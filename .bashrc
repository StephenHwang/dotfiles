# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT="%l:%M:%S %p ▏ "

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# pattern "**" used in a pathname expansion matches all files and directories
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# command line prompt colors with git directory
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]$(parse_git_branch)\[\033[00m\]$ '

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto --group-directories-first'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# vim as Manual page
export MANPAGER="vim -M +MANPAGER -"

# ibus
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODUlE=ibus

# auto-start a tmux session on terminal open
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi

# some more ls aliases
alias ll='ls -alF --group-directories-first'
alias la='ls -A --group-directories-first'
alias l='ls -CF --group-directories-first'
alias lsmb='ls -l --block-size=M'
alias lsgb='ls -l --block-size=G'

alias c='clear'
alias e='exit'
alias h='history'
alias plz='sudo $(fc -nl -1)'

alias tmux='tmux -2'
alias pwdc='pwd | xclip -selection clipboard && pwd'
alias ipython='ipython --no-autoindent'
alias tasks='task'

alias popen='mimeopen -a'
alias classdir='cd /home/stephen/Documents/classes/'
alias pip='pip3'
alias igv='/home/stephen/bin/IGV_Linux_2.8.6/igv.sh'
alias cursor='/home/stephen/bin/find-cursor/find-cursor --repeat 0 --follow --distance 1 --line-width 16 --size 16 --color red'
alias pycharm='pycharm-community'
alias lab='jupyter-lab'
alias ApE='wine /home/stephen/bin/ApE/ApE_win_current.exe'

alias sshc='ssh sjhwang@courtyard.gi.ucsc.edu' # alias for ssh
alias sshcport='ssh -X -N -f -L localhost:9999:localhost:9999 sjhwang@courtyard.gi.ucsc.edu'
alias ports='netstat -ntlp | grep LISTEN'
alias portc='ssh -X -N -f -L localhost:9999:localhost:9999 sjhwang@courtyard.gi.ucsc.edu'
alias portk='kill $(ports | grep -o '[0-9]*/ssh' | rev | cut -c5- | rev)'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# tmux and git autocompletion
source /home/stephen/bin/tmux-completion/tmux
source /home/stephen/bin/git-completion.bash

# paths
PATH=$PATH:~/bin
export PATH="home/stephen/.local/bin:$PATH"
export PATH="home/stephen/.local/bin/IGV_Linux_2.8.6/:$PATH"
export PATH="/home/stephen/anaconda3/bin/:$PATH"
export PATH="/home/stephen/Downloads/netextender/try/netExtenderClient/:$PATH"
export PATH="/home/stephen/bin/Zotero_linux-x86_64/:$PATH"
export PATH="/home/stephen/bin/pymol/:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/stephen/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/stephen/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/stephen/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/stephen/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
conda deactivate
# <<< conda initialize <<<

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
    if [[ "$1" == "---" ]] ; then  # special case: cd --- for fzf directory search
	    fd 
      return $?
    fi
    if [[ "$1" ==  "--" ]]; then  # special case: cd -- (list dirs)
	     xcd_func --
	     return $?
    fi
    if [ $badcd == 0 ]  # if we have a real place to go, find its inode
    then
	   pwdid=`ls -id .| cut -d ' ' -f 1`
	   newid=`ls -id "$dir" 2>/dev/null |cut -d ' ' -f 1`
    fi
# if no place to go or we are going to the same place, just execute it and be done
   if [[ $badcd == 1 || $pwdid == $newid ]]; then xcd_func "$@" ; return $? ; fi
# if .env.sh in current directory or .., call it
   if [ -f .env.sh ]
   then source .env.sh leave dir "$PWD"
   elif [ -f ../.env.sh ]
   then source ../.env.sh leave child "$PWD"
   fi
# switch
   xcd_func "$@"
   rv=$?
# if .env.sh in new directory or .., call it
   if [ -f .env.sh ]
   then source .env.sh enter dir "$PWD"
   elif [ -f ../.env.sh ]
   then source ../.env.sh enter child "$PWD"
   fi
   return $rv
}
alias cd=cd_func

# fzf and ripgrep (rg)
# export FZF_DEFAULT_COMMAND='find * -type f' # if no rg or ag
# https://github.com/junegunn/fzf#usage
#     ignored rg files in .rgignore
alias vimf='vim $(fzf -m --height 60%)'   # to start up vim with fzf
export FZF_DEFAULT_COMMAND='rg --files --smart-case --follow --no-hidden'
export FZF_COMPLETION_TRIGGER='--'
source /usr/share/doc/fzf/examples/key-bindings.bash
source /usr/share/doc/fzf/examples/completion.bash

