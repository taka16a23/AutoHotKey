;; Xfinder
;; ==========================================================
#IfWinActive, ahk_class TXFinder.UnicodeClass
$MButton::Send, {MButton}

#v::
  Send, {F11}
  FileFullPath = %Clipboard%
  VirusTotalSend(FileFullPath)
  Return

#h::ToggleHiddenFiles()

#y::ToggleFileExtensions()

#IfWinActive
