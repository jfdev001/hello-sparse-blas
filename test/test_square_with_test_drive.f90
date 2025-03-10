! Example module that includes mo_square and performs a dummy unit test
MODULE test_square_with_test_drive

    use mo_square
    USE testdrive, ONLY: new_unittest, unittest_type, error_type, check
    IMPLICIT NONE 
    PRIVATE
    PUBLIC :: collect_test_suite1

CONTAINS

    SUBROUTINE collect_test_suite1(testsuite)
        !> Collection of tests
        type(unittest_type), allocatable, intent(out) :: testsuite(:)
        testsuite = [new_unittest("valid", test_valid)]

    END SUBROUTINE collect_test_suite1

    SUBROUTINE test_valid(error)
        TYPE(error_type), ALLOCATABLE, INTENT(out) :: error

        CALL check(error, 1 + 2 == 3)
        IF (ALLOCATED(error)) RETURN

        ! equivalent to the above
        CALL check(error, 1 + 2, 3)
        IF (ALLOCATED(error)) RETURN

    END SUBROUTINE test_valid

END MODULE test_square_with_test_drive
