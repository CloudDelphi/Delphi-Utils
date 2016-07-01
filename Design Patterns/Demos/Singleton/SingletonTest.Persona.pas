unit SingletonTest.Persona;

interface

type
  TPersona = class
  private
    FNombre: string;
    procedure SetNombre(const Value: string);
  public
    property Nombre: string read FNombre write SetNombre;
  end;

implementation

{ TPersona }

procedure TPersona.SetNombre(const Value: string);
begin
  FNombre := Value;
end;

end.
