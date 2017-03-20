#lang racket

;returns filtered list with items from ls that satisfy pred
(define filter
  (lambda (pred ls)
    (cond
      [(null? ls) '()]
      [(pred (car ls)) (cons (car ls) (filter pred (cdr ls)))]
      [else (filter pred (cdr ls))])))

;returns list with function p applied to each item in ls
(define map
  (lambda (p ls)
    (cond
      [(null? ls) '()]
      [else (cons (p (car ls)) (map p (cdr ls)))])))

;returns flat list with items from ls2 appended to ls1
(define append
  (lambda (ls1 ls2)
    (cond
      [(null? ls1) ls2]
      [else (cons (car ls1) (append (cdr ls1) ls2))])))

;returns reverse of list ls
(define reverse
  (lambda (ls)
    (cond
      [(null? ls) '()]
      [else (append (reverse (cdr ls)) (cons (car ls) '()))])))

;returns n-th fibonacci number where (fib 0) = 0, (fib 1) = 1
(define fib
  (lambda (n)
    (cond
      [(or (zero? n) (zero? (sub1 n))) n]
      [else (+ (fib (sub1 n)) (fib (sub1 (sub1 n))))])))

;returns list representing the set difference s1 \ s2
(define set-difference
  (lambda (s1 s2)
    (cond
      [(null? s1) '()]
      [(member (car s1) s2) (set-difference (cdr s1) s2)]
      [else (cons (car s1) (set-difference (cdr s1) s2))])))

;returns the powerset of set s
(define powerset
  (lambda (s)
    (cond
      [(null? s) '(())]
      [else
       (let ([rest (powerset (cdr s))])
         (append (map (lambda (x) (cons (car s) x)) rest) rest))])))

;returns the set union of ls1 and ls2
(define union
  (lambda (ls1 ls2)
    (letrec
        ([helper
          (lambda (s1 s2 out)
            (cond
              [(and (null? s1) (null? s2)) out]
              [(null? s1)
               (if (memv (car s2) out)
                   (helper s1 (cdr s2) out)
                   (helper s1 (cdr s2) (cons (car s2) out)))]
              [else
               (if (memv (car s1) out)
                   (helper (cdr s1) s2 out)
                   (helper (cdr s1) s2 (cons (car s1) out)))]))])
      (helper ls1 ls2 '()))))

;returns boolean of whether symbol s occurs in lambda-calculus expression e
(define var-occurs?
  (lambda (s e)
    (match e
      [(? symbol?) (eqv? s e)]
      [`(lambda (,x) ,body) (var-occurs? s body)]
      [`(,rator ,rand)
       (or (var-occurs? s rator) (var-occurs? s rand))])))

;returns list containing all unique variables that occur in expression e
(define unique-vars
  (lambda (e)
    (match e
      [(? symbol?) (list e)]
      [`(lambda (,x) ,body) (unique-vars body)]
      [`(,rator ,rand) (union (unique-vars rator) (unique-vars rand))])))

;macro that behaves like Racket's and
(define-syntax and*
  (syntax-rules ()
    [(_) #t]
    [(_ e) e]
    [(_ e0 e* ...) (if e0 (and* e* ...) #f)]))

;===================================================================
;TESTS

;simple assertion function for testing
(define assert
  (lambda (bool)
    (if bool (void) (error "Failed Test"))))

(assert (equal? (filter odd? '(1 2 3 4 5 6 7 8)) '(1 3 5 7)))
(assert (equal? (map sub1 '(1 2 3 4)) '(0 1 2 3)))
(assert (equal? (append '(1 2) '(a b)) '(1 2 a b)))
(assert (equal? (reverse '(1 2 a b c 3)) '(3 c b a 2 1)))
(assert (equal? (fib 8) 21))
(assert (equal? (set-difference '(1 2 3 4) '(2 3)) '(1 4)))
(assert (equal? (powerset '(1 2 3)) '((1 2 3) (1 2) (1 3) (1) (2 3) (2) (3) ())))
(assert (equal? (union '(1 2) '(1 2 3)) '(3 2 1)))
(assert (equal? (var-occurs? 'x '(lambda (x) (x y))) #t))
(assert (equal? (var-occurs? 'x '(lambda (z) (z y))) #f))
(assert (equal? (unique-vars '((lambda (x) (y y)) z)) '(z y)))
(assert (equal? (and* 1 2 3) 3))
(assert (equal? (and* #t #f) #f))
(assert (equal? (and*) #t))
