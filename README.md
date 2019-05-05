# How to use meta-swi-qemu
1. git clone the main swi layer.
2. in meta-swi, git clone meta-swi-qemu layer.
3. make dev_src at 1st time to initialize the env,  after step 4,  run ". ./oe-init-build-env  ../build_src/" under poky for future new shell build.
4. run "bitbake-layers add-layer ../meta-swi/meta-swi-qemu/ " and update MACHINE to "swi-sdxprairie-qemu" in local.conf.
