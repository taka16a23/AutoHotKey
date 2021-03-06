;; Sleipnir
;; ==========================================================
#IfWinActive, ahk_class MainWindow

;;;; Close Tab or exit
;;
$MButton::
  MouseGetPos, x, y, OutputVarWin
  WinGetText, text, ahk_id %OutputVarWin%
  IfInString, text, about:blank
  {
    Send, !{F4}
  }
  Else
  {
    Send, ^{F4}
  }
  Return



;;;; 右click ＋ 中央click
;;
~Rbutton & ~MButton::ControlSend, %Sleipnir_ClassNN_RSS_Left_Tree%, {down}

;;;; ctrl + Q = タブ復元
;;
$^q::Send, ^l

;;;; Headline Reader 操作
;;
^Space::ControlSend, %Sleipnir_ClassNN_RSS_Left_Tree%, {down}
+Space::ControlSend, %Sleipnir_ClassNN_RSS_Left_Tree%, {up}


;;;; Run Default Browser This Page
;;
#s::
  ControlGetText, url, %Sleipnir_ClassNN_url_bar%
  Run, %url%
  Sleep, 2500
  IfWinExist, %AhkClass_Sleipnir%
    WinActivate, %AhkClass_Sleipnir%
  Else
  {
    Return
  }
  Return

#IfWinActive


;; Functions
;; ==========================================================
Run_Sleipnir(url)
  {
    global
    Run, %Sleipnir_Path% %url%
  }
