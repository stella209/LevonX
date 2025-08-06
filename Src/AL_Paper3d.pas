  (*

  TALSablon3d Delphi component (Tested in D5)
  -------------------------------------------
  By Agócs László Hungary (StellaSOFT)

  3D graphical component for special 3d vector graphics visualisation
  and editing function,

  *)


unit AL_Paper3d;

interface

Uses
    Windows, SysUtils, Classes, Graphics, Controls, StdCtrls, ClipBrd, Math,
    Extctrls, Messages, Dialogs, NewGeom, DGrafik, B_Spline, Szoveg, Szamok,
    StObjects, Forms;

Type
  TFloat = Double;
  Str32 = string[32];
  TMarkType = (mtBox,mtCircle,mtCross);
  TMarkSize = 2..8;

  TActionMode = (amNone, amDrawing, amPaning, amZooming, amPainting,
                 amSelect,
                 amInsertPoint, amDeletePoint, amMovePoint,amSelectPoint,
                 amChangePoint, amDeleteSelected, amMoveSelected, amRotateSelected,
                 amNewBeginPoint, amMagnifySelected,  amSelectArea, amSelectAreaEx,
                 amAutoPlan, amTestWorking);

  TDrawMode = (dmNone, dmPoint, dmLine, dmRectangle, dmPolyline, dmPolygon,
               dmCircle, dmEllipse, dmArc, dmChord, dmSpline, dmBspline, dmText,
               dmFreeHand);

  TInCode = (icIn,        // Cursor in Curve
             icOnLine,    // Cursor on Curve's line
             icOnPoint,   // Cursor is on any Point;
             icOut        // Cursor out of Curve
             );

  PPointRec = ^TPointRec;
  TPointRec = record
             X: TFloat;
             Y: TFloat;
             Selected: boolean;
           end;

  {Gyártási pozíció}
  TWorkPosition = record
    CuvNumber   : integer;      {Aktuális obj. sorszáma}
    PointNumber : integer;      {Aktuális pont sorszáma}
    WorkPoint   : TPoint3d;    {Aktuális pont koordinátái}
  end;

  { Polzgon metszések vizsgálatához}
  TmpRec = record
       Cuvidx   : integer;   // Polygon sorszáma
       Pointidx : integer;   // legközelebbi pontjának sorszáma
       d        : double;    // Távolsága
  end;

  TNewGraphData = record //Graphstructur for SaveGraphToFile/LoadGraphFromFile
    Copyright   : Str32;
    Version     : integer;
    GraphTitle  : Str32;
    Curves      : integer;
    Dummy       : Array[1..128] of byte;
  end;

  TNewCurveData = record //Datenstruktur for SaveCurveToStream/LoadCurveFromStream
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

  // 3D Specifications
  // ========================================================================

  PPointRec3d = ^TPointRec3d;
  TPointRec3d = record
             X: TFloat;
             Y: TFloat;
             Z: TFloat;
             Selected: boolean;
           end;

  PPointArray = ^TPointArray;
  TPointArray = array[0..0] of TPoint;

  PPointArray3d = ^TPointArray3d;
  TPointArray3d = array[0..0] of TPoint3d;

  {3d point object}
  TPoint3dObj = Class(TPersistent)
  private
    fx,fy,fz : extended;
    FOnChange: TNotifyEvent;
    procedure Setx(Value:extended);
    procedure Sety(Value:extended);
    procedure Setz(Value: extended);
    procedure Changed; dynamic;
  public
    constructor Create;
  published
    property x:extended read fx write Setx;
    property y:extended read fy write Sety;
    property z:extended read fz write Setz;
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

  // Graphical object
  TCurve3d = class(TPersistent)
  private
    FID  : integer;
    FName: Str32;
    FEnabled: Boolean;
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
    procedure Changed(Sender: TObject);
    procedure SetSelected(const Value: boolean);
    procedure SetShape(const Value: TDrawMode);
    procedure SetLayer(const Value: byte);
    procedure SetFont(const Value: TFont);
    procedure SetClosed(const Value: boolean);
    procedure SetEnabled(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
    procedure SetName(const Value: Str32);
    procedure SetAngle(const Value: TFloat);
    function GetPointArray(AIndex: integer): TPoint3d;
    procedure SetPoints(AIndex: integer; const Value: TPoint3d);
    function GetCount: integer;
    procedure SetSigned(const Value: boolean);
    procedure SetPointRec(AIndex: integer; const Value: TPointRec3d);
  public
    FPoints       : TList;
    PPoint        : PPointRec3d;    // Pointer for pointrec3d
    CPIndex       : Integer;        // Matching point index
    PointsArray   : array of TPoint3d;
    constructor Create;
    destructor Destroy; override;

    procedure ClearPoints;
    procedure AddPoint(Ax,Ay,Az: TFloat); overload;
    procedure AddPoint(Ax,Ay: TFloat); overload;
    procedure AddPoint(P: TPoint3d); overload;
    procedure AddPoint(P: TPointRec3d); overload;
    procedure GetPoint(AIndex: Integer; var Ax,Ay,Az: TFloat); overload;
    procedure GetPoint(AIndex: Integer; var Ax,Ay: TFloat); overload;
    function  GetPoint2d(AIndex: Integer): TPoint2d;
    function  GetPoint3d(AIndex: Integer): TPoint3d;
    function  GetPointRec(AIndex: Integer): TPointRec3d;
    procedure ChangePoint(AIndex: Integer; Ax,Ay,Az: TFloat); overload;
    procedure ChangePoint(AIndex: Integer; pr: TPointRec3d); overload;
    procedure InsertPoint(AIndex: Integer; Ax,Ay,Az: TFloat); overload;
    procedure InsertPoint(AIndex: Integer; pr: TPointRec3d); overload;
    procedure SelectPoint(AIndex: Integer; Sel: boolean);
    procedure DeletePoint(AIndex: Integer);
    procedure InversPointOrder;
    procedure AbsolutClosed;

    procedure MoveCurve(Ax,Ay,Az: TFloat);
    procedure MoveSelectedPoints(Ax,Ay,Az: TFloat);
    procedure MagnifyCurve(Cent: TPoint2d; Magnify: TFloat);
    procedure RotateCurve(Cent : TPoint2d; Angle: TFloat);

    function  IsInBoundsRect(Ax, Ay: TFloat): boolean;
    function  IsOnPoint(Ax, Ay, delta: TFloat): Integer;
    function  IsInCurve(Ax, Ay: TFloat): TInCode; overload;
    function  IsInCurve(P: TPoint2d): TInCode; overload;
    function  IsCutLine(P1,P2: TPoint2d): boolean; overload;
    function  IsCutLine(P1, P2: TPoint2d; var d : double): boolean; overload;
    function  GetKerulet: double;
    function  GetKeruletSzakasz(Aindex1,Aindex2: integer): double;
    function  GetNearestPoint(p: TPoint2d; var pIdx: integer): TFloat;
    function  GetBoundsRect: TRect2d;
    function  IsDirect: boolean;
    procedure FillPointArray;

    function  GetCurveData: TNewCurveData;
    procedure SetCurveData(Data: TNewCurveData);

    function  CurveToText: WideString;

    function SaveToStream(stm: TStream): boolean;
    function LoadFromStream(stm: TStream): boolean;

    property Count: integer read GetCount;   // Pontok száma
    property BoundsRect: TRect2d read GetBoundsRect;
    property ParentID: integer read FParentID write FParentID;
    property Sorted: boolean read FSorted write FSorted;
    property Points[AIndex: integer] : TPoint3d read GetPointArray write SetPoints;
    property PointRec[AIndex: integer] : TPointRec3d read GetPointRec write SetPointRec;
  published
    property ID: Integer read FID write FID;
    property Name: Str32 read FName write SetName;
    property Layer: byte read FLayer write SetLayer default 0;
    property Font: TFont read FFont write SetFont;
    property Angle: TFloat read fAngle write SetAngle;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Visible: Boolean read FVisible write SetVisible;
    property Closed: boolean read fClosed write SetClosed;
    property Selected: boolean read fSelected write SetSelected;
    property Shape: TDrawMode read fShape write SetShape;
    property Signed: boolean read fSigned write SetSigned;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  // DataSource for store graphical objects

  TCurveList3d = class(TList)
  private
    FSensitiveRadius: integer;
    fSelected: TCurve3d;
    procedure Changed(Sender: TObject);
    procedure SetSelected(const Value: TCurve3d);
    procedure SetSensitiveRadius(const Value: integer);
  protected
    FCurve              : TCurve3d;     // Cuve for general purpose
  public
    TempCurve     : TCurve3d;     // Temporary curve for not poligonized objects: Ex. Spline
    CPMatch       : Boolean;    // Matching point
    CurveMatch    : Boolean;    // Matching curve
    CurveIn       : boolean;    // point in curve
    CPCurve       : Integer;    // Actual curve index
    LastCPCurve   : Integer;
    CPIndex       : Integer;    // Actual point number
    LastCPIndex   : Integer;
    CPx           : TFloat;
    CPy           : TFloat;
    CPz           : TFloat;

    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    { Curves and process}
    function MakeCurve(const AName: Str32; ID: integer; Shape: TDrawMode;
             AEnabled, AVisible, AClosed: Boolean): Integer;
    procedure Clear;
    function  AddCurve(ACurve: TCurve3d):integer;
    procedure DeleteCurve(AItem: Integer);
    procedure DeleteSelectedCurves;
    procedure InsertCurve(AIndex: Integer; Curve: TCurve3d);
    function  GetCurveName(H: Integer): Str32;
    function  GetCurveHandle(AName: Str32; var H: Integer): Boolean;

    { Points }
    procedure AddPoint(AIndex: Integer; X, Y: TFloat); overload;
    procedure AddPoint(AIndex: Integer; X, Y, Z: TFloat); overload;
    procedure AddPoint(AIndex: Integer; P: TPoint2d); overload;
    procedure InsertPoint(AIndex,APosition: Integer; X,Y: TFloat); overload;
    procedure InsertPoint(AIndex,APosition: Integer; P: TPoint2d); overload;
    procedure DeletePoint(AIndex,APosition: Integer);
    procedure DeleteSamePoints(diff: TFloat);
    procedure ChangePoint(AIndex,APosition: Integer; X,Y: TFloat);
    procedure DoMove(Dx,Dy: Integer);  // Move a point in curve
    procedure GetPoint(AIndex,APosition: Integer; var X,Y,Z: TFloat);overload;
    procedure GetPoint(AIndex,APosition: Integer; var X,Y: TFloat);overload;
    function  GetMaxPoints: Integer;
    function  GetNearestPoint(p: TPoint2d; var cuvIdx, pIdx: integer): TFloat;
    procedure SetBeginPoint(ACurve,AIndex: Integer);
    { Transforms of Curves }
    procedure MoveCurve(AIndex :integer; Ax, Ay: TFloat);overload;
    procedure MoveCurve(AIndex :integer; Ax, Ay, Az: TFloat);overload;
    procedure MoveSelectedCurves(Ax, Ay: TFloat);overload;
    procedure MoveSelectedCurves(Ax, Ay, Az: TFloat);overload;
    procedure RotateSelectedCurves(Cent : TPoint2d; Angle: TFloat); overload;
    procedure RotateSelectedCurves(Cent : TPoint3d; Angle: TFloat); overload;
    procedure InversSelectedCurves;
    procedure InversCurve(AIndex: Integer);
    procedure SelectCurveByName(aName: string);
    procedure SelectCurve(AIndex: Integer);
    procedure PoligonizeAll(PointCount: integer);
    procedure Poligonize(Cuv: TCurve3d; Count: integer);
    procedure VektorisationAll(MaxDiff: TFloat);
    procedure Vektorisation(MaxDiff: TFloat; Cuv: TCurve3d);
    procedure PontSurites(Cuv: TCurve3d; Dist: double);
    procedure PontSuritesAll(Dist: double);

    procedure CheckCurvePoints(X, Y: Integer); overload;
    procedure CheckCurvePoints(X, Y, Z: Integer); overload;

    { Seect }
    procedure SelectAll(all: boolean);
    procedure SelectAllInArea(R: TRect2D);
    procedure SelectAllInAreaEx(R: TRect2d); // Select only points
    procedure ClosedAll(all: boolean);
    procedure SelectAllPolylines;
    procedure SelectAllPolygons;
    procedure SelectParentObjects;
    procedure SelectChildObjects;
    procedure EnabledAll(all: boolean);
    procedure SignedAll(all: boolean);
    function  GetSignedCount: integer;
    procedure SignedNotCutting;

    { Transformations }
    procedure Normalisation(Down: boolean);
    procedure Eltolas(dx,dy: double);
    procedure Nyujtas(tenyezo:double);
    procedure CentralisNyujtas(Cent: TPoint2d; tenyezo: double);
    procedure MagnifySelected(Cent: TPoint2d; Magnify: TFloat);

    { Streams and Files }
    function SaveCurveToStream(FileStream: TStream; Item: Integer): Boolean;
    function LoadCurveFromStream(FileStream: TStream): Boolean;
    function LoadCurveFromFile(const FileName: string): Boolean;
    procedure SaveGraphToMemoryStream(var stm: TMemoryStream);
    procedure LoadGraphFromMemoryStream(stm: TMemoryStream);
    function SaveGraphToFile(const FileName: string): Boolean;
    function LoadGraphFromFile(const FileName: string): Boolean;

    property Selected: TCurve3d read fSelected write SetSelected;
    property SensitiveRadius: integer read FSensitiveRadius write SetSensitiveRadius;
  end;


  // Event fron changing drawmode
  TChangeMode = procedure(Sender: TObject; ActionMode: TActionMode; DrawMode: TDrawMode) of object;
  // Event fron changing window dimension
  TChangeWindow = procedure(Sender: TObject; x0,y0,Zoom: real; MouseX,MouseY: real) of object;
  TMouseEnter = procedure(Sender: TObject) of object;
  TNewBeginPoint = procedure(Sender: TObject; Curve: integer) of object;
  TChangeCurve = procedure(Sender: TObject; Curve: TCurve3d; Point: integer) of object;
  TUndoRedoChangeEvent = procedure(Sender: TObject; Undo,Redo:boolean) of object;
  TCutPlan = procedure(Sender: TObject; Curve: TCurve3d; Point: integer) of object;
  TProcess = procedure(Sender: TObject; Percent: integer) of object;
  TAutoSortEvent = procedure(Sender: TObject; Status: byte; ObjectNo: word) of object;

  TALCustomSablon3d = class(TCustomControl)
  private
    DrawBmp: TBitMap;
    fCoordLabel: TLabel;
    fCentrum: T2dPoint;
    fOrigo: TPoint2d;
    fWorkOrigo: TPoint3d;
    fPaper: T2dPoint;
    fZoom: extended;
    FPaperVisible: boolean;
    fPaperColor: TColor;
    fBackColor: TColor;
    fCentralCross: boolean;
    fGrid: TGrid;
    fHinted: boolean;
    Hint1   : THintWindow;
    HintActive : boolean;
    oldHintStr: string;
    fCursorCross: boolean;
    FDrawMode: TDrawMode;
    FSensitiveRadius: integer;
    fShowPoints: boolean;
    fWorking: boolean;
    fDefaultLayer: Byte;
    fChangeMode: TChangeMode;
    fActionMode: TActionMode;
    fActLayer: integer;
    fpFazis: integer;
    fNewBeginPoint: TNewBeginPoint;
    fChangeWindow: TChangeWindow;
    fChangeCurve: TChangeCurve;
    fSelected: TCurve3d;
    FGraphTitle: Str32;
    fLocked: boolean;
    FWorkArea: TRect;
    FTitleFont: TFont;
    fAutoUndo: boolean;
    FUndoRedoChangeEvent: TUndoRedoChangeEvent;
    FLoading: boolean;
    FMouseEnter: TMouseEnter;
    FMouseLeave: TMouseEnter;
    fChanged: boolean;
    FDemo: boolean;
    FSTOP: boolean;
    FSablonSzinkron: boolean;
    FMMPerLepes: extended;
    fChangeSelected: TChangeCurve;
    FConturRadius: double;
    FAutoSortEvent: TAutoSortEvent;
    FPlan: TProcess;
    FTestSpeed: double;
    fChangeAll: TNotifyEvent;
    procedure SetZoom(const Value: extended);
    procedure SetPaperVisible(const Value: boolean);
    procedure SetBackColor(const Value: TColor);
    procedure SetPaperColor(const Value: TColor);
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMEraseBkGnd(var Message:TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure CMMouseEnter(var msg:TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var msg: TMessage); message CM_MOUSELEAVE;
    Procedure CMChildkey( Var msg: TCMChildKey ); message CM_CHILDKEY;
    procedure SetCentralCross(const Value: boolean);
    procedure GridDraw;
    procedure DrawMouseCross(o:TPoint;PenMode:TPenMode);
    procedure SetCursorCross(const Value: boolean);
    function  GetWindow: TRect2d;
    procedure SetWindow(const Value: TRect2d);
    procedure SetDrawMode(const Value: TDrawMode);
    procedure SetSensitiveRadius(const Value: integer);
    procedure SetShowPoints(const Value: boolean);
    procedure SetWorking(const Value: boolean);
    procedure SetDefaultLayer(const Value: Byte);
    procedure SetActionMode(const Value: TActionMode);
    procedure SetpFazis(const Value: integer);
    procedure SetSelected(const Value: TCurve3d);
    procedure SetGraphTitle(const Value: Str32);
    procedure SetLocked(const Value: boolean);
    procedure SetWorkArea(const Value: TRect);
    procedure SetTitleFont(const Value: TFont);
    procedure SetLoading(const Value: boolean);
    procedure SetWorkOrigo(const Value: TPoint3d);
    procedure ReOrderNames;
    function GetDisabledCount: integer;
    procedure SetCentrum(const Value: T2dPoint);
  protected
    UR                  : TUndoRedo;  // Undo-Redo object
    FCurve              : TCurve3d;   // Cuve for general purpose
    oldCentrum          : TPoint2d;   //
    Origin,MovePt       : TPoint;
    oldOrigin,oldMovePt : TPoint;
    MouseInOut          : integer;    // Egér belép:1, bent van:0, kilép:-1
    h                   : integer;    // New Curve handle
    rrect               : TRect2d;    // Rectangle for rect or window
    polygonContinue     : boolean;    // Polygon continue;
    MaxPointsCount      : integer;    // Max. point in Curve
    // Rotation variables
    RotCentrum          : TPoint2d;   // Centrum of rotation
    RotStartAngle       : TFloat;     // Rotate curves start angle
    RotAngle            : TFloat;     // Rotation angle
    oldCursorCross      : boolean;

    Paning              : boolean;
    Zooming             : boolean;
    painting            : boolean;
    HClip               : HRgn;
    oldCursor           : TCursor;

    DXFOut              : TDXFOut;

    VirtualClipboard : TMemoryStream;   // Store List of vectorial curves for public
    ClipboardStr     : WideString;      // Save draw to clipboard as text

    procedure Change(Sender: TObject);
    procedure ChangeCentrum(Sender: TObject);
    procedure ChangePaperExtension(Sender: TObject);
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
  public
    FCurveList    : TList;      // List of vectorial curves
    TempCurve     : TCurve3d;   // Temporary curve for not poligonized objects: Ex. Spline
    CPMatch       : Boolean;    // Matching point
    CurveMatch    : Boolean;    // Matching curve
    CurveIn       : boolean;    // point in curve
    CPCurve       : Integer;
    LastCPCurve   : Integer;
    CPIndex       : Integer;
    LastCPIndex   : Integer;
    CPx           : TFloat;
    CPy           : TFloat;
    MousePos      : TPoint;     // Mouse x,y position
    ActText       : Str32;
    InnerStream   : TMemoryStream;     // memorystream for inner use
    oldFile       : boolean;
    WorkPosition  : TWorkPosition;
    WRect         : TRect;             {A munkapont alatti terület mentéséhez}
    WBmp          : TBitmap;
    Moving        : boolean;
    pClosed,pOpened,pSelected : TPen;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    { Világ koordináták (W) képernyõ koordináttákká (S) ill. vissza }
    function  XToW(x:integer):TFloat;
    function  YToW(y:integer):TFloat;
    function  XToS(x:TFloat):integer;
    function  YToS(y:TFloat):integer;
    function  WToS(x,y:TFloat):TPoint;
    function  SToW(x,y: integer):TPoint2d;
    function  OrigoToCent:TPoint2D;
    function  CentToOrigo(c:TPoint2D):TPoint2D;
    {Teljes papír az ablakban}
    procedure ZoomPaper;
    procedure ZoomDrawing;
    procedure MoveWindow(dx,dy: integer);
    procedure MoveCentrum(fx,fy: double);
    procedure CurveToCent(AIndex: Integer);
    procedure NewOrigo(x,y:extended);
    property  Origo: TPoint2d read fOrigo write FOrigo;
    property  WorkOrigo: TPoint3d read fWorkOrigo write SetWorkOrigo;
    property  Window: TRect2d read GetWindow write SetWindow;

    function GetDrawExtension: TRect2d;
    function IsRectInWindow(R: TRect2d): boolean;
    function IsPaperInWindow: boolean;
    function IsPointInWindow(p: TPoint2d): boolean;
    { Curves and process}
    function MakeCurve(const AName: Str32; ID: integer; Shape: TDrawMode;
             AEnabled, AVisible, AClosed: Boolean): Integer;
    procedure Clear;
    function  AddCurve(ACurve: TCurve3d):integer;
    procedure DeleteCurve(AItem: Integer);
    procedure DeleteSelectedCurves;
    procedure InsertCurve(AIndex: Integer; Curve: TCurve3d);
    function  GetCurveName(H: Integer): Str32;
    function  GetCurveHandle(AName: Str32; var H: Integer): Boolean;

    procedure AddPoint(AIndex: Integer; X, Y: TFloat); overload;
    procedure AddPoint(AIndex: Integer; X, Y, Z: TFloat); overload;
    procedure AddPoint(AIndex: Integer; P: TPoint2d); overload;
    procedure InsertPoint(AIndex,APosition: Integer; X,Y: TFloat); overload;
    procedure InsertPoint(AIndex,APosition: Integer; P: TPoint2d); overload;
    procedure DeletePoint(AIndex,APosition: Integer);
    procedure DeleteSamePoints(diff: TFloat);
    procedure ChangePoint(AIndex,APosition: Integer; X,Y: TFloat);
    procedure DoMove(Dx,Dy: Integer);  // Move a point in curve
    procedure GetPoint(AIndex,APosition: Integer; var X,Y,Z: TFloat);overload;
    procedure GetPoint(AIndex,APosition: Integer; var X,Y: TFloat);overload;
    function  GetMaxPoints: Integer;
    function  GetNearestPoint(p: TPoint2d; var cuvIdx, pIdx: integer): TFloat;
    procedure SetBeginPoint(ACurve,AIndex: Integer);

    procedure MoveCurve(AIndex :integer; Ax, Ay: TFloat);
    procedure MoveSelectedCurves(Ax,Ay: TFloat);
    procedure RotateSelectedCurves(Cent : TPoint2d; Angle: TFloat);
    procedure InversSelectedCurves;
    procedure InversCurve(AIndex: Integer);
    procedure SelectCurveByName(aName: string);
    procedure SelectCurve(AIndex: Integer);
    procedure PoligonizeAll(PointCount: integer);
    procedure Poligonize(Cuv: TCurve3d; Count: integer);
    procedure VektorisationAll(MaxDiff: TFloat);
    procedure Vektorisation(MaxDiff: TFloat; Cuv: TCurve3d);
    procedure PontSurites(Cuv: TCurve3d; Dist: double);
    procedure PontSuritesAll(Dist: double);

    procedure CheckCurvePoints(X, Y: Integer);

    procedure SelectAll(all: boolean);
    procedure SelectAllInArea(R: TRect2D);
    procedure SelectAllInAreaEx(R: TRect2d); // Select only points
    procedure ClosedAll(all: boolean);
    procedure SelectAllPolylines;
    procedure SelectAllPolygons;
    procedure SelectParentObjects;
    procedure SelectChildObjects;
    procedure EnabledAll(all: boolean);
    procedure SignedAll(all: boolean);
    function  GetSignedCount: integer;
    procedure SignedNotCutting;

    { Transformations }
    procedure Normalisation(Down: boolean);
    procedure Eltolas(dx,dy: double);
    procedure Nyujtas(tenyezo:double);
    procedure CentralisNyujtas(Cent: TPoint2d; tenyezo: double);
    procedure MagnifySelected(Cent: TPoint2d; Magnify: TFloat);

    function SaveCurveToStream(FileStream: TStream;
      Item: Integer): Boolean;
    function LoadCurveFromStream(FileStream: TStream): Boolean;
    function LoadCurveFromFile(const FileName: string): Boolean;
    procedure SaveGraphToMemoryStream(var stm: TMemoryStream);
    procedure LoadGraphFromMemoryStream(stm: TMemoryStream);
    function SaveGraphToFile(const FileName: string): Boolean;
    function LoadGraphFromFile(const FileName: string): Boolean;
    function LoadFromDXF(const FileName: string): Boolean;
    function SaveToDXF(const FileName: string):boolean;
    function LoadFromPLT(const FileName: string): Boolean;
    procedure LoadFromDAT(Filename: STRING);
    function SaveToDAT(Filename: STRING):boolean;
    procedure DXFCurves;

    { Virtual Clipboard procedures }
    procedure CopySelectedToVirtClipboard;
    procedure CutSelectedToVirtClipboard;
    procedure PasteSelectedFromVirtClipboard;

    {Undo,Redo}
    procedure UndoInit;
    procedure Undo;
    procedure Redo;
    procedure UndoSave;
    procedure UndoRedo(Sender:TObject; Undo,Redo:boolean);

    {Automatkus objektum sorrend képzés}
    procedure AutoSortObject(BasePoint: TPoint2d); overload;
    procedure AutoSortObject(BasePoint: TPoint2d; Connecting: boolean); overload;
    procedure AutoCutSequence(BasePoint: TPoint2d; Sorting: boolean);
    procedure InitParentObjects;
    function  IsParent(AIndex: Integer): boolean; overload;
    function  IsParent(x, y: TFloat): boolean; overload;
    function  GetInnerObjectsCount(AIndex: Integer): integer;
    function  GetParentObject(AIndex: Integer): integer; overload;
    function  GetParentObject(x,y: TFloat): integer; overload;
    function  OutLineObject(AIndex: Integer; delta: real): TCurve3d;
    function  ObjectContour(Cuv: TCurve3d;OutCode:double): TCurve3d;
    procedure StripObj12(AParent,Achild: integer);
    procedure StripChildToParent(AIndex: integer);
    procedure StripAll;
    procedure ContourOptimalizalas(var Cuv: TCurve3d);
    function  IsCutObject(p1,p2: TPoint2d; var Aindex: integer): boolean;
    procedure ElkerulesAB(Var eCurve: TCurve3d);
    procedure Elkerules;
    procedure DrawCurve(Cuv: TCurve3d; co: TColor);

    procedure ShowHintPanel(Show: Boolean);

    { Working }
    procedure DrawWorkPoint(x,y:double);
    procedure ClearWorkPoint;
    procedure WorkpositionToCentrum;
    procedure TestVekOut(dx,dy:extended);
    procedure TestWorking(AObject,AItem:integer);

    property pFazis: integer read fpFazis write SetpFazis;    // Drawing phase
    property WorkArea: TRect read FWorkArea write SetWorkArea;
    property Loading: boolean read FLoading write SetLoading;
    property Canvas;
    property DisabledCount: integer read GetDisabledCount;
  published
    property ActionMode: TActionMode read fActionMode write SetActionMode;
    property ActLayer: integer read fActLayer write fActLayer default 0;
    property AutoUndo : boolean read fAutoUndo write fAutoUndo;
    property Changed : boolean read fChanged write fChanged;
    property Centrum: T2dPoint read fCentrum write SetCentrum;
    property CentralCross: boolean read fCentralCross write SetCentralCross;
    property CoordLabel: TLabel read fCoordLabel write fCoordLabel;
    property CursorCross: boolean read fCursorCross write SetCursorCross;
             // Kontúr vonal távolsága az objektumtól
    property ConturRadius: double read FConturRadius write FConturRadius;
    property DefaultLayer: Byte read fDefaultLayer write SetDefaultLayer default 0;
    property Demo: boolean read FDemo write FDemo default False;
    property DrawMode: TDrawMode read FDrawMode write SetDrawMode;
    property BackColor: TColor read fBackColor write SetBackColor;
    property GraphTitle: Str32 read FGraphTitle write SetGraphTitle;
    property Grid: TGrid read fGrid Write fGrid;
    property Hinted: boolean read fHinted write fHinted;
    property Locked: boolean read fLocked write SetLocked;  // Editable?
    property MMPerLepes: extended read FMMPerLepes write FMMPerLepes;
    property Paper: T2dPoint read fPaper write fPaper;
    property PaperColor: TColor read fPaperColor write SetPaperColor;
    property PaperVisible: boolean read FPaperVisible write SetPaperVisible;
    property SablonSzinkron: boolean read FSablonSzinkron write FSablonSzinkron;
    property Selected: TCurve3d read fSelected write SetSelected;
    // Cursor sensitive radius of circle around of curves' points
    property SensitiveRadius: integer read FSensitiveRadius write SetSensitiveRadius;
    property ShowPoints: boolean read fShowPoints write SetShowPoints;
    property STOP: boolean read FSTOP write fSTOP;
    property TestSpeed: double read FTestSpeed write FTestSpeed;
    property TitleFont: TFont read FTitleFont write SetTitleFont;
    property Working: boolean read fWorking write SetWorking;
    property Zoom: extended read fZoom write SetZoom;
    property OnChangeAll: TNotifyEvent read fChangeAll write fChangeAll;
    property OnChangeCurve: TChangeCurve read fChangeCurve write fChangeCurve;
    property OnChangeMode: TChangeMode read fChangeMode write fChangeMode;
    property OnChangeSelected: TChangeCurve read fChangeSelected write fChangeSelected;
    property OnChangeWindow: TChangeWindow read fChangeWindow write fChangeWindow;
    property OnMouseEnter: TMouseEnter read FMouseEnter write FMouseEnter;
    property OnMouseLeave: TMouseEnter read FMouseLeave write FMouseLeave;
    property OnNewBeginPoint: TNewBeginPoint read fNewBeginPoint write fNewBeginPoint;
    property OnUndoRedoChange : TUndoRedoChangeEvent read FUndoRedoChangeEvent
             write FUndoRedoChangeEvent;
    property OnAutoSort: TAutoSortEvent read FAutoSortEvent write FAutoSortEvent;
    property OnPlan: TProcess read FPlan write FPlan; // Event for autocut percent
  end;

  TALSablon3d = class(TALCustomSablon3d)
  private
  protected
  public
  published
    property Align;
    property Anchors;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property Caption;
    property Enabled;
    property Font;
    property Hint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnContextPopup;
    property OnConstrainedResize;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseMove;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnStartDrag;
    property OnResize;
  end;

Var
    delta: TFloat;       // Sensitive radius around of points

Const
  DrawModeText : Array[0..13] of String =
              ('None', 'Point', 'Line', 'Rectangle', 'Polyline', 'Polygon',
               'Circle', 'Ellipse', 'Arc', 'Chord', 'Spline', 'BSline', 'Text',
               'FreeHand');

  ActionModeText : Array[0..19] of String =
               ('None', 'Drawing', 'Paning', 'Zooming', 'Painting',
                 'Select',
                 'InsertPoint', 'DeletePoint', 'MovePoint','SelectPoint',
                 'ChangePoint', 'DeleteSelected', 'MoveSelected', 'RotateSelected',
                 'NewBeginPoint', 'MagnifySelected', 'SelectArea', 'SelectAreaEx',
                 'AutoPlan','TestWorking');

  ShapeClosed : Array[0..12] of Boolean =
              (False, False, False, True, False, True,
               True, True, False, True, False, True, False);

function InRange(Test,Min,Max: Integer): Boolean;

procedure Register;


implementation

procedure Register;
begin
  RegisterComponents('AL',[TALSablon3d]);
end;

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


{ TPoint3dObj }

constructor TPoint3dObj.Create;
begin
  inherited;
  fx := 0;
  fy := 0;
end;

procedure TPoint3dObj.Changed;
begin if Assigned(FOnChange) then FOnChange(Self); end;

procedure TPoint3dObj.Setx(Value: extended);
begin
     Fx:=Value;
     Changed;
end;

procedure TPoint3dObj.Sety(Value: extended);
begin
     Fy:=Value;
     Changed;
end;

procedure TPoint3dObj.Setz(Value: extended);
begin
     Fz:=Value;
     Changed;
end;

{ TCurve }

constructor TCurve3d.Create;
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
end;

destructor TCurve3d.Destroy;
begin
  ClearPoints;
  inherited Destroy;
end;

procedure TCurve3d.AbsolutClosed;
var p0,p1: TPointRec3d; // Begin and end points are equel
begin
  If Closed then begin
     p0:=GetPointRec(0);
     p1:=GetPointRec(FPoints.Count-1);
     if (p0.x<>p1.x) or (p0.y<>p1.y) or (p0.z<>p1.z) then
        AddPoint(p0);
  end;
end;

procedure TCurve3d.AddPoint(Ax, Ay, Az: TFloat);
begin
if Enabled then begin
  GetMem(PPoint,SizeOf(TPointRec3d));
  PPoint^.X:=Ax;
  PPoint^.Y:=Ay;
  PPoint^.Z:=Az;
  PPoint^.Selected:=False;
  FPoints.Add(PPoint);
end;
end;

procedure TCurve3d.AddPoint(Ax, Ay: TFloat);
begin
if Enabled then begin
  GetMem(PPoint,SizeOf(TPointRec3d));
  PPoint^.X:=Ax;
  PPoint^.Y:=Ay;
  PPoint^.Z:=0;
  PPoint^.Selected:=False;
  FPoints.Add(PPoint);
end;
end;

procedure TCurve3d.AddPoint(P: TPoint3d);
begin
  AddPoint(P.x, P.y, P.z);
end;

procedure TCurve3d.AddPoint(P: TPointRec3d);
begin
  AddPoint(P.x, P.y, P.z);
end;

procedure TCurve3d.Changed(Sender: TObject);
begin if Assigned(FOnChange) then FOnChange(Self); end;

procedure TCurve3d.ChangePoint(AIndex: Integer; pr: TPointRec3d);
begin
if Enabled then
  if InRange(AIndex,0,Pred(FPoints.Count)) then
  begin
    PPoint:=FPoints.Items[AIndex];
    PPoint^ := pr;
  end;
end;

procedure TCurve3d.ChangePoint(AIndex: Integer; Ax, Ay, Az: TFloat);
begin
if Enabled then
  if InRange(AIndex,0,Pred(FPoints.Count)) then
  begin
    PPoint:=FPoints.Items[AIndex];
    PPoint^.X:=Ax;
    PPoint^.Y:=Ay;
    PPoint^.Z:=Az;
  end;
end;

procedure TCurve3d.ClearPoints;
var
  I: Integer;
begin
  if Enabled then
  for I:=0 to Pred(FPoints.Count) do FreeMem(FPoints.Items[I],SizeOf(TPointRec3d));
  FPoints.Clear;
end;

function TCurve3d.CurveToText: WideString;
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

procedure TCurve3d.DeletePoint(AIndex: Integer);
begin
if Enabled then
  if InRange(AIndex,0,Pred(FPoints.Count)) then
  begin
    FreeMem(FPoints.Items[AIndex],SizeOf(TPointRec3d));
    FPoints.Delete(AIndex);
  end;
end;

function TCurve3d.GetBoundsRect: TRect2d;
var
  I: Integer;
  x1,y1,x2,y2: TFloat;
begin
Try
  x1:=1E+10;
  y1:=1E+10;
  x2:=-1E+10;
  y2:=-1E+10;
  If FPoints.Count>0 then
  for I:=0 to Pred(FPoints.Count) do begin
      PPoint:=FPoints.Items[i];
      if PPoint^.x<x1 then x1:=PPoint^.x;
      if PPoint^.x>x2 then x2:=PPoint^.x;
      if PPoint^.y<y1 then y1:=PPoint^.y;
      if PPoint^.y>y2 then y2:=PPoint^.y;
  end;
      Result.x1 := x1;
      Result.y1 := y1;
      Result.x2 := x2;
      Result.y2 := y2;
except
end;
end;

function TCurve3d.GetCount: integer;
begin
  Result := Fpoints.Count;
end;

function TCurve3d.GetKerulet: double;
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
function TCurve3d.GetKeruletSzakasz(Aindex1, Aindex2: integer): double;
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

function TCurve3d.GetNearestPoint(p: TPoint2d; var pIdx: integer): TFloat;
var
  J   : Integer;
  d   : Double;
  x,y,z : double;
begin
  Result := 10e+10;
    For J:=0 to Pred(FPoints.Count) do
    begin
        GetPoint(j,x,y,z);
        d:=KetPontTavolsaga(p.x,p.y,x,y);
        if d<Result then begin
           pIdx   := J;
           Result := d;
        end;
    end;
end;

procedure TCurve3d.GetPoint(AIndex: Integer; var Ax, Ay, Az: TFloat);
begin
  if InRange(AIndex,0,Pred(FPoints.Count)) then
  begin
    PPoint:=FPoints.Items[AIndex];
    Ax:=PPoint^.X;
    Ay:=PPoint^.Y;
    Az:=PPoint^.Z;
  end;
end;

procedure TCurve3d.GetPoint(AIndex: Integer; var Ax, Ay: TFloat);
begin
  if InRange(AIndex,0,Pred(FPoints.Count)) then
  begin
    PPoint:=FPoints.Items[AIndex];
    Ax:=PPoint^.X;
    Ay:=PPoint^.Y;
  end;
end;

function TCurve3d.GetPoint2d(AIndex: Integer): TPoint2d;
begin
  if InRange(AIndex,0,Pred(FPoints.Count)) then
  begin
    PPoint := FPoints.Items[AIndex];
    Result := Point2d(PPoint^.X,PPoint^.Y);
  end;
end;

function TCurve3d.GetPoint3d(AIndex: Integer): TPoint3d;
begin
  if InRange(AIndex,0,Pred(FPoints.Count)) then
  begin
    PPoint := FPoints.Items[AIndex];
    Result := Point3d(PPoint^.X,PPoint^.Y,PPoint^.Z);
  end;
end;

function TCurve3d.GetPointRec(AIndex: Integer): TPointRec3d;
begin
  if InRange(AIndex,0,Pred(FPoints.Count)) then
  begin
    Result := TPointRec3d(FPoints.Items[AIndex]^);
  end;
end;

function TCurve3d.GetPointArray(AIndex: integer): TPoint3d;
begin
end;

procedure TCurve3d.InsertPoint(AIndex: Integer; pr: TPointRec3d);
begin
  InsertPoint(AIndex,pr.x,pr.y,pr.z);
end;

procedure TCurve3d.InsertPoint(AIndex: Integer; Ax, Ay, Az: TFloat);
begin
if Enabled then
  if AIndex > -1 then
  begin
    GetMem(PPoint,SizeOf(TPointRec3d));
    PPoint^.X:=Ax;
    PPoint^.Y:=Ay;
    PPoint^.Z:=Az;
    FPoints.Insert(AIndex,PPoint);
  end;
end;

procedure TCurve3d.InversPointOrder;
var i: integer;
    pr: TPointRec3d;
begin
if Enabled then begin
    if Closed then begin
       AddPoint(GetPointRec(0));
       DeletePoint(0);
    end;
    For i:=0 to (FPoints.Count div 2)-1 do
        Fpoints.Exchange(i,Fpoints.Count-1-i);
end;
end;

function TCurve3d.IsCutLine(P1, P2: TPoint2d): boolean;
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
      if SzakaszSzakaszMetszes(pp1,pp2,Point2d(p1.x,p1.y),Point2d(p2.x,p2.y),mp) then begin
           Result := True;
           exit;
      end;
      Inc(i);
  end;
end;

// Megvizsgálja, hogy P1-P2 szakasz áttvágja-e a polygont és
// d metszéspont távolságát adja a P1 elsõ ponttól
function TCurve3d.IsCutLine(P1, P2: TPoint2d; var d : double): boolean;
var
  I: Integer;
  pp1,pp2,mp: TPoint2d;
  dd: double;
begin
  Result := False;
  i:=0;
  d:=10e+10;
  While i<=FPoints.Count-1 do begin
      pp1:=GetPoint2d(i);
      if i<FPoints.Count-1 then
         pp2:=GetPoint2d(i+1)
      else
         pp2:=GetPoint2d(0);
      if SzakaszSzakaszMetszes(pp1,pp2,Point2d(p1.x,p1.y),Point2d(p2.x,p2.y),mp) then begin
         dd:=RelDist2d(Point2d(p1.x,p1.y),mp);
         if dd<d then d:=dd;
         Result := True;
      end;
      Inc(i);
  end;
end;


function TCurve3d.IsDirect: boolean;
var ymax: double;
    i,idx: integer;
    Pprior,Pnext: integer;
begin
  // Y max pont megkeresése
  ymax:= -10e+10;
  for i:=0 to Pred(Fpoints.Count) do
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
  Result := IsDirectPoligon(GetPoint2d(Pprior),GetPoint2d(idx),GetPoint2d(Pnext));
end;

function TCurve3d.IsInBoundsRect(Ax, Ay: TFloat): boolean;
begin
  With BoundsRect do
    Result := ((x1-delta)<=Ax) and ((x2+delta)>=Ax) and
           ((y1-delta)<=Ay) and ((y2+delta)>=Ay)
end;

function TCurve3d.IsInCurve(P: TPoint2d): TInCode;
begin
  Result := IsInCurve(p.x,p.y);
end;

function TCurve3d.IsInCurve(Ax, Ay: TFloat): TInCode;
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
              Exit;
           end;
        end;

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
//        if InSide(Trunc(Ax),Trunc(Ay),arr) then
//        if PointInPolygonTest(Ax,Ay,FPoints.Count,arr) then
          if IsPointInPoligon(arr,Point2d(Ax,Ay)) then
              Result := icIn;
        end;

     end;

  end;
end;

function TCurve3d.IsOnPoint(Ax, Ay, delta: TFloat): Integer;
(* Result = Point index : if P(Ax,Ay) point in delta radius circle;
   Result = -1          : other else *)
var
  I: Integer;
begin
  Result := -1;
  for I:=0 to Pred(FPoints.Count) do begin
      PPoint:=FPoints.Items[i];
      if (Abs(Ax-PPoint^.x)<=delta) and (Abs(Ay-PPoint^.y)<=delta)
      then begin
           CPIndex := i;
           Result := i;
           exit;
      end;
  end;
end;

procedure TCurve3d.MagnifyCurve(Cent: TPoint2d; Magnify: TFloat);
var i: integer;
begin
if Enabled then
  For i:=0 to Pred(FPoints.Count) do
  begin
    PPoint:=FPoints.Items[i];
    PPoint^.X := Cent.x + Magnify * (PPoint^.X - Cent.x);
    PPoint^.Y := Cent.y + Magnify * (PPoint^.Y - Cent.y);
  end;
end;

procedure TCurve3d.MoveCurve(Ax, Ay, Az: TFloat);
var i: integer;
begin
if Enabled then
  For i:=0 to Pred(FPoints.Count) do
  begin
    PPoint:=FPoints.Items[i];
    PPoint^.X:=PPoint^.X+Ax;
    PPoint^.Y:=PPoint^.Y+Ay;
    PPoint^.Z:=PPoint^.Z+Az;
  end;
end;

procedure TCurve3d.MoveSelectedPoints(Ax, Ay, Az: TFloat);
var i: integer;
begin
if Enabled then
  For i:=0 to Pred(FPoints.Count) do
  begin
    PPoint:=FPoints.Items[i];
    if PPoint^.Selected then begin
       PPoint^.X:=PPoint^.X+Ax;
       PPoint^.Y:=PPoint^.Y+Ay;
       PPoint^.Z:=PPoint^.Z+Az;
    end;
  end;
end;

procedure TCurve3d.RotateCurve(Cent: TPoint2d; Angle: TFloat);
var i,j: integer;
    pp: Tpoint2d;
begin
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

function TCurve3d.SaveToStream(stm: TStream): boolean;
var
  CurveData: TNewCurveData;
  N,P: Integer;
  PointRec: TPointRec3d;
begin
  // Store : CurveData + PointRec3d.... (point(x,y,z) continously)
  Try
    Result:=False;
    CurveData:=GetCurveData;
    stm.Write(CurveData,SizeOf(TNewCurveData));
    P := CurveData.Points-1;

    for N:=0 to P do
    begin
      if stm.Write(PointRec,SizeOf(PointRec))<SizeOf(PointRec) then
         Exit;
    end;

    Result:=True;
  except
    Result:=False;
  end;
end;

function TCurve3d.LoadFromStream(stm: TStream): boolean;
var
  CurveData: TNewCurveData;
  N,P: Integer;
  PointRec: TPointRec3d;
begin
  // Store : CurveData + PointRec3d.... (point(x,y,z) continously)
  Try
    Result:=False;
    stm.Read(CurveData,SizeOf(TNewCurveData));
    P := CurveData.Points-1;
    SetCurveData(CurveData);

    for N:=0 to P do
    begin
      if stm.Read(PointRec,SizeOf(PointRec))<SizeOf(PointRec) then
         Exit;
      AddPoint(PointRec);
    end;

    Result:=True;
  except
    Result:=False;
  end;
end;


procedure TCurve3d.SelectPoint(AIndex: Integer; Sel: boolean);
begin
if Enabled then
  if InRange(AIndex,0,Pred(FPoints.Count)) then
  begin
    PPoint:=FPoints.Items[AIndex];
    PPoint^.Selected:=Sel;
  end;
end;

procedure TCurve3d.SetAngle(const Value: TFloat);
begin
  fAngle := Value;
  Changed(Self);
end;

procedure TCurve3d.SetClosed(const Value: boolean);
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

procedure TCurve3d.SetCurveData(Data: TNewCurveData);
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

function TCurve3d.GetCurveData: TNewCurveData;
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


procedure TCurve3d.SetEnabled(const Value: Boolean);
begin
  FEnabled := Value;
  Changed(Self);
end;

procedure TCurve3d.SetFont(const Value: TFont);
begin
if Enabled then begin
  FFont := Value;
  Changed(Self);
end;
end;

procedure TCurve3d.SetLayer(const Value: byte);
begin
if Enabled then begin
  FLayer := Value;
  Changed(Self);
end;
end;

procedure TCurve3d.SetName(const Value: Str32);
begin
  FName := Value;
  Changed(Self);
end;

procedure TCurve3d.SetPointRec(AIndex: integer; const Value: TPointRec3d);
begin
  ChangePoint(AIndex,Value);
end;

procedure TCurve3d.SetPoints(AIndex: integer; const Value: TPoint3d);
begin
  ChangePoint(AIndex,Value.x,Value.y,Value.z);
end;

procedure TCurve3d.SetSelected(const Value: boolean);
begin
if Enabled then begin
  FSelected := Value;
  Changed(Self);
end;
end;

procedure TCurve3d.SetShape(const Value: TDrawMode);
begin
if Enabled then begin
  fShape := Value;
  Changed(Self);
end;
end;

procedure TCurve3d.SetSigned(const Value: boolean);
begin
  fSigned := Value;
  Changed(Self);
end;

procedure TCurve3d.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
  Changed(Self);
end;

procedure TCurve3d.FillPointArray;
var i: integer;
begin
  SetLength(PointsArray,Count);
  for i:=0 to Count-1 do
      PointsArray[i] := GetPoint3d(i);
end;

{------------------------------------------------------------------------------}

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

{------------------------------------------------------------------------------}

{ TALCustomSablon3d }

procedure TALCustomSablon3d.Change(Sender: TObject);
begin
//  oldCentrum := OrigoToCent;
  if Sender is TCurve3d then
     if Assigned(fChangeCurve) then fChangeCurve(Self,TCurve3d(Sender),-1);
  Invalidate;
end;

procedure TALCustomSablon3d.ChangeCentrum(Sender: TObject);
var p: TPoint2d;
begin
  Origo := CentToOrigo(Point2d(Centrum.x,Centrum.y));
  Repaint;
end;

procedure TALCustomSablon3d.ChangePaperExtension(Sender: TObject);
begin
  ZoomPaper;
end;

constructor TALCustomSablon3d.Create(AOwner: TComponent);
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
  Screen.Cursors[crPolyline]     :=  LoadCursor(HInstance, 'SPOLYLINE');
  Screen.Cursors[crPolygon]      :=  LoadCursor(HInstance, 'SPOLYGON');
  Screen.Cursors[crInsertPoint]  :=  LoadCursor(HInstance, 'SINSERTPOINT');
  Screen.Cursors[crDeletePoint]  :=  LoadCursor(HInstance, 'SDELETEPOINT');
  Screen.Cursors[crNewbeginPoint]:=  LoadCursor(HInstance, 'SNEWBEGINPOINT');
  Screen.Cursors[crRotateSelected]:=  LoadCursor(HInstance,'SROTATESELECTED');
  Screen.Cursors[crFreeHand]:=  LoadCursor(HInstance,'SFREEHAND');

  STOP   := False;
  Width  := 200;
  height := 200;
  VirtualClipboard := TMemoryStream.Create;
  WBmp       := TBitMap.Create;   // Memory Bitmap for Working Pointer
  WBmp.Width := 8;
  WBmp.Height:= 8;
  // Creates pens
  pClosed := TPen.Create;
  pClosed.Width := 2;
  pClosed.Color := clBlack;
  pClosed.Style := psSolid;

  pOpened := TPen.Create;
  pOpened.Width := 1;
  pOpened.Color := clGray;
  pOpened.Style := psDot;

  pSelected := TPen.Create;
  pSelected.Width := 2;
  pSelected.Color := clBlue;
  pSelected.Style := psSolid;

  fZoom             := 1;
  DrawBmp           := TBitMap.Create;
  FCurveList        := TList.Create;
  fPaper            := T2dPoint.Create(Application,0,0);
  fPaper.x          := 210;
  fPaper.y          := 297;
  fBackColor        := clSilver;
  fPaperColor       := clWhite;
  fPaperVisible     := True;
  fGrid             := TGrid.Create;
  fCentrum          := T2dPoint.Create(Application,0,0);
  fGrid.OnChange    := Change;
  fCentrum.OnChange := ChangeCentrum;
  fPaper.OnChange   := ChangePaperExtension;
  fCentralCross     := True;
  fCursorCross      := True;
  oldCursorCross    := True;
  fShowPoints       := True;
  MouseInOut        := 1;
  Origin            := Point(0,0);
  MovePt            := Origin;
  oldMovePt         := MovePt;
  Hinted            := True;
  Hint1             := THintWindow.Create(Self);
  painting          := False;
  fDefaultLayer     := 0;
  SensitiveRadius   := 2;
  Centrum.x         := fPaper.x / 2;
  Centrum.y         := fPaper.y / 2;
  DrawMode          := dmNone;
  FTitleFont        := TFont.Create;
  With FTitleFont do begin
       Name := 'Times New Roman';
       Color:= clNavy;
       Size := 8;
  end;
  innerStream := TMemoryStream.Create;
  fAutoUndo := True;
  UR:= TUndoRedo.Create;
  Ur.UndoLimit := 100;
  Ur.UndoSaveProcedure := SaveGraphToMemoryStream;
  Ur.UndoRedoProcedure := LoadGraphFromMemoryStream;
  Ur.OnUndoRedo        := UndoRedo;
  Changed := False;
//  DoubleBuffered := True;
  FWorkOrigo := Point3d(0,0,0);
  FMMPerLepes  := 4;
  TempCurve    := TCurve3d.Create;
  FConturRadius := 2;
  FDemo   := False;
  ZoomPaper;
end;

destructor TALCustomSablon3d.Destroy;
var
  I: Integer;
begin
if Self <> nil then begin
  for I:=Pred(FCurveList.Count) downto 0 do
  begin
    FCurve:=FCurveList.Items[I];
    FCurve.Free;
  end;
  FCurveList.Free;
  pClosed.Free;
  pOpened.Free;
  pSelected.Free;
  Hint1.Free;
  fPaper.Free;
  fGrid.Free;
  fCentrum.Free;
  FTitleFont.Free;
  DrawBmp.Free;
  WBmp.Free;
  UR.Free;
  innerStream.Destroy;
  VirtualClipboard.Free;
end;
  inherited;
end;

procedure TALCustomSablon3d.WMSize(var Msg: TWMSize);
begin
    inherited;
    ChangeCentrum(nil);
end;

procedure TALCustomSablon3d.UndoInit;
begin
  Clear;           // Clears all curves
  UR.UndoInit;     // Initialize UndoRedo system
  UndoSave;        // Saves this situation
end;

procedure TALCustomSablon3d.Undo;
begin
  Loading := True;
  Clear;
  UR.Undo;
  Changed := True;
  Loading := False;
end;

procedure TALCustomSablon3d.Redo;
begin
if not Locked then begin
  Loading := True;
  Clear;
  UR.Redo;
  Changed := True;
  Loading := False;
end;
end;

procedure TALCustomSablon3d.UndoSave;
begin
if not Locked then
  UR.UndoSave;  // Felhasználói mentés undo-hoz
end;

procedure TALCustomSablon3d.UndoRedo(Sender:TObject; Undo,Redo:boolean);
begin
  If Assigned(FUndoRedoChangeEvent) then
     FUndoRedoChangeEvent(Self,Undo,Redo);
end;

procedure TALCustomSablon3d.Paint;
var
  R       : TRect;
  H,I,J,K : Integer;
  Radius  : integer;
  X,Y,Z   : TFloat;
  Angle   : TFloat;
  Size    : integer;
  p       : TPoint;
  pp      : Array[0..2] of TPoint2D;
  PA      : PPointArray;
  pPA     : PPointArray3d;
  RE      : TRect2d;
  dc      : HDC;
begin
Try
  painting := True;

  DrawBmp.Width:=Width;
  DrawBmp.Height:=Height;
  DrawBmp.Canvas.Pen.Width:=1;

  DrawBmp.Canvas.Brush.Color:=BackColor;
  DrawBmp.Canvas.FillRect(ClientRect);
  DrawBmp.Canvas.Brush.Color:=clSilver;

  If IsPaperInWindow and PaperVisible then begin
    DrawBmp.Canvas.Pen.Style := psSolid;
    R:=Rect(XToS(0),YToS(0),XToS(Paper.x),YToS(Paper.y));
    OffsetRect(R,4,4);
    DrawBmp.Canvas.Brush.Color:=clBlack;
    DrawBmp.Canvas.FillRect(R);
    OffsetRect(R,-4,-4);
    DrawBmp.Canvas.Brush.Color:=PaperColor;
    DrawBmp.Canvas.FillRect(R);
    DrawBmp.Canvas.Pen.Color := clBlack;
    DrawBmp.Canvas.Rectangle(R);
  end;

  GridDraw;
  
  if Length(FGraphTitle) > 0 then
  begin
      DrawBmp.Canvas.Font:=TitleFont;
      DrawBmp.Canvas.Brush.Style := bsClear;
      DrawBmp.Canvas.Brush.Color := clSilver;
      DrawBmp.Canvas.TextOut(4,4,FGraphTitle);
//      DrawBmp.Canvas.TextOut(Width div 2 - DrawBmp.Canvas.TextWidth(FGraphTitle) div 2,
//                        10,FGraphTitle)
  end;

  K := GetMaxPoints;
  Size:=GetMaxPoints * SizeOf(TPointArray);
  GetMem(PA,Size);

  for H:=0 to Pred(FCurveList.Count) do
  begin
    FCurve:=FCurveList.Items[H];
    if FCurve<>nil then begin
    if FCurve.Visible and (FCurve.FPoints.Count > 0) then
    begin
      DrawBmp.Canvas.Pen.Style := psSolid;
      DrawBmp.Canvas.Pen.Width:=1;
      DrawBmp.Canvas.Brush.Style:=bsSolid;
      J:=Pred(FCurve.FPoints.Count);

      for I:=0 to J do
      begin
        FCurve.GetPoint(I,X,Y,Z);
        p := WtoS(x,y);
        PA^[I].x:= p.x;
        PA^[I].y:= p.y;
      end;

      // Tollak beállítása
      If FCurve.Closed then begin
             DrawBmp.Canvas.Pen.Assign(pClosed);
             DrawBmp.Canvas.Brush.Style:=bsClear;
      end else
             DrawBmp.Canvas.Pen.Assign(pOpened);
      If (FCurve.Selected) then
        DrawBmp.Canvas.Pen.Assign(pSelected);
      if FCurve.Signed then
         DrawBmp.Canvas.Pen.Color := clSilver;
      if FCurve = Selected then begin
         DrawBmp.Canvas.Pen.Width := 2;
         if FCurve.Selected then
            DrawBmp.Canvas.Pen.Color := clFuchsia
         else
            DrawBmp.Canvas.Pen.Color := clRed;
         RE := FCurve.BoundsRect;
         R  := Rect(XToS(RE.X1),YToS(Re.y1),XToS(RE.X2),YToS(Re.y2));
         DrawBmp.Canvas.TextOut((R.Right+R.Left) div 2,(R.Bottom+R.Top) div 2,IntToStr(H))
      end;

      // Objektumok rajzolása
      Case FCurve.Shape of
      dmPolygon,dmPolyLine,dmPoint,dmLine,dmRectangle:
        If FCurve.Closed then
        begin
            DrawBmp.Canvas.Polygon(Slice(PA^,Succ(J)))
        end
        else
        begin
            DrawBmp.Canvas.PolyLine(Slice(PA^,Succ(J)));
        end;
      dmCircle:
        begin
           Radius:= Trunc( SQRT( SQR(p.x-PA^[0].x) + SQR(p.y-PA^[0].y) ) );
           DrawBmp.Canvas.Ellipse(PA^[0].x-Radius,PA^[0].y-Radius,PA^[0].x+Radius,PA^[0].y+Radius);
        end;
      dmEllipse:
        begin
           DrawBmp.Canvas.Ellipse(PA^[0].x-Abs(PA^[0].x-p.x),PA^[0].y-Abs(PA^[0].y-p.y),
                                  PA^[0].x+Abs(PA^[0].x-p.x),PA^[0].y+Abs(PA^[0].y-p.y));
        end;
      dmArc:
        If FCurve.FPoints.Count>2 then
        begin
          For i:=0 to 2 do begin
              FCurve.GetPoint(I,X,Y,Z);
              pp[i] := Point2D(XtoS(x),YToS(y));
          end;
          KorivRajzol(DrawBmp.Canvas,pp[0],pp[1],pp[2]);
        end else
           DrawBmp.Canvas.PolyLine(Slice(PA^,Succ(J)));
      dmSpline:
        begin
          if FCurve.Closed then K:=3 else K:=4;
          SplineXP(DrawBmp.Canvas,Slice(PA^,Succ(J)),100,TBSplineAlgoritm(K));
        end;
      dmBSpline:
        begin
          SplineXP(DrawBmp.Canvas,Slice(PA^,Succ(J)),100,TBSplineAlgoritm(3));
        end;
      dmText:
        begin
          DrawBmp.Canvas.Font := FCurve.Font;
          DrawBmp.Canvas.Font.Size := Trunc(FCurve.Font.Size * Zoom);
          if DrawBmp.Canvas.Font.Size>2 then begin
             Angle := FCurve.Angle;
             FCurve.GetPoint(0,X,Y,Z);
             p := WtoS(x,y);
             if Angle=0 then
                DrawBmp.Canvas.TextOut(p.x,p.y,FCurve.Name)
             else
                RotText(DrawBmp.Canvas,p.x,p.y,FCurve.Name,Round(10*Angle));
          end;
        end;
      end;

      // Sarokpontok rajzolása = Draw points
      DrawBmp.Canvas.Pen.Width := 1;
      DrawBmp.Canvas.Brush.Color:=clLime;
      If ShowPoints then
      for I:=1 to J do
      begin
           if FCurve.GetPointRec(I).Selected then begin
              DrawBmp.Canvas.Pen.Color := clBlue;
//              DrawBmp.Canvas.Brush.Color:=clBlue;
              DrawBmp.Canvas.Rectangle(PA^[I].x-4,PA^[I].y-4,
                PA^[I].x+4,PA^[I].y+4);
           end else begin
              DrawBmp.Canvas.Pen.Color := clBlack;
//              DrawBmp.Canvas.Brush.Color:=clLime;
              DrawBmp.Canvas.Rectangle(PA^[I].x-SensitiveRadius,PA^[I].y-SensitiveRadius,
                PA^[I].x+SensitiveRadius,PA^[I].y+SensitiveRadius);
           end;
      end;
           // Draw begin point
      If (FCurve=Selected) then begin
           DrawBmp.Canvas.Brush.Color:=clRed;
           DrawBmp.Canvas.Ellipse(PA^[0].x-SensitiveRadius-4,PA^[0].y-SensitiveRadius-4,
                PA^[0].x+SensitiveRadius+4,PA^[0].y+SensitiveRadius+4)
      end else begin
           DrawBmp.Canvas.Brush.Color:=clBlue;
           DrawBmp.Canvas.Ellipse(PA^[0].x-SensitiveRadius-2,PA^[0].y-SensitiveRadius-2,
                PA^[0].x+SensitiveRadius+2,PA^[0].y+SensitiveRadius+2)
      end;
           DrawBmp.Canvas.Brush.Color:=clWhite;

    end;
    end;
  end;

  {Középkereszt}
  If CentralCross then
  With DrawBmp.Canvas do begin
    R := Clientrect;
    Pen.Color := clBlack;
    Pen.Style := psSolid;
    MoveTo((R.Left+R.Right) div 2,R.Top);
    LineTo((R.Left+R.Right) div 2,R.Bottom);
    MoveTo(R.Left,(R.Top+R.Bottom) div 2);
    LineTo(R.Right,(R.Top+R.Bottom) div 2);
  end;
  if ActionMode=amRotateSelected then
     if pFazis>0 then begin
        DrawBmp.Canvas.Pen.Color := clRed;
        DrawBmp.Canvas.Brush.Color := clRed;
        p := WToS(RotCentrum.x,RotCentrum.y);
        DrawBmp.Canvas.Ellipse(p.x-4,p.y-4,p.x+4,p.y+4);
     end;

finally
  FreeMem(PA,Size);
  R:=ClientRect;
  Canvas.CopyRect(R,DrawBmp.Canvas,R);
  DrawWorkPoint(WorkPosition.WorkPoint.x,WorkPosition.WorkPoint.y);
  If oldCursorCross (*and (MouseInOut=1)*) then begin
     DrawMouseCross(oldMovePt,pmXor);
  end;
  painting := False;
  if Assigned(fChangeWindow) then
     fChangeWindow(Self,fOrigo.x,fOrigo.Y,fZoom,XToW(MovePt.x),YToW(MovePt.y))
end;
end;

procedure TALCustomSablon3d.GridDraw;
var
    kp,kp0: TPoint2d;
    tav,kpy,mar,marx,mary: extended;
    i: integer;
    GridTav : integer;     // Distance between lines
    R : TRect;
begin
If Grid.Visible then begin
  GridTav := 1;
  With DrawBmp.Canvas do

  if Grid.OnlyOnPaper then begin
  For i:=0 to 2 do begin
      tav  := Gridtav;
      if (Zoom*tav)>5 then begin

      Pen.Color := Grid.SubgridColor;
      Case GridTav of
      1:  Pen.Width := 1;
      10: Pen.Width := 2;
      100: Pen.Color := Grid.MaingridColor;
      end;

      kp.x := 0;
      kp.y := 0; kp0:=kp;

      if Grid.Style=gsLine then begin
      While kp.x<=Paper.x do begin
            MoveTo(XToS(kp.x),YToS(0));
            LineTo(XToS(kp.x),YToS(Paper.y-0.1));
            kp.x:=kp.x+tav;
      end;
      While kp.y<=Paper.y do begin
            MoveTo(XToS(0),YToS(kp.y));
            LineTo(XToS(Paper.x-0.1),YToS(kp.y));
            kp.y:=kp.y+tav;
      end;
      end;

    end;
    GridTav := GridTav * 10;

  end;

  end else
  begin
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
  end;

end;
  // Margin draws
  if (Grid.Margin>0) and PaperVisible then begin
       DrawBmp.Canvas.Brush.Style:=bsClear;
       DrawBmp.Canvas.Pen.Style := psDot;
       DrawBmp.Canvas.Pen.Color := clSilver;
       R:=Rect(XToS(Grid.Margin),YToS(Grid.Margin),XToS(Trunc(Paper.x-Grid.Margin)),
               YToS(Trunc(Paper.y-Grid.Margin)));
       DrawBmp.Canvas.Rectangle(R);
 end;
end;

{Új origo meghatározása: átírja a centrum koordinátáit is}
procedure TALCustomSablon3d.NewOrigo(x,y:extended);
var  c : TPoint2d;
begin
    FOrigo.x:=x;
    FOrigo.y:=y;
    c := OrigoToCent;
    fCentrum.x := c.x;
    Centrum.y := c.y;
end;

procedure TALCustomSablon3d.SetBackColor(const Value: TColor);
begin
  fBackColor := Value;
  Repaint;
end;

procedure TALCustomSablon3d.SetPaperColor(const Value: TColor);
begin
  fPaperColor := Value;
  Repaint;
end;

procedure TALCustomSablon3d.SetPaperVisible(const Value: boolean);
begin
  FPaperVisible := Value;
  Repaint;
end;

procedure TALCustomSablon3d.SetZoom(const Value: extended);
var felx,fely: extended;
begin
 If fzoom<>Value then begin
  felx := Width/(2*Zoom);
  fely := Height/(2*Zoom);
  forigo.x := forigo.x+felx*(1-(fZoom/Value));
  forigo.y := forigo.y+fely*(1-(fZoom/Value));
  fZoom := Value;
  invalidate;
 end;
end;

function TALCustomSablon3d.XToS(x: TFloat): integer;
begin
   Result:=Round(Zoom*(x-forigo.x));
end;

function TALCustomSablon3d.YToS(y: TFloat): integer;
begin
   Result:=Height-Round(Zoom*(y-forigo.y));
end;

function TALCustomSablon3d.XToW(x: integer): TFloat;
begin
   Result := origo.x + x / Zoom;
end;

function TALCustomSablon3d.YToW(y: integer): TFloat;
begin
   Result := origo.y + (Height - y) / Zoom;
end;

function TALCustomSablon3d.SToW(x, y: integer): TPoint2d;
begin
   Result.x := XToW(x);
   Result.y := YToW(y);
end;

function TALCustomSablon3d.WToS(x, y: TFloat): TPoint;
begin
Try
   Result.x:= XToS(x);
   Result.y:= YToS(y);
except
   Result:= Point(0,0);
end;
end;

{Az origo koord.-áiból kiszámitja a képközéppont koord.it}
function  TALCustomSablon3d.OrigoToCent:TPoint2D;
begin
  Result.x := origo.x+Width/(2*Zoom);
  Result.y := origo.y+Height/(2*Zoom);
end;

{Az képközéppont koord.-áiból kiszámitja a origo koord.it}
function  TALCustomSablon3d.CentToOrigo(c:TPoint2D):TPoint2D;
begin
  Result.x := c.x-Width/(2*Zoom);
  Result.y := c.y-Height/(2*Zoom);
end;

procedure TALCustomSablon3d.SetBeginPoint(ACurve,AIndex: Integer);
var NewPoints: TList;
    i,j1,j2: integer;
    PPoint: PPointRec;
begin
if AIndex>0 then begin
  FCurve:=FCurveList.Items[ACurve];
  if InRange(ACurve,0,Pred(FCurveList.Count)) then
  if InRange(AIndex,0,Pred(fCurve.FPoints.Count)) then
  begin
  Try
    NewPoints:=TList.Create;
    For i:=AIndex to Pred(FCurve.fPoints.Count) do begin
        PPoint:=FCurve.fPoints.Items[i];
        NewPoints.Add(PPoint);
    end;
    if FCurve.Closed then begin
       j1 := 0; j2 := AIndex-1;
       For i:=j1 to j2 do begin
        PPoint:=FCurve.fPoints.Items[i];
        NewPoints.Add(PPoint);
    end;
    end else begin
       j2 := 0; j1 := AIndex-1;
       For i:=j1 downto j2 do begin
        PPoint:=FCurve.fPoints.Items[i];
        NewPoints.Add(PPoint);
    end;
    end;
    finally
        FCurve.fPoints.Clear;
        For i:=0 to Pred(NewPoints.Count) do begin
            PPoint:=NewPoints.Items[i];
            FCurve.fPoints.Add(PPoint);
        end;
        NewPoints.Free;
        Selected := FCurve;
        Changed := True;
        if Assigned(fNewBeginPoint) then fNewBeginPoint(Self,ACurve);
    end;
  end;
end;
end;

procedure TALCustomSablon3d.DrawMouseCross(o:TPoint;PenMode:TPenMode);
var DC:HDC;
    oldPen: TPen;
begin
Try
    oldPen:=Canvas.Pen;
    oldPen.Color := Canvas.Pen.Color;
    oldPen.Mode  := Canvas.pen.Mode;
    Canvas.pen.Color := clBlue;
    Canvas.pen.Mode := PenMode;
    DrawShape(Canvas,Point(0,o.y),Point(Width,o.y),dmLine,pmNotXor);
    DrawShape(Canvas,Point(o.x,0),Point(o.x,Height),dmLine,pmNotXor);
Finally
    Canvas.Pen.Color:=oldPen.Color;
    Canvas.pen.Mode := oldPen.Mode;
end;
end;

procedure TALCustomSablon3d.MouseDown(Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
Var xx,yy : TFloat;    // Mouse world coordinates
    pr    : TPointRec3d;
    s     : Str32;
    sel   : boolean;
    RR    : extended;    // Radius for magnify
    InputString : string;
    pp    : TPoint2d;
begin
  SetFocus;
  xx := origo.x + x / Zoom;
  yy := origo.y + (Height-y) / Zoom;

  Origin := Point(x,y);
  MovePt := Point(x,y);
  MousePos := Origin;
  If pFazis=0 then oldOrigin := Origin;

  if (DrawMode<>dmNone) then begin

  if Shift = [ssLeft] then begin

     Case DrawMode of

     dmNone :
       if (ActionMode = amSelectArea) then
       Case pFazis of
       0: begin
          Canvas.Pen.Style:=psDash;
          Canvas.Rectangle(Origin.x,Origin.y,Origin.x,Origin.y);
          end;
       1: pFazis := -1;
       end;

     dmFreeHand :
     Case pFazis of
     0: h:=MakeCurve('Drawing',-1,dmPolyline,True,True,False);
     else begin
         FCurve := FCurveList.Items[h];
         Selected := FCurve;
         pFazis := -1;
     end;
     end;

     dmPoint :
     Case pFazis of
     0: h:=MakeCurve('Point',-1,DrawMode,True,True,False);
     1: pFazis := -1;
     end;

     dmLine :
     Case pFazis of
     0: h:=MakeCurve('Line',-1,DrawMode,True,True,False);
     2: pFazis := -1;
     end;

     dmRectangle :
     Case pFazis of
     0: h:=MakeCurve('Rectangle',-1,DrawMode,True,True,True);
     1: begin
          FCurve := FCurveList.Items[h];
          FCurve.GetPoint(0,pr.x,pr.y,pr.z);
          FCurve.ClearPoints;
          // Circle From left botton corner
          FCurve.AddPoint(pr.x,pr.y,pr.z);
          FCurve.AddPoint(xx,pr.y,pr.z);
          FCurve.AddPoint(xx,yy,pr.z);
          AddPoint(H,pr.x,yy);
          pFazis := -1;
        end;
     end;

     dmPolyLine  :
     Case pFazis of
     0: h:=MakeCurve('PolyLine',-1,DrawMode,True,True,False);
     end;

     dmPolygon  :
     Case pFazis of
     0:
     begin
       h:=MakeCurve('Polygon',-1,DrawMode,True,True,True);
       polygonContinue := True;
     end;
     end;

     dmCircle   :
     Case pFazis of
     0: h:=MakeCurve('Circle',-1,DrawMode,True,True,True);
     1: begin
        AddPoint(h,xx,yy);
        pFazis := -1;
        end;
     end;

     dmEllipse   :
     Case pFazis of
     0: h:=MakeCurve('Ellipse',-1,DrawMode,True,True,True);
     1: begin
        AddPoint(h,xx,yy);
        pFazis := -1;
        end;
     end;

     dmArc:
           case pfazis of
           0: h:=MakeCurve('Arc',-1,DrawMode,True,True,False);
           1: begin
              FCurve.GetPoint(0,pr.x,pr.y,pr.z);
              pp:=FelezoPont(Point2d(XToS(pr.x),YToS(pr.y)),Point2d(x,y));
              MovePt:=ClientToScreen(Point(Trunc(pp.x),Trunc(pp.y)));
              SetCursorPos(MovePt.x,MovePt.y);
              end;
           2: begin
              ChangePoint(h,1,xx,yy);
              pfazis:=-1;
              end;
           end;

     dmSpline:
     Case pFazis of
     0:
     begin
       h:=MakeCurve('Spline',-1,DrawMode,True,True,False);
       polygonContinue := True;
     end;
     end;

     dmBSpline:
     Case pFazis of
     0:
     begin
       h:=MakeCurve('BSpline',-1,DrawMode,True,True,True);
       polygonContinue := True;
     end;
     end;

     dmText:
     Case pFazis of
     1:
     begin
        AddPoint(h,xx,yy);
        pFazis := -1;
     end;
     end;

     end;
     if pFazis>-1 then
        AddPoint(h,xx,yy);
  end;

  end  // End of if (DrawMode<>dmNone)
  else
     begin
       // Choice selected curve
       if (ActionMode = amNone) and (CurveMatch or CPMatch) then begin
             FCurve := FCurveList.Items[CPCurve];
          if (ssCtrl in Shift) and (ssAlt in Shift) then begin
             if CPMatch then begin
                ActionMode := amNone;
                pr := FCurve.PointRec[CPIndex];
                FCurve.ChangePoint(CPIndex,pr.x,pr.y,pr.z);
             end;
          end else
          if (Shift = [ssShift,ssLeft]) or (Shift = [ssCtrl,ssLeft]) then begin
             sel := FCurve.Selected;
             if Shift=[ssCtrl,ssLeft] then SelectAll(False);
             FCurve.Selected := not sel;
             if CurveMatch then ActionMode := amMoveSelected;
             if CPMatch then ActionMode := amMovePoint;
             if Assigned(fChangeSelected) then fChangeSelected(Self,FCurve,CPIndex);
          end else
             Selected := FCurveList.Items[CPCurve];
       end
       else
          Selected := nil;


       // Insert point
       if (ActionMode = amInsertPoint) and CurveMatch then
       begin
          FCurve := FCurveList.Items[CPCurve];
          Selected := FCurve;
          InsertPoint(CPCurve,FCurve.CPIndex,xx,yy);
       end;
       // Delete Point
       if (ActionMode = amDeletePoint) and CPMatch then
       begin
          FCurve := FCurveList.Items[CPCurve];
          DeletePoint(CPCurve,CPIndex);
       end;
       // Select Curve
       if (ActionMode = amSelect) and (CurveMatch or CPMatch) then
       begin
          FCurve := FCurveList.Items[CPCurve];
          sel := FCurve.Selected;
          if CPMatch then TPointRec(FCurve.FPoints.Items[CPIndex]^).Selected := True
          else
          FCurve.Selected := not Sel;
          Selected := FCurve;
       end;

       if (ActionMode = amMagnifySelected) then
       if Button=mbLeft then
       Case pFazis of
       0 : begin
             RotCentrum    := Point2d(xx,yy);
           end;
       1:  begin
           (*
             RR := Trunc(Sqrt(Sqr(xx-RotCentrum.x)+Sqr(yy-RotCentrum.y)));
             if yy<RotCentrum.y then RR := 1/RR;
             MagnifySelected(RotCentrum,RR/100);
             pFazis := -1;
           *)
           end;
       end;

       if (ActionMode = amRotateSelected) then
       if Button=mbLeft then
       Case pFazis of
       0 : begin
                RotCentrum    := Point2d(xx,yy);
                RotStartAngle := 0;
                RotAngle      := 0;
                InputString:= InputBox('Rotate Selected Curves', 'Rotate Angle : ','0');
                RotAngle := -StrToFloat(InputString);
                if RotAngle<>0 then
                RotateSelectedCurves(RotCentrum,RotAngle*pi/180);
                pFazis := 0;
           end;
       1:  begin
                RotAngle := RelAngle2d(RotCentrum,Point2d(xx,yy));
           end;
       end;

       if (ActionMode = amNewBeginPoint) then
          if CPMatch then SetBeginPoint(CPCurve,CPIndex);

     end;

  if Button<>mbRight then pFazis := pFazis+1 else pFazis := 0;
  oldMovePt := Origin;
  Repaint;
  CheckCurvePoints(X,Y);
  inherited;
end;

procedure TALCustomSablon3d.MouseMove(Shift: TShiftState; X,Y: Integer);
Var xx,yy: TFloat;
  pr: TPointRec3d;
  Hintstr: string;
  HintRect: TRect;
  p: TPoint;
  w,he: integer;
  nyil: boolean;
  szog: double;
label 111;
begin

if not (ActionMode in [amInsertPoint,amMovePoint,amMoveSelected]) then
  CheckCurvePoints(X,Y);

  MovePt := Point(x,y);
  MousePos := MovePt;
  xx := origo.x + x / Zoom;
  yy := origo.y + (Height-y) / Zoom;
  If (CoordLabel<>nil) then
     CoordLabel.Caption:=Trim(Format('%6.2f',[xx]))+':'+Trim(Format('%6.2f',[yy]));

  if CursorCross then begin
       DrawMouseCross(oldMovePt,pmXor);
       DrawMouseCross(MovePt,pmXor);
  end;

  If (DrawMode = dmNone) and (ActionMode=amNone) then begin
     if CPMatch then Cursor:=crHandPoint else
     if CurveMatch then Cursor:=crDrag else
     if CurveIn then Cursor:=crMultiDrag else
     Cursor := crDefault;
  end;

  oldCursor := Cursor;
  // Automatic Move window, if cursor is near the border of window
  if (ActionMode<>amNone) and (pFazis>0) then begin
     if x<20 then // Cursor := crNyilLeft;
     MoveWindow(4,0);
     if (Width-x)<20 then // Cursor := crNyilRight;
     MoveWindow(-4,0);
     if y<20 then // Cursor := crNyilUp;
     MoveWindow(0,-4);
     if (Height-y)<20 then // Cursor := crNyilDown;
     MoveWindow(0,4);
  end;

  if (ssLeft in Shift) then begin
     Case ActionMode of
     amNone           :
       begin
          if Shift = [ssLeft] then begin
             MoveWindow(x-oldMovePt.x,-(y-oldMovePt.y));
             Paning := True;
             if Paning then Screen.Cursor := crSizeAll;
          end;
          if Shift = [ssShift,ssLeft] then begin
             Moving := True;
             MoveSelectedCurves(x-oldMovePt.x,-(y-oldMovePt.y));
          end;
          if Shift = [ssShift,ssCtrl,ssLeft] then
             if CurveMatch then begin
                MoveCurve(CPCurve,x-oldMovePt.x,-(y-oldMovePt.y));
                Moving := True;
             end;
          if (Shift = [ssAlt,ssLeft]) or (Shift = [ssCtrl,ssAlt,ssLeft]) then begin
             Canvas.Pen.Style:=psDash;
             Canvas.Pen.Mode:=pmNotXor;
             Canvas.Rectangle(Origin.x,Origin.y,oldMovePt.x,oldMovePt.y);
             Canvas.Rectangle(Origin.x,Origin.y,MovePt.x,MovePt.y);
             Canvas.Pen.Style:=psSolid;
          end;

       end;
     amMovePoint      : DoMove(x,y);
     amMoveSelected   : MoveCurve(CPCurve,x-oldMovePt.x,-(y-oldMovePt.y));
     amInsertPoint    : DoMove(x,y);
     amRotateSelected :
         if (pFazis>1) then begin
          RotAngle := RelAngle2d(RotCentrum,Point2d(xx,yy));
          szog := -Szogdiff(RotAngle,RelAngle2d(RotCentrum,SToW(oldMovePt.x,oldMovePt.y)));
          RotateSelectedCurves(RotCentrum,szog);
          pFazis := pFazis + 1;
         end;
       amSelectArea   :
         begin
         Canvas.Pen.Style:=psDash;
         Canvas.Pen.Mode:=pmNotXor;
         Canvas.Rectangle(Origin.x,Origin.y,oldMovePt.x,oldMovePt.y);
         Canvas.Rectangle(Origin.x,Origin.y,MovePt.x,MovePt.y);
         Canvas.Pen.Style:=psSolid;
         end;
     end;
     goto 111;
  end;


  // Searching point, line or inside area
  CheckCurvePoints(X,Y);

  // Magnify with pressed right button and translate on paper
  if (Shift = [ssRight]) and (pFazis=0) then begin
     if ((Origin.x<>x) or (Origin.y<>y)) then begin
        If y<oldMovePt.y then
           Zoom := Zoom * 1.1
        else
           Zoom := Zoom * 0.9;
        Zooming := True;
        goto 111;
     end;
  end;

  // Draw a shape
  if Shift <> [ssRight] then
  if (DrawMode<>dmNone) and (pFazis>0) {and (not Zooming)} then begin
     FCurve := FCurveList.Items[h];
     if MaxPointsCount>=FCurve.FPoints.Count then begin
        Case DrawMode of
        dmRectangle :
        begin
          FCurve.GetPoint(0,pr.x,pr.y,pr.z);
          FCurve.ClearPoints;
          // Circle From left botton corner
          FCurve.AddPoint(pr.x,pr.y,pr.z);
          FCurve.AddPoint(xx,pr.y,pr.z);
          FCurve.AddPoint(xx,yy,pr.z);
          FCurve.AddPoint(pr.x,yy,pr.z);
          Paint;
        end;
        dmArc :
        begin
          if Selected.FPoints.Count=1 then
             FCurve.AddPoint(xx,yy,pr.z)
          else
             FCurve.ChangePoint(1,xx,yy,pr.z);
          Paint;
        end;
        else begin
          FCurve.AddPoint(xx,yy,pr.z);
          Paint;
          if (DrawMode<>dmFreeHand) then
             FCurve.DeletePoint(Pred(FCurve.FPoints.Count));
        end;
        end;
     end else pFazis:=0;
  end;

  MouseInOut:=0;
  {Hint ablak rajzolása}
  If Hinted then begin
  If (CPMatch or CurveIn) and (Shift = []) then begin
     Hint1.Font.Size:=4;
     If CPMatch then
        Hintstr := fCurve.Name+' ['+IntToStr(CPCurve)+'/'+IntToStr(CPIndex)+']  ';
     pr:=FCurve.GetPointRec(CPIndex);
     p := ClientToScreen(point(x+8,y-18));
     w := Hint1.Canvas.TextWidth(Hintstr);
     he := 2*Hint1.Canvas.TextHeight(Hintstr)+2;
     Hintstr := Hintstr+'  Z = '+Format('%6.1f',[pr.z]);
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

111: oldMovePt := Point(x,y);
  inherited MouseMove(Shift,X,Y);
end;

procedure TALCustomSablon3d.MouseUp(Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
Var pr    : TPointRec;
begin
  MousePos := Point(x,y);
  if (not Zooming) and (Button=mbRight) then begin
     if (DrawMode=dmNone) or (pFazis<1) then begin
        // Move to center with right button
        MoveWindow((Width div 2)-x,y-(Height div 2));
     end;
     pFazis := 0;
  end
     else invalidate;
  If (not Paning) and (not Zooming) and (not Painting) and (Button<>mbRight) and AutoUndo then
     UndoSave;
  if (ActionMode=amSelectArea) or (Shift = [ssAlt]) then begin
     ActionMode:=amNone;
     SelectAllInArea(Rect2d(XToW(Origin.x),YToW(Origin.y),XToW(x),YToW(y)));
  end;
  if (ActionMode=amSelectAreaEx) or (Shift = [ssAlt,ssCtrl]) then begin
     ActionMode:=amNone;
     SelectAllInAreaEx(Rect2d(XToW(Origin.x),YToW(Origin.y),XToW(x),YToW(y)));
  end;
  if (ActionMode in [amMovePoint,amMoveSelected]) then
     ActionMode := amNone;

 if Paning then Screen.Cursor := crDefault;
       Paning   := False;
       Zooming  := False;
       Painting := False;
       Moving   := False;

  SignedNotCutting;

  inherited MouseUp(Button,Shift,X,Y);
end;

procedure TALCustomSablon3d.CMMouseEnter(var msg:TMessage);
begin
    inherited;
    MouseInOut:=1;
    oldCursorCross:=CursorCross;
    if not Focused then
//    SetFocus;
    invalidate;
    if Assigned(FMouseEnter) then FMouseEnter(Self);
end;

procedure TALCustomSablon3d.CMMouseLeave(var msg: TMessage);
begin
    inherited;
    MouseInOut:=-1;
    CursorCross:=oldCursorCross;
    oldCursorCross := False;
  if Assigned(fChangeWindow) then
     fChangeWindow(Self,fOrigo.x,fOrigo.Y,fZoom,fOrigo.x-100,fOrigo.y-100);
    invalidate;
    if Assigned(FMouseLeave) then FMouseLeave(Self);
end;


procedure TALCustomSablon3d.ZoomPaper;
var nagyx,nagyy : extended;
begin
  If PaperVisible then begin
  Try
     nagyx := Width /(Paper.x +20);
     nagyy := Height/(Paper.y +20);
  except
     nagyx:=1; nagyy:=1;
  end;
  If nagyx > nagyy Then nagyx:= nagyy;
  fCentrum.x := Paper.x/2;
  fCentrum.y := Paper.y/2;
  Zoom:= nagyx;
  end;
end;

// Total drawing in screen
procedure TALCustomSablon3d.ZoomDrawing;
var nagyx,nagyy : extended;
    I,J: integer;
    BR: TRect2d;
    x1,x2,y1,y2: TFloat;
begin
 if FCurveList.Count=0 then begin
    ZoomPaper;
    exit;
 end;
 J:=Pred(FCurveList.Count);
 if J>-1 then begin
    x1:=1e+10; y1:=1e+10;
    x2:=-1e+10; y2:=-1e+10;
    for I:=0 to J do
    begin
      FCurve:=FCurveList.Items[I];
      BR := FCurve.BoundsRect;
      if BR.x1<x1 then x1:=BR.x1;
      if BR.y1<y1 then y1:=BR.y1;
      if BR.x2>x2 then x2:=BR.x2;
      if BR.y2>y2 then y2:=BR.y2;
    end;
  Try
     nagyx := Width /(x2-x1);
     nagyy := Height/(y2-y1);
  except
     nagyx:=1; nagyy:=1;
  end;
  If nagyx > nagyy Then nagyx:= nagyy;
  fCentrum.x := (x2+x1)/2;
  fCentrum.y := (y2+y1)/2;
  Zoom:= 0.9*nagyx;
 end;
end;

procedure TALCustomSablon3d.SetCentralCross(const Value: boolean);
begin
  fCentralCross := Value;
  Invalidate;
end;

procedure TALCustomSablon3d.MoveWindow(dx, dy: integer);
begin
if not painting then begin
  fOrigo.x := fOrigo.x - dx/Zoom;
  fOrigo.y := fOrigo.y - dy/Zoom;
  oldCentrum := OrigoToCent;
  fCentrum.x := oldCentrum.x;
  Centrum.y := oldCentrum.y;
end;
end;

procedure TALCustomSablon3d.Normalisation(Down: boolean);
var r: TRect2d;
    margo: integer;
begin
  margo:=20;
  r := GetDrawExtension;
  if down then Eltolas(-r.x1+Grid.margin,-r.y1+Grid.margin)
  else Eltolas(-r.x1+Grid.margin,Paper.y-r.y2-Grid.margin);
  Paint;
end;

procedure TALCustomSablon3d.WorkpositionToCentrum;
begin
  MoveCentrum(WorkPosition.WorkPoint.x,WorkPosition.WorkPoint.y);
end;

procedure TALCustomSablon3d.MoveCentrum(fx,fy: double);
begin
  fCentrum.x := fx;
  Centrum.y := fy;
end;

// TALCustomSablon3d ===============================================================

procedure TALCustomSablon3d.SetCursorCross(const Value: boolean);
begin
  fCursorCross := Value;
  oldCursorCross:=fCursorCross;
  invalidate;
end;

function TALCustomSablon3d.GetWindow: TRect2d;
begin
  Result := Rect2d(Origo.x,origo.y,XToW(width),YToW(0));
end;

procedure TALCustomSablon3d.SetWindow(const Value: TRect2d);
begin
  fOrigo.x := Value.x1;
  fOrigo.y := Value.y1;
  Zoom     := 1;
end;

procedure TALCustomSablon3d.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1
end;

procedure TALCustomSablon3d.SetDrawMode(const Value: TDrawMode);
begin
  if Locked then FDrawMode := dmNone else FDrawMode := Value;
  if Value = dmNone then
     FActionMode := amNone
  else
     FActionMode := amDrawing;
  pFazis    := 0;
  MaxPointsCount := High(integer);
  Case Value of
       dmNone     : Cursor := crDefault;
       dmPolyline : Cursor := crPolyline;
       dmPolygon  : Cursor := crPolygon;
       dmPoint    : MaxPointsCount := 1;
       dmLine,dmCircle,dmEllipse : MaxPointsCount := 2;
       dmArc      : MaxPointsCount := 3;
       dmRectangle: MaxPointsCount := 4;
       dmText :
         begin
           ActText := InputBox('Text','',ActText);
           if ActText<>'' then
              pFazis    := 1;
              MaxPointsCount := 2;
              h:=MakeCurve('Text',-1,DrawMode,True,True,False);
              Selected.Name := ActText;
         end;
       dmFreeHand : Cursor := crFreeHand;
  else MaxPointsCount := High(integer);
  end;
  if Assigned(fChangeMode) then fChangeMode(Self,ActionMode,Value);
  invalidate;
end;

procedure TALCustomSablon3d.SetSensitiveRadius(const Value: integer);
begin
  FSensitiveRadius := Value;
  Delta := Value;
  If Value<4 then Delta := 4;
  Invalidate;
end;

function TALCustomSablon3d.AddCurve(ACurve: TCurve3d): integer;
begin
Try
  FCurveList.Pack;
  FCurveList.Add(ACurve);
  Result := FCurveList.Count-1;
  Changed := True;
except
  Result := -1;
end;
end;

procedure TALCustomSablon3d.AddPoint(AIndex: Integer; X, Y: TFloat);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    FCurve.AddPoint(X,Y,0);
    Selected := FCurve;
    Changed := True;
  end;
end;

procedure TALCustomSablon3d.AddPoint(AIndex: Integer; X, Y, Z: TFloat);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    FCurve.AddPoint(X,Y,Z);
    Selected := FCurve;
    Changed := True;
  end;
end;

procedure TALCustomSablon3d.AddPoint(AIndex: Integer; P: TPoint2d);
begin AddPoint(AIndex, P.X, P.Y); end;

procedure TALCustomSablon3d.DeletePoint(AIndex,APosition: Integer);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    FCurve.DeletePoint(APosition);
    if FCurve.FPoints.Count=0 then
       FCurveList.Delete(AIndex);
    Changed := True;
  end;
  Selected := FCurve;
end;
{------------------------------------------------------------------------------}

procedure TALCustomSablon3d.DeleteSamePoints(diff: TFloat);
// Deletes all same points in range of diff: only one point remains
// Azonos vagy nagyon közeli pontok kiejtése
var i,j,k  : integer;
    x,y,z  : TFloat;
    x1,y1,z1 : TFloat;
begin
  for i:=0 to Pred(FCurveList.Count) do begin
    FCurve:=FCurveList.Items[i];
    if FCurve.FPoints.Count>=1 then begin
    j:=0;
    repeat
          FCurve.GetPoint(j,x,y,z);
          Inc(j);
          repeat
                FCurve.GetPoint(j,x1,y1,z1);
                if (Abs(x-x1)<diff) and (Abs(y-y1)<diff) and (Abs(z-z1)<diff) then
                   FCurve.DeletePoint(j)
                else
                   Break;
          until (j>=FCurve.FPoints.Count-1);
    until j>=FCurve.FPoints.Count-1;
    end;
  end;
end;
{------------------------------------------------------------------------------}

procedure TALCustomSablon3d.CheckCurvePoints(X, Y: Integer);
var i,J,K,L,H: integer;
    Lx,Ly : TFloat;
    xx,yy : TFloat;
    InCode : TInCode;
begin
    CPMatch:=False;
    CPIndex:=0;
    CurveMatch:=False;
    CurveIn:=False;

    xx := XToW(x);
    yy := YToW(y);

    Delta := 4/zoom;
    if SensitiveRadius>3 then
       delta := SensitiveRadius/zoom;

    // Ha van kiválasztott obj, => az õ vizsgálata elsõdleges
    H:=-1;
    IF Selected<>nil then begin
       GetCurveHandle(Selected.name,H);
       if Selected.IsInBoundsRect(xx,yy) then begin
          L := Selected.IsOnPoint(xx, yy, delta);
          if L>-1 then begin
             GetPoint(H,L,Lx,Ly);
             CPMatch:=True;
             CPx:=Lx;
             CPy:=Ly;
             CPCurve:=H;
             CPIndex:=L;
//             Exit;
          end;
       end;
    end;

    J:=Pred(FCurveList.Count);

    for I:=0 to J do
    begin
      FCurve:=FCurveList.Items[I];
        InCode := FCurve.IsInCurve(xx,yy);
        if InCode=icOnLine then begin
           CurveMatch:=True;
           CPCurve:=I;
           if InCode=icIn then begin
              CurveIn:=True;
              CPCurve:=I;
           end;
           if inCode<>icOnPoint then begin
              K:=Pred(FCurve.FPoints.Count);
              for L:=K downto 0 do
              begin
                GetPoint(I,L,Lx,Ly);
                CPMatch:=(Abs(xx-Lx)<delta) and (Abs(yy-Ly)<delta);
                if CPMatch then
                begin
                   CPx:=Lx;
                   CPy:=Ly;
                   CPCurve:=I;
                   CPIndex:=L;
                   Exit;
                end;
              end;
           end;
        end;
    end;
end;

procedure TALCustomSablon3d.DeleteCurve(AItem: Integer);
begin
  if AItem < FCurveList.Count then
  begin
//    if AutoUndo then UndoSave;
    FCurve:=FCurveList.Items[AItem];
    FCurveList.Delete(AItem);
    FCurve.Destroy;
    Changed := True;
    Invalidate;
  end;
end;

procedure TALCustomSablon3d.InsertCurve(AIndex: Integer; Curve: TCurve3d);
begin
  if (AIndex > -1) and (AIndex < FCurveList.Count-1) then
  begin
    FCurveList.Insert(AIndex,Curve);
    Changed := True;
  end;
end;

function TALCustomSablon3d.GetMaxPoints: Integer;
var
  I,Max: Integer;
begin
  Max:=0;
  for I:=0 to Pred(FCurveList.Count) do
  begin
    FCurve:=FCurveList.Items[I];
    if FCurve<>nil then
    if FCurve.FPoints.Count > Max then Max:=FCurve.FPoints.Count;
  end;
  Result:=Max;
end;

// Searching for the nearest point in graph
// Result : distance from p point
//    VAR : cuvIdx = Curve's number
//          pIdx   = Point's number
function  TALCustomSablon3d.GetNearestPoint(p: TPoint2d; var cuvIdx, pIdx: integer): TFloat;
var
  I,J : Integer;
  d   : Double;
  x,y,z: double;
  Cuv : TCurve3d;
  p0,p1,p2,mp : TPoint2d;
begin
  Result := 10e+10;
  cuvIdx := -1;
  pIdx   := -1;
  for I:=0 to Pred(FCurveList.Count) do
  begin
    Cuv:=FCurveList.Items[I];
    if Cuv.Visible then
    For J:=0 to Pred(Cuv.FPoints.Count) do
    begin
        Cuv.GetPoint(j,x,y,z);
        d:=KetPontTavolsaga(p.x,p.y,x,y);
        if d<Result then begin
           cuvIdx := I;
           pIdx   := J;
           Result := d;
        end;
    end;
  end;
  // Ha talál objektumot, meg kell vizsgálni, hogy nem metszi-e:
  // Ha igen, akkor a metszett közeli vonalszakasz legközelebbi végpontja kell.
  if CuvIdx>-1 then begin
     Cuv := FCurveList.Items[CuvIdx];
     p0:=Cuv.GetPoint2d(pIdx);
     if Cuv.IsCutLine(p,p0) then begin
        For J:=0 to Cuv.FPoints.Count-2 do begin
            p1:=Cuv.GetPoint2d(j);
            p2:=Cuv.GetPoint2d(j+1);
            if SzakaszSzakaszMetszes(p,p0,Point2d(p1.x,p1.y),Point2d(p2.x,p2.y),mp) then begin
               if KetPontTavolsaga(p.x,p.y,p1.x,p1.y)<=
                  KetPontTavolsaga(p.x,p.y,p2.x,p2.y)
               then begin
                  pIdx   := J;
                  d:=KetPontTavolsaga(p.x,p.y,p1.x,p1.y);
               end else begin
                  pIdx   := J+1;
                  d:=KetPontTavolsaga(p.x,p.y,p2.x,p2.y);
               end;
               Break;
            end;
        end;
     end;
  end;
  // Ha nem talál, akkor a távolság -1; CuvIdx=-1; pIdx=-1;
  if cuvIdx=-1 then Result := -1;
end;

procedure TALCustomSablon3d.GetPoint(AIndex, APosition: Integer; var X, Y, Z: TFloat);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    if InRange(APosition,0,Pred(FCurve.FPoints.Count)) then
      FCurve.GetPoint(APosition,X,Y,Z);
  end;
end;

procedure TALCustomSablon3d.GetPoint(AIndex, APosition: Integer; var X, Y: TFloat);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    if InRange(APosition,0,Pred(FCurve.FPoints.Count)) then
      FCurve.GetPoint(APosition,X,Y);
  end;
end;

procedure TALCustomSablon3d.DoMove(Dx,Dy: Integer);
begin
  if CPMatch then begin
    CPx:=XToW(Dx);
    CPy:=YToW(Dy);
    ChangePoint(CPCurve,CPIndex,CPx,CPy);
    Paint;
  end;
end;

procedure TALCustomSablon3d.InversCurve(AIndex: Integer);
var
  I,H,N: Integer;
  X,Y: TFloat;
  Size: Word;
  PA: Array[0..1000] of TPoint;
  p0: TPoint;
  R : HRgn;
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
  Try
      FCurve:=FCurveList.Items[AIndex];
      N := FCurve.FPoints.Count+1;
      for I:=0 to Pred(N) do
      begin
        FCurve.GetPoint(I,X,Y);
        PA[I].x:=Trunc(X);
        PA[I].y:=Trunc(Y);
      end;
        FCurve.GetPoint(0,X,Y);
        PA[i+1].x:=Trunc(X);
        PA[i+1].y:=Trunc(Y);
	R := CreatePolygonRgn(PA,N,ALTERNATE);
        InvertRgn(Canvas.Handle,R);
  finally
     DeleteObject(R);
  end;
  end;
end;

(*  CREATE A NEW CURVE
    If ID<0 then ID:=Index of Curve
*)
function TALCustomSablon3d.MakeCurve(const AName: Str32; ID: integer;
  Shape: TDrawMode; AEnabled, AVisible, AClosed: Boolean): Integer;
begin
Try
  Result := ID;
  IF ID<0 then Result:=FCurveList.IndexOf(FCurve)+1;
  FCurve:=TCurve3d.Create;
  if Pos('_',Aname)>0 then
     FCurve.Name:=AName
  else
     FCurve.Name:=AName+'_'+IntToStr(Result);
  FCurve.ID      := Result;
  FCurve.Font.Assign(Font);
  FCurve.Enabled := AEnabled;
  FCurve.Visible := AVisible;
  FCurve.Closed  := AClosed;
  FCurve.Shape   := Shape;
  FCurve.OnChange:= Change;
  FCurveList.Add(FCurve);
  Selected := FCurve;
  Result:=FCurveList.IndexOf(FCurve);
except
  Result := -1;
end;
end;

function TALCustomSablon3d.GetCurveHandle(AName: Str32; var H: Integer): Boolean;
var
  I,J: Integer;
begin
  H:=-1;
  J:=FCurveList.Count;
  I:=0;
  AName:=AnsiUpperCase(AName);
  while I < J do
  begin
    FCurve:=FCurveList.Items[I];
    if AnsiUpperCase(FCurve.Name) = AnsiUpperCase(AName) then
    begin
      H:=I;
      Break;
    end;
    Inc(I);
  end;
  Result:=(H>-1) and (H<J);
end;

function TALCustomSablon3d.GetCurveName(H: Integer): Str32;
begin
  Result:='';
  if (H < 0) or (H > Pred(FCurveList.Count)) then Exit;
  FCurve:=FCurveList.Items[H];
  Result:=FCurve.Name;
end;

procedure TALCustomSablon3d.SetShowPoints(const Value: boolean);
begin
  fShowPoints := Value;
  Invalidate;
end;

procedure TALCustomSablon3d.SetWorking(const Value: boolean);
begin
  fWorking := Value;
  Paint;
end;

procedure TALCustomSablon3d.Clear;
var i: integer;
begin
(*  for I:=Pred(FCurveList.Count) downto 0 do
  begin
    FCurve:=FCurveList.Items[I];
    FCurve.Free;
  end;*)
  FCurveList.Clear;
  invalidate;
end;

procedure TALCustomSablon3d.SelectAll(all: boolean);
var i,j: integer;
    cuv: TCurve3d;
    pr: TPointRec3d;
begin
//  Loading := True;
  for i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      Cuv.Selected := all;
      For j:=0 to Pred(Cuv.Count) do
          Cuv.SelectPoint(j,all);
  end;
  if Assigned(FChangeAll) then FChangeAll(Self);
//  Loading := False;
  Invalidate;
end;

procedure TALCustomSablon3d.EnabledAll(all: boolean);
var i: integer;
    cuv: TCurve3d;
begin
  For i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      Cuv.Enabled:=all;
  end;
  if Assigned(FChangeAll) then FChangeAll(Self);
  Invalidate;
end;

procedure TALCustomSablon3d.SignedAll(all: boolean);
var i: integer;
    cuv: TCurve3d;
begin
  For i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      Cuv.Signed:=all;
  end;
  if Assigned(FChangeAll) then FChangeAll(Self);
  Invalidate;
end;

// Select all curves in Area
procedure TALCustomSablon3d.SelectAllInArea(R: TRect2d);
var i: integer;
    cuv: TCurve3d;
    RR,RC : TRect2d;
begin
//  Loading := True;
  RR := CorrectRealRect(R);
  for i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      RC := CorrectRealRect(Cuv.BoundsRect);
      If (RR.X1<=RC.X1) and (RR.X2>=RC.X2) and
         (RR.Y1<=RC.Y1) and (RR.Y2>=RC.Y2) then
         Cuv.Selected := True;
  end;
  if Assigned(FChangeAll) then FChangeAll(Self);
//  Loading := False;
  Invalidate;
end;

// Select all points in Area
procedure TALCustomSablon3d.SelectAllInAreaEx(R: TRect2d);
var i,j: integer;
    cuv: TCurve3d;
    RR,RC : TRect2d;
    pr: TPointrec3d;
begin
//  Loading := True;
  RR := CorrectRealRect(R);
  for i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      for j:=0 to Pred(Cuv.Count) do begin
          pr := Cuv.PointRec[j];
          if PontInKep(pr.x,pr.y,R) then
             Cuv.SelectPoint(j,True);
      end;
  end;
  if Assigned(FChangeAll) then FChangeAll(Self);
//  Loading := False;
  Invalidate;
end;

procedure TALCustomSablon3d.SelectAllPolygons;
var i: integer;
    cuv: TCurve3d;
begin
  for i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      cuv.Selected := Cuv.Shape = dmPolygon;
  end;
  if Assigned(FChangeAll) then FChangeAll(Self);
  Invalidate;
end;

procedure TALCustomSablon3d.SelectAllPolylines;
var i: integer;
    cuv: TCurve3d;
begin
  for i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      cuv.Selected := (Cuv.Shape = dmPolyLine) AND (not Cuv.Closed);
  end;
  if Assigned(FChangeAll) then FChangeAll(Self);
  Invalidate;
end;


procedure TALCustomSablon3d.ClosedAll(all: boolean);
var i: integer;
    cuv: TCurve3d;
begin
  for i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      if cuv.Selected then begin
         Cuv.Closed := all;
         if Cuv.Shape = dmPolyLine then
            Cuv.Shape := dmPolygon;
      end;
  end;
  if Assigned(FChangeAll) then FChangeAll(Self);
  Changed := True;
  Invalidate;
end;


function TALCustomSablon3d.LoadFromDXF(const FileName: string): Boolean;
Type TDXFSec = (POINT,LINE,POLYLINE,LWPOLYLINE,CIRCLE,ARC,SPLINE);
var
  f: TEXTFILE;
  sor : string;
  NewFileName : string;
  N,i,k: Integer;
  x,y  : real;
  NewCurve : boolean;
  DXFSec   : TDXFSec;
  closed   : boolean;
  elso     : boolean;
  FirstPoint,EndPoint : TPointRec;
  arcU,arcV,arcR,arcSAngle,arcEAngle: TFloat;
  szog,kk,deltaFI  : TFloat;
  arcPPP : T3Point2d;
const DXFstr : array[0..6] of string =
          ('POINT','LINE','POLYLINE','LWPOLYLINE','CIRCLE','ARC','SPLINE');
label 111;

  {Alakzat név keresés}
  function DXFKeres(s: string):integer;
  var j: integer;
  begin
    Result := -1;
    For j:=0 to High(DXFstr) do
        If s=DXFstr[j] then begin
            Result := j;
            Break;
        end;
  end;

  function ValidDXF(FN: STRING):boolean;
  Var ff,df: File;
      newFile: string;
      fsor : array[1..128] of Char;
      z,NumRead,NumWritten  : integer;
      buf  : char;
  begin
       result := False;
    Try
       if not FileExists(fn) then Exit;
       try
       Loading := True;
       {$I-}
       AssignFile(ff,FN);
       system.Reset(ff,1);
       {$I+}
       BlockRead(ff,fsor,SizeOf(fsor),NumRead);
       For z:=2 to 128 do
           if (fsor[z] = #10) and (fsor[z-1] = #13) then Result := True;
       newFile:=ExtractFilePath(fn)+'_'+ExtractFileName(fn);
       if not FileExists(newFile) then
       if not Result then begin
          Screen.Cursor := crHourGlass;
          system.Reset(ff,1);
          {$I-}
          AssignFile(df,newFile);
          system.Rewrite(df,1);
          {$I+}
          repeat
                BlockRead(ff, Buf, SizeOf(Buf), NumRead);
                if buf=#10 then begin
                   Buf := #13;
                   BlockWrite(dF, Buf, 1, NumWritten);
                   Buf := #10;
                   BlockWrite(dF, Buf, 1, NumWritten);
                end else
                   BlockWrite(dF, Buf, NumRead, NumWritten);
          until (NumRead = 0) or (NumWritten <> NumRead);
          CloseFile(df);
       end;
       finally
         CloseFile(ff);
       end;
    except
       result := False;
    end;
  end;

begin
  FormatSettings.Decimalseparator := '.';
  Result:=False;
  Loading := True;
  if not FileExists(FileName) then Exit;
  newFileName:=ExtractFilePath(FileName)+'_'+ExtractFileName(FileName);
  if not ValidDXF(FileName) then
     newFileName:=ExtractFilePath(FileName)+'_'+ExtractFileName(FileName)
  else
     newFileName:=FileName;

  try
  {$I-}
    AssignFile(f,NewFileName);
    system.Reset(f);
  {$I+}
    try
      repeat
        ReadLn(f,sor)
      Until sor='ENTITIES';
      NewCurve := False;
      k:=0;
      repeat
111:    ReadLn(f,sor);
        k := DXFKeres(sor);
        elso := True;
        If k>-1 then begin
            DXFSec := TDXFSec(k);
            Case DXFSec of
            LINE :
              N:=MakeCurve('Line',-1,dmLine,True,True,False);
            POLYLINE :
            begin
                repeat
                    ReadLn(f,sor);
                    If (sor = '70') OR (sor = ' 66') then begin
                        ReadLn(f,sor);
                        Closed := (StrToInt(sor) and 1)=1;
                    end;
                until sor='VERTEX';
                N:=MakeCurve('Polyline',-1,dmPolygon,True,True,True);
            end;

            LWPOLYLINE :
                N:=MakeCurve('Polyline',-1,dmPolygon,True,True,True);

            CIRCLE :
            begin
            repeat
            ReadLn(f,sor);
            If sor = ' 10' then begin
               ReadLn(f,sor);
               arcU := StrToFloat(Alltrim(sor));
            end;
            If sor = ' 20' then begin
               ReadLn(f,sor);
               arcV := StrToFloat(Alltrim(sor));
            end;
            If sor = ' 40' then begin
               ReadLn(f,sor);
               arcR := StrToFloat(Alltrim(sor));
            end;
            Until (sor='  0') or EOF(f);
               N:=MakeCurve('Circle',-1,dmPolygon,True,True,True);
               szog := 0;
               deltaFI := (2*PI*2)/(2*arcR*PI);
               While (szog>=0) and (szog<=(2*pi)) do begin
                    x := ArcU + ArcR * cos(szog);
                    y := ArcV + ArcR * sin(szog);
                    AddPoint(N,x,y);
                    szog := szog+deltaFI;
               end;
               if (szog-deltaFI)<arcEAngle then begin
                    x := ArcU + ArcR * cos(arcEAngle);
                    y := ArcV + ArcR * sin(arcEAngle);
                    AddPoint(N,x,y);
               end;
               goto 111;
            end;

            ARC :
            begin
            repeat
            ReadLn(f,sor);
            If sor = ' 10' then begin      {Center x}
               ReadLn(f,sor);
               arcU := StrToFloat(Alltrim(sor));
            end;
            If sor = ' 20' then begin      {Center y}
               ReadLn(f,sor);
               arcV := StrToFloat(Alltrim(sor));
            end;
            If sor = ' 40' then begin      {Radius}
               ReadLn(f,sor);
               arcR := StrToFloat(Alltrim(sor));
            end;
            If sor = ' 50' then begin      {Start angle}
               ReadLn(f,sor);
               arcSAngle := StrToFloat(Alltrim(sor));
            end;
            If sor = ' 51' then begin      {End angle}
               ReadLn(f,sor);
               arcEAngle := StrToFloat(Alltrim(sor));
               {Átszámítás 3 kerületi pontra}
               arcPPP := KorivbolHarompont(arcU,arcV,arcR,Radian(arcSAngle),Radian(arcEAngle));
            end;
            Until (sor='  0') or EOF(f);
               N:=MakeCurve('Arc',-1,dmPolygon,True,True,False);
               arcSAngle := Radian(arcSAngle);
               arcEAngle := Radian(arcEAngle);
               if arcSAngle>arcEAngle then begin
                  arcEAngle := 2*pi+arcEAngle;
               end;
               szog := arcSAngle;
               deltaFI := (2*PI*2)/(2*arcR*PI);
               While (szog>=arcSAngle) and (szog<=arcEAngle) do begin
                    x := ArcU + ArcR * cos(szog);
                    y := ArcV + ArcR * sin(szog);
                    AddPoint(N,x,y);
                    szog := szog+deltaFI;
               end;
               if (szog-deltaFI)<arcEAngle then begin
                    x := ArcU + ArcR * cos(arcEAngle);
                    y := ArcV + ArcR * sin(arcEAngle);
                    AddPoint(N,x,y);
               end;
               goto 111;
            end;

            SPLINE :
            begin
                Closed := True;
                N:=MakeCurve('Spline',-1,dmPolygon,True,True,Closed);
            end;
            end;

            Repeat
                ReadLn(f,sor);
                if ((DXFSec=SPLINE) or (DXFSec=LINE)) and (sor='  0') then
                   break;
                sor := sor;
                If (sor=' 10') or (sor=' 11') then begin
                    ReadLn(f,sor); x:=StrToFloat(sor);
                end;
                If (sor=' 20') or (sor=' 21') then begin
                    ReadLn(f,sor); y:=StrToFloat(sor);
                    AddPoint(N,x,y);
                    If elso then begin
                        FirstPoint.x := x;
                        FirstPoint.y := y;
                        elso := False;
                    end;
                    EndPoint.x := x;
                    EndPoint.y := y;
                end;
            until (sor='SEQEND') or (sor='ENDSEC') or EOF(f);
            if (DXFSec=POLYLINE) and (not Closed) then begin
               FCurve := FCurveList.Items[N];
               FCurve.Closed := (FirstPoint.x=EndPoint.x) and (FirstPoint.y=EndPoint.y);
            end;


        end;
      Until sor='EOF';

    except
      Result:=False;
    end;
  finally
    CloseFile(f);
    Paint;
    if AutoUndo then UndoSave;
    Loading := False;
  end;
end;

function TALCustomSablon3d.LoadFromPLT(const FileName: string): Boolean;
var f     : TEXTFILE;
    sor,S : string;
    k,N,i,pv,vpoz  : integer;
    x,y            : double;
    oldPLT: Boolean;
    KOD   : string;
    xx,yy : string;
    pd    : Boolean;  // Pen down = True; Pen up = False
    FirstPoint,EndPoint : TPoint;
    elso  : boolean;
    Shape : TDrawMode;
begin
Try
  Loading := True;
  k := 0;
  Shape:=dmPolygon;
  AssignFile(f,FileName);
  system.Reset(f);
  ReadLn(f,sor);
  pv := StrCount(sor,';');
  oldPLT:=pv>1;
  if oldPLT then      // Régebbi tipusú PLT file
  BEGIN
     i:=1;
     While i<pv do begin
        vpoz := Pos(';',sor);

        if vpoz>0 then begin

        s := UpperCase(Copy(sor,1,vpoz-1));
        sor := Copy(sor,vpoz+1,Length(sor));

        KOD := UpperCase(Copy(s,1,2));
        if (KOD='SP0') or (s='EC') then break;
        if (KOD='PU') then pd:=False;
        if (KOD='PD') then pd:=True;
        if (KOD='PA') then
        begin
             if not pd then begin
                if k>0 then begin
                   FCurve := FCurveList.Items[N];
                   FCurve.Closed := (Abs(FirstPoint.x-EndPoint.x)<0.5) and (Abs(FirstPoint.y-EndPoint.y)<0.5);
                   if FCurve.Closed then FCurve.Shape:=dmPolygon else FCurve.Shape:=dmPolyline;
                   FCurveList.Items[N]:=FCurve;
                end;
                N:=MakeCurve('Object',-1,Shape,True,True,True);
                elso := True;
                Inc(k);
             end;
             S := Copy(s,3,100);
             xx := StrCountD(s,',',1);
             yy := StrCountD(s,',',2);
             Try
             Try
                x := strtoFloat(xx)/39.37;
                y := strtoFloat(yy)/39.37;
             finally
                If elso then begin
                   FirstPoint.x := StrToInt(xx);
                   FirstPoint.y := StrToInt(yy);
                   elso := False;
                end;
                FCurve.AddPoint(x,y,0);
                EndPoint.x := StrToInt(xx);
                EndPoint.y := StrToInt(yy);
             end;
             except
                Continue;
             end;
        end;

        end;

        Inc(i);
     end;
  END
  else           // Új tipusú PLT file (CorelDraw 12)
  Repeat
    KOD := UpperCase(Copy(sor,1,2));
    if (KOD='SP0') then break;
    if (KOD='PU') or (KOD='PD') then
    begin
      if KOD='PU' then begin
         if k>0 then begin
               FCurve := FCurveList.Items[N];
               FCurve.Closed := (Abs(FirstPoint.x-EndPoint.x)<0.5) and (Abs(FirstPoint.y-EndPoint.y)<0.5);
               if FCurve.Closed then FCurve.Shape:=dmPolygon else FCurve.Shape:=dmPolyline;
               FCurveList.Items[N]:=FCurve;
         end;
         N:=MakeCurve('Object',-1,Shape,True,True,True);
         elso := True;
         Inc(k);
      end;
      S := Copy(sor,3,100);
      s := DelSub(s,';');
      If Pos(' ',s)>0 then begin
      xx := Copy(s,1,Pos(' ',s)-1);
      yy := Copy(s,Pos(' ',s)+1,Length(s));
      Try
      Try
         x := strtoFloat(xx)/39.37;
         y := strtoFloat(yy)/39.37;
      finally
         If elso then begin
            FirstPoint.x := StrToInt(xx);
            FirstPoint.y := StrToInt(yy);
            elso := False;
         end;
         FCurve.AddPoint(x,y,0);
         EndPoint.x := StrToInt(xx);
         EndPoint.y := StrToInt(yy);
      end;
      except
         Continue;
      end;
      end;
    end;
    ReadLn(f,sor);
  Until EOF(f);
finally
  CloseFile(f);
  Normalisation(True);
  Loading := False;
  Paint;
end;
end;
{------------------------------------------------------------------------------}

function TALCustomSablon3d.LoadCurveFromFile(const FileName: string): Boolean;
var
  FileStream: TFileStream;
begin
  Result:=False;
  if not FileExists(FileName) then Exit;
  try
    FileStream:=TFileStream.Create(FileName,fmOpenRead);
    try
      FileStream.Position:=0;
      Result:=LoadCurveFromStream(FileStream);
    except
      Result:=False;
    end;
  finally
    FileStream.Free;
  end;
  IF AutoUndo then UndoSave;
end;

{------------------------------------------------------------------------------}

procedure TALCustomSablon3d.SetDefaultLayer(const Value: Byte);
begin
  fDefaultLayer := Value;
  invalidate;
end;

procedure TALCustomSablon3d.SetActionMode(const Value: TActionMode);
begin
  DrawMode    := dmNone;
  fActionMode := Value;
  pFazis      := 0;
  Case Value of
  amNone           : Cursor := crDefault;
  amInsertPoint    : Cursor := crInsertPoint;
  amDeletePoint    : Cursor := crDeletePoint;
  amNewBeginPoint  : Cursor := crNewBeginPoint;
  amRotateSelected : Cursor := crRotateSelected;
  end;
  if Assigned(fChangeMode) then fChangeMode(Self,Value,DrawMode);
end;

procedure TALCustomSablon3d.InsertPoint(AIndex,APosition: Integer; X,Y: TFloat);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    FCurve.InsertPoint(APosition,X,Y,0);
    Selected := FCurve;
    Changed := True;
  end;
end;

procedure TALCustomSablon3d.InsertPoint(AIndex,APosition: Integer; P: TPoint2d);
begin InsertPoint(AIndex,APosition,P.X,P.Y); end;

procedure TALCustomSablon3d.ChangePoint(AIndex, APosition: Integer; X,Y: TFloat);
var p: TPoint3d;
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    p:=FCurve.GetPoint3d(APosition);
    if APosition < FCurve.FPoints.Count then FCurve.ChangePoint(APosition,X,Y,p.Z);
    Selected := FCurve;
    Changed := True;
  end;
end;

procedure TALCustomSablon3d.MoveCurve(AIndex :integer; Ax, Ay: TFloat);
var i: integer;
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then begin
      FCurve:=FCurveList.Items[AIndex];
      FCurve.MoveCurve(Ax/Zoom, Ay/Zoom,0);
      Selected := FCurve;
      Changed := True;
  end;
  RePaint;
end;

procedure TALCustomSablon3d.MoveSelectedCurves(Ax, Ay: TFloat);
var i: integer;
begin
  for i:=0 to Pred(FCurveList.Count) do begin
      FCurve:=FCurveList.Items[i];
      if FCurve.Selected then FCurve.MoveCurve(Ax/Zoom, Ay/Zoom,0)
      else
         FCurve.MoveSelectedPoints(Ax/Zoom, Ay/Zoom,0);
//      Selected := FCurve;
  end;
  Changed := True;
  RePaint;
end;

procedure TALCustomSablon3d.RotateSelectedCurves(Cent : TPoint2d; Angle: TFloat);
var i: integer;
begin
  for i:=0 to Pred(FCurveList.Count) do begin
      FCurve:=FCurveList.Items[i];
      if FCurve.Selected then FCurve.RotateCurve(Cent, Angle);
  end;
  Changed := True;
  RePaint;
end;

procedure TALCustomSablon3d.SetLocked(const Value: boolean);
var i: integer;
begin
  fLocked := Value;
  for i:=0 to Pred(FCurveList.Count) do begin
      FCurve:=FCurveList.Items[i];
      FCurve.Enabled := not Value;
  end;
  DrawMode := dmNone;
  UR.Enable := not Value;
  RePaint;
end;

procedure TALCustomSablon3d.SetpFazis(const Value: integer);
begin
  fpFazis := Value;
  Invalidate;
end;

function TALCustomSablon3d.IsRectInWindow(R: TRect2d): boolean;
var
    RW,RP: TRect;     // Window and R rectangle on screen
    RR: HRgn;
begin
  Result := False;
  Try
     RW:= Rect(-10,-10,Width+10,Height+10);
     RP:= Rect(XToS(R.x1),YToS(R.y1),XToS(R.x2),YToS(R.y2));
     RR:= CreateRectRgn(RW.Left,RW.Top,RW.Right,RW.Bottom);
     Result := RectInRegion(RR,RP);
  finally
     DeleteObject(RR);
  end;
end;

// Tru if point in screen window
function TALCustomSablon3d.IsPointInWindow(p: TPoint2d): boolean;
begin
   Result := PontInKep(XToS(p.x),YToS(p.y),Window);
end;

// True: if paper visible and part of paper is in window
function TALCustomSablon3d.IsPaperInWindow: boolean;
var
    RP: TRect2d;     // Paper rectangle
    RR: HRgn;
begin
  if PaperVisible then begin
     RP:= Rect2d(0,0,Paper.x,Paper.y);
     Result := IsRectInWindow(RP);
  end;
end;

// Deletes all selected curves and selected points
procedure TALCustomSablon3d.DeleteSelectedCurves;
var i,j: integer;
begin
  i:=0;
  if FCurveList.Count>0 then begin
  if AutoUndo then UndoSave;
  While i<=FCurveList.Count-1 do begin
      FCurve:=FCurveList.Items[i];
      if FCurve.Selected then begin
         FCurveList.Delete(i);
         Dec(i);
         Changed := True;
      end else
      For j:=Pred(FCurve.Count) downto 0 do
          if FCurve.PointRec[j].Selected then
             FCurve.DeletePoint(j);
      Inc(i);
  end;
  if AutoUndo then UndoSave;
  end;
  RePaint;
end;

procedure TALCustomSablon3d.InversSelectedCurves;
var i: integer;
begin
  for i:=0 to Pred(FCurveList.Count) do begin
      FCurve:=FCurveList.Items[i];
      FCurve.Selected := not FCurve.Selected;
  end;
  Invalidate;
end;

procedure TALCustomSablon3d.SetSelected(const Value: TCurve3d);
begin
  if not loading then begin
     fSelected := Value;
     fCurve := Value;
     invalidate;
     if Assigned(fChangeSelected) then fChangeSelected(Self,fSelected,CPIndex);
  end;
end;

procedure TALCustomSablon3d.Eltolas(dx,dy: double);
var n,i,j: integer;
    x,y: double;
begin
   For n:=0 to FCurveList.Count-1 do begin
      FCurve:=FCurveList.Items[n];
      J:=Pred(FCurve.FPoints.Count);
      FCurve.MoveCurve(dx,dy,0);
      Changed := True;
   end;
  if AutoUndo then UndoSave;
  Paint;
end;

procedure TALCustomSablon3d.Nyujtas(tenyezo: double);
var n,i,j: integer;
    x,y: double;
begin
   For n:=0 to FCurveList.Count-1 do begin
      FCurve:=FCurveList.Items[n];
      If FCurve.Enabled then begin
      J:=Pred(FCurve.FPoints.Count);
      for I:=0 to J do
      begin
        FCurve.GetPoint(i,X,Y);
        x := tenyezo * x;
        y := tenyezo * y;
        FCurve.ChangePoint(i,x,y,0);
      end;
      end;
   end;
  if AutoUndo then UndoSave;
  Paint;
end;

// Magnify from centrum
procedure TALCustomSablon3d.CentralisNyujtas(Cent: TPoint2d; tenyezo: double);
var n,i,j: integer;
    x,y: double;
begin
   For n:=0 to FCurveList.Count-1 do begin
      FCurve:=FCurveList.Items[n];
      If FCurve.Enabled then
         FCurve.MagnifyCurve(Cent, tenyezo);
   end;
  if AutoUndo then UndoSave;
  Paint;
end;

function TALCustomSablon3d.SaveCurveToStream(FileStream: TStream; Item: Integer): Boolean;
var
  NewCurveData: TNewCurveData;
  pp : ppoint;
  p : TPointRec3d;
  N: Integer;
begin
  Result:=False;
  if not InRange(Item,0,Pred(FCurveList.Count)) or not Assigned(FileStream) then Exit;
  FCurve:=FCurveList.Items[Item];
  try
    NewCurveData := FCurve.GetCurveData;
    FileStream.Write(NewCurveData,SizeOf(TNewCurveData));

    for N:=0 to Pred(FCurve.Count) do begin
      p := FCurve.PointRec[N];
      FileStream.Write(p.x,SizeOf(TFloat));
      FileStream.Write(p.y,SizeOf(TFloat));
      if not oldFile then
         FileStream.Write(p.z,SizeOf(TFloat));
    end;

    Result:=True;
  except
    ShowMessage('Error writing stream!');
  end;
end;
{------------------------------------------------------------------------------}

function TALCustomSablon3d.LoadCurveFromStream(FileStream: TStream): Boolean;
var
  CurveData: TNewCurveData;
  PointRec: TPointRec3d;
  H,N,P: Integer;
  XOfs: TFloat;
  YOfs: TFloat;
begin
  Result:=False;
  if not Assigned(FileStream) then Exit;
  try
    FileStream.Read(CurveData,SizeOf(TNewCurveData));
    P := CurveData.Points-1;
    H:=MakeCurve(CurveData.Name,-1,CurveData.Shape,CurveData.Enabled,CurveData.Visible,CurveData.Closed);
    XOfs:=0;
    YOfs:=0;

    for N:=0 to P do
    begin
      if FileStream.Read(PointRec.x,SizeOf(TFloat))<SizeOf(TFloat) then
         Exit;
      if FileStream.Read(PointRec.y,SizeOf(TFloat))<SizeOf(TFloat) then
         Exit;
      if not oldFile then begin
         if FileStream.Read(PointRec.z,SizeOf(TFloat))<SizeOf(TFloat) then
            Exit;
      end else
         PointRec.z := 0;
         AddPoint(H,PointRec.x+XOfs,PointRec.y+YOfs,PointRec.z);
    end;

    Result:=True;
  except
    ShowMessage('Error reading stream!');
  end;
end;

function TALCustomSablon3d.SaveGraphToFile(const FileName: string): Boolean;
var
  FileStream: TFileStream;
  NewGraphData: TNewGraphData;
  N: Integer;
  Ext: string;
begin
  Result:=False;
  try
    FileStream:=TFileStream.Create(FileName,fmCreate);
    try
      Ext := UpperCase(ExtractFileExt(FileName));
      FileStream.Position:=0;
      if Ext = '.SBN' then begin
         NewGraphData.Copyright := 'StellaFactory Obelisc Sablon Ver 1';
         NewGraphData.Version   := 1;
         NewGraphData.GraphTitle:=FGraphTitle;
         NewGraphData.Curves:=FCurveList.Count;
         FileStream.Write(NewGraphData,SizeOf(NewGraphData));
         oldFile := True;
      end;
      if Ext = '.SB3' then begin
         NewGraphData.Copyright := 'StellaFactory Obelisc Sablon Ver 2';
         NewGraphData.Version   := 2;
         NewGraphData.GraphTitle:=FGraphTitle;
         NewGraphData.Curves:=FCurveList.Count;
         FileStream.Write(NewGraphData,SizeOf(NewGraphData));
         oldFile := False;
      end;

      for N:=0 to Pred(NewGraphData.Curves) do
            SaveCurveToStream(FileStream,N);

      Result:=True;
    except
      Result:=False;
    end;
  finally
    FileStream.Free;
    Changed := False;
    oldFile := False;
  end;
end;

function TALCustomSablon3d.LoadGraphFromFile(const FileName: string): Boolean;
var
  FileStream: TFileStream;
  GraphData: TNewGraphData;
  N: Integer;
  au: boolean;
  ext: string;
begin
  Result  := False;
  if not FileExists(FileName) then Exit;
  try
    au := AutoUndo;
    AutoUndo := False;
    Loading := True;
    ext:=UpperCase(ExtractFileExt(FileName));
    oldFile := ext='.SBN';
    FileStream:=TFileStream.Create(FileName,fmOpenRead);
    try
      FileStream.Position:=0;
      FileStream.Read(GraphData,SizeOf(GraphData));
      FGraphTitle:=GraphData.GraphTitle;

      for N:=0 to Pred(GraphData.Curves) do
          if not LoadCurveFromStream(FileStream) then
          begin
             FileStream.Free;
             Clear;
             exit;
          end;

      Result:=True;
    except
      Result:=False;
    end;
  finally
    FileStream.Free;
    Repaint;
    AutoUndo := au;
    Loading := False;
    If AutoUndo then begin
       UndoSave;
    end;
  end;
end;

procedure TALCustomSablon3d.SaveGraphToMemoryStream(var stm: TMemoryStream);
var
  GraphData: TNewGraphData;
  N: Integer;
begin
    try
      oldFile:=False;
      GraphData.GraphTitle:=FGraphTitle;
      GraphData.Curves:=FCurveList.Count;
      stm.Clear;
      stm.Write(GraphData,SizeOf(GraphData));

      for N:=0 to Pred(GraphData.Curves) do
          SaveCurveToStream(stm,N);

    except
      exit;
    end;
end;

procedure TALCustomSablon3d.LoadGraphFromMemoryStream(stm: TMemoryStream);
var
  GraphData: TNewGraphData;
  N: Integer;
begin
  if stm=nil then Exit;
  try
      oldFile:=False;
      Loading := True;
      stm.Seek(0,0);
      stm.Read(GraphData,SizeOf(GraphData));
      FGraphTitle:=GraphData.GraphTitle;

      for N:=0 to Pred(GraphData.Curves) do begin
          LoadCurveFromStream(stm);
          TCurve3d(FCurveList.Items[FCurveList.Count-1]).Selected := True;
      end;
  except
      exit;
  end;
  Loading := False;
  Paint;
end;

procedure TALCustomSablon3d.DXFCurves;
var
  H,I,J: Integer;
  X,Y: TFloat;
  FCurve: TCurve3d;
begin
  for H:=0 to Pred(FCurveList.Count) do
  begin
    FCurve:=FCurveList.Items[H];
    if FCurve.Enabled and (FCurve.FPoints.Count > 0) then
    begin
      J:=Pred(FCurve.FPoints.Count);
      DXFOut.StartPolyLine(FCurve.Closed);
      for I:=0 to J do
      begin
        FCurve.GetPoint(I,X,Y);
        DXFOut.Vertex(DXFOut.ToX(X),DXFOut.ToY(Y),0);
      end;
      DXFOut.EndPolyLine;
      if Demo and (H>3) then exit;
    end;
  end;
end;

function TALCustomSablon3d.SaveToDXF(const FileName: string):boolean;
var r2d: TRect2d;
begin
  Result:=False;
  r2d:=GetDrawExtension;
  try
    DXFOut:=TDXFOut.Create(r2d.x1,r2d.y1,r2d.x2,r2d.y2,r2d.x1,r2d.y1,r2d.x2,r2d.y2,
                           16,3);
    try
      DXFOut.Header;
      DXFCurves;
      DXFOut.Trailer;
      DXFOut.StringList.SaveToFile(FileName);
      Result:=True;
    except
      Result:=False;
    end;
  finally
    DXFOut.Free;
  end;
end;

PROCEDURE TALCustomSablon3d.LoadFromDAT(Filename: STRING);
var D: Textfile;
    S,s1,s2: String;
    H,N: Integer;
    x,y: real;
    nCuv  : integer;
BEGIN
  if not FileExists(Filename) then exit;
Try
  Loading := True;
  nCuv := 0;
  AssignFile(D,Filename);
    Reset(D);
    // Read first line for text file examination
    Readln(D, S);

    H:=MakeCurve('DAT0',0,dmPolyline,True,True,False);

    // Ebben a text fileban csak soremelés karakterek vannak
    // azaz az elsõ felolvasással az egész file-t beolvassa
    if Length(s)>15 then begin
       s := trim(s);
       S := Stuff(s,#9,' ');
       S := Stuff(s,#10,' ');
       N := (StrCount(s,' ')+1) div 2;
       if N>0 then
       repeat
         s1 := StrCountD(s,' ',1);
         s2 := StrCountD(s,' ',2);
         x := strtofloat(s1);
         If s2='0.000' then y:=0 else
         y := strtofloat(s2);
         AddPoint(H,x,y);
         N  := CountPos(s,' ',2);
         s  := Trim(Copy(s,N,Length(s)));
       until N<1;
    end

    else

    repeat
      s := trim(s);

      if (Copy(s,1,1)<>';') and (s<>'') then begin
         S := Stuff(s,#9,' ');
         S := Stuff(s,#10,' ');
         s1 := StrCountD(s,' ',1);
         s2 := StrCountD(s,' ',2);
         If s1='0.000' then x:=0 else
         x := strtofloat(s1);
         If s2='0.000' then y:=0 else
         y := strtofloat(s2);
         AddPoint(H,x,y);
      end;

      if eof(D) then Break;

      Readln(D, S);

        if Trim(s)='' then begin
           s1 := ''+IntToStr(nCuv);
           H:=MakeCurve(s1,0,dmPolyline,True,True,False);
           Inc(nCuv);
        end;
    until False;

FINALLY
    CloseFile(D);
    Loading := False;
END;
END;

function TALCustomSablon3d.SaveToDAT(Filename: STRING):boolean;
var D: Textfile;
    r: TRect2d;
    szorzo: double;
    dx,dy: double;
    H,I,N: Integer;
    xx,yy: TFloat;
    s,s0: string;
    FCurve : TCurve3d;
BEGIN

Try
  Result := False;
  Loading := True;
  H := 0;
  AssignFile(D,Filename);
    Rewrite(D);
    r := GetDrawExtension;
    dx := r.x2-r.x1;
    dy := r.y2-r.y1;
    Eltolas(-r.x1,-r.y1);
    szorzo:= 1/dx;
//    if dx>dy then szorzo:= 1/dx else szorzo:= 1/dy;
    for i:=0 to Pred(FCurveList.Count) do begin
      FCurve:=FCurveList.Items[I];
    for N:=0 to Pred(FCurve.FPoints.Count) do begin
      FCurve.GetPoint(N,xx,yy);
      xx := szorzo * xx;
      yy := szorzo * yy;
      s := Ltrim(format('%6.5f',[xx]))+' '+LTrim(format('%6.5f',[yy]));
      WriteLn(D,s);
      if N=0 then s0 := s;               // Save 0. point
      Inc(H);
      if Demo and (H>500) then exit;
    end;
      if FCurve.Closed then
         WriteLn(D,s0);

//         WriteLn(D,'');                  // Üres sor beiktatása

  end;
FINALLY
      if FCurve.Closed then
         WriteLn(D,s0);
    CloseFile(D);
    Loading := False;
    Result := True;
END;
END;


procedure TALCustomSablon3d.SetGraphTitle(const Value: Str32);
begin
  FGraphTitle := Value;
  invalidate;
end;

procedure TALCustomSablon3d.CopySelectedToVirtClipboard;
var i: integer;
    Cuv: TCurve3d;
    GraphData: TNewGraphData;
begin
try
      ClipboardStr := '';
      GraphData.GraphTitle:=FGraphTitle;
      GraphData.Curves:=0;
      VirtualClipboard.Clear;
      VirtualClipboard.Write(GraphData,SizeOf(GraphData));
      i:=0;
      if FCurveList.Count>0 then
      While i<=FCurveList.Count-1 do begin
            Cuv:=FCurveList.Items[i];
            if Cuv.Selected then begin
               SaveCurveToStream(VirtualClipboard,i);
               ClipboardStr := ClipboardStr + Cuv.CurveToText;
               Inc(GraphData.Curves);
            end;
      Inc(i);
      end;
      VirtualClipboard.Seek(0,0);
      VirtualClipboard.Write(GraphData,SizeOf(GraphData));
      Clipboard.AsText := ClipboardStr;
except
end;
end;

procedure TALCustomSablon3d.CutSelectedToVirtClipboard;
begin
  If AutoUndo then UndoSave;
  CopySelectedToVirtClipboard;
  DeleteSelectedCurves;
  Changed := True;
end;

procedure TALCustomSablon3d.PasteSelectedFromVirtClipboard;
begin
IF VirtualClipboard.Size>0 then begin
  If AutoUndo then UndoSave;
  LoadGraphFromMemoryStream(VirtualClipboard);
  Changed := True;
  Invalidate;
end;
end;

function  TALCustomSablon3d.GetDrawExtension: TRect2d;
var n,i,j: integer;
    x,y: double;
    R: TRect2d;
begin
   Result := Rect2d(10e+10,10e+10,-10e+10,-10e+10);
   For n:=0 to FCurveList.Count-1 do begin
      FCurve:=FCurveList.Items[n];
      J:=Pred(FCurve.FPoints.Count);
      R := FCurve.BoundsRect;
        if R.x1<Result.x1 then Result.x1:=R.x1;
        if R.x2>Result.x2 then Result.x2:=R.x2;
        if R.y2>Result.y2 then Result.y2:=R.y2;
        if R.y1<Result.y1 then Result.y1:=R.y1;
   end;
end;

procedure TALCustomSablon3d.SetWorkArea(const Value: TRect);
begin
  FWorkArea := Value;
  invalidate;
end;

procedure TALCustomSablon3d.SetTitleFont(const Value: TFont);
begin
  FTitleFont := Value;
  Repaint;
end;

procedure TALCustomSablon3d.MagnifySelected(Cent: TPoint2d; Magnify: TFloat);
var n,i,j: integer;
    x,y: double;
begin
   If AutoUndo then UndoSave;
   For n:=0 to FCurveList.Count-1 do begin
      FCurve:=FCurveList.Items[n];
      J:=Pred(FCurve.FPoints.Count);
      if FCurve.Selected then begin
         FCurve.MagnifyCurve(Cent, Magnify);
         Changed := True;
      end;
   end;
  Paint;
end;


procedure TALCustomSablon3d.SetLoading(const Value: boolean);
begin
  FLoading := Value;
  DrawMode := dmNone;
//  ActionMode := amNone;
  if Value then begin
     oldCursor     := Cursor;
     Screen.Cursor := crHourGlass;
  end
  else begin
     Screen.Cursor := crDefault;
     Cursor        := oldCursor;
  end;
end;

procedure TALCustomSablon3d.ShowHintPanel(Show: Boolean);
begin
end;

procedure TALCustomSablon3d.SelectCurveByName(aName: string);
var n: integer;
begin
   For n:=0 to FCurveList.Count-1 do begin
      FCurve:=FCurveList.Items[n];
      if FCurve.Name = aName then
         Selected := FCurve;
   end;
  Paint;
end;

procedure TALCustomSablon3d.SelectCurve(AIndex: Integer);
begin
   FCurve:=FCurveList.Items[AIndex];
   Selected := FCurve;
end;


procedure TALCustomSablon3d.AutoSortObject(BasePoint: TPoint2d);
{Automatkus objektum sorrend képzés}
var i,j,idx: integer;
    x,y,x1,y1,d,dd : double;
    p0,p : TPoint2d;
    ts: TMemoryStream;
    Closed,Begining,Continue : boolean;
    CurveCount : integer;
    BaseCurve,nextCurve : TCurve3d;
    pp: PPointRec;
    curve0 : integer;  //Curve sorszáma amit objektummá növelünk
begin
if FCurveList.Count>1 then
Try
Try
  oldCursor := Cursor;
  Cursor := crHourGlass;
  Loading := True;
  UndoSave;
  ts:= TMemoryStream.Create;
  VektorisationAll(0.05);
  CurveCount := 0;
  p0 := BasePoint;
  While FCurveList.Count>0 do begin
        d := 1000000000;
        idx := -1;
        for I:=0 to Pred(FCurveList.Count) do
        begin
            FCurve:=FCurveList.Items[I];
               FCurve.GetPoint(0,X,Y);
               dd:=KeTPontTavolsaga(p0.x,p0.y,X,Y);
               if dd<=d then begin
                  d := dd;
                  idx := i;
                  Begining := True;
               end;
               FCurve.GetPoint(FCurve.FPoints.Count-1,X,Y);
               dd:=KeTPontTavolsaga(p0.x,p0.y,X,Y);
               if dd<=d then begin
                  d := dd;
                  idx := i;
                  Begining := False;
               end;
        end;
        FCurve:=FCurveList.Items[Idx];
        if not Begining then FCurve.InversPointOrder;

        IF FCurve.Closed {or Begining} then
           FCurve.GetPoint(0,X,Y)     // Zárt alakzat elsõ pontja
        else
           FCurve.GetPoint(Pred(FCurve.FPoints.Count),X,Y);  // Nyiltak utolsó pontja

        SaveCurveToStream(ts,Idx);
        Inc(CurveCount);
        p0 := Point2d(X,Y);
        FCurveList.Delete(Idx);
  end;
finally
  // A ts stream-re rendezett alakzatok visszatöltése
  FCurveList.Clear;
  ts.seek(0,0);
  For i:=0 to CurveCount-1 do
     LoadCurveFromStream(ts);

  // Kapcsolt objektumokból egyetlen objektum képzése

  Begining := True;
  i:=1;
  idx:=0;
  Repeat
      FCurve:=FCurveList.Items[I-1];
      nextCurve:=FCurveList.Items[I];
      nextCurve.GetPoint(0,X1,Y1);
      FCurve.GetPoint(FCurve.FPoints.Count-1,X,Y);
      dd:=KeTPontTavolsaga(x1,y1,X,Y);
      Continue:=dd<1;
      if begining then begin
         FCurve.GetPoint(0,X,Y);
         Inc(idx);
         p0 := Point2d(X,Y);
         BaseCurve := FCurve;
         FCurve.GetPoint(FCurve.FPoints.Count-1,X,Y);
         begining:=False;
      end;
      if Continue then begin
            nextCurve.AbsolutClosed;
            for j:=0 to Pred(nextCurve.FPoints.Count) do begin
                pp := nextCurve.FPoints.Items[j];
                p.x := pp^.x;
                p.y := pp^.y;
                BaseCurve.AddPoint(p.X,p.Y);
            end;
            FCurveList.Delete(i);
            BaseCurve.Selected := True;
      end else begin
            if not BaseCurve.Closed then
               BaseCurve.Closed := (ABS(P0.X-X)<1) and (ABS(P0.Y-Y)<1);
            begining := True;
            Inc(i);
      end;
  Until i>=FCurveList.Count;

  ts.Free;
  UndoSave;
  Cursor := oldCursor;
  Invalidate;
  Loading := False;
end;
except
  Cursor := oldCursor;
  Invalidate;
  Loading := False;
end;
end;

procedure TALCustomSablon3d.AutoSortObject(BasePoint: TPoint2d; Connecting: boolean);
{Automatkus objektum sorrend képzés}
var i,j,idx: integer;
    x,y,x1,y1,d,dd : double;
    p0,p : TPoint2d;
    ts: TMemoryStream;
    Closed,Begining,Continue : boolean;
    CurveCount : integer;
    BaseCurve,nextCurve : TCurve3d;
    pp: PPointRec;
    curve0 : integer;  //Curve sorszáma amit objektummá növelünk
begin
if FCurveList.Count>1 then
Try
Try
  oldCursor := Cursor;
  Cursor := crHourGlass;
  Loading := True;
  UndoSave;
  ts:= TMemoryStream.Create;
  CurveCount := 0;
  p0 := BasePoint;
  While FCurveList.Count>0 do begin
        d := 1000000000;
        idx := -1;
        for I:=0 to Pred(FCurveList.Count) do
        begin
            FCurve:=FCurveList.Items[I];
               FCurve.GetPoint(0,X,Y);
               dd:=KeTPontTavolsaga(p0.x,p0.y,X,Y);
               if dd<=d then begin
                  d := dd;
                  idx := i;
                  Begining := True;
               end;
(*               FCurve.GetPoint(FCurve.FPoints.Count-1,X,Y);
               dd:=KeTPontTavolsaga(p0.x,p0.y,X,Y);
               if dd<=d then begin
                  d := dd;
                  idx := i;
                  Begining := False;
               end; *)
        end;
        FCurve:=FCurveList.Items[Idx];
        if not Begining then FCurve.InversPointOrder;

        IF FCurve.Closed {or Begining} then
           FCurve.GetPoint(0,X,Y)     // Zárt alakzat elsõ pontja
        else
           FCurve.GetPoint(Pred(FCurve.FPoints.Count),X,Y);  // Nyiltak utolsó pontja

        SaveCurveToStream(ts,Idx);
        Inc(CurveCount);
        p0 := Point2d(X,Y);
        FCurveList.Delete(Idx);
  end;
finally
  // A ts stream-re rendezett alakzatok visszatöltése
  FCurveList.Clear;
  ts.seek(0,0);
  For i:=0 to CurveCount-1 do
     LoadCurveFromStream(ts);

  // Kapcsolt objektumokból egyetlen objektum képzése
  if Connecting then begin
  Begining := True;
  i:=1;
  idx:=0;
  Repeat
      FCurve:=FCurveList.Items[I-1];
      nextCurve:=FCurveList.Items[I];
      nextCurve.GetPoint(0,X1,Y1);
      FCurve.GetPoint(FCurve.FPoints.Count-1,X,Y);
      dd:=KeTPontTavolsaga(x1,y1,X,Y);
      Continue:=dd<0.5;
      if begining then begin
         FCurve.GetPoint(0,X,Y);
         Inc(idx);
         p0 := Point2d(X,Y);
         BaseCurve := FCurve;
         FCurve.GetPoint(FCurve.FPoints.Count-1,X,Y);
         begining:=False;
      end;
      if Continue then begin
            nextCurve.AbsolutClosed;
            for j:=0 to Pred(nextCurve.FPoints.Count) do begin
                pp := nextCurve.FPoints.Items[j];
                p.x := pp^.x;
                p.y := pp^.y;
                BaseCurve.AddPoint(p.X,p.Y);
            end;
            FCurveList.Delete(i);
      end else begin
            if not BaseCurve.Closed then
               BaseCurve.Closed := (ABS(P0.X-X)<0.5) and (ABS(P0.Y-Y)<0.5);
            begining := True;
            Inc(i);
      end;
  Until i>=FCurveList.Count;
  end;

  ts.Free;
  UndoSave;
  Cursor := oldCursor;
  Invalidate;
  Loading := False;
end;
except
  Cursor := oldCursor;
  Invalidate;
  Loading := False;
end;
end;


// A zárt poligonok ParentID-jét beállítja, ha van szülõje
procedure TALCustomSablon3d.InitParentObjects;
var i: integer;
begin
  Loading := True;
  for i:=0 to Pred(FCurveList.Count) do begin
      TCurve3d(FCurveList.Items[i]).ParentID := -1;
      if TCurve3d(FCurveList.Items[i]).Closed then
         if not IsParent(i) then
            TCurve3d(FCurveList.Items[i]).ParentID := GetParentObject(i);
  end;
  Loading := False;
  Invalidate;
end;

procedure TALCustomSablon3d.SelectParentObjects;
var i: integer;
begin
  Loading := True;
  for i:=0 to Pred(FCurveList.Count) do
      TCurve3d(FCurveList.Items[i]).Selected := IsParent(i);
  Loading := False;
  Invalidate;
end;

procedure TALCustomSablon3d.SelectChildObjects;
var i: integer;
begin
  Loading := True;
  for i:=0 to Pred(FCurveList.Count) do
      TCurve3d(FCurveList.Items[i]).Selected := not IsParent(i);
  Loading := False;
  Invalidate;
end;

    // A Child objektumot felfûzi a Parent objektumra
    procedure TALCustomSablon3d.StripObj12(AParent,Achild: integer);
    var j,f,k     : integer;
        pCuv,cCuv : TCurve3d;
        dMin      : double;
        d         : double;
        pp0,pp    : TPoint2d;
        pPointidx,cPointidx: integer;
    begin
       pCuv := FCurveList.Items[AParent];    // Parent obj.
       cCuv := FCurveList.Items[Achild];     // Child obj.
       // Fiók felfûzése
       dMin := 10000000;
       // Legközelebbi pontok keresése
       For j:=0 to Pred(pCuv.Fpoints.Count) do begin
           pp := pCuv.GetPoint2d(j);
           d  := cCuv.GetNearestPoint(pp,k);
           if d < dMin then begin
              pPointidx := j;
              cPointidx := k;
              dMin := d;
           end;
       end;
       pp0 := pCuv.GetPoint2d(pPointidx);
       // Fiók bekezdési pontjának megadása
       SetBeginPoint(Achild,cPointidx);
       // Fiók befûzése
       for f:=0 to Pred(cCuv.Fpoints.Count) do begin
           pp := cCuv.GetPoint2d(f);
           pCuv.InsertPoint(pPointidx+f+1,pp.x,pp.y,0);
       end;
       pp := cCuv.GetPoint2d(0);
       pCuv.InsertPoint(pPointidx+f+1,pp.x,pp.y,0);
       pCuv.InsertPoint(pPointidx+f+2,pp0.x,pp0.y,0);
       // Az eredeti Child legyen láthatatlan
       cCuv.Visible := False;
    end;

// A fiók objektumok felfûzése a szülõ objektumra
procedure TALCustomSablon3d.StripChildToParent(AIndex: integer);
var childCount: integer;
    i,k       : integer;
    pCuv,cCuv : TCurve3d;    // Parent and Child
    idx       : integer;   // szülõ objektum indexe
    dMin      : double;
    parent    : integer;


begin
if (AIndex>-1) and (AIndex<=Pred(FCurveList.Count)) then begin
   childCount := GetInnerObjectsCount(AIndex);
   idx := AIndex;

   if GetInnerObjectsCount(AIndex)>0 then begin
     pCuv := FCurveList.Items[AIndex];
     For i:=0 to Pred(FCurveList.Count) do begin
         Try
         cCuv   := FCurveList.Items[i];
         parent := GetParentObject(i);
         if (i<>AIndex) and (cCuv.Closed) and cCuv.Visible and
            (parent=AIndex) then
            begin
               StripObj12(AIndex,i);
            end;
         except
           exit;
         end;
     end;
//     childCount := GetInnerObjectsCount(AIndex);
//     InitParentObjects;
   end;

end;
end;

// A fiók objektumok felfûzése a szülõ objektumokra
procedure TALCustomSablon3d.StripAll;
var i: integer;
begin
  i:=0;
  For i:=0 to Pred(FCurveList.Count) do begin
      if IsParent(i) and (GetInnerObjectsCount(i)>0) then StripChildToParent(i);
//      inc(i);
  end;
end;



procedure TALCustomSablon3d.ClearWorkPoint;
begin
    Canvas.CopyRect(WRect,WBmp.Canvas,Rect(0,0,8,8));
end;

procedure TALCustomSablon3d.DrawWorkPoint(x, y: double);
var
  I,J: Integer;
begin
  WorkPosition.WorkPoint.x:=x;
  WorkPosition.WorkPoint.y:=y;
  if not painting then ClearWorkPoint;
  I:=XToS(x);
  J:=YToS(y);
  WRect:=Rect(I - 4,J - 4,I + 4,J + 4);
  WBmp.Canvas.CopyRect(Rect(0,0,8,8),Canvas,WRect);
  Canvas.Pen.Color:=clRed;
  Canvas.Pen.Mode:=pmCopy;
  Canvas.Brush.Style := bsClear;
  Canvas.Brush.Color:=clRed;
  Canvas.Ellipse(I-4,J-4,I+4,J+4);
end;

procedure TALCustomSablon3d.TestVekOut(dx,dy:extended);
var i,x,y,lepesszam: integer;
    d,xr,yr,s,c,lepeskoz : extended;
    alfa : double;
    kesleltetes,okesleltetes,correction: double;
    DestPosition : TPoint3D;
begin
  DestPosition.x := WorkPosition.WorkPoint.x+dx;
  DestPosition.y := WorkPosition.WorkPoint.y+dy;

  d := sqrt((dx*dx)+(dy*dy));

If d>MMPerLepes then begin

  lepeskoz    := MMPerLepes;
  Kesleltetes := 1;
  lepesszam   := Round(d/lepeskoz);

  alfa := SzakaszSzog(0,0,dx,dy);
  xr := 0;
  yr := 0;
  s := lepeskoz*sin(alfa); c := lepeskoz*cos(alfa);

  okesleltetes:=Kesleltetes;
  (*
  if (lepesszam<>0) and ((Abs(dx)>lepeskoz) and (Abs(dy)>lepeskoz)) then begin
     correction:=Abs(lepesszam/(Abs(dx/lepeskoz)+Abs(dy/lepeskoz)));
     Kesleltetes:= Kesleltetes*(correction);
  end;
  *)
  For i:=1 to lepesszam do begin
      x:=Round(xr/MMPerLepes); y:=Round(yr/MMPerLepes);
      xr := xr+c;
      yr := yr+s;
      If x<>Round(xr/MMPerLepes) then begin
         If dx>0 then WorkPosition.WorkPoint.x:=WorkPosition.WorkPoint.x+MMPerLepes;
         If dx<0 then WorkPosition.WorkPoint.x:=WorkPosition.WorkPoint.x-MMPerLepes;
      end;
      If y<>Round(yr/MMPerLepes) then begin
         If dy>0 then WorkPosition.WorkPoint.y:=WorkPosition.WorkPoint.y+MMPerLepes;
         If dy<0 then WorkPosition.WorkPoint.y:=WorkPosition.WorkPoint.y-MMPerLepes;
      end;

      if fSablonSzinkron then
         MoveCentrum(WorkPosition.WorkPoint.x,WorkPosition.WorkPoint.y)
      else
         Repaint;

      if (lo(GetAsyncKeyState(VK_ESCAPE)) > 0)
      then begin
           STOP := True;
      end;

(*      if (lo(GetAsyncKeyState(VK_SPACE)) > 0)
      then begin
           STOP := False;
//           PillanatAllj := True;
      end;*)

      Application.ProcessMessages;
      if STOP then begin
         Kesleltetes:=okesleltetes;
         Working := False;
         exit;
      end;
  end;
end;
  Kesleltetes:=okesleltetes;
end;

{Megmunkálás az Aobject AItem sorszámú pontjától}
procedure TALCustomSablon3d.TestWorking(AObject,AItem:integer);
var Cuv : TCurve3d;
    i,j,j0 : integer;
    x,y : double;
    elso: boolean;
    p : TPoint2d;
begin
  Try
    STOP := False;
    SaveGraphToMemoryStream(innerStream);
    elso := True;
    ShowPoints := False;
    CentralCross := True;
    Working := True;
    WorkPosition.CuvNumber := AObject;
    WorkPosition.PointNumber := AItem;
    Paint;
    For i:=AObject to FCurveList.Count-1 do begin
        Cuv := FCurveList.Items[i];
        if Ord(Cuv.Shape)>5 then
           Poligonize(FCurveList.Items[i],0);
        If Cuv.Enabled then begin
        WorkPosition.CuvNumber := i;

        If elso then begin j0:=AItem; elso:=False;
        end else j0 := 0;


        For j:=j0 to Cuv.FPoints.Count-1 do begin
            Cuv.GetPoint(j,x,y);
            WorkPosition.PointNumber := j;
            TestVekOut(x-WorkPosition.WorkPoint.x,y-WorkPosition.WorkPoint.y);
            if STOP then Break;
            if fSablonSzinkron then MoveCentrum(x,y);
        end;
        if STOP then
           Break;
        // Closed curve back to 0. point if points count>2
        If Cuv.Closed and (Cuv.FPoints.Count>2) then begin
            Cuv.GetPoint(0,x,y);
            WorkPosition.PointNumber := j;
            TestVekOut(x-WorkPosition.WorkPoint.x,y-WorkPosition.WorkPoint.y);
            if STOP then
               Break;
            if fSablonSzinkron then MoveCentrum(x,y);
        end;
        end;
    end
    finally
        Working := False;
        ShowPoints := True;
        Clear;
        LoadGraphFromMemoryStream(innerStream);
    end;
end;

procedure TALCustomSablon3d.PoligonizeAll(PointCount: integer);
// Total graphic vectorisation
Var
    i    : integer;
begin
  For i:=0 to Pred(FCurveList.Count) do
      Poligonize(TCurve3d(FCurveList.Items[i]),PointCount);
end;

// Some curve vectorization:
//    If Count>0 then result curve will be countains count points
procedure TALCustomSablon3d.Poligonize(Cuv: TCurve3d; Count: integer);
var x,y,x1,y1,ArcU,ArcV: TFloat;
    szog, arcR,R1,R2,arcEAngle,deltaFI : extended;
    szog1,szog2,szog3: double;
    i,j,k   : integer;
    pp,pp1,pp2 : pPoints;
    Size    : integer;
    dd      : CurveDataArray;
    PA,pPA  : PCurveDataArray;
    arcCirc : TPoint3d;
begin
//if Ord(Cuv.Shape)>5 then
Try
   If AutoUndo then UndoSave;
   Loading := True;
   // Store the Cuv points in dPoints list
   InitdPoints;
   For i:=0 to Pred(Cuv.FPoints.Count) do begin
       pp := Cuv.Fpoints[i];
       dPoints.Add(pp);
   end;
   // First point <> Last point
   If Cuv.Closed then
   if dPoints[0]=dPoints[Cuv.FPoints.Count-1]
   then dPoints.Delete(Cuv.FPoints.Count-1);

   Case Cuv.Shape of
   dmRectangle:
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
     begin
       Cuv.ClearPoints;
       Cuv.Shape := dmPolygon;
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
          deltaFI := Sgn(szog)*(2*PI*2)/(2*arcR*PI);
       end else
          deltaFI := szog/Count;
       j := Abs(Trunc(szog/deltaFI));
       for i:=0 to j do begin
//       While (szog1<=szog3) do begin
             x := ArcU + arcR * cos(szog1);
             y := ArcV + arcR * sin(szog1);
             Cuv.AddPoint(x,y);
             szog1 := szog1+deltaFI;
       end;
//       Cuv.AddPoint(pp1^.x,pp1^.y);
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
       Cuv.Shape := dmPolygon;
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
   If AutoUndo then UndoSave;
   InitdPoints;
   Loading := False;
end;
end;

procedure TALCustomSablon3d.SetWorkOrigo(const Value: TPoint3d);
begin
  fWorkOrigo := Value;
  If not Working then begin
     WorkPosition.WorkPoint.X := Value.X;
     WorkPosition.WorkPoint.y := Value.y;
     WorkPosition.WorkPoint.z := Value.z;
  end;
  Invalidate;
end;

procedure TALCustomSablon3d.VektorisationAll(MaxDiff: TFloat);
// Total graphic vectorisation
Var
    i    : integer;
begin
Try
  If AutoUndo then UndoSave;
  Loading := True;
  For i:=0 to Pred(FCurveList.Count) do begin
      if FCurveList.Items[i]<>nil then
      Vektorisation(MaxDiff,TCurve3d(FCurveList.Items[i]));
  end;
  if AutoUndo then UndoSave;
  Loading := False;
except
end;
end;

procedure TALCustomSablon3d.Vektorisation(MaxDiff: TFloat; Cuv: TCurve3d);
(* A vektorizálás során a kezdõpontot összekötjük a további pontokkal mindaddig
   amíg a következõ pont eltérése nagyobb lessz egy diff-erenciánál
*)

var diff    : double;          // eltérés
    i       : integer;
    pp      : pPoints3d;
    p,kp,vp   : TPoint3D;        // vektor kezdõ és végpontja
    n0,n,k  : integer;         // n futóindex
    e       : TEgyenesfgv;
    p2d     : TPoint2D;
begin
Try
   If (not Loading) and AutoUndo then UndoSave;
   DeleteSamePoints(0.05);
   Cuv.FillPointArray;
   k  := High(Cuv.PointsArray);
   n := Cuv.FPoints.Count;
(*
   // Store the Cuv points in dPoints list
   InitdPoints;
   For i:=0 to Pred(Cuv.FPoints.Count) do begin
       pp := Cuv.Fpoints[i];
       p  := pp^;
       dPoints.Add(pp);
   end;

   If Cuv.Closed then
   if dPoints[0]<>dPoints[Cuv.FPoints.Count-1]
   then begin
     pp := dPoints[0];
     dPoints.Add(pp);
   end;

   // Push vector points into the Cuv
   Cuv.ClearPoints;
   n0 := 0;
   n  := 1;
   k  := High(Cuv.PointsArray);
//   k  := dPoints.Count;

   // Ujmódszer
   While (n<dPoints.Count) and (n0<dPoints.Count) do begin
   Try
     Cuv
//     pp := dPoints[n0];
//     kp := Point3d(pp^.x,pp^.y,pp^.z);
     p  := pp^;
     Cuv.AddPoint(pp^.x,pp^.y,pp^.z);
     Inc(n0);
     Dec(k);

     While (n<dPoints.Count) and (n0<dPoints.Count) do begin
//        pp := dPoints[n];
//        vp := Point3d(pp^.x,pp^.y,pp^.z);
        e := KeTPontonAtmenoEgyenes(kp.x,kp.y,vp.x,vp.y);
        // Vizsgáljuk a közbülsõ pontok eltéréseit az egyenestõl
        For i:=n0 to n do begin
            pp   := dPoints[i];
            p2d  := Point2d(pp^.x,pp^.y);
            diff := PontEgyenesTavolsaga(e,p2d);
            if diff>MaxDiff then break;
        end;
        if diff>MaxDiff then begin
           n0 := n-1;      // Az n-1. pont eltérése már jelentõs
           break;
        end;
        Inc(n);
     end;
   except
     Break;
   end;
   end;
   If not Cuv.Closed then begin
      n0 := dPoints.Count-1;
      pp := dPoints[n0];
      Cuv.AddPoint(pp^.x,pp^.y,pp^.z);
   end;
*)
Finally
  if (not Loading) and AutoUndo then UndoSave;
end;

end;

// A pontsûrítés közbülsõ pontok beillesztése Dist távolságonként
procedure TALCustomSablon3d.PontSurites(Cuv: TCurve3d; Dist: double);
var x,y         : TFloat;
    d           : TFloat;
    i,j,k       : integer;
    pp,pp1      : pPoints;
    dx,dy       : TFloat;
    Angle       : TFloat;
begin
Try
   If AutoUndo then UndoSave;
   Loading := True;
   // Store the Cuv points in dPoints list
   InitdPoints;
   For i:=0 to Pred(Cuv.FPoints.Count) do begin
       pp := Cuv.Fpoints[i];
       dPoints.Add(pp);
   end;
   // First point <> Last point
   If Cuv.Closed then
   if dPoints[0]=dPoints[Cuv.FPoints.Count-1]
   then dPoints.Delete(Cuv.FPoints.Count-1);

   Case Cuv.Shape of
   dmPolygon,dmPolyLine:
     begin
        Cuv.Closed := False;
        if Cuv.Shape = dmPolygon then begin
           pp := Cuv.Fpoints[0];
           dPoints.Add(pp);
           Cuv.Closed := True;
        end;
        Cuv.ClearPoints;

        For i:=0 to dPoints.Count-2 do begin
            pp    := dPoints[i];
            pp1   := dPoints[i+1];
            d     := KeTPontTavolsaga(pp^.x,pp^.y,pp1^.x,pp1^.y);
            x     := pp^.x;
            y     := pp^.y;
            k     := Trunc(d/Dist);
            Angle := RelAngle2D(Point2d(x,y),Point2d(pp1^.x,pp1^.y));
            dx    := Dist * cos(Angle);
            dy    := Dist * sin(Angle);
            if d>Dist then begin
               For j:=0 to k do begin
                 Cuv.AddPoint(x,y);
                 x := x + dx;
                 y := y + dy;
               end;
            end else begin
               Cuv.AddPoint(pp^.x,pp^.y);
            end;
        end;
       end;
     end;
finally
   If AutoUndo then UndoSave;
   InitdPoints;
   Loading := False;
end;
end;

procedure TALCustomSablon3d.PontSuritesAll(Dist: double);
Var
    i    : integer;
begin
  For i:=0 to Pred(FCurveList.Count) do
      PontSurites(TCurve3d(FCurveList.Items[i]),Dist);
end;

function TALCustomSablon3d.GetInnerObjectsCount(AIndex: Integer): integer;
// Result = 0 or inner objects' count;
Var OurRect : TRect2d;
    inRect  : TRect2d;
    i       : integer;
begin
  Result := 0;
  FCurve := FCurveList.Items[AIndex];
  OurRect:= FCurve.Boundsrect;
  For i:=0 to Pred(FCurveList.Count) do begin
    if i<>AIndex then begin
      FCurve := FCurveList.Items[I];
      if FCurve.Visible then begin
         inRect := FCurve.Boundsrect;
         If RectInRect2D(OurRect,inRect) then Inc(Result);
      end;
    end;
  end;
end;

function TALCustomSablon3d.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
var N : double;
begin
  if (ActionMode = amMagnifySelected) then
  begin
      if WheelDelta<0 then N:=0.99999
      else N:=1.00001;
      MagnifySelected(RotCentrum,N);
  end
  else
      if WheelDelta<0 then Zoom:=0.9*FZoom
      else Zoom:=1.1*FZoom;
  Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos);
end;

function TALCustomSablon3d.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelDown(Shift, MousePos);
end;

function TALCustomSablon3d.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelUp(Shift, MousePos);
end;

// Megkeresi, hogy a sokszög melyik legkisebbnek a belselyében van
// Ha nincs befoglalója, akkor Result=-1
// Ha van, akkor annak az ID-jével tér vissza
function TALCustomSablon3d.GetParentObject(AIndex: Integer): integer;
Var OurRect : TRect2d;
    inRect  : TRect2d;
    oRect   : TRect2d;
    Cuv     : TCurve3d;
    p       : TPoint2d;
    i,j     : integer;
begin
  Result := -1;
  FCurve := FCurveList.Items[AIndex];
  inRect := FCurve.Boundsrect;
  oRect  := Rect2d(MaxInt,MaxInt,-MaxInt,-MaxInt);
  For i:=0 to Pred(FCurveList.Count) do begin
    if i<>AIndex then begin
      Cuv := FCurveList.Items[I];
      OurRect:= Cuv.Boundsrect;
      if Cuv.Visible then begin
      If RectInRect2D(OurRect,inRect) then
         if RectInRect2D(oRect,OurRect) then begin
            p := FCurve.GetPoint2d(0);
               oRect := OurRect;
               Result := i;
         end;
      end;
    end;
  end;
end;

// Megkeresi a pont körüli legkisebb befoglaló objektumot
// Result = -1, vagy a talált befoglaló objektum ID-je
function TALCustomSablon3d.GetParentObject(x,y: TFloat): integer;
Var OurRect : TRect2d;
    inRect  : TRect2d;
    oRect   : TRect2d;
    i       : integer;
    Cuv     : TCurve3d;
begin
  Result := -1;
  oRect  := Rect2d(-MaxInt,-MaxInt,MaxInt,MaxInt);
  For i:=0 to Pred(FCurveList.Count) do begin
      Cuv := FCurveList.Items[I];
      OurRect:= Cuv.Boundsrect;
      if Cuv.Visible then begin
      If Cuv.IsInCurve(x,y) in [icIn,icOnLine] then
         if RectInRect2D(oRect,OurRect) then begin
            oRect := OurRect;
            Result := i;
         end;
      end;
  end;
end;

// Megvizsgálja, hogy az objektumnak van-e szüleje, azaz
// olyan objektum, aminek a belselyében található.
// Ha van, akkor Result=False ,
// ha nincs, akkor: True;

function TALCustomSablon3d.IsParent(AIndex: Integer): boolean;
begin
  Result := False;
  if AIndex>-1 then
     Result := GetParentObject(AIndex)=-1;
end;

// Megvizsgálja, hogy a pont körüli objektumnak van-e szüleje, azaz
// olyan objektum, aminek a belselyében található
// True = ha szülõ objektum
function TALCustomSablon3d.IsParent(x,y: TFloat): boolean;
Var OurRect : TRect2d;
    inRect  : TRect2d;
    oRect   : TRect2d;
    i       : integer;
    ParentID: integer;
begin
  Result := False;
  Result := GetParentObject(x,y)=-1;
end;

function TALCustomSablon3d.OutLineObject(AIndex: Integer; delta: real): TCurve3d;
begin

end;

{Az objektum körül kontúrozása: mûszer korrekció
   In: Cuv        = Zárt sokszog;
       OutCode    = a vágóél sugara :
                    0  = eredeti kontúr vonalon,
                    +n = kívül haladás,
                    -n = belül haladás }
function TALCustomSablon3d.ObjectContour(Cuv: TCurve3d;OutCode:double): TCurve3d;
var i,j,meret,n: longint;
    x,y        : TFloat;
    p0,p1,p2,p3,p4   : TPoint2d;
    E1,E2      : TEgyenes;
    Idx1,Idx2  : integer;
    Dir        : boolean;
    metszes    : boolean;

    procedure ContourCorrection;
    var keresztezes: boolean;
    begin
    end;

begin
   Result := nil;
if (Cuv<>nil) then
if (Cuv.Fpoints.Count>2) and Cuv.Closed then begin
Try
   dir := Cuv.IsDirect;
   if dir then Cuv.InversPointOrder;
   Vektorisation(0.01,Cuv);

   TempCurve.ClearPoints;
   TempCurve.Shape := dmPolyLine;
   Cuv.GetPoint(0,x,y);
   p0 := Point2d(x,y);
   p1 := p0;
   n  := Cuv.Fpoints.Count;
   For i:=1 to n do begin
       if n=i then begin
          Cuv.GetPoint(0,x,y);
          p2 := Point2d(x,y);
       end else begin
          Cuv.GetPoint(i,x,y);
          p2 := Point2d(x,y);
       end;
       E1:=SzakaszParhuzamosEltolas(p1,p2,Abs(OutCode),not dir);
       TempCurve.AddPoint(E1.x1,E1.y1);
       if RelDist2D(p1,p2)>Abs(OutCode) then
       TempCurve.AddPoint(E1.x2,E1.y2);
       p1 := p2;
   end;

finally
  // Megvizsgáljuk, hogy a kontúr minden pontja megfelelõ-e
  // Ha a kontúr 2 szakasza metsz egymást, akkor képezzük a két szakasz
  //    metszéspontját p0 és a közbülsõ pontok törlése után az uj metszéspontot
  //    beszúrjuk
(*
  metszes := True;
  While metszes do begin
      i:=0;
      metszes := False;
      While i<TempCurve.Count-1 do begin
          p1 := TempCurve.Points[i];
          if i=(TempCurve.Count-1) then
             p2 := TempCurve.Points[0]
          else
             p2 := TempCurve.Points[i+1];
          for j:=i to TempCurve.Count-1 do begin
              p3 := TempCurve.Points[j];
              if i=(TempCurve.Count-1) then
                 p4 := TempCurve.Points[0]
              else
                 p4 := TempCurve.Points[j+1];
              if SzakaszSzakaszMetszes(p1,p2,p3,p4,p0) then begin
                 metszes := True;
                 Idx1:=i+1; Idx2:=j;
                 for n:=Idx1 to Idx2 do
                     TempCurve.DeletePoint(i+1);
                 TempCurve.InsertPoint(i+1,p0.x,p0.y);
                 Break;
              end;
          end;
          inc(i);
      end;
  end;
*)
  Result:= TempCurve;
end;
end;
end;

(*
function TALCustomSablon3d.ObjectContour(Cuv: TCurve;OutCode:double): TCurve;
var i,j,meret,n: longint;
    x,y        : TFloat;
    p0,p1,p2,p3,p4   : TPoint2d;
    E1,E2      : TEgyenes;
    E0,Ek,Eb   : TEgyenesFgv;
    AboveCount : integer;
    pStm       : TMemoryStream;      {poligon eredeti pontjai}
    inStream   : TMemoryStream;      {Belsõ kontúrnak}
    outStream  : TMemoryStream;      {Külsõ kontúrnak}
    talalt     : boolean;
    R,Rin,Rout : TRect2d;
    Idx1,Idx2  : integer;
     Dir    : boolean;

 { Kontúrképzõ rutin:
   pSTM : eredeti poligon csúcspontjai;
   cSTM : kontúr poligon csúcspontjai;
   actSTM : kontúr poligon oldalegyeneseinek függvényei;
   Result = True/False: belül/kívül kontúrozás;
   }
 procedure KonturKepzes(pSTM:TMemoryStream; actStream:TMemoryStream; var tCuv: TCurve);
 var i,meret: longint;
     hiba   : boolean;
 begin
   tCuv.ClearPoints;
   meret := (actStream.Size div SizeOf(TEgyenesFgv));
   actStream.Seek(0,0);
   tCuv.AddPoint(p1.x,p1.y);
   actStream.Read(Eb,SizeOf(TEgyenesFgv));
   E0 := Eb;
   For i:=2 to meret do begin
       hiba:=False;
       actStream.Read(Ek,SizeOf(TEgyenesFgv));
//       If Eb.a <> Ek.a then begin
          p1 := KetegyenesMetszespontja(Eb,Ek);
          tCuv.AddPoint(p1.x,p1.y);
//       end;
       Eb := Ek;
   end;
   {Elsõ és utolsó egyenes metszéspontja is kell}
   p1 := KetegyenesMetszespontja(Eb,E0);
   tCuv.AddPoint(p1.x,p1.y);
   tCuv.ChangePoint(0,p1.x,p1.y);
 end;

begin

   Result := nil;
if (Cuv<>nil) then
if (Cuv.Fpoints.Count>2) and Cuv.Closed then begin
Try
   // Eredeti poligon sarokpontjait kiírjuk a pStm streamre
   pStm       := TMemoryStream.Create;
   For i:=0 to Pred(Cuv.FPoints.Count) do begin
       Cuv.GetPoint(i,x,y);
       p1:=Point2d(x,y);
       pStm.Write(p1,SizeOf(TPoint2d));
   end;
   dir := Cuv.IsDirect;
//   if dir then Cuv.InversPointOrder;
   R := Cuv.GetBoundsRect;

   TempCurve.ClearPoints;
   TempCurve.Shape := dmPolyLine;
   inStream   := TMemoryStream.Create;
   outStream  := TMemoryStream.Create;
   Cuv.GetPoint(0,x,y);
   p0 := Point2d(x,y);
   p1 := p0;
   n  := Cuv.Fpoints.Count;
   {A szakaszokkal || egyenesek elhelyezése a stream-eken}
   For i:=1 to n do begin
       if n=i then begin
          Cuv.GetPoint(0,x,y);
          p2 := Point2d(x,y);
       end else begin
          Cuv.GetPoint(i,x,y);
          p2 := Point2d(x,y);
       end;
(*
       E1:=SzakaszParhuzamosEltolas(p1,p2,Abs(OutCode),not dir);
       TempCurve.AddPoint(E1.x1,E1.y1);
       if RelDist2D(p1,p2)>Abs(OutCode) then
       TempCurve.AddPoint(E1.x2,E1.y2);


       E1:=SzakaszParhuzamosEltolas(p1,p2,Abs(OutCode),not dir);
//       if RelDist2D(p1,p2)>Abs(OutCode) then begin
          Eb:=KetpontonAtmenoEgyenes(E1.x1,E1.y1,E1.x2,E1.y2);
          inStream.Write(Eb,SizeOf(TEgyenesFgv));
//       end;


       E1:=SzakaszParhuzamosEltolas(p1,p2,Abs(OutCode),True);
       E2:=SzakaszParhuzamosEltolas(p1,p2,Abs(OutCode),False);
       Eb:=KetpontonAtmenoEgyenes(E1.x1,E1.y1,E1.x2,E1.y2);
       Ek:=KetpontonAtmenoEgyenes(E2.x1,E2.y1,E2.x2,E2.y2);
       inStream.Write(Eb,SizeOf(TEgyenesFgv));
       outStream.Write(Ek,SizeOf(TEgyenesFgv));

       p1 := p2;
   end;


   {Az inStream egyeneseinek metszéspontjait keressük}
   KonturKepzes(pSTM,inStream,TempCurve);

   Rin := TempCurve.GetBoundsRect;
   If (OutCode<0) then
      If RectInRect2d(Rin,R) then
         KonturKepzes(pSTM,outStream,TempCurve);
   If (OutCode>0) then
      If RectInRect2d(R,Rin) then
         KonturKepzes(pSTM,outStream,TempCurve);


finally
  // Megvizsgáljuk, hogy a kontúr minden pontja megfelelõ-e
  // Ha a kontúr 2 szakasza metsz egymást, akkor képezzük a két szkasz
  //    metszéspontját p0 és a közbülsõ pontok törlése után az uj metszéspontot
  //    beszúrjuk

      i:=0;
      While i<TempCurve.Count-2 do begin
          if j>=TempCurve.Count then Break;
          p1 := TempCurve.Points[i];
          p2 := TempCurve.Points[i+1];
          for j:=TempCurve.Count-2 downto i do begin
              p3 := TempCurve.Points[j];
              p4 := TempCurve.Points[j+1];
              if SzakaszSzakaszMetszes(p1,p2,p3,p4,p0) then begin
                 Idx1:=i+1; Idx2:=j;
                 for n:=Idx1 to Idx2 do
                     TempCurve.DeletePoint(i+1);
                 TempCurve.InsertPoint(i+1,p0.x,p0.y);
              end;
          end;
          inc(i);
      end;

  Result:= TempCurve;
  inStream.Free;
  outStream.Free;
end;
end;
end;
*)

// A névlistát az objektumsorrendnek megfelelõen korrigálja
procedure TALCustomSablon3d.ReOrderNames;
var i,n: integer;
    kod: array[0..13] of integer;
begin
  For i:=0 to Pred(FCurveList.Count) do begin
      FCurve := FCurveList.Items[I];
      FCurve.Name := DrawModeText[Ord(FCurve.Shape)]+'_'+IntToStr(i);
  end;
end;

procedure TALCustomSablon3d.SignedNotCutting;
var i,j,k: integer;
    BaseCurve,Cuv: TCurve3d;
    p,p0: TPoint2d;
begin
  SignedAll(False);
  // Signed=True, ha valamely objektum át van vágva (rajzon szürke szín)
  For i:=0 to Pred(FCurveList.Count) do begin
      BaseCurve:=FCurveList.Items[i];
      if BaseCurve.Shape=dmPolygon then
         For j:=0 to Pred(FCurveList.Count) do begin
             Cuv:=FCurveList.Items[j];
             if Cuv.Shape=dmPolyline then
             For k:=0 to Cuv.Count-2 do
             begin
                p:=Cuv.GetPoint2d(k);
                p0:=Cuv.GetPoint2d(k+1);
                if BaseCurve.IsCutLine(p0,p) then begin
                   BaseCurve.Signed:=True;
                   Break;
                end;
             end;
         end;
  end;
end;


// Az objektumlista alapján automatikus vágási terv készítése
{Automatkus vágási terv képzés, a vágási segédvonalak políline-ok lesznek}
// BasePoint: a vágási 0 pozíció;
// Sorting  : Automatikusan keressen-e optimális sorrendet.
procedure TALCustomSablon3d.AutoCutSequence(BasePoint: TPoint2d; Sorting: boolean);
var i,j,idx: integer;
    x,y,d,dd : double;
    p0,p : TPoint2d;
    BaseCurve : TCurve3d;
    Cuv       : TCurve3d;
    cuvIDX,pIdx: integer;
    Child: boolean;
    minP : integer;          // Kontúr min táv.-û pontja a köv. poligonhoz
    KonturHossz: double;     // Kontúr hossza
    KonturSzelet: double;    // Kontúr egy szeletének hossza

label Ujra;

    procedure VisibleAll;
    var ii: integer;
    begin
         For ii:=0 to Pred(FCurveList.Count) do begin
             FCurve := FCurveList.Items[ii];
             FCurve.Visible:=True;
         end;
    end;

    function VisibleCount: integer;
    var ii: integer;
    begin
         Result := 0;
         For ii:=0 to Pred(FCurveList.Count) do begin
             FCurve := FCurveList.Items[ii];
             if FCurve.Visible then
                Inc(Result);
         end;
    end;

    function NextVisible: integer;
    var ii: integer;
    begin
         Result := -1;
         For ii:=0 to Pred(FCurveList.Count) do begin
             FCurve := FCurveList.Items[ii];
             if FCurve.Visible then begin
                Result := ii;
                exit;
             end;
         end;
    end;

begin
if (FCurveList.Count>0) and (ActionMode <> amAutoPlan) then
Try
Try
  ActionMode := amAutoPlan;
  STOP := False;
  oldCursor := Cursor;
  Screen.Cursor := crHourGlass;
  Loading := True;
  AutoUndo := False;
  if AutoUndo then UndoSave;

  InnerStream.Clear;    // Ide rendezzük a vágási mintát

  // Töröljük az összes nyílt alakzatot
  SignedAll(False);
  VisibleAll;
  SelectAll(False);
  SelectAllPolylines;
  DeleteSelectedCurves;

  // Vektorization all
  if Assigned(FAutoSortEvent) then FAutoSortEvent(Self,0,0);
  VektorisationAll(0.05);

  AutoSortObject(BasePoint);

  if Assigned(FAutoSortEvent) then FAutoSortEvent(Self,1,0);
  InitParentObjects;
  StripAll;              // Fiókok felfûzése

  p0 := BasePoint;
  cuvIDX := 0;

  if VisibleCount>0 then begin
        // Az elsõ polygon kiolvasása
        if Assigned(FAutoSortEvent) then FAutoSortEvent(Self,2,CuvIdx);
        if Sorting then begin
           GetNearestPoint(p0,cuvIDX,pIdx);
           SetBeginPoint(cuvIDX,pIdx);
        end else
           CuvIdx := NextVisible;
        GetPoint(CuvIdx,0,x,y);
        // Elsõ megközelítõ vonal képzése Origóból
        idx:=MakeCurve('Cut',-1,dmPolyline,True,True,False);
        AddPoint(idx,p0.x,p0.y);
        AddPoint(idx,x,y);
        SaveCurveToStream(innerStream,IDX);
        DeleteCurve(IDX);
  end;

  While VisibleCount>0 do begin

        // Kontúrozás és eredeti Polygon mentése
           BaseCurve := FCurveList.Items[cuvIDX];
(*
           if (lo(GetAsyncKeyState(VK_ESCAPE)) > 0)
           then begin
                Undo;
                Break;
           end;
*)
           if Sorting then
           if BaseCurve.IsDirect then BaseCurve.InversPointOrder;

           TempCurve := ObjectContour(BaseCurve,ConturRadius);
           i:=0;
           while GetInnerObjectsCount(cuvIDX)>0 do begin
                 StripChildToParent(cuvIDX);
                 inc(i);
                 if i>20 then break;
           end;

//           ContourOptimalizalas(TempCurve);

           SaveCurveToStream(innerStream,cuvIDX);
           BaseCurve.Visible := False;
           p := BaseCurve.GetPoint2d(0);
         if Assigned(FAutoSortEvent) then FAutoSortEvent(Self,2,CuvIdx);

        if VisibleCount>0 then begin

           // A következõ polygon kiolvasása
           if Sorting then begin
              GetNearestPoint(p,cuvIDX,pIdx);
              BaseCurve := FCurveList.Items[cuvIDX];
              SetBeginPoint(cuvIDX,pIdx);
              GetPoint(cuvIDX,0,x,y);
              p:=Point2d(x,y);
           end else begin
               CuvIdx := NextVisible;
               BaseCurve := FCurveList.Items[cuvIDX];
               p := BaseCurve.GetPoint2d(0);
           end;

              // Kontúron az optimális útvonal keresés a köv. objektumhoz
              idx:=MakeCurve('Cut',-1,dmPolyline,True,True,False);
              Cuv := FCurveList.Items[idx];
              Cuv.Visible:=False;

              // Megkeressük a kontúr elsõ rálátási pontját
              KonturHossz := TempCurve.GetKerulet;  // Teljes kontúr hossz

Ujra:         for i:=0 to Pred(TempCurve.Fpoints.Count) do begin
                  p0 := TempCurve.GetPoint2d(i);
                  Cuv.AddPoint(p0.x,p0.y);
                  if Sorting then begin
                     d:=GetNearestPoint(p0,cuvIDX,pIdx);
                     SetBeginPoint(cuvIDX,pIdx);
                     BaseCurve := FCurveList.Items[cuvIDX];
                     p := BaseCurve.GetPoint2d(0);
                  end;

                  if not TempCurve.isCutLine(p0,p) then
                  begin
                     // Ha van rövidebb út akkor fordított kontúrpont sorrend és ujra
                     KonturSzelet := TempCurve.GetKeruletSzakasz(0,i);
                     if KonturSzelet > (KonturHossz-KonturSzelet) then begin
                        TempCurve.InversPointOrder;
                        Cuv.ClearPoints;
                        goto Ujra;
                     end;
                     Break;
                  end;

              end;


              p := BaseCurve.GetPoint2d(0);
              Cuv.AddPoint(p.x,p.y);
              Cuv.Visible:=True;
              minP := Cuv.FPoints.Count;
              SaveCurveToStream(innerStream,IDX);
              DeleteCurve(IDX);

        end; // if

  end;

finally

  TempCurve := ObjectContour(BaseCurve,ConturRadius);

  // A ts stream-re rendezett alakzatok visszatöltése
  FCurveList.Clear;
  innerStream.seek(0,0);
  While innerStream.Size>innerStream.Position do
     LoadCurveFromStream(innerStream);

  // Kilépés az utolsó objektumból a kontúr elsõ pontjába
  idx:=MakeCurve('Back',-1,dmPolyline,True,True,False);
  TempCurve.GetPoint(0,x,y);
  AddPoint(idx,x,y);
  // Vissza az Workorigóba
  AddPoint(idx,BasePoint);

  InnerStream.Clear;
  ReOrderNames;
  invalidate;

  ActionMode := amAutoPlan;

  Elkerules;

  STOP := False;
  Cursor := oldCursor;
  Loading := False;
  AutoUndo := True;
  if AutoUndo then UndoSave;

end;
except
  Screen.Cursor := oldCursor;
  ActionMode := amNone;
  Invalidate;
  Loading := False;
  AutoUndo := True;
end;

end;


(*
  ELKERÜLÉSI RUTIN A pontból B pontba
*)
//============================================================================
procedure TALCustomSablon3d.ElkerulesAB(Var eCurve: TCurve3d);

Type TInOutRec = record      // Kontúr metszési pont rekord
       mPont   : TPoint2d;   // metszéspont koordinátái
       idx     : integer;    // idx indexû pont után beszúrni
       d       : double;     // d távolság a kezdõponttól
     end;

Var mpArr : array of TmpRec; // Metszett polygonok tömbje
    i,j,k       : integer;
    mpRec       : TmpRec;         // Legközelebbi polygon és pont + d távolság
    BaseCurve   : TCurve3d;     // Elkerülõ polyline
    TempCurve   : TCurve3d;     // Kontúr
    Cuv         : TCurve3d;     // Legközelebbi polygon
    BePont,KiPont : TInOutRec; // Be-ki lépési pontok a kontúron
    mpCount     : integer;    // Kontúr-szakasz metszéspontok száma
    AP,BP       : TPoint2d;   // Szakasz eleje, vége
    KonturHossz : double;     // Kontúr kerülete
    KonturSzelet: double;     // Egy szeletének hossza
    p           : TPoint2d;


    // Az A ponthoz legközelebbi polygon legközelebbi pontját adja
    function GetNearest(A: TPoint2d): TmpRec;
    var jj: integer;
        Idx: integer;
        dd1,dd: double;
        x,y: double;
        fCuv: TCurve3d;
    begin
    dd1 := 10e+10;
    For jj:=0 to Pred(FCurveList.Count) do
    begin
        fCuv:=FCurveList.Items[jj];    // = a polygon lista egyik eleme
        if fCuv.Shape = dmPolygon then
        begin
           dd:=fCuv.GetNearestPoint(A,Idx);
           if dd<dd1 then begin
              dd1 := dd;
              Result.Cuvidx := jj;
              Result.Pointidx := Idx;
              Result.d := dd;
           end;
        end;
    end;
    end;

    // megszámolja, hogy az AB szakasz, hány polygont metsz
    // és feltölti az mpArr tömböt az A ponttól való távolság sorrendjében
    function IsCutPolygons(A,B: TPoint2d): integer;
    var ii: integer;
        fc: TCurve3d;
        pCount : integer;
        dd: double;
        pr: TmpRec;
        csere: boolean;
    begin
         pCount := 0;
         SetLength(mpArr,1000);
         For ii:=0 to Pred(FCurveList.Count) do begin
             fc:=FCurveList.Items[ii];
             if fc.Shape=dmPolygon then
                if fc.IsCutLine(A,B,dd) then begin
                   mpArr[pCount].Cuvidx := ii;
                   mpArr[pCount].d   := dd;
                   Inc(pCount);
                end;
         end;
         mpArr := Copy(mpArr,0,pCount);
         Result := pCount;
         // Tömb rendezése távolság szerint növekvõen
         ii:=0; csere:=True;
         While csere do begin
            csere := False;
            for ii:=0 to pCount-2 do begin
                if mpArr[ii].d > mpArr[ii+1].d then begin
                   pr := mpArr[ii]; mpArr[ii]:=mpArr[ii+1]; mpArr[ii+1]:=pr;
                   csere := True;
                end;
            end;
         end;
    end;

    // Belépési és kilépési pontok keresése a kontúron
    // Result = metszéspontok száma
    function ConturInOut(cCuv: TCurve3d; AP,BP: TPoint2d; var BE,KI: TInOutRec): integer;
    Var i     : integer;
        idx1,idx2 : integer;    // metszéspontot megelõzõ kontúrpont indexe
        mPonts: TMemoryStream;  // a metszéspont rekordokat ide teszem
        P1,P2 : TPoint2d;       // Kontúr két egymást követõ pontja
        mp    : TPoint2d;       // Kontúr metszéspontja
        d     : double;         // Metszéspont távolsága AP kezdõponttól
        M_P   : TInOutRec;      // METSZÉSPONT REKORDJA
        d1,d2 : double;         // be és kilépõ metszéspontok
    begin
      Result := 0;
      // A legközelebbi és legtávolabbi metszéspontok megkeresése
      d1:=10e+10; d2:= -1;
      For i:=0 to (cCuv.Count)-2 do begin
          P1 := cCuv.GetPoint2d(i);
          P2 := cCuv.GetPoint2d(i+1);
          if SzakaszSzakaszMetszes(AP,BP,P1,P2,mp) then begin // Ha van metszéspont
             d := RelDist2d(AP,mp);
             if d<d1 then begin
                BE.mPont := mp;
                BE.idx   := i+1;
                BE.d     := d;
                d1 := d;
             end;
             if d>d2 then begin
                KI.mPont := mp;
                KI.idx   := i+1;
                KI.d     := d;
                d2 := d;
             end;
             Inc(Result);
          end;
      end;
    end;

begin
  
  k := Pred(eCurve.Count);
  AP := eCurve.GetPoint2d(k-1);
  BP := eCurve.GetPoint2d(k);

  // Megkeresem az AP ponthoz legközelebbi polygon legközelebbi pontját
  mpRec := GetNearest(AP);
  Cuv := FCurveList.Items[mpRec.Cuvidx];
  if mpRec.d<ConturRadius then begin
     // Ha egy polygonhoz túl közel van, akkor kontúron kell haladni a
     // AB húr metszéspontjáig
     TempCurve := ObjectContour(Cuv,ConturRadius);
     mpCount := ConturInOut(TempCurve,AP,BP,BePont,KiPont);
     if mpCount=1 then
        TempCurve.InsertPoint(KiPont.Idx,KiPont.mPont.x,KiPont.mPont.y,0);
     // A kontúr legközelebbi pontjára lépek
     TempCurve.GetNearestPoint(AP,mpRec.Pointidx);
     KonturHossz  := TempCurve.GetKeruletSzakasz(KiPont.Idx,Pred(TempCurve.Count));
     KonturSzelet := TempCurve.GetKeruletSzakasz(0,KiPont.Idx);
              For i:=mpRec.Pointidx to KiPont.Idx do begin
                  p := TempCurve.GetPoint2d(i);
                  k := Pred(eCurve.Count);
                  eCurve.InsertPoint(k,p.x,p.y,0);
              end;
     AP := p;
  end;

  while IsCutPolygons(AP,BP)>0 do begin
        Cuv:=FCurveList.Items[mpArr[0].Cuvidx];   // = az átmetszett poligon
        TempCurve := ObjectContour(Cuv,ConturRadius);
        // Belépési és kilépési pontok keresése a kontúron
        mpCount := ConturInOut(TempCurve,AP,BP,BePont,KiPont);
        // Ha nincs metszéspont, akkor az egyenes elkerüli a polygonokat;
        // Ha 1 van, akkor be, vagy ki lép a poligonból
        // Ha 2 vagy több van, akkor átmetszi.

        if mpCount=1 then begin
           // Belépés a kontúrba a végpont felé

        end
        else

        if mpCount>1 then begin
           if KiPont.Idx>BePont.Idx then begin
              TempCurve.InsertPoint(KiPont.Idx,KiPont.mPont.x,KiPont.mPont.y,0);
              TempCurve.InsertPoint(BePont.Idx,BePont.mPont.x,BePont.mPont.y,0);
              Inc(KiPont.Idx);
           end else begin
              TempCurve.InsertPoint(BePont.Idx,BePont.mPont.x,BePont.mPont.y,0);
              TempCurve.InsertPoint(KiPont.Idx,KiPont.mPont.x,KiPont.mPont.y,0);
              Inc(BePont.Idx);
           end;

           KonturHossz  := TempCurve.GetKerulet;  // Teljes kontúr hossz
           KonturSzelet := TempCurve.GetKeruletSzakasz(BePont.Idx,KiPont.Idx);
           // Minimális kontúrszakasz keresés
           if KonturSzelet < (KonturHossz-KonturSzelet) then begin

              if KiPont.Idx>BePont.Idx then
              For i:=BePont.Idx to KiPont.Idx do begin
                  p := TempCurve.GetPoint2d(i);
                  k := Pred(eCurve.Count);
                  eCurve.InsertPoint(k,p.x,p.y,0);
              end
              else begin
              For i:=BePont.Idx to Pred(TempCurve.Count) do begin
                  p := TempCurve.GetPoint2d(i);
                  k := Pred(eCurve.Count);
                  eCurve.InsertPoint(k,p.x,p.y,0);
              end;
              For i:=0 to KiPont.Idx do begin
                  p := TempCurve.GetPoint2d(i);
                  k := Pred(eCurve.Count);
                  eCurve.InsertPoint(k,p.x,p.y,0);
              end;
              end;

           end
           else begin

              if BePont.Idx>KiPont.Idx then
              For i:=BePont.Idx downto KiPont.Idx do begin
                  p := TempCurve.GetPoint2d(i);
                  k := Pred(eCurve.Count);
                  eCurve.InsertPoint(k,p.x,p.y,0);
              end
              else begin
              For i:=BePont.Idx downto 0 do begin
                  p := TempCurve.GetPoint2d(i);
                  k := Pred(eCurve.Count);
                  eCurve.InsertPoint(k,p.x,p.y,0);
              end;
              For i:=Pred(TempCurve.Count) downto KiPont.Idx do begin
                  p := TempCurve.GetPoint2d(i);
                  k := Pred(eCurve.Count);
                  eCurve.InsertPoint(k,p.x,p.y,0);
              end;
              end;

           end;
        end;
        AP := p;
  end;
end;

//============================================================================

procedure TALCustomSablon3d.Elkerules;
Type mpRec = record
       idx : integer;
       d   : double;
     end;


var i,j,k: integer;
    BaseCurve,Cuv,TempCurve: TCurve3d;
    p1,p2: TPoint2d;          // p1-p2 szakasz
    p11,p12: TPoint2d;        // metszett poligon két szélsõ pontja
    idx1,idx2: integer;       // metszett poligon szélsõ pontjainak indexe
    fi,fi1,fi2: double;       // A pontból húzott poligon határolók irányszöge
    sz1,sz2: double;
    d1,d2: double;
    efg: TEgyenesFgv;
    Cutting: integer;
    mpArr : array of mpRec;
    cuvIDX,pIdx: integer;
    ContP: TPoint2d;          // kontúr pont
    n: integer;
    metszes: boolean;
    szaz: integer;

label ujra;

    // megszámolja, hogy az AB szakasz, hány polygont metsz
    // és feltölti az mpArr tömböt az A ponttól való távolság sorrendjében
    function IsCutPolygons(A,B: TPoint2d): integer;
    var ii: integer;
        fc: TCurve3d;
        pCount : integer;
        dd: double;
        pr: mpRec;
        csere: boolean;
    begin
         pCount := 0;
         SetLength(mpArr,100);
         For ii:=0 to Pred(FCurveList.Count) do begin
             fc:=FCurveList.Items[ii];
             if fc.Shape=dmPolygon then
                if fc.IsCutLine(A,B,dd) then begin
                   mpArr[pCount].idx := ii;
                   mpArr[pCount].d   := dd;
                   Inc(pCount);
                end;
         end;
         SetLength(mpArr,pCount);
//         mpArr := Copy(mpArr,0,pCount);
         Result := pCount;
         // Tömb rendezése távolság szerint növekvõen
         ii:=0; csere:=True;
         While csere do begin
            csere := False;
            for ii:=0 to pCount-2 do begin
                if mpArr[ii].d > mpArr[ii+1].d then begin
                   pr := mpArr[ii]; mpArr[ii]:=mpArr[ii+1]; mpArr[ii+1]:=pr;
                   csere := True;
                end;
            end;
         end;
    end;

    function GetNearPoint(cc: TCurve3d; A: TPoint2d): integer;
    var jj: integer;
        dd1,dd: double;
        x,y: double;
    begin
    Result := -1;
    dd1 := 10e+10;
    For jj:=0 to Pred(cc.FPoints.Count) do
    begin
        cc.GetPoint(jj,x,y);
        if IsCutPolygons(A,Point2d(x,y))=0 then begin
        dd:=KetPontTavolsaga(A.x,A.y,x,y);
        if dd<dd1 then begin
           dd1 := dd;
           Result   := jj;
        end;
        end;
    end;
    end;

begin
  SignedNotCutting;
  n:=0;
  // Veszem a polyline-okat és metszést vizsgálok polygon-okkal
  For i:=0 to Pred(FCurveList.Count) do begin
      BaseCurve:=FCurveList.Items[i];    // = a polyline
      Selected := BaseCurve;
      szaz := Trunc(100*(i/FCurveList.Count));
      if Assigned(FPlan) then FPlan(Self,szaz);

ujra: if BaseCurve.Shape=dmPolyline then
      begin

         // Veszem a polyline 2 utolsó pontját
         k:=Pred(BaseCurve.Fpoints.Count);
         p1:=BaseCurve.GetPoint2d(k-1);
         p2:=BaseCurve.GetPoint2d(k);

         // ennyi db poligont vág át : mpArr tömb tartalmazza a vágott poligonokat
         Cutting:=IsCutPolygons(p1,p2);

//         ElkerulesAB(BaseCurve);

      While Cutting>0 do begin
            k:=Pred(BaseCurve.Fpoints.Count);
            p1:=BaseCurve.GetPoint2d(k-1);
            p2:=BaseCurve.GetPoint2d(k);
            Application.ProcessMessages;
            if STOP then
               Break;

             if High(mpArr)=0 then begin
//                ContourOptimalizalas(BaseCurve);
                Break;
             end;
             Cuv:=FCurveList.Items[mpArr[0].idx];   // = az átmetszett poligon
             if Cuv.Shape=dmPolygon then begin

                // Kontúrképzés az átmetszett poligon körül
                TempCurve := ObjectContour(Cuv,ConturRadius);
                Vektorisation(0.5,TempCurve);

                // Megkeressük a kontúr A ponthoz legközelebbi pontját
                pIdx := GetNearPoint(TempCurve,p1);
                p1 := TempCurve.GetPoint2d(pIdx);
                // Addig haladunk a kontúron míg a poligont metszi a maradék szakasz
                metszes := Cuv.IsCutLine(p1,p2);
                if metszes then begin
                While Cuv.IsCutLine(p1,p2) or TempCurve.IsCutLine(p1,p2) do begin
                      k:=Pred(BaseCurve.Fpoints.Count);  // Cél pont
                      p2:=BaseCurve.GetPoint2d(k);
                      BaseCurve.InsertPoint(k,p1.x,p1.y,0);
                      Inc(pIdx);
                      if pIdx>Pred(TempCurve.Count) then pIdx:=0;
                      p1 := TempCurve.GetPoint2d(pIdx);
                end;
                      k:=Pred(BaseCurve.Fpoints.Count);  // Cél pont
                      p1 := TempCurve.GetPoint2d(pIdx);
                      BaseCurve.InsertPoint(k,p1.x,p1.y,0);
                end
                else begin
                      k:=Pred(BaseCurve.Fpoints.Count);  // Cél pont
                      p1 := TempCurve.GetPoint2d(pIdx);
                      BaseCurve.InsertPoint(k,p1.x,p1.y,0);
                      Break;
                end;
             end;
            // Veszem a polyline 2 utolsó pontját
            k:=Pred(BaseCurve.Fpoints.Count);
            p1:=BaseCurve.GetPoint2d(k-1);
            p2:=BaseCurve.GetPoint2d(k);
             Cutting:=IsCutPolygons(p1,p2);
         end;

         ContourOptimalizalas(BaseCurve);
         Application.ProcessMessages;
         if STOP then
            Break;
      end;
  end;
   SetLength(mpArr,0);
   SignedNotCutting;
  invalidate;
  if Assigned(FPlan) then FPlan(Self,0);
end;

(* ContourOptimalizalas
   ----------------------------------------------------------------------------
   Lényege: A kontúron haladva növekvõ indexek szerint, minden esetben megvizsgáljuk,
   hogy a végponttól visszafelé haladva melyik az az elsõ kontúrpont, melyre
   közvetlen rálátás van. Nyilván, a közbülsõ pontok törölhetõk.
*)
    procedure TALCustomSablon3d.ContourOptimalizalas(var Cuv: TCurve3d);
    Type mpRec = record
         idx : integer;
         d   : double;
         end;
    var kezdP,vegP  : TPoint2d;
        ii,jj,nn,n    : integer;
        PointsArray : array of TPoint2d;
        mpArr : array of mpRec;

    // megszámolja, hogy az AB szakasz, hány polygont metsz
    // és feltölti az mpArr tömböt az A ponttól való távolság sorrendjében
    function IsCutPolygons(A,B: TPoint2d): integer;
    var ii: integer;
        fc: TCurve3d;
        contCuv : TCurve3d;
        pCount : integer;
        dd: double;
        pr: mpRec;
        csere: boolean;
    begin
         pCount := 0;
         SetLength(mpArr,100);
         For ii:=0 to Pred(FCurveList.Count) do begin
             fc:=FCurveList.Items[ii];
             if fc.Shape=dmPolygon then begin
                contCuv := ObjectContour(fc,0.9*ConturRadius);
                Vektorisation(0.5,contCuv);
                contCuv.Shape := dmPolygon;
                if (contCuv.IsCutLine(A,B,dd)) then begin
                   mpArr[pCount].idx := ii;
                   mpArr[pCount].d   := dd;
                   Inc(pCount);
                end;
             end;
         end;
         SetLength(mpArr,pCount);
//         mpArr := Copy(mpArr,0,pCount);
         Result := pCount;
         // Tömb rendezése távolság szerint növekvõen
         ii:=0; csere:=True;
         While csere do begin
            csere := False;
            for ii:=0 to pCount-2 do begin
                if mpArr[ii].d > mpArr[ii+1].d then begin
                   pr := mpArr[ii]; mpArr[ii]:=mpArr[ii+1]; mpArr[ii+1]:=pr;
                   csere := True;
                end;
            end;
         end;
    end;

    begin
      SetLength(PointsArray,Cuv.FPoints.Count);
      for ii:=0 to Cuv.FPoints.Count-1 do
          PointsArray[ii] := Cuv.GetPoint2d(ii);
      nn := High(PointsArray);
      Cuv.ClearPoints;
      ii := 0;
      While ii<=(nn-1) do begin
            kezdP := PointsArray[ii];
            Cuv.AddPoint(kezdP.x,kezdP.y,0);
            // Keressük a legtávolabbi, közvetlen rálátási pontot
            for jj:=nn downto (ii+1) do begin
                vegP := PointsArray[jj];
                if (IsCutPolygons(kezdP,vegP)=0) then
                begin
                   ii:=jj-1;
                   Break;
                end;
            end;
            Inc(ii);
            Application.ProcessMessages;
            if STOP then
               Break;
      end;
      if STOP then begin
         Cuv.ClearPoints;
         for ii:=0 to nn do
             Cuv.AddPoint(PointsArray[ii].X,PointsArray[ii].Y,0);
      end else
             Cuv.AddPoint(PointsArray[ii].X,PointsArray[ii].Y,0);
      SetLength(PointsArray,0);
      SetLength(mpArr,0);
    end;


// Megvizsgálja, hogy a p1-p2 szakasz átvágja valamelyik vagy több objektumot.
//     Aindex = az elsõként érintett objektum sorszáma
function TALCustomSablon3d.IsCutObject(p1,p2: TPoint2d; var Aindex: integer): boolean;
var i: integer;
    t: Trect2d;
    Cuv : TCurve3d;
begin
   Result := False;
   For i:=0 to Pred(FCurvelist.Count) do begin
      Cuv := FCurveList.Items[I];
      t := Cuv.GetBoundsRect;
      if Cuv.Visible and (IsSzakaszNegyszogMetszes(p1,p2,t)) then
      if Cuv.IsCutLine(p1,p2) then begin
         Aindex := i;
         Result := True;
         exit;
      end;
   end;
end;

function TALCustomSablon3d.GetDisabledCount: integer;
var i: integer;
    Cuv : TCurve3d;
begin
   Result := 0;
   For i:=0 to Pred(FCurvelist.Count) do begin
      Cuv := FCurveList.Items[I];
      if Cuv.Enabled = False then Inc(Result);
   end;
end;

procedure TALCustomSablon3d.DrawCurve(Cuv: TCurve3d; co: TColor);
var i: integer;
    x,y: integer;
    p: TPoint2d;
begin
  With Canvas do begin
       Pen.Color := co;
       Pen.Width := 2;
       For i:=0 to Pred(Cuv.Count) do begin
           p:=Cuv.GetPoint2d(i);
           If i=0 then
              MoveTo(Round(p.x),Round(p.y))
           else
              LineTo(Round(p.x),Round(p.y))
       end;
       if Cuv.Closed then begin
          p:=Cuv.GetPoint2d(0);
          LineTo(Round(p.x),Round(p.y))
       end;
  end;
end;

procedure TALCustomSablon3d.CMChildkey(var msg: TCMChildKey);
begin
  msg.result := 1; // declares key as handled
  Case msg.charcode of
    VK_RETURN,190  : ZoomDrawing;
    VK_ESCAPE  : begin
                   STOP := True;
                   ActionMode := amNone;
                   DrawMode   := dmNone;
                   SelectAll(False);
                 end;
    VK_ADD     : Zoom:=1.1*Zoom;
    VK_SUBTRACT,189: Zoom:=0.9*Zoom;
    VK_F4      : ShowPoints := not ShowPoints;
  Else
    msg.result:= 0;
  End;
  inherited;
end;

function TALCustomSablon3d.GetSignedCount: integer;
var i: integer;
begin
   Result := 0;
   For i:=0 to Pred(FCurvelist.Count) do begin
       FCurve:=FCurveList.Items[i];
       if FCurve.Signed then
         Inc(Result);
   end;
end;

procedure TALCustomSablon3d.CurveToCent(AIndex: Integer);
var R : TRect2d;
begin
  R := TCurve3d(FCurveList.Items[Aindex]).BoundsRect;
  MoveCentrum((R.x1+R.x2)/2,(R.y1+R.y2)/2);
end;

procedure TALCustomSablon3d.SetCentrum(const Value: T2dPoint);
begin
  fCentrum := Value;
  invalidate;
end;

procedure TALCustomSablon3d.KeyDown(var Key: Word; Shift: TShiftState);
var dx,dy: integer;
    k:integer;
begin
  if Shift=[] then begin
  k:=16;
  dx := 0; dy:=0;
  Case Key of
    VK_ESCAPE  : begin
                   STOP := True;
                   ActionMode := amNone;
                   DrawMode   := dmNone;
                   SelectAll(False);
                 end;
    VK_RETURN  : ZoomPaper;
    VK_LEFT    : dx:=k;
    VK_RIGHT   : dx:=-k;
    VK_UP      : dy:=-k;
    VK_DOWN    : dy:=k;
  end;
  if (dx<>0) or (dy<>0) then
     MoveWindow(dx,dy);
  end;
  
  inherited;
end;

procedure TALCustomSablon3d.KeyPress(var Key: Char);
begin
  inherited;

end;

{ TCurveList3d }

constructor TCurveList3d.Create(AOwner: TComponent);
begin
  inherited Create;
  FSensitiveRadius := 4;
end;

destructor TCurveList3d.Destroy;
begin
  inherited;

end;

function TCurveList3d.AddCurve(ACurve: TCurve3d): integer;
begin

end;

procedure TCurveList3d.AddPoint(AIndex: Integer; P: TPoint2d);
begin

end;

procedure TCurveList3d.AddPoint(AIndex: Integer; X, Y, Z: TFloat);
begin

end;

procedure TCurveList3d.AddPoint(AIndex: Integer; X, Y: TFloat);
begin

end;

procedure TCurveList3d.CentralisNyujtas(Cent: TPoint2d; tenyezo: double);
begin

end;

procedure TCurveList3d.Changed(Sender: TObject);
begin

end;

procedure TCurveList3d.ChangePoint(AIndex, APosition: Integer; X,
  Y: TFloat);
begin

end;

procedure TCurveList3d.CheckCurvePoints(X, Y, Z: Integer);
begin

end;

procedure TCurveList3d.CheckCurvePoints(X, Y: Integer);
begin

end;

procedure TCurveList3d.Clear;
begin

end;

procedure TCurveList3d.ClosedAll(all: boolean);
begin

end;

procedure TCurveList3d.DeleteCurve(AItem: Integer);
begin

end;

procedure TCurveList3d.DeletePoint(AIndex, APosition: Integer);
begin

end;

procedure TCurveList3d.DeleteSamePoints(diff: TFloat);
begin

end;

procedure TCurveList3d.DeleteSelectedCurves;
begin

end;

procedure TCurveList3d.DoMove(Dx, Dy: Integer);
begin

end;

procedure TCurveList3d.Eltolas(dx, dy: double);
begin

end;

procedure TCurveList3d.EnabledAll(all: boolean);
begin

end;

function TCurveList3d.GetCurveHandle(AName: Str32;
  var H: Integer): Boolean;
begin

end;

function TCurveList3d.GetCurveName(H: Integer): Str32;
begin

end;

function TCurveList3d.GetMaxPoints: Integer;
begin

end;

function TCurveList3d.GetNearestPoint(p: TPoint2d; var cuvIdx,
  pIdx: integer): TFloat;
begin

end;

procedure TCurveList3d.GetPoint(AIndex, APosition: Integer; var X, Y,
  Z: TFloat);
begin

end;

procedure TCurveList3d.GetPoint(AIndex, APosition: Integer; var X,
  Y: TFloat);
begin

end;

function TCurveList3d.GetSignedCount: integer;
begin

end;

procedure TCurveList3d.InsertCurve(AIndex: Integer; Curve: TCurve3d);
begin

end;

procedure TCurveList3d.InsertPoint(AIndex, APosition: Integer;
  P: TPoint2d);
begin

end;

procedure TCurveList3d.InsertPoint(AIndex, APosition: Integer; X,
  Y: TFloat);
begin

end;

procedure TCurveList3d.InversCurve(AIndex: Integer);
begin

end;

procedure TCurveList3d.InversSelectedCurves;
begin

end;

function TCurveList3d.LoadCurveFromFile(const FileName: string): Boolean;
begin

end;

function TCurveList3d.LoadCurveFromStream(FileStream: TStream): Boolean;
begin

end;

function TCurveList3d.LoadGraphFromFile(const FileName: string): Boolean;
begin

end;

procedure TCurveList3d.LoadGraphFromMemoryStream(stm: TMemoryStream);
begin

end;

procedure TCurveList3d.MagnifySelected(Cent: TPoint2d; Magnify: TFloat);
begin

end;

function TCurveList3d.MakeCurve(const AName: Str32; ID: integer;
  Shape: TDrawMode; AEnabled, AVisible, AClosed: Boolean): Integer;
begin

end;

procedure TCurveList3d.MoveCurve(AIndex: integer; Ax, Ay, Az: TFloat);
begin

end;

procedure TCurveList3d.MoveCurve(AIndex: integer; Ax, Ay: TFloat);
begin

end;

procedure TCurveList3d.MoveSelectedCurves(Ax, Ay: TFloat);
begin

end;

procedure TCurveList3d.MoveSelectedCurves(Ax, Ay, Az: TFloat);
begin

end;

procedure TCurveList3d.Normalisation(Down: boolean);
begin

end;

procedure TCurveList3d.Nyujtas(tenyezo: double);
begin

end;

procedure TCurveList3d.Poligonize(Cuv: TCurve3d; Count: integer);
begin

end;

procedure TCurveList3d.PoligonizeAll(PointCount: integer);
begin

end;

procedure TCurveList3d.PontSurites(Cuv: TCurve3d; Dist: double);
begin

end;

procedure TCurveList3d.PontSuritesAll(Dist: double);
begin

end;

procedure TCurveList3d.RotateSelectedCurves(Cent: TPoint2d; Angle: TFloat);
begin

end;

procedure TCurveList3d.RotateSelectedCurves(Cent: TPoint3d; Angle: TFloat);
begin

end;

function TCurveList3d.SaveCurveToStream(FileStream: TStream;
  Item: Integer): Boolean;
begin

end;

function TCurveList3d.SaveGraphToFile(const FileName: string): Boolean;
begin

end;

procedure TCurveList3d.SaveGraphToMemoryStream(var stm: TMemoryStream);
begin

end;

procedure TCurveList3d.SelectAll(all: boolean);
begin

end;

procedure TCurveList3d.SelectAllInArea(R: TRect2D);
begin

end;

procedure TCurveList3d.SelectAllInAreaEx(R: TRect2d);
begin

end;

procedure TCurveList3d.SelectAllPolygons;
begin

end;

procedure TCurveList3d.SelectAllPolylines;
begin

end;

procedure TCurveList3d.SelectChildObjects;
begin

end;

procedure TCurveList3d.SelectCurve(AIndex: Integer);
begin

end;

procedure TCurveList3d.SelectCurveByName(aName: string);
begin

end;

procedure TCurveList3d.SelectParentObjects;
begin

end;

procedure TCurveList3d.SetBeginPoint(ACurve, AIndex: Integer);
begin

end;

procedure TCurveList3d.SetSelected(const Value: TCurve3d);
begin
  fSelected := Value;
end;

procedure TCurveList3d.SetSensitiveRadius(const Value: integer);
begin
  FSensitiveRadius := Value;
end;

procedure TCurveList3d.SignedAll(all: boolean);
begin

end;

procedure TCurveList3d.SignedNotCutting;
begin

end;

procedure TCurveList3d.Vektorisation(MaxDiff: TFloat; Cuv: TCurve3d);
begin

end;

procedure TCurveList3d.VektorisationAll(MaxDiff: TFloat);
begin

end;

end.

end.
