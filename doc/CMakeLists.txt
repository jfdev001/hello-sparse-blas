set(DOXYGEN_OPTIMIZE_FOR_FORTRAN YES)
set(DOXYGEN_WARNINGS YES) 

doxygen_add_docs(doxygen_docs
    ${PROJECT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/mainpage.md
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "Generating API documentation with Doxygen" 
)
