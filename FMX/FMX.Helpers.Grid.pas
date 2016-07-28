unit FMX.Helpers.Grid;

interface

uses
  FMX.Header,
  FMX.Grid;

type
{$REGION 'TGridHelper'}
  TGridHelper = class helper for TCustomGrid
  public
    /// <summary> Devuelve el objeto THeader del TGrid </summary>
    function Header: THeader;
  end;
{$ENDREGION}

implementation

{$REGION 'TGridHelper'}

function TGridHelper.Header: THeader;
begin
  Result := Self.FHeader;
end;

{$ENDREGION}

end.
