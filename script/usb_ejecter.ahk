#SingleInstance force

; Process, Close, Autohotkey.exe
; Process, Close, Autohotkey.exe
; Process, WaitClose, Autohotkey.exe

; Sleep, 500

Run, %A_Temp%\UnplugDrive.bat,,Hide
Sleep, 20000
While WinExist("UnplugDrive Portable")
{
  Sleep, 5000
}

ErrorLevel= 
Process, Exist, UnplugDrive.exe
If ErrorLevel
{
  Send, #e
}

sleep, 10000

ErrorLevel=
Process, Exist, UnplugDrive.exe
If ErrorLevel
{
  Run, %A_Temp%\Unlocker.bat,,Hide
}

ErrorLevel=
While not ErrorLevel
{
  Process, Exist, UnplugDrive.exe
  Sleep, 2000
}

ErrorLevel=
While not ErrorLevel
{
  Process, Exist, Unlocker.exe
  Sleep, 2000
}

FileDelete, %A_Temp%\UnplugDrive.bat 
FileDelete, %A_Temp%\Unlocker.bat
FileDelete, %A_Temp%\Unlocker.exe
FileDelete, %A_Temp%\UnplugDrive.exe
FileDelete, %A_TemP%\UnlockerDriver5.sys
FileDelete, %A_TemP%\usb_ejecter.exe

ExitApp
esc::ExitApp