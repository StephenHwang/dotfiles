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

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# command line prompt colors
PS1="\[\e[32m\]\u@\h:\[\e[m\]\[\e[31m\]\w\[\e[m\]\$ "

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# auto-start a tmux session on terminal open
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias c='clear'
alias e='exit'
alias h='history'
#alias rm='/bin/rm -i' # alias for checking removing files
alias tmux='tmux -2'
alias pwdc='pwd | xclip -selection clipboard && pwd'

alias popen='mimeopen'
#alias python='python3.8'
#alias ipython='python3.8 -m IPython'
#alias anaconda3='anaconda'
alias classdir='cd /home/stephen/Documents/classes/'
alias pip='pip3'
alias igv='/home/stephen/bin/IGV_Linux_2.8.6/igv.sh'
alias cursor='/home/stephen/bin/find-cursor/find-cursor --repeat 0 --follow --distance 1 --line-width 16 --size 16 --color red'

# clear and ls
cls() { clear && ls; }

# jupyter notebook
alias sshc='ssh sjhwang@courtyard.gi.ucsc.edu' # alias for ssh
alias sshcport='ssh -X -N -f -L localhost:9999:localhost:9999 sjhwang@courtyard.gi.ucsc.edu'
alias ports='netstat -ntlp | grep LISTEN'
alias portc='ssh -X -N -f -L localhost:9999:localhost:9999 sjhwang@courtyard.gi.ucsc.edu'
alias portk='kill $(ports | grep -o '[0-9]*/ssh' | rev | cut -c5- | rev)'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

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

# countdown in mintues with announcement
function countdown(){
   date1=$((`date +%s` + $1*60)); 
   while [ "$date1" -ge `date +%s` ]; do 
     echo -ne "$(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
     sleep 0.1
   done
   espeak "$1"
   espeak "minutes counted"
   stopwatch
}

function stopwatch(){
  date1=`date +%s`; 
   while true; do 
    echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r"; 
    sleep 0.1
   done
}

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

#export PYTHONPATH="${PYTHONPATH}:/home/stephen/.local/lib/python3.8/site-packages/python_codon_tables"
#export PYTHONPATH="${PYTHONPATH}:/home/stephen/.local/lib/python3.8/site-packages"

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

# uncomment for original cd
alias cd=cd_func

