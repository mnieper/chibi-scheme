(define-library (chibi syntax-case-test)
  (export run-tests)
  (import (chibi)
	  (chibi syntax-case)
	  (chibi test))
  (begin
    (define (run-tests)
      (test-begin "Syntax Case")

      (test "syntax constant list"
	    '(+ 1 2)
	    #'(+ 1 2))

      (test "pattern variable"
	    'foo
	    (syntax-case 'foo ()
	      (x #'x)))

      (test "syntax-case pair"
	    '(a b)
	    (syntax-case '(a . b) ()
	      ((x . y) #'(x y))))

      (test "syntax-case var"
	    'a
	    (syntax-case '(a . b) (b)
	      ((b . y) #f)
	      ((x . b) #'x)))

      (test-end))))
