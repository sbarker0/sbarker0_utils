#! /bin/bash

set -e   # terminate script on error

. $SBARKER0_UTILS_BASH_MAC/common_functs.sh


# ------------------------------------------------------------------------------
# defaults

todo_an_option=some_value
todo_another_option=false
quiet_mode=false


# ------------------------------------------------------------------------------
# functions

function die_usage() {
  cat >&2 <<EOS

<todo: Does something.> Run the script in <todo: whatever> directory.

Usage:
  todo_script_name.sh [options] <todo_argument>

  options:
    -q            flip quiet mode (skips confirmation)  [default = $quiet_mode]
    -x <blah>     blah                                  [default = $todo_an_option]
    -y            blah                                  [default = $todo_another_option]

  examples:
    todo_script_name.sh blah      # produces whatever
EOS
  exit 1
}


# ------------------------------------------------------------------------------
# confirm env requirements

x=$SBARKER0_UTILS
[ "$x" == "" ] && printf "ERROR: env variable SBARKER0_UTILS is required\n" && die_usage


# ------------------------------------------------------------------------------
# options and args

while getopts ":qx:y" opt; do
  case $opt in
    q)  quiet_mode=true ;;
    x)  todo_an_option=$OPTARG ;;
    y)  todo_another_option=true ;;
    \?) die_usage ;;
  esac
done
shift $((OPTIND-1))

test $# -lt 1 && println_red "\nERROR: todo_argument is required\n" && die_usage
todo_argument=$1


# ------------------------------------------------------------------------------
# user confirmation

cat >&1 <<EOS

  todo_an_option      = $todo_an_option
  todo_another_option = $todo_another_option
  quiet_mode          = $quiet_mode

  todo_argument       = $todo_argument


EOS
$quiet_mode || verify


# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# work starts here

# ------------------------------------------------------------------------------
println_cyan "running step 1"

  println_yellow "work goes here : remember to use color conventions in show_colors.sh"
  show_colors.sh


# ------------------------------------------------------------------------------
println_cyan "running step 2"

  println_yellow "work goes here : remember to use color conventions in show_colors.sh"
  show_colors.sh


# ------------------------------------------------------------------------------
println_cyan "$0: normal successful completion"

  # println_red "bailing" && exit 1
