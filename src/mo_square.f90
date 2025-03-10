!>  \file mo_square.f90
!!  \brief A module providing a simple square function.
!!
!!  This module defines a function to compute the square of a given real number.
!!

MODULE mo_square
    USE fftpack
    IMPLICIT NONE

CONTAINS

    !> \brief Computes the square of a real number.
    !! 
    !! \return The square of the input real number.
    PURE REAL FUNCTION square(x)
        REAL, INTENT(in) :: x  !< Input real number.
        square = x**2
    END FUNCTION square

END MODULE mo_square

