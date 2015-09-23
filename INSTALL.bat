git submodule update --init

call vcvarsall amd64

pushd ext\pthreads-win32\sources\pthreads-w32-2-9-1-release
nmake clean VC
popd

pushd ext\multicorebsp-for-c
nmake /f nmakefile
popd

pushd src
rm .gitignore
popd