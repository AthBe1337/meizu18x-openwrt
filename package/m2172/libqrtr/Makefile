include $(TOPDIR)/rules.mk

PKG_NAME:=libqrtr
PKG_VERSION:=1.2
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/andersson/qrtr.git
PKG_SOURCE_VERSION:=0428c6541d230cdd253bfa76cef83341e1c2d178
PKG_MIRROR_HASH:=skip

PKG_LICENSE:=BSD-3-Clause
PKG_LICENSE_FILES:=LICENSE
PKG_BUILD_FLAGS:=gc-sections

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/meson.mk

define Package/libqrtr
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=Userspace reference library for Qualcomm QRTR
  URL:=https://github.com/andersson/qrtr
endef

define Package/qrtr-tools
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Userspace tools for Qualcomm QRTR
  URL:=https://github.com/andersson/qrtr
  DEPENDS:=+libqrtr
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include $(1)/usr/lib $(1)/usr/lib/pkgconfig
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/include/libqrtr.h $(1)/usr/include/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libqrtr.so* $(1)/usr/lib/
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/qrtr.pc $(1)/usr/lib/pkgconfig/
endef

define Package/libqrtr/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libqrtr.so.* $(1)/usr/lib/
endef

define Package/qrtr-tools/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/qrtr-cfg $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/qrtr-lookup $(1)/usr/bin/
endef

$(eval $(call BuildPackage,libqrtr))
$(eval $(call BuildPackage,qrtr-tools))
