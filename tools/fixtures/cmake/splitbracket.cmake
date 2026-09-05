if(NOT DEFINED CMAKE_OSX_SYSROOT)
  message(FATAL_ERROR "Could not detect iOS SDK")
endif()
message(
  [[FATAL_ERROR]] "the mode is a bracket argument on its own line")
