# Config with cmake -S . -B build -DCMAKE_PREFIX_PATH=../../build/installed 
# from goddard pfunit
cmake_minimum_required(VERSION 3.20)
project(testspblas_downstream
  VERSION 0.1.0
  LANGUAGES Fortran
)

include(CTest)

find_package(HelloSPBLAS REQUIRED)

