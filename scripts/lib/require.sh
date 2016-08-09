#!/usr/bin/env bash

declare -A __require_table__

function require() {
  local target=$1
  local from_path="$( cd "$( dirname "${BASH_SOURCE[1]}" )" && pwd )"

  local source_path=$(realpath "${from_path}/${target}")

  if [[ ${__require_table__[$source_path]} == "1" ]]; then
    return
  fi

  . "$source_path"
  __require_table__[$source_path]="1"
}

export -f require
