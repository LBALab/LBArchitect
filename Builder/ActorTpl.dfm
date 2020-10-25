object fmActorTpl: TfmActorTpl
  Left = 237
  Top = 111
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = 'Create Actor'
  ClientHeight = 335
  ClientWidth = 378
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PrintScale = poNone
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object pcDialogType: TPageControl
    Left = 0
    Top = 0
    Width = 377
    Height = 331
    ActivePage = tsManageTemps
    Style = tsButtons
    TabOrder = 1
    object tsUseTemp: TTabSheet
      Caption = 'tsUseTemp'
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 5
        Top = 3
        Width = 361
        Height = 33
        Alignment = taCenter
        AutoSize = False
        Caption = 
          'Select a Template to create Actor from, or press Cancel to creat' +
          'e an empty Actor (most params set to zero, no scripts).'
        WordWrap = True
      end
      object btCreate: TBitBtn
        Left = 64
        Top = 296
        Width = 113
        Height = 25
        Caption = 'Create'
        TabOrder = 0
        OnClick = btCreateClick
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
        Left = 192
        Top = 296
        Width = 113
        Height = 25
        TabOrder = 1
        Kind = bkCancel
      end
    end
    object tsManageTemps: TTabSheet
      Caption = 'tsManageTemps'
      ImageIndex = 1
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object btClose: TBitBtn
        Left = 128
        Top = 296
        Width = 113
        Height = 25
        Caption = 'Close'
        ModalResult = 1
        TabOrder = 0
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
      object btNew: TBitBtn
        Left = 124
        Top = 5
        Width = 75
        Height = 25
        Caption = 'New'
        Enabled = False
        TabOrder = 1
        Visible = False
        OnClick = btCreateClick
      end
      object btEditName: TBitBtn
        Left = 4
        Top = 5
        Width = 99
        Height = 25
        Caption = 'Edit name && desc'
        TabOrder = 2
        OnClick = btCreateClick
      end
      object btDelete: TBitBtn
        Left = 290
        Top = 5
        Width = 75
        Height = 25
        Caption = 'Delete'
        TabOrder = 3
        OnClick = btCreateClick
      end
      object btEditCont: TBitBtn
        Left = 160
        Top = 5
        Width = 75
        Height = 25
        Caption = 'Edit content'
        TabOrder = 4
        OnClick = btCreateClick
      end
    end
  end
  object lvTemplates: TListView
    Left = 8
    Top = 48
    Width = 361
    Height = 246
    Columns = <
      item
        Caption = 'Name'
        Width = 100
      end
      item
        Caption = 'Description'
        Width = 240
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
    OnClick = lvTemplatesClick
    OnDblClick = btCreateClick
  end
end
