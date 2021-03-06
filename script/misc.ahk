; outlook bussiness address to home
;::
  Loop, 5{

  Send, ^a
  sleep, 200
  Send, ^c
  ClipWait
  text%A_index% = %ClipBoard%
  Send, {del}
  Send, {tab}
  }
;  msgbox, %text1% %text2% %text3% %text4% %text5%

  ; postalcode insert "-" if not have
  IfNotInString, text1, -
  {
    StringLeft, pLeft, text1, 3
    StringRight, pRight, text1, 4
  }
  text1 = %pLeft%-%pRight%

  Loop, 7{
  send, +{tab} 
  sleep, 100 
}
  Sleep, 300
  Send, {enter}
  Send, {down}
  Send, {down}
  Send, {enter}
  sleep, 300
  Send, +{tab}

  Loop, 5{
  tx := text%A_index%
  Clipboard = %tx%
  Send, ^v
  sleep, 200
  Send, {tab}
}
  Send, !r
  Sleep, 100
  Send, {space}
  return
