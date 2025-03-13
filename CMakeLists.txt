cmake_minimum_required(VERSION 3.15)

# Flags for testing 
option(PFUNIT "ON - using pFUnit for unit tests, OFF - skip building unit tests" ON)
option(TEST_DRIVE "ON - Using test-drive for unittests, OFF - skip building unit tests" OFF)

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

# Set misc config 
set(PROJECT_INCLUDE_DIR ${PROJECT_BINARY_DIR}/include)

# Lib testing 
if (${TEST_DRIVE} OR ${PFUNIT})
    include(CTest)
    enable_testing()
    add_subdirectory(test)
endif()

include(GNUInstallDirs)

# Build external libraries
message(STATUS "Build extern")
add_subdirectory(extern)

# Build libs
message(STATUS "Build src")
# ADD FORTRAN LIB HERE??
add_subdirectory(src)

# Documentation
find_package(Doxygen)
if(Doxygen_FOUND)
    message(STATUS "Building doxygen documentation")
    add_subdirectory(doc)
else()
    message(STATUS "Doxygen not found, not building docs")
endif()

set(Fortran_MODULE_DIRECTORY ${PROJECT_INCLUDE_DIR})

# TODO: check fftpack configuration... also includes dirs...
# see creating cmake librarie sthat others can find and use (README.md)
# multiple libraries could be ina package... multiple modules make up lib..
# etc.
add_fortran_library(
    ${PROJECT_NAME}
    ${Fortran_MODULE_DIRECTORY}
    ${CMAKE_INSTALL_INCLUDEDIR}
    ${PROJECT_VERSION}
    ${PROJECT_VERSION_MAJOR}
    ${HelloSPBLAS_SOURCES} # defined in src/CMakeLists.txt 
)

## TODO: could remover target_include_directories and target_link_libraries
# and replace with helpers::link_libraries??
# TODO: this is probably causing the issue!!
link_library(
    ${PROJECT_NAME}
    ${fftpack_LIBRARY}
    ${fftpack_INCLUDE_DIR} # is include dir necessary here?? 
)
#target_include_directories(
    #${PROJECT_NAME} 
    #PUBLIC
        #${fftpack_INCLUDE_DIR}
#)

# Link any externals as an example (private link?)
# TODO: also make loop?
# use helper link_library??
#target_link_libraries(${PROJECT_NAME} PUBLIC ${fftpack_LIBRARY})

# from fftpack
# install_library depends on add_fortran_library
install_library(
    ${PROJECT_NAME}
    ${CMAKE_INSTALL_LIBDIR}
    ${CMAKE_INSTALL_BINDIR}
    ${PROJECT_INCLUDE_DIR}
    ${CMAKE_INSTALL_PREFIX}
)

# Config: fftpack/install/CMakeLists.txt
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    ${CMAKE_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
)

# TODO: configure_package_config_file since this what's needed to expand the
# HelloSPBLASConfig.cmake.in @PACKAGE_INIT@ etc...
# test-drive/config/CMakeLists.txt 
configure_package_config_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/${PROJECT_NAME}Config.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
  INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}" # TODO: change to bin?
)

export(
    EXPORT ${PROJECT_NAME}Targets 
    FILE ${CMAKE_BINARY_DIR}/${PROJECT_NAME}Targets.cmake
)   

# Define the configuration file
#configure_file(
    #${CMAKE_CURRENT_SOURCE_DIR}/cmake/${PROJECT_NAME}Config.cmake.in
    #${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake
    #COPYONLY
#)

install(
    EXPORT ${PROJECT_NAME}Targets
    FILE ${PROJECT_NAME}Targets.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)
install(
    FILES
        ${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake
        ${CMAKE_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

# used in both fftpack and test-drive 
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/template.pc
  ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.pc
  @ONLY
)

install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.pc
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig
)

