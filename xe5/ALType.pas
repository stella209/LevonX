unit ALType;

interface

Type
  TMetric = (meMM,meInch);

const
  // User definied cursors in CURSORS.RES
  crKez1     = 18000;
  crKez2     = 18001;
  crRealZoom = 18002;
  crNyilUp   = 18003;
  crNyilDown = 18004;
  crNyilLeft = 18005;
  crNyilRight= 18006;
  crZoomIn   = 18007;
  crZoomOut  = 18008;
  crKereszt  = 18009;
  crHelp     = 18100;
  crPolyline = 20000;
  crPolygon  = 20001;
  crInsertPoint = 20002;
  crDeletePoint = 20003;
  crNewbeginPoint = 20004;
  crRotateSelected = 20005;
  crFreeHand = 2006;

Const
  EoLn  : string = chr(13)+chr(10);
  Inch  : double = 25.4500; // mm

implementation

{$R Cursors.RES}

end.
