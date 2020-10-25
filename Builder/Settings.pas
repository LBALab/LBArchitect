//******************************************************************************
// Little Big Architect: Builder
//   Little Big Adventure 1 & 2 Grid and Scene editing software
//
// Settings unit
// Contains settings saving, loading and editing routines
//
// Copyright Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit Settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles, Engine, Math, ComCtrls, ExtCtrls, Buttons,
  DFSClrBn, PathEdit, BetterSpin, SceneLibConst;

const
  HiZoneType = 7;

type
  TfmSettings = class(TForm)
    pcSettings: TPageControl;
    tsPaths: TTabSheet;
    gbPaths1: TGroupBox;
    gbPaths2: TGroupBox;
    tsGeneral: TTabSheet;
    cbResetClip: TCheckBox;
    cbAskDelLayer: TCheckBox;
    tsMouse: TTabSheet;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    eWSpeed: TEdit;
    eWAverage: TEdit;
    cbWInvX: TCheckBox;
    cbWInvY: TCheckBox;
    tsCoords: TTabSheet;
    GroupBox4: TGroupBox;
    cbUseComp1: TCheckBox;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    cbUseComp2: TCheckBox;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    paComp2: TPanel;
    rbCm2UseOrg: TRadioButton;
    rbCm2Force1: TRadioButton;
    rbCm2Force2: TRadioButton;
    rbCm2Ask: TRadioButton;
    paComp1: TPanel;
    rbCm1UseOrg: TRadioButton;
    rbCm1Force1: TRadioButton;
    rbCm1Ask: TRadioButton;
    tsScene: TTabSheet;
    gbZoneColours: TGroupBox;
    lbZone2: TLabel;
    lbZone0: TLabel;
    lbZone1: TLabel;
    lbZone3: TLabel;
    lbZone5: TLabel;
    lbZone4: TLabel;
    lbZone6: TLabel;
    GroupBox7: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    cbDispCur: TCheckBox;
    cbDispSel: TCheckBox;
    GroupBox3: TGroupBox;
    rbRangeSep: TRadioButton;
    rbRangeCon: TRadioButton;
    cbRangeHide: TCheckBox;
    cbDispBrk: TCheckBox;
    rbAtCursor: TRadioButton;
    rbSelected: TRadioButton;
    GroupBox8: TGroupBox;
    Label21: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    cbScenePix: TCheckBox;
    cbSceneBrk: TCheckBox;
    cbSceneClip: TCheckBox;
    Label22: TLabel;
    Label26: TLabel;
    cbSceneSel: TCheckBox;
    Label47: TLabel;
    rbDir11: TRadioButton;
    rbDir12: TRadioButton;
    rbDir13: TRadioButton;
    rbDir21: TRadioButton;
    rbDir22: TRadioButton;
    rbDir23: TRadioButton;
    cbSceneSnap: TCheckBox;
    cbFirstIndex1: TCheckBox;
    cbSingleInvPlacing: TCheckBox;
    tsScriptsGen: TTabSheet;
    tsScriptsCom: TTabSheet;
    GroupBox10: TGroupBox;
    cbRequireENDs: TCheckBox;
    cbNotStrictSyntax: TCheckBox;
    cbAutoHLError: TCheckBox;
    cbAutoHLVisOnly: TCheckBox;
    GroupBox12: TGroupBox;
    cbLabelWarnings: TCheckBox;
    cbLbUnusedWarns: TCheckBox;
    cbCompUnusedWarns: TCheckBox;
    cbCheckZones: TCheckBox;
    cbCheckSuit: TCheckBox;
    GroupBox13: TGroupBox;
    Panel1: TPanel;
    Label35: TLabel;
    rbTrackNothing: TRadioButton;
    rbTrackWarning: TRadioButton;
    rbTrackError: TRadioButton;
    Panel2: TPanel;
    Label45: TLabel;
    rbActorNothing: TRadioButton;
    rbActorWarning: TRadioButton;
    rbActorError: TRadioButton;
    Panel3: TPanel;
    Label44: TLabel;
    rbBdAnNothing: TRadioButton;
    rbBdAnWarning: TRadioButton;
    rbBdAnError: TRadioButton;
    Label6: TLabel;
    cbGroupUndoObj: TCheckBox;
    btOK: TBitBtn;
    btCancel: TBitBtn;
    cbAutoMainGrid: TCheckBox;
    lbPages: TListBox;
    Label1: TLabel;
    tsScriptsDec: TTabSheet;
    lbEditorFontSize: TLabel;
    lbTplEditor: TLabel;
    cbScriptToActor: TCheckBox;
    cbCompletionProp: TCheckBox;
    cbGroupUndoTxt: TCheckBox;
    Label49: TLabel;
    Label4: TLabel;
    cbUpperCase: TCheckBox;
    cbIndentTrack: TCheckBox;
    cbIndentLife: TCheckBox;
    rbFirstCompMain: TRadioButton;
    rbFirstComp0: TRadioButton;
    cbAddEndSwitch: TCheckBox;
    tsFrames: TTabSheet;
    gbMainColours: TGroupBox;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label34: TLabel;
    btRestCol: TButton;
    cbNewFrames: TCheckBox;
    rbNewFrEdge: TRadioButton;
    rbNewFrObj: TRadioButton;
    cbShowIndexes: TCheckBox;
    lbZone8: TLabel;
    lbZone7: TLabel;
    lbZone9: TLabel;
    GroupBox1: TGroupBox;
    paNameLBA1: TPanel;
    rbMacro1Org: TRadioButton;
    rbMacro1Eng: TRadioButton;
    Label2: TLabel;
    Panel4: TPanel;
    rbMacro2Org: TRadioButton;
    rbMacro2Eng: TRadioButton;
    Label3: TLabel;
    Label36: TLabel;
    Panel5: TPanel;
    rbCompoOrg: TRadioButton;
    rbCompoEng: TRadioButton;
    Label37: TLabel;
    Label38: TLabel;
    procedure cbMainImgChange(Sender: TObject);
    procedure cbResetClipClick(Sender: TObject);
    procedure btRestColClick(Sender: TObject);
    procedure cbDispBrkClick(Sender: TObject);
    procedure cbUseComp1Click(Sender: TObject);
    procedure cbNewFramesClick(Sender: TObject);
    procedure cbAutoHLErrorClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbPagesClick(Sender: TObject);
  private
  public
    peLba1: array[1..3] of TPathEdit;
    peLba2: array[1..3] of TPathEdit;
    peTplEditor: TPathEdit;
    seScrFontSize: TfrBetterSpin;
    cbScZone: array[TZoneType] of TdfsColorButton;
    cbMainImg: TdfsColorButton;
    cbPanel: TdfsColorButton;
    cbHelper: TdfsColorButton;
    cbInvBrk: TdfsColorButton;
    cbCursor: TdfsColorButton;
    cbWinNet: TdfsColorButton;
    cbPlaced: TdfsColorButton;
    cbSelect: TdfsColorButton;
    cbShapes: TdfsColorButton;
    procedure ShowSettings(page: TTabSheet);
    procedure LoadSettings();
    procedure SaveSettings();
  end;

  TSaveCompMode = (cmUseOrg, cmForce1, cmForce2, cmAsk);
  TCorner = (crTopLeft, crTopRight, crBtmRight, crBtmLeft);

const
  Lba1_GRI    = 'lba_gri.hqr';
  Lba1_BLL    = 'lba_bll.hqr';
  Lba1_BRK    = 'lba_brk.hqr';
  Lba2_BKG    = 'lba_bkg.hqr';
  Lba_SCENE   = 'scene.hqr';
  Lba_RESS    = 'ress.hqr';
  Lba_FILE3D  = 'file3d.hqr';
  Lba_SPRITES = 'sprites.hqr';
  Lba_TEXT    = 'text.hqr';
  Lba_SAMPLES = 'samples.hqr'; //For this file and below we don't load the contents,
  Lba_BODY    = 'body.hqr';    //but only read info (.hqd) about them
  Lba_ANIM    = 'anim.hqr';
  Lba_INVOBJ  = 'invobj.hqr';

  MaxRecentScenarios = 10;

var
  fmSettings: TfmSettings;

  NoProgress: Boolean = False;

  BrkEx: Boolean = False;
  BllEx: Boolean = False;
  GriEx: Boolean = False;
  BkgEx: Boolean = False;
  Sc1Ex: Boolean = False;
  Sc2Ex: Boolean = False;

  Sett: record
    //Controls group keeps info about main window control states
    // They may, but not have to, be stored in the ini file
    Controls: record        //G prefix means Grid Mode, S - SceneMode
      MaxLayerEna: Boolean; //No prefix => common for both modes
      MaxLayer: Integer;
      Coords, Frames, Net, Invisi, Physical: Boolean;
      SObjAutoFind: Boolean;
      Hints: Boolean;
      GPlacedFr, GLayoutFr: Boolean;
      GCursor: Boolean;
      GHelper, GHelp3D: Boolean;
      GSelMode: (smBrick, smColumn, smObject);
      GSelNTrans: Boolean;
      GPlaceLayer: Integer;
      GInvModeBrk: Boolean;
      GClippingMin, GClippingAdv: Boolean;
      GClippingPos: TCorner;
      SObjEdPos: TCorner;
      GLtAlwaysOn: Boolean;
      GLastLtPos: Integer;
      SLastOiPos: Integer;
    end;
    //Opening: record //TODO: Open dialogs' recent values
    General: record
      UseComp1, UseComp2: Boolean;
      CompMode1, CompMode2: TSaveCompMode;
      ResetClip: Boolean;
      AskDelLayer: Boolean;
      FirstIndex1: Boolean;
      ShowIndexes: Boolean;
      SingleInvPlacing: Boolean;
      SaveSuperCompat: Boolean;
      AutoMainGrid: Boolean;
      LastExpDir, LastSaveDir, LastScenarioDir: String;
      RecentScenarios: array[0..MaxRecentScenarios-1] of String;
    end;
    OpenDlg: record
      GridPath: String;
      GridIndex: Integer;
      GrComboIndex, BlComboIndex, ScComboIndex: Integer;
      GrSimGCIndex, GrSimFCIndex, GrSimGrIndex: Integer;
      GrSimGrPath: String;
    end;
    WorkingDirs: record
      Lba1: array[1..3] of String;
      Current_Lba1: Byte;
      Lba2: array[1..3] of String;
      Current_Lba2: Byte;
    end;
    Frames: record
      NewStyle: Boolean;
      NewStyleEdges: Boolean;
      MainImgCol, WinNetCol, PanelCol, PlacedCol, CursorCol, SelectCol,
      HelperCol, InvBrkCol, ShapesCol: TColor;
    end;
    Mouse: record
      WheelSpeed: Integer;
      WheelAverage: Integer;
      InvertX, InvertY: Boolean;
    end;
    Coords: record
      Cursor, Selection: Boolean;
      BrkInfo, BrkInfoSel: Boolean;
      RangeCon, RangeHide: Boolean;
      SceneCrds, SceneBrk: Boolean;
      SceneClip, SceneSel: Boolean;
    end;
    Scene: record
      SnapToBricks: Boolean;
      ZoneColours: array[TZoneType] of TColor;
      ObjGroupUndo: Boolean;
    end;
    Scripts: record
      ScriptToActor: Boolean; //If selected, Actor shall be updated according to the Script Editor selecttion
      CompletionProp: Boolean; //Auto-show completion proposal when pressing space
      TxtGroupUndo: Boolean;
      EdFontSize: Integer; //Script Editor font size
      TemplateEditor: String;
      //Compilation/decompilation settings are in SceneLib.pas
    end;
  end
  = (Controls: (MaxLayerEna: False; Frames: False; Physical: False;
                GPlaceLayer: 0);
     General: (SaveSuperCompat: False));

  ScVisible: record
    Clipping: Boolean;
    Tracks, ActorsSpri, Actors3D: Boolean; //Visible elements
    Zones: set of TZoneType;
  end
  = (Clipping: False; Tracks: True; ActorsSpri: True; Actors3D: True;
     Zones: AllZoneTypes );

Function GetFilePath(name: String; Lba: Byte): String;
Function CheckFile(name: String; Lba: Byte): Boolean;
function RadioToIndex(Form: TForm; NameMask: String; Min, Max: Integer): Integer;
procedure UpdateColourSettings();
procedure UpdateColourControls();

implementation

uses Open, Main, Rendering, OpenSim, Clipping, Grids, Scene, SceneObj, SceneLib,
     ScriptEd, Utils, Maps, Globals, Scenario;

const ZoneDefaultColours: array[TZoneType] of TColor =
  (8716164, 33023, 15712159, 16711935, 7143423, 255, 16733525, //Common
   12572607, 7715583, clGreen);                                //LBA2

{$R *.dfm}

procedure TfmSettings.FormCreate(Sender: TObject);
const PaletteColours: array[0..4*5-1] of TColor =
  (16777215, 255, 65280, 16711680, 12572607, 0, 127, 32512, 8323072,
   15712159, 12566463, 65535, 16776960, 16711935, 7715583, 8355711,
   33023, 8355584, 8323199, 22446);
var a, b: Integer;
    zt: TZoneType;
begin
 for a:= 0 to 2 do begin
   peLba1[a+1]:= TPathEdit.Create(Self);
   peLba1[a+1].Parent:= gbPaths1;
   peLba1[a+1].SetBounds(110, 20 + a*21, 330, 21);
   peLba1[a+1].ButtonKind:= bkText;
   peLba1[a+1].ButtonText:= '...';
   peLba1[a+1].FileFilterIndex:= 1;
   peLba1[a+1].ParentFont:= False;
   peLba1[a+1].Edit.Font.Style:= [];
   peLba1[a+1].Button.Font.Style:= [];

   peLba2[a+1]:= TPathEdit.Create(Self);
   peLba2[a+1].Parent:= gbPaths2;
   peLba2[a+1].SetBounds(110, 20 + a*21, 330, 21);
   peLba2[a+1].ButtonKind:= bkText;
   peLba2[a+1].ButtonText:= '...';
   peLba2[a+1].FileFilterIndex:= 1;
   peLba2[a+1].ParentFont:= False;
   peLba2[a+1].Edit.Font.Style:= [];
   peLba2[a+1].Button.Font.Style:= [];
 end;

 peTplEditor:= TPathEdit.Create(Self);
 peTplEditor.Parent:= tsScriptsGen;
 peTplEditor.SetBounds(lbTplEditor.Left, lbTplEditor.Top + lbTplEditor.Height + 3, 430, 24);
 peTplEditor.EditStyle:= esButtonOnly;
 peTplEditor.PathKind:= pkFile;
 peTplEditor.ButtonText:= '...';
 peTplEditor.IncPathDelimiter:= False;
 peTplEditor.FileFilter:= 'Programs (*.exe, *.bat)|*.exe;*.bat';
 peTplEditor.FileFilterIndex:= 1;

 seScrFontSize:= TfrBetterSpin.Create(Self);
 seScrFontSize.Name:= 'seScrFontSize';
 seScrFontSize.Parent:= tsScriptsGen;
 seScrFontSize.SetBounds(lbEditorFontSize.Left + lbEditorFontSize.Width + 5,
                         lbEditorFontSize.Top - 3, 57, 22);
 seScrFontSize.Setup(1, 50, 1);

 for zt in [ztCube..ztRail] do begin
   a:= Byte(zt);
   cbScZone[zt]:= TdfsColorButton.Create(Self);
   cbScZone[zt].Parent:= gbZoneColours;
   cbScZone[zt].SetBounds(124 + (a div 7)*160, 16 + (a mod 7)*24, 45, 22);
   cbScZone[zt].ShowColorHints:= False;
   cbScZone[zt].OtherBtnCaption:= '&Other';
   cbScZone[zt].OtherColor:= clBtnFace;
   cbScZone[zt].CycleColors:= True;
   cbScZone[zt].PaletteColors.XSize:= 4;
   cbScZone[zt].PaletteColors.YSize:= 5;
   for b:= 1 to 4 * 5 do
     cbScZone[zt].PaletteColors.Colors[b]:= PaletteColours[b - 1];
   cbScZone[zt].CustomColors.XSize:= 8;
   cbScZone[zt].CustomColors.YSize:= 2;
   for b:= 1 to 8 * 2 do
     cbScZone[zt].CustomColors.Colors[b]:= clWhite;
   cbScZone[zt].OnColorChange:= cbMainImgChange;
 end;

 cbMainImg:= TdfsColorButton.Create(Self);
 cbMainImg.Parent:= gbMainColours;
 cbMainImg.SetBounds(164, 12, 45, 22);
 cbMainImg.ShowColorHints:= False;
 cbMainImg.OtherBtnCaption:= '&Other';
 cbMainImg.OtherColor:= clBtnFace;
 cbMainImg.CycleColors:= True;
 cbMainImg.PaletteColors.Assign(cbScZone[ztCube].PaletteColors);
 cbMainImg.CustomColors.Assign(cbScZone[ztCube].CustomColors);
 cbMainImg.OnColorChange:= cbMainImgChange;

 cbWinNet:= TdfsColorButton.Create(Self);
 cbWinNet.Parent:= gbMainColours;
 cbWinNet.SetBounds(164, 36, 45, 22);
 cbWinNet.ShowColorHints:= False;
 cbWinNet.OtherBtnCaption:= '&Other';
 cbWinNet.OtherColor:= clBtnFace;
 cbWinNet.CycleColors:= True;
 cbWinNet.PaletteColors.Assign(cbScZone[ztCube].PaletteColors);
 cbWinNet.CustomColors.Assign(cbScZone[ztCube].CustomColors);
 cbWinNet.OnColorChange:= cbMainImgChange;

 cbPanel:= TdfsColorButton.Create(Self);
 cbPanel.Parent:= gbMainColours;
 cbPanel.SetBounds(164, 60, 45, 22);
 cbPanel.ShowColorHints:= False;
 cbPanel.OtherBtnCaption:= '&Other';
 cbPanel.OtherColor:= clBtnFace;
 cbPanel.CycleColors:= True;
 cbPanel.PaletteColors.Assign(cbScZone[ztCube].PaletteColors);
 cbPanel.CustomColors.Assign(cbScZone[ztCube].CustomColors);
 cbPanel.OnColorChange:= cbMainImgChange;

 cbPlaced:= TdfsColorButton.Create(Self);
 cbPlaced.Parent:= gbMainColours;
 cbPlaced.SetBounds(164, 84, 45, 22);
 cbPlaced.ShowColorHints:= False;
 cbPlaced.OtherBtnCaption:= '&Other';
 cbPlaced.OtherColor:= clBtnFace;
 cbPlaced.CycleColors:= True;
 cbPlaced.PaletteColors.Assign(cbScZone[ztCube].PaletteColors);
 cbPlaced.CustomColors.Assign(cbScZone[ztCube].CustomColors);
 cbPlaced.OnColorChange:= cbMainImgChange;

 cbInvBrk:= TdfsColorButton.Create(Self);
 cbInvBrk.Parent:= gbMainColours;
 cbInvBrk.SetBounds(164, 108, 45, 22);
 cbInvBrk.ShowColorHints:= False;
 cbInvBrk.OtherBtnCaption:= '&Other';
 cbInvBrk.OtherColor:= clBtnFace;
 cbInvBrk.CycleColors:= True;
 cbInvBrk.PaletteColors.Assign(cbScZone[ztCube].PaletteColors);
 cbInvBrk.CustomColors.Assign(cbScZone[ztCube].CustomColors);
 cbInvBrk.OnColorChange:= cbMainImgChange;

 cbShapes:= TdfsColorButton.Create(Self);
 cbShapes.Parent:= gbMainColours;
 cbShapes.SetBounds(164, 132, 45, 22);
 cbShapes.ShowColorHints:= False;
 cbShapes.OtherBtnCaption:= '&Other';
 cbShapes.OtherColor:= clBtnFace;
 cbShapes.CycleColors:= True;
 cbShapes.PaletteColors.Assign(cbScZone[ztCube].PaletteColors);
 cbShapes.CustomColors.Assign(cbScZone[ztCube].CustomColors);
 cbShapes.OnColorChange:= cbMainImgChange;

 cbSelect:= TdfsColorButton.Create(Self);
 cbSelect.Parent:= gbMainColours;
 cbSelect.SetBounds(164, 156, 45, 22);
 cbSelect.ShowColorHints:= False;
 cbSelect.OtherBtnCaption:= '&Other';
 cbSelect.OtherColor:= clBtnFace;
 cbSelect.CycleColors:= True;
 cbSelect.PaletteColors.Assign(cbScZone[ztCube].PaletteColors);
 cbSelect.CustomColors.Assign(cbScZone[ztCube].CustomColors);
 cbSelect.OnColorChange:= cbMainImgChange;

 cbCursor:= TdfsColorButton.Create(Self);
 cbCursor.Parent:= gbMainColours;
 cbCursor.SetBounds(164, 180, 45, 22);
 cbCursor.ShowColorHints:= False;
 cbCursor.OtherBtnCaption:= '&Other';
 cbCursor.OtherColor:= clBtnFace;
 cbCursor.CycleColors:= True;
 cbCursor.PaletteColors.Assign(cbScZone[ztCube].PaletteColors);
 cbCursor.CustomColors.Assign(cbScZone[ztCube].CustomColors);
 cbCursor.OnColorChange:= cbMainImgChange;

 cbHelper:= TdfsColorButton.Create(Self);
 cbHelper.Parent:= gbMainColours;
 cbHelper.SetBounds(164, 204, 45, 22);
 cbHelper.ShowColorHints:= False;
 cbHelper.OtherBtnCaption:= '&Other';
 cbHelper.OtherColor:= clBtnFace;
 cbHelper.CycleColors:= True;
 cbHelper.PaletteColors.Assign(cbScZone[ztCube].PaletteColors);
 cbHelper.CustomColors.Assign(cbScZone[ztCube].CustomColors);
 cbHelper.OnColorChange:= cbMainImgChange;

 lbPages.ItemIndex:= 0;
 pcSettings.ActivePageIndex:= 0;
end;

procedure TfmSettings.lbPagesClick(Sender: TObject);
begin
  case lbPages.ItemIndex of
    0: pcSettings.ActivePage:= tsGeneral;
    1: pcSettings.ActivePage:= tsPaths;
    2: pcSettings.ActivePage:= tsFrames;
    3: pcSettings.ActivePage:= tsMouse;
    4: pcSettings.ActivePage:= tsCoords;
    5: pcSettings.ActivePage:= tsScene;
    6: pcSettings.ActivePage:= tsScriptsGen;
    7: pcSettings.ActivePage:= tsScriptsDec;
    8: pcSettings.ActivePage:= tsScriptsCom;
  end;  
end;

Procedure CheckFilesExist();
begin
 BrkEx:= CheckFile(Lba1_BRK, 1);
 BllEx:= CheckFile(Lba1_BLL, 1);
 GriEx:= CheckFile(Lba1_GRI, 1);
 BkgEx:= CheckFile(Lba2_BKG, 2);
 Sc1Ex:= CheckFile(Lba_SCENE, 1);
 Sc2Ex:= CheckFile(Lba_SCENE, 2);
end;

Function GetFilePath(name: String; Lba: Byte): String;
begin
 If Lba = 1 then
   Result:= Sett.WorkingDirs.Lba1[Sett.WorkingDirs.Current_Lba1] + name
 else
   Result:= Sett.WorkingDirs.Lba2[Sett.WorkingDirs.Current_Lba2] + name;
end;

Function CheckFile(name: String; Lba: Byte): Boolean;
begin
 Result:= FileExists(GetFilePath(name, Lba));
end;

Procedure TfmSettings.ShowSettings(page: TTabSheet);
var a: Integer;
    zt: TZoneType;
begin
 if page <> nil then begin
   pcSettings.ActivePage:= page;
   lbPages.ItemIndex:= pcSettings.ActivePageIndex;
 end;  

 //General
 cbUseComp1.Checked:= Sett.General.UseComp1;
 cbUseComp2.Checked:= Sett.General.UseComp2;
 cbUseComp1Click(self);
 case Sett.General.CompMode1 of
   cmForce1: rbCm1Force1.Checked:= True;
   cmAsk: rbCm1Ask.Checked:= True;
   else rbCm1UseOrg.Checked:= True;
 end;
 case Sett.General.CompMode2 of
   cmForce1: rbCm2Force1.Checked:= True;
   cmForce2: rbCm2Force2.Checked:= True;
   cmAsk: rbCm2Ask.Checked:= True;
   else rbCm2UseOrg.Checked:= True;
 end;
 cbResetClip.Checked:= Sett.General.ResetClip;
 cbAskDelLayer.Checked:= Sett.General.AskDelLayer;
 cbShowIndexes.Checked:= Sett.General.ShowIndexes;
 cbFirstIndex1.Checked:= Sett.General.FirstIndex1;
 cbSingleInvPlacing.Checked:= Sett.General.SingleInvPlacing;
 cbAutoMainGrid.Checked:= Sett.General.AutoMainGrid;
 //cbSaveSuperCompat.Checked:= Sett.General.SaveSuperCompat;

 //Working Dirs
 for a:= 1 to 3 do begin
   peLba1[a].Path:= Sett.WorkingDirs.Lba1[a];
   peLba2[a].Path:= Sett.WorkingDirs.Lba2[a];
 end;
      If Sett.WorkingDirs.Current_Lba1 = 3 then rbDir13.Checked:= True
 else if Sett.WorkingDirs.Current_Lba1 = 2 then rbDir12.Checked:= True
                                               else rbDir11.Checked:= True;
      If Sett.WorkingDirs.Current_Lba2 = 3 then rbDir23.Checked:= True
 else if Sett.WorkingDirs.Current_Lba2 = 2 then rbDir22.Checked:= True
                                           else rbDir21.Checked:= True;

 //Frames
 cbNewFrames.Checked:= Sett.Frames.NewStyle;
 If Sett.Frames.NewStyleEdges then rbNewFrEdge.Checked:= True
                              else rbNewFrObj.Checked:= True;
 cbMainImg.Color:= Sett.Frames.MainImgCol;
 cbWinNet.Color:=  Sett.Frames.WinNetCol;
 cbPanel.Color:=   Sett.Frames.PanelCol;
 cbPlaced.Color:=  Sett.Frames.PlacedCol;
 cbCursor.Color:=  Sett.Frames.CursorCol;
 cbSelect.Color:=  Sett.Frames.SelectCol;
 cbHelper.Color:=  Sett.Frames.HelperCol;
 cbInvBrk.Color:=  Sett.Frames.InvBrkCol;
 cbShapes.Color:=  Sett.Frames.ShapesCol;

 //Mouse
 eWSpeed.Text:= IntToStr(Sett.Mouse.WheelSpeed);
 eWAverage.Text:= IntToStr(Sett.Mouse.WheelAverage);
 cbWInvX.Checked:= Sett.Mouse.InvertX;
 cbWInvY.Checked:= Sett.Mouse.InvertY;

 //Coordinates
 cbDispCur.Checked:= Sett.Coords.Cursor;
 cbDispSel.Checked:= Sett.Coords.Selection;
 cbDispBrk.Checked:= Sett.Coords.BrkInfo;
 if Sett.Coords.BrkInfoSel then rbSelected.Checked:= True
                           else rbAtCursor.Checked:= True;
 if Sett.Coords.RangeCon then rbRangeCon.Checked:= True
                         else rbRangeSep.Checked:= True;
 cbRangeHide.Checked:= Sett.Coords.RangeHide;
 cbScenePix.Checked:= Sett.Coords.SceneCrds;
 cbSceneBrk.Checked:= Sett.Coords.SceneBrk;
 cbSceneClip.Checked:= Sett.Coords.SceneClip;
 cbSceneSel.Checked:= Sett.Coords.SceneSel;

 //Scene
 cbSceneSnap.Checked:= Sett.Scene.SnapToBricks;
 for zt in [ztCube..ztRail] do
   cbScZone[zt].Color:= Sett.Scene.ZoneColours[zt];

 //Scripts - general
 cbScriptToActor.Checked:= Sett.Scripts.ScriptToActor;
 cbCompletionProp.Checked:= Sett.Scripts.CompletionProp;
 cbGroupUndoTxt.Checked:= Sett.Scripts.TxtGroupUndo;
 seScrFontSize.Value:= Sett.Scripts.EdFontSize;
 peTplEditor.Path:= Sett.Scripts.TemplateEditor;
 //Decompilation
 cbUpperCase.Checked:= ScrSet.Decomp.UpperCase;
 cbIndentTrack.Checked:= ScrSet.Decomp.IndentTrack;
 cbIndentLife.Checked:= ScrSet.Decomp.IndentLife;
 if ScrSet.Decomp.FirstCompMain then rbFirstCompMain.Checked:= True
                                else rbFirstComp0.Checked:= True;
 cbAddEndSwitch.Checked:= ScrSet.Decomp.AddEND_SWITCH;
 if ScrSet.Decomp.Lba1MacroOrg then rbMacro1Org.Checked:= True
                               else rbMacro1Eng.Checked:= True;
 if ScrSet.Decomp.Lba2MacroOrg then rbMacro2Org.Checked:= True
                               else rbMacro2Eng.Checked:= True;
 if ScrSet.Decomp.CompoOrg     then rbCompoOrg.Checked:= True
                               else rbCompoEng.Checked:= True;
 //Compilation
 cbNotStrictSyntax.Checked:= not ScrSet.Comp.StrictSyntax;
 cbRequireENDs.Checked:= ScrSet.Comp.RequireENDs;
 cbAutoHLError.Checked:= ScrSet.Comp.AutoHLError;
 cbAutoHLVisOnly.Checked:= not ScrSet.Comp.AutoHLAlways;
 cbAutoHLErrorClick(cbAutoHLError);
 cbLabelWarnings.Checked:= ScrSet.Comp.LabelWarnings;
 cbLbUnusedWarns.Checked:= ScrSet.Comp.LbUnusedWarns;
 cbCompUnusedWarns.Checked:= ScrSet.Comp.CompUnusedWarns;
 cbCheckZones.Checked:= ScrSet.Comp.CheckZones;
 cbCheckSuit.Checked:= ScrSet.Comp.CheckSuit;
 If ScrSet.Comp.CheckTracks then
   If ScrSet.Comp.TrackErrors then rbTrackError.Checked:= True
                              else rbTrackWarning.Checked:= True
 else rbTrackNothing.Checked:= True;
 If ScrSet.Comp.CheckActors then
   If ScrSet.Comp.ActorErrors then rbActorError.Checked:= True
                              else rbActorWarning.Checked:= True
 else rbActorNothing.Checked:= True;
 If ScrSet.Comp.CheckBdAn then
   If ScrSet.Comp.BdAnErrors then rbBdAnError.Checked:= True
                             else rbBdAnWarning.Checked:= True
 else rbBdAnNothing.Checked:= True;

//######################################
 if ShowModal() = mrOK then begin
//######################################
   //General
   Sett.General.UseComp1:= cbUseComp1.Checked;
   Sett.General.UseComp2:= cbUseComp2.Checked;
        if rbCm1Force1.Checked then Sett.General.CompMode1:= cmForce1
   else if rbCm1Ask.Checked then Sett.General.CompMode1:= cmAsk
   else Sett.General.CompMode1:= cmUseOrg;
        if rbCm2Force1.Checked then Sett.General.CompMode2:= cmForce1
   else if rbCm2Force2.Checked then Sett.General.CompMode2:= cmForce2
   else if rbCm2Ask.Checked then Sett.General.CompMode2:= cmAsk
   else Sett.General.CompMode2:= cmUseOrg;
   Sett.General.ResetClip:= cbResetClip.Checked;
   fmMain.frLtClip.btReset.Down:= Sett.General.ResetClip;
   Sett.General.AskDelLayer:= cbAskDelLayer.Checked;
   Sett.General.ShowIndexes:= cbShowIndexes.Checked;
   Sett.General.FirstIndex1:= cbFirstIndex1.Checked;
   Sett.General.SingleInvPlacing:= cbSingleInvPlacing.Checked;
   //Sett.General.SaveSuperCompat:= cbSaveSuperCompat.Checked;
   Sett.General.AutoMainGrid:= cbAutoMainGrid.Checked;

   //Working Dirs
   for a:= 1 to 3 do begin
     Sett.WorkingDirs.Lba1[a]:= peLba1[a].Path;
     Sett.WorkingDirs.Lba2[a]:= peLba2[a].Path;
   end;  
   Sett.WorkingDirs.Current_Lba1:= IfThen(rbDir13.Checked, 3,
                                         IfThen(rbDir12.Checked, 2, 1));
   Sett.WorkingDirs.Current_Lba2:= IfThen(rbDir23.Checked, 3,
                                   IfThen(rbDir22.Checked, 2, 1));

   //Frames
   Sett.Frames.NewStyle:= cbNewFrames.Checked;
   Sett.Frames.NewStyleEdges:= rbNewFrEdge.Checked;
   Sett.Frames.MainImgCol:= cbMainImg.Color;
   Sett.Frames.WinNetCol:= cbWinNet.Color;
   Sett.Frames.PanelCol:= cbPanel.Color;
   Sett.Frames.PlacedCol:= cbPlaced.Color;
   Sett.Frames.CursorCol:= cbCursor.Color;
   Sett.Frames.SelectCol:= cbSelect.Color;
   Sett.Frames.HelperCol:= cbHelper.Color;
   Sett.Frames.InvBrkCol:= cbInvBrk.Color;
   Sett.Frames.ShapesCol:= cbShapes.Color;
   UpdateColourSettings();

   //Mouse
   Sett.Mouse.WheelSpeed:= StrToIntDef(eWSpeed.Text, 20);
   Sett.Mouse.WheelAverage:= StrToIntDef(eWAverage.Text, 180);
   Sett.Mouse.InvertX:= cbWInvX.Checked;
   Sett.Mouse.InvertY:= cbWInvY.Checked;

   //Coordinates
   Sett.Coords.Cursor:= cbDispCur.Checked;
   Sett.Coords.Selection:= cbDispSel.Checked;
   Sett.Coords.BrkInfo:= cbDispBrk.Checked;
   Sett.Coords.BrkInfoSel:= rbSelected.Checked;
   Sett.Coords.RangeCon:= rbRangeCon.Checked;
   Sett.Coords.RangeHide:= cbRangeHide.Checked;
   Sett.Coords.SceneCrds:= cbScenePix.Checked;
   Sett.Coords.SceneBrk:= cbSceneBrk.Checked;
   Sett.Coords.SceneClip:= cbSceneClip.Checked;
   Sett.Coords.SceneSel:= cbSceneSel.Checked;
   //Nie dzia³a Place (jest zawsze widoczne)

   //Scene:
   cbSceneSnap.Checked:= Sett.Scene.SnapToBricks;
   for zt in AllZoneTypes do 
     Sett.Scene.ZoneColours[zt]:= cbScZone[zt].Color;
   UpdateColourControls();

   //Scripts
   Sett.Scripts.ScriptToActor:= cbScriptToActor.Checked;
   Sett.Scripts.CompletionProp:= cbCompletionProp.Checked;
   Sett.Scripts.TxtGroupUndo:= cbGroupUndoTxt.Checked;
   Sett.Scripts.EdFontSize:= seScrFontSize.Value;
   fmScriptEd.SetEditorsOptions(Sett.Scripts.EdFontSize);
   Sett.Scripts.TemplateEditor:= peTplEditor.Path;
   //Decompilation
   ScrSet.Decomp.UpperCase:= cbUpperCase.Checked;
   fmScriptEd.SetupAutoCompLists();
   ScrSet.Decomp.IndentTrack:= cbIndentTrack.Checked;
   ScrSet.Decomp.IndentLife:= cbIndentLife.Checked;
   ScrSet.Decomp.FirstCompMain:= rbFirstCompMain.Checked;
   ScrSet.Decomp.AddEND_SWITCH:= cbAddEndSwitch.Checked;
   ScrSet.Decomp.Lba1MacroOrg:= rbMacro1Org.Checked;
   ScrSet.Decomp.Lba2MacroOrg:= rbMacro2Org.Checked;
   ScrSet.Decomp.CompoOrg:=     rbCompoOrg.Checked;
   //Compilation
   ScrSet.Comp.StrictSyntax:= not cbNotStrictSyntax.Checked;
   ScrSet.Comp.RequireENDs:= cbRequireENDs.Checked;
   ScrSet.Comp.LabelWarnings:= cbLabelWarnings.Checked;
   ScrSet.Comp.LbUnusedWarns:= cbLbUnusedWarns.Checked;
   ScrSet.Comp.CompUnusedWarns:= cbCompUnusedWarns.Checked;
   ScrSet.Comp.AutoHLError:= cbAutoHLError.Checked;
   ScrSet.Comp.AutoHLAlways:= not cbAutoHLVisOnly.Checked;
   ScrSet.Comp.CheckZones:= cbCheckZones.Checked;
   ScrSet.Comp.CheckSuit:= cbCheckSuit.Checked;
   ScrSet.Comp.CheckTracks:= not rbTrackNothing.Checked;
   ScrSet.Comp.TrackErrors:= rbTrackError.Checked;
   ScrSet.Comp.CheckActors:= not rbActorNothing.Checked;
   ScrSet.Comp.ActorErrors:= rbActorError.Checked;
   ScrSet.Comp.CheckBdAn:= not rbBdAnNothing.Checked;
   ScrSet.Comp.BdAnErrors:= rbBdAnError.Checked;

   LoadGriToBllTables();
   fmOpen.cbGriIndex.Tag:= 0; //force combos reload
   fmOpen.cbLibIndex.Tag:= 0;
   fmOpen.cbScnIndex.Tag:= 0;
   fmOpenSim.cbSimGrid.Tag:= 0;
   CheckFilesExist();
   PaintLayouts();

   SaveSettings();
 end;  
end;

procedure UpdateColourSettings();
var zt: TZoneType;
begin
 Sett.Frames.MainImgCol:= fmSettings.cbMainImg.Color;
 Sett.Frames.WinNetCol:=  fmSettings.cbWinNet.Color;
 Sett.Frames.PanelCol:=   fmSettings.cbPanel.Color;
 Sett.Frames.PlacedCol:=  fmSettings.cbPlaced.Color;
 Sett.Frames.CursorCol:=  fmSettings.cbCursor.Color;
 Sett.Frames.SelectCol:=  fmSettings.cbSelect.Color;
 Sett.Frames.HelperCol:=  fmSettings.cbHelper.Color;
 Sett.Frames.InvBrkCol:=  fmSettings.cbInvBrk.Color;
 Sett.Frames.ShapesCol:=  fmSettings.cbShapes.Color;
 for zt in AllZoneTypes do
   Sett.Scene.ZoneColours[zt]:= fmSettings.cbScZone[zt].Color;
end;

procedure UpdateColourControls();
begin
 MakeZoneSelectionIcons();
end;

function RadioToIndex(Form: TForm; NameMask: String; Min, Max: Integer): Integer;
var a: Integer;
begin
 Result:= -1;
 for a:= Min to Max do
   If (Form.FindComponent(Format(NameMask,[a])) as TRadioButton).Checked then begin
     Result:= a;
     Exit;
   end;
end;

Procedure IndexToRadio(Form: TForm; NameMask: String; Index: Integer);
begin
 If Index>-1 then
  (Form.FindComponent(Format(NameMask,[Index])) as TRadioButton).Checked:=True;
end;

Function CheckInt(val, min, max: Integer): Integer;
begin
      If val < min then Result:= min
 else if val > max then Result:= max
                   else Result:= val
end;

procedure TfmSettings.LoadSettings();
var f: TIniFile;
    a: Integer;
    AppPath: String;
    zt: TZoneType;
begin
 AppPath:= ExtractFilePath(Application.ExeName);
 f:= TIniFile.Create(AppPath + 'Builder.ini');

 //Controls
 Sett.Controls.Net:= f.ReadBool('Controls', 'Net', True);
 Sett.Controls.Coords:= f.ReadBool('Controls', 'Coords', True);
 Sett.Controls.Invisi:= f.ReadBool('Controls', 'Invisi', False);
 Sett.Controls.GPlacedFr:= f.ReadBool('Controls', 'GPlacedFr', False);
 Sett.Controls.GCursor:= f.ReadBool('Controls', 'GCursor', True);
 Sett.Controls.GHelper:= f.ReadBool('Controls', 'GHelper', True);
 Sett.Controls.GHelp3D:= f.ReadBool('Controls', 'GHelp3D', False);
 fmMain.btFrames_Click(nil);
 Sett.Controls.Hints:= f.ReadBool('Controls', 'Hints', True);
 fmMain.aHintsExecute(nil);
 Sett.Controls.MaxLayer:= f.ReadInteger('Controls', 'MaxLayer', 0);
 fmMain.btMaxLayer_Click(nil);
 case f.ReadInteger('Controls', 'GSelMode', 0) of
   0: Sett.Controls.GSelMode:= smBrick;
   1: Sett.Controls.GSelMode:= smColumn;
   else Sett.Controls.GSelMode:= smObject;
 end;
 Sett.Controls.GSelNTrans:= f.ReadBool('Controls', 'GSelNTrans', True);
 Sett.Controls.GLayoutFr:= f.ReadBool('Controls', 'GLayoutFr', False);
 fmMain.cbFramesLtClick(nil);
 Sett.Controls.GInvModeBrk:= f.ReadBool('Controls', 'GInvModeBrk', True);
 Sett.Controls.GLtAlwaysOn:= f.ReadBool('Controls', 'GLtAlwaysOn', False);
 Sett.Controls.GLastLtPos:= f.ReadInteger('Controls', 'GLastLtPos', 100);
 if Sett.Controls.GLtAlwaysOn then begin
   fmMain.paLeftSide.Width:= Sett.Controls.GLastLtPos;
   fmMain.pbLts.Width:= fmMain.paLayout.Width - fmMain.LScr.Width - 4;
 end;

 Sett.Controls.GClippingMin:= f.ReadBool('Controls', 'GClippingMin', False);
 Sett.Controls.GClippingAdv:= f.ReadBool('Controls', 'GClippingAdv', False);
 fmMain.frLtClip.btMinClick(nil); //Update panel visibility
 Sett.Controls.GClippingPos:= TCorner(f.ReadInteger('Controls', 'GClippingPos', 1));
 fmMain.frLtClip.btPosTRClick(nil);
 Sett.Controls.SObjAutoFind:= f.ReadBool('Controls', 'SObjAutoFind', True);
 Sett.Controls.SLastOiPos:= f.ReadInteger('Controls', 'SLastOiPos', 150);

 //Working Dirs
 Sett.WorkingDirs.Lba1[1]:=      f.ReadString('WorkingDirs','Lba1_1','');
 Sett.WorkingDirs.Lba1[2]:=      f.ReadString('WorkingDirs','Lba1_2','');
 Sett.WorkingDirs.Lba1[3]:=      f.ReadString('WorkingDirs','Lba1_3','');
 Sett.WorkingDirs.Current_Lba1:=
   CheckInt(f.ReadInteger('WorkingDirs','Lba1_Current',1), 1, 3);
 Sett.WorkingDirs.Lba2[1]:=      f.ReadString('WorkingDirs','Lba2_1','');
 Sett.WorkingDirs.Lba2[2]:=      f.ReadString('WorkingDirs','Lba2_2','');
 Sett.WorkingDirs.Lba2[3]:=      f.ReadString('WorkingDirs','Lba2_3','');
 Sett.WorkingDirs.Current_Lba2:=
   CheckInt(f.ReadInteger('WorkingDirs','Lba2_Current',1), 1, 3);

 //Opening
 CheckFilesExist();
 if f.ReadInteger('Open', 'LbaVersion', 1) = 2 then fmOpen.rbLba2.Checked:= True
                                               else fmOpen.rbLba1.Checked:= True;
 if f.ReadBool('Open', 'BrkOrigin', True) then fmOpen.rbBrkOrigin.Checked:= True
                                          else fmOpen.rbBrkCustom.Checked:= True;
 if f.ReadBool('Open', 'LibOrigin', True) then fmOpen.rbLibOrigin.Checked:= True
                                          else fmOpen.rbLibCustom.Checked:= True;
 case f.ReadInteger('Open', 'GriMode', 0) of
   1: fmOpen.rbGriCustom.Checked:= True;
   2: fmOpen.rbGriNew.Checked:= True;
   else fmOpen.rbGriOrigin.Checked:= True;
 end;
 case f.ReadInteger('Open', 'ScnMode', 0) of
   1: fmOpen.rbScnCustom.Checked:= True;
   2: fmOpen.rbScnNew.Checked:= True;
   else fmOpen.rbScnOrigin.Checked:= True;
 end;
 if f.ReadBool('Open', 'PalOrigin', True) then fmOpen.rbPalOrigin.Checked:= True
                                          else fmOpen.rbPalCustom.Checked:= True;
 Sett.OpenDlg.BlComboIndex:= f.ReadInteger('Open','Layout',-1);
 Sett.OpenDlg.GrComboIndex:= f.ReadInteger('Open','Grid',-1);
 Sett.OpenDlg.ScComboIndex:= f.ReadInteger('Open','Scene',-1);
 fmOpen.ShowControls(); //CheckEnabled();
 fmOpen.stBrkPath.Caption:= f.ReadString( 'Open','BrkPath', '');
 fmOpen.stPalPath.Caption:= f.ReadString( 'Open','PalPath', '');
 LibPath:=               f.ReadString( 'Open','BllPath', '');
 LibIndex:=              f.ReadInteger('Open','BllIndex',0);
 fmOpen.stLibPath.Caption:= FormatPath(LibPath, LibIndex);
 Sett.OpenDlg.GridPath:=  f.ReadString( 'Open','GriPath', '');
 Sett.OpenDlg.GridIndex:= f.ReadInteger('Open','GriIndex', 0);
 ScenePath:=  f.ReadString( 'Open','ScePath', '');
 SceneIndex:= f.ReadInteger('Open','SceIndex', 0);
 fmOpen.cbAutoLib.Checked:= f.ReadBool(  'Open','AutoLibrary',     True);
 fmOpen.eLibIndex.Text:=    f.ReadString('Open','NewGridLibIndex', '0');
 fmOpen.eFragIndex.Text:=   f.ReadString('Open','NewGrigFragIndex','0');
 If f.ReadBool('Open','SceneMode',False) then fmOpen.rbSceneMode.Checked:= True
 else fmOpen.rbGridMode.Checked:= True;
 If f.ReadInteger('OpenSim','CB',1) = 1 then fmOpenSim.rbLba1.Checked:= True
 else fmOpenSim.rbLba2.Checked:= True;
 Sett.OpenDlg.GrSimGCIndex:= f.ReadInteger('OpenSim', 'SimGCIndex', -1);
 Sett.OpenDlg.GrSimFCIndex:= f.ReadInteger('OpenSim', 'SimFCIndex', -1);
 Sett.OpenDlg.GrSimGrIndex:= f.ReadInteger('OpenSim', 'SimGrIndex', -1);
 Sett.OpenDlg.GrSimGrPath:= f.ReadString('OpenSim', 'SimGrPath', '');
 If f.ReadBool('OpenSim','SceneMode',False) then fmOpenSim.rbSceneMode.Checked:= True
 else fmOpenSim.rbGridMode.Checked:= True;

 //General
 Sett.General.UseComp1:= f.ReadBool('Saving', 'UseCompression1', True);
 Sett.General.UseComp2:= f.ReadBool('Saving', 'UseCompression2', True);
 Sett.General.CompMode1:= TSaveCompMode(f.ReadInteger('Saving', 'CompMode1', 0));
 Sett.General.CompMode2:= TSaveCompMode(f.ReadInteger('Saving', 'CompMode2', 0));
 Sett.General.ResetClip:= f.ReadBool('General', 'ResetAfterPlacing', True);
 Sett.General.AskDelLayer:= f.ReadBool('General', 'AskDelLayer', True);
 Sett.General.ShowIndexes:= f.ReadBool('General', 'ShowIndexes', False);
 Sett.General.FirstIndex1:= f.ReadBool('General', 'FirstIndex1', False);
 Sett.General.SingleInvPlacing:= f.ReadBool('General', 'SingleInvPlacing', True);
 //Sett.General.SaveSuperCompat:= f.ReadBool('General', 'SaveSuperCompat', True);
 Sett.General.AutoMainGrid:= f.ReadBool('General', 'AutoMainGrid', True);
 Sett.General.LastExpDir:= f.ReadString('General', 'LastExportDir', AppPath);
 Sett.General.LastSaveDir:= f.ReadString('General', 'LastSaveDir', AppPath);
 Sett.General.LastScenarioDir:= f.ReadString('General', 'LastScenDir', AppPath);
 for a:= 0 to MaxRecentScenarios - 1 do
   Sett.General.RecentScenarios[a]:= f.ReadString('General', 'RecentScenario' + IntToStr(a), '');
 RefreshRecentMenu();

 //Frames
 Sett.Frames.NewStyle:= f.ReadBool('Frames', 'UseNewFrames', True);
 Sett.Frames.NewStyleEdges:= f.ReadBool('Frames', 'NewFramesEdge', False);
 Sett.Frames.MainImgCol:= f.ReadInteger('Frames', 'MainImgCol',   clWhite);
 Sett.Frames.WinNetCol:=  f.ReadInteger('Frames', 'WinNetCol',    clLime);
 Sett.Frames.PanelCol:=   f.ReadInteger('Frames', 'PanelCol',     clWhite);
 Sett.Frames.PlacedCol:=  f.ReadInteger('Frames', 'PlacedCol',    clMoneyGreen);
 Sett.Frames.CursorCol:=  f.ReadInteger('Frames', 'CursorCol',    clSkyBlue);
 Sett.Frames.SelectCol:=  f.ReadInteger('Frames', 'SelectCol',    clFuchsia);
 Sett.Frames.HelperCol:=  f.ReadInteger('Frames', 'HelperCol',    clSkyBlue);
 Sett.Frames.InvBrkCol:=  f.ReadInteger('Frames', 'InvisibleCol', clSilver);
 Sett.Frames.ShapesCol:=  f.ReadInteger('Frames', 'ShapesCol',    clYellow);

 //Mouse
 Sett.Mouse.WheelSpeed:=   f.ReadInteger('Mouse', 'WheelSpeed',   20);
 Sett.Mouse.WheelAverage:= f.ReadInteger('Mouse', 'WheelAverage', 180);
 Sett.Mouse.InvertX:=      f.ReadBool('Mouse', 'InvertX', False);
 Sett.Mouse.InvertY:=      f.ReadBool('Mouse', 'InvertY', False);

 //Coordinates
 Sett.Coords.Cursor:=     f.ReadBool('Coords', 'DispCursor',    True);
 Sett.Coords.Selection:=  f.ReadBool('Coords', 'DispSelection', True);
 Sett.Coords.BrkInfo:=    f.ReadBool('Coords', 'DispBrkInfo',   True);
 Sett.Coords.BrkInfoSel:= f.ReadBool('Coords', 'BrkInfoSelected', False);
 Sett.Coords.RangeCon:=   f.ReadBool('Coords', 'RangeConnected', False);
 Sett.Coords.RangeHide:=  f.ReadBool('Coords', 'RangeHide',     True);
 Sett.Coords.SceneCrds:=  f.ReadBool('Coords', 'SceneCoords',   True);
 Sett.Coords.SceneBrk:=   f.ReadBool('Coords', 'SceneBricks',   False);
 Sett.Coords.SceneClip:=  f.ReadBool('Coords', 'SceneClip',     True);
 Sett.Coords.SceneSel:=   f.ReadBool('Coords', 'SceneSelected', True);
 cbDispBrkClick(self);

 //Scene
 Sett.Scene.SnapToBricks:= f.ReadBool('Scene', 'Snap', True);
 Sett.Scene.ObjGroupUndo:= f.ReadBool('Scene', 'ObjGroupUndo', True);
 for zt in AllZoneTypes do
   Sett.Scene.ZoneColours[zt]:= f.ReadInteger('Scene', 'ZoneCol' + IntToStr(Byte(zt)), ZoneDefaultColours[zt]);
 UpdateColourControls();

 //Scripts - general
 Sett.Scripts.ScriptToActor:= f.ReadBool('ScriptGeneral', 'ScriptToActor', True);
 Sett.Scripts.CompletionProp:= f.ReadBool('ScriptGeneral', 'CompletionProp', True);
 Sett.Scripts.EdFontSize:= f.ReadInteger('ScriptGeneral', 'EditorFontSize', 10);
 Sett.Scripts.TxtGroupUndo:= f.ReadBool('ScriptGeneral', 'TxtGroupUndo', True);
 fmScriptEd.SetEditorsOptions(Sett.Scripts.EdFontSize);
 Sett.Scripts.TemplateEditor:= f.ReadString('ScriptGeneral', 'TemplateEditor', '');
 fmScriptEd.WindowState:= wsNormal;
 a:= f.ReadInteger('ScriptGeneral', 'WindowW', -1);
 if a > 380 then fmScriptEd.Width:= a;
 a:= f.ReadInteger('ScriptGeneral', 'WindowH', -1);
 if a > 70 then fmScriptEd.Height:= a;
 a:= f.ReadInteger('ScriptGeneral', 'WindowX', -999999999);
 if (a >= -fmScriptEd.Width + 30) and (a <= Screen.WorkAreaWidth - 30) then
   fmScriptEd.Left:= a; //protection against positioning off the screen
 a:= f.ReadInteger('ScriptGeneral', 'WindowY', -999999999);
 if (a >= 0) and (a <= Screen.WorkAreaHeight - 20) then
   fmScriptEd.Top:= a;
 if f.ReadBool('ScriptGeneral', 'WindowMax', False) then
   fmScriptEd.WindowState:= wsMaximized;
 //Sett.Scripts.SPHorizPos:= ;
 fmScriptEd.pcBottom.Height:= EnsureRange(f.ReadInteger('ScriptGeneral', 'SPHorizPos', 125),
   10, fmScriptEd.paEditors.ClientHeight - 20);
 fmScriptEd.seLifeScript.Width:= EnsureRange(f.ReadInteger('ScriptGeneral', 'SPVertPos', 280),
   10, fmScriptEd.paEditors.ClientWidth - 20);
 fmScriptEd.scpLifeScript.Width:= f.ReadInteger('ScriptGeneral', 'ScpLifeW', 500);
 fmScriptEd.scpLifeScript.NbLinesInWindow:= f.ReadInteger('ScriptGeneral', 'ScpLifeH', 20);
 fmScriptEd.scpTrackScript.Width:= f.ReadInteger('ScriptGeneral', 'ScpTrackW', 500);
 fmScriptEd.scpTrackScript.NbLinesInWindow:= f.ReadInteger('ScriptGeneral', 'ScpTrackH', 20);
 //Decompilation
 ScrSet.Decomp.UpperCase:= f.ReadBool('ScriptDecomp', 'UpperCase', True);
 //fmScriptEd.SetupAutoCompLists();
 ScrSet.Decomp.IndentTrack:= f.ReadBool('ScriptDecomp', 'IndentTrack', True);
 ScrSet.Decomp.IndentLife:= f.ReadBool('ScriptDecomp', 'IndentLife', True);
 ScrSet.Decomp.FirstCompMain:= f.ReadBool('ScriptDecomp', 'FirstCompMain', True);
 ScrSet.Decomp.AddEND_SWITCH:= f.ReadBool('ScriptDecomp', 'AddEND_SWITCH', False);
 ScrSet.Decomp.Lba1MacroOrg:= f.ReadBool('ScriptDecomp', 'Lba1MacroOrg', False);
 ScrSet.Decomp.Lba2MacroOrg:= f.ReadBool('ScriptDecomp', 'Lba2MacroOrg', False);
 ScrSet.Decomp.CompoOrg:= f.ReadBool('ScriptDecomp', 'CompoOrg', False);
 //Compilation
 ScrSet.Comp.StrictSyntax:= f.ReadBool('ScriptComp', 'StrictSyntax', False);
 ScrSet.Comp.RequireENDs:= f.ReadBool('ScriptComp', 'RequireENDs', True);
 ScrSet.Comp.LabelWarnings:= f.ReadBool('ScriptComp', 'LabelWarnings', True);
 ScrSet.Comp.LbUnusedWarns:= f.ReadBool('ScriptComp', 'LbUnusedWarns', True);
 ScrSet.Comp.CompUnusedWarns:= f.ReadBool('ScriptComp', 'UnusedWarns', True);
 ScrSet.Comp.AutoHLError:= f.ReadBool('ScriptComp', 'AutoHLError', True);
 ScrSet.Comp.AutoHLAlways:= f.ReadBool('ScriptComp', 'AutoHLAlways', False);
 ScrSet.Comp.CheckZones:= f.ReadBool('ScriptComp', 'CheckZones', True);
 ScrSet.Comp.CheckSuit:= f.ReadBool('ScriptComp', 'CheckSuit', True);
 ScrSet.Comp.CheckTracks:= f.ReadBool('ScriptComp', 'CheckTracks', True);
 ScrSet.Comp.TrackErrors:= f.ReadBool('ScriptComp', 'TrackErrors', False);
 ScrSet.Comp.CheckActors:= f.ReadBool('ScriptComp', 'CheckActors', True);
 ScrSet.Comp.ActorErrors:= f.ReadBool('ScriptComp', 'ActorErrors', False);
 ScrSet.Comp.CheckBdAn:= f.ReadBool('ScriptComp', 'CheckBdAn', True);
 ScrSet.Comp.BdAnErrors:= f.ReadBool('ScriptComp', 'BdAnErrors', False);

 fmMain.UpdateButtons();

 f.Free;
end;

procedure TfmSettings.SaveSettings();
var f: TIniFile;
    a: Integer;
    zt: TZoneType;
    wp: TWindowPlacement;
begin
 f:= TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Builder.ini');
 try

   //Controls
   f.WriteBool('Controls', 'Net', Sett.Controls.Net);
   f.WriteBool('Controls', 'Coords', Sett.Controls.Coords);
   f.WriteBool('Controls', 'Invisi', Sett.Controls.Invisi);
   f.WriteBool('Controls', 'GPlacedFr', Sett.Controls.GPlacedFr);
   f.WriteBool('Controls', 'GCursor', Sett.Controls.GCursor);
   f.WriteBool('Controls', 'GHelper', Sett.Controls.GHelper);
   f.WriteBool('Controls', 'GHelp3D', Sett.Controls.GHelp3D);
   f.WriteBool('Controls', 'Hints', Sett.Controls.Hints);
   f.WriteInteger('Controls', 'MaxLayer', Sett.Controls.MaxLayer);
   f.WriteInteger('Controls', 'GSelMode', IfThen(Sett.Controls.GSelMode = smBrick, 0,
      IfThen(Sett.Controls.GSelMode = smColumn, 1, 2)));
   f.WriteBool('Controls', 'GSelNTrans', Sett.Controls.GSelNTrans);
   f.WriteBool('Controls', 'GLayoutFr', Sett.Controls.GLayoutFr);
   f.WriteBool('Controls', 'GInvModeBrk', Sett.Controls.GInvModeBrk);
   f.WriteBool('Controls', 'GLtAlwaysOn', Sett.Controls.GLtAlwaysOn);
   f.WriteInteger('Controls', 'GLastLtPos', Sett.Controls.GLastLtPos);

   f.WriteBool('Controls', 'GClippingMin', Sett.Controls.GClippingMin);
   f.WriteBool('Controls', 'GClippingAdv', Sett.Controls.GClippingAdv);
   f.WriteInteger('Controls', 'GClippingPos', Integer(Sett.Controls.GClippingPos));
   f.WriteInteger('Controls', 'SObjEdPos', Integer(Sett.Controls.SObjEdPos));
   f.WriteBool('Controls', 'SObjAutoFind', Sett.Controls.SObjAutoFind);
   f.WriteInteger('Controls', 'SLastOiPos', Sett.Controls.SLastOiPos);
    
   //Working Dirs
   f.WriteString('WorkingDirs', 'Lba1_1', Sett.WorkingDirs.Lba1[1]);
   f.WriteString('WorkingDirs', 'Lba1_2', Sett.WorkingDirs.Lba1[2]);
   f.WriteString('WorkingDirs', 'Lba1_3', Sett.WorkingDirs.Lba1[3]);
   f.WriteInteger('WorkingDirs', 'Lba1_Current', Sett.WorkingDirs.Current_Lba1);
   f.WriteString('WorkingDirs', 'Lba2_1', Sett.WorkingDirs.Lba2[1]);
   f.WriteString('WorkingDirs', 'Lba2_2', Sett.WorkingDirs.Lba2[2]);
   f.WriteString('WorkingDirs', 'Lba2_3', Sett.WorkingDirs.Lba2[3]);
   f.WriteInteger('WorkingDirs', 'Lba2_Current', Sett.WorkingDirs.Current_Lba2);

   //Opening
   f.WriteInteger('Open','Layout',fmOpen.cbLibIndex.ItemIndex);
   f.WriteInteger('Open','Grid',fmOpen.cbGriIndex.ItemIndex);
   f.WriteInteger('Open','Scene',fmOpen.cbScnIndex.ItemIndex);
   f.WriteInteger('Open', 'LbaVersion', IfThen(fmOpen.rbLba2.Checked, 2, 1));
   f.WriteBool('Open', 'BrkOrigin', fmOpen.rbBrkOrigin.Checked);
   f.WriteBool('Open', 'LibOrigin', fmOpen.rbLibOrigin.Checked);
   if fmOpen.rbGriCustom.Checked then a:= 1
   else if fmOpen.rbGriNew.Checked then a:= 2
   else a:= 0;
   f.WriteInteger('Open', 'GriMode', a);
   if fmOpen.rbScnCustom.Checked then a:= 1
   else if fmOpen.rbScnNew.Checked then a:= 2
   else a:= 0;
   f.WriteInteger('Open', 'ScnMode', a);
   f.WriteBool('Open', 'PalOrigin', fmOpen.rbPalOrigin.Checked);
   f.WriteString( 'Open','BrkPath',         fmOpen.stBrkPath.Caption);
   f.WriteString( 'Open','PalPath',         fmOpen.stPalPath.Caption);
   f.WriteString( 'Open','BllPath',         LibPath);
   f.WriteInteger('Open','BllIndex',        LibIndex);
   f.WriteString( 'Open','GriPath',         Sett.OpenDlg.GridPath);
   f.WriteInteger('Open','GriIndex',        Sett.OpenDlg.GridIndex);
   f.WriteString( 'Open','ScePath',         ScenePath);
   f.WriteInteger('Open','SceIndex',        SceneIndex);
   f.WriteBool(   'Open','AutoLibrary',     fmOpen.cbAutoLib.Checked);
   f.WriteString( 'Open','NewGridLibIndex', fmOpen.eLibIndex.Text);
   f.WriteString( 'Open','NewGrigFragIndex',fmOpen.eFragIndex.Text);
   f.WriteBool(   'Open','SceneMode',       fmOpen.rbSceneMode.Checked);
   f.WriteInteger('OpenSim','CB',           IfThen(fmOpenSim.rbLba1.Checked, 1, 2));
   f.WriteInteger('OpenSim', 'SimGCIndex', Sett.OpenDlg.GrSimGCIndex);
   f.WriteInteger('OpenSim', 'SimFCIndex', Sett.OpenDlg.GrSimFCIndex);
   f.WriteInteger('OpenSim', 'SimGrIndex', Sett.OpenDlg.GrSimGrIndex);
   f.WriteString('OpenSim', 'SimGrPath', Sett.OpenDlg.GrSimGrPath);
   f.WriteBool(   'OpenSim','SceneMode',    fmOpenSim.rbSceneMode.Checked);

   //General
   f.WriteBool('Saving', 'UseCompression1', Sett.General.UseComp1);
   f.WriteBool('Saving', 'UseCompression2', Sett.General.UseComp2);
   f.WriteInteger('Saving', 'CompMode1', Integer(Sett.General.CompMode1));
   f.WriteInteger('Saving', 'CompMode2', Integer(Sett.General.CompMode2));
   f.WriteBool('General', 'ResetAfterPlacing', Sett.General.ResetClip);
   f.WriteBool('General', 'AskDelLayer', Sett.General.AskDelLayer);
   f.WriteBool('General', 'ShowIndexes', Sett.General.ShowIndexes);
   f.WriteBool('General', 'FirstIndex1', Sett.General.FirstIndex1);
   f.WriteBool('General', 'SingleInvPlacing', Sett.General.SingleInvPlacing);
   //f.WriteBool('General', 'SaveSuperCompat', Sett.General.SaveSuperCompat);
   f.WriteBool('General', 'AutoMainGrid', Sett.General.AutoMainGrid);
   f.WriteString('General','LastExportDir', Sett.General.LastExpDir);
   f.WriteString('General','LastSaveDir', Sett.General.LastSaveDir);
   f.WriteString('General','LastScenDir', Sett.General.LastScenarioDir);
   for a:= 0 to MaxRecentScenarios - 1 do
     f.WriteString('General', 'RecentScenario' + IntToStr(a), Sett.General.RecentScenarios[a]);

   //Frames
   f.WriteBool('Frames', 'UseNewFrames', Sett.Frames.NewStyle);
   f.WriteBool('Frames', 'NewFramesEdge', Sett.Frames.NewStyleEdges);
   f.WriteInteger('Frames', 'MainImgCol', Sett.Frames.MainImgCol);
   f.WriteInteger('Frames', 'WinNetCol', Sett.Frames.WinNetCol);
   f.WriteInteger('Frames', 'PanelCol', Sett.Frames.PanelCol);
   f.WriteInteger('Frames', 'PlacedCol', Sett.Frames.PlacedCol);
   f.WriteInteger('Frames', 'CursorCol', Sett.Frames.CursorCol);
   f.WriteInteger('Frames', 'SelectCol', Sett.Frames.SelectCol);
   f.WriteInteger('Frames', 'HelperCol', Sett.Frames.HelperCol);
   f.WriteInteger('Frames', 'InvisibleCol', Sett.Frames.InvBrkCol);
   f.WriteInteger('Frames', 'ShapesCol', Sett.Frames.ShapesCol);

   //Mouse
   f.WriteInteger('Mouse', 'WheelSpeed', Sett.Mouse.WheelSpeed);
   f.WriteInteger('Mouse', 'WheelAverage', Sett.Mouse.WheelAverage);
   f.WriteBool('Mouse', 'InvertX', Sett.Mouse.InvertX);
   f.WriteBool('Mouse', 'InvertY', Sett.Mouse.InvertY);

   //Coordinates
   f.WriteBool('Coords', 'DispCursor',    Sett.Coords.Cursor);
   f.WriteBool('Coords', 'DispSelection', Sett.Coords.Selection);
   f.WriteBool('Coords', 'DispBrkInfo',   Sett.Coords.BrkInfo);
   f.WriteBool('Coords', 'BrkInfoSelected', Sett.Coords.BrkInfoSel);
   f.WriteBool('Coords', 'RangeConnected', Sett.Coords.RangeCon);
   f.WriteBool('Coords', 'RangeHide',     Sett.Coords.RangeHide);
   f.WriteBool('Coords', 'SceneCoords',   Sett.Coords.SceneCrds);
   f.WriteBool('Coords', 'SceneBricks',   Sett.Coords.SceneBrk);
   f.WriteBool('Coords', 'SceneClip',     Sett.Coords.SceneClip);
   f.WriteBool('Coords', 'SceneSelected', Sett.Coords.SceneSel);

   //Scene
   f.WriteBool('Scene', 'Snap', Sett.Scene.SnapToBricks);
   f.WriteBool('Scene', 'ObjGroupUndo', Sett.Scene.ObjGroupUndo);
   for zt in AllZoneTypes do
     f.WriteInteger('Scene', 'ZoneCol' + IntToStr(Byte(zt)), Sett.Scene.ZoneColours[zt]);

   //Scripts
   f.WriteBool('ScriptGeneral', 'ScriptToActor', Sett.Scripts.ScriptToActor);
   f.WriteBool('ScriptGeneral', 'CompletionProp', Sett.Scripts.CompletionProp);
   f.WriteInteger('ScriptGeneral', 'EditorFontSize', Sett.Scripts.EdFontSize);
   f.WriteString('ScriptGeneral', 'TemplateEditor', Sett.Scripts.TemplateEditor);
   f.WriteString('ScriptGeneral', 'TemplateEditor', Sett.Scripts.TemplateEditor);
   f.WriteBool('ScriptGeneral', 'TxtGroupUndo', Sett.Scripts.TxtGroupUndo);
   GetWindowPlacement(fmScriptEd.Handle, @wp);
   f.WriteInteger('ScriptGeneral', 'WindowX', wp.rcNormalPosition.Left);
   f.WriteInteger('ScriptGeneral', 'WindowY', wp.rcNormalPosition.Top);
   f.WriteInteger('ScriptGeneral', 'WindowW', wp.rcNormalPosition.Right - wp.rcNormalPosition.Left);
   f.WriteInteger('ScriptGeneral', 'WindowH', wp.rcNormalPosition.Bottom - wp.rcNormalPosition.Top);
   f.WriteBool('ScriptGeneral', 'WindowMax', fmScriptEd.WindowState = wsMaximized);
   f.WriteInteger('ScriptGeneral', 'SPHorizPos', fmScriptEd.pcBottom.Height);
   f.WriteInteger('ScriptGeneral', 'SPVertPos', fmScriptEd.seLifeScript.Width);
   f.WriteInteger('ScriptGeneral', 'ScpLifeW', fmScriptEd.scpLifeScript.Width);
   f.WriteInteger('ScriptGeneral', 'ScpLifeH', fmScriptEd.scpLifeScript.NbLinesInWindow);
   f.WriteInteger('ScriptGeneral', 'ScpTrackW', fmScriptEd.scpTrackScript.Width);
   f.WriteInteger('ScriptGeneral', 'ScpTrackH', fmScriptEd.scpTrackScript.NbLinesInWindow);
   //Decompilation
   f.WriteBool('ScriptDecomp', 'UpperCase', ScrSet.Decomp.UpperCase);
   f.WriteBool('ScriptDecomp', 'IndentTrack', ScrSet.Decomp.IndentTrack);
   f.WriteBool('ScriptDecomp', 'IndentLife', ScrSet.Decomp.IndentLife);
   f.WriteBool('ScriptDecomp', 'FirstCompMain', ScrSet.Decomp.FirstCompMain);
   f.WriteBool('ScriptDecomp', 'AddEND_SWITCH', ScrSet.Decomp.AddEND_SWITCH);
   f.WriteBool('ScriptDecomp', 'Lba1MacroOrg', ScrSet.Decomp.Lba1MacroOrg);
   f.WriteBool('ScriptDecomp', 'Lba2MacroOrg', ScrSet.Decomp.Lba2MacroOrg);
   f.WriteBool('ScriptDecomp', 'CompoOrg', ScrSet.Decomp.CompoOrg);
   //Compilation
   f.WriteBool('ScriptComp', 'StrictSyntax', ScrSet.Comp.StrictSyntax);
   f.WriteBool('ScriptComp', 'RequireENDs', ScrSet.Comp.RequireENDs);
   f.WriteBool('ScriptComp', 'LabelWarnings', ScrSet.Comp.LabelWarnings);
   f.WriteBool('ScriptComp', 'LbUnusedWarns', ScrSet.Comp.LbUnusedWarns);
   f.WriteBool('ScriptComp', 'UnusedWarns', ScrSet.Comp.CompUnusedWarns);
   f.WriteBool('ScriptComp', 'AutoHLError', ScrSet.Comp.AutoHLError);
   f.WriteBool('ScriptComp', 'AutoHLAlways', ScrSet.Comp.AutoHLAlways);
   f.WriteBool('ScriptComp', 'CheckZones', ScrSet.Comp.CheckZones);
   f.WriteBool('ScriptComp', 'CheckSuit', ScrSet.Comp.CheckSuit);
   f.WriteBool('ScriptComp', 'CheckTracks', ScrSet.Comp.CheckTracks);
   f.WriteBool('ScriptComp', 'TrackErrors', ScrSet.Comp.TrackErrors);
   f.WriteBool('ScriptComp', 'CheckActors', ScrSet.Comp.CheckActors);
   f.WriteBool('ScriptComp', 'ActorErrors', ScrSet.Comp.ActorErrors);
   f.WriteBool('ScriptComp', 'CheckBdAn', ScrSet.Comp.CheckBdAn);
   f.WriteBool('ScriptComp', 'BdAnErrors', ScrSet.Comp.BdAnErrors);

 except
   Application.MessageBox('Can''t save settings!','Little Big Architect',MB_ICONWARNING+MB_OK);
 end;
 f.Free;
end;

procedure TfmSettings.cbMainImgChange(Sender: TObject);
begin
 If fmSettings.Visible then begin
   UpdateColourSettings();
   UpdateColourControls();
   DrawMapA();
   PaintLayouts();
 end;
end;

procedure TfmSettings.cbResetClipClick(Sender: TObject);
begin
 fmMain.frLtClip.btResetClick(Sender);
end;

procedure TfmSettings.btRestColClick(Sender: TObject);
begin
 cbMainImg.Color:= clWhite;
 cbWinNet.Color:= clLime;
 cbPanel.Color:= clWhite;
 cbPlaced.Color:= clMoneyGreen;
 cbCursor.Color:= clSkyBlue;
 cbSelect.Color:= clFuchsia;
 cbHelper.Color:= clSkyBlue;
 cbInvBrk.Color:= clSilver;
 cbShapes.Color:= clYellow;
 cbMainImgChange(Self);
end;

procedure TfmSettings.cbDispBrkClick(Sender: TObject);
begin
 rbAtCursor.Enabled:= cbDispBrk.Checked;
 rbSelected.Enabled:= cbDispBrk.Checked;
 cbRangeHide.Enabled:= rbRangeCon.Checked;
end;

procedure TfmSettings.cbUseComp1Click(Sender: TObject);
begin
 EnableGroup(paComp1, cbUseComp1.Checked);
 EnableGroup(paComp2, cbUseComp2.Checked);
end;

procedure TfmSettings.cbNewFramesClick(Sender: TObject);
begin
 Sett.Frames.NewStyle:= cbNewFrames.Checked;
 If fmMain.pbGrid.Visible and Sett.Frames.NewStyle then SetAllFrameLines(CMap^);
 DrawMapA();
end;

procedure TfmSettings.cbAutoHLErrorClick(Sender: TObject);
begin
 cbAutoHLVisOnly.Enabled:= cbAutoHLError.Checked;
end;

end.
