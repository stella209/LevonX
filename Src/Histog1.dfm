object HistogramForm: THistogramForm
  Left = 161
  Top = 117
  ActiveControl = Button4
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'HISTOGRAMM'
  ClientHeight = 511
  ClientWidth = 827
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    AlignWithMargins = True
    Left = 6
    Top = 44
    Width = 379
    Height = 283
    Center = True
    OnMouseMove = Image1MouseMove
  end
  object Label4: TLabel
    Left = 10
    Top = 338
    Width = 8
    Height = 13
    Caption = 'R'
  end
  object Label5: TLabel
    Left = 9
    Top = 372
    Width = 8
    Height = 13
    Caption = 'G'
  end
  object Label6: TLabel
    Left = 9
    Top = 407
    Width = 7
    Height = 13
    Caption = 'B'
  end
  object Label7: TLabel
    Left = 396
    Top = 344
    Width = 41
    Height = 13
    Caption = 'F'#233'nyer'#337':'
  end
  object Label8: TLabel
    Left = 396
    Top = 375
    Width = 44
    Height = 13
    Caption = 'Kontraszt'
  end
  object Label9: TLabel
    Left = 396
    Top = 408
    Width = 51
    Height = 13
    Caption = 'Satura'#225'ci'#243
  end
  object Label10: TLabel
    Left = 396
    Top = 440
    Width = 39
    Height = 13
    Caption = 'Gamma:'
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 827
    Height = 33
    Align = alTop
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 8
      Top = 4
      Width = 61
      Height = 22
      Hint = 'Open Picture'
      Caption = 'Bet'#246'lt'#233's'
      Visible = False
      OnClick = SpeedButton1Click
    end
    object SpeedButton4: TSpeedButton
      Left = 80
      Top = 4
      Width = 101
      Height = 22
      Hint = 'Original Picture'
      Caption = 'Eredeti k'#233'p'
      OnClick = SpeedButton4Click
    end
    object CheckBox1: TCheckBox
      Left = 439
      Top = 7
      Width = 33
      Height = 17
      Caption = 'R'
      TabOrder = 0
      OnClick = CheckBox4Click
    end
    object CheckBox2: TCheckBox
      Tag = 1
      Left = 469
      Top = 7
      Width = 29
      Height = 17
      Caption = 'G'
      TabOrder = 1
      OnClick = CheckBox4Click
    end
    object CheckBox3: TCheckBox
      Tag = 2
      Left = 500
      Top = 7
      Width = 29
      Height = 17
      Caption = 'B'
      TabOrder = 2
      OnClick = CheckBox4Click
    end
    object CheckBox4: TCheckBox
      Tag = 3
      Left = 538
      Top = 7
      Width = 69
      Height = 17
      Caption = 'Intenzit'#225's'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = CheckBox4Click
    end
    object Button4: TButton
      Left = 196
      Top = 4
      Width = 101
      Height = 23
      Caption = 'Alaphelyzet'
      TabOrder = 4
      OnClick = Button4Click
    end
  end
  object Chart1: TChart
    Left = 394
    Top = 42
    Width = 421
    Height = 285
    BackWall.Brush.Style = bsClear
    Title.Text.Strings = (
      'Histogram')
    BottomAxis.LabelsFormat.TextAlignment = taCenter
    DepthAxis.LabelsFormat.TextAlignment = taCenter
    DepthTopAxis.LabelsFormat.TextAlignment = taCenter
    LeftAxis.LabelsFormat.TextAlignment = taCenter
    RightAxis.LabelsFormat.TextAlignment = taCenter
    TopAxis.LabelsFormat.TextAlignment = taCenter
    View3D = False
    View3DWalls = False
    Zoom.Animated = True
    Zoom.Pen.Mode = pmNotXor
    TabOrder = 1
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object Series1: TLineSeries
      Marks.Visible = False
      SeriesColor = clRed
      Title = 'R'
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series2: TLineSeries
      Marks.Visible = False
      SeriesColor = clGreen
      Title = 'G'
      Brush.BackColor = clDefault
      LinePen.Width = 2
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series3: TLineSeries
      Marks.Visible = False
      SeriesColor = 16744448
      Title = 'B'
      Brush.BackColor = clDefault
      LinePen.Width = 2
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object TR0: TTrackBar
    Left = 26
    Top = 335
    Width = 300
    Height = 33
    Max = 255
    Min = -255
    Frequency = 10
    SelEnd = 2
    SelStart = -2
    TabOrder = 2
    OnChange = TR0Change
    OnKeyDown = TR0KeyDown
  end
  object TR1: TTrackBar
    Tag = 1
    Left = 26
    Top = 368
    Width = 300
    Height = 33
    Max = 255
    Min = -255
    Frequency = 10
    SelEnd = 2
    SelStart = -2
    TabOrder = 3
    OnChange = TR0Change
    OnKeyDown = TR0KeyDown
  end
  object TR2: TTrackBar
    Tag = 2
    Left = 26
    Top = 402
    Width = 300
    Height = 33
    Max = 255
    Min = -255
    Frequency = 10
    SelEnd = 2
    SelStart = -2
    TabOrder = 4
    OnChange = TR0Change
    OnKeyDown = TR0KeyDown
  end
  object TR3: TTrackBar
    Tag = 3
    Left = 450
    Top = 338
    Width = 312
    Height = 33
    Max = 255
    Min = -255
    Frequency = 10
    SelEnd = 2
    SelStart = -2
    TabOrder = 5
    OnChange = TR0Change
    OnKeyDown = TR0KeyDown
  end
  object TR4: TTrackBar
    Tag = 4
    Left = 450
    Top = 370
    Width = 312
    Height = 33
    Max = 255
    Min = -255
    Frequency = 10
    SelEnd = 2
    SelStart = -2
    TabOrder = 6
    OnChange = TR0Change
    OnKeyDown = TR0KeyDown
  end
  object TR5: TTrackBar
    Tag = 5
    Left = 450
    Top = 402
    Width = 312
    Height = 33
    Max = 255
    Min = -255
    Frequency = 10
    SelEnd = 2
    SelStart = -2
    TabOrder = 7
    OnChange = TR0Change
    OnKeyDown = TR0KeyDown
  end
  object RGBCheck: TCheckBox
    Left = 24
    Top = 440
    Width = 97
    Height = 17
    Caption = 'RGB egy'#252'tt'
    TabOrder = 8
  end
  object TR6: TTrackBar
    Tag = 6
    Left = 450
    Top = 435
    Width = 312
    Height = 33
    Max = 60
    Min = -10
    Frequency = 10
    SelEnd = 1
    SelStart = -1
    TabOrder = 9
    OnChange = TR0Change
    OnKeyDown = TR0KeyDown
  end
  object Ed0: TEdit
    Left = 332
    Top = 336
    Width = 37
    Height = 21
    Hint = 'Enter'
    TabOrder = 10
    Text = '0'
    OnKeyDown = Ed0KeyDown
  end
  object Ed1: TEdit
    Tag = 1
    Left = 332
    Top = 368
    Width = 37
    Height = 21
    Hint = 'Enter'
    TabOrder = 11
    Text = '0'
    OnKeyDown = Ed0KeyDown
  end
  object Ed2: TEdit
    Tag = 2
    Left = 332
    Top = 400
    Width = 37
    Height = 21
    Hint = 'Enter'
    TabOrder = 12
    Text = '0'
    OnKeyDown = Ed0KeyDown
  end
  object Ed3: TEdit
    Tag = 3
    Left = 772
    Top = 340
    Width = 37
    Height = 21
    Hint = 'Enter'
    TabOrder = 13
    Text = '0'
    OnKeyDown = Ed0KeyDown
  end
  object Ed4: TEdit
    Tag = 4
    Left = 772
    Top = 372
    Width = 37
    Height = 21
    Hint = 'Enter'
    TabOrder = 14
    Text = '0'
    OnKeyDown = Ed0KeyDown
  end
  object Ed5: TEdit
    Tag = 5
    Left = 772
    Top = 404
    Width = 37
    Height = 21
    Hint = 'Enter'
    TabOrder = 15
    Text = '0'
    OnKeyDown = Ed0KeyDown
  end
  object Ed6: TEdit
    Tag = 6
    Left = 772
    Top = 436
    Width = 37
    Height = 21
    Hint = 'Enter'
    TabOrder = 16
    Text = '0'
    OnKeyDown = Ed0KeyDown
  end
  object CheckBox5: TCheckBox
    Left = 128
    Top = 440
    Width = 77
    Height = 17
    Caption = 'Monokr'#243'm'
    TabOrder = 17
    OnClick = CheckBox5Click
  end
  object CheckBox6: TCheckBox
    Left = 212
    Top = 440
    Width = 97
    Height = 17
    Caption = 'Inverz'
    TabOrder = 18
    OnClick = CheckBox6Click
  end
  object Panel2: TPanel
    Left = 0
    Top = 470
    Width = 827
    Height = 41
    Align = alBottom
    BevelOuter = bvLowered
    BevelWidth = 2
    TabOrder = 19
    object sbtnCancel: TSpeedButton
      Left = 288
      Top = 8
      Width = 97
      Height = 28
      Caption = 'M'#233'gsem'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Glyph.Data = {
        36080000424D3608000000000000360000002800000020000000100000000100
        2000000000000008000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF0000009900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF000000FF00FF00FF00FF00FF00FF00
        FF00FF00FF0099999900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00CCCCCC00FF00FF00FF00FF00FF00
        FF003333CC000000FF0000009900FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF0099999900CCCCCC0099999900FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF003333CC003399FF000000FF0000009900FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF000000FF00FF00FF00FF00FF00FF00FF00FF00
        FF0099999900E5E5E500CCCCCC0099999900FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00CCCCCC00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF003333CC000066FF000000CC00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF0099999900E5E5E50099999900FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00CCCCCC00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF000000CC000000FF0000009900FF00FF00FF00FF00FF00
        FF00FF00FF000000FF0000009900FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF0099999900CCCCCC0099999900FF00FF00FF00FF00FF00
        FF00FF00FF00CCCCCC0099999900FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF000000CC000000FF0000009900FF00FF00FF00
        FF000000FF0000009900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF0099999900CCCCCC0099999900FF00FF00FF00
        FF00CCCCCC0099999900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF000000CC000000FF00000099000000
        FF0000009900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF0099999900CCCCCC0099999900CCCC
        CC0099999900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000CC000000FF000000
        9900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0099999900CCCCCC009999
        9900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF000000CC000000FF00000099000000
        CC0000009900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF0099999900CCCCCC00999999009999
        990099999900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF000000CC000000FF0000009900FF00FF00FF00
        FF000000CC0000009900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF0099999900CCCCCC0099999900FF00FF00FF00
        FF009999990099999900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF000000CC000000FF000000FF0000009900FF00FF00FF00FF00FF00
        FF00FF00FF000000CC0000009900FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF0099999900CCCCCC00CCCCCC0099999900FF00FF00FF00FF00FF00
        FF00FF00FF009999990099999900FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF000000CC003399FF000000FF0000009900FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF000000CC0000009900FF00FF00FF00FF00FF00FF00FF00
        FF0099999900E5E5E500CCCCCC0099999900FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF009999990099999900FF00FF00FF00FF00FF00FF00FF00
        FF00666699000000CC0066669900FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF000000CC00FF00FF00FF00FF00FF00
        FF00CCCCCC0099999900CCCCCC00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF0099999900FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      NumGlyphs = 2
      ParentFont = False
      OnClick = sbtnCancelClick
    end
    object sbtnOk: TSpeedButton
      Left = 396
      Top = 8
      Width = 97
      Height = 28
      Caption = 'Ok'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        555555555555555555555555555555555555555555FF55555555555559055555
        55555555577FF5555555555599905555555555557777F5555555555599905555
        555555557777FF5555555559999905555555555777777F555555559999990555
        5555557777777FF5555557990599905555555777757777F55555790555599055
        55557775555777FF5555555555599905555555555557777F5555555555559905
        555555555555777FF5555555555559905555555555555777FF55555555555579
        05555555555555777FF5555555555557905555555555555777FF555555555555
        5990555555555555577755555555555555555555555555555555}
      NumGlyphs = 2
      ParentFont = False
      OnClick = sbtnOkClick
    end
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 24
    Top = 72
  end
  object janLanguage1: TjanLanguage
    SaveAble = True
    Left = 307
    Top = 180
  end
end
