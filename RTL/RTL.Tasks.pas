unit RTL.Tasks;

//#############################################################################
//
// Original unit name:  qtx.utils.callback
// Unit:                Windows callback mechanism
// Author:              Jon Lennart Aasenden
// Copyright:           Jon Lennart Aasenden, Quartex Components
// Website:             http://www.quartexcomponents.com
//#############################################################################
//
//  Purpose:
//    This unit provides methods for blocking delay of program execution,
//    and also a non-blocking callback function for anonymous methods.
//
//  The TQTXCallback.Delay method is blocking, meaning that it will halt
//  program execution for the duration of the MS parameter.
//
//  The TQTXCallback.Callback method is NON-blocking, meaning that it will
//  create a winAPI time object that, when the duration of MS is expired,
//  will execute the inline anonymous function.
//
//  NOTE: There are two overloaded versions: One for anonymous methods,
//        and another for object methods (when used within a class).
//
//  Example:
//     TQTXCallback.callback(
//        procedure (
//          begin
//            showmessage('2 seconds have gone by');
//          end,
//     2000);
//
//
//     TQTXCallback.delay(nil,4000);
//     showmessage('4 seconds have gone by');
//
//
//#############################################################################

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Winapi.Windows;

// Toggle this to use WinAPI only, VCL restricted (!)
// {$DEFINE USE_THREADS}

type
  [Weak] TObjectProc = procedure of object;
  TRepeatFunc = function: Boolean;

{$REGION 'TTaskScheduler'}
  /// <summary>
  ///   Provides methods for blocking delay of program execution, and also a non-blocking callback
  ///  function for anonymous methods
  /// </summary>
  TTaskScheduler = record
  strict private
    /// <summary> Short for TThread.GetTickCount </summary>
    class function GetTickCount: UInt32; static; inline;
  public
    /// <summary>
    ///   Non synchronic, blocking method. Halts program execution for the duration of the MS parameter and then
    ///  executes the anonymous method
    /// </summary>
    /// <param name="Proc"> Method that it will be executed </param>
    /// <param name="ms"> Amount of miliseconds to expire for the Method to be executed </param>
    class procedure DelayCall(const Proc: TProc; const ms: UInt32); overload; static;
    /// <summary>
    ///   Non synchronic, blocking method, halts program execution for the duration of the MS parameter and then
    ///  executes the object method
    /// </summary>
    /// <param name="Method"> Method that it will be executed </param>
    /// <param name="ms"> Amount of miliseconds to expire for the Method to be executed </param>
    class procedure DelayCall(const Method: TObjectProc; const ms: UInt32); overload; static;
    /// <summary> Non-blocking method. Will run synchronously the anonymous method when the MS duration expires </summary>
    /// <param name="Proc"> Method that it will be executed </param>
    /// <param name="ms"> Amount of miliseconds to expire for the Method to be executed </param>
    /// <returns> Returns the THandle to the created background thread </returns>
    class function ScheduleCall(const Proc: TProc; const ms: UInt32): THandle; overload; static;
    /// <summary> Non-blocking method. Will run synchronously the object method when the MS duration expires </summary>
    /// <param name="Method"> Method that it will be executed </param>
    /// <param name="ms"> Amount of miliseconds to expire for the Method to be executed </param>
    /// <returns> Returns the THandle to the created background thread </returns>
    class function ScheduleCall(const Method: TObjectProc; const ms: UInt32): THandle; overload; static;
    /// <summary>
    ///   Non-blocking method. Will run synchronously the anonymous function a given amount of times, each of them
    ///  when the MS duration expires. If the function Result is False the loop is interrupted
    /// </summary>
    /// <param name="Entrypoint"> Anonymous function that it will be executed </param>
    /// <param name="ms"> Amount of miliseconds to expire for the function to be executed </param>
    /// <param name="Times"> Amount of times the function is executed </param>
    class procedure &Repeat(const Entrypoint: TRepeatFunc; const ms: UInt32; const Times: Integer); static;
    /// <summary> Aborts the execution of a Thread given its Handle </summary>
    /// <param name="Handle"> The Handle of the background Thread that will be aborted </param>
    class procedure Abort(const Handle: THandle); static;
  end;
{$ENDREGION}

implementation

{$IFNDEF FMX}

uses
  Vcl.Forms;
{$ELSE}
uses
  FMX.Forms;
{$ENDIF}

type
{$REGION 'TTaskSchedulerThread'}
  TTaskSchedulerThread = class(TThread)
  strict private
    FCBAnon: TThreadProcedure;
    FCBObj: TObjectProc;
    FDelay: Integer;
    FObjCall: Boolean;
    FId: Integer;
  protected
    procedure ObjCallback;
    procedure Execute; override;
  public
    property Id: Integer read FId write FId;
    constructor Create(const ms: Integer; const Callback: TThreadProcedure); overload;
    constructor Create(const ms: Integer; const Callback: TObjectProc); overload;
  end;
{$ENDREGION}

{$REGION 'TThreadDictionary'}
  TThreadDictionary = class(TDictionary<Integer, TTaskSchedulerThread>)
  public
    procedure ThreadFinished(Sender: TObject);
  end;
{$ENDREGION}

{$REGION 'TThreadDictionary'}

procedure TThreadDictionary.ThreadFinished(Sender: TObject);
var
  LId: Integer;
begin
  if Assigned(Sender) then
  begin
    if Assigned(Self) then
    begin
      LId := TTaskSchedulerThread(Sender).Id;
      Remove(LId);
    end;
  end;
end;

{$ENDREGION}

var
{$IFDEF USE_THREADS}
  _LUT: TThreadDictionary;
  _TED: Integer;
{$ELSE}
  _LUT: TDictionary<UINT, TProc>;
{$ENDIF}

function ApplicationTerminated: Boolean;
begin
  Result := Assigned(Application) and Application.Terminated;
end;

{$REGION 'TTaskSchedulerThread'}

constructor TTaskSchedulerThread.Create(const ms: Integer; const Callback: TObjectProc);
begin
  inherited Create(True);
  FCBObj := Callback;
  FObjCall := True;
  FDelay := ms;
end;

constructor TTaskSchedulerThread.Create(const ms: Integer; const Callback: TThreadProcedure);
begin
  inherited Create(True);
  FCBAnon := Callback;
  FObjCall := False;
  FDelay := ms;
end;

procedure TTaskSchedulerThread.ObjCallback;
begin
  if not ApplicationTerminated then
    FCBObj();
end;

procedure TTaskSchedulerThread.Execute;
begin

  repeat
    Sleep(1);
    Dec(FDelay);
    if FDelay < 1 then
    begin
      Break;
    end;
  until Terminated;

  if not Terminated then
  begin
    try
      case FObjCall of
        False:
          begin
            try
              if Assigned(FCBAnon) then
                TThread.Queue(nil, FCBAnon);
            except
              on Exception do;
            end;
          end;

        True:
          begin
            try
              Synchronize(ObjCallback);
            except
              on Exception do;
            end;
          end;
      end;
    finally
      Terminate;
    end;
  end;
end;

{$ENDREGION}

{$REGION 'TTaskScheduler'}

class function TTaskScheduler.GetTickCount: UInt32;
begin
  Result := TThread.GetTickCount;
end;

class procedure TTaskScheduler.&Repeat(const Entrypoint: TRepeatFunc; const ms: UInt32; const Times: Integer);
begin
  if Assigned(Entrypoint) then
  begin
    if (ms > 0) and (Times > 0) then
    begin
      if not ApplicationTerminated then
      begin
        ScheduleCall(procedure
          begin
            if Entrypoint() then
            begin
              &Repeat(Entrypoint, ms, Times - 1);
            end;
          end, ms);
      end;
    end;
  end;
end;

class function TTaskScheduler.ScheduleCall(const Proc: TProc; const ms: UInt32): THandle;

{$IFNDEF USE_THREADS}
  procedure timerFunc(hwnd: hwnd; uMsg: UINT; idEvent: UINT_PTR; dwTime: DWORD); stdcall;
  var
    mProc: TProc;
  begin
    KillTimer(0, idEvent);
    try
      if Assigned(_LUT) then
      begin
        mProc := _LUT.Items[idEvent];
        _LUT.Remove(idEvent);
        if Assigned(mProc) then
          mProc();
      end;
    except
      on Exception do;
    end;
  end;
{$ENDIF}
{$IFDEF USE_THREADS}

var
  LThread: TTaskSchedulerThread;
{$ENDIF}
begin
  Result := 0;
  if Assigned(_LUT) then
  begin
{$IFDEF USE_THREADS}
    Inc(_TED);
    Result := _TED;

    LThread := TTaskSchedulerThread.Create(ms, TThreadProcedure(Proc));
    LThread.FreeOnTerminate := True;
    LThread.Id := Result;
    LThread.OnTerminate := _LUT.ThreadFinished;
    _LUT.Add(Result, LThread);
    LThread.Start;
{$ELSE}
    Result := SetTimer(0, 0, ms, @timerFunc);
    _LUT.Add(Result, Proc);
{$ENDIF}
  end;
end;

class procedure TTaskScheduler.Abort(const Handle: THandle);
{$IFDEF USE_THREADS}
var
  LInstance: TTaskSchedulerThread;
{$ENDIF}
begin
  if Assigned(_LUT) and _LUT.ContainsKey(Handle) then
  begin
{$IFDEF USE_THREADS}
    if _LUT.TryGetValue(Handle, LInstance) then
    begin
      if not LInstance.Terminated then
        LInstance.Terminate;
    end;
{$ELSE}
    _LUT.Remove(Handle);
    KillTimer(0, Handle);
{$ENDIF}
  end;
end;

class function TTaskScheduler.ScheduleCall(const Method: TObjectProc; const ms: UInt32): THandle;

{$IFNDEF USE_THREADS}
  procedure timerFunc(hwnd: hwnd; uMsg: UINT; idEvent: UINT_PTR; dwTime: DWORD); stdcall;
  var
    mProc: TProc;
  begin
    KillTimer(0, idEvent);
    try
      if Assigned(_LUT) then
      begin
        mProc := _LUT.Items[idEvent];
        _LUT.Remove(idEvent);
        if Assigned(mProc) then
          mProc();
      end;
    except
      on Exception do;
    end;
  end;
{$ENDIF}
{$IFDEF USE_THREADS}

var
  LThread: TTaskSchedulerThread;
{$ENDIF}
begin
  Result := 0;
  if Assigned(_LUT) then
{$IFDEF USE_THREADS}
  begin
    Inc(_TED);
    Result := _TED;

    LThread := TTaskSchedulerThread.Create(ms, Method);
    LThread.FreeOnTerminate := True;
    LThread.Id := Result;
    LThread.OnTerminate := _LUT.ThreadFinished;
    _LUT.Add(Result, LThread);
    LThread.Start;
  end;
{$ELSE}
    Result := SetTimer(0, 0, ms, @timerFunc);
    _LUT.Add(Result, Method);
{$ENDIF}
end;

class procedure TTaskScheduler.DelayCall(const Proc: TProc; const ms: UInt32);
var
  LThen: DWORD;
begin
  if not ApplicationTerminated and (ms > 0) then
  begin
    try
      LThen := GetTickCount + ms;

      repeat
        Sleep(1);
        if ApplicationTerminated then Break;
      until (GetTickCount >= LThen);

      if Assigned(Proc) and not ApplicationTerminated then
      begin
        try
          Proc;
        except
          on Exception do;
        end;
      end;
    except
      on Exception do;
    end;
  end;
end;

class procedure TTaskScheduler.DelayCall(const Method: TObjectProc; const ms: UInt32);
var
  LThen: DWORD;
begin
  if not ApplicationTerminated and (ms > 0) then
  begin
    try
      LThen := GetTickCount + ms;
      repeat
        Sleep(1);
        if ApplicationTerminated then Break;
      until GetTickCount >= LThen;

      if Assigned(Method) and not ApplicationTerminated then
      begin
        try
          Method;
        except
          on Exception do;
        end;
      end;
    except
      on Exception do;
    end;
  end;
end;

{$ENDREGION}

initialization

begin
{$IFDEF USE_THREADS}
  _LUT := TThreadDictionary.Create;
{$ELSE}
  _LUT := TDictionary<UINT, TProc>.Create;
{$ENDIF}
end;

finalization

begin
  if Assigned(_LUT) then
    FreeAndNil(_LUT);
end;

end.
