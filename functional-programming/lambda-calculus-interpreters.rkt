#lang racket

;using a data-structural representation of environment
(define empty-env (lambda () `(empty-env)))
(define extend-env (lambda (x a env) `(extend-env ,x ,a ,env)))
(define apply-env
  (lambda (env y)
    (match env
      [`(empty-env) (error 'value-of "unbound variable ~s" y)]
      [`(extend-env ,x ,a ,env) (if (eqv? y x) a (apply-env env y))])))

;interpreter which uses functional representation of closures
(define value-of-fn
  (lambda (exp env)
    (match exp
      [(? symbol?) (apply-env env exp)]
      [(? number?) exp]
      [(? boolean?) exp]
      [`(zero? ,e) (zero? (value-of-fn e env))]
      [`(sub1 ,e) (sub1 (value-of-fn e env))]
      [`(* ,e1 ,e2) (* (value-of-fn e1 env) (value-of-fn e2 env))]
      [`(if ,e1 ,e2 ,e3)
       (if (value-of-fn e1 env) (value-of-fn e2 env) (value-of-fn e3 env))]
      [`(let ([,x ,e]) ,body)
       (let ([e-value (value-of-fn e env)])
         (value-of-fn body (extend-env x e-value env)))]
      [`(lambda (,x) ,body) (closure-fn x body env)]
      [`(,rator ,rand)
       (apply-closure-fn (value-of-fn rator env) (value-of-fn rand env))])))

(define closure-fn
  (lambda (x body env)
    (lambda (a) (value-of-fn body (extend-env x a env)))))

(define apply-closure-fn
  (lambda (operator operand) (operator operand)))

;interpreter which uses data-structural representation of closures
(define value-of-ds
  (lambda (exp env)
    (match exp
      [(? symbol?) (apply-env env exp)]
      [(? number?) exp]
      [(? boolean?) exp]
      [`(zero? ,e) (zero? (value-of-ds e env))]
      [`(sub1 ,e) (sub1 (value-of-ds e env))]
      [`(* ,e1 ,e2) (* (value-of-ds e1 env) (value-of-ds e2 env))]
      [`(if ,e1 ,e2 ,e3)
       (if (value-of-ds e1 env) (value-of-ds e2 env) (value-of-ds e3 env))]
      [`(let ([,x ,e]) ,body)
       (let ([e-value (value-of-ds e env)])
         (value-of-ds body (extend-env x e-value env)))]
      [`(lambda (,x) ,body) (closure-ds x body env)]
      [`(,rator ,rand)
       (apply-closure-ds (value-of-ds rator env) (value-of-ds rand env))])))

(define closure-ds
  (lambda (x body env) `(closure ,x ,body ,env)))

(define apply-closure-ds
  (lambda (operator operand)
    (match operator
      [`(closure ,x ,body ,env)
       (value-of-ds body (extend-env x operand env))])))

;===================================================================
;TESTS

;simple assertion function for testing
(define assert
  (lambda (bool)
    (if bool (void) (error "Failed Test"))))

;lambda-calculus expressions to test
(define test-program-1
  '((lambda (x)
      (if (zero? x) 73 481)) 
     0))

(define test-program-2
  '(let ([y (* 4 6)])
     ((lambda (x) (* x y)) (sub1 3))))

(define test-program-3
  '(let ([x (* 3 3)])
     (let ([y (sub1 x)])
       (* x y))))

(define test-program-4
  '(let ([x (* 3 3)])
     (let ([x (sub1 x)])
       (* x x))))

(assert (equal? 73 (value-of-fn test-program-1 (empty-env))))
(assert (equal? 48 (value-of-fn test-program-2 (empty-env))))
(assert (equal? 72 (value-of-fn test-program-3 (empty-env))))
(assert (equal? 64 (value-of-fn test-program-4 (empty-env))))
(assert (equal? 73 (value-of-ds test-program-1 (empty-env))))
(assert (equal? 48 (value-of-ds test-program-2 (empty-env))))
(assert (equal? 72 (value-of-ds test-program-3 (empty-env))))
(assert (equal? 64 (value-of-ds test-program-4 (empty-env))))