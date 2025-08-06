// ===========================================================================
// TALZoomImage
//          is a flicker-free visual reprezentation of memory bitmap
//          By Agócs Lászlo StellaSOFT, Hungary 2009
//          Test in Delphi 5
//          Licens: Absolutely Free!!!!
// Load/Save image files: JPG, BMP;  (You can develope for other formats!)
// You can dragging the image by pressed left mouse button,
//     and zooming width rotating of mouse wheel button.
// Any point move to the centre by double click or right click
// Optimized speed for drawing.
// If you click on the the component it will be focused if Tabstop property= True;
//
// Needed files:
//        Cursors.res      // curzor images
//        JPeg.pas         // For JPEG images
// ===========================================================================

unit AL_ZoomImgEx;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, JPeg, ClipBrd, NewGeom, STAF_Imp, Printers;

Const PixelMax = 6000;

Type
  { Clipboard copy/paste: Total image; Only on Screen; Only the selected area}
  TClipBoardAction = (cbaTotal,        // Total Image
                      cbaScreen,       // Only the screen image
                      cbaSelected,     // Only the selected area
                      cbaSreenSelected,// Only the selected area from screen
                      cbaFixArea,      // Fix rect from image
                      cbaFixWindow);   // Fix rect from screen

  //Events type for zooming or dragging of component picture
  TChangeWindow = procedure(Sender: TObject; xCent,yCent,xWorld,yWorld,Zoom: double;
                            MouseX,MouseY: integer) of object;

  TBeforePaint = procedure(Sender: TObject; xCent,yCent: double;
                            DestRect: TRect) of object;

  TImageGrid = Class(TPersistent)
  private
    fVisible: boolean;
    FOnChange: TNotifyEvent;
    fOnlyOnPaper: boolean;
    FGridPen: TPen;
    FSubGridPen: TPen;
    FGridDistance: double;
    procedure SetVisible(const Value: boolean);
    procedure SetOnlyOnPaper(const Value: boolean);
    procedure SetGridPen(const Value: TPen);
    procedure SetSubGridPen(const Value: TPen);
    procedure SetGridDistance(const Value: double);
  protected
    procedure Changed;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property GridDistance: double read FGridDistance write SetGridDistance;
    property GridPen: TPen read FGridPen write SetGridPen;
    property SubGridPen: TPen read FSubGridPen write SetSubGridPen;
    property OnlyOnPaper: boolean read fOnlyOnPaper write SetOnlyOnPaper default True;
    property Visible: boolean read fVisible write SetVisible default True;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TRGBSet = (rgbRGB, rgbR, rgbG, rgbB);

  // Object for signifícant of R,G,B chanel visibility:
  // Original composite picture then R=True; G=True and B=True;
  TRGBChanel = class(TPersistent)
  private
    FG: boolean;
    FR: boolean;
    FB: boolean;
    FOnChange: TNotifyEvent;
    FMonoRGB: boolean;
    FRGB: boolean;
    procedure SetB(const Value: boolean);
    procedure SetG(const Value: boolean);
    procedure SetR(const Value: boolean);
    procedure SetMonoRGB(const Value: boolean);
    procedure SetRGB(const Value: boolean);
  protected
    procedure Changed;
  public
    RGBBMP : TBitmap;
    constructor Create;
    destructor Destroy; override;
    procedure ChangeRGB(mono,rr,gg,bb: boolean);
  published
    property MonoRGB : boolean read FMonoRGB write SetMonoRGB;
    property RGB     : boolean read FRGB write SetRGB;
    property R : boolean read FR write SetR default True;
    property G : boolean read FG write SetG default True;
    property B : boolean read FB write SetB default True;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TALCustomZoomImage = class(TCustomControl)
  private
    FClipBoardAction: TClipBoardAction;
    FCentered: boolean;
    FOverMove: boolean;
    FEnableActions: boolean;
    FBackCross: boolean;
    FPixelGrid: boolean;
    FEnableSelect: boolean;
    fCentralCross: boolean;
    fCursorCross: boolean;
    fZoom: extended;
    FBulbRadius: integer;
    FAfterPaint: TBeforePaint;
    FBeforePaint: TBeforePaint;
    FChangeWindow: TChangeWindow;
    FBackColor: TColor;
    FFileName: TFileName;
    FGrid: TImageGrid;
    FMouseLeave: TNotifyEvent;
    FMouseEnter: TNotifyEvent;
    FRGBList: TRGBChanel;
    FActualPixel: TPoint;
    FSelRectVisible: boolean;
    FFitting: boolean;
    FPrinter: TPrinter;
    FPrintView: boolean;
    procedure WMEraseBkGnd(var Message:TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure CMMouseEnter(var msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var msg: TMessage); message CM_MOUSELEAVE;
    procedure SetBackColor(const Value: TColor);
    procedure SetBackCross(const Value: boolean);
    procedure SetBulbRadius(const Value: integer);
    procedure SetCentered(const Value: boolean);
    procedure SetCentralCross(const Value: boolean);
    procedure SetCursorCross(const Value: boolean);
    procedure SetFileName(const Value: TFileName);
    procedure SetOverMove(const Value: boolean);
    procedure SetPixelGrid(const Value: boolean);
    procedure SetRGBList(const Value: TRGBChanel);
    procedure SetZoom(const Value: extended);
    procedure SetSelRectVisible(const Value: boolean);
    procedure SetPrintView(const Value: boolean);
  protected
    timer               : TTimer;     // Timer for any doing;
    pFazis              : integer;    // Fazis for any action
    Origin,MovePt       : TPoint;
    oldOrigin,oldMovePt : TPoint;
    mouseLeft           : boolean;
    oldCursor           : TCursor;
    oldCursorCross      : boolean;
    MouseInOut          : integer;   // Mouse in:1, Mouse:0, Mouse out:-1
    WinRgn              : HRgn;      // Window region;
    AutoPopup           : boolean;   // PopupMenu enable
    procedure Change(Sender: TObject);
    procedure OnTimer(Sender: TObject);
    procedure CalculateRects;
    procedure InitSelWindow;
    procedure SelToScreen;
    procedure InitBackImage;
    procedure pChange(Sender: TObject);
    procedure DrawMouseCross(o:TPoint;PenMode:TPenMode);
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
    OrigBMP        : TBitmap;      // Original bmp in memory
    WorkBMP        : TBitmap;      // bmp copy for working in memory
    BackBMP        : TBitmap;      // Ready bmp for copy to screen
    CopyBMP        : TBitmap;      // Temporary bmp for internal use
    PasteBMP       : TBitmap;      // Temporary bmp for Paste special
    BMPOffset      : TPoint;
    Sizes          : TPoint;       // OriginalBmp sizes (width, height)
    sCent          : TPoint2d;     // Centrum of the source rectangle on WorkBMP
    sRect          : TRect2d;      // Rectangle for part of source bitmap
    dRect          : TRect;        // Rectangle for stretching to the screen
    SelRect        : TRect;        // Selected area on the screen;
    FixRect        : TRect;        // Fix rectangle on image
    FixWinRect     : TRect;        // Fix rectangle on screen
    oldPos         : TPoint;       // Store the old mouse position in window
    cPen           : TPen;         // Pen for central cross;
    Loading        : boolean;      // Something in progress
    Moving         : boolean;      // Indicates the image dragging by mouse
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure New(nWidth, nHeight: integer; nColor: TColor);
    function LoadFromFile(FileName: TFileName):boolean;
    function SaveToFile(FileName: TFileName):boolean;
    procedure CutToClipboard;
    procedure CopyToClipboard;
    procedure PasteFromClipboard;
    procedure PasteSpecial;
    procedure EnablePopup(en: boolean);   // Enable/disable popup menu
    function XToW(x: integer): double;
    function YToW(y: integer): double;
    function XToS(x: double): integer;
    function YToS(y: double): integer;
    function WToS(p: TPoint2d): TPoint;
    function SToW(p: TPoint): TPoint2d;
    function ScreenRectToWorld(R: TRect): TRect;
    function WorldRectToScreen(R: TRect): TRect;
    procedure FitToScreen;
    procedure MoveWindow(x,y: double); overload;
    procedure ShiftWindow(x, y: double);
    procedure MoveToCentrum(x,y: double);
    procedure PixelToCentrum(x,y: integer);
    procedure RestoreOriginal;
    procedure SaveAsOriginal;
    procedure FadeOut(Pause: Integer);
    function GetRGB(x,y: integer): TRGBRec;
    function GetPixelColor(p: TPoint): TColor;
    procedure SetPixelColor(p: TPoint; Co: TColor);
      // Drawing
    procedure FillRect(R: TRect; co: TColor);
    procedure DrawGrid;
    procedure DrawPixelGrid;
      // Printing
    procedure Print;
    property Canvas;
      // Actual pixel coordinates for operation
    property ActualPixel : TPoint read FActualPixel write FActualPixel;
    property SelRectVisible : boolean read FSelRectVisible write SetSelRectVisible;
    // Published properties
    property ClipBoardAction: TClipBoardAction read FClipBoardAction write FClipBoardAction;
    property BackColor   : TColor read FBackColor write SetBackColor;
    property BackCross   : boolean read FBackCross write SetBackCross;
    property BulbRadius  : integer read FBulbRadius write SetBulbRadius default 0;
    property Centered    : boolean read FCentered write SetCentered;
    property CentralCross: boolean read fCentralCross write SetCentralCross;
    property CursorCross: boolean read fCursorCross write SetCursorCross;
    property EnableSelect: boolean read FEnableSelect write FEnableSelect;
    property EnableActions: boolean read FEnableActions write FEnableActions;
    property FileName    : TFileName read FFileName write SetFileName;
    property Fitting     : boolean read FFitting write FFitting;
    property Grid        : TImageGrid read FGrid write FGrid;
    property OverMove    : boolean read FOverMove write SetOverMove;
    property PixelGrid   : boolean read FPixelGrid write SetPixelGrid;
//    property Printer     : TPrinter read FPrinter write FPrinter;
    property PrintView   : boolean read FPrintView write SetPrintView;
    property RGBList     : TRGBChanel read FRGBList write SetRGBList;
    property Zoom        : extended read fZoom write SetZoom;
    property OnChangeWindow: TChangeWindow read FChangeWindow write FChangeWindow;
    property OnBeforePaint: TBeforePaint read FBeforePaint write FBeforePaint;
    property OnAfterPaint: TBeforePaint read FAfterPaint write FAfterPaint;
    property OnMouseEnter: TNotifyEvent read FMouseEnter write FMouseEnter;
    property OnMouseLeave: TNotifyEvent read FMouseLeave write FMouseLeave;
  end;

  TALZoomImage = class(TALCustomZoomImage)
  published
    property Align;
    property ClipBoardAction;
    property BackColor;
    property BackCross;
    property BulbRadius;
    property Centered;
    property CentralCross;
    property CursorCross;
    property EnableSelect;
    property EnableActions;
    property FileName;
    property Fitting;
    property Grid;
    property OverMove;
    property PixelGrid;
    property RGBList;
    property TabStop;
    property Zoom;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnBeforePaint;
    property OnAfterPaint;
    property OnChangeWindow;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
  end;

  procedure Register;

const
  // User definied cursors in CURSORS.RES
  crKez1     = 18000;
  crKez2     = 18001;
  crRealZoom = 18002;
  crNyilUp   = 18003;
  crNyilDown = 18004;
  crNyilLeft = 18005;
  crNyilRight= 18006;
  crZoomIn   = 18007;
  crZoomOut  = 18008;
  crKereszt  = 18009;
  crHelp     = 18100;

implementation

{$R Cursors.RES}

procedure Register;
begin
  RegisterComponents('AL',[TALZoomImage]);
end;

// =============================================================================

{ TImageGrid }

procedure TImageGrid.Changed;
begin if Assigned(FOnChange) then FOnChange(Self); end;

constructor TImageGrid.Create;
begin
  fGridPen       := TPen.Create;
  with fGridPen do begin
       Width := 1;
       Color := clWhite;
       Style := psSolid;
       Mode  := pmCopy;
  end;
  fSubgridPen    := TPen.Create;
  with fSubGridPen do begin
       Width := 1;
       Color := clGray;
       Style := psSolid;
       Mode  := pmCopy;
  end;
  fOnlyOnPaper   := True;
  Changed;
end;

destructor TImageGrid.Destroy;
begin
  fSubgridPen.Free;
  fGridPen.Free;
  inherited;
end;

procedure TImageGrid.SetGridDistance(const Value: double);
begin
  FGridDistance := Value;
  Changed;
end;

procedure TImageGrid.SetGridPen(const Value: TPen);
begin
  FGridPen := Value;
  Changed;
end;

procedure TImageGrid.SetOnlyOnPaper(const Value: boolean);
begin
  FOnlyOnPaper := Value;
  Changed;
end;

procedure TImageGrid.SetSubGridPen(const Value: TPen);
begin
  FSubGridPen := Value;
  Changed;
end;

procedure TImageGrid.SetVisible(const Value: boolean);
begin
  FVisible := Value;
  Changed;
end;

{ TRGBChanel }

procedure TRGBChanel.Changed;
begin
  If Assigned(FOnChange) then FOnChange(Self);
end;

procedure TRGBChanel.ChangeRGB(mono, rr, gg, bb: boolean);
begin
  FR := rr;
  FG := gg;
  FB := bb;
  FMonoRGB := mono;
  Changed;
end;

constructor TRGBChanel.Create;
begin
  FR := True;
  FG := True;
  FB := True;
  FMonoRGB := False;
end;

destructor TRGBChanel.Destroy;
begin
  inherited;
end;

procedure TRGBChanel.SetB(const Value: boolean);
begin
  FB := Value;
  Changed;
end;

procedure TRGBChanel.SetG(const Value: boolean);
begin
  FG := Value;
  Changed;
end;

procedure TRGBChanel.SetMonoRGB(const Value: boolean);
begin
  FMonoRGB := Value;
  Changed;
end;

procedure TRGBChanel.SetR(const Value: boolean);
begin
  FR := Value;
  Changed;
end;

procedure TRGBChanel.SetRGB(const Value: boolean);
begin
  FRGB := Value;
  R   := Value;
  G   := Value;
  B   := Value;
  Changed;
end;

{ TALCustomZoomImage }

constructor TALCustomZoomImage.Create(AOwner: TComponent);
begin
  inherited;
  Screen.Cursors[crKez1]     :=  LoadCursor(HInstance, 'SKEZ_1');
  Screen.Cursors[crKez2]     :=  LoadCursor(HInstance, 'SKEZ_2');
  Screen.Cursors[crRealZoom] :=  LoadCursor(HInstance, 'SREAL_ZOOM');
  Screen.Cursors[crNyilUp]   :=  LoadCursor(HInstance, 'SNYIL_UP');
  Screen.Cursors[crNyilDown] :=  LoadCursor(HInstance, 'SNYIL_DOWN');
  Screen.Cursors[crNyilLeft] :=  LoadCursor(HInstance, 'SNYIL_LEFT');
  Screen.Cursors[crNyilRight]:=  LoadCursor(HInstance, 'SNYIL_RIGHT');
  Screen.Cursors[crZoomIn]   :=  LoadCursor(HInstance, 'SZOOM_IN');
  Screen.Cursors[crZoomOut]  :=  LoadCursor(HInstance, 'SZOOM_OUT');
  Screen.Cursors[crKereszt]  :=  LoadCursor(HInstance, 'SKERESZT');
  Screen.Cursors[crHelp]     :=  LoadCursor(HInstance, 'SHELP_CUR');

  OrigBMP        := TBitmap.Create;
  WorkBMP        := TBitmap.Create;
  CopyBMP        := TBitmap.Create;
  BackBMP        := TBitmap.Create;
  PasteBMP       := TBitmap.Create;
  PasteBMP.OnChange := pChange;
  cPen           := TPen.Create;
  Grid           := TImageGrid.Create;
  fGrid.OnChange := Change;
  fGrid.fVisible := False;
  fGrid.FOnlyOnPaper := True;
  FPixelGrid     := False;
  with cPen do begin
       Color := clRed;
       Style := psSolid;
       Mode  := pmCopy;
  end;
  RGBList        := TRGBChanel.Create;
  RGBList.FOnChange := Change;
  CentralCross   := True;
  BackColor      := clSilver;
  BMPOffset      := Point(0,0);
  fZoom          := 1.0;
  fOverMove      := True;
  fCursorCross   := False;
  oldCursorCross := True;
  MouseInOut     := 1;
  oldMovePt      := Point(-1,-1);
  Sizes          := Point(0,0);
  sRect          := Rect2d(0,0,0,0);
  ControlStyle   := ControlStyle+[csFramed,csReflector,csCaptureMouse];
  TabStop        := True;
  DoubleBuffered := False;
  timer          := TTimer.Create(Self);
  timer.Interval := 10;
  timer.Ontimer  := OnTimer;
  FClipBoardAction := cbaTotal;
  FixRect        := Rect(0,0,100,100);
  FixWinRect     := Rect(0,0,100,100);
  Width          := 200;
  Height         := 200;
  InitSelWindow;
  FEnableSelect  := True;
  AutoPopup      := True;
  fitting        := True;
  New(100,100,clWhite);
end;

destructor TALCustomZoomImage.Destroy;
begin
  OrigBMP.Free;
  WorkBMP.Free;
  BackBMP.Free;
  CopyBMP.Free;
  PasteBMP.Free;
  cPen.Free;
  Grid.Free;
  RGBList.Free;
  timer.free;
  inherited;
end;

procedure TALCustomZoomImage.pChange(Sender: TObject);
begin
  EnablePopup(PasteBMP.Empty);
  Invalidate;
end;

procedure TALCustomZoomImage.EnablePopup(en: boolean);
begin
  if PopupMenu<>nil then PopupMenu.AutoPopup := en;
end;


procedure TALCustomZoomImage.CMMouseEnter(var msg: TMessage);
begin
    inherited;
    MouseInOut:=1;
    oldCursorCross:=CursorCross;
    oldMovePt := Point(-1,-1);
    invalidate;
    if Assigned(FMouseEnter) then FMouseEnter(Self);
end;

procedure TALCustomZoomImage.CMMouseLeave(var msg: TMessage);
begin
    inherited;
    MouseInOut:=-1;
    CursorCross:=oldCursorCross;
    oldCursorCross := False;
    invalidate;
    if Assigned(FMouseLeave) then FMouseLeave(Self);
end;

procedure TALCustomZoomImage.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1
end;

procedure TALCustomZoomImage.WMSize(var Msg: TWMSize);
begin
  invalidate;
end;

procedure TALCustomZoomImage.SetBackColor(const Value: TColor);
begin
  FBackColor := Value;
  invalidate;
end;

procedure TALCustomZoomImage.SetBackCross(const Value: boolean);
begin
  FBackCross := Value;
  invalidate;
end;

procedure TALCustomZoomImage.SetBulbRadius(const Value: integer);
begin
  FBulbRadius := Value;
  invalidate;
end;

procedure TALCustomZoomImage.SetCentered(const Value: boolean);
begin
  FCentered := Value;
  if Value then sCent := Point2d(Sizes.x/2,Sizes.y/2);
  Invalidate;
end;

procedure TALCustomZoomImage.SetCentralCross(const Value: boolean);
begin
  fCentralCross := Value;
  invalidate;
end;

procedure TALCustomZoomImage.SetCursorCross(const Value: boolean);
begin
  fCursorCross := Value;
end;

procedure TALCustomZoomImage.SetFileName(const Value: TFileName);
begin
  If FFileName <> Value then begin
     if LoadFromFile(Value) then
        FFileName := Value;
  end;
end;

procedure TALCustomZoomImage.SetOverMove(const Value: boolean);
begin
  FOverMove := Value;
  invalidate;
end;

procedure TALCustomZoomImage.SetPixelGrid(const Value: boolean);
begin
  FPixelGrid := Value;
  invalidate;
end;

procedure TALCustomZoomImage.SetRGBList(const Value: TRGBChanel);
begin
  FRGBList := Value;
  RestoreOriginal;
  ChangeRGBChanel(WorkBMP,FRGBList.FR,FRGBList.FG,FRGBList.FB);
  invalidate;
end;

procedure TALCustomZoomImage.SetZoom(const Value: extended);
begin
  if fZoom <> Value then begin
     // Limited zoom
     if Value>100 then fZoom:=100
     else
     if (Value*Sizes.x>8) and (Value*Sizes.y>8) then
         fZoom := Value;
     if Assigned(FChangeWindow) then
        FChangeWindow(Self,sCent.x,sCent.y,XToW(oldPos.x),YToW(oldPos.y),
                      Zoom,oldPos.x,oldPos.y);
     SelRectVisible := False;
     invalidate;
  end;
end;

procedure TALCustomZoomImage.Change(Sender: TObject);
begin
  IF Sender = RGBList then
     RGBList := RGBList;
  invalidate;
end;

procedure TALCustomZoomImage.OnTimer(Sender: TObject);
var step: integer;
begin
  if mouseLeft then begin
  step := 10;
  if Cursor=crNyilUp then ShiftWindow(0,-step);
  if Cursor=crNyilDown then ShiftWindow(0,step);
  if Cursor=crNyilLeft then ShiftWindow(-step,0);
  if Cursor=crNyilRight then ShiftWindow(step,0);
  if (Cursor > 18003) and (Cursor<18007) then
     InitSelWindow;
     Moving := True;
  end;
end;

procedure TALCustomZoomImage.CalculateRects;
var w,h : double;
begin
  Sizes := Point(OrigBMP.Width,OrigBMP.Height);

  // sCent need to be on the source bitmap
  w := width/(2*Zoom);
  h := height/(2*Zoom);

  if not OverMove then begin
     if sCent.x<0 then sCent.x:=0;
     if sCent.y<0 then sCent.y:=0;
     if sCent.x>Sizes.x then sCent.x:=Sizes.x;
     if sCent.y>Sizes.y then sCent.y:=Sizes.y;
  end;

  // Calculate the rect of the source window to view
  sRect := Rect2d(Round(sCent.x-w-1),Round(sCent.y-h-1),
                  Round(sCent.x+w+1),Round(sCent.y+h+1));
  dRect := Rect(XToS(sRect.x1),YToS(sRect.y1),
                XToS(sRect.x2),YToS(sRect.y2));
  BMPOffset := Point(dRect.left,dRect.top);
end;

procedure TALCustomZoomImage.Click;
begin
  if TabStop then SetFocus;
  inherited;
end;

procedure TALCustomZoomImage.DblClick;
begin
  if (not Loading) then begin
     MoveWindow(((Width/2)-oldPos.x)/Zoom,((Height/2)-oldPos.y)/Zoom);
     SelRectVisible:=False;
     pFazis := -1;
     inherited;
  end;
end;

function TALCustomZoomImage.DoMouseWheel(Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos);
  if WheelDelta<0 then Zoom:=0.9*Zoom
  else Zoom:=1.1*Zoom;
  if Assigned(FChangeWindow) then
     FChangeWindow(Self,sCent.x,sCent.y,XToW(MousePos.x),YToW(MousePos.y),Zoom,MousePos.x,MousePos.y);
  Result := True;
end;

function TALCustomZoomImage.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := True;
  inherited DoMouseWheelDown(Shift, MousePos);
end;

function TALCustomZoomImage.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelUp(Shift, MousePos);
end;

procedure TALCustomZoomImage.DrawMouseCross(o: TPoint; PenMode: TPenMode);
var DC:HDC;
    oldPen: TPen;
    R: integer;
begin
Try
    oldPen:=Canvas.Pen;
    Canvas.pen.Color := clBlue;
    Canvas.pen.Mode := PenMode;
    With Canvas do begin
      MoveTo(0,o.y); LineTo(Width,o.y);
      MoveTo(o.x,0); LineTo(o.x,Height);
      If BulbRadius<>0 then begin
         R := Round(BulbRadius*Zoom);
         Ellipse(o.x-R,o.y-R,o.x+R,o.y+R);
      end;
    end;
Finally
    Canvas.Pen:=oldPen;
end;
end;

procedure TALCustomZoomImage.InitSelWindow;
begin
  SelRectVisible := False;
  pFazis         := -1;
end;

procedure TALCustomZoomImage.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Shift=[] then
  Case Key of
  VK_RETURN   : FitToScreen;
  VK_ADD      : Zoom := 1.1*Zoom;
  VK_SUBTRACT : Zoom := 0.9*Zoom;
  189         : Zoom := 0.9*Zoom;
  end;
  if Shift=[ssCtrl] then
  Case Key of
  VK_LEFT     : ShiftWindow(-10,0);
  end;
  inherited;
end;

procedure TALCustomZoomImage.KeyPress(var Key: Char);
begin
  Case Key of
  ^X          : CutToClipboard;
  ^C          : COPYToClipboard;
  ^V          : PasteFromClipboard;
  end;
  inherited;
end;

function TALCustomZoomImage.LoadFromFile(FileName: TFileName): boolean;
var ext: string;
    jpgIMG: TJpegImage;
begin
Try
  Result := False;
  Loading := True;
  if FileExists(FileName) then
  Try
     ext := UpperCase(ExtractFileExt(FileName));
     If ext='.BMP' then OrigBMP.LoadFromFile(FileName);
     If ext='.JPG' then
     begin
        jpgIMG := TJpegImage.Create;
        jpgIMG.LoadFromFile(FileName);
        OrigBMP.Assign(jpgIMG);
     end;
  except
    if jpgIMG<>nil then jpgIMG.Free;
    exit;
  end;
finally
  WorkBMP.Assign(OrigBMP);
  if jpgIMG<>nil then jpgIMG.Free;
  // New image move to the centre of window and with original sizes
  Sizes := Point(OrigBMP.Width,OrigBMP.Height);
  if Fitting then FitToScreen;
  FFilename := FileName;
  Result := True;
  Loading := False;
  invalidate;
end;
end;

procedure TALCustomZoomImage.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var cx,cy,rx,ry: integer;
begin
  ActualPixel := Point(Trunc(XToW(x)),Trunc(YToW(y)));
  oldPos := Point(x,y);

  inherited;

  if ((not moving) or (not Loading)) then begin

  CASE Button of
  mbLeft:
  begin
  // Manipulating the Selected Area
  if FEnableSelect then
  if SelRectVisible and (pFazis = 2) and (Cursor <> crZoomIn) then begin
      SelRect := CorrectRect(Rect(Origin.x,Origin.y,x,y));
      cx := (SelRect.Right + SelRect.Left) div 2;
      cy := (SelRect.Bottom + SelRect.Top) div 2;
      rx := (SelRect.Right - SelRect.Left) div 2;
      ry := (SelRect.Bottom - SelRect.Top) div 2;
      pFazis  := 0;
      if (rx<0) and (ry<0) then begin
         pFazis  := 0;
         SelRectVisible := False;
      end else begin
         FixWinRect := SelRect;
         FixRect := Rect(Round(XToW(SelRect.Left)),Round(YToW(SelRect.Top)),
                         Round(XToW(SelRect.Right)),Round(YToW(SelRect.Bottom)));
      end;
  end else
  if SelRectVisible then begin
     if PtInRect(SelRect,Point(x,y)) then begin
        SelToScreen;
     end else begin
        InitSelWindow;
        invalidate;
     end;
  end else
  if Cursor=crDefault then begin
        SelRect := Rect(x,y,x,y);
        SelRectVisible := True;
        pFazis  := 1;
        invalidate;
  end;

  Origin := Point(x,y);
  MovePt := Point(x,y);
  oldMovePt := Point(x,y);

  // Cursors
  if x<20 then Cursor := crNyilLeft;
  if x>Width-20 then Cursor := crNyilRight;
  if y<20 then Cursor := crNyilUp;
  if y>Height-20 then Cursor := crNyilDown;
  if PtInRect(Rect(20,20,width-20,height-20),Point(x,y)) then Cursor := crDefault;

  if not PasteBMP.Empty then begin
     WorkBMP.Canvas.Draw(ActualPixel.x,ActualPixel.y,PasteBMP);
     PasteBMP.ReleaseHandle;
     SelRectVisible := False;
     invalidate;
  end;
  end;

  END; // Case

      mouseLeft := Button=mbLeft;
      Moving := False;
  end;
end;

procedure TALCustomZoomImage.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  MovePt := Point(x,y);
  ActualPixel := Point(Trunc(XToW(x)),Trunc(YToW(y)));

  if PasteBMP<>nil then begin
     invalidate;
  end;

  if (not moving) or (not Loading) then begin

  // Cursors
  if CursorCross then begin
       DrawMouseCross(oldMovePt,pmNotXor);
       DrawMouseCross(MovePt,pmNotXor);
  end;
  if x<10 then Cursor := crNyilLeft;
  if x>Width-10 then Cursor := crNyilRight;
  if y<10 then Cursor := crNyilUp;
  if y>Height-10 then Cursor := crNyilDown;
  if PtInRect(Rect(20,20,width-20,height-20),Point(x,y)) then Cursor := crDefault;
  if SelrectVisible and PtInRect(SelRect,MovePt) then
     Cursor := crZoomIn;

  if Shift = [ssLeft] then begin
     oldCursor := Cursor;
     Cursor := crKez2;
     MoveWindow((x-oldPos.x)/Zoom,(y-oldPos.y)/Zoom);
     oldPos := Point(x,y);
     Moving := True;
     SelRectVisible := False;
  end;
  if Shift = [] then begin
     if FEnableSelect and SelRectVisible and (pFazis > 0) then begin
        SelRect := CorrectRect(Rect(Origin.x,Origin.y,x,y));
//             DrawShape(Canvas,dtRectangle,Origin,oldMovePt,pmNotXor);
//             DrawShape(Canvas,dtRectangle,Origin,MovePt,pmNotXor);
        pFazis := 2;
        Repaint;
     end;
     if not PasteBMP.Empty then Repaint;
  end;
  MouseInOut:=0;
  end;
  
  if Assigned(FChangeWindow) then
     FChangeWindow(Self,sCent.x,sCent.y,XToW(x),YToW(y),Zoom,x,y);
  oldMovePt := Point(x,y);
  inherited;
end;

procedure TALCustomZoomImage.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ActualPixel := Point(Trunc(XToW(x)),Trunc(YToW(y)));
  if Button=mbRight then begin
     if PopupMenu=nil then DblClick;
     if not PasteBMP.Empty then begin
        PasteBMP.ReleaseHandle;
        EnablePopup(PasteBMP.Empty);
        invalidate;
     end;
     SelRectVisible:=False;
     pFazis := -1;
  end;
  inherited;
  Cursor := oldCursor;
  mouseLeft := False;
  MovePt := Point(x,y);
  oldMovePt := Point(x,y);
  Moving := False;
  inherited;
end;

procedure TALCustomZoomImage.New(nWidth, nHeight: integer; nColor: TColor);
begin
  OrigBMP.Width := nWidth;
  OrigBMP.Height := nHeight;
  Cls(OrigBMP.Canvas,nColor);
  WorkBMP.Assign(OrigBMP);
  if Fitting then FitToScreen
  else
  invalidate;
end;

procedure TALCustomZoomImage.Paint;
var tps: tagPAINTSTRUCT;
    R  : TRect;
begin
Try
  IF (not WorkBMP.Empty) and (not Loading) then begin
     beginpaint(Canvas.Handle,tps );

     InitBackImage;
     CalculateRects;

     if Assigned(FBeforePaint) then
        FBeforePaint(Self,sCent.x,sCent.y,dRect);

     SetStretchBltMode(BackBMP.Canvas.Handle, STRETCH_DELETESCANS);
     StretchBlt(BackBMP.Canvas.Handle,BMPOffset.x,BMPOffset.y,
             dRect.Right-dRect.Left,dRect.Bottom-dRect.Top,
             WorkBMP.Canvas.Handle,
             Round(sRect.x1),Round(sRect.y1),
             Round(sRect.x2-sRect.x1),Round(sRect.y2-sRect.y1),
             SRCCOPY);

     endpaint(Canvas.Handle,tps);
  end else begin
     InitBackImage;
  end;
Finally
     if PixelGrid then DrawPixelGrid;
     if Grid.Visible then DrawGrid;
     if CentralCross then DrawCentralCross(BackBMP.Canvas,cPen);
     if SelrectVisible then begin
        BackBMP.Canvas.Brush.Style := bsClear;
        BackBMP.Canvas.Pen.Color   := clBlack;
        BackBMP.Canvas.Pen.Style   := psSolid;
        DrawShape(BackBMP.Canvas,dtRectangle,Point(SelRect.Left,SelRect.Top),
                       Point(SelRect.Right,SelRect.Bottom),pmNotXor);
     end;
     if not PasteBMP.Empty then begin
        R := PasteBMP.Canvas.ClipRect;
        R := Rect(0,0,Trunc(Zoom*PasteBMP.Width),Trunc(Zoom*PasteBMP.Height));
        OffsetRect(R,MovePt.x,MovePt.y);
        BackBMP.Canvas.StretchDraw(R,TGraphic(PasteBMP));
     end;

     BitBlt(Canvas.Handle,0,0,Width,Height,
             BackBMP.Canvas.Handle,0,0,SRCCOPY);

     If oldCursorCross then DrawMouseCross(oldMovePt,pmNotXor);

     if Assigned(FAfterPaint) then
        FAfterPaint(Self,sCent.x,sCent.y,dRect);
end;
end;

function TALCustomZoomImage.SaveToFile(FileName: TFileName): boolean;
var ext: string;
    jpgIMG: TJpegImage;
begin
Try
  Result := False;
  Loading := True;
  Try
     ext := UpperCase(ExtractFileExt(FileName));
     If ext='.BMP' then WorkBMP.SaveToFile(FileName);
     If ext='.JPG' then
     begin
        jpgIMG := TJpegImage.Create;
        jpgIMG.Assign(WorkBMP);
        jpgIMG.SaveToFile(FileName);
     end;
  except
    if jpgIMG<>nil then jpgIMG.Free;
    exit;
  end;
finally
  OrigBMP.Assign(WorkBMP);
  if jpgIMG<>nil then jpgIMG.Free;
  Result := True;
  Loading := False;
  invalidate;
end;
end;

procedure TALCustomZoomImage.SelToScreen;
var dxy,sxy: double;
    cx,cy,rx,ry: integer;
begin
  if SelRectVisible then begin
      SelRect := CorrectRect(SelRect);
      cx := (SelRect.Right + SelRect.Left) div 2;
      cy := (SelRect.Bottom + SelRect.Top) div 2;
      rx := (SelRect.Right - SelRect.Left) div 2;
      ry := (SelRect.Bottom - SelRect.Top) div 2;
      sCent := Point2d(XToW(cx),YToW(cy));
      dxy := Width/height;
      sxy := rx/ry;
      if dxy<sxy then
         Zoom := zoom*width/(2*rx)
      else
         Zoom := zoom*Height/(2*ry);
      InitSelWindow;
      invalidate;
  end;
end;

procedure TALCustomZoomImage.CopyToClipboard;
var BMP: TBitmap;
    R  : TRect;
begin
Try
  BMP := TBitmap.Create;
  Case FClipBoardAction of
  cbaTotal    : BMP.Assign(WorkBMP);
  cbaScreen   : BMP.Assign(BackBMP);
  cbaSelected : begin
                  SelRectVisible := False;
                  R := Rect(Round(XToW(SelRect.Left+1)),Round(YToW(SelRect.Top+1)),
                                  Round(XToW(SelRect.Right-1)),Round(YToW(SelRect.Bottom-1)));
                  BMP.Width := R.Right - R.Left;
                  BMP.Height:= R.Bottom - R.Top;
                  BMP.canvas.CopyRect(Rect(0,0,BMP.Width,BMP.Height),WorkBMP.Canvas,R);
                end;
  cbaSreenSelected :
                begin
                  SelRectVisible := False;
                  R := Rect(SelRect.Left+1,SelRect.Top+1,
                                  SelRect.Right-1,SelRect.Bottom-1);
                  BMP.Width := R.Right - R.Left;
                  BMP.Height:= R.Bottom - R.Top;
                  BMP.canvas.CopyRect(Rect(0,0,BMP.Width,BMP.Height),Canvas,R);
                end;
  cbaFixArea   :
                begin
                  BMP.Width := FixRect.Right - FixRect.Left;
                  BMP.Height:= FixRect.Bottom - FixRect.Top;
                  BMP.canvas.CopyRect(Rect(0,0,BMP.Width,BMP.Height),WorkBMP.Canvas,FixRect);
                end;
  cbaFixWindow :
                begin
                  BMP.Width := FixWinRect.Right - FixWinRect.Left;
                  BMP.Height:= FixWinRect.Bottom - FixWinRect.Top;
                  BMP.canvas.CopyRect(Rect(0,0,BMP.Width,BMP.Height),Canvas,FixWinRect);
                end;
  end;
Finally
  Clipboard.Assign(BMP);
  BMP.Free;
  invalidate;
end;
end;

procedure TALCustomZoomImage.CutToClipboard;
begin
  CopyToClipboard;
  if ClipboardAction = cbaSelected then
     FillRect(SelRect,clBlack);
end;

procedure TALCustomZoomImage.DrawGrid;
var
    kp,kp0: TPoint2d;
    vp,vp0: TPoint2d;
    tav,kpy,mar,marx,mary: extended;
    i: integer;
    GridWidth : double;     // Distance between lines
    R : TRect;
begin
If Grid.Visible then begin
  GridWidth := Grid.GridDistance;
  With BackBmp.Canvas do

  if Grid.OnlyOnPaper then begin
      if (Zoom*GridWidth)>6 then begin

      Pen.Assign(Grid.GridPen);
      if PixelGrid and (Zoom>6) then Pen.Width := 2* Grid.GridPen.width
      else Pen.Width := Grid.GridPen.width;

      kp.x := 0;
      kp.y := 0;
      vp.x := Sizes.x;
      vp.y := Sizes.y;

      While kp.x<=vp.x do begin
            MoveTo(XToS(kp.x),YToS(kp.y));
            LineTo(XToS(kp.x),YToS(vp.y));
            kp.x:=kp.x+GridWidth;
      end;
      kp.x := Sizes.x;
      While kp.y<=vp.y do begin
            MoveTo(XToS(0),YToS(kp.y));
            LineTo(XToS(vp.x),YToS(kp.y));
            kp.y:=kp.y+GridWidth;
      end;

      end;

  end;
end;
end;

procedure TALCustomZoomImage.DrawPixelGrid;
var
    kp,kp0: TPoint2d;
    vp,vp0: TPoint2d;
    GridWidth : integer;     // Distance between lines
begin
If PixelGrid then begin
  GridWidth := 1;
  With BackBmp.Canvas do

  if Grid.OnlyOnPaper then begin
      if (Zoom*GridWidth)>4 then begin

      Pen.Assign(Grid.SubgridPen);
      Pen.Width := 1;

      kp.x := Srect.x1;
      kp.y := Srect.y1;
      vp.x := Srect.x2;
      vp.y := Srect.y2;

      While kp.x<=vp.x do begin
            MoveTo(XToS(kp.x),YToS(kp.y));
            LineTo(XToS(kp.x),YToS(vp.y));
            kp.x:=kp.x+GridWidth;
      end;
      kp.x := Trunc(Srect.x1);
      While kp.y<=vp.y do begin
            MoveTo(XToS(kp.x),YToS(kp.y));
            LineTo(XToS(vp.x),YToS(kp.y));
            kp.y:=kp.y+GridWidth;
      end;

      end;

  end;
end;
end;

procedure TALCustomZoomImage.FadeOut(Pause: Integer);
begin

end;

procedure TALCustomZoomImage.FillRect(R: TRect; co: TColor);
begin
  With WorkBMP.Canvas do begin
       Pen.Color := co;
       Brush.Color := co;
       Brush.Style := bsSolid;
       Rectangle(R);
  end;
  invalidate;
end;

procedure TALCustomZoomImage.FitToScreen;
var dxy,sxy: double;
begin
if not OrigBMP.Empty then
Try
  Sizes := Point(OrigBMP.Width,OrigBMP.Height);
  dxy := Width/height;
  sxy := Sizes.x/Sizes.y;
  sCent := Point2d(Sizes.x/2,Sizes.y/2);
  if dxy<sxy then
     Zoom := width/Sizes.x
  else
     Zoom := Height/Sizes.y;
  invalidate;
except
end;
end;

function TALCustomZoomImage.GetPixelColor(p: TPoint): TColor;
begin
  Result := WorkBMp.Canvas.Pixels[p.x,p.y];
end;

// Get RGB values from screen pixel
function TALCustomZoomImage.GetRGB(x, y: integer): TRGBRec;
var co: TColor;
begin
  co := WorkBMP.Canvas.Pixels[x,y];
  With Result do begin
       Red := GetRValue(co);
       Blue := GetBValue(co);
       Green := GetGValue(co);
  end;
end;

procedure TALCustomZoomImage.MoveToCentrum(x, y: double);
begin
  sCent     := Point2d(x,y);
  invalidate;
end;

procedure TALCustomZoomImage.MoveWindow(x, y: double);
begin
  sCent     := Point2d(sCent.x-x,sCent.y-y);
  invalidate;
end;

procedure TALCustomZoomImage.PasteFromClipboard;
begin
  if Clipboard.HasFormat(CF_PICTURE) then begin
    OrigBMP.Assign(Clipboard);
    WorkBMP.Assign(Clipboard);
    FitToScreen;
  end;
end;

// Pate the clipboard image to the world coordinate on the workBMP
procedure TALCustomZoomImage.PasteSpecial;
begin
  if Clipboard.HasFormat(CF_PICTURE) then begin
      PasteBMP.Assign(Clipboard);
      EnablePopup(False);
  end else begin
      PasteBMP.ReleaseHandle;
      EnablePopup(True);
  end;
end;

procedure TALCustomZoomImage.PixelToCentrum(x, y: integer);
begin
  sCent := Point2d(x + 0.5,y + 0.5);
  Invalidate;
end;

procedure TALCustomZoomImage.RestoreOriginal;
begin
  WorkBMP.Assign(OrigBMP);
  if fitting then FittoScreen;
  Invalidate;
end;

procedure TALCustomZoomImage.SaveAsOriginal;
begin
  OrigBMP.Assign(WorkBMP);
  Invalidate;
end;

function TALCustomZoomImage.ScreenRectToWorld(R: TRect): TRect;
begin
  Result := Rect(Round(XToW(R.Left)),Round(YToW(R.Top)),
                 Round(XToW(R.Right)),Round(YToW(R.Bottom)))
end;

procedure TALCustomZoomImage.SetPixelColor(p: TPoint; Co: TColor);
begin
  WorkBMp.Canvas.Pixels[p.x,p.y]:=co;
  invalidate;
end;

procedure TALCustomZoomImage.ShiftWindow(x, y: double);
begin
  sCent     := Point2d(sCent.x+(x/Zoom),sCent.y+(y/Zoom));
  invalidate;
end;

// Transform the Screen Coordinates to World Coordinates
function TALCustomZoomImage.SToW(p: TPoint): TPoint2d;
begin
  Result := Point2d(XToW(p.x),YToW(p.y));
end;

function TALCustomZoomImage.WorldRectToScreen(R: TRect): TRect;
begin
  Result := Rect(XToS(R.Left),YToS(R.Top),
                 XToS(R.Right),YToS(R.Bottom))
end;

// Transform the World Coordinates to Screen Coordinates
function TALCustomZoomImage.WToS(p: TPoint2d): TPoint;
begin
  Result := Point(XToS(p.x),YToS(p.y));
end;

// world x to Screen x
function TALCustomZoomImage.XToS(x: double): integer;
begin
  Result := Round((Width/2) + Zoom*(x-sCent.x));
end;

function TALCustomZoomImage.XToW(x: integer): double;
begin
  Result := sCent.x + (x-(Width/2))/Zoom;
end;

// world y to Screen y
function TALCustomZoomImage.YToS(y: double): integer;
begin
  Result := Round((Height/2) + Zoom*(y-sCent.y));
end;

function TALCustomZoomImage.YToW(y: integer): double;
begin
  Result := sCent.y + (y-(Height/2))/Zoom;
end;

procedure TALCustomZoomImage.SetSelRectVisible(const Value: boolean);
begin
  FSelRectVisible := Value;
  EnablePopup(Value);
end;

// Clears the BackBMP with BackColor brush
procedure TALCustomZoomImage.InitBackImage;
begin
  BackBMP.Width := Width;
  BackBMP.Height:= Height;
  Cls(BackBMP.Canvas,FBackColor);
  if BackCross then
  with BackBMP.Canvas do begin
       Pen.Assign(cPen);
       MoveTo(0,0);LineTo(Width,Height);
       MoveTo(0,Height);LineTo(Width,0);
  end;
end;

procedure TALCustomZoomImage.SetPrintView(const Value: boolean);
var Xmm,Ymm: integer;   // Printer page sizes
begin
  FPrintView := Value;
  if Value then begin
     Xmm := GetDeviceCaps(Printer.Handle,HORZSIZE);
     Ymm := GetDeviceCaps(Printer.Handle,VERTSIZE);
     BMPResize(OrigBMP,10*Xmm,10*Ymm);
  end else begin
  end;
  RestoreOriginal;
  invalidate;
end;

procedure TALCustomZoomImage.Print;
begin
  // Printing the image
end;

end.
