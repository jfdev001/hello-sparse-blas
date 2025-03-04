
if (${PFUNIT})
  enable_testing()
  if (DEFINED ENV{PFUNIT_DIR})
    message("using pFUnit installed at $ENV{PFUNIT_DIR}")
    find_package(PFUNIT)
  else ()
    include(FetchContent)
    set(PFUNIT_VERSION "v4.9.0")
    message("PFUNIT_DIR not set, downloading pFUnit ${PFUNIT_VERSION}")
    set(FETCHCONTENT_BASE_DIR ${CMAKE_BINARY_DIR}/pFUnit)
    FetchContent_Declare(
      PFUNIT
      GIT_REPOSITORY "https://github.com/Goddard-Fortran-Ecosystem/pFUnit"
      GIT_TAG ${PFUNIT_VERSION}
    )  
    FetchContent_MakeAvailable(PFUNIT)

    set(PFUNIT_INCLUDE_DIR ${PFUNIT_BINARY_DIR}/include)
    set(PFUNIT_INCLUDE_DIR ${PFUNIT_INCLUDE_DIR} PARENT_SCOPE) # unused?

    #set_property(
        #GLOBAL PROPERTY 
        #PFUNIT_DRIVER 
        #"${PROJECT_SOURCE_DIR}/build/_deps/pfunit-src/include/driver.F90"
    #)

    # Make a parent-scope variable for the library
    set(PFUNIT_LIBRARY PFUNIT)
    set(PFUNIT_LIBRARY ${PFUNIT_LIBRARY} PARENT_SCOPE) # unused?
  endif()
endif()
