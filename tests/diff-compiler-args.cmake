# Copyright (c) 2017 Alain Martin
#
# This file is part of FRUT.
#
# FRUT is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# FRUT is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with FRUT.  If not, see <http://www.gnu.org/licenses/>.

if(NOT DEFINED jucer_FILE)
  message(FATAL_ERROR "jucer_FILE must be defined")
endif()
if(NOT EXISTS ${jucer_FILE})
  message(FATAL_ERROR "No such .jucer file: ${jucer_FILE}")
endif()
get_filename_component(jucer_FILE "${jucer_FILE}" ABSOLUTE)
get_filename_component(jucer_DIR "${jucer_FILE}" DIRECTORY)

if(NOT DEFINED Projucer_EXE)
  message(FATAL_ERROR "Projucer_EXE must be defined")
endif()
if(NOT EXISTS ${Projucer_EXE})
  message(FATAL_ERROR "No such executable: ${Projucer_EXE}")
endif()
get_filename_component(Projucer_EXE "${Projucer_EXE}" ABSOLUTE)

if(NOT DEFINED exporter)
  message(FATAL_ERROR "exporter must be defined")
endif()
include("${CMAKE_CURRENT_LIST_DIR}/exporters/${exporter}.cmake")

if(NOT DEFINED configuration)
  set(configuration "Debug")
endif()

message("")
message(STATUS "jucer_FILE: ${jucer_FILE}")
message(STATUS "Projucer_EXE: ${Projucer_EXE}")
message(STATUS "exporter: ${exporter}")
message(STATUS "configuration: ${configuration}")
message("")

message(STATUS "Generate build system with Projucer")
execute_process(COMMAND "${Projucer_EXE}" "--resave" "${jucer_FILE}")

message(STATUS "Generate build system with Reprojucer")
if(NOT IS_DIRECTORY "${exporter_reprojucer_build_dir}")
  file(MAKE_DIRECTORY "${exporter_reprojucer_build_dir}")
endif()
execute_process(COMMAND "${CMAKE_COMMAND}" ".."
  "-DCMAKE_BUILD_TYPE=${configuration}" "-G" "${exporter_cmake_generator}"
  OUTPUT_VARIABLE configure_output
  WORKING_DIRECTORY "${exporter_reprojucer_build_dir}"
)
string(REGEX MATCH "<CMAKE_MAKE_PROGRAM>(.+)</CMAKE_MAKE_PROGRAM>"
  m "${configure_output}"
)
set(CMAKE_MAKE_PROGRAM "${CMAKE_MATCH_1}")
message("CMAKE_MAKE_PROGRAM: ${CMAKE_MAKE_PROGRAM}")

message(STATUS "Compile with build system generated by Projucer")
exporter_compile_projucer_project(projucer_compile_cmd)
message("${projucer_compile_cmd}")

message(STATUS "Compile with build system generated by Reprojucer")
exporter_compile_reprojucer_project(reprojucer_compile_cmd)
message("${reprojucer_compile_cmd}")
