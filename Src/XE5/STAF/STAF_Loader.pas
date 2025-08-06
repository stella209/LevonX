unit STAF_Loader;

interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  STAF_Imp, JpegDec,
  DeLaFitsCommon,
  DeLaFitsString,
  DeLaFitsGraphics,
  DeLaFitsMath;
//  FreeUtils, FreeImage, Math;

Const
      Version = '1.9';

function  LoadImageFromFile(const FileName: string; var Bmp: TBitmap): Boolean;
procedure LoadWICImage(fn: string; var bmp: TBitmap);
procedure LoadJPG(fName: string; var BMP: TBitmap);
function  LoadFITImage(const FileName: string; var Bmp: TBitmap): Boolean;
function  GetRAWTHumbnail(const FileName: string; var Bmp: TBitmap): Boolean;

procedure ContrastStretch(bmp: TBitmap);
procedure GrayAWB(bmp: TBitmap);

implementation

function LoadImageFromFile(const FileName: string; var Bmp: TBitmap): Boolean;
var
  ext: string;
begin
Try
  Result := True;
  Screen.Cursor := crHourGlass;
  ext := UpperCase(ExtractFileExt(FileName));
  if (ext='.FIT') OR (ext='.FITS') then
     LoadFITImage(FileName,BMP)
  ELSE
     LoadWICImage(FileName,BMP);
except
  Result := False;
End;
  Screen.Cursor := crDefault;
end;

procedure LoadWICImage(fn: string; var bmp: TBitmap);
var
  W: TWICImage;
begin
  W:= TWicImage.Create;
  try
    Try
      W.LoadFromFile(fn);
    Except
      W.LoadFromFile(fn);
    End;
    if Bmp=nil then
    Bmp:= TBitmap.Create;
    Bmp.Assign(W);
    BMP.PixelFormat := pf24bit;
  finally
    W.Free;
  end;
end;

function LoadFITImage(const FileName: string; var Bmp: TBitmap): Boolean;
Var
    FFit: TFitsFileBitmap;
begin
Try
     FFit := TFitsFileBitmap.CreateJoin(FileName, cFileRead);
     FFit.BitmapRead(BMP);
finally
     FFit.Free;
End;
end;

function GetRAWTHumbnail(const FileName: string; var Bmp: TBitmap): Boolean;
Type
    TJPGInf = record
            jpgStartPosition : INTEGER;
            orientation      : INTEGER;
            fileSize         : INTEGER;
    end;

var FS: TFileStream;
    JI : TJPGInf;
    Buffer: PByte;
    bytesRead: integer;

begin
Try
  Result := False;
//  Bmp.Canvas.Lock;
  Bmp.PixelFormat := pf24bit;
  FS := TFileStream.Create(FileName,fmOpenRead);
  // Start address is at offset 0x62, file size at 0x7A,
  // orientation at 0x6E
  FS.Seek(98,0);
  FS.Read(JI.jpgStartPosition,4);
  FS.Seek(110,0);
  FS.Read(JI.orientation,4);
  FS.Seek(122,0);
  FS.Read(JI.fileSize,4);
  FS.Seek(JI.jpgStartPosition,0);
  GetMem(Buffer, JI.fileSize);
  try
     bytesRead:=FS.Read(Buffer^,JI.fileSize);
     if bytesRead>0 then
        Bmp := JpegDecode(Buffer,bytesRead);
  finally
     FreeMem(Buffer);
  end;
Finally
  FS.Free;
//  Bmp.Canvas.UnLock;
  Result := True;
End;
end;

procedure LoadJPG(fName: string; var BMP: TBitmap);
begin
  with TMemoryStream.Create do
  try
    LoadFromFile(fName); //Sample Pictures\Tree.jpg');
    Bmp := JpegDecode(Memory,Size);
  finally
    Free;
  end;
end;

//============== White Ballance Routines =========================

procedure ContrastStretch(bmp: TBitmap);
Var xx,yy: integer;
    Row_:^TRGBTriple;
    minV, maxV: TRGBTriple;

     function remap(v, minVaue, maxValue: longint): byte;
     begin
       Result := FloatToByte((v-minVaue) * 1.0/(maxValue-minVaue));
     end;

begin
     GetBMPMinMax( bmp, minV, maxV );
     ChangeRGBColor(maxV,200,200,200);
     ChangeRGBColor(minV,20,20,20);
     for yy:=0 to bmp.height-1 do begin
         Row_:= bmp.ScanLine[yy];
         for xx:=0 to bmp.width-1 do begin
             Row_.rgbtRed   := remap(Row_.rgbtRed,   minV.rgbtRed, maxV.rgbtRed);
             Row_.rgbtGreen := remap(Row_.rgbtGreen, minV.rgbtGreen, maxV.rgbtGreen);
             Row_.rgbtBlue  := remap(Row_.rgbtBlue,  minV.rgbtBlue, maxV.rgbtBlue);
             Inc(Row_);
         end;
     end;
end;

//contrast_stretch()


// Auto White Ballance: Gray World Theory
procedure GrayAWB(bmp: TBitmap);
VAR rgbAVG: TRGB24;
    Row   :^TRGBTripleArray;
    x,y   : integer;
    corrR : double;
    corrB : double;
begin
//  rgbAVG := GetBMPMax( bmp, 255 );
  rgbAVG := GetBMPAverage( bmp, 255 );
  corrR  := rgbAVG.R / rgbAVG.G;
  corrB  := rgbAVG.B / rgbAVG.G;

  for y:=0 to (bmp.height-1) do begin
    Row:=bmp.scanline[y];
    for x:=0 to (bmp.width-1) do begin
      WITH Row[x] DO
      BEGIN
         rgbtRed   := FloatToByte( rgbtRed * corrR );
         rgbtBlue  := FloatToByte( rgbtBlue * corrB );
      END;
    end;
  end;

end;

end.
