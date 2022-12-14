object fmTplName: TfmTplName
  Left = 639
  Top = 112
  BorderStyle = bsDialog
  Caption = 'Actor Template name and description'
  ClientHeight = 195
  ClientWidth = 372
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
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 172
    Height = 13
    Caption = 'Template name (max. 50 charactes):'
  end
  object Label2: TLabel
    Left = 8
    Top = 104
    Width = 101
    Height = 13
    Caption = 'Template description:'
  end
  object Label3: TLabel
    Left = 16
    Top = 56
    Width = 345
    Height = 33
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'Template name will be also used as the template file name. Thus ' +
      'it must meet the OS'#39's file name restrictions.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object btOK: TBitBtn
    Left = 72
    Top = 159
    Width = 113
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
    Left = 200
    Top = 159
    Width = 113
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object edTempName: TEdit
    Left = 8
    Top = 24
    Width = 353
    Height = 21
    MaxLength = 50
    TabOrder = 2
  end
  object edTempDesc: TEdit
    Left = 8
    Top = 120
    Width = 353
    Height = 21
    TabOrder = 3
  end
end
