!> @file mo_square.f90 
!! @brief Defines a module of simple mathematical operations.
!! @todo remove the ifdef include statement since this throws off doxygen
!#ifdef INTEL_SPBLAS 
!INCLUDE "mkl_spblas.f90"
!#endif
MODULE mo_square

#ifdef FFTPACK
    USE fftpack
#endif

#ifdef INTEL_SPBLAS
    USE mkl_spblas  
#endif

    IMPLICIT NONE

    PRIVATE

    PUBLIC :: sum_cube_square

CONTAINS

    !> @brief Computes the square of a real number.
    !! 
    !! @return The square of the input real number.
    PURE REAL FUNCTION square(x) result(r)
        REAL, INTENT(in) :: x  !< Input real number.
        r = x**2
    END FUNCTION square

    !> @brief Computes the cube of a real number.
    PURE REAL FUNCTION cube(x) result(r)
        ! An undocumented function
        REAL, INTENT(in) :: x
        r = x**3
    END FUNCTION cube

    !> @brief Computes the sum of the cube and square of a real number
    PURE REAL FUNCTION sum_cube_square(x) result(r)
        REAL, INTENT(in) :: x   
        r = square(x) + cube(x)
    END FUNCTION sum_cube_square  

END MODULE mo_square

