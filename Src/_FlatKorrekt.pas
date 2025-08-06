unit _FlatKorrekt;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AL_ZoomImg, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.ComCtrls, Math, NewGeom, Staf_Imp, Vcl.Samples.Spin,
  janLanguage;

type
  TFlatForm = class(TForm)
    Panel1: TPanel;
    Bevel1: TBevel;
    SpeedButton7: TSpeedButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ALZ: TALZoomImage;
    TrackBar1: TTrackBar;
    QImage: TImage;
    GrImage: TImage;
    RLabel: TLabel;
    Label1: TLabel;
    Button1: TButton;
    SpeBlur: TSpinEdit;
    janLanguage1: TjanLanguage;
    SpeedButton4: TSpeedButton;
    procedure BitBtn2Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    function FormHelp(Command: Word; Data: NativeInt;
      var CallHelp: Boolean): Boolean;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    BackBMP : TBitmap;
    oldLanguage: string;
    function InitGraph(ix: double): double;
  public
    Changed   : boolean;
    CrossWidth: double;    // A kép hosszabbik átlójának fele
    spRadius  : double;    // Gömb sugara
    function Execute(inBitmap: TBitmap): boolean;
 end;

var
  FlatForm: TFlatForm;

procedure ImageFlatCorrect(bm: TBitmap; R: double);
procedure SetImageColor(bm: TBitmap; co: TColor);

implementation

{$R *.dfm}

procedure TFlatForm.BitBtn2Click(Sender: TObject);
begin
  if TWincontrol(Sender).Focused then begin
      ModalResult := mrOk;
      Changed := True;
  end;
end;

procedure TFlatForm.Button1Click(Sender: TObject);
var bm: TBitmap;
begin
try
  SCREEN.Cursor := crHourGlass;
  bm := TBitmap.Create;
  ALZ.WorkBMP.Assign(ALZ.OrigBMP);
  bm.Assign(ALZ.OrigBMP);
  GaussianBlur(bm,SpeBlur.Value);
//  ALZ.WorkBMP.Assign(bm);
  FlatCorrection(ALZ.WorkBMP,bm);
  ALZ.ReDraw;
finally
  bm.Free;
  SCREEN.Cursor := crDefault;
end;
end;

function TFlatForm.Execute(inBitmap: TBitmap): boolean;
VAR w,h: integer;
begin
Try
     Result := False;
     Changed := False;
     ALZ.WorkBMP.OnChange := NIL;
     CrossWidth := SQRT(sqr(inBitmap.Width)+sqr(inBitmap.Height))/2;
     ALZ.OrigBMP.Assign(inBitmap);
     ALZ.RestoreOriginal;
     BackBMP := TBitmap.Create;
     BackBMP.Pixelformat := pf24bit;
     BackBMP.Width := QImage.Width;
     BackBMP.Height := QImage.Height;
     cls(BackBMP.Canvas,RGB(128,128,128));
     QImage.Picture.Bitmap.Assign(BackBMP);
     spRadius := InitGraph(TrackBar1.Position);
     ShowModal;
     if Changed then
     if Modalresult=mrOk then begin
        inBitmap.Assign(ALZ.WorkBMP);
        Result := True;
     end;
     BackBMP.Free;
except
end;
end;

procedure TFlatForm.FormActivate(Sender: TObject);
begin
  if oldLanguage <> janLanguage1.GetLang then begin
     janLanguage1.InitLanguage(Self);
     oldLanguage := janLanguage1.LanguageFile;
  end;
end;

procedure TFlatForm.FormCreate(Sender: TObject);
begin
  janLanguage1.InitLanguage(Self);
  oldLanguage := janLanguage1.LanguageFile;
end;

function TFlatForm.FormHelp(Command: Word; Data: NativeInt;
  var CallHelp: Boolean): Boolean;
begin
     HtmlHelp(0, Application.HelpFile, 111, 0);
end;

procedure TFlatForm.SpeedButton4Click(Sender: TObject);
begin
  ALZ.FitToScreen;
end;

procedure TFlatForm.SpeedButton7Click(Sender: TObject);
begin
     ALZ.RestoreOriginal;
end;

procedure TFlatForm.TrackBar1Change(Sender: TObject);
var R: double;
    bm: TBitmap;
begin
  R := InitGraph(TrackBar1.Position);
  RLabel.Caption := 'R='+IntToStr(Round(R));
  spRadius := -R;
  Label1.Caption := Inttostr(-TrackBar1.Position);
  Label1.Update;
  ALZ.WorkBMP.Assign(ALZ.OrigBMP);
  ImageFlatCorrect(ALZ.WorkBMP,-R);
  ALZ.ReDraw;
  bm := TBitmap.Create;
  cls(BackBMP.Canvas,RGB(50,50,50));
  bm.Assign(BackBMP);
  ImageFlatCorrect(bm,-R*QImage.Width/ALZ.WorkBMP.Width);
  QImage.Canvas.Draw(0,0,bm);
  QImage.Repaint;
  bm.Free;
end;

// Draw graphicon and result the sphere radius
function TFlatForm.InitGraph(ix: double): double;
var h: integer;
    sph: TPoint3d;
    wt: double;
begin
  h := GrImage.Height div 2;
  cls(GrImage.Canvas,clWhite);
  GrImage.Canvas.Pen.Color := clBlack;
  ShowLine(GrImage.Canvas,0,h,GrImage.Width,h);
  sph:=HaromPontbolKor(Point2d(-CrossWidth,ix),Point2d(0,0),Point2d(CrossWidth,ix));
  GrImage.Canvas.Pen.Color := clRed;
  wt := h/128;
  if ix=0 then
     ShowLine(GrImage.Canvas,0,h,GrImage.Width,h)
  else
  KorivRajzol(GrImage.Canvas,Point2d(0,wt*ix+h),Point2d(GrImage.Width,h),Point2d(2*GrImage.Width,wt*ix+h));
  GrImage.Update;
  if ix=0 then
     Result := 0
  else
     Result := sign(ix)*sph.z;
end;

procedure SetImageColor(bm: TBitmap; co: TColor);
// A bm bitmap minden pixele felveszi a co szín értéket
var
  x,y : Integer;
  ps  : pbytearray;
  R,G,B: byte;
begin
  R := GetRValue(co);
  G := GetGValue(co);
  B := GetBValue(co);
  for y := 0 to Pred(bm.height) do begin
      ps := bm.Scanline[y];
      for x := 0 to Pred(bm.Width) do
      begin
           ps[3*x]   := G;
           ps[3*x+1] := B;
           ps[3*x+2] := R;
      end;
  end;
end;

// R a gömb sugara
procedure ImageFlatCorrect(bm: TBitmap; R: double);
var
  x,y,xv: Integer;
  ps,pd:pbytearray;
  cent: TPoint2d;
  corr: double;
  d : double;
  yy: double;
  AR,rr: double;
  Imax: double;

function IntToByte(i:Integer):Byte;
begin
  if i > 255 then
    Result := 255
  else if i < 0 then
    Result := 0
  else
    Result := i;
end;

begin
Try
  if R=0 then exit;
  Cent := Point2d(bm.Width/2,bm.Height/2);
  AR   := Abs(R);
  rr   := sqr(AR);
  Imax := 128;
  for y := 0 to Pred(bm.height div 2) do
  begin
    ps := bm.Scanline[y];
    pd := bm.Scanline[bm.Height-y-1];
    for x := 0 to Pred(bm.Width div 2) do
    begin
      xv   := bm.Width-x-1;
      d    := RelDist2D(cent,Point2d(x,y));
      yy   := Sqrt(rr-sqr(d));
      yy   := yy-AR+Imax;
      corr := Imax-yy;
      if R<0 then
         corr := yy-Imax;
      ps[3*x]   := IntToByte(Round(ps[3*x]+corr));
      ps[3*x+1] := IntToByte(Round(ps[3*x+1]+corr));
      ps[3*x+2] := IntToByte(Round(ps[3*x+2]+corr));
      ps[3*xv]  := IntToByte(Round(ps[3*xv]+corr));
      ps[3*xv-1]:= IntToByte(Round(ps[3*xv-1]+corr));
      ps[3*xv-2]:= IntToByte(Round(ps[3*xv-2]+corr));

      pd[3*x]   := IntToByte(Round(pd[3*x]+corr));
      pd[3*x+1] := IntToByte(Round(pd[3*x+1]+corr));
      pd[3*x+2] := IntToByte(Round(pd[3*x+2]+corr));
      pd[3*xv]  := IntToByte(Round(pd[3*xv]+corr));
      pd[3*xv-1]:= IntToByte(Round(pd[3*xv-1]+corr));
      pd[3*xv-2]:= IntToByte(Round(pd[3*xv-2]+corr));
(*
      xv   := bm.Width-x-1;
      d    := RelDist2D(cent,Point2d(x,y));
      yy   := Sqrt(rr-sqr(d));
      yy   := yy-AR+Imax;
      corr := yy/Imax;
      if R<0 then
         corr := 1/corr;
      ps[3*x]   := IntToByte(Round(ps[3*x]*corr));
      ps[3*x+1] := IntToByte(Round(ps[3*x+1]*corr));
      ps[3*x+2] := IntToByte(Round(ps[3*x+2]*corr));
      ps[3*xv]  := IntToByte(Round(ps[3*xv]*corr));
      ps[3*xv-1]:= IntToByte(Round(ps[3*xv-1]*corr));
      ps[3*xv-2]:= IntToByte(Round(ps[3*xv-2]*corr));

      pd[3*x]   := IntToByte(Round(pd[3*x]*corr));
      pd[3*x+1] := IntToByte(Round(pd[3*x+1]*corr));
      pd[3*x+2] := IntToByte(Round(pd[3*x+2]*corr));
      pd[3*xv]  := IntToByte(Round(pd[3*xv]*corr));
      pd[3*xv-1]:= IntToByte(Round(pd[3*xv-1]*corr));
      pd[3*xv-2]:= IntToByte(Round(pd[3*xv-2]*corr));*)
    end;
  end;
except
  exit;
end;
end;

end.
