unit _SKALAZ;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AL_ToneCurve, AL_ZoomImg, ExtCtrls, StdCtrls, Buttons, janLanguage,
  NewGeom;

type
  TSKALAZASForm = class(TForm)
    ALZ: TALZoomImage;
    Panel1: TPanel;
    ALC: TALToneCurve;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Bevel1: TBevel;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    SpeedButton7: TSpeedButton;
    janLanguage1: TjanLanguage;
    SpeedButton8: TSpeedButton;
    PresetCombo: TComboBox;
    Label1: TLabel;
    btnAdd: TButton;
    SpeedButton9: TSpeedButton;
    procedure ALCRepaint(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure PresetComboEnter(Sender: TObject);
    procedure PresetComboChange(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
  private
    oldLanguage: string;
    FCentrum: TPoint2d;
    FZoom: double;
  public
    function Execute(inBitmap: TBitmap;_cent: TPoint2d;_zoom: double): boolean;
    procedure DoZoom(_cent: TPoint2d;_zoom: double);
    property Zoom: double read FZoom write FZoom;
    property Centrum: TPoint2d read FCentrum write FCentrum;
  end;

var
  SKALAZASForm: TSKALAZASForm;

implementation

{$R *.DFM}

procedure TSKALAZASForm.BitBtn2Click(Sender: TObject);
begin
  if TWincontrol(Sender).Focused then
      ModalResult := mrOk;
end;

procedure TSKALAZASForm.btnAddClick(Sender: TObject);
var pName: string;
begin
  pName := ALC.AddPreset;
  if pName<>'' then
     PresetCombo.Items.Add(pName);
  if PresetCombo.Items.IndexOf(pName) <> -1 then begin
     PresetCombo.ItemIndex:= PresetCombo.Items.IndexOf(pName);
  end;
end;

procedure TSKALAZASForm.PresetComboChange(Sender: TObject);
begin
  if PresetCombo.ItemIndex <> -1 then begin
     ALC.LoadPreset(PresetCombo.ItemIndex);
     ALCRepaint(Nil);
  end;
end;

procedure TSKALAZASForm.PresetComboEnter(Sender: TObject);
begin
  alc.GetCurvesPreset(PresetCombo.Items);
end;

procedure TSKALAZASForm.DoZoom(_cent: TPoint2d;_zoom: double);
begin
  ALZ.sCent := _cent;
  ALZ.Zoom  := _zoom;
  ALZ.ReDraw;
end;

function TSKALAZASForm.Execute(inBitmap: TBitmap;_cent: TPoint2d;_zoom: double): boolean;
begin
Try
     Result := False;
     ALC.imgView := ALZ.WorkBMP;
     ALZ.OrigBMP.assign(inBitmap);
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

procedure TSKALAZASForm.FormActivate(Sender: TObject);
begin
  if oldLanguage <> janLanguage1.GetLang then begin
     janLanguage1.InitLanguage(Self);
     oldLanguage := janLanguage1.LanguageFile;
  end;
end;

procedure TSKALAZASForm.FormCreate(Sender: TObject);
begin
  janLanguage1.InitLanguage(Self);
  oldLanguage := janLanguage1.LanguageFile;
  ALC.PresetPath := ExtractFilePath(Application.ExeName)+'Curves\';
end;

procedure TSKALAZASForm.ALCRepaint(Sender: TObject);
begin
  ALZ.WorkBMP.OnChange := nil;
  ALZ.WorkBMP.Assign(ALZ.OrigBMP);
  ALC.ApplyCurve(ALC.imgView);
  ALZ.ReDraw;
end;

procedure TSKALAZASForm.RadioButton1Click(Sender: TObject);
begin
  ALC.LineType := cuvLinear;
end;

procedure TSKALAZASForm.RadioButton2Click(Sender: TObject);
begin
  ALC.LineType := cuvSpline;
end;

procedure TSKALAZASForm.SpeedButton1Click(Sender: TObject);
begin
  ALC.Reset;
end;

procedure TSKALAZASForm.SpeedButton2Click(Sender: TObject);
begin
  ALC.Invers;
  ALCRepaint(Sender);
end;

procedure TSKALAZASForm.SpeedButton3Click(Sender: TObject);
begin
  ALC.Channel := TComponent(Sender).Tag;
end;

procedure TSKALAZASForm.SpeedButton7Click(Sender: TObject);
begin
  ALZ.RestoreOriginal;
end;

procedure TSKALAZASForm.SpeedButton8Click(Sender: TObject);
begin
  ALZ.FitToScreen;
end;

procedure TSKALAZASForm.SpeedButton9Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to 3 do begin
      ALC.Channel := i;
      ALC.Reset;
  end;
end;

end.
