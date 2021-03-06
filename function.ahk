;; FUNCTION
;; ==========================================================
;;;; Startup Program
;;
init(pgpath)
{
  psname := pg_from_path(pgpath)
  Process, Exist, %psname%
  If not (ErrorLevel)
  {
    Run, %pgpath%
  }
}

;;;; %AScriptDir%\Dos\bat を環境変数に追加
;;
SetEnvPath()
{
  global usb_bat_path
  RegRead, OutputVar, HKEY_CURRENT_USER, Environment, PATH
  RegWrite, REG_EXPAND_SZ, HKEY_CURRENT_USER, Environment,PATH,%OutputVar%%usb_bat_path%
  EnvUpdate
}

;;;; レジスト編集でキーマップ変更 Caplock → 左Ctrl  無変換キー → 左Alt
;;;; 要 ログオフ or 再起動
;;
ChangeKeyMap()
{
  RegDelete, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\Control\Keyboard Layout, Scancode Map
  Sleep, 1000
  RegWrite, REG_BINARY, HKEY_LOCAL_MACHINE
            ,SYSTEM\CurrentControlSet\Control\Keyboard Layout
            ,Scancode Map
            ,0000000000000000030000001D003A0038007B0000000000
  MsgBox, 再ログイン or 再起動してください。
}

KeyMapChange()
{
  global BB_Path
  mapvar = 0000000000000000030000001D003A0038007B0000000000
  RegRead, var, HKEY_LOCAL_MACHINE
           ,SYSTEM\CurrentControlSet\Control\Keyboard Layout
           ,Scancode Map
  If (var) ; if exist
  {
    If(var = mapvar) ;if same
    {
      Return
    }
    Else ; if different
    {
      ;; backup
      IfNotExist, %BB_Path%\KeyboardLayout.reg
      {
	FileCreateDir, %BB_Path%
        Sleep, 1000
	    Run, reg export "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout"
             ,%BB_Path%\KeyboardLayout.reg
           }
         }
       }
  MsgBox, 3, Change Keymap, keymap 変更しますか？  "要ログアウト"
  IfMsgBox, Cancel
    Return
  IfMsgBox, Yes
  {
    RegDelete, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\Control\Keyboard Layout, Scancode Map
    Sleep, 1000
    RegWrite, REG_BINARY, HKEY_LOCAL_MACHINE
              ,SYSTEM\CurrentControlSet\Control\Keyboard Layout
              ,Scancode Map ,%mapvar%
    MsgBox, 再ログイン or 再起動してください。
  }
}

;;;; explorer で選択したファイルのfull path を取得
;;
get_explorer_selection()
{
  IfWinNotActive ahk_class CabinetWClass
    return        ;shouldn't happen, but...

  WinGetClass explorerClass, A
  ControlGetText currentPath, Edit1, ahk_class %explorerClass%
  StringRight test, currentPath, 1

  if test <> \
    currentPath = %currentPath%\         ;Directories handled different for some reason
  SetWorkingDir %currentPath%

  ;For use with Vista search folders.
  ;Path must be the last column for this to work.
  ;Mapped network folders aren't supported.
  IfInString currentPath, .search-ms
  {

    ;Path should be the last column
    ControlGet, ncol, List, Count Col, SysListView321, ahk_class %explorerClass%
    ControlGet, items, List, Selected Col%ncol%, SysListView321, ahk_class %explorerClass%
    return %items%
  }
  Else
  {
    ControlGet, selectedFiles, List, Selected Col1, SysListView321, ahk_class %explorerClass%

    Loop, Parse, selectedFiles, `n
    {
      item := A_LoopField
      full_item = %currentPath%%item%
      items = %items%`n%full_item%
    }

    ;seems easier than messing with the loop
    StringTrimLeft, items, items, 1
    return %items%
  }
}


;;;; Open cmd on current directory
;;
OpenCmdInCurrent()
{
    ;This is required to get the full path of the file from the address bar
    WinGetText, full_path, A

    ; Split on newline (`n)
    StringSplit, word_array, full_path, `n
    full_path = %word_array1%   ; Take the first element from the array

    ; Just in case - remove all carriage returns (`r)
    StringReplace, full_path, full_path, `r, , all
    full_path := RegExReplace(full_path, "^Address: ", "") ;

    IfInString full_path, \
    {
        Run, cmd /K cd /D "%full_path%"
    }
    else
    {
        Run, cmd /K cd /D "C:\ "
    }
}


;;;; ランチャー
;;
launcher()
{
  InputBox, cmd, command, Run, , 350,112
  Run, %cmd%, ,UseErrorLevel
  If ErrorLevel = Error
  {
    cmd := %cmd%()
    Run, %cmd%
  }
  Return
}


;;;; 指定した window を active 化
;;   window がなければ起動して active 化
;;
activate_force(ByRef window, ByRef program_path)
{
  IfWinExist, %window%
    WinActivate, %window%
  Else
  {
    Run, %program_path%
    WinWait, %window%
    WinActivate, %window%
  }
  WinWaitActive, %window%
}

;;;; Web page が閉じるのを待つ
;;
Wait_Close_Page(Left_Name, Right_Name)
{
  WinWait, %Left_Name% - %Right_Name%
  WinWaitClose, %Left_Name% - %Right_Name%
}

;;;; process の優先度を(低)に変更する
;;
Priority_to_low(program)
{
  Loop, parse, program, `,
{
  Process, Priority, %A_LoopField%, Low
}
}

;;;; process の優先度を(通常以下)に変更する
;;
Priority_to_BelowNormal(program)
{
  Loop, parse, program, `,
{
  Process, Priority, %A_LoopField%, BelowNormal
}
}

;;;; process の優先度を(通常)に変更する
;;
Priority_to_Normal(program)
{
  Loop, parse, program, `,
{
  Process, Priority, %A_LoopField%, Normal
}
}

;;;; process の優先度を(通常以上)に変更する
;;
Priority_to_AboveNormal(program)
{

  Send, {LAUNCH_MAIL}
  WaitWaitWait(Default_Mailer_AhkClass)
  ; WinWaitActive, %Default_Mailer_AhkClass%
  WinMaximize, %Default_Mailer_AhkClass%
  Sleep, 1000
  Send, ^2
}

;;;; process の優先度を(高)に変更する
;;
Priority_to_High(program)
{
  Loop, parse, program, `,
{
  Process, Priority, %A_LoopField%, High
}
}

;;;; process の優先度を(リアルタイム)に変更する
;;
Priority_to_Realtime(program)
{
  Loop, parse, program, `,
{
  Process, Priority, %A_LoopField%, Realtime
}
}

;;;; Process を強制終了させる
;;
Close_Process(Pgname)
{
  Loop, parse, Pgname, `,
  {
    Process, Close, %A_LoopField%
  }
}

;;;; Calendar を表示
;;
Show_Calendar()
{
  global Default_Mailer_AhkClass
  Send, {LAUNCH_MAIL}
  WaitWaitWait(Default_Mailer_AhkClass)
  ; WinWaitActive, %Default_Mailer_AhkClass%
  WinMaximize, %Default_Mailer_AhkClass%
  Sleep, 1000
  Send, ^2
}

Show_Mail()
{
  global Default_Mailer_AhkClass
  Send, {LAUNCH_MAIL}
  WaitWaitWait(Default_Mailer_AhkClass)
  ; WinWaitActive, %Default_Mailer_AhkClass%
  WinMaximize, %Default_Mailer_AhkClass%
  Sleep, 1000
  Send, ^1
}

;;;; sdf 起動
;;
sdf()
{
  global Daily_Path, Pass_Box, Daily_AhkClass
  Run, %Daily_Path%
  WinWaitClose, %Pass_Box%
  WinWait, %Daily_AhkClass%
  WinWaitClose, %Daily_AhkClass%
}

;;;; イベント ビューアをMaxで開く
;;
Max_eventvwr()
{
  Run, eventvwr
  WinWait, イベント ビューア
  Sleep, 1000
  WinMaximize, イベント ビューア
}

;;;; Process の優先度を下げる
;;
low()
{
  below = mclean.exe
         ,clcl.exe
         ,LBTWiz.exe
         ,VTTimer.exe
         ,schedul2.exe
         ,spoolsv.exe
         ,OUTLOOK.EXE
  low = PAGEANT.EXE
       ,SetPoint.exe
       ,KHALMNPR.exe
       ,schedhlp.exe
  Priority_to_BelowNormal(below)
  Priority_to_Low(low)
}

;;;; Get the color under the mouse cursor invisible.
;;
getcolor()
{
  MouseGetPos, MouseX, MouseY, MouseWin
  PixelGetColor, MouseRGB, %MouseX%, %MouseY%, RGB
  msgbox, %MouseRGB%
}

;;;; chrome のSearch Engine を同期する関数
;;
chrome_SearchEngine_makefile()
{
  engine_path = C:\searchengine.txt
  Loop, 68
  {
    Sleep, 500
    Send, ^c
    ClipWait
    SearchEngine = %clipboard%
    Send, `t
    Sleep, 500
    Send, ^c
    ClipWait
    Keyword = %clipboard%
    Send, `t
    Sleep, 500
    Send, ^c
    ClipWait
    URL = %clipboard%
    Send, {Down}
    Sleep, 1000
    FileAppend, %SearchEngine%`^%Keyword%`^%URL%`n, %engine_path%
  }
  Return
}

chrome_SearchEngine_write()
{
  engine_path = C:\searchengine.txt
  Loop, Read, %engine_path%
  {
    StringSplit, WordArray, A_LoopReadLine, `^
    i = 0
    Loop, %WordArray0%
    {
      StringTrimLeft, thisword, WordArray%a_index%, 0
      clipboard = %thisword%
      Sleep, 1000
      Send, ^v
      Sleep, 1000
      i += 1
      if i < 3
      {
	Send, `t
      }
      Else
      {
	Send, {Enter}
      }
      Sleep, 1000
    }
  }
  Return
}

;;;; 待つ
;;
WaitWaitWait(ByRef name)
{
  WinWait, %name%
  WinActivate, %name%
  WinWaitActive, %name%
}

;;;; Upload to Ki server by WinSCP
;;
UploadToKi(ByRef File, ByRef Ki_Path)
{
  global PAGEANT_Path, kagi_Path ;SSH
  global WinSCP_Path, Ahkclass_WinScp_Dialog, Progress_Window ;WinSCP

  Run, %PAGEANT_Path% %kagi_Path% -c %WinSCP_Path% ki /upload %File%
  WaitWaitWait(Ahkclass_WinScp_Dialog)
  ControlSend, Edit1, %Ki_Path%
  ControlSend, Edit1, {Enter}
  WinWait, %Progress_Window%
  WinWaitClose, %Progress_Window%
}

;;;; Backup Directory by 7z
;;
BackupDir_by_ExePass(ByRef dirpath, ByRef ki_path, ByRef name, ByRef pass)
{
  global MYTEMP
  global 7z_Path ;7z

  date = %A_Year%_%A_Mon%_%A_MDay%
  Compressed_Name = %MYTEMP%%name%_%date%.exe

  Run, %7z_Path% a -sfx %Compressed_Name% %dirpath% -p"%pass%" , , ,7zPID
  Process, WaitClose, %7zPID%
  UploadToKi(Compressed_Name, ki_Path)
}

;;;; Quarter
;;
Quarter()
{
  outlook_dirpath = "C:\Documents and Settings\Taka16\Local Settings\Application Data\Microsoft\Outlook\"
  outlook_ki_path = /data/archive/windows/appdata/outlook/
  outlook_name = OUTLOOK

  InputBox, pass, password, Enter Password for archive., , 400, 112
  Process, Close, OUTLOOK.EXE
  BackupDir_by_ExePass(outlook_dirpath, outlook_ki_path, outlook_name, pass) ;Backup Outlook
  Backup_Atok(pass)
  pass=
  sdf()
  Show_Calendar()
  MsgBox, Excel4ヶ月見直し`n4ヶ月の予定を立てる
}

Backup_Chrome(pass)
{
  chrome_dirpath = "C:\Documents and Settings\qua\Local Settings\Application Data\Google\Chrome\User Data\Default"
  ki_path = /data/archive/windows/appdata/chrome/
  chrome_name = CHROME
  BackupDir_by_ExePass(chrome_dirpath, ki_path, chrome_name, pass)
}

;;;; Backup RSS
;;
Backup_Rss(pass)
{
  BlockInput, Mouse

  global MYTEMP
  global 7z_Path

  date = %A_Year%_%A_Mon%_%A_MDay%
  Compressed_Name = %MYTEMP%RSS_%date%.exe
  ki_Path = /data/archive/rss/
  rss_data_location = %AScriptDir%Internet\Sleipnir\settings\All Users\headlinereader\headlinereader.dat

  FileCopy, %rss_data_location%, %MYTEMP%
  Copyed_rss_data = %MYTEMP%headlinereader.dat
  Sleep, 1000
  If not FileExist(Copyed_rss_data)
  {
    Sleep, 1000
  }
  Run, %7z_Path% a -sfx %Compressed_Name% %Copyed_rss_data% -p"%pass%" , , ,7zPID
  Process, WaitClose, %7zPID%
  UploadToKi(Compressed_Name, ki_Path)
}

;;;; Backup Bookmark
;;
Backup_Bookmarks(pass)
{
  BlockInput, Mouse

  global MYTEMP
  global AhkClass_Default_Browser, Default_Browser_Title_Extension
  global 7z_Path

  Page_name = Bookmark Manager
  Save_dialog = 名前を付けて保存
  ki_Path = /data/archive/bookmarks/

  activate_force(AhkClass_Default_Browser, Default_Browser)
  Sleep, 100
  Send, +^o
  WinWait, %Page_name% - %Default_Browser_Title_Extension%
  WinActivate, %Page_name% - %Default_Browser_Title_Extension%
  WinMaximize, %AhkClass_Default_Browser%
  MouseClick, left, 180, 155 ;Click "Organize"
  Sleep, 500
  MouseClick, Left, 180, 460 ;Click Export
  WaitWaitWait(Save_dialog)
  ControlGetText, filename, Edit1, %Save_dialog%
  Export_Bookmark_name = %MYTEMP%%filename%
  ControlSend, Edit1, %Export_Bookmark_name%
  ControlSend, Edit1, {Enter}
  Sleep, 5000
  Bookmark_Archive = %Export_Bookmark_Name%.exe
  ;Compress Bookmark FileSetTime
  Run, %7z_Path% a -sfx %Bookmark_Archive% %Export_Bookmark_Name% -p"%pass%" , , ,7zPID
  Process, WaitClose, %7zPID%
  Sleep, 5000
  UploadToKi(Bookmark_Archive, ki_Path)
}

;;;; Backup Atok
;;
Backup_Atok(ByRef pass)
{
  global MYTEMP
  global PAGEANT_Path, kagi_Path ;SSH
  global 7z_Path ;7z

  date = %A_Year%_%A_Mon%_%A_MDay%
  Compressed_Name = %MYTEMP%ATOK_backupdat_%date%.exe
  Atok_Backup_Path = %MYTEMP%
  Atok_Dialog = ATOK バックアップツール
  ki_Path = /data/archive/windows/appdata/ATOK/

  Run, C:\Program Files\JustSystems\ATOK22\ATOK22BU.EXE
  WaitWaitWait(Atok_Dialog)
  ControlSend, Edit1, %Atok_Backup_Path%
  ControlSend, Edit1, {Enter}
  WinWaitActive, %Atok_Dialog%, はい(&Y)
  ControlSend, Button1, {Enter}
  WinWaitActive, %Atok_Dialog%, 保存が完了しました。
  Sleep, 1000
  ControlSend, Button1, {Enter}
  WinWaitActive, %Atok_Dialog%, 操作
  Send, !x                           ;閉じる
  Sleep, 2000
  Run, %7z_Path% a -sfx %Compressed_Name% %Atok_Backup_Path%ATOK_backupdat\ -p"%pass%" , , ,7zPID
  Process, WaitClose, %7zPID%
  UploadToKi(Compressed_Name, ki_Path)
}

;;;; Backup OUTLOOK
;;
Backup_Outlook(ByRef pass)
{
  global MYTEMP
  global PAGEANT_Path, kagi_Path ;SSH
  global 7z_Path ;7z

  OUTLOOK_Backup_Path = "C:\Documents and Settings\Taka16\Local Settings\Application Data\Microsoft\Outlook\"
  date = %A_Year%_%A_Mon%_%A_MDay%
  Compressed_Name = %MYTEMP%OUTLOOK_%date%.exe
  ki_Path = /data/archive/windows/appdata/outlook/

  Process, Close, OUTLOOK.EXE
  Run, %7z_Path% a -sfx %Compressed_Name% %OUTLOOK_Backup_Path% -p"%pass%" , , ,7zPID
  Process, WaitClose, %7zPID%
  UploadToKi(Compressed_Name, ki_Path)
  Send, {LAUNCH_MAIL}
}

sync(Local_Path, Server_Path)
{
  global PAGEANT_Path, kagi_Path ;SSH
  global WinSCP_Path, Ahkclass_WinScp_Dialog, Progress_Window, AhkClass_WnnScp_CheckDialog ;WinSCP
  Run, %PAGEANT_Path% %kagi_Path% -c %WinSCP_Path% ki /defaults /synchronize %Local_Path% %Server_Path%
  ; /keepuptodate
}

;;;; check PATH environment
;;
usb_env(ByRef env)
{
  global usb_bat_path
  RegRead, PATH_env, HKEY_CURRENT_USER, Environment, PATH
  StringTrimLeft, tmp, usb_bat_path, 1
  IfNotInString, PATH_env, %tmp%
  {
    If(PATH_env)
    {
      env = %usb_bat_path%
    }
    Else
    {
      ; StringTrimLeft, tmp, usb_bat_path, 1
      env = %tmp%
    }
  }
}

;;;; check path enviroment
;;
sys_env(ByRef env)
{
  global C_windows, C_system32
  RegRead, PATH_env, HKLM, SYSTEM\CurrentControlSet\Control\Session Manager\Environment, Path
  IfNotInString, PATH_env, %C_windows%
  {
    env = %env%%C_windows%
  }
  IfNotInString, PATH_env, %C_system32%
  {
    env = %env%%C_system32%
  }
}

;;;; Init Environment
;;
environment()
{
  usb_env(env)
  sys_env(env)

  if(env)
  {
    RegRead, PATH_env, HKEY_CURRENT_USER, Environment, PATH
    MsgBox, 3, 環境変数, PATH = %PATH_env%`nPATH を "%PATH_env%%env%" に書き換えますか？
    IfMsgBox, Cancel
      Return
    IfMsgBox, Yes
    {
      RegWrite, REG_EXPAND_SZ, HKEY_CURRENT_USER, Environment,PATH,%PATH_env%%env%
      EnvUpdate
    }
  }
}

;;;; Delete Script
;;
erase()
{
  global Eraser_path, AhkClass_Eraser
  Run, %Eraser_path%
  WaitWaitWait(AhkClass_Eraser)
  Sleep, 1000
  Send, !f
  Send, i
  ahkclass_dialog = ahk_class #32770
  WaitWaitWait(ahkclass_dialog)
  ControlSend, Edit1, %AScriptDir%\system\EraserPortable\emargency.ers
  ControlSend, Edit1, {Enter}
  Sleep, 1000
  Send, ^!r
  WinWait, Eraser
  WinWaitActive, Eraser
  Send, !y
}

;;;; VirusTotal
;;
VirusTotalSend(FileFullPath)
  {
    global VirusTotal_path
    Run, %VirusTotal_path% %FileFullPath%
  ; Sleep, 5000
  ; IfWinNotActive, "VirusTotal Uploader 2.0"
  ; {
  ;   ControlClick, Button1, VirusTotal Uploader 2.0, , LEFT
  ; }
  return
  }

;;;; WINDOWS KEY + H TOGGLES HIDDEN FILES
;;
  ToggleHiddenFiles()
  {
    RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden
    If HiddenFiles_Status = 2
      RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1
    Else
      RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 2
    WinGetClass, eh_Class,A
    If (eh_Class = "#32770" OR A_OSVersion = "WIN_VISTA" OR eh_Class = "TXFinder.UnicodeClass")
      send, {F5}
    Else PostMessage, 0x111, 28931,,, A
      Return

  }

;;;; WINDOWS KEY + Y TOGGLES FILE EXTENSIONS
;;
  ToggleFileExtensions()
  {
  RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt
  If HiddenFiles_Status = 1
    RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 0
  Else
    RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 1
  WinGetClass, eh_Class,A
  If (eh_Class = "#32770" OR A_OSVersion = "WIN_VISTA")
    send, {F5}
  Else PostMessage, 0x111, 28931,,, A
Return

  }

;;;; Open All Bookmark chrome folder
;;
Open_All_Bookmark(id)
{
  Run, %AScriptDir%\system\PortablePython\App\python.exe
       ,%AScriptDir%\Autohotkey\script\bookmark_trim.py -i %id%
  ;Sleep, 1000
  Loop
  {
  IfExist, %A_Temp%\tmp_bookmark
     Break
  Sleep, 500
  }

  Loop, Read, %A_Temp%\tmp_bookmark
  {
  Run, %A_LoopReadLine%
  }
FileDelete, %A_Temp%\tmp_bookmark

IfExist, %A_Temp%\tmp_bookmark
  FileDelete, %A_Temp%\tmp_bookmark
Return
}

;*********************************************************************
;***                            実験                                ***
;*********************************************************************

halt_ki()
{
  global Putty_Path, Ahk_Class_PuTTY ;PuTTY
  global PAGEANT_Path, kagi_Path ;SSH
  global PortForwarder_title, PortForwarder_path, AhkClass_PortForwarder ;PortForwarder

  Process, Exist, PAGEANT.EXE
  If(ErrorLevel==0)
  {
    Run, %PAGEANT_Path% %kagi_Path%
    WinWaitActive, Pageant: Enter Passphrase
    WinWaitClose, Pageant: Enter Passphrase
    Sleep, 2000
  }

  Process, Exist, PortForwarder.exe
  If(ErrorLevel==0)
  {
    Run, %PortForwarder_path% -N tunnel
    WinWaitActive %PortForwarder_title%
    WinWaitClose %PortForwarder_title%
  }

  Run, %PAGEANT_Path% %kagi_Path% -c %Putty_Path% -load ki_halt
}

pg_from_path(path)
{
  ;; Get program name from path.
  StringGetPos, c, path, /, R1
  If not ErrorLevel == 0 Or c == -1
  {
    StringGetPos, c, path, `\, R1
    If not ErrorLevel == 0 Or c == -1
    {
      MsgBox, Could not read path.
      Return
    }
  }
  StringTrimLeft, pg, path, c + 1
  Return pg
}

Locker()
  {
  Run, %AScriptDir%/Autohotkey/script/lock.exe ,,, lockPID
  Process, Wait, %lockPID%
  Sleep, 3000
  Send, !#l
  WinWaitActive, Enter Password Below
  Run, %A_ScriptDir%/Dos/bat/bl.bat
  Run, %AScriptDir%/Dos/bat/_TurnOffLCD.bat
  Return
  }
