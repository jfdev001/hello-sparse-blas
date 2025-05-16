message(STATUS "Downloading test-drive")
FetchContent_Declare(
    test-drive
    GIT_REPOSITORY "https://github.com/fortran-lang/test-drive"
    GIT_TAG ${test-drive_GIT_TAG}
)
FetchContent_MakeAvailable(test-drive)

set(test-drive_LIBRARY test-drive)
set(test-drive_LIBRARY ${test-drive_LIBRARY} PARENT_SCOPE)

set(test-drive_INCLUDE_DIR ${test-drive_BINARY_DIR}/include)
message(STATUS "test-drive INCLUDE DIR ${test-drive_INCLUDE_DIR}")
set(test-drive_INCLUDE_DIR ${test-drive_INCLUDE_DIR} PARENT_SCOPE)

