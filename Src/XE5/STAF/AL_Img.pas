// ===========================================================================
// TALImage is a flicker-free visual reprezentation of memory bitmap
//          By Agócs Lászlo StellaSOFT, Hungary 2009
//          Test in Delphi 5
// You can dragging the image by pressed left mouse button, and zooming width
//     mouse wheel button

// Any point move to the centre by double click or right click
// Optimized speed for drawing.
// If you click on the the component it will be focused if Tabstop property= True;
// Licens: Absolutely Free!!!!
// ===========================================================================

unit AL_Img;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, JPeg, NewGeom, STAF_Imp, JanFX, ClipBrd, AlType;

Type
  { Clipboard copy/paste: }
  TClipBoardAction = (cbaTotal,        // Total Image
                      cbaScreen,       // Only the screen image
                      cbaSelected,     // Only the selected area
                      cbaSreenSelected,// Only the selected area from screen
                      cbaFixArea,      // Fix rect from image
                      cbaFixWindow);   // Fix rect from screen

  TGridType = (gtNone, gtGrid, gtCent, gtCentGrid, gtBulb, gtEqu, gtBulbEq);

  // Indicates which chanel is active in image
  TRGBList = (rgbRGB,rgbR,rgbG,rgbB);
  TRGBSet = set of TRGBList;

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
    FGridType: TGridType;
    procedure SetGridType(const Value: TGridType);
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
    property GridType : TGridType read FGridType write SetGridType;
    property OnlyOnPaper: boolean read fOnlyOnPaper write SetOnlyOnPaper default True;
    property Visible: boolean read fVisible write SetVisible default True;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  // Recor for signifícant of R,G,B chanel visibility:
  // Original composite picture then R=True; G=True and B=True;
  TRGBChanel = class(TPersistent)
  private
    FG: boolean;
    FR: boolean;
    FB: boolean;
    FOnChange: TNotifyEvent;
    procedure SetB(const Value: boolean);
    procedure SetG(const Value: boolean);
    procedure SetR(const Value: boolean);
  protected
    procedure Changed;
  public
    RGBBMP : TBitmap;
    constructor Create;
    destructor Destroy; override;
    property R : boolean read FR write SetR default True;
    property G : boolean read FG write SetG default True;
    property B : boolean read FB write SetB default True;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TALCustomImage = class(TCustomControl)
  private
    FBackColor: TColor;
    FFileName: TFileName;
    FBMPOffset: TPoint;
    fZoom: extended;
    FOverMove: boolean;
    fCentralCross: boolean;
    FCentered: boolean;
    FChangeWindow: TChangeWindow;
    FBackCross: boolean;
    FBeforePaint: TBeforePaint;
    FAfterPaint: TBeforePaint;
    FGrid: TImageGrid;
    FPixelGrid: boolean;
    fCursorCross: boolean;
    FMouseLeave: TNotifyEvent;
    FMouseEnter: TNotifyEvent;
    FMonoRGB: boolean;
    FRGBList: TRGBList;
    FClipBoardAction: TClipBoardAction;
    FsCent: TPoint2d;
    FCircleWindow: boolean;
    FBulbRadius: integer;
    FEnableSelect: boolean;
    FEnableActions: boolean;
    FActualPixel: TPoint;
    FSelRectVisible: boolean;
    FFitting: boolean;
    FTitle: string;
    FOffset: TPoint2d;
    procedure WMEraseBkGnd(var Message:TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure CMMouseEnter(var msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var msg: TMessage); message CM_MOUSELEAVE;
    procedure SetBackColor(const Value: TColor);
    procedure SetFileName(const Value: TFileName);
    procedure SetZoom(const Value: extended);
    procedure SetOverMove(const Value: boolean);
    procedure InitBackImage;
    procedure SetCentralCross(const Value: boolean);
    procedure SetCentered(const Value: boolean);
    procedure SetBackCross(const Value: boolean);
    procedure SetPixelGrid(const Value: boolean);
    procedure SetCursorCross(const Value: boolean);
    procedure SetMonoRGB(const Value: boolean);
    procedure SetRGBList(const Value: TRGBList);
    procedure SetBulbRadius(const Value: integer);
    procedure SetSelRectVisible(const Value: boolean);
    procedure SetTitle(const Value: string);
    procedure SetFitting(const Value: boolean);
    procedure SetOffset(const Value: TPoint2d);
  protected
    First     : boolean;              // First creation
    oldRGBSet : TRGBSet;
    timer     : TTimer;               // Timer for any doing;
    pFazis    : integer;              // Fazis for any action
    Origin,MovePt       : TPoint;
    oldOrigin,oldMovePt : TPoint;
    mouseLeft : boolean;
    oldCursor : TCursor;
    oldCursorCross : boolean;
    MouseInOut: integer;              // Mouse in:1, Mouse:0, Mouse out:-1
    WinRgn    : HRgn;                 // Window region;
    AutoPopup : boolean;              // PopupMenu enable
    MousePos  : TPoint;
    procedure OnTimer(Sender: TObject);
    procedure CalculateRects;
    procedure InitSelWindow;
    procedure SelToScreen;
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
    procedure Change(Sender: TObject);
    procedure pChange(Sender: TObject);
  public
    OrigBMP        : TBitmap;      // Original bmp in memory
    WorkBMP        : TBitmap;      // bmp copy for working in memory
    BackBMP        : TBitmap;      // Redy bmp for copy to screen
    CopyBMP        : TBitmap;      // Temporary bmp for internal use
    PasteBMP       : TBitmap;      // Temporary bmp for Paste special
    Sizes          : TPoint;       // OriginalBmp sizes (width, height)
    sCent          : TPoint2d;     // Centrum of the source rectangle on WorkBMP
    sRect          : TRect2d;      // Rectangle for part of source bitmap
    dRect          : TRect;        // Rectangle for stretching to the screen
    SelRect        : TRect;        // Selected area on the screen;
    FixRect        : TPoint;        // Fix rectangle on image (x=width, y=Height)
    FixWinRect     : TPoint;        // Fix rectangle on screen
    oldPos         : TPoint;       // Store the old mouse position in window
    cPen           : TPen;         // Pen for central cross;
    Loading        : boolean;      // Something in progress
    Moving         : boolean;      // Indicates the image dragging by mouse
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure New(nWidth, nHeight: integer; nColor: TColor);
    procedure Clear;
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
    procedure TurnLeft;
    procedure TurnRight;
    procedure MirrorHorizontal;
    procedure MirrorVertical;
    procedure Rotate(Angle: double);
    procedure ShiftSubPixel(dx, dy: double);
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
    property Canvas;
    property BMPOffset   : TPoint read FBMPOffset write FBMPOffset;
      // Actual pixel coordinates for operation
    property ActualPixel : TPoint read FActualPixel write FActualPixel;
      // Valid selected area is visible
    property SelRectVisible : boolean read FSelRectVisible write SetSelRectVisible;
  published
    property ClipBoardAction: TClipBoardAction read FClipBoardAction write FClipBoardAction;
    property BackColor   : TColor read FBackColor write SetBackColor;
    property BackCross   : boolean read FBackCross write SetBackCross;
    property BulbRadius  : integer read FBulbRadius write SetBulbRadius default 0;
    property Centered    : boolean read FCentered write SetCentered;
//    property CircleWindow: boolean read FCircleWindow write SetCircleWindow;
    property CentralCross: boolean read fCentralCross write SetCentralCross;
    property CursorCross: boolean read fCursorCross write SetCursorCross;
    property EnableSelect: boolean read FEnableSelect write FEnableSelect;
    property EnableActions: boolean read FEnableActions write FEnableActions;
    property FileName    : TFileName read FFileName write SetFileName;
    property Fitting     : boolean read FFitting write SetFitting;
    property Grid        : TImageGrid read FGrid write FGrid;
    property Offset      : TPoint2d read FOffset write SetOffset;
    property OverMove    : boolean read FOverMove write SetOverMove;
    property PixelGrid   : boolean read FPixelGrid write SetPixelGrid;
    property RGBList     : TRGBList read FRGBList write SetRGBList;
    property Title       : string read FTitle write SetTitle;
    property MonoRGB     : boolean read FMonoRGB write SetMonoRGB;
    property Zoom        : extended read fZoom write SetZoom;
    property OnChangeWindow: TChangeWindow read FChangeWindow write FChangeWindow;
    property OnBeforePaint: TBeforePaint read FBeforePaint write FBeforePaint;
    property OnAfterPaint: TBeforePaint read FAfterPaint write FAfterPaint;
    property OnMouseEnter: TNotifyEvent read FMouseEnter write FMouseEnter;
    property OnMouseLeave: TNotifyEvent read FMouseLeave write FMouseLeave;
  end;

  TALImage = class(TALCustomImage)
  private
    FStarCount: integer;
    FStarVisible: boolean;
    FSelectedStarColor: TColor;
    FStarColor: TColor;
    procedure SetSelectedStarColor(const Value: TColor);
    procedure SetStarColor(const Value: TColor);
    function GetStarCount: integer;
    procedure SetStarVisible(const Value: boolean);
    procedure SetStarCount(const Value: integer);
  protected
  public
    StarList  : TStarList;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CropSelected;
    // Effects on work Bitmap and view in window
    procedure FlipHorizontal;
    procedure FlipVertical;
    Procedure Rotate(Angle : Double) ;
    procedure Negative;
    procedure BlackAndWhite;
    procedure Saturation(Amount: Integer);
    procedure Lightness(Amount: Integer);
    procedure Darkness(Amount: integer);
    procedure Contrast(Amount: Integer);
    procedure Sepia(depth:byte);
    Procedure Blur;
    procedure Posterize(amount: integer);
    procedure Paint; override;
    // Astronomy
    function AutomaticStarDetection(Threshold: integer): integer;
    procedure StarDraw;
  published
    property StarCount : integer read GetStarCount write SetStarCount;
    property StarVisible: boolean read FStarVisible write SetStarVisible;
    property StarColor: TColor read FStarColor write SetStarColor;
    property SelectedStarColor: TColor read FSelectedStarColor write SetSelectedStarColor;
    property Align;
    property BackColor;
    property FileName;
    property BMPOffset;
    property OverMove;
    property Centered;
    property Zoom;
    property Enabled;
    property PopupMenu;
    property TabStop;
    property Visible;
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

implementation


procedure Register;
begin
  RegisterComponents('AL',[TALCustomImage,TALImage]);
end;

{ TALImage }

constructor TALCustomImage.Create(AOwner: TComponent);
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
  Grid           := TImageGrid.Create;
  fGrid.GridDistance := 100;
  fGrid.OnChange := Change;
  fGrid.fVisible := True;
  fGrid.FOnlyOnPaper := True;
  fGrid.FGridType    := gtCent;
  FRGBList       := rgbRGB;
  FPixelGrid     := False;
  cPen           := TPen.Create;
  with cPen do begin
       Color := clRed;
       Style := psSolid;
       Mode  := pmCopy;
  end;
  CentralCross   := True;
  BackColor      := clGray;
  BMPOffset      := Point(0,0);
  fZoom          := 1.0;
  fOverMove      := False;
  fCursorCross   := False;
  oldCursorCross := False;
  MouseInOut     := 1;
  oldMovePt      := Point(-1,-1);
  Sizes          := Point(0,0);
  sRect          := Rect2d(0,0,0,0);
  ControlStyle   := ControlStyle+[csFramed,csReflector,csCaptureMouse];
//  TabStop        := True;
  DoubleBuffered := False;
  timer          := TTimer.Create(Self);
  timer.Interval := 10;
  timer.Ontimer  := OnTimer;
  FClipBoardAction := cbaTotal;
  FixRect        := Point(100,100);
  FixWinRect     := Point(100,100);
  Width          := 100;
  Height         := 100;
  InitSelWindow;
  FEnableSelect  := True;
  AutoPopup      := True;
  Offset         := Point2d(0,0);
  First          := True;
end;

destructor TALCustomImage.Destroy;
begin
  OrigBMP.Free;
  WorkBMP.Free;
  BackBMP.Free;
  CopyBMP.Free;
  PasteBMP.Free;
  cPen.Free;
  Grid.Free;
  timer.free;
  inherited;
end;

// Create a new empty image with sizes and color
procedure TALCustomImage.New(nWidth, nHeight: integer; nColor: TColor);
begin
  OrigBMP.Width := nWidth;
  OrigBMP.Height := nHeight;
  Cls(OrigBMP.Canvas,nColor);
  WorkBMP.Assign(OrigBMP);
  invalidate;
end;

procedure TALCustomImage.Clear;
begin
  OrigBMP.Dormant;
  OrigBMP.FreeImage;
  OrigBMP.Width := 0;
  OrigBMP.Height := 0;
  RestoreOriginal;
end;

// Screen x to world x on the memory bitmap
function TALCustomImage.XToW(x: integer):double;
begin
  Result := sCent.x + (x-(Width/2))/Zoom;
end;

// Screen y to world y on the memory bitmap
function TALCustomImage.YToW(y: integer):double;
begin
  Result := sCent.y + (y-(Height/2))/Zoom;
end;

// world x to Screen x
function TALCustomImage.XToS(x: double):integer;
begin
  Result := Round((Width/2) + Zoom*(x-sCent.x));
end;

// world y to Screen y
function TALCustomImage.YToS(y: double):integer;
begin
  Result := Round((Height/2) + Zoom*(y-sCent.y));
end;

// Transform the World Coordinates to Screen Coordinates
function TALCustomImage.WToS(p: TPoint2d): TPoint;
begin
  Result := Point(XToS(p.x),YToS(p.y));
end;

// Transform the Screen Coordinates to World Coordinates
function TALCustomImage.SToW(p: TPoint): TPoint2d;
begin
  Result := Point2d(XToW(p.x),YToW(p.y));
end;

function TALCustomImage.ScreenRectToWorld(R: TRect): TRect;
begin
  Result := Rect(Round(XToW(R.Left)),Round(YToW(R.Top)),
                 Round(XToW(R.Right)),Round(YToW(R.Bottom)))
end;

function TALCustomImage.WorldRectToScreen(R: TRect): TRect;
begin
  Result := Rect(XToS(R.Left),YToS(R.Top),
                 XToS(R.Right),YToS(R.Bottom))
end;

procedure TALCustomImage.FillRect(R: TRect; co: TColor);
begin
  With WorkBMP.Canvas do begin
       Pen.Color := co;
       Brush.Color := co;
       Brush.Style := bsSolid;
       Rectangle(R);
  end;
  invalidate;
end;

// Calculates the source and target rect for streching on the screen
procedure TALCustomImage.CalculateRects;
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

procedure TALCustomImage.Paint;
var tps: tagPAINTSTRUCT;
    R  : TRect;
begin
Try
  IF (not WorkBMP.Empty) and (not Loading) then begin
     if First then begin
        FitToScreen;
        First := False;
     end;
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
        BackBMP.Canvas.DrawFOCUSrect(SelRect);
     end;
     if not PasteBMP.Empty then begin
        R := PasteBMP.Canvas.ClipRect;
        R := Rect(0,0,Trunc(Zoom*PasteBMP.Width),Trunc(Zoom*PasteBMP.Height));
        OffsetRect(R,MovePt.x,MovePt.y);
        BackBMP.Canvas.StretchDraw(R,TGraphic(PasteBMP));
     end;
     if Focused then begin
        BackBMP.Canvas.Brush.Color := clBlack;
        BackBMP.Canvas.FrameRect(BackBMP.Canvas.ClipRect);
     end;

     if Title<>'' then BackBMP.Canvas.TextOut(10,10,Title);

     if Assigned(FAfterPaint) then
        FAfterPaint(Self,sCent.x,sCent.y,dRect);

     BitBlt(Canvas.Handle,0,0,Width,Height,
             BackBMP.Canvas.Handle,0,0,SRCCOPY);

     If oldCursorCross then DrawMouseCross(oldMovePt,pmNotXor);

end;
end;

// Clears the BackBMP with BackColor brush
procedure TALCustomImage.InitBackImage;
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

// Delete the changes and restore the original image
procedure TALCustomImage.RestoreOriginal;
begin
  WorkBMP.Assign(OrigBMP);
  if Fitting then FitToScreen;
  Invalidate;
end;

// Save changes into the original image
procedure TALCustomImage.SaveAsOriginal;
begin
  OrigBMP.Assign(WorkBMP);
  Invalidate;
end;

// Fit image to screen
procedure TALCustomImage.FitToScreen;
var dxy,sxy: double;
begin
if not OrigBMP.Empty then
Try
  dxy := Width/height;
  Sizes := Point(WorkBMP.Width,WorkBMP.Height);
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

// Zooming the selected area
procedure TALCustomImage.SelToScreen;
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

// Loading BMP,JPG graphic files
function TALCustomImage.LoadFromFile(FileName: TFileName): boolean;
begin
Try
  Result := False;
  Loading := True;
  Load_Bitmap(FileName,OrigBMP);
  Result := True;
Finally
  Sizes := Point(OrigBMP.Width,OrigBMP.Height);
  RestoreOriginal;
  FFilename := FileName;
  Result := True;
  Loading := False;
  invalidate;
End;
end;

function TALCustomImage.SaveToFile(FileName: TFileName): boolean;
begin
Try
  Result := False;
  Loading := True;
  Save_Bitmap(FileName,WorkBMP);
  Result := True;
finally
  OrigBMP.Assign(WorkBMP);
  Result := True;
  Loading := False;
  invalidate;
end;
end;

procedure TALCustomImage.MoveWindow(x, y: double);
begin
  sCent     := Point2d(sCent.x-x,sCent.y-y);
  invalidate;
end;

procedure TALCustomImage.ShiftWindow(x, y: double);
begin
  sCent     := Point2d(sCent.x+(x/Zoom),sCent.y+(y/Zoom));
  invalidate;
end;

procedure TALCustomImage.SetBackColor(const Value: TColor);
begin
  FBackColor := Value;
  invalidate;
end;

procedure TALCustomImage.SetBackCross(const Value: boolean);
begin
  FBackCross := Value;
  invalidate;
end;

procedure TALCustomImage.SetFileName(const Value: TFileName);
begin
  if (csLoading in ComponentState) then Exit;
  If FFileName <> Value then begin
     if FileExists(Value) then
     if LoadFromFile(Value) then
        FFileName := Value;
  end;
end;

procedure TALCustomImage.SetZoom(const Value: extended);
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

procedure TALCustomImage.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1
end;

procedure TALCustomImage.WMSize(var Msg: TWMSize);
begin
  if Fitting then FitToScreen else invalidate;
end;

procedure TALCustomImage.SetOverMove(const Value: boolean);
begin
  FOverMove := Value;
  invalidate;
end;

procedure TALCustomImage.SetPixelGrid(const Value: boolean);
begin
  FPixelGrid := Value;
  invalidate;
end;

procedure TALCustomImage.SetCentralCross(const Value: boolean);
begin
  fCentralCross := Value;
  invalidate;
end;

procedure TALCustomImage.SetCentered(const Value: boolean);
begin
  FCentered := Value;
  if Value then sCent := Point2d(Sizes.x/2,Sizes.y/2);
  Invalidate;
end;

procedure TALCustomImage.FadeOut(Pause: Integer);
begin
  Invalidate;
end;

procedure TALCustomImage.CopyToClipboard;
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
  cbaSreenSelected, cbaFixWindow :
                begin
                  SelRectVisible := False;
                  R := Rect(SelRect.Left+1,SelRect.Top+1,
                                  SelRect.Right-1,SelRect.Bottom-1);
                  BMP.Width := R.Right - R.Left;
                  BMP.Height:= R.Bottom - R.Top;
                  BMP.canvas.CopyRect(Rect(0,0,BMP.Width,BMP.Height),Canvas,R);
                end;
(*  cbaFixArea   :
                begin
                  BMP.Width := R.Right - R.Left;
                  BMP.Height:= R.Bottom - R.Top;
                  BMP.canvas.CopyRect(Rect(0,0,BMP.Width,BMP.Height),WorkBMP.Canvas,SelRect);
                end;
  cbaFixWindow :
                begin
                  BMP.Width := FixWinRect.Right - FixWinRect.Left;
                  BMP.Height:= FixWinRect.Bottom - FixWinRect.Top;
                  BMP.canvas.CopyRect(Rect(0,0,BMP.Width,BMP.Height),Canvas,FixWinRect);
                end; *)
  end;
Finally
  Clipboard.Assign(BMP);
  BMP.Free;
  invalidate;
end;
end;

procedure TALCustomImage.CutToClipboard;
begin
  CopyToClipboard;
  OrigBMP.Empty;
end;

procedure TALCustomImage.PasteFromClipboard;
begin
  if Clipboard.HasFormat(CF_PICTURE) then begin
    OrigBMP.Assign(Clipboard);
    WorkBMP.Assign(Clipboard);
    FitToScreen;
  end;
end;

// Pate the clipboard image to the world coordinate on the workBMP
procedure  TALCustomImage.PasteSpecial;
begin
  if Clipboard.HasFormat(CF_PICTURE) then begin
      PasteBMP.Assign(Clipboard);
      EnablePopup(False);
  end else begin
      PasteBMP.ReleaseHandle;
      EnablePopup(True);
  end;
end;

procedure TALCustomImage.MoveToCentrum(x, y: double);
begin
  sCent     := Point2d(x,y);
  invalidate;
end;

procedure TALCustomImage.PixelToCentrum(x, y: integer);
begin
  sCent := Point2d(x + 0.5,y + 0.5);
  Invalidate;
end;

procedure TALCustomImage.TurnLeft;
begin
    CopyBMP.Assign(WorkBMP);
    sCent := Point2d(sCent.y,WorkBMP.width-sCent.x);
    STAF_Imp.TurnLeft(CopyBMP,WorkBMP);
    invalidate;
end;

procedure TALCustomImage.TurnRight;
begin
    CopyBMP.Assign(WorkBMP);
    sCent := Point2d(WorkBMP.Height-sCent.y,sCent.x);
    STAF_Imp.TurnRight(CopyBMP,WorkBMP);
    invalidate;
end;

procedure TALCustomImage.MirrorHorizontal;
begin
  FlipHorizontal(WorkBMP);
  sCent := Point2d(WorkBMP.width-sCent.x,sCent.y);
  invalidate;
end;

procedure TALCustomImage.MirrorVertical;
begin
  FlipVertical(WorkBMP);
  sCent := Point2d(sCent.x,WorkBMP.Height-sCent.y);
  invalidate;
end;

procedure TALCustomImage.Rotate(Angle: double);
begin
  CopyBMP.Assign(WorkBMP);
  RotateBitmap(CopyBMP,WorkBMP,Point(Width div 2,Height div 2),Angle);
  invalidate;
end;

(*
procedure TALCustomImage.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var cx,cy,rx,ry: integer;
begin
  ActualPixel := Point(Trunc(XToW(x)),Trunc(YToW(y)));

  inherited;

  if ((not moving) or (not Loading)) then begin

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

  oldPos := Point(x,y);
  Origin := Point(x,y);
  MovePt := Point(x,y);
  oldMovePt := Point(x,y);

  CASE Button of
  mbLeft:
  begin
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

procedure TALCustomImage.MouseMove(Shift: TShiftState; X, Y: Integer);
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

procedure TALCustomImage.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  ActualPixel := Point(Trunc(XToW(x)),Trunc(YToW(y)));
  if Button=mbRight then begin
     if PopupMenu=nil then DblClick;
     if not PasteBMP.Empty then begin
        PasteBMP.ReleaseHandle;
        EnablePopup(PasteBMP.Empty);
        invalidate;
     end;
  end;
  inherited;
  Cursor := oldCursor;
  mouseLeft := False;
  MovePt := Point(x,y);
  oldMovePt := Point(x,y);
  Moving := False;
end;
*)

procedure TALCustomImage.MouseDown(Button: TMouseButton;
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
        Case ClipboardAction of
        cbaFixWindow :
          Selrect := Rect(x-FixWinRect.x,y-FixWinRect.y,x+FixWinRect.x,y+FixWinRect.y);
        cbaFixArea :
          Selrect := Rect(x-FixWinRect.x,y-FixWinRect.y,x+FixWinRect.x,y+FixWinRect.y);
        end;
      end;
        Case ClipboardAction of
        cbaFixWindow :
          Selrect := Rect(x-FixWinRect.x,y-FixWinRect.y,x+FixWinRect.x,y+FixWinRect.y);
        cbaFixArea :
         begin
         Selrect := Rect(x-FixWinRect.x,y-FixWinRect.y,x+FixWinRect.x,y+FixWinRect.y);
//         FixRect := Rect(Round(XToW(SelRect.Left)),Round(YToW(SelRect.Top)),
//                    Round(XToW(SelRect.Right)),Round(YToW(SelRect.Bottom)));
         end;
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

  mbRight :
    begin
      if SelRectVisible then
         Cursor := crSizeAll;
    end;
  END; // Case

      mouseLeft := Button=mbLeft;
      Moving := False;
  end;
end;

procedure TALCustomImage.MouseMove(Shift: TShiftState; X, Y: Integer);
var R: TRect;
begin
  MovePt := Point(x,y);
  ActualPixel := Point(Trunc(XToW(x)),Trunc(YToW(y)));

  if not PasteBMP.Empty then begin
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

     R := RectInflate(SelRect,-8,-8);

  if SelrectVisible then begin
     if Shift = [] then begin
     if FEnableSelect and SelRectVisible and (pFazis > 0) then begin
        SelRect := CorrectRect(Rect(Origin.x,Origin.y,x,y));
        pFazis := 2;
     end;
     if not PasteBMP.Empty then Repaint;
     end;
        Case ClipboardAction of
        cbaFixWindow :
          Selrect := Rect(x-FixWinRect.x,y-FixWinRect.y,x+FixWinRect.x,y+FixWinRect.y);
        cbaFixArea :
          Selrect := Rect(x-FixWinRect.x,y-FixWinRect.y,x+FixWinRect.x,y+FixWinRect.y);
        else
         if PtInRect(R,MovePt) then begin
           Cursor := crZoomIn;
           if Shift = [ssRight] then begin
              Cursor := crSizeAll;
              OffsetRect(Selrect,x-oldMovePt.x,y-oldMovePt.y);
           end;
         end;
        end;
        Repaint;
  end;

  if Shift = [ssLeft] then begin
     oldCursor := Cursor;
     Cursor := crKez2;
     MoveWindow((x-oldPos.x)/Zoom,(y-oldPos.y)/Zoom);
     oldPos := Point(x,y);
     Moving := True;
     SelRectVisible := False;
  end;
  MouseInOut:=0;
  end;
  
  if Assigned(FChangeWindow) then
     FChangeWindow(Self,sCent.x,sCent.y,XToW(x),YToW(y),Zoom,x,y);
  oldMovePt := Point(x,y);
  inherited;
end;

procedure TALCustomImage.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ActualPixel := Point(Trunc(XToW(x)),Trunc(YToW(y)));
  if Button=mbRight then begin
    if not SelRectVisible then begin
//     if PopupMenu=nil then DblClick;
     if not PasteBMP.Empty then begin
        PasteBMP.ReleaseHandle;
        EnablePopup(PasteBMP.Empty);
        invalidate;
     end;
     SelRectVisible:=False;
     pFazis := -1;
    end;
  end;
  inherited;
  Cursor := oldCursor;
  mouseLeft := False;
  MovePt := Point(x,y);
  oldMovePt := Point(x,y);
  Moving := False;
  inherited;
end;

function TALCustomImage.DoMouseWheel(Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint): Boolean;
var k: double;
begin
  Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos);
  if SelrectVisible and PtInRect(SelRect,MovePt) then begin
    if WheelDelta>0 then k:=1.05 else k:=0.95;
    SelRect := RectMagnify(SelRect,k);
    Repaint;
  end else
     if WheelDelta<0 then Zoom:=0.9*Zoom  else Zoom:=1.1*Zoom;
  if Assigned(FChangeWindow) then
     FChangeWindow(Self,sCent.x,sCent.y,XToW(MousePos.x),YToW(MousePos.y),Zoom,MousePos.x,MousePos.y);
  Result := True;
end;

function TALCustomImage.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := True;
  inherited DoMouseWheelDown(Shift, MousePos);
end;

function TALCustomImage.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelUp(Shift, MousePos);
end;

procedure TALCustomImage.DblClick;
begin
  if not Loading then begin
  MoveWindow(((Width/2)-oldPos.x)/Zoom,((Height/2)-oldPos.y)/Zoom);
  inherited;
  end;
end;

procedure TALCustomImage.Change(Sender: TObject);
begin
  Invalidate;
end;

procedure TALCustomImage.pChange(Sender: TObject);
begin
  EnablePopup(PasteBMP.Empty);
  Invalidate;
end;

// Draws a grid around the pixels with SubGridPen, if pixelwidth>6
procedure TALCustomImage.DrawPixelGrid;
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

procedure TALCustomImage.DrawGrid;
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
  BackBmp.Canvas.Brush.Style := bsClear;

  With BackBmp.Canvas do

  Case Grid.GridType of

  gtGrid:

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

  gtCent:
  begin
      kp.x := Sizes.x/2;
      kp.y := Sizes.y/2;
      tav  := 40/Zoom;
      MoveTo(XToS(kp.x-tav),YToS(kp.y)); LineTo(XToS(kp.x+tav),YToS(kp.y));
      MoveTo(XToS(kp.x),YToS(kp.y-tav)); LineTo(XToS(kp.x),YToS(kp.y+tav));
  end;

  gtBulb:
  begin
      kp.x := Sizes.x/2;
      kp.y := Sizes.y/2;
      tav  := 4/Zoom;
      MoveTo(XToS(kp.x-tav),YToS(kp.y)); LineTo(XToS(0),YToS(kp.y));
      MoveTo(XToS(kp.x+tav),YToS(kp.y)); LineTo(XToS(Sizes.x),YToS(kp.y));
      MoveTo(XToS(kp.x),YToS(kp.y-tav)); LineTo(XToS(kp.x),YToS(0));
      MoveTo(XToS(kp.x),YToS(kp.y+tav)); LineTo(XToS(kp.x),YToS(Sizes.y));
      Ellipse(XToS(kp.x-tav),YToS(kp.y-tav),XToS(kp.x+tav),YToS(kp.y+tav));
  end;

  gtCentGrid:
  begin
  if Grid.OnlyOnPaper then begin
      if (Zoom*GridWidth)>6 then begin

      Pen.Assign(Grid.GridPen);
      if PixelGrid and (Zoom>6) then Pen.Width := 2* Grid.GridPen.width
      else Pen.Width := Grid.GridPen.width;

      Pen:=Grid.SubGridPen;
      kp.x := 0;
      kp.y := 0;
      vp.x := Sizes.x;
      vp.y := Sizes.y;

      While kp.x<=vp.x/2 do begin
            MoveTo(XToS(Sizes.x/2+kp.x),YToS(kp.y));
            LineTo(XToS(Sizes.x/2+kp.x),YToS(vp.y));
            MoveTo(XToS(Sizes.x/2-kp.x),YToS(kp.y));
            LineTo(XToS(Sizes.x/2-kp.x),YToS(vp.y));
            kp.x:=kp.x+GridWidth;
      end;
      kp.x := Sizes.x;
      While kp.y<=vp.y/2 do begin
            MoveTo(XToS(0),YToS(Sizes.y/2+kp.y));
            LineTo(XToS(vp.x),YToS(Sizes.y/2+kp.y));
            MoveTo(XToS(0),YToS(Sizes.y/2-kp.y));
            LineTo(XToS(vp.x),YToS(Sizes.y/2-kp.y));
            kp.y:=kp.y+GridWidth;
      end;

      Pen:=Grid.GridPen;
      kp.x := Sizes.x/2;
      kp.y := Sizes.y/2;
      tav  := 0;
      MoveTo(XToS(kp.x-tav),YToS(kp.y)); LineTo(XToS(0),YToS(kp.y));
      MoveTo(XToS(kp.x+tav),YToS(kp.y)); LineTo(XToS(Sizes.x),YToS(kp.y));
      MoveTo(XToS(kp.x),YToS(kp.y-tav)); LineTo(XToS(kp.x),YToS(0));
      MoveTo(XToS(kp.x),YToS(kp.y+tav)); LineTo(XToS(kp.x),YToS(Sizes.y));
//      Ellipse(XToS(kp.x-tav),YToS(kp.y-tav),XToS(kp.x+tav),YToS(kp.y+tav));

      end;

  end;
  end;

  gtBulbEq:
  begin
  end;

  end;
end;
(*
  For i:=0 to 2 do begin
      tav  := Zoom * Gridtav;
      if tav>5 then begin

      Pen.Color := Grid.SubgridColor;
      Case GridTav of
      1:  Pen.Width := 1;
      10: Pen.Width := 2;
      100: Pen.Color := Grid.MaingridColor;
      end;

      marx := -Maradek(origo.x,GridTav);
      mary := -Maradek(origo.y,GridTav);
      kp.x := tav*marx;
      kp.y := tav*mary; kp0:=kp;

      if Grid.Style in [gsDot,gsCross] then
      While kp.x<=Width do begin
      While kp.y<=Height do begin
       Case Grid.Style of
       gsDot: begin
           Pixels[Trunc(kp.x),Height-Trunc(kp.y)]:= clGreen;
          end;
       gsCross: begin
           MoveTo(Trunc(kp.x)-4,Height-Trunc(kp.y));
           LineTo(Trunc(kp.x)+5,Height-Trunc(kp.y));
           MoveTo(Trunc(kp.x),Height-Trunc(kp.y)-4);
           LineTo(Trunc(kp.x),Height-Trunc(kp.y)+4);
          end;
       end;
       kp.y := kp.y+tav;
      end;
       kp.x:=kp.x+tav;
       kp.y := kp0.y;
      end;

      if Grid.Style=gsLine then begin
      While kp.x<=Width do begin
            MoveTo(Trunc(kp.x),0);
            LineTo(Trunc(kp.x),Height);
            kp.x:=kp.x+tav;
      end;
      While kp.y<=Height do begin
            MoveTo(0,Height-Trunc(kp.y));
            LineTo(Width,Height-Trunc(kp.y));
            kp.y:=kp.y+tav;
      end;
      end;

      end; //if tav>3

    GridTav := GridTav * 10;

  end;
  end; *)

end;

procedure TALCustomImage.OnTimer(Sender: TObject);
var step: double;
    bill: boolean;
    Idx : byte;
begin
  step := 10;
  idx := 0;
  If Self.Focused then begin
  if lo(GetAsyncKeyState(VK_UP)) <> 0 then idx:=1;
  if lo(GetAsyncKeyState(VK_DOWN)) <> 0 then idx:=2;
  if lo(GetAsyncKeyState(VK_LEFT)) <> 0 then idx:=3;
  if lo(GetAsyncKeyState(VK_RIGHT)) <> 0 then idx:=4;
  if mouseLeft then begin
  if Cursor=crNyilUp then idx:=1;
  if Cursor=crNyilDown then idx:=2;
  if Cursor=crNyilLeft then idx:=3;
  if Cursor=crNyilRight then idx:=4;
  if (Cursor > 18003) and (Cursor<18007) then
     InitSelWindow;
     Moving := True;
  end;
  Case idx of
  1: ShiftWindow(0,-step);
  2: ShiftWindow(0,step);
  3: ShiftWindow(-step,0);
  4: ShiftWindow(step,0);
  end;
  end;
end;

procedure TALCustomImage.SetRGBList(const Value: TRGBList);
var rgbSet : TrgbSet;
begin
     FRGBList := Value;
     WorkBMP.Assign(origBMP);
     Case FRGBList of
     rgbRGB: rgbSet:=[rgbR,rgbG,rgbB];
     rgbR  : rgbSet:=[rgbR];
     rgbG  : rgbSet:=[rgbG];
     rgbB  : rgbSet:=[rgbB];
     end;
     If MonoRGB then
     ChangeRGBChanelToMonochrome(WorkBMP,rgbR in RGBSet,rgbG in RGBSet,rgbB in RGBSet)
     else
     ChangeRGBChanel(WorkBMP,rgbR in RGBSet,rgbG in RGBSet,rgbB in RGBSet);
     Invalidate;
end;

(*
procedure TALCustomImage.SetsCent(const Value: TPoint2d);
begin
  if FsCent <> Value then begin
     FsCent := Value;
     SelRectVisible := False;
  end;
end;
*)
(*  ==========  TALImage ==================================================*)

procedure TALImage.Negative;
begin
  STAF_Imp.Negative(WorkBMP);
  Invalidate;
end;

procedure TALImage.FlipHorizontal;
begin
  STAF_Imp.FlipHorizontal(WorkBMP);
  SCent.x := Sizes.x-SCent.x;
  Invalidate;
end;

procedure TALImage.FlipVertical;
begin
  STAF_Imp.FlipVertical(WorkBMP);
  SCent.Y := Sizes.y-SCent.Y;
  Invalidate;
end;

procedure TALImage.BlackAndWhite;
begin
  STAF_Imp.BlackAndWhite(WorkBMP);
  Invalidate;
end;

procedure TALImage.Blur;
begin
  STAF_Imp.Blur(WorkBMP);
  Invalidate;
end;

procedure TALImage.Contrast(Amount: Integer);
begin
  CopyBMP.Assign(WorkBMP);
  janFX.Contrast(CopyBMP,Amount);
  WorkBMP.Assign(CopyBMP);
  Invalidate;
end;

procedure TALImage.Darkness(Amount: integer);
begin
  WorkBMP.Assign(OrigBMP);
  STAF_Imp.Darkness(WorkBMP,Amount);
  Invalidate;
end;

procedure TALImage.Lightness(Amount: Integer);
begin
  WorkBMP.Assign(OrigBMP);
  STAF_Imp.Lightness(WorkBMP,Amount);
  Invalidate;
end;

procedure TALImage.Posterize(amount: integer);
begin
  STAF_Imp.Posterize(WorkBMP,Amount);
  Invalidate;
end;

procedure TALImage.Rotate(Angle: Double);
begin
//  CopyBMP.Assign(OrigBMP);
  RotateBitmap( CopyBMP, WorkBMP, Point(CopyBMP.Width div 2,CopyBMP.Height div 2),
                Angle );
  invalidate;
end;

procedure TALImage.Saturation(Amount: Integer);
begin
  STAF_Imp.Saturation(WorkBMP,Amount);
  Invalidate;
end;

procedure TALImage.Sepia(depth: byte);
begin
  STAF_Imp.Sepia(WorkBMP,depth);
  Invalidate;
end;


{ TImageGrid ============================================================}

procedure TImageGrid.Changed;
begin if Assigned(FOnChange) then FOnChange(Self); end;

constructor TImageGrid.Create;
begin
  fGridPen       := TPen.Create;
  with fGridPen do begin
       Width := 1;
       Color := clSilver;
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
  FGridType      := gtGrid;
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

procedure TImageGrid.SetGridType(const Value: TGridType);
begin
  FGridType := Value;
  Changed;
end;

procedure TImageGrid.SetVisible(const Value: boolean);
begin
  FVisible := Value;
  Changed;
end;

procedure TALCustomImage.Click;
begin
  SetFocus;
  inherited;
end;

procedure TALCustomImage.KeyDown(var Key: Word; Shift: TShiftState);
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

procedure TALCustomImage.KeyPress(var Key: Char);
begin
  Case Key of
  #27         : RestoreOriginal;
  ^X          : CutToClipboard;
  ^C          : COPYToClipboard;
  ^V          : PasteFromClipboard;
  'H','h'     : Grid.Visible := not Grid.Visible;
  'C','c'     : CursorCross  := not CursorCross;
  'K','k'     : CentralCross  := not CentralCross;
  'A','a'     : RGBList:=rgbRGB;
  'R','r'     : RGBList:=rgbR;
  'G','g'     : RGBList:=rgbG;
  'B','b'     : RGBList:=rgbB;
//  VK_LEFT     : ShiftWindow(-10,0);
  end;
end;

procedure TALImage.CropSelected;
begin
  If SelRectVisible then begin
     SelRectVisible := False;
     Crop(WorkBMP,Rect(Round(XToW(SelRect.Left+1)),Round(YToW(SelRect.Top+1)),
        Round(XToW(SelRect.Right-1)),Round(YToW(SelRect.Bottom-1))));
     FitToScreen;
     invalidate;
  end;
end;

constructor TALImage.Create(AOwner: TComponent);
begin
  inherited;
  StarList  := TStarList.Create;
  FStarVisible := False;
  FSelectedStarColor := clRed;
  FStarColor         := clBlue;
end;

destructor TALImage.Destroy;
begin
  StarList.NewList;
  StarList.Free;
  inherited;
end;

procedure TALImage.SetStarCount(const Value: integer);
begin
  FStarCount := Value;
end;

procedure TALImage.SetStarVisible(const Value: boolean);
begin
  FStarVisible := Value;
  invalidate;
  If Value then StarDraw;
end;

procedure TALImage.StarDraw;
var i: integer;
    RR: integer;
    sr: TStarRecord;
    x,y : integer;
begin
  if StarList.Count>0 then
  with BackBMP.Canvas do begin
       Pen.Color := StarColor;
       Pen.Width := 1;
       Pen.Mode  := pmCopy;
       Brush.Style := bsClear;
       For i:=0 to StarCount-1 do begin
           sr := StarList.GetStar(i);
         if PontInKep(sr.x,sr.y,sRect) then begin
            if Sr.Selected then begin
               Pen.Color := SelectedStarColor;
               Brush.Color := SelectedStarColor;
               Brush.Style := bsSolid;
            end else begin
               Pen.Color := StarColor;
               Brush.Style := bsClear;
            end;
           RR := Round(Zoom * Sr.Radius);
//           if RR>1 then begin
           Ellipse(XToS(Sr.x)-RR,
                   YToS(Sr.y)-RR,
                   XToS(Sr.x)+RR,
                   YToS(Sr.y)+RR);
           RR := 1;
           Rectangle(XToS(Sr.x)-RR,
                   YToS(Sr.y)-RR,
                   XToS(Sr.x)+RR,
                   YToS(Sr.y)+RR);
//           end;
         end;
       end;
  end;
end;


procedure TALImage.Paint;
begin
  inherited;
  if StarVisible then StarDraw;
     BitBlt(Canvas.Handle,0,0,Width,Height,
             BackBMP.Canvas.Handle,0,0,SRCCOPY);

end;

function TALImage.GetStarCount: integer;
begin
  Result := StarList.Count;
end;

procedure TALImage.SetSelectedStarColor(const Value: TColor);
begin
  FSelectedStarColor := Value;
  invalidate;
end;

procedure TALImage.SetStarColor(const Value: TColor);
begin
  FStarColor := Value;
  invalidate;
end;

{ TRGBChanel }

constructor TRGBChanel.Create;
begin
  RGBBMP := TBitmap.Create;
  R := True;
  G := True;
  B := True;
end;

destructor TRGBChanel.Destroy;
begin
  RGBBMP.Free;
  inherited;
end;

procedure TRGBChanel.Changed;
begin if Assigned(FOnChange) then FOnChange(Self); end;

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

procedure TRGBChanel.SetR(const Value: boolean);
begin
  FR := Value;
  Changed;
end;

procedure TALCustomImage.SetCursorCross(const Value: boolean);
begin
  fCursorCross := Value;
  oldCursorCross:=fCursorCross;
  invalidate;
end;

procedure TALCustomImage.DrawMouseCross(o: TPoint; PenMode: TPenMode);
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

procedure TALCustomImage.CMMouseEnter(var msg:TMessage);
begin
    inherited;
    MouseInOut:=1;
    oldCursorCross:=CursorCross;
    oldMovePt := Point(-1,-1);
    invalidate;
    if Assigned(FMouseEnter) then FMouseEnter(Self);
end;

procedure TALCustomImage.CMMouseLeave(var msg: TMessage);
begin
    inherited;
    MouseInOut:=-1;
    CursorCross:=oldCursorCross;
    oldCursorCross := False;
    invalidate;
    if Assigned(FMouseLeave) then FMouseLeave(Self);
end;


procedure TALCustomImage.SetMonoRGB(const Value: boolean);
begin
  FMonoRGB := Value;
  RGBList := RGBList;
  invalidate
end;

// Get RGB values from screen pixel
function TALCustomImage.GetRGB(x, y: integer): TRGBRec;
var co: TColor;
begin
  co := WorkBMP.Canvas.Pixels[x,y];
  With Result do begin
       R := GetRValue(co);
       B := GetBValue(co);
       G := GetGValue(co);
  end;
end;


procedure TALCustomImage.InitSelWindow;
begin
  SelRectVisible := False;
  pFazis         := -1;
end;

// Crete a new image from original with subpixel shifting
procedure TALCustomImage.ShiftSubPixel(dx, dy: double);
var BMP: TBitmap;
    R  : TRect;
begin
  IF (Abs(dx)>0.0009) and (Abs(dx)>0.0009) then
  Try

    BMP := TBitmap.Create;
    BMP.Width := WorkBMP.Width;
    BMP.Height := WorkBMP.Height;
    // Integer pixel shifting
    If (Frac(dx)<0.001) and ((Frac(dy)<0.001)) then
    begin
      BMP.Canvas.Draw(Round(dx),Round(dy),WorkBMP);
    end;

  finally
    BMP.Free;
  end;
end;

procedure TALCustomImage.SetBulbRadius(const Value: integer);
begin
  FBulbRadius := Value;
  invalidate;
end;

procedure TALCustomImage.SetPixelColor(p: TPoint; Co: TColor);
begin
  WorkBMp.Canvas.Pixels[p.x,p.y]:=co;
  invalidate;
end;

function TALCustomImage.GetPixelColor(p: TPoint): TColor;
begin
  Result := WorkBMp.Canvas.Pixels[p.x,p.y];
end;

procedure TALCustomImage.EnablePopup(en: boolean);
begin
  if PopupMenu<>nil then PopupMenu.AutoPopup := en;
end;

procedure TALCustomImage.SetSelRectVisible(const Value: boolean);
begin
  FSelRectVisible := Value;
  EnablePopup(Value);
end;

procedure TALCustomImage.SetTitle(const Value: string);
begin
  FTitle := Value;
  invalidate;
end;

procedure TALCustomImage.SetFitting(const Value: boolean);
begin
  FFitting := Value;
  if Value then FittoScreen;
end;

procedure TALCustomImage.SetOffset(const Value: TPoint2d);
begin
  FOffset := Value;
end;

// Automatic Star Detection from photographic bitmap
//         Result = Star Count
Function TALImage.AutomaticStarDetection(Threshold: integer): integer;
(*begin
  StarList.StarDetect(WorkBMP,True,100);
  Result := StarList.Count;
end;*)

var BMP        : TBitmap;               // For manipulation
    thRGB      : TStarRecord;
    xx,yy      : integer;
    Row,starRow: pRGBTripleArray;
    endLine    : boolean;
    i,j        : integer;
    starRect   : TRect;
    FirstRed,EndRed: integer;
begin
Try
  Try
    Result := 0;
    StarList.NewList;
    BMP    := TBitmap.Create;
    BMPCopy(WorkBMP,BMP);
    BMP.PixelFormat := pf24bit;
    STAF_Imp.BlackAndWhite(BMP);
    STAF_Imp.HighPassEx(BMP,Threshold);
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
               thRGB := StarList.NewStarRec;
               with thRGB do begin
                    x := 0.5+(starRect.Right + starRect.Left)/2;
                    y := 0.5+(starRect.Bottom + starRect.Top)/2;
                    Radius := ((starRect.Right - starRect.Left)
                              +(starRect.Bottom - starRect.Top))/4;
                    Deleted := False;
               end;
               StarList.AddStar(thRGB);

               Inc(Result);
               StarCount := Result;
            end;
        end; // xx
    end; // yy
  finally
    BMP.Free;
    StarCount := Result;
  end;
except
  if BMP<>nil then BMP.Free;
  exit;
end;
end;

end.
