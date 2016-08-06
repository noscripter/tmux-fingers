function debug_log (msg) {
  printf "%s\n", msg | "cat 1>&2"
}

BEGIN {
  n_matches = 0;
  line_pos = 0;
  col_pos = 0;

  HINTS[0] = "p"
  HINTS[1] = "o"
  HINTS[2] = "i"
  HINTS[3] = "u"
  HINTS[4] = "l"
  HINTS[5] = "k"
  HINTS[6] = "j"
  HINTS[7] = "t"
  HINTS[8] = "r"
  HINTS[9] = "e"
  HINTS[10] = "wj"
  HINTS[11] = "wt"
  HINTS[12] = "wr"
  HINTS[13] = "we"
  HINTS[14] = "ww"
  HINTS[15] = "wq"
  HINTS[16] = "wf"
  HINTS[17] = "wd"
  HINTS[18] = "ws"
  HINTS[19] = "wa"
  HINTS[20] = "qp"
  HINTS[21] = "qo"
  HINTS[22] = "qi"
  HINTS[23] = "qu"
  HINTS[24] = "ql"
  HINTS[25] = "qk"
  HINTS[26] = "qj"
  HINTS[27] = "qt"
  HINTS[28] = "qr"
  HINTS[29] = "qe"
  HINTS[30] = "qw"
  HINTS[31] = "qq"
  HINTS[32] = "qf"
  HINTS[33] = "qd"
  HINTS[34] = "qs"
  HINTS[35] = "qa"
  HINTS[36] = "fp"
  HINTS[37] = "fo"
  HINTS[38] = "fi"
  HINTS[39] = "fu"
  HINTS[40] = "fl"
  HINTS[41] = "fk"
  HINTS[42] = "fj"
  HINTS[43] = "ft"
  HINTS[44] = "fr"
  HINTS[45] = "fe"
  HINTS[46] = "fw"
  HINTS[47] = "fq"
  HINTS[48] = "ff"
  HINTS[49] = "fd"
  HINTS[50] = "fs"
  HINTS[51] = "fa"
  HINTS[52] = "dp"
  HINTS[53] = "do"
  HINTS[54] = "di"
  HINTS[55] = "du"
  HINTS[56] = "dl"
  HINTS[57] = "dk"
  HINTS[58] = "dj"
  HINTS[59] = "dt"
  HINTS[60] = "dr"
  HINTS[61] = "de"
  HINTS[62] = "dw"
  HINTS[63] = "dq"
  HINTS[64] = "df"
  HINTS[65] = "dd"
  HINTS[66] = "ds"
  HINTS[67] = "da"
  HINTS[68] = "sp"
  HINTS[69] = "so"
  HINTS[70] = "si"
  HINTS[71] = "su"
  HINTS[72] = "sl"
  HINTS[73] = "sk"
  HINTS[74] = "sj"
  HINTS[75] = "st"
  HINTS[76] = "sr"
  HINTS[77] = "se"
  HINTS[78] = "sw"
  HINTS[79] = "sq"
  HINTS[80] = "sf"
  HINTS[81] = "sd"
  HINTS[82] = "ss"
  HINTS[83] = "sa"
  HINTS[84] = "ap"
  HINTS[85] = "ao"
  HINTS[86] = "ai"
  HINTS[87] = "au"
  HINTS[88] = "al"
  HINTS[89] = "ak"
  HINTS[90] = "aj"
  HINTS[91] = "at"
  HINTS[92] = "ar"
  HINTS[93] = "ae"
  HINTS[94] = "aw"
  HINTS[95] = "aq"
  HINTS[96] = "af"
  HINTS[97] = "ad"
  HINTS[98] = "as"
  HINTS[99] = "aa"

  finger_patterns = ENVIRON["FINGER_PATTERNS"];

  pattern_list_count = split(ENVIRON["FINGER_PATTERNS_AWK"], pattern_list, "!!!finger_patterns_separator!!!");

  hint_format = "\033[1;33m[%s]\033[0m"
  highlight_format = "\033[1;33m%s\033[0m "
}

{
  line = $0;
  pos = 0;
  col_pos = 0;
	col_pos_correction = 0;

	output_line = line;

  while (match(line, finger_patterns)) {
    MATCH_RSTART = RSTART;
    MATCH_NR = NR;
    MATCH_RLENGTH = RLENGTH;

    for (i = 1; i <= pattern_list_count; ++i) {
      pattern = pattern_list[i];
      #debug_log(pattern);

      if (pattern ~ /^\^\(---/ && line ~ pattern) {
        # TODO gawk dependency
        debug_log(pattern);
        result = gensub(".*" pattern_list[i] ".*", "\\1", "g", line);
        debug_log("result 1 " result);

        result = gensub(".*" pattern_list[i] ".*", "\\2", "g", line);
        debug_log("result 2 " result);

        result = gensub(".*" pattern_list[i] ".*", "\\3", "g", line);
        debug_log("result 3 " result);
      }
    }

    n_matches += 1;

		hint = HINTS[n_matches - 1]
    pos += MATCH_RSTART;

    col_pos = pos;
    line_match = substr(line, MATCH_RSTART, MATCH_RLENGTH);

    col_pos = col_pos + col_pos_correction

    line_pos = NR;

		pre_match = substr(output_line, 0, col_pos - 1);
    hint_match = sprintf(highlight_format hint_format, line_match, hint);
		post_match = substr(output_line, col_pos + MATCH_RLENGTH, length(line) - 1);

    output_line = pre_match hint_match post_match;

    line = post_match;

    col_pos_correction += (length(sprintf(highlight_format, line_match)) - 1 + length(sprintf(hint_format, hint)) - 1) + 1;

    #printf hint ":" line_match "\n" | "cat 1>&3"
  }

  printf "\n%s", output_line
}
