object TableForm: TTableForm
  Left = 692
  Top = 112
  AutoSize = True
  BorderStyle = bsNone
  Caption = 'TableForm'
  ClientHeight = 319
  ClientWidth = 436
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormResize
  OnDeactivate = FormDeactivate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 436
    Height = 319
    TabOrder = 0
    DesignSize = (
      436
      319)
    object Bevel1: TBevel
      Left = 3
      Top = 25
      Width = 430
      Height = 291
      Anchors = [akLeft, akTop, akRight, akBottom]
    end
    object pbBrick: TPaintBox
      Left = 4
      Top = 26
      Width = 410
      Height = 289
      Anchors = [akLeft, akTop, akRight, akBottom]
      OnClick = pbBrickClick
      OnMouseDown = pbBrickMouseDown
      OnPaint = pbBrickPaint
    end
    object Label1: TLabel
      Left = 238
      Top = 5
      Width = 113
      Height = 15
      Caption = 'Custom (0 ~ 65535):'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object sbBricks: TScrollBar
      Left = 415
      Top = 27
      Width = 16
      Height = 286
      Anchors = [akTop, akRight, akBottom]
      Kind = sbVertical
      LargeChange = 7
      PageSize = 0
      TabOrder = 0
      OnChange = sbBricksChange
    end
    object btNone: TBitBtn
      Left = 3
      Top = 3
      Width = 62
      Height = 20
      Hint = 
        'No Brick will be assigned to this block, so it won'#39't be able to ' +
        'contain an image.'
      Caption = 'None (0)'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btNoneClick
      Layout = blGlyphBottom
    end
    object btTemp: TBitBtn
      Left = 81
      Top = 3
      Width = 145
      Height = 20
      Hint = 
        'A new empty Brick will be created for this block (on exit from t' +
        'he editor).'
      Caption = 'Temporary empty (65535)'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btNoneClick
      Layout = blGlyphBottom
    end
    object eIndex: TEdit
      Left = 357
      Top = 3
      Width = 45
      Height = 20
      AutoSize = False
      TabOrder = 3
      OnKeyPress = eIndexKeyPress
    end
    object btClose: TBitBtn
      Left = 413
      Top = 3
      Width = 20
      Height = 20
      Hint = 'Cancel'
      Caption = 'r'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Marlett'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = FormDeactivate
    end
  end
end
