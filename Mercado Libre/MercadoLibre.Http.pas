unit MercadoLibre.Http;

interface

type
  TMercadoLibreHttpResponse = type string;

{$REGION 'IMercadoLibreHttpClient'}
  /// <summary> Sends HTTP requests and fetches the response as an UTF-8 encoded JSON string </summary>
  IMercadoLibreHttpClient = interface
    ['{9D784EA0-FF9D-4FBF-95C1-0BAF1F53D137}']
    /// <summary> Sends a POST request </summary>
    function Post(const Url: string): TMercadoLibreHttpResponse;
    /// <summary> Sends a GET request </summary>
    function Get(const Url: string): TMercadoLibreHttpResponse;
  end;
{$ENDREGION}

implementation

end.
