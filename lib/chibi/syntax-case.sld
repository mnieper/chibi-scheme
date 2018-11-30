(define-library (chibi syntax-case)
  (export ... _ free-identifier=? bound-identifier=?
	  syntax-case syntax with-syntax)
  (import (chibi)
	  (chibi ast)
	  (srfi 8)
	  (srfi 9)
	  (srfi 11))
  (include "syntax-case.scm"))
