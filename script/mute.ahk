#SingleInstance force
#Include ../dirset_script.ahk
#Include ../variable.ahk
#Include ../function.ahk


mute()
{
  SoundSet, +1, , mute
}

mute()
ExitApp
esc::ExitApp
