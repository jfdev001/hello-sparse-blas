cmake_minimum_required(VERSION 3.20)
project(testspblas_downstream
  VERSION 0.1.0
  LANGUAGES Fortran
)

option(FETCH_HELLOSPBLAS "ON - fetches HelloSPBLAS, OFF - use local installation" OFF)

if(${FETCH_HELLOSPBLAS})
    include(FetchContent)
    FetchContent_Declare(
        HelloSPBLAS 
        GIT_REPOSITORY "https://github.com/jfdev001/hello-sparse-blas" 
        GIT_TAG ec3b16f1584c5dc31b9ba58243294a9f712e24dd
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


