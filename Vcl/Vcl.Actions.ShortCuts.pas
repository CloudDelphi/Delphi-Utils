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
    /// <summary> Clears the ShortCut property of the Action </summary>
    function ClearShortCut(Target: TContainedAction): IActionShortCutLinker;
    /// <summary> Clears the Secondary ShortCuts of the Action </summary>
    function ClearSecondaryShortCuts(Target: TContainedAction): IActionShortCutLinker;
    /// <summary> Sets the Target ShortCut property </summary>
    function SetShortCut(Target: TContainedAction; const ShortCut: TShortCut): IActionShortCutLinker; overload;
    /// <summary> Creates the TShorCut for the recieved arguments and sets it to the Target ShortCut property </summary>
    function SetShortCut(Target: TContainedAction; const Key: Word; const Shift: TShiftState): IActionShortCutLinker; overload;
    /// <summary> Adds the ShortCut to the list of Secondary ShortCuts of the Action </summary>
    function AddSecondaryShortCut(Target: TContainedAction; const ShortCut: TShortCut): IActionShortCutLinker; overload;
    /// <summary> Creates the ShortCut for the received arguments and adds it to the list of Secondary ShortCuts of the Action </summary>
    function AddSecondaryShortCut(Target: TContainedAction; const Key: Word; const Shift: TShiftState): IActionShortCutLinker; overload;
  end;
{$ENDREGION}

{$REGION 'TActionShortCutLinker'}
  TActionShortCutLinker = class(TInterfacedObject, IActionShortCutLinker)
  strict private
{$REGION 'IActionShortCutLinker'}
    function ClearShortCut(Target: TContainedAction): IActionShortCutLinker;
    function ClearSecondaryShortCuts(Target: TContainedAction): IActionShortCutLinker;
    function SetShortCut(Target: TContainedAction; const ShortCut: TShortCut): IActionShortCutLinker; overload;
    function SetShortCut(Target: TContainedAction; const Key: Word; const Shift: TShiftState): IActionShortCutLinker; overload;
    function AddSecondaryShortCut(Target: TContainedAction; const ShortCut: TShortCut): IActionShortCutLinker; overload;
    function AddSecondaryShortCut(Target: TContainedAction; const Key: Word; const Shift: TShiftState): IActionShortCutLinker; overload;
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

function TActionShortCutLinker.AddSecondaryShortCut(Target: TContainedAction; const Key: Word;
  const Shift: TShiftState): IActionShortCutLinker;
begin
  Result := AddSecondaryShortCut(Target, Vcl.Menus.ShortCut(Key, Shift));
end;

function TActionShortCutLinker.AddSecondaryShortCut(Target: TContainedAction;
  const ShortCut: TShortCut): IActionShortCutLinker;
begin
  Target.SecondaryShortCuts.Add(ShortCutToText(ShortCut));
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

function TActionShortCutLinker.SetShortCut(Target: TContainedAction; const ShortCut: TShortCut): IActionShortCutLinker;
begin
  Target.ShortCut := ShortCut;
  Result := Self;
end;

function TActionShortCutLinker.SetShortCut(Target: TContainedAction; const Key: Word;
  const Shift: TShiftState): IActionShortCutLinker;
begin
  Result := SetShortCut(Target, Vcl.Menus.ShortCut(Key, Shift));
end;

{$ENDREGION}

end.
