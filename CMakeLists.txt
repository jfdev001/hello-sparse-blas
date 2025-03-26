cmake_minimum_required(VERSION 3.15)

option(BUILD_SHARED_LIBS "Build shared libraries" ON)
option(BUILD_TESTING "Build tests" OFF)

option(ENABLE_SPBLAS "Build with SPBLAS" ON)
option(ENABLE_FIND_INTEL_MKL "Find intel MKL config" OFF)

option(ENABLE_FFTPACK "Build with fftpack" OFF)
option(ENABLE_PFUNIT "Build with pFUnit" OFF)
option(ENABLE_TEST_DRIVE "Build with test-drive" OFF)

project(
    HelloSPBLAS 
    VERSION 0.1.0 
    DESCRIPTION "Generic hello spblas project with dependencies and optional testing libs"
    LANGUAGES Fortran
)

# Set paths to Intel oneAPI MKL
if(${ENABLE_SPBLAS})
    if (${ENABLE_FIND_INTEL_MKL})
        find_package(MKL CONFIG)
        get_target_property(MKLINCLUDE MKL::MKL INTERFACE_INCLUDE_DIRECTORIES)
    endif()
   
    # manually set MKL vars  
    if (NOT MKL_FOUND)
        message(STATUS "Did not find MKL, trying to use env vars/user input")
        set(MKLROOT $ENV{MKLROOT} CACHE PATH "Installation directory of Intel MKL")
        if (NOT MKLROOT)
            message(FATAL_ERROR "MKLROOT environment variable is not set.")
        endif()
        set(MKLLIB ${MKLROOT}/lib CACHE PATH "Path to Intel MKL Libraries")
        set(MKLINCLUDE ${MKLROOT}/include/ CACHE PATH "Path to Intel MKL include files")
    else()
        message(STATUS "Found MKL")
    endif()

    if(NOT EXISTS "${MKLINCLUDE}/mkl_spblas.mod")
        set(NO_MKL_SPBLAS_MOD "
        =======================================================================
            ${MKLINCLUDE} does not contain mkl_spblas.mod
            If you installed Intel MKL to a directory 
            that requires root permissions,
            (e.g., /opt/intel/oneapi/mkl/latest/)
            ```
            # alternatively... you could update secure path in sudo visudo
            sudo -i
            echo 'source /opt/intel/oneapi/setvars.sh > /dev/null' >> ~/.bashrc
            source ~/.bashrc
            your_mkl_include=/opt/intel/oneapi/mkl/latest/include
            ifx -c your_mkl_include/mkl_spblas.f90
            ```
            otherwise if you installed to a directory
            that does not require root permissions, it 
            should be sufficient to call
            ```
            cd /your/mkl/include # replace with your local path
            ifx -c mkl_spblas.f90
            ```
        =======================================================================
        ")
        message(FATAL_ERROR "${NO_MKL_SPBLAS_MOD}")
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
