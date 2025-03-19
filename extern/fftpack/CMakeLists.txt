message(STATUS "Downloading fftpack")
FetchContent_Declare(
    fftpack
    GIT_REPOSITORY "https://github.com/fortran-lang/fftpack"
    GIT_TAG ${fftpack_GIT_TAG}
)
set(BUILD_TESTING OFF) # prevents building tests for fftpack 
FetchContent_MakeAvailable(fftpack)
