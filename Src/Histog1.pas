unit Histog1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Buttons, ExtDlgs, StdCtrls,
  Math, ComCtrls, STAF_Imp, VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series,
  VCLTee.TeeProcs, VCLTee.Chart, janLanguage;

type

  THistogramForm = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Chart1: TChart;
    Series2: TLineSeries;
    Series3: TLineSeries;
    OpenPictureDialog1: TOpenPictureDialog;
    SpeedButton1: TSpeedButton;
    TR0: TTrackBar;
    TR1: TTrackBar;
    TR2: TTrackBar;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SpeedButton4: TSpeedButton;
    TR3: TTrackBar;
    TR4: TTrackBar;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    TR5: TTrackBar;
    RGBCheck: TCheckBox;
    Label10: TLabel;
    TR6: TTrackBar;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Ed0: TEdit;
    Ed1: TEdit;
    Ed2: TEdit;
    Ed3: TEdit;
    Ed4: TEdit;
    Ed5: TEdit;
    Ed6: TEdit;
    Button4: TButton;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    Series1: TLineSeries;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    janLanguage1: TjanLanguage;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TR0Change(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure Ed0KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button4Click(Sender: TObject);
    procedure TR0KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CheckBox5Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    oldLanguage: string;
    bmp : Tbitmap;
    RGBBmp : Tbitmap;
    Colors  : TRGBColorsArray;
    HistVis : array[0..3] of boolean;
    procedure Hist(BITMAP: TBitmap);
  public
    Changed : boolean;
    Params: THistoParams;
    function Execute(inBitmap: TBitmap): boolean;
    Procedure ColorsInit;
    procedure HistogrammDraw(R,G,B,Lum: boolean);
    procedure DoChange(ResultBMP: TBitmap);
  end;

var
  HistogramForm: THistogramForm;


implementation

{$R *.DFM}

function THistogramForm.Execute(inBitmap: TBitmap): boolean;
begin
Try
     Result := False;
     Changed := False;
     Button4Click(nil);
     RGBBmp.Width := Image1.Width;
     RGBBmp.Height := Image1.Height;
     RGBBmp.Canvas.StretchDraw(RGBBmp.Canvas.Cliprect,inBitmap);
     bmp.assign(RGBBmp);
     Image1.Picture.Bitmap.Assign(bmp);
     Hist(RGBBmp);
     ShowModal;
     if Changed then
     if Modalresult=mrOk then begin
        Result := True;
     end;
except
end;
end;

procedure THistogramForm.FormActivate(Sender: TObject);
begin
  if oldLanguage <> janLanguage1.GetLang then begin
     janLanguage1.InitLanguage(Self);
     oldLanguage := janLanguage1.LanguageFile;
  end;
end;

procedure THistogramForm.FormCreate(Sender: TObject);
var i: integer;
begin
  bmp := Tbitmap.Create;
  RGBBmp:= TBitmap.Create;
  for i:=0 to 3 do HistVis[i]:= False;
  HistVis[3]:= True;
  RGBBmp.Width := Image1.Width;
  RGBBmp.Height := Image1.Height;
  if FileExists('RGB.JPG') then begin
     Load_Bitmap('RGB.JPG',bmp);
     RGBBmp.Canvas.StretchDraw(RGBBmp.Canvas.Cliprect,BMP);
     bmp.assign(RGBBmp);
     Image1.Picture.Bitmap.Assign(bmp);
     Hist(RGBBmp);
  end;
  janLanguage1.InitLanguage(Self);
  oldLanguage := janLanguage1.LanguageFile;
end;

procedure THistogramForm.FormDestroy(Sender: TObject);
begin
  bmp.Free;
  RGBBmp.Free;
end;

procedure THistogramForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//  if Key=VK_RETURN then Modalresult:=mrNone;
end;

Procedure THistogramForm.ColorsInit;
var i,j: integer;
begin
  For i:=0 to 2 do
   For j:=0 to 255 do
    Colors[i,j] := 0; // RGB szinek tömbjét 0-ázza
end;

procedure THistogramForm.SpeedButton1Click(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then begin
     Load_Bitmap(OpenPictureDialog1.Filename,bmp);
     RGBBmp.Width := Image1.Width;
     RGBBmp.Height := Image1.Height;
     RGBBmp.Canvas.StretchDraw(RGBBmp.Canvas.Cliprect,BMP);
     bmp.assign(RGBBmp);
     Image1.Picture.Bitmap.Assign(bmp);
     TR0Change(Sender);
     Hist(RGBBmp);
  end;
end;

procedure THistogramForm.Hist(BITMAP: TBitmap);
var
  x,y : Integer;
  P : PByteArray;
  Co : TColor;
  R,G,B: Byte;
begin
  try
    HistogrammDraw(HistVis[0],HistVis[1],HistVis[2],HistVis[3]);
    Chart1.Repaint;
    Colors := GetRGBHistogram(BITMAP);
  finally
    HistogrammDraw(HistVis[0],HistVis[1],HistVis[2],HistVis[3]);
  end;
end;

procedure THistogramForm.HistogrammDraw(R,G,B,Lum: boolean);
var i,j: integer;
    Co : TColor;
begin
  For i:=0 to 2 do begin
   Chart1.Series[i].Clear;
   if HistVis[i] then begin
   For j:=0 to 255 do
    if Colors[i,j]>0 then
       Chart1.Series[I].AddXY(J,log10( Colors[i,j] ),'',Chart1.Series[i].SeriesColor)
    else
       Chart1.Series[I].AddXY(J,0,'',Chart1.Series[i].SeriesColor)
   end;
  end;

   if HistVis[3] then
   For j:=0 to 255 do begin
    Co := 0;
    For i:=0 to 2 do
        Co := Co + Colors[i,j];
    if Co>0 then
       Chart1.Series[0].AddXY(J,log10( Co ),'',clBlack)
    else
       Chart1.Series[0].AddXY(J,0,'',clBlack);
   end;

end;

procedure THistogramForm.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  Co : TColor;
  R,G,B: Byte;
begin
  Co := bmp.Canvas.Pixels[x,y];
//  Shape1.Brush.Color := Co;
        R:= GetRValue(Co);
        G:= GetGValue(Co);
        B:= GetBValue(Co);
//  Label1.Caption := IntToStr(R);
//  Label2.Caption := IntToStr(G);
//  Label3.Caption := IntToStr(B);
end;


procedure THistogramForm.TR0Change(Sender: TObject);
var TR : TTrackBar;
    TE : TEdit;
    i: integer;
    x,y   : integer;
    p     : integer;
    co    : TColor;
    R,G,B : Byte;
    Rsz,Gsz,Bsz : double;
begin
Try
  For i:=0 to 6 do begin
      TR := TTrackBar(FindComponent('TR'+IntToStr(i)));
      TE := TEdit(FindComponent('Ed'+IntToStr(i)));
      TE.Text := IntToStr(TR.Position);
      TE.Repaint;
  end;

  RGBBmp.Assign(BMP);

  // az RGB csúszkák együtt mozgása
  if RGBCheck.Checked then begin
  Case TComponent(Sender).tag of
  0: p:=TR0.Position;
  1: p:=TR1.Position;
  2: p:=TR2.Position;
  end;
  For i:=0 to 2 do begin
      TR := TTrackBar(FindComponent('TR'+IntToStr(i)));
      TR.OnChange := nil;
      TR.Position:=p;
      TR.OnChange := TR0Change;
  end;
  end;

  Rsz := (TR0.Position+255) / 255;
  Gsz := (TR1.Position+255) / 255;
  Bsz := (TR2.Position+255) / 255;

  ChangeRGB(RGBBmp,Rsz,Gsz,Bsz);
  Brightness(RGBBmp,TR3.Position);
  Contrast(RGBBmp,TR4.Position);
  Saturation(RGBBmp,TR5.Position+255);
  Gamma(RGBBmp,(TR6.Position+10)/10);
  If CheckBox5.Checked then BlackAndWhite(RGBBmp);
  If CheckBox6.Checked then Negative(RGBBmp);

  Image1.Picture.Bitmap.Assign(RGBBmp);
  Image1.Repaint;
  Hist(RGBBmp);
FINALLY
  Params.R      := Rsz;
  Params.G      := Gsz;
  Params.B      := Bsz;
  Params.Brightness := TR3.Position;
  Params.Contrast   := TR4.Position;
  Params.Saturation := TR5.Position;
  Params.Gamma      := (TR6.Position+10)/10;
  Params.Mono       := CheckBox5.Checked;
  Params.Negative   := CheckBox6.Checked;
  Changed := True;
end;
end;

procedure THistogramForm.SpeedButton4Click(Sender: TObject);
begin
  Image1.Picture.Bitmap.Assign(Bmp);
end;

procedure THistogramForm.CheckBox4Click(Sender: TObject);
begin
  HistVis[0]:= CheckBox1.Checked;
  HistVis[1]:= CheckBox2.Checked;
  HistVis[2]:= CheckBox3.Checked;
  HistVis[3]:= CheckBox4.Checked;
  Hist(RGBBmp);
end;

procedure THistogramForm.Ed0KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_RETURN then
  Case TComponent(Sender).Tag of
  0:   TR0.Position := StrToInt(TEdit(Sender).Text);
  1:   TR1.Position := StrToInt(TEdit(Sender).Text);
  2:   TR2.Position := StrToInt(TEdit(Sender).Text);
  3:   TR3.Position := StrToInt(TEdit(Sender).Text);
  4:   TR4.Position := StrToInt(TEdit(Sender).Text);
  5:   TR5.Position := StrToInt(TEdit(Sender).Text);
  6:   TR6.Position := StrToInt(TEdit(Sender).Text);
  end;
end;

procedure THistogramForm.BitBtn2Click(Sender: TObject);
begin
  if TWincontrol(Sender).Focused then
      ModalResult := mrOk;
end;

procedure THistogramForm.Button4Click(Sender: TObject);
var TR : TTrackBar;
    TE : TEdit;
    i: integer;
begin
  // Alapértékre állítja a csúszkákat és edit-eket
  For i:=0 to 6 do begin
      TR := TTrackBar(FindComponent('TR'+IntToStr(i)));
      TR.Position := (TR.SelEnd + TR.SelStart) div 2;
      TE := TEdit(FindComponent('Ed'+IntToStr(i)));
      TE.Text := IntToStr(TR.Position);
  end;
end;

procedure THistogramForm.TR0KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Csúszkák alaphelyzetbe
  if Key=VK_RETURN then
     TTrackBar(Sender).Position :=
       (TTrackBar(Sender).SelEnd + TTrackBar(Sender).SelStart) div 2;
end;

procedure THistogramForm.CheckBox5Click(Sender: TObject);
begin
  If not CheckBox5.Checked then
     RGBBmp.Assign(BMP);
     TR0Change(Sender);
end;

procedure THistogramForm.CheckBox6Click(Sender: TObject);
begin
  If not CheckBox6.Checked then
     RGBBmp.Assign(BMP);
     TR0Change(Sender);
end;

procedure THistogramForm.DoChange(ResultBMP: TBitmap);
var   Rsz,Gsz,Bsz : double;
begin
Try
  Screen.Cursor := crHourGlass;
  Rsz := (TR0.Position+255) / 255;
  Gsz := (TR1.Position+255) / 255;
  Bsz := (TR2.Position+255) / 255;
  Params.R      := Rsz;
  Params.G      := Gsz;
  Params.B      := Bsz;
  Params.Brightness := TR3.Position;
  Params.Contrast   := TR4.Position;
  Params.Saturation := TR5.Position;
  Params.Gamma      := (TR6.Position+10)/10;
  Params.Mono       := CheckBox5.Checked;
  Params.Negative   := CheckBox6.Checked;
//       ChangeAll(ResultBMP,Params);

       ChangeRGB(ResultBMP,Params.R,Params.G,Params.B);
       Brightness(ResultBMP,Params.Brightness);
       Contrast(ResultBMP,Params.Contrast);
       Saturation(ResultBMP,Params.Saturation+255);
       Gamma(ResultBMP,Params.Gamma);
       If Params.Mono then BlackAndWhite(ResultBMP);
       If Params.Negative then Negative(ResultBMP);

  Screen.Cursor := crDefault;
FINALLY
end;
end;

end.
