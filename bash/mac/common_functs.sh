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

  started=`date -r $((started_secs)) "+%H:%M:%S"`
  finished=`date "+%H:%M:%S"`
  finished_secs=`date "+%s"`
  println_green "$started started   ($started_secs secs)"
  println_green "$finished finished  ($finished_secs secs)"
  s=$(($finished_secs-$started_secs))
  println_green "`date -r $s "+%H:%M:%S"` elapses   ($s secs)"
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

function print_magenta() {
  printf "${magenta}$1${reset}"
}

function print_red() {
  printf "${red}$1${reset}"
}

function print_yellow() {
  printf "${yellow}$1${reset}"
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
  eval $1
}

function verify() {
  response=`choose "Ready to proceed?" "y/n"`
  test "$response" != "y" && exit 1
}
