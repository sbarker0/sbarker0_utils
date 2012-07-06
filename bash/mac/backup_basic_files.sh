#! /bin/bash

. $SBARKER0_UTILS_BASH_MAC/common_functs.sh


# ------------------------------------------------------------------------------
# defaults

quiet_mode=true


# ------------------------------------------------------------------------------
# functions

function die_usage() {
  cat >&2 <<EOS

Backup basic files on my macs. This is the generic part run daily on each of my mac machines.

Usage:
  backup_basic_files.sh [options]

  options:
    -q            flip quiet mode (skips confirmation)  [default = $quiet_mode]
EOS
  exit 1
}

function sudo_cp() {
  local from=$1
  local to=$2
  test ! -f "$from" && println_red "'$from' is not found!!!" && exit 1
  test ! -d "$to" && mkdir -p $to
	test ! -d "$to" && println_red "mkdir '$to' failed" && exit 1
  sudo cp -v "$from" "$to" || println_red "ERROR: failed to copy '$from' to '$to'"
}

function sudo_cp_dir() {
  local from=$1
  local to=$2
  test ! -d "$from" && println_red "'$from' is not found!!!" && exit 1
  test ! -d "$to" && mkdir -p $to
	test ! -d "$to" && println_red "mkdir '$to' failed" && exit 1
  sudo cp -rv "$from" "$to" || println_red "ERROR: failed to copy '$from' to '$to'"
}


# ------------------------------------------------------------------------------
# confirm env requirements

target_dir=$PERSONAL_BACKUP_TARGET
[ "$target_dir" == "" ] && println_red "ERROR: env variable PERSONAL_BACKUP_TARGET is required" && die_usage


# ------------------------------------------------------------------------------
# options and args

while getopts ":q" opt; do
  case $opt in
    q)  quiet_mode=false ;;
    \?) die_usage ;;
  esac
done
shift $((OPTIND-1))


# ------------------------------------------------------------------------------
# user confirmation

cat >&2 <<EOS

  target_dir = $target_dir


EOS
$quiet_mode || verify


# ------------------------------------------------------------------------------
# work

println "Several files are copied using sudo so local admin password is required."

d=/private/etc/apache2
sudo_cp 		$d/httpd.conf            	$target_dir/$d/
sudo_cp			$d/extra/httpd-ssl.conf		$target_dir/$d/extra/

d=/etc
sudo_cp 		$d/hosts            			$target_dir/$d/
sudo_cp 		$d/profile          			$target_dir/$d/

d=$HOME
sudo_cp			$d/.bash_profile         	$target_dir/$d/
sudo_cp			$d/.bashrc                $target_dir/$d/
sudo_cp			$d/.gitconfig             $target_dir/$d/
sudo_cp_dir	$d/.ssh                   $target_dir/$d/
sudo_cp			$d/Documents/*.tmproj     $target_dir/$d/Documents/

d="$HOME/Library/Application Support/TextMate/Themes/"
sudo_cp_dir "$d"                    	"$target_dir/"

# just backup the lists of some stuff
ls -la ~/third_party_tools | grep -v " \.*$"          > $target_dir/$HOME/ls_third_party_tools.txt
brew list -v                                          > $target_dir/$HOME/brew_list.txt

u=`echo $HOME | sed s,/Users/,,`
run_it "sudo chown -vR $u:staff $target_dir"
