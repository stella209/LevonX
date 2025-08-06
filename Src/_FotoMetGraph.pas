unit _FotoMetGraph;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus, Vcl.Grids,
  VCLTee.TeEngine, Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart, Dgrid,
  STAF_Imp, VCLTee.Series, janLanguage;

type
  TFotometGrafForm = class(TForm)
    Chart1: TChart;
    DataGrid: TSTDataGrid;
    Series1: TLineSeries;
    Series2: TLineSeries;
    janLanguage1: TjanLanguage;
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    oldLanguage: string;
    procedure InitRefstarList;
  public
  end;

var
  FotometGrafForm: TFotometGrafForm;

implementation

{$R *.dfm}

uses Main_Levon;

procedure TFotometGrafForm.FormActivate(Sender: TObject);
begin
  if oldLanguage <> janLanguage1.GetLang then begin
     janLanguage1.InitLanguage(Self);
     oldLanguage := janLanguage1.LanguageFile;
  end;
  InitRefstarList;
end;

procedure TFotometGrafForm.FormCreate(Sender: TObject);
begin
  janLanguage1.InitLanguage(Self);
end;

procedure TFotometGrafForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then Close;

end;

procedure TFotometGrafForm.InitRefstarList;
var
  Row,aRow: integer;
  sr: TStarRecord;
begin
  DataGrid.Clear;
  Series1.Clear;
  Series2.Clear;
  aRow := 0;
  With MainForm.StarList1 do
       for Row := 0 to Pred(Count) do begin
           sr := Star[Row];
           if sr.Refstar then begin
              Inc(aRow);
              if aRow>1 then DataGrid.NewRec;
              DataGrid.Cells[1,aRow] := Inttostr(sr.ID);
              DataGrid.Cells[2,aRow] := FormatFloat('###.##',sr.Radius);
              DataGrid.Cells[3,aRow] := FormatFloat('###.##',sr.Intensity);
              DataGrid.Cells[4,aRow] := FormatFloat('###.##',sr.mg);
              Series1.AddXY(sr.Intensity,sr.mg,'',clBlue);
           end;
  end;
end;

end.
