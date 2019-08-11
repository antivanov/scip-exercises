(define (element-of-set? x set)
  (cond ((null? set) false)
        ((= x (car set)) true)
        ((< x (car set)) false)
        (else (element-of-set? x (cdr set)))))

(define (intersection-set set1 set2)
  (if (or (null? set1) (null? set2))
      '()
      (let ((x1 (car set1)) (x2 (car set2)))
        (cond ((= x1 x2)
               (cons x1
                     (intersection-set (cdr set1)
                                       (cdr set2))))
              ((< x1 x2)
               (intersection-set (cdr set1) set2))
              ((< x2 x1)
               (intersection-set set1 (cdr set2)))))))

(define (adjoin-set x set)
  (if (null? set) (list x)
      (let ((h (car set)))
        (cond
          ((< x h) (cons x set))
          ((= x h) set)
          (else (cons h (adjoin-set x (cdr set))))))))

(define (union-set set1 set2)
  (cond ((null? set1) set2)
        ((null? set2) set1)
        (else (let ((x1 (car set1)) (x2 (car set2)))
            (cond
              ((= x1 x2)
                (cons x1
                     (union-set (cdr set1)
                                (cdr set2))))
              ((< x1 x2)
                (cons x1 (union-set (cdr set1) set2)))
              ((< x2 x1)
                (cons x2 (union-set set1 (cdr set2)))))))))

(define s1 (list 1 2 3))
(define s2 (list 2 3 4 5))

(newline)
(display (adjoin-set 4 s1)) ; 1 2 3 4

(newline)
(display (adjoin-set 2 s1)) ; 1 2 3

(newline)
(display (adjoin-set 1 s2)) ; 1 2 3 4 5

(newline)
(display (intersection-set s1 s2)) ; 2 3

(newline)
(display (union-set s1 s2)) ; 1 2 3 4 5