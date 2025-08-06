////////////////////////////////////////////////////////////////////////////////
// TOpenGL component
//
// Component that allows to deal with the OpenGL library
//
// by Alan GARNY
//    gry@physiol.ox.ac.uk
//    http://pc-heartbreak.physiol.ox.ac.uk/
//
// © Copyright 1998-99
////////////////////////////////////////////////////////////////////////////////
// Date of Creation: 15/10/98 (based on the BCB version of TCustumOpenGL)
//
// Modifications: (model: [<initials>, dd/mm/yy] <what has been done>)
// [GRY, 06/11/98] Made the method "GeTCustumOpenGLBmp" public to allow the programmer
//                 to get a "TBitmap*" of the rendered scene. The user has to
//                 release the "handle" to the bitmap of the rendered scene, we
//                 then have a "ReleaseOpenGLBmp" method (like for "GetDC" and
//                 "ReleaseDC")
// [GRY, 08/03/99] Fixed a problem of memory leak in the "Print" method
// [GRY, 23/10/99] Removed the backward compatibility in order to make things
//                 easier for the future
// [GRY, 23/10/99] Added the OnKeyDown, OnKeyPress, OnKeyUp, OnMouseWheel,
//                 OnMouseWheelDown and OnMouseWheelUp events (suggested to us
//                 by Nimai C. Malle, nimai_malle@yahoo.com)
////////////////////////////////////////////////////////////////////////////////

Unit DOpenGL;

////////////////////////////////////////////////////////////////////////////////

Interface

Uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   ExtCtrls, Printers, OpenGL, NewGeom, StObjects, Math;

const
  GLF_START_LIST = 100000;
  Inch  : double = 25.4500; // mm

Type
   TGLFlag = (f_DOUBLEBUFFER, f_DRAW_TO_BITMAP, f_DRAW_TO_WINDOW,
              f_GENERIC_ACCELERATED, f_GENERIC_FORMAT, f_NEED_PALETTE,
              f_NEED_SYSTEM_PALETTE, f_SUPPORT_GDI, f_SUPPORT_OPENGL, f_STEREO,
              f_SWAP_COPY, f_SWAP_EXCHANGE, f_SWAP_LAYER_BUFFERS);
   TGLFlags = Set Of TGLFlag;

   TGLPixelType = (pt_TYPE_RGBA, pt_TYPE_COLORINDEX);

   TGLPrintScale = (ps_NONE, ps_PROPORTIONAL, ps_PRINT_TO_FIT);

  TSzin = record
    R,G,B : double;
    width : integer;
  end;

  TVector3d = array[0..2] of double;

// GLU types:

type  TGLUNurbs                   = record end;
      TGLUQuadric                 = record end;
      TGLUTesselator              = record end;

      PGLUNurbs                   = ^TGLUNurbs;
      PGLUQuadric                 = ^TGLUQuadric;
      PGLUTesselator              = ^TGLUTesselator;

      // backwards compatibility:
      GLUNurbsObj                = PGLUNurbs;
      GLUQuadricObj              = PGLUQuadric;
      GLUTesselatorObj           = PGLUTesselator;
      GLUTriangulatorObj         = PGLUTesselator;

      PGLUNurbsObj                = PGLUNurbs;
      PGLUQuadricObj              = PGLUQuadric;
      PGLUTesselatorObj           = PGLUTesselator;
      PGLUTriangulatorObj         = PGLUTesselator;

      // Callback function prototypes
      // GLUQuadricCallback
      TGLUQuadricErrorProc        = procedure(errorCode: GLEnum); stdcall;

      // GLUTessCallback
      GLUTessBeginProc           = procedure(AType: GLEnum); stdcall;
      GLUTessEdgeFlagProc        = procedure(Flag: GLboolean); stdcall;
      GLUTessVertexProc          = procedure(VertexData: Pointer); stdcall;
      GLUTessEndProc             = procedure; stdcall;
      GLUTessErrorProc           = procedure(ErrNo: GLEnum); stdcall;
      GLUTessCombineProc         = procedure(Coords: PGLdouble; VertexData: Pointer; Weight: PGLdouble; OutData: Pointer); stdcall;
      GLUTessBeginDataProc       = procedure(AType: GLEnum; UserData: Pointer); stdcall;
      GLUTessEdgeFlagDataProc    = procedure(Flag: GLboolean; UserData: Pointer); stdcall;
      GLUTessVertexDataProc      = procedure(VertexData: Pointer; UserData: Pointer); stdcall;
      GLUTessEndDataProc         = procedure(UserData: Pointer); stdcall;
      GLUTessErrorDataProc       = procedure(ErrNo: GLEnum; UserData: Pointer); stdcall;
      GLUTessCombineDataProc     = procedure(Coords: PGLdouble; VertexData: Pointer; Weight: PGLdouble; OutData: Pointer; UserData: Pointer); stdcall;

      // GLUNurbsCallback
      GLUNurbsErrorProc          = procedure(ErrorCode: GLEnum); stdcall;

  TCustumOpenGL = class(TCustomControl)
      Private
         // Private representation of published properties

         DC: HDC;
         GLContext: HGLRC;

         // Properties used for the format of the pixel (cf. the structure
         // PIXELFORMATDESCRIPTION in "WinGDI.h")

         FColorUsedForBackground: Boolean;
         FGLColorBits: Byte;
         FGLDepthBits: Byte;
         FGLFlags: TGLFlags;
         FGLPixelType: TGLPixelType;
         FPixelsPerInch: Integer;
         FPrintScale: TGLPrintScale;

         // Properties used for internal purpose

         NeedToSetControlPixelFormat: Boolean;

         ConvertedFlags: DWORD;
         ConvertedPixelType: BYTE;

         Palette: HPALETTE;

         OrigColor: TColor;
         OrigGLColor: TColor;
         FCentrum: TPoint2d;
         FZoom: extended;
         FChangeWindow: TChangeWindow;
         FOpenGLPaint: boolean;
         FBackColor: TColor;
         FCursorCross: boolean;
         FCentralCross: boolean;
         FCentralisZoom: boolean;
         fPaper: TALPaper;
         FRotAngle: double;
         fGrid: TGrid;
         FDblClickEnabled: boolean;

         // Methods to modify the different published properties

         procedure WMEraseBkGnd(var Message:TWMEraseBkGnd); message WM_ERASEBKGND;
         Procedure CMChildkey( Var msg: TCMChildKey ); message CM_CHILDKEY;
         procedure WMSize(var Msg: TWMSize); message WM_SIZE;
//         Procedure SetColorUsedForBackground(aValue: Boolean);
         Procedure SetGLColorBits(aValue: Byte);
         Procedure SetGLDepthBits(aValue: Byte);
         Procedure SetGLFlags(aValue: TGLFlags);
         Procedure SetGLPixelType(aValue: TGLPixelType);
         Function GetPixelsPerInch: Integer;
         Procedure SetPixelsPerInch(aValue: Integer);
         Procedure SetPrintScale(aValue: TGLPrintScale);

         // Methods used for internal purpose

         Procedure SetControlPixelFormat;
         Procedure CreateGLContext;

         Procedure ConvertFlags;
         Procedure ConvertPixelType;
         procedure SetCentrum(const Value: TPoint2d);
         procedure SetZoom(const Value: extended);
         procedure SetBackColor(const Value: TColor);
         procedure SetOpenGLPaint(const Value: boolean);
         procedure SetCentralCross(const Value: boolean);
         procedure SetCursorCross(const Value: boolean);
    procedure SetRotAngle(const Value: double);

      Protected
         // Special internal events

         FOnGLPaint: TNotifyEvent;   // User's routine for GL paint
         FOnGLInit: TNotifyEvent;   // User's routine for GL initialisation

         // Inherited methods

         Procedure Paint; Override;
         procedure ReDraw;
         Procedure Resize; Override;

         Procedure CreateWnd; Override;

         // Methods handling different messages (from Windows or not)

         Procedure WMCreate(Var aMessage: TWMCreate); Message WM_CREATE;
         Procedure WMDestroy(Var aMessage: TWMDestroy); Message WM_DESTROY;
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

      Public
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

         Constructor Create(aOwner: TComponent); Override;

         Function  GeTCustumOpenGLBmp: TBitmap;
         Procedure ReleaseOpenGLBmp(aOpenGLBmp: TBitmap);
         Procedure SaveToFile(aFileName: String);
         Procedure Print;

         Function GetDC: HDC;
         Function GetGLContext: HGLRC;
         Function GetPalette: HPALETTE; Override;

      Public

         // StellaSoft
         procedure ClearBackground;
         procedure DrawCentralCross;
         procedure DrawCursorCross(p: TPoint); overload;
         procedure DrawCursorCross(x,y: integer); overload;
         procedure DrawAxis;
         procedure DrawGrid;

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

         // Drawing primitives
         procedure glColor(col: TColor);
         procedure glRectangle(p1,p2,p3,p4: TPoint2d);  overload;
         procedure glRectangle(p: TPoint2d; a,b: double); overload;
         procedure glRectangle(p1,p2: TPoint2d); overload;
         procedure glCircle(u,v,r: double); overload;
         procedure glCircle(Cent: TPoint2d; r: double); overload;
         procedure glCircle(Cent,KerPoint: TPoint2d); overload;
         procedure glEllipse(p1,p2: TPoint2d);
         procedure glPrint(x,y,Height,Angle: double; text : string); overload;
         procedure glPrint(fName: string;x,y,Height,Angle: double; text: string); overload;
         procedure Line(X0,Y0,X1,Y1:extended);
         procedure Plane(X0,Y0,X1,Y1,X2,Y2,X3,Y3:extended);
         procedure glPolygon(p: array of TPoint3d);
         procedure glPolygonFill(p: array of TPoint3d);
         procedure glPolyLine(p: array of TPoint3d);
         procedure PolygonTess( n: array of TPoint3d ); overload;
         procedure PolygonTess( x, y, z, AngleRotate: single; n: array of TPoint3d ); overload;

         Property GLColorBits: Byte Read FGLColorBits Write SetGLColorBits Default 32;
         Property GLDepthBits: Byte Read FGLDepthBits Write SetGLDepthBits Default 32;
         Property GLFlags: TGLFlags Read FGLFlags Write SetGLFlags NoDefault;
         Property GLPixelType: TGLPixelType Read FGLPixelType Write SetGLPixelType Default pt_TYPE_RGBA;
         Property PixelsPerInch: Integer Read GetPixelsPerInch Write SetPixelsPerInch NoDefault;
         Property PrintScale: TGLPrintScale Read FPrintScale Write SetPrintScale Default ps_PROPORTIONAL;

         // StellaSoft

         property OpenGLPaint   : boolean      read FOpenGLPaint write SetOpenGLPaint;
         Property BackColor     : TColor       read FBackColor write SetBackColor;
         property CentralCross  : boolean      read FCentralCross write SetCentralCross;
         property CentralisZoom : boolean      read FCentralisZoom write FCentralisZoom;
         property CursorCross   : boolean      read FCursorCross write SetCursorCross;
         property Centrum       : TPoint2d read FCentrum write SetCentrum;
         property Grid          : TGrid        read fGrid Write fGrid;
         property Paper         : TALPaper     read fPaper write fPaper;
         property RotAngle      : double       read FRotAngle write SetRotAngle;
         property Zoom          : extended     read FZoom write SetZoom;
         property DblClickEnabled: boolean     read FDblClickEnabled write FDblClickEnabled default True;
         property Window        : TRect2d      read GetWorkArea;
         property OnChangeWindow: TChangeWindow read FChangeWindow write FChangeWindow;

         // OpenGL events

         Property OnGLPaint: TNotifyEvent Read FOnGLPaint Write FOnGLPaint;
         Property OnGLInit: TNotifyEvent Read FOnGLInit Write FOnGLInit;
   End;

   TOpenGL = class(TCustumOpenGL)
   published
         Property Align;
         Property BackColor;
         Property CentralCross;
         property CentralisZoom;
         property CursorCross;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property GLColorBits;
         Property GLDepthBits;
         Property GLFlags;
         Property GLPixelType;
         Property ParentColor;
         Property ParentFont;
         Property ParentShowHint;
         Property PixelsPerInch;
         Property PopupMenu;
         Property PrintScale;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Visible;

         // Available events

         Property OnClick;
         Property OnDblClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnKeyDown;
         Property OnKeyPress;
         Property OnKeyUp;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnMouseWheel;
         Property OnMouseWheelDown;
         Property OnMouseWheelUp;
         Property OnResize;
         Property OnStartDrag;

         // OpenGL events

         Property OnGLPaint;
         Property OnGLInit;
   end;

function ColorToSzin(c:TColor):TSzin;

Procedure Register;

////////////////////////////////////////////////////////////////////////////////

Implementation

function ColorToSzin(c:TColor):TSzin;
begin
With Result do begin
  R:=GetRValue(c)/255;
  G:=GetGValue(c)/255;
  B:=GetBValue(c)/255;
end;
end;

////////////////////////////////////////////////////////////////////////////////
//
// CONSTRUCTOR & DESTRUCTOR
//
////////////////////////////////////////////////////////////////////////////////

Constructor TCustumOpenGL.Create(aOwner: TComponent);
Begin
  Inherited Create(aOwner);

  NeedToSetControlPixelFormat := False;
  DC                          := 0;
  GLContext                   := 0;
  Palette                     := 0;

  FGLPixelType            := pt_TYPE_RGBA;
  FColorUsedForBackground := False;
  FGLColorBits            := 32;
  FGLDepthBits            := 32;
  FPrintScale             := ps_PROPORTIONAL;
  FPixelsPerInch          := Screen.PixelsPerInch;

  FGLFlags := [f_DRAW_TO_WINDOW, f_SUPPORT_OPENGL, f_DOUBLEBUFFER];

  ConvertFlags;
  ConvertPixelType;
  OrtoLeft       := -10;
  OrtoRight      := 10;
  OrtoBottom     := -10;
  OrtoTop        := 10;
  width          := 200;
  height         := 200;
  FCentrum       := Point2d(0,0);
  FZoom          := 2;
  FBackColor     := clWhite;
  TabStop        := True;
  Redraw;
End;

////////////////////////////////////////////////////////////////////////////////
//
// PUBLIC METHODS
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// GeTCustumOpenGLBmp:

Function TCustumOpenGL.GeTCustumOpenGLBmp: TBitmap;
Var
   Region: TRect;
   OpenGLBmp: TBitmap;
Begin
   OpenGLBmp := TBitmap.Create;

   Try
      OpenGLBmp.Width  := Width;
      OpenGLBmp.Height := Height;

      Region := Rect(0, 0, Width, Height);

      Repaint;   // Just to make sure that we get the OpenGL scene properly
                 // Indeed, it may happen that if another window is covering the
                 // control while trying to save/print, then it may be possible
                 // that part of the scene is lost

      OpenGLBmp.Canvas.CopyRect(Region, Canvas, Region);

      Result := OpenGLBmp;
   Except
      OpenGLBmp.Free;

      Result := Nil;
   End;
End;

////////////////////////////////////////////////////////////////////////////////
// ReleaseOpenGLBmp:

procedure TCustumOpenGL.ReDraw;
begin
     glViewport(0,0,width ,height);
     glMatrixMode(GL_PROJECTION);
     glLoadIdentity;
     gluOrtho2D(OrtoLeft, OrtoRight, OrtoBottom, OrtoTop);
     glMatrixMode(GL_MODELVIEW);
     glDrawBuffer(GL_BACK);
     glClear (GL_DEPTH_BUFFER_BIT or GL_COLOR_BUFFER_BIT);
     RePaint;
end;

Procedure TCustumOpenGL.ReleaseOpenGLBmp(aOpenGLBmp: TBitmap);
Begin
   if (aOpenGLBmp <> Nil) Then
      aOpenGLBmp.Free;
End;

////////////////////////////////////////////////////////////////////////////////
// SaveToFile:

Procedure TCustumOpenGL.SaveToFile(aFileName: String);
Var
   TmpBmp: TBitmap;
Begin
   TmpBmp := GeTCustumOpenGLBmp;

   If (TmpBmp <> Nil) Then
      Begin
         TmpBmp.SaveToFile(aFileName);
         ReleaseOpenGLBmp(TmpBmp);
      End;
End;

////////////////////////////////////////////////////////////////////////////////
// Print:

Procedure TCustumOpenGL.Print;
Var
   TmpBmp: TBitmap;
   TmpPrinter: TPrinter;
   InfoHeaderSize, TmpBmpSize: DWord;
   InfoHeader: TBitmapInfo;
   Bits: Pointer;
   DIBWidth, DIBHeight, PrintWidth, PrintHeight: LongInt;
Begin
   TmpBmp := GeTCustumOpenGLBmp;

   If (TmpBmp <> Nil) Then
      Begin
         TmpPrinter := Printer;

         TmpPrinter.BeginDoc;

         Try
            GetDIBSizes(TmpBmp.Handle, InfoHeaderSize, TmpBmpSize);

            Bits := AllocMem(TmpBmpSize);   //---GRY--- CHECK FOR FreeMem!!

            GetDIB(TmpBmp.Handle, 0, InfoHeader, Bits);

            DIBWidth  := InfoHeader.bmiHeader.biWidth;
            DIBHeight := InfoHeader.bmiHeader.biHeight;

            PrintWidth  := DIBWidth;
            PrintHeight := DIBHeight;

            Case FPrintScale Of
               ps_PROPORTIONAL:
                  Begin
                     PrintWidth  := Round(DIBWidth  * GetDeviceCaps(DC, LOGPIXELSX) / PixelsPerInch);
                     PrintHeight := Round(DIBHeight * GetDeviceCaps(DC, LOGPIXELSY) / PixelsPerInch);
                  End;
               ps_PRINT_TO_FIT:
                  Begin
                     PrintWidth := Round(DIBWidth * TmpPrinter.PageHeight / DIBHeight);

                     If (PrintWidth < TmpPrinter.PageWidth) Then
                        PrintHeight := TmpPrinter.PageHeight
                     Else
                        Begin
                           PrintWidth  := TmpPrinter.PageWidth;
                           PrintHeight := Round(DIBHeight * TmpPrinter.PageWidth / DIBWidth);
                        End;
                  End;
            End;

            StretchDIBits(TmpPrinter.Canvas.Handle,
                          0, 0, PrintWidth, PrintHeight,
                          0, 0, DIBWidth, DIBHeight,
                          Bits, InfoHeader, DIB_RGB_COLORS, SRCCOPY);

            FreeMem(Bits);
         Finally;
            TmpPrinter.EndDoc;

            ReleaseOpenGLBmp(TmpBmp);
         End;
   End;
End;

////////////////////////////////////////////////////////////////////////////////
// GetDC:

Function TCustumOpenGL.GetDC: HDC;
Begin
   Result := DC;
End;

////////////////////////////////////////////////////////////////////////////////
// GetGLContext:

Function TCustumOpenGL.GetGLContext: HGLRC;
Begin
   Result := GLContext;
End;

////////////////////////////////////////////////////////////////////////////////
// GetPalette:

Function TCustumOpenGL.GetPalette: HPALETTE;
Begin
   Result := Palette;
End;

////////////////////////////////////////////////////////////////////////////////
//
// INHERITED METHODS
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Paint:

Procedure TCustumOpenGL.Paint;
Var
   GLColorVal: Array[0..3] Of GLclampf;
   GLColor, BackgroundColor: TColor;
Begin
   If (NeedToSetControlPixelFormat) Then
      Begin
         NeedToSetControlPixelFormat := false;
         SetControlPixelFormat;
      End;

   // Make sure we have the correct context

   If (GLContext <> wglGetCurrentContext) Then
      wglMakeCurrent(DC, GLContext);

   // Take into account the resizing of the control
   // Note: this is completely crazy, cuz it shouldn't be done all the time, but
   //       this is necessary when there are several instances of TCustumOpenGL on the
   //       same form. Indeed, in such a case, only one instance gets its
   //       correct viewport (or whatever), while the other ones get the one of
   //       the "lucky" instance. I thought it might br because of the GL
   //       context, so I checked it out in the "Resize" method, but it didn't
   //       make any difference, so here is the "ugly" but working solution...

   If (Assigned(OnResize)) Then
      OnResize(Self);

   // Display the background using "Color", if required

   glGetFloatv(GL_COLOR_CLEAR_VALUE, @GLColorVal);

(*   GLColor := TColor(RGB(Round(GLColorVal[0] * 256),
                         Round(GLColorVal[1] * 256),
                         Round(GLColorVal[2] * 256)));

   // Update "OrigColor" and "OrigGLColor" if necessary
   // Note: it CANNOT be possible to modify both of them at the same time,
   //       that's why we can afford the "else" and this is VERY important

   If ((Color <> GLColor) And (OrigColor <> Color)) Then
      // The user changed the value of "Color"

      OrigColor := Color
   Else If ((Color <> GLColor) And (OrigGLColor <> GLColor)) Then
      // The user changed the value of "GLColor"

      OrigGLColor := GLColor;

   // Get the right color for the background

   If (FColorUsedForBackground) Then
      BackgroundColor := OrigColor
   Else
      BackgroundColor := OrigGLColor;

   If (Not(csDesigning In ComponentState)) Then
      // Update "Color". This is pretty important, since the background of the
      // custom panel (from which TCustumOpenGL inherits) is drawn first. That way, we
      // avoid some annoying flickerings

      Color := BackgroundColor;

   glClearColor((ColorToRGB(BackgroundColor) Mod 256) / 256.0,
                (Round(ColorToRGB(BackgroundColor) / 256) Mod 256) / 256.0,
                (ColorToRGB(BackgroundColor) / 65536) / 256.0,
                0.0);
*)

   glClear(GL_COLOR_BUFFER_BIT);

   // Renders the scene

   glPushMatrix;

      ClearBackGround;

      If (Assigned(OnGLPaint)) Then
         OnGLPaint(Self);

   if FCentralCross then DrawCentralCross;
   if FCursorCross then DrawCursorCross(CursorPos);

   glPopMatrix;

   If (f_DOUBLEBUFFER In FGLFlags) Then
      SwapBuffers(DC);
   inherited;
End;

procedure TCustumOpenGL.Plane(X0, Y0, X1, Y1, X2, Y2, X3, Y3: extended);
begin
    glBegin(GL_QUADS);
    glVertex3f(X0,Y0,-0.1);
    glVertex3f(X1,Y1,-0.1);
    glVertex3f(X2,Y2,-0.1);
    glVertex3f(X3,Y3,-0.1);
    glEnd();
end;

procedure TCustumOpenGL.PolygonTess(n: array of TPoint3d);
var
 i:integer;
 vvv : array of TVector3d;
 tglutessobj : GLUtesselator;
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

procedure TCustumOpenGL.PolygonTess(x, y, z, AngleRotate: single;
  n: array of TPoint3d);
var
 i:integer;
 vvv : array of TVector3d;
 tglutessobj : GLUtesselator;
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

////////////////////////////////////////////////////////////////////////////////
// Resize:

Procedure TCustumOpenGL.Resize;
Begin
   Inherited Resize;
      ReDraw;
   If (Assigned(OnResize)) Then
      OnResize(Self);
End;

////////////////////////////////////////////////////////////////////////////////
// CreateWnd:

Procedure TCustumOpenGL.CreateWnd;
Begin
   Inherited CreateWnd;

   SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) Or WS_CLIPCHILDREN Or WS_CLIPSIBLINGS);
End;

procedure TCustumOpenGL.DblClick;
begin
  if FDblClickEnabled then
  Centrum := SToW(Point(Origin.x,Height-Origin.y));
  inherited;
end;

function TCustumOpenGL.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos);
  if Focused then
  if WheelDelta<0 then Zoom:=0.9*Zoom  else Zoom:=1.1*Zoom;
end;

function TCustumOpenGL.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelDown(Shift, MousePos);
end;

function TCustumOpenGL.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelUp(Shift, MousePos);
end;

procedure TCustumOpenGL.DrawAxis;
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

procedure TCustumOpenGL.DrawCentralCross;
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

procedure TCustumOpenGL.DrawCursorCross(x, y: integer);
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

procedure TCustumOpenGL.DrawCursorCross(p: TPoint);
begin
  DrawCursorCross(p.x,p.y);
end;

procedure TCustumOpenGL.DrawGrid;
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

////////////////////////////////////////////////////////////////////////////////
//
// METHODS HANDLING DIFFERENT MESSAGES
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// WMCreate:

Procedure TCustumOpenGL.WMCreate(Var aMessage: TWMCreate);
Begin
   DC := Windows.GetDC(Handle);
   SetControlPixelFormat;
   CreateGLContext;
   If (Assigned(OnGLInit)) Then
      OnGLInit(Self);
End;

////////////////////////////////////////////////////////////////////////////////
// WMDestroy:

Procedure TCustumOpenGL.WMDestroy(Var aMessage: TWMDestroy);
Begin
   If (wglGetCurrentContext <> 0) Then

      // Make the rendering context not current
      wglMakeCurrent(0, 0);

   If (GLContext <> 0) Then
      wglDeleteContext(GLContext);

   If (Palette <> 0) Then
      DeleteObject(Palette);

   // Release the device context
   ReleaseDC(Handle, DC);
End;

procedure TCustumOpenGL.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1
end;

procedure TCustumOpenGL.WMSize(var Msg: TWMSize);
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
(*
  if BackImage.Visible then begin
     BackBMP.Width  := Msg.Width;
     BackBMP.height := Msg.Height;
  end;*)
  ReDraw;
except
end;
end;

function TCustumOpenGL.WToS(p: TPoint2d): TPoint;
begin
  if FRotAngle<>0 then
  RelRotate2D(p,FCentrum,DegToRad(FRotAngle));
  Result := Point(XToS(p.x),YToS(p.y));
end;

function TCustumOpenGL.XToS(x: double): integer;
var asp: double;
begin
  asp := Width/Height;
  Result := Trunc(asp*Width/2+(x-FCentrum.x)*FZoom);
end;

function TCustumOpenGL.XToW(x: double): double;
begin
  Result := FCentrum.x+(x-Width/2)/FZoom;
end;

function TCustumOpenGL.YToS(y: double): integer;
begin
  Result := Trunc((Height/2+(y-FCentrum.y)*FZoom));
end;

function TCustumOpenGL.YToW(y: double): double;
begin
  Result := FCentrum.y+(y-Height/2)/FZoom;
end;

procedure TCustumOpenGL.ZoomPaper;
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

////////////////////////////////////////////////////////////////////////////////
//
// METHODS TO MODIFY THE DIFFERENT PUBLISHED PROPERTIES
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////

procedure TCustumOpenGL.SetActualTransform;
begin
  glTranslated(Centrum.x,Centrum.y,0);
  glRotated(RotAngle,0,0,1);
  glTranslated(-Centrum.x,-Centrum.y,0);
end;

procedure TCustumOpenGL.SetBackColor(const Value: TColor);
begin
  FBackColor := Value;
  invalidate;
end;

procedure TCustumOpenGL.SetCentralCross(const Value: boolean);
begin
  FCentralCross := Value;
  invalidate;
end;

procedure TCustumOpenGL.SetCentrum(const Value: TPoint2d);
var wx,hx: GLDouble;
begin
  FCentrum := Value;
  wx := (Width/2)/FZoom;
  hx := (Height/2)/FZoom;
  OrtoLeft   := Value.x - wx;
  OrtoRight  := Value.x + wx;
  OrtoBottom := Value.y - hx;
  OrtoTop    := Value.y + hx;
  ReSize;
//  If Assigned(FChangeWindow) then FChangeWindow(Self,FCentrum,FZoom,MovePt);
end;

(*
Procedure TCustumOpenGL.SetColorUsedForBackground(aValue: Boolean);
Begin
   If (aValue <> FColorUsedForBackground) Then
      Begin
         FColorUsedForBackground := aValue;
         Repaint;
      End;
End;
*)
////////////////////////////////////////////////////////////////////////////////
// SetGLColorBits:

Procedure TCustumOpenGL.SetGLColorBits(aValue: Byte);
Begin
   If (aValue <> FGLColorBits) Then
      Begin
         FGLColorBits := aValue;
         NeedToSetControlPixelFormat := True;
         Repaint;
      End;
End;

////////////////////////////////////////////////////////////////////////////////
// SetGLDepthBits:

Procedure TCustumOpenGL.SetGLDepthBits(aValue: Byte);
Begin
   If (aValue <> FGLDepthBits) Then
      Begin
         FGLDepthBits := aValue;
         NeedToSetControlPixelFormat := True;
         Repaint;
      End;
End;

////////////////////////////////////////////////////////////////////////////////
// SetGLFlags:

Procedure TCustumOpenGL.SetGLFlags(aValue: TGLFlags);
Begin
   // Note: the flags f_SUPPORT_GDI and f_DOUBLEBUFFER cannot be used together

   If ((aValue <> FGLFlags) And
       Not ((f_SUPPORT_GDI In aValue) And (f_DOUBLEBUFFER In aValue))) Then
      Begin
         FGLFlags := aValue;
         ConvertFlags;
         NeedToSetControlPixelFormat := True;
         Repaint;
      End;
End;

////////////////////////////////////////////////////////////////////////////////
// SetGLPixelType:

Procedure TCustumOpenGL.SetGLPixelType(aValue: TGLPixelType);
Begin
   If (aValue <> FGLPixelType) Then
      Begin
         FGLPixelType := aValue;
         ConvertPixelType;
         NeedToSetControlPixelFormat := True;
         Repaint;
      End;
End;

procedure TCustumOpenGL.SetOpenGLPaint(const Value: boolean);
begin
  FOpenGLPaint := Value;
  if not Value then
  begin
    Canvas.Brush.Color := BackColor;
    Canvas.Rectangle(Canvas.ClipRect);
  end;
  Repaint;
end;

////////////////////////////////////////////////////////////////////////////////
// GetPixelsPerInch:

Function TCustumOpenGL.GetPixelsPerInch: Integer;
Begin
    If (FPixelsPerInch = 0) Then
       Result := Screen.PixelsPerInch
    Else
       Result := FPixelsPerInch;
End;

function TCustumOpenGL.GetWorkArea: TRect2d;
begin
  Result := Rect2d(OrtoLeft,OrtoTop,OrtoRight,OrtoBottom);
end;

procedure TCustumOpenGL.glCircle(Cent, KerPoint: TPoint2d);
begin
  glCircle(Cent.X,Cent.Y,RelDist2d(Cent,KerPoint));
end;

procedure TCustumOpenGL.glCircle(Cent: TPoint2d; r: double);
begin
  glCircle(Cent.X,Cent.Y,r);
end;

procedure TCustumOpenGL.glCircle(u, v, r: double);
var i: integer;
begin
  glBegin(GL_LINE_STRIP);
    For i:=0 to 360 do
        glVertex2d(u+r*cos(DegToRad(i)),v+r*sin(DegToRad(i)));
  glEnd;
end;

procedure TCustumOpenGL.glColor(col: TColor);
var sz: TSzin;
begin
  sz := ColorToSzin(col);
  glColor3f(sz.R,sz.G,sz.B);
end;

procedure TCustumOpenGL.glEllipse(p1, p2: TPoint2d);
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

procedure TCustumOpenGL.glPolygon(p: array of TPoint3d);
var i: integer;
begin
  glBegin(GL_LINE_LOOP);
    For i:=0 to High(p) do begin
        glVertex3f(p[i].x,p[i].y,0);
    end;
  glEnd;
end;

procedure TCustumOpenGL.glPolygonFill(p: array of TPoint3d);
begin
  PolygonTess(p);
end;

procedure TCustumOpenGL.glPolyLine(p: array of TPoint3d);
var i: integer;
begin
  glBegin(GL_LINE_STRIP);
    For i:=0 to High(p) do begin
        glVertex3f(p[i].x,p[i].y,0);
    end;
  glEnd;
end;

procedure TCustumOpenGL.glPrint(fName: string; x, y, Height, Angle: double;
  text: string);
begin

end;

procedure TCustumOpenGL.glPrint(x, y, Height, Angle: double; text: string);
begin

end;

procedure TCustumOpenGL.glRectangle(p: TPoint2d; a, b: double);
begin
  glBegin(GL_LINE_STRIP);
    glVertex2d(p.x-a/2,p.y+b/2);
    glVertex2d(p.x+a/2,p.y+b/2);
    glVertex2d(p.x+a/2,p.y-b/2);
    glVertex2d(p.x-a/2,p.y-b/2);
    glVertex2d(p.x-a/2,p.y+b/2);
  glEnd;
end;

procedure TCustumOpenGL.glRectangle(p1, p2: TPoint2d);
begin
  glRectangle(p1,Point2d(p2.X,p1.y),p2,Point2d(p1.X,p2.y))
end;

procedure TCustumOpenGL.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;

end;

procedure TCustumOpenGL.KeyPress(var Key: Char);
begin
  inherited;

end;

procedure TCustumOpenGL.glRectangle(p1, p2, p3, p4: TPoint2d);
begin
  glBegin(GL_LINE_STRIP);
    glVertex2d(p1.x,p1.y);
    glVertex2d(p2.x,p2.y);
    glVertex2d(p3.x,p3.y);
    glVertex2d(p4.x,p4.y);
    glVertex2d(p1.x,p1.y);
  glEnd;
end;

procedure TCustumOpenGL.Line(X0, Y0, X1, Y1: extended);
begin
    glBegin(GL_LINES);
    glVertex3f(X0,Y0,0);
    glVertex3f(X1,Y1,0);
    glEnd();
end;

procedure TCustumOpenGL.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
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

procedure TCustumOpenGL.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  dx,dy: GLDouble;
begin
  CursorPos := Point(x,Height-y);
  MapPoint := SToW(Point(x,Height-y));
  MovePt:=Point(x,y);

  inherited MouseMove(Shift,x,y);

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

  oldMovePt := MovePt;
  oldMapPoint := MapPoint;
  invalidate;
end;

procedure TCustumOpenGL.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  Moving := False;
  MapPoint := SToW(Point(x,Height-y));
  inherited;
end;

procedure TCustumOpenGL.MoveWindow(x, y: double);
begin
  Centrum := Point2d(Centrum.x-x,Centrum.y-y);
end;

////////////////////////////////////////////////////////////////////////////////
// SetPixelsPerInch:

Procedure TCustumOpenGL.SetPixelsPerInch(aValue: Integer);
Begin
   If ((aValue <> GetPixelsPerInch) And ((aValue = 0) Or (aValue >= 36)) And
       (Not(csLoading In ComponentState) Or (FPixelsPerInch > 0))) Then
      FPixelsPerInch := aValue;
End;

////////////////////////////////////////////////////////////////////////////////
// SetPrintScale:

Procedure TCustumOpenGL.SetPrintScale(aValue: TGLPrintScale);
Begin
   If (aValue <> FPrintScale) Then
      FPrintScale := aValue;
End;

procedure TCustumOpenGL.SetRotAngle(const Value: double);
begin
  FRotAngle := Value;
  invalidate;
end;

procedure TCustumOpenGL.SetZoom(const Value: extended);
var wx,hy,dx,dy: GLDouble;
    x0,y0,x1,y1: GLDouble;
    dZoom      : GLDouble;
begin
//if OpenGL_OK then
Try
    wx := (Width/2)/Value;
    hy := (Height/2)/Value;
    dx := 0; dy := 0;
    OrtoLeft   := FCentrum.x - wx;
    OrtoRight  := FCentrum.x + wx;
    OrtoBottom := FCentrum.y - hy;
    OrtoTop    := FCentrum.y + hy;
(*
 if CentralisZoom then begin
    dZoom := Value/FZoom;
    x0 := MapPoint.x - FCentrum.X;
    y0 := MapPoint.y - FCentrum.Y;
    x1 := x0 * dZoom;
    y1 := y0 * dZoom;
    dx := x1-x0;
    dy := y1-y0;
    MoveWindow(-dx,-dy);
 end;*)
  FZoom := Value;
//  If Assigned(FChangeWindow) then FChangeWindow(Self,FCentrum,FZoom, MovePt);
  ReDraw;
EXCEPT
end;
end;

procedure TCustumOpenGL.ShiftWindow(x, y: double);
var dx,dy : double;
begin
    dx := (Width/2)+x;
    dy := (Height/2)-y;
    Centrum := SToW(Point(Round(dx),Round(dy)));
end;

function TCustumOpenGL.SToW(x, y: double): TPoint2d;
begin
  Result := Point2d(XToW(x),YToW(y));
end;

function TCustumOpenGL.SToW(p: TPoint): TPoint2d;
begin
  Result := Point2d(XToW(p.x),YToW(p.y));
  if FRotAngle<>0 then
  RelRotate2D(Result,FCentrum,DegToRad(-FRotAngle));
end;

////////////////////////////////////////////////////////////////////////////////
//
// METHODS USED FOR INTERNAL PURPOSE
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// SetControlPixelFormat:

Procedure TCustumOpenGL.SetControlPixelFormat;
Var
   GLPixelFormat: Integer;
   PixelDesc: TPixelFormatDescriptor;
   Colors: Integer;
   Heap: THandle;
   PtrToPalette: ^TLogPalette;
   ByRedMask, ByGreenMask, ByBlueMask: Integer;
   I: Integer;
Begin
   FillChar(PixelDesc, SizeOf(PixelDesc), 0);

   With PixelDesc Do
      Begin
         nSize           := SizeOf(PIXELFORMATDESCRIPTOR);
         nVersion        := 1;
         dwFlags         := ConvertedFlags;
         iPixelType      := ConvertedPixelType;
         cColorBits      := FGLColorBits;
         cRedBits        := 8;
         cRedShift       := 16;
         cGreenBits      := 8;
         cGreenShift     := 8;
         cBlueBits       := 8;
         cBlueShift      := 0;
         cAlphaBits      := 0;
         cAlphaShift     := 0;
         cAccumBits      := 64;
         cAccumRedBits   := 16;
         cAccumGreenBits := 16;
         cAccumBlueBits  := 16;
         cAccumAlphaBits := 0;
         cDepthBits      := FGLDepthBits;
         cStencilBits    := 8;
         cAuxBuffers     := 0;
         iLayerType      := 0;
         bReserved       := 0;
         dwLayerMask     := 0;
         dwVisibleMask   := 0;
         dwDamageMask    := 0;
      End;

   // Get the best available match pixel format for the device context

   GLPixelFormat := ChoosePixelFormat(DC, @PixelDesc);

   if (GLPixelFormat = 0) Then
      // We didn't get any, so let's choose a default one

      GLPixelFormat := 1;

   // Set up the pixel format

   If (SetPixelFormat(DC, GLPixelFormat, @PixelDesc)) Then
      Begin
         DescribePixelFormat(DC, GLPixelFormat, SizeOf(PixelDesc), PixelDesc);

         If ((PixelDesc.dwFlags And PFD_NEED_PALETTE) > 0) Then
            Begin
               Colors       := 1 ShL PixelDesc.cColorBits;
               Heap         := GetProcessHeap;
               PtrToPalette := HeapAlloc(Heap, 0, SizeOf(TLogPalette) + (Colors * SizeOf(TPaletteEntry)));
               ByRedMask    := (1 ShL PixelDesc.cRedBits) - 1;
               ByGreenMask  := (1 ShL PixelDesc.cGreenBits) - 1;
               ByBlueMask   := (1 ShL PixelDesc.cBlueBits) - 1;

               PtrToPalette.palVersion    := $300;
               PtrToPalette.palNumEntries := Colors;

               For I := 0 To Colors Do
                  Begin
                     PtrToPalette.palPalEntry[I].peRed   := Round((((I ShR PixelDesc.cRedShift)   And ByRedMask)   * 255) / ByRedMask);
                     PtrToPalette.palPalEntry[I].peGreen := Round((((I ShR PixelDesc.cGreenShift) And ByGreenMask) * 255) / ByGreenMask);
                     PtrToPalette.palPalEntry[I].peBlue  := Round((((I ShR PixelDesc.cBlueShift)  And ByBlueMask)  * 255) / ByBlueMask);
                     PtrToPalette.palPalEntry[I].peFlags := 0;
                  End;

               Palette := CreatePalette(PLogPalette(PtrToPalette)^);
               HeapFree(Heap, 0, PtrToPalette);

               If (Palette <> 0) Then
                  Begin
                     SelectPalette(DC, Palette, false);

                     RealizePalette(DC);
                  End;
            End
         Else
            Begin
               If (Palette <> 0) Then
                  DeleteObject(Palette);

               Palette := 0;
            End;
      End;
End;

procedure TCustumOpenGL.SetCursorCross(const Value: boolean);
begin
  FCursorCross := Value;
  invalidate;
end;

////////////////////////////////////////////////////////////////////////////////
// CreateGLContext:

Procedure TCustumOpenGL.CreateGLContext;
Begin
   GLContext := wglCreateContext(DC);

   If (GLContext <> 0) Then
      wglMakeCurrent(DC, GLContext);
End;

////////////////////////////////////////////////////////////////////////////////
// ConvertFlags:

procedure TCustumOpenGL.ClearBackground;
var sz: TSzin;
begin
  sz := ColorToSzin(BackColor);
  glClearColor(sz.R,sz.G,sz.B,1);
end;

procedure TCustumOpenGL.CMChildkey(var msg: TCMChildKey);
var dx,dy: integer;
    k:integer;
begin
  k:=16;
  dx := 0; dy:=0;
  msg.result := 1; // declares key as handled
  Case msg.charcode of
    VK_LEFT    : dx:=-k;
    VK_RIGHT   : dx:=k;
    VK_UP      : dy:=k;
    VK_DOWN    : dy:=-k;
    VK_ADD     : Zoom:=1.1*Zoom;
    VK_SUBTRACT: Zoom:=0.9*Zoom;
  Else
    msg.result:= 0;
    inherited;
  End;
  if (dx<>0) or (dy<>0) then
     Centrum := Point2d(Centrum.x+dx,Centrum.y+dy);
end;

Procedure TCustumOpenGL.ConvertFlags;
Begin
   ConvertedFlags := 0;

   If (f_DOUBLEBUFFER        In FGLFlags) Then ConvertedFlags := ConvertedFlags Or PFD_DOUBLEBUFFER;
   If (f_DRAW_TO_BITMAP      In FGLFlags) Then ConvertedFlags := ConvertedFlags Or PFD_DRAW_TO_BITMAP;
   If (f_DRAW_TO_WINDOW      In FGLFlags) Then ConvertedFlags := ConvertedFlags Or PFD_DRAW_TO_WINDOW;
   If (f_GENERIC_ACCELERATED In FGLFlags) Then ConvertedFlags := ConvertedFlags Or PFD_GENERIC_ACCELERATED;
   If (f_GENERIC_FORMAT      In FGLFlags) Then ConvertedFlags := ConvertedFlags Or PFD_GENERIC_FORMAT;
   If (f_NEED_PALETTE        In FGLFlags) Then ConvertedFlags := ConvertedFlags Or PFD_NEED_PALETTE;
   If (f_NEED_SYSTEM_PALETTE In FGLFlags) Then ConvertedFlags := ConvertedFlags Or PFD_NEED_SYSTEM_PALETTE;
   If (f_SUPPORT_GDI         In FGLFlags) Then ConvertedFlags := ConvertedFlags Or PFD_SUPPORT_GDI;
   If (f_SUPPORT_OPENGL      In FGLFlags) Then ConvertedFlags := ConvertedFlags Or PFD_SUPPORT_OPENGL;
   If (f_STEREO              In FGLFlags) Then ConvertedFlags := ConvertedFlags Or PFD_STEREO;
   If (f_SWAP_COPY           In FGLFlags) Then ConvertedFlags := ConvertedFlags Or PFD_SWAP_COPY;
   If (f_SWAP_EXCHANGE       In FGLFlags) Then ConvertedFlags := ConvertedFlags Or PFD_SWAP_EXCHANGE;
   If (f_SWAP_LAYER_BUFFERS  In FGLFlags) Then ConvertedFlags := ConvertedFlags Or PFD_SWAP_LAYER_BUFFERS;
End;

////////////////////////////////////////////////////////////////////////////////
// ConvertPixelType:

Procedure TCustumOpenGL.ConvertPixelType;
Begin
   If (FGLPixelType = pt_TYPE_RGBA) Then
      ConvertedPixelType := PFD_TYPE_RGBA
   Else If (FGLPixelType = pt_TYPE_COLORINDEX) Then
      ConvertedPixelType := PFD_TYPE_COLORINDEX;
End;

////////////////////////////////////////////////////////////////////////////////
//
// MISCELLANEOUS
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Registration

Procedure Register;
Begin
   RegisterComponents('AL', [TOpenGL]);
End;

////////////////////////////////////////////////////////////////////////////////

End.

// End of file
////////////////////////////////////////////////////////////////////////////////

