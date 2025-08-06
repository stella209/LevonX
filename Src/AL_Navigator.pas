unit AL_Navigator;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, Buttons, NewGeom;

type
  TNavButtons = (nvLeft,nvRight,nvUp,nvDown,nvTotal);
  TDirectChangeEvent = procedure(Sender: TObject; Button: integer) of object;

  TALNavigator = class(TCustomPanel)
  private
    FSize            : integer;
    FOnUp            : TDirectChangeEvent;
    FOnDown          : TDirectChangeEvent;
    FOnLeft          : TDirectChangeEvent;
    FOnRight         : TDirectChangeEvent;
    FOnTotal         : TDirectChangeEvent;
    FInterval: integer;
    procedure SetSize(Value:integer);
    procedure TimerEvent(Sender:TObject);
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure SetInterval(const Value: integer);
  protected
    w,h      : integer;
    FButtons : array[TNavButtons] of TSpeedButton;
    timer    : TTimer;
    procedure Resize; override;
    procedure BMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
    procedure BMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    ActiveButton : integer;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    Property Interval: integer read FInterval write SetInterval;
    Property Size: integer read FSize write SetSize default 80;
    Property OnUp: TDirectChangeEvent read FOnUp write FOnUp;
    Property OnDown: TDirectChangeEvent read FOnDown write FOnDown;
    Property OnLeft: TDirectChangeEvent read FOnLeft write FOnLeft;
    Property OnRight: TDirectChangeEvent read FOnRight write FOnRight;
    Property OnTotal: TDirectChangeEvent read FOnTotal write FOnTotal;
    property Align;
    Property BevelInner;
    Property BevelOuter;
    Property BevelWidth;
    Property BorderWidth;
    Property BorderStyle;
    Property Color;
    Property Ctl3D;
    Property ShowHint;
    Property Tag;
    Property Visible;
  end;

//procedure Register;

implementation

{$R AL_Navigator}

Const
  BtnTypeName : array[TNavButtons] of PChar = ('ALNAV_LEFT', 'ALNAV_RIGHT',
                 'ALNAV_UP','ALNAV_DOWN','ALNAV_TOTAL');
(*
procedure Register;
begin
     RegisterComponents('AL',[TALNavigator]);
end;
*)
constructor TALNavigator.Create(AOwner:TComponent);
var i:TNavButtons;
    ResName: array[0..40] of Char;
    j: integer;
begin
     inherited Create(AOwner);
     timer := TTimer.Create(Self);
     Interval := 10;
     timer.OnTimer := TimerEvent;
     j:=1;
     For i:=Low(FButtons) to High(FButtons) do begin
         FButtons[i]:=TSpeedButton.Create(Self);
         FButtons[i].Parent:=Self;
         FButtons[i].Tag:= j;
         FButtons[i].Caption := '';
         FButtons[i].Enabled := True;
         FButtons[i].Flat := True;
         FButtons[i].GroupIndex := 0;
         FButtons[i].AllowAllUp := True;
         FButtons[i].OnMouseDown := BMouseDown;
         FButtons[i].OnMouseUp := BMouseUp;
         FButtons[i].Glyph.Handle := LoadBitmap(HInstance,
             StrFmt(ResName, '%s', [BtnTypeName[I]]));
         FButtons[i].NumGlyphs := 1;
         Inc(j);
     end;
     Caption:='';
     Size:=40;
     ActiveButton := 0;
end;

procedure TALNavigator.TimerEvent;
begin
   Case ActiveButton of
   1: If Assigned(FOnLeft) then FOnLeft(Self,ActiveButton);
   2: If Assigned(FOnRight) then FOnRight(Self,ActiveButton);
   3: If Assigned(FOnUp) then FOnUp(Self,ActiveButton);
   4: If Assigned(FOnDown) then FOnDown(Self,ActiveButton);
   5: If Assigned(FOnTotal) then FOnTotal(Self,ActiveButton);
   end;
end;

destructor TALNavigator.Destroy;
var i: TNavButtons;
begin
  Timer.Free;
  For i:=Low(FButtons) to High(FButtons) do FButtons[i].Free;
  inherited Destroy;
end;

procedure TALNavigator.SetSize(Value:integer);
begin
     If Value>10 then FSize:=Value;
     SetBounds(Left,Top,FSize,FSize);
     Caption:='';
     Resize;
     Invalidate;
end;

procedure TALNavigator.WMSize(var Msg: TWMSize);
begin
    inherited;
    If Msg.Width > Msg.Height then FSize := Msg.Width;
    If Msg.Height> Msg.Width then FSize := Msg.Height;
    Size:=FSize;
    Resize;
    Invalidate;
end;

procedure TALNavigator.Resize;
var
    bw : integer;   {ButtonWidth/height}
    bs : integer;
begin
   if (csLoading in ComponentState) then Exit;
   bs:=BevelWidth+BorderWidth;
   If BevelInner<>bvNone then bs:=bs+BevelWidth;
   bw := (Size - 2*bs) div 3;
   FButtons[nvLeft].SetBounds(bs,bs+bw,bw,bw);
   FButtons[nvRight].SetBounds(bs+2*bw,bs+bw,bw,bw);
   FButtons[nvUp].SetBounds(bs+bw,bs,bw,bw);
   FButtons[nvDown].SetBounds(bs+bw,bs+2*bw,bw,bw);
   FButtons[nvTotal].SetBounds(bs+bw,bs+bw,bw,bw);
   FButtons[nvTotal].Hint:='Total';
   Invalidate;
   Inherited Resize;
end;

procedure TALNavigator.BMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
Var t : integer;
begin
   t := (Sender as TSpeedButton).Tag;
   Case t of
   1: If Assigned(FOnLeft) then FOnLeft(Self,t);
   2: If Assigned(FOnRight) then FOnRight(Self,t);
   3: If Assigned(FOnUp) then FOnUp(Self,t);
   4: If Assigned(FOnDown) then FOnDown(Self,t);
   5: If Assigned(FOnTotal) then FOnTotal(Self,t);
   end;
   ActiveButton := t;
end;

procedure TALNavigator.BMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
    X,Y: Integer);
begin
   ActiveButton := 0;
end;

procedure TALNavigator.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
end;

procedure TALNavigator.SetInterval(const Value: integer);
begin
  if FInterval <> Value then begin
     FInterval := Value;
     timer.Interval:=Value;
  end;
end;

end.
