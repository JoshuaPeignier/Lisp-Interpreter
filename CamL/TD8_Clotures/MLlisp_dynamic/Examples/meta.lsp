(setq t 't)

(setq error 
  '(lambda (s env) 
;;     (lowlevel_error (concat "MLisp: " s)))))))))
     (progn 
       (print (cons "MLisp: " s))
       (newline)
       (toplevel env))))
	    

(setq cadr '(lambda (l) (car (cdr l))))
(setq caddr '(lambda (l) (cadr (cdr l))))
(setq cadddr '(lambda (l) (caddr (cdr l))))
(setq caar '(lambda (l) (car (car l))))
(setq cadar '(lambda (l) (car (cdr (car l)))))

(setq listii 
  '(lambda (l m) (cons l (cons m ()))))
(setq listiii 
  '(lambda (l m n) (cons l (cons m (cons n ())))))

(setq env 
  '(
    (fact 
     (lambda (n) (if (= n 0) 1 (* n (fact (- n 1))))))
    (plus +) 
    (a 1) 
    (b 2)
    (+ (subr +))
    (* (subr *))
    (- (subr -))
    (= (subr =))
    (eq (subr eq))
    (car (subr car))
    (cons (subr cons))
    (cdr (subr cdr))
    (null (subr null))
    (numberp (subr numberp))
    (stringp (subr stringp))
    (listp (subr listp))
    (atom_to_string (subr atom_to_string))
;    (error (subr error))
    (print (subr print))
    (read (subr read))
    (newline (subr newline))
    (concat (subr concat))
    ))

(setq assoc 
  '(lambda (a l)
     (if (null l) 
	 (error (listii "Undefined variable: " a) env)
       (if (eq a (caar l)) (cadar l)
	 (assoc a (cdr l))))))

(setq eval_list
  '(lambda (l env)
     (if (null l) l
       (cons (eval (car l) env) 
	     (eval_list (cdr l) env)))))

(setq eval_cond 
  '(lambda (l) 
     (if (null l) nil
       (if (eval (caar l) env)
	   (eval (cadar l) env)
	 (eval_cond (cdr l))))))

(setq eval_if
  '(lambda (l) 
     (if (eval (car l) env)
	 (eval (cadr l) env)
       (eval (caddr l) env))))

(setq eval_progn
  '(lambda (l)
     (if (null l) nil
       (if (null (cdr l)) (eval (car l) env)
	 (progn (eval (car l) env) 
		(eval_progn (cdr l) env))))))

(setq eval_andthen
  '(lambda (l)
     (if (eval (car l) env)
	 (eval (cadr l) env)
       nil)))

(setq list_car 
  '(lambda (l)
     (if (null l) nil
       (cons (car (car l)) (list_car (cdr l))))))

(setq list_cadr 
  '(lambda (l)
     (if (null l) nil
       (cons (cadr (car l)) (list_cadr (cdr l))))))

(setq macro_let_to_lambda 
  '(lambda (obj)
     (let ((binding_list (cadr obj))
	   (body (caddr obj)))
       (let ((lpars (list_car binding_list))
	     (largs (list_cadr binding_list)))
	 (cons 
	  (listiii 'lambda lpars body) 
	  largs)))))

(setq eval 
  '(lambda (obj env)
     (cond 
      ((null obj) obj)
      ((numberp obj) obj)
      ((stringp obj) obj)
      ((symbolp obj) (assoc obj env))
      (t
       (let ((f (car obj)))
	 (cond 
	  ((eq f 'quote) (cadr obj))
	  ((eq f 'lambda) obj)
	  ((eq f 'if) (eval_if (cdr obj)))
	  ((eq f 'cond) (eval_cond (cdr obj)))
	  ((eq f 'progn) (eval_progn (cdr obj)))
	  ((eq f 'andthen) (eval_andthen (cdr obj)))
	  ((eq f 'let) 
	   (eval (macro_let_to_lambda obj) env))
	  (t (apply f (eval_list (cdr obj) env) env)))))
      )))

(setq lowlevel_apply apply) ; Saving the original apply function

(setq apply 
  '(lambda (f lvals env)
     (cond 
      ((null f) (error "Cannot apply nil!" env))
      ((numberp f) (error "Cannot apply a number!" env))
      ((stringp f) (error "Cannot apply a string!" env))
      ((symbolp f)
       (apply (eval f env) lvals env))
      ((listp f)
       (cond
	((eq (car f) 'subr)
	 (lowlevel_apply (cadr f) lvals))
	((eq (car f) 'lambda)
	 (let ((largs (cadr f))
	       (body (caddr f)))
	   (eval body (extend_env largs lvals env))))
	(t (error "Cannot apply a list!" env))))
      (t (error "Unexpected function" env))
      )))

(setq extend_env 
  '(lambda (largs lvals env)
     (if (null largs) env
       (cons (listii (car largs) (car lvals))
	     (extend_env (cdr largs) (cdr lvals) env)))))

(setq toplevel
  '(lambda (env)
     (progn
       (print "MLisp? ")
       (let ((l (read)))
	 (cond 
	  ((andthen (listp l) (eq (car l) 'quit))
	   (progn
	     (print "Let MLisp be with you...")
	     (newline)
	     ()))
	  ((andthen (listp l) (eq (car l) 'setq))
	   (let ((x (cadr l))
		 (v (eval (caddr l) env)))
	     (progn
	       (print "MLisp: ")
	       (print x)
	       (print " = ")
	       (print v)
	       (newline)
	       (toplevel (cons (listii x v) env)))))
	  (t
	   (progn
	     (print (eval l env))
	     (newline)
	     (toplevel env))))))))


(setq my_go
  '(lambda () (toplevel env)))
