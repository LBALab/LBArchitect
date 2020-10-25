unit ScriptEd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, SynEdit, SynEditHighlighter,
  scLifeScript1HL, scTrackScript1HL, scTrackScript2HL, scLifeScript2HL,
  SynCompletionProposal, StdCtrls, ComCtrls, Buttons, Scene, SceneLib,
  SceneLibConst, SceneLibComp, Settings, ActorInfo, SynEditTextBuffer, StrUtils,
  ActnList, Menus, ActnPopup;

type
  TScrUndoRedoList = record 
    Index: Integer;
    TrackUndo: TSynEditUndoList;
    TrackRedo: TSynEditUndoList;
    LifeUndo: TSynEditUndoList;
    LifeRedo: TSynEditUndoList;
  end;

  TfmScriptEd = class(TForm)
    Label1: TLabel;
    btCompile: TBitBtn;
    paEditors: TPanel;
    spHoriz: TSplitter;
    spVert: TSplitter;
    pcBottom: TPageControl;
    tsMessages: TTabSheet;
    lbMessages: TListBox;
    btSettings: TBitBtn;
    cbEditorOnTop: TCheckBox;
    btNextActor: TBitBtn;
    btPrevActor: TBitBtn;
    eActor: TEdit;
    paUndoRedo: TPanel;
    btLifeUndo: TSpeedButton;
    btLifeRedo: TSpeedButton;
    btTrackUndo: TSpeedButton;
    btTrackRedo: TSpeedButton;
    Bevel1: TBevel;
    btSearch: TBitBtn;
    btCompileAc: TBitBtn;
    abCompileAc: TPopupActionBar;
    mCompileCur: TMenuItem;
    mCompileAll: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure scpTrackScriptExecute(Kind: TSynCompletionType;
      Sender: TObject; var CurrentInput: String; var x, y: Integer;
      var CanExecute: Boolean);
    procedure scpLifeScriptExecute(Kind: TSynCompletionType;
      Sender: TObject; var CurrentInput: String; var x, y: Integer;
      var CanExecute: Boolean);
    procedure btCompileClick(Sender: TObject);
    procedure lbMessagesData(Control: TWinControl; Index: Integer;
      var Data: String);
    function lbMessagesDataFind(Control: TWinControl;
      FindString: String): Integer;
    procedure lbMessagesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lbMessagesDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btSettingsClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure seLifeScriptChange(Sender: TObject);
    procedure seTrackScriptChange(Sender: TObject);
    procedure btPrevActorClick(Sender: TObject);
    procedure eActorChange(Sender: TObject);
    procedure btUndoRedoClick(Sender: TObject);
    procedure spHorizMoved(Sender: TObject);
    procedure btSearchClick(Sender: TObject);
    procedure btCompileAcClick(Sender: TObject);
    procedure mCompileAllClick(Sender: TObject);
  private
    CompMsgs: TCompMessages;
    scLifeScript1HL: TSynLifeScript1HL;
    scTrackScript1HL: TSynTrackScript1HL;
    scLifeScript2HL: TSynLifeScript2HL;
    scTrackScript2HL: TSynTrackScript2HL;
    Actor: Integer;
    procedure InitHighlighters();
    procedure SetEditorParams(Lba1: Boolean);
    procedure WriteActorScripts();
    procedure ActorBtnEnable();
    procedure ActivateUndoRedoButtons();
    procedure FreeActorUndoRedo(var AUR: TScrUndoRedoList);
    function FindActorUndoRedo(): Integer;
    procedure StoreActorUndoRedo();
    procedure RestoreActorUndoRedo();
    procedure InitACLba1Org();
    procedure ModACLba1Comp();
    procedure ModACLba1Eng(CompModded: Boolean);
    procedure InitACLba2Org();
    procedure ModACLba2Comp();
    procedure ModACLba2Eng(CompModded: Boolean);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    seLifeScript: TSynEdit;
    seTrackScript: TSynEdit;
    scpLifeScript: TSynCompletionProposal;
    scpTrackScript: TSynCompletionProposal;
    ScriptsVisible: Boolean; //To show the window again when switching to Scene Mode
    LastActor: Integer;
    procedure FillBodiesList(ObjIndex: Integer; Proposal: TSynCompletionProposal);
    procedure FillAnimsList(ObjIndex: Integer; Proposal: TSynCompletionProposal);
    procedure FillTracksList(ObjIndex, ColumnW: Integer; Proposal: TSynCompletionProposal);
    procedure OpenScripts(AActor: Integer; SkipShow: Boolean = False);
    procedure SetEditorsOptions(FontSize: Integer);
    procedure SetupAutoCompLists();
    function CompileAllScripts(Lba: Byte; var Scene: TScene): Boolean; //Returns True if there are no errors
    procedure ClearMessages();
    procedure DeleteAllActorUndoRedo();
    procedure DeleteUnusedActorUndoRedo();
  end;

var
  fmScriptEd: TfmScriptEd;

  TrackScriptACIt, TrackScriptACIn: TStringList;
  LifeScriptACCmdIt, LifeScriptACCmdIn: TStringList;
  LifeScriptACVarIt, LifeScriptACVarIn: TStringList;
  LifeScriptACBehIt, LifeScriptACBehIn: TStringList;
  LifeScriptACDirIt, LifeScriptACDirIn: TStringList;

  ScrUndoRedo: array of TScrUndoRedoList; //One item for each Actor
  NextUndoIndex: Cardinal = 1;

procedure OnCompMessage(Msg: TCompMessage);

implementation

uses Math, Main, Utils, Globals, SearchScript, SceneLib1Tab, SceneLib2Tab;

{$R *.dfm}
 
procedure TfmScriptEd.FormCreate(Sender: TObject);
begin
 seLifeScript:= TSynEdit.Create(Self);
 seLifeScript.Parent:= paEditors;
 seLifeScript.SetBounds(2, 2, 287, 301);
 seLifeScript.Align:= alLeft;
 seLifeScript.Font.Charset:= DEFAULT_CHARSET;
 seLifeScript.Font.Color:= clWindowText;
 seLifeScript.Font.Height:= -13;
 seLifeScript.Font.Name:= 'Courier New';
 seLifeScript.Font.Style:= [];
 seLifeScript.TabOrder:= 0;
 seLifeScript.TabStop:= False;
 seLifeScript.BookMarkOptions.DrawBookmarksFirst:= False;
 seLifeScript.BookMarkOptions.EnableKeys:= False;
 seLifeScript.Gutter.Font.Charset:= DEFAULT_CHARSET;
 seLifeScript.Gutter.Font.Color:= clWindowText;
 seLifeScript.Gutter.Font.Height:= -11;
 seLifeScript.Gutter.Font.Name:= 'Courier New';
 seLifeScript.Gutter.Font.Style:= [];
 seLifeScript.Gutter.LeftOffset:= 2;
 seLifeScript.Gutter.ShowLineNumbers:= True;
 seLifeScript.Gutter.Gradient:= True;
 seLifeScript.MaxScrollWidth:= 100;
 seLifeScript.Options:= [eoAutoIndent, eoDragDropEditing, eoEnhanceEndKey, eoGroupUndo,
   eoScrollPastEol, eoShowScrollHint, eoSmartTabDelete, eoTabIndent, eoTabsToSpaces];
 seLifeScript.TabWidth:= 2;
 seLifeScript.WantTabs:= True;
 seLifeScript.OnChange:= seLifeScriptChange;
 seTrackScript:= TSynEdit.Create(Self);
 seTrackScript.Parent:= paEditors;
 seTrackScript.SetBounds(293, 2, 304, 301);
 seTrackScript.Align:= alClient;
 seTrackScript.Font.Charset:= DEFAULT_CHARSET;
 seTrackScript.Font.Color:= clWindowText;
 seTrackScript.Font.Height:= -13;
 seTrackScript.Font.Name:= 'Courier New';
 seTrackScript.Font.Style:= [];
 seTrackScript.TabOrder:= 1;
 seTrackScript.BookMarkOptions.DrawBookmarksFirst:= False;
 seTrackScript.BookMarkOptions.EnableKeys:= False;
 seTrackScript.Gutter.Font.Charset:= DEFAULT_CHARSET;
 seTrackScript.Gutter.Font.Color:= clWindowText;
 seTrackScript.Gutter.Font.Height:= -11;
 seTrackScript.Gutter.Font.Name:= 'Courier New';
 seTrackScript.Gutter.Font.Style:= [];
 seTrackScript.Gutter.LeftOffset:= 2;
 seTrackScript.Gutter.ShowLineNumbers:= True;
 seTrackScript.Gutter.Gradient:= True;
 seTrackScript.MaxScrollWidth:= 100;
 seTrackScript.TabWidth:= 2;
 seTrackScript.OnChange:= seTrackScriptChange;
 scpLifeScript:= TSynCompletionProposal.Create(Self);
 scpLifeScript.Options:= [scoLimitToMatchedText, scoUseInsertList, scoUsePrettyText,
   scoUseBuiltInTimer, scoEndCharCompletion, scoCompleteWithTab, scoCompleteWithEnter];
 scpLifeScript.NbLinesInWindow:= 20;
 scpLifeScript.Width:= 500;
 scpLifeScript.EndOfTokenChr:= '()[]. ';
 scpLifeScript.TriggerChars:= ' ';
 scpLifeScript.Font.Charset:= DEFAULT_CHARSET;
 scpLifeScript.Font.Color:= clWindowText;
 scpLifeScript.Font.Height:= -11;
 scpLifeScript.Font.Name:= 'MS Sans Serif';
 scpLifeScript.Font.Style:= [];
 scpLifeScript.TitleFont.Charset:= DEFAULT_CHARSET;
 scpLifeScript.TitleFont.Color:= clBtnText;
 scpLifeScript.TitleFont.Height:= -11;
 scpLifeScript.TitleFont.Name:= 'MS Sans Serif';
 scpLifeScript.TitleFont.Style:= [fsBold];
 scpLifeScript.Columns.Add().BiggestWord:= 'ASK_CHOICE_OBJ actor_id(int)_..';
 scpLifeScript.OnExecute:= scpLifeScriptExecute;
 scpLifeScript.ShortCut:= 16416;
 scpLifeScript.Editor:= seLifeScript;
 scpLifeScript.TimerInterval:= 500;
 scpTrackScript:= TSynCompletionProposal.Create(Self);
 scpTrackScript.Options:= [scoLimitToMatchedText, scoUseInsertList, scoUsePrettyText,
    scoUseBuiltInTimer, scoEndCharCompletion, scoCompleteWithTab, scoCompleteWithEnter];
 scpTrackScript.NbLinesInWindow:= 20;
 scpTrackScript.Width:= 500;
 scpTrackScript.EndOfTokenChr:= '()[]. ';
 scpTrackScript.TriggerChars:= ' ';
 scpTrackScript.Font.Charset:= DEFAULT_CHARSET;
 scpTrackScript.Font.Color:= clWindowText;
 scpTrackScript.Font.Height:= -11;
 scpTrackScript.Font.Name:= 'MS Sans Serif';
 scpTrackScript.Font.Style:= [];
 scpTrackScript.TitleFont.Charset:= DEFAULT_CHARSET;
 scpTrackScript.TitleFont.Color:= clBtnText;
 scpTrackScript.TitleFont.Height:= -11;
 scpTrackScript.TitleFont.Name:= 'MS Sans Serif';
 scpTrackScript.TitleFont.Style:= [fsBold];
 scpTrackScript.Columns.Add().BiggestWord:= 'WAIT_NUM_SECOND_a';
 scpTrackScript.OnExecute:= scpTrackScriptExecute;
 scpTrackScript.ShortCut:= 16416;
 scpTrackScript.Editor:= seTrackScript;
 scpTrackScript.TimerInterval:= 500;

 btSettings.Glyph.TransparentColor:= clFuchsia;

 Actor:= -1;
 InitHighlighters();
 SetEditorParams(True);
 ScriptsVisible:= False;
end;

procedure TfmScriptEd.OpenScripts(AActor: Integer; SkipShow: Boolean = False);
begin
 if (AActor < 0) or (AActor > High(VScene.Actors)) then Exit; //Just in case
 if Sett.Scripts.ScriptToActor and not SkipShow
 and ((SelType <> otActor) or (SelId <> AActor)) then begin
   SelectObject(otActor, AActor);
   Exit;
 end;
 if Actor > -1 then begin
   WriteActorScripts();
   StoreActorUndoRedo();
 end;
 SetEditorParams(LbaMode = 1);
 Actor:= AActor;
 LastActor:= Actor;
 Caption:= 'Script editor - Actor ' + IntToStr(Actor);
 seLifeScript.Text:= VScene.Actors[Actor].LifeScriptTxt;
 seTrackScript.Text:= VScene.Actors[Actor].TrackScriptTxt;
 seLifeScript.LeftChar:= VScene.Actors[Actor].LifeScriptCoords.X;
 seLifeScript.TopLine:= VScene.Actors[Actor].LifeScriptCoords.Y;
 //seLifeScript.CaretX:= VScene.Actors[Actor].LifeScriptCaret.X;
 //seLifeScript.CaretY:= VScene.Actors[Actor].LifeScriptCaret.Y;
 seTrackScript.LeftChar:= VScene.Actors[Actor].TrackScriptCoords.X;
 seTrackScript.TopLine:= VScene.Actors[Actor].TrackScriptCoords.Y;
 //seTrackScript.CaretX:= VScene.Actors[Actor].TrackScriptCaret.X;
 //seTrackScript.CaretY:= VScene.Actors[Actor].TrackScriptCaret.Y;
 eActor.Text:= IntToStr(Actor);
 RestoreActorUndoRedo();
 ActivateUndoRedoButtons();
 ActorBtnEnable();
 if not Visible then Show();
 if WindowState = wsMinimized then
   SendMessage(Handle, WM_SYSCOMMAND, SC_RESTORE, 0);
end;

procedure TfmScriptEd.InitHighlighters();
begin
 scLifeScript1HL:= TSynLifeScript1HL.Create(fmScriptEd);
 scTrackScript1HL:= TSynTrackScript1HL.Create(fmScriptEd);
 scLifeScript2HL:= TSynLifeScript2HL.Create(fmScriptEd);
 scTrackScript2HL:= TSynTrackScript2HL.Create(fmScriptEd);
end;

procedure TfmScriptEd.SetEditorParams(Lba1: Boolean);
begin
 if Lba1 then begin
   seLifeScript.Highlighter:= scLifeScript1HL;
   seTrackScript.Highlighter:= scTrackScript1HL;
 end else begin //LBA2
   seLifeScript.Highlighter:= scLifeScript2HL;
   seTrackScript.Highlighter:= scTrackScript2HL;
 end;
end;

procedure TfmScriptEd.SetEditorsOptions(FontSize: Integer);
begin
 If Sett.Scripts.CompletionProp then begin
   scpLifeScript.Options:= scpLifeScript.Options + [scoUseBuiltinTimer];
   scpTrackScript.Options:= scpLifeScript.Options + [scoUseBuiltinTimer];
 end
 else begin
   scpLifeScript.Options:= scpLifeScript.Options - [scoUseBuiltinTimer];
   scpTrackScript.Options:= scpLifeScript.Options - [scoUseBuiltinTimer];
 end;
 if Sett.Scripts.TxtGroupUndo then begin
   seLifeScript.Options:= seLifeScript.Options + [eoGroupUndo];
   seTrackScript.Options:= seTrackScript.Options + [eoGroupUndo];
 end
 else begin
   seLifeScript.Options:= seLifeScript.Options - [eoGroupUndo];
   seTrackScript.Options:= seTrackScript.Options - [eoGroupUndo];
 end;
 seLifeScript.Font.Size:= FontSize;
 seLifeScript.Gutter.Font.Size:= FontSize;
 seTrackScript.Font.Size:= FontSize;
 seTrackScript.Gutter.Font.Size:= FontSize;
end;

procedure TfmScriptEd.SetupAutoCompLists();
begin
 if LbaMode = 1 then begin
   InitACLba1Org();
   if not ScrSet.Decomp.CompoOrg then
     ModACLba1Comp();
   if not ScrSet.Decomp.Lba1MacroOrg then
     ModACLba1Eng(not ScrSet.Decomp.CompoOrg);
 end else begin
   InitACLba2Org();
   if not ScrSet.Decomp.CompoOrg then
     ModACLba2Comp();
   if not ScrSet.Decomp.Lba2MacroOrg then
     ModACLba2Eng(not ScrSet.Decomp.CompoOrg);
 end;  
 if not ScrSet.Decomp.UpperCase then begin
   TrackScriptACIn.Text:= LowerCase(TrackScriptACIn.Text);
   LifeScriptACCmdIn.Text:= LowerCase(LifeScriptACCmdIn.Text);
   LifeScriptACVarIn.Text:= LowerCase(LifeScriptACVarIn.Text);
   LifeScriptACBehIn.Text:= LowerCase(LifeScriptACBehIn.Text);
   LifeScriptACDirIn.Text:= LowerCase(LifeScriptACDirIn.Text);
 end;
end;

procedure TfmScriptEd.WriteActorScripts();
begin
 If Actor > -1 then begin
   VScene.Actors[Actor].TrackScriptTxt:= seTrackScript.Text;
   VScene.Actors[Actor].TrackScriptCoords:=
     Point(seTrackScript.LeftChar, seTrackScript.TopLine);
   //VScene.Actors[Actor].TrackScriptCaret:=
   //  Point(seTrackScript.CaretX, seTrackScript.CaretY);
   VScene.Actors[Actor].LifeScriptTxt:= seLifeScript.Text;
   VScene.Actors[Actor].LifeScriptCoords:=
     Point(seLifeScript.LeftChar, seLifeScript.TopLine);
   //VScene.Actors[Actor].LifeScriptCaret:=
   //  Point(seLifeScript.CaretX, seLifeScript.CaretY);
 end;  
end;

procedure TfmScriptEd.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle:= Params.ExStyle or WS_EX_APPWINDOW;
end;

function LineParams(text: String): String;
var a: Integer;
begin
 Result:= '';
 for a:= 1 to Length(text) do
   if text[a] in [' ', #13, #10, #09] then begin
     Result:= RightStr(text, Length(text) - a);
     Break;
   end;
end;

procedure TfmScriptEd.FillBodiesList(ObjIndex: Integer; Proposal: TSynCompletionProposal);
var a: Integer;
    Entity: TEntity;
    VIndex: String;
begin
  if ObjIndex < 0 then ObjIndex:= Actor;
  Entity:= ActorEntities[VScene.Actors[ObjIndex].Entity];
  for a:= 0 to High(Entity.Bodies) do begin
    VIndex:= IntToStr(Entity.Bodies[a].VirtualIndex);
    Proposal.InsertList.Add(VIndex);
    Proposal.ItemList.Add('\style{+B}\color{clMaroon}' + VIndex + '\style{-B} \column{}\color{clGray}'
      + RemoveRealIndex(BodyName(Entity.Bodies[a].RealIndex)));
  end;
end;

procedure TfmScriptEd.FillAnimsList(ObjIndex: Integer; Proposal: TSynCompletionProposal);
var a: Integer;
    Entity: TEntity;
    VIndex: String;
begin
  if ObjIndex < 0 then ObjIndex:= Actor;
  Entity:= ActorEntities[VScene.Actors[ObjIndex].Entity];
  for a:= 0 to High(Entity.Anims) do begin
    VIndex:= IntToStr(Entity.Anims[a].VirtualIndex);
    Proposal.InsertList.Add(VIndex);
    Proposal.ItemList.Add('\style{+B}\color{clMaroon}' + VIndex + '\style{-B} \column{}\color{clGray}'
      + RemoveRealIndex(AnimName(Entity.Anims[a].RealIndex)));
  end;
end;

procedure TfmScriptEd.FillTracksList(ObjIndex, ColumnW: Integer; Proposal: TSynCompletionProposal);
var a: Integer;
    ScriptLines: TStringList;
    VIndex, VName, column: String;
    Params: TStrDynAr;
begin
  if ObjIndex < 0 then ObjIndex:= Actor;
  ScriptLines:= TStringList.Create();
  ScriptLines.Text:= VScene.Actors[ObjIndex].TrackScriptTxt;
  for a:= 0 to ScriptLines.Count - 1 do begin
    VIndex:= Trim(ScriptLines[a]);
    if SameText(LeftStr(VIndex, 5), 'LABEL') then begin
      Params:= ParseCSVLine(VIndex, ' ');
      if Length(Params) >= 2 then begin
        VIndex:= Params[1];
        if Length(Params) >= 3 then VName:= Params[2]
                               else VName:= VIndex;
        Proposal.InsertList.Add(VName);
        column:= IfThen(Length(VName) > ColumnW, '  ', '\column{}');
        Proposal.ItemList.Add('\style{+B}\color{clMaroon}' + VName + '\style{-B} ' + column + '\color{clGray}'
          + 'Track ' + VIndex + IfThen(Length(Params) >= 3, ' ('+VName+')'));
      end;
    end;
  end;
  FreeAndNil(ScriptLines);
end;

procedure TfmScriptEd.scpTrackScriptExecute(Kind: TSynCompletionType;
  Sender: TObject; var CurrentInput: String; var x, y: Integer;
  var CanExecute: Boolean);
var temp1, VIndex, column: String;
    a: Integer;
    temp2: TStrDynAr;
const MaxLen = 5; //BiggestWord minus 1    
begin
 scpTrackScript.ItemList.Clear;
 scpTrackScript.InsertList.Clear;

 temp1:= Trim(Copy(scpTrackScript.Editor.LineText, 1,
         scpTrackScript.Editor.CaretX - Length(CurrentInput) - 1));

 if temp1 = '' then begin
   scpTrackScript.Columns[0].BiggestWord:=
     IfThen(LBAMode = 1, 'WAIT_NUM_SECOND_a', 'WAIT_NUM_DSEC_RND_a');
   scpTrackScript.ItemList.Assign(TrackScriptACIt);
   scpTrackScript.InsertList.Assign(TrackScriptACIn);
 end else begin
   scpTrackScript.Columns[0].BiggestWord:= '100000';
   if SameText(temp1, 'BODY') then begin
     if (VScene.Actors[Actor].StaticFlags and sfSprite) = 0 then
       FillBodiesList(Actor, scpTrackScript);
   end
   else if SameText(temp1, 'ANIM') then begin
     if (VScene.Actors[Actor].StaticFlags and sfSprite) = 0 then
       FillAnimsList(Actor, scpTrackScript);
   end
   else if TextInArray(temp1, ['GOTO_POINT', 'GOTO_POINT_3D',
             'POS_POINT', 'GOTO_SYM_POINT'])
   then begin
     for a:= 0 to High(VScene.Points) do begin
       VIndex:= IntToStr(a);
       scpTrackScript.InsertList.Add(VIndex);
       scpTrackScript.ItemList.Add('\style{+B}\color{clMaroon}' + VIndex + '\style{-B} \column{}\color{clGray}'
         + 'Point ' + VIndex + IfThen(VScene.Points[a].Name <> '', ': ' + VScene.Points[a].Name));
     end;
   end
   else if SameText(temp1, 'GOTO') then begin
     scpTrackScript.InsertList.Add('-1');
     scpTrackScript.ItemList.Add('\style{+B}\color{clMaroon}-1\style{-B} \column{}\color{clGray}'
       + 'Jump nowhere (stop)');
     for a:= 0 to seTrackScript.Lines.Count - 1 do begin
       VIndex:= Trim(seTrackScript.Lines[a]);
       if SameText(LeftStr(VIndex, 5), 'LABEL') then begin
         temp2:= ParseCSVLine(VIndex, ' ');
         if Length(temp2) >= 2 then begin
           VIndex:= temp2[1];
           if Length(temp2) >= 3 then VIndex:= temp2[2];
           scpTrackScript.InsertList.Add(VIndex);
           column:= IfThen(Length(VIndex) > MaxLen, '  ', '\column{}');
           scpTrackScript.ItemList.Add('\style{+B}\color{clMaroon}' + VIndex + '\style{-B} ' + column + '\color{clGray}'
             + 'Jump to label ' + VIndex);
         end;    
       end;
     end;
   end
   else if TextInArray(temp1, ['SAMPLE', 'SIMPLE_SAMPLE', 'SAMPLE_STOP',
             'SAMPLE_RND', 'SAMPLE_ALWAYS'])
   then begin
     for a:= 0 to High(SampleNames) do begin
       VIndex:= IntToStr(SampleIndexes[a]);
       scpTrackScript.InsertList.Add(VIndex);
       scpTrackScript.ItemList.Add('\style{+B}\color{clMaroon}' + VIndex + '\style{-B} \column{}\color{clGray}'
         + SampleNames[a]);
     end;
   end
   else if TextInArray(temp1, ['PLAY_FLA', 'PLAY_ACF', 'PLAY_SMK']) then begin
     for a:= 0 to High(MovieNames) do begin
       scpTrackScript.InsertList.Add(MovieNames[a]);
       scpTrackScript.ItemList.Add('\style{+B}\color{clMaroon}' + MovieNames[a]);
     end;
   end
   else if SameText(temp1, 'SPRITE') then begin
     for a:= 0 to High(SpriteIndexes) do begin
       VIndex:= IntToStr(SpriteIndexes[a]);
       scpTrackScript.InsertList.Add(VIndex);
       scpTrackScript.ItemList.Add('\style{+B}\color{clMaroon}' + VIndex + '\style{-B} \column{}\color{clGray}'
         + SpriteNames[a]);
     end;
   end else
     CanExecute:= False;
 end;
end;

procedure TfmScriptEd.scpLifeScriptExecute(Kind: TSynCompletionType;
  Sender: TObject; var CurrentInput: String; var x, y: Integer;
  var CanExecute: Boolean);
var temp1, {temp2, }VIndex, column: String;
    a, b, ObjIndex: Integer;
    Segments, Params: TStrDynAr;
    ScriptLines: TStringList;
    cond: Boolean;
const MaxLen = 5; //BiggestWord minus 1

  procedure ActorsList();
  var a: Integer;
  begin
    scpLifeScript.InsertList.Add(IfThen(ScrSet.Decomp.UpperCase, 'SELF', 'self'));
    scpLifeScript.ItemList.Add('\style{+B}\color{clBlack}SELF\style{-B} \column{}\color{clGray}Current Actor');
    for a:= 0 to High(VScene.Actors) do begin
      VIndex:= IntToStr(a);
      scpLifeScript.InsertList.Add(VIndex);
      scpLifeScript.ItemList.Add('\style{+B}\color{clMaroon}' + VIndex + '\style{-B} \column{}\color{clGray}'
        + 'Actor ' + VIndex + IfThen(VScene.Actors[a].Name <> '', ': ' + VScene.Actors[a].Name));
    end;
  end;

  procedure InventoryList();
  var a: Integer;
  begin
    for a:= 0 to High(InvObjNames) do begin
      VIndex:= IntToStr(InvObjIndexes[a]);
      scpLifeScript.InsertList.Add(VIndex);
      scpLifeScript.ItemList.Add('\style{+B}\color{clMaroon}' + VIndex + '\style{-B} \column{}\color{clGray}'
        + InvObjNames[a]);
    end;
  end;

  procedure ZonesList();
  var a: Integer;
  begin
    for a:= 0 to High(VScene.Zones) do begin
      if VScene.Zones[a].RealType = ztSceneric then begin
        VIndex:= IntToStr(VScene.Zones[a].VirtualID);
        scpLifeScript.InsertList.Add(VIndex);
        scpLifeScript.ItemList.Add('\style{+B}\color{clMaroon}' + VIndex + '\style{-B} \column{}\color{clGray}'
          + 'Sceneric Zone ' + VIndex + IfThen(VScene.Zones[a].Name <> '', ': ' + VScene.Zones[a].Name));
      end;
    end;
  end;

begin
 scpLifeScript.ItemList.Clear;
 scpLifeScript.InsertList.Clear;
 {temp:= TrimLeft(scpLifeScript.Editor.LineText);
 }
 temp1:= Trim(Copy(scpLifeScript.Editor.LineText, 1,
              scpLifeScript.Editor.CaretX - Length(CurrentInput) - 1));
 Segments:= ParseCSVLine(temp1, ' ');
 //temp1 contains line to the left of the cursor
 cond:= (Length(Segments) >= 1)
    and TextInArray(Segments[0], ['IF', 'ONEIF', 'SWIF', 'OR_IF',
          'NEVERIF', 'SNIF', 'AND_IF', 'SWITCH']);

 scpLifeScript.Columns[0].BiggestWord:= 'ASK_CHOICE_OBJ actor_id(int)_..';
 if Length(Segments) <= 0 then begin
   scpLifeScript.ItemList.Assign(LifeScriptACCmdIt);
   scpLifeScript.InsertList.Assign(LifeScriptACCmdIn);
 end
 else if cond then begin
   if Length(Segments) = 1 then begin
     scpLifeScript.ItemList.Assign(LifeScriptACVarIt);
     scpLifeScript.InsertList.Assign(LifeScriptACVarIn);
   end else if Length(Segments) = 2 then begin
     scpLifeScript.Columns[0].BiggestWord:= '100000';
     if TextInArray(Segments[1], ['COL_OBJ', 'DISTANCE', 'DISTANCE_3D',
          'ZONE_OBJ', 'BODY_OBJ', 'ANIM_OBJ', 'CURRENT_TRACK_OBJ',
          'L_TRACK_OBJ', 'CONE_VIEW', 'LIFE_POINT_OBJ', 'BETA_OBJ',
          'ANGLE', 'DISTANCE_MESSAGE', 'REAL_ANGLE',
          'CARRY_OBJ_BY', 'CARRIED_OBJ_BY', 'HIT_OBJ_BY', 'COL_DECORS_OBJ',
          'OBJECT_DISPLAYED', 'ANGLE_OBJ'])
     then
       ActorsList()
     else if SameText(Segments[1], 'USE_INVENTORY') then
       InventoryList()
     else
       CanExecute:= False;
   end else if ((Length(Segments) = 3) and StrInArray(Segments[2], OperDecompList))
            or ((Length(Segments) = 4) and StrInArray(Segments[3], OperDecompList))
   then begin
     if SameText(Segments[2], 'SELF') then ObjIndex:= Actor
     else ObjIndex:= StrToIntDef(Segments[2], -1);
     if ObjIndex > High(VScene.Actors) then ObjIndex:= -1;
     scpLifeScript.Columns[0].BiggestWord:= '100000';

     if TextInArray(Segments[1], ['COL', 'COL_OBJ', 'HIT_BY', 'HIT_OBJ_BY',
          'CARRY_BY', 'CARRIED_BY', 'CARRY_OBJ_BY', 'CARRIED_OBJ_BY'])
     then
       ActorsList()
     else if TextInArray(Segments[1], ['ZONE', 'ZONE_OBJ']) then
       ZonesList()
     else if SameText(Segments[1], 'BODY')
     or (SameText(Segments[1], 'BODY_OBJ') and (ObjIndex > -1)) then
       FillBodiesList(ObjIndex, scpLifeScript)
     else if SameText(Segments[1], 'ANIM')
     or (SameText(Segments[1], 'ANIM_OBJ') and (ObjIndex > -1)) then
       FillAnimsList(ObjIndex, scpLifeScript)
     else if TextInArray(Segments[1], ['L_TRACK', 'CURRENT_TRACK'])
     or (TextInArray(Segments[1], ['L_TRACK_OBJ', 'CURRENT_TRACK_OBJ']) and (ObjIndex > -1)) then
       FillTracksList(ObjIndex, MaxLen, scpLifeScript)
     else if TextInArray(Segments[1],
               ['COMPORTEMENT_HERO', 'COMPORTMENT_HERO', 'BEHAVIOUR'])
     then begin
       scpLifeScript.ItemList.Assign(LifeScriptACBehIt);
       scpLifeScript.InsertList.Assign(LifeScriptACBehIn);
     end;
   end
 end
 else if TextInArray(temp1,
           ['COMPORTEMENT_HERO', 'COMPORTMENT_HERO', 'SET_BEHAVIOUR'])
 then begin
   scpLifeScript.ItemList.Assign(LifeScriptACBehIt);
   scpLifeScript.InsertList.Assign(LifeScriptACBehIn);
 end
 else begin //Length(Segments) > 0
   if Length(Segments) >= 2 then begin
     if SameText(Segments[1], 'SELF') then ObjIndex:= Actor
     else ObjIndex:= StrToIntDef(Segments[1], -1);
     if ObjIndex > High(VScene.Actors) then ObjIndex:= -1;
   end else
     ObjIndex:= -1;

   if TextInArray(temp1, ['SET_DIR', 'SET_DIRMODE'])
   or ((Length(Segments) = 2)
       and TextInArray(Segments[0], ['SET_DIR_OBJ', 'SET_DIRMODE_OBJ'])
       and (ObjIndex > -1))
   then begin
     scpLifeScript.ItemList.Assign(LifeScriptACDirIt);
     scpLifeScript.InsertList.Assign(LifeScriptACDirIn);
   end
   else begin
     scpLifeScript.Columns[0].BiggestWord:= '100000';

     if TextInArray(temp1, ['BODY_OBJ', 'ANIM_OBJ', {'SET_LIFE_OBJ',}
          'SET_TRACK_OBJ', 'SET_DIR_OBJ', 'SET_DIRMODE_OBJ', 'CAM_FOLLOW',
          'SET_COMPORTEMENT_OBJ', 'SET_COMPORTMENT_OBJ', 'KILL_OBJ',
          'MESSAGE_OBJ', 'SET_LIFE_POINT_OBJ', 'SUB_LIFE_POINT_OBJ', 'HIT_OBJ',
          'INIT_PINGOUIN', 'INIT_PENGUIN', 'SAY_MESSAGE_OBJ', 'EXPLODE_OBJ',
          'ASK_CHOICE_OBJ',
          'IMPACT_OBJ', 'ADD_MESSAGE_OBJ', 'SET_ARMURE_OBJ', 'SET_ARMOUR_OBJ',
          'ADD_LIFE_POINT_OBJ', 'STOP_L_TRACK_OBJ', 'STOP_TRACK_OBJ',
          'RESTORE_L_TRACK_OBJ', 'RESTORE_TRACK_OBJ', 'SAVE_COMPORTEMENT_OBJ',
          'SAVE_COMPORTMENT_OBJ', 'SAVE_COMP_OBJ', 'RESTORE_COMPORTEMENT_OBJ',
          'RESTORE_COMPORTMENT_OBJ', 'RESTORE_COMP_OBJ', 'DEBUG_OBJ',
          'FLOW_OBJ', 'END_MESSAGE_OBJ', 'POS_OBJ_AROUND', 'PCX_MESS_OBJ'])
     or (TextInArray(Segments[0], ['SET_DIR', 'SET_DIRMODE'])
         and ((Length(Segments) = 2) and (TextInArray(Segments[1], ['FOLLOW', 'DIRMODE9', 'DIRMODE10', 'DIRMODE11'])
                                          or (SameText(Segments[1], 'SAME_XZ') and (LbaMode <> 1)))))
     or (TextInArray(Segments[0], ['SET_DIR_OBJ', 'SET_DIRMODE_OBJ'])
         and (Length(Segments) = 3) and TextInArray(Segments[2], ['FOLLOW', 'DIRMODE9', 'DIRMODE10', 'DIRMODE11']))
     then begin
       ActorsList();
     end else begin
       if SameText(temp1, 'BODY')
       or (SameText(Segments[0], 'BODY_OBJ') and (ObjIndex > -1)) then begin
         if SameText(temp1, 'BODY') then ObjIndex:= Actor else CanExecute:= ObjIndex > -1;
         if (VScene.Actors[ObjIndex].StaticFlags and sfSprite) <> 0 then CanExecute:= False;
         if CanExecute then
           FillBodiesList(ObjIndex, scpLifeScript);
       end
       else if TextInArray(temp1, ['ANIM', 'ANIM_SET'])
       or (SameText(Segments[0], 'ANIM_OBJ') and (ObjIndex > -1)) then begin
         if not SameText(Segments[0], 'ANIM_OBJ') then ObjIndex:= Actor else CanExecute:= ObjIndex > -1;
         if (VScene.Actors[ObjIndex].StaticFlags and sfSprite) <> 0 then CanExecute:= False;
         if CanExecute then
           FillAnimsList(ObjIndex, scpLifeScript);
       end
       else if SameText(temp1, 'SET_TRACK')
       or (SameText(Segments[0], 'SET_TRACK_OBJ') and (ObjIndex > -1)) then begin
         scpLifeScript.InsertList.Add('-1');
         scpLifeScript.ItemList.Add('\style{+B}\color{clMaroon}-1\style{-B} \column{}\color{clGray}'
           + 'No Track (stop)');
         if SameText(temp1, 'SET_TRACK') then ObjIndex:= Actor else CanExecute:= ObjIndex > -1;
         if CanExecute then
           FillTracksList(ObjIndex, MaxLen, scpLifeScript);
       end
       else if TextInArray(temp1, ['MESSAGE', 'ADD_CHOICE', 'ASK_CHOICE',
                 'BIG_MESSAGE', 'SAY_MESSAGE', 'TEXT',
                 'MESSAGE_ZOE', 'ADD_MESSAGE'])
       or ((TextInArray(Segments[0], ['MESSAGE_OBJ', 'SAY_MESSAGE_OBJ',
              'ASK_CHOICE_OBJ', 'ADD_MESSAGE_OBJ']))
            and (ObjIndex > -1))
       then begin
         b:= VScene.TextBank + 3; //Number of text bank
         if b > High(DialogTexts) then CanExecute:= False;
         if CanExecute then begin
           for a:= 0 to High(DialogTexts[b]) do begin
             VIndex:= IntToStr(DialogTexts[b,a].Index);
             scpLifeScript.InsertList.Add(VIndex);
             scpLifeScript.ItemList.Add('\style{+B}\color{clMaroon}' + VIndex + '\style{-B} \column{}\color{clGray}'
               + DialogTexts[b,a].Text);
           end;
         end;
       end
       else if TextInArray(temp1, ['SET_COMPORTEMENT', 'SET_COMPORTMENT'])
       or (TextInArray(Segments[0], ['SET_COMPORTEMENT_OBJ', 'SET_COMPORTMENT_OBJ'])
           and (ObjIndex > -1))
       then begin
         if TextInArray(temp1, ['SET_COMPORTEMENT', 'SET_COMPORTMENT']) then
           ObjIndex:= Actor
         else
           CanExecute:= ObjIndex > -1;
         if CanExecute then begin
           ScriptLines:= TStringList.Create();
           ScriptLines.Text:= VScene.Actors[ObjIndex].LifeScriptTxt;
           for a:= 0 to ScriptLines.Count - 1 do begin
             VIndex:= Trim(ScriptLines[a]);
             if TextInArray(LeftStr(VIndex, 12), ['COMPORTEMENT', 'COMPORTMENT']) then begin
               Params:= ParseCSVLine(VIndex, ' ');
               if Length(Params) >= 2 then begin
                 VIndex:= Params[1];
                 scpLifeScript.InsertList.Add(VIndex);
                 column:= IfThen(Length(VIndex) > MaxLen, '  ', '\column{}');
                 scpLifeScript.ItemList.Add('\style{+B}\color{clMaroon}' + VIndex + '\style{-B} ' + column + '\color{clGray}'
                   + 'Comportment ' + VIndex);
               end;
             end;
           end;
           FreeAndNil(ScriptLines);
         end;
       end
       else if TextInArray(temp1, ['FOUND_OBJECT', 'SET_USED_INVENTORY', 'STATE_INVENTORY']) then begin
         InventoryList();
       end
       else if TextInArray(temp1, ['POS_POINT', 'IMPACT_POINT', 'FLOW_POINT']) then begin
         for a:= 0 to High(VScene.Points) do begin
           VIndex:= IntToStr(a);
           scpLifeScript.InsertList.Add(VIndex);
           scpLifeScript.ItemList.Add('\style{+B}\color{clMaroon}' + VIndex + '\style{-B} \column{}\color{clGray}'
             + 'Point ' + VIndex);
         end;
       end
       else if SameText(temp1, 'SET_MAGIC_LEVEL') then begin
         for a:= 0 to 4 do begin
           VIndex:= IntToStr(a);
           scpLifeScript.InsertList.Add(VIndex);
           scpLifeScript.ItemList.Add('\style{+B}\color{clMaroon}' + VIndex);
         end;
       end
       else if TextInArray(temp1, ['PLAY_FLA', 'PLAY_ACF', 'PLAY_SMK']) then begin
         for a:= 0 to High(MovieNames) do begin
           scpLifeScript.InsertList.Add(MovieNames[a]);
           scpLifeScript.ItemList.Add('\style{+B}\color{clMaroon}' + MovieNames[a]);
         end;
       end
       else if SameText(temp1, 'SET_GRM') then begin
         for a:= 1 to High(LdMaps) do begin
           scpLifeScript.InsertList.Add(LdMaps[a].Name);
           scpLifeScript.ItemList.Add('\style{+B}\color{clMaroon}' + LdMaps[a].Name);
         end;
       end else
         CanExecute:= False;
     end;
   end;
 end;
end;

procedure TfmScriptEd.btCompileAcClick(Sender: TObject);
var pt: TPoint;
begin
  pt:= btCompile.ClientToScreen(Point(0, btCompileAc.Height));
  abCompileAc.Popup(pt.X, pt.Y);
  btCompile.SetFocus();
end;

procedure TfmScriptEd.btCompileClick(Sender: TObject);
var a: Integer;
    LH: array of TLbHashTable;
    CL: array of TCompList;
    LT: array of TTransTable;
    OK: Boolean;
begin
 pcBottom.ActivePage:= tsMessages;
 ClearMessages();
 WriteActorScripts();
 StoreActorUndoRedo();
 SetLength(LH, Length(VScene.Actors));
 SetLength(CL, Length(VScene.Actors));
 SetLength(LT, Length(VScene.Actors));

 //Current Actor has a prority, so compile its Scripts first, then the rest
 //  (because we need all the scripts to pass through one stage to
 //  be able to perform next stage on anything (except for stage 4, which
 //  can be performed without all the scripts passed stage 3)).
 //  Stages are:
 //    1. Track Scripts compilation
 //    2. Life Scritps conversion to Trans Table
 //    3. Life Scripts offsets resolving
 //    4. Life Scripts translating to binary form

 SetupCompiler(LbaMode);

 //Compilig Track
 //NumberizeLabels(VScene.Actors[Actor].TrackScriptTxt,VScene.Actors[Actor].LifeScriptTxt);

 OK:= TrackCompile(VScene.Actors[Actor].TrackScriptTxt, Actor,
        VScene.Actors[Actor].TrackScriptBin, LH[Actor], OnCompMessage,
        ActorEntities, VScene);

 If OK then
   for a:= 0 to High(VScene.Actors) do
     If a <> Actor then //Skip the Actor that has been processed already
       If not TrackCompile(VScene.Actors[a].TrackScriptTxt, a,
         VScene.Actors[a].TrackScriptBin, LH[a], OnCompMessage, ActorEntities,
         VScene) then begin
         OK:= False;
         Break;
       end;

 If OK then begin
   AddMessage(OnCompMessage, True, ciTrackCompiled, -1, 0, 0, 0);

   //Parsing Life
   OK:= LifeCompToTransTable(VScene.Actors[Actor].LifeScriptTxt, Actor,
          LH, CL[Actor], LT[Actor], OnCompMessage, ActorEntities, VScene);
 end;

 If OK then
   for a:= 0 to High(VScene.Actors) do
     If a <> Actor then
       If not LifeCompToTransTable(VScene.Actors[a].LifeScriptTxt, a,
         LH, CL[a], LT[a], OnCompMessage, ActorEntities, VScene) then begin
         OK:= False;
         Break;
       end;

 If OK then begin
   AddMessage(OnCompMessage, False, ciLifeParsed, -1, 0, 0, 0);

   //Resolving Life
   OK:= LifeCompResolveOffsets(LT, Actor, LH, CL, OnCompMessage);
 end;

 If OK then
   for a:= 0 to High(VScene.Actors) do
     If a <> Actor then
       If not LifeCompResolveOffsets(LT, a, LH, CL, OnCompMessage) then begin
         OK:= False;
         Break;
       end;

 If OK then begin
   AddMessage(OnCompMessage, False, ciLifeResolved, -1, 0, 0, 0);

   //Checking Usage
   LifeCompCheckUsage(LH, CL, OnCompMessage);

   //Converting to binary form
   OK:= LifeCompTransToBin(LT[Actor], VScene.Actors[Actor].LifeScriptBin,
          VScene.Actors[Actor].FragmentInfo, Actor, OnCompMessage);
 end;

 ReleaseCompiler();

 If OK then begin
   SceneCheckConsistency(VScene, OnCompMessage);
   AddMessage(OnCompMessage, False, ciLifeCompSing, -1, 0, 0, 0);
 end
 else if ScrSet.Comp.AutoHLError
 and (Length(CompMsgs) > 0) and (CompMsgs[High(CompMsgs)].mType = mtError)
 and (ScrSet.Comp.AutoHLAlways or (Actor = CompMsgs[High(CompMsgs)].ObjId))
 then
   lbMessagesDblClick(lbMessages);
end;

//In case of more than one editor window this will have to be changed to a
//  procedure of object, and probably compilation routines will have to be
//  updated also.
procedure OnCompMessage(Msg: TCompMessage);
begin
  SetLength(fmScriptEd.CompMsgs, Length(fmScriptEd.CompMsgs) + 1);
  fmScriptEd.CompMsgs[High(fmScriptEd.CompMsgs)]:= Msg;
  fmScriptEd.lbMessages.Count:= fmScriptEd.lbMessages.Count + 1;
  fmScriptEd.lbMessages.ItemIndex:= fmScriptEd.lbMessages.Items.Count - 1;
end;

procedure TfmScriptEd.lbMessagesData(Control: TWinControl;
  Index: Integer; var Data: String);
begin
  Data:= CompMsgs[Index].Text;
end;

function TfmScriptEd.lbMessagesDataFind(Control: TWinControl;
  FindString: String): Integer;
begin
  Result:= -1; //This is not working (because it's not necessary)
end;

procedure TfmScriptEd.lbMessagesDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  If odSelected in State then
    (Control as TListBox).Canvas.Brush.Color:= $FFE0E0 //$80FFFF
  else
    (Control as TListBox).Canvas.Brush.Color:= (Control as TListBox).Color;
  (Control as TListBox).Canvas.FillRect(Rect);
  case CompMsgs[Index].mType of
    mtError: (Control as TListBox).Canvas.Font.Color:= clRed;
    mtWarning: (Control as TListBox).Canvas.Font.Color:= $0070E0; //orange
    mtInfo: (Control as TListBox).Canvas.Font.Color:= clGreen;
  end;

  (Control as TListBox).Canvas.TextOut(Rect.Left + 1, Rect.Top + 1,CompMsgs[Index].Text);
end;

procedure TfmScriptEd.mCompileAllClick(Sender: TObject);
begin
  CompileAllScripts(LbaMode, VScene);
end;

procedure TfmScriptEd.lbMessagesDblClick(Sender: TObject);
var a: Integer;
    bb: TBufferCoord;
    sm: TSynEdit;
begin
  a:= lbMessages.ItemIndex;
  If (a >= 0) and (a <= High(CompMsgs)) then begin
    case CompMsgs[a].oType of
      moActorLife, moActorTrack: begin
        if CompMsgs[a].ObjId > -1 then begin
          if CompMsgs[a].oType = moActorLife then sm:= seLifeScript
                                             else sm:= seTrackScript;
          OpenScripts(CompMsgs[a].ObjId);
          if (CompMsgs[a].mType <> mtInfo) and (CompMsgs[a].Line > 0) then begin
            bb.Line:= CompMsgs[a].Line;  //for some reason BlockBegin members cannot be assigned directly
            bb.Char:= CompMsgs[a].PosEnd + 1;
            sm.CaretXY:= bb;
            bb.Char:= CompMsgs[a].PosStart + 1;
            sm.BlockBegin:= bb;
            bb.Char:= CompMsgs[a].PosEnd + 1;
            sm.BlockEnd:= bb;
            //sm.CaretXY:= bb;
            sm.SetFocus();
          end;
        end;
      end;
      moActorProp: begin
        SelectObject(otActor, CompMsgs[a].ObjId);
        //if CompMsgs[a].Line > -1 then
        //  fmMain.frSceneObj.pcAProps.TabIndex:= CompMsgs[a].Line;
        fmMain.BringToFront();  
      end;
      moPoint: begin
        SelectObject(otPoint, CompMsgs[a].ObjId);
        fmMain.BringToFront();
      end;
      moZone: begin
        SelectObject(otZone, CompMsgs[a].ObjId);
        fmMain.BringToFront();
      end;
    end;
  end;
end;

procedure TfmScriptEd.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Actor > -1 then begin
    WriteActorScripts();
    StoreActorUndoRedo();
  end;
  Actor:= -1;
  fmSearchScript.Close();
end;

procedure TfmScriptEd.btSearchClick(Sender: TObject);
begin
  fmSearchScript.OpenSearchDialog(Self);
end;

procedure TfmScriptEd.btSettingsClick(Sender: TObject);
begin
 fmSettings.ShowSettings(fmSettings.tsScriptsGen);
end;

procedure TfmScriptEd.FormResize(Sender: TObject);
begin
 If (seTrackScript.Width < 187) or (seLifeScript.Width > paEditors.Width - 100) then
   seLifeScript.Width:= paEditors.Width - 194;
 If (seLifeScript.Height < 6) or (pcBottom.Height > paEditors.Height - 5) then
   pcBottom.Height:= paEditors.Height - 13;
 paUndoRedo.Left:= seLifeScript.Width - 57;  
end;

procedure TfmScriptEd.seLifeScriptChange(Sender: TObject);
begin
 VScene.Actors[Actor].LifeScriptTxt:= seLifeScript.Text;
 SetSceneModified();
 ActivateUndoRedoButtons();
end;

procedure TfmScriptEd.seTrackScriptChange(Sender: TObject);
begin
 VScene.Actors[Actor].TrackScriptTxt:= seTrackScript.Text;
 SetSceneModified();
 ActivateUndoRedoButtons();
end;

function TfmScriptEd.CompileAllScripts(Lba: Byte; var Scene: TScene): Boolean;
var a: Integer;
    LH: array of TLbHashTable;
    CL: array of TCompList;
    LT: array of TTransTable;
begin
 pcBottom.ActivePage:= tsMessages;
 ClearMessages();
 WriteActorScripts();
 if Actor >= 0 then StoreActorUndoRedo();
 SetLength(LH, Length(Scene.Actors));
 SetLength(CL, Length(Scene.Actors));
 SetLength(LT, Length(Scene.Actors));
 Result:= True;

 SetupCompiler(Lba);

 //Compilig Track Scripts
 for a:= 0 to High(Scene.Actors) do
   if not TrackCompile(Scene.Actors[a].TrackScriptTxt, a,
     Scene.Actors[a].TrackScriptBin, LH[a], OnCompMessage, ActorEntities, Scene)
   then begin
     Result:= False;
     Break;
   end;

 if Result then begin
   AddMessage(OnCompMessage, True, ciTrackCompiled, -1, 0, 0, 0);

   for a:= 0 to High(Scene.Actors) do
     if not LifeCompToTransTable(Scene.Actors[a].LifeScriptTxt, a,
       LH, CL[a], LT[a], OnCompMessage, ActorEntities, Scene)
     then begin
       Result:= False;
       Break;
     end;
 end;

 if Result then begin
   AddMessage(OnCompMessage, False, ciLifeParsed, -1, 0, 0, 0);

   //Resolving Life Scripts
   for a:= 0 to High(Scene.Actors) do
     if not LifeCompResolveOffsets(LT, a, LH, CL, OnCompMessage) then begin
       Result:= False;
       Break;
     end;
 end;

 if Result then begin
   AddMessage(OnCompMessage, False, ciLifeResolved, -1, 0, 0, 0);

   //Checking Usage
   LifeCompCheckUsage(LH, CL, OnCompMessage);

   //Converting to binary form
   for a:= 0 to High(Scene.Actors) do
     if not LifeCompTransToBin(LT[a], Scene.Actors[a].LifeScriptBin,
       Scene.Actors[a].FragmentInfo, a, OnCompMessage)
     then begin
       Result:= False;
       Break;
     end;  
 end;

 ReleaseCompiler();

 if Result then begin
   SceneCheckConsistency(Scene, OnCompMessage);
   AddMessage(OnCompMessage, False, ciLifeCompSing, -1, 0, 0, 0);
 end;
end;

procedure TfmScriptEd.ClearMessages();
begin
 SetLength(CompMsgs, 0);
 lbMessages.Count:= 0;
 lbMessages.Repaint();
end;

procedure TfmScriptEd.ActorBtnEnable();
begin
 btPrevActor.Enabled:= Actor > 0;
 btNextActor.Enabled:= Actor < High(VScene.Actors);
end;

procedure TfmScriptEd.btPrevActorClick(Sender: TObject);
begin
 if Sender = btPrevActor then begin
   if Actor > 0 then OpenScripts(Actor - 1);
 end
 else if Sender = btNextActor then begin
   if Actor < High(VScene.Actors) then OpenScripts(Actor + 1);
 end;
end;

procedure TfmScriptEd.eActorChange(Sender: TObject);
var a: Integer;
begin
 If TryStrToInt(eActor.Text, a)
 and (a >= 0) and (a <= High(VScene.Actors)) then begin
   eActor.Color:= clWindow;
   if a = Actor then Exit; //Don't do anything if the selected Actor is already opened
   eActor.OnChange:= nil; //disable the event to avoid double update
   if Sett.Scripts.ScriptToActor then
     SelectObject(otActor, a)
   else
     OpenScripts(a);
   eActor.OnChange:= eActorChange;
   ActorBtnEnable();
 end
 else
   eActor.Color:= $8080FF;
end;

procedure TfmScriptEd.btUndoRedoClick(Sender: TObject);
begin
      if Sender = btLifeUndo  then seLifeScript.Undo()
 else if Sender = btLifeRedo  then seLifeScript.Redo()
 else if Sender = btTrackUndo then seTrackScript.Undo()
 else if Sender = btTrackRedo then seTrackScript.Redo();
 ActivateUndoRedoButtons();
end;

procedure TfmScriptEd.spHorizMoved(Sender: TObject);
begin
 paUndoRedo.Left:= seLifeScript.Width - 57;
end;

procedure TfmScriptEd.ActivateUndoRedoButtons();
begin
 btLifeUndo.Enabled:= seLifeScript.UndoList.CanUndo;
 btLifeRedo.Enabled:= seLifeScript.RedoList.CanUndo;
 btTrackUndo.Enabled:= seTrackScript.UndoList.CanUndo;
 btTrackRedo.Enabled:= seTrackScript.RedoList.CanUndo;
end;

procedure TfmScriptEd.FreeActorUndoRedo(var AUR: TScrUndoRedoList);
begin
 AUR.TrackUndo.Free();
 AUR.TrackRedo.Free();
 AUR.LifeUndo.Free();
 AUR.LifeRedo.Free();
end;

procedure TfmScriptEd.DeleteAllActorUndoRedo();
var a: Integer;
begin
 for a:= 0 to High(ScrUndoRedo) do
   FreeActorUndoRedo(ScrUndoRedo[a]);
 SetLength(ScrUndoRedo, 0);
end;

procedure TfmScriptEd.DeleteUnusedActorUndoRedo();
var a, b: Integer;
    Used: Boolean;
begin
 for a:= High(ScrUndoRedo) downto 0 do begin
   Used:= False;
   for b:= 0 to High(VScene.Actors) do
     if ScrUndoRedo[a].Index = VScene.Actors[b].UndoRedoIndex then begin
       Used:= True;
       Break;
     end;
   if not Used then begin
     FreeActorUndoRedo(ScrUndoRedo[a]);
     for b:= a + 1 to High(ScrUndoRedo) do
       ScrUndoRedo[b - 1]:= ScrUndoRedo[b];
     SetLength(ScrUndoRedo, Length(ScrUndoRedo) - 1);
   end;
 end;
end;

function TfmScriptEd.FindActorUndoRedo(): Integer;
var a, index: Integer;
begin
 Assert((Actor >= 0) and (Actor <= High(VScene.Actors)), 'TfmScSriptEd.FindActorUndoRedo: Wrong Actor Id. Please contact Zink.');
 index:= VScene.Actors[Actor].UndoRedoIndex;
 if index > 0 then begin
   for a:= 0 to High(ScrUndoRedo) do
     if ScrUndoRedo[a].Index = index then begin
       Result:= a;
       Exit;
     end;
 end;
 Result:= -1;
end;

procedure TfmScriptEd.StoreActorUndoRedo();
var a, id, firstfree: Integer;
    found: Boolean;
begin
 id:= FindActorUndoRedo();

 if id < 0 then begin //need to create new lists
   firstfree:= NextUndoIndex; //First free index
   repeat
     found:= True;
     for a:= 0 to High(ScrUndoRedo) do
       if ScrUndoRedo[a].Index = firstfree then begin
         found:= False;
         Inc(firstfree);
         Break;
       end;
   until found;
   NextUndoIndex:= Cardinal(firstfree + 1);
   if NextUndoIndex = 0 then NextUndoIndex:= 1;

   id:= Length(ScrUndoRedo);
   SetLength(ScrUndoRedo, id + 1);
   ScrUndoRedo[id].Index:= firstfree;
   ScrUndoRedo[id].TrackUndo:= TSynEditUndoList.Create();
   ScrUndoRedo[id].TrackRedo:= TSynEditUndoList.Create();
   ScrUndoRedo[id].LifeUndo:= TSynEditUndoList.Create();
   ScrUndoRedo[id].LifeRedo:= TSynEditUndoList.Create();
   VScene.Actors[Actor].UndoRedoIndex:= firstfree;
 end;

 //Here we have the right index for sure
 ScrUndoRedo[id].TrackUndo.Assign(seTrackScript.UndoList);
 ScrUndoRedo[id].TrackRedo.Assign(seTrackScript.RedoList);
 ScrUndoRedo[id].LifeUndo.Assign(seLifeScript.UndoList);
 ScrUndoRedo[id].LifeRedo.Assign(seLifeScript.RedoList);
end;

procedure TfmScriptEd.RestoreActorUndoRedo();
var id: Integer;
begin
 id:= FindActorUndoRedo();
 if id >= 0 then begin
   seTrackScript.UndoList.Assign(ScrUndoRedo[id].TrackUndo);
   seTrackScript.RedoList.Assign(ScrUndoRedo[id].TrackRedo);
   seLifeScript.UndoList.Assign(ScrUndoRedo[id].LifeUndo);
   seLifeScript.RedoList.Assign(ScrUndoRedo[id].LifeRedo);
 end;
end;

{$I AutoComplete1.inc}
{$I AutoComplete2.inc}

initialization
  TrackScriptACIt:= TStringList.Create();
  TrackScriptACIn:= TStringList.Create();
  LifeScriptACCmdIt:= TStringList.Create();
  LifeScriptACCmdIn:= TStringList.Create();
  LifeScriptACVarIt:= TStringList.Create();
  LifeScriptACVarIn:= TStringList.Create();
  LifeScriptACBehIt:= TStringList.Create();
  LifeScriptACBehIn:= TStringList.Create();
  LifeScriptACDirIt:= TStringList.Create();
  LifeScriptACDirIn:= TStringList.Create();

finalization
  FreeAndNil(TrackScriptACIt);
  FreeAndNil(TrackScriptACIn);
  FreeAndNil(LifeScriptACCmdIt);
  FreeAndNil(LifeScriptACCmdIn);
  FreeAndNil(LifeScriptACVarIt);
  FreeAndNil(LifeScriptACVarIn);
  FreeAndNil(LifeScriptACBehIt);
  FreeAndNil(LifeScriptACBehIn);
  FreeAndNil(LifeScriptACDirIt);
  FreeAndNil(LifeScriptACDirIn);

end.
