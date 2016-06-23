# Introduction

DAPALB uses the Environment Modules package to provide for the dynamic modification
of a user's environment via modulefiles.

Currently, there are few modules available, but we plan to extend them in the future.

# Listing available modules

In the terminal, type:
```sh
module avail
```

It will return a list in the following form:
```text
------------------------ /usr/share/Modules/modulefiles ------------------------
dot         module-info null        python3.4
module-git  modules     python2.7   use.own
```
As you can see, modules were found under `/usr/share/Modules`. The only interesting
ones so far are the `pythonXX` ones.

To list all the currently active modules, use:
```sh
module list
```

## Python version

The DAPLAB has both python2.7 and python3.4 installed. By default, python2.7 is active.

You can easily switch between them by using the `module load` command. For example:

```sh
module load python2.7
module load python3.4
```

You can validate that the command succeeded by running `python --version`.

Woot!
