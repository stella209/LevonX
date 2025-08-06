(*
    StellaSOFT objektumok gyüjteménye
    ---------------------------------
    TUndoRedo:      UndoRedo folyamatokat megvalósító objektum;

*)
unit StObjects;

interface

uses Winapi.Windows, System.Classes, System.SysUtils, VCL.Graphics, Vcl.Forms,
     Vcl.Controls, VCL.StdCtrls,  System.Math, NewGeom, Clipper, VCL.ClipBrd,
     System.Generics.Collections, B_Spline;


Type

  TFloat = Double;
  Str32 = string[32];
  TMarkType = (mtBox,mtCircle,mtCross);
  TMarkSize = 2..8;

  TActionMode = (amNone, amDrawing, amPaning, amZooming, amPainting, amSelect,
                 amInsertPoint, amDeletePoint, amMovePoint,amSelectPoint,
                 amChangePoint, amDeleteSelected, amMoveSelected, amRotateSelected,
                 amNewBeginPoint, amMagnifySelected,  amSelectArea, amSelectAreaEx,
                 amAutoPlan, amTestWorking, amOutherBegin, amSelectFrame,
                 // Egyenként rámutatok a sorban következõ objektumra
                 // amiket szépen sorba rendezünk az FCurveList-ben
                 amManualOrder, amMovePoints);

  TDrawMode = (dmNone, dmPoint, dmLine, dmRectangle, dmPolyline, dmPolygon,
               dmCircle, dmEllipse, dmArc, dmChord, dmSpline, dmBspline, dmText,
               dmFreeHand, dmBitmap, dmPath, dmCubicBezier, dmQuadraticBezier,
               dmRotRectangle, dmArrow );

  TInCode = (icIn,        // Cursor in Curve
             icOnLine,    // Cursor on Curve's line
             icOnPoint,   // Cursor is on any Point;
             icOut        // Cursor out of Curve
             );

  PPointRec = ^TPointRec;
  TPointRec = record
//             funccode: byte;
             X: TFloat;
             Y: TFloat;
             Selected: boolean;
           end;

  PPointArray = ^TPointArray;
  TPointArray = array[0..0] of TPoint;

  TMetric = (meMM,meInch);
  TGridStyle  = (gsNone,gsLine,gsDot,gsCross);

  TNewGraphData = record //Graphstructur for SaveGraphToFile/LoadGraphFromFile
    Copyright   : Str32;
    Version     : integer;
    GraphTitle  : Str32;
    Curves      : integer;
    Dummy       : Array[1..128] of byte;
  end;

  TNewCurveData = record //Datenstruktur für SaveCurveToStream/LoadCurveFromStream
    ID       : Integer;
    Name     : Str32;
    Shape    : TDrawMode;
    Layer    : byte;
    Font     : TFont;
    Selected : Boolean;
    Enabled  : Boolean;
    Visible  : Boolean;
    Closed   : boolean;
    Angle    : TFloat;
    Points   : Integer;
  end;

  TCurveData = record //Datenstruktur für SaveCurveToStream/LoadCurveFromStream
    Name: Str32;
    Enabled: Boolean;
    Color: TColor;
    LineWidth: Byte;
    PenStyle: TPenStyle;
    Points: Integer;
    Closed: boolean;
    Texts: Integer;
    Marks: Integer;
    XOfs: TFloat;
    YOfs: TFloat;
    FontName: Str32;
    FontSize: Integer;
    FontStyle: TFontStyles;
    MarkSize: TMarkSize;
  end;

  TGraphData = record //Datenstruktur für SaveGraphToFile/LoadGraphFromFile
    GraphTitle: Str32;
    Zoom: TFloat;
    MaxZoom: TFloat;
    Curves: Integer;
  end;

  {Gyártási pozíció}
  TWorkPosition = record
    CuvNumber   : integer;      {Aktuális obj. sorszáma}
    PointNumber : integer;      {Aktuális pont sorszáma}
    WorkPoint   : TPoint2d;    {Aktuális pont koordinátái}
  end;

  { Polygon metszések vizsgálatához}
  TmpRec = record
       Cuvidx   : integer;   // Polygon sorszáma
       Pointidx : integer;   // legközelebbi pontjának sorszáma
       d        : double;    // Távolsága
  end;

  PPointRec3d = ^TPointRec3d;
  TPointRec3d = record
             X: TFloat;
             Y: TFloat;
             Z: TFloat;
             R: TFloat;
             RotAngle_X: TFloat;
             RotAngle_Y: TFloat;
             RotAngle_Z: TFloat;
             RotX,RotY,RotZ : TFloat;
             ScaleX,ScaleY,ScaleZ: TFloat;
             Selected: boolean;
           end;

  {Síkbeli pont objektum}
  TPoint2dObj = Class(TPersistent)
  private
    fx,fy : extended;
    FOnChange: TNotifyEvent;
    procedure Setx(Value:extended);
    procedure Sety(Value:extended);
    procedure Changed; dynamic;
  public
    constructor Create;
  published
    property x:extended read fx write Setx;
    property y:extended read fy write Sety;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  T2DPoint = class(TPersistent)
  private
    FOnChange: TNotifyEvent;
    Fx : extended;
    Fy : extended;
    FID: integer;
    procedure Setx(Value:extended);
    procedure Sety(Value:extended);
    procedure Changed; dynamic;
  public
    constructor Create(AOwner:TObject; px,py: extended);
  published
    property ID          : integer  read FID write FID;
    property x           : extended read Fx write Setx;
    property y           : extended read Fy write Sety;
    property OnChange    : TNotifyEvent read FOnChange write FOnChange;
  end;

  T3DPoint = class(TPersistent)
  private
    FOnChange: TNotifyEvent;
    FID: integer;
    Fx : extended;
    Fy : extended;
    Fz : extended;
    procedure Changed; dynamic;
    procedure Setx(Value:extended);
    procedure Sety(Value:extended);
    procedure Setz(const Value: extended);
  public
    constructor Create(AOwner:TObject; px,py,pz: extended);
  published
    property ID          : integer  read FID write FID;
    property x           : extended read Fx write Setx;
    property y           : extended read Fy write Sety;
    property z           : extended read Fz write Setz;
    property OnChange    : TNotifyEvent read FOnChange write FOnChange;
  end;

  TUndoRedoChangeEvent = procedure(Sender:TObject; Undo,Redo:boolean) of object;
  TUndoSaveEvent = procedure(Sender:TObject; MemSt:TMemoryStream) of object;
  TUndoSaveProcedure = procedure(var MemSt:TMemoryStream) of object;
  TUndoRedoProcedure = procedure(MemSt:TMemoryStream) of object;

  {---- UndoRedo objektum -----}
  TUndoRedo = class
  private
    fEnable: boolean;
    fUndoLimit: integer;
    FUndoRedo:TUndoRedoChangeEvent;
    FUndoSave: TUndoSaveEvent;
    fUndoSaveProcedure: TUndoSaveProcedure;
    fUndoRedoProcedure: TUndoRedoProcedure;
    procedure SetUndoLimit(const Value: integer);
    procedure SetEnable(const Value: boolean);
  protected
    UndoSaveCount : integer;
    UndoCount     : integer;
    UndoStart     : integer;
    UndoPointer   : integer;
    UndoEnable,RedoEnable : boolean;
    function GetIndex(us:integer): integer;
  public
    UndoStreams   : array[0..999] of TMemoryStream;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure UndoInit;
    procedure UndoSave;
    procedure Undo;
    procedure Redo;
    property Enable : boolean read fEnable write SetEnable;
    property UndoLimit : integer read fUndoLimit write SetUndoLimit;
    property UndoSaveProcedure: TUndoSaveProcedure read fUndoSaveProcedure write fUndoSaveProcedure;
    property UndoRedoProcedure: TUndoRedoProcedure read fUndoRedoProcedure write fUndoRedoProcedure;
    property OnUndoRedo : TUndoRedoChangeEvent read FUndoRedo write FUndoRedo;
    property OnUndoSave : TUndoSaveEvent read FUndoSave write FUndoSave;
  end;

   THRTimer = Class(TObject)
     Constructor Create;
     Function StartTimer : Boolean;
     Function ReadTimer : Double;
   private
   public
     Exists    : Boolean;
     StartTime : Double;
     ClockRate : Double;
     PROCEDURE Delay(ms: double);
   End;

  TLayerName = String[30];

  TLayer = class(TPersistent)
  private
    fVisible: Boolean;
    fHomogen: Boolean;
    fModified: Boolean;
    fActive: Boolean;
    fTag: LongInt;
    FNote: string;
    fBrush: TBrush;
    fName: TLayerName;
    fPen: TPen;
    fLayerId: Byte;
    procedure SetBrush(const Value: TBrush);
    procedure SetName(const Value: TLayerName);
    procedure SetPen(const Value: TPen);
  published
    constructor Create(Idx: Byte);
    destructor Destroy; override;
    procedure SaveToStream(const Stream: TStream); virtual;
    procedure LoadFromStream(const Stream: TStream); virtual;
    property Name: TLayerName read fName write SetName;
    property LayerID: Byte read fLayerId;
    property Pen: TPen read fPen write SetPen;
    property Brush: TBrush read fBrush write SetBrush;
    property Active: Boolean read fActive write FActive;
    property Modified: Boolean read fModified;
    property Homogen: Boolean read fHomogen write fHomogen;
    property Visible: Boolean read fVisible write fVisible;
    property Note: string read FNote write fNote;
    property Tag: LongInt read fTag write fTag;
  end;

  TGrid = Class(TPersistent)
  private
    fVisible: boolean;
    fGridStyle: TGridStyle;
    fSubGridColor: TColor;
    fMainGridColor: TColor;
    FOnChange: TNotifyEvent;
    fMetric: TMetric;
    fMargin: integer;
    fOnlyOnPaper: boolean;
    FAligne: boolean;
    FSubDistance: integer;
    procedure SetMainGridColor(Value: TColor);
    procedure SetGridStyle(const Value: TGridStyle);
    procedure SetSubGridColor(Value: TColor);
    procedure SetVisible(const Value: boolean);
    procedure Changed;
    procedure SetMetric(const Value: TMetric);
    procedure SetMargin(const Value: integer);
    procedure SetOnlyOnPaper(const Value: boolean);
    procedure SetAligne(const Value: boolean);
    procedure SetSubDistance(const Value: integer);
  protected
  public
    constructor Create;
    procedure Change(Sender: TObject);
  published
    property Aligne: boolean read FAligne write SetAligne;
    property MainGridColor: TColor read fMainGridColor write SetMainGridColor;
    property Margin: integer read fMargin write SetMargin;
    property SubDistance: integer read FSubDistance write SetSubDistance default 1;
    property SubGridColor: TColor read fSubGridColor write SetSubGridColor;
    property Style: TGridStyle read fGridStyle write SetGridStyle default gsNone;
    property Metric: TMetric read fMetric write SetMetric default meMM;
    property Visible: boolean read fVisible write SetVisible default True;
    property OnlyOnPaper: boolean read fOnlyOnPaper write SetOnlyOnPaper default True;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TDXFOut = class(TPersistent)
  private
    FromXMin: TFloat;
    FromXMax: TFloat;
    FromYMin: TFloat;
    FromYMax: TFloat;
    ToXMin: TFloat;
    ToXMax: TFloat;
    ToYMin: TFloat;
    ToYMax: TFloat;
    TextHeight: TFloat;
    Decimals: Byte;
    LayerName: Str32;
  public
    StringList: TStringList;
    constructor Create(AFromXMin,AFromYMin,AFromXMax,AFromYMax,AToXMin,AToYMin,
                       AToXMax,AToYMax,ATextHeight: TFloat; ADecimals: Byte);
    destructor Destroy; override;
//    procedure SaveToFile(fn: string);
    function FToA(F: TFloat): Str32;
    function ToX(X: TFloat): TFloat;
    function ToY(Y: TFloat): TFloat;
    procedure Header;
    procedure Trailer;
    procedure SetLayer(const Name: Str32);
    procedure Line(X1,Y1,Z1,X2,Y2,Z2: TFloat);
    procedure Point(X,Y,Z: TFloat);
    procedure StartPolyLine(Closed: Boolean);
    procedure Vertex(X,Y,Z: TFloat);
    procedure EndPolyLine;
    procedure DText(X,Y,Z,Height,Angle: TFloat; const Txt: Str32);
    procedure Layer;
    procedure StartPoint(X,Y,Z: TFloat);
    procedure EndPoint(X,Y,Z: TFloat);
    procedure AddText(const Txt: Str32);
  end;

  TALPaper = class(TPersistent)
  private
    FWidth: double;
    FColor: TColor;
    FBottom: double;
    fVisible: boolean;
    FOnChange: TNotifyEvent;
    FHeight: double;
    FLeft: double;
    fShadow: boolean;
    procedure Changed; dynamic;
    procedure SetBottom(const Value: double);
    procedure SetColor(const Value: TColor);
    procedure SetHeight(const Value: double);
    procedure SetLeft(const Value: double);
    procedure SetVisible(const Value: boolean);
    procedure SetWidth(const Value: double);
    procedure SetShadow(const Value: boolean);
  public
    constructor Create;
  published
    property Left        : double       read FLeft write SetLeft;
    property Bottom      : double       read FBottom write SetBottom;
    property Width       : double       read FWidth write SetWidth;
    property Height      : double       read FHeight write SetHeight;
    property Color       : TColor       read FColor write SetColor default clWhite;
    property Shadow      : boolean      read fShadow write SetShadow default True;
    property Visible     : boolean      read fVisible write SetVisible default True;
    property OnChange    : TNotifyEvent read FOnChange write FOnChange;
  end;

  TBMPObject = class(TPersistent)
  private
    fVisible: boolean;
    FOnChange: TNotifyEvent;
    FPosition: TPoint2dObj;
    FZoom: double;
    procedure Changed; dynamic;
    procedure SetVisible(const Value: boolean);
    function GetBoundsRect: TRect2d;
    procedure SetPosition(const Value: TPoint2dObj);
    procedure SetZoom(const Value: double);
  public
    origBMP  : TBitmap;
    BMP      : TBitmap;
    constructor Create;
    destructor Destroy; override;
    function LoadFromFile(fn: string): boolean;
    function PasteFromClipboard: boolean;
    procedure RestoreOriginal;
    procedure Clear;
    procedure Lightness( Amount: integer );
    property BoundsRect: TRect2d read GetBoundsRect;
  published
    property Position    : TPoint2dObj  read FPosition write SetPosition;       // Left & bottom
    property Visible     : boolean      read fVisible write SetVisible default True;
    property Zoom        : double       read FZoom write SetZoom;
    property OnChange    : TNotifyEvent read FOnChange write FOnChange;
  end;

  TCurve = class(TPersistent)
  private
    FID  : integer;
    FName: Str32;
    FEnabled: Boolean;
    PPoint: PPointRec;
    fClosed: boolean;
    fSelected: boolean;
    FVisible: Boolean;
    fShape: TDrawMode;
    FLayer: byte;
    FFont: TFont;
    FOnChange: TNotifyEvent;
    fAngle: TFloat;
    FParentID: integer;
    FSorted: boolean;
    fSigned: boolean;
    fOutBase: boolean;
//    FContourRadius: double;
    FVisibleContour: Boolean;
    FContourRadius: double;
    FLineWidth: integer;
    FLineColor: TColor;
    FText: string;
    fCrossed: boolean;
    procedure Changed(Sender: TObject); dynamic;
    procedure SetSelected(const Value: boolean);
    procedure SetShape(const Value: TDrawMode);
    procedure SetLayer(const Value: byte);
    procedure SetFont(const Value: TFont);
    procedure SetClosed(const Value: boolean);
    procedure SetEnabled(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
    procedure SetName(const Value: Str32);
    procedure SetAngle(const Value: TFloat);
    function GetPointArray(AIndex: integer): TPoint2d;
    procedure SetPoints(AIndex: integer; const Value: TPoint2d);
    function GetCount: integer;
    procedure SetPointRec(AIndex: integer; const Value: TPointRec);
    procedure SetOutBase(const Value: boolean);
    procedure SetContourRadius(const Value: double);
    function GetCenter: TPoint2d;
    function GetContourPoints(AIndex: integer): TPoint2d;
    procedure SetContourPoints(AIndex: integer; const Value: TPoint2d);
    procedure SetSigned(const Value: boolean);
    procedure SetCrossed(const Value: boolean);
    procedure SetSorted(const Value: boolean);
//    procedure SetVisibleContour(const Value: Boolean);
  public
    FPoints       : TList;          // List of Points
    CPIndex       : Integer;        // Matching point index
    PointsArray   : array of TPoint3d;
    TempCurve     : TCurve;
    Contour       : TCurve;
    FContour      : array of TPoint2d;     // Contour Curve
    Trans3d       : TPointRec3d;           // 3d transformáció
    oldTrans3d    : TPointRec3d;           // eredeti

    constructor Create;
    destructor Destroy; override;

    procedure InitTrans3d;
    procedure ClearPoints;
    procedure AddPoint(Ax,Ay: TFloat); overload;
    procedure AddPoint(P: TPoint2d); overload;
    procedure GetPoint(AIndex: Integer; var Ax,Ay: TFloat);
    function  GetPoint2d(AIndex: Integer): TPoint2d;
    function  GetPointRec(AIndex: Integer): TPointRec;
    function  LastPoint: TPoint2d;
    procedure ChangePoint(AIndex: Integer; Ax,Ay: TFloat); overload;
    procedure ChangePoint(AIndex: Integer; Ax, Ay: TFloat; Sel: boolean); overload;
    procedure SelectPoint(AIndex: Integer; Sel: boolean); //overload;
    procedure SelectAllPoints(Sel: boolean); overload;
    function  SelectedPointsCount: integer;
    procedure InsertPoint(AIndex: Integer; Ax,Ay: TFloat);
    procedure DeletePoint(AIndex: Integer); overload;
    procedure DeletePoint(Ax,Ay: TFloat); overload;
    procedure DeletePoints(AIndex1,AIndex2: Integer);
    procedure DeleteSelectedPoints;
    procedure SetBeginPoint(AIndex: Integer);
    procedure SetOutherBeginPoint(Ax,Ay: TFloat);
    procedure InversPointOrder;
    procedure AbsolutClosed;

    procedure MoveCurve(Ax,Ay: TFloat);
    procedure MoveSelectedPoints(Ax,Ay: TFloat);
    procedure MagnifyCurve(Cent: TPoint2d; Magnify: TFloat);
    procedure RotateCurve(Cent : TPoint2d; Angle: TFloat);
    procedure MirrorHorizontal;
    procedure MirrorVertical;

    function  IsInBoundsRect(Ax, Ay: TFloat): boolean;
    function  IsOnPoint(Ax, Ay, delta: TFloat): Integer;
    function  IsInCurve(Ax, Ay: TFloat): TInCode; overload;
    function  IsInCurve(P: TPoint2d): TInCode; overload;
    function  IsCutLine(P1,P2: TPoint2d): boolean; overload;
    function  IsCutLine(P1, P2: TPoint2d; var d : double): boolean; overload;
    function  IsCutLine(P1, P2: TPoint2d; var idx: integer; var mp: TPoint2d): boolean; overload;
    procedure Poligonize(Cuv: TCurve; Count: integer);
    function  GetKerulet: double;
    function  GetKeruletSzakasz(Aindex1,Aindex2: integer): double;
    function  GetNearestPoint(p: TPoint2d; var pIdx: integer): TFloat; overload;
    function  GetNearestPoint(p: TPoint2d): integer; overload;
    function  GetBoundsRect: TRect2d;
    function  IsDirect: boolean;
    procedure FillPointArray; overload;
    procedure FillPointArray(var aList: array of TPoint2d); overload;
    procedure FillTempCurve;
    function  GetDistance(p: TPoint2d): double;

    function  GetOldCurveData: TCurveData;
    procedure SetOldCurveData(Data: TCurveData);
    function  GetCurveData: TNewCurveData;
    procedure SetCurveData(Data: TNewCurveData);

    procedure CurveToRect(Ax, Ay: TFloat);
    function  CurveToText: WideString;

    // For Ckipper routines
    // Converts the curve point to a int array, with * multiplier
    procedure ToPath(var aList: TPath; multiplier: double);
    // Converts the path int point to the curve points, with /: multiplier
    procedure FromPath(var aList: TPath; multiplier: double);
    procedure SetContour(dist: double);         // Creates a contour into Contour curve
    procedure SetClipperContour(dist: double);  // Creates a contour into Contour curve
    function  GetContour( dist: double ): TCurve;

    property Count: integer read GetCount;   // Pontok száma
    property Center: TPoint2d read GetCenter;
    property BoundsRect: TRect2d read GetBoundsRect;
    property Points[AIndex: integer] : TPoint2d read GetPointArray write SetPoints;
    property ContourPoints[AIndex: integer] : TPoint2d read GetContourPoints write SetContourPoints;
    property PointRec[AIndex: integer] : TPointRec read GetPointRec write SetPointRec;
  published
    property ID: Integer read FID write FID;
    property Name: Str32 read FName write SetName;
    property Layer: byte read FLayer write SetLayer default 0;
    property Font: TFont read FFont write SetFont;
    property Angle: TFloat read fAngle write SetAngle;
    property LineWidth: integer read FLineWidth write FLineWidth;
    property LineColor: TColor  read FLineColor write FLineColor;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Visible: Boolean read FVisible write SetVisible;
    property Closed: boolean read fClosed write SetClosed;
    property ParentID: integer read FParentID write FParentID;
    property Selected: boolean read fSelected write SetSelected;
    property Shape: TDrawMode read fShape write SetShape;
    property Signed: boolean read fSigned write SetSigned;
    property Crossed: boolean read fCrossed write SetCrossed;
    property Sorted: boolean read fSorted write SetSorted;
    property OutBase: boolean read fOutBase write SetOutBase;
    property ContourRadius: double read FContourRadius write SetContourRadius;
    property Text: string read FText write FText;
    property VisibleContour: Boolean read FVisibleContour write FVisibleContour;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;


  { A rectangle sorround some selected oblects for further distorsion. }

  TSelectedAreaType = (
                       satFix,     // Mérete nem változtatható, csak forgatható
                       satMagnify, // Sarokpontokkal nagytható, oldalpontokkal
                                   //   ||-an elmozgatható
                       satFlex     // Rugalmasan torzítható
                      );

  TSelectedArea = class(TPersistent)
  private
    FPen: TPen;
    FAllwaysDraw: boolean;
    FVisible: boolean;
    FOnChange: TNotifyEvent;
    FOrigRect: TRect2d;
    FRotAngle: double;
    FFrameType: TSelectedAreaType;
    FOnVisible: TNotifyEvent;
    FZoom: double;
    FOrtho: boolean;
    procedure SetVisible(const Value: boolean);
    procedure SetAllwaysDraw(const Value: boolean);
    procedure SetOrigRect(const Value: TRect2d);
    function GetBoundsRect: TRect2d;
    procedure SetRotAngle(const Value: double);
    procedure SetBoundsRect(const Value: TRect2d);
    function GetHeight: double;
    function GetWidth: double;
    procedure SetHeight(const Value: double);
    procedure SetWidth(const Value: double);
    procedure SetZoom(const Value: double);
  public
    Nodes     : array[0..9] of TPoint2d; // Corners(0..3),Midpoints(4..7),8:RC,9:RCent
    RC        : TPoint2d;   // Rotation pont
    RCent     : TPoint2d;   // Rotation centrum (átlók metszéspontja)
    FixPoint  : TPoint2d;   // Standard fix point to OrthoTransform
    ActualNode: integer;    // Actual Node for modify
    OrigList  : TList;      // Original curve list in the OrigRect;
    DestList  : TList;      // Curve list after distorsion
    FCurve    : TCurve;
    oCurve    : TCurve;
    dCurve    : TCurve;
    FWidth    : double;
    FHeight   : double;

    constructor Create;
    destructor Destroy; override;

    procedure Init;        // Initialise the variables and lists
    procedure SetRect(R: TRect2d);
    procedure SetSize( w,h: double );  // Modify with and height
    procedure Recalc;      // Recalculate the nodes position in quadrilateral area
    function  IsNode(p: TPoint2d; Radius: double; var idx: integer): boolean;
    function  IsInPoint(p: TPoint2d): boolean;
    procedure SetNode( idx: integer; p: TPoint2d );
    procedure AddCurve(Cuv: TCurve);
    procedure Move(dx,dy : double);
    procedure MoveEdge(idx: integer; dx, dy : double);
    procedure Magnify( coeff: double );
    procedure RelRotate(angle : double); overload;
    procedure RelRotate( P: TPoint2d ); overload;
    procedure Rotate(Cent: TPoint2d; Angle: double);
    procedure Mirror(idx: integer);  // idx=1-függõleges, 2-vizszintes, 3-középpontos
    procedure OrthoTransform( NodeIdx: integer; CurPos: TPoint2d );
  published
    // original rectangle
    property FrameType     : TSelectedAreaType read FFrameType write FFrameType;
    property BoundsRect    : TRect2d read GetBoundsRect write SetBoundsRect;
    property OrigRect      : TRect2d read FOrigRect write SetOrigRect;
    property Ortho         : boolean read FOrtho write FOrtho default false;
    property Pen           : TPen    read FPen write FPen;
    property RotAngle      : double  read FRotAngle write SetRotAngle; // fok
    property Zoom          : double  read FZoom write SetZoom; // fok
    property Visible       : boolean read FVisible write SetVisible default false;
    property AllwaysDraw   : boolean read FAllwaysDraw write SetAllwaysDraw default True;
    property Height        : double  read GetHeight write SetHeight;
    property Width         : double  read GetWidth write SetWidth;
    property OnChange      : TNotifyEvent read FOnChange write FOnChange;
    property OnVisible     : TNotifyEvent read FOnVisible write FOnVisible;
  end;

  // Event fron changing drawmode
  TChangeMode    = procedure(Sender: TObject; ActionMode: TActionMode; DrawMode: TDrawMode) of object;
  // Event fron changing window dimension
  TChangeWindow  = procedure(Sender: TObject; Origo: TPoint2D;  Zoom: Double; CursorPos: TPoint ) of object;
  TMouseEnter    = procedure(Sender: TObject) of object;
  TNewBeginPoint = procedure(Sender: TObject; Curve: integer) of object;
  TChangeCurve   = procedure(Sender: TObject; Curve: TCurve; Point: integer) of object;
  TCutPlan       = procedure(Sender: TObject; Curve: TCurve; Point: integer) of object;
  TProcess       = procedure(Sender: TObject; Status: byte; Percent: integer) of object;
  TAutoSortEvent = procedure(Sender: TObject; Status: byte; ObjectNo: word) of object;
  TNewFile       = procedure(Sender: TObject; FileName:string) of object;

  TCurveList = class(TObjectList<TCurve>)
  private
  protected
  public
  end;

Var delta: TFloat = 4;       // Sensitive radius around of points

const
  // User definied cursors in CURSORS.RES
  crKez1           = 18000;
  crKez2           = 18001;
  crRealZoom       = 18002;
  crNyilUp         = 18003;
  crNyilDown       = 18004;
  crNyilLeft       = 18005;
  crNyilRight      = 18006;
  crZoomIn         = 18007;
  crZoomOut        = 18008;
  crKereszt        = 18009;
  crHelp           = 18100;
  crPolyline       = 20000;
  crPolygon        = 20001;
  crInsertPoint    = 20002;
  crDeletePoint    = 20003;
  crNewbeginPoint  = 20004;
  crRotateSelected = 20005;
  crFreeHand       = 20006;
  crCircle         = 20007;
  crRectangle      = 20008;
  crArc            = 20009;
  crSDefault       = 20010;


Const
  EoLn  : string = chr(13)+chr(10);
  Inch  : double = 25.4500; // mm

  DrawModeText : Array[0..Ord(High(TDrawMode))] of String =
              ('None', 'Point', 'Line', 'Rectangle', 'Polyline', 'Polygon',
               'Circle', 'Ellipse', 'Arc', 'Chord', 'Spline', 'BSpline', 'Text',
               'FreeHand','Bitmap','Path','CubicBezier', 'QuadraticBezier',
               'RotRect', 'Arrow');

  ActionModeText : Array[0..23] of String =
               ('None', 'Drawing', 'Paning', 'Zooming', 'Painting',
                 'Select',
                 'InsertNode', 'DeleteNode', 'MoveNode','SelectNode',
                 'ChangeNode', 'DeleteSelected', 'MoveSelected', 'RotateSelected',
                 'NewBeginNode', 'MagnifySelected', 'SelectArea', 'SelectAreaEx',
                 'AutoPlan','TestWorking','OutherBeginNode','Frame', 'ManualOrder',
                 'SelectNodes');

  ShapeClosed : Array[0..12] of Boolean =
              (False, False, False, True, False, True,
               True, True, False, True, False, True, False);


  // Procedures ---------------------------------------------------------

  procedure DrawShape(Canvas: TCanvas; T,B: TPoint; DrawMode: TDrawMode;
                            AMode: TPenMode);
  function InRange(Test,Min,Max: Integer): Boolean;
  procedure FillActionStrings(st: TStrings);
  procedure FillDrawmodeStrings(st: TStrings);
  function CheckForOverLaps( Cuv1, Cuv2 : TCurve): boolean;

  function AL_InputQuery( x,y : integer; ACaption, APrompt: string;
                             VisibleButtons: boolean;  var Value: string): Boolean;
  // Controll the KeyPress chars:
  // If Numeric then char in (0..9,'+','-'#13,#8,'.',',')
  // and change ,=>.
  function KeyPressChange(var Key: Char; Numeric: boolean): Char;

implementation

{$R Cursors.RES}

function InRange(Test,Min,Max: Integer): Boolean;
begin
  Result:=(Test >= Min) and (Test <= Max);
end;

// Draw a shape to Canvas
procedure DrawShape(Canvas: TCanvas; T,B: TPoint; DrawMode: TDrawMode;
                            AMode: TPenMode);
var DC:HDC;
    DX,DY : integer;
begin
  DC := GetDC(Canvas.Handle);
  With Canvas do
  begin
    Pen.Mode    := AMode;
    Brush.Color := clWhite;
    Brush.style := bsClear;
    If (T.X<>B.x) OR (T.Y<>B.Y) then
    begin
        case DrawMode of
        dmPoint:
            Rectangle(T.X-2,T.Y-2,T.X+2,T.Y+2);
        dmLine,dmPolyline,dmPolygon:
        begin
            MoveTo(T.X, T.Y); LineTo(B.X, B.Y);
        end;
        dmRectangle : Rectangle(T.X, T.Y, B.X, B.Y);
        dmCircle,dmEllipse :
        begin
            dx := Abs(T.X-B.X);
            dy := Abs(T.Y-B.Y);
            if DrawMode=dmCircle then begin
               dx:=Trunc(sqrt(dx*dx+dy*dy));
               dy:=dx;
            end;
            Ellipse(T.X-dx, T.Y-dy, T.X+dx, T.Y+dy);
        end;
        end;
    end;
  end;
  RestoreDC(Canvas.Handle,DC);
end;

procedure FillActionStrings(st: TStrings);
{ Fill a stringlist wirh ActionModeTexts }
var i: integer;
begin
  st.Clear;
  for i := 0 to High(ActionModeText) do
      st.Add(ActionModeText[i]);
end;

procedure FillDrawmodeStrings(st: TStrings);
{ Fill a stringlist wirh ActionModeTexts }
var i: integer;
begin
  st.Clear;
  for i := 0 to High(DrawModeText) do
      st.Add(DrawModeText[i]);
end;

function CheckForOverLaps( Cuv1, Cuv2 : TCurve): boolean;
var Clip: TClipper;
    shape1,shape2: TPath;
    solution: TPaths;
begin
Try
    Result := false;
    Clip := TClipper.Create;
    Cuv1.ToPath( shape1,100);
    Cuv2.ToPath( shape2,100);
    Clip.AddPath (shape1, ptClip, true);
    Clip.AddPath (shape2, ptSubject, true);
    if Clip.Execute (ctIntersection, solution, pftNonZero, pftNonZero)
    then
    if solution<>nil then
       Result := High(solution[0])>0;
Finally
    Clip.Free;
End;
end;

 // Controll the KeyPress chars:
  // If Numeric then char in (0..9,'+','-'#13,#8,'.',',')
  // and change ,=>.
  function KeyPressChange(var Key: Char; Numeric: boolean): Char;
  begin
    Result := Key;
    if Numeric then
    begin
      if not ( Key in ['0'..'9','+','-',#13,#27,#8,'.',','] ) then
         Result := #0;
      if Key=',' then Result:='.';
    end;
    Key := Result;
  end;
{------------------------------------------------------------------------------}


{ -----------  TUndoRedo --------- }

constructor TUndoRedo.Create;
var i: integer;
begin
  Inherited Create;
  UndoLimit := 1000;
  Enable    := True;
  UndoInit;
end;

destructor TUndoRedo.Destroy;
var i: integer;
begin
  for i:=0 to fUndoLimit-1 do
      if  UndoStreams[i]<>nil then UndoStreams[i].Destroy;
  Inherited Destroy;
end;

{Az Undo stream-eket alapra hozza}
procedure TUndoRedo.UndoInit;
var i: integer;
begin
  UndoSaveCount := 0;
  UndoCount     := 0;
  UndoStart     := 0;
  UndoPointer   := 0;
  UndoEnable    := False;
  RedoEnable    := False;
  for i:=0 to fUndoLimit-1 do
      if UndoStreams[i]=nil then UndoStreams[i].Create
      else UndoStreams[i].Clear;
  If Assigned(FUndoRedo) then FUndoRedo(Self,False,False);
end;

{Undo mentés az sbl stream tartalmát menti az UndoStreams n. streamjére;
 az undopointer és undoCount értékét 1-el növeli }
procedure TUndoRedo.UndoSave;
begin
If Enable then begin
  UndoStart := UndoPointer;
  UndoStreams[UndoPointer].Clear;
  If Assigned(fUndoSaveProcedure) then
     fUndoSaveProcedure(UndoStreams[UndoPointer]);
  Inc(UndoPointer);
  UndoPointer := UndoPointer mod UndoLimit;
  Inc(UndoSaveCount);
  UndoCount := 0;
  UndoEnable    := UndoSaveCount>0;
  RedoEnable    := False;
  If Assigned(FUndoRedo) then FUndoRedo(Self,UndoEnable,RedoEnable);
end;
end;

function TUndoRedo.GetIndex(us:integer): integer;
begin
  Result := us;
  If us>(Undolimit-1) then Result:=us mod Undolimit;
  if us<0 then Result:=UndoLimit-(Trunc(Abs(us)) mod Undolimit)
end;

procedure TUndoRedo.Undo;
var UC,IDX: integer;
begin
If Enable then begin
   UC := UndoPointer-1;
   If UndoSaveCount>=UndoLimit then UC:=UndoLimit-1;
   UndoEnable := UndoCount<UC;
   if UndoEnable then begin
        Dec(UndoStart);
        IDX := GetIndex(UndoStart);
        UndoStreams[IDX].Seek(0,0);
        If Assigned(fUndoRedoProcedure) then
           fUndoRedoProcedure(UndoStreams[IDX]);
        Inc(UndoCount);
        UndoEnable := UndoCount<UC;
        RedoEnable := UndoCount>0;
   end;
   If Assigned(FUndoRedo) then FUndoRedo(Self,UndoEnable,RedoEnable);
end;
end;

procedure TUndoRedo.Redo;
var UC,IDX: integer;
begin
If Enable then begin
   RedoEnable := UndoCount>0;
   if RedoEnable then begin
        Inc(UndoStart);
        IDX := GetIndex(UndoStart);
        UndoStreams[IDX].Seek(0,0);
        If Assigned(fUndoRedoProcedure) then
           fUndoRedoProcedure(UndoStreams[IDX]);
        Dec(UndoCount);
        RedoEnable := UndoCount>0;
        UndoEnable := True;
   end;
   If Assigned(FUndoRedo) then FUndoRedo(Self,UndoEnable,RedoEnable);
end;
end;

procedure TUndoRedo.SetUndoLimit(const Value: integer);
var i: integer;
begin
  If fUndoLimit <> Value then begin
     fUndoLimit := Value;
     If fUndoLimit>High(UndoStreams) then fUndoLimit:=High(UndoStreams);
     for i:=0 to fUndoLimit-1 do
       if UndoStreams[i]=nil then UndoStreams[i]:=TMemoryStream.Create;
     for i:=fUndoLimit to High(UndoStreams) do
       if UndoStreams[i]<>nil then UndoStreams[i].Destroy;
  end;
end;

procedure TUndoRedo.SetEnable(const Value: boolean);
begin
  fEnable := Value;
  if Value then begin
   If Assigned(FUndoRedo) then FUndoRedo(Self,UndoEnable,RedoEnable)
  end else
   If Assigned(FUndoRedo) then FUndoRedo(Self,False,False);
end;

{ -----------  TPoint2dObj --------- }

constructor TPoint2dObj.Create;
begin
  inherited;
  fx := 0;
  fy := 0;
end;

procedure TPoint2dObj.Changed;
begin if Assigned(FOnChange) then FOnChange(Self); end;

procedure TPoint2dObj.Setx(Value:extended);
begin
     Fx:=Value;
     Changed;
end;

procedure TPoint2dObj.Sety(Value:extended);
begin
     Fy:=Value;
     Changed;
end;

{ -----------  T2DPoint --------- }

procedure T2DPoint.Changed;
begin
  if Assigned(FOnChange) then
     FOnChange(Self);
end;

constructor T2DPoint.Create(AOwner:TObject; px,py: extended);
begin
  inherited Create;
  x := px; y := py;
  ID := 0;
end;

procedure T2DPoint.Setx(Value:extended);
begin
  If Fx<>Value then begin
     Fx:=Value;
     Changed;
  end;
end;

procedure T2DPoint.Sety(Value:extended);
begin
  If Fy<>Value then begin
     Fy:=Value;
     Changed;
  end;
end;

//-----------THRTimer-----------------

Constructor THRTimer.Create;
Var  QW : _Large_Integer;
BEGIN
   Inherited Create;
   Exists := QueryPerformanceFrequency(TLargeInteger(QW));
   ClockRate := QW.QuadPart;
END;

Function THRTimer.StartTimer : Boolean;
Var
  QW : _Large_Integer;
BEGIN
   Result := QueryPerformanceCounter(TLargeInteger(QW));
   StartTime := QW.QuadPart;
END;

Function THRTimer.ReadTimer : Double;
Var
  ET : _Large_Integer;
BEGIN
   QueryPerformanceCounter(TLargeInteger(ET));
   Result := 1000.0*(ET.QuadPart - StartTime)/ClockRate;
END;

PROCEDURE THRTimer.Delay(ms: double);
Var
  QW,ET : _Large_Integer;
  Start_Time, dt : double;
BEGIN
   QueryPerformanceCounter(TLargeInteger(QW));
   Start_Time := QW.QuadPart;
   repeat
         QueryPerformanceCounter(TLargeInteger(ET));
         dt := 1000.0*(ET.QuadPart - Start_Time)/ClockRate;
   Until dt>=ms;
END;

{------------------------------------------------------------------------------}

{ TLayer }

constructor TLayer.Create(Idx: Byte);
begin
  fPen := TPen.Create;
  fBrush := TBrush.Create;
  fLayerID := Idx;
  Tag := 0;
end;

destructor TLayer.Destroy;
begin
  fPen.Free;
  fBrush.Free;
  inherited;
end;

procedure TLayer.LoadFromStream(const Stream: TStream);
begin

end;

procedure TLayer.SaveToStream(const Stream: TStream);
begin

end;

procedure TLayer.SetBrush(const Value: TBrush);
begin
  fBrush := Value;
end;

procedure TLayer.SetName(const Value: TLayerName);
begin
  fName := Value;
end;

procedure TLayer.SetPen(const Value: TPen);
begin
  fPen := Value;
end;

{------------------------------------------------------------------------------}

{ TGrid }

constructor TGrid.Create;
begin
  inherited;
  fMainGridColor := clGreen;
  fSubGridColor  := clSilver;
  FSubDistance   := 1;
  fOnlyOnPaper   := True;
  fMetric        := meMM;
  fVisible       := True;
end;

procedure TGrid.Change(Sender: TObject);
begin
    Changed;
end;

procedure TGrid.Changed;
begin if Assigned(FOnChange) then FOnChange(Self); end;

procedure TGrid.SetOnlyOnPaper(const Value: boolean);
begin
  fOnlyOnPaper := Value;
  Changed;
end;

procedure TGrid.SetMargin(const Value: integer);
begin
  fMargin := Value;
  Changed;
end;

procedure TGrid.SetMainGridColor(Value: TColor);
begin
  fMainGridColor:=Value;
  Changed;
end;

procedure TGrid.SetAligne(const Value: boolean);
begin
  FAligne := Value;
  Changed;
end;

procedure TGrid.SetGridStyle(const Value: TGridStyle);
begin
  fGridStyle := Value;
  Changed;
end;

procedure TGrid.SetSubDistance(const Value: integer);
begin
  // Értlke meghatározza a grid finom beosztásainak távolságát.
  // Ez alap esetben 1 mm.
  // Ennek akkor van jelentõsége, ha a rácshoz igazítás funkció be van kapcsolva,
  //       azaz csak a rácspontokba lehet rajzolni.
  FSubDistance := Value;
end;

procedure TGrid.SetSubGridColor(Value: TColor);
begin
 fSubGridColor := Value;
  Changed;
end;

procedure TGrid.SetMetric(const Value: TMetric);
begin
  fMetric := Value;
  Changed;
end;

procedure TGrid.SetVisible(const Value: boolean);
begin
  fVisible := Value;
  Changed;
end;


{ T3DPoint }

procedure T3DPoint.Changed;
begin
  if Assigned(FOnChange) then
     FOnChange(Self);
end;

constructor T3DPoint.Create(AOwner: TObject; px, py, pz: extended);
begin
  inherited Create;
  x := px; y := py; z := pz;
  ID := 0;
end;

procedure T3DPoint.Setx(Value: extended);
begin
  If Fx<>Value then begin
     Fx:=Value;
     Changed;
  end;
end;

procedure T3DPoint.Setz(const Value: extended);
begin
  If Fz<>Value then begin
     Fz:=Value;
     Changed;
  end;
end;

procedure T3DPoint.Sety(Value: extended);
begin
  If Fy<>Value then begin
     Fy:=Value;
     Changed;
  end;
end;

{------------------------------------------------------------------------------}

{ TCurve }

// TCurve = Closed or Opened Curve Obeject's Datas}


constructor TCurve.Create;
begin
  inherited Create;
  FPoints        :=TList.Create;
  FFont          :=TFont.Create;
  FFont.OnChange :=Changed;
  FAngle         :=0;
  FEnabled       :=True;
  FVisible       :=True;
  FClosed        :=True;
  FSelected      :=False;
  FSigned        :=False;
  FShape         :=dmNone;
  FParentID      :=-1;      // Nincs szülõ objektuma
  fOutBase       := false;
  FContourRadius := 4;
  InitTrans3d;
end;

destructor TCurve.Destroy;
var
  I: Integer;
begin
Try
  for I:=0 to Pred(FPoints.Count) do FreeMem(FPoints.Items[I],SizeOf(TPointRec));
  if FPoints<>nil then FPoints.Free;
  if FFont<>nil then FFont.Free;
  inherited Destroy;
except
  inherited Destroy;
End;
end;

function TCurve.GetCount: integer;
begin
  if Self<>nil then
  Result := Fpoints.Count;
end;

procedure TCurve.SetName(const Value: Str32);
begin
  FName := Value;
  Changed(Self);
end;

procedure TCurve.SetLayer(const Value: byte);
begin
if Enabled then begin
  FLayer := Value;
  Changed(Self);
end;
end;

procedure TCurve.SetFont(const Value: TFont);
begin
if Enabled then begin
  FFont := Value;
  Changed(Self);
end;
end;

procedure TCurve.SetClipperContour(dist: double);
var subj : TPath;
    sol  : TPaths;
    ClipOffset: TClipperOffset;
    i    : integer;
begin
  if Contour=nil then begin
     Contour := TCurve.Create;
      With Contour do begin
        FID := -1;
        FName := 'Contour';
        Shape := dmPolygon;
        Closed := true;
      end;
  end
  else
     Contour.ClearPoints;
  if Closed and (Count>2) then
  Try
  Try
    ClipOffset := TClipperOffset.Create;
    ToPath(subj,100);
    ClipOffset.AddPath(subj, jtRound, etClosedPolygon);
    ClipOffset.Execute(sol, 100*dist);
    if Length(sol)<>0 then
    Try
       FromPath(sol[0],100);      // Result in Contour curve
       if High(FContour)>1 then
          for I := 0 to High(FContour) do
              Contour.AddPoint(FContour[i]);

    except
    End;
  Finally
    ClipOffset.Free;
  End;
  except
    if ClipOffset<>nil then
       ClipOffset.Free;
  End;
end;

procedure TCurve.SetClosed(const Value: boolean);
begin
Try
IF Self<>nil then
if Enabled then begin
  fClosed := Value;
  Changed(Self);
end;
except
end;
end;

procedure TCurve.SetEnabled(const Value: Boolean);
begin
  FEnabled := Value;
  Changed(Self);
end;

procedure TCurve.SetSigned(const Value: boolean);
begin
  fSigned := Value;
  Changed(Self);
end;

procedure TCurve.SetSorted(const Value: boolean);
begin
  fSorted := Value;
  Changed(Self);
end;

procedure TCurve.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
  Changed(Self);
end;

(*
procedure TCurve.SetVisibleContour(const Value: Boolean);
begin
  if Value and Closed then
  begin
    FVisibleContour := True;
    SetClipperContour( ContourRadius );
  end
  else begin
    FVisibleContour := False;
    SetLength(FContour,0)
  end;
  Changed(Self);
end;
*)
procedure TCurve.ToPath(var aList: TPath; multiplier: double);
Var  i: integer;
     pp: TIntPoint;
begin
  SetLength( aList, Count );
  for i := 0 to High(aList) do begin
      pp.x := Round(multiplier*Points[i].X);
      pp.y := Round(multiplier*Points[i].Y);
      aList[i] := pp;
  end;
end;

procedure TCurve.SetAngle(const Value: TFloat);
begin
  fAngle := Value;
  Changed(Self);
end;

procedure TCurve.AddPoint(Ax, Ay: TFloat);
begin
if Enabled then begin
  GetMem(PPoint,SizeOf(TPointRec));
  PPoint^.X:=Ax;
  PPoint^.Y:=Ay;
  PPoint^.Selected:=False;
  FPoints.Add(PPoint);
end;
end;

procedure TCurve.AddPoint(P: TPoint2d);
begin
  AddPoint(P.x, P.y);
end;

procedure TCurve.ChangePoint(AIndex: Integer; Ax, Ay: TFloat);
begin
if Enabled then begin
  if InRange(AIndex,0,Pred(FPoints.Count)) then
  begin
    PPoint:=FPoints.Items[AIndex];
    PPoint^.X:=Ax;
    PPoint^.Y:=Ay;
  end;
end;
end;

procedure TCurve.ChangePoint(AIndex: Integer; Ax, Ay: TFloat; Sel: boolean);
begin
if Enabled then
  if InRange(AIndex,0,Pred(FPoints.Count)) then
  begin
    PPoint:=FPoints.Items[AIndex];
    PPoint^.X:=Ax;
    PPoint^.Y:=Ay;
    PPoint^.Selected:=Sel;
  end;
end;

procedure TCurve.SelectPoint(AIndex: Integer; Sel: boolean);
begin
if Enabled then
  if InRange(AIndex,0,Pred(FPoints.Count)) then
  begin
    PPoint:=FPoints.Items[AIndex];
    PPoint^.Selected:=Sel;
  end;
end;

procedure TCurve.SelectAllPoints(Sel: boolean);
var i: integer;
begin
if Self <> nil then
if Enabled then
  For i:=0 to Pred(FPoints.Count) do
      SelectPoint(i,Sel);
end;

function TCurve.SelectedPointsCount: integer;
var i: integer;
begin
  Result := 0;
  For i:=Pred(FPoints.Count) downto 0 do begin
    PPoint:=FPoints.Items[i];
    if PPoint^.Selected then
       Inc(Result);
  end;
end;

procedure TCurve.DeleteSelectedPoints;
var i: integer;
begin
if Enabled then
  For i:=Pred(FPoints.Count) downto 0 do begin
    PPoint:=FPoints.Items[i];
    if PPoint^.Selected then
       DeletePoint(i);
  end;
end;

procedure TCurve.SetBeginPoint(AIndex: Integer);
var NewPoints: TList;
    i,j1,j2: integer;
    PPoint: PPointRec;
begin
  if InRange(AIndex,0,Pred(Count)) then
  Try
    NewPoints:=TList.Create;
    For i:=AIndex to Pred(Count) do begin
        PPoint:=fPoints.Items[i];
        NewPoints.Add(PPoint);
    end;
    if Closed then begin
       j1 := 0; j2 := AIndex-1;
       For i:=j1 to j2 do begin
        PPoint:=fPoints.Items[i];
        NewPoints.Add(PPoint);
    end;
    end else begin
       j2 := 0; j1 := AIndex-1;
       For i:=j1 downto j2 do begin
        PPoint:=fPoints.Items[i];
        NewPoints.Add(PPoint);
    end;
    end;
    finally
        fPoints.Clear;
        For i:=0 to Pred(NewPoints.Count) do begin
            PPoint:=NewPoints.Items[i];
            fPoints.Add(PPoint);
        end;
        NewPoints.Free;
    end;
end;

// Külsõ kezdõpont kijelölés
// A legközelebbi pont lesz a kezdõpont, amit kitolunk az Ax,Ay pontba
procedure TCurve.SetOutBase(const Value: boolean);
begin
  fOutBase := Value;
end;

procedure TCurve.SetOutherBeginPoint(Ax,Ay: TFloat);
var p: TPoint2d;
    idx: integer;
begin
if Self<>nil then
if Enabled then begin
  GetNearestPoint(Point2d(Ax,Ay),idx);
  p := Points[idx];
  SetBeginPoint(idx);
  InsertPoint(1,p.x,p.y);
  AddPoint(P.x, P.y);
  Points[0]:=Point2d(Ax,Ay);
  fOutBase := true;
end;
end;

procedure TCurve.MoveCurve(Ax,Ay: TFloat);
var i: integer;
begin
if Self<>nil then
if Enabled then begin
  For i:=0 to Pred(FPoints.Count) do
  begin
    PPoint:=FPoints.Items[i];
    PPoint^.X:=PPoint^.X+Ax;
    PPoint^.Y:=PPoint^.Y+Ay;
  end;
end;
end;

procedure TCurve.MoveSelectedPoints(Ax,Ay: TFloat);
var i: integer;
    pr: TPointRec;
begin
if Self<>nil then
if Enabled then begin
  For i:=0 to Pred(FPoints.Count) do
  begin
    PPoint:=FPoints.Items[i];
    if PPoint^.Selected then begin
       PPoint^.X:=PPoint^.X+Ax;
       PPoint^.Y:=PPoint^.Y+Ay;
    end;
  end;
end;
end;

procedure TCurve.MagnifyCurve(Cent: TPoint2d; Magnify: TFloat);
var i: integer;
begin
if Self<>nil then
if Enabled then begin
  For i:=0 to Pred(FPoints.Count) do
  begin
    PPoint:=FPoints.Items[i];
    PPoint^.X := Cent.x + Magnify * (PPoint^.X - Cent.x);
    PPoint^.Y := Cent.y + Magnify * (PPoint^.Y - Cent.y);
  end;
end;
end;

procedure TCurve.MirrorHorizontal;
var R: TRect2d;
    x,y,h: double;
    i: integer;
begin
  R := BoundsRect;
  h := R.x2 - R.x1;     // Középvonal y értéke
  for I := 0 to Pred(Count) do
  begin
    GetPoint(i,x,y);
    ChangePoint(i,h+(h-x),y);
  end;
end;

procedure TCurve.MirrorVertical;
var R: TRect2d;
    x,y,h: double;
    i: integer;
begin
  R := BoundsRect;
  h := R.y2 - R.y1;     // Középvonal y értéke
  for I := 0 to Pred(Count) do
  begin
    GetPoint(i,x,y);
    ChangePoint(i,x,h+(h-y));
  end;

end;

procedure TCurve.RotateCurve(Cent : TPoint2d; Angle: TFloat);
var i,j: integer;
    pp: Tpoint2d;
begin
if Self<>nil then
if Enabled then begin
  Case Shape of
  dmText : j:=0;
  else
    j := Pred(FPoints.Count);
  end;
  For i:=0 to j do
  begin
    PPoint:=FPoints.Items[i];
    pp := Point2D(PPoint^.X,PPoint^.Y);
    RelRotate2D(pp,Cent,Angle);
    PPoint^.X:=pp.X;
    PPoint^.Y:=pp.Y;
  end;
end;
end;

procedure TCurve.ClearPoints;
begin
if Self <> nil then
if Enabled then begin
  FPoints.Clear;
end;
end;

// Egy contúr objektumot ad vissza, de nem hozza létre a Contourt
function TCurve.GetCenter: TPoint2d;
Var R: TRect2d;
begin
  R := GetBoundsRect;
  Result := Point2d( (R.x2+R.x1)/2, (R.y2+R.y1)/2 )
end;

function TCurve.GetContour( dist: double ): TCurve;
var
  I: Integer;
begin
  if Contour=nil then
     Result := TCurve.Create
  else
     Result.ClearPoints;

  SetClipperContour( dist );

  if High(FContour)>1 then
  for I := 0 to High(FContour) do
      Result.AddPoint(FContour[i]);

  With Result do begin
    FID := -1;
    FName := 'Contour';
    Shape := dmPolygon;
    Closed := true;
  end;

end;

function TCurve.GetContourPoints(AIndex: integer): TPoint2d;
begin

end;

procedure TCurve.DeletePoint(AIndex: Integer);
begin
if Self<>nil then
if Enabled then begin
  if InRange(AIndex,0,Pred(FPoints.Count)) then
  begin
    FreeMem(FPoints.Items[AIndex],SizeOf(TPointRec));
    FPoints.Delete(AIndex);
  end;
end;
end;

procedure TCurve.DeletePoint(Ax, Ay: TFloat);
var i: integer;
    p: TPoint2d;
begin
  if Self<>nil then
  for i:=Pred(Count) downto 0 do begin
      p := GetPoint2d(i);
      if (Abs(Ax-p.x)<delta) and (Abs(Ay-p.y)<delta) then
         DeletePoint(i);
  end;
end;

// Törli a pontokat az AIndex1 és AIndex2 tartományban,
// beleértve a megadott határpontokat is
procedure TCurve.DeletePoints(AIndex1, AIndex2: Integer);
var k,i: integer;
begin
  if AIndex2 < AIndex1 then begin
     k := AIndex1;
     AIndex1 := AIndex2;
     AIndex2 := k;
  end;
  if AIndex2>Pred(Count) then
     AIndex2 := Pred(Count);
  if AIndex1<0 then
     AIndex1 := 0;
  for i := AIndex2 downto AIndex1 do
      DeletePoint(i);
end;

procedure TCurve.GetPoint(AIndex: Integer; var Ax, Ay: TFloat);
begin
  if Self<>nil then
  if InRange(AIndex,0,Pred(FPoints.Count)) then
  begin
    PPoint:=FPoints.Items[AIndex];
    Ax:=PPoint^.X;
    Ay:=PPoint^.Y;
  end;
end;

function TCurve.GetPoint2d(AIndex: Integer): TPoint2d;
begin
  if Self<>nil then
  if InRange(AIndex,0,Pred(FPoints.Count)) then
  begin
    PPoint := FPoints.Items[AIndex];
    Result := Point2d(PPoint^.X,PPoint^.Y);
  end;
end;

function TCurve.GetPointRec(AIndex: Integer): TPointRec;
begin
  if Self<>nil then
  if InRange(AIndex,0,Pred(FPoints.Count)) then
  begin
    Result := TPointRec(FPoints.Items[AIndex]^);
  end;
end;

function TCurve.GetPointArray(AIndex: integer): TPoint2d;
begin
  if Self<>nil then
  Result := GetPoint2d(AIndex);
end;

procedure TCurve.FillPointArray;
//(array of TPoint3d);
var i: integer;
    p: TPoint2d;
begin
  if Self<>nil then
  SetLength(PointsArray,Count);
  for i:=0 to Count-1 do begin
      p := GetPoint2d(i);
      PointsArray[i].x := p.x;
      PointsArray[i].y := p.y;
      PointsArray[i].z := 0;
  end;
end;

procedure TCurve.FillPointArray(var aList: array of TPoint2d);
//(array of TPoint2d);
var i: integer;
begin
  if Self<>nil then
  SetLength(PointsArray,Count);
  for i:=0 to Count-1 do
      aList[i] := GetPoint2d(i);
end;

// A TempCurve-t feltölti a Curve pontjaival és ha kell poligonizálja
procedure TCurve.FillTempCurve;
var i: integer;
begin
  if TempCurve=nil then TempCurve := TCurve.Create;
  TempCurve.Shape := Shape;
  TempCurve.Closed := Closed;
  TempCurve.ClearPoints;
  for i:=0 to Count-1 do begin
      TempCurve.AddPoint( GetPoint2d(i) );
  end;
end;

procedure TCurve.FromPath(var aList: TPath; multiplier: double);
Var  i,n: integer;
     pp: TIntPoint;
     p: TDoublePoint;
begin
Try
      n := High(aList);
      SetLength( FContour,n );
  for i := 0 to n-1 do begin
      pp := aList[i];
      p  := DoublePoint( pp );
      FContour[i] := Point2d( p.X/multiplier, p.Y/multiplier );
  end;
except
End;
end;

procedure TCurve.SetPointRec(AIndex: integer; const Value: TPointRec);
begin
  ChangePoint(AIndex,Value.x,Value.y,Value.Selected);
end;

procedure TCurve.SetPoints(AIndex: integer; const Value: TPoint2d);
begin
  ChangePoint(AIndex,Value.x,Value.y);
end;

// Initialize the Trans3d transformation values
procedure TCurve.InitTrans3d;
begin
  with Trans3d do begin
    x:=0; y:=0; z:=0; r:=1;
    RotAngle_X:=0;
    RotAngle_Y:=0;
    RotAngle_Z:=0;
    RotX:=0; RotY:=0; RotZ:=0;
    ScaleX:=1; ScaleY:=1; ScaleZ:=1;
    Selected := False;
  end;
end;

procedure TCurve.InsertPoint(AIndex: Integer; Ax, Ay: TFloat);
begin
if Enabled then begin
  if AIndex > -1 then
  begin
    GetMem(PPoint,SizeOf(TPointRec));
    PPoint^.X:=Ax;
    PPoint^.Y:=Ay;
    FPoints.Insert(AIndex,PPoint);
  end;
end;
end;

function TCurve.IsDirect: boolean;
var ymax: double;
    i,idx: integer;
    Pprior,Pnext: integer;
begin
if Self<>nil then
begin
  // Y max pont megkeresése
  ymax:= -10e+10;
  for i:=0 to Pred(Count) do
      if Points[i].y>ymax then begin
         ymax := Points[i].y;
         idx := i;
      end;
  Pprior := idx-1;
  Pnext  := idx+1;
  if idx=0 then
     Pprior := Pred(Fpoints.Count);
  if idx=Pred(Fpoints.Count) then
     Pnext := 0;
  Result := IsDirectPoligon(Points[Pprior],Points[idx],Points[Pnext]);
end else Result := False;
end;

procedure TCurve.SetSelected(const Value: boolean);
begin
if Enabled then begin
  FSelected := Value;
  Changed(Self);
end;
end;

procedure TCurve.SetShape(const Value: TDrawMode);
begin
if Enabled then begin
  fShape := Value;
  Changed(Self);
end;
end;

function TCurve.IsInCurve(P: TPoint2d): TInCode;
begin
  Result := IsInCurve(p.x,p.y);
end;

function TCurve.IsInCurve(Ax, Ay: TFloat): TInCode;
{Examine that point is in curve or in a point or out of curve}
Var e: TEgyenes;
    i,N: integer;
    arr  : array of TPoint2d;
    PP1,PP2: PPointRec;
    d: double;

 function InSide (const x,y : integer; Polygon: array of TPoint): boolean;
  var
     PolyHandle: HRGN;
 begin
   PolyHandle := CreatePolygonRgn(Polygon[0],length(Polygon)-1,Winding);
   result     := PtInRegion(PolyHandle,X,Y);
   DeleteObject(PolyHandle);
 end;

function PointInPolygonTest(x, y: real; N: Integer; aList: Array of TPoint2d): Boolean;
Type
   PPoint = ^TPoint;
var
   I, J : Integer;

   Function xp(aVal:Integer):Integer;
   Begin
     Result:= PPoint(@aList[aVal]).X;
   end;

   Function yp(aVal:Integer):Integer;
   Begin
     Result:= PPoint(@aList[aVal]).Y;
   end;

begin
   Result := False;
   {L := Length(aList);}
   if (N = 0) then exit;
   J := N-1;
   for I := 0 to N-1 do
   begin
     if ((((yp(I) <= y) and (y < yp(J))) or
          ((yp(J) <= y) and (y < yp(I)))) and
         (x < (xp(J)-xp(I))*(y-yp(I))/(yp(J)-yp(I))+xp(I)))
     then Result := not Result;
     J:=I;
   end;
end;

Function IsPointOnLine(p, p_1, p_2: TPoint2d; diff: double):boolean;
var d: double;
begin
  {A pontnak az egyenestõl való távolsága = d}
  d := p.x*(p_1.y-p_2.y)-p.y*(p_1.x-p_2.x)+(p_1.x*p_2.y)-(p_1.y*p_2.x);
  if Abs(d)<=diff then Result:=True else Result:=False;
end;

FUNCTION point_dist_to_line(xp,yp,x1,y1,x2,y2: double): double;
// Compute the distance from a point (xp,yp) to a line defined by its
// start (x1,y1) and end (x2,y2) points.
Var dx1p,dx21,dy1p,dy21 : double;
    frac, lambda,xsep,ysep : double;
BEGIN
     dx1p := x1 - xp; dx21 := x2 - x1; dy1p := y1 - yp; dy21 := y2 - y1;
     frac := dx21*dx21 + dy21*dy21;
     if frac=0 then Frac:=1;
     // -- Compute the distance along the line that the normal intersects.
     lambda := -(dx1p*dx21 + dy1p*dy21) / frac;
     // -- Accept if along the line segment, else choose the correct end point.
     lambda := MIN(MAX(lambda,0.0),1.0);
     //-- Compute the x and y separations between the point on the line that is
     //-- closest to (xp,yp) and (xp,yp).
     xsep := dx1p + lambda*dx21;
     ysep := dy1p + lambda*dy21;
     Result := SQRT(xsep*xsep + ysep*ysep);
END;

begin
  Result := icOut;
  if IsInBoundsRect(Ax,Ay) then begin

     // Finds a point
     if IsOnPoint(Ax,Ay,delta)>-1 then begin
        Result := icOnPoint;
     end;

     if FPoints.Count>1 then begin

        // Finds a line
        For i:=0 to FPoints.Count-1 do begin
           PP1:=FPoints.Items[i];
           IF (i=FPoints.Count-1) then begin
              if Closed then PP2:=FPoints.Items[0]
           end else
              PP2:=FPoints.Items[i+1];
           d := point_dist_to_line(Ax,Ay,PP1^.x,PP1^.y,PP2^.x,PP2^.y);
           if d<delta
           then begin
              CPIndex := i+1;
              Result := icOnLine;
//              Exit;
           end;
        end;
        if Result=icOnLine then exit;

        //Point in poligon
        If Closed then begin
        // Fills the arr array with the curve points
        N := FPoints.Count;
        If Closed then N:=N+1;
        SetLength(arr,N);
        For i:=0 to FPoints.Count-1 do begin
           PPoint:=FPoints.Items[i];
           arr[i]:=Point2d(PPoint^.x,PPoint^.y);
        end;
        If Closed then begin
           PPoint:=FPoints.Items[0];
           arr[High(arr)]:=Point2d(PPoint^.x,PPoint^.y);
        end;
        if IsPointInPoligon(arr,Point2d(Ax,Ay)) then
            Result := icIn;
        end;

     end;

  end;
end;

// Megadja, hogy az alakzat melyik pontja van a legközelebb egy külsõ ponthoz
function TCurve.GetNearestPoint(p: TPoint2d; var pIdx: integer): TFloat;
var
  J   : Integer;
  d   : Double;
  x,y : double;
begin
  Result := 10e+10;
    For J:=0 to Pred(FPoints.Count) do
    begin
        GetPoint(j,x,y);
        d:=KetPontTavolsaga(p.x,p.y,x,y);
        if d<Result then begin
           pIdx   := J;
           Result := d;
        end;
    end;
end;

// A p ponthoz legközelebbi támpont indexét adja vissza
function TCurve.GetNearestPoint(p: TPoint2d): integer;
var
  J   : Integer;
  d,dd: Double;
  x,y : double;
begin
  dd := MaxDouble;
  Result := -1;
    For J:=0 to Pred(FPoints.Count) do
    begin
        GetPoint(j,x,y);
        d:=KetPontTavolsaga(p.x,p.y,x,y);
        if d<dd then begin
           dd := d;
           Result := j;
        end;
    end;
end;

// Point distance from Curve
//       Result : distance + out; - in; the curve
function TCurve.GetDistance(p: TPoint2d): double;
var
  J   : Integer;
  d   : Double;
  pj  : TPoint2d;
  mul : double;
begin
  Result := 10e+10;
  mul    := 1;
  if IsInCurve(p)=icIn then mul:=-1;
  if FPoints.Count>1 then begin
    For J:=0 to Pred(FPoints.Count) do
    begin
        if j=FPoints.Count-1 then pj:=Points[0]
        else pj:=Points[j+1];
        d := PontSzakaszTavolsaga(p,Points[j],pj);
        if d<Result then begin
           Result := d;
        end;
    end;
        Result := Result * mul;
    end
  else
  if FPoints.Count=1 then
     Result := RelDist2D(p,Points[0]);
end;

procedure TCurve.Poligonize(Cuv: TCurve; Count: integer);
var x,y,x1,y1,ArcU,ArcV: TFloat;
    szog, arcR,R1,R2,arcEAngle,deltaFI : extended;
    szog1,szog2,szog3: double;
    i,j,k   : integer;
    pp,pp1,pp2 : pPoints;
    Size    : integer;
    dd      : CurveDataArray;
    PA,pPA  : PCurveDataArray;
    arcCirc : TPoint3d;
    p2d     : TPoint2d;
begin
if (Cuv<>NIL) and (Cuv.Count>1) then
Try
   // Store the Cuv points in dPoints list
   InitdPoints;
   For i:=0 to Pred(Cuv.FPoints.Count) do begin
       pp := Cuv.Fpoints[i];
       dPoints.Add(pp);
       p2d := cuv.GetPoint2d(i);
   end;
   // First point <> Last point
   If Cuv.Closed then
   if dPoints[0]=dPoints[Cuv.FPoints.Count-1]
   then dPoints.Delete(Cuv.FPoints.Count-1);

   Case Cuv.Shape of
   dmLine:
        if Cuv.Closed then
           Cuv.Shape := dmPolygon;

   dmRectangle:
     begin
           Cuv.Shape := dmPolygon;
           Cuv.Closed := True;

     if Count>4 then begin
        if (Count Mod 4)=0 then begin
           pp := Cuv.Fpoints[0];
           dPoints.Add(pp);
           Cuv.ClearPoints;
           Cuv.Shape := dmPolygon;
           Cuv.Closed := True;
           k := Count div 4;
           for i:=0 to 3 do begin
               pp := dPoints[i];
               pp1:= dPoints[i+1];
               x  := pp1^.x - pp^.x;
               y  := pp1^.y - pp^.y;
               for j:=0 to k-1 do begin
                   Cuv.AddPoint(pp^.x+x*j/k,pp^.y+y*j/k);
               end;
           end;
        end;
     end;

     end;
   dmCircle:
     begin
       Cuv.ClearPoints;
       Cuv.Shape := dmPolygon;
       Cuv.Closed := True;
       pp := dPoints[0];
       ArcU := pp^.x;
       ArcV := pp^.y;
       pp := dPoints[1];
       arcR := sqrt(sqr(ArcU-pp^.x)+sqr(ArcV-pp^.y));
       szog := 0;
       if Count<2 then begin
          deltaFI := (2*PI*2)/(2*arcR*PI);
          if deltaFi>pi/180 then deltaFi:=pi/180;
       end else
          deltaFI := (2*PI)/Count;
       While (szog>=0) and (szog<=(2*pi)) do begin
             x := ArcU + ArcR * cos(szog);
             y := ArcV + ArcR * sin(szog);
             Cuv.AddPoint(x,y);
             szog := szog+deltaFI;
       end;
     end;
   dmEllipse:
     begin
       Cuv.ClearPoints;
       Cuv.Shape := dmPolygon;
       Cuv.Closed := True;
       pp := dPoints[0];
       ArcU := pp^.x;
       ArcV := pp^.y;
       pp := dPoints[1];
       R1 := Abs(ArcU-pp^.x);
       R2 := aBS(ArcV-pp^.y);
       szog := 0;
       if Count<2 then begin
          deltaFI := (2*PI*2)/(2*R1*PI);
          if deltaFi>pi/180 then deltaFi:=pi/180;
       end else
          deltaFI := (2*PI)/Count;
       While (szog>=0) and (szog<=(2*pi)) do begin
             x := ArcU + R1 * cos(szog);
             y := ArcV + R2 * sin(szog);
             Cuv.AddPoint(x,y);
             szog := szog+deltaFI;
       end;
     end;
   dmArc:
     if Cuv.Count>2 then begin
       Cuv.ClearPoints;
       Cuv.Shape := dmPolyline;
       Cuv.Closed := False;
       pp := dPoints[0];
       pp1:= dPoints[1];
       pp2:= dPoints[2];
       arcCirc := HaromPontbolKor(Point2d(pp^.x,pp^.y),
                                  Point2d(pp1^.x,pp1^.y),
                                  Point2d(pp2^.x,pp2^.y));
       ArcU := arcCirc.x;
       ArcV := arcCirc.y;
       arcR := arcCirc.z;
       szog1:= SzakaszSzog(ArcU,ArcV,pp^.x,pp^.y);
       szog2:= SzakaszSzog(ArcU,ArcV,pp1^.x,pp1^.y);
       szog3:= SzakaszSzog(ArcU,ArcV,pp2^.x,pp2^.y);
       szog := RelSzogdiff(szog1,szog2,szog3);
       if Count<2 then begin
          deltaFI := Sign(szog)*(2*PI*2)/(2*arcR*PI);
       end else
          deltaFI := szog/Count;
       j := Abs(Trunc(szog/deltaFI));
       for i:=0 to j do begin
             x := ArcU + arcR * cos(szog1);
             y := ArcV + arcR * sin(szog1);
             Cuv.AddPoint(x,y);
             szog1 := szog1+deltaFI;
       end;
     end;
   dmSpline:
     begin
       j := Pred(Cuv.FPoints.Count);
       for I:=0 to j do
       begin
        Cuv.GetPoint(I,X,Y);
        dd[i+1] := Point3d(x,y,0);
       end;
       Cuv.ClearPoints;
       Cuv.Shape := dmPolyline;
       Cuv.Closed := False;
       InitdPoints;
       GetSplinePoints(dd,J+1,100,Cuv.Closed);
       for I:=0 to Pred(dPoints.Count) do begin
         pp := dPoints[i];
         Cuv.AddPoint(pp^.x,pp^.y);
       end;
     end;
   dmBSpline:
     begin
       TempCurve.Shape := dmPolygon;
     end;
   end;
finally
   InitdPoints;
end;
end;

// ---------------------------------------------------------------------------

function TCurve.IsInBoundsRect(Ax, Ay: TFloat): boolean;
begin
Try
  With BoundsRect do
    Result := ((x1-delta)<=Ax) and ((x2+delta)>=Ax) and
           ((y1-delta)<=Ay) and ((y2+delta)>=Ay);
except
  Exit;
End;
end;

function TCurve.GetBoundsRect: TRect2d;
var
  I: Integer;
  x1,y1,x2,y2: TFloat;
  d : TPoint2d;
  c,p: TPoint2d;
begin
if FPoints<>nil then
Try
  x1:=1E+10;
  y1:=1E+10;
  x2:=-1E+10;
  y2:=-1E+10;
  If FPoints.Count>0 then
  case Shape of
    dmCircle,dmEllipse:
      begin
         c := Points[0];
         p := Points[1];
         d := Point2d(Abs(c.x-p.x),Abs(c.y-p.y));
         x1 := c.X-d.x;
         x2 := c.X+d.X;
         y1 := c.y-d.Y;
         y2 := c.y+d.Y;
      end;
    dmArc:
      begin
         FillTempCurve;
         Poligonize( TempCurve,10);
         for I:=0 to Pred(TempCurve.Count) do begin
            PPoint:=TempCurve.FPoints.Items[i];
            if PPoint^.x<x1 then x1:=PPoint^.x;
            if PPoint^.x>x2 then x2:=PPoint^.x;
            if PPoint^.y<y1 then y1:=PPoint^.y;
            if PPoint^.y>y2 then y2:=PPoint^.y;
         end;
      end;
    else
        for I:=0 to Pred(FPoints.Count) do begin
            PPoint:=FPoints.Items[i];
            if PPoint^.x<x1 then x1:=PPoint^.x;
            if PPoint^.x>x2 then x2:=PPoint^.x;
            if PPoint^.y<y1 then y1:=PPoint^.y;
            if PPoint^.y>y2 then y2:=PPoint^.y;
        end;
    end;

      Result.x1 := x1;
      Result.y1 := y1;
      Result.x2 := x2;
      Result.y2 := y2;
except
end;
end;

function TCurve.IsOnPoint(Ax, Ay, delta: TFloat): Integer;
// Result = Point index : if P(Ax,Ay) point in delta radius circle;
// Result = -1          : other else
var
  I: Integer;
begin
  Result := -1;
  for I:=0 to Pred(Count) do begin
      if (Abs(Ax-Points[i].x)<=delta) and (Abs(Ay-Points[i].y)<=delta)
      then begin
           CPIndex := i;
           Result := i;
           exit;
      end;
  end;
end;

// Utolsó pont koordinátái
function TCurve.LastPoint: TPoint2d;
    begin
      Result := Points[Count-1];
    end;

// Megvizsgálja, hogy P1-P2 szakasz áttvágja-e a polygont
function TCurve.IsCutLine(P1, P2: TPoint2d): boolean;
var
  I: Integer;
  mp,pp1,pp2: TPoint2d;
begin
  Result := False;
  i:=0;
  While i<=FPoints.Count-1 do begin
      pp1:=GetPoint2d(i);
      if i<FPoints.Count-1 then
         pp2:=GetPoint2d(i+1)
      else
         pp2:=GetPoint2d(0);
      if SzakaszSzakaszMetszes(pp1,pp2,p1,p2,mp) then begin
           Result := True;
           exit;
      end;
      Inc(i);
  end;
end;

// Megvizsgálja, hogy P1-P2 szakasz áttvágja-e a polygont és
// d metszéspont távolságát adja a P1 elsõ ponttól
function TCurve.IsCutLine(P1, P2: TPoint2d; var d : double): boolean;
var
  I: Integer;
  pp1,pp2,mp: TPoint2d;
  dd: double;
begin
  Result := False;
  i:=0;
  d:=10e+10;
  While i<=Pred(Count) do begin
      pp1:=GetPoint2d(i);
      if i<FPoints.Count-1 then
         pp2:=GetPoint2d(i+1)
      else
         pp2:=GetPoint2d(0);
      if SzakaszSzakaszMetszes(pp1,pp2,p1,p2,mp) then begin
         dd:=RelDist2d(P1,mp);
         if dd<d then d:=dd;
         Result := True;
      end;
      Inc(i);
  end;
end;

// Megvizsgálja, hogy P1-P2 szakasz áttvágja-e a polygont
//               Ha igen, akkor megadja a metszéspont koordinátáit (mp);
//               idx pedig az átmetszett szakasz végpontjának indexe
function TCurve.IsCutLine(P1, P2: TPoint2d; var idx: integer; var mp: TPoint2d): boolean;
var
  I: Integer;
  pp1,pp2: TPoint2d;
begin
  Result := False;
  i:=0;
  While i<=FPoints.Count-1 do begin
      pp1:=GetPoint2d(i);
      if i<FPoints.Count-1 then
         pp2:=GetPoint2d(i+1)
      else
         pp2:=GetPoint2d(0);
      if SzakaszSzakaszMetszes(pp1,pp2,p1,p2,mp) then begin
           idx    := i;
           Result := True;
           exit;
      end;
      Inc(i);
  end;
end;

// Meghatározza az objektum kerületét
function TCurve.GetKerulet: double;
var
  I: Integer;
  pp1,pp2: TPoint2d;
begin
  Result := 0;
  for I:=0 to FPoints.Count-2 do begin
      pp1:=GetPoint2d(i);
      pp2:=GetPoint2d(i+1);
      Result := Result + KetPontTavolsaga(pp1.X,pp1.y,pp2.x,pp2.y);
  end;
  if Closed then begin
     pp1:=pp2;
     pp2:=GetPoint2d(0);
     Result := Result + KetPontTavolsaga(pp1.X,pp1.y,pp2.x,pp2.y);
  end;
end;

// Meghatározza az objektum kerületi hosszát Aindex1,Aindex2 pontok között;
function TCurve.GetKeruletSzakasz(Aindex1,Aindex2: integer): double;
var
  I: Integer;
  Idx1,Idx2: integer;
  pp1,pp2: TPoint2d;
  Ker: double;
begin
  Result := 0;
  if Aindex2 = Aindex1 then Exit;
  if Aindex2 > Aindex1 then begin
     Idx1 := Aindex1;
     Idx2 := Aindex2;
  end else begin
     Idx1 := Aindex2;
     Idx2 := Aindex1;
     ker := GetKerulet;
  end;
  for I:=Idx1 to Idx2-1 do begin
      pp1:=GetPoint2d(i);
      pp2:=GetPoint2d(i+1);
      Result := Result + KetPontTavolsaga(pp1.X,pp1.y,pp2.x,pp2.y);
  end;
  if Aindex2 < Aindex1 then Result := Ker-Result;
end;

// Megfordítja a pontsorrendet egy objektumon belül
procedure TCurve.InversPointOrder;
var i: integer;
    x,y: TFloat;
begin
if Enabled then
    if Closed then begin
       GetPoint(0,x,y);
       AddPoint(x,y);
       DeletePoint(0);
       For i:=0 to (FPoints.Count div 2)-1 do
           Fpoints.Exchange(i,Fpoints.Count-1-i);
    end else
    For i:=0 to (FPoints.Count div 2)-1 do
        Fpoints.Exchange(i,Fpoints.Count-1-i);
end;

// End point := First point
procedure TCurve.AbsolutClosed;
var x,y,x1,y1: double;
begin
  If Closed then begin
     GetPoint(0,x,y);
     GetPoint(FPoints.Count-1,x1,y1);
     if (x<>x1) or (y<>y1) then
        AddPoint(x,y);
  end;
end;

procedure TCurve.SetContour(dist: double);
begin

end;

procedure TCurve.SetContourPoints(AIndex: integer; const Value: TPoint2d);
begin

end;

(*
procedure TCurve.SetContour(dist: double);
var i,j,meret,n: longint;
    x,y        : TFloat;
    p0,p1,p2,p3,p4   : TPoint2d;
    pp1,pp2    : TPoint2d;
    E1,E2      : TEgyenes;
    d1,d2      : double;
    Idx1,Idx2  : integer;
    Dir        : boolean;
    metszes    : boolean;
    rAngle     : double;
    alfa1,alfa2: double;
    dif,d      : double;
    fp,fp1,fp2 : TPoint2d;

begin
if (Self<>nil) then
if (Fpoints.Count>2) and Closed then begin
Try

   if Contour = nil then
      Contour := TCurve.Create;
   Contour.ClearPoints;
   Contour.Shape := dmPolygon;
   Contour.Closed := True;


   // Indirekt körüljárás
//   Vektorisation(0.01,Cuv);
   dir := IsDirect;
   if dir then begin
      InversPointOrder;
      dist:=-dist;
   end;

   p0 := GetPoint2d(0);
   p1 := p0;
   n  := Fpoints.Count;
   For i:=1 to n do begin
       p2 := GetPoint2d(i);
       if n=i then
          p2 := p0;
       E1:=SzakaszParhuzamosEltolas(p1,p2,dist, not dir);
       pp1 := Point2d(E1.x1,E1.y1);
       pp2 := Point2d(E1.x2,E1.y2);
       d1  := GetDistance( pp1 );
       d2  := GetDistance( pp2 );

       // Ha az eltolt szakasz végpontjai távolabb vannak mint OutCode
          Contour.AddPoint(pp1);
          Contour.AddPoint(pp2);

       alfa2 := RelAngle2d(p1,p2);
       dif := RelSzogdiff(alfa1,alfa2);
       if (i>1) and (dif<0) then
       begin
            // Hegyeszögeknél a kontúr húr felezõpontját eltoljuk OutCode távra
            fp1 := Contour.GetPoint2d(Contour.Fpoints.Count-3);
            fp2 := Contour.GetPoint2d(Contour.Fpoints.Count-2);
            fp  := FelezoPont(fp1,fp2);
            d   := RelDist2d(p1,fp);
            if d<>0 then begin
            fp  := Point2d(p1.x+(fp.x-p1.x)*dist/d,p1.y+(fp.y-p1.y)*dist/d);
            Contour.InsertPoint(Contour.Fpoints.Count-2,fp.x,fp.y);
            end;
       end;
       p1 := p2;
       alfa1 := alfa2;

   end;
       p2 := Contour.GetPoint2d(0);
       Contour.AddPoint(p2.x,p2.y);
       alfa2 := RelAngle2d(p1,p2);
       dif := RelSzogdiff(alfa1,alfa2);
       if (i>1) and (dif<0) then
       begin
            // Hegyeszögeknél a kontúr húr felezõpontját eltoljuk OutCode távra
            fp1 := Contour.GetPoint2d(Contour.Fpoints.Count-2);
            fp2 := Contour.GetPoint2d(Contour.Fpoints.Count-1);
            fp  := FelezoPont(fp1,fp2);
            d   := RelDist2d(p1,fp);
            if d<>0 then begin
            fp  := Point2d(p1.x+(fp.x-p1.x)*dist/d,p1.y+(fp.y-p1.y)*dist/d);
            Contour.InsertPoint(Contour.Fpoints.Count-1,fp.x,fp.y);
            end;
       end;

finally

  // Megvizsgáljuk, hogy a kontúr minden pontja megfelelõ-e
  // Ha a kontúr 2 szakasza metsz egymást, akkor képezzük a két szakasz
  //    metszéspontját p0 és a közbülsõ pontok kijelölése után az uj metszéspontot
  //    beszúrjuk

  Contour.SelectAllPoints(False);
  i := 0;
  While i < Pred(Contour.Count-1) do begin
      p1 := Contour.Points[i];
      p2 := Contour.Points[i+1];
      metszes := False;
      For j:=i+1 to Pred(Contour.Count-1) do begin
          p3 := Contour.Points[j];
          p4 := Contour.Points[j+1];
          if SzakaszSzakaszMetszes(p1,p2,p3,p4,p0) then begin
             metszes := True;
             Idx1:=i+1; Idx2:=j;
                 for n:=Idx1 to Idx2 do
                     Contour.SelectPoint(n,True);

             Contour.InsertPoint(i+1,p0.x,p0.y);
             Contour.SelectPoint(i+1,False);
             i := j+1;
             Break;
          end;

      end;
      if not metszes then Inc(i);
  end;
  // Töröljük a kijelölt fölösleges pontokat
  Contour.DeleteSelectedPoints;

end;
end;
end;
*)

procedure TCurve.SetContourRadius(const Value: double);
begin
  FContourRadius := Value;
end;

procedure TCurve.SetCrossed(const Value: boolean);
begin
  fCrossed := Value;
end;

function TCurve.GetOldCurveData: TCurveData;
begin
    Result.Name     := Name;
    Result.Closed   := Closed;
    Result.Points   := fPoints.Count;
end;

procedure TCurve.SetOldCurveData(Data: TCurveData);
begin
if Enabled then begin
    Name        := Data.Name;
    Closed      := Data.Closed;
    if Closed then
    Shape       := dmPolygon
    else
    Shape       := dmPolyline;
end;
end;

function TCurve.GetCurveData: TNewCurveData;
begin
    Result.ID       := ID;
    Result.Name     := Name;
    Result.Shape    := Shape;
    Result.Layer    := Layer;
    Result.Font     := Font;
    Result.Selected := Selected;
    Result.Enabled  := Enabled;
    Result.Visible  := Enabled;
    Result.Closed   := Closed;
    Result.Points   := fPoints.Count;
end;

procedure TCurve.SetCurveData(Data: TNewCurveData);
begin
if Enabled then begin
    ID          := Data.ID;
    Name        := Data.Name;
    Shape       := Data.Shape;
    Layer       := Data.Layer;
    Font        := Data.Font;
    Selected    := Data.Selected;
    Enabled     := Data.Enabled;
    Visible     := Data.Visible;
    Closed      := Data.Closed;
end;
end;

procedure TCurve.CurveToRect(Ax, Ay: TFloat);
begin
if Enabled then begin
end;
end;

function TCurve.CurveToText : WideString;

Var i: integer;

  Function BoolText(b:boolean):string;
  begin
    if b then Result := 'True' else Result := 'False';
  end;

begin
  Result := '';
  Result := Result + '[Curve]'+Eoln;
  Result := Result + 'Name     = '+Name+Eoln;
  Result := Result + 'ID       = '+IntToStr(ID)+Eoln;
  Result := Result + 'Shape    = '+DrawModeText[Ord(Shape)]+Eoln;
  Result := Result + 'Layer    = '+IntToStr(Layer)+Eoln;
  Result := Result + 'Font     = '+Font.Name+','+Inttostr(Font.Size)+Eoln;
  Result := Result + 'Selected = '+BoolText(Selected)+Eoln;
  Result := Result + 'Enabled  = '+BoolText(Enabled)+Eoln;
  Result := Result + 'Visible  = '+BoolText(Visible)+Eoln;
  Result := Result + 'Closed   = '+BoolText(Closed)+Eoln;
  Result := Result + 'Points   = '+IntToStr(FPoints.Count)+Eoln;
  Result := Result + '[Points]'+Eoln;
  for I:=0 to Pred(FPoints.Count) do begin
      PPoint:=FPoints.Items[i];
      Result := Result + '  '+IntToStr(I)+' = '+
             Format('%6.2f',[PPoint^.x])+','+Format('%6.2f',[PPoint^.y])+Eoln;
  end;
  Result := Result + Eoln;
end;

procedure TCurve.Changed(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;


constructor TDXFOut.Create(AFromXMin,AFromYMin,AFromXMax,AFromYMax,
                           AToXMin,AToYMin,AToXMax,AToYMax,ATextHeight: TFloat; ADecimals: Byte);
begin
  inherited Create;
  FromXMin:=AFromXMin;
  FromYMin:=AFromYMin;
  FromXMax:=AFromXMax;
  FromYMax:=AFromYMax;
  ToXMin:=AToXMin;
  ToYMin:=AToYMin;
  ToXMax:=AToXMax;
  ToYMax:=AToYMax;
  TextHeight:=ATextHeight;
  Decimals:=ADecimals;
  StringList:=TStringList.Create;
end;
{------------------------------------------------------------------------------}

destructor TDXFOut.Destroy;
begin
  StringList.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.Header;
begin
  LayerName:='0';
  StringList.Add('0');
  StringList.Add('SECTION');
  StringList.Add('2');
  StringList.Add('HEADER');
  StringList.Add('9');
  StringList.Add('$LIMMIN');
  StringList.Add('10');
  StringList.Add(FToA(ToXMin));
  StringList.Add('20');
  StringList.Add(FToA(ToYMin));
  StringList.Add('9');
  StringList.Add('$LIMMAX');
  StringList.Add('10');
  StringList.Add(FToA(ToXMax));
  StringList.Add('20');
  StringList.Add(FToA(ToYMax));
  StringList.Add('0');
  StringList.Add('ENDSEC');
  StringList.Add('0');
  StringList.Add('SECTION');
  StringList.Add('2');
  StringList.Add('TABLES');
  StringList.Add('0');
  StringList.Add('TABLE');
  StringList.Add('2');
  StringList.Add('LAYER');
  StringList.Add('70');
  StringList.Add('1');
  StringList.Add('0');
  StringList.Add('LAYER');
  StringList.Add('2');
  StringList.Add('0');
  StringList.Add('70');
  StringList.Add('64');
  StringList.Add('62');
  StringList.Add('7');
  StringList.Add('6');
  StringList.Add('CONTINUOUS');
  StringList.Add('0');
  StringList.Add('ENDTAB');
  StringList.Add('0');
  StringList.Add('ENDSEC');
  StringList.Add('0');
  StringList.Add('SECTION');
  StringList.Add('2');
  StringList.Add('ENTITIES');
end;
{------------------------------------------------------------------------------}

function TDXFOut.FToA(F: TFloat): Str32;
var
  I: Integer;
begin
  Result:=FloatToStrF(F,ffFixed,16,Decimals);
  I:=Pos(',',Result);
  if I > 0 then Result[I]:='.';
end;
{------------------------------------------------------------------------------}

function TDXFOut.ToX(X: TFloat): TFloat;
var
  Factor,FromDif: TFloat;
begin
  FromDif:=FromXMax - FromXMin;
  if FromDif <> 0.0 then Factor:=(ToXMax - ToXMin) / FromDif else Factor:=1.0;
  Result:=X * Factor;
end;
{------------------------------------------------------------------------------}

function TDXFOut.ToY(Y: TFloat): TFloat;
var
  Factor,FromDif: TFloat;
begin
  FromDif:=FromYMax - FromYMin;
  if FromDif <> 0.0 then Factor:=(ToYMax - ToYMin) / FromDif else Factor:=1.0;
  Result:=Y * Factor;
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.SetLayer(const Name: Str32);
begin
  LayerName:=Name;
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.Layer;
begin
  StringList.Add('8');
  StringList.Add(LayerName);
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.StartPoint(X,Y,Z: TFloat);
begin
  StringList.Add(' 10');
  StringList.Add(FToA(X));
  StringList.Add(' 20');
  StringList.Add(FToA(Y));
  StringList.Add(' 30');
  StringList.Add(FToA(Z));
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.EndPoint(X,Y,Z: TFloat);
begin
  StringList.Add(' 11');
  StringList.Add(FToA(X));
  StringList.Add(' 21');
  StringList.Add(FToA(Y));
  StringList.Add(' 31');
  StringList.Add(FToA(Z));
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.AddText(const Txt: Str32);
begin
  StringList.Add('1');
  StringList.Add(Txt);
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.StartPolyLine(Closed: Boolean);
var
  Flag : Byte;
begin
  StringList.Add('0');
  StringList.Add('POLYLINE');
  Layer;
  StringList.Add('66');
  StringList.Add('1');
  StartPoint(0,0,0);
  Flag:=8;
  if Closed then Flag:=Flag or 1;
  StringList.Add('70');
  StringList.Add(IntToStr(Flag));
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.Vertex(X,Y,Z: TFloat);
var
 Flag : Byte;
begin
  StringList.Add('0');
  StringList.Add('VERTEX');
  Layer;
  StartPoint(X,Y,Z);
  StringList.Add('70');
  Flag:=32;
  StringList.Add(IntToStr(Flag));
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.EndPolyLine;
begin
  StringList.Add('0');
  StringList.Add('SEQEND');
  Layer;
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.Line(X1,Y1,Z1,X2,Y2,Z2: TFloat);
begin
  StringList.Add('0');
  StringList.Add('LINE');
  Layer;
  StartPoint(X1,Y1,Z1);
  EndPoint(X2,Y2,Z2);
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.Point(X,Y,Z: TFloat);
begin
  StringList.Add('0');
  StringList.Add('POINT');
  Layer;
  StartPoint(X,Y,Z);
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.DText(X,Y,Z,Height,Angle: TFloat; const Txt: Str32);
begin
  StringList.Add('0');
  StringList.Add('TEXT');
  Layer;
  StartPoint(X,Y,Z);
  StringList.Add('40');
  StringList.Add(FToA(Height));
  AddText(Txt);
  StringList.Add('50');
  StringList.Add(FToA(Angle));
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.Trailer;
begin
  StringList.Add('0');
  StringList.Add('ENDSEC');
  StringList.Add('0');
  StringList.Add('EOF');
end;

{ TALPaper }

procedure TALPaper.Changed;
begin
  if Assigned(FOnChange) then
     FOnChange(Self);
end;

constructor TALPaper.Create;
begin
  FLeft    := 0;
  FBottom  := 0;
  fWidth   := 100;
  fHeight  := 100;
  FColor   := clWhite;
  FShadow  := true;
  FVisible := true;
end;

procedure TALPaper.SetBottom(const Value: double);
begin
  FBottom := Value;
  Changed;
end;

procedure TALPaper.SetColor(const Value: TColor);
begin
  FColor := Value;
  Changed;
end;

procedure TALPaper.SetHeight(const Value: double);
begin
  FHeight := Value;
  Changed;
end;

procedure TALPaper.SetLeft(const Value: double);
begin
  FLeft := Value;
  Changed;
end;

procedure TALPaper.SetShadow(const Value: boolean);
begin
  fShadow := Value;
  Changed;
end;

procedure TALPaper.SetVisible(const Value: boolean);
begin
  fVisible := Value;
  Changed;
end;

procedure TALPaper.SetWidth(const Value: double);
begin
  FWidth := Value;
  Changed;
end;

{ TSelectedArea }

constructor TSelectedArea.Create;
begin
  FCurve     := TCurve.Create;
  oCurve     := TCurve.Create;
  dCurve     := TCurve.Create;
  OrigList   := TList.Create;
  DestList   := TList.Create;
  fPen       := TPen.Create;
  fPen.Color := clBlue;
  fPen.Width := 2;
  fPen.Mode  := pmCopy;
  fVisible   := False;
  fAllwaysDraw := False;
  FFrameType := satFlex;
  Init;
end;

destructor TSelectedArea.Destroy;
var
  I: Integer;
begin
  for I:=Pred(OrigList.Count) downto 0 do
  begin
    FCurve:=OrigList.Items[I];
    FCurve.Free;
    FCurve:=DestList.Items[I];
    FCurve.Free;
  end;
  OrigList.Free;
  DestList.Free;
  fPen.Free;
  inherited;
end;

// Return the bounding rect of quadrilateral
{ Bounding rect: left-bottom and right-top corners }
function TSelectedArea.GetBoundsRect: TRect2d;
var
  I: Integer;
  x1,y1,x2,y2: TFloat;
  P: TPoint2d;
  rAngle: double;
begin
(*
if Ortho then begin
   rAngle := RotAngle;
   RotAngle := 0;
end;*)
  x1:=1E+10;
  y1:=1E+10;
  x2:=-1E+10;
  y2:=-1E+10;
  for I:=0 to 3 do begin
      P:=Nodes[i];
      if P.x<x1 then x1:=P.x;
      if P.x>x2 then x2:=P.x;
      if P.y<y1 then y1:=P.y;
      if P.y>y2 then y2:=P.y;
  end;
      Result := Rect2d(x1,y1,x2,y2);
//if Ortho then RotAngle := rAngle;
end;

procedure TSelectedArea.SetBoundsRect(const Value: TRect2d);
var B,R: TRect2d;
    cx,cy: double;
    I: Integer;
begin
  B := BoundsRect;
  R := CorrectRealRect(Value);
  for I := 0 to 3 do begin
      cx := ( Nodes[i].x - B.x1 )/( B.x2 - B.x1 );
      cy := ( Nodes[i].y - B.y1 )/( B.y2 - B.y1 );
      Nodes[i].X := R.x1 + cx*(R.x2 - R.x1);
      Nodes[i].Y := R.y1 + cy*(R.Y2 - R.y1);
  end;
  recalc;
end;

function TSelectedArea.GetHeight: double;
var R: TRect2d;
begin
  case FrameType of
  satFix:
    begin

    end;
  satMagnify:
    begin

    end;
  satFlex :
    begin
       R := BoundsRect;
       Result := R.y2-R.y1;
    end;
  end;
  FHeight := Result;
end;

procedure TSelectedArea.SetHeight(const Value: double);
begin
if FHeight<>Value then begin
   FHeight := Value;
   Recalc;
end;
end;

function TSelectedArea.GetWidth: double;
var R: TRect2d;
begin
  case FrameType of
  satFix:
    begin

    end;
  satMagnify:
    begin

    end;
  satFlex :
    begin
       R := BoundsRect;
       Result := R.x2-R.x1;
//       Result := Nodes[1]-Nodes[0];
    end;
  end;
  FWidth := Result;
end;

procedure TSelectedArea.SetWidth(const Value: double);
begin
if FWidth<>Value then begin
   FWidth := Value;
   Recalc;
end;
end;

procedure TSelectedArea.SetZoom(const Value: double);
begin
  if FZoom <> Value then
  begin
       Magnify(Value/FZoom);
       FZoom := Value;
  end;
end;

procedure TSelectedArea.Init;
var
  I: Integer;
begin
  OrigList.Clear;
  DestList.Clear;
  OrigRect := Rect2d(0,0,0,0);
  ActualNode := -1;
  FRotAngle := 0; // fok
  FZoom := 1.0;
  for I := 0 to 9 do
      Nodes[I] := Point2d(0,0);
end;

function TSelectedArea.IsInPoint(p: TPoint2d): boolean;
    var arr: array of TPoint2d;
        i: integer;
    begin
       SetLength(arr,4);
       for i:=0 to 3 do
           arr[i] := Nodes[i];
       Result := IsPointInPoligon( arr, p );
    end;

function TSelectedArea.IsNode(p: TPoint2d; Radius: double; var idx: integer): boolean;
var i: integer;
    d: double;
    re: TRect2d;
begin
  // Radius : graviti radius
  // idx : 0..3 nodes, 4..7: midpoints, 8: RC, 9: RCent
  Result := False;
  idx := -1;
  re := Rect2d(p.x-Radius,p.y+Radius,p.x+Radius,p.y-Radius);
  for i := 0 to 9 do begin
      if PontInKep(Nodes[I].X,Nodes[I].Y,re) then
      begin
        idx := i;
        Result := true;
        Break;
      end;
  end;
end;

procedure TSelectedArea.MoveEdge(idx: integer; dx, dy : double);
var Pcent,Pcur,P: TPoint2d;
    rAngle: double;
    fpIdx : integer;
    ef : TEgyenesFgv;
    fy: double;
    BR: TRect2d;
    w,h,w1,h1: double;
begin
  rAngle := RotAngle;

  // Oldal felezõ pontok mozgatása
  if (idx>3) and (idx<8) then begin
  if Ortho then
  begin
    fpIdx := (idx-2) mod 4;
    FixPoint := Nodes[fpIdx];
    P := Point2d(dx,dy);
    Rotate2D(P,-DegToRad(rAngle));
    RotAngle := 0;
    if (idx=4) or (idx=6) then begin
       dx := 0; dy := P.Y;
    end;
    if (idx=5) or (idx=7) then begin
       dx := P.X; dy := 0;
    end;
  end;
     Nodes[idx mod 4] := Point2d(Nodes[idx mod 4].X+dx, Nodes[idx mod 4].y+dy );
     if idx=7 then idx:=3;
     Nodes[idx-3] := Point2d(Nodes[idx-3].X+dx, Nodes[idx-3].y+dy );
     Recalc;

     if Ortho then begin
        RotAngle := rAngle;
        Move( FixPoint.X-Nodes[fpIdx].X,FixPoint.Y-Nodes[fpIdx].Y);
     end;

     Recalc;
     exit;
  end;

  // Sarok pontok mozgatása
  if (idx>-1) and (idx<4) then begin
  if Ortho then
  begin
    fpIdx := (idx+2) mod 4;
    FixPoint := Nodes[fpIdx];
    RotAngle := 0;
    P := Point2d(dx,dy);
    Rotate2D(P,-DegToRad(rAngle));
    Recalc;
    BR := BoundsRect;       // Befoglaló téglalap
    w  := BR.x2 - BR.x1;    // szélessége
    h  := BR.y2 - BR.y1;    // magassága
    case Idx of
    0,3 : w1 := w - dx;
    1,2 : w1 := w + dx;
    end;
    // Oldalak korrekciója
    h1 := (w1/w)*h;
    SetSize(w1,h1);
    Recalc;
  end else
     Nodes[idx] := Point2d(Nodes[idx].X+dx, Nodes[idx].y+dy );

     if Ortho then begin
        RotAngle := rAngle;
        Move( FixPoint.X-Nodes[fpIdx].X,FixPoint.Y-Nodes[fpIdx].Y);
     end;
     Recalc;
     exit;
  end;
end;

// Orto mode: az oldalfelezõ pontok a téglalap oldalait ||-an tolja el;
// a sarokpontok pedig nagyítanak az aspect ratio megtartásával
procedure TSelectedArea.OrthoTransform(NodeIdx: integer; CurPos: TPoint2d);
var pIdx: integer;
    oldRotAngle : double;
    cP: TPoint2d;  // Kurzorpozíció
begin
if NodeIdx<8 then
begin
  oldRotAngle := RotAngle;
  // Fix pont meghatározása
  case NodeIdx of
  0..3: pIdx := (NodeIdx + 2) mod 4;
  4..7: pIdx := (NodeIdx + 3) mod 4;
  end;
  FixPoint := Nodes[pIdx];
  // Fix ponttal keret eltolása az origóba és -RotAngle elforgatása
  Move(-FixPoint.X,-FixPoint.Y);
  Rotate( Point2d(0,0),-RotAngle );
  // Kursor eltolás és elforgatás
  cP := SubPoints( CurPos, FixPoint );
  Rotate2D( cP, -RotAngle );
  // Oldalak átméretezése
//  if NodeIdx=4 then SetSize( cp.y);

  // Visszaforgatás és visszatolás a fix pontba
  Rotate( Point2d(0,0),RotAngle );
  Move(FixPoint.X,FixPoint.Y);
  RotAngle := oldRotAngle;
end;
end;

// Magnify from Cent
procedure TSelectedArea.Magnify(coeff: double);
var B,R: TRect2d;
    C  : TPoint2d; // Középpont
    dx,dy : double;
begin
  B  := BoundsRect;
  C  := Point2d((B.x2+B.x1)/2,(B.y1+B.y2)/2);
  dx := coeff * (C.X - B.x1);
  dy := coeff * (C.y - B.y1);
  R  := Rect2d( C.X-dx, C.Y-dy, C.X+dx, C.Y+dy );
  BoundsRect := R;
  Recalc;
end;

procedure TSelectedArea.Mirror(idx: integer);
Var R: TRect2d;
    CP: TPoint2d;
    i: integer;
begin
  R := BoundsRect;
  CP := Point2d( (R.x1+R.x2)/2, (R.y1+R.y2)/2 );
  case idx of
  1: // Verical mirror
       for I := 0 to 9 do
           Nodes[i].Y := 2*CP.Y - Nodes[i].Y;
  2: // Horizontal mirror
       for I := 0 to 9 do
           Nodes[i].X := 2*CP.X - Nodes[i].X;
  3: // Central mirror
       for I := 0 to 9 do
       begin
           Nodes[i].X := 2*CP.X - Nodes[i].X;
           Nodes[i].Y := 2*CP.Y - Nodes[i].Y;
       end;
  end;
  Recalc;
end;

procedure TSelectedArea.Move(dx, dy : double);
var i: integer;
begin
  for I := 0 to 9 do
      Nodes[i] := Point2d(Nodes[i].X+dx, Nodes[i].y+dy );
  Recalc;
end;

procedure TSelectedArea.SetAllwaysDraw(const Value: boolean);
begin
  FAllwaysDraw := Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TSelectedArea.SetOrigRect(const Value: TRect2d);
begin
  FOrigRect := CorrectRealRect(Value);
  Nodes[0]  := Point2d(FOrigRect.x1,FOrigRect.y2);
  Nodes[1]  := Point2d(FOrigRect.x2,FOrigRect.y2);
  Nodes[2]  := Point2d(FOrigRect.x2,FOrigRect.y1);
  Nodes[3]  := Point2d(FOrigRect.x1,FOrigRect.y1);
  recalc;
end;

procedure TSelectedArea.RelRotate( P: TPoint2d );
var ra0 : double;
begin
  ra0 := RelAngle2D( RCent, P );
  Self.RelRotate( ra0 );
end;

// Cent pont körül forgatja el a keretet
procedure TSelectedArea.Rotate(Cent: TPoint2d; Angle: double);
var i: integer;
begin
  for I := 0 to 7 do
      RelRotate2D( Nodes[i], Cent, Rad(angle) );
  FRotAngle := Angle;
  Recalc;
end;

// RCent (keret centruma) körül forgatja el a keretet
procedure TSelectedArea.RelRotate(angle: double);
var i: integer;
begin
  for I := 0 to 7 do
      RelRotate2D( Nodes[i], RCent, Rad(angle) );
  FRotAngle := FRotAngle + angle;
  Recalc;
end;

procedure TSelectedArea.SetRect(R: TRect2d);
begin
  CorrectRealRect(R);
  Nodes[0] := Point2d(R.x1,R.y2);
  Nodes[1] := Point2d(R.x2,R.y2);
  Nodes[2] := Point2d(R.x2,R.y1);
  Nodes[3] := Point2d(R.x1,R.y1);
  Recalc;
end;

procedure TSelectedArea.SetRotAngle(const Value: double);
begin
  if FRotAngle <> Value then begin
     RelRotate( Value-FRotAngle );
  end;
  if Assigned(FOnChange) then FOnChange(Self);
end;

// Resize the area from left-bottom point
procedure TSelectedArea.SetSize(w, h: double);
var wo,wh  : double;
    p0,p1  : TPoint2d;
    R      : TRect2d;
    rAngle : double;
begin
if Ortho then begin
   rAngle := RotAngle;
   RotAngle := 0;
end;
  R := GetBoundsRect;
  CorrectRealRect(R);
  p0 := R.P1;
  p1 := Point2d( p0.X+w,p0.Y+h);
  R  := Rect2d(p0.x,p0.y,p1.X,p1.Y);
  SetBoundsRect(R);
if Ortho then
   RotAngle := rAngle;
end;

procedure TSelectedArea.SetNode(idx: integer; p: TPoint2d);
begin
  if idx<=High(Nodes) then
  begin
    Nodes[idx] := p;
    Recalc;
  end;
end;

procedure TSelectedArea.SetVisible(const Value: boolean);
begin
  FVisible := Value;
  if not fVisible then
     Init;
  if Assigned(FOnChange) then FOnChange(Self);
  if Assigned(FOnVisible) then FOnVisible(Self);
end;

procedure TSelectedArea.AddCurve(Cuv: TCurve);
var oC,dC: TCurve;
    I: Integer;
begin
  oC:= TCurve.Create;
  oC.ID    := Cuv.FID;
  oC.Name  := Cuv.FName;
  oC.Shape  := Cuv.Shape;
  oC.Closed := Cuv.Closed;
  oC.ClearPoints;
  dC:= TCurve.Create;
  dC.ID    := Cuv.FID;
  dC.Name  := Cuv.FName;
  dC.Shape  := Cuv.Shape;
  dC.Closed := Cuv.Closed;
  dC.ClearPoints;
  for I := 0 to Pred(Cuv.Count) do begin
      oC.AddPoint(Cuv.GetPoint2d(I));
      dC.AddPoint(Cuv.GetPoint2d(I));
  end;
  OrigList.Add(oC);
  DestList.Add(dC);
end;

procedure TSelectedArea.Recalc;
Var i,j            : integer;
    oPoint,dPoint  : TPoint2d;      // Point from OrigList and DestList
    aP             : TPoint2d;
    A_B,D_C        : TPoint2d;      // Vectors to real point
    P              : TPoint2d;      // Transformed point
    ef1,ef2,ef3    : TEgyenesfgv;
    w,h            : double;        // OrigRect width / height
    R              : TRect2d;
begin
     // midpoints
       Nodes[4] := FelezoPont(Nodes[0],Nodes[1]);
       Nodes[5] := FelezoPont(Nodes[1],Nodes[2]);
       Nodes[6] := FelezoPont(Nodes[2],Nodes[3]);
       Nodes[7] := FelezoPont(Nodes[3],Nodes[0]);

     // Rotation centrum
       RC  := Elometszes(Nodes[0],Nodes[1],0.2,0.2);     // Rotation point
       Nodes[8] := RC;
       ef1  := KeTPontonAtmenoEgyenes(RC,Nodes[4]);
       ef2  := KeTPontonAtmenoEgyenes(Nodes[2],Nodes[3]);
       P    := KetEgyenesMetszespontja(ef1,ef2);
       RCent:= FelezoPont(Nodes[4],P);
       Nodes[9] := RCent;

       w  := SzakaszSzog(Nodes[0].X,Nodes[0].Y,Nodes[1].x,Nodes[1].y);
       FRotAngle := RadToDeg(w);

  if OrigList.Count>0 then begin
     w := OrigRect.x2-OrigRect.x1;
     h := OrigRect.y2-OrigRect.y1;

     for I := 0 to Pred(OrigList.Count) do begin
         oCurve := OrigList.Items[i];
         dCurve := DestList.Items[i];
         if oCurve<>nil then begin
            for j := 0 to Pred(oCurve.FPoints.Count) do
            begin
                oPoint := TCurve(OrigList.Items[i]).GetPoint2d(j);          // Original pont
                // Get multiplicator (normalisation)
                aP.X   := (oPoint.X-OrigRect.x1)/w;
                aP.Y   := (OrigRect.y2-oPoint.Y)/h;
                A_B    := Osztopont(Nodes[0],Nodes[1],aP.x);
                D_C    := Osztopont(Nodes[3],Nodes[2],aP.x);
                P      := Osztopont(A_B,D_C,aP.Y);
                TCurve(DestList.Items[i]).Points[J] := p;
            end;
         end;
     end;

  end;
  if Assigned(FOnChange) and FAllwaysDraw then FOnChange(Self);
end;

// ================ End of TSelectedArea ===============================

function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;

function AL_InputQuery( x,y : integer; ACaption, APrompt: string;
                             VisibleButtons: boolean;  var Value: string): Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
  w,h: integer;
begin
  Result := False;
  Form := TForm.Create(Application);
  with Form do
    try
      Canvas.Font := Font;
      DialogUnits := GetAveCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption := ACaption;
      ClientWidth := MulDiv(128, DialogUnits.X, 4);
      if VisibleButtons then
         ClientHeight := MulDiv(63, DialogUnits.Y, 8)
      else
         ClientHeight := MulDiv(40, DialogUnits.Y, 8);
      w := ClientWidth;
      h := 2*ClientHeight;
      if (x-ClientWidth)<0 then x:=0;
      if (x+ClientWidth)>Screen.Width then x:=Screen.Width-ClientWidth;
      if (y+h)>Screen.Height then y:=Screen.Height-h;
      Left := x;
      Top  := y;
      Prompt := TLabel.Create(Form);
      with Prompt do
      begin
        Parent := Form;
        AutoSize := True;
        Left := MulDiv(8, DialogUnits.X, 4);
        Top := MulDiv(8, DialogUnits.Y, 8);
        Caption := APrompt;
      end;
      Edit := TEdit.Create(Form);
      with Edit do
      begin
        Parent := Form;
        Left := Prompt.Left;
        Top := MulDiv(19, DialogUnits.Y, 8);
        Width := MulDiv(40, DialogUnits.X, 4);
        MaxLength := 255;
        Text := Value;
        SelectAll;
      end;
      ButtonTop := MulDiv(41, DialogUnits.Y, 8);
      ButtonWidth := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := 'OK';
        ModalResult := mrOk;
        Default := True;
        if VisibleButtons then
        SetBounds(MulDiv(10, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight)
        else
        SetBounds(0,0,0,0);
      end;
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := 'Cancel';
        ModalResult := mrCancel;
        Cancel := True;
        if VisibleButtons then
        SetBounds(MulDiv(68, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight)
        else
        SetBounds(0,0,0,0);
      end;
      if ShowModal = mrOk then
      begin
        Value := Edit.Text;
        Result := True;
      end;
    finally
      Form.Free;
    end;
end;

{ TBMPObject }

procedure TBMPObject.Changed;
begin if Assigned(FOnChange) then FOnChange(Self); end;

procedure TBMPObject.Clear;
begin
  origBMP.FreeImage;
  origBMP.Free;
  BMP.FreeImage;
  BMP.Free;
  origBMP := TBitmap.Create;
  BMP := TBitmap.Create;
  Changed;
end;

constructor TBMPObject.Create;
begin
  origBMP   := TBitmap.Create;
  BMP       := TBitmap.Create;
  FPosition := TPoint2DObj.Create;
  FZoom     := 1.0;
end;

destructor TBMPObject.Destroy;
begin
  BMP.Free;
  origBMP.Free;
  FPosition.Free;
  inherited;
end;

function TBMPObject.GetBoundsRect: TRect2d;
begin
  // befoglaló téglalap (Left,top,left+width, bottom)
  Result := Rect2d(FPosition.x, FPosition.y+FZoom*BMP.Height,
         FPosition.x+FZoom*BMP.Width, FPosition.y );
end;

function TBMPObject.LoadFromFile(fn: string): boolean;
var
  W: TWICImage;
begin
  Result := True;
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
    origBmp.Assign(BMP);
  finally
    W.Free;
    Changed;
  end;
end;

function TBMPObject.PasteFromClipboard: boolean;
begin
  Result := false;
  if Clipboard.HasFormat(CF_PICTURE) then begin
    origBMP.Assign(Clipboard);
    origBMP.PixelFormat := pf24bit;
    BMP.Assign(origBMP);
    Result := true;
    Changed;
  end;
end;

procedure TBMPObject.RestoreOriginal;
begin
  BMP.Assign(OrigBMP);
end;

procedure TBMPObject.SetPosition(const Value: TPoint2dObj);
begin
  // befoglaló téglalap bal alsó sarka
  FPosition := Value;
  Changed;
end;

procedure TBMPObject.SetVisible(const Value: boolean);
begin
  fVisible := Value;
  Changed;
end;

procedure TBMPObject.SetZoom(const Value: double);
begin
  FZoom := Value;
  Changed;
end;

procedure TBMPObject.Lightness( Amount: integer );
var
Wsk:^Byte;
H,V: Integer;

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
  RestoreOriginal;
  for V:=0 to BMP.Height-1 do begin
    WSK:=BMP.ScanLine[V];
    for H:=0 to BMP.Width*3-1 do
    begin
    if Amount>0 then
       Wsk^:=IntToByte(Wsk^+((255-Wsk^)*Amount)div 255)
    else
       Wsk^:=IntToByte(Wsk^+(Wsk^*Amount)div 255);
    inc(Wsk);
    end;
  end;
  Changed;
end;


end.


