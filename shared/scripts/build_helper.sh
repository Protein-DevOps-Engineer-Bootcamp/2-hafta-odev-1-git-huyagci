#!/bin/bash

#############################################
# Script Name   : Build Helper              #
# File          : build_helper.sh           #
# Usage         : ./build_helper.sh         #
# Created       : 01/06/2022                #
# Author        : Hasan Umut Yagci          #
# Email         : hasanumutyagci@gmail.com  #
#############################################

# Current directory of the user.
CURRENT_DIR=$(pwd)

# Project directory.
TARGET_DIR=/opt/project/java

# Accepted compressed archive formats can be "zip", "tar.gz" and null. In case of null default "tar.gz" will be used.
ACCEPTED_FORMATS=("" "zip" "tar.gz")

# Change directory to target directory if the script executed from another directory.
cd $TARGET_DIR

# Default state of maven build command. Test skipping is true.
BUILD="mvn package -Dmaven.test.skip=true"

# Usage message of the script.
USAGE_MSG="
Usage: $(basename $0) [OPTION] [ARGUMENT]...

OPTIONS:    ARGUMENTS:         DESCRIPTION:

[ -b ]      [branch_name]      Branch must be provided. If not on the branch switch then buil
[ -c ]                         Cleans the target folder
[ -d ]      [true|false]       Enable|Disable debug mode. Default: DISABLED Must be taken from the user
[ -f ]      [zip|tar]          Compress format of the artifact. Must be zip or tar.gz. Else break.
[ -h ]                         Shows usage
[ -n ]      [new_branch]       Create a new branch
[ -p ]      [artifact_path]    Copy compressed artifacts to given path
[ -t ]      [true|false]       Run or skip tests
"
# Usage function to prompt usage message.
usage() {
    echo "${USAGE_MSG}"
    exit 1
}

# Adds "-X" to build command if specified.
debug_mode() {
    if [ -n "$OPTARG" ] && [ "${OPTARG}" == "true" ]; then BUILD+=" -X"; fi
}

# This command cleans the maven project in quiet mode by deleting the target directory.
clean_maven() {
    echo -e "\nCleaning project..."
    echo $(mvn clean -q)
    echo -e "Done.\n"
    exit 0
}

# Creates a new branch if argument is specified.
new_branch() {
    if [ -n "${OPTARG}" ]; then git branch ${OPTARG}; fi
}

# Changes the test skipping satete to false by changing the build command parameter to "-Dmaven.test.skip=false"
tests() {
    if [ "${OPTARG}" == true ]; then BUILD=$(echo $BUILD | sed "s/"-Dmaven.test.skip=true"/"-Dmaven.test.skip=false"/g"); fi 
}

# Main build function.
build() {

    # If archive format is not in accepted formats, warn the user and stop execution. 
    if ! [[ "${ACCEPTED_FORMATS[*]}" =~ "${ARCHIVE_FORMAT}" ]]
    then
        echo
        echo "You must provide a valid format. Must be 'zip' or 'tar.gz"
        usage
        exit 1
    else
        # Get the available git branches in target directory and save it as an array.
        BRANCH_LIST=( $(git branch | tr -d ' ,*') )

        # Check the current branch in target directory.
        CURRENT_BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

        # If branch name is not specified by "-b" flag accept current branch as selected branch for build.
        if [ -z "${SELECTED_BRANCH}" ]; then SELECTED_BRANCH=${CURRENT_BRANCH}; fi

        # Check if the selected branch is exists in branch list.
        if [[ "${BRANCH_LIST[*]}" =~ "${SELECTED_BRANCH}" ]]
        then
            # Warn the users if building from "main" or "master" branch.
            if [[ "$SELECTED_BRANCH" == "main" || "$SELECTED_BRANCH" == "master" ]]
            then
                echo
                echo "Be advised: You are building on ${SELECTED_BRANCH} branch!"
            fi

            # If selected branch is the current branch, continue to build and invoke compress function.
            if [ "${SELECTED_BRANCH}" == "${CURRENT_BRANCH}" ]
            then
                eval $BUILD
                compress
            else
            # If selected branch is not the current branch, switch branch first, build the project and invoke compress function.
                git switch ${SELECTED_BRANCH}
                eval $BUILD
                compress
            fi
        else
        # If the selected branch does not exists in branch list, warn the user about creating a new branch.
            echo
            echo "Requested branch does not exits!"
            echo 'Add "-n "'$SELECTED_BRANCH'" flag if you want to build it on a new branch.'
            usage
            exit 1
        fi
    fi
}

# Compressed archive function.
compress() {

    # Selection of archive format. Depending on given, or not given arguments.
    case $ARCHIVE_FORMAT in

        # If not provided, use "tar.gz" as default.
        "")
        echo "Default selected as tar.gz"
        ARCHIVE_FORMAT="tar.gz"
        ;;

        # If provided, use the specified format.
        "zip" | "tar.gz")
        ARCHIVE_FORMAT=$ARCHIVE_FORMAT
        ;;
    esac
    
    # Check if "-p" argument is specified.
    if [ -z "${OUTPUT_DIR}" ]
    then
        # If the "-p" argument is not specified, use the current directory as output directory and inform the user.
        OUTPUT_DIR=${CURRENT_DIR}
        echo
        echo "Output directory is not specified. Using current directory."
    else
        # If the "-p" argument is specified, set the output directory of the archive.
        OUTPUT_DIR=${OUTPUT_DIR}
    fi

    # Find artifacts using ".jar" or ".war" files under target directory.
    TARGET_FILE=$(find $TARGET_DIR/target/ -type f -name "*SNAPSHOT.jar" -or -name "*SNAPSHOT.war" )

    # If "zip" format is requested;
    if [ "${ARCHIVE_FORMAT}" == "zip" ]
    then
        # Compress it using "zip" in quiet mode. "-j" flag provides it does not store directory names.
        zip -q -j ${OUTPUT_DIR}/${SELECTED_BRANCH}.${ARCHIVE_FORMAT} ${TARGET_FILE}
    fi

    # If "tar.gz" format is requested;
    if [ "${ARCHIVE_FORMAT}" == "tar.gz" ]
    then
        #Compress it using "tar" utility. "-C" flag and "$(basename ${...})" provides changing the directory first then archive only the file.
        tar -C $(dirname "${TARGET_FILE}") -Pczf ${OUTPUT_DIR}/${SELECTED_BRANCH}.${ARCHIVE_FORMAT} $(basename "${TARGET_FILE}")
    fi
}

# While loop and case block.

# ":" sign before the flags gives control of the unspecified flags to case itself.
# Therefore "illegal option" error will not be triggered.

# ":" signs after the flags indicates that flags can take arguments.
# "-c" and "-h" are the only flags that can be used without an argument.

while getopts ":b:d:f:n:p:t:ch" options
do
    case "${options}" in
        b) SELECTED_BRANCH=${OPTARG};;
        c) clean="true";;
        d) debug_mode;;
        f) ARCHIVE_FORMAT=${OPTARG};;
        h) usage;;
        n) new_branch;;
        p) OUTPUT_DIR=${OPTARG};;
        t) tests;;
        ?) echo -e "\nInvalid Option: -${OPTARG}"; usage;;
    esac
done

# If "-c" flag is specified, clean the maven project else start building.
if [ ! $clean ]
then
    # Build the project.
    build
else
    # Clean the project.
    clean_maven
fi

# Change directory to previous directory if executed from another directory.
cd - &>/dev/null