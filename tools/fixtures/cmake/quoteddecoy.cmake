if(NOT DEFINED CMAKE_OSX_SYSROOT)
  message(FATAL_ERROR "Could not detect iOS SDK")
endif()
message("FATAL_ERROR is a mode name and this line prints")
