cmake_minimum_required(VERSION 3.15)
project(TestSPBLAS Fortran)

# Set paths to Intel oneAPI MKL
set(MKLROOT $ENV{MKLROOT})  # Assuming MKLROOT is already set in the environment

if (NOT MKLROOT)
    message(FATAL_ERROR "MKLROOT environment variable is not set.")
endif()

# Add the include directory for MKL
#include_directories(${MKLROOT}/include)

# Define the Fortran source files
set(SOURCES
    ${PROJECT_SOURCE_DIR}/test_spblas.f90
)

# Define the executable target
add_executable(test_spblas ${SOURCES})
add_executable(test_spsolve ${PROJECT_SOURCE_DIR}/test_spsolve.f90)

# Add include directories
target_include_directories(test_spblas 
    PRIVATE 
        ${MKLROOT}/include
        #${MKLROOT}/include/mkl/intel64/ilp64 # suggested by LLA by not needed
)

target_include_directories(test_spsolve PRIVATE ${MKLROOT}/include)

# Specify the MKL libraries for linking
target_link_libraries(test_spblas
    PRIVATE
        # must be static 
        ${MKLROOT}/lib/libmkl_blas95_ilp64.a
        
        # must shared 
        ${MKLROOT}/lib/libmkl_intel_ilp64.so
        ${MKLROOT}/lib/libmkl_sequential.so # or libmkl_intel_thread.so
        ${MKLROOT}/lib/libmkl_core.so

        # standard shared libs 
        pthread
        m
        dl
)

target_link_libraries(test_spsolve
    PRIVATE
        # must be static 
        ${MKLROOT}/lib/libmkl_blas95_ilp64.a
        
        # must shared 
        ${MKLROOT}/lib/libmkl_intel_ilp64.so
        ${MKLROOT}/lib/libmkl_sequential.so # or libmkl_intel_thread.so
        ${MKLROOT}/lib/libmkl_core.so

        # standard shared libs 
        pthread
        m
        dl
)

# Ensure proper linker flags are passed
#target_link_options(test_spblas 
    #PRIVATE
        #-Wl,--start-group
        #-Wl,--end-group
#)

# Enable warnings and optimization flags
target_compile_options(test_spblas 
    PRIVATE
        -warn all
        -O3
        -i8
)

target_compile_options(test_spsolve
    PRIVATE
        -warn all
        -O3
        -i8
)
