# 
# Build unit tests and naive MKL executable for SpBLAS
#

# helper for building tests (from fftpack)
macro(build_tests testname)
    add_executable(${testname} ${ARGN})
    link_library(${testname} ${PROJECT_NAME} ${PROJECT_INCLUDE_DIR})
    link_library(${testname} test-drive ${test-drive_INCLUDE_DIR})
    add_test(
        NAME ${testname}
        WORKING_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
        COMMAND $<TARGET_FILE:${testname}>
    )
endmacro()

# Build dummy spblas exec
if(${ENABLE_SPBLAS})
    add_executable(
        test_spblas 
        test_spblas.f90
    )

    link_spblas(test_spblas)
endif()

# Add pfunit tests
if (${PFUNIT}) 
    add_pfunit_ctest (test_square
        TEST_SOURCES test_square.pf
        LINK_LIBRARIES ${PROJECT_NAME}
        LABELS "myproject" 
    )
    # TODO: more tests with the same label as above (e.g., testlib)
endif()

# Add test-drive tests
if (${TEST_DRIVE})
    set(
        TEST_DRIVE_SOURCES
        test_square_with_test_drive.f90 # files containing tests 
        test_drive_tester.f90           # must have this driver! 
    )    
    build_tests(test_drive_square_tests ${TEST_DRIVE_SOURCES})
endif()
