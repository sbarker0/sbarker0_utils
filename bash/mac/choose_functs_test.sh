#! /bin/bash

. $SBARKER0_UTILS_BASH_MAC/test_functs.sh
. $SBARKER0_UTILS_BASH_MAC/choose_functs.sh


# ------------------------------------------------------------------------------

println_green "\n--------------------------------------------------------------------------------"
test_it 'build_options_str "apple,bananna,cherry"' abc
test_it 'build_options_str "apple/bananna/cherry"' abc
test_it 'build_options_str "a(p)ple/b(a)nanna/c(h)erry"' pah
test_it 'build_options_str "a(p)ple/bananna/cherry"' pbc

println_green "\n--------------------------------------------------------------------------------"
test_it 'calc_default_response abc' a
test_it 'calc_default_response abc a' a
test_it 'calc_default_response abc b' b

println_green "\n--------------------------------------------------------------------------------"
test_it 'clean_choices "apple,bananna,cherry"' "apple,bananna,cherry"
test_it 'clean_choices "apple/bananna/cherry"' "apple,bananna,cherry"
test_it 'clean_choices "abc"' "abc"
test_it 'clean_choices "yes/no"' "yes,no"

println_green "\n--------------------------------------------------------------------------------"
test_it 'is_response_valid abc a' true
test_it 'is_response_valid abc x' false

println_green "\n--------------------------------------------------------------------------------"
test_it 'convert_response_to_choice "apple,bananna,cherry" abc a' apple
test_it 'convert_response_to_choice "apple/bananna/cherry" abc b' bananna
test_it 'convert_response_to_choice "apple/bananna/c(h)erry" abh h' cherry
test_it 'convert_response_to_choice "yes/no" yn y' yes

# println_red "\n--------------------------------------------------------------------------------"
# choose "What do you want to throw?" apple/bananna/cherry b
# choose
