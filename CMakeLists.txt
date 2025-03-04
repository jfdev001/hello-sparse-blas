cmake_minimum_required(VERSION 3.15)

option(PFUNIT "ON - using pFUnit for unit tests, OFF - skip building unit tests" ON)

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
#include(build_submodule)

# Build external libraries
include(FetchContent)
# TODO: conditional on enable testing! 
#build_submodule(extern/pFUnit PROJECT PFUNIT TARGET PFUNIT)


# https://github.com/jchristopherson/dynamics/blob/6d15ff598eaef8f07bbfb62d4b67115c4a13ccea/dependencies/fftpack/CMakeLists.txt#L6
message("Downloading FFTPACK")
FetchContent_Declare(
    fftpack
    GIT_REPOSITORY https://github.com/fortran-lang/fftpack
    GIT_TAG main
)

FetchContent_MakeAvailable(fftpack)
set(fftpack_INCLUDE_DIR ${fftpack_BINARY_DIR}/include)
set(fftpack_LIBRARY fftpack)


# adding pFUnit support
# TODO: move this to an extern/ dir as in dependencies/ dir of fftpack
# or use test-drive since you have working examples of this (e.g.,
# with fftpack... but pfunit is better for long run...
if (${PFUNIT})
  enable_testing()
  if (DEFINED ENV{PFUNIT_DIR})
    message("using pFUnit installed at $ENV{PFUNIT_DIR}")
    find_package(PFUNIT)
  else ()
    set(PFUNIT_VERSION "v4.9.0")
    message("PFUNIT_DIR not set, downloading pFUnit ${PFUNIT_VERSION}")
    #set(FETCHCONTENT_BASE_DIR ${CMAKE_BINARY_DIR}/pFUnit)
    FetchContent_Declare(
      PFUNIT
      GIT_REPOSITORY "https://github.com/Goddard-Fortran-Ecosystem/pFUnit"
      GIT_TAG ${PFUNIT_VERSION}
    )  
    FetchContent_MakeAvailable(PFUNIT)
  endif()
endif()

# TODO: find packages
# https://cliutils.gitlab.io/modern-cmake/chapters/testing.html
#enable_testing() # conditionally!
#find_package(PFUNIT REQUIRED)
#enable_testing()

# TODO: doxygen additions 

add_subdirectory(src)
add_subdirectory(test)

# TODO: cmake config file to allow find_package 
