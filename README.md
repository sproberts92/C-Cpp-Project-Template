# Template - Generic

A template for C/C++ projects.

## Usage

### Setup

Before usage remove `src/.gitignore` and `ext/.gitignore`, these are only there to allow the directory structure to be committed.

`bin/.gitignore` and `build/.gitignore` can stay as files in these directories do not need to be committed during normal usage.

`SETUP.bat` will handle deletion of these files. It can then be modified to include functionality such as setting environment variables, as well as cloning and building external dependencies. Examples of this are provided inside the file.

### External dependencies

Place external dependencies into the `ext` directory, if you wish to use a submodule clone with

```
git submodule add [url/to/repository].git ext/[repository]
```

It is recommended to add `ignore = all` to `.gitmodules`, this prevents changes to the submodule (such as building) from appearing as changes to the main repository.

### Building

On Windows, using `nmake`, build with

```
nmake /f NMAKEFILE
```

On Linux use

```
make -f MAKEFILE
```

## Project status

The Windows `NMAKEFILE` is far more developed than the Linux `MAKEFILE` at present. This is because I usually develop on Windows. I intend to bring the `MAKEFILE` up to date in the near future.
