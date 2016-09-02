unit Vcl.Actions.ShortCuts;

interface

uses
  System.Classes,
  System.Actions,
  Winapi.Windows;

type
{$REGION 'IActionShortCutLinker'}
  /// <summary> Fluent interface that allows to link an Action with a ShortCut </summary>
  IActionShortCutLinker = interface
    ['{2F7A38DC-CC4A-4AE9-880C-C7891759F0DD}']
    /// <summary> Clears the ShortCut of all Actions in the ActionList </summary>
    function ClearAllShortCuts(Target: TContainedActionList): IActionShortCutLinker;
    /// <summary> Clears the SecondaryShortCuts of all Actions in the ActionList </summary>
    function ClearAllSecondaryShortCuts(Target: TContainedActionList): IActionShortCutLinker;
    /// <summary> Clears the ShortCut and SecondaryShortCuts of all Actions in the ActionList </summary>
    function ClearAll(Target: TContainedActionList): IActionShortCutLinker;
    /// <summary> Clears the ShortCut property of the Action </summary>
    function ClearShortCut(Target: TContainedAction): IActionShortCutLinker;
    /// <summary> Clears the Secondary ShortCuts of the Action </summary>
    function ClearSecondaryShortCuts(Target: TContainedAction): IActionShortCutLinker;
    /// <summary> Sets the Target ShortCut property </summary>
    function SetShortCut(Target: TContainedAction; const ShortCut: TShortCut): IActionShortCutLinker; overload;
    /// <summary> Creates the TShorCut for the recieved arguments and sets it to the Target ShortCut property </summary>
    function SetShortCut(Target: TContainedAction; const Key: Char; const Shift: TShiftState): IActionShortCutLinker; overload;
    /// <summary> Creates the TShorCut for the recieved arguments and sets it to the Target ShortCut property </summary>
    function SetShortCut(Target: TContainedAction; const Key: Char): IActionShortCutLinker; overload;
    /// <summary> Adds the ShortCut to the list of Secondary ShortCuts of the Action </summary>
    function AddSecondaryShortCut(Target: TContainedAction; const ShortCut: TShortCut): IActionShortCutLinker; overload;
    /// <summary> Creates the ShortCut for the received arguments and adds it to the list of Secondary ShortCuts of the Action </summary>
    function AddSecondaryShortCut(Target: TContainedAction; const Key: Char; const Shift: TShiftState): IActionShortCutLinker; overload;
    /// <summary> Creates the ShortCut for the received arguments and adds it to the list of Secondary ShortCuts of the Action </summary>
    function AddSecondaryShortCut(Target: TContainedAction; const Key: Char): IActionShortCutLinker; overload;
  end;
{$ENDREGION}

{$REGION 'TActionShortCutLinker'}
  TActionShortCutLinker = class(TInterfacedObject, IActionShortCutLinker)
  strict private
{$REGION 'IActionShortCutLinker'}
    function ClearAllShortCuts(Target: TContainedActionList): IActionShortCutLinker;
    function ClearAllSecondaryShortCuts(Target: TContainedActionList): IActionShortCutLinker;
    function ClearAll(Target: TContainedActionList): IActionShortCutLinker;
    function ClearShortCut(Target: TContainedAction): IActionShortCutLinker;
    function ClearSecondaryShortCuts(Target: TContainedAction): IActionShortCutLinker;
    function SetShortCut(Target: TContainedAction; const ShortCut: TShortCut): IActionShortCutLinker; overload;
    function SetShortCut(Target: TContainedAction; const Key: Char; const Shift: TShiftState): IActionShortCutLinker; overload;
    function SetShortCut(Target: TContainedAction; const Key: Char): IActionShortCutLinker; overload;
    function AddSecondaryShortCut(Target: TContainedAction; const ShortCut: TShortCut): IActionShortCutLinker; overload;
    function AddSecondaryShortCut(Target: TContainedAction; const Key: Char; const Shift: TShiftState): IActionShortCutLinker; overload;
    function AddSecondaryShortCut(Target: TContainedAction; const Key: Char): IActionShortCutLinker; overload;
{$ENDREGION}
  end;
{$ENDREGION}

function ShortCutLinker: IActionShortCutLinker;

implementation

uses
  Vcl.Menus;

function ShortCutLinker: IActionShortCutLinker;
begin
  Result := TActionShortCutLinker.Create;
end;

{$REGION 'TActionShortCutLinker'}

function TActionShortCutLinker.ClearAll(Target: TContainedActionList): IActionShortCutLinker;
var
  Each: TContainedAction;
begin
  for Each in Target do
  begin
    ClearShortCut(Each);
    ClearSecondaryShortCuts(Each);
  end;

  Result := Self;
end;

function TActionShortCutLinker.ClearAllSecondaryShortCuts(Target: TContainedActionList): IActionShortCutLinker;
var
  Each: TContainedAction;
begin
  for Each in Target do
    ClearSecondaryShortCuts(Each);

  Result := Self;
end;

function TActionShortCutLinker.ClearAllShortCuts(Target: TContainedActionList): IActionShortCutLinker;
var
  Each: TContainedAction;
begin
  for Each in Target do
    ClearShortCut(Each);

  Result := Self;
end;

function TActionShortCutLinker.ClearSecondaryShortCuts(Target: TContainedAction): IActionShortCutLinker;
begin
  Target.SecondaryShortCuts.Clear;
  Result := Self;
end;

function TActionShortCutLinker.ClearShortCut(Target: TContainedAction): IActionShortCutLinker;
begin
  Result := SetShortCut(Target, Low(TShortCut));
end;

function TActionShortCutLinker.AddSecondaryShortCut(Target: TContainedAction;
  const ShortCut: TShortCut): IActionShortCutLinker;
begin
  Target.SecondaryShortCuts.Add(Vcl.Menus.ShortCutToText(ShortCut));
  Result := Self;
end;

function TActionShortCutLinker.AddSecondaryShortCut(Target: TContainedAction; const Key: Char;
  const Shift: TShiftState): IActionShortCutLinker;
begin
  Result := AddSecondaryShortCut(Target, Vcl.Menus.ShortCut(Word(Key), Shift));
end;

function TActionShortCutLinker.AddSecondaryShortCut(Target: TContainedAction; const Key: Char): IActionShortCutLinker;
begin
  Result := AddSecondaryShortCut(Target, Key, []);
end;

function TActionShortCutLinker.SetShortCut(Target: TContainedAction; const Key: Char): IActionShortCutLinker;
begin
  Result := SetShortCut(Target, Key, []);
end;

function TActionShortCutLinker.SetShortCut(Target: TContainedAction; const Key: Char;
  const Shift: TShiftState): IActionShortCutLinker;
begin
  Result := SetShortCut(Target, Vcl.Menus.ShortCut(Word(Key), Shift));
end;

function TActionShortCutLinker.SetShortCut(Target: TContainedAction; const ShortCut: TShortCut): IActionShortCutLinker;
begin
  Target.ShortCut := ShortCut;
  Result := Self;
end;

{$ENDREGION}

end.
