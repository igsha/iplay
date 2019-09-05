iplay
=====

.. image:: https://circleci.com/gh/igsha/iplay.svg?style=svg
    :target: https://circleci.com/gh/igsha/iplay

An interactive player for terminal.

Installation
============

On NixOS:

#. ``nix-env -f https://api.github.com/repos/igsha/iplay/tarball/master -i -E 'f: with import <nixpkgs> {}; callPackage f {}'``
#. Or write

   * ``iplay = pkgs.callPackage (fetchTarball https://api.github.com/repos/igsha/iplay/tarball/master) {};`` into your nix-override
   * use ``nix-env -i iplay``

For *Ubuntu-like OS* there is a deb-package on `release page <https://github.com/igsha/iplay/releases>`_.

Building & debugging
====================

On NixOS:

#. Development environment with all packages to manually build package:

   ::

      $ nix-shell .
      (impure) $ mkdir build && cd build
      (impure)/build $ cmake -DCPACK_GENERATOR=DEB ..
      (impure)/build $ make -j package

#. Test package:

   ::

      $ nix-build -E 'with import <nixpkgs> {}; callPackage ./. {}'
      $ nix-shell -p ./result
      (impure) $ iplay -v
