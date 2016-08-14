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
    edApplicationSecret: TEdit;
    Label2: TLabel;
    edToken: TEdit;
    Label3: TLabel;
    edCallbackUrl: TEdit;
    Label4: TLabel;
    procedure btnGetTokenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function ApplicationID: string;
    function CallbackURL: string;
    function ApplicationSecret: string;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses
  MercadoLibre.Token,
  MercadoLibre.Services,
  MercadoLibre.Win.WebBrowser, // add this unit to add IE11 Emulation Support for TWebBrowser
  MercadoLibre.FMX.OAuthUI;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
  edApplicationID.Text := '2010039294220063';
  edCallbackUrl.Text := 'https://www.google.com.ar/';
  edApplicationSecret.Text := 'ouq0j1OJ5BbArRgQDSEqc9MSGxZISosr';
end;

function TMainForm.ApplicationID: string;
begin
  Result := edApplicationID.Text;
end;

function TMainForm.CallbackURL: string;
begin
  Result := edCallbackUrl.Text;
end;

function TMainForm.ApplicationSecret: string;
begin
  Result := edApplicationSecret.Text;
end;

procedure TMainForm.btnGetTokenClick(Sender: TObject);
var
  OAuthUI: IMercadoLibreAuthenticator;
  Token: IMercadoLibreToken;
begin
  edToken.Text := '';
  OAuthUI := TAuthenticationFMXForm.Create(Self);
  Token := OAuthUI.AuthenticateModal(ApplicationID, ApplicationSecret, CallbackUrl);
  if Token.AccessToken <> '' then
  begin
    edToken.Text := Token.AccessToken;
    edToken.SetFocus;
    edToken.SelectAll;
  end;
end;

end.
