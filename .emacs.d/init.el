;;
;;      .emacs  Emacs-Lisp initialization file

;;
;;----------------------------------------------------------
;; Initialization
;;
(put 'eval-expression 'disabled nil)    ; enable eval-expression
(put 'narrow-to-region 'disabled nil)   ; enable narrow-to-region
(put 'suspend-emacs 'disabled nil)      ; you can suspend Emacs (not under X)
(setq inhibit-default-init t)           ; no goofy init message
;(setq pop-up-windows t)                 ; enable opening other windows
(setq meta-flag t)                      ; enable meta-key
(setq-default indent-tabs-mode nil)     ; Tab inserts spaces only
;(setq default-case-fold-search t)       ; searches are case insensitive
(setq kept-old-versions 0)              ; only keep 1 backup
(setq kept-new-versions 1)
(setq trim-versions-without-asking t)   ; delete excess versions silently
(setq scroll-step 1)                    ; smooth scroll (no jumping 1/2 page)
(scroll-bar-mode -1)                    ; no scroll bar
(setq column-number-mode 1)             ; display line AND column number
;(show-paren-mode nil)                   ; disable auto parenthesis-matching
;(global-visual-line-mode)               ; enable line continuation (word-wrap)

;; make text highlighting persistent
(transient-mark-mode t)

;; Add the following "_.-/~," chars to the definition of a word, so
;; a double-click will select a full pathname.
(modify-syntax-entry ?_ "w" (standard-syntax-table))
(modify-syntax-entry ?. "w" (standard-syntax-table))
(modify-syntax-entry ?- "w" (standard-syntax-table))
(modify-syntax-entry ?/ "w" (standard-syntax-table))
(modify-syntax-entry ?~ "w" (standard-syntax-table))
;;(modify-syntax-entry ?, "w" (standard-syntax-table))

;; Verilog customization
;; (autoload 'verilog-mode "veri2" "Verilog mode" t )
;; (add-hook 'auto-mode-alist '("\\.v$" . verilog-mode))

;(setq verilog-mode-hook '(lambda ()
;                          ;; User specifications
;                          (setq verilog-tab-always-indent t
;                               verilog-auto-newline nil
;                               verilog-auto-endcomments t
;                               verilog-indent-level 3
;                               verilog-continued-expr 1
;                               verilog-label-offset -2
;                               verilog-case-offset 2
;                           )))

;; specman mode for E files
;(autoload 'specman-mode "specman-mode" "Specman code editing mode" t)
;(setq auto-mode-alist (cons '("\\.e$" . specman-mode) auto-mode-alist))


;; Cool diff routine - ediff
;;(load "ediff")

(defun mpc-use-tab-indent ()
  (interactive)
  ;; indent 8 spaces
  (setq c-basic-offset 8)
  ;; use tabs
  (setq indent-tabs-mode t)
)

(defun mpc-use-space-indent ()
  (interactive)
  ;; indent 4 spaces
  (setq c-basic-offset 4)
  ;; use spaces
  (setq indent-tabs-mode nil)
)

(global-set-key   "\es" 'mpc-use-space-indent)
(global-unset-key "\et")
(global-set-key   "\et" 'mpc-use-tab-indent)


;; make sure that .h files use C mode
;(setq auto-mode-alist (cons '("\\.h$"  . c-mode) auto-mode-alist))
;(setq auto-mode-alist (cons '("\\.C$"  . c-mode) auto-mode-alist))
;(setq auto-mode-alist (cons '("\\.l$"  . 'c-mode) auto-mode-alist))
;(setq auto-mode-alist (cons '("\\.y$"  . 'c-mode) auto-mode-alist))
;(setq auto-mode-alist (cons '("\\.cc$" . 'c-mode) auto-mode-alist))

;; configure x stuff

(if (and (eq window-system 'x) (fboundp 'x-set-baud))
    (progn
      (x-set-baud 1000000)
      (x-set-bell 1)
      (load-library "x-mouse")
      (load-library "term/x-win"))
)


;; VHDL stuff

;(autoload 'vhdl-mode "vhdl" "vhdl-mode with hooked abbrevs" t)
;(setq auto-mode-alist (cons (cons "\\.vhdl$" 'vhdl-mode) auto-mode-alist))
;(setq auto-mode-alist (cons (cons "\\.vhd$" 'vhdl-mode) auto-mode-alist))

;; Viewscript stuff

;(setq auto-mode-alist
    ;; Vscript & C preprocessed files
;    (cons (cons "\\.\\(vs\\|i\\)$" 'c-mode)
;         auto-mode-alist))


;;----------------------------------------------------------
;; case-flip-character
;;
(defun case-flip-character (num)
  "Change the case of the character under the cursor.
Accepts a prefix argument of the number of characters to invert."
  (interactive "p")
  (while (> num 0)
    (funcall (if (<= ?a (following-char))
                 'upcase-region 'downcase-region)
             (point) (1+ (point)))
    (forward-char 1)
    (setq num (1- num))))


(defun flip (start end)
  (interactive "r")
  (goto-char start)
  (case-flip-character (- end start)))


;;----------------------------------------------------------
;; find-construct
;;
(defun find-construct (tagname)
  "Find the definition for this ELL grammar construct."
  (interactive (if current-prefix-arg
                   '(nil t)
                 (find-tag-tag "Find construct: ")))
  (push-mark)
  (goto-char 1)
  (if (re-search-forward (concat "^" tagname " :") nil t 1)
     (progn                    ;; found it
       (goto-char (point))
       t)
    ;; else
     (progn                    ;; failure
       (message "No match to %s" tagname)
       (goto-char (mark))
       nil))
)

;;----------------------------------------------------------
;; python-debug
;;
(defun python-debug ()
  (interactive)
  (push-mark)
  (insert "import pdb ; pdb.set_trace()")
  (goto-char (mark))
)

;;----------------------------------------------------------
;; mpc-find-empty-line
;;
(defun mpc-find-empty-line ()
"This routine is used by the insert-makedoc-func-header routine
to find a blank line preceding the function declaration."
  (interactive)
  (setq done nil)

  (while (eq done nil)
    ;; move up one line in the file
    (forward-line -1)
    (beginning-of-line)

    ;; scan line until something beside space or tab is found
    (while (looking-at "[ \t]") (forward-char 1))

    ;; if we reached end-of-line then we've found an empty line
    (if (or (looking-at "\n") (bobp)) (setq done t))
  )
) ;; mpc-find-empty-line


;;----------------------------------------------------------
;; mpc-find-match-of
;;
(defun mpc-find-match-of (&optional match-char noerror)
"Jumps to the matching parenthesis, square-brace, or curly-brace.
Calling routines may supply a character to match and a noerror flag.
If used interactively, or 'match-char' is nil, the current character
is matched.  If 'noerror' is nil, an error message is issued if a
mate for the specified or current character cannot be found."
  (interactive)
  (let ((start (point))          ;; current position (returns here if failure)
        (this-char nil)          ;; char to match
        (that-char nil)          ;; mate of this-char
        (nesting 1)              ;; track nested levels
        (forward nil)            ;; search direction
        (in-squote nil)          ;; single quote flag
        (in-dquote nil)          ;; double quote flag
        (in-comment nil))        ;; c comment flag

    ;; if match-char is nil, use char under cursor
    (setq this-char (if (eq match-char nil) (following-char) match-char))

    ;; initialize target char and search direction
    (if (eq this-char ?( )      ;; if arg is '(' then find ')'
        (progn
          (setq that-char ?) )
          (setq forward t)))
    (if (eq this-char ?) )      ;; if arg is ')' then find '('
        (progn
          (setq that-char ?( )
          (setq forward nil)))
    (if (eq this-char ?{ )      ;; if arg is '{' then find '}'
        (progn
          (setq that-char ?} )
          (setq forward t)))
    (if (eq this-char ?} )      ;; if arg is '}' then find '{'
        (progn
          (setq that-char ?{ )
          (setq forward nil)))
    (if (eq this-char ?[ )      ;; if arg is '[' then find ']'
        (progn
          (setq that-char ?] )
          (setq forward t)))
    (if (eq this-char ?] )      ;; if arg is ']' then find '['
        (progn
          (setq that-char ?[ )
          (setq forward nil)))

    (if that-char
        (message "Seeking %c ..." that-char))

    ;; look for mate.  set nesting to -1 if error
    (if that-char
        (while (>= nesting 1)
          (if forward (forward-char 1) (backward-char 1))

          ;; if not already within singe or double quotes, test for /*, */
          (if (and (eq in-squote nil) (eq in-dquote nil))
              (progn
                (if (looking-at "/\\*") (setq in-comment (if forward t nil)))
                (if (looking-at "\\*/") (setq in-comment (if forward nil t)))))

          ;; if not already within single quote or comment, test for "
          (if (not (or in-squote in-comment))
              (if (eq (following-char) ?\")
                    (setq in-dquote (not in-dquote))))

          ;; if not already within double quote or comment, test for '
          (if (not (or in-dquote in-comment))
              (if (eq (following-char) ?')
                    (setq in-squote (not in-squote))))

          ;; if not in comment or quote, update brace nesting counter
          (if (not (or in-comment (or in-squote in-dquote)))
              (progn
                (if (eq (following-char) this-char)
                    (setq nesting (1+ nesting)))
                (if (eq (following-char) that-char)
                    (setq nesting (1- nesting)))))

          ;; if at top or bottom of file, exit loop
          (if (or (= (point) (point-min)) (= (point) (point-max)))
              (setq nesting -1))))

    ;; return search status, possibly issuing error message
    (if (= nesting 0)
        (progn                    ;; success
          (message "Done")
          t)
    ;; else
        (progn                    ;; failure
          (goto-char start)
          (if (and that-char (not noerror))
              (message "No match to %c" this-char))
          nil))
  )
) ;; mpc-find-match-of

(setq func-header-prefix "")

;;----------------------------------------------------------
;; set-func-header-prefix
;;
(defun set-func-header-prefix (value)
" Set the value of the prefix added to a Function or Docpage
 header name.  The default value is an empty string."

  (interactive "sEnter prefix value: ")
  (setq func-header-prefix value)
)

(defun indent (spaces text)
" Add the specified number of spaces and then the text."
  (interactive)
  (while (>= spaces 1)
    (insert " ")
    (setq spaces (1- spaces)))
  (insert text)
)

;;----------------------------------------------------------
;; insert-makedoc-func-header
;;
(defun insert-makedoc-func-header ()
" Adds a 'makedoc' compatible header to the current function.
 The function name is inserted in the header and after the last
 brace of the function body.  The cursor must be positioned on
 the function name when this routine is called.

 An blank line must precede the function declaration.  This allows
 this macro to support both of the following styles of function
 declaration:

        static char *remove_trailing_newline(s) ...
 and
        static char *
        remove_trailing_newline(s) ...

 The length of the dashed comment line inserted over the function name
 marks the maximum documentation line length.  Documentation should not
 extend past the last column of the  comment line to avoid wrapping when
 viewing with the UNIX man command."

  (interactive)
  (let ((start (point))  ;; current point in file
        (error  nil))    ;; cursor must be on the name of a valid function

    ;; go to first char of function name and load name into kill buffer
    (re-search-backward "[ \t\n*(]")
    (forward-char 1)
    (setq begin-of-name (point))
    (setq last-command 'nil)   ;; disable append in copy-region-as-kill
    (copy-region-as-kill (point)
                         (progn (re-search-forward "[ \t\n(,]")
                                (backward-char 1)
                                (point)))

    ;; figure out how far to indent the header
    (goto-char begin-of-name)
    (beginning-of-line)
    (setq bol (point))
    (re-search-forward "[^ \t\n]")
    (if (> bol 1) (backward-char 1))
    (setq count (- (point) bol))
    (goto-char begin-of-name)

    ;; go to curly brace at the end of the function.
    ;; (using mcp-find-match-of() because forward-sexp() won't
    ;; return to this routine if the search for the matching } fails)
    (setq error (or (not (search-forward "{" (+ (point) 1000) t))
                    (not (mpc-find-match-of (preceding-char) nil))))

    (if error
        (progn
          (message "Couldn't match function braces")
          (goto-char start)
          nil)
    ;; else
        (progn
          ;; add name after curly brace at function end
          (forward-char 1)
          (insert " /* ")
          (insert func-header-prefix) (yank)
          (insert " */")

          ;; add the function header now
          (goto-char start)
          (beginning-of-line)
          (mpc-find-empty-line)
          (insert "\n")
          (indent count "/**\n")
          (indent count " * ")
          (setq start (point))
          (insert "\n")
          (indent count " * \n")
          (indent count " * \n")
          (indent count " * @param \n")
          (indent count " * @param \n")
          (indent count " * \n")
          (indent count " * @return \n")
          (indent count " * @attention \n")
          (indent count " * \n")
          (indent count " * @code \n")
          (indent count " * Example goes here\n")
          (indent count " * @endcode \n")
          (indent count " * \n")
          (indent count " * @see \n")
          (indent count " */")
          (goto-char start)
          t)))
) ;; insert-makedoc-func-header


;;----------------------------------------------------------
;; insert-proc-header
;;
(defun insert-proc-header ()
" Adds a comment header to the current function.  The function
 name is inserted in the header and after the last brace of the
 function body.  The cursor must be positioned on the function
 name when this routine is called."

  (interactive)
  (let ((start (point))  ;; current point in file
        (error  nil))    ;; cursor must be on the name of a valid function

    ;; go to first char of function name and load name into kill buffer
    (re-search-backward "[ \t\n*]")
    (forward-char 1)
    (setq last-command 'nil)   ;; disable append in copy-region-as-kill
    (copy-region-as-kill (point)
                         (progn (re-search-forward "[ \t\n(]")
                                (backward-char 1)
                                (point)))

    ;; go to curly brace at the end of the function.
    ;; (using mcp-find-match-of() because forward-sexp() won't
    ;; return to this routine if the search for the matching } fails)
    (search-forward "{" (+ (point) 1000) t)
    (forward-char 1)
    (setq error (or (not (search-forward "{" (+ (point) 1000) t))
                    (not (mpc-find-match-of (preceding-char) nil))))

    (if error
        (progn
          (message "Couldn't match function braces")
          (goto-char start)
          nil)
    ;; else
        (progn
          ;; add name after curly brace at function end
          (forward-char 1)
          (insert " ;# ")
          (yank)
          ;; add function header
          (goto-char start)
          (beginning-of-line)
          (mpc-find-empty-line)
          (insert "\n;#--------------------------------------------------------------")
          ;; (insert "\n;#") (yank)
          (insert "\n;# ")
          (goto-char start)   ;; postion cursor under func name
          t)))
) ;; insert-proc-header


;;----------------------------------------------------------
;; insert-func-header
;;
(defun insert-func-header ()
" Adds a comment header to the current function.  The function
 name is inserted in the header and after the last brace of the
 function body.  The cursor must be positioned on the function
 name when this routine is called."

  (interactive)
  (let ((start (point))  ;; current point in file
        (error  nil)     ;; cursor must be on the name of a valid function
        (cbeg   " /* ")
        (cmid   " * ")
        (cend   " */"))

    (setq fext (file-name-extension (buffer-file-name)))
    (setq cpp (or (equal fext "cc") (equal fext "C")))

    ;; go to first char of function name and load name into kill buffer
    (re-search-backward "[ \t\n*]")
    (forward-char 1)
    (setq last-command 'nil)   ;; disable append in copy-region-as-kill
    (copy-region-as-kill (point)
                         (progn (re-search-forward "[ \t\n(]")
                                (backward-char 1)
                                (point)))

    ;; go to curly brace at the end of the function.
    ;; (using mcp-find-match-of() because forward-sexp() won't
    ;; return to this routine if the search for the matching } fails)
    (setq error (or (not (search-forward "{" (+ (point) 1000) t))
                    (not (mpc-find-match-of (preceding-char) nil))))

    (if error
        (progn
          (message "Couldn't match function braces")
          (goto-char start)
          nil)
    ;; else
        (progn
          ;; add name after curly brace at function end
          (forward-char 1)
          (if cpp
              (progn
                (insert " // ")
                (yank)
                t)
            ;; else
              (progn
                (insert " /* ")
                (yank)
                (insert " */")
                t))
          ;; add function header
          (goto-char start)
          (beginning-of-line)
          (mpc-find-empty-line)
          (if cpp
              (progn
                (insert "\n// --------------------------------------------------------------")
                (insert "\n// ") (yank)
                (insert "\n//   ")
                (setq start (point))
                (insert "\n//   ")
                (insert "\n//   ")
                t)
            ;; else
              (progn
                (insert "\n/* --------------------------------------------------------------")
                (insert "\n * ") (yank)
                (insert "\n *   ")
                (setq start (point))
                (insert "\n *   ")
                (insert "\n */")
                t)
              ) ;; if cpp
          (goto-char start)   ;; postion cursor under func name
          t)))
) ;; insert-func-header


;;----------------------------------------------------------
;; insert-file-header
;;
(defun insert-file-header ()
  (interactive)
  (insert "/*\n")
  (insert " *  FileName: ")
  (insert (file-name-nondirectory (buffer-file-name)))
  (insert "\n")
  (insert " *  \n")
  (insert " *  Facility: \n")
  (insert " *  \n")
  (insert " *  Functional Description:\n")
  (insert " *      \n")
  (insert " *      \n")
  (insert " *  Author:\n")
  (insert " *      Matthew Chapman, ")
  (call-process "date" nil t nil "+%h")
  (delete-char -1)
  (call-process "date" nil t nil "+%Y")
  (delete-char -1)
  (insert "\n")
  (insert " *      \n")
  (insert " *  Modified by:\n")
  (insert " *  Who         When            What\n")
  (insert " *  M.Chapman   ")
  (call-process "date" nil t nil "+%d-%h-%y")
  (delete-char -1)
  (insert "       Original Coding.\n")
  (insert " *  \n")
  (insert " *  Copyright (c) ")
  (call-process "date" nil t nil "+%Y")
  (delete-char -1)
  (insert " by Synopsys, Inc.\n")
  (insert " *  \n")
  (insert " *  $Header: /remote/vtghome12/mchapman/.emacs.d/RCS/init.el,v 1.6 2014/04/18 16:59:33 mchapman Exp $\n")
  (insert " */\n")
  (insert "\n")
  (forward-line -17)
  (end-of-line)
) ;; insert-file-header


(setq tag-stack 'nil)

;;----------------------------------------------------------
;; mpc-find-tag
;;
(defun mpc-find-tag ()
" Pushes the current location on a stack before calling the
 find-tag routine.  Use \\[mpc-pop-tag-stack] to pop back to
 this location."
  (interactive)

  ;; push current buffer and position on stack
  (setq tag-stack (cons (cons (current-buffer) (point)) tag-stack))

  (call-interactively 'find-tag)

;;  (message "%s" tag-stack)  ;; debugging

) ;; mpc-find-tag

;;----------------------------------------------------------
;; mpc-pop-tag-stack
;;
(defun mpc-pop-tag-stack ()
" Pops the tag-stack and jumps to the top location.
 See \\[mpc-find-tag]."
  (interactive)

  (if (null tag-stack)
    (message "Tag stack is empty")

  ;; else
    (progn
      ;; pop stack
      (setq location (car tag-stack))
      (setq tag-stack (cdr tag-stack))

      ;; goto location
      (switch-to-buffer (car location))
      (goto-char (cdr location))
    )
  )
) ;; mpc-pop-tag-stack

;;----------------------------------------------------------
;; Key Bindings
;;    "\C-]" and "\^]" both mean control-].
;;
(global-set-key "\M-&" 'replace-string)
(global-set-key "\M-*" 'query-replace-regexp)
(global-set-key "\M-^" 'replace-regexp)
(global-set-key "\M-z" 'zap-to-char)
(global-set-key "\C-x\C-m" 'shell)
(global-set-key "\C-xn" 'next-error)
(global-set-key "\C-xg" 'goto-line)
(global-set-key "\C-xl" 'what-line)
(global-set-key "\C-o" 'case-flip-character)
(global-set-key "\C-u" 'scroll-down)    ; actually moves up 1/2 page
(global-unset-key "\M-o")  ; using this for fvwm CirculateUp
(global-unset-key "\M-p")  ; using this for fvwm CirculateDown
(global-unset-key "\e[")        ; Esc [ is a prefix key for some keyboards
(global-set-key "\C-c\C-f" '(lambda () (interactive) (message buffer-file-name)))

(global-set-key "\ed" 'python-debug)
(global-set-key "\ee" 'find-construct)
(global-set-key "\ef" 'mpc-find-tag)
(global-set-key "\en" 'mpc-pop-tag-stack)
(global-set-key "\eh" 'insert-func-header)
(global-set-key "\ep" 'insert-proc-header)
;(global-set-key "\ei" 'indent-region)
(global-set-key "\ej" 'insert-makedoc-func-header)
(global-set-key "\em" 'mpc-find-match-of)

(global-set-key "\C-x\C-n" 'end-of-buffer)
(global-set-key "\C-x\C-p" 'beginning-of-buffer)


;; hit F1 key for manpage lookup
(global-set-key [(f1)] (lambda () (interactive) (manual-entry (current-word))))


;;----------------------------------------------------------
;; Make a file name out of a mail header Date string, eg:
;; "Fri, 21 Apr 95 17:46:48 est" -> " Fri-21-Apr-95-17-46-48-est"
;;
(defun make-filename (str)
  (interactive)
  (setq temp-buffer "date-string")
  (generate-new-buffer temp-buffer)
  (set-buffer temp-buffer)
  (insert str)
  (goto-char (point-min))
  (while (re-search-forward "[ ,:][ ,:]*" nil t nil)
    (replace-match "-"))
  (setq fname (buffer-substring (point-min) (point-max)))
  (kill-buffer temp-buffer)
  (concat fname "")
)

;;----------------------------------------------------------
;; Save vcs email to the log directory using timestamp as
;; filename.
;;
(defun save-vcs-logs ()
  (interactive)
  (setq log-file (concat (substitute-in-file-name "$HOME/vcs_logs/")
                         (make-filename (mail-fetch-field "date"))))
  (append-to-file (point-min) (point-max) log-file)
  )

;;----------------------------------------------------------
;; X Stuff
;;
;;(if (eq window-system 'x)
;;    (progn
;;      (load-library "x-mouse")
;;      (x-set-mouse-color "black")
;;      (x-set-cursor-color "blue")))

;;----------------------------------------------------------
;; Key Bindings, Platform Specific
;;
(setq arch (getenv "ARCH"))
(if (equal arch "pmax")
   ( global-set-key "\e[29~" 'do-da-damn-buffers))
;;(if (or (equal arch "sun3") (equal arch "sun4"))
;;    (load "sunkeys.el"))

;; (load "lhilit")

;;----------------------------------------------------------
;; uudecode mail
;;
(defun uudecode ()
  (interactive)
  (goto-char (point-min))
  (search-forward "--------------------------------- Cut Here ---------------------------------\n")
  (let ((start-cut (point))
        (save-buffer-read-only buffer-read-only)
        (buffer-read-only nil))
    (forward-word 2)                    ;past "begin 644"
    (let ((start-kill (point)))         ;replace filename with /tmp/uudecode.in
      (end-of-line 1)
      (delete-region start-kill (point)) ;kill the old "File item"
      (insert "/tmp/uudecode.out"))     ;replace it with our filename
    (write-region start-cut (point-max) "/tmp/uudecode.in")
    (call-process "/bin/uudecode" nil t t "/tmp/uudecode.in")
    (delete-region start-cut (point-max))
    (insert-file "/tmp/uudecode.out")
    (goto-char start-cut)
    (replace-string "\r" "" nil)
    (goto-char start-cut)
    (setq buffer-read-only save-buffer-read-only))
  (call-process "/bin/rm" nil t t "/tmp/uudecode.in" "/tmp/uudecode.out"))

(global-set-key "\C-c\C-u" 'uudecode)

;;----------------------------------------------------------
;; decode-enriched-text
;;
;; Decode text/enriched format (ie, <bold>, <bigger>, <center>
;; type formatting commands.)
;;
(defun decode-enriched-text ()
  (interactive)
  (setq buffer-read-only nil)
  (goto-char (point-min))
  (re-search-forward "\n\n" (point-max) t)  ;; skip over mail header
  (format-decode-region (point) (point-max) 'text/enriched)
  (setq buffer-read-only t)
)

;;----------------------------------------------------------
;; append a copy of the outgoing mail message to a log file.
;;
(defun record-outgoing-mail ()
  (interactive)
  (setq log-file (substitute-in-file-name "$HOME/outgoing-mail"))
  ;;
;  (if (file-exists-p log-file)
;    (set-file-modes log-file 438)) ;; make the log file writable: 666
  ;;
  ;; Add a header which has the date the message is being sent.
  ;;
  (setq temp-buffer "date-string")
  (generate-new-buffer temp-buffer)
  (set-buffer temp-buffer)
  (insert "\n\n============================================================\n")
  (insert "Date: ")
  (call-process "date" nil t t)
  (append-to-file (point-min) (point-max) log-file)
  (kill-buffer temp-buffer)
  ;;
  ;; Append the contents of the *mail* buffer to the log file.
  ;;
  (set-buffer "*mail*")
  (append-to-file (point-min) (point-max) log-file)
  ;;
  (mail-send-and-exit nil)
  ;;
;  (set-file-modes log-file 256) ;; make the log file read-only: 400
)

;;(global-set-key "\C-c\C-r" 'record-outgoing-mail)

;(add-hook 'mail-mode-hook
;          '(lambda ()
;             (define-key mail-mode-map "\C-c\C-r" 'record-outgoing-mail)
;             ))

;;----------------------------------------------------------
;; Add "=== M.Chapman 24-Dec-1999 ===" line to TR files.
;;
(defun time-stamp ()
  (interactive)
  (insert "=== M.Chapman ")
  (call-process "date" nil t t "+%d-%b-%Y")
  (delete-char -1)
  (insert " ===\n")
)
(global-set-key "\C-c\C-t" 'time-stamp)

(put 'upcase-region 'disabled nil)

;; Options Menu Settings
;; =====================
(cond
 ((and (string-match "XEmacs" emacs-version)
       (boundp 'emacs-major-version)
       (or (and
            (= emacs-major-version 19)
            (>= emacs-minor-version 14))
           (= emacs-major-version 20))
       (fboundp 'load-options-file))
  (load-options-file "/remote/vtgeng/mchapman/.xemacs-options")))
;; ============================
;; End of Options Menu Settings
