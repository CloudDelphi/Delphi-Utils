unit Vcl.CustomDialogs;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin
  
// Easy calls to the TDialogForm
// see Vcl.CustomMsgBox @ https://github.com/ortuagustin/Delphi-Utils/blob/master/Vcl/Vcl.CustomMsgBox.pas

interface

{$REGION 'Information Messages'}
/// <summary> Shows an Information Message </summary>
procedure InfoMsg(const Msg: string); overload;
/// <summary> Shows an Information Message </summary>
procedure InfoMsg(const Msg: string; const FormatArgs: array of const); overload;
{$ENDREGION}

{$REGION 'Confirmation Messages'}
/// <summary> Displays a Confirmation Message with a prompt. Returns True if click on OK. False otherwise </summary>
function PromptMsg(const Prompt: string): Boolean; overload;
/// <summary> Displays a Confirmation Message with a prompt. Returns True if click on OK. False otherwise </summary>
function PromptMsg(const Prompt: string; const FormatArgs: array of const): Boolean; overload;
/// <summary> Displays a PromptMsg with a Checkbox </summary>
function CheckPromptMsg(const Prompt, CheckPrompt: string; var Checked: Boolean): Boolean; overload;
/// <summary> Displays a PromptMsg with a Checkbox </summary>
function CheckPromptMsg(const Prompt, CheckPrompt: string; const FormatArgs: array of const;
  var Checked: Boolean): Boolean; overload;
/// <summary> PromptMsg asking to discard changes. Returns True if click on OK. False otherwise </summary>
function PromptDiscardAndExit: Boolean; overload;
{$ENDREGION}

{$REGION 'Error Messages'}
/// <summary> Displays a Error Message. Returns True if click on OK. False otherwise </summary>
function ErrorPromptMsg(const Prompt: string): Boolean; overload;
/// <summary> Displays a Error Message. Returns True if click on OK. False otherwise </summary>
function ErrorPromptMsg(const Prompt: string; const FormatArgs: array of const): Boolean; overload;
/// <summary> Shows an Error Message </summary>
procedure ErrorMsg(const Msg: string); overload;
/// <summary> Shows an Error Message </summary>
procedure ErrorMsg(const Msg: string; const FormatArgs: array of const); overload;
/// <summary> Shows an Error Message and then calls System.Abort </summary>
procedure ErrorAbortMsg(const Msg: string); overload;
/// <summary> Shows an Error Message and then calls System.Abort </summary>
procedure ErrorAbortMsg(const Msg: string; const FormatArgs: array of const); overload;
{$ENDREGION}

{$REGION 'Warning Messages'}
/// <summary> Shows an Warning Message </summary>
procedure WarningMsg(const Msg: string); overload;
/// <summary> Shows an Warning Message </summary>
procedure WarningMsg(const Msg: string; const FormatArgs: array of const); overload;
/// <summary> Displays a Warning Message with a prompt. Returns True if click on OK. False otherwise </summary>
function WarningPrompt(const Prompt: string): Boolean; overload;
/// <summary> Displays a Warning Message with a prompt. Returns True if click on OK. False otherwise </summary>
function WarningPrompt(const Prompt: string; const FormatArgs: array of const): Boolean; overload;
{$ENDREGION}

{$REGION 'Open File/Folder Prompts'}
/// <summary> Displays a Confirmation Message with a prompt. If the Prompt returns True, the File is opened </summary>
procedure PromptOpenFile(const Prompt, FileName: string);
/// <summary> Displays a Confirmation Message with a prompt. If the Prompt returns True, the shell is opened
/// at the directory pointed by Path </summary>
procedure PromptOpenFolder(const Prompt, Path: string);
/// <summary> Displays a Confirmation Message with a prompt. If the Prompt returns True, the shell is opened
/// at the directory pointed of the File and the File is also selected </summary>
procedure PromptShowFileDirectory(const Prompt, FileName: string);
{$ENDREGION}

implementation

uses
  Vcl.CustomMsgBox,
  SysUtils,
  Dialogs,
  Windows,
  ShellAPI;

{$REGION 'Internal use'}

function DoWarningMsg(const Msg: string; const ShowCancelButton: Boolean): Boolean; overload;
begin
  if ShowCancelButton then
    Result := MsgBox('Advertencia', Msg, mtWarning, ['Aceptar', 'Cancelar']) = 0
  else
    Result := MsgBox('Advertencia', Msg, mtWarning, ['Aceptar']) = 0
end;

function DoWarningMsg(const Msg: string; const FormatArgs: array of const; const ShowCancelButton: Boolean): Boolean; overload;
begin
  Result := DoWarningMsg(Format(Msg, FormatArgs), ShowCancelButton);
end;

{$ENDREGION}

procedure ErrorAbortMsg(const Msg: string);
begin
  ErrorMsg(Msg);
  Abort;
end;

procedure ErrorAbortMsg(const Msg: string; const FormatArgs: array of const);
begin
  ErrorAbortMsg(Format(Msg, FormatArgs));
end;

procedure ErrorMsg(const Msg: string; const FormatArgs: array of const);
begin
  ErrorMsg(Format(Msg, FormatArgs));
end;

procedure InfoMsg(const Msg: string);
begin
  MsgBox('Información', Msg, mtInformation, ['Aceptar']);
end;

procedure InfoMsg(const Msg: string; const FormatArgs: array of const);
begin
  InfoMsg(Format(Msg, FormatArgs));
end;

function PromptMsg(const Prompt: string): Boolean;
begin
  Result := MsgBox('Confirmar', Prompt, mtConfirmation, ['Si', 'No']) = 0;
end;

function PromptMsg(const Prompt: string; const FormatArgs: array of const): Boolean;
begin
  Result := PromptMsg(Format(Prompt, FormatArgs));
end;

function CheckPromptMsg(const Prompt, CheckPrompt: string; var Checked: Boolean): Boolean;
begin
  Result := MsgBox('Confirmar', Prompt, mtConfirmation, ['Si', 'No'], CheckPrompt, Checked) = 0;
end;

function CheckPromptMsg(const Prompt, CheckPrompt: string; const FormatArgs: array of const;
  var Checked: Boolean): Boolean;
begin
  Result := CheckPromptMsg(Format(Prompt, FormatArgs), CheckPrompt, Checked);
end;

function PromptDiscardAndExit: Boolean;
begin
  Result := PromptMsg('Descartar cambios y salir?');
end;

function ErrorPromptMsg(const Prompt: string): Boolean;
begin
  Result := MsgBox('Error', Prompt, mtError, ['Aceptar', 'Cancelar']) = 0;
end;

function ErrorPromptMsg(const Prompt: string; const FormatArgs: array of const): Boolean;
begin
  Result := ErrorPromptMsg(Format(Prompt, FormatArgs));
end;

procedure ErrorMsg(const Msg: string);
begin
  MsgBox('Error', Msg, mtError, ['Aceptar']);
end;

procedure WarningMsg(const Msg: string);
begin
  DoWarningMsg(Msg, False);
end;

procedure WarningMsg(const Msg: string; const FormatArgs: array of const);
begin
  DoWarningMsg(Msg, FormatArgs, False);
end;

function WarningPrompt(const Prompt: string): Boolean;
begin
  Result := DoWarningMsg(Prompt, True);
end;

function WarningPrompt(const Prompt: string; const FormatArgs: array of const): Boolean;
begin
  Result := WarningPrompt(Format(Prompt, FormatArgs));
end;

procedure PromptOpenFile(const Prompt, FileName: string);
begin
  if PromptMsg(Prompt + sLineBreak + sLineBreak + 'Abrir archivo?') then
    ShellExecute(0, 'OPEN', PWideChar(FileName), nil, nil, SW_SHOWMAXIMIZED);
end;

procedure PromptOpenFolder(const Prompt, Path: string);
begin
  if PromptMsg(Prompt + sLineBreak + sLineBreak + 'Abrir directorio?') then
    ShellExecute(0, 'OPEN', PWideChar(Path), nil, nil, SW_SHOWMAXIMIZED);
end;

procedure PromptShowFileDirectory(const Prompt, FileName: string);
begin
  if PromptMsg(Prompt + sLineBreak + sLineBreak + 'Abrir directorio?') then
    ShellExecute(0, 'OPEN', 'explorer.exe', PWideChar('/select,"' + FileName + '"'), nil, SW_SHOWMAXIMIZED);
end;

end.
