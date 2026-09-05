if(NOT DEFINED CMAKE_OSX_SYSROOT)
  message(FATAL_ERROR "Could not detect iOS SDK")
endif()
set(_modes
    FATAL_ERROR_IF_MISSING)
