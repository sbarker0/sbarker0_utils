#! /bin/bash

set -e   # terminate script on error

# ASSUME CALLER ALREADY INCLUDED THIS
# available from https://github.com/sbarker0/sbarker0_utils if someone is interested
# . $SBARKER0_UTILS_BASH_MAC/common_functs.sh


# ------------------------------------------------------------------------------
# functions

function rsync_funcs_info() {
  cat >&2 <<EOS

Handy rsync functs to be used from other scripts to copy files and dirs to target locations

Script is intended to fail on error. Caller should be careful about changing
"set -e". This script was not tested for good behavior beyond that

Assumes caller already included SBARKER0_UTILS_BASH_MAC/common_functs.sh

EOS
  exit 1
}


function rsyncFiles() {
  # WARNING: THIS STUFF IS SUPER FINICKY AND FRAGILE. IF CHANGES ARE NEEDED,
  # MAKE SURE ALL THE OLD STUFF CONTINUES TO WORK. SERIOUSLY. THIS IS BAD!

  printf "\n\n"

  copyFiles_from="$1"
  copyFiles_to="$2"

  # println_cyan "debug\ncopyFiles_from = '$copyFiles_from'\ncopyFiles_to   = '$copyFiles_to'"
  # verify  #debug

  test "$copyFiles_from" == "" && rsync_functs__fail "rsync_functs.rsyncFiles requires <copyFiles_from> arg"
  test "$copyFiles_to"   == "" && rsync_functs__fail "rsync_functs.rsyncFiles requires <copyFiles_to> arg"

  if [ -d "$copyFiles_from" ] || [ -f "$copyFiles_from" ]; then
    test -d "$copyFiles_to"  ||  mkdir -p "$copyFiles_to"

    c="rsync  -av  '${copyFiles_from}'  '${copyFiles_to}'"
    printf "${green}command: " ; echo $c ; printf "${reset}\n"  # the quotes really bork printf....
    # verify #debug
    eval $c
  else
    # check for wild cards and loop
    #  ls both ways to deal with spaces OR wildcards -- I can't see how to handle both...
    x=`ls $copyFiles_from` || x=`ls "$copyFiles_from"` || x=""
    if [ "$x" != "" ]; then
      println_cyan "looping through ${copyFiles_from}..."
      # verify #debug
      # WARNING: THIS DOES NOT DEAL WITH SPACES IN FILE NAMES
      for file in `ls $copyFiles_from`; do
        rsyncFiles "$file" "$copyFiles_to"
      done
      println_cyan "...loop complete"
    else
      println_yellow "\nfile not found, rsync_functs.rsyncFiles ignored:  $copyFiles_from\n"
    fi
  fi
}


function rsyncFileOrDirIfExist() {
  copyFiles_from="$1"
  copyFiles_to="$2"

  if [ -e "$copyFiles_from" ]; then
    rsyncFiles "$copyFiles_from" "$copyFiles_to"
  else
    printf "\n\n"
    println_cyan "File not found, backup skipped: $copyFiles_from"
  fi
}


function rsync_functs__fail() {
  printf "${red}ERROR: $1${reset}\n"
  exit 1
}
