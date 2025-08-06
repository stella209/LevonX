
(*  StOpenGl  Delphi 5 komponens

    TCustomControl descendant OpenGL component for fast graphic

    Windowed kontrol, OpenGl tulajdonságokkal
    grafika megjelenitésére.

    By: Agócs László StellaSOFT
*)

unit AL_OpenGl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, ExtCtrls,
  Forms, Dialogs, alOpenGL, NewGeom, ClipBrd, Math, JPeg;

type
  TSzin = record
    R,G,B : double;
    width : integer;
  end;

type
  PPixelArray = ^TPixelArray;
  TPixelArray = array [0..0] of Byte;

  TShadeModel = (smFlat,smSmooth);

  TPaintEvent      = procedure(Sender: TObject) of object;
  TChangeWindow    = procedure(Sender: TObject; Cent: TPoint2D;  Zoom: Double) of object;

  TALOpenGL = class(TCustomControl)
  private
    FClearColor   : TColor;
    FZoom     : extended;
    FOnPaint      : TPaintEvent;
    FCentrum: TPoint2d;
    FShadeModel: TShadeModel;
    FCentralCross: boolean;
    FOnAfterPaint: TPaintEvent;
    FRotAngle: double;
    FOnInitGL: TNotifyEvent;
    FZoomFaktor: extended;
    procedure WMEraseBkGnd(var Message:TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    Procedure CMChildkey( Var msg: TCMChildKey ); message CM_CHILDKEY;
    procedure CMMouseEnter(var msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var msg: TMessage); message CM_MOUSELEAVE;
    procedure SetClearColor(const Value: TColor);
    procedure SetZoom(const Value: extended);
    procedure SetCentrum(const Value: TPoint2d);
    procedure SetShadeModel(const Value: TShadeModel);
    procedure SetCentralCross(const Value: boolean);
    function GetCanvas: TCanvas;
    procedure SetRotAngle(const Value: double);
  protected
    OpenGL_OK: boolean;           // OpenGL initialized
    procedure StartOpengl;
    procedure SetDCPixelFormat;
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
    BackBMP: TBitmap;      // For drawing in back
    OrtoLeft,OrtoRight,OrtoBottom,OrtoTop: double;
    origin,movept,oldmovept: TPoint;
    SelRect : TRect;
    Tex : Cardinal;
    
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure ReDraw;
    procedure Demo;
    procedure DrawCentralCross;

    // Coordinate functions
    function XToW(x: integer): double;
    function YToW(y: integer): double;
    function XToS(x: double): integer;
    function YToS(y: double): integer;
    function WToS(p: TPoint2d): TPoint;
    function SToW(p: TPoint): TPoint2d;

    function GetWorkArea:TRect2d;
    function GetTotalMapArea:TRect2d;

    procedure MoveWindow(x, y: double);
    procedure ShiftWindow(x, y: double);
    procedure CopyToClipboard;

    function CreateTexture(Texture: String): cardinal;
    function LoadGLTextures: boolean;

    // Drawing primitives
    procedure glRectangle(p1,p2,p3,p4: TPoint2d);  overload;
    procedure glRectangle(p: TPoint2d; a,b: double); overload;
    procedure glCircle(u,v,r: double);
    procedure glPrint(text : string);

    procedure DrawText(x,y:glFloat; s:string);

    procedure SBI;         // Save the current bitmap to BackBMP
    procedure LBI;         // Load the current bitmap from BackBMP

    property Canvas        : TCanvas  read GetCanvas;
    property Centrum       : TPoint2d read FCentrum write SetCentrum;
  published
    property CentralCross  : boolean   read FCentralCross write SetCentralCross;
    Property ClearColor    : TColor    read FClearColor write SetClearColor;
    property RotAngle      : double    read FRotAngle write SetRotAngle;
    property ShadeModel    : TShadeModel read FShadeModel write SetShadeModel;
    property Zoom          : extended  read FZoom write SetZoom;
    property ZoomFaktor    : extended  read FZoomFaktor write FZoomFaktor;
    property Align;
    property Enabled;
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
    property OnPaint: TPaintEvent read FOnPaint write FOnPaint;
    property OnInitGL: TNotifyEvent read FOnInitGL write FOnInitGL;
    property OnAfterPaint: TPaintEvent read FOnAfterPaint write FOnAfterPaint;
  end;


  procedure Register;
  function ColorToSzin(c:TColor):TSzin;

    // Drawing primitives
    procedure glRectangle(p1,p2,p3,p4: TPoint2d);  overload;
    procedure glRectangle(p: TPoint2d; a,b: double); overload;
    procedure glCircle(u,v,r: double);
    procedure glPrint(text : string);

implementation

procedure Register;
begin
  RegisterComponents('AL', [TALOpenGl]);
end;

function ColorToSzin(c:TColor):TSzin;
begin
With Result do begin
  R:=GetRValue(c)/255;
  G:=GetGValue(c)/255;
  B:=GetBValue(c)/255;
end;
end;

{ TALOpenGL }

constructor TALOpenGl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  OpenGL_OK      := False;
  BackBMP        := TBitmap.Create;
  width          := 200;
  height         := 200;
  OrtoLeft       := -100;
  OrtoRight      := 100;
  OrtoBottom     := -100;
  OrtoTop        := 100;
  fClearColor    := clBlack;
  FCentralCross  := True;
  FCentrum       := Point2d(0,0);
  FZoom          := 2.0;
  FZoomFaktor    := 1.1;
  FShadeModel    := smSmooth;
  FRotAngle      := 0;
  DoubleBuffered := True;
  TabStop        := True;
end;

destructor TALOpenGl.Destroy;
begin
  BackBMP.Free;
  wglMakeCurrent(0, 0);
  wglDeleteContext(hrc);
  inherited Destroy;
end;

procedure TALOpenGl.StartOpengl;
begin
Try
//  InitOpenGL;
  DC := GetDC(Handle);

  SetDCPixelFormat;
  hrc := wglCreateContext(DC);
  wglMakeCurrent(DC, hrc);

  glShadeModel(GL_SMOOTH);
  glEnable(GL_TEXTURE_2D);

//    glEnable(GL_DEPTH_TEST);
//    glDepthMask(GL_TRUE);
//  glClearDepth(1.0);
//  glEnable(GL_ALPHA_TEST);
//  glAlphaFunc(GL_GREATER,0);

//  glEnable(GL_LOGIC_OP);

//  glEnable(GL_TEXTURE_GEN_S);
//  glEnable(GL_TEXTURE_GEN_T);

//  glEnable(GL_BLEND);
//  glBlendFunc(GL_ONE,GL_ONE);

  glMatrixMode(GL_PROJECTION);
  glViewport(0, 0, Width, Height);

  OpenGL_OK  := True;
  ClearColor := fClearColor;
except
  OpenGL_OK  := False;
  Application.MessageBox('OpenGL cannot initialised!','OpenGl Error',IDOK);
  exit;
end;
  if Assigned(FOnInitGL) then FOnInitGL(Self);
end;

procedure TALOpenGl.SetDCPixelFormat;
var
  nPixelFormat: Integer;
  pfd: TPixelFormatDescriptor;
begin
  FillChar(pfd, SizeOf(pfd), 0);

  with pfd do begin
    nSize     := sizeof(pfd);
    nVersion  := 1;
    dwFlags   := PFD_DRAW_TO_WINDOW or
                 PFD_SUPPORT_OPENGL
                 or PFD_DOUBLEBUFFER;
    iPixelType:= PFD_TYPE_RGBA;
    cColorBits:= 16;
    cDepthBits:= 16;
    iLayerType:= PFD_MAIN_PLANE;
  end;

  nPixelFormat := ChoosePixelFormat(DC, @pfd);
  SetPixelFormat(DC, nPixelFormat, @pfd);
end;

procedure TALOpenGl.Paint;
var
  ps : TPaintStruct;
begin
//  BeginPaint(Handle, ps);
  glClear(GL_COLOR_BUFFER_BIT);
  If componentstate=[csDesigning] then Demo
  else begin
     glPushMatrix;
     If Assigned(FOnPaint) then FOnPaint(Self);
//     Demo;
     glPopMatrix;
  end;
  if FCentralCross then DrawCentralCross;
  SwapBuffers(DC);
  SBI;
  If Assigned(FOnAfterPaint) then FOnAfterPaint(Self);
//  EndPaint(Handle, ps);
end;

procedure TALOpenGl.ReDraw;
begin
  if not OpenGL_OK then StartOpengl;
     glViewport(0,0,width ,height);
     glMatrixMode(GL_PROJECTION);
     glLoadIdentity;
     gluOrtho2D(OrtoLeft, OrtoRight, OrtoBottom, OrtoTop);
     glMatrixMode(GL_MODELVIEW);
     glDrawBuffer(GL_BACK);
//  glClear (GL_DEPTH_BUFFER_BIT or GL_COLOR_BUFFER_BIT);
  Paint;
end;

procedure TALOpenGL.CopyToClipboard;
begin
  SBI;
  Clipboard.Assign(BackBMP);
end;

procedure TALOpenGl.Demo;
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

procedure TALOpenGl.WMPaint(var Msg: TWMPaint);
begin
  ReDraw;
end;

procedure TALOpenGl.SetClearColor(const Value: TColor);
Var szin: TSzin;
begin
  FClearColor := Value;
  If not OpenGL_OK then exit;
  szin:=ColorToSzin(Value);
  glClearcolor(szin.R,szin.G,szin.B,0);
//  glClear (GL_DEPTH_BUFFER_BIT or GL_COLOR_BUFFER_BIT);
  invalidate;
end;

procedure TALOpenGl.MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
begin
  origin:=Point(x,y);
  oldmovept:=origin;
  inherited MouseDown(Button, Shift, X, Height-Y);
end;

procedure TALOpenGl.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  dx,dy: GLDouble;
  S: string;
begin
  MovePt:=Point(x,y);

  { Moving graphic with pressed left mouse button }
  IF Shift=[ssLeft] then
  begin
    dx := (oldMovePt.x-MovePt.x)/FZoom;
    dy := (oldMovePt.y-MovePt.y)/FZoom;
    Centrum := Point2d(FCentrum.x+dx,FCentrum.y-dy);
  end;

  { Magnifying graphic with pressed right mouse button }
  IF Shift=[ssRight] then
  begin
    if oldMovePt.y<>MovePt.y then
       if oldMovePt.y>MovePt.y then
          Zoom := Zoom*1.1
       else
          Zoom := Zoom*0.9;
  end;

  oldMovePt := MovePt;

  inherited MouseMove(Shift,x,Height-y);
end;

procedure TALOpenGl.MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
begin
  Inherited MouseUp(Button,Shift,X, Y);
end;

procedure TALOpenGl.KeyDown(var Key: Word;Shift: TShiftState);
var zFac: double;
begin
  if Shift=[ssCtrl] then zFac:=1.1
  else zFac:=ZoomFaktor;
  Case Key of
  VK_ADD     : begin Zoom:=zFac*Zoom;end;
  VK_SUBTRACT: begin Zoom:=1/zFac*Zoom;end;
  VK_SPACE   : RotAngle := 0;
  end;
  inherited KeyDown(Key,Shift);
end;

procedure TALOpenGl.KeyPress(var Key: Char);
begin
  Case Key of
  'K','k' : CentralCross:=not CentralCross;
  ^C : CopyToClipboard;
  'L','l' : RotAngle := FRotAngle+1;
  'R','r' : RotAngle := FRotAngle-1;
  'F','f' : RotAngle := FRotAngle+1;
  end;
  inherited KeyPress(Key);
end;

procedure TALOpenGl.SetZoom(const Value: extended);
var wx,hx: GLDouble;
begin
  FZoom := Value;
if OpenGL_OK then
Try
  wx := (Width/2)/FZoom;
  hx := (Height/2)/FZoom;
  OrtoLeft   := FCentrum.x - wx;
  OrtoRight  := FCentrum.x + wx;
  OrtoBottom := FCentrum.y - hx;
  OrtoTop    := FCentrum.y + hx;
  invalidate;
EXCEPT
end;
end;

procedure TALOpenGl.CMChildkey(var msg: TCMChildKey);
var dx,dy: integer;
    k:integer;
begin
  k:=16;
  dx := 0; dy:=0;
  msg.result := 1; // declares key as handled
  Case msg.charcode of
    VK_ADD     : Zoom:=2*Zoom;
    VK_SUBTRACT: Zoom:=0.5*Zoom;
    VK_LEFT    : dx:=-k;
    VK_RIGHT   : dx:=k;
    VK_UP      : dy:=k;
    VK_DOWN    : dy:=-k;
  Else
    msg.result:= 0;
    inherited;
  End;
  if (dx<>0) or (dy<>0) then
     ShiftWindow(dx,dy);
    inherited;
end;

procedure TALOpenGl.WMSize(var Msg: TWMSize);
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
  BackBMP.Width := Msg.Width;
  BackBMP.height := Msg.Height;
  ReDraw;
except
end;
end;

procedure TALOpenGl.SetCentrum(const Value: TPoint2d);
var wx,hx: GLDouble;
begin
  FCentrum := Value;
  wx := (Width/2)/FZoom;
  hx := (Height/2)/FZoom;
  OrtoLeft   := Value.x - wx;
  OrtoRight  := Value.x + wx;
  OrtoBottom := Value.y - hx;
  OrtoTop    := Value.y + hx;
  ReDraw;
end;

procedure TALOpenGl.SetShadeModel(const Value: TShadeModel);
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

procedure TALOpenGl.SetCentralCross(const Value: boolean);
begin
  FCentralCross := Value;
  invalidate;
end;

procedure TALOpenGl.DrawCentralCross;
begin
        glBegin(GL_LINES);
          glColor4d(1.0,0.0,0.0,1.0);
          glVertex2d(FCentrum.x,OrtoTop);
          glVertex2d(FCentrum.x,OrtoBottom);
          glVertex2d(OrtoLeft,FCentrum.y);
          glVertex2d(OrtoRight,FCentrum.y);
        glEnd;
end;

function TALOpenGl.SToW(p: TPoint): TPoint2d;
begin
  Result := Point2d(XToW(p.x),YToW(p.y));
end;

function TALOpenGl.WToS(p: TPoint2d): TPoint;
begin
  Result := Point(XToS(p.x),YToS(p.y));
end;

function TALOpenGl.XToS(x: double): integer;
begin
  Result := Trunc(Width/2+(x-FCentrum.x)*FZoom);
end;

function TALOpenGl.XToW(x: integer): double;
begin
  Result := FCentrum.x+(x-Width/2)/FZoom;
end;

function TALOpenGl.YToS(y: double): integer;
begin
  Result := Trunc(Height/2+(y-FCentrum.y)*FZoom);
end;

function TALOpenGl.YToW(y: integer): double;
begin
  Result := FCentrum.y+(y-Height/2)/FZoom;
end;

procedure TALOpenGl.MoveWindow(x, y: double);
begin
  Centrum := Point2d(Centrum.x-x,Centrum.y-y);
end;

procedure TALOpenGl.ShiftWindow(x, y: double);
begin
  Centrum := Point2d(FCentrum.x+(x/FZoom),FCentrum.y+(y/FZoom));
end;

procedure TALOpenGl.DblClick;
begin
  Centrum := SToW(Point(Origin.x,Height-Origin.y));
  inherited;
end;

function TALOpenGl.GetTotalMapArea: TRect2d;
begin
  With Result do begin
       x1:=OrtoLeft;
       x2:=OrtoRight;
       y1:=OrtoBottom;
       y2:=OrtoTop;
  end;
end;

function TALOpenGl.GetWorkArea: TRect2d;
begin

end;

procedure TALOpenGl.CMMouseEnter(var msg: TMessage);
begin
  TabStop:=True;
  Setfocus;
end;

procedure TALOpenGl.CMMouseLeave(var msg: TMessage);
begin
  TabStop:=False;
end;

function TALOpenGl.DoMouseWheel(Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos);
  if Focused then
  if WheelDelta<0 then Zoom:=0.9*Zoom  else Zoom:=1.1*Zoom;
end;

function TALOpenGl.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelDown(Shift, MousePos);
end;

function TALOpenGl.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelUp(Shift, MousePos);
end;

procedure TALOpenGl.glCircle(u, v, r: double);
var i: integer;
begin
  glBegin(GL_LINE_STRIP);
    For i:=0 to 360 do
        glVertex2d(u+r*cos(DegToRad(i)),v+r*sin(DegToRad(i)));
  glEnd;
end;

procedure TALOpenGl.glRectangle(p1, p2, p3, p4: TPoint2d);
begin
  glBegin(GL_LINES);
    glVertex2d(p1.x,p1.y);
    glVertex2d(p2.x,p2.y);
    glVertex2d(p3.x,p3.y);
    glVertex2d(p4.x,p4.y);
  glEnd;
end;

procedure TALOpenGl.glRectangle(p: TPoint2d; a, b: double);
begin
  glBegin(GL_LINE_STRIP);
    glVertex2d(p.x-a/2,p.y+b/2);
    glVertex2d(p.x+a/2,p.y+b/2);
    glVertex2d(p.x+a/2,p.y-b/2);
    glVertex2d(p.x-a/2,p.y-b/2);
    glVertex2d(p.x-a/2,p.y+b/2);
  glEnd;
end;

procedure TALOpenGl.glPrint(text: string);
begin

end;

procedure TALOpenGl.DrawText(x,y:glFloat; s:string);
var i:integer;
begin
  glpushmatrix;
  gldisable(GL_DEPTH_TEST);
  glRasterPos2f(x, y);
  for i := 1 to length(s) do begin
//    glutBitmapCharacter(1,ord(s[i]));
  end;
  glEnable(GL_DEPTH_TEST);
  glpopmatrix;
end;

function TALOpenGl.GetCanvas: TCanvas;
begin
  Result := inherited Canvas;
end;

procedure TALOpenGl.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1
end;

procedure TALOpenGl.SBI;
begin
  StretchBlt(BackBMP.Canvas.Handle,0,0,width,Height,
             Canvas.handle,0,0,width,Height,SRCCOPY)
end;

procedure TALOpenGl.LBI;
begin
  StretchBlt(Canvas.Handle,0,0,width,Height,
             BackBMP.Canvas.handle,0,0,width,Height,SRCCOPY)
end;

procedure TALOpenGL.SetRotAngle(const Value: double);
begin
  FRotAngle := Value;
  invalidate;
end;

function TALOpenGL.CreateTexture(Texture : String): cardinal;
var
  bitmap: TBitmap;
  Pict:TJpegImage;
  BMInfo : TBitmapInfo;
  I,ImageSize : Integer;
  Temp : Byte;
  MemDC : HDC;
  TexI: PPixelArray;
  ext: string;
  PIC: TPicture;
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

     If Pos(ext,'*.PNG *.TIF.TIFF.bw.rgb.rgba.sgi.cel.pic.tga.vst.icb.vda.win'+
        '*.pcx, *.pcc, *.scr *.pcd*.ppm, *.pgm, *.pbm *.cut*.gif *.rla, *.rpf'+
        ' *.psd, *.pdd *.psp *.eps' )>0 then
     Try
        PIC := TPicture.Create;
        PIC.LoadFromFile(Texture);
        BitMap.Assign(PIC.Bitmap);
     finally
        PIC.Free;
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
    GetMem (TexI, ImageSize *3);
    try
      GetDIBits (MemDC, Bitmap.Handle, 0, biHeight, TexI, BMInfo, DIB_RGB_COLORS);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,GL_LINEAR );
      glTexImage2d(GL_TEXTURE_2D, 0, 3, biwidth, biheight, 0, GL_BGR, GL_UNSIGNED_BYTE, texI);
      For I := 0 to ImageSize - 1 do begin
          Temp := texI [I * 3];
          texI [I * 3] := texI [I * 3 + 2];
          texI [I * 3 + 2] := Temp;
      end;
     finally
      DeleteDC (MemDC);
      Bitmap.Free;
      freemem(TexI);
   end;
  end;
end;

function TALOpenGL.LoadGLTextures : boolean;
begin
  Tex:=CreateTexture('Texture.jpg');
  LoadGLTextures := True;
end;

///////////////////////////////////////////////////////////////////////////

procedure glCircle(u, v, r: double);
var i: integer;
begin
  glBegin(GL_LINE_STRIP);
    For i:=0 to 360 do
        glVertex2d(u+r*cos(DegToRad(i)),v+r*sin(DegToRad(i)));
  glEnd;
end;

procedure glRectangle(p1, p2, p3, p4: TPoint2d);
begin
  glBegin(GL_LINES);
    glVertex2d(p1.x,p1.y);
    glVertex2d(p2.x,p2.y);
    glVertex2d(p3.x,p3.y);
    glVertex2d(p4.x,p4.y);
  glEnd;
end;

procedure glRectangle(p: TPoint2d; a, b: double);
begin
  glBegin(GL_LINE_STRIP);
    glVertex2d(p.x-a/2,p.y+b/2);
    glVertex2d(p.x+a/2,p.y+b/2);
    glVertex2d(p.x+a/2,p.y-b/2);
    glVertex2d(p.x-a/2,p.y-b/2);
    glVertex2d(p.x-a/2,p.y+b/2);
  glEnd;
end;

procedure glPrint(text: string);
begin

end;

initialization
  InitOpenGL;
end.

