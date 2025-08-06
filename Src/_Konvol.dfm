object KonvolForm: TKonvolForm
  Left = 0
  Top = 0
  ActiveControl = ALZ
  Caption = 'KONVOL'#211'CI'#211
  ClientHeight = 517
  ClientWidth = 792
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
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 193
    Height = 517
    Align = alLeft
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 9
      Top = 405
      Width = 85
      Height = 22
      Caption = 'Visszavon'
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 100
      Top = 405
      Width = 75
      Height = 22
      Caption = 'Megfelel'
      OnClick = SpeedButton2Click
    end
    object Bevel1: TBevel
      Left = 9
      Top = 464
      Width = 173
      Height = 42
      Shape = bsFrame
      Style = bsRaised
    end
    object SpeedButton4: TSpeedButton
      Left = 155
      Top = 436
      Width = 20
      Height = 22
      Caption = 'O'
      OnClick = SpeedButton4Click
    end
    object BitBtn1: TBitBtn
      Left = 19
      Top = 474
      Width = 75
      Height = 25
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 100
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
      TabOrder = 1
      TabStop = False
      OnClick = BitBtn2Click
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 191
      Height = 28
      Align = alTop
      Caption = 'FILTERS'
      Color = clGray
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 2
    end
    object Button10: TButton
      Tag = 8
      Left = 10
      Top = 436
      Width = 135
      Height = 22
      Caption = 'Eredeti k'#233'p'
      TabOrder = 3
      OnClick = Button10Click
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 218
      Width = 174
      Height = 181
      Caption = 'Threshold'
      TabOrder = 4
      object SpinEdit2: TSpinEdit
        Left = 52
        Top = 121
        Width = 49
        Height = 22
        MaxValue = 255
        MinValue = 0
        TabOrder = 0
        Value = 128
      end
      object Button11: TButton
        Left = 18
        Top = 149
        Width = 113
        Height = 25
        Caption = 'Threshold'
        TabOrder = 1
        OnClick = Button11Click
      end
      object RadioButton1: TRadioButton
        Left = 52
        Top = 18
        Width = 57
        Height = 17
        Caption = 'Intensity'
        Checked = True
        TabOrder = 2
        TabStop = True
      end
      object RadioButton2: TRadioButton
        Left = 52
        Top = 39
        Width = 73
        Height = 12
        Caption = 'Saturation'
        TabOrder = 3
      end
      object RadioButton3: TRadioButton
        Left = 52
        Top = 56
        Width = 41
        Height = 17
        Caption = 'Red'
        TabOrder = 4
      end
      object RadioButton4: TRadioButton
        Left = 52
        Top = 76
        Width = 49
        Height = 17
        Caption = 'Green'
        TabOrder = 5
      end
      object RadioButton5: TRadioButton
        Left = 52
        Top = 95
        Width = 41
        Height = 17
        Caption = 'Blue'
        TabOrder = 6
      end
    end
    object GroupBox1: TGroupBox
      Left = 10
      Top = 61
      Width = 172
      Height = 159
      Caption = 'Convolution Mask'
      TabOrder = 5
      object Label1: TLabel
        Left = 38
        Top = 94
        Width = 19
        Height = 13
        Caption = 'Bias'
      end
      object Label2: TLabel
        Left = 116
        Top = 96
        Width = 37
        Height = 10
        Caption = '(-255..255)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Edit1: TEdit
        Left = 16
        Top = 24
        Width = 49
        Height = 21
        TabOrder = 0
        Text = 'Edit1'
        StyleElements = [seFont, seBorder]
        OnChange = Edit1Change
      end
      object Edit2: TEdit
        Left = 64
        Top = 24
        Width = 49
        Height = 21
        TabOrder = 1
        Text = 'Edit2'
        StyleElements = [seFont, seBorder]
        OnChange = Edit1Change
      end
      object Edit3: TEdit
        Left = 110
        Top = 24
        Width = 49
        Height = 21
        TabOrder = 2
        Text = 'Edit3'
        StyleElements = [seFont, seBorder]
        OnChange = Edit1Change
      end
      object Edit4: TEdit
        Left = 16
        Top = 46
        Width = 49
        Height = 21
        TabOrder = 3
        Text = 'Edit4'
        StyleElements = [seFont, seBorder]
        OnChange = Edit1Change
      end
      object Edit5: TEdit
        Left = 64
        Top = 46
        Width = 49
        Height = 21
        TabOrder = 4
        Text = 'Edit5'
        StyleElements = [seFont, seBorder]
        OnChange = Edit1Change
      end
      object Edit6: TEdit
        Left = 110
        Top = 46
        Width = 49
        Height = 21
        TabOrder = 5
        Text = 'Edit6'
        StyleElements = [seFont, seBorder]
        OnChange = Edit1Change
      end
      object Edit7: TEdit
        Left = 16
        Top = 67
        Width = 49
        Height = 21
        TabOrder = 6
        Text = 'Edit7'
        StyleElements = [seFont, seBorder]
        OnChange = Edit1Change
      end
      object Edit8: TEdit
        Left = 64
        Top = 67
        Width = 49
        Height = 21
        TabOrder = 7
        Text = 'Edit8'
        StyleElements = [seFont, seBorder]
        OnChange = Edit1Change
      end
      object Edit9: TEdit
        Left = 110
        Top = 67
        Width = 49
        Height = 21
        TabOrder = 8
        Text = 'Edit9'
        StyleElements = [seFont, seBorder]
        OnChange = Edit1Change
      end
      object Edit10: TEdit
        Left = 63
        Top = 91
        Width = 49
        Height = 21
        TabOrder = 9
        Text = 'Edit10'
        StyleElements = [seFont, seBorder]
        OnChange = Edit1Change
      end
      object ConvolvButton: TButton
        Left = 16
        Top = 118
        Width = 143
        Height = 25
        Caption = 'Convolve'
        TabOrder = 10
        OnClick = ConvolvButtonClick
      end
    end
    object ComboBox1: TComboBox
      Left = 12
      Top = 34
      Width = 170
      Height = 21
      Color = clInfoBk
      DropDownCount = 10
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ItemIndex = 10
      ParentFont = False
      TabOrder = 6
      Text = 'Photometric LowPass'
      OnSelect = ComboBox1Select
      Items.Strings = (
        'Uniform Smoothing'
        'Gaussian Smoothing'
        'Edge Detection'
        'Vertical Edge Detection'
        'Horizontal Edge Detection'
        'Enhanced Detail'
        'Enhanced Focus'
        'Emboss Filter'
        'Lighten'
        'Darken'
        'Photometric LowPass')
    end
  end
  object Panel3: TPanel
    Left = 193
    Top = 0
    Width = 599
    Height = 517
    Align = alClient
    Caption = 'Panel3'
    TabOrder = 1
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 597
      Height = 28
      Align = alTop
      TabOrder = 0
      object Button2: TButton
        Left = 5
        Top = 1
        Width = 62
        Height = 25
        Caption = 'Laplace'
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button3: TButton
        Tag = 1
        Left = 69
        Top = 1
        Width = 67
        Height = 25
        Caption = 'Hipass'
        TabOrder = 1
        OnClick = Button1Click
      end
      object Button4: TButton
        Tag = 2
        Left = 136
        Top = 1
        Width = 74
        Height = 25
        Caption = 'Find Edges'
        TabOrder = 2
        OnClick = Button1Click
      end
      object Button5: TButton
        Tag = 3
        Left = 210
        Top = 1
        Width = 68
        Height = 25
        Caption = 'Sharpen'
        TabOrder = 3
        OnClick = Button1Click
      end
      object Button6: TButton
        Tag = 4
        Left = 278
        Top = 1
        Width = 82
        Height = 25
        Caption = 'Edge Enhance'
        TabOrder = 4
        OnClick = Button1Click
      end
      object Button7: TButton
        Tag = 5
        Left = 361
        Top = 1
        Width = 78
        Height = 25
        Caption = 'Color Emboss'
        TabOrder = 5
        OnClick = Button1Click
      end
      object Button8: TButton
        Tag = 6
        Left = 440
        Top = 1
        Width = 69
        Height = 25
        Caption = 'Soften'
        TabOrder = 6
        OnClick = Button1Click
      end
      object Button9: TButton
        Tag = 7
        Left = 510
        Top = 1
        Width = 83
        Height = 25
        Caption = 'Blur'
        TabOrder = 7
        OnClick = Button1Click
      end
    end
    object ALZ: TALZoomImage
      Left = 1
      Top = 29
      Width = 597
      Height = 487
      Align = alClient
      ClipBoardAction = cbaTotal
      BackColor = 6776679
      BackCross = False
      Centered = False
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
  end
  object janLanguage1: TjanLanguage
    SaveAble = True
    Left = 307
    Top = 180
  end
end
