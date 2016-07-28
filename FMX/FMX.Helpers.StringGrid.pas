unit FMX.Helpers.StringGrid;

interface

uses
  FMX.Graphics,
  FMX.Grid;

type
{$REGION 'TStringGridHelper'}
  TStringGridHelper = class helper for TStringGrid
  public
    /// <summary> Limpia el Grid: Todas las celdas pasan a contener "EmptyStr" </summary>
    procedure Clear;
    /// <summary> Invoca a BeginUpdate y luego a Clear </summary>
    procedure BeginUpdateClear;
    /// <summary> Aplica a todos los THeader de todos los TColumn el TTextSettings recibido como argumento </summary>
    procedure HeadersTextSettings(const AHeaderTextSettings: TTextSettings);
  end;
{$ENDREGION}

{$REGION 'TColumnHelper'}
  TColumnHelper = class helper for TColumn
  public
    /// <summary> Devuelve el objeto TTextSettings de la columna </summary>
    function HeaderTextSettings: TTextSettings;
  end;
{$ENDREGION}

implementation

uses
  FMX.Helpers.Grid,
  System.SysUtils,
  FMX.Types,
  FMX.Header;

{$REGION 'TStringGridHelper'}

procedure TStringGridHelper.BeginUpdateClear;
begin
  BeginUpdate;
  Clear;
end;

procedure TStringGridHelper.Clear;
var
  AColumn, ARow: Integer;
begin
  BeginUpdate;
  try
    for AColumn := 0 to ColumnCount - 1 do
    begin
      for ARow := 0 to RowCount - 1 do
      begin
        Cells[AColumn, ARow] := EmptyStr;
      end;
    end;
  finally
    RowCount := 0;
    EndUpdate;
  end;
end;

procedure TStringGridHelper.HeadersTextSettings(const AHeaderTextSettings: TTextSettings);
  function CalcHeaderSize: Integer;
  var
    AFontSize: Single;
  begin
    AFontSize := Canvas.Font.Size;
    Canvas.Font.Size := AHeaderTextSettings.Font.Size + 8;
    try
      Result := Trunc(Canvas.TextHeight('A'));
    finally
      Canvas.Font.Size := AFontSize;
    end;
  end;
var
  I: Integer;
  Header: THeader;
  HeaderItem: THeaderItem;
begin
  Header := Self.Header;
  for I := 0 to Header.Count - 1 do
  begin
    HeaderItem := Header.Items[I];
    HeaderItem.TextSettings.Assign(AHeaderTextSettings);
    HeaderItem.StyledSettings := HeaderItem.StyledSettings - [TStyledSetting.Size, TStyledSetting.Style];
  end;
  Header.Height := CalcHeaderSize;
end;

{$ENDREGION}

{$REGION 'TColumnHelper'}

function TColumnHelper.HeaderTextSettings: TTextSettings;
begin
  if (Grid <> nil) and (Grid.Header <> nil) then
    Result := Grid.Header.Items[Index].TextSettings
  else
    Result := nil;
end;

{$ENDREGION}

end.
