object fmScenarioProp: TfmScenarioProp
  Left = 263
  Top = 114
  BorderStyle = bsDialog
  Caption = 'Scenario properties'
  ClientHeight = 344
  ClientWidth = 442
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  DesignSize = (
    442
    344)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 40
    Width = 425
    Height = 41
    Anchors = [akLeft, akTop, akBottom]
  end
  object Label1: TLabel
    Left = 8
    Top = 90
    Width = 184
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Short description (max 255 characters):'
  end
  object Label2: TLabel
    Left = 8
    Top = 138
    Width = 56
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Description:'
  end
  object lbScType: TLabel
    Left = 130
    Top = 46
    Width = 27
    Height = 13
    Caption = 'Info:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 5
    Width = 425
    Height = 28
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'These properties apply to current or new Scenario.'#13'They will be ' +
      'saved into an exported scenario if you choose File -> Export to ' +
      'a Scenario...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label4: TLabel
    Left = 56
    Top = 46
    Width = 71
    Height = 13
    Caption = 'Scenario type: '
  end
  object lbScene: TLabel
    Left = 130
    Top = 62
    Width = 27
    Height = 13
    Caption = 'Info:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbSceneCap: TLabel
    Left = 90
    Top = 62
    Width = 37
    Height = 13
    Caption = 'Scene: '
  end
  object lbHasGrid: TLabel
    Left = 338
    Top = 46
    Width = 27
    Height = 13
    Caption = 'Info:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbHasGridCap: TLabel
    Left = 266
    Top = 46
    Width = 69
    Height = 13
    Caption = 'Contains Grid: '
  end
  object lbHasFrags: TLabel
    Left = 338
    Top = 62
    Width = 27
    Height = 13
    Caption = 'Info:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbHasFragsCap: TLabel
    Left = 231
    Top = 62
    Width = 104
    Height = 13
    Caption = 'Additional Fragments: '
  end
  object eShortDesc: TEdit
    Left = 8
    Top = 106
    Width = 425
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 0
  end
  object mLongDesc: TMemo
    Left = 8
    Top = 154
    Width = 425
    Height = 153
    Anchors = [akLeft, akBottom]
    TabOrder = 1
  end
  object btOK: TBitBtn
    Left = 104
    Top = 314
    Width = 105
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 2
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
    Spacing = 6
  end
  object BitBtn1: TBitBtn
    Left = 224
    Top = 314
    Width = 105
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 3
    Kind = bkCancel
    Spacing = 6
  end
end
