program Pattern_Singleton;

uses
  Forms,
  uSingletonMainTest in 'uSingletonMainTest.pas' {Form3},
  Patterns.Singleton in 'E:\Delphi\Extensions\Design Patterns\Patterns.Singleton.pas',
  SingletonTest.Sucursal in 'SingletonTest.Sucursal.pas',
  SingletonTest.Persona in 'SingletonTest.Persona.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
