;; Emacs
;; ==========================================================
;;;; Autohotkey.ahk で ^s + reload
;;
#IfWinActive, ahk_class Emacs

^n::^n
^k::^k
^j::^j
^l::^l
!j::!j


$^!enter::Send,^!{Enter}

$^+n::^+n
$^+k::^+k
$^+j::^+j
$^+l::^+l

$+!k::+!k
$+!n::+!n
$+!j::+!j
$+!l::+!l

#IfWinActive
