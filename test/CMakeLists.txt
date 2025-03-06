# helper for building tests (modified from fftpack)
macro(build_tests testname)
    add_executable(${testname} ${ARGN})
    target_link_libraries(${testname} test-drive sut)
    target_include_directories(
        ${testname} 
        PUBLIC ${PROJECT_INCLUDE_DIR} ${test-drive_INCLUDE_DIR})
    add_test(
        NAME ${testname}
        WORKING_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
        COMMAND $<TARGET_FILE:${testname}>
    )
endmacro()

## Naive mkl executable... not actually a formal test 
# Define the executable target
add_executable(
    test_spblas 
    test_spblas.f90
)

# Add include directories
target_include_directories(
    test_spblas 
    PRIVATE ${MKLINCLUDE}
)

# Specify the MKL libraries for linking
target_link_libraries(
    test_spblas
    PRIVATE
        # must be static 
        ${MKLLIB}/libmkl_blas95_ilp64.a
        
        # must shared 
        ${MKLLIB}/libmkl_intel_ilp64.so
        ${MKLLIB}/libmkl_sequential.so # or libmkl_intel_thread.so
        ${MKLLIB}/libmkl_core.so

        # standard shared libs 
        pthread
        m
        dl
)

# Add pfunit tests
if (${PFUNIT}) 
    add_pfunit_ctest (test_square
        TEST_SOURCES test_square.pf
        LINK_LIBRARIES sut 
        LABELS "myproject" 
    )
    # TODO: more tests with the same label as above (e.g., testlib)
endif()

# Add test-drive tests
if (${TEST_DRIVE})
    set(
        TEST_DRIVE_SOURCES
        test_square_with_test_drive.f90
        test_drive_tester.f90
    )    
    build_tests(test_drive_square_tests ${TEST_DRIVE_SOURCES})
endif()
