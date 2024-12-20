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
    use mkl_spblas, only: sparse_matrix_t, matrix_descr, &
        mkl_sparse_s_create_csr, mkl_sparse_s_mv, &
        SPARSE_INDEX_BASE_ONE, SPARSE_MATRIX_TYPE_GENERAL, &
        SPARSE_OPERATION_NON_TRANSPOSE
         
    implicit none

    integer, parameter :: rows = 4
    integer, parameter :: cols = 6

    integer, parameter :: nnz = 8

    integer :: ia(rows+1), ja(nnz), stat
    real :: values(nnz), x(6), y(4)

    type(sparse_matrix_t) :: a
    type(matrix_descr) :: descr


    ! Matrix example taken from: 
    ! https://en.wikipedia.org/wiki/Sparse_matrix#Compressed_sparse_row_(CSR,_CRS_or_Yale_format)
    !
    !     | 10  20  0  0  0  0 |
    ! A = |  0  30  0 40  0  0 |
    !     |  0   0 50 60 70  0 |
    !     |  0   0  0  0  0 80 | 

    ia = [1,3,5,8,9]
    ja = [1,2,2,4,3,4,5,6]
    values = [10, 20, 30, 40, 50, 60, 70, 80]

    stat = mkl_sparse_s_create_csr(a,SPARSE_INDEX_BASE_ONE,rows,cols,ia(1:4),ia(2:5),ja,values)
    print *, "stat create = ", stat

    descr%type = SPARSE_MATRIX_TYPE_GENERAL

    x = [1,1,1,1,1,1]
    stat = mkl_sparse_s_mv(SPARSE_OPERATION_NON_TRANSPOSE,1.0,a,descr,x,0.0,y)
    print *, "stat mv = ", stat

    print *, "result   = ", y
    print *, "expected = ", [30., 70., 180., 80.]

END PROGRAM TEST_SPBLAS 
