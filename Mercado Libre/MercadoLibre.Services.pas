unit MercadoLibre.Services;

interface

uses
  MercadoLibre.Token,
  MercadoLibre.Exceptions;

type
{$REGION 'IMercadoLibreService'}
  /// <summary> Base interface inherited for all Mercado Libre services </summary>
  IMercadoLibreService = interface
    ['{DB1C8225-F72B-4E36-A633-3516E032DBE2}']
  end;
{$ENDREGION}

{$REGION 'IMercadoLibreAuthenticator'}
  /// <summary> Implements a MercadoLibre OAuth flow </summary>
  IMercadoLibreAuthenticator = interface(IMercadoLibreService)
    ['{7A5960EC-52A8-4C47-9477-754647568F86}']
    /// <summary>
    ///   Show a Modal Window with an embedded Web Browser component that will prompt
    ///  the user to authorize your application. The user will need to log in in his Mercado Libre Account
    ///  The Window will be closed automatically when it detects the token and return it
    ///  If the Window is closed by the user, or the user fails to log in, an EAuthorizationFailed exception is raised
    ///  - ApplicationID: The ID generated for your Application by Mercado Libre
    ///  - CallbackURL: The callback URL configured for your Application or one of the allowed domains
    /// </summary>
    function AuthenticateModal(const ApplicationID, ApplicationSecret, CallbackUrl: string): IMercadoLibreToken;
  end;
{$ENDREGION}

implementation

end.
