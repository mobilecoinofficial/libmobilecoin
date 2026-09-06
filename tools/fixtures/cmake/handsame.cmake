#  message(FATAL_ERROR "hand commented, do not resurrect")
if(NOT DEFINED CMAKE_OSX_SYSROOT)
  message(FATAL_ERROR "Could not detect iOS SDK")
endif()
