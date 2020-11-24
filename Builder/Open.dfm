object fmOpen: TfmOpen
  Left = 238
  Top = 111
  BorderStyle = bsDialog
  Caption = 'Open or create a new room'
  ClientHeight = 470
  ClientWidth = 449
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
  PixelsPerInch = 96
  TextHeight = 13
  object lbInfo: TLabel
    Left = 239
    Top = 4
    Width = 208
    Height = 24
    AutoSize = False
    Caption = 
      'If path to an LBA directory is not specified, '#39'Original'#39' option ' +
      'will be disabled for some groups.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 8
    Top = 9
    Width = 83
    Height = 13
    Caption = 'Stage version:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object gbBricks: TGroupBox
    Left = 8
    Top = 29
    Width = 433
    Height = 65
    Caption = 'Bricks:'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    object rbBrkOrigin: TRadioButton
      Left = 15
      Top = 16
      Width = 67
      Height = 17
      Caption = 'Original'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = True
      OnClick = rbBrkOriginClick
    end
    object rbBrkCustom: TRadioButton
      Left = 88
      Top = 16
      Width = 57
      Height = 17
      Caption = 'Custom'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = rbBrkOriginClick
    end
    object btBrkPath: TButton
      Left = 401
      Top = 38
      Width = 17
      Height = 17
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btBrkPathClick
    end
    object stBrkPath: TStaticText
      Left = 16
      Top = 38
      Width = 385
      Height = 17
      AutoSize = False
      BevelInner = bvSpace
      BevelKind = bkSoft
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
  end
  object gbLib: TGroupBox
    Left = 8
    Top = 101
    Width = 433
    Height = 65
    Caption = 'Library:'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    object btLibPath: TButton
      Left = 401
      Top = 38
      Width = 17
      Height = 17
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btLibPathClick
    end
    object stLibPath: TStaticText
      Left = 16
      Top = 38
      Width = 385
      Height = 17
      AutoSize = False
      BevelInner = bvSpace
      BevelKind = bkSoft
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object rbLibOrigin: TRadioButton
      Left = 15
      Top = 16
      Width = 67
      Height = 17
      Caption = 'Original'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = True
      OnClick = rbLibOriginClick
    end
    object rbLibCustom: TRadioButton
      Left = 88
      Top = 16
      Width = 57
      Height = 17
      Caption = 'Custom'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = rbLibOriginClick
    end
  end
  object gbPalette: TGroupBox
    Left = 8
    Top = 316
    Width = 433
    Height = 65
    Caption = 'Palette:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clPurple
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object rbPalOrigin: TRadioButton
      Left = 16
      Top = 16
      Width = 66
      Height = 17
      Caption = 'Original'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = True
      OnClick = rbBrkOriginClick
    end
    object rbPalCustom: TRadioButton
      Left = 88
      Top = 16
      Width = 57
      Height = 17
      Caption = 'Custom'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = rbBrkOriginClick
    end
    object btPalPath: TButton
      Left = 401
      Top = 37
      Width = 17
      Height = 17
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btPalPathClick
    end
    object stPalPath: TStaticText
      Left = 16
      Top = 37
      Width = 385
      Height = 17
      AutoSize = False
      BevelInner = bvSpace
      BevelKind = bkSoft
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
  end
  object btOpen: TBitBtn
    Left = 104
    Top = 437
    Width = 113
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 3
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
    Left = 232
    Top = 437
    Width = 113
    Height = 25
    TabOrder = 4
    Kind = bkCancel
  end
  object gbScene: TGroupBox
    Left = 8
    Top = 244
    Width = 433
    Height = 65
    Caption = 'Scene:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    object rbScnOrigin: TRadioButton
      Left = 15
      Top = 16
      Width = 67
      Height = 17
      Caption = 'Original'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = True
      OnClick = rbScnOriginClick
    end
    object rbScnCustom: TRadioButton
      Left = 88
      Top = 15
      Width = 57
      Height = 17
      Caption = 'Custom'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = rbScnOriginClick
    end
    object btScnPath: TButton
      Left = 401
      Top = 38
      Width = 17
      Height = 17
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btScnPathClick
    end
    object stScnPath: TStaticText
      Left = 16
      Top = 38
      Width = 385
      Height = 17
      AutoSize = False
      BevelInner = bvSpace
      BevelKind = bkSoft
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object rbScnNew: TRadioButton
      Left = 165
      Top = 15
      Width = 234
      Height = 17
      Caption = 'None or New (empty Scene will be created)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = rbScnOriginClick
    end
  end
  object gbGrid: TGroupBox
    Left = 8
    Top = 172
    Width = 433
    Height = 65
    Caption = 'Grid:'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 6
    object rbGriOrigin: TRadioButton
      Left = 15
      Top = 16
      Width = 67
      Height = 17
      Caption = 'Original'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = True
      OnClick = rbGriOriginClick
    end
    object rbGriCustom: TRadioButton
      Left = 88
      Top = 16
      Width = 57
      Height = 17
      Caption = 'Custom'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = rbGriOriginClick
    end
    object cbAutoLib: TCheckBox
      Left = 276
      Top = 15
      Width = 145
      Height = 17
      Caption = 'Automatic library selection'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 2
      OnClick = cbAutoLibClick
    end
    object rbGriNew: TRadioButton
      Left = 165
      Top = 16
      Width = 49
      Height = 17
      Caption = 'New'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = rbGriOriginClick
    end
    object pcGridOpenNew: TPageControl
      Left = 8
      Top = 31
      Width = 417
      Height = 31
      ActivePage = tsGridOpen
      Style = tsButtons
      TabOrder = 4
      object tsGridNew: TTabSheet
        Caption = 'tsGridNew'
        TabVisible = False
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label3: TLabel
          Left = 102
          Top = 4
          Width = 141
          Height = 13
          Caption = 'Library index (starts with zero):'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label4: TLabel
          Left = 288
          Top = 4
          Width = 75
          Height = 13
          Caption = 'Fragment index:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label1: TLabel
          Left = 8
          Top = 4
          Width = 84
          Height = 13
          Caption = 'LBA 2 options:'
        end
        object eLibIndex: TEdit
          Left = 248
          Top = 0
          Width = 27
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 3
          ParentFont = False
          TabOrder = 0
          Text = '0'
          OnChange = eLibIndexChange
        end
        object eFragIndex: TEdit
          Left = 367
          Top = 0
          Width = 27
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 3
          ParentFont = False
          TabOrder = 1
          Text = '0'
          OnChange = eLibIndexChange
        end
      end
      object tsGridOpen: TTabSheet
        Caption = 'tsGridOpen'
        ImageIndex = 1
        TabVisible = False
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object btGriPath: TButton
          Left = 389
          Top = 2
          Width = 17
          Height = 17
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = btGriPathClick
        end
        object stGriPath: TStaticText
          Left = 4
          Top = 2
          Width = 385
          Height = 17
          AutoSize = False
          BevelInner = bvSpace
          BevelKind = bkSoft
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
      end
    end
  end
  object paMode: TPanel
    Left = 96
    Top = 389
    Width = 257
    Height = 41
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Color = clSkyBlue
    TabOrder = 7
    object rbGridMode: TRadioButton
      Left = 21
      Top = 4
      Width = 201
      Height = 17
      Caption = 'Open in Grid Mode (for Grid editing)'
      TabOrder = 0
    end
    object rbSceneMode: TRadioButton
      Left = 21
      Top = 20
      Width = 217
      Height = 17
      Caption = 'Open in Scene Mode (for Scene editing)'
      TabOrder = 1
    end
  end
  object rbLba1: TRadioButton
    Left = 101
    Top = 8
    Width = 54
    Height = 17
    Caption = 'LBA 1'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    TabStop = True
    OnClick = rbLba1Click
  end
  object rbLba2: TRadioButton
    Left = 168
    Top = 8
    Width = 54
    Height = 17
    Caption = 'LBA 2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    OnClick = rbLba1Click
  end
  object DlgOpen: TOpenDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 416
    Top = 26
  end
end
