object MaszkForm: TMaszkForm
  Left = 0
  Top = 0
  ActiveControl = ALZ
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Maszkol'#225's'
  ClientHeight = 572
  ClientWidth = 894
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 217
    Height = 572
    Align = alLeft
    TabOrder = 0
    object Bevel1: TBevel
      Left = 7
      Top = 519
      Width = 202
      Height = 42
      Shape = bsFrame
      Style = bsRaised
    end
    object SpeedButton7: TSpeedButton
      Left = 19
      Top = 491
      Width = 151
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
    object Label1: TLabel
      Left = 7
      Top = 37
      Width = 75
      Height = 13
      Caption = 'Gauss-elmos'#225's:'
    end
    object ParLabel: TLabel
      Left = 178
      Top = 51
      Width = 33
      Height = 20
      Alignment = taCenter
      AutoSize = False
      Caption = '2'
      Color = clBlack
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
      StyleElements = [seBorder]
    end
    object Image1: TImage
      Left = 16
      Top = 180
      Width = 180
      Height = 117
      Stretch = True
    end
    object Image2: TImage
      Left = 16
      Top = 332
      Width = 180
      Height = 117
      Stretch = True
    end
    object Label2: TLabel
      Left = 16
      Top = 160
      Width = 76
      Height = 13
      Caption = 'T'#250'lexpon'#225'lt k'#233'p'
    end
    object Label3: TLabel
      Left = 16
      Top = 312
      Width = 79
      Height = 13
      Caption = 'Alulexpon'#225'lt k'#233'p'
    end
    object SpeedButton1: TSpeedButton
      Tag = 1
      Left = 102
      Top = 154
      Width = 65
      Height = 22
      Caption = 'Megnyit'#225's'
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Tag = 2
      Left = 98
      Top = 307
      Width = 69
      Height = 22
      Caption = 'Megnyit'#225's'
      OnClick = SpeedButton1Click
    end
    object Label4: TLabel
      Left = 8
      Top = 88
      Width = 11
      Height = 13
      Caption = 'N:'
    end
    object SpeedButton4: TSpeedButton
      Left = 176
      Top = 491
      Width = 20
      Height = 22
      Caption = 'O'
      OnClick = SpeedButton4Click
    end
    object RzToolButton1: TRzToolButton
      Left = 170
      Top = 154
      Hint = 'Paste'
      ImageIndex = 2
      Images = MainForm.ImageList1
      OnClick = RzToolButton1Click
    end
    object RzToolButton2: TRzToolButton
      Left = 170
      Top = 306
      Hint = 'Paste'
      ImageIndex = 2
      Images = MainForm.ImageList1
      OnClick = RzToolButton2Click
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 215
      Height = 28
      Align = alTop
      Caption = 'UNSHARP - '#201'letlen Maszk'
      Color = clGray
      Font.Charset = ANSI_CHARSET
      Font.Color = clYellow
      Font.Height = -13
      Font.Name = 'Arial Rounded MT Bold'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      StyleElements = [seBorder]
    end
    object BitBtn1: TBitBtn
      Left = 19
      Top = 529
      Width = 75
      Height = 25
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
    object BitBtn2: TBitBtn
      Left = 121
      Top = 529
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
      TabOrder = 2
      TabStop = False
      OnClick = BitBtn2Click
    end
    object Panel3: TPanel
      Left = -1
      Top = 116
      Width = 216
      Height = 28
      Caption = 'Intezit'#225's Maszk'
      Color = clGray
      Font.Charset = ANSI_CHARSET
      Font.Color = clYellow
      Font.Height = -13
      Font.Name = 'Arial Rounded MT Bold'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 3
      StyleElements = [seBorder]
    end
    object tbBlur: TTrackBar
      Left = 0
      Top = 51
      Width = 176
      Height = 31
      Position = 2
      PositionToolTip = ptTop
      TabOrder = 4
      OnChange = tbBlurChange
    end
    object Button1: TButton
      Left = 134
      Top = 85
      Width = 75
      Height = 25
      Caption = 'Ok'
      TabOrder = 5
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 121
      Top = 455
      Width = 75
      Height = 25
      Caption = 'Precess...'
      TabOrder = 6
      OnClick = Button2Click
    end
    object NSpin: TSpinEdit
      Left = 30
      Top = 84
      Width = 45
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 7
      Value = 2
    end
    object Button3: TButton
      Left = 16
      Top = 455
      Width = 75
      Height = 25
      Caption = 'Clear'
      TabOrder = 8
      OnClick = Button3Click
    end
  end
  object Panel5: TPanel
    Left = 217
    Top = 0
    Width = 677
    Height = 572
    Align = alClient
    Caption = 'Panel5'
    TabOrder = 1
    object ALZ: TALZoomImage
      Left = 1
      Top = 1
      Width = 675
      Height = 518
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
      Zoom = 0.830470224985128100
    end
    object PosPanel: TPanel
      Left = 1
      Top = 519
      Width = 675
      Height = 52
      Align = alBottom
      Alignment = taLeftJustify
      BevelInner = bvRaised
      BevelWidth = 4
      BorderStyle = bsSingle
      Caption = '  Intensity Level :'
      TabOrder = 0
      Visible = False
      object MixLabel: TLabel
        Left = 560
        Top = 15
        Width = 65
        Height = 20
        Alignment = taCenter
        AutoSize = False
        Caption = '1.0'
        Color = clBlack
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = False
        StyleElements = [seBorder]
      end
      object SpeedButton3: TSpeedButton
        Left = 634
        Top = 13
        Width = 23
        Height = 22
        Caption = 'x'
        OnClick = SpeedButton3Click
      end
      object TrackBar1: TTrackBar
        Left = 104
        Top = 11
        Width = 450
        Height = 28
        Max = 100
        Position = 50
        TabOrder = 0
        OnChange = TrackBar1Change
      end
    end
  end
  object janLanguage1: TjanLanguage
    SaveAble = True
    Left = 248
    Top = 144
  end
  object OD: TOpenPictureDialog
    Filter = 
      'K'#233'pek|*.bmp;*.jpg; *.cr2;*.tif;*,tiff;*.gif;*.png;*.fit;*.fits|C' +
      'anon RAW|*.cr2|TIF|*.tif; *.tiff|Windows Bitmap|*.bmp|GIF|*.gif|' +
      'Protanle Network Graphic|*.png|FITS |*.fit;*.fits'
    Left = 248
    Top = 224
  end
end
