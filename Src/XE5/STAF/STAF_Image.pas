unit STAF_Image;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, contnrs, JPeg, ClipBrd, NewGeom, STAF_Imp, STAF_Loader,
  AlType, Math;

Type

  // Egy eredeti kép ill. paramétereinak tárolására

  TStoreMethodType = (smtNone, smtMemory, smtFile);

  // A kép tipusa
  TSTAFImageType    = ( itNone, itDark, itFlat, itLight, itNylonFlat,
                     itMasterDark, itMasterFlat, itMasterNylonFlat,
                     itResult );

  TMasterMethod = (mmMedian, mmAverage, mmMaximum, mmMinimum, mmDifference,
                   mmMoved,  mmAdditive );

  TMasterAlgoritm = (
     malMemoryBitmap,
     malMemoryStream,
     malBMPFile,
     malRGBFile,
     malGrupped
     );

  TAstroImage = record
     ID      : integer;
     DarkBMP : TBitMap;
     Row     : PByteArray;
     SFill   : integer;
  end;

  TAstroImageArray = array of TAstroImage;

  dlist = array[1..200] of integer;

  TPlateAlignMethod = (amNone,
                  amTwoBrigtness,
                  amThreeBrigtness,
                  alNeighbor);

  TPlateAlignParameters = record
     PlateSize          : TPoint;           // kép méretei x,y
     MaxAlignDifference : double;           // Ennyi eltérés megengedett. If 0 then indifferent
     RefStarCount       : integer;          // Ref. csillagok száma
     SensitiveRadius    : double;           // Ennyi eltérés megengedett az align csillag kereséskor
  end;

  TPlateTransform = packed record     // Record for maches of two images transformation
    Founded   : boolean;
    Cent      : TPoint2d;
    OffsetX   : double;
    OffsetY   : double;
    Rotate    : double;
    Zoom      : double;
  end;

  // Record for astro plates
  TPlateRecord = packed record
      ID              : integer;
      ImageType       : TSTAFImageType;
      FileName        : string[80];
      Sizes           : TPoint;
      Transzform      : TPlateTransform;
      Selected        : boolean;
      Deleted         : boolean;
  end;

  TImageStruct = packed record
    ID           : integer;        // Sorszám
    ImageType    : TSTAFImageType;     // Kép tipusa
    Filename     : string[80];     // Kép fájl neve
    ImageName    : string[20];     // Kép fantázia neve
    Sizes        : TPoint;         // Kép fizikai méretei: width,height
    Centrum      : TPoint2d;       // Középpont világkoordinátái
    RotAngle     : double;         // Elforgatás szöge
    Zoom         : double;         // Nagyítás
    Aspect       : double;         // Height = Aspect*Height
    Visible      : boolean;        // Látható-e a kép a térképen
  end;

  TCr2Header = packed record
      ByteOrder       : word;
      TIFFMagicWord   : word;
      TIFFIFDoffset   : integer;
      CR2MagicWord    : String[2];
      CR2MajorVersion : byte;
      CR2MinorVersion : byte;
      RAWIFDOffset    : word;
  end;

  TCR2Image = packed record
      image_width     : integer;
  end;

  TProcess = procedure(Sender: TObject; Percent: integer) of object;
  TFileProcess = procedure(Sender: TObject; id,fCount: integer) of object;
  TProcessMessage = procedure(Sender: TObject; Msg: string) of object;

  TStarList = class(TList)
  private
    FActualIndex: integer;
    FOnChange: TNotifyEvent;
    FActualStar: integer;
    procedure SetActualIndex(const Value: integer);
    procedure SetStar(idx: integer; const Value: TStarRecord);
    procedure SetActualStar(const Value: integer);
    function GetStaridx(idx: integer): TStarRecord;
  protected
  public
      pStar          : pStarRecord;       // Pointer to TStarRecord;
      dStar          : TStarRecord;       // Record for star data
      IndexList      : TStarIndexList;    // Index list for stars' indexes
      Stars          : TStarArray;        // Array for stars
      RefStars       : TRefStarArray;     // Array for reference stars

      refArray       : TPointArray;       // Reference stars (Intensity,mg)
      LinearFunction : Tegyenesfgv;       // Linear Regression for photometry

      destructor Destroy; override;

      function NewStarRec: TStarRecord;
      procedure NewList;
      function GetStar(N: integer): TStarRecord;
      function GetStarFromID(ID: integer): integer;
      procedure NewStar;
      procedure AddStar(Star: TStarRecord);
      procedure DeleteStar(N: integer);
      procedure Pack;
      function  GetStarPos(N: integer): TPoint2d;
      function  GetBoundsRect: TRect;
      procedure SortForRadius;
      procedure Transform(Cent: TPoint2d; dx,dy,Angle: double);
      procedure IndexForDistance(x,y: double);
      procedure SelectAll(All: boolean);
      procedure DeleteAll(All: boolean);

      procedure DeleteAllRefSign;
      function  GetRefSignCount: integer;
      function  GoRefSign(No: integer): integer;
      function  NextRefSign(aktPos: integer): integer;

      function  AutoStarDetect(Bitmap: TBitmap; Del: boolean; hPass: byte): integer;
      procedure StarsDraw(Bitmap: TBitmap; sRect: TRect2d; col: TColor; filled: boolean);

      function IsStarInPos(x,y: double): integer; overload;
      function IsStarInPos(x,y: double; tures: double): integer; overload;
      function NearestStar(centX,centY: double; var Dist: double): integer;
      function BrightestStar: integer;
      function GetBrightestStarInCircle(centX,centY: double; var Dist: double): integer;
      function StarCountInRect(r: TRect2d): integer;
      function NeighborCount(N: integer; d: double; tures: double): integer;
      function GetNeighbors(N: integer; d, tures: double): TStarIndexList;
      function SelectRefStars( par: TPlateAlignParameters ): boolean;
      function SelectAloneStars(d: double): integer;

      function SetPlateAlignParams( parPlateSize    : TPoint;
                                    parMaxOffs      : double;
                                    parRefStarCount : integer;
                                    parSensitiveRadius : integer
                                    ): TPlateAlignParameters;

      procedure SaveListToFile(fn: string);
      procedure LoadListFromFile(fn: string);
      procedure SaveToFile(fn: string);
      procedure LoadFromFile(fn: string);
      procedure SaveToStream(Stream: TStream);
      procedure LoadFromStream(Stream: TStream);
      Function  SaveListToString: string;

      function  CalculateTotalPhotometry: boolean;

      property ActualIndex : integer read FActualIndex write SetActualIndex;
      property BoundsRect  : TRect read GetBoundsRect;
      property Star[idx: integer]: TStarRecord read GetStaridx write SetStar;
      property ActualStar  : integer read FActualStar write SetActualStar;
      property OnChange    : TNotifyEvent read FOnChange write FOnChange;
  end;



  TOrigImage = class(TPersistent)
  private
    FSizes: TPoint;
    FFileName: TFileName;
    FRotAngle: double;
    FZoom: double;
    FStoreMethodType: TStoreMethodType;
    FImageName: string;
    FCentrum: TPoint2d;
    FAspect: double;
    FID: integer;
    FVisible: boolean;
    FTexture: Cardinal;
    FImageType: TSTAFImageType;
    FImageStruct: TImageStruct;
    FSelected: boolean;
    FDeleted: boolean;
    FBMPFileName: TFileName;
    FAligned: boolean;
    FTransform: TPlateTransform;
    procedure SetSizes(const Value: TPoint);
    procedure ClearBitmap;
    procedure SetFileName(const Value: TFileName);
    procedure SetStoreMethodType(const Value: TStoreMethodType);
    function GetSizes: TPoint;
    procedure SetBMPFileName(const Value: TFileName);
  protected
  public
    BMP           : TBitmap;
    Transform     : TPlateTransform;
    StarList      : TStarList;          // List of stars
    imgSTM        : TMemoryStream;

    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    procedure Clear;
    function  LoadFromFile(fName: TFileName): boolean;
    function  SaveToFile(fName: TFileName): boolean;
    function  ReadStruFromStream(st: TStream): TImageStruct;
    function  WriteStruToStream(st: TStream): boolean;
    procedure CopyToClipboard;
    procedure PasteFromClipboard;
    function  GetImage(var bm: TBitmap): boolean;
    function  PutImage(bm: TBitmap): boolean;
    procedure InitImageStruct;
    function  GetImageStruct: TImageStruct;
    function  GetImageTypeString: string;
    procedure InitTransform;

    procedure SavePlateToBMP;
    procedure ReadScanlinesFromFile(n: integer);

    property ID             : integer   read FID          write FID;
    property Aligned        : boolean   read FAligned     write FAligned;
    property BMPFileName    : TFileName read FBMPFileName write SetBMPFileName;
    property FileName       : TFileName read FFileName    write SetFileName;
    property ImageName      : string    read FImageName   write FImageName;
    property ImageStruct    : TImageStruct read GetImageStruct;
    property ImageType      : TSTAFImageType read FImageType write FImageType;
    property StoreMethodType: TStoreMethodType read FStoreMethodType Write SetStoreMethodType;
    property Sizes          : TPoint read FSizes write SetSizes;
    property Centrum        : TPoint2d read FCentrum write FCentrum;  // Centrum on map
    property RotAngle       : double read FRotAngle write FRotAngle;  // Forgatás szöge
    property Zoom           : double read FZoom write FZoom;          // Nagyítás
    property Aspect         : double read FAspect write FAspect;
    property Texture        : Cardinal read FTexture write FTexture;  // Texture for OpenGL
    property Selected       : boolean read FSelected write FSelected default False;
    property Deleted        : boolean read FDeleted write FDeleted default False;
    property Visible        : boolean read FVisible write FVisible;
  end;


  // Adatforrás a képek kezelésére : az ImageView-ok innen veszik a képeket

  TSTAFCustomImageSourch = class(TComponent)
  private
    FFileName: TFileName;
    FImageIndex: integer;
    FStoreMethodType: TStoreMethodType;
    FProcess: TProcess;
    FFileProcess: TFileProcess;
    procedure SetFileName(const Value: TFileName);
    function GetMemoryUsage: integer;
    procedure SetStoreMethodType(const Value: TStoreMethodType);
    function GetItem(AIndex: integer): TOrigImage;
    function GetCount: integer;
  protected
    Loading   : boolean;
  public
    iList     : TList;         // List for original images and it's parameters
    FImage    : TOrigImage;
    constructor Create(AOwner: TComponent);override;
    destructor Destroy; override;
    function  MakeImage(Fname: string; ImageType : TSTAFImageType): integer;
    procedure Change(Sender: TObject);
    procedure Clear;
    procedure AddNewImage;
    function  AddImage(oim : TOrigImage): integer;
    function  AddImageFromFile(FileName: TFileName):boolean;
    function  AddImageFromClipboard:boolean;
    procedure Delete(AIndex:integer);
    procedure ChangeImage(AIndex1,AIndex2:integer);
    function  LoadFromFile(FileName: TFileName):boolean;
    function  SaveToFile(FileName: TFileName):boolean;
    function  GetImage(AIndex:integer;var bm: TBitmap): boolean;
    function  PutImage(AIndex:integer;var bm: TBitmap): boolean;
    procedure GetImageList(var stList: TStringList);
    procedure LoadImageList(FileName: TFileName);
    procedure SaveImageList(FileName: TFileName);

    function  GetMaxID: integer;
    function  GetImageByID(idx: integer): TOrigImage;

    // Visszadja az egyes képtipusok számát (Dark,Flat,Light)
    function  GetImageTypeCount(imType: TSTAFImageType): integer;

    property MemoryUsage :integer read GetMemoryUsage;
    property Items[AIndex:integer] : TOrigImage read GetItem;
  published
    property Count           : integer read GetCount;
    property FileName        : TFileName read FFileName   write SetFileName;
    property StoreMethodType : TStoreMethodType read FStoreMethodType Write SetStoreMethodType;
    property OnProcess       : TProcess read FProcess write FProcess; // Event for process percent
    property OnFileProcess   : TFileProcess read FFileProcess write FFileProcess; // Event for process for loding images
  end;

  TSTAFCustomAstroImageSourch = class(TSTAFCustomImageSourch)
  private
    FReferenceImageIndex: integer;
    FProcessMessage: TProcessMessage;
    FSTOP: boolean;
    FAlgoritm: TMasterAlgoritm;
    FActualIndex: integer;
    FChangeIndex: TFileProcess;
    FMethod: TMasterMethod;
    FImageType: TSTAFImageType;
    function GetDarkCount: integer;
    function GetFlatCount: integer;
    function GetLightCount: integer;
    function GetDarkItem(AIndex: integer): TOrigImage;
    function GetFlatItem(AIndex: integer): TOrigImage;
    function GetLightItem(AIndex: integer): TOrigImage;
    procedure SetSTOP(const Value: boolean);
    procedure SetActualIndex(const Value: integer);
    function GetTrueLightCount: integer;
  protected
  public
    PlateList      : TList;                         // List for images with transform
    AlignParams    : TPlateAlignParameters;         // Parameters for align
    PlateTransform : TPlateTransform;               // Result record after align
    TempBMP        : TBitmap;
    StarList       : TStarList;                     // Elsõ felvétel csillagai
    RefStarsArray  : array[0..5] of TRefStarArray;  // 6 Array for reference stars
    RefStars       : TRefStarArray;                 // Array for reference stars on 2. plate
    STMArr         : TMemoryStream;
    DarkArray      : TAstroImageArray;


    MasterDark  : TBitmap;
    MasterFlat  : TBitmap;
    MasterLight : TBitmap;

    DarkIndexList  : array of integer;
    FlatIndexList  : array of integer;
    LightIndexList : array of integer;

    constructor Create(AOwner: TComponent);override;
    destructor Destroy; override;

    procedure Init;              // Initialization at new project/plate collection
    procedure GenerateIndexes;
    function  GetImageOfType(iType: TSTAFImageType; AIndex:integer; var bm: TBitmap): boolean;
    function  PutImageOfType(iType: TSTAFImageType; AIndex:integer;var bm: TBitmap): boolean;
    function  GetIndex(iType: TSTAFImageType; AIndex:integer): integer;
    function  GetNo(AIndex: integer; var iType: TSTAFImageType): integer;
    function  IsLightIndex(AIndex: integer): boolean;

    procedure  SetDefaultPlateAlignParam;
    procedure  PlateTransformNull(var PlTran: TPlateTransform);
    procedure  GenerateStarlist(PlateIndex: integer; Intensity: byte); // Generate starlist fron 1-2 plates
    procedure  GetReferenceStarArrays;                // Get 3 ref.stars' array from 1. plate
    function   GetReferenceStars(PlateIndex: integer): TRefStarArray;
    function   AlignPlates(idx: integer): TPlateTransform;
    function   AlignAllPlates: boolean;
    procedure  RegisterImages;
    procedure  GenerateMaster(bm: TBitmap; dbm: TAstroImageArray; _method: TMasterMethod; iType: TSTAFImageType);
    function   MakeMasterDark: boolean;
    function   MakeMasterDarkMS: boolean;
    function   MakeMasterFlat: boolean;
    function   MakeMasterLight: boolean;
    procedure  MasterCorrection(bmp: TBitmap);               
    function   DoCompletProcess: boolean;

    property   DarkItems[AIndex:integer]  : TOrigImage read GetDarkItem;
    property   FlatItems[AIndex:integer]  : TOrigImage read GetFlatItem;
    property   LightItems[AIndex:integer] : TOrigImage read GetLightItem;

    property   DarkCount           : integer  read GetDarkCount;   // Dark-ok száma a képlistában
    property   FlatCount           : integer  read GetFlatCount;   // Flat-ok száma a képlistában
    property   LightCount          : integer  read GetLightCount;  // Light-ok száma a képlistában
    property   TrueLightCount      : integer  read GetTrueLightCount;  // Aligned Light-ok száma a képlistában

    property   ActualIndex         : integer  read FActualIndex write SetActualIndex;
    property   Algoritm            : TMasterAlgoritm read FAlgoritm write FAlgoritm;
    property   ImageType           : TSTAFImageType read FImageType write FImageType;
    property   Method              : TMasterMethod read FMethod write FMethod;
    property   ReferenceImageIndex : integer  read FReferenceImageIndex write FReferenceImageIndex;
    property   STOP                : boolean  read FSTOP write SetSTOP;
    property   OnProcessMessage    : TProcessMessage
                                   read FProcessMessage
                                   write FProcessMessage;
    property   OnChangeIndex       : TFileProcess read FChangeIndex write FChangeIndex;
  end;

  TSTAFAstroImageSourch = class(TSTAFCustomAstroImageSourch)
  published
    property   Method;
    property   ReferenceImageIndex;
    property   OnFileProcess;
    property   OnProcess;
    property   OnProcessMessage;
    property   OnChangeIndex;
  end;

  procedure Register;
  procedure GetMasterMethodText(list: TStrings);

Const   ImageTypeString  : array[0..8] of string =
                         ('None', 'Dark', 'Flat', 'Light', 'NylonFlat',
                         'MasterDark', 'MasterFlat', 'MasterNylonFlat',
                         'Result' );

  MasterMethodText : array[0..6] of string =
                   ('Median', 'Average', 'Maximum', 'Minimum', 'Difference',
                   'Moved',  'Additive' );

implementation

procedure Register;
begin
  RegisterComponents('StellaMAP', [TSTAFCustomImageSourch,TSTAFAstroImageSourch]);
end;

// ==========================================================================
   { TStarList }
// ==========================================================================

procedure TStarList.AddStar(Star: TStarRecord);
begin
  New(pStar);
  pStar^ := Star;
  Add(pStar);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TStarList.DeleteStar(N: integer);
var p: pStarRecord;
begin
  p:=Items[N];
  Dispose(p);
  Delete(N);
  if Assigned(FOnChange) then FOnChange(Self);
end;

// Delete all logical deleted stars
procedure TStarList.Pack;
var i: integer;
begin
  if Count>0 then
  for I:=Pred(Count) to 0 do
      if TStarRecord(Items[i]^).Deleted then DeleteStar(i);
  if Assigned(FOnChange) then FOnChange(Self);
end;

destructor TStarList.Destroy;
begin
  NewList;
  inherited;
end;

function TStarList.GetStar(N: integer): TStarRecord;
Var pS : pStarRecord;
begin
  if InRange(N,0,Pred(Count)) then begin
     pS := List[N];
     Result := pS^;
  end;
end;

// Result the star position index in the list from ID
function TStarList.GetStarFromID(ID: integer): integer;
VAR i: integer;
begin
     Result := -1;
     For i:=0 to Pred(Count) do begin
         if Star[i].ID = ID then begin
            Result := i;
            exit;
         end;
     end;
end;

function TStarList.GetStaridx(idx: integer): TStarRecord;
begin
  Result := GetStar(idx);
end;

function TStarList.GetStarPos(N: integer): TPoint2d;
begin
  Result := Point2d(TStarRecord(Items[N]^).x,TStarRecord(Items[N]^).y);
end;

function TStarList.GoRefSign(No: integer): integer;
VAR i,n: integer;
begin
     Result := -1;
     n := 0;
     For i:=0 to Pred(Count) do
         if Star[i].Refstar then begin
            Inc(n);
            if No=n then begin
               Result := i;
               ActualIndex := i;
               exit;
            end;
         end;
end;

procedure TStarList.NewList;
var i: integer;
begin
  if Count>0 then
  for I:=Pred(Count) to 0 do
      DeleteStar(i);
  LinearFunction.a := 0;
  LinearFunction.b := 0;
  Clear;
  if Assigned(FOnChange) then FOnChange(Self);
end;

// Creates a new TStarRecord with default values
procedure TStarList.NewStar;
var ds: TStarRecord;
    pS : pStarRecord;
begin
  ds := NewStarRec;
  AddStar(ds);
  if Assigned(FOnChange) then FOnChange(Self);
end;

// Fills a TStarRecord with default values
function TStarList.NewStarRec: TStarRecord;
begin
  With Result do begin
     ID       := 0;
     PixCount := 0;
     x        := 0;
     y        := 0;
     Radius   := 0;
     R        := 0;
     G        := 0;
     B        := 0;
     HalfRad  := 0;
     Intensity:= 0;
     mg       := 0;
     RA       := 0;
     DE       := 0;
     Selected := False;
     Deleted  := False;
     RefStar  := False;
  end;
end;

function TStarList.NextRefSign(aktPos: integer): integer;
VAR i,n: integer;
begin
     Result := -1;
     n := 0;
     For i:=aktPos to Pred(Count) do
         if Star[i].Refstar then begin
               Result := i;
               ActualIndex := i;
               exit;
         end;
end;

procedure TStarList.SaveListToFile(fn: string);
var i: integer;
    f: TextFile;
    Sr : TStarRecord;
    sor: string;
begin
Try
     AssignFile(F,fn);
     Rewrite(F);
     WriteLn(F,'; ID,X,Y,R');
     For i:=0 to Pred(Count) do begin
         sr := GetStar(i);
         sor := Inttostr(sr.ID)+','+FloatToStr(sr.x)+','+FloatToStr(sr.y)
                +','+FloatToStr(sr.R);
         WriteLn(F,sor);
     end;
finally
  CloseFile(F);
end;
end;

// Saves the starlist to string (e.x.: Memo1.Text := StarList1.SaveListToString)
Function TStarList.SaveListToString: string;
begin
  Result := '';
end;

procedure TStarList.LoadListFromFile(fn: string);
var i: integer;
    f: TextFile;
    Sr : TStarRecord;
    sor: string;
begin
Try
     AssignFile(F,fn);
     Rewrite(F);
     Repeat
           ReadLn(F,sor);
           sor := Trim(sor);
     Until sor[1]<>';';
     While not EOF(F) do begin
           ReadLn(F,sor);
           sor := Trim(sor);
//           Sr.ID := StrToFloat(
     end;
finally
  CloseFile(F);
end;
end;

procedure TStarList.SaveToFile(fn: string);
var i: integer;
    f: File of TStarRecord;
    Sr : TStarRecord;
    resu: integer;
begin
Try
     AssignFile(F,fn);
     Rewrite(F);
     For i:=0 to Pred(Count) do begin
         sr := GetStar(i);
         Write(F, sr);
     end;
finally
  CloseFile(F);
end;
end;

procedure TStarList.LoadFromFile(fn: string);
var i: integer;
    f: File of TStarRecord;
    Sr : TStarRecord;
    resu: integer;
begin
Try
     NewList;
     AssignFile(F,fn);
     Reset(F);
     While not EOF(f) do begin
         Read(F, sr );
         AddStar(sr);
     end;
finally
  CloseFile(F);
  if Assigned(FOnChange) then FOnChange(Self);
end;
end;


procedure TStarList.SaveToStream(Stream: TStream);
var i: integer;
    Sr : TStarRecord;
begin
  if Stream<>nil then begin
     Stream.Size := 0;
     For i:=0 to Pred(Count) do begin
         sr := GetStar(i);
         Stream.Write(sr, SizeOf(TStarRecord));
     end;
  end;
end;

procedure TStarList.LoadFromStream(Stream: TStream);
var i: integer;
    Sr : TStarRecord;
    n  : integer;
begin
  if Stream<>nil then begin
     NewList;
     Stream.Seek(0,0);
     n := Stream.Size div SizeOf(TStarRecord);
     For i:=0 to Pred(n) do begin
         Stream.Read(sr, SizeOf(TStarRecord));
         AddStar(sr);
     end;
  if Assigned(FOnChange) then FOnChange(Self);
  end;
end;


procedure TStarList.SetActualIndex(const Value: integer);
begin
  if InRange(Value,0,Pred(Count)) then begin
     FActualIndex := Value;
     pStar:=Items[Value];
     dStar := pStar^;
  end;
end;

procedure TStarList.SetActualStar(const Value: integer);
begin
  FActualStar := Value;
end;

// Sort for descending
procedure TStarList.SortForRadius;
var i,N: integer;
    sr,sr1 : TStarRecord;
    csere: boolean;
begin
  repeat
    csere := False;
    for i:=0 to Pred(Count-1) do begin
      sr := TStarRecord(Items[i]^);
      sr1:= TStarRecord(Items[i+1]^);
      if sr.Radius<sr1.Radius then begin
         csere := True;
         Exchange(i,i+1);
      end;
    end;
  until not csere;
end;

procedure TStarList.Transform(Cent: TPoint2d; dx, dy, Angle: double);
var i: integer;
    sr: TStarRecord;
    p : TPoint2d;
begin
    for i:=0 to Pred(Count) do begin
        sr := TStarRecord(Items[i]^);
        p  := Point2d(sr.x,sr.y);
        RelRotate2d(p,Cent,Angle);
        sr.x := p.x+dx;
        sr.y := p.y+dy;
        TStarRecord(Items[i]^) := sr;
    end;
end;

// Searc for nearest star index to x,y point : Result = listindex
function TStarList.NearestStar(centX,centY: double; var Dist: double): integer;
var i: integer;
    sr: TStarRecord;
    d: double;
begin
    Result := -1;
    Dist := 10E+8;
    for i:=0 to Pred(Count) do begin
      sr := TStarRecord(Items[i]^);
      if not sr.Deleted then begin
         d := KetPontTavolsaga(sr.x,sr.y,CentX,CentY);
         if d<=Dist then begin
            Dist := d;
            Result := i;
            if d<1 then exit;
         end;
      end;
    end;
end;

function TStarList.BrightestStar: integer;
var i: integer;
    sr: TStarRecord;
    R: double;
begin
    Result := -1;
    R := -1;
    for i:=0 to Pred(Count) do begin
      sr := TStarRecord(Items[i]^);
      if not sr.Deleted then
      if R<sr.Radius then begin
         R:=sr.Radius;
         Result := i;
      end;
    end;
end;


function TStarList.CalculateTotalPhotometry: boolean;
var i,n,refCount : integer;
    sr         : TStarRecord;
    a,b        : double;     // line parameters: y=a*x+b
    R          : double;     // Residual: Correlation Coefficient
    mg         : double;
begin
Try
    Result := True;
    refCount := GetRefSignCount;
    SetLength(refArray,refCount);
    n := 0;

    for I := 0 to Pred(Count) do begin
        sr := Star[i];
        if sr.Refstar then begin
           refArray[n] := Point2d(-2.5*Log10(sr.Intensity),sr.mg);
           Inc(n);
        end;
    end;

    // Linear Regression
    if LinearLeastSquares(refArray, a, b, R) then begin
       LinearFunction.a := a;
       LinearFunction.b := b;
    for I := 0 to Pred(Count) do begin
        sr := Star[i];
        if not sr.Refstar and (sr.Intensity>0) then begin
           sr.mg := a * (-2.5*Log10(sr.Intensity)) + b;
           Star[i] := sr;
        end;
    end;
    end;
except
    Result := False;
End;
end;

// Push the neighbor stars around the N Ids star, with d distance ring
// or if tures<0 then in the d radius circle
// Megjegyzi az N. csillag körüli d sugarú tures szélességû gyûrûban
//             vagy tures<0 esetén d sugarú körön belül
//             a csillagokat ill. azok indexeit
function TStarList.GetNeighbors(N: integer; d, tures: double): TStarIndexList;
var i,NO: integer;
    sr0,sr: TStarRecord;
    R: double;
    P: TPoint2d;
    aArr : array of integer;
begin
    SetLength(Result,1000);
    NO  := 0;
    sr0 := GetStar(N);
    P   := Point2d(sr0.x,sr0.y);
    for i:=0 to Pred(Count) do begin
      sr := GetStar(i);
      R  := RelDist2d(P,Point2d(sr.x,sr.y));
      if tures<=0 then
      if R<d then begin
         Result[NO] := i;
         Inc(NO);
      end;
      if tures>0 then
      if Abs(d-R)<tures then begin
         Result[NO] := i;
         Inc(NO);
      end;
    end;
    SetLength(Result,NO);
end;

function TStarList.GetRefSignCount: integer;
var i: integer;
begin
    Result := 0;
    if Count>0 then
    for i:=0 to Pred(Count) do
        if Star[i].Refstar then Inc(Result);
end;

// Counts the neighbor stars around the N Ids star, with d distance ring
// Megszámolja az N. csillag körüli d sugarú tures szélességû gyûrûban
//             vagy tures<0 esetén d sugarú körön belül
//             a csillagokat
function TStarList.NeighborCount(N: integer; d, tures: double): integer;
var i: integer;
    sr0,sr: TStarRecord;
    R: double;
    P: TPoint2d;
begin
    Result := 0;
    sr0 := GetStar(N);
    P   := Point2d(sr0.x,sr0.y);
    for i:=0 to Pred(Count) do begin
    if i<>N then begin
      sr := GetStar(i);
      R  := RelDist2d(P,Point2d(sr.x,sr.y));
      if tures<=0 then
      if R<d then
         Inc(Result);
      if tures>0 then
      if Abs(d-R)<tures then
         Inc(Result);
    end;
    end;
end;

// Select the alone stars (none stars in d radius)
// Egyedülálló csillagok kiválasztása

function TStarList.SelectAloneStars(d: double): integer;
var i: integer;
begin
     Result := 0;
     SelectAll(False);
     if d>0 then
          For i:=0 to Pred(Count) do
              if NeighborCount(i,d,0)=0 then begin
                 TStarRecord(Items[i]^).Selected := True;
                 Inc(Result);
              end;
end;

// Egy középpont körüli Dist sugarú körben kiválasztja a legfényesebb
//     csillagot és visszaadja az indexét

function TStarList.GetBrightestStarInCircle(centX, centY: double;
  var Dist: double): integer;
var i: integer;
    sr: TStarRecord;
    R: double;      // Csillag sugara
    d: double;      // Távolsága a cent-tól
    p: TPoint2d;
begin
    Result := -1;
    R := -1;
    P := Point2d(centX, centY);
    for i:=0 to Pred(Count) do begin
      sr := TStarRecord(Items[i]^);
      if not sr.Deleted then begin
         d  := RelDist2d(P,Point2d(sr.x,sr.y));
         if (d<Dist) and (R<sr.Radius) then begin
            R:=sr.Radius;
            Result := i;
         end;
      end;
    end;
end;

function TStarList.StarCountInRect(r: TRect2d): integer;
var i: integer;
    sr: TStarRecord;
begin
    Result := -1;
    for i:=0 to Pred(Count) do begin
      sr := TStarRecord(Items[i]^);
      if not sr.Deleted then
      if PontInKep(sr.x,sr.y,r) then
         Inc(Result);
    end;
end;

(*
   Csillagok kirajzolása
             Bitmap      : a kirajzolás felülete;
             sRect       : a kirajzolandó téglalap;
             col         : csillag színe
             Filled      : csillag körének kitöltése
*)
procedure TStarList.StarsDraw(Bitmap: TBitmap; sRect: TRect2d; col: TColor; filled: boolean);
var i: integer;
    RR: integer;
    csp: TPoint;
    Zoom : double;
begin
(*
Try
  if StarCount>0 then
  with Bitmap.Canvas do begin
       Pen.Color := col;
       Pen.Width := 1;
       Pen.Mode  := pmCopy;
       if filled then
          Brush.Style := bsClear
       else
          Brush.Style := bsSolid;
       Zoom := Bitmap.Width / (sRect.x2 - sRect.x1);

       For i:=0 to Count-1 do begin
         if PontInKep(StarArray[i].x,StarArray[i].y,sRect) then begin
           csp := Point( Round(Zoom*(StarArray[i].x-sRect.x1),
                         Round(Zoom*(StarArray[i].y-sRect.y1) );
           RR := Round(Zoom * StarArray[i].Radius);
           if RR<2 then RR:=2;
           Ellipse(csp.x-RR,
                   csp.y-RR,
                   csp.x+RR,
                   csp.y+RR);
           Rectangle(csp.x-1,
                   csp.y-1,
                   csp.x+1,
                   csp.y+1);
         end;
       end;
  end;
except
end;
*)
end;

// Searcing for star in tures radius around x,y position (deleted stars too)
// If found, then Result=ID, else -1
function TStarList.IsStarInPos(x, y: double): integer;
var i: integer;
    sr: TStarRecord;
    d: double;
    R: double;
begin
    Result := -1;
    R      := MaxInt;
    for i:=0 to Pred(Count) do begin
      sr := TStarRecord(Items[i]^);
         d := KetPontTavolsaga(sr.x,sr.y,X,Y);
         if (d<=sr.Radius) or (d<4) then
            if sr.Radius<R then begin
               R := sr.Radius;
               Result := i;
            end;
    end;
end;

function TStarList.IsStarInPos(x, y, tures: double): integer;
var i: integer;
    sr: TStarRecord;
    d: double;
begin
    Result := -1;
    for i:=0 to Pred(Count) do begin
      sr := TStarRecord(Items[i]^);
         d := KetPontTavolsaga(sr.x,sr.y,X,Y);
         if d<=tures then begin
            Result := i;
            Exit;
         end;
    end;
end;

function TStarList.SetPlateAlignParams( parPlateSize    : TPoint;
                                        parMaxOffs      : double;
                                        parRefStarCount : integer;
                                        parSensitiveRadius : integer
                                        ): TPlateAlignParameters;
begin
  With Result do begin
     PlateSize          := parPlateSize;           // kép méretei x,y
     MaxAlignDifference := parMaxOffs;             // Ennyi eltérés megengedett. If 0 then indifferent
     RefStarCount       := parRefStarCount;        // Ref. csillagok száma
     SensitiveRadius    := parSensitiveRadius;
  end;
end;

// A felvétel x,y koord. pontjától növekvõ sorrendbe szedi a csillagok indexeit
// az eredeti listáben lévõ pozíciójukat kigyüjtve
procedure TStarList.IndexForDistance(x, y: double);
begin

end;

function TStarList.SelectRefStars( par: TPlateAlignParameters ): boolean;
var i,k         : integer;
    sr          : TStarRecord;
    rs          : TRefStarRecord;
    d,dd        : double;          // Távolság
    idx         : integer;
    ang0,ang    : double;          // szög
    Cent        : TPoint2d;        // A felvétel középpontja
    eStar       : TPoint;          // A felvétel középpontja
    refCount    : integer;
    rRect       : TRect2d;         // Vizsgálandó terület
    stCount     : integer;         // csillagok száma a vizsgált területen
begin
Result := False;

If Count>par.RefStarCount then begin

  SelectAll(False);
  DeleteAll(False);
  SetLength( RefStars, par.RefStarCount );

  // Kijelöljük a vizsgálandó területet
  Cent := Point2d(par.PlateSize.x/2,par.PlateSize.y/2);
  refCount := 0;

  // Kiválasztok refCount db. ref. csillagot

  // Vizsgálandó terület
  rRect := Rect2d(par.MaxAlignDifference,par.MaxAlignDifference,
                par.PlateSize.x-par.MaxAlignDifference,
                par.PlateSize.y-par.MaxAlignDifference );
  stCount := StarCountInRect(rRect);

  if stCount>3 then begin

  if stCount<par.RefStarCount then par.RefStarCount := stCount-1;

  // 2. Véletlenszerû ref. csillag választás
  dd:=10E+6;
  k:=0;
  Randomize;
  While (refCount<par.RefStarCount) and (k<100) do begin
        Repeat
              i := random(Count-1);
        Until NeighborCount(i,10,0)=0;
        sr := GetStar(i);
        if (not sr.Selected) and (sr.Radius>1) and (sr.Radius<20) then
        if PontInKep( sr.x,sr.y,rRect ) then
        begin
           TStarRecord(Items[i]^).Selected := True;
           With RefStars[refCount] do begin
                ID      := sr.ID;
                x       := sr.x;
                y       := sr.y;
                distance:= 0;          // Distance from 0. ref. star
                angle   := 0;          // Angle from 0. ref. star
                Radius  := sr.Radius;  // Brightness of ref. star
           end;
           d := RelDist2d(Cent,Point2d(sr.x,sr.y));
           if d<dd then begin
              dd := d;
              idx:= refCount;
           end;
           Inc(refCount);
           k:=0;
        end
        else Inc(k);
  end;

  // 0. ref csillag legyen a kép középpontjához legközelebbi
  rs := RefStars[0];
  if idx<>0 then begin
     RefStars[0]  := RefStars[Idx];
     RefStars[Idx]:= rs;
  end;


  // Az elsõ ref csillag legyen a legtávolabbi a 0.-tól
  dd:=0;
  rs := RefStars[0];
  for i:=1 to Pred(RefCount) do begin
      d := RelDist2d(Point2d(rs.x,rs.y),Point2d(RefStars[i].x,RefStars[i].y));
      if d>dd then begin
         dd := d;
         idx:= i;
      end;
  end;
  rs := RefStars[1];
  if idx<>1 then begin
     RefStars[1]  := RefStars[Idx];
     RefStars[Idx]:= rs;
  end;


  // RefStar csillagok távolság és szög értékeinek meghatározása
  Cent := Point2d(RefStars[0].x,RefStars[0].y);
  ang0 := RelAngle2d(Cent,Point2d(RefStars[1].x,RefStars[1].y));
  for i:=1 to High(RefStars) do begin
      d := RelDist2d(Cent,Point2d(RefStars[i].x,RefStars[i].y));
      RefStars[i].distance := d;
      ang  := RelAngle2d(Cent,Point2d(RefStars[i].x,RefStars[i].y));
      RefStars[i].angle    := Szogdiff(ang0,ang);
  end;
  RefStars[1].angle := 0;

  Result := True;

  end; // StCount

end;
end;

procedure TStarList.SelectAll(All: boolean);
var i: integer;
begin
    for i:=0 to Pred(Count) do
        TStarRecord(Items[i]^).Selected := All;
end;

procedure TStarList.DeleteAll(All: boolean);
var i: integer;
begin
    for i:=0 to Pred(Count) do
        TStarRecord(Items[i]^).Deleted := All;
  if Assigned(FOnChange) then FOnChange(Self);
end;


procedure TStarList.DeleteAllRefSign;
var i: integer;
begin
    for i:=0 to Pred(Count) do
        TStarRecord(Items[i]^).Refstar := False;
  if Assigned(FOnChange) then FOnChange(Self);
end;

function TStarList.GetBoundsRect: TRect;
var i: integer;
    sr: TStarRecord;
    xmin,ymin,xmax,ymax : double;
begin
    xmin := 10E+6; ymin := 10E+6;
    xmax := 10E-6; ymax := 10E-6;
    for i:=0 to Pred(Count) do begin
        sr := GetStar(i);
        if sr.x < xmin then xmin := sr.x;
        if sr.y < ymin then ymin := sr.y;
        if sr.x > xmax then xmax := sr.x;
        if sr.y > ymax then ymax := sr.y;
    end;
    if Count=0 then Result := Rect(0,0,0,0)
       else Result := Rect(Round(xmin),Round(ymin),Round(xmax),Round(ymax));
end;

// Fills a StarList from Bitmap with automatic StarDetect
//    if Del=True, then clear list before detect
Function TStarList.AutoStarDetect(Bitmap: TBitmap; Del: boolean; hPass: byte): integer;
var BMP        : TBitmap;               // For manipulation
    thRGB      : TStarRecord;
    xx,yy      : integer;
    Row,starRow: pRGBTripleArray;
    SFill      : integer;
    endLine    : boolean;
    i,j        : integer;
    starRect   : TRect;
    FirstRed,EndRed: integer;
    p          : TPoint2d;
    pCount     : integer;   // Pixels count in star
begin
Try
  Try
    Result := 0;
    if Del then NewList;
    BMP    := TBitmap.Create;
    BMP.PixelFormat := pf24bit;
    BMP.Canvas.Brush.Style:=bsSolid;
    BMP.Assign(Bitmap);
    BlackAndWhite(BMP);
    HighPassEx(BMP,hPass);
    for yy:=0 to BMP.Height-1 do begin
        Row := BMP.Scanline[yy];
        for xx:=0 to BMP.Width-1 do begin
            if Row[xx].rgbtRed = 255 then begin
               j := yy;
               starRect := Rect(xx,yy,xx,yy);
               BMP.Canvas.Brush.Color := clRed;
               BMP.Canvas.FloodFill(xx,yy,clWhite,fsSurface);
               endLine  := False;
               pCount := 0;
               while not endLine do begin
                     endLine := False;
                     starRow := BMP.Scanline[j];
                     FirstRed := -1;

                     for i:=0 to BMP.Width-1 do begin
                         if ((starRow[i].rgbtRed = 255) and (starRow[i].rgbtBlue = 0)) then
                           begin
                             if FirstRed<0 then FirstRed := i;
                             EndRed := i;
                             Inc(pCount);
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
               dStar := NewStarRec;
               with dStar do begin
                    ID := Result;
                    x := (starRect.Right + starRect.Left)/2;
                    y := (starRect.Bottom + starRect.Top)/2;
                    Radius := ((starRect.Right - starRect.Left)
                              +(starRect.Bottom - starRect.Top))/2;
                    Radius := SQRT(pCount);
                    p:=GetStarCentroid(Bitmap,x,y,Radius);
                    Radius := SQRT(pCount);
                    x := p.X+0.5;
                    y := p.y+0.5;
                    Deleted := False;
               end;
               AddStar(dStar);

               Inc(Result);
               StarCount := Result;
            end;
        end; // xx
    end; // yy
  finally
    BMP.Free;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
except
  if BMP<>nil then BMP.Free;
  exit;
end;
end;


// ============== end of TStarList ====================

constructor TOrigImage.Create(AOwner: TComponent);
begin
  FStoreMethodType := smtFile;
  imgSTM        := TMemoryStream.Create;
  BMP           := TBitmap.Create;
  BMP.PixelFormat := pf24bit;
  Self.StarList := TStarList.Create;
  FFileName     := '';
  FImageName    := '';
  FSizes        := Point(0,0);
  FCentrum      := Point2d(0,0);
  FRotAngle     := 0;
  FZoom         := 0;
  FAspect       := 1.0;
  FTexture      := 0;           // Ha <>0, akkor texture-ként szerepel OpenGL;
  FVisible      := True;
  FAligned      := False;
  InitTransform;
  InitImageStruct;
end;

destructor TOrigImage.Destroy;
begin
  BMP.Free;
  imgSTM.Free;
  inherited;
end;

procedure TOrigImage.SetStoreMethodType(const Value: TStoreMethodType);
begin
  FStoreMethodType := Value;
  imgSTM.Size := 0;
end;

procedure TOrigImage.SetBMPFileName(const Value: TFileName);
begin
  FBMPFileName := Value;
end;

procedure TOrigImage.SetFileName(const Value: TFileName);
Var EXT: string;
    W,H: word;
begin
  EXT := UpperCase(ExtractFileExt(Value));
  Case FStoreMethodType of
  smtFile :
  begin
     FFileName := Value;
     ClearBitmap;
     if EXT='.JPG' then GetJPGSize(Value,W,H);
        Sizes := Point(W,H);
  end;
  smtMemory :
  if LoadFromFile(Value) then begin
     FFileName := Value;
  end;
  end;
end;

function TOrigImage.LoadFromFile(fName: TFileName): boolean;
var ext: string;
    PIC: TPicture;
begin
Try
  Try
     Result := True;
     ext := UpperCase(ExtractFileExt(fName));
     Case StoreMethodType of
     smtFile :
             if  Pos(ext,'.CR2 .CRW')>0 then
                GetRAWTHumbnail( fName,BMP )
             else
                LoadImageFromFile( fName,BMP );
     smtMemory: LoadImageFromFile( fName,BMP );
     End;
  except
    Result := False;
    ClearBitmap;
    exit;
  end;
finally
  BMP.PixelFormat := pf24bit;
  Sizes := Point(BMP.Width,BMP.Height);
  FFileName := fName;
end;
end;

function TOrigImage.ReadStruFromStream(st: TStream): TImageStruct;
var ims:TImageStruct;
begin
  ims := ImageStruct;
  st.Read(ims,SizeOf(TImageStruct));
end;

function TOrigImage.WriteStruToStream(st: TStream): boolean;
var ims:TImageStruct;
begin
  ims := ImageStruct;
  st.Write(ims,SizeOf(TImageStruct));
end;

procedure TOrigImage.CopyToClipboard;
begin
  BMP.LoadFromStream(imgSTM);
  ClipBoard.Assign(BMP);
end;

procedure TOrigImage.PasteFromClipboard;
begin
  if Clipboard.HasFormat(CF_PICTURE) then begin
     BMP.Assign(ClipBoard);
     FStoreMethodType := smtNone;
  end;
end;

function TOrigImage.SaveToFile(fName: TFileName): boolean;
var ext: string;
    jpgBMP : TJpegImage;
begin
  Result := True;
  Case FStoreMethodType of
  smtFile   :
     LoadFromFile(FFileName);
  smtMemory :
     if BMP.WIDTH=0 THEN
        LoadFromFile(FFileName);
  end;
  Try
     Try
     ext := UpperCase(ExtractFileExt(fName));
     If ext='.BMP' then begin
        BMP.SaveToFile(fName);
     end;
     If ext='.JPG' then begin
        jpgBMP := TJpegImage.Create;
        jpgBMP.Assign(BMP);
        jpgBMP.SaveToFile(fName);
        jpgBMP.Free;
     end;
     except
       Result := False;
     end;
  finally
     if FStoreMethodType=smtFile then
        ClearBitmap;
  end;
end;

procedure TOrigImage.SetSizes(const Value: TPoint);
begin
  FSizes := Value;
end;

procedure TOrigImage.ClearBitmap;
begin
  BMP.Free;
  BMP := TBitmap.Create;
  BMP.PixelFormat := pf24bit;
end;

procedure TOrigImage.Clear;
begin
  ClearBitmap;
  imgSTM.SetSize(0);
end;

// A képet kinyeri és visszaadja a bm változóban
function TOrigImage.GetImage(var bm: TBitmap): boolean;
begin
Try
Result := False;
Case FStoreMethodType OF
smtFile :
   if LoadFromFile(FFileName) then
   begin
      Sizes := Point(BMP.Width,BMP.Height);
      bm.Assign(BMP);
      ClearBitmap;
      Result := True;
   end;
smtMemory :
   begin
      Sizes := Point(BMP.Width,BMP.Height);
      bm.Assign(BMP);
      Result := True;
   end;
end;
except
  Result := False;
end;
end;

// A bm képet elteszi. Így lehet képet cserélni.
function TOrigImage.PutImage(bm: TBitmap): boolean;
begin
  BMP.Assign(BM);
  FStoreMethodType := smtNone;
end;

function TOrigImage.GetImageStruct: TImageStruct;
begin
  With Result do begin
    ID           := FID;
    Filename     := FFilename;
    ImageName    := FImageName;
    ImageType    := FImageType;
    Sizes        := FSizes;
    Centrum      := FCentrum;
    RotAngle     := FRotAngle;
    Zoom         := FZoom;
    Aspect       := FAspect;
    Visible      := FVisible;
  end;
end;

function TOrigImage.GetSizes: TPoint;
begin
  Result := Point(0,0);
  Case FStoreMethodType of
  smtFile: if LoadFromFile(FFileName) then begin
              Result := Point(BMP.Width,BMP.Height);
              ClearBitmap;
           end;
  smtMemory:
           Result := Point(BMP.Width,BMP.Height);
  end;
end;

procedure TOrigImage.InitImageStruct;
begin
  with FImageStruct do begin
    ID           := 0;
    ImageType    := itNone;
    Filename     := '';
    ImageName    := '';
    Sizes        := Point(0,0);         // Kép fizikai méretei: width,height
    Centrum      := Point2d(0,0);       // Középpont világkoordinátái
    RotAngle     := 0;                  // Elforgatás szöge
    Zoom         := 1;                  // Nagyítás
    Aspect       := 1;                  // Height = Aspect*Height
    Visible      := True;               // Látható-e a kép a térképen
  end;
end;

procedure TOrigImage.InitTransform;
begin
  With Transform do begin
    Founded   := False;
    Cent      := Point2d(0,0);
    OffsetX   := 0;
    OffsetY   := 0;
    Rotate    := 0;
    Zoom      := 1;
  end;
end;


// Direct read n scanlines to memorystream
procedure TOrigImage.ReadScanlinesFromFile(n: integer);
begin
  imgSTM.SetSize(0);
end;

// Save image to BMP
procedure TOrigImage.SavePlateToBMP;
begin
  Case FStoreMethodType of
  smtNone  : begin
               BMP.SaveToFile(FFileName);
             end;
  smtFile  : begin
               LoadFromFile(FFileName);
               BMP.SaveToFile(FFileName);
               ClearBitmap;
             end;
  smtMemory: BMP.SaveToFile(FFileName);
  end;
end;


{ TSTAFCustomImageSourch }

constructor TSTAFCustomImageSourch.Create(AOwner: TComponent);
begin
  inherited;
  iList          := TList.Create;
end;

destructor TSTAFCustomImageSourch.Destroy;
begin
  Clear;
  iList.Free;
  inherited;
end;

procedure TSTAFCustomImageSourch.Change(Sender: TObject);
begin

end;

function TSTAFCustomImageSourch.GetCount: integer;
begin
  Result := iList.Count;
end;

procedure TSTAFCustomImageSourch.Clear;
var i: integer;
begin
  For i:=Pred(iList.Count) downto 0 do begin
      Delete(i);
  end;
end;

function TSTAFCustomImageSourch.LoadFromFile(FileName: TFileName): boolean;
begin

end;

function TSTAFCustomImageSourch.SaveToFile(FileName: TFileName): boolean;
begin

end;

procedure TSTAFCustomImageSourch.SetFileName(const Value: TFileName);
begin
  FFileName := Value;
end;

function TSTAFCustomImageSourch.AddImageFromFile(FileName: TFileName): boolean;
var oimg: TOrigImage;
begin
  oimg := TOrigImage.Create(Self);
  oimg.StoreMethodType := Self.FStoreMethodType;
  oimg.FileName := FileName;
  iList.Add(oimg);
end;

function TSTAFCustomImageSourch.AddImageFromClipboard: boolean;
var oimg: TOrigImage;
begin
  oimg := TOrigImage.Create(Self);
  oimg.PasteFromClipboard;
  iList.Add(oimg);
end;

// Add a new empty image to the image list
procedure TSTAFCustomImageSourch.AddNewImage;
var oimg: TOrigImage;
begin
  oimg := TOrigImage.Create(Self);
  oimg.ImageType := itNone;
  iList.Add(oimg);
end;

procedure TSTAFCustomImageSourch.Delete(AIndex: integer);
begin
  FImage := iList.Items[AIndex];
  FImage.Free;
  iList.Delete(AIndex);
end;

procedure TSTAFCustomImageSourch.ChangeImage(AIndex1, AIndex2: integer);
begin
  iList.Exchange(AIndex1, AIndex2);
end;


// Get an image from list by index
function TSTAFCustomImageSourch.GetImage(AIndex: integer;
  var bm: TBitmap): boolean;
begin
  Result := False;
  if (Aindex>-1) and (Aindex<iList.Count) then begin
     FImage := Items[Aindex];
     FImage.GetImage(bm);
     Result := True;
  end;
end;

// Changes an image at index of imagelist
function TSTAFCustomImageSourch.PutImage(AIndex: integer;
  var bm: TBitmap): boolean;
begin
  if (Aindex>-1) and (Aindex<iList.Count-1) then
     FImage := TOrigImage(iList.Items[Aindex]);
     FImage.PutImage(bm);
end;

// Compute the summary of memory usage of image streams
function TSTAFCustomImageSourch.GetMemoryUsage: integer;
var i: integer;
begin
  Result := 0;
  for i:=0 to iList.Count-1 do
      Result := Result + TOrigImage(iList.Items[i]).imgSTM.Size;
end;

procedure TSTAFCustomImageSourch.SetStoreMethodType(const Value: TStoreMethodType);
var i: integer;
begin
  FStoreMethodType := Value;
          for i:=0 to iList.Count-1 do
              TOrigImage(iList.Items[i]).StoreMethodType := Value;
  Case Value of
  smtFile :
          begin
          end;
  smtmemory:
          begin
          end;
  end;
end;

// Add a file names of images to a StringList
procedure TSTAFCustomImageSourch.GetImageList(var stList: TStringList);
var i: integer;
begin
  if stList<>nil then
   for i:=0 to iList.Count-1 do
       stList.Add(TOrigImage(iList.Items[i]).FileName);
end;

procedure TSTAFCustomImageSourch.LoadImageList(FileName: TFileName);
begin

end;

procedure TSTAFCustomImageSourch.SaveImageList(FileName: TFileName);
var i: integer;
    fs: TFileStream;
begin
Try
   fs:= TFileStream.Create(FileName,fmOpenWrite);
   for i:=0 to iList.Count-1 do begin
//       fs.Write(iList.Items[i].FileName);
   end;
finally
   fs.Free;
end;
end;

function TSTAFCustomImageSourch.GetItem(AIndex: integer): TOrigImage;
begin
  if (AIndex>-1) and (AIndex<iList.Count) then
     Result := TOrigImage(iList.Items[AIndex])
  else
     Result := nil;
end;

function TSTAFCustomImageSourch.GetImageTypeCount(imType: TSTAFImageType): integer;
var i    : integer;
begin
  Result := 0;
  For i:=0 to Pred(iList.Count) do
      if Items[i].ImageType = imType
         then
             Inc(Result);
end;

function TSTAFCustomImageSourch.AddImage(oim: TOrigImage): integer;
begin
Try
  iList.Add(oim);
  Result := iList.Count-1;
//  Changed := True;
except
  Result := -1;
end;
end;

function TSTAFCustomImageSourch.MakeImage(Fname: string;
  ImageType: TSTAFImageType): integer;
var oi: TOrigImage;
begin
Try
  oi := TOrigImage.Create(Self);
  oi.FImageType := ImageType;
  oi.StoreMethodType := StoreMethodType;
  oi.FileName  := Fname;
  oi.ID := GetMaxID+1;
  iList.Add(oi);
  Result := iList.IndexOf(oi);
except
  Result := -1;
end;
end;

function TSTAFCustomImageSourch.GetImageByID(idx: integer): TOrigImage;
var i: integer;
begin
  Result := nil;
  For i:=0 to Pred(iList.Count) do
      if TOrigImage(iList.Items[i]).ID = idx then begin
         Result := TOrigImage(iList.Items[i]);
         exit;
      end;
end;

function TSTAFCustomImageSourch.GetMaxID: integer;
var i,maxID : integer;
begin
  maxID := -1;
  For i:=0 to Pred(iList.Count) do begin
      FImage := TOrigImage(iList.Items[i]);
      if FImage.ID > maxID then
         maxID := FImage.ID;
  end;
  Result := maxID;
end;

{ TSTAFCustomAstroImageSourch }

constructor TSTAFCustomAstroImageSourch.Create(AOwner: TComponent);
begin
  inherited;
  TempBMP     := TBitmap.Create;
  StarList    := TStarList.Create;
  FImageType  := itNone;
  FAlgoritm   := malMemoryStream;
  FMethod     := mmAverage;
  ReferenceImageIndex := 0;
  Init;
  SetDefaultPlateAlignParam;
end;

destructor TSTAFCustomAstroImageSourch.Destroy;
begin
  TempBMP.Free;
  Init;
  if StarList<>nil then StarList.Free;
  inherited;
end;

procedure TSTAFCustomAstroImageSourch.Init;
var i: integer;
begin
  Clear;
  if MasterDark<>nil then begin
     MasterDark.FreeImage;
     MasterDark.Free;
     MasterDark := nil;
  end;
  if MasterFlat<>nil then begin
     MasterFlat.FreeImage;
     MasterFlat.Free;
     MasterFlat := nil;
  end;
  if MasterLight<>nil then begin
     MasterLight.FreeImage;
     MasterLight.Free;
     MasterLight := nil;
  end;
  For i:=0 to High(DarkArray) do
        DarkArray[i].DarkBMP.free;
  SetLength(DarkArray,0);
end;

(*
procedure TSTAFCustomAstroImageSourch.GenerateMaster(var bm: TBitmap;
  var dbm: TImageArray; _method: TMasterMethod; iType: TSTAFImageType);
var i,ii,n,yy,xx     : integer;
    dPixArray : dList;
    pix       : byte;
    dRow      : PByteArray;
    SFill     : integer;
    dCount    : integer;
    Intensity : integer;
    perc      : integer;

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
  dCount := High(dbm)+1;
  if dCount>0 then begin

     bm.PixelFormat := pf24bit;
     bm.Width := dbm[0].DarkBMP.width;
     bm.Height:= dbm[0].DarkBMP.Height;
     bm.PixelFormat := pf24bit;
     BM.Canvas.Brush.Color := clBlack;
     BM.Canvas.FillRect(BM.Canvas.Cliprect);

     dRow  := PByteArray(bm.ScanLine[0]);
     SFill := Integer(bm.ScanLine[1]) - Integer(dRow);
     for i:=0 to Pred(dCount) do begin
         dbm[i].Row   := PByteArray(dbm[i].darkBMP.ScanLine[0]);
         dbm[i].SFill := Integer(dbm[i].darkBMP.ScanLine[1]) - Integer(dbm[i].Row);
     end;

     for yy:=0 to Pred(bm.Height) do begin
             for xx:=0 to 3*Pred(bm.Width) do begin

                 for ii:=0 to Pred(dCount) do
                     dPixArray[ii]:=dbm[ii].Row[xx];

                 Case _Method of

                 // Median átlagolás
                 mmMedian:
                 begin
                      SortArray(dPixArray,0,dCount-1);
                      dRow[xx] := dPixArray[dCount div 2];
                 end;
                 // Average átlagolás
                 mmAverage:
                 begin
                      Intensity := 0;
                      for n:=1 to Pred(dCount) do
                          Intensity := Intensity + dPixArray[n];
                      dRow[xx] := Round(Intensity/(dCount-1));
                 end;
                 mmMaximum,mmMoved:
                 begin
                      SortArray(dPixArray,0,dCount-1);
                      dRow[xx] := dPixArray[dCount-1];
                 end;
                 mmMinimum:
                 begin
                      SortArray(dPixArray,0,dCount-1);
                      dRow[xx] := dPixArray[1];
                 end;

                 end; // Case

             end;
             for i:=0 to Pred(dCount) do
                 Inc(Integer(dbm[i].Row), dbm[i].SFill);
          Inc(Integer(dRow), SFill);
          if (yy mod 100)=0 then begin
             Application.ProcessMessages;
             if STOP then exit;
             If Assigned(FProcess) then FProcess(Self,Round(100*yy/bm.Height));
          end;
     end;
     If Assigned(FProcess) then FProcess(Self,100);
  end;
end;
*)

procedure TSTAFCustomAstroImageSourch.GenerateMaster(bm: TBitmap;
  dbm: TAstroImageArray; _method: TMasterMethod; iType: TSTAFImageType);
var i,ii,n,yy,xx     : integer;
    dPixArray : dList;
    pix       : byte;
    dRow      : PByteArray;
    SFill     : integer;
    dCount    : integer;
    Intensity : integer;
    perc      : integer;

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
  dCount := High(dbm)+1;
  if dCount>0 then begin

     bm.Width := dbm[0].DarkBMP.width;
     bm.Height:= dbm[0].DarkBMP.Height;
     bm.PixelFormat := pf24bit;
     BM.Canvas.Brush.Color := clBlack;
     BM.Canvas.FillRect(BM.Canvas.Cliprect);

     dRow  := PByteArray(bm.ScanLine[0]);
     SFill := Integer(bm.ScanLine[1]) - Integer(dRow);
     for i:=0 to Pred(dCount) do begin
         dbm[i].Row   := PByteArray(dbm[i].darkBMP.ScanLine[0]);
         dbm[i].SFill := Integer(dbm[i].darkBMP.ScanLine[1]) - Integer(dbm[i].Row);
     end;

     for yy:=0 to Pred(bm.Height) do begin
             for xx:=0 to 3*Pred(bm.Width) do begin

                 for ii:=0 to Pred(dCount) do
                     dPixArray[ii]:=dbm[ii].Row[xx];

                 Case _Method of

                 // Median átlagolás
                 mmMedian:
                 begin
                      SortArray(dPixArray,0,dCount-1);
                      dRow[xx] := dPixArray[dCount div 2];
                 end;
                 // Average átlagolás
                 mmAverage:
                 begin
                      Intensity := 0;
                      for n:=1 to Pred(dCount) do
                          Intensity := Intensity + dPixArray[n];
                      dRow[xx] := Round(Intensity/(dCount-1));
                 end;
                 mmMaximum,mmMoved:
                 begin
                      SortArray(dPixArray,0,dCount-1);
                      dRow[xx] := dPixArray[dCount-1];
                 end;
                 mmMinimum:
                 begin
                      SortArray(dPixArray,0,dCount-1);
                      dRow[xx] := dPixArray[1];
                 end;

                 end; // Case

             end;
             for i:=0 to Pred(dCount) do
                 Inc(Integer(dbm[i].Row), dbm[i].SFill);
          Inc(Integer(dRow), SFill);
          if (yy mod 100)=0 then begin
             Application.ProcessMessages;
             if STOP then exit;
             If Assigned(FProcess) then FProcess(Self,Round(100*yy/bm.Height));
          end;
     end;
     If Assigned(FProcess) then FProcess(Self,100);
  end;
end;


function TSTAFCustomAstroImageSourch.MakeMasterDark: boolean;
var i,k    : integer;
    DarkIndex: integer;   // Actual Dark index
begin
Try
  Result := True;
  FImageType := itDark;

  if DarkCount>0 then
  BEGIN

    if Assigned(FProcessMessage) then FProcessMessage(Self,'Open Darks');
    if MasterDark=nil then MasterDark := TBitmap.Create;
    SetLength(DarkArray,DarkCount);
    DarkIndex := 0;
    for i:=0 to Pred(DarkCount) do begin
        DarkArray[i].DarkBMP := TBitmap.Create;
        DarkArray[i].DarkBMP.PixelFormat := pf24bit;
    end;

    // Load Darks into DarkArray
    for i:=0 to Pred(iList.Count) do
      if Items[i].ImageType = itDark then begin
         if GetImage(i,DarkArray[DarkIndex].DarkBMP ) then begin
            DarkArray[DarkIndex].ID := Items[i].ID;
            PlateTransformNull(Items[i].Transform);
            If Assigned(FFileProcess) then FFileProcess(Self,DarkIndex,DarkCount);
            Inc(DarkIndex);
            Application.ProcessMessages;
            if STOP then exit;
            if Assigned(FProcessMessage) then FProcessMessage(Self,'Open Darks : '+inttostr(DarkIndex)+'/'+inttostr(DarkCount));
         end;
      end;

    if Assigned(FProcessMessage) then FProcessMessage(Self,'Making MasterDark');
    GenerateMaster( MasterDark, DarkArray, mmMaximum, FImageType );

    For i:=0 to High(DarkArray) do
        DarkArray[i].DarkBMP.free;
    SetLength(DarkArray,0);
    If Assigned(FProcess) then FProcess(Self,0);

  END;
except
    For i:=0 to High(DarkArray) do
        DarkArray[i].DarkBMP.free;
    SetLength(DarkArray,0);
    If Assigned(FProcess) then FProcess(Self,0);
    Result := False;
end;
end;

function TSTAFCustomAstroImageSourch.MakeMasterDarkMS: boolean;
var i    : integer;
    DarkIndex: integer;   // Actual Dark index
begin
Try
  Result := True;
  FImageType := itDark;

  if DarkCount>0 then
  BEGIN

    if Assigned(FProcessMessage) then FProcessMessage(Self,'Open Flats');
    if MasterDark=nil then MasterDark := TBitmap.Create;
    SetLength(DarkArray,DarkCount);
    DarkIndex := 0;
    for i:=0 to Pred(DarkCount) do begin
        DarkArray[i].DarkBMP := TBitmap.Create;
        DarkArray[i].DarkBMP.PixelFormat := pf24bit;
    end;

    // Load Darks into DarkArray
    for i:=0 to Pred(iList.Count) do
      if Items[i].ImageType = itDark then begin
         GetImage(i,DarkArray[DarkIndex].DarkBMP );
         DarkArray[DarkIndex].ID := Items[i].ID;
         If Assigned(FFileProcess) then FFileProcess(Self,DarkIndex,DarkCount);
         Inc(DarkIndex);
      end;

    GenerateMaster( MasterDark, DarkArray, mmMedian, FImageType );

    For i:=0 to High(DarkArray) do
        DarkArray[i].DarkBMP.free;

    SetLength(DarkArray,0);
    If Assigned(FProcess) then FProcess(Self,0);

  END;
except
  If Assigned(FProcess) then FProcess(Self,0);
  Result := False;
end;
end;

function TSTAFCustomAstroImageSourch.MakeMasterFlat: boolean;
var i    : integer;
    DarkIndex: integer;   // Actual Flat index
    fn : string;
begin
Try
  Result := True;
  FImageType := itFlat;

  if FlatCount>0 then
  BEGIN

    if Assigned(FProcessMessage) then FProcessMessage(Self,'Making MasterFlat');
    if MasterFlat=nil then MasterFlat := TBitmap.Create;
    SetLength(DarkArray,FlatCount);
    DarkIndex := 0;
    for i:=0 to Pred(FlatCount) do begin
        DarkArray[i].DarkBMP := TBitmap.Create;
        DarkArray[i].DarkBMP.PixelFormat := pf24bit;
    end;

    // Load Darks into DarkArray
    for i:=0 to Pred(iList.Count) do
      if Items[i].ImageType = itFlat then begin
         fn := Items[i].FileName;
         if GetImage(i,DarkArray[DarkIndex].DarkBMP ) then begin
            DarkArray[DarkIndex].ID := Items[i].ID;
            PlateTransformNull(Items[i].Transform);
            If Assigned(FFileProcess) then FFileProcess(Self,DarkIndex,FlatCount);
            Inc(DarkIndex);
            Application.ProcessMessages;
            if STOP then exit;
            if Assigned(FProcessMessage) then FProcessMessage(Self,'Open Flats : '+inttostr(DarkIndex)+'/'+inttostr(FlatCount));
          end;
      end;

    if Assigned(FProcessMessage) then FProcessMessage(Self,'Making MasterFlat');

    GenerateMaster( MasterFlat, DarkArray, mmMedian, itFlat );
//    SubtractDark( MasterFlat, MasterDark );

    For i:=0 to High(DarkArray) do
        DarkArray[i].DarkBMP.free;

    SetLength(DarkArray,0);

    If Assigned(FProcess) then FProcess(Self,0);
  END;
except
  If Assigned(FProcess) then FProcess(Self,0);
  Result := False;
end;
end;

function TSTAFCustomAstroImageSourch.MakeMasterLight: boolean;
var i    : integer;
    DarkIndex: integer;   // Actual Dark index
    R : TRect;
    Px,Py: integer;
    movedelta: integer;
    BMP1,BMP2: TBitmap;
    STR : TStretchBitmap;
begin
Try
  Result := True;
  FImageType := itLight;

  if TrueLightCount>0 then
  BEGIN

    if Assigned(FProcessMessage) then FProcessMessage(Self,'Open Lights ');
    if MasterLight=nil then MasterLight := TBitmap.Create;
    SetLength(DarkArray,TrueLightCount);
    DarkIndex := 0;
    movedelta := 0;

    // Load Darks into DarkArray
    for i:=0 to Pred(iList.Count) do
      if (Items[i].ImageType = itLight) and (Items[i].Transform.Founded) then begin
         if DarkArray[DarkIndex].DarkBMP=nil then begin
            DarkArray[DarkIndex].DarkBMP := TBitmap.Create;
            DarkArray[DarkIndex].DarkBMP.PixelFormat := pf24bit;
         end;
         GetImage(i,DarkArray[DarkIndex].DarkBMP );
         MasterCorrection(DarkArray[DarkIndex].DarkBMP);
         DarkArray[DarkIndex].ID := Items[i].ID;

         // Transform if needed
         PlateTransform := Items[i].Transform;
         if PlateTransform.founded then
         Try
            BMP1:= TBitmap.Create;
            BMP2:= TBitmap.Create;
            BMP1.Assign(DarkArray[DarkIndex].DarkBMP);
            BMP2.Assign(BMP1);

            STR := TStretchBitmap.Create;
            STR.SourceBitmap := BMP1;
            STR.TargetBitmap := BMP2;
            STR.BackgroundColor := clBlack;

            STR.RotateIt(RadToDeg(PlateTransform.Rotate));

            Px := -Round((BMP2.Width-BMP1.Width)/2);
            Py := -Round((BMP2.Height-BMP1.Height)/2);
            R  := Rect(Px,Py,Px+BMP2.Width,Py+BMP2.Height);

            if FMethod = mmMoved then begin
               PlateTransform.OffsetX := PlateTransform.OffsetX - movedelta;
               Inc(movedelta,4);
            end;
            OffsetRect(R,-Round(PlateTransform.OffsetX),-Round(PlateTransform.OffsetY));

            BMP1.Canvas.Brush.Color := clSilver;
            BMP1.Canvas.Brush.Style := bsSolid;
            BMP1.Canvas.Rectangle(BMP1.Canvas.ClipRect);

            BMP1.Canvas.Draw(R.Left,R.Top,BMP2);
            DarkArray[DarkIndex].DarkBMP.Assign(BMP1);
         finally
            STR.Free;
            BMP1.Free;
            BMP2.Free;
         end;

         If Assigned(FFileProcess) then FFileProcess(Self,DarkIndex,LightCount);
         Inc(DarkIndex);
         Application.ProcessMessages;
         if STOP then exit;
         if Assigned(FProcessMessage) then FProcessMessage(Self,'Open Lights : '+inttostr(DarkIndex)+'/'+inttostr(LightCount));
      end;

    if Assigned(FProcessMessage) then FProcessMessage(Self,'Making MasterLight');

    GenerateMaster( MasterLight, DarkArray, FMethod, itLight );

//    AutoNoiseReduction( MasterLight,3 );

(*
    For i:=0 to High(DarkArray) do
        DarkArray[i].DarkBMP.free;
    SetLength(DarkArray,0);
*)
    If Assigned(FProcess) then FProcess(Self,0);
  END;
except
  If Assigned(FProcess) then FProcess(Self,0);
  Result := False;
end;
end;

function TSTAFCustomAstroImageSourch.DoCompletProcess: boolean;
begin
  GenerateIndexes;

  Case FAlgoritm of

  malMemoryBitmap :
  begin
       if GetImageTypeCount(itDark)>0 then
          MakeMasterDark;
       if GetImageTypeCount(itFlat)>0 then
          MakeMasterFlat;
       if GetImageTypeCount(itLight)>0 then
       begin
            AlignAllPlates;
            MakeMasterLight;
       end;
  end;

  malMemoryStream :
  begin
       if DarkCount>0 then
          MakeMasterDarkMS;
  end;

  End;
end;

// Default parameters definition for alignment methode
procedure TSTAFCustomAstroImageSourch.SetDefaultPlateAlignParam;
begin
  with AlignParams do begin
     RefStarCount       := 5;                  // Ref. csillagok száma
     MaxAlignDifference := 1000;               // Ennyi eltérés megengedett. If 0 then indifferent
     SensitiveRadius    := 2;                  // Ennyi eltérés megengedett az align csillag kereséskor
  end;
end;

procedure TSTAFCustomAstroImageSourch.PlateTransformNull(
  var PlTran: TPlateTransform);
begin
  With PlTran do begin
    Founded   := True;
    Cent      := Point2d(0,0);
    OffsetX   := 0;
    OffsetY   := 0;
    Rotate    := 0;
    Zoom      := 1;
  end;
end;

// Get the type image from list at Aindex;
// Ex. GetImageOfType(itLight,3,bmp)
//     A 4. Light képet adja, mivel 0-val kezdõdik a felsorolás
function TSTAFCustomAstroImageSourch.GetImageOfType(iType: TSTAFImageType;
  AIndex: integer; var bm: TBitmap): boolean;
var n,k,i: integer;
begin
  k := 0;
  n := GetImageTypeCount(iType);
  Result := (n>0) and (AIndex<n) and (AIndex>-1);
  if Result then
  for i:=0 to Pred(Count) do
      if (Items[i].ImageType = iType)
         then
              if k=AIndex then
              begin
                   GetImage(i,bm);
                   exit;
              end
              else Inc(k);
end;

function TSTAFCustomAstroImageSourch.PutImageOfType(iType: TSTAFImageType;
  AIndex: integer; var bm: TBitmap): boolean;
begin

end;

// Create index lists for dark,flat and light images ID
procedure TSTAFCustomAstroImageSourch.GenerateIndexes;
var i, dIDX,fIDX,lIDX : integer;
begin
    dIDX := 0; fIDX := 0; lIDX := 0;
    SetLength( DarkIndexList ,  GetImageTypeCount(itDark) );
    SetLength( FlatIndexList ,  GetImageTypeCount(itFlat) );
    SetLength( LightIndexList , GetImageTypeCount(itLight) );
    for i:=0 to Pred(Count) do begin
      if (Items[i].ImageType = itDark) then begin
         DarkIndexList[dIDX] := i;
         Inc(dIDX);
      end;
      if (Items[i].ImageType = itFlat) then begin
         FlatIndexList[fIDX] := i;
         Inc(fIDX);
      end;
      if (Items[i].ImageType = itLight) then begin
         LightIndexList[lIDX] := i;
         Inc(lIDX);
      end;
    end;
end;

function TSTAFCustomAstroImageSourch.GetDarkCount: integer;
begin
  Result := GetImageTypeCount(itDark);
end;

function TSTAFCustomAstroImageSourch.GetFlatCount: integer;
begin
  Result := GetImageTypeCount(itFlat);
end;

function TSTAFCustomAstroImageSourch.GetLightCount: integer;
begin
  Result := GetImageTypeCount(itLight);
end;

function TSTAFCustomAstroImageSourch.GetTrueLightCount: integer;
var i: integer;
begin
  // Return the count of aligned light frames
  Result := 0;
  For i:=0 to Pred(LightCount) do
      if LightItems[i].Transform.Founded
      then Inc(Result);
end;

function TSTAFCustomAstroImageSourch.GetDarkItem(
  AIndex: integer): TOrigImage;
begin
  GenerateIndexes;
  Result := Items[DarkIndexList[AIndex]];
end;

function TSTAFCustomAstroImageSourch.GetFlatItem(
  AIndex: integer): TOrigImage;
begin
  GenerateIndexes;
  Result := Items[FlatIndexList[AIndex]];
end;

function TSTAFCustomAstroImageSourch.GetLightItem(
  AIndex: integer): TOrigImage;
begin
  GenerateIndexes;
  Try
     FImage := Items[LightIndexList[AIndex]];
  except
     FImage := Items[LightIndexList[0]];
  end;
  IF FImage<>nil then
     MasterCorrection(FImage.BMP);
  Result := FImage;
end;

procedure TSTAFCustomAstroImageSourch.MasterCorrection(bmp: TBitmap);
begin
if bmp<>nil then
   if bmp.width>0 then begin
     if MasterDark<>NIL then
     if MasterDark.Width <> 0 then
            SubtractDark( BMP, MasterDark );
     if MasterFlat<>NIL then
     if MasterFlat.Width <> 0 then
            FlatCorrection( BMP, MasterFlat );
   end;
end;

procedure TSTAFCustomAstroImageSourch.SetSTOP(const Value: boolean);
begin
  FSTOP := Value;
end;

function TSTAFCustomAstroImageSourch.GetIndex(iType: TSTAFImageType;
  AIndex: integer): integer;
begin
  GenerateIndexes;
  Case iType of
  itDark  : Result := DarkIndexList[AIndex];
  itFlat  : Result := FlatIndexList[AIndex];
  itLight : Result := LightIndexList[AIndex];
  end;
end;

// Result True if AIndex in LightIndexList
function TSTAFCustomAstroImageSourch.IsLightIndex(AIndex: integer): boolean;
var i: integer;
begin
  GenerateIndexes;
  Result := False;
  For i:=0 to Pred(LightCount) do
      if AIndex = LightIndexList[i] then begin
         Result := True;
         Exit;
      end;
end;

// Result the relative No of image type lists and image type;
// AIndex : abszolut index in the list
function TSTAFCustomAstroImageSourch.GetNo(AIndex: integer; var iType: TSTAFImageType): integer;
var i: integer;
begin
  GenerateIndexes;
  Result := -1;
  iType  := items[AIndex].ImageType;
  if iType = itDark then
  For i:=0 to Pred(DarkCount) do
      if AIndex = DarkIndexList[i] then begin
         Result := i;
         Exit;
      end;
  if iType = itFlat then
  For i:=0 to Pred(FlatCount) do
      if AIndex = FlatIndexList[i] then begin
         Result := i;
         Exit;
      end;
  if iType = itLight then
  For i:=0 to Pred(LightCount) do
      if AIndex = LightIndexList[i] then begin
         Result := i;
         Exit;
      end;
end;

// Align and save all images into BMP work files
procedure TSTAFCustomAstroImageSourch.RegisterImages;
begin
   AlignAllPlates;
end;

procedure TSTAFCustomAstroImageSourch.SetActualIndex(const Value: integer);
begin
  FActualIndex := Value;
  if (Value>-1) and (Value<Count) then
     FImage := Items[Value]
  else
     FImage := nil;
  if Assigned(FChangeIndex) then FChangeIndex(Self,Value,Count);
end;

function TOrigImage.GetImageTypeString: string;
begin
  Result := ImageTypeString[Ord(ImageType)];
end;

procedure TSTAFCustomAstroImageSourch.GenerateStarlist(
  PlateIndex: integer; Intensity: byte);
Var oim       : TOrigImage;
begin
  GetImage( PlateIndex,TempBMP );
  oim := Items[PlateIndex];
  if oim.StarList=nil then oim.StarList:=TStarList.Create
        else oim.StarList.NewList;
  oim.StarList.AutoStarDetect( TempBMP,True,Intensity);
end;

function TSTAFCustomAstroImageSourch.GetReferenceStars(
  PlateIndex: integer): TRefStarArray;
begin
  LightItems[PlateIndex].StarList.SelectRefStars(AlignParams);
  Result := LightItems[PlateIndex].StarList.RefStars;
end;

procedure TSTAFCustomAstroImageSourch.GetReferenceStarArrays;
var i   : integer;
    oim : TOrigImage;
begin
  if Assigned(FProcessMessage) then FProcessMessage(Self,'GET REFERENCE STARS');
  oim := LightItems[ReferenceImageIndex];
  oim.Getimage(TempBMP);
  StarList.AutoStarDetect( TempBMP,True,200);
  AlignParams.PlateSize := oim.Sizes;
  if StarList.Count>0 then
  For i:=0 to High(RefStarsArray) do begin
      if StarList.SelectRefStars(AlignParams) then begin
         SetLength(RefStarsArray[i],High(StarList.RefStars)+1);
         RefStarsArray[i] := Copy( StarList.RefStars, 0, High(StarList.RefStars)+1 );
      end;
  end;
end;

function TSTAFCustomAstroImageSourch.AlignPlates(idx: integer): TPlateTransform;
var oim0,oim   : TOrigImage;
    sr         : TStarRecord;
    rsr        : TRefStarRecord;
    i,j        : integer;
    d,dd       : double;
    idx0       : integer;
    idxList    : TStarIndexList;
    sr1_0,sr1_1: TStarRecord;
    sr2_0,sr2_1: TStarRecord;
    cs1_0,cs1_1: TPoint2d;      // elsõ két ref.csillag koord-i az 1. felvételen
    cs2_0,cs2_1: TPoint2d;      // elsõ két ref.csillag koord-i az 2. felvételen
    cs         : TPoint2d;      // vizsgált csillag pozíció
    NewStarPos : TPoint2d;
    nNeighbors : integer;
    BaseAngle1 : double;        // az 1. felvételen a 0. és 1. ref. csillag szöge
    BaseAngle2 : double;        // az 2. felvételen a 0. és 1. ref. csillag szöge
    angleDif   : double;        // a 2. felvétel elforgatási szöge
    angle      : double;
    tures      : double;
    StarCount  : integer;
    kilep      : boolean;
    vanStar    : boolean;       // Ha talált megfelel ref.csillagot a 2. felvételen
    resStar    : TStarRecord;   // a megtalált 0. ref.star a 2. felvételen
    dx,dy      : double;
    Cent       : TPoint2d;      // Centrum of image;
begin

  oim0 := LightItems[ReferenceImageIndex];
  oim  := LightItems[idx];
  if oim<>nil then begin
     PlateTransformNull(oim.Transform);
     Cent  := Point2d(oim.Sizes.x/2,oim.Sizes.y/2);
     tures := AlignParams.SensitiveRadius;
  if High(RefStars)>0 then begin

        StarCount  := oim.StarList.Count;

        oim.StarList.SelectAll(False);
        oim.StarList.DeleteAll(False);

        // Kiveszem az eredet lista 0. ref. csillagának adatait

        sr1_0 := oim0.StarList.GetStar(RefStars[0].Id);
        sr1_1 := oim0.StarList.GetStar(RefStars[1].Id);
        cs1_0 := Point2d(sr1_0.x,sr1_0.y);
        cs1_1 := Point2d(sr1_1.x,sr1_1.y);
        BaseAngle1 := RelAngle2d(cs1_0,cs1_1);
        dd    := RefStars[1].distance;

   // Megkeresem a hozzá legközelebbi nem törölt csillagot a 2. listában

   kilep := False;
   While StarCount>0 do begin

         oim.StarList.SelectAll(False);

         // Veszem a 2. képen a legközelebbi csillagot
         idx0  := oim.StarList.NearestStar( cs1_0.x, cs1_0.y, d );
         sr2_0 := oim.StarList.getStar(idx0);
               // Offset értékek x,y
                dx    := sr2_0.x - cs1_0.x;
                dy    := sr2_0.y - cs1_0.y;
         TStarRecord(oim.StarList.Items[idx0]^).Selected := True;

         // Megvizsgáljuk, hogy a környezetében van-e ref.star csoport
         nNeighbors := oim.StarList.NeighborCount(idx0,dd,tures);
         if nNeighbors > 0 then begin
            // Vannak-e d távolságban szomszédai? Kigyüjti
            idxList := oim.StarList.GetNeighbors(idx0,dd,tures);
            nNeighbors := High(idxList);

            For i:=0 to nNeighbors do begin

                sr2_1 := oim.StarList.GetStar(idxList[i]);
                cs2_0 := Point2d(sr2_0.x,sr2_0.y);
                cs2_1 := Point2d(sr2_1.x,sr2_1.y);

                TStarRecord(oim.StarList.Items[sr2_1.ID]^).Selected := True;

                // További ref.csillagok illeszkedésének vizsgálata a 2. felvételen

                // veszem a 2. felvételen a 0.-1. csillagok relatív szögét
                BaseAngle2 := RelAngle2d(Point2d(sr2_0.x,sr2_0.y),Point2d(sr2_1.x,sr2_1.y));
                // képezem az 1.-2. felvétel bázis szög eltérését: Transform.rotate
                AngleDif   := Szogdiff(BaseAngle1,BaseAngle2);

                for j:=2 to High(oim0.StarList.RefStars) do begin
                    rsr := oim0.StarList.RefStars[j];
                    cs  := Point2d(rsr.x+dx,rsr.y+dy);
                    NewStarPos := cs;
                    RelRotate2D(NewStarPos,cs2_0,AngleDif);
                    if oim.StarList.IsStarInPos(NewStarPos.x,NewStarPos.y)>-1
                    then begin
                        Result.Founded := True;
                    end else begin
                        Result.Founded := False;
                        Break;
                    end;
                end;

                // Ha van és mindegyik illeszkedik, akkor
                if Result.Founded then begin
                   Result.Cent    := Point2d(sr2_0.x,sr2_0.y);
                   RelRotate2d(cs2_0,Cent,-AngleDif);
                   Result.OffsetX := cs2_0.x - cs1_0.x;
                   Result.OffsetY := cs2_0.y - cs1_0.y;
                   Result.Rotate  := AngleDif;
                   oim.StarList.DeleteAll(False);
                   Exit;
                end else
                   TStarRecord(oim.StarList.Items[idx0]^).Deleted := True;

            end; // For i

         end
         else
             // Ha nem megfelelõ csillag, akkor logikai törtlés
             TStarRecord(oim.StarList.Items[idx0]^).Deleted := True;
         Dec(StarCount);
   end; // while

   oim.StarList.DeleteAll(False);
   end;
   end;
//   if Result.Rotate>pi then Result.Rotate := Result.Rotate-2*pi;
end;

// Align the idx-tn image to ReferenceImage
function TSTAFCustomAstroImageSourch.AlignAllPlates: boolean;
var i,j,k     : integer;
    pt        : array[0..5] of TPlateTransform;
    pPar      : TPlateAlignParameters;
    x,y,r     : double;
begin
Try
  Result := True;
  PlateTransformNull(PlateTransform);
  GenerateIndexes;

  if LightCount>0 then
  BEGIN
        pPar := LightItems[ReferenceImageIndex].StarList.SetPlateAlignParams(
                LightItems[ReferenceImageIndex].Sizes,
                0.4*LightItems[ReferenceImageIndex].Sizes.y,5,2);
        SetLength(RefStars,5);
        GenerateStarList(LightIndexList[ReferenceImageIndex],200);
        GetReferenceStarArrays;
        RefStars := GetReferenceStars(ReferenceImageIndex);
        LightItems[ReferenceImageIndex].StarList.RefStars := RefStars;
        PlateTransform.Founded := True;
        LightItems[ReferenceImageIndex].Transform := PlateTransform;

    for i:=0 to Pred(LightCount) do
    BEGIN
        if Assigned(FProcessMessage) then FProcessMessage(Self,'ALIGN : '
                                     +IntToStr(i+1)+'/'+IntToStr(LightCount));
        If Assigned(FProcess) then FProcess(Self,Round(100*(i+1)/LightCount));

        if i<>ReferenceImageIndex then begin
           pPar := LightItems[i].StarList.SetPlateAlignParams(
                 LightItems[i].Sizes,
                 0.4*LightItems[i].Sizes.y,5,2);
           GenerateStarList(LightIndexList[i],150);
           // átlag számítás
           X := 0;
           Y := 0;
           R := 0;
           k := 0;
           for j:=0 to High(RefStarsArray) do begin
               PlateTransformNull( pt[i] );
               pt[i] := AlignPlates(i);
               if pt[i].Founded then begin
                  X := X + pt[i].OffsetX;
                  Y := Y + pt[i].OffsetY;
                  R := R + pt[i].Rotate;
                  Inc(k);
               end;
           end;
           if k>0 then begin
              PlateTransform.OffsetX := X/k;
              PlateTransform.OffsetY := Y/k;
              PlateTransform.Rotate  := R/k;
           end;
           PlateTransform.founded := k>1;
//           if PlateTransform.founded then
              LightItems[i].Transform := PlateTransform;
        end;

        Application.ProcessMessages;
        if STOP then exit;
      END;
  END;
  If Assigned(FProcess) then FProcess(Self,0);

except
  Result := False;
end;
end;
(*
function TSTAFCustomAstroImageSourch.AlignAllPlates: boolean;
var i,j,k     : integer;
    oim       : TOrigImage;
    pt        : array[0..5] of TPlateTransform;
    pPar      : TPlateAlignParameters;
    x,y,r     : double;
begin
Try
  Result := True;
  PlateTransformNull(PlateTransform);
  GenerateIndexes;
  GetReferenceStarArrays;

  if LightCount>0 then
  BEGIN
        pPar := LightItems[ReferenceImageIndex].StarList.SetPlateAlignParams(
                 LightItems[ReferenceImageIndex].Sizes,
                 0.5*LightItems[ReferenceImageIndex].Sizes.y,5,4);
        SetLength(RefStars,5);
        GenerateStarList(LightIndexList[ReferenceImageIndex],200);
        RefStars := GetReferenceStars(0);
        LightItems[ReferenceImageIndex].StarList.RefStars := RefStars;

    for i:=0 to Pred(LightCount) do
    BEGIN
        if Assigned(FProcessMessage) then FProcessMessage(Self,'ALIGN : '
                                     +IntToStr(i+1)+'/'+IntToStr(LightCount));
        If Assigned(FProcess) then FProcess(Self,Round(100*(i+1)/LightCount));
        if i<>ReferenceImageIndex then
           GenerateStarList(LightIndexList[i],150);
//        for j:=0 to High(RefStarsArray) do begin
            if i<>ReferenceImageIndex then begin
               PlateTransform := AlignPlates(i);
               LightItems[i].Transform := PlateTransform;
            end;
//        end;
        Application.ProcessMessages;
        if STOP then exit;
      END;
  END;
  If Assigned(FProcess) then FProcess(Self,0);

except
  Result := False;
end;
end;
*)

procedure TStarList.SetStar(idx: integer; const Value: TStarRecord);
begin
  TStarRecord(Items[idx]^) := Value;
end;

procedure GetMasterMethodText(list: TStrings );
var i: integer;
begin
  List.Clear;
  for I := 0 to High(MasterMethodText) do
      list.Add( MasterMethodText[i] );
end;

end.



