unit GLLTexture;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OpenGL, Utils, StdCtrls,Jpeg;


type
 PPixelArray = ^TPixelArray;
 TPixelArray = array [0..0] of Byte;

 function CreateTextureFromJpegFile(Texture : String): cardinal;
 function CreateTextureFromBitmapFile(Texture : String): cardinal;

implementation

function CreateTextureFromBitmapFile(Texture : String): cardinal;
var
  BMInfo : TBitmapInfo;
  I, ImageSize : Integer;
  Temp : Byte;
  MemDC : HDC;
  Tex: PPixelArray;
  Bitmap : TBitmap;
begin
try
  Bitmap:=TBitmap.Create;
  Bitmap.LoadFromFile(Texture);

  glGenTextures(1, @Result);
  glBindTexture(GL_TEXTURE_2D, Result);

  with BMinfo.bmiHeader do begin
    FillChar (BMInfo, SizeOf(BMInfo), 0);
    biSize := sizeof (TBitmapInfoHeader);
    biBitCount := 24;
    biWidth := Bitmap.Width;
    biHeight := Bitmap.Height;;
    ImageSize := biWidth * biHeight;
    biPlanes := 1;
    biCompression := BI_RGB;

    MemDC := CreateCompatibleDC (0);
    GetMem (Tex, ImageSize *3);
    try
      GetDIBits (MemDC, Bitmap.Handle, 0, biHeight, Tex, BMInfo, DIB_RGB_COLORS);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,GL_NEAREST);
      glTexImage2d(GL_TEXTURE_2D, 0, 3, BiWidth, biHeight, 0, GL_BGR_EXT, GL_UNSIGNED_BYTE, tex);
      glEnable(GL_TEXTURE_2D);
      For I := 0 to ImageSize - 1 do begin
          Temp := tex [I * 3];
          tex [I * 3] := tex [I * 3 + 2];
          tex [I * 3 + 2] := Temp;
      end;
     finally
      DeleteDC (MemDC);
      freemem(tex);
      Bitmap.Free;
   end;
  end;
except
ShowMessage('Cannot create texture from file: '+Texture);
end;
end;

function CreateTextureFromJpegFile(Texture : String): cardinal;
var
  bitmap: TBitmap;
  BMInfo : TBitmapInfo;
  I, ImageSize : Integer;
  Temp : Byte;
  MemDC : HDC;
  Picture: TJpegImage;
  Tex: PPixelArray;
begin
try
  glGenTextures(1, @Result);
  glBindTexture(GL_TEXTURE_2D, Result);

  Bitmap:=TBitMap.Create;
  Picture:=TJpegImage.Create;

  Picture.LoadFromFile(Texture);
  Bitmap.Assign(Picture);
  with BMinfo.bmiHeader do begin
    FillChar (BMInfo, SizeOf(BMInfo), 0);
    biSize := sizeof (TBitmapInfoHeader);
    biBitCount := 24;
    biWidth := Picture.Width;
    biHeight := Picture.Height;
    ImageSize := biWidth * biHeight;
    biPlanes := 1;
    biCompression := BI_RGB;

    MemDC := CreateCompatibleDC (0);
    GetMem (Tex, ImageSize *3);
    try
      GetDIBits (MemDC, Bitmap.Handle, 0, biHeight, Tex, BMInfo, DIB_RGB_COLORS);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,GL_LINEAR);
      glTexImage2d(GL_TEXTURE_2D, 0, 3, biwidth, biheight, 0, GL_BGR_EXT, GL_UNSIGNED_BYTE, tex);
      glEnable(GL_TEXTURE_2D);
      For I := 0 to ImageSize - 1 do begin
          Temp := tex [I * 3];
          tex [I * 3] := tex [I * 3 + 2];
          tex [I * 3 + 2] := Temp;
      end;
     finally
      DeleteDC (MemDC);
      Bitmap.Free;
      Picture.Free;
      freemem(tex);
   end;
  end;
except
ShowMessage('Cannot create texture from file: '+Texture);
end;
end;

end.
