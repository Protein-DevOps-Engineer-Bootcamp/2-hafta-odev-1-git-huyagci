#! /bin/bash
#############################################
# Script Name   : Build Helper              #
# File          : build_helper.sh           #
# Usage         : ./build_helper.sh         #
# Created       : 01/06/2022                #
# Author        : Hasan Umut Yagci          #
# Email         : hasanumutyagci@gmail.com  #
#############################################

# Predefined Variables
TARGET_DIR=/opt/project/java

# Script Execution

# CD to target directory if executed from another directory
cd $TARGET_DIR

BUILD="mvn package"

# USAGE_MSG="
#     Usage: $(basename $0) [OPTIONS]
    
#     OPTIONS:
#     [-b <branch_name>]      Branch name
#     [-n <new_branch>]       Create new branch
#     [-f <zip|tar>]          Compress format
#     [-p <artifact_path>]    Copy artifact to spesific path
# "
#     -d      <true|false>        Enable debug mode.
#     -t      <true|false>        Run or skip tests.
#     -d      <true|false>        Build from current dir or provide another dir.

eval "$BUILD"

# CD to previous directory if executed from another directory
cd -

# Some welcome messages etc..
# echo "Welcome to Build Helper"
# sleep 1
# echo "Who am I talking to?"
# read NAME
# sleep 1
# echo "Nice to meet you, $NAME!"
# sleep 1
# echo 
# echo "What would you like to do today?"