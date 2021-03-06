;-------------------------Instructions-------------------------
;
;Alt X = Unlock Screen
;Alt R = Reset Password
;
;Use right click menu to set other options
;
;------------------------Requirements-----------------------
;
;Only tested on Windows XP
;
;Reasonably current version of Autohotkey
;
;---------------------------------------------------------------------
#SingleInstance force


lockstate=0

;Creates Black Password on first run

IfNotExist, %A_ScriptDir%\lock
FileAppend,
(
[Password]
Password=
), %A_ScriptDir%\lock


;Creates GUI for Changing Password

Gui, Add, Text, x6 y10 w180 h20, Set your Password below-
Gui, Add, Text, x6 y40 w180 h20 , Old Password
Gui, Add, Edit, x6 y60 w180 h20 vpass0,
Gui, Add, Text, x6 y90 w180 h20, New Password
Gui, Add, Edit, x6 y110 w180 h20 vpass1,
Gui, Add, Text, x6 y140 w180 h20 , Confirm New Password
Gui, Add, Edit, x6 y160 w180 h20 vpass2,
Gui, Add, Button, x86 y190 w100 h30 gConfirm, Confirm


;checks idle time every minutes
SetTimer, Timer, 60000

;Timer Starts off disabled

IfNotExist, %A_ScriptDir%\lock
    IniWrite, 0, %A_ScriptDir%\lock, autoactivate, Status

IfNotExist, %A_ScriptDir%\lock
    IniWrite, 900000, %A_ScriptDir%\lock, autoactivate, milliSeconds

;Creates Menu's

Menu, Tray, Icon , %SystemRoot%\system32\SHELL32.dll, 48
Menu, Tray, NoStandard
Menu, TimerOptions, add, 3 Hours, Hours
Menu, TimerOptions, add, 2 Hours, Hours

Minutes=60

Loop,12
{
  Menu, TimerOptions, add, %Minutes% mins, Minutes
  Minutes-=5
}

;Checks/Enables/Disables menu items based on status of timer

IniRead, ms, %A_ScriptDir%\lock, autoactivate, milliSeconds

SetFormat, Float, 0.0
mins:=ms/60000

If mins > 3
    Menu, TimerOptions,Check, %mins% mins

If mins = 3
    Menu, TimerOptions,Check, 3 Hours

If mins = 2
    Menu, TimerOptions,Check, 2 Hours

Menu, Tray, add, Lock
Menu, Tray, Default, Lock
Menu, Tray, add, Change Password, PassChange
Menu, TimerOptions, add, Disable
Menu, Tray, add, Auto-Activate, :TimerOptions


IniRead, autoStatus, %A_ScriptDir%\lock, autoactivate, Status, 0

If autoStatus=1
    SetTimer, Timer, on

If autoStatus=0
{
  SetTimer, Timer, off
  Menu, TimerOptions, Disable, 3 Hours
  Menu, TimerOptions, Disable, 2 Hours
  Minutes=60
  Loop,12
  {
    Menu, TimerOptions, Disable, %Minutes% mins
    Minutes-=5
  }
  Menu, TimerOptions,Rename, Disable, Enable
}

Menu, Tray, add, Exit

;Enables All Blocked Keys

Hotkey, Left, Off
Hotkey, Right, Off
Hotkey, up, Off
Hotkey, down, Off

Hotkey, Tab, Off
Hotkey, !Tab, Off
Hotkey, !F4, Off
Hotkey, LWin, Off
Hotkey, RWin, Off
Hotkey, AppsKey, Off
Hotkey, ^Escape, Off

Hotkey, NumpadUp, Off
Hotkey, NumpadDown, Off
Hotkey, NumpadLeft, Off
Hotkey, NumpadRight, Off

;If password isn't set then you will be prompted for it on startup

IniRead, Password, %A_ScriptDir%\lock, Password, Password

If Password=Error
    IniWrite, `n, %A_ScriptDir%\lock, Password, Password

If Password=
    Gosub, SetPassword
Return

PassChange:
  Gosub, SetPassword
Return


;-------------------------------------------------------------------

;Disables/Enables Menu items and Timer

Disable:

 If A_ThisMenuItem=Disable
 {
   IniWrite, 0, %A_ScriptDir%\lock, autoactivate, Status
   SetTimer, Timer, off
   Menu, TimerOptions,Rename, Disable, Enable
   Menu, TimerOptions, Disable, 3 Hours
   Menu, TimerOptions, Disable, 2 Hours
   Minutes=60
   Loop,12
   {
     Menu, TimerOptions, Disable, %Minutes% mins
     Minutes-=5
   }
 }

 If A_ThisMenuItem=Enable
 {
   IniWrite, 1, %A_ScriptDir%\lock, autoactivate, Status
   SetTimer, Timer, on
   Menu, TimerOptions,Rename, Enable, Disable

   Menu, TimerOptions, Enable, 3 Hours
   Menu, TimerOptions, Enable, 2 Hours
   Minutes=60
   Loop,12
   {
     Menu, TimerOptions, Enable, %Minutes% mins
     Minutes-=5
   }
 }

Auto-Activate:
Return


Hours:
Minutes:

 Menu, TimerOptions, UnCheck, 3 Hours
 Menu, TimerOptions, UnCheck, 2 Hours
 Minutes=60
 Loop,12
{
    Menu, TimerOptions, UnCheck, %Minutes% mins
    Minutes-=5
 }

 Menu, TimerOptions,ToggleCheck, %A_ThisMenuItem%
 StringLeft, mins,A_ThisMenuItem, 2

 ;Calculates milliseconds to wait based on timer option chosen

 If mins=2
   milliSeconds=7200000
 If mins=3
   milliSeconds=10800000
 milliSeconds:=mins*60000
 IniWrite, %milliSeconds%, %A_ScriptDir%\lock, autoactivate, milliSeconds
 Return


Timer:

 ;If more than X minutes has passed then lock the screen

 IniRead, milliSeconds, %A_ScriptDir%\lock, autoactivate, milliSeconds
 If A_TimeIdlePhysical > %milliSeconds%
 {
   SetTimer, Timer, off
   Gosub, Lock
 }
Return


Lock:

 lockstate=1

 IniRead, Password, %A_ScriptDir%\lock, Password, Password

 If Password=Error
   IniWrite, `n, %A_ScriptDir%\lock, Password, Password

 If Password=
 {
   Gosub, SetPassword
   Return
 }

 ;Blocks all hotkeys which could be used to unlock the screen

 Hotkey, Left, On
 Hotkey, Right, On
 Hotkey, up, On
 Hotkey, down, On

 Hotkey, Tab, On
 Hotkey, !Tab, On
 Hotkey, !F4, On
 Hotkey, LWin, On
 Hotkey, RWin, On
 Hotkey, AppsKey, On
 Hotkey, ^Escape, On

 Hotkey, NumpadUp, On
 Hotkey, NumpadDown, On
 Hotkey, NumpadLeft, On
 Hotkey, NumpadRight, On

 WinHide, ahk_class Shell_TrayWnd

 WinGetPos, , , Width, Height, ahk_class Progman
 Width += 2000
 Height += 100
 SplashTextOn, %Width% , %Height%, Lock SCREEN, SCREEN is locked
 WinSet, Transparent, 100, Lock SCREEN

;------------------------------------------------------------------

 ;Begins Locking of Screen

beginning:

 lockstate=1

 SetTimer, InputOnTop, 500
 SetTimer, CloseTaskmgr, 600

 InputBox, Password, Enter Password Below, , hide ,250,100
 Password=     ; for dummy password prompt
 If ErrorLevel <> 0
 {
   Gosub, beginning
 }
 Else
 {
   IniRead, encryptedpass, %A_ScriptDir%\lock, Password, Password

   If (Password = RC4(encryptedpass,RC4Pass))
   {
     SplashTextOff
     WinShow, ahk_class Shell_TrayWnd
     Reload
   }
      Else
   {
      ;System Modal    = 4096
      ;Icon Hand         = 16
      ;OK      =0
      Timeout=5
      SetTimer, DisableOK, 100
      SetTimer, MsgBoxTimeout, 1000
      MsgBox, 4112, Error (%Timeout%), Invalid Password, 6
      Gosub, beginning
   }
 }
Return

CloseTaskmgr:
 SetTimer, CloseTaskmgr, off
 Process, Wait, taskmgr.exe, 4
 Process, Close, taskmgr.exe
 SetTimer, CloseTaskmgr, on
return

DisableOK:
 Control, Disable, , OK, Error (%Timeout%)
Return

InputOnTop:
 Control, Disable, , Cancel, Enter Password Below
 WinSet, AlwaysOnTop, On, Enter Password Below
 SetTimer, InputOnTop, Off
Return

MsgBoxTimeout:
 oldTimeout=%Timeout%
 Timeout-=1
 WinSetTitle, Error (%oldTimeout%), , Error (%Timeout%)
 If Timeout = 0
   SetTimer, MsgBoxTimeout, off
Return
  
!F12::
 Exit:
 WinShow, ahk_class Shell_TrayWnd
 ExitApp
 
; !r::
;  MsgBox,4,, Are you sure you want to reset the Password?
;  FileDelete, %A_ScriptDir%\lock
; Return

!#l::

Listvars
Winwait, %A_ScriptFullPath%
Winhide, %A_ScriptFullPath%
SetTitleMatchMode, Fast

 if lockstate=0
   goto, lock
 WinShow, ahk_class Shell_TrayWnd
 Reload

Left::
right::
up::
down::

Tab::
!Tab::
!F4::
LWin::
RWin::
#r::
LCtrl::
RCtrl::
Appskey::
^Escape::

NumpadUp::
NumpadDown::
NumpadLeft::
NumpadRight::

Return

SetPassword:
 IniRead, Password, %A_ScriptDir%\lock, Password, Password
 Gui, Show, x361 y359 h230 w198, Change Password
 If Password=
   Control, Disable, ,Edit1, Change Password
Return

Confirm:
 Gui, Submit
 IniWrite, 0, %A_ScriptDir%\lock, SetPassword, True
 IniRead, encryptedpass, %A_ScriptDir%\lock, Password, Password

 If (RC4(encryptedpass,RC4Pass) != pass0)
 {
   Gui, Show
   MsgBox, Old Password is incorrect
   Return
 }
If (pass1="" or pass2 ="")
 {
   Gui, Show
   MsgBox, new Password cannot be blank
   Return
 }
 If pass1=%pass2%
 {
   encryptedpass:=RC4(pass1,RC4Pass)
   IniWrite, %encryptedpass%, %A_ScriptDir%\lock, Password, Password
 }
 Else
 {
   Gui, Show
   MsgBox, Passwords do not match!
   Return
 }
Return

;___RC4 Encryption by Rajat_____________________________________

RC4(RC4Data,RC4Pass)
  {
    global RC4Result
    ATrim = %A_AutoTrim%
    AutoTrim, Off
    BLines = %A_BatchLines%
    SetBatchLines, -1
    StringLen, RC4PassLen, RC4Pass
    Loop, 256
      {
        a := A_Index - 1
        Transform, ModVal, Mod, %a%, %RC4PassLen%
        ModVal ++
        StringMid, C, RC4Pass, %ModVal%, 1
        Transform, AscVar, Asc, %C%
        Key%a% = %AscVar%
        sBox%a% = %a%
      }
    b = 0
    Loop, 256
      {
        a := A_Index - 1
        TempVar := b + sBox%a% + Key%a%
        Transform, b, Mod, %TempVar%, 256
        T := sBox%a%
        sBox%a% := sBox%b%
        sBox%b% = %T%
      }
    StringLen, DataLen, RC4Data
    RC4Result =
    i = 0
    j = 0
    Loop, %DataLen%
      {
        TmpVar := i + 1
        Transform, i, Mod, %TmpVar%, 256		
        TmpVar := sBox%i% + j
        Transform, j, Mod, %TmpVar%, 256
        TmpVar := sBox%i% + sBox%j%
        Transform, TmpVar2, Mod, %TmpVar%, 256
        k := sBox%TmpVar2%
        StringMid, TmpVar, RC4Data, %A_Index%, 1
        Transform, AscVar, Asc, %TmpVar%
        Transform, C, BitXOr, %AscVar%, %k%
        IfEqual, C, 0
            C = %k%
        Transform, ChrVar, Chr, %C%
        RC4Result = %RC4Result%%ChrVar%
      }
    AutoTrim, %ATrim%
    SetBatchLines, %BLines%
    Return RC4Result
  }
;___RC4 Encryption by Rajat_____________________________________ 

