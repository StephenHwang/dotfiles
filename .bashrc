# .bashrc for rockfish

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# History settings
shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT="%m/%d/%y  %l:%M:%S %p ▏ "

shopt -s checkwinsize
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Simple
parse_git_branch_and_changes() {
  OUTPUT=$(git status 2> /dev/null | grep 'Changes not staged for commit' >/dev/null && echo \*)
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1'"$OUTPUT"')/'
}
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
which_git_parse() {
  num_tracked_files=$(git ls-files 2> /dev/null | wc -l)
  max_track_files=25

  if [ "$num_tracked_files" -gt "$max_track_files" ]; then
    (parse_git_branch)
  else
    # echo less_than
    (parse_git_branch_and_changes)
  fi
}
# export PS1='\[\033[01;32m\]\u@\[\033[00;31m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$ '  # simple (non-git track)
# export PS1='\[\033[01;32m\]\u@\[\033[00;31m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]$(which_git_parse)\[\033[00m\]$ '
export PS1='\[\033[01;32m\]\u@\[\033[00;31m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]$(parse_git_branch)\[\033[00m\]$ '

# Non-git tracking bash:
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

################################################################################
####                              aliases                                   ####
alias ll='ls -alhF --time-style="+ | %b %e %Y %H:%M |" --group-directories-first'
alias la='ls -A --group-directories-first'
alias lsmb='ls -l --block-size=M'
alias lsgb='ls -l --block-size=G'
alias tree='find . -print | sed -e "s;[^/]*/;|____;g;s;____|; |;g"'
# full paths
lll() {
  if [ -z "$*" ];
  then # or use `realpath *` but doesn't capture dotfiles
    ls -rd1 --group-directories-first "$PWD"/{*,.*};
  else
    realpath $*;
  fi
}



alias e='exit'
alias h='history'
alias tmux='tmux -2'
alias bc='bc ~/dotfiles/apps/.bcrc -l'
alias gs='git status 2> /dev/null'
alias sb='source ~/.bashrc'
alias esc='vim ~/bin/saved_commands.txt'


#####################################################################################

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/shwang45/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/shwang45/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/shwang45/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/shwang45/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
conda deactivate
# <<< conda initialize <<<


# human readable time
function displaytime {
  local T=$1
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  (( $D > 0 )) && printf '%d days ' $D
  (( $H > 0 )) && printf '%d hours ' $H
  (( $M > 0 )) && printf '%d minutes ' $M
  (( $D > 0 || $H > 0 || $M > 0 )) && printf 'and '
  printf '%d seconds\n' $S
}


# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
alias vimf='vim $(fzf -m --height 60%)'   # to start up vim with fzf
export FZF_DEFAULT_COMMAND='find -L "$PWD" -name ".*" -prune -o -print'
export FZF_COMPLETION_TRIGGER='--'

# fzf saved commands and filter comments
saved_commands() {
  sed_command="sed 's/#.*$//;/^$/d'"
  com_base="tac ~/bin/saved_commands.txt 2> /dev/null | fzf +m"
  eval $com_base | eval $sed_command
}
bind '"\C-f": "$(saved_commands)\e\C-e\er\e^"'

#  https://medium.com/@_ahmed_ab/crazy-super-fast-fuzzy-search-9d44c29e14f
fd() {
  local dir
  dir=$(find -L ${1:-.} -path '*/\.*' -prune -o -type d  -print 2> /dev/null | fzf +m) &&
  cd "$dir"
  }

# fzf tmux attach -t
ta() {
  local window
  window=$(tmux ls -F '#{session_name}' 2> /dev/null | fzf +m) &&
  tmux attach -t "$window"
  }

# fzf conda activate
act() {
  local envs
  envs=$(ls ~/miniconda3/envs 2> /dev/null | fzf +m) &&
  conda activate "$envs"
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
	   newid=`ls -id "$dir" 2>/dev/null | cut -d ' ' -f 1`
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
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."


# Paths
PATH="$PATH:~/bin"
export PATH="$HOME/local/bin:$PATH"
export PATH="/scratch4/blangme2//sjhwang/scripts:$PATH"
export LD_LIBRARY_PATH="$HOME/local/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="$HOME/local/lib/pkgconfig:$HOME/bin/ncurses-6.3/include:$PKG_CONFIG_PATH"

# assorted tools
export PATH="~/bin/moni/build:$PATH"
export SPUMONI_BUILD_DIR="~/bin/spumoni/build"
export PATH="~/bin/spumoni/build:$PATH"
export PFPDOC_BUILD_DIR="~/bin/docprofiles/build"
export PATH="~/bin/docprofiles/build/:$PATH"
export PATH="~/bin/FastANI/bin:$PATH"
export PATH="~/bin/seqtk/:$PATH"


## Modules to load
#module load vim/9.0
#module load cmake/3.18.4
#module load zlib/1.2.11
#module load samtools/1.15.1
#module load bcftools/1.12
#module load HTSlib/1.12
#module load bzip2/1.0.8
#module load bedtools/2.30

