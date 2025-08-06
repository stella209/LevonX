unit AL_PapirGL;

interface
Uses
    Windows, SysUtils, Classes, Graphics, Controls, StdCtrls, ClipBrd, Math,
    Extctrls, Messages, Dialogs, Forms, NewGeom, DGrafik, B_Spline, Szoveg, Szamok,
    StObjects, AL_GL, alOpenGL, Clipper;

Type

  TALPapirGL = class(TAL_CustomOpenGL)
  private
    Hint1   : THintWindow;
    HintActive : boolean;
    fAutoUndo: boolean;
    fActLayer: integer;
    fActionMode: TActionMode;
    FSTOP: boolean;
    FGraphTitle: Str32;
    fGrid: TGrid;
    fChanged: boolean;
    fDefaultLayer: Byte;
    FContourRadius: double;
    fCoordLabel: TLabel;
    fShowPoints: boolean;
    FSensitiveRadius: integer;
    fHinted: boolean;
    fWorking: boolean;
    FDemo: boolean;
    FSablonSzinkron: boolean;
    fLocked: boolean;
    FMMPerLepes: extended;
    fChangeCurve: TChangeCurve;
    fChangeSelected: TChangeCurve;
    fChangeMode: TChangeMode;
    fChangeWindow: TChangeWindow;
    fSelected: TCurve;
    FDrawMode: TDrawMode;
    FTitleFont: TFont;
    FMouseEnter: TMouseEnter;
    FMouseLeave: TMouseEnter;
    fNewBeginPoint: TNewBeginPoint;
    FUndoRedoChangeEvent: TUndoRedoChangeEvent;
    fWorkOrigo: TPoint2d;
    FOnBeforePaint: TNotifyEvent;
    FOnAfterPaint: TNotifyEvent;
    FAppend: boolean;
    FEditable: boolean;
    FOnInit: TNotifyEvent;
    FFilename: TFileName;
    FNewFile: TNewFile;
    fpFazis: integer;
    FLoading: boolean;
    FSelectedIndex: integer;
    FAutoSortEvent: TAutoSortEvent;
    FCentralisZoom: boolean;
    fOrigo: TPoint2d;
    FPlan: TProcess;
    FEnableSelectedFrame: boolean;
    FSelectedFrame: TSelectedArea;
    FVisibleContours: Boolean;
    FDownUp: boolean;
    Procedure CMChildkey( Var msg: TCMChildKey ); message CM_CHILDKEY;
    procedure CMMouseEnter(var msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var msg: TMessage); message CM_MOUSELEAVE;
    procedure SetActionMode(const Value: TActionMode);
    procedure SetGraphTitle(const Value: Str32);
    procedure SetDefaultLayer(const Value: Byte);
    procedure SetSensitiveRadius(const Value: integer);
    procedure SetShowPoints(const Value: boolean);
    procedure SetDrawMode(const Value: TDrawMode);
    procedure SetLocked(const Value: boolean);
    procedure SetSelected(const Value: TCurve);
    procedure SetTitleFont(const Value: TFont);
    procedure SetWorking(const Value: boolean);
    procedure SetWorkOrigo(const Value: TPoint2d);
    procedure SetEditable(const Value: boolean);
    procedure SetFilename(const Value: TFileName);
    procedure SetpFazis(const Value: integer);
    procedure On_Drawing;
    procedure SetLoading(const Value: boolean);
    procedure ChangeCursor;
    procedure SetSelectedIndex(const Value: integer);
    procedure SetWindow(const Value: TRect2d);
    function GetWindow: TRect2d;
    procedure GridDraw;  // GDI grid drawing
    procedure DrawMouseCross(o:TPoint;PenMode:TPenMode);
    function GetCurves(AIndex: integer): TCurve;
    procedure SetCurves(AIndex: integer; const Value: TCurve);
    procedure SetEnableSelectedFrame(const Value: boolean);
    procedure SetVisibleContours(const Value: Boolean);
    procedure SetDownUp(const Value: boolean);
  protected
    DrawBmp             : TBitMap;
    UR                  : TUndoRedo;  // Undo-Redo object
    FCurve              : TCurve;     // Cuve for general purpose
    oldCentrum          : TPoint2d;   //
    Origin,MovePt       : TPoint;
    oldOrigin,oldMovePt : TPoint;
    MouseInOut          : integer;    // Egér belép:1, bent van:0, kilép:-1
    NCH                 : integer;    // New Curve handle
    rrect               : TRect2d;    // Rectangle for rect or window
    polygonContinue     : boolean;    // Polygon continue;
    MaxPointsCount      : integer;    // Max. point in Curve
    // Rotation variables
    RotCentrum          : TPoint2d;   // Centrum of rotation
    RotStartAngle       : TFloat;     // Rotate curves start angle
    _RotAngle           : TFloat;     // Rotation angle
    oldCursorCross      : boolean;
    Hintstr             : string;
    oldHintStr          : string;
    HintRect            : TRect;

    Paning              : boolean;
    Zooming             : boolean;
    painting            : boolean;
    HClip               : HRgn;
    oldCursor           : TCursor;

    DXFOut              : TDXFOut;
    HRT                 : THRTimer;           // Precíz idõzítõ

    procedure Change(Sender: TObject);
//    procedure NotifyPaint(Sender: TObject);
    procedure ChangeCentrum(Sender: TObject);
    procedure ShowHintPanel(Show: Boolean);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure KeyDown(var Key: Word;Shift: TShiftState); override;
    procedure KeyUp(var Key: Word;Shift: TShiftState); override;
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
    CPx           : TFloat;
    CPy           : TFloat;
    ActText       : Str32;
    InnerStream   : TMemoryStream;     // memorystream for inner use
    oldFile       : boolean;
    WorkPosition  : TWorkPosition;
    WRect         : TRect;             {A munkapont alatti terület mentéséhez}
    WBmp          : TBitmap;
    newGraphic    : boolean;           {It must to generate new list}
    Moving        : boolean;
    pClosed,pOpened,pSelected : TPen;

    tegla            : T2Point2d;       // For drawing
    VirtualClipboard : TMemoryStream;   // Store List of vectorial curves for public
    ClipboardStr     : WideString;      // Save draw to clipboard as text

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Init(Sender: TObject);
    procedure On_Paint(Sender: TObject);
    procedure PaintGDI;
    procedure PaintGL;
    procedure DoPaint;              // Forces the repaint with new generate of draw

    function  OrigoToCent:TPoint2D;
    function  CentToOrigo(c:TPoint2D):TPoint2D;

    {Teljes papír az ablakban}
    procedure ZoomDrawing;
    procedure CurveToCent(AIndex: Integer);
    procedure NewOrigo(x,y:extended);
    function GetDrawExtension: TRect2d;
    function IsRectInWindow(R: TRect2d): boolean;
    function IsPaperInWindow: boolean;
    function IsPointInWindow(p: TPoint2d): boolean;

    function LoadFile(fnev: string): boolean;
    function LoadGraphFromFile(const FileName: string): Boolean;
    procedure LoadGraphFromMemoryStream(stm: TMemoryStream);
    procedure SaveGraphToMemoryStream(var stm: TMemoryStream);
    function SaveGraphToFile(const FileName: string): Boolean;
    function LoadOldGraphFromFile(const FileName: string): Boolean;
    function LoadFromDXF(const FileName: string): Boolean;
    function SaveToDXF(const FileName: string):boolean;
    function LoadFromPLT(const FileName: string): Boolean;
    procedure LoadFromDAT(Filename: STRING);
    function SaveToDAT(Filename: STRING):boolean;
    function SaveToTXT(Filename: STRING):boolean;
    procedure DXFCurves;

    function LoadCurveFromStream(FileStream: TStream): Boolean;
    function SaveCurveToStream(FileStream: TStream;
      Item: Integer): Boolean;

    { Curves and process}
    function MakeCurve(const AName: Str32; ID: integer; Shape: TDrawMode;
             AEnabled, AVisible, AClosed: Boolean): Integer;
    procedure Clear;
    function  AddCurve(ACurve: TCurve):integer;
    procedure DeleteCurve(AItem: Integer);
    procedure DeleteSelectedCurves;
    procedure DeleteInvisibleCurves;
    procedure DeleteEmptyCurves;
    procedure InsertCurve(AIndex: Integer; Curve: TCurve);
    function  GetCurveName(H: Integer): Str32;
    function  GetCurveHandle(AName: Str32): Integer;
    procedure ReOrderNames;
    function  ShapeCount(Shape: TDrawMode): Integer;

    procedure AddPoint(AIndex: Integer; X, Y: TFloat); overload;
    procedure AddPoint(AIndex: Integer; P: TPoint2d); overload;
    procedure InsertPoint(AIndex,APosition: Integer; X,Y: TFloat); overload;
    procedure InsertPoint(AIndex,APosition: Integer; P: TPoint2d); overload;
    procedure DeletePoint(AIndex,APosition: Integer);
    procedure DeleteSamePoints(diff: TFloat);
    procedure ChangePoint(AIndex,APosition: Integer; X,Y: TFloat); overload;
    procedure ChangePoint(AIndex, APosition: Integer; P: TPoint2d); overload;
    procedure DoMove(Dx,Dy: Integer);  // Move a point in curve
    procedure GetPoint(AIndex,APosition: Integer; var X,Y: TFloat);
    function  GetPoint2d(AIndex,APosition: Integer): TPoint2d;
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
    procedure Poligonize(Cuv: TCurve; Count: integer);
    procedure VektorisationAll(MaxDiff: TFloat);
    procedure Vektorisation(MaxDiff: TFloat; Cuv: TCurve);
    procedure PontSurites(Cuv: TCurve; Dist: double);
    procedure PontSuritesAll(Dist: double);

    procedure CheckCurvePoints(X, Y: Integer);

    { Select }
    procedure SelectAll(all: boolean);
    procedure ClosedAll(all: boolean);
    procedure SelectAllPolylines;
    procedure SelectAllPolygons;
    procedure SelectParentObjects;
    procedure SelectChildObjects;
    procedure EnabledAll(all: boolean);
    procedure SignedAll(all: boolean);
    procedure SignedNotCutting;
    function  GetSelectedArea(var RR: TRect2d): boolean;
    procedure SelectAllInArea(R: TRect2D);
    function  EnumAllInArea(R: TRect2D; var aList: array of integer): integer;

    { Transformations }
    procedure Normalisation(Down: boolean);
    procedure NormalisationEx(Down: boolean);
    procedure Eltolas(dx,dy: double);
    procedure Nyujtas(tenyezo:double);
    procedure MagnifySelected(Cent: TPoint2d; Magnify: TFloat);

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
    procedure AutoCutSequence(BasePoint: TPoint2d; Sorting: boolean;
                                         CutMethod: byte);
    procedure AutoSTRIP(FileName: string; BasePoint: TPoint2d);
    procedure InitParentObjects;
    function  IsParent(AIndex: Integer): boolean; overload;
    function  IsParent(x, y: TFloat): boolean; overload;
    function  GetInnerObjectsCount(AIndex: Integer): integer;
    function  GetParentObject(AIndex: Integer): integer; overload;
    function  GetParentObject(x,y: TFloat): integer; overload;
    function  OutLineObject(AIndex: Integer; delta: real): TCurve;
    function  ObjectContour(Cuv: TCurve;OutCode:double): TCurve;
    procedure SetAllContour;
    procedure StripObj12(AParent,Achild: integer);
    procedure StripChildToParent(AIndex: integer);
    procedure StripAll;
    procedure ContourOptimalizalas(var Cuv: TCurve);
    function  IsCutObject(p1,p2: TPoint2d; var Aindex: integer): boolean;
    procedure Elkerules;
    procedure ElkerulesAB(var eCurve: TCurve);

    { Working }
    procedure DrawWorkPoint(x,y:double);
    procedure ClearWorkPoint;
    procedure WorkpositionToCentrum;
    procedure TestVekOut(dx,dy:extended);
    procedure TestWorking(AObject,AItem:integer);

    { Paint routines for OpenGL }
    procedure GenerateList;
    procedure DrawCurve(Cuv: Tcurve);
    procedure DrawPoints(Cuv: Tcurve);
    procedure DrawBeginPoints(Cuv: Tcurve);

    // SelectedFrame
    procedure DrawSelectedFrame;
    procedure LoadSelectedFrame;
    procedure AdjustSelectedFrame;

    { Clipper }
    procedure ClipperBool(ClipType: TClipType);
    procedure cUnion;
    procedure cIntersection;
    procedure cDifference;
    procedure cXor;


    property pFazis            : integer read fpFazis write SetpFazis;    // Drawing phase
    property Loading           : boolean read FLoading write SetLoading;
    property Origo             : TPoint2d read fOrigo write FOrigo;
    property WorkOrigo         : TPoint2d read fWorkOrigo write SetWorkOrigo;
    property SelectedIndex     : integer read FSelectedIndex write SetSelectedIndex;
    property CentralisZoom     : boolean  read FCentralisZoom write FCentralisZoom;
    property Window            : TRect2d read GetWindow write SetWindow;
    property Curves[AIndex: integer] : TCurve read GetCurves write SetCurves;

  published
    property ActionMode        : TActionMode read fActionMode write SetActionMode;
    property ActLayer          : integer read fActLayer write fActLayer default 0;
    property Append            : boolean read FAppend write FAppend default False;
    property AutoUndo          : boolean read fAutoUndo write fAutoUndo;
    property BackColor;
    property Changed           : boolean read fChanged write fChanged;
    property CoordLabel        : TLabel read fCoordLabel write fCoordLabel;
    // Kontúr vonal távolsága az objektumtól
    property ContourRadius     : double read FContourRadius write FContourRadius;
    property DefaultLayer      : Byte read fDefaultLayer write SetDefaultLayer default 0;
    property Demo              : boolean read FDemo write FDemo default False;
    property DownUp: boolean read FDownUp write SetDownUp default True;
    property DrawMode          : TDrawMode read FDrawMode write SetDrawMode;
    property Editable          : boolean read FEditable write SetEditable;
    property EnableSelectedFrame: boolean read FEnableSelectedFrame write SetEnableSelectedFrame;
    property Filename          : TFileName read FFilename write SetFilename;
    property GraphTitle        : Str32 read FGraphTitle write SetGraphTitle;
    property Grid;
    property Hinted            : boolean read fHinted write fHinted;
    property Locked            : boolean read fLocked write SetLocked;  // Editable?
    property MMPerLepes        : extended read FMMPerLepes write FMMPerLepes;
    property Paper;
    property SablonSzinkron    : boolean read FSablonSzinkron write FSablonSzinkron;
    property Selected          : TCurve read fSelected write SetSelected;
    property SelectedFrame     : TSelectedArea read FSelectedFrame write FSelectedFrame;
    // Cursor sensitive radius of circle around of curves' points
    property SensitiveRadius   : integer read FSensitiveRadius write SetSensitiveRadius;
    property ShowPoints        : boolean read fShowPoints write SetShowPoints;
    property STOP              : boolean read FSTOP write fSTOP;
    property TitleFont         : TFont read FTitleFont write SetTitleFont;
    property VisibleContours   : Boolean read FVisibleContours write SetVisibleContours;
    property Working           : boolean read fWorking write SetWorking;
    property OnChangeCurve     : TChangeCurve read fChangeCurve write fChangeCurve;
    property OnChangeMode      : TChangeMode read fChangeMode write fChangeMode;
    property OnChangeSelected  : TChangeCurve read fChangeSelected write fChangeSelected;
    property OnNewFile         : TNewFile read FNewFile write FNewFile;
    property OnNewBeginPoint   : TNewBeginPoint read fNewBeginPoint write fNewBeginPoint;
    property OnUndoRedoChange  : TUndoRedoChangeEvent read FUndoRedoChangeEvent
             write FUndoRedoChangeEvent;
    property OnBeforePaint     : TNotifyEvent read FOnBeforePaint write FOnBeforePaint;
    property OnAfterPaint      : TNotifyEvent read FOnAfterPaint write FOnAfterPaint;
    property OnAutoSort        : TAutoSortEvent read FAutoSortEvent write FAutoSortEvent;
    property OnPlan            : TProcess read FPlan write FPlan; // Event for autocut percent
    property CentralCross;
    property RotAngle;
    property ShadeModel;
    property Zoom;
    property OnChangeWindow;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnPaint;
    property Align;
    property Enabled;
    property Font;
    property OnClick;
    property OnDockDrop;
    property OnDockOver;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnUnDock;
  end;

//  procedure Register;

implementation
(*
procedure Register;
begin
  RegisterComponents('AL', [TALPapirGL]);
end;
*)
{ TALPapirGL }

constructor TALPapirGL.Create(AOwner: TComponent);
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

  EnableActions := False;
  OnPaint       := On_Paint;
  HRT           := THRTimer.Create;
  WBmp          := TBitMap.Create;   // Memory Bitmap for Working Pointer
  WBmp.Width    := 8;
  WBmp.Height   := 8;

  // Creates pens

  pClosed       := TPen.Create;
  pClosed.Width := 2;
  pClosed.Color := clBlack;
  pClosed.Style := psSolid;

  pOpened       := TPen.Create;
  pOpened.Width := 1;
  pOpened.Color := clGray;
  pOpened.Style := psDot;

  pSelected       := TPen.Create;
  pSelected.Width := 2;
  pSelected.Color := clBlue;
  pSelected.Style := psSolid;

  FCurveList        := TList.Create;
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
  DrawMode          := dmNone;
  innerStream       := TMemoryStream.Create;
  fAutoUndo         := True;
  UR:= TUndoRedo.Create;
  Ur.UndoLimit      := 100;
  Ur.UndoSaveProcedure := SaveGraphToMemoryStream;
  Ur.UndoRedoProcedure := LoadGraphFromMemoryStream;
  Ur.OnUndoRedo        := UndoRedo;
  Changed              := False;
  FWorkOrigo           := Point2d(0,0);
  FMMPerLepes          := 0.05;
  TempCurve            := TCurve.Create;
  FContourRadius       := 4;
  FDemo                := False;
  FAppend              := False;
  newGraphic           := False;
  STOP                 := False;
  FEditable            := False;
  FCentralisZoom       := true;
  FTitleFont           := TFont.Create;
  With FTitleFont do begin
       Name := 'Times New Roman';
       Color:= clNavy;
       Size := 8;
  end;
  SelectedFrame   := TSelectedArea.Create;
  SelectedFrame.AllwaysDraw := True;
  SelectedFrame.OnChange := change;
  Width            := 200;
  height           := 200;
  OnInitGl         := Init;
end;

destructor TALPapirGL.Destroy;
var
  I: Integer;
begin
  HRT.Free;
  UR.Free;
  for I:=Pred(FCurveList.Count) downto 0 do
  begin
    FCurve:=FCurveList.Items[I];
    FCurve.Free;
  end;
  FCurveList.Clear;
  FCurveList.Free;
  if SelectedFrame<>nil then
     SelectedFrame.Free;
  inherited;
end;

function TALPapirGL.LoadGraphFromFile(const FileName: string): Boolean;
var
  FileStream: TFileStream;
  GraphData: TNewGraphData;
  N: Integer;
  au: boolean;
  ext: string;
begin
  Result  := False;
  oldFile := False;
  Loading := true;
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

  finally
//    DeleteEmptyCurves;
    VektorisationAll(0.02);
//    SetAllContour;
    Repaint;
    AutoUndo := au;
    Loading := False;
    If AutoUndo then UndoSave;
  end;
end;


procedure TALPapirGL.SaveGraphToMemoryStream(var stm: TMemoryStream);
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

{ A SelectedFrame-ben foglalt torzított alakzatok beillesztése a rajzba }
procedure TALPapirGL.LoadSelectedFrame;
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
    DoPaint;
    invalidate;
    AutoUndo := True;
  end;
end;

procedure TALPapirGL.SetActionMode(const Value: TActionMode);
begin
  fActionMode := Value;
  DrawMode    := dmNone;
end;

procedure TALPapirGL.SetAllContour;
var i,n: integer;
    Cuv: TCurve;
    TempCurve: TCurve;
begin
   PoligonizeAll(0);
   InitParentObjects;

   For i:=0 to Pred(FCurvelist.Count) do begin
       Cuv:=FCurveList.Items[i];
       n := Cuv.Count;
//       FCurve.SetContour(0.9*ContourRadius);
//       Vektorisation(0.02,Cuv);
       Cuv.VisibleContour := true;
//       Vektorisation(0.02,Cuv.Contour);
//       TempCurve := Cuv.Contour;
(*
       if Cuv.Closed then begin
          Cuv.SetClipperContour(ContourRadius);
          Vektorisation(0.2,Cuv.Contour);
       end;*)
   end;
   GenerateList;
end;

function TALPapirGL.SaveCurveToStream(FileStream: TStream; Item: Integer): Boolean;
var
  CurveData: TNewCurveData;
  pp : ppoint;
  p : TPointRec;
  N: Integer;
begin
  Result:=False;
  if not InRange(Item,0,Pred(FCurveList.Count)) or not Assigned(FileStream) then Exit;
  FCurve:=FCurveList.Items[Item];
  try
    CurveData := FCurve.GetCurveData;

    FileStream.Write(CurveData,SizeOf(TNewCurveData));

    for N:=0 to Pred(FCurve.FPoints.Count) do begin
      pp := FCurve.FPoints.Items[N];
      p.x := pp^.x;
      p.y := pp^.y;
      FileStream.Write(FCurve.FPoints.Items[N]^,SizeOf(TPointRec));
    end;

    Result:=True;
  except
    ShowMessage('Error writing stream!');
  end;
end;
{------------------------------------------------------------------------------}

function TALPapirGL.LoadCurveFromStream(FileStream: TStream): Boolean;
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

procedure TALPapirGL.LoadGraphFromMemoryStream(stm: TMemoryStream);
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
          TCurve(FCurveList.Items[FCurveList.Count-1]).Selected := True;
      end;
  except
      exit;
  end;
  Loading := False;
  DoPaint;
end;

procedure TALPapirGL.SetGraphTitle(const Value: Str32);
begin
  FGraphTitle := Value;
  invalidate;
end;

{Az képközéppont koord.-áiból kiszámitja a origo koord.it}
function TALPapirGL.CentToOrigo(c: TPoint2D): TPoint2D;
begin
  Result.x := c.x-Width/(2*Zoom);
  Result.y := c.y-Height/(2*Zoom);
end;

procedure TALPapirGL.Change(Sender: TObject);
begin
  DoPaint;
end;

procedure TALPapirGL.SetDefaultLayer(const Value: Byte);
begin
  fDefaultLayer := Value;
end;

procedure TALPapirGL.SetDownUp(const Value: boolean);
begin
  FDownUp := Value;
  if FDownUp then begin
     WorkOrigo := Point2d(0,Paper.Height);
  end else begin
     WorkOrigo := Point2d(0,0);
  end;
end;

procedure TALPapirGL.SetSensitiveRadius(const Value: integer);
begin
  FSensitiveRadius := Value;
end;

procedure TALPapirGL.SetShowPoints(const Value: boolean);
begin
  fShowPoints := Value;
  invalidate;
end;

procedure TALPapirGL.SetDrawMode(const Value: TDrawMode);
begin
  if Locked then FDrawMode := dmNone else FDrawMode := Value;
  if Value <> dmNone then
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
              NCH:=MakeCurve('Text',-1,DrawMode,True,True,False);
              Selected.Name := ActText;
         end;
       dmFreeHand : Cursor := crFreeHand;
  else MaxPointsCount := High(integer);
  end;
  if Assigned(fChangeMode) then fChangeMode(Self,ActionMode,Value);
  invalidate;
end;

procedure TALPapirGL.SetLocked(const Value: boolean);
begin
  fLocked := Value;
  DoPaint;
end;

// A p ponthoz legközelebbi alakzat legközelebbi pontja
// lesz az új kezdõpont
procedure TALPapirGL.SetNearestBeginPoint(p: TPoint2d);
var CuvIdx,NodeIdx: integer;
begin
  GetNearestPoint( p,CuvIdx,NodeIdx );
  SetBeginPoint( CuvIdx,NodeIdx );
end;

procedure TALPapirGL.SetOutherBeginPoint(Ax, Ay: TFloat);
begin
Try
       GetNearestPoint(Point2d(Ax,Ay),CPCurve,CPIndex);
       FCurve:=FCurveList.Items[CPCurve];
       FCurve.SetOutherBeginPoint(Ax,Ay);
       Selected := FCurve;
       Changed := True;
       DoPaint;
       if Assigned(fNewBeginPoint) then fNewBeginPoint(Self,CPCurve);
except
end;
end;

procedure TALPapirGL.SetSelected(const Value: TCurve);
begin
if Enabled {and (FSelected <> Value)} then begin
   FSelected := Value;
     fSelected := Value;
     fCurve := Value;
     if FCurve<>nil then
        SelectedIndex := GetCurveHandle(Value.Name)
     else
        SelectedIndex := -1;
     if Assigned(fChangeCurve) then fChangeCurve(Self,fSelected,CPIndex);
     if Assigned(fChangeSelected) then fChangeSelected(Self,FCurve,CPIndex);
     DoPaint;
end;
end;

procedure TALPapirGL.SetTitleFont(const Value: TFont);
begin
  FTitleFont := Value;
end;

procedure TALPapirGL.SetVisibleContours(const Value: Boolean);
begin
  // Show contours around the curves
  FVisibleContours := Value;
  SelectedIndex := -1;
  DoPaint;
(*
  if Value then begin
     InitParentObjects;
     SetAllContour;
  end;
  SelectedIndex := -1;
  invalidate;
//  DoPaint;
*)
end;

procedure TALPapirGL.SetWindow(const Value: TRect2d);
begin
  fOrigo.x := Value.x1;
  fOrigo.y := Value.y1;
  Zoom     := 1;
end;

procedure TALPapirGL.SetWorking(const Value: boolean);
begin
  fWorking := Value;
  invalidate;
end;

procedure TALPapirGL.Redo;
begin
if not Locked then begin
  Loading := True;
  Clear;
  UR.Redo;
  DoPaint;
  Loading := False;
end;
end;

procedure TALPapirGL.Undo;
begin
  Loading := True;
  Clear;
  UR.Undo;
  SelectedFrame.Visible := false;
  DoPaint;
  Loading := False;
end;

procedure TALPapirGL.UndoInit;
begin
  UR.UndoInit;     // Initialize UndoRedo system
//  UndoSave;        // Saves this situation
end;

procedure TALPapirGL.UndoRedo(Sender: TObject; Undo, Redo: boolean);
begin
  If Assigned(FUndoRedoChangeEvent) then
     FUndoRedoChangeEvent(Self,Undo,Redo);
end;

procedure TALPapirGL.UndoSave;
begin
if not Locked then
  UR.UndoSave;  // Felhasználói mentés undo-hoz
end;

procedure TALPapirGL.UndoStart;
begin
  UR.Enable := AutoUndo;
end;

procedure TALPapirGL.UndoStop;
begin
  UR.Enable := False;
end;

procedure TALPapirGL.SetWorkOrigo(const Value: TPoint2d);
begin
  fWorkOrigo := Value;
  WorkPosition.WorkPoint := Value;
  DoPaint;
end;

procedure TALPapirGL.ZoomDrawing;
var nagyx,nagyy : extended;
    I,J: integer;
    BR: TRect2d;
    x1,x2,y1,y2: TFloat;
begin
 if FCurveList.Count=0 then ZoomPaper;
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
  Centrum := Point2d((x2+x1)/2,(y2+y1)/2);
  Zoom    := 0.9*nagyx;
 end;
end;

function TALPapirGL.AddCurve(ACurve: TCurve): integer;
begin
Try
  FCurveList.Pack;
  FCurveList.Add(ACurve);
  Result := FCurveList.Count-1;
  DoPaint;
except
  Result := -1;
end;
end;

procedure TALPapirGL.AddPoint(AIndex: Integer; X, Y: TFloat);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    FCurve.AddPoint(X,Y);
    DoPaint;
  end;
end;

procedure TALPapirGL.AddPoint(AIndex: Integer; P: TPoint2d);
begin
  AddPoint(AIndex, P.X, P.Y);
  DoPaint;
end;

// SelectedFrame align to min. area of selected objects
procedure TALPapirGL.AdjustSelectedFrame;
begin

end;

procedure TALPapirGL.ChangePoint(AIndex, APosition: Integer; X, Y: TFloat);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    if APosition < FCurve.FPoints.Count then FCurve.ChangePoint(APosition,X,Y);
    Selected := FCurve;
    DoPaint;
  end;
end;

procedure TALPapirGL.ChangePoint(AIndex, APosition: Integer; P: TPoint2d);
begin
  ChangePoint(AIndex, APosition,p.x,p.y);
end;

procedure TALPapirGL.CheckCurvePoints(X, Y: Integer);
var i,J,K,L,H: integer;
    Lx,Ly : TFloat;
    xx,yy : TFloat;
    WP    : TPoint2d;
    InCode : TInCode;
begin
    CPMatch:=False;
    CPIndex:=0;
    CurveMatch:=False;
    CurveIn:=False;

    WP := SToW(Point(x,Height-y));
    xx := WP.x;
    yy := WP.y;

    Delta := 4/zoom;
    if SensitiveRadius>3 then
       delta := SensitiveRadius/zoom;

    // Ha van kiválasztott obj, => az õ vizsgálata elsõdleges
    H:=-1;
    IF Selected<>nil then begin
       H:=GetCurveHandle(Selected.name);
       if Selected.IsInBoundsRect(xx,yy) then begin
          L := Selected.IsOnPoint(xx, yy, delta);
          if L>-1 then begin
             GetPoint(H,L,Lx,Ly);
             CPMatch:=True;
             CPx:=Lx;
             CPy:=Ly;
             CPCurve:=H;
             CPIndex:=L;
             Exit;
          end;
       end;
    end;

    J:=Pred(FCurveList.Count);

    for I:=0 to J do
    begin
      FCurve:=FCurveList.Items[I];
      if FCurve.IsInBoundsRect(xx,yy) then begin
        InCode := FCurve.IsInCurve(xx,yy);
        if InCode=icOnLine then begin
           CurveMatch:=True;
           CPCurve:=I;
        end;
        if InCode=icIn then begin
           CurveIn:=True;
           CPCurve:=I;
        end;

        L:=FCurve.IsOnPoint(xx, yy, delta);
        if L>-1 then
        begin
           CPMatch:=True;
           FCurve.GetPoint(L,Lx,Ly);
           CPx:=Lx;
           CPy:=Ly;
           CPCurve:=I;
           CPIndex:=L;
           Exit;
        end;

(*
//        if inCode=icOnPoint then begin
           K:=Pred(FCurve.FPoints.Count);
           for L:=K downto 0 do
           begin
                FCurve.GetPoint(L,Lx,Ly);
//                GetPoint(I,L,Lx,Ly);
//                CPMatch:=(Abs(xx-Lx)<delta) and (Abs(yy-Ly)<delta);
                CPMatch:=FCurve.IsOnPoint(xx, yy, delta)>-1;
                if CPMatch then
                begin
                   CPx:=Lx;
                   CPy:=Ly;
                   CPCurve:=I;
                   CPIndex:=L;
                   Exit;
            end;
//        end;
        end;
*)
        end;
    end;
end;

procedure TALPapirGL.Clear;
begin
  FCurveList.Clear;
  UndoInit;
  DoPaint;
end;

procedure TALPapirGL.ClosedAll(all: boolean);
var i: integer;
    cuv: TCurve;
begin
  for i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      if cuv.Selected then
         Cuv.Closed := all;
  end;
  DoPaint;
end;

procedure TALPapirGL.DeleteCurve(AItem: Integer);
begin
  if AItem < FCurveList.Count then
  begin
    if AutoUndo then UndoSave;
    FCurve:=FCurveList.Items[AItem];
    FCurveList.Delete(AItem);
    FCurve.Destroy;
    DoPaint;
  end;
end;

procedure TALPapirGL.DeleteEmptyCurves;
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

procedure TALPapirGL.DeleteInvisibleCurves;
var i: integer;
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
end;

procedure TALPapirGL.DeletePoint(AIndex, APosition: Integer);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    if AutoUndo then UndoSave;
    FCurve:=FCurveList.Items[AIndex];
    FCurve.DeletePoint(APosition);
    if FCurve.FPoints.Count=0 then
       FCurveList.Delete(AIndex);
    DoPaint;
  end;
  Selected := FCurve;
end;

procedure TALPapirGL.DeleteSamePoints(diff: TFloat);
// Deletes all same points in range of diff: only one point remains
// Azonos vagy nagyon közeli pontok kiejtése
var i,j,k  : integer;
    x,y    : TFloat;
    x1,y1  : TFloat;
begin
  for i:=0 to Pred(FCurveList.Count) do begin
    FCurve:=FCurveList.Items[i];
    if FCurve.FPoints.Count>=1 then begin
    j:=0;
    repeat
          FCurve.GetPoint(j,x,y);
          Inc(j);
          repeat
                FCurve.GetPoint(j,x1,y1);
                if (Abs(x-x1)<diff) and (Abs(y-y1)<diff) then
                   FCurve.DeletePoint(j)
                else
                   Break;
          until (j>=FCurve.FPoints.Count-1);
    until j>=FCurve.FPoints.Count-1;
    end;
  end;
  DoPaint;
end;

procedure TALPapirGL.DeleteSelectedCurves;
var i: integer;
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
      end;
      Inc(i);
  end;
  if AutoUndo then UndoSave;
  end;
  DoPaint;
end;

procedure TALPapirGL.DoMove(Dx, Dy: Integer);
begin
    CPx:=XToW(Dx);
    CPy:=YToW(Dy);
    ChangePoint(CPCurve,CPIndex,CPx,CPy);
    Changed := True;
    DoPaint;
end;

procedure TALPapirGL.Eltolas(dx, dy: double);
var n,i,j: integer;
    x,y: double;
begin
   For n:=0 to FCurveList.Count-1 do begin
      FCurve:=FCurveList.Items[n];
      J:=Pred(FCurve.FPoints.Count);
      FCurve.MoveCurve(dx,dy);
   end;
  if AutoUndo then UndoSave;
  DoPaint;
end;

procedure TALPapirGL.EnabledAll(all: boolean);
var i: integer;
    cuv: TCurve;
begin
  For i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      Cuv.Enabled:=all;
  end;
  Invalidate;
end;

function TALPapirGL.GetCurveHandle(AName: Str32): Integer;
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
      Break;
    end;
    Inc(I);
  end;
end;

function TALPapirGL.GetCurveName(H: Integer): Str32;
begin
  Result:='';
  if (H < 0) or (H > Pred(FCurveList.Count)) then Exit;
  FCurve:=FCurveList.Items[H];
  Result:=FCurve.Name;
end;

function TALPapirGL.GetCurves(AIndex: integer): TCurve;
begin
  Result := TCurve(FCurvelist.Items[AIndex]);
end;

procedure TALPapirGL.SetCurves(AIndex: integer; const Value: TCurve);
begin
  FCurvelist.Items[AIndex] := Value;
end;


// Searching for the nearest point in graph
// Result : distance from p point
//    VAR : cuvIdx = Curve's number
//          pIdx   = Point's number

function TALPapirGL.GetNearestPoint(p: TPoint2d; var cuvIdx,
  pIdx: integer): TFloat;
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

procedure TALPapirGL.GetPoint(AIndex, APosition: Integer; var X,
  Y: TFloat);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    if InRange(APosition,0,Pred(FCurve.FPoints.Count)) then
      FCurve.GetPoint(APosition,X,Y);
  end;
end;

function TALPapirGL.GetPoint2D(AIndex, APosition: Integer): TPoint2d;
var x,y : double;
begin
   GetPoint(AIndex, APosition,x,y);
   Result := Point2d(x,y);
end;

{ Get the minimal rectangle around selected objects }
function TALPapirGL.GetSelectedArea(var RR: TRect2d): boolean;
var i  : integer;
    Cuv: TCurve;
    R  : TRect2d;
begin
  Result := False;
  RR := Rect2d(MaxReal,MinReal,MinReal,MaxReal);
  for I:=0 to Pred(FCurveList.Count) do
  begin
    Cuv:=FCurveList.Items[I];
    if Cuv.Selected then begin
       Result := True;
       R := Cuv.BoundsRect;
       if RR.x1>R.x1 then RR.x1 := R.x1;
       if RR.x2<R.x2 then RR.x2 := R.x2;
       if RR.y1<R.y1 then RR.y1 := R.y1;
       if RR.y2>R.y2 then RR.y2 := R.y2;
    end;
  end;
end;

function TALPapirGL.GetWindow: TRect2d;
begin
  Result := Rect2d(Origo.x,origo.y,XToW(width),YToW(0));
end;


procedure TALPapirGL.GridDraw;
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

  GridTav := 1;

  With DrawBmp.Canvas do

  if Grid.OnlyOnPaper then begin
  For i:=0 to 2 do begin
      tav  := Gridtav*szorzo;
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
      While kp.x<=Paper.Width do begin
            MoveTo(XToS(kp.x),YToS(0));
            LineTo(XToS(kp.x),YToS(Paper.Height-0.1));
//            TextOut(XToS(kp.x),0,IntToStr(Trunc(x)));
            kp.x:=kp.x+tav;
      end;
      While kp.y<=Paper.Height do begin
            MoveTo(XToS(0),YToS(kp.y));
            LineTo(XToS(Paper.Width-0.1),YToS(kp.y));
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
  if (Grid.Margin>0) and Paper.Visible then begin
       DrawBmp.Canvas.Brush.Style:=bsClear;
       DrawBmp.Canvas.Pen.Style := psDot;
       DrawBmp.Canvas.Pen.Color := clSilver;
       R:=Rect(XToS(Grid.Margin),YToS(Grid.Margin),XToS(Trunc(Paper.Width-Grid.Margin)),
               YToS(Trunc(Paper.Height-Grid.Margin)));
       DrawBmp.Canvas.Rectangle(R);
 end;
end;

procedure TALPapirGL.InsertCurve(AIndex: Integer; Curve: TCurve);
begin
  if (AIndex > -1) and (AIndex < FCurveList.Count-1) then
  begin
    FCurveList.Insert(AIndex,Curve);
    Changed := True;
  end;
end;

procedure TALPapirGL.InsertPoint(AIndex, APosition: Integer; X, Y: TFloat);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    FCurve.InsertPoint(APosition,X,Y);
    Selected := FCurve;
  end;
  DoPaint;
end;

procedure TALPapirGL.InsertPoint(AIndex,APosition: Integer; P: TPoint2d);
begin
  InsertPoint(AIndex,APosition,P.X,P.Y);
  DoPaint;
end;


procedure TALPapirGL.InversCurve(AIndex: Integer);
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

procedure TALPapirGL.InversSelectedCurves;
var i: integer;
begin
  for i:=0 to Pred(FCurveList.Count) do begin
      FCurve:=FCurveList.Items[i];
      FCurve.Selected := not FCurve.Selected;
  end;
  Invalidate;
end;

procedure TALPapirGL.MagnifySelected(Cent: TPoint2d; Magnify: TFloat);
var n,i,j: integer;
    x,y: double;
begin
   If AutoUndo then UR.UndoSave;
   For n:=0 to FCurveList.Count-1 do begin
      FCurve:=FCurveList.Items[n];
      J:=Pred(FCurve.FPoints.Count);
      if FCurve.Selected then begin
         FCurve.MagnifyCurve(Cent, Magnify);
         Changed := True;
      end;
   end;
   DoPaint;
end;

function TALPapirGL.MakeCurve(const AName: Str32; ID: integer;
  Shape: TDrawMode; AEnabled, AVisible, AClosed: Boolean): Integer;
begin
Try
  Result := ID;
  IF ID<0 then Result:=FCurveList.IndexOf(FCurve)+1;
  FCurve:=TCurve.Create;
  if Pos('_',Aname)>0 then
     FCurve.Name:=AName
  else
     FCurve.Name:=AName+'_'+IntToStr(Result);
  FCurve.ID      := Result;
  FCurve.Font.Assign(Font);
  FCurve.Enabled := AEnabled;
  FCurve.Layer   := actLayer;
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

(*
procedure TALPapirGL.MoveCentrum(fx, fy: double);
begin
  Centrum := Point2d(fx,fy);
end;
*)
procedure TALPapirGL.MoveCurve(AIndex: integer; Ax, Ay: TFloat);
var i: integer;
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then begin
      FCurve:=FCurveList.Items[AIndex];
      FCurve.MoveCurve(Ax/Zoom, Ay/Zoom);
      if SelectedIndex<>AIndex then
         Selected := FCurve;
      Changed := True;
  end;
  DoPaint;
end;

procedure TALPapirGL.MoveSelectedCurves(Ax, Ay: TFloat);
var i: integer;
begin
  for i:=0 to Pred(FCurveList.Count) do begin
      FCurve:=FCurveList.Items[i];
      if FCurve.Selected then FCurve.MoveCurve(Ax/Zoom, Ay/Zoom);
  end;
  Changed := True;
  DoPaint;
end;

procedure TALPapirGL.NewOrigo(x, y: extended);
begin
    FOrigo.x:=x;
    FOrigo.y:=y;
    Centrum := OrigoToCent;
end;

procedure TALPapirGL.Normalisation(Down: boolean);
var r: TRect2d;
    margo: integer;
begin
  margo:=20;
  r := GetDrawExtension;
  if down then Eltolas(-r.x1+Grid.margin,-r.y1+Grid.margin)
  else Eltolas(-r.x1+Grid.margin,Paper.Height-r.y2-Grid.margin);
  DoPaint;
end;

// 0 pozícióba mozgatás
procedure TALPapirGL.NormalisationEx(Down: boolean);
var r: TRect2d;
begin
  r := GetDrawExtension;
  if down then Eltolas(-r.x1,-r.y1)
  else Eltolas(-r.x1,Paper.Height-r.y2);
  RePaint;
end;

procedure TALPapirGL.Nyujtas(tenyezo: double);
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
      end;
      end;
   end;
  if AutoUndo then UndoSave;
  DoPaint;
end;

procedure TALPapirGL.Poligonize(Cuv: TCurve; Count: integer);
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
   If AutoUndo then UR.UndoSave;
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
   If AutoUndo then UR.UndoSave;
   InitdPoints;
   Loading := False;
end;
end;

procedure TALPapirGL.PoligonizeAll(PointCount: integer);
// Total graphic vectorisation
Var
    i    : integer;
begin
  For i:=0 to Pred(FCurveList.Count) do
      Poligonize(TCurve(FCurveList.Items[i]),PointCount);
  DoPaint;
end;

procedure TALPapirGL.PontSurites(Cuv: TCurve; Dist: double);
var x,y         : TFloat;
    d           : TFloat;
    i,j,k       : integer;
    pp,pp1      : pPoints;
    dx,dy       : TFloat;
    Angle       : TFloat;
begin
Try
   If AutoUndo then UR.UndoSave;
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
   If AutoUndo then UR.UndoSave;
   InitdPoints;
   Loading := False;
end;
end;

procedure TALPapirGL.PontSuritesAll(Dist: double);
Var
    i    : integer;
begin
  For i:=0 to Pred(FCurveList.Count) do
      PontSurites(TCurve(FCurveList.Items[i]),Dist);
  DoPaint;
end;

procedure TALPapirGL.RotateSelectedCurves(Cent: TPoint2d; Angle: TFloat);
var i: integer;
begin
  for i:=0 to Pred(FCurveList.Count) do begin
      FCurve:=FCurveList.Items[i];
      if FCurve.Selected then FCurve.RotateCurve(Cent, Angle);
  end;
  Changed := True;
  DoPaint;
end;

procedure TALPapirGL.SelectAll(all: boolean);
var i: integer;
    cuv: TCurve;
begin
  Loading := True;
  for i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      Cuv.Selected := all;
  end;
  Loading := False;
  Invalidate;
end;

procedure TALPapirGL.SelectAllInArea(R: TRect2D);
var i,n: integer;
    cuv: TCurve;
    RR,RC : TRect2d;
begin
  Loading := True;
  RR := CorrectRealRect(R);
  for i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      RC := CorrectRealRect(Cuv.BoundsRect);
      If (RR.X1<=RC.X1) and (RR.X2>=RC.X2) and
         (RR.Y1<=RC.Y1) and (RR.Y2>=RC.Y2) then
      begin
         Cuv.Selected := True;
         if SelectedFrame.Visible then begin
            SelectedFrame.AddCurve(Cuv);
         end;
      end;
  end;
  n := SelectedFrame.DestList.Count;
  Loading := False;
  Invalidate;
end;

{ Megszámolja az R területet metszõ objektumokat és az aList-ben rögzíti a sorszámukat }
function TALPapirGL.EnumAllInArea(R: TRect2D; var aList: array of integer): integer;
var i,n: integer;
    cuv: TCurve;
    RR,RC : TRect2d;
begin
  Loading := True;
  Result := 0;
  RR := CorrectRealRect(R);
  for i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      RC := CorrectRealRect(Cuv.BoundsRect);
      If (RR.X1<=RC.X1) and (RR.X2>=RC.X2) and
         (RR.Y1<=RC.Y1) and (RR.Y2>=RC.Y2) then
      begin
         if SelectedFrame.Visible then begin
//            SetLength( aList,Result );
            aList[Result]:=i;
            Inc( Result );
         end;
      end;
  end;
  Loading := False;
end;

procedure TALPapirGL.SelectAllPolygons;
var i: integer;
    cuv: TCurve;
begin
  for i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      cuv.Selected := Cuv.Shape = dmPolygon;
  end;
  Invalidate;
end;

procedure TALPapirGL.SelectAllPolylines;
var i: integer;
    cuv: TCurve;
begin
  for i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      cuv.Selected := Cuv.Shape = dmPolyLine;
  end;
  Invalidate;
end;

procedure TALPapirGL.SelectChildObjects;
var i: integer;
begin
  Loading := True;
  for i:=0 to Pred(FCurveList.Count) do
      TCurve(FCurveList.Items[i]).Selected := not IsParent(i);
  Loading := False;
  Invalidate;
end;
function TALPapirGL.GetDrawExtension: TRect2d;
var n: integer;
    x,y: double;
    R: TRect2d;
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

function TALPapirGL.IsPaperInWindow: boolean;
var
    RP: TRect2d;     // Paper rectangle
    RR: HRgn;
begin
  if Paper.Visible then begin
     RP:= Rect2d(0,0,Paper.Width,Paper.Height);
     Result := IsRectInWindow(RP);
  end;
end;

function TALPapirGL.IsPointInWindow(p: TPoint2d): boolean;
begin
   Result := PontInKep(XToS(p.x),YToS(p.y),GetWorkArea);
end;

function TALPapirGL.IsRectInWindow(R: TRect2d): boolean;
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

procedure TALPapirGL.AutoSortObject(BasePoint: TPoint2d; Connecting: boolean);
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

// AutoSTRIP : FÛZÉR KÉPZÉS
// Ha a FileName='', akkor nincs automatikus mentés
procedure TALPapirGL.AutoSTRIP(FileName: string; BasePoint: TPoint2d);
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
            dy := Paper.Height-2*m-R.y2;
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

procedure TALPapirGL.AutoSortObject(BasePoint: TPoint2d);
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

function TALPapirGL.GetInnerObjectsCount(AIndex: Integer): integer;
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

function TALPapirGL.GetMaxPoints: Integer;
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

// Megkeresi, hogy a sokszög melyik legkisebbnek a belselyében van
// Ha nincs befoglalója, akkor Result=-1
// Ha van, akkor annak az ID-jével tér vissza
function TALPapirGL.GetParentObject(x, y: TFloat): integer;
Var OurRect : TRect2d;
    inRect  : TRect2d;
    oRect   : TRect2d;
    i       : integer;
    Cuv     : TCurve;
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

function TALPapirGL.GetParentObject(AIndex: Integer): integer;
Var OurRect : TRect2d;
    inRect  : TRect2d;
    oRect   : TRect2d;
    Cuv     : TCurve;
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

procedure TALPapirGL.InitParentObjects;
var i: integer;
begin
  Loading := True;
  for i:=0 to Pred(FCurveList.Count) do begin
      TCurve(FCurveList.Items[i]).ParentID := -1;
      if TCurve(FCurveList.Items[i]).Closed then
         if not IsParent(i) then
            TCurve(FCurveList.Items[i]).ParentID := GetParentObject(i);
  end;
  Loading := False;
  Invalidate;
end;

// Megvizsgálja, hogy a p1-p2 szakasz átvágja valamelyik vagy több objektumot.
//     Aindex = az elsõként érintett objektum sorszáma
function TALPapirGL.IsCutObject(p1, p2: TPoint2d;
  var Aindex: integer): boolean;
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

function TALPapirGL.IsParent(AIndex: Integer): boolean;
begin
  Result := False;
  if AIndex>-1 then
     Result := GetParentObject(AIndex)=-1;
end;

// Megvizsgálja, hogy a pont körüli objektumnak van-e szüleje, azaz
// olyan objektum, aminek a belselyében található
// True = ha szülõ objektum
function TALPapirGL.IsParent(x, y: TFloat): boolean;
begin
  Result := GetParentObject(x,y)=-1;
end;

{Az objektum körül kontúrozása: mûszer korrekció
   In: Cuv        = Zárt sokszog;
       OutCode    = a vágóél sugara :
                    0  = eredeti kontúr vonalon,
                    +n = kívül haladás,
                    -n = belül haladás }
function TALPapirGL.ObjectContour(Cuv: TCurve; OutCode: double): TCurve;
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
   {A szakaszokkal || egyenesek elhelyezése a stream-eken}
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
                 for n:=Idx1 to Idx2 do TempCurve.DeletePoint(i+1);
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

function TALPapirGL.OutLineObject(AIndex: Integer; delta: real): TCurve;
begin

end;

procedure TALPapirGL.StripAll;
var i: integer;
begin
  i:=0;
  For i:=0 to Pred(FCurveList.Count) do begin
      if IsParent(i) and (GetInnerObjectsCount(i)>0) then StripChildToParent(i);
  end;
end;

// A fiók objektumok felfûzése a szülõ objektumra
procedure TALPapirGL.StripChildToParent(AIndex: integer);
var childCount: integer;
    i,k       : integer;
    pCuv,cCuv : TCurve;    // Parent and Child
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

procedure TALPapirGL.StripObj12(AParent, Achild: integer);
    var j,f,k     : integer;
        pCuv,cCuv : TCurve;
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
           pCuv.InsertPoint(pPointidx+f+1,pp.x,pp.y);
       end;
       pp := cCuv.GetPoint2d(0);
       pCuv.InsertPoint(pPointidx+f+1,pp.x,pp.y);
       pCuv.InsertPoint(pPointidx+f+2,pp0.x,pp0.y);
       // Az eredeti Child legyen láthatatlan
       cCuv.Visible := False;
    end;

procedure TALPapirGL.SelectCurve(AIndex: Integer);
begin
  if AIndex < FCurveList.Count then begin
   FCurve:=FCurveList.Items[AIndex];
   Selected := FCurve;
   SelectedIndex := AIndex;
   Invalidate;
  end else begin
   Selected := nil;
   SelectedIndex := -1;
   Invalidate;
  end;
end;

procedure TALPapirGL.SelectCurveByName(aName: string);
var n: integer;
begin
   For n:=0 to FCurveList.Count-1 do begin
      FCurve:=FCurveList.Items[n];
      if FCurve.Name = aName then begin
         Selected := FCurve;
         SelectedIndex := n;
      end;
   end;
   Invalidate;
end;

procedure TALPapirGL.SelectParentObjects;
var i: integer;
begin
  Loading := True;
  for i:=0 to Pred(FCurveList.Count) do
      TCurve(FCurveList.Items[i]).Selected := IsParent(i);
  Loading := False;
  Invalidate;
end;

procedure TALPapirGL.SetBeginPoint(ACurve, AIndex: Integer);
var NewPoints: TList;
    i,j1,j2: integer;
    PPoint: PPointRec;
begin
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
  DoPaint;
end;

procedure TALPapirGL.SignedAll(all: boolean);
var i: integer;
    cuv: TCurve;
begin
  For i:=0 to Pred(FCurveList.Count) do begin
      Cuv:=FCurveList.Items[i];
      Cuv.Signed:=all;
  end;
  DoPaint;
end;

procedure TALPapirGL.SignedNotCutting;
var i,j,k: integer;
    BaseCurve,Cuv: TCurve;
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
  DoPaint;
end;

procedure TALPapirGL.Vektorisation(MaxDiff: TFloat; Cuv: TCurve);
(* A vektorizálás során a kezdõpontot összekötjük a további pontokkal mindaddig
   amíg a következõ pont eltérése nagyobb lessz egy diff-erenciánál
*)

var diff    : double;          // eltérés
    i       : integer;
    pp      : pPoints;
    kp,vp   : TPoint2D;        // vektor kezdõ és végpontja
    n0,n    : integer;         // n futóindex
    e       : TEgyenesfgv;
    p2d     : TPoint2D;
begin
Try
   If (not Loading) and AutoUndo then UR.UndoSave;
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

   // Ujmódszer
   While (n<dPoints.Count) do begin
   Try
     pp := dPoints[n0];
     kp := Point2d(pp^.x,pp^.y);
     Cuv.AddPoint(pp^.x,pp^.y);
     Inc(n0);

     While n<dPoints.Count do begin
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
      Cuv.AddPoint(pp^.x,pp^.y);
   end;
Finally
  if (not Loading) and AutoUndo then UndoSave;
end;

end;


procedure TALPapirGL.VektorisationAll(MaxDiff: TFloat);
// Total graphic vectorisation
Var
    i    : integer;
begin
Try
  If AutoUndo then UR.UndoSave;
  Loading := True;
  For i:=0 to Pred(FCurveList.Count) do begin
      if FCurveList.Items[i]<>nil then
      Vektorisation(MaxDiff,TCurve(FCurveList.Items[i]));
  end;
  if AutoUndo then UndoSave;
  Loading := False;
except
end;
end;

procedure TALPapirGL.DrawMouseCross(o: TPoint; PenMode: TPenMode);
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

procedure TALPapirGL.DrawCurve(Cuv: Tcurve);
var i       : integer;
    x,y     : double;
    P1,P2   : TPoint2d;
    Sel     : boolean;
begin
  Sel := GetCurveHandle(Cuv.Name)=SelectedIndex;
  if Cuv.Visible and (Cuv.Count > 0) then
  Try
      if Sel then begin
         glColor(clRed)
      end
      else
      if Cuv.Selected then glColor(clBlue)
         else glColor(clBlack);
      glLineWidth(2);
      Case Cuv.Shape of
      dmPolygon,dmPolyLine,dmPoint,dmLine,dmRectangle,dmFreeHand:
      begin
             If Cuv.Closed then
                glBegin(GL_LINE_LOOP)
             else
                glBegin(GL_LINE_STRIP);
             if not Sel then begin
             if Cuv.Shape=dmPolyLine then
                glColor3f(0.5,0.5,0.5);
             if Cuv.Selected then glColor3f(0,0,1);
             end;
             for I:=0 to Pred(Cuv.Count) do
             begin
                Cuv.GetPoint(I,X,Y);
                glVertex2d(x,y);
             end;
             glEnd;
      end;
      dmCircle:
        begin
           P1 := Cuv.GetPoint2d(0);
           P2 := Cuv.GetPoint2d(1);
           glCircle(P1,P2);
        end;
      dmEllipse:
        begin
           P1 := Cuv.GetPoint2d(0);
           P2 := Cuv.GetPoint2d(1);
           glEllipse(P1,p2);
        end;
      dmSpline:
        begin
        end;
      end;
  except
    exit;
  end;
end;

procedure TALPapirGL.DrawPoints(Cuv: Tcurve);
var i       : integer;
    x,y     : double;
begin
  if Cuv.Visible and (Cuv.Count > 0) then
  Try
             glEnable(GL_POINT_SMOOTH);
             glPointSize(6);
             glBegin(GL_POINTS);
             for I:=Pred(Cuv.Count) downto 0 do
             begin
                if I=0 then begin
                   glColor3f(1,0,0);
                end else begin
                   if Cuv.Shape=dmPolyLine then
                      glColor3f(0.5,0.5,0.5)
                   else
                      glColor(clBlack);
                end;
                if Cuv.Selected then glColor3f(0,0,1);
                Cuv.GetPoint(I,X,Y);
                glVertex2d(x,y);
             end;
             glEnd;
  except
    exit;
  end;
end;

{ Draw a frame => TSelectdFrame around the selected curves }
procedure TALPapirGL.DrawSelectedFrame;
Var
   p: array of TPoint2d;
   oCuv,dCuv: TCurve;
   i: integer;
   m: double;
begin
if SelectedFrame<>nil then
if SelectedFrame.Visible then
begin
  m := SensitiveRadius/Zoom;
  SetLength(p,4);
  glColor(clBlue);
  With SelectedFrame do begin
       p[0] := Nodes[0];
       p[1] := Nodes[1];
       p[2] := Nodes[2];
       p[3] := Nodes[3];
       glPolygon(P);

       // Támpontok rajzolása

       // Sarokpontok
       glsquareFill(Nodes[0],m);
       glsquareFill(Nodes[1],m);
       glsquareFill(Nodes[2],m);
       glsquareFill(Nodes[3],m);

       // Felezõpontok
       glsquare(Nodes[4],m);
       glsquare(Nodes[5],m);
       glsquare(Nodes[6],m);
       glsquare(Nodes[7],m);

       // RC forgatási pont
       glsquareFill(RCent,m);
       glColor(clRed);
       glLine(Nodes[4],RC);
       glsquareFill(RC,m);

       // Draw Curves from DestList
       Selectedindex := -1;
       glColor(clBlue);
       glLineWidth(3);

       for i := 0 to Pred(SelectedFrame.OrigList.Count) do
       begin
         oCuv := OrigList.Items[i];
         oCuv.Selected := false;
//         DrawCurve(oCuv);
       end;

       glColor(clRed);
       glLineWidth(1);
       for i := 0 to Pred(SelectedFrame.DestList.Count) do
       begin
         dCuv := DestList.Items[i];
         dCuv.Selected := false;
         DrawCurve(dCuv);
       end;

  end;
end;
end;

procedure TALPapirGL.DrawBeginPoints(Cuv: Tcurve);
Var x,y     : double;
begin
  if Cuv.Visible and (Cuv.Count > 0) then
  Try
             glPointSize(6);
             glColor(clRed);
             glBegin(GL_POINTS);
               Cuv.GetPoint(0,X,Y);
               glVertex2d(x,y);
             glEnd;
  except
    exit;
  end;
end;


procedure TALPapirGL.GenerateList;
var
  H : Integer;
begin
  glLineWidth(2);
  glNewList(1000,GL_COMPILE);
  for H:=0 to Pred(FCurveList.Count) do
  begin
    FCurve:=FCurveList.Items[H];
    DrawCurve(FCurve);
  end;
  glEndList();

//  if FVisibleContours then begin
  glLineWidth(1);
  glNewList(1001,GL_COMPILE);
  for H:=0 to Pred(FCurveList.Count) do
  begin
    FCurve:=FCurveList.Items[H];
    FCurve:=FCurve.Contour;
    if FCurve<>nil then
       DrawCurve(FCurve);
  end;
  glEndList();
//  end;

     glPointSize(2);
     glNewList(2000,GL_COMPILE);
     for H:=0 to Pred(FCurveList.Count) do
     begin
          FCurve:=FCurveList.Items[H];
          DrawPoints(FCurve);
     end;
     glEndList();
     glPointSize(1);
     glNewList(3000,GL_COMPILE);
     for H:=0 to Pred(FCurveList.Count) do
     begin
          FCurve:=FCurveList.Items[H];
          DrawBeginPoints(FCurve);
     end;
     glEndList();

//     if FVisibleContours then begin
     glPointSize(2);
     glNewList(2001,GL_COMPILE);
     for H:=0 to Pred(FCurveList.Count) do
     begin
          FCurve:=FCurveList.Items[H];
          FCurve:=FCurve.Contour;
          if FCurve<>nil then
             DrawPoints(FCurve);
     end;
     glEndList();
//     end;

  NewGraphic := False;
  Changed := False;
end;


procedure TALPapirGL.On_Paint(Sender: TObject);
begin
  if not FLoading then
  if OpenglPaint then PaintGL
  else PaintGDI;
  inherited;
end;

PROCEDURE TALPapirGL.PaintGL;
var
    ps : TPaintStruct;
    sz : TSzin;
begin
  if OpenGLPaint then
  begin
  If Assigned(FOnBeforePaint) then FOnBeforePaint(Self);


  if FGraphTitle<>'' then glPrint(0,0,16,0,FGraphTitle);


  if NewGraphic then GenerateList;
  glCallList(1000);
  if FVisibleContours then glCallList(1001);
  if fShowPoints then begin
     glCallList(2000);
     if FVisibleContours then glCallList(2001);
  end;
  glCallList(3000);

  On_Drawing;

  glTranslated(-Centrum.x,-Centrum.y,0);
  glRotated(RotAngle,0,0,1);
  glTranslated(Centrum.x,Centrum.y,0);

(*
  glTranslated(Centrum.x,Centrum.y,0);
  glRotated(RotAngle,0,0,1);
  glTranslated(-Centrum.x,-Centrum.y,0);
*)
  If Assigned(FOnAfterPaint) then FOnAfterPaint(Self);

  NewGraphic := False;
  end else
      inherited Paint;
end;

procedure TALPapirGL.PaintGDI;
var
  R       : TRect;
  H,I,J,K : Integer;
  Radius  : integer;
  X,Y     : TFloat;
  Angle   : TFloat;
  Size    : integer;
  p       : TPoint;
  p2      : TPoint2d;
  pp      : Array[0..2] of TPoint2D;
  PA,pPA  : PPointArray;
  RE      : TRect2d;
  dc      : HDC;
begin
Try
if not Loading then
Try
  painting := True;
  DrawBmp           := TBitMap.Create;

  DrawBmp.Width:=Width;
  DrawBmp.Height:=Height;
  DrawBmp.Canvas.Pen.Width:=1;

  DrawBmp.Canvas.Brush.Color:=BackColor;
  DrawBmp.Canvas.FillRect(ClientRect);
  DrawBmp.Canvas.Brush.Color:=clSilver;

  If IsPaperInWindow and Paper.Visible then begin
    DrawBmp.Canvas.Pen.Style := psSolid;
    R:=Rect(XToS(0),YToS(0),XToS(Paper.Width),YToS(Paper.Height));
    OffsetRect(R,4,4);
    DrawBmp.Canvas.Brush.Color:=clBlack;
    DrawBmp.Canvas.FillRect(R);
    OffsetRect(R,-4,-4);
    DrawBmp.Canvas.Brush.Color:=Paper.Color;
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
    if FCurve.Visible and (FCurve.FPoints.Count > 0) and
       (IntersectRect2D(Window,FCurve.BoundsRect)) then
    begin
      DrawBmp.Canvas.Pen.Style := psSolid;
      DrawBmp.Canvas.Pen.Width:=1;
      DrawBmp.Canvas.Brush.Style:=bsSolid;
      J:=Pred(FCurve.FPoints.Count);

      for I:=0 to J do
      begin
        p2 := FCurve.GetPoint2d(I);
        p := WtoS(p2);
        PA^[I].x:= p.x;
        PA^[I].y:= p.y;
      end;

      // Tollak beállítása
      If FCurve.Closed then begin
             DrawBmp.Canvas.Pen.Assign(pClosed);
             DrawBmp.Canvas.Brush.Style:=bsClear;
      end else
             DrawBmp.Canvas.Pen.Assign(pOpened);
      if not IsParent(H) then DrawBmp.Canvas.Pen.Color := clGreen;
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
      dmPolygon,dmPolyLine,dmPoint,dmLine,dmRectangle,dmFreeHand:
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
              FCurve.GetPoint(I,X,Y);
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
             p2:=FCurve.GetPoint2d(0);
             p := WtoS(p2);
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
           if FCurve.OutBase then
              DrawBmp.Canvas.Brush.Color := clLime;
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
        p := WToS(RotCentrum);
        DrawBmp.Canvas.Ellipse(p.x-4,p.y-4,p.x+4,p.y+4);
     end;

finally
  FreeMem(PA,Size);
  R:=ClientRect;
  DrawWorkPoint(WorkPosition.WorkPoint.x,WorkPosition.WorkPoint.y);
  Canvas.CopyRect(R,DrawBmp.Canvas,R);
  If oldCursorCross (*and (MouseInOut=1)*) then begin
     DrawMouseCross(oldMovePt,pmXor);
  end;
  painting := False;
  if Assigned(fChangeWindow) then
     fChangeWindow(Self,fOrigo,Zoom,MovePt);
  DrawBmp.free;
end;
except
  DrawBmp.free;
  Exit;
end;
end;

//  Drawing in process
procedure TALPapirGL.On_Drawing;
Var xx,yy: double;
    ps : TPaintStruct;
    TP1,TP2 : TPoint2d; // Tegla elforgatott csúcspontjainak
begin
  if not Editable then Exit;

  glPushMatrix;
  glColor3f(1,0.2,0.8);
  glLineWidth(2);

  Case DrawMode of

  dmLine,dmPolyline,dmPolygon:
  if pFazis>0 then begin
     glBegin(GL_LINE_STRIP);
      glVertex2d(Tegla.P1.x,Tegla.P1.y);
      glVertex2d(Tegla.P2.x,tegla.P2.y);
      if DrawMode=dmPolygon then begin
         TP1:=GetPoint2D(NCH,0);
         glVertex2d(TP1.x,TP1.y);
      end;
     glEnd;
     invalidate;
  end;

  dmRectangle:
  if pFazis>0 then begin
     glPushMatrix;
     glLoadIdentity;
     tP1 := tegla.p1;
     tP2 := tegla.p2;
     RelRotate2d(TP1,Centrum,Rad(RotAngle));
     RelRotate2d(TP2,Centrum,Rad(RotAngle));
//     glRectd(tp1.x,tp1.y,tp2.x,tp2.y);
     glBegin(GL_LINE_STRIP);
      glVertex2d(TP1.x,TP1.y);
      glVertex2d(TP2.x,TP1.y);
      glVertex2d(TP2.x,TP2.y);
      glVertex2d(TP1.x,TP2.y);
      glVertex2d(TP1.x,TP1.y);
     glEnd;
     glPopMatrix;
     invalidate;
  end;

  dmCircle:
  if pFazis>0 then begin
     glCircle(Tegla.P1,Tegla.P2);
     invalidate;
  end;

  dmEllipse:
  if pFazis>0 then begin
     glEllipse(Tegla.P1,Tegla.P2);
     invalidate;
  end;

  end;

  Case ActionMode of
  amSelectArea:
  if pFazis=1 then begin
     glPushMatrix;
     glLoadIdentity;
     tP1 := tegla.p1;
     tP2 := tegla.p2;
     RelRotate2d(TP1,Centrum,Rad(RotAngle));
     RelRotate2d(TP2,Centrum,Rad(RotAngle));
     glBegin(GL_POLYGON);
      glColor3f(0.8,0.8,0.8);
      glVertex2d(TP1.x,TP1.y);
      glVertex2d(TP2.x,TP1.y);
      glVertex2d(TP2.x,TP2.y);
      glVertex2d(TP1.x,TP2.y);
      glVertex2d(TP1.x,TP1.y);
     glEnd;
     glPopMatrix;
     invalidate;
  end;
  end;

  if Selected<>nil then begin
     glColor(clRed);
     DrawCurve(Selected);
  end;

  DrawSelectedFrame;

  // Drawing WorkPosition
  glColor(clRed);
  glPointSize(6);
  glBegin(GL_POINTS);
    glVertex2d(WorkPosition.WorkPoint.x,WorkPosition.WorkPoint.y);
  glEnd;

  glPopMatrix;
end;

function TALPapirGL.OrigoToCent: TPoint2D;
begin
  Result.x := origo.x+Width/(2*Zoom);
  Result.y := origo.y+Height/(2*Zoom);
end;

procedure TALPapirGL.CMMouseEnter(var msg: TMessage);
begin
  inherited;
end;

procedure TALPapirGL.CMMouseLeave(var msg: TMessage);
begin
  ShowHintPanel(False);
  inherited;
end;

procedure TALPapirGL.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
end;

procedure TALPapirGL.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if (ActionMode = amSelectArea) then begin
      ActionMode := amNone;
  end;
  if SelectedFrame.Visible then
  if Shift=[ssCtrl] then
  case Key of
  VK_ADD        : SelectedFrame.magnify(1.1);
  VK_SUBTRACT   : SelectedFrame.magnify(0.9);
  end;
  Repaint;
  inherited;
end;

procedure TALPapirGL.CMChildkey(var msg: TCMChildKey);
var dx,dy: integer;
    k:integer;
begin
  k:=16;
  dx := 0; dy:=0;
  msg.result := 1; // declares key as handled
  Case msg.charcode of
    VK_ESCAPE  : begin
                   ActionMode := amNone;
                   DrawMode := dmNone;
                   SelectAll(False);
                   if SelectedFrame.Visible then begin
                      SelectedFrame.Visible := false;
                      Undo;
                   end;
                 end;
    VK_RETURN  : if SelectedFrame.Visible then begin
                    LoadSelectedFrame;
                    SetAllContour;
                    SelectedFrame.Visible := False;
                 end else
                    ZoomDrawing;
    VK_DELETE  : DeleteSelectedCurves;
    VK_LEFT    : dx:=-k;
    VK_RIGHT   : dx:=k;
    VK_UP      : dy:=-k;
    VK_DOWN    : dy:=k;
  Else
    msg.result:= 0;
    inherited;
  End;
  if (dx<>0) or (dy<>0) then
  if not SelectedFrame.Visible then
     ShiftWindow(dx,dy);
end;

function TALPapirGL.ShapeCount(Shape: TDrawMode): Integer;
var i: integer;
begin
  Result := 0;
  for i:=0 to Pred(FCurveList.Count) do begin
    FCurve:=FCurveList.Items[i];
    if FCurve.Shape=Shape then Inc(Result);
  end;
end;

procedure TALPapirGL.ShowHintPanel(Show: Boolean);
begin
  If Show then begin
     Hint1.ActivateHint(HintRect,Hintstr);
     HintActive:=True;
  end else begin
     If HintActive then begin
        Hint1.ReleaseHandle;
        HintActive := False;
     end;
  end;
  Repaint;
end;

procedure TALPapirGL.SetEditable(const Value: boolean);
begin
  FEditable := Value;
  DoPaint;
end;

procedure TALPapirGL.SetEnableSelectedFrame(const Value: boolean);
begin
  FEnableSelectedFrame := Value;
  if (SelectedFrame.Visible) and (not Value) then
     SelectedFrame.Visible := false;
end;

procedure TALPapirGL.Init(Sender: TObject);
begin
  ZoomPaper;
  if Assigned(FOnInit) then FOnInit(Self);
end;

procedure TALPapirGL.SetFilename(const Value: TFileName);
begin
  FFilename := Value;
  Changed := True;
  LoadFile(FFilename);
  UndoSave;
end;

function TALPapirGL.LoadFile(fnev: string): boolean;
var fn ,ext   : string;
    filetipus : string;
    i         : integer;
    ures      : boolean;
    oldCur    : TCursor;
begin
    Result := False;
    If not FAppend then Clear;

    fn := UpperCase(fnev);
    If not FileExists(fn) then begin
       MessageDlg('Nem létezõ file!',mtError,[mbOk],0);
       exit;
    end;

   oldCur := Screen.Cursor;
   Screen.Cursor := crHourGlass;
   ext := UpperCase(ExtractFileExt(fnev));
    if ext = '.SBN' then LoadGraphFromFile(fnev);
    if ext = '.SB'  then LoadOldGraphFromFile(fnev);
    if ext = '.PLT' then LoadFromPLT(fnev);
    if ext = '.DXF' then LoadFromDXF(fnev);

  ZoomPaper;
  UndoInit;
  if Assigned(FnewFile) then FNewFile(Self,fn);
  Screen.Cursor := oldCur;
  DoPaint;
  UndoInit;
end;

procedure TALPapirGL.DXFCurves;
begin

end;

procedure TALPapirGL.LoadFromDAT(Filename: STRING);
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

function TALPapirGL.LoadFromDXF(const FileName: string): Boolean;
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
(*
  newFileName:=ExtractFilePath(FileName)+'_'+ExtractFileName(FileName);
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
                N:=MakeCurve('Spline',-1,dmSpline,True,True,Closed);
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

function TALPapirGL.LoadFromPLT(const FileName: string): Boolean;
var f     : TEXTFILE;
    sor,S : string;
    k,N,i,pv,vpoz  : integer;
    x,y            : double;
    oldPLT: Boolean;
    KOD   : string;
    xx,yy : string;
    pd    : Boolean;  // Pen down = True; Pen up = False
    FirstPoint,EndPoint : TPointRec;
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
                   FCurveList.Items[N]:=FCurve;
                   if FCurve.Closed then Shape:=dmPolygon else Shape:=dmPolyline;
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
                   FirstPoint.x := x;
                   FirstPoint.y := y;
                   elso := False;
                end;
                FCurve.AddPoint(x,y);
                EndPoint.x := x;
                EndPoint.y := y;
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
               if FCurve.Closed then Shape:=dmPolygon else Shape:=dmPolyline;
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
            FirstPoint.x := x;
            FirstPoint.y := y;
            elso := False;
         end;
         FCurve.AddPoint(x,y);
         EndPoint.x := x;
         EndPoint.y := y;
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
  DoPaint;
end;
end;

function TALPapirGL.LoadOldGraphFromFile(const FileName: string): Boolean;
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
    If AutoUndo then UR.UndoSave;
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
    Dopaint;
    AutoUndo := au;
    Loading := False;
  end;
end;

function TALPapirGL.SaveGraphToFile(const FileName: string): Boolean;
var
  FileStream: TFileStream;
  GraphData: TNewGraphData;
  N: Integer;
begin
  Result:=False;
  try
    FileStream:=TFileStream.Create(FileName,fmCreate);
    try
      GraphData.Copyright := 'StellaFactory Obelisc Sablon Ver 1';
      GraphData.Version   := 1;
      GraphData.GraphTitle:=FGraphTitle;
      GraphData.Curves:=FCurveList.Count;
      FileStream.Position:=0;
      FileStream.Write(GraphData,SizeOf(GraphData));

      for N:=0 to Pred(GraphData.Curves) do
            SaveCurveToStream(FileStream,N);

      Result:=True;
    except
      Result:=False;
    end;
  finally
    FileStream.Free;
    Changed := False;
  end;
end;

function TALPapirGL.SaveToDAT(Filename: STRING): boolean;
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

function TALPapirGL.SaveToDXF(const FileName: string): boolean;
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

function TALPapirGL.SaveToTXT(Filename: STRING): boolean;
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
    for N:=0 to Pred(FCurve.FPoints.Count) do begin
      FCurve.GetPoint(N,xx,yy);
      s := Ltrim(format('%6.5f',[xx]))+' '+LTrim(format('%6.5f',[yy]));
      WriteLn(D,s);
      if N=0 then s0 := s;               // Save 0. point
    end;
      if FCurve.Closed then
         WriteLn(D,s0);
  end;
FINALLY
      if FCurve.Closed then
         WriteLn(D,s0);
    CloseFile(D);
    Loading := False;
    Result := True;
END;
END;

procedure TALPapirGL.SetpFazis(const Value: integer);
begin
  fpFazis := Value;
end;

procedure TALPapirGL.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
Var InputString: string;
    pr,pp : TPoint2d;
begin
  inherited;
  Origin := Point(x,y);
  CheckCurvePoints(X,Y);
  Tegla.P2 := MapPoint;

  if SelectedFrame.Visible then
  begin
       if Shift = [ssCtrl,ssLeft] then begin
          if SelectedFrame.IsNode(MapPoint,SensitiveRadius,SelectedFrame.ActualNode) then
          Case SelectedFrame.ActualNode of
          -1   : Cursor := crDefault;
          0..3 : Cursor := crHandpoint;
          4..7 : Cursor := crSize;
          8    : Cursor := crRotateSelected;
          end;
       End;
  End

  else

  begin

  Case Button of
  mbLeft:

     Case DrawMode of

     dmNone :
     begin
       // Choice selected curve
       if (ActionMode in [amNone,amMoveSelected]) and (CurveMatch or CPMatch) then begin
          if (ssCtrl in Shift) or (ssShift in Shift) then begin
             if Shift=[ssCtrl,ssLeft] then SelectAll(False);
             FCurve := FCurveList.Items[CPCurve];
             FCurve.Selected := not FCurve.Selected;
             if CurveMatch then ActionMode := amMoveSelected;
             if CPMatch then ActionMode := amMovePoint;
             if Assigned(fChangeSelected) then fChangeSelected(Self,FCurve,CPIndex);
          end else
             Selected := FCurveList.Items[CPCurve];
       end
       else
          Selected := nil;
       // Select Curve
       if (ActionMode = amSelect) and CurveMatch then
       begin
          FCurve := FCurveList.Items[CPCurve];
          FCurve.Selected := not FCurve.Selected;
          Selected := FCurve;
          if Assigned(fChangeSelected) then fChangeSelected(Self,FCurve,CPIndex);
       end;
       // Insert point
       if (ActionMode = amInsertPoint) and CurveMatch then
       begin
          FCurve := FCurveList.Items[CPCurve];
          Selected := FCurve;
          InsertPoint(CPCurve,FCurve.CPIndex,MapPoint);
       end;
       // Delete Point
       if (ActionMode = amDeletePoint) and CPMatch then
       begin
          FCurve := FCurveList.Items[CPCurve];
          DeletePoint(CPCurve,CPIndex);
       end;
       // New Begin Point
       if (ActionMode = amNewBeginPoint) and CPMatch then
          SetBeginPoint(CPCurve,CPIndex);

       if Shift=[ssAlt,ssLeft] then ActionMode := amSelectArea;
       if (ActionMode = amSelectArea) then
       if pFazis=1 then pFazis := -1;
     end;

     dmPoint:
            if pFazis=1 then begin
               NCH:=MakeCurve('Point',-1,DrawMode,True,True,False);
               AddPoint(NCH,MapPoint);
               pFazis := -1;
               DoPaint;
            end;

     dmLine:
            begin
               Case pFazis of
               0: NCH:=MakeCurve('Line',-1,DrawMode,True,True,False);
               1: pFazis := -1;
               end;
               AddPoint(NCH,MapPoint);
            end;

     dmPolyline:
            begin
               if pFazis=0 then
                  NCH:=MakeCurve('PolyLine',-1,DrawMode,True,True,False);
               AddPoint(NCH,MapPoint);
            end;


     dmPolygon:
            begin
               if pFazis=0 then
                  NCH:=MakeCurve('Polygon',-1,DrawMode,True,True,True);
               AddPoint(NCH,MapPoint);
            end;

     dmRectangle :
            begin
               Case pFazis of
               0: NCH:=MakeCurve('Rectangle',-1,DrawMode,True,True,True);
               1: begin
                  FCurve := FCurveList.Items[NCH];
                  FCurve.ClearPoints;
                  // Circle From left botton corner
                  FCurve.AddPoint(Tegla.P1.x,Tegla.P1.y);
                  FCurve.AddPoint(Tegla.P2.x,Tegla.P1.y);
                  FCurve.AddPoint(Tegla.P2.x,Tegla.P2.y);
                  AddPoint(NCH,Tegla.P1.x,Tegla.P2.y);
                  pFazis := -1;
                  end;
               end;
            end;

     dmCircle:
               Case pFazis of
               0: NCH:=MakeCurve('Circle',-1,DrawMode,True,True,False);
               1: begin
                    FCurve := FCurveList.Items[NCH];
                    FCurve.ClearPoints;
                    FCurve.AddPoint(tegla.P1);
                    AddPoint(NCH,MapPoint);
                    pFazis := -1;
                  end;
               end;

     dmText:
            begin
            end;

     dmEllipse   :
               Case pFazis of
               0: NCH:=MakeCurve('Ellipse',-1,DrawMode,True,True,True);
               1: begin
                    FCurve := FCurveList.Items[NCH];
                    FCurve.ClearPoints;
                    FCurve.AddPoint(tegla.P1);
                    AddPoint(NCH,MapPoint);
                    pFazis := -1;
                  end;
               end;

     dmArc:
           case pfazis of
           0: begin
              NCH:=MakeCurve('Arc',-1,DrawMode,True,True,False);
              AddPoint(NCH,MapPoint);
              end;
           1: begin
              FCurve.GetPoint(0,pr.x,pr.y);
              AddPoint(NCH,MapPoint);
              pp:=FelezoPont(Point2d(XToS(pr.x),YToS(pr.y)),Point2d(x,y));
              MovePt:=ClientToScreen(Point(Trunc(pp.x),Trunc(pp.y)));
              SetCursorPos(MovePt.x,MovePt.y);
              end;
           2: begin
              ChangePoint(NCH,1,MapPoint);
              pfazis:=-1;
              end;
           end;

     dmFreeHand :
               Case pFazis of
               0: NCH:=MakeCurve('Drawing',-1,dmPolyline,True,True,False);
               else begin
                    FCurve := FCurveList.Items[NCH];
                    FCurve.Shape := dmFreeHand;
                    Selected := FCurve;
                    pFazis := -1;
                    end
               end;

     dmSpline :
              Case pFazis of
              0:
              begin
                   NCH:=MakeCurve('Spline',-1,DrawMode,True,True,False);
                   polygonContinue := True;
              end;
              end;

     dmBSpline:
               Case pFazis of
               0:
               begin
                    NCH:=MakeCurve('BSpline',-1,DrawMode,True,True,True);
                    polygonContinue := True;
               end;
               End;

     end;

  mbRight:
  begin
    pFazis:=-1;
  end;

  end; // case Button of

  end;


  MovePt := Point(x,y);
  oldMovePt := Origin;
  Tegla.P1 := MapPoint;
  pFazis := pFazis+1;
end;


procedure TALPapirGL.MouseMove(Shift: TShiftState; X, Y: Integer);
var ap: integer;
    p: TPoint;
    w,he: integer;
    szog,d: double;
    dx,dy: integer;
begin
  inherited;

  if (Shift = []) then
  if not (ActionMode in [amInsertPoint,amMovePoint,amMoveSelected]) then
     CheckCurvePoints(X,Y);

  MovePt := Point(x,y);
  Tegla.P2 := MapPoint;
  dx:=x-oldMovePt.x;
  dy:=y-oldMovePt.y;
  d := sqrt(dx*dx+dy*dy);

  if fCoordLabel<>nil then begin
     fCoordLabel.caption :=Format('%6.1f : %6.1f',[MapPoint.x,MapPoint.y]);
     fCoordLabel.Repaint;
  end;

  ChangeCursor;

          if (Shift = [ssMiddle]) or (Shift = [ssCtrl,ssLeft]) then begin
             MoveWindow(x-oldMovePt.x,-(y-oldMovePt.y));
             Paning := True;
             if Paning then Screen.Cursor := crKez2;
             oldMovePt := MovePt;
             exit;
          end;

  if SelectedFrame.Visible then
  begin
       if (Shift = []) or (Shift = [ssCtrl]) then
          if SelectedFrame.IsNode(MapPoint,SensitiveRadius,ap) then
          Case ap of
          -1     : Cursor := crDefault;
          0..3   : Cursor := crHandpoint;
          4..7,9 : Cursor := crSize;
          8      : Cursor := crRotateSelected;
          end;
  End;

  if (ssLeft in Shift) then begin

     Case ActionMode of
     amNone           :
       begin
          if Shift = [ssShift,ssLeft] then begin
             MoveSelectedCurves(x-oldMovePt.x,-(y-oldMovePt.y));
             if SelectedFrame.Visible then
                SelectedFrame.Move(XToW(x)-XToW(oldMovePt.x),YToW(oldMovePt.y)-YToW(y));
             Moving := True;
          end;
          if Shift = [ssShift,ssCtrl,ssLeft] then
             if CurveMatch then begin
                MoveCurve(CPCurve,x-oldMovePt.x,-(y-oldMovePt.y));
                Moving := True;
             end;
          if Shift = [ssCtrl,ssLeft] then
          begin
             if SelectedFrame.Visible then
             begin
//                if SelectedFrame.ActualNode>-1 then begin
                case  SelectedFrame.ActualNode of
                -1,9: SelectedFrame.Move(XToW(x)-XToW(oldMovePt.x),YToW(oldMovePt.y)-YToW(y));
                0..3: SelectedFrame.SetNode(SelectedFrame.ActualNode,MapPoint);
                4..7: SelectedFrame.MoveEdge( SelectedFrame.ActualNode,
                          XToW(x)-XToW(oldMovePt.x),YToW(oldMovePt.y)-YToW(y) );
                8: with SelectedFrame do begin
                      RotAngle := -90+RadToDeg(Angle2D( Point2d(MapPoint.X-RCent.X,MapPoint.y-RCent.y) ));
                   end;
                end;
                invalidate;
//                end;
             end;
          end;
       end;
     amMovePoint      : DoMove(x,Height-y);
     amMoveSelected   : MoveCurve(CPCurve,x-oldMovePt.x,-(y-oldMovePt.y));
     amInsertPoint    : DoMove(x,Height-y);
     amRotateSelected :
         if (pFazis>1) then begin
          RotAngle := RelAngle2d(RotCentrum,MapPoint);
          szog := -Szogdiff(RotAngle,RelAngle2d(RotCentrum,SToW(oldMovePt)));
          RotateSelectedCurves(RotCentrum,szog);
          pFazis := pFazis + 1;
         end;
     amSelectArea   :
         begin
              invalidate;
         end;
     end;

     if (Shift = [ssAlt,ssLeft]) or (Shift = [ssCtrl,ssAlt,ssLeft]) then begin
        glRectangle( Tegla.P1,Tegla.P2 );
     end;
  end;

  // Draw a shape
  if Shift <> [ssRight] then
  if (DrawMode<>dmNone) and (pFazis>0) {and (not Zooming)} then begin
     FCurve := FCurveList.Items[NCH];
     if MaxPointsCount>=FCurve.FPoints.Count then begin
        Case DrawMode of
        dmArc :
        begin
          if Selected.FPoints.Count=1 then
             AddPoint(NCH,MapPoint)
          else
             ChangePoint(nch,1,MapPoint);
          Paint;
        end;
        dmFreeHand :
        begin
             AddPoint(NCH,MapPoint)
        end;
        else begin
        end;
        end;
     end else pFazis:=0;
  end;

  {Hint ablak rajzolása}
  if DrawMode=dmNone then
  begin
  If (CPMatch or CurveIn) and ((Shift = []) and (d<4)) then begin
     If Hinted then begin
        Hint1.Font.Size:=4;
        If CPMatch then begin
           Hintstr := fCurve.Name+' ['+IntToStr(CPCurve)+'/'+IntToStr(CPIndex)+']   ';
           Hint1.Font.Color := clBlack;
        end else begin
           Hintstr := GetCurveName(CPCurve)+' ['+IntToStr(CPCurve)+']   ';
           Hint1.Font.Color := clRed;
        end;
        p := ClientToScreen(point(x+8,y-18));
        w := Hint1.Canvas.TextWidth(Hintstr);
        he := Hint1.Canvas.TextHeight(Hintstr)+2;
        HintRect := Rect(p.x,p.y,p.x+w,p.y+he);
        ShowHintPanel(True);
     end;
  end
  else
       ShowHintPanel(False);
  end
  else
       ShowHintPanel(False);

  OldMovePt := Point(x,y);
end;

procedure TALPapirGL.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var R: TRect2d;
begin
  MovePt := Point(x,y);
  Tegla.P2 := MapPoint;
  if (ActionMode=amSelectArea) or (Shift = [ssAlt]) then begin
     R := Rect2d(tegla.p1.X,tegla.p1.y,tegla.p2.X,tegla.p2.Y);
     if EnableSelectedFrame then
     with SelectedFrame do begin
          SelectAll(False);
          UndoSave;
          init;
          SelectedFrame.Visible := True;
          OrigRect := R;
          SelectAllInArea(OrigRect);
          DeleteSelectedCurves;
     end else
          SelectAllInArea(R);
     ActionMode:=amNone;
   end;
  if (ActionMode in [amMovePoint,amMoveSelected]) then
     ActionMode := amNone;
  if AutoUndo then
     if (Button<>mbRight) and (DrawMode<>dmNone) then
        UndoSave;
  SelectedFrame.ActualNode:=-1;
  inherited;
end;

procedure TALPapirGL.ChangeCentrum(Sender: TObject);
begin
  Origo := CentToOrigo(Point2d(Centrum.x,Centrum.y));
  Repaint;
end;

procedure TALPapirGL.ChangeCursor;
begin
    // Cursors
  Cursor := crDefault;
  Case FActionMode of
  amNone           : Cursor := crDefault;
  amInsertPoint    : Cursor := crInsertPoint;
  amDeletePoint    : Cursor := crDeletePoint;
  amNewBeginPoint  : Cursor := crNewBeginPoint;
  amRotateSelected : Cursor := crRotateSelected;
  end;
  Case FDrawMode of
       dmNone     : Cursor := crDefault;
       dmPolyline : Cursor := crPolyline;
       dmPolygon  : Cursor := crPolygon;
  end;
     if CPMatch then Cursor:=crHandPoint else
     if CurveMatch then Cursor:=crDrag else
     if CurveIn then Cursor:=crMultiDrag;
end;

procedure TALPapirGL.SetLoading(const Value: boolean);
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

procedure TALPapirGL.CopySelectedToVirtClipboard;
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

procedure TALPapirGL.CurveToCent(AIndex: Integer);
var R : TRect2d;
begin
  R := TCurve(FCurveList.Items[Aindex]).BoundsRect;
  MoveCentrum((R.x1+R.x2)/2,(R.y1+R.y2)/2);
end;

procedure TALPapirGL.CutSelectedToVirtClipboard;
begin
  If AutoUndo then UR.UndoSave;
  CopySelectedToVirtClipboard;
  DeleteSelectedCurves;
  Changed := True;
  Changed := True;
  Invalidate;
end;

procedure TALPapirGL.PasteSelectedFromVirtClipboard;
begin
IF VirtualClipboard.Size>0 then begin
  If AutoUndo then UR.UndoSave;
  LoadGraphFromMemoryStream(VirtualClipboard);
  Changed := True;
  Invalidate;
end;
end;

procedure TALPapirGL.DoPaint;
begin
  Changed    := True;
  NewGraphic := True;
  On_Paint(Self);
  invalidate;
end;

procedure TALPapirGL.ClearWorkPoint;
begin

end;

procedure TALPapirGL.DrawWorkPoint(x, y: double);
begin

end;

procedure TALPapirGL.TestVekOut(dx, dy: extended);
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

  okesleltetes:=Kesleltetes;
  lepeskoz    := MMPerLepes;
  Kesleltetes := 1;
  lepesszam   := Round(d/lepeskoz);

  alfa := SzakaszSzog(0,0,dx,dy);
  xr := 0;
  yr := 0;
  s := lepeskoz*sin(alfa); c := lepeskoz*cos(alfa);

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
         Centrum := WorkPosition.WorkPoint
      else
         Repaint;

      if (lo(GetAsyncKeyState(VK_ESCAPE)) > 0)
      then begin
           STOP := True;
      end;

      if (lo(GetAsyncKeyState(VK_SPACE)) > 0)
      then begin
           STOP := False;
//           PillanatAllj := True;
      end;

      Application.ProcessMessages;
//      HRT.Delay(kesleltetes);
      if STOP then begin
//         Kesleltetes:=okesleltetes;
         Working := False;
         exit;
      end;
  end;
end;
  Kesleltetes:=okesleltetes;
end;


procedure TALPapirGL.TestWorking(AObject, AItem: integer);
var Cuv : TCurve;
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
            if fSablonSzinkron then Centrum:=Point2d(x,y);
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
            if fSablonSzinkron then Centrum:=Point2d(x,y);
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

procedure TALPapirGL.WorkpositionToCentrum;
begin
  Centrum := WorkPosition.WorkPoint;
end;

procedure TALPapirGL.SetSelectedIndex(const Value: integer);
begin
  if Selected=nil then begin
     FSelectedIndex:=-1;
     exit;
  end;
  FSelectedIndex := Value;
  if FSelectedIndex>FCurvelist.Count-1 then FSelectedIndex:=0;
end;

// A névlistát az objektumsorrendnek megfelelõen korrigálja
procedure TALPapirGL.ReOrderNames;
var i,n: integer;
    kod: array[0..13] of integer;
begin
  For i:=0 to Pred(FCurveList.Count) do begin
      FCurve := FCurveList.Items[I];
      FCurve.Name := DrawModeText[Ord(FCurve.Shape)]+'_'+IntToStr(i);
  end;
end;

(*
// Az objektumlista alapján automatikus vágási terv készítése
{Automatkus vágási terv képzés, a vágási segédvonalak políline-ok lesznek}
// BasePoint: a vágási 0 pozíció;
// Sorting  : Automatikusan keressen-e optimális sorrendet.

procedure TALPapirGL.AutoCutSequence(BasePoint: TPoint2d; Sorting: boolean;
                                    CutMethod: byte);
var i,j,idx: integer;
    x,y,d,dd : double;
    p0,p : TPoint2d;
    BaseCurve : TCurve;
    Cuv,CC    : TCurve;
    cuvIDX,pIdx: integer;
    Child: boolean;
    minP : integer;          // Kontúr min táv.-ú pontja a köv. poligonhoz
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
  SetNearestBeginPoint(BasePoint);

  Case CutMethod of
  0,1 :
      begin
         StripAll;
         R := GetDrawExtension;
         m := Grid.Margin;
         dx := 2*m-R.x1;
         dy := Paper.Height-2*m-R.y2;
         Eltolas(dx,dy);
         R := GetDrawExtension;

         // Keret létrehozása a rajz körül margin távolságban
         R := Rect2d(R.x1-m,R.y1-m,R.x2+m,R.y2+m);

         h:=MakeCurve('Border',-1,dmRectangle,True,True,True);
         AddPoint(H,R.x1,R.y1);
         AddPoint(H,R.x1,R.y2);
         AddPoint(H,R.x2,R.y2);
         AddPoint(H,R.x2,R.y1);
      end;
  end;

Try

  if Assigned(FPlan) then FPlan(Self,1,0);

  AutoSortObject(BasePoint);
  StripAll;              // Fiókok felfûzése
  invalidate;

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
           BaseCurve := FCurveList.Items[cuvIDX];

           if Sorting then
           if BaseCurve.IsDirect then BaseCurve.InversPointOrder;

           TempCurve := ObjectContour(BaseCurve,ContourRadius);

           while GetInnerObjectsCount(cuvIDX)>0 do begin
                 StripChildToParent(cuvIDX);
                 inc(i);
                 if i>20 then break;
           end;

           SaveCurveToStream(innerStream,cuvIDX);
           BaseCurve.Visible := False;
           p := BaseCurve.GetPoint2d(0);

           if Assigned(FPlan) then FPlan(Self,2,Trunc((100/cCount)*cCount/(VisibleCount+1)));

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

  if Assigned(FPlan) then FPlan(Self,3,0);
  ActionMode := amAutoPlan;

//  VektorisationAll(0.1);
  if CutMethod>1 then Elkerules;

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

  STOP := False;
  Cursor := oldCursor;
  Loading := False;
  AutoUndo := True;
  Changed := True;
  if AutoUndo then UndoSave;
  DoPaint;

  if Assigned(FPlan) then FPlan(Self,4,0);
end;
except
  Screen.Cursor := oldCursor;
  ActionMode := amNone;
  Invalidate;
  Loading := False;
  AutoUndo := True;
end;

end;
*)


//  ELKERÜLÉSI RUTIN A pontból B pontba

//============================================================================
procedure TALPapirGL.ElkerulesAB(Var eCurve: TCurve);

Type TInOutRec = record      // Kontúr metszési pont rekord
       mPont   : TPoint2d;   // metszéspont koordinátái
       idx     : integer;    // idx indexû pont után beszúrni
       d       : double;     // d távolság a kezdõponttól
     end;

Var mpArr : array of TmpRec; // Metszett polygonok tömbje
    i,j,k       : integer;
    mpRec       : TmpRec;         // Legközelebbi polygon és pont + d távolság
    BaseCurve   : TCurve;     // Elkerülõ polyline
    TempCurve   : TCurve;     // Kontúr
    Cuv         : TCurve;     // Legközelebbi polygon
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

    // Belépési és kilépési pontok keresése a kontúron
    // Result = metszéspontok száma
    function ContourInOut(cCuv: TCurve; AP,BP: TPoint2d; var BE,KI: TInOutRec): integer;
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
  if mpRec.d<ContourRadius then begin
     // Ha egy polygonhoz túl közel van, akkor kontúron kell haladni a
     // AB húr metszéspontjáig
     TempCurve := ObjectContour(Cuv,ContourRadius);
     mpCount := ContourInOut(TempCurve,AP,BP,BePont,KiPont);
     if mpCount=1 then
        TempCurve.InsertPoint(KiPont.Idx,KiPont.mPont.x,KiPont.mPont.y);
     // A kontúr legközelebbi pontjára lépek
     TempCurve.GetNearestPoint(AP,mpRec.Pointidx);
     KonturHossz  := TempCurve.GetKeruletSzakasz(KiPont.Idx,Pred(TempCurve.Count));
     KonturSzelet := TempCurve.GetKeruletSzakasz(0,KiPont.Idx);
              For i:=mpRec.Pointidx to KiPont.Idx do begin
                  p := TempCurve.GetPoint2d(i);
                  k := Pred(eCurve.Count);
                  eCurve.InsertPoint(k,p.x,p.y);
              end;
     AP := p;
  end;

  while IsCutPolygons(AP,BP)>0 do begin
        Cuv:=FCurveList.Items[mpArr[0].Cuvidx];   // = az átmetszett poligon
        TempCurve := ObjectContour(Cuv,ContourRadius);
        // Belépési és kilépési pontok keresése a kontúron
        mpCount := ContourInOut(TempCurve,AP,BP,BePont,KiPont);
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
        AP := p;
  end;
end;

//============================================================================
(*
procedure TALPapirGL.Elkerules;
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
    begin
         pCount := 0;
         SetLength(mpArr,1000);
         For ii:=0 to Pred(FCurveList.Count) do begin
             fc:=FCurveList.Items[ii];
             if fc.Shape=dmPolygon then
                if fc.IsCutLine(A,B,dd) then begin
                   mpArr[pCount].idx := ii;
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

    function GetNearPoint(cc: TCurve; A: TPoint2d): integer;
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
      invalidate;

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

             Cuv:=FCurveList.Items[mpArr[0].idx];   // = az átmetszett poligon
             if Cuv.Shape=dmPolygon then begin
                // Kontúrképzés az átmetszett poligon körül
                TempCurve := ObjectContour(Cuv,ContourRadius);
                // Megkeressük a kontúr A ponthoz legközelebbi pontját
                pIdx := GetNearPoint(TempCurve,p1);
                p1 := TempCurve.GetPoint2d(pIdx);
                // Addig haladunk a kontúron míg a poligont metszi a maradék szakasz
                metszes := Cuv.IsCutLine(p1,p2);
                if metszes then begin
                While Cuv.IsCutLine(p1,p2) or TempCurve.IsCutLine(p1,p2) do begin
                      k:=Pred(BaseCurve.Fpoints.Count);  // Cél pont
                      p2:=BaseCurve.GetPoint2d(k);
                      BaseCurve.InsertPoint(k,p1.x,p1.y);
                      Inc(pIdx);
                      if pIdx>Pred(TempCurve.Count) then pIdx:=0;
                      p1 := TempCurve.GetPoint2d(pIdx);
                end;
                      k:=Pred(BaseCurve.Fpoints.Count);  // Cél pont
                      p1 := TempCurve.GetPoint2d(pIdx);
                      BaseCurve.InsertPoint(k,p1.x,p1.y);
                end
                else begin
                      k:=Pred(BaseCurve.Fpoints.Count);  // Cél pont
                      p1 := TempCurve.GetPoint2d(pIdx);
                      BaseCurve.InsertPoint(k,p1.x,p1.y);
                      Break;
                end;
             end;
//             DrawCurve(BaseCurve,clBlue);
            // Veszem a polyline 2 utolsó pontját
             Cutting:=IsCutPolygons(p1,p2);
         end;
//         n := BaseCurve.Fpoints.Count;
//         Cutting:=IsCutPolygons(p1,p2);
//         if Cutting>0 then goto ujra;
         ContourOptimalizalas(BaseCurve);
      end;
  end;
  SignedNotCutting;
end;
*)
(* ContourOptimalizalas
   ----------------------------------------------------------------------------
   Lényege: A kontúron haladva növekvõ indexek szerint, minden esetben megvizsgáljuk,
   hogy a végponttól visszafelé haladva melyik az az elsõ kontúrpont, melyre
   közvetlen rálátás van. Nyilván, a közbülsõ pontok törölhetõk.
*)
    procedure TALPapirGL.ContourOptimalizalas(var Cuv: TCurve);
    Type mpRec = record
         idx : integer;
         d   : double;
         end;
    var kezdP,vegP  : TPoint2d;
        ii,jj,nn,n  : integer;
        PointsArray : array of TPoint2d;
        contCuv     : TCurve;
        mpArr       : array of mpRec;

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
                   if fc.Contour=nil then
                   if fc.Contour.Count=0 then begin
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

    begin
      SetLength(PointsArray,Cuv.FPoints.Count);
      for ii:=0 to Cuv.FPoints.Count-1 do
          PointsArray[ii] := Cuv.GetPoint2d(ii);
      nn := High(PointsArray);
      Cuv.ClearPoints;
      ii := 0;
      While ii<=(nn-1) do begin
            kezdP := PointsArray[ii];
            Cuv.AddPoint(kezdP);
            // Keressük a legtávolabbi, közvetlen rálátási pontot
            for jj:=nn downto (ii+1) do begin
                vegP := PointsArray[jj];
                if (IsCutPolygons(kezdP,vegP)=0) then
                begin
                   ii:=jj-1;
                   Break;
                end;
                Application.ProcessMessages;
                if STOP then
                   Break;
            end;
            Inc(ii);
            Application.ProcessMessages;
            if STOP then
               Break;
      end;
      if STOP then begin
         Cuv.ClearPoints;
         for ii:=0 to nn do
             Cuv.AddPoint(PointsArray[ii]);
      end else
         Cuv.AddPoint(PointsArray[ii]);
      SetLength(PointsArray,0);
      SetLength(mpArr,0);
    end;


procedure TALPapirGL.ClipperBool(ClipType: TClipType);
var Clip: TClipper;
    clipI,subjI: TPath;
    solution: TPaths;
    n: integer;
    Cuv,sCuv: TCurve;
    I: Integer;

    procedure AddSolution(solution : TPaths);
    var i,j : integer;
        p2  : TPoint2d;
        cCuv: TCurve;
    begin
        for I := 0 to High(solution) do
        Try
            cCuv := TCurve.Create;
            cCuv.Shape := Cuv.Shape;
            cCuv.Selected := true;
            for j := 0 to High(solution[I]) do
            begin
               p2 := Point2d( solution[I][j].X/100, solution[I][j].Y/100 );
               cCuv.AddPoint(p2);
            end;
            AddCurve(cCuv);
            cCuv.MoveCurve(10,10);
        Finally
        End;
    end;

    procedure PathToCurve(solution : TPaths);
    begin

    end;

begin
  if SelectedIndex>-1 then
  Try
     SelectAll(false);
     PoligonizeAll(0);
     VektorisationAll(0.1);

     Cuv := Selected;
     Cuv.ToPath(clipI,100);

     Clip := TClipper.Create;

     Clip.AddPath(clipI, ptClip, true);
     for I := 0 to Pred(FCurveList.Count) do
       if i<>SelectedIndex then
          if CheckForOverLaps(Cuv, Curves[i]) then begin
            Curves[i].ToPath(subjI,100);
            Clip.AddPath(subjI, ptSubject, true);
          end;

     Clip.Execute (ClipType, solution, pftNonZero, pftNonZero);

     if solution<>nil then
        AddSolution(solution);
     DoPaint;
  Finally
     Clip.Free;
  End;
end;

procedure TALPapirGL.cUnion;
begin
  ClipperBool(ctUnion);
end;

procedure TALPapirGL.cIntersection;
begin
  ClipperBool(ctIntersection);
end;

procedure TALPapirGL.cDifference;
begin
  ClipperBool(ctDifference);
end;

procedure TALPapirGL.cXor;
begin
  ClipperBool(ctXor);
end;

// ------------------    AutoCutSequence     -------------------------- //

// Az objektumlista alapján automatikus vágási terv készítése
{Automatkus vágási terv képzés, a vágási segédvonalak políline-ok lesznek}
// BasePoint: a vágási 0 pozíció;
// Sorting  : Automatikusan keressen-e optimális sorrendet.
// CutMethod : 0=Virtual box; 1=Real Box; 3=Classic
procedure TALPapirGL.AutoCutSequence(BasePoint: TPoint2d; Sorting: boolean;
                                    CutMethod: byte);
var i,j,idx: integer;
    x,y,d,dd : double;
    p0,p : TPoint2d;
    BaseCurve : TCurve;
    Cuv       : TCurve;
    cuvIDX,pIdx: integer;
    Child: boolean;
    minP : integer;          // Kontúr min táv.-ú pontja a köv. poligonhoz
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
  VisibleContours := true;

  Case CutMethod of
  0,1 :
      begin
         StripAll;
         R := GetDrawExtension;
         m := Grid.Margin;
         dx := 2*m-R.x1;
         dy := Paper.Height-2*m-R.y2;
         Eltolas(dx,dy);
         R := GetDrawExtension;

         // Keret létrehozása a rajz körül margin távolságban
         R := Rect2d(R.x1-m,R.y1-m,R.x2+m,R.y2+m);

         h:=MakeCurve('Border',-1,dmRectangle,True,True,True);
         AddPoint(H,R.x1,R.y1);
         AddPoint(H,R.x1,R.y2);
         AddPoint(H,R.x2,R.y2);
         AddPoint(H,R.x2,R.y1);
      end;
  end;

Try

  if Assigned(FPlan) then FPlan(Self,1,0);

  AutoSortObject(BasePoint);
  StripAll;              // Fiókok felfûzése
  invalidate;

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
           BaseCurve := FCurveList.Items[cuvIDX];

           if Sorting then
           if BaseCurve.IsDirect then BaseCurve.InversPointOrder;

           if BaseCurve<>nil then BaseCurve.VisibleContour := true;

           TempCurve := BaseCurve.Contour;
//           TempCurve := ObjectContour(BaseCurve,ContourRadius);

           (*
           while GetInnerObjectsCount(cuvIDX)>0 do begin
                 StripChildToParent(cuvIDX);
                 inc(i);
                 if i>20 then break;
           end;
           *)

           SaveCurveToStream(innerStream,cuvIDX);
           BaseCurve.Visible := False;
           p := BaseCurve.GetPoint2d(0);

           if Assigned(FPlan) then FPlan(Self,2,Trunc((100/cCount)*cCount/(VisibleCount+1)));

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
     TempCurve := BaseCurve.Contour;
     TempCurve.GetPoint(0,x,y);
  end else begin
  end;

  AddPoint(idx,x,y);
  // Vissza az Workorigóba
  AddPoint(idx,BasePoint);

  InnerStream.Clear;
  ReOrderNames;
  invalidate;

  if Assigned(FPlan) then FPlan(Self,3,0);
  ActionMode := amAutoPlan;

//  VektorisationAll(0.1);
//  if CutMethod>1 then Elkerules;

  If CutMethod=0 then begin
     // Virtualbox-nál a befoglaló keretet töröljük
     Cuv := FCurveList[1];
     Cuv.DeletePoint(R.x1,R.y1);
     Cuv.DeletePoint(R.x1,R.y2);
     Cuv.DeletePoint(R.x2,R.y2);
     Cuv.DeletePoint(R.x2,R.y1);
  end;
  If CutMethod=1 then begin
     // A befoglaló téglalap vágódjon utoljára
     // elsõ 4 pontot a végére másoljuk
     Cuv := FCurveList[1];
     Cuv.DeletePoint(R.x1,R.y1);
     Cuv.DeletePoint(R.x1,R.y2);
     Cuv.DeletePoint(R.x2,R.y2);
     Cuv.DeletePoint(R.x2,R.y1);
     Cuv.AddPoint(R.x1,R.y2);
     Cuv.AddPoint(R.x2,R.y2);
     Cuv.AddPoint(R.x2,R.y1);
     Cuv.AddPoint(R.x1,R.y1);
     Cuv.InsertPoint(0,R.x1,R.y2);
     Cuv := FCurveList[2];
     Cuv.ChangePoint(0,R.x1,R.y2);
     Cuv.ChangePoint(1,BasePoint.x,BasePoint.y);
  end;

  STOP := False;
  Cursor := oldCursor;
  Loading := False;
  AutoUndo := True;
  Changed := True;
  if AutoUndo then UndoSave;

  if Assigned(FPlan) then FPlan(Self,4,0);
  DoPaint;

end;
except
  Screen.Cursor := oldCursor;
  ActionMode := amNone;
  Invalidate;
  Loading := False;
  AutoUndo := True;
end;
end;

//=======================  Elkerules  =====================================


procedure TALPapirGL.Elkerules;
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

//                If Cuv.Contour = nil then begin
                   // Kontúrképzés az átmetszett poligon körül
//                   TempCurve := Cuv.Contour;
                   TempCurve := ObjectContour(Cuv,ContourRadius);
                   Vektorisation(0.1,TempCurve);
                   ContourOptimalizalas(BaseCurve);
//                end else
//                   TempCurve := Cuv.Contour;

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

end.
