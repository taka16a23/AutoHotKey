#Include ../dirset_script.ahk
#Include ../variable.ahk
#Include ../function.ahk

Run, %AScriptDir%/Dos/bat/nc.bat
WinWaitActive, ahk_class ConsoleWindowClass
Sleep, 2000
Send, nc -w 3 -lp 12345 > D:\MYTEMP\

ExitApp
esc::ExitApp
