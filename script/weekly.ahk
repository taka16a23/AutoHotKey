#SingleInstance force
#Include ../dirset_script.ahk
#Include ../variable.ahk
#Include ../function.ahk
#Include ../../Lib/windowutils.ahk

;;;; Weekly
;;
Weekly()
{
  global

  ;; Check monthly
  Run, %Pythonw_path% %AScriptDir%/Autohotkey/script/monthly_date.py, %AScriptDir%/Autohotkey/script/
  Sleep, 1000
  IfExist, %AScriptDir%/Autohotkey/script/flag
  {
    monthly_flag := true
  }
  Else
  {
    monthly_flag := false
  }

  IfExist, %AScriptDir%/Autohotkey/script/flag4
  {
    monthly_flag := true
    quarter_flag := true
  }
  Else
  {
    quarter_flag := false
  }

  ;; Bookmark temp 整理
  activate_force(AhkClass_Default_Browser, Default_Browser)
  Sleep, 100
  Send, +^o
  Sleep, 500
  ;; wol
  Run, %AScriptDir%/Dos/bat/_wol.bat
  Wait_Close_Page("Bookmark Manager", Default_Browser_Title_Extension)

  ;; MYTEMP 整理
  MsgBox, MYTEMP 整理
  Run, %Xfinder_Path%
  WinWait, %Ahk_Class_Xfinder%
  Sleep, 4000
  windowutils_move_right()
  Run, %PAGEANT_Path% %kagi_Path% -c %WinSCP_Path% ki
  WinWait, %Ahk_Class_WinScp%
  Sleep, 4000
  windowutils_GetActiveMonitor(x, y, w, h)
  WinMove, %Ahk_Class_WinScp%,,x, y, w / 2 , h
  WinWaitClose, %Ahk_Class_Xfinder%

  ;; イベント ビューア
  Max_eventvwr()
  WinWaitClose, イベント ビューア

  ;; Excel見直し Consititution確認
  Show_Calendar()
  MsgBox, Clean Mail folder`nCheck Excel`nCheck Consititution`nScheduling weekly
  sdf()

  If monthly_flag
  {
    InputBox, pass, password, Enter Password for archive., HIDE , 400, 112
  }

  ;; 掃除
  MsgBox, 掃除`n観葉植物に水`n`nOK を押すと以後PCはlockされます。

  ;; Monthly backup
  If monthly_flag
  {
    ;; update usb all
    Run, %AScriptDir%/system/Ccleaner/CCleaner.exe /update
    Process, WaitClose, %CCleanerPID%
    Run, %Python_path% %AScriptDir%/Lib/.pylib/portable/update_usb.py -a -u
    Run, %AScriptDir%/Dos/bat/ccauto.bat
    Sleep, 5000
    Process, WaitClose, %CCleanerPID%
  }

  ;; USB backup
  sync(Local_emacsd, Server_emacsd) ;sync emacs.d
  sync(Local_usb, Server_usb) ;sync usb
  WinWait, %AhkClass_WnnScp_CheckDialog%
  IfWinExist, %AhkClass_WnnScp_CheckDialog%
  {
    WinActivate, %AhkClass_WnnScp_CheckDialog%
    Send, {Enter}
  }
  WinWait, %AhkClass_WnnScp_CheckDialog%
  IfWinExist, %AhkClass_WnnScp_CheckDialog%
  {
    WinActivate, %AhkClass_WnnScp_CheckDialog%
    Send, {Enter}
  }
  Process, WaitClose, %WinSCP_PID%
  ; Run, %AScriptDir%/Dos/bat/_kidkeylock.bat

  If quarter_flag
  {
    Backup_Outlook(pass)
    Backup_Atok(pass)
  }

  If monthly_flag
  {
    Backup_Rss(pass)
    Backup_Chrome(pass)
  }

  ;; Grooming
  MsgBox, Grooming

  ;; Prompt ki server halt.
  Process, WaitClose, WinSCP.exe
  MsgBox, 3,, サーバーの電源を切りますか？
  IfMsgBox, Yes
  {
    Run, kihalt.bat
  }

  pass =
}

Weekly()
ExitApp
esc::ExitApp
