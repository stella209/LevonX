object MainForm: TMainForm
  Left = 192
  Top = 124
  BorderWidth = 2
  Caption = 'LEVON  1.2 '
  ClientHeight = 657
  ClientWidth = 980
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TLabel
    Left = 48
    Top = 83
    Width = 65
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = '5.0'
    Color = clGray
    Font.Charset = ANSI_CHARSET
    Font.Color = clYellow
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = False
  end
  object Splitter1: TSplitter
    Left = 169
    Top = 41
    Width = 6
    Height = 591
    ExplicitLeft = 8
    ExplicitTop = 8
    ExplicitHeight = 565
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 980
    Height = 41
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 493
      Top = 8
      Width = 48
      Height = 22
      Cursor = crHandPoint
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
      Left = 543
      Top = 8
      Width = 23
      Height = 22
      Cursor = crHandPoint
      Caption = 'R'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton2Click
    end
    object SpeedButton3: TSpeedButton
      Tag = 2
      Left = 567
      Top = 8
      Width = 23
      Height = 22
      Cursor = crHandPoint
      Caption = 'G'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton2Click
    end
    object SpeedButton4: TSpeedButton
      Tag = 3
      Left = 591
      Top = 8
      Width = 23
      Height = 22
      Cursor = crHandPoint
      Caption = 'B'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton2Click
    end
    object MonoButton: TSpeedButton
      Left = 615
      Top = 8
      Width = 42
      Height = 22
      Cursor = crHandPoint
      GroupIndex = 1
      Caption = 'Mono'
      OnClick = MonoButtonClick
    end
    object SpeedButton5: TSpeedButton
      Left = 673
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
      Left = 698
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
    object SpeedButton7: TSpeedButton
      Left = 378
      Top = 6
      Width = 105
      Height = 25
      Cursor = crHandPoint
      Hint = 'F4'
      Action = FullScreen
    end
    object btnHistList: TSpeedButton
      Left = 735
      Top = 8
      Width = 118
      Height = 22
      AllowAllUp = True
      GroupIndex = 11
      Down = True
      Caption = 'SABLON BE/KI'
      OnClick = btnHistListClick
    end
    object Button1: TButton
      Left = 313
      Top = 6
      Width = 54
      Height = 25
      Cursor = crHandPoint
      Hint = 'K'#233'p beilleszt'#233's a v'#225'g'#243'apr'#243'l'
      Caption = 'Beilleszt'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 259
      Top = 6
      Width = 55
      Height = 25
      Cursor = crHandPoint
      Hint = 'K'#233'p m'#225'sol'#225'sa a v'#225'g'#243'lapra '
      Caption = 'M'#225'sol'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button5: TButton
      Left = 58
      Top = 6
      Width = 53
      Height = 25
      Cursor = crHandPoint
      Caption = 'Bet'#246'lt'#233's'
      TabOrder = 2
      OnClick = Button5Click
    end
    object Button9: TButton
      Left = 113
      Top = 6
      Width = 56
      Height = 25
      Cursor = crHandPoint
      Caption = 'Ment'#233's'
      TabOrder = 3
      OnClick = Button9Click
    end
    object MeretezButton: TButton
      Left = 170
      Top = 6
      Width = 75
      Height = 25
      Cursor = crHandPoint
      Hint = 'K'#233'p m'#233'ret'#233'nek megv'#225'ltoztat'#225'sa'
      Caption = #193'tm'#233'retez'#233's'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = MeretezButtonClick
    end
    object Button18: TButton
      Left = 4
      Top = 6
      Width = 48
      Height = 25
      Cursor = crHandPoint
      Caption = 'ALAP'
      TabOrder = 5
      OnClick = Button18Click
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 632
    Width = 980
    Height = 25
    Hint = 'K'#233'p m'#233'rete - k'#246'z'#233'ppontja'
    Panels = <
      item
        Alignment = taCenter
        Width = 80
      end
      item
        Alignment = taCenter
        Width = 100
      end
      item
        Width = 80
      end
      item
        Alignment = taCenter
        Text = 'K'#233'p bet'#246'lt'#233'se ...'
        Width = 50
      end>
  end
  object DataPage: TPageControl
    Left = 0
    Top = 41
    Width = 169
    Height = 591
    ActivePage = AlapPage
    Align = alLeft
    HotTrack = True
    TabOrder = 2
    OnChange = DataPageChange
    object AlapPage: TTabSheet
      Caption = 'Alap'
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 161
        Height = 563
        Align = alClient
        Ctl3D = False
        ParentBackground = False
        ParentCtl3D = False
        TabOrder = 0
        object Bevel1: TBevel
          Left = 5
          Top = 153
          Width = 145
          Height = 78
          Shape = bsFrame
          Style = bsRaised
        end
        object Label1: TLabel
          Left = 12
          Top = 3
          Width = 99
          Height = 13
          Caption = 'Levon'#225's param'#233'terei'
        end
        object ParLabel: TLabel
          Left = 77
          Top = 77
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
        object Label2: TLabel
          Left = 8
          Top = 163
          Width = 82
          Height = 13
          Caption = 'RGB szorz'#243'k :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label3: TLabel
          Left = 22
          Top = 182
          Width = 8
          Height = 13
          Caption = 'R'
        end
        object Label4: TLabel
          Left = 71
          Top = 182
          Width = 8
          Height = 13
          Caption = 'G'
        end
        object Label5: TLabel
          Left = 115
          Top = 182
          Width = 7
          Height = 13
          Caption = 'B'
        end
        object Label7: TLabel
          Left = 77
          Top = 129
          Width = 65
          Height = 20
          Alignment = taCenter
          AutoSize = False
          Caption = '0'
          Color = clGray
          Font.Charset = ANSI_CHARSET
          Font.Color = clYellow
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Transparent = False
          StyleElements = [seBorder]
        end
        object Label8: TLabel
          Left = 6
          Top = 133
          Width = 70
          Height = 13
          Caption = 'H'#225'tt'#233'r szint:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label9: TLabel
          Left = 8
          Top = 82
          Width = 62
          Height = 13
          Caption = 'Param'#233'ter:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LEVONButton: TButton
          Left = 12
          Top = 237
          Width = 129
          Height = 49
          Cursor = crHandPoint
          Hint = 'Automatic Backgroud Elimination'
          Caption = 'LEVON 1'
          DropDownMenu = LevonPopup
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          Style = bsSplitButton
          TabOrder = 0
          StyleElements = []
          OnClick = LEVONButtonClick
        end
        object TrackBar1: TTrackBar
          Left = 6
          Top = 18
          Width = 147
          Height = 31
          Position = 5
          PositionToolTip = ptTop
          TabOrder = 1
          OnChange = TrackBar1Change
        end
        object TrackBar2: TTrackBar
          Left = 3
          Top = 46
          Width = 150
          Height = 33
          Max = 9
          PositionToolTip = ptTop
          TabOrder = 2
          OnChange = TrackBar1Change
        end
        object REdit: TEdit
          Left = 9
          Top = 201
          Width = 33
          Height = 19
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          Text = '1'
          OnKeyDown = REditKeyDown
          OnKeyPress = REditKeyPress
        end
        object BEdit: TEdit
          Left = 100
          Top = 201
          Width = 33
          Height = 19
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          Text = '1'
          OnKeyDown = REditKeyDown
          OnKeyPress = REditKeyPress
        end
        object GEdit: TEdit
          Left = 55
          Top = 201
          Width = 33
          Height = 19
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
          Text = '1'
          OnKeyDown = REditKeyDown
          OnKeyPress = REditKeyPress
        end
        object Button4: TButton
          Left = 12
          Top = 491
          Width = 129
          Height = 25
          Cursor = crHandPoint
          Hint = 'Eredeti k'#233'p vissza'#225'll'#237't'#225'sa'
          Caption = 'Eredeti k'#233'p - Esc'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
          OnClick = Button4Click
        end
        object Button6: TButton
          Left = 85
          Top = 161
          Width = 57
          Height = 17
          Caption = 'Alap = 1'
          TabOrder = 7
          OnClick = Button6Click
        end
        object HistoButton: TButton
          Left = 12
          Top = 301
          Width = 129
          Height = 25
          Cursor = crHandPoint
          Hint = 'Sz'#237'n param'#233'rek be'#225'll'#237't'#225'sa'
          Caption = 'Histogram'
          TabOrder = 8
          OnClick = HistoButtonClick
        end
        object SkalaButton: TButton
          Left = 12
          Top = 324
          Width = 129
          Height = 25
          Cursor = crHandPoint
          Caption = 'Sk'#225'l'#225'z'#225's'
          TabOrder = 9
          OnClick = SkalaButtonClick
        end
        object TrackBar3: TTrackBar
          Left = 1
          Top = 104
          Width = 149
          Height = 23
          Ctl3D = False
          Max = 100
          ParentCtl3D = False
          PositionToolTip = ptTop
          TabOrder = 10
          TickStyle = tsNone
          OnChange = TrackBar3Change
        end
        object ElesButton: TButton
          Left = 12
          Top = 430
          Width = 129
          Height = 25
          Cursor = crHandPoint
          Caption = #201'les'#237't'#233's'
          TabOrder = 11
          OnClick = ElesButtonClick
        end
        object KonvolButton: TButton
          Left = 12
          Top = 347
          Width = 129
          Height = 25
          Cursor = crHandPoint
          Caption = 'Konvol'#250'ci'#243
          TabOrder = 12
          OnClick = KonvolButtonClick
        end
        object MedianButton: TButton
          Left = 12
          Top = 454
          Width = 129
          Height = 25
          Cursor = crHandPoint
          Caption = 'Medi'#225'n sz'#369'r'#233's'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 13
          OnClick = MedianButtonClick
        end
        object UpDown1: TUpDown
          Left = 42
          Top = 201
          Width = 16
          Height = 19
          Associate = REdit
          Position = 1
          TabOrder = 14
          OnChangingEx = UpDown1ChangingEx
        end
        object UpDown2: TUpDown
          Left = 88
          Top = 201
          Width = 16
          Height = 19
          Associate = GEdit
          Position = 1
          TabOrder = 15
          OnChangingEx = UpDown1ChangingEx
        end
        object UpDown3: TUpDown
          Left = 133
          Top = 201
          Width = 16
          Height = 19
          Associate = BEdit
          Position = 1
          TabOrder = 16
          OnChangingEx = UpDown1ChangingEx
        end
        object MaszkButton: TButton
          Left = 12
          Top = 370
          Width = 129
          Height = 25
          Cursor = crHandPoint
          Caption = 'Maszkol'#225's'
          TabOrder = 17
          OnClick = MaszkButtonClick
        end
        object Button16: TButton
          Left = 12
          Top = 393
          Width = 129
          Height = 25
          Cursor = crHandPoint
          Caption = 'Flat korrekci'#243
          TabOrder = 18
          OnClick = VirtulisFlatkorrekci1Click
        end
        object Button19: TButton
          Left = 8
          Top = 536
          Width = 129
          Height = 25
          Cursor = crHandPoint
          Hint = 'Sz'#237'n param'#233'rek be'#225'll'#237't'#225'sa'
          Caption = 'SABLONOK'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clTeal
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 19
          Visible = False
          StyleElements = [seBorder]
        end
      end
    end
    object astroPage: TTabSheet
      Caption = 'Csillagok'
      ImageIndex = 1
      object PosLabel: TLabel
        Left = 48
        Top = 30
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '150'
      end
      object Label10: TLabel
        Left = 7
        Top = 82
        Width = 84
        Height = 13
        Caption = 'Csillagok sz'#225'ma : '
      end
      object StarCountLabel: TLabel
        Left = 91
        Top = 81
        Width = 43
        Height = 15
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object Button7: TButton
        Left = 7
        Top = 48
        Width = 129
        Height = 25
        Action = StarDetect
        TabOrder = 0
      end
      object StarVisibleCB: TCheckBox
        Left = 7
        Top = 144
        Width = 125
        Height = 17
        Caption = 'Csillagok l'#225'tszanak'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = StarVisibleCBClick
      end
      object ThresholdBar: TTrackBar
        Left = 1
        Top = 8
        Width = 141
        Height = 18
        Max = 255
        Position = 150
        PositionToolTip = ptTop
        TabOrder = 2
        TickStyle = tsManual
        OnChange = ThresholdBarChange
      end
      object PixelGridCB: TCheckBox
        Left = 7
        Top = 176
        Width = 97
        Height = 17
        Caption = 'PixelGrid'
        TabOrder = 3
        OnClick = PixelGridCBClick
      end
      object Button8: TButton
        Left = 7
        Top = 103
        Width = 129
        Height = 25
        Action = PreciseStarDetect
        TabOrder = 4
      end
      object Button10: TButton
        Left = 7
        Top = 209
        Width = 129
        Height = 25
        Caption = 'Csillaglista t'#246'rl'#233'se'
        TabOrder = 5
        OnClick = Button10Click
      end
      object Button15: TButton
        Left = 7
        Top = 240
        Width = 129
        Height = 25
        Caption = 'Csillaglista ->'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        OnClick = Button15Click
      end
      object VisImageCB: TCheckBox
        Left = 7
        Top = 160
        Width = 97
        Height = 17
        Caption = 'K'#233'p l'#225'tszik'
        Checked = True
        State = cbChecked
        TabOrder = 7
        OnClick = VisImageCBClick
      end
      object Button17: TButton
        Left = 7
        Top = 303
        Width = 129
        Height = 25
        Action = PreciseStarDetect
        TabOrder = 8
      end
    end
    object FotometPage: TTabSheet
      Caption = 'Fotometria'
      ImageIndex = 3
      object PHZ: TALZoomImage
        Left = 3
        Top = 3
        Width = 145
        Height = 145
        ClipBoardAction = cbaTotal
        BackColor = clSilver
        BackCross = False
        Centered = False
        CentralCross = True
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
        Zoom = 0.656100000000000000
      end
      object ALRGBDiagram2: TALRGBDiagram
        Left = 3
        Top = 152
        Width = 145
        Height = 73
        AlignToImage = True
        BackColor = clWhite
        DotVisible = False
        RGBColor = False
        RColor = True
        GColor = True
        BColor = True
        FixLine = True
        PenWidth = 1
        ZoomImage = PHZ
      end
      object GroupBox1: TGroupBox
        Left = 3
        Top = 227
        Width = 145
        Height = 105
        Caption = ' M'#233'rt adatok '
        TabOrder = 2
        object Label11: TLabel
          Left = 14
          Top = 67
          Width = 42
          Height = 13
          Caption = 'Intensity:'
        end
        object Label12: TLabel
          Left = 14
          Top = 50
          Width = 11
          Height = 13
          Caption = 'R:'
        end
        object Label13: TLabel
          Left = 14
          Top = 34
          Width = 17
          Height = 13
          Caption = 'XY:'
        end
        object pStarPosLabel: TLabel
          Left = 59
          Top = 34
          Width = 87
          Height = 13
          Alignment = taCenter
          AutoSize = False
          Caption = '0:0'
        end
        object pRadiusLabel: TLabel
          Left = 59
          Top = 50
          Width = 87
          Height = 13
          Alignment = taCenter
          AutoSize = False
          Caption = '0'
        end
        object pIntensityLabel: TLabel
          Left = 60
          Top = 65
          Width = 87
          Height = 13
          Alignment = taCenter
          AutoSize = False
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label14: TLabel
          Left = 14
          Top = 19
          Width = 20
          Height = 13
          Caption = 'No :'
        end
        object pNoLabel: TLabel
          Left = 59
          Top = 19
          Width = 87
          Height = 13
          Alignment = taCenter
          AutoSize = False
          Caption = '0'
        end
        object Label15: TLabel
          Left = 14
          Top = 84
          Width = 63
          Height = 13
          Caption = 'Log Intensity:'
        end
        object pIntLogLabel: TLabel
          Left = 60
          Top = 82
          Width = 87
          Height = 13
          Alignment = taCenter
          AutoSize = False
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
      object Button13: TButton
        Left = 3
        Top = 336
        Width = 146
        Height = 25
        Caption = 'Auto Fotometria'
        TabOrder = 3
        OnClick = Button13Click
      end
      object GroupBox2: TGroupBox
        Left = 3
        Top = 367
        Width = 145
        Height = 85
        Caption = 'Sz'#225'm'#237'tott adatok'
        TabOrder = 4
        object Label21: TLabel
          Left = 14
          Top = 23
          Width = 22
          Height = 13
          Caption = 'Gmg'
        end
        object Label22: TLabel
          Left = 14
          Top = 42
          Width = 14
          Height = 13
          Caption = 'Ra'
        end
        object Label23: TLabel
          Left = 14
          Top = 61
          Width = 14
          Height = 13
          Caption = 'De'
        end
        object Label24: TLabel
          Left = 121
          Top = 21
          Width = 14
          Height = 13
          Caption = 'mg'
        end
        object lGmg: TLabel
          Left = 60
          Top = 23
          Width = 38
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lRa: TLabel
          Left = 59
          Top = 42
          Width = 76
          Height = 13
          AutoSize = False
          Caption = '00:00:00.0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lDe: TLabel
          Left = 59
          Top = 61
          Width = 76
          Height = 13
          AutoSize = False
          Caption = '00:00:00.0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
      object Button14: TButton
        Left = 2
        Top = 454
        Width = 146
        Height = 25
        Caption = 'Grafikon (I-mg)'
        TabOrder = 5
        OnClick = Button14Click
      end
    end
    object CsillagListPage: TTabSheet
      Caption = 'Csillaglista'
      ImageIndex = 3
      object Panel4: TPanel
        Left = 0
        Top = 386
        Width = 161
        Height = 177
        Align = alBottom
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object Panel5: TPanel
          Left = 0
          Top = 8
          Width = 156
          Height = 161
          TabOrder = 0
          object Label16: TLabel
            Left = 12
            Top = 9
            Width = 11
            Height = 13
            Caption = 'ID'
          end
          object Label18: TLabel
            Left = 12
            Top = 57
            Width = 22
            Height = 13
            Caption = 'Gmg'
          end
          object Label19: TLabel
            Left = 12
            Top = 80
            Width = 14
            Height = 13
            Caption = 'Ra'
          end
          object Label20: TLabel
            Left = 12
            Top = 104
            Width = 14
            Height = 13
            Caption = 'De'
          end
          object LBId: TLabel
            Left = 29
            Top = 9
            Width = 116
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = '0'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = True
          end
          object Label17: TLabel
            Left = 112
            Top = 55
            Width = 14
            Height = 13
            Caption = 'mg'
          end
          object SpeedButton19: TSpeedButton
            Left = 52
            Top = 129
            Width = 23
            Height = 22
            Hint = '1. Ref. star'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            Glyph.Data = {
              36050000424D3605000000000000360400002800000010000000100000000100
              0800000000000001000000000000000000000001000000010000000000000101
              0100020202000303030004040400050505000606060007070700080808000909
              09000A0A0A000B0B0B000C0C0C000D0D0D000E0E0E000F0F0F00101010001111
              1100121212001313130014141400151515001616160017171700181818001919
              19001A1A1A001B1B1B001C1C1C001D1D1D001E1E1E001F1F1F00202020002121
              2100222222002323230024242400252525002626260027272700282828002929
              29002A2A2A002B2B2B002C2C2C00322E2C0038302C003E322C004A342D005635
              2E005E362E0063362F0066362F0068362F0069372F006C382E006F392D00713A
              2C00743B2B00773D29007A3E29007B3F28007D40270080412600824225008544
              2400894623008C482100904A2000944C1E00994E1C009B4F1B009D501A009F51
              1900A0521800A2521700A3531600A4531600A5541500A7551500A9571400AC58
              1200B05A1100B25B1100B25B1000B45C0E00B55C0E00B75D0C00B95E0A00BC5F
              0800C0610600C3620500C5630400C7640200C9650200CA650100CC660100CD67
              0100CD670200CD670200CC670200CB670300CB670500CB680600CC690800CC69
              0800CD6A0900CE6B0900CE6C0A00CF6D0C00CF6F0E00D0711000D0721400D075
              1900D2781C00D47B2100D57F2700D6822D00D6832F00D5833000D4833100D383
              3200D1823300CE823600CA823A00C7823D00C6833F00C4834100C1834400BF83
              4700BB834A00B8834F00B4845300AF845900AA856000A48667009D8770009688
              7A008E8984008B8B8B008C8C8C008D8D8D008E8E8E008F8F8F00909090009191
              9100929292009393930094949400959595009696960097979700989898009999
              99009A9A9A009B9B9B009C9C9C009D9D9D009E9E9E009F9F9F00A0A0A000A1A1
              A100A2A2A200A3A3A300A4A4A400A5A5A500A6A6A600A7A7A700A8A8A800A9A9
              A900AAAAAA00ABABAB00ACACAC00ADADAD00AEAEAE00B3B2B100BCBAB800C8C5
              C200D2CECB00DAD6D200E4DFDB00EDE8E400F3EEEA00F7F4F000FAF7F400FCF9
              F700FDFBF900FDFCFA00FEFDFB00FEFDFC00FEFDFB00FEFCFA00FEFBF900FDFA
              F700FDF7F000FCF2E800FBEDDD00FBE9D600FBE6D000FAE3CA00F9DFC400F8DB
              BD00F7D8B700F7D4B000F7D3AE00F6D2AC00F6D0A900F6CFA700F6CEA600F5CD
              A400F5CCA100F3CA9F00F2C79C00F1C59800F0C39400F0C19100F0C08E00EFBE
              8B00EFBC8800EFBB8400EFB87F00EEB67C00ECB37800EBB07200EAAC6D00E8A9
              6800E7A76500E6A36000E4A05B00E29D5700E19A5300E0985000DF954B00DE94
              4B00DF924E00E0905200E18C5800E3866000E67C6D00EA6B8200EF559D00F536
              C100FA1BDF00FC0DEF00FE04FA00FE02FC00FE00FE00FE00FE00FE00FE00FE00
              FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FAFAFAFAFA34
              3740403734FAFAFAFAFAFAFAFA383F525B5F605B544135FAFAFAFAFA3D506162
              625F616161614F35FAFAFA4052615F6A6A5F5F606060615034FAFA46626A60CA
              E2696B5FE679606140FA505A707270BDD7696CDEC2EA606155355272767975BD
              D972D5BDBDE95F615C3555E9E6E6E9BDD6C6BDBDC0E96B5F633758E3DEE1E3BD
              D3C5BDBDC0E9695F633A52E1D2DCDEBDCDE5CEBDBDE95F615C3555E7C9D2DBBD
              C9E3E6D6C2E764615435FA71CFC7D2C2C8DBE2E8DAE967613EFAFA57E9C8C6CF
              D2DDE3E878706D4D38FAFAFA55E9CAC6C9D3DADFE5734F3DFAFAFAFAFA5771E4
              D7D3D6E27C463DFAFAFAFAFAFAFAFA52535350514CFAFAFAFAFA}
            ParentFont = False
            OnClick = SpeedButton19Click
          end
          object SpeedButton20: TSpeedButton
            Left = 74
            Top = 129
            Width = 23
            Height = 22
            Hint = 'K'#246'vetkez'#337
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            Glyph.Data = {
              36050000424D3605000000000000360400002800000010000000100000000100
              0800000000000001000000000000000000000001000000010000000000000101
              0100020202000303030004040400050505000606060007070700080808000909
              09000A0A0A000B0B0B000C0C0C000D0D0D000E0E0E000F0F0F00101010001111
              110012121200131313001414140015151500161616001A1717002A1B1800391D
              1A00401E1A0047201B004B211B004F211B0052231B0056251A005B2719005E28
              1800602A1800622C1900642F1B006B371F007A4526008C552E009C613400AB6D
              3C00B8784300C7844900D18A4D00D68E4F00DB925100DD945200DF955300E197
              5500E2995700E39B5900E39C5D00E39A5800E3995600E2975300E0945000E093
              4F00E0924D00DF914B00DF8F4800DE8D4600DE8C4400DE8A4100DD893F00DC86
              3C00DA833900D77E3300D47A2F00D1762B00D1732700CB6E2400C5681F00BB60
              1B00B3591800A64F15009C48130093421100893C11008539100082370F007F35
              0F007E340F007D340F007D330F007E340E007F340E0081350D0083350C008436
              0C0086360B0088370B008C390A00913A0900953C0800983E08009B3F07009E40
              0600A0410500A3410500A5420400A8420300AC430200AF430100B2440100B444
              0100B6460000B8470000B9480000BA490000BB4A0000BC4A0000BD4C0100BF4D
              0100C04F0200C1500200C2510200C2510300C1520400C0530600BE540900BA55
              0E00B3581900A4613300916D540084776D00817A76007F7F7F00808080008181
              8100828282008383830084848400858585008686860087878700888888008989
              89008A8A8A008B8B8B008C8C8C008D8D8D008E8E8E008F8F8F00909090009191
              910092929200939393009494940095959500969696009C999700A29D9900ACA3
              9B00B6A89C00BEAD9D00C5B19E00CDB49C00D5B79B00DEBA9900E7BE9800EBC1
              9900EFC39B00F1C59B00F2C59B00F3C69C00F2C49800F1C29500F1C09200F0BE
              8F00F0BD8E00EFBC8D00EFBC8C00EFBB8B00EEBA8A00EEB88500ECB68300EBB5
              8200EAB78700EAB98B00E7BA9000E4BB9500E0BD9C00DABEA300D5BFAA00D0BF
              AF00CBBEB200C7BDB500C1BDB900BFBDBB00BEBEBE00C2C0BF00C5C3C000C8C4
              C000CBC6C100CDC7C200CEC9C300CFC9C300D3CDC700D5D0CA00DBD6D000E0DB
              D500E3DFDB00E6E4E100E9E9E900EFEEED00F2F1F000F5F4F300F7F6F500F9F8
              F800FAFAFA00FCFCFC00FDFDFD00FDFDFD00FEFEFE00FEFEFE00FEFEFE00FEFE
              FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFE
              FE00FEFEFD00FEFDFC00FEFCFB00FEFCFA00FEFCFA00FEFBFA00FEFBFA00FEF9
              FA00FEF3FA00FEE8FB00FED6FC00FEBCFD00FE9DFD00FE6CFD00FE42FE00FE26
              FE00FE13FE00FE07FE00FE02FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
              FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FAFAFAFAFA1C
              1E22221E1CFAFAFAFAFAFAFAFA1F2260686E6F6961231CFAFAFAFAFA215D7372
              716F707171745D1DFAFAFA2260726F70706F6D6D6F70735E1CFAFA5772727373
              6F6F77726C6F707322FA5E677742CC466A6A34CB2E6C6E71621D60794734DEDE
              446A34DEE43478716A1D624643B1DEDEDEA5C9E7DEDEA56F711D643E37AEDEDE
              DEA5CBE7DEE2A56F711F613BB1A6DEDE3446B1DEE5B177716A1C6243A5A5EAB1
              4646AECE346F6D72611DFA79A9A5A8B0363F3E437876717321FAFA6344A5A5B1
              343A43464877745C1FFAFAFA6144A6A5A8B1333C43485D21FAFAFAFAFA637A2C
              B1B2B12D495121FAFAFAFAFAFAFAFA604C4C4D5F5CFAFAFAFAFA}
            ParentFont = False
            OnClick = SpeedButton20Click
          end
          object SpeedButton21: TSpeedButton
            Left = 12
            Top = 129
            Width = 23
            Height = 22
            Hint = 'Ref. lista t'#246'rl'#233'se'
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
              49004A4A4A004B4B4B004C4C4C004D4D4D004E4E4E004F4F4F00505050005151
              5100525252005353530054545400555555005656560057575700585858005959
              59005A5A5A005B5B5B005C5C5C005D5D5D005E5E5E005F5F5F00606060006161
              6100626262006363630064646400656565006666660067676700686868006969
              69006A6A6A006B6B6B006C6C6C006D6D6D006E6E6E006F6F6F00707070007171
              7100727272007373730074747400757575007676760077777700787878007979
              79007A7A7A007B7B7B007C7C7C007D7D7D007E7E7E007F7F7F00808080008181
              8100828282008383830084848400858585008686860087878700888888008989
              89008A8A8A008B8B8B008C8C8C008D8D8D008E8E8E008F8F8F00909090009191
              9100929292009393930094949400959595009696960097979700989898009999
              99009A9A9A009B9B9B009C9C9C009D9D9D009E9E9E009F9F9F00A0A0A000A1A1
              A100A2A2A200A3A3A300A4A4A400A5A5A500A6A6A600A7A7A700A8A8A800A9A9
              A900AAAAAA00ABABAB00ACACAC00ADADAD00AEAEAE00AFAFAF00B0B0B000B1B1
              B100B2B2B200B3B3B300B4B4B400B5B5B500B6B6B600B7B7B700B8B8B800B9B9
              B900BABABA00BBBBBB00BCBCBC00BDBDBD00BEBEBE00BFBFBF00C0C0C000C1C1
              C100C2C2C200C3C3C300B8BBC700ADB3CB00A3ACCF0099A5D300909ED6007086
              DE004969E7002950EE001642F3000D3BF5000838F6000536F7000435F8000335
              F8000334F8000334F9000334F9000334F8000334F7000334F6000434F4000434
              F1000433EF000433ED000533EB000533E9000533E7000632E4000632E1000632
              DE000632DD000632DD000632DD000632DD000731DD000831DD000C30DE00132F
              DF00202CE1004625E6007C1AED00CC0AF800EC04FC00F901FE00FD00FE00FE00
              FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
              FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00F7F7F7F7F7F7
              F7F7F7F7F7F7F7F7E1E1F7E1E1F7F7F7F7F7F7F7F7F7F7E1E1F7F7E1E1E1F7F7
              F7F7F7F7F7F7E1E1F7F7F7E1E3E1E1F7F7F7F7F7F7E1E1F7F7F7F7F7DBE1E1E1
              F7F7F7F7E1E1F7F7F7F7F7F7F7F7E1E1E3F7E3E1E1F7F7F7F7F7F7F7F7F7F7E3
              DEDEDDE3F7F7F7F7F7F7F7F7F7F7F7F7DFDFDAF7F7F7F7F7F7F7F7F7F7F7F7E3
              DBDDDAD8F7F7F7F7F7F7F7F7F7F7D8DADCF7F7D8D1F7F7F7F7F7F7F7F7D1DAD5
              F7F7F7F7D1D1F7F7F7F7F7F7D1D1D1F7F7F7F7F7F7D1D1F7F7F7F7D1D1D1F7F7
              F7F7F7F7F7F7F7D1F7F7D1D1D1F7F7F7F7F7F7F7F7F7F7F7F7F7D1D1F7F7F7F7
              F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7}
            OnClick = SpeedButton21Click
          end
          object SpeedButton22: TSpeedButton
            Left = 116
            Top = 129
            Width = 23
            Height = 22
            Hint = 'Ment'#233's'
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
            OnClick = SpeedButton22Click
          end
          object LbRefCount: TLabel
            Left = 83
            Top = 30
            Width = 6
            Height = 13
            Caption = '0'
          end
          object ChRef: TCheckBox
            Left = 12
            Top = 28
            Width = 61
            Height = 17
            Caption = 'Ref.star'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object EdGmg: TEdit
            Left = 52
            Top = 52
            Width = 53
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
          object EdRa: TEdit
            Left = 52
            Top = 78
            Width = 87
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
          end
          object EdDe: TEdit
            Left = 52
            Top = 101
            Width = 87
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
          end
        end
        object Memo2: TMemo
          Left = 162
          Top = 8
          Width = 215
          Height = 161
          Color = clBlack
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clSilver
          Font.Height = -11
          Font.Name = 'Arial Narrow'
          Font.Style = []
          Lines.Strings = (
            'REFERENCIA CSILLAGOK MEGAD'#193'SA'
            '         ( Minimum 3 ref. star)'
            '0. Csillagok: Precizi'#243's StarDetect'
            '1. Klikkelj a csillagra a k'#233'pen;'
            '2. Adatlapon pip'#225'ld ki a Ref.star-t;'
            '3. '#205'rd be a Gmg rovatba a magnitud'#243't;'
            '4. Ra,De rovatokba a koordin'#225't'#225't'
            '    (pl: -7:12:23.4 form'#225'ban);'
            '5. Mentsd el.'
            'V'#233'g'#252'll: Fotometria lapon: Auto Fotometria')
          ParentFont = False
          TabOrder = 1
          StyleElements = []
        end
      end
      object sGrid: TSTDataGrid
        Left = 0
        Top = 0
        Width = 161
        Height = 386
        Align = alClient
        Color = clSilver
        ColCount = 10
        DefaultColWidth = 36
        DefaultRowHeight = 16
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect, goThumbTracking]
        ParentFont = False
        TabOrder = 1
        StyleElements = [seFont, seBorder]
        OnClick = sGridClick
        OnDrawCell = sGridDrawCell
        OnSelectCell = sGridSelectCell
        AutoAppendRow = False
        CopyAboweRow = False
        EnableEvents = True
        OEMConversion = False
        TitleLabels.Strings = (
          'No'
          'ID'
          'Gmg'
          'Radius'
          'Intensity'
          'Ra'
          'De')
        ColWidths = (
          36
          44
          46
          51
          45
          44
          49
          47
          46
          48)
      end
    end
    object OpenTabSheet: TTabSheet
      Caption = 'Megnyit'#225's'
      ImageIndex = 4
      object Splitter3: TSplitter
        Left = 0
        Top = 148
        Width = 161
        Height = 9
        Cursor = crVSplit
        Align = alTop
      end
      object DriveComboBox2: TDriveComboBox
        Left = 0
        Top = 0
        Width = 161
        Height = 19
        Align = alTop
        DirList = DirectoryListBox1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object DirectoryListBox1: TDirectoryListBox
        Left = 0
        Top = 19
        Width = 161
        Height = 129
        Align = alTop
        FileList = FileListBox1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
      object FileListBox1: TFileListBox
        Left = 0
        Top = 157
        Width = 161
        Height = 406
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Mask = '*.bmp;*.tif;*.tiff;*.jpg;*.cr2;*.crw;*.nef'
        ParentFont = False
        ShowGlyphs = True
        TabOrder = 2
        OnClick = FileListBox1Click
      end
    end
  end
  object Panel3: TPanel
    Left = 175
    Top = 41
    Width = 805
    Height = 591
    Align = alClient
    Caption = 'Panel3'
    TabOrder = 3
    object ToolPages: TPageControl
      Left = 1
      Top = 1
      Width = 803
      Height = 51
      ActivePage = TabSheet6
      Align = alTop
      HotTrack = True
      TabOrder = 0
      TabPosition = tpBottom
      OnChange = ToolPagesChange
      OnChanging = ToolPagesChanging
      object TabSheet3: TTabSheet
        Caption = 'K'#233'p'
        object ToolBar2: TToolBar
          Left = 0
          Top = 0
          Width = 795
          Height = 24
          Margins.Left = 10
          ButtonWidth = 1400
          Caption = 'ToolBar1'
          Customizable = True
          Images = ImageList1
          List = True
          AllowTextButtons = True
          TabOrder = 0
          Transparent = False
          object btnKeparany: TRzMenuButton
            Left = 0
            Top = 0
            Width = 97
            Height = 22
            Hint = 'K'#233'par'#225'nyok'
            Caption = 'TOTAL'
            TabOrder = 0
            DropDownMenu = ZoomPopupMenu
          end
          object ALTimerSpeedButton2: TALTimerSpeedButton
            Left = 97
            Top = 0
            Width = 23
            Height = 22
            Cursor = crHandPoint
            Glyph.Data = {
              36040000424D3604000000000000360000002800000010000000100000000100
              2000000000000004000000000000000000000000000000000000FF00FF006470
              7A00BF9E9600FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0063A8F1003879
              F40060758800C59D9500FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00559FF500559F
              F5003879F40060758800C59D9500FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00559F
              F500559FF5003879F40060758800C59D9500FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00559FF500559FF5003879F40060758800BA9E9600FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00559FF500559FF5003879F400656F7700FF00FF009F928D00C59F
              9700D3B5A900CFAA9F00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00559FF500D0D0D1009F928D00AD9A9200FAEFC800FDF9
              DA00FDF9DA00FDF9DA00F4D6B200D1ADA100FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00CFBDB700D6B9AB00FBEDC400FCF8D700FDF9
              DA00FDF9DA00FDFADF00FDFAE300F4F1DF00B49C9500FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00C59D9500F7E0B200F8E2B200FCF6D400FDF9
              DA00FDF9E100FDFAE300FDFAE300FDFAE300F2D0B400FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00D6B9AB00F8E2B200AD9A920063A8F1004584
              F3004584F3004584F3005DA2F200DFE0D700FBF4D100C79F9600FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00F2C9B400F8E2B200356DF7002749FC002749
              FC002749FC002749FC002749FC00CBC8CC00FCF8D700CDA59A00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00D6B9AB00F9E5B700CEA79C00D1B0A50063A8
              F10063A8F10063A8F100D0D0D100F0EFDE00FBF4D100CBA29700FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00C79F9600FBEDC400FBEDC400F4D6B200F2D0
              B400F9E5B700FCF6D400FCF6D400FDF9DA00F4D9B100FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00D6B9AB00FDFAE300FDFAE300F2C9
              B400F3BFBB00F2D0B400F9E5B700FBF3CD00BF9E9600FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00CDBFBD00F4F1DF00FBED
              C400F8E2B200F9E5B700F5DDB100D1ADA100FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00CBA29700CFAA
              9F00D6B9AB00D6B9AB00FF00FF00FF00FF00FF00FF00FF00FF00}
            Interval = 1
            TimerEneble = True
            OnTimerEvent = ALTimerSpeedButton2TimerEvent
          end
          object ALTimerSpeedButton1: TALTimerSpeedButton
            Left = 120
            Top = 0
            Width = 23
            Height = 22
            Cursor = crHandPoint
            Glyph.Data = {
              36040000424D3604000000000000360000002800000010000000100000000100
              2000000000000004000000000000000000000000000000000000FF00FF004B4E
              5100BB848200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF006C83B800206C
              F20046659600BB848200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00357CF700357C
              F700206CF20046659600BB848200FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00357C
              F700357CF700206CF20046659600BB848200FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00357CF700357CF700206CF20046659600BB848200FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00357CF700357CF700206CF2004B4E5100FF00FF005A5D6000BF8B
              8500C8A29100BF8F8700FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00357CF700AEBDDA0079757400BB848200F4DCA400F9F5
              CB00F9F5CB00F9F5CB00E7CBA000C4998A00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00C8A29100CBA79400F7E5B000F9F5CB00A6B6
              D8004172F600DCE0DA00F8F5D800F0EED70079757400FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00BB848200F3D8A000F3D8A000F8EEBC006C83
              B800082AFB00BFCBDC00F8F5D800F8F5D800DBBD9D00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00CBA79400F7E1A8006C83B8006C83B800184F
              F900082AFB005B69F9005B69F900CAD3DC00F9F1C200BB848200FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00D8B99B00F7E1A80046659600082AFB00082A
              FB00082AFB00082AFB00082AFB009DAFD500F9F5CB00C1968900FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00D0AD9600F7E1A800C0938800C4998A004172
              F600082AFB008297C500B7C4DB00F0EED700F9F3C500BF8B8500FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00BD878300F7E5B000F7E5B000F3D8A0005E76
              AA00082AFB00B7C4DB00F9F3C500F9F5D100E7CBA000FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00D4B49900F8F5D800F8F5D800C8A2
              9100C5789100D4B49900F4DCA400F8EEBC00BB848200FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00D0AD9600F0EED700F7E5
              B000F7E1A800F7E1A800F1D6A000C1968900FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00C1968900C196
              8900D0AD9600CBA79400FF00FF00FF00FF00FF00FF00FF00FF00}
            Interval = 1
            TimerEneble = True
            OnTimerEvent = ALTimerSpeedButton1TimerEvent
          end
          object ToolButton1: TToolButton
            Left = 143
            Top = 0
            Width = 13
            Caption = 'ToolButton1'
            ImageIndex = 23
            Style = tbsSeparator
          end
          object ToolButton17: TToolButton
            Left = 156
            Top = 0
            Cursor = crHandPoint
            Action = CentralCross
            ImageIndex = 23
          end
          object ToolButton18: TToolButton
            Left = 180
            Top = 0
            Cursor = crHandPoint
            Action = Meroracs
            ImageIndex = 24
          end
          object ToolButton34: TToolButton
            Left = 204
            Top = 0
            Cursor = crHandPoint
            Hint = 'K'#246'r ablakban'
            Caption = 'ToolButton34'
            ImageIndex = 44
            OnClick = ToolButton34Click
          end
          object ToolButton19: TToolButton
            Left = 228
            Top = 0
            Width = 12
            Caption = 'ToolButton6'
            ImageIndex = 2
            Indeterminate = True
            Style = tbsSeparator
          end
          object ToolButton20: TToolButton
            Left = 240
            Top = 0
            Cursor = crHandPoint
            Hint = 'Negat'#237'v'
            Caption = 'ToolButton5'
            ImageIndex = 26
            OnClick = ToolButton5Click
          end
          object ToolButton21: TToolButton
            Left = 264
            Top = 0
            Cursor = crHandPoint
            Hint = 'Monokr'#243'm'
            Caption = 'ToolButton7'
            ImageIndex = 25
            Indeterminate = True
            OnClick = ToolButton7Click
          end
          object ToolButton22: TToolButton
            Left = 288
            Top = 0
            Width = 12
            Caption = 'ToolButton8'
            ImageIndex = 2
            Style = tbsSeparator
          end
          object ToolButton23: TToolButton
            Left = 300
            Top = 0
            Cursor = crHandPoint
            Hint = 'T'#246'kr'#246'z'#233's X'
            Caption = 'ToolButton1'
            ImageIndex = 29
            Indeterminate = True
            OnClick = ToolButton23Click
          end
          object ToolButton24: TToolButton
            Left = 324
            Top = 0
            Cursor = crHandPoint
            Hint = 'T'#252'kr'#246'z'#233's Y'
            Caption = 'ToolButton2'
            ImageIndex = 30
            OnClick = ToolButton24Click
          end
          object ToolButton25: TToolButton
            Left = 348
            Top = 0
            Cursor = crHandPoint
            Hint = 'Forgat'#225's balra'
            Caption = 'ToolButton10'
            ImageIndex = 31
            Indeterminate = True
            OnClick = ToolButton10Click
          end
          object ToolButton26: TToolButton
            Left = 372
            Top = 0
            Cursor = crHandPoint
            Hint = 'Forgat'#225's jobbra'
            Caption = 'ToolButton11'
            ImageIndex = 32
            OnClick = ToolButton11Click
          end
          object ToolButton27: TToolButton
            Left = 396
            Top = 0
            Width = 12
            Caption = 'ToolButton12'
            ImageIndex = 4
            Indeterminate = True
            Style = tbsSeparator
          end
          object ToolButton28: TToolButton
            Left = 408
            Top = 0
            Cursor = crHandPoint
            Hint = 'Izot'#243'ni'#225's szintek'
            Caption = 'ToolButton13'
            ImageIndex = 27
            OnClick = ToolButton13Click
          end
          object ToolButton29: TToolButton
            Left = 432
            Top = 0
            Cursor = crHandPoint
            Hint = 'Izot'#243'ni'#225's vonalak'
            Caption = 'ToolButton14'
            ImageIndex = 28
            Indeterminate = True
            OnClick = ToolButton14Click
          end
          object ToolButton30: TToolButton
            Left = 456
            Top = 0
            Cursor = crHandPoint
            Hint = 'Sz'#237'nzaj levon'#225's'
            Caption = 'ToolButton15'
            ImageIndex = 6
            OnClick = ToolButton15Click
          end
          object ToolButton32: TToolButton
            Left = 480
            Top = 0
            Cursor = crHandPoint
            Hint = 'Rossz pixelek elt'#225'vol'#237't'#225'sa'
            Caption = 'ToolButton32'
            ImageIndex = 22
            Indeterminate = True
            OnClick = ToolButton32Click
          end
          object ToolButton2: TToolButton
            Left = 504
            Top = 0
            Width = 43
            Caption = 'ToolButton2'
            ImageIndex = 23
            Style = tbsSeparator
          end
          object MemoryProgress: TProgressBar
            Left = 547
            Top = 0
            Width = 126
            Height = 22
            TabOrder = 1
            Visible = False
          end
        end
      end
      object TabSheet4: TTabSheet
        Caption = 'Grafika'
        ImageIndex = 1
        object ToolBar1: TToolBar
          Left = 0
          Top = 0
          Width = 795
          Height = 24
          Margins.Left = 10
          Caption = 'ToolBar1'
          Enabled = False
          Images = ImageList1
          TabOrder = 0
          Transparent = False
          object ToolButton9: TToolButton
            Left = 0
            Top = 0
            Width = 15
            Caption = 'ToolButton9'
            Enabled = False
            ImageIndex = 7
            Style = tbsSeparator
          end
          object ToolButton4: TToolButton
            Left = 15
            Top = 0
            Caption = 'ToolButton4'
            Enabled = False
            ImageIndex = 33
          end
          object ToolButton5: TToolButton
            Left = 38
            Top = 0
            Caption = 'ToolButton5'
            Enabled = False
            ImageIndex = 34
          end
          object ToolButton6: TToolButton
            Left = 61
            Top = 0
            Caption = 'ToolButton6'
            Enabled = False
            ImageIndex = 35
          end
          object ToolButton7: TToolButton
            Left = 84
            Top = 0
            Caption = 'ToolButton7'
            Enabled = False
            ImageIndex = 36
          end
          object ToolButton8: TToolButton
            Left = 107
            Top = 0
            Caption = 'ToolButton8'
            Enabled = False
            ImageIndex = 37
          end
          object ToolButton10: TToolButton
            Left = 130
            Top = 0
            Caption = 'ToolButton10'
            Enabled = False
            ImageIndex = 38
          end
          object ToolButton11: TToolButton
            Left = 153
            Top = 0
            Caption = 'ToolButton11'
            Enabled = False
            ImageIndex = 39
          end
          object ToolButton12: TToolButton
            Left = 176
            Top = 0
            Caption = 'ToolButton12'
            Enabled = False
            ImageIndex = 40
          end
          object ToolButton13: TToolButton
            Left = 199
            Top = 0
            Caption = 'ToolButton13'
            Enabled = False
            ImageIndex = 42
          end
          object ToolButton14: TToolButton
            Left = 222
            Top = 0
            Caption = 'ToolButton14'
            Enabled = False
            ImageIndex = 43
          end
          object ToolButton15: TToolButton
            Left = 245
            Top = 0
            Caption = 'ToolButton15'
            Enabled = False
            ImageIndex = 44
          end
          object ToolButton16: TToolButton
            Left = 268
            Top = 0
            Caption = 'ToolButton16'
            Enabled = False
            ImageIndex = 45
          end
          object ToolButton31: TToolButton
            Left = 291
            Top = 0
            Caption = 'ToolButton31'
            Enabled = False
            ImageIndex = 46
          end
        end
      end
      object TabSheet6: TTabSheet
        Caption = 'V'#225'g'#243'k'#246'nyv'
        ImageIndex = 2
        object SpeedButton8: TSpeedButton
          Left = 180
          Top = 1
          Width = 23
          Height = 22
          Cursor = crHandPoint
          AllowAllUp = True
          GroupIndex = 888
          Down = True
          Caption = '1'
          OnClick = SpeedButton8Click
          OnMouseEnter = SpeedButton8MouseEnter
          OnMouseLeave = SpeedButton8MouseLeave
        end
        object SpeedButton9: TSpeedButton
          Tag = 1
          Left = 204
          Top = 1
          Width = 23
          Height = 22
          Cursor = crHandPoint
          AllowAllUp = True
          GroupIndex = 888
          Caption = '2'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          OnClick = SpeedButton8Click
          OnMouseEnter = SpeedButton8MouseEnter
          OnMouseLeave = SpeedButton8MouseLeave
        end
        object SpeedButton10: TSpeedButton
          Tag = 2
          Left = 228
          Top = 1
          Width = 23
          Height = 22
          Cursor = crHandPoint
          AllowAllUp = True
          GroupIndex = 888
          Caption = '3'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          OnClick = SpeedButton8Click
          OnMouseEnter = SpeedButton8MouseEnter
          OnMouseLeave = SpeedButton8MouseLeave
        end
        object SpeedButton11: TSpeedButton
          Tag = 3
          Left = 252
          Top = 1
          Width = 23
          Height = 22
          Cursor = crHandPoint
          AllowAllUp = True
          GroupIndex = 888
          Caption = '4'
          OnClick = SpeedButton8Click
          OnMouseEnter = SpeedButton8MouseEnter
          OnMouseLeave = SpeedButton8MouseLeave
        end
        object SpeedButton13: TSpeedButton
          Tag = 4
          Left = 276
          Top = 1
          Width = 23
          Height = 22
          Cursor = crHandPoint
          AllowAllUp = True
          GroupIndex = 888
          Caption = '5'
          OnClick = SpeedButton8Click
          OnMouseEnter = SpeedButton8MouseEnter
          OnMouseLeave = SpeedButton8MouseLeave
        end
        object SpeedButton14: TSpeedButton
          Tag = 5
          Left = 300
          Top = 1
          Width = 23
          Height = 22
          Cursor = crHandPoint
          AllowAllUp = True
          GroupIndex = 888
          Caption = '6'
          OnClick = SpeedButton8Click
          OnMouseEnter = SpeedButton8MouseEnter
          OnMouseLeave = SpeedButton8MouseLeave
        end
        object SpeedButton15: TSpeedButton
          Tag = 6
          Left = 324
          Top = 1
          Width = 23
          Height = 22
          Cursor = crHandPoint
          AllowAllUp = True
          GroupIndex = 888
          Caption = '7'
          OnClick = SpeedButton8Click
          OnMouseEnter = SpeedButton8MouseEnter
          OnMouseLeave = SpeedButton8MouseLeave
        end
        object SpeedButton16: TSpeedButton
          Tag = 7
          Left = 348
          Top = 0
          Width = 23
          Height = 22
          Cursor = crHandPoint
          AllowAllUp = True
          GroupIndex = 888
          Caption = '8'
          OnClick = SpeedButton8Click
          OnMouseEnter = SpeedButton8MouseEnter
          OnMouseLeave = SpeedButton8MouseLeave
        end
        object SpeedButton17: TSpeedButton
          Tag = 8
          Left = 372
          Top = 0
          Width = 23
          Height = 22
          Cursor = crHandPoint
          AllowAllUp = True
          GroupIndex = 888
          Caption = '9'
          OnClick = SpeedButton8Click
          OnMouseEnter = SpeedButton8MouseEnter
          OnMouseLeave = SpeedButton8MouseLeave
        end
        object SpeedButton18: TSpeedButton
          Tag = 9
          Left = 396
          Top = 0
          Width = 23
          Height = 22
          Cursor = crHandPoint
          AllowAllUp = True
          GroupIndex = 888
          Caption = '10'
          OnClick = SpeedButton8Click
          OnMouseEnter = SpeedButton8MouseEnter
          OnMouseLeave = SpeedButton8MouseLeave
        end
        object Button3: TButton
          Left = 0
          Top = -1
          Width = 75
          Height = 25
          Cursor = crHandPoint
          Caption = 'M'#225'sol'#225's'
          DropDownMenu = CopyPopupMenu
          Style = bsSplitButton
          TabOrder = 0
          OnClick = Button3Click
          OnDropDownClick = Button3DropDownClick
        end
        object Button11: TButton
          Left = 76
          Top = -1
          Width = 101
          Height = 25
          Cursor = crHandPoint
          Caption = 'Beilleszt'#233's'
          Style = bsSplitButton
          TabOrder = 1
          OnClick = Button11Click
        end
        object Button12: TButton
          Left = 424
          Top = -1
          Width = 75
          Height = 25
          Cursor = crHandPoint
          Caption = 'Mindet T'#246'rli'
          TabOrder = 2
          OnClick = Button12Click
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'IPL'
        ImageIndex = 3
        object Label26: TLabel
          Left = 8
          Top = 3
          Width = 61
          Height = 13
          Caption = 'IPL Parancs:'
        end
        object btnHistRun: TRzToolButton
          Left = 412
          Top = -1
          Hint = 'V'#233'grehajt'#225's'
          ImageIndex = 72
          Images = ImageList1
          OnClick = btnHistRunClick
        end
        object IPLEdit: TEdit
          Left = 248
          Top = 0
          Width = 158
          Height = 21
          Hint = 'Param'#233'terek: 1,2,3,....'
          TabOrder = 1
          OnEnter = IPLEditEnter
          OnExit = IPLEditExit
        end
        object IPLCombo: TComboBox
          Left = 88
          Top = 0
          Width = 145
          Height = 21
          CharCase = ecUpperCase
          DropDownCount = 20
          TabOrder = 0
        end
      end
    end
    object Panel6: TPanel
      Left = 1
      Top = 52
      Width = 803
      Height = 538
      Align = alClient
      Caption = 'Panel6'
      TabOrder = 1
      object PageControl1: TPageControl
        Left = 1
        Top = 1
        Width = 550
        Height = 536
        ActivePage = TabSheet1
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        TabPosition = tpBottom
        object TabSheet1: TTabSheet
          Caption = 'K'#201'PSZERKESZT'#336
          object Panel7: TPanel
            Left = 0
            Top = 0
            Width = 542
            Height = 507
            Align = alClient
            Caption = 'Panel3'
            TabOrder = 0
            object Splitter2: TSplitter
              Left = 1
              Top = 401
              Width = 540
              Height = 5
              Cursor = crVSplit
              Align = alBottom
              ExplicitLeft = -15
              ExplicitTop = 355
              ExplicitWidth = 548
            end
            object SpeedButton12: TSpeedButton
              Left = 308
              Top = 4
              Width = 23
              Height = 22
            end
            object ALZ: TALZoomImage
              AlignWithMargins = True
              Left = 1
              Top = 1
              Width = 540
              Height = 400
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              ParentCustomHint = False
              Align = alClient
              ClipBoardAction = cbaTotal
              BackColor = 2105376
              BackCross = False
              BulbRadius = 20
              Centered = False
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
              Grid.SubGridPen.Color = 5592405
              Grid.SubGridDistance = 10.000000000000000000
              Grid.PixelGrid = False
              Grid.Scale = True
              Grid.ScaleFont.Charset = DEFAULT_CHARSET
              Grid.ScaleFont.Color = clWhite
              Grid.ScaleFont.Height = -11
              Grid.ScaleFont.Name = 'Arial'
              Grid.ScaleFont.Style = []
              Grid.ScaleBrush.Color = clBlack
              Grid.Visible = False
              OverMove = False
              RGBList.MonoRGB = False
              RGBList.RGB = True
              TabStop = True
              Zoom = 0.729000000000000000
              OnAfterPaint = ALZAfterPaint
              OnChangeWindow = ALZChangeWindow
              OnMouseDown = ALZMouseDown
              OnMouseMove = ALZMouseMove
              OnMouseUp = ALZMouseUp
            end
            object ALRGBDiagram1: TALRGBDiagram
              Left = 1
              Top = 406
              Width = 540
              Height = 100
              Margins.Left = 2
              Margins.Top = 2
              Margins.Right = 2
              Margins.Bottom = 2
              Align = alBottom
              AlignToImage = True
              BackColor = clWhite
              DotVisible = False
              RGBColor = True
              RColor = True
              GColor = True
              BColor = True
              FixLine = False
              PenWidth = 1
              Visible = False
              ZoomImage = ALZ
            end
          end
        end
        object HISTORY: TTabSheet
          Caption = 'HISTORY'
          ImageIndex = 1
          object HistMemo: TMemo
            Left = 0
            Top = 0
            Width = 542
            Height = 466
            Align = alClient
            TabOrder = 0
          end
          object Panel11: TPanel
            Left = 0
            Top = 466
            Width = 542
            Height = 41
            Align = alBottom
            TabOrder = 1
            object Button20: TButton
              Left = 12
              Top = 8
              Width = 75
              Height = 25
              Cursor = crHandPoint
              Caption = 'T'#246'r'#246'l'
              TabOrder = 0
              OnClick = Button20Click
            end
            object Button21: TButton
              Left = 96
              Top = 8
              Width = 141
              Height = 25
              Cursor = crHandPoint
              Caption = 'Lista ment'#233'se'
              TabOrder = 1
              OnClick = Button21Click
            end
            object Button22: TButton
              Left = 243
              Top = 8
              Width = 286
              Height = 25
              Cursor = crHandPoint
              Caption = 'Kijel'#246'ltek '#225'temel'#233'se a SABLON-ba >>'
              TabOrder = 2
              OnClick = Button22Click
            end
          end
        end
      end
      object HistPanel: TRzSizePanel
        Left = 551
        Top = 1
        Width = 251
        Height = 536
        Align = alRight
        HotSpotVisible = True
        SizeBarWidth = 7
        TabOrder = 1
        object Panel8: TPanel
          Left = 8
          Top = 0
          Width = 243
          Height = 31
          Align = alTop
          Caption = 'SABLON'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object Panel9: TPanel
          Left = 8
          Top = 31
          Width = 243
          Height = 65
          Align = alTop
          TabOrder = 1
          object Label25: TLabel
            Left = 8
            Top = 10
            Width = 57
            Height = 13
            Caption = 'Sablon n'#233'v:'
          end
          object btnSalonLoad: TRzToolButton
            Left = 8
            Top = 34
            Hint = 'Sablon bet'#246'lt'#233'se'
            ImageIndex = 7
            Images = ImageList1
            OnClick = btnSalonLoadClick
          end
          object btnSablonSave: TRzToolButton
            Left = 39
            Top = 34
            Hint = 'Sablon ment'#233'se'
            ImageIndex = 60
            Images = ImageList1
            OnClick = btnSablonSaveClick
          end
          object btnListDown: TRzToolButton
            Left = 177
            Top = 34
            Hint = 'Sor le'
            ImageIndex = 98
            Images = ImageList1
            OnClick = btnListDownClick
          end
          object btnListUp: TRzToolButton
            Left = 208
            Top = 34
            Hint = 'Sor fel'
            ImageIndex = 100
            Images = ImageList1
            OnClick = btnListUpClick
          end
          object RzToolButton1: TRzToolButton
            Left = 77
            Top = 33
            Width = 90
            Hint = 'Sor le'
            ImageIndex = 6
            Images = ImageList1
            ShowCaption = True
            UseToolbarShowCaption = False
            Caption = #218'j lista'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            OnClick = jlista1Click
          end
          object SablonNevEdit: TEdit
            Left = 74
            Top = 6
            Width = 159
            Height = 21
            TabOrder = 0
          end
        end
        object CheckListHistory: TCheckListBox
          Left = 8
          Top = 96
          Width = 243
          Height = 356
          Align = alClient
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          ItemHeight = 17
          ParentFont = False
          PopupMenu = HistListPopupMenu
          TabOrder = 2
          OnDblClick = CheckListHistoryDblClick
          OnKeyDown = CheckListHistoryKeyDown
        end
        object Panel10: TPanel
          Left = 8
          Top = 452
          Width = 243
          Height = 84
          Align = alBottom
          TabOrder = 3
          object RECShape: TShape
            Left = 8
            Top = 28
            Width = 13
            Height = 13
            Brush.Color = clRed
            Shape = stCircle
          end
          object RecLabel: TLabel
            Left = 24
            Top = 28
            Width = 26
            Height = 13
            Caption = 'REC'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object btnREC: TButton
            Left = 0
            Top = 9
            Width = 62
            Height = 51
            Cursor = crHandPoint
            Hint = 'FELV'#201'TEL'
            Caption = 'REC'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            OnClick = btnRECClick
          end
          object Button24: TButton
            Left = 64
            Top = 9
            Width = 66
            Height = 51
            Cursor = crHandPoint
            Caption = 'STOP'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
            OnClick = Button24Click
          end
          object btnRUN: TButton
            Left = 136
            Top = 6
            Width = 98
            Height = 26
            Cursor = crHandPoint
            Caption = 'LEJ'#193'TSZ'#193'S'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
            OnClick = btnRUNClick
          end
          object btnSTEP: TButton
            Left = 139
            Top = 34
            Width = 98
            Height = 26
            Cursor = crHandPoint
            Caption = 'L'#201'PTET'#201'S'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
            OnClick = btnSTEPClick
          end
          object cbFromOrigin: TCheckBox
            Left = 68
            Top = 64
            Width = 141
            Height = 17
            Caption = 'Eredeti k'#233'pb'#337'l induljon'
            Checked = True
            State = cbChecked
            TabOrder = 4
          end
        end
      end
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 
      'K'#233'pek|*.bmp;*.jpg; *.cr2;*.tif;*,tiff;*.gif;*.png;*.fit;*.fits|C' +
      'anon RAW|*.cr2|TIF|*.tif; *.tiff|Windows Bitmap|*.bmp|GIF|*.gif|' +
      'Protanle Network Graphic|*.png|FITS |*.fit;*.fits'
    Title = 'K'#233'pek megnyit'#225'sa'
    Left = 192
    Top = 249
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'JPG'
    Filter = 'JPEG|*.jpg|Windows Bitmap|*.bmp'
    Options = [ofHideReadOnly, ofCreatePrompt, ofEnableSizing]
    Left = 260
    Top = 249
  end
  object ImageList1: TImageList
    Left = 192
    Top = 304
    Bitmap = {
      494C01016600B400240210001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000040000000A0010000010020000000000000A0
      0100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000808080008080800080808000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF0080808000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF0080808000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF0080808000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF0080808000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0080808000FFFFFF0080808000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080008080800080808000000000008080800080808000808080008080
      8000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000008080
      800000000000FFFFFF0000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000FFFFFF000000000000000000000000000000000080808000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008080800000000000FFFFFF00000000000000000000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000080808000FFFFFF00000000000000000080808000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000FFFFFF000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF0080808000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080808000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004B4E5100BB8482000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000064707A00BF9E96000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080808000FFFFFF0000000000000000000000
      0000000000000000000000000000000000006C83B800206CF20046659600BB84
      8200000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000063A8F1003879F40060758800C59D
      9500000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000008080800000000000FFFFFF00000000000000
      000000000000000000000000000000000000357CF700357CF700206CF2004665
      9600BB8482000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000559FF500559FF5003879F4006075
      8800C59D95000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF0080808000FFFFFF00000000000000
      00000000000000000000000000000000000000000000357CF700357CF700206C
      F20046659600BB84820000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000559FF500559FF5003879
      F40060758800C59D950000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000008080800000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000357CF700357C
      F700206CF20046659600BB848200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000559FF500559F
      F5003879F40060758800BA9E9600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000080808000FFFFFF00000000000000000080808000FFFFFF000000
      000000000000000000000000000000000000000000000000000000000000357C
      F700357CF700206CF2004B4E5100000000005A5D6000BF8B8500C8A29100BF8F
      870000000000000000000000000000000000000000000000000000000000559F
      F500559FF5003879F400656F7700000000009F928D00C59F9700D3B5A900CFAA
      9F00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000808080000000000000000000000000008080800000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000357CF700AEBDDA0079757400BB848200F4DCA400F9F5CB00F9F5CB00F9F5
      CB00E7CBA000C4998A0000000000000000000000000000000000000000000000
      0000559FF500D0D0D1009F928D00AD9A9200FAEFC800FDF9DA00FDF9DA00FDF9
      DA00F4D6B200D1ADA10000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000FFFFFF000000000000000000000000000000000080808000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000C8A29100CBA79400F7E5B000F9F5CB00A6B6D8004172F600DCE0
      DA00F8F5D800F0EED70079757400000000000000000000000000000000000000
      000000000000CFBDB700D6B9AB00FBEDC400FCF8D700FDF9DA00FDF9DA00FDFA
      DF00FDFAE300F4F1DF00B49C9500000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000000000000000000000808080000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000BB848200F3D8A000F3D8A000F8EEBC006C83B800082AFB00BFCB
      DC00F8F5D800F8F5D800DBBD9D00000000000000000000000000000000000000
      000000000000C59D9500F7E0B200F8E2B200FCF6D400FDF9DA00FDF9E100FDFA
      E300FDFAE300FDFAE300F2D0B400000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF008080
      8000FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000CBA79400F7E1A8006C83B8006C83B800184FF900082AFB005B69
      F9005B69F900CAD3DC00F9F1C200BB8482000000000000000000000000000000
      000000000000D6B9AB00F8E2B200AD9A920063A8F1004584F3004584F3004584
      F3005DA2F200DFE0D700FBF4D100C79F96000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080008080800080808000FFFFFF008080800080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000D8B99B00F7E1A80046659600082AFB00082AFB00082AFB00082A
      FB00082AFB009DAFD500F9F5CB00C19689000000000000000000000000000000
      000000000000F2C9B400F8E2B200356DF7002749FC002749FC002749FC002749
      FC002749FC00CBC8CC00FCF8D700CDA59A000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF0080808000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D0AD9600F7E1A800C0938800C4998A004172F600082AFB008297
      C500B7C4DB00F0EED700F9F3C500BF8B85000000000000000000000000000000
      000000000000D6B9AB00F9E5B700CEA79C00D1B0A50063A8F10063A8F10063A8
      F100D0D0D100F0EFDE00FBF4D100CBA297000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF0080808000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BD878300F7E5B000F7E5B000F3D8A0005E76AA00082AFB00B7C4
      DB00F9F3C500F9F5D100E7CBA000000000000000000000000000000000000000
      000000000000C79F9600FBEDC400FBEDC400F4D6B200F2D0B400F9E5B700FCF6
      D400FCF6D400FDF9DA00F4D9B100000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF0080808000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D4B49900F8F5D800F8F5D800C8A29100C5789100D4B4
      9900F4DCA400F8EEBC00BB848200000000000000000000000000000000000000
      00000000000000000000D6B9AB00FDFAE300FDFAE300F2C9B400F3BFBB00F2D0
      B400F9E5B700FBF3CD00BF9E9600000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF0080808000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D0AD9600F0EED700F7E5B000F7E1A800F7E1
      A800F1D6A000C196890000000000000000000000000000000000000000000000
      0000000000000000000000000000CDBFBD00F4F1DF00FBEDC400F8E2B200F9E5
      B700F5DDB100D1ADA10000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF0080808000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C1968900C1968900D0AD9600CBA7
      9400000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CBA29700CFAA9F00D6B9AB00D6B9
      AB00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000808080008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F007F7F7F00000000007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F00000000007F7F7F007F7F7F00000000000000000000000000000000007F7F
      7F007F7F7F00000000007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F0000000000FFFFFF00FFFFFF007F7F7F000000000000000000000000000000
      000000000F0000000F0000000F000000000000000F0000000000000000000000
      00000F000F000000000000000F0000000F000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007F7F7F000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF007F7F7F007F7F7F007F7F7F00FFFFFF00000000000000000000000F000000
      1F0000002000000010000000100000001F0000001F0000001F00000020001000
      1F0000001F00000020000000500000001F000000000000000000000000007F7F
      7F007F7F7F007F7F7F0000000000000000007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BFBFBF007F7F7F00000000007F7F7F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF007F7F
      7F00000000007F7F7F007F7F7F00FFFFFF000000000000002000000030000000
      300000003F000000400000003000000030000000200000003000000F4F000000
      4F0000009F001F50FF0000002F00000000000000000000000000000000000000
      00007F7F7F00FFFFFF00FFFFFF0000000000000000007F7F7F007F7F7F007F7F
      7F00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BFBF
      BF00BFBFBF00BFBFBF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF007F7F7F000000
      000000000000FFFFFF007F7F7F000000000000001F0000003000000040000000
      6F0000008F000000900000005F0000005F0000005F0000008000100080004FA0
      FF002060FF0000106000000F1F00000F0F000000000000000000000000000000
      00007F7F7F007F7F7F00FFFFFF00FFFFFF00FFFFFF007F7F7F007F7F7F007F7F
      7F00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000080
      8000BFBFBF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF007F7F7F00000000000000
      0000FFFFFF007F7F7F00000000000000000000001F0000002000000050000010
      AF00002FD000003FE0000030CF000F1080002F80FF0040B0FF0060E0FF0040A0
      FF0000109F00000F50000000100000000F000000000000000000000000000000
      00007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000008080000080800000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF007F7F7F000000000000000000FFFF
      FF007F7F7F000000000000000000000000000000200000003000000040000000
      60001F60FF0090FFFF000F0F0F000F0F10000F0F10008FFFFF0070F0FF001F5F
      FF00001F800000105F0000002F00000010000000000000000000000000000000
      0000000000007F7F7F00FFFFFF00FFFFFF007F7F7F007F7F7F007F7F7F00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000008080000080800000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF007F7F7F000000000000000000FFFFFF007F7F
      7F000000000000000000000000000000000000001F000000300000005F000000
      7F000F1FA00060AFB0000F0F1F001010200010102000101F2F0040AFFF000F20
      BF0010309F0030207F00000F5F00000030000000000000000000000000000000
      0000000000007F7F7F007F7F7F00FFFFFF007F7F7F007F7F7F007F7F7F00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008080000080800000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF007F7F7F000000000000000000FFFFFF007F7F7F000000
      0000000000000000000000000000000000000000100000002F0000004F00000F
      50006FF0FF000F0F1F0010102F00101F4F001F1F5F001F1F300090FFFF00207F
      FF000F30C0001F309F0000107F00000F4F000000000000000000000000000000
      0000000000007F7F7F007F7F7F00FFFFFF007F7F7F007F7F7F007F7F7F000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000008080000080800000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF007F7F7F000000000000000000FFFFFF007F7F7F00000000000000
      00000000000000000000000000000000000000001F000000400000008F00104F
      F0007FFFFF007FB0BF001F1F4F0020206000303070006F7F9F0090FFFF00101F
      A0000F2070000F1F5F00000F3F0000102F000000000000000000000000000000
      000000000000000000007F7F7F007F7F7F007F7F7F007F7F7F00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000008080000080800000FFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF007F7F7F000000000000000000FFFFFF007F7F7F0000000000000000000000
      0000000000000000000000000000000000000000100000005000000080002F7F
      FF0050C0FF008FFFFF001F1F50006F6FAF00B0AFD000A0FFFF005FAFFF002010
      AF000F0F6F00000F400000002F00000020000000000000000000000000000000
      000000000000000000007F7F7F007F7F7F007F7F7F007F7F7F00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008080000080800000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF007F7F
      7F0000000000FFFFFF00FFFFFF007F7F7F000000000000000000000000000000
      00000000000000000000000000000000000000001F0000004F000010B000104F
      F00050BFFF007FF0FF0080FFFF008FD0FF00CFE0FF004F80FF002040DF000F10
      900010107000000F40000000300000001F000000000000000000000000000000
      000000000000000000007F7F7F007F7F7F007F7F7F007F7F7F00000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      80000000000000FFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF007F7F7F00FFFF
      FF007F7F7F00FFFFFF007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000100000005F00001FBF000F2F
      D0004FA0FF005FC0FF003F8FFF002F40D0003F3FCF001F1FB000101080000F0F
      6F000F0F4F00000F40000F1030000F101F000000000000000000000000000000
      00000000000000000000000000007F7F7F007F7F7F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF007F7F7F007F7F7F007F7F
      7F00FFFFFF007F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000100000004000000040001F50
      FF002060FF000F2FCF0010106F001F1F8F001F1F7F00101F7F0010105F000F0F
      40000F0F2F00000F200000001F0000000F000000000000000000000000000000
      00000000000000000000000000007F7F7F000000000000000000000000000000
      00000000000000000000000000000000000000000000000080000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000F00000040000F30
      DF000F0F5F000F0F3F000F103F0010105F0010105F0010105F0000000F000F0F
      30000F0F300000000F0000000F0000000F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F007F7F7F007F7F7F007F7F
      7F00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000F0000009F000000
      2000000F1F000F0F1F000F0F20000F0F200000000F0000000F0000000F000000
      0F0000000F0000000F0000000F0000000F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007F7F7F007F7F7F000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000100000000F000000
      0F0000000F00000F0F00000F10000F0F100000000F0000000F0000000F000000
      0F0000000F0000000F0000000F0000000F000000000000000000000000000000
      000000000000FFFFFF007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F000000
      0000FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F007F7F7F00000000000000000000000000FFFFFF00000000007F7F
      7F007F7F7F0000000000FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F00000000000000000000000000000000007F7F7F00FFFFFF00000000000000
      0000000000007F7F7F0000000000FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      FF000000FF000000FF0000000000FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00FFFF
      FF0000000000000000007F7F7F00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00FFFF
      FF00000000000000000000000000000000007F7F7F00FFFFFF00000000000000
      000000000000000000007F7F7F00FFFFFF00000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      FF000000FF000000FF0000000000FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00FFFF
      FF0000000000000000007F7F7F00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00FFFF
      FF00000000000000000000000000000000007F7F7F00FFFFFF00FFFFFF000000
      000000000000000000007F7F7F00FFFFFF000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      FF000000FF000000FF0000000000FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00FFFF
      FF00FFFFFF00FFFFFF007F7F7F00FFFFFF000000000000000000000000000000
      000000000000000000007F7F7F00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00FFFF
      FF000000000000000000000000007F7F7F007F7F7F007F7F7F00FFFFFF000000
      000000000000000000007F7F7F00FFFFFF000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F00000000000000000000000000000000000000
      0000000000007F7F7F0000000000000000000000000000000000000000000000
      00007F7F7F0000000000000000000000000000000000000000007F7F7F00FFFF
      FF000000000000000000000000007F7F7F007F7F7F007F7F7F00000000000000
      000000000000000000007F7F7F00FFFFFF000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F00FFFFFF0000000000000000000000000000000000000000000000
      00007F7F7F00FFFFFF00FFFFFF00000000000000000000000000000000000000
      00000000000000000000000000007F7F7F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F00000000000000000000000000FFFF0000FFFF0000FFFF
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000FFFFFF00FFFFFF007F7F7F00FFFFFF00000000000000
      00007F7F7F00FFFFFF00FFFFFF00FFFFFF000000000000000000000000007F7F
      7F007F7F7F007F7F7F00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000000000007F7F7F00000000000000000000000000000000007F7F
      7F00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF000000000000000000000000007F7F7F00FFFF
      FF007F7F7F00FFFFFF00000000000000000000000000FFFF0000FFFF0000FFFF
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000FFFFFF007F7F7F00FFFFFF00000000000000
      00007F7F7F007F7F7F007F7F7F00FFFFFF00000000007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007F7F7F0000000000FFFFFF0000000000000000007F7F7F00FFFF
      FF007F7F7F00FFFFFF00000000000000000000000000FFFF0000FFFF0000FFFF
      000000000000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F00FFFFFF00FFFFFF00FFFF
      FF007F7F7F00FFFFFF007F7F7F00FFFFFF00FFFFFF007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F00FFFFFF007F7F7F00FFFFFF0000000000000000007F7F7F00FFFF
      FF007F7F7F00FFFFFF0000000000000000000000000000000000000000000000
      000000000000FFFF000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F00000000007F7F7F007F7F7F007F7F7F00FFFFFF00000000007F7F
      7F007F7F7F007F7F7F00FFFFFF00000000000000000000000000000000000000
      00000000000000000000000000007F7F7F0000000000000000007F7F7F000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F00FFFFFF007F7F7F0000000000FFFFFF00FFFFFF007F7F7F000000
      00007F7F7F00FFFFFF000000000000000000000000000000000000000000FFFF
      0000FFFF0000FFFF000000000000FFFF00000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF0000000000000000007F7F7F00FFFF
      FF00FFFFFF00FFFFFF007F7F7F00FFFFFF007F7F7F00FFFFFF00000000007F7F
      7F007F7F7F007F7F7F00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFFFF007F7F7F007F7F7F007F7F7F00000000000000
      00007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFF00000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF0000000000000000007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F00000000007F7F7F00FFFFFF00000000007F7F
      7F007F7F7F007F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007F7F7F0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF007F7F
      7F00000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF0000FFFF00000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      00007F7F7F00FFFFFF00FFFFFF00FFFFFF007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      00007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF007F7F
      7F007F7F7F007F7F7F00FFFFFF00000000000000000000000000000000000000
      00000000000000000000BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F007F7F7F00000000000000000000000000FFFFFF00000000007F7F
      7F007F7F7F0000000000FFFFFF00000000000000000000000000000000000000
      00000000000000000000BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF000000000000000000FFFFFF007F7F7F007F7F
      7F00000000007F7F7F00FFFFFF00000000000000000000000000000000000000
      00007F7F7F007F7F7F00BFBFBF007F7F7F00000000007F7F7F00BFBFBF007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000007F7F
      7F00000000000000000000000000000000007F7F7F00FFFFFF00000000000000
      0000000000007F7F7F0000000000FFFFFF000000000000000000000000000000
      00007F7F7F007F7F7F00BFBFBF007F7F7F00000000007F7F7F00BFBFBF007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000007F7F7F00FFFFFF0000000000FFFFFF007F7F7F007F7F7F000000
      00007F7F7F007F7F7F000000000000000000000000000000000000000000BFBF
      BF00BFBFBF00BFBFBF00BFBFBF007F7F7F00000000007F7F7F00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00000000000000000000000000000000007F7F7F00FFFF
      FF00000000000000000000000000000000007F7F7F00FFFFFF00000000000000
      000000000000000000007F7F7F00FFFFFF00000000000000000000000000BFBF
      BF00BFBFBF00BFBFBF00BFBFBF007F7F7F00000000007F7F7F00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF0000000000000000000000000000000000000000000000
      0000000000007F7F7F007F7F7F00FFFFFF007F7F7F007F7F7F00000000007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000007F7F
      7F007F7F7F007F7F7F00BFBFBF00BFBFBF0000000000BFBFBF00BFBFBF007F7F
      7F007F7F7F007F7F7F00000000000000000000000000000000007F7F7F00FFFF
      FF00000000000000000000000000000000007F7F7F00FFFFFF00FFFFFF000000
      000000000000000000007F7F7F00FFFFFF000000000000000000000000007F7F
      7F007F7F7F007F7F7F00BFBFBF00BFBFBF0000000000BFBFBF00BFBFBF007F7F
      7F007F7F7F007F7F7F0000000000000000000000000000000000000000000000
      0000000000007F7F7F00000000007F7F7F007F7F7F00000000007F7F7F007F7F
      7F0000000000000000000000000000000000000000000000000000000000BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00000000000000000000000000BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00000000000000000000000000000000007F7F7F00FFFF
      FF000000000000000000000000007F7F7F007F7F7F007F7F7F00FFFFFF000000
      000000000000000000007F7F7F00FFFFFF00000000000000000000000000BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00000000000000000000000000BFBFBF00BFBF
      BF00BFBFBF00BFBFBF0000000000000000000000000000000000000000000000
      00007F7F7F00FFFFFF000000000000000000000000007F7F7F007F7F7F000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F007F7F7F007F7F7F007F7F7F000000000000000000000000007F7F7F007F7F
      7F007F7F7F007F7F7F00000000000000000000000000000000007F7F7F00FFFF
      FF000000000000000000000000007F7F7F007F7F7F007F7F7F00000000000000
      000000000000000000007F7F7F00FFFFFF000000000000000000000000007F7F
      7F007F7F7F007F7F7F007F7F7F000000000000000000000000007F7F7F007F7F
      7F007F7F7F007F7F7F0000000000000000000000000000000000000000000000
      00007F7F7F00000000000000000000000000000000007F7F7F00FFFFFF000000
      000000000000000000000000000000000000000000000000000000000000BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00000000000000000000000000000000007F7F7F000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007F7F7F000000000000FFFF000000000000000000BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF0000000000000000000000000000000000000000007F7F
      7F00FFFFFF0000000000000000000000000000000000FFFFFF007F7F7F00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F0000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F00000000000000000000000000FFFFFF00FFFFFF007F7F7F007F7F7F007F7F
      7F00000000000000000000000000000000000000000000000000000000000000
      000000000000BFBFBF000000000000000000000000000000000000000000BFBF
      BF00000000000000000000000000000000000000000000000000000000000000
      00007F7F7F00FFFFFF007F7F7F00FFFFFF0000000000000000007F7F7F00FFFF
      FF007F7F7F00FFFFFF000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF000000000000000000000000000000000000000000BFBF
      BF000000000000000000000000000000000000000000000000007F7F7F00FFFF
      FF0000000000FFFFFF00FFFFFF007F7F7F007F7F7F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BFBFBF000000000000000000000000000000000000000000BFBF
      BF00000000000000000000000000000000000000000000000000000000000000
      00007F7F7F00FFFFFF007F7F7F00FFFFFF0000000000000000007F7F7F00FFFF
      FF007F7F7F00FFFFFF00000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF007F7F7F00000000007F7F7F0000FFFF0000FFFF000000000000000000BFBF
      BF000000000000000000000000000000000000000000000000007F7F7F00FFFF
      FF00FFFFFF007F7F7F007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BFBFBF000000000000000000000000000000000000000000BFBF
      BF00000000000000000000000000000000000000000000000000000000000000
      00007F7F7F00FFFFFF007F7F7F0000000000FFFFFF00FFFFFF007F7F7F000000
      00007F7F7F00FFFFFF000000000000000000000000000000000000FFFF0000FF
      FF0000000000BFBFBF000000000000000000000000000000000000000000BFBF
      BF0000000000000000000000000000000000000000007F7F7F00FFFFFF007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F007F7F7F00BFBFBF00000000000000000000000000BFBFBF007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFFFF007F7F7F007F7F7F007F7F7F00000000000000
      00007F7F7F000000000000000000000000000000000000FFFF000000000000FF
      FF0000000000BFBFBF000000000000000000000000000000000000000000BFBF
      BF0000000000000000000000000000000000000000007F7F7F007F7F7F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007F7F7F0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF007F7F
      7F000000000000000000000000000000000000FFFF00000000000000000000FF
      FF007F7F7F007F7F7F00BFBFBF00000000000000000000000000BFBFBF007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF000000000000000000BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F00000000007F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      0000000000007F7F7F000000000000000000000000007F7F7F00000000000000
      FF00000000007F7F7F0000000000000000000000000000000000000000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F00000000000000FF000000
      00007F7F7F000000000000000000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF0080000000800000008000000080000000800000008000
      00008000000080000000FFFFFF00800000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      000000000000000000000000FF0000000000000000000000FF00000000007F7F
      7F00000000000000000000000000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF0080000000800000008000000080000000800000008000
      0000800000008000000080000000800000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000FFFFFF008000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF00000000007F7F7F000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00800000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000080000000FFFFFF008000
      000080000000800000008000000080000000800000008000000080000000FFFF
      FF00800000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF0000000000000000007F7F
      7F00000000000000000000000000000000000000000080000000FFFFFF008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00800000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000FFFFFF008000000000000000000000000000000080000000800000008000
      00008000000080000000FFFFFF00800000008000000080000000800000008000
      0000FFFFFF0080000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      00008000000080000000800000008000000080000000FFFFFF00800000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E2EFF100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E2EFF100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000993300000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000999999000000
      000000000000000000000000000000000000000000000000000000000000E2EF
      F100E5E5E500CCCCCC00E5E5E500E2EFF1000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E2EF
      F10000000000CCCCCC00E5E5E500E2EFF1000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000993300009933
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000999999009999
      99000000000000000000000000000000000000000000E2EFF100E5E5E500B2B2
      B200CC9999009966660099666600B2B2B200CCCCCC00E5E5E500E2EFF1000000
      00000000000000000000000000000000000000000000E2EFF10000000000B2B2
      B200999999009999990099999900B2B2B200CCCCCC0000000000E2EFF1000000
      0000000000000000000000000000000000000000000000000000000000009933
      0000993300009933000099330000993300009933000099330000993300009933
      0000993300000000000000000000000000000000000000000000000000009999
      9900999999009999990099999900999999009999990099999900999999009999
      990099999900000000000000000000000000E5E5E500CC99990099666600CC99
      9900CC999900FFFFFF00996666009999990099999900B2B2B200E5E5E5000000
      0000000000000000000000000000000000000000000099999900999999009999
      990099999900FFFFFF00999999009999990099999900B2B2B200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000993300009933
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000999999009999
      99000000000000000000000000000000000099666600CC999900FFCC9900FFCC
      9900FFCCCC00FFFFFF0099666600336699003366990033669900E2EFF1000000
      0000000000000000000000000000000000009999990099999900C0C0C000C0C0
      C000CCCCCC00FFFFFF0099999900999999009999990099999900E2EFF1000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000993300000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000999999000000
      00000000000000000000000000000000000099666600FFCC9900FFCC9900FFCC
      9900FFCCCC00FFFFFF009966660066CCCC0066CCCC000099CC00FFFFFF00FFCC
      CC000000000000000000000000000000000099999900C0C0C000C0C0C000C0C0
      C000CCCCCC00FFFFFF0099999900C0C0C000C0C0C00099999900FFFFFF00CCCC
      CC00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000099666600FFCC9900FFCC9900FFCC
      9900FFCCCC00FFFFFF009966660066CCCC0066CCFF003399CC00FFCCCC00CC66
      00000000000000000000000000000000000099999900C0C0C000C0C0C000C0C0
      C000CCCCCC00FFFFFF0099999900C0C0C000CCCCCC0099999900CCCCCC009999
      990000000000000000000000000000000000CC996600CC996600CC996600CC99
      6600CC996600CC996600CC99660000000000000000003399CC00006699000066
      9900006699000066990000669900006699009999990099999900999999009999
      9900999999009999990099999900000000000000000099999900999999009999
      99009999990099999900999999009999990099666600FFCC9900CC999900CC99
      6600FFCCCC00FFFFFF009966660099CCCC0099CCFF00B2B2B200FF660000CC66
      00000000000000000000000000000000000099999900C0C0C000999999009999
      9900CCCCCC00FFFFFF0099999900CCCCCC00CCCCCC00B2B2B200999999009999
      990000000000000000000000000000000000CC996600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00CC99660000000000000000003399CC0099FFFF0099FF
      FF0099FFFF0099FFFF0099FFFF00006699009999990000000000000000000000
      0000000000000000000099999900000000000000000099999900CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CCCCCC009999990099666600FFCC990099666600FFFF
      FF00FFCCCC00FFFFFF009966660099CCCC00C0C0C000CC660000CC660000CC66
      0000CC660000CC660000CC6600000000000099999900C0C0C00066666600FFFF
      FF00CCCCCC00FFFFFF0099999900CCCCCC00C0C0C00099999900999999009999
      990099999900999999009999990000000000CC996600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00CC99660000000000000000003399CC0099FFFF0099FF
      FF0099FFFF0099FFFF0099FFFF00006699009999990000000000000000000000
      0000000000000000000099999900000000000000000099999900CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CCCCCC009999990099666600FFCC9900CC9999009966
      6600FFCCCC00FFFFFF009966660000000000CC660000CC660000CC660000CC66
      0000CC660000CC660000CC6600000000000099999900C0C0C000999999006666
      6600CCCCCC00FFFFFF0099999900E5E5E5009999990099999900999999009999
      990099999900999999009999990000000000CC996600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00CC99660000000000000000003399CC0099FFFF0099FF
      FF0099FFFF0099FFFF0099FFFF00006699009999990000000000000000000000
      0000000000000000000099999900000000000000000099999900CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CCCCCC009999990099666600FFCC9900FFCC9900FFCC
      9900FFCCCC00FFFFFF009966660000000000CC999900CC660000CC660000CC66
      0000CC660000CC660000CC6600000000000099999900C0C0C000C0C0C000C0C0
      C000CCCCCC00FFFFFF0099999900E5E5E5009999990099999900999999009999
      990099999900999999009999990000000000CC996600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00CC99660000000000000000003399CC0099FFFF0099FF
      FF0099FFFF0099FFFF0099FFFF00006699009999990000000000000000000000
      0000000000000000000099999900000000000000000099999900CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CCCCCC009999990099666600FFCC9900FFCC9900FFCC
      9900FFCCCC00FFFFFF0099666600CCCCCC00E2EFF100CC999900FF660000CC66
      00000000000000000000000000000000000099999900C0C0C000C0C0C000C0C0
      C000CCCCCC00FFFFFF0099999900CCCCCC00E2EFF10099999900999999009999
      990000000000000000000000000000000000CC996600FFFFFF00FFFFFF00CC99
      6600CC996600CC996600CC99660000000000000000003399CC0099FFFF0099FF
      FF003399CC003399CC003399CC003399CC009999990000000000000000009999
      9900999999009999990099999900000000000000000099999900CCCCCC00CCCC
      CC009999990099999900999999009999990099666600FFCC9900FFCC9900FFCC
      9900FFCCCC00FFFFFF009966660099CCCC000000000099CCCC00FFCC9900CC66
      00000000000000000000000000000000000099999900C0C0C000C0C0C000C0C0
      C000CCCCCC00FFFFFF0099999900CCCCCC00E5E5E500CCCCCC00C0C0C0009999
      990000000000000000000000000000000000CC996600FFFFFF00FFFFFF00CC99
      6600E5E5E500CC9966000000000000000000000000003399CC0099FFFF0099FF
      FF003399CC00CCFFFF0000669900000000009999990000000000000000009999
      9900E5E5E5009999990000000000000000000000000099999900CCCCCC00CCCC
      CC0099999900CCCCCC00999999000000000099666600CC999900FFCC9900FFCC
      9900FFCCCC00FFFFFF0099666600CCCCCC00000000003399CC0000000000FFCC
      9900000000000000000000000000000000009999990099999900C0C0C000C0C0
      C000CCCCCC00FFFFFF0099999900CCCCCC00E5E5E5009999990000000000C0C0
      C00000000000000000000000000000000000CC996600FFFFFF00FFFFFF00CC99
      6600CC996600000000000000000000000000000000003399CC0099FFFF0099FF
      FF003399CC000066990000000000000000009999990000000000000000009999
      9900999999000000000000000000000000000000000099999900CCCCCC00CCCC
      CC009999990099999900000000000000000000000000C0C0C000CC996600CC99
      9900CCCC9900FFFFFF00996666000099CC000099CC000099CC00000000000000
      00000000000000000000000000000000000000000000C0C0C000999999009999
      9900C0C0C000FFFFFF0099999900999999009999990099999900000000000000
      000000000000000000000000000000000000CC996600CC996600CC996600CC99
      660000000000000000000000000000000000000000003399CC003399CC003399
      CC003399CC000000000000000000000000009999990099999900999999009999
      9900000000000000000000000000000000000000000099999900999999009999
      990099999900000000000000000000000000000000000000000000000000CCCC
      CC00CC9999009966660099666600000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CCCC
      CC00999999009999990099999900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000099330000993300000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000099999900999999000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000099330000CC6600009933
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000099999900CCCCCC009999
      9900000000000000000000000000000000000000000000000000000000000000
      0000000000009933000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009999990000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CC996600CC996600CC996600CC99
      6600CC996600CC996600CC996600CC996600CC99660099330000CC660000CC66
      0000993300000000000000000000000000009999990099999900999999009999
      9900999999009999990099999900999999009999990099999900CCCCCC00CCCC
      CC00999999000000000000000000000000000000000000000000000000000000
      0000993300009933000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000999999009999990000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CC996600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0099330000CC660000CC66
      0000CC6600009933000000000000000000009999990000000000000000000000
      0000000000000000000000000000000000000000000099999900CCCCCC00CCCC
      CC00CCCCCC009999990000000000000000000000000000000000000000009933
      0000993300009933000099330000993300009933000099330000993300009933
      0000993300000000000000000000000000000000000000000000000000009999
      9900999999009999990099999900999999009999990099999900999999009999
      990099999900000000000000000000000000CC996600FFFFFF00E5E5E500E5E5
      E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E50099330000CC660000CC66
      0000CC660000CC66000099330000000000009999990000000000CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC0099999900CCCCCC00CCCC
      CC00CCCCCC00CCCCCC0099999900000000000000000000000000000000000000
      0000993300009933000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000999999009999990000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CC996600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0099330000CC660000CC66
      0000CC660000CC660000CC660000993300009999990000000000000000000000
      0000000000000000000000000000000000000000000099999900CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00999999000000000000000000000000000000
      0000000000009933000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009999990000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CC996600FFFFFF00E5E5E500E5E5
      E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E50099330000CC660000CC66
      0000CC660000CC66000099330000000000009999990000000000CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC0099999900CCCCCC00CCCC
      CC00CCCCCC00CCCCCC0099999900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CC996600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0099330000CC660000CC66
      0000CC6600009933000000000000000000009999990000000000000000000000
      0000000000000000000000000000000000000000000099999900CCCCCC00CCCC
      CC00CCCCCC009999990000000000000000003399CC0000669900006699000066
      99000066990000669900006699000000000000000000CC996600CC996600CC99
      6600CC996600CC996600CC996600CC9966009999990099999900999999009999
      9900999999009999990099999900000000000000000099999900999999009999
      990099999900999999009999990099999900CC996600FFFFFF00E5E5E500E5E5
      E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E50099330000CC660000CC66
      0000993300000000000000000000000000009999990000000000CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC0099999900CCCCCC00CCCC
      CC00999999000000000000000000000000003399CC0099FFFF0099FFFF0099FF
      FF0099FFFF0099FFFF00006699000000000000000000CC996600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00CC99660099999900CCCCCC00CCCCCC00CCCC
      CC00CCCCCC00CCCCCC0099999900000000000000000099999900000000000000
      000000000000000000000000000099999900CC996600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0099330000CC6600009933
      0000000000000000000000000000000000009999990000000000000000000000
      0000000000000000000000000000000000000000000099999900CCCCCC009999
      9900000000000000000000000000000000003399CC0099FFFF0099FFFF0099FF
      FF0099FFFF0099FFFF00006699000000000000000000CC996600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00CC99660099999900CCCCCC00CCCCCC00CCCC
      CC00CCCCCC00CCCCCC0099999900000000000000000099999900000000000000
      000000000000000000000000000099999900CC996600FFFFFF00E5E5E500E5E5
      E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E5009933000099330000CC99
      6600000000000000000000000000000000009999990000000000CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC0099999900999999009999
      9900000000000000000000000000000000003399CC0099FFFF0099FFFF0099FF
      FF0099FFFF0099FFFF00006699000000000000000000CC996600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00CC99660099999900CCCCCC00CCCCCC00CCCC
      CC00CCCCCC00CCCCCC0099999900000000000000000099999900000000000000
      000000000000000000000000000099999900CC996600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CC99
      6600000000000000000000000000000000009999990000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009999
      9900000000000000000000000000000000003399CC0099FFFF0099FFFF0099FF
      FF0099FFFF0099FFFF00006699000000000000000000CC996600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00CC99660099999900CCCCCC00CCCCCC00CCCC
      CC00CCCCCC00CCCCCC0099999900000000000000000099999900000000000000
      000000000000000000000000000099999900CC996600FFFFFF00E5E5E500E5E5
      E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500FFFFFF00CC99
      6600000000000000000000000000000000009999990000000000CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00000000009999
      9900000000000000000000000000000000003399CC0099FFFF0099FFFF003399
      CC003399CC003399CC003399CC000000000000000000CC996600FFFFFF00FFFF
      FF00CC996600CC996600CC996600CC99660099999900CCCCCC00CCCCCC009999
      9900999999009999990099999900000000000000000099999900000000000000
      000099999900999999009999990099999900CC996600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CC99
      6600000000000000000000000000000000009999990000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009999
      9900000000000000000000000000000000003399CC0099FFFF0099FFFF003399
      CC00CCFFFF0000669900000000000000000000000000CC996600FFFFFF00FFFF
      FF00CC996600E5E5E500CC9966000000000099999900CCCCCC00CCCCCC009999
      9900CCCCCC009999990000000000000000000000000099999900000000000000
      000099999900E5E5E5009999990000000000CC996600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CC99
      6600000000000000000000000000000000009999990000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009999
      9900000000000000000000000000000000003399CC0099FFFF0099FFFF003399
      CC000066990000000000000000000000000000000000CC996600FFFFFF00FFFF
      FF00CC996600CC996600000000000000000099999900CCCCCC00CCCCCC009999
      9900999999000000000000000000000000000000000099999900000000000000
      000099999900999999000000000000000000CC996600CC996600CC996600CC99
      6600CC996600CC996600CC996600CC996600CC996600CC996600CC996600CC99
      6600000000000000000000000000000000009999990099999900999999009999
      9900999999009999990099999900999999009999990099999900999999009999
      9900000000000000000000000000000000003399CC003399CC003399CC003399
      CC000000000000000000000000000000000000000000CC996600CC996600CC99
      6600CC9966000000000000000000000000009999990099999900999999009999
      9900000000000000000000000000000000000000000099999900999999009999
      9900999999000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000CC99990099330000CC9999000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000CCCCCC0099999900CCCCCC000000000000000000000000000000
      0000000000009999990099999900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009999990099999900000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CC996600CC996600CC99
      6600CC996600CC996600CC996600CC996600CC996600CC996600CC996600CC99
      6600CC9999009933000099330000993300000000000099999900999999009999
      9900999999009999990099999900999999009999990099999900999999009999
      9900CCCCCC009999990099999900999999000000000000000000000000000000
      000099999900CC66000099999900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000099999900CCCCCC0099999900000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CC996600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000993300009933000099330000CC9999000000000099999900000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000999999009999990099999900CCCCCC000000000000000000000000009999
      9900CC660000CC66000099999900CC996600CC996600CC996600CC996600CC99
      6600CC996600CC996600CC996600CC9966000000000000000000000000009999
      9900CCCCCC00CCCCCC0099999900999999009999990099999900999999009999
      99009999990099999900999999009999990000000000CC996600FFFFFF00E5E5
      E500E5E5E500E5E5E500E5E5E500E5E5E5008080800080808000808080009933
      00009933000099330000CC99990000000000000000009999990000000000CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC008080800080808000808080009999
      99009999990099999900CCCCCC0000000000000000000000000099999900CC66
      0000CC660000CC66000099999900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00CC996600000000000000000099999900CCCC
      CC00CCCCCC00CCCCCC0099999900000000000000000000000000000000000000
      00000000000000000000000000009999990000000000CC996600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E5E5E50099996600FFFFCC00FFFFCC00FFFFFF00CCCC
      990099330000CC99990000000000000000000000000099999900000000000000
      00000000000000000000CCCCCC0099999900E5E5E500E5E5E500FFFFFF00E5E5
      E50099999900CCCCCC0000000000000000000000000099999900CC660000CC66
      0000CC660000CC66000099999900E5E5E500E5E5E500E5E5E500E5E5E500E5E5
      E500E5E5E500E5E5E500FFFFFF00CC9966000000000099999900CCCCCC00CCCC
      CC00CCCCCC00CCCCCC0099999900CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00000000009999990000000000CC996600FFFFFF00E5E5
      E500E5E5E500E5E5E50099999900F2EABF00FFFFCC00FFFFCC00FFFFCC00FFFF
      FF0066666600000000000000000000000000000000009999990000000000CCCC
      CC00CCCCCC00CCCCCC0099999900E5E5E500E5E5E500E5E5E500E5E5E500FFFF
      FF006666660000000000000000000000000099999900CC660000CC660000CC66
      0000CC660000CC66000099999900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00CC99660099999900CCCCCC00CCCCCC00CCCC
      CC00CCCCCC00CCCCCC0099999900000000000000000000000000000000000000
      00000000000000000000000000009999990000000000CC996600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0099999900F2EABF00FFFFFF00F2EABF00FFFFCC00FFFF
      CC00666666000000000000000000000000000000000099999900000000000000
      0000000000000000000099999900E5E5E500FFFFFF00E5E5E500E5E5E500E5E5
      E500666666000000000000000000000000000000000099999900CC660000CC66
      0000CC660000CC66000099999900E5E5E500E5E5E500E5E5E500E5E5E500E5E5
      E500E5E5E500E5E5E500FFFFFF00CC9966000000000099999900CCCCCC00CCCC
      CC00CCCCCC00CCCCCC0099999900CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00000000009999990000000000CC996600FFFFFF00E5E5
      E500E5E5E500E5E5E50099999900F2EABF00FFFFFF00FFFFFF00F2EABF00FFFF
      CC0066666600000000000000000000000000000000009999990000000000CCCC
      CC00CCCCCC00CCCCCC0099999900E5E5E500FFFFFF00FFFFFF00E5E5E500E5E5
      E50066666600000000000000000000000000000000000000000099999900CC66
      0000CC660000CC66000099999900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00CC996600000000000000000099999900CCCC
      CC00CCCCCC00CCCCCC0099999900000000000000000000000000000000000000
      00000000000000000000000000009999990000000000CC996600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0099999900F2EABF00F2EABF00F2EABF009999
      6600808080000000000000000000000000000000000099999900000000000000
      000000000000000000000000000099999900E5E5E500E5E5E500E5E5E5009999
      9900808080000000000000000000000000000000000000000000000000009999
      9900CC660000CC66000099999900E5E5E500E5E5E500E5E5E500E5E5E500E5E5
      E500E5E5E500E5E5E500FFFFFF00CC9966000000000000000000000000009999
      9900CCCCCC00CCCCCC0099999900CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00000000009999990000000000CC996600FFFFFF00E5E5
      E500E5E5E500E5E5E500E5E5E500E5E5E500999999009999990099999900E5E5
      E500CC996600000000000000000000000000000000009999990000000000CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00999999009999990099999900E5E5
      E500999999000000000000000000000000000000000000000000000000000000
      000099999900CC66000099999900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00CC9966000000000000000000000000000000
      000099999900CCCCCC0099999900000000000000000000000000000000000000
      00000000000000000000000000009999990000000000CC996600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00CC9966000000000000000000000000000000000099999900000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000999999000000000000000000000000000000000000000000000000000000
      0000CC9966009999990099999900E5E5E500E5E5E500E5E5E500E5E5E500E5E5
      E500E5E5E500E5E5E500FFFFFF00CC9966000000000000000000000000000000
      0000999999009999990099999900CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00000000009999990000000000CC996600FFFFFF00E5E5
      E500E5E5E500E5E5E500E5E5E500E5E5E500FFFFFF00CC996600CC996600CC99
      6600CC996600000000000000000000000000000000009999990000000000CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC000000000099999900999999009999
      9900999999000000000000000000000000000000000000000000000000000000
      0000CC996600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00CC9966000000000000000000000000000000
      0000999999000000000000000000000000000000000000000000000000000000
      00000000000000000000000000009999990000000000CC996600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CC996600E5E5E500CC99
      6600000000000000000000000000000000000000000099999900000000000000
      0000000000000000000000000000000000000000000099999900E5E5E5009999
      9900000000000000000000000000000000000000000000000000000000000000
      0000CC996600FFFFFF00E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5
      E500E5E5E500E5E5E500FFFFFF00CC9966000000000000000000000000000000
      00009999990000000000CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00000000009999990000000000CC996600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CC996600CC9966000000
      0000000000000000000000000000000000000000000099999900000000000000
      0000000000000000000000000000000000000000000099999900999999000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CC996600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00CC9966000000000000000000000000000000
      0000999999000000000000000000000000000000000000000000000000000000
      00000000000000000000000000009999990000000000CC996600CC996600CC99
      6600CC996600CC996600CC996600CC996600CC996600CC996600000000000000
      0000000000000000000000000000000000000000000099999900999999009999
      9900999999009999990099999900999999009999990099999900000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CC996600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00CC9966000000000000000000000000000000
      0000999999000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000999999000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CC996600CC996600CC996600CC996600CC996600CC996600CC996600CC99
      6600CC996600CC996600CC996600CC9966000000000000000000000000000000
      0000999999009999990099999900999999009999990099999900999999009999
      9900999999009999990099999900999999000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      9900000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000009999
      9900000000000000000000000000000000000000000000000000000000000000
      00000000000000000000CCCCCC00000000000000000000000000993300009933
      0000993300009933000099330000993300009933000099330000993300009933
      0000993300000000000000000000000000000000000000000000999999009999
      9900999999009999990099999900999999009999990099999900999999009999
      99009999990000000000000000000000000000000000000000003333CC000000
      FF00000099000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000099999900CCCC
      CC00999999000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CC996600FFCC9900FFCC
      9900FFCC9900FFCC9900FFCC9900FFCC9900FFCC9900FFCC9900FFCC9900CC99
      6600CC99660099330000000000000000000000000000B2B2B200CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00B2B2
      B200B2B2B20099999900000000000000000000000000000000003333CC003399
      FF000000FF000000990000000000000000000000000000000000000000000000
      0000000000000000FF000000000000000000000000000000000099999900E5E5
      E500CCCCCC009999990000000000000000000000000000000000000000000000
      000000000000CCCCCC000000000000000000CC996600CC996600CC996600CC99
      6600CC996600CC996600CC996600CC996600CC996600CC996600CC996600CC99
      660099330000CC9966009933000000000000B2B2B200B2B2B200B2B2B200B2B2
      B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2
      B20099999900B2B2B20099999900000000000000000000000000000000003333
      CC000066FF000000CC0000000000000000000000000000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000009999
      9900E5E5E5009999990000000000000000000000000000000000000000000000
      0000CCCCCC00000000000000000000000000CC996600FFFFFF00FFCC9900FFCC
      9900FFCC9900FFCC9900FFCC9900FFCC9900FFCC9900FFCC9900FFCC9900FFCC
      9900CC996600993300009933000000000000B2B2B20000000000CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCC
      CC00B2B2B2009999990099999900000000000000000000000000000000000000
      00000000CC000000FF0000009900000000000000000000000000000000000000
      FF00000099000000000000000000000000000000000000000000000000000000
      000099999900CCCCCC009999990000000000000000000000000000000000CCCC
      CC0099999900000000000000000000000000CC996600FFFFFF00FFCC9900FFCC
      9900FFCC9900FFCC990000CC000000990000FFCC99000000FF000000CC00FFCC
      9900CC996600CC9966009933000000000000B2B2B20000000000CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00B2B2B20099999900CCCCCC00B2B2B20099999900CCCC
      CC00B2B2B200B2B2B20099999900000000000000000000000000000000000000
      0000000000000000CC000000FF000000990000000000000000000000FF000000
      9900000000000000000000000000000000000000000000000000000000000000
      00000000000099999900CCCCCC00999999000000000000000000CCCCCC009999
      990000000000000000000000000000000000CC996600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00CC996600CC996600CC99660099330000B2B2B20000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B2B2B200B2B2B200B2B2B200999999000000000000000000000000000000
      000000000000000000000000CC000000FF00000099000000FF00000099000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000099999900CCCCCC0099999900CCCCCC00999999000000
      000000000000000000000000000000000000CC996600FFFFFF00FFCC9900FFCC
      9900FFCC9900FFCC9900FFCC9900FFCC9900FFCC9900FFCC9900FFCC9900FFCC
      9900CC996600CC996600CC99660099330000B2B2B20000000000CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCC
      CC00B2B2B200B2B2B200B2B2B200999999000000000000000000000000000000
      00000000000000000000000000000000CC000000FF0000009900000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000099999900CCCCCC0099999900000000000000
      00000000000000000000000000000000000000000000CC996600CC996600CC99
      6600CC996600CC996600CC996600CC996600CC996600CC996600CC996600FFCC
      9900FFCC9900CC996600CC9966009933000000000000B2B2B200B2B2B200B2B2
      B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2B200CCCC
      CC00CCCCCC00B2B2B200B2B2B200999999000000000000000000000000000000
      000000000000000000000000CC000000FF00000099000000CC00000099000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000099999900CCCCCC009999990099999900999999000000
      0000000000000000000000000000000000000000000000000000CC996600FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CC99
      6600FFCC9900FFCC9900CC996600993300000000000000000000B2B2B2000000
      000000000000000000000000000000000000000000000000000000000000B2B2
      B200CCCCCC00CCCCCC00B2B2B200999999000000000000000000000000000000
      0000000000000000CC000000FF000000990000000000000000000000CC000000
      9900000000000000000000000000000000000000000000000000000000000000
      00000000000099999900CCCCCC00999999000000000000000000999999009999
      990000000000000000000000000000000000000000000000000000000000CC99
      6600FFFFFF00E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500FFFFFF00CC99
      6600CC996600CC9966009933000000000000000000000000000000000000B2B2
      B20000000000CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC0000000000B2B2
      B200B2B2B200B2B2B20099999900000000000000000000000000000000000000
      CC000000FF000000FF0000009900000000000000000000000000000000000000
      CC00000099000000000000000000000000000000000000000000000000009999
      9900CCCCCC00CCCCCC0099999900000000000000000000000000000000009999
      990099999900000000000000000000000000000000000000000000000000CC99
      6600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00CC996600000000000000000000000000000000000000000000000000B2B2
      B200000000000000000000000000000000000000000000000000000000000000
      0000B2B2B20000000000000000000000000000000000000000000000CC003399
      FF000000FF000000990000000000000000000000000000000000000000000000
      00000000CC00000099000000000000000000000000000000000099999900E5E5
      E500CCCCCC009999990000000000000000000000000000000000000000000000
      0000999999009999990000000000000000000000000000000000000000000000
      0000CC996600FFFFFF00E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500FFFF
      FF00CC9966000000000000000000000000000000000000000000000000000000
      0000B2B2B20000000000CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC000000
      0000B2B2B2000000000000000000000000000000000000000000666699000000
      CC00666699000000000000000000000000000000000000000000000000000000
      000000000000000000000000CC00000000000000000000000000CCCCCC009999
      9900CCCCCC000000000000000000000000000000000000000000000000000000
      0000000000000000000099999900000000000000000000000000000000000000
      0000CC996600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00CC99660000000000000000000000000000000000000000000000
      0000B2B2B2000000000000000000000000000000000000000000000000000000
      000000000000B2B2B20000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000CC996600CC996600CC996600CC996600CC996600CC996600CC99
      6600CC996600CC99660000000000000000000000000000000000000000000000
      000000000000B2B2B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2
      B200B2B2B200B2B2B20000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009933
      0000993300009933000099330000993300009933000099330000993300009933
      0000993300009933000099330000993300000000000000000000000000009999
      9900999999009999990099999900999999009999990099999900999999009999
      9900999999009999990099999900999999000000000000000000993300009933
      0000993300009933000099330000993300009933000099330000993300009933
      0000993300009933000099330000000000000000000000000000999999009999
      9900999999009999990099999900999999009999990099999900999999009999
      990099999900999999009999990000000000000000000000000099330000CC66
      0000CC66000099330000E5E5E500CC66000099330000E5E5E500E5E5E500E5E5
      E50099330000CC660000CC66000099330000000000000000000099999900CCCC
      CC00CCCCCC0099999900E5E5E500CCCCCC0099999900E5E5E500E5E5E500E5E5
      E50099999900CCCCCC00CCCCCC00999999000000000099330000CC660000CC66
      000099330000E5E5E500CC66000099330000E5E5E500E5E5E500E5E5E5009933
      0000CC660000CC66000099330000000000000000000099999900CCCCCC00CCCC
      CC0099999900E5E5E500CCCCCC0099999900E5E5E500E5E5E500E5E5E5009999
      9900CCCCCC00CCCCCC009999990000000000000000009933000099330000CC66
      0000CC66000099330000E5E5E500CC66000099330000E5E5E500E5E5E500E5E5
      E50099330000CC660000CC66000099330000000000009999990099999900CCCC
      CC00CCCCCC0099999900E5E5E500CCCCCC0099999900E5E5E500E5E5E500E5E5
      E50099999900CCCCCC00CCCCCC00999999000000000099330000CC660000CC66
      000099330000E5E5E500CC66000099330000E5E5E500E5E5E500E5E5E5009933
      0000CC660000CC66000099330000000000000000000099999900CCCCCC00CCCC
      CC0099999900E5E5E500CCCCCC0099999900E5E5E500E5E5E500E5E5E5009999
      9900CCCCCC00CCCCCC00999999000000000099330000CC66000099330000CC66
      0000CC66000099330000E5E5E500CC66000099330000E5E5E500E5E5E500E5E5
      E50099330000CC660000CC6600009933000099999900CCCCCC0099999900CCCC
      CC00CCCCCC0099999900E5E5E500CCCCCC0099999900E5E5E500E5E5E500E5E5
      E50099999900CCCCCC00CCCCCC00999999000000000099330000CC660000CC66
      000099330000E5E5E500CC66000099330000E5E5E500E5E5E500E5E5E5009933
      0000CC660000CC66000099330000000000000000000099999900CCCCCC00CCCC
      CC0099999900E5E5E500CCCCCC0099999900E5E5E500E5E5E500E5E5E5009999
      9900CCCCCC00CCCCCC00999999000000000099330000CC66000099330000CC66
      0000CC66000099330000E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5
      E50099330000CC660000CC6600009933000099999900CCCCCC0099999900CCCC
      CC00CCCCCC0099999900E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5
      E50099999900CCCCCC00CCCCCC00999999000000000099330000CC660000CC66
      000099330000E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E5009933
      0000CC660000CC66000099330000000000000000000099999900CCCCCC00CCCC
      CC0099999900E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E5009999
      9900CCCCCC00CCCCCC00999999000000000099330000CC66000099330000CC66
      0000CC660000CC66000099330000993300009933000099330000993300009933
      0000CC660000CC660000CC6600009933000099999900CCCCCC0099999900CCCC
      CC00CCCCCC00CCCCCC0099999900999999009999990099999900999999009999
      9900CCCCCC00CCCCCC00CCCCCC00999999000000000099330000CC660000CC66
      0000CC660000993300009933000099330000993300009933000099330000CC66
      0000CC660000CC66000099330000000000000000000099999900CCCCCC00CCCC
      CC00CCCCCC00999999009999990099999900999999009999990099999900CCCC
      CC00CCCCCC00CCCCCC00999999000000000099330000CC66000099330000CC66
      0000CC660000CC660000CC660000CC660000CC660000CC660000CC660000CC66
      0000CC660000CC660000CC6600009933000099999900CCCCCC0099999900CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00999999000000000099330000CC660000CC66
      0000CC660000CC660000CC660000CC660000CC660000CC660000CC660000CC66
      0000CC660000CC66000099330000000000000000000099999900CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00999999000000000099330000CC66000099330000CC66
      0000CC6600009933000099330000993300009933000099330000993300009933
      000099330000CC660000CC6600009933000099999900CCCCCC0099999900CCCC
      CC00CCCCCC009999990099999900999999009999990099999900999999009999
      990099999900CCCCCC00CCCCCC00999999000000000099330000CC660000CC66
      0000993300009933000099330000993300009933000099330000993300009933
      0000CC660000CC66000099330000000000000000000099999900CCCCCC00CCCC
      CC00999999009999990099999900999999009999990099999900999999009999
      9900CCCCCC00CCCCCC00999999000000000099330000CC66000099330000CC66
      000099330000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0099330000CC6600009933000099999900CCCCCC0099999900CCCC
      CC0099999900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0099999900CCCCCC00999999000000000099330000CC6600009933
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0099330000CC66000099330000000000000000000099999900CCCCCC009999
      9900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0099999900CCCCCC00999999000000000099330000CC66000099330000CC66
      000099330000FFFFFF0099330000993300009933000099330000993300009933
      0000FFFFFF0099330000CC6600009933000099999900CCCCCC0099999900CCCC
      CC0099999900FFFFFF0099999900999999009999990099999900999999009999
      9900FFFFFF0099999900CCCCCC00999999000000000099330000CC6600009933
      0000FFFFFF00993300009933000099330000993300009933000099330000FFFF
      FF0099330000CC66000099330000000000000000000099999900CCCCCC009999
      9900FFFFFF00999999009999990099999900999999009999990099999900FFFF
      FF0099999900CCCCCC00999999000000000099330000CC66000099330000CC66
      000099330000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0099330000CC6600009933000099999900CCCCCC0099999900CCCC
      CC0099999900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0099999900CCCCCC00999999000000000099330000CC6600009933
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0099330000CC66000099330000000000000000000099999900CCCCCC009999
      9900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0099999900CCCCCC00999999000000000099330000CC66000099330000E5E5
      E50099330000FFFFFF0099330000993300009933000099330000993300009933
      0000FFFFFF0099330000993300009933000099999900CCCCCC0099999900E5E5
      E50099999900FFFFFF0099999900999999009999990099999900999999009999
      9900FFFFFF009999990099999900999999000000000099330000E5E5E5009933
      0000FFFFFF00993300009933000099330000993300009933000099330000FFFF
      FF00993300009933000099330000000000000000000099999900E5E5E5009999
      9900FFFFFF00999999009999990099999900999999009999990099999900FFFF
      FF009999990099999900999999000000000099330000CC66000099330000CC66
      000099330000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0099330000CC6600009933000099999900CCCCCC0099999900CCCC
      CC0099999900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0099999900CCCCCC00999999000000000099330000CC6600009933
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0099330000CC66000099330000000000000000000099999900CCCCCC009999
      9900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0099999900CCCCCC00999999000000000099330000E5E5E500993300009933
      0000993300009933000099330000993300009933000099330000993300009933
      00009933000099330000993300009933000099999900E5E5E500999999009999
      9900999999009999990099999900999999009999990099999900999999009999
      9900999999009999990099999900999999000000000099330000993300009933
      0000993300009933000099330000993300009933000099330000993300009933
      0000993300009933000099330000000000000000000099999900999999009999
      9900999999009999990099999900999999009999990099999900999999009999
      99009999990099999900999999000000000099330000CC66000099330000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009933
      0000CC66000099330000000000000000000099999900CCCCCC0099999900FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009999
      9900CCCCCC009999990000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009933000099330000993300009933
      0000993300009933000099330000993300009933000099330000993300009933
      0000993300009933000000000000000000009999990099999900999999009999
      9900999999009999990099999900999999009999990099999900999999009999
      9900999999009999990000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CC996600CC99
      6600CC996600CC996600CC996600CC996600CC996600CC996600CC996600CC99
      6600CC996600CC99660000000000000000000000000000000000999999009999
      9900999999009999990099999900999999009999990099999900999999009999
      9900999999009999990000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CC996600FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00CC99660000000000000000000000000000000000999999000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000999999000000000000000000000000003399CC00006699000066
      9900006699000066990000669900006699000066990000669900006699000066
      990066CCCC000000000000000000000000000000000099999900999999009999
      9900999999009999990099999900999999009999990099999900999999009999
      9900CCCCCC000000000000000000000000000000000000000000CC996600FFFF
      FF00E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5
      E500FFFFFF00CC99660000000000000000000000000000000000999999000000
      0000CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCC
      CC00000000009999990000000000000000003399CC003399CC0099FFFF0066CC
      FF0066CCFF0066CCFF0066CCFF0066CCFF0066CCFF0066CCFF0066CCFF003399
      CC00006699000000000000000000000000009999990099999900E5E5E500CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC009999
      9900999999000000000000000000000000000000000000000000CC996600FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00CC99660000000000000000000000000000000000999999000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009999990000000000000000003399CC003399CC0066CCFF0099FF
      FF0099FFFF0099FFFF0099FFFF0099FFFF0099FFFF0099FFFF0099FFFF0066CC
      FF00006699003399CC0000000000000000009999990099999900CCCCCC00E5E5
      E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500CCCC
      CC00999999009999990000000000000000000000000000000000CC996600FFFF
      FF00E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5
      E500FFFFFF00CC99660000000000000000000000000000000000999999000000
      0000CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCC
      CC00000000009999990000000000000000003399CC003399CC0066CCFF0099FF
      FF0099FFFF0099FFFF0099FFFF0099FFFF0099FFFF0099FFFF0099FFFF0066CC
      FF0066CCCC000066990000000000000000009999990099999900CCCCCC00E5E5
      E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500CCCC
      CC00CCCCCC009999990000000000000000000000000000000000CC996600FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00CC99660000000000000000000000000000000000999999000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009999990000000000000000003399CC0066CCFF003399CC0099FF
      FF0099FFFF0099FFFF0099FFFF0099FFFF0099FFFF0099FFFF0099FFFF0066CC
      FF0099FFFF00006699003399CC000000000099999900CCCCCC0099999900E5E5
      E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500CCCC
      CC00E5E5E5009999990099999900000000000000000000000000CC996600FFFF
      FF00E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5
      E500FFFFFF00CC99660000000000000000000000000000000000999999000000
      0000CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCC
      CC00000000009999990000000000000000003399CC0066CCFF0066CCCC0066CC
      CC0099FFFF0099FFFF0099FFFF0099FFFF0099FFFF0099FFFF0099FFFF0066CC
      FF0099FFFF0066CCCC00006699000000000099999900CCCCCC00CCCCCC00CCCC
      CC00E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500CCCC
      CC00E5E5E500CCCCCC0099999900000000000000000000000000CC996600FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00CC99660000000000000000000000000000000000999999000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009999990000000000000000003399CC0099FFFF0066CCFF003399
      CC00CCFFFF00CCFFFF00CCFFFF00CCFFFF00CCFFFF00CCFFFF00CCFFFF0099FF
      FF00CCFFFF00CCFFFF00006699000000000099999900E5E5E500CCCCCC009999
      9900E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5
      E500E5E5E500E5E5E50099999900000000000000000000000000CC996600FFFF
      FF00E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5
      E500FFFFFF00CC99660000000000000000000000000000000000999999000000
      0000CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCC
      CC00000000009999990000000000000000003399CC0099FFFF0099FFFF0066CC
      FF003399CC003399CC003399CC003399CC003399CC003399CC003399CC003399
      CC003399CC003399CC0066CCFF000000000099999900E5E5E500E5E5E500CCCC
      CC00999999009999990099999900999999009999990099999900999999009999
      99009999990099999900CCCCCC00000000000000000000000000CC996600FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00CC99660000000000000000000000000000000000999999000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009999990000000000000000003399CC00CCFFFF0099FFFF0099FF
      FF0099FFFF0099FFFF00CCFFFF00CCFFFF00CCFFFF00CCFFFF00CCFFFF000066
      99000000000000000000000000000000000099999900E5E5E500E5E5E500E5E5
      E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E5009999
      9900000000000000000000000000000000000000000000000000CC996600FFFF
      FF00E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500FFFFFF00CC996600CC99
      6600CC996600CC99660000000000000000000000000000000000999999000000
      0000CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC0000000000999999009999
      990099999900999999000000000000000000000000003399CC00CCFFFF00CCFF
      FF00CCFFFF00CCFFFF003399CC003399CC003399CC003399CC003399CC000000
      0000000000000000000000000000000000000000000099999900E5E5E500E5E5
      E500E5E5E500E5E5E50099999900999999009999990099999900999999000000
      0000000000000000000000000000000000000000000000000000CC996600FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CC996600E5E5
      E500CC9966000000000000000000000000000000000000000000999999000000
      0000000000000000000000000000000000000000000000000000999999000000
      00009999990000000000000000000000000000000000000000003399CC003399
      CC003399CC003399CC0000000000000000000000000000000000000000000000
      0000000000009933000099330000993300000000000000000000999999009999
      9900999999009999990000000000000000000000000000000000000000000000
      0000000000009999990099999900999999000000000000000000CC996600FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CC996600CC99
      6600000000000000000000000000000000000000000000000000999999000000
      0000000000000000000000000000000000000000000000000000999999009999
      9900000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000099330000993300000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000099999900999999000000000000000000CC996600CC99
      6600CC996600CC996600CC996600CC996600CC996600CC996600CC9966000000
      0000000000000000000000000000000000000000000000000000999999009999
      9900999999009999990099999900999999009999990099999900999999000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000099330000000000000000
      0000000000009933000000000000993300000000000000000000000000000000
      0000000000000000000000000000000000000000000099999900000000000000
      0000000000009999990000000000999999000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000993300009933
      0000993300000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000999999009999
      9900999999000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B000000000000000000000000007B7B7B00000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00000000007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B0000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000000000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000007B7B7B007B7B7B007B7B7B000000
      00007B7B7B0000000000000000007B7B7B00FFFFFF00000000007B7B7B000000
      00007B7B7B007B7B7B007B7B7B007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B000000000000000000000000007B7B7B00FFFFFF0000000000000000007B7B
      7B0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000000000007B7B7B000000
      00000000000000000000000000007B7B7B00FFFFFF0000000000000000000000
      00007B7B7B0000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B000000FF000000
      FF000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF007B7B7B000000000000000000000000007B7B7B00FFFFFF000000
      00000000000000000000000000007B7B7B00FFFFFF0000000000000000000000
      0000000000007B7B7B00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF00000000000000000000000000000000007B7B7B00FFFFFF000000
      00000000000000000000000000007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007B7B7B00FFFFFF00000000000000000000000000000000000000
      000000000000FF0000000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B00FFFFFF000000
      00000000000000000000000000007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B00FFFFFF00000000000000000000000000000000000000
      00000000000000000000FF000000FF00000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000000000FF000000000000FF000000FF000000FF00
      0000FF000000000000000000000000000000000000007B7B7B00FFFFFF000000
      000000000000000000007B7B7B00000000007B7B7B0000000000FFFFFF000000
      0000000000007B7B7B00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF00000000000000
      000000000000000000000000000000000000000000007B7B7B000000FF000000
      FF000000FF000000000000FF000000FF000000FF000000000000FF000000FF00
      0000FF0000007B7B7B000000000000000000000000007B7B7B0000000000FFFF
      FF00000000007B7B7B000000000000000000000000007B7B7B0000000000FFFF
      FF00000000007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000000000FF000000FF000000FF000000FF000000FF000000000000FF00
      00000000000000000000000000000000000000000000000000007B7B7B000000
      00007B7B7B0000000000000000000000000000000000000000007B7B7B000000
      00007B7B7B000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF00000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF007B7B
      7B0000000000FFFFFF0000000000000000000000000000000000000000007B7B
      7B000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000FF000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000007B7B7B007B7B7B00000000000000
      00007B7B7B0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B000000
      0000000000007B7B7B007B7B7B007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B000000000000000000000000007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF00000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000FF000000FF00000000000000FF000000FF000000FF000000FF000000FF00
      0000FF00000000000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FF00000000000000000000000000000000000000FF00
      0000FFFFFF00FFFFFF000000FF000000FF000000FF000000FF000000FF000000
      FF00FFFFFF00FFFFFF00FF000000000000000000000000000000000000000000
      0000FF000000BDBDBD00BDBDBD0000000000BDBDBD00BDBDBD00BDBDBD00BDBD
      BD0000000000BDBDBD00BDBDBD00FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FFFFFF00FFFFFF00FFFFFF000000FF000000FF000000FF000000FF00FFFF
      FF00FFFFFF00FFFFFF00FF00000000000000000000000000000000000000FF00
      00000000FF000000FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000FF000000FF00FF000000000000000000000000000000000000000000
      0000FF000000BDBDBD00BDBDBD00BDBDBD0000000000BDBDBD00BDBDBD000000
      0000BDBDBD00BDBDBD00BDBDBD00FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FFFFFF00FFFFFF00FFFFFF000000FF000000FF000000FF000000FF00FFFF
      FF00FFFFFF00FFFFFF00FF000000000000000000000000000000000000000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000FF00000000000000000000000000000000000000
      0000FF000000BDBDBD00BDBDBD00BDBDBD00BDBDBD000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FFFFFF00FFFFFF00FFFFFF000000FF000000FF000000FF000000FF00FFFF
      FF00FFFFFF00FFFFFF00FF000000000000000000000000000000000000000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000FF00000000000000000000000000000000000000
      0000FF000000BDBDBD00BDBDBD00BDBDBD00BDBDBD000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FFFFFF00FFFFFF00FFFFFF000000FF000000FF000000FF000000FF00FFFF
      FF00FFFFFF00FFFFFF00FF0000000000000000000000000000000000FF00FF00
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FF0000000000FF000000000000000000000000000000
      0000FF000000BDBDBD00BDBDBD00BDBDBD0000000000BDBDBD00BDBDBD000000
      0000BDBDBD00BDBDBD00BDBDBD00FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF0000000000FF000000FF000000FF000000FF00FF00
      0000FF000000FF000000FF0000000000000000000000000000000000FF00FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF0000000000FF000000000000000000000000000000
      0000FF000000FF000000FF00000000000000FF000000FF000000FF000000FF00
      000000000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF000000FF000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      00000000FF000000FF00000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B007B7B7B007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FF00000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B007B7B7B007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FF00000000000000000000000000000000000000FF00
      0000FF000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FF000000FF000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B007B7B7B007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FF000000000000000000000000000000FF000000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FF0000000000000000000000000000000000
      00000000000000000000000000007B7B7B007B7B7B007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FF000000000000000000000000000000FF000000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FF0000000000000000000000000000000000
      00000000000000000000000000007B7B7B007B7B7B007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FF000000000000000000000000000000FF000000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FF0000000000000000000000000000000000
      00000000000000000000000000007B7B7B007B7B7B007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FF00000000000000000000000000000000000000FF00
      0000FF000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FF000000FF000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B007B7B7B007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FF00000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B007B7B7B007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FFFF
      0000FFFF0000FF000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FFFF0000FFFF0000FFFF
      0000FFFF0000FF000000000000000000000000000000FF000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FF000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FF000000000000000000000000000000FF000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FF000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FF000000000000000000000000000000FF000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FF00000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FF000000000000000000000000000000FF000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FF00000000000000000000000000000000000000FF00
      0000000000000000000000000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FF000000000000000000000000000000FF000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FF000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FF000000000000000000000000000000FF000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FF000000000000000000000000000000FF000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FFFF0000FFFF0000FFFF0000FFFF0000FF000000FF000000FF000000FFFF
      0000FFFF0000FF000000000000000000000000000000FF000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FFFF0000FFFF0000FFFF0000FF000000000000000000000000000000FF00
      0000FF000000FF000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      000000000000FF0000000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF00000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF00000000000000000000000000000000000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF00000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF00000000000000000000000000000000000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000000000000000000000000000000000000000
      000000000000FF000000FF000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF00000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF0000000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000000000000000000000000000241CED00241C
      ED00241CED00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000000000
      000000000000FF0000000000000000000000000000000000000000000000241C
      ED00241CED00000000000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000000000000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00000000000000000000000000
      000000000000FF0000000000000000000000000000000000000000000000241C
      ED00241CED00000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      00000000000000000000000000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000000000000000000000000000000000
      000000000000FF0000000000000000000000000000000000000000000000241C
      ED00241CED000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      000000000000000000000000000000000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000241CED000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      000000000000000000000000000000000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000241CED000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      000000000000000000000000000000000000FF00000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      00000000000000000000000000000000000000000000FF000000FF0000000000
      000000000000000000000000000000000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF0000000000000000000000FF000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      000000000000000000000000000000000000FF000000FF000000FF0000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000000000000000000000000000FF000000000000000000000000000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF00C0C0C000C0C0C000C0C0
      C00000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004A00
      4A004A004A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF00C0C0C000C0C0C000C0C0
      C000C0C0C00000FFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004A004A004A004A004E00
      A7004A004A00000000000000000000000000000000004A004A004A004A004A00
      4A004A004A004A004A004A004A0000000000000000004A004A004A004A004A00
      4A004A004A004A004A004A004A00000000000000000000000000000000000000
      000000008000000080000000800000008000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF00C0C0C000C0C0C00000FFFF0000FF
      FF00C0C0C00000FFFF0000FFFF00000000000000000000000000000000000000
      00000000000000000000000000004A004A004A004A004E00A700000080000000
      80004A004A00000000000000000000000000000000004A004A00C8D0D400C8D0
      D400C8D0D400C8D0D4004A004A0000000000000000004A004A00000080000000
      8000000080004E00A7004A004A00000000000000000000000000000000000000
      000000000000000080000000800000008000000000000000000000000000FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000FFFF00C0C0
      C00000FFFF0000FFFF00C0C0C000C0C0C000C0C0C00000FFFF0000FFFF0000FF
      FF00C0C0C000C0C0C00000FFFF00000000000000000000000000000000000000
      0000000000004A004A004A004A004E00A7000000800000008000000080000000
      80004A004A0000000000000000000000000000000000000000004A004A00C8D0
      D400C8D0D400C8D0D4004A004A0000000000000000004A004A00000080000000
      8000000080004A004A0000000000000000000000000000000000000000000000
      000000000000000000000000000000008000000000000000000000000000FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000FFFF00C0C0
      C000C0C0C000C0C0C000C0C0C00000FFFF0000FFFF0000FFFF008080800000FF
      FF00C0C0C000C0C0C00000FFFF0000FFFF000000000000000000000000004A00
      4A004A004A004E00A70000008000000080000000800000008000000080000000
      80004A004A0000000000000000000000000000000000000000004A004A00C8D0
      D400C8D0D400C8D0D4004A004A0000000000000000004A004A00000080000000
      80004E00A7004A004A0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000FFFF00C0C0
      C000C0C0C000C0C0C00000FFFF008080800080808000808080008080800000FF
      FF00C0C0C000C0C0C00000FFFF00000000000000000000000000000000004A00
      4A004A004A004A004A004A004A004A004A004A004A004A004A004A004A004A00
      4A004A004A000000000000000000000000000000000000000000000000004A00
      4A00C8D0D400C8D0D4004A004A0000000000000000004A004A00000080000000
      80004A004A000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000000000000000000000000000000000000000000000FFFF00C0C0
      C000C0C0C000C0C0C00000FFFF0080808000808080008080800000FFFF0000FF
      FF00C0C0C000C0C0C00000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004A00
      4A00C8D0D400C8D0D4004A004A0000000000000000004A004A00000080004E00
      A7004A004A000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000000000000000000000000000000000000000000000FFFF00C0C0
      C000C0C0C000C0C0C00000FFFF0000FFFF0000FFFF0000FFFF00C0C0C000C0C0
      C000C0C0C000C0C0C00000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00004A004A00C8D0D4004A004A0000000000000000004A004A00000080004A00
      4A00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF00C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C00000FFFF0000FFFF00000000000000000000000000000000004A00
      4A004A004A004A004A004A004A004A004A004A004A004A004A004A004A004A00
      4A004A004A000000000000000000000000000000000000000000000000000000
      00004A004A00C8D0D4004A004A0000000000000000004A004A004E00A7004A00
      4A00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C00000FFFF0000FFFF0000000000000000000000000000000000000000004A00
      4A004A004A00C8D0D400C8D0D400C8D0D400C8D0D400C8D0D400C8D0D400C8D0
      D4004A004A000000000000000000000000000000000000000000000000000000
      0000000000004A004A004A004A0000000000000000004A004A004A004A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF00C0C0C000C0C0C000C0C0C000C0C0C00000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000004A004A004A004A00C8D0D400C8D0D400C8D0D400C8D0D400C8D0
      D4004A004A000000000000000000000000000000000000000000000000000000
      0000000000004A004A004A004A0000000000000000004A004A004A004A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000004A004A004A004A00C8D0D400C8D0D400C8D0
      D4004A004A000000000000000000000000000000000000000000000000000000
      000000000000000000004A004A0000000000000000004A004A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004A004A004A004A00C8D0
      D4004A004A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004A00
      4A004A004A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      00000000000000000000F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008080800000000000FFFF
      FF00FFFFFF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF0080808000FFFF
      FF00FFFFFF00FFFFFF0080808000000000000000000000000000000000000000
      00000000000000000000F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008080800000000000FFFF
      FF00FFFFFF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF0080808000FFFF
      FF00FFFFFF00FFFFFF0080808000000000000000000000000000000000000000
      00000000000000000000F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800000000000000000000000
      000000000000000000000000000000000000000000008080800000000000FFFF
      FF00FFFFFF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF0080808000FFFF
      FF00FFFFFF00FFFFFF0080808000000000000000000000000000000000000000
      00000000000000000000F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080008080800080808000808080000000
      0000000000000000000000000000000000000000000080808000000000008080
      8000808080008080800080808000808080008080800080808000808080008080
      80008080800080808000808080000000000000000000F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      00008080800080808000C0C0C000C0C0C000C0C0C000C0C0C000808080008080
      800000000000000000000000000000000000000000008080800000000000FFFF
      FF00FFFFFF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF0080808000FFFF
      FF00FFFFFF00FFFFFF00808080000000000000000000F0FBFF00000000000000
      0000000000000000000000000000000000000000000000000000F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000080808000C0C0C000C0C0C000FFFFFF00FFFFFF00C0C0C000C0C0C0008080
      800000000000000000000000000000000000000000008080800000000000FFFF
      FF00FFFFFF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF0080808000FFFF
      FF00FFFFFF00FFFFFF00808080000000000000000000F0FBFF00000000000000
      0000000000000000000000000000000000000000000000000000F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF0000000000000000000000000000000000FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000008080
      8000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0
      C00080808000000000000000000000000000000000008080800000000000FFFF
      FF00FFFFFF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF0080808000FFFF
      FF00FFFFFF00FFFFFF00808080000000000000000000F0FBFF00000000000000
      0000000000000000000000000000000000000000000000000000F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF0000000000000000000000000000000000FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000008080
      8000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0
      C000808080000000000000000000000000000000000080808000000000008080
      8000808080008080800080808000808080008080800080808000808080008080
      80008080800080808000808080000000000000000000F0FBFF00000000000000
      0000000000000000000000000000000000000000000000000000F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000080808000C0C0C000C0C0C000FFFFFF00FFFFFF00C0C0C000C0C0C0008080
      800000000000000000000000000000000000000000008080800000000000FFFF
      FF00FFFFFF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF0080808000FFFF
      FF00FFFFFF00FFFFFF00808080000000000000000000F0FBFF00000000000000
      0000000000000000000000000000000000000000000000000000F0FBFF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      00008080800080808000C0C0C000C0C0C000C0C0C000C0C0C000808080008080
      800000000000000000000000000000000000000000008080800000000000FFFF
      FF00FFFFFF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF0080808000FFFF
      FF00FFFFFF00FFFFFF00808080000000000000000000F0FBFF00000000000000
      0000000000000000000000000000000000000000000000000000F0FBFF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080008080800080808000808080000000
      000000000000000000000000000000000000000000008080800000000000FFFF
      FF00FFFFFF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF0080808000FFFF
      FF00FFFFFF00FFFFFF00808080000000000000000000F0FBFF00000000000000
      0000000000000000000000000000000000000000000000000000F0FBFF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F0FBFF00000000000000
      0000000000000000000000000000000000000000000000000000F0FBFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      80008080800080808000808080000000000000000000F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      00000000FF0084848400848484000000FF000000FF0084848400848484000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      FF008484840084848400848484000000FF000000FF0084848400848484008484
      84000000FF000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000000000000000000000000000FF008484
      84008484840084848400848484000000FF000000FF0084848400848484008484
      8400848484000000FF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF0000000000000000000000FF00848484008484
      84008484840084848400848484000000FF000000FF0084848400848484008484
      840084848400848484000000FF00000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00848484008484
      84008484840084848400848484000000FF000000FF0084848400848484008484
      840084848400848484000000FF00000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF0000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF0000000000000000000000FF00848484008484
      84008484840084848400848484000000FF000000FF0084848400848484008484
      840084848400848484000000FF00000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF0000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF0000000000000000000000FF00848484008484
      84008484840084848400848484000000FF000000FF0084848400848484008484
      840084848400848484000000FF00000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF0000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF0000000000000000000000000000000000000000000000FF008484
      84008484840084848400848484000000FF000000FF0084848400848484008484
      8400848484000000FF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      FF008484840084848400848484000000FF000000FF0084848400848484008484
      84000000FF000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF0084848400848484000000FF000000FF0084848400848484000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000008484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFF
      FF00FFFFFF000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008484000000000000000000000000000084
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000C6C6C6000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      000000000000000000000000000000000000000000000000000000848400C6C6
      C600FFFFFF000084840000000000000000000000000000000000000000000000
      00000000840000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000C6C6C600C6C6C600C6C6C600FFFFFF000084840000000000000000000000
      0000000000000000000000000000000000000000000000848400C6C6C600C6C6
      C600C6C6C600FFFFFF0000848400000000000000000000000000000000000000
      84000000840000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00008484000084840000848400FFFFFF00FFFF
      FF0000000000C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000848400C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600FFFFFF0000848400000000000000
      00000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600FFFFFF00000000000000000000000000000084000000
      8400000084000000840000008400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C600C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600FFFFFF00000000000000
      00000000000000000000000000000000000000000000C6C6C600FFFFFF00FFFF
      0000C6C6C600C6C6C600C6C6C600000000000000000000000000000000000000
      84000000840000000000000000000000840000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000C6C6C60000000000C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000000000000000000000000000000000000000000000848400FFFFFF00FFFF
      FF00C6C6C600C6C6C60000848400000000000000000000000000000000000000
      0000000084000000000000000000000084000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000C6C6C60000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      000000000000000000000000000000000000000000000000000000848400C6C6
      C600C6C6C6000084840000000000000000000000000000000000000000000000
      000000000000000000000000000000008400000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF0000000000C6C6C600000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000000000000000000000000000C6C6C600FFFFFF00FFFF
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000000000000000000000000000C6C6C600FFFFFF00FFFF
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008400000000000000
      0000000084000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFF0000FFFF0000C6C6C600C6C6C600C6C6C600C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008400000000000000
      0000000084000000840000000000000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00000000000000000000000000000000000000000000848400FFFF
      FF00FFFFFF00FFFFFF00C6C6C600C6C6C600C6C6C60000848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000084000000
      8400000084000000840000008400000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6C6C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF000000000000848400000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF000000000000848400000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF000000000000848400000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000848400C6C6C600C6C6C6000084
      84000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      00000000000000848400000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000848400C6C6C600C6C6C600FFFF00000084
      84000084840000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      84000084840000848400000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000C6C6C600C6C6C600C6C6C600C6C6C6000084
      8400C6C6C60000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      00000084840000848400000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000C6C6C600FFFF0000C6C6C600C6C6C6000084
      8400C6C6C60000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000848400000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000848400FFFF0000FFFF0000C6C6C6000084
      84000084840000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF00FFFFFF00FFFFFF000000000000FFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000848400000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000848400C6C6C600C6C6C6000084
      84000000000000000000000000000000000000000000FFFFFF000000000000FF
      FF0000000000FFFFFF000000000000FFFF000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000848400000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      000000FFFF000000000000FFFF000000000000FFFF000000000000FFFF0000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000848400000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF000000000000FFFF000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000C6C6C600000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF00000000000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF0000FFFF000000
      0000008484000084840000848400008484000084840000848400008484000084
      8400008484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00000000000084840000848400008484000084840000848400008484000084
      8400008484000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000848400008484000084
      8400008484000084840000000000FFFFFF000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      00000000000000000000FFFFFF00000000000000000000848400008484000084
      8400008484000084840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000848400008484000084
      8400008484000084840000000000FFFFFF00000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000000000000000000000
      00000000000000000000FFFFFF00000000000000000000848400008484000084
      8400008484000084840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000848400008484000084
      8400008484000084840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000000000000000FFFF
      FF00000000000000000000000000000000000000000000848400008484000084
      8400008484000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000000000000000848400008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000848400008484000000
      0000000000000000000000000000000000000000000000000000000000000084
      8400008484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400008484000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600000000000084
      8400008484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400008484000084
      84000000000000FFFF00000000000000000000FFFF0000000000008484000084
      8400008484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000A00100000100010000000000000D00000000000000000000
      000000000000000000000000FFFFFF00FC7FFC3F00000000FC7FFC3F00000000
      FC7FFC3F00000000FC7FFC3F00000000FC7FFC3F00000000FC7FF00700000000
      E00FE10700000000E00FEBEF00000000F01FF3CF00000000F01FF5DF00000000
      F83FF99F00000000F83FFABF00000000FC7FFC3F00000000FC7FFD7F00000000
      FEFFFE7F00000000FEFFFEFF000000009FFF9FFFFEFFFE7F0FFF0FFFFEFFFEBF
      07FF07FFFC7FFC3F83FF83FFFC7FFD5FC1FFC1FFF83FF99FE10FE10FF83FFBAF
      F003F003F01FF3CFF801F801F01FF7D7F801F801E00FE087F800F800E00FE00F
      F800F800FC7FFC3FF800F800FC7FFC3FF801F801FC7FFC3FFC01FC01FC7FFC3F
      FE03FE03FC7FFC3FFF0FFF0FFC7FFC7FFFFFE408E408F174F183FFF0FFE0C000
      E307FFE0FFC88001F187FFC1FF990000F007FF83FF330000F00FFF07FE670000
      F80FFE0FFCCF0000F80FFC1FF99F0000F81FF83FF33F0000FC1FF07FE67F0000
      FC1FE0FFC8FF0000FC3FC1FF81FF0000FE7F83FF03FF0000FEFF07FF07FF8000
      FFFF0FFF0FFF8000FFFF9FFF9FFF8000F8138000FFE0FFFFF3A58000FFC0FFFF
      EF3AC000FFCCF183CF3CE000FFCCFBC7CF1CF000FFC0F9C7CE1CF800FFC1F807
      CE3CFC0083FBFD8FD001060003F1FC8FE003070030E0FC8FFDC301803080FE1F
      FAC301800000FE1FF0C300600421FE1FF113C060C021FF3FF437C060C123FF7F
      FA0FF044F007FFFFFC1FF07EF07FFFFFFFE3FC1FF813FC1FFFC1F007F3A5F007
      FD89E003EF3AE003F913C001CF3CC001F827C001CF1CC001FA4FC001CE1CC001
      F39FC001CE3CC001F79FC001D0014001E787E003E003A003EE0FF1C7F0C3C3C7
      C87FF1C7F0C30047C1FFF1C7F113C1C787FFF007F437A1C79FFFF80FFA0F6007
      FFFFFC1FFC1FE80FFFFFFFFFFFFFEC1FFC00FFFFFFFFFFFFFC0080038003FFE3
      FC0080038003FFC3FC0080038003FB83E00080038003F907E00080038003F80F
      E00080038003F01FE00780038003F03F800780038003E01F800780038003E00F
      800780038003C07F801F80038003C1FF801F8003800387FF801F800380039FFF
      801FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFFDFFFFDFFFDFE0FFE8FF
      FFCFFFCF801FA05FE007E007001F803FFFCFFFCF001F001FFFDFFFDF000F000F
      FFFFFFFF000F000F01800180000F000F01807D800001000101807D8001010001
      01807D800101000101807D80000F000F01806180008F000F0381638100AF002F
      07836783803F803F0F870F87E1FFE1FFFF9FFF9FFFFFFFFFFF8FFF8FFBFFFBFF
      00070007F3FFF3FF00037F83E007E00700014001F3FFF3FF00007F80FBFFFBFF
      00014001FFFFFFFF00037F830180018000074007018001BE000F7F8F018001BE
      000F400F018001BE000F7FEF018001BE000F402F018001B0000F7FEF038103B1
      000F7FEF078307B3000F000F0F870F87FFF8FFF8F9FFF9FF80008000F1FFF1FF
      8000BFE0E000E0008001A001C000C1FE8003BC03800080028007A007000001FE
      8007BC07800080028007A007C000C1FE8007BE07E000E0028007A007F000F1FE
      8007BFF7F000F0028007A087F000F7FE800FBF8FF000F402801FBF9FF000F7FE
      803F803FF000F7FEFFFFFFFFF000F000FFFFFFFFFFFFFFFFEFFDEFFDC007C007
      C7FFC7FF80038003C3FBC3FB00010001E3F7E3F700014001F1E7F1E700014001
      F8CFF8CF00007FF0FC1FFC1F00004000FE3FFE3F80008000FC1FFC1FC000DFE0
      F8CFF8CFE001E821E1E7E1E7E007EFF7C3F3C3F3F007F417C7FDC7FDF003F7FB
      FFFFFFFFF803F803FFFFFFFFFFFFFFFFFFFFFFFFE000E000C001C001C000C000
      8001800180008000800180010000000080018001000000008001800100000000
      8001800100000000800180010000000080018001000000008001800100000000
      8001800100000000800180010000000080018001000000008001800100000000
      8001800100030003FFFFFFFF00030003FFFFFFFFFFFFFFFFC003C003FFFFFFFF
      C003DFFB80078007C003D00B00070007C003DFFB00030003C003D00B00030003
      C003DFFB00010001C003D00B00010001C003DFFB00010001C003D00B00010001
      C003DFFB000F000FC003D043801F801FC007DFD7C3F8C3F8C00FDFCFFFFCFFFC
      C01FC01FFFBAFFBAFFFFFFFFFFC7FFC7FFFFFFFFFFFFFC1FFFFFFFFFF83F8828
      FFFFFFFF10101650C001C001E00FEE6BEFFBEFFBC007DE75F7F7F7F780039E79
      FBEFFBEF80039E01F9CFFDDF80039E01FC1FFC1F80039D59FC1FFC1F8003ABAB
      FC1FFC1FC007D7D7F80FFC1FE00F8BECF7F7FFFF30183418FFFFFFFFF83FF83F
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FEFFFF
      FFFFFFFFFBFDFFFFE001E001F000C001E001E001F000EFFBE001E001F000F7F7
      E001E001F000FBEFE001E001F000FDDFE001C000F000FC1FE001C000F000FC1F
      FE1FDFF0FDFBFC1FF807EFF8FBFDFC1FFC0FEFFCF7FEFF7FFE1FF3F2FFFFFF7F
      FF3FFC0FFFFFFE3FFFFFFFFFFFFFFF7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FC1FFFFFC001C001F80FFFFFC001DFFDF007FFFFC001C1C1E003F807FC1FFDDF
      C001E001FC1FFDDFC001C000FC1FFDDFC001C000FC1FFDDFC001C000FC1FFDDF
      C001E001FC1FFDDFE003F807C001C1C1F007FFFFC001DFFDF80FFFFFC001C001
      FC1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFF
      FFFFFFFFFFE3FFFFFFFFFFFFFF838001FFFFFFFFFF038001DFFFFFFFFC038001
      DFFFFFFFF0038001EFFFFFFFC0038001EE03FFFF80038001F1FDFFFFC0038001
      FFFDFFFFC0038001FFFEFFFFE0038001FFFFFFFFE0E38001FFFFFFFFF1FFFFFF
      FFFFFFFFF7FFFFFFFFFF7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFC1FFFFFFFFF8001FBEFFFFFDFFFBFFDF7F7FFFFDFFFBFFDEFFBF807DFFF
      BFFDDFFDE7F9EFFFBFFDDFFDDFFEEFFFBFFDDFFDDFFEF7FFBFFDDFFDDFFEF7FF
      BFFDDFFDE7F9F9FFBFFDEFFBF807FEFF8001F7F7FFFFFF1FFFFFFBEFFFFFFFE1
      FFFFFC1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFB
      8201EFFFFBFFFFE38203F7FFF7F3FF9BC20FFBFFF7EFFF7BC21FFDFFEF9FFCFB
      C27FFEFFDF7FF3FBE3FFFF7FBF7FCFFBE3FFFFBFBF7FBFFBF3FFFFDF9F7FDFFB
      F3FFFFEFE7BFDFFBF3FFFFF7F9BFEF1BFBFFFFFBFE3FEEE3FBFFFFFDFFFFF1FF
      FFFFFFFFFFFFF7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0FFFFFFFFFFFFF
      FF03FFE7FFFF8041FF03FF878181C041C001FE078181F043C001F807C183F843
      C000E007C183FE43C001E007E187FFC7C001FFFFE187FFC7C001FFFFF18FFFCF
      C001E007F18FFFCFE003E007F99FFFCFE00FF807F99FFFDFFE0FFE07FDBFFFDF
      FFFFFF87FFFFFFFFFFFFFFE7FFFFFFFFFFFFFFFFFFFFFFFF8001FC018001F81F
      8001FC018001F00F8001FC018001E0078001FC018001C0038001800180018003
      8001800180018001800180018001800180018001800180018001800180018001
      8001801F800180038001801F8001C0038001801F8001E0078001801F8001F00F
      8001801F8001F81FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC1F81FFEFF
      C003C001F00FFEFFDFFBDFC1E007FEFFDFFBDFC1C003FEFFDFFBDFC18001FEFF
      DFFBDFFB8001FEFFDFFBDFFB8001FEFFC003C00380018001000000018001FEFF
      800180018001FEFFC007C007C003FEFFE00FE00FE007FEFFF81FF81FF00FFEFF
      FC7FFC7FF81FFEFFFEFFFEFFFFFFFFFFFFFFFC00FFFCFFFF8003FC00FFF8FFFF
      8003FC00FE13FFFF8003FC00FC07FFFF8003E000F807F7FF8003E000F803FBFF
      8003E000F803FDFF8003E007C003FEFF80038007D803FF7F80038007D803FFAF
      80038007DC07FFCF8003801FDE0FFF8F8003801FDFDFFFFF8003801FDFDFFFFF
      FFFF801FC01FFFFFFFFFFFFFFFFFFFFFFFF3FFFFFFFFFFFFFFE1FF3FC0078003
      FFC1FE3F80038003FF83C07F00018003F00780F700018003C00F00E700018003
      801F00C100008003801F00E600008003000F00F680008003000F81FEC0008003
      000FC3BFE0018003000FFFB7E0078003801FFFB3F0078003801FFFC1F0038003
      C03FFFF3F803FFFFF0FFFFF7FFFFFFFFFFFFFFFFFFFFFFFFC001000C000FF9FF
      80010008000FF9FF80010001000FF3C780010003000F73C780010003000F27FF
      80010003000F07C780010003000F00C780010003000F01E380010007000403F1
      8001000F000006388001000F00000E388001000FF8001E388001001FFC003F01
      8001003FFE047F83FFFF007FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFEFFDC007001FFFFFC7FFC007000FFFFFC3FBC0070007EFFFE3F7C0070003
      EF83F1E7C0070001DFC3F8CFC0070000DFE3FC1FC007001FDFD3FE3FC007001F
      EF3BFC1FC007001FF0FFF8CFC0078FF1FFFFE1E7C00FFFF9FFFFC3F3C01FFF75
      FFFFC7FDC03FFF8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FFFFFFFC00FFFF
      F6CFFE008000FFFFF6B7FE000000FFFFF6B7FE000000FFFFF8B780000000FFF7
      FE8F80000001C1F7FE3F80000003C3FBFF7F80000003C7FBFE3F80010003CBFB
      FEBF80030003DCF7FC9F80070003FF0FFDDF807F0003FFFFFDDF80FF8007FFFF
      FDDF81FFF87FFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object MainMenu1: TMainMenu
    Images = ImageList1
    Left = 208
    Top = 177
    object Fjl1: TMenuItem
      Caption = 'F'#225'jl'
      object Kpbetlts1: TMenuItem
        Caption = 'K'#233'p bet'#246'lt'#233's...'
        Hint = 'Open Picture'
        ImageIndex = 58
        ShortCut = 16463
        OnClick = Kpbetlts1Click
      end
      object mnuUjratoltes: TMenuItem
        Caption = 'Ujrat'#246'lt'#233's'
        ShortCut = 16469
        OnClick = mnuUjratoltesClick
      end
      object N20: TMenuItem
        Caption = '-'
      end
      object Kpments1: TMenuItem
        Caption = 'K'#233'p ment'#233's'
        ImageIndex = 60
        ShortCut = 16467
        OnClick = Kpments1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Export1: TMenuItem
        Caption = 'Export'
        object RGBklnfjlba1: TMenuItem
          Caption = 'R-G-B k'#252'l'#246'n f'#225'jlba'
          OnClick = RGBklnfjlba1Click
        end
        object FITfjlba1: TMenuItem
          Caption = 'FIT f'#225'jlba'
        end
      end
      object Import1: TMenuItem
        Caption = 'Import'
        object RGBfjlokbl1: TMenuItem
          Caption = 'R-G-B f'#225'jlokb'#243'l'
        end
        object FITfjbl1: TMenuItem
          Caption = 'FIT f'#225'jb'#243'l'
          OnClick = FITfjbl1Click
        end
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object Nyomtatsikp1: TMenuItem
        Caption = 'Nyomtat'#225'si k'#233'p'
        Enabled = False
      end
      object Nyomtats1: TMenuItem
        Caption = 'Nyomtat'#225's'
        Enabled = False
        ShortCut = 16464
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Kilps1: TMenuItem
        Caption = 'Kil'#233'p'#233's'
        ImageIndex = 78
        ShortCut = 16465
        OnClick = Kilps1Click
      end
    end
    object Javt1: TMenuItem
      Caption = 'Jav'#237't'
      OnClick = Javt1Click
      object Undo1: TMenuItem
        Caption = 'Undo'
        ImageIndex = 3
        ShortCut = 16474
        OnClick = Undo1Click
      end
      object Redo1: TMenuItem
        Caption = 'Redo'
        ImageIndex = 4
        ShortCut = 16453
        OnClick = Redo1Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Msol1: TMenuItem
        Caption = 'M'#225'sol'
        ImageIndex = 74
        ShortCut = 16451
        OnClick = Msol1Click
      end
      object Beilleszt1: TMenuItem
        Caption = 'Beilleszt'
        ImageIndex = 76
        RadioItem = True
        ShortCut = 16470
        OnClick = Beilleszt1Click
      end
      object SpecilisMsols1: TMenuItem
        Caption = 'Speci'#225'lis M'#225'sol'#225's'
        object eljeskpet1: TMenuItem
          Caption = 'Teljes k'#233'pet'
          Checked = True
          GroupIndex = 1
          RadioItem = True
          OnClick = Fixterletetakpernyrl1Click
        end
        object Kpernykpet1: TMenuItem
          Tag = 1
          Caption = 'K'#233'perny'#337' k'#233'pet'
          GroupIndex = 1
          RadioItem = True
          OnClick = Fixterletetakpernyrl1Click
        end
        object Kivlasztottterletet1: TMenuItem
          Tag = 2
          Caption = 'Kiv'#225'lasztott ter'#252'letet'
          GroupIndex = 1
          RadioItem = True
          OnClick = Fixterletetakpernyrl1Click
        end
        object Kpernynkivlaszottterletet1: TMenuItem
          Tag = 3
          Caption = 'K'#233'perny'#337'n kiv'#225'laszott ter'#252'letet'
          GroupIndex = 1
          RadioItem = True
          OnClick = Fixterletetakpernyrl1Click
        end
        object Fixterletet1: TMenuItem
          Tag = 4
          Caption = 'Fix ter'#252'letet a k'#233'pr'#337'l'
          GroupIndex = 1
          RadioItem = True
          OnClick = Fixterletetakpernyrl1Click
        end
        object Fixterletetakpernyrl1: TMenuItem
          Tag = 5
          Caption = 'Fix ter'#252'letet a k'#233'perny'#337'r'#337'l'
          GroupIndex = 1
          RadioItem = True
          OnClick = Fixterletetakpernyrl1Click
        end
      end
      object SpecilisBeillaszts1: TMenuItem
        Caption = 'Speci'#225'lis Beillaszt'#233's '
        ShortCut = 16471
        OnClick = SpecilisBeillaszts1Click
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object Cropkijellt1: TMenuItem
        Caption = 'Crop kijel'#246'lt'
        Enabled = False
        ShortCut = 16473
        OnClick = Cropkijellt1Click
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object tmretezs1: TMenuItem
        Caption = #193'tm'#233'retez'#233's'
        OnClick = tmretezs1Click
      end
      object Kpmezkeretezs1: TMenuItem
        Caption = 'K'#233'pmez'#337' keretez'#233's...'
        ImageIndex = 56
        OnClick = j1Click
      end
    end
    object Nzet1: TMenuItem
      Caption = 'N'#233'zet'
      object eljeskpernys1: TMenuItem
        Action = FullScreen
      end
      object eljeskp1: TMenuItem
        Caption = 'Teljes k'#233'p'
        ShortCut = 114
        OnClick = eljeskp1Click
      end
      object Eredetimret1: TMenuItem
        Caption = 'Eredeti m'#233'ret'
        ShortCut = 113
        OnClick = Eredetimret1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Kzpkereszt1: TMenuItem
        Action = CentralCross
        ImageIndex = 23
        ShortCut = 49227
      end
      object Kurzorkereszt1: TMenuItem
        Caption = 'Kurzor kereszt'
        ShortCut = 49219
        OnClick = Kurzorkereszt1Click
      end
      object Mrrcs1: TMenuItem
        Action = Meroracs
        Caption = 'M'#233'r'#337'r'#225'cs'
        ImageIndex = 24
        ShortCut = 49223
      end
      object Krablakban1: TMenuItem
        Caption = 'K'#246'r ablakban'
        ShortCut = 49233
        OnClick = Krablakban1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object RGBMindenszn1: TMenuItem
        Caption = 'RGB - Minden sz'#237'n'
        Checked = True
        GroupIndex = 3
        RadioItem = True
        ShortCut = 49217
        OnClick = RGBMindenszn1Click
      end
      object Monokrm1: TMenuItem
        Caption = 'Monokr'#243'm'
        GroupIndex = 3
        ImageIndex = 26
        RadioItem = True
        ShortCut = 49229
        OnClick = Monokrm1Click
      end
      object RVrs1: TMenuItem
        Caption = 'R - V'#246'r'#246's'
        GroupIndex = 3
        ShortCut = 16466
        OnClick = RVrs1Click
      end
      object GZld1: TMenuItem
        Caption = 'G - Z'#246'ld'
        GroupIndex = 3
        ShortCut = 16455
        OnClick = GZld1Click
      end
      object BKk1: TMenuItem
        Caption = 'B - K'#233'k'
        GroupIndex = 3
        ShortCut = 16450
        OnClick = BKk1Click
      end
      object N19: TMenuItem
        Caption = '-'
        GroupIndex = 3
      end
      object StyleMenu: TMenuItem
        Caption = 'K'#233'perny'#337' st'#237'lusok'
        GroupIndex = 3
      end
    end
    object SABLONOK1: TMenuItem
      Caption = 'Sablonok'
      object Sablontr1: TMenuItem
        Caption = 'Sablon t'#225'r'
        Visible = False
      end
      object N24: TMenuItem
        Caption = '-'
        Visible = False
      end
      object Sablonbetltse1: TMenuItem
        Caption = 'Sablon bet'#246'lt'#233'se'
        OnClick = btnSalonLoadClick
      end
      object Sablonmentse1: TMenuItem
        Caption = 'Sablon ment'#233'se'
        OnClick = btnSablonSaveClick
      end
      object N25: TMenuItem
        Caption = '-'
      end
      object LEJRSZS2: TMenuItem
        Caption = 'LEJ'#193'RSZ'#193'S'
        ShortCut = 120
        OnClick = btnRUNClick
      end
      object LPTETS2: TMenuItem
        Caption = 'L'#201'PTET'#201'S'
        ShortCut = 119
        OnClick = btnSTEPClick
      end
      object N26: TMenuItem
        Caption = '-'
      end
      object jlista2: TMenuItem
        Caption = #218'j lista'
        OnClick = jlista1Click
      end
      object Mindentkijell2: TMenuItem
        Caption = 'Mindent kijel'#246'l'
        OnClick = Mindentkijell1Click
      end
      object Ellentteskijells2: TMenuItem
        Caption = 'Ellent'#233'tes kijel'#246'l'#233's'
        OnClick = Ellentteskijells1Click
      end
      object N27: TMenuItem
        Caption = '-'
      end
      object Kijelltektrlse2: TMenuItem
        Caption = 'Kijel'#246'ltek t'#246'rl'#233'se'
        OnClick = Kijelltektrlse1Click
      end
      object Nemkijelltektrlse2: TMenuItem
        Caption = 'Nem kijel'#246'ltek t'#246'rl'#233'se'
        OnClick = Nemkijelltektrlse1Click
      end
    end
    object Szerkeszts1: TMenuItem
      Caption = 'Szerkeszt'#233's'
      object N21: TMenuItem
        Caption = '-'
      end
      object Levons1: TMenuItem
        Action = Levonas
        ShortCut = 116
      end
      object Histogram1: TMenuItem
        Caption = 'Histogram'
        ShortCut = 117
        OnClick = HistoButtonClick
      end
      object Sklzs1: TMenuItem
        Caption = 'Sk'#225'l'#225'z'#225's'
        ShortCut = 118
        OnClick = SkalaButtonClick
      end
      object Konvolci1: TMenuItem
        Caption = 'Konvol'#250'ci'#243
        OnClick = KonvolButtonClick
      end
      object mASZKOLS1: TMenuItem
        Caption = 'Maszkol'#225's'
        OnClick = MaszkButtonClick
      end
      object Flatkorrekci1: TMenuItem
        Caption = 'Flat korrekci'#243
        OnClick = VirtulisFlatkorrekci1Click
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object lests1: TMenuItem
        Caption = #201'les'#237't'#233's'
        ShortCut = 8275
        OnClick = ElesButtonClick
      end
      object Medinszrs1: TMenuItem
        Caption = 'Medi'#225'n sz'#369'r'#233's'
        ShortCut = 8269
        OnClick = MedianButtonClick
      end
      object N17: TMenuItem
        Caption = '-'
      end
      object AutoWhiteBllance1: TMenuItem
        Caption = 'Automatikus feh'#233'regyens'#250'ly (WB)'
        OnClick = AutoWhiteBllance1Click
      end
      object ContrastStretch1: TMenuItem
        Caption = 'Contrast Stretch'
        OnClick = ContrastStretch1Click
      end
    end
    object Grafika1: TMenuItem
      Caption = 'Grafika'
      Enabled = False
      object jgrafika1: TMenuItem
        Caption = #218'j grafika'
      end
      object Grafikuseszkzk1: TMenuItem
        Caption = 'Grafikus eszk'#246'z'#246'k'
      end
      object Grafikusrtegbeki1: TMenuItem
        Caption = 'Grafikus r'#233'teg be/ki'
        Checked = True
      end
      object Grafikaakpre1: TMenuItem
        Caption = 'Grafika a k'#233'pre'
      end
      object N13: TMenuItem
        Caption = '-'
      end
      object Rajzol1: TMenuItem
        Caption = 'Rajzol'
        ImageIndex = 93
        object Vonal1: TMenuItem
          Caption = 'Vonal'
        end
        object Sokszgvonal1: TMenuItem
          Caption = 'Soksz'#246'g vonal'
        end
        object Zrtsokszg1: TMenuItem
          Caption = 'Z'#225'rt soksz'#246'g'
        end
        object glalap1: TMenuItem
          Caption = 'T'#233'glalap'
        end
        object Kr1: TMenuItem
          Caption = 'K'#246'r'
        end
        object Ellipszis1: TMenuItem
          Caption = 'Ellipszis'
        end
        object v1: TMenuItem
          Caption = #205'v'
        end
        object Splne1: TMenuItem
          Caption = 'Splne'
        end
        object Szabadkzirajz1: TMenuItem
          Caption = 'Szabadk'#233'zi rajz'
        end
      end
      object Felirat1: TMenuItem
        Caption = 'Felirat'
      end
      object N14: TMenuItem
        Caption = '-'
      end
      object Csillagkijells1: TMenuItem
        Caption = 'Csillag kijel'#246'l'#233's'
      end
    end
    object ASTRO1: TMenuItem
      Caption = 'ASTRO'
      object CsillaglistaTrlse1: TMenuItem
        Caption = 'Csillaglista T'#246'rl'#233'se'
        OnClick = Button10Click
      end
      object PreczisStarDetect1: TMenuItem
        Action = PreciseStarDetect
      end
      object AutoFotometria1: TMenuItem
        Caption = 'Auto Fotometria'
        OnClick = Button13Click
      end
      object CsillagListaMentse1: TMenuItem
        Caption = 'Csillaglista Ment'#233'se'
        OnClick = CsillagListaMentse1Click
      end
      object N12: TMenuItem
        Caption = '-'
      end
      object Grafikusfelletltszik1: TMenuItem
        Caption = 'Grafikus fel'#252'let l'#225'tszik'
        Checked = True
        Enabled = False
        ShortCut = 121
      end
      object Kpltszik1: TMenuItem
        Caption = 'K'#233'p l'#225'tszik'
        Checked = True
        ShortCut = 122
        OnClick = Kpltszik1Click
      end
      object Csillagokltszanak1: TMenuItem
        Caption = 'Csillagok l'#225'tszanak'
        Checked = True
        ShortCut = 123
        OnClick = Csillagokltszanak1Click
      end
      object N16: TMenuItem
        Caption = '-'
      end
      object VirtulisFlatkorrekci1: TMenuItem
        Caption = 'Manu'#225'lis Flat korrekci'#243
        OnClick = VirtulisFlatkorrekci1Click
      end
    end
    object Md1: TMenuItem
      Caption = 'M'#243'd'
      object mod_0: TMenuItem
        Caption = #193'ltal'#225'nos'
        GroupIndex = 2
        RadioItem = True
        OnClick = mod_0Click
      end
      object mod_1: TMenuItem
        Caption = 'Csillag'#225'szati'
        Checked = True
        GroupIndex = 2
        RadioItem = True
        OnClick = mod_1Click
      end
      object N8: TMenuItem
        Caption = '-'
        GroupIndex = 2
      end
      object Belltsok1: TMenuItem
        Caption = 'Be'#225'll'#237't'#225'sok'
        Enabled = False
        GroupIndex = 2
      end
    end
    object Segt1: TMenuItem
      Caption = 'Seg'#237't'#337
      object Segt2: TMenuItem
        Caption = 'Seg'#237't'#337
        ShortCut = 112
        OnClick = Segt2Click
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object jverzletltse1: TMenuItem
        Caption = #218'j verz'#243' let'#246'lt'#233'se'
        OnClick = jverzletltse1Click
      end
      object Language1: TMenuItem
        Caption = 'Nyelv'
        OnClick = Language1Click
      end
      object N18: TMenuItem
        Caption = '-'
      end
      object Programrl1: TMenuItem
        Caption = 'Programr'#243'l'
        ImageIndex = 95
        OnClick = Programrl1Click
      end
    end
  end
  object ActionList1: TActionList
    Left = 256
    Top = 177
    object FullScreen: TAction
      Category = 'View'
      Caption = 'Teljes k'#233'perny'#337
      ShortCut = 115
      OnExecute = FullScreenExecute
    end
    object CentralCross: TAction
      Category = 'View'
      Caption = 'K'#246'z'#233'pkereszt'
      OnExecute = CentralCrossExecute
    end
    object Meroracs: TAction
      Category = 'View'
      Caption = 'Meroracs'
      OnExecute = MeroracsExecute
    end
    object Levonas: TAction
      Category = 'szerkeszt'
      Caption = 'Levon'#225's'
      OnExecute = LevonasExecute
    end
    object StarDetect: TAction
      Category = 'ASTRO'
      Caption = 'Auto Stardetect'
      OnExecute = StarDetectExecute
    end
    object PreciseStarDetect: TAction
      Category = 'ASTRO'
      Caption = 'Prec'#237'zi'#243's StarDetect'
      OnExecute = PreciseStarDetectExecute
    end
  end
  object ZoomPopupMenu: TPopupMenu
    Left = 398
    Top = 140
    object Kpernyhzilleszts1: TMenuItem
      Caption = 'Total'
      OnClick = N2001Click
    end
    object N111: TMenuItem
      Tag = 100
      Caption = '1:1'
      OnClick = N2001Click
    end
    object N15: TMenuItem
      Caption = '-'
    end
    object N101: TMenuItem
      Tag = 10
      Caption = '10 %'
      OnClick = N2001Click
    end
    object N501: TMenuItem
      Tag = 50
      Caption = '50 %'
      OnClick = N2001Click
    end
    object N1001: TMenuItem
      Tag = 100
      Caption = '100 %'
      OnClick = N2001Click
    end
    object N2001: TMenuItem
      Tag = 200
      Caption = '200 %'
      OnClick = N2001Click
    end
  end
  object LevonPopup: TPopupMenu
    Left = 402
    Top = 200
    object Klasszikus1: TMenuItem
      Caption = 'Klasszikus'
      Checked = True
      RadioItem = True
      OnClick = Kiegyenslyooztt1Click
    end
    object Kiegyenslyooztt1: TMenuItem
      Tag = 1
      Caption = 'Kiegyens'#250'lyooztt'
      RadioItem = True
      OnClick = Kiegyenslyooztt1Click
    end
  end
  object CopyPopupMenu: TPopupMenu
    Left = 485
    Top = 140
    object eljeskpet2: TMenuItem
      Caption = 'Teljes k'#233'pet'
      Checked = True
      GroupIndex = 77
      RadioItem = True
      OnClick = eljeskpet2Click
    end
    object Kpernykpet2: TMenuItem
      Tag = 1
      Caption = 'K'#233'perny'#337' k'#233'pet'
      GroupIndex = 77
      RadioItem = True
      OnClick = eljeskpet2Click
    end
    object Kpenkijelltterletet1: TMenuItem
      Tag = 2
      Caption = 'K'#233'pen kijel'#246'lt ter'#252'letet'
      GroupIndex = 77
      RadioItem = True
      OnClick = eljeskpet2Click
    end
    object Kpernynkijel9ltterletet1: TMenuItem
      Tag = 3
      Caption = 'K'#233'perny'#337'n kijel'#246'lt ter'#252'letet'
      GroupIndex = 77
      RadioItem = True
      OnClick = eljeskpet2Click
    end
  end
  object janLanguage1: TjanLanguage
    SaveAble = True
    Left = 307
    Top = 180
  end
  object HistListPopupMenu: TPopupMenu
    Left = 648
    Top = 334
    object LEJRSZS1: TMenuItem
      Caption = 'LEJ'#193'RSZ'#193'S'
      ShortCut = 120
      OnClick = btnRUNClick
    end
    object LPTETS1: TMenuItem
      Caption = 'L'#201'PTET'#201'S'
      ShortCut = 119
      OnClick = btnSTEPClick
    end
    object N22: TMenuItem
      Caption = '-'
    end
    object jlista1: TMenuItem
      Caption = #218'j lista'
      OnClick = jlista1Click
    end
    object Mindentkijell1: TMenuItem
      Caption = 'Mindent kijel'#246'l'
      OnClick = Mindentkijell1Click
    end
    object Ellentteskijells1: TMenuItem
      Caption = 'Ellent'#233'tes kijel'#246'l'#233's'
      OnClick = Ellentteskijells1Click
    end
    object N23: TMenuItem
      Caption = '-'
    end
    object Kijelltektrlse1: TMenuItem
      Caption = 'Kijel'#246'ltek t'#246'rl'#233'se'
      OnClick = Kijelltektrlse1Click
    end
    object Nemkijelltektrlse1: TMenuItem
      Caption = 'Nem kijel'#246'ltek t'#246'rl'#233'se'
      OnClick = Nemkijelltektrlse1Click
    end
  end
end
