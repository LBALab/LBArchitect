object fmProject: TfmProject
  Left = 353
  Top = 279
  Caption = 'Project options'
  ClientHeight = 452
  ClientWidth = 493
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  OnShow = cbOverrideFragClick
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 473
    Height = 409
    ActivePage = tsGeneral
    TabOrder = 0
    object tsGeneral: TTabSheet
      Caption = 'General'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 28
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label10: TLabel
        Left = 34
        Top = 73
        Width = 417
        Height = 33
        AutoSize = False
        Caption = 
          'This option uses information stored in Scenario (HQS) files to a' +
          'utomatically create all necessary Fragment entries (also called ' +
          #39'disappearing ceiling Grids'#39').'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label14: TLabel
        Left = 290
        Top = 144
        Width = 102
        Height = 13
        Caption = '(index starting with 1) '
      end
      object Label13: TLabel
        Left = 34
        Top = 163
        Width = 409
        Height = 52
        AutoSize = False
        Caption = 
          'The first LBA 1 Fragment row index is 121 and it is hard-coded i' +
          'n the game engine, so this option should not be used in general.' +
          ' However, it is probably possible to modify this value by hex-ed' +
          'iting the LBA 1 executable file and change the index this way. T' +
          'his option may be useful in such case.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label6: TLabel
        Left = 34
        Top = 221
        Width = 417
        Height = 44
        AutoSize = False
        Caption = 
          'This value determines maximum number of Maps (Grids and Fragment' +
          's) that can be put into the game. The Map limit is computed from' +
          ' the following equation:'#13'Total_Maps = 256 + First_Frag_Index - 1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label7: TLabel
        Left = 34
        Top = 271
        Width = 409
        Height = 52
        AutoSize = False
        Caption = 
          'Care should be taken when using more than First_Frag_Index - 1 G' +
          'rids and creating Fragments manually, since in such case Fragmen' +
          't indexes in the Scene must be manually increased by the distanc' +
          'e from First_Frag_Index to the actual index of the first Fragmen' +
          't.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label11: TLabel
        Left = 34
        Top = 29
        Width = 417
        Height = 14
        AutoSize = False
        Caption = 
          'Speeds up building of large projects. Used for development && te' +
          'sting'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object cbAutoFrag: TCheckBox
        Left = 16
        Top = 57
        Width = 345
        Height = 17
        Caption = 'Automatic Fragment entries creation (experimental)'
        TabOrder = 0
      end
      object edFirstFrag: TEdit
        Left = 234
        Top = 141
        Width = 49
        Height = 21
        TabOrder = 1
        Text = '0'
      end
      object cbOverrideFrag: TCheckBox
        Left = 16
        Top = 143
        Width = 215
        Height = 17
        Caption = 'Override default LBA 1 first Fragment row:'
        TabOrder = 2
        OnClick = cbOverrideFragClick
      end
      object cbCompOptOff: TCheckBox
        Left = 16
        Top = 14
        Width = 376
        Height = 17
        Caption = 'Turn compression and optimization off'
        TabOrder = 3
        OnClick = cbCompOptOffClick
      end
      object btAutoFragHelp: TBitBtn
        Left = 34
        Top = 103
        Width = 161
        Height = 21
        Caption = 'So how exactly does it work?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = btAutoFragHelpClick
        NumGlyphs = 2
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Compression'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lbCompOff: TLabel
        Left = 16
        Top = 5
        Width = 236
        Height = 13
        Caption = 'Compression is disabled globally. See General tab.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object GroupBox1: TGroupBox
        Left = 16
        Top = 24
        Width = 193
        Height = 81
        Caption = 'LBA 1:'
        TabOrder = 0
        object rb1CompNone: TRadioButton
          Left = 8
          Top = 16
          Width = 137
          Height = 17
          Caption = 'Don'#39't use compression'
          TabOrder = 0
        end
        object rb1CompAlways: TRadioButton
          Left = 8
          Top = 32
          Width = 137
          Height = 17
          Caption = 'Always use compression'
          TabOrder = 1
        end
        object rb1CompAuto: TRadioButton
          Left = 8
          Top = 48
          Width = 169
          Height = 17
          Caption = 'Auto'
          Checked = True
          TabOrder = 2
          TabStop = True
        end
      end
      object GroupBox2: TGroupBox
        Left = 240
        Top = 24
        Width = 209
        Height = 137
        Caption = 'LBA 2:'
        Enabled = False
        TabOrder = 1
        object rb2CompNone: TRadioButton
          Left = 8
          Top = 16
          Width = 137
          Height = 17
          Caption = 'Don'#39't use compression'
          TabOrder = 0
        end
        object rb2CompAuto: TRadioButton
          Left = 8
          Top = 64
          Width = 169
          Height = 17
          Caption = 'Auto (slower, but better results):'
          Checked = True
          TabOrder = 1
          TabStop = True
        end
        object rb2CompAlways1: TRadioButton
          Left = 8
          Top = 32
          Width = 169
          Height = 17
          Caption = 'Always use compression type 1'
          TabOrder = 2
        end
        object rb2CompAlways2: TRadioButton
          Left = 8
          Top = 48
          Width = 169
          Height = 17
          Caption = 'Always use compression type 2'
          TabOrder = 3
        end
        object Panel1: TPanel
          Left = 16
          Top = 80
          Width = 185
          Height = 49
          BevelOuter = bvNone
          Caption = 'Panel1'
          TabOrder = 4
          object rb2AutoBoth: TRadioButton
            Left = 8
            Top = 0
            Width = 169
            Height = 17
            Caption = 'Both compression type 1 and 2'
            Checked = True
            TabOrder = 0
            TabStop = True
          end
          object rb2AutoOnly1: TRadioButton
            Left = 8
            Top = 16
            Width = 113
            Height = 17
            Caption = 'Type 1 only'
            TabOrder = 1
          end
          object rb2AutoOnly2: TRadioButton
            Left = 8
            Top = 32
            Width = 113
            Height = 17
            Caption = 'Type 2 only'
            TabOrder = 2
          end
        end
      end
      object GroupBox3: TGroupBox
        Left = 24
        Top = 168
        Width = 425
        Height = 201
        Caption = 'Auto compression settings:'
        TabOrder = 2
        object Label1: TLabel
          Left = 8
          Top = 88
          Width = 219
          Height = 13
          Caption = 'Compress a file when file size benefit is at least'
        end
        object Label2: TLabel
          Left = 22
          Top = 128
          Width = 209
          Height = 25
          AutoSize = False
          Caption = 
            'Use compression type 1 instead of type 2 when decompression time' +
            ' benefit is at least '
          Enabled = False
          WordWrap = True
        end
        object Label4: TLabel
          Left = 65
          Top = 165
          Width = 160
          Height = 13
          Caption = 'and file size loss is not higher than'
          Enabled = False
        end
        object Label3: TLabel
          Left = 8
          Top = 16
          Width = 409
          Height = 57
          AutoSize = False
          Caption = 
            'Auto compression tries to compress each file (using both type 1 ' +
            'and 2 if it is set to), and checks if it meets the rules below. ' +
            'Then it uses the compressed or uncompressed file depending on th' +
            'e result. For LBA 2 this type takes more time, because program h' +
            'as to compress each file and decompress it before it can make a ' +
            'decision.'
          WordWrap = True
        end
        object Label5: TLabel
          Left = 8
          Top = 112
          Width = 57
          Height = 13
          Caption = 'LBA 2 only: '
          Enabled = False
        end
        object eMinSizeBenefit: TEdit
          Left = 231
          Top = 84
          Width = 57
          Height = 21
          TabOrder = 0
          Text = '10'
        end
        object cbMinSizeBenefit: TComboBox
          Left = 295
          Top = 84
          Width = 65
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 1
          Text = '%'
          Items.Strings = (
            '%'
            'kB')
        end
        object eMinTimeBenefit: TEdit
          Left = 230
          Top = 137
          Width = 57
          Height = 21
          Enabled = False
          TabOrder = 2
          Text = '0,1'
        end
        object eMaxSizeLoss: TEdit
          Left = 230
          Top = 161
          Width = 57
          Height = 21
          Enabled = False
          TabOrder = 3
          Text = '10'
        end
        object cbMaxSizeLoss: TComboBox
          Left = 294
          Top = 161
          Width = 65
          Height = 21
          Style = csDropDownList
          Enabled = False
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 4
          Text = '%'
          Items.Strings = (
            '%'
            'kB')
        end
        object cbMinTimeBenefit: TComboBox
          Left = 294
          Top = 137
          Width = 65
          Height = 21
          Style = csDropDownList
          Enabled = False
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 5
          Text = '%'
          Items.Strings = (
            '%'
            'seconds')
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Optimizations and stuff'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox4: TGroupBox
        Left = 10
        Top = 6
        Width = 444
        Height = 147
        Caption = 
          'Optimizations (reduce compiled HQR size at cost of compilation t' +
          'ime):'
        TabOrder = 0
        object lbOptOff: TLabel
          Left = 16
          Top = 20
          Width = 233
          Height = 13
          Caption = 'Optimization is disabled globally. See General tab.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object cbUseRepeated: TCheckBox
          Left = 16
          Top = 39
          Width = 137
          Height = 17
          Caption = 'Use repeated entries'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object cbLtsRemUnused: TCheckBox
          Left = 16
          Top = 69
          Width = 153
          Height = 17
          Caption = 'Remove unused Layouts'
          Enabled = False
          TabOrder = 1
        end
        object cbBrkRemDoubled: TCheckBox
          Left = 16
          Top = 101
          Width = 145
          Height = 17
          Caption = 'Remove doubled Bricks'
          TabOrder = 2
        end
      end
      object GroupBox5: TGroupBox
        Left = 10
        Top = 176
        Width = 444
        Height = 69
        Caption = 'Stuff:'
        TabOrder = 1
        object cbBrkForceInv: TCheckBox
          Left = 16
          Top = 29
          Width = 289
          Height = 17
          Caption = 'Force the invisible Brick at specific position (LBA 2 only):'
          Enabled = False
          TabOrder = 0
        end
        object eBrkForceInv: TEdit
          Left = 304
          Top = 27
          Width = 57
          Height = 21
          Enabled = False
          TabOrder = 1
          Text = '0'
        end
      end
    end
    object tsOutFiles: TTabSheet
      Caption = 'Output files'
      ImageIndex = 2
      object Label8: TLabel
        Left = 16
        Top = 16
        Width = 103
        Height = 13
        Caption = 'Create output files for:'
      end
      object cbOutputSce: TCheckBox
        Left = 16
        Top = 288
        Width = 201
        Height = 17
        Caption = 'Create Scene file (scene.hqr):'
        TabOrder = 0
        OnClick = cbOutputGriClick
      end
      object rbOutputType1: TRadioButton
        Left = 128
        Top = 16
        Width = 57
        Height = 17
        Caption = 'LBA 1'
        Checked = True
        TabOrder = 1
        TabStop = True
      end
      object rbOutputType2: TRadioButton
        Left = 128
        Top = 32
        Width = 57
        Height = 17
        Caption = 'LBA 2'
        Enabled = False
        TabOrder = 3
      end
      object pcOutFiles: TPageControl
        Left = 5
        Top = 55
        Width = 457
        Height = 209
        ActivePage = tsOutLBA1
        Style = tsButtons
        TabOrder = 2
        object tsOutLBA1: TTabSheet
          Caption = 'tsOutLBA1'
          TabVisible = False
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object gbOutLba1: TGroupBox
            Left = 0
            Top = 3
            Width = 449
            Height = 193
            Caption = 'LBA 1:'
            TabOrder = 0
            object lbBllCap: TLabel
              Left = 8
              Top = 106
              Width = 51
              Height = 13
              Caption = 'lba_bll.hqr:'
            end
            object lbBrkCap: TLabel
              Left = 8
              Top = 146
              Width = 56
              Height = 13
              Caption = 'lba_brk.hqr:'
            end
            object cbOutputGri: TCheckBox
              Left = 8
              Top = 24
              Width = 185
              Height = 17
              Caption = 'Create Grid file (lba_gri.hqr):'
              TabOrder = 0
              OnClick = cbOutputGriClick
            end
            object cbOutputBllBrk: TCheckBox
              Left = 8
              Top = 86
              Width = 193
              Height = 17
              Caption = 'Create Library and Bricks files:'
              TabOrder = 1
              OnClick = cbOutputGriClick
            end
            object cbHqdGri: TCheckBox
              Left = 376
              Top = 24
              Width = 57
              Height = 17
              Caption = '+ HQD'
              TabOrder = 2
            end
            object cbHqdBll: TCheckBox
              Left = 376
              Top = 86
              Width = 57
              Height = 17
              Caption = '+ HQD'
              TabOrder = 3
            end
          end
        end
        object tsOutLBA2: TTabSheet
          Caption = 'tsOutLBA2'
          ImageIndex = 1
          TabVisible = False
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object gbOutLba2: TGroupBox
            Left = 0
            Top = 4
            Width = 449
            Height = 89
            Caption = 'LBA 2:'
            TabOrder = 0
            object cbOutputBkg: TCheckBox
              Left = 8
              Top = 24
              Width = 233
              Height = 17
              Caption = 'Create Background file (lba_bkg.hqr):'
              TabOrder = 0
              OnClick = cbOutputGriClick
            end
            object cbHqdBkg: TCheckBox
              Left = 376
              Top = 24
              Width = 57
              Height = 17
              Caption = '+ HQD'
              TabOrder = 1
            end
          end
        end
      end
      object cbHqdSce: TCheckBox
        Left = 385
        Top = 288
        Width = 57
        Height = 17
        Caption = '+ HQD'
        TabOrder = 4
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Project description'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label9: TLabel
        Left = 16
        Top = 8
        Width = 434
        Height = 13
        Caption = 
          'You can add custom notes here. This text will be saved in projec' +
          't file only, not in output files.'
      end
      object meDescription: TMemo
        Left = 8
        Top = 32
        Width = 449
        Height = 353
        TabOrder = 0
      end
    end
  end
  object btOK: TBitBtn
    Left = 144
    Top = 423
    Width = 91
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
    Left = 256
    Top = 423
    Width = 89
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
end
