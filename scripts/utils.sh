#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $CURRENT_DIR/debug.sh

function array_join() {
  # Good ol' stack overflow
  # http://stackoverflow.com/questions/1527049/bash-join-elements-of-an-array
  local d=$1; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}";
}

function ord() {
  LC_CTYPE=C printf '%d' "'$1"
}

function chr() {
  [ "$1" -lt 256 ] || return 1
  printf "\\$(printf '%03o' "$1")"
}

function is_between() {
  local value=$1
  local lower=$2
  local upper=$3

  if [[ $value -ge $lower ]] && [[ $value -le $upper ]]; then
    echo 1
  else
    echo 0
  fi
}

A_CODE=$(ord "a")
Z_CODE=$(ord "z")
CAPITAL_A_CODE=$(ord "A")
CAPITAL_Z_CODE=$(ord "Z")

function is_letter() {
  echo $(is_between $(ord $1) $A_CODE $Z_CODE)
}

function is_capital_letter() {
  echo $(is_between $(ord $1) $CAPITAL_A_CODE $CAPITAL_Z_CODE)
}

function is_alpha() {
  if [[ $(is_letter $1) == "1" ]] || [[ $(is_capital_letter $1) == "1" ]]; then
    echo 1
  else
    echo 0
  fi
}

function str_to_ascii() {
  local input=$1
  local output=''

  for (( i=0; i<${#input}; i++ )); do
    output="${output}$(ord "${input:$i:1}") "
  done

  echo "${output// $//}"
}

function display_message() {
  local original_display_time=$(tmux show-option -gqv display-time)
  tmux set-option -g display-time $2
  tmux display-message "$1"
  tmux set-option -g display-time $original_display_time
}

function revert_to_original_pane() {
  local current_pane_id=$1
  local fingers_pane_id=$2
  tmux swap-pane -s "$current_pane_id" -t "$fingers_pane_id"
  tmux kill-pane -t "$fingers_pane_id"
}

function pane_exec() {
  local pane_id=$1
  local pane_command=$2

  tmux send-keys -t $pane_id " $pane_command"
  tmux send-keys -t $pane_id Enter
}

function fingers_tmp() {
  local tmp_path=$(mktemp "${TMPDIR:-/tmp}/tmux-fingers.XXXXXXXX")
  chmod 600 "$tmp_path"
  echo "$tmp_path"
}
