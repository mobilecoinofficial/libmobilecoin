# Stands in for the real Darwin-Initialize, which reads the active SDK and
# would make a load depend on the machine rather than on the module under test.
#
# Nothing here sets _CMAKE_OSX_SYSROOT_PATH, so the caller's value survives.
