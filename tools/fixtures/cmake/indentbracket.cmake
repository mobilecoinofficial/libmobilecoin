if(NOT DEFINED CMAKE_OSX_SYSROOT)
  message(FATAL_ERROR "Could not detect iOS SDK")
endif()
message([[
    FATAL_ERROR]] "the token sits inside a bracket argument")
