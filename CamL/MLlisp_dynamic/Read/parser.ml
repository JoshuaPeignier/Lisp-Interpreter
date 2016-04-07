type token =
  | Token_num of (int)
  | Token_symbol of (string)
  | Token_string of (string)
  | Token_lpar
  | Token_rpar
  | Token_nil
  | Token_quote

open Parsing;;
let _ = parse_error;;
# 4 "Read/parser.mly"
(* Empty Ocaml header section *)
# 15 "Read/parser.ml"
let yytransl_const = [|
  260 (* Token_lpar *);
  261 (* Token_rpar *);
  262 (* Token_nil *);
  263 (* Token_quote *);
    0|]

let yytransl_block = [|
  257 (* Token_num *);
  258 (* Token_symbol *);
  259 (* Token_string *);
    0|]

let yylhs = "\255\255\
\001\000\003\000\003\000\003\000\003\000\003\000\003\000\004\000\
\004\000\002\000\002\000\000\000"

let yylen = "\002\000\
\002\000\001\000\001\000\001\000\001\000\002\000\003\000\000\000\
\002\000\000\000\002\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\012\000\000\000\011\000\002\000\004\000\
\005\000\000\000\003\000\000\000\001\000\000\000\000\000\006\000\
\009\000\007\000"

let yydgoto = "\002\000\
\004\000\005\000\014\000\015\000"

let yysindex = "\001\000\
\252\254\000\000\252\254\000\000\002\255\000\000\000\000\000\000\
\000\000\002\255\000\000\002\255\000\000\002\255\012\255\000\000\
\000\000\000\000"

let yyrindex = "\000\000\
\009\255\000\000\009\255\000\000\000\000\000\000\000\000\000\000\
\000\000\013\255\000\000\000\000\000\000\013\255\000\000\000\000\
\000\000\000\000"

let yygindex = "\000\000\
\000\000\011\000\251\255\005\000"

let yytablesize = 19
let yytable = "\013\000\
\003\000\001\000\007\000\008\000\009\000\010\000\016\000\011\000\
\012\000\010\000\010\000\010\000\010\000\006\000\010\000\010\000\
\018\000\008\000\017\000"

let yycheck = "\005\000\
\005\001\001\000\001\001\002\001\003\001\004\001\012\000\006\001\
\007\001\001\001\002\001\003\001\004\001\003\000\006\001\007\001\
\005\001\005\001\014\000"

let yynames_const = "\
  Token_lpar\000\
  Token_rpar\000\
  Token_nil\000\
  Token_quote\000\
  "

let yynames_block = "\
  Token_num\000\
  Token_symbol\000\
  Token_string\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'list_rpar) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 23 "Read/parser.mly"
                            (_2)
# 90 "Read/parser.ml"
               : lisp_object))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 27 "Read/parser.mly"
                            ((Lisp_num (_1)))
# 97 "Read/parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 28 "Read/parser.mly"
                            ((Lisp_list([])))
# 103 "Read/parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 29 "Read/parser.mly"
                            ((Lisp_symbol(_1)))
# 110 "Read/parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 30 "Read/parser.mly"
                            ((Lisp_string(_1)))
# 117 "Read/parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 31 "Read/parser.mly"
                            ((Lisp_list 
                                ((Lisp_symbol("quote"))::(_2)::([]))))
# 125 "Read/parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'list_expr) in
    Obj.repr(
# 34 "Read/parser.mly"
                            ((Lisp_list (_2)))
# 132 "Read/parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 38 "Read/parser.mly"
                             (([]))
# 138 "Read/parser.ml"
               : 'list_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'list_expr) in
    Obj.repr(
# 39 "Read/parser.mly"
                             (((_1)::(_2)))
# 146 "Read/parser.ml"
               : 'list_expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 43 "Read/parser.mly"
                             ()
# 152 "Read/parser.ml"
               : 'list_rpar))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'list_rpar) in
    Obj.repr(
# 44 "Read/parser.mly"
                             ()
# 159 "Read/parser.ml"
               : 'list_rpar))
(* Entry main *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let main (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : lisp_object)
;;
# 47 "Read/parser.mly"
 

(* Empty Ocaml trailer section *)




# 192 "Read/parser.ml"
