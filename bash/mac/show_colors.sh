#! /bin/bash

. $SBARKER0_UTILS_BASH_MAC/common_functs.sh


# ------------------------------------------------------------------------------

# make sure this always matches common.rb
printf         "${red}red        error                     ${reset}\n"
printf      "${yellow}yellow     warning                   ${reset}\n"
printf       "${green}green      info: success             ${reset}\n"
printf        "${cyan}cyan       info: general             ${reset}\n"
printf     "${magenta}magenta    input request             ${reset}\n"
printf        "${blue}blue                                 ${reset}\n"
printf        "${bold}bold                                 ${reset}\n"
printf  "${bold}${red}bold red                             ${reset}\n"
printf "${bold}${cyan}bold cyan                            ${reset}\n"
