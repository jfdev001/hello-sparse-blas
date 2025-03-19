cmake_minimum_required(VERSION 3.15)

option(BUILD_SHARED_LIBS "Build shared libraries" ON)

option(BUILD_TESTING "Build tests" OFF)
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
set(MKLLIB ${MKLROOT}/lib CACHE PATH "Path to Intel MKL Libraries")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/cmake")

include(GNUInstallDirs)

message(STATUS "Build extern")
add_subdirectory(extern)

message(STATUS "Build src")
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
