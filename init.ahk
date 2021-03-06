;; INIT
;; ==========================================================
#SingleInstance

global mclean_path ;mclean
global clcl_path ; CLCL
global SetCaretColor_path ;SetCaretColor


;;;; 環境変数構築
;;
KeyMapChange()
;;environment()
; Run, %Python_path% %AScriptDir%\Autohotkey\script\myenv.py -c ,, Hide
Run, %Pythonw_path% %AScriptDir%\Lib\.pylib\portable_env.py
; Run, %Python_path% %AScriptDir%\Lib\.pylib\portable_env.py

init(mclean_path) ;mclean
init(clcl_path) ;clcl
init(SetCaretColor_path) ;SetCaretColor

kbdacc(pgpath)
{
SplitPath, pgpath, psname
psname := pg_from_path(pgpath)
Process, Exist, %psname%
If not (ErrorLevel)
  {
    Run, %pgpath%, ,Hide
  }
}
kbdacc(jbdacc_path) ;kbdacc


imepointer(pgpath)
{
  psname := pg_from_path(pgpath)
  Process, Exist, %psname%
  If not (ErrorLevel)
  {
   Run, %pgpath%, %AScriptDir%\system\ImePointer\
  }
}

imepointer(ImePointer_path)

; init(ImePointer_path) ;imecur

; PATH=%PATH%`;%AScriptDir%/Dos/bat
