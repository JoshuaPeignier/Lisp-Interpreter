
(define f (lambda (n) 0))))))))))

(define g (lambda (n) 0))))))))))

(setq f (lambda (n) (if (= n 0) 1 (+ (f (- n 1)) (g (- n 1))))))))

(setq g (lambda (n) (if (= n 0) 2  (+ (f (- n 1)) (g (- n 1))))))))

(f 10)

(g 10)
