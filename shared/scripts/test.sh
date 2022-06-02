#!/bin/bash

TARGET_DIR=/opt/project

clear
echo "This script will help you manage the git instances for the main script."
echo
PS3="Make a selection: "
OPTIONS=(
    "Search for Git"
    "Initialize Git"
    "Terminate Git"
    "Quit"
)
while true
do
    select selection in "${OPTIONS[@]}"; do
        case $selection in
            "Search for Git")
                echo
                echo "Found Git under:"
                echo
                for DIR in $(find $TARGET_DIR/ -type d -name '*.git*');
                do
                    echo $(dirname $DIR)
                done
                echo
                break
                ;;
            "Initialize Git")
                for DIR in `find $TARGET_DIR/* -maxdepth 0 -type d`
                do
                    echo
                    echo "Initializing Git for '$DIR' directory:"
                    echo
                    (cd "$DIR" && git config --global --add safe.directory $DIR)
                    (cd "$DIR" && git init -q && git add . && git commit -q -m "Initial commit")
                done
                echo
                break
                ;;
            "Terminate Git")
                echo
                echo "Terminating Git for all directories under '$TARGET_DIR' directory:"
                echo
                for DIR in `find $TARGET_DIR/* -maxdepth 0 -type d`
                do
                    (cd "$DIR" && rm -rf .git/)
                    (cd "$DIR" && echo "Git instance under $DIR is terminated.")
                done
                echo
                echo "Done."
                echo
                break
                ;;
            "Quit")
                echo
                echo "Goodbye."
                echo
                exit
                ;;
            *) 
                echo
                echo "$REPLY is an invalid option. Select '1 - 4'" >&2
                echo
                break
                ;;
        esac
    done
done