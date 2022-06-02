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

USAGE_MSG="
    Usage: $(basename $0) [OPTIONS]
    
    OPTIONS:
    [-b <branch_name>]      Branch name must be provided from the user. If not on the specified branch switch branch then build.
    [-d <true|false>]       Enable|Disable debug mode. Default: DISABLED Must be taken from the user.
    [-f <zip|tar>]          Compress format of the artifact. Must be zip or tar.gz. Else break. (branch_name.zip|tar.gz)
    [-n <new_branch>]       Create a new branch
    [-p <artifact_path>]    Copy compressed artifacts to given path.
    [-t <true|false>]       Run or skip tests.
"

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