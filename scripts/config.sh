#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $CURRENT_DIR/debug.sh

log "sourcing config"

# TODO empty patterns are invalid
function check_pattern() {
  echo "beep beep" | grep -e "$1" 2> /dev/null

  if [[ $? == "2" ]]; then
    echo 0
  else
    echo 1
  fi
}

source "$CURRENT_DIR/utils.sh"

PATTERNS_LIST=(
"(^|^\.|[[:space:]]|[[:space:]]\.|[[:space:]]\.\.|^\.\.)[[:alnum:]~_-]*/[][[:alnum:]_.#$%&+=/@-]*"
"[[:digit:]]{4,}"
"[0-9a-f]{7}|[0-9a-f]{40}"
"(https?://|git@|git://|ssh://|ftp://|file:///)[[:alnum:]?=%/_.:,;~@!#$&()*+-]*"
"[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}"
)

IFS=$'\n'
USER_DEFINED_PATTERNS=($(tmux show-options -g | grep ^@fingers-pattern | sed 's/^@fingers-pattern-[0-9] "\(.*\)"$/\1/'))
unset IFS

PATTERNS_LIST=("${PATTERNS_LIST[@]}" "${USER_DEFINED_PATTERNS[@]}")

i=0
for pattern in "${PATTERNS_LIST[@]}" ; do
  is_pattern_good=$(check_pattern "$pattern")

  if [[ $is_pattern_good == 0 ]]; then
    display_message "fingers-error: bad user defined pattern $pattern" 5000
    PATTERNS_LIST[$i]="nope{4000}"
  fi

  i=$((i + 1))
done

function get_pattern_list() {
  for pattern in "${PATTERNS_LIST[@]}" ; do
    printf "%s\n" $pattern
  done
}

PATTERNS="($(array_join ")|(" "${PATTERNS_LIST[@]}"))"
PATTERNS_AWK=$(array_join "!!!finger_patterns_separator!!!" "${PATTERNS_LIST[@]}")

#log "patterns $PATTERNS"
#log "patterns awk $PATTERNS_AWK"
export PATTERNS
export PATTERNS_AWK
