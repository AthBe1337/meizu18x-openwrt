# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2017 Yousong Zhou <yszhou4tech@gmail.com>

include $(TOPDIR)/rules.mk

BOARD:=armsr
BOARDNAME:=Arm SystemReady (EFI) compliant
FEATURES:=fpu pci pcie rtc usb boot-part rootfs-part
FEATURES+=cpiogz ext4 ramdisk squashfs targz vmdk

KERNEL_PATCHVER:=6.12
include $(INCLUDE_DIR)/target.mk

ifeq ($(SUBTARGET),m2172)
# The m2172 config is a complete, boot-tested kernel configuration.  Do not
# apply OpenWrt's CONFIG_KERNEL_* defaults or package-generated Kconfig
# overrides: both are intended for OpenWrt-maintained kernel fragments and can
# silently turn required built-ins off or change modules into built-ins.
define Kernel/Configure
	rm -f $(LINUX_DIR)/localversion \
		$(LINUX_DIR)/.config.target $(LINUX_DIR)/.config.override
	cp $(LINUX_SUBTARGET_CONFIG) $(LINUX_DIR)/.config
	$(_SINGLE)$(KERNEL_MAKE) olddefconfig
	cp $(LINUX_DIR)/.config $(LINUX_DIR)/.config.prev
	cp $(LINUX_DIR)/.config $(LINUX_DIR)/.config.set
	rm -rf $(KERNEL_BUILD_DIR)/modules
	$(_SINGLE) [ -d $(LINUX_DIR)/user_headers ] || \
		$(KERNEL_MAKE) INSTALL_HDR_PATH=$(LINUX_DIR)/user_headers headers_install
	grep '=[ym]' $(LINUX_DIR)/.config | LC_ALL=C sort | \
		$(MKHASH) md5 > $(LINUX_DIR)/.vermagic
endef
endif

DEFAULT_PACKAGES += mkf2fs e2fsprogs
# blkid used for resolving PARTUUID
# in sysupgrade. vfat required for
# mounting ESP partition
DEFAULT_PACKAGES += blkid

$(eval $(call BuildTarget))
