(**********************************************************************
   TAL_SVGLoader

   Simple SVG loader for futher graphic process.
   Not an XML parser. It is a text file analiser.

   by Agócs László
      StellaSOFT, Hungary
   email: lagocsstella@gmail.com

 **********************************************************************)

unit AL_SVGLoader;

interface
Uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.StrUtils, Vcl.Graphics, Szoveg;

Const SVGCommands : array[0..6] of string =
                 ('line','polygon','polyline','rect','circle','ellipse','path');


Const SVGPointType : array[0..9] of char =
                   ( 'M','L','H','V','C','S','Q','T','A','Z');
(*
PATH COMMANDS  (Nagy betû: abszolut, kisbetû: relatív koordináták)
M = moveto
L = lineto
H = horizontal lineto
V = vertical lineto
C = curveto
S = smooth curveto
Q = quadratic Bézier curve
T = smooth quadratic Bézier curveto
A = elliptical Arc
Z = closepath
*)

Type

  PPointArr = ^TPointArr;
  TPointArr = array[0..0] of TPoint;

  TSVGPoint = record
    PointType  : Char;
    x,y        : Single;
  end;

  { Objektum le\r= rekord }
  TSVGRecord = record
    ID         : string;              // Objektum neve : ha van ID akkor az, ha nincs tipusnév+sorszám
    ObjType    : integer;             // Objektum tipus név (pl. 'polygon') sorszáma az SVGCommands tömbben
    Points     : array of TSVGPoint;  // Pontok adatai
    w,h,r      : single;              // szélesség, hosszúság, sugár
    DataStr    : string;              // Az adatok szövege
  end;
  { circle  : cx, cy a Points tömb elsõ két adata, r a sugara
    ellipse : cx, cy a Points tömb elsõ két adata, w: x sugár, h: y sugár
  }

  { A path d="... adatblok...." elemzését és objektumizálását végzi}
  TAL_Path = class(TPersistent)
  private
    FPathStr: string;
    procedure SetPathStr(const Value: string);
  protected
  public
    Objects   : array of TSVGRecord;             // Objektumokat tartalmazó tömb
    constructor Create;
    destructor Destroy; override;
    function GetSubpathCount: integer;
    property PathStr: string read FPathStr write SetPathStr;
  end;

  TAL_SVGLoader = class(TPersistent)
  private
    FFileName: string;
    procedure SetFileName(const Value: string);
    function GetCapacity: integer;
    procedure SetCapacity(const Value: integer);
    function GetCount: integer;
    function CorrectPathDataStr(pathStr: string): string;
    function GetCoordCount(pathStr: string): integer;
  protected
  public
    Objects   : array of TSVGRecord;             // Objektumokat tartalmazó tömb
    SVGCounts : array[0..6] of integer;          // Egyes tipusok db-száma
    SVGText   : string;                          // Az SVG file beolvasva
    ObjectList: TStringList;                     // Objektumok neveinek listája

    constructor Create;
    destructor Destroy; override;
    function LoadFromSVG(Filename: STRING): string;
    function DoProcess(svgStr: string): boolean;
    procedure FillObjects;
    procedure FillPointList(pathStr: string; var obj: TSVGRecord);
//    procedure FillPointArray(var p: TPointArr; n: integer ); overload;
//    procedure FillPointArray(var p: TPointArr; o: TSVGRecord); overload;
    procedure PaintToCanvas( Ca: TCanvas ); overload;
    procedure PaintToCanvas( Ca: TCanvas; n: integer ); overload;
    procedure PaintToCanvas( Ca: TCanvas; o: TSVGRecord ); overload;

    property Capacity  : integer   read GetCapacity  write SetCapacity;
    property FileName  : string    read FFileName    write SetFileName;
    property Count     : integer   read GetCount;
  end;

implementation

{ TAL_SVGLoader }

constructor TAL_SVGLoader.Create;
begin
  inherited;
  ObjectList := TStringList.Create;
end;

destructor TAL_SVGLoader.Destroy;
begin
  ObjectList.Clear;
  ObjectList.Free;
  inherited;
end;

// Az svgStr stringben tárolt SVG leíró feldolgozása
function TAL_SVGLoader.DoProcess(svgStr: string): boolean;
begin
  Result := False;
  SVGText := svgStr;
  Capacity := Count;
  FillObjects;
end;

function TAL_SVGLoader.GetCapacity: integer;
begin
  Result := High( Objects )+1;
end;

procedure TAL_SVGLoader.SetCapacity(const Value: integer);
begin
  SetLength( Objects, Value );
end;

function TAL_SVGLoader.GetCount: integer;
var n: integer;
begin
  Result := 0;
  for n := 0 to High(SVGCommands) do begin
      SVGCounts[n] := StrCount( SVGText, '<'+SVGCommands[n] );
      Inc( Result , SVGCounts[n] );
  end;
end;

function TAL_SVGLoader.LoadFromSVG(Filename: STRING): string;
var tst: TStringList;
    D: Textfile;
    fn,s: string;
begin
  Result := '';
    fn := ChangeFileExt(Filename,'.svg');
    if FileExists(fn) then
    Try
    Try
      tst := TStringList.Create;
      tst.LoadFromFile(fn);
      Result := tst.Text;
    except
      exit;
    End;
    finally
      tst.Free;
    end;
end;

procedure TAL_SVGLoader.SetFileName(const Value: string);
begin
  FFileName := Value;
  SetLength(Objects,0);
  SVGText := LoadFromSVG(FFileName);
  Capacity := Count;
  FillObjects;
end;

function TAL_SVGLoader.CorrectPathDataStr(pathStr: string): string;
var s: string;
    i,h: integer;
    x,y : double;
begin
// 1. Az adatsort át kell alakítani olyan formába, hogy a pont tipus betûjel
//    és az x,y adatok között egy-egy space legyen
  Result := '';
  s := StringReplace(pathStr,',',' ',[rfReplaceAll]);
  i := 1;
  repeat
    // Csak nyomtatható karakterek ( sorvég jelek levágva )
    if Ord(s[i])>30 then
    BEGIN
    // Ha betût talál beszúr utána/elé egy space-t
    if Ord(s[i])>64 then
    begin
       Result := Trim(Result);
       if i>1 then
       begin
       if s[i-1]<>' ' then
          Result := Result + ' ';
       end;
       Result := Result + s[i];
       if s[i+1]<>' ' then
          Result := Result + ' ';
    end else
    if s[i]='-' then begin
       if AnsiRightStr(Result,1)<>' ' then
          Result := Result + ' ';
       Result := Result + s[i];
    end
    else
       Result := Result + s[i];
    END;
    Inc(i);
  until i>Length(s);
  Result := Trim(Result);
end;

// Megszámolja a koordináta párokat a korrigálás után
function TAL_SVGLoader.GetCoordCount(pathStr: string): integer;
var
  I: Integer;
  NumCount: integer;
begin
  Result := 0;
  NumCount := 0;
  for I := 1 to Length(pathStr) do
  begin
    if pathStr[i]=' ' then
    begin
       if Ord(pathStr[i+1])<65 then
          Inc(NumCount);
       if NumCount=3 then
       begin
          NumCount := 0;
          Inc( Result );
       end;
    end;
  end;
  if NumCount<>0 then
     Inc( Result );
end;

// A pathStr tartalmazza a Path adatokat, melybõl kinyeri az egyes ponztos adatait
procedure TAL_SVGLoader.FillPointList(pathStr: string; var obj: TSVGRecord);
var s,ss,ss1: string;
    n: integer;
    i,h: integer;
    x0,y0 : double;
    x,y : double;
    spCount: integer;
    lastType: Char;
    RelCoord: boolean;
    idx: integer;
begin
  s := CorrectPathDataStr(pathStr);           // adatstring korrekciója
  obj.DataStr := s;
  n := GetCoordCount(s);                      // kordináták megszámolása
  SetLength( obj.Points, 1000 );
  spCount := StrCount(s,' ');
  i := 1;
  idx:=0;
  lastType := 'L';
  while i<=spCount+1 do
  begin
       ss := Szo(s,i);
//       ss := StrCountD(s,' ',i);
       if ss<>'' then
       begin
       if (Length(ss)=1) and (Ord(ss[1])>64) then
       begin
//          ss := UpperCase(ss[1]);
          lastType := ss[1];
          RelCoord := UpperCase(lastType)<>LowerCase(lastType);
          Inc(i);
       end
       else
       begin
          obj.Points[idx].PointType := lastType;
          lastType := #32;
          if UpperCase(lastType)='A' then         // Elliptical arc
          begin
             Inc(i);
          end
          else
          if UpperCase(lastType)='H' then         // Horizontal line
          begin
             obj.Points[idx].y := y;
             obj.Points[idx].x := x + StrToFloat(ss);
             Inc(i);
          end
          else
          if UpperCase(lastType)='V' then         // Vertical line
          begin
             obj.Points[idx].x := x;
             obj.Points[idx].y := y + StrToFloat(ss);
             Inc(i);
          end
          else
          begin
             x := StrToFloat(ss);
             ss1 := StrCountD(s,' ',i+1);
             y := StrToFloat(ss1);
             if RelCoord then
             begin
               obj.Points[idx].x := x0+x;
               obj.Points[idx].y := y0+y;
             end
             else
             begin
               obj.Points[idx].x := x;
               obj.Points[idx].y := y;
             end;
             x0 := obj.Points[idx].x; y0 := obj.Points[idx].y;
             Inc(i,2);
          end;
          Inc(idx);
       end;
       end;
  end;
  SetLength( obj.Points, idx );
end;

procedure TAL_SVGLoader.FillObjects;
var maradek: string;
    comm: string;
    sor: string;
    sId: string;
    sData: string;
    poz: integer;
    poz1, poz2: integer;
    pozData1, pozData2: integer;
    numberArray : array[0..6] of integer;        // Sorszámok az objektum Id-khez
    objIdx: integer;                             // Objektum sorszáma
    I: Integer;
    oTypeIdx: integer;                           // Objektum tipus indexe

    // Kivágja az "-jelek közötti részt
    function GetData(s: string; p: integer): string;
    var ps: string;
    begin
      ps := Copy(s,p,Length(s));
      Result := StrCountD(ps,'"',2);
    end;

    function GetObjTypeIndex(sComm: string): integer;
    var i: integer;
    begin
      Result := -1;
      for I := 0 to High(SVGCommands) do
        if sComm = SVGCommands[i] then
           Result := i;
    end;

begin
  Capacity := 1000;
  maradek := SVGText;
  objIdx := 0;
  for I := 0 to High(numberArray) do
      numberArray[i]:=0;

  repeat
     poz1 := Pos('<',maradek);
     if poz1 > 0 then
     begin
          maradek := Copy( maradek, poz1+1, Length(maradek) );
          comm := LowerCase(Szo( maradek,1 ));
          poz2 := Pos('>',maradek);
          sor  := Copy( maradek,1,poz2-1 );

          oTypeIdx := GetObjTypeIndex(Comm);

     if oTypeIdx>-1 then
     BEGIN

          sId := '';
          poz := Pos(' id=',sor);
          if poz>0 then
             sId := GetData(sor,poz);
          if sId='backgroundrect' then
          begin

          end
          else
          if sId='' then begin
             sId := comm+'_'+IntToStr( numberArray[oTypeIdx] );
             Inc( numberArray[oTypeIdx] );
          end;

          if comm = 'line' then
          begin
             SetLength( Objects[objIdx].Points, 2 );
             Objects[objIdx].Id := sId;
             Objects[objIdx].ObjType := oTypeIdx;
//             Objects[objIdx].DataStr := sor;
             poz1 := Pos(' x1=',sor);
             sData := GetData(sor,poz1);
             Objects[objIdx].Points[0].x := StrToFloat(sData);
              poz1 := Pos(' y1=',sor);
             sData := GetData(sor,poz1);
             Objects[objIdx].Points[0].y := StrToFloat(sData);
              poz1 := Pos(' x2=',sor);
             sData := GetData(sor,poz1);
             Objects[objIdx].Points[1].x := StrToFloat(sData);
              poz1 := Pos(' y2=',sor);
             sData := GetData(sor,poz1);
             Objects[objIdx].Points[1].y := StrToFloat(sData);
             Inc( objIdx );
          end
             else
          if comm = 'rect' then
          begin
          if sId<>'backgroundrect' then
          begin
             SetLength( Objects[objIdx].Points, 1 );
             Objects[objIdx].Id := sId;
             Objects[objIdx].ObjType := oTypeIdx;
//             Objects[objIdx].DataStr := sor;
             poz1 := Pos(' x=',sor);
             sData := GetData(sor,poz1);
             Objects[objIdx].Points[0].x := StrToFloat(sData);
             poz1 := Pos(' y=',sor);
             sData := GetData(sor,poz1);
             Objects[objIdx].Points[0].y := StrToFloat(sData);
             poz1 := Pos(' width=',sor);
             sData := GetData(sor,poz1);
             Objects[objIdx].w := StrToFloat(sData);
             poz1 := Pos(' height=',sor);
             sData := GetData(sor,poz1);
             Objects[objIdx].h := StrToFloat(sData);
             Inc( objIdx );
          end;
          end
              else
          if (comm='polygon') or (comm='polyline') then
          begin
             Objects[objIdx].Id := sId;
             Objects[objIdx].ObjType := oTypeIdx;
//             Objects[objIdx].DataStr := sor;
             poz1 := Pos('points',sor);
             sData := GetData(sor,poz1);
             FillPointList(sData, Objects[objIdx]);
             Inc( objIdx );
          end
              else
          if comm = 'circle' then
          begin
             SetLength( Objects[objIdx].Points, 1 );
             Objects[objIdx].Id := sId;
             Objects[objIdx].ObjType := oTypeIdx;
//             Objects[objIdx].DataStr := sor;
             poz1 := Pos(' cx=',sor);
             sData := GetData(sor,poz1);
             Objects[objIdx].Points[0].x := StrToFloat(sData);
             poz1 := Pos(' cy=',sor);
             sData := GetData(sor,poz1);
             Objects[objIdx].Points[0].y := StrToFloat(sData);
             poz1 := Pos(' r=',sor);
             sData := GetData(sor,poz1);
             Objects[objIdx].r := StrToFloat(sData);
             Inc( objIdx );
          end
              else
          if comm = 'ellipse' then
          begin
             SetLength( Objects[objIdx].Points, 1 );
             Objects[objIdx].Id := sId;
             Objects[objIdx].ObjType := oTypeIdx;
//             Objects[objIdx].DataStr := sor;
              poz1 := Pos(' cx=',sor);
              sData := GetData(sor,poz1);
             Objects[objIdx].Points[0].x := StrToFloat(sData);
              poz1 := Pos(' cy=',sor);
              sData := GetData(sor,poz1);
             Objects[objIdx].Points[0].y := StrToFloat(sData);
              poz1 := Pos(' rx',sor);
              sData := GetData(sor,poz1);
             Objects[objIdx].w := StrToFloat(sData);
              poz1 := Pos(' ry',sor);
              sData := GetData(sor,poz1);
             Objects[objIdx].h := StrToFloat(sData);
             Inc( objIdx );
          end
              else
          if comm = 'path' then
          begin
             Objects[objIdx].Id := sId;
             Objects[objIdx].ObjType := oTypeIdx;
             poz1 := Pos(' d=',sor);
             sData := GetData(sor,poz1);
             Objects[objIdx].DataStr := sData;
             FillPointList(sData, Objects[objIdx]);
             Inc( objIdx );
          end;

     END;
     end;
  until poz1=0;
  Capacity := objIdx;
end;
(*
procedure TAL_SVGLoader.FillPointArray(var p: TPointArr; n: integer);
    begin
      FillPointArray(p,objects[n]);
    end;

procedure TAL_SVGLoader.FillPointArray(var p: TPointArr; o: TSVGRecord);
  var
    I,n: Integer;
    begin
           n := High(o.Points)+1;
           SetLength( p, n );
           for I := 0 to High(o.Points) do
           begin
                p[i].x := Round(o.Points[i].x);
                p[i].y := Round(o.Points[i].y);
           end;
//           p := pp;
    end;
*)
procedure TAL_SVGLoader.PaintToCanvas(Ca: TCanvas);
var i: integer;
begin
  if Ca<>nil then
  For i:=0 to Capacity do
      PaintToCanvas(Ca,i);
end;

procedure TAL_SVGLoader.PaintToCanvas(Ca: TCanvas; n: integer);
var o: TSVGRecord;
begin
  o := objects[n];
  PaintToCanvas(Ca,o);
end;

procedure TAL_SVGLoader.PaintToCanvas(Ca: TCanvas; o: TSVGRecord);
var p : array of TPoint;

  procedure FillPointArray(o: TSVGRecord);
  var
    I,n: Integer;
    begin
           n := High(o.Points)+1;
           SetLength( p, n );
           for I := 0 to High(o.Points) do
           begin
                p[i].x := Round(o.Points[i].x);
                p[i].y := Round(o.Points[i].y);
           end;
    end;

begin
      FillPointArray(o);
      Case o.ObjType of
      0:
      begin
        Ca.MoveTo(Round(o.Points[0].x),Round(o.Points[0].y));
        Ca.LineTo(Round(o.Points[1].x),Round(o.Points[1].y));
      end;
      1:
        Ca.Polygon(p);
      2:
        Ca.Polyline(p);
      3:
      begin
        Ca.Rectangle(Round(o.Points[0].x),Round(o.Points[0].y),
           Round(o.Points[0].x+o.w),Round(o.Points[0].y+o.h));
      end;
      6:
      begin

      end;
      End;
end;


{ TAL_Path }

constructor TAL_Path.Create;
begin

end;

destructor TAL_Path.Destroy;
begin

  inherited;
end;

function TAL_Path.GetSubpathCount: integer;
begin
  Result := StrCount(PathStr,'M')+StrCount(PathStr,'m');
end;

procedure TAL_Path.SetPathStr(const Value: string);
begin
  FPathStr := Value;
end;

end.


