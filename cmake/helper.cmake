# helper.cmake
#
# A collection of macros and functions making life with CMake and Fortran a
# bit simpler.
# 
# modified from fftpack

# Use to include and export headers
function(include_headers lib dir install_dir)
    target_include_directories(
        ${lib}
        INTERFACE
        $<BUILD_INTERFACE:${dir}>
        $<INSTALL_INTERFACE:${install_dir}>
    )
endfunction()

# Use instead of add_library.
function(add_fortran_library lib_name mod_dir include_install_dir version major)
    add_library(${lib_name} ${ARGN})
    set_target_properties(
        ${lib_name}
        PROPERTIES
            # possible bug with properties and output name and....
            POSITION_INDEPENDENT_CODE ON
            Fortran_MODULE_DIRECTORY ${Fortran_MODULE_DIRECTORY} # was ${include_install_dir}
    )
    # TODO: access specifiers here?? PRIVATE means internal to library (i.e., dev)
    # PUBLIC means required for user 
    target_include_directories(
        ${lib_name}
        PUBLIC
        #$<BUILD_INTERFACE:${mod_dir}>
            $<BUILD_INTERFACE:$<$<COMPILE_LANGUAGE:Fortran>:${mod_dir}>>
            # maybe need to have cmake installa prefix here as well???
            $<INSTALL_INTERFACE:${include_install_dir}>
    )
endfunction()

# Installs the library
function(install_library lib_name lib_install_dir bin_install_dir mod_dir install_dir)
    install(
        TARGETS ${lib_name}
        EXPORT ${lib_name}Targets
        RUNTIME DESTINATION ${bin_install_dir}
        LIBRARY DESTINATION ${lib_install_dir}
        ARCHIVE DESTINATION ${lib_install_dir}
        # TODO: more accurately call install_prefix?? was install_dir/include
        # before...
        INCLUDES DESTINATION ${install_dir}/${CMAKE_INSTALL_INCLUDEDIR} 
    )
    install(
        DIRECTORY ${mod_dir}
        DESTINATION ${install_dir}
    )
endfunction()

# Install the documentation files
function(install_documentation doc_dir install_dir)
    install(
        DIRECTORY ${doc_dir}
        DESTINATION ${install_dir}
    )
endfunction()

# Links the supplied library
function(link_library targ lib include_dir)
    target_link_libraries(${targ} ${lib})
    target_include_directories(${targ} PUBLIC $<BUILD_INTERFACE:${include_dir}>)
endfunction()

# ------------------------------------------------------------------------------
# Helpful Macros
macro(print_all_variables)
    message(STATUS "---------- CURRENTLY DEFINED VARIABLES -----------")
    get_cmake_property(varNames VARIABLES)
    foreach(varName ${varNames})
        message(STATUS ${varName} = ${${varName}})
    endforeach()
    message(STATUS "---------- END ----------")
endmacro()
