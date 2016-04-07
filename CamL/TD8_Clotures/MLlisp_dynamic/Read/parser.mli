type token =
  | Token_num of (int)
  | Token_symbol of (string)
  | Token_string of (string)
  | Token_lpar
  | Token_rpar
  | Token_nil
  | Token_quote

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> lisp_object
