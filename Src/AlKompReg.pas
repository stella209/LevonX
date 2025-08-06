unit AlKompReg;

{$I ALKomp.inc}

interface

uses
  Classes, Menus;

procedure Register;

implementation

{$R ALKompImg.res}

uses
  AL_BMPButton, AL_BrushStyle, AL_GL, AL_Motors, AL_Navigator,
  AL_OpenGl, AL_Paper, AL_PapirGL, AL_Ruler, AL_ToneCurve, Al_TSpeedButton,
  AL_ZoomImg, Dgrid, Orapan,
  Forms, Dialogs, Graphics, AL_StyCut;


procedure Register;
begin
  RegisterComponents('AL', [TALBMPButton, TALBrushStyleCombo,
    TAL_OpenGL, TALMotors, TALNavigator, TALOpenGl, TALSablon,
    TALPapirGL, TALRuler, TALToneCurve, TALTimerSpeedButton,
    TALZoomImage, TALImageSource, TALImageView, TALRGBDiagram,
    TSTDataGrid, TOraPanel, TStyCutMotors
    ]);
end;

end.
