(*******************************************************
* STAF_History - Image Process List
* IPL : Image Process Language
* by Agócs László Hungary 2021
* Email: lagocsstella@gmail.com
*
* HISTORY: Stringlist -> save/load into *.HIS text file
* SABLON : predefinied history list (*.SAB) ini file
* CATALOG: predefinied templates (*.CAT) ini fájl
*          [CATALOG]            [TYPE1]
*          Type1 = Nap          1 = Teljes Nap
*          Type2 = Hold         2 = Webkamerás
*          Type3 = Mély-ég .... 3 = Halpha
*******************************************************)
unit STAF_History;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  STAF_Imp, Szoveg;
//  , Graphics, Controls, Forms, Dialogs,

Type

  (* IPL = Image Process Language *)

  TIPLCommand = (
    commREM,
    commOrigImage,
    commMedian,
    commSharp,
    commDefWB,
    commWB,
    commAutoWB,
    commLevon1,
    commLevon2,
    commRGB,
    commBrightness,
    commContrast,
    commSaturation,
    commGamma,
    commBlackAndWhite,
    commNegative,
    commScale,
    commConvol3,
    commConvol5,
    commConvol7,
    commThreshold,
    commConvolveFilter,
    commUnsharpMasking,
    commMirrorVertical,
    commMirrorHorizontal,
    commTurnLeft,
    commTurnRight,
    commStepRGB,
    commStepRGBContour
  );

CONST

  // Command string, Syntax, Leírás
  // Ha nincs paraméter, akkor alapértelmezett értékekkel dolgozunk

  IPLCommandString : array[0..Ord(High(TIPLCommand)),0..2] of shortstring =
  (
    ('REM',            'REM (;) szöveg',        'Megjegyzés: Ha nem betûvel kezdõdik a sor'),
    ('ORIGIMAGE',      'OrigImage',             'Eredeti képbõl indul'),
    ('MEDIAN',         'Median',                'Medián szûrés'),
    ('SHARP',          'Sharp',                 'Élesítés'),
    ('DEFWB',          'DefWB r,g,b',           'Fehéregyensúly definiálás szorzókkal'),
    ('WB',             'WhiteBallance',         'Fehéregyensúly a definiált WB szorzókkal'),
    ('AUTOWB',         'AutoWB',                'Automatikus fehéregyensúly'),
    ('LEVON1',         'Levon1 par,backlevel',  'Automatikus kép korrekció - kemény'),
    ('LEVON2',         'Levon2 par,backlevel',  'Automatikus kép korrekció - lágy'),
    ('RGB',            'RGB R,G,B',             ''),
    ('BRIGHTNESS',     'Brightness par',        'Fényesség: '),
    ('CONTRAST',       'Contrast par',          'Kontraszt: '),
    ('SATURATION',     'Saturation par',        'Színtelítettség'),
    ('GAMMA',          'Gamma par',             'GAMMA'),
    ('BLACKANDWHITE',  'BlackAndWhite',         'Fekete-fehér kép'),
    ('NEGATIVE',       'Negative',              'Negatív kép'),
    ('SCALE',          'Scale type,I,R,G,B par','SKÁLÁZÁS'),
    ('CONVOL3',        'Convol3 9xpar',         '3x3-as konvulúciós kernel'),
    ('CONVOL5',        'Convol5 25xpar',        '5x5-as konvulúciós kernel'),
    ('CONVOL7',        'Convol7 49xpar',        '7x7-as konvulúciós kernel'),
    ('THRESHOLD',      'Threshold',             ''),
    ('CONVOLFILTER',   'ConvolveFilter',        'Konvolúció'),
    ('UNSHARPMASKING', 'UnsharpMasking par',    'Életlen maszk: -10..+10 default 2'),
    ('MIRRORVERTICAL', 'MirrorVertical',        'Függõleges tükrözés'),
    ('MIRRORHORIZONTAL','MirrorHorizontal',     'Vízszintes tükrözés'),
    ('TURNLEFT',       'TurnLeft',              'Forgatés balra'),
    ('TURNRIGHT',      'TurnRight',             'Forgatés jobbra'),
    ('STEPRGB',        'StepRGB',               'RGB rétegzés: lépésköz 1..255'),
    ('STEPRGBCONTOUR', 'StepRGBContour',        'RGB rétegzés kontúrvonalakkal: lépésköz 1..255')
  );

Type

  TIPLCmdRec = record
    Cmd     : TIPLCommand;
    Pars    : array[0..50] of double;
    ParsStr : string;
    Checked : boolean;
  end;

  THistoryRec = record
    CmdLine   : string;
    Checked   : boolean;
    Selected  : boolean;
  end;


  TIPLRecordingEvent = procedure(Sender: TObject; Rec: boolean) of object;
  TIPLChangeEvent = procedure(Sender: TObject; Idx: integer) of object;


  // A lista soronként tartalmazza a végrehajtandó IPL parancsokat
  TIPLHistory = class(TComponent)
  private
    FActualIndex: integer;
    FRecording: boolean;
    FOnRecording: TIPLRecordingEvent;
    FOnChange: TNotifyEvent;
    procedure SetActualIndex(const Value: integer);
    procedure SetRecording(const Value: boolean);
  protected
  public
      hisList : TStringList;
      LUT: Array[0..3, 0..255] of Byte; //
      nPts: Array[0..3] of Integer;
      ptX, ptY: Array[0..3, 1..32] of Integer;
      ptP, ptU: Array[0..3, 1..32] of Single;

      constructor Create(AOwner: TObject);
      destructor Destroy; override;

      procedure NewList;
      function  NewRec: THistoryRec;
      procedure Add(HistStr: string);
      procedure Delete(N: integer);
      procedure Insert(N: integer; HistStr: string);
      procedure Change(N: integer; HistStr: string);

      procedure First;
      procedure Next;
      procedure Prior;
      procedure Last;

      procedure CheckAll(All: boolean);
      procedure SelectAll(All: boolean);

      function  RecToString( Rec: TIPLCmdRec): string;
      function  StringToRec( cStr: string): TIPLCmdRec;
      procedure ItemToString(N: integer; var hStr: string);
      procedure ListToString(var hStr: string);
      procedure ListToStringList(hStrList: TStrings);
      procedure StringToList(hStr: string);
      // Feltölti a listát a parancs szövegekkel
      procedure CommandToList(hStrList: TStrings);

      // Feltölti a hisList-et a StringList (TList) elemeivel
      procedure StringListToHistoryList(hStrList: TStrings);

      function  IsCommand( CmdStr: string ): integer;
      function  FindCommand( CmdStr: string ): TIPLCommand;

      function  LoadFromFile(fn: string):boolean;
      function  SaveToFile(fn: string):boolean;

      procedure SetPresetString(PS: string);
      procedure SetPandU(cIdx: integer);
      procedure ApplyCurve(Img: TBitmap);

      // Egy parancs rekord végrehajtása
      function Execute(bmp: TBitmap; CmdRec: TIPLCmdRec): boolean;
      // Teljes lista végrehajtása
      function Run(bmp: TBitmap): boolean;
      // Az N. listaelem végrehajtása
      function RunRec(bmp: TBitmap; N: integer): boolean;
      // Egy partancssor végrehajtása
      function RunLine(bmp: TBitmap; hStr: string): boolean; overload;
      function RunLine(bmp: TBitmap; Idx: integer): boolean; overload;

      property ActualIndex     : integer read FActualIndex write SetActualIndex;
      property Recording       : boolean read FRecording write SetRecording;
      property OnChange        : TNotifyEvent read FOnChange write FOnChange;
      property OnRecording     : TIPLRecordingEvent read FOnRecording
                                                    write FOnRecording;
  end;

Var   StafHistory  : TStringList;   // Egy eljárás sorozat

implementation

{ TIPLHistory }

procedure TIPLHistory.Add(HistStr: string);
begin
  hisList.Add(HistStr);
end;

procedure TIPLHistory.Change(N: integer; HistStr: string);
begin
  hisList.Strings[N] := HistStr;
end;

procedure TIPLHistory.CheckAll(All: boolean);
begin

end;

procedure TIPLHistory.CommandToList(hStrList: TStrings);
var i: integer;
begin
  hStrList.Clear;
  for I := 0 to High(IPLCommandString) do
      hStrList.Add(IPLCommandString[i,0]);
end;

constructor TIPLHistory.Create(AOwner: TObject);
begin
  hisList := TStringList.Create;
  ActualIndex := -1;
  Recording   := False;
end;

procedure TIPLHistory.Delete(N: integer);
begin
  hisList.Delete(N);
end;

destructor TIPLHistory.Destroy;
begin
  hisList.Free;
  inherited;
end;

function TIPLHistory.FindCommand(CmdStr: string): TIPLCommand;
var i: integer;
begin
  for I := 0 to High(IPLCommandString) do
    if UpperCase(Trim(CmdStr)) = IPLCommandString[i,0] then
    begin
       Result := TIPLCommand(i);
       Exit;
    end;
end;

procedure TIPLHistory.First;
begin
  if hisList.Count>0 then ActualIndex := 0
  else ActualIndex := -1;
end;

procedure TIPLHistory.Insert(N: integer; HistStr: string);
begin

end;

// Megvizsgálja, hogy a parancs szerepel-e a szótárában
// Ha ige, akkor a sorszámát adja. Ha nem, akkor -1
function TIPLHistory.IsCommand(CmdStr: string): integer;
var i: integer;
begin
  Result := -1;
  if Trim(CmdStr)='' then exit;
  For i:=0 to High(IPLCommandString) do
    if IPLCommandString[i,0] = UpperCase(cmdStr) then begin
      Result := i;
      exit;
    end;
end;

procedure TIPLHistory.ItemToString(N: integer; var hStr: string);
begin

end;

procedure TIPLHistory.Last;
begin
  ActualIndex := hisList.Count-1;
end;

procedure TIPLHistory.ListToString(var hStr: string);
var i: integer;
begin
  hStr := '';
  for I := 0 to Pred(hisList.Count) do
      hStr := hStr + hisList[i];
end;

procedure TIPLHistory.ListToStringList(hStrList: TStrings);
begin
  hStrList.Assign(hisList);
end;

function TIPLHistory.LoadFromFile(fn: string): boolean;
begin
Try
  Result := True;
  hisList.LoadFromFile(fn);
except
  Result := False;
End;
end;

function TIPLHistory.SaveToFile(fn: string): boolean;
begin
Try
  Result := True;
  hisList.SaveToFile(fn);
except
  Result := False;
End;
end;

procedure TIPLHistory.NewList;
begin
  hisList.Clear;
end;

function TIPLHistory.NewRec: THistoryRec;
begin
  with Result do begin
    CmdLine   := '';
    Checked   := false;
    Selected  := false;
  end;
end;

procedure TIPLHistory.Next;
begin
  if (hisList.Count>0) and (ActualIndex<Pred(hisList.Count)) then
     ActualIndex := ActualIndex + 1;
end;

procedure TIPLHistory.Prior;
begin
  if (hisList.Count>0) and (ActualIndex>0) then
     ActualIndex := ActualIndex - 1;
end;

function TIPLHistory.RecToString(Rec: TIPLCmdRec): string;
begin
end;

function TIPLHistory.Run(bmp: TBitmap): boolean;
var
  I: Integer;
begin
  for I := 0 to Pred(hisList.Count) do
      RunLine(bmp,i);
end;

function TIPLHistory.RunLine(bmp: TBitmap; hStr: string): boolean;
var CmdRec : TIPLCmdRec;
begin
Try
  Result := True;
  CmdRec := StringToRec( hStr );
  Execute( bmp, CmdRec );
except
  Result := False;
End;
end;

function TIPLHistory.RunLine(bmp: TBitmap; Idx: integer): boolean;
var CmdRec : TIPLCmdRec;
begin
Try
  Result := True;
  CmdRec := StringToRec( hisList[Idx]);
  Execute( bmp, CmdRec );
except
  Result := False;
End;
end;

function TIPLHistory.RunRec(bmp: TBitmap; N: integer): boolean;
begin

end;

procedure TIPLHistory.SelectAll(All: boolean);
begin

end;

procedure TIPLHistory.SetActualIndex(const Value: integer);
begin
  FActualIndex := Value;
end;

procedure TIPLHistory.SetRecording(const Value: boolean);
begin
  if FRecording <> Value then begin
     FRecording := Value;
     // Value : True = Start; False = Stop recording
     if Assigned(FOnRecording) then FOnRecording(Self,Value);
  end;
end;

procedure TIPLHistory.StringListToHistoryList(hStrList: TStrings);
begin
  hisList.Assign(hStrList);
end;

procedure TIPLHistory.StringToList(hStr: string);
begin

end;

function TIPLHistory.StringToRec(cStr: string): TIPLCmdRec;
VAR s: string;
    parStr: string;
    n,i: integer;
begin
  s := Trim(UpperCase(cStr));
  n := Pos(';',s);
  if n>0 then s:=Copy(s,1,n-1);
  // Paraméter tömb 0-zása
  for I := 0 to High(Result.Pars) do
      Result.Pars[i]:=0;
  // Parancs keresés
  if Copy(s,1,1)=';' then begin
     Result.Cmd := commREM;
     exit;
  end
  else
     Result.Cmd := FindCommand( Szo(s,1) );

  // Paraméterek kigyüjtése
  n := Pos(' ',s);
  if n>0 then
  begin
  s := Trim(Copy(s,n,1000));
  if Result.Cmd = commSCALE then begin
     Result.ParsStr := s;
     Exit;
  end;
  n := Pos(',',s);
  if n=0 then
     Result.Pars[0]:=strtofloat(s)
  else
  for I := 1 to 1000 do
    begin
      parStr := StrCountD(s,',',i);
      if parStr<>'' then
         Result.Pars[i-1]:=strtofloat(parStr)
      else
         exit;
    end;
  end;
end;

// ******* SCALE ROUTINES ******************

procedure TIPLHistory.SetPandU(cIdx: integer);
var
  i: Integer;
  d, w: array[1..32] of Single;
begin
  for i:= 2 to nPts[cIdx] - 1 do d[i]:= 2 * (ptX[cIdx, i + 1] - ptX[cIdx, i - 1]);
  for i:= 1 to nPts[cIdx] - 1 do ptU[cIdx, i]:= ptX[cIdx, i + 1] - ptX[cIdx, i];
  for i:= 2 to nPts[cIdx] - 1 do w[i]:= 6 * ((ptY[cIdx, i + 1] - ptY[cIdx, i]) /
    ptU[cIdx, i] - (ptY[cIdx, i] - ptY[cIdx, i - 1]) / ptU[cIdx, i - 1]);
  for i:= 2 to nPts[cIdx] - 2 do begin
    w[i + 1]:= w[i + 1] - w[i] * ptU[cIdx, i] / d[i];
    d[i + 1]:= d[i + 1] - ptU[cIdx, i] * ptU[cIdx, i] / d[i];
  end;
  ptP[cIdx, 1]:= 0;
  for i:= nPts[cIdx] - 1 downto 2 do ptP[cIdx, i]:= (w[i] - ptU[cIdx, i] * ptP[cIdx, i + 1]) / d[i];
  ptP[cIdx, nPts[cIdx]]:= 0;
end;


procedure TIPLHistory.SetPresetString(PS: string);
var n,i,j,k,m: integer;
    s: AnsiString;
    x, y, p : integer;
const Ch : AnsiString = 'IRGB';

function GetCurvePoint(cIdx: integer; i: Integer; v: Single): Single;
var
  t0, t1: Single;
begin
  t0:= (v - ptX[cIdx, i]) / ptU[cIdx,i];
  t1:= 1 - t0;
  Result:= t0 * ptY[cIdx, i + 1] + t1 * ptY[cIdx, i] + ptU[cIdx, i] *
    ptU[cIdx, i] * ((t0*t0*t0-t0) * ptP[cIdx, i + 1] + (t1*t1*t1-t1) * ptP[cIdx, i]) / 6;
end;

begin
  // Clear old values
  for i := 0 to 3 do begin
    nPts[i] := 0;
    for n := 1 to 32 do begin
      ptP[i, n]:= 0;
      ptU[i, n]:= 0;
    end;
  end;

  n := StrCount(PS,',');
  k := 1;
  i := 0;
  s := StrCountD(PS,',',k);
  repeat
      if Pos(s[1],Ch)>0 then begin
         if s='I' then i:=0;
         if s='R' then i:=1;
         if s='G' then i:=2;
         if s='B' then i:=3;
         Inc(k);
         s := StrCountD(PS,',',k);
         nPts[i] := StrToInt(s);
         j := 1;
      end
      else
      begin
         ptX[i,j] := StrToInt(s);
         Inc(k);
         s := StrCountD(PS,',',k);
         ptY[i,j] := StrToInt(s);
         Inc(j);
      end;
      Inc(k);
      s := StrCountD(PS,',',k);
  until s='';

  for m := 0 to 3 do begin
    SetPandU(m);
    y:= 255;
    for p:= 1 to nPts[m] - 1 do
      for x:=  ptX[m, p] to ptX[m, p + 1] do begin
        y:= Trunc(GetCurvePoint(m, p, x));
        if y < 0 then y:= 0 else if y > 255 then y:= 255;
        LUT[m, x]:= y;
      end;
    if ptX[m, 1] > 0 then
       for p:= 0 to ptx[m,  1] - 1 do Lut[m, p]:= ptY[m, 1];
    if ptX[m, nPts[m]] < 255 then
       for p:= ptx[m, nPts[m]] + 1 to 255 do LUT[m, p]:= 255;
  end;
end;

procedure TIPLHistory.ApplyCurve(Img: TBitmap);
var
  SRow: PRGBArray;
  SFill, X, Y: Integer;
begin
Try
  SRow:= PRGBArray(Img.ScanLine[0]);
  SFill := Integer(Img.ScanLine[1]) - Integer(SRow);
  for Y := 0 to Img.Height - 1 do begin
    for X := 0 to Img.Width - 1 do begin
      SRow[X].R:= LUT[0, LUT[1, SRow[X].R]];
      SRow[X].G:= LUT[0, LUT[2, SRow[X].G]];
      SRow[X].B:= LUT[0, LUT[3, SRow[X].B]];
    end;
    Inc(Integer(SRow), SFill);
  end;
except
end;
end;

// *********************************************************

function TIPLHistory.Execute(bmp: TBitmap; CmdRec: TIPLCmdRec): boolean;
VAR rgbP : TRGBParam;
begin
Try
  Result := True;
  case CmdRec.Cmd of
    commREM:
        begin

        end;
    commOrigImage:
        begin

        end;
    commMedian:
          STAF_Imp.MedianRGB24( bmp );
    commSharp:
          STAF_Imp.ConvolveFilter( 3,0,bmp );
    commAutoWB:
          STAF_Imp.GrayAWB( bmp );
    commLevon1:
        begin
          rgbP.RParam := CmdRec.Pars[2];
          rgbP.GParam := CmdRec.Pars[3];
          rgbP.BParam := CmdRec.Pars[4];
          if rgbP.RParam=0 then rgbP.RParam := 1.0;
          if rgbP.GParam=0 then rgbP.GParam := 1.0;
          if rgbP.BParam=0 then rgbP.BParam := 1.0;
          STAF_Imp.AutoNoiseReduction(bmp,0,CmdRec.Pars[0],Round(CmdRec.Pars[1]),rgbP);
        end;
    commLevon2:
        begin
          rgbP.RParam := CmdRec.Pars[2];
          rgbP.GParam := CmdRec.Pars[3];
          rgbP.BParam := CmdRec.Pars[4];
          if rgbP.RParam=0 then rgbP.RParam := 1.0;
          if rgbP.GParam=0 then rgbP.GParam := 1.0;
          if rgbP.BParam=0 then rgbP.BParam := 1.0;
          Brightness(bmp,150);
          STAF_Imp.AutoNoiseReduction(bmp,1,CmdRec.Pars[0],Round(CmdRec.Pars[1]),rgbP);
        end;
    commRGB:
          STAF_Imp.ChangeRGB( bmp,CmdRec.Pars[0],CmdRec.Pars[1],CmdRec.Pars[2]);
    commBrightness:
          STAF_Imp.Brightness( bmp,Round(CmdRec.Pars[0]) );
    commContrast:
          STAF_Imp.Contrast( bmp,Round(CmdRec.Pars[0]) );
    commSaturation:
          STAF_Imp.Saturation( bmp,Round(CmdRec.Pars[0]) );
    commGamma:
          STAF_Imp.Gamma( bmp,CmdRec.Pars[0] );
    commBlackAndWhite:
          STAF_Imp.BlackAndWhite( bmp );
    commNegative:
          STAF_Imp.Negative( bmp );
    commScale:
        begin
          SetPresetString(CmdRec.ParsStr);
          ApplyCurve(bmp);
        end;
    commConvol3:
        begin

        end;
    commConvol5:
        begin

        end;
    commConvol7:
        begin

        end;
    commThreshold:
        begin

        end;
    commConvolveFilter:
        begin

        end;
    commUnsharpMasking:
        begin

        end;
    commMirrorVertical:
        begin
             STAF_Imp.FlipVertical(bmp);
        end;
    commMirrorHorizontal:
        begin
             STAF_Imp.FlipHorizontal(bmp);
        end;
    commTurnLeft:
        begin

        end;
    commTurnRight:
        begin

        end;
    commStepRGB:
        begin

        end;
    commStepRGBContour:
        begin

        end;
  end;
  if Assigned(FOnChange) then FOnChange(Self);
Except
  Result := False;
End;
end;


initialization
  StafHistory  := TStringList.Create;
finalization
  StafHistory.Free;
end.
