// ===========================================================================
// TALPrintView
// a print view visual component for drawing, with freely useable Canvas
// Copyright: StellaSOFT 2012 Hungary
// ===========================================================================
unit AL_PrintView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, ExtCtrls,
  Printers, NewGeom, DGrafik, StPrint;

Type

  TPrintViewFitting = (pvoNone, pvoCenter, pvoFit, pvoFitWidth, pvoFitHeight);

  TOnPaint = procedure(Sender: TObject) of object;

  // Drawing surface for print view

  TALPrintPage = class(TImage)
  private
    FMarginVisible: boolean;
    FZoom: double;
    FMargin: integer;
    FPageHeight: integer;
    FPageWidth: integer;
    FBackColor: TColor;
    procedure SetBackColor(const Value: TColor);
    procedure SetMargin(const Value: integer);
    procedure SetMarginVisible(const Value: boolean);
    procedure SetPageHeight(const Value: integer);
    procedure SetPageWidth(const Value: integer);
    procedure SetZoom(const Value: double);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure NewSize(w,h: integer);
    procedure FitWindow;
    procedure FitWidth;
    procedure FitHeight;
  published
    property BackColor   : TColor read FBackColor write SetBackColor;
    property PageWidth   : integer read FPageWidth write SetPageWidth;
    property PageHeight  : integer read FPageHeight write SetPageHeight;
    property Margin      : integer read FMargin write SetMargin;
    property MarginVisible : boolean read FMarginVisible write SetMarginVisible;
    property Zoom        : double  read FZoom write SetZoom;
  end;

  TALPrintViewPage = class(TCustomControl)
  private
    FOnPaint: TOnPaint;
    procedure WMEraseBkGnd(var Message:TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    LX,LY : integer;
    SX,SY : Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure NewSize(w,h: integer);
    property Canvas;
    property OnPaint: TOnPaint read FOnPaint write FOnPaint;
  end;

  // Scrolling box for print view with image

  TALPrintView = class(TScrollingWincontrol)
  private
    FPageWidth: integer;
    FPageHeight: integer;
    FBackColor: TColor;
    FMargin: integer;
    FZoom: double;
    FFitting: TPrintViewFitting;
    FMarginVisible: boolean;
    FCanvas: TCanvas;
    FPage: TALPrintViewPage;
    FOnPaint: TOnPaint;
    function GetCanvas: TCanvas;
    procedure SetBackColor(const Value: TColor);
    procedure SetPageHeight(const Value: integer);
    procedure SetPageWidth(const Value: integer);
    procedure SetMargin(const Value: integer);
    procedure SetZoom(const Value: double);
    procedure SetFitting(const Value: TPrintViewFitting);
    procedure SetMarginVisible(const Value: boolean);
    procedure PagePaint(Sender: TObject);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Resize; override;
    procedure NewPageSize(w,h: integer);
    procedure FitWindow;
    procedure FitWidth;
    procedure FitHeight;
    property Page        : TALPrintViewPage read FPage write FPage;
    property Canvas      : TCanvas read GetCanvas;
  published
    property BackColor   : TColor read FBackColor write SetBackColor;
    property Fitting     : TPrintViewFitting read FFitting write SetFitting;
    property PageWidth   : integer read FPageWidth write SetPageWidth;
    property PageHeight  : integer read FPageHeight write SetPageHeight;
    property Margin      : integer read FMargin write SetMargin;
    property MarginVisible : boolean read FMarginVisible write SetMarginVisible;
    property Zoom        : double  read FZoom write SetZoom;
    property OnPaint     : TOnPaint read FOnPaint write FOnPaint;
  end;

  procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('AL',[TALPrintPage]);
end;

{ TALPrintView }

constructor TALPrintView.Create(AOwner: TComponent);
begin
  inherited;
  DoubleBuffered := True;
  AutoScroll     := True;
  Page           := TALPrintViewPage.Create(Self);
  Page.Parent    := Self;
  Page.OnPaint   := PagePaint;
  if IsPrinter then begin
     FPageWidth     := PageWidthmm;
     FPageHeight    := PageHeightmm;
  end else begin
     FPageWidth     := 210;
     FPageHeight    := 297;
  end;
  Color          := clGray;
  FMargin        := 10;
  FFitting       := pvoFit;
  NewPageSize(FPageWidth,FPageHeight);
end;

destructor TALPrintView.Destroy;
begin
  Page.Free;
  inherited;
end;

procedure TALPrintView.PagePaint(Sender: TObject);
begin
  if Assigned(FOnPaint) then FOnPaint(Self)
end;

procedure TALPrintView.FitHeight;
begin
 Page.Height  := ClientHeight - 2*Margin;
 FZoom := Page.Width/FPageHeight;
 Page.Width := Trunc(FZoom*FPageWidth);
 Page.Left := (ClientWidth-Trunc(FZoom*FPageWidth)) div 2;
 Page.Top  := Margin;
end;

procedure TALPrintView.FitWidth;
begin
 Page.Width  := ClientWidth - 2*Margin;
 FZoom := Page.Width/FPageWidth;
 Page.Height := Trunc(FZoom*FPageHeight);
 Page.Left := Margin;
 Page.Top  := Margin;
end;

procedure TALPrintView.FitWindow;
var w,h: integer;
    pw,ph: integer;
    x,y: integer;          // Page topleft corner
begin
 w := ClientWidth - 2*Margin;
 h := ClientHeight - 2*Margin;
 FZoom := w/FPageWidth;
 pw:= Trunc(FZoom * FPageWidth);
 ph:= Trunc(FZoom * FPageHeight);
 if ph>=h then begin
    FZoom := h/FPageHeight;
    Page.Left := Trunc(ClientWidth - FPageWidth*FZoom) div 2;
    Page.Top  := Margin;
 end else begin
    FZoom := w/FPageWidth;
    Page.Left := Margin;
    Page.Top  := Trunc(ClientHeight - FPageHeight*FZoom) div 2;
 end;
 Page.Width := Trunc(FZoom*FPageWidth);
 Page.Height := Trunc(FZoom*FPageHeight);
// invalidate;
end;

procedure TALPrintView.Resize;
begin
  HorzScrollBar.Range := Page.Width;
  VertScrollBar.Range := Page.Height;
  Page.LX := (Page.Width - ClientWidth) * -1;
  Page.LY := (Page.Height - ClientHeight) * -1;
  Fitting := FFitting;
  inherited;
end;

procedure TALPrintView.SetBackColor(const Value: TColor);
begin
  FBackColor := Value;
  Color := Value;
  invalidate;
end;

procedure TALPrintView.SetPageHeight(const Value: integer);
begin
  FPageHeight := Value;
  invalidate;
end;

procedure TALPrintView.SetPageWidth(const Value: integer);
begin
  FPageWidth := Value;
  invalidate;
end;

procedure TALPrintView.SetMargin(const Value: integer);
begin
  FMargin := Value;
  invalidate;
end;

procedure TALPrintView.NewPageSize(w, h: integer);
begin
  FPageWidth := w;
  FPageHeight := h;
  Fitting := FFitting;
end;

procedure TALPrintView.SetZoom(const Value: double);
begin
  FZoom := Value;
  invalidate;
end;

procedure TALPrintView.SetFitting(const Value: TPrintViewFitting);
begin
Try
  FFitting := Value;
  Case Fitting of
  pvoCenter:
    begin
    end;
  pvoFit:       FitWindow;
  pvoFitWidth:  FitWidth;
  pvoFitHeight: FitHeight;
  end;
  invalidate;
except
end;
end;

procedure TALPrintView.SetMarginVisible(const Value: boolean);
begin
  FMarginVisible := Value;
  invalidate;
end;

function TALPrintView.GetCanvas: TCanvas;
var t : TRect;
begin
  t := Page.Canvas.ClipRect;
  Result := Page.Canvas;
end;

{ TALPrintViewPage }

constructor TALPrintViewPage.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TALPrintViewPage.Destroy;
begin
  inherited;
end;

procedure TALPrintViewPage.Paint;
var t : TRect;
begin
  With Canvas do begin
       Pen.Color:=clBlack;
       Brush.Color := clWhite;
       Brush.Style := bsSolid;
       Rectangle(Cliprect);
  end;
  t := Canvas.ClipRect;
  if Assigned(FOnPaint) then FOnPaint(Self)
end;

procedure TALPrintViewPage.NewSize(w, h: integer);
begin
  Width := w;
  Height := h;
  invalidate;
//  Changed := True;
end;

procedure TALPrintViewPage.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  SX := X;  // X start co-ordinate
  SY := Y;  // Y start co-ordinate
end;

procedure TALPrintViewPage.MouseMove(Shift: TShiftState; X, Y: Integer);
var NX: Integer;
    NY: Integer;
begin
if not (ssLeft in Shift) then
  Exit;
  NX := Left + X - SX;
  NY := Top + Y - SY;
//  if (NX < 0) and (NX > LX) then
     Left := NX;
//  if (NY < 0) and (NY > LY) then
     Top := NY;
  invalidate;
  inherited;
end;

procedure TALPrintViewPage.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;

end;

procedure TALPrintViewPage.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

procedure TALPrintViewPage.WMSize(var Msg: TWMSize);
begin

end;

{ TALPrintPage }

constructor TALPrintPage.Create(AOwner: TComponent);
begin
  inherited;
  if IsPrinter then begin
     FPageWidth     := PageWidthmm;
     FPageHeight    := PageHeightmm;
  end else begin
     FPageWidth     := 210;
     FPageHeight    := 297;
  end;
  BackColor      := clGray;
  FMargin        := 10;
  FZoom          := 2;
  NewSize(FPageWidth,FPageHeight);
end;

destructor TALPrintPage.Destroy;
begin
  inherited;
end;

procedure TALPrintPage.FitHeight;
begin
 Height  := Parent.ClientHeight - 2*Margin;
 FZoom   := Width/FPageHeight;
 Width   := Trunc(FZoom*FPageWidth);
 Left    := (Parent.ClientWidth-Trunc(FZoom*FPageWidth)) div 2;
 Top     := Margin;
end;

procedure TALPrintPage.FitWidth;
begin
 Width  := Parent.ClientWidth - 2*Margin;
 FZoom  := Width/FPageWidth;
 Height := Trunc(FZoom*FPageHeight);
 Left   := Margin;
 Top    := Margin;
end;

procedure TALPrintPage.FitWindow;
var w,h: integer;
    pw,ph: integer;
    x,y: integer;          // Page topleft corner
begin
 w := Parent.ClientWidth - 2*Margin;
 h := Parent.ClientHeight - 2*Margin;
 FZoom := w/FPageWidth;
 pw:= Trunc(FZoom * FPageWidth);
 ph:= Trunc(FZoom * FPageHeight);
 if ph>=h then begin
    FZoom := h/FPageHeight;
    Left := Trunc(Parent.ClientWidth - FPageWidth*FZoom) div 2;
    Top  := Margin;
 end else begin
    FZoom := w/FPageWidth;
    Left := Margin;
    Top  := Trunc(Parent.ClientHeight - FPageHeight*FZoom) div 2;
 end;
 Width := Trunc(FZoom*FPageWidth);
 Height := Trunc(FZoom*FPageHeight);
end;

procedure TALPrintPage.NewSize(w, h: integer);
begin
  FPageWidth     := w;
  FPageHeight    := h;
  Width  := Trunc(FZoom*w);
  Height := Trunc(FZoom*h);
//  Picture.Bitmap.Width := Width;
//  Picture.Bitmap.Height := Height;
  invalidate;
end;

procedure TALPrintPage.SetBackColor(const Value: TColor);
begin
  FBackColor := Value;
  invalidate;
end;

procedure TALPrintPage.SetMargin(const Value: integer);
begin
  FMargin := Value;
  invalidate;
end;

procedure TALPrintPage.SetMarginVisible(const Value: boolean);
begin
  FMarginVisible := Value;
  invalidate;
end;

procedure TALPrintPage.SetPageHeight(const Value: integer);
begin
  FPageHeight := Value;
  invalidate;
end;

procedure TALPrintPage.SetPageWidth(const Value: integer);
begin
  FPageWidth := Value;
  invalidate;
end;

procedure TALPrintPage.SetZoom(const Value: double);
begin
  FZoom := Value;
  Width  := Trunc(FZoom*FPageWidth);
  Height := Trunc(FZoom*FPageHeight);
  invalidate;
end;

end.
