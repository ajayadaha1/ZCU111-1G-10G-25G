FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://bsp.cfg file://0001-Patch-for-1G-10G-25G-switching-ethernet-for-GTY-devi.patch"
KERNEL_FEATURES:append = " bsp.cfg"
