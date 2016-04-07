
(****************** Basic types ***************)

type

  lisp_object =
  | Lisp_symbol of string
  | Lisp_string of string
  | Lisp_num of int
  | Lisp_subr of (lisp_object -> lisp_object)
  | Lisp_list of (lisp_object list)
  (** begin MLlisp_static *)
  | Lisp_env of environment
  (** end MLlisp_static *)

and

  (** begin MLlisp_static *)
  binding = {name: string; mutable value: lisp_object}
(** end MLlisp_static *)

(** begin LISP *
    binding = {name: string; value: lisp_object}
 ** end LISP *)

and

  environment = binding list

;;

