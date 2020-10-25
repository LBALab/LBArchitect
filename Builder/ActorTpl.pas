unit ActorTpl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, Utils, SceneLib, SceneLibConst,
  DePack, TplName, Settings, ShellApi;

type
  TfmActorTpl = class(TForm)
    lvTemplates: TListView;
    pcDialogType: TPageControl;
    tsUseTemp: TTabSheet;
    btCreate: TBitBtn;
    btCancel: TBitBtn;
    tsManageTemps: TTabSheet;
    btClose: TBitBtn;
    btNew: TBitBtn;
    btEditName: TBitBtn;
    btDelete: TBitBtn;
    btEditCont: TBitBtn;
    Label1: TLabel;
    procedure lvTemplatesClick(Sender: TObject);
    procedure btCreateClick(Sender: TObject);
  private
    FTplSelName: String;
    procedure MakeTemplatesList();
    function GetTemplateDescription(name: String; out desc: String): Boolean;
    function FindTemplateInList(name: String): Integer;
  public
    function SelectTemplateDialog(): Boolean;
    procedure ManageTemplatesDialog();

    property TplSelName: String read FTplSelName;
  end;

var
  fmActorTpl: TfmActorTpl;

function ActorTemplateToString(desc: String; Actor: TSceneActor): String;
function GetActorTemplatePath(name: String): String;
//procedure GetTemplatesList(var List: TStrings);
function ActorTemplateExists(name: String): Boolean;
function LoadActorFromTemplate(name: String; out Actor: TSceneActor): Boolean;
function SaveActorToTemplate(name, desc: String; Actor: TSceneActor;
  Overwrite: Boolean = False): Boolean; overload;
//This function will display the template name and desc dialog, and then call the above
function SaveActorToTemplate(Actor: TSceneActor): Boolean; overload;

implementation

uses Math, Main, Globals;

{$R *.dfm}

procedure TfmActorTpl.MakeTemplatesList();
var sr: TSearchRec;
    temp: TListItem;
    tname, desc: String;
begin
 lvTemplates.Items.BeginUpdate();
 lvTemplates.Clear();
 if FindFirst(AppPath + 'Templates\*.lat', faReadOnly + faArchive + faHidden, sr) = 0 then begin
   repeat
     tname:= FileNameWithoutExt(sr.Name);
     if GetTemplateDescription(tname, desc) then begin
       temp:= lvTemplates.Items.Add();
       temp.Caption:= tname;
       temp.SubItems.Add(desc);
     end;
   until FindNext(sr) <> 0;
   FindClose(sr);
 end;
 lvTemplates.Items.EndUpdate();
end;

function TfmActorTpl.GetTemplateDescription(name: String; out desc: String): Boolean;
var FStr: TFileStream;
    List: TStringList;
    temp: String;
begin
 FStr:= TFileStream.Create(GetActorTemplatePath(name), fmOpenRead + fmShareDenyWrite);
 try
   FStr.Seek(0, soBeginning);
   List:= TStringList.Create();
   List.NameValueSeparator:= '=';
   List.LoadFromStream(FStr);
   if SceneProjectGetStr(List, 'INFORMATION', 'File', temp)
   and SameText(temp, 'LBA Scene Actor Template')
   and SceneProjectGetStr(List, 'INFORMATION', 'Version', temp) and (temp = '1.0')
   and SceneProjectGetStr(List, 'INFORMATION', 'Description', temp) then begin
     desc:= temp;
     Result:= True;
   end
   else Result:= False;
 except
   Result:= False;
 end;
 FStr.Free();
end;

function TfmActorTpl.FindTemplateInList(name: String): Integer;
var temp: TListItem;
begin
 temp:= lvTemplates.FindCaption(0, name, False, True, False);
 if Assigned(temp) then
   Result:= temp.Index
 else
   Result:= -1;
end;

function TfmActorTpl.SelectTemplateDialog(): Boolean;
begin
 pcDialogType.ActivePage:= tsUseTemp;

 MakeTemplatesList();

 if FTplSelName <> '' then
   lvTemplates.ItemIndex:= FindTemplateInList(FTplSelName);
 lvTemplatesClick(nil);

 Result:= ShowModal() = mrOK;
end;

procedure TfmActorTpl.ManageTemplatesDialog();
begin
 pcDialogType.ActivePage:= tsManageTemps;

 MakeTemplatesList();

 if FTplSelName <> '' then
   lvTemplates.ItemIndex:= FindTemplateInList(FTplSelName);
 lvTemplatesClick(nil);

 ShowModal();
end;

procedure TfmActorTpl.lvTemplatesClick(Sender: TObject);
var ena: Boolean;
begin
 ena:= Assigned(lvTemplates.Selected);
 btCreate.Enabled:= ena;
 btEditName.Enabled:= ena;
 btEditCont.Enabled:= ena;
 btDelete.Enabled:= ena;
end;

function GetActorTemplatePath(name: String): String;
begin
 Result:= AppPath + 'Templates\' + name + '.lat';
end;

{procedure GetTemplatesList(var List: TStrings);
var sr: TSearchRec;
    tname, desc: String;
begin
 List.Clear();
 if FindFirst(AppPath + 'Templates\*.lat', faReadOnly + faArchive + faHidden, sr) = 0 then begin
   repeat
     tname:= FileNameWithoutExt(sr.Name);
     if GetTemplateDescription(tname, desc) then
       List.Add(tname);
   until FindNext(sr) <> 0;
   FindClose(sr);
 end;
end;}

function ActorTemplateExists(name: String): Boolean;
begin
 Result:= FileExists(GetActorTemplatePath(name));
end;

function LoadActorFromTemplate(name: String; out Actor: TSceneActor): Boolean;
var FStr: TFileStream;
    list: TStringList;
    stemp: String;
    itemp: Integer;
begin
 Result:= False;
 Actor.StaticFlags:= sfColObj + sfColBrk + sfZonable + sfPushable + sfFloorTst + sfCanFall;
 Actor.Entity:= 0;
 Actor.Body:= 0;
 Actor.Anim:= 0;
 Actor.Sprite:= 0;
 Actor.HitPower:= 0;
 Actor.BonusType:= 0;
 Actor.Angle:= 0;
 Actor.RotSpeed:= 0;
 Actor.CtrlMode:= 0;
 Actor.Info0:= 0;
 Actor.Info1:= 0;
 Actor.Info2:= 0;
 Actor.Info3:= 0;
 Actor.BonusAmount:= 0;
 Actor.TalkColor:= 0;
 Actor.Armour:= 0;
 Actor.LifePoints:= 1; //If the value is = 0 the Actor won't appear in the Scene
 Actor.TrackScriptTxt:= 'END';
 Actor.LifeScriptTxt:= 'END';
 Actor.UndoRedoIndex:= 0;

 FStr:= TFileStream.Create(GetActorTemplatePath(name), fmOpenRead + fmShareDenyNone);
 try
   try
     FStr.Seek(0, soBeginning);
     List:= TStringList.Create();
     List.NameValueSeparator:= '=';
     List.LoadFromStream(FStr);

     If not SceneProjectGetStr(List, 'INFORMATION', 'File', stemp)
     or not SameText(stemp, 'LBA Scene Actor Template') then Exit;
     If not SceneProjectGetStr(List, 'INFORMATION', 'Version', stemp)
     or (stemp <> '1.0') then Exit;

     //Templates don't have to contain all of the Actor params, so don't
     //  exit if some don't exist.
     If SceneProjectGetInt(List, 'ACTOR', 'StaticFlags', itemp) then
       Actor.StaticFlags:= Word(itemp);
     If SceneProjectGetInt(List, 'ACTOR', 'Entity', itemp) then
       Actor.Entity:= SmallInt(itemp);
     If SceneProjectGetInt(List, 'ACTOR', 'Body', itemp) then
       Actor.Body:= Byte(itemp);
     If SceneProjectGetInt(List, 'ACTOR', 'Animation', itemp) then
       Actor.Anim:= Byte(itemp);
     If SceneProjectGetInt(List, 'ACTOR', 'Sprite', itemp) then
       Actor.Sprite:= Word(itemp);
     If SceneProjectGetInt(List, 'ACTOR', 'HitPower', itemp) then
       Actor.HitPower:= Byte(itemp);
     If SceneProjectGetInt(List, 'ACTOR', 'BonusType', itemp) then
       Actor.BonusType:= Word(itemp);
     If SceneProjectGetInt(List, 'ACTOR', 'FacingAngle', itemp) then
       Actor.Angle:= Word(itemp);
     If SceneProjectGetInt(List, 'ACTOR', 'RotationSpd', itemp) then
       Actor.RotSpeed:= Word(itemp);
     If SceneProjectGetInt(List, 'ACTOR', 'Mode', itemp) then
       Actor.CtrlMode:= Word(itemp);
     If SceneProjectGetInt(List, 'ACTOR', 'CropLeft', itemp) then
       Actor.Info0:= SmallInt(itemp);
     If SceneProjectGetInt(List, 'ACTOR', 'CropTop', itemp) then
       Actor.Info1:= SmallInt(itemp);
     If SceneProjectGetInt(List, 'ACTOR', 'CropRight', itemp) then
       Actor.Info2:= SmallInt(itemp);
     If SceneProjectGetInt(List, 'ACTOR', 'CropBottom', itemp) then
       Actor.Info3:= SmallInt(itemp);
     If SceneProjectGetInt(List, 'ACTOR', 'BonusQuantity', itemp) then
       Actor.BonusAmount:= Byte(itemp);
     If SceneProjectGetInt(List, 'ACTOR', 'TalkColour', itemp) then
       Actor.TalkColor:= Byte(itemp);
     If SceneProjectGetInt(List, 'ACTOR', 'Armour', itemp) then
       Actor.Armour:= Byte(itemp);
     If SceneProjectGetInt(List, 'ACTOR', 'LifePoints', itemp) then
       Actor.LifePoints:= Byte(itemp);
     If not SceneProjectGetSection(List, 'TRACK SCRIPT', Actor.TrackScriptTxt) then
       Actor.TrackScriptTxt:= 'END';
     If not SceneProjectGetSection(List, 'LIFE SCRIPT', Actor.LifeScriptTxt) then
       Actor.LifeScriptTxt:= 'END';
     Result:= True;  
   finally
     FStr.Free();
   end;

 except //just return False
 end;
end;

Function ActorTemplateToString(desc: String; Actor: TSceneActor): String;
begin
  Result:= '[INFORMATION BEGIN]' + CR
         + 'File=LBA Scene Actor Template' + CR
         + 'Version=1.0' + CR
         + 'Description=' + desc + CR
         + '[INFORMATION END]' + CR
         + CR
         + '[ACTOR BEGIN]' + CR
         + 'StaticFlags=' + IntToStr(SmallInt(Actor.StaticFlags)) + CR
         + 'Entity=' + IntToStr(Actor.Entity) + CR
         + 'Body=' + IntToStr(Actor.Body) + CR
         + 'Animation=' + IntToStr(Actor.Anim) + CR
         + 'Sprite=' + IntToStr(Actor.Sprite) + CR
         + 'HitPower=' + IntToStr(Actor.HitPower) + CR
         + 'BonusType=' + IntToStr(Actor.BonusType) + CR
         + 'FacingAngle=' + IntToStr(Actor.Angle) + CR
         + 'RotationSpd=' + IntToStr(Actor.RotSpeed) + CR
         + 'Mode=' + IntToStr(Actor.CtrlMode) + CR
         + 'CropLeft=' + IntToStr(Actor.Info0) + CR
         + 'CropTop=' + IntToStr(Actor.Info1) + CR
         + 'CropRight=' + IntToStr(Actor.Info2) + CR
         + 'CropBottom=' + IntToStr(Actor.Info3) + CR
         + 'BonusQuantity=' + IntToStr(Actor.BonusAmount) + CR
         + 'TalkColour=' + IntToStr(Actor.TalkColor) + CR
         + 'Armour=' + IntToStr(Actor.Armour) + CR
         + 'LifePoints=' + IntToStr(Actor.LifePoints) + CR
         + '[ACTOR END]' + CR
         + CR
         + '[TRACK SCRIPT BEGIN]' + CR
         + Trim(Actor.TrackScriptTxt) + CR
         + '[TRACK SCRIPT END]' + CR
         + CR
         + '[LIFE SCRIPT BEGIN]' + CR
         + Trim(Actor.LifeScriptTxt) + CR
         + '[LIFE SCRIPT END]' + CR;
end;

function SaveActorToTemplate(name, desc: String; Actor: TSceneActor;
  Overwrite: Boolean = False): Boolean;
begin
 Result:= False;
 if not Overwrite and ActorTemplateExists(name) then
   ErrorMsg('Actor Template with this name already exists!')
 else begin
   ForceDirectories(AppPath + 'Templates');
   Result:= SaveStringToFile(ActorTemplateToString(desc, Actor), GetActorTemplatePath(name));
 end;
end;

function SaveActorToTemplate(Actor: TSceneActor): Boolean;
var Name, Desc: String;
begin
 Result:= False;
 if fmTplName.ShowDialog(Name, Desc) then begin
   Result:= SaveActorToTemplate(Name, Desc, Actor);
   if not Result then
     ErrorMsg('Failed to save the Template!');
 end;    
end;

procedure TfmActorTpl.btCreateClick(Sender: TObject);
var Name, Desc: String;
    Temp: TSceneActor;
    NameChange: Boolean;
begin
 if Assigned(lvTemplates.Selected) then begin
   if pcDialogType.ActivePage = tsUseTemp then begin
     FTplSelName:= lvTemplates.Selected.Caption;
     ModalResult:= mrOK;
   end
   else begin
     if (Sender = btEditName) then begin //Edit name and desc
       Name:= lvTemplates.Selected.Caption;
       Desc:= lvTemplates.Selected.SubItems[0];
       if fmTplName.ShowDialog(Name, Desc) then begin
         NameChange:= not SameText(lvTemplates.Selected.Caption, Name);
         If NameChange and ActorTemplateExists(Name) then
           ErrorMsg('Template ''' + Name + ''' already exists!')
         else if not NameChange
         or RenameFile(GetActorTemplatePath(lvTemplates.Selected.Caption),
                       GetActorTemplatePath(Name))
         then begin
           if LoadActorFromTemplate(Name, Temp) then begin
             if not SaveActorToTemplate(Name, Desc, Temp, True) then
               ErrorMsg('Failed to save the Template!');
           end
           else
             ErrorMsg('Failed to open the Template!');
         end
         else
           ErrorMsg('Failed to change the Template name. The file may be in use, or the new name may be invalid.');
       end;
     end
     else if (Sender = btEditCont) or (Sender = lvTemplates) then begin
       if not FileExists(Sett.Scripts.TemplateEditor) then
         if fmSettings.peTplEditor.DialogFile.Execute then
           Sett.Scripts.TemplateEditor:= fmSettings.peTplEditor.DialogFile.FileName;
       if FileExists(Sett.Scripts.TemplateEditor) then
         ShellExecute(fmMain.Handle, 'open', PChar(Sett.Scripts.TemplateEditor),
           PChar(GetActorTemplatePath(lvTemplates.Selected.Caption)),
           PChar(AppPath + 'Templates\'), SW_SHOWNORMAL);
     end
     else if Sender = btDelete then begin //Delete
       if Application.MessageBox('The Template will be permanently deleted. Continue?',
            'Delete the Template', MB_ICONQUESTION +MB_YESNO) = ID_YES
       then
         if not DeleteFile(GetActorTemplatePath(lvTemplates.Selected.Caption)) then
           ErrorMsg('Error while trying to delete the template!');
     end;
     MakeTemplatesList();
   end;
 end
 else
   ErrorMsg('Please select a template first!');

 lvTemplatesClick(nil); //refresh button states
end;

end.
