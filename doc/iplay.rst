:Title: IPLAY
:Author: igsha
:Date: 2019-06-27

NAME
====

iplay - an interactive analyzer and video player for terminal

SYNOPSIS
========

``iplay [-e <name>] [-u] [-b] <url>``

``iplay -h|-v|-l``

DESCRIPTION
===========

The program allows to analyze html of ``<url>`` and extract video.
It uses ``fzy`` to list available options and ``mpv`` to play extracted media URLs.

``iplay`` traverses through html and allows to select the next URL to parse.
Possible cases for traversing is:

* ``iframe`` - shows ``src`` or ``href`` of an ``iframe``;
* ``href`` - shows all tags with href properties;
* ``src`` - the same as ``href``, shows src properties;
* ``back`` - return to the previous URL;

The traversing will be ended if you select one of the extractors:

* ``self`` - return the chosen URL;
* ``ralode`` - extract media URL from ralode player;
* ``moonwalk`` - extract media URL from moonwalk player;
* and so on.

OPTIONS
=======

Currently ``iplay`` supports only short options:

<url>
  your url to play
-u
  only show extracted url, don't play it
-h
  print this help & exit
-v
  print version & exit
-b
  detach mpv to a separate session

EXAMPLES
========

::

   $ iplay https://www.youtube.com/channel/UCc7te9kr2fOVkkFay1ntCQQ

   Choose type (https://www.youtube.com/channel/UCc7te9kr2fOVkkFay1ntCQQ):
   self
   ralode
   moonwalk
   jwplayer
   back
   iframe
   src
   href <---

   Choose url: watch
   /watch?v=jSJeCGB-JUk <---
   /watch?v=J8powfeTjzw
   /watch?v=J8powfeTjzw
   /watch?v=jSJeCGB-JUk
   /watch?v=jSJeCGB-JUk
   /watch?v=KTsUH0MS2gs
   /watch?v=KTsUH0MS2gs
   /watch?v=jyGzDQCr4Kw
   /watch?v=jyGzDQCr4Kw
   /watch?v=JG49UgQmNeU

   Choose type (https://www.youtube.com/watch?v=jSJeCGB-JUk):
   self <---
   ralode
   moonwalk
   jwplayer
   back
   iframe
   src
   href

   Playing: https://www.youtube.com/watch?v=jSJeCGB-JUk
    (+) Video --vid=1 (*) (h264 1920x1080 25.000fps)
    (+) Audio --aid=1 (*) 'DASH audio' (aac 2ch 44100Hz) (external)
   AO: [pulse] 44100Hz stereo 2ch float
   VO: [gpu] 1920x1080 yuv420p
   AV: 00:01:06 / 00:16:54 (6%) A-V:  0.000 Cache: 25s+5MB
