object Form1: TForm1
  Left = 237
  Top = 109
  Width = 683
  Height = 474
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 113
    Height = 25
    Caption = 'Open Scene'
    TabOrder = 0
    OnClick = Button1Click
  end
  object LifeScript: TMemo
    Left = 8
    Top = 40
    Width = 345
    Height = 377
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object MoveScript: TMemo
    Left = 368
    Top = 40
    Width = 297
    Height = 385
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object SpinEdit1: TSpinEdit
    Left = 184
    Top = 8
    Width = 65
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 3
    Value = 0
    OnChange = SpinEdit1Change
  end
end
