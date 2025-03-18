cmake_minimum_required(VERSION 3.15)

# Flags for testing 
# TODO: add BUILD_TESTING --> BUILD_TESTING
option(PFUNIT "ON - using pFUnit for unit tests, OFF - skip building pfunit tests" OFF)
option(TEST_DRIVE "ON - Using test-drive for unittests, OFF - skip building test-drive tests" OFF)

project(
    HelloSPBLAS 
    VERSION 0.1.0 
    LANGUAGES Fortran
)

# Set paths to Intel oneAPI MKL
set(MKLROOT $ENV{MKLROOT})  # Assuming MKLROOT is already set in the environment

if (NOT MKLROOT)
    message(FATAL_ERROR "MKLROOT environment variable is not set.")
endif()

# These can be changed with -D... flag during build config 
set(MKLLIB ${MKLROOT}/lib CACHE PATH "Path to Intel MKL Libraries")
set(MKLINCLUDE ${MKLROOT}/include CACHE PATH "Path to Intel MKL include files")

# Get cmake functions 
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/cmake")

include(GNUInstallDirs)

message(STATUS "Build extern")
add_subdirectory(extern)

message(STATUS "Build src")
add_subdirectory(src)

# Documentation
find_package(Doxygen)
if(Doxygen_FOUND)
    message(STATUS "Building doxygen documentation")
    add_subdirectory(doc)
else()
    message(STATUS "Doxygen not found, not building docs")
endif()


# TODO: move installation to src dir as well?

## installation/configuration step (makes find_package work!)
## from fftpack/install/CMakeLists.txt 
#install_library( # depends on `add_fortran_library` occurring first
    #${PROJECT_NAME}
    #${CMAKE_INSTALL_LIBDIR}
    #${CMAKE_INSTALL_BINDIR}
    #${Fortran_MODULE_DIRECTORY}
    #${CMAKE_INSTALL_PREFIX}
#)

#include(CMakePackageConfigHelpers)
#write_basic_package_version_file(
    #${CMAKE_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
    #VERSION ${PROJECT_VERSION}
    #COMPATIBILITY AnyNewerVersion
#)

## from test-drive/config/CMakeLists.txt 
#configure_package_config_file(
  #"${CMAKE_CURRENT_SOURCE_DIR}/cmake/${PROJECT_NAME}Config.cmake.in"
  #"${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
  #INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
#)

## from fftpack/install/CMakeLists.txt
#export(
    #EXPORT ${PROJECT_NAME}Targets 
    #FILE ${CMAKE_BINARY_DIR}/${PROJECT_NAME}Targets.cmake
#)   

#install(
    #EXPORT ${PROJECT_NAME}Targets
    #FILE ${PROJECT_NAME}Targets.cmake
    #DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
#)
#install(
    #FILES
        #${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake
        #${CMAKE_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
    #DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
#)

## from fftpack and test-drive 
#configure_file(
  #${CMAKE_CURRENT_SOURCE_DIR}/template.pc
  #${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.pc
  #@ONLY
#)

#install(
  #FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.pc
  #DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig
#)

# Add testing last (from test-drive)
if (${TEST_DRIVE} OR ${PFUNIT})
    include(CTest)
    enable_testing()
    add_subdirectory(test)
endif()
