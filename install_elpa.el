;
; From https://github.com/stuartsierra/dotfiles
; 


(setq user-init-file "/tmp/.emacs")

;; Marmalade: http://marmalade-repo.org/
(require 'package)

;;(setq url-proxy-services 
;;      (quote (("http" . "proxy.ihc.com:8080") 
;;	      ("https" . "proxy.ihc.com:8080"))))

(add-to-list 'package-archives
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))

(package-initialize)
(package-refresh-contents)
(package-list-packages)

(package-install 'pkg-info)
(package-install 'cider)
(package-install 'rainbow-delimiters)
(package-install 'move-text)
