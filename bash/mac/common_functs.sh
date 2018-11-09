#! /bin/bash

# --------------------------------------------------------------------------------
# Color codes for printf
#   Usage: printf "${red}this is red${reset}\n"

bold='\033[1m'
reset='\033[m'

blue='\033[34m'
cyan='\033[36m'
green='\033[32m'
magenta='\033[35m'
red='\033[31m'
yellow='\033[33m'


# --------------------------------------------------------------------------------

function cp_or_die() {
  local from=$1
  local to=$2
  test ! -f $from && println_red "'$from' is not found!!!" && exit 1
  cp -v $from $to || ( println_red "ERROR: failed to copy '$from' to '$to'" && exit 1 )
}

function display_elapsed_time() {
  started_secs=$1
  message="$2"

  started=`date -r $((started_secs)) "+%H:%M:%S"`
  finished=`date "+%H:%M:%S"`
  finished_secs=`date "+%s"`
  [ "$message" != "" ] && println_green "\n$message"
  println_green "$started started   ($started_secs secs)"
  println_green "$finished finished  ($finished_secs secs)"
  s=$(($finished_secs-$started_secs))
  # TODO: this hack fixes my timezone. it needs to be fixed for real. this version is NOT a keeper.
  # TODO: my timezone is GMT+5h (which is 18000 seconds).
  s1=$(($finished_secs-$started_secs+18000))
  println_green "`date -r $s1 "+%H:%M:%S"` elapses   ($s secs)"
}

# Usage:
#   x=`get_input "Enter something: [$some_default]" "$some_default"`
function get_input () {
  local prompt=$1
  local default_response=$2

  read -p "$prompt" response
  if [ ${#response} -eq 0 ]; then
    response=$default_response
  fi
  echo $response
}

function print_blue() {
  printf "${blue}$1${reset}"
}

function print_cyan() {
  printf "${cyan}$1${reset}"
}

function print_green() {
  printf "${green}$1${reset}"
}

function print_header() {
  print_separator_hr
  println_cyan "${1}\n"
}

function print_magenta() {
  printf "${magenta}$1${reset}"
}

function print_red() {
  printf "${red}$1${reset}"
}

function print_separator_colons() {
  printf "\n    :::::::\n"
}

function print_separator_hr() {
  printf "\n\n--------------------------------------------------------------------------------\n\n"
}

function print_separator_hr2() {
  printf "\n             ------------\n\n"
}

function print_yellow() {
  printf "${yellow}$1${reset}"
}

function println() {
  printf "$1\n"
}

function println_blue() {
  print_blue "$1\n"
}

function println_cyan() {
  print_cyan "$1\n"
}

function println_green() {
  print_green "$1\n"
}

function println_magenta() {
  print_magenta "$1\n"
}

function println_red() {
  print_red "$1\n"
}

function println_yellow() {
  print_yellow "$1\n"
}

function run_it() {
  println_green "COMMAND: $1"
  eval $1 || exit 1
}

function run_it_ignore_failure() {
  println_green "COMMAND: $1"
  eval $1 || println_yellow "    **** COMMAND FAILED. run_it_ignore_failure will continue processing. status = $? ... ****"
}

function verify() {
  local msg="$1" && [ "$msg" == "" ] && msg="Ready to proceed?"
  response=`choose "$msg" "y/n"`
  test "$response" != "y" && println_yellow "  bailing..." && exit 1
  return 0  # lame result to force zero and not trigger exit on "error"
}
