unit EDSDK;

interface

uses EDSDKError, EDSDKType;

function EdsInitializeSDK: TEdsError; stdcall; external 'EDSDK.dll';
//      Initializes the libraries.
//      When using the EDSDK libraries, you must call this API once
//      before using EDSDK APIs.

function EdsTerminateSDK: TEdsError; stdcall; external 'EDSDK.dll';
//      Terminates use of the libraries.
//      This function muse be called when ending the SDK.
//      Calling this function releases all resources allocated by the libraries.

function EdsRetain(inRef: TEdsBaseRef): TEdsUInt32; stdcall; external 'EDSDK.dll';
//      Increments the reference counter of existing objects.

function EdsRelease(inRef: TEdsBaseRef): TEdsUInt32; stdcall; external 'EDSDK.dll';
//      Decrements the reference counter to an object.
//      When the reference counter reaches 0, the object is released.

function EdsGetChildCount(inRef: TEdsBaseRef; var outCount: TEdsUInt32): TEdsError; stdcall; external 'EDSDK.dll';
//      Gets the number of child objects of the designated object.
//      Example: Number of files in a directory

function EdsGetChildAtIndex(inRef: TEdsBaseRef; inIndex: TEdsInt32; var outRef: TEdsBaseRef): TEdsError; stdcall; external 'EDSDK.dll';
//       Gets an indexed child object of the designated object.

function EdsGetParent(inRef: TEdsBaseRef; var outParentRef: TEdsBaseRef): TEdsError; stdcall; external 'EDSDK.dll';
//      Gets the parent object of the designated object.

function EdsGetPropertySize(inRef: TEdsBaseRef; inPropertyID: TEdsPropertyID; inParam: TEdsInt32; var outDataType: TEdsDataType; var outSize: TEdsUInt32): TEdsError; stdcall; external 'EDSDK.dll';
//      Gets the byte size and data type of a designated property
//      from a camera object or image object.

function EdsGetPropertyData(inRef: TEdsBaseRef; inPropertyID: TEdsPropertyID; inParam: TEdsInt32; inPropertySize: TEdsUInt32; var outPropertyData): TEdsError; stdcall; external 'EDSDK.dll';
//      Gets property information from the object designated in inRef.

function EdsSetPropertyData(inRef: TEdsBaseRef; inPropertyID: TEdsPropertyID; inParam: TEdsInt32; inPropertySize: TEdsUInt32; const inPropertyData): TEdsError; stdcall; external 'EDSDK.dll';
//      Sets property data for the object designated in inRef.

function EdsGetPropertyDesc(inRef: TEdsBaseRef; inPropertyID: TEdsPropertyID; var outPropertyDesc: TEdsPropertyDesc): TEdsError; stdcall; external 'EDSDK.dll';
//      Gets a list of property data that can be set for the object
//      designated in inRef, as well as maximum and minimum values.
//      This API is intended for only some shooting-related properties.

function EdsGetCameraList(var outCameraListRef: TEdsCameraListRef): TEdsError; stdcall; external 'EDSDK.dll';
//      Gets camera list objects.

function EdsGetDeviceInfo(inCameraRef: TEdsCameraRef; var outDeviceInfo: TEdsDeviceInfo): TEdsError; stdcall; external 'EDSDK.dll';
//      Gets device information, such as the device name.
//      Because device information of remote cameras is stored
//      on the host computer, you can use this API
//      before the camera object initiates communication
//     (that is, before a session is opened).

function EdsOpenSession(inCameraRef: TEdsCameraRef): TEdsError; stdcall; external 'EDSDK.dll';
//      Establishes a logical connection with a remote camera.
//      Use this API after getting the camera's EdsCamera object.

function EdsCloseSession(inCameraRef: TEdsCameraRef): TEdsError; stdcall; external 'EDSDK.dll';
//       Closes a logical connection with a remote camera.

function EdsSendCommand(inCameraRef: TEdsCameraRef; inCommand: TEdsCameraCommand; inParam: TEdsInt32): TEdsError; stdcall; external 'EDSDK.dll';
//       Sends a command such as "Shoot" to a remote camera.

function EdsSendStatusCommand(inCameraRef: TEdsCameraRef; inStatusCommand: TEdsCameraStatusCommand; inParam: TEdsInt32): TEdsError; stdcall; external 'EDSDK.dll';
//       Sets the remote camera state or mode.

function EdsSetCapacity(inCameraRef: TEdsCameraRef; inCapacity: TEdsCapacity): TEdsError; stdcall; external 'EDSDK.dll';
//       Sets the remaining HDD capacity on the host computer
//          (excluding the portion from image transfer),
//          as calculated by subtracting the portion from the previous time.
//       Set a reset flag initially and designate the cluster length
//          and number of free clusters.
//       Some type 2 protocol standard cameras can display the number of shots
//          left on the camera based on the available disk capacity
//          of the host computer.
//       For these cameras, after the storage destination is set to the computer,
//          use this API to notify the camera of the available disk capacity
//          of the host computer.

function EdsGetVolumeInfo(inVolumeRef: TEdsVolumeRef; var outVolumeInfo: TEdsVolumeInfo): TEdsError; stdcall; external 'EDSDK.dll';
//      Gets volume information for a memory card in the camera.

function EdsFormatVolume(inVolumeRef: TEdsVolumeRef): TEdsError; stdcall; external 'EDSDK.dll';
//       Formats volumes of memory cards in a camera.

function EdsGetDirectoryItemInfo(inDirItemRef: TEdsDirectoryItemRef; var outDirItemInfo: TEdsDirectoryItemInfo): TEdsError; stdcall; external 'EDSDK.dll';
//      Gets information about the directory or file objects
//          on the memory card (volume) in a remote camera.

function EdsDeleteDirectoryItem(inDirItemRef: TEdsDirectoryItemRef): TEdsError; stdcall; external 'EDSDK.dll';
//      Deletes a camera folder or file.
//      If folders with subdirectories are designated, all files are deleted
//          except protected files.
//      EdsDirectoryItem objects deleted by means of this API are implicitly
//          released by the EDSDK. Thus, there is no need to release them
//          by means of EdsRelease.

function EdsDownload(inDirItemRef: TEdsDirectoryItemRef; inReadSize: TEdsUInt32; outStream: TEdsStreamRef): TEdsError; stdcall; external 'EDSDK.dll';
//      Downloads a file on a remote camera
//          (in the camera memory or on a memory card) to the host computer.
//      The downloaded file is sent directly to a file stream created in advance.
//      When dividing the file being retrieved, call this API repeatedly.
//      Also in this case, make the data block size a multiple of 512 (bytes),
//          excluding the final block.

function EdsDownloadCancel(inDirItemRef: TEdsDirectoryItemRef): TEdsError; stdcall; external 'EDSDK.dll';
//      Must be executed when downloading of a directory item is canceled.
//      Calling this API makes the camera cancel file transmission.
//      It also releases resources.
//      This operation need not be executed when using EdsDownloadThumbnail.


function EdsDownloadComplete(inDirItemRef: TEdsDirectoryItemRef): TEdsError; stdcall; external 'EDSDK.dll';
//      Must be called when downloading of directory items is complete.
//      Executing this API makes the camera recognize that file transmission
//      is complete. This operation need not be executed when using
//      EdsDownloadThumbnail.


function EdsDownloadThumbnail(inDirItemRef: TEdsDirectoryItemRef; outStream: TEdsStreamRef): TEdsError; stdcall; external 'EDSDK.dll';
//      Extracts and downloads thumbnail information from image files in a camera.
//      Thumbnail information in the camera's image files is downloaded
//          to the host computer.
//      Downloaded thumbnails are sent directly to a file stream created in advance.

function EdsGetAttribute(inDirItemRef: TEdsDirectoryItemRef; var outFileAttribute: TEdsFileAttributes): TEdsError; stdcall; external 'EDSDK.dll';
//      Gets attributes of files on a camera.

function EdsSetAttribute(inDirItemRef: TEdsDirectoryItemRef; inFileAttribute: TEdsFileAttributes): TEdsError; stdcall; external 'EDSDK.dll';
//      Changes attributes of files on a camera.

function EdsCreateFileStream(const inFileName: TEdsString; inCreateDisposition: TEdsFileCreateDisposition; inDesiredAccess: TEdsAccess; var outStream: TEdsStreamRef): TEdsError; stdcall; external 'EDSDK.dll';
//      Creates a new file on a host computer (or opens an existing file)
//          and creates a file stream for access to the file.
//      If a new file is designated before executing this API,
//          the file is actually created following the timing of writing
//          by means of EdsWrite or the like with respect to an open stream.

function EdsCreateMemoryStream(inBufferSize: TEdsUInt32; var outStream: TEdsStreamRef): TEdsError; stdcall; external 'EDSDK.dll';
//      Creates a stream in the memory of a host computer.
//      In the case of writing in excess of the allocated buffer size,
//          the memory is automatically extended.

function EdsCreateFileStreamEx(const inFileName: WideString; inCreateDisposition: TEdsFileCreateDisposition; inDesiredAccess: TEdsAccess; var outStream: TEdsStreamRef): TEdsError; stdcall; external 'EDSDK.dll';
//      An extended version of EdsCreateStreamFromFile.
//      Use this function when working with Unicode file names.

function EdsCreateMemoryStreamFromPointer(const inUserBuffer; inBufferSize: TEdsUInt32; var outStream: TEdsStreamRef): TEdsError; stdcall; external 'EDSDK.dll';
//      Creates a stream from the memory buffer you prepare.
//      Unlike the buffer size of streams created by means of EdsCreateMemoryStream,
//      the buffer size you prepare for streams created this way does not expand.

function EdsGetPointer(inStream: TEdsStreamRef; var outPointer: Pointer): TEdsError; stdcall; external 'EDSDK.dll';
//      Gets the pointer to the start address of memory managed by the memory stream.
//      As the EDSDK automatically resizes the buffer, the memory stream provides
//          you with the same access methods as for the file stream.
//      If access is attempted that is excessive with regard to the buffer size
//          for the stream, data before the required buffer size is allocated
//          is copied internally, and new writing occurs.
//      Thus, the buffer pointer might be switched on an unknown timing.
//      Caution in use is therefore advised.

function EdsRead(inStreamRef: TEdsStreamRef; inReadSize: TEdsUInt32; var outBuffer; var outReadSize: TEdsUInt32): TEdsError; stdcall; external 'EDSDK.dll';
//      Reads data the size of inReadSize into the outBuffer buffer,
//          starting at the current read or write position of the stream.
//      The size of data actually read can be designated in outReadSize.

function EdsWrite(inStreamRef: TEdsStreamRef; inWriteSize: TEdsUInt32; const inBuffer; var outWrittenSize: TEdsUInt32): TEdsError; stdcall; external 'EDSDK.dll';
//      Writes data of a designated buffer
//          to the current read or write position of the stream.

function EdsSeek(inStreamRef: TEdsStreamRef; inSeekOffset: TEdsInt32; inSeekOrigin: TEdsSeekOrigin): TEdsError; stdcall; external 'EDSDK.dll';
//      Moves the read or write position of the stream
//            (that is, the file position indicator).

function EdsGetPosition(inStreamRef: TEdsStreamRef; var outPosition: TEdsUInt32): TEdsError; stdcall; external 'EDSDK.dll';
//      Gets the current read or write position of the stream
//          (that is, the file position indicator).

function EdsGetLength(inStreamRef: TEdsStreamRef; var outLength: TEdsUInt32): TEdsError; stdcall; external 'EDSDK.dll';
//      Gets the stream size.

function EdsCopyData(inStreamRef: TEdsStreamRef; inWriteSize: TEdsUInt32; outStreamRef: TEdsStreamRef): TEdsError; stdcall; external 'EDSDK.dll';
//      Copies data from the copy source stream to the copy destination stream.
//      The read or write position of the data to copy is determined from
//          the current file read or write position of the respective stream.
//      After this API is executed, the read or write positions of the copy source
//          and copy destination streams are moved an amount corresponding to
//          inWriteSize in the positive direction.

function EdsSetProgressCallback(inRef: TEdsBaseRef; inProgressCallback: TEdsProgressCallback; inProgressOption: TEdsProgressOption; inContext: TVoid): TEdsError; stdcall; external 'EDSDK.dll';
//      Register a progress callback function.
//      An event is received as notification of progress during processing that
//          takes a relatively long time, such as downloading files from a
//          remote camera.
//      If you register the callback function, the EDSDK calls the callback
//          function during execution or on completion of the following APIs.
//      This timing can be used in updating on-screen progress bars, for example.

function EdsCreateImageRef(inStreamRef: TEdsStreamRef; var outImageRef: TEdsImageRef): TEdsError; stdcall; external 'EDSDK.dll';
//      Creates an image object from an image file.
//      Without modification, stream objects cannot be worked with as images.
//      Thus, when extracting images from image files,
//          you must use this API to create image objects.
//      The image object created this way can be used to get image information
//          (such as the height and width, number of color components, and
//           resolution), thumbnail image data, and the image data itself.

function EdsGetImageInfo(inImageRef: TEdsImageRef; inImageSource: TEdsImageSource; var outImageInfo: TEdsImageInfo): TEdsError; stdcall; external 'EDSDK.dll';
//      Gets image information from a designated image object.
//      Here, image information means the image width and height,
//          number of color components, resolution, and effective image area.

function EdsGetImage(inImageRef: TEdsImageRef; inImageSource: TEdsImageSource; inImageType: TEdsTargetImageType; inSrcRect: TEdsRect; inDstSize: TEdsSize; outStreamRef: TEdsStreamRef): TEdsError; stdcall; external 'EDSDK.dll';
//      Gets designated image data from an image file, in the form of a
//          designated rectangle.
//      Returns uncompressed results for JPEGs and processed results
//          in the designated pixel order (RGB, Top-down BGR, and so on) for
//           RAW images.
//      Additionally, by designating the input/output rectangle,
//          it is possible to get reduced, enlarged, or partial images.
//      However, because images corresponding to the designated output rectangle
//          are always returned by the SDK, the SDK does not take the aspect
//          ratio into account.
//      To maintain the aspect ratio, you must keep the aspect ratio in mind
//          when designating the rectangle.


function EdsSaveImage(inImageRef: TEdsImageRef; inImageType: TEdsTargetImageType; inSaveSetting: TEdsSaveImageSetting; outStreamRef: TEdsStreamRef): TEdsError; stdcall; external 'EDSDK.dll';
//      Saves as a designated image type after RAW processing.
//      When saving with JPEG compression,
//          the JPEG quality setting applies with respect to EdsOptionRef.

function EdsCacheImage(inImageRef: TEdsImageRef; inUseCache: TEdsBool): TEdsError; stdcall; external 'EDSDK.dll';
//      Switches a setting on and off for creation of an image cache in the SDK
//          for a designated image object during extraction (processing) of
//          the image data.
//          Creating the cache increases the processing speed, starting from
//          the second time.

function EdsReflectImageProperty(inImageRef: TEdsImageRef): TEdsError; stdcall; external 'EDSDK.dll';
//      Incorporates image object property changes
//          (effected by means of EdsSetPropertyData) in the stream.

function EdsCreateEvfImageRef(inStreamRef: TEdsStreamRef; var outEvfImageRef: TEdsEvfImageRef): TEdsError; stdcall; external 'EDSDK.dll';
//       Creates an object used to get the live view image data set.

function EdsDownloadEvfImage(inCameraRef: TEdsCameraRef; inEvfImageRef: TEdsEvfImageRef): TEdsError; stdcall; external 'EDSDK.dll';
//	 Downloads the live view image data set for a camera currently in live view mode.
//	   Live view can be started by using the property ID:kEdsPropertyID_Evf_OutputDevice and
//	   data:EdsOutputDevice_PC to call EdsSetPropertyData.
//	   In addition to image data, information such as zoom, focus position, and histogram data
//	   is included in the image data set. Image data is saved in a stream maintained by EdsEvfImageRef.
//	   EdsGetPropertyData can be used to get information such as the zoom, focus position, etc.
//	   Although the information of the zoom and focus position can be obtained from EdsEvfImageRef,
//	   settings are applied to EdsCameraRef.

function EdsSetCameraAddedHandler(inCameraAddedHandler: TEdsCameraAddedHandler; inContext: TVoid): TEdsError; stdcall; external 'EDSDK.dll';
//       Registers a callback function for when a camera is detected.

function EdsSetPropertyEventHandler(inCameraRef: TEdsCameraRef; inEvent: TEdsPropertyEvent; inPropertyEventHandler: TEdsPropertyEventHandler; inContext: TVoid): TEdsError; stdcall; external 'EDSDK.dll';
//       Registers a callback function for receiving status
//          change notification events for property states on a camera.

function EdsSetObjectEventHandler(inCameraRef: TEdsCameraRef; inEvent: TEdsObjectEvent; inObjectEventHandler: TEdsObjectEventHandler; inContext: TVoid): TEdsError; stdcall; external 'EDSDK.dll';
//       Registers a callback function for receiving status
//          change notification events for objects on a remote camera.
//       Here, object means volumes representing memory cards, files and directories,
//          and shot images stored in memory, in particular.

function EdsSetCameraStateEventHandler(inCameraRef: TEdsCameraRef; inEvent: TEdsStateEvent; inStateEventHandler: TEdsStateEventHandler; inContext: TVoid): TEdsError; stdcall; external 'EDSDK.dll';
//       Registers a callback function for receiving status
//          change notification events for property states on a camera.

function EdsCreateStream(inStream: PEdsIStream; var outStreamRef: TEdsStreamRef): TEdsError; stdcall; external 'EDSDK.dll';

function EdsGetDCIMDirectory(inCameraRef: TEdsCameraRef; var outDirItemRef: TEdsDirectoryItemRef): TEdsError;
function EdsGetCurrentDir(inCameraRef: TEdsCameraRef; var outDirItemRef: TEdsDirectoryItemRef): TEdsError;
function EdsGetRecentFile(inCameraRef: TEdsCameraRef; var outDirItemRef: TEdsDirectoryItemRef): TEdsError;

function EdsFindTvIdx(ID: Integer): Integer;
function EdsFindAvIdx(ID: Integer): Integer;
function EdsFindISOIdx(ID: Integer): Integer;
function EdsFindIQIdx(ID: Integer): Integer;

implementation

function EdsGetDCIMDirectory(inCameraRef: TEdsCameraRef; var outDirItemRef: TEdsDirectoryItemRef): TEdsError;
var
  Volume: TEdsVolumeRef;
  Count: TEdsUInt32;
  Info: TEdsDirectoryItemInfo;
  i: Integer;
  Found: Boolean;
  s: string;
begin
  Result:=EdsGetChildCount(inCameraRef, Count);
  if (Result=EDS_ERR_OK) and (Count>0) then
   begin

    Result:=EdsGetChildAtIndex(inCameraRef, Count-1, Volume);
    if (Result=EDS_ERR_OK) and (Volume<>nil) then
     begin

      Result:=EdsGetChildCount(Volume, Count);
      if (Result=EDS_ERR_OK) and (Count>0) then
       begin

        i:=0; Found:=False; outDirItemRef:=nil;
        repeat

         Result:=EdsGetChildAtIndex(Volume, i, outDirItemRef);
         if (Result=EDS_ERR_OK) and (outDirItemRef<>nil) then
          begin

           Result:=EdsGetDirectoryItemInfo(outDirItemRef, Info);
           if Result=EDS_ERR_OK then
            begin
             s:=PChar(@Info.szFileName);
             Found:=(Info.isFolder) and (s='DCIM');
            end;

           if not Found then begin EdsRelease(outDirItemRef); outDirItemRef:=nil; end;
          end;

         i:=i+1;
        until Found or (i>=Count) or (Result<>EDS_ERR_OK);

        if not Found then Result:=EDS_ERR_DIR_NOT_FOUND;
       end;

      EdsRelease(Volume);
     end;

   end;
end;

function EdsGetCurrentDir(inCameraRef: TEdsCameraRef; var outDirItemRef: TEdsDirectoryItemRef): TEdsError;
var
  DCIMDir: TEdsDirectoryItemRef;
  Info: TEdsDirectoryItemInfo;
  Count: TEdsUInt32;
  i: Integer;
  Found: Boolean;
  s: string;
begin
  DCIMDir:=nil;
  Result:=EdsGetDCIMDirectory(inCameraRef, DCIMDir);
  if Result=EDS_ERR_OK then
   begin

    Result:=EdsGetChildCount(DCIMDir, Count);
    if (Result=EDS_ERR_OK) and (Count>0) then
     begin

      i:=Count-1; Found:=False; outDirItemRef:=nil;
      repeat

       Result:=EdsGetChildAtIndex(DCIMDir, i, outDirItemRef);
       if (Result=EDS_ERR_OK) and (outDirItemRef<>nil) then
        begin

         Result:=EdsGetDirectoryItemInfo(outDirItemRef, Info);
         if Result=EDS_ERR_OK then
          begin
           s:=PChar(@Info.szFileName[4]);
           Found:=Info.isFolder and (s='CANON');
          end;

         if not Found then begin EdsRelease(outDirItemRef); outDirItemRef:=nil; end;
        end else Result:=EDS_ERR_DIR_NOT_FOUND;

       i:=i-1;
      until Found or (i<0) or (Result<>EDS_ERR_OK);

      if not Found then Result:=EDS_ERR_DIR_NOT_FOUND;

     end else Result:=EDS_ERR_DIR_NOT_FOUND;

    EdsRelease(DCIMDir);
   end;
end;

function EdsGetRecentFile(inCameraRef: TEdsCameraRef; var outDirItemRef: TEdsDirectoryItemRef): TEdsError;
var
  LastDir: TEdsDirectoryItemRef;
  Info: TEdsDirectoryItemInfo;
  Count: TEdsUInt32;
  i: Integer;
  Found: Boolean;
begin
  Result:=EdsGetCurrentDir(inCameraRef, LastDir);
  if Result=EDS_ERR_OK then
   begin

    Result:=EdsGetChildCount(LastDir, Count);
    if (Result=EDS_ERR_OK) and (Count>0) then
     begin

      i:=Count-1; Found:=False; outDirItemRef:=nil;
      repeat

       Result:=EdsGetChildAtIndex(LastDir, i, outDirItemRef);
       if (Result=EDS_ERR_OK) and (outDirItemRef<>nil) then
        begin

         Result:=EdsGetDirectoryItemInfo(outDirItemRef, Info);

         if Result=EDS_ERR_OK then Found:=not Info.isFolder;

         if not Found then begin EdsRelease(outDirItemRef); outDirItemRef:=nil; end;
        end;

       i:=i-1;
      until Found or (i<0) or (Result<>EDS_ERR_OK);

      if not Found then Result:=EDS_ERR_FILE_NOT_FOUND;

     end else Result:=EDS_ERR_DIR_NOT_FOUND;

    EdsRelease(LastDir);
   end;
end;

function EdsFindTvIdx(ID: Integer): Integer;
var
  i: Integer;
begin
  Result:=-1; i:=Low(EdsTvTable);
  while (Result=-1) and (i<=High(EdsTvTable)) do
   begin
    if ID=EdsTvTable[i].ID then Result:=i;
    i:=i+1;
   end;
end;

function EdsFindAvIdx(ID: Integer): Integer;
var
  i: Integer;
begin
  Result:=-1; i:=Low(EdsAvTable);
  while (Result=-1) and (i<=High(EdsAvTable)) do
   begin
    if ID=EdsAvTable[i].ID then Result:=i;
    i:=i+1;
   end;
end;

function EdsFindISOIdx(ID: Integer): Integer;
var
  i: Integer;
begin
  Result:=-1; i:=Low(EdsISOTable);
  while (Result=-1) and (i<=High(EdsISOTable)) do
   begin
    if ID=EdsISOTable[i].ID then Result:=i;
    i:=i+1;
   end;
end;

function EdsFindIQIdx(ID: Integer): Integer;
var
  i: Integer;
begin
  Result:=-1; i:=Low(EdsIQTable);
  while (Result=-1) and (i<=High(EdsIQTable)) do
   begin
    if ID=EdsIQTable[i].ID then Result:=i;
    i:=i+1;
   end;
end;

end.
