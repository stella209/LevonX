(*
  AL_ASCOMTelescope

  This Delphi component is the implementation of Telescope driver
  for Goto cumputerized telescope mounts.
  Required: Installad ASCOM interface!

  Outhor : Agócs László 2009 Hungary
  Base on: Cartes du Ciel source code

*)

unit STAF_ASCOM;

interface

uses
  Windows,  Messages, SysUtils, Classes, Variants, Graphics, Controls,
  Forms, Dialogs, ShellAPI, ComObj,
  StdCtrls, Buttons, inifiles, ComCtrls, Menus, ExtCtrls,
  STAF_AstroUnit;

Type

  TDirect = (dirLeft,dirRight,dirUp,dirDown);

  TAlignmentModes = (algAltAz,algPolar,algGermanPolar);

  TConnectEvent = procedure(Sender: TObject; Connection: boolean) of object;
  TChangeCoordEvent = procedure(Sender: TObject; Ra, De: double) of object;
  TTimerChange = procedure(Sender: TObject; Direction: TDirect; Duration: integer) of object;

  // Telescope korrections Ra,De by two TTimer;
  TALCorrections = class(TPersistent)
  private
    FActive: boolean;
    FCorrectionPerArcsec: double;
    FDeTime: double;
    FRaTime: double;
    FOnRaTimer: TNotifyEvent;
    FOnTimerChange: TTimerChange;
    procedure SetActive(const Value: boolean);
    procedure SetCorrectionPerArcsec(const Value: double);
    procedure SetdDeTime(const Value: double);
    procedure SetdRaTime(const Value: double);
    procedure OnRaTimerEvent(Sender: TObject);
    procedure OnDeTimerEvent(Sender: TObject);
  protected
    RaTimer : TTimer;
    DeTimer : TTimer;
  public
     constructor Create;
     destructor Destroy; override;
  published
     property Active: boolean read FActive write SetActive;
     property RaTime: double read FRaTime write SetdRaTime;  //mp-ben
     property DeTime: double read FDeTime write SetdDeTime;
     property CorrectionPerArcsec: double read FCorrectionPerArcsec
              write SetCorrectionPerArcsec;
     property OnTimerChange: TTimerChange read FOnTimerChange write FOnTimerChange;
  end;

  TAL_CustomASCOMTelescope = class(TComponent)
  private
    FAutoConnect: boolean;
    FScopeName: string;
    FIniFile: string;
    FInitialized: boolean;
    FConnected: boolean;
    FOnConnect: TConnectEvent;
    FOnChangeCoord: TChangeCoordEvent;
    FOnRefresh: TNotifyEvent;
    FCorrections: TALCorrections;
    function GetUTC: TDateTime;
    procedure SetUTC(const Value: TDateTime);
    function GetAlignmentMode: TAlignmentModes;
    function GetDeclinationRate: double;
    function GetRightAscensionRate: double;
    procedure SetDeclinationRate(const Value: double);
    procedure SetRightAscensionRate(const Value: double);
    function GetTracking: boolean;
    procedure SetTracking(const Value: boolean);
    function GetSideralTime: double;
    function GetPuslseGuide: boolean;
    function GetRefreshrate: integer;
    procedure SetRefreshrate(const Value: integer);
    function GetDe: double;
    function GetRa: double;
    procedure SetDe(const Value: double);
    procedure SetRa(const Value: double);
    procedure SetConnected(const Value: boolean);
    procedure SetAutoConnect(const Value: boolean);
    procedure SetIniFile(const Value: string);
    procedure SetScopeName(const Value: string);
    function GetGuideRateDe: double;
    function GetGuideRateRa: double;
    procedure SetGuideRateDe(const Value: double);
    procedure SetGuideRateRa(const Value: double);
  protected
    inTimer   : TTimer;        // Timer for get Ra,De
    procedure LoadConfig;
    procedure SaveConfig;
    procedure OnTimer(Sender: TObject);
    procedure OnCorrection(Sender: TObject; Direction: TDirect; Duration: integer);
  public
     T         : Variant;       // Telescope variant
     Ser       : Variant;       // Serial comm. variant
     ini       : TIniFile;      // Ini file for parameters load/save

     constructor Create(AOwner:TComponent); override;
     destructor  Destroy; override;

     function  GetASCOMInstalled: boolean;
     function  ScopeConnect: boolean;
     function  ScopeDisconnect : boolean;
     function  ScopeSelect(scopeType: string): string;
     procedure ScopeConfigure;
     function  ScopeConnected : boolean;
     // Rates
//     function  ScopeAxisRates(Axis: integer): IAxisReates;

     procedure ScopeAbort;
     procedure ScopeAlign(ar_,de_: double);
     function  ScopeSyncToCoordinates(ar_,de_: double): boolean;
     function  ScopeShowModal : boolean;
     procedure ScopeShow;
     procedure ScopeClose;
     procedure ScopeGetEqSys(var EqSys : double);
     function  ScopeGetRaDec(var ar_,de_ : double): boolean;
     function  ScopeGetAltAz(var alt,az : double): boolean;
     procedure ScopeGetName(var scopename : shortstring);
     procedure ScopeReset;
     procedure ScopeGetInfo(var Name : shortstring; var QueryOK,SyncOK,GotoOK : boolean; var refreshrate : integer);
     procedure ScopeSetObs(latitude,longitude : double);
     function  ScopeGoto(ar_,de_ : double): boolean;
     function  ScopeRelGoto(ar_, de_: double): boolean;
     function  ScopeAdjust(Direction: TDirect; Rate: integer): boolean;
     procedure SetLocation(Longitude, Latitude: double);
     procedure ScopePark;
     procedure ScopeUnPark;
     procedure ScopePulseGuide(Direction: TDirect; Duration: integer);
     procedure ScopeMoveAxis(Direction: TDirect; Rate: double);
     procedure ScopeSlewToTarget(var ar_,de_ : double);
     procedure ScopeSlewToTargetAsync(var ar_,de_ : double);

     Function  CreateSerial: boolean;

     property IniFile          : string read FIniFile write SetIniFile;
     property ASCOMInstalled   : boolean read GetASCOMInstalled;
     Property AutoConnect      : boolean read FAutoConnect write SetAutoConnect default False;
     Property Connected        : boolean read FConnected write SetConnected default False;
     property Corrections      : TALCorrections read FCorrections write FCorrections;
     Property Initialized      : boolean read FInitialized write FInitialized default False;
     Property ScopeName        : string read FScopeName write SetScopeName;
     property Ra               : double read GetRa write SetRa;
     property De               : double read GetDe write SetDe;
     property Refreshrate      : integer read GetRefreshrate write SetRefreshrate;
     property Tracking         : boolean read GetTracking write SetTracking;
     property RightAscensionRate : double read GetRightAscensionRate write SetRightAscensionRate;
     property DeclinationRate  : double read GetDeclinationRate write SetDeclinationRate;
     property GuideRateRa      : double read GetGuideRateRa write SetGuideRateRa;
     property GuideRateDe      : double read GetGuideRateDe write SetGuideRateDe;
     property AlignmentMode    : TAlignmentModes read GetAlignmentMode;

     property CanPuslseGuide: boolean read GetPuslseGuide;
     property SideralTime: double read GetSideralTime;
     property UTC : TDateTime read GetUTC write SetUTC;

     property OnConnect : TConnectEvent read FOnConnect write FOnConnect;
     property OnChangeCoord : TChangeCoordEvent read FOnChangeCoord write FOnChangeCoord;
     property OnRefresh : TNotifyEvent read FOnRefresh write FOnRefresh;
  end;

  TALTelescope = class(TAL_CustomASCOMTelescope)
  private
  protected
  public
     property ASCOMInstalled;
     Property Initialized;
  published
     property IniFile;
     Property AutoConnect;
     Property Connected;
     property Corrections;
     Property ScopeName;
     property Ra;
     property De;
     property Refreshrate;
     property Tracking;
     property AlignmentMode;
     property OnConnect;
     property OnChangeCoord;
     property OnRefresh;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('AL',[TALTelescope]);
end;

{ TAL_CustomASCOMTelescope }

constructor TAL_CustomASCOMTelescope.Create(AOwner: TComponent);
begin
  inherited;
  // Controlling ASCOM interface
  T := Unassigned;
  Corrections  := TALCorrections.Create;
  Corrections.OnTimerChange := OnCorrection;
  FAutoConnect := True;
  FScopeName   := 'Celestron.Telescope';
  if FIniFile = '' then
     FIniFile     := 'Telescope.ini';
  IF FileExists(FIniFile) then
     LoadConfig;
  inTimer         := TTimer.Create(Self);
  RefreshRate     := 1000;                    // 1 sec = 1000 msec
  inTimer.Interval:= 1000;
  inTimer.OnTimer := OnTimer;
end;

destructor TAL_CustomASCOMTelescope.Destroy;
begin
  if Corrections<>nil then
     Corrections.Free;
//  SaveConfig;
  if inTimer<>nil then inTimer.Free;
  inherited;
end;

function TAL_CustomASCOMTelescope.GetASCOMInstalled: boolean;
var
  V: variant;
begin
  try
  V := CreateOleObject('DriverHelper.Chooser');
  V.devicetype:='Telescope';
  FScopeName:=V.Choose(FScopeName);
  V:=Unassigned;
  Result := True;
  except
    Result := False;
    Showmessage('No ASCOM telescope drivers are installed!');
  end;
end;

procedure TAL_CustomASCOMTelescope.ScopeConfigure;
begin
if (not Scopeconnected) then begin
  if VarIsEmpty(T) then begin
   T := CreateOleObject(ScopeName);
   T.SetupDialog;
   T:=Unassigned;
  end else begin
   T.SetupDialog;
  end;
end;
end;

function TAL_CustomASCOMTelescope.ScopeConnect: boolean;
var dis_ok : boolean;
begin
Try
  if Trim(ScopeName)='' then exit;
  if T=Unassigned then
  T := CreateOleObject(ScopeName);
  T.connected:=true;
  if T.connected then begin
    Connected := True;
    Initialized:=true;
    Result := True;
  end else scopedisconnect;
except
    Result := False;
end;
end;

Function TAL_CustomASCOMTelescope.CreateSerial: boolean;
begin
Try
  Result := True;
  Ser := CreateOleObject('DriverHelper.Serial');
except
  Result := False;
end;
end;

function TAL_CustomASCOMTelescope.ScopeDisconnect: boolean;
begin
Try
  Initialized:=false;
  if trim(ScopeName)='' then exit;
  if not VarIsEmpty(T) then begin
    T.connected:=false;
    T:=Unassigned;
    Connected := False;
    Result:=true;
  end;
except
    Result := False;
end;
end;


procedure TAL_CustomASCOMTelescope.ScopeAlign(ar_,de_: double);
begin
  if ScopeConnected then
    if T.CanSync then T.SyncToCoordinates(ar_,De_);
end;

procedure TAL_CustomASCOMTelescope.ScopeClose;
begin
  ScopeDisconnect;
end;

function TAL_CustomASCOMTelescope.ScopeConnected: boolean;
begin
  Result := False;
  if not VarIsEmpty(T) then
    Result := T.Connected;
end;

function TAL_CustomASCOMTelescope.ScopeGetAltAz(var alt, az: double): boolean;
begin
 if ScopeConnected then begin
   az  := T.Azimuth;
   alt := T.Altitude;
   Result:=true;
 end else Result:=false;
end;

procedure TAL_CustomASCOMTelescope.ScopeGetEqSys(var EqSys: double);
begin
end;

procedure TAL_CustomASCOMTelescope.ScopeGetInfo(var Name: shortstring;
  var QueryOK, SyncOK, GotoOK: boolean; var refreshrate: integer);
begin
  if ScopeConnected  then begin
    Name    := T.name;
    QueryOK := true;
    SyncOK  := T.CanSync;
    GotoOK  := T.CanSlew;
  end else begin
    name:='';
    QueryOK:=false;
    SyncOK:=false;
    GotoOK:=false;
  end;
  Refreshrate := inTimer.interval;
end;

function TAL_CustomASCOMTelescope.ScopeGetRaDec(var ar_, de_: double): boolean;
begin
if ScopeConnected then begin
   ar_:=Ra;
   de_:=De;
   Result:=true;
end else Result:=false;
end;

function TAL_CustomASCOMTelescope.ScopeGoto(ar_, de_: double): boolean;
begin
  Result := False;
  if ScopeConnected then begin
    if T.CanSlewAsync then T.SlewToCoordinatesAsync(ar_,de_)
                  else T.SlewToCoordinates(ar_,de_);
    Result := True;
  end;
end;

// A jelenlegi pozícióhoz képest ar_,de_ ivperccel mozgatja el a távcsövet
function TAL_CustomASCOMTelescope.ScopeRelGoto(ar_, de_: double): boolean;
var dar,dde,dad,ded : double;
    dur     : integer;
    RaMin,DeMin : double;
begin
  Result := False;
  if ScopeConnected then begin
    dar := Ra + ar_/900;
    dde := De + de_/60;
    Dur := 10;
    RaMin := 1000; DeMin := 1000;
    Repeat
       dad := Abs(dar-Ra);
       If dad<RaMin then begin
          RaMin := dad;
          if ar_<0 then ScopeAdjust(dirLeft,5);
          if ar_>0 then ScopeAdjust(dirRight,5);
       end;
       ded := Abs(dde-De);
       If ded<DeMin then begin
          DeMin := ded;
          if de_>0 then ScopeAdjust(dirUp,5);
          if de_<0 then ScopeAdjust(dirDown,5);
       end;
    Until (dad>=RaMin) and (ded>=DeMin);
    ScopeAbort;
  end;
end;

procedure TAL_CustomASCOMTelescope.ScopeReset;
begin
end;

function TAL_CustomASCOMTelescope.ScopeSelect(scopeType: string): string;
               var
                  V: variant;
               begin
               try
                  V := CreateOleObject('DriverHelper.Chooser');
                  V.devicetype:='Telescope';
                  Result:=V.Choose(scopeType);
                  V:=Unassigned;
               except
               Showmessage('Please ensure that ASCOM telescope drivers are installed properly.');
               end;
               end;

procedure TAL_CustomASCOMTelescope.ScopeSetObs(latitude,
  longitude: double);
begin
  if ScopeConnected then begin
     T.SiteLongitude := longitude;
     T.SiteLatitude  := latitude;
  end;
end;

procedure TAL_CustomASCOMTelescope.ScopeShow;
begin

end;

function TAL_CustomASCOMTelescope.ScopeShowModal: boolean;
begin

end;

procedure TAL_CustomASCOMTelescope.SetAutoConnect(const Value: boolean);
begin
  FAutoConnect := Value;
  // Controlling ASCOM interface
//  If FAutoConnect then
//     ASCOMInstallad:=True;
end;

procedure TAL_CustomASCOMTelescope.SetIniFile(const Value: string);
begin
  FIniFile := Value;
  if Value = '' then
     FIniFile := 'Telescope.ini';
  Ini := TIniFile.Create(FIniFile);
end;

procedure TAL_CustomASCOMTelescope.SetScopeName(const Value: string);
begin
  FScopeName := Value;
end;

procedure TAL_CustomASCOMTelescope.LoadConfig;
begin
Try
  if Ini=nil then
  ini:=tinifile.create(FIniFile);
finally
  ini.Free;
end;
end;

procedure TAL_CustomASCOMTelescope.SaveConfig;
begin
Try
Try
  if Ini=nil then
    ini:=tinifile.create(FIniFile);
    ini.writestring('Ascom','ScopeName',ScopeName);
    ini.writestring('Ascom','RefreshRate',IntToStr(inTimer.Interval));
//  ini.writeBool('Ascom','AltAz',ShowAltAz.Checked);
//  ini.writestring('observatory','latitude',lat.text);
//  ini.writestring('observatory','longitude',long.text);
finally
  ini.Free;
end;
except
end;
end;

// Telescop finommozgatása
function TAL_CustomASCOMTelescope.ScopeAdjust(Direction: TDirect; Rate: integer): boolean;
Var Ra_,De_ : double;
    ut      : string;
    Button  : integer;
    r       : string;
begin
  if ScopeConnected then BEGIN
     Case Direction of
     dirLeft:
       begin
         ut   := 'P'+chr(2)+chr(16)+chr(36)+chr(Rate)+chr(0)+chr(0)+chr(0);
       end;
     dirRight:
       begin
         ut   := 'P'+chr(2)+chr(16)+chr(37)+chr(Rate)+chr(0)+chr(0)+chr(0);
       end;
     dirUp:
       begin
         ut   := 'P'+chr(2)+chr(17)+chr(36)+chr(Rate)+chr(0)+chr(0)+chr(0);
       end;
     dirDown:
       begin
         ut   := 'P'+chr(2)+chr(17)+chr(37)+chr(Rate)+chr(0)+chr(0)+chr(0);
       end;
     end;

     r := T.CommandBlind(ut,False);
     Application.ProcessMessages;
  end;
end;

procedure TAL_CustomASCOMTelescope.SetConnected(const Value: boolean);
begin
  FConnected := Value;
  if Assigned(FOnConnect) then FOnConnect(Self,Value);
end;

procedure TAL_CustomASCOMTelescope.OnTimer(Sender: TObject);
begin
   if Connected then begin
   If Assigned(FOnRefresh) then FOnRefresh(Sender);
   end;
end;

procedure TAL_CustomASCOMTelescope.ScopeGetName(var scopename: shortstring);
begin
end;

function TAL_CustomASCOMTelescope.GetRa: double;
begin
   if Connected then begin
      Result := T.RightAscension;
   end;
end;

function TAL_CustomASCOMTelescope.GetDe: double;
begin
   if Connected then begin
      Result := T.Declination;
   end;
end;

procedure TAL_CustomASCOMTelescope.SetRa(const Value: double);
begin
end;

procedure TAL_CustomASCOMTelescope.SetDe(const Value: double);
begin
end;

function TAL_CustomASCOMTelescope.GetRefreshrate: integer;
begin
  Result := InTimer.Interval;
end;

procedure TAL_CustomASCOMTelescope.SetRefreshrate(const Value: integer);
begin
  InTimer.Interval := Value;
end;

procedure TAL_CustomASCOMTelescope.SetLocation(Longitude, Latitude: double);
begin
 if ScopeConnected then begin
  T.SiteLongitude := longitude;
  T.SiteLatitude  := latitude;
 end;
end;

procedure TAL_CustomASCOMTelescope.ScopeAbort;
begin
  if ScopeConnected then
    T.AbortSlew;
end;

procedure TAL_CustomASCOMTelescope.ScopePark;
begin
  if ScopeConnected and T.CanPark then T.Pak;
end;

function TAL_CustomASCOMTelescope.GetPuslseGuide: boolean;
begin
  if ScopeConnected then
    Result := T.CanPulseGuide;
end;

procedure TAL_CustomASCOMTelescope.ScopePulseGuide(Direction: TDirect; Duration: integer);
begin
  if ScopeConnected then
  if T.CanPulseGuide then
    T.PulseGuide(Ord(Direction),Duration);
end;

function TAL_CustomASCOMTelescope.GetSideralTime: double;
begin
  if ScopeConnected then
    Result := T.SiderealTime;
end;

function TAL_CustomASCOMTelescope.GetTracking: boolean;
begin
  if ScopeConnected then
    Result := T.Tracking;
end;

// Swich on/off the sideraé clock-drive
procedure TAL_CustomASCOMTelescope.SetTracking(const Value: boolean);
begin
  if ScopeConnected then
    T.Tracking := Value;
end;

// Syncronize telescope to the coordinates
function TAL_CustomASCOMTelescope.ScopeSyncToCoordinates(ar_,
  de_: double): boolean;
begin
Try
  if ScopeConnected then
    if T.CanSync then begin
      T.SyncToCoordinates(ar_,De_);
      Result := True;
    end;
except
  Result := False;
end;
end;

function TAL_CustomASCOMTelescope.GetDeclinationRate: double;
begin
  Result := 0;
  if ScopeConnected then
     Result := T.DeclinationRate;
end;

function TAL_CustomASCOMTelescope.GetGuideRateDe: double;
begin
  if ScopeConnected then
     Result := T.GuideRateDeclination;
end;

function TAL_CustomASCOMTelescope.GetGuideRateRa: double;
begin
  if ScopeConnected then
     Result := T.GuideRateRightAscension;
end;

function TAL_CustomASCOMTelescope.GetRightAscensionRate: double;
begin
  Result := 0;
  if ScopeConnected then
     Result := T.RightAscensionRate;
end;

procedure TAL_CustomASCOMTelescope.SetDeclinationRate(const Value: double);
begin
  if ScopeConnected then
     T.DeclinationRate := Value;
end;

procedure TAL_CustomASCOMTelescope.SetGuideRateDe(const Value: double);
begin
  if ScopeConnected then
     T.GuideRateRightAscension := Value;
end;

procedure TAL_CustomASCOMTelescope.SetGuideRateRa(const Value: double);
begin
  if ScopeConnected then
     T.GuideRateDeclination := Value;
end;

procedure TAL_CustomASCOMTelescope.SetRightAscensionRate(const Value: double);
begin
  if ScopeConnected then
     T.RightAscensionRate := Value;
end;

// Dirrect axis driver
// You can stop this function with ScopeAbort;
procedure TAL_CustomASCOMTelescope.ScopeMoveAxis(Direction: TDirect;
  Rate: double);
begin
  if ScopeConnected then
  Case Direction of
  dirUp  : T.MoveAxis(1,-rate);
  dirDown: T.MoveAxis(1,rate);
  dirLeft: T.MoveAxis(0,-rate);
  dirRight:T.MoveAxis(0,rate);
  end;
end;

function TAL_CustomASCOMTelescope.GetAlignmentMode: TAlignmentModes;
begin
  if ScopeConnected then
     Result := T.AlignmentMode;
end;

procedure TAL_CustomASCOMTelescope.ScopeSlewToTarget(var ar_, de_: double);
begin
  if ScopeConnected then
  begin
    T.TargetRightAscension := ar_;
    T.TargetDeclination    := de_;
    T.SlewToTarget;
  end;
end;

procedure TAL_CustomASCOMTelescope.ScopeSlewToTargetAsync(var ar_, de_: double);
begin
  if ScopeConnected and T.CanSlewAsync then
  begin
    T.TargetRightAscension := ar_;
    T.TargetDeclination    := de_;
    T.SlewToTargetAsync;
  end;
end;

procedure TAL_CustomASCOMTelescope.ScopeUnPark;
begin
  if ScopeConnected and T.CanPark then
     T.UnPark;
end;

function TAL_CustomASCOMTelescope.GetUTC: TDateTime;
begin
  if ScopeConnected and T.CanPark then
     T.UTCDate;
end;

procedure TAL_CustomASCOMTelescope.SetUTC(const Value: TDateTime);
begin
  if ScopeConnected and T.CanPark then
     T.UTCDate := Value;
end;

procedure TAL_CustomASCOMTelescope.OnCorrection(Sender: TObject;
  Direction: TDirect; Duration: integer);
begin
  ScopePulseGuide(Direction,Duration);
end;

{ TALCorrections }

constructor TALCorrections.Create;
begin
  RaTimer := TTimer.Create(Application);
  DeTimer := TTimer.Create(Application);
  RaTimer.OnTimer := OnRaTimerEvent;
  DeTimer.OnTimer := OnDeTimerEvent;
end;

destructor TALCorrections.Destroy;
begin
//  if RaTimer<>nil then RaTimer.Free;
//  if DeTimer<>nil then DeTimer.Free;
  inherited;
end;

procedure TALCorrections.OnDeTimerEvent(Sender: TObject);
VAR Direction: TDirect;
begin
  if deTime >= 0 then Direction := dirUp
  else Direction := dirDown;
  if Assigned(FOnTimerChange) then FOnTimerChange(Self,Direction,500)
end;

procedure TALCorrections.OnRaTimerEvent(Sender: TObject);
VAR Direction: TDirect;
begin
  if RaTime >= 0 then Direction := dirRight
  else Direction := dirLeft;
  if Assigned(FOnTimerChange) then FOnTimerChange(Self,Direction,500)
end;

procedure TALCorrections.SetActive(const Value: boolean);
begin
  FActive := Value;
  RaTimer.Enabled := Value;
  DeTimer.Enabled := Value;
end;

procedure TALCorrections.SetCorrectionPerArcsec(const Value: double);
begin
  FCorrectionPerArcsec := Value;
end;

procedure TALCorrections.SetdDeTime(const Value: double);
begin
  FDeTime := Value;
  DeTimer.Interval := Abs(Round(1000*Value));
end;

procedure TALCorrections.SetdRaTime(const Value: double);
begin
  FRaTime := Value;
  RaTimer.Interval := Abs(Round(1000*Value));
end;

end.
