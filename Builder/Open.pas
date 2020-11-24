//******************************************************************************
// Little Big Architect: Builder - editing grid files containing rooms in
//                                 Little Big Adventure 1 & 2
//
// Open unit.
// Contains room opening dialog (advanced) routines.
//
// Copyright Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit Open;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DePack, Engine, Grids, Libraries, ExtCtrls, ComCtrls,
  ListForm, Buttons, Scene, SceneLib, Math, Maps, Utils, SmartCombo;

type
  TfmOpen = class(TForm)
    gbBricks: TGroupBox;
    rbBrkOrigin: TRadioButton;
    rbBrkCustom: TRadioButton;
    gbLib: TGroupBox;
    rbLibOrigin: TRadioButton;
    rbLibCustom: TRadioButton;
    btBrkPath: TButton;
    btLibPath: TButton;
    DlgOpen: TOpenDialog;
    stBrkPath: TStaticText;
    stLibPath: TStaticText;
    lbInfo: TLabel;
    gbPalette: TGroupBox;
    rbPalOrigin: TRadioButton;
    rbPalCustom: TRadioButton;
    btPalPath: TButton;
    stPalPath: TStaticText;
    btOpen: TBitBtn;
    btCancel: TBitBtn;
    gbScene: TGroupBox;
    rbScnOrigin: TRadioButton;
    rbScnCustom: TRadioButton;
    btScnPath: TButton;
    stScnPath: TStaticText;
    rbScnNew: TRadioButton;
    gbGrid: TGroupBox;
    rbGriOrigin: TRadioButton;
    rbGriCustom: TRadioButton;
    cbAutoLib: TCheckBox;
    rbGriNew: TRadioButton;
    pcGridOpenNew: TPageControl;
    tsGridNew: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    eLibIndex: TEdit;
    eFragIndex: TEdit;
    tsGridOpen: TTabSheet;
    btGriPath: TButton;
    stGriPath: TStaticText;
    paMode: TPanel;
    rbGridMode: TRadioButton;
    rbSceneMode: TRadioButton;
    Label2: TLabel;
    rbLba1: TRadioButton;
    rbLba2: TRadioButton;
    procedure rbGriOriginClick(Sender: TObject);
    procedure rbLibOriginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rbBrkOriginClick(Sender: TObject);
    procedure cbGriIndexChange(Sender: TObject);
    procedure btBrkPathClick(Sender: TObject);
    procedure btLibPathClick(Sender: TObject);
    procedure btGriPathClick(Sender: TObject);
    procedure btPalPathClick(Sender: TObject);
    procedure eLibIndexChange(Sender: TObject);
    procedure cbAutoLibClick(Sender: TObject);
    procedure rbScnOriginClick(Sender: TObject);
    procedure btScnPathClick(Sender: TObject);
    procedure rbLba1Click(Sender: TObject);
    procedure cbScnIndexChange(Sender: TObject);
  private
    ScenarioOpen: Boolean;
    function AutoLibrary(): Boolean;
    procedure CheckAutoLib();
  public
    cbLibIndex: TSmartComboBox;
    cbGriIndex: TSmartComboBox;
    cbScnIndex: TSmartComboBox;
    function ShowDialog(Scenario: Boolean; Lib: Boolean = True;
      Grid: Boolean = True; Scene: Boolean = True; Pal: Boolean = True): TModalResult;
    procedure OpenFiles(ALib: Boolean = True; AGrid: Boolean = True;
      AScene: Boolean = True; APal: Boolean = True);
    //procedure CheckEnabled();
    procedure ShowControls();
  end;

  TPalType = (ptFile, ptLba, ptScenario);

{const GriToBll1: array[0..133] of Byte = (0,1,1,1,1,2,1,3,4,5,3,1,6,1,3,5,2,7,
       1,7,2,4,1,0,1,1,3,3,2,2,3,2,3,3,8,1,9,1,8,9,4,4,6,3,6,6,6,6,2,0,3,8,2,2,2,
       8,8,4,2,10,10,2,5,5,0,5,0,0,0,5,0,5,5,5,8,8,8,8,6,8,8,5,5,0,6,8,8,8,8,0,4,
       5,5,11,6,0,5,6,0,0,6,8,2,2,1,0,12,12,12,12,12,12,12,12,12,12,13,13,1,3,
       0,0,0,0,2,3,8,4,8,8,5,0,0,9);
      GriToBll2: array[0..177] of Byte = (0,0,1,2,2,2,2,0,2,0,3,3,3,4,2,0,2,1,1,
       1,1,1,2,4,5,5,1,1,1,5,5,4,3,1,1,5,5,0,5,5,5,6,1,4,4,4,7,8,9,8,7,7,7,7,7,
       10,11,11,12,12,11,11,3,6,6,11,11,11,11,11,11,7,7,7,7,3,12,11,13,13,13,13,
       13,7,14,14,14,14,14,14,14,13,13,12,7,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,4,4,
       8,8,15,15,15,15,15,12,16,17,17,17,17,6,3,3,10,10,10,10,6,10,6,10,0,0,1,3,
       13,11,12,9,10,3,17,  //grids
       3,0,5,6,9,9,7,6,6,7,7,7,7,7,12,13,15,17,6,10,10,10,10,10,10,10,10,3,10,10); //fragments
      BllToGri1: array[0..13] of Byte = (0,1,5,7,8,9,12,17,34,36,59,93,106,116);
}
var
  fmOpen: TfmOpen;

  Buffer: TPackEntry;
  Palette, InvertPal: TPalette;
  PaletteType: TPalType;
  GridOpened: Boolean = False; //True also means that Scene has been opened, because there can't be one opened without another
  SceneModified: Boolean = False;

  LibPath: String = ''; //For opening dialog
  LibIndex: Integer;
  ScenePath: String = ''; //for opening dialog
  SceneIndex: Integer;
  CurrentLibFile: String = '';
  CurrentLibIndex: Integer = 0;
  CurrentSceneFile: String = '';
  CurrentSceneIndex: Integer = 0;

Procedure SetMapModified(var Map: TComplexMap);
Function FormatPath(Path: String; Index: Integer): String;
//Function FindRadio(Num1, Num2: Integer): TRadioButton;
procedure OpenBricks(path: String);
procedure OpenLibrary(path: String; Index: Integer = 0);
function OpenGrid(path: String; Index: Integer; Lib: TLibrary;
  var Map: TComplexMap): Boolean;
procedure OpenScene(path: String; Index: Integer = 0; SimOpen: Boolean = False);

implementation

uses StrUtils, Settings, Main, ProgBar, Rendering, Hints, OpenSim, ListDialog,
     Scenario, Globals;

{$R *.dfm}

function CheckGridVersion(GridLba2: Boolean; What: String): Boolean;
begin
 Result:= False;
 If HQSInfo.Lba2 and not GridLba2 then
   Application.MessageBox(PChar('The Scenario is LBA 2 type, you cannot open an LBA 1 '+What+' for it!'),ProgramName,MB_ICONWARNING+MB_OK)
 else if not HQSInfo.Lba2 and GridLba2 then
   Application.MessageBox(PChar('The Scenario is LBA 1 type, you cannot open an LBA 2 '+What+' for it!'),ProgramName,MB_ICONWARNING+MB_OK)
 else
   Result:= True;
end;

function CheckGridFragment(Fragment: Boolean): Boolean;
begin
 Result:= False;
 If Fragment then
   Application.MessageBox('You cannot open a Grid Fragment for a Scenario!',ProgramName,MB_ICONWARNING+MB_OK)
 else
   Result:= True;
end;

Procedure SetMapModified(var Map: TComplexMap);
begin
 If not Map.Modified then begin
   Map.Modified:= True;
   fmMain.UpdateProgramName();
 end;
end;

Procedure ErrorFileNotExists(path, name: String);
begin
 Application.MessageBox(PChar(Format('%s file doesn''t exist!'#13'The file was not found on path "%s".',[name,path])),ProgramName,MB_ICONERROR+MB_OK);
 Screen.Cursor:= crDefault;
 Abort;
end;

//Returns True if AutoLibrary is available and enabled
function TfmOpen.AutoLibrary(): Boolean;
begin
 Result:= cbAutoLib.Enabled and cbAutoLib.Visible and cbAutoLib.Checked;
end;

Procedure EnableOpen();
var a: Integer;
begin
 with fmOpen do begin
   btOpen.Enabled:=
   ( rbLba1.Checked or rbLba2.Checked )
   and (
          not gbBricks.Visible
          or rbBrkOrigin.Checked
          or (rbBrkCustom.Checked and (stBrkPath.Caption <> ''))
   )
   and (
          not gbLib.Visible
          or (rbLibOrigin.Checked and (cbLibIndex.ItemIndex >= 0))
          or (rbLibCustom.Checked and (stLibPath.Caption <> ''))
          or AutoLibrary()
   )
   and (
          not gbGrid.Visible
          or (  rbGriNew.Checked
                and (
                  rbLba1.Checked
                  or (TryStrToInt(eLibIndex.Text, a) and TryStrToInt(eFragIndex.Text, a))
                )
             )
          or (rbGriOrigin.Checked and (cbGriIndex.ItemIndex >= 0))
          or (rbGriCustom.Checked and (stGriPath.Caption <> ''))
   )
   and (
          not gbScene.Visible
          or (rbScnOrigin.Checked and (cbScnIndex.ItemIndex >= 0))
          or (rbScnCustom.Checked and (stScnPath.Caption <> ''))
          or rbScnNew.Checked
   )
   and (
          not gbPalette.Visible
          or rbPalOrigin.Checked
          or (rbPalCustom.Checked and (stPalPath.Caption <> ''))
   );
 end;
end;

{Function FindRadio(Num1, Num2: Integer): TRadioButton;
begin
 Result:= fmOpen.FindComponent(Format('rb%d%d',[Num1,Num2])) as TRadioButton;
end;}

Procedure TfmOpen.CheckAutoLib();
begin
 cbAutoLib.Enabled:= (
     rbGriOrigin.Checked and (
       (rbLba1.Checked and BllEx) or (rbLba2.Checked and BkgEx)
     )
   )
   or (
     rbGriCustom.Checked and (
       ExtIs(Sett.OpenDlg.GridPath, '.hqr') or ExtIs(Sett.OpenDlg.GridPath, '.gr2'))
   );

 {(BkgEx and (IsBkg(Sett.OpenDlg.GridPath)
                                     or ExtIs(Sett.OpenDlg.GridPath, '.gr2')))
                         or (BllEx and ExtIs(Sett.OpenDlg.GridPath, '.hqr')
                             and not IsBkg(Sett.OpenDlg.GridPath));}
 if not cbAutoLib.Enabled then cbAutoLib.Checked:= False;
 cbAutoLibClick(fmMain);
end;

//Auto-check first enabled Radio button if currently checked is disabled
{procedure TfmOpen.CheckEnabled();
var a: Integer;
begin
 For a:= 0 to 4 do begin
  If (a = 1) and AutoLibrary then Continue;
  If (FindRadio(a,1).Checked and not FindRadio(a,1).Enabled)
  or (FindRadio(a,2).Checked and not FindRadio(a,2).Enabled) then
    FindRadio(a,3).Checked:= True;
 end;
 EnableOpen();
end;}

//show appropriate controls according to radio buttons checked
procedure TfmOpen.ShowControls();
var Lba1, Lba2: Boolean;
    AutoLib: Boolean;
begin
 rbLba1.Enabled:= not ScenarioOpen or not HQSInfo.Lba2;
 rbLba2.Enabled:= not ScenarioOpen or HQSInfo.Lba2;
 if not rbLba1.Enabled then rbLba1.Checked:= False;
 if not rbLba2.Enabled then rbLba2.Checked:= False;
 Lba1:= rbLba1.Checked;
 Lba2:= rbLba2.Checked;

 stBrkPath.Visible:= rbBrkCustom.Checked;
 btBrkPath.Visible:= rbBrkCustom.Checked;
 cbLibIndex.Visible:= rbLibOrigin.Checked;
 stLibPath.Visible:= rbLibCustom.Checked;
 btLibPath.Visible:= rbLibCustom.Checked;
 cbGriIndex.Visible:= rbGriOrigin.Checked;
 stGriPath.Visible:= rbGriCustom.Checked;
 btGriPath.Visible:= rbGriCustom.Checked;
 pcGridOpenNew.Visible:= Lba2 or rbGriOrigin.Checked or rbGriCustom.Checked;
 if rbGriNew.Checked then pcGridOpenNew.ActivePage:= tsGridNew
                     else pcGridOpenNew.ActivePage:= tsGridOpen;
 cbScnIndex.Visible:= rbScnOrigin.Checked;
 stScnPath.Visible:= rbScnCustom.Checked;
 btScnPath.Visible:= rbScnCustom.Checked;
 stPalPath.Visible:= rbPalCustom.Checked;
 btPalPath.Visible:= rbPalCustom.Checked;

 AutoLib:= AutoLibrary();

 rbBrkOrigin.Enabled:= (Lba1 and BrkEx) or (Lba2 and BkgEx);
 if not rbBrkOrigin.Enabled then rbBrkCustom.Checked:= True;
 rbLibOrigin.Enabled:= ((Lba1 and BllEx) or (Lba2 and BkgEx)) and not AutoLib;
 if AutoLib then
   rbLibOrigin.Checked:= True
 else
   if not rbLibOrigin.Enabled then rbLibCustom.Checked:= True;
 rbLibCustom.Enabled:= not AutoLib;
 if not rbLibCustom.Enabled then rbLibCustom.Checked:= False;
 cbLibIndex.Enabled:= not AutoLib;
 btLibPath.Enabled:= not AutoLib;
 rbGriOrigin.Enabled:= (Lba1 and GriEx) or (Lba2 and BkgEx);
 if rbGriOrigin.Checked and not rbGriOrigin.Enabled then rbGriCustom.Checked:= True;
 rbScnOrigin.Enabled:= (Lba1 and Sc1Ex) or (Lba2 and Sc2Ex);
 if rbScnOrigin.Checked and not rbScnOrigin.Enabled then rbScnCustom.Checked:= True;

 EnableOpen();
end;

procedure TfmOpen.rbLba1Click(Sender: TObject);
begin
 rbLba1.Font.Color:= IfThen(rbLba1.Checked, clBlue, clWindowText);
 rbLba2.Font.Color:= IfThen(rbLba2.Checked, clBlue, clWindowText);

 cbLibIndex.ItemIndex:= -1;
 cbGriIndex.ItemIndex:= -1;
 cbScnIndex.ItemIndex:= -1;

 ShowControls();
 //CheckEnabled();

 rbLibOriginClick(nil);
 rbGriOriginClick(nil);
 rbScnOriginClick(nil);
end;

procedure TfmOpen.rbGriOriginClick(Sender: TObject);
var a: Integer;
begin
 a:= IfThen(rbLba1.Checked, 1, 2);
 if rbGriOrigin.Checked then begin
   if ScenarioOpen then begin
     LoadCombo(cbGriIndex, -a, etGridFrag);
     if a = 2 then
       while Copy(cbGriIndex.Items.Strings[cbGriIndex.Items.Count-1],1,10) = '[fragment]' do
         cbGriIndex.Items.Delete(cbGriIndex.Items.Count - 1);
   end else
     LoadCombo(cbGriIndex, a, etGridFrag);
 end;
 //If rb21.Checked or rb22.Checked then cbAutoLib.Checked:= True
 //else if rb24.Checked then cbAutoLib.Checked:= False;
 CheckAutoLib();
 //CheckEnabled();
 ShowControls();
end;

procedure TfmOpen.rbLibOriginClick(Sender: TObject);
var a: Integer;
begin
 a:= IfThen(rbLba1.Checked, 1, 2);
 if rbLibOrigin.Checked then begin
   LoadCombo(cbLibIndex, a, etLibs);
   If cbGriIndex.ItemIndex > -1 then
     cbGriIndexChange(cbGriIndex);
 end;
 //CheckEnabled();
 ShowControls();
end;

procedure TfmOpen.rbBrkOriginClick(Sender: TObject);
begin
 //CheckEnabled();
 ShowControls();
end;

procedure TfmOpen.rbScnOriginClick(Sender: TObject);
var a: Integer;
begin
 a:= IfThen(rbLba1.Checked, 1, 2);
 if rbLibOrigin.Checked then begin
   {If ScenarioOpen then begin
    LoadCombo(grCombo,-a,'GRI');
    If a = 2 then
     while Copy(grCombo.Items.Strings[grCombo.Items.Count-1],1,10) = '[fragment]' do
      grCombo.Items.Delete(grCombo.Items.Count - 1);
   end
   else} LoadCombo(cbScnIndex, a, etScenes);
 end;
 //CheckEnabled();
 ShowControls();
end;

procedure TfmOpen.FormCreate(Sender: TObject);
begin
 //rb21Click(Self);
 //rb11Click(Self);
 cbLibIndex:= TSmartComboBox.Create(Self);
 cbLibIndex.Name:= 'cbLibIndex';
 cbLibIndex.Parent:= gbLib;
 cbLibIndex.DropDownCount:= 20;
 cbLibIndex.Left:= 16;
 cbLibIndex.Top:= 36;
 cbLibIndex.Width:= 403;
 cbLibIndex.Height:= 21;
 cbLibIndex.ItemHeight:= 13;
 cbLibIndex.TabOrder:= 2;
 cbLibIndex.ParentFont:= False;
 cbLibIndex.Font.Style:= [];
 cbLibIndex.AutoDropDown:= True;
 cbLibIndex.OnChange:= eLibIndexChange;

 cbGriIndex:= TSmartComboBox.Create(Self);
 cbGriIndex.Name:= 'cbGriIndex';
 cbGriIndex.Parent:= tsGridOpen;
 cbGriIndex.DropDownCount:= 20;
 cbGriIndex.Left:= 4;
 cbGriIndex.Top:= 0;
 cbGriIndex.Width:= 403;
 cbGriIndex.Height:= 21;
 cbGriIndex.ItemHeight:= 13;
 cbGriIndex.TabOrder:= 0;
 cbGriIndex.ParentFont:= False;
 cbGriIndex.Font.Style:= [];
 cbGriIndex.AutoDropDown:= True;
 cbGriIndex.OnChange:= cbGriIndexChange;

 cbScnIndex:= TSmartComboBox.Create(Self);
 cbScnIndex.Name:= 'cbScnIndex';
 cbScnIndex.Parent:= gbScene;
 cbScnIndex.DropDownCount:= 20;
 cbScnIndex.Left:= 16;
 cbScnIndex.Top:= 36;
 cbScnIndex.Width:= 403;
 cbScnIndex.Height:= 21;
 cbScnIndex.ItemHeight:= 13;
 cbScnIndex.TabOrder:= 5;
 cbScnIndex.ParentFont:= False;
 cbScnIndex.Font.Style:= [];
 cbScnIndex.AutoDropDown:= True;
 cbScnIndex.OnChange:= cbScnIndexChange;

    
end;

procedure TfmOpen.cbGriIndexChange(Sender: TObject);
var a, b, gid: Integer;
begin
 gid:= cbGriIndex.ItemIndex;
 if gid >= 0 then begin
   if rbGriOrigin.Checked then begin
     if rbLba1.Checked then begin
       b:= GriToBll1[GridList1[gid]];
       for a:= 0 to High(BllList1) do
         if BllList1[a] = b then begin
           cbLibIndex.ItemIndex:= a;
           Break;
         end;
     end
     else if rbLba2.Checked then
       cbLibIndex.ItemIndex:= GriToBll2[gid] - GriToBll2[0];

     if rbScnOrigin.Checked then begin
       if rbLba1.Checked and (gid < cbScnIndex.Items.Count) then
         cbScnIndex.ItemIndex:= gid
       else if rbLba2.Checked and (GriToScene2[gid] < cbScnIndex.Items.Count) then
         cbScnIndex.ItemIndex:= GriToScene2[gid];
     end;
   end;
 end;
 EnableOpen();
end;

procedure TfmOpen.cbScnIndexChange(Sender: TObject);
begin
 EnableOpen();
end;

Function FormatPath(Path: String; Index: Integer): String;
begin
 If Path <> '' then begin
  If not ExtIs(Path,'.hqr') then Result:= Path
  else if Index >= 0 then Result:= Path + ', entry ' + IntToStr(Index + 1);
 end;
end;

procedure TfmOpen.btBrkPathClick(Sender: TObject);
begin
 DlgOpen.Title:= 'Open Brick package';
 DlgOpen.FileName:= stBrkPath.Caption;
 if ScenarioOpen then begin
   if HQSInfo.Lba2 then DlgOpen.Filter:= 'LBA 2 Bricks (lba_bkg.hqr)|*lba_bkg*.hqr'
   else DlgOpen.Filter:= 'LBA 1 Bricks (lba_brk.hqr)|*lba_brk*.hqr';
 end
 else DlgOpen.Filter:= 'LBA Bricks (lba_brk.hqr or lba_bkg.hqr)|*lba_brk*.hqr;*lba_bkg*.hqr';
 if DlgOpen.Execute then begin
   if not ScenarioOpen
   or CheckGridVersion(IsBkg(DlgOpen.FileName),'Bricks') then begin
     stBrkPath.Caption:= DlgOpen.FileName;
   end;
 end;
 EnableOpen();
end;

procedure TfmOpen.btLibPathClick(Sender: TObject);
var //p: TSmallPoint;
    a, lba: Integer;
    ext: String;
begin
 DlgOpen.Title:= 'Open Layout library or package';
 DlgOpen.FileName:= LibPath;
 if ScenarioOpen then begin
   if HQSInfo.Lba2 then DlgOpen.Filter:= 'LBA 2 Libraries (*.bl2, lba_bkg.hqr)|*.bl2;*lba_bkg*.hqr'
   else DlgOpen.Filter:= 'LBA 1 Libraries (*.bl1, lba_bll.hqr)|*.bl1;*lba_bll*.hqr';
 end else
   DlgOpen.Filter:= 'All supported (*.bl1, *.bl2, lba_bll.hqr, lba_brk.hqr)|*.bl1;*.bl2;*lba_bll*.hqr;*lba_bkg*.hqr|'+
                    'Layout libraries (*.bl1, *.bl2)|*.bl1;*.bl2|'+
                    'lba_bll.hqr or lba_bkg.hqr|*lba_bll*.hqr;*lba_bkg*.hqr';
 DlgOpen.FilterIndex:= 1;
 if DlgOpen.Execute then begin
   ext:= LowerCase(ExtractFileExt(DlgOpen.FileName));
   if ext = '.hqr' then begin
     //p.x:= 1;
     if IsBkg(DlgOpen.FileName) then lba:= 2 else lba:= 1;
     if not ScenarioOpen or CheckGridVersion(lba = 2,'Library') then begin
       //If lba = 2 then p:= BkgEntriesCount(DlgOpen.FileName,weLibs)
       //else p.y:= PackEntriesCount(DlgOpen.FileName);
       //If fmListForm.ShowDialog(Format('LBA_%d_BLL',[lba]),p.y-p.x+1,a) then begin
       if SameText(DlgOpen.FileName,LibPath) then a:= LibIndex
                                             else a:= -1;
       a:= HQRListDialog(DlgOpen.FileName, etLibs, lba = 1,
          Sett.General.FirstIndex1, Sett.General.ShowIndexes,
          'Please select a Library from the package:'#13'(only normal entries are shown)',a);
       if a > -1 then begin
         LibPath:= DlgOpen.FileName;
         //If lba = 1 then LibIndex:= BllToGri1[a+p.x-1]+1 else LibIndex:= a+p.x;
         LibIndex:= a;
         stLibPath.Caption:= Format('%s, entry %d',
           [LibPath,LibIndex + IfThen(Sett.General.FirstIndex1,1)]);
       end;
     end;
   end
   else if (ext = '.bl1') or (ext = '.bl2') then begin
     if not ScenarioOpen or CheckGridVersion(ext = '.bl2','Library') then begin
       LibPath:= DlgOpen.FileName;
       stLibPath.Caption:= LibPath;
     end;
   end else
     Application.MessageBox('Unknown extension!',ProgramName,MB_ICONERROR+MB_OK);
 end;
 EnableOpen;
end;

procedure TfmOpen.btGriPathClick(Sender: TObject);
var //p: TSmallPoint;
    a, lba: Integer;
    ext: String;
begin
 DlgOpen.Title:='Open Grid, Fragment or package';
 DlgOpen.FileName:= Sett.OpenDlg.GridPath;
 if ScenarioOpen then begin
   if HQSInfo.Lba2 then DlgOpen.Filter:= 'LBA 2 Grids (*.gr2, lba_bkg.hqr)|*.gr2;*lba_bkg*.hqr'
   else DlgOpen.Filter:= 'LBA 1 Grids (*.gr1, lba_gri.hqr)|*.gr1;*lba_gri*.hqr';
 end else
   DlgOpen.Filter:= 'All supported (*.gr1, *.gr2, *.grf, lba_gri.hqr, lba_bkg.hqr)|*.gr1;*.gr2;*.grf;*lba_gri*.hqr;*lba_bkg*.hqr|' +
                    'Grid files (*.gr1, *.gr2)|*.gr1;*.gr2|' +
                    'Grid fragments (*.grf)|*.grf|' +
                    'lba_gri.hqr or lba_bkg.hqr|*lba_gri*.hqr;*lba_bkg*.hqr';
 DlgOpen.FilterIndex:= 1;
 if DlgOpen.Execute then begin
   ext:= LowerCase(ExtractFileExt(DlgOpen.FileName));
   if ext= '.hqr' then begin
     //p.x:= 1;
     if IsBkg(DlgOpen.FileName) then lba:= 2 else lba:= 1;
     if not ScenarioOpen or CheckGridVersion(lba = 2,'Grid') then begin
       //If (lba = 2) then p:= BkgEntriesCount(DlgOpen.FileName,weGrids)
       //else p.y:= PackEntriesCount(DlgOpen.FileName);
       //If fmListForm.ShowDialog(Format('LBA_%d_GRI',[lba]),p.y-p.x+1,a) then begin
       if SameText(DlgOpen.FileName, Sett.OpenDlg.GridPath) then
         a:= Sett.OpenDlg.GridIndex
       else
         a:= -1;
       a:= HQRListDialog(DlgOpen.FileName, etGridFrag, lba = 1,
          Sett.General.FirstIndex1, Sett.General.ShowIndexes,
          'Please select a Grid from the package:'#13'(only normal entries are shown)',a);
       if a > -1 then begin
         Sett.OpenDlg.GridPath:= DlgOpen.FileName;
         Sett.OpenDlg.GridIndex:= a; // + p.x;
         stGriPath.Caption:= Format('%s, entry %d',
           [Sett.OpenDlg.GridPath, Sett.OpenDlg.GridIndex + IfThen(Sett.General.FirstIndex1,1)]);
       end;
     end;
   end
   else if (ext = '.gr1') or (ext = '.gr2') or (ext = '.grf') then begin
     if not ScenarioOpen
     or (CheckGridVersion(ext = '.gr2','Grid')
     and CheckGridFragment(ext = '.grf')) then begin
       Sett.OpenDlg.GridPath:= DlgOpen.FileName;
       stGriPath.Caption:= Sett.OpenDlg.GridPath;
     end;
   end else
     Application.MessageBox('Unknown extension!',ProgramName,MB_ICONERROR+MB_OK);
 end;
 //EnableOpen;
 CheckAutoLib();
end;

procedure TfmOpen.btPalPathClick(Sender: TObject);
begin
 DlgOpen.Title:='Open palette';
 DlgOpen.FileName:= stPalPath.Caption;
 DlgOpen.Filter:='LBA palette files (*.pal)|*.pal';
 if DlgOpen.Execute then begin
   stPalPath.Caption:= DlgOpen.FileName;
 end;
 EnableOpen();
end;

procedure TfmOpen.btScnPathClick(Sender: TObject);
var a, lba: Integer;
    ext: String;
begin
 DlgOpen.Title:= 'Open Scene or package';
 DlgOpen.FileName:= ScenePath;
 if (    ScenarioOpen and HQSInfo.Lba2)
 or (not ScenarioOpen and rbLba2.Checked) then
   DlgOpen.Filter:= 'All LBA 2 Scenes|*.ls2;*.stp;*.sc2;*.sce;*scene*.hqr'
                  + '|LBA Scene Text Projects (*.stp)|*.stp'
                  + '|LBA 2 binary Scenes (*.ls2)|*.ls2'
                  + '|LBA 2 text Scenes (*.sc2, *.sce)|*.sc2;*.sce'
                  + '|LBA 2 scene.hqr|*scene*.hqr'
 else
   DlgOpen.Filter:= 'All LBA 1 Scenes|*.ls1;*.stp;*.sc1;*.sce;*scene*.hqr'
                  + '|LBA Scene Text Projects (*.stp)|*.stp'
                  + '|LBA 1 binary Scenes (*.ls1)|*.ls1'
                  + '|LBA 1 text Scenes (*.sc1, *.sce)|*.sc1;*.sce'
                  + '|LBA 1 scene.hqr|*scene*.hqr';
 DlgOpen.FilterIndex:= 1;
 if DlgOpen.Execute then begin
   ext:= LowerCase(ExtractFileExt(DlgOpen.FileName));
   if ext= '.hqr' then begin
     if IsSceneLba2(DlgOpen.FileName) then
       lba:= 2
     else
       lba:= 1;
     if not ScenarioOpen or CheckGridVersion(lba = 2, 'Scene') then begin  //TODO: Check this
       if SameText(DlgOpen.FileName, ScenePath) then a:= SceneIndex
                                                else a:= -1;
       a:= HQRListDialog(DlgOpen.FileName, etScenes, lba = 1,
         Sett.General.FirstIndex1, Sett.General.ShowIndexes,
         'Please select a Scene from the package:'#13'(only normal entries are shown)', a);
       if a > -1 then begin
         ScenePath:= DlgOpen.FileName;
         SceneIndex:= a;
         stScnPath.Caption:= Format('%s, entry %d',
           [ScenePath, SceneIndex + IfThen(Sett.General.FirstIndex1,1)]);
       end;
     end;
   end
   else if (ext = '.ls1') or (ext = '.ls2')
        or (ext = '.sc1') or (ext = '.sc2') or (ext = '.sce')
        or (ext = '.stp') then begin
     if not ScenarioOpen
     or CheckGridVersion((ext = '.ls2') or (ext = '.sc2'), 'Scene') then begin
       //TODO: add stp file LBA 2 checking!
       ScenePath:= DlgOpen.FileName;
       stScnPath.Caption:= ScenePath;
     end;
   end else
     Application.MessageBox('Unknown extension!',ProgramName,MB_ICONERROR+MB_OK);
 end;
 //EnableOpen;
 //CheckAutoLib;
end;

procedure OpenPalette(path: String);
begin
 if not FileExists(path) then ErrorFileNotExists(path,'Palette');
 Palette:= LoadPaletteFromFile(path);
 //InvertPal:= InvertPalette(Palette);
 PaletteType:= ptFile;
end;

procedure OpenBricks(path: String);
var FStr: TFileStream;
    p: TSmallPoint;
begin
 If not FileExists(path) then ErrorFileNotExists(path, 'Brick');
 FStr:= TFileStream.Create(path, fmOpenRead + fmShareDenyWrite);
 If AnsiContainsText(path, 'lba_bkg') then begin
   TransparentBrick:= BkgEntriesCount(FStr, itTransparent).y + 1;
   p:= BkgEntriesCount(FStr, itBricks);
   PkBricks:= OpenPack(FStr, p.x-1, p.x+p.y);
 end
 else begin
   TransparentBrick:= 0;
   PkBricks:= OpenPack(FStr);
 end;
 FreeAndNil(FStr);
end;

procedure OpenLibrary(path: String; Index: Integer = 0);
var FStr: TFileStream;
    MStr: TMemoryStream;
    ext: String;
begin
 If not FileExists(path) then ErrorFileNotExists(path,'Library');
 FStr:= TFileStream.Create(path,fmOpenRead + fmShareDenyWrite);
 ext:= LowerCase(ExtractFileExt(path));
 If (ext = '.bl1') or (ext = '.bl2') then
   LdLibrary:= LoadLibraryFromStream(FStr)
 else if ext = '.hqr' then begin
   MStr:= UnpackToStream(OpenSingleEntry(FStr,Index));
   LdLibrary:= LoadLibraryFromStream(MStr);
   FreeAndNil(MStr);
 end;
 FreeAndNil(FStr);
 CurrentLibFile:= path;
 CurrentLibIndex:= Index;
end;

function OpenGrid(path: String; Index: Integer; Lib: TLibrary;
  var Map: TComplexMap): Boolean;
var FStr: TFileStream;
    MStr: TMemoryStream;
    ext: String;
    VPack: TPackEntry;
    p: TSmallPoint;
begin
 Result:= False;
 if not FileExists(path) then
   ErrorFileNotExists(path,'Grid');
 FStr:= TFileStream.Create(path,fmOpenRead,fmShareDenyWrite);
 ext:= LowerCase(ExtractFileExt(path));
 if (ext = '.gr1') or (ext = '.gr2') then begin
   //fmMain.SetLBAMode(IfThen(ext = '.gr2', 2, 1));
   Result:= LoadGridFromStream(FStr, LBAMode = 2, Lib, GLibIndex, GFragIndex, Map);
   Map.Compression:= 0;
   MainMapIsGrid:= True;
 end
 else if ext = '.grf' then begin
   //fmMain.SetLBAMode(2);
   Result:= LoadFragmentFromStream(FStr, Lib, Map);
   Map.Compression:= 0;
   MainMapIsGrid:= False;
 end
 else if ext = '.hqr' then begin
   VPack:= OpenSingleEntry(FStr,Index);
   MainMapIsGrid:= True;
   MStr:= UnpackToStream(VPack);
   if IsBkg(path) then begin
     //fmMain.SetLBAMode(2);
     p:= BkgEntriesCount(FStr, itFrags);
     If Index + 1 < p.x then
       Result:= LoadGridFromStream(MStr, True, Lib, GLibIndex, GFragIndex, Map)
     else begin
       Result:= LoadFragmentFromStream(MStr, Lib, Map);
       MainMapIsGrid:= False;
     end;
   end
   else begin
     //fmMain.SetLBAMode(1);
     Result:= LoadGridFromStream(MStr, False, Lib, GLibIndex, GFragIndex, Map);
   end;
   FreeAndNil(MStr);
   Map.Compression:= VPack.Comp;
 end;
 Map.FilePath:= path;
 Map.FileIndex:= Index;
 FreeAndNil(FStr);
end;

//Tries to automatically determine Library Index for given Grid
//Works only for HQRs and gr2.
//Returns -1 if the index can't be determined automatically (e.g. file is gr1).
function GetGridLibIndex(path: String; Index: Integer): Integer;
var FStr: TFileStream;
    temp: TMemoryStream;
    ext: String;
    VPack: TPackEntry;
    p: TSmallPoint;
    BKG, HQR, GR2: Boolean;
    LIndex: Byte;
begin
 Result:= -1;
 If not FileExists(path) then Exit; //ErrorFileNotExists(path, 'Grid');
 ext:= LowerCase(ExtractFileExt(path));
 HQR:= ext = '.hqr';
 GR2:= not HQR and (ext = '.gr2');
 BKG:= HQR and IsBkg(path);
 if GR2 or HQR then begin
   if HQR and not BKG then begin
     Result:= Index; //For LBA 1 HQRs the relationship is that simple
     Exit;
   end;
   FStr:= TFileStream.Create(path, fmOpenRead, fmShareDenyWrite);
   FStr.Seek(0, soBeginning);
   if GR2 then
     FStr.Read(Result, 1)
   else if BKG then begin
     VPack:= OpenSingleEntry(FStr, Index);
     p:= BkgEntriesCount(FStr, itFrags);
     If Index + 1 < p.x then begin
       temp:= UnpackToStream(VPack);
       temp.Seek(0, soBeginning);
       temp.Read(LIndex, 1);
       FreeAndNil(temp);
       Result:= LIndex;
     end;
   end;
   FreeAndNil(FStr);
 end;
end;

procedure OpenScene(path: String; Index: Integer = 0; SimOpen: Boolean = False);
var FStr: TFileStream;
    MStr: TMemoryStream;
    ext: String;
    StpLba: Byte;
    VPack: TPackEntry;
    Lba2: Boolean;
  procedure Error(Msg: String);
  begin
    If Msg <> '' then Application.MessageBox(PChar(Msg), ProgramName, MB_ICONERROR or MB_OK);
    VScene:= CreateEmptyScene();
    CurrentSceneFile:= '';
    CurrentSceneIndex:= 0;
  end;
begin
 If not FileExists(path) then ErrorFileNotExists(path, 'Scene');
 FStr:= TFileStream.Create(path, fmOpenRead + fmShareDenyWrite);
 SceneLoadedFromText:= False;
 CurrentSceneIndex:= Index;
 CurrentSceneFile:= path;
 SOrgComp:= 0;
 ext:= LowerCase(ExtractFileExt(path));
 if (ext = '.ls1') or (ext = '.ls2') then
   VScene:= SceneLib.LoadSceneFromStream(FStr, IfThen(ext='.ls1', 1, 2))
 else if ext = '.hqr' then begin
   Lba2:= IsSceneLba2(path);
   //if Lba2 then Inc(Index); //for LBA2 first scene.hqr entry is information file - THIS IS ALREADY ACCOUNTED HERE
   if OpenSingleEntry(FStr, Index, VPack) then begin
     MStr:= UnpackToStream(VPack);
     VScene:= SceneLib.LoadSceneFromStream(MStr, IfThen(Lba2, 2, 1));
     FreeAndNil(MStr);
     SOrgComp:= VPack.Comp;
   end else begin
     if SimOpen then begin
       InfoMsg('Fragments don''t have associated Scenes. Empty Scene will be created.');
       Error('');
     end else
       Error('There is no Scene at specified index! Empty Scene will be created instead.');
   end;
 end
 else if (ext = '.sc1') or (ext = '.sce') or (ext = '.sc2') then begin
   if SceneLib.LoadTextSceneStream(FStr, IfThen(ext='.sc2', 2, 1), VScene) then
     SceneLoadedFromText:= True
   else
     Error('Error during opening the text Scene. An empty Scene will be created instead.');
 end
 else if ext = '.scp' then begin
   If SceneLib.LoadCoderProjectStream(FStr, 1, VScene) then
     SceneLoadedFromText:= True
   else
     Error('Error during opening the Story Coder Project. An empty Scene will be created instead.');
 end
 else if ext = '.stp' then begin
   if SceneLib.LoadSceneProjectStream(FStr, StpLba, VScene) then
     SceneLoadedFromText:= True //TODO: What can we use the StpLba info for?
   else
     Error('Error during opening the Text Scene Project. An empty Scene will be created instead.');
 end
 else
   Error('Unknown Scene file extension! An empty Scene will be created instead.');
 FStr.Free();

end;

procedure TfmOpen.OpenFiles(ALib: Boolean = True; AGrid: Boolean = True;
  AScene: Boolean = True; APal: Boolean = True);
var p: TSmallPoint;
    GPath: String;
    GIndex, GLIndex, mi: Integer;
    Lba1: Boolean;
begin
 Lba1:= rbLba1.Checked;
 fmMain.SetLbaMode(IfThen(Lba1, 1, 2));
 GIndex:= 0;
 GLIndex:= 0;

 if APal then begin
   PaletteType:= ptLba;
   if rbPalOrigin.Checked then
     if Lba1 then Palette:= LoadPaletteFromResource(1)
             else Palette:= LoadPaletteFromResource(2)
   else OpenPalette(stPalPath.Caption);
 end;

 if AGrid then begin
   TransparentBrick:= 0;
   if rbGriOrigin.Checked then begin
     if Lba1 then begin
       GPath:= GetFilePath(Lba1_GRI, 1);
       GIndex:= GridList1[cbGriIndex.ItemIndex];
     end else begin
       p:= BkgEntriesCount(GetFilePath(Lba2_BKG, 2), itGrids);
       GPath:= GetFilePath(Lba2_BKG, 2);
       GIndex:= cbGriIndex.ItemIndex + p.x-1;
     end;
   end
   else if rbGriCustom.Checked then begin
     GPath:= Sett.OpenDlg.GridPath;
     GIndex:= Sett.OpenDlg.GridIndex;
   end else
     MainMapIsGrid:= True; //rbGriNew
   GLIndex:= GetGridLibIndex(GPath, GIndex);
 end;

 if ALib then begin
   Assert(AGrid, 'OpenFiles: ALib without AGrid');
   if AutoLibrary then begin
     if ExtIs(GPath, '.gr2') or IsBkg(GPath) then begin
       p:= BkgEntriesCount(GetFilePath(Lba2_BKG, 2), itLibs);
       OpenLibrary(GetFilePath(Lba2_BKG, 2), GLIndex + p.x-1);
     end
     else if ExtIs(GPath, '.hqr') then
       OpenLibrary(GetFilePath(Lba1_BLL, 1), GLIndex); //Sett.OpenDlg.GridIndex);
   end
   else begin
     if rbLibOrigin.Checked then begin
       if Lba1 then
         OpenLibrary(GetFilePath(Lba1_BLL, 1), BllList1[cbLibIndex.ItemIndex])
       else begin
         p:= BkgEntriesCount(GetFilePath(Lba2_BKG, 2), itLibs);
         OpenLibrary(GetFilePath(Lba2_BKG, 2), cbLibIndex.ItemIndex + p.x - 1);
       end;
     end else
       OpenLibrary(LibPath, LibIndex);
   end;

   if rbBrkOrigin.Checked then
     if Lba1 then OpenBricks(GetFilePath(Lba1_BRK, 1))
             else OpenBricks(GetFilePath(Lba2_BKG, 2))
   else OpenBricks(stBrkPath.Caption);
 end;

 //This function is to be called for newly opened maps only (not for
 //  opening additional Fragments when the Main Grid is already in),
 //  so we are safe to clear the LdMaps and init it here.
 if AGrid then begin
   TransparentBrick:= 0;
   SetLength(LdMaps, 0); //should have been already done, but it won't hurt
   mi:= CreateNewMap(True);
   if mi >= 0 then begin
     CMap:= @LdMaps[mi]; //Create and set as current
     if rbGriNew.Checked then begin //create a new map
       InitMap(CMap^, 64, 25, 64);
       CMap^.IsGrid:= True; //TODO: fix this for Lba 2!
     end else //open existing map
       OpenGrid(GPath, GIndex, LdLibrary, CMap^);
     UpdateCurrentMapEnvironment(); //Setup variables depending on the map size
   end else begin
     CloseEverything();
     Exit;
   end;  
 end;

 if AScene then begin
   if rbScnOrigin.Checked then begin
     if Lba1 then
       OpenScene(GetFilePath(Lba_SCENE, 1), SceneIndexList[cbScnIndex.ItemIndex])
     else begin
       OpenScene(GetFilePath(Lba_SCENE, 2), SceneIndexList[cbScnIndex.ItemIndex]);
     end;
   end
   else if rbScnCustom.Checked then
     OpenScene(ScenePath, SceneIndex)
   else
     VScene:= CreateEmptyScene(); //rbScnNew
 end;
end;

procedure TfmOpen.eLibIndexChange(Sender: TObject);
begin
 if (Sender is TComboBox) and rbLibOrigin.Checked and rbLba2.Checked then
   eLibIndex.Text:= IntToStr(cbLibIndex.ItemIndex);
 EnableOpen();
end;

procedure TfmOpen.cbAutoLibClick(Sender: TObject);
begin
 ShowControls();
 EnableOpen();
end;

function TfmOpen.ShowDialog(Scenario: Boolean; Lib: Boolean = True;
 Grid: Boolean = True; Scene: Boolean = True; Pal: Boolean = True): TModalResult;
begin
 If Scenario then fmOpen.lbInfo.Caption:= 'For Scenario you can open only files from compatible LBA version.'
 else fmOpen.lbInfo.Caption:= 'If path to an LBA directory is not specified, ''Original'' option will be disabled for some groups.';
 ScenarioOpen:= Scenario;
 //fmOpen.rb21Click(fmOpen);  //unnecessary?

 gbBricks.Visible:= not Scenario or Lib;
 gbLib.Visible:= not Scenario or Lib;
 gbGrid.Visible:= not Scenario or Grid;
 gbScene.Visible:= not Scenario or Scene;
 gbPalette.Visible:= not Scenario or Pal;
 paMode.Visible:= not Scenario;
 cbAutoLib.Visible:= not Scenario or Lib;

 //LoadGriToBllTables();
 ShowControls();
 
 //it's here because GridPath and Index may be in Scenario opening also:
 fmOpen.stGriPath.Caption:= FormatPath(Sett.OpenDlg.GridPath, Sett.OpenDlg.GridIndex);
 fmOpen.stScnPath.Caption:= FormatPath(ScenePath, SceneIndex);
 CheckAutoLib();
 //CheckEnabled();
 rbBrkOriginClick(nil);
 rbLibOriginClick(nil);
 rbGriOriginClick(nil);
 rbScnOriginClick(nil);
 cbAutoLibClick(nil);

 Result:= ShowModal();
end;

end.
