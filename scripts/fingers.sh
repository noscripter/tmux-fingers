#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $CURRENT_DIR/lib/require.sh

require "./utils.sh"
require "./config.sh"
require "./actions.sh"
require "./debug.sh"
require "./hints.sh"
require "./utils.sh"

FINGERS_COPY_COMMAND=$(tmux show-option -gqv @fingers-copy-command)

current_pane_id=$1
fingers_pane_id=$2
tmp_path=$3

BACKSPACE=$'\177'

function is_pane_zoomed() {
  local pane_id=$1

  tmux list-panes \
    -F "#{pane_id}:#{?pane_active,active,nope}:#{?window_zoomed_flag,zoomed,nope}" \
    | grep -c "^${pane_id}:active:zoomed$"
}

function zoom_pane() {
  local pane_id=$1

  tmux resize-pane -Z -t "$pane_id"
}

function handle_exit() {
  tmux swap-pane -s "$current_pane_id" -t "$fingers_pane_id"
  [[ $pane_was_zoomed == "1" ]] && zoom_pane "$current_pane_id"
  tmux kill-pane -t "$fingers_pane_id"
  rm -rf "$tmp_path"
}

function copy_result() {
  local result=$1

  clear
  echo -n "$result"
  start_copy_mode
  top_of_buffer
  start_of_line
  start_selection
  end_of_line
  cursor_left
  copy_selection

  if [ ! -z "$FINGERS_COPY_COMMAND" ]; then
    echo -n "$result" | eval "nohup $FINGERS_COPY_COMMAND" > /dev/null
  fi
}

function is_valid_input() {
  local input=$1
  local is_valid=1

  for (( i=0; i<${#input}; i++ )); do
    char=${input:$i:1}

    if [[ ! $(is_alpha $char) == "1" ]]; then
      is_valid=0
      break
    fi
  done

  echo $is_valid
}

function hide_cursor() {
  echo $(tput civis)
}

trap "handle_exit" EXIT

pane_was_zoomed=$(is_pane_zoomed "$current_pane_id")
show_hints_and_swap $current_pane_id $fingers_pane_id
[[ $pane_was_zoomed == "1" ]] && zoom_pane "$fingers_pane_id"

hide_cursor
input=''
while read -rsn1 char; do
  # Escape sequence, flush input
  if [[ "$char" == $'\x1b' ]]; then
    read -rsn1 -t 0.1 next_char

    if [[ "$next_char" == "[" ]]; then
      read -rsn1 -t 0.1
    fi

    continue
  fi

  if [[ ! $(is_valid_input "$char") == "1" ]]; then
    continue
  fi

  if [[ $char == "$BACKSPACE" ]]; then
    input=""
    continue
  else
    input="$input$char"
  fi

  result=$(lookup_match "$input")

  tmux display-message "$input"

  log "result: $result"

  if [[ -z $result ]]; then
    continue
  fi

  copy_result "$result"
  revert_to_original_pane "$current_pane_id" "$fingers_pane_id"

  exit 0
done < /dev/tty
