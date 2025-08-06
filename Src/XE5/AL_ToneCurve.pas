(*

  AL_ToneCurve : Interactive grafical Delphi component for modify a bitmap
  ------------   caracteristic in R-G-B chanels (like PhotoShop)

  Original idea and source by: Roy Magne Klever
                               rmklever@gmail.com
                               http://www.rmklever.com
                               Curve Tool : http://rmklever.com/?p=467

  LineStyle      New property the style of the lines between the cureve
                 points.
                 TToneCurveType = (cuvLinear, cuvSpline);

  imgView        A bitmap, where do the tone effects and get a histogram.

  ApplyCurve     The most important procedure: if you non declered az
                 imgView bitmap, you can gíve an outhern bitmap.

  This component has fix dimensions (width/height) = 272.

  Agócs László Hungary 2016
  StellaSOFT
  WEB       : http://stella.kojot.co.hu/
  Email     : lagocsstella@gmail.com

*)

unit AL_ToneCurve;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Math, StdCtrls, ExtCtrls, ComCtrls, FileCtrl, Szoveg, Szamok;

type

  PRGB_24 = ^TRGB_24;
  TRGB_24 = record B, G, R: Byte; end;
  PRGBArray = ^TRGBArray;
  TRGBArray = array [Word] of TRGB_24;

  TToneCurveType = (cuvLinear, cuvSpline);

(*
  TALCustomToneCurve = class(TCustomControl)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  published
  end;
*)

  TALToneCurve = class(TCustomControl)
  private
    FPresetPath: String;
    FimgView: TBitmap;
    FRepaint: TNotifyEvent;
    FFileName: String;
    FChannel: integer;
    FLineType: TToneCurveType;
    FColor: TColor;
    FHistogram: boolean;
    FPresetName: String;
    procedure WMEraseBkGnd(var Message:TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure SetFileName(const Value: String);
    procedure SetChannel(const Value: integer);
    procedure SetPresetPath(const Value: String);
    procedure setLineType(const Value: TToneCurveType);
    procedure SetColor(const Value: TColor);
    procedure SetHistogram(const Value: boolean);
  protected
    BackBMP : TBitmap;          // The memory bitmap for drawing
    nPts: Array[0..3] of Integer;
    ptX, ptY: Array[0..3, 1..32] of Integer;
    ptP, ptU: Array[0..3, 1..32] of Single;
    nHist: Array[0..3, Byte] of Integer;
    maxHist: Array[0..3] of Integer;
    aPt, cIdx: Integer;
    oldHistogram: boolean;
    ImgLoaded: Boolean;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    function CompareNatural(s1, s2: string): Integer;
    function SortMe(List: TStringList; i1, i2: Integer): Integer;
    function Blend(Color1, Color2: TColor; A: Byte): TColor;
    procedure BilinearRescale(Src, Dest: TBitmap);
    function PtInCircle(cx, cy, x, y, radius: Integer): Boolean;
    procedure WuLine(x1, y1, x2, y2: integer; Color: TColor);
    procedure SetPandU;
    function GetCurvePoint(i: Integer; v: Single): Single;
    procedure DrawCurve;
    procedure AddPoint(pt: TPoint);
    procedure DelPoint(idx: Integer);
    procedure GetHist;
    function IsPoint(x, y: integer): integer;
  public
    LUT: Array[0..3, 0..255] of Byte; //
    Presets     : TStrings;
    constructor Create(AOwner: TComponent);override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure ApplyCurve(Img: TBitmap);
    procedure Reset;
    procedure Invers;
    procedure GetCurvesPreset(Files: TStrings);
    procedure LoadPreset(Idx: Integer); overload;
    procedure LoadPreset(PresetFile: string); overload; // Stella
    procedure SavePreset(fName: string);
    function  AddPreset: string;
    // Stella
    function  GetPresetString: string;
    procedure SetPresetString(PS: string);
  published
    property Channel    : integer read FChannel write SetChannel;            // 0:RGB, 1-2-3: r-g-b
    property Color      : TColor read FColor write SetColor default clWhite; // 0:RGB, 1-2-3: r-g-b
    property PresetPath : String read FPresetPath write SetPresetPath;       // Preset directory
    property Histogram  : boolean read FHistogram write SetHistogram; 
    property imgView    : TBitmap read FimgView write FimgView;              // Bitmap for tone curves
    property FileName   : String read FFileName write SetFileName;
    property LineType   : TToneCurveType read FLineType write setLineType;   // Linear/Spline
    property PresetName : String read FPresetName write FPresetName;
    property OnRepaint  : TNotifyEvent read FRepaint write FRepaint;
  end;

//  procedure Register;

implementation

constructor TALToneCurve.Create(AOwner: TComponent);
var
  bmp: TBitmap;
  i, j: Integer;
begin
  inherited;
  Presets := TStringList.Create;
  BackBMP := TBitmap.Create;
  BackBMP.Width := 1;
  BackBMP.Height := 1;
  BackBMP.Canvas.Pixels[0, 0] := $00C4C4C4;
  bmp:= TBitmap.Create;
  bmp.PixelFormat:= pf24bit;
  bmp.Width:= 276;
  bmp.Height:= 276;
  BackBMP.Assign(bmp);
  bmp.Free;
  FLineType := cuvSpline;
  FHistogram := True;
  FChannel := 0;
  cIdx:= 0;
  aPt:= -1;
  // Init start values
  for i:= 0 to 3 do begin
    nPts[i]:= 2;
    ptX[i, 1]:= 0;
    ptX[i, 2]:= 255;
    ptY[i, 1]:= 0;
    ptY[i, 2]:= 255;
    for j:= 0 to 255 do LUT[i, j]:= j;
  end;
  FPresetPath:= ExtractFileDir(Application.ExeName) + '\Curves\';
  GetCurvesPreset(Presets);
  FPresetName := '';
  Color := clWhite;
  width := 272;
  height := 272;
end;

destructor TALToneCurve.Destroy;
begin
  BackBMP.Free;
  Presets.Free;
  inherited;
end;

function TALToneCurve.CompareNatural(s1, s2: string): Integer;
  function ExtractNr(n: Integer; var Txt: string): Int64;
  begin
    while (n <= Length(Txt)) and (Txt[n] >= '0') and (Txt[n] <= '9') do n := n + 1;
    Result := StrToInt64Def(Copy(Txt, 1, n - 1), 0);
    Delete(Txt, 1, (n - 1));
  end;
var
  b: Boolean;
begin
  Result := 0;
  s1 := LowerCase(s1);
  s2 := LowerCase(s2);
  if (s1 <> s2) and (s1 <> '') and (s2 <> '') then begin
    b := False;
    while (not b) do begin
      if ((s1[1] >= '0') and (s1[1] <= '9')) and ((s2[1] >= '0') and (s2[1] <= '9')) then
        Result := Sgn(ExtractNr(1, s1) - ExtractNr(1, s2))
      else
        Result := Sgn(Integer(s1[1]) - Integer(s2[1]));
      b := (Result <> 0) or (Min(Length(s1), Length(s2)) < 2);
      if not b then begin
        Delete(s1, 1, 1);
        Delete(s2, 1, 1);
      end;
    end;
  end;
  if Result = 0 then begin
    if (Length(s1) = 1) and (Length(s2) = 1) then
      Result := Sgn(Integer(s1[1]) - Integer(s2[1]))
    else
      Result := Sgn(Length(s1) - Length(s2));
  end;
end;

function TALToneCurve.SortMe(List: TStringList; i1, i2: Integer): Integer;
begin
  Result := CompareNatural(List[i1], List[i2]);
end;

function TALToneCurve.Blend(Color1, Color2: TColor; A: Byte): TColor;
var
  c1, c2: LongInt;
  r, g, b, v1, v2: byte;
begin
  A := Round(2.56 * A);
  c1 := ColorToRGB(Color1);
  c2 := ColorToRGB(Color2);
  v1 := Byte(c1);
  v2 := Byte(c2);
  r := A * (v1 - v2) shr 8 + v2;
  v1 := Byte(c1 shr 8);
  v2 := Byte(c2 shr 8);
  g := A * (v1 - v2) shr 8 + v2;
  v1 := Byte(c1 shr 16);
  v2 := Byte(c2 shr 16);
  b := A * (v1 - v2) shr 8 + v2;
  Result := (b shl 16) + (g shl 8) + r;
end;

procedure TALToneCurve.BilinearRescale(Src, Dest: TBitmap);
var
  x, y, px, py: Integer;
  i, x1, x2, z, z2, iz2: Integer;
  w1, w2, w3, w4: Integer;
  Ratio: Integer;
  sDst, sDstOff: Integer;
  PScanLine: array of PRGBArray;
  Src1, Src2: PRGBArray;
  C, C1, C2: TRGB_24;
begin
  if (Dest.Width < 2) or (Dest.Height < 2) then begin
    Dest.Assign(Src);
    Exit;
  end;
  SetLength(PScanLine, Src.Height);
  PScanLine[0]:= (Src.Scanline[0]);
  i := Integer(Src.Scanline[1]) - Integer(PScanLine[0]);
  for y := 1 to Src.Height - 1 do PScanLine[y]:= PRGBArray(Integer(PScanLine[y - 1]) + i);
  sDst := Integer(Dest.ScanLine[0]);
  sDstOff := Integer(Dest.ScanLine[1]) - sDst;
  Ratio := ((Src.Width - 1) shl 15) div Dest.Width;
  py := 0;
  for y := 0 to Dest.Height - 1 do begin
    i := py shr 15;
    if i > src.Height - 1 then i := src.Height - 1;
    Src1 := PScanline[i];
    if i < src.Height - 1 then Src2 := PScanline[i + 1] else Src2 := Src1;
    z2 := py and $7FFF;
    iz2 := $8000 - z2;
    px := 0;
    for x := 0 to Dest.Width - 1 do begin
      x1 := px shr 15;
      x2 := x1 + 1;
      C1 := Src1[x1];
      C2 := Src2[x1];
      z := px and $7FFF;
      w2 := (z * iz2) shr 15;
      w1 := iz2 - w2;
      w4 := (z * z2) shr 15;
      w3 := z2 - w4;
      C.R := (C1.R * w1 + Src1[x2].R * w2 + C2.R * w3 + Src2[x2].R * w4) shr 15;
      C.G := (C1.G * w1 + Src1[x2].G * w2 + C2.G * w3 + Src2[x2].G * w4) shr 15;
      C.B := (C1.B * w1 + Src2[x2].B * w2 + C2.B * w3 + Src2[x2].B * w4) shr 15;
      PRGBArray(sDst)[x] := C;
      Inc(px, Ratio);
    end;
    sDst := sDst + SDstOff;
    Inc(py, Ratio);
  end;
  SetLength(PScanline, 0);
end;

function TALToneCurve.PtInCircle(cx, cy, x, y, radius: Integer): Boolean;
begin
  Result:= ((cx - x) * (cx - x)) + ((cy - y) * (cy - y)) <= radius * radius;
end;


procedure TALToneCurve.WuLine( x1, y1, x2, y2: integer; Color: TColor);
var
  Src: TBitmap;
  c: Cardinal;
  r, g, b: Byte;
  rgb: TRGB_24;
  i, dx, dy, x, y, w, h, a1, a2 : integer;
  dxi, dyi, gradient : integer;
  Line: array of PRGBArray;

  function BlendPixel(x, y, a: Integer): TRGB_24;
  begin
    Result.R:= a * (r - Line[y][x].R) shr 8 + Line[y][x].R;
    Result.G:= a * (g - Line[y][x].G) shr 8 + Line[y][x].G;
    Result.B:= a * (b - Line[y][x].B) shr 8 + Line[y][x].B;
  end;

begin
  c:= ColorToRGB(Color);
  r:= c and 255;
  g:= (c shr 8) and 255;
  b:= (c shr 16) and 255;
  w:= BackBMP.Width;
  h:= BackBMP.Height;
  if (x1 = x2) or (y1 = y2) then begin
    BackBMP.Canvas.Pen.Color:= Color;
    BackBMP.Canvas.MoveTo(x1, y1);
    BackBMP.Canvas.LineTo(x2, y2);
    Exit;
  end;
  // make an array of source scanlines to speed up the rendering
  SetLength(Line, BackBMP.Height);
  Line[0]:= (BackBMP.Scanline[0]);
  i:= Integer(BackBMP.Scanline[1]) - Integer(Line[0]);
  for y:= 1 to BackBMP.Height - 1 do Line[y]:= PRGBArray(Integer(Line[y - 1]) + i);
  dx:= abs(x2 - x1);
  dy:= abs(y2 - y1);
  if dx > dy then begin // horizontal or vertical
    if y2 > y1 then dy:= -dy;
    gradient:= dy shl 8 div dx;
    if x2 < x1 then begin
      i:= x1; x1:= x2; x2:= i;
      dyi:= y2 shl 8;
    end else begin
      dyi:= y1 shl 8;
      gradient:= -gradient;
    end;
    if x1 >= W then x2:= W - 1;
    for x := x1 to x2 do begin
      Y:= dyi shr 8;
      if (x < 0) or (y < 0) or (y > h - 2) then Inc(dyi, gradient) else begin
        a1 := dyi - y shl 8;
        a2 := 256 - a1;
        Line[y][x]:= BlendPixel(x, y, a1);
        Line[y + 1][x]:= BlendPixel(x, y + 1, a2);
        Inc(dyi, gradient);
      end;
    end;
  end else begin
    if x2 > x1 then dx:= -dx;
    gradient:= dx shl 8 div dy;
    if y2 < y1 then begin
      i:= y1; y1:= y2; y2:= i;
      dxi:= x2 shl 8;
    end else begin
      dxi:= x1 shl 8;
      gradient:= -gradient;
    end;
    if y2 >= h then y2:= h - 1;
    for y := y1 to y2 do begin
      x:= dxi shr 8;
      if (y < 0) or (x < 0) or (x > w - 2) then Inc(dxi, gradient) else begin
        a1 := dxi - x shl 8;
        a2 := 256 - a1;
        Line[y][x]:= BlendPixel(x, y, a2);
        Line[y][x + 1]:= BlendPixel(x + 1, y, a1);
        Inc(dxi, gradient);
      end;
    end;
  end;
end;

procedure TALToneCurve.AddPoint(pt: TPoint);
var
  i, x: Integer;
begin
  i:= 1;
  while (i <= nPts[cIdx]) and (pt.X > ptX[cIdx, i]) do i:= i + 1;
  if i <= nPts[cIdx] + 1 then begin
    Caption:= IntToStr(i);

    for x:= 31 downto i do begin
      ptX[cIdx, x + 1]:= ptX[cIdx, x];
      ptY[cIdx, x + 1]:= ptY[cIdx, x];
    end;
    ptX[cIdx, i]:= pt.X;
    ptY[cIdx, i]:= pt.Y;
    apt:= i;
    nPts[cIdx]:= nPts[cIdx] + 1;
  end;
end;

procedure TALToneCurve.ApplyCurve(Img: TBitmap);
var
  SRow: PRGBArray;
  SFill, X, Y: Integer;
begin
Try
  if ImgLoaded then Exit;
  SRow:= PRGBArray(Img.ScanLine[0]);
  SFill := Integer(Img.ScanLine[1]) - Integer(SRow);
  for Y := 0 to Img.Height - 1 do begin
    for X := 0 to Img.Width - 1 do begin
      SRow[X].R:= LUT[0, LUT[1, SRow[X].R]];
      SRow[X].G:= LUT[0, LUT[2, SRow[X].G]];
      SRow[X].B:= LUT[0, LUT[3, SRow[X].B]];
    end;
    Inc(Integer(SRow), SFill);
  end;
except
end;
end;

procedure TALToneCurve.DelPoint(idx: Integer);
var
  x: Integer;
begin
  if nPts[cIdx] = 2 then begin
    ShowMessage('At least two points must exist.');
    Exit;
  end;
  if (idx > 0) and (idx <= nPts[cIdx]) then begin
    for x:= idx to 31 do begin
      ptX[cIdx, x]:= ptX[cIdx, x + 1];
      ptY[cIdx, x]:= ptY[cIdx, x + 1];
    end;
    apt:= -1;
    nPts[cIdx]:= nPts[cIdx] - 1;
    DrawCurve;
  end;
end;

procedure TALToneCurve.DrawCurve;
var
  n, i, j, k, x, y, x1, x2, xpos, ypos: Integer;
  c, c1: TColor;
  f: Single;
  tga: Single;
const lColors : array[0..3] of TColor = (clBlack,clRed,clGreen,clBlue);
begin
if BackBMP<>nil then begin
Try
  if imgView<>nil then
     if Assigned(FRepaint) then FRepaint(Self);
  if FHistogram then
     GetHist;
  SetPandU;
  With BackBMP.Canvas do
  begin
       Brush.Color:= Color;
       FillRect(ClipRect);

  // Paint histogram
  case cIdx of
    0: c:= RGB(192, 192, 192);
    1: c:= RGB(255, 190, 190);
    2: c:= RGB(190, 220, 190);
    3: c:= RGB(190, 190, 255);
    else c:= RGB(190, 190, 255);
  end;

  c1:= Blend(c, clWhite, 30);
  Pen.Color:= c;
  Pen.Width:= 1;
  j:= MulDiv(nHist[cIdx, 0], 230, maxHist[cIdx]);
  MoveTo(8, 255 + 8);
  LineTo(8, (255 + 8) - j);
  k:= (255 + 8) - j;
  for i := 1 to 255 do begin
    j:= (255 + 8) - MulDiv(nHist[cIdx, i], 230, maxHist[cIdx]);
    Pen.Color:= c1;
    MoveTo(i + 8, 255 + 8);
    LineTo(i + 8, j);
    WuLine(8 + (i - 1), k, 8 + i, j, c);
    k:= j;
  end;
  // Histogram done...
  // Paint guidelines
  Pen.Color:= clGray;
  Brush.Style:= bsClear;
  Rectangle(Rect(8, 8, 264, 264));
  Pen.Color:= clSilver;
  Pen.Style:= psDot;
  for i:= 1 to 5 do begin
    j:= 8 + (i * 50);
    MoveTo(8, 272-j); LineTo(264, 272-j);
    MoveTo(j, 8); LineTo(j, 264);
  end;
  Pen.Style:= psSolid;
  Pen.Color:= clSilver;
  MoveTo(8, 263);
  LineTo(263, 8);
  // Guidelines done...

  // Paint points and curve
  Pen.Color:= clBlack;
  Brush.Color:= clBlack;
  Brush.Style:= bsClear;
  for i:= 1 to nPts[cIdx] do
    Rectangle(8 + ptX[cIdx, i] - 3, 263 - ptY[cIdx, i] - 3, 8 + ptX[cIdx, i] + 4, 263 - ptY[cIdx, i] + 4);


  xpos:= 0; ypos:= 0;
  x:= 8 + ptX[cIdx, 1];
  y:= 263 - ptY[cIdx, 1];
  MoveTo(8, y);
  if ptX[cIdx, 1] > 0 then LineTo(x, y);
  for i:= 1 to nPts[cIdx] - 1 do begin
    x1:= ptX[cIdx, i];
    x2:= ptX[cIdx, i + 1];

    Case LineType of
    cuvLinear:
    begin
      LineTo(x2 + 8, 263 - ptY[cIdx, i + 1]);
      tga := (ptY[cIdx, i + 1]-ptY[cIdx, i]) / (x2-x1);
      for j:=x1 to x2 do begin
          ypos := Round(ptY[cIdx, i] + (j-x1)*tga);
          LUT[cIdx, j]:= ypos;
      end;
    end;
    cuvSpline:
    for j:=  x1 to x2 do begin
      xpos:= j;
      ypos:= Trunc(GetCurvePoint(i, xpos));
      if ypos < 0 then ypos:= 0 else if ypos > 255 then ypos:= 255;
      WuLine(x, y, 8 + xpos, 263 - ypos, lColors[cIdx]);
      LUT[cIdx, xpos]:= ypos;
      x:= 8 + xpos;
      y:= 263 - ypos;
    end;
    end;
  end;

  MoveTo(8 + xpos, 263 - ypos);
  if ptX[cIdx, nPts[cIdx]] < 255 then LineTo(263, 263 - ptY[cIdx, nPts[cIdx]]);
  if ptX[cIdx, 1] > 0 then for i:= 0 to ptx[cIdx, 1] - 1 do Lut[cIdx, i]:= ptY[cIdx, 1];
  if ptX[cIdx, nPts[cIdx]] < 255 then for i:= ptx[cIdx, nPts[cIdx]] + 1 to 255 do Lut[cIdx, i]:= ypos;
  // Curve and points done...

  end;

finally
  Canvas.Draw(0,0,BackBMP);
end;
end;
end;

function TALToneCurve.GetCurvePoint(i: Integer; v: Single): Single;
var
  t0, t1: Single;
begin
  t0:= (v - ptX[cIdx, i]) / ptU[cIdx,i];
  t1:= 1 - t0;
  Result:= t0 * ptY[cIdx, i + 1] + t1 * ptY[cIdx, i] + ptU[cIdx, i] *
    ptU[cIdx, i] * ((t0*t0*t0-t0) * ptP[cIdx, i + 1] + (t1*t1*t1-t1) * ptP[cIdx, i]) / 6;
end;

procedure TALToneCurve.GetHist;
var
  SRow: PRGBArray;
  i, x, y, SFill: Integer;
  Src: TBitmap;
  RGB: TRGB_24;
  r, g, b, l: Byte;
begin
Try
  if ImgLoaded then Exit;
  if imgView<>nil then
  if not imgView.Empty then begin
  for y:= 0 to 3 do begin
    maxHist[y]:= 0;
    for x := 0 to 255 do nHist[y, x]:= 0;
  end;
  Src:= imgView;
  SRow:= PRGBArray(Src.ScanLine[0]);
  SFill := Integer(Src.ScanLine[1]) - Integer(SRow);
  for Y := 0 to Src.Height - 1 do begin
    for X := 0 to Src.Width - 1 do begin
      rgb:= SRow[X];
      r:= RGB.R; g:= RGB.G;  b:= RGB.B; l:= (r + g + b) div 3;
      nHist[0, l]:= nHist[0, l] + 1;
      nHist[1, r]:= nHist[1, r] + 1;
      nHist[2, g]:= nHist[2, g] + 1;
      nHist[3, b]:= nHist[3, b] + 1;
    end;
    Inc(Integer(SRow), SFill);
  end;
  for y := 0 to 3 do for x := 0 to 255 do if nHist[y, x] > maxHist[y] then maxHist[y]:= nHist[y, x];
  end;
except
end;
end;

function TALToneCurve.IsPoint(x, y: integer): integer;
var
  i: Integer;
  p: TPoint;
begin
  x:= x - 8;
  y:= y - 8;
  p.X:= x;
  p.Y:= 255 - y;
  if p.X < 0 then p.X:= 0 else if p.X > 255 then p.X:= 255;
  if p.Y < 0 then p.Y:= 0 else if p.Y > 255 then p.Y:= 255;
  apt:= -1;
  i:= 1;
  while (i <= nPts[cIdx]) and (not PtInCircle(ptX[cIdx, i], ptY[cIdx, i], p.X, p.Y, 5)) do inc(i);
  if i <= nPts[cIdx] then apt:= i else apt:=-1;
  Result := apt;
end;

procedure TALToneCurve.SetChannel(const Value: integer);
begin
  if FChannel<>Value then begin
     FChannel := Value;
     cIdx:= Value;
     DrawCurve;
  end;
end;

procedure TALToneCurve.Reset;
var
  j: Integer;
begin
  aPt:= -1;
  // Reset values
  nPts[cIdx]:= 2;
  ptX[cIdx, 1]:= 0;
  ptX[cIdx, 2]:= 255;
  ptY[cIdx, 1]:= 0;
  ptY[cIdx, 2]:= 255;
  for j:= 0 to 255 do LUT[cIdx, j]:= j;
  DrawCurve;
end;

procedure TALToneCurve.Invers;
var
  i: Integer;
begin
  For i:=1 to nPts[cIdx] do ptY[cIdx, i]:= 255-ptY[cIdx, i];
  GetHist;
  DrawCurve;
end;


procedure TALToneCurve.LoadPreset(Idx: Integer);
var
  x, y, i, j, k, m, n, p, q, cnt: Integer;
  FileArr, Simple: Array[0..255] of Byte;
  CurvePts: Array[0..3] of String;
  s: String;
  Stream: TFileStream;
  ACVFile, Curve: String;
begin
  q:= cIdx;
  ACVFile:= PresetPath + Presets.Strings[Idx] + '.acv';
  Stream:= TFileStream.Create(ACVFile, fmOpenRead or fmShareDenyWrite);
  try
    i:= Stream.Size;
    Stream.Read(FLineType,1);
    Stream.ReadBuffer(FileArr, i-1);
  finally
    Stream.Free;
  end;
  i:= i div 2;
  n:= 1;
  for j:= 0 to i - 1 do begin
    Simple[j]:= FileArr[n];
    n:= n + 2;
  end;
  if (Simple[0] <> 4) then begin
    ShowMessage('This file version is not supported. Sorry!');
    Exit;
  end;
  // Clear old values
  for i := 0 to 3 do begin
    for n := 1 to 32 do begin
      ptP[i, n]:= 0;
      ptU[i, n]:= 0;
    end;
  end;
  k:= 2;
  for m := 0 to 3 do begin
    cnt:= Simple[k];
    i:= Simple[k] * 2;
    nPts[m]:= cnt;
    n:= k + 1;
    for j:= 1 to cnt do begin
      ptX[m, j]:= Simple[n + 1];
      ptY[m, j]:= Simple[n];
      n:= n + 2;
    end;
    cIdx:= m;
    SetPandU;
    y:= 255;
    for p:= 1 to cnt - 1 do begin
      for x:=  ptX[m, p] to ptX[m, p + 1] do begin
        y:= Trunc(GetCurvePoint(p, x));
        if y < 0 then y:= 0 else if y > 255 then y:= 255;
        LUT[m, x]:= y;
      end;
    end;
    if ptX[m, 1] > 0 then for p:= 0 to ptx[m,  1] - 1 do Lut[m, p]:= ptY[m, 1];
    if ptX[m, nPts[m]] < 255 then for p:= ptx[m, nPts[m]] + 1 to 255 do LUT[m, p]:= 255;
    k:= k + i + 1;
  end;
  cIdx:= q;
  DrawCurve;
  FPresetName := Presets.Strings[Idx];
end;

procedure TALToneCurve.LoadPreset(PresetFile: string);
var
  x, y, i, j, k, m, n, p, q, cnt: Integer;
  FileArr, Simple: Array[0..255] of Byte;
  CurvePts: Array[0..3] of String;
  s: String;
  Stream: TFileStream;
  ACVFile, Curve: String;
begin
  q:= cIdx;
  ACVFile:= PresetFile;
  if ExtractFileExt(ACVFile)='' then
     ACVFile := ACVFile + '.acv';
  if ExtractFilePath(ACVFile)='' then
     ACVFile := PresetPath + ACVFile;
  Stream:= TFileStream.Create(ACVFile, fmOpenRead or fmShareDenyWrite);
  try
    i:= Stream.Size;
    Stream.Read(FLineType,1);
    Stream.ReadBuffer(FileArr, i-1);
  finally
    Stream.Free;
  end;
  i:= i div 2;
  n:= 1;
  for j:= 0 to i - 1 do begin
    Simple[j]:= FileArr[n];
    n:= n + 2;
  end;
  if (Simple[0] <> 4) then begin
    ShowMessage('This file version is not supported. Sorry!');
    Exit;
  end;
  // Clear old values
  for i := 0 to 3 do begin
    for n := 1 to 32 do begin
      ptP[i, n]:= 0;
      ptU[i, n]:= 0;
    end;
  end;
  k:= 2;
  for m := 0 to 3 do begin
    cnt:= Simple[k];
    i:= Simple[k] * 2;
    nPts[m]:= cnt;
    n:= k + 1;
    for j:= 1 to cnt do begin
      ptX[m, j]:= Simple[n + 1];
      ptY[m, j]:= Simple[n];
      n:= n + 2;
    end;
    cIdx:= m;
    SetPandU;
    y:= 255;
    for p:= 1 to cnt - 1 do begin
      for x:=  ptX[m, p] to ptX[m, p + 1] do begin
        y:= Trunc(GetCurvePoint(p, x));
        if y < 0 then y:= 0 else if y > 255 then y:= 255;
        LUT[m, x]:= y;
      end;
    end;
    if ptX[m, 1] > 0 then for p:= 0 to ptx[m,  1] - 1 do Lut[m, p]:= ptY[m, 1];
    if ptX[m, nPts[m]] < 255 then for p:= ptx[m, nPts[m]] + 1 to 255 do LUT[m, p]:= 255;
    k:= k + i + 1;
  end;
  cIdx:= q;
  DrawCurve;
  FPresetName := ExtractFileName(ACVFile);
  if Pos('.',FPresetName)>0 then
     FPresetName := Copy(FPresetName,1,Pos('.',FPresetName)-1);
end;

procedure TALToneCurve.SavePreset(fName: string);
var
  i, j, k: Integer;
  txt: String;
  acv: Array[0..255] of Byte;
  Stream: TFileStream;
  ACVFile: String;
  typ: byte;
begin
  for i := 0 to 255 do acv[i]:= 0;
  if fName <> '' then begin
    j:= 1;
    acv[j]:= 4; inc(j, 2);
    acv[j]:= 5; inc(j, 2);
    for i := 0 to 3 do begin
      acv[j]:= nPts[i]; inc(j, 2);
      for k:= 1 to nPts[i] do begin
        acv[j]:= ptY[i, k]; inc(j, 2);
        acv[j]:= ptX[i, k]; inc(j, 2);
      end;
    end;
    acv[j]:= 2; inc(j, 2);
    acv[j]:= 0; inc(j, 2);
    acv[j]:= 0; inc(j, 2);
    acv[j]:= 255; inc(j, 2);
    acv[j]:= 255; inc(j, 2);
    ACVFile:= PresetPath + fName + '.acv';
    Stream:= TFileStream.Create(ACVFile, fmCreate or fmOpenWrite or fmShareDenyWrite);
    try
      typ := Ord(FLineType);
      Stream.Write(typ,1);
      Stream.WriteBuffer(acv, j - 1);
    finally
      Stream.Free;
      GetCurvesPreset(Presets);
    end;
  end;
end;


procedure TALToneCurve.GetCurvesPreset(Files: TStrings);
var
  SR: TSearchRec;
  i : integer;
begin
  if not DirectoryExists(PresetPath) then CreateDir(PresetPath) else begin
    Files.Clear;
      if FindFirst(PresetPath + '*.acv', faArchive, SR) = 0 then
          begin
            repeat
                Files.Add(SR.Name);
            until FindNext(SR) <> 0;
            FindClose(SR);
          end;
          if Files.Count > 0 then begin
//            Files.CustomSort(Self.SortMe);
            for i := 0 to Files.Count - 1 do Files.Strings[i]:=ChangeFileExt(Files[i], '');
          end;
  end;
end;

procedure TALToneCurve.SetPresetPath(const Value: String);
begin
  FPresetPath := Value;
  GetCurvesPreset(Presets);
end;

procedure TALToneCurve.SetPandU;
var
  i: Integer;
  d, w: array[1..32] of Single;
begin
  for i:= 2 to nPts[cIdx] - 1 do d[i]:= 2 * (ptX[cIdx, i + 1] - ptX[cIdx, i - 1]);
  for i:= 1 to nPts[cIdx] - 1 do ptU[cIdx, i]:= ptX[cIdx, i + 1] - ptX[cIdx, i];
  for i:= 2 to nPts[cIdx] - 1 do w[i]:= 6 * ((ptY[cIdx, i + 1] - ptY[cIdx, i]) /
    ptU[cIdx, i] - (ptY[cIdx, i] - ptY[cIdx, i - 1]) / ptU[cIdx, i - 1]);
  for i:= 2 to nPts[cIdx] - 2 do begin
    w[i + 1]:= w[i + 1] - w[i] * ptU[cIdx, i] / d[i];
    d[i + 1]:= d[i + 1] - ptU[cIdx, i] * ptU[cIdx, i] / d[i];
  end;
  ptP[cIdx, 1]:= 0;
  for i:= nPts[cIdx] - 1 downto 2 do ptP[cIdx, i]:= (w[i] - ptU[cIdx, i] * ptP[cIdx, i + 1]) / d[i];
  ptP[cIdx, nPts[cIdx]]:= 0;
end;

procedure TALToneCurve.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  i: Integer;
  p: TPoint;
begin
  x:= x - 8;
  y:= y - 8;
  p.X:= x;
  p.Y:= 255 - y;
  if p.X < 0 then p.X:= 0 else if p.X > 255 then p.X:= 255;
  if p.Y < 0 then p.Y:= 0 else if p.Y > 255 then p.Y:= 255;
  apt:= -1;
  i:= 1;
  while (i <= nPts[cIdx]) and (not PtInCircle(ptX[cIdx, i], ptY[cIdx, i], p.X, p.Y, 5)) do inc(i);
  if i <= nPts[cIdx] then apt:= i;
  if (ssLeft in Shift) then begin
    if (apt <> -1) then begin
      if (apt > 0) and (apt < nPts[cIdx]) then begin
        if (p.X > ptX[cIdx, apt - 1]) and (p.X < ptX[cIdx, apt + 1]) then ptX[cIdx, apt]:= p.X;
        ptY[cIdx, apt]:= p.Y;
      end;
    end else if nPts[cIdx] < 31 then AddPoint(p);
  end else if (ssRight in Shift) then DelPoint(apt);
  oldHistogram := FHistogram;
  FHistogram   := False;
  DrawCurve;
end;

procedure TALToneCurve.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  p: TPoint;
begin
  if not (ssLeft in Shift) then begin
     apt := IsPoint(x,y);
  if apt <> -1 then
      Cursor := crHandPoint
  else
      Cursor := crDefault;
      Exit;
  end;
  x:= x - 8;
  y:= y - 8;
  p.X:= x;
  p.Y:= 255 - y;
  if p.X < 0 then p.X:= 0 else if p.X > 255 then p.X:= 255;
  if p.Y < 0 then p.Y:= 0 else if p.Y > 255 then p.Y:= 255;
  if apt = -1 then begin
    i:= 1;
    while (i <= nPts[cIdx]) and (not PtInCircle(ptX[cIdx, i], ptY[cIdx, i], p.X, p.Y, 5)) do inc(i);
    if i <= nPts[cIdx] then apt:= i;
  end;
  if (ssLeft in Shift) and (apt <> -1) then begin
    if (apt > 1) and (apt < nPts[cIdx]) then begin
      if (p.X > ptX[cIdx, apt - 1]) and (p.X < ptX[cIdx, apt + 1]) then ptX[cIdx, apt]:= p.X;
    end else begin
      if (apt = 1) and (p.X < ptX[cIdx, apt + 1]) then ptX[cIdx, apt]:= p.X;
      if (apt = nPts[cIdx]) and (p.X > ptX[cIdx, apt - 1]) then ptX[cIdx, apt]:= p.X;
    end;
    ptY[cIdx, apt]:= p.Y;
  end;
  FHistogram   := False;
  DrawCurve;
end;

procedure TALToneCurve.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  apt:= -1;
  FHistogram   := oldHistogram;
  DrawCurve;
  if imgView<>nil then
     if Assigned(FRepaint) then FRepaint(Self);
end;

procedure TALToneCurve.SetFileName(const Value: String);
begin
  // New image file loading in the imgView
  FFileName := Value;
  if FimgView<>nil then begin
  end;
end;

procedure TALToneCurve.setLineType(const Value: TToneCurveType);
begin
  FLineType := Value;
  DrawCurve;
  if imgView<>nil then
     if Assigned(FRepaint) then FRepaint(Self);
end;

procedure TALToneCurve.SetColor(const Value: TColor);
begin
  FColor := Value;
  invalidate;
end;

procedure TALToneCurve.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := -1
end;

procedure TALToneCurve.WMSize(var Msg: TWMSize);
begin
  Msg.width := 272;
  Msg.height := 272;
end;

procedure TALToneCurve.Paint;
begin
  DrawCurve;
  inherited;
end;
(*
procedure Register;
begin
  RegisterComponents('AL',[TALToneCurve]);
end;
*)
procedure TALToneCurve.SetHistogram(const Value: boolean);
begin
  FHistogram := Value;
  DrawCurve;
end;

function TALToneCurve.AddPreset: string;
var
  i, j, k: Integer;
  txt: String;
  acv: Array[0..255] of Byte;
  Stream: TFileStream;
  ACVFile: String;
begin
  Result := '';
  if InputQuery('Give the curve a name', 'Please type a name ', FPresetName)
  then
  begin
     Result := FPresetName;
     SavePreset(FPresetName);
  end;
end;

// Stella modify

// Kigyüjti a pont koordinátákat R,G,B, csatornánként
// Chanel,db,x,y,....
// PL. 'I,3,0,10,55,66,255,255,R,2,0,0,255,255,G,2,0,0,255,255,B,2,0,0,255,255'
function TALToneCurve.GetPresetString: string;
var
  I: Integer;
  j: Integer;
const Ch : AnsiString = 'IRGB';
begin
  Result := '';
  for I := 0 to 3 do begin
      Result := Result + ch[i+1] + ',' + inttostr(nPts[i]);
      for j := 1 to nPts[i] do begin
          Result := Result + ',' + inttostr(ptX[i,j]) + ',' + inttostr(ptY[i,j]);
      end;
      if i<3 then Result := Result + ',';
  end;
end;

// A GetPresetString-el kigyüjtött szöveg alapján
// elõállítja a görbéket I,R,G,B
procedure TALToneCurve.SetPresetString(PS: string);
var n,i,j,k,m: integer;
    s: AnsiString;
    x, y, p : integer;
const Ch : AnsiString = 'IRGB';
begin
  // Clear old values
  for i := 0 to 3 do begin
    nPts[i] := 0;
    for n := 1 to 32 do begin
      ptP[i, n]:= 0;
      ptU[i, n]:= 0;
    end;
  end;

  n := StrCount(PS,',');
  k := 1;
  i := 0;
  s := StrCountD(PS,',',k);
  repeat
      if Pos(s[1],Ch)>0 then begin
         if s='I' then i:=0;
         if s='R' then i:=1;
         if s='G' then i:=2;
         if s='B' then i:=3;
         Inc(k);
         s := StrCountD(PS,',',k);
         nPts[i] := StrToInt(s);
         j := 1;
      end
      else
      begin
         ptX[i,j] := StrToInt(s);
         Inc(k);
         s := StrCountD(PS,',',k);
         ptY[i,j] := StrToInt(s);
         Inc(j);
      end;
      Inc(k);
      s := StrCountD(PS,',',k);
  until s='';

  for m := 0 to 3 do begin
    cIdx:= m;
    SetPandU;
    y:= 255;
    for p:= 1 to nPts[m] - 1 do
      for x:=  ptX[m, p] to ptX[m, p + 1] do begin
        y:= Trunc(GetCurvePoint(p, x));
        if y < 0 then y:= 0 else if y > 255 then y:= 255;
        LUT[m, x]:= y;
      end;
    if ptX[m, 1] > 0 then
       for p:= 0 to ptx[m,  1] - 1 do Lut[m, p]:= ptY[m, 1];
    if ptX[m, nPts[m]] < 255 then
       for p:= ptx[m, nPts[m]] + 1 to 255 do LUT[m, p]:= 255;
  end;
end;

end.
