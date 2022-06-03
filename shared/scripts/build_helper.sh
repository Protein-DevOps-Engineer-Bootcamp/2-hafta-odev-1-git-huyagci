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
DEBUG=false
SKIP_TESTS=false

# CD to target directory if executed from another directory
cd $TARGET_DIR

BUILD="mvn package"

USAGE_MSG="
    Usage: $(basename $0) [OPTION] [ARGUMENT]...

    OPTIONS:    ARGUMENTS:

    [-b]        [branch_name]      Branch must be provided. If not on the branch switch then buil
    [-d]        [true|false]       Enable|Disable debug mode. Default: DISABLED Must be taken from the user
    [-f]        [zip|tar]          Compress format of the artifact. Must be zip or tar.gz. Else break.
    [-h]                           Shows usage
    [-n]        [new_branch]       Create a new branch
    [-p]        [artifact_path]    Copy compressed artifacts to given path
    [-t]        [true|false]       Run or skip tests
"

usage() {
    echo "${USAGE_MSG}"
    exit 1
}

branch() {
    SELECTED_BRANCH=${OPTARG}
}

debug_mode() {
    if [ "${OPTARG}" == "true" ]; then BUILD+=" -X"; fi
}

archive_artifact() {
    if [ "${OPTARG}" == "zip" | "tar.gz" ]
    then
        if [ "${OPTARG}" == "zip" ]
        then
            ARCHIVE_FORMAT="zip"
        else
            ARCHIVE_FORMAT="tar.gz"
        fi
    else
        echo "Invalid archive format selected. Must be zip or tar.gz"
        break
    fi
}

# Create a new branch (IF ARG IS GIVEN)
new_branch() {
    if [ "${OPTARG}" == {{{{{EXISTS}}}}} ]; then git branch ${OPTARG}; fi
}

# If arg is given set Output Path of the Archive else build into same directory
output_path() {
    if [ "${OPTARG}" == {{{{{EXISTS}}}}} ]
    then
        OUTPUT_PATH=${OPTARG}
    else
        OUTPUT_PATH="${pwd}"
    fi
}

skip_tests() {
    if [ "${OPTARG}" == "true" ]; then BUILD+=" -Dmaven.test.skip=true"; fi 
}

build() {
    BRANCH_LIST=( $(git branch | tr -d ' ,*') )
    CURRENT_BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
    echo
    echo "Building project on ${SELECTED_BRANCH} branch"
    echo
    if [[ " ${BRANCH_LIST[*]} " =~ " ${SELECTED_BRANCH} " ]]
    then
        if [ " ${SELECTED_BRANCH} " == " ${CURRENT_BRANCH} " ]
        then
            echo
            echo "SELECTED BRANCH IS CURRENT BRANCH"
            echo
            eval echo $BUILD
        else
            echo
            echo "SELECTED BRANCH IS NOT CURRENT BRANCH SWITCHING BRANCH"
            git switch ${SELECTED_BRANCH}
            eval echo $BUILD
        fi
    else
        echo
        echo "SELECTED BRANCH IS NOT EXIST... CREATING REQUESTED BRANCH"
        git checkout -b ${SELECTED_BRANCH}
        eval echo $BUILD
    fi
}

compress() {
    TARGET_DIR=/opt/project
    TARGET_FILE=$(find $TARGET_DIR/ -type f -name "*.jar")
    if [ "${ARCHIVE_FORMAT}" == "zip" ]
    then
        zip -r ${OUTPUT_PATH}/${SELECTED_BRANCH}.${ARCHIVE_FORMAT} ${TARGET_FILE}
    else
        tar -czf ${OUTPUT_PATH}/${SELECTED_BRANCH}.${ARCHIVE_FORMAT} ${TARGET_FILE}
    fi
}

# If no args are given show usage
# if [ "$#" -lt 1 ]
# then
#     usage
# fi

while getopts b:d:f:n:p:t:h options
do
    case "${options}" in
        b) branch;;
        d) debug_mode;;
        f) archive_artifact;;
        h) usage;;
        n) new_branch;;
        p) output_path;;
        t) skip_tests;;
        # *) ??
        #     usage
        #     ;;
        ?)
            echo
            echo "Invalid Option: ${OPTARG}"
            usage
            ;;
    esac
done

echo
echo "Branch: ${SELECTED_BRANCH}"
echo "Format: ${FORMAT}"
echo "New Branch: ${NEW_BRANCH}"
echo "Output Path: ${OUTPUT_PATH}"

# if [ "${current_folder}" == false ]
# then
#     echo "Where is your pom.xml file located?"
#     read PATH
#     BUILD+= " -f $PATH"
#     # mvn package -f /path/to/pom.xml
# fi

# Get build
build

# Compress
compress

# CD to previous directory if executed from another directory
cd -

###############################################################################
# Shift Method for args
###############################################################################
# while true
# do
#     case "$1" in
#         -b)
#             BRANCH=$2
#             shift 2
#             ;;
#         -d)
#             DEBUG=$2
#             shift 2
#             ;;
#         -f)
#             FORMAT=$2
#             shift 2
#             ;;
#         -h)
#             usage
#             ;;
#         -n)
#             NEW_BRANCH=$2
#             shift 2
#             ;;
#         -p)
#             OUTPUT_PATH=$2
#             shift 2
#             ;;
#         -t)
#             TESTS=$2
#             shift 2
#             ;;
#         *)
#             usage
#             break
#             ;;
#     esac
# done

###############################################################################
# Some welcome messages etc..
###############################################################################
# echo "Welcome to Build Helper"
# sleep 1
# echo "Who am I talking to?"
# read NAME
# sleep 1
# echo "Nice to meet you, $NAME!"
# sleep 1
# echo 
# echo "What would you like to do today?"
###############################################################################