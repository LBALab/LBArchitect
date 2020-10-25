object fmListForm: TfmListForm
  Left = 238
  Top = 111
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Little Grid Builder'
  ClientHeight = 370
  ClientWidth = 335
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  DesignSize = (
    335
    370)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 6
    Width = 305
    Height = 27
    Alignment = taCenter
    AutoSize = False
    Caption = 'Label1'
    Layout = tlCenter
    WordWrap = True
  end
  object ListBox: TListBox
    Left = 5
    Top = 40
    Width = 325
    Height = 294
    Anchors = [akLeft, akTop, akRight, akBottom]
    Ctl3D = True
    ExtendedSelect = False
    ItemHeight = 13
    ParentCtl3D = False
    TabOrder = 0
    OnClick = ListBoxClick
    OnDblClick = ListBoxDblClick
  end
  object btOK: TButton
    Left = 128
    Top = 341
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Enabled = False
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 232
    Top = 341
    Width = 99
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
