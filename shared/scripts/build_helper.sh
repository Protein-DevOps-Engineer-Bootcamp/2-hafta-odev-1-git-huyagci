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

# archive_artifact() {
#     md5sum
# }

# if [ "$#" -lt 1 ]
# then
#     usage
# fi

DEBUG=false
SKIP_TESTS=false

while getopts b:d:f:hn:p:t: options
do
    case "${options}" in
        b) BRANCH=${OPTARG};;
        # d) DEBUG=${OPTARG};;
        d) if [ "${OPTARG}" == "true" ]; then BUILD+=" -X"; fi ;;
        f) FORMAT=${OPTARG};;
        h) usage;;
        n) NEW_BRANCH=${OPTARG};;
        p) OUTPUT_PATH=${OPTARG};;
        t) if [ "${OPTARG}" == "true" ]; then BUILD+=" -Dmaven.test.skip=true"; fi ;;
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
echo "Branch: ${BRANCH}"
echo "Debug: ${DEBUG} | DEFAULT: FALSE"
echo "Format: ${FORMAT}"
echo "New Branch: ${NEW_BRANCH}"
echo "Output Path: ${OUTPUT_PATH}"
echo "Skip Tests: ${SKIP_TESTS} | DEFAULT: FALSE"

# if [ "${current_folder}" == false ]
# then
#     echo "Where is your pom.xml file located?"
#     read PATH
#     BUILD+= " -f $PATH"
#     # mvn package -f /path/to/pom.xml
# fi

echo
echo "Output: "
eval echo $BUILD
echo





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

# echo "Branch: ${BRANCH}"
# echo "Debug: ${DEBUG}"
# echo "Format: ${FORMAT}"
# echo "New Branch: ${NEW_BRANCH}"
# echo "OUTPUT_PATH: ${OUTPUT_PATH}"
# echo "Tests: ${TESTS}"

###############################################################################
# Script execution ends here
###############################################################################
# eval "$BUILD"

# CD to previous directory if executed from another directory
# cd -

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