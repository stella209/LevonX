(*
  TALBrushStyleCombo - Delphi 5 component

  Egy módosított ComboBox az ecsetfajták kiválasztásához
  (TBrushStyle) a Canvas rajzfelületekhez

  Agócs László - 2004.

*)
unit AL_BrushStyle;

interface

Uses
    Windows, SysUtils, Classes, Graphics, Controls, StdCtrls;

Type
  TALBrushStyleCombo = class(TCustomComboBox)
  private
    fBrushStyle: TBrushStyle;
  protected
    procedure CreateWnd; override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure Click; override;
  public
    constructor Create(AOwner:TComponent);override;
  published
    Property BrushStyle: TBrushStyle read fBrushStyle write fBrushStyle;
    Property OnChange;
  end;

procedure Register;

implementation

//{$R AL_BrushStyle.dcr}

procedure Register;
begin
  RegisterComponents('AL',[TALBrushStyleCombo]);
end;

constructor TALBrushStyleCombo.Create(AOwner: TComponent);
begin
  inherited;
  Style := csOwnerDrawFixed;
  Width := 40;
end;

procedure TALBrushStyleCombo.CreateWnd;
var i: integer;
begin
  inherited CreateWnd;
  For i:=0 to 7 do Items.Add('');
  fBrushStyle := bsSolid;
  With Canvas do begin
    Pen.Mode := pmCopy;
    Pen.Color := clBlack;
    Brush.Color := clWhite;
  end;
end;

procedure TALBrushStyleCombo.DrawItem(Index: Integer; Rect: TRect;
    State: TOwnerDrawState);
VAR r : TRect;
begin
  With Canvas do begin
    Brush.Style := TBrushStyle(Index);
    r := Classes.Rect(Rect.Left+2,Rect.Top+2,Rect.Right-2,Rect.Bottom-2);
    Rectangle(r.left,r.top,r.Right,r.Bottom);
    InflateRect(r, -1, -1);
    FillRect(r);
    InvertRect(Canvas.Handle,r);
  end;
end;

procedure TALBrushStyleCombo.Click;
begin
  if ItemIndex >= 0 then
    fBrushStyle := TBrushStyle(ItemIndex);
  inherited Click;
end;

end.

