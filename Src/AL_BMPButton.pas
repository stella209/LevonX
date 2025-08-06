unit AL_BMPButton;

//  TALBMPButton
//  Developed by Agocs László
//            Based on tiaonImageButton
//            http://stella.kojot.co.hu/

//  Description:  tiaonImageButton allows you assign images to over,
//                down and disabled status. Much like a web image.
//                Depend on what picture format you have installed
//                tiaonImageButton will support all.
//                If you cannot load GIF images, you can download
//                RxLib.
//  Create by William Yang
//  for contact info please find it below
//  http://www.tiaon.com/wordpress
//  Last Update: 28/07/2007
//

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type

  THAlignment = (haNone, haLeft, haRight, haCenter);
  TVAlignment = (vaNone, vaTop, vaBottom, vaCenter);

  TImageAlign = (iaNone, iaCenter, iaLeft, iaRight, iaTop, iaBottom,
                 iaToButton, iaToBitmap, iaTitle);

  T_Bitmaps = class(Tpersistent)
  private
    FImage: TPicture;
    FTransparentColor: TColor;
    FOverImage: TPicture;
    fDisableImage: TPicture;
    FDownImage: TPicture;
    FOnChange: TNotifyEvent;
    FImageAlign: TImageAlign;
    FEnableInvert: boolean;
    procedure Changed;
    procedure SetDisableImage(const Value: TPicture);
    procedure SetDownImage(const Value: TPicture);
    procedure SetImage(const Value: TPicture);
    procedure SetOverImage(const Value: TPicture);
    procedure SetTransparentColor(const Value: TColor);
    procedure SetImageAlign(const Value: TImageAlign);
  published
    constructor Create;
    destructor Destroy; override;
    property Image: TPicture read FImage write SetImage;
    property DownImage: TPicture read FDownImage write SetDownImage;
    property OverImage: TPicture read FOverImage write SetOverImage;
    property DisableImage: TPicture read fDisableImage write SetDisableImage;
    property ImageAlign  : TImageAlign read FImageAlign write SetImageAlign;
    property TransparentColor: TColor read FTransparentColor write SetTransparentColor;
    property EnableInvert: boolean read FEnableInvert write FEnableInvert;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  T_ColorList  = class(Tpersistent)
  private
    FUpColor: TColor;
    FOverColor: TColor;
    FDisableColor: TColor;
    FDownColor: TColor;
    FOnChange: TNotifyEvent;
    procedure Changed;
    procedure SetDisableColor(const Value: TColor);
    procedure SetDownColor(const Value: TColor);
    procedure SetOverColor(const Value: TColor);
    procedure SetUpColor(const Value: TColor);
  published
    constructor Create;
    property UpColor : TColor read FUpColor write SetUpColor;
    property DownColor : TColor read FDownColor write SetDownColor;
    property OverColor : TColor read FOverColor write SetOverColor;
    property DisableColor : TColor read FDisableColor write SetDisableColor;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TTextProperties = class(Tpersistent)
  private
    FVAlignment: TVAlignment;
    FHAlignment: THAlignment;
    FTextPosition: TPoint;
    FOnChange: TNotifyEvent;
    FMarginH: integer;
    FColors: T_ColorList;
    FMarginV: integer;
    procedure Changed;
    procedure Change(Sender: TObject);
    procedure SetHAlignment(const Value: THAlignment);
    procedure SetMarginH(const Value: integer);
    procedure SetTextPosition(const Value: TPoint);
    procedure SetVAlignment(const Value: TVAlignment);
    procedure SetColors(const Value: T_ColorList);
    procedure SetMarginV(const Value: integer);
  published
    constructor Create;
    property AlignmentH: THAlignment read FHAlignment write SetHAlignment;
    property AlignmentV: TVAlignment read FVAlignment write SetVAlignment;
    property MarginH: integer read FMarginH write SetMarginH;
    property MarginV: integer read FMarginV write SetMarginV;
    property TextPosition: TPoint read FTextPosition write SetTextPosition;
    property Colors: T_ColorList read FColors write SetColors;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;


  TALBMPButton = class(TGraphicControl)
  private
    fStatus: Integer;
    fAutosize: Boolean;
    fDown: Boolean;
    fGroupIndex: Integer;
    fTransparent: Boolean;
    fAllowAllUp: Boolean;
    fPushOffset: Integer;
    FCaption: TCaption;
    FZoom: double;
    FBitmaps: T_Bitmaps;
    FCaptionOptions: TTextProperties;
    FOnBotton: TNotifyEvent;
    FFont: TFont;
    FMouseEnter: TNotifyEvent;
    FMouseLeave: TNotifyEvent;
//    procedure CMMouseEnter(var msg:TMessage); message CM_MOUSEENTER;
//    procedure CMMouseLeave(var msg: TMessage); message CM_MOUSELEAVE;
    procedure SetAutosize(const Value: Boolean);
    procedure SetDown(const Value: Boolean);
    procedure CMButtonPressed(var Message: TMessage); message CM_ButtonPressed;
    procedure UpdateExclusive;
    procedure SetCaption(const Value: TCaption);
    procedure SetZoom(const Value: double);
    procedure SetTransparent(const Value: Boolean);
    procedure SetStatus(const Value: integer);
  protected
    procedure Change(Sender: TObject);
    procedure MouseDown(Button: TMouseButton;
              Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton;
              Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MsgMouseEnter(var Message: TMessage); message CM_MouseEnter;
    procedure MsgMouseLeave(var Message: TMessage); message CM_MouseLeave;

    procedure Paint; override;
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    property Canvas;
    property Status: integer read FStatus write SetStatus;
  published
    property Bitmaps: T_Bitmaps read FBitmaps write FBitmaps;
    property Down: Boolean read fDown write SetDown;
    property GroupIndex: Integer read fGroupIndex write fGroupIndex;
    property Transparent: Boolean read fTransparent write SetTransparent;
    property AllowAllUp: Boolean read fAllowAllUp write fAllowAllUp;
    property PushOffset: Integer read fPushOffset write fPushOffset;
    property AutoSize: Boolean read FAutoSize write SetAutoSize;

    property Caption: TCaption read FCaption write SetCaption;
    property CaptionOptions: TTextProperties read FCaptionOptions write FCaptionOptions;
    property Zoom: double read FZoom write SetZoom;
    property OnBotton: TNotifyEvent read FOnBotton write FOnBotton;
    property OnMouseEnter: TNotifyEvent read FMouseEnter write FMouseEnter;
    property OnMouseLeave: TNotifyEvent read FMouseLeave write FMouseLeave;

    property Align;
    property Anchors;
    property Color;
    property Cursor;
    property Font;

    property Visible;
    property Enabled;
    property PopupMenu;
    property ShowHint;

    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;

  end;

procedure Register;

procedure DrawTransparentBmp(Cnv: TCanvas; x,y: Integer; Bmp: TBitmap; clTransparent: TColor);

implementation



procedure Register;
begin
  RegisterComponents('AL', [TALBMPButton]);
end;

procedure DrawTransparentBmp(Cnv: TCanvas; x,y: Integer; Bmp: TBitmap; clTransparent: TColor);
var
bmpXOR, bmpAND, bmpINVAND, bmpTarget: TBitmap;
oldcol: Longint;
begin
try
bmpAND := TBitmap.Create;
bmpAND.Width := Bmp.Width;
bmpAND.Height := Bmp.Height;
bmpAND.Monochrome := True;
oldcol := SetBkColor(Bmp.Canvas.Handle, ColorToRGB(clTransparent));
BitBlt(bmpAND.Canvas.Handle, 0,0,Bmp.Width,Bmp.Height, Bmp.Canvas.Handle,
0,0, SRCCOPY);
SetBkColor(Bmp.Canvas.Handle, oldcol);

bmpINVAND := TBitmap.Create;
bmpINVAND.Width := Bmp.Width;
bmpINVAND.Height := Bmp.Height;
bmpINVAND.Monochrome := True;
BitBlt(bmpINVAND.Canvas.Handle, 0,0,Bmp.Width,Bmp.Height,
bmpAND.Canvas.Handle, 0,0, NOTSRCCOPY);

bmpXOR := TBitmap.Create;
bmpXOR.Width := Bmp.Width;
bmpXOR.Height := Bmp.Height;
BitBlt(bmpXOR.Canvas.Handle, 0,0,Bmp.Width,Bmp.Height, Bmp.Canvas.Handle,
0,0, SRCCOPY);
BitBlt(bmpXOR.Canvas.Handle, 0,0,Bmp.Width,Bmp.Height,
bmpINVAND.Canvas.Handle, 0,0, SRCAND);

bmpTarget := TBitmap.Create;
bmpTarget.Width := Bmp.Width;
bmpTarget.Height := Bmp.Height;
BitBlt(bmpTarget.Canvas.Handle, 0,0,Bmp.Width,Bmp.Height, Cnv.Handle, x,y,
SRCCOPY);
BitBlt(bmpTarget.Canvas.Handle, 0,0,Bmp.Width,Bmp.Height,
bmpAND.Canvas.Handle, 0,0, SRCAND);
BitBlt(bmpTarget.Canvas.Handle, 0,0,Bmp.Width,Bmp.Height,
bmpXOR.Canvas.Handle, 0,0, SRCINVERT);
BitBlt(Cnv.Handle, x,y,Bmp.Width,Bmp.Height, bmpTarget.Canvas.Handle, 0,0,
SRCCOPY);
finally
bmpXOR.Free;
bmpAND.Free;
bmpINVAND.Free;
bmpTarget.Free;
end; end;

{ T_Bitmaps }

constructor T_Bitmaps.Create;
begin
  inherited;
  fOverImage    := TPicture.Create;
  fDownImage    := TPicture.Create;
  fDisableImage := TPicture.Create;
  fImage        := TPicture.Create;
  fImage.Bitmap.width  := 100;
  fImage.Bitmap.height := 100;
  fImageAlign   := iaNone;
  FTransparentColor := clFuchsia;
  FEnableInvert := True;
end;

destructor T_Bitmaps.Destroy;
begin
	fDownImage.Free;
	fOverImage.Free;
	fImage.Free;
  fDisableImage.Free;
  inherited;
end;

procedure T_Bitmaps.Changed;
begin if Assigned(FOnChange) then FOnChange(Self); end;

procedure T_Bitmaps.SetDisableImage(const Value: TPicture);
begin
  if fDisableImage <> Value then
  	fDisableImage.Assign(Value);
  Changed;
end;

procedure T_Bitmaps.SetDownImage(const Value: TPicture);
begin
	if fDownImage <> Value then
    fDownImage.Assign(Value);
  Changed;
end;

procedure T_Bitmaps.SetImage(const Value: TPicture);
begin
  if fImage <> Value then
  	fImage.Assign(Value);
  Changed;
end;

procedure T_Bitmaps.SetImageAlign(const Value: TImageAlign);
begin
  FImageAlign := Value;
  Changed;
end;

procedure T_Bitmaps.SetOverImage(const Value: TPicture);
begin
	if FOverImage <> Value then
  	fOverimage.Assign(Value);
  Changed;
end;

procedure T_Bitmaps.SetTransparentColor(const Value: TColor);
begin
  FTransparentColor := Value;
  Changed;
end;

{ T_ColorList }

procedure T_ColorList.Changed;
begin if Assigned(FOnChange) then FOnChange(Self); end;

constructor T_ColorList.Create;
begin
  UpColor := clBlack;
  DownColor := clBlack;
  OverColor := clBlack;
  DisableColor := clSilver;
end;

procedure T_ColorList.SetDisableColor(const Value: TColor);
begin
  FDisableColor := Value;
  Changed;
end;

procedure T_ColorList.SetDownColor(const Value: TColor);
begin
  FDownColor := Value;
  Changed;
end;

procedure T_ColorList.SetOverColor(const Value: TColor);
begin
  FOverColor := Value;
  Changed;
end;

procedure T_ColorList.SetUpColor(const Value: TColor);
begin
  FUpColor := Value;
  Changed;
end;

{ TTextProperties }

constructor TTextProperties.Create;
begin
  inherited;
  FHAlignment   := haCenter;
  FVAlignment   := vaCenter;
  FTextPosition := Point(0,0);
  FMarginH       := 0;
  Colors        := T_ColorList.Create;
  Colors.OnChange := Change;
end;

procedure TTextProperties.Change(Sender: TObject);
begin
  Changed;
end;

procedure TTextProperties.Changed;
begin if Assigned(FOnChange) then FOnChange(Self); end;

procedure TTextProperties.SetColors(const Value: T_ColorList);
begin
  FColors := Value;
  Changed;
end;

procedure TTextProperties.SetHAlignment(const Value: THAlignment);
begin
  FHAlignment := Value;
  Changed;
end;

procedure TTextProperties.SetMarginH(const Value: integer);
begin
  FMarginH := Value;
  Changed;
end;

procedure TTextProperties.SetMarginV(const Value: integer);
begin
  FMarginV := Value;
  Changed;
end;

procedure TTextProperties.SetTextPosition(const Value: TPoint);
begin
  FTextPosition := Value;
  Changed;
end;

procedure TTextProperties.SetVAlignment(const Value: TVAlignment);
begin
  FVAlignment := Value;
  Changed;
end;


{ TALBMPButton }

constructor TALBMPButton.Create(Aowner: TComponent);
begin
	inherited Create(AOwner);
  FBitmaps       := T_Bitmaps.Create;
  FBitmaps.OnChange := Change;
  FCaptionOptions:= TTextProperties.Create;
  FCaptionOptions.OnChange := Change;
  fStatus       := 0;
  fAutoSize     := false;
  Cursor        := crHandPoint;
  WIDTH         := 100;
  HEIGHT        := 100;
end;

destructor TALBMPButton.Destroy;
begin
  Bitmaps.Free;
  CaptionOptions.Free;
	inherited Destroy;
end;

procedure TALBMPButton.UpdateExclusive;
var
  Msg: TMessage;
begin
  if (fGroupIndex <> 0) and (Parent <> nil) then
  begin
    Msg.Msg := CM_BUTTONPRESSED;
    Msg.WParam := fGroupIndex;
    Msg.LParam := Longint(Self);
    Msg.Result := 0;
    Parent.Broadcast(Msg);
  end;
end;


procedure TALBMPButton.MsgMouseEnter(var Message: TMessage);
begin
  Case fStatus of
  0:  begin
      Status := 1;
      paint;
      if Bitmaps.EnableInvert then
         InvertRect(Canvas.Handle, Canvas.ClipRect);
  end;
  1:  begin
  	Status := 0;
  	paint;
      end;
  End;
  if Assigned(FMouseEnter) then FMouseEnter(Self);
end;

procedure TALBMPButton.MsgMouseLeave(var Message: TMessage);
begin
 if fStatus = 1 then
  begin
  	Status := 0;
  	paint;
  end;
  if Assigned(FMouseLeave) then FMouseLeave(Self);
end;

procedure TALBMPButton.Change(Sender: TObject);
begin
  Invalidate;
end;

procedure TALBMPButton.CMButtonPressed(var Message: TMessage);
var
  Sender: TALBMPButton;
  Comp: TALBMPButton;
  i: Integer;
  OneDown: Boolean;
begin
	OneDown := False;
  if Message.WParam = fGroupIndex then
  begin
    Sender := TALBMPButton(Message.LParam);
    if Sender <> Self then
    begin
      if Sender.Down and (fDown) then
      begin
        fDown := False;
        paint;
      end;
      FAllowAllUp := Sender.AllowAllUp;
    end else if not fAllowAllUp then
    begin
      if Parent <> nil then
	    	for i := 0 to Parent.ControlCount-1 do
    		begin
        	Comp := TALBMPButton(Parent.Controls[i]);
          if Comp <> nil then
          begin
        		OneDown := OneDown and Comp.Down;
            if OneDown then Break;
          end;
        end;
      if not OneDown then Down := True;
    end;
  end;
end;

(*
procedure TALBMPButton.CMMouseEnter(var msg: TMessage);
begin
    if Assigned(FMouseEnter) then FMouseEnter(Self);
end;

procedure TALBMPButton.CMMouseLeave(var msg: TMessage);
begin
    if Assigned(FMouseLeave) then FMouseLeave(Self);
end;
*)
procedure TALBMPButton.SetCaption(const Value: TCaption);
begin
  FCaption := Value;
  invalidate;
end;

procedure TALBMPButton.SetDown(const Value: Boolean);
begin
  if fDown <> Value then
  begin
    fDown := Value;
    UpdateExclusive;
    paint;
  end;
end;

procedure TALBMPButton.SetStatus(const Value: integer);
begin
  FStatus := Value;
  if Assigned(FOnBotton) then FOnBotton(Self);
end;

procedure TALBMPButton.SetAutosize(const Value: Boolean);
begin
  if fAutosize <> Value then begin
  fAutosize := Value;
  if fAutosize then Setbounds(Left, Top, Bitmaps.Image.Width, Bitmaps.Image.Height);
  end;
end;

procedure TALBMPButton.SetTransparent(const Value: Boolean);
begin
  fTransparent := Value;
  invalidate;
end;

procedure TALBMPButton.SetZoom(const Value: double);
begin
  FZoom := Value;
  width := Round(Zoom*width);
  height := Round(Zoom*height);
  invalidate;
end;

procedure TALBMPButton.Paint;
  var
  	x,y, tx, ty, th, tv: Integer;

  procedure DrawImage(im: TPicture);
  var bmp: Tbitmap;
  begin
  	x := 0; y := 0;
  	if im <> nil then begin
       // Transparent
       im.Bitmap.Transparent := fTransparent;
       im.Bitmap.TransparentMode := tmFixed;
       im.Bitmap.TransparentColor := Bitmaps.FTransparentColor;
    case Bitmaps.ImageAlign of
    iaNone:    Canvas.Draw(x, y, im.Graphic);
    iaCenter:
    begin
       x := (Self.Width - im.Width) div 2;
       y := (Self.Height - im.Height) div 2;
       Canvas.Draw(x, y, im.Graphic);
    end;
    iaLeft:
    begin
       x := 0;
       y := (Self.Height - im.Height) div 2;
       Canvas.Draw(x, y, im.Graphic);
    end;
    iaRight:
    begin
       x := Width - im.Width;
       y := (Self.Height - im.Height) div 2;
       Canvas.Draw(x, y, im.Graphic);
    end;
    iaTop:
    begin
       x := (Self.Width - im.Width) div 2;
       y := 0;
       Canvas.Draw(x, y, im.Graphic);
    end;
    iaBottom:
    begin
       x := (Self.Width - im.Width) div 2;
       y := Self.Height - im.Height;
       Canvas.Draw(x, y, im.Graphic);
    end;
    iaToButton:
      Canvas.StretchDraw(Rect(x, y,width,height), im.Graphic);
    iaToBitmap:
    begin

      if Align=alNone then begin
         Self.Width := im.Bitmap.Width;
         Self.Height:= im.Bitmap.Height;
      end else begin
         x := (Self.Width - im.Width) div 2;
         y := (Self.Height - im.Height) div 2;
      end;

      Canvas.Draw(x, y, im.Graphic);
    end;
    iaTitle:
    repeat
        Canvas.Draw(x, y, im.Graphic);
        Inc(x, im.Width);
        if x > Width+im.Graphic.Width then
        begin
          x := 0;
          Inc(y, im.Graphic.Height);
        end;
      until (y>=Height)
    end;
    end;
    (*
    if Status=1 then
    begin
       bmp := Tbitmap.Create;
       bmp.Assign(im.Graphic);
       Negativ(bmp);
    end;*)
  end;

  procedure Draw_Up;
  begin
      DrawImage(Bitmaps.Image);
  end;

  procedure Draw_Down;
  begin
      DrawImage(Bitmaps.DownImage);
  end;

  procedure Draw_Over;
  begin
      DrawImage(Bitmaps.OverImage);
  end;

  procedure Draw_Disable;
  begin
      DrawImage(Bitmaps.DisableImage);
  end;

begin
//  CaptionOptions.Colors.UpColor := Font.Color;
  Canvas.Font.Assign(Font);
	if fTransparent then
	begin
  	Canvas.Brush.Style := bsClear;
  	Canvas.FillRect(ClientRect);
  end;
  if fAutoSize and (Bitmaps.Image<>nil) then
	   Setbounds(Left, Top, Bitmaps.Image.Width, Bitmaps.Image.Height);
(*
  if Bitmaps.DownImage.Graphic <> nil then
	  Bitmaps.DownImage.Graphic.Transparent := fTransparent;
  if Bitmaps.OverImage.Graphic <> nil then
	  Bitmaps.OverImage.Graphic.Transparent := fTransparent;
  if Bitmaps.Image.Graphic <> nil then
    Bitmaps.Image.Graphic.Transparent := fTransparent;
*)
  if Bitmaps.Image.Graphic <> nil then
  begin
    if not Enabled then
       Draw_Disable
    else
    case fStatus of
    0: if fDown then
       begin
            Draw_Down;
            Canvas.Font.Color := CaptionOptions.Colors.DownColor;
       end
       else
       begin
            Draw_Up;
            Canvas.Font.Color := CaptionOptions.Colors.UpColor;
       end;
    2: begin
            Draw_Down;
            Canvas.Font.Color := CaptionOptions.Colors.DownColor;
       end;
    1: begin
            Draw_Over;
            Canvas.Font.Color := CaptionOptions.Colors.OverColor;
       end;
    end;
  end
  else
  begin
    if csDesigning in ComponentState then
    begin
        Canvas.Pen.Style := psDash;
        Canvas.Pen.Color := clBlue;
    	Canvas.Brush.Color := clGray;
    	Canvas.Rectangle(0, 0, Width, Height);
    	Canvas.TextOut(2,2,'(TALBMPButton)');
    end;
  end;
  if not Enabled then
      Canvas.Font.Color := CaptionOptions.Colors.DisableColor;


  // Caption draw
  th := Canvas.TextWidth(Caption);
  tv := Canvas.TextHeight(Caption);
  case CaptionOptions.AlignmentH of
  haNone:    tx := CaptionOptions.MarginH;
  haCenter:  tx := (Width-th) div 2;
  haLeft:    tx := CaptionOptions.MarginH;
  haRight:   tx := Width-CaptionOptions.MarginH-th;
  end;
  case CaptionOptions.AlignmentV of
  vaNone:    ty := CaptionOptions.MarginV;
  vaCenter:  ty := (Height-tv) div 2;
  vaTop:     ty := CaptionOptions.MarginV;
  vaBottom:  ty := Height-CaptionOptions.MarginV-tv;
  end;

  if Down or (fStatus=2) then
  begin
       tx:=tx+PushOffset;
       ty:=ty+PushOffset;
  end;

  Canvas.Brush.Style := bsClear;
 	Canvas.TextOut(tx,ty,Caption);
end;

procedure TALBMPButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
  	Status := 2;
        paint;
  end;
  if Button = mbRight then
  begin
  	Status := 0;
        Down := fGroupIndex <> 0;
        paint;
  end;
end;

procedure TALBMPButton.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if fStatus = 0 then
  begin
  	Status := 1;
        paint;
  end;
  inherited MouseMove(Shift, X, Y);
end;

procedure TALBMPButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if fStatus = 2 then
  begin
  	Status := 0;
//        Down := fGroupIndex <> 0;
  	paint;
  end;
end;

end.


