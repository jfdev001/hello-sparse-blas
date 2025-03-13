# system under test
#add_library(sut
    #mo_square.f90
#)
set(dir ${CMAKE_CURRENT_SOURCE_DIR})
set(HelloSPBLAS_SOURCES
    ${dir}/mo_square.f90
)

set(HelloSPBLAS_SOURCES ${HelloSPBLAS_SOURCES} PARENT_SCOPE)

# libiconmath
#set(Fortran_MODULE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/mod")

# fftpack
#set(Fortran_MODULE_DIRECTORY ${PROJECT_INCLUDE_DIR})

## TODO: check fftpack configuration... also includes dirs...
## see creating cmake librarie sthat others can find and use (README.md)
## multiple libraries could be ina package... multiple modules make up lib..
## etc.
#add_fortran_library(
    #${PROJECT_NAME}
    #${Fortran_MODULE_DIRECTORY}
    #${CMAKE_INSTALL_INCLUDEDIR}
    #${PROJECT_VERSION}
    #${PROJECT_VERSION_MAJOR}
    #${HelloSPBLAS_SOURCES}
#)

## Controls where to write the fortran mod files 
## see libiconmath src/horizontal/CMakeList.txt for setting /mod dir ...
## add_fortran_library sets this ...
##set_target_properties(
    ##sut 
    ##PROPERTIES Fortran_MODULE_DIRECTORY "${Fortran_MODULE_DIRECTORY}"
##)

## from libiconmath src/horizontal
##target_include_directories(
    ##sut 
    ##PUBLIC 
        ##$<BUILD_INTERFACE:$<$<COMPILE_LANGUAGE:Fortran>:${Fortran_MODULE_DIRECTORY}>>
        ##$<INSTALL_INTERFACE:$<$<COMPILE_LANGUAGE:Fortran>:$<INSTALL_PREFIX>/${CMAKE_INSTALL_INCLUDEDIR}>>
        ##${fftpack_INCLUDE_DIR}
##)

### TODO: could remover target_include_directories and target_link_libraries
## and replace with helpers::link_libraries??
#target_include_directories(
    #${PROJECT_NAME} # TODO: make for loop for multiple targets dependent on fftpack?
    #PUBLIC
        #${fftpack_INCLUDE_DIR}
#)

## Link any externals as an example (private link?)
## TODO: also make loop?
## use helper link_library??
#target_link_libraries(${PROJECT_NAME} PUBLIC ${fftpack_LIBRARY})

## from fftpack
## install_library depends on add_fortran_library
#install_library(
    #${PROJECT_NAME}
    #${CMAKE_INSTALL_LIBDIR}
    #${CMAKE_INSTALL_BINDIR}
    #${PROJECT_INCLUDE_DIR}
    #${CMAKE_INSTALL_PREFIX}
#)
#message(STATUS "Done install_library in src/")

# from libiconmath: probably fftpack better basis???
#install(TARGETS sut EXPORT "${PROJECT_NAME}Targets")
#install(DIRECTORY "${Fortran_MODULE_DIRECTORY}/" TYPE INCLUDE)
