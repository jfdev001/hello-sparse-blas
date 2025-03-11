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

# Lib testing 
if (${TEST_DRIVE} OR ${PFUNIT})
    include(CTest)
    enable_testing()
    add_subdirectory(test)
endif()

# Build external libraries
message(STATUS "Build extern")
add_subdirectory(extern)

# Build libs
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


# Cmake configuration
include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

# TODO: is this configuration necessary??
message(STATUS "Configure package")
configure_package_config_file(
  "${PROJECT_SOURCE_DIR}/cmake/config.cmake.in"
  "${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
  INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake"
  NO_SET_AND_CHECK_MACRO NO_CHECK_REQUIRED_COMPONENTS_MACRO # are these needed?
)

# from fftpack
#install(
    #TARGETS ${PROJECT_NAME}
    #EXPORT ${PROJECT_NAME}Targets
    #RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    #LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    #ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    #INCLUDES DESTINATION ${CMAKE_INSTALL_PREFIX}/include
#)

#install(
    #DIRECTORY ${PROJECT_INCLUDE_DIR}  # is this where my modules are ???
    #DESTINATION ${CMAKE_INSTALL_PREFIX}
#)

# TODO: how are the targets identified here.... try to do this with 
# explicit paths???
# TODO: can't export something that doesnt exist....
message(STATUS "Export targets")
#export(EXPORT "${PROJECT_NAME}Targets"
       #FILE "${PROJECT_BINARY_DIR}/${PROJECT_NAME}Targets.cmake")

write_basic_package_version_file(
  "${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY AnyNewerVersion
)

# TODO: from libicon-math
# TODO: The only target is the SUT... how to make this available to other
# libs ...
message(STATUS "Install targets") 
#install(
    #EXPORT "${PROJECT_NAME}Targets"
    #DESTINATION "${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME}/cmake"
#)

#install(
    #FILES "${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
          #"${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
    #DESTINATION "${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME}/cmake"
#)


## also from fftpack
#configure_file(
    #${CMAKE_CURRENT_SOURCE_DIR}/config.cmake.in
    #${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake
    #COPYONLY
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

