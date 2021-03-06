return

Initialize:


ScriptTitle=AutoCommander

;�ʏ펞��WorkingDir�ɂȂ�
HomeDir=%A_ScriptDir%\

;Migemo�̎������w��
migemo_dict=%HomeDir%dict\migemo-dict

;Migemo�̌������s���Œ�L�[���[�h������
MigemoMin=2

;Migemo�g�p���ɃX�L�b�v�}�b�`���O����������
;�X�L�b�v������������̐��K�\�����w�肷��
;��:MigemoSkipMatch=[^\\]*
MigemoSkipMatch=

;�f�t�H���g�̌������[�h�w�蕶��
SMode=+

;�Z�k�������[�h
SearchWord_rm=readme.txt
SearchWord_ahk=?AutoHotkey|\.ahk

;�E�B���h�E���b�Z�[�W�ȂǂŊO��������s������R�}���h
Remote_11=/o %HomeDir%

;�N�����ɓ��͂���L�[���[�h
;kw=

;���X�g�ɕ\������ő�̌���
ListMax=100

;���X�g�R���g���[���̍ő�̍���(�s��)
ListMaxRows=24

FontSize=9
width=400

;��A�N�e�B�u�����Ɏ����I�ɉB��
AutoHide=1

inifile=%HomeDir%FileLaunch.ini

;�e�t�@�C���̃p�X
indexfile=%HomeDir%path.txt
itemfile=%HomeDir%items.txt
commandfile=%HomeDir%commands.txt
scanlistfile=%HomeDir%scan.txt
subindexfile=%HomeDir%sublist.txt


;�A�C�e���̍ő區�ڐ�(����𒴂����ꍇ�A�����o�^���ڂ��폜�����)
ItemsMax=500

;�C���f�b�N�X�ɒǉ�����t�@�C���𐳋K�\���Ŏw��
list_ptn=\.(exe|txt|ahk|ini)$
;�C���f�b�N�X�Ƀt�H���_��ǉ����邩
list_dir=1
;�X�L�������Ȃ��t�H���_�𐳋K�\���Ŏw��
exclude_ptn=

;�X�L��������A�[�J�C�u�t�@�C���̊g���q
list_archive=zip,lzh,rar,gz

;�A�[�J�C�u���̃t�@�C���̈ꎟ�𓀐�(�Ō��\�Ȃ�)
archive_tmp=%temp%\FL_archive


;�h���C�u�̌��o�̍ۂɑ��݂𖳎�����h���C�u����
OmitDrives=AB


;�풓���[�h
Persistent=1

;�d���N�����̓���(1=�E�B���h�E�\���A2=�ċN��)
;RemoteCmd=1

return





/*
SetGlobalActions�ASetActions�Ŋ��蓖�Ă�T�u���[�`���Ƃ��ẮA
�ȉ��̂悤�ȕ����p�ӂ���Ă���B

ListPrev
	���X�g�őO�̑I�����ڂ�
ListNext
	���X�g�Ŏ��̑I�����ڂ�
ListSPrev
	���X�g�̏�̍��ڂɔ͈͑I�����Ȃ���ړ�
ListSNext
	���X�g�̉��̍��ڂɔ͈͑I�����Ȃ���ړ�
ListCPrev
	���X�g�̏�̍��ڂɈړ����I����Ԃ𔽓]
ListCNext
	���X�g�̉��̍��ڂɈړ����I����Ԃ𔽓]
ListToggleSelect
	���X�g�̃t�H�[�J�X���ڂ̑I����Ԃ𔽓]
SelectAll
	���X�g�̑S���ڂ�I��

Execute
	���݂̓��͓��e�ƑI���t�@�C���Ŋm�肷��
NormalMode
	�C���f�b�N�X�������[�h�ɕ��A
Open
	�I�����ڂ��t�H���_�Ȃ�W�J
UpDir
	�I�����ڂ̂���t�H���_��A�W�J���̃t�H���_�̐e�t�H���_��W�J
SelectCommand
	�R�}���h�I�����[�h�Ɉڍs
SelectProgram
	�v���O�����I�����[�h�Ɉڍs
SelectArg
	�����t�@�C���I�����[�h�Ɉڍs

Exit
	�X�N���v�g���I������
Hide
	���C���E�B���h�E���B��
Show
	���C���E�B���h�E��\��
ShowHide
	�\������Ă���ΉB���A�B��Ă���Ε\������
AutoHide
	��A�N�e�B�u�����Ɏ�����������悤�ɂ���
NoAutoHide
	��A�N�e�B�u�ɂȂ��Ă��\�������܂܂ɂȂ�悤�ɂ���
ToggleAutoHide
	��L��؂�ւ���[
ShowMenu
	�^�X�N�g���C�A�C�R���̉E�N���b�N���j���[��\��

CleanUpData
	���݂��Ȃ����Ƃ��m�F���ꂽ�t�@�C����A����𒴂��������o�^�A�C�e�����폜��
	�C���f�b�N�X���\�[�g������
LoadData
	�C���f�b�N�X�A�A�C�e���A�R�}���h�̃f�[�^��ǂݍ��ݒ���
SaveItems
	CleanUpData���s���Ă���f�[�^��ۑ�����

*/


;�V�X�e���S�̂œ����z�b�g�L�[�����蓖��
SetGlobalActions:
	Hotkey,#z,Show
return

;���C���E�B���h�E�œ����L�[�����蓖��
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
	
	;�����R�}���h�ւ̊��蓖��
	Hotkey,^e,FL_CMD_e
return

/*
���X�g��ł̃}�E�X����ɋ@�\�����蓖��
(�E�A���{�^���ł̓t�@�C���̑I���͍s���Ȃ��̂Œ���)

SetMouseAction(msg,fwkeys,label)
	msg
		0x202		;���{�^���������
		0x203		;���_�u���N���b�N
		0x205		;�E�{�^���������
		0x206		;�E�_�u���N���b�N
		0x208		;���{�^���������
		0x209		;���_�u���N���b�N
	fwkeys
		Shift=4
		Ctrl=8
		Ctrl+Shift=12
*/
SetMouseActions:
	SetMouseAction(0x203,0,"Execute")
	SetMouseAction(0x203,12,"Open")
return




;�^�X�N�g���C�A�C�R���̉E�N���b�N���j���[��ǉ�
SetMenuItems:
Menu,Tray,Add,�f�[�^�ۑ�(&D),SaveData
Menu,Tray,Add,�f�[�^�ēǍ�(&L),LoadData
return





;�^�C�}�[���s���������T�u���[�`��������Ƃ��ɋL�q
SetTimers:
;��:2���Ԃ��ƂɁA�A�C�h�����Ȃ�S�X�L����
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
;;   �C�Ӄv���Z�X�̎��s�t�@�C���p�X���擾
;; ����
;;   pid  �Ώۃv���Z�XID
;; �Ԃ�l
;;   �擾�����p�X
;;;;
getPEName(pid){
	hModule=0
	dwNeed=0
	l=0
	max:=VarSetCapacity(s,256,0)
	hProcess:=getProcessHandle(pid,0x410)	;�ʂ邢�A�N�Z�X���łȂ��Ƌ��ۂ��邱�Ƃ�����
	if(DllCall("psapi\EnumProcessModules","Int",hProcess,"Int*",hModule,"Int",4,"UInt*",dwNeed,"Int")<>0){
		l:=DllCall("psapi\GetModuleFileNameExA","Int",hProcess,"Int",hModule,"Str",s,"Int",max,"Int")
	}
	releaseProcessHandle(hProcess)
	return s
}

TimerActWinAddItem:
	WinGetTitle,t,A
	If(InStr(t,"\") && FileExist(t)){		;�^�C�g���o�[���t�@�C���p�X��������
		AddItem(t)
	}else{
		WinGet,pid,pid,A
		AddItem(getPEName(pid))
	}
return
