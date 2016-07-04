program Pattern_Singleton;

uses
  Forms,
  uSingletonMainTest in 'uSingletonMainTest.pas' {Form3},
  Patterns.Singleton in '..\..\Patterns.Singleton.pas',
  SingletonTest.Sucursal in 'SingletonTest.Sucursal.pas',
  SingletonTest.Persona in 'SingletonTest.Persona.pas',
  Patterns.Singleton.Repository in '..\..\Patterns.Singleton.Repository.pas',
  Patterns.Singleton.DefaultRepository in '..\..\Patterns.Singleton.DefaultRepository.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
