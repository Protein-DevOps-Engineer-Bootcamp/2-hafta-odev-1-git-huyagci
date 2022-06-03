#!/bin/bash

#############################################
# Script Name   : Build Helper              #
# File          : build_helper.sh           #
# Usage         : ./build_helper.sh         #
# Created       : 01/06/2022                #
# Author        : Hasan Umut Yagci          #
# Email         : hasanumutyagci@gmail.com  #
#############################################

# Predefined Variables
CURRENT_DIR=$(pwd)
TARGET_DIR=/opt/project/java

# CD to target directory if executed from another directory
cd $TARGET_DIR

BUILD="mvn package -Dmaven.test.skip=true"

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

debug_mode() {
    if [ -n "$OPTARG" ] && [ "${OPTARG}" == "true" ]; then BUILD+=" -X"; fi
}

# Create a new branch (IF ARG IS GIVEN)
# new_branch() {
#     if [ -n "${OPTARG}" ]; then git branch ${OPTARG}; fi
# }

# skip_tests() {
#     if [ "${OPTARG}" == false ]
#     then
#         BUILD+=" -Dmaven.test.skip=false"
#     else
#         BUILD+=" -Dmaven.test.skip=true"
#     fi 
# }

build() {
    if [ -z "$ARCHIVE_FORMAT" ] || ! [[ "$ARCHIVE_FORMAT" == "zip" || "$ARCHIVE_FORMAT" == "tar.gz" ]]
    then
        echo
        echo "INVALID ARCHIVE FORMAT: '$ARCHIVE_FORMAT'"
        echo "You must provide an archive format."
        usage
        exit 1
    else
        BRANCH_LIST=( $(git branch | tr -d ' ,*') )
        CURRENT_BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

        if [ -z "${SELECTED_BRANCH}" ];
        then
            SELECTED_BRANCH=${CURRENT_BRANCH}
            echo
            echo "BRANCH IS NOT SELECTED. USING $SELECTED_BRANCH CURRENT BRANCH $CURRENT_BRANCH"
                
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
                echo "SELECTED BRANCH IS $SELECTED_BRANCH EQUALS TO CURRENT BRANCH IS $CURRENT_BRANCH"
                echo
                echo "OUTPUT COMMAND:"
                eval echo $BUILD
                compress
                echo
            else
                echo
                echo "SELECTED BRANCH $SELECTED_BRANCH IS NOT CURRENT BRANCH $CURRENT_BRANCH... SWITCHING BRANCH TO $SELECTED_BRANCH"
                git switch ${SELECTED_BRANCH}
                echo
                echo "OUTPUT COMMAND:"
                eval echo $BUILD
                compress
                echo
            fi
        else
            echo
            echo "SELECTED BRANCH IS NOT EXISTS... CREATING REQUESTED BRANCH..."
            git checkout -b ${SELECTED_BRANCH}
            echo
            echo "OUTPUT COMMAND:"
            eval echo $BUILD
            compress
            echo
        fi
    fi
}

compress() {
    # If arg is given set Output Path of the Archive else archive into same directory
    if [ -z "${OUTPUT_DIR}" ]
    then
        OUTPUT_DIR=${CURRENT_DIR}
        echo "OUTPUT DIR IS NOT PROVIDED. USING WORKING DIR..."
        echo
        echo "OUTPUT DIR:"
        echo $OUTPUT_DIR
        echo
    else
        OUTPUT_DIR=${OUTPUT_DIR}
        echo "OUTPUT DIR IS PROVIDED. USING USER SPECIFIED DIR..."
        echo
        echo "OUTPUT DIR:"
        echo $OUTPUT_DIR
        echo
    fi

    TARGET_FILE=$(find $TARGET_DIR/target/ -type f -name "*.jar" -or -name "*.war" )

    echo "TARGET FILE:"
    echo $TARGET_FILE
    echo
    echo "ARCHIVE FORMAT:"
    echo $ARCHIVE_FORMAT

    if [ "${ARCHIVE_FORMAT}" == "zip" ]
    then
        zip -r ${OUTPUT_DIR}/${SELECTED_BRANCH}.${ARCHIVE_FORMAT} ${TARGET_FILE}
        echo "$TARGET_FILE is archived as $ARCHIVE_FORMAT"
    fi

    if [ "${ARCHIVE_FORMAT}" == "tar.gz" ]
    then
        tar -Pczf ${OUTPUT_DIR}/${SELECTED_BRANCH}.${ARCHIVE_FORMAT} ${TARGET_FILE}
        echo "$TARGET_FILE is archived as $ARCHIVE_FORMAT"
    fi
}

while getopts b:d:f:n:p:t:h options
do
    case "${options}" in
        b) SELECTED_BRANCH=${OPTARG};;
        d) debug_mode;;
        f) ARCHIVE_FORMAT=${OPTARG};;
        h) usage;;
        n) new_branch;;
        p) OUTPUT_DIR=${OPTARG};;
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

# Output information
echo "Your artifact will be compressed and saved under ${OUTPUT_DIR}"

# Variable Tests (WILL BE DELETED)
echo
echo "Selected Branch: ${SELECTED_BRANCH}"
echo "New Branch: ${NEW_BRANCH}"

# CD to previous directory if executed from another directory
cd -

# If no args are given show usage
# if [ "$#" -lt 1 ]
# then
#     usage
# fi

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