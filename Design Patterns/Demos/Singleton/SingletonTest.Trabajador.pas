unit SingletonTest.Trabajador;

interface

uses
  SingletonTest.Persona;

type
  TTrabajador = class(TPersona)
  private
    FSalario: Currency;
    procedure SetSalario(const Value: Currency);
  public
    property Salario: Currency read FSalario write SetSalario;
  end;

implementation

{ TTrabajador }

procedure TTrabajador.SetSalario(const Value: Currency);
begin
  FSalario := Value;
end;

end.
