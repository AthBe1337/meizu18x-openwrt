include $(TOPDIR)/rules.mk

PKG_NAME:=tqftpserv
PKG_VERSION:=1.1.1
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/meizu-m2172-mainline/tqftpserv.git
PKG_SOURCE_VERSION:=43ecec1b5dcf28fdf06fd5dc5c1b37686a9384a4
PKG_MIRROR_HASH:=skip

PKG_LICENSE:=BSD-3-Clause
PKG_LICENSE_FILES:=LICENSE
PKG_BUILD_FLAGS:=gc-sections

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/meson.mk

define Package/tqftpserv
  SECTION:=net
  CATEGORY:=Network
  TITLE:=QRTR TFTP server for the Meizu 18X modem
  URL:=https://github.com/meizu-m2172-mainline/tqftpserv
  DEPENDS:=+libqrtr +libzstd
endef

MESON_ARGS += -Dsystemd-unit-prefix=no

define Package/tqftpserv/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/tqftpserv $(1)/usr/bin/
	$(INSTALL_BIN) ./files/tqftpserv.init $(1)/etc/init.d/tqftpserv
endef

$(eval $(call BuildPackage,tqftpserv))
