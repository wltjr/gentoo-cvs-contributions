
;;; site-lisp configuration for http-emacs

(add-to-list 'load-path "@SITELISP@")
(autoload 'http-get "http-get"
  "Get URL in a buffer, and return the process." t)
(autoload 'swc-emacswiki-browse "simple-wiki-completion" nil t)
(autoload 'simple-wiki-edit "simple-wiki-edit")

;;; The following are an attempt at some reasonable defaults based on
;;; the EmacsWiki page:
;;; http://emacswiki.org/cgi-bin/wiki.pl?SimpleWikiEditMode

;; (add-hook 'simple-wiki-edit-mode-hooks 'pcomplete-simple-wiki-setup)
;; (add-hook 'simple-wiki-edit-mode-hooks 'turn-off-auto-fill)
