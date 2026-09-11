tp_code_root() {
  print -r -- "${TP_CODE_ROOT:-$HOME/Code}"
}

tp_project_path() {
  local code_root project_path
  code_root="$(tp_code_root)"
  code_root=${code_root:A}

  if [[ -z $1 ]]; then
    project_path=$PWD
  elif [[ $1 == /* ]]; then
    print -u2 -- "tp: project paths must be relative to $code_root"
    return 1
  else
    project_path="$code_root/$1"
  fi

  project_path=${project_path:A}

  if [[ $project_path == "$code_root" || $project_path != "$code_root"/* ]]; then
    print -u2 -- "tp: project paths must be inside $code_root"
    return 1
  fi

  if [[ ! -d $project_path ]]; then
    print -u2 -- "tp: project does not exist: $project_path"
    return 1
  fi

  print -r -- "$project_path"
}

tp_project_name() {
  local code_root
  code_root="$(tp_code_root)"
  code_root=${code_root:A}
  print -r -- "${1#$code_root/}"
}

tp_has_session() {
  tmux has-session -t "=$1" 2>/dev/null
}

tp_has_pane() {
  local project_path

  while IFS= read -r project_path; do
    [[ $project_path == "$2" ]] && return 0
  done < <(tmux list-panes -s -t "=$1" -F '#{@tp_project}')

  return 1
}

tp_mark_initial_pane() {
  local pane_id
  pane_id="$(tmux list-panes -s -t "=$1" -F '#{pane_id}')" || return
  tmux set-option -p -t "$pane_id" @tp_project "$2"
}

tp_create_project_session() {
  if ! tp_has_session "$2"; then
    tmux new-session -d -s "$2" -c "$1" || return
    tp_mark_initial_pane "$2" "$1"
  fi
}

tp_server_command() {
  print -r -- "source ${(q)1}; exec zsh"
}

tp_add_main_pane() {
  local pane_id

  if ! tp_has_session main; then
    tmux new-session -d -s main -c "$1" || return
    tp_mark_initial_pane main "$1"
  elif ! tp_has_pane main "$1"; then
    pane_id="$(tmux split-window -v -P -F '#{pane_id}' -t =main -c "$1")" || return
    tmux set-option -p -t "$pane_id" @tp_project "$1"
  fi
}

tp_add_server_pane() {
  local pane_id server_command
  server_command="$(tp_server_command "$2")"

  if ! tp_has_session server; then
    tmux new-session -d -s server -c "$1" "$server_command" || return
    tp_mark_initial_pane server "$1"
  elif ! tp_has_pane server "$1"; then
    pane_id="$(tmux split-window -h -P -F '#{pane_id}' -t =server -c "$1" "$server_command")" || return
    tmux set-option -p -t "$pane_id" @tp_project "$1"
  fi
}

tp_attach() {
  if [[ -n $TMUX ]]; then
    tmux switch-client -t "=$1"
  else
    tmux attach-session -t "=$1"
  fi
}

tp() {
  local create_sessions=false project_argument project_path session_name config_path
  local -a project_arguments project_paths
  local -A seen_projects project_configs

  if [[ $1 == -c ]]; then
    create_sessions=true
    shift
  elif [[ $1 == -* ]]; then
    print -u2 -- "usage: tp [-c] [project ...]"
    return 1
  fi

  project_arguments=("$@")
  (( ${#project_arguments} )) || project_arguments=('')

  for project_argument in "${project_arguments[@]}"; do
    project_path="$(tp_project_path "$project_argument")" || return
    [[ -n ${seen_projects[$project_path]-} ]] && continue
    seen_projects[$project_path]=1
    project_paths+=("$project_path")

    if [[ $create_sessions == false ]]; then
      config_path="$project_path/.tmux-server"
      if [[ ! -r $config_path || ! -s $config_path ]]; then
        print -u2 -- "tp: missing or empty server command: $config_path"
        return 1
      fi
      project_configs[$project_path]=$config_path
    fi
  done

  if [[ $create_sessions == true ]]; then
    for project_path in "${project_paths[@]}"; do
      session_name="$(tp_project_name "$project_path")"
      tp_create_project_session "$project_path" "$session_name" || return
    done
    tp_attach "$(tp_project_name "${project_paths[1]}")"
    return
  fi

  for project_path in "${project_paths[@]}"; do
    tp_add_main_pane "$project_path" || return
    tp_add_server_pane "$project_path" "${project_configs[$project_path]}" || return
  done

  tp_attach main
}

_tp_projects() {
  local code_root
  code_root="$(tp_code_root)"
  _files -W "$code_root" -/
}

_tp() {
  _arguments '-c[create one shell session per project]' '*:project:_tp_projects'
}

compdef _tp tp
