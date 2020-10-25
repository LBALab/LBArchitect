object fmSettings: TfmSettings
  Left = 881
  Top = 106
  BorderStyle = bsDialog
  Caption = 'Program settings'
  ClientHeight = 204
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
  PixelsPerInch = 96
  TextHeight = 13
  object btOK: TBitBtn
    Left = 128
    Top = 172
    Width = 91
    Height = 25
    Caption = 'OK'
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
    Left = 240
    Top = 172
    Width = 89
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object cbAskDelRow: TCheckBox
    Left = 32
    Top = 36
    Width = 233
    Height = 17
    Caption = 'Ask before deleting a row'
    TabOrder = 2
  end
  object cbBuildSummary: TCheckBox
    Left = 32
    Top = 60
    Width = 257
    Height = 17
    Caption = 'Show build summary after successful build'
    TabOrder = 3
  end
  object cbAutoSave: TCheckBox
    Left = 32
    Top = 108
    Width = 265
    Height = 17
    Caption = 'Auto-save current project (before every build)'
    TabOrder = 4
    OnClick = cbAutoSaveClick
  end
  object cbNoASForce: TCheckBox
    Left = 48
    Top = 132
    Width = 369
    Height = 17
    Caption = 
      'Don'#39't force saving the project if it has never been saved manual' +
      'ly before'
    TabOrder = 5
  end
  object cbLastProject: TCheckBox
    Left = 32
    Top = 84
    Width = 217
    Height = 17
    Caption = 'Open last project at startup'
    TabOrder = 6
  end
  object cbStartZero: TCheckBox
    Left = 32
    Top = 13
    Width = 233
    Height = 17
    Caption = 'Row numbers start with 0'
    TabOrder = 7
  end
end
