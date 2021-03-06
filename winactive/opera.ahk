;; Opera
;; ==========================================================
#IfWinActive,ahk_class OperaWindowClass
;;;; Close Tab
;;
~MButton::Send, ^{F4}

;;;; 左click ＋ wheel ＝ 進む、戻る
;;
~LButton & ~WheelUp::Send,!{left}
~LButton & ~WheelDown::Send,!{right}

;;;; 右click ＋ wheel = タブ移動
;;
~RButton & ~WheelUp::Send, ^+{Tab}
~RButton & ~WheelDown::Send, ^{Tab}

;;;; Close Tab
;;
; ~RButton & ~LButton::Send, ^{F4}

;;;; ctrl + Wheel = 縮小/拡大
;;
^WheelUp::^WheelDown
^WheelDown::^WheelUp

;;;; ctrl + E = アドレスバー移動 ？なし
;;
^e::Send,{f6}

;;;; ctrl + Q = タブ復元
;;
^q::Send,^+t

;;;; Secret mode
;;
$^i::^+n

;;;;F2 = ウィンドウ再起動
;;
F2::RestartActiveApp()

;;;; Run sleipnir
;;
#d::
  Send,!d
  Sleep,1000
  Send,^Critical
  ClipWait
  Run %AScriptDir%\Internet\Sleipnir\PortableSleipnir.exe %Clipboard%
  Return

;;;; Developer tool
;;
^+d::Send, ^+I

#IfWinActive
