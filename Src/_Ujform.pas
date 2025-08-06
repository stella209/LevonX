unit _Ujform;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  janLanguage;

type
  TUjForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ColorDialog: TColorDialog;
    Edit1: TEdit;
    Edit2: TEdit;
    Shape1: TShape;
    KepCheck: TCheckBox;
    RadioGroup1: TRadioGroup;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    GroupBox1: TGroupBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    janLanguage1: TjanLanguage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    cim : string;
    oldLanguage: string;
    FPictureWidth: integer;
    FPictureColor: integer;
    FPictureStay: boolean;
    FPictureHeight: integer;
    { Private declarations }
  public
    property PictureWidth  : integer read FPictureWidth write FPictureWidth;
    property PictureHeight : integer read FPictureHeight write FPictureHeight;
    property PictureColor  : integer read FPictureColor write FPictureColor;
    property PictureStay   : boolean read FPictureStay write FPictureStay;
  end;

var
  UjForm: TUjForm;

implementation

{$R *.dfm}

procedure TUjForm.BitBtn2Click(Sender: TObject);
begin
  if TWincontrol(Sender).Focused then
      ModalResult := mrOk;
end;

procedure TUjForm.FormActivate(Sender: TObject);
begin
  if oldLanguage <> janLanguage1.GetLang then begin
     janLanguage1.InitLanguage(Self);
     oldLanguage := janLanguage1.LanguageFile;
  end;
  Edit1.Text  := IntToStr(PictureWidth);
  Edit2.Text  := IntToStr(PictureHeight);
  Caption     := cim + ' ' + Edit1.Text +' x '+Edit2.Text;
  Shape1.Brush.Color := PictureColor;
  Edit1.SelectAll;
  Edit1.SetFocus;
end;

procedure TUjForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult=mrOk then begin
     Self.PictureWidth  := StrToInt(Edit1.Text);
     Self.PictureHeight := StrToInt(Edit2.Text);
     Self.PictureColor  := Shape1.Brush.Color;
     Self.PictureStay   := KepCheck.Checked;
  end;
end;

procedure TUjForm.FormCreate(Sender: TObject);
begin
  cim := Caption;
  janLanguage1.InitLanguage(Self);
  oldLanguage := janLanguage1.LanguageFile;
end;

procedure TUjForm.Shape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ColorDialog.Execute then
     Shape1.Brush.Color := ColorDialog.Color;
end;

procedure TUjForm.SpeedButton1Click(Sender: TObject);
begin
  Edit1.Text := inttostr(2*strtoint(Edit1.Text));
end;

procedure TUjForm.SpeedButton2Click(Sender: TObject);
begin
  Edit2.Text := inttostr(2*strtoint(Edit2.Text));
end;

end.
