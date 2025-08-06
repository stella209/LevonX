(*
   TStRuler    : Delphi 5 component
   Author      : Agócs László StellaSOFT 2005
   Notes       : A ruler component for grafical and text
                 windowed controls usage
   Hungary     : Vonalzó komponens mm,cm,dm,m,km skálával
*)

unit AL_Ruler;

interface

uses
  Windows,Classes,SysUtils,Controls,StdCtrls,ExtCtrls,Graphics,Forms,Messages,
  StObjects, NewGeom, Szamok;

Type

  { Skála jellemzõk - Scale object for TStRuler}

  TScaleStyle = (ssLine, ssCircle, ssDot);
  TOrientation = (toHorizontal, toVertical);

  TALCustomRuler = class(TCustomPanel)
  private
    FOnChange: TNotifyEvent;
    FColor: TColor;
    fOrientation: TOrientation;
    fScaleFactor: extended;
    fMin: extended;
    FScaleFont: TFont;
    fMarkerPos: extended;
    FMarkerColor: TColor;
    FMarkerVisible: boolean;
    fMetric: TMetric;
    procedure WMEraseBkGnd(var Message:TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure Changed(Sender:TObject);
    procedure SetOrientation(const Value: TOrientation);
    procedure SetColor(const Value: TColor);
    procedure SetMin(const Value: extended);
    procedure SetScaleFactor(const Value: extended);
    procedure SetFont(const Value: TFont);
    procedure SetMarkerColor(const Value: TColor);
    procedure SetMarkerPos(const Value: extended);
    procedure SetMarkerVisible(const Value: boolean);
    procedure SetMetric(const Value: TMetric);
  protected
    BMP : TBitmap;
    painting: boolean;
    szorzo: double;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    property Color : TColor read FColor write SetColor default clBlack;
    property Metric: TMetric read fMetric write SetMetric default meMM;
    property MarkerColor : TColor read FMarkerColor write SetMarkerColor default clBlue;
    property MarkerPos: extended read fMarkerPos write SetMarkerPos;
    property MarkerVisible: boolean read FMarkerVisible write SetMarkerVisible;
    property ScaleFont: TFont read FScaleFont write FScaleFont;
    property Orientation : TOrientation read fOrientation write SetOrientation;
    property Min : extended read fMin write SetMin;
    property ScaleFactor : extended read fScaleFactor write SetScaleFactor;
//    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TALRuler = class(TALCustomRuler)
  published
    property Color;
    property ScaleFont;
    property Min;
    property ScaleFactor;
    property Orientation;
    property Align;
    property Anchors;
(*    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderStyle;
    property BorderWidth;*)
    property Hint;
    property MarkerColor;
    property MarkerPos;
    property Metric;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyPress;
    property OnKeyDown;
    property OnKeyUp;
    property OnMouseMove;
    property OnMouseDown;
    property OnMouseUp;
  end;

//procedure Register;

implementation
(*
procedure Register;
begin
  RegisterComponents('AL',[TALRuler]);
end;
*)

{ TALCustomRuler }

constructor TALCustomRuler.Create(AOwner: TComponent);
begin
  inherited;
  BMP := TBitmap.Create;
  DoubleBuffered := True;
  fOrientation := toHorizontal;
  fScaleFont := TFont.Create;
     With fScaleFont do begin
        Name  := 'Tachoma';
        Color := clBlack;
        Size  := 8;
        Style := [];
     end;
  fScaleFont.OnChange := Changed;
  fScaleFactor   := 1.0;
  fMetric        := meMM;
  szorzo         := 1.0;
  fMarkerColor   := clBlue;
  fMarkerPos     := 100;
  fMarkerVisible := True;
  Width          := 200;
  Height         := 28;
  painting       := False;
end;

destructor TALCustomRuler.Destroy;
begin
  BMP.Free;
  fScaleFont.Free;
  inherited;
end;

procedure TALCustomRuler.Changed(Sender:TObject);
begin
  invalidate;
//  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TALCustomRuler.SetColor(const Value: TColor);
begin
  FColor := Value;
  Canvas.Brush.Color := Value;
  invalidate;
end;

procedure TALCustomRuler.SetOrientation(const Value: TOrientation);
var w,h: integer;
begin
  If fOrientation <> Value then begin
     fOrientation := Value;
//     w:=Width; h:=Height;
//     Width:=h; Height:=w;
     invalidate;
  end;
end;

procedure TALCustomRuler.SetMin(const Value: extended);
begin
  fMin := Value/szorzo;
  invalidate;
end;

procedure TALCustomRuler.SetScaleFactor(const Value: extended);
begin
  fScaleFactor := Value;
  invalidate;
end;

procedure TALCustomRuler.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1
end;

procedure TALCustomRuler.SetFont(const Value: TFont);
begin
  fScaleFont := Value;
  Invalidate;
end;

procedure TALCustomRuler.SetMarkerColor(const Value: TColor);
begin
  FMarkerColor := Value;
  invalidate;
end;

procedure TALCustomRuler.SetMarkerVisible(const Value: boolean);
begin
  FMarkerVisible := Value;
  Invalidate;
end;

procedure TALCustomRuler.SetMetric(const Value: TMetric);
begin
  fMetric := Value;
   if Metric = meMM then
      szorzo := 1
   else
      szorzo := inch/10;
  Invalidate;
end;

procedure TALCustomRuler.SetMarkerPos(const Value: extended);
begin
  fMarkerPos := Value;
  Repaint;
end;

procedure TALCustomRuler.Paint;
var R: TRect;
    kp: TPoint2d;
    tav,mar,marx: extended;
    i: integer;
    GridTav : integer;     // Distance between lines
    s: string;
begin
if not painting then
Try
Try
  painting:=True;
  GridTav := 1;
  R := ClientRect;
  BMP.Width := Width;
  BMP.Height := Height;
  BMP.Canvas.Font.Assign(fScaleFont);

  With BMP.Canvas do begin

     Pen.Color := clBlack;
     BMP.Canvas.Brush.Assign(Canvas.Brush);
     Rectangle(0,0,Width,Height);

    For i:=0 to 8 do begin
      tav  := ScaleFactor * Gridtav * szorzo;

      if tav>4 then begin

      Case GridTav of
      1:  begin
          Pen.Width := 1;
      Pen.Color := clBlack;
          end;
      10: begin
          Pen.Width := 1;
          Font.Color := clPurple;
          end;
      100:Begin
          Pen.Width := 2;
          Font.Color := clRed;
          end;
      end;

      marx := -Maradek(Min,GridTav);
      kp.x := tav*marx;

      Case Orientation of
      toHorizontal:
      begin
      While kp.x<=Width do begin
            MoveTo(Round(kp.x),Height);
            LineTo(Round(kp.x),Height-(4*(i+1)+4));
            if (tav>40) and (GridTav>1) then begin
               s := Inttostr(Round(Min + (kp.x / ScaleFactor)/szorzo));
               TextOut(Trunc(kp.x)-(TextWidth(s) div 2),4,s);
            end;
            kp.x:=kp.x+tav;
      end;
            if MarkerVisible then begin
               Pen.Color := fMarkerColor;
               MoveTo(Round((fMarkerPos-Min*szorzo)*ScaleFactor),0);
               LineTo(Round((fMarkerPos-Min*szorzo)*ScaleFactor),Height);
            end;
      end;
      toVertical:
      begin
      While kp.x<=Height do begin
            MoveTo(Width,height-Round(kp.x));
            LineTo(Width-(4*(i+1)+4),height-Round(kp.x));
            if (tav>40) and (GridTav>1) then begin
               s := Inttostr(Round(Min + (kp.x / ScaleFactor)/szorzo));
               TextOut(4,height-Trunc(kp.x)-(TextHeight(s) div 2),s);
               RotText(Canvas,4,height-Trunc(kp.x)-(TextHeight(s) div 2),s,30);
            end;
            kp.x:=kp.x+tav;
      end;
            if MarkerVisible then begin
               Pen.Color := fMarkerColor;
               MoveTo(0,height-Round((fMarkerPos-Min*szorzo)*ScaleFactor));
               LineTo(Width,height-Round((fMarkerPos-Min*szorzo)*ScaleFactor));
            end;
      end;
      end;

    end;
      GridTav := GridTav * 10;
    end;
  end;
except
  exit;
end;
finally
  Canvas.CopyRect(R,Bmp.Canvas,R);
  painting:= False;
end;
end;

end.
