object FlatForm: TFlatForm
  Left = 0
  Top = 0
  ActiveControl = ALZ
  BorderIcons = [biSystemMenu, biHelp]
  Caption = 'Manu'#225'lis Flat Korrekci'#243
  ClientHeight = 562
  ClientWidth = 884
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnHelp = FormHelp
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 257
    Height = 562
    Align = alLeft
    TabOrder = 0
    object Bevel1: TBevel
      Left = 12
      Top = 508
      Width = 231
      Height = 42
      Shape = bsFrame
      Style = bsRaised
    end
    object SpeedButton7: TSpeedButton
      Left = 12
      Top = 481
      Width = 181
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
    object QImage: TImage
      Left = 12
      Top = 327
      Width = 231
      Height = 149
      Center = True
      Stretch = True
    end
    object GrImage: TImage
      Left = 41
      Top = 36
      Width = 202
      Height = 261
    end
    object RLabel: TLabel
      Left = 80
      Top = 44
      Width = 129
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'R=0'
    end
    object Label1: TLabel
      Left = 8
      Top = 12
      Width = 33
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = '0'
      Color = clBlack
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clYellow
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
      StyleElements = [seBorder]
    end
    object SpeedButton4: TSpeedButton
      Left = 223
      Top = 480
      Width = 20
      Height = 22
      Caption = 'O'
      OnClick = SpeedButton4Click
    end
    object BitBtn1: TBitBtn
      Left = 24
      Top = 518
      Width = 75
      Height = 25
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 156
      Top = 518
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
    object TrackBar1: TTrackBar
      Left = 12
      Top = 28
      Width = 23
      Height = 277
      Max = 128
      Min = -128
      Orientation = trVertical
      TabOrder = 2
      OnChange = TrackBar1Change
    end
    object Button1: TButton
      Left = 112
      Top = 304
      Width = 131
      Height = 17
      Caption = 'Virtual Flat korrekci'#243
      TabOrder = 3
      OnClick = Button1Click
    end
    object SpeBlur: TSpinEdit
      Left = 41
      Top = 300
      Width = 48
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 4
      Value = 2
    end
  end
  object ALZ: TALZoomImage
    Left = 257
    Top = 0
    Width = 627
    Height = 562
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
    Fitting = True
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
    Zoom = 0.623944571739390000
  end
  object janLanguage1: TjanLanguage
    Left = 307
    Top = 180
  end
end
