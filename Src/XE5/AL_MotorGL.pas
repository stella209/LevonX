{ TALMotors      : x,y léptetõmotorokat és megmunkálást az LPTn, ill
                   USB, COMn  porton keresztûl
                   vezérlõ DELPHI 5.0 komponens.
  Szerzõ        :  Agócs László - StellaSOFT - 2009 HUNGARY

  Properties:

}
unit AL_MotorGL;

interface

uses
  Windows,Classes,SysUtils,Controls,StdCtrls,ExtCtrls,Graphics,Forms,Dialogs,
  AL_Paper, AL_PapirGL, Szamok, NewGeom,
  SerialComUnit;

Type

  TMotorMethod    = (mmOld,mmNew,mmUSB,mmCOM,mmBlueTooth);

  TMoveOption     = (moAuto, moManual);        {Mozgatási mód:auto vagy kézi}
  TSebessegOption = (soNone, soQuick, soWork); {Gyors vagy lassú a mozgás}
  TStepDirection  = (sdNone, sdPoz, sdNeg);    {A mozgás iránya: + vagy -}

    {Gyártási mód:
       Tesztmód   = wmTest : csak szimulálja a gyártást, de a motorok nem mozognak;
       Vágási mód = wmCut  : a pozícionálások kivételével a fejet leengedi és vág;
       Gravir mód = wmGravir : Gravírozás során a fej magassága folyamatosan változtatható;
       Plazma mód = wmPlazma : Plazma vágás esetán bekezdési pontokon átfúvás
    }
  TWorkingMode    = (wmTest, wmCut, wmGravir, wmPlazma);

TFactoryConfig = record
  Demo          : boolean;        {Demó verzió = True}
  Belepett      : word;           {Ennyiszer lépett be a programba}
  UtolsoBelepes : TDateTime;      {Utolsó belépés dátuma}
  Uzemido       : TDateTime;      {Teljes üzemeltetés : GÉP ÖSSZ. MUNKAIDEJE}
  MotorMethod   : TMotorMethod;   {mmOldSty=Régi; mmNewStyle=Uj motor vezérlõ algoritmus}
  globaldir     : String[120];    {Config és catalógus és INI file könyvtára}
  localdir      : String[120];    {Sablon könyvtár}
  filenev       : String[120];    {Utoljára megnyitott Sablon file}
  Paper         : TPoint;         {Rajzlap méretei}
  PaperFont     : TFont;
  ForeColor     : TColor;         {Rajzlap alapszine}
  BackColor     : TColor;         {Rajzlapon kívüli terület alapszine}

  LPT           : byte;           {LPT port kiválasztás}
  MMPerSec      : real;           {Vágási sebesség mm/sec}
  LepesX        : real;           {X léptetõmotor mm/1 léptetés}
  LepesY        : real;           {Y léptetõmotor mm/1 léptetés}
  LepesZ        : real;           {Z léptetõmotor mm/1 léptetés}
  WorkSebesseg  : integer;        {Megmunkálási sebesség = 1..50}
  PosSebesseg   : integer;        {Pozícionálási sebesség = 1..50}
  Precizio      : integer;        {Tizedesek száma}
  ActPosition   : TPoint3d;       {Utolsó aktuális pozíció}
  Kiemeles      : integer;        {A fej kiemelése [leptetes_szám]}
  KesleltetesMIN: longint;        {A léptetõmotorok min. késleltetése}
  KesleltetesMINz: longint;       {A Z léptetõmotor min. késleltetése}
  WorkingMode   : byte;           {0=teszt,1=Vágás,2=Glavírozáa}
  NegativHead   : integer;        {1=pozítív; -1=negatív fejmozgás z-ben}
  Correction    : real;           {0=kontúron; <0=belül; >0=kívül;
                                   értéke = a vágóél sugara}
  DelayCorrection: real;          // Szorzó a késleltetésekhez
  TimeCorrection: Array[1..40] of Double; // Idõkorrekciók a sebességekhez
  PlazmaMachine : boolean;        // True=Plazmavágó; False=Plasticut
  FireTime      : integer;        // Átfúvás ideje bekeudési pontokon
  PlazmaIndex   : integer;        // A TimePlazma tömb aktuális indexe
  TimePlazma    : Array[0..9,0..1] of Double; // Átfúvási Idõk plazma vágókhoz
  TerminalSwitch: boolean;        // Végállás érzékelés
  Dummy         : Array[1..128] of byte;
end;


// New COM style structures
// ---------------------------------------------------------------------------
COM_OUTTITLE_Record = record      // Egy csomag állapot leírója
  First        : byte;            // Indító byte  = $55;
  PackType     : byte;            // Csomag tipus : 0=Elsõ; 1=Közbülsõ;
                                  // 2=Utolsó; 3=elsõ csomag az utolsó is
  PackCount    : word;            // Csomagok száma
  PackNo       : word;            // Küldendõ csomag sorszáma
  VecCount     : word;            // Vektorok száma a csomagban: max=78;
end;

COM_OUTDATA_Record = record       // Egy csomag adatrekordja
  xCount_L     : byte;            // X irányû lépések száma
  xCount_H     : byte;            // X irányû lépések száma
  yCount_L     : byte;            // Y irányû lépések száma
  yCount_H     : byte;            // Y irányû lépések száma
  xTime        : word;            // x irányû késleltetés
  yTime        : word;            // y irányû késleltetés
end;

COM_OUTCLOSE_Record = record      // Egy csomag lezárás leírója
  CloseByte    : byte;            // = 0;
  CheckSum     : byte;            // Ellenõrzõ összeg: SUM AND $FF
end;                              // SUM: Minden elõzõ byte összege

COM_IN_Record = record            // Vezérló által küldött 4 byte-os csomag
  First        : byte;            // = $AA;
  Info         : byte;            // Info a csmagról
  PackNo       : word;            // A leinformált csomag sorszáma
end;

Type FIFORec = record             // Receive Buffer data
       First : byte;
       info  : byte;
       PackNo: word;
     end;

(*      INFO BYTE
0x00    A vezérlõ a fõmenübe lépett
0x01    A VEZ kézi mozgatásba lépett
0x02    A VEZ adatra várakozik
0x03    A VEZ vágása felfüggesztve (PackNo=felfüggesztett csomag sorszáma)
0x04    A VEZ vágása újraindítva (PackNo=újraindított csomag sorszáma)
0x05    Csomag vétel sikeres (PackNo=a sikeresen vett csomag sorszáma)
0x06    Csomag adás ismétlés kérés (PackNo=az ismételni kívánt csomag sorszáma)
0x07    Csomag vétel 2-jára is sikertelen (PackNo=a 2. is sikertelenül vett csomag)
0x08    az PackNo. csomag vágása elindult
0x09    az PackNo. csomag vágása befejezõdött
0x0A    Utolsó csomag vágása befejezõdött
0x0B    Felfüggesztés utáni végleges leállítás
*)

// ---------------------------------------------------------------------------
// BlueTooth rekordok
BT_OUTDATA_Record = record
   x_lo : string[2];
   x_hi : string[2];
   y_lo : string[2];
   y_hi : string[2];
   tx_lo : string[2];
   tx_hi : string[2];
   ty_lo : string[2];
   ty_hi : string[2];
end;

// ---------------------------------------------------------------------------

  TActPositionChangeEvent = procedure(Sender: TObject; ActPosition : TPoint3D) of object;
  TWorkOnOffChangeEvent = procedure(Sender: TObject; WorkOn : boolean) of object;
  TPillanatAlljChangeEvent = procedure(Sender: TObject; All : boolean) of object;
  TWorkingModeChangeEvent = procedure(Sender: TObject; WorkMode : TWorkingMode) of object;
  TWorkTimeChangeEvent = procedure(Sender: TObject; WorkTime: double) of object;
  TWorkWayChangeEvent = procedure(Sender: TObject; WorkWay: extended) of object;
  TSTOPEvent = procedure(Sender: TObject; IsSTOP: boolean) of object;
  TOverRunEvent = procedure(Sender: TObject; x0,x1,y0,y1:boolean) of object;
  THeadStatusEvent = procedure(Sender: TObject; Down : boolean) of object;
  TLineOk = procedure(Sender: TObject; LineTempareture : integer; LineBreak: boolean) of object;
  TSzakadasEvent = procedure(Sender: TObject; Break : boolean) of object;
  TChangeConnection = procedure(Sender: TObject; Connected: boolean) of object;
  TRxQueEvent = procedure(Sender: TObject; info: byte; PackNo: byte) of object;
  TDownloadEvent = procedure(Sender: TObject; Percent: integer) of object;

   THRTimer = Class(TObject)
     Constructor Create;
     Function StartTimer : Boolean;
     Function ReadTimer : Double;
   public
     Exists    : Boolean;
     StartTime : Double;
     ClockRate : Double;
     PROCEDURE Delay(ms: double);
   End;

  TALMotorGL = class(TComponent)
  private
    FActPosition: TPoint3D;
    FWorkingMode: TWorkingMode;
    FOnActPosition: TActPositionChangeEvent;
    FPillanatAlljEvent: TPillanatAlljChangeEvent;
    FOnWorkingMode: TWorkingModeChangeEvent;
    FOnWorkOnOff: TWorkOnOffChangeEvent;
    FWorkTime: TWorkTimeChangeEvent;
    FWorkWay: TWorkWayChangeEvent;
    FSablonImage: TALPapirGL;
    FMMPerLepesY: extended;
    FMMPerLepesX: extended;
    FMMPerLepesZ: extended;
    fPillanatAllj: boolean;
    FWorkOn: boolean;
    FFolytonosVagas: boolean;
    FHeadStatus: boolean;
    FSTOP: boolean;
    FLapmeretHEIGHT: integer;
    FKiemeles: integer;
    FActPosPrecision: integer;
    FQuickVelocity: integer;
    FNegativHead: integer;
    FLapmeretWIDTH: integer;
    FWorkVelocity: integer;
    FSebesseg: integer;
    FkesleltetesMINz: longint;
    FkesleltetesMIN: longint;
    FActPositionLabel: TLabel;
    FMoveOption: TMoveOption;
    FSebessegOption: TSebessegOption;
    fCorrection: extended;
    fSablonSzinkron: boolean;
    fOverRunEvent: TOverRunEvent;
    fSTOPx0: boolean;
    fSTOPx1: boolean;
    fSTOPy0: boolean;
    fSTOPy1: boolean;
    FWorkingEnable: boolean;
    fSTOPEvent: TSTOPEvent;
    fIsMachine: boolean;
    FDelayCorrection: extended;
    FHeadStatusChange: THeadStatusEvent;
    fMotorMethod: TMotorMethod;
    FLineTemperature: integer;
    FLineOk: TLineOk;
    FSzakadas: boolean;
    FSzakadasEvent: TSzakadasEvent;
    FSzakadasVolt: boolean;
    FDownUp: boolean;
    FChangeConnection: TChangeConnection;
    FUSBName: string;
    FTerminalSwitch: boolean;
    FComPort: byte;
    FPackCount: word;
    FVecCount: word;
    fOnCTS: TNotifyEvent;
    FRxQue: TRxQueEvent;
    FPackSize: byte;
    FDownload: TDownloadEvent;
    procedure SetActPosition(const Value: TPoint3D);
    procedure SetWorkingMode(const Value: TWorkingMode);
    procedure SetSablonImage(const Value: TALPapirGL);
    procedure SetActPositionLabel(const Value: TLabel);
    procedure SetkesleltetesMIN(const Value: longint);
    procedure SetLapmeretHEIGHT(const Value: integer);
    procedure SetLapmeretWIDTH(const Value: integer);
    procedure SetPillanatAllj(const Value: boolean);
    procedure SetQuickVelocity(const Value: integer);
    procedure SetSebesseg(const Value: integer);
    procedure SetSebessegOption(const Value: TSebessegOption);
    procedure SetSTOP(const Value: boolean);
    procedure SetWorkOn(const Value: boolean);
    procedure SetWorkVelocity(const Value: integer);
    procedure SetActPosPrecision(const Value: integer);
    procedure SetMMPerLepesX(const Value: extended);
    procedure SetMMPerLepesY(const Value: extended);
    procedure SetMMPerLepesZ(const Value: extended);
    procedure SetkesleltetesMINz(const Value: longint);
    procedure SetKiemeles(const Value: integer);
    procedure SetNegativHead(const Value: integer);
    procedure SetCorrection(const Value: extended);
    procedure SetSablonSzinkron(const Value: boolean);
    procedure SetOverRun(const Index: Integer; const Value: boolean);
    procedure SetWorkingEnable(const Value: boolean);
    procedure Timer(Sender:TObject);
    procedure setIsMachine(const Value: boolean);
    procedure SetHeadStatus(const Value: boolean);
    procedure SetMotorMethod(const Value: TMotorMethod);
    procedure SetLineTemperature(const Value: integer);
    procedure SetSzakadas(const Value: boolean);
    procedure Heating(LTemp: integer);
    procedure SetSzakadasVolt(const Value: boolean);
    procedure SetDownUp(const Value: boolean);
    function GetVecCount: word;
    procedure OnCTSEvent(Sender: TObject);
    function GetConnected: boolean;
    procedure SetPackSize(const Value: byte);
    procedure SetComPort(const Value: byte);
  protected
    alfa : extended;               {Az aktuális mozgás iránya radiánban}
    H_Next,V_Next,Z_Next: integer;        {Vizszintes,függõleges számláló léptetéshez}
    dTimer : TTimer;
  public
    demo            : boolean;            {Demonstrációs program}
    FactoryConfig   : TFactoryConfig;
    HRT             : THRTimer;           // Precíz idõzítõ
    toll            : boolean;            {Toll lent=True, fent=False}
    oldActPosition  : TPoint3d;           {Régi aktuális pozíció}
    SourcePosition  : TPoint3D;
    DestPosition    : TPoint3D;
    kesleltetes,Quickkesleltetes,Workkesleltetes : double;
    StepDirectionX  : TStepDirection;    {Az X tengely mentén mozgás iránya}
    StepDirectionY  : TStepDirection;    {Az Y tengely mentén mozgás iránya}
    StepDirectionZ  : TStepDirection;    {Az Z tengely mentén mozgás iránya}
    StepX,StepY     : longint;           {x,y irányú lépések száma}
    WorkTime        : double;            {Gyártási idõ msec}
    WorkTimePerMM   : double;            {1 mm hossz gyártási ideje}
    oldXDir, oldYDir: integer;
    //------ Serial COM ------------
    SerialCOM       : TSerialCom;        // Component for serial communication
    PackStream      : TMemoryStream;     // Stream for Title+Data packs
    COM_TITLE       : COM_OUTTITLE_Record;
    COM_DATA        : COM_OUTDATA_Record;
    COM_CLOSE       : COM_OUTCLOSE_Record;
    COM_IN          : COM_IN_Record;
    ALLCurve        : TCurve;            // Teljes vágási terv egyetlen objektumban
    ActualPackType  : word;              // Aktuális csomag tipusa (0..3)
    ActualPackNo    : word;              // Aktuális csomag sorszáma
    NextPackVector  : integer;           // Következõ vektor indexe
    oldConnected    : boolean;           // COM port kapcsolódik-e?
    oldCTSState     : boolean;           // CTS vonal állapota
    fifo            : FIFORec;           // Vezérlõ visszajelzése

    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;

    Procedure Up;
    Procedure Down;
    Procedure Left;
    Procedure Right;
    procedure Wait;
    procedure WaitTime(sec:integer);
    procedure VekOut(dx,dy:extended;PENDOWN:boolean);
    procedure Working(AObject,AItem:integer);
    Procedure GotoNullPosition;
    Function  GotoXYPosition(x,y:extended) : boolean;
    procedure GotoAbsolutNullPosition;
    procedure TotalWorking;
    procedure WorkingFromPoint(ap:longint);
    procedure DrawWorkWay(AItem:integer);

        {VészSTOP-ot nyomtak-e?}
    function GetSTOP:boolean;
        {Végállások lekérdezése}
    procedure GetOverRun;
    function GetTotalWorkWay:double;

    {A STFACTORY32.FAC konf. fileba menti ill. betölti a
     FactoryConfig rekordot}
    procedure ConfigInit;
    Function ConfigLoad(iFileNev:string):boolean;
    Function ConfigSave(iFileNev:string):boolean;
    procedure FactoryDefaultSave;
    procedure FactoryDefaultLoad;

    Property IsMachine: boolean read fIsMachine write setIsMachine;
    Property ActPosition : TPoint3D read FActPosition write SetActPosition;
    Property LepesX : extended read FMMPerLepesX ;
    Property LepesY : extended read FMMPerLepesY ;
    Property LepesZ : extended read FMMPerLepesZ ;
    Property STOPx0 : boolean index 1 read fSTOPx0 write SetOverRun;
    Property STOPx1 : boolean index 2 read fSTOPx1 write SetOverRun;
    Property STOPy0 : boolean index 3 read fSTOPy0 write SetOverRun;
    Property STOPy1 : boolean index 4 read fSTOPy1 write SetOverRun;
    {Gyártási úthossz mm}
    Property TotalWorkWay : double read GetTotalWorkWay;
    property Szakadas: boolean read FSzakadas write SetSzakadas default False;
    property SzakadasVolt : boolean read FSzakadasVolt write SetSzakadasVolt;

    //---------- COM Specials ------------
    function GetFirstCOMPort: integer;
    function  ComOpen(PortN: byte): boolean;
    procedure InitCOMPort;
    function InitComWorking: boolean;
    function InitComTitle: COM_OUTTITLE_Record;
    function InitComData: COM_OUTDATA_Record;
    function InitComClose: COM_OUTCLOSE_Record;
    function GenerateAllInCurve: integer;   // All curve converst all in one
    function GetPackCount: word;
    function GetVectorPerPack(idx: word): word;
    function VecToDataRecord(dx,dy: extended): COM_OUTDATA_Record;
    function GetCheckSum: byte;
    procedure ComWorking(AItem:integer);
    procedure ComGotoXY(x,y: extended);
    procedure ComGotoRealative(dx,dy: extended);
    procedure ComTransfer;
    procedure TimerOnOff(onoff: boolean);

    procedure BlueToothWorking(AItem: integer);

    // Vectorok száma
    property VecCount : word read GetVecCount write FVecCount;
    // Csomagok száma
    property PackCount : word read GetPackCount write FPackCount;
    property Connected : boolean read GetConnected;

  published
    property ComPort : byte read FComPort write SetComPort;
    property PackSize: byte read FPackSize write SetPackSize;
    property MotorMethod: TMotorMethod read fMotorMethod write SetMotorMethod;
    Property SablonImage : TALPapirGL read FSablonImage write SetSablonImage;
    Property ActPositionLabel : TLabel read FActPositionLabel write SetActPositionLabel;
    Property ActPosPrecision : integer read FActPosPrecision write SetActPosPrecision;
    Property FolytonosVagas : boolean read FFolytonosVagas write FFolytonosVagas;
    Property KesleltetesMIN : longint read FkesleltetesMIN write SetkesleltetesMIN;
    Property KesleltetesMINz : longint read FkesleltetesMINz write SetkesleltetesMINz;
    Property LapmeretHEIGHT : integer read FLapmeretHEIGHT write SetLapmeretHEIGHT;
    Property LapmeretWIDTH : integer read FLapmeretWIDTH write SetLapmeretWIDTH;
    Property LineTemperature: integer read FLineTemperature write SetLineTemperature;
    // Szál hõmérséklet: 0=Kikapcsolva; 1: alacsony hõfok 2>=Magas vágási hõfok
    Property MMPerLepesX : extended read FMMPerLepesX write SetMMPerLepesX ;
    Property MMPerLepesY : extended read FMMPerLepesY write SetMMPerLepesY ;
    Property MMPerLepesZ : extended read FMMPerLepesZ write SetMMPerLepesZ ;
    Property QuickVelocity : integer read FQuickVelocity write SetQuickVelocity;
    Property WorkVelocity : integer read FWorkVelocity write SetWorkVelocity;
    Property Sebesseg : integer read FSebesseg write SetSebesseg default 1;
    Property MoveOption : TMoveOption read FMoveOption write FMoveOption;
    Property SebessegOption : TSebessegOption read FSebessegOption
                            write SetSebessegOption;
    Property Kiemeles : integer read FKiemeles write SetKiemeles;
    Property HeadStatus : boolean read FHeadStatus write SetHeadStatus;
    Property NegativHead : integer read FNegativHead write SetNegativHead;
        {VÉSZSTOP : True -> Working, WorkOn = False}
    Property STOP : boolean read FSTOP write SetSTOP;
        {Pillanatállj : True -> Working=True; WorkOn=False}
    Property PillanatAllj : boolean read fPillanatAllj write SetPillanatAllj;
        {Gyártás engedélyezett = True}
    Property WorkingEnable : boolean read FWorkingEnable write SetWorkingEnable;
        {Gyártás folyamatban = True; WorkigMode<>wmTest esetén}
    Property WorkOn : boolean read FWorkOn write SetWorkOn;
        {Gyártási mód : wmTest, wmCut, wmGravir}
    Property WorkingMode : TWorkingMode read FWorkingMode write SetWorkingMode;
    Property Correction: extended read fCorrection write SetCorrection;
    property SablonSzinkron: boolean read fSablonSzinkron write SetSablonSzinkron;
    property DelayCorrection: extended read FDelayCorrection write fDelayCorrection;
        // Végállás kapcsolók figyelése
    property TerminalSwitch: boolean read FTerminalSwitch write FTerminalSwitch;
    // Kezdési pont alúl vagy fölül
    property DownUp: boolean read FDownUp write SetDownUp default True;
    Property OnActPosition : TActPositionChangeEvent read FOnActPosition write FOnActPosition;
    Property OnWorkOnOff : TWorkOnOffChangeEvent read FOnWorkOnOff write FOnWorkOnOff;
    Property OnWorkingMode : TWorkingModeChangeEvent read FOnWorkingMode write FOnWorkingMode;
    Property OnWorkTimeChangeEvent : TWorkTimeChangeEvent read FWorkTime
             write FWorkTime;
    Property OnWorkWayChangeEvent : TWorkWayChangeEvent read FWorkWay
             write FWorkWay;
    Property OnPillanatAllj : TPillanatAlljChangeEvent read FPillanatAlljEvent
             write FPillanatAlljEvent;
    Property OnOverRun: TOverRunEvent read fOverRunEvent write fOverRunEvent;
    property OnSTOP: TSTOPEvent read fSTOPEvent write fSTOPEvent;
    property OnHeadStatusChange: THeadStatusEvent read FHeadStatusChange write FHeadStatusChange;
    property OnLineOk: TLineOk read FLineOk write FLineOk;
    property OnSzakadasEvent : TSzakadasEvent read FSzakadasEvent write FSzakadasEvent;
    property OnChangeConnection: TChangeConnection read FChangeConnection
             write FChangeConnection;
    property OnCTS: TNotifyEvent read FOnCTS write FOnCTS;
    property OnRxQue: TRxQueEvent read FRxQue write FRxQue;
    property OnDownload: TDownloadEvent read FDownload write FDownload;
  end;

procedure Register;

function Point2D(X, Y : double): TPoint2D;
function Point3D(X, Y, Z: double): TPoint3D;

CONST   TLPTPortName : Array[1..3] of String[4]= ('LPT1','LPT2','LPT3');
        MOTTAB:  Array[0..7] of Byte = ($27,$2D,$1C,$0D,$03,$09,$38,$29);

const COMInfo : array[0..12] of string =
        ('Processor in Main Menu',
         'Processor in Hand Mode',
         'Processor Wait for Data',
         'Cutting Disabled',
         'Processor Restart',
         'Pack is OK!',
         'Pack Repeat Request',
         'Pack not Ok in Second Time',
         'Pack Cutting in Process',
         'End of Pack Cutting',
         'End of Last Packing',
         'END',
         'Time Overflow Error!');

MotorMethodStr: array[0..4] of string =
        ('LPT','New','USB','Serial COMM.','BlueTooth');
         
Var     MotorConstans : extended;
        LPTBazis : byte absolute $408;


implementation

procedure Register;
begin
  RegisterComponents('AL',[TALMotorgl]);
end;

function Point2D(X, Y: double): TPoint2D;
begin
  Point2D.X := X;
  Point2D.Y := Y;
end;

function Point3D(X, Y, Z: double): TPoint3D;
begin
  Point3D.X := X;
  Point3D.Y := Y;
  Point3D.Z := Z;
end;

// ---- a FactoryConfig rekordot alapértékekkel tölti fel -----
procedure TALMotorGL.ConfigInit;
begin
end;

Function TALMotorGL.ConfigLoad(iFileNev:string):boolean;
var resu: integer;
    f : file;
begin
  Try
  If FileExists(iFileNev) then begin
    Try
     AssignFile(f,iFileNev);
     Reset(f,1);
     BlockRead(f,FactoryConfig,Sizeof(FactoryConfig),Resu);
     Result:=True;
    finally
     CloseFile(f);
    end;
  end else Result:=False;
  except
     Result:=False;
  end;
end;

Function TALMotorGL.ConfigSave(iFileNev:string):boolean;
var resu: integer;
    f : file;
    s: string;
begin
  Try
     Result:=True;
     {$I-}
     AssignFile(f,iFileNev);
     Rewrite(f,1);
     s:=FactoryConfig.filenev;
     BlockWrite(f,FactoryConfig,Sizeof(FactoryConfig),Resu);
     CloseFile(f);
     {$I+}
  except
     Result:=False;
  end;
end;

//-----------THRTimer-----------------

Constructor THRTimer.Create;
Var  QW : _Large_Integer;
BEGIN
   Inherited Create;
   Exists := QueryPerformanceFrequency(TLargeInteger(QW));
   ClockRate := QW.QuadPart;
END;

Function THRTimer.StartTimer : Boolean;
Var
  QW : _Large_Integer;
BEGIN
   Result := QueryPerformanceCounter(TLargeInteger(QW));
   StartTime := QW.QuadPart;
END;

Function THRTimer.ReadTimer : Double;
Var
  ET : _Large_Integer;
BEGIN
   QueryPerformanceCounter(TLargeInteger(ET));
   Result := 1000.0*(ET.QuadPart - StartTime)/ClockRate;
END;

PROCEDURE THRTimer.Delay(ms: double);
Var
  QW,ET : _Large_Integer;
  Start_Time, dt : double;
BEGIN
   QueryPerformanceCounter(TLargeInteger(QW));
   Start_Time := QW.QuadPart;
   repeat
         QueryPerformanceCounter(TLargeInteger(ET));
         dt := 1000.0*(ET.QuadPart - Start_Time)/ClockRate;
   Until dt>=ms;
END;



{ TALMotors }

constructor TALMotorGL.Create(AOwner: TComponent);
begin
     DecimalSeparator:='.';
     demo             := False;
     fMotorMethod     := mmCom;
     FPillanatAllj    := False;
     FkesleltetesMIN  := 5000;
     FkesleltetesMINz := 5000;

     FMMPerLepesX     := MotorConstans;
     FMMPerLepesY     := MotorConstans;
     FMMPerLepesZ     := MotorConstans;

     FActPosition     := Point3D(0,0,0);
     oldActPosition   := Point3D(-100,-100,0);
     FActPosPrecision := 0;
     FWorkingMode     := wmTest;
     FWorkVelocity    := 50;
     FQuickVelocity   := 100;
     Fworkingenable   := True;
     FWorkOn          := False;
     FFolytonosVagas  := False;
     StepX            := 0;
     StepY            := 0;
     H_Next           := 0;
     V_Next           := 0;
     Z_Next           := 0;
     FKiemeles         := 100;
     HeadStatus        := False;
     FNegativHead      := 1;
     WorkTime          := 0;
     WorkTimePerMM     := 0;
     FCorrection       := 0;
     fSTOPx0           := True;
     fSTOPx1           := True;
     fSTOPy0           := True;
     fSTOPy1           := True;
     fIsMachine       := False;
     fDelayCorrection := 1;
     fSablonSzinkron  := False;
     HRT:=THRTimer.Create;
     FSzakadasVolt    := False;
     FSzakadas        := False;
     LineTemperature  := 0;       // kikapcsolva
     IsMachine        := True;
     oldXDir := 100;
     oldYDir := 100;

     // COM Specific variables

     TerminalSwitch := False;
     ALLCurve         := TCurve.Create;
     with ALLCurve do begin
          ID          := 1;
          Name        := 'Cutting Plan';
          Closed      := False;
          Shape       := dmPolyline;
     end;
     PackStream       := TMemoryStream.Create;
     oldConnected     := False;
     oldCTSState      := True;
//     FMotorMethod     := mmBlueTooth;
     InitCOMPort;
     dTimer           := TTimer.Create(Self);
     dTimer.Interval  := 100;
     dTimer.OnTimer   := Timer;
     DownUp           := True;
  inherited;
end;

destructor TALMotorGL.Destroy;
begin
  dTimer.Free;
  HRT.Free;
  ALLCurve.Free;
  PackStream.Free;
  If SerialCOM<>nil then BEGIN
     SerialCOM.Close;
     SerialCOM.Free;
  END;
  inherited;
end;


(*---------- KIEGÉSZITÕ RUTINOK ----------*)


Procedure TALMotorGL.Up;
begin
//If (not fSTOPy1) or (WorkingMode=wmTest) then begin
  ActPosition:=Point3d(ActPosition.x,ActPosition.y+MMPerLepesY,ActPosition.z);
  Wait;
//end;
end;

Procedure TALMotorGL.Down;
begin
//If (not fSTOPy0) or (WorkingMode=wmTest) then begin
  ActPosition:=Point3d(ActPosition.x,ActPosition.y-MMPerLepesy,ActPosition.z);
  Wait;
//end;
end;

Procedure TALMotorGL.Left;
begin
//If (not fSTOPx0) or (WorkingMode=wmTest) then begin
  ActPosition:=Point3d(ActPosition.x-MMPerLepesX,ActPosition.y,ActPosition.z);
  Wait;
//end;
end;

Procedure TALMotorGL.Right;
begin
//If (not fSTOPx1) or (WorkingMode=wmTest) then begin
  ActPosition:=Point3d(ActPosition.x+MMPerLepesX,ActPosition.y,ActPosition.z);
  Wait;
//end;
end;


// CutOn = vágóláng megy-e? Ez vegye figyelembe a rutin
// Ha lemászik az asztalról kapcsolja ki a lángot
procedure TALMotorGL.GetOverrun;
Var
     statusByte : byte;
     kesz       : byte;
     vegallas   : byte;
     veSTOP     : byte;
     k          : integer;
begin
  if TerminalSwitch then begin
       STOPx0   := True;
       STOPx1   := True;
       STOPy0   := True;
       STOPy1   := True;
  end;
end;

function TALMotorGL.GetSTOP:boolean;
Var  _STB : word;
     _STA : word;
     statusByte : byte;
     kesz       : byte;
     vegallas   : byte;
     veSTOP     : byte;
     k          : integer;
begin
       Result := False;
       WorkOn := True;
end;

procedure TALMotorGL.Wait;
var k: longint;
begin
if Kesleltetes>0 then
   HRT.Delay(kesleltetes);
end;

{Várakozás sec másodpercig}
procedure TALMotorGL.WaitTime(sec:integer);
var d1:TDateTime;
    h,m,s,ms: word;
begin
  d1:=Now;
  repeat
    DecodeTime(Now-d1,h,m,s,ms);
    if (lo(GetAsyncKeyState(VK_RETURN)) = 1)
    then
        Exit;
  Until s>=sec;
end;

procedure TALMotorGL.SetActPosition(const Value: TPoint3D);
Var xx,yy: integer;
begin
  FActPosition := Value;
     If FActPositionLabel<>nil then begin
        ActPositionLabel.Caption :=
                Format('%6.1f',[FActPosition.x])+' : '+
                Format('%6.1f',[FActPosition.y]);
     end;

     If SablonImage<>nil then
     With SablonImage do begin
        DrawWorkPoint(Value.x,Value.y);
     end;
     If Assigned(FOnActPosition) then FOnActPosition(Self,Value);
end;

{ A gyártási mód beállítása }
procedure TALMotorGL.SetWorkingMode(const Value: TWorkingMode);
var oldWM: TWorkingMode;
begin
  If FWorkingMode <> Value then begin
     oldWM:= FWorkingMode;
     FWorkingMode := Value;
     Case Value of
     wmTest   : WorkOn:=False;
     wmCut    : WorkOn:=True;
     wmGravir : WorkOn:=True;
     wmPlazma : WorkOn:=True;
     end;
     FactoryConfig.WorkingMode := Ord(Value);
  end;
  If Assigned(FOnWorkingMode) then FOnWorkingMode(Self,Value);
end;


procedure TALMotorGL.SetSablonImage(const Value: TALPapirGL);
begin
  If FSablonImage<>Value then begin
     FSablonImage:=Value;
  end;
end;

procedure TALMotorGL.SetActPositionLabel(const Value: TLabel);
begin
  If FActPositionLabel<>Value then begin
     FActPositionLabel:=Value;
     ActPosition := FActPosition;
  end;
end;

procedure TALMotorGL.SetkesleltetesMIN(const Value: longint);
begin
     FkesleltetesMIN := Value;
     Quickkesleltetes := FKesleltetesMIN * (100-QuickVelocity);
     Workkesleltetes  := FKesleltetesMIN * (100-WorkVelocity);
     kesleltetes := Quickkesleltetes;
     FactoryConfig.KesleltetesMIN := Value;
end;

procedure TALMotorGL.SetLapmeretWIDTH(const Value: integer);
begin
  FLapmeretWIDTH := Value;
  If SablonImage<>nil then begin
     SablonImage.Paper.x := Value;
     FactoryConfig.Paper.x := Value;
  end;
end;

procedure TALMotorGL.SetLapmeretHEIGHT(const Value: integer);
begin
  FLapmeretHEIGHT := Value;
  If SablonImage<>nil then begin
     SablonImage.Paper.y := Value;
     FactoryConfig.Paper.y := Value;
  end;
end;

procedure TALMotorGL.SetQuickVelocity(const Value: integer);
begin
     If Value<=0 then FQuickVelocity :=1
     else FQuickVelocity := Value;
     FactoryConfig.PosSebesseg := Value;
     Quickkesleltetes := Trunc(KesleltetesMIN * (100/FQuickVelocity));
     If SablonImage<>nil then FactoryConfig.PosSebesseg:=FQuickVelocity;
end;

procedure TALMotorGL.SetSebesseg(const Value: integer);
begin
  FSebesseg := Value;
  WorkVelocity := Value;
end;

procedure TALMotorGL.SetSebessegOption(const Value: TSebessegOption);
begin
  FSebessegOption := Value;
end;

procedure TALMotorGL.SetWorkVelocity(const Value: integer);
var kk: double;

     Function GetDelayCorrection(seb:double):double;
     var k1,k2: integer; // Elõzõ,következõ egész sebesség indexe
         d1,d2: double;
     begin
       With FactoryConfig do begin
         k1:=Trunc(seb); k2:=Trunc(seb+1);
         d1:=TimeCorrection[k1];
         d2:=TimeCorrection[k2];
         Result := d1+(seb-k1)*(d2-d1);
       end;
     end;

begin
  If Value<=0 then FWorkVelocity:=1 else
     FWorkVelocity := Value;
     DelayCorrection := GetDelayCorrection(FWorkVelocity);
     Workkesleltetes := FactoryConfig.TimeCorrection[Value];
     FactoryConfig.WorkSebesseg := FWorkVelocity;
end;

procedure TALMotorGL.SetActPosPrecision(const Value: integer);
begin
  FActPosPrecision := Value;
  FactoryConfig.Precizio := Value;
end;

procedure TALMotorGL.SetMMPerLepesX(const Value: extended);
begin
  FMMPerLepesX := Value;
  FactoryConfig.LepesX := FMMPerLepesX; //MotorConstans;
  IF SablonImage<>nil then SablonImage.MMPerLepes := Value;
end;

procedure TALMotorGL.SetMMPerLepesY(const Value: extended);
begin
  FMMPerLepesY := Value;
  FactoryConfig.LepesY := FMMPerLepesY; //MotorConstans;
end;

procedure TALMotorGL.SetMMPerLepesZ(const Value: extended);
begin
  FMMPerLepesZ := Value;
  FactoryConfig.LepesZ := FMMPerLepesZ; //MotorConstans;
end;

procedure TALMotorGL.SetkesleltetesMINz(const Value: longint);
begin
  FkesleltetesMINz := Value;
  FactoryConfig.KesleltetesMINz := Value;
end;

procedure TALMotorGL.SetKiemeles(const Value: integer);
begin
  FKiemeles := Value;
  FactoryConfig.Kiemeles := Value;
end;

procedure TALMotorGL.SetNegativHead(const Value: integer);
begin
  FNegativHead := Value;
  FactoryConfig.NegativHead := Value;
end;

procedure TALMotorGL.SetCorrection(const Value: extended);
begin
  fCorrection := Value;
  FactoryConfig.Correction := Value;
end;

procedure TALMotorGL.FactoryDefaultLoad;
begin
  If FileExists('FACTORY.FAC') then
    ConfigLoad('FACTORY.FAC')
  else
    ShowMessage('FACTORY.FAC file betöltése sikertelen')
end;

procedure TALMotorGL.FactoryDefaultSave;
begin
 Try
  ConfigSave('FACTORY.FAC');
 except
  exit;
 end;
end;

procedure TALMotorGL.TotalWorking;
begin
  If SablonImage<>nil then begin
    SablonImage.FCurveList.First;
    GenerateAllInCurve;
    Case MotorMethod of
    mmCOM : ComWorking(0);
    mmBlueTooth: BlueToothWorking(0);
    end;
  end;
end;

procedure TALMotorGL.WorkingFromPoint(ap: Integer);
begin
    GenerateAllInCurve;
    ComWorking(ap);
end;

procedure TALMotorGL.GotoNullPosition;
begin
  if (not szakadas) and (WorkingMode<>wmTest) then LineTemperature := 2;
  If DownUp then begin
     If (actPosition.x<>0) or (actPosition.y<>0) then
        VekOut(-actPosition.x,-ActPosition.y,True);
  end else begin
     If (actPosition.x<>0) or (actPosition.y<>Factoryconfig.Paper.y) then
        VekOut(-actPosition.x,Factoryconfig.Paper.y-ActPosition.y,True);
  end;
  if (not szakadas) and (WorkingMode<>wmTest) then LineTemperature := 1;
end;

function TALMotorGL.GotoXYPosition(x, y: extended): boolean;
var dx,dy: extended;
begin
  if (not szakadas) and (WorkingMode<>wmTest) then LineTemperature := 2;
  SourcePosition := actPosition;
  DestPosition := Point3D(x,y,actPosition.z);
  dx:=DestPosition.x - SourcePosition.x;
  dy:=DestPosition.y - SourcePosition.y;
  HeadStatus := False;
  if (not szakadas) and (WorkingMode<>wmTest) then LineTemperature := 1;
end;

function TALMotorGL.GetTotalWorkWay:double;
// A teljes sablon hossza mm-ben
var i,j : integer;
    x,y,ox,oy : TFloat;
    Cuv : TCurve;
begin
If ComponentState=[] then begin
  Result := 0;
  ox:=ActPosition.x; oy:=ActPosition.Y;
  If SablonImage<>nil then
  With SablonImage do
  For i:=0 to FCurveList.Count-1 do begin
       Cuv := FCurveList.Items[i];
        For j:=0 to Cuv.FPoints.Count-1 do begin
            Cuv.GetPoint(j,x,y);
            Result := Result + sqrt(sqr(x-ox)+sqr(y-oy));
            ox:=x; oy:=y;
        end;
        If Cuv.Closed then begin
            Cuv.GetPoint(0,x,y);
            Result := Result + sqrt(sqr(x-ox)+sqr(y-oy));
            ox:=x; oy:=y;
        end;
  end;
end;
end;

procedure TALMotorGL.SetSablonSzinkron(const Value: boolean);
begin
  fSablonSzinkron := Value;
end;

procedure TALMotorGL.SetOverRun(const Index: Integer; const Value: boolean);
begin
  Case Index of
  1: fSTOPx0 := Value;
  2: fSTOPx1 := Value;
  3: fSTOPy0 := Value;
  4: fSTOPy1 := Value;
  end;
  If Assigned(fOverRunEvent) then
    fOverRunEvent(Self,fSTOPx0,fSTOPx1,fSTOPy0,fSTOPy1);
end;

procedure TALMotorGL.SetSTOP(const Value: boolean);
begin
  {VÉSZSTOP esetén minden letiltva}
  FSTOP := Value;
  WorkingEnable := not Value;
  IF WorkOn then
     WorkOn := not Value;
  if Sablonimage<>nil then SablonImage.STOP := Value;
  If Assigned(fSTOPEvent) then fSTOPEvent(Self,Value);
end;

procedure TALMotorGL.SetWorkingEnable(const Value: boolean);
begin
  {Gyártás engedélyezés: False esetben a folyamatban lévõ gyártás
    letiltása}
  FWorkingEnable := Value;
  If fWorkOn then fWorkOn := Value;
end;

procedure TALMotorGL.SetWorkOn(const Value: boolean);
begin
  {Valódi gyártási folyamat jelzése = True esetben}
  FWorkOn := Value;
  If Assigned(FOnWorkOnOff) then FOnWorkOnOff(Self,Value);
end;

procedure TALMotorGL.SetPillanatAllj(const Value: boolean);
begin
//  If FPillanatAllj<>Value then begin
  If ComponentState <> [csDestroying] then begin

     FPillanatAllj := Value;
     If Assigned(FPillanatAlljEvent) then FPillanatAlljEvent(Self,Value);

     if (WorkingMode<>wmTest) then
     begin
          If Value then begin
             if not SzakadasVolt then
                Heating(1);
          end
          else
             Heating(2);
     end
       else
       if not SzakadasVolt then
          LineTemperature := 1;

     Repeat
       Application.ProcessMessages;
     Until ((not FPillanatAllj) or STOP) and (not SzakadasVolt);

  end;

end;

procedure TALMotorGL.GotoAbsolutNullPosition;
var szele: boolean;
begin
  {Fej elmozgatása x irányban végállásig}
  if (not szakadas) and (WorkingMode<>wmTest) then LineTemperature := 2;
     ActPosition:=Point3d(0,FactoryConfig.Paper.y,0);
  if (not szakadas) and (WorkingMode<>wmTest) then LineTemperature := 1;
end;

procedure TALMotorGL.setIsMachine(const Value: boolean);
begin
  If fIsMachine <> Value then begin
     fIsMachine := Value;
  end;
  if Assigned(FChangeConnection) then FChangeConnection(Self,SerialCOM.Connected);
end;

procedure TALMotorGL.SetHeadStatus(const Value: boolean);
begin
  FHeadStatus := Value;
  If Assigned(FHeadStatusChange) then FHeadStatusChange(Self,Value);
end;

procedure TALMotorGL.SetMotorMethod(const Value: TMotorMethod);
begin
  fMotorMethod := Value;
//  InitCOMPort;
end;


// Szál hõfokának beállítása
procedure TALMotorGL.SetLineTemperature(const Value: integer);
begin
     FLineTemperature := Value;
          if not Szakadas then begin
             Heating(Value);
          end else
             Pillanatallj := True;
     if Assigned(FLineOk) then FLineOk(Self,LineTemperature,Szakadas);
end;

procedure TALMotorGL.Heating(LTemp: integer);
begin
     FLineTemperature := LTemp;
end;

procedure TALMotorGL.SetSzakadas(const Value: boolean);
begin
  if FSzakadas <> Value then begin
     FSzakadas := Value;
     if Assigned(FLineOk) then FLineOk(Self,LineTemperature,FSzakadas);
     if Value then begin
        SzakadasVolt := True;
     end;
     PillanatAllj:=Value;
  end;
end;


procedure TALMotorGL.SetSzakadasVolt(const Value: boolean);
VAR statusByte : byte;
begin
  FSzakadasVolt := Value;
//  dTimer.Enabled := False;
  Heating(0);
end;

procedure TALMotorGL.SetDownUp(const Value: boolean);
begin
  FDownUp := Value;
  if Sablonimage<>nil then
  if FDownUp then
     Sablonimage.WorkOrigo := Point2d(0,Sablonimage.Paper.y)
  else
     Sablonimage.WorkOrigo := Point2d(0,0);
  inherited;
end;

procedure TALMotorGL.VekOut(dx,dy:extended;PENDOWN:boolean);
var i,x,y,lepesszam: integer;
    d,xr,yr,s,c,lepeskoz : extended;
    alfa : double;
    okesleltetes,correction: double;
    DestPosition : TPoint3D;
begin
  DestPosition.x := ActPosition.x+dx;
  DestPosition.y := ActPosition.y+dy;

  WorkOn:=True;
  d := sqrt((dx*dx)+(dy*dy));
  If MMPerLepesX<MMPerLepesY then begin
     lepeskoz  := MMPerLepesX;
  end else begin
     lepeskoz  := MMPerLepesY;
  end;
  If PENDOWN then begin
     Kesleltetes:=WorkKesleltetes;
{     If WorkingMode=wmCut then HeadDown;}
  end else begin
     Kesleltetes:=QuickKesleltetes;
{     If WorkingMode=wmCut then HeadUp;}
  end;
  lepesszam := Round(d/lepeskoz);
  alfa := SzakaszSzog(0,0,dx,dy);
  xr := 0;
  yr := 0;
  s := lepeskoz*sin(alfa); c := lepeskoz*cos(alfa);

  okesleltetes:=Kesleltetes;
  if (lepesszam<>0) and ((Abs(dx)>lepeskoz) and (Abs(dy)>lepeskoz)) then begin
     correction:=Abs(lepesszam/(Abs(dx/lepeskoz)+Abs(dy/lepeskoz)));
     Kesleltetes:= Kesleltetes*(correction);
  end;

  For i:=1 to lepesszam do begin
//  Repeat
      x:=Round(xr/MMPerLepesX); y:=Round(yr/MMPerLepesY);
      xr := xr+c;
      yr := yr+s;
      If x<>Round(xr/MMPerLepesX) then begin
         If dx>0 then Right;
         If dx<0 then Left;
      end;
      If y<>Round(yr/MMPerLepesY) then begin
         If dy>0 then Up;
         If dy<0 then Down;
      end;
      If SablonImage<>nil then
      With SablonImage do begin
        if fSablonSzinkron then
            Centrum:=Point2d(ActPosition.x,ActPosition.y);
      end;

      WorkTime := HRT.ReadTimer;
      If Assigned(fWorkTime) then fWorkTime(Self,WorkTime);

(*      if (lo(GetAsyncKeyState(VK_ESCAPE)) > 0)
      then begin
           STOP := True;
      end;

      if (lo(GetAsyncKeyState(VK_SPACE)) > 0)
      then begin
           STOP := False;
           PillanatAllj := True;
      end;*)

      Application.ProcessMessages;
      if STOP then begin
         Kesleltetes:=okesleltetes;
         WorkOn := False;
         exit;
      end;
  end;
//  Until (Abs(DestPosition.x-ActPosition.x)<=lepeskoz) and (Abs(DestPosition.y-ActPosition.y)<=lepeskoz);
  Kesleltetes:=okesleltetes;
end;

procedure TALMotorGL.Working(AObject,AItem:integer);
var Cuv : TCurve;
    i,j,j0 : integer;
    x,y : double;
    elso: boolean;
    p : TPoint2d;
begin
If not STOP then begin
  If SablonImage<>nil then
  With SablonImage do begin
  Try
    elso := True;
    ShowPoints := False;
    CentralCross := True;
    SablonImage.Working := True;
    WorkPosition.CuvNumber := AObject;
    WorkPosition.PointNumber := AItem;
    Paint;
//    If WorkingMode<>wmTest then
    WorkOn:=True;
    dTimer.OnTimer := nil;
    HRT.StartTimer;
    For i:=AObject to FCurveList.Count-1 do begin
        Cuv := FCurveList.Items[i];
        If Cuv.Enabled then begin
        WorkPosition.CuvNumber := i;

        If elso then begin j0:=AItem; elso:=False;
        end else j0 := 0;

        HeadStatus := False;

        For j:=j0 to Cuv.FPoints.Count-1 do begin
            Cuv.GetPoint(j,x,y);
            WorkPosition.PointNumber := j;
            VekOut(x-ActPosition.x,y-ActPosition.y,True);
            If FactoryConfig.PlazmaMachine and (j=0) then begin
               { Zárt alakzatoknál fej státusza : láng begyujtás, kioltás }
               if Cuv.Closed then
                  WaitTime(Trunc(FactoryConfig.TimePlazma[FactoryConfig.PlazmaIndex,1]));
               HeadStatus := Cuv.Closed;
            end;
            if STOP then Break;
            if fSablonSzinkron then Centrum:=Point2d(x,y);
        end;
        if STOP then Break;
        // Closed curve back to 0. point if points count>2
        If Cuv.Closed and (Cuv.FPoints.Count>2) then begin
            Cuv.GetPoint(0,x,y);
            WorkPosition.PointNumber := j;
            VekOut(x-ActPosition.x,y-ActPosition.y,True);
            if STOP then exit;
            if fSablonSzinkron then Centrum:=Point2d(x,y);
        end;
        end;
        if assigned(fWorkTime) then
           fWorkTime(Self,HRT.ReadTimer);
    end
    finally
        SablonImage.Working := False;
        WorkOn := False;
        HeadStatus := False;
        dTimer.OnTimer := Timer;
    end;
  end;
end;
end;


// ============= COM specific rutins ===============================

function TALMotorGL.InitComWorking: boolean;
var
  VCount : integer;
begin
Try
  Result := True;
  ActualPackNo    := 0;
  ActualPackType  := 0;           // Elsõ csomag
  if PackCount=1 then
     ActualPackType  := 3;        // Elsõ és utolsó egyben
except
  Result := False;
end;
end;

procedure TALMotorGL.ComWorking(AItem:integer);
var Cuv : TCurve;
    i,j,j0,jd : integer;
    x0,y0 : double;
    x,y : double;
    elso: boolean;
    p : TPoint2d;
    Ok : boolean;
begin
if (WorkingMode=wmCut) then begin
Try
  InitComWorking;
    WorkOn:=True;
    HRT.StartTimer;
  j0 := Aitem+1;
  AllCurve.GetPoint(Aitem,x,y);
  x0 := x;
  y0 := y;

  For i:= 0 to PackCount-1 do begin

      PackStream.Clear;
      ActualPackNo := i;
      if i>0 then
         ActualPackType := 1;        // Közbülsõ csomag
      if i=(PackCount-1) then
         ActualPackType := 2;        // Utolsó csomag
      if PackCount=1 then
         ActualPackType := 3;        // Elsõ és utolsó egyben

      COM_TITLE := InitComTitle;
      PackStream.Write(COM_TITLE, SizeOf(COM_OUTTITLE_Record));

     if (AllCurve.FPoints.Count-1-j0)>78 then
         jd := 78
      else
         jd := AllCurve.FPoints.Count-j0;

      For j:=j0 to j0+jd-1 do begin
          AllCurve.GetPoint(j,x,y);
          COM_DATA := VecToDataRecord(x-x0,y-y0);
          PackStream.Write(COM_DATA, SizeOf(COM_OUTDATA_Record));
          x0 := x;
          y0 := y;
      end;
      j0 := j;

      if assigned(fWorkTime) then
         fWorkTime(Self,HRT.ReadTimer);

      Application.ProcessMessages;
        if STOP then begin
           dTimer.Ontimer := Timer;
           WorkOn := False;
           Exit;
        end;

      COM_CLOSE := InitComClose;
      PackStream.Write(COM_CLOSE, SizeOf(COM_OUTCLOSE_Record));
      if assigned(fWorkTime) then
         fWorkTime(Self,HRT.ReadTimer);

      if ActualPackType = 2 then
         SerialCOM.RxPurge;

         if assigned(fWorkTime) then
            fWorkTime(Self,HRT.ReadTimer);
      dTimer.Ontimer := nil;
      SerialCOM.RxPurge;
      ComTransfer;
      Ok := False;
      DrawWorkWay(j);
      
         if assigned(fWorkTime) then
            fWorkTime(Self,HRT.ReadTimer);

      // Vez. visszajelzéseinek vizsgálata
      repeat
        IF (SerialCOM.RxQue mod 4 = 0) then begin
           SerialCOM.Read(fifo,4);
           If Assigned(FRxQue) then FRxQue(Self, fifo.Info, fifo.PackNo);
           Case fifo.Info of
           0,1:   Break;
           2  :   Ok := True;
           5  :   Ok := True;
           6  : begin
                  SerialCOM.RxPurge;
                  ComTransfer;
                  Ok := False;
                end;
           7,10  : Break;
           end;
        end;
        if assigned(fWorkTime) then
           fWorkTime(Self,HRT.ReadTimer);
        Application.ProcessMessages;
        if STOP then begin
           dTimer.Ontimer := Timer;
           WorkOn := False;
           Exit;
        end;
      until (SerialCOM.CTSState and Ok);

     dTimer.Ontimer := Timer;

  end; // for i
finally
        if assigned(fWorkTime) then
           fWorkTime(Self,HRT.ReadTimer);
  dTimer.Ontimer := Timer;
  WorkOn := False;
end;
end
  else If SablonImage<>nil then
    Working(0,0);
end;

procedure TALMotorGL.BlueToothWorking(AItem:integer);
var Cuv    : TCurve;
    i,d,m  : integer;
    x0,y0  : double;
    x,y    : double;
    p1,p2  : TPoint2d;
    vCount : word;
    h,l    : byte;
    he     : string;
    ChkSum : byte;
    mByte  : byte;
    hs,ls  : string[2];
    BT_DATA : BT_OUTDATA_Record;
    BTS    : TMemoryStream;
    Percent: integer;
    cts: string;
begin
if (WorkingMode=wmCut) then begin
Try
  InitComWorking;
  BTS := TMemoryStream.Create;
  WorkOn:=True;

  // Összes vektor kigyüjtése a PackStream-re

  PackStream.Clear;
  ChkSum := 0;

  // Vektorok száma
  vCount := AllCurve.Count-1;
  h := Hi(vCount); l := Lo(vCount);
  PackStream.Write(h, SizeOf(byte));
  PackStream.Write(l, SizeOf(byte));

  AllCurve.GetPoint(Aitem,x,y);
  x0 := x;
  y0 := y;
  For i:=1 to Pred(AllCurve.Count) do begin
      AllCurve.GetPoint(i,x,y);
      COM_DATA := VecToDataRecord(x-x0,y-y0);
      PackStream.Write(COM_DATA, SizeOf(COM_DATA));
      x0 := x;
      y0 := y;
      Application.ProcessMessages;
        if STOP then begin
           WorkOn := False;
           Exit;
        end;
  end; // for i

  ChkSum := GetCheckSum;
  PackStream.Write(ChkSum, SizeOf(byte));

  // Hexa átalkítások a BTS stream-re

  PackStream.Seek(0,0);
  // Nyitó karakter :
  h := 58;
  BTS.Write(h,1);
  For i:=1 to PackStream.Size do
  begin
    PackStream.Read(h,1);
    he:=Format('%2.2x',[h]);
    l:=Ord(he[1]);
    h:=Ord(he[2]);
    BTS.Write(l,1);
    BTS.Write(h,1);
  end;
  // Záró karakter ;
  h := 59;
  BTS.Write(h,1);

//      SerialCOM.RxPurge;

      // Send BTS Stream to BloeTooth

      SerialCOM.Events := [];
      BTS.Seek(0,0);
      Percent := 0;
      m := BTS.Size;

      SetLength(cts,m);
      For i:=1 to m do begin
          BTS.Read(mByte,1);
          cts[i]:=chr(mByte);
      end;
      SerialCOM.WriteString(cts);

      (* Lassú módszer
      For i:=1 to m do begin
          BTS.Read(mByte,1);
          SerialCOM.WriteString(chr(mByte));
          Application.ProcessMessages;
          if not WorkOn then exit;
          if Assigned(FDownload) then begin
             Percent := Round(100*i/BTS.Size);
             FDownload(Self,percent);
          end;
      end;
      *)
finally
  if assigned(fWorkTime) then
           fWorkTime(Self,HRT.ReadTimer);
  BTS.Free;
  WorkOn := False;
end;
end
  else If SablonImage<>nil then
    Working(0,0);
end;

// Drawing work way with red line
procedure TALMotorGL.DrawWorkWay(AItem:integer);
var i     : integer;
    x,y   : TFloat;
    p0,p  : TPoint;
begin
(*
  If (SablonImage<>nil) and (AllCurve.FPoints.Count>0) then begin
     SablonImage.Canvas.Pen.Width := 2;
     SablonImage.Canvas.Pen.Color := clRed;
     AllCurve.GetPoint(0,X,Y);
     p0 := SablonImage.MapPoint;
     SablonImage.Canvas.MoveTo(p0.x,p0.y);
     For i:=0 to AItem do begin
        AllCurve.GetPoint(I,X,Y);
        p := SablonImage.WtoS(x,y);
        SablonImage.Canvas.LineTo(p.x,p.y);
     end;
  end;*)
end;

function TALMotorGL.InitComTitle: COM_OUTTITLE_Record;
begin
  With Result do begin
    First     := $55;
    PackCount := GetPackCount;
    PackNo    := ActualPackNo;
    PackType  := ActualPackType;
    VecCount  := GetVectorPerPack(ActualPackNo);
  end;
end;

function TALMotorGL.InitComData: COM_OUTDATA_Record;
begin
  with Result do begin
       XCount_L := 0;
       XCount_H := 0;
       YCount_L := 0;
       YCount_H := 0;
       XTime  := 0;
       YTime  := 0;
  end;
end;

function TALMotorGL.InitComClose: COM_OUTCLOSE_Record;
begin
  With Result do begin
  CloseByte   := 0;            // = 0;
  CheckSum    := GetCheckSum;  // Ellenõrzõ összeg: SUM AND $FF
  end;
end;


function TALMotorGL.GetPackCount: word;
begin
// Result := Veccount;
 Result := VecCount div 78;
 if (VecCount mod 78)>0 then Inc(Result);
end;

{ Összes objektumot egyetlen nyilt (Polyline) objektumba konvertál
  Result = Polyline vektorok száma (Vektorszám = Támpontok száma - 1 )
}
function TALMotorGL.GenerateAllInCurve: integer;
var
 i,j     : integer;
 x0,y0   : TFloat;
 x,y     : TFloat;
 Cuv     : TCurve;

 procedure SzakaszOsztas(xx0,yy0,xx,yy: TFloat);
 var k,n     : integer;
     d       : TFloat;
     op,p1,p2: TPoint2d;
     maxXhossz: integer;
 begin
    maxXhossz := 10; 
    d := KeTPontTavolsaga(xx0,yy0,xx,yy);
    if d>maxXhossz then
    begin
      // Hosszabb szakaszok darabolása: max vektorhossz = maxXhossz mm
      n := Trunc(d/maxXhossz);
      p1 := Point2d(xx0,yy0);
      p2 := Point2d(xx,yy);
      for k:=1 to n do begin
          op := OsztoPont(p1,p2,maxXhossz*k/d);
          ALLCurve.AddPoint(op.x, op.y)
      end;
    end;
 end;

begin
 Result := 0;
 ALLCurve.ClearPoints;

 if SablonImage<>nil then
 with SablonImage do begin
   x0 := ActPosition.x; y0 := ActPosition.y;
   ALLCurve.AddPoint(x0, y0);
   For i:=0 to FCurveList.Count-1 do begin
        Cuv := FCurveList.Items[i];
        If Cuv.Enabled and Cuv.Visible then begin
           For j:=0 to Cuv.FPoints.Count-1 do begin
            Cuv.GetPoint(j,x,y);
            if (x<>x0) or (y<>y0) then begin
               SzakaszOsztas(x0,y0,x,y);
               ALLCurve.AddPoint(x, y)
            end;
            x0 := x; y0 := y;
           end;
           if Cuv.Closed then begin
            Cuv.GetPoint(0,x,y);
            if (x<>x0) or (y<>y0) then
               SzakaszOsztas(x0,y0,x,y);
               ALLCurve.AddPoint(x, y);
            x0 := x; y0 := y;
           end;
        end;
   end;
   Result := ALLCurve.Fpoints.Count-1;
 end;

end;

function TALMotorGL.GetVecCount: word;
begin
  if ALLCurve.Fpoints.Count=0 then Result := 0
  else
   Result := ALLCurve.Fpoints.Count-1;
end;

// Az idx (0..PackCount-1) sorszámû csomag vektorainak száma
function TALMotorGL.GetVectorPerPack(idx: word): word;
begin
  Result := 78;
  if PackCount=1 then
     Result := VecCount;
  if (VecCount div 78)=idx then
     Result := (VecCount mod 78);
  if (VecCount div 78)<idx then
     Result := 0;
end;

function TALMotorGL.VecToDataRecord(dx, dy: extended): COM_OUTDATA_Record;
var
  d              : extended;
  alfa           : extended;
  lepesszam      : extended;
  XLepes, YLepes : INTEGER;
  x,y            : word;
  T,tX, tY       : extended;
  LepesPerMM     : extended;
begin
  d := sqrt((dx*dx)+(dy*dy));           // vektor hossza mm-ben
  if d<>0 then begin
  LepesPerMM := 1/MotorConstans;        // 59.88
  lepesszam  := Round(d*LepesPerMM);    // Ennyi lépés a vektor
  alfa       := SzakaszSzog(0,0,dx,dy); // Vekctor dõlésszöge
  XLepes     := Round(lepesszam*cos(alfa));    // X irányú lépés
  YLepes     := Round(lepesszam*sin(alfa));    // Y irányú lépés
      if Sebesseg=0 then Sebesseg:=8;          // Biztonsági védelem
  T          := d/Sebesseg;             // Össz idõ sec
  if XLepes=0 then tx:=0 else
  tX         := T/XLepes/0.000002;      // X lépések közötti idõ 2mikros egységekben
  if YLepes=0 then ty:=0 else
  tY         := T/YLepes/0.000002;      // Y lépések közötti idõ 2mikros egységekben
  x := ABS(Round(XLepes));
  y := ABS(Round(YLepes));
  with Result do begin
       XCount_L := Lo(X);
       XCount_H := Hi(X);
       if XLepes<0 then XCount_H := XCount_H or 128;
       YCount_L := Lo(Y);
       YCount_H := Hi(Y);
       if YLepes<0 then YCount_H := YCount_H or 128;
       XTime  := ABS(Round(tX));
       YTime  := ABS(Round(tY));
  end;
  end else
       Result := InitComData;
end;

function TALMotorGL.GetCheckSum: byte;
Var
  mByte   : byte;
  CheckSum: Integer;
  m , i   : integer;
begin
  CheckSum := 0;
  PackStream.Seek(0,0);
  m := PackStream.Size;
  For i:=0 to m-1 do begin
      PackStream.Read(mByte,1);
      CheckSum := (CheckSum + mByte) and $FF;
  end;
  Result := (256-CheckSum) and 255;
end;


{ ==================  COM Port Rutines ==============================}


// Initialize the serial communikation's parameters of SerialCom
// Ex: COM7: InitCOMPort(7,9600,8,prNone,sbOneStopBit);
procedure TALMotorGL.InitCOMPort;
begin
Try
  If SerialCOM=nil then
  SerialCOM := TSerialCom.Create(Self);
  Case MotorMethod of
       mmBlueTooth :
       begin
            SerialCOM.BaudRate  := 57600;
            SerialCOM.DataBits  := 8;
            SerialCOM.Parity    := prNone;
            SerialCOM.StopBits  := sbOneStopBit;
            SerialCOM.Events    := [];
       end;
       mmCOM       :
       begin
            SerialCOM.BaudRate  := 9600;
            SerialCOM.DataBits  := 8;
            SerialCOM.Parity    := prNone;
            SerialCOM.StopBits  := sbOneStopBit;
            SerialCOM.Events    := [];
            SerialCOM.OnCTS     := OnCTSEvent;
       end;
  end;
except
end;
end;

procedure TALMotorGL.ComGotoRealative(dx, dy: extended);
begin
  PackStream.Clear;
  With COM_Title do begin
    First     := $55;
    PackCount := 1;
    PackNo    := 1;
    PackType  := 3;
    VecCount  := 1;
  end;
      PackStream.Write(COM_TITLE, SizeOf(COM_OUTTITLE_Record));
  COM_DATA := VecToDataRecord(dx, dy);
      PackStream.Write(COM_DATA, SizeOf(COM_OUTDATA_Record));
  COM_CLOSE:= InitComClose;
end;

procedure TALMotorGL.ComGotoXY(x, y: extended);
VAR
  dx, dy: extended;
begin
  dx := x - ActPosition.x;
  dy := y - ActPosition.y;
  ComGotoRealative(dx, dy);
end;

function TALMotorGL.ComOpen(PortN: byte): boolean;
begin
if FComPort <> PortN then
Try
  SerialCOM.Port := PortN;
  SerialCOM.Open;
  Result := SerialCOM.Connected;
  FComPort := PortN;
except
  FComPort := 0;
  Result := False;
end;
end;

// Visszaadja az elsõ szabad COM port számát, vagy hiba esetén -1 -et.
function TALMotorGL.GetFirstCOMPort: integer;
var i: integer;
begin
  Result := -1;
  For i:=1 to 20 do
    If ComOpen(i) then begin
       FComPort := I;
       Result := i;
       Exit;
    end;
end;

// Transfer data packs from PackStream
// if COM port ready for receive data
procedure TALMotorGL.ComTransfer;
var m,i: integer;
    mByte: byte;
begin
  SerialCOM.Events := [];
  If SerialCOM.Connected and SerialCOM.CTSState
  then begin
  PackStream.Seek(0,0);
  m := PackStream.Size;
  For i:=0 to m-1 do begin
      PackStream.Read(mByte,1);
      SerialCOM.WriteString(chr(mByte));
  end;
  end;
end;

procedure TALMotorGL.OnCTSEvent(Sender: TObject);
begin
  If Assigned(FOnCTS) then FOnCTS(Self);
end;

procedure TALMotorGL.Timer(Sender:TObject);
begin
if SerialCOM<>nil then begin
  if Connected <> oldConnected then begin
     oldConnected := SerialCOM.Connected;
     if Assigned(FChangeConnection) then FChangeConnection(Self,SerialCOM.Connected);
  end;
  if Connected then begin
    IF SerialCOM.CTSState <> oldCTSState then begin
       oldCTSState := SerialCOM.CTSState;
       If Assigned(FOnCTS) then FOnCTS(Self);
    end;
    IF SerialCOM.RxQue=4 then begin
       SerialCOM.Read(fifo,4);
       If Assigned(FRxQue) then FRxQue(Self, fifo.Info, fifo.PackNo);
    end;
  end;
end;
end;

function TALMotorGL.GetConnected: boolean;
begin
  Result := SerialCOM.Connected;
end;

procedure TALMotorGL.SetPackSize(const Value: byte);
begin
  FPackSize := Value;
  if Value<1 then FPackSize := 1;
  if Value>78 then FPackSize := 78;
end;

procedure TALMotorGL.TimerOnOff(onoff: boolean);
begin
  // Idõzítõ ki/be kapcsolása mely figyeli a soros portot
  if onoff then
    dTimer.OnTimer   := Timer
  else
    dTimer.OnTimer   := nil;
end;

procedure TALMotorGL.SetComPort(const Value: byte);
begin
  FComPort := Value;
  if Assigned(FChangeConnection) then FChangeConnection(Self,SerialCOM.Connected);
end;

initialization

   // mm/lépés állandó az adott motorra, csak itt kell beállítani !!!!
//   MotorConstans := 0.039;
//   MotorConstans := 0.052;
//   MotorConstans := 0.0375;
   MotorConstans := 0.0167;

end.

