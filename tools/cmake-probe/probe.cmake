# Load a copy of iOS-Initialize.cmake and exit non-zero when a FATAL_ERROR call
# in it is still live. A regex reads one line at a time, so a call spread over
# several lines or reached through a variable is visible only to cmake itself.
#
# MODULE has to be a copy outside the cmake install. In place, the module's own
# include resolves to the real Darwin-Initialize, which writes a working SDK
# path and makes the load pass whatever the module says.
if(NOT DEFINED STUB OR NOT DEFINED MODULE)
  message(FATAL_ERROR "PROBE BROKEN: pass -DSTUB=<dir> and -DMODULE=<file>")
endif()

set(SENTINEL "/definitely-not-an-sdk")
list(PREPEND CMAKE_MODULE_PATH "${STUB}")
set(_CMAKE_OSX_SYSROOT_PATH "${SENTINEL}")
include("${MODULE}")

# The sentinel is what makes the SDK test fail, so a load that replaced it read
# a real SDK and says nothing about the module.
if(NOT _CMAKE_OSX_SYSROOT_PATH STREQUAL "${SENTINEL}")
  message(FATAL_ERROR "PROBE BROKEN: the load reached a real SDK at ${_CMAKE_OSX_SYSROOT_PATH}")
endif()
