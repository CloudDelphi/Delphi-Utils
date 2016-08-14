unit UI.Main;

interface

uses
  System.Classes,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.Controls,
  Vcl.ExtCtrls;

type
  TMainForm = class(TForm)
    edApplicationID: TLabeledEdit;
    edCallbackUrl: TLabeledEdit;
    edToken: TLabeledEdit;
    btnGetToken: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnGetTokenClick(Sender: TObject);
  private
    function CallbackUrl: string;
    function ApplicationID: string;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  MercadoLibre.Services,
  MercadoLibre.Win.WebBrowser, // add this unit to add IE11 Emulation Support for TWebBrowser
  MercadoLibre.Vcl.OAuthUI;

function TMainForm.ApplicationID: string;
begin
  Result := edApplicationID.Text;
end;

procedure TMainForm.btnGetTokenClick(Sender: TObject);
var
  OAuthUI: IMercadoLibreAuthenticator;
  Token: IMercadoLibreToken;
begin
  edToken.Text := '';
  OAuthUI := TAuthenticationVclForm.Create(Self);
  Token := OAuthUI.AuthenticateModal(ApplicationID, CallbackUrl);
  if Token <> '' then
  begin
    edToken.Text := Token;
    edToken.SetFocus;
    edToken.SelectAll;
  end;
end;

function TMainForm.CallbackUrl: string;
begin
  Result := edCallbackUrl.Text;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
  edApplicationID.Text := '2010039294220063';
  edCallbackUrl.Text := 'https://www.google.com.ar/';
end;

end.
