object fmManual: TfmManual
  Left = 440
  Top = 269
  BorderStyle = bsDialog
  Caption = 'Manual Grid list cell edit'
  ClientHeight = 201
  ClientWidth = 501
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PrintScale = poNone
  Scaled = False
  OnCreate = FormCreate
  DesignSize = (
    501
    201)
  PixelsPerInch = 96
  TextHeight = 13
  object lbPathCap: TLabel
    Left = 8
    Top = 53
    Width = 43
    Height = 13
    Caption = 'File path:'
  end
  object lbError: TLabel
    Left = 131
    Top = 96
    Width = 362
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'THE FILE DOES NOT EXIST'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 8
    Width = 25
    Height = 13
    Caption = 'Row:'
  end
  object lbRowId: TLabel
    Left = 40
    Top = 8
    Width = 47
    Height = 13
    Caption = 'lbRowId'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 131
    Top = 8
    Width = 38
    Height = 13
    Caption = 'Column:'
  end
  object lbColumn: TLabel
    Left = 176
    Top = 8
    Width = 52
    Height = 13
    Caption = 'lbColumn'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbInfo: TLabel
    Left = 8
    Top = 24
    Width = 485
    Height = 26
    AutoSize = False
    Caption = 'lbInfo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clPurple
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
  end
  object btOK: TBitBtn
    Left = 113
    Top = 168
    Width = 129
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Save'
    Default = True
    ModalResult = 1
    TabOrder = 0
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object btCancel: TBitBtn
    Left = 264
    Top = 168
    Width = 129
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 1
    Kind = bkCancel
  end
  object cbBlank: TCheckBox
    Left = 8
    Top = 95
    Width = 50
    Height = 17
    Caption = 'Blank'
    TabOrder = 2
    OnClick = cbBlankClick
  end
  object paFragment: TPanel
    Left = 140
    Top = 126
    Width = 317
    Height = 27
    BevelOuter = bvNone
    TabOrder = 3
    object lbFragmentCap: TLabel
      Left = 33
      Top = 6
      Width = 24
      Height = 13
      Caption = 'Map:'
    end
    object cbFragment: TComboBox
      Left = 62
      Top = 3
      Width = 145
      Height = 21
      Style = csDropDownList
      DropDownCount = 20
      ItemHeight = 13
      TabOrder = 0
    end
  end
end
