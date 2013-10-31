;
; From https://github.com/stuartsierra/dotfiles
; 


(setq user-init-file "/tmp/.emacs")

;; Marmalade: http://marmalade-repo.org/
(require 'package)
(add-to-list 'package-archives
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))
(package-initialize)

(package-refresh-contents)

(package-install 'pkg-info)
(package-install 'cider)
(package-install 'rainbow-delimiters)
(package-install 'move-text)
