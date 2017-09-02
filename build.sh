#!/bin/bash

# Author : 0c7d485fcdfafdf85a8bbb7624f5c4669a54f0735b45331f1a96f6ccfb87c3a3
# Date   : September 02, 2017 

# This is an elementary build script which builds, and runs your project from the build directory.

BUILD_SCRIPT_DIR=`pwd -P`
BUILD_SCRIPT="$BUILD_SCRIPT_DIR/${0##*/}"

BUILD_DIR="$BUILD_SCRIPT_DIR/build"
BUILD_LOG="$BUILD_SCRIPT_DIR/build_log"
CMAKE_TXT="$BUILD_SCRIPT_DIR/CMakeLists.txt"

BINARY_FQN="$BUILD_DIR/swag"

# TODO:  There is probably a more protable way to get this.
NUM_PROCESSORS=`cat /proc/cpuinfo | grep processor | wc -l`

# TODO: Set the makefile processor constant here, it will
# apply to all make commands run from within this shell.

# Simple wrapper which provides timestamps and io redirection to stdout as well as
# a build file.
run_command() {
  COMMAND=$1
  CURR_DATE_TIME=`date "+%Y-%m-%d %H:%M:%S"`
  
  printf "[ %s ][ %s | tee -a $BUILD_LOG ]\n" "$CURR_DATE_TIME" "$COMMAND" >> $BUILD_LOG
  $COMMAND | tee -a $BUILD_LOG
}

# Create build directory if it does not exist or if CMakeLists.txt
# has been updated. TODO: Add symlink switching i.e. /tmp.
if [ ! -d $BUILD_DIR ]; then
  run_command "mkdir $BUILD_DIR"
elif [[ $CMAKE_TXT -nt $BUILD_DIR ]]; then
  run_command "echo 'CMakeLists.txt is newer than build directory. Rebuilding.'"
  run_command "rm $BUILD_DIR/Makefile"
fi;

run_command "rm $BUILD_LOG"

# No 'run_command' since tee will spawn a subshell and the directory
# change will not be preserved.
cd $BUILD_DIR

# TODO: Stop processing if one of the commands fails.
run_command "cmake .."
run_command "make -j$NUM_PROCESSORS"

# When you add tests, which you should (check out googletest), uncomment this.
# run_command "make test"
run_command "$BINARY_FQN"

