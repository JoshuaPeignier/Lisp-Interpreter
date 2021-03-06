
(********************** Toplevel loop ************************)

let extract_defining_expr obj =
  if (nullp (cdddr obj)) (* At most 3 objects *)
  then (caddr obj) (* Last object *)
  else
    begin
      let rest = (cddr obj) (* Rest but the two first objects *)
      in
      (** begin LISP *
          (cons lisp_lambda rest)
       ** end LISP *)

      (** begin MLlisp_static *)
      (list2 lisp_quote (cons lisp_lambda rest))
      (** end MLlisp_static *)
    end
;;

let handle_define obj =
  let defined_obj = (cadr obj)
  and defining_expr = (extract_defining_expr obj) in
  let defined_name = (obj_to_string defined_obj)
  and defining_value = (eval defining_expr !global_env_ref)
  in
  begin
    print_string ("DEFINE: " ^ defined_name ^ " = ");
    print(defining_value);
    print_newline();
    global_env_ref := update_env_extend
        defined_obj defining_value !global_env_ref
  end
;;

(** begin LISP *
    let handle_set obj = handle_define obj;;
 ** end LISP *)

(** begin MLlisp_static *)
let handle_set obj =
  let defined_obj = (cadr obj)
  and defining_expr = (extract_defining_expr obj) in
  let defined_name = (obj_to_string defined_obj)
  and defining_value = (eval defining_expr !global_env_ref)
  in
  begin
    print_string ("SET: " ^ defined_name ^ " = ");
    print(defining_value);
    print_newline();
    global_env_ref := update_env_modify
        defined_obj defining_value !global_env_ref
  end
;;
(** end MLlisp_static *)

let handle_load obj toplevel =
  let file_object = (cadr obj) in
  let file_name =
    (obj_to_string
       (eval file_object !global_env_ref))
  and initial_channel = !current_channel
  in
  begin
    (* Beware: the rest of the lexing buffer is lost here! *)
    current_channel := (open_in file_name);
    print_string ("Loading file " ^ file_name ^ "...\n");
    begin
      try toplevel ()
      with End_of_file -> ()
    end;
    close_in !current_channel;
    print_string ("File " ^ file_name ^ " loaded!\n");
    current_channel := initial_channel;
    reset_parser()	(* Necessary! *)
  end
;;

exception Lisp_continue;;

let handle_directive obj toplevel =
  if (listp obj) then
    let directive = (car obj) in
    if directive = lisp_load
    then (handle_load obj toplevel; raise Lisp_continue)
    else
    if (directive = lisp_define)
    then (handle_define obj; raise Lisp_continue)
    else
    if (directive = lisp_setq)
    || (directive = lisp_defun)
    then (handle_set obj; raise Lisp_continue)
;;

(** begin LISP *
    let prompt = "LISP";;
 ** end LISP *)

(** begin MLlisp_static *)
let prompt = "MLlisp_static";;
(** end MLlisp_static *)

let rec toplevel () =
  reset_parser ();
  while true do
    init_counter();
    print_newline ();
    print_string (prompt ^ "? ");
    flush(stdout);
    let obj = read ()
    in
    try
      begin
        handle_directive obj toplevel;
        print (eval obj !global_env_ref);
        print_newline();
      end
    with Lisp_continue -> ()
  done
;;

