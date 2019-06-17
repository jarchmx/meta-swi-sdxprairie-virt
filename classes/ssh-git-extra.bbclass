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
    temp=`echo ${SRCGIT} | sed -e 's/\:/_/g' -e 's/\//_/g' -e 's/\-/_/g'`
    if [ -d git2/${temp} -o -e git2/${temp}.done ]; then
        rm -rf ./git2/${temp}*
    fi
}

addtask clean_git before do_cleanall after do_clean

do_fetch() {
    mkdir -p git2
    temp=`echo ${SRCGIT} | sed -e 's/\:/_/g' -e 's/\//_/g' -e 's/\-/_/g'`
    cd git2
    if [ ! -e ./${temp}.done ]; then
        rm -rf ./${temp}
        git clone --bare ${SRCGIT} ${temp}
        touch ./${temp}.done
    fi
}

python do_unpack() {
    src_git = d.getVar('SRCGIT', True)
	#src_dir = d.getVar('S', True)
    src_dir = os.path.abspath(d.getVar('S'))
    work_dir = d.getVar('WORKDIR',True)
    dl_dir =  d.getVar('DL_DIR',True)

    temp = src_git.replace('/','_')
    temp = temp.replace(':','_')
    temp = temp.replace('-','_')
    dl_src = dl_dir + '/git2/' + temp 

    srcdirg = src_dir + '.git'

    srcrev = d.getVar('SRCREV',True) or d.getVar('SRCBRANCH',True) or "master"

    if not os.path.exists(srcdirg):
        os.system("cd %s && git clone %s %s" % (work_dir,dl_src,src_dir))
        os.system("cd %s && git checkout %s && git pull" % (src_dir, srcrev)) 
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
