;;; TEST CODE
(import (chibi) (chibi ast))

(define-syntax plet
  (er-macro-transformer
   (lambda (expr rename compare)
     (let ((bindings (cadr expr))
	   (body (cddr expr)))
       `(,(rename 'let-syntax)
	 ,(map (lambda (binding)
		 (display binding) (newline)
		 `(,(car binding) (,(rename 'make-pattern-variable) ',(car binding))))
	       bindings)
	 (,(rename 'plet1) . ,(cdr expr)))))))

(define-syntax plet1
  (er-macro-transformer
   (lambda (expr rename compare)
     (let ((bindings (cadr expr))
	   (body (cddr expr)))
       (for-each (lambda (binding)
		   (let ((mac (cdr (env-cell (current-usage-environment)
					     (car binding)))))
		     (macro-aux-set! mac (cdr binding))))
		 bindings)
       `(,(rename 'begin) . ,body)))))

(define (make-pattern-variable pvar)
  (lambda (expr)
    (error "reference to pattern variable outside syntax" pvar)))

(define (pattern-variable x)
  (let ((cell (env-cell (current-usage-environment) x)))
    (and cell (macro? (cdr cell)) (macro-aux (cdr cell)))))


;; TEST CODE vvv
(define-syntax foo
  (lambda (expr)
    `(quote ,(pattern-variable (cadr expr)))))

(display
 (plet ((x 'bla 'blub)) x))
(newline)




;; (define (pattern-variable? id)

;;   ()

;;   )


;; (define-syntax syntax-case
;;   (er-macro-transformer
;;    (lambda (expr rename compare)
;;      (define _apply (rename 'apply))
;;      (define _e (rename 'e))
;;      (define _failure (rename 'failure))
;;      (define _lambda (rename 'lambda))
;;      (define _let (rename 'let))
;;      (define _let-syntax (rename 'let-syntax))
;;      (define _if (rename 'if))
;;      (define _error (rename 'error))
;;      (define _make_pattern_variable )
;;      (define (gen-clause lit* clause)
;;        (if (= 3 (length clause))
;; 	   (gen-output lit* (car clause) (cadr clause) (car (cddr clause)))
;; 	   (gen-output lit* (car clause) #t (cadr clause))))
;;      (define (gen-output lit* pattern fender output-expr)
;;        (receive (matcher vars)
;; 	   (gen-matcher _e lit* pattern '())
;; 	 (let ((x* (map car vars))
;; 	       (y* (map cdr vars))
;; 	       (e* (map car y*))
;; 	       (l* (map cadr y*)))
;; 	   (matcher (lambda ()
;; 		      `(,_let-syntax
;; 			,(map (lambda (var)
;; 				`(,(car var)
;; 				  (,_apply ,_make-pattern-variable var)))
;; 			      vars)
;; 			(,_set-bindings! ,vars)
;; 			...
;; 			)))))


;;        )
;;      (let ((expr (cadr expr))
;; 	   (lit* (car (cddr expr)))
;; 	   (clause* (reverse (cdr (cddr expr))))
;; 	   (error `(,_error "syntax error" e)))
;;        `(let ((,_e ,expr))
;; 	  ,(if (null? clause*)
;; 	       error
;; 	       `(let ((,_failure (,_lambda () ,error)))
;; 		  (let loop ((clause (car clauses))
;; 			     (clause* (cdr clause*)))
;; 		    (if (null? clauses)
;; 			(gen-clause lit* clause)
;; 			`(,_let ((,_failure (,_lambda () ,(gen-clause lit* clause))))
;; 			   ,(loop (car clause*) (cdr clause*))))))))))))
