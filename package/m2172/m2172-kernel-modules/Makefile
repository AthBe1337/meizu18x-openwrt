include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=m2172-kernel-modules
PKG_VERSION:=7.1.0
PKG_RELEASE:=15
PKG_LICENSE:=GPL-2.0-only

include $(INCLUDE_DIR)/package.mk

# Preserve the pinned kernel tree's modules, including debug information and build
# IDs.  They are compiled by target/linux before package compilation starts.
RSTRIP:=:

define Package/m2172-kernel-modules
  SECTION:=kernel
  CATEGORY:=Kernel modules
  TITLE:=Linux 7.1 modules for Meizu 18X
  DEPENDS:=@TARGET_armsr_m2172 +kmod +m2172-initrd +@DRIVER_11AC_SUPPORT +@DRIVER_11AX_SUPPORT
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Compile
	test -f $(LINUX_DIR)/modules.order
	test -f $(LINUX_DIR)/vmlinux
endef

define Package/m2172-kernel-modules/install
	+$(KERNEL_MAKE) \
		DEPMOD=/usr/sbin/depmod \
		INSTALL_MOD_PATH=$(1) \
		modules_install
	/usr/sbin/depmod -a -b $(1) $(LINUX_UNAME_VERSION)
	rm -f $(1)/lib/modules/*/build $(1)/lib/modules/*/source
	test -f $(1)/$(MODULES_SUBDIR)/modules.dep
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/usr/libexec/m2172-kmod
	ln -sf /sbin/kmod $(1)/usr/libexec/m2172-kmod/modprobe
	$(INSTALL_BIN) ./files/m2172-kmod.init $(1)/etc/init.d/m2172-kmod
	for subsystem in platform pci mhi rpmsg i2c spi slim input serio usb; do \
		$(INSTALL_DIR) $(1)/etc/hotplug.d/$$$$subsystem; \
		$(INSTALL_DATA) ./files/m2172-kmod.hotplug \
			$(1)/etc/hotplug.d/$$$$subsystem/10-m2172-kmod; \
	done
endef

$(eval $(call BuildPackage,m2172-kernel-modules))
