(define fib
  (lambda (n)
     (if (= n 0) 1
       (if (= n 1) 1
	 (+ (fib (- n 1)) (fib (- n 2)))))))))))))))

