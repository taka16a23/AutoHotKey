;; WinSCP
;; ==========================================================
#IfWinActive, ahk_class TScpCommanderForm
~LButton & ~WheelUp::Send,!{left}
~LButton & ~WheelDown::Send,!{Right}
#IfWinActive
