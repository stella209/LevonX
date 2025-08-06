unit Al_TSpeedButton;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, extctrls, Buttons;

Type

  TALTimerSpeedButton = class(TSpeedButton)
  private
    ora : TTimer;
    FInterval: integer;
    fOnTimerEvent: TNotifyEvent;
    fTimerEneble: boolean;
    procedure TimerEvent(Sender: TObject);
    procedure SetInterval(const Value: integer);
  protected
    TEnable : boolean;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Interval: integer read FInterval write SetInterval;
    property TimerEneble: boolean read fTimerEneble write fTimerEneble;
    property OnTimerEvent: TNotifyEvent read fOnTimerEvent write fOnTimerEvent;
  end;

//  procedure Register;

implementation
(*
procedure Register;
begin
  RegisterComponents('AL',[TALTimerSpeedButton]);
end;
*)
{TTimerSpeedButton}

constructor TAlTimerSpeedButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ora := TTimer.Create(Self);
  ora.OnTimer  := TimerEvent;
  fInterval := 1;
  fTimerEneble := True;
end;

destructor TAlTimerSpeedButton.Destroy;
begin
  if ora <> nil then
    ora.Free;
  inherited Destroy;
end;

procedure TALTimerSpeedButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown (Button, Shift, X, Y);
  ora.Interval := fInterval;
  TEnable := True;
end;

procedure TALTimerSpeedButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
                                  X, Y: Integer);
begin
  inherited MouseUp (Button, Shift, X, Y);
  TEnable := False;
end;

procedure TALTimerSpeedButton.SetInterval(const Value: integer);
begin
  FInterval := Value;
  if ora <> nil then begin
    ora.Interval := fInterval;
  end;
end;

procedure TALTimerSpeedButton.TimerEvent(Sender: TObject);
begin
  If TimerEneble then
  If TEnable and Assigned(fOnTimerEvent) then fOnTimerEvent(Self);
end;

end.
