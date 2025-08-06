unit STAF_EOS;

interface

uses
  Windows, SysUtils, Classes, EDSDKApi, EDSDKType, EDSDKError, DateUtils,
  ExtCtrls, MESSAGES, Dialogs;

type
  TPictureStatus       = (psNone, psBegin, psPicture, psSaved, psDelay, psEnd);

  TConnectEvent = procedure(Sender: TObject; Connected: boolean) of object;
  TNewFileEvent = procedure(Sender: TObject; SavedFile: string) of object;

  TCamera = class(TPersistent)
  private
    FDeviceInfo : EdsDeviceInfo;
    FTime       : EdsTime;

     { capture parameter }
    FModelName : PChar;
    FAeMode : EdsUInt32;
    FAv     : EdsUInt32;
    FTv     : EdsUInt32;
    FIso    : EdsUInt32;
    FBatteryLevel: EdsUInt32;
    FJpegQuality: EdsUInt32;

    { available range list of capture paramter }
    FAeModeDesc       : EdsPropertyDesc;
    FAvDesc           : EdsPropertyDesc;
    FTvDesc           : EdsPropertyDesc;
    FIsoDesc          : EdsPropertyDesc;
    FBatteryLevelDesc : EdsPropertyDesc;
    FJpegQualityDesc  : EdsPropertyDesc;

  public
    constructor Create( devInfo : EdsDeviceInfo );

    procedure getModelName( var name : string );
    function  getTime: TDateTime;

    { interface procedure and function }
    procedure setPropertyUInt32( id : EdsPropertyID; value : EdsUInt32 );
    function  getPropertyUInt32( id : EdsPropertyID ): EdsUInt32;
    procedure setPropertyString( id : EdsPropertyID ; const str : PChar );
    procedure getPropertyString( id : EdsPropertyID ; var str : PChar );

    procedure setPropertyDesc(id: EdsPropertyID; desc: EdsPropertyDesc );
    function  getPropertyDesc( id: EdsPropertyID ) : EdsPropertyDesc;

    { capture parameter }
    property  AEMode         :EdsUInt32 read FAeMode write FAeMode;
    property  Av             :EdsUInt32 read FAv write FAv;
    property  Tv             :EdsUInt32 read FTv write FTv;
    property  Iso            :EdsUInt32 read FIso write FIso;
    property  BatteryLevel   :EdsUInt32 read FBatteryLevel write FBatteryLevel;
    property  JpegQuality    :EdsUInt32 read FJpegQuality write FJpegQuality;
  end;

  TSTAF_Canon = class(TComponent)
  private
    InCamera      : EdsCameraRef;    // Camera ref for inner use
    deviceInfo    : EdsDeviceInfo;

    FCamera       : TCamera;
    FOnConnect    : TConnectEvent;
    FOnNewFile    : TNewFileEvent;

    FhWnd         : HWND;
    Ora           : TTimer;          // Timer for series of pictures
    OraCounter    : integer;         // Counts the seconds
    FIsSDKLoaded  : Bool;
    oldConnect    : Boolean;
    FIsConnect    : Boolean;
    FIsLegacy     : Bool;
    FNewFile      : string;
    FSavePath     : string;
    FFileName     : string;
    FTPictureStatus: TPictureStatus;
    procedure SetTPictureStatus(const Value: TPictureStatus);
    procedure SetIsConnect(const Value: boolean);
    procedure SetNewFile(const Value: string);
  protected
  public
    CameraString : string;
    CameraInt    : EdsUInt32;

    constructor Create( wnd : HWND );
    destructor Destroy ; override;

    function  Connect: boolean;
    function  getCameraObject : TCamera;
    function  enableConnection : EdsUInt32;
    function  setEventCallBack : EdsError;

    function  getProperty( id : EdsPropertyID ) : EdsError;
    function  getPropertyDesc( id : EdsPropertyID) : EdsError;

    function  setProperty( id : EdsPropertyID; var value : EdsUInt32 ) : EdsError;

    function  takePicture : EdsError;
    function  getImageData(itemRef : EdsDirectoryItemRef; targetPath : string ) : EdsError;
    property  PictureStatus: TPictureStatus read FTPictureStatus write SetTPictureStatus;
    property  fLegacy : Bool read FIsLegacy;
  published
    property Camera      : TCamera read FCamera write FCamera;
    property IsConnect   : boolean read FIsConnect write SetIsConnect;
    property filePath    : string read FSavePath write FSavePath;
    property FileName    : string read FFileName write FFileName;
    property NewFile     : string read FNewFile write SetNewFile;
    property OnConnect   : TConnectEvent read FOnConnect write FOnConnect;
    property OnNewFile   : TNewFileEvent read FOnNewFile write FOnNewFile;
  end;

  TCanon = class(TComponent)
  private
    camera        : EdsCameraRef;
    deviceInfo    : EdsDeviceInfo;
    FhWnd         : HWND;
    FIsLegacy     : Bool;
    FIsConnect: boolean;
    FOnConnect: TConnectEvent;
    procedure SetIsConnect(const Value: boolean);
  protected
  public
    FCamera       : TCamera;
    CameraString  : string;
    CameraInt     : EdsUInt32;
    cameraList    : EdsCameraListRef;
    constructor Create( wnd : HWND );
    destructor Destroy ; override;
    function Connect: boolean;
    property IsConnect : boolean read FIsConnect write SetIsConnect;
  published
    property OnConnect   : TConnectEvent read FOnConnect write FOnConnect;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('AL', [TSTAF_Canon]);
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
          kEdsPropID_AEMode,
          kEdsPropID_ISOSpeed,
          kEdsPropID_Av,
          kEdsPropID_Tv:
            PostMessage( HWND(inContext), WM_USER+1 , integer(inEvent) , integer(inPropertyID) );
         end;
      end;

    kEdsPropertyEvent_PropertyDescChanged :
      begin
        case inPropertyID of
          kEdsPropID_AEMode,
          kEdsPropID_ISOSpeed,
          kEdsPropID_Av,
          kEdsPropID_Tv:
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
begin
  case inEvent of
    kEdsObjectEvent_DirItemRequestTransfer :
      PostMessage( HWND(inContext), WM_USER+2 , integer(inEvent) , integer(inRef) );
  end;
  Result := EDS_ERR_OK;
end;


{ Progress callback function }
function ProgressFunc( inPercent : EdsUInt32;
                       inContext : EdsUInt32;
                       var outCancel : EdsBool ) : EdsError; stdcall;
begin
  PostMessage( HWND(inContext) , WM_USER+3 , integer(inPercent) , integer( outCancel ) );
  Result := EDS_ERR_OK;
end;

{ Object event handler }
(*function handleStateEvent(
            inCameraRef : EdsCameraRef;
            inEvent : EdsStateEvent;
            inStateEventHandler : Pointer;
            inContext : EdsUInt32 ) : EdsError; stdcall;
begin
  case inEvent of
    kEdsStateEvent_ALL :
      PostMessage( HWND(inContext), WM_USER+4 , integer(inEvent) , integer(inContext) );
  end;
  Result := EDS_ERR_OK;
end;*)

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
//     EOSCamRelease;
     end;
//   kEdsStateEvent_JobStatusChanged:
   kEdsStateEvent_WillSoonShutDown:
     begin s:=Format('The camera will shutdown in %d seconds.', [inEventData]);
      t:=mtWarning;
     end;
//   kEdsStateEvent_ShutDownTimerUpdate          = $00000304;
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

{ TCamera }

constructor TCamera.Create(devInfo: EdsDeviceInfo);
begin
  FDeviceInfo := devInfo;
end;

procedure TCamera.getModelName(var name: string);
var buffer : PChar;
begin
  GetMem( buffer,Length( FDeviceInfo.szDeviceDescription ) );
  StrCopy( buffer, FDeviceInfo.szDeviceDescription );
  name := buffer;
  FreeMem( buffer );
end;

function TCamera.getPropertyDesc(id: EdsPropertyID): EdsPropertyDesc;
var desc : EdsPropertyDesc;
begin
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
  end;
  Result := desc;
end;

procedure TCamera.setPropertyDesc(id: EdsPropertyID;
  desc: EdsPropertyDesc);
begin
  Case id of
    kEdsPropID_AEMode        : FAeModeDesc := desc;
    kEdsPropID_Tv            : FtvDesc := desc;
    kEdsPropID_Av            : FAvDesc := desc;
    kEdsPropID_ISOSpeed      : FIsoDesc := desc;
    kEdsPropID_BatteryLevel  : FBatteryLevelDesc := desc;
    kEdsPropID_JpegQuality   : FJpegQualityDesc := desc;
  end;
end;

procedure TCamera.getPropertyString(id: EdsPropertyID; var str: PChar);
begin
  Case id of
    kEdsPropID_ProductName: StrCopy( FModelName, str );
  end;
end;

procedure TCamera.setPropertyString(id: EdsPropertyID;
  const str: PChar);
begin
  Case id of
    kEdsPropID_ProductName: StrCopy( FModelName, str );
  end;
end;

function TCamera.getPropertyUInt32(id: EdsPropertyID): EdsUInt32;
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
  end;
  Result := value;
end;

procedure TCamera.setPropertyUInt32(id: EdsPropertyID;
  value: EdsUInt32);
begin
  Case id of
    kEdsPropID_AEMode        : FAeMode := value;
    kEdsPropID_Tv            : FTv     := value;
    kEdsPropID_Av            : FAv     := value;
    kEdsPropID_ISOSpeed      : FIso    := value;
    kEdsPropID_BatteryLevel  : FBatteryLevel := Value;
    kEdsPropID_JpegQuality   : FJpegQuality  := Value;
  end;
end;

function TCamera.getTime: TDateTime;
begin

end;

{ TSTAF_Canon }
//============================================================================//

constructor TSTAF_Canon.Create(wnd: HWND);
var err : EdsError;
    cameraList  : EdsCameraListRef;
    count : EdsUInt32;
    deviceInfo : EdsDeviceInfo;
begin
  FhWnd := wnd;
  FIsConnect    := false;
  FIsSDKLoaded  := false;
  cameraList    := nil;
  count         := 0;
  incamera      := nil;
  { load EDSDk and initialize }
  err := EdsInitializeSDK;
  if err = EDS_ERR_OK then
    FIsSDKLoaded := true;
  Ora           := TTimer.Create(nil);
//  Ora.OnTimer   := OnOra;
  FNewFile      := '';
  FFileName     := 'CANON_';
  Connect;
end;

destructor TSTAF_Canon.Destroy;
begin
  Ora.Free;
  if FIsSDKLoaded = true then begin
    { disconnect camera }
    if FIsConnect = true then
      EdsCloseSession( incamera );
    FCamera.Free;
    EdsTerminateSDK;
  end;
  inherited;
end;

function TSTAF_Canon.Connect: boolean;
var err : EdsError;
    cameraList  : EdsCameraListRef;
    count : EdsUInt32;
begin
Try
  Result := False;
  IsConnect := False;

  { get list of camera }
  err := EdsGetCameraList( cameraList );

  { get number of camera }
  if err = EDS_ERR_OK then begin
    err := EdsGetChildCount( cameraList , count );
    if count = 0 then begin
      if Assigned(FOnConnect) then FOnConnect(Self,False);
      Exit;
    end else begin
      Result := True;
      IsConnect := True;
      if Assigned(FOnConnect) then FOnConnect(Self,True);
    end;
  end;

  { get first camera }
  if err = EDS_ERR_OK then
    EdsGetChildAtIndex( cameraList , 0 , InCamera );

  if incamera <> nil then begin
    err := EdsGetDeviceInfo( incamera , deviceInfo );
    if err = EDS_ERR_OK then begin
      if deviceInfo.deviceSubType = 0 then
        FIsLegacy := true
      else
        FIsLegacy := false;{ new type camera! }
    end;
    { create TCamera class }
    FCamera := TCamera.Create( deviceInfo );
  end;

  { release camera list object }
  if cameraList <> nil then
    EdsRelease( cameraList );

except
  IsConnect := False;
end;
end;

function TSTAF_Canon.enableConnection: EdsUInt32;
var err : EdsError;
    saveTo : EdsUInt32;
    fLock  : Bool;
    capacity : EdsCapacity;
begin
  fLock := false;
  FIsConnect := false;

  { Open session with the connected camera }
  err := EdsOpenSession( incamera );
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

		   err := EdsSetCapacity( incamera, capacity);
  	 end;

		 { It releases it when locked }
		 if fLock = true  then
      EdsSendStatusCommand(incamera, kEdsCameraState_UIUnLock, 0);

	 end;
  Result := err;

end;

procedure TSTAF_Canon.SetIsConnect(const Value: boolean);
begin
  FIsConnect := Value;
end;

procedure TSTAF_Canon.SetNewFile(const Value: string);
begin
  if FNewFile <> Value then begin
    FNewFile := Value;
    if Assigned(FOnNewFile) then FOnNewFile(Self,Value);
  end;
end;

function TSTAF_Canon.getCameraObject: TCamera;
begin
  Result := FCamera;
end;

function TSTAF_Canon.getProperty(id: EdsPropertyID): EdsError;
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

  err := EdsGetPropertySize( incamera, id, 0, dataType, dataSize );
  if err <> EDS_ERR_OK then begin
    Result := err;
    Exit;
  end;

  if dataType = EdsUInt32(kEdsDataType_UInt32) then begin
    P := @data;
    err := EdsGetPropertyData( incamera, id, 0, dataSize, Pointer(P^) );

    { set property data into TCamera }
    if err = EDS_ERR_OK then begin
      FCamera.setPropertyUInt32( id, data );
      CameraInt := data;
    end;
  end;

  if dataType = EdsUInt32(kEdsDataType_String) then begin
    P := @str;
    err := EdsGetPropertyData( incamera, id, 0, dataSize, Pointer(P^) );

    { set property string into TCamera }
    if err = EDS_ERR_OK then begin
      FCamera.setPropertyString( id, str );
      CameraString := StrPas(str);
    end;

  end;
  Result := err;
end;

function TSTAF_Canon.getPropertyDesc(id: EdsPropertyID): EdsError;
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

  err := EdsGetPropertyDesc( incamera, id, desc );
  if err = EDS_ERR_OK then
    { set available list into TCamera object }
    FCamera.setPropertyDesc( id, desc );

  Result := err;
end;

function TSTAF_Canon.setEventCallBack: EdsError;
var err : EdsError;
begin
  err := EDS_ERR_OK;
  if camera = nil then begin
    Result := err;
    Exit;
  end;

  { register property event handler & object event handler }
  err := EdsSetPropertyEventHandler( camera, kEdsPropertyEvent_All, @handlePropertyEvent, FhWnd );
  if err = EDS_ERR_OK then
    err := EdsSetObjectEventHandler( camera, kEdsObjectEvent_All, @handleObjectEvent, FhWnd );

  if err = EDS_ERR_OK then
     err := EdsSetCameraStateEventHandler(camera, kEdsStateEvent_All, @HandleStateEvent, FhWnd);

  Result := err;
end;

function TSTAF_Canon.setProperty(id: EdsPropertyID;
  var value: EdsUInt32): EdsError;
var err : EdsError;
begin
  err := EdsSetPropertyData( incamera, id, 0, sizeof( value ), @value );
  Result := err;
end;

function TSTAF_Canon.getImageData(itemRef: EdsDirectoryItemRef;
  targetPath: string): EdsError;
var dirInfo : EdsDirectoryItemInfo;
    err : EdsError;
    stream : EdsStreamRef;
    ffName,fName,Ext : string;
begin
  { get information of captured image }
  err := EdsGetDirectoryItemInfo( itemRef, dirInfo );
  if err <> EDS_ERR_OK then begin
    Result := err;
    Exit;
  end;

(*
  Ext   := ExtractFileExt(string(dirInfo.szFileName));
  fName := FileName+Inttostr(StartCounter);
  ffName := IncludeTrailingPathDelimiter(FSavePath) + FName + Ext;
  While FileExists(ffName) do begin
    StartCounter := StartCounter+1;
    FName := FileName+'_'+Inttostr(StartCounter);
    ffName := IncludeTrailingPathDelimiter(FSavePath) + FName + Ext;
  end;
*)
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
  end;

  { free resource }
  if stream <> nil then begin
    EdsRelease( stream );
  end;

  EdsRelease( itemRef );

  PictureStatus := psSaved;
  NewFile := ffName;

  Result := err;
end;

{------------------------------------}
{ Process of handling remote release }
{------------------------------------}
function TSTAF_Canon.takePicture: EdsError;
var err : EdsError;
    fLock  : Bool;
begin

  fLock := false;
  err := EDS_ERR_OK;

  if camera = nil then begin
    PictureStatus := psNone;
    Result := err;
    Exit;
  end;

  { For cameras earlier than the 30D, the camera UI must be
    locked before commands are issued. }
  if fLegacy = true then begin
    err := EdsSendStatusCommand( incamera, kEdsCameraState_UILock, 0 );
    if err = EDS_ERR_OK then
      fLock := true;

  end;

  if err = EDS_ERR_OK then
    err := EdsSendCommand( incamera, kEdsCameraCommand_TakePicture, 0 );

  if fLock = true then
    err := EdsSendStatusCommand( incamera, kEdsCameraState_UIUnLock, 0 );

  Result := err;
end;


procedure TSTAF_Canon.SetTPictureStatus(const Value: TPictureStatus);
begin
  FTPictureStatus := Value;
end;

{ TCanon }

constructor TCanon.Create(wnd: HWND);
begin
  FhWnd := wnd;
  FCamera := nil;
end;

destructor TCanon.Destroy;
begin
  { release camera list object }
  if cameraList <> nil then
    EdsRelease( cameraList );
  if FCamera<>nil then
     FCamera.Free;
  inherited;
end;

procedure TCanon.SetIsConnect(const Value: boolean);
begin
  FIsConnect := Value;
end;

function TCanon.Connect: boolean;
var err : EdsError;
    count : EdsUInt32;
begin
Try
  Result := False;
  IsConnect := False;

  { get list of camera }
  err := EdsGetCameraList( cameraList );

  { get number of camera }
  if err = EDS_ERR_OK then begin
    err := EdsGetChildCount( cameraList , count );
    if count = 0 then begin
//      ShowMessage( 'Camera is not connected!' );
      if Assigned(FOnConnect) then FOnConnect(Self,False);
      Exit;
    end else begin
      Result := True;
      IsConnect := True;
      if Assigned(FOnConnect) then FOnConnect(Self,True);
    end;
  end;

  { get first camera }
  if err = EDS_ERR_OK then
    EdsGetChildAtIndex( cameraList , 0 , camera );

  if camera <> nil then begin
    err := EdsGetDeviceInfo( camera , deviceInfo );
    if err = EDS_ERR_OK then begin
      if deviceInfo.deviceSubType = 0 then
        FIsLegacy := true
      else
        FIsLegacy := false;{ new type camera! }
    end;

    { create TCamera class }
    FCamera := TCamera.Create( deviceInfo );
  end;

except
  IsConnect := False;
end;
end;

end.
