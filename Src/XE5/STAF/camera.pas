{******************************************************************************
*                                                                             *
*   PROJECT : EOS Digital Software Development Kit EDSDK                      *
*      NAME : camera.pas                                                      *
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
unit camera;

interface

uses
  Classes, Sysutils, EDSDKApi, EDSDKType, EDSDKError,
  DateUtils;

  type

  TCamera = class(TObject)
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
    FAeModeDesc : EdsPropertyDesc;
    FAvDesc  : EdsPropertyDesc;
    FTvDesc  : EdsPropertyDesc;
    FIsoDesc : EdsPropertyDesc;
    FBatteryLevelDesc: EdsPropertyDesc;
    FJpegQualityDesc: EdsPropertyDesc;

  public
    constructor Create( devInfo : EdsDeviceInfo );

    procedure getModelName( var name : string );
    function  getTime: TDateTime;

    { capture parameter }
    property  AEMode:EdsUInt32 read FAeMode write FAeMode;
    property  Av:EdsUInt32 read FAv write FAv;
    property  Tv:EdsUInt32 read FTv write FTv;
    property  Iso:EdsUInt32 read FIso write FIso;
    property  BatteryLevel:EdsUInt32 read FBatteryLevel write FBatteryLevel;
    property  JpegQuality:EdsUInt32 read FJpegQuality write FJpegQuality;

    { interface procedure and function }
    procedure setPropertyUInt32( id : EdsPropertyID; value : EdsUInt32 );
    function  getPropertyUInt32( id : EdsPropertyID ): EdsUInt32;
    procedure setPropertyString( id : EdsPropertyID ; const str : PChar );
    procedure getPropertyString( id : EdsPropertyID ; var str : PChar );

    procedure setPropertyDesc(id: EdsPropertyID; desc: EdsPropertyDesc );
    function  getPropertyDesc( id: EdsPropertyID ) : EdsPropertyDesc;

  end;



implementation


constructor TCamera.Create( devinfo : EdsDeviceInfo );
begin
  FDeviceInfo := devInfo;
end;



procedure TCamera.getModelName( var name : string );
var buffer : PChar;
begin
  GetMem( buffer,Length( FDeviceInfo.szDeviceDescription ) );
  StrCopy( buffer, FDeviceInfo.szDeviceDescription );
  name := buffer;
  FreeMem( buffer );
end;

function TCamera.getTime: TDateTime;
begin
end;


procedure TCamera.setPropertyUInt32(id: EdsPropertyID; value: EdsUInt32);
begin
  Case id of
    kEdsPropID_AEMode:    FAeMode := value;
    kEdsPropID_Tv:        FTv     := value;
    kEdsPropID_Av:        FAv     := value;
    kEdsPropID_ISOSpeed:  FIso    := value;
    kEdsPropID_BatteryLevel: FBatteryLevel := Value;
    kEdsPropID_JpegQuality : FJpegQuality  := Value;
  end;
end;

function TCamera.getPropertyUInt32( id : EdsPropertyID ): EdsUInt32;
var value : EdsUInt32;
begin
  value := $ffffffff;
  Case id of
    kEdsPropID_AEMode:    value := FAeMode;
    kEdsPropID_Tv:        value := FTv;
    kEdsPropID_Av:        value := FAv;
    kEdsPropID_ISOSpeed:  value := FIso;
    kEdsPropID_BatteryLevel: Value := FBatteryLevel;
    kEdsPropID_JpegQuality : Value := FJpegQuality;
  end;
  Result := value;
end;


procedure TCamera.setPropertyString( id : EdsPropertyID ; const str : PChar );
begin
  Case id of
    kEdsPropID_ProductName: StrCopy( FModelName, str );
  end;
end;


procedure TCamera.getPropertyString( id : EdsPropertyID ; var str : PChar );
begin
  Case id of
    kEdsPropID_ProductName: StrCopy( str, FModelName );
  end;
end;


procedure TCamera.setPropertyDesc(id: EdsPropertyID; desc: EdsPropertyDesc );
begin
  Case id of
    kEdsPropID_AEMode:   FAeModeDesc := desc;
    kEdsPropID_Tv:       FtvDesc := desc;
    kEdsPropID_Av:       FAvDesc := desc;
    kEdsPropID_ISOSpeed: FIsoDesc := desc;
    kEdsPropID_BatteryLevel: FBatteryLevelDesc := desc;
    kEdsPropID_JpegQuality : FJpegQualityDesc := desc;
  end;
end;

function TCamera.getPropertyDesc( id: EdsPropertyID ) : EdsPropertyDesc;
var desc : EdsPropertyDesc;
begin
  desc.form := 0;
  desc.access := kEdsAccess_Read;
  desc.numElements := 0;

  Case id of
    kEdsPropID_AEMode:    desc := FAeModeDesc;
    kEdsPropID_Tv:        desc := FTvDesc;
    kEdsPropID_Av:        desc := FAvDesc;
    kEdsPropID_ISOSpeed:  desc := FIsoDesc;
    kEdsPropID_BatteryLevel:  desc := FBatteryLevelDesc;
    kEdsPropID_JpegQuality :  desc := FJpegQualityDesc;
  end;
  Result := desc;
end;

end.
