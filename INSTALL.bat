echo Cloning submodules...
git submodule update --init
echo Cloning submodules... Done.

echo Setting compiler environment variables...
call vcvarsall amd64
echo Done.

echo Compiling getopt library...
pushd ext\getopt
nmake /f nmakefile
popd
echo Compiling getopt library... Done.

echo Compiling pthreads library...
pushd ext\pthreads-win32\sources\pthreads-w32-2-9-1-release
nmake clean VC
popd
echo Compiling pthreads-win32 library... Done.

echo Compiling multicorebsp-for-c library... 
pushd ext\multicorebsp-for-c
nmake /f nmakefile
popd
echo Compiling multicorebsp-for-c library... 

echo removing .gitignore...
pushd src
del /f /q .gitignore
popd
echo Done.

echo Install complete.