#lang racket

(require syntax/strip-context)
(require "tokenizer.rkt" "parser.rkt")

(provide (rename-out [my-read-syntax read-syntax]))

(define (my-read-syntax src input)
  (define parsed (parse src (tokenize input)))
  (strip-context
   (datum->syntax #f `(module crazy-html-module "expander.rkt"
                        ,parsed))))
