#!/bin/bash

PATTERNS="((^|^\.|[[:space:]]|[[:space:]]\.|[[:space:]]\.\.|^\.\.)[[:alnum:]~_-]*/[][[:alnum:]_.#$%&+=/@-]*)|([[:digit:]]{4,})|([0-9a-f]{7}|[0-9a-f]{40})|((https?://|git@|git://|ssh://|ftp://|file:///)[[:alnum:]?=%/_.:,;~@!#$&()*+-]*)|([[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3})|(git rebase --(abort|continue))|(git push --set-upstream.*)"
PATTERNS="([[:digit:]]{4,})"
cat | FINGER_PATTERNS=$PATTERNS awk 'n = match($0, ENVIRON["FINGER_PATTERNS"], a) { printf "line=%d, column=%d, match=%s\n", NR, n, substr($0, RSTART, RLENGTH) }'
