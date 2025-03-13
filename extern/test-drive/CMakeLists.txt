include(FetchContent)

# partial from fftpack -- I omit the setting of INCLUDE_DIR, LIBRARY_DIR
# vars that fftpack does since these don't seem to be actually used...
if (${TEST_DRIVE})
    if (${test-drive_FOUND})
        message(STATUS "TEST-DRIVE (${test-drive_VERSION}) library found.")
    else()
        message(STATUS "TEST-DRIVE library not found.  Downloading appropriate repository.")
        FetchContent_Declare(
            test-drive
            GIT_TAG "origin/main"
            GIT_REPOSITORY "https://github.com/fortran-lang/test-drive"
            OVERRIDE_FIND_PACKAGE
        )
        FetchContent_MakeAvailable(test-drive)
    endif()
endif()
