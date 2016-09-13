unit Vcl.Helpers.Forms;

interface

uses
  Vcl.Forms,
  FMX.Forms,
  Winapi.Windows;

type
{$REGION 'TVclFormHelper'}
  TVclFormHelper = class helper for Vcl.Forms.TForm
  public
    /// <summary> Parents the Vcl form inside of the FMX Form </summary>
    procedure ParentToFmx(FmxForm: FMX.Forms.TForm);
  end;
{$ENDREGION}

implementation

uses
  FMX.Helpers.Forms;

{$REGION 'TVclFormHelper'}

procedure TVclFormHelper.ParentToFmx(FmxForm: FMX.Forms.TForm);
begin
  Winapi.Windows.SetParent(Handle, FmxForm.WinHandle);
end;

{$ENDREGION}

end.
