program MercadoLibre_REST_API_FMXDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UI.Main in 'UI.Main.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
