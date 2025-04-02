set(DOXYGEN_OPTIMIZE_FOR_FORTRAN YES)
set(DOXYGEN_WARNINGS YES)  # ignored if EXTRACT_ALL YES 

## https://stackoverflow.com/questions/8887810/how-to-get-doxygen-to-produce-call-caller-graphs-for-c-functions
set(DOXYGEN_HAVE_DOT YES)
set(DOXYGEN_EXTRACT_ALL YES)
set(DOXYGEN_EXTRACT_PRIVATE YES)
set(DOXYGEN_CALL_GRAPH YES)
set(DOXYGEN_CALLER_GRAPH YES)
set(DOXYGEN_GENERATE_TREEVIEW YES)
set(DOXYGEN_RECURSIVE YES)

## https://stackoverflow.com/questions/52312850/no-modules-item-in-doxygen-for-fortran
#set(DOXYGEN_EXTENSION_MAPPING "f90=Fortran f95=Fortran f03=Fortran f08=Fortran")
set(DOXYGEN_SOURCE_BROWSER YES)
# Text version of caller/call graph
set(DOXYGEN_REFERENCED_BY_RELATION NO) 
set(DOXYGEN_REFERENCES_RELATION NO)

set(DOXYGEN_ENABLE_PREPROCESSING YES) # https://www.doxygen.nl/manual/config.html#cfg_include_graph
set(DOXYGEN_INCLUDED_BY_GRAPH YES)
set(DOXYGEN_INCLUDE_GRAPH YES)

doxygen_add_docs(doxygen_docs
    ${PROJECT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/mainpage.md
    COMMENT "Generating API documentation with Doxygen" 
)
