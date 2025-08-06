{ TSTSTDataGrid       : TStringgrid adattáblázat komponens
                    Fejléc feliratokkal, rekordsorszámozással és
                    kibõvített adatbeviteli eljárásokkal
  Tipus           : DELPHI 1.0 komponens
  Szerzõ          : Agócs László by StellaSOFT 2001
}

unit Dgrid;

interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes,
  Vcl.Controls, Vcl.Forms, StdCtrls, Grids, Szoveg, ClipBrd;

Type
  TGridState = (gsNone,gsBrowse,gsEdit,gsAppend,gsInsert,gsDelete);

  TRowCountChange = procedure(Sender: TObject; RowCount:longint) of object;

  TSTCustomDataGrid = class(TStringGrid)
  private
    FAutoAppendRow   : boolean;     {Automatikus sor hozzáfûzés a tábla végére}
    FCopyAboweRow    : boolean;     {Uj sornál a fölötte lévõt másolja}
    FOEMConversion   : boolean;
    FTitleLabels     : TStrings;    {Fejléc feliratok}
    FRowCount        : longint;
    FRowCountChange  : TRowCountChange;
    FGridState: TGridState;
    FEnableEvents: boolean;
    procedure SetOEMConversion(Value:boolean);
    procedure SetTitleLabels(Value:TStrings);
    procedure SetGridState(const Value: TGridState);
  protected
    elso             : boolean;     {belépéskor igaz}
    TitleChanged     : boolean;     {Jelzi a fejlécszövegek változását}
    GridText         : string;      {Editált mezõ eredeti tartalma}
    DragRow1         : longint;
    DragRow2         : longint;
    Row1,Row2        : longint;
    copySTM          : TMemoryStream;
    copyRowCol       : TGridRect;
    lastRowCol       : TGridRect;
    mousemoved       : boolean;

    procedure KeyDown(var Key: Word; Shift: TShiftState);override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    function  SelectCell(ACol, ARow: Longint): boolean; override;
    function GetEditText(Col,Row: Longint):string; override;
    procedure Paint;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure SaveToFile(fn:string);
    function  LoadFromListFile(fn:string):boolean;
    function  SaveToListFile(fn:string):boolean; overload;
    procedure SaveToListFile(fn:string;delimeiter:string;tablo:boolean); overload;
    procedure First;
    procedure Next;
    procedure Prior;
    procedure Last;
    procedure ColClear;
    procedure ActColNull(col:integer);
    procedure RowClear;
    procedure RowClearTo;
    procedure RowClearFrom;
    procedure ClearRows(s1,s2:longint);
    procedure Clear;
    procedure NewRec;
    procedure InsertRec;
    procedure DeleteRec; overload;
    procedure DeleteRec(aRow:longint); overload;
    procedure DeleteRecords(R1,R2:longint);
    procedure DeleteEmptyRows;
    function  IsEmptyRec(aRow:longint): boolean;
    procedure FillsCol(Value:string);
    procedure ExchangeRows(aRow1,aRow2:longint);
    procedure InsertDelRow(delRow,InsRow:longint);
    procedure InitTitleLabels;
    procedure CopyRowsToStream(R1,R2: longint);
    procedure InsertRowsFromStream(R: longint);
    function GetLineAsText(R: Longint):string; overload;
    function GetLineAsText(R: Longint; delimiter: string):string; overload;
    property AutoAppendRow:boolean read FAutoAppendRow write FAutoAppendRow;
    property CopyAboweRow:boolean read FCopyAboweRow write FCopyAboweRow;
    property EnableEvents: boolean read FEnableEvents write FEnableEvents;
    property OEMConversion : boolean read FOEMConversion write SetOEMConversion;
    property GridState: TGridState read FGridState write SetGridState;
    property TitleLabels : TStrings read FTitleLabels write SetTitleLabels
         stored True;
    property OnRowCountChange: TRowCountChange read FRowCountChange write FRowCountChange;
  end;

  TSTDataGrid = class(TSTCustomDataGrid)
  published
    property AutoAppendRow;
    property CopyAboweRow;
    property EnableEvents;
    property OEMConversion;
    property TitleLabels;
    property OnRowCountChange;
  end;

//procedure Register;
Function UresStrings(t:TStrings): TStrings;

implementation
(*
procedure Register;
begin
     RegisterComponents('AL',[TSTDataGrid]);
end;
*)
constructor TSTCustomDataGrid.Create(AOwner:TComponent);
begin
     inherited Create(AOwner);
     copySTM      := TMemoryStream.Create;
     FEnableEvents:= True;
     FGridState   := gsNone;
     GridText     := '';
     DefaultRowHeight := 18;
     FixedRows:=1;
     FixedCols:=1;
     FTitleLabels := TStringList.Create;
     TitleChanged := True;
     FRowCount    := 0;
     Row1         := -1;
     Row2         := -1;
     elso:=True;
end;

destructor TSTCustomDataGrid.Destroy;
begin
     FTitleLabels.Free;
     copySTM.Free;
     inherited Destroy;
end;

procedure TSTCustomDataGrid.Paint;
var i: longint;
begin
If elso then begin
  InitTitleLabels;
  elso:=False;
end;
If FRowCount<>RowCount then begin
   For i:=1 to RowCount-1 do Rows[i][0]:=IntToStr(i);
   FRowCount:=RowCount
end;
  inherited Paint;
end;

procedure TSTCustomDataGrid.Prior;
begin
  if Row>1 then Row:=Row-1;
end;

procedure TSTCustomDataGrid.SetTitleLabels(Value:TStrings);
begin
  FTitleLabels.Assign(Value);
  TitleChanged := True;
  InitTitleLabels;
end;

procedure TSTCustomDataGrid.InitTitleLabels;
var i: integer;
begin
  If TitleChanged then begin
     For i:=0 to ColCount-1 do Cells[i,0]:='';
     For i:=0 to FTitleLabels.Count-1 do Cells[i,0]:=FTitleLabels.Strings[i];
     TitleChanged := False;
  end;
end;

procedure TSTCustomDataGrid.Clear;
begin
  RowCount:=2;
  Rows[1].Assign(UresStrings(Rows[1]));
  FixedRows:=1;
end;

procedure TSTCustomDataGrid.ColClear;
begin
If goEditing in Options then
  Cols[Col].Assign(UresStrings(Cols[Col]));
end;

procedure TSTCustomDataGrid.RowClear;
begin
If goEditing in Options then begin
  Rows[Row].Assign(UresStrings(Rows[Row]));
  Cells[0,row]:=IntToStr(row);
end;
end;

procedure TSTCustomDataGrid.ActColNull(col:integer);
var i:longint;
begin
If goEditing in Options then
  For i:=1 to RowCount-1 do Cells[col,i]:='0';
end;

procedure TSTCustomDataGrid.RowClearTo;
var i:longint;
begin
If goEditing in Options then begin
  For i:=1 to Row-1 do begin
  Rows[i].Assign(UresStrings(Rows[i]));
  Cells[0,i]:=IntToStr(i);
  end;
end;
end;

procedure TSTCustomDataGrid.RowClearFrom;
var i:longint;
begin
If goEditing in Options then begin
  For i:=Row to Rowcount do begin
  Rows[i].Assign(UresStrings(Rows[i]));
  Cells[0,i]:=IntToStr(i);
  end;
end;
end;

procedure TSTCustomDataGrid.ClearRows(s1,s2:longint);
var i:longint;
begin
If goEditing in Options then begin
  If s1<1 then s1:=1;
  row := s1;
  For i:=s1 to s2 do DeleteRec;
  if FEnableEvents then
  If Assigned(FRowCountChange) then FRowCountChange(Self,RowCount);
end;
end;

procedure TSTCustomDataGrid.FillsCol(Value:string);
var i:longint;
begin
If goEditing in Options then begin
  For i:=1 to Rowcount do begin
  Cells[Col,i]:=Value;
  end;
end;
end;

procedure TSTCustomDataGrid.First;
begin
  if Row>1 then Row:=1;
end;

{ Két sor tartalmát felcseréli }
procedure TSTCustomDataGrid.ExchangeRows(aRow1,aRow2:longint);
var BufferStrs: TStringList;
begin
 Try
  BufferStrs := TStringList.Create;
  BufferStrs.Assign(Rows[aRow2]);
  Rows[aRow2].Assign(Rows[aRow1]);
  Rows[aRow1].Assign(BufferStrs);
  Cells[0,aRow1]:=Inttostr(aRow1);
  Cells[0,aRow2]:=Inttostr(aRow2);
 finally
  BufferStrs.Free;
 end;
end;

{A delRow-t törli és beilleszti az insRow sor helyére}
procedure TSTCustomDataGrid.InsertDelRow(delRow,InsRow:longint);
var BufferStrs: TStringList;
begin
 Try
  BufferStrs := TStringList.Create;
  BufferStrs.Assign(Rows[delRow]);
  Row := insRow;
  InsertRec;
  Rows[insRow].Assign(BufferStrs);
  If delRow>insRow then Row:=delRow+1 else Row:=delRow;
  DeleteRec;
  If (delRow<insRow) then ExchangeRows(insRow,insrow-1)
  else
    Cells[0,insRow]:=Inttostr(insRow);
 finally
  BufferStrs.Free;
  GridState := gsInsert;
 end;
end;

procedure TSTCustomDataGrid.SaveToFile(fn: string);
begin

end;

function TSTCustomDataGrid.SaveToListFile(fn: string): boolean;
begin
  SaveToListFile(fn,',',False);
end;

procedure TSTCustomDataGrid.SaveToListFile(fn, delimeiter: string;
  tablo: boolean);
var T: TEXTFILE;
    i,j: integer;
    sor: string;
begin
Try
  AssignFile(T,fn);
  Rewrite(T);
  for I := 1 to Pred(RowCount) do begin
      sor := GetLineAsText(i,delimeiter);
      WriteLn(T,sor);
  end;
Finally
  CloseFile(T);
End;
end;

procedure TSTCustomDataGrid.Last;
begin
  if Row<RowCount-1 then Row:=RowCount-1;
end;

function TSTCustomDataGrid.LoadFromListFile(fn: string): boolean;
var T: TEXTFILE;
    i,j,R: integer;
    dataCount : integer;
    sor: string;
begin
Try
  AssignFile(T,fn);
  Reset(T);
  while not EOF(T) do begin
        ReadLn(T,sor);
        dataCount := StrCount(sor,',');
        if (sor<>'') and (dataCount>0) then begin
           NewRec;
           for I := 1 to dataCount do
               Cells[I,Row] := StrCountD(sor,',',i);
        end;
  end;
Finally
  CloseFile(T);
End;
end;


procedure TSTCustomDataGrid.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
Var tgr: TGridRect;
    Arow,Acol: integer;
begin
  if Shift=[ssLeft] then
  begin
     MouseToCell( x,y,Acol,Arow );
     copyRowCol.Left := Acol;
     copyRowCol.Top := Arow;
  end;
  if (Shift=[ssShift,ssLeft]) then
  begin
     MouseToCell( x,y,Acol,Arow );
     copyRowCol.Right := Acol;
     copyRowCol.Bottom := Arow;
     Selection := copyRowCol;
     HideEditor;
     mousemoved:=False;
  end;
  inherited;
end;

procedure TSTCustomDataGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
Var
    Arow,Acol: integer;
begin
  inherited;
  if (Shift=[ssLeft]) then
  begin
     MouseToCell( x,y,Acol,Arow );
     copyRowCol.Right := Acol;
     copyRowCol.Bottom := Arow;
     Selection := copyRowCol;
     HideEditor;
     mousemoved:=True;
  end;
end;

procedure TSTCustomDataGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
Var
    Arow,Acol: integer;
begin
  inherited;
  if mousemoved then
  if Shift=[ssLeft] then
  begin
     MouseToCell( x,y,Acol,Arow );
     copyRowCol.Right := Acol;
     copyRowCol.Bottom := Arow;
     Selection := copyRowCol;
  end;
  HideEditor;
  mousemoved:=False;
end;

function  TSTCustomDataGrid.SelectCell(ACol, ARow: Integer): boolean;
begin
(*
  lastRowCol := copyRowCol;
  copyRowCol.TopLeft.X:=ACol;
  copyRowCol.TopLeft.Y:=ARow;
*)
  Result := True;
  inherited;
end;

procedure TSTCustomDataGrid.SetGridState(const Value: TGridState);
begin
  FGridState := Value;
end;

procedure TSTCustomDataGrid.SetOEMConversion(Value:boolean);
var i,j:longint;
begin
  If FOEMConversion<>Value then begin
     FOEMConversion := Value;
  For i:=1 to Rowcount do
  For j:=1 to Colcount do begin
      If FOEMConversion then Cells[j,i]:=ASCIIToWin(Cells[j,i])
      else Cells[j,i]:=WinToASCII(Cells[j,i]);
  end;
  end;
end;

procedure TSTCustomDataGrid.NewRec;
begin
If goEditing in Options then begin
  RowCount:=RowCount+1;
  If CopyAboweRow and (Row>1) then
     Rows[RowCount-1].Assign(Rows[RowCount-2])
  else
     Rows[RowCount-1].Assign(UresStrings(Rows[RowCount-1]));
    Cells[0,RowCount-1]:=IntToStr(RowCount-1)+'*';
  If RowCount-Toprow>VisibleRowCount then TopRow:=RowCount-VisibleRowCount;
  Row:=RowCount-1;
  Col:=1;
  GridState := gsAppend;
  if FEnableEvents then
  If Assigned(FRowCountChange) then FRowCountChange(Self,RowCount);
end;
end;

procedure TSTCustomDataGrid.Next;
begin
  if Row>RowCount-2 then Row:=Row+1;
end;

procedure TSTCustomDataGrid.InsertRec;
var i:longint;
begin
If goEditing in Options then begin
  If (RowCount>1) then begin
  RowCount := RowCount+1;
  If RowCount>2 then begin
     For i:=RowCount-1 downto Row do begin
         Rows[i].Assign(Rows[i-1]);
         Rows[i][0]:=IntToStr(i);
     end;
  end;
  If CopyAboweRow {and (Row>1)} then
     Rows[Row].Assign(Rows[Row+1])
  else
     Rows[Row].Assign(UresStrings(Rows[Row]));
  Rows[Row][0]:=IntToStr(Row)+'*';
  Row:=Row+1;
  end else NewRec;
  GridState := gsInsert;
  if FEnableEvents then
  If Assigned(FRowCountChange) then FRowCountChange(Self,RowCount);
end;
end;

procedure TSTCustomDataGrid.DeleteEmptyRows;
var i: integer;
begin
  For i:=Pred(Rowcount) downto 1 do begin
    if IsEmptyRec(i) then begin
       DeleteRec(i);
    end;
  end;
end;

procedure TSTCustomDataGrid.DeleteRec;
var i:longint;
begin
If goEditing in Options then begin
  If (RowCount>2) then begin
     If (Row<RowCount-1) then
     For i:=Row to RowCount-2 do begin
         Rows[i+1][0]:=IntToStr(i);
         Rows[i].Assign(Rows[i+1]);
     end;
     RowCount:=RowCount-1
  end else Rows[1].Assign(UresStrings(Rows[1]));
  GridState := gsDelete;
  if FEnableEvents then
  If Assigned(FRowCountChange) then FRowCountChange(Self,RowCount);
end;
end;

{Törli a grid r1..r2 közötti sorait}
procedure TSTCustomDataGrid.DeleteRec(aRow: Integer);
begin
  Row := aRow;
  DeleteRec;
end;

procedure TSTCustomDataGrid.DeleteRecords(R1,R2:longint);
var i,k:longint;
    oe: boolean;
begin
If goEditing in Options then begin
  oe := FEnableEvents;
  FEnableEvents := False;
  if R2<R1 then begin
     k:=R1; R1:=R2; R2:=k;
   end;
   if R1<1 then R1:=1;
   if R2>RowCount then R2 := RowCount;
   For i:=R2 downto R1 do
       DeleteRec(i);
  FEnableEvents := oe;
  if FEnableEvents then
  If Assigned(FRowCountChange) then FRowCountChange(Self,RowCount);
end;
end;
(*
procedure TSTCustomDataGrid.DeleteRecords(R1,R2:longint);
var i:longint;
begin
If goEditing in Options then begin
  If (RowCount>(R2-R1)) then begin
     If (Row<RowCount-1) then
     For i:=R2 to RowCount-Abs(R2-R1) do begin
         Rows[R1+(i-R2)][0]:=IntToStr(i);
         Rows[R1+(i-R2)].Assign(Rows[i+1]);
     end;
     RowCount:=RowCount-(R2-R1+1);
  end else Rows[1].Assign(UresStrings(Rows[1]));
  If Assigned(FRowCountChange) then FRowCountChange(Self,RowCount);
end;
end;
*)
procedure TSTCustomDataGrid.CopyRowsToStream(R1,R2: longint);
var i,j: longint;
    s: string[20];
begin
  copyRowCol:=Selection;
  copySTM.Clear;
  For i:= Selection.Top to Selection.Bottom do
  For j:=Selection.Left to Selection.Right do begin
      s := Cells[j,i];
      copySTM.Write(s,SizeOf(s));
  end;
{  copyRowCol.Left:=-1;
  copyRowCol.Top:=-1;
  copyRowCol.Right := -1;
  copyRowCol.Bottom:=-1;}
end;

procedure TSTCustomDataGrid.InsertRowsFromStream(R: longint);
var i,j,dr: longint;
    appended  : boolean;
    s: string[20];
begin
  appended := R = RowCount;
  copySTM.Seek(0,0);
  Row:=R;
  dr := r-copyRowCol.Top;
  For i:=copyRowCol.Top+dr to copyRowCol.Bottom+dr do
      InsertRec;
  For i:=copyRowCol.Top+dr to copyRowCol.Bottom+dr do
    For j:=copyRowCol.Left to copyRowCol.Right do begin
      copySTM.Read(s,SizeOf(s));
      Cells[j,i]:=s;
    end;
end;

function TSTCustomDataGrid.IsEmptyRec(aRow: Integer): boolean;
var s: string;
begin
  s := Stuff(GetLineAsText(aRow),',','');
  Result := s = '';
end;

function TSTCustomDataGrid.GetEditText(Col,Row: Longint):string;
begin
  GridText := Cells[Col,Row];
  Result   := GridText;
end;

{Egy sort ad vissza string alakban; a mezõk vesszõvel elválasztva}
function TSTCustomDataGrid.GetLineAsText(R: Longint):string;
var i: integer;
begin
  Result   := '';
  For i:=1 to ColCount-1 do
      Result := Result + Cells[i,R] + ',';
  Result   := Copy(Result,1,Length(Result)-1);
end;

function TSTCustomDataGrid.GetLineAsText(R: Longint; delimiter: string):string;
var i: integer;
begin
  Result   := '';
  For i:=1 to ColCount-1 do
      Result := Result + Cells[i,R] + delimiter;
  Result   := Copy(Result,1,Length(Result)-1);
end;

Function UresStrings(t:TStrings): TStrings;
var i:longint;
begin
  Result:=TStringList.create;
  Result.Assign(t);
  For i:=1 to Result.Count-1 do Result[i]:='';
end;

procedure TSTCustomDataGrid.KeyDown(var Key: Word; Shift: TShiftState);
var selSelection: TGridRect;
begin
if goEditing in Options then begin
  If Shift=[] then begin
       copyRowCol := Selection;
  Case Key of
  VK_INSERT : begin InsertRec; Row:=Row-1; Col:=1; end;
  VK_DELETE : //If not (goRowSelect in Options) then DeleteRec else
              begin
                 DeleteRecords(Selection.Top,Selection.Bottom);
                 If (goRowSelect in Options) then
                    Options := Options - [goRowSelect];
              end;
  VK_DOWN   : If (Row=RowCount-1) and AutoAppendRow then
              if not IsEmptyRec(Row) then
                 NewRec;
  VK_UP     : If (Row=RowCount-1) and AutoAppendRow then
              if IsEmptyRec(Row) then begin
                 DeleteRec(Row);
                 exit;
              end;
  VK_ADD    : begin Key:=VK_RETURN; NewRec; end;
  VK_ESCAPE : begin
                Cells[Col,Row]:=GridText;
                HideEditor;
                copySTM.Clear;
                Row1:=-1; Row2:=-1;
              end;
  VK_TAB    : begin
                if Col<Colcount then Col:=Col+1
                else begin
                  Row := Row+1;
                end;
                key := 0;
              end;
  end;

  If (goRowSelect in Options) then Options := Options - [goRowSelect];
  end;
  If Shift=[ssShift] then
  Case Key of
  VK_DOWN,VK_UP :
       begin
       If not (goRowSelect in Options) then Options := Options + [goRowSelect];
       copyRowCol := Selection;
       Row1 := Selection.Top;
       Row2 := Selection.Bottom;
       end;
  end;
  If Shift=[ssCtrl] then BEGIN
  Case Key of
  67   : begin                       {^C}
           if Row1>0 then CopyRowsToStream(Row1,Row2);
         end;
  88   : if Row1>0 then begin         {^X}
              CopyRowsToStream(Row1,Row2);
              Deleterecords(Row1,Row2);
              Row1 := -1;
           end;
  86   : begin                        {^V}
           InsertRowsFromStream(Row);
         end;
  end;
    If (goRowSelect in Options) then
       Options := Options - [goRowSelect];
  end;
end;
inherited KeyDown(Key,Shift);
end;


end.
