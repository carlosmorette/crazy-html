#lang racket

(require
 (for-syntax syntax/parse
             racket/syntax
             racket/string
             racket/format))

(provide program tag childrens propertie #%module-begin)

(define-for-syntax (eval-and-clean-string str)
  (string-replace (syntax-e str) "\"" ""))

(define-syntax (program stx)
  (syntax-parse stx
    [({~literal program} ({~literal filename} filename) program ...)
     (with-syntax ([filename (eval-and-clean-string #'filename)])
       #'(begin
           (define out (open-output-file filename #:exists 'replace))
           (displayln "<!DOCTYPE html>" out)
           (displayln program ... out)
           (close-output-port out)))]))

(define-syntax (tag stx)
  (syntax-parse stx
    [({~literal tag} tag-name)
     #'(format "<~a></~a>" (syntax-e #'tag-name) (syntax-e #'tag-name))]

    [({~literal tag} tag-name ({~literal group-properties} properties ...) more ...)
     #'(format "<~a ~a>~a</~a>"
               (syntax-e #'tag-name)
               (~a properties ...)
               (~a more ...)
               (syntax-e #'tag-name))]

    [({~literal tag} tag-name ({~literal group-properties} properties ...))
     #'(format "<~a ~a></~a>" (syntax-e #'tag-name) (~a properties ...) (syntax-e #'tag-name))]

    [({~literal tag} tag-name more ...)
     #'(format "<~a>~a</~a>" (syntax-e #'tag-name) (~a more ...) (syntax-e #'tag-name))]))

(define-syntax (childrens stx)
  (syntax-parse stx
    [({~literal childrens} children)
     (if (string? (syntax-e #'children))
         (with-syntax ([value (eval-and-clean-string #'children)])
           #'value)
         #'children)]
    
    [({~literal childrens} more ...)
     #'(~a more ...)]))

(define-syntax (propertie stx)
  (syntax-parse stx
    [({~literal propertie} name value)
     (with-syntax ([p-name (eval-and-clean-string #'name)])
       #'(format "~a=~a" p-name (syntax-e #'value)))]

    [({~literal propertie} name value more ...)
     (with-syntax ([p-name (eval-and-clean-string #'name)])       
       #'(format "~a=~a ~a"
                 p-name
                 (syntax-e #'value)
                 more ...))]))
