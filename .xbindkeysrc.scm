;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start of xbindkeys guile configuration ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This configuration is guile based.
;;   http://www.gnu.org/software/guile/guile.html
;; any functions that work in guile will work here.
;; see EXTRA FUNCTIONS:
;;
;; Version: 1.8.6
;;
;; If you edit this file, do not forget to uncomment any lines
;; that you change.
;; The semicolon(;) symbol may be used anywhere for comments.
;;
;; To specify a key, you can use 'xbindkeys --key' or
;; 'xbindkeys --multikey' and put one of the two lines in this file.
;;
;; A list of keys is in /usr/include/X11/keysym.h and in
;; /usr/include/X11/keysymdef.h
;; The XK_ is not needed.
;;
;; List of modifier:
;;   Release, Control, Shift, Mod1 (Alt), Mod2 (NumLock),
;;   Mod3 (CapsLock), Mod4, Mod5 (Scroll).
;;
;; run with command
;;    >killall xbindkeys && xbindkeys
;;
;;(xbindkey '(b:9) "xte 'keydown Control_R' 'key bracketleft' 'keyup Control_R'")
;;(xbindkey '(b:8) "xte 'keydown Control_L' 'key Tab' 'keyup Control_L'")

;; Forward and backward buttons
;; 9,8 forward, backward buttons
(xbindkey '(b:9) "~/dotfiles/MX-Master-3-bindings.sh Forward")
(xbindkey '(b:8) "~/dotfiles/MX-Master-3-bindings.sh Backward")

;; 10 is middle button
(xbindkey '(b:10) "xte 'keydown Alt_L' 'key w' 'keyup Alt_L'")

;; Thumb wheel
;;# thumb wheel up => next tab/volume up
(xbindkey '(b:7) "~/dotfiles/MX-Master-3-bindings.sh Scroll_R")
(xbindkey '(alt b:7) "~/dotfiles/MX-Master-3-bindings.sh Alt_Scroll_R")
;; thumb wheel down => last tab/volume down
(xbindkey '(b:6) "~/dotfiles/MX-Master-3-bindings.sh Scroll_L")
(xbindkey '(alt b:6) "~/dotfiles/MX-Master-3-bindings.sh Alt_Scroll_L")
