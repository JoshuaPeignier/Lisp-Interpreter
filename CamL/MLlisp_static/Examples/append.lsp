(define append ())

(setq append
      '(lambda (l m k)
;; 	 (progn (printenv) (newline) (newline) (newline)
	   (if (null l) (k m)
	     (append (cdr l) m
		     (lambda (r)
		       (k (cons (car l) r))))))))))))

(define cont '(lambda (r) (cons '0 r)))

; (append '(1 2 3) '(4 5 6) cont)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define reverse ())

(setq reverse
      '(lambda (l k)
	 (if (null l) (k l)
	   (reverse (cdr l)
		    (lambda (r) (append r (cons (car l) ()) k)))))))

(define cont '(lambda (r) (cons '0 r)))

; (reverse '(1 2 3 4 5 6) cont)
