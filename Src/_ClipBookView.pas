unit _ClipBookView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TClipbookViewerForm = class(TForm)
    Image: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ClipbookViewerForm: TClipbookViewerForm;

implementation

{$R *.dfm}

end.
