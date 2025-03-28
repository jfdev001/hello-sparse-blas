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
!! @cond
include "mkl_spblas.f90"
!! @endcond
PROGRAM TEST_SPBLAS
    USE, INTRINSIC :: ISO_C_BINDING, ONLY: C_FLOAT, C_LONG, C_INT, C_DOUBLE
    USE MKL_SPBLAS
         
    IMPLICIT NONE

    INTEGER(KIND=C_LONG), PARAMETER :: rows = 4
    INTEGER(KIND=C_LONG), PARAMETER :: cols = 6

    INTEGER(KIND=C_LONG), PARAMETER :: nnz = 8

    INTEGER(KIND=C_LONG) :: ia(rows+1), ja(nnz) ! works with include 'mkl_spblas.f90'
    INTEGER :: stat
    REAL(KIND=C_DOUBLE) :: values(nnz), x(6), y(4), y_coo(4), alpha, beta

    TYPE(SPARSE_MATRIX_T) :: a
    TYPE(MATRIX_DESCR) :: descr

    TYPE(SPARSE_MATRIX_T) :: A_coo

    INTEGER(KIND=C_LONG), ALLOCATABLE :: row_indx(:)     
    INTEGER(KIND=C_LONG), ALLOCATABLE :: col_indx(:) 

    ! Matrix example taken from: 
    ! https://en.wikipedia.org/wiki/Sparse_matrix#Compressed_sparse_row_(CSR,_CRS_or_Yale_format)
    !
    !     | 10  20  0  0  0  0 |
    ! A = |  0  30  0 40  0  0 |
    !     |  0   0 50 60 70  0 |
    !     |  0   0  0  0  0 80 | 

    ! create:
    ! create csr
    ia = [1,3,5,8,9]
    ja = [1,2,2,4,3,4,5,6]
    values = [10, 20, 30, 40, 50, 60, 70, 80]

    stat = MKL_SPARSE_D_CREATE_CSR(&
        a,SPARSE_INDEX_BASE_ONE,rows,cols,ia(1:4),ia(2:5),ja,values)

    print *, "stat create = ", stat
    descr%type = SPARSE_MATRIX_TYPE_GENERAL
    
    !! create coo
    row_indx = [1, 1, 2, 2, 3, 3, 3, 4] 
    col_indx = [1, 2, 2, 4, 3, 4, 5, 6]
    stat = mkl_sparse_d_create_coo(&
        A_coo, SPARSE_INDEX_BASE_ONE, rows, cols, nnz, row_indx, col_indx,&
        values) 

    ! spmv: 
    x = [1,1,1,1,1,1]
    beta = 0
    alpha = 1
    ! spmv csr 
    stat = MKL_SPARSE_D_MV(SPARSE_OPERATION_NON_TRANSPOSE,alpha,a,descr,x,beta,y)
    print *, "stat mv = ", stat
    print *, "result csr  = ", y
    print *, "expected = ", [30., 70., 180., 80.]

    !! spmv coo
    stat = mkl_sparse_d_mv(&
        SPARSE_OPERATION_NON_TRANSPOSE, alpha, A_coo, descr, x, beta, y_coo)
    print *, "result coo  = ", y_coo

END PROGRAM TEST_SPBLAS 
