unit MercadoLibre.Vcl.OAuthUI;

interface

uses
  MercadoLibre.Services,
  SHDocVw,
  System.Classes,
  Vcl.Forms,
  Vcl.OleCtrls,
  Vcl.Controls,
  Vcl.WinXCtrls;

type
{$REGION 'TAuthenticationVclForm'}
  TAuthenticationVclForm = class(TForm, IMercadoLibreAuthenticator)
    WebBrowser: TWebBrowser;
    ActivityIndicator: TActivityIndicator;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure WebBrowserNavigateComplete2(ASender: TObject; const pDisp: IDispatch; const [Ref] URL: OleVariant);
    procedure FormResize(Sender: TObject);
  strict private
    FToken: IMercadoLibreToken;
    FAcquiredToken: Boolean;
    FCurrentUrl: string;

    function GetCurrentUrl: string;
    function GetToken: IMercadoLibreToken;
    procedure SetCurrentUrl(const Value: string);
    procedure SetToken(const Value: IMercadoLibreToken);

    procedure HideLoadingIndicator;
    procedure ShowLoadingIndicator;
  strict protected
    /// <summary> Returns the Authentication URL Endpoint </summary>
    function GetAuthUrl(const ApplicationID, CallbackUrl: string): string; virtual;
    /// <summary> Returns True if the given URL contains a Token </summary>
    function ContainsToken(const Url: string): Boolean; virtual;
    /// <summary> Returns the Token from the gven URL; assumes ContainsToken is True </summary>
    function ExtractToken(const Url: string): IMercadoLibreToken; virtual;

    /// <summary> Token acquired on succesful authentication </summary>
    property Token: IMercadoLibreToken read GetToken write SetToken;
    /// <summary> Flag that controls if a Token has ben succesfuly acquired </summary>
    property AcquiredToken: Boolean read FAcquiredToken;
    /// <summary> The current URL used by the WebBrowser component </summary>
    property CurrentUrl: string read GetCurrentUrl write SetCurrentUrl;
{$REGION 'IMercadoLibreAuthenticator'}
    function AuthenticateModal(const ApplicationID, CallbackUrl: string): IMercadoLibreToken;
{$ENDREGION}
  public
    constructor Create(AOwner: TComponent); override;
  end;
{$ENDREGION}

implementation

{$R *.dfm}

uses
  MercadoLibre.Exceptions,
  System.SysUtils;

{$REGION 'TAuthenticationVclForm'}

constructor TAuthenticationVclForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ShowLoadingIndicator;
  FAcquiredToken := False;
  FToken := EmptyStr;
end;

{$REGION 'IMercadoLibreAuthenticator'}

function TAuthenticationVclForm.AuthenticateModal(const ApplicationID, CallbackUrl: string): IMercadoLibreToken;
begin
  ShowLoadingIndicator;
  CurrentUrl := GetAuthUrl(ApplicationID, CallbackURL);
  if ShowModal = mrOk then
    Result := Token
  else
    raise EAuthorizationFailed.Create('Authorization Failed');
end;

{$ENDREGION}

function TAuthenticationVclForm.GetAuthUrl(const ApplicationID, CallbackUrl: string): string;
const
  AUTH_ENDPOINT = 'https://auth.mercadolibre.com.ar/authorization?response_type=code&client_id=%s&redirect_uri=%s';
begin
  Result := Format(AUTH_ENDPOINT, [ApplicationID, CallbackUrl]);
end;

function TAuthenticationVclForm.GetCurrentUrl: string;
begin
  Result := FCurrentUrl;
end;

function TAuthenticationVclForm.ContainsToken(const Url: string): Boolean;
begin
  Result := Url.Contains('?code=');
end;

function TAuthenticationVclForm.ExtractToken(const Url: string): IMercadoLibreToken;
begin
  Result := Copy(Url, Url.IndexOf('?code=') + 1, Integer.MaxValue).Replace('?code=', '');
end;

procedure TAuthenticationVclForm.HideLoadingIndicator;
begin
  WebBrowser.Visible := True;
  ActivityIndicator.Animate := False;
  ActivityIndicator.Visible := False;
end;

procedure TAuthenticationVclForm.ShowLoadingIndicator;
begin
  WebBrowser.Visible := False;
  ActivityIndicator.Animate := True;
  ActivityIndicator.Visible := True;
end;

{$REGION 'Properties'}

function TAuthenticationVclForm.GetToken: IMercadoLibreToken;
begin
  if AcquiredToken then
    Result := FToken
  else
    Result := EmptyStr;
end;

procedure TAuthenticationVclForm.SetCurrentUrl(const Value: string);
begin
  FCurrentUrl := Value;
  WebBrowser.Navigate2(FCurrentUrl);
end;

procedure TAuthenticationVclForm.SetToken(const Value: IMercadoLibreToken);
begin
  FToken := Trim(Value);
  FAcquiredToken := FToken <> EmptyStr;
end;

{$ENDREGION}

{$REGION 'Event Handlers'}

procedure TAuthenticationVclForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TAuthenticationVclForm.FormResize(Sender: TObject);
begin
  ActivityIndicator.Left := (Width div 2) - (ActivityIndicator.Width);
  ActivityIndicator.Top := (Height div 2) - (ActivityIndicator.Height);
end;

procedure TAuthenticationVclForm.WebBrowserNavigateComplete2(ASender: TObject; const pDisp: IDispatch;
  const [Ref] URL: OleVariant);
begin
  FCurrentUrl := URL;
  HideLoadingIndicator;
  if ContainsToken(CurrentUrl) then
  begin
    Token := ExtractToken(CurrentUrl);
    if AcquiredToken then
    begin
      WebBrowser.Stop;
      ModalResult := mrOk;
    end;
  end;
end;

{$ENDREGION}

{$ENDREGION}

end.
