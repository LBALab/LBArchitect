object fmList: TfmList
  Left = 233
  Top = 115
  BorderStyle = bsDialog
  Caption = 'Choose one'
  ClientHeight = 452
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 6
    Width = 409
    Height = 30
    AutoSize = False
    Caption = 'Please choose one...'
    WordWrap = True
  end
  object lbList: TListBox
    Left = 8
    Top = 40
    Width = 409
    Height = 369
    ItemHeight = 13
    TabOrder = 0
    OnDblClick = lbListDblClick
    OnMouseDown = lbListMouseDown
  end
  object btOK: TBitBtn
    Left = 96
    Top = 420
    Width = 104
    Height = 25
    Enabled = False
    TabOrder = 1
    Kind = bkOK
    Spacing = 8
  end
  object btCancel: TBitBtn
    Left = 224
    Top = 420
    Width = 105
    Height = 25
    TabOrder = 2
    Kind = bkCancel
    Spacing = 8
  end
end
