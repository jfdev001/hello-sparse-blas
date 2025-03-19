cmake_minimum_required(VERSION 3.20)
project(testspblas_downstream
  VERSION 0.1.0
  LANGUAGES Fortran
)

option(FETCH_HELLOSPBLAS "ON - fetches HelloSPBLAS, OFF - use local installation" OFF)

if(${FETCH_HELLOSPBLAS})
    include(FetchContent)
    message(STATUS "Downloading HelloSPBLAS.")
    FetchContent_Declare(
        HelloSPBLAS 
        GIT_REPOSITORY "https://github.com/jfdev001/hello-sparse-blas" 
        GIT_TAG main
    )
    FetchContent_MakeAvailable(HelloSPBLAS) 
else()
    message(STATUS "Finding HelloSPBLAS locally.")
    find_package(HelloSPBLAS REQUIRED)
endif()

add_executable(hello hello.f90) 

target_link_libraries(hello PRIVATE HelloSPBLAS)


