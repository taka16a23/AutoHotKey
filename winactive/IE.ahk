;; IE
;; ==========================================================
#IfWinActive,ahk_class IEFrame
;;;; 左click Wheel でブラウザ進む戻る
;;
~LButton & ~WheelUp::Send,!{left}
~LButton & ~WheelDown::Send,!{right}

;;;; 右click Wheel でブラウザタブ進む戻る
;;
~RButton & ~WheelUp::Send, ^+{Tab}
~RButton & ~WheelDown::Send, ^{Tab}

;;;;
;;
; ~RButton & ~LButton::Send, ^{F4}

;;;; Close Tab
;;
~MButton::Send, ^{F4}

;;;; ctrl + Wheel = 縮小/拡大
;;
^WheelUp::^WheelDown
^WheelDown::^WheelUp

;;;; ctrl + E = 検索ボックスに移動 
;;
;; Default

;;;; ctrl + Q = タブ復元
;;
^q::Send,^+t

;;;; Secret mode
;;
$^i::^+p

;;;; F2 = ウィンドウ再起動
;;
F2::RestartActiveApp()

#IfWinActive
