object fmSearchScript: TfmSearchScript
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Search the Scripts'
  ClientHeight = 153
  ClientWidth = 241
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PrintScale = poNone
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 60
    Height = 13
    Caption = 'Text to find:'
  end
  object edText: TEdit
    Left = 8
    Top = 24
    Width = 225
    Height = 21
    TabOrder = 0
    OnChange = edTextChange
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 51
    Width = 225
    Height = 62
    Caption = 'Search in'
    TabOrder = 1
    object cbTrack: TCheckBox
      Left = 16
      Top = 34
      Width = 97
      Height = 17
      Caption = 'Track Script'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = edTextChange
    end
    object cbLife: TCheckBox
      Left = 16
      Top = 18
      Width = 97
      Height = 17
      Caption = 'Life Script'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = edTextChange
    end
    object rbCurrent: TRadioButton
      Left = 119
      Top = 18
      Width = 90
      Height = 17
      Caption = 'Current Actor'
      TabOrder = 2
      OnClick = edTextChange
    end
    object rbAll: TRadioButton
      Left = 119
      Top = 34
      Width = 66
      Height = 17
      Caption = 'All Actors'
      Checked = True
      TabOrder = 3
      TabStop = True
      OnClick = edTextChange
    end
  end
  object btFind: TBitBtn
    Left = 8
    Top = 119
    Width = 89
    Height = 25
    Caption = 'Find'
    Default = True
    TabOrder = 2
    OnClick = btFindClick
    NumGlyphs = 2
  end
  object btClose: TBitBtn
    Left = 144
    Top = 120
    Width = 89
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 3
    OnClick = btCloseClick
    NumGlyphs = 2
  end
end
