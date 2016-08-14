unit MercadoLibre.Token;

interface

uses
  System.JSON;

type
{$REGION 'TTokenScope'}
{$SCOPEDENUMS ON}
  /// <summary> The diferent scopes that a Token is allowed to operate on </summary>
  TTokenScope = (
    /// <summary> The Token may Read data </summary>
    Read,
    /// <summary> The Token may Write data </summary>
    Write,
    /// <summary>
    ///   The Token may operate on a Offline basis, that is, the user grants permission once and then the bearer may
    ///  request a refresh without explicitly asking the user
    /// </summary>
    Offline_Access
  );
{$SCOPEDENUMS OFF}

  TTokenScopes = set of TTokenScope;
{$ENDREGION}

{$REGION 'IMercadoLibreToken'}
  /// <summary> Token returned on succesful Authentication </summary>
  IMercadoLibreToken = interface
    ['{888470DB-AB11-491F-8FF1-6F1C943F7EFF}']
    function GetAccessToken: string;
    function GetTokenType: string;
    function GetSecondsToExpiration: UInt32;
    function GetScopes: TTokenScopes;

    /// <summary> The Access Token used to access the diferent services </summary>
    property AccessToken: string read GetAccessToken;
    /// <summary> The Token Type, for example "Bearer" </summary>
    property TokenType: string read GetTokenType;
    /// <summary> Time in seconds left for the Token to expire </summary>
    property SecondsToExpiration: UInt32 read GetSecondsToExpiration;
    /// <summary> The scopes that the token is allowed to operate on </summary>
    property Scopes: TTokenScopes read GetScopes;
  end;
{$ENDREGION}

{$REGION 'IMercadoLibreRefreshToken'}
  /// <summary>
  ///   Refresh Tokens may be obtained to gain access again once a Access Token has expired
  ///  They require succesful authorization with offline-access scope and an Access Token already received
  /// </summary>
  IMercadoLibreRefreshToken = interface(IMercadoLibreToken)
    ['{6CB4DE10-9EF7-43CD-86A7-1FF85CB6A0E4}']
    function GetRefreshToken: string;
      /// <summary> The Refresh Token used to get a new Access Token </summary>
    property RefreshToken: string read GetRefreshToken;
  end;
{$ENDREGION}

{$REGION 'TToken'}
  /// <summary> Factory that parses and returns the IMercadoLibreToken from a given JSON string </summary>
  TToken = record
  strict private
    /// <summary> Returns the corresponding TTokenScopes Flags from the given JSON string </summary>
    class function TokenScopesFromJSON(const JSON: string): TTokenScopes; static;
    /// <summary> Checks if the JSONResponse represents an error and raises an raises an EInvalidToken </summary>
    class procedure CheckIsError(JSONResponse: TJSONObject); static;
    /// <summary> Checks if the JSONResponse represents a Refresh Token and returns a decorated Token with the Refresh Token value </summary>
    class function CheckIsRefreshToken(const JSONResponse: TJSONObject;
      const Token: IMercadoLibreToken): IMercadoLibreToken; static;
  public
    /// <summary> Parses the JSON string and returns the Access Token </summary>
    class function Parse(const JSON: string): IMercadoLibreToken; static;
  end;
{$ENDREGION}

implementation

uses
  MercadoLibre.Exceptions,
  System.SysUtils;

type
{$REGION 'TJSONObjectHelper'}
  TJSONObjectHelper = class helper for TJSONObject
  public
    /// <summary> Returns True if the JSONObject contains the given Value </summary>
    function ContainsValue(const Name: string): Boolean;
  end;
{$ENDREGION}

{$REGION 'TAbstractToken'}
  TAbstractToken = class abstract(TInterfacedObject, IMercadoLibreToken)
  strict protected
{$REGION 'IMercadoLibreToken'}
    function GetAccessToken: string; virtual; abstract;
    function GetTokenType: string; virtual; abstract;
    function GetSecondsToExpiration: UInt32; virtual; abstract;
    function GetScopes: TTokenScopes; virtual; abstract;
{$ENDREGION}
  end;
{$ENDREGION}

{$REGION 'TNullToken'}
  /// <summary> Implements a Null IMercadoLibreToken </summary>
  TNullToken = class(TAbstractToken)
  strict protected
    function GetAccessToken: string; override;
    function GetTokenType: string; override;
    function GetSecondsToExpiration: UInt32; override;
    function GetScopes: TTokenScopes; override;
  end;
{$ENDREGION}

{$REGION 'TMercadoLibreToken'}
  TMercadoLibreToken = class(TAbstractToken)
  strict private
    FAccessToken: string;
    FTokenType: string;
    FSecondsToExpiration: UInt32;
    FScopes: TTokenScopes;

    procedure SetAccessToken(const Value: string);
    procedure SetTokenType(const Value: string);
    procedure SetSecondsToExpiration(const Value: UInt32);
    procedure SetScopes(const Value: TTokenScopes);
  strict protected
    function GetAccessToken: string; override;
    function GetTokenType: string; override;
    function GetSecondsToExpiration: UInt32; override;
    function GetScopes: TTokenScopes; override;
  protected
    property AccessToken: string read GetAccessToken write SetAccessToken;
    property TokenType: string read GetTokenType write SetTokenType;
    property SecondsToExpiration: UInt32 read GetSecondsToExpiration write SetSecondsToExpiration;
    property Scopes: TTokenScopes read GetScopes write SetScopes;
  end;
{$ENDREGION}

{$REGION 'TMercadoLibreRefreshToken'}
  TMercadoLibreRefreshToken = class(TAbstractToken, IMercadoLibreRefreshToken)
  strict private
    FToken: IMercadoLibreToken;
    FRefreshToken: string;
    function GetRefreshToken: string;
  strict protected
    function GetAccessToken: string; override;
    function GetTokenType: string; override;
    function GetSecondsToExpiration: UInt32; override;
    function GetScopes: TTokenScopes; override;

    property Token: IMercadoLibreToken read FToken;
    property RefreshToken: string read GetRefreshToken;
  public
    constructor Create(const AToken: IMercadoLibreToken; const ARefreshToken: string);
  end;
{$ENDREGION}

{$REGION 'TJSONObjectHelper'}

function TJSONObjectHelper.ContainsValue(const Name: string): Boolean;
begin
  Result := Assigned(Values[Name]);
end;

{$ENDREGION}

{$REGION 'TNullToken'}

function TNullToken.GetAccessToken: string;
begin
  Result := EmptyStr;
end;

function TNullToken.GetScopes: TTokenScopes;
begin
  Result := [];
end;

function TNullToken.GetSecondsToExpiration: UInt32;
begin
  Result := 0;
end;

function TNullToken.GetTokenType: string;
begin
  Result := EmptyStr;
end;

{$ENDREGION}

{$REGION 'TMercadoLibreToken'}

function TMercadoLibreToken.GetAccessToken: string;
begin
  Result := FAccessToken;
end;

function TMercadoLibreToken.GetScopes: TTokenScopes;
begin
  Result := FScopes;
end;

function TMercadoLibreToken.GetSecondsToExpiration: UInt32;
begin
  Result := FSecondsToExpiration;
end;

function TMercadoLibreToken.GetTokenType: string;
begin
  Result := FTokenType;
end;

procedure TMercadoLibreToken.SetAccessToken(const Value: string);
begin
  FAccessToken := Value;
end;

procedure TMercadoLibreToken.SetScopes(const Value: TTokenScopes);
begin
  FScopes := Value;
end;

procedure TMercadoLibreToken.SetSecondsToExpiration(const Value: UInt32);
begin
  FSecondsToExpiration := Value;
end;

procedure TMercadoLibreToken.SetTokenType(const Value: string);
begin
  FTokenType := Value;
end;

{$ENDREGION}

{$REGION 'TMercadoLibreRefreshToken'}

constructor TMercadoLibreRefreshToken.Create(const AToken: IMercadoLibreToken; const ARefreshToken: string);
begin
  if not Assigned(AToken) then
    raise Exception.CreateFmt('%s.Create :: AToken is not assigned', [QualifiedClassName]);

  inherited Create;
  FToken := AToken;
  FRefreshToken := ARefreshToken;
end;

function TMercadoLibreRefreshToken.GetRefreshToken: string;
begin
  Result := FRefreshToken;
end;

function TMercadoLibreRefreshToken.GetAccessToken: string;
begin
  Result := Token.AccessToken;
end;

function TMercadoLibreRefreshToken.GetScopes: TTokenScopes;
begin
  Result := Token.Scopes;
end;

function TMercadoLibreRefreshToken.GetSecondsToExpiration: UInt32;
begin
  Result := Token.SecondsToExpiration;
end;

function TMercadoLibreRefreshToken.GetTokenType: string;
begin
  Result := Token.TokenType;
end;

{$ENDREGION}

{$REGION 'TToken'}

class function TToken.TokenScopesFromJSON(const JSON: string): TTokenScopes;
begin
  Result := [];

  if JSON.Contains('read') then
    Result := Result + [TTokenScope.Read];

  if JSON.Contains('write') then
    Result := Result + [TTokenScope.Write];

  if JSON.Contains('offline_access') then
    Result := Result + [TTokenScope.Offline_Access];
end;

class procedure TToken.CheckIsError(JSONResponse: TJSONObject);
begin
  if JSONResponse.ContainsValue('message') then
    raise EInvalidToken.Create(JSONResponse.ToString);
end;

class function TToken.CheckIsRefreshToken(const JSONResponse: TJSONObject; const Token: IMercadoLibreToken): IMercadoLibreToken;
begin
  if JSONResponse.ContainsValue('refresh_token') then
    Result := TMercadoLibreRefreshToken.Create(Token, JSONResponse.Values['refresh_token'].Value)
  else
    Result := Token;
end;

class function TToken.Parse(const JSON: string): IMercadoLibreToken;
var
  JSONResponse: TJSONObject;
  Instance: TMercadoLibreToken;
begin
  if JSON.IsEmpty then
    Exit(TNullToken.Create);

  JSONResponse := TJSONObject(TJSONObject.ParseJSONValue(JSON));

  try
    CheckIsError(JSONResponse);
    Instance := TMercadoLibreToken.Create;
    Instance.AccessToken := JSONResponse.Values['access_token'].Value;
    Instance.TokenType := JSONResponse.Values['token_type'].Value;
    Instance.SecondsToExpiration := TJSONNumber(JSONResponse.Values['expires_in']).AsInt;
    Instance.Scopes := TokenScopesFromJSON(JSONResponse.Values['scope'].Value);
    Result := CheckIsRefreshToken(JSONResponse, Instance);
  finally
    JSONResponse.Free;
  end;
end;

{$ENDREGION}

end.
