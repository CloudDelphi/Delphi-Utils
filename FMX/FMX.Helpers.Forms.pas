unit FMX.Helpers.Forms;

interface

uses
  FMX.Forms,
  FMX.Controls,
  Winapi.Windows;

type
{$REGION 'TFMXFormHelper'}
  TFMXFormHelper = class helper for FMX.Forms.TForm
  strict private
    function GetWinHandle: HWND;
  public
    /// <summary> Parents the FMX Form to the "InForm" FMX Form inside the Control </summary>
    procedure ParentTo(AControl: FMX.Controls.TControl; InForm: FMX.Forms.TForm);
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

procedure TFMXFormHelper.ParentTo(AControl: FMX.Controls.TControl; InForm: FMX.Forms.TForm);
begin
  while ChildrenCount > 0 do
    Children[0].Parent := AControl;

//  Parent := InForm;
  Winapi.Windows.SetParent(WinHandle, InForm.WinHandle);
end;

{$ENDREGION}

end.
