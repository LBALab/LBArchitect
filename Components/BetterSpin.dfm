object frBetterSpin: TfrBetterSpin
  Left = 0
  Top = 0
  Width = 99
  Height = 22
  TabOrder = 0
  TabStop = True
  OnResize = FrameResize
  object paFrame: TPanel
    Left = 0
    Top = 0
    Width = 99
    Height = 22
    Align = alClient
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clWindow
    TabOrder = 0
    object edValue: TEdit
      AlignWithMargins = True
      Left = 2
      Top = 2
      Width = 63
      Height = 14
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 30
      Margins.Bottom = 2
      Align = alClient
      AutoSize = False
      BorderStyle = bsNone
      TabOrder = 0
      Text = 'edValue'
      OnChange = edValueChange
      OnKeyDown = edValueKeyDown
    end
    object btLUp: TBitBtn
      Left = 82
      Top = 0
      Width = 13
      Height = 9
      TabOrder = 1
      TabStop = False
      OnMouseDown = btSUpMouseDown
      OnMouseLeave = btSUpMouseLeave
      OnMouseUp = btSUpMouseUp
      Glyph.Data = {
        9E000000424D9E0000000000000076000000280000000E000000050000000100
        0400000000002800000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
        DD00CCCCCCC777777700DCCCCCDD77777D00DDCCCDDDD777DD00DDDCDDDDDD7D
        DD00}
      NumGlyphs = 2
    end
    object btLDown: TBitBtn
      Left = 82
      Top = 9
      Width = 13
      Height = 9
      TabOrder = 2
      TabStop = False
      OnMouseDown = btSUpMouseDown
      OnMouseLeave = btSUpMouseLeave
      OnMouseUp = btSUpMouseUp
      Glyph.Data = {
        9E000000424D9E0000000000000076000000280000000E000000050000000100
        0400000000002800000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDCDDDDDD7D
        DD00DDCCCDDDD777DD00DCCCCCDD77777D00CCCCCCC777777700DDDDDDDDDDDD
        DD00}
      Layout = blGlyphBottom
      Margin = 1
      NumGlyphs = 2
    end
    object btSUp: TBitBtn
      Left = 69
      Top = 0
      Width = 13
      Height = 9
      TabOrder = 3
      TabStop = False
      OnMouseDown = btSUpMouseDown
      OnMouseLeave = btSUpMouseLeave
      OnMouseUp = btSUpMouseUp
      Glyph.Data = {
        12010000424D120100000000000036000000280000000E000000050000000100
        180000000000DC000000130B0000130B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FF0000FF00FF000000000000000000000000000000FF00FFFF00FF8080
        80808080808080808080808080FF00FF0000FF00FFFF00FF0000000000000000
        00FF00FFFF00FFFF00FFFF00FF808080808080808080FF00FFFF00FF0000FF00
        FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF808080FF
        00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000}
      NumGlyphs = 2
    end
    object btSDown: TBitBtn
      Left = 69
      Top = 9
      Width = 13
      Height = 9
      TabOrder = 4
      TabStop = False
      OnMouseDown = btSUpMouseDown
      OnMouseLeave = btSUpMouseLeave
      OnMouseUp = btSUpMouseUp
      Glyph.Data = {
        12010000424D120100000000000036000000280000000E000000050000000100
        180000000000DC000000130B0000130B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FF0000FF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FF808080FF00FFFF00FFFF00FF0000FF00FFFF00FF0000000000000000
        00FF00FFFF00FFFF00FFFF00FF808080808080808080FF00FFFF00FF0000FF00
        FF000000000000000000000000000000FF00FFFF00FF80808080808080808080
        8080808080FF00FF0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000}
      Layout = blGlyphBottom
      NumGlyphs = 2
    end
  end
  object tmRepeat: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmRepeatTimer
    Left = 40
  end
end