object EditForm: TEditForm
  Left = 193
  Top = 101
  BorderIcons = [biSystemMenu]
  Caption = 'Editor'
  ClientHeight = 404
  ClientWidth = 539
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PrintScale = poNone
  Scaled = False
  OnClose = FormClose
  OnConstrainedResize = FormConstrainedResize
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    539
    404)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 3
    Top = 34
    Width = 411
    Height = 349
    Anchors = [akLeft, akTop, akRight, akBottom]
  end
  object pbMain: TPaintBox
    Left = 4
    Top = 35
    Width = 391
    Height = 329
    Anchors = [akLeft, akTop, akRight, akBottom]
    OnMouseDown = pbMainMouseDown
    OnMouseMove = pbMainMouseMove
    OnMouseUp = pbMainMouseUp
    OnPaint = pbMainPaint
  end
  object btPen: TSpeedButton
    Left = 421
    Top = 232
    Width = 38
    Height = 28
    Hint = 'Free hand drawing'
    Anchors = [akTop, akRight]
    GroupIndex = 1
    Down = True
    Glyph.Data = {
      5A010000424D5A01000000000000760000002800000017000000130000000100
      040000000000E400000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
      DDDDD0DDDDD0DDDDDDDDDDDDDDD80D0DDDD0DDDDDDDDDDDDDD00DDD00000DDDD
      DDDDDDDD0000DDDDDDD0DDDDDDDDDD00800DDDDDDDD0DDDDDDDD008FF70DDDDD
      DDD0DDDDDDD008FF70DDDDDDDDD0DDDDDD0330F770DDDDDDDDD0DDDDD033B307
      0DDDDDDDDDD0DDDD033B3BB00DDDDDDDDDD0DDD033B3BB30DDDDDDDDDDD0DD03
      3B3BB30DDDDDDDDDDDD0D033B3BB30DDDDDDDDDDDDD0033B3BB30DDDDDDDDDDD
      DDD033B3BB30DDDDDDDDDDDDDDD03B3BB30DDDDDDDDDDDDDDDD0B3BB30DDDDDD
      DDDDDDDDDDD03BB30DDDDDDDDDDDDDDDDDD0BB30DDDDDDDDDDDDDDDDDDD0}
    Layout = blGlyphBottom
    ParentShowHint = False
    ShowHint = True
    Spacing = 0
    Transparent = False
    OnClick = btPenClick
  end
  object btSelect: TSpeedButton
    Left = 459
    Top = 232
    Width = 38
    Height = 28
    Hint = 'Select a region'
    Anchors = [akTop, akRight]
    GroupIndex = 1
    Glyph.Data = {
      5A010000424D5A01000000000000760000002800000013000000130000000100
      040000000000E400000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
      F0FFFFF00000FFFFFFFFFFFFF0FFFFF00000FFFFFFFFFFFFF0FFFFF00000FFFF
      FFFFFFFFF0FFFFF00000FFFFFFFFFFFFF0FFFFF0000088FF88FF000000000000
      00008FFFFFFFFFFFF0FFFFF00000FFFFFFFFFFFFF0FFFFF00000FFFFFFFFFFFF
      F0FFFFF000008FFFFFFFFFFFF0FFFFF000008FFFFFFFFFFFF0FFFFF00000FFFF
      FFFFFFFFFFFFFFF00000FFFFFFFFFFFFFFFFFFF000008FFFFFFFFFFFF8FFFFF0
      00008FFFFFFFFFFFF8FFFFF00000FFFFFFFFFFFFFFFFFFF00000FFFFFFFFFFFF
      FFFFFFF000008FFFFFFFFFFFF8FFFFF0000088FF88FF88FF88FFFFF00000}
    ParentShowHint = False
    ShowHint = True
    Spacing = 10
    Transparent = False
    OnClick = btPenClick
  end
  object Bevel2: TBevel
    Left = 421
    Top = 80
    Width = 113
    Height = 145
    Anchors = [akTop, akRight]
  end
  object pbPal: TPaintBox
    Left = 422
    Top = 81
    Width = 111
    Height = 143
    Anchors = [akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnMouseDown = pbPalMouseDown
    OnMouseMove = pbPalMouseMove
    OnMouseUp = pbPalMouseUp
    OnPaint = pbPalPaint
  end
  object btUndo: TSpeedButton
    Left = 358
    Top = 4
    Width = 25
    Height = 25
    Anchors = [akTop, akRight]
    Enabled = False
    Glyph.Data = {
      36060000424D3606000000000000360000002800000020000000100000000100
      1800000000000006000000000000000000000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFFFFFFFFFFFFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF8080808000
      00FF00FFFF00FFFF00FFFF00FFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      00FFFF00FFFF00FFFF00FF808080808080FFFFFFFF00FFFF00FFFF00FFFF00FF
      800000800000800000800000800000FF00FFFF00FFFF00FFFF00FFFF00FF8000
      00808080FF00FFFF00FFFF00FFFF00FF808080808080808080808080808080FF
      FFFFFF00FFFF00FFFF00FFFF00FF808080808080FFFFFFFF00FFFF00FFFF00FF
      800000800000800000800000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FF800000FF00FFFF00FFFF00FFFF00FF808080C0C0C0C0C0C0C0C0C0FFFFFFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FF808080FFFFFFFF00FFFF00FFFF00FF
      800000800000800000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FF800000FF00FFFF00FFFF00FFFF00FF808080C0C0C0C0C0C0FFFFFFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FF808080FFFFFFFF00FFFF00FFFF00FF
      800000800000FF00FF800000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FF800000FF00FFFF00FFFF00FFFF00FF808080C0C0C0FF00FF808080FFFFFFFF
      FFFFFF00FFFF00FFFF00FFFF00FFFF00FF808080FFFFFFFF00FFFF00FFFF00FF
      800000FF00FFFF00FFFF00FF800000800000FF00FFFF00FFFF00FFFF00FF8000
      00808080FF00FFFF00FFFF00FFFF00FF808080FF00FFFF00FFFF00FF80808080
      8080FFFFFFFFFFFFFFFFFFFFFFFFC0C0C0808080FFFFFFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF8000008000008000008000008080
      80FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FF808080808080808080808080808080FF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    NumGlyphs = 2
    OnClick = btUndoClick
  end
  object btRedo: TSpeedButton
    Left = 389
    Top = 4
    Width = 25
    Height = 25
    Anchors = [akTop, akRight]
    Enabled = False
    Glyph.Data = {
      36060000424D3606000000000000360000002800000020000000100000000100
      1800000000000006000000000000000000000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFFFFFFFFFFFFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FF800000808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF808080808080FFFFFFFF00FFFF
      00FFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFF00FFFF00FF
      808080800000FF00FFFF00FFFF00FFFF00FFFF00FF8000008000008000008000
      00800000FF00FFFF00FFFF00FFFF00FF808080C0C0C0FF00FFFF00FFFF00FFFF
      00FFFF00FFC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0FFFFFFFF00FFFF00FFFF00FF
      800000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF8000008000008000
      00800000FF00FFFF00FFFF00FFFF00FF808080FFFFFFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFC0C0C0C0C0C0C0C0C0C0C0C0FFFFFFFF00FFFF00FFFF00FF
      800000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF8000008000
      00800000FF00FFFF00FFFF00FFFF00FF808080FFFFFFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FF808080C0C0C0C0C0C0FFFFFFFF00FFFF00FFFF00FF
      800000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF800000FF00FF8000
      00800000FF00FFFF00FFFF00FFFF00FF808080FFFFFFFF00FFFF00FFFF00FFFF
      00FFFFFFFFFFFFFF808080FF00FF808080C0C0C0FFFFFFFF00FFFF00FFFF00FF
      808080800000FF00FFFF00FFFF00FFFF00FF800000800000FF00FFFF00FFFF00
      FF800000FF00FFFF00FFFF00FFFF00FF808080C0C0C0FFFFFFFFFFFFFFFFFFFF
      FFFF808080808080FF00FFFF00FFFF00FF808080FFFFFFFF00FFFF00FFFF00FF
      FF00FF808080800000800000800000800000FF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF80808080808080808080808080
      8080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    NumGlyphs = 2
    OnClick = btRedoClick
  end
  object btTransN: TSpeedButton
    Left = 501
    Top = 232
    Width = 33
    Height = 30
    Hint = 'Selected region is NOT transparent'
    Anchors = [akTop, akRight]
    GroupIndex = 2
    Down = True
    Glyph.Data = {
      66010000424D6601000000000000760000002800000017000000140000000100
      040000000000F000000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDD00D00D
      00D00D00D000DDDDD0FFFFFFFFFFFFFFFFD0DDDDD0FFFFFFFFFFFFFFFF00DDDD
      DDFFF00000007777FF00DDDDD0FFF2FAAAAA07777FD0DDDDD0FFF2FAAAAA2077
      7700DDDDDDFFF2FAAAAA22077700000000FFF2FAAAAA220FFFD00BBBB0FFF2FA
      AAAA220FFF000BBBBBFFF2FAAAAA220FFF000BBBB0FFF2FFFFFF220FFFD00BBB
      B0FFFF222222820FFF000BBBBBFFFFF22222280FFF000BBBB0FFFFFF2222227F
      FFD00BBBB0FFFFFFFFF0FFFFFF000BBBBB00B00B00B00D00D0000BBBBBBBBBBB
      BBB0DDDDDDD00BBBBBBBBBBBBBB0DDDDDDD00BBBBBBBBBBBBBB0DDDDDDD00000
      000000000000DDDDDDD0}
    OnClick = btTransNClick
  end
  object btTrans: TSpeedButton
    Left = 501
    Top = 262
    Width = 33
    Height = 30
    Hint = 'Selected region is transparent'
    Anchors = [akTop, akRight]
    GroupIndex = 2
    Glyph.Data = {
      66010000424D6601000000000000760000002800000017000000140000000100
      040000000000F000000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDD00D00D
      00D00D00D000DDDDD0DDDDDDDDDDDDDDDDD0DDDDD0DDDDDDDDDDDDDDDD00DDDD
      DDDDD0000000DDDDDD00DDDDD0DDD2FAAAAA0DDDDDD0DDDDD0DDD2FAAAAA20DD
      DD00DDDDDDDDD2FAAAAA220DDD000000000002FAAAAA220DDDD00BBBB0BBB2FA
      AAAA220DDD000BBBBBBBB2FAAAAA220DDD000BBBB0BBB2FFFFFF220DDDD00BBB
      B0BBBB222222820DDD000BBBBBBBBBB22222280DDD000BBBB0BBBBBB2222227D
      DDD00BBBB0BBBBBBBBB0DDDDDD000BBBBB00B00B00B00D00D0000BBBBBBBBBBB
      BBB0DDDDDDD00BBBBBBBBBBBBBB0DDDDDDD00BBBBBBBBBBBBBB0DDDDDDD00000
      000000000000DDDDDDD0}
    OnClick = btTransNClick
  end
  object btFill: TSpeedButton
    Left = 421
    Top = 260
    Width = 38
    Height = 28
    Hint = 'Flood fill'
    Anchors = [akTop, akRight]
    GroupIndex = 1
    Glyph.Data = {
      76050000424D7605000000000000360400002800000012000000100000000100
      0800000000004001000000000000000000000001000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
      A6000020400000206000002080000020A0000020C0000020E000004000000040
      20000040400000406000004080000040A0000040C0000040E000006000000060
      20000060400000606000006080000060A0000060C0000060E000008000000080
      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
      20004000400040006000400080004000A0004000C0004000E000402000004020
      20004020400040206000402080004020A0004020C0004020E000404000004040
      20004040400040406000404080004040A0004040C0004040E000406000004060
      20004060400040606000406080004060A0004060C0004060E000408000004080
      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
      20008000400080006000800080008000A0008000C0008000E000802000008020
      20008020400080206000802080008020A0008020C0008020E000804000008040
      20008040400080406000804080008040A0008040C0008040E000806000008060
      20008060400080606000806080008060A0008060C0008060E000808000008080
      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FDFDFDFDFDFD
      FDFDFDFDFDFDFDFDFDFDFDFD0000FDFDFD00FDFDFDFDFDFDFDFDFDFDFDFDFDFD
      0000FDFD0000FDFDFDFDFDFD0000FDFDFDFDFDFD0000FDFD0000FDFDFDFDFD00
      F0F000FDFDFDFDFD0000FD000000FDFDFDFD000000F0F000FDFDFDFD0000FD00
      0000FDFDFD0000000000F0F000FDFDFD0000FD000000FDFD00F00000000000F0
      F000FDFD0000FD000000FDFD00F0F00000000000F0F000FD0000FD0000FD0000
      F000F0F00000000000F000FD0000FD0000FD00F0F0F0F0F0F00000000000FDFD
      0000FD000000FD00F0F0F0F0F0F0000000FDFDFD0000FDFD000000FD00FFFFFF
      00FFFF00FDFDFDFD0000FDFDFD000000FD00FFFFFF0000FDFDFDFDFD0000FDFD
      FDFDFDFDFDFD00FF00FDFDFDFDFDFDFD0000FDFDFDFDFDFDFDFDFD0000FDFDFD
      FDFDFDFD0000FDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFD0000}
    ParentShowHint = False
    ShowHint = True
    OnClick = btPenClick
  end
  object btPick: TSpeedButton
    Left = 459
    Top = 260
    Width = 38
    Height = 28
    Hint = 'Colour picker'
    Anchors = [akTop, akRight]
    GroupIndex = 1
    Glyph.Data = {
      26050000424D26050000000000003604000028000000100000000F0000000100
      080000000000F000000000000000000000000001000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
      A6000020400000206000002080000020A0000020C0000020E000004000000040
      20000040400000406000004080000040A0000040C0000040E000006000000060
      20000060400000606000006080000060A0000060C0000060E000008000000080
      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
      20004000400040006000400080004000A0004000C0004000E000402000004020
      20004020400040206000402080004020A0004020C0004020E000404000004040
      20004040400040406000404080004040A0004040C0004040E000406000004060
      20004060400040606000406080004060A0004060C0004060E000408000004080
      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
      20008000400080006000800080008000A0008000C0008000E000802000008020
      20008020400080206000802080008020A0008020C0008020E000804000008040
      20008040400080406000804080008040A0008040C0008040E000806000008060
      20008060400080606000806080008060A0008060C0008060E000808000008080
      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FDF0F0F0F0F0
      F0F0FDFDFDFDFDFDFDFDF0F0000000F0F0F0F0F0FDFDFDFDFDFDFDF000F0F000
      F0F0F0FDFDFDFDFDFDFDFDFD00FFFFF000FDFDFDFDFDFDFDFDFDFDFDFD00FFFF
      F000FDFDFDFDFDFDFDFDFDFDFDFD00FFFFF000FDFDFDFDFDFDFDFDFDFDFDFD00
      FFFFA400FDFDFDFDFDFDFDFDFDFDFDFD00FFFFA400FD00FDFDFDFDFDFDFDFDFD
      FD00FFFFA40000FDFDFDFDFDFDFDFDFDFDFD00FF00000000FDFDFDFDFDFDFDFD
      FDFDFD000000000000FDFDFDFDFDFDFDFDFD0000000000000000FDFDFDFDFDFD
      FDFDFDFD000000000000FDFDFDFDFDFDFDFDFDFDFD0007000000FDFDFDFDFDFD
      FDFDFDFDFDFD000000FD}
    ParentShowHint = False
    ShowHint = True
    OnClick = btPenClick
  end
  object btAccept: TBitBtn
    Left = 3
    Top = 4
    Width = 141
    Height = 25
    Caption = 'Accept'
    TabOrder = 0
    Kind = bkOK
    Spacing = 8
  end
  object btCancel: TBitBtn
    Left = 152
    Top = 4
    Width = 141
    Height = 25
    Caption = 'Discard'
    TabOrder = 1
    Kind = bkCancel
    Spacing = 8
  end
  object sbHor: TScrollBar
    Left = 5
    Top = 365
    Width = 391
    Height = 16
    Anchors = [akLeft, akRight, akBottom]
    Enabled = False
    LargeChange = 20
    PageSize = 0
    TabOrder = 2
    OnChange = sbVerChange
  end
  object sbVer: TScrollBar
    Left = 396
    Top = 36
    Width = 16
    Height = 329
    Anchors = [akTop, akRight, akBottom]
    Kind = sbVertical
    LargeChange = 20
    PageSize = 0
    TabOrder = 3
    OnChange = sbVerChange
  end
  object btCopy: TBitBtn
    Left = 421
    Top = 292
    Width = 38
    Height = 28
    Hint = 'Copy selected region'
    Anchors = [akTop, akRight]
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = btCopyClick
    Glyph.Data = {
      46060000424D4606000000000000360400002800000016000000160000000100
      0800000000001002000074120000741200000001000000000000000000004000
      000080000000FF000000002000004020000080200000FF200000004000004040
      000080400000FF400000006000004060000080600000FF600000008000004080
      000080800000FF80000000A0000040A0000080A00000FFA0000000C0000040C0
      000080C00000FFC0000000FF000040FF000080FF0000FFFF0000000020004000
      200080002000FF002000002020004020200080202000FF202000004020004040
      200080402000FF402000006020004060200080602000FF602000008020004080
      200080802000FF80200000A0200040A0200080A02000FFA0200000C0200040C0
      200080C02000FFC0200000FF200040FF200080FF2000FFFF2000000040004000
      400080004000FF004000002040004020400080204000FF204000004040004040
      400080404000FF404000006040004060400080604000FF604000008040004080
      400080804000FF80400000A0400040A0400080A04000FFA0400000C0400040C0
      400080C04000FFC0400000FF400040FF400080FF4000FFFF4000000060004000
      600080006000FF006000002060004020600080206000FF206000004060004040
      600080406000FF406000006060004060600080606000FF606000008060004080
      600080806000FF80600000A0600040A0600080A06000FFA0600000C0600040C0
      600080C06000FFC0600000FF600040FF600080FF6000FFFF6000000080004000
      800080008000FF008000002080004020800080208000FF208000004080004040
      800080408000FF408000006080004060800080608000FF608000008080004080
      800080808000FF80800000A0800040A0800080A08000FFA0800000C0800040C0
      800080C08000FFC0800000FF800040FF800080FF8000FFFF80000000A0004000
      A0008000A000FF00A0000020A0004020A0008020A000FF20A0000040A0004040
      A0008040A000FF40A0000060A0004060A0008060A000FF60A0000080A0004080
      A0008080A000FF80A00000A0A00040A0A00080A0A000FFA0A00000C0A00040C0
      A00080C0A000FFC0A00000FFA00040FFA00080FFA000FFFFA0000000C0004000
      C0008000C000FF00C0000020C0004020C0008020C000FF20C0000040C0004040
      C0008040C000FF40C0000060C0004060C0008060C000FF60C0000080C0004080
      C0008080C000FF80C00000A0C00040A0C00080A0C000FFA0C00000C0C00040C0
      C00080C0C000FFC0C00000FFC00040FFC00080FFC000FFFFC0000000FF004000
      FF008000FF00FF00FF000020FF004020FF008020FF00FF20FF000040FF004040
      FF008040FF00FF40FF000060FF004060FF008060FF00FF60FF000080FF004080
      FF008080FF00FF80FF0000A0FF0040A0FF0080A0FF00FFA0FF0000C0FF0040C0
      FF0080C0FF00FFC0FF0000FFFF0040FFFF0080FFFF00FFFFFF00919191919191
      9191919191919191919191919191919100009191919191919100000000000000
      000000000000009100009191919191919192DBDBDBDBDBDBDBDBDBDBDBDB0091
      00009191919191919192FFFFFEFFFEFFFEFFFEFFFEDB00910000919191919191
      9192FFFE0707070707070707FFDB009100009100000000000092FFFFFFFFFEFF
      FEFFFEFFFEDB009100009192DBDBDBDBDB92FFFE0303030303030303FFDB0091
      00009192FFFFFEFFFE92FFFFFEFFFEFFFEFFFEFFFEDB009100009192FFFE0606
      0692FFFE0303030303030303FFDB009100009192FFFFFFFEFF92FFFFFEFFFEFF
      FEFFFEFFFEDB009100009192FFFF06060692FFFF2F2F2F2F2F2F2F2FFFDB0091
      00009192FFFEFFFFFE92FFFFFFFEFFFFFEFFFEDBDBDB009100009192FFFF0606
      0692FFFF2F2F2F2FFFFE00000000009100009192FFFEFFFEFF92FFFFFFFFFFFF
      FEFF92FFFF00919100009192FFFF06060692FFFFFFFFFFFFFFFF92FF00919191
      00009192FFFFFFFFFF92FFFFFFFFFFFFFFFF92009191919100009192FFFF0606
      0692929292929292929292919191919100009192FFFFFFFFFEFFFFFE92FFFF00
      919191919191919100009192FFFFFFFFFFFFFEFF92FF00919191919191919191
      00009192FFFFFFFFFFFFFFFF9200919191919191919191910000919292929292
      9292929292919191919191919191919100009191919191919191919191919191
      91919191919191910000}
    Layout = blGlyphTop
    Spacing = 0
  end
  object btPaste: TBitBtn
    Left = 459
    Top = 292
    Width = 38
    Height = 28
    Hint = 'Paste from clipboard'
    Anchors = [akTop, akRight]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = btPasteClick
    Glyph.Data = {
      B6060000424DB60600000000000036040000280000001D000000140000000100
      0800000000008002000074120000741200000001000000000000000000004000
      000080000000FF000000002000004020000080200000FF200000004000004040
      000080400000FF400000006000004060000080600000FF600000008000004080
      000080800000FF80000000A0000040A0000080A00000FFA0000000C0000040C0
      000080C00000FFC0000000FF000040FF000080FF0000FFFF0000000020004000
      200080002000FF002000002020004020200080202000FF202000004020004040
      200080402000FF402000006020004060200080602000FF602000008020004080
      200080802000FF80200000A0200040A0200080A02000FFA0200000C0200040C0
      200080C02000FFC0200000FF200040FF200080FF2000FFFF2000000040004000
      400080004000FF004000002040004020400080204000FF204000004040004040
      400080404000FF404000006040004060400080604000FF604000008040004080
      400080804000FF80400000A0400040A0400080A04000FFA0400000C0400040C0
      400080C04000FFC0400000FF400040FF400080FF4000FFFF4000000060004000
      600080006000FF006000002060004020600080206000FF206000004060004040
      600080406000FF406000006060004060600080606000FF606000008060004080
      600080806000FF80600000A0600040A0600080A06000FFA0600000C0600040C0
      600080C06000FFC0600000FF600040FF600080FF6000FFFF6000000080004000
      800080008000FF008000002080004020800080208000FF208000004080004040
      800080408000FF408000006080004060800080608000FF608000008080004080
      800080808000FF80800000A0800040A0800080A08000FFA0800000C0800040C0
      800080C08000FFC0800000FF800040FF800080FF8000FFFF80000000A0004000
      A0008000A000FF00A0000020A0004020A0008020A000FF20A0000040A0004040
      A0008040A000FF40A0000060A0004060A0008060A000FF60A0000080A0004080
      A0008080A000FF80A00000A0A00040A0A00080A0A000FFA0A00000C0A00040C0
      A00080C0A000FFC0A00000FFA00040FFA00080FFA000FFFFA0000000C0004000
      C0008000C000FF00C0000020C0004020C0008020C000FF20C0000040C0004040
      C0008040C000FF40C0000060C0004060C0008060C000FF60C0000080C0004080
      C0008080C000FF80C00000A0C00040A0C00080A0C000FFA0C00000C0C00040C0
      C00080C0C000FFC0C00000FFC00040FFC00080FFC000FFFFC0000000FF004000
      FF008000FF00FF00FF000020FF004020FF008020FF00FF20FF000040FF004040
      FF008040FF00FF40FF000060FF004060FF008060FF00FF60FF000080FF004080
      FF008080FF00FF80FF0000A0FF0040A0FF0080A0FF00FFA0FF0000C0FF0040C0
      FF0080C0FF00FFC0FF0000FFFF0040FFFF0080FFFF00FFFFFF00919191919191
      9191919191919191919191919191919191919191919191000000919191919191
      9191919191910000000000000000000000919191919191000000919191919191
      91919191919192DBDBDBDBDBDBDBDBDB00919191919191000000919191919191
      91919191919192FF07070707070707DB00919191919191000000919191919100
      00000000000092FFFEFFFEFFFEFFFEDB00919191919191000000919191916C91
      91919191919192FF03030303030303DB00919191919191000000919191916CDA
      DA91DA91DA9192FFFEFFFEFFFEFFDBDB00919191919191000000919191916CFF
      DADA91DA91DA92FF030303FEFF6D000000919191919191000000919191916CDA
      FFDADA91DA9192FFFFFFFFFFFE92FF0091919191919191000000919191916CFF
      DAFFDADA91DA92FFFFFFFFFFFF92009191919191919191000000919191916CFF
      FFDAFFDADA919292929292929292919191919191919191000000919191916CFF
      FFFFDAFFDADA91DA919191919100919191919191919191000000919191916CFF
      FFFFFFDAFFDADA91DA9191919100919191919191919191000000919191916CFF
      FFFFFFFFDAFFDADA91DA91919100919191919191919191000000919191916CFF
      FF00000000000000000000919100919191919191919191000000919191916CFF
      FFD0FEF8F8F8F8F8D08C00919100919191919191919191000000919191916CFF
      FFFFD0FEF86C6CF88C009191910091919191919191919100000091919191916C
      6C6C6CD0FFFEFEF8006C6C6C6C91919191919191919191000000919191919191
      919191D0D0D0D0D08C9191919191919191919191919191000000919191919191
      9191919191919191919191919191919191919191919191000000}
    Layout = blGlyphTop
    Spacing = 0
  end
  object btZoom: TBitBtn
    Left = 421
    Top = 4
    Width = 113
    Height = 21
    Anchors = [akTop, akRight]
    Caption = 'Zoom'
    TabOrder = 6
    OnClick = btZoomClick
    Glyph.Data = {
      9A000000424D9A00000000000000760000002800000006000000090000000100
      0400000000002400000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDD00D0DD
      DD00D00DDD00D000DD00D0000D00D000DD00D00DDD00D0DDDD00DDDDDD00}
    Layout = blGlyphRight
    Margin = 26
    Spacing = 13
  end
  object btDisp: TBitBtn
    Left = 421
    Top = 28
    Width = 113
    Height = 21
    Anchors = [akTop, akRight]
    Caption = 'Display'
    TabOrder = 7
    OnClick = btDispClick
    Glyph.Data = {
      9A000000424D9A00000000000000760000002800000006000000090000000100
      0400000000002400000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDD00D0DD
      DD00D00DDD00D000DD00D0000D00D000DD00D00DDD00D0DDDD00DDDDDD00}
    Layout = blGlyphRight
    Margin = 26
    Spacing = 10
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 385
    Width = 539
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object btSave: TBitBtn
    Left = 421
    Top = 329
    Width = 113
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Save to file'
    TabOrder = 9
    OnClick = btSaveClick
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF00FFFF00FF000000
      008080008080000000000000000000000000000000000000C6D1D7C6D1D70000
      00008080000000FF00FFFF00FF00000000808000808000000000000000000000
      0000000000000000C6D1D7C6D1D7000000008080000000FF00FFFF00FF000000
      008080008080000000000000000000000000000000000000C6D1D7C6D1D70000
      00008080000000FF00FFFF00FF00000000808000808000000000000000000000
      0000000000000000000000000000000000008080000000FF00FFFF00FF000000
      0080800080800080800080800080800080800080800080800080800080800080
      80008080000000FF00FFFF00FF00000000808000808000000000000000000000
      0000000000000000000000000000008080008080000000FF00FFFF00FF000000
      008080000000C6D1D7C6D1D7C6D1D7C6D1D7C6D1D7C6D1D7C6D1D7C6D1D70000
      00008080000000FF00FFFF00FF000000008080000000C6D1D7C6D1D7C6D1D7C6
      D1D7C6D1D7C6D1D7C6D1D7C6D1D7000000008080000000FF00FFFF00FF000000
      008080000000C6D1D7C6D1D7C6D1D7C6D1D7C6D1D7C6D1D7C6D1D7C6D1D70000
      00008080000000FF00FFFF00FF000000008080000000C6D1D7C6D1D7C6D1D7C6
      D1D7C6D1D7C6D1D7C6D1D7C6D1D7000000008080000000FF00FFFF00FF000000
      008080000000C6D1D7C6D1D7C6D1D7C6D1D7C6D1D7C6D1D7C6D1D7C6D1D70000
      00000000000000FF00FFFF00FF000000008080000000C6D1D7C6D1D7C6D1D7C6
      D1D7C6D1D7C6D1D7C6D1D7C6D1D7000000C6D1D7000000FF00FFFF00FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    Margin = 11
    Spacing = 8
  end
  object btLoad: TBitBtn
    Left = 421
    Top = 358
    Width = 113
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Load from file'
    TabOrder = 10
    OnClick = btLoadClick
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000000000000000000000000000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00000000000000
      0000008080000080800000808000008080000080800000808000008080000080
      80000080800000000000FF00FF00FF00FF00FF00FF00FF00FF000000000000FF
      FF00000000000080800000808000008080000080800000808000008080000080
      8000008080000080800000000000FF00FF00FF00FF00FF00FF0000000000FFFF
      FF0000FFFF000000000000808000008080000080800000808000008080000080
      800000808000008080000080800000000000FF00FF00FF00FF000000000000FF
      FF00FFFFFF0000FFFF0000000000008080000080800000808000008080000080
      80000080800000808000008080000080800000000000FF00FF0000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000000000FF
      FF00FFFFFF0000FFFF0000000000000000000000000000000000000000000000
      000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
      00000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00000000000000000000000000FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF000000000000000000FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FF00
      FF00FF00FF00FF00FF0000000000FF00FF0000000000FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
      00000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
    Margin = 11
    Spacing = 8
  end
  object btOpts: TBitBtn
    Left = 421
    Top = 52
    Width = 113
    Height = 21
    Anchors = [akTop, akRight]
    Caption = 'Options'
    TabOrder = 11
    OnClick = btOptsClick
    Glyph.Data = {
      9A000000424D9A00000000000000760000002800000006000000090000000100
      0400000000002400000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDD00D0DD
      DD00D00DDD00D000DD00D0000D00D000DD00D00DDD00D0DDDD00DDDDDD00}
    Layout = blGlyphRight
    Margin = 26
    Spacing = 9
  end
  object paWarning: TPanel
    Left = 421
    Top = 323
    Width = 113
    Height = 60
    Anchors = [akRight, akBottom]
    BevelOuter = bvLowered
    TabOrder = 12
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 111
      Height = 41
      Alignment = taCenter
      AutoSize = False
      Caption = 'You are editing Bricks:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      WordWrap = True
    end
    object btWarningMore: TButton
      Left = 2
      Top = 42
      Width = 109
      Height = 16
      Caption = 'tell me more about it'
      TabOrder = 0
      OnClick = btWarningMoreClick
    end
  end
  object dlSave: TSaveDialog
    DefaultExt = '.brk'
    Filter = 'LBA Brick file (*.brk)|*.brk'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Save Brick to file'
    Left = 320
    Top = 48
  end
  object dlOpen: TOpenDialog
    DefaultExt = '.brk'
    Filter = 'LBA Brick files (*.brk)|*.brk'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Open Brick from file'
    Left = 352
    Top = 48
  end
end
