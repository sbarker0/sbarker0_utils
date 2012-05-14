#! /bin/bash

. $SBARKER0_UTILS_MAC_BASH/common_functs.sh


# ------------------------------------------------------------------------------

function test_it()
{
  local the_command="$1"
  local expected="$2"

  printf "TESTING: $the_command\t"
  actual=`${the_command}`
  if [ "$expected" == "$actual" ]; then
    println_green "passed"
  else
    println_red "failed"
    printf "  EXPECTED: $expected\n"
    printf "  ACTUAL:   $actual\n"
  fi
}
