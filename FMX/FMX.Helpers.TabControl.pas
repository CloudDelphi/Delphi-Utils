unit FMX.Helpers.TabControl;

interface

uses
  FMX.TabControl;

type
{$REGION 'TTabControlHelper'}
  TTabControlHelper = class helper for FMX.TabControl.TTabControl
  private
    function GetTab(Index: Integer): TTabItem;
  public
    procedure ChangeTab(const TabIndex: Integer; const Transition: TTabTransition);
    property Tab[Index: Integer]: TTabItem read GetTab;
  end;
{$ENDREGION}

implementation

{$REGION 'TTabControlHelper'}

procedure TTabControlHelper.ChangeTab(const TabIndex: Integer; const Transition: TTabTransition);
begin
  SetActiveTabWithTransition(Tab[TabIndex], Transition);
end;

function TTabControlHelper.GetTab(Index: Integer): TTabItem;
begin
  Result := Tabs[Index];
end;

{$ENDREGION}

end.
