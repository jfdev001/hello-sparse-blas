# Config with cmake -S . -B build -DCMAKE_PREFIX_PATH=../../build/installed 
# from goddard pfunit
cmake_minimum_required(VERSION 3.20)
project(testspblas_downstream
  VERSION 0.1.0
  LANGUAGES Fortran
)

option(FETCH_HELLOSPBLAS "ON - fetches HelloSPBLAS, OFF - use local installation" OFF)

include(CTest)

if(${FETCH_HELLOSPBLAS})
    include(FetchContent)
    # ...
else()
    find_package(HelloSPBLAS REQUIRED)
endif()

# make libs and include avail

# link to target (executable)
add_executable(hello hello.f90) 

# test-drive and fftpack have ${LIBNAME}_INCLUDE_DIR...
# TODO: need to include stuff here .... maybe use helper function... link_library
#target_include_directories(hello PUBLIC HelloSPBLAS)

target_link_libraries(hello PRIVATE HelloSPBLAS)


