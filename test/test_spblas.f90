! Sparse BLAS matrix-vector product example
!
! The following code demonstrates the creation of
! a CSR matrix, and the sparse matrix-vector product
! using the sparse BLAS functions in Intel MKL.
!
! For linking options for your specific platform see
! the Intel MKL link line advisor located at:
!   https://software.intel.com/content/www/us/en/develop/tools/oneapi/components/onemkl/link-line-advisor.html
!
! In the Inspector-Executor Sparse BLAS Routines, the creation of matrices
! which can be used for solving is described. (mkl_devref_fortran_index.htm)
!
! Is are those matrices used for solving? Might be simpler means of this...
! But at least this will be useful later. There is a direct solver interface..
!
! In the MKL Cookbook (cookbook_index.htm) many different example problems are
! solved... could use that also as a reference.
INCLUDE "mkl_spblas.f90"
PROGRAM TEST_SPBLAS
    USE mkl_spblas, ONLY: sparse_matrix_t, matrix_descr, &
                          mkl_sparse_s_create_csr, mkl_sparse_s_create_coo, mkl_sparse_s_mv, &
                          SPARSE_INDEX_BASE_ONE, SPARSE_MATRIX_TYPE_GENERAL, &
                          SPARSE_OPERATION_NON_TRANSPOSE

    IMPLICIT NONE

    INTEGER, PARAMETER :: rows = 4
    INTEGER, PARAMETER :: cols = 6

    INTEGER, PARAMETER :: nnz = 8

    INTEGER :: ia(rows + 1), ja(nnz), stat
    REAL :: values(nnz), x(6), y(4), y_coo(4)

    TYPE(sparse_matrix_t) :: a
    TYPE(matrix_descr) :: descr

    TYPE(sparse_matrix_t) :: A_coo

    INTEGER, ALLOCATABLE :: row_indx(:)
    INTEGER, ALLOCATABLE :: col_indx(:)

    ! Matrix example taken from:
    ! https://en.wikipedia.org/wiki/Sparse_matrix#Compressed_sparse_row_(CSR,_CRS_or_Yale_format)
    !
    !     | 10  20  0  0  0  0 |
    ! A = |  0  30  0 40  0  0 |
    !     |  0   0 50 60 70  0 |
    !     |  0   0  0  0  0 80 |

    x = [1, 1, 1, 1, 1, 1] ! for spmv
    values = [10, 20, 30, 40, 50, 60, 70, 80] ! for matrix values 

    !! create csr
    ia = [1, 3, 5, 8, 9]
    ja = [1, 2, 2, 4, 3, 4, 5, 6]

    stat = mkl_sparse_s_create_csr( &
           a, SPARSE_INDEX_BASE_ONE, rows, cols, ia(1:4), ia(2:5), ja, values)

    PRINT *, "stat create = ", stat
    descr%TYPE = SPARSE_MATRIX_TYPE_GENERAL

    ! create coo
    !row_indx = [1, 1, 2, 2, 3, 3, 3, 4]
    !col_indx = [1, 2, 2, 4, 3, 4, 5, 6]
    !stat = mkl_sparse_s_create_coo( &
           !A_coo, SPARSE_INDEX_BASE_ONE, rows, cols, nnz, row_indx, col_indx, &
           !values)
    !PRINT *, "stat create = ", stat
    !descr%TYPE = SPARSE_MATRIX_TYPE_GENERAL
    !PRINT *, "descr%TYPE", descr%TYPE

    ! spmv csr
    stat = mkl_sparse_s_mv(SPARSE_OPERATION_NON_TRANSPOSE, 1.0, a, descr, x, 0.0, y)
    PRINT *, "stat mv = ", stat
    PRINT *, "result csr  = ", y
    PRINT *, "expected = ", [30., 70., 180., 80.]

    !! spmv coo
    !stat = mkl_sparse_s_mv( &
           !SPARSE_OPERATION_NON_TRANSPOSE, 1.0, A_coo, descr, x, 0.0, y_coo)
    !PRINT *, "result coo  = ", y_coo

END PROGRAM TEST_SPBLAS
