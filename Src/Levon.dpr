program Levon;

uses
  Forms,
  Histog1 in 'Histog1.pas' {HistogramForm},
  Vcl.Themes,
  Vcl.Styles,
  _SKALAZ in '_SKALAZ.pas' {SKALAZASForm},
  Main_Levon in 'Main_Levon.pas' {MainForm},
  _FullScreen in '_FullScreen.pas' {FullForm},
  _Rsize in '_Rsize.pas' {ResizeDlg},
  _Konvol in '_Konvol.pas' {KonvolForm},
  _Ujform in '_Ujform.pas' {UjForm},
  _About in '_About.pas' {AboutBox},
  _ClipBookView in '_ClipBookView.pas' {ClipbookViewerForm},
  _FlatKorrekt in '_FlatKorrekt.pas' {FlatForm},
  _FixTerDialog in '_FixTerDialog.pas' {FixTerForm},
  Unit_Levon in 'Unit_Levon.pas',
  _FotoMetGraph in '_FotoMetGraph.pas' {FotometGrafForm},
  _Maszk in '_Maszk.pas' {MaszkForm},
  _SablonDlg in '_SablonDlg.pas' {SablonDlg},
  STAF_History in 'STAF_History.pas';

{$R *.RES}

begin
  AboutBox := TAboutBox.Create(Application);
  AboutBox.Show;
  AboutBox.Update;
  Application.Initialize;
  TStyleManager.TrySetStyle('Aqua Light Slate');
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(THistogramForm, HistogramForm);
  Application.CreateForm(TSKALAZASForm, SKALAZASForm);
  Application.CreateForm(TFullForm, FullForm);
  Application.CreateForm(TFixTerForm, FixTerForm);
  Application.CreateForm(TFotometGrafForm, FotometGrafForm);
  Application.CreateForm(TFotometGrafForm, FotometGrafForm);
  Application.CreateForm(TMaszkForm, MaszkForm);
  Application.CreateForm(TSablonDlg, SablonDlg);
  //  Application.CreateForm(TResizeDlg, ResizeDlg);
  Application.CreateForm(TKonvolForm, KonvolForm);
  Application.CreateForm(TUjForm, UjForm);
  Application.CreateForm(TClipbookViewerForm, ClipbookViewerForm);
  Application.CreateForm(TFlatForm, FlatForm);
  //  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
