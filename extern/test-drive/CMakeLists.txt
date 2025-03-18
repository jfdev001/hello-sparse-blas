include(FetchContent)

# partial from fftpack -- I omit the setting of INCLUDE_DIR, LIBRARY_DIR
# vars that fftpack does since these don't seem to be actually used...
if (${TEST_DRIVE})
    if (${test-drive_FOUND})
        message(STATUS "TEST-DRIVE (${test-drive_VERSION}) library found.")
        get_target_property(test-drive_INCLUDE_DIR test-drive INTERFACE_INCLUDE_DIRECTORIES)
    else()
        message(STATUS "TEST-DRIVE library not found.  Downloading appropriate repository.")
        FetchContent_Declare(
            test-drive
            GIT_TAG "origin/main"
            GIT_REPOSITORY "https://github.com/fortran-lang/test-drive"
            OVERRIDE_FIND_PACKAGE
        )
        FetchContent_MakeAvailable(test-drive)
        set(test-drive_INCLUDE_DIR ${test-drive_BINARY_DIR}/include)
    endif()

    set(test-drive_LIBRARY test-drive)
    set(test-drive_LIBRARY ${test-drive_LIBRARY} PARENT_SCOPE)

    set(test-drive_INCLUDE_DIR ${test-drive_INCLUDE_DIR} PARENT_SCOPE)
endif()

