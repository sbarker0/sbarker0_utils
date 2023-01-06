#! /bin/bash

# set -e   # terminate script on error

. $SBARKER0_UTILS_BASH_MAC/common_functs.sh


# ------------------------------------------------------------------------------
# defaults

force=false
git_dir=
max_lines=50
quiet_mode=true
skip_leading_chars=false


# ------------------------------------------------------------------------------
# functions

function die_usage() {
  cat >&2 <<EOS

In a text file, replace leading tabs with spaces and strip trailing spaces from lines.

Usage:
  cleanup_whitespace.sh [options] [<filespec>]

  options:
    -f            force cleanup even if it will affect more than $max_lines
    -g <dir>      process modified and new files shown by 'git status <dir>'
    -l            skip leading chars [default = $skip_leading_chars]
    -q            flip quiet mode (skips confirmation)  [default = $quiet_mode]

  examples:
    cleanup_whitespace.sh /tmp/somefile.txt
    cleanup_whitespace.sh -g <dir> -l
EOS
  exit 1
}


function processFile() {
  filespec=$1

  println_cyan "processing ${filespec}"

  if [ ! -f "$filespec" ]; then
    # bail on a dir or a file with a space in the name
    println_red "\nERROR: $filespec is not a file\n" && die_usage
  fi

  filename=`basename ${filespec}`
  ext="${filename##*.}"
  if  [ 0 == 1 ]                  \
      || [ "${ext}" == 'bz' ]     \
      || [ "${ext}" == 'class' ]     \
      || [ "${ext}" == 'doc' ]    \
      || [ "${ext}" == 'docx' ]   \
      || [ "${ext}" == 'gliffy' ]  \
      || [ "${ext}" == 'gnucash' ]  \
      || [ "${ext}" == 'jar' ]    \
      || [ "${ext}" == 'jpg' ]    \
      || [ "${ext}" == 'less' ]   \
      || [ "${ext}" == 'ofx' ]    \
      || [ "${ext}" == 'pdf' ]    \
      || [ "${ext}" == 'png' ]    \
      || [ "${ext}" == 'tar' ]    \
      || [ "${ext}" == 'tiff' ]   \
      || [ "${ext}" == 'xls' ]    \
      || [ "${ext}" == 'xlsx' ]   \
      || [ "${ext}" == 'zip' ]    \
      || [ "${filename}" == 'gradle/' ]        \
      || [ "${filename}" == 'gradlew' ]        \
      || [ "${filename}" == 'gradlew.bat' ]    \
           ; then
    println_yellow "${filespec} is recognized as non-text. Skipping."
  else
    if [ 0 != 1 ]                         \
          && [ "${ext}" != "css" ]        \
          && [ "${ext}" != "csv" ]        \
          && [ "${ext}" != 'gitignore' ]  \
          && [ "${ext}" != "go" ]         \
          && [ "${ext}" != 'gradle' ]     \
          && [ "${ext}" != 'groovy' ]     \
          && [ "${ext}" != "html" ]       \
          && [ "${ext}" != "java" ]       \
          && [ "${ext}" != "js" ]         \
          && [ "${ext}" != "json" ]       \
          && [ "${ext}" != "md" ]         \
          && [ "${ext}" != "properties" ] \
          && [ "${ext}" != "scss" ]       \
          && [ "${ext}" != "sh" ]         \
          && [ "${ext}" != "sql" ]        \
          && [ "${ext}" != "swagger-codegen-ignore" ] \
          && [ "${ext}" != "ts" ]         \
          && [ "${ext}" != "txt" ]        \
          && [ "${ext}" != "xml" ]        \
          && [ "${ext}" != "yml" ]        \
          && [ "${ext}" != "yaml" ]       \
          ; then
      println_yellow "${filespec} has unrecognized extension. Process anyway?"
      verify
    fi
    stripTrailing ${filespec}
    if [ ! $skip_leading_chars ]; then
      println_red "clearing leading tabs" && exit 1

      replaceLeadingTabs ${filespec}
    fi
    stripSpacesFromEmptyLines ${filespec}
  fi
}


function replaceLeadingTabs() {
  filespec=$1

  println_cyan "  replacing leading tabs"

  grep_regex="^( *)\\t([^\\t ]*)"

  count=`cat ${filespec} | grep -E -c "${grep_regex}"`
  println "    count = $count"

  do_it=0  # true
  if [ $count -eq 0 ]; then
    do_it=1
  else
    if [ $count -le $max_lines ]; then
      println "    less than max lines $max_lines"
    else
      if [ "$force" == "true" ]; then
        println "    forcing over max lines $max_lines"
      else
        println_magenta "    max lines exceeded..."
        x=`choose "$count lines contain tab. Do you really want to replace them all?"`
        if [ "$x" == "no" ]; then
          do_it=1
        fi
      fi
    fi
  fi

  if [ $do_it -ne 0 ]; then
    println "    skipping"
  else
    # this is clumsy but effective. i'm assuming there are never more than 50 leading tabs
    for x in {1..50}; do
      # sed handles tab in a weird way. I can't figure out how to share a variable for both grep and sed regex
      sed -E -i "" -e $'s/^( *)\t([^\t ]*)/\\1  \\2/' $filespec
    done
    println "    replaced chars"
  fi
}


function stripSpacesFromEmptyLines() {
  filespec=$1

  println_cyan "  stripping spaces from empty lines"

  grep_regex="^( +)\r"

  count=`cat ${filespec} | grep -E -c "${grep_regex}"`
  println "    count = $count"

  do_it=0  # true
  if [ $count -eq 0 ]; then
    do_it=1
  else
    if [ $count -le $max_lines ]; then
      println "    less than max lines $max_lines"
    else
      if [ "$force" == "true" ]; then
        println "    forcing over max lines $max_lines"
      else
        println_magenta "    max lines exceeded..."
        x=`choose "$count lines contain tab. Do you really want to replace them all?"`
        if [ "$x" == "no" ]; then
          do_it=1
        fi
      fi
    fi
  fi

  if [ $do_it -ne 0 ]; then
    println "    skipped"
  else
    sed -E -i "" -e $'s/^[ \t]+\r/\r/' $filespec
    println "    replaced chars"
  fi
}


function stripTrailing() {
  filespec=$1

  println_cyan "  stripping trailing spaces and tabs"

  grep_regex="( |\\t)+$"

  count=`cat ${filespec} | grep -E -c "${grep_regex}"`
  println "    count = $count"

  do_it=0  # true
  if [ $count -eq 0 ]; then
    do_it=1
  else
    if [ $count -le $max_lines ]; then
      println "    less than max lines $max_lines"
    else
      if [ "$force" == "true" ]; then
        println "    forcing over max lines $max_lines"
      else
        println_magenta "    max lines exceeded..."
        x=`choose "$count lines end in space or tab. Do you really want to strip them all?"`
        if [ "$x" == "no" ]; then
          do_it=1
        fi
      fi
    fi
  fi

  if [ $do_it -ne 0 ]; then
    println "    skipped"
  else
    # sed handles tab in a weird way. I can't figure out how to share a variable for both grep and sed regex
    sed -E -i "" -e $'s/[ \t]+$//' $filespec
    println "    replaced chars"
  fi
}


# ------------------------------------------------------------------------------
# confirm env requirements

x=$SBARKER0_UTILS
[ "$x" == "" ] && printf "ERROR: env variable SBARKER0_UTILS is required\n" && die_usage


# ------------------------------------------------------------------------------
# options and args

while getopts ":fg:lq" opt; do
  case $opt in
    f)  force=true ;;
    g)  git_dir=$OPTARG ;;
    l)  skip_leading_chars=true ;;
    q)  quiet_mode=false ;;
    \?) die_usage ;;
  esac
done
shift $((OPTIND-1))


# ------------------------------------------------------------------------------
# user confirmation

cat >&1 <<EOS

  force               = $force
  quiet_mode          = $quiet_mode
  skip_leading_chars  = $skip_leading_chars

EOS
$quiet_mode || verify


# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# work starts here


# ------------------------------------------------------------------------------

  if [ "${git_dir}" != "" ]; then
    if [ ! -d ${git_dir} ]; then
      println_red "\nERROR: ${git_dir} not found\n" && die_usage
    else
      tmp_file=/tmp/cleanup_whitespace_git.txt
      git status ${git_dir} | tee ${tmp_file}

      # mods=`cat ${tmp_file} | grep modified | sed "s/.*://"`
      # for f in ${mods}; do
      #   processFile ${f}
      # done

      # news=`cat ${tmp_file} | grep 'new file' | sed "s/.*://"`
      # for f in ${news}; do
      #   processFile ${f}
      # done

      # untracked=`cat ${tmp_file} | grep '\t' | grep -v 'modified:'`
      # for f in ${untracked}; do
      #   processFile ${f}
      # done

      files=`cat ${tmp_file} | grep '\t' | grep -v deleted | sed "s/renamed.*>//" | sed "s/.*://"`
      for f in ${files}; do
        processFile ${f}
      done
    fi
  else
    test $# -lt 1 && println_red "\nERROR: filespec is required\n" && die_usage
    processFile $1
  fi


# ------------------------------------------------------------------------------
println_cyan "$0: normal successful completion"

  # println_red "bailing" && exit 1
