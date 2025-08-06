unit _Ujform;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  janLanguage, Vcl.Samples.Spin;

type
  TUjForm = class(TForm)
    GroupBox1: TGroupBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    janLanguage1: TjanLanguage;
    Panel1: TPanel;
    Panel2: TPanel;
    KepCheck: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Shape1: TShape;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Edit1: TEdit;
    Edit2: TEdit;
    ColorDialog: TColorDialog;
    Panel3: TPanel;
    Panel4: TPanel;
    Label4: TLabel;
    SpinEdit1: TSpinEdit;
    cbKeret: TCheckBox;
    Label5: TLabel;
    Shape2: TShape;
    Label6: TLabel;
    SpinEdit2: TSpinEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Panel5: TPanel;
    wImage: TImage;
    Button1: TButton;
    Panel6: TPanel;
    CheckBox1: TCheckBox;
    Button2: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
  private
    cim : string;
    oldLanguage: string;
    FPictureWidth: integer;
    FPictureColor: integer;
    FPictureStay: boolean;
    FPictureHeight: integer;
    FDataWidth: integer;
    FFrameWidth: integer;
    FImageHeight: integer;
    FImageWidth: integer;
    FZoom: double;
    FDataDown: boolean;
    FFrameColor: integer;
    procedure DrawView;
    { Private declarations }
  public
    property Zoom          : double  read FZoom write FZoom;
    property ImageWidth    : integer read FImageWidth write FImageWidth;
    property ImageHeight   : integer read FImageHeight write FImageHeight;
    property PictureWidth  : integer read FPictureWidth write FPictureWidth;
    property PictureHeight : integer read FPictureHeight write FPictureHeight;
    property PictureColor  : integer read FPictureColor write FPictureColor;
    property PictureStay   : boolean read FPictureStay write FPictureStay;
    property FrameWidth    : integer read FFrameWidth write FFrameWidth;
    property FrameColor    : integer read FFrameColor write FFrameColor;
    property DataWidth     : integer read FDataWidth write FDataWidth;
    property DataDown      : boolean read FDataDown write FDataDown;
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
  FDataDown := True;
end;

procedure TUjForm.RadioButton1Click(Sender: TObject);
begin
  DataDown := True;
end;

procedure TUjForm.RadioButton2Click(Sender: TObject);
begin
  DataDown := False;
end;

procedure TUjForm.Shape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ColorDialog.Execute then begin
     TShape(Sender).Brush.Color := ColorDialog.Color;
     PictureColor := Shape1.Brush.Color;
     FrameColor   := Shape2.Brush.Color;
  end;
end;

procedure TUjForm.SpeedButton1Click(Sender: TObject);
begin
  Edit1.Text := inttostr(2*strtoint(Edit1.Text));
end;

procedure TUjForm.SpeedButton2Click(Sender: TObject);
begin
  Edit2.Text := inttostr(2*strtoint(Edit2.Text));
end;

// A rajzlapon megmutatja a látványtervet
procedure TUjForm.Button2Click(Sender: TObject);
begin
  DrawView;
end;

procedure TUjForm.DrawView;
var w0,h0 : integer;   // Canvas original sizes
    w,h   : integer;   // Canvas on the view
    R     : TRect;
begin
    Zoom := 1.0;
    w0 := PictureWidth + FrameWidth;
    h0 := PictureHeight + FrameWidth + DataWidth;
    if w0 > wImage.Width then
       Zoom := wImage.Width / w0;
    if Zoom * h0 > wImage.Height then
       Zoom := wImage.Height / (Zoom * h0);
    w := Trunc( Zoom * w0 );
    h := Trunc( Zoom * h0 );
    R.Left  := Trunc((wImage.Width-w)/2);
    R.Top   := Trunc((wImage.Height-h)/2);
    R.Right := Trunc((wImage.Width+w)/2);
    R.Bottom:= Trunc((wImage.Height+h)/2);
    // Kép megrajzolása
    with wImage.Canvas do begin
      Brush.Color := clWhite;
      FillRect(Cliprect);
      Brush.Color := PictureColor;
      FillRect(R);
    end;
end;

end.
