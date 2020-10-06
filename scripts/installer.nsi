; Based on https://nsis.sourceforge.io/Sample_installation_script_for_an_application
; -------------------------------
; Start
  RequestExecutionLevel user
  !define MUI_PRODUCT "RuneChanger"
  Name "RuneChanger"
  !define MUI_VERSION ""
  BrandingText "RuneChanger"
  CRCCheck On

  !include "${NSISDIR}\Contrib\Modern UI\System.nsh"

;---------------------------------
;General

  OutFile "RuneChanger-Setup.exe"
  ShowInstDetails "nevershow"
  ShowUninstDetails "nevershow"
  ;SetCompressor "bzip2"

  !define MUI_ICON "icon.ico"
  !define MUI_UNICON "icon.ico"


;--------------------------------
;Folder selection page

  InstallDir "$LocalAppData\${MUI_PRODUCT}"


;--------------------------------
;Modern UI Configuration

  !define MUI_WELCOMEPAGE
  !define MUI_LICENSEPAGE
  !define MUI_DIRECTORYPAGE
  !define MUI_ABORTWARNING
  !define MUI_UNINSTALLER
  !define MUI_UNCONFIRMPAGE
  !define MUI_FINISHPAGE


;--------------------------------
;Language

  !insertmacro MUI_LANGUAGE "English"


;--------------------------------
;Modern UI System

;  !insertmacro MUI_SYSTEM


;--------------------------------
;Data

  ;LicenseData "LICENSE.TXT"


;--------------------------------
;Installer Sections
Section "install"

;Add files
  SetOutPath "$INSTDIR"
  File "RuneChanger.jar"
  File "open.bat"
  File "run.bat"
  File "silent.vbs"
  File "update.bat"
  SetOutPath "$INSTDIR\lib"
  File /r "lib\*.*"
  SetOutPath "$INSTDIR\image"
  File /r "image\*.*"
  SetOutPath "$INSTDIR"

;create desktop shortcut
;  CreateShortCut "$DESKTOP\${MUI_PRODUCT}.lnk" "$INSTDIR\open.bat" ""

;create start-menu items
;  CreateDirectory "$SMPROGRAMS\${MUI_PRODUCT}"
  CreateShortCut "$SMPROGRAMS\${MUI_PRODUCT}\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "$INSTDIR\Uninstall.exe" 0
;  CreateShortCut "$SMPROGRAMS\${MUI_PRODUCT}\${MUI_PRODUCT}.lnk" "$INSTDIR\open.bat" "" "$INSTDIR\open.bat" 0

;write uninstall information to the registry
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "DisplayName" "${MUI_PRODUCT} (remove only)"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "UninstallString" "$INSTDIR\Uninstall.exe"

  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd


;--------------------------------
;Uninstaller Section
Section "Uninstall"

goto Uninstall
Uninstall:
  ;IfFileExists "$INSTDIR\runechanger.lock" LockFileFound LockFileNotFound
  ;LockFileFound:
    MessageBox MB_OK "Make sure the app is closed before uninstalling."
  ;  goto Uninstall
  ;LockFileNotFound:

;Delete Files
  RMDir /r "$INSTDIR\*.*"

;Remove the installation directory
  RMDir "$INSTDIR"

;Delete Start Menu Shortcuts
  Delete "$DESKTOP\${MUI_PRODUCT}.lnk"
  Delete "$SMPROGRAMS\${MUI_PRODUCT}\*.*"
  RmDir  "$SMPROGRAMS\${MUI_PRODUCT}"

;Delete Uninstaller And Unistall Registry Entries
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\${MUI_PRODUCT}"
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}"

SectionEnd


;--------------------------------
;MessageBox Section


;Function that calls a messagebox when installation finished correctly
Function .onInstSuccess
  Exec "$INSTDIR\open.bat"
  MessageBox MB_OK "RuneChanger has been installed and now will launch."
FunctionEnd


Function un.onUninstSuccess
  MessageBox MB_OK "You have successfully uninstalled ${MUI_PRODUCT}."
FunctionEnd


;eof