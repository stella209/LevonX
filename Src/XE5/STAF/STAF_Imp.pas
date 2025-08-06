
(*
  STAF - BASIC IMEGE PROCESSES UNIT  Ver 1.0.0.1
  ---------------------------------
  By Agócs László 2008
*)

(*
  STAF - StarFactory Image Process Library for Astrophotographers
  -----------------------------------------------------------------
  by Agócs László Hungarian Amateur Astronomer in StellaObservatory
     Email: lagocsstella@gmail.com
     Website: http://stella_209.extra.hu/

  Licence: GPU licence;  'Do anything you wish!'

  This unit contains:
  - BASIC IMAGE PROCESSES: Brightness, Darken, Threshold, Contrast, .....
  - ADVENCE IMAGE PROCESSES:
  - IMAGE EFFECTS:
  - PUBLISHING IMAGES: Bordered image, labels, lists, hotmap, ....
  - ASTROPHOTOGRAPHY RUTINF FOR PROCESSES AND ANALYSIS
    - ASTROMETRY
    - PHOTOMETRY
*)

unit STAF_Imp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ShellApi, ClipBrd, CommCtrl, ExtCtrls, Math, Jpeg, NewGeom, Szamok, Szoveg,
  MMXE, FastDIB;


Const PixelMax = 20000;

Type
   PByteArr = ^TByteArray;
   TByteArr = array[0..64535] of Byte;
   pPixelArray = ^TPixelArray;
   TPixelArray = Array[0..PixelMax-1] Of TRGBTriple;
   PRGBTripleArray = ^TRGBTripleArray;
   TRGBTripleArray = array[0..PixelMax] of TRGBTriple;
   T3x3FloatArray = array[0..2] of array[0..2] of Extended;

  TRGBRec = packed record
    case Integer of
      1: (RGBVal: LongInt);
      0: (Red, Green, Blue, None: Byte);
  end;

   PRGB24 = ^TRGB24;
   TRGB24 = record B, G, R: Byte; end;
   PRGBArray = ^TRGBArray;
   TRGBArray = Array[0..0] Of TRGB24;
//   TRGBArray = array [Word] of TRGB24;

   TRGBColorsArray  = Array[0..2,0..255] of Cardinal; // RGB szinek tömbje for histogram

   TRGBStatisticArray = Array[0..2,0..255] of double; // RGB szinek tömbje for statistic (%)

   TStarPixelsArray = Array of TPoint;

   TBMPAction = (bacNone, bacFlipVertical, bacFlipHorizontal,
                 bacGrayscale, bacNegative, bacFlaxen, bacEmboss
                 );

  // Indicates which chanel is active in image
  TRGBList = (rgbRGB,rgbR,rgbG,rgbB);
  TRGBSet = set of TRGBList;

  pThreshold   = ^TThreshold;
  TThreshold   = TRGB24;      // Record for average of threshold or measuring

   // Színcsatornák korrekciója: alapesetben minden érték = 1
   //                            <1 csökkenti; >1 növeli a színcsatorna értékét
   TRGBParam = record
      RParam : double;
      GParam : double;
      BParam : double;
   end;

  THistoParams = record
    Brightness : integer;
    Contrast   : integer;
    Saturation : integer;
    Gamma      : double;
    R,G,B      : double;
    Mono       : boolean;
    Negative   : boolean;
  end;

  TNoiseReductRecord = record
     Factor          : double;
     BackLevel       : byte;
     RGBParam        : TRGBParam;
  end;

  pStarRecord = ^TStarRecord;
  TStarRecord = packed record         // Record for star detection
     ID       : integer;
     PixCount : integer;
     x,y      : double;
     Radius   : double;
     R,G,B    : word;
     HalfRad  : double;        // Wide of half intensity
     Intensity: double;        // Average intenzity in the HalfRad
//     logIntensity: double;
     RA,DE    : double;        // Ra and De float (0<=Ra<24, -90<=De<=90)
     mg       : double;        // magnitude
     c        : double;        // color index
     Dist     : double;
     Selected : boolean;
     Deleted  : boolean;
     Filtered : boolean;
     Refstar  : boolean;       // if True then knowen star (coord. or mg.)
  end;


  TStarIndexList  = array of integer;              // Index list for stars' IDs
  TStarArray      = Array of TStarRecord;          // List for stars

  CSILLAG = Record
    StarCount : integer;                           // Stars count
    StarArray : Array of TStarRecord;              // Array of Star's datas
  end;

  TDrawingTool = (dtNone, dtPoint, dtLine, dtInfo, dtRectangle,
       dtRoundRect, dtEllipse, dtFillRect, dtFillRoundRect,
       dtFillEllipse, dtPolyLine, dtPolygon, dtIv, dtText,
       dtExtraText, dtBrush);


  ProcessCommand = (
                 pcRGBChanel,       // Select RGB chanel: par=1 : R,G,B,RGB
                 pcMono,            // Monochrome image;  par=0;
                 pcInvers,          // Invers image;      par=0;
                 pcTurnLeft,        // Turn left 90 deg.  par=0;
                 pcTurnRight,       // Turn right 90 deg. par=0;
                 pcRotate,          // Rotate             par=1 : Deg
                 pcBright,          // Brightness         par=1 : Amount
                 pcContrast,        // Brightness         par=1 : Amount
                 pcLevel,           // Brightness         par=1 : LevelStep
                 pcBlur,            // Blur               par=1 : Amount
                 pcSaturate,        // Saturate           par=1 : Amount
                 pcHighPass,        // HighPass           par=1 : Amount(0..255)
                 pcLowPass,         // LowPass            par=1 : Amount(0..255)
                 pcHighPassEx,      // HighPass           par=1 : Amount(0..255)
                 pcLowPassEx,       // LowPass            par=1 : Amount(0..255)
                 pcThresElim,       // Threshold elimin.  par=1 : ThresHoldLevel
                 pcCreateMasterDark,// Create a master dark     par=1 : DarkList
                 pcCreateMasterFlat,// Create a median flat     par=1 : FlatList
                 pcCreateMasterLight,// Create a median light   par=1 : FlatList
                 pcHotPixelCorrect,
                 pcReScale,
                 pcMosaic,
                 pcLoad,
                 pcSave,
                 pcCopyToClipboard,
                 pcStarDetect,
                 pcPrecisionStarDeave
                 );

  TProcessAction = record
     ProcessText : String[50];   // Process by text: e.x. 'Contrast 100'
     ProcessIdx  : integer;
     Params      : Array of Variant;
  end;

  TProcessActionList = TStringList;

  TBMPFileHeaderStruct = record
    BM           : word;           // 00h 'BM' Characters
    BMPSize      : integer;        // 02h Size of the BMP file
    AppSpec1     : word;           // 06h Application Specific - none used
    AppSpec2     : word;           // 08h Application Specific - none used
    DataOffset   : word;           // 0Ah The offset where the bitmap data (pixels) can be found.
    NumberOfByte : integer;        // 0Eh The number of bytes in the header (from this point).
    BMPWidth     : integer;        // 12h The width of the bitmap in pixels
    BMPHeight    : integer;        // 16h The height of the bitmap in pixels
    Planes       : word;           // 1Ah Number of color planes being used.
    BitPerPixel  : word;           // 1Ch bits/pixel.
    Compression  : integer;        // 1Eh BI_RGB, No compression used = 0;
    RAWBMP       : integer;        // 22h The size of the raw BMP data (after this header)
    HResolution  : integer;        // 26h The horizontal resolution of the image
    VResolution  : integer;        // 2Ah The horizontal resolution of the image
    ColorNumber  : integer;        // 2Eh Number of colors in the palette
    iColor       : integer;        // 32h Means all colors are important
  end;


  TRefStarRecord = packed record
    Id          : integer;         // Index of the reference star in the starlist
    x,y         : double;          // Coordinates of the star
    distance    : double;          // Distance from 0. ref. star
    angle       : double;          // Angle from 0. ref. star
    Radius      : double;          // Brightness of ref. star
  end;

  TRefStarArray = array of TRefStarRecord;


type
  TPlaneType = (ptOrthogonal, ptStretched);

  TPlane = record
    PlaneType: TPlaneType;
    Origin,
    X_Axis,
    Y_Axis: TPoint;
  end;

  TStretchHeader = record
    SourcePlane,
    TargetPlane: TPlane;
  end;

  TRotateRec = record
    x1, y1, x2, y2, w, h,           // Forrás téglalap két szemközti a,c csúcsa
    x1s, y1s, x2s, y2s, x3s, y3s,   // cél paralelogramma 3 csúcsa: a,b,d
    ww, hh, maxw, maxh,
    ptr1, ptr2,
    ptrscanline1, ptrscanline2: integer;
  end;

  TArray = record
    x, y, cor: integer;
  end;

  TStretchBitmap = class
  private
    R: TRotateRec;
    FBackgroundColor: TColor;
    procedure MakeArray(X1S, X2S, Y1S, Y2S, W: integer; WW_ptr, ptr: Pointer);
    procedure SetBackgroundColor(const Value: TColor);
  public
    SourceBitmap,      //the bitmap that is about to be transformed
    TargetBitmap: TBitmap;    //the bitmap to save the transformed image
    ResizeTargetBitmap: Boolean;  //set if you want to resize the target bitmap

    StretchHeader: TStretchHeader;  //transformation vectors
    ErrorX, ErrorY: integer;    //shows point where an error occurred
    constructor Create;
    destructor Destroy;

    function StretchBitm(Bitmap, Target: TBitmap; R: TRotateRec): Boolean;
    procedure StretchArea(R: TRotateRec; ErrX, ErrY: integer);
    function CheckPlane(pl: TPlane): Boolean;
    procedure AdjustTargetPlaneToBitmap;

    { Transfor the source rect to a dest paralelogram }
    procedure TransBMP
            ( src,dst  : TBitmap;      // Source, Destination bitmap,
              srcRect  : TRect;        // Source rectangle in src bitmap
              Cent     : TPoint2d;     // Centrum of the destination
              Zoom     : double;       // Zoom
              RotAngle : double);      // Rotate angle

    function StretchIt: Boolean;  //stretch the bitmap according to StretchHeader
    function RotateIt(RotationAngle: Single): Boolean; overload; //rotate bitmsp
    function RotateIt(RotationAngle,Magnify: double): Boolean; overload;
    function SkewIt(Horizontally, Vertically: Single): Boolean;  //skew bitmap
    property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor;
  end;


Var
    // BMP's are created and destroyed by this unit: you need not to do!
    OrigBMP : TBitmap; // Original bitmap
    bmp     : TBitmap; // bitmap for else
    wbmp    : TBitmap; // work bitmap copied from Origbmp

    AvgThreshold    : TThreshold;    // for average of threshold
    ThresholdFactor : double = 1;    // Subjective factor for threshold

    StarCount : integer;                           // Stars count
    StarArray : Array[0..80000] of TStarRecord;    // Array of Star's datas
    stRec     : TStarRecord;                       // Star record for any usage

    ActivePhotometry : boolean;              // Photometry in active mode

    ProcessList : TStringList;               // For programming processes


// NEEDED ROUTINS

  procedure SortArray(var A : array of integer);
  function MedianAverage(var A : array of integer) : integer;
//  function InRange(Test,Min,Max: integer): Boolean; overload;
//  function InRange(Test,Min,Max: double): Boolean; overload;
  function Range(Test,Min,Max: Integer): Integer;
  function BoolToStr(bVal: boolean): string;
  function IntToByte(i:Integer):Byte;
  function FloatToByte(i:double):Byte;
  function Set255(Clr : integer) : integer;
  procedure quicksort(var a: array of integer);
  function GetCoordStr(x,y: integer): string; overload;
  function GetCoordStr(x,y: double): string; overload;
  function PointToCoord(p: TPoint): string;
  function GetRGBStr(co: TColor): string;

  function RectMagnify(R: TRect; n: double):TRect;
  function RectInflate(R: TRect; dx,dy: integer):TRect;

  function BMPCopy( SourceBitmap : TBitmap; DestBitmap : TBitmap ):boolean;
  procedure CopyMe(tobmp: TBitmap; frbmp : TGraphic);
  function BMPResize( Bitmap:TBitmap ; const x,y: integer ):boolean; overload;
  function BMPResize( Bitmap:TBitmap ; const x,y: integer; color: TColor ):boolean; overload;
  procedure SmoothResize(abmp:TBitmap; NuWidth,NuHeight:integer);
  procedure SmoothResize2(abmp: TBitmap; NuWidth, NuHeight: integer);
  function ScalePercentBmp(bitmp: TBitmap; iPercent: Integer): Boolean;
  function Load_Bitmap(FName: string; BM: TBitmap): boolean;
  function Save_Bitmap(FName: string; BM: TBitmap): boolean;
  function Delete_file(FName: string): boolean;
  procedure LoadWICImage(fn: string; bmp: TBitmap);

// DIR and File rutines

  procedure GetSubDirs(const sRootDir: string; slt: TStrings);
  procedure GetJPGSize(const sFile: string; var wWidth, wHeight: word);
  procedure GetPNGSize(const sFile: string; var wWidth, wHeight: Word);
  procedure GetGIFSize(const sGIFFile: string; var wWidth, wHeight: Word);
  function WinExecAndWait32(FileName: string; Visibility: Integer): Longword;
  procedure ShellExecute_AndWait(FileName: string; Params: string; ShowType: integer);

// CLIPBOARD rutins

  procedure CopyStreamFromClipboard(fmt: Cardinal; S: TStream);
  procedure CopyStreamToClipboard(fmt: Cardinal; S: TStream);

// RGB Colors

  function ColorToTriple(Color:TColor):TRGBTriple;
  function TripleToColor( RGB: TRGBTriple):TColor;
  function ChangeRGBColor(var color:TRGBTriple;R,G,B:integer):TRGBTriple;
  procedure ChangeRGB(var Bitmap:TBitmap;R,G,B: double);

// BASIC IMAGE PROCESSES

  procedure DoBMPAction( var Bitmap:TBitmap; BMPAction: TBMPAction;
                       Par1, Par2, Par3: Variant);
//  procedure DoBMPAction( var Bitmap:TBitmap; BMPAction: TBMPAction);
  procedure DrawShape(Canv: TCanvas; DrawingTool:TDrawingTool; T,B: TPoint;
           AMode: TPenMode);

  // Transformations
  procedure TurnLeft(src,dst:tbitmap); overload;
  procedure TurnLeft(src:tbitmap); overload;
  procedure TurnRight(src,dst:Tbitmap);

    procedure AntiAlias(clip:tbitmap);
    procedure AntiAliasRect(clip:tbitmap;XOrigin, YOrigin, XFinal, YFinal: Integer);

  procedure ChangeAll(var Bitmap: TBitmap; HIP: THistoParams);
  procedure Lightness( Bitmap:TBitmap; Amount: Integer);
  procedure Brightness( Bitmap:TBitmap; Amount: integer);
  procedure Darkness( Bitmap:TBitmap; Amount: integer);
  procedure Contrast(var Bitmap:TBitmap; Amount: Integer);
  procedure ContrastNess(var clip: tbitmap; Amount: Integer);
  procedure Gamma(var Bitmap:TBitmap; Amount: double);
  procedure KeepBlue(src:Tbitmap;factor:extended);
  procedure KeepGreen(src:Tbitmap;factor:extended);
  procedure KeepRed(src:Tbitmap;factor:extended);
  procedure Saturation(var  Bitmap: TBitmap; Amount: Integer);
  Procedure ColorAdjust(var Bitmap:TBitmap; AmountR, AmountG, AmountB: double);
  Procedure ColorAdjustEx(var Bitmap:TBitmap; Threshold: byte);
  Procedure ColorNoiseElimination(var Bitmap:TBitmap);

  procedure Threshold( Bitmap:TBitmap ; const Light:TRgbTriple;
            const Dark:TRgbTriple; Amount:Integer = 128);

            // The fast rotation
  function CreateRotatedBitmap(Bitmap: TBitmap; const Angle: Extended; bgColor: TColor): TBitmap;
            // The slow rotation
  Procedure RotateBitmap( SourceBitmap : TBitmap; out DestBitmap : TBitmap;
            Center : TPoint; Angle : Double) ;

  procedure Negative(var Bitmap:TBitmap);
  Procedure GrayScale(var Bitmap:TBitmap);
  procedure BlackAndWhite(var Bitmap:TBitmap);

  procedure Crop(var Bitmap:TBitmap; Rec: TRect);
  procedure FlipHorizontal(var Bitmap:TBitmap);
  procedure FlipVertical(var Bitmap:TBitmap);

  procedure Flaxen( Bitmap:TBitmap);
  procedure Emboss(Bitmap : TBitmap; AMount : Integer);
  Procedure Blur( var Bitmap :TBitmap);
  procedure SplitBlur(var clip:tbitmap;Amount:integer);
  procedure GaussianBlur(var clip:tbitmap;Amount: integer);
  procedure Posterize(Bitmap: TBitmap; amount: integer);
  procedure Sepia ( Bitmap:TBitmap;depth:byte);

  procedure MonoNoise(var Bitmap: TBitmap; Amount: Integer);
  procedure ColorNoise( Bitmap: TBitmap; Amount: Integer);
  procedure Mosaic(var Bm: TBitmap; size: Integer);
  Procedure Opaque(sBMP1,sBMP2 :TBitmap; destBMP :TBitmap; Percent: integer);

  procedure FadeOut(const Bmp: TImage; Pause: Integer);
  procedure ChangeRGBChanel(Bitmap : TBitmap; RCh,GCh,BCh: boolean); overload;
  procedure ChangeRGBChanel(Bitmap : TBitmap; Mono,RCh,GCh,BCh: boolean); overload;
  procedure ChangeRGBChanelToMonochrome(Bitmap : TBitmap; RCh,GCh,BCh: boolean);
  procedure StepRGB(Bitmap: TBitmap; Step: byte);
  procedure StepRGBContur(Bitmap: TBitmap; Step: byte;
                                ConturColor: TColor);

  procedure DrawCentralCross(Ca: TCanvas; cPen: Tpen);

  function ShowBaloonHint(Point: TPoint; Handle: THandle; Title: String;
           Msg: String; Icon: Integer): Boolean;

    function AbovePass(var vol: byte; amount: byte):byte;
    function BelowPass(var vol: byte; amount: byte):byte;
    function EqualPass(var vol: byte; amount: byte):byte;

  procedure HighPass(Bitmap: TBitmap; R,G,B: byte);
  procedure LowPass(Bitmap: TBitmap; R,G,B: byte);
  procedure HighPassEx(Bitmap: TBitmap; amount:integer);
  procedure LowPassEx(Bitmap: TBitmap; amount:integer);
  procedure SlicePass(Bitmap: TBitmap; Low,High:integer);

  procedure EdgeDetect(Bitmap: TBitmap);
  PROCEDURE Convolve(ABitmap : TBitmap ; AMask : T3x3FloatArray ; ABias : integer);
  procedure ConvolveM(ray : array of integer; z : word; aBmp : TBitmap);
  procedure ConvolveE(ray : array of integer; z : word; aBmp : TBitmap);
  procedure ConvolveI(ray : array of integer; z : word; aBmp : TBitmap);
  procedure ConvolveFilter(filternr,edgenr:integer;src:TBitmap);
  procedure Median(src:TBitmap);
  procedure Median1(src:TBitmap);
  procedure MedianRGB24(BMP: TBitmap);  // Super! Fast! 25X!
  procedure applyMedian3x3(b:TBitmap);
  procedure UnsharpMasking(bmOrig: TBitmap; NBlur, NSpin: integer); overload;
  procedure UnsharpMasking(bmOrig,bmBlured: TBitmap; N: integer); overload;

  procedure GrayAWB(bmp: TBitmap);

    (*  BAD PIXEL CORRECTIONS *)

function FixStuckPixels(Bitmap: TBitmap; Threshold: byte; difference: byte): integer;
function GetStuckPixelsStatistic(Bitmap: TBitmap; VAR stpa: array of TPoint;
                                 Threshold: byte; difference: byte): integer;

    (*  FRAMES CORRECTIONS *)

function SubtractDark(SrcBitmap, DarkBitmap: TBitmap): boolean;
function FlatCorrection(SrcBitmap, FlatBitmap: TBitmap): boolean;
function AddFrames(SrcBitmap1, SrcBitmap2: TBitmap; var DstkBitmap: TBitmap): boolean;
function AddFramesLimited(SrcBitmap1, SrcBitmap2: TBitmap; var DstkBitmap: TBitmap;
                          Limit: integer ): boolean;
function AlignFrames(SrcBitmap1, SrcBitmap2: TBitmap):TPoint;


    (*  ASTROPHOTOGRAPHY RUTINS *)

// Basic preparations on image
procedure AutoNoiseReduction(Bitmap: TBitmap; factor: DOUBLE); overload;
procedure AutoNoiseReduction_1(Bitmap: TBitmap; factor: DOUBLE);
procedure AutoNoiseReduction(Bitmap: TBitmap; Method: integer; factor: DOUBLE;
                             BackLevel: byte; RGBParam: TRGBParam); overload;
procedure AutomaticThresholdElimination(Bitmap: TBitmap; factor: double);
function GetBMPSum(Bitmap: TBitmap):Longint;
function GetBMPAverage(Bitmap: TBitmap; HighLimit: byte): TThreshold;
function GetBMPMin(Bitmap: TBitmap): TThreshold;
function GetBMPMax(Bitmap: TBitmap): TThreshold;
function GetBMPMinMax(Bitmap: TBitmap; var minV, maxV : TRGBTriple): boolean;
function  GetAverageThreshold(Bitmap: TBitmap): TThreshold;
procedure ThresholdElimination(Bitmap: TBitmap; avgTres: TThreshold; factor: double);
procedure To2Bit(Bitmap: TBitmap; Threshold: byte);
procedure RGBMultiplication(Bitmap: TBitmap; Rm,Gm,Bm: double);
// The Red chanel reduction to Green chanel's level
procedure RedToGreen(Bitmap: TBitmap);
// StarDetect methods
Function  AutomaticStarDetection(Bitmap: TBitmap): integer;
Function PrecisionStarDetection(Bitmap: TBitmap; ThresholdFactor: double;
                                 HighPassLevel: byte): integer;
function GetStarCentroid(Bitmap: TBitmap; x, y, Radius: double): TPoint2d;
procedure StarCirclesDraw(Bitmap: TBitmap; col: TColor);
function StarSearch(var idx: integer; x,y: double): boolean;
procedure SubPixelShift(SourceBitmap : TBitmap; out DestBitmap : TBitmap;
                                  OffsetX, OffsetY: double);

// Photometrical methods

function SingleStarPhotometry(Bitmap:TBitmap;      // Source bitmap
                              x,y: integer;        // Coord's in bitmap
                              R: integer;          // Radius
                              Threshold: integer)  // Threshold level
                              : TStarRecord;       // Record of star
function SimplePhotometry(Bitmap: TBitmap; x,y: Double; var Star : TStarRecord): boolean;
function GetAverageIntensityOfStar(Bitmap: TBitmap; x,y, Radius: Double): double;
function SimplePhotometryG(Bitmap: TBitmap; x,y: Double; var Star : TStarRecord): boolean;
function GetAverageIntensityOfStarG(Bitmap: TBitmap; x,y, Radius: Double): double;
procedure TotalPhotometry(Bitmap: TBitmap);

// SttarArray rutins
// ---------------------------------------------------------------------------

// Megkeresi a legfényesebb csillagot és visszaadja tömbbeli indexét
function GetMaxStar(ar: array of TStarRecord): integer;

// HISTOGRAM

function HistogramInit: TRGBColorsArray;
function GetRGBHistogram(Bitmap: TBitmap): TRGBColorsArray;
function RGBStatisticInit: TRGBStatisticArray;
function GetRGBStatistic(Bitmap: TBitmap): TRGBStatisticArray;
function GetRGBStatisticMax(Bitmap: TBitmap): TRGB24;

// Processes

procedure DoProcessList(var Bitmap: TBitmap; PrList: TStringList);

implementation

// Execute a bitmap process
procedure DoBMPAction( var Bitmap:TBitmap; BMPAction: TBMPAction;
                       Par1, Par2, Par3: Variant);
begin
  if Bitmap<>nil then
  Case BMPAction of
  bacFlipVertical    : FlipVertical(Bitmap);
  bacFlipHorizontal  : FlipHorizontal(Bitmap);
  bacGrayscale       : Grayscale(Bitmap);
  bacNegative        : Negative(Bitmap);
  bacFlaxen          : Flaxen(Bitmap);
  bacEmboss          : Emboss(Bitmap, Par1);
  end;
end;

// NEEDED ROUTINS

(*
function InRange(Test,Min,Max: integer): Boolean;
begin
  Result:=(Test >= Min) and (Test <= Max);
end;

function InRange(Test,Min,Max: double): Boolean;
begin
  Result:=(Test >= Min) and (Test <= Max);
end;
*)
// Forces that test value be in range
function Range(Test,Min,Max: Integer): Integer;
begin
  Result := Test;
  if Test<Min then Result := Min;
  if Test>Max then Result := Max;
end;

function BoolToStr(bVal: boolean): string;
begin
  if bVal then Result := 'True'
  else Result := 'False';
end;

function IntToByte(i:Integer):Byte;
begin
  if i > 255 then
    Result := 255
  else if i < 0 then
    Result := 0
  else
    Result := i;
end;

function FloatToByte(i:double):Byte;
begin
  Result := IntToByte(Round(i));
end;

function PointToCoord(p: TPoint): string;
begin
  Result := inttostr(p.x)+':'+inttostr(p.y);
end;

function GetCoordStr(x,y: integer): string;
begin
  Result := inttostr(x)+':'+inttostr(y);
end;

function GetCoordStr(x,y: double): string;
begin
  Result := Format('%6.2f',[x])+':'+Format('%6.2f',[y]);
end;

function GetRGBStr(co: TColor): string;
begin
  Result := IntToStr(GetRValue(co))+':'+IntToStr(GetGValue(co))+':'+IntToStr(GetBValue(co));
end;

// Central magnifíe a Rect
function RectMagnify(R: TRect; n: double):TRect;
var dx,dy: double;
    CentX,CentY : double;
    RR : TRect;
begin
   RR    := CorrectRect(R);
   CentX := (RR.Left+RR.Right)/2;
   CentY := (RR.Top+RR.Bottom)/2;
   dx    := n*(RR.Right-RR.Left)/2;
   dy    := n*(RR.Bottom-RR.Top)/2;
   Result:= Rect(Round(CentX-dx),Round(CentY-dy),Round(CentX+dx),Round(CentY+dy));
end;

// Increase or decrease a Rect
function RectInflate(R: TRect; dx,dy: integer):TRect;
Var RR : TRect;
begin
   RR    := CorrectRect(R);
   Result:= Rect(RR.Left-dx,RR.Top-dy,RR.Right+dx,RR.Bottom+dy);
end;

// Vector from FromP to ToP

function Vektor(FromP, Top: TPoint): TPoint;
begin
  Result.x := Top.x - FromP.x;
  Result.y := Top.y - FromP.y;
end;

// new x-component of the vector
function xComp(Vektor: TPoint; Angle: Extended): Integer;
begin
  Result := Round(Vektor.x * cos(Angle) - (Vektor.y) * sin(Angle));
end;

procedure quicksort(var a: array of integer);

procedure sort(l,r: integer);
var
  i,j,x,y: integer;
begin
  i:=l; j:=r; x:=a[(l+r) DIV 2];
  repeat
    while a[i]<x do i:=i+1;
    while x<a[j] do j:=j-1;
    if i<=j then
    begin
      y:=a[i]; a[i]:=a[j]; a[j]:=y;
      i:=i+1; j:=j-1;
    end;
  until i>j;
  if l<j then sort(l,j);
  if i<r then sort(i,r);
end;

begin {quicksort};
  sort(0,High(a));
end;

// Load a BMP or JPG into bitmap
function Load_Bitmap(FName: string; BM: TBitmap): boolean;
var ext: string;
    jpgIMG: TJpegImage;
begin
Try
  Result := False;
  if FileExists(FName) then
  Try
     ext := UpperCase(ExtractFileExt(FName));
     If ext='.BMP' then BM.LoadFromFile(FName);
     If ext='.JPG' then
     begin
        jpgIMG := TJpegImage.Create;
        jpgIMG.LoadFromFile(FName);
        BM.Assign(jpgIMG);
        if jpgIMG<>nil then jpgIMG.Free;
     end;
  except
    if jpgIMG<>nil then jpgIMG.Free;
    exit;
  end;
finally
  BM.PixelFormat := pf24bit;
  Result := True;
end;
end;

function Save_Bitmap(FName: string; BM: TBitmap): boolean;
var ext: string;
    jpgIMG: TJpegImage;
begin
Try
  Result := False;
  BM.PixelFormat := pf24bit;
     ext := UpperCase(ExtractFileExt(FName));
     If ext='.BMP' then BM.SaveToFile(FName);
     If ext='.JPG' then
     begin
        jpgIMG := TJpegImage.Create;
        jpgIMG.Assign(BM);
        jpgIMG.SaveToFile(FName);
        SLEEP(1000);
        if jpgIMG<>nil then jpgIMG.Free;
     end;
finally
  Result := True;
end;
end;

// Delete an existing file from disk
function Delete_file(FName: string): boolean;
begin
Try
  Result := False;
  if FileExists(FName) then
  if MessageDlg('Do you really want to delete ' + ExtractFileName(FName) + '?',
                mtWarning, [mbYes,mbNo],0) = mrYes then
  begin
    Result := DeleteFile(FName);
  end;
except
  Result := False;
end;
end;

procedure LoadWICImage(fn: string; bmp: TBitmap);
var
  W: TWICImage;
begin
  W:= TWicImage.Create;
  try
    Try
      W.LoadFromFile(fn);
    Except
      W.LoadFromFile(fn);
    End;
    if Bmp=nil then
    Bmp:= TBitmap.Create;
    Bmp.Assign(W);
    BMP.PixelFormat := pf24bit;
  finally
    W.Free;
  end;
end;

// new y-component of the vector
function yComp(Vektor: TPoint; Angle: Extended): Integer;
begin
  Result := Round((Vektor.x) * (sin(Angle)) + (vektor.y) * cos(Angle));
end;

// Resize the input bitmap
function BMPResize( Bitmap:TBitmap ; const x,y: integer ):boolean;
begin
Try
  Result := True;
  Bitmap.width := x;
  Bitmap.Height := y;
except
  Result := False;
end;
end;

function BMPResize( Bitmap:TBitmap ; const x,y: integer; color: TColor ):boolean;
begin
Try
  Result := True;
  Bitmap.width := x;
  Bitmap.Height := y;
  Bitmap.Canvas.Brush.Color := color;
  Bitmap.Canvas.Pen.Color := color;
  Bitmap.Canvas.Rectangle(Bitmap.Canvas.ClipRect);
except
  Result := False;
end;
end;

procedure SmoothResize(abmp:TBitmap; NuWidth,NuHeight:integer);
var
  xscale, yscale         : Single;
  sfrom_y, sfrom_x       : Single;
  ifrom_y, ifrom_x       : Integer;
  to_y, to_x             : Integer;
  weight_x, weight_y     : array[0..1] of Single;
  weight                 : Single;
  new_red, new_green     : Integer;
  new_blue               : Integer;
  total_red, total_green : Single;
  total_blue             : Single;
  ix, iy                 : Integer;
  bTmp : TBitmap;
  sli, slo : pRGBArray;
begin
  abmp.PixelFormat := pf24bit;
  bTmp := TBitmap.Create;
  bTmp.PixelFormat := pf24bit;
  bTmp.Width := NuWidth;
  bTmp.Height := NuHeight;
  xscale := bTmp.Width / (abmp.Width-1);
  yscale := bTmp.Height / (abmp.Height-1);
  for to_y := 0 to bTmp.Height-1 do begin
    sfrom_y := to_y / yscale;
    ifrom_y := Trunc(sfrom_y);
    weight_y[1] := sfrom_y - ifrom_y;
    weight_y[0] := 1 - weight_y[1];
    for to_x := 0 to bTmp.Width-1 do begin
      sfrom_x := to_x / xscale;
      ifrom_x := Trunc(sfrom_x);
      weight_x[1] := sfrom_x - ifrom_x;
      weight_x[0] := 1 - weight_x[1];
      total_red   := 0.0;
      total_green := 0.0;
      total_blue  := 0.0;
      for ix := 0 to 1 do begin
        for iy := 0 to 1 do begin
          sli := abmp.Scanline[ifrom_y + iy];
          new_red := sli[ifrom_x + ix].R;
          new_green := sli[ifrom_x + ix].G;
          new_blue := sli[ifrom_x + ix].B;
          weight := weight_x[ix] * weight_y[iy];
          total_red   := total_red   + new_red   * weight;
          total_green := total_green + new_green * weight;
          total_blue  := total_blue  + new_blue  * weight;
        end;
      end;
      slo := bTmp.ScanLine[to_y];
      slo[to_x].R := Round(total_red);
      slo[to_x].G := Round(total_green);
      slo[to_x].B := Round(total_blue);
    end;
  end;
  abmp.Width := bTmp.Width;
  abmp.Height := bTmp.Height;
  abmp.Canvas.Draw(0,0,bTmp);
  bTmp.Free;
end;

procedure SmoothResize2(abmp: TBitmap; NuWidth, NuHeight: integer);
var
  xscale, yscale: Single;
  sfrom_y, sfrom_x: Single;
  ifrom_y, ifrom_x: Integer;
  to_y, to_x: Integer;
  weight_x, weight_y: array[0..1] of Single;
  weight: Single;
  new_red, new_green: Integer;
  new_blue: Integer;
  total_red, total_green: Single;
  total_blue: Single;
  ix, iy: Integer;
  bTmp: TBitmap;
  sli, slo: pRGBArray;
  {pointers for scanline access}
  liPByte, loPByte, p: PByte;
  {offset increment}
  liSize, loSize: integer;
begin
  abmp.PixelFormat := pf24bit;
  bTmp := TBitmap.Create;
  bTmp.PixelFormat := pf24bit;
  bTmp.Width := NuWidth;
  bTmp.Height := NuHeight;
  xscale := bTmp.Width / (abmp.Width - 1);
  yscale := bTmp.Height / (abmp.Height - 1);
  liPByte := abmp.Scanline[0];
  liSize := integer(abmp.Scanline[1]) - integer(liPByte);
  loPByte := bTmp.Scanline[0];
  loSize := integer(bTmp.Scanline[1]) - integer(loPByte);
  for to_y := 0 to bTmp.Height - 1 do
  begin
    sfrom_y := to_y / yscale;
    ifrom_y := Trunc(sfrom_y);
    weight_y[1] := sfrom_y - ifrom_y;
    weight_y[0] := 1 - weight_y[1];
    for to_x := 0 to bTmp.Width - 1 do
    begin
      sfrom_x := to_x / xscale;
      ifrom_x := Trunc(sfrom_x);
      weight_x[1] := sfrom_x - ifrom_x;
      weight_x[0] := 1 - weight_x[1];
      total_red := 0.0;
      total_green := 0.0;
      total_blue := 0.0;
      for ix := 0 to 1 do
      begin
        for iy := 0 to 1 do
        begin
          p := liPByte;
          Inc(p, liSize * (ifrom_y + iy));
          sli := pRGBArray(p);
          new_red := sli[ifrom_x + ix].R;
          new_green := sli[ifrom_x + ix].G;
          new_blue := sli[ifrom_x + ix].B;
          weight := weight_x[ix] * weight_y[iy];
          total_red := total_red + new_red * weight;
          total_green := total_green + new_green * weight;
          total_blue := total_blue + new_blue * weight;
        end;
      end;
      p := loPByte;
      Inc(p, loSize * to_y);
      slo := pRGBArray(p);
      slo[to_x].R := Round(total_red);
      slo[to_x].G := Round(total_green);
      slo[to_x].B := Round(total_blue);
    end;
  end;
  abmp.Width := bTmp.Width;
  abmp.Height := bTmp.Height;
  abmp.Canvas.Draw(0, 0, bTmp);
  bTmp.Free;
end;

// Copy SourceBitmap to DestBitmap and corrigate the DestBitmap dimensions
function BMPCopy( SourceBitmap : TBitmap; DestBitmap : TBitmap ):boolean;
begin
Try
  BMPResize(DestBitmap,SourceBitmap.Width,SourceBitmap.Height);
  DestBitmap.Canvas.Draw(0,0,SourceBitmap);
except
  Result := False;
end;
end;

procedure GetSubDirs(const sRootDir: string; slt: TStrings);
var
  srSearch: TSearchRec;
  sSearchPath: string;
  sltSub: TStrings;
  i: Integer;
begin
  sltSub := TStringList.Create;
  slt.BeginUpdate;
  try
    sSearchPath := sRootDir+'\';
    if FindFirst(sSearchPath + '*', faDirectory, srSearch) = 0 then
      repeat
        if ((srSearch.Attr and faDirectory) = faDirectory) and
          (srSearch.Name <> '.') and
          (srSearch.Name <> '..') then
        begin
          slt.Add(sSearchPath + srSearch.Name);
          sltSub.Add(sSearchPath + srSearch.Name);
        end;
      until (FindNext(srSearch) <> 0);

    FindClose(srSearch);

    for i := 0 to sltSub.Count - 1 do
      GetSubDirs(sltSub.Strings[i], slt);
  finally
    slt.EndUpdate;
    FreeAndNil(sltSub);
  end;

end;

function WinExecAndWait32(FileName: string; Visibility: Integer): Longword;
var { by Pat Ritchey }
  zAppName: array[0..512] of Char;
  zCurDir: array[0..255] of Char;
  WorkDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  StrPCopy(zAppName, FileName);
  GetDir(0, WorkDir);
  StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb          := SizeOf(StartupInfo);
  StartupInfo.dwFlags     := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  if not CreateProcess(nil,
    zAppName, // pointer to command line string
    nil, // pointer to process security attributes
    nil, // pointer to thread security attributes
    False, // handle inheritance flag
    CREATE_NEW_CONSOLE or // creation flags
    NORMAL_PRIORITY_CLASS,
    nil, //pointer to new environment block
    nil, // pointer to current directory name
    StartupInfo, // pointer to STARTUPINFO
    ProcessInfo) // pointer to PROCESS_INF
    then Result := WAIT_FAILED
  else
  begin
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess, Result);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
  end;
end; { WinExecAndWait32 }

// ; ShowType: integer : SW_HIDE, SW_NORMAL, ....
procedure ShellExecute_AndWait(FileName: string; Params: string; ShowType: integer);
var
  exInfo: TShellExecuteInfo;
  Ph: DWORD;
begin
  FillChar(exInfo, SizeOf(exInfo), 0);
  with exInfo do
  begin
    cbSize := SizeOf(exInfo);
    fMask := SEE_MASK_NOCLOSEPROCESS or SEE_MASK_FLAG_DDEWAIT;
    Wnd := GetActiveWindow();
    ExInfo.lpVerb := 'open';
    ExInfo.lpParameters := PChar(Params);
    lpFile := PChar(FileName);
    nShow := ShowType;
//    nShow := SW_SHOWNORMAL;
  end;
  if ShellExecuteEx(@exInfo) then
    Ph := exInfo.HProcess
  else
  begin
    ShowMessage(SysErrorMessage(GetLastError));
    Exit;
  end;
  while WaitForSingleObject(ExInfo.hProcess, 50) <> WAIT_OBJECT_0 do
    Application.ProcessMessages;
  CloseHandle(Ph);
end;


function ReadMWord(f: TFileStream): Word;
type
  TMotorolaWord = record
    case Byte of
      0: (Value: Word);
      1: (Byte1, Byte2: Byte);
  end;
var
  MW: TMotorolaWord;
begin
  { It would probably be better to just read these two bytes in normally }
  { and then do a small ASM routine to swap them.  But we aren't talking }
  { about reading entire files, so I doubt the performance gain would be }
  { worth the trouble. }
  f.read(MW.Byte2, SizeOf(Byte));
  f.read(MW.Byte1, SizeOf(Byte));
  Result := MW.Value;
end;

procedure GetJPGSize(const sFile: string; var wWidth, wHeight: word);
const
  ValidSig: array[0..1] of Byte = ($FF, $D8);
  Parameterless = [$01, $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7];
var
  Sig: array[0..1] of byte;
  f: TFileStream;
  x: integer;
  Seg: byte;
  Dummy: array[0..15] of byte;
  Len: word;
  ReadLen: LongInt;
begin
  FillChar(Sig, SizeOf(Sig), #0);
  f := TFileStream.Create(sFile, fmOpenRead);
  try
    ReadLen := f.read(Sig[0], SizeOf(Sig));

    for x := Low(Sig) to High(Sig) do
      if Sig[x] <> ValidSig[x] then ReadLen := 0;

    if ReadLen > 0 then
    begin
      ReadLen := f.read(Seg, 1);
      while (Seg = $FF) and (ReadLen > 0) do
      begin
        ReadLen := f.read(Seg, 1);
        if Seg <> $FF then
        begin
          if (Seg = $C0) or (Seg = $C1) then
          begin
            ReadLen := f.read(Dummy[0], 3); { don't need these bytes }
            wHeight := ReadMWord(f);
            wWidth  := ReadMWord(f);
          end
          else
          begin
            if not (Seg in Parameterless) then
            begin
              Len := ReadMWord(f);
              f.Seek(Len - 2, 1);
              f.read(Seg, 1);
            end 
            else
              Seg := $FF; { Fake it to keep looping. }
          end;
        end;
      end;
    end;
  finally
    f.Free;
  end;
end;

procedure GetPNGSize(const sFile: string; var wWidth, wHeight: Word);
type
  TPNGSig = array[0..7] of Byte;
const
  ValidSig: TPNGSig = (137,80,78,71,13,10,26,10);
var
  Sig: TPNGSig;
  f: tFileStream;
  x: integer;
begin
  FillChar(Sig, SizeOf(Sig), #0);
  f := TFileStream.Create(sFile, fmOpenRead);
  try
    f.read(Sig[0], SizeOf(Sig));
    for x := Low(Sig) to High(Sig) do
      if Sig[x] <> ValidSig[x] then Exit;
    f.Seek(18, 0);
    wWidth := ReadMWord(f);
    f.Seek(22, 0);
    wHeight := ReadMWord(f);
  finally
    f.Free;
  end;
end;

procedure GetGIFSize(const sGIFFile: string; var wWidth, wHeight: Word);
type
  TGIFHeader = record
    Sig: array[0..5] of char;
    ScreenWidth, ScreenHeight: Word;
    Flags, Background, Aspect: Byte;
  end;

  TGIFImageBlock = record
    Left, Top, Width, Height: Word;
    Flags: Byte;
  end;
var
  f: file;
  Header: TGifHeader;
  ImageBlock: TGifImageBlock;
  nResult: integer;
  x: integer;
  c: char;
  DimensionsFound: boolean;
begin
  wWidth  := 0;
  wHeight := 0;

  if sGifFile = '' then
    Exit;

  {$I-}
  FileMode := 0;   { read-only }
  AssignFile(f, sGifFile);
  reset(f, 1);
  if IOResult <> 0 then
    { Could not open file }
    Exit;

  { Read header and ensure valid file. }
  BlockRead(f, Header, SizeOf(TGifHeader), nResult);
  if (nResult <> SizeOf(TGifHeader)) or (IOResult <> 0) or
    (StrLComp('GIF', Header.Sig, 3) <> 0) then
  begin
    { Image file invalid }
    Close(f);
    Exit;
  end;

  { Skip color map, if there is one }
  if (Header.Flags and $80) > 0 then
  begin
    x := 3 * (1 shl ((Header.Flags and 7) + 1));
    Seek(f, x);
    if IOResult <> 0 then
    begin
      { Color map thrashed }
      Close(f);
      Exit;
    end;
  end;

  DimensionsFound := False;
  FillChar(ImageBlock, SizeOf(TGIFImageBlock), #0);
  { Step through blocks. }
  BlockRead(f, c, 1, nResult);
  while (not EOF(f)) and (not DimensionsFound) do
  begin
    case c of
      ',': { Found image }
        begin
          BlockRead(f, ImageBlock, SizeOf(TGIFImageBlock), nResult);
          if nResult <> SizeOf(TGIFImageBlock) then 
          begin
            { Invalid image block encountered }
            Close(f);
            Exit;
          end;
          wWidth := ImageBlock.Width;
          wHeight := ImageBlock.Height;
          DimensionsFound := True;
        end;
      'y': { Skip }
        begin
          { NOP }
        end;
      { nothing else.  just ignore }
    end;
    BlockRead(f, c, 1, nResult);
  end;
  Close(f);
  {$I+}
end;

function ScalePercentBmp(bitmp: TBitmap; iPercent: Integer): Boolean;
var
  TmpBmp: TBitmap;
  ARect: TRect;
  h, w: Real;
  hi, wi: Integer;
begin
  Result := False;
  try
    TmpBmp := TBitmap.Create;
    try
      h := bitmp.Height * (iPercent / 100);
      w := bitmp.Width * (iPercent / 100);
      hi := StrToInt(FormatFloat('#', h)) + bitmp.Height;
      wi := StrToInt(FormatFloat('#', w)) + bitmp.Width;
      TmpBmp.Width := wi;
      TmpBmp.Height := hi;
      ARect := Rect(0, 0, wi, hi);
      TmpBmp.Canvas.StretchDraw(ARect, Bitmp);
      bitmp.Assign(TmpBmp);
    finally
      TmpBmp.Free;
    end;
    Result := True;
  except
    Result := False;
  end;
end;

procedure CopyStreamToClipboard(fmt: Cardinal; S: TStream);
var
  hMem: THandle;
  pMem: Pointer;
begin
  S.Position := 0;
  hMem       := GlobalAlloc(GHND or GMEM_DDESHARE, S.Size);
  if hMem <> 0 then
  begin
    pMem := GlobalLock(hMem);
    if pMem <> nil then 
    begin
      S.Read(pMem^, S.Size);
      S.Position := 0;
      GlobalUnlock(hMem);
      Clipboard.Open;
      try
        Clipboard.SetAsHandle(fmt, hMem);
      finally
        Clipboard.Close;
      end;
    end { If }
    else
    begin
      GlobalFree(hMem);
      OutOfMemoryError;
    end;
  end { If }
  else
    OutOfMemoryError;
end; { CopyStreamToClipboard }


procedure CopyStreamFromClipboard(fmt: Cardinal; S: TStream);
var
  hMem: THandle;
  pMem: Pointer;
begin
  hMem := Clipboard.GetAsHandle(fmt);
  if hMem <> 0 then
  begin
    pMem := GlobalLock(hMem);
    if pMem <> nil then
    begin
      S.Write(pMem^, GlobalSize(hMem));
      S.Position := 0;
      GlobalUnlock(hMem);
    end { If }
    else
      raise Exception.Create('CopyStreamFromClipboard: could not lock global handle ' +
        'obtained from clipboard!');
  end; { If }
end; { CopyStreamFromClipboard }

procedure TurnLeft(src, dst: tbitmap);
var w,h,x,y:integer;
    ps,pd:pbytearray;
begin
 h:=src.Height;
 w:=src.width;
 src.PixelFormat :=pf24bit;
 dst.PixelFormat :=pf24bit;
 dst.Height :=w;
 dst.Width :=h;
 for y:=0 to h-1 do begin
  ps:=src.ScanLine [y];
  for x:=0 to w-1 do begin
   pd:=dst.ScanLine [w-1-x];
   pd[y*3]:=ps[x*3];
   pd[y*3+1]:=ps[x*3+1];
   pd[y*3+2]:=ps[x*3+2];
   end;
  end;
end;

procedure TurnLeft(src:tbitmap); overload;
var w,h,x,y:integer;
    ps,pd:pbytearray;
    dst: TBitmap;
begin
Try
 h:=src.Height;
 w:=src.width;
 src.PixelFormat :=pf24bit;
 dst.PixelFormat :=pf24bit;
 dst.Height :=w;
 dst.Width :=h;
 for y:=0 to h-1 do begin
  ps:=src.ScanLine [y];
  for x:=0 to w-1 do begin
   pd:=dst.ScanLine [w-1-x];
   pd[y*3]:=ps[x*3];
   pd[y*3+1]:=ps[x*3+1];
   pd[y*3+2]:=ps[x*3+2];
   end;
  end;
Finally
  src.Assign(dst);
  dst.Free;
End;
end;

procedure TurnRight(src, dst: Tbitmap);
var w,h,x,y:integer;
    ps,pd:pbytearray;
begin
 h:=src.Height;
 w:=src.width;
 src.PixelFormat :=pf24bit;
 dst.PixelFormat :=pf24bit;
 dst.Height :=w;
 dst.Width :=h;
 for y:=0 to h-1 do begin
  ps:=src.ScanLine [y];
  for x:=0 to w-1 do begin
   pd:=dst.ScanLine [x];
   pd[(h-1-y)*3]:=ps[x*3];
   pd[(h-1-y)*3+1]:=ps[x*3+1];
   pd[(h-1-y)*3+2]:=ps[x*3+2];
   end;
  end;
end;

function ColorToTriple(Color:TColor):TRGBTriple;
type
  Rec=Record
  Case TColor of
  1:( ColorValue:TColor );
  2:(Bytes: array [0..3] of Byte);
  end;
var
  Col:Rec;
begin
  Col.ColorValue:= Color;

  Result.rgbtRed :=Col.Bytes[3];
  Result.rgbtGreen :=Col.Bytes[2];
  Result.rgbtBlue :=Col.Bytes[1];
end ;

function TripleToColor( RGB: TRGBTriple):TColor;
begin
  Result := RGB.rgbtRed + 256*RGB.rgbtGreen + 65536*RGB.rgbtBlue;
end;

function ChangeRGBColor(var color:TRGBTriple;R,G,B:integer):TRGBTriple;
begin
if  B+Color.rgbtBlue >255 then Color.rgbtBlue :=255 else
if  B+Color.rgbtBlue <0 then  Color.rgbtBlue :=0 else
inc(Color.rgbtBlue,B) ;


if  G+Color.rgbtGreen >255 then Color.rgbtGreen :=255 else
if  G+Color.rgbtGreen <0 then  Color.rgbtGreen :=0 else
inc(Color.rgbtGreen,G) ;

if  R+Color.rgbtRed >255 then Color.rgbtRed :=255 else
if  R+Color.rgbtRed <0 then  Color.rgbtRed :=0 else
inc(Color.rgbtRed,R) ;
Result:=Color;

end;

// Changes the RGB colors all pixesl of bitmap
// RGB = 1 : not modifies; <1: decreas; >1: increse
procedure ChangeRGB(var Bitmap: TBitmap; R,G,B: double);
var
  H,V: integer;
  Row: pPixelArray;
begin
 Bitmap.PixelFormat:=pf24bit;
 for V:=0 to Bitmap.Height -1 do
  begin
      Row := Bitmap.ScanLine[V];
      for H:=0 to Bitmap.Width -1 do
      WITH Row[H] DO
      begin
           rgbtRed   := FloatToByte(rgbtRed*R);
           rgbtGreen := FloatToByte(rgbtGreen*G);
           rgbtBlue  := FloatToByte(rgbtBlue*B);
      end;
  end;
end;

procedure Flaxen( Bitmap:TBitmap);
var
H,V:Integer;
WSK,WSK2,WSK3:^TRGBTriple;
begin
Bitmap.PixelFormat:=pf24bit;
for V:=0 to Bitmap.Height-1 do
  begin
Wsk:=Bitmap.ScanLine[V];
Wsk2:=Wsk;
Wsk3:=Wsk;
inc(Wsk2);
inc(Wsk3,2);

for H:=0 to Bitmap.Width -1 do
    begin
    Wsk.rgbtRed  := (Wsk.rgbtRed + Wsk2.rgbtGreen  +
    Wsk3.rgbtBlue) div 3;
    Wsk2.rgbtGreen := (Wsk.rgbtGreen + Wsk2.rgbtGreen +
    Wsk3.rgbtBlue) div 3;
    Wsk2.rgbtBlue := (Wsk.rgbtBlue + Wsk2.rgbtGreen +
    Wsk3.rgbtBlue) div 3;
    inc(Wsk);inc(Wsk2);inc(Wsk3);
    end;
  end;

end;

procedure Emboss(Bitmap : TBitmap; AMount : Integer);
var
  x, y, i : integer;
  p1, p2: PByteArray;
begin
  for i := 0 to AMount do
  begin
    for y := 0 to Bitmap.Height-2 do
    begin
      p1 := Bitmap.ScanLine[y];
      p2 := Bitmap.ScanLine[y+1];
      for x := 0 to Bitmap.Width do
      begin
        p1[x*3] := (p1[x*3]+(p2[(x+3)*3] xor $FF)) shr 1;
        p1[x*3+1] := (p1[x*3+1]+(p2[(x+3)*3+1] xor $FF)) shr 1;
        p1[x*3+2] := (p1[x*3+1]+(p2[(x+3)*3+1] xor $FF)) shr 1;
      end;
    end;
  end;
end;

procedure MonoNoise(var Bitmap: TBitmap; Amount: Integer);
var
Row:^TRGBTriple;
H,V,a: Integer;
begin
  for V:=0 to Bitmap.Height-1 do
  begin
    Row:=Bitmap.ScanLine[V];
    for H:=0 to Bitmap.Width-1 do
    begin
      a:=Random(Amount)-(Amount shr 1);

      Row.rgbtBlue :=IntToByte(Row.rgbtBlue+a);
      Row.rgbtGreen :=IntToByte(Row.rgbtGreen+a);
      Row.rgbtRed :=IntToByte(Row.rgbtRed+a);
      inc(Row);
    end;
  end;
end;


procedure ColorNoise( Bitmap: TBitmap; Amount: Integer);
var
WSK:^Byte;
H,V,a: Integer;
begin
Bitmap.PixelFormat:=pf24bit;
  for V:=0 to Bitmap.Height-1 do
  begin
    Wsk:=Bitmap.ScanLine[V];
    for H:=0 to Bitmap.Width*3-1 do
    begin
    Wsk^:=IntToByte(Wsk^+(Random(Amount)-(Amount shr 1)));
      inc(Wsk);
    end;
  end;
end;

Procedure GrayScale(var Bitmap:TBitmap);
var
   Row:^TRGBTriple;
   H,V,Index:Integer;
begin
 Bitmap.PixelFormat:=pf24bit;
 for V:=0 to Bitmap.Height-1 do
  begin
    Row:=Bitmap.ScanLine[V];
    for H:=0 to Bitmap.Width -1 do
    begin
    Index := ((Row.rgbtRed * 77 +
       Row.rgbtGreen* 150 +
       Row.rgbtBlue * 29) shr 8);
       Row.rgbtBlue:=Index;
       Row.rgbtGreen:=Index;
       Row.rgbtRed:=Index;
       inc(Row);
    end;
  end;
end;

procedure RedToGreen(Bitmap: TBitmap);
var
  x, y, i : integer;
  Row:^TRGBTripleArray;
  p : PByteArray;
begin
 Bitmap.PixelFormat:=pf24bit;
  for y := 0 to Bitmap.Height-1 do begin
    P := Bitmap.ScanLine[y];
    for x := 0 to Bitmap.Width do
      begin
        p[x*3+2] := p[(x*3)];
      end;
  end;
end;

// Adjust RGB colors of bitmat.
// Amount = 1   : not change the color chanel;
//          0.5 : 50% half intensity of color
//          1.8 : 180% intensity of color
Procedure ColorAdjust(var Bitmap:TBitmap; AmountR, AmountG, AmountB: double);
var
   Row:^TRGBTriple;
//   Row:pbytearray;
   X,Y:Integer;
   e: byte;
begin
 Bitmap.PixelFormat:=pf24bit;
 for Y:=0 to Bitmap.Height-1 do
  begin
    Row:=Bitmap.ScanLine[Y];
    for X:=0 to Bitmap.Width -1 do
    begin
 (*
       e := Row[x*3];
       Row[x*3]   := FloatToByte(Row[x*3] * AmountB);
       Row[x*3+1] := FloatToByte(Row[x*3+1] * AmountG);
       Row[x*3+2] := FloatToByte(Row[x*3+2] * AmountR);
 *)
       Row.rgbtRed   := FloatToByte(Row.rgbtRed * AmountR);
       Row.rgbtGreen := FloatToByte(Row.rgbtGreen * AmountG);
       Row.rgbtBlue  := FloatToByte(Row.rgbtBlue * AmountB);
       inc(Row);
    end;
  end;
end;

// Adjust RGB colors of bitmap.
//    Threshold alatt 0
Procedure ColorAdjustEx(var Bitmap:TBitmap; Threshold: byte);
var
Wsk:^Byte;
H,V: Integer;
begin
  Bitmap.pixelformat:=pf24bit;
  for V:=0 to Bitmap.Height-1 do begin
    WSK:=Bitmap.ScanLine[V];
    for H:=0 to Bitmap.Width*3-1 do
    begin
    if Wsk^>Threshold then
       Wsk^:= Round(Wsk^*(1-((255-Wsk^)/255)))
    else
       Wsk^:= 0;
    inc(Wsk);
  end;
 end;
end;
(*var
   Row:^TRGBTriple;
   H,V:Integer;
   th: TThresHold;
begin
 Bitmap.PixelFormat:=pf24bit;
 TH := GetAverageThreshold(Bitmap);
 for V:=0 to Bitmap.Height-1 do
  begin
    Row:=Bitmap.ScanLine[V];
    for H:=0 to Bitmap.Width -1 do
    begin
       Row.rgbtRed   := Round(100*(255-Row.rgbtRed)/255);
       Row.rgbtRed   := Round(100*(255-Row.rgbtRed)/255);
       Row.rgbtRed   := Round(100*(255-Row.rgbtRed)/255);
       if Row.rgbtRed<=3*th.R then
       Row.rgbtRed   := Round(Row.rgbtRed * AmountR);
       if Row.rgbtGreen<=2*th.G then
       Row.rgbtGreen := Round(Row.rgbtGreen * AmountG);
       if Row.rgbtBlue<=2*th.B then
       Row.rgbtBlue  := Round(Row.rgbtBlue * AmountB);
       inc(Row);
    end;
  end;
end;*)

// Az egyszínû pixelek eltávolítása
Procedure ColorNoiseElimination(var Bitmap:TBitmap);
var
   Row:^TRGBTriple;
   H,V:Integer;
   szorzo: double;
begin
 szorzo:=1.2;
 Bitmap.PixelFormat:=pf24bit;
 for V:=0 to Bitmap.Height-1 do
  begin
    Row:=Bitmap.ScanLine[V];
    for H:=0 to Bitmap.Width -1 do
    begin
       if (Row.rgbtRed>szorzo*Row.rgbtGreen) or (Row.rgbtGreen=0) or (Row.rgbtBlue=0) then
          Row.rgbtRed   := 0;
       if (Row.rgbtGreen>szorzo*Row.rgbtRed) or (Row.rgbtRed=0) or (Row.rgbtBlue=0) then
          Row.rgbtGreen := 0;
       if (Row.rgbtBlue>szorzo*Row.rgbtRed) or (Row.rgbtGreen=0) or (Row.rgbtRed=0) then
          Row.rgbtBlue  := 0;
       inc(Row);
    end;
  end;
end;


// BASIC IMAGE PROCESSES
// ============================================================================


procedure Darkness( Bitmap:TBitmap; Amount: integer);
var
Wsk:^Byte;
H,V: Integer;
begin
  Bitmap.pixelformat:=pf24bit;
  for V:=0 to Bitmap.Height-1 do begin
    WSK:=Bitmap.ScanLine[V];
    for H:=0 to Bitmap.Width*3-1 do
    begin
    Wsk^:=IntToByte(Wsk^-(Wsk^*Amount)div 255);
    inc(Wsk);
  end;
 end;
end;

procedure Threshold( Bitmap:TBitmap ; const Light:TRgbTriple; const Dark:TRgbTriple; Amount:Integer = 128);
var
Row:^TRGBTriple;
H,V,Index:Integer;
begin
 Bitmap.PixelFormat:=pf24bit;
 for V:=0 to Bitmap.Height-1 do
  begin
    Row:=Bitmap.ScanLine[V];
    for H:=0 to Bitmap.Width -1 do
    begin
    Index := ((Row.rgbtRed * 77 +
       Row.rgbtGreen* 150 +
       Row.rgbtBlue * 29) shr 8);
       if Index>Amount then
          Row^:=Light  else Row^:=Dark ;
       inc(Row);
    end;
  end;
end;

procedure Posterize(Bitmap: TBitmap; amount: integer);
var
H,V:Integer;
Wsk:^Byte;
begin
  Bitmap.PixelFormat :=pf24bit;
  for V:=0 to Bitmap.Height -1 do
  begin
   Wsk:=Bitmap.scanline[V];
   for H:=0 to Bitmap.Width*3 -1 do
   begin
     Wsk^:= round(WSK^/amount)*amount ;
     inc(Wsk);
     end;
   end;
end;

procedure Mosaic(var Bm:TBitmap;size:Integer);
var
   x,y,i,j:integer;
   p1,p2:pbytearray;
   r,g,b:byte;
begin
  y:=0;
  repeat
    p1:=bm.scanline[y];
    x:=0;
    repeat
      j:=1;
      repeat
      p2:=bm.scanline[y];
      x:=0;
      repeat
        r:=p1[x*3];
        g:=p1[x*3+1];
        b:=p1[x*3+2];
        i:=1;
       repeat
       p2[x*3]:=r;
       p2[x*3+1]:=g;
       p2[x*3+2]:=b;
       inc(x);
       inc(i);
       until (x>=bm.width) or (i>size);
      until x>=bm.width;
      inc(j);
      inc(y);
      until (y>=bm.height) or (j>size);
    until (y>=bm.height) or (x>=bm.width);
  until y>=bm.height;
end;

procedure Crop(var Bitmap:TBitmap; Rec: TRect);
var BM: TBitmap;
begin
  Try
    BM := TBitmap.Create;
    BMPResize(BM,Rec.Right-Rec.Left,Rec.Bottom-Rec.Top);
    BM.Canvas.CopyRect(BM.Canvas.Cliprect,Bitmap.Canvas,Rec);
    BMPCopy(BM,Bitmap);
  finally
    BM.Free;
  end;
end;

procedure FlipHorizontal(var Bitmap:TBitmap);
type
ByteTriple =array[0..2] of byte        ; // musimy czytaæ po 3 bajty ¿eby nie zamieniæ kolejnoœci BGR na RGB
var
ByteL,ByteR:^ByteTriple;
ByteTemp:ByteTriple;
H,V:Integer;
begin
Bitmap.PixelFormat:=pf24bit;
for V:=0 to (Bitmap.Height -1 )  do
  begin
  ByteL:=Bitmap.ScanLine[V];
  ByteR:=Bitmap.ScanLine[V];
  inc(ByteR,Bitmap.Width -1);
    for H:=0 to (Bitmap.Width -1) div 2  do
    begin
    ByteTemp:=ByteL^;
    ByteL^:=ByteR^;
    ByteR^:=ByteTemp;
    Inc(ByteL);
    Dec(ByteR);
    end;
  end;
end;

procedure FlipVertical(var Bitmap:TBitmap);
var
ByteTop,ByteBottom:^Byte;
ByteTemp:Byte;
H,V:Integer;
begin
for V:=0 to (Bitmap.Height -1 ) div 2 do
  begin
  ByteTop:=Bitmap.ScanLine[V];
  ByteBottom:=Bitmap.ScanLine[Bitmap.Height -1-V];
  for H:=0 to Bitmap.Width *3 -1 do
    begin
    ByteTemp:=ByteTop^;
    ByteTop^:=ByteBottom^;
    ByteBottom^:=ByteTemp;
    inc(ByteTop);
    inc(ByteBottom);
    end;
  end;
end;

function RotImage(srcbit: TBitmap; Angle: Extended; FPoint: TPoint;
  Background: TColor): TBitmap;
var
  highest, lowest, mostleft, mostright: TPoint;
  topoverh, leftoverh: integer;
  x, y, newx, newy: integer;
begin
  Result := TBitmap.Create;

  // Calculate angle down on one rotation, if necessary
  while Angle >= (2 * pi) do
  begin
    angle := Angle - (2 * pi);
  end;

  // specify new size
  if (angle <= (pi / 2)) then
  begin
    highest := Point(0,0);
    Lowest := Point(Srcbit.Width, Srcbit.Height);
    mostleft := Point(0,Srcbit.Height);
    mostright := Point(Srcbit.Width, 0);
  end
  else if (angle <= pi) then
  begin
    highest := Point(0,Srcbit.Height);
    Lowest := Point(Srcbit.Width, 0);
    mostleft := Point(Srcbit.Width, Srcbit.Height);
    mostright := Point(0,0);
  end
  else if (Angle <= (pi * 3 / 2)) then
  begin
    highest := Point(Srcbit.Width, Srcbit.Height);
    Lowest := Point(0,0);
    mostleft := Point(Srcbit.Width, 0);
    mostright := Point(0,Srcbit.Height);
  end
  else
  begin
    highest := Point(Srcbit.Width, 0);
    Lowest := Point(0,Srcbit.Height);
    mostleft := Point(0,0);
    mostright := Point(Srcbit.Width, Srcbit.Height);
  end;

  topoverh := yComp(Vektor(FPoint, highest), Angle);
  leftoverh := xComp(Vektor(FPoint, mostleft), Angle);
  Result.Height := Abs(yComp(Vektor(FPoint, lowest), Angle)) + Abs(topOverh);
  Result.Width  := Abs(xComp(Vektor(FPoint, mostright), Angle)) + Abs(leftoverh);

  // change of FPoint in the new picture in relation on srcbit
  Topoverh := TopOverh + FPoint.y;
  Leftoverh := LeftOverh + FPoint.x;

  // at first fill with background color
  Result.Canvas.Brush.Color := Background;
  Result.Canvas.pen.Color   := background;
  Result.Canvas.Fillrect(Rect(0,0,Result.Width, Result.Height));

  // Start of actual rotation
  for y := 0 to srcbit.Height - 1 do
  begin                       // Rows
    for x := 0 to srcbit.Width - 1 do
    begin                    // Columns
      newX := xComp(Vektor(FPoint, Point(x, y)), Angle);
      newY := yComp(Vektor(FPoint, Point(x, y)), Angle);
      newX := FPoint.x + newx - leftoverh;
      newy := FPoint.y + newy - topoverh;
      // Move beacause of new size
      Result.Canvas.Pixels[newx, newy] := srcbit.Canvas.Pixels[x, y];
      // also fil lthe pixel beside to prevent empty pixels
      if ((angle < (pi / 2)) or
        ((angle > pi) and
        (angle < (pi * 3 / 2)))) then
      begin
        Result.Canvas.Pixels[newx, newy + 1] := srcbit.Canvas.Pixels[x, y];
      end
      else
      begin
        Result.Canvas.Pixels[newx + 1,newy] := srcbit.Canvas.Pixels[x, y];
      end;
    end;
  end;
end;

procedure Negative(var Bitmap:TBitmap);
var
H,V:Integer;
WskByte:^Byte;
begin
Bitmap.PixelFormat:=pf24bit;
for V:=0 to Bitmap.Height-1 do
  begin
    WskByte:=Bitmap.ScanLine[V]; // V jest to pozycja  danej linii bitmapy (od góry )
    for  H:=0 to (Bitmap.Width *3)-1 do
    begin
      WskByte^:= not WskByte^ ;// (odwracamy wartoœæ na któr¹ pokazuje wskaŸnik)
      inc(WskByte);//Przesuwam wskaŸnik
    end;
  end;
end;

procedure BlackAndWhite(var Bitmap:TBitmap );
VAR
  i  :  INTEGER;
  j  :  INTEGER;
  Row:  pPixelArray;
  Gray: byte;
begin
TRY
  Bitmap.PixelFormat := pf24bit;
  FOR j := 0 TO Bitmap.Height-1 DO
  BEGIN
    Row := Bitmap.Scanline[j];
    FOR i := 0 TO Bitmap.Width-1 DO
    BEGIN
      WITH Row[i] DO
      BEGIN
        Gray := (rgbtRed + rgbtGreen + rgbtBlue) div 3;
        rgbtRed   := Gray;
        rgbtGreen := Gray;
        rgbtBlue  := Gray;
      END
    END
  END;
FINALLY
END
end;

procedure Saturation(var  Bitmap: TBitmap; Amount: Integer);
var
  Wsk:^TRGBTriple;
  Gray,H,V: Integer;
begin
  for V:=0 to Bitmap.Height-1 do
  begin
    Wsk:=Bitmap.ScanLine[V];
    for H:=0 to Bitmap.Width-1 do
    begin
    Gray:=(Wsk.rgbtBlue+Wsk.rgbtGreen+Wsk.rgbtRed) div 3;
    Wsk.rgbtRed:=IntToByte(Gray+(((Wsk.rgbtRed-Gray)*Amount)div 255));
    Wsk.rgbtGreen:=IntToByte(Gray+(((Wsk.rgbtGreen-Gray)*Amount)div 255));
    Wsk.rgbtBlue:=IntToByte(Gray+(((Wsk.rgbtBlue-Gray)*Amount)div 255));
    inc(Wsk);
    end;
  end;
end;


procedure Contrast(var Bitmap:TBitmap; Amount: Integer);
var
ByteWsk:^Byte;
H,V:  Integer;
begin
if Amount<>0 then
  for V:=0 to Bitmap.Height-1 do
  begin
    ByteWsk:=Bitmap.ScanLine[V];
    for H:=0 to Bitmap.Width*3 -1  do
    begin
      ByteWsk^:=IntToByte(ByteWsk^-((127-ByteWsk^)*Amount)div 255);
      Inc(ByteWsk);
    end;
  end;
end;

procedure ContrastNess(var clip: tbitmap; Amount: Integer);
var
p0:pbytearray;
rg,gg,bg,r,g,b,x,y:  Integer;
begin
  for y:=0 to clip.Height-1 do
  begin
    p0:=clip.scanline[y];
    for x:=0 to clip.Width-1 do
    begin
      r:=p0[x*3];
      g:=p0[x*3+1];
      b:=p0[x*3+2];
      rg:=(Abs(127-r)*Amount)div 255;
      gg:=(Abs(127-g)*Amount)div 255;
      bg:=(Abs(127-b)*Amount)div 255;
      if r>127 then r:=r+rg else r:=r-rg;
      if g>127 then g:=g+gg else g:=g-gg;
      if b>127 then b:=b+bg else b:=b-bg;
      p0[x*3]:=IntToByte(r);
      p0[x*3+1]:=IntToByte(g);
      p0[x*3+2]:=IntToByte(b);
    end;
  end;
end;

procedure Gamma(var Bitmap:TBitmap; Amount: double);
var
ByteWsk:^Byte;
H,V:  Integer;
begin
  for V:=0 to Bitmap.Height-1 do
  begin
    ByteWsk:=Bitmap.ScanLine[V];
    for H:=0 to Bitmap.Width*3 -1  do
    begin
      ByteWsk^:=FloatToByte(ByteWsk^*Amount);
      Inc(ByteWsk);
    end;
  end;
end;

procedure KeepBlue(src: Tbitmap; factor: extended);
var x,y,w,h:integer;
    p0:pbytearray;
begin
  src.PixelFormat :=pf24bit;
  w:=src.width;
  h:=src.height;
  for y:=0 to h-1 do begin
    p0:=src.scanline[y];
   for x:=0 to w-1 do begin
    p0[x*3]:=round(factor*p0[x*3]);
    p0[x*3+1]:=0;
    p0[x*3+2]:=0;
    end;
   end;
end;

procedure KeepGreen(src: Tbitmap; factor: extended);
var x,y,w,h:integer;
    p0:pbytearray;
begin
  src.PixelFormat :=pf24bit;
  w:=src.width;
  h:=src.height;
  for y:=0 to h-1 do begin
    p0:=src.scanline[y];
   for x:=0 to w-1 do begin
    p0[x*3+1]:=round(factor*p0[x*3+1]);
    p0[x*3]:=0;
    p0[x*3+2]:=0;
    end;
   end;
end;

procedure KeepRed(src: Tbitmap; factor: extended);
var x,y,w,h:integer;
    p0:pbytearray;
begin
  src.PixelFormat :=pf24bit;
  w:=src.width;
  h:=src.height;
  for y:=0 to h-1 do begin
    p0:=src.scanline[y];
   for x:=0 to w-1 do begin
    p0[x*3+2]:=round(factor*p0[x*3+2]);
    p0[x*3+1]:=0;
    p0[x*3]:=0;
    end;
   end;
end;

// =========== ROTATTE BITMAP =====================================

function TStretchBitmap.StretchBitm(Bitmap, Target: TBitmap; R: TRotateRec): Boolean;
var
  i: integer;
  pptr1, pptr2: array of TArray;
  ptrscanline1, ptrscanline2: array of integer;
begin
if (Bitmap<>nil) and (Target<>nil) then begin
   SetLength(ptrscanline1, bitmap.Height);
   SetLength(ptrscanline2, target.Height);
   for i := 0 to bitmap.Height - 1 do
     ptrscanline1[i] := integer(bitmap.ScanLine[i]);
   for i := 0 to target.Height - 1 do
     ptrscanline2[i] := integer(target.ScanLine[i]);
   r.maxw := target.Width;
   r.maxh := target.Height;
   r.w := (r.x2 - r.x1);
   r.h := (r.y2 - r.y1);
   SetLength(pptr1, Max(abs(r.x2s-r.x1s), abs(r.y2s-r.y1s)) + 1);
   SetLength(pptr2, Max(abs(r.x3s-r.x1s), abs(r.y3s-r.y1s)) + 1);
   r.ptr1 := integer(pptr1);
   r.ptr2 := integer(pptr2);
   r.ptrscanline1 := integer(ptrscanline1);
   r.ptrscanline2 := integer(ptrscanline2);
   MakeArray(r.x1s, r.x2s, r.y1s, r.y2s, r.w, @r.ww, pptr1);
   MakeArray(r.x1s, r.x3s, r.y1s, r.y3s, r.h, @r.hh, pptr2);
   Result := true;
   try
     StretchArea(r, integer(@ErrorX), integer(@ErrorY));
   except
     on EAccessViolation do
     begin
       beep;
       ErrorX := pptr1[ErrorX div 12].cor;
       ErrorY := pptr2[ErrorY div 12].cor;
       Result := false;
     end;
   end;
end;
end;

procedure TStretchBitmap.MakeArray(X1S, X2S, Y1S, Y2S, W: integer; WW_ptr, ptr: Pointer);
var
  WW: integer;
  WW_int_ptr: ^integer;
  h, place_1, place_2: integer;
  adder_x, adder_y: integer;
  base, sum_add, step, ptr1: integer;
label
  label1, label2, label3, label4, label5,
  label6, label7, label8, label9;
begin
  ptr1 := integer(ptr);
  WW_int_ptr := WW_ptr;
  asm
    push   eax
    push   ebx
    push   ecx
    push   edx
    push   esi
    push   edi
    pushf

    mov    ecx,1
    mov    edx,1
    mov    eax,X2S
    sub    eax,X1S     //eax = X1S - X2S
    cmp    eax,0
    jge    label1      //if eax >= 0 then goto label1
    neg    eax         //else reverse sign so that is positive
    mov    ecx,-1      //and mark that X1S - X2S is negative
label1:
    inc    eax
    mov    ebx,Y2S
    sub    ebx,Y1S
    cmp    ebx,0
    jge    label2
    neg    ebx
    mov    edx,-1
label2:
    inc    ebx
    mov    place_1,0
    mov    place_2,4
    cmp    eax,ebx
    jge    label3
    xchg   eax,ebx
    xchg   ecx,edx
    mov    place_1,4
    mov    place_2,0
label3:
    mov    h,ebx
    shl    eax,2
    mov    WW,eax
    shl    eax,1
    add    WW,eax
    shr    eax,3
    mov    adder_x,ecx
    mov    adder_y,edx
    shr    ebx,1
    xor    esi,esi
    mov    edi,ebx
    mov    ecx,ptr1
    add    ecx,place_1
    mov    edx,ptr1
    add    edx,place_2
    mov    esi,12
label4:
    mov    ebx,adder_x
    mov    dword ptr [ecx+esi],ebx
    mov    dword ptr [edx+esi],0
    add    edi,h
    cmp    edi,eax
    jl     label5
    mov    ebx,adder_y
    mov    dword ptr [edx+esi],ebx
    sub    edi,eax
label5:
    add    esi,12
    cmp    esi,WW
    jl     label4

    mov    edi,ptr1
    add    edi,8
    dec    eax
    mov    ebx,W
    xchg   eax,ebx                    {EAX = h êáé EBX = w}
    cmp    ebx,eax                    {óýãêñéóç w êáé h}
    jl     label6
    inc    eax                        {EAX = h = y2 - y1 + 1}
    inc    ebx                        {EBX = w = x2 - x1 + 1}
    mov    ecx,eax                    {áí w >= h ôüôå}
    shr    ecx,1
    mov    base,ecx                   {base = int(h/2)}
    mov    step,0                     {step = 0}
    mov    sum_add,eax                {sum_add = h}
    jmp    label7
label6:                                 {áí w <= h ôüôå}
    mov    ecx,ebx
    shr    ecx,1
    mov    base,ecx                   {base = int(w/2)}
    push   eax                        {áðïèÞêåõóç ôçò ôéìÞò h ôïõ EAX}
    xor    edx,edx                    {ï EDX:EAX ðñïåôïéìÜæåôáé ãéá
äéáßñåóç}
    div    ebx                        {äéáßñåóç EDX:EAX/EBX}
    mov    step,eax                   {step = EAX = int(h/w) (ôï áêÝñáéï
ìÝñïò ôçò äéáßñåóçò)}
    mov    sum_add,edx                {sum_add = EDX = h mod w (ôï õðüëïéðï
ôçò äéáßñåóçò)}
    pop    eax                        {áíÜêôçóç ôçò ôéìÞò h ôïõ EAX}
label7:
    xor    esi,esi                    {ESI = i = 0}
    mov    ecx,base                   {ECX = sum = base}
    mov    edx,0                      {EDX = level = 0}
    mov    eax,WW                     {EAX = limit}
label8:
    mov    dword ptr [edi+esi],edx    {ç array óôï offset i ðáßñíåé ôçí ôéìÞ
level}
    add    ecx,sum_add                {sum = sum + sum_add}
    add    edx,step                   {level = level + step}
    cmp    ecx,ebx
    jl     label9                     {áí sum >= w ôüôå}
    inc    edx                        {level = level + 1}
    sub    ecx,ebx                    {sum = sum - w}
label9:
    add    esi,12                      {i = i + 4 (äéüôé ôá ðåñéå÷üìåíá ôçò
array ôïðïèåôïýíôáé áíÜ 4 bytes}
    cmp    esi,WW
    jl     label8                       {áí i = limit ôüôå ôÝëïò ôçò
ñïõôßíáò}

    popf
    pop    edi
    pop    esi
    pop    edx
    pop    ecx
    pop    ebx
    pop    eax
  end;
  WW_int_ptr^ := WW;
end;

procedure TStretchBitmap.StretchArea(R: TRotateRec; ErrX, ErrY: integer);
var
  ptr_y, x_prev, y_prev, maxh4: integer;
label
  label1, label2, label3, label4, label5, label6, label7;
begin
  asm
    pushad
    pushf
    xor    ebx,ebx
    xor    ecx,ecx
    xor    edx,edx
    xor    edi,edi
    mov    eax,R.maxh      //takes the height of the target bitmap
    shl    eax,2           //multiply by 4
    mov    maxh4,eax       //maxh4 stores the height of the target bitmap x 4
label1:
    mov    y_prev,ebx      //y_prev takes the previous value of y correspondance in source bitmap
    mov    ebx,ErrY        //address of ErrY is loaded on ebx
    mov    dword ptr [ebx],edi   //index of array of y correspondances is stored in ErrY
    mov    ebx,R.ptr2      //array of y correspondances is loaded on ebx
    mov    eax,dword ptr [ebx+edi]     //eax takes the step in x axis
    mov    esi,dword ptr [ebx+edi+4]   //esi takes the step in y axis
    mov    ebx,dword ptr [ebx+edi+8]   //ebx takes the y correspondance in source bitmap
    push   edi         //push index of array of y correspondances in stack
    add    ecx,eax     //ecx is the x position in the target bitmap
    add    edx,esi     //ecx is the y position in the target bitmap
    test   eax,esi     //if steps in both axis is <> 0 then continue
    jz     label5      //else goto to label5
    push   ebx         //push y correspondance in source bitmap in stack
    push   ecx         //push x position in target bitmap in stack
    push   edx         //push y position in target bitmap in stack
    add    ecx,R.x1s   //ecx get the relative position in x axis of target bitmap
    shl    ecx,1       //ecx is doubled
    sub    ecx,eax     //step in x axis is subtrscted from ecx
                       //ecx now has the intermediate value of relative position
                       //in x axis of target bitmap, doubled so that it is an
                       //integer value
    add    edx,R.y1s {R.y1s}
    shl    edx,1
    sub    edx,esi     //the same as ecx, for the y axis of target bitmap
    add    ebx,y_prev  //add previous value of y correspondance in source bitmap to the present value
    shr    ebx,1       //divide ebx by 2, in order to find the intermediate value
    add    ebx,r.y1    //get the relative to y1 value
    shl    ebx,2       //multiply by 4, in order to get the index of the address of the line
    add    ebx,R.ptrscanline1  //ebx gets the array of the line adresses of the source bitmap
    mov    ebx,dword ptr [ebx]  //get the line address of the source bitmap
{    add    ebx,r.x1}     {8bit}
    mov    esi,r.x1       {24bit}  //esi = x1
    add    ebx,esi        {24bit}
    add    ebx,esi        {24bit}
    add    ebx,esi        {24bit}  //get the address of x1 in line array
    mov    ptr_y,ebx    //ptr_y is the address of x1 in source bitmap
    xor    ebx,ebx
    xor    esi,esi
label2:
    mov    x_prev,ebx  //x_prev takes the previous value of x correspondance in source bitmap
    mov    ebx,ErrX    //address of ErrX is loaded on ebx
    mov    dword ptr [ebx],esi  //index of array of x correspondances is stored in ErrX
    mov    ebx,R.ptr1  //array of y correspondances is loaded on ebx
    mov    eax,dword ptr[ebx+esi]  //eax takes the step in x axis
    mov    edi,dword ptr[ebx+esi+4]  //edi takes the step in y axis
    mov    ebx,dword ptr[ebx+esi+8]  //ebx takes the x correspondance in source bitmap
    add    ecx,eax
    add    ecx,eax     //ecx has the final x position of target bitmap, doubled
    add    edx,edi
    add    edx,edi     //edx has the final y position of target bitmap, doubled
    test   eax,edi     //if steps in both axis is <> 0 then continue
    jz     label4      //else goto label4
    push   ebx         //push x correspondance in source bitmap in stack
    push   ecx         //push final x position in target bitmap in stack
    push   edx         //push final y position in target bitmap in stack
    sub    edx,edi     //edx has the final intermediate y position, doubled
    shl    edx,1       //final intermediate y position, quadrupled
    cmp    edx,maxh4   //check if y position in target bitmap exceeds bitmap limits
    jge    label3      //if it exceeds then continue to next point
    sub    ecx,eax     //ecx has the final intermediate x position, doubled
    shr    ecx,1       //ecx has the final intermediate x position
    cmp    ecx,R.maxw  //check if x position in target bitmap exceeds bitmap limits
    jge    label3      //if it exceeds then continue to next point
    add    edx,R.ptrscanline2  //edx gets the array of the line adresses of the target bitmap
{    add    ecx,dword ptr [edx]}  {8bit}
    mov    edx,dword ptr [edx]    {24bit}  //get the line address of the target bitmap
    add    edx,ecx                {24bit}
    add    edx,ecx                {24bit}
    add    ecx,edx                {24bit}  //ecx = edx + 3 * ecx
    add    ebx,x_prev  //add previous value of x correspondance in source bitmap to the present value
    shr    ebx,1       //divide ebx by 2, in order to find the intermediate value
    mov    edx,ebx                {24bit}  //edx takes intermediate x position in source bitmap
    add    ebx,ebx                {24bit}  //ebx takes intermediate x position in source bitmap, doubled
    add    ebx,ptr_y   //ebx = (address of the source point) - edx

//    mov    bl,byte ptr [ebx]    //8bit
//    mov    byte ptr [ecx],bl    //8bit
    mov    al, byte ptr [ebx+edx]   //al gets the first byte of the 24bit source color
    mov    byte ptr [ecx], al       //the first byte of the 24bit source color is assigned to target bitmap
    mov    ax, word ptr [ebx+edx+1] //al gets the next 2 bytes of the 24bit source color
    mov    word ptr [ecx+1], ax     //the next 2 bytes of the 24bit source color are assigned to target bitmap
label3:
    pop    edx
    pop    ecx
    pop    ebx
label4:
    add    esi,12
    cmp    esi,R.ww
    jl     label2
    pop    edx
    pop    ecx
    pop    ebx
label5:
    push   ebx
    push   ecx
    push   edx
    add    ecx,R.x1s
    add    edx,R.y1s
    mov    edi,R.ptrscanline1
    xor    esi,esi
    add    ebx,r.y1
    shl    ebx,2
    mov    ebx,dword ptr [ebx+edi]
{    add    ebx,r.x1}       {8bit}
    mov    edi,r.x1         {24bit}
    add    ebx,edi          {24bit}
    add    ebx,edi          {24bit}
    add    ebx,edi          {24bit}
    mov    ptr_y,ebx
    mov    edi,R.ptrscanline2
label6:
    mov    ebx,ErrX
    mov    dword ptr [ebx],esi
    mov    ebx,R.ptr1
    add    ecx,dword ptr [ebx+esi]
    add    edx,dword ptr [ebx+esi+4]
    cmp    edx,R.maxh
    jge    label7
    cmp    ecx,R.maxw
    jge    label7
    mov    ebx,dword ptr [ebx+esi+8]
    mov    eax,ebx              {24bit}
    add    ebx,ebx              {24bit}
    add    ebx,ptr_y

{    mov    bl,byte ptr [ebx]}  {8bit}
    add    ebx,eax
    mov    eax,edx
    shl    eax,2
    mov    eax,dword ptr [eax+edi]
    add    eax,ecx
    add    eax,ecx             //24bit
    add    eax,ecx             //24bit
    push   ecx
    mov    cl,byte ptr [ebx] //24bit
    mov    byte ptr [eax],cl //24bit
    mov    cx,word ptr [ebx+1] //24bit
//    mov    byte ptr [eax],bl //8bit
    mov    word ptr [eax+1],cx //24bit
    pop    ecx
label7:
    add    esi,12
    cmp    esi,R.ww
    jl     label6
    pop    edx
    pop    ecx
    pop    ebx
    pop    edi
    add    edi,12
    cmp    edi,R.hh
    jl     label1
    popf
    popad
  end;
end;

function TStretchBitmap.StretchIt: Boolean;
var
  sr: TRect;
  res: Boolean;
begin
  if SourceBitmap = nil then
  begin
    MessageDlg('No source bitmap.', mtError, [mbOk], 0);
    exit;
  end;
  if TargetBitmap = nil then
  begin
    MessageDlg('No target bitmap.', mtError, [mbOk], 0);
    exit;
  end;
  if SourceBitmap = TargetBitmap then
  begin
    MessageDlg('Source and Target bitmaps cannot be the same.', mtError, [mbOk], 0);
    exit;
  end;
  if (SourceBitmap.PixelFormat <> pf24bit) or (TargetBitmap.PixelFormat <> pf24bit) then
  begin
//    MessageDlg('Both bitmaps must be 24bit.', mtError, [mbOk], 0);
    exit;
  end;
  StretchHeader.SourcePlane.PlaneType := ptOrthogonal;
  StretchHeader.TargetPlane.PlaneType := ptStretched;
  if not CheckPlane(StretchHeader.SourcePlane) then exit;
  sr := Rect(0, 0, SourceBitmap.Width, SourceBitmap.Height);
  with StretchHeader.SourcePlane do
    if not (PtInRect(sr, Origin) and PtInRect(sr, X_Axis) and PtInRect(sr, Y_Axis)) then
    begin
//      MessageDlg('Source plane out of bitmap bounds.', mtError, [mbOk], 0);
      exit;
    end;
  if ResizeTargetBitmap then
  begin
    TargetBitmap.Width := 0;
    TargetBitmap.Height := 0;
  end;
  AdjustTargetPlaneToBitmap;
  R.x1 := StretchHeader.SourcePlane.Origin.x;
  R.y1 := StretchHeader.SourcePlane.Origin.y;
  R.x2 := StretchHeader.SourcePlane.X_Axis.x;
  R.y2 := StretchHeader.SourcePlane.Y_Axis.y;
  R.x1s := StretchHeader.TargetPlane.Origin.x;
  R.y1s := StretchHeader.TargetPlane.Origin.y;
  R.x2s := StretchHeader.TargetPlane.X_Axis.x;
  R.y2s := StretchHeader.TargetPlane.X_Axis.y;
  R.x3s := StretchHeader.TargetPlane.Y_Axis.x;
  R.y3s := StretchHeader.TargetPlane.Y_Axis.y;
  TargetBitmap.Canvas.Brush.Color := BackgroundColor;
  sr := Rect(0, 0, TargetBitmap.Width, TargetBitmap.Height);
  TargetBitmap.Canvas.FillRect(sr);
  Result := StretchBitm(SourceBitmap, TargetBitmap, R);
  if Result then
  begin
    ErrorX := 0;
    ErrorY := 0;
  end;
end;

function TStretchBitmap.CheckPlane(pl: TPlane): Boolean;
begin
  if pl.PlaneType = ptOrthogonal then
  begin
    if (pl.X_Axis.y <> pl.Origin.y) or (pl.Y_Axis.x <> pl.Origin.x) then
    begin
      MessageDlg('Othogonal plane not properly set.', mtError, [mbOk], 0);
      CheckPlane := false;
      exit;
    end;
  end;
  CheckPlane := true;
end;

procedure TStretchBitmap.AdjustTargetPlaneToBitmap;
var
  p4, maxp, minp, dims: TPoint;
begin
if (SourceBitmap<>nil) and (TargetBitmap<>nil) then begin
  with StretchHeader.TargetPlane do
  begin
    p4.x := X_Axis.x + Y_Axis.x - Origin.x;
    p4.y := X_Axis.y + Y_Axis.y - Origin.y;
    maxp.x := MaxIntValue([X_Axis.x, Y_Axis.x, Origin.x, p4.x]);
    maxp.y := MaxIntValue([X_Axis.y, Y_Axis.y, Origin.y, p4.y]);
    minp.x := MinIntValue([X_Axis.x, Y_Axis.x, Origin.x, p4.x]);
    minp.y := MinIntValue([X_Axis.y, Y_Axis.y, Origin.y, p4.y]);
    Origin.x := Origin.x - minp.x;
    Origin.y := Origin.y - minp.y;
    X_Axis.x := X_Axis.x - minp.x;
    X_Axis.y := X_Axis.y - minp.y;
    Y_Axis.x := Y_Axis.x - minp.x;
    Y_Axis.y := Y_Axis.y - minp.y;
    dims.x := maxp.x - minp.x + 1;
    dims.y := maxp.y - minp.y + 1;
  end;
  if ResizeTargetBitmap then
  begin
    TargetBitmap.Width := dims.x;
    TargetBitmap.Height := dims.y;
  end;
end;
end;

function TStretchBitmap.RotateIt(RotationAngle: Single): Boolean;
var
  pnew: TPoint;
  rad, sinf, cosf: Double;
begin
if (SourceBitmap<>nil) and (TargetBitmap<>nil) then begin
  rad := - Pi * RotationAngle / 180;
  sinf := Sin(rad);
  cosf := Cos(rad);
  StretchHeader.SourcePlane.Origin := Point(0, 0);
  StretchHeader.SourcePlane.X_Axis := Point(SourceBitmap.Width - 1, 0);
  StretchHeader.SourcePlane.Y_Axis := Point(0, SourceBitmap.Height - 1);
  StretchHeader.TargetPlane.Origin := Point(0, 0);
  pnew.x := trunc((SourceBitmap.Width - 1) * cosf + 0.5);
  pnew.y := trunc((SourceBitmap.Width - 1) * sinf + 0.5);
  StretchHeader.TargetPlane.X_Axis := pnew;
  pnew.x := -trunc((SourceBitmap.Height - 1) * sinf + 0.5);
  pnew.y := trunc((SourceBitmap.Height - 1) * cosf + 0.5);
  StretchHeader.TargetPlane.Y_Axis := pnew;
  Result := StretchIt;
end;
end;

{ A cél bitmap-et úgy nagyítja, hogy az elforgatott téglalap befoglalója legyen }
function TStretchBitmap.RotateIt(RotationAngle,Magnify: double): Boolean;
var
  pnew: TPoint;
  rad, sinf, cosf: Double;
begin
if (SourceBitmap<>nil) and (TargetBitmap<>nil) then begin
  rad := - Pi * RotationAngle / 180;
  sinf := Sin(rad);
  cosf := Cos(rad);
  StretchHeader.SourcePlane.Origin := Point(0, 0);
  StretchHeader.SourcePlane.X_Axis := Point(SourceBitmap.Width - 1, 0);
  StretchHeader.SourcePlane.Y_Axis := Point(0, SourceBitmap.Height - 1);
  StretchHeader.TargetPlane.Origin := Point(0, 0);
  pnew.x := trunc(Magnify*(SourceBitmap.Width - 1) * cosf + 0.5);
  pnew.y := trunc(Magnify*(SourceBitmap.Width - 1) * sinf + 0.5);
  StretchHeader.TargetPlane.X_Axis := pnew;
  pnew.x := -trunc(Magnify*(SourceBitmap.Height - 1) * sinf + 0.5);
  pnew.y := trunc(Magnify*(SourceBitmap.Height - 1) * cosf + 0.5);
  StretchHeader.TargetPlane.Y_Axis := pnew;
  Result := StretchIt;
end;
end;

procedure TStretchBitmap.TransBMP
            ( src,dst  : TBitmap;
              srcRect  : TRect;
              Cent     : TPoint2d;
              Zoom     : double;
              RotAngle : double);
var R: TRotateRec;
    T: TTeglalap;
begin
  // Cél paralelogramma elforgatva, nagyítva
  T := RotateTegla(Cent,Zoom*(srcRect.Right-srcRect.Left),
                         Zoom*(srcRect.Bottom-srcRect.Top),RotAngle);
//  DrawTegla(dst.Canvas,T);
  R.x1:= srcRect.Left;
  R.y1:= srcRect.Top;
  R.x2:= srcRect.Right;
  R.Y2:= srcRect.Bottom;
  R.w := 0;
  R.H := 0;
  R.x1s:= Round(T.a.x);
  R.y1s:= Round(T.a.y);
  R.x2s:= Round(T.b.x);
  R.y2s:= Round(T.b.y);
  R.x3s:= Round(T.d.x);
  R.y3s:= Round(T.d.y);
  StretchBitm(src,dst,R);
end;

function TStretchBitmap.SkewIt(Horizontally, Vertically: Single): Boolean;
var
  pnew: TPoint;
begin
if (SourceBitmap<>nil) and (TargetBitmap<>nil) then begin
  StretchHeader.SourcePlane.Origin := Point(0, 0);
  StretchHeader.SourcePlane.X_Axis := Point(SourceBitmap.Width - 1, 0);
  StretchHeader.SourcePlane.Y_Axis := Point(0, SourceBitmap.Height - 1);
  StretchHeader.TargetPlane.Origin := Point(0, 0);
  pnew.x := SourceBitmap.Width - 1;
  pnew.y := trunc((SourceBitmap.Height - 1) * Vertically / 100 + 0.5);
  StretchHeader.TargetPlane.X_Axis := pnew;
  pnew.x := trunc( - (SourceBitmap.Width - 1) * Horizontally / 100 + 0.5);
  pnew.y := SourceBitmap.Height - 1;
  StretchHeader.TargetPlane.Y_Axis := pnew;
  Result := StretchIt;
end;
end;

constructor TStretchBitmap.Create;
begin
  StretchHeader.SourcePlane.PlaneType := ptOrthogonal;
  StretchHeader.TargetPlane.PlaneType := ptStretched;
  ResizeTargetBitmap := True;
  BackgroundColor := clBlack;
//  SourceBitmap := TBitMap.Create;
//  TargetBitmap := TBitMap.Create;
//  SourceBitmap.PixelFormat := pf24bit;
//  TargetBitmap.PixelFormat := pf24bit;
end;

destructor TStretchBitmap.Destroy;
begin
//  SourceBitmap.Free;
//  TargetBitmap.Free;
end;

procedure TStretchBitmap.SetBackgroundColor(const Value: TColor);
begin
  FBackgroundColor := Value;
end;

// ============== ROTATE BITMAP =========================

// Creates rotated bitmap of the specified bitmap.
function CreateRotatedBitmap(Bitmap: TBitmap; const Angle: Extended; bgColor: TColor): TBitmap;
type
  PRGBQuadArray = ^TRGBQuadArray;
  TRGBQuadArray = array[0..0] of TRGBQuad;
var
  bgRGB: TRGBQuad;
  NormalAngle: Extended;
  CosTheta, SinTheta: Extended;
  iCosTheta, iSinTheta: Integer;
  xSrc, ySrc: Integer;
  xDst, yDst: Integer;
  xODst, yODst: Integer;
  xOSrc, yOSrc: Integer;
  xPrime, yPrime: Integer;
  srcWidth, srcHeight: Integer;
  dstWidth, dstHeight: Integer;
  yPrimeSinTheta, yPrimeCosTheta: Integer;
  srcRGBs: PRGBQuadArray;
  dstRGBs: PRGBQuadArray;
  dstRGB: PRGBQuad;
  BitmapInfo: TBitmapInfo;
  srcBMP, dstBMP: HBITMAP;
  DC: HDC;
begin
  { Converts bgColor to true RGB Color }
  bgColor := ColorToRGB(bgColor);
  with bgRGB do
  begin
    rgbRed := Byte(bgColor);
    rgbGreen := Byte(bgColor shr 8);
    rgbBlue := Byte(bgColor shr 16);
    rgbReserved := Byte(bgColor shr 24);
  end;

  { Calculates Sine and Cosine of the rotation angle }
  NormalAngle := Frac(Angle / 360.0) * 360.0;
  SinCos(Pi * -NormalAngle / 180, SinTheta, CosTheta);
  iSinTheta := Trunc(SinTheta * (1 shl 16));
  iCosTheta := Trunc(CosTheta * (1 shl 16));

  { Prepares the required data for the source bitmap }
  srcBMP := Bitmap.Handle;
  srcWidth := Bitmap.Width;
  srcHeight := Bitmap.Height;
  xOSrc := srcWidth shr 1;
  yOSrc := srcHeight shr 1;

  { Prepares the required data for the target bitmap }
  dstWidth := SmallInt((srcWidth * Abs(iCosTheta) + srcHeight * Abs(iSinTheta)) shr 16);
  dstHeight := SmallInt((srcWidth * Abs(iSinTheta) + srcHeight * Abs(iCosTheta)) shr 16);
  xODst := dstWidth shr 1;
  if not Odd(dstWidth) and ((NormalAngle = 0.0) or (NormalAngle = -90.0)) then
    Dec(xODst);
  yODst := dstHeight shr 1;
  if not Odd(dstHeight) and ((NormalAngle = 0.0) or (NormalAngle = +90.0)) then
    Dec(yODst);

  // Initializes bitmap header
  FillChar(BitmapInfo, SizeOf(BitmapInfo), 0);
  with BitmapInfo.bmiHeader do
  begin
    biSize := SizeOf(BitmapInfo.bmiHeader);
    biCompression := BI_RGB;
    biBitCount := 32;
    biPlanes := 1;
  end;

  // Get source and target RGB bits
  DC := CreateCompatibleDC(0);
  try
    BitmapInfo.bmiHeader.biWidth := srcWidth;
    BitmapInfo.bmiHeader.biHeight := srcHeight;
    GetMem(srcRGBs, srcWidth * srcHeight * SizeOf(TRGBQuad));
    GdiFlush;
    GetDIBits(DC, srcBMP, 0, srcHeight, srcRGBS, BitmapInfo, DIB_RGB_COLORS);
    BitmapInfo.bmiHeader.biWidth := dstWidth;
    BitmapInfo.bmiHeader.biHeight := dstHeight;
    dstBMP := CreateDIBSection(DC, BitmapInfo, DIB_RGB_COLORS, Pointer(dstRGBs), 0, 0);
  finally
    DeleteDC(DC);
  end;

  { Pefroms rotation on RGB bits }
  dstRGB := @dstRGBs[(dstWidth * dstHeight) - 1];
  yPrime := yODst;
  for yDst := dstHeight - 1 downto 0 do
  begin
    yPrimeSinTheta := yPrime * iSinTheta;
    yPrimeCosTheta := yPrime * iCosTheta;
    xPrime := xODst;
    for xDst := dstWidth - 1 downto 0 do
    begin
      xSrc := SmallInt((xPrime * iCosTheta - yPrimeSinTheta) shr 16) + xOSrc;
      ySrc := SmallInt((xPrime * iSinTheta + yPrimeCosTheta) shr 16) + yOSrc;
      {$IFDEF COMPILER4_UP}
      if (DWORD(ySrc) < DWORD(srcHeight)) and (DWORD(xSrc) < DWORD(srcWidth)) then
      {$ELSE} // Delphi 3 compiler ignores unsigned type cast and generates signed comparison code!
      if (ySrc >= 0) and (ySrc < srcHeight) and (xSrc >= 0) and (xSrc < srcWidth) then
      {$ENDIF}
        dstRGB^ := srcRGBs[ySrc * srcWidth + xSrc]
      else
        dstRGB^ := bgRGB;
      Dec(dstRGB);
      Dec(xPrime);
    end;
    Dec(yPrime);
  end;

  { Releases memory for source bitmap RGB bits }
  FreeMem(srcRGBs);

  { Create result bitmap }
  Result := TBitmap.Create;
  Result.Handle := dstBMP;
end;

Procedure RotateBitmap( SourceBitmap : TBitmap; out DestBitmap : TBitmap;
                        Center : TPoint; Angle : Double) ;
Var
   cosRadians : Double;
   inX : Integer;
   inXOriginal : Integer;
   inXPrime : Integer;
   inXPrimeRotated : Integer;
   inY : Integer;
   inYOriginal : Integer;
   inYPrime : Integer;
   inYPrimeRotated : Integer;
   OriginalRow : pPixelArray;
   Radians : Double;
   RotatedRow : pPixelArray;
   sinRadians : Double;
begin
   DestBitmap.Width := SourceBitmap.Width;
   DestBitmap.Height := SourceBitmap.Height;
   DestBitmap.PixelFormat := pf24bit;
   Radians := -(Angle) * PI / 180;
   sinRadians := Sin(Radians) ;
   cosRadians := Cos(Radians) ;
   For inX := DestBitmap.Height-1 Downto 0 Do
   Begin
     RotatedRow := DestBitmap.Scanline[inX];
     inXPrime := 2*(inX - Center.y) + 1;
     For inY := DestBitmap.Width-1 Downto 0 Do
     Begin
       inYPrime := 2*(inY - Center.x) + 1;
       inYPrimeRotated := Round(inYPrime * CosRadians - inXPrime * sinRadians) ;
       inXPrimeRotated := Round(inYPrime * sinRadians + inXPrime * cosRadians) ;
       inYOriginal := (inYPrimeRotated - 1) Div 2 + Center.x;
       inXOriginal := (inXPrimeRotated - 1) Div 2 + Center.y;
       If
         (inYOriginal >= 0) And
         (inYOriginal <= SourceBitmap.Width-1) And
         (inXOriginal >= 0) And
         (inXOriginal <= SourceBitmap.Height-1)
       Then
       Begin
         OriginalRow := SourceBitmap.Scanline[inXOriginal];
         RotatedRow[inY] := OriginalRow[inYOriginal]
       End
       Else
       Begin
         RotatedRow[inY].rgbtBlue := 100;
         RotatedRow[inY].rgbtGreen := 100;
         RotatedRow[inY].rgbtRed := 100
       End;
     End;
   End;
   SourceBitmap.Assign(DestBitmap);
End;

// ============== END ROTATE BITMAP =========================

procedure AntiAlias(clip: tbitmap);
begin
AntiAliasRect(clip,0,0,clip.width,clip.height);
end;

procedure AntiAliasRect(clip: tbitmap; XOrigin, YOrigin,
  XFinal, YFinal: Integer);
var Memo,x,y: Integer; (* Composantes primaires des points environnants *)
    p0,p1,p2:pbytearray;

begin
   if XFinal<XOrigin then begin Memo:=XOrigin; XOrigin:=XFinal; XFinal:=Memo; end;  (* Inversion des valeurs   *)
   if YFinal<YOrigin then begin Memo:=YOrigin; YOrigin:=YFinal; YFinal:=Memo; end;  (* si diff‚rence n‚gative*)
   XOrigin:=max(1,XOrigin);
   YOrigin:=max(1,YOrigin);
   XFinal:=min(clip.width-2,XFinal);
   YFinal:=min(clip.height-2,YFinal);
   clip.PixelFormat :=pf24bit;
   for y:=YOrigin to YFinal do begin
    p0:=clip.ScanLine [y-1];
    p1:=clip.scanline [y];
    p2:=clip.ScanLine [y+1];
    for x:=XOrigin to XFinal do begin
      p1[x*3]:=(p0[x*3]+p2[x*3]+p1[(x-1)*3]+p1[(x+1)*3])div 4;
      p1[x*3+1]:=(p0[x*3+1]+p2[x*3+1]+p1[(x-1)*3+1]+p1[(x+1)*3+1])div 4;
      p1[x*3+2]:=(p0[x*3+2]+p2[x*3+2]+p1[(x-1)*3+2]+p1[(x+1)*3+2])div 4;
      end;
   end;
end;


procedure Sepia ( Bitmap:TBitmap;depth:byte);
var
Row:^TRGBTriple;
H,V:Integer;
begin
 Bitmap.PixelFormat:=pf24bit;
 for V:=0 to Bitmap.Height-1 do
  begin
    Row:=Bitmap.ScanLine[V];
    for H:=0 to Bitmap.Width -1 do
    begin
      Row.rgbtBlue :=(Row.rgbtBlue +Row.rgbtGreen +Row.rgbtRed)div 3;
      Row.rgbtGreen:=Row.rgbtBlue;
      Row.rgbtRed  :=Row.rgbtBlue;
      inc(Row.rgbtRed,depth*2); //dodane wartosci
      inc(Row.rgbtGreen,depth);
      if Row.rgbtRed < (depth*2) then Row.rgbtRed:=255;
      if  Row.rgbtGreen < (depth) then Row.rgbtGreen:=255;
      inc(Row);
    end;
  end;
end;

Procedure Blur( var Bitmap :TBitmap);
var
   TL,TC,TR,BL,BC,BR,LL,LC,LR:^TRGBTriple;
   H,V:Integer;
begin
     Bitmap.PixelFormat :=pf24bit;
for V := 1 to Bitmap.Height - 2 do
begin
TL:= Bitmap.ScanLine[V - 1];
TC:=TL;    // to samo Scanline  Bitmap.ScanLine[V - 1]; tylko oszczêdniej
TR:=TL;
BL:= Bitmap.ScanLine[V];
BC:=BL;
BR:=BL;
LL:= Bitmap.ScanLine[V + 1];
LC:=LL;
LR:=LL;
inc(TC); inc(TR,2);
inc(BC); inc(BR,2);
inc(LC); inc(LR,2);

for H := 1 to (Bitmap.Width  - 2) do
begin
//Wyci¹gam sredni¹ z 9 s¹siaduj¹cych pixeli
  BC.rgbtRed:= (BC.rgbtRed+ BL.rgbtRed+BR.rgbtRed+
  TC.rgbtRed+ TL.rgbtRed+TR.rgbtRed+
  LL.rgbtRed+ LC.rgbtRed+LR.rgbtRed) div 9 ;

  BC.rgbtGreen:=( BC.rgbtGreen+ BL.rgbtGreen+BR.rgbtGreen+
  TC.rgbtGreen+ TL.rgbtGreen+TR.rgbtGreen+
  LL.rgbtGreen+ LC.rgbtGreen+LR.rgbtGreen) div 9 ;

  BC.rgbtBlue:=( BC.rgbtBlue+ BL.rgbtBlue+BR.rgbtBlue+
  TC.rgbtBlue+ TL.rgbtBlue+TR.rgbtBlue+
  LL.rgbtBlue+ LC.rgbtBlue+LR.rgbtBlue )div 9 ;
//zwiêkszam wskaŸniki bior¹c nastêpne 9 pixeli
  inc(TL);inc(TC);inc(TR);
  inc(BL);inc(BC);inc(BR);
  inc(LL);inc(LC);inc(LR);
    end;
  end;
end;

procedure SplitBlur(var clip: tbitmap; Amount: integer);
var
p0,p1,p2:pbytearray;
cx,i,x,y: Integer;
Buf:   array[0..3,0..2]of byte;
begin
  if Amount=0 then Exit;
  for y:=0 to clip.Height-1 do
  begin
    p0:=clip.scanline[y];
    if y-Amount<0         then p1:=clip.scanline[y]
    else {y-Amount>0}          p1:=clip.ScanLine[y-Amount];
    if y+Amount<clip.Height    then p2:=clip.ScanLine[y+Amount]
    else {y+Amount>=Height}    p2:=clip.ScanLine[clip.Height-y];

    for x:=0 to clip.Width-1 do
    begin
      if x-Amount<0     then cx:=x
      else {x-Amount>0}      cx:=x-Amount;
      Buf[0,0]:=p1[cx*3];
      Buf[0,1]:=p1[cx*3+1];
      Buf[0,2]:=p1[cx*3+2];
      Buf[1,0]:=p2[cx*3];
      Buf[1,1]:=p2[cx*3+1];
      Buf[1,2]:=p2[cx*3+2];
      if x+Amount<clip.Width     then cx:=x+Amount
      else {x+Amount>=Width}     cx:=clip.Width-x;
      Buf[2,0]:=p1[cx*3];
      Buf[2,1]:=p1[cx*3+1];
      Buf[2,2]:=p1[cx*3+2];
      Buf[3,0]:=p2[cx*3];
      Buf[3,1]:=p2[cx*3+1];
      Buf[3,2]:=p2[cx*3+2];
      p0[x*3]:=(Buf[0,0]+Buf[1,0]+Buf[2,0]+Buf[3,0])shr 2;
      p0[x*3+1]:=(Buf[0,1]+Buf[1,1]+Buf[2,1]+Buf[3,1])shr 2;
      p0[x*3+2]:=(Buf[0,2]+Buf[1,2]+Buf[2,2]+Buf[3,2])shr 2;
    end;
  end;
end;

procedure GaussianBlur(var clip: tbitmap; Amount: integer);
var
i: Integer;
begin
  for i:=Amount downto 0 do
  SplitBlur(clip,3);
end;

procedure Lightness( Bitmap:TBitmap; Amount: Integer);
var
Wsk:^Byte;
H,V: Integer;
begin
  Bitmap.PixelFormat:=Graphics.pf24bit;
  for V:=0 to Bitmap.Height-1 do
  begin
    Wsk:=Bitmap.ScanLine[V];
    for H:=0 to Bitmap.Width*3-1 do
    begin
    Wsk^:=IntToByte(Wsk^+((255-Wsk^)*Amount)div 255);
    inc(Wsk);
    end;
  end;
end;

// Brighten or Darken (-255..0..+255)
procedure Brightness( Bitmap:TBitmap; Amount: integer);
begin
  If Amount>=0 then
     Lightness(Bitmap,Amount)
  else
     Darkness(Bitmap,-Amount);
end;

function ShowBaloonHint(Point: TPoint; Handle: THandle; Title: String;
Msg: String; Icon: Integer): Boolean;
var
  hwnd: THandle;
  ti: TToolInfo;
  hCursor: THandle;
  Rect: TRect;
  IconData: TNotifyIconData;

const
  TTS_BALLOON = $40;
  TTS_CLOSE = $80;

  procedure SetToolTipTitle(tt: THandle; IconType: Integer; Title: string);
  var
    buffer: array[0..255] of Char;
  const
    TTM_SETTITLE = (WM_USER + 32);
  begin
    FillChar(buffer, SizeOf(buffer), #0);
    lstrcpy(buffer, PChar(Title));
    SendMessage(tt, TTM_SETTITLE, IconType, Integer(@buffer));
  end;

begin
  hwnd:= CreateWindowEx(0,
                        TOOLTIPS_CLASS,
                        nil,
                        TTS_ALWAYSTIP or TTS_BALLOON or TTS_CLOSE,
                        CW_USEDEFAULT,
                        CW_USEDEFAULT,
                        CW_USEDEFAULT,
                        CW_USEDEFAULT,
                        Application.MainForm.Handle,
                        0,
                        Application.Handle,
                        0);

  SetWindowPos( hwnd,
                HWND_TOPMOST,
                0,
                0,
                0,
                0,
                SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);

  GetClientRect(Handle, Rect);

  with ti do
    begin
      cbSize:= Sizeof(TToolInfo);
      uFlags:= TTF_TRACK;
      hwnd:= Handle;
      hInst:= Application.Handle;
      uId:= Handle;
      lpszText:= PChar(Msg);
    end;

  ti.Rect.Left:= Rect.Left;
  ti.Rect.Top:= Rect.Top;
  ti.Rect.Right:= Rect.Right;
  ti.Rect.Bottom:= Rect.Bottom;

  SendMessage(hwnd,TTM_ADDTOOL,1,Integer(@ti));
  SetToolTipTitle(hwnd,Icon,Title);

  SendMessage(hwnd, TTM_TRACKPOSITION, 0, MakeLParam(Point.x,Point.y));

  SendMessage(hwnd, TTM_TRACKACTIVATE, Integer(True), Integer(@ti));
end; 

procedure DrawShape(Canv: TCanvas; DrawingTool:TDrawingTool; T,B: TPoint;
           AMode: TPenMode);
begin
    Canv.Pen.Mode := AMode;
    If (T.X<>B.x) OR (T.Y<>B.Y) then
    begin
    case DrawingTool of
      dtPoint: Canv.Rectangle(T.X-1,T.Y-1,T.X+1,T.Y+1);
      dtLine: begin
                Canv.MoveTo(T.X, T.Y);
                Canv.LineTo(B.X, B.Y);
              end;
      dtRectangle: begin
           Canv.Rectangle(T.X, T.Y, B.X, B.Y);
           end;
      dtEllipse:   Canv.Ellipse(T.X, T.Y, B.X, B.Y);
      dtRoundRect: Canv.RoundRect(T.X, T.Y, B.X, B.Y,
        (T.X - B.X) div 2, (T.Y - B.Y) div 2);
    end;
    case DrawingTool of
      dtFillRect: begin
        Canv.Rectangle(T.X, T.Y, B.X, B.Y);
        end;
      dtFillEllipse: begin
        Canv.Ellipse(T.X, T.Y, B.X, B.Y);
        end;
      dtFillRoundRect: begin
        Canv.RoundRect(T.X, T.Y, B.X, B.Y,
        (T.X - B.X) div 2, (T.Y - B.Y) div 2);
        end;
    end;
    end;
    Canv.Refresh;
end;


// Fade out the image: Elhalványítja a képet
procedure FadeOut(const Bmp: TImage; Pause: Integer);
var
  BytesPorScan, counter, w, h: Integer;
  p: pByteArray;
begin
if not (Bmp.Picture.Bitmap.Empty) then begin
  if not (Bmp.Picture.Bitmap.PixelFormat in [pf24Bit, pf32Bit]) then
     Bmp.Picture.Bitmap.PixelFormat := pf24Bit;
//    raise Exception.Create('Error, bitmap format is not supporting.');
  try
    BytesPorScan := Abs(Integer(Bmp.Picture.Bitmap.ScanLine[1]) -
      Integer(Bmp.Picture.Bitmap.ScanLine[0]));
  except
    raise Exception.Create('Error!!');
  end;

  for counter := 1 to 256 do
  begin
    for h := 0 to Bmp.Picture.Bitmap.Height - 1 do
    begin
      P := Bmp.Picture.Bitmap.ScanLine[h];
      for w := 0 to BytesPorScan - 1 do
        if P^[w] > 0 then P^[w] := P^[w] - 1;
    end;
    Sleep(Pause);
    Bmp.Refresh;
  end;
end;
end;

procedure DrawCentralCross(Ca: TCanvas; cPen: Tpen);
var R: TRect;
begin
  With Ca do begin
    R := Ca.ClipRect;
    Pen.Assign(cPen);
    MoveTo((R.Left+R.Right) div 2,R.Top);
    LineTo((R.Left+R.Right) div 2,R.Bottom);
    MoveTo(R.Left,(R.Top+R.Bottom) div 2);
    LineTo(R.Right,(R.Top+R.Bottom) div 2);
  end;
end;

// Deletes the False chanels
procedure ChangeRGBChanel(Bitmap : TBitmap; RCh,GCh,BCh: boolean);
var
   Row:^TRGBTripleArray;
   i,j:Integer;
begin
If (Bitmap<>nil) and (not Bitmap.Empty) then begin
TRY
  Bitmap.PixelFormat := pf24bit;
  FOR j := 0 TO Bitmap.Height-1 DO
  BEGIN
    Row := Bitmap.Scanline[j];
    FOR i := 0 TO Bitmap.Width-1 DO
      WITH Row[i] DO
      BEGIN
        if not RCh then rgbtRed := 0;
        if not GCh then rgbtGreen := 0;
        if not BCh then rgbtBlue := 0;
      END
  END;
FINALLY
END;
end;
end;

// Change the RGB chanels to monochrome, and set the visibility of rgb chanels
procedure ChangeRGBChanel(Bitmap : TBitmap; Mono,RCh,GCh,BCh: boolean);
var
   Row:^TRGBTripleArray;
   i,j:Integer;
   v: integer;
begin
  if Mono then
     ChangeRGBChanelToMonochrome(Bitmap,RCh,GCh,BCh)
  else
     ChangeRGBChanel(Bitmap,RCh,GCh,BCh);
end;

// Change the RGB chanels to monochrome
procedure ChangeRGBChanelToMonochrome(Bitmap : TBitmap; RCh,GCh,BCh: boolean);
var
   Row:^TRGBTripleArray;
   i,j,v:Integer;
begin
If (Bitmap<>nil) and (not Bitmap.Empty) then begin
  Bitmap.PixelFormat := pf24bit;
  FOR j := 0 TO Bitmap.Height-1 DO
  BEGIN
    Row := Bitmap.Scanline[j];
    FOR i := 0 TO Bitmap.Width-1 DO
      WITH Row[i] DO
      BEGIN
        if RCh and GCh and BCh then begin
           v := (rgbtRed+rgbtGreen+rgbtBlue) div 3;
           rgbtRed   := v;
           rgbtGreen := v;
           rgbtBlue  := v;
        end;
//         else begin
        if RCh then begin
           rgbtGreen := rgbtRed;
           rgbtBlue := rgbtRed;
        end;
        if GCh then begin
           rgbtRed := rgbtGreen;
           rgbtBlue := rgbtGreen;
        end;
        if BCh then begin
           rgbtRed := rgbtBlue;
           rgbtGreen := rgbtBlue;
        end;
//        end;
      END
  END;
end;
end;

    function AbovePass(var vol: byte; amount: byte):byte;
    begin
      if vol >= amount then vol:=$FF else vol:=0;
    end;

    function BelowPass(var vol: byte; amount: byte):byte;
    begin
      if vol <= amount then vol:=$FF else vol:=0;
    end;

    function EqualPass(var vol: byte; amount: byte):byte;
    begin
      if vol = amount then vol:=$FF else vol:=0;
    end;


// Remains only those pixels has a value abova (>=) then amount
procedure HighPass(Bitmap: TBitmap; R,G,B: byte);
var x,y:integer;
   Row:^TRGBTripleArray;

    function SliceOfByte(var vol: byte; amount: byte):byte;
    begin
      if vol <= amount then vol:=0;
    end;

begin
  Bitmap.PixelFormat := pf24bit;
  for y:=0 to Bitmap.height-1 do begin
    Row:=Bitmap.scanline[y];
    for x:=0 to Bitmap.width-1 do begin
      WITH Row[x] DO
      BEGIN
        SliceOfByte(rgbtRed,R);
        SliceOfByte(rgbtGreen,G);
        SliceOfByte(rgbtBlue,B);
      END
    end;
  end;
end;

// Remains only those pixels has a value abova (>=) then amount
procedure LowPass(Bitmap: TBitmap; R,G,B: byte);
var x,y:integer;
   Row:^TRGBTripleArray;

    function SliceOfByte(var vol: byte; amount: byte):byte;
    begin
      if vol >= amount then vol:=0;
    end;

begin
  Bitmap.PixelFormat := pf24bit;
  for y:=0 to Bitmap.height-1 do begin
    Row:=Bitmap.scanline[y];
    for x:=0 to Bitmap.width-1 do begin
      WITH Row[x] DO
      BEGIN
        SliceOfByte(rgbtRed,R);
        SliceOfByte(rgbtGreen,G);
        SliceOfByte(rgbtBlue,B);
      END
    end;
  end;
end;

// Remains only those pixels has a value abova (>=) then amount
procedure HighPassEx(Bitmap: TBitmap; amount:integer);
var x,y:integer;
    Row:^TRGBTripleArray;
begin
  Bitmap.PixelFormat := pf24bit;
  for y:=0 to Bitmap.height-1 do begin
    Row:=Bitmap.scanline[y];
    for x:=0 to Bitmap.width-1 do begin
      WITH Row[x] DO
      BEGIN
        AbovePass(rgbtRed,amount);
        AbovePass(rgbtGreen,amount);
        AbovePass(rgbtBlue,amount);
      END
    end;
  end;
end;

// Remains only those pixels has a value abova (>=) then amount
procedure LowPassEx(Bitmap: TBitmap; amount:integer);
var x,y:integer;
    Row:^TRGBTripleArray;
begin
  Bitmap.PixelFormat := pf24bit;
  for y:=0 to Bitmap.height-1 do begin
    Row:=Bitmap.scanline[y];
    for x:=0 to Bitmap.width-1 do begin
      WITH Row[x] DO
      BEGIN
        BelowPass(rgbtRed,amount);
        BelowPass(rgbtGreen,amount);
        BelowPass(rgbtBlue,amount);
      END
    end;
  end;
end;

// Remains only those pixels has a value abova (>=) then amount
procedure SlicePass(Bitmap: TBitmap; Low,High:integer);
var x,y:integer;
    Row:^TRGBTripleArray;

    function SliceByte(var vol: byte; amount1,amount2: byte):byte;
    begin
      if (vol < amount1) or (vol > amount2) then vol:=0;
    end;

begin
  Bitmap.PixelFormat := pf24bit;
  for y:=0 to Bitmap.height-1 do begin
    Row:=Bitmap.scanline[y];
    for x:=0 to Bitmap.width-1 do begin
      WITH Row[x] DO
      BEGIN
        SliceByte(rgbtRed,Low,High);
        SliceByte(rgbtGreen,Low,High);
        SliceByte(rgbtBlue,Low,High);
      END
    end;
  end;
end;

// Summerize all pixel intensity of BMP
function GetBMPSum(Bitmap: TBitmap):Longint;
var
ByteWsk:^Byte;
H,V:  Integer;
begin
  Result := 0;
  for V:=0 to Bitmap.Height-1 do
  begin
    ByteWsk:=Bitmap.ScanLine[V];
    for H:=0 to (Bitmap.Width-1)*3 do
    begin
      Result := Result + ByteWsk^;
      Inc(ByteWsk);
    end;
  end;
end;


function GetBMPAverage(Bitmap: TBitmap; HighLimit: byte): TRGB24;
var
    Row        :^TRGBTripleArray;
    x,y        :Integer;
    Ra,Ga,Ba   : double;
    PixCount   : integer;
    PixR,PixG,PixB : integer;   // Count of RGB pixels
begin
  PixCount := Bitmap.Width*Bitmap.Height;
if PixCount>0 then begin
  Ra:=0;Ga:=0;Ba:=0;
  PixR:=0;PixG:=0;PixB:=0;

  for y:=0 to (Bitmap.height-1) do begin
    Row:=Bitmap.scanline[y];
    for x:=0 to (Bitmap.width-1) do begin
      WITH Row[x] DO
      BEGIN
      if rgbtRed  <= HighLimit
         then begin
            Ra   := Ra + rgbtRed;
            Inc(PixR);
         end;
      if rgbtGreen<= HighLimit
         then begin
            Ga := Ga + rgbtGreen;
            Inc(PixG);
         end;
      if rgbtBlue <= HighLimit
         then begin
            Ba  := Ba + rgbtBlue;
            Inc(PixB);
         end;
      END;
    end;
  end;

  AvgThreshold.R  := Round(Ra/PixR);
  AvgThreshold.G  := Round(Ga/PixG);
  AvgThreshold.B  := Round(Ba/PixB);
end else begin
  AvgThreshold.R  := 0;
  AvgThreshold.G  := 0;
  AvgThreshold.B  := 0;
end;
  Result := AvgThreshold;
end;

function GetBMPMax(Bitmap: TBitmap): TRGB24;
var
    Row        :^TRGBTripleArray;
    x,y        :Integer;
    PixCount   : integer;
    PixR,PixG,PixB : integer;   // Count of RGB pixels
begin
  PixCount := Bitmap.Width*Bitmap.Height;
if PixCount>0 then begin
  PixR:=0;PixG:=0;PixB:=0;

  for y:=0 to (Bitmap.height-1) do begin
    Row:=Bitmap.scanline[y];
    for x:=0 to (Bitmap.width-1) do begin
      WITH Row[x] DO
      BEGIN
      if rgbtRed    > PixR then PixR := rgbtRed;
      if rgbtGreen  > PixG then PixG := rgbtGreen;
      if rgbtBlue   > PixB then PixB := rgbtBlue;
      END;
    end;
  end;

  Result.R  := PixR;
  Result.G  := PixG;
  Result.B  := PixB;
end else begin
  Result.R  := 0;
  Result.G  := 0;
  Result.B  := 0;
end;
end;

function GetBMPMin(Bitmap: TBitmap): TRGB24;
var
    Row        :^TRGBTripleArray;
    x,y        :Integer;
    PixCount   : integer;
    PixR,PixG,PixB : integer;   // Count of RGB pixels
begin
  PixCount := Bitmap.Width*Bitmap.Height;
if PixCount>0 then begin
  PixR:=255;PixG:=255;PixB:=255;

  for y:=0 to (Bitmap.height-1) do begin
    Row:=Bitmap.scanline[y];
    for x:=0 to (Bitmap.width-1) do begin
      WITH Row[x] DO
      BEGIN
      if rgbtRed    < PixR then PixR := rgbtRed;
      if rgbtGreen  < PixG then PixG := rgbtGreen;
      if rgbtBlue   < PixB then PixB := rgbtBlue;
      END;
    end;
  end;

  Result.R  := PixR;
  Result.G  := PixG;
  Result.B  := PixB;
end else begin
  Result.R  := 0;
  Result.G  := 0;
  Result.B  := 0;
end;
end;

function GetBMPMinMax(Bitmap: TBitmap; var minV, maxV : TRGBTriple): boolean;
var
    Row        :^TRGBTripleArray;
    x,y        :Integer;
    PixCount   : integer;
begin
  PixCount := Bitmap.Width*Bitmap.Height;
  Result := False;
  if PixCount>0 then begin
     ChangeRGBColor(minV,255,255,255);
     ChangeRGBColor(maxV,0,0,0);

     for y:=0 to (Bitmap.height-1) do begin
         Row:=Bitmap.scanline[y];
     for x:=0 to (Bitmap.width-1) do begin
      WITH Row[x] DO
      BEGIN
      if rgbtRed    < minV.rgbtRed then minV.rgbtRed := rgbtRed;
      if rgbtGreen  < minV.rgbtGreen then minV.rgbtGreen := rgbtGreen;
      if rgbtBlue   < minV.rgbtBlue then minV.rgbtBlue := rgbtBlue;
      if rgbtRed    > maxV.rgbtRed then maxV.rgbtRed := rgbtRed;
      if rgbtGreen  > maxV.rgbtGreen then maxV.rgbtGreen := rgbtGreen;
      if rgbtBlue   > maxV.rgbtBlue then maxV.rgbtBlue := rgbtBlue;
      END;
     end;
     end;
     Result := True;
  end;
end;

function GetAverageThreshold(Bitmap: TBitmap): TThreshold;
var
    Row        :^TRGBTripleArray;
    x,y        :Integer;
    Ra,Ga,Ba   : double;
    PixCount   : integer;
begin
(*
  PixCount := Bitmap.Width*Bitmap.Height;
if PixCount>0 then begin
  Ra:=0;Ga:=0;Ba:=0;

  for y:=0 to (Bitmap.height-1) do begin
    Row:=Bitmap.scanline[y];
    for x:=0 to (Bitmap.width-1) do begin
      WITH Row[x] DO
      BEGIN
      if rgbtRed  < 120
         then Ra   := Ra + rgbtRed;
      if rgbtGreen< 100
         then Ga := Ga + rgbtGreen;
      if rgbtBlue < 120
         then Ba  := Ba + rgbtBlue;
      END;
    end;
  end;

  AvgThreshold.R  := Round(Ra/PixCount);
  AvgThreshold.G  := Round(Ga/PixCount);
  AvgThreshold.B  := Round(Ba/PixCount);
end else begin
  AvgThreshold.R  := 0;
  AvgThreshold.G  := 0;
  AvgThreshold.B  := 0;
end;*)
  GetBMPAverage(Bitmap,60);
  Result := AvgThreshold;
end;


// Háttérzaj levonása a teljes képbõl: Factor = küszöb szorzó
procedure ThresholdElimination(Bitmap: TBitmap; avgTres: TThreshold; factor: double);
var
   Row:^TRGBTripleArray;
   x,y :Integer;
begin
  Bitmap.PixelFormat := pf24bit;
  for y:=0 to Bitmap.height-1 do begin
    Row:=Bitmap.scanline[y];
    for x:=0 to Bitmap.width-1 do begin
      WITH Row[x] DO
      BEGIN
      if rgbtRed  < factor*avgTres.R
         then rgbtRed   := 0
         else rgbtRed   := rgbtRed - Round(factor*avgTres.R);
      if rgbtGreen< factor*avgTres.G
         then rgbtGreen := 0
         else rgbtGreen := rgbtGreen - Round(factor*avgTres.G);
      if rgbtBlue < factor*avgTres.B
         then rgbtBlue  := 0
         else rgbtBlue  := rgbtBlue  - Round(factor*avgTres.B);
      END;
    end;
  end;
end;

procedure AutomaticThresholdElimination(Bitmap: TBitmap; factor: double);
begin
  AvgThreshold := GetBMPAverage(Bitmap,100);
  ThresholdElimination(Bitmap,AvgThreshold,Factor);
  RGBMultiplication(Bitmap,1+AvgThreshold.R/255,1+AvgThreshold.G/255,1+AvgThreshold.B/255);
end;

// All pixel is white if intenzity<>0
// Minden pixel telített, ha értéke <> 0
procedure To2Bit(Bitmap: TBitmap; Threshold: byte);
var Treshold : integer;
    xx,yy: integer;
    Row:  pRGBTripleArray;
begin
//   Treshold := 13;
    for yy:=0 to Bitmap.Height-1 do begin
        Row := Bitmap.Scanline[yy];
        for xx:=0 to Bitmap.Width-1 do begin
            WITH Row[xx] DO
            BEGIN
                if rgbtGreen>Threshold then begin
                   rgbtRed   := 255;
                   rgbtGreen   := 255;
                   rgbtBlue   := 255;
                end else begin
                   rgbtRed   := 0;
                   rgbtGreen   := 0;
                   rgbtBlue   := 0;
                end;
            END
        end; // xx
    end; // yy
end;

procedure RGBMultiplication(Bitmap: TBitmap; Rm,Gm,Bm: double);
var
   Row:^TRGBTripleArray;
   x,y :Integer;
   kuszob: integer;
   i          : integer;
   PixCount   : integer;

    function RGBLimit(l: double):byte;
    // l paraméter 0-255 között lehet: ha negatív=0; l>255 = 255
    begin
      Result:=Trunc(l);
      if l<0 then Result:=0;
      if l>255 then Result:=255;
    end;

begin
  kuszob := 10;
  Bitmap.PixelFormat := pf24bit;
  PixCount := Bitmap.Width*Bitmap.Height;

  for y:=0 to Bitmap.height-1 do begin
    Row:=Bitmap.scanline[y];
    for x:=0 to Bitmap.width-1 do begin
      WITH Row[x] DO
      BEGIN
           rgbtRed   := RGBLimit(Rm * rgbtRed);
           rgbtGreen := RGBLimit(Gm * rgbtGreen);
           rgbtBlue  := RGBLimit(Bm * rgbtBlue);
      END;
    end;
  end;

end;


// Automac Star Detection from photographic bitmap
//         Result = Star Count
Function AutomaticStarDetection(Bitmap: TBitmap): integer;
var BMP        : TBitmap;               // For manipulation
    thRGB      : TStarRecord;
    xx,yy      : integer;
    Row,starRow: pRGBTripleArray;
    endLine    : boolean;
    i,j        : integer;
    starRect   : TRect;
    FirstRed,EndRed: integer;
    p          : TPoint2d;
begin
Try
  Try
    Result := 0;
    BMP    := TBitmap.Create;
    BMP.Assign(Bitmap);
    BMP.PixelFormat := pf24bit;
    BMP.Canvas.Brush.Style:=bsSolid;
    for yy:=0 to BMP.Height-1 do begin
        Row := BMP.Scanline[yy];
        for xx:=0 to BMP.Width-1 do begin
            if Row[xx].rgbtRed = 255 then begin
               j := yy;
               starRect := Rect(xx,yy,xx,yy);
               BMP.Canvas.Brush.Color := clRed;
               BMP.Canvas.FloodFill(xx,yy,clWhite,fsSurface);
               endLine := False;
               while not endLine do begin
                     endLine := False;
                     starRow := BMP.Scanline[j];
                     FirstRed := -1;
                     for i:=0 to BMP.Width-1 do begin
                         if ((starRow[i].rgbtRed = 255) and (starRow[i].rgbtBlue = 0)) then
                           begin
                             if FirstRed<0 then FirstRed := i;
                             EndRed := i;
                           end;
                    end;
                     if FirstRed = -1 then begin
                        endLine := True;
                        starRect.Bottom := j-1;
                     end else begin
                     if FirstRed < starRect.Left
                        then starRect.Left := FirstRed;
                     if EndRed > starRect.Right
                        then starRect.Right := EndRed;
                     end;
                     Inc(j);
                     if j>BMP.Height-1 then
                        exit;
               end;
               BMP.Canvas.Brush.Color := clBlack;
               BMP.Canvas.FloodFill(xx,yy,clRed,fsSurface);
               // Csillag középpont mentése
               with StarArray[Result] do begin
                    ID := Result;
                    x := 0.5+(starRect.Right + starRect.Left)/2;
                    y := 0.5+(starRect.Bottom + starRect.Top)/2;
                    Radius := ((starRect.Right - starRect.Left)
                              +(starRect.Bottom - starRect.Top))/2;
                    p:=GetStarCentroid(Bitmap,x,y,Radius);
                    Deleted := False;
               end;

               Inc(Result);
               StarCount := Result;
            end;
        end; // xx
    end; // yy
  finally
    BMP.Free;
  end;
except
  if BMP<>nil then BMP.Free;
  exit;
end;
end;


procedure StarCirclesDraw(Bitmap: TBitmap; col: TColor);
var i: integer;
    RR: double;
begin
  if StarCount>0 then
  with Bitmap.Canvas do begin
       Pen.Color := col;
       Pen.Width := 1;
       Brush.Style := bsClear;
       For i:=0 to StarCount-1 do begin
           RR := StarArray[i].Radius;
           if RR<2 then RR:=2;
           Ellipse(Round(StarArray[i].x-RR),
                   Round(StarArray[i].y-RR),
                   Round(StarArray[i].x+RR),
                   Round(StarArray[i].y+RR));
       end;    
  end;
end;

// Search for star from image x,y coordinates
//        idx = index of StarArray element
function StarSearch(var idx: integer; x,y: double): boolean;
var R : double;
    i : integer;
begin
  Result := False;
  idx    := -1;
  if StarCount<>0 then
  for i:=0 to StarCount-1 do begin
      R := StarArray[i].Radius;
      if R<4 then R:=4;
      if (Abs(StarArray[i].x-x)<=R) and (Abs(StarArray[i].y-y)<=R) then
      begin
        idx    := i;
        Result := True;
        Exit;
      end;
  end;
end;


procedure StepRGB(Bitmap: TBitmap; Step: byte);
var
    x,y: integer;
    Row:  pRGBTripleArray;
begin
  Bitmap.PixelFormat := pf24bit;
  for y:=0 to Bitmap.height-1 do begin
    Row:=Bitmap.scanline[y];
    for x:=0 to Bitmap.width-1 do begin
      WITH Row[x] DO
      BEGIN
           rgbtRed   := Step * Trunc(rgbtRed / Step);
           rgbtGreen := Step * Trunc(rgbtGreen / Step);
           rgbtBlue  := Step * Trunc(rgbtBlue / Step);
      END;
    end;
  end;
end;

procedure StepRGBContur(Bitmap: TBitmap; Step: byte;
                                ConturColor: TColor);
var
    x,y: integer;
    Row,RowNext:  pRGBTripleArray;
    cR,cB,cG : byte;
    oldR,oldB,oldG : byte;
begin
  Bitmap.PixelFormat := pf24bit;
  cR := GetRValue(ConturColor);
  cG := GetGValue(ConturColor);
  cB := GetBValue(ConturColor);
  oldR := 0; oldG:=0; oldB:=0;
  Row:=Bitmap.scanline[0];
  for y:=0 to Bitmap.height-2 do begin
    RowNext:=Bitmap.scanline[y+1];
    for x:=0 to Bitmap.width-1 do begin
      WITH Row[x] DO
      BEGIN
       if Trunc(oldG/Step)<>Trunc(rgbtGreen/Step) then begin
           oldR := rgbtRed; oldG:=rgbtGreen; oldB:=rgbtBlue;
           rgbtRed := cR;
           rgbtGreen := cG;
           rgbtBlue := cB;
        end else
        if Trunc(rgbtGreen/Step)<>Trunc(RowNext[x].rgbtGreen/Step) then begin
           rgbtRed := cR;
           rgbtGreen := cG;
           rgbtBlue := cB;
        end;
      END;
    end;
    Row := RowNext;
  end;
end;

// Take a preprocesses on the Bitmap (Threshold elimination+HighPass filter)
// and execute the StarDetect with multilevel HighPass;
// Save the detected stars into the StarArray for all highpass level.
// After calculete the real stars and store datas in the final StarArray,
// and you can access the datas from the global StarArray.
//       Result = Star Count

Function PrecisionStarDetection(Bitmap: TBitmap; ThresholdFactor: double;
                                 HighPassLevel: byte): integer;
var BMP        : TBitmap;        // For manipulation
    StarList   : TList;          // List for stars
    hPass      : byte;           // HighPass value for growing
    TempBMP    : TBitmap;        // For large areas analysis
    TempCorner : TPoint;
    TempRadius : integer;
    EndAnalysis: boolean;        // Significant the end of analysis
    sStream    : TMemoryStream;  // For founded real stars;

    // Recursive calling while found a
    function SmallAreaAnalysis(tBMP: TBitmap; TopLeft: TPoint): integer;
    begin
    end;

begin
Try
    StarList   := TList.Create;
    BMP        := TBitmap.Create;
    TempBMP    := TBitmap.Create;
    hPass      := HighPassLevel;
    EndAnalysis:= False;
    BMP.Assign(Bitmap);
    BMP.PixelFormat := pf24bit;
    Blur(BMP);
    AutomaticThresholdElimination(BMP, ThresholdFactor);
    Repeat
       HighPassEx(BMP,hPass);
       AutomaticStarDetection(BMP);
       Inc(hPass,20);
       EndAnalysis := hPass>235;
    Until EndAnalysis;
finally
    TempBMP.Free;
    BMP.Free;
    StarList.Free;
end;
end;

// Calculate the centre position of the star
// Csillag középpont meghatározás
function GetStarCentroid(Bitmap: TBitmap;x, y, Radius: double): TPoint2d;
var i,x0,y0: integer;
    xx,yy: integer;
    XPos,YPos: double;
    XI,YI: double;
    d: double;
    n: integer;
    nPixel: integer;
    co   : TColor;
begin
  x0 := Round(x-Radius);     // befoglaló négyzet bal felsõ sarka
  y0 := Round(y-Radius);
  n  := Round(2*Radius+2);   // befoglaló négyzet oldala
  nPixel := 0;
  XPos := 0; YPos := 0;
  XI := 0; YI := 0;
  With Bitmap.Canvas do
    for yy:=y0 to y0+n do begin
        for xx:=x0 to x0+n do begin
           d := SQRt(SQR(X-XX)+SQR(Y-YY));
           IF d<=Radius then begin           // Ha a mérõkörbe esik
              co := GetGValue(Pixels[xx,yy]);
              XPos := XPos + (xx-x0) * co;
              YPos := YPos + (yy-y0) * co;
              XI   := XI + co;
              YI   := YI + co;
              Inc(nPixel);
           end;
        end;
    end;
    Result.x := x0;
    Result.y := y0;
    if XI>0 then begin
      Result.x := x0 + XPos / XI;
      Result.y := y0 + YPos / YI;
    end;
end;


// ================ Execute and manipulate a Process, or ProcessList

procedure DoProcessList(var Bitmap: TBitmap; PrList: TStringList);
var CommandStr, par1Str, par2Str, par3Str, par4Str : string;
    i           : integer;
begin
  For i:=0 to Pred(PrList.Count) do begin
  end;
end;

// =============== PHOTOMETRICAL METHODS =========================== //

function GetAverageIntensityOfStar(Bitmap: TBitmap; x,y, Radius: Double): double;
Var StarTopLeft  : TPoint;     // To left coordinate of Inner rectanle
    xx,yy,RR     : integer;    // Pixel coordinates, RR = width of star rectangle
    co           : TColor;     // Color of actual pixel
    d            : double;     // Distance from the star's centre
    nPixel       : integer;    // Count of star's pixels are inner the Radius
begin
  Result := 0;
If Radius>0 then
Try
  nPixel := 0;
  StarTopLeft := Point(Round(x-Radius),Round(y-Radius));
  RR := Round(2*Radius);
  For yy:=StarTopLeft.y to StarTopLeft.y+RR do
      For xx:=StarTopLeft.x to StarTopLeft.x+RR do begin
           d := SQRt(SQR(X-XX)+SQR(Y-YY));
           IF d<Radius then begin               // if distance < Radius
              co := Bitmap.Canvas.Pixels[xx,yy];
              Result := Result + co;
              Inc(nPixel);
           end;
      end;
Finally
   Result := Result / nPixel;
end;
end;

function SingleStarPhotometry(Bitmap:TBitmap;      // Source bitmap
                              x,y: integer;        // Coord's in bitmap
                              R: integer;          // Radius
                              Threshold: integer)  // Threshold level
                              : TStarRecord;       // Record of star
Var bmp: TBitmap;
    xx,yy      : integer;
    Row,starRow:  pRGBTripleArray;
    endLine    : boolean;
    i,j        : integer;
    sRect      : TRect;
    pCent      : TPoint2d;
begin
  Try
    BMP := TBitmap.Create;
    BMP.PixelFormat := pf24bit;
    BMPResize(bmp,2*R+1,2*R+1);
    BMP.Canvas.CopyRect(BMP.Canvas.Cliprect,Bitmap.Canvas,
                   Rect(x-R,y-R,x+R,y+R));

    // Automatic star detect in x,y position (not precise!)
    HighPassEx(BMP,Threshold);
    sRect:=Rect(MaxInt,MaxInt,-MaxInt,-MaxInt);
    BMP.Canvas.Brush.Color := clRed;
    BMP.Canvas.FloodFill(R,R,clRed,fsSurface);
    for yy:=0 to BMP.Height-1 do begin
        Row := BMP.Scanline[yy];
        for xx:=0 to BMP.Width-1 do begin
            if Row[xx].rgbtRed = 255 then begin
               if sRect.Left>xx then sRect.Left:=xx;
               if sRect.Right<xx then sRect.Right:=xx;
               if sRect.Top>yy then sRect.Top:=yy;
               if sRect.Bottom<yy then sRect.Bottom:=yy;
            end;
        end;
    end;
    Result.x := (sRect.Right + sRect.Left)/2;
    Result.y := (sRect.Bottom + sRect.Top)/2;
    Result.Radius := ((sRect.Right - sRect.Left)
                   +(sRect.Bottom - sRect.Top))/4;
    BMP.Canvas.CopyRect(BMP.Canvas.Cliprect,Bitmap.Canvas,
                   Rect(x-R,y-R,x+R,y+R));

    // Get the original part of source image
    // and take a precise star detect
    pCent := GetStarCentroid(Bitmap,Result.x,Result.y,Result.Radius);
    (*
    for yy:=0 to BMP.Height-1 do begin
        Row := BMP.Scanline[yy];
        for xx:=0 to BMP.Width-1 do begin
        end;
    end;
    *)
    Result.x := (x-R)+pCent.x;
    Result.y := (y-R)+pCent.y;
  finally
    bmp.Free;
  end;
end;

// Photomety for a single star:
// x,y = the coordinates of the star;
// Result = TStarRecord;
function SimplePhotometry(Bitmap: TBitmap; x,y: Double; var Star : TStarRecord): boolean;
var StarCent : TPoint2D;         // Centre of star
    scPoint  : TPoint;
    StarRec  : TRect2D;
    MaxIntensity   : integer;    // Maximal intenzity of peek of star
    PixIntensity   : integer;    // One pixel intenzity while stepping
    HalfIntensity  : double;     // Half of MaxIntensity
    AvgIntensity   : double;     // Average intensity of the star in the radius
    xx,yy          : integer;    // Pixel coordinates
    OutOfBitmap    : boolean;    // True if measuring step out from the image
BEGIN
  With Bitmap.Canvas do begin
    StarCent      := Point2d(x,y);
    // Centre pixel of star
    scPoint       := Point(Trunc(StarCent.x),Trunc(StarCent.y));
    MaxIntensity  := Pixels[scPoint.x,scPoint.y];
    HalfIntensity := MaxIntensity/2;

    // Measuring the half-wide of star curve
    // -------------------------------------
    // Get the left edge
    xx := scPoint.x;
    yy := scPoint.y;
    Repeat
       Dec(xx);
       PixIntensity := Pixels[xx,yy];
       if PixIntensity<=HalfIntensity then
          StarRec.x1 := xx;
       OutOfBitmap := xx<1;
    Until (PixIntensity<=HalfIntensity) or OutOfBitmap;
    // Get the right edge
    xx := scPoint.x;
    Repeat
       Inc(xx);
       PixIntensity := Pixels[xx,yy];
       if PixIntensity<=HalfIntensity then
          StarRec.x2 := xx;
       OutOfBitmap := xx>Bitmap.Width-2;
    Until (PixIntensity<=HalfIntensity) or OutOfBitmap;
    // Get the Bottom edge
    xx := scPoint.x;
    yy := scPoint.y;
    Repeat
       Inc(yy);
       PixIntensity := Pixels[xx,yy];
       if PixIntensity<=HalfIntensity then
          StarRec.y2 := yy;
       OutOfBitmap := yy>Bitmap.Height-2;
    Until (PixIntensity<=HalfIntensity) or OutOfBitmap;
    // Get the Top edge
    yy := scPoint.y;
    Repeat
       Dec(yy);
       PixIntensity := Pixels[xx,yy];
       if PixIntensity<=HalfIntensity then
          StarRec.y1 := yy;
       OutOfBitmap := yy<1;
    Until (PixIntensity<=HalfIntensity) or OutOfBitmap;

    Result         := not OutOfBitmap;        // The total star is on the bitmap

    if Result then begin
    Star.HalfRad   := ((StarRec.x2-StarRec.x1)+(StarRec.y2-StarRec.y1))/2;
    Star.Radius    := Star.HalfRad;

    xx := Trunc((StarRec.x2+StarRec.x1)/2);
    xx := Trunc((StarRec.y2+StarRec.y1)/2);
    StarCent      := GetStarCentroid(Bitmap,Trunc(xx),Trunc(yy),Round(Star.Radius));
    AvgIntensity := GetAverageIntensityOfStar(Bitmap, x,y, Star.HalfRad);

    // Finally set the Result parameters
    Star.x         := StarCent.x;
    Star.y         := StarCent.y;
    Star.Intensity := AvgIntensity;
    end;
  end;
END;

function GetAverageIntensityOfStarG(Bitmap: TBitmap; x,y, Radius: Double): double;
Var StarTopLeft  : TPoint;     // To left coordinate of Inner rectanle
    xx,yy,RR     : integer;    // Pixel coordinates, RR = width of star rectangle
    co           : TColor;     // Color of actual pixel
    d            : double;     // Distance from the star's centre
    nPixel       : integer;    // Count of star's pixels are inner the Radius
begin
  Result := 0;
If Radius>0 then
Try
  nPixel := 0;
  StarTopLeft := Point(Round(x-Radius),Round(y-Radius));
  RR := Round(2*Radius);
  For yy:=StarTopLeft.y to StarTopLeft.y+RR do
      For xx:=StarTopLeft.x to StarTopLeft.x+RR do begin
           d := SQRt(SQR(X-XX)+SQR(Y-YY));
           IF d<=Radius then begin               // if distance < Radius
              co := GetGValue(Bitmap.Canvas.Pixels[xx,yy]);
              Result := Result + co;
              Inc(nPixel);
           end;
      end;
Finally
(*
   if nPixel=0 then
      Result := 0
   else
      Result := Result / nPixel;
*)
end;
end;

// Photomety for a single star:
// x,y = the coordinates of the star;
// Result = TStarRecord;
function SimplePhotometryG(Bitmap: TBitmap; x,y: Double; var Star : TStarRecord): boolean;
var StarCent : TPoint2D;         // Centre of star
    scPoint  : TPoint;
    StarRec  : TRect2D;
    MaxIntensity   : integer;    // Maximal intenzity of peek of star
    PixIntensity   : integer;    // One pixel intenzity while stepping
    HalfIntensity  : double;     // Half of MaxIntensity
    AvgIntensity   : double;     // Average intensity of the star in the radius
    xx,yy          : integer;    // Pixel coordinates
    OutOfBitmap    : boolean;    // True if measuring step out from the image
BEGIN
  With Bitmap.Canvas do begin
    StarCent      := GetStarCentroid(Bitmap,Trunc(x),Trunc(y),10);
    // Centre pixel of star
    scPoint       := Point(Trunc(StarCent.x),Trunc(StarCent.y));
    MaxIntensity  := GetGValue(Pixels[scPoint.x,scPoint.y]);
    HalfIntensity := MaxIntensity/2;

    // Measuring the half-wide of star curve
    // -------------------------------------
    // Get the left edge
    xx := scPoint.x;
    yy := scPoint.y;
    Repeat
       Dec(xx);
       PixIntensity := GetGValue(Pixels[xx,yy]);
       if PixIntensity<=HalfIntensity then
          StarRec.x1 := xx;
       OutOfBitmap := xx<1;
    Until (PixIntensity<=HalfIntensity) or OutOfBitmap;
    // Get the right edge
    xx := scPoint.x;
    Repeat
       Inc(xx);
       PixIntensity := GetGValue(Pixels[xx,yy]);
       if PixIntensity<=HalfIntensity then
          StarRec.x2 := xx;
       OutOfBitmap := xx>Bitmap.Width-2;
    Until (PixIntensity<=HalfIntensity) or OutOfBitmap;
    // Get the Bottom edge
    xx := scPoint.x;
    yy := scPoint.y;
    Repeat
       Inc(yy);
       PixIntensity := GetGValue(Pixels[xx,yy]);
       if PixIntensity<=HalfIntensity then
          StarRec.y2 := yy;
       OutOfBitmap := yy>Bitmap.Height-2;
    Until (PixIntensity<=HalfIntensity) or OutOfBitmap;
    // Get the Top edge
    yy := scPoint.y;
    Repeat
       Dec(yy);
       PixIntensity := GetGValue(Pixels[xx,yy]);
       if PixIntensity<=HalfIntensity then
          StarRec.y1 := yy;
       OutOfBitmap := yy<1;
    Until (PixIntensity<=HalfIntensity) or OutOfBitmap;

    Result         := not OutOfBitmap;        // The total star is on the bitmap

    if Result then begin
    Star.HalfRad   := ((StarRec.x2-StarRec.x1)+(StarRec.y2-StarRec.y1))/4;

    If Star.HalfRad>0 then Star.Radius := Star.HalfRad else Star.Radius:=1;

    AvgIntensity := GetAverageIntensityOfStarG(Bitmap, x,y, Star.HalfRad);

    // Finally set the Result parameters
    Star.x         := StarCent.x+0.5;
    Star.y         := StarCent.y+0.5;
    Star.Intensity := AvgIntensity;
    end;
  end;
END;

// Photometry of all detected stars
procedure TotalPhotometry(Bitmap: TBitmap);
var i: integer;
begin
  if StarCount > 0 then
  for i:=0 to StarCount-1 do begin
      SimplePhotometryG(Bitmap,StarArray[i].x,StarArray[i].y,StarArray[i]);
  end;
end;

// Move away the source bitmap with offsets (0<=Offset<=1)
procedure SubPixelShift(SourceBitmap : TBitmap; out DestBitmap : TBitmap;
                                  OffsetX, OffsetY: double);
Var Row1,Row2,ROW: pRGBTripleArray;
    X,Y          : integer;
    ofx,ofy      : double;
    t1,t2,t3,t4  : double;
    r,g,b        : integer;
begin
   DestBitmap.Width  := SourceBitmap.Width;
   DestBitmap.Height := SourceBitmap.Height;
   DestBitmap.PixelFormat := pf24bit;
   Cls(DestBitmap.Canvas,clBlack);
   ofx := Frac(OffsetX);
   ofy := Frac(OffsetY);
   t1 := (1-ofx)*(1-ofy);
   t2 := ofx*(1-ofy);
   t3 := (1-ofx)*ofy;
   t4 := ofx*ofy;
   Row1 := SourceBitmap.Scanline[0];
   For Y :=0 to SourceBitmap.Height-2 Do
   Begin
     Row2 := SourceBitmap.Scanline[Y+1];
     ROW  := DestBitmap.Scanline[Y];
     For X :=0 to SourceBitmap.Width-2 Do
         WITH ROW[x] DO
         BEGIN
           r         := Trunc(t1*Row1[x].rgbtRed+t2*Row1[x+1].rgbtRed
                        +t3*Row2[x].rgbtRed+t4*Row2[x+1].rgbtRed);
           rgbtRed   := IntToByte(r);
           g         := Trunc(t1*Row1[x].rgbtGreen+t2*Row1[x+1].rgbtGreen
                        +t3*Row2[x].rgbtGreen+t4*Row2[x+1].rgbtGreen);
           rgbtGreen := IntToByte(g);
           b         := Trunc(t1*Row1[x].rgbtBlue+t2*Row1[x+1].rgbtBlue
                        +t3*Row2[x].rgbtBlue+t4*Row2[x+1].rgbtBlue);
           rgbtBlue  := IntToByte(b);
         END;
     Row1 := Row2;
   end;
end;

    (*  BAD PIXEL CORRECTIONS *)

function FixStuckPixels(Bitmap: TBitmap; Threshold: byte; difference: byte): integer;
// Result = Count of stuck pixels
VAR
  i  :  INTEGER;
  j  :  INTEGER;
  x,y:  integer;
  Row        :  array[0..2] of pPixelArray;
  prevPixel  : TRGBTriple;        // Previous pixel RGB
  nextPixel  : TRGBTriple;        // Next pixel RGB
  next1Pixel : TRGBTriple;        // Next pixel RGB 1
  next2Pixel : TRGBTriple;        // Next pixel RGB 2
  avgR, avgG, avgB  : integer;    // Average  pixel RGB
  RandomI           : integer;    // Random
//  bBMP       : TBitmap;           // 4x4 Bitmap for bad stuck pixel
begin
TRY
  Result := 0;
  Bitmap.PixelFormat := pf24bit;
  Row[0] := Bitmap.Scanline[0];
  Row[1] := Bitmap.Scanline[1];
  FOR j := 2 TO Bitmap.Height-3 DO
  BEGIN
    Row[2] := Bitmap.Scanline[j];
    prevPixel := ChangeRGBColor(prevPixel,0,0,0);
    FOR i := 1 TO Bitmap.Width-2 DO
    BEGIN
      nextPixel := Row[1][i+1];
      next1Pixel := Row[2][i-1];
      next2Pixel := Row[2][i+1];

      WITH Row[1][i] DO
      BEGIN
      // Only the very high pixels
      if ((Row[1][i].rgbtGreen-prevPixel.rgbtGreen)>difference) and
         ((Row[1][i].rgbtGreen-nextPixel.rgbtGreen)>difference)
      then
      begin
        if ((rgbtRed+rgbtGreen+rgbtBlue) div 3)>Threshold then
        begin
           iF (next1Pixel.rgbtGreen<Row[1][i].rgbtGreen) and
              (next2Pixel.rgbtGreen<Row[1][i].rgbtGreen)
           then begin
           // Stuck pixel R,G,B are about equal between 20 difference
             // 3x3 matrix RGB average around the stuck pixel
             avgR := 0; avgG := 0; avgB := 0;
             for y:=0 to 2 do
                 for x:=-1 to 1 do
                 begin
                   avgR := avgR + Row[y][x+i].rgbtRed;
                   avgG := avgG + Row[y][x+i].rgbtGreen;
                   avgB := avgB + Row[y][x+i].rgbtBlue;
                 end;

             avgR := avgR - (Row[1][i].rgbtRed DIV 2);
             avgG := avgG - (Row[1][i].rgbtGreen DIV 2);
             avgB := avgB - (Row[1][i].rgbtBlue DIV 2);

             avgR := avgR div 9;
             avgG := avgG div 9;
             avgB := avgB div 9;

             for y:=0 to 2 do
                 for x:=-1 to 1 do
                 begin
                   RandomI := Random(difference);
                   RandomI := RandomI - (difference div 4);
                   RandomI := 0;
                   Row[y][x+i].rgbtRed   := avgR + RandomI;
                   Row[y][x+i].rgbtGreen := avgG + RandomI;
                   Row[y][x+i].rgbtBlue  := avgB + RandomI;
                 end;


             Inc(Result);
           end;
        end;
      end;
      END;
      prevPixel := Row[1][i];
    END;
    Row[0] := Row[1];
    Row[1] := Row[2];
  END;
FINALLY
END
end;

function GetStuckPixelsStatistic(Bitmap: TBitmap; VAR stpa: array of TPoint;
                                 Threshold: byte; difference: byte): integer;
// Result = Count of stuck pixels
VAR
  i  :  INTEGER;
  j  :  INTEGER;
  x,y:  integer;
  Row        :  array[0..2] of pPixelArray;
  prevPixel  : TRGBTriple;        // Previous pixel RGB
  nextPixel  : TRGBTriple;        // Next pixel RGB
  next1Pixel : TRGBTriple;        // Next pixel RGB 1
  next2Pixel : TRGBTriple;        // Next pixel RGB 2
  avgR, avgG, avgB  : integer;    // Average  pixel RGB
  RandomI           : integer;    // Random
//  bBMP       : TBitmap;           // 4x4 Bitmap for bad stuck pixel
begin
TRY
  Result := 0;
  Bitmap.PixelFormat := pf24bit;
  Row[0] := Bitmap.Scanline[0];
  Row[1] := Bitmap.Scanline[1];
  FOR j := 2 TO Bitmap.Height-3 DO
  BEGIN
    Row[2] := Bitmap.Scanline[j];
    prevPixel := ChangeRGBColor(prevPixel,0,0,0);
    FOR i := 1 TO Bitmap.Width-2 DO
    BEGIN
      nextPixel := Row[1][i+1];
      next1Pixel := Row[2][i-1];
      next2Pixel := Row[2][i+1];

      WITH Row[1][i] DO
      BEGIN
      // Only the very high pixels
      if ((Row[1][i].rgbtGreen-prevPixel.rgbtGreen)>difference) and
         ((Row[1][i].rgbtGreen-nextPixel.rgbtGreen)>difference)
      then
      begin
        if ((rgbtRed+rgbtGreen+rgbtBlue) div 3)>Threshold then
        begin
           iF (next1Pixel.rgbtGreen<Row[1][i].rgbtGreen) and
              (next2Pixel.rgbtGreen<Row[1][i].rgbtGreen)
           then begin
             Inc(Result);
           end;
        end;
      end;
      END;
      prevPixel := Row[1][i];
    END;
    Row[0] := Row[1];
    Row[1] := Row[2];
  END;
FINALLY
END
end;

// Dark Frame Substaction from Src : Result = Src
function SubtractDark(SrcBitmap, DarkBitmap: TBitmap): boolean;
Var
  i  :  INTEGER;
  j  :  INTEGER;
  w,h:  integer;
  sRow :  pPixelArray;
  dRow :  pPixelArray;
begin
  Result := False;
IF (SrcBitmap<>nil) and (DarkBitmap<>nil) then
Try
  SrcBitmap.PixelFormat  := pf24bit;
  DarkBitmap.PixelFormat := pf24bit;
  if DarkBitmap.Width<SrcBitmap.Width then w:=DarkBitmap.Width
     else w:=SrcBitmap.Width;
  if DarkBitmap.Height<SrcBitmap.Height then h:=DarkBitmap.Height
     else h:=SrcBitmap.Height;
  FOR j := 0 TO h-1 DO
  BEGIN
    sRow := SrcBitmap.Scanline[j];
    dRow := DarkBitmap.Scanline[j];
    FOR i := 0 TO w-1 DO
    BEGIN
      sRow[i].rgbtRed   := IntToByte(sRow[i].rgbtRed - dRow[i].rgbtRed);
      sRow[i].rgbtGreen := IntToByte(sRow[i].rgbtGreen - dRow[i].rgbtGreen);
      sRow[i].rgbtBlue  := IntToByte(sRow[i].rgbtBlue - dRow[i].rgbtBlue);
    END;
  END;
  Result := True;
except
  Result := False;
end;
end;

function FlatCorrection(SrcBitmap, FlatBitmap: TBitmap): boolean;
Var
  i  :  INTEGER;
  j  :  INTEGER;
  w,h:  integer;
  sRow   :  pPixelArray;
  dRow   :  pPixelArray;
  thRec  :  TThreshold;
begin
Result := False;
if (SrcBitmap<>nil) and (FlatBitmap<>nil) then
Try
  Result := True;
  SrcBitmap.PixelFormat   := pf24bit;
  FlatBitmap.PixelFormat  := pf24bit;
  if FlatBitmap.Width<>SrcBitmap.Width then
     FlatBitmap.Width        := SrcBitmap.Width;
  if FlatBitmap.Height<>SrcBitmap.Height then
     FlatBitmap.Height       := SrcBitmap.Height;

  thRec := GetBMPAverage(FlatBitmap,255);
  if thRec.R=0 then thRec.R:=1;
  if thRec.G=0 then thRec.G:=1;
  if thRec.B=0 then thRec.B:=1;

  FOR j := 0 TO SrcBitmap.Height-1 DO
  BEGIN
    sRow  := SrcBitmap.Scanline[j];
    dRow  := FlatBitmap.Scanline[j];
    FOR i := 0 TO SrcBitmap.Width-1 DO
    BEGIN
    if dRow[i].rgbtRed>0 then
      sRow[i].rgbtRed   := IntToByte(Round(sRow[i].rgbtRed   * (thRec.R/dRow[i].rgbtRed)));
    if dRow[i].rgbtGreen>0 then
      sRow[i].rgbtGreen := IntToByte(Round(sRow[i].rgbtGreen * (thRec.G/dRow[i].rgbtGreen)));
    if dRow[i].rgbtBlue>0 then
      sRow[i].rgbtBlue  := IntToByte(Round(sRow[i].rgbtBlue  * (thRec.B/dRow[i].rgbtBlue)));
    END;
  END;
except
  Result := False;
end;
end;

function AddFrames(SrcBitmap1, SrcBitmap2: TBitmap; var DstkBitmap: TBitmap): boolean;
Var
  i  :  INTEGER;
  j  :  INTEGER;
  w,h:  integer;
  sRow1,sRow2 :  pPixelArray;
  dRow :  pPixelArray;
begin
Try
  Result := True;
  SrcBitmap1.PixelFormat  := pf24bit;
  SrcBitmap2.PixelFormat  := pf24bit;
  DstkBitmap.PixelFormat  := pf24bit;
  DstkBitmap.Width := SrcBitmap1.Width;
  DstkBitmap.Height := SrcBitmap1.Height;
  FOR j := 0 TO SrcBitmap1.Height-1 DO
  BEGIN
    sRow1 := SrcBitmap1.Scanline[j];
    sRow2 := SrcBitmap2.Scanline[j];
    dRow  := DstkBitmap.Scanline[j];
    FOR i := 0 TO SrcBitmap1.Width-1 DO
    BEGIN
      dRow[i].rgbtRed   := IntToByte(sRow1[i].rgbtRed + sRow2[i].rgbtRed);
      dRow[i].rgbtGreen := IntToByte(sRow1[i].rgbtGreen + sRow2[i].rgbtGreen);
      dRow[i].rgbtBlue  := IntToByte(sRow1[i].rgbtBlue + sRow2[i].rgbtBlue);
    END;
  END;
except
  Result := False;
end;
end;

function AddFramesLimited(SrcBitmap1, SrcBitmap2: TBitmap; var DstkBitmap: TBitmap;
                          Limit: integer ): boolean;
Var
  i  :  INTEGER;
  j  :  INTEGER;
  w,h:  integer;
  sRow1,sRow2 :  pPixelArray;
  dRow :  pPixelArray;
  thRec1,thRec2: TThreshold;
begin
Try
  Result := True;
  SrcBitmap1.PixelFormat  := pf24bit;
  SrcBitmap2.PixelFormat  := pf24bit;
  DstkBitmap.PixelFormat  := pf24bit;
  DstkBitmap.Width := SrcBitmap1.Width;
  DstkBitmap.Height := SrcBitmap1.Height;
  thRec1 := GetBMPAverage(SrcBitmap1,Limit);
  thRec2 := GetBMPAverage(SrcBitmap2,Limit);
  FOR j := 0 TO SrcBitmap1.Height-1 DO
  BEGIN
    sRow1 := SrcBitmap1.Scanline[j];
    sRow2 := SrcBitmap2.Scanline[j];
    dRow  := DstkBitmap.Scanline[j];
    FOR i := 0 TO SrcBitmap1.Width-1 DO
    BEGIN
      if (thRec1.R<sRow1[i].rgbtRed) and (thRec2.R<sRow2[i].rgbtRed) then
      dRow[i].rgbtRed   := IntToByte(sRow1[i].rgbtRed + sRow2[i].rgbtRed);
      if (thRec1.G<sRow1[i].rgbtGreen) and (thRec2.G<sRow2[i].rgbtGreen) then
      dRow[i].rgbtGreen := IntToByte(sRow1[i].rgbtGreen + sRow2[i].rgbtGreen);
      if (thRec1.B<sRow1[i].rgbtBlue) and (thRec2.B<sRow2[i].rgbtBlue) then
      dRow[i].rgbtBlue  := IntToByte(sRow1[i].rgbtBlue + sRow2[i].rgbtBlue);
    END;
  END;
except
  Result := False;
end;
end;

// Align 2 fames, where the difference of bitmaps is minimal
function AlignFrames(SrcBitmap1, SrcBitmap2: TBitmap):TPoint;
var minIntensity: Longint;
    defRadius   : integer;
    BMP1,BMP2   : TBitmap;
    RC,R        : TRect;
    V,H         : integer;
    sumI        : Longint;   // smal image summerized intensity
    WI,HE       : integer;
begin
Try
  defRadius := 50;
  Result := Point(0,0);
  minIntensity:=High(Longint);
  WI := SrcBitmap1.Width div 2;
  HE := SrcBitmap1.Height div 2;
  BMP1 := TBitmap.Create;
  BMP2 := TBitmap.Create;
  BMP1.Canvas.CopyMode := cmSrcCopy;
  BMPResize(BMP1,2*defRadius,2*defRadius);
  BMPResize(BMP2,2*defRadius,2*defRadius);
  SrcBitmap1.PixelFormat  := pf24bit;
  SrcBitmap2.PixelFormat  := pf24bit;
  RC := Rect((SrcBitmap2.Width div 2)-defRadius,(SrcBitmap2.Height div 2)-defRadius,
             (SrcBitmap2.Width div 2)+defRadius,(SrcBitmap2.Height div 2)+defRadius);
  BMP2.canvas.CopyRect(BMP2.Canvas.ClipRect,SrcBitmap2.Canvas,RC);
  for V:=HE-100 to HE+100 do
  begin
    for H:=WI-100 to WI+100 do begin
      RC := Rect(H,V,H+(2*defRadius),V+(2*defRadius));
      BMP1.canvas.CopyRect(BMP1.Canvas.ClipRect,SrcBitmap2.Canvas,RC);
      SubtractDark(BMP1,BMP2);
      sumI := GetBMPSum(BMP1);
      if sumI<minIntensity then begin
         minIntensity := sumI;
         Result := Point(H,V);
      end;
    end;
  end;
finally
  Result := Point(WI-(Result.x+defRadius),HE-(Result.y+defRadius));
  BMP1.Free;
  BMP2.Free;
end;
end;

(* s1,s2 bitmap-ek áttetsz? kombinálása %-os arányban:
   Ha Percent=0, akkor az els? bmp nem látszik, ha 50, akkor fele-fel, 100-nál
   csak az els? bmp látszik *)

Procedure Opaque(sBMP1,sBMP2 :TBitmap; destBMP :TBitmap; Percent: integer);
var
  scl1,scl2,dscl:^Byte;
  y,x: integer;
  w,h: integer;
begin
  sBMP1.pixelformat:=pf24bit;
  sBMP2.pixelformat:=pf24bit;
  destBMP.pixelformat:=pf24bit;
  w:=Min(sBMP1.Width,sBMP2.Width);
  h:=Min(sBMP1.Height,sBMP2.Height);
  if destBMP.Width<w then destBMP.Width:=w;
  if destBMP.Height<h then destBMP.Height:=h;
  for y:=0 to h-1 do begin
    scl1:=sBMP1.ScanLine[y];
    scl2:=sBMP2.ScanLine[y];
    dscl:=destBMP.ScanLine[y];
    for x:=0 to w*3-1 do begin
       dscl^:= Round((Percent*scl1^+(100-Percent)*scl2^)/100);
       inc(scl1);
       inc(scl2);
       inc(dscl);
    end;
  end;
end;
procedure EdgeDetect(Bitmap: TBitmap);
var
   nTemp      : double;
   c          : double;
   min, max   : double;
   sum        : double;
   mean       : double;
   d,s        : double;
   mdl, Size  : integer;
   n,l,k      : integer;
   bmp        : TBitmap;
Const
	MASK : array[1..12, 1..12] of double =
        (
        (-0.000699762,	-0.000817119,	-0.000899703,	-0.000929447,	-0.000917118,	-0.000896245,	-0.000896245,	-0.000917118,	-0.000929447,	-0.000899703,	-0.000817119,	-0.000699762),
        (-0.000817119,	-0.000914231,	-0.000917118,	-0.000813449,	-0.000655442,	-0.000538547,	-0.000538547,	-0.000655442,	-0.000813449,	-0.000917118,	-0.000914231,	-0.000817119),
        (-0.000899703,	-0.000917118,	-0.000745635,	-0.000389918,	0.0000268,	0.000309618,	0.000309618,	0.0000268,	-0.000389918,	-0.000745635,	-0.000917118,	-0.000899703),
        (-0.000929447,	-0.000813449,	-0.000389918,	0.000309618,	0.001069552,	0.00156934,	0.00156934,	0.001069552,	0.000309618,	-0.000389918,	-0.000813449,	-0.000929447),
        (-0.000917118,	-0.000655442,	0.0000268,	0.001069552,	0.002167033,	0.002878738,	0.002878738,	0.002167033,	0.001069552,	0.0000268,	-0.000655442,	-0.000917118),
        (-0.000896245,	-0.000538547,	0.000309618,	0.00156934,	0.002878738,	0.003722998,	0.003722998,	0.002878738,	0.00156934,	0.000309618,	-0.000538547,	-0.000896245),
        (-0.000896245,	-0.000538547,	0.000309618,	0.00156934,	0.002878738,	0.003722998,	0.003722998,	0.002878738,	0.00156934,	0.000309618,	-0.000538547,	-0.000896245),
        (-0.000917118,	-0.000655442,	0.0000268,	0.001069552,	0.002167033,	0.002878738,	0.002878738,	0.002167033,	0.001069552,	0.0000268,	-0.000655442,	-0.000917118),
        (-0.000929447,	-0.000813449,	-0.000389918,	0.000309618,	0.001069552,	0.00156934,	0.00156934,	0.001069552,	0.000309618,	-0.000389918,	-0.000813449,	-0.000929447),
        (-0.000899703,	-0.000917118,	-0.000745635,	-0.000389918,	0.0000268,	0.000309618,	0.000309618,	0.0000268,	-0.000389918,	-0.000745635,	-0.000917118,	-0.000899703),
        (-0.000817119,	-0.000914231,	-0.000917118,	-0.000813449,	-0.000655442,	-0.000538547,	-0.000538547,	-0.000655442,	-0.000813449,	-0.000917118,	-0.000914231,	-0.000817119),
	(-0.000699762,	-0.000817119,	-0.000899703,	-0.000929447,	-0.000917118,	-0.000896245,	-0.000896245,	-0.000917118,	-0.000929447,	-0.000899703,	-0.000817119,	-0.000699762)
	);

begin
end;

PROCEDURE Convolve(ABitmap : TBitmap ; AMask : T3x3FloatArray ; ABias : integer);
Var
  LRow1, LRow2, LRow3, LRowOut : PRGBTripleArray;
  LRow, LCol : integer;
  LNewBlue, LNewGreen, LNewRed : Extended;
  LCoef : Extended;
  BMP   : TBitmap;
begin
Try

  LCoef := 0;
  for LRow := 0 to 2 do for LCol := 0 to 2 do LCoef := LCoef + AMask[LCol, LRow];
  if LCoef = 0 then LCoef := 1;

  BMP := TBitmap.Create;

  BMP.Width := ABitmap.Width - 2;
  BMP.Height := ABitmap.Height - 2;
  BMP.PixelFormat := pf24bit;

  LRow2 := ABitmap.ScanLine[0];
  LRow3 := ABitmap.ScanLine[1];

  for LRow := 1 to ABitmap.Height - 2 do begin

    LRow1 := LRow2;
    LRow2 := LRow3;
    LRow3 := ABitmap.ScanLine[LRow + 1];
    
    LRowOut := BMP.ScanLine[LRow - 1];

    for LCol := 1 to ABitmap.Width - 2 do begin

      LNewBlue :=
        (LRow1[LCol-1].rgbtBlue*AMask[0,0]) + (LRow1[LCol].rgbtBlue*AMask[1,0]) + (LRow1[LCol+1].rgbtBlue*AMask[2,0]) +
        (LRow2[LCol-1].rgbtBlue*AMask[0,1]) + (LRow2[LCol].rgbtBlue*AMask[1,1]) + (LRow2[LCol+1].rgbtBlue*AMask[2,1]) +
        (LRow3[LCol-1].rgbtBlue*AMask[0,2]) + (LRow3[LCol].rgbtBlue*AMask[1,2]) + (LRow3[LCol+1].rgbtBlue*AMask[2,2]);
      LNewBlue := (LNewBlue / LCoef) + ABias;
      if LNewBlue > 255 then LNewBlue := 255;
      if LNewBlue < 0 then LNewBlue := 0;

      LNewGreen :=
        (LRow1[LCol-1].rgbtGreen*AMask[0,0]) + (LRow1[LCol].rgbtGreen*AMask[1,0]) + (LRow1[LCol+1].rgbtGreen*AMask[2,0]) +
        (LRow2[LCol-1].rgbtGreen*AMask[0,1]) + (LRow2[LCol].rgbtGreen*AMask[1,1]) + (LRow2[LCol+1].rgbtGreen*AMask[2,1]) +
        (LRow3[LCol-1].rgbtGreen*AMask[0,2]) + (LRow3[LCol].rgbtGreen*AMask[1,2]) + (LRow3[LCol+1].rgbtGreen*AMask[2,2]);
      LNewGreen := (LNewGreen / LCoef) + ABias;
      if LNewGreen > 255 then LNewGreen := 255;
      if LNewGreen < 0 then LNewGreen := 0;

      LNewRed :=
        (LRow1[LCol-1].rgbtRed*AMask[0,0]) + (LRow1[LCol].rgbtRed*AMask[1,0]) + (LRow1[LCol+1].rgbtRed*AMask[2,0]) +
        (LRow2[LCol-1].rgbtRed*AMask[0,1]) + (LRow2[LCol].rgbtRed*AMask[1,1]) + (LRow2[LCol+1].rgbtRed*AMask[2,1]) +
        (LRow3[LCol-1].rgbtRed*AMask[0,2]) + (LRow3[LCol].rgbtRed*AMask[1,2]) + (LRow3[LCol+1].rgbtRed*AMask[2,2]);
      LNewRed := (LNewRed / LCoef) + ABias;
      if LNewRed > 255 then LNewRed := 255;
      if LNewRed < 0 then LNewRed := 0;

      LRowOut[LCol-1].rgbtBlue  := trunc(LNewBlue);
      LRowOut[LCol-1].rgbtGreen := trunc(LNewGreen);
      LRowOut[LCol-1].rgbtRed   := trunc(LNewRed);

    end;

  end;
finally
//  ABitmap.Assign(BMP);
  ABitmap.Canvas.Draw(1,1,BMP);
  BMP.Free;
end;
end;

{This just forces a value to be 0 - 255 for rgb purposes.  I used asm in an
 attempt at speed, but I don't think it helps much.}
function Set255(Clr : integer) : integer;
asm
  MOV  EAX,Clr  // store value in EAX register (32-bit register)
  CMP  EAX,254  // compare it to 254
  JG   @SETHI   // if greater than 254 then go set to 255 (max value)
  CMP  EAX,1    // if less than 255, compare to 1
  JL   @SETLO   // if less than 1 go set to 0 (min value)
  RET           // otherwise it doesn't change, just exit
@SETHI:         // Set value to 255
  MOV  EAX,255  // Move 255 into the EAX register
  RET           // Exit (result value is the EAX register value)
@SETLO:         // Set value to 0
  MOV  EAX,0    // Move 0 into EAX register
end;            // Result is in EAX

{The Expand version of a 3 x 3 convolution.

 This approach is similar to the mirror version, except that it copies
 or duplicates the pixels from the edges to the same edge.  This is
 probably the best version if you're interested in quality, but don't need
 a tiled (seamless) image. }
procedure ConvolveE(ray: array of integer; z: word;
  aBmp: TBitmap);
var
  O, T, C, B : pPixelArray;  // Scanlines
  x, y : integer;
  tBufr : TBitmap; // temp bitmap for 'enlarged' image
begin
  tBufr := TBitmap.Create;
  tBufr.Width:=aBmp.Width+2;  // Add a box around the outside...
  tBufr.Height:=aBmp.Height+2;
  tBufr.PixelFormat := pf24bit;
  O := tBufr.ScanLine[0];   // Copy top corner pixels
  T := aBmp.ScanLine[0];
  O[0] := T[0];  // Left
  O[tBufr.Width - 1] := T[aBmp.Width - 1];  // Right
  // Copy top lines
  tBufr.Canvas.CopyRect(RECT(1,0,tBufr.Width - 1,1),aBmp.Canvas,
          RECT(0,0,aBmp.Width,1));

  O := tBufr.ScanLine[tBufr.Height - 1]; // Copy bottom corner pixels
  T := aBmp.ScanLine[aBmp.Height - 1];
  O[0] := T[0];
  O[tBufr.Width - 1] := T[aBmp.Width - 1];
  // Copy bottoms
  tBufr.Canvas.CopyRect(RECT(1,tBufr.Height-1,tBufr.Width - 1,tBufr.Height),
         aBmp.Canvas,RECT(0,aBmp.Height-1,aBmp.Width,aBmp.Height));
  // Copy rights
  tBufr.Canvas.CopyRect(RECT(tBufr.Width-1,1,tBufr.Width,tBufr.Height-1),
         aBmp.Canvas,RECT(aBmp.Width-1,0,aBmp.Width,aBmp.Height));
  // Copy lefts
  tBufr.Canvas.CopyRect(RECT(0,1,1,tBufr.Height-1),
         aBmp.Canvas,RECT(0,0,1,aBmp.Height));
  // Now copy main rectangle
  tBufr.Canvas.CopyRect(RECT(1,1,tBufr.Width - 1,tBufr.Height - 1),
    aBmp.Canvas,RECT(0,0,aBmp.Width,aBmp.Height));
  // bmp now enlarged and copied, apply convolve
  for x := 0 to aBmp.Height - 1 do begin  // Walk scanlines
    O := aBmp.ScanLine[x];      // New Target (Original)
    T := tBufr.ScanLine[x];     //old x-1  (Top)
    C := tBufr.ScanLine[x+1];   //old x    (Center)
    B := tBufr.ScanLine[x+2];   //old x+1  (Bottom)
  // Now do the main piece
    for y := 1 to (tBufr.Width - 2) do begin  // Walk pixels
      O[y-1].rgbtRed := Set255(
          ((T[y-1].rgbtRed*ray[0]) +
          (T[y].rgbtRed*ray[1]) + (T[y+1].rgbtRed*ray[2]) +
          (C[y-1].rgbtRed*ray[3]) +
          (C[y].rgbtRed*ray[4]) + (C[y+1].rgbtRed*ray[5])+
          (B[y-1].rgbtRed*ray[6]) +
          (B[y].rgbtRed*ray[7]) + (B[y+1].rgbtRed*ray[8])) div z
          );
      O[y-1].rgbtBlue := Set255(
          ((T[y-1].rgbtBlue*ray[0]) +
          (T[y].rgbtBlue*ray[1]) + (T[y+1].rgbtBlue*ray[2]) +
          (C[y-1].rgbtBlue*ray[3]) +
          (C[y].rgbtBlue*ray[4]) + (C[y+1].rgbtBlue*ray[5])+
          (B[y-1].rgbtBlue*ray[6]) +
          (B[y].rgbtBlue*ray[7]) + (B[y+1].rgbtBlue*ray[8])) div z
          );
      O[y-1].rgbtGreen := Set255(
          ((T[y-1].rgbtGreen*ray[0]) +
          (T[y].rgbtGreen*ray[1]) + (T[y+1].rgbtGreen*ray[2]) +
          (C[y-1].rgbtGreen*ray[3]) +
          (C[y].rgbtGreen*ray[4]) + (C[y+1].rgbtGreen*ray[5])+
          (B[y-1].rgbtGreen*ray[6]) +
          (B[y].rgbtGreen*ray[7]) + (B[y+1].rgbtGreen*ray[8])) div z
          );
    end;
  end;
  tBufr.Free;
end;

{The Ignore (basic) version of a 3 x 3 convolution.

 The 3 x 3 convolve uses the eight surrounding pixels as part of the
 calculation.  But, for the pixels on the edges, there is nothing to use
 for the top row values.  In other words, the leftmost pixel in the 3rd
 row, or scanline, has no pixels on its left to use in the calculations.
 This version just ignores the outermost edge of the image, and doesn't
 alter those pixels at all.  Repeated applications of filters will
 eventually cause a pronounced 'border' effect, as those pixels never
 change but all others do. However, this version is simpler, and the
 logic is easier to follow.  It's the fastest of the three in this
 application, and works great if the 'borders' are not an issue. }
procedure ConvolveI(ray: array of integer; z: word;
  aBmp: TBitmap);
var
  O, T, C, B : pPixelArray;  // Scanlines
  x, y : integer;
  tBufr : TBitmap; // temp bitmap
begin
  tBufr := TBitmap.Create;
  CopyMe(tBufr,aBmp);
  for x := 1 to aBmp.Height - 2 do begin  // Walk scanlines
    O := aBmp.ScanLine[x];      // New Target (Original)
    T := tBufr.ScanLine[x-1];     //old x-1  (Top)
    C := tBufr.ScanLine[x];   //old x    (Center)
    B := tBufr.ScanLine[x+1];   //old x+1  (Bottom)
  // Now do the main piece
    for y := 1 to (tBufr.Width - 2) do begin  // Walk pixels
      O[y].rgbtRed := Set255(
          ((T[y-1].rgbtRed*ray[0]) +
          (T[y].rgbtRed*ray[1]) + (T[y+1].rgbtRed*ray[2]) +
          (C[y-1].rgbtRed*ray[3]) +
          (C[y].rgbtRed*ray[4]) + (C[y+1].rgbtRed*ray[5])+
          (B[y-1].rgbtRed*ray[6]) +
          (B[y].rgbtRed*ray[7]) + (B[y+1].rgbtRed*ray[8])) div z
          );
      O[y].rgbtBlue := Set255(
          ((T[y-1].rgbtBlue*ray[0]) +
          (T[y].rgbtBlue*ray[1]) + (T[y+1].rgbtBlue*ray[2]) +
          (C[y-1].rgbtBlue*ray[3]) +
          (C[y].rgbtBlue*ray[4]) + (C[y+1].rgbtBlue*ray[5])+
          (B[y-1].rgbtBlue*ray[6]) +
          (B[y].rgbtBlue*ray[7]) + (B[y+1].rgbtBlue*ray[8])) div z
          );
      O[y].rgbtGreen := Set255(
          ((T[y-1].rgbtGreen*ray[0]) +
          (T[y].rgbtGreen*ray[1]) + (T[y+1].rgbtGreen*ray[2]) +
          (C[y-1].rgbtGreen*ray[3]) +
          (C[y].rgbtGreen*ray[4]) + (C[y+1].rgbtGreen*ray[5])+
          (B[y-1].rgbtGreen*ray[6]) +
          (B[y].rgbtGreen*ray[7]) + (B[y+1].rgbtGreen*ray[8])) div z
          );
    end;
  end;
  tBufr.Free;
end;

{The mirror version of a 3 x 3 convolution.

 The 3 x 3 convolve uses the eight surrounding pixels as part of the
 calculation.  But, for the pixels on the edges, there is nothing to use
 for the top row values.  In other words, the leftmost pixel in the 3rd
 row, or scanline, has no pixels on its left to use in the calculations.
 I compensate for this by increasing the size of the bitmap by one pixel
 on top, left, bottom, and right.  The mirror version is used in an
 application that creates seamless tiles, so I copy the opposite sides to
 maintain the seamless integrity.  }
procedure ConvolveM(ray: array of integer; z: word;
  aBmp: TBitmap);
var
  O, T, C, B : ^TPixelArray;  // Scanlines
  x, y : integer;
  tBufr : TBitmap; // temp bitmap for 'enlarged' image
begin
  tBufr := TBitmap.Create;
  tBufr.Width:=aBmp.Width+2;  // Add a box around the outside...
  tBufr.Height:=aBmp.Height+2;
  tBufr.PixelFormat := pf24bit;
  O := tBufr.ScanLine[0];   // Copy top corner pixels
  T := aBmp.ScanLine[0];
  O[0] := T[0];  // Left
  O[tBufr.Width - 1] := T[aBmp.Width - 1];  // Right
  // Copy bottom line to our top - trying to remain seamless...
  tBufr.Canvas.CopyRect(RECT(1,0,tBufr.Width - 1,1),aBmp.Canvas,
          RECT(0,aBmp.Height - 1,aBmp.Width,aBmp.Height-2));

  O := tBufr.ScanLine[tBufr.Height - 1]; // Copy bottom corner pixels
  T := aBmp.ScanLine[aBmp.Height - 1];
  O[0] := T[0];
  O[tBufr.Width - 1] := T[aBmp.Width - 1];
  // Copy top line to our bottom
  tBufr.Canvas.CopyRect(RECT(1,tBufr.Height-1,tBufr.Width - 1,tBufr.Height),
         aBmp.Canvas,RECT(0,0,aBmp.Width,1));
  // Copy left to our right
  tBufr.Canvas.CopyRect(RECT(tBufr.Width-1,1,tBufr.Width,tBufr.Height-1),
         aBmp.Canvas,RECT(0,0,1,aBmp.Height));
  // Copy right to our left
  tBufr.Canvas.CopyRect(RECT(0,1,1,tBufr.Height-1),
         aBmp.Canvas,RECT(aBmp.Width - 1,0,aBmp.Width,aBmp.Height));
  // Now copy main rectangle
  tBufr.Canvas.CopyRect(RECT(1,1,tBufr.Width - 1,tBufr.Height - 1),
    aBmp.Canvas,RECT(0,0,aBmp.Width,aBmp.Height));
  // bmp now enlarged and copied, apply convolve
  for x := 0 to aBmp.Height - 1 do begin  // Walk scanlines
    O := aBmp.ScanLine[x];      // New Target (Original)
    T := tBufr.ScanLine[x];     //old x-1  (Top)
    C := tBufr.ScanLine[x+1];   //old x    (Center)
    B := tBufr.ScanLine[x+2];   //old x+1  (Bottom)
  // Now do the main piece
    for y := 1 to (tBufr.Width - 2) do begin  // Walk pixels
      O[y-1].rgbtRed := Set255(
          ((T[y-1].rgbtRed*ray[0]) +
          (T[y].rgbtRed*ray[1]) + (T[y+1].rgbtRed*ray[2]) +
          (C[y-1].rgbtRed*ray[3]) +
          (C[y].rgbtRed*ray[4]) + (C[y+1].rgbtRed*ray[5])+
          (B[y-1].rgbtRed*ray[6]) +
          (B[y].rgbtRed*ray[7]) + (B[y+1].rgbtRed*ray[8])) div z
          );
      O[y-1].rgbtBlue := Set255(
          ((T[y-1].rgbtBlue*ray[0]) +
          (T[y].rgbtBlue*ray[1]) + (T[y+1].rgbtBlue*ray[2]) +
          (C[y-1].rgbtBlue*ray[3]) +
          (C[y].rgbtBlue*ray[4]) + (C[y+1].rgbtBlue*ray[5])+
          (B[y-1].rgbtBlue*ray[6]) +
          (B[y].rgbtBlue*ray[7]) + (B[y+1].rgbtBlue*ray[8])) div z
          );
      O[y-1].rgbtGreen := Set255(
          ((T[y-1].rgbtGreen*ray[0]) +
          (T[y].rgbtGreen*ray[1]) + (T[y+1].rgbtGreen*ray[2]) +
          (C[y-1].rgbtGreen*ray[3]) +
          (C[y].rgbtGreen*ray[4]) + (C[y+1].rgbtGreen*ray[5])+
          (B[y-1].rgbtGreen*ray[6]) +
          (B[y].rgbtGreen*ray[7]) + (B[y+1].rgbtGreen*ray[8])) div z
          );
    end;
  end;
  tBufr.Free;
end;

procedure ConvolveFilter(filternr,edgenr:integer;src:TBitmap);
var
  z : integer;
  ray : array [0..8] of integer;
  OrigBMP : TBitmap;              // Bitmap for temporary use
begin
  z := 1;  // just to avoid compiler warnings!
  case filternr of
    0 : begin // Laplace
      ray[0] := -1; ray[1] := -1; ray[2] := -1;
      ray[3] := -1; ray[4] :=  8; ray[5] := -1;
      ray[6] := -1; ray[7] := -1; ray[8] := -1;
      z := 1;
      end;
    1 : begin  // Hipass
      ray[0] := -1; ray[1] := -1; ray[2] := -1;
      ray[3] := -1; ray[4] :=  9; ray[5] := -1;
      ray[6] := -1; ray[7] := -1; ray[8] := -1;
      z := 1;
      end;
    2 : begin  // Find Edges (top down)
      ray[0] :=  1; ray[1] :=  1; ray[2] :=  1;
      ray[3] :=  1; ray[4] := -2; ray[5] :=  1;
      ray[6] := -1; ray[7] := -1; ray[8] := -1;
      z := 1;
      end;
    3 : begin  // Sharpen
      ray[0] := -1; ray[1] := -1; ray[2] := -1;
      ray[3] := -1; ray[4] := 16; ray[5] := -1;
      ray[6] := -1; ray[7] := -1; ray[8] := -1;
      z := 8;
      end;
    4 : begin  // Edge Enhance
      ray[0] :=  0; ray[1] := -1; ray[2] :=  0;
      ray[3] := -1; ray[4] :=  5; ray[5] := -1;
      ray[6] :=  0; ray[7] := -1; ray[8] :=  0;
      z := 1;
      end;
    5 : begin  // Color Emboss (Sorta)
      ray[0] :=  1; ray[1] :=  0; ray[2] :=  1;
      ray[3] :=  0; ray[4] :=  0; ray[5] :=  0;
      ray[6] :=  1; ray[7] :=  0; ray[8] := -2;
      z := 1;
      end;
    6 : begin  // Soften
      ray[0] :=  2; ray[1] :=  2; ray[2] :=  2;
      ray[3] :=  2; ray[4] :=  0; ray[5] :=  2;
      ray[6] :=  2; ray[7] :=  2; ray[8] :=  2;
      z := 16;
      end;
    7 : begin  // Blur
      ray[0] :=  3; ray[1] :=  3; ray[2] :=  3;
      ray[3] :=  3; ray[4] :=  8; ray[5] :=  3;
      ray[6] :=  3; ray[7] :=  3; ray[8] :=  3;
      z := 32;
      end;
    8 : begin  // Soften less
      ray[0] :=  0; ray[1] :=  1; ray[2] :=  0;
      ray[3] :=  1; ray[4] :=  2; ray[5] :=  1;
      ray[6] :=  0; ray[7] :=  1; ray[8] :=  0;
      z := 6;
      end;
(*
    10 : begin  // Photometric LowPass
      ray[0] :=  0.0625; ray[1] :=  0.125; ray[2] :=  0.0625;
      ray[3] :=  0.125;  ray[4] :=  0.25;  ray[5] :=  0.125;
      ray[6] :=  0.0625; ray[7] :=  0.125; ray[8] :=  0.0625;
      z := 1;
      end;   *)
    else exit;
  end;
  OrigBMP := TBitmap.Create;  // Copy image to 24-bit bitmap
  CopyMe(OrigBMP,src);
  case Edgenr of
    0 : ConvolveM(ray,z,OrigBMP);
    1 : ConvolveE(ray,z,OrigBMP);
    2 : ConvolveI(ray,z,OrigBMP);
//  else
//    Convolv
  end;
  src.Assign(OrigBMP);  //  Assign filtered image to src Image
  OrigBMP.Free;
end;

procedure UnsharpMasking(bmOrig: TBitmap; NBlur, NSpin: integer);
// A bmOrig n-szeresébõl kivonjuk a bmBlured (n-1)-szeresét
var
  bmBlured: TBitmap;
begin
  bmBlured := TBitmap.Create;
  bmOrig.PixelFormat  := pf24bit;
  bmBlured.PixelFormat:= pf24bit;
  bmBlured.Assign(bmOrig);
  GaussianBlur( bmBlured, NBlur );
  UnsharpMasking( bmOrig, bmBlured, NSpin );
end;

procedure UnsharpMasking(bmOrig,bmBlured: TBitmap; N: integer);
// A bmOrig n-szeresébõl kivonjuk a bmBlured (n-1)-szeresét
var
   H,V : Integer;
   WskO: ^Byte;
   WskB: ^Byte;
begin
  bmOrig.PixelFormat  := pf24bit;
  bmBlured.PixelFormat:= pf24bit;
  for V:=0 to bmOrig.Height-1 do
  begin
    WskO:=bmOrig.ScanLine[V];
    WskB:=bmBlured.ScanLine[V];
    for H:=0 to bmOrig.Width*3-1 do
    begin
         WskO^:=IntToByte( N*WskO^ - (N-1)*WskB^ );
         inc(WskO);
         inc(WskB);
    end;
  end;
end;

procedure CopyMe(tobmp: TBitmap; frbmp : TGraphic);
begin
  tobmp.Width := frbmp.Width;
  tobmp.Height := frbmp.Height;
  tobmp.PixelFormat := pf24bit;
  tobmp.Canvas.Draw(0,0,frbmp);
end;

procedure SortArray(var A : array of integer);
var
  i,j,v,x : integer;
begin
  for i:=0 to High(A) do begin
    v:=A[i]; x:=0;
    for j:=i+1 to 8 do begin
      if A[j]<v then begin v:=A[j]; x:=j; end;
    end;
    A[x]:=A[i]; A[i]:=v;
  end;
end;

function MedianAverage(var A : array of integer) : integer;
begin
  SortArray(A);
  Result:=A[High(A) div 2];
end;

procedure Median(src:TBitmap);
Type
    dArr = array[0..8] of integer;
var xx,yy,ii,jj : integer;
    dPixArray : dArr;
    dRow      : array[0..2] of PByteArray;
    SFill     : integer;
    dRowS     : PByteArray;
    SFillS    : integer;
    dCount    : integer;
    Intensity : integer;
    BMP       : TBitmap;
    Pix       : TPoint;
    pf        : TPixelFormat;

procedure SortArray(var a: array of integer; Lo,Hi: integer);
procedure sort(l,r: integer);
var
  i,j,x,y: integer;
begin
  i:=l; j:=r; x:=a[(l+r) DIV 2];
  repeat
    while a[i]<x do i:=i+1;
    while x<a[j] do j:=j-1;
    if i<=j then
    begin
      y:=a[i]; a[i]:=a[j]; a[j]:=y;
      i:=i+1; j:=j-1;
    end;
  until i>j;
  if l<j then sort(l,j);
  if i<r then sort(i,r);
end;
begin {quicksort};
  sort(Lo,Hi);
end;

function Median9(var A : array of integer) : integer;
var
  i,j,v,x : integer;
begin
  for i:=0 to 4 do begin
    v:=A[i]; x:=0;
    for j:=i+1 to 8 do begin
      if A[j]<v then begin v:=A[j]; x:=j; end;
    end;
    A[x]:=A[i]; A[i]:=v;
  end;
  Result:=A[4];
end;

begin

Try
  Try
     BMP    := TBitmap.Create;
     BMP.Assign(src);
     pf:=src.PixelFormat;
     BMP.PixelFormat := pf24bit;
     dRowS  := PByteArray(src.ScanLine[1]);
     SFillS := Integer(src.ScanLine[2]) - Integer(dRowS);
     for jj:=0 to 2 do
         dRow[jj]   := PByteArray(BMP.ScanLine[jj]);
     SFill  := Integer(BMP.ScanLine[1]) - Integer(BMP.ScanLine[0]);

     For yy:=1 to src.Height-2 do begin
         For xx:=3 to 3*(src.Width-2) do begin

             // Fill the 3*3 pixel kernel around the actual pixel
             for jj:=0 to 2 do
                 For ii:=-1 to 1 do begin
                     dPixArray[3*jj+(ii+1)] := dRow[jj][xx+3*ii];
                 end;

             // Calculate the median average
             dRowS[xx] := MedianAverage(dPixArray);
         end;
         for jj:=0 to 2 do
             Inc(Integer(dRow[jj]), SFill);
         Inc(Integer(dRowS), SFillS);
     end;

  finally
     BMP.Free;
  end;
except
end;

end;

procedure Median1(src:TBitmap);
Type
    dlist = array[0..8] of integer;
var xx,yy,ii,jj : integer;
    dPixArray : dList;
    dRow      : array[0..2] of PByteArray;
    SFill     : integer;
    dRowS     : PByteArray;
    SFillS    : integer;
    dCount    : integer;
    Intensity : integer;
    BMP       : TBitmap;
    Pix       : TPoint;

procedure SortArray(var a: dlist; Lo,Hi: integer);
procedure sort(l,r: integer);
var
  i,j,x,y: integer;
begin
  i:=l; j:=r; x:=a[(l+r) DIV 2];
  repeat
    while a[i]<x do i:=i+1;
    while x<a[j] do j:=j-1;
    if i<=j then
    begin
      y:=a[i]; a[i]:=a[j]; a[j]:=y;
      i:=i+1; j:=j-1;
    end;
  until i>j;
  if l<j then sort(l,j);
  if i<r then sort(i,r);
end;
begin {quicksort};
  sort(Lo,Hi);
end;

begin

Try
  Try
     BMP    := TBitmap.Create;
     BMP.Assign(src);
     BMP.PixelFormat := pf24bit;
     dRowS  := PByteArray(src.ScanLine[1]);
     SFillS := Integer(src.ScanLine[2]) - Integer(dRowS);
     SFill  := Integer(BMP.ScanLine[1]) - Integer(BMP.ScanLine[0]);
     for jj:=0 to 2 do begin
         dRow[jj]   := PByteArray(BMP.ScanLine[jj]);
     end;

     For yy:=1 to src.Height-2 do begin
         For xx:=3 to 3*(src.Width-2) do begin

             // Fill the 3*3 pixel kernel around the actual pixel
             for jj:=0 to 2 do
                 For ii:=-1 to 1 do begin
                     dPixArray[3*jj+(ii+1)] := dRow[jj][xx+3*ii];
                 end;

             // Calculate the median average
             SortArray(dPixArray,0,8);
             dRowS[xx] := dPixArray[4];
         end;
         for jj:=0 to 2 do
             Inc(Integer(dRow[jj]), SFill);
         Inc(Integer(dRowS), SFillS);
     end;

  finally
     BMP.Free;
  end;
except
end;

end;

// This medin 3x3 filter fast and efficient rutin: You need to use
procedure MedianRGB24(BMP: TBitmap);
var
  FD : TFastDib;
  Fr, Fg, Fb : TFastDib;
  x,y : integer;
  c   : TFColor;
begin
  FD := TFastDib.Create;
  FD.LoadFromHandle( BMP.Handle );
  if (FD.Width mod 16)<>0 then
     FD.Width := 16*Trunc((FD.Width+16)/16);

  FD.Draw(BMP.Handle,0,0);

  Fr := TFastDib.Create; Fr.SetSize(FD.Width, FD.Height, 8);
  Fg := TFastDib.Create; Fg.SetSize(FD.Width, FD.Height, 8);
  Fb := TFastDib.Create; Fb.SetSize(FD.Width, FD.Height, 8);

  // Szetszedi az RGB kepet BW kepekre
  for y := 0 to FD.Height-1 do for x := 0 to FD.Width-1 do begin
      c := FD.Pixels24[y,x];
      Fr.Pixels8[y,x] := c.r;
      Fg.Pixels8[y,x] := c.g;
      Fb.Pixels8[y,x] := c.b;
  end;

  // MMX-es median filterek a BW kepeken
  MedianFilter3x3MMXPlane(Fr.Bits, Fr.Width, Fr.Height);
  MedianFilter3x3MMXPlane(Fg.Bits, Fg.Width, Fg.Height);
  MedianFilter3x3MMXPlane(Fb.Bits, Fb.Width, Fb.Height);

  // Osszerakja az RGB kepet a BW kepekbol
  for y := 0 to FD.Height-1 do for x := 0 to FD.Width-1 do begin
      c.r := Fr.Pixels8[y,x];
      c.g := Fg.Pixels8[y,x];
      c.b := Fb.Pixels8[y,x];
      FD.Pixels24[y,x] := c;
  end;

  FD.Draw(BMP.Canvas.Handle,0,0);

  Fr.Free;
  Fg.Free;
  Fb.Free;
end;

procedure SSE_median3x3_RGB_x2(dst:pointer; linesize, count:integer);
asm
  push esi push edi push ebx push ebp

  mov ebp,linesize  //ebp: linesize   //must be 16 aligned
  mov ebx,count     //ebx: counterr
  mov ecx,dst       //ecx: dst

  //calc src addresses
  mov eax, ecx   sub eax, ebp   sub eax, 3   //src = dst-linesize-3
  lea edx, [eax+ebp]  //one line down

  //prepare 2*7*$10 bytes of temp buffers
  mov esi, esp   sub esi, 2*$70;   and esi,not $FFF    //align temps to a 4K page
  lea edi, [esi+$70]  //the other half of the temp buffers

  //fetch the first 2 rows to the temp buffer
  movups xmm0,[eax] movups xmm1,[eax+3] movups xmm2,[eax+6] movaps xmm3,xmm0 pminub xmm0,xmm1 pmaxub xmm3,xmm1 movups xmm1,[edx]
  movaps xmm4,xmm3 pminub xmm3,xmm2 movups xmm5,[edx+3] pmaxub xmm4,xmm2 movaps xmm2,xmm0 pminub xmm0,xmm3 pmaxub xmm2,xmm3
  movups xmm3,[edx+6] movaps xmm6,xmm1 pminub xmm1,xmm5 pmaxub xmm6,xmm5 movaps xmm5,xmm6 pminub xmm6,xmm3 pmaxub xmm5,xmm3
  movaps [esi],xmm0 movaps xmm3,xmm1 pminub xmm1,xmm6 movaps [esi+$10],xmm2 pmaxub xmm3,xmm6 movaps [esi+$20],xmm4
  movaps [esi+$30],xmm1 movaps [esi+$40],xmm3 movaps [esi+$50],xmm5

  xchg esi, edi         //swap the temp banks,
  lea eax, [eax+ebp*2]  //advance the source offsets
  lea edx, [edx+ebp*2]

  cmp ebx, 0;  jle @end
  @1:
    //inputs      : eax, edx  : image source row0, row1
    //temps       : esi, edi  : 2x 7*16bytes alternating buffers. Last elements are used as 2 temps.
    //output      : ecx       : 2x 16bytes of output (used as temp internally)
    //remarks     : edx = eax+linesize;  next iteration: swap(esi,edi); eax += linesize*2;
    //source plan : SSEDesign_1610_Median3x3
prefetch [eax+ebp*2]  prefetch [edx+ebp*2]  //2.2->2.9 GB/s
    movups xmm0,[eax] movups xmm1,[eax+3] movups xmm2,[eax+6] movaps xmm3,xmm0 pminub xmm0,xmm1 pmaxub xmm3,xmm1 movups xmm1,[edx]
    movaps xmm4,xmm3 pminub xmm3,xmm2 pmaxub xmm4,xmm2 movups xmm2,[edx+3] movaps xmm5,xmm0 pminub xmm0,xmm3 movups xmm6,[edx+6]
    pmaxub xmm5,xmm3 movaps xmm3,xmm1 pminub xmm1,xmm2 pmaxub xmm3,xmm2 movaps [esi],xmm0 movaps xmm2,xmm3 pminub xmm3,xmm6
    movaps [esi+$10],xmm5 pmaxub xmm2,xmm6 movaps [esi+$20],xmm4 movaps xmm6,xmm1 pminub xmm1,xmm3 pmaxub xmm6,xmm3
    movaps [esi+$30],xmm1 movaps xmm3,[edi+$20] movaps [esi+$40],xmm6 movaps xmm7,xmm2 pminub xmm2,xmm3 movaps [edi+$60],xmm2
    movaps [esi+$50],xmm7 movaps xmm7,[edi+$10] movaps xmm3,xmm6 pminub xmm6,xmm7 pmaxub xmm3,xmm7 movaps [esi+$60],xmm6
    pminub xmm4,xmm2 pmaxub xmm5,xmm6 movaps xmm6,[edi] pminub xmm5,xmm3 pmaxub xmm0,xmm1 pmaxub xmm0,xmm6 movaps xmm2,xmm4
lea eax, [eax+ebp*2]  //advance the source offsets
    pminub xmm4,xmm0 pmaxub xmm2,xmm0 pmaxub xmm4,xmm5 movaps xmm5,[edi+$50] movaps xmm0,[esi+$60] pminub xmm4,xmm2
lea edx, [edx+ebp*2]
    movaps xmm2,[edi+$40] movaps [ecx+ebp],xmm4 pmaxub xmm2,xmm0 movaps xmm0,[edi+$60] pminub xmm5,xmm0 pminub xmm2,xmm3
    movaps xmm3,[edi+$30] pmaxub xmm3,xmm1 pmaxub xmm3,xmm6 movaps xmm6,xmm5 pminub xmm5,xmm3 pmaxub xmm6,xmm3 pmaxub xmm5,xmm2
xchg esi, edi         //swap the temp banks,
    pminub xmm5,xmm6 movaps [ecx],xmm5
lea ecx, [ecx+ebp*2]  //advance the dst offset too

    dec ebx jg @1
  @end:
  pop ebp pop ebx pop edi pop esi
end;

procedure applyMedian3x3(b:TBitmap);


  procedure Error(s:string);begin raise exception.Create('applyMedian3x3: '+s); end;
  function AlignUp(i:integer;const align:integer):integer; asm sub edx,1;  add eax,edx;  not edx;  and eax,edx end;

var base,dst0, ycnt, xcnt, w, h, x, y, yblocksize, ysiz, st, en:integer;

const L3CacheLimit=4096 shl 10;
begin
  if b.PixelFormat<>pf24bit then error('24bit format expected');
  h:=b.Height;  w:=b.Width*3;  if (w and 15)<>0 then error('Scanline size must be a multiple of 16');
  base:=integer(b.ScanLine[h-1]);

  //calculate first aligned dstByte (on the 0th line first)
  dst0:=AlignUp(base+w+3, 16);  //center of 3x3 window
  xcnt:=((base+w*2-3)-dst0)div 16;
  ycnt:=h shr 1-1;

  yblocksize:=ycnt;
  while(yblocksize>4)and(yblocksize*w*2>L3CacheLimit) do yblocksize:=yblocksize shr 1;

  while ycnt>0 do begin
    ysiz:=min(ycnt, yblocksize);
    for x:=0 to xcnt-1 do begin
      SSE_median3x3_RGB_x2(pointer(dst0+x shl 4), w, ysiz);
    end;
    ycnt:=ycnt-ysiz;
    inc(dst0, ysiz*w*2);
  end;
end;


// SttarArray rutins
// ---------------------------------------------------------------------------

// Megkeresi a legfényesebb csillagot és visszaadja tömbbeli indexét
function GetMaxStar(ar: array of TStarRecord): integer;
var     i: integer;
        r: double;
begin
  r:=0;
  For i:=0 to High(ar) do begin
      if (ar[i].Radius>r) AND (not ar[i].Deleted) then begin
         r := ar[i].Radius;
         Result := i;
      end;
  end;
end;


function HistogramInit: TRGBColorsArray;
var i,j: integer;
begin
  For i:=0 to 2 do
   For j:=0 to 255 do
    Result[i,j] := 0; // RGB szinek tömbjét 0-ázza
end;

function GetRGBHistogram(Bitmap: TBitmap): TRGBColorsArray;
VAR
  i  :  INTEGER;
  j  :  INTEGER;
  Row:  pPixelArray;
begin
TRY
  Result := HistogramInit;
  Bitmap.PixelFormat := pf24bit;
  FOR j := 0 TO Bitmap.Height-1 DO
  BEGIN
    Row := Bitmap.Scanline[j];
    FOR i := 0 TO Bitmap.Width-1 DO
      WITH Row[i] DO
      BEGIN
        Inc(Result[0,rgbtRed]);
        Inc(Result[1,rgbtGreen]);
        Inc(Result[2,rgbtBlue]);
      END
  END;
FINALLY
END
end;


function RGBStatisticInit: TRGBStatisticArray;
var i,j: integer;
begin
  FOR j := 0 TO 2 DO
    FOR i := 0 TO 255 DO
        Result[j,i] := 0;
end;

// Kigyüjti a kép pixeleinek RGB statisztikáját %-os eloszlásban
function GetRGBStatistic(Bitmap: TBitmap): TRGBStatisticArray;
VAR
  i  :  INTEGER;
  j  :  INTEGER;
  Row:  pPixelArray;
  pixCount : integer;
  RGBColorsArray : TRGBColorsArray;
begin
TRY
  pixCount := Bitmap.Width * Bitmap.Height;
  if PixCount>0 then begin
  RGBColorsArray := GetRGBHistogram(Bitmap);
  FOR j := 0 TO 2 DO
    FOR i := 0 TO 255 DO
        Result[j,i] := 100*RGBColorsArray[j,i]/pixCount;
  end else
        Result := RGBStatisticInit;
FINALLY
END
end;

// Megnézi hogy a kép pixeleinek RGB maximuma, mely intenzitásértékeknél van.
// Valószínûleg ez adja az alapzaj szintjeit.
function GetRGBStatisticMax(Bitmap: TBitmap): TRGB24;
Var
  Colors  : TRGBStatisticArray;
  i,j     : integer;
  MaxArr  : array[0..2] of integer;
  maxCol  : double;
begin
  Colors := GetRGBStatistic(Bitmap);
  For i:=0 to 2 do begin
   MaxArr[i]:=0;
   maxCol   :=0;
   For j:=5 to 255 do begin
       if Colors[i,j]>MaxCol then begin
          maxCol := Colors[i,j];
          MaxArr[i]:=j;
       end;
   end;
  end;
  With Result do begin
       R := MaxArr[0];
       G := MaxArr[1];
       B := MaxArr[2];
  end;
end;

procedure AutoNoiseReduction(Bitmap: TBitmap; factor: DOUBLE);
var avgTres  : TRGB24;
    Row      : pRGBTripleArray;
    Rfactor,Gfactor,Bfactor: double;
    x,y      : integer;
begin
  // Meghaározzuk az átlagos RGB zaj szintet
  //  factor:=3; ÉRTÉKNÉL JÓ EREDMÉNY VÁRHATÓ
  avgTres := GetRGBStatisticMax(Bitmap);
  Rfactor := factor*(1+avgTres.R/255);
  Gfactor := factor*(1+avgTres.G/255);
  Bfactor := factor*(1+avgTres.B/255);
  // Az ez alatti zajt eltávolítjuk, levágjuk, majd visszaszorozzuk
  Bitmap.PixelFormat := pf24bit;
  for y:=0 to Bitmap.height-1 do begin
    Row:=Bitmap.scanline[y];
    for x:=0 to Bitmap.width-1 do begin
      WITH Row[x] DO
      BEGIN
        rgbtRed   := FloatToByte(Rfactor * (rgbtRed - avgTres.R));
        rgbtGreen := FloatToByte(Gfactor * (rgbtGreen - avgTres.G));
        rgbtBlue  := FloatToByte(Bfactor * (rgbtBlue - avgTres.B));
      END;
    end;
  end;
end;

procedure AutoNoiseReduction_1(Bitmap: TBitmap; factor: DOUBLE);
var avgTres  : TRGB24;
    Row      : pRGBTripleArray;
    Rfactor,Gfactor,Bfactor: double;
    x,y      : integer;
begin
  // Meghaározzuk az átlagos RGB zaj szintet
  //  factor:=3; ÉRTÉKNÉL JÓ EREDMÉNY VÁRHATÓ
  avgTres := GetRGBStatisticMax(Bitmap);
  Rfactor := factor*(1+avgTres.R/255);
  Gfactor := factor*(1+avgTres.G/255);
  Bfactor := factor*(1+avgTres.B/255);
  // Az ez alatti zajt eltávolítjuk, levágjuk, majd visszaszorozzuk
  Bitmap.PixelFormat := pf24bit;
  for y:=0 to Bitmap.height-1 do begin
    Row:=Bitmap.scanline[y];
    for x:=0 to Bitmap.width-1 do begin
      WITH Row[x] DO
      BEGIN
        rgbtRed   := FloatToByte(Rfactor * (rgbtRed - avgTres.R));
        rgbtGreen := FloatToByte(Gfactor * (rgbtGreen - avgTres.G));
        rgbtBlue  := FloatToByte(Bfactor * (rgbtBlue - avgTres.B));
      END;
    end;
  end;
end;

(* AUTOMATIC NOISE REDUCTION for Images
   ____________________________________
   Method     : 0=Classic; 1=Ballanced
   Factor     : Multiplicator
   BackLecel  : Bellow level is gray
   RGBParam   : Multiplicator RGB levels - 0.5...1...1.5
*)
procedure AutoNoiseReduction(Bitmap: TBitmap; Method: integer; factor: DOUBLE;
                             BackLevel: byte; RGBParam: TRGBParam);
var avgTres  : TRGB24;
    Row      : pRGBTripleArray;
    Rfactor,Gfactor,Bfactor: double;
    BF       : double;
    x,y      : integer;
begin
  // Meghaározzuk az átlagos RGB zaj szintet
  //  factor:=3; ÉRTÉKNÉL JÓ EREDMÉNY VÁRHATÓ
  avgTres := GetRGBStatisticMax(Bitmap);
  BF := (100-BackLevel)/100;
  Rfactor := RGBParam.RParam * factor*(1+avgTres.R/255);
  Gfactor := RGBParam.GParam * factor*(1+avgTres.G/255);
  Bfactor := RGBParam.BParam * factor*(1+avgTres.B/255);
  // Az ez alatti zajt eltávolítjuk, levágjuk, majd visszaszorozzuk
  Bitmap.PixelFormat := pf24bit;

  case Method of

  0:
  Begin
  for y:=0 to Bitmap.height-1 do begin
    Row:=Bitmap.scanline[y];
    for x:=0 to Bitmap.width-1 do begin
      WITH Row[x] DO
      BEGIN
        rgbtRed   := FloatToByte(Rfactor * (rgbtRed   - avgTres.R*BF));
        rgbtGreen := FloatToByte(Gfactor * (rgbtGreen - avgTres.G*BF));
        rgbtBlue  := FloatToByte(Bfactor * (rgbtBlue  - avgTres.B*BF));
      END;
    end;
  end;
  End;

  1:
  Begin
  Brightness(Bitmap,150);
  for y:=0 to Bitmap.height-1 do begin
    Row:=Bitmap.scanline[y];
    for x:=0 to Bitmap.width-1 do begin
      WITH Row[x] DO
      BEGIN
        if ((rgbtRed+rgbtGreen+rgbtBlue) / 3)<BackLevel then begin
             rgbtRed := BackLevel;
             rgbtGreen := BackLevel;
             rgbtBlue := BackLevel;
        end else begin
        if rgbtRed>0 then
        rgbtRed   := FloatToByte(Rfactor*((255-Rfactor)/rgbtRed)   * (rgbtRed - avgTres.R));
        if rgbtGreen>0 then
        rgbtGreen := FloatToByte(Gfactor*((255-Gfactor)/rgbtGreen) * (rgbtGreen - avgTres.G));
        if rgbtBlue>0 then
        rgbtBlue  := FloatToByte(Bfactor*((255-Bfactor)/rgbtBlue)  * (rgbtBlue - avgTres.B));
        end;
      END;
    end;
  end;

  End;
  End;
end;

// Auto White Ballance: Gray World Theory
procedure GrayAWB(bmp: TBitmap);
VAR rgbAVG: TRGB24;
    Row   :^TRGBTripleArray;
    x,y   : integer;
    corrR : double;
    corrB : double;
begin
  rgbAVG := GetBMPAverage( bmp, 200 );
  corrR  := rgbAVG.G / rgbAVG.R;
  corrB  := rgbAVG.G / rgbAVG.B;

  for y:=0 to (bmp.height-1) do begin
    Row:=bmp.scanline[y];
    for x:=0 to (bmp.width-1) do begin
      WITH Row[x] DO
      BEGIN
         rgbtRed   := FloatToByte( rgbtRed * corrR );
         rgbtBlue  := FloatToByte( rgbtBlue * corrB );
      END;
    end;
  end;

end;

procedure ChangeAll(var Bitmap: TBitmap; HIP: THistoParams);
var
  H,V: integer;
  Row: pPixelArray;
  Gray: byte;
begin
 Bitmap.PixelFormat:=pf24bit;
 for V:=0 to Bitmap.Height -1 do
  begin
      Row := Bitmap.ScanLine[V];
      for H:=0 to Bitmap.Width -1 do
      WITH Row[H] DO
      begin
           // RGB adjust
           rgbtRed   := FloatToByte(rgbtRed*HIP.R);
           rgbtGreen := FloatToByte(rgbtGreen*HIP.G);
           rgbtBlue  := FloatToByte(rgbtBlue*HIP.B);

           //Lightness: Wsk^:=IntToByte(Wsk^+((255-Wsk^)*Amount)div 255);
           //Darkness : Wsk^:=IntToByte(Wsk^-(Wsk^*Amount)div 255);
           if HIP.Brightness>0 then begin
              rgbtRed   := IntToByte(rgbtRed+((255-rgbtRed)*HIP.Brightness) div 255);
              rgbtGreen := IntToByte(rgbtGreen+((255-rgbtGreen)*HIP.Brightness) div 255);
              rgbtBlue  := IntToByte(rgbtBlue+((255-rgbtBlue)*HIP.Brightness) div 255);
           end;
           if HIP.Brightness<0 then begin
              rgbtRed   := IntToByte(rgbtRed-(rgbtRed*HIP.Brightness) div 255);
              rgbtGreen := IntToByte(rgbtGreen-(rgbtGreen*HIP.Brightness) div 255);
              rgbtBlue  := IntToByte(rgbtBlue-(rgbtBlue*HIP.Brightness) div 255);
           end;

           //Contrast : ByteWsk^:=IntToByte(ByteWsk^-((127-ByteWsk^)*Amount)div 255);
           if HIP.Contrast<>0 then begin
              rgbtRed   := IntToByte(rgbtRed-((127-rgbtRed)*HIP.Contrast) div 255);
              rgbtGreen := IntToByte(rgbtGreen-((127-rgbtGreen)*HIP.Contrast) div 255);
              rgbtBlue  := IntToByte(rgbtBlue-((127-rgbtBlue)*HIP.Contrast) div 255);
           end;

           //Saturat  :
           //    Gray:=(Wsk.rgbtBlue+Wsk.rgbtGreen+Wsk.rgbtRed) div 3;
           //    Wsk.rgbtRed:=IntToByte(Gray+(((Wsk.rgbtRed-Gray)*Amount)div 255));
           //    Wsk.rgbtGreen:=IntToByte(Gray+(((Wsk.rgbtGreen-Gray)*Amount)div 255));
           //    Wsk.rgbtBlue:=IntToByte(Gray+(((Wsk.rgbtBlue-Gray)*Amount)div 255));
           if HIP.Saturation<>255 then begin
              Gray:=(rgbtBlue+rgbtGreen+rgbtRed) div 3;
              rgbtRed   := IntToByte(Gray+(((rgbtRed-Gray)*HIP.Saturation)div 255));
              rgbtGreen := IntToByte(Gray+(((rgbtGreen-Gray)*HIP.Saturation)div 255));
              rgbtBlue  := IntToByte(Gray+(((rgbtBlue-Gray)*HIP.Saturation)div 255));
           end;
           //Gamma    : ByteWsk^:=FloatToByte(ByteWsk^*Amount);
           if HIP.Gamma<>1 then begin
              rgbtRed   := FloatToByte(rgbtRed*HIP.Gamma);
              rgbtGreen := FloatToByte(rgbtGreen*HIP.Gamma);
              rgbtBlue  := FloatToByte(rgbtBlue*HIP.Gamma);
           end;
          //Mono     :
           //    Gray := (rgbtRed + rgbtGreen + rgbtBlue) div 3;
           //    rgbtRed   := Gray;
           //    rgbtGreen := Gray;
           //    rgbtBlue  := Gray;
           if HIP.Mono then begin
              Gray:=(rgbtBlue+rgbtGreen+rgbtRed) div 3;
              rgbtRed   := Gray;
              rgbtGreen := Gray;
              rgbtBlue  := Gray;
           end;
           //Negativ  : WskByte^:= not WskByte^
           if HIP.Negative then begin
              rgbtRed   := not rgbtRed;
              rgbtGreen := not rgbtGreen;
              rgbtBlue  := not rgbtBlue;
           end;
      end;
  end;
end;


initialization
//  DecimalSeparator := '.';
  bmp:= TBitmap.Create;
  wbmp:= TBitmap.Create;
  Origbmp:= TBitmap.Create;
  ProcessList := TStringList.Create;

finalization
  bmp.Free;
  wbmp.Free;
  Origbmp.Free;
  ProcessList.Free;

end.

(*
		/// <summary>
		/// This function used to detect edges on Input image using standard deviation.
		/// </summary>
		/// <param name="SrcImage"></param>
		/// <returns></returns>
		///
		private Bitmap LoG12x12(Bitmap SrcImage)
		{
			double[,] MASK = new double[12, 12] {
								{-0.000699762,	-0.000817119,	-0.000899703,	-0.000929447,	-0.000917118,	-0.000896245,	-0.000896245,	-0.000917118,	-0.000929447,	-0.000899703,	-0.000817119,	-0.000699762},
								{-0.000817119,	-0.000914231,	-0.000917118,	-0.000813449,	-0.000655442,	-0.000538547,	-0.000538547,	-0.000655442,	-0.000813449,	-0.000917118,	-0.000914231,	-0.000817119},
								{-0.000899703,	-0.000917118,	-0.000745635,	-0.000389918,	0.0000268,	0.000309618,	0.000309618,	0.0000268,	-0.000389918,	-0.000745635,	-0.000917118,	-0.000899703},
								{-0.000929447,	-0.000813449,	-0.000389918,	0.000309618,	0.001069552,	0.00156934,	0.00156934,	0.001069552,	0.000309618,	-0.000389918,	-0.000813449,	-0.000929447},
								{-0.000917118,	-0.000655442,	0.0000268,	0.001069552,	0.002167033,	0.002878738,	0.002878738,	0.002167033,	0.001069552,	0.0000268,	-0.000655442,	-0.000917118},
								{-0.000896245,	-0.000538547,	0.000309618,	0.00156934,	0.002878738,	0.003722998,	0.003722998,	0.002878738,	0.00156934,	0.000309618,	-0.000538547,	-0.000896245},
								{-0.000896245,	-0.000538547,	0.000309618,	0.00156934,	0.002878738,	0.003722998,	0.003722998,	0.002878738,	0.00156934,	0.000309618,	-0.000538547,	-0.000896245},
								{-0.000917118,	-0.000655442,	0.0000268,	0.001069552,	0.002167033,	0.002878738,	0.002878738,	0.002167033,	0.001069552,	0.0000268,	-0.000655442,	-0.000917118},
								{-0.000929447,	-0.000813449,	-0.000389918,	0.000309618,	0.001069552,	0.00156934,	0.00156934,	0.001069552,	0.000309618,	-0.000389918,	-0.000813449,	-0.000929447},
								{-0.000899703,	-0.000917118,	-0.000745635,	-0.000389918,	0.0000268,	0.000309618,	0.000309618,	0.0000268,	-0.000389918,	-0.000745635,	-0.000917118,	-0.000899703},
								{-0.000817119,	-0.000914231,	-0.000917118,	-0.000813449,	-0.000655442,	-0.000538547,	-0.000538547,	-0.000655442,	-0.000813449,	-0.000917118,	-0.000914231,	-0.000817119},
								{-0.000699762,	-0.000817119,	-0.000899703,	-0.000929447,	-0.000917118,	-0.000896245,	-0.000896245,	-0.000917118,	-0.000929447,	-0.000899703,	-0.000817119,	-0.000699762}
							};

			double nTemp = 0.0;
			double c = 0;

			int mdl, size;
			size = 12;
			mdl = size/2;
			
			double min, max;
			min = max = 0.0;

			double sum = 0.0;
			double mean;
			double d = 0.0;
			double s = 0.0;
			int n = 0;

			Bitmap bitmap = new Bitmap(SrcImage.Width + mdl, SrcImage.Height + mdl);
			int l, k;

			BitmapData bitmapData = bitmap.LockBits(new Rectangle(0, 0, bitmap.Width, bitmap.Height), ImageLockMode.ReadWrite, PixelFormat.Format24bppRgb);
			BitmapData srcData = SrcImage.LockBits(new Rectangle(0, 0, SrcImage.Width, SrcImage.Height), ImageLockMode.ReadOnly, PixelFormat.Format24bppRgb);

			unsafe
			{
				int offset = 3;

				for (int colm = 0; colm < srcData.Height - size; colm++)
				{
					byte* ptr = (byte*)srcData.Scan0 + (colm * srcData.Stride);
					byte* bitmapPtr = (byte*)bitmapData.Scan0 + (colm * bitmapData.Stride);

					for (int row = 0; row < srcData.Width - size; row++)
					{
						nTemp = 0.0;

						min = double.MaxValue;
						max = double.MinValue;

						for (k = 0; k < size; k++)
						{
							for (l = 0; l < size; l++)
							{
								byte* tempPtr = (byte*)srcData.Scan0 + ((colm + l) * srcData.Stride);
								c = (tempPtr[((row + k) * offset)] + tempPtr[((row + k) * offset) + 1] + tempPtr[((row + k) * offset) + 2]) / 3;

								nTemp += (double)c * MASK[k, l];

							}
						}

						sum += nTemp;
						n++;
					}
				}
				mean = ((double)sum / n);
				d = 0.0;

				for (int i = 0; i < srcData.Height - size; i++)
				{
					byte* ptr = (byte*)srcData.Scan0 + (i * srcData.Stride);
					byte* tptr = (byte*)bitmapData.Scan0 + (i * bitmapData.Stride);

					for (int j = 0; j < srcData.Width - size; j++)
					{
						nTemp = 0.0;

						min = double.MaxValue;
						max = double.MinValue;

						for (k = 0; k < size; k++)
						{
							for (l = 0; l < size; l++)
							{
								byte* tempPtr = (byte*)srcData.Scan0 + ((i + l) * srcData.Stride);
								c = (tempPtr[((j + k) * offset)] + tempPtr[((j + k) * offset) + 1] + tempPtr[((j + k) * offset) + 2]) / 3;

								nTemp += (double)c * MASK[k, l];

							}
						}

						s = (mean - nTemp);
						d += (s * s);
					}
				}


				d = d / (n - 1);
				d = Math.Sqrt(d);
				d = d * 2;

				for (int colm = mdl; colm < srcData.Height - mdl; colm++)
				{
					byte* ptr = (byte*)srcData.Scan0 + (colm * srcData.Stride);
					byte* bitmapPtr = (byte*)bitmapData.Scan0 + (colm * bitmapData.Stride);

					for (int row = mdl; row < srcData.Width - mdl; row++)
					{
						nTemp = 0.0;

						min = double.MaxValue;
						max = double.MinValue;

						for (k = (mdl * -1); k < mdl; k++)
						{
							for (l = (mdl * -1); l < mdl; l++)
							{
								byte* tempPtr = (byte*)srcData.Scan0 + ((colm + l) * srcData.Stride);
								c = (tempPtr[((row + k) * offset)] + tempPtr[((row + k) * offset) + 1] + tempPtr[((row + k) * offset) + 2]) / 3;

								nTemp += (double)c * MASK[mdl + k, mdl + l];

							}
						}

						if (nTemp > d)
						{
							bitmapPtr[row * offset] = bitmapPtr[row * offset + 1] = bitmapPtr[row * offset + 2] = 255;
						}
						else
							bitmapPtr[row * offset] = bitmapPtr[row * offset + 1] = bitmapPtr[row * offset + 2] = 0;

					}
				}
			}

			bitmap.UnlockBits(bitmapData);
			SrcImage.UnlockBits(srcData);

			return bitmap;
		}

*)
