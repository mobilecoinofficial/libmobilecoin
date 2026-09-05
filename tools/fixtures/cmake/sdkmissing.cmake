message(FATAL_ERROR "the canonical call")
if(NOT _CMAKE_OSX_SYSROOT_PATH MATCHES "/(iPhoneOS|iPhoneSimulator|MacOSX)")
  message(
    FATAL_ERROR
    "the mode leads its own line under an unmatched SDK")
endif()
