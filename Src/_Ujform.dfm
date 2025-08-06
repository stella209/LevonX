object UjForm: TUjForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'K'#233'pter'#252'let m'#233'retez'#233's'
  ClientHeight = 406
  ClientWidth = 478
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
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 140
    Top = 369
    Width = 185
    Height = 37
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 11
      Top = 5
      Width = 75
      Height = 25
      Caption = 'M'#233'gse'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 100
      Top = 5
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
      OnClick = BitBtn2Click
    end
  end
  object Panel1: TPanel
    Left = 12
    Top = 12
    Width = 185
    Height = 169
    TabOrder = 1
    object Label1: TLabel
      Left = 20
      Top = 64
      Width = 54
      Height = 13
      Caption = 'Sz'#233'less'#233'g :'
    end
    object Label2: TLabel
      Left = 21
      Top = 92
      Width = 58
      Height = 13
      Caption = 'Hossz'#250's'#225'g :'
    end
    object Label3: TLabel
      Left = 21
      Top = 125
      Width = 26
      Height = 13
      Caption = 'Sz'#237'n :'
    end
    object Shape1: TShape
      Left = 80
      Top = 121
      Width = 49
      Height = 23
      Hint = 'Sz'#237'npaletta kattint'#225'sra'
      Brush.Color = clGray
      OnMouseDown = Shape1MouseDown
    end
    object SpeedButton1: TSpeedButton
      Left = 135
      Top = 55
      Width = 23
      Height = 22
      Caption = '2x'
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 135
      Top = 86
      Width = 23
      Height = 22
      Caption = '2x'
      OnClick = SpeedButton2Click
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 183
      Height = 28
      Align = alTop
      Caption = 'V'#193'SZON'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object KepCheck: TCheckBox
      Left = 21
      Top = 35
      Width = 104
      Height = 17
      Caption = 'K'#233'p megtart'#225's'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      State = cbChecked
      TabOrder = 1
    end
    object Edit1: TEdit
      Left = 80
      Top = 58
      Width = 49
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      HideSelection = False
      ParentFont = False
      TabOrder = 2
      Text = '1000'
      StyleElements = [seFont]
    end
    object Edit2: TEdit
      Left = 80
      Top = 86
      Width = 49
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      Text = '1000'
      StyleElements = [seFont]
    end
  end
  object Panel3: TPanel
    Left = 12
    Top = 188
    Width = 185
    Height = 175
    TabOrder = 2
    object Label4: TLabel
      Left = 16
      Top = 34
      Width = 54
      Height = 13
      Caption = 'Sz'#233'less'#233'g :'
    end
    object Label5: TLabel
      Left = 16
      Top = 63
      Width = 26
      Height = 13
      Caption = 'Sz'#237'n :'
    end
    object Shape2: TShape
      Left = 80
      Top = 59
      Width = 49
      Height = 23
      Hint = 'Sz'#237'npaletta kattint'#225'sra'
      Brush.Color = clGray
      OnMouseDown = Shape1MouseDown
    end
    object Label6: TLabel
      Left = 16
      Top = 123
      Width = 54
      Height = 13
      Caption = 'Sz'#233'less'#233'g :'
    end
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 183
      Height = 24
      Align = alTop
      Caption = 'KERET'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object cbKeret: TCheckBox
        Left = 5
        Top = 4
        Width = 16
        Height = 15
        TabOrder = 0
      end
    end
    object SpinEdit1: TSpinEdit
      Left = 80
      Top = 31
      Width = 49
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
    object SpinEdit2: TSpinEdit
      Left = 80
      Top = 120
      Width = 49
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
    object RadioButton1: TRadioButton
      Left = 16
      Top = 148
      Width = 59
      Height = 17
      Caption = 'Alul'
      Checked = True
      TabOrder = 3
      TabStop = True
      OnClick = RadioButton1Click
    end
    object RadioButton2: TRadioButton
      Left = 80
      Top = 148
      Width = 59
      Height = 17
      Caption = 'Fel'#252'l'
      TabOrder = 4
      OnClick = RadioButton2Click
    end
    object Panel6: TPanel
      Left = 0
      Top = 90
      Width = 183
      Height = 24
      Caption = 'ADATS'#193'V'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      object CheckBox1: TCheckBox
        Left = 5
        Top = 4
        Width = 16
        Height = 15
        TabOrder = 0
      end
    end
  end
  object Panel5: TPanel
    Left = 208
    Top = 13
    Width = 257
    Height = 350
    TabOrder = 3
    object wImage: TImage
      Left = 4
      Top = 48
      Width = 245
      Height = 260
    end
    object Button1: TButton
      Left = 20
      Top = 12
      Width = 209
      Height = 29
      Caption = 'K'#233'phez igaz'#237't'#225's'
      TabOrder = 0
    end
    object Button2: TButton
      Left = 68
      Top = 316
      Width = 117
      Height = 25
      Caption = 'K'#233'pfriss'#237't'#233's'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object janLanguage1: TjanLanguage
    SaveAble = True
    Left = 148
    Top = 4
  end
  object ColorDialog: TColorDialog
    Left = 152
    Top = 132
  end
end
