! Use external library HelloSPBLAS 
PROGRAM main
    USE mo_square, ONLY: square 
    REAL :: x = 2 
    REAL :: y
    PRINT *, "Hello, world!"   
    y = square(x)
    PRINT *, "square(x) =", y
END PROGRAM main 
