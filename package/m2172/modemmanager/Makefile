include $(TOPDIR)/rules.mk

PKG_NAME:=modemmanager
PKG_VERSION:=1.24.2
PKG_RELEASE:=7

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/meizu-m2172-mainline/ModemManager.git
PKG_SOURCE_VERSION:=e43081e320521586a127decf004c7e1339e01038
PKG_MIRROR_HASH:=598e24fa01ba729596c31caeda075f507137cc5bbc6b4c6435bd0de2c6d27e79

PKG_LICENSE:=GPL-2.0-or-later
PKG_LICENSE_FILES:=COPYING
PKG_BUILD_DEPENDS:=glib2/host libxslt/host
PKG_BUILD_FLAGS:=gc-sections

MODEMMANAGER_OPENWRT_FILES:=$(TOPDIR)/feeds/packages/net/modemmanager/files

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk
include $(INCLUDE_DIR)/meson.mk

TARGET_CFLAGS += -fno-merge-all-constants -fmerge-constants

define Package/modemmanager/config
  source "$(SOURCE)/Config.in"
endef

define Package/modemmanager
  SECTION:=net
  CATEGORY:=Network
  TITLE:=M2172-patched ModemManager
  URL:=https://github.com/meizu-m2172-mainline/ModemManager
  DEPENDS:= \
	$(INTL_DEPENDS) \
	+glib2 \
	+dbus \
	+MODEMMANAGER_WITH_MBIM:libmbim \
	+MODEMMANAGER_WITH_QMI:libqmi \
	+MODEMMANAGER_WITH_QRTR:libqrtr-glib
endef

MESON_ARGS += \
	-Dudev=false \
	-Dudevdir=/lib/udev \
	-Dexamples=false \
	-Dtests=false \
	-Dsystemdsystemunitdir=no \
	-Dsystemd_suspend_resume=false \
	-Dsystemd_journal=false \
	-Dpolkit=no \
	-Dintrospection=false \
	-Dman=false \
	-Dbash_completion=false \
	-Dbuiltin_plugins=true \
	-Db_lto=true \
	-Dmbim=$(if $(CONFIG_MODEMMANAGER_WITH_MBIM),true,false) \
	-Dqmi=$(if $(CONFIG_MODEMMANAGER_WITH_QMI),true,false) \
	-Dqrtr=$(if $(CONFIG_MODEMMANAGER_WITH_QRTR),true,false) \
	-Dat_command_via_dbus=$(if $(CONFIG_MODEMMANAGER_WITH_AT_COMMAND_VIA_DBUS),true,false)

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/ModemManager $(1)/usr/include/libmm-glib
	$(CP) $(PKG_INSTALL_DIR)/usr/include/ModemManager/*.h $(1)/usr/include/ModemManager/
	$(CP) $(PKG_INSTALL_DIR)/usr/include/libmm-glib/*.h $(1)/usr/include/libmm-glib/
	$(INSTALL_DIR) $(1)/usr/lib $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libmm-glib.so* $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/ModemManager.pc $(1)/usr/lib/pkgconfig/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/mm-glib.pc $(1)/usr/lib/pkgconfig/
endef

define Package/modemmanager/install
	$(INSTALL_DIR) $(1)/lib/udev/rules.d
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/lib/udev/rules.d/*.rules $(1)/lib/udev/rules.d/
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/ModemManager $(1)/usr/sbin/
	$(INSTALL_BIN) ./files/usr/sbin/ModemManager-wrapper $(1)/usr/sbin/
	$(INSTALL_BIN) $(MODEMMANAGER_OPENWRT_FILES)/usr/sbin/ModemManager-monitor $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/mmcli $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libmm-glib.so.* $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/lib/ModemManager/connection.d
	$(INSTALL_BIN) $(MODEMMANAGER_OPENWRT_FILES)/usr/lib/ModemManager/connection.d/10-report-down \
		$(1)/usr/lib/ModemManager/connection.d/
	$(INSTALL_DIR) $(1)/etc/dbus-1/system.d
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/etc/dbus-1/system.d/org.freedesktop.ModemManager1.conf \
		$(1)/etc/dbus-1/system.d/
	$(INSTALL_DIR) $(1)/usr/share/dbus-1/system-services
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/share/dbus-1/system-services/org.freedesktop.ModemManager1.service \
		$(1)/usr/share/dbus-1/system-services/
	$(INSTALL_DIR) $(1)/usr/share/ModemManager
	$$(if $$(wildcard $(PKG_INSTALL_DIR)/usr/share/ModemManager/*.conf),\
		$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/share/ModemManager/*.conf $(1)/usr/share/ModemManager/,)
	$(INSTALL_DATA) $(MODEMMANAGER_OPENWRT_FILES)/usr/share/ModemManager/modemmanager.common \
		$(1)/usr/share/ModemManager/
	$(INSTALL_DIR) $(1)/usr/share/ModemManager/fcc-unlock.available.d
	$$(if $$(wildcard $(PKG_INSTALL_DIR)/usr/share/ModemManager/fcc-unlock.available.d/*),\
		$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/share/ModemManager/fcc-unlock.available.d/* \
		$(1)/usr/share/ModemManager/fcc-unlock.available.d/,)
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(MODEMMANAGER_OPENWRT_FILES)/etc/init.d/modemmanager $(1)/etc/init.d/
	$(INSTALL_DIR) $(1)/etc/hotplug.d/net $(1)/etc/hotplug.d/tty $(1)/etc/hotplug.d/wwan
	$(INSTALL_DATA) $(MODEMMANAGER_OPENWRT_FILES)/etc/hotplug.d/net/25-modemmanager-net $(1)/etc/hotplug.d/net/
	$(INSTALL_DATA) $(MODEMMANAGER_OPENWRT_FILES)/etc/hotplug.d/tty/25-modemmanager-tty $(1)/etc/hotplug.d/tty/
	$(INSTALL_DATA) $(MODEMMANAGER_OPENWRT_FILES)/etc/hotplug.d/wwan/25-modemmanager-wwan $(1)/etc/hotplug.d/wwan/
ifeq ($(CONFIG_MODEMMANAGER_WITH_NETIFD),y)
	$(INSTALL_DIR) $(1)/lib/netifd/proto
	$(INSTALL_BIN) $(MODEMMANAGER_OPENWRT_FILES)/lib/netifd/proto/modemmanager.sh $(1)/lib/netifd/proto/
endif
endef

$(eval $(call BuildPackage,modemmanager))
