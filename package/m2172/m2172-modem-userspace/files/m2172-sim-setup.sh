#!/bin/sh

# Keep the primary GW provisioning session selected on the SDX55M.  The modem
# may come up before or after ModemManager, so this daemon also retries the
# configured cellular interface once the SIM and ModemManager are ready.

QMI_DEVICE="${QMI_DEVICE:-qrtr://3}"
WAN_INTERFACE="${WAN_INTERFACE:-wan}"
CHECK_INTERVAL="${CHECK_INTERVAL:-10}"
QMI="qmicli --silent -p -d $QMI_DEVICE"

last_sim_state=
last_wan_state=

log()
{
	logger -t m2172-sim "$*"
	printf '%s\n' "$*"
}

log_sim_state()
{
	[ "$last_sim_state" = "$1" ] && return
	last_sim_state="$1"
	shift
	log "$*"
}

log_wan_state()
{
	[ "$last_wan_state" = "$1" ] && return
	last_wan_state="$1"
	shift
	log "$*"
}

check_modem_ready()
{
	$QMI --dms-get-operating-mode >/dev/null 2>&1
}

get_sim_status()
{
	$QMI --uim-get-card-status 2>/dev/null
}

extract_sim_info()
{
	local cards="$1"
	local slot aid

	slot=$(printf '%s\n' "$cards" | awk -F'[][]' '
		/^Slot \[[0-9]+\]:/ { slot=$2 }
		/Card state: .present./ { print slot; exit }
	')

	if [ -n "$slot" ]; then
		aid=$(printf '%s\n' "$cards" | awk -v s="$slot" '
			BEGIN { capture=0 }
			$0 ~ "Slot \\[" s "\\]:" { capture=1 }
			capture && /Application ID:/ {
				getline
				gsub(/^[[:space:]]+|[[:space:]]+$/, "")
				print
				exit
			}
		')
	fi

	printf '%s %s\n' "$slot" "$aid"
}

activate_sim()
{
	local slot="$1"
	local aid="$2"

	$QMI --uim-change-provisioning-session="slot=$slot,activate=yes,session-type=primary-gw-provisioning,aid=$aid" >/dev/null
}

wan_is_active()
{
	local status

	status=$(ubus call "network.interface.$WAN_INTERFACE" status 2>/dev/null) || return 1
	[ "$(printf '%s\n' "$status" | jsonfilter -q -e '@.up' 2>/dev/null)" = true ] ||
		[ "$(printf '%s\n' "$status" | jsonfilter -q -e '@.pending' 2>/dev/null)" = true ]
}

ensure_wan()
{
	if ! mmcli --modem=qcom-soc --output-keyvalue >/dev/null 2>&1; then
		log_wan_state modem-wait "Waiting for ModemManager to expose qcom-soc"
		return
	fi
	# Do not issue another ifup while netifd is already dialing.  A duplicate
	# request in this window tears down the newly created dynamic QMAP link.
	if wan_is_active; then
		last_wan_state=up
		return
	fi

	log_wan_state retry "ModemManager is ready; requesting cellular interface '$WAN_INTERFACE'"
	ifup "$WAN_INTERFACE" >/dev/null 2>&1 || true
}

restart_modemmanager()
{
	[ -x /etc/init.d/modemmanager ] || return
	log "Restarting ModemManager after SIM activation"
	/etc/init.d/modemmanager restart >/dev/null 2>&1 || true
}

main()
{
	local cards sim_info slot aid

	trap 'log "Service stopped"; exit 0' INT TERM

	while true; do
		if ! check_modem_ready; then
			log_sim_state modem-wait "Modem is not ready; waiting"
			sleep "$CHECK_INTERVAL"
			continue
		fi

		if ! cards=$(get_sim_status); then
			log_sim_state status-failed "Unable to read SIM status; retrying"
			sleep "$CHECK_INTERVAL"
			continue
		fi

		if ! printf '%s\n' "$cards" | grep -q "Card state: 'present'"; then
			log_sim_state sim-missing "No SIM is present"
			sleep "$CHECK_INTERVAL"
			continue
		fi

		if printf '%s\n' "$cards" | grep -q "Primary GW:   session doesn't exist"; then
			sim_info=$(extract_sim_info "$cards")
			slot=${sim_info%% *}
			aid=${sim_info#* }

			if [ -z "$slot" ] || [ -z "$aid" ] || [ "$slot" = "$aid" ]; then
				log_sim_state parse-failed "Unable to extract the SIM slot or application ID"
			else
				log "Activating SIM slot $slot, application $aid"
				if activate_sim "$slot" "$aid"; then
					log "SIM provisioning session activated"
					last_sim_state=
					last_wan_state=
					restart_modemmanager
					sleep 5
				else
					log_sim_state activation-failed "SIM activation failed; retrying"
				fi
			fi
		else
			log_sim_state sim-ready "SIM provisioning session is active"
		fi

		ensure_wan
		sleep "$CHECK_INTERVAL"
	done
}

main
