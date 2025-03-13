# from dynamics 
# Get FFTPACK
message(STATUS "Building fftpack")
add_subdirectory(fftpack)

# Get test drive
if (${TEST_DRIVE})
    message(STATUS "Building test-drive")
    add_subdirectory(test-drive)
endif()

# Get pfunit
if (${PFUNIT})
    message(STATUS "Building pFUnit")
    add_subdirectory(pFUnit)
endif()

