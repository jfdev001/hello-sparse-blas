message(STATUS "Downloading pFUnit")
FetchContent_Declare(
  PFUNIT
  GIT_REPOSITORY "https://github.com/Goddard-Fortran-Ecosystem/pFUnit"
  GIT_TAG ${pFUnit_GIT_TAG}
)  
FetchContent_MakeAvailable(PFUNIT)
