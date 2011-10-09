(use-modules (srfi srfi-1)
	     (ice-9 rdelim))

(define (file->lines infile)
  (let loop ((result '()))
    (let ((next (read-line infile)))
      (if (eof-object? next)
	  (reverse result)
	  (loop (cons next result))))))

(define (write-line x)(display x)(newline))

(define (not-blank? line)        (not (equal? line "")))
(define (start-alphabetic? line) (char-alphabetic? (string-ref line 0)))
(define (first-word line)
  (let ((idx (string-index line char-whitespace?)))
    (if idx (string-take line idx) line)))

;; group lines by 'those that should be merged':
(define (unwrap-lines lines)
  (fold-right
   (lambda (line result)
     (if (null? result)
	 (list (list line)) ;; init with final line alone in a group
	 (let ((next-line (caar result)))
	   (if (and (not-blank? line)
		    (not-blank? next-line)
		    (and (start-alphabetic? next-line)
			 (> (string-length
			     (string-append line " " (first-word next-line)))
			    (string-length next-line))))
	       ;; merge lines
	       (cons (cons line (car result))
		     (cdr result))
	       ;; don't merge
	       (cons (list line) result)))))
   '()
   lines))

;; FIXME insert interstitial spaces
(define (flatten-string-groups groups)
  (map (lambda (strs)
	 (fold-right
	  (lambda (next result)
	    (if (not-blank? result)
		(string-append next " " result)
		next))
	  ""
	  strs))
       groups))

;; Main procedure
(let ((infile (if (null? (cdr (command-line)))
		  (current-input-port)
		  (open-input-file (cadr (command-line))))))
  (for-each
   write-line
   (flatten-string-groups (unwrap-lines (file->lines infile)))))
