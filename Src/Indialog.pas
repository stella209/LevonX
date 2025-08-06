unit Indialog;

interface

uses SysUtils, WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls {, DsgnIntf};

Type

  TInDlgForm = class(TForm)
  private
    procedure FormActivate(Sender: TObject);
  public
  end;

  TInDlg = class(TComponent)
  private
    IndlgForm: TForm;
    FAbout: string;
    procedure SetAbout(Value:string);
  public
    constructor Create(AOwner:TComponent);override;
    function Execute(Focim:String;Adatszam:integer;labelek:array of string;
                        var Editertekek:array of string):boolean; overload;
  published
    Property About: string read FAbout write SetAbout;
  end;
(*
  TAboutEditor = class(TComponentEditor)
  public
    FAboutDialog : TForm;
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;
*)
procedure Register;

implementation

constructor TInDlg.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FAbout := 'StellaSOFT Multi Input Dialog';
end;

procedure TInDlg.SetAbout(Value:string);
begin
  FAbout := 'StellaSOFT Multi Input Dialog';
end;

function TInDlg.Execute(Focim:String;Adatszam:integer;labelek:array of string;
                        var Editertekek:array of string):boolean;
var i,lepes:integer;
    pan: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    feliratok : TLabel;
    editek : Tedit;
begin
  IndlgForm:=TForm.Create(Application);
    lepes := 20;
  With IndlgForm do begin
    Name := 'InDlgForm';
    BorderStyle := bsDialog;
    position    := poScreenCenter;
    Caption     := Focim;
    pan := TPanel.Create(IndlgForm);
    pan.Align   :=alBottom;
    pan.parent  :=IndlgForm;
    Clientheight := lepes*(adatszam+2)+Pan.Height;
    ClientWidth  := 280;
    OKBtn:=TBitBtn.Create(IndlgForm);
    CancelBtn:= TBitBtn.Create(IndlgForm);
    With OkBtn do begin
      Top := (pan.Height - OkBtn.Height) div 2;
      Width := (pan.width div 2)-8;
      Left:=  4;
      Name := 'OkBtn';
      Kind := bkOk;
      Parent := pan;
    end;
    With CancelBtn do begin
      Top := (pan.Height - Height) div 2;
      Width := (pan.width div 2)-8;
      Left:= (pan.width div 2) + 4;
      Name := 'CancelBtn';
      Kind := bkCancel;
      Caption := 'Mégsem';
      Parent := pan;
    end;
    For i:=1 to adatszam do begin
      feliratok:=TLabel.Create(IndlgForm);
      With Feliratok do begin
           Parent := IndlgForm;
           Name   := 'Label'+Inttostr(i);
           Caption:= labelek[i-1];
           Top    := i*lepes+4;
           Left   := 10;
           width  := (IndlgForm.width - 10) div 2;
      end;
      editek:=TEdit.Create(IndlgForm);
      With editek do begin
           Parent := InDlgForm;
           Name   := 'Edit'+Inttostr(i);
           Try
              Text   := editertekek[i-1];
           except
              Text   := '';
           end;
           Top    := Top+i*lepes;
           Left   := InDlgForm.width div 2;
           TabOrder:= i-1;
      end;
    end;
    ShowModal;
    Result := Modalresult = mrOk;
    For i:=1 to adatszam do begin
        Editertekek[i-1]:=(FindComponent('Edit'+Inttostr(i)) as TEdit).Text;
    end;
    Free;
  end;
end;

procedure TInDlgForm.FormActivate(Sender: TObject);
Var     TheComponent: TComponent;
begin
  TheComponent := FindComponent('Edit1');
  (TheComponent as TEdit).SetFocus;
end;

procedure Register;
begin
  RegisterComponents('AL',[TInDlg]);
//  RegisterComponentEditor(TInDlg, TAboutEditor);
end;

(*
procedure TAboutEditor.Edit;
begin
  ExecuteVerb(0);
end;

procedure TAboutEditor.ExecuteVerb;
var l1 : TMemo;
begin
    FAboutDialog := TForm.Create(Application);
    With FAboutDialog do begin
         Position := poScreenCenter;
         width    := 450; Height := 400;
         Caption  := 'StellaSOFT Multi Input Dialog';
         l1 := TMemo.Create(Application);
         l1.Parent := FAboutDialog;
         l1.Align  := alClient;
    {     l1.Enabled:= False;}
         l1.Lines.Add('function Execute(');
         l1.Lines.Add('   Caption     :String');
         l1.Lines.Add('   DataCount   :integer');
         l1.Lines.Add('   labelsText  :array of string');
         l1.Lines.Add('   var EditVariables : array of string');
         l1.Lines.Add('                ):boolean;');
         l1.Lines.Add('');
         l1.Lines.Add('Pl.procedure TForm1.Button1Click(Sender: TObject);');
         l1.Lines.Add('var a: array[1..3] of string;');
         l1.Lines.Add('b: string;');
         l1.Lines.Add('begin');
         l1.Lines.Add(' a[1]:= FloatToStr(100.23);');
         l1.Lines.Add(' a[2]:= FloatToStr(200);');
         l1.Lines.Add(' a[3]:= FloatToStr(300);');
         l1.Lines.Add(' If InDlg1.Execute(''''Centrum koordináták'''',3,[''''K[EOV]:'''',''''K :'''',''''Uj''''],a)');
         l1.Lines.Add(' then begin');
         l1.Lines.Add('      label1.caption:=a[1];');
         l1.Lines.Add('      label2.caption:=a[2];');
         l1.Lines.Add(' end;');
         l1.Lines.Add('end;');
    end;
    try
     	FAboutDialog.ShowModal;
    finally
        FAboutDialog.Free;
    end;
end;

function TAboutEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'About Input Dialog';
    else Result := '';
  end;
end;

function TAboutEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;
*)
end.
