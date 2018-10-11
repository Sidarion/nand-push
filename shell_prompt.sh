# This snippet is intended to be included in ~/.bashrc
#
# it extends PS1 to show in color
# 
# - git information
# - ansible environment

#  Make the prompt display git infos
. ~/.bash_git

__ansible_env_ps1() {
  # https://misc.flogisoft.com/bash/tip_colors_and_formatting
  # https://wiki.archlinux.org/index.php/Bash/Prompt_customization#Embedding_commands -> Note
  # http://mywiki.wooledge.org/BashFAQ/053
  if   [[ $ANSIBLE_CONFIG =~ production ]]; then 
    echo -en '\001\e[0;31;49m\002(-> prod)' # red
  elif [[ $ANSIBLE_CONFIG =~ simulation ]]; then 
    echo -en '\001\e[0;32;49m\002(-> sim)'  # green
  else
    echo -en '\001\e[0;90;49m\002(-> ???)'  # grey
  fi  
}

__working_dir() {
  local wd=`pwd`
  if [ "$wd" == "$HOME" ]; then
    echo "~"
  elif [ "$wd" == "./network-orchestrator" ]; then
    echo "~orch~"
  else
    echo "$wd"
  fi
}

if [ $(id -u) -eq 0 ]; then 
  PS1='\[\e[0;32;49m\]\u@\h:\[\e[0;32;49m\]$(__working_dir) \[\e[0m\]# \[\e[01;35m\]$(__git_ps1 " (%s)")$(__ansible_env_ps1)\[\e[0m\] '
else
  PS1='\[\e[0;32;49m\]\u@\h:\[\e[0;32;49m\]$(__working_dir) \[\e[0m\]> \[\e[01;35m\]$(__git_ps1 " (%s)")$(__ansible_env_ps1)\[\e[0m\] '
fi 
