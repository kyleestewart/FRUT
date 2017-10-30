FRUT
####

|AppVeyor| |TravisCI|

``FRUT`` is a collection of tools dedicated to building `JUCE`_ projects using `CMake`_
instead of `Projucer`_.

It currently contains:

- ``Reprojucer.cmake``, a CMake module that provides high-level functions to reproduce
  how a JUCE project is defined in Projucer,

- ``Jucer2Reprojucer``, a console application based on JUCE that converts ``.jucer``
  project files into ``CMakeLists.txt`` files that include and use ``Reprojucer.cmake``,

- several ``CMakeLists.txt`` files generated from existing ``.jucer`` project files,
  including:

  - ``examples`` and ``extras`` projects from `JUCE 4.2.0`_
    (in `Jucer2Reprojucer/generated/JUCE-4.2.0`_)

  - ``examples`` and ``extras`` projects from `JUCE 4.3.1`_
    (in `Jucer2Reprojucer/generated/JUCE-4.3.1`_)


Requirements
============

- CMake, version 3.4 minimum
- JUCE, version 4.2.0 to 4.3.1 (JUCE 5 is not supported yet)


Getting started
===============

Let's consider that you have a copy of `JUCE <https://github.com/WeAreROLI/JUCE>`_, a
copy of `FRUT`_ and a JUCE project called ``MyGreatProject`` following this folder
structure:
::
        <root>
        ├── FRUT/
        ├── JUCE/
        └── MyGreatProject/
            ├── Source/
            └── MyGreatProject.jucer

We first build ``Jucer2Reprojucer`` with CMake. Since ``Jucer2Reprojucer`` uses the JUCE
modules ``juce_core``, ``juce_data_structures`` and ``juce_events``, we specify where to
find JUCE by defining ``JUCE_ROOT`` when calling ``cmake``.
::
    cd <root>/FRUT/Jucer2Reprojucer

    mkdir build && cd build

    # On macOS
    cmake .. -G Xcode -DJUCE_ROOT=../../../JUCE
    # On Linux and on Windows
    cmake .. -DJUCE_ROOT=../../../JUCE

    cmake --build .

Then we convert ``MyGreatProject.jucer`` to a new ``CMakeLists.txt`` file:
::
    cd <root>/MyGreatProject

    # On macOs and on Windows
    ../FRUT/Jucer2Reprojucer/build/Debug/Jucer2Reprojucer MyGreatProject.jucer ../FRUT/cmake/Reprojucer.cmake
    # On Linux
    ../FRUT/Jucer2Reprojucer/build/Jucer2Reprojucer MyGreatProject.jucer ../FRUT/cmake/Reprojucer.cmake

Now we can build ``MyGreatProject`` using CMake:
::
    cd <root>/MyGreatProject

    mkdir build && cd build

    # On macOs
    cmake .. -G Xcode -DMyGreatProject_jucer_FILE=../MyGreatProject.jucer
    # On Linux and on Windows
    cmake .. -DMyGreatProject_jucer_FILE=../MyGreatProject.jucer

    cmake --build .


Supported export targets
========================

``Reprojucer.cmake`` and ``Jucer2Reprojucer`` support the following Projucer export
targets:

- Xcode (MacOSX)
- Visual Studio 2015
- Visual Studio 2013
- Linux Makefiles


License
=======

FRUT is free software: you can redistribute it and/or modify it under the terms of
the GNU General Public License as published by the Free Software Foundation, either
version 3 of the License, or (at your option) any later version.

FRUT is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the `LICENSE`_ file for more details.


.. |AppVeyor| image:: https://ci.appveyor.com/api/projects/status/github/McMartin/frut?branch=master&svg=true
    :target: https://ci.appveyor.com/project/McMartin/frut
    :alt: AppVeyor build status
.. |TravisCI| image:: https://travis-ci.org/McMartin/FRUT.svg?branch=master
   :target: https://travis-ci.org/McMartin/FRUT
   :alt: Travis CI build status

.. _Jucer2Reprojucer/generated/JUCE-4.2.0: Jucer2Reprojucer/generated/JUCE-4.2.0
.. _Jucer2Reprojucer/generated/JUCE-4.3.1: Jucer2Reprojucer/generated/JUCE-4.3.1
.. _LICENSE: LICENSE

.. _CMake: https://cmake.org/
.. _FRUT: https://github.com/McMartin/FRUT
.. _JUCE 4.2.0: https://github.com/WeAreROLI/JUCE/tree/4.2.0
.. _JUCE 4.3.1: https://github.com/WeAreROLI/JUCE/tree/4.3.1
.. _JUCE: https://juce.com/
.. _Projucer: https://www.juce.com/projucer
