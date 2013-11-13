;;; m0clj-classpath.el --- Clojure Classpath Browsing -*- lexical-binding: t -*-

;; Copyright (C) 2013 Matthew O. Smith

;; Author: Sebastian Kremer <matt@m0smith.com>
;; Maintainer: 
;; Keywords: clojure classpath
;; Package: m0clj

;; This file is NOT part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;
;; This motivated by the Eclipse Open Type (C-S-t) and Open Resource
;; (C-S-r) functionality and a desire to import it to the Emacs-Clojure-Cider.
;;
;;  Getting Started:
;;     Required ELPA packages:  pkg-info cider 
;;     External Software:
;;        * lein - https://raw.github.com/technomancy/leiningen/stable/bin/lein
;;
;;     LEIN configuration: in ~/.lein/profiles.clj
;;         {:user {:dependencies [[org.clojure/tools.nrepl "0.2.3"]
;;			          [m0clj-classpath "0.1.5"]] }}
;;
;;     EMACS Configuration
;;      (defun m0clj-cider-hook ()
;;         (require 'm0clj-classpath)
;;         (m0clj-classpath-resource-init)
;;         (define-key cider-repl-mode-map (kbd "C-S-t") 'm0clj-classpath-mode)
;;         (define-key cider-repl-mode-map (kbd "C-S-r") 'm0clj-classpath-mode-resource))
;;
;;      (eval-after-load 'clojure-mode
;;        '(progn
;;           (define-key clojure-mode-map (kbd "C-S-t") 'm0clj-classpath-mode)
;;           (define-key clojure-mode-map (kbd "C-S-r") 'm0clj-classpath-mode-resource))))

;;  (add-hook 'nrepl-connected-hook 'm0clj-cider-hook)

;;
;;
;; thanks to http://stackoverflow.com/a/11529749/850252
;;



;;; Customizable variables

(defgroup m0clj-classpath nil
  "Class Loader mode for use with cider."
  :group 'programming)

(defcustom m0clj-classpath-mode-hook nil
  "Run at the very end of `m0clj-classpath-mode'."
  :group 'm0clj-classpath
  :type 'hook)

(defcustom m0clj-classpath-location-mode-hook nil
  "Run at the very end of `m0clj-classpath-location-mode'."
  :group 'm0clj-classpath
  :type 'hook)


(defcustom m0clj-tl-mode-hook nil
  "Run at the very end of `m0clj-tl-mode'."
  :group 'm0clj-classpath
  :type 'hook)


;;; Code:


(defun m0clj-classpath-resource-init ()
  (interactive)
  (nrepl-send-string-sync "(use 'm0clj-classpath.tools)")
  (nrepl-send-string-sync "(m0clj-classpath.tools/m0clj-init)")
  )


(defun m0clj-classpath-class-find* (s search-func name-filter-func)
  (car (read-from-string
   (plist-get 
    (nrepl-send-string-sync 
     (format "(map (fn [f] 
               (list 
                 (first f) 
                 [
                  (str (count (second f)))
                  (%s ( first f ))
                 ])) 
                (m0clj-classpath.tools/%s \"%s\"))" name-filter-func search-func s))
    :value))))

(defun m0clj-classpath-resource-find (s)
  (interactive "sCamelcase: ")
  (m0clj-classpath-class-find* s "m0clj-resource-search" "identity" ))


(defun m0clj-classpath-which (class-name)
  (interactive "sClass Name: ")
  (message "%s" (plist-get 
	    (nrepl-send-string-sync (format "(m0clj-classpath.tools/which \"%s\")" class-name))
	    :value)))

(defun m0clj-classpath-class-find (s )
  (interactive "sCamelcase: ")
  (m0clj-classpath-class-find* s "m0clj-class-search" "m0clj-classpath.tools/m0clj-path-to-full-class"))

(defun m0clj-classpath-mode-resource (s)
  (interactive "sCamelcase: ")
  (m0clj-classpath-mode s 'm0clj-classpath-resource-find))



(defun print-current-line-id ()
  (interactive)
   (message (concat "current line ID is: " (tabulated-list-get-id))))

(defun m0clj-classpath-which ()
  (interactive)
  (let ((class-name (elt (tabulated-list-get-entry) 1)))
    (message (format "%s from %s" class-name (m0clj-classpath-which class-name)))))

(defun m0clj-classpath-find-file ()
  (interactive)
  (let ((type (elt (tabulated-list-get-entry) 0))
	(file-name (elt (tabulated-list-get-entry) 2)))
    (find-file file-name)))

(defun m0clj-classpath-locate ()
  (interactive)
  (let ((resource-key  (tabulated-list-get-id)))
   (m0clj-classpath-location-mode resource-key)))

(defun m0clj-classpath-package-name ()
  (interactive)
  (let ((class-name (elt (tabulated-list-get-entry) 1)))
     (string-match "\\.[^.]*\\'" class-name)
     (substring class-name 0 (match-beginning 0))))

(defun m0clj-classpath-class-name ()
  (interactive)
  (let ((class-name (elt (tabulated-list-get-entry) 1)))
     (string-match "\\.[^.]*\\'" class-name)
     (substring class-name (+ (match-beginning 0) 1))))

(defun m0clj-classpath-kill-ring-save-package ()
  (interactive)
  (let ((s (m0clj-classpath-package-name)))
    (kill-new s)
    (message "Copied %s" s)))

(defun m0clj-classpath-kill-ring-save-class ()
  (interactive)
  (let ((s (m0clj-classpath-class-name)))
    (kill-new s)
    (message "Copied %s" s)))

(defun m0clj-classpath-kill-ring-save-full-class ()
  (interactive)
  (let ((s (elt (tabulated-list-get-entry) 1)))
    (kill-new s)
    (message "Copied %s" s)))

(defun m0clj-classpath-kill-ring-save-import ()
  (interactive)
  (let ((f (format "[%s %s]" (m0clj-classpath-package-name) (m0clj-classpath-class-name))))
    (kill-new f)
    (message "Copied %s" f)))

(defun m0clj-classpath-kill-ring-save-full-import ()
  (interactive)
  (let ((f (format "(:import [%s %s])" (m0clj-classpath-package-name) (m0clj-classpath-class-name))))
    (kill-new f)
    (message "Copied %s" f)))


(defun m0clj-classpath-kill-ring-save-column (column)
  (interactive "p")
  (if (< column 0 )
      (let ((s  (tabulated-list-get-entry) ))
	(kill-new (format "%s" s))
	(message "Copied %s" s))
    (let ((s (elt (tabulated-list-get-entry) column)))
      (kill-new s)
      (message "Copied %s" s))))
  


(defun m0clj-classpath-kill-ring-save-base ()
  (interactive)
  (let ((s (elt (tabulated-list-get-entry) 1)))
    (kill-new s)
    (message "Copied %s" s)))

(defun m0clj-classpath-kill-ring-save-path ()
  (interactive)
  (let ((s (elt (tabulated-list-get-entry) 2)))
    (kill-new s)
    (message "Copied %s" s)))



(defvar m0clj-classpath-mode-map
  (let ((map (make-keymap)))
    (set-keymap-parent map tabulated-list-mode-map)
    (define-key map "=" 'print-current-line-id)
    (define-key map "l" 'm0clj-classpath-locate)
    (define-key map "w" 'm0clj-classpath-which)
    (define-key map "P" 'm0clj-classpath-kill-ring-save-package)
    (define-key map "c" 'm0clj-classpath-kill-ring-save-class)
    (define-key map "C" 'm0clj-classpath-kill-ring-save-full-class)
    (define-key map "i" 'm0clj-classpath-kill-ring-save-import)
    (define-key map "I" 'm0clj-classpath-kill-ring-save-full-import)
    map))

(defvar m0clj-classpath-location-mode-map
  (let ((map (make-keymap)))
    (set-keymap-parent map tabulated-list-mode-map)
    (define-key map "i" 'print-current-line-id)
    (define-key map "f" 'm0clj-classpath-find-file)
    (define-key map "b" 'm0clj-classpath-kill-ring-save-base)
    (define-key map "P" 'm0clj-classpath-kill-ring-save-path)
    map))


(defun m0clj-classpath-locations-of (resource-key)
  (interactive "sResource Name: ")
  (car (read-from-string
	(plist-get 
	 (nrepl-send-string-sync (format "(m0clj-classpath.tools/locations-of \"%s\")" resource-key))
	 :value))))


(define-derived-mode m0clj-classpath tabulated-list-mode 
  "m0clj-classpath" "Major mode m0clj-classpath to interact with classpath 

\\{m0clj-classpath-mode-map}

"
  (setq tabulated-list-format [("Cnt" 3 nil)
                               ("Name" 50 t)
                               ;;("Col3"  10 t)
                               ;;("Col4" 0 nil)
			       ])
  (setq tabulated-list-padding 2)
  (setq tabulated-list-sort-key (cons "Name" nil))
  (tabulated-list-init-header)
  (use-local-map m0clj-classpath-mode-map)
  (run-mode-hooks 'm0clj-classpath-mode-hook))


(define-derived-mode m0clj-classpath-location tabulated-list-mode 
  "m0clj-classpath-location" "Major mode m0clj-classpath-location to interact with classpath

\\{m0clj-classpath-location-mode-map}
"
  (setq tabulated-list-format [("TYP" 3 nil)
                               ("Base" 50 t)
                               ("Path" 50 t)
                               ;;("Col3"  10 t)
                               ;;("Col4" 0 nil)
			       ])
  (setq tabulated-list-padding 2)
  (setq tabulated-list-sort-key (cons "Base" nil))
  (tabulated-list-init-header)
  (use-local-map m0clj-classpath-location-mode-map)
  (run-mode-hooks 'm0clj-classpath-location-mode-hook))




(defun m0clj-tl-call (func-name)
  (interactive "sCLJ Class Name and args: ")
  (let (( ff (format "(letfn [(to-tl [f] (if (instance? clojure.lang.Seqable f)  (if (instance? clojure.lang.Seqable (first f)) f (map vector f)) [[f]]))]
                (let [r (to-tl (%s))]
		[
		  (mapv (fn [f g] (list g 20 \t)) (first r) (map str (repeat \"COL-\") (range)))
		  (map (fn [f] (list (str (first f)) (mapv str f))) r)
		]))" func-name)))
    ;(message "m0clj-tl-call: %s" ff)

    (car (read-from-string
	  (plist-get 
	   (nrepl-send-string-sync ff)
	   :value)))))


(defun m0clj-tl-format (s)
 (format "\"%s\"" s))

(defun m0clj-tl-call-with-current (func-name column)
  (interactive "sCLJ Class Name and args: \nP")
  (message "%s" column)
  (let (( arg (if column  
		  (m0clj-tl-format (elt (tabulated-list-get-entry) column))
		(apply 'vector (mapcar 'm0clj-tl-format (tabulated-list-get-entry))))))
    (let (( f (format "%s %s" func-name  arg)))
      ;;(message "%s" f)
      (m0clj-tl-mode f))))


(defvar m0clj-tl-mode-map
  (let ((map (make-keymap)))
    (set-keymap-parent map tabulated-list-mode-map)
    (define-key map "i" 'print-current-line-id)
    (define-key map "c" 'm0clj-tl-call-with-current)
    (define-key map "w" 'm0clj-classpath-kill-ring-save-column)

    map))


(define-derived-mode m0clj-tl tabulated-list-mode 
  "m0clj-tl" "Major mode m0clj-tl to interact with clojure results

\\{m0clj-tl-mode-map}
"
  (setq tabulated-list-padding 2)
  (use-local-map m0clj-tl-mode-map)
  (run-mode-hooks 'm0clj-classpath-location-mode-hook))


(defun m0clj-classpath-mode (&optional seach-pattern source-func)
  (interactive "sCamelCase: ")
  (pop-to-buffer "*M0CLJ Classpath*" nil)
  (m0clj-classpath)
  (let ((sf (if source-func source-func 'm0clj-classpath-class-find)))
        (setq tabulated-list-entries
         (funcall sf seach-pattern)))
  (tabulated-list-print t))

(defun m0clj-tl-mode ( clj-func )
  (interactive "sCLJ Function and args : ")
  (pop-to-buffer "*M0CLJ TL*" nil)
  (let (( table-info (m0clj-tl-call clj-func) ))
    ;(message "%s" table-info)
    (setq tabulated-list-format (elt table-info 0))
    (setq tabulated-list-sort-key (cons "COL-0" nil))
    (setq tabulated-list-entries (elt table-info 1)))
	  
  (m0clj-tl)
  (tabulated-list-init-header)
  (tabulated-list-print t))


(defun m0clj-classpath-location-mode (&optional resource-key)
  (interactive "sResource: ")
  (pop-to-buffer (format "*M0CLJ Location:%s*" resource-key) nil)
  (m0clj-classpath-location)
  (setq tabulated-list-entries (m0clj-classpath-locations-of resource-key))
  (tabulated-list-print t))

(defun m0clj-classpath-locate ()
  (interactive)
  (let ((resource-key  (tabulated-list-get-id)))
   (m0clj-classpath-location-mode resource-key)))

(provide 'm0clj-classpath)
