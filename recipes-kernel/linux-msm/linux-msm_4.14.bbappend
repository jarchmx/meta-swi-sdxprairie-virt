KERNEL_DEVICETREE_swi-sdxprairie-qemu = "versatile-pb.dtb"

#KERNEL_CONFIG = ""
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://defconfig"

do_deploy_append() {
    install -m 0644 ${D}/${KERNEL_IMAGEDEST}/${KERNEL_IMAGETYPE}-${KERNEL_VERSION} ${DEPLOY_DIR_IMAGE}/
}
