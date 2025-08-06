unit _FixTerDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Samples.Spin, janLanguage;

type
  TFixTerForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    janLanguage1: TjanLanguage;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    oldLanguage: string;
    FFixWidth: integer;
    FFixHeight: integer;
  public
    function Execute: boolean;
    property FixWidth  : integer read FFixWidth write FFixWidth;
    property FixHeight : integer read FFixHeight write FFixHeight;
  end;

var
  FixTerForm: TFixTerForm;

implementation

{$R *.dfm}

{ TFixTerForm }

function TFixTerForm.Execute: boolean;
begin
  SpinEdit1.Value := FFixWidth;
  SpinEdit2.Value := FFixHeight;
  Showmodal;
  Result := Modalresult = mrOk;
  if Result then begin
     FFixWidth  := SpinEdit1.Value;
     FFixHeight := SpinEdit2.Value;
  end;
end;

procedure TFixTerForm.FormActivate(Sender: TObject);
begin
  if oldLanguage <> janLanguage1.GetLang then begin
     janLanguage1.InitLanguage(Self);
     oldLanguage := janLanguage1.LanguageFile;
  end;
end;

procedure TFixTerForm.FormCreate(Sender: TObject);
begin
  FFixWidth  := 100;
  FFixHeight := 100;
  janLanguage1.InitLanguage(Self);
  oldLanguage := janLanguage1.LanguageFile;
end;

end.
