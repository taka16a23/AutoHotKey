/*
Migemoの辞書ファイルから不要な語句や動作に支障を来す語句を削除する	by流行らせるページ管理人
*/

;辞書ファイルのパス
dict=%A_ScriptDir%\dict\migemo-dict
;辞書ファイルのバックアップ名
back=%A_ScriptDir%\dict\migemo-dict.bak
;見出し語(仮名の奴)の長さの上限(これ以上長い語句は完全にスキップされる)
kw_maxlen=16
;禁止するパターン
ng_ptn=m/[\^\$\.\|\(\)\[\]\*\+\?\{\}\/\\]/k

hModuleRegExp:=DllCall("LoadLibrary","Str","BREGEXP.DLL")
VarSetCapacity(RegExpMsg,256)
pRegExp=0

SetBatchLines,-1

FileMove,%dict%,%back%
FileRead,list,*t %A_ScriptDir%\dict\migemo-dict.bak
Size:=StrLen(list)
VarSetCapacity(NL,size)
VarSetCapacity(NW,20000)
read=0
Loop,Parse,List,`n
{
	read:=read+StrLen(A_LoopField)+1
	Progress,% 100*(read/Size)
	Sleep,0
	StringSplit,words,A_LoopField,%A_Tab%
	if(StrLen(words1)>kw_maxlen){
		continue
	}
	NW=%words1%
	add=0
	Loop,%words0%
	{
		if A_Index>1
		{
			t:=words%A_Index%
			ep:=&t+StrLen(t)
			if(DllCall("BREGEXP.DLL\BMatch", "Str",ng_ptn, "Str",t, "UInt",ep ,"UIntP",pRegExp, Str,RegExpMsg, "Cdecl UInt")<=0){
				word:=words%A_Index%
				NW=%NW%%A_Tab%%word%
				add=1
			}
		}
	}
	if add=1
		NL=%NL%%NW%`n
}
FileAppend,%NL%,*%dict%


DllCall("BREGEXP.DLL\BRegFree","Int",pRegExpScanPattern)
DllCall("FreeLibrary", "UInt", hModuleRegExp)


