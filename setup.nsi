# We assume the following commandline parameters for the compilation
# DIR_PREFIX     is the full path to the directory containing the different modules
# SOURCE_VERSION defines the version of the release
# SOURCE_DIR     is the relative path to the groovy install directory
# NATIVE_DIR     is the relative path to the native launcher
# SCRIPTOM_DIR   is the relative path to the scriptom module
# GANT_DIR       is the relative path to the gant module
# GRIFFON_B      is the relative path to the griffon builders module
# VERSION_TXT    is the relative path to the installed_versions.txt
# DOC_DIR        is the relative path to the doc directory

;@Todo: Correct language strings

!define InstallerVersion 0.7.0

# Set the compression level
#SetCompressor /SOLID lzma

# The source of the Groovy installation
!define SOURCEDIR "${DIR_PREFIX}\${SOURCE_DIR}"

# Defines
!define COMPANY ""
!define URL groovy.codehaus.org
!define ShortName Groovy
!define VERSION ${SOURCE_VERSION}
Name "Groovy-${Version}"
!define REGKEY "SOFTWARE\$(^Name)"

# MUI defines
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
!define MUI_STARTMENUPAGE_REGISTRY_KEY ${REGKEY}
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME StartMenuGroup
!define MUI_STARTMENUPAGE_DEFAULTFOLDER $(^Name)
!define MUI_FINISHPAGE_SHOWREADME $INSTDIR\${VERSION_TXT}
!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "header.bmp"
!define MUI_HEADERIMAGE_BITMAP_NOSTRETCH
!define MUI_WELCOMEFINISHPAGE_BITMAP "welcome.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP_NOSTRETCH

# Included files
!include Sections.nsh
!include MUI.nsh
!include logiclib.nsh
!include WinMessages.NSH
!include FileFunc.nsh
!include  EnvVarUpdate.nsh


# Reserved Files
#ReserveFile "${NSISDIR}\Plugins\AdvSplash.dll"

# User and System Environment
!define NT_current_env 'HKCU "Environment"'
!define NT_all_env     'HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"'

# Variables
Var StartMenuGroup
Var UserOrSystem

# Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuGroup
!insertmacro MUI_PAGE_INSTFILES
Page custom ReadVariables SetVariables
Page custom ReadFileAssociation SetFileAssociation
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

# Installer languages
!insertmacro MUI_LANGUAGE English
!insertmacro MUI_LANGUAGE German
!insertmacro MUI_LANGUAGE Spanish
!insertmacro MUI_LANGUAGE French
!insertmacro MUI_LANGUAGE PortugueseBR


# Installer attributes
OutFile "groovy-${SOURCE_VERSION}-installer.exe"
InstallDir "$PROGRAMFILES\${ShortName}\$(^Name)"
CRCCheck on
XPStyle on
ShowInstDetails show
InstallDirRegKey HKLM "${REGKEY}" Path
ShowUninstDetails show

# Installer sections
Section "Groovy Binaries" SecBinaries
    SectionIn RO    # this section cannot be deselected
    SetOutPath $INSTDIR
    SetOverwrite on
    File /r "${SOURCEDIR}\*"

    SetOutPath $INSTDIR\bin
    File /oname=groovy.exe "${DIR_PREFIX}\${NATIVE_DIR}\groovy.exe"
    File /oname=groovyc.exe "${DIR_PREFIX}\${NATIVE_DIR}\groovy.exe"
    File /oname=groovysh.exe "${DIR_PREFIX}\${NATIVE_DIR}\groovy.exe"
    File /oname=java2groovy.exe "${DIR_PREFIX}\${NATIVE_DIR}\groovy.exe"

    File /oname=groovyw.exe "${DIR_PREFIX}\${NATIVE_DIR}\groovyw.exe"
    File /oname=groovyConsole.exe "${DIR_PREFIX}\${NATIVE_DIR}\groovyw.exe"

    SetOutPath $INSTDIR
    File "${DIR_PREFIX}\${VERSION_TXT}"

    WriteRegStr HKLM "${REGKEY}\Components" "Groovy Binaries" 1
SectionEnd

Section "Groovy Documentation" SecDocumentation
    SetOutPath $INSTDIR
    
    SetOverwrite on
    File  /r "${DIR_PREFIX}\${DOC_DIR}\*"
    WriteRegStr HKLM "${REGKEY}\Components" "Groovy Documentation" 1
SectionEnd

Section "Modify Variables" SecVariables
    SetOutPath $INSTDIR
    SetOverwrite on
    WriteRegStr HKLM "${REGKEY}\Components" "Modify Variables" 1
SectionEnd

SectionGroup /e Modules SecGrpModules
    Section Gant SecGant
        SetOutPath $INSTDIR
        SetOverwrite on
        File /r "${DIR_PREFIX}\${GANT_DIR}\*"

        SetOutPath $INSTDIR\bin
        File /oname=gant.exe "${DIR_PREFIX}\${NATIVE_DIR}\groovy.exe"
        File /oname=gantw.exe "${DIR_PREFIX}\${NATIVE_DIR}\groovyw.exe"
        
        WriteRegStr HKLM "${REGKEY}\Components" Gant 1
    SectionEnd

    Section Griffon SecGriffon
        SetOutPath "$INSTDIR\lib"
        SetOverwrite on
        File /r "${DIR_PREFIX}\${GRIFFON_B}\*"
        WriteRegStr HKLM "${REGKEY}\Components" Griffon 1
    SectionEnd

    Section Scriptom SecScriptom
        SetOutPath $INSTDIR
        SetOverwrite on
        File /r "${DIR_PREFIX}\${SCRIPTOM_DIR}\*"
        WriteRegStr HKLM "${REGKEY}\Components" Scriptom 1
    SectionEnd
SectionGroupEnd

# Links in Start Menu

LangString ^UninstallLink ${LANG_ENGLISH} "Uninstall $(^Name)"
LangString ^UninstallLink ${LANG_GERMAN} "Deinstalliere $(^Name)"
LangString ^UninstallLink ${LANG_SPANISH} "Uninstall $(^Name)"
LangString ^UninstallLink ${LANG_FRENCH} "Uninstall $(^Name)"
LangString ^UninstallLink ${LANG_PortugueseBR} "Desinstalar $(^Name)"

LangString ^PDFLink ${LANG_ENGLISH} "PDF Documentation"
LangString ^PDFLink ${LANG_GERMAN} "PDF-Dokumentation"
LangString ^PDFLink ${LANG_SPANISH} "Documentaci�n en PDF"
LangString ^PDFLink ${LANG_FRENCH} "Documentation PDF"
LangString ^PDFLink ${LANG_PortugueseBR} "Documenta��o em PDF"

LangString ^HTMLLink ${LANG_ENGLISH} "GDK Documentation"
LangString ^HTMLLink ${LANG_GERMAN} "GDK-Dokumentation"
LangString ^HTMLLink ${LANG_SPANISH} "Documentaci�n del GDK"
LangString ^HTMLLink ${LANG_FRENCH} "Documentation du GDK"
LangString ^HTMLLink ${LANG_PortugueseBR} "Documenta��o do GDK"

LangString ^APILink ${LANG_ENGLISH} "API Documentation"
LangString ^APILink ${LANG_GERMAN} "API-Dokumentation"
LangString ^APILink ${LANG_SPANISH} "Documentaci�n del API"
LangString ^APILink ${LANG_FRENCH} "Documentation de l'API"
LangString ^APILink ${LANG_PortugueseBR} "Documenta��o da API"

LangString ^GAPILink ${LANG_ENGLISH} "GAPI Documentation"
LangString ^GAPILink ${LANG_GERMAN} "GAPI-Dokumentation"
LangString ^GAPILink ${LANG_SPANISH} "Documentaci�n del GAPI"
LangString ^GAPILink ${LANG_FRENCH} "Documentation de la GAPI"
LangString ^GAPILink ${LANG_PortugueseBR} "Documenta��o da GAPI"

LangString ^GroovyConsoleLink ${LANG_ENGLISH} "Start GroovyConsole"
LangString ^GroovyConsoleLink ${LANG_GERMAN} "Starte GroovyConsole"
LangString ^GroovyConsoleLink ${LANG_SPANISH} "Start GroovyConsole"
LangString ^GroovyConsoleLink ${LANG_FRENCH} "Start GroovyConsole"
LangString ^GroovyConsoleLink ${LANG_PortugueseBR} "Iniciar GroovyConsole"

Section "-Shortcuts" SecShortcuts

    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    SetOutPath $SMPROGRAMS\$StartMenuGroup

    SectionGetFlags ${SecDocumentation} $R0 
    IntOp $R0 $R0 & ${SF_SELECTED} 

    ${If} $R0 == ${SF_SELECTED}
        CreateShortcut "$SMPROGRAMS\$StartMenuGroup\$(^HTMLLink).lnk" $INSTDIR\html\groovy-jdk\index.html
        CreateShortcut "$SMPROGRAMS\$StartMenuGroup\$(^APILink).lnk" $INSTDIR\html\api\index.html
        CreateShortcut "$SMPROGRAMS\$StartMenuGroup\$(^GAPILink).lnk" $INSTDIR\html\gapi\index.html
        CreateShortcut "$SMPROGRAMS\$StartMenuGroup\$(^PDFLink).lnk" $INSTDIR\pdf\wiki-snapshot.pdf
    ${EndIf}

    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\$(^GroovyConsoleLink).lnk" $INSTDIR\bin\GroovyConsole.exe

    !insertmacro MUI_STARTMENU_WRITE_END    
    WriteRegStr HKLM "${REGKEY}\Components" Shortcuts 1
SectionEnd

# Section Descriptions
LangString DESC_SecBinaries ${LANG_ENGLISH} "Main Groovy Binaries (includes native launcher)"
LangString DESC_SecBinaries ${LANG_GERMAN} "Groovy Basisinstallation (beinhaltet den nativelauncher)"
LangString DESC_SecBinaries ${LANG_SPANISH} "Main Groovy Binaries"
LangString DESC_SecBinaries ${LANG_FRENCH} "Main Groovy Binaries"
LangString DESC_SecBinaries ${LANG_PortugueseBR} "Main Groovy Binaries"

LangString DESC_SecDocumentation ${LANG_ENGLISH} "Groovy Documentation - including  a \
PDF Snapshot of the Wiki (ca. 900 pages)"
LangString DESC_SecDocumentation ${LANG_GERMAN}  "Groovy-Dokumentation - inkl. \
PDF-Abzug des Wiki (ca. 900 Seiten)"
LangString DESC_SecDocumentation ${LANG_SPANISH} "Documentaci�n de Groovy - incluye copia \
del wiki en PDF (aprox. 900 p�ginas)"
LangString DESC_SecDocumentation ${LANG_FRENCH}  "Documentation de Groovy - dont un PDF \
du wiki (900 pages)"
LangString DESC_SecDocumentation ${LANG_PortugueseBR}  "Groovy Documentation - incluindo um \
PDF extraido da Wiki (aprox. 900 p�ginas)"

LangString DESC_SecVariables ${LANG_ENGLISH} "Environment Variables and File Association"
LangString DESC_SecVariables ${LANG_GERMAN} "Umgebungsvariablen und Dateiassoziationen"
LangString DESC_SecVariables ${LANG_SPANISH} "Environment Variables and File Association"
LangString DESC_SecVariables ${LANG_FRENCH} "Environment Variables and File Association"
LangString DESC_SecVariables ${LANG_PortugueseBR} "Environment Variables and File Association"

LangString DESC_SecGrpModules ${LANG_ENGLISH} "Additional Modules are not strictly necessary, \
but we recommend installing them anyway."
LangString DESC_SecGrpModules ${LANG_GERMAN} "Zus�tzliche Module sind nicht unbedingt notwendig, \
wir empfehlen aber, sie trotzdem zu installieren."
LangString DESC_SecGrpModules ${LANG_SPANISH} "Los M�dulos Adicionales no son estrictamente \
necesarios, pero recomendamos que se instalen de todas formas."
LangString DESC_SecGrpModules ${LANG_FRENCH}  "Les Modules aditionnels sont optionnels, \
nous vous recommendons cependant de les installer"
LangString DESC_SecGrpModules ${LANG_PortugueseBR}  "M�dulos adicionais n�o s�o estritamente necess�rios, \
mesmo assim recomendamos que sejam instalados."

LangString DESC_SecGant ${LANG_ENGLISH} "Gant - a build tool for scripting Ant tasks \
with Groovy"
LangString DESC_SecGant ${LANG_GERMAN}  "Gant - Ein Werkzeug, um Ant Tasks mit Groovy \
zu programmieren"
LangString DESC_SecGant ${LANG_SPANISH} "Gant - una herramienta que facilita el \
'scripting' the tareas de Ant con Groovy"
LangString DESC_SecGant ${LANG_FRENCH}  "Gant - Outil de build permettant de manipuler \
les t�ches Ant avec Groovy"
LangString DESC_SecGant ${LANG_PortugueseBR}  "Gant - uma ferramenta de build para criar tarefas do Ant \
com scripts Groovy"

LangString DESC_SecGriffon ${LANG_ENGLISH} "Griffon Builders"
LangString DESC_SecGriffon ${LANG_GERMAN} "Griffon Builders"
LangString DESC_SecGriffon ${LANG_SPANISH} "Griffon Builders"
LangString DESC_SecGriffon ${LANG_FRENCH} "Griffon Builders"
LangString DESC_SecGriffon ${LANG_PortugueseBR} "Griffon Builders"

LangString DESC_SecScriptom ${LANG_ENGLISH} "Scriptom - script ActiveX or COM components \
with Groovy"
LangString DESC_SecScriptom ${LANG_GERMAN}  "Scriptom - Programmieren von ActiveX und COM-\
Komponenten mit Groovy"
LangString DESC_SecScriptom ${LANG_SPANISH} "Scriptom - permite acceder y configurar \
components ActiveX y/o COM con Groovy"
LangString DESC_SecScriptom ${LANG_FRENCH}  "Scriptom - Manipulation d'ActiveX ou composants \
COM avec Groovy"
LangString DESC_SecScriptom ${LANG_PortugueseBR}  "Scriptom - acesse componentes ActiveX ou COM \
com Groovy"

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecBinaries} $(DESC_SecBinaries)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDocumentation} $(DESC_SecDocumentation)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecVariables} $(DESC_SecVariables)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecGrpModules} $(DESC_SecGrpModules)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecGant} $(DESC_SecGant)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecGriffon} $(DESC_SecGriffon)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecScriptom} $(DESC_SecScriptom)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Section -post SEC0006
    WriteRegStr HKLM "${REGKEY}" Path $INSTDIR
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\$(^UninstallLink).lnk" $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_END
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon $INSTDIR\uninstall.exe
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString $INSTDIR\uninstall.exe
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1
SectionEnd

# Macro for selecting uninstaller sections
!macro SELECT_UNSECTION SECTION_NAME UNSECTION_ID
    Push $R0
    ReadRegStr $R0 HKLM "${REGKEY}\Components" "${SECTION_NAME}"
    StrCmp $R0 1 0 next${UNSECTION_ID}
    !insertmacro SelectSection "${UNSECTION_ID}"
    GoTo done${UNSECTION_ID}
next${UNSECTION_ID}:
    !insertmacro UnselectSection "${UNSECTION_ID}"
done${UNSECTION_ID}:
    Pop $R0
!macroend

Section /o un.Shortcuts UNSEC0006
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\$(^GroovyConsoleLink).lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\$(^HTMLLink).lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\$(^APILink).lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\$(^GAPILink).lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\$(^PDFLink).lnk"
    DeleteRegValue HKLM "${REGKEY}\Components" "Shortcuts"
SectionEnd

# Uninstaller sections
Section /o un.Scriptom UNSEC0005
    DeleteRegValue HKLM "${REGKEY}\Components" Scriptom
SectionEnd

Section /o un.Griffon UNSEC0004
    DeleteRegValue HKLM "${REGKEY}\Components" Griffon
SectionEnd

Section /o un.Gant UNSEC0003
    DeleteRegValue HKLM "${REGKEY}\Components" Gant
SectionEnd

Section /o "un.Modify Variables" UNSEC0002
    DeleteRegValue HKLM "${REGKEY}\Components" "Modify Variables"
SectionEnd

Section /o "un.Groovy Documentation" UNSEC0001
    DeleteRegValue HKLM "${REGKEY}\Components" "Groovy Documentation"
SectionEnd

Section /o "un.Groovy Binaries" UNSEC0000
    Delete /REBOOTOK $INSTDIR\${VERSION_TXT}
    RmDir /r /REBOOTOK $INSTDIR
    DeleteRegValue HKLM "${REGKEY}\Components" "Groovy Binaries"
SectionEnd

Section un.post UNSEC0007
    DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\$(^UninstallLink).lnk"
    Delete /REBOOTOK $INSTDIR\uninstall.exe
    DeleteRegValue HKLM "${REGKEY}" StartMenuGroup
    DeleteRegValue HKLM "${REGKEY}" Path
    DeleteRegKey /IfEmpty HKLM "${REGKEY}\Components"
    DeleteRegKey /IfEmpty HKLM "${REGKEY}"
    RmDir /REBOOTOK $SMPROGRAMS\$StartMenuGroup
    RmDir /REBOOTOK $INSTDIR
    Push $R0
    StrCpy $R0 $StartMenuGroup 1
    StrCmp $R0 ">" no_smgroup
no_smgroup:
    Pop $R0
SectionEnd

# Installer functions
Function .onInit
    InitPluginsDir
    !insertmacro MUI_LANGDLL_DISPLAY
    File /oname=$PLUGINSDIR\variables.ini variables.ini
    File /oname=$PLUGINSDIR\fileassociation.ini fileassociation.ini
    
FunctionEnd


# Uninstaller functions
Function un.onInit
    ReadRegStr $INSTDIR HKLM "${REGKEY}" Path
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuGroup
    !insertmacro SELECT_UNSECTION "Groovy Binaries" ${UNSEC0000}
    !insertmacro SELECT_UNSECTION "Groovy Documentation" ${UNSEC0001}
    !insertmacro SELECT_UNSECTION "Modify Variables" ${UNSEC0002}
    !insertmacro SELECT_UNSECTION Gant ${UNSEC0003}
    !insertmacro SELECT_UNSECTION Griffon ${UNSEC0004}
    !insertmacro SELECT_UNSECTION Scriptom ${UNSEC0005}
    !insertmacro SELECT_UNSECTION Shortcuts ${UNSEC0006}
FunctionEnd


#################################################################################################

### Environment

#################################################################################################

# VField 01
LangString VField01 ${LANG_ENGLISH} "Create GROOVY_HOME"
LangString VField01 ${LANG_GERMAN}  "Erzeuge GROOVY_HOME"
LangString VField01 ${LANG_SPANISH} "Crear GROOVY_HOME"
LangString VField01 ${LANG_FRENCH}  "Cr�er GROOVY_HOME"
LangString VField01 ${LANG_PortugueseBR}  "Criar GROOVY_HOME"

# VField 02
LangString VField02 ${LANG_ENGLISH} "Add to Path"
LangString VField02 ${LANG_GERMAN}  "Zum Pfad hinzuf�gen"
LangString VField02 ${LANG_SPANISH} "Agregar a la Ruta"
LangString VField02 ${LANG_FRENCH}  "Ajouter au chemin d'acc�s/au Path"
LangString VField02 ${LANG_PortugueseBR}  "Adicionar ao Path"

# VField 5
LangString VField05 ${LANG_ENGLISH} "If a reference to groovy is detected in the path, \
the checkbox for adding GROOVY_HOME to the path is unchecked. \
If you know better, please set the checkbox to checked.\r\n\r\n\
NB: The uninstaller won't restore old values (yet)."
LangString VField05 ${LANG_GERMAN} "Wenn eine Referenz zu groovy im Pfad entdeckt wird, \
wird die Checkbox f�r das Hinzuf�gen von GROOVY_HOME ausgeschaltet.\
Wenn Sie GROOVY_HOME trotzdem zum Pfad hinzuf�gen m�chten, w�hlen Sie sie wieder an.\r\n\r\n\
Achtung: Der Uninstaller merkt sich keine alten Werte (noch nicht)."
LangString VField05 ${LANG_SPANISH} "Si alguna referencia a Groovy es detectada en la ruta, \
el bot�n para agregar GROOVY_HOME a la ruta aparecer� deseleccionado. \
Puede dejar el bot�n seleccionado si lo desea.\r\n\r\n\
NB: El proceso de desinstalaci�n no restaurar� valores anteriores."
LangString VField05 ${LANG_FRENCH} "Si une r�f�rence vers groovy \
est d�tect�e dans le chemin d'acc�s, \
la boite  � cocher d'ajout de GROOVY_HOME au chemin d'acc�s est d�coch�e. \
Si vous �tes expert, cochez ici svp.\r\n\r\n\
NB: Le d�sinstalleur ne restaurera pas les anciennes valeurs (pas pour le moment)."
LangString VField05 ${LANG_PortugueseBR} "Se uma refer�ncia ao Groovy foi detectada, \
o checkbox para adicionar o GROOVY_HOME ao Path estar� desmarcada. \
Se voc� preferir, por favor marque esse checkbox.\r\n\r\n\
NB: O desinstalador n�o ir� restaurar os antigos valores (por enquanto)."

# VField 6
LangString VField06 ${LANG_ENGLISH} "User Environment or\r\nSystem Environment"
LangString VField06 ${LANG_GERMAN}  "Benutzerumgebung oder\r\nSystemumgebung"
LangString VField06 ${LANG_SPANISH} "Entorno de Usuario o\r\nEntorno de Sistema"
LangString VField06 ${LANG_FRENCH}  "Environnement utilisateur ou\r\nenvironnement syst�me"
LangString VField06 ${LANG_PortugueseBR}  "Apenas para esse usu�rio\r\nPara todos os usu�rios"


# VField 7
LangString VField07 ${LANG_ENGLISH} "Add to System Environment"
LangString VField07 ${LANG_GERMAN}  "Systemumgebung w�hlen"
LangString VField07 ${LANG_SPANISH} "Agregar a Entorno de Sistema"
LangString VField07 ${LANG_FRENCH}  "Ajouter � l'environnement syst�me"
LangString VField07 ${LANG_PortugueseBR}  "Adicionar �s vari�veis do sistema"

# VField 8
LangString VField08 ${LANG_ENGLISH} "Path to Groovy Home"
LangString VField08 ${LANG_GERMAN}  "Pfad zu Groovy Home"
LangString VField08 ${LANG_SPANISH} "Ruta a Groovy Home"
LangString VField08 ${LANG_FRENCH}  "Chemins d'acc�s au r�pertoire standard Groovy"
LangString VField08 ${LANG_PortugueseBR}  "Caminho para o diret�rio raiz do Groovy"

# VField 9
LangString VField09 ${LANG_ENGLISH} "Path Extension"
LangString VField09 ${LANG_GERMAN}  "Erweiterung des Pfades"
LangString VField09 ${LANG_SPANISH} "Extensi�n de Rutas"
LangString VField09 ${LANG_FRENCH}  "Extension du chemin d'acc�s"
LangString VField09 ${LANG_PortugueseBR}  "Extens�o do Path"

# EnvironmentTitle
LangString EnvironmentTitle ${LANG_ENGLISH} "Environment"
LangString EnvironmentTitle ${LANG_GERMAN}  "Umgebung"
LangString EnvironmentTitle ${LANG_SPANISH} "Entorno"
LangString EnvironmentTitle ${LANG_FRENCH}  "Environnement"
LangString EnvironmentTitle ${LANG_PortugueseBR}  "Vari�veis"

# JavaHomeWarning
LangString JavaHomeWarning ${LANG_ENGLISH} "JAVA_HOME is not set. Please set it \
to your Java installation, otherwise Groovy won't be able to work."
LangString JavaHomeWarning ${LANG_GERMAN}  "JAVA_HOME ist nicht gesetzt. \
Bitte setzen Sie die Umgebungsvariable, ansonsten kann Groovy nicht funktionieren."
LangString JavaHomeWarning ${LANG_SPANISH} "JAVA_HOME no est� definido. Por favor defina la ruta \
hacia la instalaci�n de Java, de lo contrario Groovy no podr� funcionar correctamente."
LangString JavaHomeWarning ${LANG_FRENCH}  "JAVA_HOME n'est pas positionn� sur le r�pertoire \
d'installation Java. Dans le cas contraire groovy ne fonctionnera pas."
LangString JavaHomeWarning ${LANG_PortugueseBR}  "JAVA_HOME n�o est� configurada. Por favor, configure \
para o diret�rio de instala��o do Java, caso contr�rio o Groovy n�o funcionar�."


#Additional Page for setting GROOVY_HOME and system path
Function ReadVariables

  SectionGetFlags ${SecVariables} $R0 
  IntOp $R0 $R0 & ${SF_SELECTED} 
  IntCmp $R0 ${SF_SELECTED} show 
 
  Abort 
 
  show: 

  Push $R0

  # Localization
  WriteINIStr $PLUGINSDIR\variables.ini "Field 1"  "Text" $(VField01)
  WriteINIStr $PLUGINSDIR\variables.ini "Field 2"  "Text" $(VField02)
  WriteINIStr $PLUGINSDIR\variables.ini "Field 5"  "Text" $(VField05)
  WriteINIStr $PLUGINSDIR\variables.ini "Field 6"  "Text" $(VField06)
  WriteINIStr $PLUGINSDIR\variables.ini "Field 7"  "Text" $(VField07)
  WriteINIStr $PLUGINSDIR\variables.ini "Field 8"  "Text" $(VField08)
  WriteINIStr $PLUGINSDIR\variables.ini "Field 9"  "Text" $(VField09)

  # Set value for GROOVY_HOME textfield
  WriteINIStr $PLUGINSDIR\variables.ini "Field 3" "state" $INSTDIR

  # Check for groovy in path
  ReadEnvStr $R0 PATH
  Push $R0
  Push "roovy"
  Call StrStr
  Pop $R0
  
  
  # set GROOVY_HOME checkbox to unchecked if groovy is in path
  ${If} $R0 != ''
    WriteINIStr $PLUGINSDIR\variables.ini "Field 2" "state" "0"
  ${EndIf}
  
  #InstallOptions::dialog $PLUGINSDIR\variables.ini
  ;If not using Modern UI use InstallOptions::dialog "iofile.ini"
  !insertmacro MUI_HEADER_TEXT "$(EnvironmentTitle)" ""
  !insertmacro MUI_INSTALLOPTIONS_DISPLAY "variables.ini" 

  Pop $R0
FunctionEnd

Function SetVariables
  Push $R0

  # default is current
  StrCpy $UserOrSystem "current"
  # If set, then the system environment is used
  ReadINIStr $R0 "$PLUGINSDIR\variables.ini" "Field 7" "State"
  ${If} $R0 == '1'
    StrCpy $UserOrSystem "all"
  ${Else}
    StrCpy $UserOrSystem "current"
  ${EndIf}
  
  # Set GROOVY_HOME if the user checked the resp. checkbox
  ReadINIStr $R0 "$PLUGINSDIR\variables.ini" "Field 1" "State"
  ${If} $R0 == '1'
    ReadINIStr $R0 "$PLUGINSDIR\variables.ini" "Field 3" "State"
    Push "GROOVY_HOME"
    Push $R0
    Call WriteEnvStr
  ${EndIf}
  
  # Set PATH if the user checked the resp. checkbox
  ReadINIStr $R0 "$PLUGINSDIR\variables.ini" "Field 2" "State"
  ${If} $R0 == '1'
    
    # Variable PATH and Mode Append
    Push "PATH"
    Push "A"

    # "HKLM" = the "all users" section of the registry 
    # "HKCU" = the "current user" section     
    StrCmp $UserOrSystem "current" NT_current
       Push "HKLM"
       Goto NT_resume
    NT_current:
       Push "HKCU"
    NT_resume:

    ReadINIStr $R0 "$PLUGINSDIR\variables.ini" "Field 4" "State"
    Push $R0
    Call EnvVarUpdate
    Pop  $0
    
  ${EndIf}

  # Finally, check for JAVA_HOME existence
  ReadEnvStr $R0 JAVA_HOME
  ${If} $R0 == ""
    MessageBox MB_ICONEXCLAMATION|MB_OK $(JavaHomeWarning)
  ${EndIf}
  
  Pop $R0

FunctionEnd

#################################################################################################

### File Associations

#################################################################################################

# FAField 01
LangString FAField01 ${LANG_ENGLISH} "File Association allows us to define \
a program (in our case groovy) to execute upon \
double click on a file. This means that you can \
execute your groovy programs directly from the explorer.\
You need the native launcher for this.\
\r\n\r\nAn added benefit is that the groovy \
icon is associated with groovy files."
LangString FAField01 ${LANG_GERMAN}  "Dateiassoziation erlaubt es uns, ein \
Programm zu bestimmen (in unserem Fall Groovy), \
das automatisch beim Start einer Groovy-Datei \
ausgef�hrt wird. Sie k�nnen also mit Doppelklick \
im Explorer Ihre Groovy-Programme starten.\
Sie ben�tigen den 'Native Launcher' hierf�r.\
\r\n\r\nZus�tzlich wird das Groovy Icon mit \
Groovy-Dateien assoziiert."
LangString FAField01 ${LANG_SPANISH} "Asociaci�n de Ficheros permite definir que \
un programa (en este caso Groovy) se ejecute al realizar \
doble click con el puntero sobre un fichero. Esto significa \
que usted podr� ejecutar programas Groovy directamente desde el Explorador de Windows. \
Para ello se requiere entonces del Lanzador Nativo.\
\r\nComo beneficio adicional habr� un �cono Groovy asociado a \
ficheros de tipo Groovy."
LangString FAField01 ${LANG_FRENCH}  "L'association fichier vous permet de d�finir \
un programme (dans notre cas groovy) pour ex�cuter un fichier groovy \
par simple double-click sur ce dernier. Ceci signifie que vous pouvez \
ex�cuter vos programmes groovy directement � partir d'un explorateur windows. \
Vous avez besoin du lanceur natif pour cela. \
\r\nUn b�n�fice suppl�mentaire est que l'icone \
groovy est associ�e � tout fichier de type groovy."
LangString FAField01 ${LANG_PortugueseBR}  "Associa��o de arquivos nos permite definir \
um programa (no caso groovy) que executa com \
um duplo clique no arquivo. Isso significa que voc� pode \
executar seus programas escritos em Groovy diretamente do explorer. \
Voc� precisa do Native Launcher para isso.\
\r\n\r\nUm benef�cio adicional � que o icone do Groovy \
ser� associado aos arquivos .groovy."

# FAField 02
LangString FAField02 ${LANG_ENGLISH} "Add File Association"
LangString FAField02 ${LANG_GERMAN}  "F�ge Dateiassoziation hinzu"
LangString FAField02 ${LANG_SPANISH} "Agregar Asociaci�n de Ficheros"
LangString FAField02 ${LANG_FRENCH}  "Ajouter une association fichier"
LangString FAField02 ${LANG_PortugueseBR}  "Adicionar associa��o de arquivos"

# FAField 03
LangString FAField03 ${LANG_ENGLISH} "PATHEXT is an environment variable telling cmd.exe \
which files are executable. If Groovy-Files are already referenced, this checkbox \
is unchecked.  If you know better, please set the checkbox to checked."
LangString FAField03 ${LANG_GERMAN}  "PATHEXT ist eine Umgebungsvariable, die cmd.exe \
mitteilt, welche Dateien ausf�hrbar sind. Wenn Groovy-Dateien schon referenziert \
sind, ist die Checkbox nicht ausgew�hlt. \
Wenn Sie Groovy trotzdem hinzuf�gen wollen, w�hlen Sie sie wieder an."
LangString FAField03 ${LANG_SPANISH} "PATHEXT es una variable de entorno que le indica \
a cmd.exe cuales ficheros son de tipo ejecutable. Si Groovy-Files ya esta referenciado, \
este bot�n aparecer� deseleccionado. Puede dejar el bot�n seleccionado si lo \
desea."
LangString FAField03 ${LANG_FRENCH}  "PATHEXT est une variable d'environnement indiquant \
� la commande cmd.exe \
quels fichiers sont des ex�cutables. Si les fichiers groovy sont d�j� r�f�renc�s, \
la boite � cocher est d�coch�e. Si vous �tes expert, cochez ici svp."
LangString FAField03 ${LANG_PortugueseBR}  "PATHEXT � uma vari�vel de ambiente que indica ao cmd.exe \
quais arquivos s�o execut�veis. Se os arquivos Groovy j� est�o referenciados, este checkbox \
estar� desmarcado. Se voc� preferir, por favor marque esse checkbox."

# FAField 04
LangString FAField04 ${LANG_ENGLISH} "Add to PATHEXT"
LangString FAField04 ${LANG_GERMAN}  "F�ge zu PATHEXT hinzu"
LangString FAField04 ${LANG_SPANISH} "Agregar a PATHEXT"
LangString FAField04 ${LANG_FRENCH}  "Ajouter � PATHEXT"
LangString FAField04 ${LANG_PortugueseBR}  "Adicionar ao PATHEXT"

# AssocTitle
LangString AssocTitle ${LANG_ENGLISH} "File Association"
LangString AssocTitle ${LANG_GERMAN}  "Dateiassoziationen"
LangString AssocTitle ${LANG_SPANISH} "Asociaci�n de Ficheros"
LangString AssocTitle ${LANG_FRENCH}  "Association des fichiers"
LangString AssocTitle ${LANG_PortugueseBR}  "Associa��o de arquivos"

Function ReadFileAssociation

  SectionGetFlags ${SecVariables} $R0 
  IntOp $R0 $R0 & ${SF_SELECTED} 
  IntCmp $R0 ${SF_SELECTED} show 
 
  Abort 
 
  show: 

  Push $R0

  # Localization
  #MessageBox MB_ICONEXCLAMATION|MB_OK "Result. $(Field10)"
  WriteINIStr $PLUGINSDIR\fileassociation.ini "Field 1" "Text" $(FAField01)
  WriteINIStr $PLUGINSDIR\fileassociation.ini "Field 2" "Text" $(FAField02)
  WriteINIStr $PLUGINSDIR\fileassociation.ini "Field 3" "Text" $(FAField03)
  WriteINIStr $PLUGINSDIR\fileassociation.ini "Field 4" "Text" $(FAField04)
  
  
  # Check for groovy in pathext
  ReadEnvStr $R0 "PATHEXT"
  Push $R0
  Push ".groovy"
  Call StrStr
  Pop $R0
  
  # set Pathext checkbox to unchecked if .groovy is already in Pathext
  ${If} $R0 != ''
    WriteINIStr $PLUGINSDIR\fileassociation.ini "Field 4" "state" "0"
  ${EndIf}
    
  #InstallOptions::dialog $PLUGINSDIR\fileassociation.ini
  ;If not using Modern UI use InstallOptions::dialog "iofile.ini"
  !insertmacro MUI_HEADER_TEXT "$(AssocTitle)" ""
  !insertmacro MUI_INSTALLOPTIONS_DISPLAY "fileassociation.ini" 

  Pop $R0
FunctionEnd

Function SetFileAssociation
  Push $R0

  # If set, then create file association
  ReadINIStr $R0 "$PLUGINSDIR\fileassociation.ini" "Field 2" "State"
  ${If} $R0 == '1'
    # set file associations
    !define Index "Line${__LINE__}"
    ReadRegStr $1 HKCR ".groovy" ""
    StrCmp $1 "" "${Index}-NoBackup"
      StrCmp $1 "Groovy" "${Index}-NoBackup"
      WriteRegStr HKCR ".groovy" "backup_val" $1
    "${Index}-NoBackup:"
    WriteRegStr HKCR ".groovy" "" "Groovy"
    ReadRegStr $0 HKCR "Groovy" ""
    StrCmp $0 "" 0 "${Index}-Skip"
      WriteRegStr HKCR "Groovy" "" "Groovy.groovy"
      WriteRegStr HKCR "Groovy\shell" "" "open"
      WriteRegStr HKCR "Groovy\DefaultIcon" "" '"$INSTDIR\bin\groovy.exe",0'
    "${Index}-Skip:"
    WriteRegStr HKCR "Groovy\shell\open\command" "" '"$INSTDIR\bin\groovy.exe" "%1" %*'
    #WriteRegStr HKCR "Groovy\shell\edit" "" "Edit Options File"
    #WriteRegStr HKCR "Groovy\shell\edit\command" "" '$INSTDIR\execute.exe "%1"'
 
    System::Call 'Shell32::SHChangeNotify(i 0x8000000, i 0, i 0, i 0)'
    !undef Index
  ${EndIf}

  # Set PATHEXT if the user checked the resp. checkbox
  ReadINIStr $R0 "$PLUGINSDIR\fileassociation.ini" "Field 4" "State"
  ${If} $R0 == '1'
    ReadEnvStr $R0 "PATHEXT"
    StrCpy $R0 "$R0;.groovy;.gy"
    Push "PATHEXT"
    Push $R0
    Call WriteEnvStr
  ${EndIf}


  Pop $R0

FunctionEnd



!macro IsNT UN
Function ${UN}IsNT
  Push $0
  ReadRegStr $0 HKLM \
    "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
  StrCmp $0 "" 0 IsNT_yes
  ; we are not NT.
  Pop $0
  Push 0
  Return
 
  IsNT_yes:
    ; NT!!!
    Pop $0
    Push 1
FunctionEnd
!macroend
!insertmacro IsNT ""
!insertmacro IsNT "un."

#
# WriteEnvStr - Writes an environment variable
# Note: Win9x systems requires reboot
#
# Example:
#  Push "HOMEDIR"           # name
#  Push "C:\New Home Dir\"  # value
#  Call WriteEnvStr
#
Function WriteEnvStr
  Exch $1 ; $1 has environment variable value
  Exch
  Exch $0 ; $0 has environment variable name
  Push $2
 
  Call IsNT
  Pop $2
  StrCmp $2 1 WriteEnvStr_NT
    ; Not on NT
    StrCpy $2 $WINDIR 2 ; Copy drive of windows (c:)
    FileOpen $2 "$2\autoexec.bat" a
    FileSeek $2 0 END
    FileWrite $2 "$\r$\nSET $0=$1$\r$\n"
    FileClose $2
    SetRebootFlag true
    Goto WriteEnvStr_done
 
  WriteEnvStr_NT:

  ${If} $UserOrSystem == "all"
    ClearErrors
    WriteRegExpandStr ${NT_all_env} $0 $1

    IfErrors 0 WriteEnvStr_all_resume
      MessageBox MB_YESNO|MB_ICONQUESTION "The path could not be set for all users$\r$\nShould I try for the current user?" \
         IDNO WriteEnvStr_all_failed
      ; change selection
      StrCpy $UserOrSystem "current"
    WriteEnvStr_all_resume:
      SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
      DetailPrint "added variable $0 for user ($UserOrSystem), $1"
    WriteEnvStr_all_failed:
  ${EndIf}


  ${If} $UserOrSystem == "current"
    ClearErrors
    WriteRegExpandStr ${NT_current_env} $0 $1

    IfErrors 0 WriteEnvStr_current_resume
      MessageBox MB_OK|MB_ICONINFORMATION "The path could not be set for the current user."
      Goto WriteEnvStr_current_failed
    WriteEnvStr_current_resume:
      SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
      DetailPrint "added variable $0 for user ($UserOrSystem), $1"
    WriteEnvStr_current_failed:
  ${EndIf}

  WriteEnvStr_done:
    Pop $2
    Pop $0
    Pop $1
FunctionEnd
