${begin_SCHEME_pattern} = '\(\*{2,}\s+begin\s+SCHEME\s+\*{1,}\)';
${end_SCHEME_pattern} = '\(\*{2,}\s+end\s+SCHEME\s+\*{1,}\)';

${begin_LISP_pattern} = '\*{2,}\s+begin\s+LISP';
${end_LISP_pattern} = '\*{2,}\s+end\s+LISP';

LINE: while (defined($line = <>)) {
  if ($line =~ m/${begin_SCHEME_pattern}/o) {
    SKIP: while (defined($line = <>)) {
      last SKIP if ($line =~ m/${end_SCHEME_pattern}/o);
      ## chop($line); print "(** SCHEME: $line *)\n";
      next SKIP;
    }
    next LINE;
  }
  if ($line =~ m/${begin_LISP_pattern}/o) {
    ## print "(** begin LISP *)\n";
    next LINE;
  }
  if ($line =~ m/${end_LISP_pattern}/o) { 
    ## print "(** end LISP *)\n";
    next LINE;
  }
  print "$line";
  next LINE;
}
