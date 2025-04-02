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
if (${ENABLE_PFUNIT})
    add_pfunit_ctest (test_square
        TEST_SOURCES test_square.pf
        LINK_LIBRARIES ${PROJECT_NAME}
        LABELS "test_${PROJECT_NAME}" 
    )
endif()

# Add test-drive tests
if (${ENABLE_TEST_DRIVE})
    set(
        TEST_DRIVE_SOURCES
        test_square_with_test_drive.f90 # files containing tests 
        test_drive_tester.f90           # must have this driver! 
    )    
    build_tests(test_${PROJECT_NAME} ${TEST_DRIVE_SOURCES})
endif()

if (${BUILD_TESTING}) 
    # TODO: untested with Pfunit since it may need -L flag instead... 
    add_custom_target(testlib
        COMMAND ctest --test-dir ${PROJECT_BINARY_DIR} -R test_${PROJECT_NAME} --output-on-failure
        WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
        COMMENT "Running ${PROJECT_NAME} tests..."
        VERBATIM
    )
endif() 
