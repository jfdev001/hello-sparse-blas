! Use external library HelloSPBLAS 
PROGRAM main
    USE mo_square, ONLY: sum_cube_square
    REAL :: x = 2 
    REAL :: y
    PRINT *, "Hello, world!"   
    y = sum_cube_square(x)
    PRINT *, y
END PROGRAM main 
