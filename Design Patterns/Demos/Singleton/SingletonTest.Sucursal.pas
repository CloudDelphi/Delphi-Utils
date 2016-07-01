unit SingletonTest.Sucursal;

interface

type
  TSucursal = class
  private
    FNumero: Integer;
    FNombre: string;
    procedure SetNombre(const Value: string);
    procedure SetNumero(const Value: Integer);
  public
    property Numero: Integer read FNumero write SetNumero;
    property Nombre: string read FNombre write SetNombre;
  end;

implementation

{ TSucursal }

procedure TSucursal.SetNombre(const Value: string);
begin
  FNombre := Value;
end;

procedure TSucursal.SetNumero(const Value: Integer);
begin
  FNumero := Value;
end;

end.
