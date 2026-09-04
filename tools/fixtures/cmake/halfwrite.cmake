if(NOT DEFINED CMAKE_OSX_SYSROOT)
  message(FATAL_ERROR "Could not detect iOS SDK")
  message(
    FATAL_ERROR "Could not detect the iOS SDK path")
endif()
