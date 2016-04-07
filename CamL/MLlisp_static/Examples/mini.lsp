;; Meta-interpreter Lisp, March 2, 2007, by Luc Bougé
;; Extended with the let construct on Nov. 6, 2007

(defun caar (l) (car (car l)))
(defun cadr (l) (car (cdr l)))
(defun cadar (l) (car (cdr (car l))))
(defun caddr (l) (car (cdr (cdr l))))
(defun list1 (a) (cons a ()))
(defun list2 (a b) (cons a (cons b ())))
(defun list3 (a b c) (cons a (cons b (cons c ()))))

(defun my-error (s) 
  (progn (print "MY-LISP error: ") 
	 (print s)
	 (newline)
	 (error "Giving up...")))

(defun my-error2 (x s) 
  (progn (print "MY-LISP error: ") 
	 (print s)  
	 (print ": ")
	 (print x)
	 (newline)
	 (error "Giving up...")))

(defun my-eval (l env)
  (cond 
   ((null l) l)
   ((eq l 't) l)
   ((numberp l) l)
   ((stringp l) l)
   ((symbolp l) (my-get-value l env))
   ((eq (car l) 'quote) (cadr l))
   ((eq (car l) 'cond) (my-eval-cond (cdr l) env))
   ((eq (car l) 'if) (my-eval-if (cdr l) env))
   ((eq (car l) 'let) (my-eval-let (cadr l) (caddr l) env))
   ((eq (car l) 'lambda) l)
   (t (my-apply (car l) (my-eval-list (cdr l) env) env))
   ))

(defun my-eval-list (largs env)
  (if (null largs) ()
    (cons (my-eval (car largs) env) (my-eval-list (cdr largs) env))))

(defun my-eval-cond (lclauses env)
  (if (null lclauses) 
      ()
    (if (my-eval (caar lclauses) env) 
	(my-eval (cadar lclauses) env) 
      (my-eval-cond (cdr lclauses) env))))

(defun my-eval-if (lparts env)
  (if (my-eval (car lparts) env)
      (my-eval (cadr lparts) env)
    (my-eval (caddr lparts) env)))

(defun unzip-left (lbindings)
  (if (null lbindings) nil
    (cons (caar lbindings) (unzip-left (cdr lbindings)))
    ))

(defun unzip-right (lbindings)
  (if (null lbindings) nil
    (cons (cadar lbindings) (unzip-right (cdr lbindings)))
    ))

(defun my-eval-let (lbindings body env)
  (my-eval body (my-extend-env (unzip-left lbindings)
			       (my-eval-list (unzip-right lbindings) env) env))
    )

(defun my-apply (f lvals env)
  (cond 
   ((null f) (my-error "Cannot apply nil"))
   ((numberp f) (my-error2 f "Cannot apply a number"))
   ((stringp f) (my-error2 f "Cannot apply a string"))
   ((symbolp f) (my-apply-symbol f lvals env))
   ((eq (car f) 'lambda)
    (my-eval (caddr f) (my-extend-env (cadr f) lvals env)))
   (t (my-error2 f "Cannot apply a list"))
   ))

(defun my-apply-symbol (f lvals env)
  (cond 
   ((eq f '+) (+ (car lvals) (cadr lvals)))
   ((eq f '*) (* (car lvals) (cadr lvals)))
   ((eq f '-) (- (car lvals) (cadr lvals)))
   ((eq f '=) (= (car lvals) (cadr lvals)))
   ((eq f 'car) (car (car lvals)))
   ((eq f 'cdr) (cdr (car lvals)))
   ((eq f 'cons) (cons (car lvals) (cadr lvals)))
   ((eq f 'null) (null (car lvals)))
   ((eq f 'end) (my-error "See you later, alLISPator!"))
   (t (my-apply (my-eval f env) lvals env))
   ))

(defun my-get-value (x env)
  (if (null env) (my-error2 x "Undefined symbol")
    (if (eq (caar env) x) (cadar env)
      (my-get-value x (cdr env)))))

(defun my-extend-env (lpars lvals env)
  (if (null lpars)
      (if (null lvals) env
	(my-error2 lvals "Too many args"))
    (if (null lvals) 
	(my-error2 lpars "Not enough args")
      (my-extend-env (cdr lpars) (cdr lvals)
		     (cons (list2 (car lpars) (car lvals)) env)))))

(setq env 
      '(
	(a b) (b c) (c +)
	(a 1)
	(b 2)
	(c 3)
	(d 4)
	(e 5)
	(plus1 (lambda (x) (+ x 1)))
	(fact (lambda (n) (if (= n 0) 1 (* n (fact (- n 1))))))
	(fib (lambda (n) (cond 
			  ((= n 0) 1)
			  ((= n 1) 1)
			  (t (+ (fib (- n 1)) (fib (- n 2))))
			  )))

	))

(defun my-toplevel (env)
  (progn
    (print "MY-LISP? ")
    (print (my-eval (read) env))
    (newline)
    (my-toplevel env)
))

(defun go () (my-toplevel env))

    

