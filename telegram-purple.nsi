; Script based on the Skype4Pidgin and Off-the-Record Messaging NSI files


SetCompress off

; todo: SetBrandingImage
; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "telegram-purple"
!define PRODUCT_VERSION "${PLUGIN_VERSION}"
!define PRODUCT_PUBLISHER "The telegram-purple team"
!define PRODUCT_WEB_SITE "https://github.com/majn/telegram-purple"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "COPYING"
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Run Pidgin"
!define MUI_FINISHPAGE_RUN_FUNCTION "RunPidgin"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
;!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${PRODUCT_NAME}-${PRODUCT_VERSION}.exe"

Var "PidginDir"

ShowInstDetails show
ShowUnInstDetails show

Section "MainSection" SEC01
    ;Check for pidgin installation
    Call GetPidginInstPath
    
    SetOverwrite try
    
	SetOutPath "$PidginDir\pixmaps\pidgin"
	File "/oname=protocols\16\telegram.png" "imgs\telegram16.png"
	File "/oname=protocols\22\telegram.png" "imgs\telegram22.png"
	File "/oname=protocols\48\telegram.png" "imgs\telegram48.png"

    SetOverwrite try
	copy:
		ClearErrors
		Delete "$PidginDir\plugins\${PRPL_NAME}"
		IfErrors dllbusy
		SetOutPath "$PidginDir\plugins"
	    File "bin\${PRPL_NAME}"
		Goto after_copy
	dllbusy:
		MessageBox MB_RETRYCANCEL "${PRPL_NAME} is busy. Please close Pidgin (including tray icon) and try again" IDCANCEL cancel
		Goto copy
	cancel:
		Abort "Installation of telegram-purple aborted"
	after_copy:
	
	SetOutPath "$PidginDir\locale"
	File /nonfatal "/oname=de\LC_MESSAGES\telegram-purple.mo" "po\de.mo"
	File /nonfatal "/oname=es_AR\LC_MESSAGES\telegram-purple.mo" "po\es_AR.mo"
	File /nonfatal "/oname=pl\LC_MESSAGES\telegram-purple.mo" "po\pl.mo"
	File /nonfatal "/oname=ru\LC_MESSAGES\telegram-purple.mo" "po\ru.mo"
	File /nonfatal "/oname=sq\LC_MESSAGES\telegram-purple.mo" "po\sq.mo"
	
	SetOutPath "$PidginDir"
	File "/oname=server.tglpub" "tg-server.tglpub"
	File "${WIN32_DEV_TOP}\libgpg-error-1.12-2\bin\libgpg-error-0.dll"
	File "${WIN32_DEV_TOP}\libgcrypt-1.6.3\bin\libgcrypt-20.dll"
	File "${WIN32_DEV_TOP}\libwebp-0.4.3-1\bin\libwebp-5.dll"
	File "${WIN32_DEV_TOP}\mingw\bin\libgcc_s_sjlj-1.dll"
	
SectionEnd

Function GetPidginInstPath
  Push $0
  ReadRegStr $0 HKLM "Software\pidgin" ""
	IfFileExists "$0\pidgin.exe" cont
	ReadRegStr $0 HKCU "Software\pidgin" ""
	IfFileExists "$0\pidgin.exe" cont
		MessageBox MB_OK|MB_ICONINFORMATION "Failed to find Pidgin installation."
		Abort "Failed to find Pidgin installation. Please install Pidgin first."
  cont:
	StrCpy $PidginDir $0
FunctionEnd

Function RunPidgin
	ExecShell "" "$PidginDir\pidgin.exe"
FunctionEnd

