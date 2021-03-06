#SingleInstance Off
#NoTrayIcon
#include %A_ScriptDir%\CommonArc.ahk

Gosub,Initialize

;INIファイルの読み込み
IniRead,posX,%inifile%,Window,X,0
IniRead,posY,%inifile%,Window,Y,0
IniRead,inisettings,%inifile%,Settings,VarNames,`,
Loop,Parse,inisettings,`,
{
	if A_LoopField=
		continue
	val:=%A_LoopField%
	IniRead,%A_LoopField%,%inifile%,Settings,%A_LoopField%,%val%
}


;引数の解釈
Loop,%0%
{
	StringSplit,a,%A_Index%,=,"
	if a0=1
		%a1%=1
	else if a0=2
		%a1%=%a2%
	else if a0=3
	{
		TransForm,a3,Deref,%a3%
		%a1%=%a3%
	}
}





;検索モード指定文字を列挙
SModeChars=+`:->@?


;遠隔操作用
RemoteMsg=0x444
Remote_1=Show
Remote_2=Reload
Remote_3=Exit
if ForceCmd<>
{
	InitCmd=%ForceCmd%
	RemoteCmd=%ForceCmd%
}


;常駐用
if(Persistent){
	Hide=Hide
	DetectHiddenWindows,On
	IniRead,hwnd,%inifile%,Remote,hwnd,0
	IfWinExist,ahk_id %hwnd% ahk_class AutoHotkey
	{
	;重複起動時
		if RemoteCmd<>
		{
			if RemoteCmd is not integer
			{
				IniWrite,%RemoteCmd%,%inifile%,Remote,Cmd_0
				RemoteCmd=0
			}
			PostMessage,%RemoteMsg%,%RemoteCmd%
		}
		ExitApp		;OnExit設定してないので即死
	}
	;操作用にウィンドウハンドルを保存しておく
	Process,Exist
	WinGet,hwnd,id,ahk_pid %ErrorLevel% ahk_class AutoHotkey
	IniWrite,%hwnd%,%inifile%,Remote,hwnd

	DetectHiddenWindows,Off
}



;GUIウィンドウ生成
Gui,Font,S%FontSize%
Gui,Margin,0,0
Gui,add,Edit,vKW gMatch w%width%,%kw%
Gui,+Delimiter`n
Gui,add,ListBox,Multi -E0x00000200 w400 h300 vLst Delimiter`n,
GuiControl,Move,Lst,h0
Gui,+AlwaysOnTop +ToolWindow
Gui,Show,%Hide% x%posX% y%posY% AutoSize,%ScriptTitle%
Mode=N
DMode=0
SetWorkingDir,%HomeDir%

;タスクトレイのメニュー
Menu,Tray,NoStandard
Menu,Tray,Add,表示(&S),Show
Menu,Tray,Default,表示(&S)
Gosub,SetMenuItems
Menu,Std,Standard
Menu,Tray,Add,&AutoHotkey,:Std
Menu,Tray,Add,終了(&X),Exit
Menu,Tray,Icon

;操作割り当て関連
Gui,+LastFound
WinGet,myhwnd,id
Hotkey,IfWinActive,ahk_id %myhwnd%
GoSub,SetActions
Hotkey,IfWinActive
GoSub,SetGlobalActions
GoSub,SetMouseActions
GoSub,SetTimers
OnExit,Exit
OnMessage(0x6,"OnActivate")
OnMessage(0x20A,"OnWheel")
OnMessage(RemoteMsg,"OnRemote")

;正規表現用
hModuleRegExp:=DllCall("LoadLibrary","Str","BREGEXP.DLL")
FileRegExp=m/^(((\w)\:)?.*\\)?(([^\\]+?)(\.[^\\]+)?\\?)$/k
pRegExpFile=0
VarSetCapacity(RegExpMsg,256)


;ドライブ情報取得
DriveGet,str,List,FIXED
DriveGet,AutoDelDrives,List,RAMDISK
AutoDelDrives=%str%%AutoDelDrives%


Gosub,LoadData
DeadList=


if InitCmd<>
{
	if InitCmd is integer
	{
		OnRemote(InitCmd)
	}else{
		ExecCommand("",InitCmd)
	}
}
return



















OnRemote(w){
	global
	local label,cmd
	label:=Remote_%w%
	if(IsLabel(label)){
		Gosub,%label%
	}else IfInString,label,/
	{
		ExecCommand("",label)
	}else{
		IniRead,cmd,%inifile%,Remote,Cmd_%w%
		ExecCommand("",cmd)
	}
}




Match:
	SetBatchLines,-1
	GuiControlGet,KW,,KW
	
	;未入力、「/」「*」のときの処理
	if KW=
	{
		if(DMode){
			GuiControl,-Redraw,Lst
			GuiControl,,Lst,`n
			GuiControl,,Lst,%DList%
			GuiControl,Choose,Lst,1
			GuiControl,+Redraw,Lst
			LList=%DList%
		}else{
			GuiControl,,Lst,`n
		}
		if(Mode="C"){
			Gosub,NormalMode
		}
		GoSub,SetWinSize
		LKW=
		return
	}else if((KW="/") && (Mode<>"C")){
		Gosub,SelectCommand
	}else if((KW="*") && (!DMode)){
		NList=
		Loop,Parse,Items,`n,`r
		{
			If A_Index<=ListMax
				NList=%NList%%A_LoopField%`n
			else
				break
		}
		GuiControl,-Redraw,Lst
		GuiControl,,Lst,`n
		GuiControl,,Lst,%NList%
		Gui,+LastFound
		SendMessage,0x185,0,-1,ListBox1
		GuiControl,Choose,Lst,1
		GuiControl,+Redraw,Lst
		GoSub,SetWinSize
		LKW=*
		LList=%Items%`n%List%`n%SubList%
		return
	}
	
	;最後がモード移行文字の場合は除去
	StringRight,Chr,KW,1
	if Chr in /,\,>,<
	{
		if((KW<>"/") || (Mode<>"C"))
			StringTrimRight,KW,KW,1
	}
	
	;「 /」を含む場合、「/」以降を除去、コマンド文字列で絞り込まれるのを防ぐ
	StringGetPos,pos,KW,%A_Space%/
	if pos<>-1
	{
		StringLeft,KW,KW,% pos +1
	}
	
	;結果、全く同じ内容なら絞り込まない
	if KW=%LKW%
		return
	
	
	StringSplit,kws,KW,%A_SPACE%
	if Mode=C
	{
		kws0=1
		LList=%Commands%
	}else{
		if LKW=
			pos=-1
		else
			StringGetPos,pos,KW,%LKW%
		If pos=0
		{
			;前回のキーワードに追記された場合、そのキーワードのみで絞り込む
			if kws%kws0%=
			{
				;最後にスペースがあった場合、その前のキーワード(プレフィクス付きのみ)
				kws0--
				kws1:=kws%kws0%
				kws2=
				kws0=2
				StringLeft,Chr,kws1,1
				IfNotInString SModeChars,%Chr%
					return
			}else{
				kws1:=kws%kws0%
				kws0=1
			}
		}else{
			;それ以外の場合、検索対象リストを適宜設定
			if(DMode){
				LList=%DList%
			}else{
				LList=%Items%`n%List%`n%SubList%
			}
		}
	}
	searched=0
	VarSetCapacity(NList,VarSetCapacity(LList))
	Loop,%kws0%{
		k:=kws%A_Index%
		StringLeft,Chr,K,1
		;検索モード指定文字の判別
		IfInString SModeChars,%Chr%
		{
			StringTrimLeft,k,k,1
			if Chr=@
			{
				if A_Index=%kws0%
					continue
				k:=SearchWord_%k%
				StringLeft,Chr,K,1
				IfInString SModeChars,%Chr%
					StringTrimLeft,k,k,1
				else
					Chr=%SMode%
			}
		}else{
			Chr=%SMode%
		}
		if k =
			continue
		NList=
		
		;検索モード指定文字で分岐
		if Chr=+
		{
			;通常絞り込み
			searched=1
			Loop,PARSE,LList,`n,`r
				ifInString,A_LoopField,%k%	
					NList=%NList%%A_LoopField%`n
		}else if Chr=`:
		{
			if(StrLen(k)<MigemoMin)
				continue
			MigemoSet(k)
			searched=1
			if A_Index=%kws0%
			{
				;一番後ろのキーワードの場合
				c=0
				Loop,PARSE,LList,`n,`r
				{
					if A_LoopField<>
					{
						;リスト上限を超えた分は、検査せずに追加(表示はされない)
						if((c>=ListMax)||(MigemoMatch(A_LoopField))){
							c++
							NList=%NList%%A_LoopField%`n
						}
					}
				}
			}else{
				Loop,PARSE,LList,`n,`r
					if A_LoopField<>
						if(MigemoMatch(A_LoopField))
							NList=%NList%%A_LoopField%`n
			}
		}else if Chr=?
		{
			;正規表現(最後の語句意外)
			if A_Index=%kws0%
				continue
			searched=1
			ptn=m/%k%/ik
			pRegExp=0
			Loop,PARSE,LList,`n,`r
				if A_LoopField<>
				{
					tmp=%A_LoopField%
					ep:=&tmp+StrLen(tmp)
					if(DllCall("BREGEXP.DLL\BMatch", "Str",ptn, "UInt",&tmp, "UInt",ep, "UIntP",pRegExp, "Str",RegExpMsg, "Cdecl UInt")>0)
						NList=%NList%%A_LoopField%`n
				}
		}else if Chr=>
		{
			;名前部分のみの検索
			searched=1
			ptn=m/[^\\]*%k%[^\\]*\\?$/ik
			pRegExp=0
			Loop,PARSE,LList,`n,`r
				if A_LoopField<>
				{
					tmp=%A_LoopField%
					ep:=&tmp+StrLen(tmp)
					if(DllCall("BREGEXP.DLL\BMatch", "Str",ptn, "UInt",&tmp, "UInt",ep, "UIntP",pRegExp, "Str",RegExpMsg, "Cdecl UInt")>0)
						NList=%NList%%A_LoopField%`n
				}
		}else if Chr=-
		{
			;除外絞り込み(最後の語句意外)
			if A_Index=%kws0%
				continue
			
			searched=1
			Loop,PARSE,LList,`n,`r
				if A_LoopField<>
					ifNotInString,A_LoopField,%k%
						NList=%NList%%A_LoopField%`n
		}
		LList=%NList%
	}
	if NList=
	{
		if KW=/
			NList=%LList%
		else if searched=0
			return
	}
	
	;リスト表示
	GuiControl,-Redraw,Lst
	GuiControl,,Lst,`n
	StringGetPos,pos,NList,`n,L%ListMax%
	if pos>0
		StringLeft,NList,NList,%pos%
	GuiControl,,Lst,%NList%
	GoSub,SetWinSize
	GuiControl,Choose,Lst,1
	GuiControl,+Redraw,Lst
	LKW=%KW%
	NList=
return

SetWinSize:
	Gui,+LastFound
	SendMessage,0x1A1,0,0,ListBox1
	s=%ErrorLevel%
	SendMessage,0x18B,0,0,ListBox1
	if ErrorLevel>%ListMaxRows%
		s*=ListMaxRows
	else
		s*=ErrorLevel
	GuiControl,Move,Lst,h%s%
	Gui,Show,AutoSize NA %Hide%
return

/*
検索用
*/
MigemoSet(q){
	global hMigemo,MigemoPattern,pRegExpMigemo
	if hMigemo=
		GoSub,MigemoOpen
	if(pRegExpMigemo)
		DllCall("BREGEXP.DLL\BRegFree","UInt",pRegExpMigemo)
	pRegExpMigemo=0
	MigemoPattern:="m/" . DllCall("migemo.dll\migemo_query" ,"UInt",hMigemo ,"Str",q ,"Str") . "/ki"
}
MigemoMatch(t){
	global MigemoPattern,pRegExpMigemo,MigemoMsg
	return DllCall("BREGEXP.DLL\BMatch", "Str",MigemoPattern, "UInt",&t, "UInt",&t+StrLen(t) ,"UIntP",pRegExpMigemo, Str,MigemoMsg, "Cdecl int")>0
}
MigemoOpen:
	hModuleMigemo:=DllCall("LoadLibrary","Str","migemo.dll")
	hMigemo:=DllCall("migemo.dll\migemo_open" ,"Str",migemo_dict ,"UInt")
	if(MigemoSkipMatch){
		DllCall("migemo.dll\migemo_set_operator", "UInt",hMigemo, Int,5, Str,MigemoSkipMatch)
	}
return

MigemoClose:
	if(hMigemo){
		DllCall("migemo.dll\migemo_close" ,"UInt",hMigemo)
		DllCall("BREGEXP.DLL\BRegFree","Int",pRegExpMigemo)
		DllCall("FreeLibrary", "UInt", hModuleMigemo)
		hMigemo=
		MigemoPattern=
	}
return





/*
データ管理
*/

/*
スキャンを行う
引数
	dir
		対象フォルダのパス(最後に「\」を付ける)
	list_ptn
		対象正規表現	省略時は全ファイル
	listdir
		フォルダをリストに含めるか	省略時は含める
	exclude_ptn
		サブフォルダ検索の除外フォルダパターン	省略時は除外しない
	recurse
		サブフォルダをたどる深度	0で再帰検索しない、-1で無限
	残りは、再帰呼び出しの時に内部的に使用される
戻り値
	ファイルのリスト
*/
ScanArchive(path,list_ptn,pRegExpScanPattern){
	global RegExpMsg
	list=
	if(ArcOpen(path)){
		Loop{
			if(ArcFind("*")=0){
				t:=ArcGetAttr()
				ifInString t,D
					continue
				t:=ArcGetName()
				ep:=&t+StrLen(t)
				
				if(DllCall("BREGEXP.DLL\BMatch", "Str",list_ptn, "Str",t, "UInt",ep ,"IntP",pRegExpScanPattern, "Str",RegExpMsg, "Cdecl UInt")>0){
					List=%List%%path%|\%t%`n
				}
			}else{
				break
			}
		}
		ArcClose()
	}
	return,list
}

Scan(dir,list_ptn="",listdir=1,exclude_ptn="",recurse=-1,pRegExpScanPattern=0,pRegExpExcdir=0){
	global RegExpMsg,list_archive
	List=
	if pRegExpScanPattern=0
	{
		root=1
		List=%dir%`n
		if list_ptn<>
			list_ptn=m/%list_ptn%/ik
		else
			list_ptn=m/./ik
		DllCall("BREGEXP.DLL\BMatch", "Str",list_ptn, "Str",root, "UInt",&root+1 ,"IntP",pRegExpScanPattern, "Str",RegExpMsg, "Cdecl UInt")
		if exclude_ptn<>
			exclude_ptn=m/%exclude_ptn%/ik
		else if exclude_ptn=*
			recurse=0
	}
	ifInString,dir,|
	{
		List:=ScanArchive(dir,list_ptn,pRegExpScanPattern)
	}else{
		Loop,%dir%*,1
		{
			IfInString,A_LoopFileAttrib,D
			{
				if listdir=1
					List=%List%%A_LoopFileLongPath%\`n
				if recurse<>0
				{
					if exclude_ptn<>
					{
						t=%A_LoopFileLongPath%\
						ep:=&t+StrLen(t)
						if(DllCall("BREGEXP.DLL\BMatch", "Str",exclude_ptn, "Str",t, "UInt",ep ,"UIntP",pRegExpExcdir, Str,RegExpMsg, "Cdecl UInt")>0){
							continue
						}
					}
					List:=List . Scan(A_LoopFileLongPath . "\",list_ptn,listdir,exclude_ptn,recurse-1,pRegExpScanPattern,pRegExpExcdir)
				}
			}else{
				t=%A_LoopFileLongPath%
				ep:=&t+StrLen(t)
				if(DllCall("BREGEXP.DLL\BMatch", "Str",list_ptn, "Str",t, "UInt",ep ,"IntP",pRegExpScanPattern, "Str",RegExpMsg, "Cdecl UInt")>0){
					List=%List%%A_LoopFileLongPath%`n
				}
				SplitPath,A_LoopFileLongPath,,,t
				If t in %list_archive%
				{
					List:=List . ScanArchive(A_LoopFileLongPath,list_ptn,pRegExpScanPattern)
				}
			}
		}
	}
	if root=1
	{
		DllCall("BREGEXP.DLL\BRegFree","Int",pRegExpScanPattern)
		if(pRegExpExcdir)
			DllCall("BREGEXP.DLL\BRegFree","Int",pRegExpExcdir)
		
		StringLeft,str,dir,3
		s:=GetRemovablePath(str)
		if s<>str
		{
			StringReplace,List,List,%str%,%s%,A
		}
	}
	return List
}

/*
	pがリムーバブルメディア上のパスだった場合、ドライブ文字をシリアルなどの識別情報に置換して返す
*/
GetRemovablePath(p){
	global
	local t,str,f,s
	StringMid,t,p,2,1
	if t=`:
	{
		StringLeft,str,p,3
		DriveGet,t,Type,%str%
		if t in Removable,CDROM
		{
			f=%A_FormatInteger%
			DriveGet,s,Serial,%str%
			SetFormat,Integer,H
			s:=0x100000000 | s
			SetFormat,Integer,%f%
			StringTrimLeft,s,s,3
			StringUpper,s,s
			StringLeft,f,p,1
			DRIVE_%s%=%f%
			s=#%s%
			if t=CDROM
			{
				DriveGet,l,Label,%str%
				s=%l%%s%
			}
			StringTrimLeft,str,p,1
			return	s . str
		}
	}
	return p
}

ScanAll(){
	global ScanList,list_ptn,list_dir,exclude_ptn
	NList=
	Loop,Parse,ScanList,`n,`r
	{
		if A_LoopField=
			continue
		StringSplit,ary,A_LoopField,%A_Tab%
		if ary1<>
		{
			dir=%ary1%
			if ary2<>
				ptn=%ary2%
			else
				ptn=%list_ptn%
			
			if ary3<>
				ld=%ary3%
			else
				ld=%list_dir%
			
			if ary4<>
				ep=%ary4%
			else
				ep=%exclude_ptn%
			
			if ary5<>
				dep=%ary5%
			else
				dep=-1
			
			if ary7<>
				Next=%ary7%
			else
				Next=0
			
			if Next<%A_Now%
			{
				UpdateIndex(dir,Scan(GetRealPath(dir),ptn,ld,ep,dep))
				if ary6<>
				{
					StringLeft,C,ary6,1
					StringTrimLeft,span,ary6,1
					Next=%A_Now%
					EnvAdd,Next,%span%,%C%
					NList=%NList%%ary1%%A_Tab%%ary2%%A_Tab%%ary3%%A_Tab%%ary4%%A_Tab%%ary5%%A_Tab%%ary6%%A_Tab%%Next%`n
					continue
				}
			}
		}
		NList=%NList%%A_LoopField%`n
	}
	ScanList=%NList%
}

ScanAll:
	ScanAll()
return

UpdateIndex(dir,newlist=""){
	global List
	p:=GetRemovablePath(dir)
	Sort,List,U
	StringGetPos,pos1,list,%p%
	if pos1<>-1
	{
		StringGetPos,pos2,list,%p%,R
		StringGetPos,pos2,list,`n,,%pos2%
		StringLeft,NList,list,%pos1%
		StringTrimLeft,NList2,list,% pos2+1
		List=%NList%%newlist%%NList2%
	}else if newlist<>
	{
		List=%List%%newlist%
		Sort,List,U
	}
}

AddItem(str){
	global Items
	VarSetCapacity(NItems,StrLen(Items)+StrLen(str)+1)
	NItems=%str%`n
	Loop,Parse,Items,`n,`r
	{
		If A_LoopField<>%str%
			If A_LoopField<>
				NItems=%NItems%%A_LoopField%`n
	}
	Items=%NItems%
}

GuiDropFiles:
	Loop,Parse,A_GuiEvent,`n,`r
	{
		FileGetAttrib,attr,%A_LoopField%
		IfInString,attr,D
		{
			If(GetKeyState("Ctrl")){
				MsgBox,% A_LoopField . "\"
				UpdateIndex(A_LoopField . "\",Scan(A_LoopField . "\",list_ptn,list_dir,exclude_ptn,depth))
				return
			}
		}
		SetVar(A_LoopField)
		StringRight,Chr,P,1
		If(GetKeyState("Shift")){
			InputBox,Str,アイテム名入力,%A_LoopField%,,,,,,,,%N%
		}else{
			Str=%N%
		}
		AddItem(Str . A_Tab . GetRemovablePath(P))
	}
return

DeleteItem(str){
	global Items
	VarSetCapacity(NItems,StrLen(Items))
	NItems=
	Loop,Parse,Items,`n,`r
	{
		If A_LoopField<>%str%
			If A_LoopField<>
				NItems=%NItems%%A_LoopField%`n
	}
	Items=%NItems%
}

AddScanList(str){
	global ScanList
	VarSetCapacity(NScanList,StrLen(Items)+StrLen(str)+1)
	NScanList=
	Loop,Parse,ScanList,`n,`r
	{
		If A_LoopField<>%str%
			If A_LoopField<>
				NScanList=%NScanList%%A_LoopField%`n
	}
	ScanList=%NScanList%%str%`n
}

;インデックスをソートし、重複と死亡項目を取り除く
CleanUpIndex(){
	global List,DeadList
	Sort,List,U
	Sort,DeadList,U
	NList=
	Loop,Parse,List,`n,`r
	{
		item=%A_LoopField%
		found=0
		Loop,Parse,DeadList,`n,`r
		{
			if A_LoopField>%item%
			{
				break
			}else if A_LoopField=%item%
			{
				found=1
			}
		}
		if found=0
			NList=%NList%%item%`n
	}
	List=%NList%
}

;アイテムリストから死亡項目を取り除き、上限を超えた自動登録項目を削除
CleanUpItems(){
	global Items,DeadList,ItemsMax
	Sort,DeadList,U
	NList=
	;死亡項目の削除
	Loop,Parse,Items,`n,`r
	{
		item=%A_LoopField%
		found=0
		Loop,Parse,DeadList,`n,`r
		{
			if A_LoopField>%item%
			{
				break
			}else if A_LoopField=%item%
			{
				found=1
			}
		}
		if found=0
			NList=%NList%%item%`n
	}
	Items=%NList%
	cnt=0
	;残すべき自動登録項目数の取得
	Loop,Parse,Items,`n,`r
	{
		If A_Index<=%ItemsMax%
		{
			if A_LoopField<>
				IfNotInString,A_LoopField,%A_Tab%
					cnt++
		}else{
			IfInString,A_LoopField,%A_Tab%
				cnt--
		}
	}
	NList=
	;上限を超えた自動登録項目の削除
	Loop,Parse,Items,`n,`r
	{
		if A_LoopField=
			continue
		else IfNotInString,A_LoopField,%A_Tab%
		{
			if cnt<1
			{
				continue
			}else if A_LoopField<>
			{
				NList=%NList%%A_LoopField%`n
				cnt--
			}
		}else
			NList=%NList%%A_LoopField%`n
	}
	Items=%NList%
}

/*
CleanUpScanList(){
	global ScanList,DeadList,ScanListMax
}
*/

CleanUpData:
	CleanUpIndex()
	CleanUpItems()
;	CleanUpScanList()
	DeadList=
return

LoadData:
FileRead,List,*t %indexfile%
FileRead,Items,*t %itemfile%
FileRead,Commands,*t %commandfile%
FileRead,ScanList,*t %scanlistfile%
FileRead,SubList,*t %subindexfile%
return

SaveData:
	Gosub,CleanUpData
	FileDelete,%indexfile%
	FileAppend,%List%,%indexfile%
	FileDelete,%itemfile%
	FileAppend,%Items%,%itemfile%
	FileDelete,%scanlistfile%
	FileAppend,%ScanList%,%scanlistfile%
	
	Gui,+LastFound
	WinGetPos,posX,posY
	IniWrite,%posX%,%inifile%,Window,X
	IniWrite,%posY%,%inifile%,Window,Y

	Loop,Parse,inisettings,`,
	{
		if A_LoopField=
			continue
		val:=%A_LoopField%
		IniWrite,%val%,%inifile%,Settings,%A_LoopField%
	}
return

ClearKeyword:
	LKW=
	GuiControl,,KW
return

SetKeyword(k){
	global myhwnd
	LKW=
	GuiControl,,KW,%k%
	l:=StrLen(k)
	SendMessage,0xB1,%l%,%l%,Edit1,ahk_id %myhwnd%
}

GetKeyword(){
	GuiControlGet,kw,,KW
	return kw
}

Reset:
	LList=
	LKW=
	GuiControl,,KW
	GoSub,MigemoClose
	GoSub,NormalMode
return


AddDeadList(p){
	global DeadList
	DeadList=%DeadList%%p%`n
	SplitPath(p . "a",drive,dir,name,ext,noext)
	d=%dir%
	Loop{
		if(FileExist(dir))
			break
		ifNotInString,dir,\
			return
		SplitPath(d,drive,dir,name,ext,noext)
		d=%dir%
	}
	UpdateIndex(d)
}


GetSelectedPath(item="",NeedExist=0){
	global Mode,DPath,DeadList,DMode,AutoDelDrives
	if item=
		GuiControlGet,item,,Lst
	if item<>
	{
		if(DMode){
			return GetRealPath(DPath . item,NeedExist)
		}else{
			StringSplit,str,item,%A_Tab%
			item:=str%str0%
			if(FileExist(GetRealPath(item,NeedExist))){
				return item
			}else if(str0=1){
				ifNotInString,item,|
				{
					StringLeft,Chr,item,1
					IfInString,AutoDelDrives,%Chr%
						AddDeadList(item)
					return
				}else{
					return item
				}
			}
		}
	}
}

GetSelectedItem(NeedExist=0){
	global DeadList,AutoDelDrives,DMode,DPath
	GuiControlGet,item,,Lst
	if(DMode){
		return GetRealPath(DPath . item,NeedExist)
	}else IfNotInString,item,%A_Tab%
	{
		if(!FileExist(GetRealPath(item,NeedExist))){
			IfNotInString,item,|
			{
				StringLeft,Chr,item,1
				IfInString,AutoDelDrives,%Chr%
					AddDeadList(item)
			}
		}
	}
	return item
}

/*
「<Serial>:\」や「<Label#Serial>:\」のようなパスが与えられたとき、
当該メディアが挿入されているかをチェックし、見つかればパスを修正して返す。
NeedExistが真の時は、メディアがセットされていなければセットするように促すメッセージを表示する
見つからなければ、空の文字列を返す。
*/
GetRealPath(p,NeedExist=0){
	global
	local t,s0,s1,s2,s3,str,pos,f,dl,d
	f=%A_FormatInteger%
	
	;アーカイブファイル内のパス
	IfInString,p,|
	{
		StringSplit,t,p,|
		t1:=GetRealPath(t1,NeedExist)
		if(NeedExist){
			;実在のパスが欲しいとき
			StringRight,t,t2,1
			StringTrimLeft,t2,t2,1
			If t<>\
			{
				;ファイルなら解凍
				FileCreateDir,%archive_tmp%
				ArcExtract(t1,t2,archive_tmp . "\","-aoa")
				t=%archive_tmp%\%t2%
				if(FileExist(t)){
					return,archive_tmp . "\" . t2
				}else{
					return,t1 . "|\" . t2
				}
			}else{
				;ファイル以外は無理
				return,t1 . "|\" . t2
			}
		}
		return,t1 . "|" . t2
	}
	
	StringMid,t,p,2,1
	;普通のパス
	if t in \,`:
		return p
	
	StringLeft,t,p,1
	;「"C:\Program Files\aaa\bbb.exe" ddd」のようなコマンドライン
	if t="
		return p
	
	StringGetPos,pos,p,:\
	;「:\」がないのでフルパスじゃない
	if pos=-1
		return p
	
	StringMid,str,p,1,%pos%
	StringGetPos,pos,str,%A_Space%
	;「:\」の前にスペースが来ているので、フルパスがあるのは引数部分
	if pos<>-1
		return p
	
	StringSplit,s,str,#
	;シリアルに対応するドライブを得る
	d:=DRIVE_%s2%
	if d<>
	{
		;取得済みの場合
		DriveGet,s3,Serial,%d%:\
		SetFormat,Integer,H
		s3:=0x100000000 | s3
		SetFormat,Integer,%f%
		StringTrimLeft,s3,s3,3
		StringUpper,s3,s3
		if s3=%s2%
		{
			;シリアルが一致した場合
			StringReplace,p,p,%str%,%d%
			return p
		}else{
			;不一致の場合、取得したシリアルを記録
			DRIVE_%s2%=
			DRIVE_%s3%=%d%
		}
	}
	;ラベルの有無でタイプを決定しドライブリストを取得
	if s1=
		DriveGet,dl,List,Removable
	else
		DriveGet,dl,List,CDROM
	Loop,Parse,dl,,%OmitDrives%
	{
		DriveGet,s3,Serial,%A_LoopField%:\
		if s3<>
		{
			SetFormat,Integer,H
			s3:=0x100000000 | s3
			SetFormat,Integer,%f%
			StringTrimLeft,s3,s3,3
			StringUpper,s3,s3
			DRIVE_%s3%=%A_LoopField%
			if s3=%s2%
			{
				StringReplace,p,p,%str%,%A_LoopField%
				return p
			}
		}
	}
	;シリアル一致ドライブ見つからず
	if(NeedExist){
		Gui,+OwnDialogs
		if(s1){
			MsgBox,1,メディアが見つかりません,ラベル%s1%(シリアル%s2%)のメディアをセットしてください
		}else{
			MsgBox,1,メディアが見つかりません,シリアル%s2%のメディアをセットしてください
		}
		Gui,-OwnDialogs
		;メディアがセットされたらしいときは再帰呼び出しに丸投げ
		IfMsgBox,OK
		{
			return GetRealPath(p)
		}
	}
	return ""
}

SGetInt(pStruct,offset){
	DllCall("RtlMoveMemory", UIntP,val, UInt,pStruct+offset, Int,4)
	return val
}

SplitPath(target, ByRef Drive, ByRef Dir, ByRef Name, ByRef Ext, ByRef NoExt){
	global
	local t,te,m,start,length,pArray1,pArray2
	t:=&target
	te:=t+StrLen(target)
	
	if(target=""){
		Drive=
		Dir=
		Name=
		Ext=
		NoExt=
		return
	}
	m:=DllCall("BREGEXP.DLL\BMatch", Str,FileRegExp, UInt,t, UInt,te, UIntP,pRegExpFile, Str,msg, "Cdecl int")
	if(m>0){
		pArray1:=SGetInt(pRegExpFile,32)
		pArray2:=SGetInt(pRegExpFile,36)
		
		start:=SGetInt(pArray1,4)+1-t
		length:=SGetInt(pArray2,4)+1-t-start
		StringMid,Dir,target,%start%,%length%
		
		start:=SGetInt(pArray1,12)+1-t
		length:=SGetInt(pArray2,12)+1-t-start
		StringMid,Drive,target,%start%,%length%
		
		start:=SGetInt(pArray1,16)+1-t
		length:=SGetInt(pArray2,16)+1-t-start
		StringMid,Name,target,%start%,%length%
		
		start:=SGetInt(pArray1,20)+1-t
		length:=SGetInt(pArray2,20)+1-t-start
		StringMid,NoExt,target,%start%,%length%
		
		start:=SGetInt(pArray1,24)+1-t
		length:=SGetInt(pArray2,24)+1-t-start
		StringMid,Ext,target,%start%,%length%
	}
	return m
}

ClearVar:
	P=
	D=
	Drive=
	N=
	E=
	Name=
	H=
	M=
	MN=
	Folder=
	C=
	Loop,%A0%
		A%A_Index%=
	A0=
	A=
	
return

SetVar:
	Gosub,ClearVar
	SetVar(GetRealPath(GetSelectedPath()))
	C=%Clipboard%
	K:=GetKeyword()
	
	Gui,+LastFound
	SendMessage,0x190,0,0,ListBox1
	if ErrorLevel>1
	{
		M=
		MN=
		ControlGet,TList,List,,ListBox1
		Loop,Parse,TList,`n,`r
		{
			SendMessage,0x187,% A_Index-1,0,ListBox1
			if ErrorLevel<>0
			{
				str:=GetSelectedPath(A_LoopField)
				if str<>
				{
					M:=M . """" . str . """" . A_Space
					MN:=MN . str . "`n"
				}
			}
		}
		StringTrimRight,M,M,1
	}else{
		M="%P%"
	}
	
	if(DMode)
		H=%DPath%
	else
		H=
	FileGetAttrib,attr,%P%
	IfInString,attr,D
		Folder=%P%
	else if(DMode)
		Folder=%h%
	else
		Folder=%D%
return
SetVar(fname){
	global
	P=%fname%
	SplitPath(fname,Drive,D,N,E,Name)
}


/*
cにコマンドIDを、argsに引数を指定
cが空の場合、argsをコマンド+引数の形式で解釈する
以下の2つは同じ動作
ExecCommand("o","C:\Program Files")
ExecCommand("","/o C:\Program Files")

cにはコマンドリストに記述するコマンド定義を指定することもできる
*/
ExecCommand(c,args=""){
	global
	local label,str,cmdline,winstate,workingdir
	str=
	if c=
		if args<>
		{
			StringTrimLeft,args,args,1
			StringGetPos,pos,args,%A_Space%
			if pos<>-1
			{
				StringLeft,c,args,%pos%
				StringTrimLeft,args,args,% pos+1
			}else{
				c=%args%
			}
		}
		else
			return
	A=%args%
	aa=%A%
	Transform,A,Deref,%A%
	StringSplit,A,args,%A_Space%
	IfInString,c,%A_Tab%
	{
		;コマンドアイテムの場合
		StringSplit,str,c,%A_Tab%
		if str%str0%=
		{
			;内部コマンドの場合
			StringTrimLeft,c,str1,1
			label=FL_CMD_%c%
			if(IsLabel(label)){
				if A<>
					AddItem("/" . c . A_Space . aa)
				GoSub,%label%
			}
			return
		}
	}else{
		;コマンド名のみの場合
		Loop,Parse,Commands,`n,`r
		{
			;入力されたコマンドを検索
			StringSplit,str,A_LoopField,%A_Tab%
			if str1=/%c%
			{
				if A<>
					AddItem("/" . c . A_Space . aa)
				break
			}
		}
		;見つからなかったら内部コマンドを検索
		if((str1<> "/" . c)||(str%str0%="")){
			label=FL_CMD_%c%
			if(IsLabel(label)){
				if A<>
					AddItem("/" . c . A_Space . aa)
				GoSub,%label%
			}
			return
		}
	}
	cmdline:=str%str0%
	str0--
	if str0>1
		workingdir:=str%str0%
	TransForm,workingdir,Deref,%workingdir%
	str0--
	if str0>1
		winstate:=str%str0%
	TransForm,cmdline,Deref,%cmdline%
	cmdline:=GetRealPath(cmdline,1)
	Run,%cmdline%,%workingdir%,%winstate% UseErrorLevel
}



Execute:
	if(DllCall("imm32.dll\ImmGetCompositionStringA", UInt,DllCall("imm32.dll\ImmGetContext",UInt,id, UInt), UInt,8, UInt,0, UInt,0, UInt)>0){
		return
	}
	kw:=GetKeyword()
	if(kw="\"){
		Gosub,NormalMode
		Gosub,ExitDir
		return
	}else if(Mode="C"){
		args=
		Gui,+LastFound
		SendMessage,0x19F,0,0,ListBox1
		if ErrorLevel=0
		{
			StringTrimLeft,kw,kw,1
			StringGetPos,pos,kw,%A_Space%
			if pos<>-1
			{
				StringLeft,cmd,kw,%pos%
				StringTrimLeft,args,kw,% pos+1
			}else{
				cmd=%kw%
			}
		}else{
			cmd:=GetSelectedItem()
		}
		ExecCommand(cmd,args)
		Gosub,NormalMode
		return
	}else if(Mode="P"){
		extargs:=A_Space . """" . P . """"
		if(DMode){
			item:=GetSelectedPath()
		}else{
			item:=GetSelectedItem()
		}
		AddItem(item)
		Gosub,NormalMode
	}else if(Mode="A"){
		extargs:=A_Space . """" . GetRealPath(GetSelectedPath(),1) . """"
		item=%targetItem%
		Gosub,NormalMode
	}else{	;D,N
		StringRight,Chr,kw,1
		if(Chr="\"){
			Gosub,Open
			return
		}else if(Chr="/"){
			Gosub,SelectCommand
			return
		}else if(Chr="<"){
			Gosub,SelectArg
			return
		}else if(Chr=">"){
			Gosub,SelectProgram
			return
		}else if((kw="..") && (DMode)){
			GoSub,UpDir
			return
		}else{
			StringLeft,Chr,kw,1
			if(Chr="/"){
				kw=a %kw%
			}
			StringGetPos,pos,kw,%A_Space%/
			pos+=2
			if pos<>1
			{
				;コマンドで実行
				Gosub,SetVar
				StringTrimLeft,kw,kw,%pos%
				StringGetPos,pos,kw,%A_Space%
				if pos<>-1
				{
					StringLeft,cmd,kw,%pos%
					pos++
					StringTrimLeft,args,kw,%pos%
				}else{
					cmd=%kw%
					args=
				}
				ExecCommand(cmd,args)
				Gosub,ClearKeyword
				return
			}else{
				;通常実行
				extargs=
				item:=GetSelectedItem()
				AddItem(item)
			}
		}
	}
	;アイテムテキストを展開
	StringSplit,str,item,%A_Tab%
	cmdline:=str%str0%
	if(cmdline=""){
		return
	}
	str0--
	if str0>0
		workingdir:=str%str0%
	
	str0--
	TransForm,workingdir,Deref,%workingdir%
	if str0>0
		winstate:=str%str0%
	;コマンドラインの特殊モード指定
	StringLeft,Chr,cmdline,1
	if(Chr="/"){
		;コマンドとして実行
		StringGetPos,pos,cmdline,%A_Space%
		StringTrimLeft,args,cmdline,% pos+1
		StringMid,cmd,cmdline,2,% pos-1
		ExecCommand(cmd,args)
		GoSub,ClearKeyword
		return
	}else if(Chr="*"){
		;変数を展開してから実行
		StringTrimLeft,cmdline,cmdline,1
		TransForm,cmdline,Deref,%cmdline%
	}
	cmdline:=GetRealPath(cmdline,1)
	Run,%cmdline%%extargs%,%workingdir%,%winstate% UseErrorLevel
	GoSub,ClearKeyword
return







/*
モード遷移
*/

SetTitle(title){
	Gui,+LastFound
	WinSetTitle,%title%
}

ExitDir:
	if(DMode){
		SetWorkingDir,%HomeDir%
		DPath=
		DList=
		DMode=0
		SetTitle(ScriptTitle)
	}
return

NormalMode:
	Mode=N
	if(!DMode)
		SetTitle(ScriptTitle)
	GoSub,ClearKeyword
return

SelectCommand:
	Mode=C
	Gosub,SetVar
	if P<>
		SetTitle("Command for:" . P)
	else
		SetTitle("Command")
	SetKeyword("/")
return

SelectProgram:
	Mode=P
	Gosub,SetVar
	SetTitle("Program for:" . P)
	Gosub,ClearKeyword
return

SelectArg:
	Mode=A
	targetItem:=GetSelectedItem(1)
	Gosub,SetVar
	SetTitle("Argument for:" . P)
	Gosub,ClearKeyword
return


/*
ディレクトリモード関連
*/
Open:
	item:=GetSelectedPath()
	if(item){
		OpenDir(item)
	}
return

OpenDir(dir){
	global
	local len,fn,c
	dir:=GetRealPath(dir,1)
	ifInString,dir,|
	{
		StringRight,c,dir,1
		if c=\
		{
			DMode=1
			SetWorkingDir,%archive_tmp%
			DPath=%dir%
			DList:=ListArchive(dir)
			LList=%DList%
			GoSub,ClearKeyword
			GoSub,SetWinSize
			SetTitle(dir)
		}
	}else{
		FileGetAttrib,attr,%dir%
		StringLen,len,dir
		ifInString,attr,D
		{
			DMode=1
			SetWorkingDir,%dir%
			DPath=%dir%
			DList=
			Loop,%dir%*,1,0
			{
				StringTrimLeft,fn,A_LoopFileLongPath,%len%
				IfInString,A_LoopFileAttrib,D
				{
					DList=%DList%%fn%\`n
				}else{
					DList=%DList%%fn%`n
				}
			}
			LList=%DList%
			GoSub,ClearKeyword
			GoSub,SetWinSize
			SetTitle(dir)
		}else{
			SplitPath,dir,,,ext
			If ext in %list_archive%
			{
				OpenDir(dir . "|\")
			}
		}
	}
}
ListArchive(path){
	StringSplit,p,path,|
	StringTrimLeft,p2,p2,1
	StringLen,len,p2
	ptn=%p2%*
	list=
	list_d=
	if(ArcOpen(p1)){
		Loop{
			if(ArcFind(ptn)=0){
				t:=ArcGetName()
				StringTrimLeft,t,t,%len%
				ifInString,t,\
				{
					StringGetPos,pos,t,\,,1
					if(pos>0){
						StringLeft,t,t,% pos+1
						list_d=%list_d%%t%`n
					}
				}else{
					list=%list%%t%`n
				}
			}else{
				break
			}
		}
		ArcClose()
		list=%list%%list_d%
		Sort,list,U
	}else{
		ListVars
	}
	return,list
}

UpDir:
	if(DMode){
		str=%DPath%
	}else{
		str:=GetSelectedPath()
		if str=
			return
	}
	SetVar(str)
	OpenDir(D)
return








/*
ウィンドウ表示
*/
Exit:
	if A_ExitReason<>
	{
		Gui,Hide
		Gosub,SaveData
	}
	FileRemoveDir,%archive_tmp%,1
	ExitApp
return

Reload:
	Reload
return

Show:
	Hide=
	Gui,+LastFound
	WinGetPos,pX,pY
	Gui,Show
	Gosub,ExitDir
	Gosub,NormalMode
	ControlFocus,Edit1
return

Hide:
	if(Persistent){
		Hide=Hide
		Gui,Hide
		GoSub,Reset
	}else{
		Gosub,Exit
	}
return

ShowHide:
	if Hide=Hide
		GoSub,Show
	else
		GoSub,Hide
return

OnActivate(w,l,m,h){
	global AutoHide,Hide
	if((A_Gui=1)&&((w&0xFFF)=0)&(AutoHide=1)){
		Gosub,Hide
	}else{
		GuiControl,Move,Lst,h0
		Gui,Show,AutoSize NA %Hide%
	}
}

AutoHide:
	AutoHide=1
return
NoAutoHide:
	AutoHide=0
return
ToggleAutoHide:
	AutoHide=!AutoHide
return


GuiClose:
	Hide=Hide
	GoSub,Reset
return

ShowMenu:
	Menu,Tray,Show
return

/*
マウス操作登録用
*/
OnWheel(l,w,m,h){
	If((A_Gui=1)&&(A_GuiControl<>"ListBox1")){
		Gui,+LastFound
		SendMessage,%m%,%l%,%w%,ListBox1
		return 0
	}
}

SetMouseAction(msg,fwkeys,label){
	global
	fwkeys+=0
	msg+=0
	Mouse_%msg%_%fwkeys%=%label%
	OnMessage(msg,"MouseFunc")
}

MouseFunc(w,l,m,h){
	global
	local label
	if(A_GuiControl="Lst"){
		m+=0
		w:=w&12
		if(IsLabel(Mouse_%m%_%w%)){
			label:=Mouse_%m%_%w%
			GoSub,%label%
		}
	}
}

/*
キー操作用
*/
ListPrev:
	Gui,+LastFound
	SendMessage,0x19F,0,0,ListBox1
	if ErrorLevel=0
		ControlSend,ListBox1,{End}
	else
		ControlSend,ListBox1,{Up}
return

ListNext:
	Gui,+LastFound
	SendMessage,0x19F,0,0,ListBox1
	pos:=ErrorLevel+1
	SendMessage,0x18B,0,0,ListBox1
	if ErrorLevel=%pos%
		ControlSend,ListBox1,{Home}
	else
		ControlSend,ListBox1,{Down}
return


ListSPrev:
	ControlSend,ListBox1,+{Up},ahk_id %myhwnd%
return

ListSNext:
	ControlSend,ListBox1,+{Down},ahk_id %myhwnd%
return


SelectAll:
	Gui,+LastFound
	SendMessage,0x185,1,-1,ListBox1
return

ListToggleSelect:
	Gui,+LastFound
	SendMessage,0x19F,0,0,ListBox1
	pos=%ErrorLevel%
	SendMessage,0x187,%pos%,0,ListBox1
	SendMessage,0x185,% !ErrorLevel,%pos%,ListBox1
return
ListCPrev:
	Gui,+LastFound
	SendMessage,0x19F,0,0,ListBox1
	pos:=ErrorLevel-1
	if pos>=0
	{
		SendMessage,0x19E,%pos%,0,ListBox1
		SendMessage,0x187,%pos%,0,ListBox1
		
		SendMessage,0x185,% !ErrorLevel,%pos%,ListBox1
	}
return

ListCNext:
	Gui,+LastFound
	SendMessage,0x19F,0,0,ListBox1
	pos:=ErrorLevel+1
	SendMessage,0x18B,0,0,ListBox1
	if pos<ErrorLevel
	{
		SendMessage,0x19E,%pos%,0,ListBox1
		SendMessage,0x187,%pos%,0,ListBox1
		SendMessage,0x185,% !ErrorLevel,%pos%,ListBox1
	}
return


#Include %A_ScriptDir%\FL_Settings.ahk
#Include %A_ScriptDir%\FL_Commands.ahk
