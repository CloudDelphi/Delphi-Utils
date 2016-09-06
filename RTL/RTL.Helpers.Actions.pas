unit RTL.Helpers.Actions;

interface

uses
  Spring.Collections,
  System.Classes,
  System.Actions;

type
{$REGION 'IActionListHelper'}
  IActionListHelper = interface
    ['{7239094D-3F99-4A46-A7AE-9EBD010B7CF0}']
    /// <summary> Sets TActionListState.asSuspended for all TActionList instances of the target component </summary>
    function DisableActionLists(Target: TComponent): IActionListHelper;
    /// <summary> Sets TActionListState.asNormal for all TActionList instances of the target component </summary>
    function EnableActionLists(Target: TComponent): IActionListHelper;
    /// <summary> Sets the given TActionListState for all TActionList instances of the target component </summary>
    function SetActionListsState(Target: TComponent; const State: TActionListState): IActionListHelper;
    /// <summary> Returns the collection of all TActionList instances of the target component </summary>
    function GetActionLists(Target: TComponent): Spring.Collections.IEnumerable<TContainedActionList>;
  end;
{$ENDREGION}

{$REGION 'TActionListHelper'}
  TActionListHelper = class(TInterfacedObject, IActionListHelper)
  strict protected
{$REGION 'IActionListHelper'}
    function DisableActionLists(Target: TComponent): IActionListHelper;
    function EnableActionLists(Target: TComponent): IActionListHelper;
    function SetActionListsState(Target: TComponent; const State: TActionListState): IActionListHelper;
    function GetActionLists(Target: TComponent): Spring.Collections.IEnumerable<TContainedActionList>;
{$ENDREGION}
  end;
{$ENDREGION}

function ActionListHelper: IActionListHelper;

implementation

function ActionListHelper: IActionListHelper;
begin
  Result := TActionListHelper.Create;
end;

{$REGION 'TActionListHelper'}

function TActionListHelper.DisableActionLists(Target: TComponent): IActionListHelper;
begin
  Result := SetActionListsState(Target, TActionListState.asSuspended);
end;

function TActionListHelper.EnableActionLists(Target: TComponent): IActionListHelper;
begin
  Result := SetActionListsState(Target, TActionListState.asNormal);
end;

function TActionListHelper.GetActionLists(Target: TComponent): Spring.Collections.IEnumerable<TContainedActionList>;
var
  List: Spring.Collections.IList<TContainedActionList>;
  Each: TComponent;
begin
  List := TCollections.CreateList<TContainedActionList>;
  for Each in Target do
  begin
    if Each is TContainedActionList then
      List.Add(TContainedActionList(Each));
  end;
  Result := List;
end;

function TActionListHelper.SetActionListsState(Target: TComponent; const State: TActionListState): IActionListHelper;
var
  Each: TContainedActionList;
begin
  for Each in GetActionLists(Target) do
    Each.State := State;

  Result := Self;
end;

{$ENDREGION}

end.
