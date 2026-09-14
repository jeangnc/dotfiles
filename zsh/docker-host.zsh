_dotfiles_docker_host() {
  local docker_host=""

  if [[ -n ${DOCKER_HOST:-} && ${DOCKER_HOST:-} != ${DOTFILES_DOCKER_HOST_AUTO:-} ]]; then
    return
  fi

  if [[ -n ${DOCKER_CONTEXT:-} ]]; then
    unset DOCKER_HOST
    return
  fi

  local git_common_dir
  if git_common_dir="$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)"; then
    docker_host="$(_dotfiles_docker_host_for_directory "${git_common_dir:A:h}")"
  fi
  if [[ -z $docker_host ]]; then
    docker_host="$(_dotfiles_docker_host_for_directory "${PWD:A}")"
  fi

  if [[ -n $docker_host ]]; then
    export DOCKER_HOST=$docker_host
    export DOTFILES_DOCKER_HOST_AUTO=$docker_host
  else
    unset DOCKER_HOST DOTFILES_DOCKER_HOST_AUTO
  fi
}

_dotfiles_docker_host_for_directory() {
  case "$1" in
    "$HOME/Code/gq"|"$HOME/Code/gq/"*) print -r -- ssh://gq@orb ;;
    "$HOME/Code/jeangnc"|"$HOME/Code/jeangnc/"*) print -r -- ssh://me@orb ;;
    "$HOME/Code/skip-visa-queue"|"$HOME/Code/skip-visa-queue/"*) print -r -- ssh://svq@orb ;;
  esac
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd _dotfiles_docker_host
_dotfiles_docker_host
