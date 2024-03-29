# Yay! High voltage and arrows!

prompt_setup_pygmalion(){
  # source activate myEnv
  ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
  ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}⚡%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_CLEAN=""

  condaenv_format="%{$fg[blue]%} %1v -env %{$reset_color%}"
  base_prompt="%{$fg[magenta]%}%n%{$reset_color%}%{$fg[cyan]%}@%{$reset_color%}%{$fg[yellow]%}%m%{$reset_color%}%{$fg[red]%}:%{$reset_color%}%{$fg[cyan]%}%0~%{$reset_color%}%{$fg[red]%} :%{$reset_color%}$condaenv_format"
  post_prompt='%{$fg[cyan]%}⇒%{$reset_color%}  '

  base_prompt_nocolor=$(echo "$base_prompt" | perl -pe "s/%\{[^}]+\}//g")
  post_prompt_nocolor=$(echo "$post_prompt" | perl -pe "s/%\{[^}]+\}//g")

  precmd_functions+=(condaenv_name)
  precmd_functions+=(prompt_pygmalion_precmd)
}

function condaenv_name {
    if [[ -z $CONDA_DEFAULT_ENV ]] then
        psvar[1]=''
    else
        psvar[1]=${CONDA_DEFAULT_ENV##*/}
    fi
}

prompt_pygmalion_precmd(){
  local gitinfo=$(git_prompt_info)
  local gitinfo_nocolor=$(echo "$gitinfo" | perl -pe "s/%\{[^}]+\}//g")
  local exp_nocolor="$(print -P \"$base_prompt_nocolor$gitinfo_nocolor$post_prompt_nocolor\")"
  local prompt_length=${#exp_nocolor}
  local nl=$'\n'

  pipe='%{$fg[red]%}|%{$reset_color%}'
  PROMPT="$base_prompt$gitinfo "	  
  if [ ! -z "$gitinfo" -a "$gitinfo"!=" "  ]; then
    PROMPT="$base_prompt$pipe$gitinfo"
  fi

  home=$(pwd) 
  if [[ $HOME == $home ]]; then
    PROMPT="$base_prompt$pipe$post_prompt"
  else
  	if [[ $prompt_length -gt 40 ]]; then
     		PROMPT_PREFIX=" $nl $post_prompt"
     		PROMPT=$PROMPT$PROMPT_PREFIX
  	else
     		PROMPT=$PROMPT" $post_prompt"
  	fi
  fi



}

prompt_setup_pygmalion