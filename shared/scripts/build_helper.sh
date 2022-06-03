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
OUTPUT_PATH=$(pwd)

# CD to target directory if executed from another directory
cd $TARGET_DIR

BUILD="mvn package"

USAGE_MSG="
    Usage: $(basename $0) [OPTION] [ARGUMENT]...

    OPTIONS:    ARGUMENTS:

    [-b]        [branch_name]      Branch must be provided. If not on the branch switch then buil
    [-c]                           Cleans the target folder
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

# branch() {
#     if [ -z "${OPTARG}" ]
#     then
#         echo "You did not provide a branch name. Selecting current branch."
#         SELECTED_BRANCH=${CURRENT_BRANCH}
#     else
#         SELECTED_BRANCH=${OPTARG}
#     fi
# }

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
    if [ -n "${OPTARG}" ]; then git branch ${OPTARG}; fi
}

# If arg is given set Output Path of the Archive else archive into same directory
output_dir() {
    if [ -n "${OPTARG}" ]; then OUTPUT_PATH=${OPTARG}; fi
}

skip_tests() {
    if [ "${OPTARG}" == "true" ]; then BUILD+=" -Dmaven.test.skip=true"; fi 
}

build() {

    BRANCH_LIST=( $(git branch | tr -d ' ,*') )
    CURRENT_BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

    if [ -z "${SELECTED_BRANCH}" ];
    then
        SELECTED_BRANCH=${CURRENT_BRANCH}
        echo
        echo "Branch is not selected. Using Current Branch."
            
    fi

    if [[ "$SELECTED_BRANCH" == "main" || "$SELECTED_BRANCH" == "master" ]]
    then
        echo
        echo "Warning!!! You are building on ${SELECTED_BRANCH} branch!"
    fi

    if [[ "${BRANCH_LIST[*]}" =~ "${SELECTED_BRANCH}" ]]
    then
        if [ "${SELECTED_BRANCH}" == "${CURRENT_BRANCH}" ]
        then
            echo
            echo "SELECTED BRANCH IS CURRENT BRANCH"
            echo
            echo "OUTPUT:"
            eval $BUILD
            echo
        else
            echo
            echo "SELECTED BRANCH IS NOT CURRENT BRANCH... SWITCHING BRANCH"
            git switch ${SELECTED_BRANCH}
            echo
            echo "OUTPUT:"
            eval $BUILD
            echo
        fi
    else
        echo
        echo "SELECTED BRANCH IS NOT EXISTS... CREATING REQUESTED BRANCH..."
        git checkout -b ${SELECTED_BRANCH}
        echo
        echo "OUTPUT:"
        eval $BUILD
        echo
    fi
}

# compress() {
#     TARGET_DIR=/opt/project
#     TARGET_FILE=$(find $TARGET_DIR/ -type f -name "*.jar")
#     if [ "${ARCHIVE_FORMAT}" == "zip" ]
#     then
#         zip -r ${OUTPUT_PATH}/${SELECTED_BRANCH}.${ARCHIVE_FORMAT} ${TARGET_FILE}
#     else
#         tar -Pczf ${OUTPUT_PATH}/${SELECTED_BRANCH}.${ARCHIVE_FORMAT} ${TARGET_FILE}
#     fi
# }

# If no args are given show usage
# if [ "$#" -lt 1 ]
# then
#     usage
# fi

while getopts b:d:f:n:p:t:h options
do
    case "${options}" in
        b) SELECTED_BRANCH=${OPTARG};;
            # branch;;
        d) debug_mode;;
        f) archive_artifact;;
        h) usage;;
        n) new_branch;;
        p) output_dir;;
        t) skip_tests;;
        *) echo "Wildcard"
            ;;
        ?)
            echo
            echo "Invalid Option: ${OPTARG}"
            usage
            ;;
    esac
done

# Get build
build

# Compress
# compress

# Output informatin
echo "Your artifact will be compressed and saved to ${OUTPUT_PATH}"

# Variable Tests (WILL BE DELETED)
echo
echo "Selected Branch: ${SELECTED_BRANCH}"
echo "Archive Format: ${ARCHIVE_FORMAT}"
echo "New Branch: ${NEW_BRANCH}"
echo $TEST

# CD to previous directory if executed from another directory
cd -

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