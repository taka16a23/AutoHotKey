/*
内部コマンドを追加したりする
*/
return


/*
拡張子による条件分けなどの複雑な動作を行いたい場合は、
以下のようにスクリプトを記述する
*/
FL_CMD_e:
	If E in .jpeg,.jpg,.bmp
		Run,mspaint "%P%"
	else If E in .rtf,.doc
		Run,"C:\Program Files\Windows NT\Accessories\wordpad.exe" "%P%"
	else
		Run,notepad "%P%"
return


FL_CMD_scan:
	depth=-1
	if A1 is Integer
	{
		depth=%A1%
		pos:=StrLen(A1)+1
		StringTrimLeft,A,A,%pos%
		
	}
	if A=
		str=%Folder%
	else
	{
		StringRight,Chr,A,1
		if Chr<>\
			str=%A%\
		else
			str=%A%
	}
	UpdateIndex(str,Scan(str,list_ptn,list_dir,exclude_ptn,depth))
return

FL_CMD_addscan:
	if A<>
	{
		StringRight,Chr,A,1
		if Chr<>\
			AddScanList(GetRemovablePath(A . "\") . A_Tab)
		else
			AddScanList(GetRemovablePath(A) . A_Tab)
	}else
		AddScanList(GetRemovablePath(Folder) . A_Tab)
return

FL_CMD_o:
	if Hide=Hide
		GoSub,Show
	if A<>
	{
		StringRight,Chr,A,1
		if Chr<>\
			OpenDir(A . "\")
		else
			OpenDir(A)
	}else
		OpenDir(Folder)
return

FL_CMD_a:
	if A<>
	{
		AddItem(A . A_Tab . GetRemovablePath(P))
	}else{
		AddItem(N . A_Tab . GetRemovablePath(P))
	}
return

FL_CMD_addfile:
	SetVar(A)
	AddItem(N . A_Tab . GetRemovablePath(P))
return

FL_CMD_del:
	DeleteItem(GetSelectedItem())
return

FL_CMD_C:
	if A<>
		Clipboard=%A%
	else
		Clipboard=%MN%
return

FL_CMD_set:
	StringGetPos,pos,A,=
	if pos<>-1
	{
		StringLeft,str,A,%pos%
		StringTrimLeft,str1,A,% pos+1
		%str%=%str1%
	}
return

FL_CMD_setkeyword:
	if Hide=Hide
	{
		Gosub,Show
	}
	SetKeyword(A)
return


FL_CMD_exit:
	Gosub,Exit
return

FL_CMD_reload:
	Reload
return

FL_CMD_save:
	Gosub,SaveData
return

FL_CMD_load:
	Gosub,LoadData
return

FL_CMD_clean:
	Gosub,CleanupData
return

FL_CMD_scanall:
	ScanAll()
return

