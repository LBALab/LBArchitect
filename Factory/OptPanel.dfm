object OptForm: TOptForm
  Left = 932
  Top = 110
  AutoSize = True
  BorderStyle = bsNone
  Caption = 'gfhds'
  ClientHeight = 124
  ClientWidth = 106
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object paOpt: TPanel
    Left = 0
    Top = 0
    Width = 106
    Height = 124
    TabOrder = 0
    DesignSize = (
      106
      124)
    object pcOpts: TPageControl
      Left = 1
      Top = 1
      Width = 104
      Height = 122
      ActivePage = optOptions
      Anchors = [akLeft, akTop, akRight, akBottom]
      Style = tsButtons
      TabOrder = 0
      object optZoom: TTabSheet
        Caption = 'optZoom'
        TabVisible = False
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label2: TLabel
          Left = 25
          Top = 0
          Width = 48
          Height = 16
          Caption = 'ZOOM:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lbZoom: TListBox
          Left = 11
          Top = 30
          Width = 74
          Height = 69
          Color = clBtnFace
          Columns = 2
          Ctl3D = True
          ExtendedSelect = False
          ItemHeight = 13
          Items.Strings = (
            '   X 1'
            '   X 2'
            '   X 3'
            '   X 4'
            '   X 5'
            '   X 6'
            '   X 7'
            '   X 8'
            '   X 9'
            '  X 10')
          ParentCtl3D = False
          TabOrder = 0
          OnClick = lbZoomClick
        end
      end
      object optDisplay: TTabSheet
        Caption = 'optDisplay'
        ImageIndex = 1
        TabVisible = False
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label1: TLabel
          Left = 16
          Top = 0
          Width = 68
          Height = 16
          Caption = 'DISPLAY:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object cbFrontF: TCheckBox
          Left = 0
          Top = 48
          Width = 81
          Height = 17
          Caption = 'Front frame'
          TabOrder = 0
          OnClick = cbGridClick
        end
        object cbGrid: TCheckBox
          Left = 8
          Top = 24
          Width = 81
          Height = 17
          Caption = 'grid (Ctrl+G)'
          TabOrder = 1
          OnClick = cbGridClick
        end
        object cbBackF: TCheckBox
          Left = 0
          Top = 64
          Width = 81
          Height = 17
          Caption = 'Back frame'
          Checked = True
          State = cbChecked
          TabOrder = 2
          OnClick = cbGridClick
        end
        object cbCoverBack: TCheckBox
          Left = 0
          Top = 96
          Width = 97
          Height = 17
          Caption = 'Brick covers b.f. '
          TabOrder = 3
          OnClick = cbGridClick
        end
        object cbAddF: TCheckBox
          Left = 0
          Top = 80
          Width = 81
          Height = 17
          Caption = 'Add. frames'
          TabOrder = 4
          OnClick = cbGridClick
        end
      end
      object optOptions: TTabSheet
        ImageIndex = 2
        TabVisible = False
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label3: TLabel
          Left = 12
          Top = 0
          Width = 72
          Height = 16
          Caption = 'OPTIONS:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label4: TLabel
          Left = 3
          Top = 24
          Width = 88
          Height = 13
          Caption = 'Front frame colour:'
        end
        object Label5: TLabel
          Left = 2
          Top = 64
          Width = 89
          Height = 13
          Caption = 'Back frame colour:'
        end
      end
      object optStructOpts: TTabSheet
        ImageIndex = 3
        TabVisible = False
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label7: TLabel
          Left = 8
          Top = 71
          Width = 79
          Height = 13
          Caption = 'Selection colour:'
        end
        object cbShowImg: TCheckBox
          Left = 2
          Top = 16
          Width = 90
          Height = 17
          Caption = 'Show image'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = cbFramesClick
        end
        object cbIndexes: TCheckBox
          Left = 2
          Top = 32
          Width = 90
          Height = 17
          Caption = 'Show indexes'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = cbFramesClick
        end
        object cbShape: TCheckBox
          Left = 2
          Top = 48
          Width = 90
          Height = 17
          Caption = 'Show shape'
          TabOrder = 2
          OnClick = cbFramesClick
        end
        object cbFrames: TCheckBox
          Left = 2
          Top = 0
          Width = 87
          Height = 17
          Caption = 'Show frames'
          Checked = True
          State = cbChecked
          TabOrder = 3
          OnClick = cbFramesClick
        end
      end
    end
  end
end
