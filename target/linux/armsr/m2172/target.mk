ARCH:=aarch64
SUBTARGET:=m2172
BOARDNAME:=Meizu 18X (m2172)
CPU_TYPE:=generic

# This subtarget is built from the pinned m2172 mainline repository.  Keep
# armsr's generic armv7/armv8 subtargets on their normal 6.12 kernel.
KERNEL_PATCHVER:=7.1
KERNELNAME:=Image.gz dtbs
# APK accepts numeric VCS suffixes; this is the pinned commit timestamp.
LINUX_PACKAGE_VERSION:=7.1.0_git1781463551

define Target/Description
  Build the Linux 7.1 kernel, modules, root filesystem and Android boot image
  for the Meizu 18X (m2172).
endef
