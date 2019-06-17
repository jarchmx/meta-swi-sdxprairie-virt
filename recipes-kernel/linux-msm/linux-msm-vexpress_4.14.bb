#require recipes-kernel/linux-msm/linux-msm_4.14.bb
inherit kernel kernel-yocto


DESCRIPTION = "CAF Linux Kernel"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

KBRANCH ?= ""
KMETA = "kernel-meta"
KMACHINE ?= "${MACHINE}"
KCONFIG_MODE = "--alldefconfig"
KBUILD_DEFCONFIG ?= "${KERNEL_CONFIG}"
LINUX_VERSION_EXTENSION = "${@['-perf', ''][d.getVar('VARIANT', True) == ('' or 'debug')]}"

do_kernel_checkout[noexec] = "1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI = "file://defconfig \
           file://0001-Fixed-build-issue-and-crashed-issue.patch "

COMPATIBLE_MACHINE_swi-sdxprairie-qemu = "swi-sdxprairie-qemu|swi-sdx55-qemu"
KERNEL_DEVICETREE_swi-sdxprairie-qemu = "vexpress-v2p-ca9.dtb"
KERNEL_DEVICETREE_swi-sdx55-qemu = "vexpress-v2p-ca9.dtb"

DEPENDS_remove = "llvm-arm-toolchain-native"

#KERNEL_EXTRA_ARGS        += "V=1"

inherit ssh-git-kernel

SRCBRANCH = "sdx55le10-swi-em"
SRCREV = ""

SRCGIT = "git://cnshz-er-git01/external/privcaf/external/private_le/kernel/msm-4.14"

do_deploy_append() {
    install -m 0644 ${D}/${KERNEL_IMAGEDEST}/${KERNEL_IMAGETYPE}-${KERNEL_VERSION} ${DEPLOY_DIR_IMAGE}/
}

do_shared_workdir_append () {
        cp Makefile $kerneldir/
        cp -fR usr $kerneldir/

        cp include/config/auto.conf $kerneldir/include/config/auto.conf

        if [ -d arch/${ARCH}/include ]; then
                mkdir -p $kerneldir/arch/${ARCH}/include/
                cp -fR arch/${ARCH}/include/* $kerneldir/arch/${ARCH}/include/
        fi

        if [ -d arch/${ARCH}/boot ]; then
                mkdir -p $kerneldir/arch/${ARCH}/boot/
                cp -fR arch/${ARCH}/boot/* $kerneldir/arch/${ARCH}/boot/
        fi

        if [ -d scripts ]; then
            for i in \
                scripts/basic/bin2c \
                scripts/basic/fixdep \
                scripts/conmakehash \
                scripts/dtc/dtc \
                scripts/kallsyms \
                scripts/kconfig/conf \
                scripts/mod/mk_elfconfig \
                scripts/mod/modpost \
                scripts/recordmcount \
                scripts/sign-file \
                scripts/sortextable;
            do
                if [ -e $i ]; then
                    mkdir -p $kerneldir/`dirname $i`
                    cp $i $kerneldir/$i
                fi
            done
        fi

        cp ${STAGING_KERNEL_DIR}/scripts/gen_initramfs_list.sh $kerneldir/scripts/

        # Copy vmlinux and zImage into deplydir for boot.img creation
        install -m 0644 ${KERNEL_OUTPUT_DIR}/${KERNEL_IMAGETYPE} ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}
        install -m 0644 vmlinux ${DEPLOY_DIR_IMAGE}

        # Generate kernel headers
        oe_runmake_call -C ${STAGING_KERNEL_DIR} ARCH=${ARCH} CC="${KERNEL_CC}" LD="${KERNEL_LD}" headers_install O=${STAGING_KERNEL_BUILDDIR}
}

deltask do_bootimg
