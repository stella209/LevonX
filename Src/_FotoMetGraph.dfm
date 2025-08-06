object FotometGrafForm: TFotometGrafForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Ref. Stars - Luminosity - G magnitude Diagramme'
  ClientHeight = 358
  ClientWidth = 589
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Chart1: TChart
    Left = 243
    Top = 0
    Width = 346
    Height = 358
    Legend.Visible = False
    Title.Text.Strings = (
      'Intensity - Gmg')
    BottomAxis.LabelsFormat.TextAlignment = taCenter
    BottomAxis.Title.Caption = 'I'
    DepthAxis.LabelsFormat.TextAlignment = taCenter
    DepthTopAxis.LabelsFormat.TextAlignment = taCenter
    LeftAxis.LabelsFormat.TextAlignment = taCenter
    LeftAxis.Title.Caption = 'G mg'
    LeftAxis.TitleSize = 12
    RightAxis.LabelsFormat.TextAlignment = taCenter
    TopAxis.LabelsFormat.TextAlignment = taCenter
    View3D = False
    Zoom.Pen.Mode = pmNotXor
    Align = alClient
    TabOrder = 0
    DefaultCanvas = 'TGDIPlusCanvas'
    PrintMargins = (
      15
      8
      15
      8)
    ColorPaletteIndex = 13
    object Series1: TLineSeries
      ColorEachLine = False
      Marks.Visible = False
      Brush.BackColor = clDefault
      Pointer.Brush.Gradient.EndColor = 10708548
      Pointer.Gradient.EndColor = 10708548
      Pointer.HorizSize = 2
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Transparency = 27
      Pointer.VertSize = 2
      Pointer.Visible = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series2: TLineSeries
      Marks.Visible = False
      SeriesColor = clRed
      Brush.BackColor = clDefault
      DrawStyle = dsCurve
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object DataGrid: TSTDataGrid
    Left = 0
    Top = 0
    Width = 243
    Height = 358
    Align = alLeft
    DefaultColWidth = 36
    DefaultRowHeight = 18
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    AutoAppendRow = False
    CopyAboweRow = False
    OEMConversion = False
    TitleLabels.Strings = (
      'No'
      'ID'
      'Radius'
      'Intensity'
      'Gmg')
    ColWidths = (
      36
      46
      58
      50
      45)
  end
  object janLanguage1: TjanLanguage
    Left = 307
    Top = 180
  end
end
