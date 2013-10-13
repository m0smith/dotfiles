;;; clojure-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (clojure-mode) "clojure-mode" "../../../../../../../../home/xubuntu/.emacs.d/elpa/clojure-mode-2.1.0/clojure-mode.el"
;;;;;;  "a4eddf18007f95885dbc88f769a38ad3")
;;; Generated autoloads from ../../../../../../../../home/xubuntu/.emacs.d/elpa/clojure-mode-2.1.0/clojure-mode.el

(autoload 'clojure-mode "clojure-mode" "\
Major mode for editing Clojure code - similar to Lisp mode.
Commands:
Delete converts tabs to spaces as it moves back.
Blank lines separate paragraphs.  Semicolons start comments.
\\{clojure-mode-map}
Note that `run-lisp' may be used either to start an inferior Lisp job
or to switch back to an existing one.

Entry to this mode calls the value of `clojure-mode-hook'
if that value is non-nil.

\(fn)" t nil)

(put 'clojure-test-ns-segment-position 'safe-local-variable 'integerp)

(put 'clojure-mode-load-command 'safe-local-variable 'stringp)

(add-to-list 'auto-mode-alist '("\\.clj\\'" . clojure-mode))

(add-to-list 'interpreter-mode-alist '("jark" . clojure-mode))

(add-to-list 'interpreter-mode-alist '("cake" . clojure-mode))

;;;***

;;;### (autoloads nil nil ("../../../../../../../../home/xubuntu/.emacs.d/elpa/clojure-mode-2.1.0/clojure-mode-pkg.el"
;;;;;;  "../../../../../../../../home/xubuntu/.emacs.d/elpa/clojure-mode-2.1.0/clojure-mode.el")
;;;;;;  (21082 5777 569080))

;;;***

(provide 'clojure-mode-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; clojure-mode-autoloads.el ends here
