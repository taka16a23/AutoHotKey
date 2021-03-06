#Singleinstance force
autoscan()
{
InputBox, time, Scan Interval, Default 60 seconds,,235,110,,,,,60
time *= 1000
    If ErrorLevel = 0
    {
      loop
      {
	Run, C:\WINDOWS\twain_32\escndv\escndv.exe
        Sleep, %time% - 10000
      }
    }
    Else
    {
      Return
    }
  }
autoscan()
esc::ExitApp
