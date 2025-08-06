unit tiaonImageButton;

//  tiaonImageButton
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

  TImageAlign = (iaNone, iaCenter, iaToButton, iaToBitmap, iaTitle);

  TAlignments = class(Tpersistent)
  private
  public
  end;

  TtiaonImageButton = class(TGraphicControl)
  private
    FOverImage: TPicture;
    FDownImage: TPicture;
    FImage: TPicture;
    fStatus: Integer;
    fAutosize: Boolean;
    fDown: Boolean;
    fCheckGroup: Integer;
    fDisableImage: TPicture;
    fTransparent: Boolean;
    fAllowAllUp: Boolean;
    fPushOffset: Integer;
    FHAlignment: THAlignment;
    FVAlignment: TVAlignment;
    FTextPosition: TPoint;
    FImageAlign: TImageAlign;
    FCaption: TCaption;
    FMargin: integer;
    FZoom: double;
    procedure SetDownImage(const Value: TPicture);
    procedure SetImage(const Value: TPicture);
    procedure SetOverImage(const Value: TPicture);
    procedure SetAutosize(const Value: Boolean);
    procedure SetDisableImage(const Value: TPicture);
    procedure SetDown(const Value: Boolean);
    procedure CMButtonPressed(var Message: TMessage); message CM_ButtonPressed;
    procedure UpdateExclusive;
    procedure SetHAlignment(const Value: THAlignment);
    procedure SetVAlignment(const Value: TVAlignment);
    procedure SetTextPosition(const Value: TPoint);
    procedure SetImageAlign(const Value: TImageAlign);
    procedure SetCaption(const Value: TCaption);
    procedure SetMargin(const Value: integer);
    procedure SetZoom(const Value: double);
    procedure SetTransparent(const Value: Boolean);
//    procedure SetCheckGroup(const Value: Integer);
    { Private declarations }
  protected
    { Protected declarations }

    procedure MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); override;
		procedure MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); override;
		procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MsgMouseEnter(var Message: TMessage); message CM_MouseEnter;
    procedure MsgMouseLeave(var Message: TMessage); message CM_MouseLeave;

    procedure Paint; override;
  public
    { Public declarations }
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    property Canvas;
  published
    property Image: TPicture read FImage write SetImage;
    property DownImage: TPicture read FDownImage write SetDownImage;
    property OverImage: TPicture read FOverImage write SetOverImage;
    property Down: Boolean read fDown write SetDown;
    property CheckGroup: Integer read fCheckGroup write fCheckGroup;
    property DisableImage: TPicture read fDisableImage write SetDisableImage;
    property Transparent: Boolean read fTransparent write SetTransparent;
    property AllowAllUp: Boolean read fAllowAllUp write fAllowAllUp;
    property PushOffset: Integer read fPushOffset write fPushOffset;
    property AutoSize: Boolean read FAutoSize write SetAutoSize;

    property Caption: TCaption read FCaption write SetCaption;
    property AlignmentH: THAlignment read FHAlignment write SetHAlignment;
    property AlignmentV: TVAlignment read FVAlignment write SetVAlignment;
    property Margin: integer read FMargin write SetMargin;
    property TextPosition: TPoint read FTextPosition write SetTextPosition;
    property ImageAlign  : TImageAlign read FImageAlign write SetImageAlign;
    property Zoom: double read FZoom write SetZoom;


    property Align;
    property Anchors;
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
  RegisterComponents('AL', [TtiaonImageButton]);
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

{ TtiaonImageButton }

constructor TtiaonImageButton.Create(Aowner: TComponent);
begin
	inherited Create(AOwner);
  fOverImage    := TPicture.Create;
  fDownImage    := TPicture.Create;
  fDisableImage := TPicture.Create;
  fImage        := TPicture.Create;
  FHAlignment   := haCenter;
  FVAlignment   := vaCenter;
  FTextPosition := Point(0,0);
  FMargin       := 0;
  fStatus := 0;
  fAutoSize := True;
end;

destructor TtiaonImageButton.Destroy;
begin
	fDownImage.Free;
	fOverImage.Free;
	fImage.Free;
  fDisableImage.Free;
	inherited Destroy;
end;

procedure TtiaonImageButton.UpdateExclusive;
var
  Msg: TMessage;
begin
  if (fCheckGroup <> 0) and (Parent <> nil) then
  begin
    Msg.Msg := CM_BUTTONPRESSED;
    Msg.WParam := fCheckGroup;
    Msg.LParam := Longint(Self);
    Msg.Result := 0;
    Parent.Broadcast(Msg);
  end;
end;

procedure TtiaonImageButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
	if Button = mbLeft then
  begin
  	fStatus := 2;
    paint;
  end;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TtiaonImageButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
	if fStatus = 2 then
  begin
  	fStatus := 0;
		if fCheckGroup <> 0 then Down := not fDown;
  	paint;
  end;
  inherited MouseUp(Button, Shift, X, Y);  
end;

procedure TtiaonImageButton.MsgMouseEnter(var Message: TMessage);
begin
	if fStatus = 0 then
  begin
  	fStatus := 1;
		paint;
  end;
end;

procedure TtiaonImageButton.MsgMouseLeave(var Message: TMessage);
begin
	if fStatus = 1 then
  begin
  	fStatus := 0;
  	paint;
  end;
end;

procedure TtiaonImageButton.SetDisableImage(const Value: TPicture);
begin
  if fDisableImage <> Value then
  begin
  	fDisableImage.Assign(Value);
    if not Enabled then paint;
  end;
end;

procedure TtiaonImageButton.CMButtonPressed(var Message: TMessage);
var
  Sender: TtiaonImageButton;
  Comp: TtiaonImageButton;
  i: Integer;
  OneDown: Boolean;
begin
	OneDown := False;
  if Message.WParam = fCheckGroup then
  begin
    Sender := TtiaonImageButton(Message.LParam);
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
        	Comp := TtiaonImageButton(Parent.Controls[i]);
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

procedure TtiaonImageButton.SetCaption(const Value: TCaption);
begin
  FCaption := Value;
  invalidate;
end;

procedure TtiaonImageButton.SetDown(const Value: Boolean);
begin
	if fDown <> Value then
  begin
  	fDown := Value;
    UpdateExclusive;
    paint;
  end;
end;

procedure TtiaonImageButton.SetAutosize(const Value: Boolean);
begin
  fAutosize := Value;
  if fAutosize then Setbounds(Left, Top, fImage.Width, fImage.Height);
end;

procedure TtiaonImageButton.SetDownImage(const Value: TPicture);
begin
	if fDownImage <> Value then
	begin
    FDownImage.Assign(Value);
    paint;
  end;
end;

procedure TtiaonImageButton.SetImage(const Value: TPicture);
begin
  if FImage <> Value then
  begin
  	fImage.Assign(Value);
    if fAutoSize then
		  Setbounds(Left, Top, fImage.Width, fImage.Height);
    paint;
  end;
end;

procedure TtiaonImageButton.SetImageAlign(const Value: TImageAlign);
begin
  FImageAlign := Value;
  invalidate;
end;

procedure TtiaonImageButton.SetMargin(const Value: integer);
begin
  FMargin := Value;
  invalidate;
end;

procedure TtiaonImageButton.SetOverImage(const Value: TPicture);
begin
	if FOverImage <> Value then
  begin
  	fOverimage.Assign(Value);
  	paint;
  end;
end;

procedure TtiaonImageButton.SetTextPosition(const Value: TPoint);
begin
  FTextPosition := Value;
  invalidate;
end;

procedure TtiaonImageButton.SetTransparent(const Value: Boolean);
begin
  fTransparent := Value;
  invalidate;
end;

procedure TtiaonImageButton.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
	if fStatus = 0 then
  begin
  	fStatus := 1;
		paint;
  end;
  inherited MouseMove(Shift, X, Y);
end;

procedure TtiaonImageButton.SetHAlignment(const Value: THAlignment);
begin
  FHAlignment := Value;
  invalidate;
end;

procedure TtiaonImageButton.SetVAlignment(const Value: TVAlignment);
begin
  FVAlignment := Value;
  invalidate;
end;

procedure TtiaonImageButton.SetZoom(const Value: double);
begin
  FZoom := Value;
  width := Round(Zoom*width);
  height := Round(Zoom*height);
  invalidate;
end;

procedure TtiaonImageButton.Paint;
  var
  	x,y, tx, ty, th, tv: Integer;

  procedure DrawImage(im: TPicture);
  begin
  	x := 0; y := 0;
  	if fImage.Graphic <> nil then
    case ImageAlign of
    iaNone:    Canvas.Draw(x, y, im.Graphic);
    iaCenter:
    begin
       x := (Width div 2) - (Self.Width - im.Width) div 2;
       y := (Height div 2) - (Self.Height - im.Height) div 2;
       Canvas.Draw(x, y, im.Graphic);
    end;
    iaToButton:
      Canvas.StretchDraw(Rect(x, y,width,height), im.Graphic);
    iaToBitmap:
    begin
      Width := fImage.Width;
      Height:= fImage.Height;
      Canvas.Draw(x, y, im.Graphic);
    end;
    iaTitle:
			repeat
	      Canvas.Draw(x, y, im.Graphic);
        Inc(x, fImage.Graphic.Width);
        if x > Width+im.Graphic.Width then
        begin
          x := 0;
          Inc(y, im.Graphic.Height);
        end;
      until (y>=Height)
    end;
  end;

	procedure Draw_Up;
  begin
      DrawImage(FImage);
  end;

  procedure Draw_Down;
  begin
      DrawImage(FDownImage);
  end;

  procedure Draw_Over;
  begin
      DrawImage(fOverImage);
  end;

begin
	if fTransparent then
	begin
  	Canvas.Brush.Style := bsClear;
  	Canvas.FillRect(ClientRect);
  end;
  if fDownImage.Graphic <> nil then
	  fDownImage.Graphic.Transparent := fTransparent;
  if fOverImage.Graphic <> nil then
	  fOverImage.Graphic.Transparent := fTransparent;
  if fImage.Graphic <> nil then
    fImage.Graphic.Transparent := fTransparent;
  if fImage.Graphic <> nil then
  begin
  	case fStatus of
    0: if fDown then Draw_Down else Draw_Up;
    2: Draw_Down;
    1: Draw_Over;
    end;
  end
  else
  begin
  	if csDesigning in ComponentState then
    begin
	    Canvas.Pen.Style := psDash;
  	  Canvas.Pen.Color := clWhite;
    	Canvas.Brush.Color := clGray;
    	Canvas.Rectangle(0, 0, Width, Height);
    	Canvas.TextOut(2,2,'(TALImageButton)');
    end;
  end;


  // Caption draw
  Canvas.Font.Assign(Font);
  th := Canvas.TextWidth(Caption);
  tv := Canvas.TextHeight(Caption);
  case FHAlignment of
  haNone:    tx := Margin;
  haCenter:  tx := (Width-th) div 2;
  haLeft:    tx := Margin;
  haRight:   tx := Width-Margin-th;
  end;
  case FVAlignment of
  vaNone:    ty := Margin;
  vaCenter:  ty := (Height-tv) div 2;
  vaTop:     ty := Margin;
  vaBottom:  ty := Height-Margin-tv;
  end;

  if Down or (fStatus=2) then
  begin
       tx:=tx+PushOffset;
       ty:=ty+PushOffset;
  end;

  Canvas.Brush.Style := bsClear;
 	Canvas.TextOut(tx,ty,Caption);
end;

end.


