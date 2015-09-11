# MulticoreBSP for Windows

From the [MulticoreBSP website](http://www.multicorebsp.com/):

> Valiant introduced the BSP model to abstractly represent a parallel computer The model enables the simplified design of parallel algorithms, and allows for the transparent analysis of those algorithms. To easily bridge design and analysis to actual codes, BSP programming interfaces exist. MulticoreBSP is one of those. 

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

## Project structure

User created source files should be placed in the `src` directory. Upon building, the resultant binary will be placed in `bin` along with necessary dlls (at present, just `pthreadVC2.dll`).

The `build` directory contains `.obj` files generated during the build process.

Finally, the dependencies mentioned in the section above are located in the `ext` directory. They are present via the use of git submodules (see usage section, below). For more information the repositories are hosted at
```
https://bitbucket.org/sproberts92/multicorebsp-for-c.git
https://bitbucket.org/sproberts92/pthreads-win32.git
https://bitbucket.org/sproberts92/getopt.git
https://bitbucket.org/sproberts92/unistd.git
```

## Usage

As mentioned above, the external dependencies are present via the use of git submodules. In order to obtain the repository and the external dependencies, run the following commands

```
git clone https://bitbucket.org/sproberts92/learning-bsp.git
git submodule init
git submodule update
```

or more simply

```
git clone https://bitbucket.org/sproberts92/learning-bsp.git --recursive
```

Navigate to `ext\pthreads-win32\sources\pthreads-w32-2-9-1-release` and run the command `nmake clean VC`. To build the appropriate version of Pthreads.

Navigate to `ext\multicorebsp-for-c` and run the command `nmake /F NMakefile` to build MulticoreBSP.

You may now begin writing your application, placing source files in the `src` directory. Change the first line of `MAKEFILE` to the name of your source file and add any others as needed. You may also alter the name of the binary produced in the second line.

Build your application by simply running nmake. The resultant binary is placed in the `bin` directory and the `pthreadVC2.dll` is copied there also.