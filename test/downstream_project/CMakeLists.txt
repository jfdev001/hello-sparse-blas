# Config with cmake -S . -B build -DCMAKE_PREFIX_PATH=../../build/installed 
# from goddard pfunit
cmake_minimum_required(VERSION 3.20)
project(testspblas_downstream
  VERSION 0.1.0
  LANGUAGES Fortran
)

option(FETCH_HELLOSPBLAS "ON - fetches HelloSPBLAS, OFF - use local installation" OFF)

if(${FETCH_HELLOSPBLAS})
    include(FetchContent)
    # TODO: fetching when there are dependencies... maybe need to add
    # find_dependency PFUNIT if ON or find_dependency test-drive if ON
    FetchContent_Declare(
        HelloSPBLAS 
        GIT_REPOSITORY "https://github.com/jfdev001/hello-sparse-blas" 
        GIT_TAG d0b87d653bbae4ed7cb8177d6e32df7cb3b54335
    )
    FetchContent_MakeAvailable(HelloSPBLAS) 
else()
    find_package(HelloSPBLAS REQUIRED)
endif()

add_executable(hello hello.f90) 

# test-drive and fftpack have ${LIBNAME}_INCLUDE_DIR...
# TODO: need to include stuff here .... maybe use helper function... link_library
#target_include_directories(hello PUBLIC HelloSPBLAS)

target_link_libraries(hello PRIVATE HelloSPBLAS)


