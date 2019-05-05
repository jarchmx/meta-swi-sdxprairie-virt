inherit kernel-src-install

COMPATIBLE_MACHINE_swi-sdxprairie-qemu = "swi-sdxprairie-qemu"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://gdb.cfg"

RDEPENDS_${PN} += "kern-tools-native"

KERNEL_DEVICETREE_swi-sdxprairie-qemu = "versatile-pb.dtb"

# arm
COMPATIBLE_MACHINE_swi-virt-arm = "swi-virt-arm"

KMACHINE_swi-sdxprairie-qemu = "qemuarm"
KBRANCH_swi-sdxprairie-qemu = "${KBRANCH_qemuarm}"

SRCREV_swi-sdxprairie-qemu = "${SRCREV_machine_qemuarm}"

do_install_append() {
    kernel_src_install
}
