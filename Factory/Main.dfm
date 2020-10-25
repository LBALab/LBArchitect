object fmMain: TfmMain
  Left = 265
  Top = 112
  Caption = 'Little Big Factory - Brick and Library Editor'
  ClientHeight = 424
  ClientWidth = 553
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mmMain
  OldCreateOrder = False
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  DesignSize = (
    553
    424)
  PixelsPerInch = 96
  TextHeight = 13
  object paMain: TPanel
    Left = 0
    Top = 0
    Width = 553
    Height = 420
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
    Visible = False
    ExplicitHeight = 401
    DesignSize = (
      553
      420)
    object lbInfo: TLabel
      Left = 12
      Top = 40
      Width = 9
      Height = 13
      Caption = '...'
    end
    object lbTest: TLabel
      Left = 10
      Top = 144
      Width = 29
      Height = 13
      Caption = 'lbTest'
      ParentShowHint = False
      ShowHint = True
      Visible = False
    end
    object pcContent: TPageControl
      Left = 84
      Top = 0
      Width = 465
      Height = 420
      ActivePage = LibTab
      Anchors = [akLeft, akTop, akRight, akBottom]
      OwnerDraw = True
      TabOrder = 0
      OnChange = pcContentChange
      OnDrawTab = pcContentDrawTab
      ExplicitHeight = 401
      object BrkTab: TTabSheet
        Caption = 'Bricks'
        ExplicitHeight = 373
        DesignSize = (
          457
          392)
        object lbBrkCount: TLabel
          Left = 13
          Top = 5
          Width = 9
          Height = 13
          Caption = '...'
        end
        object Bevel2: TBevel
          Left = 8
          Top = 24
          Width = 441
          Height = 364
          Anchors = [akLeft, akTop, akRight, akBottom]
          ExplicitHeight = 305
        end
        object pbBrick: TPaintBox
          Left = 9
          Top = 25
          Width = 421
          Height = 362
          Anchors = [akLeft, akTop, akRight, akBottom]
          PopupMenu = pmBricks
          OnDblClick = mEditBrkClick
          OnMouseDown = pbBrickMouseDown
          OnPaint = pbBrickPaint
          ExplicitHeight = 303
        end
        object lbAllocCnt: TLabel
          Left = 128
          Top = 5
          Width = 9
          Height = 13
          Caption = '...'
        end
        object sbBricks: TScrollBar
          Left = 431
          Top = 26
          Width = 16
          Height = 360
          Anchors = [akTop, akRight, akBottom]
          Enabled = False
          Kind = sbVertical
          LargeChange = 10
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = sbBricksChange
          ExplicitHeight = 341
        end
        object paBadBricks: TPanel
          Left = 280
          Top = 0
          Width = 177
          Height = 21
          BevelOuter = bvNone
          TabOrder = 1
          Visible = False
          object Label4: TLabel
            Left = 8
            Top = 4
            Width = 81
            Height = 13
            Caption = 'Corrupted Bricks:'
          end
          object cbBadBricks: TComboBox
            Left = 96
            Top = 0
            Width = 73
            Height = 21
            Style = csDropDownList
            ItemHeight = 0
            TabOrder = 0
            OnChange = cbBadBricksChange
          end
        end
      end
      object LibTab: TTabSheet
        Caption = 'Layouts'
        ImageIndex = 1
        TabVisible = False
        ExplicitHeight = 373
        DesignSize = (
          457
          392)
        object lbLtCount: TLabel
          Left = 13
          Top = 5
          Width = 9
          Height = 13
          Caption = '...'
        end
        object Bevel1: TBevel
          Left = 8
          Top = 24
          Width = 441
          Height = 362
          Anchors = [akLeft, akTop, akRight, akBottom]
          ExplicitHeight = 303
        end
        object pbLayout: TPaintBox
          Left = 9
          Top = 25
          Width = 421
          Height = 360
          Anchors = [akLeft, akTop, akRight, akBottom]
          PopupMenu = pmLayouts
          OnDblClick = mLtEditStrClick
          OnMouseDown = pbLayoutMouseDown
          OnPaint = pbLayoutPaint
          ExplicitHeight = 301
        end
        object Label2: TLabel
          Left = 383
          Top = 5
          Width = 29
          Height = 13
          Caption = 'Go to:'
        end
        object btSortSize: TSpeedButton
          Left = 160
          Top = 0
          Width = 89
          Height = 22
          GroupIndex = 1
          Down = True
          Caption = 'Sort by size'
          Layout = blGlyphBottom
          OnClick = btSortSizeClick
        end
        object btSortIndex: TSpeedButton
          Left = 256
          Top = 0
          Width = 89
          Height = 22
          GroupIndex = 1
          Caption = 'Sort by index'
          Layout = blGlyphBottom
          OnClick = btSortSizeClick
        end
        object btTest: TButton
          Left = 344
          Top = 288
          Width = 75
          Height = 25
          Caption = 'Test'
          TabOrder = 0
          Visible = False
          OnClick = btTestClick
        end
        object sbLayouts: TScrollBar
          Left = 431
          Top = 26
          Width = 16
          Height = 358
          Anchors = [akTop, akRight, akBottom]
          Kind = sbVertical
          Max = 10000
          PageSize = 0
          SmallChange = 20
          TabOrder = 1
          OnChange = sbLayoutsChange
          ExplicitHeight = 339
        end
        object edGoTo: TEdit
          Left = 416
          Top = 2
          Width = 33
          Height = 19
          AutoSize = False
          TabOrder = 2
          OnKeyPress = edGoToKeyPress
        end
      end
    end
  end
  object paSplash: TPanel
    Left = 48
    Top = 32
    Width = 449
    Height = 289
    BevelInner = bvLowered
    BorderStyle = bsSingle
    TabOrder = 1
    object Shape1: TShape
      Left = 54
      Top = 46
      Width = 337
      Height = 137
      Brush.Color = 8110066
      Pen.Width = 2
      Shape = stRoundRect
    end
    object Label7: TLabel
      Left = 70
      Top = 66
      Width = 305
      Height = 39
      Alignment = taCenter
      AutoSize = False
      Caption = 'Little Big Factory'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -33
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label8: TLabel
      Left = 70
      Top = 110
      Width = 305
      Height = 19
      Alignment = taCenter
      AutoSize = False
      Caption = 'part of Little Big Architect'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label9: TLabel
      Left = 70
      Top = 150
      Width = 305
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'by Zink'
      Transparent = True
    end
    object lbVersion: TLabel
      Left = 70
      Top = 134
      Width = 305
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Version: 0.10'
      Transparent = True
    end
    object Label11: TLabel
      Left = 54
      Top = 198
      Width = 337
      Height = 41
      Alignment = taCenter
      AutoSize = False
      Caption = 
        'Little Big Factory comes with ABSOLUTELY NO WARRANTY; for detail' +
        's see License.txt. This is free software, and you are welcome to' +
        ' redistribute it under certain conditions; see License.txt for d' +
        'etails.'
      WordWrap = True
    end
  end
  object DlgOpen: TOpenDialog
    Left = 8
    Top = 264
  end
  object DlgSave: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 40
    Top = 264
  end
  object pmBricks: TPopupMenu
    OnPopup = pmBricksPopup
    Left = 8
    Top = 296
    object mEditBrk: TMenuItem
      Caption = 'Edit...'
      Default = True
      OnClick = mEditBrkClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mExportBrk: TMenuItem
      Caption = 'Export to Brick file...'
      OnClick = mExportBrkClick
    end
    object mExportBrkBit: TMenuItem
      Caption = 'Export to bitmap...'
      OnClick = mExportBrkBitClick
    end
    object N12: TMenuItem
      Caption = '-'
      Visible = False
    end
    object mImportBrk: TMenuItem
      Caption = 'Import from brick file...'
      Visible = False
      OnClick = mImportBrkClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mBrkInsBefore: TMenuItem
      Caption = 'Insert before'
      Enabled = False
      OnClick = mBrkInsBeforeClick
    end
    object mBrkInsAfter: TMenuItem
      Caption = 'Insert after'
      Enabled = False
      OnClick = mBrkInsBeforeClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object mBrkMoveForw: TMenuItem
      Caption = 'Move forward'
      Enabled = False
      OnClick = mBrkMoveForwClick
    end
    object mBrkMoveBack: TMenuItem
      Caption = 'Move backward'
      Enabled = False
      OnClick = mBrkMoveForwClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object mBrkDelete: TMenuItem
      Caption = 'Delete'
      Enabled = False
      OnClick = mBrkDeleteClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object mLockBrick: TMenuItem
      AutoCheck = True
      Caption = 'Lock HQR structure'
      Checked = True
      OnClick = mLockBrickClick
    end
  end
  object pmLayouts: TPopupMenu
    OnPopup = pmLayoutsPopup
    Left = 40
    Top = 296
    object mLtEditStr: TMenuItem
      Caption = 'Edit layout structure...'
      Default = True
      OnClick = mLtEditStrClick
    end
    object mLtEditImg: TMenuItem
      Caption = 'Edit layout image...'
      Enabled = False
      OnClick = mLtEditImgClick
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object mExportLay: TMenuItem
      Caption = 'Export to Layout file...'
      OnClick = mExportLayClick
    end
    object mExportLayBit: TMenuItem
      Caption = 'Export to bitmap...'
      OnClick = mExportLayBitClick
    end
    object N19: TMenuItem
      Caption = '-'
    end
    object mLayImpHqsRep: TMenuItem
      Caption = 'Import from a Scenario and replace...'
      OnClick = mLayImpHqsRepClick
    end
    object mLayImpHqsNew: TMenuItem
      Caption = 'Import from a Scenario as new...'
      OnClick = mLayImpHqsNewClick
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object mNewLt: TMenuItem
      Caption = 'New Layout'
      OnClick = mNewLtClick
    end
    object mCopyLt: TMenuItem
      Caption = 'Copy this Layout'
      OnClick = mCopyLtClick
    end
    object mRemSharing: TMenuItem
      Caption = 'Remove Brick sharing'
      OnClick = mRemSharingClick
    end
    object mDeleteLt: TMenuItem
      Caption = 'Delete this Layout'
      Enabled = False
      OnClick = mDeleteLtClick
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object mLockLib: TMenuItem
      AutoCheck = True
      Caption = 'Lock dangerous features'
      Checked = True
      OnClick = mLockLibClick
    end
  end
  object mmMain: TMainMenu
    Left = 8
    Top = 328
    object mFile: TMenuItem
      Caption = 'File'
      OnClick = mFileClick
      object NewBrick1: TMenuItem
        Caption = 'New'
        object mNewBrk: TMenuItem
          Caption = 'Brick'
          OnClick = mNewClick
        end
        object mNewBrkHqr: TMenuItem
          Caption = 'Brick HQR (lba_brk.hqr for LBA1)'
          OnClick = mNewClick
        end
        object N15: TMenuItem
          Caption = '-'
        end
        object mNewLt1: TMenuItem
          Caption = 'LBA 1 Layout'
          OnClick = mNewClick
        end
        object mNewLt2: TMenuItem
          Caption = 'LBA 2 Layout'
          OnClick = mNewClick
        end
        object mNewLib1: TMenuItem
          Caption = 'LBA 1 Library'
          OnClick = mNewClick
        end
        object mNewLib2: TMenuItem
          Caption = 'LBA 2 Library'
          OnClick = mNewClick
        end
        object N16: TMenuItem
          Caption = '-'
        end
        object mNewBkg: TMenuItem
          Caption = 'Background HQR (lba_bkg.hqr for LBA2)'
          Visible = False
          OnClick = mNewClick
        end
      end
      object N14: TMenuItem
        Caption = '-'
      end
      object mOpenBrk: TMenuItem
        Caption = 'Open Brick(s)...'
        OnClick = mOpenBrkClick
      end
      object mSaveBrk: TMenuItem
        Caption = 'Save Bricks'
        Enabled = False
        OnClick = mSaveBrkClick
      end
      object mSaveBrkAs: TMenuItem
        Caption = 'Save Bricks as...'
        Enabled = False
        OnClick = mSaveBrkClick
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object mOpenLib: TMenuItem
        Caption = 'Open Layout or Library...'
        OnClick = mOpenLibClick
      end
      object mChooseEntry: TMenuItem
        Caption = 'Choose another HQR entry...'
        Enabled = False
        OnClick = mChooseEntryClick
      end
      object mSaveLib: TMenuItem
        Caption = 'Save Library'
        Enabled = False
        OnClick = mSaveLibClick
      end
      object mSaveLibAs: TMenuItem
        Caption = 'Save Library as... (single only)'
        Enabled = False
        OnClick = mSaveLibClick
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object mOpenScen: TMenuItem
        Caption = 'Open Scenario'
        OnClick = mOpenScenClick
      end
      object mExportScen: TMenuItem
        Caption = 'Export to a Scenario...'
        Enabled = False
        OnClick = mExportScenClick
      end
      object N18: TMenuItem
        Caption = '-'
      end
      object mSaveBoth: TMenuItem
        Caption = 'Save both (BKG)'
        Enabled = False
        OnClick = mSaveBothClick
      end
      object mSaveBothAs: TMenuItem
        Caption = 'Save both as...'
        Enabled = False
        OnClick = mSaveBothAsClick
      end
      object N13: TMenuItem
        Caption = '-'
      end
      object mExit: TMenuItem
        Caption = 'Exit'
        OnClick = mExitClick
      end
    end
    object View1: TMenuItem
      Caption = 'View'
      object mFrames: TMenuItem
        AutoCheck = True
        Caption = 'Frames'
        OnClick = mFramesClick
      end
      object mIndexes: TMenuItem
        AutoCheck = True
        Caption = 'Indexes'
        OnClick = mFramesClick
      end
      object mShapes: TMenuItem
        AutoCheck = True
        Caption = 'Shapes (Layouts only)'
        OnClick = mFramesClick
      end
      object N17: TMenuItem
        Caption = '-'
      end
      object mScenProp: TMenuItem
        Caption = 'Scenario properties...'
        Enabled = False
        OnClick = mScenPropClick
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object mStartWith1: TMenuItem
        AutoCheck = True
        Caption = 'HQR files'#39' indexes start with 1'
        OnClick = mStartWith1Click
      end
    end
    object Palette1: TMenuItem
      Caption = 'Palette'
      object mLba1: TMenuItem
        AutoCheck = True
        Caption = 'LBA 1'
        Checked = True
        GroupIndex = 1
        RadioItem = True
        OnClick = mLba1Click
      end
      object mLba2: TMenuItem
        AutoCheck = True
        Caption = 'LBA 2'
        GroupIndex = 1
        RadioItem = True
        OnClick = mLba1Click
      end
      object N9: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object mAutoPal: TMenuItem
        AutoCheck = True
        Caption = 'Auto palette'
        Checked = True
        GroupIndex = 2
      end
    end
  end
end
