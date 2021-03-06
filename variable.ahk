;; VARIABLE
;; ==========================================================
;;;; ENVIRONMENT
;;
C_windows = `;%A_WinDir%
C_system32 = `;%A_WinDir%\system32
usb_bat_path = `;%AScriptDir%\Dos\bat

EnvSet, PATH, %usb_bat_path%%C_windows%%C_system32%

;;;; Date
;;
date_ymd = %A_Year%_%A_Mon%_%A_MDay%

;;;; MYTEMP
;;
MYTEMP = D:\MYTEMP\

;;;; Icon
;;
suspend_icon = %AScriptDir%/Autohotkey/icon/suspend.ico

;;;; Report Path
;;
BB_Path = %AScriptDir%\bb\%A_OSVersion%_%A_UserName%_%A_YYYY%_%A_MM%_%A_DD%

;;;; Chrome
;;
Chrome_Path            = C:\Program Files\Google\Chrome\Application\chrome.exe
Chrome_cmdline         =  --disable-ipv6
                         ,--purge-memory-button
                         ,--disk-cache-dir="T:\chrome"
                         ,--new-tab-page
AhkClass_Chrome        = ahk_class Chrome_WidgetWin_1
Chrome_ProcName        = chrome.exe
Chrome_Title_Extension = Google Chrome
Chrome_ClassNN_Omnibox = Chrome_OmniboxView1

;;;; Default Browser (Google Chrome)
;;
Default_Browser                 := Chrome_Path " " Chrome_cmdline
AhkClass_Default_Browser        := AhkClass_Chrome
Default_Browser_Title_Extension := Chrome_Title_Extension
Default_Browser_ProcName        := Chrome_ProcName

;;;; Default Mailer (Outlook)
;;
Outlook_AhkClass                 = ahk_class rctrl_renwnd32
Default_Mailer_AhkClass         := Outlook_AhkClass
Outlook_ClassNN_appo_Subject     = RichEdit20WPT6
Outlook_ClassNN_appo_Location    = REComboBox20W1
Outlook_ClassNN_appo_StartTime   = RichEdit20WPT7
Outlook_ClassNN_appo_EndTime     = RichEdit20WPT9
Outlook_ClassNN_appo_Alldayevent = Button5
Outlook_ClassNN_appo_Reminder    = RichEdit20W1

;;;; Sleipnir
;;
Sleipnir_Path                  = %AScriptDir%\Internet\sleipnir\bin\Sleipnir.exe
AhkClass_Sleipnir              = ahk_class MainWindow
Sleipnir_ClassNN_RSS_Left_Tree = TTreeViewEx1
Sleipnir_ClassNN_url_bar       = Edit2

;;;; RSS
;;
RSS_Path     = %Sleipnir_Path%
AhkClass_RSS = %AhkClass_Sleipnir%
RSS_ClassNN  = %Sleipnir_ClassNN_RSS_Left_Tree%


;;;; Daily
;;
Daily_Path     = D:\Daily\sdf.xls
Pass_Box       = bosa_sdm_XL9
Daily_AhkClass = ahk_class XLMAIN


;;;; Xfinder
;;
Xfinder_Path      = %AScriptDir%\Dos\bat\f.bat
Ahk_Class_Xfinder = ahk_class TXFinder.UnicodeClass


;;;; PuTTY
;;
Putty_Path      = %AScriptDir%\Internet\putty\putty.exe
Ahk_Class_PuTTY = ahk_class PuTTY


;;;; SSH
;;
PAGEANT_Path = %AScriptDir%\Internet\putty\PAGEANT.EXE
kagi_Path    = %AScriptDir%\Security\Password\kagi\kagi.ppk


;;;; WinSCP
;;
;; WinSCP の dialog の path は "/" だと error になるので "\" を使うこと
WinSCP_Path                 = %AScriptDir%\Internet\winscp\WinSCP.exe
WinSCP_PID                  = WinSCP.exe
Ahkclass_WinScp_Dialog      = ahk_class TCopyDialog
Progress_Window             = ahk_class TProgressForm
Ahk_Class_WinScp            = ahk_class TScpCommanderForm
AhkClass_WnnScp_CheckDialog = ahk_class TSynchronizeChecklistDialog

;;;; Sync Directory
;;
Local_emacsd  = %AScriptDir%/Office/Emacs/.emacs.d/
Server_emacsd = /home/t1/.emacs.d/
;; global Local_Usb, Server_usb ;usb
Local_usb     = %AScriptDir%
Server_usb    = /data/USB/
;; global Local_sdf, Server_sdf ;sdf
Local_sdf     = D:\Daily\
Server_sdf    = /data/archive/life/dialy/sdf/

;;;; 7z
;;
7z_Path            = C:\Program Files\7-Zip\7z.exe

;;;; Secunia PSI
;;
Secunia_Path       = C:\Program Files\Secunia\PSI\psi.exe
AhkClass_Secunia   = ahk_class Afx:00400000:0

;;;; UpdateChecker
;;
UpdateChecker_Path = %AScriptDir%\Security\UpdateChecker.exe

;;;; CLCL
;;
clcl_path          = %AScriptDir%\Office\CLCL\CLCL.exe

;;;; SetCaretColor
;;
SetCaretColor_path = %AScriptDir%\system\setcaretcolor\SetCaretColor.exe

;;;; Imecur
;;
ImePointer_path    = %AScriptDir%\system\ImePointer\ImePointer.exe

;;;; Eraser
;;
Eraser_path        = %AScriptDir%\system\EraserPortable\EraserPortable.exe
AhkClass_Eraser    = ahk_class Eraser.{73F5BCF6-F36C-11d2-BBF3-00105AAF62C4}

;;;; Everest
;;
Everest_path       = %AScriptDir%\Analyze\everest\everest.exe

;;;; Virus Total
;;
VirusTotal_path    = %AScriptDir%\Security\AntiVirus\VirusTotalUpload.exe

;;;; Wireshark
;;
AhkClass_WireShark = ahk_class gdkWindowToplevel

;;;; cmd.exe
;;
AhkClass_Cmd       = ahk_class ConsoleWindowClass

;;;; Potable Python
;;
Python_path        = %AScriptDir%\system\PortablePython\App\python.exe
Pythonw_path        = %AScriptDir%\system\PortablePython\App\pythonw.exe

;;;; PortForwarder
;;
PortForwarder_title    = PortForwarder
PortForwarder_path     = %AScriptDir%\Internet\portforwarder\PortForwarder.exe
AhkClass_PortForwarder = ahk_class #32770

;;;; UnplugDrive
;;
UnplugDrive_path  = %AScriptDir%\system\UnplugDrive.exe
UnplugDrive_exe  := pg_from_path(UnplugDrive_path)
UnplugDrive_title = UnplugDrive

;;;; Unlocker
;;
Unlocker_path     = %AScriptDir%\system\unlocker\unlocker.exe
Unlocker_exe     := pg_from_path(unlocker_path)
Unlocker_title    = Unlocker
Unlocker_sys_path = %AScriptDir%\system\unlocker\UnlockerDriver5.sys
Unlocker_sys     := pg_from_path(unlocker_sys_path)

;;;; usb_ejecter
;;
usb_ejecter_path  = %AScriptDir%/Autohotkey/script/usb_ejecter.exe
usb_ejecter_exe  := pg_from_path(usb_ejecter_path)
usb_ejecter_title = usb_ejecter
