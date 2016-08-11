object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 189
  ClientWidth = 536
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 17
  object edApplicationID: TLabeledEdit
    Left = 14
    Top = 32
    Width = 400
    Height = 25
    EditLabel.Width = 77
    EditLabel.Height = 17
    EditLabel.Caption = 'ApplicationID'
    TabOrder = 0
  end
  object edCallbackUrl: TLabeledEdit
    Left = 14
    Top = 84
    Width = 400
    Height = 25
    EditLabel.Width = 75
    EditLabel.Height = 17
    EditLabel.Caption = 'Callback URL'
    TabOrder = 1
  end
  object edToken: TLabeledEdit
    Left = 14
    Top = 138
    Width = 400
    Height = 25
    EditLabel.Width = 34
    EditLabel.Height = 17
    EditLabel.Caption = 'Token'
    TabOrder = 3
  end
  object btnGetToken: TButton
    Left = 430
    Top = 74
    Width = 95
    Height = 35
    Caption = 'Get Token'
    TabOrder = 2
    OnClick = btnGetTokenClick
  end
end
