program Pattern_Singleton;

uses
  Forms,
  uSingletonMainTest in 'uSingletonMainTest.pas' {Form3},
  SingletonTest.Sucursal in 'SingletonTest.Sucursal.pas',
  SingletonTest.Persona in 'SingletonTest.Persona.pas',
  Patterns.Singleton.SpringRepository in '..\..\Patterns.Singleton.SpringRepository.pas',
  SingletonTest.Trabajador in 'SingletonTest.Trabajador.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
