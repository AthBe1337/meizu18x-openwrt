include $(TOPDIR)/rules.mk

PKG_NAME:=m2172-initrd
PKG_VERSION:=2026.05.25
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/meizu-m2172-mainline/initrd.git
PKG_SOURCE_VERSION:=9d6c02230ec1cee0f78d7010833de36da6beda95
PKG_MIRROR_HASH:=d5acb0ee04aea05a7a3bf087f72fc13e4b20deee295696dc6f8611e5708e8569

PKG_LICENSE:=GPL-2.0-only
PKGARCH:=all

include $(INCLUDE_DIR)/package.mk

define Package/m2172-initrd
  SECTION:=boot
  CATEGORY:=Boot Loaders
  TITLE:=Early userspace ramdisk for Meizu 18X
  DEPENDS:=@TARGET_armsr_m2172
endef

define Build/Compile
	$(PKG_BUILD_DIR)/build.sh $(PKG_BUILD_DIR)/initrd.cpio.gz
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/share/m2172
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/initrd.cpio.gz \
		$(1)/usr/share/m2172/initrd.cpio.gz
endef

define Package/m2172-initrd/install
	$(INSTALL_DIR) $(1)/usr/share/m2172
	echo $(PKG_SOURCE_VERSION) > $(1)/usr/share/m2172/initrd.version
endef

$(eval $(call BuildPackage,m2172-initrd))
