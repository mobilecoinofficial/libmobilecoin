if(NOT DEFINED CMAKE_OSX_SYSROOT)
  fatal_abort("not an iOS SDK")  # was a FATAL_ERROR
endif()
