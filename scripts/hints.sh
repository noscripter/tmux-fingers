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

function clear_screen() {
  clear
  tmux clearhist
}

function lookup_match() {
  local input=$1
  echo ${match_lookup_table[$input]}
}

lines=''
OLDIFS=$IFS
IFS=
while read -r line
do
  lines+="$line\n"
done < /dev/stdin
IFS=$OLDIFS

# geirha #awk
# P='\..' awk '{ s = $0; pos = 0; while (match(s, ENVIRON["P"])) { print pos += RSTART, substr(s, RSTART, RLENGTH); s = substr(s, 
# RSTART+RLENGTH-1); } }'

matches=$(echo -ne $lines | FINGER_PATTERNS=$PATTERNS awk '{ s=$0; while (n = match(s, ENVIRON["P"])) { print substr(s, RSTART, RLENGTH); s = substr(s, RSTART+RLENGTH-1); } }'
output="$lines"
echo -ne "$matches" > $CURRENT_DIR/../matches.log

function print_hints() {
  echo -ne "$output"
}

log "match count: ${#matches}"
log "matches[2]: ${matches[2]}"

for i in $(seq 0 $((${#matches} / 3 - 1))) ; do
  linenumber=${matches[$i]}
  colnumber=${matches[$((i + 1))]}
  match=${matches[$((i + 2))]}

  log "i:       $i"
  #log "line no: $linenumber"
  #log "col no:  $colnumber"
  #log "match:   $match"

  #hint=$(get_hint $i)
  #linenumber=$(echo $match | sed "s/$MATCH_PARSER/\1/")
  #text=$(echo $match | sed "s/$MATCH_PARSER/\2/")
  #output=$(echo -ne "$output" | sed "${linenumber}s!${text//!/\\!}!$(highlight ${text//!/\\!}) $(highlight "[${hint//!/\\!}]")!g")
  #match_lookup_table[$hint]=$text

  #clear_screen
done
