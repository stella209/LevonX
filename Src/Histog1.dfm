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
    object BitBtn1: TBitBtn
      Left = 296
      Top = 8
      Width = 75
      Height = 25
      Caption = 'M'#233'gse'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 400
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
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
      TabOrder = 1
      TabStop = False
      OnClick = BitBtn2Click
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
