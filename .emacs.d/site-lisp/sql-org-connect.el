(require 'sql)
(require 'org-table)


(defvar sql-org-connect-columns '(sql-org-connect-service sql-org-connect-user sql-org-connect-pwd))


(defun sql-org-connect-sqli-buffer-p (buffer)
  (with-current-buffer buffer
    (equal 'sql-interactive-mode major-mode)))

(defun sql-org-connect-sql-buffer-p (buffer)
  (with-current-buffer buffer
    (equal 'sql-mode major-mode)))

(defun sql-org-connect-set-sqli* (buffer sqli-buffer)
  (message "Setting %s to use %s" buffer sqli-buffer)
  (with-current-buffer buffer
    (setq sql-buffer sqli-buffer)
    (run-hooks 'sql-set-sqli-hook)))

(defun sql-org-connect-set-sqli (all sqli-buffer)
  "Set the Interactive SQL session for the current buffer but looking for the list
of active SQL connection buffers and letting the user pick one.  Use a prefix argument to find all sql-mode buffers and set them."
  (interactive (list
		current-prefix-arg
		(completing-read "SQL Connection: "  
				 (mapcar (lambda (b) (list (buffer-name b) b)) 
					 (cl-remove-if-not 'sql-org-connect-sqli-buffer-p 
							   (buffer-list)))
				 nil t)))

  (when (> (length sqli-buffer) 0)
    (if all
	(mapcar (lambda (b) (sql-org-connect-set-sqli* b sqli-buffer))
		(cl-remove-if-not 'sql-org-connect-sql-buffer-p 
				  (buffer-list)))
      (sql-org-connect-set-sqli* (current-buffer) sqli-buffer))))



(defun sql-org-connect ()
  "Build a connection string and make a connection. The point must be in an org-mode table.
Columns of the table must correspond to the `sql-org-connect-columns' variable."
  (interactive)
  (org-table-force-dataline)
  (let*
      ((cur-row (nth (org-table-current-dline) (org-table-to-lisp)))
       (is-user-selected (= (org-table-current-column) (+ 1 (cl-position 'sql-org-connect-user sql-org-connect-columns))))
       (passwd (nth (cl-position 'sql-org-connect-pwd sql-org-connect-columns) cur-row))
       (database (nth (cl-position 'sql-org-connect-service sql-org-connect-columns) cur-row))
       (user    (if is-user-selected	(thing-at-point 'symbol)   
		  (nth (cl-position 'sql-org-connect-user sql-org-connect-columns) cur-row))))
    
    (save-excursion
      (with-temp-buffer
	(setq sql-user user sql-password passwd sql-database database)
	(sql-oracle (concat user "@" database))))))
    
(define-minor-mode sql-org-connect-mode
  "Add an inteaction with SQLi mode for sql-mode and Org mode.  The idea is to keep a an encrypted table in org mode.

Example of a table:
| Service (SID) | user           | pwd       |
|---------------+----------------+-----------|
|               |                |           |
| SID01         | admin          | soouper   |
| SID01         | user           | seakreet  |

The user then puts the point in one line of the table and calls (sql-org-connect)
to make the connection.  

A buffer can be set to use the connection by using sql-org-connect-set-sqli C-c !.
Passing a prefix arg will make the set all sql-mode buffers to use the same SQLi connection.

"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-c !") 'sql-org-connect-set-sqli)
            map))

;;;###autoload
(add-hook 'sql-mode-hook 'sql-org-connect-mode)

(provide 'sql-org-connect)
