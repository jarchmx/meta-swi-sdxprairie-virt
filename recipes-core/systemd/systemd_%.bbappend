do_install_append () {
   rm -f ${D}/etc/systemd/system/systemd-journald.service
   rm -f ${D}${systemd_unitdir}/system/sysinit.target.wants/systemd-journal-flush.service
   rm -f ${D}${systemd_unitdir}/system/sysinit.target.wants/systemd-journal-catalog-update.service
}
