
;;; wikipedia-mode site-lisp configuration

(add-to-list 'load-path "@SITELISP@")

(autoload 'wikipedia-mode "wikipedia-mode"
  "Major mode for editing documents in Wikipedia markup." t)

(add-to-list 'auto-mode-alist
  '("\\.wiki\\'" . wikipedia-mode))
(add-to-list 'auto-mode-alist
  '("en\\.wikipedia\\.org" . wikipedia-mode))
