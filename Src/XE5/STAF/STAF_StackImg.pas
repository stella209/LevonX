unit STAF_StackImg;
(*
     TCustomStackedObject   by Agócs László StellaSOFT 2009 - Free Licence!
     ____________________
     Delphi object for store multiple graphic into the single stacked file.
     The stack file contains: Dark, Flat, NylonFlat, Light types of images;
     Stack file structure:

     Header: TStackHeader

     Data blocks continouslíy:
          1: Data description record (TImageDesc) +
          2: Bitmap (3 byte/pixel)

     Bitmap: TImageDesc record + Bitmap stored in bellow format
             R,G,B bytes contiously  (Enables only 24bit/pixel images;
             E.g.: if image area is 100x200 pixel the image size is
             20000 * 3 = 60000 bytes.

             Pixel Address = StartAddress + 3*PixelNo

             Read into TRGBTriple record defined in Windows unit.

     It is can create composite master frames:
     1. No offset: all images are totally overlapped: CreateMaster();
     2. Mosaic: All images in the union rectangle;
     3. Common: The result imege contains only the overlapped region of the images

*)

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  ClipBrd, CommCtrl, ExtCtrls, Jpeg, STAF_Imp;

Const
    HeaderString = 'STAF Stacked Images';

Type
    TImageType    = (itNone, itLight, itDark, itFlat, itNylonFlat,
                     itMasterDark, itMasterFlat, itMasterNylonFlat,
                     itResult );

    TMasterMethod = (mmAdditive, mmAverage, mmMedian, mmDifference,
                     mmMax
                     );

    TDescBoolField = (dbNone,dbInStack,dbRegistered,dbSelected,dbDeleted,dbEdited);

    TDescSelectBoolMode = (dsbNone, dsbAll, dsbNot, dsbInvers);

    TStackHeader   = packed record
      HeadStr       : string[24];     // For HeaderString;
      ImageCount    : word;           // Count of Images in the stackfile
      BytePerPixel  : byte;           // 1,2,3,4 (8,16,24,32,48,64 bites)
      ProjectName   : string[80];     // Project file neve
    end;

    pImageDesc    = ^TImageDesc;
    TImageDesc    = packed record   // Image properties in the stackfile
      ID            : byte;         // Idenfify number
      FileName      : string[255];  // Name of image file with full path
      StartAddress  : Cardinal;     // First pixel Address in the file
      NextAddress   : Cardinal;     // Next Datablock Address in the file
      Size          : Cardinal;     // Size of image in byte
      bmpWidth      : word;         // Image width in pixel
      bmpHeight     : word;         // Image Height in pixel
      XOffset       : double;       // X offset
      YOffset       : double;       // Y offset
      Rotate        : double;       // Rotate the image around the origo(0;0)
      Zoom          : double;       // Zoom factor default = 1
      ExpTime       : TDateTime;    // Creation time: date+time
      ISO           : word;         // ISO Speed
      Exp           : single;       // Exposition time:
      ImageType     : TImageType;   // Image type
      Registered    : boolean;      // True if image registered
      inStack       : boolean;      // True if in the stack file
      Selected      : boolean;      // True if this item is selected
      Edited        : boolean;      // True if this item is edited
      Deleted       : boolean;      // True if this item is deleted
      Comment       : string[255];  // Comment for image
      Darked        : boolean;      // Dark eliminated
      Flatted       : boolean;      // Flat corrected
      Dommy         : array[0..27] of Byte;
    end;

    TStackStatistic = packed record   // Statistic record for imagetypes in stack file
      ImageCount  : integer;
      TypeCount   : Array[0..Ord(High(TImageType))] of word;
    end;

    // List object for TImageDesc records
    TDescList = class(TList)
    private
      FActualIndex: integer;
      FBMPActive: boolean;
    FUnique: boolean;
      procedure SetActualIndex(const Value: integer);
    procedure BMPChange(Sender: TObject);
    procedure SetUnique(const Value: boolean);
    protected
    public
      Owner   : TObject;
      pDesc   : pImageDesc;
      dDesc   : TImageDesc;
      BMP     : TBitmap;
      constructor Create(Aowner: TObject);
      destructor Destroy; override;
      procedure NewList;
      function NewDesc(FName: string): TImageDesc;
      function GetDesc(N: integer): TImageDesc;
      procedure Change(N: integer; tid: TImageDesc);
      procedure GenerateListFromStackFile(stackFile: TFileName);
      procedure AddToList(FName: string);
      procedure AddDesc(desc: TImageDesc);
      procedure DeleteFromList(N: integer);
      procedure Select(dBool: TDescBoolField; dSel: TDescSelectBoolMode);
      procedure RegisterAll(Reg: boolean);
      procedure InversRegister;
      procedure RegisterSelected(Reg: boolean);
      procedure ForceUnique;
      procedure SaveListToFile(fn: string);
      procedure ChangeBMP(N: integer; BM: TBitmap);
      property ActualIndex: integer read FActualIndex write SetActualIndex;
      property BMPActive: boolean read FBMPActive write FBMPActive;
      property Unique: boolean read FUnique write SetUnique;
    end;

    TChangeIndex = procedure(Sender: TObject; Index: integer) of object;
    TProgress    = procedure(Sender: TObject; Percent: integer) of object;

    TCustomStackedImage = class(TPersistent)
    private
    FActualIndex: integer;
    FDefaultExt: string;
    FFileName: TFileName;
    FAppend: boolean;
    FProjectName: string;
    FOnChangeIndex: TChangeIndex;
    FOnBeforeRegister: TNotifyEvent;
    FOnAfterRegister: TChangeIndex;
    FOnChangeList: TNotifyEvent;
    FOnProgress: TProgress;
    FMasterMethod: TMasterMethod;
    function GetCount: integer;
    function GetFirstImageAddress: integer;
    procedure SetActualIndex(const Value: integer);
    procedure SetFileName(const Value: TFileName);
    procedure HeaderNull;
    procedure SetProjectName(const Value: string);
    protected
    public
      StackFileStream : TFileStream;     // File stream for stack file
      BakFileStream   : TFileStream;     // File stream for bak file
      BMPS            : TDescList;       // List for registered (Stacked) TImageDesc records
      unregBMPS       : TDescList;       // List for unregistered TImageDesc records
      filtList        : TDescList;       // List for filtered TImageDesc records
      BMP             : TBitmap;         // Bitmap for one image
      StackHeader     : TStackHeader;    // Header blokk of stack file
      FImageDesc      : pImageDesc;      // Pointer to TImageDesc record
      ImageDesc       : TImageDesc;      // Bitmap description record
      Loading         : boolean;         // Loading in procces
      Statistic       : TStackStatistic; // Statistic for count of image types
      MasterDark      : TBitmap;
      MasterFlat      : TBitmap;
      MasterLight     : TBitmap;
      constructor Create(Aowner: TObject);
      destructor Destroy; override;

      function NewProject(ProjName : string): boolean;
      function NewDesc(FName: string): TImageDesc;
      function GetDesc(N: integer): TImageDesc;
      procedure AddDesc(iDesc: TImageDesc);
      procedure Change(N: integer; tid: TImageDesc);

      function LoadBMP(FName: string; BM: TBitmap): boolean;
      function SaveBMP(FName: string; BM: TBitmap): boolean;

      // Stack file methods
      function IsStackFile: boolean;  // If stack file exists
      procedure CreateStackFile;      // Create stack file and generate from list
      procedure EmptyStack;           // Empty the stack except Header
      function RegisterList(append: boolean): boolean; // Register desc list to stack file
      function GetHeader(Stream: TStream): TStackHeader;
      function GetImageCount(Stream: TStream): integer;
      procedure SaveHeaderToStream(Stream: TStream; Header: TStackHeader);
      procedure SaveIndexDescToStream(Stream: TStream; N: integer);
      procedure SaveDescToStream(Stream: TStream; var iDesc: TImageDesc);
      function LoadDescFromStream(Stream: TStream; N: integer):TImageDesc;
      procedure SaveBMPToStream(Stream: TStream; N: integer);
      procedure SaveBITMAPToStream(Stream: TStream; BM: Tbitmap);  // Save any bitmap to stream
      procedure LoadBMPFromStream(stream: TStream; pDesc: TImageDesc; BM: TBitmap);
      function GetImageRect(stream: TStream; pDesc: TImageDesc; R: TRect; BM: TBitmap): boolean;

      function PackStack: boolean;            // Deletes the deleted blocks from stackfilestream;
      function AppendBlockFromStream(SRCstream, DSCStream: TStream; N: integer): boolean;
      function CopyBlockFromStream(SRCstream, DSCStream: TStream; N: integer): boolean;
      function TuncateStream(Stream: TStream; oPos: integer): boolean; // Truncate the stream fron oPos position

      // List methods
      procedure NewList;
      procedure GenerateListFromStackFile;
      procedure AddToList(FName: string);
      procedure DeleteFromList(N: integer);
      procedure Select(dBool: TDescBoolField; dSel: TDescSelectBoolMode);
      procedure RegisterAll(Reg: boolean);
      procedure SaveDesc(iDesc: TImageDesc);        // Save to filestream
      procedure SaveALLDesc;                        // Save to filestream

      // Actual Index pointer routins
      procedure First;
      procedure Last;
      procedure Prior;
      procedure Next;
      procedure MoveBy(N: integer);
      procedure Jump(N: integer);

      // Clipboard methods
      procedure CopyToClipboard;
      procedure PasteFromClipboard;
      procedure AppendFromClipboard;

      // List
      procedure MakeStatistic;
      function MakeImageTypeList(iType: TImageType): integer;
//      function GetImageRect(N: Integer): TRect;
      function GetPixel(N: Integer; x,y: integer): TRGBTriple;

      // Master darf/flat and correction of lights
      function Stacking(iType: TImageType; Method: TMasterMethod): boolean;
      function MakeMasterDark: boolean;
      function MakeMasterDark1: boolean;
      function MakeMasterFlat: boolean;
      function MakeMasterLight: boolean;
      function DarkCorrect: boolean;
      function FlatCorrect: boolean;
      function AllignFrames: boolean;

      property Append: boolean read FAppend write FAppend;            // If False then examine repeated blokk
      property Count: integer read GetCount;
      property FileName: TFileName read FFileName write SetFileName;  // Stack file name
      property FirstImageAddress: integer read GetFirstImageAddress;
      property ActualIndex: integer read FActualIndex write SetActualIndex;
      property DefaultExt: string read FDefaultExt write FDefaultExt;
      property ProjectName: string read FProjectName write SetProjectName;
      property MasterMethod: TMasterMethod read FMasterMethod write FMasterMethod;
      property OnChangeList: TNotifyEvent read FOnChangeList write FOnChangeList;
      property OnChangeIndex: TChangeIndex read FOnChangeIndex write FOnChangeIndex;
      property OnBeforeRegister: TNotifyEvent read FOnBeforeRegister write FOnBeforeRegister;
      property OnAfterRegister: TChangeIndex read FOnAfterRegister write FOnAfterRegister;
      property OnProgress: TProgress read FOnProgress write FOnProgress;
    end;

Const ImageTypeString : array[0..Ord(High(TImageType))] of string =
                    ('None', 'Light', 'Dark', 'Flat', 'NylonFlat',
                     'MasterDark', 'MasterFlat', 'MasterNylonFlat',
                     'Result' );

implementation

{ TDescList }

constructor TDescList.Create(Aowner: TObject);
begin
  Owner        := Aowner;
  BMP          := TBitmap.Create;
  BMP.OnChange := BMPChange;
  FBMPActive   := False;       // Alapestben nem töltõdnek be a képek és adataik
end;

destructor TDescList.Destroy;
begin
  NewList;
  BMP.Free;
  inherited;
end;

procedure TDescList.BMPChange(Sender: TObject);
begin
  If Owner is TCustomStackedImage then
     TCustomStackedImage(Owner).BMP.Assign(BMP);
end;

procedure TDescList.NewList;
var i: integer;
begin
  for I:=0 to Pred(Count) do
  begin
    pDesc:=Items[I];
    Dispose(pDesc);
  end;
  Clear;
end;

procedure TDescList.AddToList(FName: string);
begin
  dDesc:=NewDesc(FName);
end;

procedure TDescList.AddDesc(desc: TImageDesc);
begin
  New(pDesc);
  pDesc^ := desc;
  Add(pDesc);
  ActualIndex := Count-1;
end;

procedure TDescList.DeleteFromList(N: integer);
var p: pImageDesc;
begin
    p:=Items[N];
    Dispose(p);
    Delete(N);
end;

procedure TDescList.GenerateListFromStackFile(stackFile: TFileName);
begin

end;

function TDescList.GetDesc(N: integer): TImageDesc;
begin
  if InRange(N,0,Pred(Count)) then begin
     pDesc := List[N];
     Result := pDesc^;
  end;
end;

procedure TDescList.Change(N: integer; tid: TImageDesc);
begin
  if InRange(N,0,Pred(Count)) then begin
     TImageDesc(List[N]^) := tid;
  end;
end;

function TDescList.NewDesc(FName: string): TImageDesc;
var i: integer;
begin
Try
  New(pDesc);
  with pDesc^ do begin
       Registered   := False;
       InStack      := False;
       FillChar(FileName,Sizeof(FileName),' ');
       StartAddress := 0;
       NextAddress  := 0;
       Size         := 0;
       bmpWidth     := 0;
       bmpHeight    := 0;
       XOffset      := 0;
       YOffset      := 0;
       Zoom         := 1;
       Rotate       := 0;
       Comment      := '';
       inStack      := False;
       Deleted      := False;
       Selected     := False;
       Edited       := False;
       ExpTime      := 0;
       ISO          := 0;
       Exp          := 0;
       ImageType    := itNone;
       Darked       := False;
       Flatted      := False;
       for i:=0 to High(Dommy) do Dommy[i]:=0;
       If FileExists(FName) then begin
          GetJPGSize(FName,bmpWidth,bmpHeight);
          Filename := FName;
          Size     := 3*bmpWidth*bmpHeight;
          NextAddress  := StartAddress+Size;
       end;
  end;
Finally
  Add(pDesc);
  Result := pDesc^;
end;
end;

// dBool = Field in TImageDesc record; dSel : select mód
procedure TDescList.Select(dBool: TDescBoolField; dSel: TDescSelectBoolMode);
var i: integer;
begin
  for I:=0 to Pred(Count) do
  begin
    pDesc:=Items[I];
  Case dBool of
  dbInStack :
    Case dSel of
    dsbAll   : pDesc^.InStack := True;
    dsbNot   : pDesc^.InStack := False;
    dsbInvers: pDesc^.InStack := not pDesc^.InStack;
    end;
  dbRegistered :
    Case dSel of
    dsbAll   : pDesc^.Registered := True;
    dsbNot   : pDesc^.Registered := False;
    dsbInvers: pDesc^.Registered := not pDesc^.Registered;
    end;
  dbSelected   :
    Case dSel of
    dsbAll   : pDesc^.Selected := True;
    dsbNot   : pDesc^.Selected := False;
    dsbInvers: pDesc^.Selected := not pDesc^.Selected;
    end;
  dbDeleted    :
    Case dSel of
    dsbAll   : pDesc^.Deleted := True;
    dsbNot   : pDesc^.Deleted := False;
    dsbInvers: pDesc^.Deleted := not pDesc^.Deleted;
    end;
  dbEdited     :
    Case dSel of
    dsbAll   : pDesc^.Edited := True;
    dsbNot   : pDesc^.Edited := False;
    dsbInvers: pDesc^.Edited := not pDesc^.Edited;
    end;
  end;
  end;
end;

procedure TDescList.RegisterAll(Reg: boolean);
begin
  If Reg then
     Select(dbRegistered,dsbAll)
  else
     Select(dbRegistered,dsbNot);
end;

procedure TDescList.InversRegister;
begin
  Select(dbRegistered,dsbInvers);
end;

procedure TDescList.RegisterSelected(Reg: boolean);
var i: integer;
begin
     for I:=0 to Pred(Count) do
     begin
         pDesc:=Items[I];
         if pDesc^.Selected then
            pDesc^.Registered := Reg;
     end;
end;

procedure TDescList.SetActualIndex(const Value: integer);
begin
  FActualIndex := Value;
  dDesc := GetDesc(Value);
  if FBMPActive then
  if dDesc.inStack then
     TCustomStackedImage(Owner).LoadBMPFromStream(TCustomStackedImage(Owner).StackFileStream,dDesc,BMP)
  else
     Load_Bitmap(dDesc.FileName, BMP);
end;

// Only one same record in list. Deletes same records
procedure TDescList.ForceUnique;
var i,k: integer;
    fn: string;
begin
     for I:=0 to Pred(Count) do
     begin
         pDesc:=Items[I];
         fn := UpperCase(pDesc^.Filename);
         k:=i;
         repeat
               pDesc:=Items[k];
               if fn=UpperCase(pDesc^.Filename) then
                  pDesc^.Deleted := True;
               Inc(k);
         until k>Pred(Count);
         Pack;
     end;
end;

procedure TDescList.SetUnique(const Value: boolean);
begin
  FUnique := Value;
  if Value then ForceUnique;
end;

// Save List to text file
procedure TDescList.SaveListToFile(fn: string);
var i,k: integer;
    tLine : string;
    F  : TEXTFILE;
begin
Try
Try
     AssignFile(F,fn);
     Rewrite(F);

     for I:=0 to Pred(Count) do
     begin
         dDesc := GetDesc(i);
         with dDesc do begin
         WriteLn(F,'FileName      : '+FileName);
         WriteLn(F,'ImageType     : ');
         WriteLn(F,'Registered    : '+BoolToStr(Registered));
         WriteLn(F,'inStack       : '+BoolToStr(inStack));
         WriteLn(F,'Deleted       : '+BoolToStr(Deleted));
         WriteLn(F,'Selected      : '+BoolToStr(Selected));
         WriteLn(F,'StartAddress  : '+IntToStr(StartAddress));
         WriteLn(F,'Size          : '+IntToStr(Size));
         WriteLn(F,'bmpWidth      : '+IntToStr(bmpWidth));
         WriteLn(F,'bmpHeight     : '+IntToStr(bmpHeight));
         WriteLn(F,'XOffset       : '+Format('%6.2f',[XOffset]));
         WriteLn(F,'YOffset       : '+Format('%6.2f',[YOffset]));
         WriteLn(F,'Zoom          : '+Format('%6.2f',[Zoom]));
         WriteLn(F,'Rotate        : '+Format('%6.2f',[Rotate]));
         WriteLn(F,'ExpTime       : '+FormatDateTime('yyyy-mm-dd',ExpTime));
         WriteLn(F,'ISO           : '+IntToStr(ISO));
         WriteLn(F,'Exp           : '+Format('%6.2f',[Exp]));
         WriteLn(F,'Comment       : '+Comment);
         end;
     end;
except
  CloseFile(F);
end;
finally
  CloseFile(F);
end;
end;

procedure TDescList.ChangeBMP(N: integer; BM: TBitmap);
begin
end;

{ TCustomStackedImage }

constructor TCustomStackedImage.Create(Aowner: TObject);
begin
  StackFileStream := nil;
  BMPS          := TDescList.Create(Self);
  unregBMPS     := TDescList.Create(Self);
  filtList      := TDescList.Create(Self);
  BMP           := TBitmap.Create;
  BMPS.BMPActive:= True;
  FFilename     := '';
  ProjectName   := 'STACK';
  FDefaultExt   := '.STC';
end;

destructor TCustomStackedImage.Destroy;
begin
  if StackFileStream<>nil then StackFileStream.Free;
  unregBMPS.Free;
  BMPS.Free;
  BMP.Free;
  filtList.Free;
  inherited;
end;

procedure TCustomStackedImage.HeaderNull;
begin
  with StackHeader do begin
       HeadStr      := 'STAF STACK FILE Ver 1.0';
       ImageCount   := 0;
       BytePerPixel := 24;
  end;
end;

procedure TCustomStackedImage.GenerateListFromStackFile;
Var
    iDesc        : TImageDesc;
    ENDOFFILE    : Boolean;
begin
Try
     If StackFileStream<>nil then begin
           BMPS.NewList;
           StackFileStream.Position := 0;
           StackFileStream.Read(StackHeader,SizeOf(TStackHeader));
           FProjectName := StackHeader.ProjectName;
           StackFileStream.Position := FirstImageAddress;
     if (StackFileStream.Size > StackFileStream.Position) then
     REPEAT
           StackFileStream.Read(iDesc,SizeOf(TImageDesc));
           New(FImageDesc);
           FImageDesc^ := iDesc;
           BMPS.Add(FImageDesc);
           StackFileStream.Position := StackFileStream.Position + FImageDesc^.Size;
           ENDOFFILE := (StackFileStream.Size <= StackFileStream.Position);
     UNTIL ENDOFFILE;
     end;
except
  exit;
end;
end;

function TCustomStackedImage.GetCount: integer;
begin
  Result := BMPS.Count;
end;

// Get the image properties record from list and load bitmap into BMP
function TCustomStackedImage.GetDesc(N: integer): TImageDesc;
begin
  Result := BMPS.GetDesc(N);
end;

function TCustomStackedImage.GetFirstImageAddress: integer;
begin
  Result := SizeOf(TStackHeader);
end;

// Loading bitmap file to BMP
function TCustomStackedImage.LoadBMP(FName: string; BM: TBitmap): boolean;
var ext: string;
    jpgIMG: TJpegImage;
begin
Try
  Loading := True;
  Load_Bitmap(FName,BM);
Finally
  Loading := False;
End;
end;

function TCustomStackedImage.SaveBMP(FName: string; BM: TBitmap): boolean;
var ext: string;
    jpgIMG: TJpegImage;
begin
Try
  Loading := True;
  Save_Bitmap(FName,BM);
Finally
  Loading := False;
End;
end;


function TCustomStackedImage.NewDesc(FName: string): TImageDesc;
begin
  Result := BMPS.NewDesc(FName);
end;

// Deletes all image from BMP list
procedure TCustomStackedImage.NewList;
begin
  BMPS.NewList;
end;

procedure TCustomStackedImage.AddToList(FName: string);
begin
  ImageDesc:=BMPS.NewDesc(FName);
end;

procedure TCustomStackedImage.SetActualIndex(const Value: integer);
var idx: integer;
begin
  if FActualIndex <> Value then begin
     idx := Value;
     if not InRange(Value,0,Pred(Count)) then begin
        if Value>=BMPS.Count then idx := BMPS.Count-1;
        if BMPS.Count=0 then idx := -1;
     end;
     FActualIndex := idx;
     IF FActualIndex>-1 THEN BEGIN
     ImageDesc := GetDesc(idx);           // Fills FImageDesc with values
     if ImageDesc.inStack then
        LoadBMPFromStream(StackFileStream,ImageDesc,BMP)
     ELSE
        Load_Bitmap(ImageDesc.FileName,BMP);
     END;
     if Assigned(FOnChangeIndex) then FOnChangeIndex(Self, FActualIndex);
  end;
end;

procedure TCustomStackedImage.SetFileName(const Value: TFileName);
begin
  if FFileName <> Value then begin
     FFileName := Value;
     CreateStackFile;
  end;
end;

procedure TCustomStackedImage.CreateStackFile;
begin
Try
  if StackFileStream<>nil then StackFileStream.Destroy;
  if FFileName<>'' then
  if FileExists(FFileName) then begin
     StackFileStream := TFileStream.Create(FFileName,fmOpenReadWrite);
     StackFileStream.Read(StackHeader, SizeOf(TStackHeader));
     ProjectName := StackHeader.ProjectName;
   end else begin
     StackFileStream := TFileStream.Create(FFileName,fmCreate);
     HeaderNull;
     StackFileStream.Write(StackHeader, SizeOf(TStackHeader));
   end;
except
  exit;
end;
end;

procedure TCustomStackedImage.DeleteFromList(N: integer);
begin
    BMPS.DeleteFromList(N);
end;

procedure TCustomStackedImage.SaveIndexDescToStream(Stream: TStream;
  N: integer);
begin
  ImageDesc := BMPS.GetDesc(N);
  ImageDesc.InStack := True;
  ImageDesc.StartAddress := StackFileStream.Position+SizeOf(TImageDesc);
  Stream.Write(ImageDesc,SizeOf(TImageDesc));
end;

procedure TCustomStackedImage.SaveDescToStream(Stream: TStream;
  var iDesc: TImageDesc);
begin
  iDesc.InStack := True;
  iDesc.StartAddress := StackFileStream.Position+SizeOf(TImageDesc);
  Stream.Write(iDesc,SizeOf(TImageDesc));
end;

// Save only the ImageDesc record into stream
procedure TCustomStackedImage.SaveDesc(iDesc: TImageDesc);
begin
  iDesc.InStack := True;
  StackFileStream.Position := iDesc.StartAddress-SizeOf(TImageDesc);
  StackFileStream.Write(iDesc,SizeOf(TImageDesc));
end;

procedure TCustomStackedImage.SaveAllDesc;
var i: integer;
begin
  for i:=0 to Pred(BMPS.Count) do
      SaveDesc(GetDesc(i));
end;

procedure TCustomStackedImage.SaveBMPToStream(Stream: TStream; N: integer);
Var p   : pImageDesc;
    x,y : integer;
    Row :^TRGBTriple;
begin
  p := BMPS.Items[N];
  LoadBMP(p^.FileName,BMP);
  If Stream<>nil then begin
  FOR y := 0 TO bmp.Height-1 DO
  BEGIN
    Row := bmp.Scanline[y];
    Stream.Write(Row^,bmp.Width*SizeOf(TRGBTriple));
  END;
  end;
end;

procedure TCustomStackedImage.SaveBITMAPToStream(Stream: TStream; BM: Tbitmap);
Var
    Y   : integer;
    Row :^TRGBTriple;
begin
  If Stream<>nil then begin
  FOR y := 0 TO BM.Height-1 DO
  BEGIN
    Row := BM.Scanline[y];
    Stream.Write(Row^,bm.Width*SizeOf(TRGBTriple));
  END;
  end;
end;


function TCustomStackedImage.IsStackFile: boolean;
begin
  Result := FileExists(FileName);
end;

procedure TCustomStackedImage.LoadBMPFromStream(stream: TStream;
  pDesc: TImageDesc; BM: TBitmap);
var x,y: integer;
   Row       :^TRGBTripleArray;
begin
if Stream<>nil then begin
  Stream.Position := pDesc.StartAddress;
  BM.PixelFormat := pf24bit;
  BM.Width  := pDesc.bmpWidth;
  BM.Height := pDesc.bmpHeight;
  Row := BM.Scanline[0];
  FOR y := 0 TO bm.Height-1 DO
  BEGIN
    Row := BM.Scanline[y];
    Stream.Read(Row^,BM.Width*SizeOf(TRGBTriple));
  END;
(*
  Row := BM.Scanline[0];
  Stream.Read(Row^,10000*SizeOf(TRGBTriple));
  *)
end;
end;

procedure TCustomStackedImage.CopyToClipboard;
begin
  Clipboard.Assign(BMP);
end;

procedure TCustomStackedImage.PasteFromClipboard;
var oPos : longint;
    oDesc : TImageDesc;
    NewSize : Cardinal;
begin
  If Clipboard.Hasformat(CF_BITMAP) then begin
     ImageDesc := GetDesc(ActualIndex);
     oDesc := ImageDesc;
     BMP.Assign(Clipboard);
     BMP.PixelFormat := pf24bit;
     NewSize := BMP.Width*BMP.Height*3;
        ImageDesc.Size := NewSize;
        ImageDesc.bmpWidth := BMP.Width;
        ImageDesc.bmpHeight := BMP.Height;
        ImageDesc.NextAddress := oDesc.StartAddress + 3*oDesc.bmpWidth*oDesc.bmpHeight;
     if NewSize<=oDesc.Size then begin
     end else begin
     end;
        if StackFileStream<>nil then begin
        end;
  end;
end;

// Append the Clipbord image to the end of stack file
procedure TCustomStackedImage.AppendFromClipboard;
var oPos : longint;
begin
  If Clipboard.Hasformat(CF_BITMAP) then begin
     AddToList('');
     BMP.Assign(Clipboard);
     BMP.PixelFormat := pf24bit;
     if StackFileStream<>nil then begin
        ImageDesc.FileName := 'Clipboard';
        ImageDesc.StartAddress := StackFileStream.Size+SizeOf(TImageDesc);
        ImageDesc.bmpWidth := BMP.Width;
        ImageDesc.bmpHeight := BMP.Height;
        ImageDesc.Size := BMP.Width*BMP.Height*3;
        oPos := StackFileStream.Position;
        StackFileStream.Seek(0,2);
        StackFileStream.Write(ImageDesc,SizeOf(TImageDesc));
        SaveBITMAPToStream(StackFileStream,BMP);
        StackFileStream.Position := oPos;
     end;
  end;
end;

// If exist stac file, then fill the file from desc list
// if one of the desc is exist then step toward
function TCustomStackedImage.RegisterList(append: boolean): boolean;
var i: integer;
    fn: string;
    pIdesc     : pImageDesc;
begin
Try
Try
  If StackFileStream<>nil then begin
     Result := True;
     Loading := True;

     if not append then begin
        StackFileStream.Size:=0;
        SaveHeaderToStream(StackFileStream,StackHeader); // Only header remains
     end;
     GenerateListFromStackFile;                      // Fills the BMPS list
     StackFileStream.Seek(0,2);                      // Append bloks to the end of stream

     for I:=0 to Pred(unregBMPS.Count) do
     begin
         ImageDesc := unregBMPS.GetDesc(I);
         if (ImageDesc.Registered) and (not ImageDesc.Deleted) and (not ImageDesc.inStack)
         then begin
              fn := ImageDesc.FileName;
              if FileExists(fn) then begin           // First get the image dimensions
                 LoadBMP(ImageDesc.FileName, BMP);
                 ImageDesc.bmpWidth := BMP.Width;
                 ImageDesc.bmpHeight := BMP.Height;
                 ImageDesc.Size := 3*BMP.Width*BMP.Height;
              end;
              ImageDesc.StartAddress := StackFileStream.Position+SizeOf(TImageDesc);
              ImageDesc.InStack := True;
              StackFileStream.Write(ImageDesc, SizeOf(TImageDesc));
              SaveBITMAPToStream(StackFileStream,BMP);
              AddDesc(ImageDesc);
              unregBMPS.Change(i,ImageDesc);
              if Assigned(FOnAfterRegister) then FOnAfterRegister(Self,i);
         end;
     end;
     StackHeader.ImageCount := Count;
     SaveHeaderToStream(StackFileStream,StackHeader);
  end;
except
  Loading := False;
end;
finally
  Loading := False;
  Last;
end;
end;

function TCustomStackedImage.GetHeader(Stream: TStream): TStackHeader;
begin
  If Stream<>nil then begin
     Stream.Seek(0,0);
     Stream.Read(Result, SizeOf(TStackHeader));
  end;
end;

function TCustomStackedImage.GetImageCount(Stream: TStream): integer;
begin

end;

function TCustomStackedImage.LoadDescFromStream(Stream: TStream;
  N: integer): TImageDesc;
var id: TImageDesc;
begin
  id := BMPS.GetDesc(N);
  if StackFileStream<>nil then begin
     StackFileStream.Seek(id.StartAddress-Sizeof(id),0);
     StackFileStream.Read(Result,SizeOf(id));
  end;
end;

procedure TCustomStackedImage.RegisterAll(Reg: boolean);
begin
  BMPS.RegisterAll(Reg);
end;

function TCustomStackedImage.GetImageRect(stream: TStream;
  pDesc: TImageDesc; R: TRect; BM: TBitmap): boolean;
VAR _BMP : TBitmap;
begin
  Result := False;
  If StackFileStream<>nil then begin
  Try
     Loading := True;
     _BMP := TBitmap.Create;
     BM.PixelFormat := pf24bit;
     if pDesc.inStack then begin
        if pDesc.Startaddress<>0 then begin
           StackFileStream.Seek(pDesc.Startaddress,0);
           LoadBMPFromStream(stream, pDesc, _BMP);
           BM.Width := R.Right - R.Left;
           BM.Height := R.Bottom - R.Top;
           BM.Canvas.CopyRect(BM.Canvas.Cliprect,_BMP.Canvas,R);
        end;
        Result := True;
     end;
  finally
     Loading := False;
     _BMP.Free;
  end;
  end;
end;

procedure TCustomStackedImage.AddDesc(iDesc: TImageDesc);
begin
  BMPS.AddDesc(iDesc);
end;

procedure TCustomStackedImage.Change(N: integer; tid: TImageDesc);
begin
  BMPS.Change(N,Tid);
  SaveDesc(tid);
end;

procedure TCustomStackedImage.SetProjectName(const Value: string);
begin
  FProjectName := Value;
  StackHeader.ProjectName := Value;
end;

procedure TCustomStackedImage.SaveHeaderToStream(Stream: TStream; Header: TStackHeader);
var oPos: longint;
begin
  oPos := Stream.Position;
  Stream.Seek(0,0);
  Stream.Write(Header, SizeOf(TStackHeader));
  Stream.Position := oPos;
end;

function TCustomStackedImage.NewProject(ProjName: string): boolean;
begin
  FileName := ProjName+'.STC';
  StackHeader.ProjectName := ProjName;
  EmptyStack;
end;

procedure TCustomStackedImage.EmptyStack;
begin
  StackFileStream.Size := 0;
  BMPS.NewList;
  StackHeader.ImageCount := 0;
  SaveHeaderToStream(StackFileStream,StackHeader);
  ActualIndex := -1;
end;

procedure TCustomStackedImage.First;
begin
  if Count=0 then ActualIndex := -1 else
  ActualIndex := 0;
end;

procedure TCustomStackedImage.Jump(N: integer);
begin
  ActualIndex := N;
end;

procedure TCustomStackedImage.Last;
begin
  ActualIndex := Count-1;
end;

procedure TCustomStackedImage.MoveBy(N: integer);
begin
  ActualIndex := FActualIndex+N;
end;

procedure TCustomStackedImage.Next;
begin
  ActualIndex := FActualIndex+1;
end;

procedure TCustomStackedImage.Prior;
begin
  ActualIndex := FActualIndex-1;
end;

procedure TCustomStackedImage.Select(dBool: TDescBoolField;
  dSel: TDescSelectBoolMode);
begin
  BMPS.Select(dBool, dSel);
  SaveAllDesc;
end;


function TCustomStackedImage.AppendBlockFromStream(SRCstream,
  DSCStream: TStream; N: integer): boolean;
begin

end;

function TCustomStackedImage.CopyBlockFromStream(SRCstream,
  DSCStream: TStream; N: integer): boolean;
begin

end;

// Deletes the deleted blocks from stream
function TCustomStackedImage.PackStack: boolean;
var delCount    : integer;     // Count of Deleted blocks
    iDesc       : TImageDesc;  //
    Header      : TStackHeader;
    i           : integer;
    oldFileName : string;
begin
Try
  Result := True;
  Try
     GenerateListFromStackFile;
     // Counts the deleted blocks
     delCount := 0;
     For i:=0 to Pred(Count) do begin
         iDesc := GetDesc(i);
         if iDesc.Deleted then Inc(delCount);
     end;
     if delCount>0 then begin
     Try
        // Copies the not deleted blocks to BackFileStream
        BakFileStream := TFileStream.Create('BAK.STC',fmCreate);
        StackFileStream.Seek(FirstImageAddress,0);
        For i:=0 to Pred(Count) do begin
            iDesc := GetDesc(i);
            if not iDesc.Deleted then begin
               SaveDescToStream(BakFileStream,iDesc);
               LoadBMPFromStream(StackFileStream,iDesc,BMP);
               SaveBITMAPToStream(BakFileStream,BMP);
            end;
        end;
     finally
        BakFileStream.Free;
        oldFileName := FFileName;
        FileName := '';
        if RenameFile('BAK.STC',oldFileName) then begin
           FileName := oldFileName;
           GenerateListFromStackFile;
        end;
     end;
     end;
  except
    Result := False;
  end;
finally
  Result := True;
end;
end;

function TCustomStackedImage.TuncateStream(Stream: TStream;
  oPos: integer): boolean;
begin
  Stream.Size := oPos;
end;

procedure TCustomStackedImage.MakeStatistic;
Var
    iDesc       : TImageDesc;
    i           : integer;
begin
  Statistic.ImageCount := Count;
  For i:=0 to High(Statistic.TypeCount) do begin
      Statistic.TypeCount[i]:=0;
  end;
  For i:=0 to Pred(Count) do begin
      iDesc := GetDesc(i);
      if not iDesc.Deleted then
         Statistic.TypeCount[Ord(iDesc.ImageType)]:=
            Statistic.TypeCount[Ord(iDesc.ImageType)]+1;
  end;
end;

// Make a list (filtList) from stack fájl BMPS-list, filtered by imagetype
function TCustomStackedImage.MakeImageTypeList(iType: TImageType): integer;
var iDesc : TImageDesc;
    i     : integer;
begin
    Result := 0;
    GenerateListFromStackFile;
    filtList.NewList;
     For i:=0 to Pred(BMPS.Count) do begin
         iDesc := GetDesc(i);
         if iDesc.ImageType = iType then begin
            filtList.AddDesc(iDesc);
            Inc(Result);
         end;
     end;
end;

(*
function TCustomStackedImage.GetImageRect(N: Integer): TRect;
begin
   Result := Rect(0,0,TImageDesc(BMPS[N]^).BMPWidth,TImageDesc(BMPS[N]^).BMPHeight);
end;
*)

function TCustomStackedImage.GetPixel(N, x, y: integer): TRGBTriple;
var iDesc : TImageDesc;
begin
  Result := ColorToTriple(0);
  if InRange(N,0,Count-1) then begin
     iDesc := GetDesc(N);
     StackFileStream.Position := iDesc.StartAddress + 3*y*iDesc.BMPWidth + 3*x;
     StackFileStream.Read(Result,SizeOf(TRGBTriple));
  end;
end;

function TCustomStackedImage.MakeMasterDark1: boolean;
Type sortArray = array[0..200] of integer;
var DarkCount  : integer;
    iDesc      : TImageDesc;
    i,x,y,xx,yy: integer;
    tBMP       : TBitmap;             // Temporary bitmap
    dBMP       : TBitmap;             // Master Dark bitmap
    dArr       : sortArray;
    Row        :^TRGBTripleArray;
    tRow,dRow  : PByteArray;
begin
  Result := False;
  DarkCount := MakeImageTypeList(itDark);

  if DarkCount>0 then begin
  Try
     iDesc := FiltList.GetDesc(0);

     tBMP  := TBitmap.Create;
     tBMP.Width  := iDesc.bmpWidth;
     tBMP.Height := DarkCount;

     dBMP  := TBitmap.Create;
     dBMP.Width  := iDesc.bmpWidth;
     dBMP.Height := iDesc.bmpHeight;

     for y:=0 to Pred(iDesc.bmpHeight) do begin

         // Get rows of darks and put it the temp bmp
         // Mindegyik darkból kiolvasunk egy-egy sort és a tBMP-re tesszük egymás alá
         for i:=0 to Pred(FiltList.Count) do begin
             iDesc := FiltList.GetDesc(i);
             StackFileStream.Position := iDesc.StartAddress + 3*y*iDesc.BMPWidth;
             Row := tBMP.ScanLine[i];
             StackFileStream.Read(Row^,SizeOf(TRGBTriple));
         end;

         // Medián átlagolunk a tBMP egymás alatti értékeire
         for xx:=0 to Pred(iDesc.bmpWidth) do begin
             for yy:=0 to Pred(DarkCount) do begin
                 tRow := tBMP.ScanLine[yy];
                 dArr[yy] := tRow[xx];
             end;
             QuickSort(Slice(dArr,DarkCount));
             dBMP.Canvas.Pixels[xx,y] := dArr[darkCount div 2];
         end;

         if Assigned(FOnProgress) then FOnProgress(Self,Trunc(100*(y+1)/iDesc.bmpHeight));

     end;

  finally
     if MasterDark<>nil then MasterDark.Free;
     MasterDark:=TBitmap.Create;
     MasterDark.Assign(dBMP);
     tBMP.Free;
     dBMP.Free;
  end;
  end;
end;


function TCustomStackedImage.Stacking(iType: TImageType;
                                        Method: TMasterMethod): boolean;
Type sortArray = array[0..200] of integer;
var mCount     : integer;             // Count of frames
    iDesc      : TImageDesc;
    i,x,y      : integer;
    dBMP       : TBitmap;             // Master Dark/Flat/Light bitmap
    dArr       : array of TRGBTriple;
    rArr       : sortArray;
    gArr       : sortArray;
    bArr       : sortArray;
    rgb_       : TRGBTriple;
    r,g,b      : integer;
//    Row        :^TRGBTriple;
    Row        : pByteArray;
begin
  Result := False;

  mCount := MakeImageTypeList(iType);

  if mCount>0 then begin
  Try
     iDesc := FiltList.GetDesc(0);     // Filterlist for dark
     dBMP  := TBitmap.Create;
     dBMP.Width  := iDesc.bmpWidth;
     dBMP.Height := iDesc.bmpHeight;
     SetLength(dArr,mCount);

//     for y:=0 to Pred(iDesc.bmpHeight) do
//         Row := dBMP.ScanLine[y];

     for y:=0 to Pred(iDesc.bmpHeight) do begin

//         Row := dBMP.ScanLine[y];

         for x:=0 to Pred(iDesc.bmpWidth) do begin

         // Get pixels into the array
         for i:=0 to Pred(FiltList.Count) do begin
             iDesc := FiltList.GetDesc(i);
             StackFileStream.Position := iDesc.StartAddress + 3*y*iDesc.BMPWidth + 3*x;
             StackFileStream.Read(dArr[i],SizeOf(TRGBTriple));
             rArr[i]:=dArr[i].rgbtRed;
             gArr[i]:=dArr[i].rgbtGreen;
             bArr[i]:=dArr[i].rgbtBlue;
         end;


         Case Method of
         mmAdditive   :
           begin
                // Add r,g,b intensities
                r:=0; g:=0; b:=0;
                for i:=0 to Pred(mCount) do begin
                    r := r + rArr[i];
                    g := g + gArr[i];
                    b := b + bArr[i];
                end;
                rgb_.rgbtRed   := r;
                rgb_.rgbtGreen := g;
                rgb_.rgbtBlue  := b;
           end;
         mmAverage    :
           begin
                // Arithmetic average
                r:=0; g:=0; b:=0;
                for i:=0 to Pred(mCount) do begin
                    r := r + rArr[i];
                    g := g + gArr[i];
                    b := b + bArr[i];
                end;
                rgb_.rgbtRed   := Round(r/mCount);
                rgb_.rgbtGreen := Round(g/mCount);
                rgb_.rgbtBlue  := Round(b/mCount);
           end;
         mmMedian     :
           begin
                // Median average

                // Sorting the r,g,b chanels
                QuickSort(Slice(rArr,mCount));
                QuickSort(Slice(gArr,mCount));
                QuickSort(Slice(bArr,mCount));

                rgb_.rgbtRed   := rArr[mCount div 2];
                rgb_.rgbtGreen := gArr[mCount div 2];
                rgb_.rgbtBlue  := bArr[mCount div 2];
           end;
         mmDifference :
           begin
           end;
         mmMax        :
           begin
                // Maximum intensities
                rgb_.rgbtRed   := rArr[mCount-1];
                rgb_.rgbtGreen := gArr[mCount-1];
                rgb_.rgbtBlue  := bArr[mCount-1];
           end;
         end;

         // Set pixel on target bmp


//         Row.rgbtBlue  := rgb_.rgbtRed;
//         Row.rgbtGreen := rgb_.rgbtGreen;
//         Row.rgbtRed   := rgb_.rgbtBlue;
//         inc(Row);
         dBMP.Canvas.Pixels[x,y] := TripleToColor(rgb_);
//         dBMP.Canvas.Pixels[x,y] := IArr[mCount div 2];

         end;

         if Assigned(FOnProgress) then FOnProgress(Self,Trunc(100*(y+1)/iDesc.bmpHeight));

     end;

  finally
     Case iType of
     itDark:
            begin
                 if MasterDark=nil then
                    MasterDark:=TBitmap.Create;
                    MasterDark.Assign(dBMP);
            end;
     itFlat:
            begin
                 if MasterFlat=nil then
                    MasterFlat:=TBitmap.Create;
                    MasterFlat.Assign(dBMP);
            end;
     itLight:
            begin
                 if MasterLight=nil then
                    MasterLight:=TBitmap.Create;
                    MasterLight.Assign(dBMP);
            end;
     end;
     dBMP.Free;
     Result := True;
  end;
  end;
end;

function TCustomStackedImage.MakeMasterDark: boolean;
begin
  Stacking(itDark,mmMedian);
end;

function TCustomStackedImage.MakeMasterFlat: boolean;
begin
  Stacking(itFlat,mmMedian);
end;

function TCustomStackedImage.MakeMasterLight: boolean;
begin
  Stacking(itLight,mmMedian);
end;


// Eliminates the master dark from light frames
function TCustomStackedImage.DarkCorrect: boolean;
var iDesc : TImageDesc;
    i     : integer;
    dBMP  : TBitmap;
begin
Try
  dBMP  := TBitmap.Create;
  if MasterDark=nil then
     Result := MakeMasterDark;
  if Result then
     For i:=0 to Pred(BMPS.Count) do begin
         iDesc := GetDesc(i);
         if (iDesc.ImageType = itLight) and (not iDesc.Darked) then begin
            LoadBMPFromStream( StackFileStream, iDesc, dBMP );
            SubtractDark( dBMP,MasterDark );
            StackFileStream.Seek( iDesc.StartAddress, 0 );
            SaveBITMAPToStream( StackFileStream, dBMP );
         end;
     end;
finally
  dBMP.Free;
end;
end;

// Corrigates with flat of light frames
function TCustomStackedImage.FlatCorrect: boolean;
var iDesc : TImageDesc;
    i     : integer;
    dBMP  : TBitmap;
begin
Try
  dBMP  := TBitmap.Create;
  if MasterFlat=nil then
     Result := MakeMasterFlat;
  if Result then
     For i:=0 to Pred(BMPS.Count) do begin
         iDesc := GetDesc(i);
         if (iDesc.ImageType = itLight) and (not iDesc.Flatted) then begin
            LoadBMPFromStream( StackFileStream, iDesc, dBMP );
            FlatCorrection( dBMP,MasterFlat );
            StackFileStream.Seek( iDesc.StartAddress, 0 );
            SaveBITMAPToStream( StackFileStream, dBMP );
         end;
     end;
finally
  dBMP.Free;
end;
end;

// Alligns all light frames
function TCustomStackedImage.AllignFrames: boolean;
begin

end;


end.
