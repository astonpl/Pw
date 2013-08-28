program pw_serv;

uses
  Forms,
  glowna in 'glowna.pas' {Form2},
  unit_packages in 'unit_packages.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
