
(****************** Closure ***************)

let lisp_closure = string_to_obj "closure";;

let make_closure body env =
	(cons lisp_closure (cons body (cons (env_to_obj env) nil)))
;;

let check_closure c =
	if not ((car c) = lisp_closure)
	then error2 c "Not a closure"
;;

let get_body_closure c =
	check_closure c;
	cadr c
;;

let get_env_closure c =
	check_closure c;
	obj_to_env (caddr c)
;;

