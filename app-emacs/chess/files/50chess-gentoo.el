
;;; chess site-lisp configuration 

(add-to-list 'load-path "@SITELISP@")

(autoload 'chess "chess"
  "Start a game of chess, playing against ENGINE (a module name)." t)
(defalias 'chess-session 'chess)
(autoload 'chess-create-display "chess"
  "Create a display, letting the user's customization decide the style.")
(autoload 'chess-link "chess-link"
  "Play out a game between two engines, and watch the progress." t)
(autoload 'chess-pgn-read "chess-pgn"
  "Read and display a PGN game after point." t)
(autoload 'chess-pgn-mode "chess-pgn"
  "A mode for editing chess PGN files." t)
(defalias 'pgn-mode 'chess-pgn-mode)
(autoload 'chess-puzzle "chess-puzzle"
  "Pick a random puzzle from FILE, and solve it against the default engine." t)
(autoload 'chess-fischer-random-position "chess-random"
  "Generate a Fischer Random style position.")
(autoload 'chess-tutorial "chess-tutorial"
  "A simple chess training display." t)
(autoload 'chess-ics "chess-ics"
  "Connect to an Internet Chess Server." t)

(add-to-list 'auto-mode-alist '("\\.pgn\\'" . chess-pgn-mode))

(setq chess-images-directory "/usr/share/pixmaps/chess/xboard")
(setq chess-sound-directory "/usr/share/sounds/chess")

;; Change the order of the engine preference list to coincide with the order
;; of our dependencies: games-board/gnuchess, crafty, phalanx, and sjeng.
;; The user can override this using M-x customize-group RET chess RET
(setq chess-default-engine
      '(chess-gnuchess chess-crafty chess-phalanx chess-sjeng))
