#SingleInstance force
#Include ../dirset_script.ahk
#Include ../variable.ahk
#Include ../function.ahk
#Include ../../Lib/windowutils.ahk

;;;; Monthly
;;
Monthly1()
{
  global

  Run, %UpdateChecker_Path%
  Sleep, 5000
  Wait_Close_Page("FileHippo.com - 無料ソフトウェアをダウンロードする", Default_Browser_Title_Extension)

  ;; sdf.xls
  sdf()
}

monthly1()
ExitApp
esc::ExitApp