
(*
  TAL_CustomGlobe     - Free Delphi(5) visual component
  _____________________________________________________
  By Agócs László     - StellaSOFT (Hungary) 2012

  Draws a globe with geographic coordinate's grid.

  Image = Loadable image from file or paste from clipboard. This back image is
        maybe a globe (ex.: Sun, Moon or planets).
  First task: to align the grid to the image
        (with adjust the Centrum, Radius, Theta, Phi and Meridian parameteres)
  GlobeVisible, CoordFont: shows the coordinates labels.

  Interactiviti: with mouse;
  1. You can drag the grid with pressed left mouse button (+Shift button or without);
  2. Magnify with wheel mouse or pressed right mouse button;
  3. You can drag the image with pressed left mouse button if globe Locked;
  4. Magnify with Gray+/-;
  5. Assigned clipboard functions: Ctrl+C, Ctrl+V;
  6. Enter = move to cent; Ctrl+Enter = FitToScreen;


  See: HELP: ALGlobe.hlp and DEMO: ALGlobeDemo.dpr
*)

unit AL_Globe;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Clipbrd, StdCtrls,
  NewGeom, Math;

Type

  TGlobeType = (gtyGeo, gtyAstro);

  TCoordType=(coordGeo,coordEquatorial,coordHorizontal);

  TAL_CustomGlobe = class(TCustomControl)
  private
    FTheta: double;
    FAspect: double;
    FPFi: double;
    FRadius: double;
    FImageFile: string;
    FGridPen: TPen;
    FCentrum: TPoint2d;
    FGlobeVisible: boolean;
    FMeridian: double;
    FCoordFont: TFont;
    FAfterPaint: TNotifyEvent;
    FCirclePen: TPen;
    FEquatorPen: TPen;
    FFitImage: boolean;
    FImageOrigin: TPoint;
    FLabelVisible: boolean;
    fZoom: double;
    FLabelFont: TFont;
    FCentralCross: boolean;
    FBackColor: TColor;
    FLocked: boolean;
    FMouseLeave: TNotifyEvent;
    FMouseEnter: TNotifyEvent;
    FRotAngleY: double;
    FImageLocked: boolean;
    FImageVisible: boolean;
    FdeltaAlt: double;
    FdeltaLat: double;
    FCrossPen: TPen;
    FChange: TNotifyEvent;
    FGlobeCoord: TPoint3d;
    FCoordLabel: TLabel;
    FGlobeType: TGlobeType;
    FGlobeColor: TColor;
    FBeforePaint: TNotifyEvent;
    procedure Change(Sender: TObject);
    procedure Changed;
    procedure WMEraseBkGnd(var Message:TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure CMMouseEnter(var msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var msg: TMessage); message CM_MOUSELEAVE;
    procedure SetAspect(const Value: double);
    procedure SetPFi(const Value: double);
    procedure SetImageFile(const Value: string);
    procedure SetZoom(const Value: double);
    procedure SetTheta(const Value: double);
    procedure SetCentrum(const Value: TPoint2d);
    procedure SetCirclePen(const Value: TPen);
    procedure SetLabelFont(const Value: TFont);
    procedure SetGlobeVisible(const Value: boolean);
    procedure SetEquatorPen(const Value: TPen);
    procedure SetGridPen(const Value: TPen);
    procedure SetImageOrigin(const Value: TPoint);
    procedure SetMeridian(const Value: double);
    procedure SetFitImage(const Value: boolean);
    procedure SetLabelVisible(const Value: boolean);
    procedure SetBackColor(const Value: TColor);
    procedure SetCentralCross(const Value: boolean);
    procedure SetLocked(const Value: boolean);
    procedure SetRotAngleY(const Value: double);
    procedure SetImageLocked(const Value: boolean);
    procedure SetImageVisible(const Value: boolean);
    procedure SetdeltaAlt(const Value: double);
    procedure SetdeltaLat(const Value: double);
    procedure SetCrossPen(const Value: TPen);
    function getALT: double;
    function getLAT: double;
    procedure SetALT(const Value: double);
    procedure SetLAT(const Value: double);
    procedure SetGlobeCoord(const Value: TPoint3d);
    procedure SetGlobeType(const Value: TGlobeType);
    procedure SetGlobeColor(const Value: TColor);
  protected
    Ux0,Uy0: Integer;
    oldGlobeCoord : TPoint3d;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint): Boolean; override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure Click;  override;
    procedure DblClick;  override;
  public
    Image  : TBitMap;     // Bitmap for image
    BMP    : TBitMap;     // Back memory bitmap for drawing
    Loading    : boolean;
    OnBreak    : boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;

    procedure ClearImage;
    procedure CutToClipboard;
    procedure CopyToClipboard;
    procedure PasteFromClipboard;

    function GetGlobeCoord(x,y: integer): TPoint3d;
    function GetGlobeXY(lambda,fi: double): TPoint3d;
    function GetGlobeXYDeg(lambda,fi: double): TPoint3d;
    function GlobeCoordToStr(p: TPoint3d): string;

    procedure DrawLatLine(fi1,fi2,lambda: double);
    procedure DrawAltLine(lambda1,lambda2,fi: double);

    procedure FitToScreen;
    procedure GlobeToCent;
    procedure ImageToCent;
    procedure GlobeToNullPosition;
    procedure AutoImageToCent;  // Automatic image centrum detection if it is contain a globe

    property Centrum     : TPoint2d read FCentrum write SetCentrum;  // x,y in screen
    property ImageOrigin : TPoint read FImageOrigin write SetImageOrigin;   // Image topleft corner coord.
    property GlobeCoord  : TPoint3d read FGlobeCoord write SetGlobeCoord;   // (LAT,ALT,z)

    // Published properties

    property GlobeType   : TGlobeType read FGlobeType write SetGlobeType;
    property BackColor   : TColor read FBackColor write SetBackColor;
    property GlobeColor  : TColor read FGlobeColor write SetGlobeColor;
    property CentralCross: boolean read FCentralCross write SetCentralCross;
    property CoordLabel  : TLabel read FCoordLabel write FCoordLabel;
    property FitImage    : boolean read FFitImage write SetFitImage; // Image to Centre
    property Zoom        : double read fZoom write SetZoom;          // Radius of globe in screen
    property LAT         : double read getLAT write SetLAT;          // Latitude on globe
    property ALT         : double read getALT write SetALT;          // Latitude on globe
    property Theta       : double read FTheta write SetTheta;        // Polar rot. angle latitude
    property Pfi         : double read FPFi write SetPFi;            // Polar rot. angle altitude
    property RotAngleY   : double read FRotAngleY write SetRotAngleY;  // Rotate angle around the centrum
    property deltaAlt    : double read FdeltaAlt write SetdeltaAlt;
    property deltaLat    : double read FdeltaLat write SetdeltaLat;
    property Meridian    : double read FMeridian write SetMeridian;  // Null meridian altitude
    property Aspect      : double read FAspect write SetAspect;      // Y = Aspect*Y munliplication
    property GridPen     : TPen read FGridPen write SetGridPen;      // Pen for grid
    property CrossPen    : TPen read FCrossPen write SetCrossPen;    // Pen for central cross
    property EquatorPen  : TPen read FEquatorPen write SetEquatorPen;// Pen for equator
    property CirclePen   : TPen read FCirclePen write SetCirclePen;  // Pen for circle round globe
    property ImageVisible: boolean read FImageVisible write SetImageVisible;
    property GlobeVisible: boolean read FGlobeVisible write SetGlobeVisible;
    property LabelVisible: boolean read FLabelVisible write SetLabelVisible;
    property LabelFont   : TFont read FLabelFont write SetLabelFont; // Font for labels
    property Locked      : boolean read FLocked write SetLocked;     // Lock a Centrum.x to width/2
    property ImageLocked : boolean read FImageLocked write SetImageLocked;     // Lock a Centrum.x to width/2
    property ImageFile   : string read FImageFile write SetImageFile;// Image file name with path
    property OnChange    : TNotifyEvent read FChange write FChange;
    property OnBeforePaint: TNotifyEvent read FBeforePaint write FBeforePaint;
    property OnAfterPaint: TNotifyEvent read FAfterPaint write FAfterPaint;
    property OnMouseEnter: TNotifyEvent read FMouseEnter write FMouseEnter;
    property OnMouseLeave: TNotifyEvent read FMouseLeave write FMouseLeave;
  end;

  // Simple globe/sphere component with basic parameters and procedure
  // It maybe the base for develope a complex geographic or skymap program

  TAL_Globe = class(TAL_CustomGlobe)
  published
    property Align;
    property GlobeType;
    property BackColor;
    property CentralCross;
    property CoordLabel;
    property FitImage;
    property Zoom;
    property Theta;
    property Pfi;
    property RotAngleY;
    property deltaAlt;
    property deltaLat;
    property Meridian;
    property Aspect;
    property GridPen;
    property EquatorPen;
    property CirclePen;
    property ImageVisible;
    property GlobeVisible;
    property LabelVisible;
    property LabelFont;
    property Locked;
    property ImageLocked;
    property ImageFile;
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

function GlobePoint( fi, lambda: double ): TPoint3d;
function RotX( const p: TPoint3d; alfa: double ): TPoint3d;
function RotY( const p: TPoint3d; alfa: double ): TPoint3d;
function RotZ( const p: TPoint3d; alfa: double ): TPoint3d;
Function Rot2d(x,y: double;porigo:TPoint2d;alfa:double):TPoint2d;

  procedure Register;

implementation

{$R AL_Globe.Dcr}

procedure Register;
begin
  RegisterComponents('AL',[TAL_Globe]);
end;

// 3D GEOMETRY ROUTINS
// ========================================================================

// Get the radius=1 sphere x,y,z coordinates
function GlobePoint( fi, lambda: double ): TPoint3d;
begin
   Result.x := cos( fi ) * sin( lambda );
   Result.y := sin( fi );
   Result.z := cos( fi ) * cos( lambda );
end;

// Rotate the p point around the X axis
function RotX( const p: TPoint3d; alfa: double ): TPoint3d;
begin
   Result.x := p.x;
   Result.y := cos( alfa )*p.y + sin( alfa )*p.z;
   Result.z := -sin( alfa )*p.y + cos( alfa )*p.z;
end;

// Rotate the p point around the Y axis
function RotY( const p: TPoint3d; alfa: double ): TPoint3d;
begin
   Result.x := cos( alfa )*p.x + sin( alfa )*p.z;
   Result.y := p.y;
   Result.z := -sin( alfa )*p.x + cos( alfa )*p.z;
end;

// Rotate the p point around the Z axis
function RotZ( const p: TPoint3d; alfa: double ): TPoint3d;
begin
   Result.x := cos( alfa )*p.x + sin( alfa )*p.y;
   Result.y := -sin( alfa )*p.x + cos( alfa )*p.y;
   Result.z := p.z;
end;

// Rotate around the porigo(Centrum) in Descartes coord.system
Function Rot2d(x,y: double;porigo:TPoint2d;alfa:double):TPoint2d;
var c,s : double;
begin
  c := COS(alfa); s := SIN(alfa);  {szög radiánban}
  x := x - porigo.x;
  y := y - porigo.y;
  Result.x := x * c + y * s + porigo.x;
  Result.y := y * c - x * s + porigo.y;
end;

{ TAL_CustomGlobe }
//==========================================================================
constructor TAL_CustomGlobe.Create(AOwner: TComponent);
begin
  inherited;
  Image          := TBitMap.Create;     // Bitmap for image
  BMP            := TBitMap.Create;     // Back memory bitmap for drawing
  FGridPen       := TPen.Create;
  FCrossPen      := TPen.Create;
  FEquatorPen    := TPen.Create;
  FCirclePen     := TPen.Create;
  FLabelFont     := TFont.Create;
  with FGridPen do begin
       Width     := 1;
       Color     := clGray;
       OnChange  := Change;
  end;
  with FCrossPen do begin
       Width     := 1;
       Color     := clMaroon;
       OnChange  := Change;
  end;
  with FEquatorPen do begin
       Width     := 1;
       Color     := clBlue;
       OnChange  := Change;
  end;
  with FCirclePen do begin
       Width     := 2;
       Color     := clGray;
       OnChange  := Change;
  end;
  with FLabelFont do begin
       Name      := 'Courier New';
       Height    := 16;
       Color     := clGray;
       OnChange  := Change;
  end;
  FGlobeType     := gtyGeo;
  FLabelVisible  := True;
  FGlobeVisible  := True;
  FImageVisible  := False;
  FImageOrigin   := Point(0,0);
  FFitImage      := True;
  FAspect        := 1.000;
  FTheta         := 0;
  FPfi           := 0;
  FMeridian      := 0;
  FdeltaAlt      := 10;
  FdeltaLat      := 10;
  FRotAngleY     := 0;
  FBackColor     := clBlack;
  FGlobeColor    := $00510028;
  FZoom          := 200;
  FCentrum       := Point2d(200,200);
  FLocked        := True;
  FCentralCross  := False;
  DoubleBuffered := False;
  TabStop        := True;
  Width          := 400;
  Height         := 400;
end;

destructor TAL_CustomGlobe.Destroy;
begin
  FGridPen.Free;
  FCrossPen.Free;
  EquatorPen.Free;
  FCirclePen.Free;
  FLabelFont.Free;
  Image.Free;
  BMP.Free;
  inherited;
end;

procedure TAL_CustomGlobe.Change(Sender: TObject);
begin
  invalidate;
end;


procedure TAL_CustomGlobe.Changed;
begin
  invalidate;
  if Assigned(FChange) then FChange(Self);
end;


procedure TAL_CustomGlobe.Click;
begin
  inherited;
end;

procedure TAL_CustomGlobe.DblClick;
begin
  FMeridian := RadToDeg(GlobeCoord.x);
  FTheta    := RadToDeg(GlobeCoord.y);
//  Centrum := Point2d(width/2,height/2);
  Changed;
  inherited;
end;

function TAL_CustomGlobe.DoMouseWheel(Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint): Boolean;
var a: double;
begin
  Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos);
  if WheelDelta>=0 then a:=1.02 else a:=0.98;
  Zoom := FZoom * a;
end;

function TAL_CustomGlobe.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelDown(Shift, MousePos);
end;

function TAL_CustomGlobe.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelUp(Shift, MousePos);
end;

procedure TAL_CustomGlobe.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Ux0 := x; Uy0 := y;
  GlobeCoord := GetGlobeCoord( x, y );
  inherited;
end;

procedure TAL_CustomGlobe.MouseMove(Shift: TShiftState; X, Y: Integer);
var fi1,fi2: double;
    dx,dy  : double;
    p      : TPoint3d;
begin
  dx := x-Centrum.x; dy := y-Centrum.Y;
  GlobeCoord := GetGlobeCoord( x, y );
  if CoordLabel<>nil then
     CoordLabel.Caption := GlobeCoordToStr(GlobeCoord);

  if Shift = [ssLeft] then begin
     Centrum := Point2d(FCentrum.x+x-UX0,FCentrum.Y+(y-UY0));
     ImageOrigin := Point(FImageOrigin.x+x-UX0,FImageOrigin.Y+(y-UY0));
  end;

  if Shift = [ssRight] then begin
     if (UY0-y)>0 then Zoom := FZoom * 1.1;
     if (UY0-y)<0 then Zoom := FZoom * 0.9;
  end;

     if (Shift = [ssShift,ssLeft]) or (Locked and (Shift = [ssLeft])) then begin  // Rotate around x axis
     Try
       if FZoom>RelDist2D(Point2D(x,y),Centrum) then begin
        fi1   := ArcSin(Frac((UX0-Centrum.x)/FZoom));
        fi2   := ArcSin(Frac(dx/FZoom));
        FMeridian := FMeridian+(RadToDeg(fi2-fi1));
        fi1   := ArcSin(Frac((UY0-Centrum.y)/FZoom));
        fi2   := ArcSin(Frac(dy/FZoom));
        Theta:= FTheta+(RadToDeg(fi2-fi1));
       end;
     except
        Theta := FTheta;
     end;
     end;
     if Shift = [ssShift,ssRight] then begin // Rotate around the globe axis
        fi1   := ArcSin(Frac((UX0-Centrum.x)/FZoom));
        fi2   := ArcSin(Frac(dx/FZoom));
        Meridian := FMeridian+(RadToDeg(fi2-fi1));
     end;

  if ssCtrl in Shift then        // If Ctrl is pressed
  begin
  end;

  Ux0 := x; Uy0 := y;
  inherited;
end;

procedure TAL_CustomGlobe.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
end;

procedure TAL_CustomGlobe.SetAspect(const Value: double);
begin
  if FAspect <> Value then begin
     FAspect := Value;
     Changed;
  end;
end;

procedure TAL_CustomGlobe.SetCentrum(const Value: TPoint2d);
begin
  FCentrum := Value;
  if FLocked then
     FCentrum := Point2d(width/2,Value.y);
  Changed;
end;

procedure TAL_CustomGlobe.SetCirclePen(const Value: TPen);
begin
  FCirclePen := Value;
end;

procedure TAL_CustomGlobe.SetLabelFont(const Value: TFont);
begin
  FCoordFont := Value;
end;

procedure TAL_CustomGlobe.SetGlobeVisible(const Value: boolean);
begin
  FGlobeVisible := Value;
  Changed;
end;

procedure TAL_CustomGlobe.SetEquatorPen(const Value: TPen);
begin
  FEquatorPen := Value;
  Changed;
end;

procedure TAL_CustomGlobe.SetPFi(const Value: double);
begin
 if FPFi <> Value then begin
  FPFi := Value;
  Changed;
 end;
end;

procedure TAL_CustomGlobe.SetGridPen(const Value: TPen);
begin
  FGridPen := Value;
end;

procedure TAL_CustomGlobe.SetImageFile(const Value: string);
begin
  FImageFile := Value;
  if FileExists(Value) then begin
      Image.LoadFromFile(Value);
      Image.FreeImage;
    end
  else begin
  end;
  Changed;
end;

procedure TAL_CustomGlobe.SetImageOrigin(const Value: TPoint);
begin
  if not FImageLocked then begin
     FImageOrigin := Value;
     Changed;
  end;
end;

procedure TAL_CustomGlobe.SetMeridian(const Value: double);
begin
 if FMeridian<>Value then begin
  FMeridian := (Trunc(Value) mod 360) + Frac(Value);
  Changed;
 end;
end;

procedure TAL_CustomGlobe.SetZoom(const Value: double);
var oZoom: double;
    magni: double;
    dx,dy: double;
begin
 if FZoom <> Value then begin
  oZoom := FZoom;
  FZoom := Value;
  if FZoom<4 then FZoom:=4;
  magni := FZoom/oZoom;
  dx := magni*(Centrum.x-Width/2);
  dy := magni*(Centrum.y-Height/2);
  Centrum:=Point2d(Width/2+dx,Height/2+dy);
 end;
end;

procedure TAL_CustomGlobe.SetTheta(const Value: double);
begin
 if FTheta <> Value then begin
  FTheta := Value;
  if FTheta>90 then FTheta:=90;
  if FTheta<-90 then FTheta:=-90;
  Changed;
 end;
end;

procedure TAL_CustomGlobe.SetFitImage(const Value: boolean);
var w,h   : integer;
begin
  FFitImage := Value;
  if FFitImage then begin
     w := 0;
     h := 0;
     FImageOrigin := Point(w,h);
  end;
  Changed;
end;


procedure TAL_CustomGlobe.SetLabelVisible(const Value: boolean);
begin
  FLabelVisible := Value;
  Changed;
end;

procedure TAL_CustomGlobe.SetBackColor(const Value: TColor);
begin
  FBackColor := Value;
  invalidate;
end;

procedure TAL_CustomGlobe.SetCentralCross(const Value: boolean);
begin
  FCentralCross := Value;
  Changed;
end;

procedure TAL_CustomGlobe.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1
end;

procedure TAL_CustomGlobe.WMSize(var Msg: TWMSize);
begin
  BMP.Width := Msg.Width;
  BMP.Height := Msg.Height;
  Theta := FTheta;
//  FitImage := FFitImage;
  invalidate;
end;

procedure TAL_CustomGlobe.SetLocked(const Value: boolean);
begin
 if FLocked <> Value then begin
  FLocked := Value;
  if FLocked then
     Centrum := Point2d(width/2,Height/2);
 end;
end;

procedure TAL_CustomGlobe.CMMouseEnter(var msg: TMessage);
begin
  if TabStop then SetFocus;
  invalidate;
  if Assigned(FMouseEnter) then FMouseEnter(Self);
end;

procedure TAL_CustomGlobe.CMMouseLeave(var msg: TMessage);
begin
  invalidate;
  if Assigned(FMouseLeave) then FMouseLeave(Self);
end;

procedure TAL_CustomGlobe.SetRotAngleY(const Value: double);
begin
 if FRotAngleY <> Value then begin
  FRotAngleY := Value;
  Changed;
 end;
end;

procedure TAL_CustomGlobe.SetImageLocked(const Value: boolean);
begin
  FImageLocked := Value;
end;

procedure TAL_CustomGlobe.GlobeToCent;
begin
  Centrum := Point2d(width/2,Height/2);
end;

procedure TAL_CustomGlobe.ImageToCent;
begin
  ImageOrigin := Point((width-Image.Width) div 2,(Height-Image.Height) div 2);
end;

procedure TAL_CustomGlobe.AutoImageToCent;
begin

end;

procedure TAL_CustomGlobe.SetImageVisible(const Value: boolean);
begin
  FImageVisible := Value;
  Changed;
end;


procedure TAL_CustomGlobe.ClearImage;
begin
  Image.Width  := 0;
  Image.Height := 0;
  Changed;
end;

procedure TAL_CustomGlobe.CutToClipboard;
begin
   CopyToClipboard;
   ClearImage;
end;

procedure TAL_CustomGlobe.CopyToClipboard;
begin
  Clipboard.Assign(BMP);
end;

procedure TAL_CustomGlobe.PasteFromClipboard;
begin
  if Clipboard.HasFormat(CF_PICTURE) then begin
    Image.Assign(Clipboard);
    Changed;
  end;
end;

procedure TAL_CustomGlobe.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Shift=[] then
  Case Key of
  VK_RETURN   : GlobeToNullPosition;
  VK_ADD      : Zoom := 1.1*Zoom;
  VK_SUBTRACT : Zoom := 0.9*Zoom;
  189         : Zoom := 0.9*Zoom;
  end;
  if Shift=[ssCtrl] then
  Case Key of
  VK_RETURN   : FitToScreen;
  VK_LEFT     : Meridian := FMeridian + 1/FZoom;
  end;
  inherited;
end;

procedure TAL_CustomGlobe.KeyPress(var Key: Char);
begin
  Case Key of
  ^X          : CutToClipboard;
  ^C          : COPYToClipboard;
  ^V          : PasteFromClipboard;
  #13         : GlobeToNullPosition;
  '-'         : Zoom := 0.9*Zoom;
  '+'         : Zoom := 1.1*Zoom;
  'K','k'     : CentralCross:=not FCentralCross;     
  end;
  inherited;
end;

procedure TAL_CustomGlobe.GlobeToNullPosition;
begin
  FTheta := 0;
  FPfi    := 0;
  FRotAngleY := 0;
  GlobeToCent;
end;

procedure TAL_CustomGlobe.SetdeltaAlt(const Value: double);
begin
  FdeltaAlt := Value;
  Changed;
end;

procedure TAL_CustomGlobe.SetdeltaLat(const Value: double);
begin
  FdeltaLat := Value;
  Changed;
end;

procedure TAL_CustomGlobe.Paint;
var tps: tagPAINTSTRUCT;
   alfa   : double;
   beta   : double;
   fi,alt : Integer;
   lambda : Integer;
   pont   : TPoint3d;
   p      : TPoint2d;
   OldpOn : boolean;
   pOn    : boolean;
   R      : double;
   x,y    : double;
begin
Try
  Loading := True;
  OnBreak := False;
  With BMP.Canvas do begin
  beginpaint(Handle,tps );

   R    := FZoom;
   alfa := FTheta * pi/180;
   beta := FPfi * pi/180;

   Brush.Style := bsSolid;
   Cls(BMP.Canvas,FBackColor);

  if Assigned(FBeforePaint) then FBeforePaint(Self);

   if FFitImage then
      FImageOrigin := Point((width-Image.Width) div 2,(Height-Image.Height) div 2);
   if FLocked then
      FCentrum := Point2d(width/2,Height/2);

   if FImageVisible then begin
      Draw(ImageOrigin.x,ImageOrigin.y,Image);   // Draw the back image
   end;

   if FGlobeVisible then begin

   if not FImageVisible then begin
      Brush.Color := FGlobeColor;
      Ellipse(Round(Centrum.x-R),Round(Centrum.y-R),Round(Centrum.x+R),Round(Centrum.y+R));
   end;
   Brush.Style := bsClear;

   // Drawing the altitudes
   for fi := -8 to 8 do begin
       OldpOn  := False;
       pOn     := False;
       if fi=0 then
          Pen.Assign(EquatorPen)
       else
          Pen.Assign(GridPen);
      for lambda := 0 to 360 do begin
          pont := Rotz( Rotx(
             GlobePoint( fi*FdeltaAlt*pi/180, lambda*pi/180),
             alfa), beta );
          x := Centrum.x+pont.x*R;
          y := Centrum.y+FAspect*pont.y*R;
          pOn := pont.z > 0;
          if pOn and OldpOn then
             LineTo(Round(x), Round(y))
          else
             MoveTo(Round(x), Round(y));
          OldpOn := pOn;
      end;
   end;

   // Drawing the latidudes
   Pen.Assign(GridPen);
   for lambda := 0 to Trunc((360-FdeltaLat) / FdeltaLat)
   do begin
       OldpOn  := False;
       pOn     := False;
       if lambda=0 then
          Pen.Assign(EquatorPen)
       else
          Pen.Assign(GridPen);
     for fi := -80 to 80 do begin
          pont := Rotz( Rotx(
             GlobePoint( fi*pi/180, (Meridian+lambda*FdeltaLat)*pi/180),
             alfa), beta );
          x := Centrum.x+pont.x*R;
          y := Centrum.y+FAspect*pont.y*R;
          pOn := pont.z > 0;
          if pOn and OldpOn then
             LineTo(Round(x), Round(y))
          else
             MoveTo(Round(x), Round(y));
          OldpOn := pOn;
      end;
   end;

   // Drawing Pole cross
   if fTheta>29 then begin
      pont := GetGlobeXY(0,PI/2);
      ShowCross(BMP.Canvas,Round(pont.x),Round(pont.y),4);
   end;
   if fTheta<29 then begin
      pont := GetGlobeXY(0,-PI/2);
      ShowCross(BMP.Canvas,Round(pont.x),Round(pont.y),4);
   end;


   If FLabelVisible and (FZoom>200) then begin
      Font.Assign(LabelFont);
      // Scale for altitudes on equator
      for lambda := 0 to Trunc(350/FdeltaLat) do begin
          Fi := 0;
          pont := RotZ( RotX(
             GlobePoint( fi, (Meridian-lambda*FdeltaLat)*pi/180),
             alfa), beta );
          x := Centrum.x+pont.x*R;
          y := Centrum.y+FAspect*pont.y*R;
          if pont.z > 0 then
             TextOut(Round(x),Round(y),Inttostr(Trunc(FdeltaLat*lambda)));
      end;
      // Scale for latitudes around the globe
      for fi := -8 to 8 do begin
          pont := RotZ( RotX(
             GlobePoint( fi*FdeltaAlt*pi/180, Meridian*pi/180),
             alfa), beta );
          x := Centrum.x+pont.x*R;
          y := Centrum.y+FAspect*pont.y*R;
          if pont.z > 0 then begin
             alt := -fi;
             if Abs(fi)>9 then begin
                if alt<0 then alt := -9-(alt mod 9);
                if alt>0 then alt := 9-(alt mod 9);
             end;
             TextOut(Round(x),Round(y),Inttostr(Trunc(FdeltaAlt*alt)));
          end;
      end;
   end;

   end;

   Pen.Assign(CirclePen);
   Ellipse(Round(Centrum.x-R),Round(Centrum.y-R),Round(Centrum.x+R),Round(Centrum.y+R));

   if FCentralCross then begin
      Pen.Assign(CrossPen);
      ShowCross(BMP.Canvas,width div 2,Height div 2,1000);
   end;

  end;
finally
  if Assigned(FAfterPaint) then FAfterPaint(Self);
  endpaint(BMP.Canvas.Handle,tps);
  Canvas.Draw(0,0,BMP);
  Loading := False;
  OnBreak := False;
end;
end;

procedure TAL_CustomGlobe.SetCrossPen(const Value: TPen);
begin
  FCrossPen := Value;
end;

procedure TAL_CustomGlobe.FitToScreen;
var w: integer;
begin
  if Width>Height then w:=Height else w:=Width;
  FZoom := (w-10)/2;
  FCentrum := Point2d(width/2,Height/2);
  Changed;
end;

// Calculate the 2d x,y coordainates retaliv to Centrum from globe coord.
//           lambda,fi in radian
function TAL_CustomGlobe.GetGlobeXY(lambda, fi: double): TPoint3d;
var p: TPoint2d;
    radian: double;
begin
  radian := pi/180;
  Result := RotZ( RotX(
          GlobePoint( -fi, ((Meridian*radian)-lambda)),
          FTheta * radian), FPfi * radian );
  Result.x := Centrum.x+Result.x*FZoom;
  Result.y := Centrum.y+FAspect*Result.y*FZoom;
end;

// Calculate the 2d x,y coordainates retaliv to Centrum from globe coord.
//           lambda,fi in degrees
function TAL_CustomGlobe.GetGlobeXYDeg(lambda, fi: double): TPoint3d;
var p: TPoint2d;
begin
  Result := RotZ( RotX(
          GlobePoint( -fi*pi/180, (Meridian-lambda)*pi/180),
          FTheta * pi/180), FPfi * pi/180 );
  Result.x := Centrum.x+Result.x*FZoom;
  Result.y := Centrum.y+FAspect*Result.y*FZoom;
end;


function TAL_CustomGlobe.getALT: double;
begin
//  Result := FTheta;
end;

function TAL_CustomGlobe.getLAT: double;
begin

end;

procedure TAL_CustomGlobe.SetALT(const Value: double);
begin

end;

procedure TAL_CustomGlobe.SetLAT(const Value: double);
begin

end;

// Get the globe coordinates from x,y position on planar sigth of globe
// Result P(lambda,fi,z) in radian
function TAL_CustomGlobe.GetGlobeCoord( x, y: integer ): TPoint3d;
var dx,dy: double;           // rel. coord. to the globe origo
    d    : double;           // distance from globe centre in 2d
    p    : TPoint3d;         // Point 3d coordinates
    RN   : double;
    z    : double;
    r    : double;           // 
    lambda,fi: double;       // Globe coordinetes  (alt.,lat.)
begin

Try
  Canvas.Pen.Color := clWhite;
  dx := (x - FCentrum.x);                        // Rel coord. to the centre of planar globe
  dy := -(y - FCentrum.y);
  d  := Sqrt(dx * dx + dy * dy);                 // Pont distance from globe centre on plane
  if d <= FZoom then begin
     z      := SQRT((FZoom*FZoom) - (d*d));
     Result := RotX(RotZ(Point3d(dx,dy,z),FPfi*pi/180),FTheta*pi/180);
     fi     := ArcSin(Result.y/FZoom);
     lambda := Arctan(Result.x/Result.z);
     if Result.z<0 then
        lambda := (lambda+pi);
     lambda := lambda-DegToRad(FMeridian);
     if lambda<0 then
        lambda := 2*pi+lambda;
     Result := Point3d(2*pi-lambda,fi,Result.z);
  end else
     Result := Point3d(0,0,-1);  // z coord < 0 : Signes that point is not on globe
  GlobeCoord := Result;
except
  Result := Point3d(0,0,-1);
  GlobeCoord := Result;
end;

end;

function TAL_CustomGlobe.GlobeCoordToStr(p: TPoint3d): string;
begin
  Result := '';
  Case FGlobeType of
  gtyGeo:
     Result := Format('%6.2f',[RadToDeg(p.x)])+':'
            +Format('%6.2f',[RadToDeg(p.y)]);
  gtyAstro:
     begin
     end;
  end;
end;


procedure TAL_CustomGlobe.SetGlobeCoord(const Value: TPoint3d);
begin
  FGlobeCoord := Value;
end;

procedure TAL_CustomGlobe.SetGlobeType(const Value: TGlobeType);
begin
  FGlobeType := Value;
  Changed;
end;

// Draw a Line paralel to latitude  (input in degrees)
procedure TAL_CustomGlobe.DrawLatLine(fi1,fi2,lambda: double);
var k    : integer;
    p    : TPoint3d;
    pOn, OldpOn : boolean;
begin
  if fi1>fi2 then fi2 := 360*fi2;
  k:=0;
  OldpOn := False;
  pOn    := False;
  repeat
    p := GetGlobeXY(lambda*pi/180,(fi1+k)*pi/180);
    pOn := p.z>0;
    if pOn and OldpOn then
       Canvas.Lineto(Round(p.x),Round(p.y))
    else
       Canvas.Moveto(Round(p.x),Round(p.y));
    OldpOn := pOn;
    Inc(k);
  until fi1+k>=fi2+1;
end;

// Draw a Line paralel to altitude
procedure TAL_CustomGlobe.DrawAltLine(lambda1,lambda2,fi: double);
var k    : integer;
    p    : TPoint3d;
    pOn, OldpOn : boolean;
begin
  if lambda1>lambda2 then lambda2 := 360*lambda2;
  k:=0;
  OldpOn := False;
  pOn    := False;
  repeat
    p := GetGlobeXY((lambda1+k)*pi/180,fi*pi/180);
    pOn := p.z>0;
    if pOn and OldpOn then
       Canvas.Lineto(Round(p.x),Round(p.y))
    else
       Canvas.Moveto(Round(p.x),Round(p.y));
    OldpOn := pOn;
    Inc(k);
  until lambda1+k>=lambda2+1;
end;

procedure TAL_CustomGlobe.SetGlobeColor(const Value: TColor);
begin
  FGlobeColor := Value;
  Changed;
end;

end.


