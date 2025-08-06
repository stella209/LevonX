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

unit AL_ZoomImg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, {DesignEditors,} Vcl.Imaging.jpeg, ClipBrd, NewGeom,
  STAF_Imp, STAF_Loader, AlType;


Const
  WM_IMAGEMOUSEDOWN    = WM_USER + 1000;
  WM_IMAGEMOUSEMOVE    = WM_USER + 1001;
  WM_IMAGEMOUSEUP      = WM_USER + 1002;
  WM_IMAGECHANGE       = WM_USER + 1003;

Type
  TImageTypes = (itNone, itBMP, itJPG);

  { Clipboard copy/paste: Total image; Only on Screen; Only the selected area}
  TClipBoardAction = (cbaTotal,        // Total Image
                      cbaScreen,       // Only the screen image
                      cbaSelected,     // Only the selected area
                      cbaScreenSelected,// Only the selected area from screen
                      cbaFixArea,      // Fix rect from image
                      cbaFixWindow);   // Fix rect from screen

   PRGBTripleArray = ^TRGBTripleArray;
   TRGBTripleArray = array[0..32767] of TRGBTriple;

  //Events type for zooming or dragging of component picture
  TChangeWindow = procedure(Sender: TObject; xCent,yCent,xWorld,yWorld,Zoom: double;
                            MouseX,MouseY: integer) of object;

  TBeforePaint = procedure(Sender: TObject; xCent,yCent: double;
                            DestRect: TRect) of object;

type
{
  TFileProperty = class(TStringProperty)
  private
    FileType : string[3];
  public
    FOpenDialog : TOpenDialog;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
    procedure Edit; override;
  end;
}
  TImageGrid = Class(TPersistent)
  private
    fVisible: boolean;
    FOnChange: TNotifyEvent;
    fOnlyOnPaper: boolean;
    FGridPen: TPen;
    FSubGridPen: TPen;
    FGridDistance: double;
    FSubGridDistance: double;
    FScale: boolean;
    FScaleFont: TFont;
    FPixelGrid: boolean;
    FScaleBrush: TBrush;
    FFix: boolean;
    procedure SetVisible(const Value: boolean);
    procedure SetOnlyOnPaper(const Value: boolean);
    procedure SetGridPen(const Value: TPen);
    procedure SetSubGridPen(const Value: TPen);
    procedure SetGridDistance(const Value: double);
    procedure SetSubGridDistance(const Value: double);
    procedure SetScale(const Value: boolean);
    procedure SetScaleFont(const Value: TFont);
    procedure SetPixelGrid(const Value: boolean);
    procedure SetScaleBrush(const Value: TBrush);
    procedure StyleChanged(Sender: TObject);
    procedure SetFix(const Value: boolean);
  protected
    procedure Changed;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Fix: boolean read FFix write SetFix;
    property GridDistance: double read FGridDistance write SetGridDistance;
    property GridPen: TPen read FGridPen write fGridPen;
    property SubGridPen: TPen read FSubGridPen write fSubGridPen;
    property SubGridDistance: double read FSubGridDistance write SetSubGridDistance;
    property OnlyOnPaper: boolean read fOnlyOnPaper write SetOnlyOnPaper default True;
    property PixelGrid : boolean read FPixelGrid write SetPixelGrid;
    property Scale: boolean read FScale write SetScale;  // Scale text visible
    property ScaleFont: TFont read FScaleFont write fScaleFont;
    property ScaleBrush: TBrush read FScaleBrush write fScaleBrush;
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

  // DataSource component for some other viewers
  TALImageSource = class(TComponent)
  private
    FFileName: TFileName;
    FRGBList: TRGBChanel;
    procedure SetFileName(const Value: TFileName);
    procedure SetRGBList(const Value: TRGBChanel);
  protected
    Loading   : boolean;
  public
    OrigBMP        : TBitmap;      // Original bmp in memory
    WorkBMP        : TBitmap;      // bmp copy for working in memory
    CopyBMP        : TBitmap;      // Temporary bmp for internal use (save,rotate,...)
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Change(Sender: TObject);
    procedure New(nWidth, nHeight: integer; nColor: TColor);
    function  LoadFromFile(FileName: TFileName):boolean;
    function  SaveToFile(FileName: TFileName):boolean;
    procedure RestoreOriginal;
    procedure SaveAsOriginal;
  published
    property FileName    : TFileName read FFileName write SetFileName;
//    property RGBList     : TRGBChanel read FRGBList write SetRGBList;
  end;

  TALCustomImageView = class(TCustomControl)
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
    FImageSource: TALImageSource;
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
    procedure SetImageSource(const Value: TALImageSource);
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
    BackBMP        : TBitmap;      // Ready bmp for copy to screen
    PasteBMP       : TBitmap;      // Temporary bmp for Paste special
    BMPOffset      : TPoint;
    Sizes          : TPoint;       // OriginalBmp sizes (width, height)
    sCent          : TPoint2d;     // Centrum of the source rectangle on WorkBMP
    newCent        : TPoint2d;     // Centrum of the source rectangle on CopyBMP
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
    procedure wChange(Sender: TObject);  // if WorkBMP Changed
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
    function GetRGB(x,y: integer): TRGB24;
    function GetPixelColor(p: TPoint): TColor;
    procedure SetPixelColor(p: TPoint; Co: TColor);
      // Drawing
    procedure FillRect(R: TRect; co: TColor);
    procedure DrawGrid;
    procedure DrawPixelGrid;
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
    property CursorCross : boolean read fCursorCross write SetCursorCross;
    property ImageSource : TALImageSource read FImageSource write SetImageSource;
    property EnableSelect: boolean read FEnableSelect write FEnableSelect;
    property EnableActions: boolean read FEnableActions write FEnableActions default True;
    property FileName    : TFileName read FFileName write SetFileName;
    property Fitting     : boolean read FFitting write FFitting;
    property Grid        : TImageGrid read FGrid write FGrid;
    property OverMove    : boolean read FOverMove write SetOverMove;
    property PixelGrid   : boolean read FPixelGrid write SetPixelGrid;
    property RGBList     : TRGBChanel read FRGBList write SetRGBList;
    property Zoom        : extended read fZoom write SetZoom;
    property OnChangeWindow: TChangeWindow read FChangeWindow write FChangeWindow;
    property OnBeforePaint: TBeforePaint read FBeforePaint write FBeforePaint;
    property OnAfterPaint: TBeforePaint read FAfterPaint write FAfterPaint;
    property OnMouseEnter: TNotifyEvent read FMouseEnter write FMouseEnter;
    property OnMouseLeave: TNotifyEvent read FMouseLeave write FMouseLeave;
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
    FFileName: string;
    FGrid: TImageGrid;
    FMouseLeave: TNotifyEvent;
    FMouseEnter: TNotifyEvent;
    FRGBList: TRGBChanel;
    FActualPixel: TPoint;
    FSelRectVisible: boolean;
    FFitting: boolean;
    FRotateAngle: double;
    FVisibleImage: boolean;
    FChange: TNotifyEvent;
    FEnableFocus: boolean;
    FOffset: TPoint2d;
    fHinted: boolean;
    Hint1   : THintWindow;
    HintActive : boolean;
    oldHintStr: string;
    FImageVisible: boolean;
    FVisibleOverlay: boolean;
    fCircleWindow: boolean;
    FEmbeddedJPG: boolean;
    procedure WMEraseBkGnd(var Message:TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure CMMouseEnter(var msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var msg: TMessage); message CM_MOUSELEAVE;
    Procedure CMChildkey( Var msg: TCMChildKey ); message CM_CHILDKEY;
    procedure SetBackColor(const Value: TColor);
    procedure SetBackCross(const Value: boolean);
    procedure SetBulbRadius(const Value: integer);
    procedure SetCentered(const Value: boolean);
    procedure SetCentralCross(const Value: boolean);
    procedure SetCursorCross(const Value: boolean);
    procedure SetFileName(const Value: string);
    procedure SetOverMove(const Value: boolean);
    procedure SetPixelGrid(const Value: boolean);
    procedure SetRGBList(const Value: TRGBChanel);
    procedure SetZoom(const Value: extended);
    procedure SetSelRectVisible(const Value: boolean);
    procedure SetRotateAngle(const Value: double);
    procedure SetVisibleImage(const Value: boolean);
    procedure Draw_Grid(gRect: TRect2d; GridWidth: double; Scale: boolean);
    procedure oChange(Sender: TObject);
    procedure SetFitting(const Value: boolean);
    procedure SetVisibleOverlay(const Value: boolean);
    procedure SetClipBoardAction(const Value: TClipBoardAction);
    procedure SetCircleWindow(const Value: boolean);
  protected
    elso                : boolean;
    timer               : TTimer;     // Timer for any doing;
    pFazis              : integer;    // Fazis for any action
    oldOrigin,oldMovePt : TPoint;
    mouseLeft           : boolean;
    oldCursor           : TCursor;
    oldCursorCross      : boolean;
    MouseInOut          : integer;   // Mouse in:1, Mouse:0, Mouse out:-1
    WinRgn              : HRgn;      // Window region;
    AutoPopup           : boolean;   // PopupMenu enable
    SelDirect           : integer;
    procedure Change(Sender: TObject);
    procedure OnTimer(Sender: TObject);
    procedure CalculateRects;
    procedure InitSelWindow;
    procedure SelToScreen;
    procedure InitBackImage;
    function  GetNewCent(origCent: TPoint2d): TPoint2d;
    procedure pChange(Sender: TObject);
    procedure wChange(Sender: TObject);  // if WorkBMP Changed
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
    BackBMP        : TBitmap;      // Redy bmp for copy to screen
    CopyBMP        : TBitmap;      // Temporary bmp for internal use
    PasteBMP       : TBitmap;      // Temporary bmp for Paste special
    StretchBitmap  : TStretchBitmap;  // For special effects (Rotate,Skew)
    InnerStream    : TMemoryStream;   // For save workBMP when image not shoe
    BMPOffset      : TPoint;
    Sizes          : TPoint;       // OriginalBmp sizes (width, height)
    sCent          : TPoint2d;     // Centrum of the source rectangle on WorkBMP
    newCent        : TPoint2d;     // Centrum of the source rectangle on CopyBMP
    sRect          : TRect2d;      // Rectangle for part of source bitmap
    dRect          : TRect;        // Rectangle for stretching to the screen
    SelRect        : TRect;        // Selected area on the screen;
    FixRect        : TRect;        // Fix rectangle on image
    FixSizes       : TPoint;       // Fix rectangle sizes: width,height
    FixWinRect     : TRect;        // Fix rectangle on screen
    oldPos         : TPoint;       // Store the old mouse position in window
    cPen           : TPen;         // Pen for central cross;
    Origin,MovePt  : TPoint;
    Loading        : boolean;      // Something in progress
    Moving         : boolean;      // Indicates the image dragging by mouse
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure ReDraw;
    procedure New(nWidth, nHeight: integer; nColor: TColor);
    function LoadFromFile(FileName: TFileName):boolean;
    function SaveToFile(FileName: TFileName):boolean;
    function LoadFromStream(stm: TStream; ImageType: TImageTypes): boolean;
    function SaveToStream(stm: TStream; ImageType: TImageTypes): boolean;
    procedure CutToClipboard;
    procedure CopyToClipboard;
    procedure PasteFromClipboard;
    procedure PasteSpecial;
    procedure CropSelected;
    procedure EnablePopup(en: boolean);   // Enable/disable popup menu
    function XToW(x: integer): double;
    function YToW(y: integer): double;
    function XToS(x: double): integer;
    function YToS(y: double): integer;
    function WToS(p: TPoint2d): TPoint;
    function SToW(p: TPoint): TPoint2d;
    function WorldToScreen(p: TPoint2d): TPoint;
    function ScreenToWorld(p: TPoint): TPoint2d;
    function ScreenRectToWorld(R: TRect): TRect;
    function WorldRectToScreen(R: TRect): TRect;
    procedure FitToScreen;
    procedure MoveWindow(x,y: double); overload;
    procedure ShiftWindow(x, y: double);
    procedure MoveToCentrum(x,y: double);
    procedure Transform(x,y,rot : double);
    procedure PixelToCentrum(x,y: integer);
    procedure SelRectToCentrum;
    procedure RestoreOriginal;
    procedure SaveAsOriginal;
    function GetRGB(x,y: integer): TRGB24;
    function GetPixelColor(p: TPoint): TColor;
    procedure SetPixelColor(p: TPoint; Co: TColor);
      // Drawing
    procedure FillRect(R: TRect; co: TColor);
    procedure DrawGrid;
    procedure DrawPixelGrid;
    procedure ShowHintPanel(Show: Boolean; x,y: integer; HintText: string);
    procedure CloseHintPanel;

    // RGB Colors (only for display)
    procedure SetVRGB;
    procedure SetVR;
    procedure SetVG;
    procedure SetVB;

    procedure Clear;
    procedure TurnLeft;
    procedure TurnRight;
    procedure MirrorHorizontal;
    procedure MirrorVertical;
    procedure FadeOut(Pause: Integer);
    procedure Negative;
    procedure MonoChrome;
    procedure BlackAndWhite;
    procedure Saturation(Amount: Integer);
    procedure Lightness(Amount: Integer);
    procedure Darkness(Amount: integer);
    procedure Contrast(Amount: Integer);
    procedure Sepia(depth:byte);
    Procedure Blur;
    procedure Posterize(amount: integer);

    property Canvas;
      // Actual pixel coordinates for operation
    property ActualPixel : TPoint read FActualPixel write FActualPixel;
    property SelRectVisible : boolean read FSelRectVisible write SetSelRectVisible;
    property Offset      : TPoint2d read FOffset write FOffset;
    // Published properties
    property ClipBoardAction: TClipBoardAction read FClipBoardAction write SetClipBoardAction;
    property BackColor   : TColor read FBackColor write SetBackColor;
    property BackCross   : boolean read FBackCross write SetBackCross;
    property BulbRadius  : integer read FBulbRadius write SetBulbRadius default 0;
    property Centered    : boolean read FCentered write SetCentered;
    property CentralCross: boolean read fCentralCross write SetCentralCross;
    property CursorCross : boolean read fCursorCross write SetCursorCross;
    property CircleWindow: boolean read fCircleWindow write SetCircleWindow;
    property EmbeddedJPG : boolean read FEmbeddedJPG write FEmbeddedJPG;
    property EnableFocus : boolean read FEnableFocus write FEnableFocus;
    property EnableSelect: boolean read FEnableSelect write FEnableSelect;
    property EnableActions: boolean read FEnableActions write FEnableActions;
    property FileName    : string read FFileName write SetFileName;
    property Fitting     : boolean read FFitting write SetFitting;
    property Grid        : TImageGrid read FGrid write FGrid;
    property Hinted      : boolean read fHinted write fHinted;
    property OverMove    : boolean read FOverMove write SetOverMove;
    property PixelGrid   : boolean read FPixelGrid write SetPixelGrid;
    property RGBList     : TRGBChanel read FRGBList write SetRGBList;
    property RotateAngle : double read FRotateAngle write SetRotateAngle;
    property Zoom        : extended read fZoom write SetZoom;
    property VisibleImage  : boolean read FVisibleImage write SetVisibleImage;
    property VisibleOverlay: boolean read FVisibleOverlay write SetVisibleOverlay;
    property OnChange    : TNotifyEvent read FChange write FChange;
    property OnChangeWindow: TChangeWindow read FChangeWindow write FChangeWindow;
    property OnBeforePaint: TBeforePaint read FBeforePaint write FBeforePaint;
    property OnAfterPaint: TBeforePaint read FAfterPaint write FAfterPaint;
    property OnMouseEnter: TNotifyEvent read FMouseEnter write FMouseEnter;
    property OnMouseLeave: TNotifyEvent read FMouseLeave write FMouseLeave;
  end;

  // Draws an RGB Diagramm for ZoomImage active line
  TALCustomRGBDiagram = class(TCustomControl)
  private
    FGColor: boolean;
    FBColor: boolean;
    FRColor: boolean;
    FRGBColor: boolean;
    FZoomImage: TALCustomZoomImage;
    FFixLine: boolean;
    FDotVisible: boolean;
    FBackColor: TColor;
    FPenWidth: integer;
    FAlignToImage: boolean;
    FRGBStatistic: boolean;
    procedure WMEraseBkGnd(var Message:TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMMouseMove(var Msg: TMessage); message WM_IMAGEMOUSEMOVE;
    procedure WMChange(var Msg: TMessage); message WM_IMAGECHANGE;
    procedure SetZoomImage(const Value: TALCustomZoomImage);
    procedure SetDotVisible(const Value: boolean);
    procedure SetBackColor(const Value: TColor);
    procedure SetPenWidth(const Value: integer);
    procedure SetBColor(const Value: boolean);
    procedure SetGColor(const Value: boolean);
    procedure SetRColor(const Value: boolean);
    procedure SetRGBColor(const Value: boolean);
    procedure SetAlignToImage(const Value: boolean);
    procedure SetRGBStatistic(const Value: boolean);
  protected
    BMP: TBitmap;
(*
    oldMouseDown : TMouseEvent;
    oldMouseMove : TMouseMoveEvent;
    oldMouseUp   : TMouseEvent;
    oldChangeWindow : TChangeWindow;
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ImageChangeWindow(Sender: TObject; xCent,yCent,xWorld,yWorld,Zoom: double;
                            MouseX,MouseY: integer);
*)
    procedure Resize; override;
  public
    MouseX,MouseY: integer;
    rgbMax : TRGB24;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure ReDraw(x,y: integer);
    procedure DrawGraph(SourceBMP: TBitmap;x,y,PixelWidth: integer);
    procedure ReadRGBStatistic;

    property AlignToImage : boolean read FAlignToImage  write SetAlignToImage;
    property BackColor : TColor  read FBackColor write SetBackColor;
    property PenWidth  : integer read FPenWidth  write SetPenWidth;
    property RGBColor  : boolean read FRGBColor write SetRGBColor;
    property RColor    : boolean read FRColor write SetRColor;
    property GColor    : boolean read FGColor write SetGColor;
    property BColor    : boolean read FBColor write SetBColor;
             { A kép középvonalának diagramja }
    property FixLine   : boolean read FFixLine write FFixLine;
             { A diagram pontok rajzolása }
    property DotVisible: boolean read FDotVisible write SetDotVisible;
    property RGBStatistic: boolean read FRGBStatistic write SetRGBStatistic;
             { Forrás kép }
    property ZoomImage: TALCustomZoomImage read FZoomImage write SetZoomImage;
  end;

  TALCustomRGBDiagram3D = class(TCustomControl)
  private
    FZoomImage: TALCustomZoomImage;
    FBackColor: TColor;
    procedure SetBackColor(const Value: TColor);
    procedure SetZoomImage(const Value: TALCustomZoomImage);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure DrawGraph(SourceBMP: TBitmap;x,y,PixelWidth: integer);
    property BackColor : TColor  read FBackColor write SetBackColor;
             { Forrás kép }
    property ZoomImage: TALCustomZoomImage read FZoomImage write SetZoomImage;
  end;

(*
  // ZoomImage descendat for astrophotography
  TALCustomAstroImage = class(TALCustomZoomImage)
  private
    FImageVisible: boolean;
    FStarVisible: boolean;
    FStarBrush: TBrush;
    procedure SetImageVisible(const Value: boolean);
    procedure SetStarBrush(const Value: TBrush);
    procedure SetStarVisible(const Value: boolean);
  protected
  public
    StarList  : TStarList;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function StarDetect: integer;
    function PrecizeStarDetect: integer;
    property ImageVisible : boolean read FImageVisible write SetImageVisible;
    property StarVisible  : boolean read FStarVisible write SetStarVisible;
    property StarBrush    : TBrush  read FStarBrush   write SetStarBrush;
  end;
*)
// ==================== Component definitions ========================

  TALZoomImage = class(TALCustomZoomImage)
  published
    property Align;
    property ClipBoardAction;
    property BackColor;
    property BackCross;
    property BulbRadius;
    property Centered;
    property CentralCross;
    property CircleWindow;
    property CursorCross;
    property EnableFocus;
    property EnableSelect;
    property EnableActions;
    property FileName;
    property Fitting;
    property Grid;
    property OverMove;
    property RGBList;
    property RotateAngle;
    property TabStop;
    property Visible;
    property Zoom;
    property OnBeforePaint;
    property OnAfterPaint;
    property OnChangeWindow;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
  end;

  TALImageView = class(TALCustomImageView)
  published
    property Align;
    property ImageSource;
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
    property OnKeyDown;
    property OnKeyPress;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
  end;

  TALRGBDiagram = class(TALCustomRGBDiagram)
  published
    property Align;
    property AlignToImage;
    property BackColor;
    property DotVisible;
    property RGBColor;
    property RColor;
    property GColor;
    property BColor;
    property FixLine;
    property PenWidth;
    property PopupMenu;
    property Visible;
    property ZoomImage;
  end;

//  procedure Register;
  procedure Send_Message(HW: TWinControl; Msag: Cardinal; wPar: WPARAM; Lpar: LPARAM; Res: LRESULT);

implementation

{$R AL_ZoomImg.dcr}

{
function TFileProperty.GetAttributes: TPropertyAttributes;
begin
	Result := [paDialog,paAutoUpdate];
end;

procedure TFileProperty.SetValue(const Value: string);
begin
     SetStrValue(Value);
end;

function TFileProperty.GetValue: string;
begin
  Result := GetStrValue;
end;

procedure TFileProperty.Edit;
var fn: string;
    ftype: string;
begin
    FOpenDialog := TOpenDialog.Create(Application);
    try
     	FOpenDialog.InitialDir:=ExtractFilePath(GetValue);
     	With FOpenDialog do begin
             FileName  :=GetValue;
             ftype := UpperCase(GetName);
             If ftype='FILENAME' then begin
                FileName:='*.BMP;*.JPG';
                Filter :=
                          'Bitmap file (*.BMP)|*.BMP|'+
                          'JPEG file (*.JPG)|*.JPG|';
             end;
             Title:=GetName+' megnyitása';
             If execute then SetStrValue(Filename);
        end;
    finally
        FOpenDialog.Free;
    end;
end;
}
(*
procedure Register;
begin
  RegisterComponents('AL',[TALZoomImage,TALImageSource,TALImageView,TALRGBDiagram]);
//  RegisterPropertyEditor(TypeInfo(string), TALZoomImage, 'FileName', TFileProperty);
end;
*)
// =============================================================================

{ TImageGrid }

procedure TImageGrid.Changed;
begin if Assigned(FOnChange) then FOnChange(Self); end;

constructor TImageGrid.Create;
begin
  fGridPen       := TPen.Create;
  with fGridPen do begin
       Width := 1;
       Color := clGray;
       Style := psSolid;
       Mode  := pmCopy;
       OnChange := StyleChanged;
  end;
  fSubgridPen    := TPen.Create;
  with fSubGridPen do begin
       Width := 1;
       Color := $005F5F5F;
       Style := psSolid;
       Mode  := pmCopy;
       OnChange := StyleChanged;
  end;
  fGridDistance  := 100;
  fSubGridDistance  := 10;
  fScale            := False;
  fScaleFont        := TFont.Create;
  fScaleFont.Name   := 'Arial';
  fScaleFont.Size   := 8;
  fScaleFont.Color  := clWhite;
  fScaleBrush       := TBrush.Create;
  with fScaleBrush do begin
       Style := bsSolid;
       Color := clGray;
       OnChange := StyleChanged;
  end;
  fOnlyOnPaper   := True;
  Changed;
end;

destructor TImageGrid.Destroy;
begin
  fSubgridPen.Free;
  fGridPen.Free;
  fScaleFont.Free;
  fScaleBrush.Free;
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

procedure TImageGrid.SetPixelGrid(const Value: boolean);
begin
  FPixelGrid := Value;
  Changed;
end;

procedure TImageGrid.SetScale(const Value: boolean);
begin
  FScale := Value;
  Changed;
end;

procedure TImageGrid.StyleChanged(Sender: TObject);
begin
  Changed;
end;

procedure TImageGrid.SetScaleBrush(const Value: TBrush);
begin
  FScaleBrush := Value;
  Changed;
end;

procedure TImageGrid.SetScaleFont(const Value: TFont);
begin
  FScaleFont := Value;
  Changed;
end;

procedure TImageGrid.SetSubGridDistance(const Value: double);
begin
  FSubGridDistance := Value;
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

procedure TImageGrid.SetFix(const Value: boolean);
begin
  FFix := Value;
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
  FRGB := True;
  FMonoRGB := False;
end;

destructor TRGBChanel.Destroy;
begin
  inherited;
end;

procedure TRGBChanel.SetB(const Value: boolean);
begin
  ChangeRGB(FMonoRGB,FR,FG,Value);
end;

procedure TRGBChanel.SetG(const Value: boolean);
begin
  ChangeRGB(FMonoRGB,FR,Value,FB);
end;

procedure TRGBChanel.SetMonoRGB(const Value: boolean);
begin
  ChangeRGB(Value,FR,FG,FB);
end;

procedure TRGBChanel.SetR(const Value: boolean);
begin
  ChangeRGB(FMonoRGB,Value,FG,FB);
end;

procedure TRGBChanel.SetRGB(const Value: boolean);
begin
  FRGB := Value;
  ChangeRGB(not Value,True,True,True);
end;
(*
procedure TRGBChanel.SetRGBChanel(const _Mono, _R, _G, _B: boolean);
begin
  FRGB := _Mono;
  FR   := _R;
  FG   := _G;
  FB   := _B;
  Changed;
end;
*)

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
  OrigBMP.OnChange  := oChange;
  PasteBMP.OnChange := pChange;
  WorkBMP.PixelFormat := pf24bit;
  CopyBMP.PixelFormat := pf24bit;
  StretchBitmap  := TStretchBitmap.Create;
  StretchBitmap.SourceBitmap := WorkBMP;
  StretchBitmap.TargetBitmap := CopyBMP;
  cPen           := TPen.Create;
  Grid           := TImageGrid.Create;
  fGrid.OnChange := Change;
  fGrid.fVisible := False;
  fGrid.FOnlyOnPaper := True;
  FPixelGrid     := False;
  Hinted         := True;
  Hint1          := THintWindow.Create(Self);
  with cPen do begin
       Color := clRed;
       Style := psSolid;
       Mode  := pmCopy;
  end;
  RGBList        := TRGBChanel.Create;
  RGBList.RGB    := True;
  RGBList.OnChange := Change;
  CentralCross   := True;
  BackColor      := clSilver;
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
  TabStop        := True;
  DoubleBuffered := True;
  timer          := TTimer.Create(Self);
  timer.Interval := 10;
  timer.Ontimer  := OnTimer;
  FClipBoardAction := cbaTotal;
  FixRect        := Rect(0,0,100,100);
  FixWinRect     := Rect(0,0,100,100);
  Width          := 100;
  Height         := 100;
  FEnableSelect  := True;
  AutoPopup      := True;
  FEnableFocus   := True;
  FEnableActions := True;
  FVisibleImage  := True;
  FVisibleOverlay:= True;
  FEmbeddedJPG   := True;
  SelRect        := Rect(0,0,0,0);
  FixSizes       := Point(200,100);
  InitSelWindow;
  elso := True;
end;

destructor TALCustomZoomImage.Destroy;
begin
  OrigBMP.Free;
  WorkBMP.Free;
  BackBMP.Free;
  CopyBMP.Free;
  PasteBMP.Free;
  StretchBitmap.Free;
  cPen.Free;
  Grid.Free;
  Hint1.Free;
  RGBList.Free;
  timer.free;
  inherited;
end;

procedure TALCustomZoomImage.oChange(Sender: TObject);
begin
//    if Assigned(FChange) then FChange(Self);
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


procedure TALCustomZoomImage.CMChildkey(var msg: TCMChildKey);
var dx,dy: integer;
    k:integer;
begin
  k:=16;
  dx := 0; dy:=0;
  msg.result := 1; // declares key as handled
  Case msg.charcode of
    VK_LEFT    : dx:=-k;
    VK_RIGHT   : dx:=k;
    VK_UP      : dy:=-k;
    VK_DOWN    : dy:=k;
  Else
    msg.result:= 0;
    inherited;
  End;
  if (dx<>0) or (dy<>0) then
     ShiftWindow(dx,dy);
  inherited;
end;

procedure TALCustomZoomImage.CMMouseEnter(var msg: TMessage);
begin
    inherited;
    MouseInOut:=1;
    oldCursorCross:=CursorCross;
    oldMovePt := Point(-1,-1);
    if EnableFocus then SetFocus;
    invalidate;
    if Assigned(FMouseEnter) then FMouseEnter(Self);
end;

procedure TALCustomZoomImage.CMMouseLeave(var msg: TMessage);
begin
    inherited;
    MouseInOut:=-1;
    CursorCross:=oldCursorCross;
    oldCursorCross := False;
    CloseHintPanel;
    Screen.Cursor := crDefault;
    invalidate;
    if Assigned(FMouseLeave) then FMouseLeave(Self);
end;

procedure TALCustomZoomImage.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1
end;

procedure TALCustomZoomImage.WMSize(var Msg: TWMSize);
var sc : TPoint2d;
begin
(*
  sc := newCent;
  if Fitting then FitToScreen
  else
      MoveToCentrum(sc.x,sc.y);
*)
  invalidate;
end;

procedure TALCustomZoomImage.SetBackColor(const Value: TColor);
begin
  FBackColor := Value;
  StretchBitmap.BackgroundColor := Value;
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

procedure TALCustomZoomImage.SetCircleWindow(const Value: boolean);
begin
  fCircleWindow := Value;
  Redraw;
end;

procedure TALCustomZoomImage.SetClipBoardAction(const Value: TClipBoardAction);
begin
  FClipBoardAction := Value;
  if Ord(Value)>3 then begin
     SelRectVisible := Ord(Value)>3;
  end;
end;

procedure TALCustomZoomImage.SetCursorCross(const Value: boolean);
begin
  fCursorCross := Value;
  oldCursorCross := Value;
  invalidate;
end;

procedure TALCustomZoomImage.SetFileName(const Value: string);
begin
     if LoadFromFile(Value) then
        FFileName := Value
     else
        FFileName := '';
end;

procedure TALCustomZoomImage.SetOverMove(const Value: boolean);
begin
  FOverMove := Value;
  invalidate;
end;

procedure TALCustomZoomImage.SetPixelGrid(const Value: boolean);
begin
  FPixelGrid := Value;
  Grid.Visible := Value;
  invalidate;
end;

procedure TALCustomZoomImage.SetRGBList(const Value: TRGBChanel);
var cBMP : TBitmap;
begin
Try
  FRGBList := Value;
  cBMP := TBitmap.Create;
  WorkBMP.OnChange := nil;
  cBMP.Assign(WorkBMP);
    ChangeRGBChanel(WorkBMP,FRGBList.MonoRGB,FRGBList.FR,FRGBList.FG,FRGBList.FB);
  ReDraw;
finally
  WorkBMP.Assign(cBMP);
  WorkBMP.OnChange := wChange;
  cBMP.Free;
end;
end;

procedure TALCustomZoomImage.SetZoom(const Value: extended);
var cx,cy,w,h : double;
begin
  if fZoom <> Value then begin
     // Limited zoom
     Sizes := Point(WorkBMP.Width,WorkBMP.Height);
     if Value>100 then fZoom:=100
     else
     if (Value*Sizes.x>8) and (Value*Sizes.y>8) then
         fZoom := Value;
     if WorkBMP.Width<1 then
         fZoom := Value;

     if Ord(FClipboardAction)=4 then begin
        w  := FixSizes.x/2;
        h  := FixSizes.y/2;
        cx := SelRect.Left+(SelRect.Right-SelRect.Left)/2;
        cy := SelRect.Top+(SelRect.Bottom-SelRect.Top)/2;
        SelRect := Rect(Trunc(cx-FZoom*w),Trunc(cy-FZoom*h),
                        Trunc(cx+FZoom*w),Trunc(cy+FZoom*h));
     end;

     if Assigned(FChangeWindow) then
        FChangeWindow(Self,sCent.x,sCent.y,XToW(oldPos.x),YToW(oldPos.y),
                      Zoom,oldPos.x,oldPos.y);
     invalidate;
  end;
end;

procedure TALCustomZoomImage.Change(Sender: TObject);
begin
  IF Sender = RGBList then
     RGBList := RGBList
  else
  invalidate;
end;

procedure TALCustomZoomImage.OnTimer(Sender: TObject);
var step: double;
begin
  step := 4;
  if FEnableActions and mouseLeft then
  begin
       if not SelrectVisible then
       if (MouseInOut>-1) then
       begin
            if Cursor=crNyilUp then ShiftWindow(0,-step);
            if Cursor=crNyilDown then ShiftWindow(0,step);
            if Cursor=crNyilLeft then ShiftWindow(-step,0);
            if Cursor=crNyilRight then ShiftWindow(step,0);
            if (Cursor > 18002) and (Cursor<18007) then
               Moving := True;
       end;

       if SelrectVisible then
       begin
          step:=1;
          if MovePt.Y<20 then ShiftWindow(0,-step);
          if MovePt.Y>(Height-20) then ShiftWindow(0,step);
          if MovePt.x<20 then ShiftWindow(-step,0);
          if MovePt.X>(Width-20) then ShiftWindow(step,0);
          Moving := True;
       end;
  end;
end;

procedure TALCustomZoomImage.Click;
begin
  if TabStop then SetFocus;
  inherited;
end;

procedure TALCustomZoomImage.DblClick;
begin
  if (not Loading) and FEnableActions then begin
     MoveWindow(((Width/2)-oldPos.x)/Zoom,((Height/2)-oldPos.y)/Zoom);
     SelRectVisible:=False;
     Moving:=True;
     pFazis := -1;
     inherited;
  end;
end;

function TALCustomZoomImage.DoMouseWheel(Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos);
//  if EnableActions then begin
  if WheelDelta<0 then Zoom:=0.9*Zoom
  else Zoom:=1.1*Zoom;
//  end;
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
    Canvas.pen.Color := clRed;
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
  if EnableActions and (not (moving or Loading)) then begin
  if Shift=[] then
  Case Key of
  VK_RETURN   : FitToScreen;
  VK_ESCAPE   : begin
                     IF SelRectVisible then SelRectVisible:=False;
                     RestoreOriginal;
                end;
  VK_ADD,190   : Zoom := 1.1*Zoom;
  VK_SUBTRACT,189 : Zoom := 0.9*Zoom;
  VK_SPACE    : RotateAngle := 0;
  end;
  if Shift=[ssCtrl] then
  Case Key of
  VK_DELETE   : New(0,0,BackColor);     // Ctrl+Del: Deletes image
  end;
  END;
  inherited;
end;

procedure TALCustomZoomImage.KeyPress(var Key: Char);
begin
(*
  if EnableActions and (not (moving or Loading)) then
  Case Key of
  ^X          : CutToClipboard;
  ^C          : COPYToClipboard;
  ^V          : PasteFromClipboard;
  ^K          : CropSelected;
  'G','g'     : Grid.Visible := not Grid.Visible;
  'C','c'     : CursorCross  := not CursorCross;
  'K','k'     : CentralCross := not CentralCross;
  'Q','q'     : CircleWindow := not CircleWindow;
  'F','f'     : FitToScreen;
  'O','o'     : RestoreOriginal;
  '1'         : Zoom := 1;
  'R','r'     : RotateAngle := RotateAngle+1;
  'L','l'     : RotateAngle := RotateAngle-1;
  ^R          : SetVR;
  ^G          : SetVG;
  ^B          : SetVB;
  'A','a'     : begin
                FRgbList.RGB := True;
                SetRGBList(FRgbList);
                end;
  'M','m'     : begin
                FRgbList.MonoRGB := True;
                SetRGBList(FRgbList);
                end;
  'I','i'     : Negative;
  end;
  INVALIDATE;
  inherited;*)
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
    if Assigned(FChange) then FChange(Self);
     ext := UpperCase(ExtractFileExt(FileName));
     If ext='.BMP' then OrigBMP.LoadFromFile(FileName)
     else
     If ext='.JPG' then
     begin
        jpgIMG := TJpegImage.Create;
        jpgIMG.LoadFromFile(FileName);
        OrigBMP.Assign(jpgIMG);
        if jpgIMG<>nil then jpgIMG.Free;
     end
     else
     if (ext='.FIT') OR (ext='.FITS') then
        LoadFITImage(FileName,OrigBMP)
     else
     if (ext='.CR2') then begin
        if EmbeddedJPG then
           GetRAWTHumbnail(FileName,OrigBMP)
        else
           LoadWICImage(FileName,OrigBMP);
     end
     else
         LoadWICImage(FileName,OrigBMP);
  except
    if jpgIMG<>nil then jpgIMG.Free;
    exit;
  end;
finally
  WorkBMP.OnChange := nil;
  OrigBMP.PixelFormat := pf24bit;
  WorkBMP.PixelFormat := pf24bit;
  RestoreOriginal;
  // New image move to the centre of window and with original sizes
  Sizes := Point(OrigBMP.Width,OrigBMP.Height);
  FFilename := FileName;
  Result := True;

  if elso then begin
     FitToScreen;
     elso:=False;
  end else
  if Fitting then FitToScreen;
  if Centered then Centered:=True;

  WorkBMP.OnChange := wChange;
  Loading := False;
end;
end;

function TALCustomZoomImage.LoadFromStream(stm: TStream; ImageType: TImageTypes): boolean;
Var jpgIMG: TJpegImage;
begin
Try
  Result := False;
  Loading := True;
  Case ImageType of
  itBMP: WorkBMP.LoadFromStream(STM);
  itJPG:
         Try
           jpgIMG := TJpegImage.Create;
           jpgIMG.LoadFromStream(stm);
           WorkBMP.Assign(jpgIMG);
         finally
           jpgIMG.Free;
         end;
  end;
finally
//  RestoreOriginal;
  Sizes := Point(WorkBMP.Width,WorkBMP.Height);
  Result := True;
  if Fitting then FitToScreen;
  if Centered then Centered:=True;
  invalidate;
  Loading := False;
end;
end;

function TALCustomZoomImage.SaveToStream(stm: TStream; ImageType: TImageTypes): boolean;
Var jpgIMG: TJpegImage;
begin
Try
  Result := False;
  Loading := True;
  Case ImageType of
  itBMP: WorkBMP.SaveToStream(STM);
  itJPG:
         Try
           jpgIMG := TJpegImage.Create;
           jpgIMG.Assign(WorkBMP);
           jpgIMG.SaveToStream(stm);
         finally
           jpgIMG.Free;
         end;
  end;
finally
  Loading := False;
  Result := True;
end;                   
end;

procedure Send_Message(HW: TWinControl; Msag: Cardinal; wPar: WPARAM; Lpar: LPARAM; Res: LRESULT);
Var msg: TMessage;
begin
  msg.Msg    := msag;
  msg.WParam := wPar;
  msg.LParam := lPar;
  msg.Result := Res;
  HW.Broadcast(msg);
end;

procedure TALCustomZoomImage.MonoChrome;
begin
  STAF_Imp.GrayScale(WorkBMP);
  Redraw;
end;

procedure TALCustomZoomImage.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var cx,cy,rx,ry: integer;
begin
  if EnableFocus then SetFocus;
  ActualPixel := Point(Trunc(XToW(x)),Trunc(YToW(y)));
  oldPos := Point(x,y);

  inherited;

  if EnableActions and (not (moving or Loading)) then begin

  CASE Button of
  mbLeft:
  begin

  // Manipulating the Selected Area
  if FEnableSelect then
  BEGIN

     if (y>SelRect.Top) and (y<SelRect.Bottom) then
     begin
     if (Abs(x-SelRect.Left)<5) then
        SelDirect := 1;
     if (Abs(x-SelRect.Right)<5) then
        SelDirect := 3;
     end;
     if (x<SelRect.Right) and (x>SelRect.Left) then
     begin
     if (Abs(y-SelRect.Top)<5) then
        SelDirect := 2;
     if (Abs(y-SelRect.Bottom)<5) then
        SelDirect := 4;
     end;

  if (Cursor<>crSizeWE) and (Cursor<>crSizeNS) then
  if SelRectVisible and (pFazis > 1) and (Cursor <> crZoomIn)
  then begin
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
         InitSelWindow;
      end;
  end
  else
  begin

  if (Shift = [ssAlt,ssLeft]) or (Shift = [ssCtrl,ssLeft]) then
     begin
        // Bigin draw selrect
        SelRect := Rect(x,y,x,y);
        SelRectVisible := True;
        SelDirect := 0;
        pFazis  := 1;
     end
     else
     if SelRectVisible then begin
        if Cursor = crZoomIn then
           SelToScreen
        else begin
           InitSelWindow;
        end;
     end;

     invalidate;
  end;
  END;

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
     CopyBMP.Assign(WorkBMP);
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
var msg: TMessage;
  Hintstr: string;
  HintRect: TRect;
  p: TPoint;
  w,he: integer;
begin
if EnableActions then begin
  MovePt := Point(x,y);
  ActualPixel := Point(Trunc(XToW(x)),Trunc(YToW(y)));

  if PasteBMP<>nil then begin
     invalidate;
  end;

  if EnableActions and ((not moving) or (not Loading)) then begin
  if Shift = [] then begin
     if x<10 then Cursor := crNyilLeft;
     if x>Width-10 then Cursor := crNyilRight;
     if y<10 then Cursor := crNyilUp;
     if y>Height-10 then Cursor := crNyilDown;
  end;
  if PtInRect(Rect(20,20,width-20,height-20),Point(x,y)) then Cursor := crDefault;

  if (Shift = [ssAlt,ssLeft]) or (Shift = [ssCtrl,ssLeft]) then begin
     if FEnableSelect and SelRectVisible and (pFazis > 0) then begin
        SelRect := CorrectRect(Rect(Origin.x,Origin.y,x,y));
        pFazis := 2;
        Repaint;
     end;
     if not PasteBMP.Empty then Repaint;
  end;

  // Cursor for border of selected rect
  if SelRectVisible then
  begin

  if Shift = [] then
  if Ord(FClipboardAction)<4 then begin
     if ((Abs(x-SelRect.Left)<5) or (Abs(x-SelRect.Right)<5))
        and (y>SelRect.Top) and (y<SelRect.Bottom)
        then
            Cursor:=crSizeWE;
     if ((Abs(y-SelRect.Top)<5) or (Abs(y-SelRect.Bottom)<5))
        and (x<SelRect.Right) and (x>SelRect.Left)
        then
            Cursor:=crSizeNS;
  end else begin
      if Ord(FClipboardAction)=4 then
      SelRect := Rect(x-Trunc((FixSizes.X div 2)*FZoom),y-Trunc((FixSizes.Y div 2)*FZoom),
                      x+Trunc((FixSizes.X div 2)*FZoom),y+Trunc((FixSizes.Y div 2)*FZoom));
      if Ord(FClipboardAction)=5 then
      SelRect := Rect(x-(FixSizes.X div 2),y-(FixSizes.Y div 2),
                      x+(FixSizes.X div 2),y+(FixSizes.Y div 2));
  end;

  if SelRectVisible then
  if PtInRect(SelRect,MovePt) then
     if Ord(FClipboardAction)<4 then
        Cursor := crZoomIn
     else
        Cursor := crCross;

  if Shift = [ssLeft] then
  begin
     Case SelDirect of
     1: SelRect.Left := x;
     2: SelRect.Top := y;
     3: SelRect.Right := x;
     4: SelRect.Bottom := y;
     end;
     Repaint;
  end;
  end else
    If (oldMovePt.x<>MovePt.x) or (oldMovePt.y<>MovePt.y) then begin
     If (Shift=[ssLeft]) then begin
        MoveWindow((x-oldPos.x)/Zoom,(y-oldPos.y)/Zoom);
        oldPos := Point(x,y);
        Moving := True;
     end;
     If (Shift=[ssRight]) then begin
        if (oldMovePt.y-MovePt.y)>0 then Zoom := Zoom*1.1
             else Zoom := Zoom*0.9;
     end;
  end;

  MouseInOut:=0;
  end;
end;

  if Assigned(FChangeWindow) then
     FChangeWindow(Self,sCent.x,sCent.y,XToW(x),YToW(y),Zoom,x,y);
  oldMovePt := Point(x,y);

  msg.Msg := WM_IMAGEMOUSEMOVE;
  msg.WParam := x;
  msg.LParam := y;
  msg.Result := 0;
  Broadcast(msg);

  inherited;
end;

procedure TALCustomZoomImage.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if EnableActions and (not (moving or Loading)) then begin
  ActualPixel := Point(Trunc(XToW(x)),Trunc(YToW(y)));
  if Button=mbRight then begin
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

(*
  {Hint ablak rajzolása}
  If Hinted then begin
  If (CPMatch or CurveIn) and (Shift = []) then begin
     Hint1.Font.Size:=4;
     FCurve := FCurveList.Items[CPCurve];
     If CPMatch then
        Hintstr := fCurve.Name+' ['+IntToStr(CPCurve)+'-'+IntToStr(CPIndex)+'/'+IntToStr(FCurve.Count)+']   ';
//     else
//     If CurveIn then
//        Hintstr := ' ['+IntToStr(CPCurve)+'] ';
     p := ClientToScreen(point(x+8,y-18));
     w := Hint1.Canvas.TextWidth(Hintstr);
     he := Hint1.Canvas.TextHeight(Hintstr)+2;
     HintRect := Rect(p.x,p.y,p.x+w,p.y+he);
     If (not HintActive) or (Hintstr<>oldHintstr) then begin
        Hint1.ActivateHint(HintRect,Hintstr);
        oldHintstr := Hintstr;
        HintActive:=True;
     end;
  end else
    If HintActive then begin
       Hint1.ReleaseHandle;
       HintActive := False;
    end;
  end;
*)

  Cursor := oldCursor;
  mouseLeft := False;
  MovePt := Point(x,y);
  oldMovePt := Point(x,y);
  Moving := False;
  inherited;
end;

procedure TALCustomZoomImage.New(nWidth, nHeight: integer; nColor: TColor);
begin
  if Assigned(FChange) then FChange(Self);
  OrigBMP.Width := nWidth;
  OrigBMP.Height := nHeight;
  Cls(OrigBMP.Canvas,nColor);
  RestoreOriginal;
  FFileName := '';
  invalidate;
end;

procedure TALCustomZoomImage.MoveWindow(x, y: double);
var pCent : TPoint2d;
begin
  pCent     := Elforgatas(Point2d(x,y),Point2d(0,0),Rad(-RotateAngle));
  sCent     := Point2d(sCent.x-pCent.x, sCent.y-pCent.y);
  if Assigned(FChangeWindow) then
     FChangeWindow(Self,sCent.x,sCent.y,0,0,Zoom,0,0);
  invalidate;
end;

procedure TALCustomZoomImage.ShiftWindow(x, y: double);
var pCent : TPoint2d;
begin
  pCent     := Elforgatas(Point2d(x,y),Point2d(0,0),Rad(-RotateAngle));
  sCent     := Point2d(sCent.x+(pCent.x/Zoom),sCent.y+(pCent.y/Zoom));
  if SelrectVisible then
     begin
       OffsetRect(SelRect,Round(-x),Round(-y));
     end;
  if Assigned(FChangeWindow) then
     FChangeWindow(Self,sCent.x,sCent.y,0,0,Zoom,0,0);
  invalidate;
end;

procedure TALCustomZoomImage.ShowHintPanel(Show: Boolean; x,y: integer; HintText: string);
Var
  HintRect: TRect;
  p: TPoint;
  w,he: integer;
begin
  {Hint ablak rajzolása}
  if Show then begin
     Hint1.Canvas.Font.Name := 'Courir New';
     Hint1.Canvas.Font.Size := 8;
     p := ClientToScreen(point(x+8,y-18));
     w := Pos(chr(13),HintText);
     if w=0 then
        w := Hint1.Canvas.TextWidth(HintText)
     else
        w := Hint1.Canvas.TextWidth(Copy(HintText,1,w+1));
     he := Hint1.Canvas.TextHeight(HintText)+2+48;
     HintRect := Rect(p.x,p.y,p.x+w,p.y+he);
     Hint1.Color := clWhite;
     Hint1.ActivateHint(HintRect,HintText);
     HintActive:=True;
  end else
    If HintActive then begin
       Hint1.ReleaseHandle;
       HintActive := False;
    end;
end;

procedure TALCustomZoomImage.CloseHintPanel;
begin
    If HintActive then begin
       Hint1.ReleaseHandle;
       HintActive := False;
    end;
end;

function TALCustomZoomImage.GetNewCent(origCent: TPoint2d): TPoint2d;
var dx,dy: double;    // Differences to the upper left corner
    pCent: TPoint2d;
begin
  pCent := Point2d(sCent.x-WorkBMP.Width/2,origCent.y-WorkBMP.Height/2);
  pCent := Elforgatas(pCent,Point2d(0,0),Rad(RotateAngle));
  dx    := pCent.X;
  dy    := pCent.Y;
  Result := Point2d(dx+CopyBMP.Width/2,dy+CopyBMP.Height/2);
end;

procedure TALCustomZoomImage.CalculateRects;
var w,h : double;
begin
  newCent := GetNewCent(sCent);
  Sizes := Point(CopyBMP.Width,CopyBMP.Height);

  // newCent need to be on the source bitmap
  w := width/(2*Zoom);
  h := height/(2*Zoom);

  // Calculate the rect of the source window to view
  sRect := Rect2d(Round(newCent.x-w-1),Round(newCent.y-h-1),
                  Round(newCent.x+w+1),Round(newCent.y+h+1));
  dRect := Rect(XToS(sRect.x1),YToS(sRect.y1),
                XToS(sRect.x2),YToS(sRect.y2));
  BMPOffset := Point(dRect.left,dRect.top);
  if not OverMove then begin
     if newCent.x<0 then newCent.x:=0;
     if newCent.y<0 then newCent.y:=0;
     if newCent.x>Sizes.x then newCent.x:=Sizes.x;
     if newCent.y>Sizes.y then newCent.y:=Sizes.y;
     if sCent.x<0 then sCent.x:=0;
     if sCent.y<0 then sCent.y:=0;
     if sCent.x>WorkBMP.Width then sCent.x:=WorkBMP.Width;
     if sCent.y>WorkBMP.Height then sCent.y:=WorkBMP.Height;
  end;

end;

procedure TALCustomZoomImage.Paint;
var tps: tagPAINTSTRUCT;
    R  : TRect;
    s  : string;
    siz: TSize;
    Rgn: HRGN;
    w  : integer;
begin
  IF (not WorkBMP.Empty) and (not Loading) then begin
     beginpaint(BackBMP.Canvas.Handle,tps );
     Canvas.Lock;

     InitBackImage;
     CalculateRects;

     if Assigned(FBeforePaint) then
        FBeforePaint(Self,sCent.x,sCent.y,dRect);

     if FVisibleImage then
     begin
     SetStretchBltMode(BackBMP.Canvas.Handle, STRETCH_DELETESCANS);
     StretchBlt(BackBMP.Canvas.Handle,BMPOffset.x,BMPOffset.y,
             dRect.Right-dRect.Left,dRect.Bottom-dRect.Top,
             CopyBMP.Canvas.Handle,
             Round(sRect.x1),Round(sRect.y1),
             Round(sRect.x2-sRect.x1),Round(sRect.y2-sRect.y1),
             SRCCOPY);
     end;

     if SelrectVisible then begin
        BackBMP.Canvas.Brush.Style := bsClear;
        BackBMP.Canvas.Pen.Color   := clBlack;
        BackBMP.Canvas.Pen.Style   := psSolid;
        DrawShape(BackBMP.Canvas,dtRectangle,Point(SelRect.Left,SelRect.Top),
                       Point(SelRect.Right,SelRect.Bottom),pmNotXor);
        BackBMP.Canvas.Pen.Color   := clWhite;
        BackBMP.Canvas.Pen.Mode   := pmNotXor;
        with BackBMP.Canvas.Font do begin
             Name := 'Arial';
             Color:= clWhite;
             Size := 8;
        end;
        s := IntToStr(SelRect.Right-SelRect.Left)+'x'+IntToStr(SelRect.Bottom-SelRect.Top);
        siz:=BackBMP.Canvas.TextExtent(s);
        BackBMP.Canvas.TextOut(SelRect.Left,SelRect.Top,s);
     end;
     if not PasteBMP.Empty then begin
        R := PasteBMP.Canvas.ClipRect;
        R := Rect(0,0,Trunc(Zoom*PasteBMP.Width),Trunc(Zoom*PasteBMP.Height));
        OffsetRect(R,MovePt.x,MovePt.y);
        BackBMP.Canvas.StretchDraw(R,TGraphic(PasteBMP));
     end;
     if Grid.PixelGrid then DrawPixelGrid;
     if Grid.Visible then DrawGrid;
     if CentralCross then DrawCentralCross(BackBMP.Canvas,cPen);

     if Assigned(FAfterPaint) and not (csDestroying in ComponentState) then
        FAfterPaint(Self,sCent.x,sCent.y,dRect);

  end else begin
     InitBackImage;
  end;

     if FCircleWindow then begin
        Cls(Canvas,clBlack);
        if Width>Height
           then w:=Height div 2
           else w:=Width div 2;
        Rgn := CreateEllipticRgn((Width div 2)-w, (Height div 2)-w, (Width div 2)+w, (Height div 2)+w);
        SelectClipRgn(Canvas.Handle, Rgn);
        Canvas.Draw(0, 0, BackBMP);
     end else
        BitBlt(Canvas.Handle,0,0,Width,Height,
             BackBMP.Canvas.Handle,0,0,SRCCOPY);

     If oldCursorCross then DrawMouseCross(oldMovePt,pmNotXor);
     endpaint(BackBMP.Canvas.Handle,tps);
     Canvas.UnLock;

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
        jpgIMG.Free;
     end;
  except
    exit;
  end;
finally
  OrigBMP.Assign(WorkBMP);
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
    oldClipBoardAction : TClipBoardAction;
begin
Try
  BMP := TBitmap.Create;
  oldClipBoardAction := FClipBoardAction;
  if SelrectVisible then begin
  if oldClipBoardAction in [cbaScreen,cbaScreenSelected] then
     FClipBoardAction := cbaScreenSelected
  else
     FClipBoardAction := cbaSelected;
  end;
  Case FClipBoardAction of
  cbaTotal    : BMP.Assign(CopyBMP);
  cbaScreen   : begin
                  R := Canvas.ClipRect;
                  BMPResize(BMP,Width,Height);
                  BMP.canvas.CopyRect(R,Canvas,R);
                end;
  //BMP.Assign(BackBMP);
  cbaSelected : if SelRectVisible then begin
                  SelRectVisible := False;
                  R := Rect(Round(XToW(SelRect.Left+1)),Round(YToW(SelRect.Top+1)),
                                  Round(XToW(SelRect.Right-1)),Round(YToW(SelRect.Bottom-1)));
                  BMP.Width := R.Right - R.Left;
                  BMP.Height:= R.Bottom - R.Top;
                  BMP.canvas.CopyRect(Rect(0,0,BMP.Width,BMP.Height),CopyBMP.Canvas,R);
                end;
  cbaScreenSelected :
                if SelRectVisible then begin
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
                  BMP.canvas.CopyRect(Rect(0,0,BMP.Width,BMP.Height),CopyBMP.Canvas,FixRect);
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
  FClipBoardAction := oldClipBoardAction;
  invalidate;
end;
end;

procedure TALCustomZoomImage.CutToClipboard;
begin
  CopyToClipboard;
  if ClipboardAction = cbaSelected then
     FillRect(SelRect,clBlack)
  else
     FillRect(Rect(0,0,WorkBMP.Width,WorkBMP.Height),clBlack);
end;

    procedure TALCustomZoomImage.Draw_Grid(gRect: TRect2d; GridWidth: double;
                                           Scale: boolean);  // Distance between lines
    var
       kp,kp0: TPoint2d;
       vp,vp0: TPoint2d;
       x,y   : integer;
       n : double;
       sCorr: integer;
    begin
      kp := Point2d(gRect.x1,gRect.y1);
      vp := Point2d(gRect.x2,gRect.y2);
      sCorr:=-Grid.ScaleFont.Height+4;
      With BackBmp.Canvas do begin
           if Scale then begin
              Font.Assign(Grid.ScaleFont);
           end;

      n := 0;
      Brush.Style := bsClear;
      While kp.x<=vp.x do begin
            if Grid.FFix then begin
               x := Round(kp.x);
               y := Round(vp.y);
            end else begin
               x := XToS(kp.x);
               y := YToS(vp.y);
            end;
            if x>sCorr then begin
               MoveTo(x,sCorr);
               LineTo(x,y);
               if Scale and (n=0) then
                  TextOut(x,0,IntToStr(Trunc(kp.x)));
               n := n+GridWidth*Zoom;
               if n>32 then n:=0;
            end;
            kp.x:=kp.x+GridWidth;
      end;

      n := 0;
      Brush.Style := bsClear;
      While kp.y<=vp.y do begin
            if Grid.FFix then begin
               x := Round(vp.x);
               y := Round(kp.y);
            end else begin
               x := XToS(vp.x);
               y := YToS(kp.y);
            end;
            if y>sCorr then begin
               MoveTo(sCorr,y);
               LineTo(x,y);
               if Scale and (Trunc(n)=0) then
                  RotText(BackBmp.Canvas,0,y,IntToStr(Trunc(kp.y)),900);
               n := n+GridWidth*Zoom;
               if n>32 then n:=0;
            end;
            kp.y:=kp.y+GridWidth;
      end;
      end;
    end;

procedure TALCustomZoomImage.DrawGrid;
var
    R : TRect2d;
    scale : boolean;
begin
If Grid.Visible then
  With BackBmp.Canvas do begin

       if Grid.OnlyOnPaper or Grid.FFix then
          R := Rect2d(0,0,CopyBMP.Width,CopyBMP.Height)
       else
          R := Rect2d(Trunc(sRect.x1-1),Trunc(sRect.y1-1),Trunc(sRect.x2+1),Trunc(sRect.y2+1));

      if Scale then begin
         Brush.Assign(Grid.ScaleBrush);
//         Pen.Mode := pmNotXor;
         Rectangle(0,0,width,-Grid.ScaleFont.Height+4);
         Rectangle(0,0,-Grid.ScaleFont.Height+4,Height+4);
      end;

      Brush.Style := bsClear;
      Font.assign(Grid.ScaleFont);
      if (Zoom*Grid.SubGridDistance)>32 then begin
         Pen.Assign(Grid.SubGridPen);
         if Grid.PixelGrid and (Zoom>4) then Pen.Width := 2* Grid.SubGridPen.width
            else Pen.Width := Grid.GridPen.width;
         scale := (Zoom*Grid.SubGridDistance)>1;
         Font.color := clGray;
         Draw_Grid(R,Grid.SubGridDistance,Scale);
      end;
      if (Zoom*Grid.GridDistance)>12 then begin
         Pen.Assign(Grid.GridPen);
         Font.color := clYellow;
         Draw_Grid(R,Grid.GridDistance,True);
      end;

  end;


  if Zoom>20 then
  DrawPixelGrid;
end;

procedure TALCustomZoomImage.DrawPixelGrid;
var
    R : TRect2d;
    scale : boolean;
begin
If Grid.Visible then
  With BackBmp.Canvas do begin

       if Grid.OnlyOnPaper then
          R := Rect2d(0,0,CopyBMP.Width,CopyBMP.Height)
       else
          R := Rect2d(Trunc(sRect.x1-1),Trunc(sRect.y1-1),Trunc(sRect.x2+1),Trunc(sRect.y2+1));


      Pen.Assign(Grid.SubgridPen);
      Pen.Width := 1;

      Brush.Style := bsClear;
      Pen.Assign(Grid.GridPen);
      Rectangle(XToS(R.x1),YToS(R.y1),XToS(R.x2),YToS(R.y2));

      if (Zoom)>4 then begin
         Pen.Assign(Grid.SubGridPen);
         scale := (Zoom)>32;
         Draw_Grid(R,1,Scale);
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
  repaint;
end;

procedure TALCustomZoomImage.FitToScreen;
var dxy,sxy: double;
begin
if not WorkBMP.Empty then
Try
  dxy := Width/height;
  Sizes := Point(CopyBMP.Width,CopyBMP.Height);
  sxy   := Height/Width;
  sCent := Point2d(WorkBMP.Width/2,WorkBMP.Height/2);
  sxy := Sizes.x/Sizes.y;
  if (Sizes.x>0) and (Sizes.y>0) then
  if dxy<sxy then
     Zoom := 0.99*width/Sizes.x
  else
     Zoom := 0.99*Height/Sizes.y;
//  invalidate;
except
end;
end;

function TALCustomZoomImage.GetPixelColor(p: TPoint): TColor;
begin
  Result := WorkBMp.Canvas.Pixels[p.x,p.y];
end;

// Get RGB values from screen pixel
function TALCustomZoomImage.GetRGB(x, y: integer): TRGB24;
var co: TColor;
    wPoint : TPoint2d;
begin
  wPoint := ScreenToWorld(Point(x,y));
  co := CopyBMP.Canvas.Pixels[Trunc(wPoint.x),Trunc(wPoint.y)];
  With Result do begin
       R := GetRValue(co);
       B := GetBValue(co);
       G := GetGValue(co);
  end;
end;

procedure TALCustomZoomImage.MoveToCentrum(x, y: double);
begin
  sCent     := Point2d(x,y);
  invalidate;
end;

procedure TALCustomZoomImage.PasteFromClipboard;
begin
  if Clipboard.HasFormat(CF_PICTURE) then begin
    if Assigned(FChange) then FChange(Self);
    OrigBMP.Assign(Clipboard);
    OrigBMP.PixelFormat := pf24bit;
    RestoreOriginal;
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
  loading := True;
  WorkBMP.Assign(OrigBMP);
  CopyBMP.Assign(WorkBMP);
  if Fitting then FitToScreen;
  loading := False;
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

// Transform the Screen Coordinates to World Coordinates
function TALCustomZoomImage.SToW(p: TPoint): TPoint2d;
var Vec : TPoint2d;
begin
   Vec := Point2d(p.x-Width/2,p.y-Height/2);
   Vec := Elforgatas(Vec,Point2d(0,0),Rad(-FRotateAngle));
   Result := Point2d(Vec.x/Zoom+sCent.x,Vec.y/Zoom+sCent.y);
//  Result := Point2d(XToW(p.x),YToW(p.y));
end;

function TALCustomZoomImage.WorldRectToScreen(R: TRect): TRect;
begin
  Result := Rect(XToS(R.Left),YToS(R.Top),
                 XToS(R.Right),YToS(R.Bottom))
end;

// Transform the World Coordinates to Screen Coordinates
function TALCustomZoomImage.WToS(p: TPoint2d): TPoint;
var Vec : TPoint2d;
begin
   Vec := Point2d(p.x-sCent.x,p.y-sCent.y);
   Vec := Elforgatas(Vec,Point2d(0,0),Rad(FRotateAngle));
   Result := Point(Trunc(Zoom*Vec.x+Width/2),Trunc(Zoom*Vec.y+Height/2));
//  Result := Point(XToS(p.x),YToS(p.y));
end;

// world x to Screen x
function TALCustomZoomImage.XToS(x: double): integer;
begin
  Result := Round((Width/2) + Zoom*(x-newCent.x));
end;

// X coordinate on the CopyBMP from Screen x coordinate
function TALCustomZoomImage.XToW(x: integer): double;
begin
  Result := newCent.x + (x-(Width/2))/Zoom;
end;

// world y to Screen y
function TALCustomZoomImage.YToS(y: double): integer;
begin
  Result := Round((Height/2) + Zoom*(y-newCent.y));
end;

function TALCustomZoomImage.YToW(y: integer): double;
begin
  Result := {-0.5 + }newCent.y + (y-(Height/2))/Zoom;
end;

procedure TALCustomZoomImage.SetSelRectVisible(const Value: boolean);
begin
  FSelRectVisible := Value;
  EnablePopup(Value);
  invalidate;
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

procedure TALCustomZoomImage.SetRotateAngle(const Value: double);
begin
  FRotateAngle := Value;
  WorkBMP.PixelFormat := pf24bit;
  CopyBMP.Assign(WorkBMP);
  if Value<>0 then
     StretchBitmap.RotateIt(FRotateAngle);
  if Assigned(FChangeWindow) then
     FChangeWindow(Self,sCent.x,sCent.y,0,0,Zoom,0,0);
  Repaint;
end;

procedure TALCustomZoomImage.SetVisibleImage(const Value: boolean);
begin
  FVisibleImage := Value;
  invalidate;
end;

procedure TALCustomZoomImage.SetVisibleOverlay(const Value: boolean);
begin
  FVisibleOverlay := Value;
  invalidate;
end;

procedure TALCustomZoomImage.wChange(Sender: TObject);
begin
  RotateAngle := FRotateAngle;
end;

// Get the new centrum, from original centrum on the WorkBMP

function TALCustomZoomImage.ScreenToWorld(p: TPoint): TPoint2d;
begin
  Result := SToW(p);
end;

function TALCustomZoomImage.WorldToScreen(p: TPoint2d): TPoint;
begin
  Result := WToS(p);
end;

// Croping the selected image area
// Kivágja a kép kiválasztott részletét és ez lesz a kép: Ctrl+K
procedure TALCustomZoomImage.CropSelected;
var BMP: TBitmap;
    R  : TRect;
begin
  If SelRectVisible then begin
     SelRectVisible := False;
     Crop(CopyBMP,Rect(Round(XToW(SelRect.Left+1)),Round(YToW(SelRect.Top+1)),
        Round(XToW(SelRect.Right-1)),Round(YToW(SelRect.Bottom-1))));
     OrigBMP.Assign(CopyBMP);
     RestoreOriginal;
     FitToScreen;
  end;
(*
  if SelrectVisible then begin
  Try
     SelRectVisible := False;
     BMP := TBitmap.Create;
     R := Rect(Round(XToW(SelRect.Left+1)),Round(YToW(SelRect.Top+1)),
          Round(XToW(SelRect.Right-1)),Round(YToW(SelRect.Bottom-1)));
     BMP.Width := R.Right - R.Left;
     BMP.Height:= R.Bottom - R.Top;
     BMP.canvas.CopyRect(Rect(0,0,BMP.Width,BMP.Height),CopyBMP.Canvas,R);
  finally
     OrigBMP.Assign(BMP);
     RestoreOriginal;
  end;
  end;
*)
end;

procedure TALCustomZoomImage.SetFitting(const Value: boolean);
begin
  FFitting := Value;
  if Value then FitToScreen;
end;

procedure TALCustomZoomImage.ReDraw;
begin
  RotateAngle:=FRotateAngle;
end;

procedure TALCustomZoomImage.Transform(x, y, rot: double);
begin
  MoveWindow(x,y);
  RotateAngle := rot;
end;

procedure TALCustomZoomImage.MirrorHorizontal;
begin
  FlipHorizontal(WorkBMP);
  sCent := Point2d(WorkBMP.width-sCent.x,sCent.y);
  Redraw;
end;

procedure TALCustomZoomImage.MirrorVertical;
begin
  FlipVertical(WorkBMP);
  sCent := Point2d(sCent.x,WorkBMP.Height-sCent.y);
  Redraw;
end;

procedure TALCustomZoomImage.TurnLeft;
var R,yy: double;
    BMP: TBitmap;
begin
    WorkBMP.OnChange := nil;
    BMP := TBitmap.Create;
    BMP := CreateRotatedBitmap(WorkBMP,90,clBlack);
    sCent := Point2d(sCent.y,WorkBMP.width-sCent.x);
    WorkBMP.Assign(BMP);
    BMP.Free;
    WorkBMP.OnChange := wChange;
    ReDraw;
end;

procedure TALCustomZoomImage.TurnRight;
var R,yy: double;
    BMP: TBitmap;
begin
    WorkBMP.OnChange := nil;
    BMP := TBitmap.Create;
    BMP := CreateRotatedBitmap(WorkBMP,-90,clBlack);
    sCent := Point2d(WorkBMP.Height-sCent.y,sCent.x);
    WorkBMP.Assign(BMP);
    BMP.Free;
    WorkBMP.OnChange := wChange;
    ReDraw;
end;

procedure TALCustomZoomImage.SelRectToCentrum;
var dx,dy: integer;
begin
  dx := (Width - (SelRect.Right + SelRect.Left)) div 2;
  dy := (Height - (SelRect.Bottom + SelRect.Top)) div 2;
  OffsetRect(SelRect,dx,dy);
  invalidate;
end;

procedure TALCustomZoomImage.BlackAndWhite;
begin
  STAF_Imp.BlackAndWhite(WorkBMP);
  Redraw;
end;

procedure TALCustomZoomImage.Blur;
begin
  STAF_Imp.Blur(WorkBMP);
  Redraw;
end;

procedure TALCustomZoomImage.Contrast(Amount: Integer);
begin
  CopyBMP.Assign(WorkBMP);
  Contrastness(CopyBMP,Amount);
  WorkBMP.Assign(CopyBMP);
end;

procedure TALCustomZoomImage.Darkness(Amount: integer);
begin
  WorkBMP.Assign(OrigBMP);
  STAF_Imp.Darkness(WorkBMP,Amount);
  Redraw;
end;

procedure TALCustomZoomImage.Lightness(Amount: Integer);
begin
  WorkBMP.Assign(OrigBMP);
  STAF_Imp.Lightness(WorkBMP,Amount);
  Redraw;
end;

procedure TALCustomZoomImage.Negative;
begin
  STAF_Imp.Negative(WorkBMP);
  Redraw;
end;

procedure TALCustomZoomImage.Posterize(amount: integer);
begin
  STAF_Imp.Posterize(WorkBMP,Amount);
  Redraw;
end;

procedure TALCustomZoomImage.Saturation(Amount: Integer);
begin
  STAF_Imp.Saturation(WorkBMP,Amount);
  Redraw;
end;

procedure TALCustomZoomImage.Sepia(depth: byte);
begin
  STAF_Imp.Sepia(WorkBMP,depth);
  Redraw;
end;

procedure TALCustomZoomImage.Clear;
begin
  OrigBMP.Dormant;
  OrigBMP.FreeImage;
  OrigBMP.Width := 0;
  OrigBMP.Height := 0;
  RestoreOriginal;
end;

procedure TALCustomZoomImage.SetVB;
begin
                FRgbList.FR := False;
                FRgbList.FG := False;
                FRgbList.FB := True;
                SetRGBList(FRgbList);
end;

procedure TALCustomZoomImage.SetVG;
begin
                FRgbList.FR := False;
                FRgbList.FG := True;
                FRgbList.FB := False;
                SetRGBList(FRgbList);
end;

procedure TALCustomZoomImage.SetVR;
begin
                FRgbList.FR := True;
                FRgbList.FG := False;
                FRgbList.FB := False;
                SetRGBList(FRgbList);
end;

procedure TALCustomZoomImage.SetVRGB;
begin
                FRgbList.FRGB := True;
                SetRGBList(FRgbList);
end;

{ TALImageSource }

constructor TALImageSource.Create(AOwner: TComponent);
begin
  inherited;
  OrigBMP        := TBitmap.Create;
  WorkBMP        := TBitmap.Create;
  CopyBMP        := TBitmap.Create;
//  RGBList        := TRGBChanel.Create;
//  RGBList.FOnChange := Change;
end;

destructor TALImageSource.Destroy;
begin
  OrigBMP.Free;
  WorkBMP.Free;
  CopyBMP.Free;
//  RGBList.Free;
  inherited;
end;

procedure TALImageSource.SetFileName(const Value: TFileName);
begin
  If FFileName <> Value then begin
     if LoadFromFile(Value) then
        FFileName := Value;
  end;
end;

function TALImageSource.LoadFromFile(FileName: TFileName): boolean;
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
        if jpgIMG<>nil then jpgIMG.Free;
     end;
  except
    if jpgIMG<>nil then jpgIMG.Free;
    exit;
  end;
finally
  WorkBMP.Assign(OrigBMP);
  FFilename := FileName;
  Result := True;
  Loading := False;
end;
end;

procedure TALImageSource.New(nWidth, nHeight: integer; nColor: TColor);
begin
  OrigBMP.Width := nWidth;
  OrigBMP.Height := nHeight;
  Cls(OrigBMP.Canvas,nColor);
  WorkBMP.Assign(OrigBMP);
end;

function TALImageSource.SaveToFile(FileName: TFileName): boolean;
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
        if jpgIMG<>nil then jpgIMG.Free;
     end;
  except
    if jpgIMG<>nil then jpgIMG.Free;
    exit;
  end;
finally
  OrigBMP.Assign(WorkBMP);
  Result := True;
  Loading := False;
end;
end;

procedure TALImageSource.SetRGBList(const Value: TRGBChanel);
begin
  FRGBList := Value;
  RestoreOriginal;
  ChangeRGBChanel(WorkBMP,FRGBList.MonoRGB,FRGBList.FR,FRGBList.FG,FRGBList.FB);
end;

procedure TALImageSource.RestoreOriginal;
begin
  WorkBMP.Assign(OrigBMP);
end;

procedure TALImageSource.SaveAsOriginal;
begin
  OrigBMP.Assign(WorkBMP);
end;

procedure TALImageSource.Change(Sender: TObject);
begin
//  IF Sender = RGBList then
//     RGBList := RGBList;
end;

{ TALCustomImageView }

procedure TALCustomImageView.CalculateRects;
var w,h : double;
begin
  Sizes := Point(ImageSource.WorkBMP.Width,ImageSource.WorkBMP.Height);

  // sCent need to be on the source bitmap
  w := width/(2*Zoom);
  h := height/(2*Zoom);

  if not OverMove then begin
     if sCent.x<0 then sCent.x:=0;
     if sCent.y<0 then sCent.y:=0;
     if sCent.x>Sizes.x then sCent.x:=Sizes.x;
     if sCent.y>Sizes.y then sCent.y:=Sizes.y;
  end;
(*   else begin
     if sCent.x<w then sCent.x:=w;
     if sCent.y<h then sCent.y:=h;
     if sCent.x>Sizes.x-w then sCent.x:=Sizes.x-w;
     if sCent.y>Sizes.y-h then sCent.y:=Sizes.y-h;
  end;*)

  // Calculate the rect of the source window to view
  sRect := Rect2d(Round(sCent.x-w-1),Round(sCent.y-h-1),
                  Round(sCent.x+w+1),Round(sCent.y+h+1));
  dRect := Rect(XToS(sRect.x1),YToS(sRect.y1),
                XToS(sRect.x2),YToS(sRect.y2));
  BMPOffset := Point(dRect.left,dRect.top);
end;

procedure TALCustomImageView.Change(Sender: TObject);
begin
  IF Sender = RGBList then
     RGBList := RGBList;
  invalidate;
end;

procedure TALCustomImageView.Click;
begin
  inherited;

end;

procedure TALCustomImageView.CMMouseEnter(var msg: TMessage);
begin

end;

procedure TALCustomImageView.CMMouseLeave(var msg: TMessage);
begin

end;

procedure TALCustomImageView.CopyToClipboard;
begin

end;

constructor TALCustomImageView.Create(AOwner: TComponent);
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
//  RGBList.OnChange := Change;
  CentralCross   := True;
  BackColor      := clSilver;
  BMPOffset      := Point(0,0);
  fZoom          := 1.0;
  fOverMove      := True;
  fCursorCross   := True;
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
  Width          := 100;
  Height         := 100;
  InitSelWindow;
  FEnableSelect  := True;
  FEnableActions := True;
  AutoPopup      := True;
end;

destructor TALCustomImageView.Destroy;
begin
  BackBMP.Free;
  PasteBMP.Free;
  cPen.Free;
  Grid.Free;
  RGBList.Free;
  timer.free;
  inherited;
end;

procedure TALCustomImageView.CutToClipboard;
begin

end;

procedure TALCustomImageView.DblClick;
begin
  inherited;

end;

function TALCustomImageView.DoMouseWheel(Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint): Boolean;
begin

end;

function TALCustomImageView.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin

end;

function TALCustomImageView.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin

end;

procedure TALCustomImageView.DrawGrid;
begin

end;

procedure TALCustomImageView.DrawMouseCross(o: TPoint; PenMode: TPenMode);
begin

end;

procedure TALCustomImageView.DrawPixelGrid;
begin

end;

procedure TALCustomImageView.EnablePopup(en: boolean);
begin

end;

procedure TALCustomImageView.FadeOut(Pause: Integer);
begin

end;

procedure TALCustomImageView.FillRect(R: TRect; co: TColor);
begin

end;

procedure TALCustomImageView.FitToScreen;
begin

end;

function TALCustomImageView.GetPixelColor(p: TPoint): TColor;
begin

end;

function TALCustomImageView.GetRGB(x, y: integer): TRGB24;
begin

end;

procedure TALCustomImageView.InitBackImage;
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

procedure TALCustomImageView.InitSelWindow;
begin

end;

procedure TALCustomImageView.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;

end;

procedure TALCustomImageView.KeyPress(var Key: Char);
begin
  inherited;

end;

function TALCustomImageView.LoadFromFile(FileName: TFileName): boolean;
begin

end;

procedure TALCustomImageView.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;

end;

procedure TALCustomImageView.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;

end;

procedure TALCustomImageView.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;

end;

procedure TALCustomImageView.MoveToCentrum(x, y: double);
begin

end;

procedure TALCustomImageView.MoveWindow(x, y: double);
var pCent : TPoint2d;
begin
//  pCent     := Elforgatas(Point2d(x,y),Point2d(0,0),Rad(-RotateAngle));
  sCent     := Point2d(sCent.x-pCent.x, sCent.y-pCent.y);
  if Assigned(FChangeWindow) then
     FChangeWindow(Self,sCent.x,sCent.y,0,0,Zoom,0,0);
  invalidate;
end;

procedure TALCustomImageView.New(nWidth, nHeight: integer; nColor: TColor);
begin

end;

procedure TALCustomImageView.OnTimer(Sender: TObject);
begin

end;

procedure TALCustomImageView.Paint;
var tps: tagPAINTSTRUCT;
    R  : TRect;
begin
Try
if ImageSource<>nil then begin
  IF (not ImageSource.WorkBMP.Empty) and (not Loading) then begin
     beginpaint(Canvas.Handle,tps );

     InitBackImage;
     CalculateRects;

     if Assigned(FBeforePaint) then
        FBeforePaint(Self,sCent.x,sCent.y,dRect);

     SetStretchBltMode(BackBMP.Canvas.Handle, STRETCH_DELETESCANS);
     StretchBlt(BackBMP.Canvas.Handle,BMPOffset.x,BMPOffset.y,
             dRect.Right-dRect.Left,dRect.Bottom-dRect.Top,
             ImageSource.WorkBMP.Canvas.Handle,
             Round(sRect.x1),Round(sRect.y1),
             Round(sRect.x2-sRect.x1),Round(sRect.y2-sRect.y1),
             SRCCOPY);

     endpaint(Canvas.Handle,tps);
  end else begin
     InitBackImage;
  end;
  end else begin
     InitBackImage;
     inherited Paint;
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

     if Assigned(FAfterPaint) then
        FAfterPaint(Self,sCent.x,sCent.y,dRect);

     BitBlt(Canvas.Handle,0,0,Width,Height,
             BackBMP.Canvas.Handle,0,0,SRCCOPY);

     If oldCursorCross then DrawMouseCross(oldMovePt,pmNotXor);

end;
end;

procedure TALCustomImageView.PasteFromClipboard;
begin

end;

procedure TALCustomImageView.PasteSpecial;
begin

end;

procedure TALCustomImageView.pChange(Sender: TObject);
begin

end;

procedure TALCustomImageView.PixelToCentrum(x, y: integer);
begin

end;

procedure TALCustomImageView.RestoreOriginal;
begin

end;

procedure TALCustomImageView.SaveAsOriginal;
begin

end;

function TALCustomImageView.SaveToFile(FileName: TFileName): boolean;
begin

end;

function TALCustomImageView.ScreenRectToWorld(R: TRect): TRect;
begin

end;

procedure TALCustomImageView.SelToScreen;
begin

end;

procedure TALCustomImageView.SetBackColor(const Value: TColor);
begin

end;

procedure TALCustomImageView.SetBackCross(const Value: boolean);
begin

end;

procedure TALCustomImageView.SetBulbRadius(const Value: integer);
begin

end;

procedure TALCustomImageView.SetCentered(const Value: boolean);
begin

end;

procedure TALCustomImageView.SetCentralCross(const Value: boolean);
begin

end;

procedure TALCustomImageView.SetCursorCross(const Value: boolean);
begin

end;

procedure TALCustomImageView.SetFileName(const Value: TFileName);
begin

end;

procedure TALCustomImageView.SetImageSource(const Value: TALImageSource);
begin
  FImageSource := Value;
  invalidate;
end;

procedure TALCustomImageView.SetOverMove(const Value: boolean);
begin

end;

procedure TALCustomImageView.SetPixelColor(p: TPoint; Co: TColor);
begin

end;

procedure TALCustomImageView.SetPixelGrid(const Value: boolean);
begin

end;

procedure TALCustomImageView.SetRGBList(const Value: TRGBChanel);
begin

end;

procedure TALCustomImageView.SetSelRectVisible(const Value: boolean);
begin

end;

procedure TALCustomImageView.SetZoom(const Value: extended);
begin
if FImageSource<>nil then
  if fZoom <> Value then begin
     // Limited zoom
     Sizes := Point(FImageSource.WorkBMP.Width,FImageSource.WorkBMP.Height);
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

procedure TALCustomImageView.ShiftWindow(x, y: double);
begin

end;

procedure TALCustomImageView.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin

end;

procedure TALCustomImageView.WMSize(var Msg: TWMSize);
begin

end;

function TALCustomImageView.WorldRectToScreen(R: TRect): TRect;
begin

end;

function TALCustomImageView.WToS(p: TPoint2d): TPoint;
begin
  Result := Point(XToS(p.x),YToS(p.y));
end;

function TALCustomImageView.XToS(x: double): integer;
begin
  Result := Round((Width/2) + Zoom*(x-newCent.x));
end;

function TALCustomImageView.XToW(x: integer): double;
begin
  Result := newCent.x + (x-(Width/2))/Zoom;
end;

function TALCustomImageView.YToS(y: double): integer;
begin
  Result := Round((Height/2) + Zoom*(y-newCent.y));
end;

function TALCustomImageView.YToW(y: integer): double;
begin
  Result := {-0.5 + }newCent.y + (y-(Height/2))/Zoom;
end;

procedure TALCustomImageView.wChange(Sender: TObject);
begin
//  RotateAngle := FRotateAngle;
end;

function TALCustomImageView.SToW(p: TPoint): TPoint2d;
begin
  Result := Point2d(XToW(p.x),YToW(p.y));
end;

{ TALCustomRGBDiagram }

constructor TALCustomRGBDiagram.Create(AOwner: TComponent);
begin
  inherited;
  BMP:= TBitmap.Create;
  rgbMax.R := 0;
  rgbMax.G := 0;
  rgbMax.B := 0;
  FBackColor  := clWhite;
  FDotVisible := False;
  FPenWidth   := 1;
  FRColor := True;
  FGColor := True;
  FBColor := True;
  FRGBColor := False;
  Width   := 100;
  Height  := 100;
end;

destructor TALCustomRGBDiagram.Destroy;
begin
  BMP.Free;
  inherited;
end;

procedure TALCustomRGBDiagram.DrawGraph(SourceBMP: TBitmap;x,y,PixelWidth: integer);
// RGB Grafikon rajzolása
var i,x0,n,w,h: integer;
    dx: double;
    co: byte;
    szin: TColor;
    pixColor : TColor;
    xx,yy: integer;      // koordináta pontok a grafikonon
    Row: pPixelArray;
    lin: boolean;
begin
Try
  with BMP.Canvas do begin
       Brush.Color := FBackColor;
       FillRect(Cliprect);
       w := Cliprect.Right-Cliprect.Left;
       h := Cliprect.Bottom-Cliprect.Top;

       // koordináta vonalak és feliratok
       Pen.Color := clSilver;
       for i:=0 to 5 do begin
           yy := Round(h*(1-(50*i/255)));
           MoveTo(0,yy);
           LineTo(w,yy);
       end;
       Font.Name := 'Arial';
       Font.Size := 6;
       yy := Round(H*(1-(100/255)));
       TextOut(W div 2,yy,'100');
       yy := Round(H*(1-(200/255)));
       TextOut(W div 2,yy,'200');
       Pen.Color := clSilver;
       MoveTo(W div 2,0);
       LineTo(W div 2,H);

       if (SourceBMP<>nil) then begin

       if  FAlignToImage then begin
       x0 := x-PixelWidth;    // Eredeti képen a kezdõpont x
       n  := 2*PixelWidth+1;  // n darab pixelt kell vizsgálni
       dx := W/(2*PixelWidth+1);
       end else begin
       x0 := x-PixelWidth*Trunc(w/FZoomImage.Width);    // Eredeti képen a kezdõpont x
       n  := 2*PixelWidth*Trunc(w/FZoomImage.Width)+1;  // n darab pixelt kell vizsgálni
       dx := W/(2*PixelWidth+1);
       end;

       { Diagram rajzolás }
       Pen.Width := FPenWidth;
       for szin := 0 to 3 do begin

//           Application.ProcessMessages;

           Case szin of
           0: Pen.Color := clRed;
           1: Pen.Color := clGreen;
           2: Pen.Color := clBlue;
           3: begin
              Pen.Color := clBlack;
              Pen.Width := 2;
              end;
           end;

           if FRGBStatistic then begin
              i := Pen.Width;
              Pen.Width := 2;
           Case szin of
           0: begin
              yy := H-Trunc(H*(rgbMax.R/255));
              MoveTo(0,yy); LineTo(w,yy);
              end;
           1: begin
              yy := H-Trunc(H*(rgbMax.G/255));
              MoveTo(0,yy); LineTo(w,yy);
              end;
           2: begin
              yy := H-Trunc(H*(rgbMax.B/255));
              MoveTo(0,yy); LineTo(w,yy);
              end;
           end;
              Pen.Width := i; 
           end;

           IF ((szin=0) and RColor) or ((szin=1) and GColor) or
              ((szin=2) and BColor) or ((szin=3) and RGBColor)
              then
           if (y>-1) and (y<SourceBMP.Height-1) then begin

              Row:=SourceBMP.ScanLine[y];
              lin := True;

              for i:=0 to n-1 do
              With Row[x0+i] DO
              begin

//                   Application.ProcessMessages;

                   if ((x0+i)>-1) and ((x0+i)<SourceBMP.Width-1) then begin

                   Case szin of
                   0: co := rgbtRed;
                   1: co := rgbtGreen;
                   2: co := rgbtBlue;
                   end;
                   xx := Trunc( (dx/2)+i*dx );
                   if FRGBColor then begin
                      pixColor := RGB(rgbtRed,rgbtGreen,rgbtBlue);
                      yy := H-Trunc(H*(pixColor/(16581375)));
                   end
                   else
                      yy := H-Trunc(H*(co/255));
                   if FDotVisible then
                      ellipse(xx-2,yy-2,xx+2,yy+2);
                   if lin then begin
                      MoveTo(xx,yy);
                      lin := False;
                   end else
                      Lineto(xx,yy);

                   end;

              end;
           end;

       end;

       Pen.Color := clBlack;
       end;
  end;
finally
  Canvas.Draw(0,0,BMP);
end;
end;

(*
procedure TALCustomRGBDiagram.ImageChangeWindow(Sender: TObject; xCent,
  yCent, xWorld, yWorld, Zoom: double; MouseX, MouseY: integer);
begin
  Repaint;
     if FZoomImage<>nil then begin
     Try
        FZoomImage.OnChangeWindow := oldChangeWindow;
        FZoomImage.OnChangeWindow(Self,xCent,yCent,xWorld,yWorld,Zoom,MouseX,MouseY);
        FZoomImage.OnChangeWindow := ImageChangeWindow;
     except
        exit;
     End;
     end;
  inherited;
end;

procedure TALCustomRGBDiagram.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//  FixLine := not FixLine;
  MouseX:=x; MouseY:=y;
  Repaint;
     if FZoomImage<>nil then begin
        FZoomImage.OnMouseDown := oldMouseDown;
        FZoomImage.MouseDown(Button,Shift,x,y);
        FZoomImage.OnMouseDown := ImageMouseDown;
     end;
  inherited;
end;

procedure TALCustomRGBDiagram.ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
     MouseY:=y;
     MouseX:=x;

     if FZoomImage<>nil then begin
        FZoomImage.OnMouseMove := oldMouseMove;
        FZoomImage.MouseMove(Shift,x,y);
        FZoomImage.OnMouseMove := ImageMouseMove;
        Repaint;
     end;

     inherited;
end;
*)

procedure TALCustomRGBDiagram.Paint;
begin
if FZoomImage<>nil then begin
  BMP.Width := Width;
  BMP.Height := Height;
  if FixLine then
     MouseY:=FZoomImage.Height div 2;
     DrawGraph(FZoomImage.CopyBMP,Round(FZoomImage.XToW(WIDTH div 2)),
                                   Round(FZoomImage.YToW(MouseY)),
                                   Round(WIDTH/(2*FZoomImage.Zoom)));
  Canvas.MoveTo(MouseX,0);
  Canvas.LineTo(MouseX,Height);
  FZoomImage.Repaint;
end else
  DrawGraph(nil,0,0,0);
  inherited;
end;

procedure TALCustomRGBDiagram.ReadRGBStatistic;
begin
  rgbMax := GetRGBStatisticMax(fZoomImage.WorkBMP);
end;

procedure TALCustomRGBDiagram.ReDraw(x, y: integer);
begin
  MouseX := x;
  MouseY := y;
  Repaint;
end;

procedure TALCustomRGBDiagram.Resize;
begin
  BMP.Width := Width;
  BMP.Height := Height;
  inherited;
end;

procedure TALCustomRGBDiagram.SetAlignToImage(const Value: boolean);
begin
  FAlignToImage := Value;
  invalidate;
end;

procedure TALCustomRGBDiagram.SetBackColor(const Value: TColor);
begin
  FBackColor := Value;
  invalidate;
end;

procedure TALCustomRGBDiagram.SetBColor(const Value: boolean);
begin
  FBColor := Value;
  invalidate;
end;

procedure TALCustomRGBDiagram.SetDotVisible(const Value: boolean);
begin
  FDotVisible := Value;
  invalidate;
end;

procedure TALCustomRGBDiagram.SetGColor(const Value: boolean);
begin
  FGColor := Value;
  invalidate;
end;

procedure TALCustomRGBDiagram.SetPenWidth(const Value: integer);
begin
  FPenWidth := Value;
  invalidate;
end;

procedure TALCustomRGBDiagram.SetRColor(const Value: boolean);
begin
  FRColor := Value;
  invalidate;
end;

procedure TALCustomRGBDiagram.SetRGBColor(const Value: boolean);
begin
  FRGBColor := Value;
  invalidate;
end;

procedure TALCustomRGBDiagram.SetRGBStatistic(const Value: boolean);
begin
  FRGBStatistic := Value;
  if Value then ReadRGBStatistic;
  invalidate;
end;

procedure TALCustomRGBDiagram.SetZoomImage(const Value: TALCustomZoomImage);
begin
  FZoomImage := Value;
(*
  if FZoomImage<>nil then begin
     oldMouseDown := FZoomImage.OnMouseDown;
     oldMouseMove := FZoomImage.OnMouseMove;
     oldChangeWindow := FZoomImage.OnChangeWindow;
     FZoomImage.OnMouseDown := ImageMouseDown;
     FZoomImage.OnMouseMove := ImageMouseMove;
     FZoomImage.OnChangeWindow := ImageChangeWindow;
  end;
*)
end;

procedure TALCustomRGBDiagram.WMChange(var Msg: TMessage);
begin
   if ZoomImage<>nil then begin
      Repaint;
   end;
  inherited;
end;

procedure TALCustomRGBDiagram.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1
end;

procedure TALCustomRGBDiagram.WMMouseMove(var Msg: TMessage);
begin
   if ZoomImage<>nil then begin
      Repaint;
   end;
  inherited;
end;

{ TALCustomRGBDiagram3D }

constructor TALCustomRGBDiagram3D.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TALCustomRGBDiagram3D.Destroy;
begin
  inherited;

end;

procedure TALCustomRGBDiagram3D.DrawGraph(SourceBMP: TBitmap; x, y,
  PixelWidth: integer);
begin

end;

procedure TALCustomRGBDiagram3D.Paint;
begin
  inherited;
end;

procedure TALCustomRGBDiagram3D.SetBackColor(const Value: TColor);
begin
  FBackColor := Value;
end;

procedure TALCustomRGBDiagram3D.SetZoomImage(
  const Value: TALCustomZoomImage);
begin
  FZoomImage := Value;
end;

(*
{ TALCustomAstroImage }

constructor TALCustomAstroImage.Create(AOwner: TComponent);
begin
  inherited;
  StarList := TStarList.Create;
  FStarBrush := TBrush.Create;
  with FStarBrush do begin
       Color := clLime;
       Style := bsClear;
  end;
end;

destructor TALCustomAstroImage.Destroy;
begin
  FStarBrush.Free;
  StarList.Free;
  inherited;
end;

function TALCustomAstroImage.StarDetect: integer;
begin
  result := AutomaticStarDetection(WorkBMP);
  invalidate;
end;

function TALCustomAstroImage.PrecizeStarDetect: integer;
begin

end;

procedure TALCustomAstroImage.SetImageVisible(const Value: boolean);
begin
  FImageVisible := Value;
  invalidate;
end;

procedure TALCustomAstroImage.SetStarBrush(const Value: TBrush);
begin
  FStarBrush := Value;
  invalidate;
end;

procedure TALCustomAstroImage.SetStarVisible(const Value: boolean);
begin
  FStarVisible := Value;
  invalidate;
end;
*)
end.

