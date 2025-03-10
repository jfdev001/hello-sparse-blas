set(DOXYGEN_IN ${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.in)
set(DOXYGEN_OUT ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)
configure_file(${DOXYGEN_IN} ${DOXYGEN_OUT} @ONLY)

doxygen_add_docs(doxygen_docs
    ${PROJECT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/mainpage.md
    CONFIG ${DOXYGEN_IN}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "Generating API documentation with Doxygen" 
)
