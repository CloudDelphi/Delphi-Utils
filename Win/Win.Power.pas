unit Win.Power;

interface

/// <summary> Cierra el sistema operativo y agapa la computadora </summary>
/// <param name="Force">
///   Si esta a True, se cierran todas las aplicaciones en ejecucion forzosamente
///  Si esta a False, se permite al usuario que guarde sus datos, cierre las aplicaciones, o que fuerce el apagado
/// </param>
function WindowsPoweOff(const Force: Boolean = False): Boolean;
/// <summary> Cierra el sistema operativo y reinicia la computadora </summary>
/// <param name="Force">
///   Si esta a True, se cierran todas las aplicaciones en ejecucion forzosamente
///  Si esta a False, se permite al usuario que guarde sus datos, cierre las aplicaciones, o que fuerce el renicio
/// </param>
function WindowsReboot(const Force: Boolean = False): Boolean;
/// <summary> Termina todos los procesos de la sesion actual y luego cierra la sesion </summary>
/// <param name="Force">
///   Si esta a True, se cierran todas las aplicaciones en ejecucion forzosamente
///  Si esta a False, se permite al usuario que guarde sus datos, cierre las aplicaciones, o que fuerce el cierre de sesion
/// </param>
function WindowsLogOff(const Force: Boolean = False): Boolean;

implementation

uses
  Winapi.Windows;

// Based on http://www.delphifaq.com/faq/delphi_windows_API/f358.shtml
function SetPrivilege(const PrivilegeName: string; const Enabled: Boolean): Boolean;
var
  TokenPrivileges, RequestedPrivileges: TTokenPrivileges;
  TokenHandle: THandle;
  ReturnLength: DWORD;
begin
  Result := False;
  OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, TokenHandle);

  RequestedPrivileges.PrivilegeCount := 1;
  if LookupPrivilegeValue(nil, PWideChar(PrivilegeName), RequestedPrivileges.Privileges[0].LUID) then
  begin
    if Enabled then
      RequestedPrivileges.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED
    else
      RequestedPrivileges.Privileges[0].Attributes := 0;

    ReturnLength := 0;
    Result := AdjustTokenPrivileges(TokenHandle, False, RequestedPrivileges, SizeOf(TokenPrivileges),
      TokenPrivileges, ReturnLength);
  end;

  CloseHandle(TokenHandle)
end;

// Based on http://www.delphifaq.com/faq/delphi_windows_API/f358.shtml
function WinExit(const Flags: Integer): Boolean;
begin
  Result := False;
  if SetPrivilege('SeShutdownPrivilege', True) then
  begin
    if not ExitWindowsEx(Flags, 0) then
      Exit(False);

    SetPrivilege('SeShutdownPrivilege', False)
  end;
end;

function WindowsPoweOff(const Force: Boolean): Boolean;
var
  Flags: Integer;
begin
  Flags := EWX_POWEROFF;

  if Force then
    Flags := Flags or EWX_FORCE;

  Result := WinExit(Flags)
end;

function WindowsReboot(const Force: Boolean): Boolean;
var
  Flags: Integer;
begin
  Flags := EWX_REBOOT;

  if Force then
    Flags := Flags or EWX_FORCE;

  Result := WinExit(Flags);
end;

function WindowsLogOff(const Force: Boolean): Boolean;
var
  Flags: Integer;
begin
  Flags := EWX_LOGOFF;

  if Force then
    Flags := Flags or EWX_FORCE;

  Result := WinExit(Flags);
end;

end.
