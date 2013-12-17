;
; From https://github.com/stuartsierra/dotfiles
; 


(setq user-init-file "/tmp/.emacs")

;; Marmalade: http://marmalade-repo.org/
(require 'package)


(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives  '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)
(package-refresh-contents)
(package-list-packages)

(package-install 'pkg-info)
(package-install 'cider)
(package-install 'clojure-cheatsheet)
(package-install 'rainbow-delimiters)
(package-install 'move-text)
(package-install 'web-mode)
(package-install 'cider-tracing)
(package-install 'yasnippet)
(package-install 'malabar-mode)


