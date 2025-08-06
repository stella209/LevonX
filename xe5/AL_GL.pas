(*  AL_OpenGl  Delphi 5 komponens

    TCustomControl descendant OpenGL component for fast graphic

    Windowed control, with OpenGl properties;
    Some predefinied function:
         Keyboard:   + and -  : magnify;
                     R ang L  : Rotate Right and left;
         Mouse:      Dragging with pressed left mose button;
                     Magnifying with pressed right mose button;
                     Wheel for magnify;

    By: Agócs László StellaSOFT
*)

unit AL_GL;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, ExtCtrls,
  Forms, Dialogs, alOpenGL, NewGeom, ClipBrd, Math, JPeg, StObjects;

const
  GLF_START_LIST = 100000;
  Inch  : double = 25.4500; // mm

type
  TVector3d = array[0..2] of double;

  PPixelArray = ^TPixelArray;
  TPixelArray = array [0..0] of Byte;

  TSzin = record
    R,G,B : double;
    width : integer;
  end;

  TShadeModel = (smFlat,smSmooth);
  TEditMode   = (emView,emEdit);

  TDigitAction = ( daSync, daMap, daImage );

//  TPaintEvent      = procedure(Sender: TObject) of object;
  TChangeWindow    = procedure(Sender: TObject; Cent: TPoint2D;  Zoom: Double; CursorPos: TPoint ) of object;

  T_Image = class(TPersistent)
  private
    FZoom: double;
    FFileName: string;
    FCentrum: TPoint2d;
    FOnChange: TNotifyEvent;
    FHeight: integer;
    FWidth: integer;
    FRotAngle: double;
    FVisible: boolean;
    procedure Changed; dynamic;
    procedure SetCentrum(const Value: TPoint2d);
    procedure SetFileName(const Value: string);
    procedure SetZoom(const Value: double);
    procedure SetHeight(const Value: integer);
    procedure SetWidth(const Value: integer);
    // Texture
    function CreateTexture(Texture: String): cardinal;
    function CreateTextureFromBMP(Bitmap: TBitmap): cardinal;
    procedure SetRotAngle(const Value: double);
    procedure SetVisible(const Value: boolean);
  public
    Image    : Cardinal;
    constructor Create(AOwner:TObject);
  published
    property FileName: string read FFileName write SetFileName;
    property Width   : integer read FWidth write SetWidth;
    property Height  : integer read FHeight write SetHeight;
    property Centrum : TPoint2d read FCentrum write SetCentrum;
    property Zoom    : double read FZoom write SetZoom;
    property Visible : boolean read FVisible write SetVisible;
    property RotAngle: double read FRotAngle write SetRotAngle;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TAL_CustomOpenGL = class(TCustomControl)
  private
    FCentralCross: boolean;
    FRotAngle: double;
    FZoom: extended;
    FChangeWindow: TChangeWindow;
    FBackColor: TColor;
    FOnPaint: TNotifyEvent;
    FCentrum: TPoint2d;
    FShadeModel: TShadeModel;
    FOnInitGL: TNotifyEvent;
    FOnAfterPaint: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FOpenGLPaint: boolean;
    FCursorCross: boolean;
    FDblClickEnabled: boolean;
    FBackImage: T_Image;
    fVisibleImage: boolean;
    FDigitAction: TDigitAction;
    FCentralisZoom: boolean;
    fGrid: TGrid;
    fPaper: TALPaper;
    FFillColor: TColor;
    FEnableActions: boolean;
    procedure WMEraseBkGnd(var Message:TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    Procedure CMChildkey( Var msg: TCMChildKey ); message CM_CHILDKEY;
    procedure CMMouseEnter(var msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var msg: TMessage); message CM_MOUSELEAVE;
    procedure SetCentralCross(const Value: boolean);
    procedure SetCentrum(const Value: TPoint2d);
    procedure SetBackColor(const Value: TColor);
    procedure SetRotAngle(const Value: double);
    procedure SetShadeModel(const Value: TShadeModel);
    procedure SetZoom(const Value: extended);
    procedure SetDCPixelFormat;
    procedure Demo;
    function GetCanvas: TCanvas;
    procedure SetBackImage(const Value: T_Image);
    procedure SetVisibleImage(const Value: boolean);
    procedure SetCursorCross(const Value: boolean);
    function CreateTexture(Texture: String): cardinal;
    function CreateTextureFromBMP(Bitmap: TBitmap): cardinal;
    procedure SetOpenGLPaint(const Value: boolean);
    procedure ChangePaperExtension(Sender: TObject);
  protected
    OpenGL_OK: boolean;           // OpenGL initialized
    procedure Change(Sender: TObject);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint): Boolean; override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure KeyDown(var Key: Word;Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure DblClick;  override;
  public
    DC: HDC;
    hrc : HGLRC;
    BackBMP: TBitmap;                  // For drawing in back
    OrtoLeft,OrtoRight,OrtoBottom,OrtoTop: double;
    SelRect : TRect;
    rSIN,rCOS : double;               // sin and cos of RotAngle;
    CursorPos : TPoint;
    MouseIn   : boolean;

    MapPoint  : TPoint2d;             // Actual map point coordinates
    oldMapPoint  : TPoint2d;             // Actual map point coordinates
    origin,movept,oldmovept: TPoint;

    Moving    : boolean;              // True, if any action in process
                                      // Moving, or Magnifying the graphic

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure InitGL;
    procedure Paint; override;
    procedure ReDraw;
    procedure ClearBackground;
    procedure DrawCentralCross;
    procedure DrawCursorCross(p: TPoint); overload;
    procedure DrawCursorCross(x,y: integer); overload;
    procedure DrawAxis;
    procedure DrawGrid;

    procedure CopyToClipboard;

    // Coordinate functions
    function XToW(x: double): double;
    function YToW(y: double): double;
    function XToS(x: double): integer;
    function YToS(y: double): integer;
    function WToS(p: TPoint2d): TPoint;
    function SToW(p: TPoint): TPoint2d;  overload;
    function SToW(x,y: double): TPoint2d; overload;

    function GetWorkArea:TRect2d;
    procedure SetActualTransform;

    procedure ZoomPaper;
    procedure MoveWindow(x, y: double);
    procedure ShiftWindow(x, y: double);
    procedure MoveCentrum(fx,fy: double);

    procedure SBI;         // Save the current bitmap to BackBMP
    procedure LBI;         // Load the current bitmap from BackBMP

    // Drawing primitives
    procedure glColor(col: TColor);
    procedure glsquare(p: TPoint2d; a: double);
    procedure glsquareFill(p: TPoint2d; a: double);
    procedure glRectangle(p1,p2,p3,p4: TPoint2d);  overload;
    procedure glRectangle(p: TPoint2d; a,b: double); overload;
    procedure glRectangle(p1,p2: TPoint2d); overload;
    procedure glCircle(u,v,r: double); overload;
    procedure glCircle(Cent: TPoint2d; r: double); overload;
    procedure glCircle(Cent,KerPoint: TPoint2d); overload;
    procedure glEllipse(p1,p2: TPoint2d);
    procedure glPrint(x,y,Height,Angle: double; text : string); overload;
    procedure glPrint(fName: string;x,y,Height,Angle: double; text: string); overload;
    procedure glLine(X0,Y0,X1,Y1:extended); overload;
    procedure glLine(p1,p2: TPoint2d); overload;
    procedure Plane(X0,Y0,X1,Y1,X2,Y2,X3,Y3:extended);
    procedure glPolygon(p: array of TPoint2d); overload;
    procedure glPolygon(p: array of TPoint3d); overload;
    procedure glPolygonFill(p: array of TPoint2d); overload;
    procedure glPolygonFill(p: array of TPoint3d); overload;
    procedure glPolyLine(p: array of TPoint3d);
    procedure PolygonTess( n: array of TPoint3d ); overload;
    procedure PolygonTess( x, y, z, AngleRotate: single; n: array of TPoint3d ); overload;

    { FONT RUTINS }
    procedure InitFont(dc: HDC; Fontname: PChar);
    procedure Draw3DText(Text: String; X, Y, Z, AX, AY, AZ, Height: GLFloat);

    property Canvas        : TCanvas  read GetCanvas;
    property Centrum       : TPoint2d read FCentrum write SetCentrum;
    property DblClickEnabled: boolean read FDblClickEnabled write FDblClickEnabled default True;
    property Window        : TRect2d  read GetWorkArea;
  published
    property OpenGLPaint   : boolean      read FOpenGLPaint write SetOpenGLPaint;
    Property BackColor     : TColor       read FBackColor write SetBackColor;
    property BackImage     : T_Image      read FBackImage write SetBackImage;
    property BackImageVisible : boolean   read fVisibleImage write SetVisibleImage default True;
    property CentralCross  : boolean      read FCentralCross write SetCentralCross;
    property CentralisZoom : boolean      read FCentralisZoom write FCentralisZoom;
    property CursorCross   : boolean      read FCursorCross write SetCursorCross;
    property DigitAction   : TDigitAction read FDigitAction write FDigitAction;
    property EnableActions : boolean      read FEnableActions write FEnableActions;
    Property FillColor     : TColor       read FFillColor write FFillColor;
    property Grid          : TGrid        read fGrid Write fGrid;
    property Paper         : TALPaper     read fPaper write fPaper;
    property RotAngle      : double       read FRotAngle write SetRotAngle;
    property ShadeModel    : TShadeModel  read FShadeModel write SetShadeModel;
    property Zoom          : extended     read FZoom write SetZoom;
    property OnChangeWindow: TChangeWindow read FChangeWindow write FChangeWindow;
    property OnInitGL      : TNotifyEvent read FOnInitGL write FOnInitGL;
    property OnMouseEnter  : TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave  : TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnPaint       : TNotifyEvent read FOnPaint write FOnPaint;
    property OnAfterPaint  : TNotifyEvent read FOnAfterPaint write FOnAfterPaint;
  end;

  TAL_OpenGL = class(TAL_CustomOpenGL)
    property OpenGLPaint;
    property BackImage;
    property BackImageVisible;
    property CentralCross;
    property CentralisZoom;
    property CursorCross;
    Property BackColor;
    property DigitAction;
    property EnableActions;
    property Grid;
    property Paper;
    property RotAngle;
    property ShadeModel;
    property Zoom;
    property OnChangeWindow;
    property OnInitGL;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnPaint;
    property OnAfterPaint;
    property Align;
    property Enabled;
    property Font;
    property TabStop;
    property OnClick;
    property OnDblClick;
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


  function ColorToSzin(c:TColor):TSzin;

//  procedure Register;

implementation
(*
procedure Register;
begin
  RegisterComponents('AL', [TAL_OpenGL]);
end;
*)
function ColorToSzin(c:TColor):TSzin;
begin
With Result do begin
  R:=GetRValue(c)/255;
  G:=GetGValue(c)/255;
  B:=GetBValue(c)/255;
end;
end;

{ TALOpenGL }

constructor TAL_CustomOpenGL.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  OpenGL_OK      := False;
  fPaper         := TALPaper.Create;
  fPaper.OnChange:= Change;
  BackBMP        := TBitmap.Create;
  BackImage      := T_Image.Create(Self);
  FGrid          := TGrid.Create;
  FGrid.OnChange := Change;
  fVisibleImage  := True;
  Canvas.Font.Name := 'Times New Roman';
  width          := 200;
  height         := 200;
  OrtoLeft       := -10;
  OrtoRight      := 10;
  OrtoBottom     := -10;
  OrtoTop        := 10;
  fBackColor     := clWhite;
  FFillColor     := clBlack;
  FCentralCross  := True;
  FCentrum       := Point2d(0,0);
  FZoom          := 2;
  FShadeModel    := smSmooth;
  FRotAngle      := 0;
  DoubleBuffered := True;
  FDblClickEnabled := True;
  FCentralisZoom := False;
  TabStop        := True;
  OpenGLPaint    := True;
  MouseIn        := False;
  Moving         := False;
  FEnableActions := True;
end;

destructor TAL_CustomOpenGL.Destroy;
begin
Try
  BackBMP.Free;
  BackImage.Free;
  Paper.Free;
  Grid.Free;
  wglMakeCurrent(0, 0);
  wglDeleteContext(hrc);
  inherited Destroy;
except
end;
end;

procedure TAL_CustomOpenGL.InitGL;
begin
if not OpenGL_OK then
Try
Try
  DC := GetDC(Handle);

  SetDCPixelFormat;
  hrc := wglCreateContext(DC);
  wglMakeCurrent(DC, hrc);

  glShadeModel(GL_SMOOTH);
  glEnable(GL_TEXTURE_2D);

  glEnable(GL_ALPHA_TEST);
  glAlphaFunc(GL_GEQUAL,0.8);

//  glEnable(GL_DEPTH_TEST);
  glDrawBuffer(GL_BACK);
  glDepthFunc(GL_LESS);
  glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);

  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_COLOR,GL_SRC_COLOR);
//  glBlendFunc(GL_ONE_MINUS_SRC_COLOR,GL_ONE_MINUS_SRC_COLOR);

  glMatrixMode(GL_PROJECTION);
  glViewport(0, 0, ClientWidth, ClientHeight);

except
  OpenGL_OK  := False;
  Application.MessageBox('OpenGL cannot initialised!','OpenGl Error',IDOK);
end;
finally
  OpenGL_OK  := True;
//  InitFont(dc,PChar('Arial'));
  BackColor := FBackColor;
  Zoom := FZoom;
  if Assigned(FOnInitGL) then FOnInitGL(Self);
end;
end;

procedure TAL_CustomOpenGL.SetDCPixelFormat;
var
  nPixelFormat: Integer;
  pfd: TPixelFormatDescriptor;
begin
  FillChar(pfd, SizeOf(pfd), 0);

  with pfd do begin
    nSize     := sizeof(pfd);
    nVersion  := 1;
    dwFlags   := PFD_DRAW_TO_WINDOW or
                 PFD_SUPPORT_OPENGL or
                 PFD_DOUBLEBUFFER;
    iPixelType:= PFD_TYPE_RGBA;
    cColorBits:= 24;
    cDepthBits:= 32;
    iLayerType:= PFD_MAIN_PLANE;
  end;

  nPixelFormat := ChoosePixelFormat(DC, @pfd);
  SetPixelFormat(DC, nPixelFormat, @pfd);
end;

procedure TAL_CustomOpenGL.SetOpenGLPaint(const Value: boolean);
{ if TRUE then OpenGL else GDI (Windows GDI API) drawing enabled }
begin
  FOpenGLPaint := Value;
  if not Value then
  begin
    Canvas.Brush.Color := BackColor;
    Canvas.Rectangle(Canvas.ClipRect);
  end;
  Repaint;
end;

procedure TAL_CustomOpenGL.Change(Sender: TObject);
begin
  Invalidate;
end;

procedure TAL_CustomOpenGL.ChangePaperExtension(Sender: TObject);
begin
  ZoomPaper;
end;

procedure TAL_CustomOpenGL.ClearBackground;
var sz: TSzin;
begin
  sz := ColorToSzin(FBackColor);
  glClearColor(sz.R,sz.G,sz.B,1);
end;

procedure TAL_CustomOpenGL.CMChildkey(var msg: TCMChildKey);
var dx,dy: integer;
    k:integer;
begin
  if FEnableActions then
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
     Centrum := Point2d(Centrum.x+dx,Centrum.y+dy);
  end
  Else begin
    msg.result:= 0;
    inherited;
  end;
end;

procedure TAL_CustomOpenGL.CMMouseEnter(var msg: TMessage);
begin
  inherited;
  if TabStop then Setfocus;
  MouseIn := True;
  if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
  invalidate;
end;

procedure TAL_CustomOpenGL.CMMouseLeave(var msg: TMessage);
begin
  inherited;
  MouseIn := False;
  if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
  invalidate;
end;

procedure TAL_CustomOpenGL.Paint;
var
  ps : TPaintStruct;
begin
//inherited;
if OpenGLPaint then begin
  BeginPaint(Handle, ps);
  if not OpenGL_OK then InitGL;
     glLoadIdentity;
     glPushMatrix;
     DrawGrid;

  If Assigned(FOnPaint) then begin
     If Assigned(FOnPaint) then FOnPaint(Self);
  end;
  If Assigned(FOnAfterPaint) then FOnAfterPaint(Self);

  if FCentralCross then DrawCentralCross;
  if FCursorCross then DrawCursorCross(CursorPos);

     glPopMatrix;
  SwapBuffers(DC);
  EndPaint(Handle, ps);
  SBI;
end else begin
  If Assigned(FOnPaint) then FOnPaint(Self);
  If Assigned(FOnAfterPaint) then FOnAfterPaint(Self);
end;
end;

procedure TAL_CustomOpenGL.ReDraw;
begin
  if OpenGLPaint then
  begin
     if not OpenGL_OK then InitGL;
     glViewport(0,0,width ,height);
     glMatrixMode(GL_PROJECTION);
     glLoadIdentity;
     gluOrtho2D(OrtoLeft, OrtoRight, OrtoBottom, OrtoTop);
     glMatrixMode(GL_MODELVIEW);
     glDrawBuffer(GL_FRONT_AND_BACK);
     glClear (GL_DEPTH_BUFFER_BIT or GL_COLOR_BUFFER_BIT);
  end;
  Paint;
end;

procedure TAL_CustomOpenGL.Plane(X0, Y0, X1, Y1, X2, Y2, X3, Y3: extended);
begin
    glBegin(GL_QUADS);
    glVertex3f(X0,Y0,-0.1);
    glVertex3f(X1,Y1,-0.1);
    glVertex3f(X2,Y2,-0.1);
    glVertex3f(X3,Y3,-0.1);
    glEnd();
end;

procedure TAL_CustomOpenGL.PolygonTess( n: array of TPoint3d );
var
 i:integer;
 vvv : array of TVector3d;
 tglutessobj : PGLUtesselator;
begin
 tglutessobj := glunewtess();
 gluTessCallback( tglutessobj, GLU_TESS_BEGIN, @glBegin );
 gluTessCallback( tglutessobj, GLU_TESS_VERTEX, @glVertex3dv );
 gluTessCallback( tglutessobj, GLU_TESS_END, @glEnd );

 SetLength( vvv, Length( n ) );

// glNewList(1, GL_COMPILE);

 gluTessBeginPolygon ( tglutessobj ,vvv );
  For i:=0 to High( n )  do
   begin
    vvv[ i ][ 0 ] := n[ i ].x;
    vvv[ i ][ 1 ] := n[ i ].y;
    vvv[ i ][ 2 ] := n[ i ].z;
    gluTessVertex(tglutessobj, @vvv[ i ], @vvv[ i ] );
   end ;
 gluTessEndPolygon( tglutessobj );
// glEndList;

// glCallList( 1 );
// glDeleteLists( 1, 1 );

 gluDeleteTess( tglutessobj );
 SetLength( vvv, 0 );
end;

procedure TAL_CustomOpenGL.PolygonTess( x, y, z, AngleRotate: single; n: array of TPoint3d );
var
 i:integer;
 vvv : array of TVector3d;
 tglutessobj : PGLUtesselator;
begin
// glPushMatrix();
 tglutessobj := glunewtess();
 gluTessCallback( tglutessobj, GLU_TESS_BEGIN, @glBegin );
 gluTessCallback( tglutessobj, GLU_TESS_VERTEX, @glVertex3dv );
 gluTessCallback( tglutessobj, GLU_TESS_END, @glEnd );

 SetLength( vvv, Length( n ) );

 glTranslated(x,y,z);
 glRotatef(AngleRotate, 0,0,1);

// glNewList(1, GL_COMPILE);

 gluTessBeginPolygon ( tglutessobj, vvv );
  For i:=0 to High( n )  do
   begin
    vvv[ i ][ 0 ] := n[ i ].x;
    vvv[ i ][ 1 ] := n[ i ].y;
    vvv[ i ][ 2 ] := n[ i ].z;
    gluTessVertex(tglutessobj, @vvv[ i ], @vvv[ i ] );
   end ;
 gluTessEndPolygon( tglutessobj );

// glEndList;

// glCallList( 1 );
 glDeleteLists( 1, 1 );

 gluDeleteTess( tglutessobj );
 SetLength( vvv, 0 );

// glPopMatrix();
end;

procedure TAL_CustomOpenGL.DrawCentralCross;
begin
        glLineWidth(2);
        glBegin(GL_LINES);
          glColor3d(1.0,0.0,0.0);
          glVertex2d(FCentrum.x,OrtoTop);
          glVertex2d(FCentrum.x,OrtoBottom);
          glVertex2d(OrtoLeft,FCentrum.y);
          glVertex2d(OrtoRight,FCentrum.y);
        glEnd;
end;

procedure TAL_CustomOpenGL.DrawCursorCross(p: TPoint);
begin
  DrawCursorCross(p.x,p.y);
end;

procedure TAL_CustomOpenGL.DrawCursorCross(x,y: integer);
var p: TPoint2d;
begin
  if MouseIn then begin
     p := SToW(Point(x,y));
     glLineWidth(1);
     glColor(clBlue);
     glBegin(GL_LINES);
          glVertex2d(p.x,OrtoTop);
          glVertex2d(p.x,OrtoBottom);
          glVertex2d(OrtoLeft,p.y);
          glVertex2d(OrtoRight,p.y);
     glEnd;
  end;
end;

procedure TAL_CustomOpenGL.DrawGrid;
var
    kp,kp0: TPoint2d;
    tav,kpy,mar,marx,mary: extended;
    sWidth,sHeight: double;
    i: integer;
    GridTav : integer;     // Distance between lines
    R : TRect2d;
    szorzo  : double;

    procedure XGrid;
    begin
      glBegin(GL_LINES);
      While kp.x<=sWidth do begin
            glVertex2d(kp.x,kp.y);
            glVertex2d(kp.x,sHeight-0.1);
            kp.x:=kp.x+tav;
      end;
      glEnd;
    end;

    procedure YGrid;
    begin
      glBegin(GL_LINES);
      While kp.y<=sHeight do begin
            glVertex2d(kp.X,kp.y);
            glVertex2d(sWidth,kp.y);
            kp.y:=kp.y+tav;
      end;
      glEnd;
    end;

begin
if Paper.Visible then
begin
   glColor(Paper.Color);
   Plane(Paper.Left,Paper.Bottom,Paper.Left+Paper.Width,Paper.Bottom,
         Paper.Left+Paper.Width,Paper.Bottom+Paper.Height,
         Paper.Left,Paper.Bottom+Paper.Height );
end;

if Grid.Visible then
begin

   if Grid.Metric = meMM then
      szorzo := 1
   else
      szorzo := inch/10;

   GridTav := 1;

   For i:=0 to 2 do begin
   if ((i=0) and (Zoom>8)) or ((i=1) and (Zoom>4)) or ((i=2) and (Zoom>1)) then begin
      Case GridTav of
      1:
      begin
           glColor(Grid.SubgridColor);
           glLineWidth(1);
      end;
      10:
      begin
           glColor(Grid.MaingridColor);
           glLineWidth(2);
      end;
      100:
      begin
           glColor(Grid.MaingridColor);
           glLineWidth(4);
      end;
      end;

      tav  := Gridtav*szorzo;
      if Grid.OnlyOnpaper and Paper.Visible then
      begin
           kp.x := Paper.Left; kp.y := Paper.Bottom; kp0:=kp;
           sWidth := Paper.Width; sHeight := Paper.Height;
           XGrid;
           kp.x := Paper.Left; kp.y := Paper.Bottom; kp0:=kp;
           sWidth := Paper.Width; sHeight := Paper.Height;
           YGrid;
      end else
      begin
           kp.x := 0; kp.y := 0; kp0:=kp;
           sWidth := OrtoRight; sHeight := OrtoTop;
           XGrid;
           kp.x := 0; kp.y := 0; kp0:=kp;
           YGrid;
      end;
   end;
      GridTav := GridTav * 10;
   end;

  // Margin draws
  if Paper.Visible then
  begin
     glLineWidth(3);
     glColor(clOlive);
     R:=Rect2d( Paper.Left+Grid.Margin, Paper.Bottom+Grid.Margin,
                Paper.Left+Paper.Width-Grid.Margin, Paper.Bottom+Paper.Height-Grid.Margin);
     glRectangle( Point2d(R.x1,R.y1),Point2d(R.x2,R.y2) );
  end;

end;
end;

procedure TAL_CustomOpenGL.DrawAxis;
var p: TPoint2d;
    w: TRect2d;
begin
  if MouseIn then begin
  glPushMatrix;
        w := Window;
        glLineWidth(1);
        glBegin(GL_LINES);
          glColor(clWhite);
          if (OrtoLeft<0) and (OrtoRight>0) then begin
             glVertex2d(0,w.y1);
             glVertex2d(0,w.y2);
          end;
          if (OrtoBottom<0) and (OrtoTop>0) then begin
             glVertex2d(w.x1,0);
             glVertex2d(w.x2,0);
          end;
        glEnd;
  glPopMatrix;
  end;
end;

procedure TAL_CustomOpenGL.SetCentralCross(const Value: boolean);
begin
  FCentralCross := Value;
  invalidate;
end;

procedure TAL_CustomOpenGL.Demo;
begin
      glBegin(GL_POLYGON);
        glColor3d(1.0,0.0,0.0);
        glVertex2d(-30.0,-30.0);

        glColor3d(0.0,1.0,0.0);
        glVertex2d(30.0,-30.0);

        glColor3d(0.0,0.0,1.0);
        glVertex2d(30.0,30.0);

        glColor3d(1.0,1.0,1.0);
        glVertex2d(-30.0,30.0);
     glEnd;
     glBegin(GL_POLYGON);
        glColor4d(1.0,0.0,0.0,1.0);
        glVertex2d(0.0,-30.0);

        glColor4d(0.0,0.0,1.0,1.0);
        glVertex2d(30.0,0.0);

        glColor4d(1.0,1.0,0.0,1.0);
        glVertex2d(10.0,10.0);

        glColor4d(1.0,0.0,1.0,1.0);
        glVertex2d(0.0,30.0);

        glColor4d(0.0,0.5,1.0,1.0);
        glVertex2d(-10.0,10.0);

        glColor4d(5.0,0.5,0.0,1.0);
        glVertex2d(-30.0,0.0);
     glEnd;
        //INNEN LESZ A KIRAJZOLAS
     glFlush;
end;

procedure TAL_CustomOpenGL.SBI;
begin
  StretchBlt(BackBMP.Canvas.Handle,0,0,width,Height,
             Canvas.handle,0,0,width,Height,SRCCOPY)
end;

procedure TAL_CustomOpenGL.LBI;
begin
  StretchBlt(Canvas.Handle,0,0,width,Height,
             BackBMP.Canvas.handle,0,0,width,Height,SRCCOPY)
end;

procedure TAL_CustomOpenGL.glLine(X0, Y0, X1, Y1: extended);
begin
    glBegin(GL_LINES);
    glVertex3f(X0,Y0,0);
    glVertex3f(X1,Y1,0);
    glEnd();
end;

procedure TAL_CustomOpenGL.SetCentrum(const Value: TPoint2d);
var wx,hx: GLDouble;
begin
  FCentrum := Value;
  wx := (Width/2)/FZoom;
  hx := (Height/2)/FZoom;
  OrtoLeft   := Value.x - wx;
  OrtoRight  := Value.x + wx;
  OrtoBottom := Value.y - hx;
  OrtoTop    := Value.y + hx;
  RePaint;
  If Assigned(FChangeWindow) then FChangeWindow(Self,FCentrum,FZoom,MovePt);
end;

procedure TAL_CustomOpenGL.SetBackColor(const Value: TColor);
Var szin: TSzin;
begin
  FBackColor := Value;
  If not OpenGL_OK then exit;
  szin:=ColorToSzin(Value);
  glClearcolor(szin.R,szin.G,szin.B,0);
  invalidate;
end;

procedure TAL_CustomOpenGL.SetRotAngle(const Value: double);
begin
  FRotAngle := Value;
  rSIN := SIN(DegToRad(FRotAngle)); rCOS := COS(DegToRad(FRotAngle));
  repaint;
end;

procedure TAL_CustomOpenGL.SetShadeModel(const Value: TShadeModel);
begin
if OpenGL_OK then
Try
  FShadeModel := Value;
  Case Value of
  smFlat   : glShadeModel(GL_FLAT);
  smSmooth : glShadeModel(GL_SMOOTH);
  end;
  invalidate;
except
end;
end;

procedure TAL_CustomOpenGL.SetZoom(const Value: extended);
var wx,hy,dx,dy: GLDouble;
    x0,y0,x1,y1: GLDouble;
    dZoom      : GLDouble;
begin
if OpenGL_OK then
Try
    wx := (Width/2)/Value;
    hy := (Height/2)/Value;
    dx := 0; dy := 0;
    OrtoLeft   := FCentrum.x - wx;
    OrtoRight  := FCentrum.x + wx;
    OrtoBottom := FCentrum.y - hy;
    OrtoTop    := FCentrum.y + hy;
 if CentralisZoom then begin
    dZoom := Value/FZoom;
    x0 := MapPoint.x - FCentrum.X;
    y0 := MapPoint.y - FCentrum.Y;
    x1 := x0 * dZoom;
    y1 := y0 * dZoom;
    dx := x1-x0;
    dy := y1-y0;
    MoveWindow(-dx,-dy);
 end;
  FZoom := Value;
  If Assigned(FChangeWindow) then FChangeWindow(Self,FCentrum,FZoom, MovePt);
  invalidate;
EXCEPT
end;
end;

procedure TAL_CustomOpenGL.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1
end;

procedure TAL_CustomOpenGL.WMPaint(var Msg: TWMPaint);
begin
  ReDraw;
  Msg.Result := 1;
end;

procedure TAL_CustomOpenGL.WMSize(var Msg: TWMSize);
var w,h: GLDouble;
    wx,hx: GLDouble;
begin
Try
  w  := Msg.Width;
  h  := Msg.Height;
  wx := (w/2)/FZoom;
  hx := (h/2)/FZoom;
  OrtoLeft   := FCentrum.x - wx;
  OrtoRight  := FCentrum.x + wx;
  OrtoBottom := FCentrum.y - hx;
  OrtoTop    := FCentrum.y + hx;
  if BackImage.Visible then begin
     BackBMP.Width  := Msg.Width;
     BackBMP.height := Msg.Height;
  end;
  ReDraw;
except
end;
end;

procedure TAL_CustomOpenGL.DblClick;
begin
  if FDblClickEnabled then
  Centrum := SToW(Point(Origin.x,Height-Origin.y));
  inherited;
end;

procedure TAL_CustomOpenGL.KeyDown(var Key: Word; Shift: TShiftState);
var zFactor: double;
begin
  if FEnableActions then
  begin
  if Shift=[ssCtrl] then zFactor:=1.1
  else zFactor:=2;
  Case Key of
  VK_ADD     : begin Zoom:=zFactor*Zoom;end;
  VK_SUBTRACT: begin Zoom:=1/zFactor*Zoom;end;
  VK_SPACE   : RotAngle := 0;
  end;
  end;
  inherited KeyDown(Key,Shift);
end;

procedure TAL_CustomOpenGL.KeyPress(var Key: Char);
begin
  if FEnableActions then
  Case Key of
  'K','k' : CentralCross:=not CentralCross;
  ^C      : CopyToClipboard;
  'L','l' : RotAngle := FRotAngle+1;
  'R','r' : RotAngle := FRotAngle-1;
  'F','f' : RotAngle := FRotAngle+1;
  end;
  inherited KeyPress(Key);
end;

procedure TAL_CustomOpenGL.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  CursorPos := Point(x,Height-y);
  MapPoint := SToW(Point(x,Height-y));
  oldMapPoint := MapPoint;
  origin:=Point(x,y);
  oldmovept:=origin;
  if Shift<>[] then
     Moving := True;
  inherited MouseDown(Button, Shift, X, Height-Y);
end;

procedure TAL_CustomOpenGL.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  dx,dy: GLDouble;
begin
  CursorPos := Point(x,Height-y);
  MapPoint := SToW(Point(x,Height-y));
  MovePt:=Point(x,y);

  inherited MouseMove(Shift,x,y);

  if FEnableActions then
  begin
  { Moving graphic with pressed left mouse button }
  IF Shift=[ssLeft] then
  begin
//    Centrum := Point2d(Centrum.x+oldMapPoint.x-MapPoint.x,Centrum.y+oldMapPoint.y-MapPoint.y);
    dx := (oldMovePt.x-MovePt.x);
    dy := (oldMovePt.y-MovePt.y);
    ShiftWindow(dx,dy);
  end;

  { Magnifying graphic with pressed right mouse button }
  IF Shift=[ssRight] then
  begin
    if oldMovePt.y<>MovePt.y then
       if oldMovePt.y>MovePt.y then
          Zoom := FZoom*1.1
       else
          Zoom := FZoom*0.9;
  end;

  end;

  oldMovePt := MovePt;
  oldMapPoint := MapPoint;
  invalidate;
end;

procedure TAL_CustomOpenGL.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  Moving := False;
  MapPoint := SToW(Point(x,Height-y));
  inherited;
end;

procedure TAL_CustomOpenGL.CopyToClipboard;
begin
  SBI;
  Clipboard.Assign(BackBMP);
end;

function TAL_CustomOpenGL.CreateTexture(Texture: String): cardinal;
var
  bitmap: TBitmap;
  Pict:TJpegImage;
  BMInfo : TBitmapInfo;
  I,ImageSize : Integer;
  Temp : Byte;
  MemDC : HDC;
  Tex: PPixelArray;
  ext: string;
begin
  glGenTextures(1, @Result);
  glBindTexture(GL_TEXTURE_2D, Result);
  Bitmap:=TBitMap.Create;

  ext := UpperCase(ExtractFileExt(Texture));

  if ext='.JPG' THEN begin
     Pict:=TJpegImage.Create;
     Pict.LoadFromFile(Texture);
     BitMap.Assign(Pict);
     Pict.Free;
  end;
  if ext='.BMP' THEN begin
     BitMap.LoadFromFile(Texture);
  end;

  with BMinfo.bmiHeader do begin
    FillChar (BMInfo, SizeOf(BMInfo), 0);
    biSize := sizeof (TBitmapInfoHeader);
    biBitCount := 24;
    biWidth := Bitmap.Width;
    biHeight := Bitmap.Height;
    ImageSize := biWidth * biHeight;
    biPlanes := 1;
    biCompression := BI_RGB;

    MemDC := CreateCompatibleDC (0);
    GetMem (Tex, ImageSize *3);
    try
      GetDIBits (MemDC, Bitmap.Handle, 0, biHeight, Tex, BMInfo, DIB_RGB_COLORS);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,GL_LINEAR);
      glTexImage2d(GL_TEXTURE_2D, 0, 3, biwidth, biheight, 0, GL_BGR_EXT, GL_UNSIGNED_BYTE, tex);
      For I := 0 to ImageSize - 1 do begin
          Temp := tex [I * 3];
          tex [I * 3] := tex [I * 3 + 2];
          tex [I * 3 + 2] := Temp;
      end;
     finally
      DeleteDC (MemDC);
      Bitmap.Free;
      freemem(tex);
   end;
  end;
end;

function TAL_CustomOpenGL.CreateTextureFromBMP(Bitmap: TBitmap): cardinal;
var
  BMInfo : TBitmapInfo;
  I,ImageSize : Integer;
  Temp : Byte;
  MemDC : HDC;
  Tex: PPixelArray;
begin
  glGenTextures(1, @Result);
  glBindTexture(GL_TEXTURE_2D, Result);

  with BMinfo.bmiHeader do begin
    FillChar (BMInfo, SizeOf(BMInfo), 0);
    biSize := sizeof (TBitmapInfoHeader);
    biBitCount := 24;
    biWidth := Bitmap.Width;
    biHeight := Bitmap.Height;
    ImageSize := biWidth * biHeight;
    biPlanes := 1;
    biCompression := BI_RGB;

    MemDC := CreateCompatibleDC (0);
    GetMem (Tex, ImageSize *3);
    try
      GetDIBits (MemDC, Bitmap.Handle, 0, biHeight, Tex, BMInfo, DIB_RGB_COLORS);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,GL_LINEAR);
      glTexImage2d(GL_TEXTURE_2D, 0, 3, biwidth, biheight, 0, GL_BGR_EXT, GL_UNSIGNED_BYTE, tex);
      For I := 0 to ImageSize - 1 do begin
          Temp := tex [I * 3];
          tex [I * 3] := tex [I * 3 + 2];
          tex [I * 3 + 2] := Temp;
      end;
     finally
      DeleteDC (MemDC);
      freemem(tex);
   end;
  end;
end;

function TAL_CustomOpenGL.GetWorkArea: TRect2d;
begin
  Result := Rect2d(OrtoLeft,OrtoTop,OrtoRight,OrtoBottom);
end;

procedure TAL_CustomOpenGL.MoveCentrum(fx, fy: double);
begin
  Centrum := Point2d(fx,fy);
end;

procedure TAL_CustomOpenGL.MoveWindow(x, y: double);
begin
  Centrum := Point2d(Centrum.x-x/FZoom,Centrum.y-y/FZoom);
end;

procedure TAL_CustomOpenGL.ShiftWindow(x, y: double);
var dx,dy : double;
begin
    dx := (Width/2)+x;
    dy := (Height/2)-y;
    Centrum := SToW(Point(Round(dx),Round(dy)));
end;

function TAL_CustomOpenGL.SToW(x, y: double): TPoint2d;
begin
  Result := Point2d(XToW(x),YToW(y));
end;

function TAL_CustomOpenGL.SToW(p: TPoint): TPoint2d;
begin
  Result := Point2d(XToW(p.x),YToW(p.y));
  if FRotAngle<>0 then
  RelRotate2D(Result,FCentrum,DegToRad(-FRotAngle));
end;

function TAL_CustomOpenGL.WToS(p: TPoint2d): TPoint;
begin
  if FRotAngle<>0 then
  RelRotate2D(p,FCentrum,DegToRad(FRotAngle));
  Result := Point(XToS(p.x),YToS(p.y));
end;

function TAL_CustomOpenGL.XToS(x: double): integer;
var asp: double;
begin
  asp := Width/Height;
  Result := Trunc(asp*Width/2+(x-FCentrum.x)*FZoom);
end;

function TAL_CustomOpenGL.YToS(y: double): integer;
begin
  Result := Trunc((Height/2+(y-FCentrum.y)*FZoom));
end;

function TAL_CustomOpenGL.XToW(x: double): double;
begin
  Result := FCentrum.x+(x-Width/2)/FZoom;
end;

function TAL_CustomOpenGL.YToW(y: double): double;
begin
  Result := FCentrum.y+(y-Height/2)/FZoom;
end;


procedure TAL_CustomOpenGL.ZoomPaper;
var nagyx,nagyy : extended;
begin
  If Paper.Visible then begin
  Try
     nagyx := Width /(Paper.Width + 20);
     nagyy := Height/(Paper.Height + 20);
  except
     nagyx:=1; nagyy:=1;
  end;
  If nagyx > nagyy Then nagyx:= nagyy;
  Centrum := Point2d(Paper.Width/2,Paper.Height /2);
  Zoom:= nagyx;
  end;
end;

procedure TAL_CustomOpenGL.glCircle(u, v, r: double);
var i: integer;
begin
  glBegin(GL_LINE_STRIP);
    For i:=0 to 360 do
        glVertex2d(u+r*cos(DegToRad(i)),v+r*sin(DegToRad(i)));
  glEnd;
end;

procedure TAL_CustomOpenGL.glCircle(Cent: TPoint2d; r: double);
begin
  glCircle(Cent.X,Cent.Y,r);
end;

procedure TAL_CustomOpenGL.glCircle(Cent, KerPoint: TPoint2d);
begin
  glCircle(Cent.X,Cent.Y,RelDist2d(Cent,KerPoint));
end;

// Ellipszis 2 átellenes pontja
procedure TAL_CustomOpenGL.glEllipse(p1,p2: TPoint2d);
var i: integer;
    u,v,r1,r2: double;
begin
  u:=(p2.x+p1.x)/2; v:=(p2.y+p1.y)/2;
  r1:=Abs(p2.x-p1.x)/2; r2:=Abs(p2.y-p1.y)/2;
  glBegin(GL_LINE_STRIP);
    For i:=0 to 360 do
        glVertex2d(u+r1*cos(DegToRad(i)),v+r2*sin(DegToRad(i)));
  glEnd;
end;

procedure TAL_CustomOpenGL.glLine(p1, p2: TPoint2d);
begin
  glLine(p1.X,p1.Y,p2.X,p2.Y);
end;

procedure TAL_CustomOpenGL.glPrint(fName: string; x, y, Height, Angle: double;
  text: string);
var szoveg: PChar;
procedure InitFontEx(dc: HDC; Fontname: PChar);
var
  lf : TLOGFONT;
  hFontNew, hOldFont : HFONT;
  agmf : Array [0..255] of TGLYPHMETRICSFLOAT ;
begin
  FillChar(lf, SizeOf(lf), 0);
  lf.lfHeight               :=   -38 ;
  lf.lfWeight               :=   FW_NORMAL ;
  lf.lfCharSet              :=   ANSI_CHARSET ;
  lf.lfOutPrecision         :=   OUT_DEFAULT_PRECIS ;
  lf.lfClipPrecision        :=   CLIP_DEFAULT_PRECIS ;
  lf.lfQuality              :=   DEFAULT_QUALITY ;
  lf.lfPitchAndFamily       :=   FF_DONTCARE OR DEFAULT_PITCH;
  lstrcpy(lf.lfFaceName, Fontname) ;

  hFontNew := CreateFontIndirect(lf);
  hOldFont := SelectObject(DC, hFontNew);

  wglUseFontOutlines(DC, 32, 128, 99000, 0.0, 0.15,
                     WGL_FONT_POLYGONS, @agmf);

  DeleteObject(SelectObject(DC,hOldFont));
  DeleteObject(SelectObject(DC,hFontNew));
end;
begin
  if Height*Zoom>7 then begin
     InitFontEx(DC,PChar(fName));
     glPushMatrix;
       glTranslatef(Y, X, 0);
       glPushMatrix;
       glRotatef(Angle, 0, 0, 1);
       glScaled(Height,Height,0);
       glPushMatrix;
         glListBase(99000-32);
         glCallLists(Length(Text), GL_UNSIGNED_BYTE, pChar(Text));
       glPopMatrix;
       glPopMatrix;
       glPopMatrix;
  end;
end;

procedure TAL_CustomOpenGL.glPrint(x,y,Height,Angle: double; text: string);
begin
  if Height*Zoom>7 then
       Draw3DText(Text,y,x,0,0,0,Angle,Height);
end;

procedure TAL_CustomOpenGL.glRectangle(p1, p2, p3, p4: TPoint2d);
begin
  glBegin(GL_LINE_STRIP);
    glVertex2d(p1.x,p1.y);
    glVertex2d(p2.x,p2.y);
    glVertex2d(p3.x,p3.y);
    glVertex2d(p4.x,p4.y);
    glVertex2d(p1.x,p1.y);
  glEnd;
end;

procedure TAL_CustomOpenGL.glRectangle(p: TPoint2d; a, b: double);
begin
  glBegin(GL_LINE_STRIP);
    glVertex2d(p.x-a/2,p.y+b/2);
    glVertex2d(p.x+a/2,p.y+b/2);
    glVertex2d(p.x+a/2,p.y-b/2);
    glVertex2d(p.x-a/2,p.y-b/2);
    glVertex2d(p.x-a/2,p.y+b/2);
  glEnd;
end;

function TAL_CustomOpenGL.GetCanvas: TCanvas;
begin
  Result := inherited Canvas;
end;

function TAL_CustomOpenGL.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos);
  if Focused then
  if WheelDelta<0 then Zoom:=0.9*Zoom  else Zoom:=1.1*Zoom;
end;

function TAL_CustomOpenGL.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelDown(Shift, MousePos);
end;

function TAL_CustomOpenGL.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelUp(Shift, MousePos);
end;

{ FONT RUTINS }
{ ===================================================================== }
procedure TAL_CustomOpenGL.InitFont(dc: HDC; Fontname: PChar);
var
  lf : TLOGFONT;
  hFontNew, hOldFont : HFONT;
  agmf : Array [0..255] of TGLYPHMETRICSFLOAT ;
begin
  FillChar(lf, SizeOf(lf), 0);
  lf.lfHeight               :=   -38 ;
  lf.lfWeight               :=   FW_NORMAL ;
  lf.lfCharSet              :=   ANSI_CHARSET ;
  lf.lfOutPrecision         :=   OUT_DEFAULT_PRECIS ;
  lf.lfClipPrecision        :=   CLIP_DEFAULT_PRECIS ;
  lf.lfQuality              :=   DEFAULT_QUALITY ;
  lf.lfPitchAndFamily       :=   FF_DONTCARE OR DEFAULT_PITCH;
  lstrcpy (lf.lfFaceName, Fontname) ;

//  hFontNew := CreateFont(lf);
  hFontNew := CreateFontIndirect(lf);
  hOldFont := SelectObject(DC, hFontNew);

  wglUseFontOutlines(DC, 0, 255, GLF_START_LIST, 0.0, 0.15,
                     WGL_FONT_POLYGONS, @agmf);

  DeleteObject(SelectObject(DC,hOldFont));
  DeleteObject(SelectObject(DC,hFontNew));
end;

procedure TAL_CustomOpenGL.Draw3DText(Text: String; X, Y, Z, AX, AY, AZ, Height: GLFloat);
begin
 glPushMatrix;
  glTranslatef(Y, X, Z);
 glPushMatrix;
  glRotatef(AX, 1, 0, 0);
  glRotatef(AY, 0, 1, 0);
  glRotatef(AZ, 0, 0, 1);
  glScaled(Height,Height,0);
 glPushMatrix;
//  glTranslatef(-0.46, -0.31, 0);
  glListBase(GLF_START_LIST);
  glCallLists(Length(Text), GL_UNSIGNED_BYTE, pChar(Text));
 glPopMatrix;
 glPopMatrix;
 glPopMatrix;
end;

procedure TAL_CustomOpenGL.glColor(col: TColor);
var sz: TSzin;
begin
  sz := ColorToSzin(col);
  glColor3f(sz.R,sz.G,sz.B);
end;

procedure TAL_CustomOpenGL.SetActualTransform;
begin
  glTranslated(Centrum.x,Centrum.y,0);
  glRotated(RotAngle,0,0,1);
  glTranslated(-Centrum.x,-Centrum.y,0);
end;

procedure TAL_CustomOpenGL.SetBackImage(const Value: T_Image);
begin
  FBackImage := Value;
end;

procedure TAL_CustomOpenGL.SetVisibleImage(const Value: boolean);
begin
  fVisibleImage := Value;
  Repaint;
end;

procedure TAL_CustomOpenGL.SetCursorCross(const Value: boolean);
begin
  FCursorCross := Value;
  Repaint;
end;

procedure TAL_CustomOpenGL.glPolygon(p: array of TPoint3d);
var i: integer;
begin
  glBegin(GL_LINE_LOOP);
    For i:=0 to High(p) do begin
        glVertex3f(p[i].x,p[i].y,0);
    end;
  glEnd;
end;

procedure TAL_CustomOpenGL.glPolygon(p: array of TPoint2d);
var i: integer;
begin
  glBegin(GL_LINE_LOOP);
    For i:=0 to High(p) do begin
        glVertex2f(p[i].x,p[i].y);
    end;
  glEnd;
end;

procedure TAL_CustomOpenGL.glPolygonFill(p: array of TPoint2d);
begin

end;

procedure TAL_CustomOpenGL.glPolygonFill(p: array of TPoint3d);
begin
  PolygonTess(p);
end;

procedure TAL_CustomOpenGL.glPolyLine(p: array of TPoint3d);
var i: integer;
begin
  glBegin(GL_LINE_STRIP);
    For i:=0 to High(p) do begin
        glVertex3f(p[i].x,p[i].y,0);
    end;
  glEnd;
end;

procedure TAL_CustomOpenGL.glRectangle(p1, p2: TPoint2d);
begin
  glRectangle(p1,Point2d(p2.X,p1.y),p2,Point2d(p1.X,p2.y))
end;


{ Draws a square}
procedure TAL_CustomOpenGL.glsquare(p: TPoint2d; a: double);
begin
  glRectangle(Point2d(p.X-a/2,p.Y+a/2),Point2d(p.X+a/2,p.Y-a/2));
end;

procedure TAL_CustomOpenGL.glsquareFill(p: TPoint2d; a: double);
begin
  glBegin(GL_QUADS);
    glVertex2f(p.x-a/2,p.y+a/2);
    glVertex2f(p.x+a/2,p.y+a/2);
    glVertex2f(p.x+a/2,p.y-a/2);
    glVertex2f(p.x-a/2,p.y-a/2);
  glEnd();
end;

{ T_Image ------------------------------------------------------------}

procedure T_Image.Changed;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

constructor T_Image.Create(AOwner: TObject);
begin
  inherited Create;
  Image     := 0;
  FFileName := '';
  FCentrum  := Point2d(0,0);
  FRotAngle := 0;
  FZoom     := 1;
end;

procedure T_Image.SetCentrum(const Value: TPoint2d);
begin
  FCentrum := Value;
end;

procedure T_Image.SetFileName(const Value: string);
begin
  FFileName := Value;
  Image := CreateTexture(FFileName);
end;

procedure T_Image.SetHeight(const Value: integer);
begin
  FHeight := Value;
end;

procedure T_Image.SetWidth(const Value: integer);
begin
  FWidth := Value;
end;

procedure T_Image.SetZoom(const Value: double);
begin
  FZoom := Value;
end;

function T_Image.CreateTexture(Texture: String): cardinal;
var
  bitmap: TBitmap;
  Pict:TJpegImage;
  BMInfo : TBitmapInfo;
  I,ImageSize : Integer;
  Temp : Byte;
  MemDC : HDC;
  Tex: PPixelArray;
  ext: string;
begin
if FileExists(Texture) then
begin

  glenable(GL_TEXTURE_2D);
  glGenTextures(1, @Result);
  glBindTexture(GL_TEXTURE_2D, Result);

  Bitmap:=TBitMap.Create;

  ext := UpperCase(ExtractFileExt(Texture));

  if ext='.JPG' THEN begin
     Pict:=TJpegImage.Create;
     Pict.LoadFromFile(Texture);
     BitMap.Assign(Pict);
     Pict.Free;
  end;
  if ext='.BMP' THEN begin
     BitMap.LoadFromFile(Texture);
  end;

  Width := Bitmap.Width;
  Height := Bitmap.Height;

  with BMinfo.bmiHeader do begin
    FillChar (BMInfo, SizeOf(BMInfo), 0);
    biSize := sizeof (TBitmapInfoHeader);
    biBitCount := 24;
    biWidth := Bitmap.Width;
    biHeight := Bitmap.Height;
    ImageSize := biWidth * biHeight;
    biPlanes := 1;
    biCompression := BI_RGB;

    MemDC := CreateCompatibleDC (0);
    GetMem (Tex, ImageSize *3);
    try
      GetDIBits (MemDC, Bitmap.Handle, 0, biHeight, Tex, BMInfo, DIB_RGB_COLORS);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,GL_LINEAR);
      glTexImage2d(GL_TEXTURE_2D, 0, 3, biwidth, biheight, 0, GL_BGR_EXT, GL_UNSIGNED_BYTE, tex);
      For I := 0 to ImageSize - 1 do begin
          Temp := tex [I * 3];
          tex [I * 3] := tex [I * 3 + 2];
          tex [I * 3 + 2] := Temp;
      end;
     finally
      DeleteDC (MemDC);
      Bitmap.Free;
      freemem(tex);
      Changed;
   end;
  end;
end;
end;

function T_Image.CreateTextureFromBMP(Bitmap: TBitmap): cardinal;
var
  BMInfo : TBitmapInfo;
  I,ImageSize : Integer;
  Temp : Byte;
  MemDC : HDC;
  Tex: PPixelArray;
begin
  glGenTextures(1, @Result);
  glBindTexture(GL_TEXTURE_2D, Result);

  Width := Bitmap.Width;
  Height := Bitmap.Height;

  with BMinfo.bmiHeader do begin
    FillChar (BMInfo, SizeOf(BMInfo), 0);
    biSize := sizeof (TBitmapInfoHeader);
    biBitCount := 24;
    biWidth := Bitmap.Width;
    biHeight := Bitmap.Height;
    ImageSize := biWidth * biHeight;
    biPlanes := 1;
    biCompression := BI_RGB;

    MemDC := CreateCompatibleDC (0);
    GetMem (Tex, ImageSize *3);
    try
      GetDIBits (MemDC, Bitmap.Handle, 0, biHeight, Tex, BMInfo, DIB_RGB_COLORS);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,GL_LINEAR);
      glTexImage2d(GL_TEXTURE_2D, 0, 3, biwidth, biheight, 0, GL_BGR_EXT, GL_UNSIGNED_BYTE, tex);
      For I := 0 to ImageSize - 1 do begin
          Temp := tex [I * 3];
          tex [I * 3] := tex [I * 3 + 2];
          tex [I * 3 + 2] := Temp;
      end;
     finally
      DeleteDC (MemDC);
      freemem(tex);
      Changed;
   end;
  end;
end;

procedure T_Image.SetRotAngle(const Value: double);
begin
  FRotAngle := Value;
  Changed;
end;

procedure T_Image.SetVisible(const Value: boolean);
begin
  FVisible := Value;
  Changed;
end;

initialization
  Initopengl;
end.

