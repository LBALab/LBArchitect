unit SceneProp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, SceneLib, SceneLibConst, Scene, Utils,
  BetterSpin, Math;

type
  TfmSceneProp = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label15: TLabel;
    btOK: TBitBtn;
    BitBtn2: TBitBtn;
    gbAmbient: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label5: TLabel;
    Label16: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    seIslandId: TfrBetterSpin;
    seGameOver: TfrBetterSpin;
    seAlphaLight: TfrBetterSpin;
    seBetaLight: TfrBetterSpin;
    seMusicId: TfrBetterSpin;
    seSampleId: array[1..4] of TfrBetterSpin;
    seSampleRep: array[1..4] of TfrBetterSpin;
    seSampleRnd: array[1..4] of TfrBetterSpin;
    seMinDelay: TfrBetterSpin;
    seMinDelayRnd: TfrBetterSpin;
  public
    procedure EditProperties(var Scene: TScene);
  end;

var
  fmSceneProp: TfmSceneProp;

implementation

{$R *.dfm}

procedure TfmSceneProp.EditProperties(var Scene: TScene);
var a, t: Integer;
begin
 seIslandId.Value:= Scene.TextBank;
 seGameOver.Value:= Scene.GameOverScene;
 seAlphaLight.Value:= Scene.AlphaLight;
 seBetaLight.Value:= Scene.BetaLight;
 for a:= 0 to 3 do begin
   seSampleId[a+1].Value:= Scene.SampleAmbience[a];
   seSampleRep[a+1].Value:= Scene.SampleRepeat[a];
   seSampleRnd[a+1].Value:= Scene.SampleRound[a];
 end;
 seMinDelay.Value:= Scene.MinDelay;
 seMinDelayRnd.Value:= Scene.MinDelayRnd;
 seMusicId.Value:= IfThen(Scene.MusicIndex = 255, -1, Scene.MusicIndex);

 If ShowModal() = mrOK then begin
   If seIslandId.ValueOK then Scene.TextBank:= seIslandId.Value;
   If seGameOver.ValueOK then Scene.GameOverScene:= seGameOver.Value;
   If seAlphaLight.ValueOK then Scene.AlphaLight:= seAlphaLight.Value;
   If seBetaLight.ValueOK then Scene.BetaLight:= seBetaLight.Value;
   for a:= 0 to 3 do begin
     If seSampleId[a+1].TryReadValue(t) then Scene.SampleAmbience[a]:= t;
     If seSampleRep[a+1].TryReadValue(t) then Scene.SampleRepeat[a]:= t;
     If seSampleRnd[a+1].TryReadValue(t) then Scene.SampleRound[a]:= t;
   end;
   If seMinDelay.ValueOK then Scene.MinDelay:= seMinDelay.Value;
   If seMinDelayRnd.ValueOK then Scene.MinDelayRnd:= seMinDelayRnd.Value;
   If seMusicId.ValueOK then Scene.MusicIndex:= Byte(seMusicId.Value);
   SetSceneModified();
 end;
end;

procedure TfmSceneProp.FormClose(Sender: TObject;
  var Action: TCloseAction);
//var a: Integer;
begin
 {If ModalResult = mrOK then
   for a:= 0 to ControlCount - 1 do
     If (Controls[a] is TSpinEdit)
     and not (Controls[a] as TSpinEdit).ValueOK then begin
       ModalResult:= mrNone;
       Action:= caNone;
       (Controls[a] as TSpinEdit).SetFocus();
       Break;
     end;}
end;

procedure TfmSceneProp.FormCreate(Sender: TObject);
var a: Integer;
begin
 seIslandId:= TfrBetterSpin.Create(Self);
 seIslandId.Name:= 'seIslandId';
 seIslandId.Parent:= Self;
 seIslandId.SetBounds(136, 16, 57, 22);
 seIslandId.Setup(0, 255, 0);

 seGameOver:= TfrBetterSpin.Create(Self);
 seGameOver.Name:= 'seGameOver';
 seGameOver.Parent:= Self;
 seGameOver.SetBounds(136, 48, 57, 22);
 seGameOver.Setup(0, 255, 0);

 seAlphaLight:= TfrBetterSpin.Create(Self);
 seAlphaLight.Name:= 'seAlphaLight';
 seAlphaLight.Parent:= Self;
 seAlphaLight.SetBounds(352, 16, 73, 22);
 seAlphaLight.Setup(0, 65535, 0);

 seBetaLight:= TfrBetterSpin.Create(Self);
 seBetaLight.Name:= 'seBetaLight';
 seBetaLight.Parent:= Self;
 seBetaLight.SetBounds(352, 48, 73, 22);
 seBetaLight.Setup(0, 65535, 0);

 seMusicId:= TfrBetterSpin.Create(Self);
 seMusicId.Name:= 'seMusicId';
 seMusicId.Parent:= Self;
 seMusicId.SetBounds(136, 96, 57, 22);
 seMusicId.Setup(-1, 254, 0);

 for a:= 0 to 3 do begin
   seSampleId[a+1]:= TfrBetterSpin.Create(Self);
   seSampleId[a+1].Name:= 'seSampleId' + IntToStr(a+1);
   seSampleId[a+1].Parent:= gbAmbient;
   seSampleId[a+1].SetBounds(128 + a*80, 40, 73, 22);
   seSampleId[a+1].Setup(-1, 32767, 0);

   seSampleRep[a+1]:= TfrBetterSpin.Create(Self);
   seSampleRep[a+1].Name:= 'seSampleRep' + IntToStr(a+1);
   seSampleRep[a+1].Parent:= gbAmbient;
   seSampleRep[a+1].SetBounds(128 + a*80, 64, 73, 22);
   seSampleRep[a+1].Setup(-1, 32767, 0);

   seSampleRnd[a+1]:= TfrBetterSpin.Create(Self);
   seSampleRnd[a+1].Name:= 'seSampleRnd' + IntToStr(a+1);
   seSampleRnd[a+1].Parent:= gbAmbient;
   seSampleRnd[a+1].SetBounds(128 + a*80, 88, 73, 22);
   seSampleRnd[a+1].Setup(-1, 32767, 0);
   seSampleRnd[a+1].Tag:= a+1;
 end;

 seMinDelay:= TfrBetterSpin.Create(Self);
 seMinDelay.Name:= 'seMinDelay';
 seMinDelay.Parent:= gbAmbient;
 seMinDelay.SetBounds(160, 136, 73, 22);
 seMinDelay.Setup(-1, 32767, 0);

 seMinDelayRnd:= TfrBetterSpin.Create(Self);
 seMinDelayRnd.Name:= 'seMinDelayRnd';
 seMinDelayRnd.Parent:= gbAmbient;
 seMinDelayRnd.SetBounds(160, 168, 73, 22);
 seMinDelayRnd.Setup(-1, 32767, 0);
end;

procedure TfmSceneProp.btOKClick(Sender: TObject);
var a: Integer;
begin
 for a:= 0 to ComponentCount - 1 do
   If (Components[a] is TfrBetterSpin) then begin
     if (Components[a] as TfrBetterSpin).ValueOK then begin
       if (Components[a] as TfrBetterSpin).Value = 0 then begin
         if ((Components[a] = seSampleRnd[1]) or (Components[a] = seSampleRnd[2])
         or (Components[a] = seSampleRnd[3]) or (Components[a] = seSampleRnd[4]))
         then begin
           ErrorMsg(Format('Value of 0 is not allowed in the Sound #%d Pitch Range field!', [Components[a].Tag]));
           Exit;
         end
         else if Components[a] = seMinDelayRnd then begin
           ErrorMsg('Value of 0 is not allowed in the Minimal Delay Random Range field!');
           Exit;
         end;
       end;  
     end else begin
       (Components[a] as TfrBetterSpin).SetFocus();
       Exit;
     end;
   end;
 
 ModalResult:= mrOK;
end;

end.
