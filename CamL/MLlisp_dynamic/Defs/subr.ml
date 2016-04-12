
(********************* Subr functions management *****)

let register_subr symbol f =
  global_env_ref := update_env_extend
      symbol (fun_to_subr f) !global_env_ref
;;

let init_env_subr () =
  begin
    register_subr lisp_plus do_plus; (* Done *)
    register_subr lisp_mult do_mult; (* Done *)
    register_subr lisp_minus do_minus; (* Done *)
    register_subr lisp_car do_car; (* Done *)
    register_subr lisp_cdr do_cdr; (* Done *)
    register_subr lisp_cons do_cons; (* Done *)
    register_subr lisp_eq do_eq;
    register_subr lisp_equal do_equal;
    register_subr lisp_read do_read;
    register_subr lisp_print do_print;
    register_subr lisp_newline do_newline;
    register_subr lisp_numberp do_numberp;
    register_subr lisp_null do_null;
    register_subr lisp_symbolp do_symbolp;
    register_subr lisp_stringp do_stringp;
    register_subr lisp_listp do_listp;
    register_subr lisp_debug do_debug;
    register_subr lisp_concat do_concat;
    register_subr lisp_eval do_eval;
    register_subr lisp_apply do_apply;
    register_subr lisp_error do_error;
    register_subr lisp_end do_end;
  end
;;

