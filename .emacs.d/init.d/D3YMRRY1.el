(eval-after-load 'malabar-variables
  '(progn
     (add-to-list 'malabar-extra-source-locations 
		  (expand-file-name "/cygdrive/c/Program Files/Java/jdk1.7.0_45/src.zip"))))

(eval-after-load 'malabar-groovy
  '(progn
     (add-to-list 'malabar-groovy-extra-classpath
		  (expand-file-name "~/test/config"))))

