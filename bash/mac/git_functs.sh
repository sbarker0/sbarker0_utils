#! /bin/bash

function git_get_current_branch()
{
  git br | grep "*" | sed "s/\* //"
}

function git_get_remote_name()
{
  git remote | grep "origin"
}

function git_get_repo_name()
{
  remote=`git_get_remote_name`
  git remote -v | grep "`git_get_remote_name`.*fetch" | sed "s!.*/!!" | sed "s/\..*//" | sed "s/ .*//"
}
