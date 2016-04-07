
(********************* read and print ***************************)

let read () = build_object !current_channel;;

let hiddenp obj = match obj with
  | Lisp_subr(_) -> true
  | _ -> false
;;

let rec

  print_env_level (e:environment) n =
  if not (!debug) then print_string "<env>"
  else if n <= 0 then print_string "<env>"
  else match e with
    | [] -> ()
    | {name=x; value=v}::e' ->
      if ((hiddenp v) && (not !print_env_hidden))
      then
        print_env_level e' n
      else
        (print_string ("\"" ^ x ^ "\"");
         print_string " = ";
         print_level v (n-1);
         print_string "; ";
         print_env_level e' n)

and

  print_level obj n =
  if n <= 0 then print_string "..."
  else match obj with
    | Lisp_list([]) -> print_string "()"
    | Lisp_num(n) -> print_int n
    | Lisp_symbol(s) -> print_string s
    | Lisp_string(s) -> print_string s
    | Lisp_subr(f) -> print_string "<subr>"
    | Lisp_list(l) ->
      (print_string "(";
       let rec aux = function
           [] -> print_string ")"
         | x::[] -> (print_level x (n-1); print_string ")")
         | x::m -> (print_level x (n-1); print_string " "; aux m)
       in aux l)
    (** begin MLlisp_static *)
    | Lisp_env(e) -> print_env_level e (n-1)
    (** end MLlisp_static *)
;;

let print_env'_level (e:environment) n =
  let tmp = !debug in
  debug := true;
  print_env_level e n;
  debug := tmp
;;

let print_env e = print_env_level e !max_print_env_level;;

let print obj = print_level obj !max_print_level;;

let print_env' e = print_env'_level e !max_print_level;;

