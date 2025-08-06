unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AL_ZoomImg, STAF_Imp, ComCtrls, ExtCtrls, ExtDlgs, Buttons,
  StObjects;

Const PixelMax = 6000;

type
   pPixelArray = ^TPixelArray;
   TPixelArray = Array[0..PixelMax-1] Of TRGBTriple;

   TRGB24 = record B, G, R: Byte; end;

   TRGBColorsArray  = Array[0..2,0..255] of Cardinal; // RGB szinek tömbje for histogram

   TRGBStatisticArray = Array[0..2,0..255] of double; // RGB szinek tömbje for statistic (%)

   // Színcsatornák korrekciója: alapesetben minden érték = 1
   //                            <1 csökkenti; >1 növeli a színcsatorna értékét
   TRGBParam = record
      RParam : double;
      GParam : double;
      BParam : double;
   end;

  TMainForm = class(TForm)
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    Button1: TButton;
    Button2: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel2: TPanel;
    ALZ: TALZoomImage;
    Memo1: TMemo;
    Button3: TButton;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    Label1: TLabel;
    ParLabel: TLabel;
    Button5: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Button4: TButton;
    Button6: TButton;
    Bevel1: TBevel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    OpenDialog: TOpenDialog;
    MonoButton: TSpeedButton;
    Button7: TButton;
    Button8: TButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Button9: TButton;
    SaveDialog: TSaveDialog;
    Button10: TButton;
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ALZChangeWindow(Sender: TObject; xCent, yCent, xWorld,
      yWorld, Zoom: Double; MouseX, MouseY: Integer);
    procedure Button3Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button6Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure MonoButtonClick(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
  private
    UR : TUndoRedo;
    FParam: double;
    FpicFile: string;
    procedure SetParam(const Value: double);
    procedure UndoSave(var MemSt:TMemoryStream);
    procedure UndoRedo(MemSt:TMemoryStream);
    procedure OnUndoRedo(Sender:TObject; Undo,Redo:boolean);
    procedure SetpicFile(const Value: string);
  public
    property Param: double read FParam write SetParam;
    property picFile: string read FpicFile write SetpicFile;
  end;

var
  MainForm: TMainForm;
  elso : boolean = True;
  ExeDir: string;

function LoadImageFromFile(const FileName: string; Bmp: TBitmap): Boolean;

function IntToByte(i:Integer):Byte;
function FloatToByte(i:double):Byte;
function HistogramInit: TRGBColorsArray;
function RGBStatisticInit: TRGBStatisticArray;
function GetRGBHistogram(Bitmap: TBitmap): TRGBColorsArray;
function GetRGBStatistic(Bitmap: TBitmap): TRGBStatisticArray;
function GetRGBStatisticMax(Bitmap: TBitmap): TRGB24;
procedure AutoNoiseReduction(Bitmap: TBitmap; factor: DOUBLE; RGBParam: TRGBParam);

implementation

{$R *.DFM}

uses Histog1, _SKALAZ;

function LoadImageFromFile(const FileName: string; Bmp: TBitmap): Boolean;
var
  W: TWICImage;
begin
  Screen.Cursor := crHourGlass;
  W:= TWicImage.Create;
  try
    Try
      W.LoadFromFile(FileName);
    Except
      W.LoadFromFile(FileName);
    End;
    if Bmp=nil then
    Bmp:= TBitmap.Create;
    Bmp.Assign(W);
  finally
    W.Free;
    Screen.Cursor := crDefault;
  end;
end;

// ============= LEVONÓ RUTINOK =======================================

function IntToByte(i:Integer):Byte;
begin
  if i > 255 then
    Result := 255
  else if i < 0 then
    Result := 0
  else
    Result := i;
end;

function FloatToByte(i:double):Byte;
begin
  Result := IntToByte(Round(i));
end;

function HistogramInit: TRGBColorsArray;
var i,j: integer;
begin
  For i:=0 to 2 do
   For j:=0 to 255 do
    Result[i,j] := 0; // RGB szinek tömbjét 0-ázza
end;

function RGBStatisticInit: TRGBStatisticArray;
var i,j: integer;
begin
  FOR j := 0 TO 2 DO
    FOR i := 0 TO 255 DO
        Result[j,i] := 0;
end;

function GetRGBHistogram(Bitmap: TBitmap): TRGBColorsArray;
VAR
  i  :  INTEGER;
  j  :  INTEGER;
  Row:  pPixelArray;
begin
TRY
  Result := HistogramInit;
  Bitmap.PixelFormat := pf24bit;
  FOR j := 0 TO Bitmap.Height-1 DO
  BEGIN
    Row := Bitmap.Scanline[j];
    FOR i := 0 TO Bitmap.Width-1 DO
      WITH Row[i] DO
      BEGIN
        Inc(Result[0,rgbtRed]);
        Inc(Result[1,rgbtGreen]);
        Inc(Result[2,rgbtBlue]);
      END
  END;
FINALLY
END
end;

// Megnézi hogy a kép pixeleinek RGB maximuma, mely intenzitásértékeknél van.
// Kigyüjti a kép pixeleinek RGB statisztikáját %-os eloszlásban
function GetRGBStatistic(Bitmap: TBitmap): TRGBStatisticArray;
VAR
  i  :  INTEGER;
  j  :  INTEGER;
  Row:  pPixelArray;
  pixCount : integer;
  RGBColorsArray : TRGBColorsArray;
begin
TRY
  pixCount := Bitmap.Width * Bitmap.Height;
  if PixCount>0 then begin
  RGBColorsArray := GetRGBHistogram(Bitmap);
  FOR j := 0 TO 2 DO
    FOR i := 0 TO 255 DO
        Result[j,i] := 100*RGBColorsArray[j,i]/pixCount;
  end else
        Result := RGBStatisticInit;
FINALLY
END
end;

// Valószínûleg ez adja az alapzaj szintjeit.
function GetRGBStatisticMax(Bitmap: TBitmap): TRGB24;
Var
  Colors  : TRGBStatisticArray;
  i,j     : integer;
  MaxArr  : array[0..2] of integer;
  maxCol  : double;
begin
  Colors := GetRGBStatistic(Bitmap);
  For i:=0 to 2 do begin
   MaxArr[i]:=0;
   maxCol   :=0;
   For j:=5 to 255 do begin
       if Colors[i,j]>MaxCol then begin
          maxCol := Colors[i,j];
          MaxArr[i]:=j;
       end;
   end;
  end;
  With Result do begin
       R := MaxArr[0];
       G := MaxArr[1];
       B := MaxArr[2];
  end;
end;

procedure AutoNoiseReduction(Bitmap: TBitmap; factor: DOUBLE; RGBParam: TRGBParam);
var avgTres  : TRGB24;
    Row      : pRGBTripleArray;
    Rfactor,Gfactor,Bfactor: double;
    x,y      : integer;
begin
  // Meghaározzuk az átlagos RGB zaj szintet
  //  factor:=3; ÉRTÉKNÉL JÓ EREDMÉNY VÁRHATÓ
  avgTres := GetRGBStatisticMax(Bitmap);
  Rfactor := RGBParam.RParam * factor*(1+avgTres.R/255);
  Gfactor := RGBParam.GParam * factor*(1+avgTres.G/255);
  Bfactor := RGBParam.BParam * factor*(1+avgTres.B/255);
  // Az ez alatti zajt eltávolítjuk, levágjuk, majd visszaszorozzuk
  Bitmap.PixelFormat := pf24bit;
  for y:=0 to Bitmap.height-1 do begin
    Row:=Bitmap.scanline[y];
    for x:=0 to Bitmap.width-1 do begin
      WITH Row[x] DO
      BEGIN
        rgbtRed   := FloatToByte(Rfactor * (rgbtRed - avgTres.R));
        rgbtGreen := FloatToByte(Gfactor * (rgbtGreen - avgTres.G));
        rgbtBlue  := FloatToByte(Bfactor * (rgbtBlue - avgTres.B));
      END;
    end;
  end;
end;

// ============= END LEVONÓ RUTINOK =======================================

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FormatSettings.DecimalSeparator := '.';
  UR := TUndoRedo.Create;
  UR.UndoSaveProcedure := UndoSave;
  UR.UndoRedoProcedure := UndoRedo;
  UR.OnUndoRedo := OnUndoRedo;
  UR.UndoLimit:=10;
  UR.UndoInit;
  if FileExists(ExeDir+'Levon.txt') then
     Memo1.Lines.LoadFromFile(ExeDir+'Levon.txt')
  else
     Memo1.Lines.Add('A leíró fájl nem található. De okos fickó vagy: rá fogsz jönni!');
  Param := 5.0;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  UR.Destroy;
end;

procedure TMainForm.SetParam(const Value: double);
begin
  FParam := Value;
  ParLabel.Caption := Format('%6.1f',[Value]);
end;

procedure TMainForm.SetpicFile(const Value: string);
begin
  FpicFile := Value;
  StatusBar1.Panels[3].Text := Value;
end;

procedure TMainForm.TrackBar1Change(Sender: TObject);
begin
  Param := TrackBar1.Position+TrackBar2.Position/10;
end;

procedure TMainForm.UndoRedo(MemSt: TMemoryStream);
begin
  ALZ.LoadFromStream(MemSt,itBMP);
end;

procedure TMainForm.UndoSave(var MemSt: TMemoryStream);
begin
  ALZ.SaveToStream(MemSt,itBMP);
end;

procedure TMainForm.Button10Click(Sender: TObject);
begin
  if SKALAZASForm.Execute(ALZ.WorkBMP) then begin
     ALZ.ReDraw;
     UR.UndoSave;
  end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  ALZ.PasteFromClipboard;
  picFile := 'Clipboard';
  UR.UndoInit;
  UR.UndoSave;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  ALZ.CopyToClipboard;
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
  ALZ.RestoreOriginal;
  UR.UndoSave;
end;

procedure TMainForm.ALZChangeWindow(Sender: TObject; xCent, yCent, xWorld,
  yWorld, Zoom: Double; MouseX, MouseY: Integer);
begin
  StatusBar1.Panels[0].Text := IntToStr(ALZ.OrigBMP.width)+'x'+IntToStr(ALZ.OrigBMP.height);
  StatusBar1.Panels[1].Text := IntToStr(Round(xCent))+'x'+IntToStr(Round(yCent));
end;

procedure TMainForm.Button3Click(Sender: TObject);
VAR rgbP : TRGBParam;
begin
  rgbP.RParam := StrToFloat(Edit1.Text);
  rgbP.GParam := StrToFloat(Edit2.Text);
  rgbP.BParam := StrToFloat(Edit3.Text);
  AutoNoiseReduction(ALZ.WorkBMP,Param,rgbP);
  ALZ.ReDraw;
  UR.UndoSave;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  if elso then begin
     Update;
  if FileExists('Roz.jpg') then begin
     ALZ.FileName := 'Roz.jpg';
     picFile := ExeDir+'Roz.jpg';
     UR.UndoSave;
  end;
     ALZ.FitToScreen;
     ALZ.Fitting  := False;
     elso := False;
  end;
end;

procedure TMainForm.Button5Click(Sender: TObject);
var ext: string;
    dt1, dt2: TTime;
begin
  if OpenDialog.Execute then begin
     dt1 := Now;
     ext := UpperCase(ExtractFileExt(OpenDialog.FileName));
     if Pos(ext,'.BMP.JPG')>0 then
        ALZ.FileName := OpenDialog.FileName
     ELSE begin
//        ALZ.FileName := OpenDialog.FileName;
        LoadImageFromFile(OpenDialog.FileName,ALZ.OrigBMP);
        ALZ.RestoreOriginal;
     end;
     dt2 := Now;
     StatusBar1.Panels[2].Text := TimeToStr(dt2-dt1);
     UR.UndoInit;
     UR.UndoSave;
     picFile:= OpenDialog.FileName;
  end;
end;

procedure TMainForm.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  IF not (Key in ['0'..'9','.',#8]) then Key:=#0;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Case Key of
  VK_ESCAPE : ALZ.RestoreOriginal;
  end;
end;

procedure TMainForm.MonoButtonClick(Sender: TObject);
begin
  ALZ.RGBList.MonoRGB := True;
end;

procedure TMainForm.OnUndoRedo(Sender: TObject; Undo, Redo: boolean);
begin
  SpeedButton5.Enabled := Undo;
  SpeedButton6.Enabled := Redo;
end;

procedure TMainForm.Button6Click(Sender: TObject);
begin
  Edit1.Text := '1.0';
  Edit2.Text := '1.0';
  Edit3.Text := '1.0';
end;

procedure TMainForm.Button7Click(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  Median(ALZ.WorkBMP);
  ALZ.ReDraw;
  UR.UndoSave;
  Screen.Cursor := crDefault;
end;

procedure TMainForm.Button8Click(Sender: TObject);
begin
  // Histogram
  if HistogramForm.Execute(ALZ.WorkBMP) then begin
     ALZ.ReDraw;
     UR.UndoSave;
  end;
end;

procedure TMainForm.Button9Click(Sender: TObject);
begin
  if SaveDialog.Execute then begin
     ALZ.SaveToFile(SaveDialog.FileName);
  end;
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
begin
  ALZ.RGBList.RGB := True;
  SpeedButton2.Down := True;
  SpeedButton3.Down := True;
  SpeedButton4.Down := True;
end;

procedure TMainForm.SpeedButton2Click(Sender: TObject);
begin
  TSpeedButton(Sender).Down := not TSpeedButton(Sender).Down;
  Case TSpeedButton(Sender).Tag of
       1: ALZ.SetVR;
       2: ALZ.SetVG;
       3: ALZ.SetVB;
  end;
end;

procedure TMainForm.SpeedButton5Click(Sender: TObject);
begin
  UR.Undo;
  ALZ.ReDraw;
end;

procedure TMainForm.SpeedButton6Click(Sender: TObject);
begin
  UR.Redo;
  ALZ.ReDraw;
end;

initialization
  ExeDir := ExtractFilePath(Application.ExeName);
end.
