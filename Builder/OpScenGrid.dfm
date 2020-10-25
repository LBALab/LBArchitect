object fmOpScenGrid: TfmOpScenGrid
  Left = 617
  Top = 110
  BorderStyle = bsDialog
  Caption = 'Open an existing Grid'
  ClientHeight = 132
  ClientWidth = 441
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 94
    Height = 13
    Caption = 'Select Grid to open:'
  end
  object lbInfo: TLabel
    Left = 248
    Top = 8
    Width = 185
    Height = 41
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'Be careful to select appropriate Grid for the Library, that is i' +
      'n the Scenario.'#13'Scenario type is LBA 1'
    WordWrap = True
  end
  object OpenBtn: TButton
    Left = 104
    Top = 101
    Width = 113
    Height = 25
    Caption = 'Open'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Button1: TButton
    Left = 232
    Top = 101
    Width = 113
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object cmGrid: TComboBox
    Left = 16
    Top = 68
    Width = 409
    Height = 21
    Style = csDropDownList
    DropDownCount = 20
    ItemHeight = 13
    TabOrder = 2
    OnClick = rb21Click
  end
  object rb21: TRadioButton
    Left = 15
    Top = 32
    Width = 49
    Height = 17
    Caption = 'LBA 1'
    Checked = True
    TabOrder = 3
    TabStop = True
    OnClick = rb21Click
  end
  object rb22: TRadioButton
    Left = 87
    Top = 32
    Width = 49
    Height = 17
    Caption = 'LBA 2'
    TabOrder = 4
    OnClick = rb21Click
  end
  object rb23: TRadioButton
    Left = 159
    Top = 32
    Width = 58
    Height = 17
    Caption = 'Custom:'
    TabOrder = 5
    OnClick = rb21Click
  end
  object grText: TStaticText
    Left = 16
    Top = 70
    Width = 385
    Height = 17
    AutoSize = False
    BevelInner = bvSpace
    BevelKind = bkSoft
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
  end
  object grBtn: TButton
    Left = 401
    Top = 70
    Width = 17
    Height = 17
    Caption = '...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = grBtnClick
  end
  object DlgOpen: TOpenDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 192
  end
end
