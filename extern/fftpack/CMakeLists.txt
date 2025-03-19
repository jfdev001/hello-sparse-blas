include(FetchContent)

# Fetch the proper content
message(STATUS "Declare FFTPACK")
FetchContent_Declare(
    fftpack
    GIT_REPOSITORY "https://github.com/fortran-lang/fftpack"
    GIT_TAG main
)

message(STATUS "Make available FFTPACK")
set(BUILD_TESTING OFF) # prevents building tests for fftpack 
FetchContent_MakeAvailable(fftpack)
