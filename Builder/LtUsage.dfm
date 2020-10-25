object fmLtUsage: TfmLtUsage
  Left = 241
  Top = 110
  BorderStyle = bsDialog
  Caption = 'Layout usage list'
  ClientHeight = 425
  ClientWidth = 506
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
    Width = 489
    Height = 31
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'This window allows you to select additional Layouts to be added ' +
      'to the Layouts usage list in the current Grid. Layouts used by t' +
      'he current Grid will be added automatically - there is no need t' +
      'o select them.'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 8
    Top = 39
    Width = 489
    Height = 28
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'The additional Layouts list cannot be saved within the Grid, so ' +
      'it will be lost when you close the program or load another Grid.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clPurple
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label5: TLabel
    Left = 8
    Top = 328
    Width = 489
    Height = 57
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'WARNING: It is NOT recommended to select more Layouts than are r' +
      'eally needed (especially all of them). The game has memory limit' +
      ' for the Layouts (its value is not known), so if there are more ' +
      'Layouts in the list that it can handle at once, it will behave s' +
      'trangely or even crash.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object btOK: TBitBtn
    Left = 120
    Top = 395
    Width = 121
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
    Left = 264
    Top = 395
    Width = 121
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object Panel1: TPanel
    Left = 8
    Top = 241
    Width = 489
    Height = 41
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object Label3: TLabel
      Left = 118
      Top = 14
      Width = 189
      Height = 13
      Caption = 'Select Layouts used by the current Grid:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object SelReplace: TBitBtn
      Left = 312
      Top = 8
      Width = 81
      Height = 25
      Caption = 'Replace list'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object btSelAdd: TBitBtn
      Left = 400
      Top = 8
      Width = 81
      Height = 25
      Caption = 'Add to list'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object btUnselAll: TBitBtn
      Left = 8
      Top = 8
      Width = 81
      Height = 25
      Caption = 'Unselect all'
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 8
    Top = 280
    Width = 489
    Height = 41
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 3
    object Label4: TLabel
      Left = 208
      Top = 14
      Width = 99
      Height = 13
      Caption = 'Paste from clipboard:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object btCopy: TBitBtn
      Left = 8
      Top = 8
      Width = 145
      Height = 25
      Caption = 'Copy the list to clipboard'
      TabOrder = 0
    end
    object btPaseReplace: TBitBtn
      Left = 312
      Top = 8
      Width = 81
      Height = 25
      Caption = 'Replace list'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object btPasteAdd: TBitBtn
      Left = 400
      Top = 8
      Width = 81
      Height = 25
      Caption = 'Add to list'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
end
