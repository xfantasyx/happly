cmake_minimum_required(VERSION 3.12)

project("happly" VERSION 5.0
  DESCRIPTION "A header-only implementation of the .ply file format."
  HOMEPAGE_URL "https://github.com/nmwsharp/happly")

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

add_library(happly INTERFACE)
add_library(happly::happly ALIAS happly)

target_include_directories( happly
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

install(
  TARGETS happly 
  EXPORT happlyTargets)

install(
  EXPORT happlyTargets 
  FILE happlyTargets.cmake 
  DESTINATION cmake)

install(
  FILES
  ${CMAKE_CURRENT_SOURCE_DIR}/happly.h
  DESTINATION
  ${CMAKE_INSTALL_INCLUDEDIR}
)



configure_package_config_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/happlyConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/happlyConfig.cmake
  INSTALL_DESTINATION "cmake"
)


# Install files
INSTALL(FILES
        ${CMAKE_CURRENT_BINARY_DIR}/happlyConfig.cmake
        DESTINATION "cmake"
        )
