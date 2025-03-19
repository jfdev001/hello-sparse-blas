# from fftpack/src/CMakeLists.txt 
set(dir ${CMAKE_CURRENT_SOURCE_DIR})
set(HelloSPBLAS_SOURCES
    ${dir}/mo_square.f90
)


# modified from fftpack/CMakeLists.txt and stdlib/src/CMakeLists.txt
set(Fortran_MODULE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/mod/")
set(Fortran_MODULE_DIRECTORY ${Fortran_MODULE_DIRECTORY} PARENT_SCOPE)

if(NOT EXISTS ${Fortran_MODULE_DIRECTORY})
    file(MAKE_DIRECTORY "${Fortran_MODULE_DIRECTORY}")
endif()

# TODO: how could i expose this to the user if they need it???
set(PROJECT_INCLUDE_DIR ${Fortran_MODULE_DIRECTORY})
set(PROJECT_INCLUDE_DIR ${PROJECT_INCLUDE_DIR} PARENT_SCOPE)

# the set fortran module directory seems to fail in the function...
#add_fortran_library(
    #${PROJECT_NAME}
    #${Fortran_MODULE_DIRECTORY} # relevant for build 
    #${CMAKE_INSTALL_INCLUDEDIR} # relevant for installation only
    #${PROJECT_VERSION}
    #${PROJECT_VERSION_MAJOR}
    #${HelloSPBLAS_SOURCES} # defined in src/CMakeLists.txt, ${ARGN}
#)

# TODO:
add_library(${PROJECT_NAME} ${HelloSPBLAS_SOURCES})
set_target_properties(
    ${PROJECT_NAME}
    PROPERTIES
        POSITION_INDEPENDENT_CODE ON
        VERSION ${PROJECT_VERSION}
        Fortran_MODULE_DIRECTORY ${Fortran_MODULE_DIRECTORY}
)
target_include_directories(${PROJECT_NAME} PUBLIC
    $<BUILD_INTERFACE:${Fortran_MODULE_DIRECTORY}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}> # what about prefix?
)

# Could use cmake/helpers.cmake::link_libraries but fftpack include dir is not needed
target_link_libraries(${PROJECT_NAME} fftpack)

# installation/configuration step (makes find_package work!)
# from fftpack/install/CMakeLists.txt 
# TODO: okay, instsall puts mo_square.mod into flat installation prefix...
# need to have it be in include or mod
install_library( # depends on `add_fortran_library` occurring first
    ${PROJECT_NAME}
    ${CMAKE_INSTALL_LIBDIR}
    ${CMAKE_INSTALL_BINDIR}
    ${Fortran_MODULE_DIRECTORY}
    ${CMAKE_INSTALL_PREFIX}
)

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    ${CMAKE_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
)

# modified from test-drive/config/CMakeLists.txt  
configure_package_config_file(
  "${PROJECT_SOURCE_DIR}/cmake/${PROJECT_NAME}Config.cmake.in"
  "${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
  INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
)

# from fftpack/install/CMakeLists.txt
export(
    EXPORT ${PROJECT_NAME}Targets 
    FILE ${CMAKE_BINARY_DIR}/${PROJECT_NAME}Targets.cmake
)   

install( # does this also need to be modifieid??? TODO
    EXPORT ${PROJECT_NAME}Targets
    FILE ${PROJECT_NAME}Targets.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)
install(
    FILES
        ${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake
        ${CMAKE_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

# modified from fftpack and test-drive 
configure_file(
  ${PROJECT_SOURCE_DIR}/cmake/template.pc # modified to have template.pc not in src
  ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.pc
  @ONLY
)

install(
  FILES ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.pc
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig
)
