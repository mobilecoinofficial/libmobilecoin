# Stands in for the module iOS-Initialize.cmake includes first. The real one
# reads the active SDK, which would make the load depend on the machine rather
# than on the module under test.
#
# Nothing here sets _CMAKE_OSX_SYSROOT_PATH, so the value the probe wrote
# survives and the SDK test below the include reaches its message call.
