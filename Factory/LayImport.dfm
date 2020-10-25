object fmLayImport: TfmLayImport
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Select Layouts to import'
  ClientHeight = 364
  ClientWidth = 536
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
  OnCreate = FormCreate
  OnResize = FormResize
  DesignSize = (
    536
    364)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 3
    Top = 6
    Width = 90
    Height = 13
    Caption = 'Maximum allowed: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbMax: TLabel
    Left = 99
    Top = 6
    Width = 7
    Height = 13
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbSelCap: TLabel
    Left = 129
    Top = 6
    Width = 48
    Height = 13
    Caption = 'Selected: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbSel: TLabel
    Left = 183
    Top = 6
    Width = 7
    Height = 13
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object sbContent: TScrollBox
    Left = 3
    Top = 25
    Width = 530
    Height = 303
    HorzScrollBar.Smooth = True
    HorzScrollBar.Tracking = True
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
  end
  object btOK: TBitBtn
    Left = 129
    Top = 335
    Width = 118
    Height = 25
    Anchors = [akBottom]
    Caption = 'OK'
    TabOrder = 1
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
    Spacing = 8
  end
  object btCancel: TBitBtn
    Left = 295
    Top = 335
    Width = 118
    Height = 25
    Anchors = [akBottom]
    TabOrder = 2
    Kind = bkCancel
    Spacing = 8
  end
  object cbAutoPal: TCheckBox
    Left = 408
    Top = 5
    Width = 120
    Height = 17
    Caption = 'Auto-convert palette'
    TabOrder = 3
    OnClick = cbAutoPalClick
  end
end
