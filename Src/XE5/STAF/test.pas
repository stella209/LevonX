unit test;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Clipbrd, StdCtrls,
  NewGeom, Math;

Type
  TTest = class(TCustomControl)
  private
    FCentralCross: boolean;
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnPaint: TNotifyEvent;
    procedure SetCentralCross(const Value: boolean);
//    procedure WMEraseBkGnd(var Message:TWMEraseBkGnd); message WM_ERASEBKGND;
//    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;

//    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    Procedure CMChildkey( Var msg: TCMChildKey ); message CM_CHILDKEY;
    procedure CMMouseEnter(var msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var msg: TMessage); message CM_MOUSELEAVE;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;

    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure KeyDown(var Key: Word;Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure DblClick;  override;
  public
    constructor Create(AOwner: TComponent); override;

    destructor Destroy; override;
    procedure Paint; override;
  published
    property CentralCross  : boolean   read FCentralCross write SetCentralCross;
    property OnMouseEnter  : TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave  : TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnPaint       : TNotifyEvent read FOnPaint write FOnPaint;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('AL', [TTest]);
end;

procedure TTest.CMChildkey(var msg: TCMChildKey);
var dx,dy: integer;
    k:integer;
begin
  k:=16;
  dx := 0; dy:=0;
  msg.result := 1; // declares key as handled
(*  Case msg.charcode of
  Else
    msg.result:= 0;
    inherited;
  End;*)
end;

procedure TTest.CMMouseEnter(var msg: TMessage);
begin
  if TabStop then Setfocus;
  if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);

end;

procedure TTest.CMMouseLeave(var msg: TMessage);
begin
  if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
end;

constructor TTest.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TTest.DblClick;
begin
  inherited;

end;

destructor TTest.Destroy;
begin

  inherited;
end;

procedure TTest.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;

end;

procedure TTest.KeyPress(var Key: Char);
begin
  inherited;

end;

procedure TTest.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;

end;

procedure TTest.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;

end;

procedure TTest.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;

end;

procedure TTest.Paint;
begin
  If componentstate=[csDesigning] then begin
  end;
  Canvas.Brush.color := clRed;
  Canvas.Brush.Style := bsSolid;
  Canvas.Rectangle(Canvas.ClipRect);
  If Assigned(FOnPaint) then FOnPaint(Self);
end;


procedure TTest.SetCentralCross(const Value: boolean);
begin
  FCentralCross := Value;
end;
(*
procedure TTest.WMEraseBkGnd(var Message: TWMEraseBkGnd);

begin

  Message.Result := 1

end;

procedure TTest.WMPaint(var Msg: TWMPaint);
begin
 Msg.Result := 0;
end;

procedure TTest.WMSize(var Msg: TWMSize);
begin
end;
*)
end.
