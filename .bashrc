# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# silence ZSH defualt warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# History settings
shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT="%m/%d/%y  %l:%M:%S %p ▏ "

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

## vim as Manual page
export MANPAGER="vim -M +MANPAGER -"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Non-git tracking bash:
# export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
parse_git_branch() {
  MODIFIED=$(git status 2> /dev/null | grep 'Changes not staged for commit' >/dev/null && echo \*)
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1'"$MODIFIED"')/'
}
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]$(parse_git_branch)\[\033[00m\]$ '


################################################################################
####                              aliases                                   ####
alias ls='ls -G'
alias ll='ls -alhFG'
alias la='ls -AG'
alias lsmb='ls -lk | tail -n +2 | awk '\''{print $5/(1024^2)" MiB", $NF}'\'''
alias lsgb='ls -lk | tail -n +2 | awk '\''{print $5/(1024^2)" GiB", $NF}'\'''

alias e='exit'
alias h='history'
alias pwdc='pwd | xclip -selection clipboard && pwd'
alias sb='source ~/.bashrc'

alias eol='vim ~/bin/one_liners.wiki'
alias esc='vim ~/bin/saved_commands.txt'
alias sc='$(saved_commands)'

# basic software
alias bc='bc -l ~/dotfiles/apps/.bcrc'
alias tmux='tmux -2'
alias dact='conda deactivate'
alias lab='jupyter-lab'

# full paths
lll() {
  if [ -z "$*" ];
  then # or use `realpath *` but doesn't capture dotfiles
    ls -rd1 "$PWD"/{*,.*};
  else
    realpath $*;
  fi
}

## fzf and ripgrep (rg)
## https://github.com/junegunn/fzf#usage
##     ignored rg files in .rgignore
#alias vimf='vim $(fzf -m --height 60%)'   # to start up vim with fzf
#export FZF_DEFAULT_COMMAND='rg --files --smart-case --follow --no-hidden'
#export FZF_COMPLETION_TRIGGER='--'
#source /usr/share/doc/fzf/examples/key-bindings.bash
#source /usr/share/doc/fzf/examples/completion.bash

# fzf saved commands and filter comments
saved_commands() {
  sed_command="sed 's/#.*$//;/^$/d'"
  com_base="tac ~/bin/saved_commands.txt 2> /dev/null | fzf +m"
  eval $com_base | eval $sed_command
}
bind '"\C-f": "$(saved_commands)\e\C-e\er\e^"'


# assorted bash bindings
#   ctrl-y to send current line into history
# bind '"\C-y"':"\"\C-ahistory -s '\C-e'\C-m\""
# pwd | xclip -selection clipboard

# fzf conda activate
act() {
  local envs
  envs=$(cat ~/.conda/environments.txt 2> /dev/null | fzf +m) &&
  conda activate "$envs"
  }

# fzf tmux attach -t
ta() {
  local window
  window=$(tmux ls -F '#{session_name}' 2> /dev/null | fzf +m) &&
  tmux attach -t "$window"
  }

#  https://medium.com/@_ahmed_ab/crazy-super-fast-fuzzy-search-9d44c29e14f
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d  -print 2> /dev/null | fzf +m) &&
  cd "$dir"
  }

# Petar Marinov, http:/geocities.com/h2428
# This function defines a 'cd' replacement function capable of keeping,
# displaying and accessing history of visited directories, up to 10 entries.
# Usage 'cd --' to list directories, cd -# to change directory
xcd_func ()
 {
   local x2 the_new_dir adir index
   local -i cnt
   if [[ $1 ==  "--" ]]; then
     dirs -v
     return 0
   fi
   the_new_dir=$1
   [[ -z $1 ]] && the_new_dir=$HOME
   if [[ ${the_new_dir:0:1} == '-' ]]; then
     # Extract dir N from dirs
     index=${the_new_dir:1}
     [[ -z $index ]] && index=1
     adir=$(dirs +$index)
     [[ -z $adir ]] && return 1
     the_new_dir=$adir
   fi
   # '~' has to be substituted by ${HOME}
   [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"
   # Now change to the new dir and add to the top of the stack
   pushd "${the_new_dir}" >/dev/null
   [[ $? -ne 0 ]] && return 1
   the_new_dir=$(pwd)
   # Trim down everything beyond 11th entry
   popd -n +11 2>/dev/null 1>/dev/null
   # Remove any other occurence of this dir, skipping the top of the stack
   for ((cnt=1; cnt <= 10; cnt++)); do
     x2=$(dirs +${cnt} 2>/dev/null)
     [[ $? -ne 0 ]] && return 0
     [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
     if [[ "${x2}" == "${the_new_dir}" ]]; then
       popd -n +$cnt 2>/dev/null 1>/dev/null
       cnt=cnt-1
     fi
   done
   return 0
 }

cd_func()
{
  # this is relatively wasteful to see if it is going to work
  ( builtin cd "$@" >/dev/null 2>&1 )
  badcd=$?
  dir="$1"
  # see if we are really changing
  if [ -z "$1" ] ; then   # special case: no argument
  	dir=~
  fi
  if [[ "$1" == "-" ]] ; then  # special case: cd -
    dir="$OLDPWD"
  fi
  if [[ "$1" ==  "--" ]]; then  # special case: cd -- (list dirs)
	  xcd_func --
	  return $?
  fi
  if [[ "$1" == "---" ]] ; then  # special case: cd --- for fzf directory search
	  fd
    return $?
  fi
  if [ $badcd == 0 ]  # if we have a real place to go, find its inode
  then
	 pwdid=`ls -id .| cut -d ' ' -f 1`
	 newid=`ls -id "$dir" 2>/dev/null | cut -d ' ' -f 1`
  fi
  # if no place to go or we are going to the same place, just execute it and be done
  if [[ $badcd == 1 || $pwdid == $newid ]]; then
    xcd_func "$@"
    return $?
  fi
  # if .env.sh in current directory or .., call it
  if [ -f .env.sh ] ; then
    source .env.sh leave dir "$PWD"
  elif [ -f ../.env.sh ] ; then
    source ../.env.sh leave child "$PWD"
  fi
  # switch
  xcd_func "$@"
  rv=$?
  # if .env.sh in new directory or .., call it
  if [ -f .env.sh ] ; then
    source .env.sh enter dir "$PWD"
  elif [ -f ../.env.sh ] ; then
    source ../.env.sh enter child "$PWD"
  fi
  return $rv
}
alias cd=cd_func
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# paths
PATH=$PATH:~/bin
#export PATH="home/stephen/.local/bin:$PATH"


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
