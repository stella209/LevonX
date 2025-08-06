unit _Rsize;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, Spin, ExtCtrls, janLanguage;

type

  TResizeMode = (resmSimple, resmSmooth, resmBox, resmTriangle, resmHermite,
                 resmBell, resmBSpline, resmLanczos3, resmMitchell);

  TResizeDlg = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    RadioButton1: TRadioButton;
    Label2: TLabel;
    Panel2: TPanel;
    Bevel1: TBevel;
    SpinEdit1: TSpinEdit;
    Label3: TLabel;
    RadioButton2: TRadioButton;
    Button1: TButton;
    Button2: TButton;
    OkBtn: TBitBtn;
    BitBtn2: TBitBtn;
    Label4: TLabel;
    ComboBox1: TComboBox;
    janLanguage1: TjanLanguage;
    procedure RadioButton2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    oldLanguage: string;
    FoldSize: TPoint;
    FnewSize: TPoint;
    FResizeMode: TResizeMode;
    procedure SetnewSize(const Value: TPoint);
    procedure SetoldSize(const Value: TPoint);
    { Private declarations }
  public
    property oldSize: TPoint read FoldSize write SetoldSize;
    property newSize: TPoint read FnewSize write SetnewSize;
    property ResizeMode: TResizeMode read FResizeMode write FResizeMode;
  end;

var
  ResizeDlg: TResizeDlg;

  Function ResizeExecute(var size: TPoint): boolean;

implementation

{$R *.DFM}

Function ResizeExecute(var size: TPoint): boolean;
begin
  ResizeDlg := TResizeDlg.create(Application);
  ResizeDlg.oldSize := size;
  ResizeDlg.newSize := size;
  ResizeDlg.ShowModal;
  Result := ResizeDlg.ModalResult = mrOk;
  if Result then
     size := ResizeDlg.newSize;
  ResizeDlg.free;
end;

{ TResizeDlg }

procedure TResizeDlg.SetnewSize(const Value: TPoint);
begin
  FnewSize := Value;
  Panel2.Caption := IntToStr(Value.x)+' x '+IntToStr(Value.y);
end;

procedure TResizeDlg.SetoldSize(const Value: TPoint);
begin
  FoldSize := Value;
  Panel1.Caption := IntToStr(Value.x)+' x '+IntToStr(Value.y);
end;

procedure TResizeDlg.RadioButton2Click(Sender: TObject);
var scr : TPoint;
    z   : double;
begin
  scr     := Point(Screen.Width,Screen.Height);
  if oldSize.x>oldSize.y then
     z := Screen.Width / oldSize.x
  else
     z := Screen.Height / oldSize.y;
  newSize := Point(Trunc(z*oldSize.x),Trunc(z*oldSize.y));
end;

procedure TResizeDlg.Button1Click(Sender: TObject);
begin
  newSize := Point((oldSize.x div 2),(oldSize.y div 2));
end;

procedure TResizeDlg.Button2Click(Sender: TObject);
begin
  newSize := Point((oldSize.x * 2),(oldSize.y * 2));
end;

procedure TResizeDlg.ComboBox1Click(Sender: TObject);
begin
  ResizeMode := TResizeMode(ComboBox1.ItemIndex);
end;

procedure TResizeDlg.FormActivate(Sender: TObject);
begin
  if oldLanguage <> janLanguage1.GetLang then begin
     janLanguage1.InitLanguage(Self);
     oldLanguage := janLanguage1.LanguageFile;
  end;
end;

procedure TResizeDlg.FormCreate(Sender: TObject);
begin
  janLanguage1.InitLanguage(Self);
  oldLanguage := janLanguage1.LanguageFile;
  ResizeMode := resmSimple;
end;

procedure TResizeDlg.SpinEdit1Change(Sender: TObject);
var Percent: double;
begin
  Percent := SpinEdit1.Value/100;
  newSize := Point(Round(oldSize.x * Percent),Round(oldSize.y * Percent));
end;

end.
