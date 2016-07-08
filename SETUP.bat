@echo off

rem echo Cloning submodules...
rem git submodule update --init
rem echo Cloning submodules... Done.

rem echo Setting compiler environment variables...
rem call vcvarsall amd64
rem echo Done.

rem echo Compiling [...] library... 
rem pushd ext\[...]
rem nmake /f [...]
rem popd
rem echo Compiling [...] library... Done.

echo removing .gitignore...

del /f /q src\.gitignore
del /f /q ext\.gitignore
del /f /q initial-commit-message.txt

echo Done.

echo Setup complete.
