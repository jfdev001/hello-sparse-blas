# helper.cmake
#
# A collection of macros and functions making life with CMake and Fortran a
# bit simpler.
# 
# modified from fftpack

function(link_spblas targ)
    # Add include directories
    target_include_directories(
        ${targ}
        PRIVATE ${MKLINCLUDE}
    )

    # Specify the MKL libraries for linking
    target_link_libraries(
        ${targ}
        PRIVATE
            # must be static 
            ${MKLLIB}/libmkl_blas95_ilp64.a
            
            # must shared 
            ${MKLLIB}/libmkl_intel_ilp64.so
            ${MKLLIB}/libmkl_sequential.so # or libmkl_intel_thread.so
            ${MKLLIB}/libmkl_core.so

            # standard shared libs 
            pthread
            m
            dl
    )

    target_compile_options(
        ${targ}
        PRIVATE
            -i8 # required, otherwise segfaults
    )
endfunction()

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
        # Put all dependency .mod files in this dir (e.g., fftpack, test-drive)
        INCLUDES DESTINATION ${install_dir}/${CMAKE_INSTALL_INCLUDEDIR} 
    )
    install(
        DIRECTORY ${mod_dir}
        # Put all *my* library .mod in this dir 
        DESTINATION ${install_dir}/${CMAKE_INSTALL_INCLUDEDIR}
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
