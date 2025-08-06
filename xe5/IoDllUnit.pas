(*
    IoDllUnit:

    Illesztés az IO.DLL-ben foglalt eljárásokhoz és függvényekhez.
    Használatához: be kell venni a Uses szekcióba.

    Created By : Agócs László 2003.12.06. Delphi 5

*)

unit IoDllUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

  Procedure PortOut(Port:word; Data:Byte);stdcall;external 'io.dll';
  Procedure PortWordOut(Port:word; Data:word);stdcall;external 'io.dll';
  Procedure PortDWordOut(Port:word; Data:Dword);stdcall;external 'io.dll';
  Function  PortIn(Port:word):byte;stdcall;external 'io.dll';
  Function  PortWordIn(Port:word):word;stdcall;external 'io.dll';
  Function  PortDWordIn(Port:word):Dword;stdcall;external 'io.dll';
  Procedure SetPortBit(Port:word; Bit:Byte);stdcall;external 'io.dll';
  Procedure ClrPortBit(Port:word; Bit:Byte);stdcall;external 'io.dll';
  Procedure NotPortBit(Port:word; Bit:Byte);stdcall;external 'io.dll';
  Function  GetPortBit(Port:word; Bit:Byte): WordBool;stdcall;external 'io.dll';
  Function  LeftPortShift(Port:word; Val:WordBool): WordBool;stdcall;external 'io.dll';
  Function  RightPortShift(Port:word; Val:WordBool): WordBool;stdcall;external 'io.dll';
  Function  IsDriverInstalled : Boolean;stdcall;external 'io.dll';

implementation

end.
