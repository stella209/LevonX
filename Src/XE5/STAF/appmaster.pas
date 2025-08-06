{******************************************************************************
*                                                                             *
*   PROJECT : EOS Digital Software Development Kit EDSDK                      *
*      NAME : appmaster.pas                                                   *
*                                                                             *
*   Description: This is the Sample code to show the usage of EDSDK.          *
*                                                                             *
*                                                                             *
*******************************************************************************
*                                                                             *
*   Written and developed by Camera Design Dept.53                            *
*   Copyright Canon Inc. 2006 All Rights Reserved                             *
*                                                                             *
*******************************************************************************
*   File Update Information:                                                  *
*     DATE      Identify    Comment                                           *
*   -----------------------------------------------------------------------   *
*   06-03-22    F-001        create first version.                            *
*                                                                             *
******************************************************************************}
unit appmaster;

interface

uses
  Dialogs, SysUtils, Windows, ExtCtrls, Classes, Forms,
  MESSAGES, EDSDKApi, EDSDKType, EDSDKError, camera;

type

  TPictureStatus       = (psNone, psBegin, psPicture, psSaved, psDelay, psEnd);

  TPictureSeriesStatus = (pssNone, pssFirst, pssMiddle, pssEnd);
  TPictureSeriesStatusSet = set of TPictureSeriesStatus;

  TPictureSeriesEvent = procedure(Sender: TObject; PicCount: integer;
                                  Status: TPictureStatus; Sec: integer) of object;

  TConnectEvent = procedure(Sender: TObject; Connected: boolean) of object;
  TNewFileEvent = procedure(Sender: TObject; SavedFile: string) of object;

  TAppMaster = class(TComponent)
  private

    FhWnd : HWND;
    Ora   : TTimer;          // Timer for series of pictures
    OraCounter : integer;    // Counts the seconds
    FIsSDKLoaded : Bool;

    oldConnect : Boolean;
    FIsConnect : Boolean;
    FIsLegacy  : Bool;

    camera : EdsCameraRef;

    FSavePath : string;
    FFileName: string;
    FStartCounter: word;
    FNewFile: string;
    FImageCount: integer;
    FDelaySec: integer;
    FTPictureStatus: TPictureStatus;
    FOnPictureSeries: TPictureSeriesEvent;
    FOnNewFile: TNewFileEvent;
    FOnConnect: TConnectEvent;
    procedure SetIsConnect(const Value: boolean);
    procedure SetNewFile(const Value: string);
    procedure SetTPictureStatus(const Value: TPictureStatus);
    procedure SetImageCount(const Value: integer);
    procedure OnOra(Sender: TObject);

  public

    FCamera      : TCamera;
    CameraString : string;
    CameraInt    : EdsUInt32;

    constructor Create( hwnd : HWND );
    destructor Destroy ; override;

    property  IsConnect : boolean read FIsConnect write SetIsConnect;
    property  filePath : string read FSavePath write FSavePath;
    property  FileName : string read FFileName write FFileName;
    property  NewFile  : string read FNewFile write SetNewFile;
    property  StartCounter : word read FStartCounter write FStartCounter;
    property  ImageCount : integer read FImageCount write SetImageCount;
    property  DelaySec   : integer read FDelaySec write FDelaySec;
    property  PictureStatus: TPictureStatus read FTPictureStatus write SetTPictureStatus;
    property  fLegacy : Bool read FIsLegacy;

    function Connect: boolean;

    procedure getCameraName( var name : string );
    function  saveSetting : EdsError;

    function  getCameraObject : TCamera;
    function  enableConnection : EdsUInt32;
    function  setEventCallBack : EdsError;

    function  getProperty( id : EdsPropertyID ) : EdsError;
    function  getPropertyDesc( id : EdsPropertyID) : EdsError;

    function  setProperty( id : EdsPropertyID; var value : EdsUInt32 ) : EdsError;

    function  takePicture : EdsError;
    function  TakePictureSeries(fName: string; PicCount: integer;
              BeginNumber, Delay: integer): EdsError;
    function  getImageData(itemRef : EdsDirectoryItemRef; targetPath : string ) : EdsError;
    property  OnPictureSeries: TPictureSeriesEvent read FOnPictureSeries
                            write FOnPictureSeries;
    property  OnConnect: TConnectEvent read FOnConnect write FOnConnect;
    property  OnNewFile: TNewFileEvent read FOnNewFile write FOnNewFile;
  end;

Const PictureStatusString : array[0..5] of string =
        ('None', 'Begin', 'Picture', 'Saved', 'Delay', 'End');

implementation

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


{===============================================================================}


{ TAppMaster class }

constructor TAppMaster.Create( hwnd : HWND );
var err : EdsError;
    cameraList  : EdsCameraListRef;
    count : EdsUInt32;
    deviceInfo : EdsDeviceInfo;
begin
//  inherited hwnd;
  FhWnd := hwnd;
  FIsConnect := false;
  FIsSDKLoaded := false;
  cameraList := nil;
  count := 0;
  camera := nil;
  { load EDSDk and initialize }
  err := EdsInitializeSDK;
  if err = EDS_ERR_OK then
    FIsSDKLoaded := true;
  Ora       := TTimer.Create(nil);
  Ora.OnTimer  := OnOra;
  FNewFile  := '';
  FFileName := 'CANON_';
  Connect;
end;

function TAppMaster.Connect: boolean;
var err : EdsError;
    cameraList  : EdsCameraListRef;
    count : EdsUInt32;
    deviceInfo : EdsDeviceInfo;
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

  { release camera list object }
  if cameraList <> nil then
    EdsRelease( cameraList );

except
  IsConnect := False;
end;
end;


destructor TAppMaster.Destroy;
begin
  Ora.Free;
  if FIsSDKLoaded = true then begin
    { disconnect camera }
    if FIsConnect = true then
      EdsCloseSession( camera );

    FCamera.Free;
    EdsTerminateSDK;
  end;
  inherited;
end;

{-------------------------------------------}
{ process of logical connection with camera }
{-------------------------------------------}
function TAppMaster.enableConnection: EdsUInt32;
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

{-------------------------------------------}
{ register event callback function to EDSDK }
{-------------------------------------------}
function TAppMaster.SetEventCallBack : EdsError;
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

{------------------------------------------}
{         get camera model name            }
{------------------------------------------}
procedure TAppMaster.getCameraName( var name : string );
begin
  if FCamera <> nil then
    FCamera.getModelName( name );
  if Not IsConnect then
    name := 'Camera is not detected!';
end;

{------------------------------------------}
{           get TCamera object             }
{------------------------------------------}
function TAppMaster.getCameraObject: TCamera;
begin
  Result := FCamera;
end;

{-------------------------------------}
{ set file saving location at capture }
{-------------------------------------}
function TAppMaster.saveSetting: EdsError;
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

{----------------------------------------}
{ get data from camera hardware directly }
{----------------------------------------}
function TAppMaster.getProperty( id: EdsPropertyID ): EdsError;
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

  if dataType = EdsUInt32(kEdsDataType_UInt32) then begin
    P := @data;
    err := EdsGetPropertyData( camera, id, 0, dataSize, Pointer(P^) );

    { set property data into TCamera }
    if err = EDS_ERR_OK then begin
      FCamera.setPropertyUInt32( id, data );
      CameraInt := data;
    end;
  end;

  if dataType = EdsUInt32(kEdsDataType_String) then begin
    P := @str;
    err := EdsGetPropertyData( camera, id, 0, dataSize, Pointer(P^) );

    { set property string into TCamera }
    if err = EDS_ERR_OK then begin
      FCamera.setPropertyString( id, str );
      CameraString := StrPas(str);
    end;

  end;
  Result := err;
end;

{----------------------------------------}
{ get desc from camera hardware directly }
{----------------------------------------}
function TAppMaster.getPropertyDesc(id: EdsPropertyID ): EdsError;
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
    FCamera.setPropertyDesc( id, desc );

  Result := err;
end;

{-------------------------------- ---------}
{ set property data into hardware directly }
{------------------------------------------}
function TAppMaster.setProperty(id: EdsPropertyID; var value: EdsUInt32): EdsError;
var err : EdsError;
begin
  err := EdsSetPropertyData( camera, id, 0, sizeof( value ), @value );
  Result := err;
end;


{------------------------------------}
{ Process of handling remote release }
{------------------------------------}
function TAppMaster.takePicture: EdsError;
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
    err := EdsSendStatusCommand( camera, kEdsCameraState_UILock, 0 );
    if err = EDS_ERR_OK then
      fLock := true;

  end;

  if err = EDS_ERR_OK then
    err := EdsSendCommand( camera, kEdsCameraCommand_TakePicture, 0 );

  if fLock = true then
    err := EdsSendStatusCommand( camera, kEdsCameraState_UIUnLock, 0 );

  Result := err;
end;

{ ---------------------------------------- }
{    Process of getting captured image     }
{ ---------------------------------------- }
function TAppMaster.getImageData( itemRef : EdsDirectoryItemRef; targetPath : string ) : EdsError;
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

  Ext   := ExtractFileExt(string(dirInfo.szFileName));
  fName := FileName+Inttostr(StartCounter);
  ffName := IncludeTrailingPathDelimiter(FSavePath) + FName + Ext;
  While FileExists(ffName) do begin
    StartCounter := StartCounter+1;
    FName := FileName+'_'+Inttostr(StartCounter);
    ffName := IncludeTrailingPathDelimiter(FSavePath) + FName + Ext;
  end;
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

procedure TAppMaster.SetImageCount(const Value: integer);
begin
  FImageCount := Value;
  if Value=0 then PictureStatus:=psEnd;
end;

procedure TAppMaster.SetTPictureStatus(const Value: TPictureStatus);
begin
  if FTPictureStatus <> Value then begin
    FTPictureStatus := Value;
    OraCounter   := 0;
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

procedure TAppMaster.OnOra(Sender: TObject);
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

function TAppMaster.takePictureSeries(fName: string; PicCount: integer;
              BeginNumber, Delay: integer): EdsError;
begin
  FileName := ExtractFileName(fName);
  ImageCount := PicCount;
  StartCounter := BeginNumber;
  DelaySec     := Delay;
  PictureStatus := psBegin;
end;

procedure TAppMaster.SetNewFile(const Value: string);
begin
  if FNewFile <> Value then begin
    FNewFile := Value;
    if Assigned(FOnNewFile) then FOnNewFile(Self,Value);
  end;
end;

procedure TAppMaster.SetIsConnect(const Value: boolean);
begin
  FIsConnect := Value;
end;

end.
