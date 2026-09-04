#message(FATAL_ERROR "commented out by someone else")
if(NOT DEFINED CMAKE_OSX_SYSROOT)
  message(
    FATAL_ERROR "Could not detect iOS SDK")
endif()
