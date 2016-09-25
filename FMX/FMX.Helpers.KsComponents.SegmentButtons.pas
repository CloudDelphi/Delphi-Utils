unit FMX.Helpers.KsComponents.SegmentButtons;

interface

uses
  ksSegmentButtons;

type
{$REGION 'TksSegmentButtonsHelper'}
  TksSegmentButtonsHelper = class helper for TksSegmentButtons
  strict private
    function GetItemText(Index: Integer): string;
    procedure SetItemText(Index: Integer; const Value: string);
  public
    /// <summary> Pone como seleccionado el item con texto AText, y si no existe deja ItemIndex a -1 </summary>
    procedure SelectItemWithText(const AText: string);
    /// <summary> Devuelve el texto del item seleccionado; Si no hay nada seleccionado devuelve EmptyStr </summary>
    function SelectedText: string;
    /// <summary> Texto que muestra cada TksSegmentButton, dado por el Index </summary>
    property ItemText[Index: Integer]: string read GetItemText write SetItemText;
  end;
{$ENDREGION}

implementation

uses
  System.SysUtils;

{$REGION 'TksSegmentButtonsHelper'}

function TksSegmentButtonsHelper.SelectedText: string;
begin
  if ItemIndex <> -1 then
    Result := Selected.Text
  else
    Result := EmptyStr;
end;

procedure TksSegmentButtonsHelper.SelectItemWithText(const AText: string);
var
  I: Integer;
  Each: TksSegmentButton;
begin
  for I := 0 to Segments.Count - 1 do
  begin
    Each := Segments.Items[I];
    if Each.Text = AText then
    begin
      ItemIndex := Each.Index;
      Exit;
    end;
  end;

  ItemIndex := -1;
end;

function TksSegmentButtonsHelper.GetItemText(Index: Integer): string;
begin
  Result := Segments.Items[Index].Text;
end;

procedure TksSegmentButtonsHelper.SetItemText(Index: Integer; const Value: string);
begin
  Segments.Items[Index].Text := Value;
end;

{$ENDREGION}

end.
