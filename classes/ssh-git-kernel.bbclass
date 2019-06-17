inherit ssh-git-extra
inherit ssh-git-nocache
inherit ssh-git-kernel-extra

#do_unpack_append() {
#	mkdir -p ${STAGING_KERNEL_DIR}
#    rm -rf ${STAGING_KERNEL_DIR} && ln -sf ${S} ${STAGING_KERNEL_DIR}
#}

#do_kernel_configme[noexec] = "1"

do_deploy[nostamp] = "1"
