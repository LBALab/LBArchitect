object fmScriptEd: TfmScriptEd
  Left = 237
  Top = 111
  Caption = 'Script editor'
  ClientHeight = 415
  ClientWidth = 684
  Color = clBtnFace
  Constraints.MinHeight = 82
  Constraints.MinWidth = 392
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  DesignSize = (
    684
    415)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 28
    Height = 13
    Caption = 'Actor:'
  end
  object btCompile: TBitBtn
    Left = 563
    Top = 3
    Width = 107
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Compile the Scripts'
    TabOrder = 0
    OnClick = btCompileClick
  end
  object paEditors: TPanel
    Left = 0
    Top = 32
    Width = 684
    Height = 383
    Align = alCustom
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object spHoriz: TSplitter
      Left = 2
      Top = 2
      Width = 4
      Height = 251
      AutoSnap = False
      MinSize = 190
      ResizeStyle = rsUpdate
      OnMoved = spHorizMoved
      ExplicitLeft = 289
      ExplicitHeight = 301
    end
    object spVert: TSplitter
      Left = 2
      Top = 253
      Width = 680
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      AutoSnap = False
      MinSize = 10
      ResizeStyle = rsUpdate
      ExplicitTop = 303
      ExplicitWidth = 595
    end
    object pcBottom: TPageControl
      Left = 2
      Top = 256
      Width = 680
      Height = 125
      ActivePage = tsMessages
      Align = alBottom
      MultiLine = True
      TabOrder = 0
      TabPosition = tpLeft
      object tsMessages: TTabSheet
        Caption = 'Messages'
        TabVisible = False
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object lbMessages: TListBox
          Left = 0
          Top = 0
          Width = 672
          Height = 117
          Style = lbVirtualOwnerDraw
          Align = alClient
          ItemHeight = 14
          TabOrder = 0
          OnData = lbMessagesData
          OnDataFind = lbMessagesDataFind
          OnDblClick = lbMessagesDblClick
          OnDrawItem = lbMessagesDrawItem
        end
      end
    end
  end
  object btSettings: TBitBtn
    Left = 536
    Top = 3
    Width = 25
    Height = 25
    Hint = 'Script Settings'
    Anchors = [akTop, akRight]
    TabOrder = 2
    OnClick = btSettingsClick
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000847E5C5C563C
      4C462C443A1C443A1C4C4A2C4C4A34545A34949A4CDCE274F4EE8CDCDE84F4F6
      94DCE2747C7E342C321C544E344C4A34444A3C645E5C5C6E5C4C4E4C4C462C4C
      462C444224646634ACB25CDCDE749CA24C545A2C4C4E4C848A8C4C4E344C462C
      4C627C94B6E4BCF2FC6C827C44361C44462C443A242C221C24260C444224545A
      54848A8CA4A6AC7C86844C4A344C4A344C4A3C6C869474928C4C563C44422C44
      3E242C2A1C343224545A548C9294ACAEB47C8AAC344A84343E445C5A444C462C
      443E24443A1C342E1C3C321C3C321C3C3A2C545A5494928CA4AEB47C8AAC3C52
      9C243EA4243EA4848E9C5456444C422C443E2C34322434321C3C3A2C5C625C94
      9A94A4AEAC7482A43C4A9424369C3446AC3C56C44456ACFF00FF44422C443E24
      342E1C3432245C5654949A94A4AEB47C8AAC2C426C3C6AB45C92E4445EBC3C4E
      B44462CC3C4EB4FF00FF3C321C3436245C6254848A8CA4A6AC747AA43C4A9424
      36942C3EAC5C7AD46C96D44456AC3C52BC3C56C4547ADCFF00FF5C5654848A8C
      9CA6B474829C3C4E943C62BC3C5EC43C4EBC3C52BC2C42AC2C3EAC344AB43C52
      B4344EB43C52ACFF00FFA4AABC848684344A842436942C4AAC6CB2FC6486D434
      4AAC3C56BC3C52BC3C52BC3C5AC43C5EC44C6AD4547AF4547ADCC4CED474829C
      2C3E9C3C52BC3C4EB43C5ACC3C52AC344EB43C52BC344EB43C5EBC74B2F47C9E
      DC4462A44C66B4FF00FF8C9AAC4456AC3C52BC3C56BC3C52BC3C52B43C4EBC3C
      56BC3C52BC3C56BC5C7EEC84AEF4547ADCFF00FFFF00FFFF00FFFF00FF344AB4
      4466DC3C52B43C52BC3C5AC43C52BC3C52B4344EB43C5AC4547ADC547ADCFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FF344EB4FF00FFFF00FF344AB4344EB43C
      5EC44462CC344EB4FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FF3C4EBC547AE46492FCFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF344EB434
      4EB45C7ABCFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    Margin = 2
    Spacing = -1
  end
  object cbEditorOnTop: TCheckBox
    Left = 104
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Always on top'
    TabOrder = 3
    Visible = False
  end
  object btNextActor: TBitBtn
    Left = 108
    Top = 3
    Width = 24
    Height = 24
    TabOrder = 4
    OnClick = btPrevActorClick
    Glyph.Data = {
      96090000424D9609000000000000360000002800000028000000140000000100
      18000000000060090000130B0000130B00000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF80
      8080808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF8080808080
      80FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00D0D000D0D0808080808080
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FF5C5C5C5C5C5C808080808080FF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FF00D0D000FCFF00D0D0808080808080FF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FF5C5C5CB6B6B65C5C5C808080808080FF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FF00D0D00AFCFF14FDFF00D0D0808080808080FF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      5C5C5CB6B6B6B6B6B65C5C5C808080808080FF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00D0D017
      FDFF21FCFF2BFCFF00D0D0808080808080FF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5C5C5CB6B6B6B6B6
      B6B6B6B65C5C5C808080808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00D0D024FDFF2EFDFF38FDFF
      42FDFF00D0D0808080808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FF5C5C5CB6B6B6B6B6B6B6B6B6B6B6B65C
      5C5C808080808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FF00D0D030FCFF3BFDFF45FDFF4FFDFF5AFDFF00D0
      D0808080808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FF5C5C5CB6B6B6B6B6B6B6B6B6B6B6B6B6B6B65C5C5C808080
      808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FF00D0D03DFDFF48FDFF52FDFF5CFDFF66FDFF71FEFF00D0D080808080
      8080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      5C5C5CB6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B65C5C5C808080808080FF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00D0D04B
      FCFF55FDFF5EFDFF69FDFF73FDFF7EFDFF88FDFF00D0D0FF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5C5C5CB6B6B6B6B6
      B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B65C5C5CFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00D0D057FDFF62FDFF6BFEFF
      76FDFF80FDFF8AFEFF00D0D0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FF5C5C5CB6B6B6B6B6B6B6B6B6B6B6B6B6
      B6B6B6B6B65C5C5CFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FF00D0D064FDFF6EFDFF79FDFF83FEFF8DFEFF00D0
      D0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FF5C5C5CB6B6B6B6B6B6B6B6B6B6B6B6B6B6B65C5C5CFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FF00D0D071FDFF7BFDFF86FEFF90FDFF00D0D0FF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      5C5C5CB6B6B6B6B6B6B6B6B6B6B6B65C5C5CFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00D0D07D
      FDFF88FEFF93FEFF00D0D0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5C5C5CB6B6B6B6B6
      B6B6B6B65C5C5CFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00D0D08BFEFF95FEFF00D0D0
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FF5C5C5CB6B6B6B6B6B65C5C5CFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FF00D0D097FDFF00D0D0FF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FF5C5C5CB6B6B65C5C5CFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FF00D0D000D0D0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      5C5C5C5C5C5CFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    Layout = blGlyphBottom
    NumGlyphs = 2
  end
  object btPrevActor: TBitBtn
    Left = 40
    Top = 3
    Width = 24
    Height = 24
    TabOrder = 5
    OnClick = btPrevActorClick
    Glyph.Data = {
      96090000424D9609000000000000360000002800000028000000140000000100
      18000000000060090000130B0000130B00000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FF808080808080FF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FF808080808080FF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FF00D0D000D0D0808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FF5C5C5C5C5C5C808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00D0D01BFC
      FF00D0D0808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5C5C5CB6B6B65C5C5C
      808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FF00D0D01AFCFF27FCFF00D0D0808080FF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FF5C5C5CB6B6B6B6B6B65C5C5C808080FF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FF00D0D01BFDFF27FCFF33FDFF00D0D0808080FF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FF5C5C5CB6B6B6B6B6B6B6B6B65C5C5C808080FF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00D0D01BFCFF
      28FCFF34FDFF40FDFF00D0D0808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5C5C5CB6B6B6B6B6B6B6
      B6B6B6B6B65C5C5C808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FF00D0D01CFCFF28FCFF34FDFF40FCFF4DFD
      FF00D0D0808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FF5C5C5CB6B6B6B6B6B6B6B6B6B6B6B6B6B6B65C5C5C
      808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FF00D0D01CFDFF29FCFF35FDFF40FDFF4DFDFF59FDFF00D0D0808080FF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      5C5C5CB6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B65C5C5C808080FF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00D0D01DFCFF29
      FCFF35FDFF41FDFF4DFDFF59FDFF66FDFF00D0D0808080FF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5C5C5CB6B6B6B6B6B6B6B6
      B6B6B6B6B6B6B6B6B6B6B6B6B65C5C5C808080FF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00D0D035FDFF41FDFF4DFCFF
      5AFDFF66FDFF73FEFF00D0D0808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FF5C5C5CB6B6B6B6B6B6B6B6B6B6B6B6B6
      B6B6B6B6B65C5C5C808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FF00D0D04FFDFF5AFDFF66FDFF72FDFF7FFD
      FF00D0D0808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FF5C5C5CB6B6B6B6B6B6B6B6B6B6B6B6B6B6B65C5C5C
      808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FF00D0D067FDFF74FEFF7FFEFF8CFEFF00D0D0808080FF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FF5C5C5CB6B6B6B6B6B6B6B6B6B6B6B65C5C5C808080FF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FF00D0D080FEFF8CFEFF98FEFF00D0D0808080FF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FF5C5C5CB6B6B6B6B6B6B6B6B65C5C5C808080FF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      00D0D098FEFFA5FEFF00D0D0808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5C5C5CB6
      B6B6B6B6B65C5C5C808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00D0D0B1FE
      FF00D0D0808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5C5C5CB6B6B65C5C5C
      808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00D0D000D0D0FF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5C5C5C5C5C5CFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    Layout = blGlyphBottom
    NumGlyphs = 2
  end
  object eActor: TEdit
    Left = 68
    Top = 5
    Width = 37
    Height = 21
    TabOrder = 6
    Text = '0'
    OnChange = eActorChange
  end
  object paUndoRedo: TPanel
    Left = 230
    Top = 1
    Width = 121
    Height = 31
    BevelOuter = bvNone
    TabOrder = 7
    object btLifeUndo: TSpeedButton
      Left = 2
      Top = 2
      Width = 25
      Height = 25
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        18000000000000060000130B0000130B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF551BFF5C1EFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FF808080808080FF00FFFF00FFFF00FFFF00FFFF00FFFF210B
        FF280DFF2E0FFF3411FF3C13FF4215FF4817FF00FFFF00FFFF5B1EFF621FFF68
        22FF00FFFF00FFFF00FFFF00FF80808080808080808080808080808080808080
        8080FF00FFFF00FF808080808080808080FF00FFFF00FFFF00FFFF00FFFF280D
        FF2E0EFF3511FF3C13FF4215FF4817FF00FFFF00FFFF00FFFF00FFFF6821FF6F
        23FF7526FF00FFFF00FFFF00FF808080808080808080808080808080808080FF
        00FFFF00FFFF00FFFF00FF808080808080808080FF00FFFF00FFFF00FFFF2E0F
        FF3511FF3B13FF4115FF4817FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF76
        26FF7C28FF00FFFF00FFFF00FF808080808080808080808080808080FF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FF808080808080FF00FFFF00FFFF00FFFF3511
        FF3B13FF4115FF4817FF4E19FF551BFF00FFFF00FFFF00FFFF00FFFF00FFFF7C
        28FF8229FF00FFFF00FFFF00FF808080808080808080808080808080808080FF
        00FFFF00FFFF00FFFF00FFFF00FF808080808080FF00FFFF00FFFF00FFFF3B13
        FF4115FF4817FF4E1AFF551CFF5B1DFF621FFF00FFFF00FFFF00FFFF7C28FF82
        29FF882BFF00FFFF00FFFF00FF80808080808080808080808080808080808080
        8080FF00FFFF00FFFF00FF808080808080808080FF00FFFF00FFFF00FFFF4115
        FF4817FF00FFFF541BFF5B1EFF611FFF6821FF6E24FF7526FF7C27FF822AFF88
        2CFF00FFFF00FFFF00FFFF00FF808080808080FF00FF80808080808080808080
        8080808080808080808080808080808080FF00FFFF00FFFF00FFFF00FFFF4717
        FF00FFFF00FFFF00FFFF611FFF6822FF6E23FF7526FF7B27FF812AFF892CFF8E
        2EFF00FFFF00FFFF00FFFF00FF808080FF00FFFF00FFFF00FF80808080808080
        8080808080808080808080808080808080FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF6E23FF7525FF7C28FF812AFF882BFF8F2EFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF80808080
        8080808080808080808080808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
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
      Layout = blGlyphBottom
      Margin = 3
      NumGlyphs = 2
      Spacing = 20
      Transparent = False
      OnClick = btUndoRedoClick
    end
    object btLifeRedo: TSpeedButton
      Left = 29
      Top = 2
      Width = 25
      Height = 25
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        18000000000000060000130B0000130B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF2F0EFF3511FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF808080808080FF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF2E0FFF3411FF3C13FF00FFFF00FFFF4F19FF551CFF5B1EFF621FFF68
        22FF6F24FF7526FF00FFFF00FFFF00FFFF00FF808080808080808080FF00FFFF
        00FF808080808080808080808080808080808080808080FF00FFFF00FFFF00FF
        FF2E0EFF3511FF3C13FF00FFFF00FFFF00FFFF00FFFF5B1DFF621FFF6821FF6F
        23FF7526FF7C27FF00FFFF00FFFF00FF808080808080808080FF00FFFF00FFFF
        00FFFF00FF808080808080808080808080808080808080FF00FFFF00FFFF00FF
        FF3511FF3B13FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF6822FF6E24FF76
        26FF7C28FF822AFF00FFFF00FFFF00FF808080808080FF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FF808080808080808080808080808080FF00FFFF00FFFF00FF
        FF3B13FF4115FF00FFFF00FFFF00FFFF00FFFF00FFFF6821FF6E23FF7526FF7C
        28FF8229FF892BFF00FFFF00FFFF00FF808080808080FF00FFFF00FFFF00FFFF
        00FFFF00FF808080808080808080808080808080808080FF00FFFF00FFFF00FF
        FF4115FF4817FF4E1AFF00FFFF00FFFF00FFFF6821FF6E23FF7525FF7C28FF82
        29FF882BFF8F2EFF00FFFF00FFFF00FF808080808080808080FF00FFFF00FFFF
        00FF808080808080808080808080808080808080808080FF00FFFF00FFFF00FF
        FF00FFFF4E19FF541BFF5B1EFF611FFF6821FF6E24FF7526FF7C27FF822AFF00
        FFFF8F2EFF9530FF00FFFF00FFFF00FFFF00FF80808080808080808080808080
        8080808080808080808080808080FF00FF808080808080FF00FFFF00FFFF00FF
        FF00FFFF551BFF5B1DFF611FFF6822FF6E23FF7526FF7B27FF812AFF00FFFF00
        FFFF00FFFF9C32FF00FFFF00FFFF00FFFF00FF80808080808080808080808080
        8080808080808080808080FF00FFFF00FFFF00FF808080FF00FFFF00FFFF00FF
        FF00FFFF00FFFF611FFF6721FF6E23FF7525FF7C28FF812AFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF80808080808080808080
        8080808080808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
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
      Layout = blGlyphBottom
      Margin = 3
      NumGlyphs = 2
      Spacing = 20
      Transparent = False
      OnClick = btUndoRedoClick
    end
    object btTrackUndo: TSpeedButton
      Left = 67
      Top = 2
      Width = 25
      Height = 25
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        18000000000000060000130B0000130B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00AC0000B000FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FF808080808080FF00FFFF00FFFF00FFFF00FFFF00FF009100
        009400009800009B00009F0000A20000A600FF00FFFF00FF00B00000B30000B7
        00FF00FFFF00FFFF00FFFF00FF80808080808080808080808080808080808080
        8080FF00FFFF00FF808080808080808080FF00FFFF00FFFF00FFFF00FF009400
        009800009B00009F0000A20000A600FF00FFFF00FFFF00FFFF00FF00B70000BA
        0000BE00FF00FFFF00FFFF00FF808080808080808080808080808080808080FF
        00FFFF00FFFF00FFFF00FF808080808080808080FF00FFFF00FFFF00FF009800
        009B00009F0000A20000A600FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00BE
        0000C100FF00FFFF00FFFF00FF808080808080808080808080808080FF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FF808080808080FF00FFFF00FFFF00FF009B00
        009F0000A20000A60000A90000AD00FF00FFFF00FFFF00FFFF00FFFF00FF00C1
        0000C500FF00FFFF00FFFF00FF808080808080808080808080808080808080FF
        00FFFF00FFFF00FFFF00FFFF00FF808080808080FF00FFFF00FFFF00FF009F00
        00A20000A60000A90000AD0000B00000B400FF00FFFF00FFFF00FF00C10000C5
        0000C800FF00FFFF00FFFF00FF80808080808080808080808080808080808080
        8080FF00FFFF00FFFF00FF808080808080808080FF00FFFF00FFFF00FF00A300
        00A600FF00FF00AD0000B00000B40000B70000BB0000BE0000C20000C50000C8
        00FF00FFFF00FFFF00FFFF00FF808080808080FF00FF80808080808080808080
        8080808080808080808080808080808080FF00FFFF00FFFF00FFFF00FF00A600
        FF00FFFF00FFFF00FF00B40000B70000BB0000BE0000C20000C50000C90000CC
        00FF00FFFF00FFFF00FFFF00FF808080FF00FFFF00FFFF00FF80808080808080
        8080808080808080808080808080808080FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF00BB0000BE0000C20000C50000C90000CC00FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF80808080
        8080808080808080808080808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
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
      Layout = blGlyphBottom
      Margin = 3
      NumGlyphs = 2
      Spacing = 20
      Transparent = False
      OnClick = btUndoRedoClick
    end
    object btTrackRedo: TSpeedButton
      Left = 94
      Top = 2
      Width = 25
      Height = 25
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        18000000000000060000130B0000130B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FF009900009C00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF808080808080FF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FF009900009C00009F00FF00FFFF00FF00AA0000AD0000B00000B40000B7
        0000BB0000BE00FF00FFFF00FFFF00FFFF00FF808080808080808080FF00FFFF
        00FF808080808080808080808080808080808080808080FF00FFFF00FFFF00FF
        009900009C00009F00FF00FFFF00FFFF00FFFF00FF00B00000B40000B70000BB
        0000BE0000C100FF00FFFF00FFFF00FF808080808080808080FF00FFFF00FFFF
        00FFFF00FF808080808080808080808080808080808080FF00FFFF00FFFF00FF
        009C00009F00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00B70000BB0000BE
        0000C10000C500FF00FFFF00FFFF00FF808080808080FF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FF808080808080808080808080808080FF00FFFF00FFFF00FF
        009F0000A300FF00FFFF00FFFF00FFFF00FFFF00FF00B70000BB0000BE0000C1
        0000C50000C800FF00FFFF00FFFF00FF808080808080FF00FFFF00FFFF00FFFF
        00FFFF00FF808080808080808080808080808080808080FF00FFFF00FFFF00FF
        00A30000A60000AA00FF00FFFF00FFFF00FF00B70000BB0000BE0000C10000C5
        0000C80000CC00FF00FFFF00FFFF00FF808080808080808080FF00FFFF00FFFF
        00FF808080808080808080808080808080808080808080FF00FFFF00FFFF00FF
        FF00FF00AA0000AD0000B00000B40000B70000BB0000BE0000C10000C500FF00
        FF00CC0000CF00FF00FFFF00FFFF00FFFF00FF80808080808080808080808080
        8080808080808080808080808080FF00FF808080808080FF00FFFF00FFFF00FF
        FF00FF00AD0000B00000B40000B70000BB0000BE0000C10000C500FF00FFFF00
        FFFF00FF00D200FF00FFFF00FFFF00FFFF00FF80808080808080808080808080
        8080808080808080808080FF00FFFF00FFFF00FF808080FF00FFFF00FFFF00FF
        FF00FFFF00FF00B40000B70000BB0000BE0000C10000C500FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF80808080808080808080
        8080808080808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
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
      Layout = blGlyphBottom
      Margin = 3
      NumGlyphs = 2
      Spacing = 20
      Transparent = False
      OnClick = btUndoRedoClick
    end
    object Bevel1: TBevel
      Left = 60
      Top = 2
      Width = 2
      Height = 29
    end
  end
  object btSearch: TBitBtn
    Left = 509
    Top = 3
    Width = 25
    Height = 25
    Hint = 'Script Settings'
    Anchors = [akTop, akRight]
    TabOrder = 8
    OnClick = btSearchClick
    Glyph.Data = {
      36060000424D3606000000000000360000002800000020000000100000000100
      18000000000000060000130B0000130B00000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FF807F7F807F7FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFADADADADADADFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF807F
      7FC2C2C2807F7FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFADADADC2C2C2ADADADFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF807F7FC2C2
      C2807F7FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFADADADC2C2C2ADADADFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF807F7FC2C2C2807F
      7FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFADADADC2C2C2ADADADFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FF807F7F807F7F807F7F807F7F807F7FFF00FF807F7FC2C2C2807F7FFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFADADADADADADADADADADADADAD
      ADADFF00FFADADADC2C2C2ADADADFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      807F7FC2C2C2C2C2C2C2C2C2C2C2C2C2C2C2807F7F807F7F807F7FFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFADADADC2C2C2C2C2C2C2C2C2C2C2C2C2
      C2C2ADADADADADADADADADFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF807F7F
      C2C2C2F39184F4978CF59E93F6A59BF7ACA3C2C2C2807F7FFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFADADADC2C2C2ADADADB2B2B2B7B7B7BDBDBDC2
      C2C2C2C2C2ADADADFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF807F7FC2C2C2
      F39185F4988CF59F94F6A59CF7ACA3F8B3ABF9B9B3C2C2C2807F7FFF00FFFF00
      FFFF00FFFF00FFFF00FFADADADC2C2C2AEAEAEB3B3B3B8B8B8BDBDBDC2C2C2C7
      C7C7CCCCCCC2C2C2ADADADFF00FFFF00FFFF00FFFF00FFFF00FF807F7FC2C2C2
      F4988DF59F95F6A69CF7ADA4F8B3ACF9BAB3FAC1BBC2C2C2807F7FFF00FFFF00
      FFFF00FFFF00FFFF00FFADADADC2C2C2B3B3B3B8B8B8BDBDBDC3C3C3C8C8C8CD
      CDCDD2D2D2C2C2C2ADADADFF00FFFF00FFFF00FFFF00FFFF00FF807F7FC2C2C2
      F5A095F6A69DF7ADA4F8B4ACF9BBB4FAC1BBFBC8C3C2C2C2807F7FFF00FFFF00
      FFFF00FFFF00FFFF00FFADADADC2C2C2B9B9B9BEBEBEC3C3C3C8C8C8CDCDCDD2
      D2D2D7D7D7C2C2C2ADADADFF00FFFF00FFFF00FFFF00FFFF00FF807F7FC2C2C2
      F6A79DF7AEA5F8B4ADF9BBB4FAC2BCFCC9C4FDCFCBC2C2C2807F7FFF00FFFF00
      FFFF00FFFF00FFFF00FFADADADC2C2C2BEBEBEC3C3C3C8C8C8CDCDCDD3D3D3D8
      D8D8DDDDDDC2C2C2ADADADFF00FFFF00FFFF00FFFF00FFFF00FF807F7FC2C2C2
      F7AEA6F8B5ADFABCB5FBC2BDFCC9C4FDD0CCFED7D4C2C2C2807F7FFF00FFFF00
      FFFF00FFFF00FFFF00FFADADADC2C2C2C4C4C4C9C9C9CECECED3D3D3D8D8D8DE
      DEDEE3E3E3C2C2C2ADADADFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF807F7F
      C2C2C2FABCB6FBC3BDFCCAC5FDD0CDFED7D4C2C2C2807F7FFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFADADADC2C2C2CFCFCFD4D4D4D9D9D9DEDEDEE3
      E3E3C2C2C2ADADADFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      807F7FC2C2C2C2C2C2C2C2C2C2C2C2C2C2C2807F7FFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFADADADC2C2C2C2C2C2C2C2C2C2C2C2C2
      C2C2ADADADFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FF807F7F807F7F807F7F807F7F807F7FFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFADADADADADADADADADADADADAD
      ADADFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    NumGlyphs = 2
    Spacing = -1
  end
  object btCompileAc: TBitBtn
    Left = 671
    Top = 3
    Width = 13
    Height = 25
    Anchors = [akTop, akRight]
    TabOrder = 9
    OnClick = btCompileAcClick
    Glyph.Data = {
      AE000000424DAE00000000000000360000002800000007000000050000000100
      18000000000078000000130B0000130B00000000000000000000FF00FFFF00FF
      FF00FF000000FF00FFFF00FFFF00FF000000FF00FFFF00FF0000000000000000
      00FF00FFFF00FF000000FF00FF000000000000000000000000000000FF00FF00
      0000000000000000000000000000000000000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FF000000}
  end
  object abCompileAc: TPopupActionBar
    Left = 464
    object mCompileCur: TMenuItem
      Caption = 'Compile current Actor'#39's scripts'
      Default = True
      OnClick = btCompileClick
    end
    object mCompileAll: TMenuItem
      Caption = 'Compile all Actors'#39' scripts'
      OnClick = mCompileAllClick
    end
  end
end
