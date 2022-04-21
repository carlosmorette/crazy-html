#lang racket

(require brag/support)
(require br-parser-tools/lex)
(require br-parser-tools/lex-sre)

(provide tokenize)

(define (tokenize input)
  (port-count-lines! input)
  (define my-lexer
    (lexer-src-pos
     [(from/to "\"" "\"") (token 'STRING lexeme)]
     [(from/stop-before "--" "\n") (token 'COMMENT #:skip? #t)]
     ["[" (token 'OPEN-GROUP-PROPERTIES-SYMBOL lexeme)]
     ["{" (token 'OPEN-PROPERTIE-SYMBOL lexeme)]
     ["}" (token 'CLOSE-PROPERTIE-SYMBOL lexeme)]
     ["]" (token 'CLOSE-GROUP-PROPERTIES-SYMBOL lexeme)]
     ["," (token 'COMMA lexeme)]
     ["end" (token 'END-TAG lexeme)]
     ["->" (token 'ARROW-SYMBOL lexeme)]
     [(or "tag: " "tag:") (token 'TAG-IDENTIFIER lexeme)]
     [(or "childrens: " "childrens:") (token 'CHILDREN-IDENTIFIER lexeme)]
     [(or "properties: " "properties:") (token 'PROPERTIES-IDENTIFIER lexeme)]
     [(or "filename: " "filename:") (token 'FILENAME-IDENTIFIER lexeme)]
     [(concatenation (repetition 1 +inf.0 lower-case) (repetition 0 +inf.0 numeric)) (token 'TAG-NAME lexeme)]
     [whitespace (token 'WHITESPACE lexeme #:skip? #t)]
     [(eof) (void)]))
    
   (define (next-token) (my-lexer input))
   next-token)
