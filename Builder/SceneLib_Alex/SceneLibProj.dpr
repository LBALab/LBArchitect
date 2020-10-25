program SceneLibProj;



{%File 'SceneLibConst.inc'}
{%File 'SceneLibDecomp.inc'}
{%File 'SceneLibComp.inc'}

uses
  Forms,
  MainForm in 'MainForm.pas' {Form1},
  SceneLib in 'SceneLib.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
