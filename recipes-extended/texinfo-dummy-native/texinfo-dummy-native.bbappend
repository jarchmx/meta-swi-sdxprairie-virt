#texinfo-dummy-native is the 1st build bb, use this bb to prebuiltdircheck.
addhandler prebuiltdircheck_eventhandler
prebuiltdircheck_eventhandler[eventmask] = "bb.event.RecipeParsed"
python prebuiltdircheck_eventhandler() {
    print('prebuiltdircheck_eventhandler')
    import os
    import re
    workspace = d.getVar("WORKSPACE", True) + "/"
    machine = d.getVar("MACHINE", True)
    prebuilddir = workspace + "prebuilt_HY11/" + machine + "/"
    if not os.path.exists(prebuilddir):
        if re.search('-qemu',machine):
            npos = machine.index('-qemu')
            tempmach=machine[0:npos]
            tempprebuilddir = workspace + "prebuilt_HY11/" + tempmach + "/"
            if not os.path.exists(tempprebuilddir):
                raise_sanity_error("both %s and %s not exists." % (prebuilddir, tempprebuilddir), d)
            else:
                command = "cp -rf " + tempprebuilddir + " " + prebuilddir
                print("call %s" % command)
                os.system(command)
}
