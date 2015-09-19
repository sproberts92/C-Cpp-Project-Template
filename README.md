# MulticoreBSP Template

## What is MulticoreBSP?

From the [MulticoreBSP website:](http://www.multicorebsp.com/)

> Valiant introduced the BSP model to abstractly represent a parallel computer The model enables the simplified design of parallel algorithms, and allows for the transparent analysis of those algorithms. To easily bridge design and analysis to actual codes, BSP programming interfaces exist. MulticoreBSP is one of those. 

## Project structure

User created source files should be placed in the `src` directory. Upon building, the resultant binary will be placed in `bin` (along with necessary dlls on Windows, at present just `pthreadVC2.dll`).

The `build` directory contains `.o` or `.obj` files generated during the build process.

Finally, the dependencies mentioned in the section above are located in the `ext` directory. They are present via the use of git submodules (see usage section, below). 

## Usage

Obtain the repository using

```
git clone https://bitbucket.org/sproberts92/learning-bsp.git
```

How to proceed next is platform specific.

---

### Linux

Only the Multicore-BSP library is requried on Linux. Obtain this submodule by running the following

```
git submodule update --init https://bitbucket.org/sproberts92/multicorebsp-for-c.git
```

Navigate to `ext\multicorebsp-for-c` and run the command `make` to build MulticoreBSP.

### Windows

On Windows extra dependencies are required, see the "Issues with the MulticoreBSP library on Windows" section below for more details.

All submodule dependenies are required, so simply run

```
git submodule update --init
```

Navigate to `ext\pthreads-win32\sources\pthreads-w32-2-9-1-release` and run the command `nmake clean VC`. To build the appropriate version of Pthreads.

Navigate to `ext\multicorebsp-for-c` and run the command `nmake /F NMakefile` to build MulticoreBSP.

### OSX

Not yet supported - work in progress.

---

You may now begin writing your application, placing source files in the `src` directory. Change the first line of `MAKEFILE` (Linux) or `NMAKEFILE` (Windows) to the name of your source file and add any others as needed. You may also alter the name of the binary produced in the second line.

Build your application by simply running `make -f MAKEFILE` (Linux) or `nmake ./f NMAKEFILE` (Windows). The resultant binary can be run from the `bin` directory.

## More info on external dependencies

[More info on Multicore BSP.](http://www.multicorebsp.com/)

[More info on Pthreads Win32.](https://www.sourceware.org/pthreads-win32/)

[More info on unistd.](http://stackoverflow.com/questions/341817/is-there-a-replacement-for-unistd-h-for-windows-visual-c)

[More info on getopt.](https://gist.github.com/superwills/5815344#file-getopt-c)

The repositories are also mirrored on bitbucket at
```
https://bitbucket.org/sproberts92/multicorebsp-for-c.git
https://bitbucket.org/sproberts92/pthreads-win32.git
https://bitbucket.org/sproberts92/getopt.git
https://bitbucket.org/sproberts92/unistd.git
```

## Issues with the MulticoreBSP library on Windows

The library does not officially support Windows. There are some windows object files provided on the website but they are outdated and cannot be linked with projects compiled using Visual Studio 2015 (VS2015).

Linking with the provided object files gives the following errors using VS2015:

```
mcbsp.o : error LNK2019: unresolved external symbol __imp___iob_func referenced in function mcbsp_set_pinning
mcinternal.o : error LNK2001: unresolved external symbol __imp___iob_func
mcutil.o : error LNK2001: unresolved external symbol __imp___iob_func
mcbsp.o : error LNK2019: unresolved external symbol vfprintf referenced in function bsp_abort
mcutil.o : error LNK2019: unresolved external symbol sscanf referenced in function mcbsp_util_createMachineInfo
```

This is because Microsoft has [changed definitions of some fundamental functions in VS2015](http://stackoverflow.com/questions/30412951/unresolved-external-symbol-imp-fprintf-and-imp-iob-func-sdl2).

The solution is to build from the source files ourselves. This requires finding substitutes for the following libraries:

### pthreads
The standard unix multithreading library pthreads is not available on Windows. Fortunately this dependency can be resolved thanks to [Pthreads Win32](https://www.sourceware.org/pthreads-win32/).

The usage of pthreads introduces another error:
```
error C2011: 'timespec': 'struct' type redefinition
```
which is resolved by defining `HAVE_STRUCT_TIMESPEC` in each of `mcbsp.c`, `mcinternal.c` and `mcutil.c`, or more easily by the adding the definition via the MAKEFILE with
```
/D HAVE_STRUCT_TIMESPEC
```

### getopt
Also a standard unix library not available on Windows, a port is available thanks to user [superwills on GitHub](https://gist.github.com/superwills/5815344#file-getopt-c).

### unistd
Another unix library not available on Windows, a port has been [communally developed on Stack Overflow](http://stackoverflow.com/questions/341817/is-there-a-replacement-for-unistd-h-for-windows-visual-c).