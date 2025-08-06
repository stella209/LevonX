unit Orapan;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls;

type

  Toratipus = (otUres,otDatumIdo,otDatum,otIdo);

  TOraPanel = class(TPanel)
  private
    FTimer  : TTimer;
    Foratipus : Toratipus;
  protected
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure Timer(Sender : TObject);
  published
    Property Align;
    property OraTipus : Toratipus read Foratipus write Foratipus
             default otDatumIdo;
    Property OnDblClick;
    Property OnMouseDown;
    Property OnMouseMove;
    Property OnMouseUp;
  end;

//procedure Register;

implementation
(*
procedure Register;
begin
  RegisterComponents('AL', [TOraPanel]);
end;
*)
constructor TOraPanel.Create(AOwner:TComponent);
begin
     inherited Create(AOwner);
     FTimer:=TTimer.Create(Self);
     FTimer.OnTimer := Timer;
     Ftimer.Interval:=1000;
     Oratipus := otDatumIdo;
end;

destructor TOraPanel.Destroy;
begin
     FTimer.Free;
     inherited Destroy;
end;

procedure TOraPanel.Timer;
begin
  Case Oratipus of
  otUres     : Caption:='';
  otDatumIdo : Caption:=FormatDateTime('yyyy.mmm.dd   hh:mm:ss',now);
  otDatum    : Caption:=FormatDateTime('yyyy.mmm.dd',now);
  otIdo      : Caption:=FormatDateTime('hh:mm:ss',now);
  end;
end;

end.
