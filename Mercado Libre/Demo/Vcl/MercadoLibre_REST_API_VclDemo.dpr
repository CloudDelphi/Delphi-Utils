program MercadoLibre_REST_API_VclDemo;

uses
  Vcl.Forms,
  UI.Main in 'UI.Main.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
