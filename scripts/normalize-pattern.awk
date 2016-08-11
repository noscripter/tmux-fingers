function find_matching_pos(str, position) {
  i = position;
  right_char = substr(str, i, 1);

  if (right_char == ")") {
    left_char = "(";
  }

  if (right_char == "]") {
    left_char = "[";
  }

  do {
    current_char = substr(str, i, 1);
    i--;

    # TODO peek next char for escaping backslash
    if (current_char == right_char) {
      match_count++;
    }

    if (current_char == left_char) {
      match_count--;
    }

  } while (current_char != left_char && match_count > 0 && i > 0)

  return i;
}

{
  input_pattern = $0
  original_input = $0

  # TODO this is a while loop, and we need to accum col_pos, trim input and such
  #   input_pattern = substr(input_pattern, RLENGTH + 1, length(input_pattern) - 1);

  if (match(input_pattern, "[])]\\{[[:digit:]]+(,[[:digit:]]*)?\\}")) {
    matching_pos = find_matching_pos(original_input, RSTART);
  }
}
