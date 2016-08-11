object AuthenticationVclForm: TAuthenticationVclForm
  Left = 0
  Top = 0
  Caption = 'OAuth Login'
  ClientHeight = 600
  ClientWidth = 900
  Color = clWindow
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 17
  object WebBrowser: TWebBrowser
    Left = 0
    Top = 0
    Width = 900
    Height = 600
    Align = alClient
    TabOrder = 0
    OnNavigateComplete2 = WebBrowserNavigateComplete2
    ExplicitLeft = 264
    ExplicitTop = 216
    ExplicitWidth = 300
    ExplicitHeight = 150
    ControlData = {
      4C000000055D0000033E00000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object ActivityIndicator: TActivityIndicator
    Left = 250
    Top = 160
    IndicatorSize = aisXLarge
  end
end
