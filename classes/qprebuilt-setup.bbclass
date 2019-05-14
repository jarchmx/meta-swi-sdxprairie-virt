do_setup_prebuild() {
    prebuiltdir="${WORKSPACE}/prebuilt_HY22"
    if [ -d ${WORKSPACE}/prebuilt_HY11 ]; then
        prebuiltdir="${WORKSPACE}/prebuilt_HY11"
    fi

    if [[ ${MACHINE} == "swi-sdxprairie-qemu"  && ! -d $prebuiltdir/${MACHINE}/ ]]; then
        TEMPMACH=`echo ${MACHINE} | sed 's/\-qemu//'`
        echo "Sync prebuiltdir from $prebuiltdir/$TEMPMACH/"
        cp -rf $prebuiltdir/$TEMPMACH $prebuiltdir/${MACHINE}
    fi
}
addtask setup_prebuild before do_prebuilt_install after do_populate_lic
