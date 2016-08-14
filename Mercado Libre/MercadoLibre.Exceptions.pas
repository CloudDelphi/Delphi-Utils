unit MercadoLibre.Exceptions;

interface

uses
  System.SysUtils;

type
  /// <summary> Base Library Exception class </summary>
  EMercadoLibreException = class abstract(Exception);

  /// <summary> Raised when an Authorization fails </summary>
  EAuthorizationFailed = class(EMercadoLibreException);

  /// <summary> Raised when failed to get an Access Token </summary>
  EInvalidToken = class(EMercadoLibreException)
  private
    FJSON: string;
//    function GetErrorMessage: string;
  public
    constructor Create(const RawJSON: string);
//    property ErrorMessage: string read GetErrorMessage;
  end;

implementation

{$REGION 'EInvalidToken'}

constructor EInvalidToken.Create(const RawJSON: string);
begin
  inherited Create(RawJSON);
  FJSON := RawJSON;
end;

{$ENDREGION}

end.
