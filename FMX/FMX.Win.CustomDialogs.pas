unit FMX.Win.CustomDialogs;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin
  
// Easy calls to the MessageDlg function

interface

uses
  FMX.Dialogs;

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

procedure PromptOpenFile(const Prompt, Filename: string);

implementation

uses
{$IFDEF MSWINDOWS}
  Winapi.ShellAPI,
  Winapi.Windows,
{$ENDIF}
  System.SysUtils,
  System.UITypes;

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
  MessageDlg(Msg, TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0, TMsgDlgBtn.mbOK);
end;

procedure InfoMsg(const Msg: string; const FormatArgs: array of const);
begin
  InfoMsg(Format(Msg, FormatArgs));
end;

function PromptMsg(const Prompt: string): Boolean;
begin
  Result := MessageDlg(Prompt, TMsgDlgType.mtConfirmation , mbOKCancel, 0, TMsgDlgBtn.mbOK) = mrOk;
end;

function PromptMsg(const Prompt: string; const FormatArgs: array of const): Boolean;
begin
  Result := PromptMsg(Format(Prompt, FormatArgs));
end;

function PromptDiscardAndExit: Boolean;
begin
  Result := PromptMsg('Descartar cambios y salir?');
end;

function ErrorPromptMsg(const Prompt: string): Boolean;
begin
  Result := MessageDlg(Prompt, TMsgDlgType.mtError, mbOKCancel, 0, TMsgDlgBtn.mbOK) = mrOk;
end;

function ErrorPromptMsg(const Prompt: string; const FormatArgs: array of const): Boolean;
begin
  Result := ErrorPromptMsg(Format(Prompt, FormatArgs));
end;

procedure ErrorMsg(const Msg: string);
begin
  MessageDlg(Msg, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0, TMsgDlgBtn.mbOK);
end;

procedure WarningMsg(const Msg: string);
begin
  MessageDlg(Msg, TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0, TMsgDlgBtn.mbOK);
end;

procedure WarningMsg(const Msg: string; const FormatArgs: array of const);
begin
  WarningMsg(Msg, FormatArgs);
end;

function WarningPrompt(const Prompt: string): Boolean;
begin
  Result :=  MessageDlg(Prompt, TMsgDlgType.mtWarning, mbOKCancel, 0, TMsgDlgBtn.mbOK) = mrOk;
end;

function WarningPrompt(const Prompt: string; const FormatArgs: array of const): Boolean;
begin
  Result := WarningPrompt(Format(Prompt, FormatArgs));
end;

{$IFDEF MSWINDOWS}

procedure PromptOpenFile(const Prompt, Filename: string);
begin
  if PromptMsg(Prompt + sLineBreak + sLineBreak + 'Abrir archivo?') then
    ShellExecute(0, 'OPEN', PWideChar(Filename), nil, nil, SW_SHOWMAXIMIZED);
end;

{$ENDIF}

end.
