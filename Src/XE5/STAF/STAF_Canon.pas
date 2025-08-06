unit STAF_Canon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DateUtils, EDSDKApi, EDSDKTYPE, EDSDKERROR;

type
  TPictureStatus = (psNone, psBegin, psPicture, psSaved, psDelay, psEnd);

  TPictureSeriesStatus = (pssNone, pssFirst, pssMiddle, pssEnd);
  TPictureSeriesStatusSet = set of TPictureSeriesStatus;

  TPictureSeriesEvent = procedure(Sender: TObject; PicCount: integer;
                                  Status: TPictureStatus; Sec: integer) of object;

  TPropList = record
    PropStr : string;
    PropID  : EdsUInt32;
  end;
  PPropList = ^TPropList;


  TFileNameProc = class(TPersistent)
  private
    FPrefix: string;
    FBlank: string;
    FUserTag: string;
    FlTime: boolean;
    FlPrefix: boolean;
    FlDate: boolean;
    FlUserTag: boolean;
    FlCount: boolean;
    FStartCounter: integer;
    FFilePath: string;
    FOverwrite: boolean;
    FExtension: string;
    FlJD: boolean;
    FlUT: boolean;
    FlDateTime: boolean;
    procedure SetFilePath(const Value: string);
    procedure SetBlank(const Value: string);
  public
    constructor Create;
    function GetFileName: string;
  published
    property StartCounter : integer read FStartCounter write FStartCounter;
    property FilePath     : string  read FFilePath write SetFilePath;
    property FileName     : string  read GetFileName;
    property Prefix       : string  read FPrefix write FPrefix;
    property Blank        : string  read FBlank write SetBlank;
    property UserTag      : string  read FUserTag write FUserTag;
    property Extension    : string  read FExtension write FExtension;
    property lPrefix      : boolean read FlPrefix write FlPrefix;
    property lDate        : boolean read FlDate write FlDate;
    property lTime        : boolean read FlTime write FlTime;
    property lDateTime    : boolean read FlDateTime write FlDateTime;
    property lUT          : boolean read FlUT write FlUT;
    property lJD          : boolean read FlJD write FlJD;
    property lCount       : boolean read FlCount write FlCount;
    property lUserTag     : boolean read FlUserTag write FlUserTag;
    property Overwrite    : boolean read FOverwrite write FOverwrite;
  end;

  TConnectEvent  = procedure(Sender: TObject; Connected: boolean) of object;
  TNewFileEvent  = procedure(Sender: TObject; SavedFile: string) of object;
  TProgressEvent = procedure(Sender: TObject; Percent: cardinal) of object;
  TTimerEvent    = procedure(Sender: TObject; RemainTime: integer) of object;

  TExpositions = class(TPersistent)
  private
    FBulbPort: integer;
    FSeries: boolean;
    FCount: integer;
    FExpTime: integer;
    FDelay: integer;
    FBulbCable: boolean;
  public
    property Series     : boolean     read FSeries    write FSeries;             // sorozat felvétel
    property Count      : integer     read FCount     write FCount default 1;    // sorozat db
    property BulbCable  : boolean     read FBulbCable write FBulbCable;          // Bulb kábel soros vagy USB-Serial
    property BulbPort   : integer     read FBulbPort  write FBulbPort;           // COM port sorszáma
    property ExpTime    : integer     read FExpTime   write FExpTime;            // Bulb kábellel [sec]
    property Delay      : integer     read FDelay     write FDelay;              // felvételek közötti szünet sec.
  end;

  TCanon = class(TComponent)
  private
    DeviceInfo    : EdsDeviceInfo;
    stateTimer    : TTimer;
    FIsSDKLoaded  : Bool;
    FTime         : EdsTime;

     { capture parameter }
    FModelName    : PAnsiChar;
    FAeMode       : EdsUInt32;
    FAv           : EdsUInt32;
    FTv           : EdsUInt32;
    FIso          : EdsUInt32;
    FBatteryLevel : EdsUInt32;
    FJpegQuality  : EdsUInt32;

    { available range list of capture paramter }
    FAeModeDesc       : EdsPropertyDesc;
    FAvDesc           : EdsPropertyDesc;
    FTvDesc           : EdsPropertyDesc;
    FIsoDesc          : EdsPropertyDesc;
    FBatteryLevelDesc : EdsPropertyDesc;
    FJpegQualityDesc  : EdsPropertyDesc;
    FWBDesc           : EdsPropertyDesc;

    FIsConnect: boolean;
    FOnConnect: TConnectEvent;
    FIsLegacy: Bool;
    FTPictureStatus: TPictureStatus;
    FNewFile: string;
    FSavePath: string;
    FFileName: string;
    FOnNewFile: TNewFileEvent;
    FAutoSave: boolean;
    FFileNameProc: TFileNameProc;
    FOnChangeParams: TNotifyEvent;
    FOnProgrees: TProgressEvent;
    FWB: EdsUInt32;
    FOnAfterDownload: TNotifyEvent;
    FExpositions: TExpositions;
    FStartCounter: word;
    FDelaySec: integer;
    FImageCount: integer;
    FOnPictureSeries: TPictureSeriesEvent;
    function FindTvStr(data: EdsUInt32; var sTv: string): boolean;
    procedure SetAutoSave(const Value: boolean);
    procedure SetSavePath(const Value: string);
    procedure SetFileName(const Value: string);
    procedure SetNewFile(const Value: string);
    procedure SetTPictureStatus(const Value: TPictureStatus);
    procedure OnTimer(Sender: TObject);
    function GetCameraCount: integer;
    function getModelName : string ;
    procedure SetIsConnect(const Value: boolean);
    procedure SetExpositions(const Value: TExpositions);
    procedure OnOra(Sender: TObject);
    procedure SetImageCount(const Value: integer);
  protected
    Ora   : TTimer;          // Timer for series of pictures
    OraCounter : integer;    // Counts the seconds
    oldCameraCount : integer;
    function  SetEventCallBack : EdsError;
  public
    FhWnd : HWND;
    Camera: EdsBaseRef;                   // Camera object
    cameraList   : EdsCameraListRef;       // List of existing EOS cameras
   
    CameraString : string;
    CameraInt    : EdsUInt32;

    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;

    function Connect: boolean;
    function DisConnect: boolean;
    function EnableConnection: EdsUInt32;
    function SaveSetting: EdsError;

    { interface procedure and function }
    function setPropertyInt( id : EdsPropertyID; value : EdsUInt32): EdsError;
    function setPropertyStr( id : EdsPropertyID; value : string): EdsError;
    function getProperty( id : EdsPropertyID ): EdsUInt32;

    procedure setPropertyUInt32( id : EdsPropertyID; value : EdsUInt32 );
    function  getPropertyUInt32( id : EdsPropertyID ): EdsUInt32;
    procedure setPropertyString( id : EdsPropertyID ; const str : PAnsiChar );
    procedure getPropertyString( id : EdsPropertyID ; var str : PAnsiChar );

    function  GetCamaraPropertyDesc(id: EdsPropertyID): EdsPropertyDesc;
    procedure SetCameraPropertyDesc(id: EdsPropertyID; desc: EdsPropertyDesc);
    function  getPropertyDesc( id: EdsPropertyID ) : EdsError;

    function findAeModePropIndex(value: EdsUInt32): integer;
    function findAvPropIndex(value: EdsUInt32): integer;
    function findIsoPropIndex(value: EdsUInt32): integer;
    function findTvPropIndex(value: EdsUInt32): integer;
    function findWBPropIndex(value: EdsUInt32): integer;

    function  FindISOID(sISO: string; var data: EdsUInt32): boolean;
    function  FindISOStr(data: EdsUInt32; var sISO: string): boolean;
    function  FindTvID(sTv: string; var data: EdsUInt32): boolean;
    function  FindWBID(sWB: string; var data: EdsUInt32): boolean;
    function  FindWBStr(data: EdsUInt32; var sWB: string): boolean;
    function  FindQualiyID(sQ: string; var data: EdsUInt32): boolean;
    function  FindQualityStr(data: EdsUInt32; var sQ: string): boolean;

    function  GetAEModeList: TStrings;
    function  GetTvList: TStrings;
    function  GetAvList: TStrings;
    function  GetISOList: TStrings;
    function  GetQualityList: TStrings;
    function  GetWBList: TStrings;

    function  GetTime: TDateTime;
    function  SetTime( sTime: TDateTime ): EdsError;
    function  GetISO: string;
    function  SetISO( sISO: string ): EdsError;
    function  GetTv: string;
    function  SetTv( sTv: string ): EdsError;
    function  GetWB: string;
    function  SetWB( sWB: string ): EdsError;
    function  GetQuality: string;
    function  SetQuality( sQ: string ): EdsError;

    function  TakePicture : EdsError;   // Take one picture
      // Take series of pictures by Expositions parameters
    function  TakePictureSeries: EdsError; overload;
    function  TakePictureSeries(fName: string; PicCount: integer;
              BeginNumber, DelaySec_: integer): EdsError; overload;
    function  getImageData(itemRef: EdsDirectoryItemRef;
                                    targetPath, FName: string): EdsError;
    property  PictureStatus: TPictureStatus read FTPictureStatus write SetTPictureStatus;

    property  fLegacy : Bool read FIsLegacy;

  published
    { capture parameter }
    property  AEMode         :EdsUInt32 read FAeMode write FAeMode;
    property  Av             :EdsUInt32 read FAv write FAv;
    property  Tv             :EdsUInt32 read FTv write FTv;
    property  Iso            :EdsUInt32 read FIso write FIso;
    property  WB             :EdsUInt32 read FWB write FWB;
    property  BatteryLevel   :EdsUInt32 read FBatteryLevel write FBatteryLevel;
    property  JpegQuality    :EdsUInt32 read FJpegQuality write FJpegQuality;

    property AutoSave    : boolean read FAutoSave write SetAutoSave;
    property IsConnect   : boolean read FIsConnect write SetIsConnect;
    property FilePath    : string  read FSavePath write SetSavePath;
    property FileName    : string  read FFileName write SetFileName;
    property NewFile     : string  read FNewFile write SetNewFile;
    property FileNameProc: TFileNameProc read FFileNameProc write FFileNameProc;
    property CameraCount : integer read GetCameraCount;
    property CameraName  : string  read getModelName;
    property Expositions : TExpositions    read FExpositions write SetExpositions;
    property StartCounter : word read FStartCounter write FStartCounter;
    property ImageCount  : integer read FImageCount write SetImageCount;
    property DelaySec    : integer read FDelaySec write FDelaySec;
    property OnConnect   : TConnectEvent   read FOnConnect write FOnConnect;
    property OnNewFile   : TNewFileEvent   read FOnNewFile write FOnNewFile;
    property OnChangeParams: TNotifyEvent  read FOnChangeParams write FOnChangeParams;
    property OnProgress  : TProgressEvent  read FOnProgrees write FOnProgrees;
    property OnAfterDownload: TNotifyEvent read FOnAfterDownload write FOnAfterDownload;
    property OnPictureSeries: TPictureSeriesEvent read FOnPictureSeries
                            write FOnPictureSeries;
  end;

Var
    p_cam : ^TCanon;
   _SavePath, _NewFile : string;


  {      all available camera setting       }
  { ----------------------------------------}
  { This sampel uses the following property }
  const AeModeProp : array[ 0..16 ] of TPropList = (
    ( PropStr: 'P' ; PropID: 0 ),
    ( PropStr: 'Tv' ; PropID: 1 ),
    ( PropStr: 'Av' ; PropID: 2 ),
    ( PropStr: 'M' ; PropID: 3 ),
    ( PropStr: 'Bulb' ; PropID: 4 ),
    ( PropStr: 'A-DEP' ; PropID: 5 ),
    ( PropStr: 'DEP' ; PropID: 6 ),
    ( PropStr: 'C' ; PropID: 7 ),
    ( PropStr: 'Lock' ; PropID: 8 ),
    ( PropStr: 'Green Mode' ; PropID: 9 ),
    ( PropStr: 'Night Portrait' ; PropID: 10 ),
    ( PropStr: 'Sports' ; PropID: 11 ),
    ( PropStr: 'Portrait' ; PropID: 12 ),
    ( PropStr: 'Landscape' ; PropID: 13 ),
    ( PropStr: 'Close Up' ; PropID: 14 ),
    ( PropStr: 'Disable Strobe' ; PropID: 15 ),
    ( PropStr: 'Unknown' ; PropID: $FFFFFFFF )
  );

  const AvProp : array[ 0..53] of TPropList = (
    ( PropStr: '1.0'; PropID: $08 ), ( PropStr: '1.1'; PropID: $0B ), ( PropStr: '1.2'; PropID: $0C ),
    ( PropStr: '1.2'; PropID: $0D ), ( PropStr: '1.4'; PropID: $10 ), ( PropStr: '1.6'; PropID: $13 ),
    ( PropStr: '1.8'; PropID: $14 ), ( PropStr: '1.8'; PropID: $15 ), ( PropStr: '2.0'; PropID: $18 ),
    ( PropStr: '2.2'; PropID: $1B ), ( PropStr: '2.5'; PropID: $1C ), ( PropStr: '2.5'; PropID: $1D ),
    ( PropStr: '2.8'; PropID: $20 ), ( PropStr: '3.2'; PropID: $23 ), ( PropStr: '3.5'; PropID: $24 ),
    ( PropStr: '3.5'; PropID: $25 ), ( PropStr: '4'  ; PropID: $28 ), ( PropStr: '4';   PropID: $2B ),
    ( PropStr: '4.5'; PropID: $2C ), ( PropStr: '5'  ; PropID: $2D ), ( PropStr: '5.6'; PropID: $30 ),
    ( PropStr: '6.3'; PropID: $33 ), ( PropStr: '6.7'; PropID: $34 ), ( PropStr: '7.1'; PropID: $35 ),
    ( PropStr: '8'  ; PropID: $38 ), ( PropStr: '9'  ; PropID: $3B ), ( PropStr: '9.5'; PropID: $3C ),
    ( PropStr: '10';  PropID: $3D ), ( PropStr: '11';  PropID: $40 ), ( PropStr: '13';  PropID: $43 ),
    ( PropStr: '13';  PropID: $44 ), ( PropStr: '14';  PropID: $45 ), ( PropStr: '16';  PropID: $48 ),
    ( PropStr: '18';  PropID: $4B ), ( PropStr: '19';  PropID: $4C ), ( PropStr: '20';  PropID: $4D ),
    ( PropStr: '22';  PropID: $50 ), ( PropStr: '25';  PropID: $53 ), ( PropStr: '27';  PropID: $54 ),
    ( PropStr: '29';  PropID: $55 ), ( PropStr: '32';  PropID: $58 ), ( PropStr: '36';  PropID: $5B ),
    ( PropStr: '38';  PropID: $5C ), ( PropStr: '40';  PropID: $5D ), ( PropStr: '45';  PropID: $60 ),
    ( PropStr: '51';  PropID: $63 ), ( PropStr: '54';  PropID: $64 ), ( PropStr: '57';  PropID: $65 ),
    ( PropStr: '64';  PropID: $68 ), ( PropStr: '72';  PropID: $6B ), ( PropStr: '76';  PropID: $6C ),
    ( PropStr: '80';  PropID: $6D ), ( PropStr: '91';  PropID: $70 ), ( PropStr: 'Unknown'; PropID: $FFFFFFFF )
  );

  const TvProp : array[ 0.. 74] of TPropList = (
    ( PropStr:'Bulb'; PropID: $0C ), ( PropStr:'30"'; PropID: $10 ), ( PropStr:'25"'; PropID: $13 ),
    ( PropStr:'20"';  PropID: $14 ), ( PropStr:'20"'; PropID: $15 ), ( PropStr:'15"'; PropID: $18 ),
    ( PropStr:'13"';  PropID: $1B ), ( PropStr:'10"'; PropID: $1C ), ( PropStr:'10"'; PropID: $1D ),
    ( PropStr:' 8"';  PropID: $20 ), ( PropStr:'6"' ; PropID: $23 ), ( PropStr:'6"' ; PropID: $24 ),
    ( PropStr:'5"';   PropID: $25 ), ( PropStr:'4"' ; PropID: $28 ), ( PropStr:'3"2'; PropID: $2B ),
    ( PropStr:'3"';   PropID: $2C ), ( PropStr:'2"5'; PropID: $2D ), ( PropStr:'2"' ; PropID: $30 ),
    ( PropStr:'1"6';  PropID: $33 ), ( PropStr:'1"5'; PropID: $34 ), ( PropStr:'1"3'; PropID: $35 ),
    ( PropStr:'1"';   PropID: $38 ), ( PropStr:'0"8'; PropID: $3B ), ( PropStr:'0"7'; PropID: $3C ),
    ( PropStr:'0"6';  PropID: $3D ), ( PropStr:'0"5'; PropID: $40 ), ( PropStr:'0"4'; PropID: $43 ),
    ( PropStr:'0"3';  PropID: $44 ), ( PropStr:'0"3'; PropID: $45 ), ( PropStr:'4';   PropID: $48 ),
    ( PropStr:'5';    PropID: $4B ), ( PropStr:'6';   PropID: $4C ), ( PropStr:'6';   PropID: $4D ),
    ( PropStr:'8';    PropID: $50 ), ( PropStr:'10';  PropID: $53 ), ( PropStr:'10';  PropID: $54 ),
    ( PropStr:'13';   PropID: $55 ), ( PropStr:'15';  PropID: $58 ), ( PropStr:'20';  PropID: $5B ),
    ( PropStr:'20';   PropID: $5C ), ( PropStr:'25';  PropID: $5D ), ( PropStr:'30';  PropID: $60 ),
    ( PropStr:'40';   PropID: $63 ), ( PropStr:'45';  PropID: $64 ), ( PropStr:'50';  PropID: $65 ),
    ( PropStr:'60';   PropID: $68 ), ( PropStr:'80';  PropID: $6B ), ( PropStr:'90';  PropID: $6C ),
    ( PropStr:'100';  PropID: $6D ), ( PropStr:'125'; PropID: $70 ), ( PropStr:'160'; PropID: $73 ),
    ( PropStr:'180';  PropID: $74 ), ( PropStr:'200'; PropID: $75 ), ( PropStr:'250'; PropID: $78 ),
    ( PropStr:'320';  PropID: $7B ), ( PropStr:'350'; PropID: $7C ), ( PropStr:'400'; PropID: $7D ),
    ( PropStr:'500';  PropID: $80 ), ( PropStr:'640'; PropID: $83 ), ( PropStr:'750'; PropID: $84 ),
    ( PropStr:'800';  PropID: $85 ), ( PropStr:'1000';PropID: $88 ), ( PropStr:'1250';PropID: $8B ),
    ( PropStr:'1500'; PropID: $8C ), ( PropStr:'1600';PropID: $8D ), ( PropStr:'2000';PropID: $90 ),
    ( PropStr:'2500'; PropID: $93 ), ( PropStr:'3000';PropID: $94 ), ( PropStr:'3200';PropID: $95 ),
    ( PropStr:'4000'; PropID: $98 ), ( PropStr:'5000';PropID: $9B ), ( PropStr:'6000';PropID: $9C ),
    ( PropStr:'6400'; PropID: $9D ), ( PropStr:'8000';PropID: $A0 ), ( PropStr:'Unknown'; PropID: $FFFFFFFF )
  );

  const IsoProp : array[0..19 ] of TPropList = (
    ( PropStr: '6'   ; PropID: $28 ),
    ( PropStr: '12'  ; PropID: $30 ),
    ( PropStr: '25'  ; PropID: $38 ),
    ( PropStr: '50'  ; PropID: $40 ),
    ( PropStr: '100' ; PropID: $48 ),
    ( PropStr: '125' ; PropID: $4B ),
    ( PropStr: '160' ; PropID: $4D ),
    ( PropStr: '200' ; PropID: $50 ),
    ( PropStr: '250' ; PropID: $53 ),
    ( PropStr: '320' ; PropID: $55 ),
    ( PropStr: '400' ; PropID: $58 ),
    ( PropStr: '500' ; PropID: $5B ),
    ( PropStr: '640' ; PropID: $5D ),
    ( PropStr: '800' ; PropID: $60 ),
    ( PropStr: '1000' ; PropID: $63 ),
    ( PropStr: '1250' ; PropID: $65 ),
    ( PropStr: '1600' ; PropID: $68 ),
    ( PropStr: '3200' ; PropID: $70 ),
    ( PropStr: '6400' ; PropID: $78 ),
    ( PropStr: 'Unknown' ; PropID: $FFFFFFFF )
  );

  const ImageTypeProp : array[0..4 ] of TPropList = (
    ( PropStr: 'UnKnown'    ; PropID: 0 ),
    ( PropStr: 'Jpeg'       ; PropID: 1 ),
    ( PropStr: 'CRW'        ; PropID: 2 ),
    ( PropStr: 'RAW'        ; PropID: 4 ),
    ( PropStr: 'CR2'        ; PropID: 6 )
  );

  const ImageSizeProp : array[0..5 ] of TPropList = (
    ( PropStr: 'Large'    ; PropID: 0 ),
    ( PropStr: 'Middle'   ; PropID: 1 ),
    ( PropStr: 'Small'    ; PropID: 2 ),
    ( PropStr: 'Middle1'  ; PropID: 5 ),
    ( PropStr: 'Middle2'  ; PropID: 6 ),
    ( PropStr: 'UnKnown'  ; PropID: $FFFFFFFF )
  );

  const ImageQualityProp : array[0..4 ] of TPropList = (
    ( PropStr: 'Normal'   ; PropID: 2 ),
    ( PropStr: 'Fine'     ; PropID: 3 ),
    ( PropStr: 'Lossless' ; PropID: 4 ),
    ( PropStr: 'SuperFine'; PropID: 5 ),
    ( PropStr: 'UnKnown'  ; PropID: $FFFFFFFF )
  );

  // White ballance
  const WBProp : array[0..12 ] of TPropList = (
    ( PropStr: 'Auto'       ; PropID: 0 ),
    ( PropStr: 'Daylight'   ; PropID: 1 ),
    ( PropStr: 'Cloudy'     ; PropID: 2 ),
    ( PropStr: 'Tangsten'   ; PropID: 3 ),
    ( PropStr: 'Fluorescent'; PropID: 4 ),
    ( PropStr: 'Strobe'     ; PropID: 5 ),
    ( PropStr: 'WhitePaper' ; PropID: 6 ),
    ( PropStr: 'Shade'      ; PropID: 7 ),
    ( PropStr: 'ColorTemp'  ; PropID: 8 ),
    ( PropStr: 'PCSet1'     ; PropID: 9 ),
    ( PropStr: 'PCSet2'     ; PropID: 10 ),
    ( PropStr: 'PCSet3'     ; PropID: 11 ),
    ( PropStr: 'Pasted'     ; PropID: 12 )
  );

  // Image quality in the menu Quality
  const QualityProp : array[0..7 ] of TPropList = (
    ( PropStr: 'hL'         ; PropID: $00130F0F ),
    ( PropStr: 'lL'         ; PropID: $00120F0F ),
    ( PropStr: 'hM'         ; PropID: $01130F0F ),
    ( PropStr: 'lM'         ; PropID: $01120F0F ),
    ( PropStr: 'hS'         ; PropID: $02130F0F ),
    ( PropStr: 'lS'         ; PropID: $02120F0F ),
    ( PropStr: 'RAW+L'      ; PropID: $00640013 ),
    ( PropStr: 'RAW'        ; PropID: $00640F0F )
  );

procedure Register;

// {$INCLUDE STAF_Canon.inc}

implementation

procedure Register;
begin
  RegisterComponents('AL', [TCanon]);
end;

{==============================================================================}
{                         E V E N T    H A N D L E R
{==============================================================================}

{ Propery event handler }
function handlePropertyEvent( inEvent : EdsUInt32;
                                inPropertyID : EdsUInt32;
                                inParam : EdsUInt32;
                                inContext : EdsUInt32 ) : EdsError; stdcall;
begin
  case inEvent of
    kEdsPropertyEvent_PropertyChanged :
      begin
        case inPropertyID of
          kEdsPropID_AEMode   : p_cam^.AEMode := inParam;
          kEdsPropID_ISOSpeed : p_cam^.ISO    := inParam;
          kEdsPropID_Av       : p_cam^.Av     := inParam;
          kEdsPropID_Tv       : p_cam^.Tv     := inParam;
          kEdsPropID_WhiteBalance : p_cam^.WB := inParam;
         end;
         If Assigned(p_cam^.FOnChangeParams) then p_cam^.FOnChangeParams(p_cam^);
         PostMessage( HWND(inContext), WM_USER+1 , integer(inEvent) , integer(inPropertyID) );
      end;

    kEdsPropertyEvent_PropertyDescChanged :
      begin
        case inPropertyID of
          kEdsPropID_AEMode,
          kEdsPropID_ISOSpeed,
          kEdsPropID_Av,
          kEdsPropID_Tv,
          kEdsPropID_WhiteBalance,
          kEdsPropID_ImageQuality:
            PostMessage( HWND(inContext) , WM_USER+1 , integer(inEvent) , integer(inPropertyID) );
        end;
      end;
  end;
  Result := EDS_ERR_OK;
end;


{ Object event handler }
function handleObjectEvent( inEvent : EdsUInt32;
                            inRef : EdsBaseRef;
                            inContext : EdsUInt32 ) : EdsError; stdcall;
var err : EdsError;
begin
  case inEvent of
    kEdsObjectEvent_DirItemRequestTransfer :
    begin
      if p_cam^.AutoSave then
         err:= p_cam^.getImageData( inRef, p_cam^.FilePath, '' );
      PostMessage( HWND(inContext), WM_USER+2 , integer(inEvent) , integer(inRef) );
    end;
  end;
  Result := EDS_ERR_OK;
end;


{ Progress callback function }
function ProgressFunc( inPercent : EdsUInt32;
                       inContext : EdsUInt32;
                       var outCancel : EdsBool ) : EdsError; stdcall;
begin
  If Assigned(p_cam^.FOnProgrees) then
     p_cam^.FOnProgrees(p_cam^,inPercent);
  PostMessage( HWND(inContext) , WM_USER+3 , integer(inPercent) , integer( outCancel ) );
  Result := EDS_ERR_OK;
end;


function HandleStateEvent(inEvent: EdsStateEvent;
                          inEventData: EdsUInt32;
                          inContext: EdsUInt32): EdsError; stdcall;
var
  t: TMsgDlgType;
  s: string;
begin
  Result:=EDS_ERR_OK;
  s:=''; t:=mtError;
  case inEvent of
   kEdsStateEvent_Shutdown:
     begin s:='Camera disconnected.';
           p_cam^.IsConnect:=False;
//     EOSCamRelease;
     end;
//   kEdsStateEvent_JobStatusChanged:
   kEdsStateEvent_WillSoonShutDown:
     begin s:=Format('The camera will shutdown in %d seconds.', [inEventData]);
           t:=mtWarning;
     end;
   kEdsCameraEvent_ShutDownTimerUpdate:       //  = $00000304;
     begin s:='The camera connected.';
           p_cam^.IsConnect:=True;
           t:=mtWarning;
     end;
   kEdsCameraEvent_CaptureError:
     begin s:='Capture error '+IntToStr(inEventData);
//     GlobalUILock:=GlobalUILock and not (EdsSendStatusCommand(EOSCam, kEdsCameraStatusCommand_UIUnLock, 0)=EDS_ERR_OK);
     end;
   kEdsCameraEvent_InternalError:
     begin s:='Internal EOS SDK error.';
//     EOSCamRelease;
//     CanonForm.ShowNoCamera;
     end;
   end;
   if s<>'' then
      PostMessage( HWND(inContext), WM_USER+4 , integer(inEvent) ,integer(inEventData)  );

//   kEdsStateEvent_AfResult                     = $00000309;
//   kEdsStateEvent_BulbExposureTime             = $00000310;

end;

{ TFileNameProc }

constructor TFileNameProc.Create;
begin
  inherited;
  FPrefix       := 'Canon';
  FBlank        := '_';
  FUserTag      := '';
  FStartCounter := 1;
  FlPrefix   := True;
  FlDate     := False;
  FlTime     := False;
  FlUserTag  := False;
  FlCount    := True;
  FOverWrite := False;
end;

function TFileNameProc.GetFileName: string;
var sr: TSearchRec;
    f,f1: string;
    r,nomax,no: integer;

    function GetCounter(fn:string): integer;
    // if found then Result=counter else -1;
    var ff,co: string;
        ld   : integer;
    begin
      Result := -1;
      ld := LastDelimiter('.',fn);
      if ld>0 then
         ff := Copy(fn,1,ld-1);
      ld := LastDelimiter(FBlank,ff);
      if ld>0 then begin
         co := Copy(ff,ld+1,1000);
         Try
           Result := StrToInt(co);
         except
           exit;
         end;
      end;
    end;

    {  Replicate = egy karekter megsokszorozása  }
    Function Replicate( kar : String; szor : Integer ):String;
    Var	i	: Integer;
	      r	: String;
    begin
	       r := '';
	       For i:=1 to szor do r := r + kar;
	       Replicate := r;
    end;

    { Zeronum	= Egy num. értéket bevezetõ '0'-kal stringgé alakit }
    Function ZeroNum( sz,hosz : Word ):String;
    Var	s	: String;
    begin
	       Str( sz,s );
	       ZeroNum := Replicate( '0',hosz-Length(s)) + s;
    end;

    function NowUTC: TDateTime;
    Var UTC: TSystemTime;
    begin
         GetSystemTime(UTC);
         Result := SystemTimeToDateTime(UTC);
    end;

begin
  f := '';
  if not OverWrite then begin
     if lPrefix then
        f := FFilePath+FPrefix+'*.*'
     else
        f := FFilePath+'*.*';
     r := FindFirst(f,faAnyFile,sr);
     nomax:=-1;
     no := GetCounter(sr.Name);
     While r=0 do begin
           if no>nomax then nomax:=no;
           r := FindNext(sr);
           no := GetCounter(sr.Name);
     end;
     FindClose(sr);
     f:=FFilePath+FPrefix+FBlank+ZeroNum(StartCounter,3)+extension;
     if nomax>-1 then begin
        if FileExists(f) then begin
              StartCounter := nomax+1;
        if extension='.JPG' then begin
           f1:=FFilePath+FPrefix+FBlank+ZeroNum(StartCounter,3)+'.CR2';
           f:=FFilePath+FPrefix+FBlank+ZeroNum(StartCounter,3)+'.JPG';
           if FileExists(f1) and (not FileExists(f)) then
              StartCounter := StartCounter-1;
        end;
        end;
     end;

     FlCount := True;
     if FlPrefix  then begin
        f := FPrefix;
     end;
     if FlDate    then f := f+FBlank+FormatDateTime('yy-mm-dd',now);
     if FlTime    then
     begin
        f := f+FBlank+FormatDateTime('hhnnss',now);
     end;
     if FlJD      then
     begin
        f := f+FBlank+'JD'+Format('%6.5f',[DateTimeToJulianDate(Now)]);
        FlCount := False;
     end;
     if FlUserTag then f := f+FBlank+UserTag;
     if FlCount   then f := f+FBlank+ZeroNum(StartCounter,3);
     Result := FFilePath+f+extension;
  end;
end;

procedure TFileNameProc.SetFilePath(const Value: string);
begin
  FFilePath := IncludeTrailingPathDelimiter(Value);
end;

procedure TFileNameProc.SetBlank(const Value: string);
const defaultBlank : string = '_';
      validBlank   : string = ' -=().*';
begin
  if Pos(Value,validBlank)>0 then
     FBlank := validBlank[Pos(Value,validBlank)]
  else
     FBlank := '_';
end;


{ TCanon }
// =======================================================================

constructor TCanon.Create(AOwner:TComponent);
var err : EdsError;
    count : EdsUInt32;
    deviceInfo : EdsDeviceInfo;
begin
  inherited;
  { load EDSDk and initialize }
  err := EdsInitializeSDK;
  if err = EDS_ERR_OK then
    FIsSDKLoaded := true
  else
    FIsSDKLoaded := False;
  FhWnd         := TWinControl(AOwner).Handle;
  FIsConnect    := false;
  FIsSDKLoaded  := false;
  cameraList    := nil;
  count         := 0;
  FSavePath     := ExtractFilePath(Application.ExeName);
  FNewFile      := '';
  FFileName     := 'CANON_';
  FAutoSave     := True;
  oldCameraCount:= 0;
  FileNameProc  := TFileNameProc.Create;
  stateTimer    := TTimer.Create(Self);
  stateTimer.Enabled := False;
  stateTimer.Interval := 5000;
  stateTimer.OnTimer := OnTimer;
  Ora                := TTimer.Create(nil);
  Ora.OnTimer        := OnOra;
  New(p_cam);
  p_cam^ := Self;    // For external callback funtions
  Connect;
end;

destructor TCanon.Destroy;
begin
  stateTimer.OnTimer := nil;
  stateTimer.Free;
  FileNameProc.Free;
  { release camera list object }
  if cameraList <> nil then
     EdsRelease( cameraList );
  if FIsSDKLoaded then begin
    { disconnect camera }
    if FIsConnect then
      EdsCloseSession( Camera );
    EdsTerminateSDK;
  end;
  inherited;
end;

function TCanon.Connect: boolean;
var err : EdsError;
    cameraList  : EdsCameraListRef;
    count : EdsUInt32;
begin
Try
  Result := False;

  { get list of camera }
  err := EdsGetCameraList( cameraList );

  { get number of camera }
  if err = EDS_ERR_OK then begin
    err := EdsGetChildCount( cameraList , count );
    if count = 0 then begin
//      EdsRelease( camera );
      IsConnect := False;
      Exit;
    end;

  { get first camera }
  if err = EDS_ERR_OK then
    EdsGetChildAtIndex( cameraList , 0 , Camera );

  if Camera <> nil then begin
    err := EdsGetDeviceInfo( Camera , deviceInfo );
    if err = EDS_ERR_OK then begin
//      EdsRetain(camera);
      if deviceInfo.deviceSubType = 0 then
        FIsLegacy := true
      else
        FIsLegacy := false;{ new type camera! }
    end;
    enableConnection;
    setEventCallback;
    saveSetting;
    IsConnect := True;
    Result := True;
  end;
  end;
except
  IsConnect := False;
end;
end;

{-------------------------------------------}
{ process of logical connection with camera }
{-------------------------------------------}
function TCanon.enableConnection: EdsUInt32;
var err : EdsError;
    saveTo : EdsUInt32;
    fLock  : Bool;
    capacity : EdsCapacity;
begin
  fLock := false;
  FIsConnect := false;

  { Open session with the connected camera }
  err := EdsOpenSession( camera );
  if err = EDS_ERR_OK then
    FIsConnect := true;

	 if FIsLegacy = true then begin

	   {Preservation ahead is set to PC}
	   if err = EDS_ERR_OK then begin
  	   saveTo := EdsUInt32(kEdsSaveTo_Host); { save to Host drive ! }
      err := EdsSetPropertyData( camera, kEdsPropID_SaveTo, 0, Sizeof(saveTo), @saveTo );
    end;
  end else begin
		 {Preservation ahead is set to PC}
		 if err = EDS_ERR_OK then begin
  	   saveTo := EdsUInt32(kEdsSaveTo_Host); { save to Host drive ! }
      err := EdsSetPropertyData( camera, kEdsPropID_SaveTo, 0, Sizeof(saveTo), @saveTo );
    end;

	 	 { UI lock }
	   if err = EDS_ERR_OK then
      err := EdsSendStatusCommand(camera, kEdsCameraState_UILock, 0);

		 if err = EDS_ERR_OK then
      fLock := true;

		 if err = EDS_ERR_OK then begin
      capacity.numberOfFreeClusters := EdsInt32($7FFFFFFF);
		   capacity.bytesPerSector := EdsInt32($1000);
		   capacity.reset := EdsInt32(1);

		   err := EdsSetCapacity( camera, capacity);
  	 end;

		 { It releases it when locked }
		 if fLock = true  then
      EdsSendStatusCommand(camera, kEdsCameraState_UIUnLock, 0);

	 end;
  Result := err;

end;

{-------------------------------------}
{ set file saving location at capture }
{-------------------------------------}
function TCanon.saveSetting: EdsError;
var err : EdsError;
    fLock  : Bool;
    saveTo : EdsUInt32;
begin
  err := EDS_ERR_OK;
  fLock := false;

  if camera = nil then begin
    Result := err;
    Exit;
  end;

  { For cameras earlier than the 30D, the camera UI must be
    locked before commands are issued. }
  if fLegacy = true then begin
    err := EdsSendStatusCommand( camera, kEdsCameraState_UILock, 0 );
    if err = EDS_ERR_OK then
      fLock := true;

  end;

  saveTo := EdsUInt32(kEdsSaveTo_Host); { save to Host drive ! }
  if err = EDS_ERR_OK then
    err := EdsSetPropertyData( camera, kEdsPropID_SaveTo, 0, Sizeof(saveTo), @saveTo );

  if err = EDS_ERR_OK then begin
    if fLock = true then
      err := EdsSendStatusCommand( camera, kEdsCameraState_UIUnLock, 0 );
  end;

  Result := err;
end;

function TCanon.SetEventCallBack: EdsError;
var err : EdsError;
begin
  err := EDS_ERR_OK;
  if Camera = nil then begin
    Result := err;
    Exit;
  end;

  { register property event handler & object event handler }
  err := EdsSetPropertyEventHandler( camera, kEdsPropertyEvent_All, @handlePropertyEvent, FhWnd );

  if err = EDS_ERR_OK then
    err := EdsSetObjectEventHandler( camera, kEdsObjectEvent_All, @handleObjectEvent, FhWnd );

  if err = EDS_ERR_OK then
     err := EdsSetCameraStateEventHandler(camera, kEdsStateEvent_All, @HandleStateEvent, FhWnd);

  if err = EDS_ERR_OK then
     err := EdsSetProgressCallback(camera, @ProgressFunc, kEdsProgressOption_Periodically, FhWnd);

  Result := err;
end;

procedure TCanon.SetExpositions(const Value: TExpositions);
begin
  FExpositions := Value;
end;

function TCanon.GetModelName: string;
var buffer : PAnsiChar;
begin
  GetMem( buffer,Length( DeviceInfo.szDeviceDescription ) );
  StrCopy( buffer, DeviceInfo.szDeviceDescription );
  IF FIsConnect then
     Result := buffer
  else
     Result := 'No Camera Detected!';
  FreeMem( buffer );
end;

procedure TCanon.getPropertyString(id: EdsPropertyID; var str: PAnsiChar);
begin
  Case id of
    kEdsPropID_ProductName: StrCopy( FModelName, str );
  end;
end;

procedure TCanon.setPropertyString(id: EdsPropertyID; const str: PAnsiChar);
begin
  Case id of
    kEdsPropID_ProductName: StrCopy( FModelName, str );
  end;
end;

function TCanon.GetCamaraPropertyDesc(id: EdsPropertyID): EdsPropertyDesc;
var desc : EdsPropertyDesc;
begin
  getPropertyDesc(id);
  desc.form := 0;
  desc.access := kEdsAccess_Read;
  desc.numElements := 0;

  Case id of
    kEdsPropID_AEMode      : desc := FAeModeDesc;
    kEdsPropID_Tv          : desc := FTvDesc;
    kEdsPropID_Av          : desc := FAvDesc;
    kEdsPropID_ISOSpeed    : desc := FIsoDesc;
    kEdsPropID_BatteryLevel: desc := FBatteryLevelDesc;
    kEdsPropID_JpegQuality : desc := FJpegQualityDesc;
    kEdsPropID_WhiteBalance: desc := FWBDesc;
  end;
  Result := desc;
end;

procedure TCanon.setCameraPropertyDesc(id: EdsPropertyID; desc: EdsPropertyDesc);
begin
  Case id of
    kEdsPropID_AEMode        : FAeModeDesc := desc;
    kEdsPropID_Tv            : FtvDesc := desc;
    kEdsPropID_Av            : FAvDesc := desc;
    kEdsPropID_ISOSpeed      : FIsoDesc := desc;
    kEdsPropID_BatteryLevel  : FBatteryLevelDesc := desc;
    kEdsPropID_JpegQuality   : FJpegQualityDesc := desc;
    kEdsPropID_WhiteBalance  : FWBDesc := desc;
  end;
end;

function TCanon.GetPropertyUInt32(id: EdsPropertyID): EdsUInt32;
var value : EdsUInt32;
begin
  value := $ffffffff;
  Case id of
    kEdsPropID_AEMode        : value := FAeMode;
    kEdsPropID_Tv            : value := FTv;
    kEdsPropID_Av            : value := FAv;
    kEdsPropID_ISOSpeed      : value := FIso;
    kEdsPropID_BatteryLevel  : Value := FBatteryLevel;
    kEdsPropID_JpegQuality   : Value := FJpegQuality;
    kEdsPropID_WhiteBalance  : Value := FWB;
  end;
  Result := value;
end;

function TCanon.getPropertyDesc(id: EdsPropertyID): EdsError;
var err : EdsError;
    desc : EdsPropertyDesc;
begin
  { if property id is invalid value (kEdsPropID_Unknown),
    EDSDK cannot identify the changed property.
    So, we must retrieve the required property again.  }
  if id = kEdsPropID_Unknown then begin
    err := getPropertyDesc( kEdsPropID_AEMode );
    if err = EDS_ERR_OK then err := getPropertyDesc(kEdsPropID_Tv);
    if err = EDS_ERR_OK then err := getPropertyDesc(kEdsPropID_Av);
    if err = EDS_ERR_OK then err := getPropertyDesc(kEdsPropID_ISOSpeed );
    Result := err;
    Exit;
  end;

  err := EdsGetPropertyDesc( camera, id, desc );
  if err = EDS_ERR_OK then
    { set available list into TCamera object }
    SetCameraPropertyDesc( id, desc );

  Result := err;
end;

function TCanon.getTime: TDateTime;
var err : EdsError;
  dataSize : EdsUInt32;
  dataType : EdsUInt32;
  data : EdsTime;
  str : array [0..EDS_MAX_NAME-1] of EdsChar;
  P : Pointer;
begin
  err := EdsGetPropertySize( camera, kEdsPropID_DateTime, 0, dataType, dataSize );
  if err <> EDS_ERR_OK then begin
    Result := err;
    Exit;
  end;

    P := @data;
    err := EdsGetPropertyData( camera, kEdsPropID_DateTime, 0, dataSize, Pointer(P^) );
    if err=EDS_ERR_OK then begin
        Result := EncodeDate(data.year,data.Month,data.day)
                + EncodeTime(data.hour,data.Minute,data.second,data.millseconds);
    end;
end;

function TCanon.SetTime(sTime: TDateTime): EdsError;
var err : EdsError;
  dataSize : EdsUInt32;
  dataType : EdsUInt32;
  data : EdsTime;
  y,m,d,h,mm,s,ss: word;
begin
  err := EdsGetPropertySize( camera, kEdsPropID_DateTime, 0, dataType, dataSize );
  if err <> EDS_ERR_OK then begin
    Result := err;
    Exit;
  end;

    DecodeDate(sTime,y,m,d);
    DecodeTime(sTime,h,mm,s,ss);
    with data do begin
         year        := y;
         month       := m;
         day         := d;
         hour        := h;
         minute      := mm;
         second      := s;
         millseconds := ss;
    end;
    Result := EdsSetPropertyData( camera, kEdsPropID_DateTime, 0, dataSize, @data );
end;

procedure TCanon.SetPropertyUInt32(id: EdsPropertyID; value: EdsUInt32);
begin
  Case id of
    kEdsPropID_AEMode        : FAeMode       := value;
    kEdsPropID_Tv            : FTv           := value;
    kEdsPropID_Av            : FAv           := value;
    kEdsPropID_ISOSpeed      : FIso          := value;
    kEdsPropID_BatteryLevel  : FBatteryLevel := Value;
    kEdsPropID_JpegQuality   : FJpegQuality  := Value;
    kEdsPropID_WhiteBalance  : fWB           := Value;
  end;
end;

procedure TCanon.SetImageCount(const Value: integer);
begin
  FImageCount := Value;
  if Value=0 then PictureStatus:=psEnd;
end;

procedure TCanon.SetIsConnect(const Value: boolean);
begin
  FIsConnect := Value;
//  if Value then Connect;
  if Assigned(FOnConnect) then FOnConnect(Self,FIsConnect);
end;

function TCanon.DisConnect: boolean;
begin
Try
  if FIsConnect then
      EdsCloseSession( Camera );
finally
  IsConnect := False;
end;
end;

function TCanon.GetCameraCount: integer;
var err : EdsError;
    cameraList  : EdsCameraListRef;
    count : EdsUInt32;
begin
  Count := 0;
  err := EdsGetCameraList( cameraList );
  if err = EDS_ERR_OK then
    err := EdsGetChildCount( cameraList , Count );
  Result := Count;
end;

procedure TCanon.OnOra(Sender: TObject);
begin
    Case PictureStatus of
    psBegin:
      begin
        PictureStatus := psPicture;
      end;
    psSaved:
      begin
      end;
    psDelay:
      begin
        if DelaySec <= OraCounter then begin
           ImageCount   := ImageCount-1;
           StartCounter := StartCounter+1;
           if ImageCount>0 then
            PictureStatus := psPicture
           else
            PictureStatus := psEnd;
        end;
      end;
    end;
    if Assigned(FOnPictureSeries) then
      FOnPictureSeries(Self,FImageCount,FTPictureStatus,OraCounter);
    Inc(OraCounter);
end;

procedure TCanon.OnTimer(Sender: TObject);
begin
  if (CameraCount<>oldCameraCount) then begin
     IsConnect:=Connect;
     oldCameraCount := CameraCount;
  end;
end;

// Download Image from Canon and Save to file
function TCanon.GetImageData(itemRef: EdsDirectoryItemRef;
  targetPath, FName: string): EdsError;
var dirInfo : EdsDirectoryItemInfo;
    err : EdsError;
    stream : EdsStreamRef;
    tDir,ffName,Ext : Ansistring;
    fnCount: integer;

    function GetFileCounter(fn: Ansistring): integer;
    var cstr: string;
        i   : integer;
    begin
      Result := 0;
      cstr := '';
      for i:=Length(fn) downto 1 do begin
          if fn[i]= FileNameProc.Blank then exit;
          cstr := fn[i]+cstr;
      end;
      if cstr<>'' then Result := strtoint(cstr);
    end;

begin
  { get information of captured image }
  err := EdsGetDirectoryItemInfo( itemRef, dirInfo );
  if err <> EDS_ERR_OK then begin
    Result := err;
    Exit;
  end;

  Ext   := ExtractFileExt(string(dirInfo.szFileName));
  if FName='' then begin
     // Automatic filename by FileNameProc if FName is empty
     tDir   := IncludeTrailingPathDelimiter(FSavePath);
     FileNameProc.Extension := Ext;
     ffName := FileNameProc.FileName;
  end else
     ffName := ExtractFileName(FName)+ext;

  NewFile := ffName;

  { create file stream }
  stream := nil;
  if err = EDS_ERR_OK then
    err := EdsCreateFileStream( PChar(ffName), kEdsFileCreateDisposition_CreateAlways,
                               kEdsAccess_ReadWrite, stream );

  { set progress call back }
  if err = EDS_ERR_OK then
    err := EdsSetProgressCallback( stream, @ProgressFunc, kEdsProgressOption_Periodically, FhWnd );

  { download image data }
  if err = EDS_ERR_OK then
    err := EdsDownload( itemRef, dirInfo.size, stream );

  { completed trasnfer }
  if err = EDS_ERR_OK then begin
    err := EdsDownloadComplete( itemRef );
    NewFile := ffName;
  end else
    NewFile := 'Download error!';

  { free resource }
  if stream <> nil then begin
    EdsRelease( stream );
  end;

  EdsRelease( itemRef );

  PictureStatus := psSaved;
  if Assigned(FOnAfterDownload) then FOnAfterDownload(Self);
  Result := err;
end;

function TCanon.takePicture: EdsError;
var err : EdsError;
    fLock  : Bool;
begin

  fLock := True;
  err := EDS_ERR_OK;

  if camera = nil then begin
    PictureStatus := psNone;
    Result := err;
    Exit;
  end;

  { For cameras earlier than the 30D, the camera UI must be
    locked before commands are issued. }
  if not fLegacy then begin
    err := EdsSendStatusCommand( Camera, kEdsCameraState_UILock, 0 );
    if err = EDS_ERR_OK then
      fLock := true;
  end;

  if err = EDS_ERR_OK then
    err := EdsSendCommand( Camera, kEdsCameraCommand_TakePicture, 0 );

  if fLock = true then
    err := EdsSendStatusCommand( Camera, kEdsCameraState_UIUnLock, 0 );

  Result := err;
end;

function TCanon.TakePictureSeries: EdsError;
begin
  PictureStatus := psBegin;
end;

function TCanon.TakePictureSeries(fName: string; PicCount: integer;
              BeginNumber, DelaySec_: integer): EdsError;
var fn,ext: string;
begin
  FileNameProc.FilePath := ExtractFilePath(fName);
  fn := ExtractFileName(fName);
  FileNameProc.Extension := ExtractFileExt(fName);
  FileNameProc.Prefix := ChangeFileExt(fn,'');
  with Expositions do begin
    Series      := True;
    Count       := PicCount;
    Delay       := DelaySec_;
  end;
  ImageCount    := PicCount;
  StartCounter  := BeginNumber;
  DelaySec      := DelaySec_;
  PictureStatus := psBegin;
end;

procedure TCanon.SetTPictureStatus(const Value: TPictureStatus);
begin
  if FTPictureStatus <> Value then begin
    FTPictureStatus := Value;
    OraCounter := 0;
    Case FTPictureStatus of
    psNone:
      begin
      end;
    psBegin:
      begin
        Ora.Interval := 1000;
      end;
    psPicture:
      begin
        takePicture;
      end;
    psSaved:
      begin
        FTPictureStatus := psDelay;
      end;
    psDelay:
      begin
      end;
    psEnd:
      begin
        FTPictureStatus := psNone;
      end;
    end;
  end;
end;

procedure TCanon.SetNewFile(const Value: string);
begin
    FNewFile := Value;
    _NewFile := Value;
    if Assigned(FOnNewFile) then FOnNewFile(Self,Value);
end;

procedure TCanon.SetFileName(const Value: string);
begin
  FFileName := Value;
  FileNameProc.Prefix := Value;
  FileNameProc.lPrefix := not (Value='');
  FileNameProc.StartCounter:=1;
end;

procedure TCanon.SetSavePath(const Value: string);
begin
  if DirectoryExists(Value) then begin
     FSavePath := IncludeTrailingPathDelimiter(Value);
     _SavePath := FSavePath;
     FileNameProc.FilePath:=FSavePath;
  end;
end;

procedure TCanon.SetAutoSave(const Value: boolean);
begin
  FAutoSave := Value;
end;

function TCanon.getProperty(id: EdsPropertyID): EdsUInt32;
var err : EdsError;
  dataSize : EdsUInt32;
  dataType : EdsUInt32;
  data : EdsUInt32;
  str : array [0..EDS_MAX_NAME-1] of EdsChar;
  P : Pointer;
begin
  { if property id is invalid value (kEdsPropID_Unknown),
    EDSDK cannot identify the changed property.
    So, we must retrieve the required property again.  }
  if id = kEdsPropID_Unknown then begin
    err := getProperty( kEdsPropID_AEMode );
    if err = EDS_ERR_OK then err := getProperty(kEdsPropID_Tv);
    if err = EDS_ERR_OK then err := getProperty(kEdsPropID_Av);
    if err = EDS_ERR_OK then err := getProperty(kEdsPropID_ISOSpeed );
    Result := err;
    Exit;
  end;

  err := EdsGetPropertySize( camera, id, 0, dataType, dataSize );
  if err <> EDS_ERR_OK then begin
    Result := err;
    Exit;
  end;

  if (dataType in [3..11])
//   EdsUInt32(kEdsDataType_UInt32)
  then begin
    P := @data;
    err := EdsGetPropertyData( camera, id, 0, dataSize, Pointer(P^) );

    { set property data into TCamera }
    if err = EDS_ERR_OK then begin
      setPropertyUInt32( id, data );
      CameraInt := data;
    end;
  end;

  if dataType = EdsUInt32(kEdsDataType_String) then begin
    P := @str;
    err := EdsGetPropertyData( camera, id, 0, dataSize, Pointer(P^) );

    { set property string into TCamera }
    if err = EDS_ERR_OK then begin
      setPropertyString( id, str );
      CameraString := StrPas(str);
    end;

  end;
  Result := err;
end;

function TCanon.FindISOID(sISO: string; var data: EdsUInt32): boolean;
var i: integer;
begin
  Result := False;
  data := 0;
  for i:=0 to High(IsoProp) do
      if IsoProp[i].PropStr = sISO then begin
         data := IsoProp[i].PropID;
         Result := True;
      end;
end;

function TCanon.FindISOStr(data: EdsUInt32; var sISO: string): boolean;
var i: integer;
begin
  Result := False;
  for i:=0 to High(IsoProp) do
      if IsoProp[i].PropID = data then begin
         sISO := IsoProp[i].PropStr;
         Result := True;
      end;
end;

function TCanon.FindTvID(sTv: string; var data: EdsUInt32): boolean;
var i: integer;
begin
  Result := False;
  data := 0;
  for i:=0 to High(TvProp) do
      if TvProp[i].PropStr = sTv then begin
         data := TvProp[i].PropID;
         Result := True;
      end;
end;

function TCanon.FindWBID(sWB: string; var data: EdsUInt32): boolean;
var i: integer;
begin
  Result := False;
  data := 0;
  for i:=0 to High(WBProp) do
      if WBProp[i].PropStr = sWB then begin
         data := WBProp[i].PropID;
         Result := True;
      end;
end;

function TCanon.FindTvStr(data: EdsUInt32; var sTv: string): boolean;
var i: integer;
begin
  Result := False;
  for i:=0 to High(TvProp) do
      if TvProp[i].PropID = data then begin
         sTv := TvProp[i].PropStr;
         Result := True;
      end;
end;

function TCanon.FindWBStr(data: EdsUInt32; var sWB: string): boolean;
var i: integer;
begin
  Result := False;
  for i:=0 to High(WBProp) do
      if WBProp[i].PropID = data then begin
         sWB := WBProp[i].PropStr;
         Result := True;
      end;
end;

function TCanon.FindQualiyID(sQ: string; var data: EdsUInt32): boolean;
var i: integer;
begin
  Result := False;
  for i:=0 to High(QualityProp) do
      if QualityProp[i].PropStr = sQ then begin
         data := QualityProp[i].PropID;
         Result := True;
      end;
end;

function TCanon.FindQualityStr(data: EdsUInt32; var sQ: string): boolean;
var i: integer;
begin
  Result := False;
  for i:=0 to High(QualityProp) do
      if QualityProp[i].PropID = data then begin
         sQ := QualityProp[i].PropStr;
         Result := True;
      end;
end;


//---------------------------------------------------------------
{ process of find index number in TPropList array }
function TCanon.findAeModePropIndex(value: EdsUInt32): integer;
var i : integer;
begin
  Result := 16;
  for i := 0 to 16 do begin
    if AeModeProp[i].PropID = value then
      Result := i
  end;
end;

function TCanon.findAvPropIndex( value: EdsUInt32): integer;
var i : integer;
begin
  Result := 53;
  for i := 0 to 53 do begin
    if AvProp[i].PropID = value then
      Result := i
  end;
end;

function TCanon.findTvPropIndex(value: EdsUInt32): integer;
var i : integer;
begin
  Result := 74;
  for i := 0 to 74 do begin
    if TvProp[i].PropID = value then
      Result := i
  end;
end;

function TCanon.findIsoPropIndex(value: EdsUInt32): integer;
var i : integer;
begin
  Result := 19;
  for i := 0 to 19 do begin
    if IsoProp[i].PropID = value then
      Result := i;
  end;
end;

function TCanon.findWBPropIndex(value: EdsUInt32): integer;
var i : integer;
begin
  Result := 1;
  for i := 0 to 12 do begin
    if WBProp[i].PropID = value then
      Result := i;
  end;
end;

//-------------------------------------------------------------

function TCanon.setPropertyInt(id: EdsPropertyID; value: EdsUInt32): EdsError;
var data: EdsUInt32;
begin
  data := EdsUInt32(Value);
  Result := EdsSetPropertyData( camera, id, 0, sizeof( data ), @data );
  if Result = EDS_ERR_OK then
     setPropertyUInt32(id, data );
end;

function TCanon.setPropertyStr(id: EdsPropertyID; value: string): EdsError;
var data: string;
begin
  data := Value;
  Result := EdsSetPropertyData( camera, id, 0, sizeof( data ), @data );
  if Result = EDS_ERR_OK then
     setPropertyString(id, PAnsiChar(data));
end;

function TCanon.GetISOList: TStrings;
var desc : EdsPropertyDesc;
    i, j : integer;
    current, val  : EdsUInt32;
begin
  Result := TStringList.Create;
  desc := GetCamaraPropertyDesc( kEdsPropID_ISOSpeed );
     Result.Clear;
        { refill available ISO value }
        for i := 0  to desc.numElements -1 do begin
          val := desc.propDesc[i];
          j := findIsoPropIndex( val );
          Result.AddObject( IsoProp[j].PropStr, @IsoProp[j] );
        end;
end;

function TCanon.GetAEModeList: TStrings;
var desc : EdsPropertyDesc;
    i, j : integer;
    current, val  : EdsUInt32;
begin
  Result := TStringList.Create;
  desc := GetCamaraPropertyDesc( kEdsPropID_AEMode );
     Result.Clear;
        { refill available ISO value }
        for i := 0  to desc.numElements -1 do begin
          val := desc.propDesc[i];
          j := findAEModePropIndex( val );
          Result.AddObject( AeModeProp[j].PropStr, @AeModeProp[j] );
        end;
end;

function TCanon.GetAvList: TStrings;
var desc : EdsPropertyDesc;
    i, j : integer;
    current, val  : EdsUInt32;
begin
  Result := TStringList.Create;
  desc := GetCamaraPropertyDesc( kEdsPropID_Av );
     Result.Clear;
        { refill available ISO value }
        for i := 0  to desc.numElements -1 do begin
          val := desc.propDesc[i];
          j := findAvPropIndex( val );
          Result.AddObject( AvProp[j].PropStr, @AvProp[j] );
        end;
end;

function TCanon.GetQualityList: TStrings;
var i : integer;
begin
  Result := TStringList.Create;
  Result.Clear;
        { refill available ISO value }
        for i := 0  to High(QualityProp) do begin
          Result.AddObject( QualityProp[i].PropStr, @QualityProp[i] );
        end;
end;

function TCanon.GetTvList: TStrings;
var desc : EdsPropertyDesc;
    i, j : integer;
    current, val  : EdsUInt32;
begin
  Result := TStringList.Create;
  desc := GetCamaraPropertyDesc( kEdsPropID_Tv );
     Result.Clear;
        { refill available ISO value }
        for i := 0  to desc.numElements -1 do begin
          val := desc.propDesc[i];
          j := findTvPropIndex( val );
          Result.AddObject( TvProp[j].PropStr, @TvProp[j] );
        end;
end;

function TCanon.GetWBList: TStrings;
var desc : EdsPropertyDesc;
    i, j : integer;
    current, val  : EdsUInt32;
begin
  Result := TStringList.Create;
  desc := GetCamaraPropertyDesc( kEdsPropID_WhiteBalance );
     Result.Clear;
        { refill available ISO value }
        for i := 0  to desc.numElements -1 do begin
          val := desc.propDesc[i];
          j := findWBPropIndex( val );
          Result.AddObject( WBProp[j].PropStr, @WBProp[j] );
        end;
end;


function TCanon.GetISO: string;
var data: string;
begin
  getProperty(kEdsPropID_ISOSpeed);
  FindISOStr(iso,Result);
end;

function TCanon.SetISO(sISO: string): EdsError;
var data: EdsUInt32;
begin
  If FindISOID(sISO,data) then begin
  Result := EdsSetPropertyData( camera, kEdsPropID_ISOSpeed, 0, sizeof( data ), @data );
  if Result = EDS_ERR_OK then FISO := data;
  end;
end;

function TCanon.GetTv: string;
var data: string;
    n: integer;
begin
  getProperty(kEdsPropID_Tv);
  n:=findTvPropIndex(Tv);
  Result := TvProp[n].PropStr;
end;

function TCanon.SetTv(sTv: string): EdsError;
var data: EdsUInt32;
begin
  If FindTvID(sTv,data) then begin
  Result := EdsSetPropertyData( camera, kEdsPropID_Tv, 0, sizeof( data ), @data );
  if Result = EDS_ERR_OK then FTv := data;
  end;
end;

function TCanon.GetWB: string;
var data: string;
    n: integer;
begin
  getProperty(kEdsPropID_WhiteBalance);
  n:=findWBPropIndex(Cameraint);
  Result := WBProp[n].PropStr;
end;

function TCanon.SetWB(sWB: string): EdsError;
var data: EdsUInt32;
begin
  If FindWBID(sWB,data) then begin
  Result := EdsSetPropertyData( camera, kEdsPropID_WhiteBalance, 0, sizeof( data ), @data );
  if Result = EDS_ERR_OK then FWB := data;
  end;
end;

function TCanon.GetQuality: string;
var n: Cardinal;
begin
  n:=GetProperty(kEdsPropID_ImageQuality);
  FindQualityStr(Cameraint,Result);
end;

function TCanon.SetQuality(sQ: string): EdsError;
var data: EdsUInt32;
begin
  if FindQualiyID(sQ,data) then
  Result := EdsSetPropertyData( camera, kEdsPropID_ImageQuality, 0, sizeof( data ), @data );
end;

end.
