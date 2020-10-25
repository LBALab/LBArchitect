object fmSelect: TfmSelect
  Left = 374
  Top = 203
  BorderStyle = bsDialog
  Caption = 'Manual selection'
  ClientHeight = 168
  ClientWidth = 352
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object pgEditor: TPageControl
    Left = 8
    Top = 8
    Width = 337
    Height = 121
    ActivePage = TabSheet1
    TabOrder = 0
    OnChange = pgEditorChange
    object TabSheet1: TTabSheet
      Caption = 'Single-field editor'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 16
        Top = 8
        Width = 89
        Height = 13
        Caption = 'Accepted formats: '
      end
      object Label2: TLabel
        Left = 112
        Top = 8
        Width = 111
        Height = 13
        Caption = '[x1, y1, z1] - [x2, y2, z2]'
      end
      object Label3: TLabel
        Left = 112
        Top = 24
        Width = 93
        Height = 13
        Caption = '[x1-x2, y1-y2, z1-z2]'
      end
      object Label4: TLabel
        Left = 44
        Top = 43
        Width = 241
        Height = 15
        Alignment = taCenter
        AutoSize = False
        Caption = 'Braces and spaces are ignored'
      end
      object eSelection: TEdit
        Left = 8
        Top = 64
        Width = 313
        Height = 21
        TabOrder = 0
      end
    end
    object tsMultiEdit: TTabSheet
      Caption = 'Multi-field editor'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object X: TLabel
        Left = 78
        Top = 12
        Width = 14
        Height = 13
        Caption = 'x1:'
      end
      object Label5: TLabel
        Left = 78
        Top = 36
        Width = 14
        Height = 13
        Caption = 'y1:'
      end
      object Label6: TLabel
        Left = 78
        Top = 60
        Width = 14
        Height = 13
        Caption = 'z1:'
      end
      object Label7: TLabel
        Left = 174
        Top = 12
        Width = 14
        Height = 13
        Caption = 'x2:'
      end
      object Label8: TLabel
        Left = 174
        Top = 36
        Width = 14
        Height = 13
        Caption = 'y2:'
      end
      object Label9: TLabel
        Left = 174
        Top = 60
        Width = 14
        Height = 13
        Caption = 'z2:'
      end
      object eX1: TEdit
        Left = 96
        Top = 8
        Width = 49
        Height = 21
        TabOrder = 0
      end
      object eY1: TEdit
        Left = 96
        Top = 32
        Width = 49
        Height = 21
        TabOrder = 1
      end
      object eZ1: TEdit
        Left = 96
        Top = 56
        Width = 49
        Height = 21
        TabOrder = 2
      end
      object eX2: TEdit
        Left = 192
        Top = 8
        Width = 49
        Height = 21
        TabOrder = 3
      end
      object eY2: TEdit
        Left = 192
        Top = 32
        Width = 49
        Height = 21
        TabOrder = 4
      end
      object eZ2: TEdit
        Left = 192
        Top = 56
        Width = 49
        Height = 21
        TabOrder = 5
      end
    end
  end
  object btOK: TBitBtn
    Left = 56
    Top = 136
    Width = 113
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = btOKClick
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
    Left = 184
    Top = 136
    Width = 113
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object paScene: TPanel
    Left = 8
    Top = 8
    Width = 337
    Height = 121
    BevelOuter = bvNone
    TabOrder = 3
    object Label10: TLabel
      Left = 12
      Top = 64
      Width = 237
      Height = 13
      Caption = 'Choose an object from the list, or just type its ID in:'
    end
    object rgType: TRadioGroup
      Left = 12
      Top = 8
      Width = 313
      Height = 42
      Caption = 'Select'
      Columns = 4
      Items.Strings = (
        'Actor'
        'Zone'
        'Point'
        'Nothing')
      TabOrder = 0
      OnClick = rgTypeClick
    end
    object cbId: TComboBox
      Left = 12
      Top = 83
      Width = 313
      Height = 21
      DropDownCount = 20
      ItemHeight = 13
      TabOrder = 1
      Text = 'cbId'
    end
  end
end
