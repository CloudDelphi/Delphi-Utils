unit FMX.Helpers.Forms;

interface

uses
  FMX.Types,
  FMX.Forms,
  FMX.Controls,
  Winapi.Windows;

type
{$REGION 'TFMXFormHelper'}
  TFMXFormHelper = class helper for FMX.Forms.TCommonCustomForm
  strict private
    function GetWinHandle: HWND;
  public
    /// <summary> Parents the FMX Form to the FMX Object </summary>
    procedure ParentTo(&Object: FMX.Types.TFmxObject);
    /// <summary> Calls ParentTo and then uses Windows API to set the Window Parent to the InForm HWND </summary>
    procedure WinParentTo(&Object: FMX.Types.TFmxObject; InForm: FMX.Forms.TCommonCustomForm);
    /// <summary> Returns the Windows HWND value </summary>
    property WinHandle: HWND read GetWinHandle;
  end;
{$ENDREGION}

implementation

uses
  FMX.Platform.Win;

{$REGION 'TFMXFormHelper'}

function TFMXFormHelper.GetWinHandle: HWND;
begin
  Result := WindowHandleToPlatform(Handle).Wnd;
end;

procedure TFMXFormHelper.ParentTo(&Object: FMX.Types.TFmxObject);
begin
  while ChildrenCount > 0 do
    Children[0].Parent := &Object;
end;

procedure TFMXFormHelper.WinParentTo(&Object: FMX.Types.TFmxObject; InForm: FMX.Forms.TCommonCustomForm);
begin
  ParentTo(&Object);
  Winapi.Windows.SetParent(WinHandle, InForm.WinHandle);
end;

{$ENDREGION}

end.
