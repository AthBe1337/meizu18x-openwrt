include $(TOPDIR)/rules.mk

PKG_NAME:=m2172-firmware
PKG_VERSION:=2026.05.31
PKG_RELEASE:=2

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/meizu-m2172-mainline/firmware.git
PKG_SOURCE_VERSION:=9a5c1be31b5047487f363f3da42e44fa10006e3c
PKG_MIRROR_HASH:=965eae35f48350565e87bf76e2ec9fe6289f5a12cce97f6c4a7aac3123eb792e
PKG_LICENSE:=Proprietary
PKGARCH:=all

include $(INCLUDE_DIR)/package.mk

RSTRIP:=:

define Package/m2172-firmware
  SECTION:=firmware
  CATEGORY:=Firmware
  TITLE:=Firmware for mainline Linux on Meizu 18X
endef

define Build/Compile
endef

define Package/m2172-firmware/install
	$(INSTALL_DIR) $(1)/lib/firmware
	$(CP) $(PKG_BUILD_DIR)/firmware/. $(1)/lib/firmware/
endef

$(eval $(call BuildPackage,m2172-firmware))
