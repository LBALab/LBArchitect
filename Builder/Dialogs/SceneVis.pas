unit SceneVis;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls;

type
  TfmSceneVis = class(TForm)
    btOK: TBitBtn;
    btCancel: TBitBtn;
    cbActorsSpri: TCheckBox;
    cbPoints: TCheckBox;
    cbZCube: TCheckBox;
    cbZCamera: TCheckBox;
    cbZSceneric: TCheckBox;
    cbZFragment: TCheckBox;
    cbZBonus: TCheckBox;
    cbZLadder: TCheckBox;
    cbZText: TCheckBox;
    cbZSpike: TCheckBox;
    cbClipping: TCheckBox;
    btAll: TBitBtn;
    btNone: TBitBtn;
    cbZConveyor: TCheckBox;
    cbZRail: TCheckBox;
    cbActors3D: TCheckBox;
    procedure btAllClick(Sender: TObject);
  private
    { Private declarations }
  public
    class procedure ShowDialog();
  end;

var
  fmSceneVis: TfmSceneVis;

implementation

uses Settings, Rendering, SceneLibConst;

{$R *.dfm}

procedure TfmSceneVis.btAllClick(Sender: TObject);
var Sel: Boolean;
begin
  Sel:= Sender = btAll;
  cbZCube.Checked:=     Sel;
  cbZCamera.Checked:=   Sel;
  cbZSceneric.Checked:= Sel;
  cbZFragment.Checked:= Sel;
  cbZBonus.Checked:=    Sel;
  cbZLadder.Checked:=   Sel;
  cbZText.Checked:=     Sel;
  cbZConveyor.Checked:= Sel;
  cbZSpike.Checked:=    Sel;
  cbZRail.Checked:=     Sel;
end;

class procedure TfmSceneVis.ShowDialog();
var Form: TfmSceneVis;
begin
  Application.CreateForm(Self, Form);

  Form.cbActorsSpri.Checked:=ScVisible.ActorsSpri;
  Form.cbActors3D.Checked:=  ScVisible.Actors3D;
  Form.cbClipping.Checked:=  ScVisible.Clipping;
  Form.cbPoints.Checked:=    ScVisible.Tracks;
  Form.cbZCube.Checked:=     ztCube     in ScVisible.Zones;
  Form.cbZCamera.Checked:=   ztCamera   in ScVisible.Zones;
  Form.cbZSceneric.Checked:= ztSceneric in ScVisible.Zones;
  Form.cbZFragment.Checked:= ztFragment in ScVisible.Zones;
  Form.cbZBonus.Checked:=    ztBonus    in ScVisible.Zones;
  Form.cbZLadder.Checked:=   ztLadder   in ScVisible.Zones;
  Form.cbZText.Checked:=     ztText     in ScVisible.Zones;
  Form.cbZConveyor.Checked:= ztConveyor in ScVisible.Zones;
  Form.cbZSpike.Checked:=    ztHurt     in ScVisible.Zones;
  Form.cbZRail.Checked:=     ztRail     in ScVisible.Zones;

  if Form.ShowModal = mrOK then begin
    ScVisible.ActorsSpri:=        Form.cbActorsSpri.Checked;
    ScVisible.Actors3D:=          Form.cbActors3D.Checked;
    ScVisible.Clipping:=          Form.cbClipping.Checked;
    ScVisible.Tracks:=            Form.cbPoints.Checked;
    ScVisible.Zones:= [];
    if Form.cbZCube.Checked     then ScVisible.Zones:= ScVisible.Zones + [ztCube];
    if Form.cbZCamera.Checked   then ScVisible.Zones:= ScVisible.Zones + [ztCamera];
    if Form.cbZSceneric.Checked then ScVisible.Zones:= ScVisible.Zones + [ztSceneric];
    if Form.cbZFragment.Checked then ScVisible.Zones:= ScVisible.Zones + [ztFragment];
    if Form.cbZBonus.Checked    then ScVisible.Zones:= ScVisible.Zones + [ztBonus];
    if Form.cbZLadder.Checked   then ScVisible.Zones:= ScVisible.Zones + [ztLadder];
    if Form.cbZText.Checked     then ScVisible.Zones:= ScVisible.Zones + [ztText];
    if Form.cbZConveyor.Checked then ScVisible.Zones:= ScVisible.Zones + [ztConveyor];
    if Form.cbZSpike.Checked    then ScVisible.Zones:= ScVisible.Zones + [ztHurt];
    if Form.cbZRail.Checked     then ScVisible.Zones:= ScVisible.Zones + [ztRail];
    DrawMapA();
  end;

  FreeAndNil(Form);
end;

end.
