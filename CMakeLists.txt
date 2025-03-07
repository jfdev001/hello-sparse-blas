cmake_minimum_required(VERSION 3.15)

option(PFUNIT "ON - using pFUnit for unit tests, OFF - skip building unit tests" ON)
option(TEST_DRIVE "ON - Using test-drive for unittests, OFF - skip building unit tests" OFF)

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

# These can be changed with -D... flag during build config 
set(MKLLIB ${MKLROOT}/lib CACHE PATH "Path to Intel MKL Libraries")
set(MKLINCLUDE ${MKLROOT}/include CACHE PATH "Path to Intel MKL include files")

# Get cmake functions 
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/cmake")

if (${TEST_DRIVE} OR ${PFUNIT})
    include(CTest)
    enable_testing()
endif()

# TODO: doxygen additions 

# Build external libraries
add_subdirectory(extern)

add_subdirectory(src)
add_subdirectory(test)

# TODO: cmake config file to allow find_package 
