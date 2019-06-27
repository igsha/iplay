:Title: IPLAY
:Author: igsha
:Date: 2019-06-27

NAME
====

iplay - an interactive player for terminal

SYNOPSIS
========

``iplay [-e <name>] [-u] [-b] <url>``

``iplay -h|-v|-l``

DESCRIPTION
===========

The program allows to extract video from ``<url>``.
It uses ``fzy`` to list available seasons and episodes and ``mpv`` to play they.

OPTIONS
=======

Currently ``iplay`` supports only short options:

<url>
  your url to play
-e <name>
  use ``<name>`` extractor
-u
  only show extracted url, don't play it
-h
  print this help & exit
-v
  print version & exit
-l
  list known extractors & exit
-b
  detach mpv to a separate session

EXAMPLES
========

::

   $ iplay -l
   Known extractors:
   * moonwalk
   * ralode
