#lang s-exp framework/keybinding-lang


;; making sure that command is used as 'm'
(map-command-as-meta-key #t)


;; just get a command name from "Edit > Keybindings > Show active keybindings" and paste it here
(define (rebind key command)
  (keybinding
   key
   (λ (editor event)
     (send (send editor get-keymap) call-function
           command editor event #t))))


;; moving about
(rebind "c:i" "backward-character")
(rebind "c:o" "forward-character")
(rebind "c:k" "next-line")
(rebind "c:l" "previous-line")
(rebind "c:j" "backward-word")
(rebind "c:ö" "forward-word")
(rebind "c:u" "beginning-of-line")
(rebind "c:p" "end-of-line")


;; selecting
(rebind "c:s:i" "backward-select")
(rebind "c:s:o" "forward-select")
(rebind "c:s:k" "select-down")
(rebind "c:s:l" "select-up")
(rebind "c:s:j" "backward-select-word")
(rebind "c:s:ö" "forward-select-word")
(rebind "c:s:u" "select-to-beginning-of-line")
(rebind "c:s:p" "select-to-end-of-line")


;; comments
(rebind "c:s:c" "comment-out")
(rebind "c:s:u" "uncomment")

;; window jumping
(rebind "c:m:r" "down-into-embedded-editor")
(rebind "c:m:e" "up-out-of-embedded-editor")

;; known keybindings
;;
;; c:r --------> run
;; c:e --------> to def window
;; c:d --------> to repl
;; c:opt:s:7 --> λ
;; m:p ------> in repl: get previous command
;; m:n ------> in repl: get next command

;; keybinding-abbreviation-syntax:
;;
;; c ---> control
;; s ---> shift
;; m ---> esc, or command
;; a ---> option
