#! /usr/bin/env nix-shell
#! nix-shell -i "csi -script" -p chicken
#! nix-shell -p chickenPackages.chickenEggs.args
#! nix-shell -p chickenPackages.chickenEggs.matchable
#! nix-shell -p jujutsu

(import
  (chicken format)
  (chicken io)
  (chicken port)
  (chicken process)
  (chicken process-context)
  (chicken string)
  matchable
  args)

(define opts
  (list (args:make-option (b branch) #:required "Name of branch to fetch")))

(define (collect-unknown-options)
  (define (assemble-option n x)
    (if (not x)
        (dashify n)
        (string-append (dashify n) "=" x)))
  (lambda (o n x options operands)
          (values options (cons (assemble-option n x) operands))))

(define (collect-unknown-operands)
  (lambda (o options operands)
          (values options (cons o operands))))

;; Change #\c => "-c" and "cookie" to "--cookie".
;; Taken from `args.scm`
(define (dashify x)
  (if (char? x)
      (string #\- x)
      (string-append "--" x)))

(define (run-jj command)
  (let* ((pipe (open-input-pipe (string-append "jj " command " 2>&1")))
         (lines (read-lines pipe))
         (exit-code (close-input-pipe pipe)))
        (values lines exit-code)))

(receive
  (options operands)
  (args:parse (command-line-arguments) opts
              ; collect unknown arguments verbatim to re-emit into the commands
              #:operand-proc (collect-unknown-operands)
              #:unrecognized-proc (collect-unknown-options))
  (receive
    (lines exit-code)
    (run-jj "log --no-graph --revision 'latest(bookmarks() & first_ancestors(@))' --template 'separate(\" \", self.change_id(), self.bookmarks())'")
    (if (and (= exit-code 0) (not (null? lines)))
        (match-let (((bookmark-change-id bookmark) (string-split (car lines))))
                   (print (sprintf "Fetching bookmark '~A'" bookmark))
                   (receive
                     (lines exit-code)
                     (run-jj (sprintf "git fetch --branch '~A'" bookmark))
                     (if (and (= exit-code 0) (not (string=? (car lines) "Nothing changed.")))
                         (receive
                           (lines exit-code)
                           (run-jj (sprintf "log --no-graph --revision '~A+' --template 'self.change_id() ++ \"\\n\"'" bookmark-change-id))
                           (if (and (= exit-code 0) (not (null? lines)))
                               (for-each
                                 (lambda (change-id)
                                         (printf "Rebasing ~A onto ~A" change-id bookmark)
                                         (receive (_ exit-code)
                                                  (run-jj (sprintf "rebase --source ~A --onto ~A" change-id bookmark))
                                                  (if (= exit-code 0)
                                                      (printf " [OK]~%")
                                                      (printf " [FAILED]~%"))))
                                 lines)))
                         (printf "Nothing changed for bookmark ~A." bookmark))))
        (error "Failed to determine current bookmark"))))
