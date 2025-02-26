# hello-minimal-sp-mkl

Demonstrate sparse matrix-vector multiplication with Intel MKL.

```shell
# Get externals 
git submodule update --init 

# Build on ubuntu 22.04 LTS with intel install via apt get
cmake -S . -B build -DCMAKE_Fortran_COMPILER=ifx
cmake --build build
./build/test/test_spblas
```

Alternatively, if on a system where you need to specify a different MKL library
and MKL include path, you can do this with the below (e.g., for DKRZ Levante):

```shell
cmake -S . -B build \
    -DCMAKE_Fortran_COMPILER=ifx \
    -DMKLLIB=/sw/intel/oneapi/mkl/2021.3.0/lib/intel64\
    -DMKLINCLUDE=/sw/intel/oneapi/mkl/2021.3.0/include
```

# References

* Test file based on [gist](https://gist.github.com/ivan-pi/23fe2da69ea6da9e2eb6bcf6e5060937).
* Cmake linking based on [link line advisor](https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl-link-line-advisor.html)
* [Installing intel fortran compiler](https://www.intel.com/content/www/us/en/developer/tools/oneapi/fortran-compiler-download.html?operatingsystem=linux&distribution-linux=apt)
* [Installing mkl](https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl-download.html?operatingsystem=linux&linux-install=apt)
* [Set environment vars](https://gist.github.com/SomajitDey/aeb6eb4c8083185e06800e1ece4be1bd)
* [I did `INCLUDE mkl_spblas.f90` above the `PROGRAM` statement and the `use mkl_spblas` in the program block since i mimicked the direct sparse solver example for f90 on pg. 1941 of the mkl manual](https://www.scc.kit.edu/scc/docs/HP-XC/mkl72/mklman.pdf)
* Directory structure from [fpm](https://fpm.fortran-lang.org/tutorial/hello-fpm.html) even though using cmake  
* [fftpack](https://github.com/fortran-lang/fftpack) uses cmake for dependencies instead of git submodule 
