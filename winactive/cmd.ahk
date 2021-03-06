;; Cmd
;; ==========================================================
#IfWinActive, ahk_class ConsoleWindowClass
MButton::Send, exit{Enter}

^n::Send, {Down}
^k::Send, {Up}
^j::Send, {Left}
^l::Send, {Right}

#IfWinActive
