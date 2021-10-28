# History settings
shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT="%l:%M:%S %p ▏ "

shopt -s checkwinsize
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Simple
# export PS1='\[\033[01;32m\]\u@\[\033[00;31m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$ '
parse_git_branch_and_changes() {
  OUTPUT=$(git status 2> /dev/null | grep 'Changes not staged for commit' >/dev/null && echo \*)
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1'"$OUTPUT"')/'
}
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
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

#####################################################################################
alias ll='ls -alF --group-directories-first'
alias la='ls -A --group-directories-first'
alias l='ls -CF --group-directories-first'
alias lsmb='ls -l --block-size=M'
alias lsgb='ls -l --block-size=G'

alias pip='pip3'
alias python='python3'
alias e='exit'
alias h='history'
alias tmux='tmux -2'
alias brain='cd /public/groups/hausslerlab/people/sjhwang && conda activate scRNA'
alias vg_='cd /public/groups/vg/sjhwang'
alias lab='jupyter-lab'
alias ipython='ipython --no-autoindent'
alias ipy='ipython --no-autoindent'

#####################################################################################

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/public/home/sjhwang/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/public/home/sjhwang/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/public/home/sjhwang/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/public/home/sjhwang/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
alias vimf='vim $(fzf -m --height 60%)'   # to start up vim with fzf
export FZF_DEFAULT_COMMAND='find "$PWD" -name ".*" -prune -o -print'
export FZF_COMPLETION_TRIGGER='--'

# fzf a saved commands file
bind '"\C-f": "$(tac ~/bin/saved_commands.txt 2> /dev/null | fzf +m)\e\C-e\er\e^"'

# fzf conda activate
act() {
  local envs
  envs=$(ls ~/miniconda3/envs 2> /dev/null | fzf +m) &&
  conda activate "$envs"
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

conda deactivate

# paths
export VIMRUNTIME=/public/home/sjhwang/.local/usr/share/vim/vim82
export PATH="/public/home/sjhwang/.local/bin:$PATH"
export PATH="/public/home/sjhwang/cmake-3.17.2-Linux-x86_64/bin/:$PATH"
export PATH="/public/home/sjhwang/R/server/usr/lib/rstudio-server/bin:$PATH"
export PATH="/public/home/sjhwang/bin/vim/src/:$PATH"

# paths to build VG
export PATH=/public/home/sjhwang/.local/bin:/public/home/anovak/.local/bin:$PATH
export LD_LIBRARY_PATH=/public/home/sjhwang/.local/lib:/public/home/anovak/.local/lib64/:/public/home/anovak/.local/lib/:$LD_LIBRARY_PATH
export LD_RUN_PATH=/public/home/sjhwang/.local/lib:/public/home/anovak/.local/lib64/:/public/home/anovak/.local/lib/:$LD_RUN_PATH
export LIBRARY_PATH=/public/home/sjhwang/.local/lib:/public/home/anovak/.local/lib64/:/public/home/anovak/.local/lib/:$LIBRARY_PATH
export PKG_CONFIG_PATH=/public/home/anovak/.local/lib/pkgconfig:/usr/share/pkgconfig:/usr/lib64/pkgconfig:$PKG_CONFIG_PATH
export C_INCLUDE_PATH=/public/home/sjhwang/.local/include:/public/home/anovak/.local/include
export CPLUS_INCLUDE_PATH=/public/home/sjhwang/.local/include:/public/home/anovak/.local/include
export CPATH=$CPATH:/public/home/sjhwang/.local/install/miniconda/include/python2.7

export LIBRARY_PATH=$LIBRARY_PATH:/usr/lib64:/usr/lib/x86_64-redhat-linux6E/lib64
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64:/usr/lib/x86_64-redhat-linux6E/lib64
export LD_RUN_PATH=$LD_RUN_PATH:/usr/lib64:/usr/lib/x86_64-redhat-linux6E/lib64

export GVBINDIR=/usr/lib64/graphviz/

clear
