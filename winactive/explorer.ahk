;; Explorer
;; ==========================================================
#IfWinActive ahk_class CabinetWClass
;;;; Virus Total
;;
#v::
  FileFullPath := get_explorer_selection()
  VirusTotalSend(FileFullPath)
  Return

;;;; Create New File
;;
f3::Send !fwt

;;;; Create New Folder
;;
f4::Send !fwf

;;;; Open cmd on current directory
;;
#c::OpenCmdInCurrent()

;;;; WINDOWS KEY + H TOGGLES HIDDEN FILES
;;
#^h::ToggleHiddenFiles()

;;;; WINDOWS KEY + Y TOGGLES FILE EXTENSIONS
;;
#y::ToggleFileExtensions()

;;;; get full path
;;
#f::get_explorer_selection()



#IfWinActive
