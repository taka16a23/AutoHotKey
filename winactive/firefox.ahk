;; FireFox
;; ==========================================================
#IfWinActive,ahk_class MozillaWindowClass
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

;;;; ctrl + E = 検索ボックスに移動 
;;
;; Default

;;;; ctrl + Q = タブ復元
;;
^q::Send,^+t

;;;; F2 = ウィンドウ再起動
;;
F2::RestartActiveApp()

#IfWinActive

;; FireFox old
;; ==========================================================
#IfWinActive,ahk_class MozillaUIWindowClass

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

;;;; ctrl + E = 検索ボックスに移動
;;
;; Default

;;;; ctrl + Q = タブ復元
;;
^q::Send,^+t

;;;; F2 = ウィンドウ再起動
;;
F2::RestartActiveApp()

#IfWinActive
