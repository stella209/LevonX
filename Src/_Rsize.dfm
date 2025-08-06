object ResizeDlg: TResizeDlg
  Left = 343
  Top = 265
  BorderStyle = bsDialog
  Caption = 'Resize/Resample Image'
  ClientHeight = 243
  ClientWidth = 276
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 13
    Width = 82
    Height = 13
    Caption = 'Current Size  :'
  end
  object Label2: TLabel
    Left = 8
    Top = 39
    Width = 66
    Height = 13
    Caption = 'New Size  :'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 64
    Width = 257
    Height = 121
  end
  object Label3: TLabel
    Left = 238
    Top = 102
    Width = 10
    Height = 13
    Caption = '%'
  end
  object Label4: TLabel
    Left = 20
    Top = 76
    Width = 81
    Height = 13
    Caption = 'Resize mode :'
  end
  object Panel1: TPanel
    Left = 99
    Top = 8
    Width = 165
    Height = 23
    Caption = '0 x 0'
    TabOrder = 0
  end
  object RadioButton1: TRadioButton
    Left = 16
    Top = 102
    Width = 113
    Height = 17
    Caption = 'Percent %'
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 99
    Top = 34
    Width = 165
    Height = 23
    Caption = '0 x 0'
    TabOrder = 2
  end
  object SpinEdit1: TSpinEdit
    Left = 144
    Top = 99
    Width = 89
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 3
    Value = 0
    OnChange = SpinEdit1Change
  end
  object RadioButton2: TRadioButton
    Left = 16
    Top = 126
    Width = 153
    Height = 17
    Caption = 'Best fit to Desctop'
    TabOrder = 4
    OnClick = RadioButton2Click
  end
  object Button1: TButton
    Left = 48
    Top = 150
    Width = 97
    Height = 25
    Caption = 'Half (50%)'
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 152
    Top = 150
    Width = 97
    Height = 25
    Caption = 'Double (200%)'
    TabOrder = 6
    OnClick = Button2Click
  end
  object OkBtn: TBitBtn
    Left = 151
    Top = 210
    Width = 75
    Height = 25
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 7
  end
  object BitBtn2: TBitBtn
    Left = 70
    Top = 210
    Width = 75
    Height = 25
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 8
  end
  object ComboBox1: TComboBox
    Left = 108
    Top = 72
    Width = 153
    Height = 21
    TabOrder = 9
    Text = 'Simple'
    OnClick = ComboBox1Click
    Items.Strings = (
      'Simple'
      'Smooth'
      'Box'
      'Triangle'
      'Hermite'
      'Bell'
      'B-Spline'
      'Lanczos3'
      'Mitchell')
  end
  object janLanguage1: TjanLanguage
    SaveAble = True
    Left = 233
    Top = 172
  end
end
