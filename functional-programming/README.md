# Functional programming in the Racket language

The programs in this folder demonstrate an understanding of
recursion, a LISP language, pattern-matching, lambda calculus,
and building language interpreters
(with both data-structural and functional representations).

The `racket-functions.rkt` file contains basic list-manipulation functions
like append, map, reverse, and powerset. It also contains functions for examining
lambda-calculus expressions, and it has a syntax definition for creating a custom macro in Racket.

The `lambda-calculus-interpreters.rkt` file contains two functions
value-of-fn and value-of-ds which evaluate the value of the given expression.
The language these functions interpret is a simple lambda calculus with
variables, numbers, booleans, simple functions (zero?, sub1, etc.),
simple control flow (if-else-statements, let-statements),
closures, and application of closures to one operand.

There is a small set of tests at the bottom of each file.
