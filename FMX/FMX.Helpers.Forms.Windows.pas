unit FMX.Helpers.Forms.Windows;

interface

uses
  FMX.Helpers.Forms,
  FMX.Types,
  FMX.Forms,
  Winapi.Windows;

type
{$REGION 'TWindowsFMXFormHelper'}
  TWindowsFMXFormHelper = class helper (TFMXFormHelper) for FMX.Forms.TCommonCustomForm
  strict private
    function GetWinHandle: HWND;
  public
    /// <summary> Calls ParentTo and then uses Windows API to set the Window Parent to the InForm HWND </summary>
    procedure WinParentTo(&Object: FMX.Types.TFmxObject; InForm: FMX.Forms.TCommonCustomForm);
    /// <summary> Returns the Windows HWND value </summary>
    property WinHandle: HWND read GetWinHandle;
  end;
{$ENDREGION}

implementation

uses
  FMX.Platform.Win;

{$REGION 'TWindowsFMXFormHelper'}

function TWindowsFMXFormHelper.GetWinHandle: HWND;
begin
  Result := WindowHandleToPlatform(Handle).Wnd;
end;

procedure TWindowsFMXFormHelper.WinParentTo(&Object: FMX.Types.TFmxObject; InForm: FMX.Forms.TCommonCustomForm);
begin
  ParentTo(&Object);
  Winapi.Windows.SetParent(WinHandle, InForm.WinHandle);
end;

{$ENDREGION}

end.
