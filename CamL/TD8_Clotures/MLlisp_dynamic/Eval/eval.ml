
(********************** The core ************************************)

let rec

  eval_list l env =
  if (nullp l) then nil
  else (cons (eval (car l) env) (eval_list (cdr l) env))

and

  do_progn l env =
  if (nullp l) then nil
  else if (nullp (cdr l))
  then (eval (car l) env)
  else
    begin
      (ignore (eval (car l) env));
      do_progn (cdr l) env
    end

and

  do_if l env =
  let test_part = (car l)
  and then_part = (cadr l)
  and else_part = (caddr l)
  in
  if not (nullp (eval test_part env))
  then eval then_part env
  else eval else_part env

and

  do_cond l env =
  if (nullp l) then nil
  else
    let test_part = (caar l)
    and then_part = (cadar l)
    in
    if not (nullp (eval test_part env))
    then eval then_part env
    else do_cond (cdr l) env

and

  do_andthen l env =
  let part1 = (car l)
  and part2 = (cadr l)
  in
  if not (nullp (eval part1 env))
  then (eval part2 env)
  else nil

and

  eval obj env =
  if not (!debug) then eval' obj env
  else
    begin
      print_string_level " --> ";
      incr_counter();
      print obj;
      print_string "\t| ";
      print_env env;
      print_newline();
      let obj' = (eval' obj env)
      in
      begin
        decr_counter();
        print_string_level " <-- ";
        print obj';
        print_newline();
        obj'
      end
    end

and

  eval' obj env =
  if (nullp obj) then obj
  else if (obj = lisp_t) then obj
  else if (numberp obj) then obj
  else if (stringp obj) then obj
  else if (subrp obj) then obj
  else if (symbolp obj)
  then (get_value_env obj env)
  else
    begin

      if (car obj) = lisp_lambda then obj

      else if (car obj) = lisp_let
      then (eval (macro_let_to_lambda obj) env)

      else if (car obj) = lisp_printenv then (print_env' env; nil)
      else if (car obj) = lisp_quote then (cadr obj)
      else if (car obj) = lisp_if then do_if (cdr obj) env
      else if (car obj) = lisp_cond then do_cond (cdr obj) env
      else if (car obj) = lisp_andthen then do_andthen (cdr obj) env
      else if (car obj) = lisp_progn then do_progn (cdr obj) env
      else
        let f = (car obj)
        and largs = (cdr obj)
        in
        let lvals =  (eval_list largs env)
        in (apply f lvals env)
    end

and

  apply f lvals env =
  if (nullp f) then error "Cannot apply nil"
  else if (numberp f) then error2 f "Cannot apply a number"
  else if (stringp f) then error2 f "Cannot apply a string"
  else if (subrp f) then ((subr_to_fun f) lvals)
  else if (symbolp f)
  then
    let new_f = (eval f env)
    in (apply new_f lvals env)
  else
    begin
      if ((car f) = lisp_lambda)
      then
        let body =  (caddr f)
        and lpars = (cadr f)
        in
        let new_env = (extend_largs_env lpars lvals env)
        in (eval body new_env)


      else error2 f "Cannot apply a list"
    end

and

  do_eval lvals =
  eval (car lvals) !global_env_ref

and

  do_apply lvals =
  apply (car lvals) (cadr lvals) !global_env_ref

;;

