if(NOT DEFINED CMAKE_OSX_SYSROOT)
  message(FATAL_ERROR "Could not detect iOS SDK")
endif()
set(modes
  FATAL_ERROR
  SEND_ERROR)
message(STATUS "modes=${modes}")
