
;;;
;;; search for resources on classpath
;;;

;;(nrepl-send-string-sync "(.getContextClassLoader (Thread/currentThread))")
;;(nrepl-send-string-sync "(.getURLs (.getClassLoader (.getClass clojure-version)))")

;;;Search a ZIP file: From http://stackoverflow.com/a/5428265/850252
;; Maybe use a ZipInputStream

(defun m0clj-resource-init()
  (interactive)
  (nrepl-send-string-sync 
   "
    (defprotocol EntryHandler
       (entry-name [entry]))

    (defrecord FileEntry [base file]
       EntryHandler 
       (entry-name [e] 
          (let [b (.getPath base)
                f (.getPath file)]
            (.replace f b ""))))

    (defrecord NewZipEntry [base file]
       EntryHandler 
       (entry-name [e] (.getName file)))

    (defn m0clj-filenames-in-zip [filename]
      (let [z (java.util.zip.ZipFile. filename)] 
        (map #(NewZipEntry. filename %) (enumeration-seq (.entries z)))))

    (defn m0clj-files-in [d]
	 (map (fn [f] (FileEntry. d f))(filter #(not (.isDirectory %))(file-seq d))))

    (defn m0clj-type-of [s]
	(let [f (java.io.File. (.. s toURI))
	      p (.getPath f)]
	  (cond
           (not (.exists f)) []
	   (.isDirectory f) (m0clj-files-in f)
	   (.endsWith p (str \j \a \r)) (m0clj-filenames-in-zip f)
	   :else [s])))

    (defn m0clj-classpath-urls [] 
        (.getURLs (.getClassLoader (.getClass clojure-version))))
 
    (defn m0clj-resources [] (map m0clj-type-of (m0clj-classpath-urls)))

")

   
)

;; (java.lang.System/getProperty "sun.boot.class.path")

;;#'user/filenames-in-zip
;;user> (def z "/media/xubuntu/D8D3-1C07/.m2/repository/clojurewerkz/archimedes/1.0.0-alpha5/archimedes-1.0.0-alpha5.jar")
;;#'user/z
;;user> (filenames-in-zip z)





;; Recursively generate tags for all *.clj files, 
;; creating tags for def* and namespaces
;; http://webcache.googleusercontent.com/search?q=cache:M1FGmXfA9HEJ:blog.kovanovic.info/emacs-etags-for-clojure/+&cd=2&hl=en&ct=clnk&gl=us&client=firefox-a

(defun m0clj-etags (project-root)
  "Create tags file for clojure project."
  (interactive "DProject Root:")
  (eshell-command
   (format "find %s/src -name \'*.clj\' | xargs etags --regex=@%s -o %s/TAGS" 
	   project-root 
	   (expand-file-name "~/.emacs.d/clojure/clj.etags") 
	   project-root)))
