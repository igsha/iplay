iplay
=====

Interactive player for terminal

Installation
============

On NixOS:

#. ``nix-env -f https://api.github.com/repos/igsha/iplay/tarball/master -i -E 'f: with import <nixpkgs> {}; callPackage f {}'``
#. Or write
  * ``iplay = pkgs.callPackage (fetchTarball https://api.github.com/repos/igsha/iplay/tarball/master) {};`` into your nix-override
  * use ``nix-env -i iplay``

Debugging
=========

On NixOS:

#. Development environment with all packages: ``nix-shell .``
#. Test package: ``nix-build -E 'with import <nixpkgs> {}; callPackage ./. {}'``
