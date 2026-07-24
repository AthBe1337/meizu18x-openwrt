include $(TOPDIR)/rules.mk

PKG_NAME:=m2172-mark-boot-successful
PKG_VERSION:=2026.05.16
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/meizu-m2172-mainline/mark-boot-successful.git
PKG_SOURCE_VERSION:=42166bf7ed3e1d1ef90138215567d4559ae6a485
PKG_MIRROR_HASH:=skip

PKG_LICENSE:=GPL-2.0-only
PKGARCH:=all

include $(INCLUDE_DIR)/package.mk

define Package/m2172-mark-boot-successful
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Mark the active Meizu 18X A/B boot slot successful
  URL:=https://github.com/meizu-m2172-mainline/mark-boot-successful
  DEPENDS:=+bash +blkid +lsblk +sgdisk +grep +coreutils-realpath
endef

define Build/Compile
endef

define Package/m2172-mark-boot-successful/install
	$(INSTALL_DIR) $(1)/usr/local/bin $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/mark-boot-successful.sh \
		$(1)/usr/local/bin/mark-boot-successful.sh
	$(INSTALL_BIN) ./files/mark-boot-successful.init \
		$(1)/etc/init.d/mark-boot-successful
endef

$(eval $(call BuildPackage,m2172-mark-boot-successful))
