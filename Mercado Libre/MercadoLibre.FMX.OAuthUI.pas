unit MercadoLibre.FMX.OAuthUI;

interface

uses
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
    FToken: TMercadoLibreToken;
    FAcquiredToken: Boolean;

    function GetCurrentUrl: string;
    function GetToken: TMercadoLibreToken;
    procedure SetToken(const Value: TMercadoLibreToken);

    procedure HideLoadingIndicator;
    procedure ShowLoadingIndicator;
  strict protected
    /// <summary> Returns the Authentication URL Endpoint </summary>
    function GetAuthUrl(const ApplicationID, CallbackUrl: string): string; virtual;
    /// <summary> Returns True if the given URL contains a Token </summary>
    function ContainsToken(const Url: string): Boolean; virtual;
    /// <summary> Returns the Token from the gven URL; assumes ContainsToken is True </summary>
    function ExtractToken(const Url: string): TMercadoLibreToken; virtual;

    /// <summary> Token acquired on succesful authentication </summary>
    property Token: TMercadoLibreToken read GetToken write SetToken;
    /// <summary> Flag that controls if a Token has ben succesfuly acquired </summary>
    property AcquiredToken: Boolean read FAcquiredToken;
    /// <summary> The current URL used by the WebBrowser component </summary>
    property CurrentUrl: string read GetCurrentUrl;
{$REGION 'IMercadoLibreAuthenticator'}
    function AuthenticateModal(const ApplicationID, CallbackUrl: string): TMercadoLibreToken;
{$ENDREGION}
  public
    constructor Create(AOwner: TComponent); override;
  end;
{$ENDREGION}

implementation

{$R *.fmx}

uses
  MercadoLibre.Exceptions,
  System.SysUtils;

{$REGION 'TAuthenticationFMXForm'}

constructor TAuthenticationFMXForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ShowLoadingIndicator;
  FAcquiredToken := False;
  FToken := EmptyStr;
end;

{$REGION 'IMercadoLibreAuthenticator'}

function TAuthenticationFMXForm.AuthenticateModal(const ApplicationID, CallbackUrl: string): TMercadoLibreToken;
begin
  ShowLoadingIndicator;
  WebBrowser.URL := GetAuthUrl(ApplicationID, CallbackURL);
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

function TAuthenticationFMXForm.ContainsToken(const Url: string): Boolean;
begin
  Result := Url.Contains('?code=');
end;

function TAuthenticationFMXForm.ExtractToken(const Url: string): TMercadoLibreToken;
begin
  Result := Copy(Url, Url.IndexOf('?code=') + 1, Integer.MaxValue).Replace('?code=', '');
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

function TAuthenticationFMXForm.GetToken: TMercadoLibreToken;
begin
  if AcquiredToken then
    Result := FToken
  else
    Result := EmptyStr;
end;

procedure TAuthenticationFMXForm.SetToken(const Value: TMercadoLibreToken);
begin
  FToken := Trim(Value);
  FAcquiredToken := FToken <> EmptyStr;
end;

{$ENDREGION}

{$REGION 'Event Handlers'}

procedure TAuthenticationFMXForm.WebBrowserDidFinishLoad(ASender: TObject);
begin
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

procedure TAuthenticationFMXForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

{$ENDREGION}

{$ENDREGION}

end.
