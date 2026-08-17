[Setup]
AppId={{APP_ID}}
AppVersion={{APP_VERSION}}
AppName={{DISPLAY_NAME}}
AppPublisher={{PUBLISHER_NAME}}
AppPublisherURL={{PUBLISHER_URL}}
AppSupportURL={{PUBLISHER_URL}}
AppUpdatesURL={{PUBLISHER_URL}}
DefaultDirName={{INSTALL_DIR_NAME}}
DisableProgramGroupPage=yes
OutputDir=../installer
OutputBaseFilename={{OUTPUT_BASE_FILENAME}}
Compression=lzma
SolidCompression=yes
SetupIconFile={{SETUP_ICON_FILE}}
WizardStyle=modern
PrivilegesRequired={{PRIVILEGES_REQUIRED}}
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
CloseApplications=force
SignTool=sign_and_backup sign /v /fd sha256 /tr http://ts.ssl.com /td sha256 /sha1 {{CODE_SIGN_CERT_THUMBPRINT}} /d "{{DISPLAY_NAME}}" /du "{{PUBLISHER_URL}}" $f
SignedUninstaller=yes

[Languages]
{% for locale in LOCALES %}
{% if locale == 'en' %}Name: "english"; MessagesFile: "compiler:Default.isl"{% endif %}
{% endfor %}

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: {% if CREATE_DESKTOP_ICON != true %}unchecked{% else %}checkedonce{% endif %}
Name: "launchAtStartup"; Description: "{cm:AutoStartProgram,{{DISPLAY_NAME}}}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: {% if LAUNCH_AT_STARTUP != true %}unchecked{% else %}checkedonce{% endif %}

[Files]
Source: "{{SOURCE_DIR}}\zenshield.exe"; DestDir: "{app}"; Flags: ignoreversion signonce
Source: "{{SOURCE_DIR}}\zenshield_core.dll"; DestDir: "{app}"; Flags: ignoreversion signonce
Source: "{{SOURCE_DIR}}\singbox-tunnel.exe"; DestDir: "{app}"; Flags: ignoreversion signonce
Source: "{{SOURCE_DIR}}\*"; DestDir: "{app}"; Excludes: "zenshield.exe,singbox-tunnel.exe,zenshield_core.dll"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\\{{DISPLAY_NAME}}"; Filename: "{app}\\{{EXECUTABLE_NAME}}"
Name: "{autodesktop}\\{{DISPLAY_NAME}}"; Filename: "{app}\\{{EXECUTABLE_NAME}}"; Tasks: desktopicon
Name: "{userstartup}\\{{DISPLAY_NAME}}"; Filename: "{app}\\{{EXECUTABLE_NAME}}"; WorkingDir: "{app}"; Tasks: launchAtStartup
[Run]
Filename: "{app}\\{{EXECUTABLE_NAME}}"; Description: "{cm:LaunchProgram,{{DISPLAY_NAME}}}"; Flags: {% if PRIVILEGES_REQUIRED == 'admin' %}runascurrentuser{% endif %} nowait postinstall skipifsilent
; The in-app updater runs Setup with /SILENT, where the postinstall checkbox
; above is skipped — relaunch the app ourselves so an update does not leave the
; user staring at a closed app.
Filename: "{app}\\{{EXECUTABLE_NAME}}"; Flags: {% if PRIVILEGES_REQUIRED == 'admin' %}runascurrentuser{% endif %} nowait; Check: WizardSilent

[Registry]
Root: HKCU; Subkey: "Software\Classes\zenshield"; ValueType: string; ValueName: ""; ValueData: "URL:Zenshield Protocol"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\zenshield"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""
Root: HKCU; Subkey: "Software\Classes\zenshield\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{{EXECUTABLE_NAME}},0"
Root: HKCU; Subkey: "Software\Classes\zenshield\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{{EXECUTABLE_NAME}}"" ""%1"""

[Code]
function InitializeSetup(): Boolean;
var
  ResultCode: Integer;
begin
  Exec('taskkill', '/F /IM Zenshield.exe', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Exec('taskkill', '/F /IM singbox-tunnel.exe', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Exec('net', 'stop "ZenshieldTunnelService"', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Exec('sc.exe', 'delete "ZenshieldTunnelService"', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Result := True;
end;
