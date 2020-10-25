object Form1: TForm1
  Left = 168
  Top = 110
  Width = 806
  Height = 640
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 321
    Top = 33
    Width = 6
    Height = 554
    ResizeStyle = rsUpdate
  end
  object Label32: TLabel
    Left = 248
    Top = 208
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label33: TLabel
    Left = 248
    Top = 224
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label36: TLabel
    Left = 256
    Top = 216
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label37: TLabel
    Left = 256
    Top = 232
    Width = 6
    Height = 13
    Caption = '0'
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 587
    Width = 798
    Height = 19
    Panels = <
      item
        Text = 'Elaspsed Time'
        Width = 150
      end
      item
        Text = 'Visibility'
        Width = 180
      end
      item
        Text = 'Selection'
        Width = 150
      end>
  end
  object Panel2: TPanel
    Left = 0
    Top = 33
    Width = 321
    Height = 554
    Align = alLeft
    Caption = 'Panel2'
    TabOrder = 1
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 319
      Height = 552
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = 'General'
        object Label4: TLabel
          Left = 15
          Top = 12
          Width = 34
          Height = 13
          Caption = 'Groups'
        end
        object Label3: TLabel
          Left = 11
          Top = 36
          Width = 54
          Height = 13
          Caption = 'Item Count'
        end
        object Label5: TLabel
          Left = 2
          Top = 58
          Width = 67
          Height = 13
          Caption = 'Column Count'
        end
        object Label18: TLabel
          Left = 8
          Top = 80
          Width = 22
          Height = 13
          Caption = 'View'
        end
        object Bevel5: TBevel
          Left = 8
          Top = 216
          Width = 273
          Height = 305
        end
        object Label26: TLabel
          Left = 8
          Top = 216
          Width = 44
          Height = 13
          Caption = 'Cell Sizes'
          FocusControl = Button2
        end
        object Label27: TLabel
          Left = 16
          Top = 240
          Width = 21
          Height = 13
          Caption = 'Icon'
        end
        object Label28: TLabel
          Left = 12
          Top = 296
          Width = 48
          Height = 13
          Caption = 'Small Icon'
        end
        object Label29: TLabel
          Left = 16
          Top = 340
          Width = 16
          Height = 13
          Caption = 'List'
        end
        object Label30: TLabel
          Left = 16
          Top = 436
          Width = 37
          Height = 13
          Caption = 'Thumbs'
        end
        object Label31: TLabel
          Left = 16
          Top = 484
          Width = 21
          Height = 13
          Caption = 'Tiles'
        end
        object LabelIconSizeWidth: TLabel
          Left = 248
          Top = 232
          Width = 6
          Height = 13
          Caption = '0'
        end
        object LabelIconSizeHeight: TLabel
          Left = 248
          Top = 248
          Width = 6
          Height = 13
          Caption = '0'
        end
        object LabelSmallIconSizeWidth: TLabel
          Left = 248
          Top = 280
          Width = 6
          Height = 13
          Caption = '0'
        end
        object LabelSmallIconSizeHeight: TLabel
          Left = 248
          Top = 296
          Width = 6
          Height = 13
          Caption = '0'
        end
        object LabelListSizeWidth: TLabel
          Left = 248
          Top = 328
          Width = 6
          Height = 13
          Caption = '0'
        end
        object LabelListSizeHeight: TLabel
          Left = 248
          Top = 344
          Width = 6
          Height = 13
          Caption = '0'
        end
        object LabelThumbSizeWidth: TLabel
          Left = 248
          Top = 426
          Width = 6
          Height = 13
          Caption = '0'
        end
        object LabelThumbSizeHeight: TLabel
          Left = 248
          Top = 444
          Width = 6
          Height = 13
          Caption = '0'
        end
        object LabelTileSizeWidth: TLabel
          Left = 248
          Top = 476
          Width = 6
          Height = 13
          Caption = '0'
        end
        object LabelTileSizeHeight: TLabel
          Left = 248
          Top = 492
          Width = 6
          Height = 13
          Caption = '0'
        end
        object Label34: TLabel
          Left = 16
          Top = 384
          Width = 33
          Height = 13
          Caption = 'Report'
        end
        object LabelReportSizeWidth: TLabel
          Left = 248
          Top = 376
          Width = 6
          Height = 13
          Caption = '0'
        end
        object LabelReportSizeHeight: TLabel
          Left = 248
          Top = 394
          Width = 6
          Height = 13
          Caption = '0'
        end
        object Label39: TLabel
          Left = 8
          Top = 128
          Width = 78
          Height = 13
          Caption = 'Tile Detail Count'
        end
        object TrackBarSizeReportHeight: TTrackBar
          Left = 67
          Top = 396
          Width = 181
          Height = 20
          Max = 300
          Frequency = 10
          TabOrder = 12
          ThumbLength = 10
          OnChange = TrackBarSizeReportHeightChange
        end
        object EditGroupCount: TEdit
          Left = 72
          Top = 8
          Width = 57
          Height = 21
          TabOrder = 0
          Text = '10'
        end
        object EditItemCount: TEdit
          Left = 72
          Top = 32
          Width = 57
          Height = 21
          TabOrder = 1
          Text = '10'
        end
        object EditColumnCount: TEdit
          Left = 72
          Top = 56
          Width = 57
          Height = 21
          TabOrder = 2
          Text = '10'
        end
        object Button2: TButton
          Left = 142
          Top = 32
          Width = 75
          Height = 25
          Caption = 'Add Items'
          TabOrder = 3
          OnClick = Button2Click
        end
        object Button3: TButton
          Left = 142
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Clear'
          TabOrder = 4
          OnClick = Button3Click
        end
        object CheckBoxThemed: TCheckBox
          Left = 8
          Top = 152
          Width = 97
          Height = 17
          Caption = 'Themed'
          TabOrder = 5
          OnClick = CheckBoxThemedClick
        end
        object cbViews: TComboBox
          Left = 14
          Top = 96
          Width = 145
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 6
          OnChange = cbViewsChange
        end
        object CheckBoxTrackSelections: TCheckBox
          Left = 88
          Top = 152
          Width = 169
          Height = 17
          Caption = 'Track Selections in Status Bar'
          TabOrder = 7
        end
        object CheckBoxRandomizeItemCount: TCheckBox
          Left = 134
          Top = 64
          Width = 153
          Height = 17
          Caption = 'Randomize Item Count'
          TabOrder = 8
        end
        object TrackBarSizeIconWidth: TTrackBar
          Left = 66
          Top = 232
          Width = 180
          Height = 20
          Max = 300
          Frequency = 10
          TabOrder = 9
          ThumbLength = 10
          OnChange = TrackBarSizeIconWidthChange
        end
        object TrackBarSizeIconHeight: TTrackBar
          Left = 66
          Top = 250
          Width = 180
          Height = 20
          Max = 300
          Frequency = 10
          TabOrder = 10
          ThumbLength = 10
          OnChange = TrackBarSizeIconHeightChange
        end
        object ButtonSizeReset: TButton
          Left = 237
          Top = 212
          Width = 43
          Height = 17
          Caption = 'Reset'
          TabOrder = 11
          OnClick = ButtonSizeResetClick
        end
        object TrackBarSizeReportWidth: TTrackBar
          Left = 67
          Top = 376
          Width = 180
          Height = 20
          Max = 300
          Frequency = 10
          TabOrder = 13
          ThumbLength = 10
          OnChange = TrackBarSizeReportWidthChange
        end
        object TrackBarSizeIconSmallHeight: TTrackBar
          Left = 66
          Top = 298
          Width = 180
          Height = 20
          Max = 300
          Frequency = 10
          TabOrder = 14
          ThumbLength = 10
          OnChange = TrackBarSizeIconSmallHeightChange
        end
        object TrackBarSizeIconSmallWidth: TTrackBar
          Left = 66
          Top = 280
          Width = 180
          Height = 20
          Max = 300
          Frequency = 10
          TabOrder = 15
          ThumbLength = 10
          OnChange = TrackBarSizeIconSmallWidthChange
        end
        object TrackBarSizeThumbsHeight: TTrackBar
          Left = 66
          Top = 446
          Width = 180
          Height = 20
          Max = 300
          Frequency = 10
          TabOrder = 16
          ThumbLength = 10
          OnChange = TrackBarSizeThumbsHeightChange
        end
        object TrackBarSizeThumbsWidth: TTrackBar
          Left = 67
          Top = 426
          Width = 180
          Height = 20
          Max = 300
          Frequency = 10
          TabOrder = 17
          ThumbLength = 10
          OnChange = TrackBarSizeThumbsWidthChange
        end
        object TrackBarSizeTilesHeight: TTrackBar
          Left = 67
          Top = 493
          Width = 180
          Height = 20
          Max = 300
          Frequency = 10
          TabOrder = 18
          ThumbLength = 10
          OnChange = TrackBarSizeTilesHeightChange
        end
        object TrackBarSizeTilesWidth: TTrackBar
          Left = 66
          Top = 474
          Width = 180
          Height = 20
          Max = 300
          Frequency = 10
          TabOrder = 19
          ThumbLength = 10
          OnChange = TrackBarSizeTilesWidthChange
        end
        object TrackBarSizeListHeight: TTrackBar
          Left = 66
          Top = 346
          Width = 180
          Height = 20
          Max = 300
          Frequency = 10
          TabOrder = 20
          ThumbLength = 10
          OnChange = TrackBarSizeListHeightChange
        end
        object TrackBarSizeListWidth: TTrackBar
          Left = 66
          Top = 328
          Width = 180
          Height = 20
          Max = 300
          Frequency = 10
          TabOrder = 21
          ThumbLength = 10
          OnChange = TrackBarSizeListWidthChange
        end
        object EditTileDetailCount: TEdit
          Left = 96
          Top = 124
          Width = 57
          Height = 21
          TabOrder = 22
          Text = '3'
          OnExit = EditTileDetailCountExit
          OnKeyPress = EditTileDetailCountKeyPress
        end
        object CheckBoxHideCaptions: TCheckBox
          Left = 8
          Top = 168
          Width = 185
          Height = 17
          Caption = 'Hide Thumbnail Captions'
          TabOrder = 23
          OnClick = CheckBoxHideCaptionsClick
        end
        object Button5: TButton
          Left = 216
          Top = 8
          Width = 89
          Height = 25
          Caption = 'Delete Selected'
          TabOrder = 24
          OnClick = Button5Click
        end
        object CheckBoxStateImages: TCheckBox
          Left = 8
          Top = 184
          Width = 169
          Height = 17
          Caption = 'State Images in Details mode'
          TabOrder = 25
          OnClick = CheckBoxStateImagesClick
        end
      end
      object TabSheet6: TTabSheet
        Caption = 'Groups'
        ImageIndex = 5
        object Label1: TLabel
          Left = 24
          Top = 72
          Width = 79
          Height = 13
          Caption = 'Band Start Color'
        end
        object Label14: TLabel
          Left = 112
          Top = 72
          Width = 73
          Height = 13
          Caption = 'Band End Color'
        end
        object Label23: TLabel
          Left = 16
          Top = 118
          Width = 73
          Height = 13
          Caption = 'Band Thickness'
        end
        object Bevel3: TBevel
          Left = 16
          Top = 184
          Width = 129
          Height = 57
        end
        object Label24: TLabel
          Left = 16
          Top = 184
          Width = 37
          Height = 13
          Caption = 'Margins'
        end
        object Label25: TLabel
          Left = 16
          Top = 142
          Width = 60
          Height = 13
          Caption = 'Band Length'
          FocusControl = Button2
        end
        object CheckBoxGroupExpandable: TCheckBox
          Left = 16
          Top = 32
          Width = 89
          Height = 17
          Caption = 'Expandable'
          TabOrder = 0
          OnClick = CheckBoxGroupExpandableClick
        end
        object CheckBoxBlendedBand: TCheckBox
          Left = 16
          Top = 48
          Width = 97
          Height = 17
          Caption = 'Blended Band'
          TabOrder = 1
          OnClick = CheckBoxBlendedBandClick
        end
        object PanelBandStartColor: TPanel
          Left = 32
          Top = 88
          Width = 57
          Height = 17
          TabOrder = 2
          OnClick = PanelBandStartColorClick
        end
        object PanelBandFadeColor: TPanel
          Left = 120
          Top = 88
          Width = 57
          Height = 17
          TabOrder = 3
          OnClick = PanelBandFadeColorClick
        end
        object EditBandWidth: TEdit
          Left = 96
          Top = 112
          Width = 57
          Height = 21
          TabOrder = 4
          Text = 'EditBandWidth'
          OnExit = EditBandWidthExit
          OnKeyPress = EditBandWidthKeyPress
        end
        object CheckBoxMarginTop: TCheckBox
          Left = 32
          Top = 200
          Width = 57
          Height = 17
          Caption = 'Top'
          Checked = True
          State = cbChecked
          TabOrder = 5
          OnClick = CheckBoxMarginTopClick
        end
        object CheckBoxMarginLeft: TCheckBox
          Left = 32
          Top = 216
          Width = 57
          Height = 17
          Caption = 'Left'
          TabOrder = 6
          OnClick = CheckBoxMarginLeftClick
        end
        object CheckBoxMarginRight: TCheckBox
          Left = 80
          Top = 216
          Width = 57
          Height = 17
          Caption = 'Right'
          TabOrder = 7
          OnClick = CheckBoxMarginRightClick
        end
        object CheckBoxMarginBottom: TCheckBox
          Left = 80
          Top = 200
          Width = 57
          Height = 17
          Caption = 'Bottom'
          TabOrder = 8
          OnClick = CheckBoxMarginBottomClick
        end
        object EditBandLength: TEdit
          Left = 96
          Top = 136
          Width = 57
          Height = 21
          TabOrder = 9
          Text = 'EditBandLength'
          OnExit = EditBandLengthExit
          OnKeyPress = EditBandLengthKeyPress
        end
        object CheckBoxBandTracksWindow: TCheckBox
          Left = 16
          Top = 160
          Width = 169
          Height = 17
          Caption = 'Band Length Tracks Window'
          TabOrder = 10
          OnClick = CheckBoxBandTracksWindowClick
        end
        object ButtonExpandAll: TButton
          Left = 16
          Top = 256
          Width = 75
          Height = 25
          Caption = 'Expand All'
          TabOrder = 11
          OnClick = ButtonExpandAllClick
        end
        object ButtonCollapseAll: TButton
          Left = 104
          Top = 256
          Width = 75
          Height = 25
          Caption = 'Collapse All'
          TabOrder = 12
          OnClick = ButtonCollapseAllClick
        end
        object CheckBoxShowGroupMargins: TCheckBox
          Left = 8
          Top = 8
          Width = 161
          Height = 17
          Caption = 'Show Group Margins'
          TabOrder = 13
          OnClick = CheckBoxShowGroupMarginsClick
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Visibility'
        ImageIndex = 1
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 311
          Height = 105
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Panel4: TPanel
            Left = 0
            Top = 0
            Width = 311
            Height = 105
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object CheckBoxVisHideItems: TCheckBox
              Left = 8
              Top = 8
              Width = 129
              Height = 17
              Caption = 'Hide Every Other Item'
              TabOrder = 0
              OnClick = CheckBoxVisHideItemsClick
            end
            object CheckBoxVisHideGroups: TCheckBox
              Left = 8
              Top = 24
              Width = 137
              Height = 17
              Caption = 'Hide Every Other Group'
              TabOrder = 1
              OnClick = CheckBoxVisHideGroupsClick
            end
          end
        end
      end
      object TabSheet3: TTabSheet
        Caption = 'Selection'
        ImageIndex = 2
        object Bevel4: TBevel
          Left = 8
          Top = 0
          Width = 297
          Height = 265
        end
        object Bevel1: TBevel
          Left = 8
          Top = 400
          Width = 297
          Height = 57
        end
        object Bevel2: TBevel
          Left = 8
          Top = 280
          Width = 297
          Height = 105
        end
        object LabelSelBlendAlpha: TLabel
          Left = 160
          Top = 336
          Width = 6
          Height = 13
          Caption = '0'
        end
        object Label6: TLabel
          Left = 16
          Top = 320
          Width = 56
          Height = 13
          Caption = 'Blend Alpha'
        end
        object Label7: TLabel
          Left = 52
          Top = 362
          Width = 96
          Height = 13
          Caption = 'Sel Rect Blend Color'
        end
        object Label8: TLabel
          Left = 56
          Top = 106
          Width = 60
          Height = 13
          Caption = 'Border Color'
        end
        object LabelSelColor: TLabel
          Left = 56
          Top = 122
          Width = 25
          Height = 13
          Caption = 'Color'
        end
        object LabelSelInactiveColor: TLabel
          Left = 160
          Top = 106
          Width = 67
          Height = 13
          Caption = 'Inactive Color'
        end
        object LabelSelInactiveBorderColor: TLabel
          Left = 160
          Top = 122
          Width = 102
          Height = 13
          Caption = 'Inactive Border Color'
        end
        object LabelSelInactiveTextColor: TLabel
          Left = 160
          Top = 138
          Width = 92
          Height = 13
          Caption = 'Inactive Text Color'
        end
        object Label1SelTextColor: TLabel
          Left = 56
          Top = 138
          Width = 50
          Height = 13
          Caption = 'Text Color'
        end
        object Label9: TLabel
          Left = 104
          Top = 162
          Width = 32
          Height = 13
          Caption = 'Radius'
        end
        object Label10: TLabel
          Left = 24
          Top = 410
          Width = 76
          Height = 13
          Caption = 'Delay Time (ms)'
        end
        object Label11: TLabel
          Left = 24
          Top = 436
          Width = 74
          Height = 13
          Caption = 'Scroll Time (ms)'
        end
        object Label12: TLabel
          Left = 152
          Top = 436
          Width = 55
          Height = 13
          Caption = 'Accelerator'
        end
        object Label13: TLabel
          Left = 144
          Top = 410
          Width = 97
          Height = 13
          Caption = 'Edge Margin (pixels)'
        end
        object Label15: TLabel
          Left = 192
          Top = 360
          Width = 102
          Height = 13
          Caption = 'Sel Rect Border Color'
        end
        object Label16: TLabel
          Left = 8
          Top = 280
          Width = 94
          Height = 13
          Caption = 'Selection Rectangle'
        end
        object Label19: TLabel
          Left = 224
          Top = 480
          Width = 60
          Height = 13
          Caption = 'Group Index'
        end
        object Label20: TLabel
          Left = 8
          Top = 504
          Width = 55
          Height = 13
          Caption = 'Selection...'
        end
        object Label44: TLabel
          Left = 16
          Top = 184
          Width = 56
          Height = 13
          Caption = 'Blend Alpha'
        end
        object LabelBlendAlphaTextRect: TLabel
          Left = 216
          Top = 184
          Width = 6
          Height = 13
          Caption = '0'
        end
        object CheckBoxSelMulti: TCheckBox
          Left = 16
          Top = 64
          Width = 81
          Height = 17
          Caption = 'Multi-Select'
          TabOrder = 0
          OnClick = CheckBoxSelMultiClick
        end
        object CheckBoxSelEnabled: TCheckBox
          Left = 8
          Top = 0
          Width = 73
          Height = 17
          Caption = 'Enabled'
          TabOrder = 1
          OnClick = CheckBoxSelEnabledClick
        end
        object CheckBoxSelAlphaRect: TCheckBox
          Left = 24
          Top = 296
          Width = 161
          Height = 17
          Caption = 'Alpha-Blend Selection Rect'
          TabOrder = 2
          OnClick = CheckBoxSelAlphaRectClick
        end
        object TrackBarSelBlendAlpha: TTrackBar
          Left = 16
          Top = 336
          Width = 129
          Height = 25
          Max = 255
          Frequency = 8
          TabOrder = 3
          ThumbLength = 10
          OnChange = TrackBarSelBlendAlphaChange
        end
        object PanelSelRectBlendColor: TPanel
          Left = 12
          Top = 360
          Width = 33
          Height = 16
          TabOrder = 4
          OnClick = PanelSelRectBlendColorClick
        end
        object PanelSelBorderColor: TPanel
          Left = 16
          Top = 101
          Width = 33
          Height = 16
          TabOrder = 5
          OnClick = PanelSelBorderColorClick
        end
        object PanelSelColor: TPanel
          Left = 16
          Top = 117
          Width = 33
          Height = 16
          TabOrder = 6
          OnClick = PanelSelColorClick
        end
        object PanelSelTextColor: TPanel
          Left = 16
          Top = 133
          Width = 33
          Height = 16
          TabOrder = 7
          OnClick = PanelSelTextColorClick
        end
        object PanelSelInactiveColor: TPanel
          Left = 120
          Top = 101
          Width = 33
          Height = 16
          TabOrder = 8
          OnClick = PanelSelInactiveColorClick
        end
        object PanelSelInactiveBorderColor: TPanel
          Left = 120
          Top = 117
          Width = 33
          Height = 16
          TabOrder = 9
          OnClick = PanelSelInactiveBorderColorClick
        end
        object PanelSelInactiveTextColor: TPanel
          Left = 120
          Top = 133
          Width = 33
          Height = 16
          TabOrder = 10
          OnClick = PanelSelInactiveTextColorClick
        end
        object CheckBoxSelFullRow: TCheckBox
          Left = 16
          Top = 32
          Width = 81
          Height = 17
          Caption = 'Row Select'
          TabOrder = 11
          OnClick = CheckBoxSelFullRowClick
        end
        object CheckBoxSelRound: TCheckBox
          Left = 16
          Top = 168
          Width = 77
          Height = 17
          Caption = 'Round Rect'
          TabOrder = 12
          OnClick = CheckBoxSelRoundClick
        end
        object EditSelRoundRadius: TEdit
          Left = 144
          Top = 160
          Width = 33
          Height = 21
          TabOrder = 13
          Text = '4'
          OnExit = EditSelRoundRadiusExit
          OnKeyPress = EditSelRoundRadiusKeyPress
        end
        object CheckBoxShowFocusRect: TCheckBox
          Left = 16
          Top = 16
          Width = 105
          Height = 17
          Caption = 'Show Focus Rect'
          TabOrder = 14
          OnClick = CheckBoxShowFocusRectClick
        end
        object CheckBoxSelDragRect: TCheckBox
          Left = 120
          Top = 16
          Width = 113
          Height = 17
          Caption = 'Enable Drag Rect'
          TabOrder = 15
          OnClick = CheckBoxSelDragRectClick
        end
        object CheckBoxSelAutoScroll: TCheckBox
          Left = 8
          Top = 392
          Width = 97
          Height = 17
          Caption = 'AutoScroll'
          TabOrder = 16
          OnClick = CheckBoxSelAutoScrollClick
        end
        object EditSelScrollDelay: TEdit
          Left = 112
          Top = 408
          Width = 25
          Height = 21
          TabOrder = 17
          Text = '500'
          OnExit = EditSelExit
          OnKeyPress = EditSelScrollDelayKeyPress
        end
        object EditSelScrollTime: TEdit
          Left = 112
          Top = 432
          Width = 25
          Height = 21
          TabOrder = 18
          Text = '50'
          OnExit = EditSelExit
          OnKeyPress = EditSelScrollDelayKeyPress
        end
        object EditSelAccel: TEdit
          Left = 248
          Top = 432
          Width = 25
          Height = 21
          TabOrder = 19
          Text = '2'
          OnExit = EditSelExit
          OnKeyPress = EditSelScrollDelayKeyPress
        end
        object EditSelEdgeMargin: TEdit
          Left = 248
          Top = 408
          Width = 25
          Height = 21
          TabOrder = 20
          Text = '15'
          OnExit = EditSelExit
          OnKeyPress = EditSelScrollDelayKeyPress
        end
        object PanelSelRectBorderColor: TPanel
          Left = 152
          Top = 360
          Width = 33
          Height = 16
          TabOrder = 21
          OnClick = PanelSelRectBorderColorClick
        end
        object CheckBoxSelAlphaBlend: TCheckBox
          Left = 16
          Top = 152
          Width = 78
          Height = 17
          Caption = 'Alpha Blend'
          TabOrder = 22
          OnClick = CheckBoxSelAlphaBlendClick
        end
        object ButtonSelFirst: TButton
          Left = 8
          Top = 464
          Width = 75
          Height = 17
          Caption = 'First'
          TabOrder = 23
          OnClick = ButtonSelFirstClick
        end
        object ButtonSelNext: TButton
          Left = 88
          Top = 464
          Width = 75
          Height = 17
          Caption = 'Next'
          TabOrder = 24
          OnClick = ButtonSelNextClick
        end
        object ButtonSelFirstInGroup: TButton
          Left = 8
          Top = 480
          Width = 75
          Height = 17
          Caption = 'First in Group'
          TabOrder = 25
          OnClick = ButtonSelFirstInGoupClick
        end
        object ButtonSelNextInGroup: TButton
          Left = 88
          Top = 480
          Width = 75
          Height = 17
          Caption = 'Next in Group'
          TabOrder = 26
          OnClick = ButtonSelNextInGroupClick
        end
        object EditSelGroup: TEdit
          Left = 168
          Top = 478
          Width = 49
          Height = 21
          TabOrder = 27
          Text = '0'
        end
        object ButtonSelAll: TButton
          Left = 72
          Top = 504
          Width = 33
          Height = 17
          Caption = 'All'
          TabOrder = 28
          OnClick = ButtonSelAllClick
        end
        object ButtonSelClear: TButton
          Left = 104
          Top = 504
          Width = 41
          Height = 17
          Caption = 'Clear'
          TabOrder = 29
          OnClick = ButtonSelClearClick
        end
        object ButtonSelInvert: TButton
          Left = 144
          Top = 504
          Width = 49
          Height = 17
          Caption = 'Invert'
          TabOrder = 30
          OnClick = ButtonSelInvertClick
        end
        object CheckBoxSelLinearSelect: TCheckBox
          Left = 16
          Top = 48
          Width = 105
          Height = 17
          Caption = 'Box Select'
          TabOrder = 31
          OnClick = CheckBoxSelLinearSelectClick
        end
        object GroupBox2: TGroupBox
          Left = 24
          Top = 224
          Width = 249
          Height = 33
          Caption = 'Mouse Button'
          TabOrder = 32
          object CheckBoxSelMouseButtonL: TCheckBox
            Left = 8
            Top = 14
            Width = 49
            Height = 17
            Caption = 'Left'
            TabOrder = 0
            OnClick = CheckBoxSelMouseButtonLClick
          end
          object CheckBoxSelMouseButtonR: TCheckBox
            Left = 96
            Top = 14
            Width = 57
            Height = 17
            Caption = 'Right'
            TabOrder = 1
            OnClick = CheckBoxSelMouseButtonRClick
          end
          object CheckBoxSelMouseButtonM: TCheckBox
            Left = 184
            Top = 14
            Width = 57
            Height = 17
            Caption = 'Middle'
            TabOrder = 2
            OnClick = CheckBoxSelMouseButtonMClick
          end
        end
        object GroupBox1: TGroupBox
          Left = 192
          Top = 288
          Width = 73
          Height = 67
          Caption = 'Mouse Button'
          TabOrder = 33
          object CheckBoxSelRectMouseButtonL: TCheckBox
            Left = 8
            Top = 16
            Width = 49
            Height = 17
            Caption = 'Left'
            TabOrder = 0
            OnClick = CheckBoxSelRectMouseButtonLClick
          end
          object CheckBoxSelRectMouseButtonR: TCheckBox
            Left = 8
            Top = 32
            Width = 57
            Height = 17
            Caption = 'Right'
            TabOrder = 1
            OnClick = CheckBoxSelRectMouseButtonRClick
          end
          object CheckBoxSelRectMouseButtonM: TCheckBox
            Left = 8
            Top = 47
            Width = 57
            Height = 17
            Caption = 'Middle'
            TabOrder = 2
            OnClick = CheckBoxSelRectMouseButtonMClick
          end
        end
        object CheckBoxFullItemSelect: TCheckBox
          Left = 120
          Top = 32
          Width = 145
          Height = 17
          Caption = 'Full Item Select Painting'
          TabOrder = 34
          OnClick = CheckBoxFullItemSelectClick
        end
        object CheckBoxFullCellSelect: TCheckBox
          Left = 120
          Top = 48
          Width = 145
          Height = 17
          Caption = 'Full Cell Select Painting'
          TabOrder = 35
          OnClick = CheckBoxFullCellSelectClick
        end
        object CheckBoxGroupSelection: TCheckBox
          Left = 120
          Top = 64
          Width = 169
          Height = 17
          Caption = 'Group Selection (Report Only)'
          TabOrder = 36
          OnClick = CheckBoxGroupSelectionClick
        end
        object CheckBoxResizeGroup: TCheckBox
          Left = 120
          Top = 80
          Width = 153
          Height = 17
          Caption = 'Resize Group On Focus'
          TabOrder = 37
          OnClick = CheckBoxResizeGroupClick
        end
        object CheckBoxBlendIcon: TCheckBox
          Left = 16
          Top = 80
          Width = 81
          Height = 17
          Caption = 'Blend Icon'
          TabOrder = 38
          OnClick = CheckBoxBlendIconClick
        end
        object CheckBoxDragDrop: TCheckBox
          Left = 192
          Top = 160
          Width = 97
          Height = 17
          Caption = 'Drag and Drop'
          TabOrder = 39
          OnClick = CheckBoxDragDropClick
        end
        object TrackBarSelTextBlendAlpha: TTrackBar
          Left = 80
          Top = 184
          Width = 129
          Height = 25
          Max = 255
          Frequency = 8
          TabOrder = 40
          ThumbLength = 10
          OnChange = TrackBarSelTextBlendAlphaChange
        end
        object CheckBoxSelectionGradient: TCheckBox
          Left = 16
          Top = 204
          Width = 97
          Height = 17
          BiDiMode = bdLeftToRight
          Caption = 'Gradient Effect'
          ParentBiDiMode = False
          TabOrder = 41
          OnClick = CheckBoxSelectionGradientClick
        end
        object PanelGradientTop: TPanel
          Left = 120
          Top = 205
          Width = 33
          Height = 16
          TabOrder = 42
          OnClick = PanelGradientTopClick
        end
        object PanelGradientBottom: TPanel
          Left = 160
          Top = 205
          Width = 33
          Height = 16
          TabOrder = 43
          OnClick = PanelGradientBottomClick
        end
        object CheckBoxSelectionBlurBkGnd: TCheckBox
          Left = 208
          Top = 204
          Width = 81
          Height = 17
          Caption = 'Blur BkGnd'
          TabOrder = 44
          OnClick = CheckBoxSelectionBlurBkGndClick
        end
      end
      object TabSheet4: TTabSheet
        Caption = 'Header'
        ImageIndex = 3
        object CheckBoxShowHeader: TCheckBox
          Left = 22
          Top = 8
          Width = 89
          Height = 17
          Caption = 'Show Header'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = CheckBoxShowHeaderClick
        end
        object EditMaxSizeWidth: TEdit
          Left = 40
          Top = 64
          Width = 89
          Height = 21
          Enabled = False
          TabOrder = 1
          Text = '250'
        end
        object CheckBoxMaxSizeWidth: TCheckBox
          Left = 24
          Top = 40
          Width = 121
          Height = 17
          Caption = 'Max Sizing Width'
          TabOrder = 2
          OnClick = CheckBoxMaxSizeWidthClick
        end
        object CheckBoxHeaderHotTrack: TCheckBox
          Left = 24
          Top = 104
          Width = 97
          Height = 17
          Caption = 'HotTrack'
          TabOrder = 3
          OnClick = CheckBoxHeaderHotTrackClick
        end
        object CheckBoxHeaderSizeable: TCheckBox
          Left = 24
          Top = 120
          Width = 97
          Height = 17
          Caption = 'Sizeable'
          TabOrder = 4
          OnClick = CheckBoxHeaderSizeableClick
        end
        object CheckBoxHeaderClickable: TCheckBox
          Left = 24
          Top = 136
          Width = 97
          Height = 17
          Caption = 'Clickable'
          Checked = True
          State = cbChecked
          TabOrder = 5
          OnClick = CheckBoxHeaderClickableClick
        end
        object CheckBoxHeaderDraggable: TCheckBox
          Left = 24
          Top = 152
          Width = 97
          Height = 17
          Caption = 'Draggable'
          TabOrder = 6
          OnClick = CheckBoxHeaderDraggableClick
        end
        object CheckBoxAutoToggleSort: TCheckBox
          Left = 24
          Top = 176
          Width = 121
          Height = 17
          Caption = 'Auto Toggle Sort'
          Checked = True
          State = cbChecked
          TabOrder = 7
          OnClick = CheckBoxAutoToggleSortClick
        end
        object CheckBoxHilightColumn: TCheckBox
          Left = 24
          Top = 208
          Width = 97
          Height = 17
          Caption = 'Hilight Column'
          TabOrder = 8
          OnClick = CheckBoxHilightColumnClick
        end
        object ButtonHilightColor: TButton
          Left = 24
          Top = 232
          Width = 105
          Height = 25
          Caption = 'Hilight Color...'
          TabOrder = 9
          OnClick = ButtonHilightColorClick
        end
        object CheckBoxGridLines: TCheckBox
          Left = 24
          Top = 272
          Width = 97
          Height = 17
          Caption = 'Grid Lines'
          TabOrder = 10
          OnClick = CheckBoxGridLinesClick
        end
        object ButtonGridLineColor: TButton
          Left = 24
          Top = 296
          Width = 105
          Height = 25
          Caption = 'Grid Lines Color..,'
          TabOrder = 11
          OnClick = ButtonGridLineColorClick
        end
      end
      object TabSheet5: TTabSheet
        Caption = 'Checks'
        ImageIndex = 4
        object Label2: TLabel
          Left = 84
          Top = 32
          Width = 59
          Height = 13
          Caption = 'Item Checks'
        end
        object Label17: TLabel
          Left = 16
          Top = 8
          Width = 81
          Height = 13
          Caption = 'Item Check Type'
        end
        object Label21: TLabel
          Left = 16
          Top = 48
          Width = 88
          Height = 13
          Caption = 'Group Check Type'
        end
        object Label22: TLabel
          Left = 16
          Top = 88
          Width = 94
          Height = 13
          Caption = 'Column Check Type'
        end
        object ComboBoxItemItemCheckType: TComboBox
          Left = 22
          Top = 24
          Width = 121
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnChange = Chnge
          Items.Strings = (
            'None'
            'None with Space'
            'Box'
            'Radio')
        end
        object ComboBoxItemGroupCheckType: TComboBox
          Left = 22
          Top = 64
          Width = 121
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
          OnChange = ComboBoxItemGroupCheckTypeChange
          Items.Strings = (
            'None'
            'None with Space'
            'Box'
            'Radio')
        end
        object ComboBoxItemColumnCheckType: TComboBox
          Left = 22
          Top = 104
          Width = 121
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
          OnChange = ComboBoxItemColumnCheckTypeChange
          Items.Strings = (
            'None'
            'None with Space'
            'Box'
            'Radio')
        end
      end
      object TabSheet7: TTabSheet
        Caption = 'Streams'
        ImageIndex = 6
        object Label35: TLabel
          Left = 16
          Top = 24
          Width = 122
          Height = 13
          Caption = 'Save EasyListview To File'
        end
        object Label38: TLabel
          Left = 16
          Top = 80
          Width = 133
          Height = 13
          Caption = 'Load EasyListview From File'
        end
        object Button1: TButton
          Left = 176
          Top = 24
          Width = 75
          Height = 25
          Caption = 'Save...'
          TabOrder = 0
          OnClick = Button1Click
        end
        object Button4: TButton
          Left = 176
          Top = 72
          Width = 75
          Height = 25
          Caption = 'Load...'
          TabOrder = 1
          OnClick = Button4Click
        end
      end
      object TabSheet8: TTabSheet
        Caption = 'Colors'
        ImageIndex = 7
        object CheckBoxRandomItemCaptionColor: TCheckBox
          Left = 16
          Top = 24
          Width = 177
          Height = 17
          Caption = 'Color Item Captions'
          TabOrder = 0
          OnClick = CheckBoxRandomItemCaptionColorClick
        end
        object CheckBoxRandomGroupCaptionColor: TCheckBox
          Left = 16
          Top = 40
          Width = 177
          Height = 17
          Caption = 'Random Group Caption Colors'
          TabOrder = 1
          OnClick = CheckBoxRandomGroupCaptionColorClick
        end
        object CheckBoxRandomHeaderCaptionColors: TCheckBox
          Left = 16
          Top = 56
          Width = 185
          Height = 17
          Caption = 'Random Header Caption Colors'
          TabOrder = 2
          OnClick = CheckBoxRandomHeaderCaptionColorsClick
        end
        object CheckBoxRedDetails: TCheckBox
          Left = 16
          Top = 88
          Width = 169
          Height = 17
          Caption = 'Paint Details Red'
          TabOrder = 3
          OnClick = CheckBoxRedDetailsClick
        end
      end
      object TabSheet9: TTabSheet
        Caption = 'Incremental Search'
        ImageIndex = 8
        object Label40: TLabel
          Left = 16
          Top = 112
          Width = 60
          Height = 13
          Caption = 'Search Type'
        end
        object Label41: TLabel
          Left = 16
          Top = 160
          Width = 51
          Height = 13
          Caption = 'Start Type'
        end
        object Label42: TLabel
          Left = 16
          Top = 208
          Width = 77
          Height = 13
          Caption = 'Reset Time (ms)'
        end
        object Label43: TLabel
          Left = 8
          Top = 264
          Width = 34
          Height = 13
          Caption = 'Query:'
        end
        object LabelQuery: TLabel
          Left = 48
          Top = 264
          Width = 55
          Height = 13
          Caption = 'LabelQuery'
        end
        object Label45: TLabel
          Left = 8
          Top = 304
          Width = 57
          Height = 13
          Caption = 'Item Index:'
        end
        object LabelItemIndex: TLabel
          Left = 72
          Top = 304
          Width = 75
          Height = 13
          Caption = 'LabelItemIndex'
        end
        object CheckBoxIncrementalSearchEnable: TCheckBox
          Left = 8
          Top = 16
          Width = 81
          Height = 17
          Caption = 'Enabled'
          TabOrder = 0
          OnClick = CheckBoxIncrementalSearchEnableClick
        end
        object ComboBoxIncrementalSearchType: TComboBox
          Left = 24
          Top = 128
          Width = 145
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 1
          Text = 'eisiAll'
          OnChange = ComboBoxIncrementalSearchTypeChange
          Items.Strings = (
            'eisiAll'
            'eisiInitializedOnly'
            'eisiVisible')
        end
        object ComboBoxIncrementalSearchStartType: TComboBox
          Left = 24
          Top = 176
          Width = 145
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 2
          Text = 'eissStartOver'
          OnChange = ComboBoxIncrementalSearchStartTypeChange
          Items.Strings = (
            'eissStartOver'
            'eissLastHit'
            'eissFocusedNode')
        end
        object RadioGroupIncrementalSearchDir: TRadioGroup
          Left = 16
          Top = 40
          Width = 137
          Height = 57
          Caption = 'Direction'
          Items.Strings = (
            'Forward'
            'Backward')
          TabOrder = 3
          OnClick = RadioGroupIncrementalSearchDirClick
        end
        object EditIncrementalSearchResetTime: TEdit
          Left = 24
          Top = 224
          Width = 121
          Height = 21
          TabOrder = 4
          Text = '1000'
          OnExit = EditIncrementalSearchResetTimeExit
          OnKeyPress = EditIncrementalSearchResetTimeKeyPress
        end
      end
      object TabSheet10: TTabSheet
        Caption = 'DragDrop'
        ImageIndex = 9
        object CheckBoxDragDropEnabled: TCheckBox
          Left = 16
          Top = 32
          Width = 97
          Height = 17
          Caption = 'Enabled'
          TabOrder = 0
          OnClick = CheckBoxDragDropEnabledClick
        end
      end
      object TabSheet11: TTabSheet
        Caption = 'HotTracking'
        ImageIndex = 10
        object Label46: TLabel
          Left = 16
          Top = 376
          Width = 111
          Height = 13
          Caption = 'Group not Hot Tracking'
        end
        object Label48: TLabel
          Left = 16
          Top = 416
          Width = 104
          Height = 13
          Caption = 'Item not Hot Tracking'
        end
        object Label50: TLabel
          Left = 8
          Top = 400
          Width = 27
          Height = 13
          Caption = 'Items'
          FocusControl = Button1
        end
        object Label51: TLabel
          Left = 8
          Top = 360
          Width = 34
          Height = 13
          Caption = 'Groups'
        end
        object Label47: TLabel
          Left = 8
          Top = 8
          Width = 253
          Height = 26
          Caption = 
            'Events are fired for hottracking of items and Groups.  The contr' +
            'ol must have the focus.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Shell Dlg 2'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object CheckBoxHotTrackEnable: TCheckBox
          Left = 16
          Top = 56
          Width = 97
          Height = 17
          Caption = 'Enabled'
          TabOrder = 0
          OnClick = CheckBoxHotTrackEnableClick
        end
        object GroupBoxGroupHotTrack: TGroupBox
          Left = 24
          Top = 96
          Width = 225
          Height = 89
          Caption = 'Group Hot Track Area'
          TabOrder = 1
          object CheckBoxGroupHitIcon: TCheckBox
            Left = 8
            Top = 16
            Width = 97
            Height = 17
            Caption = 'Icon'
            TabOrder = 0
            OnClick = CheckBoxGroupHitIconClick
          end
          object CheckBoxGroupHitText: TCheckBox
            Left = 8
            Top = 32
            Width = 97
            Height = 17
            Caption = 'Text'
            TabOrder = 1
            OnClick = CheckBoxGroupHitTextClick
          end
          object CheckBoxGroupHitTop: TCheckBox
            Left = 8
            Top = 48
            Width = 97
            Height = 17
            Caption = 'Top Margin'
            TabOrder = 2
            OnClick = CheckBoxGroupHitTopClick
          end
          object CheckBoxGroupHitBottom: TCheckBox
            Left = 8
            Top = 64
            Width = 97
            Height = 17
            Caption = 'Bottom Margin'
            TabOrder = 3
            OnClick = CheckBoxGroupHitBottomClick
          end
          object CheckBoxGroupHitLeft: TCheckBox
            Left = 128
            Top = 16
            Width = 89
            Height = 17
            Caption = 'Left Margin'
            TabOrder = 4
            OnClick = CheckBoxGroupHitLeftClick
          end
          object CheckBoxGroupHitRight: TCheckBox
            Left = 128
            Top = 32
            Width = 89
            Height = 17
            Caption = 'Right Margin'
            TabOrder = 5
            OnClick = CheckBoxGroupHitRightClick
          end
          object CheckBoxGroupHitAnywhere: TCheckBox
            Left = 128
            Top = 48
            Width = 89
            Height = 17
            Caption = 'AnyWhere'
            TabOrder = 6
            OnClick = CheckBoxGroupHitAnywhereClick
          end
        end
        object GroupBox4: TGroupBox
          Left = 24
          Top = 192
          Width = 225
          Height = 73
          Caption = 'Item Hot Track Area'
          TabOrder = 2
          object CheckBoxItemHitIcon: TCheckBox
            Left = 8
            Top = 16
            Width = 97
            Height = 17
            Caption = 'Icon'
            TabOrder = 0
            OnClick = CheckBoxItemHitIconClick
          end
          object CheckBoxItemHitText: TCheckBox
            Left = 8
            Top = 32
            Width = 97
            Height = 17
            Caption = 'Text'
            TabOrder = 1
            OnClick = CheckBoxItemHitTextClick
          end
          object CheckBoxItemHitAnyWhere: TCheckBox
            Left = 8
            Top = 48
            Width = 97
            Height = 17
            Caption = 'AnyWhere'
            TabOrder = 2
            OnClick = CheckBoxItemHitAnyWhereClick
          end
        end
        object CheckBoxUnderLineText: TCheckBox
          Left = 24
          Top = 272
          Width = 97
          Height = 17
          Caption = 'UnderLine Text'
          TabOrder = 3
          OnClick = CheckBoxUnderLineTextClick
        end
        object CheckBoxHotTrackFocusOnly: TCheckBox
          Left = 24
          Top = 288
          Width = 209
          Height = 17
          Caption = 'Track when Control has Focus Only'
          TabOrder = 4
          OnClick = CheckBoxHotTrackFocusOnlyClick
        end
      end
      object TabSheet12: TTabSheet
        Caption = 'Background'
        ImageIndex = 11
        object Bevel6: TBevel
          Left = 8
          Top = 216
          Width = 257
          Height = 161
        end
        object Label49: TLabel
          Left = 8
          Top = 208
          Width = 106
          Height = 13
          Caption = 'Fixed Backgound Text'
        end
        object Bevel7: TBevel
          Left = 8
          Top = 8
          Width = 257
          Height = 185
        end
        object Label52: TLabel
          Left = 8
          Top = 0
          Width = 91
          Height = 13
          Caption = 'Background Bitmap'
        end
        object Label53: TLabel
          Left = 16
          Top = 128
          Width = 37
          Height = 13
          Caption = 'XOffset'
        end
        object Label55: TLabel
          Left = 16
          Top = 152
          Width = 37
          Height = 13
          Caption = 'YOffset'
        end
        object Label54: TLabel
          Left = 16
          Top = 48
          Width = 30
          Height = 13
          Caption = 'Image'
        end
        object Bevel8: TBevel
          Left = 8
          Top = 384
          Width = 257
          Height = 105
        end
        object Label56: TLabel
          Left = 8
          Top = 384
          Width = 126
          Height = 13
          Caption = 'CustomDrawn Background'
        end
        object Label57: TLabel
          Left = 40
          Top = 440
          Width = 27
          Height = 13
          Caption = 'Alpha'
        end
        object EditBkGndCaption: TEdit
          Left = 96
          Top = 232
          Width = 121
          Height = 21
          TabOrder = 0
          Text = 'Background Text'
          OnChange = EditBkGndCaptionChange
        end
        object CheckBoxBkGndText: TCheckBox
          Left = 16
          Top = 232
          Width = 81
          Height = 17
          Caption = 'Show Text'
          TabOrder = 1
          OnClick = CheckBoxBkGndTextClick
        end
        object CheckBoxBkGnd: TCheckBox
          Left = 16
          Top = 24
          Width = 97
          Height = 17
          Caption = 'Show Image'
          TabOrder = 2
          OnClick = CheckBoxBkGndClick
        end
        object CheckBoxBkGndCaptionOnlyWhenEmpty: TCheckBox
          Left = 16
          Top = 336
          Width = 225
          Height = 17
          Caption = 'Show Only when Control is Empty'
          TabOrder = 3
          OnClick = CheckBoxBkGndCaptionOnlyWhenEmptyClick
        end
        object RadioGroupBkGndCaptionAlignment: TRadioGroup
          Left = 16
          Top = 256
          Width = 113
          Height = 73
          Caption = 'Alignment'
          Items.Strings = (
            'Left'
            'Right'
            'Center')
          TabOrder = 4
          OnClick = RadioGroupBkGndCaptionAlignmentClick
        end
        object RadioGroupBkGndCaptionVAlignment: TRadioGroup
          Left = 136
          Top = 256
          Width = 113
          Height = 73
          Caption = 'Vertical Alignment'
          Items.Strings = (
            'Top'
            'Bottom'
            'Center')
          TabOrder = 5
          OnClick = RadioGroupBkGndCaptionVAlignmentClick
        end
        object CheckBoxBkGndCaptionSingleLine: TCheckBox
          Left = 16
          Top = 352
          Width = 97
          Height = 17
          Caption = 'Single Line'
          TabOrder = 6
          OnClick = CheckBoxBkGndCaptionSingleLineClick
        end
        object CheckBoxBkGndTile: TCheckBox
          Left = 16
          Top = 72
          Width = 97
          Height = 17
          Caption = 'Tile'
          TabOrder = 7
          OnClick = CheckBoxBkGndTileClick
        end
        object CheckBoxBkGndTransparent: TCheckBox
          Left = 16
          Top = 88
          Width = 97
          Height = 17
          Caption = 'Transparent'
          TabOrder = 8
          OnClick = CheckBoxBkGndTransparentClick
        end
        object TrackBarBkGndXOffset: TTrackBar
          Left = 64
          Top = 128
          Width = 150
          Height = 25
          Max = 100
          Frequency = 10
          TabOrder = 9
          ThumbLength = 10
          OnChange = TrackBarBkGndXOffsetChange
        end
        object TrackBarBkGndYOffset: TTrackBar
          Left = 64
          Top = 152
          Width = 150
          Height = 25
          Max = 100
          Frequency = 10
          TabOrder = 10
          ThumbLength = 10
          OnChange = TrackBarBkGndYOffsetChange
        end
        object CheckBoxTrackOffsets: TCheckBox
          Left = 16
          Top = 104
          Width = 97
          Height = 17
          Caption = 'Track Offsets'
          TabOrder = 11
          OnClick = CheckBoxTrackOffsetsClick
        end
        object EditBkGndImage: TEdit
          Left = 56
          Top = 48
          Width = 177
          Height = 21
          TabOrder = 12
        end
        object ButtonBkGndLoadImage: TButton
          Left = 232
          Top = 47
          Width = 27
          Height = 22
          Caption = '...'
          TabOrder = 13
          OnClick = ButtonBkGndLoadImageClick
        end
        object CheckBoxBkGndCustomDraw: TCheckBox
          Left = 16
          Top = 400
          Width = 97
          Height = 17
          Caption = 'CustomDraw'
          TabOrder = 14
          OnClick = CheckBoxBkGndCustomDrawClick
        end
        object CheckBoxCustomBkGndAlphaBlend: TCheckBox
          Left = 32
          Top = 420
          Width = 97
          Height = 17
          Caption = 'AlphaBlend'
          TabOrder = 15
          OnClick = CheckBoxCustomBkGndAlphaBlendClick
        end
        object TrackBarCustomDrawBkGnd: TTrackBar
          Left = 72
          Top = 440
          Width = 150
          Height = 25
          Max = 255
          Frequency = 8
          TabOrder = 16
          ThumbLength = 10
          OnChange = TrackBarCustomDrawBkGndChange
        end
      end
    end
  end
  object EasyListview1: TEasyListview
    Left = 327
    Top = 33
    Width = 471
    Height = 554
    Align = alClient
    BackGround.AlphaBlend = True
    BackGround.BlendAlpha = 192
    BackGround.Caption = 'This text is shown in the background of the control'
    BackGround.Image.Data = {
      36180000424D3618000000000000360800002800000020000000200000000100
      2000000000000010000000000000000000000001000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
      A6000020400000206000002080000020A0000020C0000020E000004000000040
      20000040400000406000004080000040A0000040C0000040E000006000000060
      20000060400000606000006080000060A0000060C0000060E000008000000080
      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
      20004000400040006000400080004000A0004000C0004000E000402000004020
      20004020400040206000402080004020A0004020C0004020E000404000004040
      20004040400040406000404080004040A0004040C0004040E000406000004060
      20004060400040606000406080004060A0004060C0004060E000408000004080
      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
      20008000400080006000800080008000A0008000C0008000E000802000008020
      20008020400080206000802080008020A0008020C0008020E000804000008040
      20008040400080406000804080008040A0008040C0008040E000806000008060
      20008060400080606000806080008060A0008060C0008060E000808000008080
      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00C0C0C000A4A0A00080808000C0A0A000FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00A4A0A000808080004060A0008080A000C0A0
      A000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF0080A0C00040A0E0004080E0004060A0008080
      A000C0A0A000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF0080C0E00040C0E00040A0E0004080E0004060
      A0008080A000C0A0A000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF0080C0E00040C0E00040A0E0004080
      E0004060A0008080A000C0A0A000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0080C0E00040C0E00040A0
      E0004080E0004060A0008080A000C0A0A000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0080C0E00040C0
      E00040A0E0004080E0004060A0008080A000C0A0C000FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0080C0
      E00040C0E00040A0E0004080E0004060A000A4A0A000FF00FF00FF00FF00FF00
      FF00C0C0C000C0C0C000C0DCC000C0DCC000C0DCC000FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF0080C0E00040C0E00040A0E0004080C0008080A000C0C0C000C0C0C000C0A0
      A000C0A08000C0A08000C0A0A000C0C0A000C0A0A000C0A0A000C0C0C000FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF0080E0E00080C0E000C0C0C000A4A0A000C0808000C0A08000F0CA
      A600F0CAA600FFFFFF00FFFFFF00FFFFFF00F0CAA600F0CAA600C0A0A000C0A0
      A000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00C0DCC000C0A0A000C0A08000F0CAA600FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F0FBFF00C0A0
      A000C0A0A000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00C0C0C000C0A08000F0CAA600FFFFFF00F0CA
      A600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F0FB
      FF00C0A08000C0DCC000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00C0C0C000F0CAA600F0CAA600F0CAA600F0CA
      A600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00F0CAA600C0808000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00C0DCC000C0A0A000F0CAA600F0CAA600F0CAA600F0CA
      A600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00F0CAA600C0808000C0DCC000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00C0DCC000C0A0A000F0CAA600F0CAA600F0CAA600F0CA
      A600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0A08000C0DCC000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00C0DCC000C0A0A000FFFFFF00F0CAA600F0CAA600F0CA
      A600F0CAA600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0A08000C0DCC000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00C0DCC000C0A0A000F0CAA600F0CAA600F0CAA600F0CA
      A600F0CAA600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00F0CAA600C0808000C0DCC000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00C0A0A000F0CAA600FFFFFF00F0CAA600F0CA
      A600F0CAA600F0CAA600F0CAA600F0CAA600FFFFFF00FFFFFF00F0CAA600FFFF
      FF00F0CAA600C0808000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00C0C0C000F0CAA600FFFFFF00FFFFFF00FFFF
      FF00F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CA
      A600C0A08000C0A0A000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00C0DCC000C0A0A000F0CAA600FFFFFF00FFFF
      FF00F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CA
      A600C0808000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00C0C0C000C0A0A000F0FBFF00FFFF
      FF00FFFFFF00FFFFFF00F0CAA600F0CAA600FFFFFF00F0CAA600F0CAA600C080
      8000C0DCC000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00C0DCC000C0808000C0A0
      A000F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600C0A0A000C0A0A000C0DC
      C000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00C0C0
      C000C0808000C0808000C0808000C0A0A000C0A0A000C0C0C000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
    BackGround.OffsetTrack = True
    BackGround.Transparent = True
    CacheDoubleBufferBits = False
    EditManager.Enabled = True
    UseDockManager = False
    DragManager.Enabled = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Shell Dlg 2'
    Font.Style = []
    GroupFont.Charset = ANSI_CHARSET
    GroupFont.Color = clWindowText
    GroupFont.Height = -13
    GroupFont.Name = 'Comic Sans MS'
    GroupFont.Style = [fsBold]
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Shell Dlg 2'
    Header.Font.Style = []
    IncrementalSearch.Enabled = True
    ImagesGroup = Imagelists.ImageListGroups
    ImagesSmall = Imagelists.ImageListSmall
    ImagesLarge = Imagelists.ImageListLarge
    ImagesExLarge = Imagelists.ImageListExLarge
    PaintInfoGroup.MarginBottom.CaptionIndent = 4
    PaintInfoItem.ShowBorder = False
    ParentFont = False
    ShowGroupMargins = True
    TabOrder = 2
    View = elsIcon
    OnColumnClick = EasyListview1ColumnClick
    OnColumnGetImageIndex = EasyListview1ColumnGetImageIndex
    OnColumnInitialize = EasyListview1ColumnInitialize
    OnColumnPaintText = EasyListview1ColumnPaintText
    OnColumnSizeChanging = EasyListview1ColumnSizeChanging
    OnGroupFreeing = EasyListview1GroupFreeing
    OnGroupGetCaption = EasyListview1GroupGetCaption
    OnGroupGetImageIndex = EasyListview1GroupGetImageIndex
    OnGroupInitialize = EasyListview1GroupInitialize
    OnGroupPaintText = EasyListview1GroupPaintText
    OnGroupHotTrack = EasyListview1GroupHotTrack
    OnIncrementalSearch = EasyListview1IncrementalSearch
    OnItemFreeing = EasyListview1ItemFreeing
    OnItemGetCaption = EasyListview1ItemGetCaption
    OnItemGetImageIndex = EasyListview1ItemGetImageIndex
    OnItemGetTileDetail = EasyListview1ItemGetTileDetail
    OnItemGetTileDetailCount = EasyListview1ItemGetTileDetailCount
    OnItemHotTrack = EasyListview1ItemHotTrack
    OnItemPaintText = EasyListview1ItemPaintText
    OnItemSelectionChanged = EasyListview1ItemSelectionChanged
    OnItemVisibilityChanged = EasyListview1ItemVisibilityChanged
    OnOLEDragStart = EasyListview1OLEDragStart
    OnOLEDragOver = EasyListview1OLEDragOver
    OnPaintBkGnd = EasyListview1PaintBkGnd
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 0
    Width = 798
    Height = 33
    Align = alTop
    AutoSize = False
    BevelKind = bkFlat
    BorderStyle = sbsSingle
    Caption = 
      'NOTE:  Running the demo through the IDE and creating large numbe' +
      'rs of items may be slow closing.  This is apparently do to the W' +
      'indows Unicode string deletion to be effected by the IDE.  Runni' +
      'ng the demo outside the IDE greatly increases the speed of the a' +
      'pplication.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Shell Dlg 2'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object ColorDialog1: TColorDialog
    Left = 280
    Top = 161
  end
  object OpenDialogStream: TOpenDialog
    Left = 272
    Top = 128
  end
  object SaveDialogStream: TSaveDialog
    Left = 272
    Top = 80
  end
  object ImageListState: TImageList
    Left = 269
    Top = 226
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FFF0DFE7FFC987A8FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FFDCCAD1FF9C727FFF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FFB8BCAFFF3A7530FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FFBD6293FFFE88D3FFDE75B7FFD09BB6FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF927178FFC4BBBBFFB3A3A3FFA57D8BFF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF158521FF13DD77FF11BD53FF517744FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FFF9F2
      F6FFF995DAFFF282C4FFF385C7FFFE9CE0FFEE99D7FFC06C99FFE1BFD0FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FFF1E9
      EDFFCFC4C4FFA49C9CFFA39B9BFFBEB7B7FFC3B6B6FF95757BFFC1A1ADFF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FFE2E1
      DEFF1EDC7BFF18C85FFF1BC961FF26E07FFF2AD578FF258A2CFF849176FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FFBC63
      93FFF898D9FFF492D1FFF596D5FFF69ADAFFF69EDDFFF9A7E5FFFEDBF9FFE1A5
      CEFFC46FA2FFC379A0FFCD96B2FF000000FF000000FF000000FF000000FF9171
      77FFBCB5B5FFACA4A4FFABA3A3FFAAA2A2FFA7A0A0FFADA5A5FFDEDADAFFBCAF
      AFFF997F82FF946D78FFA27C89FF000000FF000000FF000000FF000000FF1784
      1FFF26D775FF23CF6AFF26D16CFF28D470FF2BD671FF33DC7BFF9CF4C6FF5FCA
      81FF1D9B36FF2B7A28FF4B7A40FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FFDCB5C8FFFFC0
      FCFFF49EDBFFF6A3E0FFF7A8E4FFF8A8E7FFF8A9E8FFFAACEBFFFCCAF3FFFEF0
      FBFFFFC4FFFFFFEDFFFFFF8ED8FF000000FF000000FF000000FFB794A0FFECE3
      E3FFB1AAAAFFB2ABABFFB3ACACFFB1A9A9FFAEA7A7FFAFA7A7FFCAC5C5FFEFED
      EDFFD5CBCBFFF1EDEDFFC0B8B8FF000000FF000000FF000000FF748665FF3DF1
      9EFF2BD16FFF2ED673FF32D978FF30DA78FF33DD7BFF3AE180FF80EDAEFFDCFA
      E8FF54F6ACFFC0FFE6FF34DB79FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FFF9F2F6FFF2B4EBFFF4A4
      DFFFF6A7E3FFF7A9E5FFF8A7E6FFFFF0FFFFFFEFFFFFFEE3FAFFFFF9FFFFFFFF
      FFFFFFC4FFFFFFEEF6FFE59BD4FF000000FF000000FFF0E9EDFFE4D7D7FFB9B1
      B1FFBAB3B3FFB9B2B2FFB5ACACFFFDFAFAFFF7F5F5FFE7E4E4FFFAF9F9FFFFFF
      FFFFDED3D3FFF6F5F5FFBFB1B1FF000000FF000000FFE1E1DEFF3EDF8CFF33D5
      75FF37D97AFF3ADC7EFF35DD7BFFCCFEEAFFD1FCE9FFBBF7D6FFF0FEF7FFFFFF
      FFFF63FAB8FFE7F7EAFF42D17CFF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FAF5F7FFDB92C6FFFCBAF4FFF7AA
      E6FFF7A8E5FFF8AAE8FFF9AAEAFFFFFAFFFFFFE7FFFFFFD6FFFFFFDDFFFFFFCB
      FFFFFFF1FFFFFF88CEFFC06F9CFF000000FFF3EDEFFFC8B8B8FFE4DBDBFFC5BD
      BDFFBEB6B6FFBEB6B6FFBDB4B4FFFFFFFFFFF8F3F3FFF2EAEAFFF4EEEEFFEAE1
      E1FFF9F6F6FFB9B1B1FF97797FFF000000FFE7E7E3FF3AC168FF4AEB99FF3DDF
      83FF41DF82FF44E286FF41E486FFEEFFF9FFBFFEE2FF96FDCFFFACFEDBFF81FE
      C8FFDBFFF1FF34CE68FF288E31FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FFD8A7BFFFD59DBEFFFFF6
      FFFFFFDCFFFFFFDAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC4FFFFFFC7FFFFFFC5
      FFFFFFFFFFFFFF97E4FFD9AEC4FF000000FF000000FFAD8593FFC8BDBDFFFFFF
      FFFFFFFAFAFFFFF8F8FFFFFFFFFFFFFFFFFFFFFFFFFFF4EAEAFFF2E8E8FFEFE5
      E5FFFFFFFFFFC5BBBBFFB18D9AFF000000FF000000FF627C53FF6EBF7CFFDAFF
      F3FF9FFED6FFA0FED5FFFEFFFFFFFEFFFFFFFFFFFFFF76FFC5FF7CFFC7FF76FF
      C5FFFFFFFFFF35E382FF69815BFF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FFD3CBCFFFF856B0FFFF62
      BAFFFFE6F5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC7FFFFFFC7FFFFFFD5
      FFFFFFDDF1FFFFBDF9FFF6EDF1FF000000FF000000FFB2AAADFFA29696FFA99F
      9FFFF1F0F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBF0F0FFF9EFEFFFF9F1
      F1FFE8E6E6FFE5DBDBFFEADFE2FF000000FF000000FF91948CFF0AC045FF17C9
      54FFDAF7E4FFFFFFFFFFFEFFFFFFFEFFFFFFFFFFFFFF79FFC7FF7CFFC7FF9DFF
      D5FFC4F1D4FF6DF9B8FFD6D5CFFF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000ECDAE3FFF258AEFFFF63BBFFFF64
      BDFFFFBCE3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC5FFFFFFC6FFFFFFF9
      FFFFFF93D4FFF3B9EFFF000000FF000000FFD6C3CAFFA79A9AFFB0A5A5FFAFA5
      A5FFDCD7D7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5F5FFFFF5F5FFFFFF
      FFFFB9B1B1FFE8DCDCFF000000FF000000FFAEB4A4FF12BF49FF1BCD5CFF1ACE
      5CFF9AE9B8FFFFFFFFFFFEFFFFFFFEFFFFFFFFFFFFFF76FFC5FF7AFFC6FFEFFF
      F9FF44D679FF70EFB1FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EFDEE7FFD084B8FFFF92DCFFFF6B
      C1FFFF6DC4FFFFC7E8FFFFFFFFFFFFFFFFFFFFD8FFFFFFC4FFFFFFC4FFFFFFFF
      FFFFFF82D2FFDE96CCFF000000FF000000FFDCC9D0FFC0ADADFFD7CFCFFFB9AF
      AFFFB9AFAFFFE4E0E0FFFFFFFFFFFFFFFFFFFFF8F8FFFFF4F4FFFFF4F4FFFFFF
      FFFFB7ADADFFCEBEBEFF000000FF000000FFB7BAADFF33B55AFF44E78FFF24D2
      67FF21D366FFA9EEC4FFFFFFFFFFFFFFFFFFA4FFD8FF74FFC4FF74FFC4FFFFFF
      FFFF22D469FF50CD7FFF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FFBE6C97FFFDBD
      F6FFFF7DCEFFFF79CAFFFF7DCEFFFFD4EFFFFFFFFFFFFFFFFFFFFFF0FFFFFFFE
      FFFFFF93DEFFCF7EB3FF000000FF000000FF000000FF000000FF947078FFF6EE
      EEFFCAC0C0FFC4BABAFFC5BABAFFECE9E9FFFFFFFFFFFFFFFFFFFFFCFCFFFFFF
      FFFFCBC1C1FFB9A4A4FF000000FF000000FF000000FF000000FF257F27FF71F7
      BBFF37DD7BFF30D974FF32DA76FFB9F3D1FFFFFFFFFFFFFFFFFFDAFFF0FFFDFF
      FEFF3AE082FF39B45AFF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FFF1E1
      E9FFC26EA2FFFFC5FDFFFF90DBFFFF86D4FFFF85D5FFFFAAE2FFFFE7F7FFFFE3
      F6FFFFACEEFFC46EA1FF000000FF000000FF000000FF000000FF000000FFDECD
      D3FFA69091FFFCF5F5FFD8CECEFFCEC4C4FFCDC3C3FFDCD4D4FFF5F3F3FFF3F0
      F0FFE5DBDBFFA58C8FFF000000FF000000FF000000FF000000FF000000FFBDBE
      B4FF2C9F42FF79FEC7FF49E68FFF3CDF81FF34DF7EFF6FE8A4FFD5F9E5FFCCF7
      DFFF5AF0A3FF2B9D3DFF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FFEAD3DEFFC0679DFFFFD1FFFFFFAEEFFFFF95DDFFFF99E0FFFF9A
      E2FFFFBAF7FFC2729FFF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FFD0B8C0FFA48F8FFFFFFFFFFFEEE4E4FFD9CFCFFFDAD0D0FFDAD0
      D0FFF4EAEAFF9C7A82FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FFA2A896FF269F3DFF85FFD5FF64F4AEFF4AE690FF49E691FF48E7
      90FF6CF8B7FF2B8B32FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FFE6C9D7FFC16B9CFFF4BAEFFFFFCDFFFFFFB6
      F4FFFFC2FCFFC2789FFF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FFC8ABB5FF9F8387FFF1E7E7FFFFFCFCFFF2E8
      E8FFFCF2F2FF96727CFF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF939A85FF289539FF71F0B3FF81FFD0FF6AF7
      B4FF76FDC1FF2D7D2BFF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FFD9AFC4FFC172
      9EFFDD96C9FFC57DA2FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FFB18D9AFF9B7C
      83FFCDBFBFFF97707BFF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF6A815CFF2B8B
      34FF50C97FFF32792BFF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00F3FFF3FFF3FF0000F0FFF0FFF0FF0000
      E01FE01FE01F0000E001E001E0010000C001C001C00100008001800180010000
      0001000100010000800180018001000080018001800100000003000300030000
      0003000300030000C003C003C0030000E003E003E0030000F803F803F8030000
      FE03FE03FE030000FFC3FFC3FFC3000000000000000000000000000000000000
      000000000000}
  end
end
