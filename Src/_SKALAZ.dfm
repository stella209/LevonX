object SKALAZASForm: TSKALAZASForm
  Left = 192
  Top = 114
  ActiveControl = ALZ
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'SK'#193'L'#193'Z'#193'S'
  ClientHeight = 512
  ClientWidth = 777
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ALZ: TALZoomImage
    Left = 301
    Top = 0
    Width = 476
    Height = 512
    Align = alClient
    ClipBoardAction = cbaTotal
    BackColor = 6776679
    BackCross = False
    Centered = True
    CentralCross = False
    CircleWindow = False
    CursorCross = False
    EnableFocus = True
    EnableSelect = True
    EnableActions = True
    Fitting = False
    Grid.Fix = False
    Grid.GridDistance = 100.000000000000000000
    Grid.GridPen.Color = clGray
    Grid.SubGridPen.Color = 6250335
    Grid.SubGridDistance = 10.000000000000000000
    Grid.PixelGrid = False
    Grid.Scale = False
    Grid.ScaleFont.Charset = DEFAULT_CHARSET
    Grid.ScaleFont.Color = clWhite
    Grid.ScaleFont.Height = -11
    Grid.ScaleFont.Name = 'Arial'
    Grid.ScaleFont.Style = []
    Grid.ScaleBrush.Color = clGray
    Grid.Visible = False
    OverMove = False
    RGBList.MonoRGB = False
    RGBList.RGB = True
    TabStop = True
    Zoom = 1.000000000000000000
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 301
    Height = 512
    Align = alLeft
    TabOrder = 1
    object SpeedButton1: TSpeedButton
      Left = 191
      Top = 320
      Width = 93
      Height = 22
      Caption = 'Reset'
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 192
      Top = 348
      Width = 93
      Height = 22
      Caption = 'Invers'
      OnClick = SpeedButton2Click
    end
    object Bevel1: TBevel
      Left = 12
      Top = 464
      Width = 273
      Height = 42
      Shape = bsFrame
      Style = bsRaised
    end
    object SpeedButton3: TSpeedButton
      Left = 20
      Top = 347
      Width = 65
      Height = 22
      GroupIndex = 1
      Caption = 'RGB'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton3Click
    end
    object SpeedButton4: TSpeedButton
      Tag = 1
      Left = 91
      Top = 346
      Width = 23
      Height = 22
      GroupIndex = 1
      Caption = 'R'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton3Click
    end
    object SpeedButton5: TSpeedButton
      Tag = 2
      Left = 120
      Top = 346
      Width = 23
      Height = 22
      GroupIndex = 1
      Caption = 'G'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton3Click
    end
    object SpeedButton6: TSpeedButton
      Tag = 3
      Left = 149
      Top = 346
      Width = 23
      Height = 22
      GroupIndex = 1
      Caption = 'B'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton3Click
    end
    object SpeedButton7: TSpeedButton
      Left = 20
      Top = 436
      Width = 199
      Height = 22
      GroupIndex = 1
      Down = True
      Caption = 'Eredeti k'#233'p'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton7Click
    end
    object SpeedButton8: TSpeedButton
      Left = 239
      Top = 436
      Width = 20
      Height = 22
      Hint = 'Total'
      Caption = 'O'
      OnClick = SpeedButton8Click
    end
    object Label1: TLabel
      Left = 12
      Top = 16
      Width = 30
      Height = 13
      Caption = 'Preset'
    end
    object SpeedButton9: TSpeedButton
      Left = 192
      Top = 388
      Width = 93
      Height = 22
      Caption = 'Reset All Chanel'
      OnClick = SpeedButton9Click
    end
    object ALC: TALToneCurve
      Left = 12
      Top = 44
      Width = 272
      Height = 272
      Channel = 0
      Color = clInfoBk
      PresetPath = 'C:\Program Files\Embarcadero\RAD Studio\12.0\bin\Curves\'
      Histogram = True
      LineType = cuvSpline
      OnRepaint = ALCRepaint
    end
    object RadioButton1: TRadioButton
      Left = 48
      Top = 324
      Width = 57
      Height = 17
      Caption = 'Linear'
      TabOrder = 1
      OnClick = RadioButton1Click
    end
    object RadioButton2: TRadioButton
      Left = 108
      Top = 323
      Width = 57
      Height = 17
      Caption = 'Spline'
      Checked = True
      DragKind = dkDock
      TabOrder = 2
      TabStop = True
      OnClick = RadioButton2Click
    end
    object BitBtn1: TBitBtn
      Left = 40
      Top = 474
      Width = 75
      Height = 25
      Caption = 'M'#233'gse'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 3
    end
    object BitBtn2: TBitBtn
      Left = 184
      Top = 474
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
      TabOrder = 4
      TabStop = False
      OnClick = BitBtn2Click
    end
    object PresetCombo: TComboBox
      Left = 52
      Top = 12
      Width = 167
      Height = 21
      TabOrder = 5
      OnChange = PresetComboChange
      OnEnter = PresetComboEnter
    end
    object btnAdd: TButton
      Left = 228
      Top = 8
      Width = 56
      Height = 25
      Caption = 'Ment'#233's'
      TabOrder = 6
      OnClick = btnAddClick
    end
  end
  object janLanguage1: TjanLanguage
    SaveAble = True
    Left = 331
    Top = 180
  end
end
