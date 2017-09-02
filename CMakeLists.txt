# author : 0c7d485fcdfafdf85a8bbb7624f5c4669a54f0735b45331f1a96f6ccfb87c3a3
# date   : September 02, 2017

# I hope this gets you going, I look forward to seeing all the awesome stuff 
# you will create!

cmake_minimum_required(VERSION 2.8)

# Put your project name here.
project(PROJECT_NAME)
enable_language(C CXX)

# -------------------- Set up our main binary ---------------------------------

# Self explanatory.
set(MAIN_EXEC_NAME "swag")

# Avoid string literals like the plauge. Name everything. This is the constant
# which will be a list of header directories which *our* source code needs to
# compile. This does *not* include the directories of external libraries, which
# are defined elsewhere.
set(MAIN_HEADER_DIR
  "${PROJECT_SOURCE_DIR}/hdr"
  )

# This defines the source path relative to *where* cmake is
# being run. In our case this is the 'build' directory.
set(MAIN_SOURCE_DIR "${PROJECT_SOURCE_DIR}/src")

# This globs our project's source files together. This is coming
# from 'ROOT/src' via. MAIN_SOURCE_DIR (defined above).
file(GLOB ALL_MAIN_SOURCES ${MAIN_SOURCE_DIR}/*.cc)

# Adding a directory to the search path. Our project includes
# (but not all includes) live in the 'ROOT/hdr' directory.
include_directories(
  ${MAIN_HEADER_DIR}
  )

# This creates an executable. You will express dependencies on other libraries
# via. 'add_dependencies'. (see below).
add_executable(${MAIN_EXEC_NAME}
  ${ALL_MAIN_SOURCES}
  )

# ------------------ Common to all external libraries  ------------------------

# Think of this like a CMake 'import'. This allows us to use 
# 'ExternalProject_Add'.
include(ExternalProject)

# This is the root for all external libraries.
set(EXTERNAL_LIB_ROOT_DIR "${CMAKE_CURRENT_BINARY_DIR}/external")
# This is the root for all external library source files (uncompiled).
set(EXTERNAL_LIB_SOURCE_DIR "${EXTERNAL_LIB_ROOT_DIR}/source")
# This is the root for all external library build output (.a files, .so files).
set(EXTERNAL_LIB_BUILD_DIR "${EXTERNAL_LIB_ROOT_DIR}/build")


# ---------------------- Eigen Library ----------------------------------------

# This name will be analogous to MAIN_EXEC_NAME (see above). You will use this
# when you express dependencies among egigen and other targets (like 'swag').
set(EIGEN_LIB_NAME "eigen")

# Where are we getting eigen from?
set(EIGEN_GIT_REPO "https://github.com/RLovelett/eigen.git")

# Which branch are we using?
set(EIGEN_BRANCH "master")

# Eigen stores all of its headers top-level, so there is no sub-dir here.
set(EIGEN_INCLUDES_DIR ${EXTERNAL_LIB_SOURCE_DIR})

# The meat of 'adding' an external project.
ExternalProject_Add(${EIGEN_LIB_NAME}
  PREFIX ${EXTERNAL_LIB_ROOT_DIR}

  SOURCE_DIR ${EXTERNAL_LIB_SOURCE_DIR}
  BINARY_DIR ${EXTERNAL_LIB_BUILD_DIR}

  GIT_REPOSITORY ${EIGEN_GIT_REPO}
  GIT_TAG ${EIGEN_BRANCH}
  GIT_SHALLOW 1                       # Do not download the entire git history.

  UPDATE_COMMAND ""                   # No update command.
  INSTALL_COMMAND ""                  # No install command.

  LOG_DOWNLOAD 1                      # Log everything.
  LOG_BUILD 1
  LOG_TEST 1
  )

# Include our include directory (see above) in the search path.
include_directories(${EIGEN_INCLUDES_DIR})

# Express the fact that main depends on eigen.
add_dependencies(${MAIN_EXEC_NAME} ${EIGEN_LIB_NAME})


# --------------------- Foobar Library ----------------------------------------

# This is where you follow my notes and try to include another library. 

# Tips: 
#        find . | grep "\.h" 
#        find . | grep "\.a"
#        find . | grep "\.so"
#        find . | grep "\.cc"

# -------------------------- Misc ---------------------------------------------

# Export compilation database so clang tooling can make use of it. YCM needs
# this for autocompletion.
set(CMAKE_EXPORT_COMPILE_COMMANDS 1)

# This will print all variables to the screen as well as the build log. Grep
# this diligently if you start losing your mind.
get_cmake_property(_variableNames VARIABLES)
foreach(_variableName ${_variableNames})
  message(STATUS "${_variableName}=${${_variableName}}")
endforeach()
