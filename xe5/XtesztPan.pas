unit XtesztPan;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.ExtCtrls;

type
  TtestPanel = class(TCustomPanel)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TtestPanel]);
end;

{ TtestPanel }

constructor TtestPanel.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'teszt';
end;

end.
