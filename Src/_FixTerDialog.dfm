object FixTerForm: TFixTerForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Fix ter'#252'let m'#233'retei'
  ClientHeight = 73
  ClientWidth = 239
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
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 54
    Height = 13
    Caption = 'Sz'#233'less'#233'g: '
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 55
    Height = 13
    Caption = 'Hossz'#250's'#225'g:'
  end
  object SpinEdit1: TSpinEdit
    Left = 72
    Top = 8
    Width = 69
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 0
    Value = 100
  end
  object SpinEdit2: TSpinEdit
    Left = 72
    Top = 36
    Width = 69
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 100
  end
  object BitBtn1: TBitBtn
    Left = 156
    Top = 8
    Width = 75
    Height = 25
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 2
  end
  object BitBtn2: TBitBtn
    Left = 156
    Top = 34
    Width = 75
    Height = 25
    Kind = bkNo
    NumGlyphs = 2
    TabOrder = 3
  end
  object janLanguage1: TjanLanguage
    Left = 211
    Top = 45
  end
end
