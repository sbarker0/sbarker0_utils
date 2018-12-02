#! /bin/bash

function git_get_current_branch()
{
  git branch | grep "*" | sed "s/\* //"
}


# return origin if it exists, otherwise, one of the remotes
function git_get_remote_name()
{
  r=
  for x in `git remote`; do
    r=$x
    if [ "$x" == "origin" ]; then
      break
    fi
  done
  if [ "$r" != "" ]; then
    echo $r
  fi
}


function git_get_repo_name()
{
  remote=`git_get_remote_name`
  git remote -v | grep "`git_get_remote_name`.*fetch" | sed "s!.*/!!" | sed "s/\..*//" | sed "s/ .*//"
}
