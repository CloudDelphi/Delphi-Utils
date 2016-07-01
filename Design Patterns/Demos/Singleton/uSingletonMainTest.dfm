object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 216
  ClientWidth = 470
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 17
  object edNumero: TLabeledEdit
    Left = 16
    Top = 28
    Width = 200
    Height = 25
    EditLabel.Width = 48
    EditLabel.Height = 17
    EditLabel.Caption = 'N'#250'mero'
    NumbersOnly = True
    TabOrder = 0
  end
  object edNombre: TLabeledEdit
    Left = 16
    Top = 84
    Width = 200
    Height = 25
    EditLabel.Width = 49
    EditLabel.Height = 17
    EditLabel.Caption = 'Nombre'
    TabOrder = 1
  end
  object btnMostrarSucursal: TButton
    Left = 16
    Top = 157
    Width = 121
    Height = 41
    Caption = 'Mostrar Sucursal'
    TabOrder = 2
    OnClick = btnMostrarSucursalClick
  end
  object btnMostrarPersona: TButton
    Left = 152
    Top = 157
    Width = 121
    Height = 41
    Caption = 'Mostrar Persona'
    TabOrder = 3
    OnClick = btnMostrarPersonaClick
  end
  object btnCambiarSucursal: TButton
    Left = 236
    Top = 20
    Width = 121
    Height = 35
    Caption = 'Modificar Sucursal'
    TabOrder = 4
    OnClick = btnCambiarSucursalClick
  end
  object btnCambiarPersona: TButton
    Left = 236
    Top = 75
    Width = 121
    Height = 35
    Caption = 'Modificar Persona'
    TabOrder = 5
    OnClick = btnCambiarPersonaClick
  end
end
