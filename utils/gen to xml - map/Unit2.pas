unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var
  i : integer;
begin
  memo2.Clear;
  for i := 0 to memo1.Lines.Count-1 do
   memo2.Lines.Add(' <line>'+memo1.lines[i]+'</line>');
  showmessage(inttostr(memo1.Lines.Count));
end;

end.
