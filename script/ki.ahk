#SingleInstance force
#Include ../dirset_script.ahk
#Include ../variable.ahk
#Include ../function.ahk


ki()
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
    Process, Wait, PortForwarder.exe
    Sleep, 5000
  }
    
  Run, %PAGEANT_Path% %kagi_Path% -c %Putty_Path% -load ki
  Return
}
ki()
ExitApp
esc::ExitApp
