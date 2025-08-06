unit _Maszk;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  STAF_Imp, Vcl.ComCtrls, AL_ZoomImg, Vcl.Samples.Spin, janLanguage, Vcl.ExtDlgs,
  RzButton, ClipBrd;

type
  TMaszMethod = (mamUnsharp, mamIntensity);

  TMaszkForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Bevel1: TBevel;
    SpeedButton7: TSpeedButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel3: TPanel;
    Label1: TLabel;
    tbBlur: TTrackBar;
    ParLabel: TLabel;
    Button1: TButton;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Button2: TButton;
    Label4: TLabel;
    NSpin: TSpinEdit;
    janLanguage1: TjanLanguage;
    OD: TOpenPictureDialog;
    Panel5: TPanel;
    PosPanel: TPanel;
    ALZ: TALZoomImage;
    TrackBar1: TTrackBar;
    MixLabel: TLabel;
    SpeedButton3: TSpeedButton;
    Button3: TButton;
    SpeedButton4: TSpeedButton;
    RzToolButton1: TRzToolButton;
    RzToolButton2: TRzToolButton;
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure tbBlurChange(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure RzToolButton1Click(Sender: TObject);
    procedure RzToolButton2Click(Sender: TObject);
  private
    oldLanguage: string;
    FMaszMethod: TMaszMethod;
  public
    Changed : boolean;
    oldPosition: integer;
    function Execute(inBitmap: TBitmap): boolean;
    property MaszMethod: TMaszMethod read FMaszMethod write FMaszMethod;
  end;

var
  MaszkForm: TMaszkForm;

implementation

{$R *.dfm}

uses Main_Levon;

{ TMaszkForm }
(*
procedure UnsharpMasking(bmOrig,bmBlured: TBitmap; N: integer);
// A bmOrig n-szeresébõl kivonjuk a bmBlured (n-1)-szeresét
var
   H,V : Integer;
   WskO: ^Byte;
   WskB: ^Byte;
begin
  bmOrig.PixelFormat  := pf24bit;
  bmBlured.PixelFormat:= pf24bit;
  for V:=0 to bmOrig.Height-1 do
  begin
    WskO:=bmOrig.ScanLine[V];
    WskB:=bmBlured.ScanLine[V];
    for H:=0 to bmOrig.Width*3-1 do
    begin
         WskO^:=IntToByte( N*WskO^ - (N-1)*WskB^ );
         inc(WskO);
         inc(WskB);
    end;
  end;
end;
*)

function TMaszkForm.Execute(inBitmap: TBitmap): boolean;
begin
Try
     Result := False;
     Changed := False;
     ALZ.OrigBMP.Assign(inBitmap);
     ALZ.RestoreOriginal;
     ALZ.Fitting := False;
     ParLabel.Caption := IntToStr(tbBlur.Position);
     PosPanel.Visible := False;
     ShowModal;
     if Changed then
     if Modalresult=mrOk then begin
        inBitmap.Assign(ALZ.WorkBMP);
        Result := True;
     end;
except
end;
end;

procedure TMaszkForm.FormActivate(Sender: TObject);
begin
  if oldLanguage <> janLanguage1.GetLang then begin
     janLanguage1.InitLanguage(Self);
     oldLanguage := janLanguage1.LanguageFile;
  end;
end;

procedure TMaszkForm.FormCreate(Sender: TObject);
begin
  oldLanguage := 'Language.lng';
  janLanguage1.InitLanguage(Self);
  oldLanguage := janLanguage1.LanguageFile;
  oldPosition:=128;
end;

procedure TMaszkForm.RzToolButton1Click(Sender: TObject);
begin
  if Clipboard.HasFormat(CF_PICTURE) then begin
     Image1.Picture.Bitmap.Assign(Clipboard);
  end;
end;

procedure TMaszkForm.RzToolButton2Click(Sender: TObject);
begin
  if Clipboard.HasFormat(CF_PICTURE) then begin
     Image2.Picture.Bitmap.Assign(Clipboard);
  end;
end;

procedure TMaszkForm.SpeedButton1Click(Sender: TObject);
begin
  if OD.Execute then begin
     case TComponent(Sender).Tag of
     1: LoadWICImage(OD.FileName,Image1.Picture.Bitmap);
     2: LoadWICImage(OD.FileName,Image2.Picture.Bitmap);
     end;
  end;
end;

procedure TMaszkForm.SpeedButton3Click(Sender: TObject);
begin
  PosPanel.Visible := False;
  ALZ.RestoreOriginal;
end;

procedure TMaszkForm.SpeedButton4Click(Sender: TObject);
begin
  ALZ.FitToScreen;
end;

procedure TMaszkForm.SpeedButton7Click(Sender: TObject);
begin
   ALZ.RestoreOriginal;
end;

procedure TMaszkForm.tbBlurChange(Sender: TObject);
begin
  ParLabel.Caption := IntToStr(tbBlur.Position);
end;

procedure TMaszkForm.TrackBar1Change(Sender: TObject);
begin
   MixLabel.Caption := Inttostr(TrackBar1.Position)+'%';
   TrackBar1.Update;
   Opaque(Image1.Picture.Bitmap,Image2.Picture.Bitmap,ALZ.WorkBMP,TrackBar1.Position);
   ALZ.ReDraw;
end;

procedure TMaszkForm.BitBtn2Click(Sender: TObject);
begin
  if TWincontrol(Sender).Focused then begin
      ModalResult := mrOk;
      Changed := True;
  end;
end;

procedure TMaszkForm.Button1Click(Sender: TObject);
var bm: TBitmap;
begin
Try
   bm := TBitmap.Create;
   Screen.Cursor := crHourGlass;
   bm.Assign(ALZ.WorkBMP);
   GaussianBlur( bm, tbBlur.Position );
   UnsharpMasking( ALZ.WorkBMP, bm, NSpin.Value );
   ALZ.ReDraw;
Finally
   bm.FreeImage;
   bm.Free;
   Screen.Cursor := crDefault;
End;
end;


procedure TMaszkForm.Button2Click(Sender: TObject);
begin
  PosPanel.Visible := True;
  TrackBar1Change(Sender);
end;

procedure TMaszkForm.Button3Click(Sender: TObject);
begin
  BMPResize(Image1.Picture.Bitmap,Image1.width,Image1.Height,clSilver);
  Image1.Update;
  BMPResize(Image2.Picture.Bitmap,Image2.width,Image2.Height,clSilver);
  Image2.Update;
  PosPanel.Visible := False;
  ALZ.RestoreOriginal;
end;

end.
