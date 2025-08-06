(*
   TStRuler    : Delphi 5 component
   Author      : Agócs László StellaSOFT 2005
   Notes       : A ruler component for grafical and text
                 windowed controls usage
   Hungary     : Vonalzó komponens mm,cm,dm,m,km skálával
*)

unit StRuler;

interface

uses
  Windows,Classes,SysUtils,Controls,StdCtrls,ExtCtrls,Graphics,Forms,
  StObjects, NewGeom, Szamok;

Type

  { Skála jellemzõk - Scale object for TStRuler}

  TScaleStyle = (ssLine, ssCircle, ssDot);
  TOrientation = (toHorizontal, toVertical);

  TScale = class(TPersistent)
  private
    FOnChange: TNotifyEvent;
    FFont : TFont;
    FFontVisible  : boolean;
    FVisible: boolean;
    FLength: integer;
    FColor: TColor;
    FPen: TPen;
    FStyle: TScaleStyle;
    fPixelsPerTick: double;          {Koord. tengelyek látszonak?}
    procedure Changed(Sender: TObject);
    procedure SetFontVisible(Value:boolean);
    procedure SetLength(const Value: integer);
    procedure SetStyle(const Value: TScaleStyle);
    procedure SetVisible(const Value: boolean);
    procedure SetFont(const Value: TFont);
  public
    constructor Create;
    destructor Destroy; override;
    property PixelsPerTick : double read fPixelsPerTick write fPixelsPerTick;
  published
    property Length : integer read FLength write SetLength default 4;
    property Font : TFont read FFont write SetFont;
    property FontVisible : boolean read FFontVisible write SetFontVisible default True;
    property Pen : TPen read FPen write FPen;
    property Style : TScaleStyle read FStyle write SetStyle;
    property Visible : boolean read FVisible write SetVisible default True;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  { Skálák jellemzõi - Scales object for TStRuler}

  TScales = class(TPersistent)
  private
    FOnChange: TNotifyEvent;
    fcm: TScale;
    fdm: TScale;
    fmm: TScale;
    fkm: TScale;
    fm: TScale;
    procedure Changed(Sender:TObject);
  public
    constructor Create;
    destructor Destroy; override;
  published
    property mm      : TScale read fmm write fmm;
    property cm      : TScale read fcm write fcm;
    property dm      : TScale read fdm write fdm;
    property m       : TScale read fm write fm;
    property km      : TScale read fkm write fkm;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TStCustomRuler = class(TCustomPanel)
  private
    FOnChange: TNotifyEvent;
    fScales: TScales;
    FColor: TColor;
    fIntervall: T2DPoint;
    fOrientation: TOrientation;
    procedure Changed(Sender:TObject);
    procedure SetOrientation(const Value: TOrientation);
    procedure SetColor(const Value: TColor);
    procedure SetIntervall(const Value: T2DPoint);
    procedure Callibrate;
  protected
    BMP : TBitmap;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    property Color : TColor read FColor write SetColor default clBlack;
    property Scales : TScales read fScales write fScales;
    property Orientation : TOrientation read fOrientation write SetOrientation;
    property Intervall : T2DPoint read fIntervall write SetIntervall;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TStRuler = class(TStCustomRuler)
  published
    property Canvas;
    property Color;
    property Scales;
    property Orientation;
    property Intervall;
    property Align;
    property Anchors;
(*    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderStyle;
    property BorderWidth;*)
    property Hint;
    property ShowHint;
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

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('AL',[TStRuler]);
end;

{ TScale }

constructor TScale.Create;
begin
   inherited Create;
   fVisible := True;
   fColor   := clBlack;
   fLength  := 4;
   fFont    := TFont.Create;
   fFont.Onchange := Changed;
     With fFont do begin
        Name  := 'Tachoma';
        Color := clBlack;
        Size  := 8;
        Style := [];
     end;
   fFontVisible  := False;
   fPen          := TPen.Create;
   fPen.Onchange := Changed;
   With fPen do begin
     Width := 1;
     Color := clBlack;
   end;
   fStyle  := ssLine;
end;

destructor TScale.Destroy;
begin
   fPen.Free;
   fFont.Free;
   inherited Destroy;
end;

procedure TScale.Changed(Sender: TObject);
begin if Assigned(FOnChange) then FOnChange(Self); end;

procedure TScale.SetFontVisible(Value: boolean);
begin
  fFontVisible := Value;
  Changed(Self);
end;

procedure TScale.SetLength(const Value: integer);
begin
  FLength := Value;
  Changed(Self);
end;

procedure TScale.SetStyle(const Value: TScaleStyle);
begin
  FStyle := Value;
  Changed(Self);
end;

procedure TScale.SetVisible(const Value: boolean);
begin
  FVisible := Value;
  Changed(Self);
end;

procedure TScale.SetFont(const Value: TFont);
begin
  FFont := Value;
  Changed(Self);
end;

{ TScales }

constructor TScales.Create;
begin
  inherited Create;
  fmm  := TScale.Create;
  fcm  := TScale.Create;
  fdm  := TScale.Create;
  fm   := TScale.Create;
  fkm  := TScale.Create;
  fmm.OnChange := Changed;
  fcm.OnChange := Changed;
  fdm.OnChange := Changed;
  fm.OnChange  := Changed;
  fkm.OnChange := Changed;
end;

destructor TScales.Destroy;
begin
  inherited;
  fmm.Free;
  fcm.Free;
  fdm.Free;
  fm.Free;
  fkm.Free;
end;

procedure TScales.Changed(Sender:TObject);
begin
  if Assigned(FOnChange) then
     FOnChange(Self);
end;

{ TStCustomRuler }

constructor TStCustomRuler.Create(AOwner: TComponent);
begin
  inherited;
  BMP := TBitmap.Create;
  fScales := TScales.Create;
  fIntervall := T2DPoint.Create(Self,0,200);
  fIntervall.OnChange := Changed;
  fScales.OnChange := Changed;
  fOrientation := toHorizontal;
  Width   := 200;
  Height  := 28;
end;

destructor TStCustomRuler.Destroy;
begin
  fScales.Free;
  BMP.Free;
  inherited;
end;

procedure TStCustomRuler.Changed(Sender:TObject);
begin
  if Sender is T2DPoint then SetIntervall(Sender as T2DPoint);
  invalidate;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TStCustomRuler.SetColor(const Value: TColor);
begin
  FColor := Value;
  BMP.Canvas.Brush.Color := Value;
  invalidate;
end;

procedure TStCustomRuler.SetIntervall(const Value: T2DPoint);
begin
  fIntervall := Value;
  invalidate;
end;

procedure TStCustomRuler.SetOrientation(const Value: TOrientation);
var w,h: integer;
begin
  If fOrientation <> Value then begin
     fOrientation := Value;
     w:=Width; h:=Height;
     Width:=h; Height:=w;
     invalidate;
  end;
end;

procedure TStCustomRuler.Callibrate;
// beosztások távolságát határozza meg
begin
  With fScales do begin
    mm.PixelsPerTick := width / (fIntervall.y-fIntervall.x);
    cm.PixelsPerTick := 10*mm.PixelsPerTick;
    dm.PixelsPerTick := 10*cm.PixelsPerTick;
    m.PixelsPerTick  := 10*dm.PixelsPerTick;
    km.PixelsPerTick := 1000*m.PixelsPerTick;
  end;
end;

procedure TStCustomRuler.Paint;
var R: TRect;
(*
    procedure ScaleDraw(Ca:TCanvas;Scale:TScale;mm:integer);
    Var kk: double;
        k: integer;
        sz: integer;
        s: string;
    begin
    If Scale.PixelsPerTick>3 then begin
    sz:=Trunc(Intervall.x);
    kk:=-Frac(Intervall.x/mm)*Scale.PixelsPerTick;
    Ca.Pen.Assign(Scale.Pen);
    Ca.Font.Assign(Scale.Font);
    Repeat
       k:=Round(kk);
       Ca.MoveTo(k,Height);Ca.LineTo(k,Height-Scale.Length);
       If Scale.PixelsPerTick>20 then begin
          s:=Inttostr(sz);
          Ca.TextOut(k-(Ca.TextWidth(s) div 2),0,s);
       end;
       kk := kk+Scale.PixelsPerTick;
       Inc(sz);
    Until kk>=Width;
    end;
    end;
*)

  procedure ScaleDraw(Ca:TCanvas);
  var
    kp,kp0: TPoint2d;
    tav,kpy,mar,marx,mary: extended;
    i: integer;
    GridTav : integer;     // Distance between lines
    sz: integer;
    Zoom : extended;
  begin
  GridTav := 1;
  Zoom    := Width/(Intervall.y-Intervall.x);
  With Ca do
  For i:=0 to 2 do begin
      tav  := (Width/(Intervall.y-Intervall.x)) * Gridtav;
      if tav>5 then begin

      Pen.Color := clSilver;
      Case GridTav of
      1:  begin
          Pen.Assign(Scales.mm.Pen);
          Font.Assign(Scales.mm.Font);
          end;
      10: begin
          Pen.Assign(Scales.cm.Pen);
          Font.Assign(Scales.cm.Font);
          end;
      100:Begin
          Pen.Assign(Scales.dm.Pen);
          Font.Assign(Scales.dm.Font);
          end;
      end;

      marx := -Maradek(Intervall.x,GridTav);
      mary := -Maradek(Intervall.y,GridTav);
      kp.x := tav*marx;
      kp.y := tav*mary; kp0:=kp;

//      if Grid.Style=gsLine then begin
      While kp.x<=Width do begin
            MoveTo(Round(kp.x),Height);
            LineTo(Round(kp.x),Height-(8*(i+1)));
            if (tav>20) and (GridTav>1) then begin
               TextOut(Trunc(kp.x),0,Inttostr(Round(Intervall.x + kp.x / Zoom)));
            end;
            kp.x:=kp.x+tav;
      end;
(*      While kp.y<=Height do begin
            MoveTo(0,Height-Trunc(kp.y));
            LineTo(Width,Height-Trunc(kp.y));
            kp.y:=kp.y+tav;
      end;*)
      end;

    GridTav := GridTav * 10;

  end;
  end;

begin
  try
    Callibrate;
    R := ClientRect;
    BMP.Width := Width;
    BMP.Height := Height;

  With BMP.Canvas do begin
    FillRect(R);

    { skálák rajzolása }
    ScaleDraw(BMP.Canvas);
(*    ScaleDraw(BMP.Canvas,Scales.mm,1);
    ScaleDraw(BMP.Canvas,Scales.cm,10);
    ScaleDraw(BMP.Canvas,Scales.dm,100);
    ScaleDraw(BMP.Canvas,Scales.m,1000);
    ScaleDraw(BMP.Canvas,Scales.km,1000000);*)

  end;

  finally
    Canvas.CopyRect(R,Bmp.Canvas,R);
  end;
end;

end.
