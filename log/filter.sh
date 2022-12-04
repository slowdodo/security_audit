#!/bin/bash

# the log file to filter
LOG_FILE=""

# the string to search for in the log file
SEARCH_STRING=""

# function to print the help message
print_help() {
    echo "Usage: $0 [OPTION]..."
    echo "Filter a Linux log file for a specific string using awk."
    echo
    echo "  -h, --help          show this help message and exit"
    echo "  -l, --log-file      the log file to filter"
    echo "  -s, --search-string the string to search for in the log file"
}

# parse command line arguments using getopt
# "hl:s:" indicates that the options -h and -l require no arguments, and -f and -s take one argument
# the colon after the option letter indicates that the option takes an argument
# "hls:" specifies the order in which the options should be processed
# the option string is followed by a colon and the name of the variable that will hold the remaining arguments
# in this case, the variable "remaining" will hold all arguments after the options have been processed
ARGS=$(getopt -o hl:s: -l help,log-file:,search-string: --name "$0" -- "$@")

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

        # set the search string
        -s|--search-string)
            SEARCH_STRING="$2"
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

# check if a log file and search string were provided
if [ -z "$LOG_FILE" ] || [ -z "$SEARCH_STRING" ]; then
    # log file or search string not provided, so print the help message and exit
    print_help
    exit 1
fi

# filter the log file using awk
awk -v search="$SEARCH_STRING" '$0 ~ search' "$LOG_FILE"
