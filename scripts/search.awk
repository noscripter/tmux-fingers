{
  text = $0;
  pos = 0;
  while (match(text, ENVIRON["FINGER_PATTERNS"])) {
    printf "%d\n%d\n%s\n", NR, pos += RSTART, substr(text, RSTART, RLENGTH);
    text = substr(text, RSTART + RLENGTH - 1);
  }
}
