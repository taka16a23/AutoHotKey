;; PuTTY
;; ==========================================================
#IfWinActive, ahk_class PuTTY
^`;::Send,^]
+enter::!&
^enter::^&
!space::!$
^!n::^!n

$^!enter::Send,^!{Enter}

$^n::Send,^n
$^k::Send,^k
$^j::Send,^j
$^l::Send,^l
$!j::Send,!j

$^+n::Send,^+n
$^+k::Send,^+k
$^+j::Send,^+j
$^+l::Send,^+l

$+!k::Send,+!k
$+!n::Send,+!n
$+!j::Send,+!j
$+!l::Send,+!l

#p::
  MouseClick, right
  Sleep, 100
  Send, {down}
  Sleep, 100
  Send, {Enter}
  Return
#IfWinActive
