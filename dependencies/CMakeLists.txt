# from dynamics 
# Get FFTPACK
if(${ENABLE_FFTPACK})
    message(STATUS "Building fftpack")
    add_subdirectory(fftpack)
endif()

# Get test drive
if (${ENABLE_TEST_DRIVE})
    message(STATUS "Building test-drive")
    add_subdirectory(test-drive)
    set(test-drive_LIBRARY ${test-drive_LIBRARY} PARENT_SCOPE)
    set(test-drive_INCLUDE_DIR ${test-drive_INCLUDE_DIR} PARENT_SCOPE)
endif()

# Get pfunit
if(${ENABLE_PFUNIT})
    message(STATUS "Building pFUnit")
    add_subdirectory(pFUnit)
endif()

