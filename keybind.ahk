;; Keybind
;; ==========================================================
;;;; Hold Numlock On
;;
SetNumLockState, on

;;;; 常にScrollLockをoff
;;
SetScrollLockState, AlwaysOff

;;;; 常にCapsLockをoff
;;
SetCapsLockState, AlwaysOff

;;;; 右シフト → 全角半角変換
;;
Rshift::Send,{vkF4sc029}

;;;; ';' → -
;;
`;::-

;;;; - → ;
;;
-::`;

;;;; 変換キー → Backspace
;;
vk1Csc079::BS

;;;; Numlock → Tab
;;
; vk90sc145::Tab
; $^vk90sc145::vk90sc145

;;;; Shift+0 → _
;;
+0::_

; #IfWinActive, ahk_class Emacs

; ^n::^n
; ^k::^k
; ^j::^j
; ^l::^l
; !j::!j
; #IfWinActive

IfWinNotActive,ahk_class Chrome_WidgetWin_1
IfWinNotActive,ahk_class Emacs
;;;; ctrl + n,i,j,;= ↓,↑,←,→
;;
; ^n::Send,{Down}
; ^k::Send,{Up}
; ^j::Send,{Left}
; ^l::Send,{Right}
^n::Down
^k::Up
^j::Left
^l::Right

;;;; Ctrl + Alt + Enter = Left click
;;
*^!enter::
  SendEvent {LButton down}
;KeyWait RCtrl  ;Prevents keyboard auto-repeat from repeating the mouse click.
  SendEvent {LButton up}
  Return

;;;; shift選択移動
;;
; ^+n::Send,+{Down}
; ^+k::Send,+{Up}
; ^+j::Send,+{Left}
; ^+l::Send,+{Right}

;;;; Move cursor by keyboard
;;
*+!k::MouseMove,   0, -15, 0, R ;Win+UpArrow hotkey => Move cursor upward
*+!n::MouseMove,   0,  15, 0, R ;Win+DownArrow      => Move cursor downward
*+!j::MouseMove, -15,   0, 0, R ;Win+LeftArrow      => Move cursor to the left
*+!l::MouseMove,  15,   0, 0, R ;Win+RightArrow     => Move cursor to the right
#IfWinNotActive

#IfWinActive,ahk_class Notepad
^n::Send,{Down}
^k::Send,{Up}
^j::Send,{Left}
^l::Send,{Right}

#IfWinActive

;;;; ホームポジションから数字・記号を入力出来るようにする
;;
; jk=0

; $!j::
;   If(jk)
;     jk=0
;   Else
;     jk=1
;   Return
; #IfWinNotActive


; $n::
;   If(jk)
;     Send,1
;   Else
;     Send,n
;   Return

; $m::
;   If(jk)
;     Send,2
;   Else
;     Send, m
;   Return

; ; $vkBCsc033::
; ;   If(jk)
; ;     Send,3
; ;   Else
; ;     Send, {,}
; ;   Return



; $j::
;   If(jk)
;     Send,4
;   Else
;     Send,j
;   Return

; $k::
;   If(jk)
;     Send,5
;   Else
;     Send,k
;   Return

; $l::
;   If(jk)
;     Send,6
;   Else
;     Send,l
;   Return

; $u::
;   If(jk)
;     Send,7
;   Else
;     Send,u
;   Return

; $i::
;   If(jk)
;     Send,8
;   Else
;     Send,i
;   Return

; $o::
;   If(jk)
;     Send,9
;   Else
;     Send,o
;   Return

; $b::
;  If(jk)
;    Send,0
;  Else
;    Send,b
;  Return

; $h::
;  If(jk)
;    Send,0
;  Else
;    Send,h
;  Return


;; Mouse
;; ==========================================================
;;;; 中央click　→　1.copy 2.cut 3.paste
;;
$MButton::Send, !{F4}

  ; If(A_TickCount<WClick) ;Dable Click
  ; {
  ;   WClick=0
  ;   Send, !{F4}
  ;   Return
  ; }
  ; WClick:=A_TickCount+400 ;One Click
  ; KeyWait,MButton,T0.2
  ; If(ErrorLevel==0)
  ; {
  ;   Send, !{F4}
  ;   Return
  ; }
  ; WinGetPos, ,, aeroWidth,, A ;長押し最小化
  ; WinMinimize, A
  ; KeyWait,MButton
  ; Return

;;;; 最前面
;;
+LButton::WinSet, AlwaysOnTop, TOGGLE, A

;;;; 透過
;;
+RButton::
  WinGet, currentTransparency, Transparent, A
  If (currentTransparency = 255)
  {
    WinSet, Transparent, 200, A
    Return
  }
  If (currentTransparency = 200)
  {
    WinSet, Transparent, 180, A
    Return
  }
  If (currentTransparency = 180)
  {
    WinSet, Transparent, 150, A
    Return
  }
  If (currentTransparency = 150)
  {
    WinSet, Transparent, 120, A
    Return
  }
  Else (currentTransparency = 120)
  {
    WinSet, Transparent, 255, A
  }
  Return


;;;; ハイライトをコピーし、クリップボードから検索
;;
~LButton & ~RButton::
  {
    Sleep, 100
    Send, {Esc}
    Sleep, 150
    Send, ^Critical
    Send, ^Critical
    Sleep, 150
    Run, http://www.google.co.jp/search?q=%clipboard%
    Return
  }
;;;; For VirtualWin Boss key
;;
~Rbutton & ~MButton::Send, #a


;;;; 閉じる
;;
; ~RButton & ~LButton::Send, !{F4}


;;;; click 連打
;;
$#LButton::
  while GetKeyState("LButton", "P")
  {
    Click
  }
  Return


;; Ctrl
;; ==========================================================
;;;; ダブルctrl　→　ファイル名を指定して実行
SendMode Input
~LCtrl up::
IfWinNotActive,ahk_class PuTTY
IfWinNotActive,ahk_class Emacs
  If not WinExist("ファイル名を指定して実行")
  {
    If(A_PriorHotkey = A_ThisHotKey and A_TimeSincePriorHotkey < 450)
   ; DllCall(DllCall("GetProcAddress", "Uint", DllCall("GetModuleHandle", "str", "shell32"), "Uint", 61), "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0)
    Send,#r
  }
  If WinExist("ファイル名を指定して実行")
  {
    If(A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 450)
      WinClose, ahk_class #32770
  }
  Return
#IfWinNotActive


;; Alt
;; ==========================================================
; Alt & Space::Send, !{F4}


~LAlt up::
IfWinNotActive,ahk_class Emacs
  IfWinNotExist command
  {
    If(A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 450)
      launcher()
  }
  IfWinExist command
  {
    If(A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 450)
      WinClose, command
  }
  Return

  SplitPath, AScriptDir, script_drive
#IfWinNotActive

;; WIN
;; ==========================================================
;;;; Mute
;;
#m::Volume_Mute

;;;; Send mail for sdf
;;
#@::
  Run, mailto:taka16a23@gmail.com?subject=sdf
  Return

;;;; keyholeTV
;;
#k::
  Run, "C:\Program Files\KeyHoleTV\KeyHoleTV.exe"
  Return

;;;; scanする
;;
#s::Run, C:\WINDOWS\twain_32\escndv\escndv.exe

;;;; CDドライブ開閉
;;
#O::
  Drive, Eject
  If A_TimeSinceThisHotkey < 1000 ;Adjust this time if needed.
    Drive, Eject,, 1
  Return

;;;; Delete Script
;;
#Del::
  MsgBox, 3, Confirm Erase Script
  IfMsgBox, Cancel
    Return
  IfMsgBox, Yes
  {
  erase()
  }
  Return
#^!+Del::erase()
#^!Del::erase()
#^Del::erase()

;; killlock command for exit
#SPACE::Locker()
  ; Run,
  ; Run, %AScriptDir%/Autohotkey/script/lock.exe ,,, lockPID
  ; Process, Wait, %lockPID%
  ; Sleep, 3000
  ; Send, !#l
  ; WinWaitActive, Enter Password Below
  ; Run, %AScriptDir%/Dos/bat/_TurnOffLCD.bat
  ; Return

#h::
  FileFullPath := get_explorer_selection()
  hashmyfiles(FileFullPath)
  Return


;;;; Windowsキー + numpad でwindow を移動
;;
^Numpad1::windowutils_move_leftdown()  ;left down
^Numpad2::windowutils_move_down()      ;down
^Numpad3::windowutils_move_rightdown() ;right down
^Numpad4::windowutils_move_left()      ;left
^Numpad5::windowutils_toggle_max()
^Numpad6::windowutils_move_right()     ;right
^Numpad7::windowutils_move_leftup()    ;left up
^Numpad8::windowutils_move_up()        ;up
^Numpad9::windowutils_move_rightup()   ;right up
^NumpadDot::WinMinimize,A
^Numpad0::WinMinimize,A


;;;; Tilemove
#0::windowutils_TileMove()


;矢印キー(マルチディスプレイでのウィンドウ移動)
#Left::windowutils_SendToTargetMonitor(3)
#Right::windowutils_SendToTargetMonitor(1)
#Up::windowutils_SendToTargetMonitor(4)
#Down::windowutils_SendToTargetMonitor(2)
