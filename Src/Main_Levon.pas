unit Main_Levon;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, ExtDlgs, Buttons, VCL.Themes, IniFiles,
  Vcl.ToolWin, Vcl.ImgList, Vcl.Menus, System.Actions, Vcl.ActnList,
  Vcl.StdActns, Vcl.ExtActns, WinInet, ShellApi, Vcl.Grids, Vcl.CheckLst,
  Resample, Math, Vcl.FileCtrl, RzStatus, RzPanel, RzSplit,
  DeLaFitsCommon,
  DeLaFitsString,
  DeLaFitsGraphics,
  DeLaFitsMath,
  janLanguage,
  AL_ZoomImg, STAF_Imp, StObjects, STAF_Image, Newgeom, STAF_AstroUnit,
  Al_TSpeedButton, Szoveg, Dgrid, STAF_History, RzButton;

Const PixelMax = 10000;
      EOL     = CHR(13)+CHR(10);

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

  TNoiseReductRecord = record
     Factor          : double;
     BackLevel       : byte;
     RGBParam        : TRGBParam;
  end;

  TProgramMode = (pmoGeneral,pmoAstro);

  pClipBoolItem = ^TClipBoolItem;
  TClipBoolItem = record
    Stream      : TMemoryStream;
  end;

  TClipBook = class(TList)
  private
    FOnChange: TNotifyEvent;
    FActIndex: integer;
    FFileName: string;
    FClipBoardAction: TClipBoardAction;
    function GetBITMAPS(index: integer): TBitmap;
    procedure SetBITMAPS(index: integer; const Value: TBitmap);
    procedure SetFileName(const Value: string);
  public
    procedure NewList(n: integer);
    procedure AddBMP(bmp: TBitmap);
    function  GetBMP(idx: integer): TBitmap;
    procedure DeleteBMP(idx: integer);
    function  IsEmpty(idx: integer): boolean;
    property ActIndex    : integer read FActIndex write FActIndex;
    property ClipBoardAction: TClipBoardAction read FClipBoardAction
                                                    write FClipBoardAction;
    property FileName    : string read FFileName write SetFileName;
    property BITMAPS[index: integer]: TBitmap read GetBITMAPS write SetBITMAPS;
    property OnChange    : TNotifyEvent read FOnChange write FOnChange;
  end;

  TMainForm = class(TForm)
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    Button1: TButton;
    Button2: TButton;
    Button5: TButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    OpenDialog: TOpenDialog;
    MonoButton: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Button9: TButton;
    SaveDialog: TSaveDialog;
    MeretezButton: TButton;
    Label6: TLabel;
    SpeedButton7: TSpeedButton;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    Fjl1: TMenuItem;
    Kpbetlts1: TMenuItem;
    Kpments1: TMenuItem;
    N1: TMenuItem;
    Nyomtatsikp1: TMenuItem;
    Nyomtats1: TMenuItem;
    N2: TMenuItem;
    Kilps1: TMenuItem;
    Nzet1: TMenuItem;
    eljeskpernys1: TMenuItem;
    N3: TMenuItem;
    Kzpkereszt1: TMenuItem;
    Kurzorkereszt1: TMenuItem;
    Mrrcs1: TMenuItem;
    Monokrm1: TMenuItem;
    N4: TMenuItem;
    RGBMindenszn1: TMenuItem;
    RVrs1: TMenuItem;
    GZld1: TMenuItem;
    BKk1: TMenuItem;
    Szerkeszts1: TMenuItem;
    ActionList1: TActionList;
    FullScreen: TAction;
    Levons1: TMenuItem;
    CentralCross: TAction;
    Meroracs: TAction;
    Levonas: TAction;
    Histogram1: TMenuItem;
    Sklzs1: TMenuItem;
    Konvolci1: TMenuItem;
    N6: TMenuItem;
    lests1: TMenuItem;
    Medinszrs1: TMenuItem;
    Javt1: TMenuItem;
    Undo1: TMenuItem;
    Redo1: TMenuItem;
    N5: TMenuItem;
    Beilleszt1: TMenuItem;
    Msol1: TMenuItem;
    SpecilisBeillaszts1: TMenuItem;
    N7: TMenuItem;
    Cropkijellt1: TMenuItem;
    Md1: TMenuItem;
    mod_0: TMenuItem;
    mod_1: TMenuItem;
    Segt1: TMenuItem;
    N8: TMenuItem;
    Belltsok1: TMenuItem;
    N9: TMenuItem;
    tmretezs1: TMenuItem;
    Eredetimret1: TMenuItem;
    Export1: TMenuItem;
    RGBklnfjlba1: TMenuItem;
    FITfjlba1: TMenuItem;
    Import1: TMenuItem;
    N10: TMenuItem;
    RGBfjlokbl1: TMenuItem;
    FITfjbl1: TMenuItem;
    Segt2: TMenuItem;
    N11: TMenuItem;
    Programrl1: TMenuItem;
    jverzletltse1: TMenuItem;
    Grafika1: TMenuItem;
    Felirat1: TMenuItem;
    Grafikuseszkzk1: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    Csillagkijells1: TMenuItem;
    Grafikusrtegbeki1: TMenuItem;
    Grafikaakpre1: TMenuItem;
    Rajzol1: TMenuItem;
    Vonal1: TMenuItem;
    Sokszgvonal1: TMenuItem;
    Zrtsokszg1: TMenuItem;
    Kr1: TMenuItem;
    Ellipszis1: TMenuItem;
    v1: TMenuItem;
    Splne1: TMenuItem;
    Szabadkzirajz1: TMenuItem;
    jgrafika1: TMenuItem;
    StarDetect: TAction;
    PreciseStarDetect: TAction;
    ASTRO1: TMenuItem;
    PreczisStarDetect1: TMenuItem;
    N12: TMenuItem;
    ZoomPopupMenu: TPopupMenu;
    N111: TMenuItem;
    Kpernyhzilleszts1: TMenuItem;
    N15: TMenuItem;
    N101: TMenuItem;
    N501: TMenuItem;
    N1001: TMenuItem;
    N2001: TMenuItem;
    eljeskp1: TMenuItem;
    LevonPopup: TPopupMenu;
    Klasszikus1: TMenuItem;
    Kiegyenslyooztt1: TMenuItem;
    Csillagokltszanak1: TMenuItem;
    SpecilisMsols1: TMenuItem;
    eljeskpet1: TMenuItem;
    Kpernykpet1: TMenuItem;
    Kivlasztottterletet1: TMenuItem;
    Kpernynkivlaszottterletet1: TMenuItem;
    Fixterletet1: TMenuItem;
    Fixterletetakpernyrl1: TMenuItem;
    Kpltszik1: TMenuItem;
    Grafikusfelletltszik1: TMenuItem;
    N16: TMenuItem;
    VirtulisFlatkorrekci1: TMenuItem;
    CopyPopupMenu: TPopupMenu;
    eljeskpet2: TMenuItem;
    Kpernykpet2: TMenuItem;
    Kpenkijelltterletet1: TMenuItem;
    Kpernynkijel9ltterletet1: TMenuItem;
    CsillagListaMentse1: TMenuItem;
    CsillaglistaTrlse1: TMenuItem;
    AutoFotometria1: TMenuItem;
    Krablakban1: TMenuItem;
    N17: TMenuItem;
    AutoWhiteBllance1: TMenuItem;
    ContrastStretch1: TMenuItem;
    janLanguage1: TjanLanguage;
    N18: TMenuItem;
    Language1: TMenuItem;
    N19: TMenuItem;
    StyleMenu: TMenuItem;
    mnuUjratoltes: TMenuItem;
    N20: TMenuItem;
    Button18: TButton;
    DataPage: TPageControl;
    AlapPage: TTabSheet;
    Panel2: TPanel;
    Bevel1: TBevel;
    Label1: TLabel;
    ParLabel: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LEVONButton: TButton;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    REdit: TEdit;
    BEdit: TEdit;
    GEdit: TEdit;
    Button4: TButton;
    Button6: TButton;
    HistoButton: TButton;
    SkalaButton: TButton;
    TrackBar3: TTrackBar;
    ElesButton: TButton;
    KonvolButton: TButton;
    MedianButton: TButton;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    UpDown3: TUpDown;
    MaszkButton: TButton;
    Button16: TButton;
    Button19: TButton;
    astroPage: TTabSheet;
    PosLabel: TLabel;
    Label10: TLabel;
    StarCountLabel: TLabel;
    Button7: TButton;
    StarVisibleCB: TCheckBox;
    ThresholdBar: TTrackBar;
    PixelGridCB: TCheckBox;
    Button8: TButton;
    Button10: TButton;
    Button15: TButton;
    VisImageCB: TCheckBox;
    Button17: TButton;
    FotometPage: TTabSheet;
    PHZ: TALZoomImage;
    ALRGBDiagram2: TALRGBDiagram;
    GroupBox1: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    pStarPosLabel: TLabel;
    pRadiusLabel: TLabel;
    pIntensityLabel: TLabel;
    Label14: TLabel;
    pNoLabel: TLabel;
    Label15: TLabel;
    pIntLogLabel: TLabel;
    Button13: TButton;
    GroupBox2: TGroupBox;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    lGmg: TLabel;
    lRa: TLabel;
    lDe: TLabel;
    Button14: TButton;
    CsillagListPage: TTabSheet;
    Panel4: TPanel;
    Panel5: TPanel;
    Label16: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    LBId: TLabel;
    Label17: TLabel;
    SpeedButton19: TSpeedButton;
    SpeedButton20: TSpeedButton;
    SpeedButton21: TSpeedButton;
    SpeedButton22: TSpeedButton;
    LbRefCount: TLabel;
    ChRef: TCheckBox;
    EdGmg: TEdit;
    EdRa: TEdit;
    EdDe: TEdit;
    Memo2: TMemo;
    sGrid: TSTDataGrid;
    OpenTabSheet: TTabSheet;
    Splitter3: TSplitter;
    DriveComboBox2: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    FileListBox1: TFileListBox;
    Splitter1: TSplitter;
    Panel3: TPanel;
    ToolPages: TPageControl;
    TabSheet3: TTabSheet;
    ToolBar2: TToolBar;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton34: TToolButton;
    ALTimerSpeedButton2: TALTimerSpeedButton;
    ALTimerSpeedButton1: TALTimerSpeedButton;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
    ToolButton23: TToolButton;
    ToolButton24: TToolButton;
    ToolButton25: TToolButton;
    ToolButton26: TToolButton;
    ToolButton27: TToolButton;
    ToolButton28: TToolButton;
    ToolButton29: TToolButton;
    ToolButton30: TToolButton;
    ToolButton32: TToolButton;
    TabSheet4: TTabSheet;
    ToolBar1: TToolBar;
    ToolButton9: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton31: TToolButton;
    TabSheet6: TTabSheet;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    SpeedButton15: TSpeedButton;
    SpeedButton16: TSpeedButton;
    SpeedButton17: TSpeedButton;
    SpeedButton18: TSpeedButton;
    Button3: TButton;
    Button11: TButton;
    Button12: TButton;
    TabSheet2: TTabSheet;
    Label26: TLabel;
    btnHistRun: TRzToolButton;
    IPLEdit: TEdit;
    IPLCombo: TComboBox;
    Panel6: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel7: TPanel;
    Splitter2: TSplitter;
    SpeedButton12: TSpeedButton;
    ALZ: TALZoomImage;
    ALRGBDiagram1: TALRGBDiagram;
    HISTORY: TTabSheet;
    HistPanel: TRzSizePanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Label25: TLabel;
    SablonNevEdit: TEdit;
    CheckListHistory: TCheckListBox;
    Panel10: TPanel;
    HistMemo: TMemo;
    Panel11: TPanel;
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    btnREC: TButton;
    Button24: TButton;
    btnRUN: TButton;
    btnSTEP: TButton;
    HistListPopupMenu: TPopupMenu;
    LEJRSZS1: TMenuItem;
    LPTETS1: TMenuItem;
    N22: TMenuItem;
    Mindentkijell1: TMenuItem;
    Ellentteskijells1: TMenuItem;
    N23: TMenuItem;
    Kijelltektrlse1: TMenuItem;
    Nemkijelltektrlse1: TMenuItem;
    jlista1: TMenuItem;
    btnSalonLoad: TRzToolButton;
    btnSablonSave: TRzToolButton;
    mASZKOLS1: TMenuItem;
    Flatkorrekci1: TMenuItem;
    Kpmezkeretezs1: TMenuItem;
    glalap1: TMenuItem;
    SABLONOK1: TMenuItem;
    N21: TMenuItem;
    btnKeparany: TRzMenuButton;
    btnHistList: TSpeedButton;
    ToolButton1: TToolButton;
    Sablontr1: TMenuItem;
    N24: TMenuItem;
    Sablonbetltse1: TMenuItem;
    Sablonmentse1: TMenuItem;
    N25: TMenuItem;
    LEJRSZS2: TMenuItem;
    LPTETS2: TMenuItem;
    N26: TMenuItem;
    jlista2: TMenuItem;
    Mindentkijell2: TMenuItem;
    Ellentteskijells2: TMenuItem;
    N27: TMenuItem;
    Kijelltektrlse2: TMenuItem;
    Nemkijelltektrlse2: TMenuItem;
    RECShape: TShape;
    RecLabel: TLabel;
    btnListDown: TRzToolButton;
    btnListUp: TRzToolButton;
    cbFromOrigin: TCheckBox;
    RzToolButton1: TRzToolButton;
    ToolButton2: TToolButton;
    MemoryProgress: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ALZChangeWindow(Sender: TObject; xCent, yCent, xWorld,
      yWorld, Zoom: Double; MouseX, MouseY: Integer);
    procedure LEVONButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure REditKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button6Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure MonoButtonClick(Sender: TObject);
    procedure MedianButtonClick(Sender: TObject);
    procedure HistoButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure SkalaButtonClick(Sender: TObject);
    procedure MeretezButtonClick(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
    procedure ElesButtonClick(Sender: TObject);
    procedure KonvolButtonClick(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure ToolButton10Click(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure ToolButton13Click(Sender: TObject);
    procedure ToolButton14Click(Sender: TObject);
    procedure ToolButton15Click(Sender: TObject);
    procedure FullScreenExecute(Sender: TObject);
    procedure Kurzorkereszt1Click(Sender: TObject);
    procedure DialogOpenPicture1Accept(Sender: TObject);
    procedure CentralCrossExecute(Sender: TObject);
    procedure MeroracsExecute(Sender: TObject);
    procedure LevonasExecute(Sender: TObject);
    procedure Cropkijellt1Click(Sender: TObject);
    procedure Javt1Click(Sender: TObject);
    procedure Kilps1Click(Sender: TObject);
    procedure Undo1Click(Sender: TObject);
    procedure Redo1Click(Sender: TObject);
    procedure Msol1Click(Sender: TObject);
    procedure Beilleszt1Click(Sender: TObject);
    procedure ALZMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RGBMindenszn1Click(Sender: TObject);
    procedure Monokrm1Click(Sender: TObject);
    procedure j1Click(Sender: TObject);
    procedure tmretezs1Click(Sender: TObject);
    procedure Eredetimret1Click(Sender: TObject);
    procedure RGBklnfjlba1Click(Sender: TObject);
    procedure mod_0Click(Sender: TObject);
    procedure mod_1Click(Sender: TObject);
    procedure Programrl1Click(Sender: TObject);
    procedure jverzletltse1Click(Sender: TObject);
    procedure SpecilisBeillaszts1Click(Sender: TObject);
    procedure ThresholdBarChange(Sender: TObject);
    procedure ALZAfterPaint(Sender: TObject; xCent, yCent: Double;
      DestRect: TRect);
    procedure StarVisibleCBClick(Sender: TObject);
    procedure PixelGridCBClick(Sender: TObject);
    procedure StarDetectExecute(Sender: TObject);
    procedure PreciseStarDetectExecute(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure ALZMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ALZMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ToolButton23Click(Sender: TObject);
    procedure ToolButton24Click(Sender: TObject);
    procedure N2001Click(Sender: TObject);
    procedure ToolButton32Click(Sender: TObject);
    procedure eljeskp1Click(Sender: TObject);
    procedure DataPageChange(Sender: TObject);
    procedure PHZChangeWindow(Sender: TObject; xCent, yCent, xWorld, yWorld,
      Zoom: Double; MouseX, MouseY: Integer);
    procedure PHZMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Kiegyenslyooztt1Click(Sender: TObject);
    procedure Csillagokltszanak1Click(Sender: TObject);
    procedure sGridClick(Sender: TObject);
    procedure Fixterletetakpernyrl1Click(Sender: TObject);
    procedure Kpltszik1Click(Sender: TObject);
    procedure SpeedButton8MouseEnter(Sender: TObject);
    procedure SpeedButton8MouseLeave(Sender: TObject);
    procedure REditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UpDown1ChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Integer; Direction: TUpDownDirection);
    procedure VirtulisFlatkorrekci1Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure SpeedButton21Click(Sender: TObject);
    procedure sGridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure SpeedButton22Click(Sender: TObject);
    procedure SpeedButton19Click(Sender: TObject);
    procedure SpeedButton20Click(Sender: TObject);
    procedure sGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Button14Click(Sender: TObject);
    procedure CsillagListaMentse1Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure VisImageCBClick(Sender: TObject);
    procedure Segt2Click(Sender: TObject);
    procedure MaszkButtonClick(Sender: TObject);
    procedure ToolButton34Click(Sender: TObject);
    procedure Krablakban1Click(Sender: TObject);
    procedure RVrs1Click(Sender: TObject);
    procedure GZld1Click(Sender: TObject);
    procedure BKk1Click(Sender: TObject);
    procedure FITfjbl1Click(Sender: TObject);
    procedure AutoWhiteBllance1Click(Sender: TObject);
    procedure ContrastStretch1Click(Sender: TObject);
    procedure Language1Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Kpments1Click(Sender: TObject);
    procedure ALTimerSpeedButton1TimerEvent(Sender: TObject);
    procedure ALTimerSpeedButton2TimerEvent(Sender: TObject);
    procedure mnuUjratoltesClick(Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
    procedure Kpbetlts1Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure btnHistRunClick(Sender: TObject);
    procedure IPLEditEnter(Sender: TObject);
    procedure IPLEditExit(Sender: TObject);
    procedure ToolPagesChange(Sender: TObject);
    procedure ToolPagesChanging(Sender: TObject; var AllowChange: Boolean);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure btnRECClick(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure btnRUNClick(Sender: TObject);
    procedure btnSTEPClick(Sender: TObject);
    procedure jlista1Click(Sender: TObject);
    procedure Mindentkijell1Click(Sender: TObject);
    procedure Ellentteskijells1Click(Sender: TObject);
    procedure Kijelltektrlse1Click(Sender: TObject);
    procedure Nemkijelltektrlse1Click(Sender: TObject);
    procedure btnHistListClick(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure CheckListHistoryDblClick(Sender: TObject);
    procedure btnSalonLoadClick(Sender: TObject);
    procedure btnSablonSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnListDownClick(Sender: TObject);
    procedure btnListUpClick(Sender: TObject);
    procedure CheckListHistoryKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eljeskpet2Click(Sender: TObject);
    procedure Button3DropDownClick(Sender: TObject);
  private
    UR : TUndoRedo;
    RecTimer: TTimer;
    statusstring: string;
    dt1, dt2: TTime;
    FParam: double;
    FpicFile: string;
    FProgramMode: TProgramMode;
    cBook : array[0..9] of TBitmap;
    cBookIndex : integer;
    Levon1 : TNoiseReductRecord;
    Levon2 : TNoiseReductRecord;
    FStarVisible: boolean;
    FImageVisible: boolean;
    procedure SetParam(const Value: double);
    procedure UndoSave(var MemSt:TMemoryStream);
    procedure UndoRedo(MemSt:TMemoryStream);
    procedure OnUndoRedo(Sender:TObject; Undo,Redo:boolean);
    procedure OnRecording(Sender:TObject; Rec:boolean);
    procedure SetpicFile(const Value: string);
    procedure FullScreen1Click(Sender: TObject);
    procedure StatusStart(s: string);
    procedure StatusEnd;
    procedure SetProgramMode(const Value: TProgramMode);
    procedure DownloadNewVersion;
    procedure StarDraw(StarList: TStarList; col: TColor);
    procedure StarListChange(Sender: TObject);
    procedure GetGridRow(Row: integer; sr: TStarRecord);
    procedure SetGridRow(Row: integer; sr: TStarRecord);
    procedure StarDataWrite(No: Integer);
    procedure StarDataRead(No: Integer);
    procedure SetStarVisible(const Value: boolean);
    procedure SetImageVisible(const Value: boolean);
    procedure SaveImage;
    procedure StyleClick(Sender: TObject);
    procedure AddHistory(sor: string);
    procedure AddLocalHistory(sor: string);
    procedure DoZoom(_cent: TPoint2d; _zoom: double);
    procedure LoadSablon;
    procedure SaveSablon;
    procedure OnRectimer(Sender: TObject);
    procedure OnPicChange(Sender: TObject);
  public
    StarList1 : TStarList;
    ClipBook  : TClipBook;
    FFit: TFitsFileBitmap;
    IPLHistory : TIPLHistory;
    ShortCutEnable : boolean; // Engedi/Tiltja az egybetûs menü parancsokat
    procedure GridInit;
    property Param       : double read FParam write SetParam;
    property picFile     : string read FpicFile write SetpicFile;
    property ProgramMode : TProgramMode read FProgramMode write SetProgramMode;
    property StarVisible : boolean read FStarVisible write SetStarVisible;
    property ImageVisible: boolean read FImageVisible write SetImageVisible;
  end;

var
  MainForm: TMainForm;
  elso : boolean = True;
  focim: string;
  ExeDir: string;

//function LoadImageFromFile(const FileName: string; Bmp: TBitmap): Boolean;

function IntToByte(i:Integer):Byte;
function FloatToByte(i:double):Byte;
function HistogramInit: TRGBColorsArray;
function RGBStatisticInit: TRGBStatisticArray;
function GetRGBHistogram(Bitmap: TBitmap): TRGBColorsArray;
function GetRGBStatistic(Bitmap: TBitmap): TRGBStatisticArray;
function GetRGBStatisticMax(Bitmap: TBitmap): TRGB24;
procedure AutoNoiseReduction(Bitmap: TBitmap; Method: integer; factor: DOUBLE;
                             BackLevel: byte; RGBParam: TRGBParam);
procedure ExtractRChanel(src,dst: TBitmap);
procedure ExtractGChanel(src,dst: TBitmap);
procedure ExtractBChanel(src,dst: TBitmap);

function PhotoMetryG(Bitmap: TBitmap; p: TPoint2d; Radius: double; Level: integer): double;

function DownloadFile(
    const url: string;
    const destinationFileName: string): boolean;
function DownloadURL_NOCache(const aUrl: string; var s: String): Boolean;

implementation

{$R *.DFM}

uses Histog1, _SKALAZ, _FullScreen, _Rsize, _Konvol, _Ujform, _About,
  _ClipBookView, _FlatKorrekt, _FixTerDialog, Unit_Levon, _FotoMetGraph, _Maszk;

// Calculate the centre position of the star
// Csillag középpont meghatározás
function GetStarCentroid(Bitmap: TBitmap;x, y, Radius: double): TPoint2d;
var i,x0,y0: integer;
    xx,yy: integer;
    XPos,YPos: double;
    XI,YI: double;
    d: double;
    n: integer;
    nPixel: integer;
    co   : TColor;
begin
  x0 := Round(x-Radius);     // befoglaló négyzet bal felsõ sarka
  y0 := Round(y-Radius);
  n  := Round(2*Radius+2);   // befoglaló négyzet oldala
  nPixel := 0;
  XPos := 0; YPos := 0;
  XI := 0; YI := 0;
  With Bitmap.Canvas do
    for yy:=y0 to y0+n do begin
        for xx:=x0 to x0+n do begin
           d := SQRt(SQR(X-XX)+SQR(Y-YY));
           IF d<=Radius then begin           // Ha a mérõkörbe esik
              co := GetGValue(Pixels[xx,yy]);
              XPos := XPos + (xx-x0) * co;
              YPos := YPos + (yy-y0) * co;
              XI   := XI + co;
              YI   := YI + co;
              Inc(nPixel);
           end;
        end;
    end;
    Result.x := x0;
    Result.y := y0;
    if XI>0 then begin
      Result.x := x0 + XPos / XI;
      Result.y := y0 + YPos / YI;
    end;
end;

function PhotoMetryG(Bitmap: TBitmap; p: TPoint2d; Radius: double; Level: integer): double;
var StarCent : TPoint2D;         // Centre of star
    scPoint  : TPoint;
    Row      : ^TRGBTripleArray;
    H,V      : Integer;
    sIntensity:Integer;
    x1,x2,y1,y2: integer;
    xdif     : integer;
begin
  // Összegzi a G csatorna intenzitásait a p pont körüli Radius sugarú
  // körön belül azon pixelekre, melyeknek értéke >= Level
   Result := 0;
   StarCent      := GetStarCentroid(Bitmap,Trunc(p.x),Trunc(p.y),Radius);

   sIntensity := 0;
   x1 := Trunc(p.X - Radius);   // befoglaló négyzet
   x2 := Round(p.X + Radius);
   y1 := Trunc(p.Y - Radius);
   y2 := Round(p.Y + Radius);
   if (x1<0) or (x2>Bitmap.Width) or (y1<0) or (y2>Bitmap.Height) then exit;
   for V:=y1 to y2 do
   if V<Bitmap.Height then begin
    Row:=Bitmap.ScanLine[V];
    for H:=x1 to x2 do
        if Sqrt(sqr(p.x-h)+sqr(p.y-v))<Radius then
        with Row[H] do
             if  rgbtGreen > Level then
                 Inc( sIntensity, rgbtGreen );
   end;
   Result := sIntensity;
end;

function DownloadFile(
    const url: string;
    const destinationFileName: string): boolean;
var
  hInet: HINTERNET;
  hFile: HINTERNET;
  localFile: File;
  buffer: array[1..1024] of byte;
  bytesRead: DWORD;
begin
  result := False;
  hInet := InternetOpen(PChar(application.title),
    INTERNET_OPEN_TYPE_PRECONFIG,nil,nil,0);
  hFile := InternetOpenURL(hInet,PChar(url),nil,0,0,0);
  if Assigned(hFile) then
  begin
    AssignFile(localFile,destinationFileName);
    Rewrite(localFile,1);
    repeat
      InternetReadFile(hFile,@buffer,SizeOf(buffer),bytesRead);
      BlockWrite(localFile,buffer,bytesRead);
    until bytesRead = 0;
    CloseFile(localFile);
    result := true;
    InternetCloseHandle(hFile);
  end;
  InternetCloseHandle(hInet);
end;


function DownloadURL_NOCache(const aUrl: string; var s: String): Boolean;
var
  hSession: HINTERNET;
  hService: HINTERNET;
  lpBuffer: array[0..1024 + 1] of Char;
  dwBytesRead: DWORD;
begin
  Result := False;
  s := '';
  // hSession := InternetOpen( 'MyApp', INTERNET_OPEN_TYPE_DIRECT, nil, nil, 0);
  hSession := InternetOpen('MyApp', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  try
    if Assigned(hSession) then
    begin
      hService := InternetOpenUrl(hSession, PChar(aUrl), nil, 0, INTERNET_FLAG_RELOAD, 0);
      if Assigned(hService) then
        try
          while True do
          begin
            dwBytesRead := 1024;
            InternetReadFile(hService, @lpBuffer, 1024, dwBytesRead);
            if dwBytesRead = 0 then break;
            lpBuffer[dwBytesRead] := #0;
            s := s + lpBuffer;
          end;
          Result := True;
        finally
          InternetCloseHandle(hService);
        end;
    end;
  finally
    InternetCloseHandle(hSession);
  end;
end;
(*
procedure TMainForm.DownloadNewVersion;
var sl : TStringList;
    newVersion: string;
    setupFile: string;
begin
// Letölti a Version.txt fájlt
Try
 if DownloadURL_NOCache('http://stella.kojot.co.hu/StarFactory/Prog/Levon/version.txt', newVersion)
then
Try
  if Version < newVersion then begin
  if MessageDlg('Új verzió a net-en ='+newVersion+' Letöltés indulhat?',
                mtInformation, [mbYes, mbNo], 0, mbYes) = mrYes then
  begin
     StatusStart('setup_LevonX.EXE: Új verzió letöltése folyamatban ...');
     setupFile := ExeDir+'setup_LevonX_'+newVersion+'.exe';
     DownloadFile(
     'http://stella.kojot.co.hu/StarFactory/Prog/Levon/setup_LevonX.exe',
     setupFile);
     StatusEnd;
     ShellExecute(handle, 'open', PChar(setupFile), nil, nil, SW_SHOWNORMAL);
     Close;
  end;
  end;
Finally
  sl.Free;
End;
except
  exit;
End;
end;
*)

procedure TMainForm.DownloadNewVersion;
var sl : TStringList;
    newVersion: string;
    setupFile: string;
begin
// Letölti a Version.txt fájlt
Try
if DownloadFile(
    'http://stella.kojot.co.hu/StarFactory/Prog/Levon/version.txt',
    ExtractFilePath(Application.ExeName)+'NewVersion.txt')
then
Try
  sl := TStringList.Create;
  sl.LoadFromFile('NewVersion.txt');
  newVersion := Trim(sl.Text);
  if Version < newVersion then begin
  if MessageDlg('Új verzió a net-en ='+sl.Text+' Letöltés indulhat?',
                mtInformation, [mbYes, mbNo], 0, mbYes) = mrYes then
  begin
     StatusStart('setup_LevonX.EXE: Új verzió letöltése folyamatban ...');
     setupFile := ExeDir+'setup_LevonX_'+newVersion+'.exe';
     DownloadFile(
     'http://stella.kojot.co.hu/StarFactory/Prog/Levon/setup_LevonX.exe',
     setupFile);
     StatusEnd;
     ShellExecute(handle, 'open', PChar(setupFile), nil, nil, SW_SHOWNORMAL);
     Close;
  end;
  end;
Finally
  sl.Free;
End;
except
  exit;
End;
end;
(*
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
    BMP.PixelFormat := pf24bit;
  finally
    W.Free;
    Screen.Cursor := crDefault;
  end;
end;
*)
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

(* AUTOMATIC NOISE REDUCTION for Images
   ____________________________________
   Method     : 0=Classic; 1=Ballanced
   Factor     : Multiplicator
   BackLecel  : Bellow level is gray
   RGBParam   : Multiplicator RGB levels - 0.5...1...1.5
*)
procedure AutoNoiseReduction(Bitmap: TBitmap; Method: integer; factor: DOUBLE;
                             BackLevel: byte; RGBParam: TRGBParam);
var avgTres  : TRGB24;
    Row      : pRGBTripleArray;
    Rfactor,Gfactor,Bfactor: double;
    BF       : double;
    x,y      : integer;
begin
  // Meghaározzuk az átlagos RGB zaj szintet
  //  factor:=3; ÉRTÉKNÉL JÓ EREDMÉNY VÁRHATÓ
  avgTres := GetRGBStatisticMax(Bitmap);
  BF := (100-BackLevel)/100;
  Rfactor := RGBParam.RParam * factor*(1+avgTres.R/255);
  Gfactor := RGBParam.GParam * factor*(1+avgTres.G/255);
  Bfactor := RGBParam.BParam * factor*(1+avgTres.B/255);
  // Az ez alatti zajt eltávolítjuk, levágjuk, majd visszaszorozzuk
  Bitmap.PixelFormat := pf24bit;

  case Method of

  0:
  Begin
  for y:=0 to Bitmap.height-1 do begin
    Row:=Bitmap.scanline[y];
    for x:=0 to Bitmap.width-1 do begin
      WITH Row[x] DO
      BEGIN
        rgbtRed   := FloatToByte(Rfactor * (rgbtRed   - avgTres.R*BF));
        rgbtGreen := FloatToByte(Gfactor * (rgbtGreen - avgTres.G*BF));
        rgbtBlue  := FloatToByte(Bfactor * (rgbtBlue  - avgTres.B*BF));
      END;
    end;
  end;
  End;

  1:
  Begin
  for y:=0 to Bitmap.height-1 do begin
    Row:=Bitmap.scanline[y];
    for x:=0 to Bitmap.width-1 do begin
      WITH Row[x] DO
      BEGIN
        if ((rgbtRed+rgbtGreen+rgbtBlue) / 3)<BackLevel then begin
             rgbtRed := BackLevel;
             rgbtGreen := BackLevel;
             rgbtBlue := BackLevel;
        end else begin
        if rgbtRed>0 then
        rgbtRed   := FloatToByte(Rfactor*((255-Rfactor)/rgbtRed)   * (rgbtRed - avgTres.R));
        if rgbtGreen>0 then
        rgbtGreen := FloatToByte(Gfactor*((255-Gfactor)/rgbtGreen) * (rgbtGreen - avgTres.G));
        if rgbtBlue>0 then
        rgbtBlue  := FloatToByte(Bfactor*((255-Bfactor)/rgbtBlue)  * (rgbtBlue - avgTres.B));
        end;
      END;
    end;
  end;

  End;
  End;
end;
(*
procedure AutoNoiseReduction(Bitmap: TBitmap; Method: integer; factor: DOUBLE;
                             BackLevel: byte; RGBParam: TRGBParam);
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

  case Method of
  0:
  Begin
  for y:=0 to Bitmap.height-1 do begin
    Row:=Bitmap.scanline[y];
    for x:=0 to Bitmap.width-1 do begin
      WITH Row[x] DO
      BEGIN
        if ((rgbtRed+rgbtGreen+rgbtBlue) / 3)<BackLevel then begin
             rgbtRed := BackLevel;
             rgbtGreen := BackLevel;
             rgbtBlue := BackLevel;
        end else begin
        rgbtRed   := FloatToByte(Rfactor * (rgbtRed - avgTres.R));
        rgbtGreen := FloatToByte(Gfactor * (rgbtGreen - avgTres.G));
        rgbtBlue  := FloatToByte(Bfactor *(rgbtBlue - avgTres.B));
        end;
      END;
    end;
  end;
  End;
  1:
  Begin
  for y:=0 to Bitmap.height-1 do begin
    Row:=Bitmap.scanline[y];
    for x:=0 to Bitmap.width-1 do begin
      WITH Row[x] DO
      BEGIN
        if ((rgbtRed+rgbtGreen+rgbtBlue) / 3)<BackLevel then begin
             rgbtRed := BackLevel;
             rgbtGreen := BackLevel;
             rgbtBlue := BackLevel;
        end else begin
        if rgbtRed>0 then
        rgbtRed   := FloatToByte(Rfactor*((255-Rfactor)/rgbtRed)   * (rgbtRed - avgTres.R));
        if rgbtGreen>0 then
        rgbtGreen := FloatToByte(Gfactor*((255-Gfactor)/rgbtGreen) * (rgbtGreen - avgTres.G));
        if rgbtBlue>0 then
        rgbtBlue  := FloatToByte(Bfactor*((255-Bfactor)/rgbtBlue)  * (rgbtBlue - avgTres.B));
        end;
      END;
    end;
  end;
  End;
  End;
end;
*)
// Extract R chanel from src bitmap
// src pixelformat must be 24 or 32 bit/pixel, dst = 8 bit/pixel;
procedure ExtractBChanel(src,dst: TBitmap);
Var sWsk,dWsk:^Byte;
    H,V:  Integer;
begin
  dst.PixelFormat := pf8bit;
  dst.Width  := src.Width;
  dst.Height := src.Height;
  for V:=0 to src.Height-1 do
  begin
    sWsk:=src.ScanLine[V];
    dWsk:=dst.ScanLine[V];
    for H:=0 to src.Width-1  do
    begin
      dWsk^:=sWsk^;
      Inc(sWsk,3);
      Inc(dWsk);
    end;
  end;
end;

procedure ExtractGChanel(src,dst: TBitmap);
Var sWsk,dWsk:^Byte;
    H,V:  Integer;
begin
  dst.PixelFormat := pf8bit;
  dst.Width  := src.Width;
  dst.Height := src.Height;
  for V:=0 to src.Height-1 do
  begin
    sWsk:=src.ScanLine[V];
    dWsk:=dst.ScanLine[V];
    Inc(sWsk);
    for H:=0 to src.Width-1  do
    begin
      dWsk^:=sWsk^;
      Inc(sWsk,3);
      Inc(dWsk);
    end;
  end;
end;

procedure ExtractRChanel(src,dst: TBitmap);
Var sWsk,dWsk:^Byte;
    H,V:  Integer;
begin
  dst.PixelFormat := pf8bit;
  dst.Width  := src.Width;
  dst.Height := src.Height;
  for V:=0 to src.Height-1 do
  begin
    sWsk:=src.ScanLine[V];
    dWsk:=dst.ScanLine[V];
    Inc(sWsk,2);
    for H:=0 to src.Width-1  do
    begin
      dWsk^:=sWsk^;
      Inc(sWsk,3);
      Inc(dWsk);
    end;
  end;
end;

// ============= END LEVONÓ RUTINOK =======================================

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if RecTimer=nil then RecTimer.Free;
  Action := caFree;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var i: integer;
    StyleName: String;
    Item: TMenuItem;
begin
  Application.HelpFile := ExtractFilePath(Application.ExeName) + 'LevonX.chm';
  FormatSettings.DecimalSeparator := '.';
  Doublebuffered := True;
  UR := TUndoRedo.Create;
  UR.UndoSaveProcedure := UndoSave;
  UR.UndoRedoProcedure := UndoRedo;
  UR.OnUndoRedo := OnUndoRedo;
  UR.UndoLimit:=10;
  UR.UndoInit;
  StarList1 := TStarList.Create;
  StarList1.OnChange := StarListChange;
  cBookIndex := 0;
  PageControl1.ActivePageIndex := 0;
  ToolPages.ActivePageIndex    := 0;
  Application.HintColor := clYellow;
  DataPage.Width    := 159;
  DataPage.TabIndex := 0;
  PHZ.Zoom          := 4;
  Param             := 5.0;
  FStarVisible      := True;
  FImageVisible     := True;
     With Levon1 do begin
          factor    := 5;
          BackLevel := 0;
          RGBParam.RParam := 1;
          RGBParam.GParam := 1;
          RGBParam.BParam := 1;
     end;
     With Levon2 do begin
          factor    := 1;
          BackLevel := 0;
          RGBParam.RParam := 1;
          RGBParam.GParam := 1;
          RGBParam.BParam := 1;
     end;

 StyleName := iniFile.ReadString('MainForm','StyleName','');
 if StyleName='' then StyleName:='Windows';
 TStyleManager.SetStyle(StyleName);
 //Add child menu items based on available styles.
 for StyleName in TStyleManager.StyleNames do
 begin
   Item := TMenuItem.Create(StyleMenu);
   Item.Caption := StyleName;
   Item.OnClick := StyleClick;
   if TStyleManager.ActiveStyle.Name = StyleName then
     Item.Checked := true;
   StyleMenu.Add(Item);
 end;

  RecTimer := TTimer.Create(Self);

  IPLHistory := TIPLHistory.Create(Application);
  IPLHistory.CommandToList( IPLCombo.Items );
  IPLHistory.OnChange    := OnPicChange;
  IPLHistory.OnRecording := OnRecording;
  ShortCutEnable := True;
  janLanguage1.InitLanguage(Self);
  Caption := 'LEVONX '+VersionStr;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var i: integer;
begin
  UR.Free;
  StarList1.Free;
  for i:=0 to 9 do
  if cBook[i]<>nil then begin
      cBook[i].Free;
      cBook[i]:=nil;
  end;
  IPLHistory.Free;
end;

procedure TMainForm.StyleClick(Sender: TObject);
var
 StyleName: String;
 i: Integer;
begin
 //get style name
 StyleName :=   StringReplace(TMenuItem(Sender).Caption, '&', '',
 [rfReplaceAll, rfIgnoreCase]);
 //set active style
 TStyleManager.SetStyle(StyleName);
 //uncheck all other style menu items
 for I := 0 to StyleMenu.Count -1 do
     StyleMenu.Items[i].Checked := false;
 //check the currently selected menu item
 (Sender as TMenuItem).Checked := true;
 iniFile.WriteString('MainForm','StyleName',StyleName);
end;

procedure TMainForm.SetParam(const Value: double);
begin
  FParam := Value;
  ParLabel.Caption := Format('%6.1f',[Value]);
end;

procedure TMainForm.SetpicFile(const Value: string);
begin
  FpicFile := Value;
  StatusBar1.Panels[0].Text := inttostr(ALZ.WorkBMP.width)+'x'+inttostr(ALZ.WorkBMP.Height);
  Caption := focim + ' [ '+Value+' ]';
  StatusBar1.Update;
end;

procedure TMainForm.SetProgramMode(const Value: TProgramMode);
begin
  FProgramMode := Value;
  mod_0.Checked := False;
  mod_1.Checked := False;
  case Value of
  pmoGeneral:
     begin
          mod_0.Checked := True;
          astroPage.Visible := False;
          fotometPage.Visible := False;
          CsillagListPage.Visible := False;
          ASTRO1.Visible := False;
     end;
  pmoAstro:
     begin
          mod_1.Checked := True;
          astroPage.Visible := True;
          fotometPage.Visible := True;
          CsillagListPage.Visible := False;
          ASTRO1.Visible := True;
     end;
  end;
end;

procedure TMainForm.SetStarVisible(const Value: boolean);
begin
  FStarVisible := Value;
  StarVisibleCB.Checked := FStarVisible;
  Csillagokltszanak1.Checked := FStarVisible;
  ALZ.ReDraw;
end;

procedure TMainForm.sGridClick(Sender: TObject);
var sID,n : Integer;
    sr    : TStarRecord;
begin
  if sGrid.Focused then begin
     sID := StrToInt(sGrid.Cells[1,sGrid.Row]);
     n   := StarList1.GetStarFromID(sID);
     sr  := StarList1.Star[n];
     ALZ.MoveToCentrum(sr.x,sr.y);
//     sr.Intensity := PhotometryG(ALZ.CopyBMP,Point2d(sr.x,sr.y),sr.Radius,ThresholdBar.Position);
//     Starlist1.Star[n] := sr;
//     SetGridRow(sGrid.Row,sr);
  end;
end;

procedure TMainForm.sGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
if ARow>0 then
  if ACol=0 then begin
//     Starlist1.ActualIndex := ARow-1;
     if Starlist1.dStar.Refstar then
        sGrid.Cells[0,ARow]:=inttostr(ARow)+'*';
     ALZ.Repaint;
  end;

(*        if sGrid.Font.Style = [] then begin
           sGrid.Font.Color := clMaroon;
           sGrid.Font.Style := [fsBold];
        end;
     end else
     if sGrid.Font.Style <> [] then begin
        sGrid.Font.Color := clBlack;
        sGrid.Font.Style := [];
     end;   *)
end;

procedure TMainForm.sGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  StarDataRead(ARow-1);
//  sGridClick(Sender);
end;

procedure TMainForm.StarDataRead(No: Integer);
// Kiírja a No sorszámú rekordot az adatmezõkbe
var st: TStarRecord;
begin
  st := Starlist1.Star[No];
  LbRefCount.Caption := '/'+inttostr(Starlist1.GetRefSignCount);
  ChRef.Checked:= st.Refstar;
  LBId.Caption := inttostr(st.ID)+' / '+inttostr(Starlist1.Count);
  EdGMg.Text   := FloatToStr(st.mg);
  EdRa.Text    := ARToStr_(st.Ra);
  EdDe.Text    := DEToStr_(st.De);
  lGMg.Caption := FormatFloat('#.##',st.mg);
  lRa.Caption  := ARToStr_(st.Ra);
  lDe.Caption  := DEToStr_(st.De);
end;

procedure TMainForm.StarDataWrite(No: Integer);
var st: TStarRecord;
begin
  st := Starlist1.Star[No];
  with st do begin
    Refstar := ChRef.Checked;
    mg    := StrToFloat(EdGMg.Text);
    Ra    := StrToAr_De(EdRa.Text);
    De    := StrToAr_De(EdDe.Text);
  end;
  Starlist1.Star[No]:=st;
  SetGridRow(No+1,st);
end;

procedure TMainForm.ToolButton10Click(Sender: TObject);
begin
  ALZ.TurnLeft;
  UR.UndoSave;
  AddLocalHistory('SHARP');
end;

procedure TMainForm.ToolButton11Click(Sender: TObject);
begin
  ALZ.TurnRight;
  UR.UndoSave;
  AddLocalHistory('SHARP');
end;

procedure TMainForm.ToolButton13Click(Sender: TObject);
begin
  StepRGB(ALZ.WorkBMP,25);
  ALZ.ReDraw;
  UR.UndoSave;
  AddLocalHistory('SHARP');
end;

procedure TMainForm.ToolButton14Click(Sender: TObject);
begin
  StepRGBContur(ALZ.WorkBMP,50,clSilver);
  ALZ.ReDraw;
  UR.UndoSave;
  AddLocalHistory('SHARP');
end;

procedure TMainForm.ToolButton15Click(Sender: TObject);
begin
  ColorNoiseElimination(alz.WorkBMP);
  ALZ.ReDraw;
  UR.UndoSave;
  AddLocalHistory('SHARP');
end;

procedure TMainForm.ToolButton1Click(Sender: TObject);
begin
  ALZ.Zoom := 2*ALZ.Zoom;
end;

procedure TMainForm.ToolButton23Click(Sender: TObject);
begin
  ALZ.MirrorVertical;
  UR.UndoSave;
  AddLocalHistory('SHARP');
end;

procedure TMainForm.ToolButton24Click(Sender: TObject);
begin
  ALZ.MirrorHorizontal;
  UR.UndoSave;
  AddLocalHistory('SHARP');
end;

procedure TMainForm.ToolButton2Click(Sender: TObject);
begin
  ALZ.Zoom := 0.5*ALZ.Zoom;
end;

procedure TMainForm.ToolButton32Click(Sender: TObject);
begin
  FixStuckPixels(ALZ.WorkBMP,30,20);
  UR.UndoSave;
  AddLocalHistory('SHARP');
end;

procedure TMainForm.ToolButton34Click(Sender: TObject);
begin
  ALZ.circlewindow:=not ALZ.circlewindow;
end;

procedure TMainForm.ToolButton3Click(Sender: TObject);
begin
  ALZ.Zoom := 1;
end;

procedure TMainForm.ToolButton4Click(Sender: TObject);
begin
  ALZ.Grid.Visible := NOT ALZ.Grid.Visible;
end;

procedure TMainForm.ToolButton5Click(Sender: TObject);
begin
  ALZ.Negative;
  UR.UndoSave;
  AddLocalHistory('NEGATIVE');
end;

procedure TMainForm.ToolButton7Click(Sender: TObject);
begin
  ALZ.MonoChrome;
  UR.UndoSave;
  AddLocalHistory('BLACKANDWHITE');
end;

procedure TMainForm.TrackBar1Change(Sender: TObject);
begin
  Param := TrackBar1.Position+TrackBar2.Position/10;
end;

procedure TMainForm.TrackBar3Change(Sender: TObject);
begin
  Label7.Caption := IntToStr(TrackBar3.Position);
end;

procedure TMainForm.ThresholdBarChange(Sender: TObject);
begin
  PosLabel.Caption := IntToStr(ThresholdBar.Position);
end;

procedure TMainForm.mnuUjratoltesClick(Sender: TObject);
begin
   StatusStart('Kép betöltése ...');
   LoadImageFromFile(picFile,ALZ.OrigBMP);
   ALZ.RestoreOriginal;
   ALZ.Cursor := crDefault;
   StatusEnd;
end;

procedure TMainForm.Undo1Click(Sender: TObject);
begin
  SpeedButton5Click(Sender);
end;

procedure TMainForm.UndoRedo(MemSt: TMemoryStream);
begin
  ALZ.LoadFromStream(MemSt,itBMP);
end;

procedure TMainForm.UndoSave(var MemSt: TMemoryStream);
begin
  ALZ.SaveToStream(MemSt,itBMP);
end;

procedure TMainForm.UpDown1ChangingEx(Sender: TObject; var AllowChange: Boolean;
  NewValue: Integer; Direction: TUpDownDirection);
var ed: TEdit;
begin
  AllowChange := False;
  ed := TEdit(TUpDown(Sender).Associate);
  case Direction of
  updUp:
  ed.Text := FloatToStr(StrToFloat(ed.Text)+0.05);
  updDown:
  ed.Text := FloatToStr(StrToFloat(ed.Text)-0.05);
  end;
  TEdit(TUpDown(Sender).Associate).Text := ed.Text;
end;

procedure TMainForm.VirtulisFlatkorrekci1Click(Sender: TObject);
begin
  StatusBar1.Panels[3].Text := 'FLAT';
  FlatForm.Execute(ALZ.WorkBMP);
  StatusBar1.Panels[3].Text := '';
end;

procedure TMainForm.SkalaButtonClick(Sender: TObject);
begin
  StatusBar1.Panels[3].Text := 'SKÁLÁZÁS';
  StatusBar1.Update;
  if SKALAZASForm.Execute(ALZ.WorkBMP,ALZ.sCent,ALZ.Zoom) then begin
     DoZoom(SKALAZASForm.ALZ.sCent,SKALAZASForm.ALZ.Zoom);
     ALZ.ReDraw;
     UR.UndoSave;
     AddLocalHistory('SCALE '+SKALAZASForm.ALC.GetPresetString);
  end;
     StatusBar1.Panels[3].Text := '';
end;

procedure TMainForm.DoZoom(_cent: TPoint2d;_zoom: double);
begin
  ALZ.sCent := _cent;
  ALZ.Zoom  := _zoom;
  ALZ.ReDraw;
end;

procedure TMainForm.ALZMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var d: double;
    i,sn,sid: integer;
    sr,sf: TStarRecord;
    sa: TStarIndexList;
begin
  sid := Starlist1.IsStarInPos(ALZ.XToW(x),ALZ.YToW(y));
  If sid>-1 then begin
     Screen.Cursor := crDrag;
     sr := Starlist1.GetStar(sid);
     sr.Intensity := PhotometryG(ALZ.CopyBMP,Point2d(sr.x,sr.y),sr.Radius,ThresholdBar.Position);
     pNoLabel.Caption        := inttostr(sr.ID);
     pStarPosLabel.Caption   := FormatFloat('#.##',sr.x)+' '+FormatFloat('#.##',sr.y);
     pRadiusLabel.Caption    := FormatFloat('#.###',sr.Radius)+'-'+FormatFloat('#.###',sf.Radius);
     pIntensityLabel.Caption := FormatFloat('#.##',sr.Intensity);
     pIntLogLabel.Caption    := FormatFloat('#.##',-2.5*log10(sr.Intensity));
     Starlist1.Star[sid] := sr;
     SetGridRow(sid+1,sr);
     // Csillag terület kimásolása
     PHZ.WorkBMP.Assign(ALZ.WorkBMP);
     PHZ.sCent := Point2D(sr.x,sr.y);
     PHZ.ReDraw;
     ALRGBDiagram2.Repaint;
     ALZ.ShowHintPanel(True,x+10,y,'ID = '+inttostr(sr.ID)+
                               EOL+' R = '+FormatFloat('#.###',sr.Radius)+
                               EOL+' I = '+FormatFloat('#.##',sr.Intensity));

     sGrid.Row := StarList1.GetStarFromID(sr.ID)+1;
  end
  else begin
     Screen.Cursor := crDefault;
     ALZ.CloseHintPanel;
  end;
end;

procedure TMainForm.ALZMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
Var sid: integer;
    sr: TStarRecord;
begin

  sid := Starlist1.IsStarInPos(ALZ.XToW(x),ALZ.YToW(y));
  If sid>-1 then begin
     sr := Starlist1.GetStar(sid);
     Screen.Cursor := crDrag;
     ALZ.ShowHintPanel(True,x+10,y,' ID  = '+inttostr(sr.ID)+'          '+
                               EOL+' GMg = '+FormatFloat('#.###',sr.mg)+
                               EOL+' Ra  = '+FormatFloat('#.##',sr.Ra)+
                               EOL+' De  = '+FormatFloat('#.##',sr.De));
                               ;
  end else begin
     Screen.Cursor := crDefault;
     ALZ.CloseHintPanel;
  end;
  if ALRGBDiagram1.Visible then
     ALRGBDiagram1.ReDraw(x,y);

end;

procedure TMainForm.ALZMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Cropkijellt1.Enabled := alz.SelRectVisible;
end;

procedure TMainForm.AutoWhiteBllance1Click(Sender: TObject);
begin
  StatusStart('Auto White Bllance ...');
  GrayAWB(ALZ.WorkBMP);
  ALZ.ReDraw;
  UR.UndoSave;
  StatusEnd;
end;

procedure TMainForm.Beilleszt1Click(Sender: TObject);
begin
  ALZ.PasteFromClipboard;
  UR.UndoSave;
end;

procedure TMainForm.BKk1Click(Sender: TObject);
begin
  SpeedButton4.Down := True;
  SpeedButton2Click(SpeedButton4);
end;

procedure TMainForm.MeretezButtonClick(Sender: TObject);
var siz: TPoint;
    BMP: TBitmap;
begin
  siz := Point(ALZ.WorkBMP.Width,ALZ.WorkBMP.Height);
  IF ResizeExecute( siz ) then
  Try
  StatusStart('Resizing ...');
  case ResizeDlg.ResizeMode of
  resmSimple:
  begin
     BMP := TBitmap.Create;
     BMP.Width := Siz.x;
     BMP.Height := Siz.y;
     SetStretchBltMode(BMP.Canvas.Handle, STRETCH_DELETESCANS);
     StretchBlt(BMP.Canvas.Handle,0,0,BMP.Width,BMP.Height,
                ALZ.WorkBMP.Canvas.Handle,0,0,ALZ.WorkBMP.Width,ALZ.WorkBMP.Height,SRCCOPY	);
     ALZ.WorkBMP.Assign(BMP);
     BMP.Free;
  end;
  resmSmooth:
     SmoothResize2(ALZ.WorkBMP,Siz.x,Siz.y);
  else
     Strecth(ALZ.WorkBMP,Ord(ResizeDlg.ResizeMode)-2,Siz.x,Siz.y);
  end;

     ALZ.Fittoscreen;
  finally
     UR.UndoSave;
     StatusBar1.Panels[0].Text := inttostr(ALZ.WorkBMP.width)+'x'+inttostr(ALZ.WorkBMP.Height);
     StatusEnd;
  end;
end;

procedure TMainForm.ElesButtonClick(Sender: TObject);
begin
  StatusStart('Élesítés');
  ConvolveFilter(3,0,ALZ.WorkBMP);
  ALZ.Redraw;
  UR.UndoSave;
  StatusEnd;
  AddLocalHistory('SHARP');
end;

procedure TMainForm.eljeskp1Click(Sender: TObject);
begin
  ALZ.FitToScreen;
end;

procedure TMainForm.eljeskpet2Click(Sender: TObject);
begin
  TMenuitem(Sender).Checked := True;
  ALZ.ClipBoardAction := TClipBoardAction(TMenuitem(Sender).Tag);
end;

procedure TMainForm.Ellentteskijells1Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Pred(CheckListHistory.Count) do
      CheckListHistory.Checked[i]:=not CheckListHistory.Checked[i];
end;

procedure TMainForm.Eredetimret1Click(Sender: TObject);
begin
  ALZ.Zoom := 1;
end;

procedure TMainForm.Kiegyenslyooztt1Click(Sender: TObject);
begin
  case TMenuitem(Sender).Tag of
  0:
  begin
     LEVONButton.Caption := 'LEVON 1';
     With Levon1 do begin
          TrackBar1.Position := Trunc(factor);
          TrackBar2.Position := Round(10*Frac(factor));
          TrackBar3.Position := BackLevel;
          REdit.Text         := FloatToStr(RGBParam.RParam); 
          GEdit.Text         := FloatToStr(RGBParam.GParam); 
          BEdit.Text         := FloatToStr(RGBParam.BParam); 
     end;
  end;
  1:
  begin
     LEVONButton.Caption := 'LEVON 2';
     With Levon2 do begin
          TrackBar1.Position := Trunc(factor);
          TrackBar2.Position := Round(10*Frac(factor));
          TrackBar3.Position := BackLevel;
          REdit.Text         := FloatToStr(RGBParam.RParam); 
          GEdit.Text         := FloatToStr(RGBParam.GParam); 
          BEdit.Text         := FloatToStr(RGBParam.BParam); 
     end;
  end;
  end;

  LEVONButton.Tag := TMenuitem(Sender).Tag;
  TMenuitem(Sender).Checked := True;
end;

procedure TMainForm.Kijelltektrlse1Click(Sender: TObject);
begin
  CheckListHistory.DeleteSelected;
end;

procedure TMainForm.Kilps1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.KonvolButtonClick(Sender: TObject);
begin
  StatusBar1.Panels[3].Text := 'KONVOLÓCIÓ';
  StatusBar1.Update;
  if KonvolForm.Execute(ALZ.WorkBMP,ALZ.sCent,ALZ.Zoom) then begin
     DoZoom(KonvolForm.ALZ.sCent,KonvolForm.ALZ.Zoom);
     ALZ.ReDraw;
     UR.UndoSave;
  end;
     StatusBar1.Panels[3].Text := '';
end;

procedure TMainForm.Kpbetlts1Click(Sender: TObject);
var ext: string;
begin
  if OpenDialog.Execute then begin
     StatusStart('Kép betöltése ...');
     ext := UpperCase(ExtractFileExt(OpenDialog.FileName));
     picFile:= OpenDialog.FileName;
     LoadImageFromFile(OpenDialog.FileName,ALZ.OrigBMP);
     ALZ.Loading := True;
     ALZ.Fitting := True;
     ALZ.RestoreOriginal;
     ALZ.ReDraw;
     UR.UndoInit;
     UR.UndoSave;
     StarList1.NewList;
     ALZ.Loading := False;
     ALZ.Fitting := False;
     mnuUjratoltes.enabled := True;
     StatusEnd;
  end;
end;

procedure TMainForm.Kpltszik1Click(Sender: TObject);
begin
  ImageVisible  := not ImageVisible;
end;

procedure TMainForm.Kpments1Click(Sender: TObject);
begin
  SaveImage;
end;

procedure TMainForm.Krablakban1Click(Sender: TObject);
begin
if ShortCutEnable then
begin
  ALZ.CircleWindow := NOT ALZ.CircleWindow;
  Krablakban1.Checked := ALZ.CircleWindow;
end;
end;

procedure TMainForm.Button10Click(Sender: TObject);
begin
  DataPage.ActivePage := CsillagListPage;
  StarList1.Newlist;
  GridInit;
end;

procedure TMainForm.Button11Click(Sender: TObject);
begin
  ALZ.PasteBMP.Assign(cBook[cBookIndex]);
end;

procedure TMainForm.Button12Click(Sender: TObject);
var i: integer;
begin
  for i:=0 to 9 do 
  if cBook[i]<>nil then begin 
      cBook[i].Free;
      cBook[i]:=nil; 
  end;
end;

procedure TMainForm.Button13Click(Sender: TObject);
begin
  if StarList1.GetRefSignCount>2 then
  begin
     if StarList1.CalculateTotalPhotometry then
     GridInit;
  end else begin
     ShowMessage('Minimum 2 referencia csillag szükséges');
     Button15Click(Sender);
  end;
end;

procedure TMainForm.Button14Click(Sender: TObject);
begin
  FotometGrafForm.ShowModal;
end;

procedure TMainForm.Button15Click(Sender: TObject);
begin
  DataPage.ActivePage := CsillagListPage;
     ALZ.CentralCross := True;
     DataPage.Width := 400;
end;

procedure TMainForm.Button17Click(Sender: TObject);
VAR sCount: integer;
  I: Integer;
  sr: TStarRecord;

  PROCEDURE FWHM();
  //Max. intenzitású pixelek keresése
  BEGIN

  END;

begin
  // Preciz csillag keresés
  StatusStart('Precíziós csillagérzékelés ...');
  StarList1.OnChange := NIL;
//  fwhm(ALZ.WorkBMP);
//  StarList1.AutoStarDetect(ALZ.WorkBMP,True,ThresholdBar.Position);
  for I := 0 to StarList1.Count-1 do begin
      sr := StarList1.Star[i];
      sr.Intensity := PhotometryG(ALZ.CopyBMP,Point2d(sr.x,sr.y),sr.Radius,ThresholdBar.Position);
      StarList1.Star[i] := sr;
  end;
  StarList1.OnChange := StarListChange;
  StarListChange(nil);
  StatusEnd;
  GridInit;
end;

procedure TMainForm.Button18Click(Sender: TObject);
begin
  DataPage.Width := 169;
  DataPage.ActivePageIndex := 0;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  ALZ.PasteFromClipboard;
  picFile := 'Clipboard';
  StarList1.Newlist;
  UR.UndoSave;
end;

procedure TMainForm.Button20Click(Sender: TObject);
begin
  HistMemo.Clear;
end;

procedure TMainForm.Button21Click(Sender: TObject);
var sd: TSaveDialog;
    fn: string;
begin
Try
  sd := TSaveDialog.Create(Application);
  sd.Filter := '*.his';
  sd.DefaultExt := 'his';
  if sd.Execute then
  begin
    fn := sd.FileName;
    HistMemo.Lines.SaveToFile(fn);
  end;
Finally
  sd.Free;
End;

end;

procedure TMainForm.Button22Click(Sender: TObject);
var sText : string;
    sor   : string;
    eo    : string;
    i,n   : integer;
    p     : integer;
begin
  sText := HistMemo.SelText;
  eo := chr(13)+chr(10);
  n := StrCount(sText,eo);
  p := Pos(chr(13),sText);
  while p>0 do begin
        sor := Copy(sText,1,p-1);
        sText := Copy(sText,p+2,Length(sText));
        IPLHistory.hisList.Add(sor);
        p := Pos(chr(13),sText);
  end;
  IPLHistory.ListToStringList(CheckListHistory.Items);
end;

procedure TMainForm.Button23Click(Sender: TObject);
var s: AnsiString;
begin
  WITH SKALAZASForm.ALC do begin
//       LoadPreset('Új');
       ApplyCurve(ALZ.WorkBMP);
       alz.ReDraw;
       s := GetPresetString;
  end;
end;

procedure TMainForm.btnRECClick(Sender: TObject);
begin
  IPLHistory.Recording := True;
end;

procedure TMainForm.Button24Click(Sender: TObject);
begin
  IPLHistory.Recording := False;
end;

procedure TMainForm.btnRUNClick(Sender: TObject);
begin
if CheckListHistory.Count>0 then
begin
  Screen.Cursor := crHourGlass;
  StatusStart('LRJÁTSZÁS');
  if cbFromOrigin.Checked then
     ALZ.RestoreOriginal;
  CheckListHistory.SetFocus;
  CheckListHistory.ItemIndex := 0;
  IPLHistory.StringListToHistoryList(CheckListHistory.Items);
  IPLHistory.Run(ALZ.WorkBMP);
  ALZ.ReDraw;
  UR.UndoSave;
  StatusEnd;
  CheckListHistory.ItemIndex := Pred(CheckListHistory.Count);
  Screen.Cursor := crDefault;
end;
end;

procedure TMainForm.btnSablonSaveClick(Sender: TObject);
begin
  SaveSablon;
end;

procedure TMainForm.btnSalonLoadClick(Sender: TObject);
begin
  LoadSablon;
end;

procedure TMainForm.btnSTEPClick(Sender: TObject);
begin
if CheckListHistory.Count>0 then
begin
  if CheckListHistory.ItemIndex<0 then
     CheckListHistory.ItemIndex := 0;
  if cbFromOrigin.Checked then ALZ.RestoreOriginal;
  CheckListHistory.SetFocus;
  if not CheckListHistory.Checked[CheckListHistory.ItemIndex] then
     IPLHistory.RunLine(ALZ.WorkBMP,CheckListHistory.ItemIndex);
  if CheckListHistory.ItemIndex<Pred(CheckListHistory.Count) then
     CheckListHistory.ItemIndex := CheckListHistory.ItemIndex + 1
  else
     CheckListHistory.ItemIndex := 0;
end;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  ALZ.CopyToClipboard;
end;

procedure TMainForm.Button3Click(Sender: TObject);
var BMP: TBitmap;
    R  : TRect;
begin
Try
  // Képrészletek másolása a vágókönyvbe
  BMP := TBitmap.Create;
  if cBook[ cBookIndex ]=nil then
     cBook[cBookIndex] := TBitmap.Create;
  case ALZ.ClipBoardAction of
  cbaTotal  :  BMPCopy( ALZ.WorkBMP, cBook[ cBookIndex ] );
  cbaScreen :  begin
                  R := ALZ.Canvas.ClipRect;
                  BMPResize(BMP,ALZ.Width,ALZ.Height);
                  BMP.canvas.CopyRect(R,ALZ.Canvas,R);
                  BMPCopy( BMP, cBook[ cBookIndex ] );
                end;
  cbaSelected : if ALZ.SelRectVisible then begin
                  ALZ.SelRectVisible := False;
                  R := Rect(Round(ALZ.XToW(ALZ.SelRect.Left+1)),Round(ALZ.YToW(ALZ.SelRect.Top+1)),
                       Round(ALZ.XToW(ALZ.SelRect.Right-1)),Round(ALZ.YToW(ALZ.SelRect.Bottom-1)));
                  BMP.Width := R.Right - R.Left;
                  BMP.Height:= R.Bottom - R.Top;
                  BMP.canvas.CopyRect(Rect(0,0,BMP.Width,BMP.Height),ALZ.CopyBMP.Canvas,R);
                  BMPCopy( BMP, cBook[ cBookIndex ] );
                  ALZ.SelRectVisible := True;
                end;
  cbaScreenSelected :
                if ALZ.SelRectVisible then begin
                  ALZ.SelRectVisible := False;
                  R := Rect(ALZ.SelRect.Left+1,ALZ.SelRect.Top+1,
                       ALZ.SelRect.Right-1,ALZ.SelRect.Bottom-1);
                  BMP.Width := R.Right - R.Left;
                  BMP.Height:= R.Bottom - R.Top;
                  BMP.canvas.CopyRect(Rect(0,0,BMP.Width,BMP.Height),ALZ.Canvas,R);
                  BMPCopy( BMP, cBook[ cBookIndex ] );
                  ALZ.SelRectVisible := True;
                end;
  end;
Finally
  BMP.Free;
End;
end;

procedure TMainForm.Button3DropDownClick(Sender: TObject);
begin
  Kpenkijelltterletet1.Enabled := ALZ.SelRectVisible;
  Kpernynkijel9ltterletet1.Enabled := ALZ.SelRectVisible;
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
  ALZ.RestoreOriginal;
  UR.UndoSave;
  StatusBar1.Panels[2].Text := '-';
  HistMemo.Lines.Add('ORIGIMAGE');
end;

procedure TMainForm.StarDetectExecute(Sender: TObject);
begin
  StatusStart('Automatikus csillagérzékelés ...');
  StarList1.OnChange := NIL;
  StarList1.AutoStarDetect(ALZ.WorkBMP,True,ThresholdBar.Position);
  StarList1.OnChange := StarListChange;
  StarListChange(nil);
  StatusEnd;
  GridInit;
end;

procedure TMainForm.ALTimerSpeedButton1TimerEvent(Sender: TObject);
begin
  ALZ.Zoom := 1.05*ALZ.Zoom;
end;

procedure TMainForm.ALTimerSpeedButton2TimerEvent(Sender: TObject);
begin
  ALZ.Zoom := 0.95*ALZ.Zoom;
end;

procedure TMainForm.ALZAfterPaint(Sender: TObject; xCent, yCent: Double;
  DestRect: TRect);
var fm: integer;
begin
  if StarVisible then begin
     StarDraw(StarList1,clRed);
  end;
  btnKeparany.Caption := IntToStr(Round(100*ALZ.Zoom))+' %';
  fm := GetFreeMemoryPercent;
  MemoryProgress.Position := fm;
end;

procedure TMainForm.StarDraw(StarList: TStarList; col: TColor);
var i: integer;
    RR: integer;
    sr,sf: TStarRecord;
    rsr0,rsr: TRefStarRecord;
    p: TPoint2d;
begin

  if StarList.Count>0 then
  with ALZ,ALZ.BackBMP.Canvas do begin
       Font.Name := 'Arial';
       Font.Size := 8;
       Font.Color := Col;
       Pen.Color := Col;
       Pen.Width := 1;
       Pen.Mode  := pmCopy;
       Brush.Style := bsClear;
       For i:=0 to StarList.Count-1 do begin
           sr := StarList.GetStar(i);
         if PontInKep(sr.x,sr.y,sRect) then begin
            Pen.Mode := pmCopy;
            if Sr.Selected then begin
               Pen.Color := clLime;
               Brush.Color := clLime;
               Brush.Style := bsSolid;
            end else begin
               Pen.Color := Col;
               Brush.Style := bsClear;
            end;
            if Sr.Refstar then begin
               Pen.Color := clAqua;
               Brush.Color := clAqua;
               Brush.Style := bsSolid;
            end;
           RR := Round(Zoom * Sr.Radius);
           Ellipse(XToS(Sr.x-Sr.Radius),
                   YToS(Sr.y-Sr.Radius),
                   XToS(Sr.x+Sr.Radius),
                   YToS(Sr.y+Sr.Radius));
           RR := 1;
           Rectangle(XToS(Sr.x)-1,
                     YToS(Sr.y)-1,
                     XToS(Sr.x)+1,
                     YToS(Sr.y)+1);
           Brush.Style := bsClear;
           if alz.Zoom>7 then begin
              Pen.Mode := pmXor;
              TextOut(XToS(Sr.x)+4,YToS(Sr.y)+4,Inttostr(sr.ID)+'-'+
                      FormatFloat('#.##',sr.Radius));
(*              SimplePhotometryG(ALZ.WorkBMP,XToS(Sr.x),YToS(Sr.y),SF);
              TextOut(XToS(Sr.x)+4,YToS(Sr.y)+16,Inttostr(sf.ID)+'-'+
                      FormatFloat('#.##',sf.Radius)+'-'+FormatFloat('#.##',sf.Intensity));*)
           end;
         end;
       end;
       if High(StarList.RefStars)>0 then begin
         Pen.Color := clBlack;
         rsr0 := StarList.refstars[0];
         For i:=0 to High(StarList.RefStars) do begin
             rsr := StarList.refstars[i];
             RR := Round(Zoom * rSr.Radius);
             Ellipse(XToS(rSr.x)-RR,
                   YToS(rSr.y)-RR,
                   XToS(rSr.x)+RR,
                   YToS(rSr.y)+RR);
           Font.Color := clBlack;
           TextOut(XToS(rSr.x)+4,YToS(rSr.y)+4,Inttostr(rsr.id));
           if i<2 then Pen.Color := clWhite else Pen.Color := col;
           MoveTo(XToS(rsr0.x),YToS(rsr0.y)); LineTo(XToS(rsr.x),YToS(rsr.y));
         end;
         end;
         Pen.Color := col;
         MoveTo(0,0);
  end;
end;

procedure TMainForm.StarListChange(Sender: TObject);
begin
  StarCountLabel.caption:=inttostr(StarList1.count);
  ALZ.ReDraw;
end;

procedure TMainForm.StarVisibleCBClick(Sender: TObject);
begin
  if StarVisibleCB.Focused then
     StarVisible := not StarVisible;
end;

procedure TMainForm.ALZChangeWindow(Sender: TObject; xCent, yCent, xWorld,
  yWorld, Zoom: Double; MouseX, MouseY: Integer);
begin
  StatusBar1.Panels[0].Text := IntToStr(ALZ.WorkBMP.width)+' x '+IntToStr(ALZ.WorkBMP.height);
  StatusBar1.Panels[1].Text := IntToStr(Trunc(xWorld))+':'+IntToStr(Trunc(yWorld));
  ALRGBDiagram1.ReDraw(MouseX, MouseY);
end;

procedure TMainForm.LEVONButtonClick(Sender: TObject);
VAR rgbP : TRGBParam;
    backLevel: byte;
begin
  StatusStart('LEVONÁS');
  Param       := TrackBar1.Position+TrackBar2.Position/10;
  backLevel   := TrackBar3.Position;
  rgbP.RParam := StrToFloat(REdit.Text);
  rgbP.GParam := StrToFloat(GEdit.Text);
  rgbP.BParam := StrToFloat(BEdit.Text);
  case LEVONButton.Tag of
  0:  
     With Levon1 do begin
          factor    := TrackBar1.Position+TrackBar2.Position/10;
          BackLevel := TrackBar3.Position;
          RGBParam  := rgbP;
     end;
  1:
     With Levon2 do begin
          Brightness(ALZ.WorkBMP,150);
          factor    := TrackBar1.Position+TrackBar2.Position/10;
          BackLevel := TrackBar3.Position;
          RGBParam  := rgbP;
     end;
  end;
  AutoNoiseReduction(ALZ.WorkBMP,LEVONButton.Tag,Param,backLevel,rgbP);
  ALZ.ReDraw;
  UR.UndoSave;
  StatusBar1.Panels[3].Text := '';
  StatusEnd;
  AddLocalHistory('LEVON'+inttostr(LEVONButton.Tag+1)+' '
                           +FormatFloat('0.####',param)+','
                           +FormatFloat('0.####',backLevel)+','
                           +FormatFloat('0.####',rgbP.RParam)+','
                           +FormatFloat('0.####',rgbP.GParam)+','
                           +FormatFloat('0.####',rgbP.BParam));
end;

procedure TMainForm.FileListBox1Click(Sender: TObject);
begin
     StatusStart('Kép betöltése ...');
  ALZ.Fitting := True;
  ALZ.FileName := FileListBox1.FileName;
  ALZ.Fitting := False;
     StatusEnd;
  PicFile := ALZ.FileName;
  StatusBar1.Panels[3].Text := PicFile;
end;

procedure TMainForm.FITfjbl1Click(Sender: TObject);
begin
  if OpenDialog.Execute then begin
  Try
     StatusStart('Kép betöltése ...');
     picFile:= OpenDialog.FileName;
     FFit := TFitsFileBitmap.CreateJoin(OpenDialog.FileName, cFileRead);
     FFit.BitmapRead(ALZ.OrigBMP);
     ALZ.RestoreOriginal;
     UR.UndoInit;
     UR.UndoSave;
     ALZ.FitToScreen;
     StarList1.NewList;
     StatusEnd;
  Finally
     FFit.Free;
  End;
  end;
end;

procedure TMainForm.Fixterletetakpernyrl1Click(Sender: TObject);
var w,h: integer;
    siz: string;
begin
  TMenuItem(Sender).Checked := True;
  ALZ.ClipBoardAction := TClipBoardAction(TMenuItem(Sender).Tag);
  if TMenuItem(Sender).Tag>3 then
  if FixTerForm.Execute then
  begin
     ALZ.FixSizes := Point(FixTerForm.FixWidth,FixTerForm.FixHeight);
  end;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  if elso then begin
     Update;
  if FileExists('Roz.jpg') then begin
     picFile := ExeDir+'Roz.jpg';
     StatusStart('Kép betöltése ...');
     ALZ.Loading := True;
     LoadImageFromFile(picFile,ALZ.OrigBMP);
     ALZ.RestoreOriginal;
     ALZ.Loading := False;
     ALZ.FitToScreen;
     UR.UndoSave;
     StatusEnd;
     CheckListHistory.SetFocus;
  end;                               ALZ.FitToScreen;
     ALZ.Fitting  := False;
     AboutBox.Close;
     elso := False;
     DownloadNewVersion;
  end;
end;

procedure TMainForm.Button5Click(Sender: TObject);
begin
  DataPage.ActivePage := OpenTabSheet;
end;

procedure TMainForm.REditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
VAR n: double;
begin
Try
  n := StrToFloat(TEdit(Sender).Text);
  case Key of
  VK_UP   : n:=n+0.05;
  VK_DOWN : n:=n-0.05;
  end;
  TEdit(Sender).Text := FormatFloat('#.##',n);
except
  TEdit(Sender).Text := '0';
End;
end;

procedure TMainForm.REditKeyPress(Sender: TObject; var Key: Char);
begin
  IF not (Key in ['0'..'9','.',#8]) then Key:=#0;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Case Key of
  VK_ESCAPE : ALZ.RestoreOriginal;
  end;
  if Shift=[ssCtrl] then
  if Key=VK_RETURN then
     FullScreen1Click(Sender);
end;

procedure TMainForm.FullScreen1Click(Sender: TObject);
begin
end;

procedure TMainForm.FullScreenExecute(Sender: TObject);
var wc: TWinControl;
begin
  wc := alz.Parent;
  alz.Parent:= FullForm;
  FullForm.ShowModal;
  alz.Parent:= wc;
end;

procedure TMainForm.Segt2Click(Sender: TObject);
begin
  HtmlHelp(0, Application.HelpFile, HH_DISPLAY_TOC, 0);
end;

procedure TMainForm.SetGridRow(Row: integer; sr: TStarRecord);
begin
  if sr.Refstar then
     sGrid.Cells[0,Row] := '*'+Inttostr(Row)
  else
     sGrid.Cells[0,Row] := Inttostr(Row);
     sGrid.Cells[1,Row] := Inttostr(sr.ID);
     sGrid.Cells[2,Row] := FormatFloat('###.##',sr.mg);
     sGrid.Cells[3,Row] := FormatFloat('###.##',sr.Radius);
     sGrid.Cells[4,Row] := FormatFloat('###.##',sr.Intensity);
     sGrid.Cells[5,Row] := FormatFloat('###.##',sr.Ra);
     sGrid.Cells[6,Row] := FormatFloat('###.##',sr.De);
end;

procedure TMainForm.SetImageVisible(const Value: boolean);
begin
  FImageVisible := Value;
  if not VisImageCB.Focused then
     VisImageCB.Checked := FImageVisible;
  Kpltszik1.Checked  := FImageVisible;
  ALZ.VisibleImage   := FImageVisible;
end;

procedure TMainForm.GetGridRow(Row: integer; sr: TStarRecord);
begin

end;

procedure TMainForm.GridInit;
var i: integer;
    sr: TStarRecord;
begin
  sGrid.Clear;
  sGrid.RowCount := StarList1.Count+2;
  for I := 1 to StarList1.Count do
  begin
     sr := StarList1.Star[i-1];
     sGrid.Cells[0,i] := Inttostr(i);
     SetGridRow(i,sr);
  end;
  StarDataRead(0);
end;

procedure TMainForm.GZld1Click(Sender: TObject);
begin
  SpeedButton3.Down := True;
  SpeedButton2Click(SpeedButton3);
end;

procedure TMainForm.Kurzorkereszt1Click(Sender: TObject);
begin
if ShortCutEnable then
  ALZ.CursorCross := not ALZ.CursorCross;
end;

procedure TMainForm.Language1Click(Sender: TObject);
var
  I: Integer;
  cn: string;
  co: TForm;
begin
  janLanguage1.ChangeLanguage(Self);
  StatusStart('New Language ...');
//  AboutBox.ChangeLanguage;
  (*
  for I := 0 to Application.ComponentCount-1 do
      if Application.Components[i] is TForm  then begin
         co := TForm(Application.Components[i]);
         with co do
         janLanguage1.InitLanguage(co);
      end;
  *)
  StatusEnd;
end;

procedure TMainForm.LevonasExecute(Sender: TObject);
begin
  LEVONButtonClick(Sender);
end;

procedure TMainForm.MeroracsExecute(Sender: TObject);
begin
if ShortCutEnable then
begin
  ALZ.Grid.Visible := NOT ALZ.Grid.Visible;
  Mrrcs1.Checked   := ALZ.Grid.Visible;
end;
end;

procedure TMainForm.Mindentkijell1Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Pred(CheckListHistory.Count) do
      CheckListHistory.Checked[i]:=True;
end;

procedure TMainForm.mod_0Click(Sender: TObject);
begin
  ProgramMode:=pmoGeneral;
end;

procedure TMainForm.mod_1Click(Sender: TObject);
begin
  ProgramMode:=pmoAstro;
end;

procedure TMainForm.MonoButtonClick(Sender: TObject);
begin
  ALZ.RGBList.MonoRGB := True;
end;

procedure TMainForm.Monokrm1Click(Sender: TObject);
begin
if ShortCutEnable then
begin
  MonoButton.Down := True;
  MonoButtonClick(Sender);
end;
end;

procedure TMainForm.Msol1Click(Sender: TObject);
begin
  ALZ.CopyToClipboard
end;

procedure TMainForm.N2001Click(Sender: TObject);
var z: integer;
begin
  z := TMenuitem(Sender).Tag;
  if z=0 then
     ALZ.FitToScreen
  else begin
     ALZ.Zoom := z/100;
  end;
  btnKeparany.Caption := TMenuItem(Sender).Caption
end;

procedure TMainForm.Nemkijelltektrlse1Click(Sender: TObject);
begin
  Ellentteskijells1Click(Sender);
  CheckListHistory.DeleteSelected;
  Ellentteskijells1Click(Sender);
end;

procedure TMainForm.OnUndoRedo(Sender: TObject; Undo, Redo: boolean);
begin
  SpeedButton5.Enabled := Undo;
  SpeedButton6.Enabled := Redo;
end;

procedure TMainForm.PreciseStarDetectExecute(Sender: TObject);
VAR sCount: integer;
  I: Integer;
  sr: TStarRecord;
begin
  // Preciz csillag keresés
  StatusStart('Precíziós csillagérzékelés ...');
  StarList1.OnChange := NIL;
  StarList1.AutoStarDetect(ALZ.WorkBMP,True,ThresholdBar.Position);
  for I := 0 to StarList1.Count-1 do begin
      sr := StarList1.Star[i];
      sr.Intensity := PhotometryG(ALZ.CopyBMP,Point2d(sr.x,sr.y),sr.Radius,ThresholdBar.Position);
      StarList1.Star[i] := sr;
  end;
  StarList1.OnChange := StarListChange;
  StarListChange(nil);
  StatusEnd;
  GridInit;
end;

procedure TMainForm.Programrl1Click(Sender: TObject);
begin
  AboutBox := TAboutBox.Create(Application);
  AboutBox.ShowModal;
end;

procedure TMainForm.Redo1Click(Sender: TObject);
begin
  SpeedButton6Click(Sender);
end;

procedure TMainForm.RGBklnfjlba1Click(Sender: TObject);
var Rbmp,Gbmp,Bbmp : TBitmap;
    ofile, chFile : string;
begin
  SaveDialog.FileName := ExtractFileName(picFile);
  if SaveDialog.Execute(MainForm.Handle) then begin
     chFile := ExtractFileName( SaveDialog.FileName );
     StatusStart('RGB save');

     ofile := ChangeFileExt(chFile,'_R.bmp');
     Rbmp := TBitmap.Create;
     ExtractRChanel(ALZ.WorkBMP,Rbmp);
     Rbmp.SaveToFile(ofile);

     ofile := ChangeFileExt(chFile,'_G.bmp');
     Gbmp := TBitmap.Create;
     ExtractGChanel(ALZ.WorkBMP,Gbmp);
     Gbmp.SaveToFile(ofile);

     ofile := ChangeFileExt(chFile,'_B.bmp');
     Bbmp := TBitmap.Create;
     ExtractBChanel(ALZ.WorkBMP,Bbmp);
     Bbmp.SaveToFile(ofile);

     StatusEnd;
  end;
end;

procedure TMainForm.RGBMindenszn1Click(Sender: TObject);
begin
if ShortCutEnable then
begin
  SpeedButton1.Down := True;
  RGBMindenszn1.Checked := True;
  SpeedButton1Click(Sender);
end;
end;

procedure TMainForm.RVrs1Click(Sender: TObject);
begin
  SpeedButton2.Down := True;
  SpeedButton2Click(SpeedButton2);
end;

procedure TMainForm.btnListDownClick(Sender: TObject);
var
  i, Max: Integer;
begin
  Max := CheckListHistory.Items.Count;
  if Max > 0 then begin
    Dec(Max);
    i := CheckListHistory.ItemIndex;
    if i < Max then begin
      CheckListHistory.Items.Exchange(i, i + 1);
      CheckListHistory.Selected[i+1]:= True;
    end;
  end;
end;

procedure TMainForm.btnListUpClick(Sender: TObject);
var
  i: Integer;
begin
  i := CheckListHistory.ItemIndex;
  if i = 0 then
      exit
    else
      CheckListHistory.Items.Exchange(i, i - 1);
      CheckListHistory.Selected[i-1]:= True;
end;

procedure TMainForm.Button6Click(Sender: TObject);
begin
  REdit.Text := '1.0';
  GEdit.Text := '1.0';
  BEdit.Text := '1.0';
end;

procedure TMainForm.MaszkButtonClick(Sender: TObject);
begin
  // Maszkolás
  StatusBar1.Panels[3].Text := 'MASZKOLÁS';
  StatusBar1.Update;
  if MaszkForm.Execute(ALZ.WorkBMP) then begin
     ALZ.ReDraw;
     UR.UndoSave;
     AddLocalHistory('MEDIAN');
  end;
     StatusBar1.Panels[3].Text := '';
end;

procedure TMainForm.MedianButtonClick(Sender: TObject);
begin
  StatusStart('Medián szûrés');
  MedianRGB24(ALZ.WorkBMP);
  ALZ.ReDraw;
  UR.UndoSave;
  StatusEnd;
  AddLocalHistory('MEDIAN');
end;

procedure TMainForm.HistoButtonClick(Sender: TObject);
begin
  // Histogram
  StatusBar1.Panels[3].Text := 'HISTOGRAM';
  StatusBar1.Update;
  if HistogramForm.Execute(ALZ.WorkBMP) then begin
     StatusStart('Érvényesítés a képen ...');
     HistogramForm.DoChange(ALZ.WorkBMP);
     ALZ.ReDraw;
     UR.UndoSave;
  end;
     StatusEnd;
  with HistogramForm do begin
  if (Params.R<>1) or (Params.G<>1) or (Params.B<>1) then
     AddLocalHistory('RGB '+FormatFloat('0.####',Params.R)+','
                           +FormatFloat('0.####',Params.G)+','
                           +FormatFloat('0.####',Params.B));
  if Params.Brightness<>0 then
     AddLocalHistory('BRIGHTNESS '+inttostr(Params.Brightness));
  if Params.Contrast<>0 then
     AddLocalHistory('CONTRAST '+inttostr(Params.Contrast));
  if Params.Saturation<>0 then
     AddLocalHistory('SATURATION '+inttostr(Params.Saturation+255));
  if Params.Gamma<>1 then
     AddLocalHistory('GAMMA '+FloatToStr(Params.Gamma));
  if Params.Mono then
     AddLocalHistory('BLACKANDWHITE');
  if Params.Negative then
     AddLocalHistory('NEGATIVE');
  end;
     StatusBar1.Panels[3].Text := '';
end;

procedure TMainForm.IPLEditEnter(Sender: TObject);
begin
  ShortCutEnable := False;
end;

procedure TMainForm.IPLEditExit(Sender: TObject);
begin
  ShortCutEnable := True;
end;

procedure TMainForm.j1Click(Sender: TObject);
VAR tempBMP : TBitmap;
    x,y     : integer;
begin
  UjForm.ImageWidth := ALZ.WorkBMP.Width;
  UjForm.ImageHeight := ALZ.WorkBMP.Height;
  UjForm.PictureWidth := ALZ.WorkBMP.Width;
  UjForm.PictureHeight := ALZ.WorkBMP.Height;
  UjForm.ShowModal;
  if UjForm.ModalResult = mrOk then begin
  Try
     ALZ.OrigBMP.Assign(ALZ.WorkBMP);
     tempBMP := TBitmap.Create;
     tempBMP.Width := UjForm.PictureWidth + 2*UjForm.FrameWidth;
     tempBMP.Height := UjForm.PictureHeight + 2*UjForm.FrameWidth + UjForm.DataWidth;;
     x := 0; y:= 0;
     x := UjForm.FrameWidth;
     if UjForm.DataDown then
        y := UjForm.FrameWidth
     else
        y := UjForm.FrameWidth + UjForm.DataWidth;
     tempBMP.Canvas.Brush.Color := UjForm.FrameColor;
     tempBMP.Canvas.FillRect(tempBMP.Canvas.ClipRect);
     tempBMP.Canvas.Brush.Color := UjForm.PictureColor;
     if UjForm.PictureStay then begin
        tempBMP.Canvas.Draw(x,y,ALZ.WorkBMP);
     end;
  Finally
     ALZ.WorkBMP.Assign(tempBMP);
     UR.UndoSave;
     tempBMP.Free;
     ALZ.ReDraw;
  End;
  end;
end;

procedure TMainForm.Javt1Click(Sender: TObject);
begin
  Cropkijellt1.Enabled := ALZ.SelRectVisible;
end;

procedure TMainForm.jlista1Click(Sender: TObject);
begin
  CheckListHistory.Clear;
  SablonNevEdit.Text := '';
end;

procedure TMainForm.jverzletltse1Click(Sender: TObject);
var sl : TStringList;
    newVersion,setupFile: string;
begin
//     DownloadNewVersion;

if DownloadFile(
    'http://stella.kojot.co.hu/StarFactory/Prog/Levon/version.txt',
    ExtractFilePath(Application.ExeName)+'NewVersion.txt')
then
Try
  sl := TStringList.Create;
  sl.LoadFromFile('NewVersion.txt');
  newVersion := Trim(sl.Text);
  if Version < newVersion then begin
  if MessageDlg('Új verzió a net-en ='+sl.Text+' Letöltés indulhat?',
                mtInformation, [mbYes, mbNo], 0, mbYes) = mrYes then
  begin
     StatusStart('setup_LevonX.EXE: Új verzió letöltése folyamatban ...');
     setupFile := ExeDir+'setup_LevonX_'+newVersion+'.exe';
     DownloadFile(
     'http://stella.kojot.co.hu/StarFactory/Prog/Levon/setup_LevonX.exe',
     setupFile);
     StatusEnd;
     ShowMessage('Letöltés Ok : '+ExeDir+'setup_LevonX_'+newVersion+'.exe');
     ShellExecute(handle, 'open', PChar(setupFile), nil, nil, SW_SHOWNORMAL);
     Close;
  end;
  end else
  ShowMessage('Nincs letölthetõ újabb változat');
Finally
  if sl<>nil then sl.Free;
End
else
  ShowMessage('Sikertelen letöltés vagy nincs internet kapcsolat');
end;

procedure TMainForm.Button9Click(Sender: TObject);
begin
  SaveImage;
end;

procedure TMainForm.SaveImage;
begin
  With SaveDialog do begin
       Title := 'Save';
       DefaultExt := 'JPG';
       Filter     := 'JPEG|*.jpg|Windows Bitmap|*.bmp';
       if Execute then
          ALZ.SaveToFile(FileName);
  end;
end;

procedure TMainForm.CentralCrossExecute(Sender: TObject);
begin
if ShortCutEnable then
begin
  ALZ.CentralCross := NOT ALZ.CentralCross;
  Kzpkereszt1.Checked := ALZ.CentralCross;
end;
end;

procedure TMainForm.CheckListHistoryDblClick(Sender: TObject);
var s: AnsiString;
begin
  s := CheckListHistory.Items[CheckListHistory.ItemIndex];
  Screen.Cursor := crHourGlass;
  StatusStart('LRJÁTSZÁS');
  IPLHistory.RunLine(ALZ.WorkBMP,s);
  ALZ.ReDraw;
  UR.UndoSave;
  StatusEnd;
  Screen.Cursor := crDefault;
end;

procedure TMainForm.CheckListHistoryKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Case Key of
  VK_DELETE:
     CheckListHistory.Items.Delete(CheckListHistory.ItemIndex);
//  VK_UP: btnListUpClick(nil);
//  VK_DOWN: btnListDownClick(nil);
  End;
end;

procedure TMainForm.ContrastStretch1Click(Sender: TObject);
begin
  ContrastStretch(ALZ.WorkBMP);
  ALZ.Redraw;
end;

procedure TMainForm.VisImageCBClick(Sender: TObject);
begin
  if VisImageCB.Focused then
     ImageVisible := not ImageVisible;
end;

procedure TMainForm.PHZChangeWindow(Sender: TObject; xCent, yCent, xWorld,
  yWorld, Zoom: Double; MouseX, MouseY: Integer);
begin
  ALRGBDiagram2.ReDraw(MouseX, MouseY);
end;

procedure TMainForm.PHZMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  ALRGBDiagram2.ReDraw(x,y);
end;

procedure TMainForm.PixelGridCBClick(Sender: TObject);
begin
  ALZ.PixelGrid := PixelGridCB.Checked;
end;

procedure TMainForm.Cropkijellt1Click(Sender: TObject);
begin
  if ALZ.SelRectVisible then begin
     ALZ.CropSelected;
     UR.UndoSave;
  end;
end;

procedure TMainForm.CsillagListaMentse1Click(Sender: TObject);
begin
  With SaveDialog do begin
       Title := 'Csillaglista mentése';
       DefaultExt := 'dat';
       Filter     := 'Adat|*.dat|Text|*.txt';
       if Execute then begin
          sGrid.SaveToListFile(FileName);
       end;
  end;
end;

procedure TMainForm.Csillagokltszanak1Click(Sender: TObject);
begin
  StarVisible := not StarVisible;
end;

procedure TMainForm.DataPageChange(Sender: TObject);
begin
  if DataPage.ActivePage = FotometPage then begin
     ALRGBDiagram1.Visible := True;
     ALRGBDiagram1.Height := 128;
     ALZ.CursorCross := True;
  end;
  if DataPage.ActivePage = CsillagListPage then begin
     ALZ.CentralCross := True;
     DataPage.Width := 400;
  end else
     DataPage.Width := 159;
end;

procedure TMainForm.DialogOpenPicture1Accept(Sender: TObject);
begin
  Button5Click(Sender);
end;

procedure TMainForm.SpecilisBeillaszts1Click(Sender: TObject);
begin
  ALZ.PasteSpecial;
  UR.UndoSave;
end;

procedure TMainForm.SpeedButton19Click(Sender: TObject);
var n: integer;
begin
Try
  n := StarList1.NextRefSign(0);
  if n>-1 then begin
     sGrid.Row := n+1;
     ALZ.MoveToCentrum(StarList1.Star[n].x,StarList1.Star[n].y);
  end;
Except
  exit;
End;
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
begin
  ALZ.RGBList.RGB := True;
  SpeedButton2.Down := True;
  SpeedButton3.Down := True;
  SpeedButton4.Down := True;
end;

procedure TMainForm.SpeedButton20Click(Sender: TObject);
var n: integer;
begin
Try
  n := StarList1.NextRefSign(sGrid.Row);
  if n>-1 then begin
     sGrid.Row := n+1;
     ALZ.MoveToCentrum(StarList1.Star[n].x,StarList1.Star[n].y);
  end;
Except
  exit;
End;
end;

procedure TMainForm.SpeedButton21Click(Sender: TObject);
begin
  // Delete all reference star signature
  StarList1.DeleteAllRefSign;
end;

procedure TMainForm.SpeedButton22Click(Sender: TObject);
begin
  StarDataWrite(sGrid.Row-1);
end;

procedure TMainForm.btnHistListClick(Sender: TObject);
begin
  HistPanel.Visible := not HistPanel.Visible;
  btnHistList.Down  := HistPanel.Visible;
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

procedure TMainForm.SpeedButton8Click(Sender: TObject);
begin
  cBookIndex := TSpeedButton(Sender).Tag;
end;

procedure TMainForm.SpeedButton8MouseEnter(Sender: TObject);
var tp: TPoint;
begin
  if not ClipbookViewerForm.Showing then begin
     tp := ClientToScreen(Point(TSpeedButton(Sender).Left,TSpeedButton(Sender).Top));
     ClipbookViewerForm.Left := tp.X;
     ClipbookViewerForm.Top  := 100+tp.Y+TSpeedButton(Sender).Height+8;
     ClipbookViewerForm.Caption := TSpeedButton(Sender).Caption;
     ClipbookViewerForm.Image.Visible := cBook[TSpeedButton(Sender).Tag]<>nil;
     if ClipbookViewerForm.Image.Visible then BEGIN
        ClipbookViewerForm.Image.Picture.Bitmap.Assign(cBook[TSpeedButton(Sender).Tag]);
        ClipbookViewerForm.Image.Refresh;
        ClipbookViewerForm.Show;
     END;
  end;
end;

procedure TMainForm.SpeedButton8MouseLeave(Sender: TObject);
begin
  if ClipbookViewerForm.Showing then
     ClipbookViewerForm.Close;
end;

procedure TMainForm.StatusEnd;
begin
  dt2 := GetTickCount;
  Screen.Cursor := crDefault;
  ALZ.EnableFocus := True;
  StatusBar1.Panels[2].Text := Format('%6.2f sec.',[(dt2-dt1)/1000]);
//  FormatDateTime('s.ms',dt2-dt1)+' sec';
  StatusBar1.Panels[3].Text := statusstring;
end;

procedure TMainForm.StatusStart(s: string);
begin
  statusstring := picFile;
  Screen.Cursor := crHourGlass;
  ALZ.Cursor := crHourGlass;
  ALZ.EnableFocus := False;
  StatusBar1.Panels[2].Text := '...';
  StatusBar1.Panels[3].Text := s;
  StatusBar1.Update;
  dt1 := GetTickCount;
end;

procedure TMainForm.tmretezs1Click(Sender: TObject);
begin
  MeretezButtonClick(Sender);
end;

procedure TMainForm.ToolButton9Click(Sender: TObject);
begin
  ALZ.BlackAndWhite;
end;

procedure TMainForm.ToolPagesChange(Sender: TObject);
begin
  if ToolPages.ActivePageIndex=3 then IPLCombo.SetFocus;

end;

procedure TMainForm.ToolPagesChanging(Sender: TObject;
  var AllowChange: Boolean);
begin

end;

{ TClipBook }

procedure TClipBook.AddBMP(bmp: TBitmap);
var p: pClipBoolItem;
begin
  New(p);
  p^.Stream := TMemoryStream.Create;
  bmp.SaveToStream(p^.Stream);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TClipBook.DeleteBMP(idx: integer);
var p: pClipBoolItem;
begin
  p:=Items[idx];
  if p^.Stream.Size>0 then
     p^.Stream.SetSize(0);
  p^.Stream.Free;
  Dispose(p);
  Delete(idx);
  if Assigned(FOnChange) then FOnChange(Self);
end;

function TClipBook.GetBITMAPS(index: integer): TBitmap;
begin
  Result := GetBMP(index);
end;

function TClipBook.GetBMP(idx: integer): TBitmap;
var p: pClipBoolItem;
begin
  p:=Items[idx];
  Result:=TBitmap.Create;
  Result.LoadFromStream(p^.Stream);
end;

function TClipBook.IsEmpty(idx: integer): boolean;
var p: pClipBoolItem;
begin
  p:=Items[idx];
  Result := p^.Stream.Size>0; 
end;

procedure TClipBook.NewList(n: integer);
var i: integer;
    p: pClipBoolItem;
begin
  if Count>0 then
  for I:=Pred(Count) to n do
      DeleteBMP(i);
  for I:=0 TO Pred(n) do BEGIN
      New(p);
      p^.Stream := TMemoryStream.Create;
  END;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TClipBook.SetBITMAPS(index: integer; const Value: TBitmap);
var p: pClipBoolItem;
begin
  p:=Items[index];
  if p^.Stream=nil then p^.Stream := TMemoryStream.Create;
  Value.SaveToStream(p^.Stream);
end;


procedure TClipBook.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

// ========================= NOISE REDUCTION =======================

{***********************************
 *  copy the image data to a Array of integer
 *
 ***********************************}
(*
procedure ScanRasterValues (aBmp : TBitmap; xstart, ystart, xsteps, ysteps : Integer;
          var RvalueArray, GValueArray, BValueArray : TImageFilter);
var   ByteLine  : Pbytearray;
      i, j      : integer;
begin



   for j := ystart to ystart + ysteps  do
         begin

         ByteLine := aBmp.ScanLine[j];

         for  i:= xstart to xstart + xsteps  do

                begin

                   BvalueArray [i-xstart, j-ystart] := ByteLine[3*i];
                   GvalueArray [i-xstart, j-ystart] := ByteLine[3*i +1];
                   RvalueArray [i-xstart, j-ystart] := ByteLine[3*i +2];


                end;

         end;

end;

(*

function FilterResult (aFilter, bFilter : TImageFilter) : word;
var  i,j   :  Integer;
     n,m     :  Integer;

begin
     n := length( aFilter );
     m:= n;


     for i := 1 to n do
       for j := 1 to m do
          result := aFilter[i][j] * bfilter[i,j];
end;

{******************************************************************************
 *      Input:
 *          bmp1, bm2 : TBitMap
 *          ImageFilter  : Image Filter array , size   FilterSize x  FilterSize
 *          assume filter size is always even !!  1,3,5, ...
 *
 *    OutPut:
 *
 *
 *
 *******************************************************************************}

procedure ReduceNoise_AnyFilter (bmp1, bmp2 : TBitMap; aImageFilter : TImageFilter );

var  P1                 :    pbytearray;  //  from Image 1
     FilterSize         :    Integer;     //  3,5,7
     FilterSize2        :    Integer;     //  2,3,4
     i,j,jj             :    Integer;
     RvalueArray        :    TImageFilter;    // Red Color Values
     GvalueArray        :    TImageFilter;    // Green Color Values
     BvalueArray        :    TImageFilter;    // Blue Color Values

begin
     //  the filter size
     FilterSize := length(aImageFilter);

     FilterSize2 := round((FilterSize-1)/2 +1);

      //  adjust dyn. arrays

     setlength ( RvalueArray, Filtersize, Filtersize );

     setlength ( GvalueArray, Filtersize, Filtersize );

     setlength ( BvalueArray, Filtersize, Filtersize );


     //  Loop through all Pixels
     for j := FilterSize2 to bmp1.Height - (FilterSize2 +1) do
         begin

             p1 := bmp1.ScanLine[j];


             for i := FilterSize2 to bmp1.Width - (FilterSize2+1)  do

               begin

                ScanRasterValues (bmp2, i-FilterSize2, j-FilterSize2, FilterSize, FilterSize,RvalueArray, GValueArray, BValueArray );



                p1[3 * i ]     :=  FilterResult ( aImageFilter,BvalueArray ) ;     //  Bvalue
                p1[3 * i + 1 ] :=  FilterResult ( aImageFilter,GvalueArray ) ;     //  Gvalue
                p1[3 * i + 2 ] :=  FilterResult ( aImageFilter,RvalueArray ) ;     //  Rvalue


               end; // i := ...




         end;  //  j:= ..
end;
*)

// =================== LOCAL HISTORY RUTINS ========================

procedure TMainForm.AddLocalHistory(sor : string);
begin
  HistMemo.Lines.Add(sor);
  if IPLHistory.Recording then begin
     IPLHistory.Add(sor);
     CheckListHistory.Items.Add(sor);
  end;
end;

// =================== HISTORY RUTINS ==============================

procedure TMainForm.AddHistory(sor : string);
begin
  StafHistory.Add(sor);
end;

procedure TMainForm.btnHistRunClick(Sender: TObject);
begin
  IPLHistory.RunLine(ALZ.WorkBMP, IPLcOMBO.Text+' '+IPLEdit.Text);
  ALZ.Redraw;
  UR.UndoSave;
end;

procedure TMainForm.LoadSablon;
var OD: TOpenDialog;
    fn: string;
begin
Try
  OD := TOpenDialog.Create(Application);
  OD.Title := 'Sablon betöltése';
  OD.Filter := '*.sab;*.his';
  OD.InitialDir := ExeDir+'Templates';
  if OD.Execute then begin
     CheckListHistory.Items.LoadFromFile(OD.FileName);
     IPLHistory.hisList.Assign(CheckListHistory.Items);
     fn := ExtractFileName(OD.FileName);
     SablonNevEdit.Text := fn;
  end;
Finally
  OD.Free;
End;
end;

procedure TMainForm.SaveSablon;
var SD: TSaveDialog;
begin
Try
  SD := TSaveDialog.Create(Application);
  SD.Title := 'Sablon mentése';
  SD.Filter := '*.sab;*.his';
  SD.DefaultExt := 'sab';
  SD.InitialDir := ExeDir+'Templates';
  if SD.Execute then begin
     CheckListHistory.Items.SaveToFile(SD.FileName);
  end;
Finally
  SD.Free;
End;
end;

procedure TMainForm.OnPicChange(Sender: TObject);
begin
  ALZ.Redraw;
end;

procedure TMainForm.OnRecording(Sender: TObject; Rec: boolean);
begin
  btnRec.Visible := not Rec;
  btnRun.Enabled := not Rec;
  btnStep.Enabled := not Rec;
  if Rec then begin
        RecTimer.Interval := 500;
        RecTimer.Enabled := True;
        RecTimer.OnTimer := OnRectimer;
  end
  else
       RecTimer.Enabled := False;
end;

procedure TMainForm.OnRectimer(Sender: TObject);
begin
  RecShape.Visible := not RecShape.Visible;
  RecLabel.Visible := not RecLabel.Visible;
end;


initialization
  ExeDir := ExtractFilePath(Application.ExeName);
  focim := VersionPrg+VersionStr;
end.


