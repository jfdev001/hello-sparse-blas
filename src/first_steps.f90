! For figuring out cmake config as libary with external dependencies
! and how this might be used in conjunction with e.g., ICON 
! https://fpm.fortran-lang.org/tutorial/hello-fpm.html
MODULE first_steps
    IMPLICIT NONE
    PRIVATE

    PUBLIC :: say_hello
CONTAINS
    SUBROUTINE say_hello
        PRINT *, "Hello, first_steps!"
    END SUBROUTINE say_hello
END MODULE first_steps
