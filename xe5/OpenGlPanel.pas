unit OpenGlPanel;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls, OpenGl, Windows,
  Messages, Graphics, Forms,
  Dialogs;
type
  TOpenGlBasePanel = Class ( TCustomPanel )
  private
    FGlDraw : TNotifyEvent;
    fFullScreen : TNotifyEvent;
    rc : HGLRC;
    dc  : HDC;
    fApplication : TApplication;
    procedure Resize; override;
    { Protected declarations }
    procedure Idle(Sender: TObject; var Done: Boolean);
    Procedure glInit; virtual;
  public
    procedure Paint; override;
    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;
    Property hApplication : TApplication Read fApplication Write fApplication;
  published
    Property glDraw : TNotifyEvent read FGlDraw write FGlDraw;
    Property FullScreen : TNotifyEvent Read fFullScreen Write fFullScreen;
    Property Onkeydown;
  end;


  TOpenGlPanel = class(TOpenGlBasePanel)
  private
    { Private declarations }
    fWireFrame : Boolean;
  protected
  public
    Procedure glInit; Override;
    procedure Paint; override;
    constructor Create(AOwner: TComponent); override;
  published
    Property WireFrame : Boolean Read fWireFrame Write fWireFrame;
  end;

procedure Register;

implementation

//------------------------------------------------------------------------------

procedure Register;
begin
  RegisterComponents('AL', [TOpenGlPanel]);
end;

//------------------------------------------------------------------------------

{ TOpenGlPanel }

//------------------------------------------------------------------------------

procedure TOpenGlBasePanel.glInit();
var pfd : TPIXELFORMATDESCRIPTOR;
    pf  : Integer;
begin
  dc:=GetDC( Self.Handle );
  pfd.nSize:=sizeof(pfd);
  pfd.nVersion:=1;
  pfd.dwFlags:=PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER or 0;
  pfd.iPixelType:=PFD_TYPE_RGBA;
  pfd.cColorBits:=32;
  pf :=ChoosePixelFormat(dc, @pfd);
  SetPixelFormat(dc, pf, @pfd);
  rc :=wglCreateContext(dc);
  wglMakeCurrent(dc,rc);

  glClearColor(0.0, 0.0, 0.0, 0.0);
  glShadeModel(GL_SMOOTH);
  glClearDepth(1.0);
  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LESS);
  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);

  // Tunnel
  glClearColor(0.0, 0.0, 0.0, 0.0); 	   // Black Background
  glShadeModel(GL_SMOOTH);                 // Enables Smooth Color Shading
  glClearDepth(1.0);                       // Depth Buffer Setup
  glEnable(GL_DEPTH_TEST);                 // Enable Depth Buffer
  glDepthFunc(GL_LESS);		           // The Type Of Depth Test To Do
  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);   //Realy Nice perspective calculations
  glBlendFunc(GL_SRC_ALPHA, GL_ONE);
  glEnable(GL_TEXTURE_2D);

  Resize;

  fApplication.OnIdle := Idle;
end;

//------------------------------------------------------------------------------

constructor TOpenGlBasePanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BevelOuter := bvNone;
  BevelInner := bvNone;
end;

//------------------------------------------------------------------------------

destructor TOpenGlBasePanel.Destroy;
begin
  wglMakeCurrent(0,0);
  wglDeleteContext(rc);
  inherited;
end;

//------------------------------------------------------------------------------

procedure TOpenGlBasePanel.Idle(Sender: TObject; var Done: Boolean);
begin
  Done := FALSE;
  glDraw(Self);
  SwapBuffers(DC);
end;

//------------------------------------------------------------------------------

procedure TOpenGlBasePanel.Resize;
begin
  inherited;
  glViewport(0, 0, Self.Width, Self.Height);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluPerspective(45.0, Self.Width/Self.Height, 1.0, 500.0);
  glMatrixMode(GL_MODELVIEW);         
end;

//------------------------------------------------------------------------------

procedure TOpenGlBasePanel.Paint;
begin
  inherited;
  if csDesigning in ComponentState then
	with inherited Canvas do
	begin
	  Pen.Style := psDash;
	  Brush.Style := bsClear;
	  Rectangle(0, 0, Width, Height);
	end;
end;

//------------------------------------------------------------------------------

procedure TOpenGlPanel.Paint;
begin
  inherited;
  // Wire Frame Mode
  if Wireframe = TRUE then
    glPolygonmode(GL_FRONT_AND_BACK, GL_LINE)
  else
    glPolygonmode(GL_FRONT, GL_FILL);
end;
    
//------------------------------------------------------------------------------

procedure TOpenGlPanel.glInit;
begin
  inherited;
end;
        
//------------------------------------------------------------------------------

constructor TOpenGlPanel.Create(AOwner: TComponent);
begin
  inherited;
  Cursor := crNone;
end;

//------------------------------------------------------------------------------

end.
