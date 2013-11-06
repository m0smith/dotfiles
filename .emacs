

(if (eq system-type 'cygwin)
    (load-file "~/.emacs.d/cygwin/init.el"))

(add-to-list 'load-path "~/.emacs.d/site-lisp/")

;;
;;  Customization setup
;;



(setq custom-file "~/.emacs-custom.el")
(load custom-file)

;;
;; Keys 
;;
(global-set-key [f5] (quote revert-buffer))

;;
;; Colors
;;
;;(set-background-color "dark slate grey")
;;(set-cursor-color "green")
;;(set-foreground-color "white")




;;
;; PACKAGE
;;

(require 'package)

(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives  '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

;;;
;;; Move Text
;;;

(require 'move-text)
(move-text-default-bindings)

;;
;; Clojure
;;

(require 'clojure-mode)
(require 'cider)
(load-file "~/projects/cljdb/cljdb.el")
(load "m0clj")


(load-file "/home/xubuntu/projects/cljdb/cljdb.el")
;;(require 'cljdb)

;(load-file "/home/xubuntu/projects/nrepl-inspect/nrepl-inspect.el")
;(define-key nrepl-repl-mode-map (kbd "C-c C-i") 'nrepl-inspect)
;(define-key nrepl-interaction-mode-map (kbd "C-c C-i") 'nrepl-inspect)
;; Don't you hate it when people overwrite default keybindings?
;; me too
(define-key cider-mode-map (kbd "C-M-.") 'nrepl-jump)
(define-key cider-repl-mode-map (kbd "C-M-.") 'nrepl-jump)
(define-key cider-mode-map (kbd "M-.") 'find-tag)
(define-key cider-repl-mode-map (kbd "M-.") 'find-tag)




;;
;; nrepl and ritz
;;
;;(require 'nrepl)






;; (eval-after-load "auto-complete"
;;   '(add-to-list 'ac-modes 'nrepl-mode))

;; (add-hook 'nrepl-mode-hook 'ac-nrepl-setup)
 
;; Some default eldoc facilities
;(add-hook 'nrepl-connected-hook
;(defun pnh-clojure-mode-eldoc-hook ()
;(add-hook 'clojure-mode-hook 'turn-on-eldoc-mode)
;(add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)
;(nrepl-enable-on-existing-clojure-buffers)))
 
;; Repl mode hook
;(add-hook 'nrepl-mode-hook 'subword-mode)
 
;; Auto completion for NREPL
;(require 'ac-nrepl)
;(eval-after-load "auto-complete"
;'(add-to-list 'ac-modes 'nrepl-mode))
;(add-hook 'nrepl-mode-hook 'ac-nrepl-setup)



;(require 'nrepl-ritz) ;; after (require 'nrepl)
 
;; Ritz middleware
;(define-key nrepl-interaction-mode-map (kbd "C-c C-j") 'nrepl-javadoc)
;(define-key nrepl-mode-map (kbd "C-c C-j") 'nrepl-javadoc)
;(define-key nrepl-interaction-mode-map (kbd "C-c C-a") 'nrepl-apropos)
;(define-key nrepl-mode-map (kbd "C-c C-a") 'nrepl-apropos)
