unit MercadoLibre.FMX.OAuthUI;

interface

uses
  MercadoLibre.Token,
  MercadoLibre.Services,
  System.UITypes,
  System.Classes,
  FMX.Forms,
  FMX.Types,
  FMX.Controls,
  FMX.WebBrowser,
  FMX.StdCtrls;

type
{$REGION 'TAuthenticationFMXForm'}
  TAuthenticationFMXForm = class(TForm, IMercadoLibreAuthenticator)
    WebBrowser: TWebBrowser;
    AniIndicator: TAniIndicator;
    procedure WebBrowserDidFinishLoad(ASender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  strict private
    FToken: IMercadoLibreToken;
    FApplicationID: string;
    FCallbackUrl: string;
    FApplicationSecret: string;
    FAuthorizationCode: string;
    FAcquiredToken: Boolean;

    function GetCurrentUrl: string;
    function GetToken: IMercadoLibreToken;
    procedure SetToken(const Value: IMercadoLibreToken);
    procedure SetAuthorizationCode(const Value: string);

    procedure HideLoadingIndicator;
    procedure ShowLoadingIndicator;
  strict protected
    /// <summary> Returns the Authentication URL Endpoint </summary>
    function GetAuthUrl(const ApplicationID, CallbackUrl: string): string;
    /// <summary> Returns True if the given URL contains an AuthorizationCode </summary>
    function ContainsAuthorizationCode(const Url: string): Boolean;
    /// <summary> Returns the AuthorizationCode from the gven URL; assumes ContainsToken is True </summary>
    function ExtractAuthorizationCode(const Url: string): string;
    /// <summary> Returns the Access Token from the JSON string </summary>
    function ExtractToken(const JSON: string): IMercadoLibreToken;

    /// <summary> Authorization Code used to exchange for a Token </summary>
    property AuthorizationCode: string read FAuthorizationCode write SetAuthorizationCode;
    /// <summary> Token acquired on succesful authentication </summary>
    property Token: IMercadoLibreToken read GetToken write SetToken;
    /// <summary> Flag that controls if a Token has ben succesfuly acquired </summary>
    property AcquiredToken: Boolean read FAcquiredToken;
    /// <summary> The current URL used by the WebBrowser component </summary>
    property CurrentUrl: string read GetCurrentUrl;
{$REGION 'IMercadoLibreAuthenticator'}
    function AuthenticateModal(const ApplicationID, ApplicationSecret, CallbackUrl: string): IMercadoLibreToken;
{$ENDREGION}
  public
    constructor Create(AOwner: TComponent); override;
  end;
{$ENDREGION}

implementation

{$R *.fmx}

uses
  MercadoLibre.Http,
  MercadoLibre.Exceptions,
  MercadoLibre.Http.NetHttp,
  System.SysUtils;

{$REGION 'TAuthenticationFMXForm'}

constructor TAuthenticationFMXForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ShowLoadingIndicator;
  FAcquiredToken := False;
  FAuthorizationCode := EmptyStr;
  FApplicationID := EmptyStr;
  FCallbackUrl := EmptyStr;
end;

{$REGION 'IMercadoLibreAuthenticator'}

function TAuthenticationFMXForm.AuthenticateModal(const ApplicationID, ApplicationSecret,
  CallbackUrl: string): IMercadoLibreToken;
begin
  FApplicationID := ApplicationID;
  FCallbackUrl := CallbackURL;
  FApplicationSecret := ApplicationSecret;
  ShowLoadingIndicator;
  WebBrowser.URL := GetAuthUrl(FApplicationID, FCallbackUrl);
  if ShowModal = mrOk then
    Result := Token
  else
    raise EAuthorizationFailed.Create('Authorization Failed');
end;

{$ENDREGION}

function TAuthenticationFMXForm.GetAuthUrl(const ApplicationID, CallbackUrl: string): string;
const
  AUTH_ENDPOINT = 'https://auth.mercadolibre.com.ar/authorization?response_type=code&client_id=%s&redirect_uri=%s';
begin
  Result := Format(AUTH_ENDPOINT, [ApplicationID, CallbackUrl]);
end;

function TAuthenticationFMXForm.GetCurrentUrl: string;
begin
  Result := WebBrowser.URL;
end;

function TAuthenticationFMXForm.ContainsAuthorizationCode(const Url: string): Boolean;
begin
  Result := Url.Contains('?code=');
end;

function TAuthenticationFMXForm.ExtractAuthorizationCode(const Url: string): string;
begin
  Result := Copy(Url, Url.IndexOf('?code=') + 1, Integer.MaxValue).Replace('?code=', '');
end;

function TAuthenticationFMXForm.ExtractToken(const JSON: string): IMercadoLibreToken;
begin
  Result := TToken.Parse(JSON);
end;

procedure TAuthenticationFMXForm.HideLoadingIndicator;
begin
  WebBrowser.Visible := True;
  AniIndicator.Enabled := False;
  AniIndicator.Visible := False;
end;

procedure TAuthenticationFMXForm.ShowLoadingIndicator;
begin
  WebBrowser.Visible := False;
  AniIndicator.Enabled := True;
  AniIndicator.Visible := True;
end;

{$REGION 'Properties'}

function TAuthenticationFMXForm.GetToken: IMercadoLibreToken;
begin
  if AcquiredToken then
    Result := FToken;
end;

procedure TAuthenticationFMXForm.SetAuthorizationCode(const Value: string);
const
  TOKEN_EXHANGE_URL = 'https://api.mercadolibre.com/oauth/token?grant_type=authorization_code&client_id=%s&client_secret=%s&code=%s&redirect_uri=%s';
var
  HttpClient: IMercadoLibreHttpClient;
begin
  HttpClient := TMercadoLibreNetHttpClient.Create;
  FAuthorizationCode := Trim(Value);
  Token := ExtractToken(HttpClient.Post(Format(TOKEN_EXHANGE_URL, [FApplicationID, FApplicationSecret, FAuthorizationCode, FCallbackUrl])));
end;

procedure TAuthenticationFMXForm.SetToken(const Value: IMercadoLibreToken);
begin
  if Value.AccessToken <> EmptyStr then
  begin
    FToken := Value;
    FAcquiredToken := True;
  end
  else
    FAcquiredToken := False;
end;

{$ENDREGION}

{$REGION 'Event Handlers'}

procedure TAuthenticationFMXForm.WebBrowserDidFinishLoad(ASender: TObject);
begin
  if not AcquiredToken then
  begin
    HideLoadingIndicator;
    if ContainsAuthorizationCode(CurrentUrl) then
      AuthorizationCode := ExtractAuthorizationCode(CurrentUrl);
  end
  else
  begin
    WebBrowser.Stop;
    ModalResult := mrOk;
  end;
end;

procedure TAuthenticationFMXForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

{$ENDREGION}

{$ENDREGION}

end.
