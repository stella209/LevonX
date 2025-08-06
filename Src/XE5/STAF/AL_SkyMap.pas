unit AL_SkyMap;

{$REALCOMPATIBILITY ON}
{$J+}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Clipbrd, ExtCtrls,
  NewGeom, Math, Szamok, AL_Globe, STAF_Astrounit;

Type

  TSkyMapAction = ( maNone, maSearch, maSign, maSpecial );

  TALStarRecOld = packed record
    SAO   : integer;
    GREAK : byte;
    CANSTELLATION : byte;
    RA  : real48;
    DE  : real48;
    VMG : real48;
    FMG : real48;
    SP  : string[3];
  end;

  TALStarRec = packed record
    SAO           : integer;
    HD            : string[6];
    GREAK         : byte;
    CANSTELLATION : byte;
    RA            : real48;               // RA_2000 rad.
    DE            : real48;               // DE_2000 rad.
    RA_PM         : real48;               // RA move/year
    DE_PM         : real48;               // DE move/year
    VMG           : real48;
    FMG           : real48;
    SP            : string[3];
  end;

  // Constellations boundaries end figures lines
  Tconstb = record ra,de : single; end;           // constb.dat
  Tconstl = record sao1,sao2 : integer; end;      // constl.dat

  // Simple skymap component with inner star database;

  TAL_CustomSkyGlobe = class(TAL_CustomGlobe)
  private
    FStarFile: string;
    FInversMap: boolean;
    FConstBFile: string;
    FConstLFile: string;
    FConstBVisible: boolean;
    FConstLVisible: boolean;
    FStarVisible: boolean;
    FDataPath: string;
    FAction: TSkyMapAction;
    FCoordType: TCoordType;
    FPlateVisible: boolean;
    FPhotoPlate: TPoint;
    FSelectedSAO: integer;
    function GetPlateRect: TRect;
    procedure DrawImage;
    procedure MapPaint(Sender: TObject);
    procedure SetStarFile(const Value: string);
    function GetStarCount: integer;
    procedure SetInversMap(const Value: boolean);
    procedure SetConstBFile(const Value: string);
    procedure SetConstLFile(const Value: string);
    procedure SetConstBVisible(const Value: boolean);
    procedure SetConstLVisible(const Value: boolean);
    procedure SetStarVisible(const Value: boolean);
    procedure SetDataPath(const Value: string);
    procedure SetAction(const Value: TSkyMapAction);
    procedure SetCoordType(const Value: TCoordType);
    procedure SetPhotoPlate(const Value: TPoint);
    procedure SetPlateVisible(const Value: boolean);
    procedure OnTimer(Sender: TObject);
    procedure SetSelectedSAO(const Value: integer);
  protected
    timer               : TTimer;     // Timer for any doing;
    innerfile: string;
    searchThread: TThread;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    StarStream   : TMemoryStream;    {A csillagok adatbázisa a memóriában}
    ConstBStream : TMemoryStream;    // Constellations boundaries stream
    ConstLStream : TMemoryStream;    // Constellations FIGURES stream
    actStar      : integer;            // Star record pointer
    actStarRec   : TALStarRec;         // Star record of actual star
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;

    procedure DrawMap;
    procedure DrawBoundaries;
    procedure DrawConstLine;

    FUNCTION GetStarRadius(sRec: TALStarRec):double;
    function GetStarFromScreen(x,y: integer; var StRec: TALStarRec): boolean;
    function GetSAO(SaoNo: integer; var StRec: TALStarRec): boolean;

    property PhotoPlate       : TPoint read FPhotoPlate write SetPhotoPlate;
    property PlateRect        : TRect read GetPlateRect;
    property PlateVisible     : boolean read FPlateVisible write SetPlateVisible;
    property SelectedSAO      : integer read FSelectedSAO write SetSelectedSAO;

    property Action           : TSkyMapAction read FAction write SetAction;
    property DataPath         : string read FDataPath write SetDataPath;
    property StarFile         : string read FStarFile write SetStarFile;
    property ConstBFile       : string read FConstBFile write SetConstBFile;
    property ConstLFile       : string read FConstLFile write SetConstLFile;

    property CoordType        : TCoordType read FCoordType write SetCoordType;
    property StarCount        : integer read GetStarCount;
    property InversMap        : boolean read FInversMap write SetInversMap;

    property StarVisible      : boolean read FStarVisible write SetStarVisible;
    property ConstBVisible    : boolean read FConstBVisible write SetConstBVisible;
    property ConstLVisible    : boolean read FConstLVisible write SetConstLVisible;
  end;


  TAL_SkyMap = class(TAL_CustomSkyGlobe)
  published
    property Align;
    property Action;
    property DataPath;
    property BackColor;
    property GlobeColor;
    property CentralCross;
    property CoordType;
    property Zoom;
    property Theta;
    property Pfi;
    property Meridian;
    property LAT;
    property ALT;
    property Aspect;
    property GridPen;
    property EquatorPen;
    property CirclePen;
    property StarFile;
    property ConstBFile;
    property ConstLFile;
    property InversMap;
    property StarVisible;
    property ConstBVisible;
    property ConstLVisible;
    property PopupMenu;
    property OnAfterPaint;
    property OnChange;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
  end;

  procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('AL',[TAL_SkyMap]);
end;

{ TAL_CustomSkyGlobe }

constructor TAL_CustomSkyGlobe.Create(AOwner: TComponent);
VAR filepath: string;
begin
  inherited;
  StarStream         := TMemoryStream.Create;
  ConstBStream       := TMemoryStream.Create;
  ConstLStream       := TMemoryStream.Create;
  Loading            := True;
  innerfile          := 'AL_SkyMap.SKY';
  deltaLAT           := 15;
  FInversMap         := False;
  GlobeType          := gtyAstro;
  GlobeColor         := clBlack;
  FStarVisible       := True;
  FConstBVisible     := True;
  FConstLVisible     := False;
  FPlateVisible      := True;
  FPhotoPlate        := Point(128,84); // width,height in arcmin
  OnAfterPaint       := MapPaint;
  FCoordType         := coordEquatorial;
  ALT                := 20.3;
  LAT                := 48.2;
  timer              := TTimer.Create(Self);
  timer.Interval     := 1;
  timer.Ontimer      := OnTimer;
  DataPath           := 'Data\';
  FSelectedSAO       := -1;
  Loading            := False;
end;

destructor TAL_CustomSkyGlobe.Destroy;
begin
  Timer.Free;
  StarStream.Destroy;
  ConstBStream.Destroy;
  ConstLStream.Destroy;
  inherited;
end;

procedure TAL_CustomSkyGlobe.MapPaint(Sender: TObject);
begin
  if not Image.Empty then
     DrawImage;
  DrawBoundaries;
  DrawConstLine;
  DrawMap;
  inherited;
end;

    FUNCTION TAL_CustomSkyGlobe.GetStarRadius(sRec: TALStarRec):double;
    var mgLimit: double;
    begin
      if Zoom<800 then
         Result := 6-(1.1*(sRec.vmg))
      else
      if sRec.vmg>=-2 then
         Result := 10-(Sqrt(9.5*(sRec.vmg+2)))
    end;

procedure TAL_CustomSkyGlobe.DrawImage;
begin
   BMP.Canvas.StretchDraw(GetPlateRect,Image);
end;

procedure TAL_CustomSkyGlobe.DrawMap;
var sRec : TALStarRec;
    i,j  : integer;
    sPos : TPoint3d;
    R    : double;
    n    : integer;
    Rec  : TRect;

begin
if FStarVisible then begin
  // Draw a skymap objects from StarStream
  Loading := True;
  BMP.Canvas.Brush.Style := bsSolid;
  if FInversMap then begin
  BMP.Canvas.Brush.Color := clBlack;
  BMP.Canvas.Pen.Color := clBlack;
  end else begin
  BMP.Canvas.Brush.Color := clWhite;
  BMP.Canvas.Pen.Color := clWhite;
  end;
  with StarStream do begin
    Seek(0,0);
    n:=0;
    for i:=1 To StarCount do begin
        Read(sRec,SizeOf(TALStarRec));
        if sRec.VMG<8 then begin
        sPos := GetGlobeXY(sRec.RA,sRec.DE);
        if sPos.z>0 then begin
           if PtInRect(BMP.Canvas.ClipRect,Point(Trunc(sPos.x),Trunc(sPos.y))) then
           begin
             R := GetStarRadius(sRec);
             if R>0.4 then
             if R>0.8 then
                BMP.Canvas.Ellipse(Round(sPos.x-R),Round(sPos.y-R),
                              Round(sPos.x+R),Round(sPos.y+R))
             else
                BMP.Canvas.Pixels[Round(sPos.x),Round(sPos.y)]:=clSilver;
             if FSelectedSAO=sRec.SAO then begin
                BMP.Canvas.Pen.Color := clLime;
                R := 20;
                BMP.Canvas.Rectangle(Round(sPos.x-R),Round(sPos.y-R),
                              Round(sPos.x+R),Round(sPos.y+R));
                BMP.Canvas.Pen.Color := clLime;
             end;
             Inc(n);
           end;
        end;
        end;
    end;
  end;
  if FPlateVisible then begin
     BMP.Canvas.Brush.Style := bsClear;
     BMP.Canvas.Pen.Color := clRed;
(*
     i := Trunc(Zoom*sin(DegToRad(FPhotoPlate.x/120)));
     j := Trunc(Zoom*sin(DegToRad(FPhotoPlate.y/120)));
     BMP.Canvas.Rectangle((Width div 2)-i,(Height div 2)-j,(Width div 2)+i,(Height div 2)+j);
*)
     BMP.Canvas.Rectangle(GetPlateRect);
  end;
  Loading := False;
end;
end;

procedure TAL_CustomSkyGlobe.DrawBoundaries;
var m,i  : integer;
    bRec : TConstb;
    sPos : TPoint3d;
    newConst : boolean;
begin
if ConstBVisible then
  with ConstBStream do begin
    m := Size div SizeOf(TConstb);
    Seek(0,0);
    BMP.Canvas.Pen.Color:=clBlue;
    for i:=1 To m do begin
        Read(bRec,SizeOf(TConstb));
        sPos := GetGlobeXY(DegToRad(15*Abs(bRec.RA)),DegToRad(bRec.DE));
             if (bRec.Ra<0) or (sPos.z<0) then
                BMP.Canvas.MoveTo(Trunc(sPos.x),Trunc(sPos.y))
             else
                BMP.Canvas.LineTo(Trunc(sPos.x),Trunc(sPos.y));
    end;
  end;
end;

procedure TAL_CustomSkyGlobe.DrawConstLine;
var m,i  : integer;
    lRec : TConstl;
    sPos1,sPos2 : TPoint3d;   // Line end points
    sao1,sao2: TALStarRec;
    newConst : boolean;
    d: double;
begin
if ConstLVisible then
  with ConstLStream do begin
    m := Size div SizeOf(TConstl);
    Seek(0,0);
    BMP.Canvas.Pen.Color:=clGray;
    for i:=1 To m do begin
        Read(lRec,SizeOf(TConstl));
        Try
        if GetSao(lRec.sao1,sao1) then
           if GetSao(lRec.sao2,sao2) then begin
              sPos1 := GetGlobeXY(sao1.RA,sao1.DE);
              sPos2 := GetGlobeXY(sao2.RA,sao2.DE);
              if (sPos1.z>0) and (sPos2.z>0)
              and (RelDist3D(sPos1,sPos2)<(1.7*Zoom))
              then begin
                   BMP.Canvas.MoveTo(Trunc(sPos1.x),Trunc(sPos1.y));
                   BMP.Canvas.LineTo(Trunc(sPos2.x),Trunc(sPos2.y));
              end;
           end;
        except
        end;
    end;
  end;
end;

function TAL_CustomSkyGlobe.GetSAO(SaoNo: integer; var StRec: TALStarRec): boolean;
var sRec : TALStarRec;
    k,k1,k2,m: integer;
    maxSao : integer;
    Up   : boolean;
begin
  Result := False;
  with StarStream do begin
       Seek(-SizeOf(TALStarRec),2);
       Read(sRec,SizeOf(TALStarRec));
       m  := Size div SizeOf(TALStarRec);
       maxSao := sRec.SAO;
       IF (SaoNo<1) or (SaoNo>maxSao) then
          exit;
       k  := SaoNo-1;
       k1 := 0;
       k2 := StarCount;
       up := True;
  repeat
       Seek(k*SizeOf(TALStarRec),0);
       Read(sRec,SizeOf(TALStarRec));
       if sRec.SAO = SaoNo then begin
          StRec := SRec;
          Result := True;
          exit;
       end;
       if sRec.SAO < SaoNo then begin
          up := False;
          k2 := k;
          k := k-(sRec.SAO - SaoNo);
       end;
       if sRec.SAO > SaoNo then begin
          up := True;
          k1 := k;
          k := k+(SaoNo-sRec.SAO);
       end;
//       if (k1>=k2) then Exit;
  until False;
  end;
end;

function TAL_CustomSkyGlobe.GetStarCount: integer;
begin
  Result := StarStream.Size div SizeOf(TALStarRec);
end;

function TAL_CustomSkyGlobe.GetStarFromScreen(x,y: integer; var StRec: TALStarRec): boolean;
var i: integer;
    sPos : TPoint3d;
    sRec : TALStarRec;
    R    : double;
begin
  Result := False;
  if not Loading then
  with StarStream do begin
    actStar := -1;
    Seek(0,0);
    for i:=1 To StarCount do
    if not OnBreak then begin
        Read(sRec,SizeOf(TALStarRec));
        sPos := GetGlobeXY(sRec.RA,sRec.DE);
        if (Abs(x-sPos.x)<4) and (Abs(y-sPos.y)<4) then begin
           R := GetStarRadius(sRec);
           if R>0.4 then begin
           Result := True;
           actStar := i-1;
           actStarRec := sRec;
           StRec := sRec;
           exit;
           end;
        end;
    end else begin
        OnBreak := False;
        Exit;
    end;
  end;
end;

procedure TAL_CustomSkyGlobe.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//  OnBreak := True;
  inherited;
end;

procedure TAL_CustomSkyGlobe.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if Shift=[] then
  if GetStarFromScreen(x,y,actStarRec) then
        Cursor := crHandPoint
  else
        Cursor := crDefault;
  inherited;
end;

procedure TAL_CustomSkyGlobe.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//  OnBreak := False;
  inherited;
end;

procedure TAL_CustomSkyGlobe.Paint;
begin
  inherited;
end;

procedure TAL_CustomSkyGlobe.SetInversMap(const Value: boolean);
begin
  FInversMap := Value;
  if Value then begin
     BackColor := clWhite;
  end;
  invalidate;
end;

procedure TAL_CustomSkyGlobe.SetSelectedSAO(const Value: integer);
begin
  FSelectedSAO := Value;
  invalidate;
end;

procedure TAL_CustomSkyGlobe.SetStarFile(const Value: string);
begin
  FStarFile := Value;
  Loading := True;
  If FileExists(FStarFile) then begin
     StarStream.LoadFromFile(FStarFile);
  end;
  Loading := False;
end;

procedure TAL_CustomSkyGlobe.SetConstBFile(const Value: string);
begin
  FConstBFile := Value;
  If FileExists(FConstBFile) then begin
     ConstBStream.LoadFromFile(FConstBFile);
  end;
end;

procedure TAL_CustomSkyGlobe.SetConstLFile(const Value: string);
begin
  FConstLFile := Value;
  If FileExists(FConstLFile) then begin
     ConstLStream.LoadFromFile(FConstLFile);
  end;
end;

procedure TAL_CustomSkyGlobe.SetConstBVisible(const Value: boolean);
begin
  FConstBVisible := Value;
  invalidate;
end;

procedure TAL_CustomSkyGlobe.SetConstLVisible(const Value: boolean);
begin
  FConstLVisible := Value;
  invalidate;
end;

procedure TAL_CustomSkyGlobe.SetStarVisible(const Value: boolean);
begin
  FStarVisible := Value;
  invalidate;
end;

procedure TAL_CustomSkyGlobe.SetDataPath(const Value: string);
begin
  FDataPath := Value;
  StarFile           := FDataPath+'AL_Sky.SKY';
  ConstBFile         := FDataPath+'ConstB.dat';
  ConstLFile         := FDataPath+'Figures.dat';
end;

procedure TAL_CustomSkyGlobe.SetAction(const Value: TSkyMapAction);
begin
  FAction := Value;
end;

procedure TAL_CustomSkyGlobe.SetCoordType(const Value: TCoordType);
begin
  FCoordType := Value;
  if Value=coordHorizontal then begin
     Theta := ALT;
//     Meridian := ;
  end;
end;

procedure TAL_CustomSkyGlobe.SetPhotoPlate(const Value: TPoint);
begin
  FPhotoPlate := Value;
  invalidate;
end;

procedure TAL_CustomSkyGlobe.SetPlateVisible(const Value: boolean);
begin
  FPlateVisible := Value;
  invalidate;
end;

procedure TAL_CustomSkyGlobe.OnTimer(Sender: TObject);
begin

end;

function TAL_CustomSkyGlobe.GetPlateRect: TRect;
var i,j: integer;
begin
     i := Trunc(Zoom*sin(DegToRad(FPhotoPlate.x/120)));
     j := Trunc(Zoom*sin(DegToRad(FPhotoPlate.y/120)));
     Result := Rect((Width div 2)-i,(Height div 2)-j,(Width div 2)+i,(Height div 2)+j);
end;

end.
