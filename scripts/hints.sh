#!/usr/bin/env bash

sourcing_before_ms=$(current_ms)
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

MATCH_PARSER="\([0-9]*\):\(.*\)"

HINTS=(p o i u l k j t r e wj wt wr we ww wq wf wd ws wa qp qo qi qu ql qk qj qt qr qe qw qq qf qd qs qa fp fo fi fu fl fk fj ft fr fe fw fq ff fd fs fa dp do di du dl dk dj dt dr de dw dq df dd ds da sp so si su sl sk sj st sr se sw sq sf sd ss sa ap ao ai au al ak aj at ar ae aw aq af ad as aa)
match_lookup_table=''

declare -A match_lookup_table

function get_hint() {
  echo "${HINTS[$1]}"
}

function highlight() {
  printf "\033[1;33m%s\033[0m" "$1"
}

function tput_hint() {
  local text=$1
  local hint=$2
  local linenumber=$3
  local colnumber=$4

  echo "$(tput cup $linenumber $colnumber)$(tput setaf 3)$(tput bold)$text [$hint]$(tput sgr0)"
}

function clear_screen() {
  clear
  tmux clearhist
}

function lookup_match() {
  local input=$1
  echo ${match_lookup_table[$input]}
}

lines=''
OLDIFS="$IFS"

IFS=''
while read -r line
do
  lines+="$line\n"
done < /dev/stdin
IFS="$OLDIFS"

IFS=$'\n'
matches=($(echo -ne $lines | FINGER_PATTERNS=$PATTERNS awk -f $CURRENT_DIR/search.awk))
IFS="$OLDIFS"

output="$lines"

match_count=$((${#matches[@]} / 3 - 1))

clear_screen
printf "%b" "${output::-2}"
#echo -ne $output
#echo -ne $output >> $CURRENT_DIR/../wtf.log

i=0
while [[ $i -lt $match_count ]]; do
  match_index=$((i * 3))
  linenumber=${matches[$match_index]}
  colnumber=${matches[$((match_index + 1))]}
  match=${matches[$((match_index + 2))]}
	hint=$(get_hint $i)

  log "i:       $i"
  log "line no: $linenumber"
  log "col no:  $colnumber"
  log "match:   $match"

	tput_hint $match $hint $((linenumber - 1)) $((colnumber - 1))

	match_lookup_table[$hint]=$text

  i=$((i + 1))
done
