
(setq t 't)

(setq a 1)

(setq b 2)

(setq f (lambda (m n) (+ m n)))

(setq l (quote ((a b) c d)))

(setq fact 
      (lambda (n)
	(if (= n 0) 1 (* n (fact (- n 1))))))

(setq fib (lambda (n) (cond 
		  ((= n 0) 1)
		  ((= n 1) 1)
		  (t (+ (fib (- n 1)) (fib (- n 2))))
		  )))

(load "ielm.lsp")

