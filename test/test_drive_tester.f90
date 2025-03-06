PROGRAM test_drive_tester

    USE, INTRINSIC :: ISO_FORTRAN_ENV, ONLY: ERROR_UNIT
    USE testdrive, ONLY: run_testsuite, new_testsuite, testsuite_type
    USE test_square_with_test_drive, ONLY: collect_test_suite1
    IMPLICIT NONE
    INTEGER :: stat, is
    TYPE(testsuite_type), ALLOCATABLE :: testsuites(:)
    CHARACTER(len=*), PARAMETER :: fmt = '("#", *(1x, a))'

    stat = 0

    testsuites = [new_testsuite("suite1", collect_test_suite1)]

    DO is = 1, SIZE(testsuites)
        WRITE (ERROR_UNIT, fmt) "Testing:", testsuites(is)%name
        CALL run_testsuite(testsuites(is)%collect, ERROR_UNIT, stat)
    END DO

    IF (stat > 0) THEN
        WRITE (ERROR_UNIT, '(i0, 1x, a)') stat, "test(s) failed!"
        error STOP
    END IF

END PROGRAM test_drive_tester

