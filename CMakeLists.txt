cmake_minimum_required(VERSION 3.15)

option(BUILD_SHARED_LIBS "Build shared libraries" ON)

option(BUILD_TESTING "Build tests" OFF)
option(ENABLE_SPBLAS "Build with SPBLAS" ON)
option(PFUNIT "ON - using pFUnit for unit tests, OFF - skip building pfunit tests" OFF)
option(TEST_DRIVE "ON - Using test-drive for unittests, OFF - skip building test-drive tests" OFF)


project(
    HelloSPBLAS 
    VERSION 0.1.0 
    DESCRIPTION "Generic hello spblas project with dependencies and optional testing libs"
    LANGUAGES Fortran
)

# Set paths to Intel oneAPI MKL
# TODO: something wrong with spblas call??
if(${ENABLE_SPBLAS})
    set(MKLROOT $ENV{MKLROOT})  # Assuming MKLROOT is already set in the environment
    if (NOT MKLROOT)
        message(FATAL_ERROR "MKLROOT environment variable is not set.")
    endif()
    set(MKLLIB ${MKLROOT}/lib CACHE PATH "Path to Intel MKL Libraries")
    set(MKLINCLUDE ${MKLROOT}/include CACHE PATH "Path to Intel MKL include files")

    add_executable(
        test_root_spblas 
        test_root_spblas.f90
    )

    # Add include directories
    target_include_directories(
        test_root_spblas 
        PRIVATE ${MKLINCLUDE}
    )

    # Specify the MKL libraries for linking
    target_link_libraries(
        test_root_spblas
        PRIVATE
            # must be static 
            ${MKLLIB}/libmkl_blas95_ilp64.a
            
            # must shared 
            ${MKLLIB}/libmkl_intel_ilp64.so
            ${MKLLIB}/libmkl_sequential.so # or libmkl_intel_thread.so
            ${MKLLIB}/libmkl_core.so

            # standard shared libs 
            pthread
            m
            dl
    )

    target_compile_options(
        test_root_spblas 
        PRIVATE
            -i8 # required, otherwise segfaults
    )
endif()

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/cmake")

# build externals with specified version corresponding to git tag 
#include(FetchContent)
#message(STATUS "Build extern")
#set(fftpack_GIT_TAG main)
#set(pFUnit_GIT_TAG cf37fb694f7c015d3718c1b4f7f3e9a56613067a) # fixes fetch content
#set(test-drive_GIT_TAG main)
#add_subdirectory(extern)

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
