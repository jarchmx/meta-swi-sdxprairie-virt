
do_install_append() {
        rm -rf ${D}/run
        rm -rf ${D}/usr/lib/avahi
}

