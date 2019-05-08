#KERNEL_DEVICETREE_swi-sdxprairie-qemu = "versatile-pb.dtb"

#KERNEL_CONFIG = ""
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://defconfig"
SRC_URI += "file://clk.c"

COMPATIBLE_MACHINE_swi-sdxprairie-qemu = "swi-sdxprairie-qemu"

DEPENDS_remove = "llvm-arm-toolchain-native"

do_compile () {
    oe_runmake ${KERNEL_EXTRA_ARGS} $use_alternate_initrd
}

do_deploy_append() {
    install -m 0644 ${D}/${KERNEL_IMAGEDEST}/${KERNEL_IMAGETYPE}-${KERNEL_VERSION} ${DEPLOY_DIR_IMAGE}/
}

#as swi kernel build didn't git clone the kernel, so kgit-s2q(git am) can't work.
do_patch_append() {
    cp -f ${WORKDIR}/clk.c ${S}/drivers/clk/
    sed -i 's/KBUILD_CFLAGS   := -Wall/KBUILD_CFLAGS   := /g' ${S}/Makefile
}
