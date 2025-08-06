unit AL_Motors;

interface
Uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, IniFiles,
  AL_Paper, StObjects, Szoveg, Szamok, NewGeom, Registry, CPortCtl, CPort;

Type
  { Vezérlés tipusa
    mmOld      : manuális vezérlés külsõ billentyûzetrõl;
    mmNew      : Új vezérlés: Editor gép vagy közvetlenül virtul COM porttal
                 vagy bluetootk-on keresztül vagy
                 az Obeliskbe épített tablettel
  }
  TMotorMethod    = (mmOld,mmNew);

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

  MotorMethod   : TMotorMethod;   {mmOld=Régi; mmNew=Uj motor vezérlõ algoritmus}
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
  WorkingMode   : byte;           {0=teszt,1=Vágás,2=Glavírozáa}
  Correction    : real;           {0=kontúron; <0=belül; >0=kívül;
                                   értéke = a vágóél sugara}
  Down          : boolean;         // Origó lent=True; Fent=False;
  Dummy         : Array[1..127] of byte;
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

TFreezRecord = record
   idx       : integer;
end;

StatusRecord = packed record
    Vagas       : string[1];
    dummy       : string[1];
    Mozgas      : string[1];
    XVegallas   : string[1];
    YVegallas   : string[1];
    Futes       : string[1];
    FutesErtek  : integer;
    Futoszal    : string[1];
    VektorNo    : integer;
end;

TMotorStatus = (statNone,       // Nincs
                statMoving,     // Vektor mozgás
                statGoOrigo,    // Origóba mozgás
                statCutting,    // Vágás közben
                statPaused      // Pillanat állj
               );
// ---------------------------------------------------------------------------

  TChangeMethod = procedure(Sender: TObject;  MotorMethod: TMotorMethod) of object;
  TChangeMachineType = procedure(Sender: TObject;  MachineType: TMachineType) of object;
  TChangeStatus = procedure(Sender: TObject;  MotorStatus: TMotorStatus) of object;
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

  TALMotors = class(TComponent)
  private
    FActPosition: TPoint3D;
    FWorkingMode: TWorkingMode;
    FOnActPosition: TActPositionChangeEvent;
    FPillanatAlljEvent: TPillanatAlljChangeEvent;
    FOnWorkingMode: TWorkingModeChangeEvent;
    FOnWorkOnOff: TWorkOnOffChangeEvent;
    FWorkTime: TWorkTimeChangeEvent;
    FWorkWay: TWorkWayChangeEvent;
    FSablonImage: TALSablon;
    FMMPerLepesY: extended;
    FMMPerLepesX: extended;
    FMMPerLepesZ: extended;
    fPillanatAllj: boolean;
    FWorkOn: boolean;
    FFolytonosVagas: boolean;
    FSTOP: boolean;
    FLapmeretHEIGHT: integer;
    FActPosPrecision: integer;
    FQuickVelocity: integer;
    FLapmeretWIDTH: integer;
    FWorkVelocity: integer;
    FSebesseg: integer;
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
    FLineTemperature: integer;
    FLineOk: TLineOk;
    FSzakadas: boolean;
    FSzakadasEvent: TSzakadasEvent;
    FSzakadasVolt: boolean;
    FDownUp: boolean;
    FChangeConnection: TChangeConnection;
    FUSBName: string;
    FTerminalSwitch: boolean;
    FPackCount: word;
    FVecCount: word;
    fOnCTS: TNotifyEvent;
    FRxQue: TRxQueEvent;
    FPackSize: byte;
    FDownload: TDownloadEvent;
    fMotorProcess: TMotorProcess;
    FComPort2: TComPort;
    FComPort1: TComPort;
    FMachineType: TMachineType;
    FOnMachineType: TChangeMachineType;
    fMotorMethod: TMotorMethod;
    FOnMotorMethod: TChangeMethod;
    FMotorConstans: extended;
    FFreezIndex: integer;
    FBacklash: TPoint;
    FMotorStatus: TMotorStatus;
    FHeating: boolean;
    FHeatingPercent: integer;
    FChangeStatus: TChangeStatus;
    procedure SetActPosition(const Value: TPoint3D);
    procedure SetWorkingMode(const Value: TWorkingMode);
    procedure SetSablonImage(const Value: TALSablon);
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
    procedure SetCorrection(const Value: extended);
    procedure SetSablonSzinkron(const Value: boolean);
    procedure SetOverRun(const Index: Integer; const Value: boolean);
    procedure SetWorkingEnable(const Value: boolean);
    procedure Timer(Sender:TObject);
    procedure setIsMachine(const Value: boolean);
    procedure SetLineTemperature(const Value: integer);
    procedure SetSzakadas(const Value: boolean);
    procedure szHeating(LTemp: integer);
    procedure SetSzakadasVolt(const Value: boolean);
    procedure SetDownUp(const Value: boolean);
    function GetVecCount: word;
    procedure OnCTSEvent(Sender: TObject);
    procedure SetPackSize(const Value: byte);
    procedure SetMotorProcess(const Value: TMotorProcess);
    procedure SetMachineType(const Value: TMachineType);
    procedure GetRxChar1(Sender: TObject; Count: Integer);
    procedure GetRxChar2(Sender: TObject; Count: Integer);
    procedure SetMotorMethod(const Value: TMotorMethod);
    procedure SetMotorConstans(const Value: extended);
    procedure SetFreezIndex(const Value: integer);
    procedure MotException(Sender:TObject;
                          TComException:TComExceptions; ComportMessage:String;
                          WinError:Int64; WinMessage:String);
    procedure SetMotorStatus(const Value: TMotorStatus);
    procedure SetHeating(const Value: boolean);
    procedure SetHeatingPercent(const Value: integer);
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
    status          : string;            // 15 karakteres státusz visszajelzés
    statusRec       : StatusRecord;
    cts             : string;            // output string adatátvitelhez

    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure Assign(Source: TPersistent); override;

    Procedure Up;
    Procedure Down;
    Procedure Left;
    Procedure Right;
    procedure WaitTime(sec:integer);
    Procedure SetNullPosition;
    Procedure GotoNullPosition;
    Function  GotoXYPosition(x,y:extended) : boolean;
    procedure GotoAbsolutNullPosition;
    procedure TotalWorking;
    procedure WorkingFromPoint(ap:longint);
    procedure WorkingCurve(idx:longint);        // Egy objektum kivágása
    procedure WorkingVector(p1,p2: TPoint2d);
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
    procedure StoreIniFile(IniFile: TIniFile);

    //---------- COM Specials ------------
    function  GetFirstCOMPort: integer;
    function  ComOpen(PortN: byte): boolean;
    function  ComClose(PortN: byte): boolean;
    procedure InitCOMPort;
    procedure InitAllCurve;
    function  InitComWorking: boolean;
    function  InitComData: COM_OUTDATA_Record;
    function  InitComClose: COM_OUTCLOSE_Record;
    function  GenerateAllInCurve: integer;   // All curve converst all in one
    function  GetPackCount: word;
    function  GetVectorPerPack(idx: word): word;
    function  VecToDataRecord(dx,dy: extended): COM_OUTDATA_Record;
    function  GetCheckSum: byte;
    procedure BlueToothWorking(AItem: integer);
    procedure RunBacklash(xMot: boolean; poz: boolean);
    procedure ComGotoXY(x,y: extended);
    procedure ComGotoRealative(dx,dy: extended);
    procedure ComTransfer;
    procedure TimerOnOff(onoff: boolean);

    function DrawToDataStream(aStream: TStream; AItem: integer): boolean;
    function SaveToBinaryFile(fName: string): boolean;
    function LoadFromBinaryFile(fName: string): boolean;

    //------------ New method -----------------------
    procedure SendCommand(pPort: integer; cmd: string);
    function  SendSablon: boolean;
    function  ReceiveSablon: boolean;
    function  GetStatus: string;
    function  GetMotorStatus: TMotorStatus;
    function  IsVegallas: boolean;
    function  IsVegallasX: boolean;
    function  IsVegallasY: boolean;
    function  IsHeating: boolean;
    function  IsCuttingPlan: boolean;
    function  NewGetMachine: boolean;
    procedure NewStart;       // „S”: Mûsor vágás indítás.
    procedure NewPause;       // „P”: Mûsor vágás felfüggesztés, utána "C"
    procedure NewContinue;    // „C”: Mûsor vágás folytatás
    procedure NewSTOP;        // „E”: Mûsor vágás leállítás
    procedure NewGotoNull;    // „X”: Végállásba mozgás vagy adott vektoros mozgás leállítása
    procedure NewHeatOn;
    procedure NewHeatOff;
    // „HXXX”: Fûtõszál intenzitás %-ban, ahol XXX paraméter kötelezõen 3 digit, az intenzitás %-ban (000…100).
    procedure NewHeatAdjust(percent: integer);
    procedure NewGoto(dx,dy: double); // „V/Vx/Vy”: Hajts végre egy megadott vektor szerinti mozgást


    Property IsMachine: boolean read NewGetMachine write setIsMachine;
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
    // Vectorok száma
    property VecCount : word read GetVecCount write FVecCount;
    // Csomagok száma
    property PackCount : word read GetPackCount write FPackCount;
    property FreezIndex: integer read FFreezIndex write SetFreezIndex;

  published
   // mm/lépés állandó az adott motorra, csak itt kell beállítani !!!!
    // MotorConstans : 0.0100;
    Property MotorConstans : extended read FMotorConstans write SetMotorConstans;
    property MotorMethod: TMotorMethod read fMotorMethod write SetMotorMethod;
    property MotorStatus: TMotorStatus read GetMotorStatus;
//    property MotorStatus: TMotorStatus read FMotorStatus write SetMotorStatus;
    { Motor ptoperties }
    property MachineType: TMachineType read FMachineType write SetMachineType;
    { ComPort1: USB port gépvezérlés; ComPort2: bluetooth port}
    property ComPort1  : TComPort read FComPort1 write FComPort1;
    property ComPort2  : TComPort read FComPort2 write FComPort2;
    property PackSize: byte read FPackSize write SetPackSize;
    property MotorProcess: TMotorProcess read fMotorProcess write SetMotorProcess;
    Property SablonImage : TALSablon read FSablonImage write SetSablonImage;
    Property ActPosPrecision : integer read FActPosPrecision write SetActPosPrecision;
    Property FolytonosVagas : boolean read FFolytonosVagas write FFolytonosVagas;
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
        {Holtjáték korrekciók az x,y motorokra, amikor irányt váltanak }
    Property Backlash : TPoint read FBacklash write FBacklash;
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
        // Végállás kapcsolók figyelése
    property TerminalSwitch: boolean read FTerminalSwitch write FTerminalSwitch;
    // Kezdési pont alúl vagy fölül
    property DownUp: boolean read FDownUp write SetDownUp default True;
    // Fûtés be/ki kapcsolás
    property Heating: boolean read IsHeating write SetHeating;
    // Fûtés % beállítás - ez nem kapcsolja a fûtést csak értéket állít be
    property HeatingPercent: integer read FHeatingPercent write SetHeatingPercent;
    // ============ Events =====================================
    Property OnMotorMethod : TChangeMethod read FOnMotorMethod write FOnMotorMethod;
    Property OnMachineType : TChangeMachineType read FOnMachineType write FOnMachineType;
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
    property OnChangeStatus: TChangeStatus read FChangeStatus write FChangeStatus;
  end;

//procedure Register;

function Point2D(X, Y : double): TPoint2D;
function Point3D(X, Y, Z: double): TPoint3D;
function IsComPort(PortNO: integer): boolean;

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

implementation

//{$R AL_MotorComp.dcr}
(*
procedure Register;
begin
  RegisterComponents('AL',[TALMotors]);
end;
*)
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
procedure TALMotors.ConfigInit;
begin
end;

Function TALMotors.ConfigLoad(iFileNev:string):boolean;
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

Function TALMotors.ConfigSave(iFileNev:string):boolean;
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

constructor TALMotors.Create(AOwner: TComponent);
begin
     FormatSettings.DecimalSeparator:='.';
     demo             := False;
     FMotorConstans   := 0.0100;
     MachineType      := cutMachine;
     FMotorStatus     := statNone;
     ComPort1 := TComPort.Create(Self);
     with FComPort1 do begin
       Name := 'COMPlotter';
       Port := '';
       Baudrate := br57600;
       OnException := MotException;
     end;
     ComPort2 := TComPort.Create(Self);
     with FComPort2 do begin
       Name := 'COMBluetooth';
       Port := '';
       Baudrate := br57600;
       OnException := MotException;
     end;

     FPillanatAllj    := False;

     FMMPerLepesX     := fMotorConstans;
     FMMPerLepesY     := fMotorConstans;
     FMMPerLepesZ     := fMotorConstans;

     oldActPosition   := Point3D(-100,-100,0);
     FActPosPrecision := 0;
     FWorkingMode     := wmTest;
     FWorkVelocity    := 50;
     FQuickVelocity   := 100;
     Fworkingenable   := True;
     FWorkOn          := False;
     FFolytonosVagas  := False;
     H_Next           := 0;
     V_Next           := 0;
     Z_Next           := 0;
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
//     IsMachine        := True;
     Backlash         := Point(0,0);

     // COM Specific variables

     TerminalSwitch := False;
     InitALLCurve;
     PackStream       := TMemoryStream.Create;
     oldConnected     := False;
     oldCTSState      := True;
     InitCOMPort;
     dTimer           := TTimer.Create(Self);
     dTimer.Interval  := 100;
     dTimer.OnTimer   := Timer;
     FActPosition     := Point3D(0,0,0);
     DownUp           := True;
  inherited;
end;

destructor TALMotors.Destroy;
begin
  dTimer.Free;
  HRT.Free;
  if ALLCurve<>nil then
     ALLCurve.Free;
  PackStream.Free;
  If ComPort1<>nil then
  begin
       if FComPort1.Connected then FComPort1.Close;
       FComPort1.Free;
  end;
  If ComPort2<>nil then
  begin
       if FComPort2.Connected then FComPort2.Close;
       FComPort2.Free;
  end;
  inherited;
end;

// store settings to ini file
procedure TALMotors.StoreIniFile(IniFile: TIniFile);

  procedure StoreMot(Mot: TComport);
  begin
    IniFile.WriteString(Mot.Name, 'Port', Mot.Port);
    IniFile.WriteString(Mot.Name, 'BaudRate', BaudRateToStr(Mot.BaudRate));
    IniFile.WriteString(Mot.Name, 'StopBits', StopBitsToStr(Mot.StopBits));
    IniFile.WriteString(Mot.Name, 'DataBits', DataBitsToStr(Mot.DataBits));
    IniFile.WriteString(Mot.Name, 'Parity', ParityToStr(Mot.Parity.Bits));
    IniFile.WriteString(Mot.Name, 'FlowControl', FlowControlToStr(Mot.FlowControl.FlowControl));
  end;

begin
 if IniFile<>nil then
 begin
   StoreMot(ComPort1);
   StoreMot(ComPort2);
 end;
end;

(*---------- KIEGÉSZITÕ RUTINOK ----------*)


Procedure TALMotors.Up;
begin
  // Elindul föl folyamatosan. Csak állj parancsea áll meg
  NewHeatOn;
  SendCommand(1,'!GN+');
//  ActPosition:=Point3d(ActPosition.x,ActPosition.y+MMPerLepesY,ActPosition.z);
end;

Procedure TALMotors.Down;
begin
  // Elindul le folyamatosan. Csak állj parancsea áll meg
  NewHeatOn;
  SendCommand(1,'!GN-');
//  ActPosition:=Point3d(ActPosition.x,ActPosition.y-MMPerLepesy,ActPosition.z);
end;

Procedure TALMotors.Left;
begin
  // Elindul balra folyamatosan. Csak állj parancsea áll meg
  NewHeatOn;
  SendCommand(1,'!G-N');
//  ActPosition:=Point3d(ActPosition.x-MMPerLepesX,ActPosition.y,ActPosition.z);
end;

Procedure TALMotors.Right;
begin
  // Elindul balra folyamatosan. Csak állj parancsea áll meg
  NewHeatOn;
  SendCommand(1,'!G+N');
end;

// Ellenõrzi, hogy van-e gép kapcsolódva
function TALMotors.NewGetMachine: boolean;
var s: string;
    b: boolean;
begin
  Result := False;
  case fMachineType of
  cutMachine:
     if ComPort1.Connected then
     begin
          b := ComPort1.TriggersOnRxChar;
          ComPort1.ClearBuffer(true,true);
          SendCommand(1,'U');
          ComPort1.ReadStr(s,1);
          Result := s='A'
     end;
  end;
end;

procedure TALMotors.NewGoto(dx, dy: double);
Var odr: COM_OUTDATA_Record;
    co : string;
    tx,ty: string;
begin
  NewHeatOn;
  odr := VecToDataRecord(dx,dy);
  tx :=  IntToHex(odr.xTime,4);
  ty :=  IntToHex(odr.yTime,4);
  co  := '!V'+IntToHex(odr.xCount_L,2)+IntToHex(odr.xCount_H,2)
         +IntToHex(odr.yCount_L,2)+IntToHex(odr.yCount_H,2)
         +Copy(tx,3,2)+Copy(tx,1,2)
         +Copy(ty,3,2)+Copy(ty,1,2);
  SendCommand(1,co);
end;

procedure TALMotors.NewGotoNull;
var dx,dy: integer;
    op: integer;
begin
  // Végállásba mozgás vagy vektoros mozgás leállítása
  Sebesseg := 6;
  op := HeatingPercent;
  HeatingPercent := 100;
  NewHeatOn;
  if DownUp then
  begin
    repeat
      if IsVegallasX then dx:=0 else dx:=-100;
      if Copy(Status,5,1)='+' then dy:=0 else dy:=100;
      NewGoto(dx,dy);
    until Copy(Status,4,2)='-+';
  end
  else
    NewGoto(-1000,-1000);
  NewHeatOff;
  HeatingPercent := op;
end;

procedure TALMotors.NewHeatOn;
begin
  // Fûtés be
  if not IsHeating then
    SendCommand(1,'!I');
end;

procedure TALMotors.NewHeatOff;
begin
  // Fûtés ki
  if IsHeating then
     SendCommand(1,'!O');
end;

procedure TALMotors.NewHeatAdjust(percent: integer);
var s: string;
begin
  // Fûtés szint % beállítás
  s := ZeroNum(percent,3);
  SendCommand(1,'!H'+s);
end;

procedure TALMotors.NewStart;
begin
  // Sablon vágás indítás
  NewHeatOn;
  SendCommand(1,'!S');
end;

procedure TALMotors.NewPause;
begin
  // Sablon vágás felfüggesztés
  SendCommand(1,'!P');
  NewHeatOff;
end;

procedure TALMotors.NewContinue;
begin
  // Sablon vágás folytatás pause után
  NewHeatOn;
  SendCommand(1,'!C');
end;

procedure TALMotors.NewSTOP;
var ms: TMotorStatus;
begin
  ms := GetMotorStatus;
  SendCommand(1,'!X');   // Mozgások megszakítása
  if ms=statPaused then begin
     SendCommand(1,'!C');   // Mûsor folytatás
     Sleep(100);
  end;
  SendCommand(1,'!E');   // Mûsor felfüggesztse
  Sleep(100);
  NewHeatOff;            // Fûtés kikapcsolása
//  MotorStatus := statNone;
end;

procedure TALMotors.MotException(Sender: TObject; TComException: TComExceptions;
  ComportMessage: String; WinError: Int64; WinMessage: String);
begin

end;

// CutOn = vágóláng megy-e? Ez vegye figyelembe a rutin
// Ha lemászik az asztalról kapcsolja ki a lángot
procedure TALMotors.GetOverrun;
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

function TALMotors.GetSTOP:boolean;
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

{Várakozás sec másodpercig}
procedure TALMotors.WaitTime(sec:integer);
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

procedure TALMotors.SetActPosition(const Value: TPoint3D);
Var xx,yy: integer;
begin
  FActPosition := Value;
  If SablonImage<>nil then
     With SablonImage do begin
        DrawWorkPoint(Value.x,Value.y);
     end;
     If Assigned(FOnActPosition) then FOnActPosition(Self,Value);
end;

{ A gyártási mód beállítása }
procedure TALMotors.SetWorkingMode(const Value: TWorkingMode);
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

procedure TALMotors.SetSablonImage(const Value: TALSablon);
begin
  If FSablonImage<>Value then begin
     FSablonImage:=Value;
     If Value<>nil then begin
        LapmeretWIDTH   := Trunc(FSablonImage.Paper.x);
        LapmeretHEIGHT  := Trunc(FSablonImage.Paper.y);
        DownUp := DownUp;
     end;
  end;
end;

procedure TALMotors.SetLapmeretWIDTH(const Value: integer);
begin
  FLapmeretWIDTH := Value;
  If SablonImage<>nil then begin
     SablonImage.Paper.x := Value;
     FactoryConfig.Paper.x := Value;
  end;
end;

procedure TALMotors.SetLapmeretHEIGHT(const Value: integer);
begin
  FLapmeretHEIGHT := Value;
  If SablonImage<>nil then begin
     SablonImage.Paper.y := Value;
     FactoryConfig.Paper.y := Value;
  end;
end;

procedure TALMotors.SetQuickVelocity(const Value: integer);
begin
     If Value<=0 then FQuickVelocity :=1
     else FQuickVelocity := Value;
     FactoryConfig.PosSebesseg := Value;
     If SablonImage<>nil then FactoryConfig.PosSebesseg:=FQuickVelocity;
end;

procedure TALMotors.SetSebesseg(const Value: integer);
begin
  FSebesseg := Value;
  WorkVelocity := Value;
end;

procedure TALMotors.SetSebessegOption(const Value: TSebessegOption);
begin
  FSebessegOption := Value;
end;

procedure TALMotors.SetWorkVelocity(const Value: integer);
begin
  If Value<=0 then FWorkVelocity:=1 else
     FWorkVelocity := Value;
     FactoryConfig.WorkSebesseg := FWorkVelocity;
end;

procedure TALMotors.SetActPosPrecision(const Value: integer);
begin
  FActPosPrecision := Value;
  FactoryConfig.Precizio := Value;
end;

procedure TALMotors.SetMachineType(const Value: TMachineType);
begin
  FMachineType := Value;
end;

procedure TALMotors.SetMMPerLepesX(const Value: extended);
begin
  FMMPerLepesX := Value;
  FactoryConfig.LepesX := FMMPerLepesX; //MotorConstans;
  IF SablonImage<>nil then SablonImage.MMPerLepes := Value;
end;

procedure TALMotors.SetMMPerLepesY(const Value: extended);
begin
  FMMPerLepesY := Value;
  FactoryConfig.LepesY := FMMPerLepesY; //MotorConstans;
end;

procedure TALMotors.SetMMPerLepesZ(const Value: extended);
begin
  FMMPerLepesZ := Value;
  FactoryConfig.LepesZ := FMMPerLepesZ; //MotorConstans;
end;

procedure TALMotors.SetCorrection(const Value: extended);
begin
  fCorrection := Value;
  FactoryConfig.Correction := Value;
end;

procedure TALMotors.FactoryDefaultLoad;
begin
(*
  If FileExists('FACTORY.FAC') then
    ConfigLoad('FACTORY.FAC')
  else
    ShowMessage('FACTORY.FAC file betöltése sikertelen')
*)
end;

procedure TALMotors.FactoryDefaultSave;
begin
 Try
  ConfigSave('FACTORY.FAC');
 except
  exit;
 end;
end;

procedure TALMotors.TotalWorking;
begin
  If SablonImage<>nil then begin
    SablonImage.FCurveList.First;
    GenerateAllInCurve;
    BlueToothWorking(0);
  end;
end;

// Egy objektum kivágása
procedure TALMotors.WorkingCurve(idx: Integer);
begin
  AllCurve := SablonImage.Curves[idx];
  if AllCurve<>nil then
     BlueToothWorking(0);
end;

procedure TALMotors.WorkingFromPoint(ap: Integer);
begin
    GenerateAllInCurve;
    BlueToothWorking(ap);
end;

procedure TALMotors.WorkingVector(p1, p2: TPoint2d);
begin
  InitALLCurve;
  if AllCurve<>nil then
  begin
       AllCurve.ClearPoints;
       AllCurve.AddPoint(p1);
       AllCurve.AddPoint(p2);
       BlueToothWorking(0);
  end;
end;

// Csak az aktuális pozíciót állítja NULL pontba
// a motor nem mozdul.
procedure TALMotors.SetNullPosition;
begin
  if SablonImage<>nil then
  begin
      If DownUp then
         ActPosition := Point3d(0,SablonImage.Paper.y,0)
      else
         ActPosition := Point3d(0,0,0);
  end
  else
      If DownUp then
         ActPosition := Point3d(0,LapmeretHEIGHT,0)
      else
         ActPosition := Point3d(0,0,0);
end;

// A motor 0 pozícióba mozog
procedure TALMotors.GotoNullPosition;
begin
  if (not szakadas) and (WorkingMode<>wmTest) then LineTemperature := 2;
  If DownUp then begin
//     If (actPosition.x<>0) or (actPosition.y<>0) then
//        VekOut(-actPosition.x,-ActPosition.y,True);
  end else begin
//     If (actPosition.x<>0) or (actPosition.y<>Factoryconfig.Paper.y) then
//        VekOut(-actPosition.x,Factoryconfig.Paper.y-ActPosition.y,True);
  end;
  if (not szakadas) and (WorkingMode<>wmTest) then LineTemperature := 1;
end;

function TALMotors.GotoXYPosition(x, y: extended): boolean;
var dx,dy: extended;
begin
  if (not szakadas) and (WorkingMode<>wmTest) then LineTemperature := 2;
  SourcePosition := actPosition;
  DestPosition := Point3D(x,y,actPosition.z);
  dx:=DestPosition.x - SourcePosition.x;
  dy:=DestPosition.y - SourcePosition.y;
  if (not szakadas) and (WorkingMode<>wmTest) then LineTemperature := 1;
end;

function TALMotors.GetTotalWorkWay:double;
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

procedure TALMotors.SetSablonSzinkron(const Value: boolean);
begin
  fSablonSzinkron := Value;
end;

procedure TALMotors.SetOverRun(const Index: Integer; const Value: boolean);
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

procedure TALMotors.SetSTOP(const Value: boolean);
begin
  {VÉSZSTOP esetén minden letiltva}
  FSTOP := Value;
  WorkingEnable := not Value;
  IF WorkOn then
     WorkOn := not Value;
  if Sablonimage<>nil then SablonImage.STOP := Value;
  If Assigned(fSTOPEvent) then fSTOPEvent(Self,Value);
end;

procedure TALMotors.SetWorkingEnable(const Value: boolean);
begin
  {Gyártás engedélyezés: False esetben a folyamatban lévõ gyártás
    letiltása}
  FWorkingEnable := Value;
  If fWorkOn then fWorkOn := Value;
end;

procedure TALMotors.SetWorkOn(const Value: boolean);
begin
  {Valódi gyártási folyamat jelzése = True esetben}
  FWorkOn := Value;
  If Assigned(FOnWorkOnOff) then FOnWorkOnOff(Self,Value);
end;

procedure TALMotors.SetPillanatAllj(const Value: boolean);
begin
//  If FPillanatAllj<>Value then begin
  If ComponentState <> [csDestroying] then begin

     FPillanatAllj := Value;
     If Assigned(FPillanatAlljEvent) then FPillanatAlljEvent(Self,Value);

     if (WorkingMode<>wmTest) then
     begin
          If Value then begin
             if not SzakadasVolt then
                szHeating(1);
          end
          else
             szHeating(2);
     end
       else
       if not SzakadasVolt then
          LineTemperature := 1;

     Repeat
       Application.ProcessMessages;
     Until ((not FPillanatAllj) or STOP) and (not SzakadasVolt);

  end;

end;

procedure TALMotors.GotoAbsolutNullPosition;
var szele: boolean;
begin
  {Fej elmozgatása x irányban végállásig}
  if (not szakadas) and (WorkingMode<>wmTest) then LineTemperature := 2;
     ActPosition:=Point3d(0,FactoryConfig.Paper.y,0);
  if (not szakadas) and (WorkingMode<>wmTest) then LineTemperature := 1;
end;

procedure TALMotors.setIsMachine(const Value: boolean);
begin
  If fIsMachine <> Value then begin
     fIsMachine := Value;
     if Assigned(FChangeConnection) then FChangeConnection(Self,ComPort1.Connected);
  end;
end;

// Szál hõfokának beállítása
procedure TALMotors.SetLineTemperature(const Value: integer);
begin
     FLineTemperature := Value;
          if not Szakadas then begin
             szHeating(Value);
          end else
             Pillanatallj := True;
     if Assigned(FLineOk) then FLineOk(Self,LineTemperature,Szakadas);
end;


procedure TALMotors.szHeating(LTemp: integer);
begin
     FLineTemperature := LTemp;
end;

procedure TALMotors.SetSzakadas(const Value: boolean);
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


procedure TALMotors.SetSzakadasVolt(const Value: boolean);
VAR statusByte : byte;
begin
  FSzakadasVolt := Value;
//  dTimer.Enabled := False;
  szHeating(0);
end;

procedure TALMotors.SetDownUp(const Value: boolean);
begin
//if FDownUp <> Value then begin
  FDownUp := Value;
  if Sablonimage<>nil then
  if FDownUp then begin
     Sablonimage.WorkOrigo := Point2d(0,Sablonimage.Paper.y);
     FActPosition          := Point3D(0,Sablonimage.Paper.y,0);
  end else begin
     Sablonimage.WorkOrigo := Point2d(0,0);
     FActPosition          := Point3D(0,0,0);
  end;
//end;
end;


procedure TALMotors.SetFreezIndex(const Value: integer);
begin
  FFreezIndex := Value;
end;

procedure TALMotors.SetHeating(const Value: boolean);
begin
  FHeating := Value;
  if Value then NewHeatOn
  else NewHeatOff;
end;

procedure TALMotors.SetHeatingPercent(const Value: integer);
begin
  FHeatingPercent := Value;
  NewHeatAdjust(Value);
end;

// ============= COM specific rutins ===============================

function TALMotors.InitComWorking: boolean;
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


function TALMotors.IsCuttingPlan: boolean;
begin
  Status := GetStatus;
  Result := Copy(Status,1,1)='M';
end;

function TALMotors.IsHeating: boolean;
begin
  Status := GetStatus;
  Result := Copy(Status,6,1)='I';
end;

function TALMotors.IsVegallas: boolean;
begin
  Status := GetStatus;
  Result := (Copy(Status,4,2)='--') or (Copy(Status,4,2)='-+');
end;

function TALMotors.IsVegallasX: boolean;
begin
  Status := GetStatus;
  Result := (Copy(Status,4,1)='-') or (Copy(Status,4,1)='+');
end;

function TALMotors.IsVegallasY: boolean;
begin
  Status := GetStatus;
  Result := (Copy(Status,5,1)='-') or (Copy(Status,5,1)='+');
end;

procedure TALMotors.Assign(Source: TPersistent);
begin
  if (Source is TALMotors) then
  begin
    FactoryConfig          := TALMotors(Source).FactoryConfig;
    FActPosition           := TALMotors(Source).FActPosition;
    FWorkingMode           := TALMotors(Source).FWorkingMode;
    FOnActPosition         := TALMotors(Source).FOnActPosition;
    SablonImage            := TALMotors(Source).FSablonImage;
    FMMPerLepesY           := TALMotors(Source).FMMPerLepesY;
    FMMPerLepesX           := TALMotors(Source).FMMPerLepesX;
    FMMPerLepesZ           := TALMotors(Source).FMMPerLepesZ;
    fPillanatAllj          := TALMotors(Source).fPillanatAllj;
    FWorkOn                := TALMotors(Source).FWorkOn;
    FFolytonosVagas        := TALMotors(Source).FFolytonosVagas;
    FSTOP                  := TALMotors(Source).FSTOP;
    FLapmeretHEIGHT        := TALMotors(Source).FLapmeretHEIGHT;
    FActPosPrecision       := TALMotors(Source).FActPosPrecision;
    FQuickVelocity         := TALMotors(Source).FQuickVelocity;
    FLapmeretWIDTH         := TALMotors(Source).FLapmeretWIDTH;
    FWorkVelocity          := TALMotors(Source).FWorkVelocity;
    FSebesseg              := TALMotors(Source).FSebesseg;
    FMoveOption            := TALMotors(Source).FMoveOption;
    FSebessegOption        := TALMotors(Source).FSebessegOption;
    fCorrection            := TALMotors(Source).fCorrection;
    fSablonSzinkron        := TALMotors(Source).fSablonSzinkron;
    fIsMachine             := TALMotors(Source).fIsMachine;
    FDelayCorrection       := TALMotors(Source).FDelayCorrection;
    FLineTemperature       := TALMotors(Source).FLineTemperature;
    FLineOk                := TALMotors(Source).FLineOk;
    FSzakadasVolt          := TALMotors(Source).FSzakadasVolt;
    FDownUp                := TALMotors(Source).FDownUp;
    FUSBName               := TALMotors(Source).FUSBName;
    FTerminalSwitch        := TALMotors(Source).FTerminalSwitch;
    FVecCount              := TALMotors(Source).FVecCount;
    FComPort2              := TALMotors(Source).FComPort2;
    FComPort1              := TALMotors(Source).FComPort1;
    MachineType            := TALMotors(Source).FMachineType;
    MotorMethod            := TALMotors(Source).fMotorMethod;
    FMotorConstans         := TALMotors(Source).FMotorConstans;
    FFreezIndex            := TALMotors(Source).FFreezIndex;
  end;
end;

// HOLTJÁTÉK KOMPENZÁCIÓ
// xMot = true: az x motoron léptetünk, false: y motoron léptetünk;
// poz  = true: pozitív irányba, false = negatív irányba
procedure TALMotors.RunBacklash(xMot, poz: boolean);
var ODR: COM_OUTDATA_Record;
begin
  ODR:=InitComData;
  with ODR do begin
  if xMot then
  begin
       YCount_L := 0;
       YCount_H := 0;
       XCount_L := Lo(Backlash.X);
       XCount_H := Hi(Backlash.X);
       if not poz then XCount_H := XCount_H or 128;
  end else
  begin
       XCount_L := 0;
       XCount_H := 0;
       YCount_L := Lo(Backlash.Y);
       YCount_H := Hi(Backlash.Y);
       if not poz then YCount_H := YCount_H or 128;
  end;
       XTime  := 500;
       YTime  := 500;
  end;
      PackStream.Write(ODR, SizeOf(COM_DATA));
end;

// A rajzot a vezérlés számára érthetõ hexa kódolással fájlba írja
function TALMotors.SaveToBinaryFile( fName : string ): boolean;
var
   fStream : TFileStream;
begin
  Result := False;
  If SablonImage<>nil then begin
    SablonImage.FCurveList.First;
    GenerateAllInCurve;
    Try
       fStream := TFileStream.Create( fName, fmCreate );
       Result := DrawToDataStream( fStream, 0 );
    Finally
       fStream.Free;
    End;
  end;
end;

// A rajzot a vezérlés számára érthetõ hexa kódolással fájlba írja
function TALMotors.LoadFromBinaryFile( fName : string ): boolean;
var
   f       : TextFile;
   ch      : char;
   s       : string;
   he,h,l  : string;
   vCount  : word;
   i,k: Integer;
   xStep,yStep : integer; //smallint; //short;
   x,y,dx,dy : double;
   szorzo    : integer;
   b         : byte;
begin
  Result := False;
  If SablonImage<>nil then begin
    Try
       AllCurve.ClearPoints;
       AssignFile( f, fName );
       Reset(f);
       Read(f,ch);
       if ch=':' then     // Ha a bevezetõ karakter :
       begin
         Read(f,s);
         he := Copy(s,1,4);
         vCount := StrToInt('$' + he);
         k := 5;
         x := 0;
         y := 0;
         if DownUp then y := SablonImage.Paper.y;
         AllCurve.AddPoint(x,y);

         for i := 1 to vCount do
         begin
           szorzo := 1;
           l := Copy(s,k,2);
           h := Copy(s,k+2,2);
           b := StrToInt('$' + h);
           if GetBit(b,7)=1 then
           begin
             szorzo := -1;
             SetBit(b,7,0);
           end;
           xStep := szorzo * (256*b + StrToInt('$' + l));

           szorzo := 1;
           l := Copy(s,k+4,2);
           h := Copy(s,k+6,2);
           b := StrToInt('$' + h);
           if GetBit(b,7)=1 then
           begin
             szorzo := -1;
             SetBit(b,7,0);
           end;
           yStep := szorzo * (256*b + StrToInt('$' + l));

           dx := MotorConstans * xStep;
           dy := MotorConstans * yStep;
           x  := x+dx;
           y  := y+dy;
           AllCurve.AddPoint(x,y);
           Inc(k,16);
         end;
       end;
    Finally
       CloseFile(f);
       SablonImage.Clear;
//       SablonImage.painting := true;
       SablonImage.AddCurve(AllCurve);
       SablonImage.SaveToTXT(ChangeFileExt(fName,'.txt'));
    End;
  end;
end;

// A rajz adatait kiírja streamre hexa formában, amit a vezérlés fogadhat
//   vagy fájlba
// Ha sikerült: Return = True
function TALMotors.DrawToDataStream(aStream: TStream; AItem:integer): boolean;
var Cuv    : TCurve;
    i      : integer;
    x0,y0  : double;
    x,y    : double;
    vCount : word;
    h,l    : byte;
    he     : string;
    ChkSum : byte;
    hs,ls  : string[2];
    pozX   : boolean;
    pozY   : boolean;
    oldpozX   : boolean;
    oldpozY   : boolean;
    Percent   : integer;
    BT_DATA   : BT_OUTDATA_Record;
begin
Try

  Result := True;
  // Rajz kigyüjtése packstream-re
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
  pozX := true; pozY := true;
  oldpozX := true; oldpozY := true;
  For i:=1 to Pred(AllCurve.Count) do begin
      AllCurve.GetPoint(i,x,y);

      pozX := x-x0>=0;
      pozY := y-y0>=0;
      if oldpozX<>pozX then
      begin
        if pozX then  // negatívból pozítívba vált
           COM_DATA := VecToDataRecord(BackLash.x*LepesX,0)
        else
           COM_DATA := VecToDataRecord(-BackLash.x*LepesX,0);
        PackStream.Write(COM_DATA, SizeOf(COM_DATA));
        Inc(vCount);
        oldpozX:=pozX;
      end;
      if oldpozY<>pozY then
      begin
        if pozY then  // negatívból pozítívba vált
           COM_DATA := VecToDataRecord(0,BackLash.y*LepesY)
        else
           COM_DATA := VecToDataRecord(0,-BackLash.y*LepesY);
        Inc(vCount);
        PackStream.Write(COM_DATA, SizeOf(COM_DATA));
        oldpozY:=pozY;
      end;

      COM_DATA := VecToDataRecord(x-x0,y-y0);
      PackStream.Write(COM_DATA, SizeOf(COM_DATA));
      x0 := x;
      y0 := y;
        if STOP then begin
           WorkOn := False;
           Exit;
        end;
  end; // for i

  PackStream.Seek(0,0);
  h := Hi(vCount); l := Lo(vCount);
  PackStream.Write(h, SizeOf(byte));
  PackStream.Write(l, SizeOf(byte));

  ChkSum := GetCheckSum;
  PackStream.Write(ChkSum, SizeOf(byte));

  // Hexa átalkítások az aStream-re

  PackStream.Seek(0,0);

  // Nyitó karakter :
  h := 58;
  aStream.Write(h,1);
  For i:=1 to PackStream.Size do
  begin
    PackStream.Read(h,1);
    he:=Format('%2.2x',[h]);
    l:=Ord(he[1]);
    h:=Ord(he[2]);
    aStream.Write(l,1);
    aStream.Write(h,1);
  end;
  // Záró karakter ;
  h := 59;
  aStream.Write(h,1);

except
  Result := False;
End;
end;

procedure TALMotors.BlueToothWorking(AItem:integer);
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
    pozX   : boolean;
    pozY   : boolean;
    oldpozX   : boolean;
    oldpozY   : boolean;
begin
if (WorkingMode=wmCut) then begin
Try
  InitComWorking;
  BTS := TMemoryStream.Create;
  WorkOn:=True;

  if Assigned(FDownload) then FDownload(Self,0);

(*
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
  pozX := true; pozY := true;
  oldpozX := true; oldpozY := true;
  For i:=1 to Pred(AllCurve.Count) do begin
      AllCurve.GetPoint(i,x,y);

      pozX := x-x0>=0;
      pozY := y-y0>=0;
      if oldpozX<>pozX then
      begin
        if pozX then  // negatívból pozítívba vált
           COM_DATA := VecToDataRecord(BackLash.x*LepesX,0)
        else
           COM_DATA := VecToDataRecord(-BackLash.x*LepesX,0);
        PackStream.Write(COM_DATA, SizeOf(COM_DATA));
        Inc(vCount);
        oldpozX:=pozX;
      end;
      if oldpozY<>pozY then
      begin
        if pozY then  // negatívból pozítívba vált
           COM_DATA := VecToDataRecord(0,BackLash.y*LepesY)
        else
           COM_DATA := VecToDataRecord(0,-BackLash.y*LepesY);
        Inc(vCount);
        PackStream.Write(COM_DATA, SizeOf(COM_DATA));
        oldpozY:=pozY;
      end;

      COM_DATA := VecToDataRecord(x-x0,y-y0);
      PackStream.Write(COM_DATA, SizeOf(COM_DATA));
      x0 := x;
      y0 := y;
        if STOP then begin
           WorkOn := False;
           Exit;
        end;
  end; // for i

  PackStream.Seek(0,0);
  h := Hi(vCount); l := Lo(vCount);
  PackStream.Write(h, SizeOf(byte));
  PackStream.Write(l, SizeOf(byte));

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
*)

      DrawToDataStream(BTS,AItem);

      // Send BTS Stream to BloeTooth

      COMPort1.Events := [];
      BTS.Seek(0,0);
      Percent := 0;
      m := BTS.Size;

      SetLength(cts,m);
      For i:=1 to m do begin
          BTS.Read(mByte,1);
          cts[i]:=chr(mByte);
      end;
      if ComPort1.Connected then begin
         // Fûtés % beállítás
         NewHeatAdjust(HeatingPercent);
         // Fûtés bekapcs.
         NewHeatOn;
         COMPort1.WriteStr(cts);
         if MotorMethod=mmNew then
            SendCommand(1,'!S');
         GetMotorStatus;
      end;

finally
  if assigned(fWorkTime) then
           fWorkTime(Self,HRT.ReadTimer);

  BTS.Free;
  WorkOn := False;
  If SablonImage<>nil then SablonImage.ZoomDrawing;
end;
end
//  else If SablonImage<>nil then Working(0,0);
end;

// Drawing work way with red line
procedure TALMotors.DrawWorkWay(AItem:integer);
var i     : integer;
    x,y   : TFloat;
    p0,p  : TPoint;
begin
  If (SablonImage<>nil) and (AllCurve.FPoints.Count>0) then begin
     SablonImage.Canvas.Pen.Width := 2;
     SablonImage.Canvas.Pen.Color := clRed;
     AllCurve.GetPoint(0,X,Y);
     p0 := SablonImage.WtoS(x,y);
     SablonImage.Canvas.MoveTo(p0.x,p0.y);
     For i:=0 to AItem do begin
        AllCurve.GetPoint(I,X,Y);
        p := SablonImage.WtoS(x,y);
        SablonImage.Canvas.LineTo(p.x,p.y);
     end;
  end;
end;

function TALMotors.InitComData: COM_OUTDATA_Record;
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

procedure TALMotors.InitAllCurve;
begin
     if ALLCurve<>nil then
        ALLCurve := nil;
     ALLCurve         := TCurve.Create;
     with ALLCurve do begin
          ID          := 1;
          Name        := 'Cutting Plan';
          Closed      := False;
          Shape       := dmPolyline;
     end;
end;

function TALMotors.InitComClose: COM_OUTCLOSE_Record;
begin
  With Result do begin
  CloseByte   := 0;            // = 0;
  CheckSum    := GetCheckSum;  // Ellenõrzõ összeg: SUM AND $FF
  end;
end;


function TALMotors.GetPackCount: word;
begin
// Result := Veccount;
 Result := VecCount div 78;
 if (VecCount mod 78)>0 then Inc(Result);
end;

procedure TALMotors.GetRxChar1(Sender: TObject; Count: Integer);
begin

end;

procedure TALMotors.GetRxChar2(Sender: TObject; Count: Integer);
begin

end;

{ Összes objektumot egyetlen nyilt (Polyline) objektumba konvertál
  Result = Polyline vektorok száma (Vektorszám = Támpontok száma - 1 )
}
function TALMotors.GenerateAllInCurve: integer;
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
    maxXhossz := 100;
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

function TALMotors.GetVecCount: word;
begin
  if ALLCurve.Fpoints.Count=0 then Result := 0
  else
   Result := ALLCurve.Fpoints.Count-1;
end;

// Az idx (0..PackCount-1) sorszámû csomag vektorainak száma
function TALMotors.GetVectorPerPack(idx: word): word;
begin
  Result := 78;
  if PackCount=1 then
     Result := VecCount;
  if (VecCount div 78)=idx then
     Result := (VecCount mod 78);
  if (VecCount div 78)<idx then
     Result := 0;
end;

function TALMotors.VecToDataRecord(dx, dy: extended): COM_OUTDATA_Record;
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
  LepesPerMM := 1/fMotorConstans;        // 59.88
  lepesszam  := Round(d*LepesPerMM);    // Ennyi lépés a vektor
  alfa       := SzakaszSzog(0,0,dx,dy); // Vekctor dõlésszöge
  XLepes     := Round(lepesszam*cos(alfa));    // X irányú lépés
  YLepes     := Round(lepesszam*sin(alfa));    // Y irányú lépés
      if Sebesseg=0 then Sebesseg:=6;          // Biztonsági védelem
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

function TALMotors.GetCheckSum: byte;
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


// Initialize the serial communikation's parameters of ComPort1
// Ex: COM7: InitCOMPort(7,9600,8,prNone,sbOneStopBit);
procedure TALMotors.InitCOMPort;
begin
Try
  If ComPort1=nil then
     ComPort1 := TComPort.Create(Self);
  Case MotorMethod of
       mmOld:
       begin
            ComPort1.BaudRate    := br57600;
            ComPort1.DataBits    := dbEight;
            ComPort1.Parity.Bits := prNone;
            ComPort1.StopBits    := sbOneStopBit;
            ComPort1.Events      := [];
       end;
       mmNew:
       begin
            ComPort1.BaudRate    := br57600;
            ComPort1.DataBits    := dbEight;
            ComPort1.Parity.Bits := prNone;
            ComPort1.StopBits    := sbOneStopBit;
            ComPort1.Events      := [];
       end;
  end;
except
end;
end;

procedure TALMotors.ComGotoRealative(dx, dy: extended);
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

procedure TALMotors.ComGotoXY(x, y: extended);
VAR
  dx, dy: extended;
begin
  dx := x - ActPosition.x;
  dy := y - ActPosition.y;
  ComGotoRealative(dx, dy);
end;

function TALMotors.ComOpen(PortN: byte): boolean;
begin
Try
  Result := False;
  case PortN of
  1:   begin
       Comport1.Close;
       Comport1.Open;
       Result := Comport1.Connected;
  end;
  2:   begin
       Comport2.Open;
       Result := Comport2.Connected;
  end;
  end;
except

End;
end;

function TALMotors.ComClose(PortN: byte): boolean;
begin
Try
  Result := False;
  case PortN of
  1:   begin
       Comport1.Close;
       Result := not Comport1.Connected;
  end;
  2:   begin
       Comport2.Close;
       Result := not Comport2.Connected;
  end;
  end;
except

End;
end;

// Visszaadja az elsõ szabad COM port számát, vagy hiba esetén -1 -et.
function TALMotors.GetFirstCOMPort: integer;
var i: integer;
begin
  Result := -1;
  For i:=1 to 20 do
    If ComOpen(i) then begin
       Result := i;
       Exit;
    end;
end;

function TALMotors.GetMotorStatus: TMotorStatus;
var ms,s: string;
begin
  Result := statNone;
  ms := GetStatus;
  Status := ms;
  if ms='' then Exit;
  s := Copy(ms,1,1);
  if s='N' then Result :=  statNone;
  if s='M' then Result :=  statCutting;
  if s='P' then Result :=  statPaused;
  s := Copy(ms,2,1);
  if s='M' then begin
     Result :=  statGoOrigo;
  end;
  s := Copy(ms,3,1);
  if s='M' then Result :=  statMoving;
  if Assigned(FChangeStatus) then FChangeStatus(Self,Result);
end;

function IsComPort(PortNO: integer): boolean;
var
  reg : TRegistry;
  st  : TStrings;
  i   : integer;
  cn  : string;
begin
  Result := False;
  cn := 'COM'+Inttostr(PortNo);
  reg := TRegistry.Create(KEY_READ OR $100);
  reg.RootKey := HKEY_LOCAL_MACHINE;
  reg.OpenKey('hardware\devicemap\serialcomm',false);
  st := TStringList.Create;
  reg.GetValueNames(st);
  for i := 0 to st.Count -1 do
  if reg.ReadString(st.Strings[i])=cn then begin
     Result := True;
     Break;
  end;
  st.Free;
  reg.CloseKey;
  reg.free;
end;

// Transfer data packs from PackStream
// if COM port ready for receive data
procedure TALMotors.ComTransfer;
var m,i: integer;
    mByte: byte;
    sig: TComSignals;
begin
  sig := ComPort1.Signals;
  If ComPort1.Connected
  then begin
  PackStream.Seek(0,0);
  m := PackStream.Size;
  For i:=0 to m-1 do begin
      PackStream.Read(mByte,1);
      ComPort1.WriteStr(chr(mByte));
      if Assigned(FDownload) then FDownload(Self,Trunc(100*i/m));
  end;
  end;
end;

procedure TALMotors.OnCTSEvent(Sender: TObject);
begin
  If Assigned(FOnCTS) then FOnCTS(Self);
end;

procedure TALMotors.Timer(Sender:TObject);
begin
(*
if ComPort1<>nil then begin
  if Assigned(FChangeConnection) then FChangeConnection(Self,IsComPort(ComPort1.Port));
  if Connected <> oldConnected then begin
     oldConnected := ComPort1.Connected;
     if Assigned(FChangeConnection) then FChangeConnection(Self,ComPort1.Connected);
  end;
  if Connected then begin
    IF ComPort1.CTSState <> oldCTSState then begin
       oldCTSState := ComPort1.CTSState;
       If Assigned(FOnCTS) then FOnCTS(Self);
    end;
    IF ComPort1.RxQue=4 then begin
       ComPort1.Read(fifo,4);
       If Assigned(FRxQue) then FRxQue(Self, fifo.Info, fifo.PackNo);
    end;
  end;
end;*)
end;

procedure TALMotors.SetPackSize(const Value: byte);
begin
  FPackSize := Value;
  if Value<1 then FPackSize := 1;
  if Value>78 then FPackSize := 78;
end;

procedure TALMotors.TimerOnOff(onoff: boolean);
begin
  // Idõzítõ ki/be kapcsolása mely figyeli a soros portot
  if onoff then
    dTimer.OnTimer   := Timer
  else
    dTimer.OnTimer   := nil;
end;

procedure TALMotors.SetMotorConstans(const Value: extended);
begin
  FMotorConstans := Value;
  FMMPerLepesX := Value;
  FMMPerLepesY := Value;
  FMMPerLepesZ := Value;
end;

procedure TALMotors.SetMotorMethod(const Value: TMotorMethod);
begin
  fMotorMethod := Value;
  if Assigned(FOnMotorMethod) then FOnMotorMethod(Self,fMotorMethod);

end;

procedure TALMotors.SetMotorProcess(const Value: TMotorProcess);
begin
  fMotorProcess := Value;
end;

procedure TALMotors.SetMotorStatus(const Value: TMotorStatus);
begin
  FMotorStatus := Value;
  if Assigned(FChangeStatus) then FChangeStatus(Self,FMotorStatus);
end;

(* ----------------- NewMechine -------------------------------------------*)

// Az EditMachin átküldi a cutMachine-nak soros vonalon a
// PackStream-re másolt sablon adathalmazát
function TALMotors.SendSablon: boolean;
begin
  Result := False;
  If SablonImage<>nil then
  With SablonImage do
  Try
     Result := True;
     WorkOn:=True;
     HRT.StartTimer;
     SablonImage.SaveGraphToMemoryStream(PackStream);
     ComTransfer;
     WorkOn:=False;
     HRT.StartTimer;
     if assigned(fWorkTime) then
           fWorkTime(Self,HRT.ReadTimer);
  except
     Result := False;
  end;
end;

// Az EditMachin által soros vonalon átküldött
// sablon adathalmazát PackStream-re másolja a cutMachine
function TALMotors.ReceiveSablon: boolean;
var buffer: byte;
begin
  Result := False;
  If SablonImage<>nil then
  With SablonImage do
  Try
     Result := True;
     WorkOn:=True;
     HRT.StartTimer;
     PackStream.Clear;

     while ComPort1.InputCount>0 do begin
       ComPort1.Read(buffer,1);
       PackStream.Write(buffer,1);
//       if Assigned(FDownload) then FDownload(Self,100*i/m);
     end;

     SablonImage.LoadGraphFromMemoryStream(PackStream);
     WorkOn:=False;
     if assigned(fWorkTime) then
           fWorkTime(Self,HRT.ReadTimer);
  except
     Result := False;
  end;
end;

// Parancs küldés soros vonalra
procedure TALMotors.SendCommand(pPort: integer; cmd: string);
begin
  case pPort of
  1: ComPort1.WriteStr(CMD);
  2: ComPort2.WriteStr(CMD);
  end;
  sleep(100);
end;

// MOT18 státusz lekérdezés
function TALMotors.GetStatus: string;
var st: string;

         function RString(s: string; h: integer): string;
         begin
           if Length(s)>h then
              Result := Copy(s,Length(s)-h,Length(s))
           else
              Result := s;
         end;
begin
Try
Try
  status := '';
  case fMachineType of
  cutMachine:
     if IsMachine then
     begin
          ComPort1.ClearBuffer(true,true);
          SendCommand(1,'?');
          ComPort1.ReadStr(status,15);
          // Hibás válasz esetén
          if Length(status)<2 then
          begin
            Result := status;
            Exit;
          end;
          status := Copy(status,2,16);
     end;
  end;
except
  Result := status;
  Exit;
End;
Finally
  Result := status;
End;
end;


initialization
end.

