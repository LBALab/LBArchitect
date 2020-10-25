object fmOpenSim: TfmOpenSim
  Left = 238
  Top = 110
  BorderStyle = bsDialog
  Caption = 'Open map'
  ClientHeight = 160
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  DesignSize = (
    441
    160)
  PixelsPerInch = 96
  TextHeight = 13
  object lbCaption: TLabel
    Left = 8
    Top = 8
    Width = 119
    Height = 13
    Caption = 'Select map for Main Grid:'
  end
  object lbInfo: TLabel
    Left = 168
    Top = 8
    Width = 257
    Height = 41
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'This way you can open only standard LBA maps. If you want to ope' +
      'n maps from single files or in different environment, please cho' +
      'ose File->Open advanced.'
    WordWrap = True
  end
  object cbSimGrid: TComboBox
    Left = 16
    Top = 60
    Width = 409
    Height = 21
    Style = csDropDownList
    DropDownCount = 20
    ItemHeight = 0
    TabOrder = 0
    OnChange = rbLba1Click
  end
  object rbLba1: TRadioButton
    Left = 15
    Top = 32
    Width = 49
    Height = 17
    Caption = 'LBA 1'
    Checked = True
    TabOrder = 1
    TabStop = True
    OnClick = rbLba1Click
  end
  object rbLba2: TRadioButton
    Left = 79
    Top = 32
    Width = 49
    Height = 17
    Caption = 'LBA 2'
    TabOrder = 2
    OnClick = rbLba1Click
  end
  object btOpen: TBitBtn
    Left = 104
    Top = 128
    Width = 113
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Open'
    TabOrder = 3
    Kind = bkOK
  end
  object btCancel: TBitBtn
    Left = 232
    Top = 128
    Width = 113
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 4
    Kind = bkCancel
  end
  object paMode: TPanel
    Left = 104
    Top = 88
    Width = 241
    Height = 33
    BevelOuter = bvNone
    TabOrder = 5
    object rbGridMode: TRadioButton
      Left = 16
      Top = 0
      Width = 201
      Height = 17
      Caption = 'Open in Grid Mode (for Grid editing)'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbSceneMode: TRadioButton
      Left = 16
      Top = 16
      Width = 217
      Height = 17
      Caption = 'Open in Scene Mode (for Scene editing)'
      TabOrder = 1
    end
  end
  object rbLbaCustom: TRadioButton
    Left = 143
    Top = 32
    Width = 58
    Height = 17
    Caption = 'Custom'
    TabOrder = 6
    OnClick = rbLba1Click
  end
  object btSimGrid: TButton
    Left = 403
    Top = 62
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
    OnClick = btSimGridClick
  end
  object stSimGrid: TStaticText
    Left = 18
    Top = 62
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
    TabOrder = 8
  end
  object DlgOpen: TOpenDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 8
    Top = 88
  end
end
