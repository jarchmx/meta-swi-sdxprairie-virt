require recipes-kernel/linux-msm/linux-msm_4.14.bb

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI = "file://defconfig \
           file://0001-Fixed-build-issue-and-crashed-issue.patch \
           file://systemd.cfg"

COMPATIBLE_MACHINE_swi-sdxprairie-qemu = "swi-sdxprairie-qemu"

DEPENDS_remove = "llvm-arm-toolchain-native"

#KERNEL_EXTRA_ARGS        += "V=1"

inherit ssh-git-kernel

SRCBRANCH = "sdx55le10-swi-em"
SRCREV = ""

SRCGIT = "git://cnshz-er-git01/external/privcaf/external/private_le/kernel/msm-4.14"

do_deploy_append() {
    install -m 0644 ${D}/${KERNEL_IMAGEDEST}/${KERNEL_IMAGETYPE}-${KERNEL_VERSION} ${DEPLOY_DIR_IMAGE}/
}
