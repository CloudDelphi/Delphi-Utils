unit MercadoLibre.Exceptions;

interface

uses
  System.SysUtils;

type
  /// <summary> Base Library Exception class </summary>
  EMercadoLibreException = class abstract(Exception);

  /// <summary> Raised when an Authorization fails </summary>
  EAuthorizationFailed = class(EMercadoLibreException);

implementation

end.
