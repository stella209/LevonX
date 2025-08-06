{
  TStIniFile      (by Agócs László StellaSOFT)
  ----------
  Local = True;
  Lokál IniFile komponens, mely az EXE-vel azonos könyvtárban keletkezik
  és bármely adattipussal illesztve van.
  Local=False;
  Ebben az esetben az IniFileName property adja meg az INI file nevét

}
unit StIni;

interface

uses
  SysUtils, WinProcs, Classes, WinTypes, Messages, Graphics, Controls, Forms,
  IniFiles, Szoveg;

type
  TStIniFile = class(TComponent)
  private
    FLocal: boolean;
    FIniFileName: string;
    procedure SetLocal(Value:boolean);
    procedure SetIniFileName(Value:string);
  public
    iFile : TIniFile;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    procedure SetString(const Section, Entry, Value: string);
    function  GetString(const Section, Entry, Default: string): string;
    procedure SetInteger(const Section, Entry: string; Value: LongInt);
    function  GetInteger(const Section, Entry: string; Default: LongInt): LongInt;
    procedure SetBoolean(const Section, Entry: string; Value: boolean);
    function  GetBoolean(const Section, Entry: string; Default: boolean): boolean;
    procedure SetFloat(const Section, Entry: string; Value: Extended);
    function  GetFloat(const Section, Entry: string; Default: Extended): Extended;
    procedure SetFont(const Section, Entry: string; Value: TFont);
    function  GetFont(const Section, Entry: string; Default: TFont): TFont;
    procedure SetPen(const Section, Entry: string; Value: TPen);
    function  GetPen(const Section, Entry: string; Default: TPen): TPen;
    function  StrToBool(strVal: string): boolean;
    function  BoolToStr(bVal: boolean): string;
    function  StrToFont(s:string):TFont;
    function  FontToStr(f:TFont):string;
    function  StrToPen(s:string):TPen;
    function  PenToStr(p:TPen):string;
{    function  StrToBrush(s:string):TBrush;
    function  BrushToStr(b:TBrush):string;}
  published
    property IniFileName: string read FIniFileName write SetIniFileName;
    property Local: boolean read FLocal write SetLocal;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('AL', [TStIniFile]);
end;

constructor TStIniFile.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Local := True;
  IniFileName:=ChangeFileExt(Application.ExeName, '.INI');
end;

destructor TStIniFile.Destroy;
begin
     iFile.Free;
     inherited Destroy;
end;

procedure TStIniFile.SetIniFileName(Value:string);
begin
  If FIniFileName<>Value then begin
     FIniFileName:=Value;
     If iFile<>nil then iFile.Free;
     If (IniFileName<>'') then iFile := TIniFile.Create(Value);
  end;
end;

procedure TStIniFile.SetLocal(Value:boolean);
begin
  If FLocal<>Value then begin
     FLocal:=Value;
     If Value then IniFileName:=ChangeFileExt(Application.ExeName, '.INI');
  end;
end;

procedure TStIniFile.SetString(const Section, Entry,Value: string);
begin
      iFile.WriteString(Section, Entry, Value);
end;

function TStIniFile.GetString(const Section, Entry, Default: string): string;
begin
      Result:=iFile.ReadString(Section, Entry, Default);
end;

procedure TStIniFile.SetInteger(const Section, Entry: string; Value: LongInt);
begin
      iFile.WriteInteger(Section, Entry, Value);
end;

function TStIniFile.GetInteger(const Section, Entry:string; Default: LongInt): LongInt;
begin
      Result := iFile.ReadInteger(Section, Entry, Default);
end;

procedure TStIniFile.SetBoolean(const Section, Entry: string; Value: boolean);
begin
      iFile.WriteString(Section, Entry, BoolToStr(Value));
end;

function TStIniFile.GetBoolean(const Section, Entry: string; Default: boolean): boolean;
begin
      Result:=StrToBool(iFile.ReadString(Section, Entry, BoolToStr(Default)));
end;

procedure TStIniFile.SetFloat(const Section, Entry: string; Value: Extended);
begin
      iFile.WriteString(Section, Entry, FloatToStr(Value));
end;

function TStIniFile.GetFloat(const Section, Entry: string; Default: Extended): Extended;
begin
      Result:=StrToFloat(iFile.ReadString(Section, Entry, FloatToStr(Default)));
end;

procedure TStIniFile.SetFont(const Section, Entry: string; Value: TFont);
begin
      iFile.WriteString(Section, Entry, FontToStr(Value));
end;

function  TStIniFile.GetFont(const Section, Entry: string; Default: TFont): TFont;
begin
      Result:=StrToFont(iFile.ReadString(Section, Entry, FontToStr(Default)));
end;

procedure TStIniFile.SetPen(const Section, Entry: string; Value: TPen);
begin
      iFile.WriteString(Section, Entry, PenToStr(Value));
end;

function  TStIniFile.GetPen(const Section, Entry: string; Default: TPen): TPen;
begin
      Result:=StrToPen(iFile.ReadString(Section, Entry, PenToStr(Default)));
end;

{ --------- konverziós rutinok ---------}

function TStIniFile.StrToBool(strVal: string): boolean;
var Bool1,Bool2: boolean;
begin
  Bool1:=(Pos(UpperCase(strVal),'TTRUEYYESON')>0) or (strVal = '1');
  Bool2:=(Pos(UpperCase(strVal),'FFALSENNOOFF')>0) or (strVal <> '1');
  Result := Bool1;
end;

function TStIniFile.BoolToStr(bVal: boolean): string;
begin
  if bVal then Result := 'True'
  else Result := 'False';
end;

{Stringbõl Font-ot generál : pl. 'Arial,12,fsBold,szin' -> TFont}
function TStIniFile.StrToFont(s:string):TFont;
var i,n,m: integer;
    sz: string;
    f: TFont;
Const fst : Array[0..3] of string = ('Félkövér','Dõlt','Aláhúzott','Áthúzott');
begin
Try
 Result:=TFont.Create;
 n:=Pos(',',s)-1;
 sz := Copy(s,1,n);
 m := StrCount(sz,' ');
 s:=Stuff(s,',',' ');
 Result.Name:=sz;
 Result.Size:=StrToInt(Szo(s,2+m));
 sz := Szo(s,3+m);     {Stylus}
 Result.Style:=[];
 If sz='Félkövérdõlt' then Result.Style:=[fsBold,fsItalic]
 else
 For i:=0 to 3 do If fst[i]=sz then Result.Style:=[TFontStyle(i)];
 sz := Szo(s,4+m);     {Szín}
 If sz='' then Result.Color:=clBlack else Result.Color:=StrToInt(sz);
except
 Exit;
end;
end;

{Fontból string-et generál : pl. TFont -> 'Arial,12,fsBold,szin' }
function TStIniFile.FontToStr(f:TFont):string;
var st: string;
begin
 If f.Style=[] then st:='Normál';
 If fsBold in f.Style then st:='Félkövér';
 If fsItalic in f.Style then st:='Dõlt';
 If fsUnderline in f.Style then st:='Aláhúzott';
 If fsStrikeOut in f.Style then st:='Áthúzott';
 Result:=f.Name+','+IntToStr(f.Size)+','+st+','+Inttostr(f.Color);
end;

{Stringbõl Pen-t generál :  'vastag,szin,style,mode' -> TPen}
function  TStIniFile.StrToPen(s:string):TPen;
var i,n,m: integer;
    sz: string;
    f: TPen;
Const fst : Array[0..3] of string = ('Félkövér','Dõlt','Aláhúzott','Áthúzott');
begin
Try
 Result:=TPen.Create;
 n:=Pos(',',s)-1;
 sz := Copy(s,1,n);
 m := StrCount(sz,' ');
 s:=Stuff(s,',',' ');
 Result.Width:=StrToInt(sz);
 Result.Color:=StrToInt(Szo(s,2+m));
 sz := Szo(s,3+m);     {Stylus}
 Result.Style:=TPenStyle(StrToInt(sz));
 sz := Szo(s,4+m);
 Result.Mode:=TPenMode(StrToInt(sz));
except
 Exit;
end;
end;

function  TStIniFile.PenToStr(p:TPen):string;
begin
  Result:=IntToStr(p.width)+IntToStr(p.Color)+IntToStr(Ord(p.Style))
          +IntToStr(Ord(p.Mode));
end;
{
function  TStIniFile.StrToBrush(s:string):TBrush;
function  TStIniFile.BrushToStr(b:TBrush):string;
}
end.

