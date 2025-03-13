include(FetchContent)
if (${PFUNIT})
    FetchContent_Declare(
      PFUNIT
      GIT_REPOSITORY "https://github.com/Goddard-Fortran-Ecosystem/pFUnit"
      GIT_TAG cf37fb694f7c015d3718c1b4f7f3e9a56613067a # branch that fixes fetchcontent 
    )  
    FetchContent_MakeAvailable(PFUNIT)
endif()
