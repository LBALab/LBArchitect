object fmSceneProp: TfmSceneProp
  Left = 235
  Top = 112
  BorderStyle = bsSingle
  Caption = 'Scene properties'
  ClientHeight = 382
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 21
    Width = 121
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Island ID (text bank):'
  end
  object Label2: TLabel
    Left = 32
    Top = 53
    Width = 97
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Game Over Scene:'
  end
  object Label3: TLabel
    Left = 232
    Top = 21
    Width = 113
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Alpha light vector:'
  end
  object Label4: TLabel
    Left = 232
    Top = 53
    Width = 113
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Beta light vector:'
  end
  object Label15: TLabel
    Left = 64
    Top = 101
    Width = 65
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Music ID:'
  end
  object btOK: TBitBtn
    Left = 104
    Top = 352
    Width = 121
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = btOKClick
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
  object BitBtn2: TBitBtn
    Left = 240
    Top = 352
    Width = 121
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object gbAmbient: TGroupBox
    Left = 8
    Top = 128
    Width = 457
    Height = 209
    Caption = 'Ambient sounds:'
    TabOrder = 2
    object Label6: TLabel
      Left = 16
      Top = 45
      Width = 105
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Sample ID:'
    end
    object Label7: TLabel
      Left = 16
      Top = 69
      Width = 105
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Repeat count:'
    end
    object Label8: TLabel
      Left = 16
      Top = 93
      Width = 105
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Pitch range:'
    end
    object Label9: TLabel
      Left = 160
      Top = 24
      Width = 8
      Height = 13
      Caption = '1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label10: TLabel
      Left = 240
      Top = 24
      Width = 8
      Height = 13
      Caption = '2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label11: TLabel
      Left = 320
      Top = 24
      Width = 8
      Height = 13
      Caption = '3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label12: TLabel
      Left = 400
      Top = 24
      Width = 8
      Height = 13
      Caption = '4'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label13: TLabel
      Left = 24
      Top = 141
      Width = 129
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Minimal delay:'
    end
    object Label14: TLabel
      Left = 16
      Top = 173
      Width = 137
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Minimal delay random range:'
    end
    object Label5: TLabel
      Left = 16
      Top = 24
      Width = 107
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Sound #:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label16: TLabel
      Left = 248
      Top = 144
      Width = 193
      Height = 41
      Alignment = taCenter
      AutoSize = False
      Caption = 'Value of -1 can be used to disable particular sound parameter.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
  end
end
