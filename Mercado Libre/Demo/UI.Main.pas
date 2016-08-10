unit UI.Main;

interface

uses
  System.Classes,
  FMX.Forms,
  FMX.Edit,
  FMX.Types,
  FMX.StdCtrls,
  FMX.Controls,
  FMX.Controls.Presentation;

type
  TMainForm = class(TForm)
    btnGetToken: TButton;
    edApplicationID: TEdit;
    Label1: TLabel;
    edCallbackUrl: TEdit;
    Label2: TLabel;
    edToken: TEdit;
    Label3: TLabel;
    procedure btnGetTokenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function ApplicationID: string;
    function CallbackURL: string;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses
  MercadoLibre.Services,
  MercadoLibre.FMX.OAuthUI;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
  edApplicationID.Text := '2010039294220063';
  edCallbackUrl.Text := 'https://www.google.com.ar/';
end;

function TMainForm.ApplicationID: string;
begin
  Result := edApplicationID.Text;
end;

function TMainForm.CallbackURL: string;
begin
  Result := edCallbackUrl.Text;
end;

procedure TMainForm.btnGetTokenClick(Sender: TObject);
var
  OAuthUI: IMercadoLibreAuthenticator;
  Token: TMercadoLibreToken;
begin
  edToken.Text := '';
  OAuthUI := TAuthenticationFMXForm.Create(Self);
  Token := OAuthUI.AuthenticateModal(ApplicationID, CallbackUrl);
  if Token <> '' then
  begin
    edToken.Text := Token;
    edToken.SetFocus;
    edToken.SelectAll;
  end;
end;

end.
