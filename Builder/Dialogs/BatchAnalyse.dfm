object fmBatchAnalyse: TfmBatchAnalyse
  Left = 0
  Top = 0
  Caption = 'Batch Scene analysis'
  ClientHeight = 350
  ClientWidth = 598
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
    598
    350)
  PixelsPerInch = 96
  TextHeight = 13
  object rgGroups: TRadioGroup
    Left = 8
    Top = 8
    Width = 582
    Height = 65
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Groups'
    Columns = 4
    Items.Strings = (
      'LBA1 Life Script macros'
      'LBA1 Track Script macros'
      'LBA1 Variable macros'
      'LBA1 Behaviours'
      'LBA1 Dir Modes'
      '---'
      'LBA2 Life Script macros'
      'LBA2 Track Script macros'
      'LBA2 Variable macros'
      'LBA2 Behaviours'
      'LBA2 Dir Modes'
      '---')
    TabOrder = 0
    OnClick = rgGroupsClick
  end
  object cbMacro: TComboBox
    Left = 8
    Top = 79
    Width = 398
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    DropDownCount = 20
    ItemHeight = 13
    TabOrder = 1
    OnChange = cbMacroChange
  end
  object reText: TRichEdit
    Left = 8
    Top = 106
    Width = 582
    Height = 205
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    PlainText = True
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object btClose: TBitBtn
    Left = 515
    Top = 317
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 3
    OnClick = btCloseClick
  end
  object btExport: TBitBtn
    Left = 8
    Top = 317
    Width = 121
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Export to a text file'
    TabOrder = 4
    OnClick = btExportClick
  end
  object btStart: TBitBtn
    Left = 515
    Top = 76
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'START'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = btStartClick
  end
  object cbAllErrors: TCheckBox
    Left = 412
    Top = 74
    Width = 97
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Report all errors'
    TabOrder = 6
  end
  object cbOnlyErrors: TCheckBox
    Left = 412
    Top = 88
    Width = 97
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Only errors'
    TabOrder = 7
  end
  object dlgSaveTxt: TSaveDialog
    DefaultExt = '.txt'
    Filter = 'Text files|*.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Export log to a file'
    Left = 136
    Top = 320
  end
end
