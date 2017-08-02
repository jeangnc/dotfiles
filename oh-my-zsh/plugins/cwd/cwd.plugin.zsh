#open tab in the last directory
function cd() {  
  builtin cd "$@";
  echo "$PWD" > ~/.cwd;
}

export cd

alias cwd='cd "$(cat ~/.cwd)"'
cwd
