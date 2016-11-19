unit Vcl.GridPanel.Helper;

interface

uses
  Vcl.Controls,
  Vcl.ExtCtrls;

type
{$REGION 'TGridPanelHelper'}
  TGridPanelHelper = class helper for TCustomGridPanel
  strict private
    function GetCellControl(Value: TControl): TControlItem;
  public
    /// <summary> Returns the TControlItem for the given TControl </summary>
    /// <remarks> If the control is not contained in the TGridPanel, nil is returned </remarks>
    property CellControl[Index: TControl]: TControlItem read GetCellControl;
  end;
{$ENDREGION}

implementation

{$REGION 'TGridPanelHelper'}

function TGridPanelHelper.GetCellControl(Value: TControl): TControlItem;
var
  I: Integer;
  Each: TControlItem;
begin
  for I := 0 to ControlCollection.Count - 1 do
  begin
    Each := ControlCollection[I];
    if Each.Control = Value then
      Exit(Each);
  end;

  Result := nil;
end;

{$ENDREGION}

end.
