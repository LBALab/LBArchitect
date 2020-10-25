object fmSettings: TfmSettings
  Left = 238
  Top = 113
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Settings'
  ClientHeight = 334
  ClientWidth = 633
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001000800680500001600000028000000100000002000
    0000010008000000000000010000000000000000000000010000000100002426
    0C00949A4C00243694004462A400545A2C002C3EAC00343E44008C9AAC00443E
    1C004462CC003C52AC00C4CED400645E5C005C92E4002C321C007C8684004C4A
    34003C56C400344A8400DCDE74007C7E34003C3A2C00747AA400545644002C4A
    AC005C7AD400443A1C00A4A6AC0044462C0074928C003C5EBC0094B6E4003C32
    1C006C8694003C5EC4003C4E9C003C4EBC00A4AEAC002C3E9C00443E2C00847E
    5C0054523C00344AB4005C7EEC00646634003C52BC00444A3C00F4EE8C005C62
    54002C2A1C004C66B4004C563C004466DC004C627C0034322400848A8C003C5A
    CC003C4A94007C8AAC005C5654006486D40094928C0074B2F400A4AEB400ACB2
    5C0024329C003446AC002C426C00443E2400446ACC003C52B400BCF2FC005C6E
    5C006492FC004C4E34003C5AC400DCDE84005C7ABC003C4EAC00547AE4003C3A
    2400A4AABC004C4A2C003C361C00848E9C003C5ECC003452A400243EA4004442
    2C00344EB4003C6AB400949A940084AEF400A4B2B4002C221C009CA24C00545A
    34002C42AC004C4E4C006C96D4004456AC005C625C007C9EDC0034321C008486
    84003C4E8400DCE274007482A4005C5A4400344AAC00547ADC009CA6B4004C46
    2C00445EBC0074829C003C529C006C827C00547AF4003C56BC004C4A3C00F4F6
    9400342E1C003C62BC005C563C00343624008C8A8C003C4E9400545A54008C92
    9400FCFEFC006CB2FC004C6AD4002C42A40024369C0044422400ACAEB400544E
    3400445AC400443A240044361C00445ECC004C422C003C4EB4004875E40012EF
    AC00D7D53000D3243800FFFFFF00D5CD9400D35CC90000000000355370003704
    0E000004010000010000B45B7C000000000000000000000100003E33F40012EF
    6000D35CE800FF04410037040E000004010000010000B45B7C00000001001703
    A00012EF8000F833670000000C001705F800140000001703A0000000010012F0
    5400F58B7B00140000001703A00012F02000F58EC100ED60E000AC0010001703
    A800F833670000000C001705F800140000001703A0000000010012F09000F58B
    7B00140000001703A00012F05C00F58EC100ED60E000AC001000F8A82500F8A8
    430016889800AC001000ED60E000168DC000ED60E00000008000168890000100
    10001400000012EFE4001688980014000000F59685000000000014000000F596
    8500F596A50014060800AC001000000001000000010012F07400E71B8E00E71B
    96001688C00012F0C0000000010016889800AC0010000000000012F0440012F2
    940012F29400E9BB8600E8182000FFFFFF001688980014000000F5968500F596
    A50014060800AC001000000000000000000012F0D000E716E800E716EF00B449
    90004C3AE800000001000000000016889800AC00100012F0A00000000000287B
    701A1A521060016A2F4C786A140E88102E0C48627070862C40135F0462374A70
    351F47748B1C8A5E5E867F371B0F101077211D33584431367F80873A12066C70
    441A792020157F3D3F3A73575754178D27366715655B256B3985421164965844
    79363B5B3F3A435A0D718E098E96207C30371B163902051963642D116E963B37
    6F727E7A22242D61052A46590A965168120218823C6D762D2D4B2283756E0B72
    262D8E380A592D591E3E6603329607642D762D4624762D762B5C6E969696962A
    34462D4B2D46594B6E6E9696969696965996962A592209599696969696969696
    96969696244F499696969696969696969696969659594D969696969696960000
    0000000000000000000000000000000000000001000000010000000100000001
    0000000000000001000000070000800F0000D83F0000FC7F0000FC7F0000}
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pcSettings: TPageControl
    Left = 163
    Top = 3
    Width = 465
    Height = 294
    ActivePage = tsScriptsDec
    MultiLine = True
    TabOrder = 0
    object tsGeneral: TTabSheet
      Caption = 'General'
      ImageIndex = 2
      TabVisible = False
      object cbResetClip: TCheckBox
        Left = 8
        Top = 9
        Width = 217
        Height = 17
        Caption = 'Reset clipping after placing a Layout'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = cbResetClipClick
      end
      object cbAskDelLayer: TCheckBox
        Left = 8
        Top = 33
        Width = 153
        Height = 17
        Caption = 'Ask before deleting a layer'
        TabOrder = 1
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 136
        Width = 305
        Height = 129
        Caption = 'Compression when saving (applies to Grid and Scene files):'
        TabOrder = 2
        object Label27: TLabel
          Left = 8
          Top = 34
          Width = 203
          Height = 13
          Caption = 'Use compression when saving into a HQR:'
        end
        object Label28: TLabel
          Left = 216
          Top = 16
          Width = 35
          Height = 13
          Caption = 'LBA 1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label29: TLabel
          Left = 264
          Top = 16
          Width = 35
          Height = 13
          Caption = 'LBA 2'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label30: TLabel
          Left = 22
          Top = 57
          Width = 189
          Height = 13
          Caption = 'Use compression type of the original file:'
        end
        object Label31: TLabel
          Left = 87
          Top = 73
          Width = 124
          Height = 13
          Caption = 'Force compression type 1:'
        end
        object Label32: TLabel
          Left = 87
          Top = 89
          Width = 124
          Height = 13
          Caption = 'Force compression type 2:'
        end
        object Label33: TLabel
          Left = 88
          Top = 105
          Width = 123
          Height = 13
          Caption = 'Always ask before saving:'
        end
        object cbUseComp1: TCheckBox
          Left = 225
          Top = 32
          Width = 17
          Height = 17
          TabOrder = 0
          OnClick = cbUseComp1Click
        end
        object cbUseComp2: TCheckBox
          Left = 273
          Top = 32
          Width = 17
          Height = 17
          TabOrder = 1
          OnClick = cbUseComp1Click
        end
        object paComp2: TPanel
          Left = 265
          Top = 48
          Width = 33
          Height = 73
          BevelOuter = bvNone
          TabOrder = 2
          object rbCm2UseOrg: TRadioButton
            Left = 8
            Top = 8
            Width = 17
            Height = 17
            Checked = True
            TabOrder = 0
            TabStop = True
          end
          object rbCm2Force1: TRadioButton
            Left = 8
            Top = 24
            Width = 17
            Height = 17
            TabOrder = 1
          end
          object rbCm2Force2: TRadioButton
            Left = 8
            Top = 40
            Width = 17
            Height = 17
            TabOrder = 2
          end
          object rbCm2Ask: TRadioButton
            Left = 8
            Top = 56
            Width = 17
            Height = 17
            TabOrder = 3
          end
        end
        object paComp1: TPanel
          Left = 217
          Top = 48
          Width = 33
          Height = 73
          BevelOuter = bvNone
          TabOrder = 3
          object rbCm1UseOrg: TRadioButton
            Left = 8
            Top = 8
            Width = 17
            Height = 17
            Checked = True
            TabOrder = 0
            TabStop = True
          end
          object rbCm1Force1: TRadioButton
            Left = 8
            Top = 24
            Width = 17
            Height = 17
            TabOrder = 1
          end
          object rbCm1Ask: TRadioButton
            Left = 8
            Top = 56
            Width = 17
            Height = 17
            TabOrder = 2
          end
        end
      end
      object cbFirstIndex1: TCheckBox
        Left = 167
        Top = 58
        Width = 83
        Height = 17
        Caption = 'Start with 1'
        TabOrder = 3
      end
      object cbSingleInvPlacing: TCheckBox
        Left = 8
        Top = 81
        Width = 281
        Height = 17
        Caption = 'End Invisible Wall creating mode after first placing'
        TabOrder = 4
      end
      object cbAutoMainGrid: TCheckBox
        Left = 8
        Top = 105
        Width = 281
        Height = 17
        Caption = 'Swich to Main Grid when entering Scene Mode'
        TabOrder = 5
      end
      object cbShowIndexes: TCheckBox
        Left = 8
        Top = 58
        Width = 153
        Height = 17
        Caption = 'Display HQR entry indexes'
        TabOrder = 6
      end
    end
    object tsPaths: TTabSheet
      Caption = 'Paths'
      ImageIndex = 1
      TabVisible = False
      object Label1: TLabel
        Left = 3
        Top = 8
        Width = 450
        Height = 13
        Caption = 
          'After changing the working dir, files currently being edited are' +
          ' still saved to the original locations.'
      end
      object gbPaths1: TGroupBox
        Left = 3
        Top = 35
        Width = 451
        Height = 94
        Caption = 'LBA 1:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object rbDir11: TRadioButton
          Left = 8
          Top = 22
          Width = 97
          Height = 17
          Caption = 'Base dirctory (1):'
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          TabStop = True
        end
        object rbDir12: TRadioButton
          Left = 8
          Top = 43
          Width = 89
          Height = 17
          Caption = 'Working dir (2):'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object rbDir13: TRadioButton
          Left = 8
          Top = 64
          Width = 89
          Height = 17
          Caption = 'Working dir (3):'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
      end
      object gbPaths2: TGroupBox
        Left = 3
        Top = 151
        Width = 451
        Height = 94
        Caption = 'LBA 2:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object rbDir21: TRadioButton
          Left = 8
          Top = 22
          Width = 97
          Height = 17
          Caption = 'Base dirctory (1):'
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          TabStop = True
        end
        object rbDir22: TRadioButton
          Left = 8
          Top = 43
          Width = 89
          Height = 17
          Caption = 'Working dir (2):'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object rbDir23: TRadioButton
          Left = 8
          Top = 64
          Width = 89
          Height = 17
          Caption = 'Working dir (3):'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
      end
    end
    object tsMouse: TTabSheet
      Caption = 'Mouse wheel'
      ImageIndex = 3
      TabVisible = False
      object Label14: TLabel
        Left = 26
        Top = 33
        Width = 66
        Height = 13
        Caption = 'Wheel speed:'
      end
      object Label15: TLabel
        Left = 151
        Top = 26
        Width = 201
        Height = 32
        AutoSize = False
        Caption = 'Change this value if your wheels work too slow or too fast.'
        WordWrap = True
      end
      object Label16: TLabel
        Left = 16
        Top = 89
        Width = 81
        Height = 17
        AutoSize = False
        Caption = 'Wheel average:'
        WordWrap = True
      end
      object Label17: TLabel
        Left = 151
        Top = 70
        Width = 218
        Height = 53
        AutoSize = False
        Caption = 
          'This value is used to distinguish vertical wheel from horizontal' +
          ' one. If your both wheels work as vertical, try smaller values. ' +
          'If both work as horizontal, try larger values.'
        WordWrap = True
      end
      object eWSpeed: TEdit
        Left = 96
        Top = 30
        Width = 49
        Height = 21
        MaxLength = 3
        TabOrder = 0
        Text = '20'
      end
      object eWAverage: TEdit
        Left = 96
        Top = 86
        Width = 49
        Height = 21
        MaxLength = 4
        TabOrder = 1
        Text = '180'
      end
      object cbWInvX: TCheckBox
        Left = 16
        Top = 154
        Width = 113
        Height = 17
        Caption = 'Invert wheel X axis'
        TabOrder = 2
      end
      object cbWInvY: TCheckBox
        Left = 16
        Top = 170
        Width = 113
        Height = 17
        Caption = 'Invert wheel Y axis'
        TabOrder = 3
      end
    end
    object tsCoords: TTabSheet
      Caption = 'Coordinates'
      ImageIndex = 4
      TabVisible = False
      object GroupBox7: TGroupBox
        Left = 3
        Top = 1
        Width = 451
        Height = 178
        Caption = 'In normal mode:'
        TabOrder = 0
        object Label18: TLabel
          Left = 176
          Top = 25
          Width = 72
          Height = 13
          Caption = 'Cursor: [x, y, z] '
        end
        object Label19: TLabel
          Left = 176
          Top = 41
          Width = 83
          Height = 13
          Caption = 'Selection: [x, y, z]'
        end
        object Label20: TLabel
          Left = 176
          Top = 57
          Width = 134
          Height = 13
          Caption = 'Layout: A, Brick: B, Piece: C'
        end
        object cbDispCur: TCheckBox
          Left = 8
          Top = 24
          Width = 153
          Height = 17
          Caption = 'Display cursor/place coords:'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object cbDispSel: TCheckBox
          Left = 8
          Top = 40
          Width = 161
          Height = 17
          Caption = 'Display selection coordinates:'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object GroupBox3: TGroupBox
          Left = 8
          Top = 111
          Width = 321
          Height = 58
          Caption = 'Way of displ. range coords:'
          TabOrder = 2
          object rbRangeSep: TRadioButton
            Left = 8
            Top = 16
            Width = 153
            Height = 17
            Caption = '[x1, y1, z1] '#247' [x2, y2, z2]'
            Checked = True
            TabOrder = 0
            TabStop = True
            OnClick = cbDispBrkClick
          end
          object rbRangeCon: TRadioButton
            Left = 8
            Top = 32
            Width = 137
            Height = 17
            Caption = '[x1:x2, y1:y2, z1:z2]'
            TabOrder = 1
            OnClick = cbDispBrkClick
          end
          object cbRangeHide: TCheckBox
            Left = 167
            Top = 24
            Width = 137
            Height = 17
            Caption = 'Merge equal coords'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
        end
        object cbDispBrk: TCheckBox
          Left = 8
          Top = 56
          Width = 121
          Height = 17
          Caption = 'Display brick info:'
          Checked = True
          State = cbChecked
          TabOrder = 3
          OnClick = cbDispBrkClick
        end
        object rbAtCursor: TRadioButton
          Left = 24
          Top = 72
          Width = 121
          Height = 17
          Caption = 'of brick at cursor'
          Checked = True
          TabOrder = 4
          TabStop = True
        end
        object rbSelected: TRadioButton
          Left = 24
          Top = 88
          Width = 137
          Height = 17
          Caption = 'of selected brick'
          TabOrder = 5
        end
      end
      object GroupBox8: TGroupBox
        Left = 3
        Top = 183
        Width = 451
        Height = 98
        Caption = 'In scene mode:'
        TabOrder = 1
        object Label21: TLabel
          Left = 160
          Top = 25
          Width = 33
          Height = 13
          Caption = '[x, y, z]'
        end
        object Label23: TLabel
          Left = 160
          Top = 41
          Width = 99
          Height = 13
          Caption = '[x*512, y*256, z*512]'
        end
        object Label24: TLabel
          Left = 272
          Top = 25
          Width = 118
          Height = 13
          Caption = '(x, y, z are scene coords)'
        end
        object Label25: TLabel
          Left = 272
          Top = 41
          Width = 112
          Height = 13
          Caption = '(x, y, z are brick coords)'
        end
        object Label22: TLabel
          Left = 160
          Top = 57
          Width = 22
          Height = 13
          Caption = '[x, y]'
        end
        object Label26: TLabel
          Left = 272
          Top = 57
          Width = 110
          Height = 13
          Caption = '(x, y are screen coords)'
        end
        object cbScenePix: TCheckBox
          Left = 8
          Top = 24
          Width = 129
          Height = 17
          Caption = 'Display scene coords:'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object cbSceneBrk: TCheckBox
          Left = 8
          Top = 40
          Width = 137
          Height = 17
          Caption = 'Display brick/scene:'
          TabOrder = 1
        end
        object cbSceneClip: TCheckBox
          Left = 8
          Top = 56
          Width = 137
          Height = 17
          Caption = 'Display clipping coords:'
          TabOrder = 2
        end
        object cbSceneSel: TCheckBox
          Left = 8
          Top = 72
          Width = 201
          Height = 17
          Caption = 'Display selected object'#39's coordinates'
          TabOrder = 3
        end
      end
    end
    object tsScene: TTabSheet
      Caption = 'Scene'
      ImageIndex = 5
      TabVisible = False
      object Label47: TLabel
        Left = 33
        Top = 24
        Width = 182
        Height = 13
        Caption = '(in X and Z axes it snaps to half bricks)'
      end
      object gbZoneColours: TGroupBox
        Left = 16
        Top = 73
        Width = 369
        Height = 193
        Caption = 'Zone colours:'
        TabOrder = 0
        object lbZone2: TLabel
          Left = 16
          Top = 68
          Width = 97
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Sceneric zones:'
        end
        object lbZone0: TLabel
          Left = 9
          Top = 20
          Width = 104
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Cube zones:'
        end
        object lbZone1: TLabel
          Left = 16
          Top = 44
          Width = 97
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Camera zones:'
        end
        object lbZone3: TLabel
          Left = 32
          Top = 92
          Width = 81
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Fragment zones:'
          WordWrap = True
        end
        object lbZone5: TLabel
          Left = 32
          Top = 140
          Width = 81
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Text zones:'
        end
        object lbZone4: TLabel
          Left = 24
          Top = 116
          Width = 89
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Bonus zones:'
        end
        object lbZone6: TLabel
          Left = 24
          Top = 164
          Width = 89
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Ladder zones:'
          WordWrap = True
        end
        object lbZone8: TLabel
          Left = 184
          Top = 44
          Width = 89
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Spike zones:'
          WordWrap = True
        end
        object lbZone7: TLabel
          Left = 184
          Top = 20
          Width = 89
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Conveyor zones:'
          WordWrap = True
        end
        object lbZone9: TLabel
          Left = 184
          Top = 68
          Width = 89
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Rail zones:'
          WordWrap = True
        end
      end
      object cbSceneSnap: TCheckBox
        Left = 16
        Top = 8
        Width = 249
        Height = 17
        Caption = 'Snap Scene elements to Grid when moving'
        TabOrder = 1
      end
      object cbGroupUndoObj: TCheckBox
        Left = 16
        Top = 50
        Width = 193
        Height = 17
        Caption = 'Group undo for Scene objects '
        TabOrder = 2
        Visible = False
      end
    end
    object tsScriptsGen: TTabSheet
      Caption = 'Scripts - general'
      ImageIndex = 6
      TabVisible = False
      object lbEditorFontSize: TLabel
        Left = 16
        Top = 98
        Width = 72
        Height = 13
        Caption = 'Editor font size:'
      end
      object lbTplEditor: TLabel
        Left = 16
        Top = 133
        Width = 175
        Height = 13
        Caption = 'Template editor (a regular text editor):'
      end
      object Label49: TLabel
        Left = 34
        Top = 52
        Width = 152
        Height = 13
        Caption = '(otherwise Ctrl + Space to show)'
      end
      object cbScriptToActor: TCheckBox
        Left = 16
        Top = 16
        Width = 345
        Height = 17
        Caption = 
          'Update selected Actor when Actor ID in the Script Editor is chan' +
          'ged'
        TabOrder = 0
      end
      object cbCompletionProp: TCheckBox
        Left = 16
        Top = 35
        Width = 345
        Height = 17
        Caption = 'Show Completion Proposal automatically when editing'
        TabOrder = 1
      end
      object cbGroupUndoTxt: TCheckBox
        Left = 16
        Top = 70
        Width = 217
        Height = 17
        Caption = 'Group undo in the Script editor'
        TabOrder = 2
      end
    end
    object tsScriptsDec: TTabSheet
      Caption = 'Scripts - decomp'
      ImageIndex = 8
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 10
      object Label4: TLabel
        Left = 16
        Top = 90
        Width = 156
        Height = 13
        Caption = 'Name the first COMPORTMENT:'
      end
      object cbUpperCase: TCheckBox
        Left = 16
        Top = 22
        Width = 97
        Height = 17
        Caption = 'UPPER CASE'
        TabOrder = 0
      end
      object cbIndentTrack: TCheckBox
        Left = 16
        Top = 38
        Width = 153
        Height = 17
        Caption = 'Indent Track Scripts'
        TabOrder = 1
      end
      object cbIndentLife: TCheckBox
        Left = 16
        Top = 54
        Width = 153
        Height = 17
        Caption = 'Indent Life Scripts'
        TabOrder = 2
      end
      object rbFirstCompMain: TRadioButton
        Left = 32
        Top = 109
        Width = 113
        Height = 17
        Caption = #39'main'#39
        TabOrder = 3
      end
      object rbFirstComp0: TRadioButton
        Left = 32
        Top = 125
        Width = 113
        Height = 17
        Caption = #39'0'#39
        TabOrder = 4
      end
      object cbAddEndSwitch: TCheckBox
        Left = 16
        Top = 209
        Width = 212
        Height = 17
        Caption = 'Add missing END_SWITCH (LBA2 only)'
        TabOrder = 5
        Visible = False
      end
      object GroupBox1: TGroupBox
        Left = 234
        Top = 14
        Width = 209
        Height = 259
        Caption = 'Macro name sets'
        TabOrder = 6
        object Label2: TLabel
          Left = 8
          Top = 80
          Width = 29
          Height = 13
          Caption = 'LBA1:'
        end
        object Label3: TLabel
          Left = 8
          Top = 136
          Width = 29
          Height = 13
          Caption = 'LBA2:'
        end
        object Label36: TLabel
          Left = 8
          Top = 192
          Width = 88
          Height = 13
          Caption = 'COMPORTMENT:'
        end
        object Label37: TLabel
          Left = 8
          Top = 16
          Width = 190
          Height = 29
          AutoSize = False
          Caption = 
            'These settings also apply to the command completion proposal lis' +
            'ts.'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          WordWrap = True
        end
        object Label38: TLabel
          Left = 8
          Top = 47
          Width = 190
          Height = 26
          AutoSize = False
          Caption = 'These settings take effect only when a new Scene is opened.'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 30685
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          WordWrap = True
        end
        object paNameLBA1: TPanel
          Left = 13
          Top = 92
          Width = 182
          Height = 40
          BevelOuter = bvNone
          TabOrder = 0
          object rbMacro1Org: TRadioButton
            Left = 4
            Top = 6
            Width = 183
            Height = 17
            Caption = 'Original set (e.g. BULLE_ON)'
            TabOrder = 0
          end
          object rbMacro1Eng: TRadioButton
            Left = 4
            Top = 21
            Width = 183
            Height = 17
            Caption = 'English set (e.g. BALLOON_ON)'
            TabOrder = 1
          end
        end
        object Panel4: TPanel
          Left = 13
          Top = 148
          Width = 182
          Height = 40
          BevelOuter = bvNone
          TabOrder = 1
          object rbMacro2Org: TRadioButton
            Left = 4
            Top = 6
            Width = 183
            Height = 17
            Caption = 'Original set (e.g. PLUIE)'
            TabOrder = 0
          end
          object rbMacro2Eng: TRadioButton
            Left = 4
            Top = 21
            Width = 183
            Height = 17
            Caption = 'English set (e.g. RAIN)'
            TabOrder = 1
          end
        end
        object Panel5: TPanel
          Left = 13
          Top = 204
          Width = 182
          Height = 40
          BevelOuter = bvNone
          TabOrder = 2
          object rbCompoOrg: TRadioButton
            Left = 4
            Top = 6
            Width = 183
            Height = 17
            Caption = 'Original (COMPORTEMENT)'
            TabOrder = 0
          end
          object rbCompoEng: TRadioButton
            Left = 4
            Top = 21
            Width = 183
            Height = 17
            Caption = 'English (COMPORTMENT)'
            TabOrder = 1
          end
        end
      end
    end
    object tsScriptsCom: TTabSheet
      Caption = 'Scripts - compilation'
      ImageIndex = 7
      TabVisible = False
      object GroupBox10: TGroupBox
        Left = 14
        Top = 16
        Width = 208
        Height = 121
        Caption = 'Misc:'
        TabOrder = 0
        object cbRequireENDs: TCheckBox
          Left = 16
          Top = 41
          Width = 185
          Height = 17
          Caption = 'Require ENDs (recommended)'
          TabOrder = 0
        end
        object cbNotStrictSyntax: TCheckBox
          Left = 16
          Top = 21
          Width = 185
          Height = 17
          Caption = 'Allow for original Script quirks'
          TabOrder = 1
        end
        object cbAutoHLError: TCheckBox
          Left = 16
          Top = 72
          Width = 177
          Height = 17
          Caption = 'Highlight errors automatically'
          TabOrder = 2
          OnClick = cbAutoHLErrorClick
        end
        object cbAutoHLVisOnly: TCheckBox
          Left = 30
          Top = 89
          Width = 171
          Height = 17
          Caption = 'Only for currently visible Scripts'
          TabOrder = 3
        end
      end
      object GroupBox12: TGroupBox
        Left = 233
        Top = 16
        Width = 208
        Height = 121
        Caption = 'Show warnings for:'
        TabOrder = 1
        object cbLabelWarnings: TCheckBox
          Left = 13
          Top = 21
          Width = 113
          Height = 17
          Caption = 'Missing LABEL IDs'
          TabOrder = 0
        end
        object cbLbUnusedWarns: TCheckBox
          Left = 13
          Top = 37
          Width = 113
          Height = 17
          Caption = 'Unused LABELs'
          TabOrder = 1
        end
        object cbCompUnusedWarns: TCheckBox
          Left = 13
          Top = 53
          Width = 161
          Height = 17
          Caption = 'Unused COMPORTMENTs'
          TabOrder = 2
        end
        object cbCheckZones: TCheckBox
          Left = 13
          Top = 69
          Width = 161
          Height = 17
          Caption = 'Invalid Zone virtual IDs'
          TabOrder = 3
        end
        object cbCheckSuit: TCheckBox
          Left = 13
          Top = 85
          Width = 161
          Height = 17
          Hint = 
            'For example: if a Sprite-Actor-specific command is used for a 3D' +
            '-Actor'
          Caption = 'Not suitable commands'
          TabOrder = 4
        end
      end
      object GroupBox13: TGroupBox
        Left = 14
        Top = 160
        Width = 427
        Height = 105
        Caption = 
          'Errors that don'#39't prevent compilation (but may cause the game to' +
          ' crash):'
        TabOrder = 2
        object Label6: TLabel
          Left = 166
          Top = 24
          Width = 52
          Height = 13
          Caption = 'Treat as:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Panel1: TPanel
          Left = 75
          Top = 41
          Width = 265
          Height = 17
          BevelOuter = bvNone
          TabOrder = 0
          object Label35: TLabel
            Left = 5
            Top = 1
            Width = 79
            Height = 13
            Caption = 'Invalid Track ID:'
          end
          object rbTrackNothing: TRadioButton
            Left = 90
            Top = 0
            Width = 57
            Height = 17
            Caption = 'Nothing'
            TabOrder = 0
          end
          object rbTrackWarning: TRadioButton
            Left = 154
            Top = 0
            Width = 65
            Height = 17
            Caption = 'Warning'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 28880
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
          object rbTrackError: TRadioButton
            Left = 219
            Top = 0
            Width = 44
            Height = 17
            Caption = 'Error'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
          end
        end
        object Panel2: TPanel
          Left = 75
          Top = 57
          Width = 265
          Height = 17
          BevelOuter = bvNone
          TabOrder = 1
          object Label45: TLabel
            Left = 8
            Top = 1
            Width = 76
            Height = 13
            Caption = 'Invalid Actor ID:'
          end
          object rbActorNothing: TRadioButton
            Left = 90
            Top = 0
            Width = 57
            Height = 17
            Caption = 'Nothing'
            TabOrder = 0
          end
          object rbActorWarning: TRadioButton
            Left = 154
            Top = 0
            Width = 65
            Height = 17
            Caption = 'Warning'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 28880
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
          object rbActorError: TRadioButton
            Left = 219
            Top = 0
            Width = 44
            Height = 17
            Caption = 'Error'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
          end
        end
        object Panel3: TPanel
          Left = 11
          Top = 73
          Width = 329
          Height = 17
          BevelOuter = bvNone
          TabOrder = 2
          object Label44: TLabel
            Left = 4
            Top = 1
            Width = 144
            Height = 13
            Caption = 'Invalid Body or Anim virtual ID:'
          end
          object rbBdAnNothing: TRadioButton
            Left = 154
            Top = 0
            Width = 57
            Height = 17
            Caption = 'Nothing'
            TabOrder = 0
          end
          object rbBdAnWarning: TRadioButton
            Left = 218
            Top = 0
            Width = 65
            Height = 17
            Caption = 'Warning'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 28880
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
          object rbBdAnError: TRadioButton
            Left = 283
            Top = 0
            Width = 44
            Height = 17
            Caption = 'Error'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
          end
        end
      end
    end
    object tsFrames: TTabSheet
      Caption = 'Frames'
      TabVisible = False
      object gbMainColours: TGroupBox
        Left = 11
        Top = 19
        Width = 217
        Height = 233
        Caption = 'Colours:'
        TabOrder = 0
        object Label5: TLabel
          Left = 36
          Top = 64
          Width = 120
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Layouts on layout panel'
        end
        object Label7: TLabel
          Left = 52
          Top = 16
          Width = 104
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Main image'
        end
        object Label8: TLabel
          Left = 60
          Top = 88
          Width = 96
          Height = 13
          Caption = 'Layout being placed'
        end
        object Label9: TLabel
          Left = 28
          Top = 40
          Width = 128
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Main window net'
        end
        object Label10: TLabel
          Left = 126
          Top = 184
          Width = 30
          Height = 13
          Caption = 'Cursor'
        end
        object Label11: TLabel
          Left = 112
          Top = 160
          Width = 44
          Height = 13
          Caption = 'Selection'
        end
        object Label12: TLabel
          Left = 120
          Top = 208
          Width = 36
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Helper'
          WordWrap = True
        end
        object Label13: TLabel
          Left = 87
          Top = 112
          Width = 69
          Height = 13
          Caption = 'Invisible bricks'
        end
        object Label34: TLabel
          Left = 120
          Top = 137
          Width = 36
          Height = 13
          Caption = 'Shapes'
        end
        object btRestCol: TButton
          Left = 7
          Top = 200
          Width = 102
          Height = 25
          Caption = 'Restore defaults'
          TabOrder = 0
          OnClick = btRestColClick
        end
      end
      object cbNewFrames: TCheckBox
        Left = 267
        Top = 105
        Width = 166
        Height = 17
        Caption = 'New style of main image frames'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = cbNewFramesClick
      end
      object rbNewFrEdge: TRadioButton
        Left = 283
        Top = 121
        Width = 65
        Height = 17
        Caption = 'by edges'
        TabOrder = 2
        OnClick = cbNewFramesClick
      end
      object rbNewFrObj: TRadioButton
        Left = 283
        Top = 137
        Width = 73
        Height = 17
        Caption = 'by objects'
        Checked = True
        TabOrder = 3
        TabStop = True
        OnClick = cbNewFramesClick
      end
    end
  end
  object btOK: TBitBtn
    Left = 184
    Top = 303
    Width = 121
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
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
    Left = 328
    Top = 303
    Width = 121
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object lbPages: TListBox
    Left = 8
    Top = 8
    Width = 149
    Height = 289
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 24
    Items.Strings = (
      'General'
      'Paths'
      'Frames'
      'Mouse Wheel'
      'Coordinates'
      'Scene'
      'Scripts - general'
      'Scripts - decompilation'
      'Scripts - compilation')
    ParentFont = False
    TabOrder = 3
    OnClick = lbPagesClick
  end
end
