unit STAFRobTypes;

interface

Uses
  Classes, SysUtils, Windows, Forms, ExtCtrls,
  EDSDKApi, EDSDKType, EDSDKError, STAF_Canon,
  AscomTel1, STAF_Ascom, STAF_AstroUnit,
  Szoveg;

Type

  TSTAFCommandType = (cmtNone, cmtTIME, cmtCIKL, cmtASCOM, cmtCANON,
                      cmtFOCUSER, cmtGUIDER);

  TCmdExecuteStatus = (cmesNone,
                       cmesBegin,
                       cmesProcess,
                       cmesPause,
                       cmesContinue,
                       cmesEnd,
                       cmesStop);


  TSTAFCommand = (
    commREM,
    commSTART,
    commEND,
    commWAIT,
    commDELAY,
    commEQ,
    commEQREL,
    commCANONPARAMS,
    commISO,
    commEXP,
    commPATH,
    commFILENAME,
    commPHOTO,
    commSERIES,
    commFOR,
    commENDFOR,
    commSHUTDOWN
    );


  PPropList = ^TSTAFRobLangPropList;
  TSTAFRobLangPropList = record
    PropCmdType    : TSTAFCommandType;
    PropCmd        : TSTAFCommand;
    PropStr        : string;
    PropID         : byte;
    PropParamCount : byte;
    PropRequiedParamCount : byte;
  end;


Const

  STAFCommandString : array[0..Ord(High(TSTAFCommand)),0..2] of shortstring =
  (
    ('REM','REM (;:*) szöveg','Megjegyzés: Ha nem betûvel kezdõdik a sor'),
    ('START','START hh:mm:ss','A program kezdõ idõpontja'),
    ('END','END hh:mm:ss','A program befejezésének idõpontja'),
    ('WAIT','WAIT T','Várakozás T idõpontig'),
    ('DELAY','DELAY s','Várakozás s másodpecig'),
    ('EQ','EQ ra de','Távcsõ új koordinátákra áll'),
    ('EQREL','EQREL ra de','Távcsõ relatív elmozgatása'),
    ('CANONPARAMS','CANONPARAMS','CANON paraméteresés'),
    ('ISO','ISO','CANON ISO érétékének állítása'),
    ('EXP','EXP','CANON Expozíciós idejének beállítása'),
    ('PATH','','CANON képek metésének könyvtára'),
    ('FILENAME','FILENAME','CANON képek fájlnevének prefixe(elõtagja'),
    ('PHOTO','PHOTO','CANON képet készít'),
    ('SERIES','SERIES filename db kezdõsorszám várakozás','CANON felvételsorozatot készít'),
    ('FOR','FOR [cv]','Ciklus kezdete: cv-szer ismétlõdik: pl. FOR 10'),
    ('ENDFOR','ENDFOR','Ciklus vége'),
    ('SHUTDOWN','SHUTDOWN','Program vége')
  );

  STAFCommandSyntax : array[0..Ord(High(TSTAFCommand))] of shortstring = (
    'REM           : Megjegyzés',
    'START         : A program kezdõ idõpontja',
    'END           : A program befejezésének idõpontja',
    'WAIT          : Várakozás T idõpontig',
    'DELAY         : Várakozás N másodpecig',
    'EQ            : Távcsõ új koordinátákra áll',
    'EQREL         : Távcsõ relatív elmozgatása',
    'CANONPARAMS   : CANON paraméterezés',
    'ISO           : CANON ISO érétékének állítása',
    'EXP           : CANON Expozíciós idejének beállítása',
    'PATH          : CANON képek metésének könyvtára',
    'FILENAME      : CANON képek fájlnevének prefixe(elõtagja)',
    'PHOTO         : CANON képet készít',
    'SERIES        : CANON felvételsorozatot készít',
    'FOR           : Ciklus kezdete',
    'ENDFOR        : Ciklus vége',
    'SHUTDOWN      : Program vége'
    );

Const CmdExecuteStatusString : array[ 0..5 ] of string =
       ('None', 'Begin', 'Continue', 'End', 'Pause', 'Stop');

const STAFCommProp : array[ 0..Ord(High(TSTAFCommand)) ] of TSTAFRobLangPropList = (
    ( PropCmdType: cmtNone    ; PropCmd: commREM      ;
      PropStr: 'REM'         ; PropID: 0  ;
      PropParamCount: 1; PropRequiedParamCount: 0),
    ( PropCmdType: cmtTIME    ; PropCmd: commSTART      ;
      PropStr: 'START'       ; PropID: 1  ;
      PropParamCount: 1; PropRequiedParamCount: 0),
    ( PropCmdType: cmtTIME    ; PropCmd: commEND ;
      PropStr: 'END'       ; PropID: 2  ;
      PropParamCount: 1; PropRequiedParamCount: 0),
    ( PropCmdType: cmtTIME    ; PropCmd: commWAIT     ;
      PropStr: 'WAIT'        ; PropID: 3 ;
      PropParamCount: 1; PropRequiedParamCount: 1),
    ( PropCmdType: cmtTIME    ; PropCmd: commDELAY      ;
      PropStr: 'DELAY'       ; PropID: 4  ;
      PropParamCount: 1; PropRequiedParamCount: 1),
    ( PropCmdType: cmtASCOM    ; PropCmd: commEQ      ;
      PropStr: 'EQ'          ; PropID: 5  ;
      PropParamCount: 2; PropRequiedParamCount: 2),
    ( PropCmdType: cmtASCOM    ; PropCmd: commEQREL     ;
      PropStr: 'EQREL'       ; PropID: 6  ;
      PropParamCount: 2; PropRequiedParamCount: 2),
    ( PropCmdType: cmtCANON    ; PropCmd: commCANONPARAMS      ;
      PropStr: 'CANONPARAMS' ; PropID: 7  ;
      PropParamCount: 4; PropRequiedParamCount: 2),
    ( PropCmdType: cmtCANON    ; PropCmd: commISO      ;
      PropStr: 'ISO'         ; PropID: 8  ;
      PropParamCount: 1; PropRequiedParamCount: 1),
    ( PropCmdType: cmtCANON    ; PropCmd: commEXP      ;
      PropStr: 'EXP'         ; PropID: 9  ;
      PropParamCount: 1; PropRequiedParamCount: 1),
    ( PropCmdType: cmtCANON    ; PropCmd: commPATH ;
      PropStr: 'PATH'        ; PropID: 10  ;
      PropParamCount: 1; PropRequiedParamCount: 1),
    ( PropCmdType: cmtCANON    ; PropCmd: commFILENAME ;
      PropStr: 'FILENAME'    ; PropID: 11 ;
      PropParamCount: 1; PropRequiedParamCount: 1),
    ( PropCmdType: cmtCANON    ; PropCmd: commPHOTO ;
      PropStr: 'PHOTO'       ; PropID: 12 ;
      PropParamCount: 0; PropRequiedParamCount: 0),
    ( PropCmdType: cmtCANON    ; PropCmd: commSERIES ;
      PropStr: 'SERIES'      ; PropID: 13 ;
      PropParamCount: 4; PropRequiedParamCount: 2),
    ( PropCmdType: cmtCIKL    ; PropCmd: commFOR ;
      PropStr: 'FOR'         ; PropID: 14 ;
      PropParamCount: 1; PropRequiedParamCount: 0),
    ( PropCmdType: cmtCIKL    ; PropCmd: commENDFOR ;
      PropStr: 'ENDFOR'      ; PropID: 15 ;
      PropParamCount: 0; PropRequiedParamCount: 0),
    ( PropCmdType: cmtNone    ; PropCmd: commSHUTDOWN ;
      PropStr: 'SHUTDOWN'    ; PropID: 16 ;
      PropParamCount: 0; PropRequiedParamCount: 0)
  );

Type

  TCmdRec = record
    Cmd   : TSTAFRobLangPropList;
    Pars  : array[0..5] of ShortString;
  end;

  (* A szövegesen megírt STAF Robottávcsõ programot értelmezi és végrehajtja *)

  TStatusChangedEvent = procedure(Sender: TObject; Status: TCmdExecuteStatus) of object;
  TNewCommandEvent    = procedure(Sender: TObject; LineNo: integer; cmdLine: string;
                                          cmdRecord: TCmdRec) of object;

  TSTAFRobCommander = class(TComponent)
  private
    Ora      : TTimer;
    FStatus: TCmdExecuteStatus;
    FCount: integer;
    FEndTime: TDateTime;
    FStartTime: TDateTime;
    FCmdLine: String;
    FReport: boolean;
    FStatusChanged: TStatusChangedEvent;
    FNewCommand: TNewCommandEvent;
    FCmdLineIndex: integer;
    function GetCmdLine: String;
    procedure SetCmdLineIndex(const Value: integer);
    function GetASCOM: boolean;
    function GetCANON: boolean;
    procedure SetEndTime(const Value: TDateTime);
    procedure SetStartTime(const Value: TDateTime);
    function GetCount: integer;
    procedure SetStatus(const Value: TCmdExecuteStatus);
    procedure GetStartEndTime( cText : TstringList );

    procedure OnTimer(Sender: TObject);
  protected
    For1,For2     : integer;    // Ciklus elsõ és utolsó sorának indexe
    ForN          : integer;    // Ciklus ennyiszer ismétlõdik
    InFor         : boolean;    // Ciklus mag jelzése
  public
    Telescope   : TAL_CustomASCOMTelescope;
    Canon       : TCanon;
    CmdList     : TList;
    CmdStrings  : TStringList;        // Command list
    CmdRec      : TCmdRec;            // Actual Command Record
    CmdLine     : string;             // Actual Command Line in process


    CiklNo1, CiklNo2 : integer;       // Ciklus elsõ és utolsó sorának sorszáma

    constructor Create(AOwner: TObject);
    destructor Destroy ; override;

    procedure Execute;
    function  ExecuteText( cText : TstringList ): boolean;
    function  ExecuteLine( cLine : string ): boolean;
    function  ExecuteCommand( cRec : TCmdRec ): boolean;
    function  ExecuteAtLine( LineNo : integer): boolean;
    procedure WaitSec(sec:integer);
    procedure WaitUntil(dt:TDateTime);

    procedure PAUSE;
    procedure CUNTINUE;
    procedure STOP;

    procedure GenerateFromText( Text: TstringList );
    function  IsCommand( CmdStr: string ): integer;
    function  RecToString( Rec: TCmdRec): string;
    function  StringToRec( cStr: string): TCmdRec;

    property  CmdLineIndex : integer read FCmdLineIndex write SetCmdLineIndex;
//    property  CmdLine   : String read FCmdLine write SetCmdLine;
    property  Count     : integer read GetCount write FCount;
    property  Status    : TCmdExecuteStatus read FStatus write SetStatus;
    property  StartTime : TDateTime read FStartTime write SetStartTime;
    property  EndTime   : TDateTime read FEndTime write SetEndTime;
    property  Report    : boolean read FReport write FReport;
    property  isASCOM   : boolean read GetASCOM;
    property  isCANON   : boolean read GetCANON;

    property  OnStatusChanged  : TStatusChangedEvent
                                 read FStatusChanged
                                 write FStatusChanged;
    property  OnNewCommand     : TNewCommandEvent
                                 read FNewCommand
                                 write FNewCommand;
  end;


implementation

{ TSTAFRobCommader }

constructor TSTAFRobCommander.Create(AOwner: TObject);
begin
  Telescope    := TAL_CustomASCOMTelescope(Self);
  Canon        := TCanon(Self);
  CmdList      := TList.Create;
  CmdStrings   := TStringList.Create;
  CmdLine      := '';
  FStartTime   := 0;
  FEndTime     := 0;
  Status       := cmesNone;
  Ora          := TTimer.Create(Self);
  Ora.OnTimer  := OnTimer;
  Telescope.ScopeConnect;
end;

procedure TSTAFRobCommander.CUNTINUE;
begin
  Telescope.Free;
  CmdStrings.Free;
end;

destructor TSTAFRobCommander.Destroy;
begin
  CmdList.Free;
  inherited;
end;

// Start program at first line
procedure TSTAFRobCommander.Execute;
begin
  CmdLineIndex := 0;
  ExecuteText(CmdStrings);
end;

// Start program at CmdLineIndex line
function TSTAFRobCommander.ExecuteText(cText: TstringList): boolean;
begin
  Status := cmesBegin;
  GetStartEndTime(cText);
  Status  := cmesProcess;
  While CmdLineIndex < Pred(cText.Count) do begin
    CmdLine := cText[CmdLineIndex];
    CmdRec  := StringToRec( CmdLine );
    if Assigned(FNewCommand) then FNewCommand(Self,CmdLineIndex,CmdLine,CmdRec);
    if Status in [cmesStop, cmesEnd] then Break
    else
        ExecuteCommand(CmdRec);
    CmdLineIndex := CmdLineIndex+1;
  end;
//  else
end;

function TSTAFRobCommander.ExecuteLine(cLine: string): boolean;
begin
    CmdLine := cLine;
    CmdRec  := StringToRec( cLine );
    ExecuteCommand(CmdRec);
end;


function TSTAFRobCommander.ExecuteCommand(cRec: TCmdRec): boolean;
var uInt: integer;
    Ra,De: double;
begin

  Application.Processmessages;

  While Status = cmesPause do begin
    Application.Processmessages;
    if (Status in [cmesContinue,cmesStop, cmesEnd])
          then Exit;
  end;

  if (StartTime<>0) and (Now>=StartTime) then begin
     Status := cmesContinue;
     StartTime := 0;
  end;

  if (EndTime<>0) and (Now>=EndTime) then begin
     Status := cmesEnd;
     EndTime := 0;
  end;

  Case cRec.Cmd.PropCmd of
    commSTART:
      begin
        StartTime := TimeStringToTime(cRec.Pars[0]);
      end;
    commEND:
      begin
        EndTime := TimeStringToTime(cRec.Pars[0]);
      end;
    commWAIT, commDELAY:
      begin
        uInt:=StrToInt(cRec.Pars[0]);
        WaitSec( uInt );
      end;
    commEQ:
        if isASCOM then begin
           Ra := StrToAr_De( cRec.Pars[0]);
           De := StrToAr_De( cRec.Pars[1]);
           Telescope.ScopeGoto(Ra,De);
        end
        else WaitSec( 1 );
    commEQREL:
        if isASCOM then begin
           Ra := StrToFloat( cRec.Pars[0])/900;
           De := StrToFloat( cRec.Pars[1])/60;
           Telescope.ScopeRelGoto(Ra,De);
        end
        else WaitSec( 1 );
    commCANONPARAMS:
      begin
      end;
    commISO:
        if isCANON then
           Canon.SetISO(cRec.Pars[0])
        else WaitSec( 1 );
    commEXP:
        if isCANON then
           Canon.SetTV(cRec.Pars[0])
        else WaitSec( 1 );
    commPATH:
        if isCANON then
           Canon.FilePath := cRec.Pars[0]
        else WaitSec( 1 );
    commFILENAME:
        if isCANON then
           Canon.FileName := cRec.Pars[0]
        else WaitSec( 1 );
    commPHOTO:
        if isCANON then
           Canon.TakePicture
        else sleep(1000);
    commSERIES:
        if isCANON then
        begin
        end
        else WaitSec( 1 );
    commFOR:
        Begin
             //GetForIndexes;
             For1  := CmdLineIndex+1;
             ForN  := StrToInt(cRec.Pars[0]);
             InFor := True;
        end;
    commENDFOR:
      begin
        Dec(ForN);
        InFor := ForN>0;
        if InFor then begin
           CmdLineIndex := For1-1;
//           Execute;
        end ELSE
           CmdLineIndex := CmdLineIndex;
      end;
    commSHUTDOWN:
      begin
        Status := cmesEnd;
        sleep(10000);            // Waiting 10 sec
        ExitWindowsEx(EWX_FORCE and EWX_SHUTDOWN,0);
      end;
  end;
end;

procedure TSTAFRobCommander.GenerateFromText(Text: TstringList);
var nLine: integer;
begin
  CmdStrings.Clear;
  For nLine:=0 to Text.Count-1 do begin
    CmdStrings.Add(Text[nLine]);
  end;
end;


function TSTAFRobCommander.GetASCOM: boolean;
begin
  Result := Telescope.ScopeConnected;
  if not Result then WaitSec(1);
end;

function TSTAFRobCommander.GetCANON: boolean;
begin
  Result := Canon.IsConnect;
  if not Result then WaitSec(1);
end;

function TSTAFRobCommander.GetCmdLine: String;
begin
  Result := CmdLine;
end;

function TSTAFRobCommander.GetCount: integer;
begin
  Result := CmdStrings.Count;
end;

// A parancs script elõzetes elemzésével megkeresi a StarTime, EndTime idõket
procedure TSTAFRobCommander.GetStartEndTime(cText: TstringList);
var nLine,i: integer;
    sLine  : string;
    cRec   : TCmdRec;
begin
  For nLine:=0 to cText.Count-1 do begin
    sLine  := cText[nLine];
    cRec   := StringToRec( sLine );
    if cRec.Cmd.PropCmd = commSTART then
      StartTime := TimeStringToTime(cRec.Pars[0]);
    if cRec.Cmd.PropCmd = commEND then
      EndTime := TimeStringToTime(cRec.Pars[0]);
  end;
end;

procedure TSTAFRobCommander.SetEndTime(const Value: TDateTime);
var t: TDateTime;
begin
  FEndTime := Value;
  t := Now;
  // Ha a kezdõnap kisebb mint a mai nap
  if Trunc(Value)<Trunc(t) then
    FEndTime := Trunc(t)+Frac(Value);
  // Ha az idõ kisebb mint a jelenlegi akkor a köv. nap
  if Frac(Value)<Frac(t) then
    FEndTime := Trunc(t)+1+Frac(Value);
end;

procedure TSTAFRobCommander.SetStartTime(const Value: TDateTime);
var t: TDateTime;
begin
  FStartTime := Value;
  t := Now;
  // Ha a kezdõnap kisebb mint a mai nap
  if Trunc(Value)<Trunc(t) then
    FStartTime := Trunc(t)+Frac(Value);
  // Ha az idõ kisebb mint a jelenlegi akkor a köv. nap
  if Frac(Value)<Frac(t) then
    FStartTime := Trunc(t)+1+Frac(Value);
end;

procedure TSTAFRobCommander.SetStatus(const Value: TCmdExecuteStatus);
begin
  FStatus := Value;
  if Assigned(FStatusChanged) then FStatusChanged(Self,Value);
end;

procedure TSTAFRobCommander.PAUSE;
begin
   Status := cmesPause;
end;

procedure TSTAFRobCommander.STOP;
begin
   Status := cmesStop;
end;

function TSTAFRobCommander.StringToRec(cStr: string): TCmdRec;
var i,j: integer;
    cmdStr : string;
    Ch     : integer;
    pStr   : string;
begin
  cmdStr := UpperCase(AllTrim(Szo(cStr,1)));
  i := IsCommand(cmdStr);
  if i>-1 then
    begin
      Result.Cmd := STAFCommProp[i];
      For j:=0 to High(Result.Pars) do begin
        pStr := Szo(cStr,j+2);
        Result.Pars[j] := pStr;
      end;
      EXIT;
    end
  else
  begin
     Result.Cmd := STAFCommProp[0];
     exit;
  end;
end;

function TSTAFRobCommander.RecToString(Rec: TCmdRec): string;
var i: integer;
begin
  Result := Rec.Cmd.PropStr;
  For i:=0 to High(Rec.Pars) do
    Result := Result + ' ' + Rec.Pars[i];
end;

function TSTAFRobCommander.IsCommand( CmdStr: string ): integer;
var i: integer;
begin
  Result := -1;
  if Alltrim(CmdStr)='' then exit;
  For i:=0 to High(STAFCommProp) do
    if STAFCommProp[i].PropStr = cmdStr then begin
      Result := i;
      exit;
    end;
end;

procedure TSTAFRobCommander.OnTimer(Sender: TObject);
begin

end;

procedure TSTAFRobCommander.SetCmdLineIndex(const Value: integer);
begin
  FCmdLineIndex := Value;
  if FCmdLineIndex>Pred(CmdStrings.Count) then
     FCmdLineIndex := Pred(CmdStrings.Count);
  CmdLine := CmdStrings[FCmdLineIndex];
end;

{Várakozás sec másodpercig}
procedure TSTAFRobCommander.WaitSec(sec:integer);
var d1:TDateTime;
    h,m,s,ms: word;
begin
  d1:=Now;
  repeat
    DecodeTime(Now-d1,h,m,s,ms);
    Application.ProcessMessages;
    if (Status in [cmesPause,cmesStop,cmesEnd])
    then
        Exit;
  Until s>=sec;
end;


procedure TSTAFRobCommander.WaitUntil(dt: TDateTime);
begin
  repeat
    Application.ProcessMessages;
    if (Status in [cmesPause,cmesStop,cmesEnd])
    then
        Exit;
  Until now>=dt;
end;

function TSTAFRobCommander.ExecuteAtLine(LineNo: integer): boolean;
begin
  CmdLineIndex := LineNo;
  ExecuteText(CmdStrings);
end;

end.
