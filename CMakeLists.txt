cmake_minimum_required(VERSION 3.15)
project(
    TestSPBLAS 
    VERSION 0.1.0 
    LANGUAGES Fortran
)

# Set paths to Intel oneAPI MKL
set(MKLROOT $ENV{MKLROOT})  # Assuming MKLROOT is already set in the environment

if (NOT MKLROOT)
    message(FATAL_ERROR "MKLROOT environment variable is not set.")
endif()

# TODO: find packages
# https://cliutils.gitlab.io/modern-cmake/chapters/testing.html
#enable_testing() # conditionally!

# These can be changed with -D... flag during build config 
set(MKLLIB ${MKLROOT}/lib CACHE PATH "Path to Intel MKL Libraries")
set(MKLINCLUDE ${MKLROOT}/include CACHE PATH "Path to Intel MKL include files")

# Get cmake functions 
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/cmake")
include(build_submodule)

# Build external libraries
# TODO: conditional on enable testing! 
build_submodule(extern/pFUnit PROJECT PFUNIT TARGET PFUNIT)

# TODO: doxygen additions 

add_subdirectory(src)
add_subdirectory(test)

# TODO: cmake config file to allow find_package 
