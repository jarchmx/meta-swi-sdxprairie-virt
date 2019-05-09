# How to use meta-swi-sdxprairie-virt.

#Clone and patch to support meta-swi-sdxprairie-virt for sdxprairie.

#> cd meta-swi layer: 
#> git clone this layer: https://github.com/jarchmx/meta-swi-sdxprairie-virt.git
#> patch -p1 < meta-swi-sdxprairie-virt/patches/add_meta-swi-sdxprairie-virt_support.patch

#Build the image:
#> cd to ROOT directory of yocto, run QEMU=1 make image_src to build the image.

#Run the emulator.
#> cd to poky directory of yocto.
#> run '. ./oe-init-build-env  ../build_src/' to initialize the env. 
#> runqemu to run the emulator.
