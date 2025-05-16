cmake_minimum_required(VERSION 3.15)

option(BUILD_SHARED_LIBS "Build shared libraries" ON)
option(BUILD_TESTING "Build tests" OFF)

option(ENABLE_SPBLAS "Build with SPBLAS" ON)
option(ENABLE_FIND_INTEL_MKL "Find intel MKL config" ON)

option(ENABLE_FFTPACK "Build with fftpack" OFF)
option(ENABLE_PFUNIT "Build with pFUnit" OFF)
option(ENABLE_TEST_DRIVE "Build with test-drive" OFF)

project(
    HelloSPBLAS 
    VERSION 0.1.0 
    DESCRIPTION "Generic hello spblas project with dependencies and optional testing libs"
    LANGUAGES Fortran
)

# Safety net (https://numpy.org/doc/stable/f2py/buildtools/skbuild.html#cmake-modules-only)
if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
  message(
    FATAL_ERROR
      "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there.\n"
  )
endif()

# Set paths to Intel oneAPI MKL
if(${ENABLE_SPBLAS})
    if (${ENABLE_FIND_INTEL_MKL})
        # automatically set paths (preferred option)
        find_package(MKL REQUIRED)
    else()
        # manually set paths
        set(MKLROOT $ENV{MKLROOT} CACHE PATH "Installation directory of Intel MKL")
        if (NOT MKLROOT)
            message(FATAL_ERROR "MKLROOT environment variable is not set.")
        endif()
        set(MKLLIB ${MKLROOT}/lib CACHE PATH "Path to Intel MKL Libraries")
        set(MKLINCLUDE ${MKLROOT}/include/ CACHE PATH "Path to Intel MKL include files")
    endif()
endif()

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/cmake")
include("${PROJECT_SOURCE_DIR}/cmake/helper.cmake")

# build dependenciesals with specified version corresponding to git tag 
include(FetchContent)
message(STATUS "Build dependencies")
set(fftpack_GIT_TAG main)
set(pFUnit_GIT_TAG cf37fb694f7c015d3718c1b4f7f3e9a56613067a) # fixes fetch content
set(test-drive_GIT_TAG main)
add_subdirectory(dependencies)

message(STATUS "Build src")
include(GNUInstallDirs)
add_subdirectory(src)

find_package(Doxygen)
if(Doxygen_FOUND)
    message(STATUS "Building doxygen documentation")
    add_subdirectory(doc)
else()
    message(STATUS "Doxygen not found, not building docs")
endif()

if (${BUILD_TESTING})
    include(CTest)
    enable_testing()
    add_subdirectory(test)
endif()
