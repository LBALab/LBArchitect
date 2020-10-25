unit ExitSave;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, StrUtils, Math, ExtCtrls, brace;

type
  TSaveAction = (saDontExit, saDontSave, saMGrid, saScene, saSeparate, saScenario);

  TfmExitSave = class(TForm)
    btNoExit: TBitBtn;
    btGrid: TBitBtn;
    btScene: TBitBtn;
    btBoth: TBitBtn;
    btScenario: TBitBtn;
    btNoSave: TBitBtn;
    Label1: TLabel;
    Label3: TLabel;
    lbScenProps: TLabel;
    imgSave: TImage;
    btSaveAll: TBitBtn;
    procedure btSaveClick(Sender: TObject);
    procedure btSaveAllClick(Sender: TObject);
  private
    Labels: array of TLabel;
    Buttons: array of TBitBtn;
    brSaveAll: TBrace;
    //returns the right boundary of the created label
    function AddItem(Name: String; Colour: TColor; Id: Integer): Integer;
    procedure AlignSaveAllBtn();
  public
    function ShowDialog(Exiting: Boolean): TSaveAction;
  end;

var
  fmExitSave: TfmExitSave;

function CheckModified(Exiting: Boolean): Boolean;

implementation

uses Main, Open, Scenario, Globals;

{$R *.dfm}

function TfmExitSave.AddItem(Name: String; Colour: TColor; Id: Integer): Integer;
var lh: Integer;
begin
 lh:= Length(Labels);
 SetLength(Labels, lh + 1);
 Labels[lh]:= TLabel.Create(Self);
 Labels[lh].Parent:= Self;
 Labels[lh].Font.Style:= [fsBold];
 Labels[lh].Font.Color:= Colour;
 Labels[lh].Left:= 40;
 Labels[lh].Top:= lh * 22 + 44;
 Labels[lh].Caption:= Name;
 Labels[lh].Tag:= Id;
 Result:= Labels[lh].Left + Labels[lh].Width;
 SetLength(Buttons, lh + 1);
 Buttons[lh]:= TBitBtn.Create(Self);
 Buttons[lh].Parent:= Self;
 Buttons[lh].OnClick:= btSaveClick;
 Buttons[lh].SetBounds(16, lh * 22 + 40, 20, 20);
 Buttons[lh].Glyph.Assign(imgSave.Picture.Bitmap);
 Buttons[lh].Tag:= lh;
end;

procedure TfmExitSave.AlignSaveAllBtn();
var a, maxw, bx: Integer;
    ena: Boolean;
begin
  if Assigned(brSaveAll) then begin
    maxw:= 0;
    ena:= False;
    for a:= 0 to High(Labels) do begin
      maxw:= Max(maxw, Labels[a].Left + Labels[a].Width);
      ena:= ena or Buttons[a].Enabled;
    end;
    bx:= Min(maxw + 5, ClientWidth - btSaveAll.Width - 8 - 20);
    brSaveAll.Left:= bx;
    btSaveAll.Left:= bx + 20;
    btSaveAll.Enabled:= ena;
  end;
end;

function TfmExitSave.ShowDialog(Exiting: Boolean): TSaveAction;
var a, bh: Integer;
begin
  if Exiting then begin
    btNoExit.Caption:= 'Don''t exit';
    btNoSave.Caption:= 'Exit anyway';
  end else begin
    btNoExit.Caption:= 'Abort opening';
    btNoSave.Caption:= 'Continue opening anyway';
  end;

  for a:= 0 to High(LdMaps) do
    if LdMaps[a].Modified then
      AddItem(LdMaps[a].Name, clGreen, a);

  if SceneModified then
    AddItem('Scene', clTeal, -1);

  if ScenarioModified then begin
    lbScenProps.Visible:= True;
    lbScenProps.Top:= Length(Labels) * 22 + 44;
  end;

  if Length(Buttons) >= 3 then begin
    bh:= High(Buttons);
    brSaveAll:= TBrace.Create(Self, 0, Buttons[0].Top, 12,
      Buttons[bh].Top + Buttons[bh].Height - Buttons[0].Top, boLeft);
    brSaveAll.Parent:= Self;
    btSaveAll.Top:= brSaveAll.Top + ((brSaveAll.Height - btSaveAll.Height) div 2);
    btSaveAll.Visible:= True;
    AlignSaveAllBtn();
  end;

  ClientHeight:=  180 + Length(Labels) * 22 + IfThen(ScenarioModified, 22);

  case ShowModal of
       mrYes: Result:= saMGrid;
        mrNo: Result:= saScene;
       mrAll: Result:= saSeparate;
     mrRetry: Result:= saScenario;
    mrCancel: Result:= saDontExit;
    mrIgnore: Result:= saDontSave;
         else Result:= saDontExit;
  end;

  for a:= 0 to High(Labels) do begin
    FreeAndNil(Labels[a]);
    FreeAndNil(Buttons[a]);
  end;
  SetLength(Labels, 0);
  SetLength(Buttons, 0);
  lbScenProps.Visible:= False;
  btSaveAll.Visible:= False;
  FreeAndNil(brSaveAll);
end;

procedure TfmExitSave.btSaveClick(Sender: TObject);
var id: Integer;
    Saved: Boolean;
begin
 id:= Labels[(Sender as TBitBtn).Tag].Tag; //Id of the map
 Assert((id >= -1) and (id <= High(LdMaps)), 'fmExitSave.btSaveClick');
 if id >= 0 then begin
   fmMain.SaveMapAuto(LdMaps[id]);
   Saved:= not LdMaps[id].Modified;
 end
 else begin // -1 = save Scene
   fmMain.aSaveScene.Execute();
   Saved:= not SceneModified;
 end;

 if Saved then begin
   id:= (Sender as TBitBtn).Tag; //Id of the button clicked
   Labels[id].Enabled:= False;
   Labels[id].Caption:= Labels[id].Caption + ' (saved)';
   Buttons[id].Enabled:= False;
   AlignSaveAllBtn();
 end;
end;

procedure TfmExitSave.btSaveAllClick(Sender: TObject);
var a: Integer;
begin
 for a:= 0 to High(Buttons) do
   if Buttons[a].Enabled then begin //Not saved manually yet
     btSaveClick(Buttons[a]);
     if Buttons[a].Enabled then Exit; //User cancelled, so break the loop
   end;
end;

//Returns True if we're clear to close the program or open another file(s),
//  False otherwise
//Exiting parameter influences the "don't exit" and "exit anyway" button names only
function CheckModified(Exiting: Boolean): Boolean;
var a: Integer;
    GMod: Boolean;
begin
 Result:= True;
 GMod:= False;
 for a:= 0 to High(LdMaps) do
   if LdMaps[a].Modified then begin
     GMod:= True;
     Break;
   end;

 If GMod or SceneModified or ScenarioModified then begin
   If ScenarioState then begin
     case Application.MessageBox('Current Scenario has been changed. Save?', ProgramName, MB_ICONQUESTION+MB_YESNOCANCEL) of
       ID_YES: begin
         fmMain.aSaveScenario.Execute();
         If ScenarioModified then Result:= False;
       end;
       ID_CANCEL: Result:= False;
     end;
   end
   else begin
     case fmExitSave.ShowDialog(Exiting) of
       saDontExit: Result:= False;
       //saDontSave: do nothing
       {saMGrid: begin
         fmMain.SaveMapAuto(LdMaps[0]);
         If LdMaps[0].Modified then Result:= False;
       end;
       saScene: begin
         fmMain.aSaveScene.Execute();
         If SceneModified then Result:= False;
       end;
       saSeparate: begin
         for a:= 0 to High(LdMaps) do begin
           fmMain.SaveMapAuto(LdMaps[a]);
           if LdMaps[a].Modified then begin //User cancelled saving, so break the loop
             Result:= False;
             Exit;
           end;
         end;
         fmMain.aSaveScene.Execute();
         If SceneModified then Result:= False;
       end;}
       saScenario: begin
         fmMain.aSaveScenario.Execute();
         If ScenarioModified then Result:= False;
       end;
     end;
   end;
 end;
end;

end.
