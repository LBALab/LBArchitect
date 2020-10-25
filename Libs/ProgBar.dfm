object ProgBarForm: TProgBarForm
  Left = 413
  Top = 142
  AutoSize = True
  BorderStyle = bsNone
  Caption = 'ProgBarForm'
  ClientHeight = 57
  ClientWidth = 353
  Color = clSkyBlue
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 353
    Height = 57
    Style = bsRaised
  end
  object Bevel2: TBevel
    Left = 16
    Top = 18
    Width = 321
    Height = 21
  end
  object Image1: TImage
    Left = 18
    Top = 20
    Width = 317
    Height = 18
    Transparent = True
  end
  object Label1: TLabel
    Left = 24
    Top = 22
    Width = 305
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'Label1'
    Transparent = True
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 248
    Top = 8
  end
end
