#IMAGE_INSTALL_remove = "data diag dsutils glib-2.0 qmi qmi-framework xmllib pugixml data-oss"
#IMAGE_INSTALL_remove = "qmi-client-helper libcap configdb"
#IMAGE_INSTALL_remove = "loc-externaldrcore loc-epdr loc-hal loc-api-v02 loc-net-iface location-api gps-utils location-hal-daemon location-client-api start-scripts-qseecomd-daemon start-scripts-sfs-config securemsm securemsm-noship   qmi-simple-ril data-items  embms-kernel start-scripts-ipa-fws ipa-fws mbim data-module atfwd-daemon diag-reboot-app qmi-shutdown-modem"
#IMAGE_INSTALL_remove = "edk2  init-mss reboot-daemon  data-ipa-cfg-mgr  nmea-test-app xtra-daemon izat-client-api lowi-server lowi-test xtwifi-client xtwifi-inet-agent engine-plugin engine-simulator"
#IMAGE_INSTALL_remove = "izat-core lbs-core"


#IMAGE_INSTALL_remove = "data garden-app izat-core lbs-core loc-glue loc-net-iface location-client-api location-flp location-geofence location-hal-daemon location-service machine-image miniupnpd"
#IMAGE_INSTALL_remove = "system-core libion data-ipa-cfg-mgr edk2 llvm-arm-toolchain-native libion ebtables loc-externaldrcore alx data qmi qmi-framework qmi-client-helper configdb xtwifi-client"
#IMAGE_INSTALL_remove = "emac-dwc-eqos pimd gsb sfe dsutils data-oss lowi-server loc-externaldrcore lowi-test data-items xtwifi-inet-agent lowi-client engine-simulator asn1c-rtx xmllib asn1c-crt asn1c-cper"
#IMAGE_INSTALL_remove = "securemsm securemsm-noship loc-eng-hub loc-epdr xtra-daemon engine-plugin gdtap-adapter izat-client-api rtsp-alg atfwd-daemon diag-reboot-app mbim nmea-test-app qmi-shutdown-modem qmi-simple-ril"
#IMAGE_INSTALL_remove = "slim-common slim-client slim-utils time-services data-module loc-api-v02"

#IMAGE_INSTALL_remove = "gsb"
#IMAGE_INSTALL_append = " systemd"
#do_makesystem() {
#    echo fake do_makesystem
#}

determine_kernel_versions() {
    cd "${IMGDEPLOYDIR}"

    if [ ! -e "${IMAGE_MANIFEST}" ]; then
        echo "Image manifest does not exist."
        exit 1
    fi

    # Retreive generic version name from manifest
    VERSION_kernel_image=$(grep -e '^kernel' "${IMAGE_MANIFEST}" | grep -v 'module' \
                                                                 | awk '{print $3}' \
                                                                 | sed 's/-r[0-9]*$//' \
                                                                 | head -1)

    # linux-yocto
    if [[ "${PREFERRED_PROVIDER_virtual/kernel}" == "linux-yocto" ]]; then
        kernel_versions=$(echo "${VERSION_kernel_image}" | grep -Po '\+([\w]{6,})_([\w]{6,})' | sed 's/[+_]/ /g')
        kernel_meta_rev=$(echo $kernel_versions |awk '{print $1}')
        kernel_machine_rev=$(echo $kernel_versions |awk '{print $2}')
        VERSION_kernel_meta="$kernel_meta_rev"
        VERSION_kernel_machine="$kernel_machine_rev"
        VERSION_kernel=$(echo ${PREFERRED_VERSION_linux-yocto} | sed 's/%//g')

    # linux-quic
    elif [[ "${PREFERRED_PROVIDER_virtual/kernel}" == "linux-quic" ]]; then
        VERSION_kernel=$(echo ${PREFERRED_VERSION_linux-quic} | sed 's/%//g')

    # linux-msm
    elif [[ "${PREFERRED_PROVIDER_virtual/kernel}" == "linux-msm" ]]; then
        VERSION_kernel=$(echo ${PREFERRED_VERSION_linux-msm} | sed 's/%//g')
    elif [[ "${PREFERRED_PROVIDER_virtual/kernel}" == "linux-msm-vexpress" ]]; then
        VERSION_kernel=$(echo ${PREFERRED_VERSION_linux-msm} | sed 's/%//g')
    fi

    if [ -z "$VERSION_kernel" ]; then
        echo "Unable to determine kernel version"
        exit 1
    fi
}

do_generate_cwe[noexec] = "1"
