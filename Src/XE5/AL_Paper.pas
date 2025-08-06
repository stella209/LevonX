
// Modified: 2019-07-30     By Agócs László Hun. StellaSOFT

unit AL_Paper;

interface
Uses
    Winapi.Windows, System.SysUtils, System.Classes, VCL.Graphics,
    VCL.Controls, VCL.StdCtrls, VCL.ClipBrd, System.Math,
    VCL.Extctrls, Winapi.Messages, VCL.Dialogs, VCL.Forms, NewGeom, DGrafik,
    B_Spline, Szoveg, Szamok, StObjects, Clipper, AL_SVGLoader;

Type

  TInOutRec = record           // Metszési pont rekord  .margin
       mPont   : TPoint2d;     // metszéspont koordinátái
       idx     : integer;      // idx indexû pont után beszúrni
       d       : double;       // d távolság a kezdõponttól
  end;

  TALSablon = class(TCustomControl)
  private
    fCoordLabel: TLabel;
    fCentrum: TPoint2dObj;
    fOrigo: TPoint2d;
    fWorkOrigo: TPoint2d;
    fPaper: TPoint2dObj;
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
    fSelected: TCurve;
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
    FContourRadius: double;
    FAutoSortEvent: TAutoSortEvent;
    FPlan: TProcess;
    FTestSpeed: double;
    fChangeAll: TNotifyEvent;
    FCentralisZoom: boolean;
    fEnablePaint: boolean;
    FAppend: boolean;
    FFilename: string;
    FSelectedIndex: integer;
    FEnableSelectedFrame: boolean;
    FSelectedFrame: TSelectedArea;
    FVisibleContours: Boolean;
    FGravity: boolean;
    FXYCompulsion: boolean;
    FDefiniedLength: boolean;
    FBackImage   : TBMPObject;
    fCoordHint: boolean;
    fOnSelectedFrame: TNotifyEvent;
    FFilled: boolean;
    FCList: TList;
    fPointWhdth: integer;
    FClone_Contour: double;
    FSelectedVisible: boolean;
    FDesigneMode: boolean;
    fAutoPoligonize: boolean;
    FOrtho: boolean;
    FBoxing: boolean;
    fShowNumbers: boolean;
    fpOpened: TPen;
    fpSorted: TPen;
    fpCrossed: TPen;
    fpSelected: TPen;
    fpSigned: TPen;
    fpClosed: TPen;
    fbFillBrush: TBrush;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMEraseBkGnd(var Message:TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure CMMouseEnter(var msg:TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var msg: TMessage); message CM_MOUSELEAVE;
    Procedure CMChildkey( Var msg: TCMChildKey ); message CM_CHILDKEY;
//    procedure WM_KeyDown(var Msg: TWMKeyDown); message WM_KEYDOWN;
//    procedure WMKeyUp(var Msg: TWMKeyDown); message WM_KEYUP;

    procedure LButtonDblClick(var Message: TMessage); message WM_LBUTTONDBLCLK;
    procedure SetCentralCross(const Value: boolean);
    procedure SetZoom(const Value: extended);
    procedure SetPaperVisible(const Value: boolean);
    procedure SetBackColor(const Value: TColor);
    procedure SetPaperColor(const Value: TColor);
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
    procedure SetSelected(const Value: TCurve);
    procedure SetGraphTitle(const Value: Str32);
    procedure SetLocked(const Value: boolean);
    procedure SetWorkArea(const Value: TRect);
    procedure SetTitleFont(const Value: TFont);
    procedure SetLoading(const Value: boolean);
    procedure SetWorkOrigo(const Value: TPoint2d);
    procedure ReOrderNames;
    function GetDisabledCount: integer;
    procedure SetSTOP(const Value: boolean);
    function GetCurve(idx: integer): TCurve;
    procedure SetCurve(idx: integer; const Value: TCurve);
    procedure SetEnablePaint(const Value: boolean);
    procedure SetFilename(const Value: string);
    procedure SetEnableSelectedFrame(const Value: boolean);
    procedure SetSelectedIndex(const Value: integer);
    procedure SetVisibleContours(const Value: Boolean);
    procedure SetBackImage(const Value: TBMPObject);
    procedure SetCoordHint(const Value: boolean);
    procedure SetFilled(const Value: boolean);
    procedure SetSablonSzinkron(const Value: boolean);
    procedure SetPointWhdth(const Value: integer);
    procedure SetSelectedVisible(const Value: boolean);
    procedure SetDesigneMode(const Value: boolean);
    procedure ShowMagneticCircle(x,y: TFloat; enab: boolean);
    procedure SetOrtho(const Value: boolean);
    procedure SetBoxing(const Value: boolean);
    procedure SetShowNumbers(const Value: boolean);
    procedure SetpClosed(const Value: TPen);
    procedure SetpCrossed(const Value: TPen);
    procedure SetpOpened(const Value: TPen);
    procedure SetpSelected(const Value: TPen);
    procedure SetpSigned(const Value: TPen);
    procedure SetpSorted(const Value: TPen);
    procedure SetbFillBrush(const Value: TBrush);
  protected
    FCurve              : TCurve;     // Cuve for general purpose
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
    preselected         : boolean;
    tegla               : Tteglalap;  // Roteted rectangle

    Paning              : boolean;
    Zooming             : boolean;
    HClip               : HRgn;
    oldCursor           : TCursor;
    THintLabel          : TLabel;

    DXFOut              : TDXFOut;

    UR                  : TUndoRedo;  // Undo-Redo object
//    KeyboardThread      : TThread;
    procedure Change(Sender: TObject);
    procedure ChangeCentrum(Sender: TObject);
    procedure ChangePaperExtension(Sender: TObject);
    procedure DoubleClick(Sender: TObject);
//    procedure KeyDown(var Key: Word;Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint): Boolean; override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure UndoStart;
    procedure UndoStop;
  public
    FCurveList    : TList;      // List of vectorial curves
    TempCurve     : TCurve;     // Temporary curve for not poligonized objects: Ex. Spline
    CPMatch       : Boolean;    // Matching point
    CurveMatch    : Boolean;    // Matching curve
    CurveIn       : boolean;    // point in curve
    CPCurve       : Integer;
    LastCPCurve   : Integer;
    CPIndex       : Integer;
    LastCPIndex   : Integer;
    CPx           : TFloat;     // Aktív pont koordinátái
    CPy           : TFloat;
    Mouse_Pos     : TPoint;     // Mouse x,y position
    MapXY         : TPoint2d;   // Point on Word coordinates
    MapPoint      : TPoint2d;
    ActText       : Str32;
    InnerStream   : TMemoryStream;     // memorystream for inner use
    oldFile       : boolean;
    WorkPosition  : TWorkPosition;
    WRect         : TRect;             {A munkapont alatti terület mentéséhez}
    WBmp          : TBitmap;
    DrawBmp       : TBitMap;
    Moving        : boolean;
    MouseOn       : boolean;
    kesleltetes   : double;     // A test vágás lépései közti szünet
    defLength     : double;     // defined length of line
    oldActionMode : TActionMode;
    painting      : boolean;
    // Tollak definiálása

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Paint; override;
    { Világ koordináták (W) képernyõ koordináttákká (S) ill. vissza }
    function  XToW(x:integer):TFloat;
    function  YToW(y:integer):TFloat;
    function  XToS(x:TFloat):integer;
    function  YToS(y:TFloat):integer;
    function  WToS(p:TPoint2d):TPoint; overload;
    function  WToS(x,y:TFloat):TPoint; overload;
    function  SToW(x,y: integer):TPoint2d; overload;
    function  SToW(p: TPoint): TPoint2d; overload;
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
    property  WorkOrigo: TPoint2d read fWorkOrigo write SetWorkOrigo;
    property  Window: TRect2d read GetWindow write SetWindow;

    function GetDrawExtension: TRect2d;
    function IsRectInWindow(R: TRect2d): boolean;
    function IsPaperInWindow: boolean;
    function IsPointInWindow(p: TPoint2d): boolean;
    { Curves and process}
    function MakeCurve(const AName: Str32; ID: integer; Shape: TDrawMode;
             AEnabled, AVisible, AClosed: Boolean): Integer;
    procedure MakeNewCurve(AIndex: integer; var cuv: TCurve);
    procedure Clear;
    function  AddCurve(ACurve: TCurve):integer;
    procedure DeleteCurve(AItem: Integer);
    procedure DeleteSelectedCurves;
    procedure DeleteInvisibleCurves;
    procedure DeleteEmptyCurves;
    procedure InsertCurve(AIndex: Integer; Curve: TCurve);
    function  GetCurveName(H: Integer): Str32;
    function  GetCurveHandle(AName: Str32; var H: Integer): Boolean;
    function  GetCurveIndex(AName: Str32): Integer;
    function  ShapeCount(Shape: TDrawMode): Integer;
    procedure CloneCurve(AIndex: integer);
    procedure CloneContour(AIndex: integer);
    procedure CloneSeledted;
    procedure CreateBoxObject(AIndex: integer);
    procedure CuttingObject(AIndex: integer);

    procedure AddPoint(AIndex: Integer; X, Y: TFloat); overload;
    procedure AddPoint(AIndex: Integer; P: TPoint2d); overload;
    procedure InsertPoint(AIndex,APosition: Integer; X,Y: TFloat); overload;
    procedure InsertPoint(AIndex,APosition: Integer; P: TPoint2d); overload;
    procedure DeletePoint(AIndex,APosition: Integer);
    procedure DeleteSamePoints(diff: TFloat);
    procedure ChangePoint(AIndex,APosition: Integer; X,Y: TFloat);
    procedure DoMove(Dx,Dy: Integer);  // Move a point in curve
    procedure GetPoint(AIndex,APosition: Integer; var X,Y: TFloat);
    function  GetMaxPoints: Integer;
    function  GetNearestPoint(p: TPoint2d; var cuvIdx, pIdx: integer): TFloat;
    procedure SetNearestBeginPoint(p: TPoint2d);
    procedure SetBeginPoint(ACurve,AIndex: Integer);
    procedure SetOutherBeginPoint(Ax,Ay: TFloat);

    procedure MoveCurve(AIndex :integer; Ax, Ay: TFloat);
    procedure MoveSelectedCurves(Ax,Ay: TFloat);
    procedure RotateSelectedCurves(Cent : TPoint2d; Angle: TFloat);
    procedure InversSelectedCurves;
    procedure InversCurve(AIndex: Integer);
    procedure SelectCurveByName(aName: string);
    procedure SelectCurve(AIndex: Integer);
    procedure PoligonizeAll(PointCount: integer);
    procedure PoligonizeAllSelected(PointCount: integer);
    procedure Poligonize(Cuv: TCurve; Count: integer);
    procedure VektorisationAll(MaxDiff: TFloat);
    procedure VektorisationAllSelected(MaxDiff: TFloat);
    procedure Vektorisation(MaxDiff: TFloat; Cuv: TCurve);
    procedure PontSurites(Cuv: TCurve; Dist: double);
    procedure PontSuritesAll(Dist: double);

    procedure CheckCurvePoints(X, Y: Integer);

    procedure SelectAll(all: boolean);
    procedure SelectAllInArea(R: TRect2D);
    procedure SelectAllInAreaEx(R: TRect2d); // Select only points
    procedure AddSelectedToSelectedFrame;
    procedure ClosedAll(all: boolean);
    procedure BombAll;                      // Bomb for lines
    procedure SelectAllPolylines;
    procedure SelectAllPolygons;
    procedure SelectParentObjects;
    procedure SelectChildObjects;
    function  GetSelectedCount: integer;
    function  GetSelectArea( var RArea: TRect2d): boolean;
    procedure ChangeSelectedShape( newShape: TDrawMode );

    procedure EnabledAll(all: boolean);
    procedure SignedAll(all: boolean);
    procedure CrossedAll(all: boolean);
    procedure SortedAll(all: boolean);
    procedure SignedNotCutting;
    function  GetSignedCount: integer;

    procedure JoinSelected;
    procedure MirrorSeledted(Horiz, Vert: boolean);

    { Transformations }
    procedure Normalisation(Down: boolean);
    procedure NormalisationEx(Down: boolean);
    procedure Eltolas(dx,dy: double);
    procedure Nyujtas(tenyezo:double);
    procedure CentralisNyujtas(Cent: TPoint2d; tenyezo: double);
    procedure MagnifySelected(Cent: TPoint2d; Magnify: TFloat);
    procedure MirrorHorizontal;
    procedure MirrorVertical;
    procedure MirrorCentral;

    function SaveCurveToStream(FileStream: TStream;
      Item: Integer): Boolean;
    function LoadCurveFromStream(FileStream: TStream): Boolean;
    function LoadCurveFromFile(const FileName: string): Boolean;
    procedure SaveGraphToMemoryStream(var stm: TMemoryStream);
    procedure LoadGraphFromMemoryStream(stm: TMemoryStream);
    function SaveGraphToFile(const FileName: string): Boolean;
    function LoadGraphFromFile(const FileName: string): Boolean;
    function LoadOldGraphFromFile(const FileName: string): Boolean;
      // 3d parameters file save/load (*.sb3)
    function SaveGraph3dToFile(const FileName: string): Boolean;
    function LoadGraph3dFromFile(const FileName: string): Boolean;
    function SaveCurve3dToStream(FileStream: TStream; Item: Integer): Boolean;
    function LoadCurve3dFromStream(FileStream: TStream; Item: Integer): Boolean;

    function  LoadFromDXF(const FileName: string): Boolean;
    function  SaveToDXF(const FileName: string):boolean;
    function  LoadFromPLT(const FileName: string): Boolean;
    procedure LoadFromDAT(Filename: STRING);
    function  SaveToDAT(Filename: STRING):boolean;
    function  LoadFromTXT(Filename: STRING):boolean;
    function  SaveToTXT(Filename: STRING):boolean;
    function  SaveToCNC(Filename: STRING):boolean;
    procedure LoadFromGKOD(Filename: STRING);
    procedure DXFCurves;
    function  LoadFromSVG(Filename: STRING): boolean;
    function  SaveToSVG(Filename: STRING):boolean;
    function  GetSVGText: STRING;
//    procedure SetSVGText( SVGText: string );

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
    procedure ReorderObjects;
    procedure Lazitas(coeff: TFloat);
    procedure AutoCutSequence(BasePoint: TPoint2d; Sorting: boolean;
                                         CutMethod: byte);
    procedure AutoSTRIP(FileName: string; BasePoint: TPoint2d);
    procedure StripObj12(AParent,Achild: integer);
    procedure StripChildToParent(AIndex: integer);
    procedure StripAll;
    procedure StripAll1;

    procedure InitParentObjects;
    function  IsParent(AIndex: Integer): boolean; overload;
    function  IsParent(x, y: TFloat): boolean; overload;
    function  GetInnerObjectsCount(AIndex: Integer): integer; overload;
    function  GetInnerObjectsCount(Cuv: TCurve): integer; overload;
    function  GetParentObject(AIndex: Integer): integer; overload;
    function  GetParentObject(x,y: TFloat): integer; overload;
    function  GetRealParentObject(AIndex: Integer): integer;

    function  ObjectContour(Cuv: TCurve;OutCode:double): TCurve;
    function  GetContour(Cuv: TCurve;OutCode:double): TCurve;
    procedure SetContour(AIndex: Integer; Radius: double);
    procedure SetAllContour;
    procedure ContourOptimalizalas(var Cuv: TCurve);
    function  IsCutObject(p1,p2: TPoint2d; var Aindex: integer): boolean;
    function ConturInOut(cCuv: TCurve; AP, BP: TPoint2d; var BE,
      KI: TInOutRec): integer;
    function  ElkerulesAB(Var eCurve: TCurve): boolean;
    procedure Elkerules;
    procedure Elkerules1;

    procedure DrawCurve(Cuv: TCurve; co: TColor);
    procedure DrawNode(p: TPoint2d; m: integer; Fill: boolean; co: TColor);

    procedure ShowHintPanel(Show: Boolean);

    { Working }
    procedure DrawWorkPoint(x,y:double);
    procedure ClearWorkPoint;
    procedure WorkpositionToCentrum;
    procedure TestVekOut(dx,dy:extended);
    procedure TestWorking(AObject,AItem:integer);

    // SelectedFrame
    procedure DoSelectedFrame(aSave: boolean);
    procedure DrawSelectedFrame;
    procedure LoadSelectedFrame;
    procedure AdjustSelectedFrame;
    function IsNode(p: TPoint2d; Radius: double; var idx: integer): boolean;

    { Clipper }
    function GetClipperContour(Cuv: TCurve; dist: double): TCurve;
    procedure ClipperBool(ClipType: TClipType);
    procedure cUnion;
    procedure cIntersection;
    procedure cDifference;
    procedure cXor;

    { BackImage }

    procedure InitTrans3d;

    property pFazis: integer read fpFazis write SetpFazis;    // Drawing phase
    property WorkArea: TRect read FWorkArea write SetWorkArea;
    property Loading: boolean read FLoading write SetLoading;
    property Canvas;
    property SelectedCount: integer read GetSelectedCount;
    property DisabledCount: integer read GetDisabledCount;
    property CentralisZoom: boolean  read FCentralisZoom write FCentralisZoom;
    property Curves[idx: integer]: TCurve read GetCurve write SetCurve;
  published
    property ActionMode    : TActionMode read fActionMode write SetActionMode;
    property ActLayer      : integer read fActLayer write fActLayer default 0;
    property Append        : boolean read FAppend write FAppend;
    property AutoUndo      : boolean read fAutoUndo write fAutoUndo;
    property AutoPoligonize: boolean read fAutoPoligonize write fAutoPoligonize;
    property BackImage     : TBMPObject  read FBackImage write SetBackImage;
    // Befoglaló téglalap rajzolása
    property ShowBoxes     : boolean read FBoxing write SetBoxing;
    property Changed       : boolean read fChanged write fChanged;
    property Centrum       : TPoint2dObj read fCentrum write fCentrum;
    property CentralCross  : boolean read fCentralCross write SetCentralCross;
    property CoordLabel    : TLabel read fCoordLabel write fCoordLabel;
    property CursorCross   : boolean read fCursorCross write SetCursorCross;
             // Kontúr vonal távolsága az objektumtól vágásnál és kontúrozásnál
    property ContourRadius : double read FContourRadius write FContourRadius;
             // Kontúr vonal távolsága egyedi objektum kontúrozáshoz
    property Clone_Contour : double read FClone_Contour write FClone_Contour;
    property DefaultLayer  : Byte read fDefaultLayer write SetDefaultLayer default 0;
    property Demo          : boolean read FDemo write FDemo default False;
    property DesigneMode   : boolean read FDesigneMode write SetDesigneMode default False;
    property DrawMode      : TDrawMode read FDrawMode write SetDrawMode;
    property BackColor     : TColor read fBackColor write SetBackColor;
    property EnablePaint   : boolean read fEnablePaint write SetEnablePaint;
    property Filled        : boolean read FFilled write SetFilled;
    property FileName      : string read FFilename write SetFilename;
    property GraphTitle    : Str32 read FGraphTitle write SetGraphTitle;
    property Grid          : TGrid read fGrid Write fGrid;
    property Gravity       : boolean read FGravity write FGravity default False;
    property Hinted        : boolean read fHinted write fHinted;
    property CoordHint     : boolean read fCoordHint write SetCoordHint;
    property Locked        : boolean read fLocked write SetLocked;  // Editable?
    property MMPerLepes    : extended read FMMPerLepes write FMMPerLepes;
    property Ortho         : boolean read FOrtho write SetOrtho default false;
    property Paper         : TPoint2dObj read fPaper write fPaper;
    property PaperColor    : TColor read fPaperColor write SetPaperColor;
    property PaperVisible  : boolean read FPaperVisible write SetPaperVisible;
    property SablonSzinkron: boolean read FSablonSzinkron write SetSablonSzinkron;
    property Selected      : TCurve read fSelected write SetSelected;
    property SelectedIndex : integer read FSelectedIndex write SetSelectedIndex;
    // Cursor sensitive radius of circle around of curves' points
    property SelectedVisible  : boolean read FSelectedVisible write SetSelectedVisible;
    property SensitiveRadius: integer read FSensitiveRadius write SetSensitiveRadius;
    property ShowPoints    : boolean read fShowPoints write SetShowPoints;
    property ShowNumbers   : boolean read fShowNumbers write SetShowNumbers;
    property PointWhdth    : integer read fPointWhdth write SetPointWhdth;
    property STOP          : boolean read FSTOP write SetSTOP;
    property TestSpeed     : double read FTestSpeed write FTestSpeed;
    property TitleFont     : TFont read FTitleFont write SetTitleFont;
    property XYCompulsion  : boolean read FXYCompulsion write FXYCompulsion default False;
    property Working       : boolean read fWorking write SetWorking;
    property Zoom          : extended read fZoom write SetZoom;
    // SelectedFrame
    property EnableSelectedFrame : boolean read FEnableSelectedFrame write SetEnableSelectedFrame;
    property SelectedFrame       : TSelectedArea read FSelectedFrame write FSelectedFrame;
    property VisibleContours     : Boolean read FVisibleContours write SetVisibleContours;
    // Pre definied length of line
    property DefiniedLength      : boolean read FDefiniedLength write fDefiniedLength;

    property bFillBrush    : TBrush read fbFillBrush write SetbFillBrush;
    property pClosed       : TPen read fpClosed   write SetpClosed;
    property pOpened       : TPen read fpOpened   write SetpOpened;
    property pSelected     : TPen read fpSelected write SetpSelected;
    property pSigned       : TPen read fpSigned   write SetpSigned;
    property pCrossed      : TPen read fpCrossed  write SetpCrossed;
    property pSorted       : TPen read fpSorted   write SetpSorted;


    property OnChangeAll      : TNotifyEvent read fChangeAll write fChangeAll;
    property OnChangeCurve    : TChangeCurve read fChangeCurve write fChangeCurve;
    property OnChangeMode     : TChangeMode read fChangeMode write fChangeMode;
    property OnChangeSelected : TChangeCurve read fChangeSelected write fChangeSelected;
    property OnChangeWindow   : TChangeWindow read fChangeWindow write fChangeWindow;
    property OnMouseEnter     : TMouseEnter read FMouseEnter write FMouseEnter;
    property OnMouseLeave     : TMouseEnter read FMouseLeave write FMouseLeave;
    property OnNewBeginPoint  : TNewBeginPoint read fNewBeginPoint write fNewBeginPoint;
    property OnUndoRedoChange : TUndoRedoChangeEvent read FUndoRedoChangeEvent
             write FUndoRedoChangeEvent;
    property OnSelectedFrame  : TNotifyEvent read fOnSelectedFrame write fOnSelectedFrame;
    property OnAutoSort       : TAutoSortEvent read FAutoSortEvent write FAutoSortEvent;
    property OnPlan           : TProcess read FPlan write FPlan; // Event for autocut percent

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

//   procedure Register;

Var
    VirtualClipboard : TMemoryStream;   // Store List of vectorial curves for public
    ClipboardStr     : WideString;      // Save draw to clipboard as text

Const
  DrawModeText : Array[0..15] of String =
              ('None', 'Point', 'Line', 'Rectangle', 'Polyline', 'Polygon',
               'Circle', 'Ellipse', 'Arc', 'Chord', 'Spline', 'BSline', 'Text',
               'FreeHand','Bitmap','Path');

  ActionModeText : Array[0..20] of String =
               ('None', 'Drawing', 'Paning', 'Zooming', 'Painting',
                 'Select',
                 'InsertNode', 'DeleteNode', 'MoveNode','SelectNode',
                 'ChangeNode', 'DeleteSelected', 'MoveSelected', 'RotateSelected',
                 'NewBeginNode', 'MagnifySelected', 'SelectArea', 'SelectAreaEx',
                 'AutoPlan','TestWorking','OutherBeginNode');

  ShapeClosed : Array[0..12] of Boolean =
              (False, False, False, True, False, True,
               True, True, False, True, False, True, False);

implementation
{$R AL_Paper.dcr}

(*
// ============ TKeyboardThread =================
Type
  TKeyboardThread = class(TThread)
  private
    FOwner : TALSablon;
  protected
    procedure Execute; override;
  public
    constructor Create(Sablon: TALSablon; Enabled: Boolean);
  end;

constructor TKeyboardThread.Create(Sablon: TALSablon; Enabled: Boolean);
begin
  FOwner := Sablon;
  inherited Create(Enabled);
//  FreeOnTerminate := True;
end;

procedure TKeyboardThread.Execute;
var dx,dy: integer;
    k:integer;
    l,r,u,d: short;
begin
  repeat
  if FOwner.ComponentState=[] then
  begin
    k:=16;
    dx := 0; dy:=0;
    l := GetAsyncKeyState(VK_LEFT);
    r := GetAsyncKeyState(VK_RIGHT);
    u := GetAsyncKeyState(VK_UP);
    d := GetAsyncKeyState(VK_DOWN);
    if l<0 then dx := k;
    if r<0 then dx := -k;
    if u<0 then dy := k;
    if d<0 then dy := -k;

    if (dx<>0) or (dy<>0) then
       FOwner.MoveWindow(dx,dy);
//    sleep(100);
  end;
  until Terminated;
end;
*)
(*
procedure Register;
begin
  RegisterComponents('AL',[TALSablon]);
end;
*)


{ TALSablon }

procedure TALSablon.Change(Sender: TObject);
begin
  if Sender is TCurve then
     if Assigned(fChangeCurve) then fChangeCurve(Self,TCurve(Sender),-1);
  Invalidate;
end;

procedure TALSablon.ChangeCentrum(Sender: TObject);
var p: TPoint2d;
begin
  Origo := CentToOrigo(Point2d(Centrum.x,Centrum.y));
  Repaint;
end;

procedure TALSablon.ChangePaperExtension(Sender: TObject);
begin
  ZoomPaper;
end;

constructor TALSablon.Create(AOwner: TComponent);
begin
  inherited;

  Screen.Cursors[crKez1]          :=  LoadCursor(HInstance, 'SKEZ_1');
  Screen.Cursors[crKez2]          :=  LoadCursor(HInstance, 'SKEZ_2');
  Screen.Cursors[crRealZoom]      :=  LoadCursor(HInstance, 'SREAL_ZOOM');
  Screen.Cursors[crNyilUp]        :=  LoadCursor(HInstance, 'SNYIL_UP');
  Screen.Cursors[crNyilDown]      :=  LoadCursor(HInstance, 'SNYIL_DOWN');
  Screen.Cursors[crNyilLeft]      :=  LoadCursor(HInstance, 'SNYIL_LEFT');
  Screen.Cursors[crNyilRight]     :=  LoadCursor(HInstance, 'SNYIL_RIGHT');
  Screen.Cursors[crZoomIn]        :=  LoadCursor(HInstance, 'SZOOM_IN');
  Screen.Cursors[crZoomOut]       :=  LoadCursor(HInstance, 'SZOOM_OUT');
  Screen.Cursors[crKereszt]       :=  LoadCursor(HInstance, 'SKERESZT');
  Screen.Cursors[crHelp]          :=  LoadCursor(HInstance, 'SHELP_CUR');
  Screen.Cursors[crPolyline]      :=  LoadCursor(HInstance, 'SPOLYLINE');
  Screen.Cursors[crPolygon]       :=  LoadCursor(HInstance, 'SPOLYGON');
  Screen.Cursors[crInsertPoint]   :=  LoadCursor(HInstance, 'SINSERTPOINT');
  Screen.Cursors[crDeletePoint]   :=  LoadCursor(HInstance, 'SDELETEPOINT');
  Screen.Cursors[crNewbeginPoint] :=  LoadCursor(HInstance, 'SNEWBEGINPOINT');
  Screen.Cursors[crRotateSelected]:=  LoadCursor(HInstance, 'SROTATESELECTED');
  Screen.Cursors[crFreeHand]      :=  LoadCursor(HInstance, 'SFREEHAND');
  Screen.Cursors[crCircle]        :=  LoadCursor(HInstance, 'SCIRCLE');
  Screen.Cursors[crRectangle]     :=  LoadCursor(HInstance, 'SRECTANGLE');
  Screen.Cursors[crSDefault]      :=  LoadCursor(HInstance, 'SDEFAULT');
  Screen.Cursors[crArc]           :=  LoadCursor(HInstance, 'SARC');

  STOP   := False;
  Width  := 200;
  height := 200;
  MouseOn    := False;
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
  pSelected.Width := 4;
  pSelected.Color := clBlue;
  pSelected.Style := psSolid;

  pCrossed := TPen.Create;
  pCrossed.Width := 2;
  pCrossed.Color := clRed;
  pCrossed.Style := psSolid;

  pSigned := TPen.Create;
  pSigned.Width := 2;
  pSigned.Color := clLime;
  pSigned.Style := psSolid;

  pSorted := TPen.Create;
  pSorted.Width := 2;
  pSorted.Color := clLime;
  pSorted.Style := psSolid;

  bFillBrush := TBrush.Create;
  bFillBrush.Color := clSilver;
  bFillBrush.Style := bsSolid;

  FDesigneMode      := True;
  fZoom             := 1;
  DrawBmp           := TBitMap.Create;
  FCurveList        := TList.Create;
  fPaper            := TPoint2DObj.Create;
  fPaper.x          := 210;
  fPaper.y          := 297;
  fBackColor        := clSilver;
  fPaperColor       := clWhite;
  fPaperVisible     := True;
  fGrid             := TGrid.Create;
  fGrid.OnChange    := Change;
  FFilled           := False;
  fCentrum          := TPoint2DObj.Create;
  fCentrum.OnChange := ChangeCentrum;
  fPaper.OnChange   := ChangePaperExtension;
  LastCPIndex:=-1;         // nincs pont
  LastCPCurve:=-1;         // nincs curve
  CPIndex:=-1;         // nincs pont
  CPCurve:=-1;         // nincs curve
  fCentralCross     := True;
  fCursorCross      := false;
  oldCursorCross    := false;
  fShowPoints       := True;
  FBoxing           := False;
  MouseInOut        := 1;
  Origin            := Point(0,0);
  MovePt            := Origin;
  oldMovePt         := MovePt;
  Hinted            := True;
  Hint1             := THintWindow.Create(Self);
  THintLabel        := TLabel.Create(Self);
  THintLabel.Parent := Self;
  THintLabel.Name   := 'HintLabel';
  THintLabel.Visible:= False;
  THintLabel.Transparent := false;

  fCoordHint        := False;
  painting          := False;
  fDefaultLayer     := 0;
  fSensitiveRadius  := 8;
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
  UndoInit;
  Changed := False;
//  DoubleBuffered := True;
  FWorkOrigo := Point2d(0,0);
  FMMPerLepes  := 4;
  TempCurve        := TCurve.Create;
  FContourRadius   := 2;
  FClone_Contour   := 5;
  FDemo   := False;
  FCentralisZoom:=True;
  FEnablePaint := True;
  SelectedFrame   := TSelectedArea.Create;
  SelectedFrame.AllwaysDraw := True;
  SelectedFrame.OnChange := change;
  fDefiniedLength := false;
  defLength       := 100;
  FBackImage      := TBMPobject.Create;
  FBackImage.OnChange := Change;
  fShowNumbers := False;
  painting := False;
  TabStop  := true;
  ZoomPaper;

//  KeyboardThread := TKeyboardThread.Create(Self,True);
//  KeyboardThread.Priority := tpLower;
//  KeyboardThread.Resume;
end;

destructor TALSablon.Destroy;
var
  I: Integer;
begin
if Self <> nil then begin
//  if KeyboardThread.Suspended then KeyboardThread.Resume;
//     KeyboardThread.Terminate;
//     KeyboardThread.Free;
  for I:=Pred(FCurveList.Count) downto 0 do
  begin
    FCurve:=FCurveList.Items[I];
    FCurve.Free;
  end;
  if SelectedFrame<>nil then
     SelectedFrame.Free;
  if FBackImage<>nil then
     FBackImage.Free;
  FCurveList.Free;
  if TempCurve<>nil then TempCurve.Free;
  pClosed.Free;
  pOpened.Free;
  pSelected.Free;
  pSigned.Free;
  pCrossed.Free;
  pSorted.Free;
  bFillBrush.Free;
  Hint1.Free;
  fPaper.Free;
  fGrid.Free;
  fCentrum.Free;
  FTitleFont.Free;
  DrawBmp.Free;
  WBmp.Free;
  UR.Free;
  THintLabel.Free;
  innerStream.Destroy;
end;
  inherited;
end;

procedure TALSablon.WMSize(var Msg: TWMSize);
begin
    inherited;
    ChangeCentrum(nil);
end;

procedure TALSablon.UndoInit;
begin
  UR.UndoInit;     // Initialize UndoRedo system
  UndoSave;        // Saves this situation
  Changed := False;
end;

procedure TALSablon.Undo;
begin
if (not Locked) and UR.Enable then begin
  Loading := True;
  FCurveList.Clear;
  UR.Undo;
  SelectedFrame.Visible := false;
  SignedNotCutting;
  Changed := True;
  Loading := False;
  invalidate;
end;
end;

procedure TALSablon.Redo;
begin
if (not Locked) and UR.Enable then begin
  Loading := True;
  Clear;
  UR.Redo;
  SelectedFrame.Visible := false;
  SignedNotCutting;
  Changed := True;
  Loading := False;
end;
end;

procedure TALSablon.UndoSave;
begin
if (not Locked) and UR.Enable then
  UR.UndoSave;  // Felhasználói mentés undo-hoz
end;

procedure TALSablon.UndoRedo(Sender:TObject; Undo,Redo:boolean);
begin
  If Assigned(FUndoRedoChangeEvent) then
     FUndoRedoChangeEvent(Self,Undo,Redo);
end;

procedure TALSablon.Paint;
var
  tps: tagPAINTSTRUCT;
  FC      : TCurve;
  R       : TRect;
  H,I,J,K : Integer;
  II,KK   : integer;
  Radius  : integer;
  X,Y     : TFloat;
  Angle   : TFloat;
  Size    : integer;
  p       : TPoint;
  pp      : Array[0..2] of TPoint2D;
  PA,pPA  : PPointArray;
  RE      : TRect2d;
  dc      : HDC;
  bRect   : TRect2d;
begin
if EnablePaint then
if (not Loading) and (not painting) then
Try
Try
  painting := True;
  beginpaint(DrawBmp.Canvas.Handle,tps );

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

  if FBackImage.Visible and (not FBackImage.BMP.Empty) then
  begin
     // Draw the backimage
     RE := FBackImage.BoundsRect;
     R  := Rect(XToS(RE.x1),YToS(RE.y1),XToS(RE.x2),YToS(RE.y2));
     with DrawBmp.Canvas do begin
          Pen.Style := psDash;
          Brush.Style := bsClear;
          Rectangle(R);
          SetStretchBltMode(DrawBmp.Canvas.Handle, STRETCH_DELETESCANS);
          StretchBlt(DrawBmp.Canvas.Handle,R.Left,R.Top,R.Right-R.Left,R.Bottom-R.Top,
             FBackImage.BMP.Canvas.Handle,
             0,0,FBackImage.BMP.Width,FBackImage.BMP.Height,
             SRCCOPY);
     end;
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

  Size:=GetMaxPoints * SizeOf(TPointArray);
  GetMem(PA,Size);
  if VisibleContours then
     II := 1
  else
     II := 0;

  for H:=0 to Pred(FCurveList.Count) do
  begin

  for KK := 0 to II do
  begin
    case KK of
    0: FC:=FCurveList.Items[H];
    1: begin
         FC := Curves[H].Contour;
       end;
    end;


    if FC<>nil then begin
    if FC.Visible and (FC.FPoints.Count > 0)
    then
    begin

      J:=Pred(FC.FPoints.Count);

      for I:=0 to J do
      begin
        FC.GetPoint(I,X,Y);
        p := WtoS(x,y);
        PA^[I].x:= p.x;
        PA^[I].y:= p.y;
      end;

      // Draw bounding boxes
      if ShowBoxes and FC.Closed then
      begin
      bRect := FC.BoundsRect;
      DrawBmp.Canvas.Pen.Color := clRed;
      DrawBmp.Canvas.Pen.Width := 1;
      DrawBmp.Canvas.Pen.Style := psDot;
      DrawBmp.Canvas.Brush.Style := bsClear;
      DrawBmp.Canvas.Rectangle(xtos(bRect.x1),ytos(bRect.y1),xtos(bRect.x2),ytos(bRect.y2));
      end;

      // Tollak beállítása =====================================================

      If FC.Closed then
         DrawBmp.Canvas.Pen.Assign(pClosed)
      else
         DrawBmp.Canvas.Pen.Assign(pOpened);

      If (FC.Selected) then begin
        DrawBmp.Canvas.Pen.Width := 4;
        DrawBmp.Canvas.Pen.Assign(pSelected);
      end;

      if FC.Signed then
        DrawBmp.Canvas.Pen.Assign(pSigned);

      if FC.Crossed then
        DrawBmp.Canvas.Pen.Assign(pCrossed);

      if FC.Sorted then
        DrawBmp.Canvas.Pen.Assign(pSorted);

      if FSelectedVisible then
      if FC = Selected then begin
         DrawBmp.Canvas.Pen.Width := 4;
         if FC.Selected then
            DrawBmp.Canvas.Pen.Color := clFuchsia
         else
            DrawBmp.Canvas.Pen.Color := clRed;
      end;

      end;

      Case KK of
      0:  // Objektumok
         begin
              if Filled then begin
                 DrawBmp.Canvas.Brush.Assign(bFillBrush)
              end else
                 DrawBmp.Canvas.Brush.Style:=bsClear;
         end;
      1: begin // Kontúrok
              DrawBmp.Canvas.Pen.Width := 1;
              DrawBmp.Canvas.Pen.Color := clRed;
//              DrawBmp.Canvas.Brush.Color := DrawBmp.Canvas.Pen.Color;
              DrawBmp.Canvas.Brush.Style:=bsClear;
         end;
      End;

      // Objektumok rajzolása ==================================================
      if PA<>nil then
      Case FC.Shape of
      dmPolygon,dmPolyLine,dmPoint,dmLine,dmRectangle,dmFreeHand,dmRotRectangle:
        If FC.Closed then
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
        If FC.FPoints.Count>2 then
        begin
          For i:=0 to 2 do begin
              FC.GetPoint(I,X,Y);
              pp[i] := Point2D(XtoS(x),YToS(y));
          end;
          KorivRajzol(DrawBmp.Canvas,pp[0],pp[1],pp[2]);
        end else
           DrawBmp.Canvas.PolyLine(Slice(PA^,Succ(J)));

      dmSpline:
        begin
          if FC.Closed then K:=3 else K:=4;
          SplineXP(DrawBmp.Canvas,Slice(PA^,Succ(J)),100,TBSplineAlgoritm(K));
        end;
      dmBSpline:
        begin
          if FC.Closed then K:=1 else K:=2;
          SplineXP(DrawBmp.Canvas,Slice(PA^,Succ(J)),100,TBSplineAlgoritm(K));
        end;
      dmText:

        begin
          DrawBmp.Canvas.Font := FCurve.Font;
          DrawBmp.Canvas.Font.Size := Trunc(FCurve.Font.Size * Zoom);
          if DrawBmp.Canvas.Font.Size>2 then begin
             Angle := FC.Angle;
             FC.GetPoint(0,X,Y);
             p := WtoS(x,y);
             if Angle=0 then
                DrawBmp.Canvas.TextOut(p.x,p.y,FC.Name)
             else
                RotText(DrawBmp.Canvas,p.x,p.y,FC.Name,Round(10*Angle));
          end;
        end;
        dmCubicBezier:
          begin
             DrawBmp.Canvas.PolyBezier(Slice(PA^,Succ(J)));
          end;
        dmQuadraticBezier:
          begin
             DrawBmp.Canvas.PolyBezierTo(Slice(PA^,Succ(J)));
          end;
        dmArrow:
          begin
            DrawBmp.Canvas.PolyLine(Slice(PA^,Succ(J)));

          end;

      end;

      // Sarokpontok rajzolása = Draw points
      DrawBmp.Canvas.Brush.Color:=clLime;
      If ShowPoints then
      begin
           DrawBmp.Canvas.Pen.Width := 1;
           If (FC.Selected) then begin
              DrawBmp.Canvas.Pen.Assign(pSelected);
              DrawBmp.Canvas.Pen.Width := 2;
           end else
              DrawBmp.Canvas.Pen.Color := clBlack;
           for I:=1 to J do
           begin
                if i=1 then
                   DrawBmp.Canvas.Brush.Color := clGray;
                if FC.GetPointRec(I).Selected then begin
                   DrawBmp.Canvas.Brush.Color := clBlue;
                   Radius := 2*fPointWhdth;
                end
                else begin
                   DrawBmp.Canvas.Brush.Color:=clLime;
                   Radius := fPointWhdth;
                end;
                if PA<>nil then
                DrawBmp.Canvas.Rectangle(PA^[I].x-Radius,PA^[I].y-Radius,
                                         PA^[I].x+Radius,PA^[I].y+Radius);
           end;
      end;


      // Draw begin point
      If (FC=Selected) then
           DrawBmp.Canvas.Brush.Color:=clRed
      else
           DrawBmp.Canvas.Brush.Color:=clBlue;
      if FC.OutBase then
           DrawBmp.Canvas.Brush.Color := clLime;
      DrawBmp.Canvas.Ellipse(PA^[0].x-fPointWhdth-1,PA^[0].y-fPointWhdth-1,
                PA^[0].x+fPointWhdth+1,PA^[0].y+fPointWhdth+1);

      // Objektum sorszám kiírása
      if ShowNumbers then
      begin
          DrawBmp.Canvas.Brush.Style := bsClear;
          DrawBmp.Canvas.Font.Color  := clBlack;
          DrawBmp.Canvas.Font.Size   := 12;
          DrawBmp.Canvas.TextOut(PA^[0].x,PA^[0].y,IntToStr(H+1));
      end;

    end;
   end;
  end;

  {Középkereszt}
  If CentralCross then
  With DrawBmp.Canvas do begin
    R := Clientrect;
    Pen.Color := clBlue;
    Pen.Style := psSolid;
    Pen.Width := 2;
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
  DrawWorkPoint(WorkPosition.WorkPoint.x,WorkPosition.WorkPoint.y);
  endpaint(DrawBmp.Canvas.Handle,tps);
  Canvas.CopyRect(R,DrawBmp.Canvas,R);
  DrawSelectedFrame;
  If CursorCross {and (MouseInOut=1)} then DrawMouseCross(oldMovePt,pmNotXor);
  painting := False;
  if Assigned(fChangeWindow) then
     fChangeWindow(Self,fOrigo, fZoom, Mouse_Pos)
end;
except
  painting := False;
  Exit;
end;
end;

procedure TALSablon.GridDraw;
var
    kp,kp0: TPoint2d;
    tav,kpy,mar,marx,mary: extended;
    i: integer;
    GridTav : integer;     // Distance between lines
    szorzo  : double;
    R : TRect;
begin
If Grid.Visible then begin
   if Grid.Metric = meMM then
      szorzo := 1
   else
      szorzo := inch/10;

  GridTav := Grid.SubDistance;

  With DrawBmp.Canvas do

  if Grid.OnlyOnPaper then begin
  For i:=0 to 2 do begin
      tav  := Gridtav*szorzo;
      if (Zoom*tav)>8 then begin

      Pen.Color := Grid.SubgridColor;
      Case GridTav of
      1:   Pen.Width := 1;
      10:
      begin
         Pen.Width := 2;
         if (Zoom*tav)<64 then Pen.Width := 1;
      end;
      100:
      begin
         Pen.Color := Grid.MaingridColor;
      end;
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
      tav  := Zoom * Gridtav * szorzo;
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
       DrawBmp.Canvas.Pen.Width := 2;
       DrawBmp.Canvas.Pen.Color := clTeal;
       R:=Rect(XToS(Grid.Margin),YToS(Grid.Margin),XToS(Trunc(Paper.x-Grid.Margin)),
               YToS(Trunc(Paper.y-Grid.Margin)));
       DrawBmp.Canvas.Rectangle(R);
 end;
end;

{Új origo meghatározása: átírja a centrum koordinátáit is}
procedure TALSablon.NewOrigo(x,y:extended);
var  c : TPoint2d;
begin
    FOrigo.x:=x;
    FOrigo.y:=y;
    c := OrigoToCent;
    fCentrum.x := c.x;
    Centrum.y := c.y;
end;

procedure TALSablon.SetBackColor(const Value: TColor);
begin
  fBackColor := Value;
  Repaint;
end;

procedure TALSablon.SetBackImage(const Value: TBMPObject);
begin
  FBackImage := Value;
  Repaint;
end;

procedure TALSablon.SetPaperColor(const Value: TColor);
begin
  fPaperColor := Value;
  Repaint;
end;

procedure TALSablon.SetPaperVisible(const Value: boolean);
begin
  FPaperVisible := Value;
  Repaint;
end;

procedure TALSablon.SetZoom(const Value: extended);
var felx,fely: extended;
begin
 If fzoom<>Value then begin
 if CentralisZoom then begin
    felx := Width/(2*Zoom);
    fely := Height/(2*Zoom);
 end else begin
    felx := MovePt.x/(Zoom);
    fely := (Height-MovePt.y)/(Zoom);
 end;
  forigo.x := forigo.x+felx*(1-(fZoom/Value));
  forigo.y := forigo.y+fely*(1-(fZoom/Value));
  fZoom := Value;
  invalidate;
 end;
end;

function TALSablon.ShapeCount(Shape: TDrawMode): Integer;
var i: integer;
begin
  Result := 0;
  for i:=0 to Pred(FCurveList.Count) do begin
    FCurve:=FCurveList.Items[i];
    if FCurve.Shape=Shape then Inc(Result);
  end;
end;

function TALSablon.XToS(x: TFloat): integer;
begin
   Result:=Round(Zoom*(x-forigo.x));
end;

function TALSablon.YToS(y: TFloat): integer;
begin
   Result:=Height-Round(Zoom*(y-forigo.y));
end;

function TALSablon.XToW(x: integer): TFloat;
begin
   Result := origo.x + x / Zoom;
end;

function TALSablon.YToW(y: integer): TFloat;
begin
   Result := origo.y + (Height - y) / Zoom;
end;

function TALSablon.SToW(x, y: integer): TPoint2d;
begin
   Result.x := XToW(x);
   Result.y := YToW(y);
end;

function TALSablon.WToS(x, y: TFloat): TPoint;
begin
Try
   Result.x:= XToS(x);
   Result.y:= YToS(y);
except
   Result:= Point(0,0);
end;
end;

{Az origo koord.-áiból kiszámitja a képközéppont koord.it}
function  TALSablon.OrigoToCent:TPoint2D;
begin
  Result.x := origo.x+Width/(2*Zoom);
  Result.y := origo.y+Height/(2*Zoom);
end;

{Az képközéppont koord.-áiból kiszámitja a origo koord.it}
function  TALSablon.CentToOrigo(c:TPoint2D):TPoint2D;
begin
  Result.x := c.x-Width/(2*Zoom);
  Result.y := c.y-Height/(2*Zoom);
end;

procedure TALSablon.SetBeginPoint(ACurve,AIndex: Integer);
begin
Try
       FCurve:=FCurveList.Items[ACurve];
       FCurve.SetBeginPoint(AIndex);
       Selected := FCurve;
       Changed := True;
       if Assigned(fNewBeginPoint) then fNewBeginPoint(Self,ACurve);
except
end;
end;

procedure TALSablon.SetbFillBrush(const Value: TBrush);
begin
  fbFillBrush := Value;
  invalidate;
end;

procedure TALSablon.SetBoxing(const Value: boolean);
begin
  FBoxing := Value;
  invalidate;
end;

procedure TALSablon.SetOrtho(const Value: boolean);
begin
  FOrtho := Value;
  SelectedFrame.Ortho := Value;
end;

procedure TALSablon.SetOutherBeginPoint(Ax,Ay: TFloat);
begin
Try
       GetNearestPoint(Point2d(Ax,Ay),CPCurve,CPIndex);
       FCurve:=FCurveList.Items[CPCurve];
       FCurve.SetOutherBeginPoint(Ax,Ay);
       Selected := FCurve;
       Changed := True;
       if Assigned(fNewBeginPoint) then fNewBeginPoint(Self,CPCurve);
except
end;
end;

procedure TALSablon.DrawMouseCross(o:TPoint;PenMode:TPenMode);
var
    oldPen: TPen;
begin
Try
    oldPen:=Canvas.Pen;
    Canvas.pen.Color := clBlue;
    Canvas.pen.Width := 1;
    DrawShape(Canvas,Point(0,o.y),Point(Width,o.y),dmLine,PenMode);
    DrawShape(Canvas,Point(o.x,0),Point(o.x,Height),dmLine,PenMode);
Finally
    Canvas.Pen := oldPen;
end;
end;


procedure TALSablon.MouseDown(Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
Var xx,yy : TFloat;    // Mouse world coordinates
    pr    : TPointRec;
    s     : Str32;
    sel   : boolean;
    RR    : extended;    // Radius for magnify
    InputString : string;
    pp    : TPoint2d;
    p     : TPoint;
    sl    : string;
    szog  : double;
    MouseCoor: TPoint;
    cuvIdx,ptIdx: integer;
begin

  if (ActionMode=amDrawing) and Grid.aligne then
  begin
     x := XToS(Round(XToW(x)));
     y := YToS(Round(YToW(y)));
  end;
  xx := origo.x + x / Zoom;
  yy := origo.y + (Height-y) / Zoom;
  MapXY := SToW(Point(x,y));
  Origin := Point(x,y);
  MovePt := Point(x,y);
  Mouse_Pos := Origin;
  If pFazis=0 then oldOrigin := Origin;

  if Gravity then
    if CPMatch then
    begin
       pp := Curves[CPCurve].GetPoint2d(CPIndex);
       xx := pp.X;
       yy := pp.y;
    end;

  if SelectedFrame.Visible then
  begin
       if (Shift = [ssCtrl,ssLeft]) or (Shift = [ssLeft]) then begin
          if IsNode(SToW(MovePt),SensitiveRadius/Zoom,SelectedFrame.ActualNode) then
          Case SelectedFrame.ActualNode of
          -1   : Cursor := crCross;
          0..3 : Cursor := crHandpoint;
          4..7 : Cursor := crSize;
          8    : Cursor := crRotateSelected;
          end;
       End;
  End

  else

  begin

  if (DrawMode<>dmNone) then begin

  if (ssLeft in Shift) then begin

     Case DrawMode of

     dmNone :
       if (ActionMode in [amSelectArea,amSelectAreaEx]) then
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

     dmLine, dmArrow :
     Case pFazis of
     0: h:=MakeCurve('Line',-1,DrawMode,True,True,False);
     1: begin
          FCurve.AddPoint(xx,yy);
          pFazis := -1;
        end;
     end;

     dmRectangle :
     Case pFazis of
     0: h:=MakeCurve('Rectangle',-1,DrawMode,True,True,True);
     1: begin
          FCurve := FCurveList.Items[h];
          FCurve.GetPoint(0,pr.x,pr.y);
          FCurve.ClearPoints;
          if (ssCtrl in Shift) or Ortho then // négyzetté deformálás
          begin
               FCurve.AddPoint(pr.x,pr.y);
               FCurve.AddPoint(xx,pr.y);
               FCurve.AddPoint(xx,pr.y-(xx-pr.x));
               FCurve.AddPoint(pr.x,pr.y-(xx-pr.x));
          end else
          begin
               FCurve.AddPoint(pr.x,pr.y);
               FCurve.AddPoint(xx,pr.y);
               FCurve.AddPoint(xx,yy);
               FCurve.AddPoint(pr.x,yy);
          end;
          pFazis := -1;
        end;
     end;

  dmRotRectangle:
      Case pFazis of
      0: begin
         h:=MakeCurve('rotRectangle',-1,DrawMode,True,True,True);
         tegla.a := MapXY; tegla.b := MapXY; tegla.c := MapXY; tegla.d := MapXY;
         end;
      1: begin
          FCurve := Curves[h];
          FCurve.ClearPoints;
          tegla.b := MapXY;
          FCurve.AddPoint(tegla.a.X,tegla.a.Y);
          FCurve.AddPoint(tegla.b.X,tegla.b.Y);
         end;
      2: begin
          tegla := HaromPontbolTeglalap(tegla.a,tegla.b,MapXY);
          FCurve.ClearPoints;
          FCurve.AddPoint(tegla.a.X,tegla.a.Y);
          FCurve.AddPoint(tegla.b.X,tegla.b.Y);
          FCurve.AddPoint(tegla.c.X,tegla.c.Y);
          FCurve.AddPoint(tegla.d.X,tegla.d.Y);
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

     dmCircle,dmEllipse   :
     Case pFazis of
     0: h:=MakeCurve('Ellipse',-1,DrawMode,True,True,True);
     1: begin
        if (ssCtrl in Shift) or Ortho then
        begin
           DrawMode:=dmCircle;
           Curves[h].Name := 'Circle';
           Curves[h].Shape := dmCircle;
        end
        else begin
           DrawMode:=dmEllipse;
           Curves[h].Name := 'Ellipse';
           Curves[h].Shape := dmEllipse;
        end;
        if AutoPoligonize then
           Poligonize( FCurvelist.Items[h],0);
        pFazis := -1;
        end;
     end;

     dmArc:
           case pfazis of
           0: h:=MakeCurve('Arc',-1,DrawMode,True,True,False);
           1: begin
              FCurve.GetPoint(0,pr.x,pr.y);
              pp:=FelezoPont(Point2d(XToS(pr.x),YToS(pr.y)),Point2d(x,y));
              MovePt:=ClientToScreen(Point(Trunc(pp.x),Trunc(pp.y)));
              SetCursorPos(MovePt.x,MovePt.y);
              end;
           2: begin
              ChangePoint(h,1,xx,yy);
              if AutoPoligonize then
                 Poligonize( FCurvelist.Items[h],0);
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

     // Adott hosszúságú szakaszok rajzolása

     if pFazis>-1 then begin
        pp := Curves[h].GetPoint2d(Curves[h].Count-1);

        if (XYCompulsion or Ortho) and (pFazis>0) then      // XY kényszer
             if Abs(pp.X-xx)>Abs(pp.y-yy) then
                yy := pp.y
             else
                xx := pp.x;

        if FDefiniedLength and (pFazis>0) then
        if (XYCompulsion or Ortho) then
        begin
           if pp.Y=yy then
              if pp.X>xx then
                 xx:=pp.X-defLength else xx:=pp.X+defLength;
           if pp.X=xx then
              if pp.Y>yy then
                 yy:=pp.y-defLength else yy:=pp.y+defLength;
           szog := RelAngle2d(pp,Point2d(xx,yy));
           Move2d(pp,szog,defLength);
        end
        else
        begin
          szog := RelAngle2d(pp,SToW(MovePt));
          Move2d(pp,szog,defLength);
          xx := pp.X; yy := pp.y;
        end;

        AddPoint(h,xx,yy);

        if Curves[h].Shape in [dmLine,dmPolygon,dmPolyLine] then
        if FDefiniedLength then
        begin
        p := ClientToScreen(Point(x,y));
        sl := FloatToStr(defLength);
        if AL_InputQuery(p.x+10,p.y-10,'Vector Length','Length [mm] :',true,sl)
          then
               defLength := strtofloat(sl)
          else pFazis := -1;
        end;

     end;

  end;

  end  // End of if (DrawMode<>dmNone)
  else
     begin


       // Choice selected curve
       if (ActionMode = amNone) and (CurveMatch or CPMatch or CurveIn) then
       begin

          Selected := Curves[CPCurve];

          if (Shift = [ssAlt,ssCtrl,ssLeft]) or (Shift = [ssLeft]) then begin
             if CPMatch and ShowPoints Then begin
                ActionMode := amNone;
                pr := Curves[CPCurve].PointRec[CPIndex];
                if (Shift = [ssLeft]) then
                   ActionMode := amMovePoint
                else
                   Curves[CPCurve].ChangePoint(CPIndex,pr.x,pr.y,not pr.Selected);
             end;

             if CurveMatch or CurveIn or (CPMatch and not ShowPoints) then
             if (Shift = [ssLeft]) then
             begin
                   SelectAll(false);
                   Curves[CPCurve].Selected := True;
             end;

          end else
          begin
              // Csoportos kijelölés Shift-el
              if Shift = [ssShift,ssLeft]
              then begin
                   sel := Curves[CPCurve].Selected;
                   if CurveMatch then ActionMode := amMoveSelected;
                      Curves[CPCurve].Selected := not sel;
                      ActionMode := amMoveSelected;
                   if Assigned(fChangeSelected) then fChangeSelected(Self,Curves[CPCurve],CPIndex);
              end;
          end;

       end;
(*
       else
       if ActionMode <> amNone then
       begin
          Selected := nil;
          // Ha van kijelölt objektum, akkor a kijelölést törli
          if Shift = [ssLeft] then
             SelectAll(False);
       end;
*)

       // Insert point
       if (ActionMode = amInsertPoint) and CurveMatch then
       begin
          Selected := Curves[CPCurve];
          InsertPoint(CPCurve,Selected.CPIndex,xx,yy);
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
                pFazis := 1;
                ActionMode := amNone;
           end;
       1:  begin
                RotAngle := RelAngle2d(RotCentrum,Point2d(xx,yy));
                pFazis := 0;
           end;
       end;

       if (ActionMode = amNewBeginPoint) then
          if CPMatch then SetBeginPoint(CPCurve,CPIndex);

       if (ActionMode = amOutherBegin) then
          SetOutherBeginPoint(xx,yy);

     if (ActionMode = amManualOrder) then
     if (CurveMatch or CPMatch or CurveIn) then
     begin
        if Curves[CPCurve].Signed then
        begin
          Curves[CPCurve].Signed := False;
          pFazis := pFazis-1;
        end
        else
        begin
          Curves[CPCurve].Signed := True;
          if Curves[CPCurve].Shape=dmPolygon then
          begin
            pp := Curves[pFazis-1].LastPoint;
            Curves[CPCurve].SetBeginPoint(Curves[CPCurve].GetNearestPoint(pp));
          end;
          FCurveList.Move(CPCurve,pFazis);
          FSelectedIndex := pFazis;
        end;
        if Assigned(fChangeSelected) then fChangeSelected(Self,Curves[CPCurve],CPIndex);
        if pFazis=FCurveList.Count-1 then
        begin
           ActionMode := amNone;
           DrawMode := dmNone;
        end;
     end;

     end;

  end;

  oldMovePt := Origin;
  if Shift = [ssMiddle] then begin
     Screen.Cursor := crKez1;
  end ELSE
  if Button<>mbRight then begin
     pFazis := pFazis+1;
     MouseOn := True;
  end else
     MouseOn := False;
  Repaint;
  CheckCurvePoints(X,Y);
  inherited;
end;

procedure TALSablon.MouseMove(Shift: TShiftState; X,Y: Integer);
Var xx,yy: TFloat;
  pr: TPointRec;
  Hintstr: string;
  HintRect: TRect;
  p: TPoint;
  w,he: integer;
  nyil: boolean;
  szog: double;
  szorzo: double;
  ap: integer;
  pp: TPoint2d;
  dx,dy: TFloat;
  MouseCoor: TPoint;
  FCurve : TCurve;
  d: double;
  cur : TCursor;
label 111;

begin

  MapXY := SToW(Point(x,y));
  MovePt := Point(x,y);
  Mouse_Pos := MovePt;
  MouseOn := Shift <> [ssRight];

          if (Shift = [ssMiddle]) or (Shift = [ssCtrl,ssLeft]) then begin
             MoveWindow(x-oldMovePt.x,-(y-oldMovePt.y));
             Paning := True;
             if Paning then Screen.Cursor := crKez2;
             oldMovePt := MovePt;
             exit;
          end;

if not (ActionMode in [amInsertPoint,amMovePoint,amMoveSelected]) then
  CheckCurvePoints(X,Y);

  if Grid.aligne then
  begin
     x := XToS(Round(XToW(x)));
     y := YToS(Round(YToW(y)));
  end;

  MovePt := Point(x,y);
  Mouse_Pos := MovePt;
  MouseOn := Shift <> [ssRight];

  xx := origo.x + x / Zoom;
  yy := origo.y + (Height-y) / Zoom;

  if CPMatch and Gravity then
  begin
       pp := Curves[CPCurve].GetPoint2d(CPIndex);
       xx := pp.X;
       yy := pp.y;
  end;

  case Grid.Metric of
  meMM : szorzo:=1.0;
  meInch : szorzo:=1/inch;
  else
    szorzo:=1.0;
  end;
  MapPoint := Point2d(xx*szorzo,yy*szorzo);

  If (CoordLabel<>nil) then begin
     CoordLabel.Caption:=Trim(Format('%6.2f : %6.2f',[xx*szorzo,yy*szorzo]));
     CoordLabel.Repaint;
  end;


  If (DrawMode = dmNone) and (ActionMode in [amNone,amManualOrder]) then begin
     if (CPMatch and ShowPoints) then begin
        Cursor:=crHandPoint;
     end else
     if CurveMatch then Cursor:=crDrag else
     if CurveIn then Cursor:=crMultiDrag else
     if ActionMode=amManualOrder then
        Cursor := crUpArrow
     else
        Cursor := crDefault;
  end;

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

  if EnableSelectedFrame and (Shift = [ssAlt]) then
     Cursor := crCross;

  if SelectedFrame.Visible then
  begin
       if SelectedFrame.IsInPoint(Point2d(xx,yy)) then
          Cursor := crSizeAll
       else
          Cursor := crDefault;
       if (Shift = []) or (Shift = [ssCtrl]) then
          if IsNode(SToW(MovePt),SensitiveRadius/Zoom,ap) then
          Case ap of
          -1     : Cursor := crCross;
          0..3   : Cursor := crHandpoint;
          4..7,9 : Cursor := crHandpoint;
          8      : Cursor := crRotateSelected;
          end;
  End;

  if (ActionMode = amSelectFrame) and (Shift = [ssLeft])
          then begin
             Canvas.Pen.Style:=psSolid;
             Canvas.Brush.Style := bsSolid;
             Canvas.Brush.Color := clSilver;
             Canvas.Pen.Mode:=pmNotXor;
             Canvas.Rectangle(Origin.x,Origin.y,oldMovePt.x,oldMovePt.y);
             Canvas.Rectangle(Origin.x,Origin.y,MovePt.x,MovePt.y);
             Canvas.Pen.Style:=psSolid;
          end;

  if (ssLeft in Shift) then begin
     Case ActionMode of
     amNone,amMovePoints :
       begin

          if (Shift = [ssShift,ssLeft]) or (Shift = [ssCtrl,ssLeft]) or (Shift = [ssLeft]) then begin
             Moving := True;
             if Ortho then begin
               dx := x-oldMovePt.x;
               dy := y-oldMovePt.y;
               if Abs(dx)>Abs(dy) then
                  MoveSelectedCurves(dx,0)
               else
                  MoveSelectedCurves(0,-(y-oldMovePt.y))
             end
             else
             MoveSelectedCurves(x-oldMovePt.x,-(y-oldMovePt.y));
          end;

          if Shift = [ssShift,ssCtrl,ssLeft] then
             if CurveMatch or CurveIn then begin
                MoveCurve(CPCurve,x-oldMovePt.x,-(y-oldMovePt.y));
                Moving := True;
             end;

          if (Shift = [ssAlt,ssLeft]) or (Shift = [ssCtrl,ssAlt,ssLeft])
             or (ActionMode = amSelectFrame)
          then begin
             Canvas.Pen.Style:=psSolid;
             Canvas.Brush.Style := bsSolid;
             Canvas.Brush.Color := clSilver;
             Canvas.Pen.Mode:=pmNotXor;
             Canvas.Rectangle(Origin.x,Origin.y,oldMovePt.x,oldMovePt.y);
             Canvas.Rectangle(Origin.x,Origin.y,MovePt.x,MovePt.y);
             Canvas.Pen.Style:=psSolid;
          end;

          if (Shift = [ssCtrl,ssLeft]) or (Shift = [ssLeft]) then
          begin
             if SelectedFrame.Visible then
             begin
                case  SelectedFrame.ActualNode of
                -1,9: SelectedFrame.Move(XToW(x)-XToW(oldMovePt.x),YToW(Height-oldMovePt.y)-YToW(Height-y));
                0..3: if Ortho then
                      SelectedFrame.MoveEdge( SelectedFrame.ActualNode,
                          XToW(x)-XToW(oldMovePt.x),YToW(Height-oldMovePt.y)-YToW(Height-y) )
                      else
                      SelectedFrame.SetNode(SelectedFrame.ActualNode,SToW(MovePt));
                4..7: SelectedFrame.MoveEdge( SelectedFrame.ActualNode,
                          XToW(x)-XToW(oldMovePt.x),YToW(Height-oldMovePt.y)-YToW(Height-y) );
                8: with SelectedFrame do
                      RotAngle := -90+RadToDeg(Angle2D( Point2d(xx-RCent.X,yy-RCent.y) ));
                end;
                Paint;
             end;
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
       amSelectArea,amSelectAreaEx :
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

(*// MEGSZÛNT A JOBB EGÉRGOMBOS NAGYÍTÁS
  // Magnify with pressed right button and translate on paper
  if (Shift = [ssRight]) and (pFazis=0) then begin
     if ((Origin.x<>x) or (Origin.y<>y)) then begin
        FCentralisZoom:=True;
        If y<oldMovePt.y then
           Zoom := Zoom * 1.1
        else
           Zoom := Zoom * 0.9;
        Zooming := True;
        FCentralisZoom:=False;
        goto 111;
     end;
  end;
*)

  // Draw a shape
  if Shift <> [ssRight] then
  if (DrawMode<>dmNone) and (pFazis>0) {and (not Zooming)} then begin
     FCurve := FCurveList.Items[h];
     if MaxPointsCount>=FCurve.FPoints.Count then begin
        Case DrawMode of

        dmRectangle :
        begin
             FCurve.GetPoint(0,pr.x,pr.y);
             FCurve.ClearPoints;
          if (ssCtrl in Shift) or Ortho then // négyzetté deformálás
          begin
               FCurve.AddPoint(pr.x,pr.y);
               FCurve.AddPoint(xx,pr.y);
               FCurve.AddPoint(xx,pr.y-(xx-pr.x));
               FCurve.AddPoint(pr.x,pr.y-(xx-pr.x));
          end else
          begin
               FCurve.AddPoint(pr.x,pr.y);
               FCurve.AddPoint(xx,pr.y);
               FCurve.AddPoint(xx,yy);
               FCurve.AddPoint(pr.x,yy);
          end;
          Paint;
        end;

        dmRotRectangle:
        begin
          FCurve.ClearPoints;
          case pFazis of
          1: begin
               tegla.b := MapXY;
               FCurve.AddPoint(tegla.a.X,tegla.a.Y);
               FCurve.AddPoint(tegla.b.X,tegla.b.Y);
             end;
          2: begin
               tegla := HaromPontbolTeglalap(tegla.a,tegla.b,MapXY);
               FCurve.AddPoint(tegla.a.X,tegla.a.Y);
               FCurve.AddPoint(tegla.b.X,tegla.b.Y);
               FCurve.AddPoint(tegla.c.X,tegla.c.Y);
               FCurve.AddPoint(tegla.d.X,tegla.d.Y);
             end;
          end;
          Paint;
        end;

        dmArc :
        begin
          if FCurve.FPoints.Count=1 then
             FCurve.AddPoint(xx,yy)
          else
             ChangePoint(h,1,xx,yy);
          Paint;
        end;

        dmCircle, dmEllipse:
        begin
          if (ssCtrl in Shift) or Ortho then
             FCurve.Shape := dmCircle
          else
             FCurve.Shape := dmEllipse;
          if FCurve.FPoints.Count=1 then
             FCurve.AddPoint(xx,yy)
          else
             ChangePoint(h,1,xx,yy);
          paint;
        end;

        dmFreeHand :
        begin
          FCurve.AddPoint(xx,yy);
          Paint;
        end;
        else begin

          pp := Curves[h].GetPoint2d(Curves[h].Count-1);
          XYCompulsion := Shift = [ssCtrl];
          if (XYCompulsion or Ortho) and (pFazis>0) then      // XY kényszer
          begin
             if Abs(pp.X-xx)>Abs(pp.y-yy) then
                yy := pp.y
             else
                xx := pp.x;
          end;
          if FDefiniedLength then
          begin
               if (XYCompulsion or Ortho) then      // XY kényszer
               begin
                    if (pFazis>0) then begin
                       if pp.Y=yy then
                          if pp.X>xx then
                             xx:=pp.X-defLength else xx:=pp.X+defLength;
                       if pp.X=xx then
                          if pp.Y>yy then
                             yy:=pp.y-defLength else yy:=pp.y+defLength;
                       szog := RelAngle2d(pp,Point2d(xx,yy));
                       Move2d(pp,szog,defLength);
                    end;
               end
               else
               begin
                    szog := RelAngle2d(pp,SToW(MovePt));
                    Move2d(pp,szog,defLength);
               end;
               xx := pp.X; yy := pp.y;
          end;

          FCurve.AddPoint(xx,yy);
          RePaint;
          if FCurve<>nil then
          if (DrawMode<>dmFreeHand) then
             FCurve.DeletePoint(Pred(FCurve.FPoints.Count));
        end;
        end;
     end else pFazis:=0;
  end;

//  MouseInOut:=0;

  {Hint ablak rajzolása}
  Try

  THintLabel.Visible := fCoordHint;
  if fCoordHint then begin
     THintLabel.Transparent := false;
     THintLabel.Color := clInfoBk;
     THintLabel.Left := X+24;
     THintLabel.Top  := Y+24;
     pp := Curves[h].Points[0];
     THintLabel.Caption := Format('x:y = ( %6.1f : %6.1f )',[xx,yy]);
     if pFazis>0 then
     Case DrawMode of
     dmPolygon, dmPolyline, dmLine:
     begin
        d := KetpontTavolsaga(Curves[h].LastPoint,Point2d(xx,yy));
        THintLabel.Caption := Format('d = %6.1f',[d]);
     end;
     dmRectangle:
        THintLabel.Caption := Format('A : B = %6.1f : %6.1f',[Abs(xx-pp.X),Abs(yy-pp.y)]);
     dmCircle:
     begin
        d := 2*KetpontTavolsaga(pp,Point2d(xx,yy));
        THintLabel.Caption := Format('d = %6.1f',[d]);
     end;
     dmEllipse:
        if Ortho then begin
        d := 2*KetpontTavolsaga(pp,Point2d(xx,yy));
        THintLabel.Caption := Format('d = %6.1f',[d]);
        end else
        THintLabel.Caption := Format('A : B = %6.1f : %6.1f',[2*Abs(xx-pp.X),2*Abs(yy-pp.y)]);
     end;
     THintLabel.Update;
  end;

  If Hinted then begin
  If (CurveMatch or CPMatch or CurveIn) and (Shift = []) then begin
     Hint1.Font.Size :=8;
     Hint1.Font.Color:=clRed;
     FCurve := FCurveList.Items[CPCurve];
     Hintstr := '';
     If CurveMatch then
        Hintstr := '- '+IntToStr(CPCurve)+' -';
     If CPMatch then
        Hintstr := ' ['+IntToStr(CPCurve)+'] '+fCurve.Name+'  ( '+IntToStr(CPIndex+1)+' / '+IntToStr(FCurve.Count)+' ) ';
     if CurveIn then begin
        Hintstr := '<'+IntToStr(CPCurve)+'>';
     end;
     p := ClientToScreen(point(x+8,y-18));
     w := Hint1.Canvas.TextWidth(Hintstr)+12;
     he := Hint1.Canvas.TextHeight(Hintstr)+4;
     HintRect := Rect(p.x,p.y,p.x+w,p.y+he);
        Hint1.ActivateHint(HintRect,Hintstr);
        oldHintstr := Hintstr;
        HintActive:=True;
  end else
    If HintActive then begin
       Hint1.ReleaseHandle;
       HintActive := False;
    end;
  end;

  except
  end;

  if CursorCross then begin
     if MouseInout=0 then
       DrawMouseCross(oldMovePt,pmNotXor);
       DrawMouseCross(MovePt,pmNotXor);
     MouseInout:=0;
  end;

111: oldMovePt := Point(x,y);
  oldCursor := Cursor;
  if {(Drawmode = dmNone) and }ShowPoints and Gravity then
     ShowMagneticCircle(CPx,CPy,CPMatch);
//  if VisibleContours then SetAllContour;
  inherited MouseMove(Shift,X,Y);
end;

procedure TALSablon.MouseUp(Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
Var pr    : TPointRec;
    R     : TRect2d;
    ap    : integer;
begin
  Mouse_Pos := Point(x,y);
  MouseOn  := False;

  if Button = mbMiddle then begin
     Screen.Cursor := crDefault;
     Exit;
  end;

  if Button = mbRight then
  if AutoPoligonize then
     Case DrawMode of
     dmSpline, dmBSpline:
           Poligonize( Curves[h],0);
     End;

  if (not Zooming) and (Button=mbRight) then begin
     pFazis := 0;
  end
     else invalidate;

  If (not Paning) and (not Zooming) and (not Painting) and (Button<>mbRight) and AutoUndo then
     UndoSave;
  if (ActionMode=amSelectArea) or (Shift = [ssAlt]) then begin
     R := Rect2d(XToW(Origin.x),YToW(Origin.y),XToW(x),YToW(y));
     if EnableSelectedFrame then
     with SelectedFrame do begin
          UndoSave;
          SelectAll(False);
          AutoUndo := false;
          Ur.Enable := false;
          init;
          SelectedFrame.Visible := True;
          OrigRect := R;
          SelectAllInArea(R);
          DeleteSelectedCurves;
          Screen.Cursor := crDefault;
     end else
         SelectAllInArea(R);
//     ActionMode:=amNone;
  end;

  if SelectedFrame.Visible and (ActionMode=amNone) then
  begin
     IsNode(SToW(MovePt),SensitiveRadius/Zoom,ap);
     if SelectedFrame.ActualNode=-1 then
     if (Button = mbRight) then
        DoSelectedFrame(false)
     else begin
        if not SelectedFrame.IsInPoint(SToW(x,y)) then begin
           DoSelectedFrame(true);
        end;
     end;
     ActionMode:=amNone;
  end
  else
  if (ActionMode=amSelectAreaEx) or (ActionMode = amSelectFrame)
     or (Shift = [ssAlt,ssCtrl])
  then begin
     ActionMode:=amMovePoints;
     R := Rect2d(XToW(Origin.x),YToW(Origin.y),XToW(x),YToW(y));
     if ShowPoints then
        SelectAllInAreaEx(R)
     else
        SelectAllInArea(R);
     // Terület kijelölés után a SelecTedFrame megjelenítése
     if GetSelectArea(R) then
     begin
     SelectedFrame.Init;
     SelectedFrame.OrigRect := R;
     SelectedFrame.Visible := True;
     AddSelectedToSelectedFrame;
     UndoSave;
     AutoUndo := false;
     DeleteSelectedCurves;
     Screen.Cursor := crDefault;
     end;
  end;

  if (ActionMode in [amMovePoint,amMoveSelected]) then
     ActionMode := amNone;

  if Paning then Screen.Cursor := crDefault;
       Paning   := False;
       Zooming  := False;
       Painting := False;
       Moving   := False;

//  if FDrawmode<>dmNone then
  if ActionMode=amNone then SignedNotCutting;
  SelectedFrame.ActualNode:=-1;

  inherited MouseUp(Button,Shift,X,Y);
end;

procedure TALSablon.CMMouseEnter(var msg:TMessage);
begin
    inherited;
    MouseInOut:=1;
    if Hinted then
       THintLabel.Visible := CoordHint;
    if not Focused then
       SetFocus;
//    FCursorCross := oldCursorCross;
    invalidate;
    if Assigned(FMouseEnter) then FMouseEnter(Self);
end;

procedure TALSablon.CMMouseLeave(var msg: TMessage);
begin
    inherited;
    MouseInOut:=-1;
    If HintActive then begin
       Hint1.ReleaseHandle;
       HintActive := False;
    end;
    THintLabel.Visible := False;
//    oldCursorCross := CursorCross;
//    CursorCross := False;
    invalidate;
    if Assigned(FMouseLeave) then FMouseLeave(Self);
end;


procedure TALSablon.ZoomPaper;
var nagyx,nagyy : extended;
begin
  FCentralisZoom := True;
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
procedure TALSablon.ZoomDrawing;
var nagyx,nagyy : extended;
    I,J: integer;
    BR: TRect2d;
    x1,x2,y1,y2: TFloat;
begin
if SelectedFrame.Visible then
BEGIN
   BR := SelectedFrame.BoundsRect;
   MoveCentrum((BR.x2+BR.x1)/2,(BR.y2+BR.y1)/2);
END ELSE
if FCurveList.Count>0 then begin
 FCentralisZoom := True;
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
end else ZoomPaper;
end;

procedure TALSablon.SetCentralCross(const Value: boolean);
begin
  fCentralCross := Value;
  Invalidate;
end;

procedure TALSablon.MoveWindow(dx, dy: integer);
begin
if not painting then begin
  fOrigo.x := fOrigo.x - dx/Zoom;
  fOrigo.y := fOrigo.y - dy/Zoom;
  oldCentrum := OrigoToCent;
  fCentrum.x := oldCentrum.x;
  Centrum.y := oldCentrum.y;
end;
end;

// Margóhoz igazítás
procedure TAlSablon.Normalisation(Down: boolean);
var r: TRect2d;
begin
  r := GetDrawExtension;
  if ShapeCount(dmPolyLine)>0 then
  begin
     if down then Eltolas(-r.x1,-r.y1)
     else Eltolas(-r.x1,Paper.y-r.y2);
  end else
  begin
     if down then Eltolas(-r.x1+Grid.margin,-r.y1+Grid.margin)
     else Eltolas(-r.x1+Grid.margin,Paper.y-r.y2-Grid.margin);
  end;
  Paint;
end;

// 0 pozícióba mozgatás
procedure TAlSablon.NormalisationEx(Down: boolean);
var r: TRect2d;
begin
  r := GetDrawExtension;
  if down then Eltolas(-r.x1,-r.y1)
  else Eltolas(-r.x1,Paper.y-r.y2);
  Paint;
end;

procedure TALSablon.WorkpositionToCentrum;
begin
  MoveCentrum(WorkPosition.WorkPoint.x,WorkPosition.WorkPoint.y);
end;

function TALSablon.WToS(p: TPoint2d): TPoint;
begin
Try
   Result.x:= XToS(p.x);
   Result.y:= YToS(p.y);
except
   Result:= Point(0,0);
end;
end;

procedure TALSablon.MoveCentrum(fx,fy: double);
begin
  fCentrum.x := fx;
  Centrum.y := fy;
end;

// TALSablon ===============================================================

procedure TALSablon.SetCursorCross(const Value: boolean);
begin
  fCursorCross := Value;
  oldCursorCross:=fCursorCross;
  DrawMouseCross(MovePt,pmNotXor);
  invalidate;
end;

function TALSablon.GetCurve(idx: integer): TCurve;
begin
  if ((Idx>-1) and (idx < FCurveList.Count)) then
     Result := FCurveList.Items[idx]
  else
     Result := nil;
end;

procedure TALSablon.SetCurve(idx: integer; const Value: TCurve);
begin
  if ((Idx>-1) and (idx < FCurveList.Count)) then
     FCurveList.Items[idx] := Value;
end;

function TALSablon.GetWindow: TRect2d;
begin
  Result := Rect2d(Origo.x,origo.y,XToW(width),YToW(0));
end;

procedure TALSablon.SetWindow(const Value: TRect2d);
begin
  fOrigo.x := Value.x1;
  fOrigo.y := Value.y1;
  Zoom     := 1;
end;

procedure TALSablon.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1
end;

procedure TALSablon.SetDrawMode(const Value: TDrawMode);
begin
  if Locked then FDrawMode := dmNone else FDrawMode := Value;
  if Value = dmNone then
     FActionMode := amNone
  else
     FActionMode := amDrawing;
  pFazis    := 0;
  Cursor := crDefault;
  MaxPointsCount := High(integer);
  Case Value of
       dmNone     : Cursor := crDefault;
       dmPolyline : Cursor := crPolyline;
       dmPolygon  : Cursor := crPolygon;
       dmPoint    : MaxPointsCount := 1;
       dmLine     : MaxPointsCount := 2;
       dmCircle,dmEllipse:
         begin
              MaxPointsCount := 2;
              Cursor := crCircle;
         end;
       dmArc      :
         begin
              MaxPointsCount := 3;
              Cursor := crArc;
         end;
       dmRectangle:
         begin
              MaxPointsCount := 4;
              Cursor := crRectangle;
         end;
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

procedure TALSablon.SetEnablePaint(const Value: boolean);
begin
  fEnablePaint := Value;
  painting := not Value;
//  Repaint;
end;

procedure TALSablon.SetFilename(const Value: string);
begin
if FileExists(Value) then
begin
  if not Append then Clear;
  LoadGraphFromFile(Value);
  FFilename := Value;
end;
end;

procedure TALSablon.SetFilled(const Value: boolean);
begin
  FFilled := Value;
  Invalidate;
end;

procedure TALSablon.SetSensitiveRadius(const Value: integer);
begin
  FSensitiveRadius := Value;
  Delta := Value;
  If Value<4 then Delta := 4;
  Invalidate;
end;

procedure TALSablon.CloneCurve(AIndex: integer);
var h,i: integer;
begin
  SetContour( AIndex, ContourRadius );
  h:=MakeCurve('Clone',-1,Curves[AIndex].Shape,Curves[AIndex].Enabled,
                          Curves[AIndex].Visible,Curves[AIndex].Closed);
  for I := 0 to Pred(Curves[AIndex].Count) do
      AddPoint(h,Curves[AIndex].Points[i]);
//  MoveCurve( h,20,0);
  Changed := True;
  invalidate;
end;

procedure TALSablon.CloneContour(AIndex: integer);
var h,i: integer;
begin
  if (AIndex>-1) and (Aindex<FCurveList.Count) and (not Loading) then
  begin
  UndoSave;
  SetContour( AIndex, Clone_Contour );
  h:=MakeCurve('Clone',-1,Curves[AIndex].Shape,Curves[AIndex].Enabled,
                          Curves[AIndex].Visible,Curves[AIndex].Closed);
  for I := 0 to Pred(Curves[AIndex].Contour.Count) do
      AddPoint(h,Curves[AIndex].Contour.Points[i]);
  UndoSave;
  Changed := True;
  end;
  invalidate;
end;

// Az eredeti objektumból a kontúrjával egy bvelül lyukas objektumpárt képez.
// Az eredeti kontúrból pedig alsó-, és fedlapot.
procedure TALSablon.CreateBoxObject(AIndex: integer);
var
    h,i: integer;
begin
  if (AIndex>-1) and (Aindex<FCurveList.Count) and (not Loading) then
  begin
       SetContour( AIndex, ContourRadius );
       h:=MakeCurve('Clone',-1,Curves[AIndex].Shape,Curves[AIndex].Enabled,
                          Curves[AIndex].Visible,Curves[AIndex].Closed);
       for I := 0 to Pred(Curves[AIndex].Contour.Count) do
           AddPoint(h,Curves[AIndex].Contour.Points[i]);

       CloneCurve(h);
       MoveCurve(FCurveList.Count-1,100,0);
       SetContour( FCurveList.Count-1, ContourRadius );

       CloneCurve(h);
       MoveCurve(FCurveList.Count-1,-100,0);
       SetContour( FCurveList.Count-1, ContourRadius );

       invalidate;
  end;
end;

// Az AIndex által megjelölt nyílt objektummel kettévágunk egy objektumot.
// A gyakorlatban ezt úgy tehetjük, hogy egy Line/Polyline vonallal teljesen
// átmetsszük a darabolni kívánt objektumot. A metszéspontokat beinsertáljuk és
// a közüttük lévõ rész határoló vonala lesz a ketté metszett új objektumoknak.
procedure TALSablon.CuttingObject(AIndex: integer);
var
    h,nh: integer;
    i,n1,n2: integer;
    AP,BP: TPoint2d;
    mpCount: integer;
    BePont,KiPont: TInOutRec;

begin
  if (AIndex>-1) and (Aindex<FCurveList.Count) and (not Loading) then
  begin
     if AutoUndo then UndoSave;       // Elõtte mentés

     AP := Curves[Aindex].Points[0];                          // 0. pont
     BP := Curves[Aindex].Points[Pred(Curves[Aindex].Count)]; // Utolsó pont

     // Ha átvág egy objektumot
     h:=-1;
     If IsCutObject(AP,BP,h) then
     if h>-1 then begin
          mpCount := ConturInOut(Curves[h],AP,BP,BePont,KiPont);
          if mpCount=2 then
          begin
               n1 := Bepont.idx;
               n2 := Kipont.idx;
               if Bepont.idx>KiPont.idx then begin
                  n1 := Kipont.idx;
                  n2 := Bepont.idx;
                  Curves[h].InsertPoint(n1,KiPont.mPont.x,KiPont.mPont.y);
                  Curves[h].InsertPoint(n2+1,BePont.mPont.x,BePont.mPont.y);
               end else begin;
                  Curves[h].InsertPoint(n1,BePont.mPont.x,BePont.mPont.y);
                  Curves[h].InsertPoint(n2+1,KiPont.mPont.x,KiPont.mPont.y);
               end;

               Curves[h].SelectAllPoints(false);

               nh:=MakeCurve('Cut',-1,Curves[h].Shape,Curves[h].Enabled,
                          Curves[h].Visible,Curves[h].Closed);


               for I := n1 to n2+1 do
                   AddPoint(nh,Curves[h].Points[i]);
               MoveCurve(FCurveList.Count-1,0,16);
               Curves[nh].Selected := true;

               for I := n2 downto n1+1 do
                   DeletePoint(h,i);

               DeleteCurve(AIndex);

               if AutoUndo then UndoSave;       // Utána mentés

          end;
     end;
     invalidate;
  end;
end;



function TALSablon.AddCurve(ACurve: TCurve): integer;
begin
Try
  FCurveList.Pack;
  FCurveList.Add(ACurve);
  Result := FCurveList.Count-1;
  if Assigned(fChangeCurve) then fChangeCurve(Self, ACurve, -1);
  Changed := True;
except
  Result := -1;
end;
end;

procedure TALSablon.AddPoint(AIndex: Integer; X, Y: TFloat);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    FCurve.AddPoint(X,Y);
//    Selected := FCurve;
    Changed := True;
  end;
end;

procedure TAlSablon.AddPoint(AIndex: Integer; P: TPoint2d);
begin AddPoint(AIndex, P.X, P.Y); end;

procedure TALSablon.Assign(Source: TPersistent);
begin
  if (Source is TALSablon) then
  begin
    fCurveList     := TALSablon(Source).fCurveList;
    fCoordLabel    := TALSablon(Source).fCoordLabel;
    fCentrum       := TALSablon(Source).fCentrum;
    fOrigo         := TALSablon(Source).fOrigo;
    fWorkOrigo     := TALSablon(Source).fWorkOrigo;
    fPaper         := TALSablon(Source).fPaper;
    fZoom          := TALSablon(Source).fZoom;
    FPaperVisible  := TALSablon(Source).FPaperVisible;
    fPaperColor    := TALSablon(Source).fPaperColor;
    fBackColor     := TALSablon(Source).FBackColor;
    fCentralCross  := TALSablon(Source).fCentralCross;
    fGrid          := TALSablon(Source).fGrid;
    fHinted        := TALSablon(Source).fHinted;
    HintActive     := TALSablon(Source).HintActive;
    fCursorCross   := TALSablon(Source).fCursorCross;
    FDrawMode      := TALSablon(Source).FDrawMode;
    FSensitiveRadius:= TALSablon(Source).FSensitiveRadius;
    fShowPoints   := TALSablon(Source).fShowPoints;
    fDefaultLayer := TALSablon(Source).fDefaultLayer;
    fActionMode   := TALSablon(Source).fActionMode;
    fActLayer     := TALSablon(Source).fActLayer;
    fSelected     := TALSablon(Source).fSelected;
    FGraphTitle   := TALSablon(Source).FGraphTitle;
    fLocked       := TALSablon(Source).fLocked;
    FTitleFont    := TALSablon(Source).FTitleFont;
    fAutoUndo     := TALSablon(Source).fAutoUndo;
    fChanged      := TALSablon(Source).fChanged;
    FDemo         := TALSablon(Source).FDemo;
    FSablonSzinkron:= TALSablon(Source).FSablonSzinkron;
    FMMPerLepes   := TALSablon(Source).FMMPerLepes;
    FContourRadius:= TALSablon(Source).FContourRadius;
    FTestSpeed    := TALSablon(Source).FTestSpeed;
    FCentralisZoom:= TALSablon(Source).FCentralisZoom;
  end;
end;

procedure TALSablon.DeletePoint(AIndex,APosition: Integer);
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

procedure TALSablon.DeleteSamePoints(diff: TFloat);
// Deletes all same points in range of diff: only one point remains
// Azonos vagy nagyon közeli pontok kiejtése
var i,j,k  : integer;
    x,y    : TFloat;
    x1,y1  : TFloat;
begin
  for i:=0 to Pred(FCurveList.Count) do begin
    FCurve:=Curves[i];
    j:=0;
    if FCurve.FPoints.Count>1 then
    while j<FCurve.FPoints.Count-1 do begin
          FCurve.GetPoint(j,x,y);
          k:=j+1;
          while k<FCurve.FPoints.Count-1 do begin
                FCurve.GetPoint(k,x1,y1);
                if (Abs(x-x1)<diff) and (Abs(y-y1)<diff) then
                   FCurve.DeletePoint(k);
                inc(k);
          end;
          inc(j);
    end;
  end;
end;
{------------------------------------------------------------------------------}

procedure TALSablon.CheckCurvePoints(X, Y: Integer);
var i,J,K,L,H: integer;
    Lx,Ly  : TFloat;
    xx,yy  : TFloat;
    InCode : TInCode;
    R      : TRect2d;
    ter,oter: double;
    FC     : TCurve;
begin
    CPMatch:=False;
    CurveMatch:=False;
    CurveIn:=False;
    CPCurve:=-1;         // nincs curve
    oter := MaxDouble;

    xx := XToW(x);
    yy := YToW(y);

    delta := fSensitiveRadius/fzoom;

    J:=Pred(FCurveList.Count);

    for I:=J downto 0 do
    begin

      if Curves[I]=NIL then
         EXIT;

      if Curves[I].IsInBoundsRect(xx,yy) then begin

         if Curves[I].Shape in [dmCircle,dmEllipse,dmArc] then
         begin
         if drawmode=dmNone then begin
            Curves[I].FillTempCurve;
            FC:=Curves[I].TempCurve;
            Poligonize( FC,10);
         end else exit;
         end
         else
            FC:=Curves[I];

         if ShowPoints then
         begin
         if Curves[I].Shape in [dmCircle,dmEllipse,dmArc] then
            L := Curves[I].IsOnPoint(xx,yy,delta)
         else
            L := FC.IsOnPoint(xx,yy,delta);
         if L>-1 then
         begin
            CPMatch:=True;
            if CPCurve <> I then
               LastCPCurve := CPCurve;
            CPCurve:=I;
            if CPIndex <> L then
               LastCPIndex := CPIndex;
            CPIndex:=L;
            CPx:=Curves[CPCurve].Points[L].x;
            CPy:=Curves[CPCurve].Points[L].y;
            Exit;
         end;
         end;
         if CPIndex <> -1 then
            LastCPIndex := CPIndex;
         CPIndex:=-1;         // nincs pont

         InCode := FC.IsInCurve(xx,yy);
         case inCode of
         icOnLine :
         begin
              CurveMatch:=True;
              LastCPCurve := CPCurve;
              CPCurve:=I;
              Exit;
         end;
         icIn :
         begin
              R := FC.BoundsRect;
              ter := (R.x2-R.X1)*(R.y2-R.y1);
              if ter<oter then begin
                 CurveIn:=True;
                 LastCPCurve := CPCurve;
                 CPCurve:=I;
                 oter:=ter;
//                 exit;
              end;
         end;
         end;

      end;
    end;

end;

procedure TALSablon.DeleteCurve(AItem: Integer);
begin
  if AItem < FCurveList.Count then
  begin
    FCurve:=FCurveList.Items[AItem];
    FCurveList.Delete(AItem);
    if Assigned(fChangeCurve) then fChangeCurve(Self, FCurve, -1);
    Changed := True;
  end;
end;

procedure TALSablon.InsertCurve(AIndex: Integer; Curve: TCurve);
begin
  if (AIndex > -1) and (AIndex < FCurveList.Count-1) then
  begin
    FCurveList.Insert(AIndex,Curve);
    if Assigned(fChangeCurve) then fChangeCurve(Self, Curve, -1);
    Changed := True;
  end;
end;

function TALSablon.GetMaxPoints: Integer;
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
function  TALSablon.GetNearestPoint(p: TPoint2d; var cuvIdx, pIdx: integer): TFloat;
var
  I,J : Integer;
  d   : Double;
  x,y : double;
  Cuv : TCurve;
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
        Cuv.GetPoint(j,x,y);
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
            if SzakaszSzakaszMetszes(p,p0,p1,p2,mp) then begin
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

procedure TALSablon.GetPoint(AIndex, APosition: Integer; var X, Y: TFloat);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    if InRange(APosition,0,Pred(FCurve.FPoints.Count)) then
      FCurve.GetPoint(APosition,X,Y);
  end;
end;


procedure TALSablon.DoMove(Dx,Dy: Integer);
begin
  if CPMatch then begin
    CPx:=XToW(Dx);
    CPy:=YToW(Dy);
    ChangePoint(CPCurve,CPIndex,XToW(Dx),YToW(Dy));
    Paint;
  end;
end;

procedure TALSablon.InversCurve(AIndex: Integer);
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
function TALSablon.MakeCurve(const AName: Str32; ID: integer;
  Shape: TDrawMode; AEnabled, AVisible, AClosed: Boolean): Integer;
begin
Try
  Result := ID;
  IF ID<0 then Result:=FCurveList.Count; //.IndexOf(FCurve)+1;
  FCurve:=TCurve.Create;
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
  Result:=FCurveList.Count-1; //IndexOf(FCurve);
//  if Assigned(fChangeCurve) then fChangeCurve(Self, FCurve, -1);
except
  Result := -1;
end;
end;

// Az AIndex sorszámú objektumból létrehoz egy újat, de nem teszi be a listába
procedure TALSablon.MakeNewCurve(AIndex: integer; var cuv: TCurve);
var idx: integer;
    origCuv : TCurve;
begin
Try
  origCuv := Curves[AIndex];
  idx:=FCurveList.Count; //.IndexOf(FCurve)+1;
  cuv:=TCurve.Create;
  cuv.Name    := 'NewCurve_'+IntToStr(idx);
  cuv.ID      := idx+1;
  cuv.Closed  := origCuv.Closed;
  cuv.Shape   := origCuv.Shape;
  cuv.OnChange:= Change;
except
  cuv := nil;
End;
end;

// Mirror selected object. Centrum is the midle line of select area
procedure TALSablon.MirrorSeledted(Horiz, Vert: boolean);
var
   i,j: integer;
   xx,yy: double;
   rSel: TRect2d;
   P: TPoint2d;
begin
  if GetSelectedCount > 0 then
  begin
    if GetSelectArea( rSel ) then
    begin
         // Centrum of the selected rect
         xx := (rSel.x1+rSel.x2)/2;
         yy := (rSel.y1+rSel.y2)/2;

         For i:=0 to FCurveList.Count-1 do begin
             FCurve:=Curves[i];
             if FCurve.Selected then
             for j:=0 to Pred(FCurve.Count) do begin
                 P := FCurve.Points[j];
                 if Horiz then
                    FCurve.ChangePoint(j,xx+(xx-P.X),P.y);
                 P := FCurve.Points[j];
                 if Vert then
                    FCurve.ChangePoint(j,p.x,yy+(yy-P.Y));
             end;
         end;
    Changed := True;
    Paint;
    end;
  end;
end;

procedure TALSablon.MirrorCentral;
var R: TRect2d;
    i,j: integer;
    x,y,hx,hy: double;
begin
  R := GetDrawExtension;
  hx := (R.x2 + R.x1)/2;     // Középpont x értéke
  hy := (R.y2 + R.y1)/2;     // Középpont x értéke
  for i:=0 to Pred(FCurvelist.count) do
    for j := 0 to Pred(Curves[i].Count) do
    begin
      Curves[i].GetPoint(j,x,y);
      Curves[i].ChangePoint(j,hx+(hx-x),hy+(hy-y));
    end;
end;

procedure TALSablon.MirrorHorizontal;
var R: TRect2d;
    i,j: integer;
    x,y,h: double;
begin
  R := GetDrawExtension;
  h := (R.x2 + R.x1)/2;     // Középvonal x értéke
  for i:=0 to Pred(FCurvelist.count) do
    for j := 0 to Pred(Curves[i].Count) do
    begin
      Curves[i].GetPoint(j,x,y);
      Curves[i].ChangePoint(j,h+(h-x),y);
    end;
end;

procedure TALSablon.MirrorVertical;
var R: TRect2d;
    i,j: integer;
    x,y,h: double;
begin
  R := GetDrawExtension;
  h := (R.y2 + R.y1)/2;     // Középvonal y értéke
  for i:=0 to Pred(FCurvelist.count) do
    for j := 0 to Pred(Curves[i].Count) do
    begin
      Curves[i].GetPoint(j,x,y);
      Curves[i].ChangePoint(j,x,h+(h-y));
    end;
end;

// Megduplázza a kiválasztott objektumokat
procedure TALSablon.CloneSeledted;
var
   i,j: integer;
   xx,yy: double;
   rSel: TRect2d;
   P: TPoint2d;
begin
  if GetSelectedCount > 0 then
  begin
         For i:=0 to FCurveList.Count-1 do begin
             FCurve:=Curves[i];
             if FCurve.Selected then
                CloneCurve(i);
         end;
    Changed := True;
    Paint;
  end;
end;

function TALSablon.GetCurveHandle(AName: Str32; var H: Integer): Boolean;
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

function TALSablon.GetCurveIndex(AName: Str32): Integer;
var
  I,J: Integer;
begin
  Result:=-1;
  J:=FCurveList.Count;
  I:=0;
  AName:=AnsiUpperCase(AName);
  while I < J do
  begin
    FCurve:=FCurveList.Items[I];
    if AnsiUpperCase(FCurve.Name) = AnsiUpperCase(AName) then
    begin
      Result:=I;
      Exit;
    end;
    Inc(I);
  end;
end;

function TAlSablon.GetCurveName(H: Integer): Str32;
begin
  Result:='';
  if (H < 0) or (H > Pred(FCurveList.Count)) then Exit;
  FCurve:=FCurveList.Items[H];
  Result:=FCurve.Name;
end;

procedure TALSablon.SetShowNumbers(const Value: boolean);
begin
  fShowNumbers := Value;
  Invalidate;
end;

procedure TALSablon.SetShowPoints(const Value: boolean);
begin
  fShowPoints := Value;
  Invalidate;
end;

procedure TALSablon.SetSTOP(const Value: boolean);
begin
  FSTOP := Value;
end;

procedure TALSablon.SetWorking(const Value: boolean);
begin
  fWorking := Value;
  Paint;
end;

procedure TALSablon.Clear;
begin
  if SelectedFrame.Visible then
     DoSelectedFrame(false);
  FCurveList.Clear;
  BackImage.Clear;
//  if AutoUndo then UndoSave;
  if Assigned(FChangeAll) then FChangeAll(Self);
  invalidate;
end;

procedure TALSablon.SelectAll(all: boolean);
var i,j: integer;
    cuv: TCurve;
    pr: TPointRec;
begin
  Loading := True;
  for i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      Cuv.Selected := all;
      if not all then
         Cuv.SelectAllPoints(false);
  end;
  Loading := False;
//  if {(not MouseOn) and} (not Loading) then
  if Assigned(FChangeAll) then FChangeAll(Self);
  Invalidate;
end;

procedure TALSablon.EnabledAll(all: boolean);
var i: integer;
    cuv: TCurve;
begin
  For i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      Cuv.Enabled:=all;
  end;
  if not MouseOn then
  if Assigned(FChangeAll) then FChangeAll(Self);
  Invalidate;
end;

procedure TALSablon.SignedAll(all: boolean);
var i: integer;
    cuv: TCurve;
begin
  For i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      Cuv.Signed:=all;
  end;
  if not MouseOn then
  if Assigned(FChangeAll) then FChangeAll(Self);
  Invalidate;
end;

procedure TALSablon.CrossedAll(all: boolean);
var i: integer;
    cuv: TCurve;
begin
  For i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      Cuv.Crossed:=all;
  end;
  if not MouseOn then
  if Assigned(FChangeAll) then FChangeAll(Self);
  Invalidate;
end;

procedure TALSablon.SortedAll(all: boolean);
var i: integer;
    cuv: TCurve;
begin
  For i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      Cuv.Sorted:=all;
  end;
  if not MouseOn then
  if Assigned(FChangeAll) then FChangeAll(Self);
  Invalidate;
end;

// Select all curves in Area
procedure TALSablon.SelectAllInArea(R: TRect2d);
var i: integer;
    cuv: TCurve;
    RR,RC : TRect2d;
begin
//  Loading := True;
  RR := CorrectRealRect(R);
  for i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      RC := CorrectRealRect(Cuv.BoundsRect);
      If (RR.X1<=RC.X1) and (RR.X2>=RC.X2) and
         (RR.Y1<=RC.Y1) and (RR.Y2>=RC.Y2) then
      begin
         Cuv.Selected := True;
         if SelectedFrame.Visible then
            SelectedFrame.AddCurve(Cuv);
      end;
  end;
  if not MouseOn then
  if Assigned(FChangeAll) then FChangeAll(Self);
//  Loading := False;
  Invalidate;
end;

// A selected objektumokat a SelectedFrame-hez adja
procedure TALSablon.AddSelectedToSelectedFrame;
var i: integer;
    cuv: TCurve;
begin
  PoligonizeAllSelected(0);
  if SelectedFrame.Visible then
  for i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      if Cuv.Selected then
            SelectedFrame.AddCurve(Cuv);
  end;
  if not MouseOn then
  if Assigned(FChangeAll) then FChangeAll(Self);
  Invalidate;
end;

// Select all points in Area
procedure TALSablon.SelectAllInAreaEx(R: TRect2d);
var i,j: integer;
    cuv: TCurve;
    RR,RC : TRect2d;
    pr: TPointrec;
begin
//  Loading := True;
  RR := CorrectRealRect(R);
  for i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      for j:=0 to Pred(Cuv.Count) do begin
          pr := Cuv.PointRec[j];
          if PontInKep(pr.x,pr.y,R) then
             Cuv.ChangePoint(j,pr.x,pr.y,True);
      end;
  end;
  if not MouseOn then
  if Assigned(FChangeAll) then FChangeAll(Self);
//  Loading := False;
  Invalidate;
end;

procedure TALSablon.SelectAllPolygons;
var i: integer;
    cuv: TCurve;
begin
  for i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      cuv.Selected := Cuv.Shape = dmPolygon;
  end;
  if not MouseOn then
  if Assigned(FChangeAll) then FChangeAll(Self);
  Invalidate;
end;

procedure TALSablon.SelectAllPolylines;
var i: integer;
    cuv: TCurve;
begin
  for i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      cuv.Selected := (Cuv.Shape = dmPolyLine) AND (not Cuv.Closed);
  end;
  if not MouseOn then
  if Assigned(FChangeAll) then FChangeAll(Self);
  Invalidate;
end;


procedure TALSablon.ClosedAll(all: boolean);
var i: integer;
    cuv: TCurve;
begin
  for i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      if cuv.Selected then begin
         Cuv.Closed := all;
         if all then
            Cuv.Shape := dmPolygon
         else
            Cuv.Shape := dmPolyline
      end;
  end;
  if AutoUndo then UndoSave;
  if not MouseOn then
  if Assigned(FChangeAll) then FChangeAll(Self);
  Changed := True;
  Invalidate;
end;

function TALSablon.LoadFromDXF(const FileName: string): Boolean;
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
(*
  if not ValidDXF(FileName) then
     newFileName:=ExtractFilePath(FileName)+'_'+ExtractFileName(FileName)
  else
     newFileName:=FileName;
*)

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
                    If (sor = ' 70') then begin
                        ReadLn(f,sor);
                        Closed := (StrToInt(sor) and 1)=1;
                    end;
                until sor='VERTEX';
                N:=MakeCurve('Polyline',-1,dmPolyline,True,True,Closed);
            end;

            LWPOLYLINE :
                N:=MakeCurve('Polyline',-1,dmPolyline,True,True,False);

            CIRCLE :
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
               N:=MakeCurve('Circle',-1,dmCircle,True,True,True);
               AddPoint(N,arcU,arcV);
               AddPoint(N,arcU+arcR,arcV);
               goto 111;
            end;
            Until (sor='  0') or EOF(f);

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
               N:=MakeCurve('Arc',-1,dmArc,True,True,False);
               AddPoint(N,arcPPP.p1.x,arcPPP.p1.y);
               AddPoint(N,arcPPP.p2.x,arcPPP.p2.y);
               AddPoint(N,arcPPP.p3.x,arcPPP.p3.y);
               goto 111;
            end;

            SPLINE :
            begin
                Closed := False;
                N:=MakeCurve('Spline',-1,dmPolygon,True,True,Closed);
            end;
            end;

            Repeat
                ReadLn(f,sor);
                if ((DXFSec=SPLINE) or (DXFSec=LINE)) and (sor='  0') then
                   break;
                sor := sor;
                if ((DXFSec=SPLINE) or (DXFSec=LINE)) and (sor='  0') then
                   break;
//                sor := Copy(sor,Length(sor)-2,Length(sor));
                if (DXFSec=SPLINE) then
                If (sor=' 71') then begin
                    ReadLn(f,sor); i:=StrToInt(sor);
                    case i of
                    1,3: // Nem megy át a támpontokon
                       Curves[N].Shape := dmBSpline;
                    2: // átmegy a támpontokon
                       Curves[N].Shape := dmSpline;
                    end;
                end;
                // Zárt alakzat vizsgálat
                If (sor=' 70') then begin
                    ReadLn(f,sor);
                    if StrToInt(sor)=1 then begin
                       Curves[N].Closed := True;
                       if Curves[N].Closed then
                       if Curves[N].Shape = dmPolyline then
                          Curves[N].Shape := dmPolygon;
                    end;
                end;
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

(*
function TALSablon.LoadFromDXF(const FileName: string): Boolean;
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

     newFileName:=FileName;

  try
  {$I-}
    AssignFile(f,NewFileName);
    system.Reset(f);
  {$I+}
    try
      ReadLn(f,sor);
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
               N:=MakeCurve('Arc',-1,dmArc,True,True,False);
               AddPoint(N,arcPPP.p1.x,arcPPP.p1.y);
               AddPoint(N,arcPPP.p2.x,arcPPP.p2.y);
               AddPoint(N,arcPPP.p3.x,arcPPP.p3.y);

               goto 111;
            end;

            SPLINE :
            begin
                Closed := False;
                N:=MakeCurve('Spline',-1,dmSpline,True,True,Closed);
            end;
            end;

            Repeat
                ReadLn(f,sor);
                if ((DXFSec=SPLINE) or (DXFSec=LINE)) and (sor='  0') then
                   break;
                sor := Copy(sor,Length(sor)-2,Length(sor));
                If (sor=' 71') then begin
                    ReadLn(f,sor); i:=StrToInt(sor);
                    case i of
                    1,3: // Nem megy át a támpontokon
                       Curves[N].Shape := dmBSpline;
                    2: // átmegy a támpontokon
                       Curves[N].Shape := dmSpline;
                    end;
                end;
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
            until (sor='SEQEND') or (sor='ENDSEC') or (sor='  0') or EOF(f);
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
*)

// Load G-KOD file
procedure TALSablon.LoadFromGKOD(Filename: STRING);
var f     : TEXTFILE;
    sor,S : string;
    Numbered: boolean;
begin
(*
Try
  Loading := True;
  AssignFile(f,FileName);
  system.Reset(f);
  // Üres és komment sorok átugrása
  repeat
        ReadLn(f,sor);
        s := Copy(LTrim(sor),1,1);
  until ((s<>'') and (s<>'('));

  numbered := (s='N');

  repeat
        if numbered then
           s := Szo(sor,2)
        else
           s := Szo(sor,1);
        case s of
        G00: begin

             end;
        G01: begin

             end;
        end;
        ReadLn(f,sor);
  Until EOF(f);
finally
  CloseFile(f);
  Loading := False;
End;
*)
end;

function TALSablon.LoadFromPLT(const FileName: string): Boolean;
var f     : TEXTFILE;
    sor,S : string;
    N,i,pv,vpoz  : integer;
    x,y   : double;
    KOD   : string;
    xx,yy : string;
    FirstPoint,EndPoint : TPoint;
    elso  : boolean;
    delim : string;
begin
Try
  Loading := True;
  AssignFile(f,FileName);
  system.Reset(f);
  ReadLn(f,sor);
  repeat
    ReadLn(f,sor);
    pv := StrCount(sor,';');

    if pv>0 then
       for I := 1 to pv do
       begin
         s := StrCountD(sor,';',i);
         KOD := UpperCase(Copy(s,1,2));
         if (KOD='PU') or (KOD='PD') then
         begin
           if (KOD='PU') then begin
              N:=MakeCurve('Object',-1,dmPolygon,True,True,True);
              FCurve := Curves[N];
              elso := true;
           end;
           // Pontok kinyerése
           S := Copy(s,3,Length(s));
           delim := ' ';
           if Pos(',',s)>0 then
              delim := ',';
           xx := StrCountD(s,delim,1);
           yy := StrCountD(s,delim,2);
             Try
                x := strtoFloat(xx)/39.37;
                y := strtoFloat(yy)/39.37;
             finally
                If elso then begin
                   FirstPoint.x := StrToInt(xx);
                   FirstPoint.y := StrToInt(yy);
                   elso := False;
                end;
                FCurve.AddPoint(x,y);
                EndPoint.x := StrToInt(xx);
                EndPoint.y := StrToInt(yy);
             end;
         end;
       end;

      if Curves[N]<>nil then begin
        Curves[N].Closed := (Abs(FirstPoint.x-EndPoint.x)<0.5) and (Abs(FirstPoint.y-EndPoint.y)<0.5);
        if Curves[N].Closed then Curves[N].Shape:=dmPolygon else Curves[N].Shape:=dmPolyline;
      end;

  Until EOF(f);
Finally
  CloseFile(f);
  Loading := False;
  Paint;
End;
end;

// SVG file loader
function TALSablon.LoadFromSVG(Filename: STRING): boolean;
var SVGL : TAL_SVGLoader;
  n: integer;
  i,j,k: Integer;
  o: TSVGRecord;
  h: Integer;
  R: TRect2d;
  absoluteCoord: boolean;
  StartCoord : TPoint2d;
begin
Try
  SVGL := TAL_SVGLoader.Create;
  if FileExists(Filename) then
  BEGIN
    SVGL.FileName := Filename;
    n := SVGL.Capacity;
    for i := 0 to Pred(n) do
    begin
        o := SVGL.Objects[i];

        case o.ObjType of
        0: // line
           h := MakeCurve('SVGPolyline',-1,dmPolyline,true,true,false);
        1: // polygon
           h := MakeCurve('SVGPolygon',-1,dmPolygon,true,true,true);
        2: // polyline
           h := MakeCurve('SVGPolyline',-1,dmPolyline,true,true,false);
        3: // rect
           h := MakeCurve('SVGRectangle',-1,dmRectangle,true,true,true);
        4: // circle
           h := MakeCurve('SVGCircle',-1,dmCircle,true,true,true);
        5: // ellipse
           h := MakeCurve('SVGEllipse',-1,dmEllipse,true,true,true);
        end;


      n:= High(o.Points);
      for j := 0 to n do
      begin
        case o.ObjType of
        0: // line
        begin
           AddPoint(h,o.Points[0].x,o.Points[0].y);
           AddPoint(h,o.Points[1].x,o.Points[1].y);
        end;
        1: // polygon
        for k:=0 to High(o.Points) do begin
           AddPoint(h,o.Points[j].x,o.Points[j].y);
        end;
        2: // polyline
        for k:=0 to High(o.Points) do begin
           AddPoint(h,o.Points[j].x,o.Points[j].y);
        end;
        3: // rect
        begin
           AddPoint(h,o.Points[0].x,o.Points[0].y);
           AddPoint(h,o.Points[0].x+o.w,o.Points[0].y);
           AddPoint(h,o.Points[0].x+o.w,o.Points[0].y+o.h);
           AddPoint(h,o.Points[0].x,o.Points[0].y+o.h);
        end;
        4: // circle
        begin
           AddPoint(h,o.Points[0].x,o.Points[0].y);
           AddPoint(h,o.Points[0].x+o.r,o.Points[0].y+o.r);
        end;
        5: // ellipse
        begin
           AddPoint(h,o.Points[0].x,o.Points[0].y);
           AddPoint(h,o.Points[1].x+o.w,o.Points[1].y+o.h);
        end;
        6: // path
        begin

           if UpperCase(o.Points[j].PointType)='M' then begin
              StartCoord := Point2d( 0,0 );
              if UpperCase(o.Points[j+1].PointType)='Q' then
                 h := MakeCurve('SVGBezier',-1,dmCubicBezier,true,true,false);
              if UpperCase(o.Points[j+1].PointType)='L' then
                 h := MakeCurve('SVGPolyline',-1,dmPolygon,true,true,true);
              if UpperCase(o.Points[j+1].PointType)='C' then
              h := MakeCurve('SVGBezier',-1,dmCubicBezier,true,true,false);
//                h := MakeCurve('SVGSpline',-1,dmSpline,true,true,true);
              Curves[h].Selected := True;
           end;

           AddPoint(h,o.Points[j].x,o.Points[j].y);

        end; // path
        end;
      end;

      Curves[h].Selected := True;
      if (Curves[h].Points[0].X=Curves[h].Points[Curves[h].Count-1].x)
         and (Curves[h].Points[0].y=Curves[h].Points[Curves[h].Count-1].y)
      then
      begin
//         Curves[h].Shape := dmPolygon;
         Curves[h].Closed := True;
         Curves[h].DeletePoint(Curves[h].Count-1);
      end;

    end;
    R := GetDrawExtension;
    MirrorSeledted(false,true);
    SelectAll(False);
  END;
Finally
  SVGL.Free;
End;
end;

function TALSablon.LoadFromTXT(Filename: STRING): boolean;
begin

end;

(*
function TALSablon.LoadFromSVG(Filename: STRING): boolean;
var SVGText: string;
    tst: TStringList;
    D: Textfile;
    fn,s: string;
begin
  Result := False;
  Loading := True;
    fn := ChangeFileExt(Filename,'.svg');
    if FileExists(fn) then
    begin
      tst := TStringList.Create;
      tst.LoadFromFile(fn);
      s := tst.Text;
      tst.Free;
      SetSVGText(s);
    end;
    Loading := False;
    Result := True;
  Result := True;
  Loading := False;

end;

// SVG leíró szöveget objektumokká konvertálja
procedure TALSablon.SetSVGText( SVGText: string );
var n1,n2,p1,p2: integer;
    s,sz: string;
    i,j,k: Integer;
    shape : TDrawMode;
    shapeName : string;
    idPos: integer;
    pointPos: integer;
    pointCount : integer;
    point1,point2: integer;
    sx,sy: string;
    x,y: double;
    Cuv: TCurve;

    function IsInDrawModeText(ss: string): TDrawMode;
    var jj: integer;
    begin
      Result := dmNone;
      for jj := 0 to High(DrawModeText) do
          if lower(ss)=lower(DrawModeText[jj]) then
          begin
            Result := TDrawMode(jj);
            if ss='rect' then Result := dmRectangle;
            exit;
          end;
    end;

    function GetPoiintsStr(s,key: string): string;
    var jj: integer;
    begin
      Result := '';
      pointPos := Pos( key, s);
      if pointPos>0 then
      for jj:=pointPos+Length(key)+1 to Length(s) do
      begin
        if s[jj]='"' then
           Break
        else
           Result := Result + s[jj];
      end;
    end;

begin
  n1 := StrCount( SVGText,'<');
  n2 := StrCount( SVGText,'>');
  for i := 1 to n1 do
  begin
    p1 := CountPos( SVGText,'<',i );
    p2 := CountPos( SVGText,'>',i );
    s := Lower(Copy( SVGText, p1+1, p2-1 ));
    sz := Szo(s,1);

    shape := IsInDrawModeText(sz);
    if shape<>dmNone then
    begin
      idPos := Pos( ' id=', s);
      k := 2;
      if idPos>0 then
         while sz<>'' do begin
            sz := Szo(s,k);
            if Copy(sz,1,3)='id=' then
            begin
               // Objektum nevének kinyerése
               shapeName := StrCountD( sz,'"',2);
               break;
            end;
            Inc(k);
         end;
    end else
        shapeName := '';

    if Shape<>dmNone then
       H := MakeCurve(shapeName,-1,shape,true,true,true);

    // Pontok kigyüjtése
    Case shape of

    dmPolyline,dmPolygon:
      begin
        Curves[H].Closed := shape=dmPolygon;
        s := Trim(GetPoiintsStr(s,' points='));
        while StrCount(s,EoLn)>0 do
              s:=DelSub(s,EoLn);
        k := StrCount(s,EoLn);
        if s<>'' then
           pointCount := StrCount(s,',');
        while s<>'' do
        begin
             s  := Trim(s);
             sz := Szo(s,1);
             if sz[1]=',' then sz := '0'+sz;
             s  := Copy(s,Length(sz)+1,10000);
             sx := StrCountD(sz,',',1);
             sy := StrCountD(sz,',',2);
             x  := StrToFloat(sx);
             y  := StrToFloat(sy);
             Curves[H].AddPoint(x,y);
        end;
      end;

      dmRectangle:
      begin
        s := Trim(GetPoiintsStr(s,' d='));
        while StrCount(s,EoLn)>0 do
              s:=DelSub(s,EoLn);
        k := StrCount(s,EoLn);
      end;

      dmPath:
      begin
        s := Trim(GetPoiintsStr(s,' d='));
        while StrCount(s,EoLn)>0 do
              s:=DelSub(s,EoLn);
        k := StrCount(s,EoLn);
      end;

    End;
  end;
  MirrorVertical;
  Normalisation(True);
end;
*)
function TALSablon.GetSVGText: STRING;
var BR : TRect2d;
    w,h: integer;
    I,N: Integer;
    xx,yy: TFloat;
    s,s0: string;
    dat: string;
BEGIN
Try
  Result := '';
  BR := GetDrawExtension;
  w := Trunc(BR.x2-BR.x1+1);
  h := Trunc(BR.y2-BR.y1+1);
  // Fejléc az SVG fájlhoz
  s := '<!-- Generator: StyCut Version: 1.0 -->'+EoLn+
       '<svg version="1.1" id="Layer_1" '+ EoLn+
       ' xmlns="http://www.w3.org/2000/svg" '+ EoLn+
       ' xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" '+ EoLn+
       ' viewBox="0 0 300 300" style="enable-background:new 0 0 300 300;" xml:space="preserve">' +EoLn+EoLn;
  s := s+'<g>'+EoLn;

    for i:=0 to Pred(FCurveList.Count) do begin
        FCurve:=FCurveList.Items[I];

        s0 := '<'+Lower( DrawModeText[Ord(FCurve.Shape)] )+' ';

        s := s + s0 + ' Id="'+FCurve.Name+'" points="';

      dat := '';
      for N:=0 to Pred(FCurve.FPoints.Count) do begin
        FCurve.GetPoint(N,xx,yy);
        yy := BR.y2-yy+1;
        dat := dat + Trim(FormatFloat('####.##',xx))+','+Trim(FormatFloat('####.##',yy))+' ';
      end;
      if FCurve.Closed then
         s := s + dat +'" style="fill:none;stroke:black;stroke-width:2" />'+EoLn+EoLn
      else
         s := s + dat +'" style="fill:none;stroke:silver;stroke-width:1" />'+EoLn+EoLn;

    end;

  s := s + '</g>'+EoLn+'</svg>' +EoLn;
Finally
  Result := s;
End;
END;

function TALSablon.SaveToSVG(Filename: STRING): boolean;
var D: Textfile;
    fn,s: string;
begin
  Result := False;
  Loading := True;
    s := GetSVGText;
    fn := ChangeFileExt(Filename,'.svg');
    AssignFile(D,FN);
        Rewrite(D);
        WriteLn(D,s);
    CloseFile(D);
    Loading := False;
    Result := True;
  Result := True;
  Loading := False;
END;


{------------------------------------------------------------------------------}

function TALSablon.LoadCurveFromFile(const FileName: string): Boolean;
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

procedure TALSablon.SetDefaultLayer(const Value: Byte);
begin
  fDefaultLayer := Value;
  invalidate;
end;

procedure TALSablon.SetDesigneMode(const Value: boolean);
begin
  FDesigneMode := Value;
  if not Value then
     DrawMode := dmNone;
  invalidate;
end;

procedure TALSablon.SetActionMode(const Value: TActionMode);
begin
  oldActionMode := fActionMode;
  DrawMode    := dmNone;
  fActionMode := Value;
  pFazis      := 0;
  Case Value of
  amNone           :
  begin
       Cursor := crDefault;
       SignedAll(False);
  end;
  amInsertPoint    : Cursor := crInsertPoint;
  amDeletePoint    : Cursor := crDeletePoint;
  amNewBeginPoint  : Cursor := crNewBeginPoint;
  amRotateSelected : Cursor := crRotateSelected;
  amSelectFrame    :
     begin
          Cursor := crCross;
//          SelectedFrame.Visible := True;
     end;
  amManualOrder:
     begin
          Cursor := crUpArrow;
          ShowPoints := False;
          PoligonizeAll(0);
          StripAll1;
          SignedAll(False);
     end;
  end;

  Case oldActionMode of
  amManualOrder:
     begin
//       VektorisationAll(0.05);
     end;
  End;

  if Assigned(fChangeMode) then fChangeMode(Self,Value,DrawMode);
end;

procedure TALSablon.InsertPoint(AIndex,APosition: Integer; X,Y: TFloat);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    FCurve.InsertPoint(APosition,X,Y);
    Selected := FCurve;
    Changed := True;
  end;
end;

procedure TALSablon.InsertPoint(AIndex,APosition: Integer; P: TPoint2d);
begin InsertPoint(AIndex,APosition,P.X,P.Y); end;

procedure TAlSablon.ChangePoint(AIndex, APosition: Integer; X,Y: TFloat);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    if APosition < FCurve.FPoints.Count then FCurve.ChangePoint(APosition,X,Y);
    Selected := FCurve;
    Changed := True;
  end;
end;

// Change the Shape property of the Selected Objects
procedure TALSablon.ChangeSelectedShape(newShape: TDrawMode);
var i: integer;
begin
  UndoSave;
  if (SelectedCount=0) and (Selected<>nil) then
  begin
     Selected.Shape := newShape;
     Selected.Closed := newShape in [dmPolygon];
  end
  else
  for i:=0 to Pred(FCurveList.Count) do
  begin
      if Curves[i].Selected then
         Curves[i].Shape := newShape;
      Curves[i].Closed := newShape in [dmPolygon];
  end;
  if not MouseOn then
  if Assigned(FChangeAll) then FChangeAll(Self);
  Invalidate;
  UndoSave;
end;

procedure TALSablon.MoveCurve(AIndex :integer; Ax, Ay: TFloat);
var i: integer;
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then begin
      FCurve:=FCurveList.Items[AIndex];
      FCurve.MoveCurve(Ax/Zoom, Ay/Zoom);
      Selected := FCurve;
      Changed := True;
  end;
  RePaint;
end;

procedure TALSablon.MoveSelectedCurves(Ax, Ay: TFloat);
var i: integer;
begin
  for i:=0 to Pred(FCurveList.Count) do begin
      FCurve:=FCurveList.Items[i];
      if FCurve.Selected then FCurve.MoveCurve(Ax/Zoom, Ay/Zoom)
      else
      if ShowPoints then
         FCurve.MoveSelectedPoints(Ax/Zoom, Ay/Zoom);
  end;
  Changed := True;
  RePaint;
end;

procedure TALSablon.RotateSelectedCurves(Cent : TPoint2d; Angle: TFloat);
var i: integer;
begin
  for i:=0 to Pred(FCurveList.Count) do begin
      FCurve:=FCurveList.Items[i];
      if FCurve.Selected then FCurve.RotateCurve(Cent, Angle);
  end;
  Changed := True;
  RePaint;
end;

procedure TALSablon.SetLocked(const Value: boolean);
var i: integer;
begin
  fLocked := Value;
  UR.Enable := not Value;
  for i:=0 to Pred(FCurveList.Count) do begin
      FCurve:=FCurveList.Items[i];
      FCurve.Enabled := not Value;
  end;
  DrawMode := dmNone;
  RePaint;
end;

// A p ponthoz legközelebbi alakzat legközelebbi pontja
// lesz az új kezdõpont
procedure TALSablon.SetNearestBeginPoint(p: TPoint2d);
var CuvIdx,NodeIdx: integer;
begin
  if GetNearestPoint( p,CuvIdx,NodeIdx )>-1 then
     SetBeginPoint( CuvIdx,NodeIdx );
end;

procedure TALSablon.SetpClosed(const Value: TPen);
begin
  fpClosed := Value;
  invalidate;
end;

procedure TALSablon.SetpCrossed(const Value: TPen);
begin
  fpCrossed := Value;
  invalidate;
end;

procedure TALSablon.SetpFazis(const Value: integer);
begin
  fpFazis := Value;
  Invalidate;
end;

procedure TALSablon.SetPointWhdth(const Value: integer);
begin
  fPointWhdth := Value;
  invalidate;
end;

procedure TALSablon.SetpOpened(const Value: TPen);
begin
  fpOpened := Value;
  invalidate;
end;

procedure TALSablon.SetpSelected(const Value: TPen);
begin
  fpSelected := Value;
  invalidate;
end;

procedure TALSablon.SetpSigned(const Value: TPen);
begin
  fpSigned := Value;
  invalidate;
end;

procedure TALSablon.SetpSorted(const Value: TPen);
begin
  fpSorted := Value;
  invalidate;
end;

function TALSablon.IsRectInWindow(R: TRect2d): boolean;
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

// Selected nyílt objektumokat összefûzi egy zárt alakzattá
procedure TALSablon.JoinSelected;
var i,n: integer;
    Cuv: TCurve;
    selArray: array of integer;
    NextIdx  : integer;

    function InitSelArray: integer;
    var ii,jj: integer;
    begin
       jj := 0;
       SetLength(selArray,GetSelectedCount);
       for ii:=0 to Pred(FCurveList.Count) do begin
         if Curves[ii].Selected {and (Curves[ii].shape in [dmLine,dmPolyLine])} then
         begin
           selArray[jj] := ii;
           Inc(jj);
         end;
       end;
       Result := jj;
    end;


    (* Megvizsgálja, hogy melyik a legközelebbi selected polyline, ami nem
       signed, és megnézi, hogy az eleje vagy a vége van-e közelebb.
       Felfûzi a Cuv zárt objektumra
    *)
    function AppendNearestSelectedLine: boolean;
    var ii,jj: integer;
        d,d1,d2 : double;
        idx  : integer;
        elore: boolean;
        pv   : TPoint2d;
        p0,p1: TPoint2d;
    begin
      Result := true;
      idx := -1; elore := true;
      d := MaxDouble;
      for II := 0 to High(selArray) do
      begin
        if selArray[ii]>-1 then
        begin
          pv := Cuv.Points[Cuv.Count-1];
          p0 := Curves[selArray[ii]].Points[0];
          p1 := Curves[selArray[ii]].Points[Curves[selArray[ii]].Count-1];
          d1 := RelDist2d(pv,p0);
          d2 := RelDist2d(pv,p1);
          if RelDist2d(pv,p0)<d then
          begin
            d := RelDist2d(pv,p0);
            idx := ii;
            elore := true;
          end;
          if RelDist2d(pv,p1)<d then
          begin
            d := RelDist2d(pv,p1);
            idx := ii;
            elore := false;
          end;
        end;
      end;

        if idx>-1 then
        begin
           if not elore then
              Curves[selArray[idx]].InversPointOrder;
           for jj := 0 to Pred(Curves[selArray[idx]].Count) do
               Cuv.AddPoint(Curves[selArray[idx]].Points[jj]);
           selArray[idx] := -1;
           Result := False;
        end;

    end;

begin
if GetSelectedCount>1 then
Try
  PoligonizeAllSelected(0);
  n := InitSelArray;
  Cuv := Tcurve.Create;
  Cuv := Curves[selArray[0]];
  selArray[0]  := -1;
  Cuv.Shape    := dmPolygon;
  Cuv.Closed   := True;
  Cuv.Selected := False;

  While not AppendNearestSelectedLine do;

Finally
//  AddCurve(Cuv);
  SetLength(selArray,0);
  DeleteSelectedCurves;
  Changed := True;
  RePaint;
End;
end;

(*
procedure TALSablon.KeyDown(var Key: Word; Shift: TShiftState);
var dx,dy: integer;
    k:integer;
begin
  k:=16;
  dx := 0; dy:=0;
  case Key of
    VK_LEFT    : dx:=k;
    VK_RIGHT   : dx:=-k;
    VK_UP      : dy:=-k;
    VK_DOWN    : dy:=k;
  end;
  if (dx<>0) or (dy<>0) then MoveWindow(dx,dy);
  inherited;
end;
*)

// Tru if point in screen window
function TALSablon.IsPointInWindow(p: TPoint2d): boolean;
begin
   Result := PontInKep(XToS(p.x),YToS(p.y),Window);
end;

// True: if paper visible and part of paper is in window
function TALSablon.IsPaperInWindow: boolean;
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
procedure TALSablon.DeleteSelectedCurves;
var i,j: integer;
begin
  i:=0;
  if FCurveList.Count>0 then begin
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
  if Assigned(FChangeAll) then FChangeAll(Self);
  end;
  RePaint;
end;

procedure TALSablon.DeleteInvisibleCurves;
var i,j: integer;
begin
  i:=0;
  if FCurveList.Count>0 then begin
  While i<FCurveList.Count do begin
      FCurve:=FCurveList.Items[i];
      if not FCurve.Visible then begin
         DeleteCurve(i);
         Dec(i);
         Changed := True;
      end;
      Inc(i);
  end;
  if AutoUndo then UndoSave;
  end;
//  RePaint;
end;

// A 0 pontot tartalmazó alakzatok törlése
procedure TALSablon.DeleteEmptyCurves;
var i: integer;
begin
  for i:=Pred(FCurveList.Count) downto 0 do
  begin
      FCurve:=FCurveList.Items[i];
      if FCurve.Count=0 then begin
         DeleteCurve(i);
         Changed := True;
      end;
  end;
  if (Changed and AutoUndo) then UndoSave;
  RePaint;
end;


procedure TALSablon.InversSelectedCurves;
var i: integer;
begin
  loading := true;
  for i:=0 to Pred(FCurveList.Count) do begin
      FCurve:=FCurveList.Items[i];
      FCurve.Selected := not FCurve.Selected;
  end;
  loading := false;
  Invalidate;
end;

procedure TALSablon.SetSablonSzinkron(const Value: boolean);
begin
  FSablonSzinkron := Value;
  if Value then CentralCross := True;
end;

procedure TALSablon.SetSelected(const Value: TCurve);
begin
  if not loading then begin
     fSelected := Value;
     fCurve := Value;
     if Value<>nil then
        GetCurveHandle(Value.Name,fSelectedIndex)
     else
        SelectedIndex:=-1;
     invalidate;
     if Assigned(fChangeSelected) then fChangeSelected(Self,fSelected,CPIndex);
  end;
end;

procedure TALSablon.Eltolas(dx,dy: double);
var n,i,j: integer;
    x,y: double;
begin
   For n:=0 to FCurveList.Count-1 do begin
      FCurve:=FCurveList.Items[n];
      J:=Pred(FCurve.FPoints.Count);
      FCurve.MoveCurve(dx,dy);
      Changed := True;
   end;
  if AutoUndo then UndoSave;
  Paint;
end;

procedure TALSablon.Nyujtas(tenyezo: double);
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
        FCurve.ChangePoint(i,x,y);
        Changed := True;
      end;
      end;
   end;
  if AutoUndo then UndoSave;
  Paint;
end;

// Magnify from centrum
procedure TALSablon.CentralisNyujtas(Cent: TPoint2d; tenyezo: double);
var n,i,j: integer;
    x,y: double;
begin
   For n:=0 to FCurveList.Count-1 do begin
      FCurve:=FCurveList.Items[n];
      If FCurve.Enabled then
         FCurve.MagnifyCurve(Cent, tenyezo);
   end;
  Changed := True;
  if AutoUndo then UndoSave;
  Paint;
end;

function TALSablon.SaveCurveToStream(FileStream: TStream; Item: Integer): Boolean;
var
  CurveData: TCurveData;
  NewCurveData: TNewCurveData;
  pp : ppoint;
  p : TPointRec;
  N: Integer;
begin
  Result:=False;
  if not InRange(Item,0,Pred(FCurveList.Count)) or not Assigned(FileStream) then Exit;
  FCurve:=FCurveList.Items[Item];
  try
    if oldFile then begin
        CurveData := FCurve.GetoldCurveData;
        FileStream.Write(CurveData,SizeOf(TCurveData));
    end else begin
        NewCurveData := FCurve.GetCurveData;
        FileStream.Write(NewCurveData,SizeOf(TNewCurveData));
    end;

    for N:=0 to Pred(FCurve.Count) do begin
      p := FCurve.PointRec[N];
      FileStream.Write(p.x,SizeOf(TFloat));
      FileStream.Write(p.y,SizeOf(TFloat));
    end;

    Result:=True;
  except
    ShowMessage('Error writing stream!');
  end;
end;

{------------------------------------------------------------------------------}

function TALSablon.LoadCurveFromStream(FileStream: TStream): Boolean;
var
  CurveData: TNewCurveData;
  oldCurveData: TCurveData;
  oShape      : TDrawMode;
  PointRec: TPointRec;
  H,N,P: Integer;
  XOfs: TFloat;
  YOfs: TFloat;
begin
  Result:=False;
  if not Assigned(FileStream) then Exit;
  try
    if oldFile then begin
       FileStream.Read(oldCurveData,SizeOf(TCurveData));
       if oldCurveData.Closed then oShape:=dmPolygon else oShape:=dmPolyline;
       P := oldCurveData.Points-1;
       H:=MakeCurve(oldCurveData.Name,-1,oShape,oldCurveData.Enabled,True,oldCurveData.Closed);
       XOfs:=oldCurveData.XOfs;
       YOfs:=oldCurveData.YOfs;
    end else begin
       FileStream.Read(CurveData,SizeOf(TNewCurveData));
       P := CurveData.Points-1;
       H:=MakeCurve(CurveData.Name,-1,CurveData.Shape,CurveData.Enabled,CurveData.Visible,CurveData.Closed);
       XOfs:=0;
       YOfs:=0;
    end;
       FCurve := FCurvelist.Items[H];
       FCurve.Selected := False;

    for N:=0 to P do
    begin
      if FileStream.Read(PointRec.x,SizeOf(TFloat))<SizeOf(TFloat) then
         Exit;
      if FileStream.Read(PointRec.y,SizeOf(TFloat))<SizeOf(TFloat) then
         Exit;
      AddPoint(H,PointRec.x+XOfs,PointRec.y+YOfs);
    end;

    Result:=True;
  except
    ShowMessage('Error reading stream!');
  end;
end;

function TAlSablon.SaveGraphToFile(const FileName: string): Boolean;
var
  FileStream: TFileStream;
  GraphData: TGraphData;
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
      if Ext = '.SB' then begin
         GraphData.GraphTitle:=FGraphTitle;
         GraphData.Curves:=FCurveList.Count;
         FileStream.Write(GraphData,SizeOf(GraphData));
         oldFile := True;
      end;
      if Ext = '.SBN' then begin
         NewGraphData.Copyright := 'StellaFactory Obelisc Sablon Ver 1';
         NewGraphData.Version   := 1;
         NewGraphData.GraphTitle:=FGraphTitle;
         NewGraphData.Curves:=FCurveList.Count;
         FileStream.Write(NewGraphData,SizeOf(NewGraphData));
         oldFile := False;
      end;

      for N:=0 to Pred(FCurveList.Count) do
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

function TAlSablon.LoadGraphFromFile(const FileName: string): Boolean;
var
  FileStream: TFileStream;
  GraphData: TNewGraphData;
  N: Integer;
  au: boolean;
  ext: string;
begin
  Result  := False;
  oldFile := False;
  if not FileExists(FileName) then Exit;
  try
    au := AutoUndo;
    AutoUndo := False;
    Loading := True;
    ext := UpperCase(ExtractFileExt(FileName));

    if Ext='.SBN' then begin
    FileStream:=TFileStream.Create(FileName,fmOpenRead);
    try
      Try
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
      finally
             FileStream.Free;
             Result:=True;
      end;
    except
      if FileStream<>nil then FileStream.Free;
      Result:=False;
    end;
    end;

    If ext = '.SB' then
       LoadOldGraphFromFile(Filename);
    if ext = '.PLT' then
       LoadFromPLT(Filename);
    if ext = '.DXF' then
       LoadFromDXF(Filename);
    if ext = '.SVG' then
       LoadFromSVG(Filename);
    if StrSearch('.EIA.NC.TXT',ext)>0 then
       LoadFromGKOD(Filename);

  finally
    DeleteEmptyCurves;
    Repaint;
    AutoUndo := au;
    Loading := False;
    If AutoUndo then UndoSave;
    if Assigned(FChangeAll) then FChangeAll(Self);
  end;
end;

function TALSablon.LoadOldGraphFromFile(const FileName: string): Boolean;
var
  FileStream: TFileStream;
  GraphData: TGraphData;
  N: Integer;
  au: boolean;
begin
  Result:=False;
  if FileExists(FileName) then
  try
    oldFile := True;
    au := AutoUndo;
    AutoUndo := False;
    Loading := True;
    FileStream:=TFileStream.Create(FileName,fmOpenRead);
    try
      FileStream.Position:=0;
      FileStream.Read(GraphData,SizeOf(GraphData));

      for N:=0 to Pred(GraphData.Curves) do
          if not LoadCurveFromStream(FileStream) then
          begin
             FileStream.Free;
             Clear;
             Exit;
          end;

    except
      Result:=False;
    end;
  finally
    Result:=True;
    FileStream.Free;
    oldFile := False;
    Repaint;
    AutoUndo := au;
    If AutoUndo then UndoSave;
    Loading := False;
  end;
end;

procedure TALSablon.SaveGraphToMemoryStream(var stm: TMemoryStream);
var
  GraphData: TNewGraphData;
  N: Integer;
begin
    try
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

procedure TALSablon.LoadGraphFromMemoryStream(stm: TMemoryStream);
var
  GraphData: TNewGraphData;
  N: Integer;
begin
  if stm=nil then Exit;
  try
      Loading := True;
      stm.Seek(0,0);
      stm.Read(GraphData,SizeOf(GraphData));
      FGraphTitle:=GraphData.GraphTitle;

      for N:=0 to Pred(GraphData.Curves) do begin
          LoadCurveFromStream(stm);
//          TCurve(FCurveList.Items[FCurveList.Count-1]).Selected := True;
      end;
  except
      exit;
  end;
  Loading := False;
  Paint;
end;

function TALSablon.SaveGraph3dToFile(const FileName: string): Boolean;
var
  FileStream: TFileStream;
  N: Integer;
begin
  Result:=False;
  try
      FileStream:=TFileStream.Create(FileName,fmCreate);
      for N:=0 to Pred(FCurveList.Count) do
          FileStream.Write(Curves[N].Trans3d ,SizeOf(TPointRec3d));
//          SaveCurve3dToStream(FileStream,N);
      Result:=True;
  except
      Result:=False;
  end;
  FileStream.Free;
end;

function TALSablon.LoadGraph3dFromFile(const FileName: string): Boolean;
var
  FileStream: TFileStream;
  N: Integer;
begin
  Result:=False;
  if FileExists(FileName) then
  try
      FileStream:=TFileStream.Create(FileName,fmOpenRead);
      for N:=0 to Pred(FCurveList.Count) do
          FileStream.Read(Curves[N].Trans3d ,SizeOf(TPointRec3d));
      FileStream.Free;
      Result:=True;
  except
      Result:=False;
  end;
end;


// Kimenti egy objektum 3d paramétereit
function TALSablon.SaveCurve3dToStream(FileStream: TStream; Item: Integer): Boolean;
begin
  Result:=False;
  if not InRange(Item,0,Pred(FCurveList.Count)) or not Assigned(FileStream) then Exit;
     FileStream.Write(Curves[item].Trans3d ,SizeOf(TPointRec3d));
  Result:=True;
end;

// Az objektumokat eltávolítja egymástól,
// de a méretüket nem módosítja
procedure TALSablon.Lazitas(coeff: TFloat);
var H: integer;
    dx,dy: TFloat;
    basePoint : TPoint2d;
begin
  for H:=0 to Pred(FCurveList.Count) do
  begin
    FCurve:=Curves[H];
    basePoint := FCurve.Points[0];
    dx := (coeff - 1) * basePoint.x;
    dy := (coeff - 1) * basePoint.y;
    FCurve.MoveCurve(dx,dy);
  end;
  Repaint;
end;

procedure TALSablon.LButtonDblClick(var Message: TMessage);
begin
  // Double click for select curves
  if SelectedIndex>-1 then
  begin
     FCurve := Curves[SelectedIndex];
     if FCurve<>nil then
     begin
       FCurve.Selected := not FCurve.Selected;
       if Assigned(fChangeSelected) then fChangeSelected(Self,FCurve,CPIndex);
     end;
  end;
end;

function TALSablon.LoadCurve3dFromStream(FileStream: TStream; Item: Integer): Boolean;
begin
  Result:=False;
  if not InRange(Item,0,Pred(FCurveList.Count)) or not Assigned(FileStream) then Exit;
     FileStream.Write(Curves[item].Trans3d ,SizeOf(TPointRec3d));
  Result:=True;
end;

procedure TALSablon.DXFCurves;
var
  H,I,J: Integer;
  X,Y: TFloat;
  FCurve: TCurve;
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

function TALSablon.SaveToDXF(const FileName: string):boolean;
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

PROCEDURE TALSablon.LoadFromDAT(Filename: STRING);
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

function TALSablon.SaveToDAT(Filename: STRING):boolean;
var D: Textfile;
    r: TRect2d;
    szorzo: double;
    dx,dy: double;
    H,I,N: Integer;
    xx,yy: TFloat;
    s,s0: string;
    FCurve : TCurve;
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

function TALSablon.SaveToTXT(Filename: STRING):boolean;
var D: Textfile;
    I,N: Integer;
    xx,yy: TFloat;
    s,s0: string;
BEGIN
Try
  Result := False;
  Loading := True;
  AssignFile(D,Filename);
    Rewrite(D);
    for i:=0 to Pred(FCurveList.Count) do begin
      FCurve:=FCurveList.Items[I];
      WriteLn(D,'['+FCurve.Name+']');
      WriteLn(D,'Type='+DrawModeText[Ord(FCurve.Shape)]);
    for N:=0 to Pred(FCurve.FPoints.Count) do begin
      FCurve.GetPoint(N,xx,yy);
      s := IntToStr(N)+'='+Ltrim(format('%6.2f',[xx]))+','+LTrim(format('%6.2f',[yy]));
      WriteLn(D,s);
      if N=0 then s0 := s;               // Save 0. point
    end;
  end;
FINALLY
      if FCurve.Closed then
         WriteLn(D,s0);
    CloseFile(D);
    Loading := False;
    Result := True;
END;
END;

function TALSablon.SaveToCNC(Filename: STRING):boolean;
var D: Textfile;
    I,N: Integer;
    xx,yy: TFloat;
    s,s0: string;
    Num: integer;
BEGIN
Try
  Result := False;
  Loading := True;
  Num := 10;
  AssignFile(D,Filename);
    Rewrite(D);
  for i:=0 to Pred(FCurveList.Count) do begin
      FCurve:=FCurveList.Items[I];
      WriteLn(D,'['+FCurve.Name+']');
      WriteLn(D,'Type='+DrawModeText[Ord(FCurve.Shape)]);
    for N:=0 to Pred(FCurve.FPoints.Count) do begin
      FCurve.GetPoint(N,xx,yy);
      s := 'N'+ZeroNum(Num,4)+' X'+Ltrim(format('%6.2f',[xx]))+'Y'+LTrim(format('%6.2f',[yy]));
      WriteLn(D,s);
      Inc(Num,10);
    end;
      if FCurve.Closed then begin
         FCurve.GetPoint(0,xx,yy);
         s := 'N'+ZeroNum(Num,4)+' X'+Ltrim(format('%6.2f',[xx]))+'Y'+LTrim(format('%6.2f',[yy]));
         WriteLn(D,s);
      end;
  end;
FINALLY
    CloseFile(D);
    Loading := False;
    Result := True;
END;
END;

procedure TALSablon.SetGraphTitle(const Value: Str32);
begin
  FGraphTitle := Value;
  invalidate;
end;

procedure TALSablon.CopySelectedToVirtClipboard;
var i: integer;
    Cuv: TCurve;
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

procedure TALSablon.CutSelectedToVirtClipboard;
begin
  CopySelectedToVirtClipboard;
  DeleteSelectedCurves;
  If AutoUndo then UndoSave;
  Changed := True;
  Invalidate;
end;

procedure TALSablon.PasteSelectedFromVirtClipboard;
begin
IF VirtualClipboard.Size>0 then begin
  LoadGraphFromMemoryStream(VirtualClipboard);
  If AutoUndo then UndoSave;
  Changed := True;
  Invalidate;
end;
end;

function  TALSablon.GetDrawExtension: TRect2d;
var n    : integer;
    x,y  : double;
    R    : TRect2d;
begin
   Result := Rect2d(10e+10,10e+10,-10e+10,-10e+10);
   For n:=0 to FCurveList.Count-1 do begin
      FCurve:=FCurveList.Items[n];
      R := FCurve.BoundsRect;
        if R.x1<Result.x1 then Result.x1:=R.x1;
        if R.x2>Result.x2 then Result.x2:=R.x2;
        if R.y2>Result.y2 then Result.y2:=R.y2;
        if R.y1<Result.y1 then Result.y1:=R.y1;
   end;
end;

procedure TALSablon.SetWorkArea(const Value: TRect);
begin
  FWorkArea := Value;
  invalidate;
end;

procedure TALSablon.SetTitleFont(const Value: TFont);
begin
  FTitleFont := Value;
  Repaint;
end;

procedure TALSablon.SetVisibleContours(const Value: Boolean);
begin
  FVisibleContours := Value;
  if Value then SetAllContour;
  SelectedIndex := -1;
  invalidate;
end;

procedure TALSablon.MagnifySelected(Cent: TPoint2d; Magnify: TFloat);
var n,i,j: integer;
    x,y: double;
begin
   For n:=0 to FCurveList.Count-1 do begin
      FCurve:=FCurveList.Items[n];
      J:=Pred(FCurve.FPoints.Count);
      if FCurve.Selected then begin
         FCurve.MagnifyCurve(Cent, Magnify);
         Changed := True;
      end;
   end;
   If AutoUndo then UndoSave;
   Paint;
end;


procedure TALSablon.SetLoading(const Value: boolean);
begin
  FLoading := Value;
//  DrawMode := dmNone;
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

procedure TALSablon.ShowHintPanel(Show: Boolean);
begin
end;

// Az aktív pont körül senzitiveradius távolságban kört rajzol
procedure TALSablon.ShowMagneticCircle(x, y: TFloat; enab: boolean);
var p: TPoint;
begin
  Paint;
  if enab then begin
     p := WToS(Point2d(x,y));
     Canvas.Pen.Color := clBlue;
     Canvas.Pen.Width := 2;
     Canvas.Pen.Mode := pmCopy;
     Canvas.Ellipse(P.x-SensitiveRadius,P.y-SensitiveRadius,
                 P.x+SensitiveRadius,P.y+SensitiveRadius);
  end;
end;

procedure TALSablon.SelectCurveByName(aName: string);
var n: integer;
begin
   For n:=0 to FCurveList.Count-1 do begin
      FCurve:=FCurveList.Items[n];
      if FCurve.Name = aName then
         Selected := FCurve;
   end;
  Paint;
end;

procedure TALSablon.SelectCurve(AIndex: Integer);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
   FCurve:=FCurveList.Items[AIndex];
   Selected := FCurve;
  end
  else
   Selected := nil;
end;

procedure TALSablon.AutoSortObject(BasePoint: TPoint2d);
{Automatkus objektum sorrend képzés}
var i,j,idx: integer;
    x,y,x1,y1,d,dd : double;
    p0,p : TPoint2d;
    ts: TMemoryStream;
    Closed,Begining,Continue : boolean;
    CurveCount : integer;
    BaseCurve,nextCurve : TCurve;
    pp: PPointRec;
    curve0 : integer;  //Curve sorszáma amit objektummá növelünk
    CuvIdx,NodeIdx: integer;
begin
if FCurveList.Count>1 then
Try
Try
  oldCursor := Cursor;
  Cursor := crHourGlass;
  Loading := True;
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
            BaseCurve.Shape := dmPolyLine;
            BaseCurve.Selected := True;
      end else begin
            if not BaseCurve.Closed then
               BaseCurve.Closed := (ABS(P0.X-X)<1) and (ABS(P0.Y-Y)<1);
            if BaseCurve.Closed then BaseCurve.Shape := dmPolyGon;
            begining := True;
            Inc(i);
      end;
  Until i>=FCurveList.Count;

  if not BaseCurve.Closed then
  begin
     p0 := BaseCurve.Points[0];
     p  := BaseCurve.LastPoint;
     BaseCurve.Closed := (ABS(P0.X-p.X)<1) and (ABS(P0.Y-p.Y)<1);
     if BaseCurve.Closed then BaseCurve.Shape := dmPolyGon;
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
(*
procedure TALSablon.AutoSortObject(BasePoint: TPoint2d);
{Automatkus objektum sorrend képzés}
var i,j,idx: integer;
    x,y,x1,y1,d,dd : double;
    p0,p : TPoint2d;
    ts: TMemoryStream;
    Closed,Begining,Continue : boolean;
    CurveCount : integer;
    BaseCurve,nextCurve : TCurve;
    pp: PPointRec;
    curve0 : integer;  //Curve sorszáma amit objektummá növelünk
    CuvIdx,NodeIdx: integer;
begin
if FCurveList.Count>1 then
Try
Try
  oldCursor := Cursor;
  Cursor := crHourGlass;
  Loading := True;
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
*)
procedure TALSablon.AutoSortObject(BasePoint: TPoint2d; Connecting: boolean);
{Automatkus objektum sorrend képzés}
var i,j,idx: integer;
    CuvIdx,NodeIdx: integer;
    x,y,x1,y1,d,dd : double;
    p0,p : TPoint2d;
    ts: TMemoryStream;
    Closed,Begining,Continue : boolean;
    CurveCount : integer;
    BaseCurve,nextCurve : TCurve;
    pp: PPointRec;
    curve0 : integer;  //Curve sorszáma amit objektummá növelünk
begin
if FCurveList.Count>1 then
Try
Try
  oldCursor := Cursor;
  Cursor := crHourGlass;
  Loading := True;
  ts:= TMemoryStream.Create;
  CurveCount := 0;
  p0 := BasePoint;
  // A legközelebbi objektum legközelebbi pontja lesz a kezdõpont
  GetNearestPoint( BasePoint,CuvIdx,NodeIdx );
  SetBeginPoint( CuvIdx,NodeIdx );

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
            if BaseCurve.Closed then BaseCurve.Shape := dmPolygon
               else BaseCurve.Shape := dmPolyline;
            begining := True;
            Inc(i);
      end;
  Until i>=FCurveList.Count;
  end;

           if not BaseCurve.Closed then begin
              dd:=KeTPontTavolsaga(BaseCurve.Points[0],BaseCurve.LastPoint);
              BaseCurve.Closed := dd<0.5;
           end;
           if BaseCurve.Closed then BaseCurve.Shape := dmPolygon
              else BaseCurve.Shape := dmPolyline;

  ts.Free;
  If AutoUndo then UndoSave;
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

// Fordított Objektum sorrend
procedure TALSablon.ReorderObjects;
var i,m:  integer;
    ts:   TMemoryStream;
begin
Try
  ts := TMemoryStream.Create;
  for I:=Pred(FCurveList.Count) downto 0 do
        begin
            FCurve:=FCurveList.Items[I];
            SaveCurveToStream(ts,i);
        end;
  FCurveList.Clear;
  m := ts.Size;
  ts.Seek(0,0);
  while ts.position<m do
        LoadCurveFromStream(ts);
finally
  ts.Free;
end;
end;

// A zárt poligonok ParentID-jét beállítja, ha van szülõje
procedure TALSablon.InitParentObjects;
var i: integer;
begin
  for i:=0 to Pred(FCurveList.Count) do begin
      FCurve := Curves[i];
      FCurve.ParentID := -1;
      if FCurve.Closed and FCurve.Visible then
            FCurve.ParentID := GetRealParentObject(i);
  end;
end;
// Initialize the transformation paraméters of Curves
procedure TALSablon.InitTrans3d;
var j: integer;
begin
  For j:=0 to Pred(FCurveList.Count) do Curves[j].InitTrans3d;
end;

procedure TALSablon.SelectParentObjects;
var i: integer;
begin
  Loading := True;
  for i:=0 to Pred(FCurveList.Count) do
      TCurve(FCurveList.Items[i]).Selected := IsParent(i);
  Loading := False;
  Invalidate;
end;

procedure TALSablon.SelectChildObjects;
var i: integer;
begin
  Loading := True;
  InitParentObjects;
  for i:=0 to Pred(FCurveList.Count) do
      Curves[i].Selected := Curves[i].ParentID>-1;
  Loading := False;
  Invalidate;
end;

    // A Child objektumot felfûzi a Parent objektumra
    procedure TALSablon.StripObj12(AParent,Achild: integer);
    var j,f,k     : integer;
        pCuv,cCuv : TCurve;
        dMin      : double;
        d         : double;
        pp0,pp,mp : TPoint2d;
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
       pp  := cCuv.GetPoint2d(cPointidx);

       // Vizsgáljuk, hogy a szakasz átvágja-e a befûzendõ polygon oldalát
       if cCuv.IsCutLine(pp0,pp,cPointidx,mp) then begin
          // Ha metszi, akkor be kell szúrni egy pontot oda
          InsertPoint(Achild,cPointidx,mp);
//          Dec(cPointidx);
       end;

       // Fiók bekezdési pontjának megadása
       SetBeginPoint(Achild,cPointidx);

       // Fiók befûzése
       for f:=0 to Pred(cCuv.Fpoints.Count) do begin
           pp := cCuv.GetPoint2d(f);
           pCuv.InsertPoint(pPointidx+f+1,pp.x,pp.y);
       end;
       pp := cCuv.GetPoint2d(0);
       pCuv.InsertPoint(pPointidx+f+1,pp.x,pp.y);
       pCuv.InsertPoint(pPointidx+f+2,pp0.x,pp0.y);
       // Az eredeti Child törlése
       cCuv.Visible := False;

    end;

// A fiók objektumok felfûzése a szülõ objektumra
procedure TALSablon.StripChildToParent(AIndex: integer);
var childCount: integer;
    i,k       : integer;
    pCuv,cCuv : TCurve;    // Parent and Child
    dMin      : double;
    parent    : integer;
begin
if (AIndex>-1) and (AIndex<=Pred(FCurveList.Count)) then begin
   childCount := GetInnerObjectsCount(AIndex);
   if childCount=0 then begin
     cCuv := FCurveList.Items[AIndex];
     parent := cCuv.ParentID;
     StripObj12(AIndex,parent);
   end;
end;
end;

// A fiók objektumok felfûzése a szülõ objektumokra
procedure TALSablon.StripAll1;

    // Megszámolja a teljes rajzban elõforduló gyerek objektumokat
    Function ChildCountAll: integer;
    var p: integer;
    begin
         Result := 0;
         InitParentObjects;
         For p:=0 to Pred(FCurveList.Count) do
             if Curves[p].Visible then
             if (Curves[p].ParentId=-1) then
                Result := Result + GetInnerObjectsCount(p);
    end;


    // Megszámolja a Cuv gyerek objektumait
    Function ChildCount(C: TCurve): integer;
    var p: integer;
    begin
         Result := 0;
         InitParentObjects;
         if c.Visible then
            Result := GetInnerObjectsCount(C);
    end;

    Function Strip: integer;
    var i: integer;
        Cuv : TCurve;
    begin
        Result := 0;
        InitParentObjects;
        For i:=0 to Pred(FCurveList.Count) do begin
            Cuv   := Curves[i];
            if Cuv.Visible and (Cuv.Shape=dmPolygon) then
            if (Cuv.ParentId>-1) and (GetInnerObjectsCount(i)=0) then
            begin
               StripObj12(Cuv.ParentID,i);
               Inc(Result);
               exit;
            end;
        end;
    end;


begin
  Loading := True;
  DeleteInvisibleCurves;
  PontsuritesAll(2);
  InitParentObjects;
  While ChildCountAll>0 do
  Strip;
  DeleteInvisibleCurves;
  SelectAll(false);
  Loading := False;
  invalidate;
end;

procedure TALSablon.StripAll;
var i,n: integer;
    Cuv : TCurve;
begin
  Loading := True;
  DeleteInvisibleCurves;
  PontsuritesAll(2);
  InitParentObjects;
  n := 100;
  While n>0 do begin
        n := 0;
        For i:=0 to Pred(FCurveList.Count) do begin
            Cuv   := FCurveList.Items[i];
            if Cuv.Visible and (Cuv.Shape=dmPolygon) then
            if not IsParent(i) and (GetInnerObjectsCount(i)=0) then begin
               StripChildToParent(i);
               Inc(n);
               Break;
            end;
        end;
        DeleteInvisibleCurves;
  end;
  Loading := False;
  invalidate;
end;

procedure TALSablon.ClearWorkPoint;
begin
    Canvas.CopyRect(WRect,WBmp.Canvas,Rect(0,0,8,8));
end;

procedure TALSablon.DrawWorkPoint(x, y: double);
var
  I,J: Integer;
begin
  WorkPosition.WorkPoint.x:=x;
  WorkPosition.WorkPoint.y:=y;
  With DrawBmp.Canvas do
  begin
       I:=XToS(x);
       J:=YToS(y);
       Pen.Color:=clRed;
       Pen.Mode:=pmCopy;
       Brush.Style := bsSolid;
       Brush.Color:=clRed;
       Ellipse(I-4,J-4,I+4,J+4);
  end;
end;

procedure TALSablon.TestVekOut(dx,dy:extended);
var i,lepesszam: integer;
    d,xr,yr,s,c,lepeskoz : double;
    x,y,alfa : double;
    okesleltetes,correction: double;
    DestPosition : TPoint3D;
    R  : TRect;
    HR : THRTimer;
begin
  DestPosition.x := WorkPosition.WorkPoint.x+dx;
  DestPosition.y := WorkPosition.WorkPoint.y+dy;

  d := sqrt((dx*dx)+(dy*dy));

If d>MMPerLepes then begin
  HR := THRTimer.Create;
  lepeskoz    := MMPerLepes;
  Kesleltetes := 1;
  lepesszam   := Round(d/lepeskoz);

  alfa := SzakaszSzog(0,0,dx,dy);
  xr := 0;
  yr := 0;
  s := lepeskoz*sin(alfa); c := lepeskoz*cos(alfa);

  okesleltetes:=Kesleltetes;

    For i:=1 to lepesszam do begin
      x:=xr/MMPerLepes; y:=yr/MMPerLepes;
      xr := xr+c;
      yr := yr+s;
      If Round(x)<>Round(xr/MMPerLepes) then begin
         If dx>0 then WorkPosition.WorkPoint.x:=WorkPosition.WorkPoint.x+MMPerLepes;
         If dx<0 then WorkPosition.WorkPoint.x:=WorkPosition.WorkPoint.x-MMPerLepes;
      end;
      If Round(y)<>Round(yr/MMPerLepes) then begin
         If dy>0 then WorkPosition.WorkPoint.y:=WorkPosition.WorkPoint.y+MMPerLepes;
         If dy<0 then WorkPosition.WorkPoint.y:=WorkPosition.WorkPoint.y-MMPerLepes;
      end;

      if fSablonSzinkron then begin
         MoveCentrum(WorkPosition.WorkPoint.x,WorkPosition.WorkPoint.y);
         repaint;
      end
      else begin
//         Canvas.LineTo(XToS(xr),YToS(yr+Paper.y));
         Canvas.LineTo(XToS(WorkPosition.WorkPoint.x),YToS(WorkPosition.WorkPoint.y));
      end;
      HR.Delay(kesleltetes);

      if (lo(GetAsyncKeyState(VK_ESCAPE)) > 0)
      then begin
           STOP := True;
      end;
      if (lo(GetAsyncKeyState(VK_SPACE)) > 0)
      then begin
           fSablonSzinkron := not fSablonSzinkron;
      end;

      if STOP then begin
         Kesleltetes:=okesleltetes;
         Working := False;
         HR.Free;
         exit;
      end;
  end;
  if HR<>NIL then HR.Free;
end;
  Kesleltetes:=okesleltetes;
end;


(*
procedure TALSablon.TestVekOut(dx,dy:extended);
var i,x,y,lepesszam: integer;
    d,xr,yr,s,c,lepeskoz : extended;
    alfa : double;
    kesleltetes,okesleltetes,correction: double;
    DestPosition : TPoint3D;
    R  : TRect;
begin
  DestPosition.x := WorkPosition.WorkPoint.x+dx;
  DestPosition.y := WorkPosition.WorkPoint.y+dy;

  d := sqrt((dx*dx)+(dy*dy));

If d>MMPerLepes then begin

  lepeskoz    := MMPerLepes;
  Kesleltetes := 10;
  lepesszam   := Round(d/lepeskoz);

  alfa := SzakaszSzog(0,0,dx,dy);
  xr := 0;
  yr := 0;
  s := lepeskoz*sin(alfa); c := lepeskoz*cos(alfa);

  okesleltetes:=Kesleltetes;

  if (lepesszam<>0) and ((Abs(dx)>lepeskoz) and (Abs(dy)>lepeskoz)) then begin
     correction:=Abs(lepesszam/(Abs(dx/lepeskoz)+Abs(dy/lepeskoz)));
     Kesleltetes:= Kesleltetes*(correction);
  end;

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
      else begin
           R:=ClientRect;
           Canvas.CopyRect(R,DrawBmp.Canvas,R);
           DrawWorkPoint(WorkPosition.WorkPoint.x,WorkPosition.WorkPoint.y);
//         Repaint;
      end;

      if (lo(GetAsyncKeyState(VK_ESCAPE)) > 0)
      then begin
           STOP := True;
      end;

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
*)

{Megmunkálás az Aobject AItem sorszámú pontjától}
procedure TALSablon.TestWorking(AObject,AItem:integer);
var Cuv : TCurve;
    i,j,j0 : integer;
    x,y : double;
    elso: boolean;
    p : TPoint2d;
    oc : boolean;
begin
  Try
    if Assigned(FPlan) then FPlan(Self,1,0);
    STOP := False;
    EnablePaint := False;
//    Loading := not SablonSzinkron;
    Kesleltetes := 8;
    elso := True;
    ShowPoints := False;
    oc := CentralCross;
    Working := True;
    WorkPosition.CuvNumber := AObject;
    WorkPosition.PointNumber := AItem;
    Paint;
    For i:=AObject to FCurveList.Count-1 do begin
        if Assigned(FPlan) then FPlan(Self,1,Trunc(100*i/Pred(FCurvelist.Count)));
        if STOP then Break;
        Application.ProcessMessages;
        Cuv := FCurveList.Items[i];
        if Ord(Cuv.Shape)>5 then
           Poligonize(FCurveList.Items[i],0);
        If Cuv.Enabled then begin
        WorkPosition.CuvNumber := i;

        If elso then begin
           j0:=AItem; elso:=False;
           Canvas.Pen.Color := clRed;
           Canvas.Pen.Style := psSolid;
           Canvas.Pen.Mode  := pmCopy;
           Canvas.Pen.width := 4;
           Canvas.MoveTo(XToS(WorkPosition.WorkPoint.x),YToS(WorkPosition.WorkPoint.y));
        end else j0 := 0;


        For j:=j0 to Cuv.FPoints.Count-1 do begin
            Cuv.GetPoint(j,x,y);
            WorkPosition.PointNumber := j;
            TestVekOut(x-WorkPosition.WorkPoint.x,y-WorkPosition.WorkPoint.y);
            if STOP then Break;
            Application.ProcessMessages;
        end;
        if STOP then
           Break;
        // Closed curve back to 0. point if points count>2
        If Cuv.Closed and (Cuv.FPoints.Count>2) then begin
            Cuv.GetPoint(0,x,y);
            WorkPosition.PointNumber := j;
            TestVekOut(x-WorkPosition.WorkPoint.x,y-WorkPosition.WorkPoint.y);
            if STOP then Break;
        end;
        end;
    end
    finally
       if Assigned(FPlan) then FPlan(Self,1,0);
        Working := False;
        EnablePaint := True;
        CentralCross := oc;
    end;
end;

(*
procedure TALSablon.TestWorking(AObject,AItem:integer);
var Cuv : TCurve;
    i,j,j0 : integer;
    x,y : double;
    elso: boolean;
    p : TPoint2d;
    oc : boolean;
begin
  Try
    STOP := False;
    Loading := not SablonSzinkron;
    Kesleltetes := 8;
    elso := True;
    ShowPoints := False;
    oc := CentralCross;
//    CentralCross := false;
    Working := True;
    WorkPosition.CuvNumber := AObject;
    WorkPosition.PointNumber := AItem;
    Paint;
    For i:=AObject to FCurveList.Count-1 do begin
        if STOP then Break;
        Cuv := FCurveList.Items[i];
        if Ord(Cuv.Shape)>5 then
           Poligonize(FCurveList.Items[i],0);
        If Cuv.Enabled then begin
        WorkPosition.CuvNumber := i;

        If elso then begin
           j0:=AItem; elso:=False;
           Canvas.Pen.Color := clRed;
           Canvas.Pen.Style := psSolid;
           Canvas.Pen.Mode  := pmCopy;
           Canvas.Pen.width := 4;
           Canvas.MoveTo(XToS(WorkPosition.WorkPoint.x),YToS(WorkPosition.WorkPoint.y));
        end else j0 := 0;


        For j:=j0 to Cuv.FPoints.Count-1 do begin
            Cuv.GetPoint(j,x,y);
            WorkPosition.PointNumber := j;
            TestVekOut(x-WorkPosition.WorkPoint.x,y-WorkPosition.WorkPoint.y);
            if STOP then Break;
        end;
        if STOP then
           Break;
        // Closed curve back to 0. point if points count>2
        If Cuv.Closed and (Cuv.FPoints.Count>2) then begin
            Cuv.GetPoint(0,x,y);
            WorkPosition.PointNumber := j;
            TestVekOut(x-WorkPosition.WorkPoint.x,y-WorkPosition.WorkPoint.y);
            if STOP then Break;
        end;
        end;
    end
    finally
        Working := False;
        Loading := false;
        CentralCross := oc;
    end;
end;
*)

procedure TALSablon.PoligonizeAll(PointCount: integer);
// Total graphic vectorisation
Var
    i    : integer;
begin
  For i:=0 to Pred(FCurveList.Count) do
      Poligonize(Curves[i],PointCount);
end;

procedure TALSablon.PoligonizeAllSelected(PointCount: integer);
Var
    i    : integer;
begin
  For i:=0 to Pred(FCurveList.Count) do
  if Curves[i].selected then
      Poligonize(Curves[i],PointCount);
end;

// Some curve vectorization:
//    If Count>0 then result curve will be countains count points
procedure TALSablon.Poligonize(Cuv: TCurve; Count: integer);
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
   Loading := True;
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
//          deltaFI := (2*PI)/(2*arcR*PI);
          deltaFI := 1/57;
//          if deltaFi>pi/180 then deltaFi:=pi/180;
       end else
          deltaFI := (2*PI)/Count;
       While (szog<=(2*pi)) do begin
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
          deltaFI := Sgn(szog)*1/57;
//          deltaFI := Sgn(szog)*(2*PI*2)/(2*arcR*PI);
       end else
          deltaFI := szog/Count;
       j := Abs(Trunc(szog/deltaFI));
       for i:=0 to j+1 do begin
             x := ArcU + arcR * cos(szog1);
             y := ArcV + arcR * sin(szog1);
             Cuv.AddPoint(x,y);
             szog1 := szog1+deltaFI;
       end;
       Cuv.ChangePoint(Cuv.Count-1,pp2.X,pp2.Y);
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
       Cuv.Shape := dmPolygon;
       Cuv.Closed := True;
     end;
   dmCubicBezier:
     begin
        // Virtual Drawing Bitmap
       j := Pred(Cuv.FPoints.Count);
       for I:=0 to j do
       begin
        Cuv.GetPoint(I,X,Y);
        dd[i] := Point3d(x,y,0);
       end;
       Cuv.ClearPoints;
       Cuv.Shape := dmPolyline;
       Cuv.Closed := False;
       InitdPoints;
       GetBezierPathPoints(dd,J+1,100);
       for I:=0 to Pred(dPoints.Count) do begin
         pp := dPoints[i];
         Cuv.AddPoint(pp^.x,pp^.y);
       end;
     end;
   end;
finally
//   If AutoUndo then UndoSave;
   Vektorisation(0.05,Cuv);
   InitdPoints;
   Loading := False;
end;
end;

procedure TALSablon.SetWorkOrigo(const Value: TPoint2d);
begin
  fWorkOrigo := Value;
  If not Working then begin
     WorkPosition.WorkPoint.X := Value.X;
     WorkPosition.WorkPoint.y := Value.y;
  end;
  Invalidate;
end;

procedure TALSablon.VektorisationAll(MaxDiff: TFloat);
// Total graphic vectorisation
Var
    i    : integer;
begin
Try
  Loading := True;
  For i:=0 to Pred(FCurveList.Count) do begin
      if FCurveList.Items[i]<>nil then
      Vektorisation(MaxDiff,TCurve(FCurveList.Items[i]));
  end;
  if AutoUndo then UndoSave;
  Invalidate;
  Loading := False;
except
end;
end;

procedure TALSablon.VektorisationAllSelected(MaxDiff: TFloat);
// Total graphic vectorisation
Var
    i    : integer;
begin
Try
  Loading := True;
  For i:=0 to Pred(FCurveList.Count) do begin
      if FCurveList.Items[i]<>nil then
      if TCurve(FCurveList.Items[i]).selected then
         Vektorisation(MaxDiff,TCurve(FCurveList.Items[i]));
  end;
  if AutoUndo then UndoSave;
  Loading := False;
except
end;
end;


procedure TALSablon.Vektorisation(MaxDiff: TFloat; Cuv: TCurve);
var diff    : double;          // eltérés
    i       : integer;
    pp      : pPoints;
    kp,vp   : TPoint2D;        // vektor kezdõ és végpontja
    lp      : TPoint2D;
    n0,n,k  : integer;         // n futóindex
    e       : TEgyenesfgv;
    p2d     : TPoint2D;
begin

if (cuv<>nil) and (Cuv.Count>2) then
Try
   lp := Cuv.LastPoint;
//   DeleteSamePoints(0.05);
   // Store the Cuv points in dPoints list
   InitdPoints;
   For i:=0 to Pred(Cuv.FPoints.Count) do begin
       pp := Cuv.Fpoints[i];
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
   k  := dPoints.Count;

   // Ujmódszer
   While (n<dPoints.Count) and (n0<dPoints.Count) do begin
   Try
     pp := dPoints[n0];
     kp := Point2d(pp^.x,pp^.y);
     Cuv.AddPoint(pp^.x,pp^.y);
     Inc(n0);
     Dec(k);

     While (n<dPoints.Count) and (n0<dPoints.Count) do begin
        pp := dPoints[n];
        vp := Point2d(pp^.x,pp^.y);
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
           Inc(n);
           break;
        end;
        Inc(n);
     end;
   except
     Break;
   end;
   end;

      n0 := dPoints.Count-2;

      pp := dPoints[n0];
      Cuv.AddPoint(pp^.x,pp^.y);

      Cuv.AddPoint(lp);

except
      Exit;
end;
end;

(*
procedure TALSablon.Vektorisation(MaxDiff: TFloat; Cuv: TCurve);
var diff    : double;          // eltérés
    i       : integer;
    pp      : pPoints;
    kp,vp   : TPoint2D;        // vektor kezdõ és végpontja
    lp      : TPoint2D;
    n0,n,k  : integer;         // n futóindex
    e       : TEgyenesfgv;
    p2d     : TPoint2D;
begin

if (cuv<>nil) and (Cuv.Count>2) then
Try
   lp := Cuv.LastPoint;
   DeleteSamePoints(0.05);
   // Store the Cuv points in dPoints list
   InitdPoints;
   For i:=0 to Pred(Cuv.FPoints.Count) do begin
       pp := Cuv.Fpoints[i];
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
   k  := dPoints.Count;

   // Ujmódszer
   While (n0<k-2) do begin
   Try
     pp := dPoints[n0];
     kp := Point2d(pp^.x,pp^.y);
     Cuv.AddPoint(pp^.x,pp^.y);
        pp := dPoints[n0+1];
        vp := Point2d(pp^.x,pp^.y);
        e := KeTPontonAtmenoEgyenes(kp.x,kp.y,vp.x,vp.y);
        // Vizsgáljuk a közbülsõ pontok eltéréseit az egyenestõl
        For i:=n0+2 to Pred(k) do begin
            pp   := dPoints[i];
            p2d  := Point2d(pp^.x,pp^.y);
            diff := PontEgyenesTavolsaga(e,p2d);
            if diff>MaxDiff then
            begin
               n0 := i-1;      // Az n-1. pont eltérése már jelentõs
               break;
            end;
        end;

   except
     Break;
   end;
   end;

   If not Cuv.Closed then
      n0 := dPoints.Count-1
   else
      n0 := dPoints.Count-2;

      pp := dPoints[n0];
      Cuv.AddPoint(pp^.x,pp^.y);

      Cuv.AddPoint(lp);

except
      Exit;
end;
end;
*)
(*
procedure TALSablon.Vektorisation(MaxDiff: TFloat; Cuv: TCurve);
var diff    : double;          // eltérés
    i       : integer;
    pp      : pPoints;
    kp,vp   : TPoint2D;        // vektor kezdõ és végpontja
    lp      : TPoint2D;
    n0,n,k  : integer;         // n futóindex
    e       : TEgyenesfgv;
    p2d     : TPoint2D;
begin

if (cuv<>nil) and (Cuv.Count>2) then
Try
   lp := Cuv.LastPoint;
   DeleteSamePoints(0.05);
   // Store the Cuv points in dPoints list
   InitdPoints;
   For i:=0 to Pred(Cuv.FPoints.Count) do begin
       pp := Cuv.Fpoints[i];
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
   k  := dPoints.Count;

   // Ujmódszer
   While (n<dPoints.Count) and (n0<dPoints.Count) do begin
   Try
     pp := dPoints[n0];
     kp := Point2d(pp^.x,pp^.y);
     Cuv.AddPoint(pp^.x,pp^.y);
     Inc(n0);
     Dec(k);

     While (n<dPoints.Count) and (n0<dPoints.Count) do begin
        pp := dPoints[n];
        vp := Point2d(pp^.x,pp^.y);
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
//           Inc(n);
           break;
        end;
        Inc(n);
     end;
   except
     Break;
   end;
   end;

   If not Cuv.Closed then
      n0 := dPoints.Count-1
   else
      n0 := dPoints.Count-2;

      pp := dPoints[n0];
      Cuv.AddPoint(pp^.x,pp^.y);

      Cuv.AddPoint(lp);

except
      Exit;
end;
end;
*)

// A pontsûrítés közbülsõ pontok beillesztése Dist távolságonként
procedure TALSablon.PontSurites(Cuv: TCurve; Dist: double);
var x,y         : TFloat;
    d           : TFloat;
    i,j,k       : integer;
    pp,pp1      : pPoints;
    dx,dy       : TFloat;
    Angle       : TFloat;
begin
Try
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
//   If AutoUndo then UndoSave;
   InitdPoints;
   Loading := False;
end;
end;

procedure TALSablon.PontSuritesAll(Dist: double);
Var
    i    : integer;
begin
  For i:=0 to Pred(FCurveList.Count) do
      PontSurites(TCurve(FCurveList.Items[i]),Dist);
end;

function TALSablon.GetInnerObjectsCount(AIndex: Integer): integer;
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
      if FCurve.Visible and (FCurve.Shape=dmPolygon) then begin
         inRect := FCurve.Boundsrect;
         If RectInRect2D(OurRect,inRect) then Inc(Result);
      end;
    end;
  end;
end;

function TALSablon.GetInnerObjectsCount(Cuv: TCurve): integer;
// Result = 0 or inner objects' count;
Var OurRect : TRect2d;
    inRect  : TRect2d;
    i       : integer;
begin
  Result := 0;
  OurRect:= Cuv.Boundsrect;
  For i:=0 to Pred(FCurveList.Count) do begin
      FCurve := FCurveList.Items[I];
      if FCurve.Visible and (FCurve<>Cuv) then begin
         inRect := FCurve.Boundsrect;
         If RectInRect2D(OurRect,inRect) then
         if Cuv.IsInCurve(FCurve.Points[0])=icIn then begin
            Inc(Result);
         end;
      end;
  end;
end;

function TALSablon.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
var N : double;
begin
  FCentralisZoom := False;
  if SelectedFrame.Visible and SelectedFrame.IsInPoint(SToW(Mouse_Pos))
  then
  begin
      if WheelDelta<0 then N:=0.999
      else N:=1.001;
      SelectedFrame.Magnify(N);
      paint;
  end
  else
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
  end;
  Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos);
end;

function TALSablon.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelDown(Shift, MousePos);
end;

function TALSablon.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelUp(Shift, MousePos);
end;

// Megkeresi, hogy a sokszög melyik legkisebbnek alakzat belselyében van
// Ha nincs befoglalója, akkor Result=-1
// Ha van, akkor annak az ID-jével tér vissza
function TALSablon.GetParentObject(AIndex: Integer): integer;
Var OurRect : TRect2d;
    inRect  : TRect2d;
    oRect   : TRect2d;
    Cuv     : TCurve;
    p,p1,p2 : TPoint2d;
    i,j     : integer;
    maxy    : double;
begin

  Result := -1;
  FCurve := FCurveList.Items[AIndex];
  p := FCurve.GetPoint2d(0);
  maxy := minReal;
  // Megkeresem a max. y pontot
  for i:=0 to Pred(FCurve.Count) do begin
      p1 := FCurve.Points[i];
      if p1.y>maxy then begin
         maxy := p1.y;
         p := p1;
      end;
  end;
  Result := GetParentObject(p.x,p.y);
  FCurve.ParentID := Result;

(*
  Result := -1;
  FCurve := FCurveList.Items[AIndex];
  p := FCurve.GetPoint2d(0);
  inRect := FCurve.Boundsrect;
  oRect  := Rect2d(MaxInt,MaxInt,-MaxInt,-MaxInt);
  For i:=0 to Pred(FCurveList.Count) do begin
    if i<>AIndex then begin
      Cuv := FCurveList.Items[I];
      if Cuv.Visible then
      begin
      OurRect:= Cuv.Boundsrect;
      If RectInRect2D(oRect,OurRect) then
         if RectInRect2D(OurRect,inRect) then begin
            oRect := OurRect;
            Result := i;
         end;
      end;
    end;
  end;
*)
end;

// Megkeresi a pont körüli legkisebb befoglaló objektumot
// Result = -1, vagy a talált befoglaló objektum ID-je
function TALSablon.GetParentObject(x,y: TFloat): integer;
Var OurRect : TRect2d;
    inRect  : TRect2d;
    oRect   : TRect2d;
    i,j     : integer;
    Cuv     : TCurve;
    dist    : double;
    p,p1,p2,o : TPoint2d;
begin
  Result := -1;
  dist   := maxReal;
  For i:=0 to Pred(FCurveList.Count) do begin
      Cuv := FCurveList.Items[I];
      if Cuv.Visible then begin
         OurRect:= Cuv.Boundsrect;
         if PontInKep(x,y,OurRect) then
         for j:=0 to Cuv.Count-2 do begin
             p1:=Cuv.Points[j];
             p2:=Cuv.Points[j+1];
             if Kozben(p1.x,p2.x,x,0) and (p2.x<>p1.x)then begin
                   o := Osztopont(p1,p2,(x-p1.x)/(p2.x-p1.x));
                   if (o.y>y) and (Abs(o.y-y)<dist) then begin
                      dist := Abs(o.y-y);
                      Result := i;
                   end;
             end;
         end;
      end;
  end;
(*
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
*)
end;

// Megvizsgálja, hogy az objektumnak van-e szüleje, azaz
// olyan objektum, aminek a belselyében található.
// Ha van, akkor Result=False ,
// ha nincs, akkor: True;
function TALSablon.IsParent(AIndex: Integer): boolean;
begin
  Result := False;
  if AIndex>-1 then
     Result := GetParentObject(AIndex)=-1;
end;

// Megvizsgálja, hogy a pont körüli objektumnak van-e szüleje, azaz
// olyan objektum, aminek a belselyében található
// True = ha szülõ objektum
function TALSablon.IsParent(x,y: TFloat): boolean;
begin
  Result := False;
  Result := GetParentObject(x,y)=-1;
end;

function TALSablon.GetRealParentObject(AIndex: Integer): integer;
Var CuvParent : TCurve;
    Cuv     : TCurve;
    pIdx    : integer;
    i,j     : integer;
begin
  Result := -1;
  Cuv := Curves[AIndex];
  for I := 0 to Pred(FCurveList.Count) do
    if i<>AIndex then begin
       CuvParent := Curves[i];
       if CuvParent.IsInCurve(Cuv.Points[0])=icIn then
       begin
          Result := i;
          Exit;
       end;
    end;
end;


(*
  Result := -1;
  pIdx   := GetParentObject(AIndex);
  if pIdx<>-1 then
  begin
       Cuv := Curves[AIndex];
       CuvParent := Curves[pIdx];
       if CuvParent.IsInCurve(Cuv.Points[0])=icIn then
          Result := pIdx;
  end;
end;
*)


// A névlistát az objektumsorrendnek megfelelõen korrigálja
procedure TALSablon.ReOrderNames;
var i,n: integer;
    kod: array[0..13] of integer;
begin
  For i:=0 to Pred(FCurveList.Count) do begin
      FCurve := FCurveList.Items[I];
      FCurve.Name := DrawModeText[Ord(FCurve.Shape)]+'_'+IntToStr(i);
  end;
end;

procedure TALSablon.SignedNotCutting;
var i,j,k: integer;
    BaseCurve,Cuv: TCurve;
    p,p0: TPoint2d;
    R1,R2: TRect2d;
begin
  loading := True;
  CrossedAll(False);
  // Signed=True, ha valamely objektum át van vágva (rajzon szürke szín)
  For i:=0 to Pred(FCurveList.Count) do begin
      BaseCurve:=FCurveList.Items[i];
      R1 := BaseCurve.BoundsRect;
      if BaseCurve.Shape=dmPolygon then
         For j:=0 to Pred(FCurveList.Count) do
         if (i<>j) {and (Curves[j].closed)} then begin
             Cuv:=FCurveList.Items[j];
             R2 := Cuv.BoundsRect;
             if IntersectRect2D(R1,R2) then
             For k:=0 to Cuv.Count-2 do
             begin
                p:=Cuv.GetPoint2d(k);
                p0:=Cuv.GetPoint2d(k+1);
                if BaseCurve.IsCutLine(p0,p) then begin
                   BaseCurve.Crossed:=True;
                   Break;
                end;
             end;
         end;
  end;
  loading := False;
  invalidate;
end;


function TALSablon.SToW(p: TPoint): TPoint2d;
begin
   Result.x := XToW(p.x);
   Result.y := YToW(p.y);
end;


// AutoSTRIP : FÛZÉR KÉPZÉS
// Ha a FileName='', akkor nincs automatikus mentés
procedure TALSablon.AutoSTRIP(FileName: string; BasePoint: TPoint2d);
var i,h,m: integer;
    bm: TPoint2d;
    R:  TRect2d;
    fc,Cuv: TCurve;
    dx,dy: extended;
    fn,path: string;

    procedure VisibleAll;
    var ii: integer;
    begin
         For ii:=0 to Pred(FCurveList.Count) do begin
             FCurve := FCurveList.Items[ii];
             FCurve.Visible:=True;
         end;
    end;

    function GetFileName(fn:string;toldat:string): string;
    var
       fName,path,ext : string;
    begin
     Result := '';
     fName := ExtractFileName(fn);
     if fName<>'' then
     begin
          ext  := ExtractFileExt(fn);
          path := ExtractFilePath(fn);
          if ext <> '' then fName := DelSub(fName,ext)+toldat+ext
          else fName := fName + toldat + '.sbn';
          Result := path + fName;
     end;
    end;

begin
if (FCurveList.Count>0) and (ActionMode <> amAutoPlan) then
Try
  // Alap beállítások
  if Assigned(FPlan) then FPlan(Self,0,0);
  ActionMode := amAutoPlan;
  STOP := False;
  oldCursor := Cursor;
  Screen.Cursor := crHourGlass;
  Loading := True;
  AutoUndo := False;

  // Eredeti rajz mentése
  // Ha nincs olyan könyvtár, akkor létrehozza
  if Filename<>'' then begin
     path := ExtractFilePath(FileName);
     if not DirectoryExists(path) then
        CreateDir(path);
     if DirectoryExists(path) then
        SaveGraphToFile( FileName );
  end;

  // Töröljük az összes nyílt alakzatot
  SignedAll(False);
  VisibleAll;
  SelectAll(False);

  // Polyline-ok törlése
  SelectAllPolylines;
  DeleteSelectedCurves;

         R := GetDrawExtension;
         m := Grid.Margin;
         dx := 2*m-R.x1;
            dy := Paper.y-2*m-R.y2;
         Eltolas(dx,dy);


  // Parent objektumok másolása a virtuál clipboardra
  // Csak a gyerek objektumok maradnak
  SelectParentObjects;
  CutSelectedToVirtClipboard;


  // Gyerek objektumok sorba rendezése
  AutoSortObject(BasePoint);

  if Assigned(FPlan) then FPlan(Self,1,0);


  // Gyerek objektumok felfûzése
  bm := BasePoint;
  h  := Pred(FCurveList.Count);
  for i:=0 to h do
  begin
      fc := TCurve.Create;
      fc.ClearPoints;
      fc.Name := 'Strip'+inttostr(i);
      fc.Closed := False;
      fc.Shape := dmPolyline;
      fc.AddPoint(bm);
      FCurve:=FCurveList.Items[2*i];
      bm := FCurve.GetPoint2d(0);
      fc.AddPoint(bm);
      FCurveList.Insert(2*i,fc);
  end;
      fc := TCurve.Create;
      fc.ClearPoints;
      fc.Name := 'Strip'+inttostr(i);
      fc.Closed := False;
      fc.Shape := dmPolyline;
      fc.AddPoint(bm);
      fc.AddPoint(BasePoint);
      FCurveList.Add(fc);
  invalidate;
  // Fûzér mentése child-ekkel
  if Filename<>'' then begin
     fn := GetFileName(FileName,'_1');
     if fn<>'' then
        SaveGraphToFile( fn );
  end;

  // Polygon-ok/child-ek törlése
  SelectAllPolygons;
  DeleteSelectedCurves;
  if Filename<>'' then begin
     fn := GetFileName(FileName,'_0');
     if fn<>'' then
        SaveGraphToFile( fn );
  end;

  // Fûzér törlése
  FCurveList.Clear;
  invalidate;

  // Parent objektumok visszatöltése, rendezés, felfûzés
  PasteSelectedFromVirtClipboard;
  Selectall(False);
  R := GetDrawExtension;
  AutoCutSequence(BasePoint,True,0);
  if Filename<>'' then
     SaveGraphToFile( GetFileName(FileName,'_2') );

  // A fûzér betöltése
  Clear;
  fn := GetFileName(FileName,'_0');
  if fn<>'' then
     LoadGraphFromFile( fn );

  invalidate;
  Changed := false;
  AutoUndo := True;

except
  AutoUndo := True;
end; // Try
end;

// A kijelölt objektumokat szakaszokká bontja
procedure TALSablon.BombAll;
var i,j,h: integer;
    cuv: TCurve;
    p1,p2: TPoint2d;
begin
  for i:=Pred(FCurveList.Count) downto 0 do begin
      Cuv:=FCurveList.Items[i];
      if cuv.Selected then begin
      for j:=0 to Pred(cuv.Count)-1 do begin
          h := MakeCurve('Line',-1,dmPolyline,true,true,false);
          p1 := cuv.Points[j];
          p2 := cuv.Points[j+1];
          AddPoint(h,p1);
          AddPoint(h,p2);
      end;
      if cuv.Closed then begin
          h := MakeCurve('Line',-1,dmPolyline,true,true,false);
          p1 := cuv.Points[Pred(cuv.Count)];
          p2 := cuv.Points[0];
          AddPoint(h,p1);
          AddPoint(h,p2);
      end;
      DeleteCurve(i);
      end;
  end;
  if AutoUndo then UndoSave;
  if not MouseOn then
  if Assigned(FChangeAll) then FChangeAll(Self);
  Changed := True;
  Invalidate;
end;

// Megvizsgálja, hogy a p1-p2 szakasz átvágja valamelyik vagy több objektumot.
//     Aindex = az elsõként érintett objektum sorszáma
function TALSablon.IsCutObject(p1,p2: TPoint2d; var Aindex: integer): boolean;
var i: integer;
    t: Trect2d;
    Cuv : TCurve;
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

function TALSablon.GetDisabledCount: integer;
var i: integer;
    Cuv : TCurve;
begin
   Result := 0;
   For i:=0 to Pred(FCurvelist.Count) do begin
      Cuv := FCurveList.Items[I];
      if Cuv.Enabled = False then Inc(Result);
   end;
end;

procedure TALSablon.DrawCurve(Cuv: TCurve; co: TColor);
var i: integer;
    x,y: integer;
    R: TRect2d;
    p: TPoint;

    function IsOverlapedRects(R1,R2: TRect2d): boolean;
    begin
         R1 := CorrectRealRect(R1);
         R2 := CorrectRealRect(R2);
         Result := not ( (R2.x2<R1.x1) or (R2.x1>R1.x2) or
                         (R2.y2<R1.y1) or (R2.y1>R1.x2));
    end;

begin
if Cuv<>nil then begin
//  if IsOverlapedRects(Window,Cuv.BoundsRect) then
  With Canvas do begin
       Pen.Mode  := pmCopy;
       Pen.Color := co;
       Pen.Width := 2;
       For i:=0 to Pred(Cuv.Count) do begin
           p:=WToS(Cuv.GetPoint2d(i));
           If i=0 then
              MoveTo(p.x,p.y)
           else
              LineTo(Round(p.x),Round(p.y))
       end;
       if Cuv.Closed then begin
          p:=WToS(Cuv.GetPoint2d(0));
          LineTo(p.x,p.y)
       end;
  end;
end;
end;

// aSave = True: akkor beteszi a rajzba a torzított képet
// aSave = False: visszaadja az eredeti kpet
procedure TALSablon.DoSelectedFrame(aSave: boolean);
begin
  if SelectedFrame.Visible then
  begin
     Ur.Enable := true;
     if aSave then
     begin
        LoadSelectedFrame;
        UndoSave;
     end else
     begin
        Undo;
     end;
     AutoUndo := true;
     SetAllContour;
     SelectedFrame.Visible := False;
     EnableSelectedFrame := False;
     SignedNotCutting;
  end;
  if Assigned(FChangeAll) then FChangeAll(Self);
end;

procedure TALSablon.DoubleClick(Sender: TObject);
begin
  Centrum.x := MapXY.X;
  Centrum.y := MapXY.Y;
  inherited;
end;

// Return the least rect of selected objects
function TALSablon.GetSelectArea( var RArea: TRect2d): boolean;
var i: integer;
    boundsR: TRect2d;
begin
   Result := False;
   RArea := Rect2d(MaxDouble,MaxDouble,MinDouble,MinDouble);
   if GetSelectedCount>0 then
   begin
   For i:=0 to Pred(FCurvelist.Count) do begin
       FCurve:=Curves[i];
       if FCurve.Selected then begin
          boundsR := FCurve.BoundsRect;
          if boundsR.x1<RArea.x1 then RArea.x1 := boundsR.x1;
          if boundsR.x2>RArea.x2 then RArea.x2 := boundsR.x2;
          if boundsR.y1<RArea.y1 then RArea.y1 := boundsR.y1;
          if boundsR.y2>RArea.y2 then RArea.y2 := boundsR.y2;
       end;
   end;
     Result := true;
   end;
end;

function TALSablon.GetSelectedCount: integer;
var i: integer;
begin
   Result := 0;
   For i:=0 to Pred(FCurvelist.Count) do
       if Curves[i].Selected then
         Inc(Result);
end;

function TALSablon.GetSignedCount: integer;
var i: integer;
begin
   Result := 0;
   For i:=0 to Pred(FCurvelist.Count) do begin
       FCurve:=FCurveList.Items[i];
       if FCurve.Signed then
         Inc(Result);
   end;
end;

procedure TALSablon.CurveToCent(AIndex: Integer);
var R : TRect2d;
begin
  R := TCurve(FCurveList.Items[Aindex]).BoundsRect;
  MoveCentrum((R.x1+R.x2)/2,(R.y1+R.y2)/2);
end;

procedure TALSablon.UndoStart;
begin
  UR.Enable := AutoUndo;
end;

procedure TALSablon.UndoStop;
begin
  UR.Enable := False;
end;



// =============    SelectedFrame   ============================================

procedure TALSablon.DrawNode(p: TPoint2d; m: integer; Fill: boolean; co: TColor);
var pp: TPoint;
begin
  With Canvas do begin
       Pen.Color := co;
       Pen.Width := 2;
       Pen.Mode  := pmCopy;
       Brush.Color := co;
       if Fill then
          Brush.Style := bsSolid
       else
          Brush.Style := bsClear;
       pp := WToS(p);
       Rectangle(pp.X-m,pp.Y-m,pp.X+m,pp.Y+m);
  end;
end;

procedure TALSablon.DrawSelectedFrame;
Var
   p: array of TPoint2d;
   Cuv,oCuv,dCuv: TCurve;
   i: integer;
   m: integer;
begin
if SelectedFrame<>nil then
if SelectedFrame.Visible then
Try
  m := 4; //SensitiveRadius;
  SetLength(p,4);

  Cuv := TCurve.Create;
  Cuv.Shape  := dmPolygon;
  Cuv.Closed := true;
  With SelectedFrame do begin
       for I := 0 to 3 do
           Cuv.AddPoint( Nodes[i] );
       DrawCurve( Cuv, clBlue );

       // Támpontok rajzolása

       // Sarokpontok
       for I := 0 to 3 do
           DrawNode(Nodes[i],m,true,clBlue);
       // Felezõpontok
       for I := 4 to 7 do
           DrawNode(Nodes[i],m,false,clBlue);

       // RC forgatási pont
       DrawNode(RCent,m,true,clRed);
       ShowLine(Canvas,XToS(Nodes[4].x),YToS(Nodes[4].y),XToS(RC.X),YToS(RC.Y));
       DrawNode(RC,m,true,clRed);

       // Draw Curves from DestList
       Selectedindex := -1;
       for i := 0 to Pred(SelectedFrame.DestList.Count) do
       begin
         dCuv := DestList.Items[i];
         dCuv.Selected := false;
         DrawCurve(dCuv,clMaroon);
       end;

  end;
finally
  Cuv.Free;
end;
end;

procedure TALSablon.LoadSelectedFrame;
var i: integer;
    Cuv: TCurve;
begin
  if SelectedFrame.Visible then
  begin
    for I := 0 to Pred(SelectedFrame.DestList.Count) do
    begin
      Cuv := TCurve.Create;
      Cuv := SelectedFrame.DestList.Items[i];
      FCurveList.Add(Cuv);
    end;
    invalidate;
    AutoUndo := True;
  end;
end;

procedure TALSablon.AdjustSelectedFrame;
begin

end;

function TALSablon.IsNode(p: TPoint2d; Radius: double;
  var idx: integer): boolean;
var i: integer;
    d: double;
    re: TRect2d;
begin
  // Radius : graviti radius
  // idx : 0..3 nodes, 4..7: midpoints, 8: RC, 9: RCent
Try
  Result := False;
  idx := -1;
  re := Rect2d(p.x-Radius,p.y+Radius,p.x+Radius,p.y-Radius);
  for i := 0 to 9 do begin
      if PontInKep(SelectedFrame.Nodes[I].X,SelectedFrame.Nodes[I].Y,re) then
      begin
        idx := i;
        Result := true;
        Break;
      end;
  end;
except

End;
end;

procedure TALSablon.SetEnableSelectedFrame(const Value: boolean);
begin
  FEnableSelectedFrame := Value;
  if (SelectedFrame.Visible) and (not Value) then
     SelectedFrame.Visible := false;
  if Assigned(fOnSelectedFrame) then fOnSelectedFrame(Self);
  if Value then Screen.Cursor := crCross
  else Screen.Cursor := crDefault;
end;

procedure TALSablon.SetSelectedIndex(const Value: integer);
begin
  if Selected=nil then begin
     FSelectedIndex:=-1;
     exit;
  end;
  FSelectedIndex := Value;
  if FSelectedIndex>FCurvelist.Count-1 then FSelectedIndex:=0;
end;

// Ha True, akkor az aktuális (Selected) objektum pirossal kirajzolódik
procedure TALSablon.SetSelectedVisible(const Value: boolean);
begin
  FSelectedVisible := Value;
  invalidate;
end;

// =============    Cipper functions   =========================================


function TALSablon.GetClipperContour(Cuv: TCurve; dist: double): TCurve;
var subj : TPath;
    sol  : TPaths;
    ClipOffset: TClipperOffset;

procedure ToPath(Cuv: TCurve; var aList: TPath; multiplier: double);
Var  i: integer;
     pp: TIntPoint;
begin
  SetLength( aList, Cuv.Count );
  for i := 0 to High(aList) do begin
      pp.x := Round(multiplier*Cuv.Points[i].X);
      pp.y := Round(multiplier*Cuv.Points[i].Y);
      aList[i] := pp;
  end;
end;

function FromPath(aList: TPath; multiplier: double): TCurve;
Var  i: integer;
     pp: TIntPoint;
     p: TDoublePoint;
begin
Try
  // Clear the point list of Contour
  Result := TCurve.Create;
  Result.Shape := dmPolygon;
  Result.Closed := True;
  for i := 0 to High(aList) do begin
      pp := aList[i];
      p  := DoublePoint( pp );
      Result.AddPoint( p.X/multiplier, p.Y/multiplier );
  end;
except
End;
end;

begin
// Create contour if
if Cuv<>nil then
if Cuv.Closed and (Cuv.Count>2) then
Try
Try
  ClipOffset := TClipperOffset.Create;
  ToPath(Cuv,subj,100);
  ClipOffset.AddPath(subj, jtRound, etClosedPolygon);
  ClipOffset.Execute(sol, 100*dist);
  if Length(sol)<>0 then
  Try
     if Length(sol[0])<>0 then begin
        Result := FromPath(sol[0],100);      // Result in Contour curve
        Cuv.Contour := Result;
     end;
  except
  End;
Finally
  if ClipOffset<>nil then
     ClipOffset.Free;
End;
except
  if ClipOffset<>nil then
     ClipOffset.Free;
End;
end;

procedure TALSablon.ClipperBool(ClipType: TClipType);
var Clip: TClipper;
    clipI,subjI: TPath;
    solution: TPaths;
    n: integer;
    Cuv: TCurve;
    sIdx,I: Integer;

    procedure AddSolution(solution : TPaths);
    var ii,jj : integer;
        p2  : TPoint2d;
        cCuv: TCurve;
    begin
        for ii := 0 to High(solution) do
        Try
            cCuv := TCurve.Create;
            cCuv.Shape := Cuv.Shape;
            cCuv.Selected := False;
            for jj := 0 to High(solution[ii]) do
            begin
               p2 := Point2d( solution[ii][jj].X/100, solution[ii][jj].Y/100 );
               cCuv.AddPoint(p2);
            end;
            AddCurve(cCuv);
        Finally
        End;
    end;

begin
  if SelectedCount>0 then begin
     PoligonizeAll(0);
     VektorisationAll(0.1);
     sIdx := 0;
  For sIdx := 0 to Pred(FCurveList.Count) do
  if (SelectedCount>0) and (Curves[sIdx]<>nil) then
      if Curves[sIdx].Selected then begin
//         Curves[sIdx].Selected := false;
         Cuv := Curves[sIdx];
  Try
     Cuv.ToPath(clipI,100);

     Clip := TClipper.Create;

     Clip.AddPath(clipI, ptClip, true);
     for I := 0 to Pred(FCurveList.Count) do
       if i<>sIdx then
          if CheckForOverLaps(Cuv, Curves[i]) then begin
            Curves[i].ToPath(subjI,100);
            Clip.AddPath(subjI, ptSubject, true);
            Curves[i].Visible := False;
          end;

     Clip.Execute (ClipType, solution, pftNonZero, pftNonZero);

     if solution<>nil then begin
        AddSolution(solution);
        Curves[Fcurvelist.Count-1].Name := 'Clipper';
        Cuv.Visible := False;
        DeleteInvisibleCurves;
     end;
  Finally
     Clip.Free;
  End;
  end;
     DeleteInvisibleCurves;
     Repaint;
  end;
end;

procedure TALSablon.cUnion;
begin
  ClipperBool(ctUnion);
end;

procedure TALSablon.cIntersection;
begin
  ClipperBool(ctIntersection);
end;

procedure TALSablon.cDifference;
begin
  ClipperBool(ctDifference);
end;

procedure TALSablon.cXor;
begin
  ClipperBool(ctXor);
end;


// ========================= CUT PLAN ROUTINS =================================

{Az objektum körül kontúrozása (régi módszer) : mûszer korrekció
   In: Cuv        = Zárt sokszog;
       OutCode    = a vágóél sugara :
                    0  = eredeti kontúr vonalon,
                    +n = kívül haladás,
                    -n = belül haladás }
function TALSablon.ObjectContour(Cuv: TCurve;OutCode:double): TCurve;
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
   Result := nil;
if (Cuv<>nil) then
if (Cuv.Fpoints.Count>2) and Cuv.Closed then begin
Try

   // Indirekt körüljárás
   Vektorisation(0.01,Cuv);
   dir := Cuv.IsDirect;
   if dir then begin
      Cuv.InversPointOrder;
      OutCode:=-OutCode;
   end;

(*
   // A legnagyobb y koordinátájú pont legyen a 0. bekezdési pont
   y := 10e-10; n:=0;
   For i:=0 to Pred(Cuv.Count) do
       if cuv.Points[i].y > y then begin
          y := cuv.Points[i].y;
          n := i;
       end;
   cuv.SetBeginPoint(n);
*)
   TempCurve.ClearPoints;
   TempCurve.Shape := dmPolyLine;
   p0 := Cuv.GetPoint2d(0);
   p1 := p0;
   n  := Cuv.Fpoints.Count;
   For i:=1 to n do begin
       p2 := Cuv.GetPoint2d(i);
       if n=i then
          p2 := p0;
       E1:=SzakaszParhuzamosEltolas(p1,p2,OutCode, not dir);
       pp1 := Point2d(E1.x1,E1.y1);
       pp2 := Point2d(E1.x2,E1.y2);
       d1  := cuv.GetDistance( pp1 );
       d2  := cuv.GetDistance( pp2 );

       // Ha az eltolt szakasz végpontjai távolabb vannak mint OutCode
          TempCurve.AddPoint(pp1);
          TempCurve.AddPoint(pp2);

       alfa2 := RelAngle2d(p1,p2);
       dif := RelSzogdiff(alfa1,alfa2);
       if (i>1) and (dif<0) then
       begin
            // Hegyeszögeknél a kontúr húr felezõpontját eltoljuk OutCode távra
            fp1 := TempCurve.GetPoint2d(TempCurve.Fpoints.Count-3);
            fp2 := TempCurve.GetPoint2d(TempCurve.Fpoints.Count-2);
            fp  := FelezoPont(fp1,fp2);
            d   := RelDist2d(p1,fp);
            if d<>0 then begin
            fp  := Point2d(p1.x+(fp.x-p1.x)*OutCode/d,p1.y+(fp.y-p1.y)*OutCode/d);
            TempCurve.InsertPoint(TempCurve.Fpoints.Count-2,fp.x,fp.y);
            end;
       end;
       p1 := p2;
       alfa1 := alfa2;

   end;
       p2 := TempCurve.GetPoint2d(0);
       TempCurve.AddPoint(p2.x,p2.y);
       alfa2 := RelAngle2d(p1,p2);
       dif := RelSzogdiff(alfa1,alfa2);
       if (i>1) and (dif<0) then
       begin
            // Hegyeszögeknél a kontúr húr felezõpontját eltoljuk OutCode távra
            fp1 := TempCurve.GetPoint2d(TempCurve.Fpoints.Count-2);
            fp2 := TempCurve.GetPoint2d(TempCurve.Fpoints.Count-1);
            fp  := FelezoPont(fp1,fp2);
            d   := RelDist2d(p1,fp);
            if d<>0 then begin
            fp  := Point2d(p1.x+(fp.x-p1.x)*OutCode/d,p1.y+(fp.y-p1.y)*OutCode/d);
            TempCurve.InsertPoint(TempCurve.Fpoints.Count-1,fp.x,fp.y);
            end;
            TempCurve.DeletePoint(TempCurve.Fpoints.Count-1);
       end;

finally

  // Megvizsgáljuk, hogy a kontúr minden pontja megfelelõ-e
  // Ha a kontúr 2 szakasza metsz egymást, akkor képezzük a két szakasz
  //    metszéspontját p0 és a közbülsõ pontok kijelölése után az uj metszéspontot
  //    beszúrjuk

  TempCurve.SelectAllPoints(False);
  i := 0;
  While i < Pred(TempCurve.Count-1) do begin
      p1 := TempCurve.Points[i];
      p2 := TempCurve.Points[i+1];
      metszes := False;
      For j:=i+1 to Pred(TempCurve.Count-1) do begin
          p3 := TempCurve.Points[j];
          p4 := TempCurve.Points[j+1];
          if SzakaszSzakaszMetszes(p1,p2,p3,p4,p0) then begin
             metszes := True;
             Idx1:=i+1; Idx2:=j;
                 for n:=Idx1 to Idx2 do
                     TempCurve.SelectPoint(n,True);

             TempCurve.InsertPoint(i+1,p0.x,p0.y);
             TempCurve.SelectPoint(i+1,False);
             i := j+1;
             Break;
          end;

      end;
      if not metszes then Inc(i);
  end;
  // Töröljük a kijelölt fölösleges pontokat
  TempCurve.DeleteSelectedPoints;

  Result:= TempCurve;
end;
end;
end;

procedure TALSablon.SetContour(AIndex: Integer; Radius: double);
var isDir: boolean;
begin
if Curves[AIndex].Closed then begin
   Curves[AIndex].SetClipperContour(Radius);
//  Curves[AIndex].Contour := Curves[AIndex].GetContour(Radius);
//  Curves[AIndex].Contour := GetClipperContour( Curves[AIndex], Radius);
  Curves[AIndex].Contour.SetBeginPoint( Curves[AIndex].Contour.GetNearestPoint( Curves[AIndex].Points[0] ) );
  Curves[AIndex].Contour.InversPointOrder;
end;
end;

procedure TALSablon.SetCoordHint(const Value: boolean);
begin
  fCoordHint := Value;
  THintLabel.Visible := Value;
end;

function TALSablon.GetContour(Cuv: TCurve; OutCode: double): TCurve;
begin

end;

procedure TALSablon.SetAllContour;
var i: integer;
begin
   For i:=0 to Pred(FCurvelist.Count) do begin
       if Curves[i].Count>3 then begin
          SetContour(i,ContourRadius);
          Vektorisation(0.05,Curves[i].Contour);
       end;
   end;
end;

// Automatikus vágási terv készítés
procedure TALSablon.AutoCutSequence(BasePoint: TPoint2d; Sorting: boolean;
                                    CutMethod: byte);
var i,j,idx: integer;
    x,y,d,dd : double;
    p0,p,p1 : TPoint2d;
    BaseCurve : TCurve;
    Cuv,CC    : TCurve;
    cuvIDX,pIdx: integer;
    Child: boolean;
    KonturHossz: double;     // Kontúr hossza
    KonturSzelet: double;    // Kontúr egy szeletének hossza
    cCount: integer;
    R      : TRect2d;
    sc     : integer;
    dx,dy,m: double;
    h      : integer;

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
  SelectedVisible := true;
  if Assigned(FPlan) then FPlan(Self,0,0);
  ActionMode := amAutoPlan;
  STOP := False;
  oldCursor := Cursor;
  Screen.Cursor := crHourGlass;
  Loading := True;
  AutoUndo := False;

  InnerStream.Clear;    // Ide rendezzük a vágási mintát

  if Assigned(FPlan) then FPlan(Self,0,0);


  // Töröljük az összes nyílt alakzatot
  SignedAll(False);
  VisibleAll;
  SelectAll(False);
  SelectAllPolylines;
  DeleteSelectedCurves;
  PoligonizeAll(0);
  StripAll;
  AutoSortObject(BasePoint);
  SetNearestBeginPoint(BasePoint);

  if Assigned(FPlan) then FPlan(Self,1,0);

  Case CutMethod of
  0,1 :
      begin
         R := GetDrawExtension;
         m := Grid.Margin;
         dx := 2*m-R.x1;
         dy := Paper.y-2*m-R.y2;
         Eltolas(dx,dy);
         R := GetDrawExtension;

         // Keret létrehozása a rajz körül margin távolságban
         R := Rect2d(R.x1-m,R.y1-m,R.x2+m,R.y2+m);

         h:=MakeCurve('Border',-1,dmRectangle,True,True,True);
         AddPoint(H,R.x1,R.y1);
         AddPoint(H,R.x1,R.y2);
         AddPoint(H,R.x2,R.y2);
         AddPoint(H,R.x2,R.y1);
         StripAll;
      end;
  end;

//  ContourRadius := ContourRadius+1;
  SetAllContour;
  invalidate;
// exit;
Try

  p0 := BasePoint;
  cuvIDX := 0;
  cCount := VisibleCount;


  if VisibleCount>0 then begin
        // Az elsõ polygon kiolvasása
        if Assigned(FAutoSortEvent) then FAutoSortEvent(Self,2,CuvIdx);
        if Sorting then begin
           GetNearestPoint(p0,cuvIDX,pIdx);
           SetBeginPoint(cuvIDX,pIdx);
        end else
           CuvIdx := NextVisible;
        BaseCurve := FCurveList.Items[cuvIDX];
        GetPoint(CuvIdx,0,x,y);
        // Elsõ megközelítõ vonal képzése Origóból
        idx:=MakeCurve('Cut',-1,dmPolyline,True,True,False);
        AddPoint(idx,p0.x,p0.y);
        AddPoint(idx,x,y);
        SaveCurveToStream(innerStream,IDX);
        if CutMethod<2 then
        SaveCurveToStream(innerStream,cuvIDX);
        DeleteCurve(IDX);
  end;

  if CutMethod>1 then
  While VisibleCount>0 do begin

        // Kontúrozás és eredeti Polygon mentése
           BaseCurve := Curves[cuvIDX];

             SetContour(cuvIDX,ContourRadius);
             TempCurve := Curves[cuvIDX].Contour ;
             if TempCurve.IsDirect then TempCurve.InversPointOrder;

           SaveCurveToStream(innerStream,cuvIDX);
           BaseCurve.Visible := False;
//           p := BaseCurve.GetPoint2d(0);
           p := BaseCurve.Contour.Points[0];

           if Assigned(FPlan) then FPlan(Self,2,Trunc((100/cCount)*cCount/(VisibleCount+1)));

        if VisibleCount>0 then begin

           // A következõ polygon kiolvasása
           if Sorting then begin
              GetNearestPoint(p,cuvIDX,pIdx);
              BaseCurve := FCurveList.Items[cuvIDX];
              SetBeginPoint(cuvIDX,pIdx);
              GetPoint(cuvIDX,0,x,y);
              p1:=Point2d(x,y);
           end else begin
              CuvIdx := NextVisible;
              BaseCurve := FCurveList.Items[cuvIDX];
              p1 := BaseCurve.GetPoint2d(0);
           end;

              // Kontúron az optimális útvonal keresés a köv. objektumhoz
              idx:=MakeCurve('Cut',-1,dmPolyline,True,True,False);
              Cuv := Curves[idx];
              Cuv.Visible:=False;

              Cuv.AddPoint(p.x,p.y);
              SetContour(cuvIDX,ContourRadius);
              p1 := BaseCurve.Contour.Points[0];
              Cuv.AddPoint(p1.x,p1.y);

(*
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
*)



//              ContourOptimalizalas(Cuv);
//              p := BaseCurve.GetPoint2d(0);
//              Cuv.AddPoint(p.x,p.y);
              Cuv.Visible:=True;
              SaveCurveToStream(innerStream,IDX);
              DeleteCurve(IDX);
              Invalidate;
        end; // if

  end;

finally

  // A ts stream-re rendezett alakzatok visszatöltése
  FCurveList.Clear;
  innerStream.seek(0,0);
  While innerStream.Size>innerStream.Position do
     LoadCurveFromStream(innerStream);

  // Kilépés az utolsó objektumból a kontúr elsõ pontjába
  idx:=MakeCurve('Back',-1,dmPolyline,True,True,False);
  if CutMethod>1 then begin
     TempCurve := ObjectContour(BaseCurve,ContourRadius);
     TempCurve.GetPoint(0,x,y);
  end else begin
  end;

  AddPoint(idx,x,y);
  // Vissza az Workorigóba
  AddPoint(idx,BasePoint);

  InnerStream.Clear;
  ReOrderNames;
  invalidate;

//  if Assigned(FPlan) then FPlan(Self,3,0);
  ActionMode := amAutoPlan;

  If CutMethod=0 then begin
     // Virtualbox-nál a befoglaló keretet töröljük
     Cuv := FCurveList[1];
     Cuv.DeletePoint(R.x1,R.y1);
     Cuv.DeletePoint(R.x1,R.y2);
     Cuv.DeletePoint(R.x2,R.y2);
     Cuv.DeletePoint(R.x2,R.y1);
     SelectAllPolylines;
     DeleteSelectedCurves;
     AutoSortObject(BasePoint);
     SetNearestBeginPoint(BasePoint);
     Eltolas(-Grid.Margin,Grid.Margin);
     h:=MakeCurve('Line',-1,dmPolyline,True,True,False);
     FCurve := FCurveList.Items[h];
     FCurve.AddPoint(Cuv.Points[0]);
     FCurve.AddPoint(BasePoint);
  end;
  If CutMethod=1 then begin
     // A befoglaló téglalap vágódjon utoljára
     // elsõ 4 pontot a végére másoljuk
     DeleteCurve(0);
     DeleteCurve(1);
     Cuv := FCurveList[0];
     Cuv.DeletePoint(R.x1,R.y1);
     Cuv.DeletePoint(R.x1,R.y2);
     Cuv.DeletePoint(R.x2,R.y2);
     Cuv.DeletePoint(R.x2,R.y1);
     GetNearestPoint( BasePoint,CuvIdx,i );
     SetBeginPoint( CuvIdx,i );
     Cuv.AddPoint(Cuv.Points[0]);
     Cuv.AddPoint(R.x1,R.y2);
     Cuv.AddPoint(R.x2,R.y2);
     Cuv.AddPoint(R.x2,R.y1);
     Cuv.AddPoint(R.x1,R.y1);
     Cuv.InsertPoint(0,R.x1,R.y2);
     Cuv.InsertPoint(0,R.x1,R.y2);
     h:=MakeCurve('Line',-1,dmPolyline,True,True,False);
     FCurve := FCurveList.Items[h];
     FCurve.AddPoint(Cuv.Points[0]);
     FCurve.AddPoint(BasePoint);
  end;

  ActionMode := amNone;
  STOP := False;
  Cursor := oldCursor;
  Loading := False;
  AutoUndo := True;
  Changed := True;

  if CutMethod>1 then Elkerules;

  SignedNotCutting;
  VektorisationAll(0.05);
  if AutoUndo then UndoSave;

  if Assigned(FPlan) then FPlan(Self,4,0);
end;
except
  Screen.Cursor := oldCursor;
  ActionMode := amNone;
  Invalidate;
  Loading := False;
  AutoUndo := True;
end;
SelectedVisible := false;
end;

//=======================  Elkerules  =====================================

    // Belépési és kilépési pontok keresése a kontúron
    // Result = metszéspontok száma
    function TALSablon.ConturInOut(cCuv: TCurve; AP,BP: TPoint2d; var BE,KI: TInOutRec): integer;
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
      For i:=0 to Pred(cCuv.Count) do begin
          P1 := cCuv.GetPoint2d(i);
          if i=Pred(cCuv.Count) then   // Utolsó pont után a 0. pontot kell venni
             P2 := cCuv.Points[0]
          else
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

(*
  ELKERÜLÉSI RUTIN A pontból B pontba
*)
//============================================================================
function TALSablon.ElkerulesAB(Var eCurve: TCurve): boolean;

Var mpArr : array of TmpRec; // Metszett polygonok tömbje
    i,j,k       : integer;
    mpRec       : TmpRec;        // Legközelebbi polygon és pont + d távolság
    BaseCurve   : TCurve;     // Elkerülõ polyline
    TempCurve   : TCurve;     // Kontúr
    Cuv         : TCurve;     // Legközelebbi polygon
    BePont,KiPont : TInOutRec; // Be-ki lépési pontok a kontúron
    mpCount     : integer;    // Kontúr-szakasz metszéspontok száma
    AP,BP       : TPoint2d;   // Szakasz eleje, vége
    KonturHossz : double;     // Kontúr kerülete
    KonturSzelet: double;     // Egy szeletének hossza
    p           : TPoint2d;
    nCikl       : integer;    // Számláló a próbálkozásokhoz


    // Az A ponthoz legközelebbi polygon legközelebbi pontját adja
    function GetNearest(A: TPoint2d): TmpRec;
    var jj: integer;
        Idx: integer;
        dd1,dd: double;
        x,y: double;
        fCuv: TCurve;
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
        fc: TCurve;
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

begin
  Result := True;
  nCikl := 0;

  k := Pred(eCurve.Count);
  AP := eCurve.GetPoint2d(k-1);
  BP := eCurve.GetPoint2d(k);

  // Megkeresem az AP ponthoz legközelebbi polygon legközelebbi pontját
  mpRec := GetNearest(AP);
  Cuv := Curves[mpRec.Cuvidx];
  if mpRec.d<ContourRadius then begin
     // Ha egy polygonhoz túl közel van, akkor kontúron kell haladni a
     // AB húr metszéspontjáig
     TempCurve := Cuv.Contour;
     mpCount := ConturInOut(TempCurve,AP,BP,BePont,KiPont);
     if mpCount=1 then
        TempCurve.InsertPoint(KiPont.Idx,KiPont.mPont.x,KiPont.mPont.y);
     // A kontúr legközelebbi pontjára lépek
     TempCurve.GetNearestPoint(AP,j);
     if mpCount=0 then
        TempCurve.GetNearestPoint(BP,k);
              For i:=j to k do begin
                  p := TempCurve.GetPoint2d(i);
                  eCurve.InsertPoint(Pred(eCurve.Count),p.x,p.y);
              end;
     AP := p;
  end;

  Repaint;

  while IsCutPolygons(AP,BP)>0 do begin
        Cuv:=FCurveList.Items[mpArr[0].Cuvidx];   // = az átmetszett poligon
        TempCurve := Cuv.Contour;
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
              TempCurve.InsertPoint(KiPont.Idx,KiPont.mPont.x,KiPont.mPont.y);
              TempCurve.InsertPoint(BePont.Idx,BePont.mPont.x,BePont.mPont.y);
              Inc(KiPont.Idx);
           end else begin
              TempCurve.InsertPoint(BePont.Idx,BePont.mPont.x,BePont.mPont.y);
              TempCurve.InsertPoint(KiPont.Idx,KiPont.mPont.x,KiPont.mPont.y);
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
                  eCurve.InsertPoint(k,p.x,p.y);
              end
              else begin
              For i:=BePont.Idx to Pred(TempCurve.Count) do begin
                  p := TempCurve.GetPoint2d(i);
                  k := Pred(eCurve.Count);
                  eCurve.InsertPoint(k,p.x,p.y);
              end;
              For i:=0 to KiPont.Idx do begin
                  p := TempCurve.GetPoint2d(i);
                  k := Pred(eCurve.Count);
                  eCurve.InsertPoint(k,p.x,p.y);
              end;
              end;

           end
           else begin

              if BePont.Idx>KiPont.Idx then
              For i:=BePont.Idx downto KiPont.Idx do begin
                  p := TempCurve.GetPoint2d(i);
                  k := Pred(eCurve.Count);
                  eCurve.InsertPoint(k,p.x,p.y);
              end
              else begin
              For i:=BePont.Idx downto 0 do begin
                  p := TempCurve.GetPoint2d(i);
                  k := Pred(eCurve.Count);
                  eCurve.InsertPoint(k,p.x,p.y);
              end;
              For i:=Pred(TempCurve.Count) downto KiPont.Idx do begin
                  p := TempCurve.GetPoint2d(i);
                  k := Pred(eCurve.Count);
                  eCurve.InsertPoint(k,p.x,p.y);
              end;
              end;

           end;
        end;
        Repaint;
        AP := p;

        Application.ProcessMessages;
        if STOP then begin
           STOP:=False;
           Exit;
        end;

        inc( nCikl );
        if nCikl>100 then begin
           Result := False;
           exit;
        end;

  end;

//        ContourOptimalizalas( eCurve );
end;



//=======================  Elkerules  =====================================

procedure TALSablon.Elkerules;
// Sorra veszem a nyílt objektumokat és kontúr optimalizálással
// megkeresem az optimális útvonalat
var i,j    : integer;
    CR     : double;
    cuv    : TCurve;
begin
Try
  if Assigned(FPlan) then FPlan(Self,1,0);
  CR := ContourRadius;
  ContourRadius := ContourRadius*0.8;
//  PontsuritesAll(10);
  SetAllContour;
  for i := 0 to Pred(FCurvelist.Count) do
  begin
    if not Curves[i].Closed then
    begin
       Selected := Curves[i];
       if Curves[i].Count>2 then
       for j := Pred(Curves[i].Count)-1 downto 1 do
           Curves[i].DeletePoint(j);
       if Assigned(FPlan) then FPlan(Self,1,Trunc(100*i/Pred(FCurvelist.Count)));
       cuv := Curves[i];
       ElkerulesAB(cuv);
//       PontSurites(CUV,20);
       ContourOptimalizalas(Cuv);
    end;
  end;
Finally
  ContourRadius := CR;
  SetAllContour;
End;
end;

procedure TALSablon.Elkerules1;
Type mpRec = record
       idx : integer;
       d   : double;
     end;

var i,j,k: integer;
    BaseCurve,Cuv,TempCurve: TCurve;
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
    ciklusCounter: integer;
    CR: double;

label ujra;

    // megszámolja, hogy az AB szakasz, hány polygont metsz
    // és feltölti az mpArr tömböt az A ponttól való távolság sorrendjében

    function IsCutPolygons(A,B: TPoint2d): integer;
    var ii: integer;
        fc: TCurve;
        pCount : integer;
        dd: double;
        pr: mpRec;
        csere: boolean;
        contCuv : TCurve;
        R: TRect2d;
    begin
         pCount := 0;
         SetLength(mpArr,1000);
         For ii:=0 to Pred(FCurveList.Count) do begin
             fc:=FCurveList.Items[ii];
             if fc.Shape=dmPolygon then begin
                R := fc.GetBoundsRect;
                R := Rect2d(R.X1-delta,R.y1-delta,R.x2+delta,R.y2+delta);
                if IsSzakaszNegyszogMetszes(A,B,R) then begin
                   if fc.Contour=nil then begin
                      fc.SetContour(ContourRadius);
                      Vektorisation(0.1,fc.Contour);
                   end;
                   if (fc.Contour.IsCutLine(A,B,dd)) then begin
                      mpArr[pCount].idx := ii;
                      mpArr[pCount].d   := dd;
                      Inc(pCount);
                   end;
                end;
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


    function GetNearPoint(cc: TCurve; A: TPoint2d): integer;
    var jj: integer;
        dd1,dd: double;
        x,y: double;
    begin
    Result := -1;
    if cc<>nil then begin
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
    end;

begin
  STOP := False;
  SetAllContour;
  SignedNotCutting;
  invalidate;
  n:=0;
  // Veszem a polyline-okat és metszést vizsgálok polygon-okkal
  For i:=0 to Pred(FCurveList.Count) do begin
      BaseCurve:=FCurveList.Items[i];    // = a polyline
      Selected := BaseCurve;
      szaz := Trunc(100*(i/FCurveList.Count));
      if Assigned(FPlan) then FPlan(Self,3,szaz);

ujra: if BaseCurve.Shape=dmPolyline then
      begin

         // Veszem a polyline 2 utolsó pontját
         k:=Pred(BaseCurve.Fpoints.Count);
         p1:=BaseCurve.GetPoint2d(k-1);
         p2:=BaseCurve.GetPoint2d(k);

         // ennyi db poligont vág át : mpArr tömb tartalmazza a vágott poligonokat
         Cutting:=IsCutPolygons(p1,p2);


      While Cutting>0 do begin
            k:=Pred(BaseCurve.Fpoints.Count);
            p1:=BaseCurve.GetPoint2d(k-1);
            p2:=BaseCurve.GetPoint2d(k);
            Application.ProcessMessages;
            if STOP then
               Break;

             Cuv:=FCurveList.Items[mpArr[0].idx];   // = az átmetszett poligon
             if Cuv.Shape=dmPolygon then begin

                   TempCurve := Cuv.Contour;
                   Vektorisation(0.1,TempCurve);
//                   ContourOptimalizalas(BaseCurve);

                // Megkeressük a kontúr A ponthoz legközelebbi pontját
                pIdx := GetNearPoint(TempCurve,p1);
                p1 := TempCurve.GetPoint2d(pIdx);
                // Addig haladunk a kontúron míg a poligont metszi a maradék szakasz
                metszes := Cuv.IsCutLine(p1,p2);
                if metszes then begin
                   ciklusCounter:=0;
                While Cuv.IsCutLine(p1,p2) or TempCurve.IsCutLine(p1,p2) do begin
                      k:=Pred(BaseCurve.Fpoints.Count);  // Cél pont
                      p2:=BaseCurve.GetPoint2d(k);
                      BaseCurve.InsertPoint(k,p1.x,p1.y);
                      Inc(pIdx);
                      if pIdx>Pred(TempCurve.Count) then pIdx:=0;
                      p1 := TempCurve.GetPoint2d(pIdx);
                      Application.ProcessMessages;
                      Inc(ciklusCounter);
                      if STOP or (ciklusCounter>10000) then
                         Break;
                end;
                      k:=Pred(BaseCurve.Fpoints.Count);  // Cél pont
                      p1 := TempCurve.GetPoint2d(pIdx);
                      BaseCurve.InsertPoint(k,p1.x,p1.y);
                      Application.ProcessMessages;
                      if STOP then Break;
                end
                else begin
                      k:=Pred(BaseCurve.Fpoints.Count);  // Cél pont
                      p1 := TempCurve.GetPoint2d(pIdx);
                      BaseCurve.InsertPoint(k,p1.x,p1.y);
                      Break;
                end;
             end;
            // Veszem a polyline 2 utolsó pontját
            k:=Pred(BaseCurve.Fpoints.Count);
            p1:=BaseCurve.GetPoint2d(k-1);
            p2:=BaseCurve.GetPoint2d(k);
            Cutting:=IsCutPolygons(p1,p2);
            if STOP then Break;
            if (ciklusCounter>10000) then
               Cutting:=0;
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
   if Assigned(FPlan) then FPlan(Self,3,0);
end;


//   ContourOptimalizalas
//   ----------------------------------------------------------------------------
//   Lényege: A kontúron haladva növekvõ indexek szerint, minden esetben megvizsgáljuk,
//   hogy a végponttól visszafelé haladva melyik az az elsõ kontúrpont, melyre
//   közvetlen rálátás van. Nyilván, a közbülsõ pontok törölhetõk.
//
procedure TALSablon.ContourOptimalizalas(var Cuv: TCurve);
    Type mpRec = record
         idx : integer;
         d   : double;
         end;
    var kezdP,vegP     : TPoint2d;
        ii,jj,kk,nn,n  : integer;
        CR             : double;
        PointsArray    : array of TPoint2d;
        cCuv           : TCurve;
        mpArr          : array of mpRec;

    // megszámolja, hogy az AB szakasz, hány polygont metsz
    // és feltölti az mpArr tömböt az A ponttól való távolság sorrendjében

    function IsCutPolygons(A,B: TPoint2d): integer;
    var i: integer;
        fc: TCurve;
        pCount : integer;
        dd: double;
        pr: mpRec;
        csere: boolean;
        R: TRect2d;
    begin
         pCount := 0;
         SetLength(mpArr,1000);
         For i:=0 to Pred(FCurveList.Count) do begin
             if Curves[i].Shape=dmPolygon then begin
                fc := Curves[i].Contour;
                   if (fc.IsCutLine(A,B,dd)) then begin
                      mpArr[pCount].idx := i;
                      mpArr[pCount].d   := dd;
                      Inc(pCount);
                   end;
             end;
         end;
         // Tömb rendezése távolság szerint növekvõen
         mpArr := Copy(mpArr,0,pCount);
         Result := pCount;
         i:=0; csere:=True;
         While csere do begin
            csere := False;
            for i:=0 to pCount-2 do begin
                if mpArr[i].d > mpArr[i+1].d then begin
                   pr := mpArr[i]; mpArr[i]:=mpArr[i+1]; mpArr[i+1]:=pr;
                   csere := True;
                end;
            end;
         end;
    end;

    begin
      STOP := False;
      CR := ContourRadius;
      ContourRadius := ContourRadius-0.3;
      SetAllContour;
      Cuv.SelectAllPoints(False);

      nn := Pred(Cuv.Count);
      ii := 0;

      if Cuv.Count>2 then
      While ii<=(nn) do begin
            kezdP := Cuv.Points[ii];
            // Keressük a legtávolabbi, közvetlen rálátási pontot
            for jj:=nn downto (ii+1) do begin
                vegP := Cuv.Points[jj];
                if (IsCutPolygons(kezdP,vegP)=0) then
                   Break;
                Application.ProcessMessages;
                if STOP then Break;
            end;

            if (jj-ii>1) then
            begin
                for kk := ii+1 to jj-1 do           // törli a közbülsõ pontokat
                    Cuv.SelectPoint(kk,true);
                ii := jj+1;
            end else
                Inc(ii);

            Application.ProcessMessages;
            if STOP then Break;
      end;
      Cuv.DeleteSelectedPoints;
(*
      // Urolsó két pont szakaszának elkerülése
      ii  := Pred(Cuv.Count);
      if (IsCutPolygons(Cuv.Points[ii-1],Cuv.Points[ii])<>0) then
      Try
        cCuv  := TCurve.Create;
        cCuv.Shape := dmLine;
        cCuv.Closed := False;
        cCuv.AddPoint(Cuv.Points[ii-1]);
        cCuv.AddPoint(Cuv.Points[ii]);
        ElkerulesAB( cCuv );
      finally
        Cuv.DeletePoint(Pred(Cuv.Count));
        Cuv.DeletePoint(Pred(Cuv.Count));
        for jj:=0 downto Pred(cCuv.Count) do
            Cuv.AddPoint(cCuv.Points[jj]);
        cCuv.Free;
      end;
*)
      SetLength(mpArr,0);
      ContourRadius := CR;
      SetAllContour;

end;  // End ContourOptimalizalas

procedure TALSablon.CMChildkey(var msg: TCMChildKey);
var dx,dy: integer;
    k:integer;
begin
  k:=16;
  dx := 0; dy:=0;
  Case msg.charcode of
    VK_ESCAPE  : begin
                   UndoStop;
                   STOP := True;
                   ActionMode := amNone;
                   DrawMode   := dmNone;
                   SelectAll(False);
                   UndoStart;
                   if SelectedFrame.Visible then begin
                      DoSelectedFrame(false);
                  end;
                 end;
    VK_RETURN,190  :
                 if SelectedFrame.Visible then begin
                    DoSelectedFrame(true);
                 end else
                    ZoomDrawing;

    VK_DELETE : DeleteSelectedCurves;

    18: // Alt
                if EnableSelectedFrame then Cursor := crCross;
    VK_ADD     :
                 if SelectedFrame.Visible then
                 begin
                    SelectedFrame.Magnify(1.01);
                    repaint;
                 end else
                 begin
                      FCentralisZoom := True;
                      Zoom:=1.1*Zoom;
                      FCentralisZoom := False;
                 end;
    VK_SUBTRACT,189:
                 if SelectedFrame.Visible then
                 begin
                    SelectedFrame.Magnify(0.99);
                    repaint;
                 end else
                 begin
                      FCentralisZoom := True;
                      Zoom:=0.9*Zoom;
                      FCentralisZoom := False;
                 end;
    VK_F4      : ShowPoints := not ShowPoints;
(*
    VK_LEFT    : dx:=k;
    VK_RIGHT   : dx:=-k;
    VK_UP      : dy:=-k;
    VK_DOWN    : dy:=k;*)
  End;
//  if (dx<>0) or (dy<>0) then MoveWindow(dx,dy);
  inherited;
end;

(*
procedure TALSablon.WM_KeyDown(var Msg: TWMKeyDown);
var dx,dy: integer;
    k:integer;
begin
  k:=16;
  dx := 0; dy:=0;
  case Msg.CharCode of
    VK_LEFT    : dx:=k;
    VK_RIGHT   : dx:=-k;
    VK_UP      : dy:=-k;
    VK_DOWN    : dy:=k;
  end;
  if (dx<>0) or (dy<>0) then MoveWindow(dx,dy);
  inherited;
end;

procedure TALSablon.WMKeyUp(var Msg: TWMKeyDown);
begin

end;
*)

initialization
  FormatSettings.DecimalSeparator := '.';
  VirtualClipboard := TMemoryStream.Create;
finalization
  VirtualClipboard.Free;
end.

