object fmDebugLog: TfmDebugLog
  Left = 0
  Top = 0
  Caption = 'Debug Messages'
  ClientHeight = 348
  ClientWidth = 558
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PrintScale = poNone
  Scaled = False
  DesignSize = (
    558
    348)
  PixelsPerInch = 96
  TextHeight = 13
  object reText: TRichEdit
    Left = 8
    Top = 8
    Width = 542
    Height = 301
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    PlainText = True
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object btClose: TBitBtn
    Left = 475
    Top = 315
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 1
    OnClick = btCloseClick
  end
  object btClear: TBitBtn
    Left = 8
    Top = 315
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Clear'
    TabOrder = 2
    OnClick = btClearClick
  end
end
