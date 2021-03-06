;; Chrome
;; ==========================================================
#IfWinActive,ahk_class Chrome_WidgetWin_1

;;;; 左click ＋ wheel ＝ 進む、戻る
;;
~LButton & ~WheelUp::Send,!{left}
~LButton & ~WheelDown::Send,!{right}

; ^n::^n
; ^k::^k
; ^j::^j
; ^l::^l

^n::Down
^k::Up
^j::Send,{Left}
^l::Send,{Right}

;;;; 右click ＋ wheel = タブ移動
;;
~RButton & ~WheelUp::
Send, ^{PgUp}
Send, ^0
Return

~RButton & ~WheelDown::
Send, ^{PgDn}
Send, ^0
Return

;;;; 右click ＋ 左click = ホームへ戻る
;;
~RButton & ~LButton::
Send,!{Home}
KeyWait,RButton
Sleep,10
Send,{esc}
Return

;;;; Close Tab
;;
;;~MButton::Send, ^{F4}
MButton::Send, ^{F4}

;;;; 右click ＋ 中央click
;;
~Rbutton & ~MButton::Send, ^0

;;;; ctrl + Wheel = 縮小/拡大
;;
^WheelUp::^WheelDown
^WheelDown::^WheelUp

;;;; ctrl + E = アドレスバー移動 ？なし
;;
^e::
  Send,{F6}
  Sleep, 100
  Send, +{F1}
  Send, !d
  Return

;;;; ctrl + Q = タブ復元
;;
^q::Send,^+t

;;;; Secret mode
;;
;;$^i::^+n

;;;;F2 = ウィンドウ再起動
;;
F2::RestartActiveApp()

;;;; Run sleipnir
;;

#s::
  ControlGetText, url, %Chrome_ClassNN_Omnibox%
  Run_Sleipnir(url)
  Return

;;;; Developer tool
;;
^+d::Send, ^+I

;;;; icognito
;;
#i::Send, ^+N

;;;; for google search extension
;;
$^i::Send, ^{Down}
$^u::Send, ^{Up}
; $^n::Send, ^{Down}
; $^k::Send, ^{Up}

^,::Send, ^+{Tab}
^.::Send, ^{Tab}

!n::Down
!k::Up

#IfWinActive
