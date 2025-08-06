unit _Konvol;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  AL_ZoomImg, STAF_Imp, NewGeom, Vcl.Samples.Spin, janLanguage;

type
  TKonvolForm = class(TForm)
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel2: TPanel;
    Button10: TButton;
    GroupBox2: TGroupBox;
    SpinEdit2: TSpinEdit;
    Button11: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    ComboBox1: TComboBox;
    ConvolvButton: TButton;
    Panel3: TPanel;
    Panel4: TPanel;
    ALZ: TALZoomImage;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Label2: TLabel;
    janLanguage1: TjanLanguage;
    SpeedButton4: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure ConvolvButtonClick(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    oldLanguage: string;
  public
    Mask : T3x3FloatArray;
    Bias : integer;
    function Execute(inBitmap: TBitmap;_cent: TPoint2d;_zoom: double): boolean;
    procedure DoZoom(_cent: TPoint2d;_zoom: double);
    procedure SetMask(a1, a2, a3, a4, a5, a6, a7, a8, a9 : Extended ; ABias : integer); overload;
    procedure SetMask(FilterIndex: integer); overload;
  end;

var
  KonvolForm: TKonvolForm;

implementation

{$R *.dfm}

procedure TKonvolForm.ComboBox1Select(Sender: TObject);
begin
  SetMask(ComboBox1.ItemIndex);
end;

procedure TKonvolForm.ConvolvButtonClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  Convolve(ALZ.WorkBMP, Mask, Bias);
  ALZ.ReDraw;
  Screen.Cursor := crDefault;
end;

procedure TKonvolForm.DoZoom(_cent: TPoint2d; _zoom: double);
begin
  ALZ.sCent := _cent;
  ALZ.Zoom  := _zoom;
  ALZ.ReDraw;
end;

procedure TKonvolForm.Edit1Change(Sender: TObject);
Var
  LTag : byte;
  LValue : Extended;
begin
  LTag := TEdit(Sender).Tag;

  if (TEdit(Sender).Text = '') or (TEdit(Sender).Text = '-')
    then LValue := 0
    else LValue := StrToFloat(TEdit(Sender).Text);

  if LTag = 9 then begin
    if (LValue > 255) or (Frac(LValue) <> 0) then begin
      ShowMessage('the bias has to be a whole number between -255 and 255');
      Exit;
    end;
    Bias := trunc(LValue);
    Exit;
  end;

  Mask[LTag mod 3, LTag div 3] := LValue;
end;

function TKonvolForm.Execute(inBitmap: TBitmap;_cent: TPoint2d;_zoom: double): boolean;
begin
Try
     Result := False;
     ALZ.OrigBMP.assign(inBitmap);
     ALZ.Fitting := False;
     ALZ.RestoreOriginal;
     DoZoom(_cent,_zoom);
     ShowModal;
     if Modalresult=mrOk then begin
        inBitmap.assign(ALZ.WorkBMP);
        Result := True;
     end;
except
end;
end;

procedure TKonvolForm.FormActivate(Sender: TObject);
begin
  if oldLanguage <> janLanguage1.GetLang then begin
     janLanguage1.InitLanguage(Self);
     oldLanguage := janLanguage1.LanguageFile;
  end;
end;

procedure TKonvolForm.FormCreate(Sender: TObject);
begin
  janLanguage1.InitLanguage(Self);
  oldLanguage := janLanguage1.LanguageFile;
  Edit1.Tag := 0; Edit2.Tag := 1; Edit3.Tag := 2;
  Edit4.Tag := 3; Edit5.Tag := 4; Edit6.Tag := 5;
  Edit7.Tag := 6; Edit8.Tag := 7; Edit9.Tag := 8;
  Edit10.Tag := 9; // bias

  SetMask(10);
(*
  SetMask(1, 1, 1,
          1, 1, 1,
          1, 1, 1, 0);*)
end;

procedure TKonvolForm.SetMask(a1, a2, a3, a4, a5, a6, a7, a8, a9: Extended;
  ABias: integer);
begin
  Edit1.Text := FloatToStr(a1);
  Edit2.Text := FloatToStr(a2);
  Edit3.Text := FloatToStr(a3);
  Edit4.Text := FloatToStr(a4);
  Edit5.Text := FloatToStr(a5);
  Edit6.Text := FloatToStr(a6);
  Edit7.Text := FloatToStr(a7);
  Edit8.Text := FloatToStr(a8);
  Edit9.Text := FloatToStr(a9);
  Edit10.Text := IntToStr(ABias);
end;

procedure TKonvolForm.SetMask(FilterIndex: integer);
begin
  case FilterIndex of
  0:
    SetMask(1, 1, 1,
            1, 1, 1,
            1, 1, 1, 0);
   1:
    SetMask(1/36, 1/9, 1/36,
            1/9,  4/9, 1/9,
            1/36, 1/9, 1/36, 0);
   2:
    SetMask(-1, -1, -1,
            -1,  8, -1,
            -1, -1, -1, 0);
   3:
    SetMask( 0,  0,  0,
            -1,  2, -1,
             0,  0,  0, 0);
   4:
    SetMask( 0, -1,  0,
             0,  2,  0,
             0, -1,  0, 0);
   5:
    SetMask( 0, -1,  0,
            -1,  9, -1,
             0, -1,  0, 0);
   6:
    SetMask(-1,  0, -1,
             0,  7,  0,
            -1,  0, -1, 0);
   7:
    SetMask(-1, -1,  0,
            -1,  0,  1,
             0,  1,  1, 128);
   8:
    SetMask( 0,  0,  0,
             0,  1,  0,
             0,  0,  0, 20);
   9:
    SetMask( 0,  0,  0,
             0,  1,  0,
             0,  0,  0, -20);
   10:       // Photometric LowPass
    SetMask( 0.0625,  0.125,  0.0625,
             0.125,   0.25,   0.125,
             0.0625,  0.125,  0.0625, 0);
  end;
end;

procedure TKonvolForm.SpeedButton1Click(Sender: TObject);
begin
     ALZ.RestoreOriginal;
end;

procedure TKonvolForm.SpeedButton2Click(Sender: TObject);
begin
     ALZ.OrigBMP.assign(ALZ.WorkBMP);
end;

procedure TKonvolForm.SpeedButton4Click(Sender: TObject);
begin
  ALZ.FitToScreen;
end;

procedure TKonvolForm.BitBtn2Click(Sender: TObject);
begin
  if TWincontrol(Sender).Focused then
      ModalResult := mrOk;
end;

procedure TKonvolForm.Button10Click(Sender: TObject);
begin
  ALZ.RestoreOriginal;
end;

function Threshold(ABitmap : TBitmap ; AThreshold : byte ;
                          Intensity,
                          Saturation,
                          Red,
                          Green,
                          Blue : boolean) : TBitmap;
Var
  LRowIn, LRowOut : PRGBTripleArray;
  Ly, Lx : integer;
  LBlack, LWhite : TRGBTriple;
  LR, LG, LB : byte;
  LR1, LR2 : integer;
begin

  Result := TBitmap.Create;
  Result.Width := ABitmap.Width;
  Result.Height := ABitmap.Height;
  Result.PixelFormat := pf24bit;

  LBlack.rgbtBlue := 0; LBlack.rgbtGreen := 0; LBlack.rgbtRed := 0;
  LWhite.rgbtBlue := 255; LWhite.rgbtGreen := 255; LWhite.rgbtRed := 255;

  for Ly := 0 to ABitmap.Height - 1 do begin
    LRowIn := ABitmap.ScanLine[Ly];
    LRowOut := Result.ScanLine[Ly];
    for Lx := 0 to ABitmap.Width - 1 do begin

      LR := LRowIn[Lx].rgbtRed;
      LG := LRowIn[Lx].rgbtGreen;
      LB := LRowIn[Lx].rgbtBlue;

      if Intensity then begin

        if (0.3  * LR) + (0.59 * LG) + (0.11 * LB) >= AThreshold
          then LRowOut[Lx] := LWhite
          else LRowOut[Lx] := LBlack;

      end else if Saturation then begin

        LR1 := trunc( (-0.105465 * LR) + (-0.207424 * LG) + (0.312889 * LB) );
        LR2 := trunc( (0.445942 * LR) + (-0.445942 * LG) );
        if Sqrt( Sqr(LR1) + Sqr(LR2) ) >= AThreshold
          then LRowOut[Lx] := LWhite
          else LRowOut[Lx] := LBlack;

      end else if Red then begin

        if LR >= AThreshold then LRowOut[Lx] := LWhite
                            else LRowOut[Lx] := LBlack;

      end else if Green then begin

        if LG >= AThreshold then LRowOut[Lx] := LWhite
                            else LRowOut[Lx] := LBlack;

      end else begin

        if LB >= AThreshold then LRowOut[Lx] := LWhite
                            else LRowOut[Lx] := LBlack;

      end;

    end;
  end;

end;

procedure TKonvolForm.Button11Click(Sender: TObject);
Var
  LThreshold : integer;
begin
  Screen.Cursor := crHourGlass;
  LThreshold := SpinEdit2.Value;
  if RadioButton2.Checked then LThreshold := trunc( LThreshold / 2 );

  ALZ.WorkBMP := Threshold(ALZ.WorkBMP, LThreshold,
                                     RadioButton1.Checked,
                                     RadioButton2.Checked,
                                     RadioButton3.Checked,
                                     RadioButton4.Checked,
                                     RadioButton5.Checked);
  ALZ.ReDraw;
  Screen.Cursor := crDefault;
end;

procedure TKonvolForm.Button1Click(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  ConvolveFilter(TComponent(Sender).Tag,0,ALZ.WorkBMP);
  ALZ.ReDraw;
  Screen.Cursor := crDefault;
end;

end.
