#! /usr/bin/env nix-shell
#! nix-shell -i "csi -script" -p chicken
#! nix-shell -p chickenPackages.chickenEggs.medea
#! nix-shell -p chickenPackages.chickenEggs.args
#! nix-shell -p fzf

(import
  (chicken condition)
  (chicken file)
  (chicken io)
  (chicken pathname)
  (chicken port)
  (chicken process signal)
  (chicken process)
  (chicken process-context)
  (chicken string)
  args
  medea
  srfi-1)

(define FZF_CMD (or (get-environment-variable "FZF_CMD") "fzf"))
(define FZF_FLAGS '("--delimiter" "\t"
                    "--no-sort"
                    "--with-nth" "{2} [{3}] {1}"
                    "--with-nth" "{2} [{3}] {1}"
                    "--accept-nth" "{4}\t{1}"))

(define opts
  (list (args:make-option (folder f) (#:required "projects") "claude-code projects folder")
        (args:make-option (c claude-command)  #:required "claude-code command to execute")
        (args:make-option (h help)  #:none "Display help" (usage))))

(define (usage)
  (with-error-output-to-port (current-error-port)
                             (lambda ()
                                     (print "Usage: " (car (argv)))
                                     (print (args:usage opts)))))

(define (process-jsonl file)
  ; OPTIM: Only read lines until we populated the required values
  (let* ((lines (call-with-input-file file (lambda (port) (read-lines port))))
         (jsons (reverse (map read-json lines)))
         (cwd (any (lambda (json) (alist-ref 'cwd json)) jsons))
         (sessionId (any (lambda (json) (alist-ref 'sessionId json)) jsons))
         (customTitle (any (lambda (json)
                                   (if (equal? (alist-ref 'type json) "custom-title")
                                       (alist-ref 'customTitle json)
                                       #f))
                           jsons))
         (aiTitle (any (lambda (json)
                               (if (equal? (alist-ref 'type json) "ai-title")
                                   (alist-ref 'aiTitle json)
                                   #f))
                       jsons)))
        `((cwd . ,cwd) (sessionId . ,sessionId) (customTitle . ,customTitle) (aiTitle . ,aiTitle))))

(define (pick-fzf from-files)
  (receive
    (input output pid) (process FZF_CMD FZF_FLAGS)
    ; OPTIM: Parse all files in parallel
    ; NOTE: If we select something before the following has completed
    ; populating the fzf items, the `write-line` will error because fzf is
    ; terminated, and as a result the output port is closed. This leads to a
    ; fatal error that terminates this program, so we need to handle it
    ; properly.
    (signal-ignore signal/pipe)
    (for-each (lambda (file)
                      (let* ((json (process-jsonl file))
                             (fields (list (or (alist-ref 'cwd json) "NOCWD")
                                           (or (alist-ref 'customTitle json) "")
                                           (or (alist-ref 'aiTitle json) "")
                                           (or (alist-ref 'sessionId json) "NOID")))
                             (line (string-intersperse fields "\t")))
                            (handle-exceptions
                              exn
                              (void)
                              (begin
                                (write-line line output)
                                (flush-output output)))))
              from-files)
    (close-output-port output)
    (signal-default signal/pipe)
    (let ((choice (read-line input)))
         (close-input-port input)
         choice)))

(receive
  (options operands) (args:parse (command-line-arguments) opts)
  (let* ((claude-folder (or (alist-ref 'folder options)
                            (make-pathname (get-environment-variable "HOME") ".claude/projects")))
         (claude-command (or (alist-ref 'claude-command options)
                             "claude"))
         (choice (pick-fzf (find-files claude-folder
                                       limit: 1
                                       test: '(seq (* any) ".jsonl" eos)))))
        (if (not (equal? choice #!eof))
            (let* ((c (string-split choice))
                   (session-id (car c))
                   (session-directory (car (cdr c))))
                  (print "Resuming session: " session-id)
                  (print "Running in directory: " session-directory)
                  (change-directory session-directory)
                  (process-execute claude-command (list "-r" session-id)))
            (print "Nothing selected."))))
