
(************************ Subroutines ***************)

let list2 x y = cons x (cons y nil);;

let list3 x y z = cons x (list2 y z);;

(**************************************)

let lisp_plus = string_to_symbol "+";;

let do_plus lvals =
  num_to_obj
    ((obj_to_num (car lvals))
     + (obj_to_num (cadr lvals)))
;;

let lisp_mult = string_to_symbol "*";;

let do_mult lvals =
  num_to_obj
    ((obj_to_num (car lvals))
     * (obj_to_num (cadr lvals)))
;;

let lisp_minus = string_to_symbol "-";;

let do_minus lvals =
  num_to_obj
    ((obj_to_num (car lvals))
     - (obj_to_num (cadr lvals)))
;;

let lisp_concat = string_to_symbol "concat";;

let rec do_concat lvals =
  if (nullp lvals)
  then string_to_obj("")
  else
    let s = obj_to_string (car lvals)
    and t = obj_to_string (do_concat (cdr lvals))
    in string_to_obj (s^t)
;;

(**************************************)

let lisp_car= string_to_symbol "car";;

let do_car lvals = car (car lvals);;

let lisp_cdr = string_to_symbol "cdr";;

let do_cdr lvals = cdr (car lvals);;

let lisp_cons = string_to_symbol "cons";;

let do_cons lvals = cons (car lvals) (cadr lvals);;

let lisp_eq = string_to_symbol "eq";;

let do_eq lvals =
  bool_to_obj(eqp (car lvals) (cadr lvals))
;;

let lisp_equal = string_to_symbol "=";;

let do_equal lvals = do_eq lvals
;;

let lisp_read = string_to_symbol "read";;

let do_read lvals = read ();;

let lisp_print = string_to_symbol "print";;

let do_print lvals =
  let obj = (car lvals) in
  (print obj; flush(stdout); obj);;

let lisp_newline = string_to_symbol "newline";;

let do_newline lvals = print_newline (); nil;;

let lisp_end = string_to_symbol "end";;

exception Lisp_end_of_toplevel;;

let do_end lvals = raise Lisp_end_of_toplevel;;


(**************************************)

let lisp_lambda = string_to_symbol "lambda";;

let lisp_quote = string_to_symbol "quote";;

let lisp_setq = string_to_symbol "setq";;

let lisp_define = string_to_symbol "define";;

let lisp_defun = string_to_symbol "defun";;

let lisp_if = string_to_symbol "if";;

let lisp_cond = string_to_symbol "cond";;

let lisp_andthen = string_to_symbol "andthen";;

let lisp_progn = string_to_symbol "progn";;

let lisp_printenv = string_to_symbol "printenv";;

let lisp_debug = string_to_symbol "debug";;

let lisp_load = string_to_symbol "load";;

(**************************************)

let lisp_null = string_to_symbol "null";;

let do_null lvals =
  bool_to_obj(nullp (car lvals))
;;

let lisp_stringp = string_to_symbol "stringp";;

let do_stringp lvals =
  bool_to_obj(stringp (car lvals))
;;

let lisp_numberp = string_to_symbol "numberp";;

let do_numberp lvals =
  bool_to_obj(numberp (car lvals))
;;

let lisp_symbolp = string_to_symbol "symbolp";;

let do_symbolp lvals =
  bool_to_obj(symbolp (car lvals))
;;

let lisp_listp = string_to_symbol "listp";;

let do_listp lvals =
  bool_to_obj(listp (car lvals))
;;

(****************************************)

let lisp_eval = string_to_symbol "eval";;

let lisp_apply = string_to_symbol "apply";;

let lisp_error = string_to_symbol "error";;

let do_error lvals =
  let message = obj_to_string (car lvals)
  in
  error message
;;

(**********************************)

let lisp_let = string_to_symbol "let";;

let rec list_car l =
  if (nullp l) then l
  else (cons (car (car l)) (list_car (cdr l)))
;;

let rec list_cadr l =
  if (nullp l) then l
  else (cons (cadr (car l)) (list_cadr (cdr l)))
;;

let macro_let_to_lambda obj =
  let binding_list = cadr obj
  and body = caddr obj
  in
  let lpars = list_car binding_list
  and largs = list_cadr binding_list
  in
  (cons (list3 lisp_lambda lpars body) largs)
;;

(******************************************)

let do_debug lvals =
  begin
    if (nullp lvals) then debug := false
    else
      let v = (car lvals) in
      begin
        if (nullp v) then debug := false
        else if (numberp v) then
          begin
            max_print_level := (obj_to_num v);
            begin
              if (nullp (cdr lvals))
              then max_print_env_level := !max_print_level
              else max_print_env_level :=
                  (obj_to_num (cadr lvals))
            end;
            debug := true
          end
        else debug := true
      end
  end;
  nil
;;

