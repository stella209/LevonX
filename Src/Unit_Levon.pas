unit Unit_Levon;

interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  STAF_Imp, IniFiles,
  DeLaFitsCommon,
  DeLaFitsString,
  DeLaFitsGraphics,
  DeLaFitsMath;
//  FreeUtils, FreeImage, Math;

Type
    // Kép jellemzõk tárolására
    TPictureParams = record
       CR2RAW_JPG    : boolean; // True: RAW kép betöltés; False: embedded JPG
    end;

var
    defaultDir  : string;
    SablonDir   : string;
    iniFile     : TInifile;
    langFile    : TInifile;        // *.lng (Hun.lng)
    lFile       : TIniFile;
    iniFileName : string;          // program paraméreknek
    langFileName : string;         // Nyelvi paraméterek (Caption, Hint)
    oldLanguage  : string;         // Elõzõ nyelv
    picdir       : string;         // Utoljára megnyitott kép könyvtára
    ShutDownAfter: boolean = False;// Kilépéskor sz.gép kikapcsolása

    PictureParams : TPictureParams;// Kép jellemzõk

    VersionPrg  : string = 'StyCut ';
    VersionStr  : string = '3.0 ';

function  LoadImageFromFile(const FileName: string; Bmp: TBitmap): Boolean;
procedure LoadWICImage(fn: string; bmp: TBitmap);
//procedure LoadFreeImage(fn: string; bmp: TBitmap);
function  LoadFITImage(const FileName: string; Bmp: TBitmap): Boolean;

procedure ContrastStretch(bmp: TBitmap);
function GetRAWTHumbnail(const FileName: string; Bmp: TBitmap): Boolean;
procedure GrayAWB(bmp: TBitmap);

implementation

function LoadImageFromFile(const FileName: string; Bmp: TBitmap): Boolean;
var
  ext: string;
begin
  Screen.Cursor := crHourGlass;
  ext := UpperCase(ExtractFileExt(FileName));
  if (ext='.FIT') OR (ext='.FITS') then
     LoadFITImage(FileName,BMP)
  ELSE
     LoadWICImage(FileName,BMP);
  Screen.Cursor := crDefault;
end;

procedure LoadWICImage(fn: string; bmp: TBitmap);
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
(*
procedure LoadFreeImage(fn: string; bmp: TBitmap);
Var
   t : FREE_IMAGE_FORMAT;
   dib48,dib: PFIBITMAP;
   PBI: PBITMAPINFO;
   W,H: INTEGER;
   Ext: string;
begin
    t := FreeImage_GetFileType(PAnsiChar(AnsiString(fn)), 16);

    if t = FIF_UNKNOWN then
    begin
      // Check for types not supported by GetFileType
      Ext := UpperCase(ExtractFileExt(fn));
      if (Ext = '.TGA') or(Ext = '.TARGA') then
        t := FIF_TARGA
      else if Ext = '.MNG' then
        t := FIF_MNG
      else if Ext = '.PCD' then
        t := FIF_PCD
      else if Ext = '.WBMP' then
        t := FIF_WBMP
      else if Ext = '.CUT' then
        t := FIF_CUT
      else if Ext = '.CR2' then
        t := FIF_RAW
      else if Ext = '.CRW' then
        t := FIF_RAW
      else
        raise Exception.Create('The file "' + fn + '" cannot be displayed because SFM does not recognise the file type.');
    end;

     BMP.PixelFormat := pf24bit;
     dib48 := Freeimage_loadU(t,PWideChar(fn),0);
     dib := FreeImage_ConvertTo24Bits(Dib48);
     w := Freeimage_getWidth(dib);
     h := Freeimage_getHeight(dib);
     PBI:=Freeimage_Getinfo(dib);
     bmp.Width := w;
     bmp.Height := h;
     SetStretchBltMode(bmp.Canvas.handle, COLORONCOLOR);
     StretchDIBits(bmp.Canvas.handle, 0, 0, w, h, 0, 0, w, h,
     FreeImage_GetBits(dib), PBI^, DIB_RGB_COLORS, SRCCOPY);
end;
*)

function LoadFITImage(const FileName: string; Bmp: TBitmap): Boolean;
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

function GetRAWTHumbnail(const FileName: string; Bmp: TBitmap): Boolean;
begin

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
  rgbAVG := GetBMPAverage( bmp, 200 );
  corrR  := rgbAVG.G / rgbAVG.R;
  corrB  := rgbAVG.G / rgbAVG.B;

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

initialization
  defaultDir:=ExtractFilePath(Application.Exename);
  iniFileName := defaultDir+ChangeFileExt(ExtractFileName(Application.Exename),'.ini');
  if IniFile=nil then
     iniFile := TInifile.Create(iniFileName);
  langFileName := defaultDir+'Language.lng';
  if langFile=nil then
     langFile := TInifile.Create(langFileName);
  lFile:= langFile;

finalization
  if IniFile<>nil then
     iniFile.Free;
  if langFile<>nil then
     langFile.Free;
end.
