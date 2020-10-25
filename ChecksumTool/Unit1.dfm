object Form1: TForm1
  Left = 222
  Top = 103
  Width = 390
  Height = 212
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    382
    185)
  PixelsPerInch = 96
  TextHeight = 13
  object ASCII: TLabel
    Left = 16
    Top = 16
    Width = 27
    Height = 13
    Caption = 'ASCII'
  end
  object lbSuma: TLabel
    Left = 168
    Top = 96
    Width = 33
    Height = 13
    Caption = 'Suma: '
  end
  object Oblicz: TButton
    Left = 40
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Oblicz'
    Default = True
    TabOrder = 0
    OnClick = ObliczClick
  end
  object Edit1: TEdit
    Left = 16
    Top = 32
    Width = 345
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
end
