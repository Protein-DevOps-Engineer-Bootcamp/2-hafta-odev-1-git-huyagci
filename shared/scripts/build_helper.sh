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

BUILD="mvn package"
USAGE_MSG="
    Usage: $(basename $0) [OPTIONS]
    
    OPTIONS:
    -b      <branch_name>       Branch name
    -n      <new_branch>        Create new branch
    -f      <zip|tar>           Compress format
    -p      <artifact_path>     Copy artifact to spesific path
"
