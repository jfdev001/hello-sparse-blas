# system under test
add_library(sut
    mo_square.f90
)

set(Fortran_MODULE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/mod")

# Controls where to write the fortran mod files 
# TODO: access specifier for target?? should be public so can be used 
# as lib right?
# see src/horizontal/CMakeList.txt for setting /mod dir ...
set_target_properties(
    sut 
    PROPERTIES Fortran_MODULE_DIRECTORY "${Fortran_MODULE_DIRECTORY}"
)

# Allows successful linking of sut in the tests/CMakeLists.txt
target_include_directories(
    sut 
    PUBLIC 
        $<BUILD_INTERFACE:$<$<COMPILE_LANGUAGE:Fortran>:${Fortran_MODULE_DIRECTORY}>>
        $<INSTALL_INTERFACE:$<$<COMPILE_LANGUAGE:Fortran>:$<INSTALL_PREFIX>/${CMAKE_INSTALL_INCLUDEDIR}>>
        ${fftpack_INCLUDE_DIR}
)

# Link any externals as an example
target_link_libraries(sut PUBLIC ${fftpack_LIBRARY})

# from libiconmath
#install(TARGETS sut EXPORT "${PROJECT_NAME}Targets")
#install(DIRECTORY "${Fortran_MODULE_DIRECTORY}/" TYPE INCLUDE)
