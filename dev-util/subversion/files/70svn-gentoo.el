;;; svn site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(and (< emacs-major-version 22)
     (add-to-list 'load-path "@SITELISP@/compat"))
(add-to-list 'vc-handled-backends 'SVN)

(defalias 'svn-examine 'svn-status)
(autoload 'svn-status "psvn"
  "Examine the status of Subversion working copy in directory DIR." t)
