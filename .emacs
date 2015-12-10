(setq lisp-dir (substitute-in-file-name "$HOME/.emacs.d"))
(setq load-path (cons lisp-dir load-path))

(load-file (expand-file-name "init.el" lisp-dir))
(load-file (expand-file-name "custom.el" lisp-dir))

;; Clang-format style
;(load-file (expand-file-name "clang-format.el" lisp-dir))
;(global-set-key "\ei" 'clang-format-region)

;; "stroustrup" but suppress indent of namespace and extern "C" {} blocks:
(setq c-default-style "stroustrup")
(add-hook 'c-mode-common-hook (lambda() (c-set-offset 'innamespace 0)))
(add-hook 'c-mode-common-hook (lambda() (c-set-offset 'inextern-lang 0)))

;; CCM Perl
;;
;(add-hook 'perl-mode-hook 'vg-display-whitespace)

;; CCM Python
;;
;(add-hook 'python-mode-hook 'vg-display-whitespace)

;; JSON mode --> python mode
;;
(add-to-list 'auto-mode-alist '("\\.json\\'" . python-mode))

;; XML mode
;;
(add-to-list 'auto-mode-alist '("\\.xml\\'" . nxml-mode))
;(add-hook 'nxml-mode-hook 'vg-display-whitespace)

;; 80 Column Rule
;;
(require 'fill-column-indicator)
(define-globalized-minor-mode global-fci-mode fci-mode
  (lambda ()
    (setq fci-rule-column 80)
    (fci-mode 1)))
(global-fci-mode 1)

;; Line numbering
;;
(require 'wb-line-number)
(setq wb-line-number-scroll-bar nil)
(setq wb-line-number-text-width 5)
(setq truncate-partial-width-windows nil) ; wrap long lines
(global-set-key (kbd "<f6>") 'wb-line-number-toggle)
;(wb-line-number-enable)
