(define fact
  (lambda (n)
    (if (= n 0) 1
      (* n (fact (+ n -1))))))

(define fib
  (lambda (n)
    (if (= n 0) 1
      (if (= n 1) 1
	(+ (fib (+ n -1)) (fib (+ n -2)))))))
