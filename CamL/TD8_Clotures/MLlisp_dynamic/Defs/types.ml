
(****************** Basic types ***************)

type

  lisp_object =
  | Lisp_symbol of string
  | Lisp_string of string
  | Lisp_num of int
  | Lisp_subr of (lisp_object -> lisp_object)
  | Lisp_list of (lisp_object list)

and


  binding = {name: string; value: lisp_object}

and

  environment = binding list

;;

