
(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/elpa/cygwin-mount-2001")

;;
(put 'narrow-to-region 'disabled nil)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(clojure-swank-command "echo \"C:/opt/lein/lein.bat jack-in %s\" | \"$SHELL\" -l")
 '(package-archives (quote (("marmalade" . "http://marmalade-repo.org/packages/") ("gnu" . "http://elpa.gnu.org/packages/"))))
 '(socks-server (quote ("Default server" "127.0.0.1" 4567 5)))
 '(url-gateway-method (quote socks))
 '(exec-path (quote ("c:/Users/lpmsmith/bin" "c:/cygwin/bin/" "c:/Users/lpmsmith/bin" "c:/cygwin/bin/" "c:/Users/lpmsmith/bin" "c:/cygwin/bin/" "c:/Program Files (x86)/Common Files/Avaya Modular Messaging" "C:/WINDOWS/system32" "C:/WINDOWS" "C:/WINDOWS/System32/Wbem" "C:/WINDOWS/System32/WindowsPowerShell/v1.0/" "C:/ORACLE/product/10.2.0/client_1/bin" "C:/Program Files (x86)/Avaya Modular Messaging/Common" "C:/Program Files/SlikSvn/bin/" "C:/Program Files/Dell/DW WLAN Card" "c:/Program Files (x86)/emacs-23.2/bin" "c:/Program Files (x86)/PuTTY" "C:/Program Files (x86)/lein" "C:/Program Files/Java/jdk1.6.0_32/bin")))
 '(tramp-default-method "ssh"))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "DarkSlateGrey" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 81 :width normal :foundry "outline" :family "Courier New"))))
 '(font-lock-comment-face ((((class color) (min-colors 88) (background dark)) (:foreground "yellow")))))
(set-cursor-color "green")




     
(setq shell-mode-hook 'my-shell-setup)
(require 'tramp)
(setq tramp-default-method "plink")

(defun tramp-set-auto-save-not ()
  (when (and ;; ange-ftp has its own auto-save mechanism
	     (eq (tramp-find-foreign-file-name-handler (buffer-file-name))
		 'tramp-sh-file-name-handler)
             auto-save-default)
    (auto-save-mode 0)))

(remove-hook 'find-file-hooks 'tramp-set-auto-save)
(add-hook 'find-file-hooks 'tramp-set-auto-save-not t)
(add-hook 'tramp-unload-hook
	  (lambda ()
	    (remove-hook 'find-file-hooks 'tramp-set-auto-save-not)))



(nconc (cadr (assq 'tramp-login-args (assoc "ssh" tramp-methods)))
       '(("bash" "-i")))
(setcdr (assq 'tramp-remote-sh (assoc "ssh" tramp-methods))
	'("bash -i"))


(setq archive-zip-use-pkzip nil)

(require 'dired-aux)

(defun dired-call-process (program discard &rest arguments)
  ;; 09Feb02, sailor overwrite this function because Gnu Emacs cannot
  ;; recognize gunzip is a symbolic link to gzip. Thus, if the program
  ;; is "gunzip", replace it with "gzip" and add an option "-d".

  ;; "Run PROGRAM with output to current buffer unless DISCARD is t.
  ;; Remaining arguments are strings passed as command arguments to PROGRAM."
  ;; Look for a handler for default-directory in case it is a remote file name.
  (let ((handler
         (find-file-name-handler (directory-file-name default-directory)
                                 'dired-call-process)))
    (if handler (apply handler 'dired-call-process
                       program discard arguments)
      (progn
        (if (string-equal program "gunzip")
            (progn
              (setq program "gzip")
              (add-to-list 'arguments "-d")
              )
            )
        (apply 'call-process program nil (not discard) nil arguments)
        )
      )))


(add-hook 'comint-output-filter-functions
    'shell-strip-ctrl-m nil t)
(add-hook 'comint-output-filter-functions2
    'comint-watch-for-password-prompt nil t)
;;(setq explicit-shell-file-name "bash.exe")
(setq explicit-shell-file-name "bash")
;; For subprocesses invoked via the shell
;; (e.g., "shell -c command")
(setq shell-file-name explicit-shell-file-name)


;(require 'clojure-mode)

;(add-hook 'slime-repl-mode-hook
;          (defun clojure-mode-slime-font-lock ()
;            (require 'clojure-mode)
;            (let (font-lock-mode)
;              (clojure-mode-font-lock-setup))))
			       

(setenv "PATH" (concat "/usr/local/bin86/lein2;/usr/local/bin86/apache-maven-2.2.1/bin;c:/cygwin/bin;c:/Users/lpmsmith/bin;" (getenv "PATH")))
(setq exec-path (cons "c:/Users/lpmsmith/bin" (cons "c:/cygwin/bin/" exec-path)))
(require 'cygwin-mount)
(cygwin-mount-activate)


(defun my-shell-setup ()
       "For Cygwin bash under Emacs 20"
       (setq comint-scroll-show-maximum-output 'this)
       (make-variable-buffer-local 'comint-completion-addsuffix))
       (setq comint-completion-addsuffix t)
       ;; (setq comint-process-echoes t) ;; reported that this is no longer needed
       (setq comint-eol-on-send t)
       (setq w32-quote-process-args ?\")

;;(require 'slime)

;;;
;;; Package
;;;
(require 'package)
(package-initialize)

;;;
;;; Clojure
;;;

(require 'nrepl-inspect) 
(define-key nrepl-mode-map (kbd "C-c C-i") 'nrepl-inspect)
