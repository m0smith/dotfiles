(defun m0-compute-max-frame-height ( &optional this-frame )
  (interactive)
  (let ((fr (if this-frame this-frame (selected-frame)))
	(height (display-pixel-height))
	(padding 77))
     (/ (- height padding)
	(frame-char-height))))


(defun m0-set-frame-height   (n)
  "For some reason I cannot resize a window in some configurations, mostly cygwin X11"
  (interactive "nFrame Height:")
  (let ((rows (if (< n 1) (+ (m0-compute-max-frame-height) n) n)))  
    (message "Setting frame height to %d" rows)
    (set-frame-height (selected-frame) rows)))
