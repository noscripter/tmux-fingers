{
  text = $0;
  finger_patterns = ENVIRON["FINGER_PATTERNS"];

  pos = 0;
  n_matches = 0;
  line_pos = 0;
  col_pos = 0;
  col_correction = 0;

  while (match(text, finger_patterns)) {
    n_matches += 1;
    pos += RSTART;

    line_pos = NR;
    col_pos = pos;
    text_match = substr(text, RSTART, RLENGTH);

    if (n_matches > 1 && NR != line_pos) {
      col_correction += (col_pos + (n_matches > 10 ? 5 : 4));
    } else {
      col_correction = 0;
    }

    printf "%d\n%d\n%s\n", line_pos, (col_pos + col_correction), text_match;

    text = substr(text, RSTART + RLENGTH - 1);
  }
}
