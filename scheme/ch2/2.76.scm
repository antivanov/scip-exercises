(define pi 3.14159)

(define (attach-tag type-tag contents)
  (cons type-tag contents))
(define (type-tag datum)
  (if (pair? datum)
      (car datum)
      (error "Bad tagged datum -- TYPE-TAG" datum)))
(define (contents datum)
  (if (pair? datum)
      (cdr datum)
      (error "Bad tagged datum -- CONTENTS" datum)))

(define (generic-dispatch)
  (define (perimeter-rectangle r) (* 2 (+ (car r) (cdr r))))
  (define (area-rectangle r) (* (car r) (cdr r)))
  (define (make-rectangle x y)
    (attach-tag 'rectangle
              (cons x y)))
  (define (rectangle? r)
    (eq? (type-tag r) 'rectangle))

  (define (perimeter-circle r) (* 2 pi r))
  (define (area-circle r) (* pi r r))
  (define (make-circle r)
   (attach-tag 'circle r))
  (define (circle? c)
    (eq? (type-tag c) 'circle))

  (define (perimeter-line l) l)
  (define (area-line l) 0)
  (define (make-line l)
    (attach-tag 'line l))
  (define (line? l)
    (eq? (type-tag l) 'line))

  (define (perimeter z)
    (cond ((rectangle? z) (perimeter-rectangle (contents z)))
          ((circle? z) (perimeter-circle (contents z)))
          ((line? z) (perimeter-line (contents z)))
          (else (error "Unknown type -- PERIMETER" z))))

  (define (area z)
    (cond ((rectangle? z) (area-rectangle (contents z)))
          ((circle? z) (area-circle (contents z)))
          ((line? z) (area-line (contents z)))
          (else (error "Unknown type -- AREA" z))))

  (define rect (make-rectangle 3 4))
  (define circ (make-circle 1))
  (define line (make-line 5))

  (newline)
  (display "generic-dispatch")
  (newline)
  (display (perimeter rect))
  (newline)
  (display (area rect))
  (newline)
  (display (perimeter circ))
  (newline)
  (display (area circ))
  (newline)
  (display (perimeter line))
  (newline)
  (display (area line))
  (newline)
  (display "end")
'done)

(define (data-directed-dispatch)
  (define get 2d-get)
  (define put 2d-put!)
  (define (apply-generic op arg)
      (let ((proc (get op (type-tag arg))))
        (if proc
            (proc (contents arg))
            (error
              "No method for these types -- APPLY-GENERIC"
              (list op (type-tag arg))))))

  (define (perimeter-rectangle r) (* 2 (+ (car r) (cdr r))))
  (define (area-rectangle r) (* (car r) (cdr r)))
  (define (make-rectangle x y)
    (attach-tag 'rectangle
              (cons x y)))
  (put 'perimeter 'rectangle perimeter-rectangle)
  (put 'area 'rectangle area-rectangle)

  (define (perimeter-circle r) (* 2 pi r))
  (define (area-circle r) (* pi r r))
  (define (make-circle r)
   (attach-tag 'circle r))
  (put 'perimeter 'circle perimeter-circle)
  (put 'area 'circle area-circle)

  (define (perimeter-line l) l)
  (define (area-line l) 0)
  (define (make-line l)
   (attach-tag 'line l))
  (put 'perimeter 'line perimeter-line)
  (put 'area 'line area-line)

  (define (perimeter z)
    (apply-generic 'perimeter z))

  (define (area z)
    (apply-generic 'area z))

  (define rect (make-rectangle 3 4))
  (define circ (make-circle 1))
  (define line (make-line 5))

  (newline)
  (display "data-directed-dispatch")
  (newline)
  (display (perimeter rect))
  (newline)
  (display (area rect))
  (newline)
  (display (perimeter circ))
  (newline)
  (display (area circ))
  (newline)
  (display (perimeter line))
  (newline)
  (display (area line))
  (newline)
  (display "end")
'done)

(define (message-passing-dispatch)
  (define (make-rectangle x y)
    (define (dispatch op)
      (cond ((eq? op 'perimeter) (* 2 (+ x y)))
            ((eq? op 'area) (* x y))
            (else
              (error "Unknown op -- rectangle" op))))
    dispatch)

  (define (make-circle r)
    (define (dispatch op)
      (cond ((eq? op 'perimeter) (* 2 pi r))
            ((eq? op 'area) (* pi r r))
            (else
              (error "Unknown op -- circle" op))))
    dispatch)

  (define (make-line l)
    (define (dispatch op)
      (cond ((eq? op 'perimeter) l)
            ((eq? op 'area) 0)
            (else
              (error "Unknown op -- line" op))))
    dispatch)

  (define (apply-generic op arg) (arg op))
  (define (perimeter z)
    (apply-generic 'perimeter z))
  (define (area z)
    (apply-generic 'area z))

  (define rect (make-rectangle 3 4))
  (define circ (make-circle 1))
  (define line (make-line 5))

  (newline)
  (display "message-passing-dispatch")
  (newline)
  (display (perimeter rect))
  (newline)
  (display (area rect))
  (newline)
  (display (perimeter circ))
  (newline)
  (display (area circ))
  (newline)
  (display (perimeter line))
  (newline)
  (display (area line))
  (newline)
  (display "end")
'done)

(generic-dispatch)
(data-directed-dispatch)
(message-passing-dispatch)

; In all the scenarios data-directed style is better than explicit dispatch

; When adding new types fewer changes when using the explicit dispatch or data-directed style than with message-passing style
; When new operations are added it might be more convenient to use the message passing style