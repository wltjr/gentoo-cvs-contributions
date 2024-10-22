
;;; slime site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(add-to-list 'load-path "@SITELISP@/contrib")
(autoload 'slime-highlight-edits-mode "slime-highlight-edits" nil t)

(require 'slime-autoloads)
(eval-after-load 'slime
  (slime-setup '(slime-fancy slime-asdf slime-banner)))

;; this allows us not to require dev-lisp/hyperspec
;; (which is non-free) as a hard dependency
(setq common-lisp-hyperspec-root
      (if (file-exists-p "/usr/share/doc/hyperspec/HyperSpec")
	  "file:///usr/share/doc/hyperspec/HyperSpec/"
	"http://www.lispworks.com/reference/HyperSpec/"))
