return

Initialize:


ScriptTitle=AutoCommander

;通常時のWorkingDirになる
HomeDir=%A_ScriptDir%\

;Migemoの辞書を指定
migemo_dict=%HomeDir%dict\migemo-dict

;Migemoの検索を行う最低キーワード文字数
MigemoMin=2

;Migemo使用時にスキップマッチングを実現する
;スキップしたい文字列の正規表現を指定する
;例:MigemoSkipMatch=[^\\]*
MigemoSkipMatch=

;デフォルトの検索モード指定文字
SMode=+

;短縮検索ワード
SearchWord_rm=readme.txt
SearchWord_ahk=?AutoHotkey|\.ahk

;ウィンドウメッセージなどで外部から実行させるコマンド
Remote_11=/o %HomeDir%

;起動時に入力するキーワード
;kw=

;リストに表示する最大の件数
ListMax=100

;リストコントロールの最大の高さ(行数)
ListMaxRows=24

FontSize=9
width=400

;非アクティブ化時に自動的に隠す
AutoHide=1

inifile=%HomeDir%FileLaunch.ini

;各ファイルのパス
indexfile=%HomeDir%path.txt
itemfile=%HomeDir%items.txt
commandfile=%HomeDir%commands.txt
scanlistfile=%HomeDir%scan.txt
subindexfile=%HomeDir%sublist.txt


;アイテムの最大項目数(これを超えた場合、自動登録項目が削除される)
ItemsMax=500

;インデックスに追加するファイルを正規表現で指定
list_ptn=\.(exe|txt|ahk|ini)$
;インデックスにフォルダを追加するか
list_dir=1
;スキャンしないフォルダを正規表現で指定
exclude_ptn=

;スキャンするアーカイブファイルの拡張子
list_archive=zip,lzh,rar,gz

;アーカイブ内のファイルの一次解凍先(最後の\なし)
archive_tmp=%temp%\FL_archive


;ドライブの検出の際に存在を無視するドライブ文字
OmitDrives=AB


;常駐モード
Persistent=1

;重複起動時の動作(1=ウィンドウ表示、2=再起動)
;RemoteCmd=1

return





/*
SetGlobalActions、SetActionsで割り当てるサブルーチンとしては、
以下のような物が用意されている。

ListPrev
	リストで前の選択項目へ
ListNext
	リストで次の選択項目へ
ListSPrev
	リストの上の項目に範囲選択しながら移動
ListSNext
	リストの下の項目に範囲選択しながら移動
ListCPrev
	リストの上の項目に移動しつつ選択状態を反転
ListCNext
	リストの下の項目に移動しつつ選択状態を反転
ListToggleSelect
	リストのフォーカス項目の選択状態を反転
SelectAll
	リストの全項目を選択

Execute
	現在の入力内容と選択ファイルで確定する
NormalMode
	インデックス検索モードに復帰
Open
	選択項目がフォルダなら展開
UpDir
	選択項目のあるフォルダや、展開中のフォルダの親フォルダを展開
SelectCommand
	コマンド選択モードに移行
SelectProgram
	プログラム選択モードに移行
SelectArg
	引数ファイル選択モードに移行

Exit
	スクリプトを終了する
Hide
	メインウィンドウを隠す
Show
	メインウィンドウを表示
ShowHide
	表示されていれば隠し、隠れていれば表示する
AutoHide
	非アクティブ化時に自動消去するようにする
NoAutoHide
	非アクティブになっても表示したままになるようにする
ToggleAutoHide
	上記を切り替える[
ShowMenu
	タスクトレイアイコンの右クリックメニューを表示

CleanUpData
	存在しないことが確認されたファイルや、上限を超えた自動登録アイテムを削除し
	インデックスをソートし直す
LoadData
	インデックス、アイテム、コマンドのデータを読み込み直す
SaveItems
	CleanUpDataを行ってからデータを保存する

*/


;システム全体で働くホットキーを割り当て
SetGlobalActions:
	Hotkey,#z,Show
return

;メインウィンドウで働くキーを割り当て
SetActions:
	Hotkey,Escape,Hide
	Hotkey,^Escape,Exit
	Hotkey,Up,ListPrev
	Hotkey,Down,ListNext
	Hotkey,^Up,ListCPrev
	Hotkey,^Down,ListCNext
	Hotkey,+Up,ListSPrev
	Hotkey,+Down,ListSNext
	Hotkey,^Space,ListToggleSelect
	Hotkey,^a,SelectAll

	
	Hotkey,~Enter,Execute
	
	Hotkey,Right,Open
	Hotkey,Left,UpDir
	Hotkey,^\,NormalMode
	Hotkey,^/,SelectCommand
	Hotkey,^.,SelectProgram
	Hotkey,^`,,SelectArg
	
	;内部コマンドへの割り当て
	Hotkey,^e,FL_CMD_e
return

/*
リスト上でのマウス操作に機能を割り当て
(右、中ボタンではファイルの選択は行われないので注意)

SetMouseAction(msg,fwkeys,label)
	msg
		0x202		;左ボタンを放した
		0x203		;左ダブルクリック
		0x205		;右ボタンを放した
		0x206		;右ダブルクリック
		0x208		;中ボタンを放した
		0x209		;中ダブルクリック
	fwkeys
		Shift=4
		Ctrl=8
		Ctrl+Shift=12
*/
SetMouseActions:
	SetMouseAction(0x203,0,"Execute")
	SetMouseAction(0x203,12,"Open")
return




;タスクトレイアイコンの右クリックメニューを追加
SetMenuItems:
Menu,Tray,Add,データ保存(&D),SaveData
Menu,Tray,Add,データ再読込(&L),LoadData
return





;タイマー実行させたいサブルーチンがあるときに記述
SetTimers:
;例:2時間ごとに、アイドル中なら全スキャン
;	SetTimer,TimerScanAll,7200000
;	SetTimer,TimerActWinAddItem,30000
return


TimerScanAll:
	If A_TimeIdlePhysical>60000
		ScanAll()
return



getProcessHandle(pid,mode=0x001F0FFF){
	return DllCall("OpenProcess",UInt,mode,UInt,0,UInt,pid,UInt)
}
releaseProcessHandle(hProcess){
	DllCall("psapi\CloseProcess","Int",hProcess)
}


;;;;
;; getPEName(pid)
;;   任意プロセスの実行ファイルパスを取得
;; 引数
;;   pid  対象プロセスID
;; 返り値
;;   取得したパス
;;;;
getPEName(pid){
	hModule=0
	dwNeed=0
	l=0
	max:=VarSetCapacity(s,256,0)
	hProcess:=getProcessHandle(pid,0x410)	;ぬるいアクセス権でないと拒否られることがある
	if(DllCall("psapi\EnumProcessModules","Int",hProcess,"Int*",hModule,"Int",4,"UInt*",dwNeed,"Int")<>0){
		l:=DllCall("psapi\GetModuleFileNameExA","Int",hProcess,"Int",hModule,"Str",s,"Int",max,"Int")
	}
	releaseProcessHandle(hProcess)
	return s
}

TimerActWinAddItem:
	WinGetTitle,t,A
	If(InStr(t,"\") && FileExist(t)){		;タイトルバーがファイルパスだったら
		AddItem(t)
	}else{
		WinGet,pid,pid,A
		AddItem(getPEName(pid))
	}
return
