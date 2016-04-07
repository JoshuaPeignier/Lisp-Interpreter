(define fact ())

(setq fact
      '(lambda (n k)
	   (if (= n 0) (k 1)
	     (fact (- n 1) (lambda (r) (k (* r n))))))))))))))

(define cont '(lambda (r) r))))

; (fact 2 cont)
