#Jarch Hu
#Belowing val must be defined
#SRCGIT = "git@xxx.xxx.xxx.xxx:xxx/xxx.git"

SRCBRANCH ?= ""
KMETA = ""
KBRANCH = "${SRCBRANCH}"
SRCREV ?= "${AUTOREV}"

python () {
    import re

    #d.setVar('WORKDIR', d.getVar('TOPDIR', True) + "/" + "targets" + "/" +
    #    d.getVar('PN', True))
    #d.setVar('S', d.getVar('WORKDIR', True) + "/" + "git" )
}

do_clean_git() {
    cd ${DL_DIR}
    temp=`echo ${SRCGIT} | tr -s /:- _`
    if [ -d git2/${temp} -o -e git2/${temp}.done ]; then
        rm -rf ./git2/${temp}*
    fi
}

addtask clean_git before do_cleanall after do_clean

do_fetch() {
    mkdir -p git2
    temp=`echo ${SRCGIT} | tr -s /:- _`
    cd git2
    if [ ! -e ./${temp}.done ]; then
        rm -rf ./${temp}
        git clone --bare ${SRCGIT} ${temp}
        touch ./${temp}.done
    fi
}

do_unpack() {
    cd ${WORKDIR}
    temp=`echo ${SRCGIT} | tr -s /:- _`
    if [ -z ${S} ]; then
        return 1
    fi
	if [ ! -d ${S}/.git ];then
	   git clone file://${DL_DIR}/git2/${temp} ${S}
	fi
    
    cd ${S} &&git remote set-url origin ${SRCGIT}
    if [ ! -z ${SRCREV} ];then
	   cd ${S} && git checkout ${SRCREV} 
    elif [ ! -z ${SRCBRANCH} ];then
       cd ${S} && git checkout ${SRCBRANCH} && git pull
    else
       cd ${S} && git checkout ${master} && git pull
    fi
}

python do_unpack_extra() {
    src_uri = (d.getVar('SRC_URI', True) or "").split()
    if len(src_uri) == 0:
        return

    rootdir = d.getVar('WORKDIR', True)

    # Ensure that we cleanup ${S}/patches
    # TODO: Investigate if we can remove
    # the entire ${S} in this case.
    s_dir = d.getVar('S', True)
    p_dir = os.path.join(s_dir, 'patches')
    bb.utils.remove(p_dir, True)

    try:
        fetcher = bb.fetch2.Fetch(src_uri, d)
        fetcher.unpack(rootdir)
    except bb.fetch2.BBFetchException as e:
        raise bb.build.FuncFailed(e)

    #if not os.path.exists(s_dir):
    #    bb.warn("%s ('S') doesn't exist, please set 'S' to a proper value" % s_dir)
}
addtask unpack_extra before do_unpack after do_fetch
