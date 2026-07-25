# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2016-2017 Yousong Zhou <yszhou4tech@gmail.com>

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

GRUB2_VARIANT =
GRUB_TERMINALS =
GRUB_SERIAL_CONFIG =
GRUB_TERMINAL_CONFIG =
GRUB_CONSOLE_CMDLINE = earlycon

ifneq ($(CONFIG_GRUB_CONSOLE),)
  GRUB_TERMINALS += console
endif

GRUB_SERIAL:=$(call qstrip,$(CONFIG_TARGET_SERIAL))

GRUB_SERIAL_CONFIG := serial --unit=0 --speed=$(CONFIG_GRUB_BAUDRATE) --word=8 --parity=no --stop=1 --rtscts=$(if $(CONFIG_GRUB_FLOWCONTROL),on,off)
GRUB_TERMINALS += serial

GRUB_TERMINAL_CONFIG := terminal_input $(GRUB_TERMINALS); terminal_output $(GRUB_TERMINALS)

ROOTPART:=$(call qstrip,$(CONFIG_TARGET_ROOTFS_PARTNAME))
ROOTPART:=$(if $(ROOTPART),$(ROOTPART),PARTUUID=$(IMG_PART_SIGNATURE)-02)
GPT_ROOTPART:=$(call qstrip,$(CONFIG_TARGET_ROOTFS_PARTNAME))
GPT_ROOTPART:=$(if $(GPT_ROOTPART),$(GPT_ROOTPART),PARTUUID=$(shell echo $(IMG_PART_DISKGUID) | sed 's/00$$/02/'))

GRUB_TIMEOUT:=$(call qstrip,$(CONFIG_GRUB_TIMEOUT))
GRUB_TITLE:=$(call qstrip,$(CONFIG_GRUB_TITLE))

BOOTOPTS:=$(call qstrip,$(CONFIG_GRUB_BOOTOPTS))

define Build/combined
  $(INSTALL_DIR) $@.boot/
	$(CP) $(KDIR)/$(KERNEL_NAME) $@.boot/efi/openwrt/
	-$(CP) $(STAGING_DIR_ROOT)/boot/. $@.boot/boot/
	$(if $(filter $(1),efi),
		$(INSTALL_DIR) $@.boot/efi/boot
		$(CP) $(STAGING_DIR_IMAGE)/grub2/boot$(if $(CONFIG_aarch64),aa64,arm).efi $@.boot/efi/openwrt/
		$(CP) $(STAGING_DIR_IMAGE)/grub2/boot$(if $(CONFIG_aarch64),aa64,arm).efi $@.boot/efi/boot/
	)
	KERNELPARTTYPE=ef FAT_TYPE="32" PADDING="1" SIGNATURE="$(IMG_PART_SIGNATURE)" \
		$(if $(filter $(1),efi),GUID="$(IMG_PART_DISKGUID)") $(SCRIPT_DIR)/gen_image_generic.sh \
		$@ \
		$(CONFIG_TARGET_KERNEL_PARTSIZE) $@.boot \
		$(CONFIG_TARGET_ROOTFS_PARTSIZE) $(IMAGE_ROOTFS) \
		256
endef

define Build/grub-config
	rm -fR $@.boot
	$(INSTALL_DIR) $@.boot/efi/openwrt/
	sed \
		-e 's#@SERIAL_CONFIG@#$(strip $(GRUB_SERIAL_CONFIG))#g' \
		-e 's#@TERMINAL_CONFIG@#$(strip $(GRUB_TERMINAL_CONFIG))#g' \
		-e 's#@ROOTPART@#root=$(ROOTPART) rootwait#g' \
		-e 's#@GPT_ROOTPART@#root=$(GPT_ROOTPART) rootwait#g' \
		-e 's#@CMDLINE@#$(BOOTOPTS) $(GRUB_CONSOLE_CMDLINE)#g' \
		-e 's#@TIMEOUT@#$(GRUB_TIMEOUT)#g' \
		-e 's#@TITLE@#$(GRUB_TITLE)#g' \
		-e 's#@KERNEL_NAME@#$(KERNEL_NAME)#g' \
		./grub-$(1).cfg > $@.boot/efi/openwrt/grub.cfg
endef

define Build/grub-install
	rm -fR $@.grub2
	$(INSTALL_DIR) $@.grub2
endef

DEVICE_VARS += GRUB2_VARIANT UBOOT
define Device/efi-default
  IMAGE/rootfs.img := append-rootfs | pad-to $(ROOTFS_PARTSIZE)
  IMAGE/rootfs.img.gz := append-rootfs | pad-to $(ROOTFS_PARTSIZE) | gzip
  IMAGE/combined-efi.img := grub-config efi | combined efi | grub-install efi | append-metadata
  IMAGE/combined-efi.img.gz := grub-config efi | combined efi | grub-install efi | gzip | append-metadata
  IMAGE/combined-efi.vmdk := grub-config efi | combined efi | grub-install efi | qemu-image vmdk
 ifeq ($(CONFIG_TARGET_IMAGES_GZIP),y)
    IMAGES-y := rootfs.img.gz
    IMAGES-y += combined-efi.img.gz
  else
    IMAGES-y := rootfs.img
    IMAGES-y += combined-efi.img
  endif
  ifeq ($(CONFIG_VMDK_IMAGES),y)
    IMAGES-y += combined-efi.vmdk
  endif
  KERNEL := kernel-bin
  KERNEL_INSTALL := 1
  IMAGES := $$(IMAGES-y)
  ARTIFACTS := $$(ARTIFACTS-y)
  SUPPORTED_DEVICES :=
 ifeq ($(CONFIG_arm),y)
  KERNEL_NAME = zImage
 endif
endef

define Device/generic
  $(call Device/efi-default)
  DEVICE_TITLE := Generic EFI Boot
  GRUB2_VARIANT := generic
  FILESYSTEMS := ext4 squashfs
  UBOOT := $(if $(CONFIG_aarch64),qemu_armv8,qemu_armv7)
  DEVICE_PACKAGES += kmod-fs-vfat \
	kmod-amazon-ena kmod-e1000e kmod-vmxnet3 kmod-rtc-rx8025 \
	kmod-i2c-mux-pca954x kmod-gpio-pca953x partx-utils kmod-wdt-sp805 \
	kmod-mvneta kmod-mvpp2 kmod-fsl-dpaa1-net kmod-fsl-dpaa2-net \
	kmod-fsl-enetc-net kmod-dwmac-imx kmod-fsl-fec \
	kmod-dwmac-rockchip kmod-dwmac-sun8i kmod-phy-aquantia kmod-phy-broadcom \
	kmod-phy-marvell kmod-phy-marvell-10g kmod-sfp kmod-atlantic \
	kmod-bcmgenet kmod-octeontx2-net kmod-renesas-net-avb \
	kmod-phy-realtek kmod-phy-smsc $(if $(CONFIG_aarch64),kmod-thunderx-net)
endef
ifneq ($(SUBTARGET),m2172)
TARGET_DEVICES += generic
endif

define Build/m2172-check-build-inputs
	@if [ "$(call qstrip,$(CONFIG_KERNEL_GIT_CLONE_URI))" != \
		"https://github.com/meizu-m2172-mainline/linux.git" ]; then \
		echo 'ERROR: meizu_m2172 requires the meizu-m2172-mainline HTTPS kernel repository' >&2; \
		exit 1; \
	fi
	@if [ "$(call qstrip,$(CONFIG_KERNEL_GIT_REF))" != \
		"8afab201fb9812de7da2144e68e53f08394a8a1b" ]; then \
		echo 'ERROR: meizu_m2172 requires the pinned kernel commit 8afab201fb9812de7da2144e68e53f08394a8a1b' >&2; \
		exit 1; \
	fi
	@if ! grep -q '^CONFIG_PACKAGE_m2172-kernel-modules=y$$' $(TOPDIR)/.config; then \
		echo 'ERROR: meizu_m2172 requires m2172-kernel-modules' >&2; \
		exit 1; \
	fi
	@if grep -E '^CONFIG_PACKAGE_.*(firmware|microcode).*=y$$' $(TOPDIR)/.config | \
		grep -Ev '^CONFIG_PACKAGE_m2172-firmware=y$$' | grep -q .; then \
		echo 'ERROR: meizu_m2172 must use only m2172-firmware:' >&2; \
		grep -E '^CONFIG_PACKAGE_.*(firmware|microcode).*=y$$' $(TOPDIR)/.config | \
			grep -Ev '^CONFIG_PACKAGE_m2172-firmware=y$$' >&2; \
		exit 1; \
	fi
endef

M2172_MKBOOTIMG:=mkbootimg
M2172_IMG2SIMG:=img2simg
M2172_BOOT_RAMDISK:=$(STAGING_DIR)/usr/share/m2172/initrd.cpio.gz
M2172_DTB:=$(LINUX_DIR)/arch/arm64/boot/dts/qcom/sm8250-meizu-m2172-rm692e5.dtb
M2172_BOOT_MAX_SIZE:=16777216

define Build/m2172-android-boot
	command -v $(M2172_MKBOOTIMG)
	test -f $(KDIR)/Image.gz
	test -f $(M2172_DTB)
	test -f $(M2172_BOOT_RAMDISK)
	cat $(KDIR)/Image.gz $(M2172_DTB) > $@.kernel-dtb
	$(M2172_MKBOOTIMG) \
		--base 0x00000000 \
		--kernel_offset 0x00008000 \
		--ramdisk_offset 0x01000000 \
		--tags_offset 0x00000100 \
		--pagesize 4096 \
		--second_offset 0x00000000 \
		--ramdisk $(M2172_BOOT_RAMDISK) \
		--cmdline "console=tty0,115200n8 earlycon=tty0 earlyprintk root=/dev/sda17 rootfstype=ext4 rootwait=10 loglevel=3 debug rw" \
		--kernel $@.kernel-dtb \
		-o $@
	rm -f $@.kernel-dtb
	@test "$$(stat -c %s $@)" -le "$(M2172_BOOT_MAX_SIZE)" || { \
		echo "ERROR: Android boot image exceeds $(M2172_BOOT_MAX_SIZE) bytes: $$(stat -c %s $@)" >&2; \
		exit 1; \
	}
endef

define Build/m2172-fsck-ext4
	status=0; \
		$(STAGING_DIR_HOST)/bin/e2fsck -pDf $@ || status=$$?; \
		test "$$status" -le 1
endef

define Build/m2172-img2simg
	command -v $(M2172_IMG2SIMG)
	test -f $(BIN_DIR)/$(DEVICE_IMG_PREFIX)-ext4-rootfs.img
	$(M2172_IMG2SIMG) \
		$(BIN_DIR)/$(DEVICE_IMG_PREFIX)-ext4-rootfs.img \
		$@
endef

# Linux, modules and Android boot image for the Meizu 18X pinned mainline
# kernel.  m2172-kernel-modules installs every module produced by this tree;
# selected OpenWrt kmod packages are empty dependency markers.
define Device/meizu_m2172
  DEVICE_VENDOR := Meizu
  DEVICE_MODEL := 18X
  DEVICE_VARIANT := m2172 mainline
  DEVICE_PACKAGES :=
  FILESYSTEMS := ext4
  IMAGE/rootfs.img := m2172-check-build-inputs | append-rootfs | m2172-fsck-ext4
  IMAGE/boot.img := m2172-check-build-inputs | m2172-android-boot
  IMAGES := rootfs.img boot.img
  ARTIFACTS := ext4-rootfs.simg
  ARTIFACT/ext4-rootfs.simg := m2172-img2simg
  KERNEL := kernel-bin
  KERNEL_INSTALL := 1
  SUPPORTED_DEVICES :=
endef
ifeq ($(SUBTARGET),m2172)
TARGET_DEVICES += meizu_m2172
endif

$(eval $(call BuildImage))
