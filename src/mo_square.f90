!>  \file mo_square.f90
!!  \brief A module providing a simple square function.
!!
!!  This module defines a function to compute the square of a given real number.
!!

#ifdef INTEL_SPBLAS
INCLUDE "mkl_spblas.f90"
#endif
MODULE mo_square

#ifdef FFTPACK
    USE fftpack
#endif

#ifdef INTEL_SPBLAS
    USE mkl_spblas  
#endif

    IMPLICIT NONE

CONTAINS

    !> \brief Computes the square of a real number.
    !! 
    !! \return The square of the input real number.
    PURE REAL FUNCTION square(x)
        REAL, INTENT(in) :: x  !< Input real number.
        square = x**2
    END FUNCTION square

    PURE REAL FUNCTION cube(x)
        ! An undocumented function
        REAL, INTENT(in) :: x
        cube = x**3
    END FUNCTION cube

END MODULE mo_square

