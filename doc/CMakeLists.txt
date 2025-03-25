set(DOXYGEN_OPTIMIZE_FOR_FORTRAN YES)
set(DOXYGEN_WARNINGS YES) 

# https://stackoverflow.com/questions/8887810/how-to-get-doxygen-to-produce-call-caller-graphs-for-c-functions
set(DOXYGEN_HAVE_DOT YES)
set(DOXYGEN_EXTRACT_ALL YES)
set(DOXYGEN_EXTRACT_PRIVATE YES)
set(DOXYGEN_EXTRACT_STATIC YES)
set(DOXYGEN_CALL_GRAPH YES)
set(DOXYGEN_CALLER_GRAPH YES)
set(DOXYGEN_DISABLE_INDEX YES)
set(DOXYGEN_GENERATE_TREEVIEW YES)
set(DOXYGEN_RECURSIVE YES)

doxygen_add_docs(doxygen_docs
    ${PROJECT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/mainpage.md
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "Generating API documentation with Doxygen" 
)
