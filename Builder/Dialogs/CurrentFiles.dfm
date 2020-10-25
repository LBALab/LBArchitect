object fmCurrentFiles: TfmCurrentFiles
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Opened files list'
  ClientHeight = 295
  ClientWidth = 497
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PrintScale = poNone
  Scaled = False
  DesignSize = (
    497
    295)
  PixelsPerInch = 96
  TextHeight = 13
  object lbEditHead: TLabel
    Left = 8
    Top = 8
    Width = 169
    Height = 13
    Caption = 'List of files opened for editing:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbReadHead: TLabel
    Left = 8
    Top = 112
    Width = 321
    Height = 13
    Caption = 'List of files opened for reading only (or opened && closed):'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 6710886
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbEditCapts: TLabel
    Left = 24
    Top = 28
    Width = 81
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'lbEditCapts'
  end
  object lbEditPaths: TLabel
    Left = 111
    Top = 28
    Width = 53
    Height = 13
    Caption = 'lbEditPaths'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbReadCapts: TLabel
    Left = 24
    Top = 131
    Width = 81
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'lbReadCapts'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 6710886
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbReadPaths: TLabel
    Left = 111
    Top = 131
    Width = 60
    Height = 13
    Caption = 'lbReadPaths'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object btClose: TBitBtn
    Left = 188
    Top = 262
    Width = 121
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Close'
    TabOrder = 0
    OnClick = btCloseClick
  end
end
