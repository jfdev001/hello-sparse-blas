# from fftpack/src/CMakeLists.txt 
set(dir ${CMAKE_CURRENT_SOURCE_DIR})
set(HelloSPBLAS_SOURCES
    ${dir}/mo_square.f90
)

set(HelloSPBLAS_SOURCES ${HelloSPBLAS_SOURCES} PARENT_SCOPE)
