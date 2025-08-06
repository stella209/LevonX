object MainForm: TMainForm
  Left = 192
  Top = 124
  Caption = 
    'LEVON (CR2/CRW,JPG,BMP,TIF) - Automatikus H'#225'tt'#233'rzaj Levon'#225'st sze' +
    'ml'#233'ltet'#337' teszt program (Ag'#243'cs L'#225'szl'#243' 2017)'
  ClientHeight = 514
  ClientWidth = 724
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 724
    Height = 41
    Align = alTop
    ParentBackground = False
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 444
      Top = 8
      Width = 65
      Height = 22
      GroupIndex = 1
      Down = True
      Caption = 'RGB'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Tag = 1
      Left = 516
      Top = 8
      Width = 23
      Height = 22
      Caption = 'R'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton2Click
    end
    object SpeedButton3: TSpeedButton
      Tag = 2
      Left = 540
      Top = 8
      Width = 23
      Height = 22
      Caption = 'G'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton2Click
    end
    object SpeedButton4: TSpeedButton
      Tag = 3
      Left = 564
      Top = 8
      Width = 23
      Height = 22
      Caption = 'B'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton2Click
    end
    object MonoButton: TSpeedButton
      Left = 593
      Top = 8
      Width = 65
      Height = 22
      GroupIndex = 1
      Caption = 'Mono'
      OnClick = MonoButtonClick
    end
    object SpeedButton5: TSpeedButton
      Left = 664
      Top = 8
      Width = 23
      Height = 22
      Hint = 'Undo=Visszavon'
      Glyph.Data = {
        36050000424D3605000000000000360400002800000010000000100000000100
        0800000000000001000000000000000000000001000000010000000000000101
        0100020202000303030004040400050505000606060007070700080808000909
        09000A0A0A000B0B0B000C0C0C000D0D0D000E0E0E000F0F0F00101010001111
        1100121212001313130014141400151515001616160017171700181818001919
        19001A1A1A001B1B1B001C1C1C001D1D1D001E1E1E001F1F1F00202020002121
        2100222222002323230024242400252525002626260027272700282828002929
        29002A2A2A002B2B2B002C2C2C002D2D2D002E2E2E002F2F2F00303030003131
        3100323232003333330034343400353535003636360037373700383838003939
        39003A3A3A003B3B3B003C3C3C003D3D3D003E3E3E003F3F3F00404040004141
        4100424242004343430044444400454545004646460047474700484848004949
        490055455500614161007549750094639000AC79A400C383B700D389C600E473
        D800EF5DE400F54BEC00F83BF100FB2EF500FC21F800FD11FB00FE09FD00FE04
        FE00FE01FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
        FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
        FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE01FE00FE02
        FE00FE05FD00FE08FD00FE0FFB00FD16FA00FC21F800FB2EF500F93CF200F64C
        ED00F260E700EA78DD00DD93D000D192C600C28EB900B180AD009D719D009071
        9000897989008383830084848400858585008686860087878700888888008989
        89008A8A8A008B8B8B008C8C8C008D8D8D008E8E8E008F8F8F00909090009191
        9100929292009393930094949400959595009696960097979700989898009999
        99009A9A9A009B9B9B009C9C9C009D9D9D009E9E9E009F9F9F00A0A0A000A1A1
        A100A2A2A200A3A3A300A4A4A400A5A5A500A6A6A600A7A7A700A8A8A800A9A9
        A900AAAAAA00ABABAB00ACACAC00ADADAD00AEAEAE00AFAFAF00B0B0B000B1B1
        B100B2B2B200B3B3B300B4B4B400B9B9B900C1C0BF00C8C6C400CFCBC800D9D4
        D000E2DDD800E8E3DE00EFEAE500F3EFEA00F7F2EE00F9F5F100FBF7F400FAF6
        F100FAF4EF00F9F2EA00F8EDE200F7EADC00F6E5D400F5E2CF00F4DFC900F2DA
        C200F1D6BB00F0D3B500EFD0B100EDCDAC00ECC9A700EBC7A200EAC49E00E8BF
        9600E7BB8E00E6B98B00E5B58400E3AE7900DFA66D00DC9E6000DB9B5C00D894
        5100D58E4700D2883E00D0823300CE7D2C00CC782300CA741D00C9711800C96E
        1400C86B0E00C76A0C00C7680800C7660600C8650400C8650200C9650100C965
        0000C9640000C9640000C6630100C3610300BE5F0600B75D0D00B25C1100AE5A
        1200AB571100A8551200A4531400A15115009D4F1700994D1900934A1C008E48
        1E008A46200086432200854323008342230083422300844223006565656565FD
        FDFDFDFDFD6565656565656565FDFDE9E9E9E9E9E9FDFD6565656565F6EDE9E9
        E9E9E9E9E9E9ECFD656565F7EDEAECECECECEAEBE9E9E9ECFD6565EEECEDEDEE
        DBD9D8DADEE9E9E9FD65F3E4E4E4E5EDD0C0C0C0C0D8E9E9E9FDF2E1E0E0E0E0
        E0E0E0DFD3C0E9E9E9FDF2DCDDDDDDDDCDE0E3EEE1C0E9E9E9FDF1D7D9DBDACC
        C0DDE0E4D8C0E9E9E9FDF2D4D5D9C8C0C0C4C7C8C0D3E9E9E9FDF3D4CBD5C7C0
        C0C7CDCFD7ECE9E9E9FD65F1C9C9D2CAC0DADCDEE1E6E9E9FD6565F3D4C6C8D2
        CCDADCDEE0E4E9ECFD656565F2D3C8C6CCD3D6D7DAE1ECF96565656565F2F0D2
        CECED2D7DDF0FA6565656565656565F1F0F0F0F1F66565656565}
      OnClick = SpeedButton5Click
    end
    object SpeedButton6: TSpeedButton
      Left = 689
      Top = 8
      Width = 23
      Height = 22
      Hint = 'Redo'
      Glyph.Data = {
        36050000424D3605000000000000360400002800000010000000100000000100
        0800000000000001000000000000000000000001000000010000000000000101
        0100020202000303030004040400050505000606060007070700080808000909
        09000A0A0A000B0B0B000C0C0C000D0D0D000E0E0E000F0F0F00101010001111
        1100121212001313130014141400151515001616160017171700181818001919
        19001A1A1A001B1B1B001C1C1C001D1D1D001E1E1E001F1F1F00202020002121
        2100222222002323230024242400252525002626260027272700282828002929
        29002A2A2A002B2B2B002C2C2C002D2D2D002E2E2E002F2F2F00303030003131
        3100323232003333330034343400353535003636360037373700383838003939
        39003A3A3A003B3B3B003C3C3C003D3D3D003E3E3E003F3F3F00404040004141
        4100424242004343430044444400454545004646460047474700484848004949
        490055455500614161006C3E6C00773A77008137810092309200A12AA100BC1E
        BC00D314D300E30DE300F007F000F704F700FB02FB00FD01FD00FE00FE00FE00
        FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
        FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
        FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
        FE00FD01FD00FC01FC00FB03FB00F904F900F607F600F30AF300ED0FED00E616
        E600DB20DB00CC2ECC00B942B900AE4DAE00A359A3009D609D00976897009071
        9000897989008383830084848400858585008686860087878700888888008989
        89008A8A8A008B8B8B008C8C8C008D8D8D008E8E8E008F8F8F00909090009191
        9100929292009393930094949400959595009696960097979700989898009999
        99009A9A9A009B9B9B009C9C9C009D9D9D009E9E9E009F9F9F00A0A0A000A1A1
        A100A2A2A200A3A3A300A4A4A400A5A5A500A6A6A600A7A7A700A8A8A800A9A9
        A900AAAAAA00ABABAB00ACACAC00ADADAD00AEAEAE00AFAFAF00B0B0B000B1B1
        B100B2B2B200B3B3B300B4B4B400B5B5B500B6B6B600B7B7B700B8B8B800B9B9
        B900BABABA00BBBBBB00BCBCBC00BDBDBD00BEBEBE00BFBFBF00C3C3C300C8C8
        C800CFCFCF00DADADA00E2E2E200EAEAEA00EFEFEF00F4F4F400F7F7F700FAF9
        F900FBFAF900FBF8F500FAF6F100F9F1E900F7EADD00F6E5D300F5E1CD00F4DF
        C900F3DCC400F2D9C000F1D5B900EECFAF00ECCAA700EBC6A100E9C39B00E9C0
        9600E8BC8F00E7B98A00E5B58300E4B17D00E2AD7700E0A76D00DEA26500DC9E
        5F00DB9B5A00D9965200D58D4500D2863A00D0813100CE7B2800CB741D00CB70
        1500CA6C0D00C9680600CA660200C9660100C9650000C9640100C7630100C662
        0100C3600200C15F0400BD5F0800B85E0C00B25B1000AC571100A7541200A051
        16009A4E1800934A1B008E471E008844210085432200854322006464646464FE
        FEFEFEFEFE6464646464646464FEFEEDEDEDEDEDEDFEFE6464646464FAF1EEEE
        EEEEEEEDEDEDF0FE646464FAF1F0F1F1F1F1F0EFEDEDEDF0FE6464F4F1F2F2E8
        E4E2E2E5EFEDEDEDFE64F8EBEBEBE2CACACACAD8F1EFEDEDEDFEF7E9E9E8CAD9
        E7E8E9F4F2F0EEEDEDFEF7E6E6E7CAE5E7E9EBD8F3F1EEEDEDFEF7E0E3E4CADC
        E5E7E9CAD9F2EEEDEDFEF7DCDDE3D4CACFCFCECACAD5EEEDEDFEF7DDD4DDDFD8
        D4D5D1CACAD6EEEDEDFE64F6D3D3DBDFE2E4E6CADAECEEEDFE6464F7DCCFD1DB
        E1E4E6DAE8EBEDF0FE646464F7DBD1CFD5DBDEE1E4E9F0FC6464646464F7F6DA
        D6D6DAE0E7F6FD6464646464646464F7F6F6F6F6FA6464646464}
      OnClick = SpeedButton6Click
    end
    object Button1: TButton
      Left = 191
      Top = 8
      Width = 61
      Height = 25
      Hint = 'K'#233'p beilleszt'#233's a v'#225'g'#243'apr'#243'l'
      Caption = 'Beilleszt'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 254
      Top = 8
      Width = 65
      Height = 25
      Hint = 'K'#233'p m'#225'sol'#225'sa a v'#225'g'#243'lapra '
      Caption = 'M'#225'sol'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button5: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'K'#233'p bet'#246'lt'#233's'
      TabOrder = 2
      OnClick = Button5Click
    end
    object Button7: TButton
      Left = 339
      Top = 8
      Width = 87
      Height = 25
      Caption = 'Medi'#225'n sz'#369'r'#225's'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button7Click
    end
    object Button9: TButton
      Left = 89
      Top = 8
      Width = 75
      Height = 25
      Caption = 'K'#233'p ment'#233's'
      TabOrder = 4
      OnClick = Button9Click
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 495
    Width = 724
    Height = 19
    Hint = 'K'#233'p m'#233'rete - k'#246'z'#233'ppontja'
    Panels = <
      item
        Alignment = taCenter
        Width = 100
      end
      item
        Alignment = taCenter
        Width = 100
      end
      item
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 41
    Width = 724
    Height = 454
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'LEVON'#193'S'
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 153
        Height = 426
        Align = alLeft
        ParentBackground = False
        TabOrder = 0
        object Bevel1: TBevel
          Left = 3
          Top = 144
          Width = 142
          Height = 129
          Shape = bsFrame
          Style = bsRaised
        end
        object Label1: TLabel
          Left = 8
          Top = 8
          Width = 99
          Height = 13
          Caption = 'Levon'#225's param'#233'terei'
        end
        object ParLabel: TLabel
          Left = 40
          Top = 107
          Width = 65
          Height = 20
          Alignment = taCenter
          AutoSize = False
          Caption = '5.0'
          Color = clGray
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Transparent = False
        end
        object Label2: TLabel
          Left = 8
          Top = 160
          Width = 68
          Height = 13
          Caption = 'RGB szorz'#243'k :'
        end
        object Label3: TLabel
          Left = 40
          Top = 192
          Width = 17
          Height = 13
          Caption = 'R ='
        end
        object Label4: TLabel
          Left = 40
          Top = 216
          Width = 17
          Height = 13
          Caption = 'G ='
        end
        object Label5: TLabel
          Left = 40
          Top = 240
          Width = 16
          Height = 13
          Caption = 'B ='
        end
        object Button3: TButton
          Left = 8
          Top = 279
          Width = 129
          Height = 49
          Caption = 'LEVON'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = Button3Click
        end
        object TrackBar1: TTrackBar
          Left = 0
          Top = 29
          Width = 150
          Height = 45
          Position = 5
          TabOrder = 1
          OnChange = TrackBar1Change
        end
        object TrackBar2: TTrackBar
          Left = 0
          Top = 61
          Width = 150
          Height = 45
          Max = 9
          TabOrder = 2
          OnChange = TrackBar1Change
        end
        object Edit1: TEdit
          Left = 64
          Top = 189
          Width = 33
          Height = 21
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          Text = '1.0'
          OnKeyPress = Edit1KeyPress
        end
        object Edit2: TEdit
          Left = 64
          Top = 213
          Width = 33
          Height = 21
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          Text = '1.0'
          OnKeyPress = Edit1KeyPress
        end
        object Edit3: TEdit
          Left = 64
          Top = 237
          Width = 33
          Height = 21
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
          Text = '1.0'
          OnKeyPress = Edit1KeyPress
        end
        object Button4: TButton
          Left = 8
          Top = 396
          Width = 129
          Height = 25
          Hint = 'Eredeti k'#233'p vissza'#225'll'#237't'#225'sa'
          Caption = 'Eredeti k'#233'p - Esc'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnClick = Button4Click
        end
        object Button6: TButton
          Left = 80
          Top = 158
          Width = 57
          Height = 17
          Caption = 'Alap = 1'
          TabOrder = 7
          OnClick = Button6Click
        end
        object Button8: TButton
          Left = 8
          Top = 334
          Width = 129
          Height = 25
          Hint = 'Eredeti k'#233'p vissza'#225'll'#237't'#225'sa'
          Caption = 'Histogram'
          TabOrder = 8
          OnClick = Button8Click
        end
        object Button10: TButton
          Left = 8
          Top = 365
          Width = 129
          Height = 25
          Hint = 'Eredeti k'#233'p vissza'#225'll'#237't'#225'sa'
          Caption = 'Sk'#225'l'#225'z'#225's'
          TabOrder = 9
          OnClick = Button10Click
        end
      end
      object ALZ: TALZoomImage
        Left = 153
        Top = 0
        Width = 563
        Height = 426
        Align = alClient
        ClipBoardAction = cbaTotal
        BackColor = clGray
        BackCross = False
        Centered = True
        CentralCross = False
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
        Zoom = 1.000000000000000000
        OnChangeWindow = ALZChangeWindow
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Haszn'#225'lati '#250'tmutat'#243
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 716
        Height = 426
        Align = alClient
        Color = clInfoBk
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 
      'K'#233'pek|*.bmp;*.jpg; *.cr2;*.tif;*,tiff;*.gif;*.png|Canon RAW|*.cr' +
      '2|TIF|*.tif; *.tiff|Windows Bitmap|*.bmp|GIF|*.gif|Protanle Netw' +
      'ork Graphic|*.png'
    Left = 208
    Top = 105
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'JPG'
    Filter = 'JPEG|*.jpg|Windows Bitmap|*.bmp'
    Left = 268
    Top = 105
  end
end
