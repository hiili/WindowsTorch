# Torch for Windows

This repository contains Windows binary builds of the [Torch](http://torch.ch/) machine learning framework.

See the project branches for different build configurations: 32-bit vs. 64-bit, different LuaJIT versions, ..

The git logs contain all build commands and repository versions that were used. The build process is mostly based on this: https://github.com/torch/torch7/wiki/Windows#using-visual-studio-manually

## Preinstalled packages

Preinstalled packages: _cwrap, dok, fun, gnuplot, image, inspect, luaffi, luafilesystem, moses, nn, nnx, optim, paths, penlight, strict, sundown, sys, torch, xlua_

The _torch_ and _nn_ packages are built from pinned versions (commit 7bbe179 on Sep 6, 2016, and commit 1b95f7e on Feb 21, 2017, respectively). Unfortunately, more recent versions do not compile on Windows when following the aforementioned build process.

Everything else is built from the most recent versions that were available when building (the build month is mentioned in the branch names).

## Installing and running

1. Choose a branch that contains the desired build configuration
1. Download or clone the branch to C:\torch
1. In a command prompt:
    1. `C:\torch\setpaths.cmd`
    1. `luajit`

If you wish to place the binaries somewhere else than C:\torch, then you need to modify the path configuration in several files (grep for 'C:[\\\\/]torch'). If you do not plan to use luarocks for installing additional packages, then simply modifying the paths in setpaths.cmd is enough. Torch itself works through symlinks and junctions, too, but luarocks doesn't.

If you want to plot from Torch using Gnuplot, then you need to have Gnuplot installed on your system and the bin directory of the installation in your PATH.

Local and remote debugging with ZeroBrane Studio should work for both 64-bit and 32-bit applications (see the torch7 wiki link above for details).

## Notes

The lua51.dll file in the bin directory is simply a copy of libluajit.dll; this is needed for local debugging with ZeroBrane Studio.
