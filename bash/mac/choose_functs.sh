#! /bin/bash

. $SBARKER0_UTILS_BASH_MAC/common_functs.sh


# ------------------------------------------------------------------------------
# defaults

# n/a


# ------------------------------------------------------------------------------
# functions

function build_options_str() {
  local choices="$1"
  local result=""

  local remaining=`clean_choices $choices`
  while [ ${#remaining} -gt 0 ]; do
    local curr=`echo $remaining | sed "s/,.*//"`
    local remaining=`echo $remaining | sed "s/$curr,*//"`
    local letter=`echo $curr | sed "s/.*(//" | sed "s/).*//"`
    if [ "${#letter}" != "1" ]; then
      local letter=${curr:0:1}
    fi
    local result="$result$letter"
  done
  echo $result
}

function calc_default_response() {
  local options_str=$1
  local current_default=$2
  if [ ${#current_default} -eq 0 ] ; then
    local new_default=${options_str:0:1}
  else
    local new_default=$current_default
  fi
  echo $new_default
}

function clean_choices() {
  echo $1 | sed "s/'//g" | sed 's/"//g' | sed "s|/|,|g"
}

function convert_response_to_choice() {
  local choices=$1
  local options_str=$2
  local response=$3

  local s=`echo $options_str | sed "s/${response}.*//"`
  local response_index=${#s}
  clean_choices $choices | sed -e "s/\([^,]*,\)\{$response_index\}\([^,]*\).*/\\2/" | sed -e "s/[()]//g"
}

function is_response_valid() {
  local options_str=$1
  local response=$2

  s=`echo $options_str | grep $response`
  [ ${#s} -gt 0 ] && echo true && return
  echo false
}


# ------------------------------------------------------------------------------
# options and args

# n/a


# ------------------------------------------------------------------------------
# work

# n/a
