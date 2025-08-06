unit AL_COMMotor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  AL_Paper, StObjects, Szamok, NewGeom, Registry, CPortCtl, CPort;

Type
  { Számítógép tipusa
      cutMachine         : vezérléssel egybe épített tablet
      editMachine        : külsõ sz.gép bluetooth kapcsolattal
  }
  TMachineType    = (cutMachine,editMachine);

  (*motContinue  : folyamatos vágás
    motStepBy    : lineroad esetén a szakasz elsõ és utolsó pontján Pause-val
                   megáll és utasításra indul újra.
                   Ez lehetõséget ad a szál be/ki fûzésre.
                   Polygon-okat egyben kivág.
  *)
  TMotorProcess   = (motNone, motContinue, motStepBy);

  TMoveOption     = (moAuto, moManual);        {Mozgatási mód:auto vagy kézi}
  TSebessegOption = (soNone, soQuick, soWork); {Gyors vagy lassú a mozgás}

    {Gyártási mód:
       Tesztmód   = wmTest   : csak szimulálja a gyártást, de a motorok nem mozognak;
       Vágási mód = wmCut    : a pozícionálások kivételével a fejet leengedi és vág;
       Gravir mód = wmGravir : Gravírozás során a fej magassága folyamatosan változtatható;
       Plazma mód = wmPlazma : Plazma vágás esetán bekezdési pontokon átfúvás
    }
  TWorkingMode    = (wmTest, wmCut, wmGravir, wmPlazma);

TFactoryConfig = record
  Demo          : boolean;        {Demó verzió = True}
  Belepett      : word;           {Ennyiszer lépett be a programba}
  UtolsoBelepes : TDateTime;      {Utolsó belépés dátuma}
  Uzemido       : TDateTime;      {Teljes üzemeltetés : GÉP ÖSSZ. MUNKAIDEJE}
  globaldir     : String[120];    {Config és catalógus és INI file könyvtára}
  localdir      : String[120];    {Sablon könyvtár}
  filenev       : String[120];    {Utoljára megnyitott Sablon file}
  Paper         : TPoint;         {Rajzlap méretei}
  PaperFont     : TFont;
  ForeColor     : TColor;         {Rajzlap alapszine}
  BackColor     : TColor;         {Rajzlapon kívüli terület alapszine}

  MachineType   : TMachineType;
  Port1         : byte;           {COM port a vezérléshez}
  Baud1         : TBaudRate;
  Port2         : byte;           {BT port kiválasztás}
  Baud2         : TBaudRate;
  LepesX        : real;           {X léptetõmotor mm/1 léptetés}
  LepesY        : real;           {Y léptetõmotor mm/1 léptetés}
  LepesZ        : real;           {Z léptetõmotor mm/1 léptetés}
  WorkSebesseg  : integer;        {Megmunkálási sebesség = 1..50}
  PosSebesseg   : integer;        {Pozícionálási sebesség = 1..50}
  Precizio      : integer;        {Tizedesek száma}
  ActPosition   : TPoint3d;       {Utolsó aktuális pozíció}
  Kiemeles      : integer;        {A fej kiemelése [leptetes_szám]}
  WorkingMode   : byte;           {0=teszt,1=Vágás,2=Glavírozáa}
  NegativHead   : integer;        {1=pozítív; -1=negatív fejmozgás z-ben}
  Correction    : real;           {0=kontúron; <0=belül; >0=kívül;
                                   értéke = a vágóél sugara}
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

TMotorStatus = record

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
  TChangeMachineType = procedure(Sender: TObject;  MachineType: TMachineType) of object;
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

  TALCOMMotors = class(TComponent)
  private
    FComPort2: TComPort;
    FComPort1: TComPort;
    fMotorProcess: TMotorProcess;
    FSablonImage: TALSablon;
    FDownUp: boolean;
    FActPosition: TPoint3D;
    FOnActPosition: TActPositionChangeEvent;
    FMachineType: TMachineType;
    FOnMachineType: TChangeMachineType;
    FPackSize: byte;
    FWorkVelocity: integer;
    FMMPerLepesZ: extended;
    FQuickVelocity: integer;
    FMMPerLepesX: extended;
    FMMPerLepesY: extended;
    FWorkingMode: TWorkingMode;
    FOnWorkingMode: TWorkingModeChangeEvent;
    fPillanatAllj: boolean;
    FSTOP: boolean;
    FWorkingEnable: boolean;
    FWorkOn: boolean;
    procedure SetSablonImage(const Value: TALSablon);
    procedure SetDownUp(const Value: boolean);
    procedure SetActPosition(const Value: TPoint3D);
    procedure SetMachineType(const Value: TMachineType);
    procedure GetRxChar1(Sender: TObject; Count: Integer);
    procedure GetRxChar2(Sender: TObject; Count: Integer);
    procedure SetPackSize(const Value: byte);
    procedure SetMMPerLepesX(const Value: extended);
    procedure SetMMPerLepesY(const Value: extended);
    procedure SetMMPerLepesZ(const Value: extended);
    procedure SetQuickVelocity(const Value: integer);
    procedure SetWorkVelocity(const Value: integer);
    procedure SetWorkingMode(const Value: TWorkingMode);
    procedure SetPillanatAllj(const Value: boolean);
    procedure SetSTOP(const Value: boolean);
    procedure SetWorkingEnable(const Value: boolean);
    procedure SetWorkOn(const Value: boolean);
    function GetTotalWorkWay: double;
  protected
    dTimer : TTimer;
  public
    demo            : boolean;            {Demonstrációs program}
    FactoryConfig   : TFactoryConfig;
    HRT             : THRTimer;           // Precíz idõzítõ
    oldActPosition  : TPoint3d;           {Régi aktuális pozíció}
  //------ Serial COM ------------
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

    //---------- COM Specials ------------
    function  GetPlotterPort: integer;
    function  ComOpen: boolean;
    procedure InitCOMPort;
    function  InitComWorking: boolean;
    function  InitComTitle: COM_OUTTITLE_Record;
    function  InitComData: COM_OUTDATA_Record;
    function  InitComClose: COM_OUTCLOSE_Record;
    function  GenerateAllInCurve: integer;   // All curve converst all in one
    function  GetPackCount: word;
    function  GetVectorPerPack(idx: word): word;
    function  VecToDataRecord(dx,dy: extended): COM_OUTDATA_Record;
    function  GetCheckSum: byte;
    procedure ComWorking(AItem:integer);
    procedure ComGotoXY(x,y: extended);
    procedure ComGotoRealative(dx,dy: extended);
    procedure ComTransfer;
    procedure TimerOnOff(onoff: boolean);
    procedure SendCommand(cmd: string);
    function  SendSablon: boolean;
    function  ReceiveSablon: boolean;





  (*

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

    //---------- COM Specials ------------
    function  GetPlotterPort: integer;
    function  ComOpen(PortN: byte): boolean;
    procedure InitCOMPort;
    function  InitComWorking: boolean;
    function  InitComTitle: COM_OUTTITLE_Record;
    function  InitComData: COM_OUTDATA_Record;
    function  InitComClose: COM_OUTCLOSE_Record;
    function  GenerateAllInCurve: integer;   // All curve converst all in one
    function  GetPackCount: word;
    function  GetVectorPerPack(idx: word): word;
    function  VecToDataRecord(dx,dy: extended): COM_OUTDATA_Record;
    function  GetCheckSum: byte;
    procedure ComWorking(AItem:integer);
    procedure ComGotoXY(x,y: extended);
    procedure ComGotoRealative(dx,dy: extended);
    procedure ComTransfer;
    procedure TimerOnOff(onoff: boolean);
    procedure SendCommand(cmd: string);
    function  SendSablon: boolean;
    function  ReceiveSablon: boolean;

    // Vectorok száma
    property VecCount : word read GetVecCount write FVecCount;
    // Csomagok száma
    property PackCount : word read GetPackCount write FPackCount;
    property Connected : boolean read GetConnected;

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
  *)
    Property ActPosition : TPoint3D read FActPosition write SetActPosition;
    Property LepesX : extended read FMMPerLepesX ;
    Property LepesY : extended read FMMPerLepesY ;
    Property LepesZ : extended read FMMPerLepesZ ;
    {Gyártási úthossz mm}
    Property TotalWorkWay : double read GetTotalWorkWay;

  published
    { ComPort1: USB port gépvezérlés; ComPort2: bluetooth port}
    property ComPort1  : TComPort read FComPort1 write FComPort1;
    property ComPort2  : TComPort read FComPort2 write FComPort2;
    { Motor ptoperties }
    property MachineType: TMachineType read FMachineType write SetMachineType;
    property DownUp: boolean read FDownUp write SetDownUp default True;
    property MotorProcess: TMotorProcess read fMotorProcess write fMotorProcess;
    Property MMPerLepesX : extended read FMMPerLepesX write SetMMPerLepesX ;
    Property MMPerLepesY : extended read FMMPerLepesY write SetMMPerLepesY ;
    Property MMPerLepesZ : extended read FMMPerLepesZ write SetMMPerLepesZ ;
    Property QuickVelocity : integer read FQuickVelocity write SetQuickVelocity;
    Property WorkVelocity : integer read FWorkVelocity write SetWorkVelocity;
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

    Property SablonImage : TALSablon read FSablonImage write SetSablonImage;
    property PackSize: byte read FPackSize write SetPackSize;

    Property OnMachineType : TChangeMachineType read FOnMachineType write FOnMachineType;
    Property OnActPosition : TActPositionChangeEvent read FOnActPosition write FOnActPosition;
    Property OnWorkingMode : TWorkingModeChangeEvent read FOnWorkingMode write FOnWorkingMode;



  (*
    property ComPort  : byte read FComPort write SetComPort;
    property BaudRate : Longword read FBaudRate write SetBaudRate;
    property PackSize: byte read FPackSize write SetPackSize;
    property MotorMethod: TMotorMethod read fMotorMethod write SetMotorMethod;
    property MotorProcess: TMotorProcess read fMotorProcess write SetMotorProcess;
    Property SablonImage : TALSablon read FSablonImage write SetSablonImage;
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
  *)
  end;

Var     MotorConstans : extended;

implementation

{ TALCOMMotors }


constructor TALCOMMotors.Create(AOwner: TComponent);
begin
     FormatSettings.DecimalSeparator:='.';

     MachineType := editMachine;
     ComPort1 := TComPort.Create(Self);
     with FComPort1 do begin
       Name := 'COMPlotter';
       Port := 'COM1';
       Baudrate := br57600;
       OnRxChar := GetRxChar1;
     end;
     ComPort2 := TComPort.Create(Self);
     with FComPort2 do begin
       Name := 'COMBluetooth';
       Port := 'COM1';
       Baudrate := br9600;
       OnRxChar := GetRxChar2;
     end;

     FMMPerLepesX     := MotorConstans;
     FMMPerLepesY     := MotorConstans;
     FMMPerLepesZ     := MotorConstans;

     oldActPosition   := Point3D(-100,-100,0);
     FWorkingMode     := wmTest;
     FWorkVelocity    := 50;
     FQuickVelocity   := 100;

     DownUp           := True;

     (*
     FPillanatAllj    := False;
     FMMPerLepesX     := MotorConstans;
     FMMPerLepesY     := MotorConstans;
     FMMPerLepesZ     := MotorConstans;

     oldActPosition   := Point3D(-100,-100,0);
     FActPosPrecision := 0;
     FWorkingMode     := wmTest;
     FWorkVelocity    := 50;
     FQuickVelocity   := 100;
     Fworkingenable   := True;
     FWorkOn          := False;
     FFolytonosVagas  := False;
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
     InitCOMPort;
     FActPosition     := Point3D(0,0,0);
     DownUp           := True;
*)
  inherited;
end;

destructor TALCOMMotors.Destroy;
begin
  if FComPort1.Connected then
     FComPort1.Close;
  if FComPort2.Connected then
     FComPort2.Close;
  FComPort1.Free;
  FComPort2.Free;
  inherited;
end;

procedure TALCOMMotors.Down;
begin

end;

procedure TALCOMMotors.DrawWorkWay(AItem: integer);
begin

end;

function TALCOMMotors.GenerateAllInCurve: integer;
begin

end;

function TALCOMMotors.GetCheckSum: byte;
begin

end;

function TALCOMMotors.GetPackCount: word;
begin

end;

function TALCOMMotors.GetPlotterPort: integer;
begin

end;

procedure TALCOMMotors.GetRxChar1(Sender: TObject; Count: Integer);
begin

end;

procedure TALCOMMotors.GetRxChar2(Sender: TObject; Count: Integer);
begin

end;

function TALCOMMotors.GetTotalWorkWay: double;
// A teljes sablon hossza mm-ben
var i,j : integer;
    x,y,ox,oy : double;
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

function TALCOMMotors.GetVectorPerPack(idx: word): word;
begin

end;

procedure TALCOMMotors.GotoAbsolutNullPosition;
begin

end;

procedure TALCOMMotors.GotoNullPosition;
begin

end;

function TALCOMMotors.GotoXYPosition(x, y: extended): boolean;
begin

end;

// COM portok iniciakizálása
procedure TALCOMMotors.InitCOMPort;
begin
Try
  If ComPort1=nil then
     ComPort1 := TComPort.Create(Self);
  If ComPort2=nil then
     ComPort2 := TComPort.Create(Self);
except
End;
end;

function TALCOMMotors.InitComClose: COM_OUTCLOSE_Record;
begin

end;

function TALCOMMotors.InitComData: COM_OUTDATA_Record;
begin

end;

function TALCOMMotors.InitComTitle: COM_OUTTITLE_Record;
begin

end;

function TALCOMMotors.InitComWorking: boolean;
begin

end;

procedure TALCOMMotors.Left;
begin

end;

procedure TALCOMMotors.Right;
begin

end;


function TALCOMMotors.ReceiveSablon: boolean;
begin

end;

procedure TALCOMMotors.SendCommand(cmd: string);
begin

end;

function TALCOMMotors.SendSablon: boolean;
begin

end;

procedure TALCOMMotors.SetActPosition(const Value: TPoint3D);
begin
  FActPosition := Value;
  If SablonImage<>nil then
     With SablonImage do begin
        DrawWorkPoint(Value.x,Value.y);
     end;
  If Assigned(FOnActPosition) then FOnActPosition(Self,Value);
end;

procedure TALCOMMotors.SetDownUp(const Value: boolean);
begin
  FDownUp := Value;
  if Sablonimage<>nil then
  if FDownUp then begin
     Sablonimage.WorkOrigo := Point2d(0,Sablonimage.Paper.y);
     FActPosition          := Point3D(0,Sablonimage.Paper.y,0);
  end else begin
     Sablonimage.WorkOrigo := Point2d(0,0);
     FActPosition          := Point3D(0,0,0);
  end;
  inherited;
end;

procedure TALCOMMotors.SetMachineType(const Value: TMachineType);
begin
  FMachineType := Value;
  case Value of
    cutMachine:
    begin
    end;
    editMachine:
    begin
    end;
  end;
  if Assigned(FOnMachineType) then FOnMachineType(Self,FMachineType);
end;

procedure TALCOMMotors.SetMMPerLepesX(const Value: extended);
begin
  FMMPerLepesX := Value;
  FactoryConfig.LepesX := FMMPerLepesX; //MotorConstans;
  IF SablonImage<>nil then SablonImage.MMPerLepes := Value;
end;

procedure TALCOMMotors.SetMMPerLepesY(const Value: extended);
begin
  FMMPerLepesY := Value;
  FactoryConfig.LepesY := FMMPerLepesY; //MotorConstans;
end;

procedure TALCOMMotors.SetMMPerLepesZ(const Value: extended);
begin
  FMMPerLepesZ := Value;
  FactoryConfig.LepesZ := FMMPerLepesZ; //MotorConstans;
end;

procedure TALCOMMotors.SetPackSize(const Value: byte);
begin
  FPackSize := Value;
  if Value<1 then FPackSize := 1;
  if Value>78 then FPackSize := 78;
end;

procedure TALCOMMotors.SetPillanatAllj(const Value: boolean);
begin
  fPillanatAllj := Value;
end;

procedure TALCOMMotors.SetQuickVelocity(const Value: integer);
begin
  FQuickVelocity := Value;
end;

procedure TALCOMMotors.SetSablonImage(const Value: TALSablon);
begin
  If FSablonImage<>Value then begin
     FSablonImage:=Value;
     If Value<>nil then begin
        DownUp := DownUp;
     end;
  end;
end;

procedure TALCOMMotors.SetSTOP(const Value: boolean);
begin
  FSTOP := Value;
end;

procedure TALCOMMotors.SetWorkingEnable(const Value: boolean);
begin
  FWorkingEnable := Value;
end;

procedure TALCOMMotors.SetWorkingMode(const Value: TWorkingMode);
begin
  If FWorkingMode <> Value then begin
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

procedure TALCOMMotors.SetWorkOn(const Value: boolean);
begin
  FWorkOn := Value;
end;

procedure TALCOMMotors.SetWorkVelocity(const Value: integer);
begin
  FWorkVelocity := Value;
end;

procedure TALCOMMotors.TimerOnOff(onoff: boolean);
begin

end;

procedure TALCOMMotors.TotalWorking;
begin

end;

procedure TALCOMMotors.Up;
begin

end;

function TALCOMMotors.VecToDataRecord(dx, dy: extended): COM_OUTDATA_Record;
begin

end;

procedure TALCOMMotors.VekOut(dx, dy: extended; PENDOWN: boolean);
begin

end;

procedure TALCOMMotors.Wait;
begin

end;

procedure TALCOMMotors.WaitTime(sec: integer);
begin

end;

procedure TALCOMMotors.Working(AObject, AItem: integer);
begin

end;

procedure TALCOMMotors.WorkingFromPoint(ap: Integer);
begin

end;

procedure TALCOMMotors.ComGotoRealative(dx, dy: extended);
begin

end;

procedure TALCOMMotors.ComGotoXY(x, y: extended);
begin

end;

// Open COM port
function TALCOMMotors.ComOpen: boolean;
begin
  Comport1.Close;
  Comport2.Close;
  if MachineType = cutMachine then
  begin
     Comport1.Open;
  end else
  begin
     Comport2.Open;
  end;
end;

procedure TALCOMMotors.ComTransfer;
begin

end;

procedure TALCOMMotors.ComWorking(AItem: integer);
begin

end;


{ THRTimer }

constructor THRTimer.Create;
Var  QW : _Large_Integer;
BEGIN
   Inherited Create;
   Exists := QueryPerformanceFrequency(TLargeInteger(QW));
   ClockRate := QW.QuadPart;
END;

procedure THRTimer.Delay(ms: double);
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

function THRTimer.ReadTimer: Double;
Var
  ET : _Large_Integer;
BEGIN
   QueryPerformanceCounter(TLargeInteger(ET));
   Result := 1000.0*(ET.QuadPart - StartTime)/ClockRate;
END;

function THRTimer.StartTimer: Boolean;
Var
  QW : _Large_Integer;
BEGIN
   Result := QueryPerformanceCounter(TLargeInteger(QW));
   StartTime := QW.QuadPart;
END;

initialization
   MotorConstans := 0.0100;
end.
