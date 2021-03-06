/*
統合アーカイバDLL呼び出し	by流行らせるページ管理人

●概要
以下のような関数がある

・解凍
ArcExtract(path,mask,dest,opt="")

・圧縮
ArcCompress(type,dest,files,opt="")

・アーカイブファイルに格納されたファイルの情報を取得
ArcOpen(path)
ArcClose()
ArcFind(pattern="")
ArcGetName()
ArcGetCompressedSize()
ArcGetOriginalSize()
ArcGetRatio()
ArcGetTime()
ArcGetAttr()
ArcGetMethod()
ArcGetCRC()

・内部用ユーティリティ関数
ArcCmd(type,cmd,outsize=1024)
ArcGetType(path)

●関数説明
ArcExtract(path,mask,dest,opt="")
	アーカイブファイルを解凍する
	
	引数
		path
			アーカイブファイルのパスを指定
		mask
			解凍するファイルのアーカイブ内でのパスを指定
			ワイルドカードに対応
		dest
			解凍先フォルダパス
			最後は「\」で終わらせること
		opt
			DLLに渡すコマンドラインに追加するオプション
	返り値
		処理結果文字列。

ArcCompress(type,dest,files,opt="")
	アーカイブファイルを作成する
	
	引数
		type
			圧縮形式を表す文字列
		dest
			作成する圧縮ファイル名
		files
			圧縮するファイルのパス、マスク
		opt
			DLLに渡すコマンドラインに追加するオプション
	返り値
		処理結果文字列。

ArcCmd(type,cmd,outsize=1024)
	DLLの関数(UnLHA32.dllなら「Unlha()」)を呼び出してコマンドラインを実行する
	
	引数
		type
			圧縮形式を表す文字列
		cmd
			コマンドライン
		outsize
			処理結果文字列のために確保する容量
	返り値
		処理結果文字列。
		outsizeで指定した容量より大きかった場合、容量に収まるように切りつめられる

ArcGetType(path)
	DLLに問い合わせてファイルの圧縮形式を取得する
	
	引数
		path
			チェックするファイルのパス
	返り値
		対応するDLLがあった場合、圧縮形式を表す文字列

ArcOpen(path)
	ArcFind等で格納ファイルの情報を得るためにアーカイブファイルを開く。
	
	引数
		path
			開くアーカイブファイルのパス
	返り値
		成功した場合、DLLに渡すアーカイブハンドルが返される
	詳細
		使用するDLLは自動的に判別される
		同時に開いていられるのはスクリプト全体で1つだけである。

ArcClose()
	ArcOpenで開いたアーカイブを閉じ、リソースを解放する

ArcFind(pattern="")
	現在開いているアーカイブファイル内のファイルを検索する
	
	引数
		pattern
			ファイルマスク(パスやワイルドカード)
			省略するか前回と同じにすると、「次を検索」になる

ArcGetName()
	ArcFindで最後に見つけたファイルのアーカイブ内でのパス・ファイル名を取得
	
	返り値
		ファイルの名前(フォルダ内の物の場合はパス付き)

ArcGetCompressedSize()
	ArcFindで最後に見つけたファイルの圧縮後のサイズを取得
	
	返り値
		ファイルの圧縮後のサイズを示す整数

ArcGetOriginalSize()
	ArcFindで最後に見つけたファイルの圧縮前のサイズを取得
	
	返り値
		ファイルの元サイズを示す整数

ArcGetRatio()
	ArcFindで最後に見つけたファイルの圧縮率を取得
	
	返り値
		1000*ArcGetCompressedSize/ArcGetOriginalSizeに相当する整数

ArcGetTime()
	ArcFindで最後に見つけたファイルの更新日時を取得
	
	返り値
		AutoHotkeyのタイムスタンプ形式での日時

ArcGetAttr()
	ArcFindで最後に見つけたファイルの属性を取得
	
	返り値
		以下の物を連結した文字列
			R 読み取り専用
			A アーカイブ
			S システムファイル
			H 隠しファイル
			D ディレクトリ
			V ボリュームラベル(あまり使われない)
			P パスワード付き(7-zip.dll等のみ対応)

ArcGetMethod()
	ArcFindで最後に見つけたファイルの圧縮方法を取得
	
	返り値
		圧縮方法を表す文字列

ArcGetCRC()
	ArcFindで最後に見つけたファイルのCRCチェックサムを取得
	
	返り値
		CRCを示す整数



●サンプル1
#ファイルの圧縮を行う
ArcCompress("zip","F:\test\test.zip","")

●サンプル2
#引数で渡されたファイルの内容を表示して解凍
sample.ahk参照

*/



;DLLごとに代表的な対応拡張子を一つ列挙。形式の自動判別に使う。
ArcExts=zip,lzh,cab,tar,rar,gca,ish,bga

;拡張子とライブラリ名、API関数名のプレフィクスの対応を記述
;ArcLibName_* = DLLファイル名
;ArcLibPrefix_* = API関数名のプレフィクス
;ArcLibCompOpt_* = 圧縮時にコマンドラインに追加するオプション
;ArcLibExtrOpt_* = 解凍時にコマンドラインに追加するオプション
ArcLibName_zip=7-zip32.dll
ArcLibPrefix_zip=SevenZip
ArcLibName_jar=7-zip32.dll
ArcLibPrefix_jar=SevenZip
ArcLibName_xpi=7-zip32.dll
ArcLibPrefix_xpi=SevenZip
ArcLibName_nar=7-zip32.dll
ArcLibPrefix_nar=SevenZip
ArcLibName_7z=7-zip32.dll
ArcLibPrefix_7z=SevenZip
ArcLibCompOpt_zip=-tzip

ArcLibName_lzh=UnLha32
ArcLibPrefix_lzh=Unlha

ArcLibName_cab=CAB32.dll
ArcLibPrefix_cab=Cab

ArcLibName_tar=TAR32.dll
ArcLibPrefix_tar=Tar
ArcLibName_gz=TAR32.dll
ArcLibPrefix_gz=Tar
ArcLibName_z=TAR32.dll
ArcLibPrefix_z=Tar
ArcLibName_bz2=TAR32.dll
ArcLibPrefix_bz2=Tar
ArcLibName_cpio=TAR32.dll
ArcLibPrefix_cpio=Tar
ArcLibName_rpm=TAR32.dll
ArcLibPrefix_rpm=Tar
ArcLibName_deb=TAR32.dll
ArcLibPrefix_deb=Tar
ArcLibName_tgz=TAR32.dll
ArcLibPrefix_tgz=Tar
ArcLibName_taz=TAR32.dll
ArcLibPrefix_taz=Tar
ArcLibName_tbz=TAR32.dll
ArcLibPrefix_tbz=Tar
ArcLibName_ar=TAR32.dll
ArcLibPrefix_ar=Tar

ArcLibName_rar=UnRAR32.dll
ArcLibPrefix_rar=Unrar

ArcLibName_gca=UnGCA32.dll
ArcLibPrefix_gca=UnGCA

ArcLibName_ish=AISH32.dll
ArcLibPrefix_ish=Aish

ArcLibName_bga=BGA32.dll
ArcLibPrefix_bga=Bga



ArcExtract(path,mask,dest,opt=""){
	global
	local ext
	SplitPath,path,,,ext
	if ArcLibName_%ext%=
	{
		ext:=ArcGetType(path)
	}
	return ArcCmd(ext,"x " . ArcLibExtrOpt_%ext% . " " . opt . " """ . path . """ """ . dest . """ """ . mask . """")
}
ArcCompress(type,dest,files,opt=""){
	if(FileExist(dest)){
		FileDelete,%dest%
	}
	return ArcCmd(type,"a " . ArcLibCompOpt_%type% . " " . opt . " """ . dest . """ """ . files . """")
}

ArcCmd(type,cmd,outsize=1024){
	global
	local out,size,arcmyhwnd
	Process,Exist
	WinGet,arcmyhwnd,id,ahk_pid %ErrorLevel% ahk_class AutoHotkey
	size:=VarSetCapacity(out,outsize)
	DllCall(ArcLibName_%type% . "\" . ArcLibPrefix_%type%, UInt,arcmyhwnd, Str,cmd, Str,out, UInt,size, Int)
	return out
}

ArcGetType(path){
	global
	Loop,Parse,ArcExts,`,
	{
		if(DllCall(ArcLibName_%A_LoopField% . "\" . ArcLibPrefix_%A_LoopField% . "CheckArchive", Str,path, UInt,0, Int)){
			return A_LoopField
		}
	}
	return
}


ArcOpen(path){
	global
	local ext,arcmyhwnd
	
	if hArc<>
		return
	Process,Exist
	WinGet,arcmyhwnd,id,ahk_pid %ErrorLevel% ahk_class AutoHotkey
	
	
	SplitPath,path,,,ext
	if ArcLibName_%ext%=
	{
		ext:=ArcGetType(path)
	}
	
	ArcLibPrefix:=ArcLibName_%ext% . "\" . ArcLibPrefix_%ext%
	
	
	hArcLib:=DllCall("LoadLibrary",Str,ArcLibName_%ext%,UInt)
	hArc:=DllCall(ArcLibPrefix . "OpenArchive",UInt,arcmyhwnd,Str,path,UInt,0,UInt)
	return,hArc
}

ArcClose(){
	global
	DllCall(ArcLibPrefix . "CloseArchive",UInt,hArc)
	DllCall("FreeLibrary",UInt,hArcLib)
	hArc=
	hArcLib=
	ArcLastPattern=
}

ArcFind(pattern=""){
	global
	if ((pattern="")||(pattern=ArcLastPattern)){
		return DllCall(ArcLibPrefix . "FindNext",UInt,hArc,UInt,0,Int)
	}else{
		ArcLastPattern=%pattern%
		return DllCall(ArcLibPrefix . "FindFirst",UInt,hArc,Str,pattern,UInt,0,Int)
	}
}
ArcGetName(){
	global
	size:=VarSetCapacity(buf,256)
	DllCall(ArcLibPrefix . "GetFileName",UInt,hArc,Str,buf,Int,size,Int)
	return buf
}
ArcGetCompressedSize(){
	global
	return DllCall(ArcLibPrefix . "GetCompressedSize",UInt,hArc,UInt)
}
ArcGetOriginalSize(){
	global
	return DllCall(ArcLibPrefix . "GetOriginalSize",UInt,hArc,UInt)
}
ArcGetRatio(){
	global
	return DllCall(ArcLibPrefix . "GetRatio",UInt,hArc,UShort)
}
ArcGetMethod(){
	global
	size:=VarSetCapacity(buf,256)
	DllCall(ArcLibPrefix . "GetMethod",UInt,hArc,Str,buf,Int,size,Int)
	return buf
}
ArcGetTime(){
	global
	local time,time2
	time=19700101000000
	time2:=DllCall(ArcLibPrefix . "GetWriteTime",UInt,hArc,UInt)
	if(time2<>0xFFFFFFFF){
		EnvAdd,time,%time2%,Seconds
		return time
	}else{
		return
	}
}

ArcGetCRC(){
	global
	return DllCall(ArcLibPrefix . "GetCRC",UInt,hArc,UInt)
}

ArcGetAttr(){
	global
	local attr,res
	attr:=DllCall(ArcLibPrefix . "GetAttribute",UInt,hArc,UInt)
	res=
	if(attr<>0xFFFFFFFF){
		if(attr&1){
			res=%res%R
		}
		if(attr&32){
			res=%res%A
		}
		if(attr&4){
			res=%res%S
		}
		if(attr&2){
			res=%res%H
		}
		if(attr&16){
			res=%res%D
		}
		if(attr&8){
			res=%res%V
		}
		if(attr&64){
			res=%res%P
		}
		return res
	}else{
		return
	}
}
