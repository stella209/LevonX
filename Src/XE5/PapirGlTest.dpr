program PapirGlTest;

uses
  Vcl.Forms,
  Unit1 in 'D:\PC\Stella\Test\PapirGL\Unit1.pas' {Form1},
  AL_GL in 'AL_GL.pas',
  AL_PapirGL in 'AL_PapirGL.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
