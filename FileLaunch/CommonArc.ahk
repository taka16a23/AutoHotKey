/*
�����A�[�J�C�oDLL�Ăяo��	by���s�点��y�[�W�Ǘ��l

���T�v
�ȉ��̂悤�Ȋ֐�������

�E��
ArcExtract(path,mask,dest,opt="")

�E���k
ArcCompress(type,dest,files,opt="")

�E�A�[�J�C�u�t�@�C���Ɋi�[���ꂽ�t�@�C���̏����擾
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

�E�����p���[�e�B���e�B�֐�
ArcCmd(type,cmd,outsize=1024)
ArcGetType(path)

���֐�����
ArcExtract(path,mask,dest,opt="")
	�A�[�J�C�u�t�@�C�����𓀂���
	
	����
		path
			�A�[�J�C�u�t�@�C���̃p�X���w��
		mask
			�𓀂���t�@�C���̃A�[�J�C�u���ł̃p�X���w��
			���C���h�J�[�h�ɑΉ�
		dest
			�𓀐�t�H���_�p�X
			�Ō�́u\�v�ŏI��点�邱��
		opt
			DLL�ɓn���R�}���h���C���ɒǉ�����I�v�V����
	�Ԃ�l
		�������ʕ�����B

ArcCompress(type,dest,files,opt="")
	�A�[�J�C�u�t�@�C�����쐬����
	
	����
		type
			���k�`����\��������
		dest
			�쐬���鈳�k�t�@�C����
		files
			���k����t�@�C���̃p�X�A�}�X�N
		opt
			DLL�ɓn���R�}���h���C���ɒǉ�����I�v�V����
	�Ԃ�l
		�������ʕ�����B

ArcCmd(type,cmd,outsize=1024)
	DLL�̊֐�(UnLHA32.dll�Ȃ�uUnlha()�v)���Ăяo���ăR�}���h���C�������s����
	
	����
		type
			���k�`����\��������
		cmd
			�R�}���h���C��
		outsize
			�������ʕ�����̂��߂Ɋm�ۂ���e��
	�Ԃ�l
		�������ʕ�����B
		outsize�Ŏw�肵���e�ʂ��傫�������ꍇ�A�e�ʂɎ��܂�悤�ɐ؂�߂���

ArcGetType(path)
	DLL�ɖ₢���킹�ăt�@�C���̈��k�`�����擾����
	
	����
		path
			�`�F�b�N����t�@�C���̃p�X
	�Ԃ�l
		�Ή�����DLL���������ꍇ�A���k�`����\��������

ArcOpen(path)
	ArcFind���Ŋi�[�t�@�C���̏��𓾂邽�߂ɃA�[�J�C�u�t�@�C�����J���B
	
	����
		path
			�J���A�[�J�C�u�t�@�C���̃p�X
	�Ԃ�l
		���������ꍇ�ADLL�ɓn���A�[�J�C�u�n���h�����Ԃ����
	�ڍ�
		�g�p����DLL�͎����I�ɔ��ʂ����
		�����ɊJ���Ă�����̂̓X�N���v�g�S�̂�1�����ł���B

ArcClose()
	ArcOpen�ŊJ�����A�[�J�C�u����A���\�[�X���������

ArcFind(pattern="")
	���݊J���Ă���A�[�J�C�u�t�@�C�����̃t�@�C������������
	
	����
		pattern
			�t�@�C���}�X�N(�p�X�⃏�C���h�J�[�h)
			�ȗ����邩�O��Ɠ����ɂ���ƁA�u���������v�ɂȂ�

ArcGetName()
	ArcFind�ōŌ�Ɍ������t�@�C���̃A�[�J�C�u���ł̃p�X�E�t�@�C�������擾
	
	�Ԃ�l
		�t�@�C���̖��O(�t�H���_���̕��̏ꍇ�̓p�X�t��)

ArcGetCompressedSize()
	ArcFind�ōŌ�Ɍ������t�@�C���̈��k��̃T�C�Y���擾
	
	�Ԃ�l
		�t�@�C���̈��k��̃T�C�Y����������

ArcGetOriginalSize()
	ArcFind�ōŌ�Ɍ������t�@�C���̈��k�O�̃T�C�Y���擾
	
	�Ԃ�l
		�t�@�C���̌��T�C�Y����������

ArcGetRatio()
	ArcFind�ōŌ�Ɍ������t�@�C���̈��k�����擾
	
	�Ԃ�l
		1000*ArcGetCompressedSize/ArcGetOriginalSize�ɑ������鐮��

ArcGetTime()
	ArcFind�ōŌ�Ɍ������t�@�C���̍X�V�������擾
	
	�Ԃ�l
		AutoHotkey�̃^�C���X�^���v�`���ł̓���

ArcGetAttr()
	ArcFind�ōŌ�Ɍ������t�@�C���̑������擾
	
	�Ԃ�l
		�ȉ��̕���A������������
			R �ǂݎ���p
			A �A�[�J�C�u
			S �V�X�e���t�@�C��
			H �B���t�@�C��
			D �f�B���N�g��
			V �{�����[�����x��(���܂�g���Ȃ�)
			P �p�X���[�h�t��(7-zip.dll���̂ݑΉ�)

ArcGetMethod()
	ArcFind�ōŌ�Ɍ������t�@�C���̈��k���@���擾
	
	�Ԃ�l
		���k���@��\��������

ArcGetCRC()
	ArcFind�ōŌ�Ɍ������t�@�C����CRC�`�F�b�N�T�����擾
	
	�Ԃ�l
		CRC����������



���T���v��1
#�t�@�C���̈��k���s��
ArcCompress("zip","F:\test\test.zip","")

���T���v��2
#�����œn���ꂽ�t�@�C���̓��e��\�����ĉ�
sample.ahk�Q��

*/



;DLL���Ƃɑ�\�I�ȑΉ��g���q����񋓁B�`���̎������ʂɎg���B
ArcExts=zip,lzh,cab,tar,rar,gca,ish,bga

;�g���q�ƃ��C�u�������AAPI�֐����̃v���t�B�N�X�̑Ή����L�q
;ArcLibName_* = DLL�t�@�C����
;ArcLibPrefix_* = API�֐����̃v���t�B�N�X
;ArcLibCompOpt_* = ���k���ɃR�}���h���C���ɒǉ�����I�v�V����
;ArcLibExtrOpt_* = �𓀎��ɃR�}���h���C���ɒǉ�����I�v�V����
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
