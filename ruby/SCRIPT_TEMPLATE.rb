#! /Users/sbarker0/.rvm/rubies/ruby-2.1.2/bin/ruby

# ------------------------------------------------------------------------------
# defaults

some_environment_var = ENV["SOME_ENVIRONMENT_VARIABLE"]


# ------------------------------------------------------------------------------
# functions

def die_usage()
  puts "\n"
  puts "Does something useful...\n"
  puts "\n"
  puts "Usage:\n"
  puts "\n"
  puts "  foo.rb <arg desc> <arg desc>\n"
  puts "\n"
  exit
end


# ----------------------------------------------------------------------------
# options and arguments

first_arg = ARGV[0]

if first_arg == nil
  die_usage()
end


# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------
# work

puts ""

puts "Doing something useful with arg '#{first_arg}' based on env info '#{some_environment_var}'."

puts ""
