# hello-sparse-blas

Demonstrate sparse matrix-vector multiplication with Intel MKL. Also has
various cmake structural components that are intended to be for generic 
projects.

Use either `pFUnit` or `test-drive` for unit testing.

Make sure you have the [Intel oneAPI HPC Toolkit](https://www.intel.com/content/www/us/en/developer/tools/oneapi/hpc-toolkit-download.html?packages=hpc-toolkit&hpc-toolkit-os=linux&hpc-toolkit-lin=apt) or [Intel Fortran Essentials](https://www.intel.com/content/www/us/en/developer/tools/oneapi/hpc-toolkit-download.html?packages=fortran-essentials&fortran-essentials-os=linux&fortran-essentials-lin=apt).

Then, you can configure, build, and run tests for the project. 

```shell 
# test-drive builds faster than pfunit
./config/intel_ubuntu_test_drive
```

Alternatively, if on a system where you need to specify a different MKL library
and MKL include path, you can do this with the flags `-DMKLLIB` and `-DMKLINCLUDE`
during configuration. The below bash script does the necessary configuration,
as an example, for DKRZ's Levante.

```shell
./config/intel_levante_pfunit
```

You can build the documentation separately with

```
cmake --build build --target doxygen_docs 
```

Note that `doc/Doxygen.in` was generated using `doxygen -g doc/Doxygen.in`
(see [doxygen tutorial](https://www.doxygen.nl/manual/starting.html)) and
see [Documenting Fotran with Doxygen](https://en.wikibooks.org/wiki/Fortran/Documenting_Fortran) for more details.

You can also check to see if a downstream project can find/fetch this package.

```
(
cd build 
make install
cd ..
cd test/downstream_project/ 
./config/local # uses local installation from make install to run hello world with repo lib
./config/fetch # fetchcontent this repo to run hello world with repo lib
)
```

# On Writing CMakeLists for Fortran

In the `**/CMakeLists.txt`, the packages 
[`fortran-lang/stdlib`](https://github.com/fortran-lang/stdlib),
[`libfortran-support`](https://gitlab.dkrz.de/icon-libraries/libfortran-support),
[`fftpack`](https://github.com/fortran-lang/fftpack), 
[`test-drive`](https://github.com/fortran-lang/test-drive),
[`libiconmath`](https://gitlab.dkrz.de/icon-libraries/libiconmath), and 
[`dynamics`](https://github.com/jchristopherson/dynamics/tree/main) were used as 
inspiration for the cmake commands needed for building a portable Fortran project. 
Comments explicitly state `# ... (from <libname>)` to indicate projects inspired 
part of or the entire cmake command. These projects were used as inspiration due 
to their (a) wide-spread use and/or (b) credibility from expert authorship.

# References

* Test file based on [gist](https://gist.github.com/ivan-pi/23fe2da69ea6da9e2eb6bcf6e5060937).
* Cmake linking based on [link line advisor](https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl-link-line-advisor.html)
* [Installing intel fortran compiler](https://www.intel.com/content/www/us/en/developer/tools/oneapi/fortran-compiler-download.html?operatingsystem=linux&distribution-linux=apt)
* [Installing mkl](https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl-download.html?operatingsystem=linux&linux-install=apt)
* [Set environment vars](https://gist.github.com/SomajitDey/aeb6eb4c8083185e06800e1ece4be1bd)
* [I did `INCLUDE mkl_spblas.f90` above the `PROGRAM` statement and the `use mkl_spblas` in the program block since i mimicked the direct sparse solver example for f90 on pg. 1941 of the mkl manual](https://www.scc.kit.edu/scc/docs/HP-XC/mkl72/mklman.pdf)
* Directory structure from [fpm](https://fpm.fortran-lang.org/tutorial/hello-fpm.html) even though using cmake  
* [fftpack](https://github.com/fortran-lang/fftpack) uses cmake for dependencies instead of git submodule and fetch content 
* Doxygen real Fortran examples: [NOAA-ECM/fv3atm](https://github.com/NOAA-EMC/fv3atm/tree/41df0d88e4c11a8ba239c52605648cafed47acd7)
* [Creating CMake libraries that others can find and use](https://www.youtube.com/watch?v=08f5Dav72aE)
* [fortran-lang/stdlib](https://github.com/fortran-lang/stdlib) for more cmake structure
