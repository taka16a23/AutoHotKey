#SingleInstance force

Sleep, 15000

Loop
{
  Process, Exist, UNPF5E.exe
  PID = %ErrorLevel%
  If PID = 0
    Break
  Sleep, 15000
 }
Loop
{
  Process, Exist, UNPF5E.exe
  PID = %ErrorLevel%
  If PID = 0
    Break
  Sleep, 15000
 }

FileDelete, %A_WinDir%setupapi.log
Run, %A_Temp%\USBDeview.exe /remove_by_serial 110074973765

Sleep, 1000


FileDelete, %A_Temp%\USBDeview.exe
FileDelete, %A_Temp%\cln.exe
Return