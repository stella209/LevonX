unit _FullScreen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AL_ZoomImg;

type
  TFullForm = class(TForm)
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FullForm: TFullForm;

implementation

{$R *.DFM}

uses Main_Levon;

procedure TFullForm.FormCreate(Sender: TObject);
begin
  Doublebuffered := True;
end;

procedure TFullForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_ESCAPE) or (Key=VK_F4) then begin
     Key:=0;
     close;
  end;
  if Key=VK_F12 then
     MainForm.StarVisible := not MainForm.StarVisible;
end;

end.
