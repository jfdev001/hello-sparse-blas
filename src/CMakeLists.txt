# system under test
add_library(sut
    square.f90
)

# Controls where to write the fortran mod files 
set_target_properties (sut 
    PROPERTIES
    Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

# Allows successful linking of sut in the tests/CMakeLists.txt
message("${CMAKE_CURRENT_SOURCE_DIR} including: ${fftpack_INCLUDE_DIR}")
target_include_directories(sut 
    PUBLIC ${CMAKE_CURRENT_BINARY_DIR} ${fftpack_INCLUDE_DIR}
)

# Link any externals as an example
message("${CMAKE_CURRENT_SOURCE_DIR} linking: ${fftpack_LIBRARY}")
target_link_libraries(sut 
    PRIVATE ${fftpack_LIBRARY}
)
