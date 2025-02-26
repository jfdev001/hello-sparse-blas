# Define the executable target
add_executable(
    test_spblas 
    test_spblas.f90
)

# Add include directories
target_include_directories(
    test_spblas 
    PRIVATE ${MKLINCLUDE}
)

# Specify the MKL libraries for linking
target_link_libraries(
    test_spblas
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

# Enable warnings and optimization flags
target_compile_options(
    test_spblas 
    PRIVATE
        -warn all
        -O3
        -i8
)
