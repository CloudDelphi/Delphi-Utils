unit MercadoLibre.Http.NetHttp;

interface

uses
  MercadoLibre.Http,
  System.Net.URLClient,
  System.Net.HttpClient,
  System.Net.HttpClientComponent;

type
{$REGION 'TMercadoLibreNetHttpClient'}
  TMercadoLibreNetHttpClient = class(TInterfacedObject, IMercadoLibreHttpClient)
  strict private
    FHttpClient: TNetHTTPClient;
    FHttpRequest: TNetHTTPRequest;

{$REGION 'IMercadoLibreHttpClient'}
    function Post(const Url: string): TMercadoLibreHttpResponse;
    function Get(const Url: string): TMercadoLibreHttpResponse;
{$ENDREGION}
  public
    constructor Create;
    destructor Destroy; override;
  end;
{$ENDREGION}

implementation

uses
  System.SysUtils;

{$REGION 'TMercadoLibreNetHttpClient'}

constructor TMercadoLibreNetHttpClient.Create;
begin
  inherited Create;
  FHttpClient := TNetHTTPClient.Create(nil);
  FHttpClient.AllowCookies := True;
  FHttpClient.HandleRedirects := True;

  FHttpRequest := TNetHTTPRequest.Create(nil);
  FHttpRequest.Client := FHttpClient;
end;

destructor TMercadoLibreNetHttpClient.Destroy;
begin
  FHttpClient.Free;
  FHttpRequest.Free;
  inherited Destroy;
end;

{$REGION 'IMercadoLibreHttpClient'}

function TMercadoLibreNetHttpClient.Get(const Url: string): TMercadoLibreHttpResponse;
begin
  Result := FHttpRequest.Get(Url).ContentAsString(TEncoding.UTF8);
end;

function TMercadoLibreNetHttpClient.Post(const Url: string): TMercadoLibreHttpResponse;
begin
  FHttpRequest.URL := Url;
  FHttpRequest.MethodString := 'POST';
  Result := FHttpRequest.Execute.ContentAsString(TEncoding.UTF8);
end;

{$ENDREGION}

{$ENDREGION}

end.
