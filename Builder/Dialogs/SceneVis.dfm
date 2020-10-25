object fmSceneVis: TfmSceneVis
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Visible elements'
  ClientHeight = 298
  ClientWidth = 347
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PrintScale = poNone
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object btOK: TBitBtn
    Left = 54
    Top = 264
    Width = 113
    Height = 25
    TabOrder = 0
    Kind = bkOK
  end
  object btCancel: TBitBtn
    Left = 182
    Top = 264
    Width = 113
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object cbActorsSpri: TCheckBox
    Left = 32
    Top = 13
    Width = 97
    Height = 17
    Caption = 'Sprite Actors'
    TabOrder = 2
  end
  object cbPoints: TCheckBox
    Left = 32
    Top = 133
    Width = 97
    Height = 17
    Caption = 'Points'
    TabOrder = 3
  end
  object cbZCube: TCheckBox
    Left = 208
    Top = 13
    Width = 97
    Height = 17
    Caption = 'Cube Zones'
    TabOrder = 4
  end
  object cbZCamera: TCheckBox
    Left = 208
    Top = 33
    Width = 97
    Height = 17
    Caption = 'Camera Zones'
    TabOrder = 5
  end
  object cbZSceneric: TCheckBox
    Left = 208
    Top = 53
    Width = 97
    Height = 17
    Caption = 'Sceneric Zones'
    TabOrder = 6
  end
  object cbZFragment: TCheckBox
    Left = 208
    Top = 73
    Width = 97
    Height = 17
    Caption = 'Fragment Zones'
    TabOrder = 7
  end
  object cbZBonus: TCheckBox
    Left = 208
    Top = 93
    Width = 97
    Height = 17
    Caption = 'Bonus Zones'
    TabOrder = 8
  end
  object cbZLadder: TCheckBox
    Left = 208
    Top = 113
    Width = 97
    Height = 17
    Caption = 'Ladder Zones'
    TabOrder = 9
  end
  object cbZText: TCheckBox
    Left = 208
    Top = 133
    Width = 97
    Height = 17
    Caption = 'Text Zones'
    TabOrder = 10
  end
  object cbZSpike: TCheckBox
    Left = 208
    Top = 173
    Width = 97
    Height = 17
    Caption = 'Spike Zones'
    TabOrder = 11
  end
  object cbClipping: TCheckBox
    Left = 32
    Top = 53
    Width = 113
    Height = 17
    Caption = 'Actor clipping rects'
    TabOrder = 12
  end
  object btAll: TBitBtn
    Left = 192
    Top = 216
    Width = 65
    Height = 25
    Caption = 'Select all'
    TabOrder = 13
    OnClick = btAllClick
  end
  object btNone: TBitBtn
    Left = 263
    Top = 216
    Width = 65
    Height = 25
    Caption = 'Select none'
    TabOrder = 14
    OnClick = btAllClick
  end
  object cbZConveyor: TCheckBox
    Left = 208
    Top = 153
    Width = 97
    Height = 17
    Caption = 'Conveyor zones'
    TabOrder = 15
  end
  object cbZRail: TCheckBox
    Left = 208
    Top = 193
    Width = 97
    Height = 17
    Caption = 'Rail Zones'
    TabOrder = 16
  end
  object cbActors3D: TCheckBox
    Left = 32
    Top = 33
    Width = 97
    Height = 17
    Caption = '3D Actors'
    TabOrder = 17
  end
end
