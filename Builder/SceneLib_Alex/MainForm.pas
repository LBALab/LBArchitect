unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SceneLib, StdCtrls, Spin;

type
  TForm1 = class(TForm)
    Button1: TButton;
    LifeScript: TMemo;
    MoveScript: TMemo;
    SpinEdit1: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Scene: TScene;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Scene:=OpenSceneFile('prison.ls1');
  SpinEdit1.MaxValue:=Length(Scene.Actors);
  MoveScript.Text := Scene.Hero.MoveScript;
  LifeScript.Text := Scene.Hero.LifeScript;  
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  if SpinEdit1.Value = 0 then begin
     MoveScript.Text := Scene.Hero.MoveScript;
     LifeScript.Text := Scene.Hero.LifeScript;
  end;
  if SpinEdit1.Value <> 0 then begin
     MoveScript.Text := Scene.Actors[SpinEdit1.Value-1].MoveScript;
     LifeScript.Text := Scene.Actors[SpinEdit1.Value-1].LifeScript;
  end;

end;

end.
