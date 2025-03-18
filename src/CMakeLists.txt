# from fftpack/src/CMakeLists.txt 
set(dir ${CMAKE_CURRENT_SOURCE_DIR})
set(HelloSPBLAS_SOURCES
    ${dir}/mo_square.f90
)


# modified from fftpack/CMakeLists.txt and stdlib/src/CMakeLists.txt
set(Fortran_MODULE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/mod/")
set(Fortran_MODULE_DIRECTORY ${Fortran_MODULE_DIRECTORY} PARENT_SCOPE)

if(NOT EXISTS ${Fortran_MODULE_DIRECTORY})
    file(MAKE_DIRECTORY "${Fortran_MODULE_DIRECTORY}")
endif()

set(PROJECT_INCLUDE_DIR ${Fortran_MODULE_DIRECTORY})
set(PROJECT_INCLUDE_DIR ${PROJECT_INCLUDE_DIR} PARENT_SCOPE)

# the set fortran module directory seems to fail in the function...
#add_fortran_library(
    #${PROJECT_NAME}
    #${Fortran_MODULE_DIRECTORY} # relevant for build 
    #${CMAKE_INSTALL_INCLUDEDIR} # relevant for installation only
    #${PROJECT_VERSION}
    #${PROJECT_VERSION_MAJOR}
    #${HelloSPBLAS_SOURCES} # defined in src/CMakeLists.txt, ${ARGN}
#)

# TODO:
add_library(${PROJECT_NAME} ${HelloSPBLAS_SOURCES})
set_target_properties(
    ${PROJECT_NAME}
    PROPERTIES
        POSITION_INDEPENDENT_CODE ON
        Fortran_MODULE_DIRECTORY ${Fortran_MODULE_DIRECTORY}
)
target_include_directories(${PROJECT_NAME} PUBLIC
    $<BUILD_INTERFACE:${Fortran_MODULE_DIRECTORY}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}> # what about prefix?
)

# Could use cmake/helpers.cmake::link_libraries but fftpack include dir is not needed
target_link_libraries(${PROJECT_NAME} fftpack)
