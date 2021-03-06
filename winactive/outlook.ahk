;; OUTLOOK
;; ==========================================================
#IfWinActive, ahk_class rctrl_renwnd32
^0::Send,^+a
^e::Send,^n

; Minimize only main outlook window
$MButton::
  WinGetTitle, title
  IfInString, title, Microsoft Outlook
  {
    WinGetPos, ,, aeroWidth,, A ;get window info
    WinMinimize, A
  }
  Else
  {
    Send, !{F4}
  }
  Return

#IfWinActive
