//******************************************************************************
// Little Big Architect: Builder - editing grid files containing rooms in
//                                 Little Big Adventure 1 & 2
//
// OpenSim unit.
// Contains room opening dialog (simple) routines.
//
// Copyright Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit OpenSim;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils, ExtCtrls, DePack, ListForm, HQDesc, Buttons,
  Maps, Math, Utils, SmartCombo;

type
  TfmOpenSim = class(TForm)
    lbCaption: TLabel;
    rbLba1: TRadioButton;
    rbLba2: TRadioButton;
    lbInfo: TLabel;
    btOpen: TBitBtn;
    btCancel: TBitBtn;
    paMode: TPanel;
    rbGridMode: TRadioButton;
    rbSceneMode: TRadioButton;
    rbLbaCustom: TRadioButton;
    btSimGrid: TButton;
    stSimGrid: TStaticText;
    DlgOpen: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure rbLba1Click(Sender: TObject);
    procedure btSimGridClick(Sender: TObject);
  private
    FFragmentMode: Boolean;
    FFileName: String;
    FFileIndex: Integer;
    procedure EnableBtOpen(Sender: TObject);
  public
    cbSimGrid: TSmartComboBox;
    //For Main Map opening
    function ShowDialogMain(): Boolean;
    //For addditional Fragment opening
    function ShowDialogFrag(): Boolean;
    procedure OpenSimpleFiles(var Map: TComplexMap);
  end;

var
  fmOpenSim: TfmOpenSim;

  {GridIndexList, LibIndexList,} SceneIndexList: TIndexList;
  DummyIndexList: TIndexList;
  GriToBll1, BllList1, GridList1: TIndexList;
  GriToBll2, GriToScene2: TIndexList;

procedure CloseEverything();
Procedure EnableControls(Enable: Boolean = True);
Procedure ResetControls(Full: Boolean = True);
procedure OpenFinalize(SetScenarioMod: Boolean = False);
procedure LoadTexts(Combo: TComboBox; Name: String);
Procedure LoadCombo(Dest: TComboBox; Tag: Integer; What: TEntriesType);
procedure LoadComboSimple(Dest: TComboBox; Lba: Integer; What: TEntriesType;
  Index, MinEntries: Integer);
procedure LoadGriToBllTables();

implementation

uses Main, Open, Hints, Rendering, Settings, Engine, ProgBar, Scene, Scenario,
     ScriptEd, Globals;

{$R *.dfm}

procedure CloseEverything();
begin
  if Assigned(fmScriptEd) then begin
    fmScriptEd.Close();
    fmScriptEd.ClearMessages();
  end;  
  UnloadSceneFiles();
  SetLength(PkBricks, 0);
  SetLength(LdLibrary, 0);
  //CurrentGridFile:= '';
  //CurrentSceneFile:= '';
  //SetLength(VScene, 0);
  CMap:= nil;
  SetLength(LdMaps, 0);
  LBAMode:= 0;
  fmMain.pcControls.ActivePage:= fmMain.tsGrid;
  fmMain.mDeleteLayer.Enabled:= False;
  GridOpened:= False;
  SceneModified:= False;
  ScenarioModified:= False;
  MapCounter:= 0;
  fmMain.UpdateProgramName();
  //TODO: find other arrays that need to be freed
end;


Procedure EnableControls(Enable: Boolean = True);
begin
 if Assigned(ProgBarForm) then ProgBarForm.CloseSpecial();
 If not Enable then begin
   CloseScenario();
   GoGridMode();
   CloseEverything();
   BadBrickMessage:= False;
   BadActorMessage:= False;
 end;
 fmMain.paSplash.Visible:= not Enable;
 fmMain.paTools.Visible:= Enable;
 fmMain.paLeftSide.Visible:= Enable;
 fmMain.Splitter1.Visible:= Enable;
 If Enable then fmMain.paLeftSide.Left:= 0;
 fmMain.pbGrid.Visible:= Enable;
 fmMain.pbThumb.Visible:= Enable;
 fmMain.pbLts.Visible:= Enable;
 fmMain.aExportBMP.Enabled:= Enable;
 fmMain.HScr.Enabled:= Enable;
 fmMain.VScr.Enabled:= Enable;
 fmMain.LScr.Enabled:= Enable;
 fmMain.aSaveGrid.Enabled:= {not New and} Enable;
 fmMain.aSaveGridAs.Enabled:= Enable;
 fmMain.aSaveScenario.Enabled:= Enable;
 fmMain.aSaveScenarioAs.Enabled:= Enable;
 fmMain.aSceneMode.Enabled:= Enable;
 fmMain.aSaveScene.Enabled:= {not New and} Enable;
  //TODO: Prevent SceneMode if LBA 2 Fragment is opened
 fmMain.aSaveSceneAs.Enabled:= Enable;
 fmMain.aSceneProp.Enabled:= Enable;
 fmMain.aScenarioProp.Enabled:= Enable;
 fmMain.aCreateFrag.Enabled:= Enable;
 fmMain.aOpenFrag.Enabled:= Enable;
 fmMain.aCloseFrag.Enabled:= Enable and (fmMain.cbFragment.ItemIndex > 0);
 fmMain.aCloseAll.Enabled:= Enable;
 HintsOn:= Enable;
 fmMain.FormResize(fmMain);
end;

Procedure ResetControls(Full: Boolean = True);
begin
 If Full then begin
   LtSel:= 1;
   fmMain.pbLtsMouseDown(fmMain, mbLeft, [], 0, 0);
   If fmMain.LScr.Enabled then fmMain.LScr.Position:= 0;
   If fmMain.HScr.Enabled then
     fmMain.HScr.Position:= (fmMain.HScr.Max-fmMain.HScr.PageSize) div 2;
   If fmMain.VScr.Enabled then
     fmMain.VScr.Position:= (fmMain.VScr.Max-fmMain.VScr.PageSize) div 5;
   Sett.Controls.MaxLayerEna:= False;
   fmMain.UpdateButtons();
   fmMain.btMaxLayer_Click(nil);
 end;
 GCursor:= BoxPoint(-1, -1, -1);
 GLastCursor:= GCursor;
 GHasSelection:= False;
 GSelStart:= GCursor;
 GPlacePos:= Point3d(-1000, -1000, -1000);
 GLastPlacePos:= GPlacePos;
 GPlacing:= False;
 GVMoving:= False;
 GSelecting:= False;
 GMoveAllowed:= False;
 GFHMoving:= False;
 GFVMoving:= False;
 GInvPlacing:= False;
 GObjCopied:= False;

 SMvType:= otNone;
 SVertMoving:= False;
 SPrevBtn:= fmMain.btScHand;

 KeyHandled:= False;
 SZoneSelecting:= False;
end;

//TODO: Check if an LBA 2 Fragment is opened and disable Scene Mode in such case
procedure OpenFinalize(SetScenarioMod: Boolean = False);
begin
 fmMain.pcControls.ActivePage:= fmMain.tsGrid;
 BufferBricks(LdLibrary, PkBricks);
 CreateThumbnail(False);
 MakeLayoutMap();
 PaintLayouts();
 EnableControls(True);
 ResetControls();
 CMap^.Modified:= False; //This should have been already set by InitMap()
 SceneModified:= False;
 ScenarioModified:= SetScenarioMod;
 DrawMapA();
 ProgBarForm.CloseSpecial();
 PutMessage('Files successfully loaded'); //30
 GridOpened:= True;
 fmMain.RefreshMapList();
 fmMain.UpdateProgramName();
 fmScriptEd.SetupAutoCompLists();
end;

{procedure LoadTexts(Combo: TComboBox; Tag: Integer; What: String);
var f: TextFile;
    temp, ext, desc: String;
begin
 If (Tag=2) then desc:='all' else desc:=What;
 temp:=ExtractFilePath(Application.ExeName)+Format('Lba%d%s.hqd',[Tag,desc]);
 If FileExists(temp) then begin
  Combo.Items.Clear;
  AssignFile(f,temp);
  Reset(f);
  ReadLn(f,temp); //file description
  ReadLn(f,temp); //first entry
  repeat
   ReadLn(f,temp);
   ext:=Copy(temp,1,3);
   desc:=Copy(temp,5,Length(temp)-4);
   If Trim(desc)='' then desc:='unknown';
   If (Tag=2) then begin
    If (What='grids') then begin
     If ext='gr2' then Combo.Items.Add('[grid] '+desc)
     else if ext='grf' then Combo.Items.Add('[fragment] '+desc);
    end
    else if ext='bl2' then Combo.Items.Add(desc);
   end
   else Combo.Items.Add(desc);
  until Eof(f) or ((Tag=2) and ((ext<>'gr2') or (ext<>'grf')));
  CloseFile(f);
 end;
end;}

procedure LoadTexts(Combo: TComboBox; Name: String);
var FRes: TResourceStream;
begin
 FRes:= TResourceStream.Create(0,Name,'TEXT');
 Combo.Items.LoadFromStream(FRes);
 FRes.Free;
end;

{Procedure LoadCombo(Dest: TComboBox; Tag: Integer; What: String);
begin
 If Dest.Tag <> Tag then begin
  LoadTexts(Dest,Format('LBA_%d_%s',[Abs(Tag),What]));
  Dest.Tag:= Tag;
  If Dest.Name= 'grCombo' then
   OpenForm.laCombo.ItemIndex:= -1;
 end;
end;}

Procedure LoadCombo(Dest: TComboBox; Tag: Integer; What: TEntriesType);
var a: Integer;
    Names: TStrArray;
    path: String;
begin
 If Dest.Tag <> Tag then begin

   If Tag = 1 then begin
     Case What of
       etGridFrag: path:= GetFilePath(Lba1_GRI, 1);
       etLibs:     path:= GetFilePath(Lba1_BLL, 1);
       etScenes:   path:= GetFilePath(Lba_SCENE, 1);
     end;
   end
   else begin
     If What = etScenes then path:= GetFilePath(Lba_SCENE, 2)
     else path:= GetFilePath(Lba2_BKG, 2);
   end;

   case What of
     etGridFrag: Names:= MakeDescriptionList(path, What, Tag = 1,
                           Sett.General.FirstIndex1, Sett.General.ShowIndexes, DummyIndexList);
     etLibs: Names:= MakeDescriptionList(path, etLibs, Tag = 1,
                           Sett.General.FirstIndex1, Sett.General.ShowIndexes, DummyIndexList);
     etScenes: Names:= MakeDescriptionList(path, etScenes, Tag = 1,
                           Sett.General.FirstIndex1, Sett.General.ShowIndexes, SceneIndexList);
   end;
   
   Dest.Clear();
   for a:= 0 to High(Names) do
     Dest.Items.Add(Names[a]);

   //LoadTexts(Dest,Format('LBA_%d_%s',[Abs(Tag),What]));
   Dest.Tag:= Tag;
   If Dest.Name = 'grCombo' then
     fmOpen.cbLibIndex.ItemIndex:= -1;

   if Dest is TSmartComboBox then
     (Dest as TSmartComboBox).InitSmartCombo();
 end;
end;

procedure LoadComboSimple(Dest: TComboBox; Lba: Integer; What: TEntriesType;
  Index, MinEntries: Integer);
var a: Integer;
    Names: TStrArray;
    path: String;
begin
 Case What of
   etScenes:  path:= GetFilePath(Lba_SCENE, Lba);
   etFile3d:  if Lba = 1 then
                path:= GetFilePath(Lba_FILE3D, 1)
              else
                path:= GetFilePath(Lba_RESS, 2);
   etBodies:  path:= GetFilePath(Lba_BODY, Lba);
   etAnims:   path:= GetFilePath(Lba_ANIM, Lba);
   etSprites: path:= GetFilePath(Lba_SPRITES, Lba);
   else begin
     if Lba = 1 then begin
       if What = etGridFrag then path:= GetFilePath(Lba1_GRI, 1)
       else if What = etLibs then path:= GetFilePath(Lba1_BLL, 1);
     end else
       path:= GetFilePath(Lba2_BKG, 2);
   end;
 end;

 Names:= MakeDescriptionList(path, What, Lba = 1, Sett.General.FirstIndex1, True, DummyIndexList);

 Dest.Clear();
 for a:= 0 to High(Names) do
   Dest.Items.Add(Names[a]);

 if Length(Names) < MinEntries then
   for a:= Length(Names) to MinEntries - 1 do
     Dest.Items.Add(IntToStr(a) + ': (unknown)');  

 //LoadTexts(Dest,Format('LBA_%d_%s',[Abs(Tag),What]));
 Dest.ItemIndex:= Index;
end;

procedure TfmOpenSim.FormCreate(Sender: TObject);
begin
 //rb21Click(Self);
 cbSimGrid:= TSmartComboBox.Create(Self);
 cbSimGrid.Name:= 'cbSimGrid';
 cbSimGrid.Parent:= Self;
 cbSimGrid.DropDownCount:= 20;
 cbSimGrid.Height:= 21;
 cbSimGrid.ItemHeight:= 13;
 cbSimGrid.Left:= 16;
 cbSimGrid.TabOrder:= 0;
 cbSimGrid.Top:= 60;
 cbSimGrid.Width:= 409;
 cbSimGrid.AutoDropDown:= True;
 cbSimGrid.OnChange:= EnableBtOpen;
end;

procedure TfmOpenSim.EnableBtOpen(Sender: TObject);
begin
  if FFragmentMode then
   btOpen.Enabled:= ((rbLba1.Checked or rbLba2.Checked) and (cbSimGrid.ItemIndex > -1))
                  or (rbLbaCustom.Checked and (FFileName <> ''))
 else
   btOpen.Enabled:= cbSimGrid.ItemIndex > -1;
end;

procedure TfmOpenSim.rbLba1Click(Sender: TObject);
begin
 if rbLba1.Checked then LoadCombo(cbSimGrid, 1, etGridFrag)
 else if rbLba2.Checked then LoadCombo(cbSimGrid, 2, etGridFrag);
 //cbSimGrid.InitSmartCombo();
 cbSimGrid.Visible:= rbLba1.Checked or rbLba2.Checked;
 stSimGrid.Visible:= not cbSimGrid.Visible;
 btSimGrid.Visible:= stSimGrid.Visible;
 EnableBtOpen(nil);
end;

function TfmOpenSim.ShowDialogMain(): Boolean;
begin
 lbCaption.Caption:= 'Select map for Main Grid:';
 FFragmentMode:= False;
 rbLba1.Enabled:= BrkEx and BllEx and GriEx;
 rbLba2.Enabled:= BkgEx;
 rbLbaCustom.Visible:= False;
 if rbLbaCustom.Checked then rbLba1.Checked:= True;
 if rbLba1.Checked and not rbLba1.Enabled then rbLba2.Checked:= True;
 if rbLba2.Checked and not rbLba2.Enabled then rbLba1.Checked:= True;
 cbSimGrid.Enabled:= rbLba1.Enabled or rbLba2.Enabled;
 if not cbSimGrid.Enabled then begin
   lbInfo.Caption:= 'No LBA 1 or 2 files specified. If you want to open a map from a single file or in different environment, choose File->Open or create new (advanced).';
   cbSimGrid.ItemIndex:= -1;
 end else begin
   lbInfo.Caption:= 'This way you can open only standard LBA maps. If you want to open maps from single files or in different environment, please choose File->Open or create new (advanced).';
   cbSimGrid.ItemIndex:= Sett.OpenDlg.GrSimGCIndex;
 end;
 stSimGrid.Visible:= False;
 btSimGrid.Visible:= False;
 paMode.Visible:= True;
 ClientHeight:= 160;
 rbLba1Click(Self);

 Result:= ShowModal() = mrOK;

 if Result then
   Sett.OpenDlg.GrSimGCIndex:= cbSimGrid.ItemIndex;
end;

function TfmOpenSim.ShowDialogFrag(): Boolean;
begin
 lbCaption.Caption:= 'Select map for the additional Fragment:';
 FFragmentMode:= True;
 rbLba1.Enabled:= (LBAMode = 1) and BrkEx and BllEx and GriEx;
 rbLba2.Enabled:= False; //(LBAMode = 2) and BkgEx;  TODO !!!
 rbLbaCustom.Visible:= True;
 if rbLba1.Checked and not rbLba1.Enabled then rbLba2.Checked:= True;
 if rbLba2.Checked and not rbLba2.Enabled then rbLba1.Checked:= True;
 if not (rbLba1.Enabled or rbLba2.Enabled) then rbLbaCustom.Checked:= True;
 cbSimGrid.Enabled:= rbLba1.Enabled or rbLba2.Enabled;
 cbSimGrid.Visible:= rbLba1.Checked or rbLba2.Checked;
 stSimGrid.Visible:= not cbSimGrid.Visible;
 btSimGrid.Visible:= stSimGrid.Visible;
 cbSimGrid.ItemIndex:= Sett.OpenDlg.GrSimFCIndex;
 FFileName:= Sett.OpenDlg.GrSimGrPath;
 FFileIndex:= Sett.OpenDlg.GrSimGrIndex;
 if FFileIndex > -1 then
   stSimGrid.Caption:= Format('%s, entry %d',
     [FFileName, FFileIndex + IfThen(Sett.General.FirstIndex1,1)])
 else
   stSimGrid.Caption:= FFileName;
 lbInfo.Caption:= '';
 paMode.Visible:= False;
 ClientHeight:= 125;
 rbLba1Click(Self);

 Result:= ShowModal() = mrOK;

 if Result then begin
   Sett.OpenDlg.GrSimFCIndex:= cbSimGrid.ItemIndex;
   Sett.OpenDlg.GrSimGrPath:= FFileName;
   Sett.OpenDlg.GrSimGrIndex:= FFileIndex;
 end;
end;

procedure TfmOpenSim.OpenSimpleFiles(var Map: TComplexMap);
var p: TSmallPoint;
    Lba1: Boolean;
begin
 TransparentBrick:= 0;
 SetLength(PkScenario, 0);
 Lba1:= rbLba1.Checked;
 fmMain.SetLbaMode(IfThen(Lba1, 1, 2));

 If Lba1 then Palette:= LoadPaletteFromResource(1)
 else Palette:= LoadPaletteFromResource(2);
 InvertPal:= InvertPalette(Palette);

 if Lba1 then
   OpenLibrary(GetFilePath(Lba1_BLL,1), GridList1[cbSimGrid.ItemIndex])
 else begin
   //p:= BkgEntriesCount(SetForm.peBkg.Path,weLibs);
   //If GridNow then OpenLibrary(SetForm.peBkg.Path,Grid.LibIndex+p.x-1)
   //else OpenLibrary(SetForm.peBkg.Path,GriToBll2[cbSimGrid.ItemIndex]+p.x-1);
   OpenLibrary(GetFilePath(Lba2_BKG,2), GriToBll2[cbSimGrid.ItemIndex]);
 end;

 if Lba1 then
   OpenGrid(GetFilePath(Lba1_GRI,1), GridList1[cbSimGrid.ItemIndex], LdLibrary, Map)
 else begin
   p:= BkgEntriesCount(GetFilePath(Lba2_BKG,2), itGrids);
   OpenGrid(GetFilePath(Lba2_BKG, 2), cbSimGrid.ItemIndex + p.x - 1, LdLibrary, Map);
 end;

 UpdateCurrentMapEnvironment(); //Setup variables depending on the map size

 if Lba1 then OpenBricks(GetFilePath(Lba1_BRK,1))
 else OpenBricks(GetFilePath(Lba2_BKG,2));

 if Lba1 then
   Open.OpenScene(GetFilePath(Lba_SCENE,1), GridList1[cbSimGrid.ItemIndex], True)
 else begin
   Open.OpenScene(GetFilePath(Lba_SCENE,2), GriToScene2[cbSimGrid.ItemIndex] + 1, True);
 end;
 //InitSceneMode(); - this is done automatically one first switching to Scene Mode
end;

//TODO: Add LBA 2 scene index tables
procedure LoadGriToBllTables(); //Also loads LBA2 Grid to Scene table
var a, b: Integer;
    temp: TPackEntries;
    temp2: TPackEntry;
    p1, p2: TSmallPoint;
    FragIdx, LibIdx, LastFrag, LastLib, SType, SIdx: Byte;
    tempstr: String;
begin
 ProgBarForm.ShowSpecial('Building Grid information...', fmMain, True, True);
 if CheckFile(Lba1_BLL, 1) then begin
   GriToBll1:= GetRepeatedRefList(GetFilePath(Lba1_BLL,1));
  // for a:= 0 to High(GriToBll1) do
  //  If GriToBll1[a] = -1 then GriToBll1[a]:= a;
   BllList1:= GetNormalEntriesList(GetFilePath(Lba1_BLL,1));
 end
 else begin
   SetLength(GriToBll1, 0);
   SetLength(BllList1, 0);
 end;
 if CheckFile(Lba1_GRI, 1) then
   GridList1:= GetNormalEntriesList(GetFilePath(Lba1_GRI,1))
 else
   SetLength(GridList1, 0);
 if CheckFile(Lba2_BKG, 2) then begin
   p1:= BkgEntriesCount0(GetFilePath(Lba2_BKG,2), itGrids);
   p2:= BkgEntriesCount0(GetFilePath(Lba2_BKG,2), itFrags);
   SetLength(GriToBll2, p2.y - p1.x);
   temp:= OpenPack(GetFilePath(Lba2_BKG,2), p1.x, p1.y - 1);
   UnpackAll(temp);
   LastFrag:= 255;
   LastLib:= 255;
   for a:= 0 to High(temp) do begin
     tempstr:= UnpackToString(temp[a], 2);
     LibIdx:=  Byte(tempstr[1]);
     FragIdx:= Byte(tempstr[2]);
     GriToBll2[a]:= LibIdx + p2.y;
     if (a > 0) and (FragIdx <> LastFrag) then begin
       for b:= 0 to FragIdx - LastFrag - 1 do
         GriToBll2[LastFrag + p2.x - p1.x + b]:= LastLib + p2.y;
     end;
     LastLib:=  LibIdx;
     LastFrag:= FragIdx;
   end;
   SetLength(temp, 0); //free some mem
   //Scenes:
   a:= PackEntriesCount(GetFilePath(Lba2_BKG,2));
   temp2:= OpenSingleEntry(GetFilePath(Lba2_BKG,2), a - 1); //open last entry
   UnpackSelf(temp2);
   SetLength(GriToScene2, Length(GriToBll2));
   for a:= 0 to Length(temp2.Data) div 2 - 1 do begin
     SType:= Byte(temp2.Data[a*2 + 1]);
     SIdx:=  Byte(temp2.Data[a*2 + 2]);
     if SType = 1 then begin //type 1 is isometric Scene, type 2 is 3D Scene
       if SIdx < Length(GriToScene2) then
         GriToScene2[SIdx]:= a;
     end;
   end;
 end;
 ProgBarForm.CloseSpecial();
end;

procedure TfmOpenSim.btSimGridClick(Sender: TObject);
var a, lba: Integer;
    ext: String;
begin
 DlgOpen.Title:='Open Grid, Fragment or package';
 DlgOpen.FileName:= FFileName;
 DlgOpen.Filter:= 'All supported (*.gr1, *.gr2, *.grf, lba_gri.hqr, lba_bkg.hqr)|*.gr1;*.gr2;*.grf;*lba_gri*.hqr;*lba_bkg*.hqr|' +
                  'Grid files (*.gr1, *.gr2)|*.gr1;*.gr2|' +
                  'Grid fragments (*.grf)|*.grf|' +
                  'lba_gri.hqr or lba_bkg.hqr|*lba_gri*.hqr;*lba_bkg*.hqr';
 DlgOpen.FilterIndex:= 1;
 If DlgOpen.Execute then begin
   ext:= LowerCase(ExtractFileExt(DlgOpen.FileName));
   If ext = '.hqr' then begin
     If IsBkg(DlgOpen.FileName) then lba:= 2 else lba:= 1;
     If SameText(DlgOpen.FileName, FFileName) then
       a:= FFileIndex
     else
       a:= -1;
     a:= HQRListDialog(DlgOpen.FileName, etGridFrag, lba = 1,
       Sett.General.FirstIndex1, Sett.General.ShowIndexes,
       'Please select a Grid from the package:'#13'(only normal entries are shown)', a);
     If a > -1 then begin
       FFileName:= DlgOpen.FileName;
       FFileIndex:= a;
       stSimGrid.Caption:= Format('%s, entry %d',
         [FFileName, a + IfThen(Sett.General.FirstIndex1,1)]);
     end;
   end
   else if (ext = '.gr1') or (ext = '.gr2') or (ext = '.grf') then begin
     FFileName:= DlgOpen.FileName;
     stSimGrid.Caption:= DlgOpen.FileName;
   end
   else
     ErrorMsg('Unknown extension!');
 end;
 rbLba1Click(nil);
end;

end.
