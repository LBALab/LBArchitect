object fmAbout: TfmAbout
  Left = 238
  Top = 110
  BorderStyle = bsDialog
  Caption = 'About'
  ClientHeight = 262
  ClientWidth = 452
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 58
    Top = 16
    Width = 335
    Height = 31
    Caption = 'Little Big Architect - Builder'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 191
    Top = 96
    Width = 69
    Height = 13
    Caption = 'written by Zink'
  end
  object Label3: TLabel
    Left = 168
    Top = 128
    Width = 80
    Height = 13
    Caption = 'Status:  freeware'
  end
  object lbHome: TLabel
    Left = 146
    Top = 152
    Width = 55
    Height = 13
    Caption = 'Homepage:'
  end
  object lbVersion: TLabel
    Left = 72
    Top = 64
    Width = 305
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Caption = 'Version: 0.11 beta'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lbEmail: TLabel
    Left = 171
    Top = 176
    Width = 30
    Height = 13
    Caption = 'e-mail:'
  end
  object BitBtn1: TBitBtn
    Left = 165
    Top = 216
    Width = 121
    Height = 25
    Caption = 'Close'
    TabOrder = 0
    OnClick = BitBtn1Click
    Kind = bkOK
  end
end
