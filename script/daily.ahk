#SingleInstance force
#Include ../dirset_script.ahk
#Include ../variable.ahk
#Include ../function.ahk



BlockInput, Mouse

global RSS_Path, AhkClass_RSS, RSS_ClassNN ;RSS
global Default_Browser, AhkClass_Default_Browser ;default browser
global Local_sdf, Server_sdf ;sdf
global Python_path

;; RSS
Run, %RSS_Path%
; Sleep, 5000
; WinWait, %AhkClass_RSS%
; WinActivate, %AhkClass_RSS%
; Sleep, 5000
; Send, !xp

;; OUTLOOK Mail
Show_Mail()

;; sdf.xls
; sync(Local_sdf, Server_sdf)
; Sleep, 3000
; Process, WaitClose, WinSCP.exe
; sdf()
; Sleep, 3000
; sync(Local_sdf, Server_sdf)

;; Weather
activate_force(AhkClass_Default_Browser, Default_Browser)
Run, _tenki.bat
Sleep, 10000
Wait_Close_Page("気象庁 | 異常天候早期警戒情報", Default_Browser_Title_Extension)

;; Japan news - Browser Main
activate_force(AhkClass_Default_Browser, Default_Browser)
Run, _japan_news.bat
sleep, 10000
; Wait_Close_Page("東京穀物商品取引所", Default_Browser_Title_Extension)

;; Wait Close RSS
; IfWinExist, %AhkClass_RSS%
  ; WinActivate, %AhkClass_RSS%
WinWaitActive, %AhkClass_RSS%
WinWaitClose, %AhkClass_RSS%

;; Foreign news - Browser Main
activate_force(AhkClass_Default_Browser, Default_Browser)
Run, _foreign_news.bat
Sleep, 30000
Wait_Close_Page("The New York Times - Breaking News, World News & Multimedia", Default_Browser_Title_Extension)

;; Nation - Browser Main
activate_force(AhkClass_Default_Browser, Default_Browser)
Run, _nation.bat




ExitApp
esc::ExitApp
