# system under test
add_library(sut
    mo_square.f90
)

# Controls where to write the fortran mod files 
# see libiconmath src/horizontal/CMakeList.txt for setting /mod dir ...
set(Fortran_MODULE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/mod")
set_target_properties(
    sut 
    PROPERTIES Fortran_MODULE_DIRECTORY "${Fortran_MODULE_DIRECTORY}"
)

# from libiconmath src/horizontal
target_include_directories(
    sut 
    PUBLIC 
        $<BUILD_INTERFACE:$<$<COMPILE_LANGUAGE:Fortran>:${Fortran_MODULE_DIRECTORY}>>
        $<INSTALL_INTERFACE:$<$<COMPILE_LANGUAGE:Fortran>:$<INSTALL_PREFIX>/${CMAKE_INSTALL_INCLUDEDIR}>>
        ${fftpack_INCLUDE_DIR}
)

# Link any externals as an example (private link?)
target_link_libraries(sut PUBLIC ${fftpack_LIBRARY})

# from fftpack
install_library(
    ${PROJECT_NAME}
    ${CMAKE_INSTALL_LIBDIR}
    ${CMAKE_INSTALL_BINDIR}
    ${PROJECT_INCLUDE_DIR}
    ${CMAKE_INSTALL_PREFIX}
)
message(STATUS "Done install_library in src/")

# from libiconmath: probably fftpack better basis???
#install(TARGETS sut EXPORT "${PROJECT_NAME}Targets")
#install(DIRECTORY "${Fortran_MODULE_DIRECTORY}/" TYPE INCLUDE)
