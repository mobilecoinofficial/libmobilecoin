if(NOT DEFINED CMAKE_OSX_SYSROOT)
  message(fatal_error "Could not detect iOS SDK")
endif()
