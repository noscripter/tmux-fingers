#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $CURRENT_DIR/debug.sh
source $CURRENT_DIR/utils.sh

match_lookup_table=''

function clear_screen() {
  local fingers_pane_id=$1
  log "clearing screen for $fingers_pane_id"
  clear
  tmux clearhist -t $fingers_pane_id
}

function lookup_match() {
  local input=$1
  echo "$(cat $match_lookup_table | grep "^$input:" | sed "s/^$input://")"
}

function show_hints_and_swap() {
  current_pane_id=$1
  fingers_pane_id=$2
  match_lookup_table=$(fingers_tmp)
  tmux swap-pane -s "$current_pane_id" -t "$fingers_pane_id"
  clear_screen "$fingers_pane_id"
  cat | FINGER_PATTERNS=$PATTERNS awk -f $CURRENT_DIR/search.awk 3> $match_lookup_table
}
