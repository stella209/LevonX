unit SerialComUnit;

// Serial communication component
//
// (c) PROPIX  Written by Pinter Gabor
// H-8000 Szekesfehervar, Krivanyi u. 15.
// Tel: +36 30 9972445, +36 22 300915
// Fax: +36 22 304326
// Email: propix@mail.datatrans.hu, Pinter.Gabor@freemail.hu
// Web: www.propix.hu, www.datatrans.hu/propix
//
// Revisions:
//  V5.01 11/21/2000  First release (shareware)

interface

uses
  Windows, Classes, SysUtils;


type
  TStopBits = (sbOneStopBit, sbOneHalfStopBits, sbTwoStopBits);
  TParity = (prNone, prOdd, prEven, prMark, prSpace);
  TDTRControl = (dtrNone, dtrFlow);
  TRTSControl = (rtsNone, rtsFlow, rtsDirection);
  TDataBits = 5..8;
  TBaudRate = Longword;
  TComError = (ceFrame, ceParity, ceOverrun, ceBreak);
  TComErrors= set of TComError;
  TEvent = (evRxChar, evRxFlag, evTxEmpty, evCTS, evDSR,  evDCD, evBreak, evError, evRing);
  TEvents = set of TEvent;

  TSerialCom = class(TComponent)
  private
    FComHandle: THandle;                                                        // Serial port file handle
    EventThread: TThread; // TComThread;                                        // Interrupt handler thread
    FConnected: Boolean;                                                        // Serial port open
    FPortNumber: Byte;                                                          // Serial port number
    FBaudRate: TBaudRate;                                                       // Baud rate
    FDataBits: TDataBits;                                                       // Data bits
    FParity: TParity;                                                           // Parity
    FStopBits: TStopBits;                                                       // Stop bits
    FDTRControl: TDTRControl;                                                   // Automatic DTR control function
    FRTSControl: TRTSControl;                                                   // Automatic RTS control function
    FXONXOFFControl: Boolean;                                                   // XON/XOFF flow control
    FDTRState: Boolean;                                                         // DTR state if DTR is not automatic
    FRTSState: Boolean;                                                         // RTS state if RTS is not automatic
    FTxBreak: Boolean;                                                          // Transmit break
    FRxBufSize: Integer;                                                        // Receive buffer size
    FTxBufSize: Integer;                                                        // Transmit buffer size
    FRxToInterval: Longword;                                                    // Receive timeout between bytes
    FRxToMulti: Longword;                                                       // Receive timeout by number of bytes
    FRxToConstant: Longword;                                                    // Receive timeout additional time
    FTxToMulti: Longword;                                                       // Transmit timeout by number of bytes
    FTxToConstant: Longword;                                                    // Transmit timeout additional time
    FEvents: TEvents;                                                           // Interrupt mask
    FOnRxChar: TNotifyEvent;                                                    // Receive buffer is not empty event
    FOnTxEmpty: TNotifyEvent;                                                   // Transmit buffer is empty event
    FOnRxBreak: TNotifyEvent;                                                   // Start of break received event
    FOnRI: TNotifyEvent;                                                        // RI rising edge detected event
    FOnCTS: TNotifyEvent;                                                       // CTS changed state event
    FOnDSR: TNotifyEvent;                                                       // DSR changed state event
    FOnDCD: TNotifyEvent;                                                       // DCD changed state event
    FOnError: TNotifyEvent;                                                     // Receive error event
    FOnOpen: TNotifyEvent;                                                      // After port opened event
    FOnClose: TNotifyEvent;                                                     // Before port closed event
    function GetRxQue: Integer;                                                 // Get property RxQue
    function GetTxQue: Integer;                                                 // Get property TxQue
    procedure SetDTRState(Value: Boolean);                                      // Set property DTRState
    procedure SetRTSState(Value: Boolean);                                      // Set property RTSState
    function GetCTSState: Boolean;                                              // Get property CTSState
    function GetDSRState: Boolean;                                              // Get property DSRState
    function GetDCDState: Boolean;                                              // Get property DCDState
    function GetRIState: Boolean;                                               // Get property RIState
    procedure SetTxBreak(Value: Boolean);                                       // Set property TxBreak
    function ComString: String;                                                 // Make serial port file name
    procedure CreateHandle;                                                     // Open serial port file
    procedure DestroyHandle;                                                    // Close serial port file
    function ValidHandle: Boolean;                                              // Test if ComHandle is valid
    function GetComErrors: TComErrors;                                          // Get property ComErrors
    procedure SetEvents(Value: TEvents);
    procedure SetConnected(const Value: Boolean);                                        // Set property Events
  protected
    procedure Setup;                                                            // Setup port parameters
    property ComHandle: THandle read FComHandle;                                // Serial port file handle
  published
    property Port: Byte read FPortNumber write FPortNumber;                     // Serial port number
    property BaudRate: TBaudRate read FBaudRate write FBaudRate;                // Baud rate
    property DataBits: TDataBits read FDataBits write FDataBits;                // Data bits
    property Parity: TParity read FParity write FParity;                        // Parity
    property StopBits: TStopBits read FStopBits write FStopBits;                // Stop bits
    property Connected: Boolean read FConnected write SetConnected;                                // Serial port is open
    property ComErrors: TComErrors read GetComErrors;                           // Report errors
    procedure Open;                                                             // Open serial port
    procedure Close;                                                            // Close serial port
    property RxQue: Integer read GetRxQue;                                      // Number of bytes in receive bufffer
    property TxQue: Integer read GetTxQue;                                      // Number of bytes in transmit buffer
    property RxBufSize: Integer read FRxBufSize write FRxBufSize;               // Receive buffer size
    property TxBufSize: Integer read FTxBufSize write FTxBufSize;               // Transmit buffer size
    property RxToInterval: Longword read FRxToInterval write FRxToInterval;	// Receive timeout between bytes
    property RxToMulti: Longword read FRxToMulti write FRxToMulti;		// Receive timeout by number of bytes
    property RxToConstant: Longword read FRxToConstant write FRxToConstant;	// Receive timeout additional time
    property TxToMulti: Longword read FTxToMulti write FTxToMulti;		// Transmit timeout by number of bytes
    property TxToConstant: Longword read FTxToConstant write FTxToConstant;	// Transmit timeout additional time
    property Events: TEvents read FEvents write SetEvents;			// Interrupt events
    property OnRxChar: TNotifyEvent read FOnRxChar write FOnRxChar;		// Receive buffer is not empty event
    property OnTxEmpty: TNotifyEvent read FOnTxEmpty write FOnTxEmpty;		// Transmit buffer is empty event
    property OnRxBreak: TNotifyEvent read FOnRxBreak write FOnRxBreak;		// Start of break received event
    property OnRI: TNotifyEvent read FOnRI write FOnRI;				// RI rising edge detected event
    property OnCTS: TNotifyEvent read FOnCTS write FOnCTS;			// CTS changed state event
    property OnDSR: TNotifyEvent read FOnDSR write FOnDSR;			// DSR changed state event
    property OnDCD: TNotifyEvent read FOnDCD write FOnDCD;			// DCD changed state event
    property OnError: TNotifyEvent read FOnError write FOnError;		// Receive error event
    property OnOpen: TNotifyEvent read FOnOpen write FOnOpen;			// After port opened event
    property OnClose: TNotifyEvent read FOnClose write FOnClose;		// Before port closed event
    property DTRControl: TDTRControl read FDTRControl write FDTRControl;	// Automatic DTR functions
    property RTSControl: TRTSControl read FRTSControl write FRTSControl;        // Automatic RTS functions
    property XONXOFFControl: Boolean read FXONXOFFControl write FXONXOFFControl;// XON/XOFF control
    property DTRState: Boolean read FDTRState write SetDTRState;	        // Control DTR line if not automatic
    property RTSState: Boolean read FRTSState write SetRTSState;		// Control RTS line if not automatic
    property CTSState: Boolean read GetCTSState;				// Get CTS line state
    property DSRState: Boolean read GetDSRState;				// Get DSR line state
    property DCDState: Boolean read GetDCDState;				// Get DCD line state
    property RIState: Boolean read GetRIState;					// Get RI line state
    property TxBreak: Boolean read FTxBreak write SetTxBreak;			// Send transmit break
    function Write(var Buffer; Count: Integer): Integer;			// Write data to transmit FIFO
    function WriteString(Str: String): Integer;					// Write data to transmit FIFO 2
    function Read(var Buffer; Count: Integer): Integer;				// Read data from receive FIFO
    function ReadString(var Str: String; Count: Integer): Integer;		// Read data from receive FIFO 2
    procedure RxPurge;								// Clear receive FIFO
    procedure TxPurge;								// Clear transmit FIFO
    constructor Create(AOwner: TComponent); override;                           // Create
    destructor Destroy; override;                                               // Destroy
  end;

  EComError  = class(Exception);						// Any error in TSerialCom
  EComOpen   = class(EComError);						// File open error
  EComState  = class(EComError);						// Cannot set contol line state error
  EComWrite  = class(EComError);						// Data write error
  EComRead   = class(EComError);						// Data read error
  EComStatus = class(EComError);						// Cannot read status
  EComPurge  = class(EComError);						// Cannot clear FIFO error

procedure Register;								// Register component

implementation

type
  TComThread = class(TThread)							// Interrupt handler thread
  private
    Owner: TSerialCom;								// Serial port component
    Mask: DWORD;								// Happened events
  protected
    procedure Execute; override;						// Interrupt wait loop
    procedure DoEvents;								// Execute event handlers
  public
    constructor Create(AOwner: TSerialCom);					// Create
    destructor Destroy; override;						// Destroy
  end;


const
  dcbfBinary           =  0;							// WinAPI control bits
  dcbfParity           =  1;
  dcbfOutxCtsFlow      =  2;
  dcbfOutxDsrFlow      =  3;
  dcbfDtrControl       =  4;
  dcbfDsrSensivity     =  6;
  dcbfTXContinueOnXOff =  7;
  dcbfOutX             =  8;
  dcbfInX              =  9;
  dcbfErrorChar        = 10;
  dcbfNull             = 11;
  dcbfRtsControl       = 12;
  dcbfAbortOnError     = 14;


//----------------------------------------------------------------------------------------------------------------------
// TComThread interrupt handler


// Create and start
constructor TComThread.Create(AOwner: TSerialCom);
begin
  inherited Create(True);         						// Create suspended
  Owner:= AOwner;
  Priority:= tpTimeCritical;                                                    // Highest priority
  Resume;									// Run
end;


// Get and execute interrupt
procedure TComThread.Execute;
var
  Status: Boolean;
begin
  repeat
    Status:= WaitCommEvent(Owner.ComHandle, Mask, nil);				// Wait for interrupt
    if Status then DoEvents;							// Execute events
  until Terminated;								// Terminate if requested
end;


// Reset interrupt
destructor TComThread.Destroy;
begin
  Terminate;                       						// Request terminate
  SetCommMask(Owner.ComHandle, 0); 						// Exit WaitCommEvent
  inherited Destroy;               						// Wait for terminate and destroy
end;


// Interrupt routines
// Executed in main thread
procedure TComThread.DoEvents;
begin

  // Clear errors automatically
  if ((EV_ERR and Mask)<>0) or ((EV_BREAK and Mask)<>0) then
  begin 									// Clear errors
    Owner.ComErrors;
  end;

  // Execute event handlers
  if ((EV_ERR and Mask)<>0)     and Assigned(Owner.FOnError)   then Owner.FOnError(Owner);
  if ((EV_BREAK and Mask)<>0)   and Assigned(Owner.FOnRxBreak) then Owner.FOnRxBreak(Owner);
  if ((EV_RXCHAR and Mask)<>0)  and Assigned(Owner.FOnRxChar)  then Owner.FOnRxChar(Owner);
  if ((EV_TXEMPTY and Mask)<>0) and Assigned(Owner.FOnTxEmpty) then Owner.FOnTxEmpty(Owner);
  if ((EV_RING and Mask)<>0)    and Assigned(Owner.FOnRI)      then Owner.FOnRI(Owner);
  if ((EV_CTS and Mask)<>0)     and Assigned(Owner.FOnCTS)     then Owner.FOnCTS(Owner);
  if ((EV_DSR and Mask)<>0)     and Assigned(Owner.FOnDSR)     then Owner.FOnDSR(Owner);
  if ((EV_RLSD and Mask)<>0)    and Assigned(Owner.FOnDCD)     then Owner.FOnDCD(Owner);

end;


//----------------------------------------------------------------------------------------------------------------------
// TSerialCom serial port interface


// Create and initialize
constructor TSerialCom.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FConnected:= False;
  FBaudRate:= 9600;
  FParity:= prNone;
  FPortNumber:= 1;
  FStopBits:= sbOneStopBit;
  FDataBits:= 8;
  FDTRControl:= dtrNone;
  FDTRState:= True;
  FRTSControl:= rtsNone;
  FRTSState:= True;
  FTxBufSize:= 256;
  FRxBufSize:= 2048;
  FComHandle:= INVALID_HANDLE_VALUE;
  //FRxToInterval:= 0;
  //FRxToMulti:= 0;
  //FRxToConstant:= 0;
  //FTxToMulti:= 0;
  //FTxToConstant:= 0;
  //Events:= [];
end;


// Close and destroy
destructor TSerialCom.Destroy;
begin
  Close;                                                                        // Close and destroy interrupt handler
  inherited Destroy;
end;


// Serial port system name
function TSerialCom.ComString: String;
begin
  Result:= '\\.\COM'+IntToStr(FPortNumber);					// Good for >COM9 too
end;


// Check handle
function TSerialCom.ValidHandle: Boolean;
begin
  Result:= ComHandle <> INVALID_HANDLE_VALUE;
end;


// Open file for serial port
procedure TSerialCom.CreateHandle;
begin
  FComHandle:= CreateFile(
    PChar(ComString),
    GENERIC_READ or GENERIC_WRITE,
    0,
    nil,
    OPEN_EXISTING,
    0,
    0);
//  if not ValidHandle then
//    raise EComOpen.Create('Unable to open serial port');
end;


// Close file for serial port
procedure TSerialCom.DestroyHandle;
begin
  if ValidHandle then CloseHandle(ComHandle);
  FComHandle:= INVALID_HANDLE_VALUE;
end;


// Open serial port
procedure TSerialCom.Open;
begin
  Close;                                   					// Reopen?
  CreateHandle;                            					// Create file handle
  EventThread:= TComThread.Create(Self);   					// Create interrupt handler
  Setup;                                   					// Set parameters
  FConnected:= True;                       					// Port is open
  if FTxBreak then TxBreak:= FTxBreak;     					// Execute pending break
  if Assigned(FOnOpen) then FOnOpen(Self);					// Execute OnOpen event handler
end;


// Cose serial port
procedure TSerialCom.Close;
begin
  if FConnected then begin							// If open
    if Assigned(FOnClose) then FOnClose(Self);					// Execute OnClose event handler
    EventThread.Free;                           				// Release interrupt handler
    FConnected:= False;                         				// Port is closed
  end;
  DestroyHandle;								// Close file
end;


// Setup serial port parameters
procedure TSerialCom.Setup;
var
  DCB: TDCB;
  Timeouts: TCommTimeouts;
begin

  // Main parameters
  GetCommState(FComHandle, DCB);
  DCB.BaudRate:= FBaudRate;
  DCB.Flags:= (1 shl dcbfBinary) or (1 shl dcbfParity) or (1 shl dcbfTXContinueOnXoff);
  if (FDTRControl=dtrFlow) then DCB.Flags:= DCB.Flags or (1 shl dcbfOutxDsrFlow);
  if (FRTSControl=rtsFlow) then DCB.Flags:= DCB.Flags or (1 shl dcbfOutxCtsFlow);
  case FDTRControl of
    dtrNone: if FDTRState then DCB.Flags:= DCB.Flags or (DTR_CONTROL_ENABLE shl dcbfDtrControl)
                          else DCB.Flags:= DCB.Flags or (DTR_CONTROL_DISABLE shl dcbfDtrControl);
    dtrFlow: DCB.Flags:= DCB.Flags or (DTR_CONTROL_HANDSHAKE shl dcbfDtrControl);
  end;
  if FXONXOFFControl then DCB.Flags:= DCB.Flags or (1 shl dcbfOutX) or (1 shl dcbfInX);
  case FRTSControl of
    rtsNone: if FRTSState then DCB.Flags:= DCB.Flags or (RTS_CONTROL_ENABLE shl dcbfRtsControl)
                          else DCB.Flags:= DCB.Flags or (RTS_CONTROL_DISABLE shl dcbfRtsControl);
    rtsFlow: DCB.Flags:= DCB.Flags or (RTS_CONTROL_HANDSHAKE shl dcbfRtsControl);
    rtsDirection: DCB.Flags:= DCB.Flags or (RTS_CONTROL_TOGGLE shl dcbfRtsControl);
  end;
  DCB.XonLim:= FRxBufSize div 4;
  DCB.XoffLim:= FRxBufSize div 4;
  DCB.ByteSize:= FDataBits;
  case FParity of
    prNone:  DCB.Parity:= NOPARITY;
    prOdd:   DCB.Parity:= ODDPARITY;
    prEven:  DCB.Parity:= EVENPARITY;
    prMark:  DCB.Parity:= MARKPARITY;
    prSpace: DCB.Parity:= SPACEPARITY;
  end;
  case FStopBits of
    sbOneStopBit:      DCB.StopBits:= ONESTOPBIT;
    sbOneHalfStopBits: DCB.StopBits:= ONE5STOPBITS;
    sbTwoStopBits:     DCB.StopBits:= TWOSTOPBITS;
  end;
  DCB.XonChar:= #17;
  DCB.XoffChar:= #19;
  if not SetCommState(ComHandle, DCB) then
    raise EComState.Create('Unable to set parameters of serial port');

  // Timeouts
  GetCommTimeouts(ComHandle, Timeouts);
  Timeouts.ReadIntervalTimeout:= FRxToInterval;
  Timeouts.ReadTotalTimeoutMultiplier:= FRxToMulti;
  Timeouts.ReadTotalTimeoutConstant:= FRxToConstant;
  Timeouts.WriteTotalTimeoutMultiplier:= FTxToMulti;
  Timeouts.WriteTotalTimeoutConstant:= FTxToConstant;
  if not SetCommTimeouts(ComHandle, Timeouts) then
    raise EComState.Create('Unable to set timeouts of serial port');

  // Buffer size
  if not SetupComm(ComHandle, FRxBufSize, FTxBufSize) then
    raise EComState.Create('Unable to allocate buffers for serial port');

  // Set interrupt mask
  SetEvents(Events);

end;


// Read error flags
function TSerialCom.GetComErrors: TComErrors;
var
  Errors: DWORD;
begin
  Result:= [];
  if FConnected then
  begin
    ClearCommError(ComHandle, Errors, nil);
    if 0<>(Errors and CE_FRAME)     then Result:= Result + [ceFrame];
    if 0<>(Errors and CE_RXPARITY)  then Result:= Result + [ceParity];
    if 0<>(Errors and CE_OVERRUN)   then Result:= Result + [ceOverrun];
    if 0<>(Errors and CE_BREAK)     then Result:= Result + [ceBreak];
  end;
end;


// Set events mask and enable corresponding interrupts
procedure TSerialCom.SetEvents(Value: TEvents);
var
  AMask: Integer;
begin
  FEvents:= Value;
  if ValidHandle then								// If port is open
  begin										// Translate interrupt mask
    AMask:= 0;
    if evRxChar  in FEvents then AMask:= AMask or EV_RXCHAR;
    if evTxEmpty in FEvents then AMask:= AMask or EV_TXEMPTY;
    if evError   in FEvents then AMask:= AMask or EV_ERR;
    if evRing    in FEvents then AMask:= AMask or EV_RING;
    if evBreak   in FEvents then AMask:= AMask or EV_BREAK;
    if evCTS     in FEvents then AMask:= AMask or EV_CTS;
    if evDSR     in FEvents then AMask:= AMask or EV_DSR;
    if evDCD     in FEvents then AMask:= AMask or EV_RLSD;
    SetCommMask(ComHandle, AMask);						// Set interrupt mask
  end;
end;


// Set DTR if not automatic
procedure TSerialCom.SetConnected(const Value: Boolean);
begin
  FConnected := Value;
  if FConnected then Open
  else Close;
end;

procedure TSerialCom.SetDTRState(Value: Boolean);
var
  Control: DWORD;
begin
  if FConnected then
    begin
      if FDTRControl=dtrNone then
      begin
        FDTRState:= Value;
        if Value then Control:= SETDTR else Control:= CLRDTR;
        if not EscapeCommFunction(FComHandle, Control) then
          raise EComStatus.Create('Unable to control serial port');
      end;
    end
  else FDTRState:= Value;
end;


// Set RTS if not automatic
procedure TSerialCom.SetRTSState(Value: Boolean);
var
  Control: DWORD;
begin
  if FConnected then
    begin
      if FRTSControl=rtsNone then
      begin
        FRTSState:= Value;
        if Value then Control:= SETRTS else Control:= CLRRTS;
        if not EscapeCommFunction(FComHandle, Control) then
          raise EComStatus.Create('Unable to control serial port');
      end;
    end
  else FRTSState:= Value;
end;


// Get CTS
function TSerialCom.GetCTSState: Boolean;
var
  Status: DWORD;
begin
 Result:=False;
 if Connected then
  begin
  GetCommModemStatus(FComHandle, Status);
  Result:= ((Status and MS_CTS_ON) <> 0);
  end;
end;


// Get DSR
function TSerialCom.GetDSRState: Boolean;
var
  Status: DWORD;
begin
 Result:=False;
 if Connected then
  begin
  GetCommModemStatus(FComHandle, Status);
  Result:= ((Status and MS_DSR_ON) <> 0);
  end;
end;


// Get DCD
function TSerialCom.GetDCDState: Boolean;
var
  Status: DWORD;
begin
 Result:=False;
 if Connected then
  begin
  GetCommModemStatus(FComHandle, Status);
  Result:= ((Status and MS_RLSD_ON) <> 0);
  end;
end;


// Get RI
function TSerialCom.GetRIState: Boolean;
var
  Status: DWORD;
begin
 Result:=False;
 if Connected then
  begin
  GetCommModemStatus(FComHandle, Status);
  Result:= ((Status and MS_RING_ON) <> 0);
  end;
end;


// Set or clear break
procedure TSerialCom.SetTxBreak(Value: Boolean);
var
  Control: DWORD;
begin
  if FConnected then
    begin
      FTxBreak:= Value;
      if Value then Control:= SETBREAK else Control:= CLRBREAK;
      if not EscapeCommFunction(FComHandle, Control) then
        raise EComStatus.Create('Unable to control serial port');
    end
  else FTxBreak:= Value;
end;


// Number of bytes in receive FIFO
function TSerialCom.GetRxQue: Integer;
var
  Errors: DWORD;
  ComStat: TComStat;
begin
 Result:=0;
 if Connected then
  begin
  if not ClearCommError(ComHandle, Errors, @ComStat) then
    raise EComStatus.Create('Unable to read status of serial port');
  Result:= ComStat.cbInQue;
  end;
end;


// Number of bytes in transmit FIFO
function TSerialCom.GetTxQue: Integer;
var
  Errors: DWORD;
  ComStat: TComStat;
begin
 Result:=0;
 if Connected then
  begin
  if not ClearCommError(ComHandle, Errors, @ComStat) then
    raise EComStatus.Create('Unable to read status of serial port');
  Result:= ComStat.cbOutQue;
  end;
end;


// Write data
function TSerialCom.Write(var Buffer; Count: Integer): Integer;
var
  BytesWritten: DWORD;
begin
  if not WriteFile(FComHandle, Buffer, Count, BytesWritten, nil) then
    raise EWriteError.Create('Unable to write serial port');
  Result:= BytesWritten;
end;

// Write data
function TSerialCom.WriteString(Str: String): Integer;
begin
  Result:= Write(Str[1], Length(Str));
end;

// Read data
function TSerialCom.Read(var Buffer; Count: Integer): Integer;
var
  BytesRead: DWORD;
begin
  if not ReadFile(FComHandle, Buffer, Count, BytesRead, nil) then
    raise EWriteError.Create('Unable to read serial port');
  Result:= BytesRead;
end;

// Read data
function TSerialCom.ReadString(var Str: String; Count: Integer): Integer;
begin
  SetLength(Str, Count);
  Result:= Read(Str[1], Count);
  SetLength(Str, Result);
end;

// Clear input buffer
procedure TSerialCom.RxPurge;
begin
  if not PurgeComm(FComHandle, PURGE_RXABORT or PURGE_RXCLEAR) then
    raise EComPurge.Create('Unable to purge serial port');
end;

// Clear output buffer
procedure TSerialCom.TxPurge;
begin
  if not PurgeComm(FComHandle, PURGE_TXABORT or PURGE_TXCLEAR) then
    raise EComPurge.Create('Unable to purge serial port');
end;


//----------------------------------------------------------------------------------------------------------------------
// Component specific

// Register component
procedure Register;
begin
  RegisterComponents('Propix', [TSerialCom]);
end;

end.
