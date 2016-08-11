unit MercadoLibre.Win.WebBrowser;

interface

uses
  Win.WebBrowser; // See https://github.com/ortuagustin/Delphi-Utils/blob/master/Win/Win.WebBrowser.pas

type
{$REGION 'TWinWebBrowserFix'}
  /// <summary> Enables Internet Explorer 11 emulation support for TWebBrowser components (both Vcl and FMX) </summary>
  TWinWebBrowserFix = record
  private
    class var FIEEmulatorSupport: TWinWebBrowserEmulation;
    class function GetIEEmulatorSupport: TWinWebBrowserEmulation; static;
    class property IEEmulatorSupport: TWinWebBrowserEmulation read GetIEEmulatorSupport;
  public
    /// <summary> Tweaks the Windows Registry to enable Internet Explorer 11 Emulation Support for TWebBrowser </summary>
    class procedure EnableIE11EmulationSupport; static;
    /// <summary> Undo the change to the Windows Registry done on EnableIE11EmulationSupport </summary>
    class procedure RestoreEmulationSupport; static;
  end;
{$ENDREGION}

implementation

{$REGION 'TWinWebBrowserFix'}

class function TWinWebBrowserFix.GetIEEmulatorSupport: TWinWebBrowserEmulation;
begin
  if not Assigned(FIEEmulatorSupport) then
    FIEEmulatorSupport := TWinWebBrowserEmulation.Create;

  Result := FIEEmulatorSupport;
end;

class procedure TWinWebBrowserFix.EnableIE11EmulationSupport;
begin
  IEEmulatorSupport.EnableBrowserEmulation(TInternetExplorerVersion.IE11);
end;

class procedure TWinWebBrowserFix.RestoreEmulationSupport;
begin
  IEEmulatorSupport.RestoreBrowserEmulation;
  IEEmulatorSupport.Free;
end;

{$ENDREGION}

initialization

TWinWebBrowserFix.EnableIE11EmulationSupport;

finalization

TWinWebBrowserFix.RestoreEmulationSupport;

end.
