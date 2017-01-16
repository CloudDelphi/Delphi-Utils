unit FMX.Helpers.Forms;

interface

uses
  FMX.Types,
  FMX.Forms;

type
{$REGION 'TFMXFormHelper'}
  TFMXFormHelper = class helper for FMX.Forms.TCommonCustomForm
  public
    /// <summary> Parents the FMX Form to the FMX Object </summary>
    procedure ParentTo(&Object: FMX.Types.TFmxObject);
  end;
{$ENDREGION}

implementation

{$REGION 'TFMXFormHelper'}

procedure TFMXFormHelper.ParentTo(&Object: FMX.Types.TFmxObject);
begin
  while ChildrenCount > 0 do
    Children[0].Parent := &Object;
end;

{$ENDREGION}

end.
