include $(TOPDIR)/rules.mk

PKG_NAME:=m2172-modem-userspace
PKG_VERSION:=2026.07.20
PKG_RELEASE:=5

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/meizu-m2172-mainline/modem-userspace.git
PKG_SOURCE_VERSION:=95d7680db119bf520af0e26dafad7ed0355c36e0
PKG_MIRROR_HASH:=skip

PKG_LICENSE:=MIT
PKGARCH:=all

include $(INCLUDE_DIR)/package.mk

define Package/m2172-modem-userspace
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Meizu 18X SDX55M modem userspace
  URL:=https://github.com/meizu-m2172-mainline/modem-userspace
  DEPENDS:=+python3-light +qmi-utils +ip-full +procps-ng-ps +coreutils-stat +modemmanager +m2172-firmware +tqftpserv
endef

define Build/Compile
endef

define Package/m2172-modem-userspace/install
	$(INSTALL_DIR) $(1)/usr/local/sbin $(1)/usr/sbin \
		$(1)/lib/udev/rules.d $(1)/etc/init.d $(1)/etc/uci-defaults
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scripts/m2172_sahara_fw_loader.py \
		$(1)/usr/local/sbin/m2172-sahara-fw-loader
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scripts/m2172-modem-bringup.sh \
		$(1)/usr/local/sbin/m2172-modem-bringup.sh
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scripts/sdx55m-data-up.sh \
		$(1)/usr/local/sbin/sdx55m-data-up.sh
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/udev/78-mm-sdx55m.rules \
		$(1)/lib/udev/rules.d/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/udev/79-mm-sdx55m-net.rules \
		$(1)/lib/udev/rules.d/
	$(INSTALL_BIN) ./files/m2172-modem.init $(1)/etc/init.d/m2172-modem
	$(INSTALL_BIN) ./files/m2172-sim-setup.sh $(1)/usr/sbin/m2172-sim-setup
	$(INSTALL_BIN) ./files/m2172-sim.init $(1)/etc/init.d/m2172-sim
	$(INSTALL_BIN) ./files/99-m2172-network $(1)/etc/uci-defaults/99-m2172-network
endef

$(eval $(call BuildPackage,m2172-modem-userspace))
