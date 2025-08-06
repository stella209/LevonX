object UjForm: TUjForm
  Left = 0
  Top = 0
  ActiveControl = Edit1
  BorderStyle = bsDialog
  Caption = 'K'#233'pter'#252'let m'#233'rete'
  ClientHeight = 253
  ClientWidth = 280
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
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 54
    Height = 13
    Caption = 'Sz'#233'less'#233'g :'
  end
  object Label2: TLabel
    Left = 16
    Top = 45
    Width = 58
    Height = 13
    Caption = 'Hossz'#250's'#225'g :'
  end
  object Label3: TLabel
    Left = 16
    Top = 80
    Width = 26
    Height = 13
    Caption = 'Sz'#237'n :'
  end
  object Shape1: TShape
    Left = 76
    Top = 66
    Width = 49
    Height = 41
    Hint = 'Sz'#237'npaletta kattint'#225'sra'
    Brush.Color = clGray
    OnMouseDown = Shape1MouseDown
  end
  object SpeedButton1: TSpeedButton
    Left = 124
    Top = 13
    Width = 23
    Height = 22
    Caption = '2x'
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 124
    Top = 39
    Width = 23
    Height = 22
    Caption = '2x'
    OnClick = SpeedButton2Click
  end
  object RadioGroup1: TRadioGroup
    Left = 158
    Top = 8
    Width = 107
    Height = 113
    ItemIndex = 3
    Items.Strings = (
      'K'#246'z'#233'pre'
      'K'#246'z'#233'pre fent'
      'K'#246'z'#233'pre lent'
      'Bal sarokba')
    TabOrder = 3
  end
  object Edit1: TEdit
    Left = 76
    Top = 13
    Width = 49
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    HideSelection = False
    ParentFont = False
    TabOrder = 0
    Text = '1000'
    StyleElements = [seFont]
  end
  object Edit2: TEdit
    Left = 76
    Top = 39
    Width = 49
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    Text = '1000'
    StyleElements = [seFont]
  end
  object KepCheck: TCheckBox
    Left = 161
    Top = 9
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
    TabOrder = 2
  end
  object CheckBox1: TCheckBox
    Left = 16
    Top = 128
    Width = 129
    Height = 17
    Caption = 'K'#233'pm'#233'ret megtart'#225'sa'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object CheckBox2: TCheckBox
    Left = 16
    Top = 146
    Width = 122
    Height = 17
    Caption = 'K'#233'pm'#233'ret sz'#233'less'#233'g'
    TabOrder = 5
  end
  object CheckBox3: TCheckBox
    Left = 16
    Top = 164
    Width = 122
    Height = 17
    Caption = 'K'#233'pm'#233'ret hossz'#250's'#225'g'
    TabOrder = 6
  end
  object GroupBox1: TGroupBox
    Left = 56
    Top = 204
    Width = 185
    Height = 37
    TabOrder = 7
    object BitBtn1: TBitBtn
      Left = 10
      Top = 7
      Width = 75
      Height = 25
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 102
      Top = 7
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
  object ColorDialog: TColorDialog
    Left = 88
    Top = 80
  end
  object janLanguage1: TjanLanguage
    SaveAble = True
    Left = 252
    Top = 180
  end
end
