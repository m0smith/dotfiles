(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#2f4f4f" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 83 :width normal :foundry "outline" :family "Lucida Console"))))
 '(cursor ((t (:background "green"))))
 '(font-lock-comment-face ((t (:foreground "yellow"))))
 '(font-lock-doc-face ((t (:foreground "gold")))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40")
 '(malabar-groovy-compile-server-port 56563)
 '(malabar-groovy-eval-server-port 56564)
 '(malabar-groovy-extra-classpath (quote ("~/src/malabar/target/classes" "~/test/config")))
 '(malabar-util-groovy-file-filter (quote malabar-util-reverse-slash))
 '(malabar-util-path-filter (quote cygwin-convert-file-name-to-windows))
 '(malabar-util-path-separator ";")
 '(rng-schema-locating-files (quote ("schemas.xml" "/usr/share/emacs/24.3/etc/schema/schemas.xml" "/home/lpmsmith/projects/maven-pom-mode/schemas.xml")))
 '(safe-local-variable-values (quote ((eval when (and (buffer-file-name) (file-regular-p (buffer-file-name)) (string-match-p "^[^.]" (buffer-file-name))) (emacs-lisp-mode) (when (fboundp (quote flycheck-mode)) (flycheck-mode -1)) (unless (featurep (quote package-build)) (let ((load-path (cons ".." load-path))) (require (quote package-build)))) (package-build-minor-mode)))))
 '(tool-bar-mode nil)
 '(visible-cursor nil))

