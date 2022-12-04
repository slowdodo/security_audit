#!/bin/bash

# path to the Apache access log file
LOG_FILE=""

# function to print the help message
print_help() {
    echo "Usage: $0 [OPTION]..."
    echo "Watch the Apache access log in real-time."
    echo
    echo "  -h, --help      show this help message and exit"
    echo "  -l, --log-file  path to the Apache access log file"
}

# parse command line arguments using getopt
# "hl:" indicates that the options -h and -l require no arguments, and -f takes one argument
# the colon after the option letter indicates that the option takes an argument
# "hlf:" specifies the order in which the options should be processed
# the option string is followed by a colon and the name of the variable that will hold the remaining arguments
# in this case, the variable "remaining" will hold all arguments after the options have been processed
ARGS=$(getopt -o hl: -l help,log-file: --name "$0" -- "$@")

# check if getopt was successful
if [ $? -ne 0 ]; then
    # getopt failed, so print the error message and exit
    exit 1
fi

# set the command line arguments to the values that getopt parsed
eval set -- "$ARGS"

# process the command line arguments
while true; do
    case "$1" in
        # print the help message and exit
        -h|--help)
            print_help
            exit
            ;;

        # set the log file path
        -l|--log-file)
            LOG_FILE="$2"
            shift
            shift
            ;;

        # no more options
        --)
            shift
            break
            ;;
    esac
done

# check if the log file path was provided
if [ -z $LOG_FILE ]; then
    # log file path was not provided, so print the error message and exit
    echo "Error: log file path was not provided."
    echo "Use the -h or --help option for usage information."
    exit 1
