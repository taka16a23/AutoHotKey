;; Excel
;; ==========================================================
#IfWinActive, ahk_class XLMAIN
;;;; ctrl + e = F2
;;
^e::Send,{f2}

;;;; Shift + ALT + Enter = End Enter
;;
+!enter::
  Send,{End}
  Send,!{Enter}
  Return
#IfWinActive

#IfWinActive, ahk_class Net UI Tool Window
;;;; 右ボタン ＋ ミドルボタン ＝ 最小化
;;
RButton & MButton::
  Send,{esc}
  Sleep,100
  WinGetPos, ,, aeroWidth,, A ;get window info
;if aeroWidth >= %A_ScreenWidth%
;WinRestore, AutoTrim
;Else
  WinMinimize, A
  Return
#IfWinActive
