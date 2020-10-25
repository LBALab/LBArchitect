//******************************************************************************
// Little Big Architect: Builder - editing grid files containing rooms in
//                                 Little Big Adventure 1 & 2
//
// Main unit.
// Main program unit. Contains main form's events.
//
// Copyright Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, DePack, Engine, ExtCtrls, Buttons, StrUtils,
  Rendering, ImgList, ActnList, ToolWin, Math, jpeg, Menus, Grids,
  Clipping, Bricks, Scenario, SceneObj, Scene, ImgExport, Clipbrd,
  SceneLib, SceneLibConst, CompMods, ExitSave, ScenarioDlg, Link, ShellApi,
  SceneUndo, Utils, Maps, BetterSpin, ComboMod, DebugLog;

type
  TfmMain = class(TForm)
    DlgOpen: TOpenDialog;
    DlgSave: TSaveDialog;
    imgBrkBuff: TImageList;
    ActionList: TActionList;
    aOpen: TAction;
    aNew: TAction;
    aExit: TAction;
    aSettings: TAction;
    aExportBMP: TAction;
    aSaveGridAs: TAction;
    Splitter1: TSplitter;
    paMain: TPanel;
    paGrid: TPanel;
    pbGrid: TPaintBox;
    VScr: TScrollBar;
    HScr: TScrollBar;
    paHint: TPanel;
    aHints: TAction;
    aOpenSim: TAction;
    tmHintMsg: TTimer;
    paTools: TPanel;
    Bevel2: TBevel;
    pbThumb: TPaintBox;
    aUndo: TAction;
    aRedo: TAction;
    imgAxes: TImage;
    paCoords: TPanel;
    lbCoords: TLabel;
    paAdv: TPanel;
    Label1: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    btAlX0: TSpeedButton;
    btAlZ2: TSpeedButton;
    btAlY1: TSpeedButton;
    MainMenu1: TMainMenu;
    mmFile: TMenuItem;
    Edit1: TMenuItem;
    View1: TMenuItem;
    New1: TMenuItem;
    Opensimple1: TMenuItem;
    Openadvanced1: TMenuItem;
    Saveas1: TMenuItem;
    Exporttobitmap1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Undo1: TMenuItem;
    Redo1: TMenuItem;
    Undo2: TMenuItem;
    Hintbox1: TMenuItem;
    imgMenus: TImageList;
    ThumbTimer: TTimer;
    imgFlag: TImage;
    btTest: TButton;
    aSaveGrid: TAction;
    Save1: TMenuItem;
    N4: TMenuItem;
    paSplash: TPanel;
    paDummy: TPanel;
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
    lbVersion: TLabel;
    lbDisclaimer: TLabel;
    mViewShapes: TMenuItem;
    imgActor: TImage;
    imgFrameList: TImageList;
    mAbout: TMenuItem;
    pcControls: TPageControl;
    tsGrid: TTabSheet;
    tsScene: TTabSheet;
    GroupBox4: TGroupBox;
    btInvisi: TSpeedButton;
    btSelect: TSpeedButton;
    btPlace: TSpeedButton;
    btHand: TSpeedButton;
    ToolOpts: TPageControl;
    SelOpts: TTabSheet;
    GroupBox5: TGroupBox;
    btSelBrk: TSpeedButton;
    btSelCol: TSpeedButton;
    btSelObj: TSpeedButton;
    btSelFnt: TSpeedButton;
    btSelFne: TSpeedButton;
    cbCursor1: TCheckBox;
    cbHelper1: TCheckBox;
    cbPlacedFr1: TCheckBox;
    cbHelp3D1: TCheckBox;
    PlaceOpts: TTabSheet;
    gbPlaceOpts: TGroupBox;
    Label6: TLabel;
    cbPlacedFr2: TCheckBox;
    cbFramesLt: TCheckBox;
    cbHelper2: TCheckBox;
    cbHelp3D2: TCheckBox;
    InvOpts: TTabSheet;
    GroupBox7: TGroupBox;
    btInvBrk: TSpeedButton;
    btInvObj: TSpeedButton;
    cbCursor2: TCheckBox;
    cbHelper3: TCheckBox;
    gbCreateInvisi: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    btinvNew: TButton;
    cbHelp3D3: TCheckBox;
    GroupBox1: TGroupBox;
    btScHand: TSpeedButton;
    btScEdit: TSpeedButton;
    btFrames_: TSpeedButton;
    btNet_: TSpeedButton;
    btMaxLayer_: TSpeedButton;
    btCoords_: TSpeedButton;
    btShowInv_: TSpeedButton;
    btScShowInv_: TSpeedButton;
    btScCoords_: TSpeedButton;
    btScNet_: TSpeedButton;
    btScFrames_: TSpeedButton;
    btScMaxLayer_: TSpeedButton;
    btScAddTrack: TSpeedButton;
    btScAddActor: TSpeedButton;
    aOpenScenario: TAction;
    aSaveScenarioAs: TAction;
    N5: TMenuItem;
    mOpenScen: TMenuItem;
    ExporttoaScenario1: TMenuItem;
    mScenarioProp: TMenuItem;
    aScenarioProp: TAction;
    N7: TMenuItem;
    mSceneMode: TMenuItem;
    Sceneproperties1: TMenuItem;
    N9: TMenuItem;
    SaveScene1: TMenuItem;
    SaveSceneas1: TMenuItem;
    aSceneMode: TAction;
    aSceneProp: TAction;
    aSaveScene: TAction;
    aSaveSceneAs: TAction;
    N8: TMenuItem;
    btScAddZone: TSpeedButton;
    mScObjSelect: TPopupMenu;
    Selectobject1: TMenuItem;
    N11: TMenuItem;
    mSCancelSelect: TMenuItem;
    mSSelectNothing: TMenuItem;
    tmHighlight: TTimer;
    imgSceneSelObj: TImageList;
    lbHints: TLabel;
    aSaveScenario: TAction;
    SaveScenario1: TMenuItem;
    lbBetaInfo: TLabel;
    btSceneUndo: TSpeedButton;
    btSceneRedo: TSpeedButton;
    aSceneHelp: TAction;
    aAbout: TAction;
    Scenereference1: TMenuItem;
    N10: TMenuItem;
    AboutBuilder1: TMenuItem;
    aManageTpls: TAction;
    ManageActorTemplates1: TMenuItem;
    cbFragment: TComboBox;
    N12: TMenuItem;
    mOpenFrag: TMenuItem;
    mCreateFrag: TMenuItem;
    aCreateFrag: TAction;
    aOpenFrag: TAction;
    aSelToFrag: TAction;
    AddFragmentfromselection1: TMenuItem;
    mGRight: TPopupMenu;
    mGSelNone: TMenuItem;
    mGDelSel: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    mGCopyTo: TMenuItem;
    mGSelAll: TMenuItem;
    mGNewFrag: TMenuItem;
    N15: TMenuItem;
    Closethemenu1: TMenuItem;
    tsFragTest: TTabSheet;
    mRecentScenario: TMenuItem;
    lbSpecial: TLabel;
    aCloseFrag: TAction;
    N16: TMenuItem;
    CloseFragment1: TMenuItem;
    aCloseAll: TAction;
    Closeall1: TMenuItem;
    btDelFrag: TBitBtn;
    btUndo: TBitBtn;
    BitBtn1: TBitBtn;
    imgButtons: TImageList;
    CheckBox1: TCheckBox;
    BitBtn2: TBitBtn;
    N17: TMenuItem;
    mDeleteLayer: TMenuItem;
    btScAim: TSpeedButton;
    Listofopenfiles1: TMenuItem;
    N6: TMenuItem;
    ools1: TMenuItem;
    aFileList: TAction;
    aBatchAnalyse: TAction;
    BatchSceneanalysis1: TMenuItem;
    paLeftSide: TPanel;
    paLayout: TPanel;
    imgLts: TImage;
    pbLts: TPaintBox;
    LScr: TScrollBar;
    paObjInspector: TPanel;
    btScVisible: TSpeedButton;
    aDebugLog: TAction;
    DebugLog1: TMenuItem;
    procedure pbGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure VScrScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure FormResize(Sender: TObject);
    procedure pbGridPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btMaxLayer_Click(Sender: TObject);
    procedure aOpenExecute(Sender: TObject);
    procedure aSettingsExecute(Sender: TObject);
    procedure pbThumbPaint(Sender: TObject);
    procedure aExportBMPExecute(Sender: TObject);
    procedure pbThumbMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbThumbMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure aExitExecute(Sender: TObject);
    procedure pbLtsPaint(Sender: TObject);
    procedure LScrChange(Sender: TObject);
    procedure pbLtsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Splitter1CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure btHandClick(Sender: TObject);
    procedure aHintsExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure aSaveGridAsExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure aNewExecute(Sender: TObject);
    procedure aOpenSimExecute(Sender: TObject);
    procedure tmHintMsgTimer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btinvNewClick(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure aUndoExecute(Sender: TObject);
    procedure lbCoordsClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure btAlX0Click(Sender: TObject);
    procedure seAXChange(Sender: TObject);
    procedure ThumbTimerTimer(Sender: TObject);
    procedure btTestClick(Sender: TObject);
    procedure aSaveGridExecute(Sender: TObject);
    procedure btScVisibleClick(Sender: TObject);
    procedure btScHandClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure aOpenScenarioExecute(Sender: TObject);
    procedure aSaveScenarioAsExecute(Sender: TObject);
    procedure aScenarioPropExecute(Sender: TObject);
    procedure VScrChange(Sender: TObject);
    procedure aSceneModeExecute(Sender: TObject);
    procedure btScVisibleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mSSelectNothingClick(Sender: TObject);
    procedure frSceneObjPropsseZXChange(Sender: TObject);
    procedure tmHighlightTimer(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure aScenePropExecute(Sender: TObject);
    procedure aSaveSceneExecute(Sender: TObject);
    procedure aSaveSceneAsExecute(Sender: TObject);
    procedure aSaveScenarioExecute(Sender: TObject);
    procedure aAboutExecute(Sender: TObject);
    procedure aSceneHelpExecute(Sender: TObject);
    procedure aManageTplsExecute(Sender: TObject);
    procedure btFrames_Click(Sender: TObject);
    procedure btCoords_Click(Sender: TObject);
    procedure btSelBrkClick(Sender: TObject);
    procedure cbFramesLtClick(Sender: TObject);
    procedure pcControlsDrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure pcControlsChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure aCreateFragExecute(Sender: TObject);
    procedure cbFragmentChange(Sender: TObject);
    procedure cbFragmentDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure mGSelAllClick(Sender: TObject);
    procedure pcControlsChange(Sender: TObject);
    procedure mOpenRecentScenarioClick(Sender: TObject);
    procedure mmFileClick(Sender: TObject);
    procedure aSelToFragExecute(Sender: TObject);
    procedure aOpenFragExecute(Sender: TObject);
    procedure aCloseFragExecute(Sender: TObject);
    procedure aCloseAllExecute(Sender: TObject);
    procedure pbGridMouseLeave(Sender: TObject);
    procedure aFileListExecute(Sender: TObject);
    procedure pbGridDblClick(Sender: TObject);
    procedure aBatchAnalyseExecute(Sender: TObject);
    procedure aDebugLogExecute(Sender: TObject);
  private
    DblClicked: Boolean;
    DownInSel: Boolean; //Mouse down inside sielection
    DownPt: TPoint;
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
    procedure WMDropFiles(hDrop: THandle; hWindow: HWnd);
    procedure ShowSceneSelList(X, Y: Integer);
    procedure ShowGridSelMenu(X, Y: Integer);
    procedure CopySelToFragment(Target: Integer; DelOrg: Boolean);
    procedure NewFragmentFromSel(DelOrg: Boolean);
    procedure DeleteSelectedArea();
  public
    lnkMantis: TLink;
    seScMaxLayer_: TfrBetterSpin;
    seMaxLayer_: TfrBetterSpin;
    seAX, seAY, seAZ: TfrBetterSpin;
    sePlaceLayer: TfrBetterSpin;
    seX, seY, seZ: TfrBetterSpin;
    frLtClip: TfrClipping;
    frSceneObj: TfrSceneObj;
    procedure AppException(Sender: TObject; E: Exception);
    procedure AppShowHint(Sender: TObject);
    procedure UpdateButtons();
    procedure UpdateCoordsPanel();
    procedure GridUndoSetButtons();
    Procedure UpdateProgramName();
    procedure SetLBAMode(NewLBA: Byte);
    procedure RefreshMapList();
    function SaveMapAs(var Map: TComplexMap): Boolean;
    function SaveMapAuto(var Map: TComplexMap): Boolean;
    function OpenScenarioFile(path: String): Boolean;
    procedure UpdateFileMenu();
  end;

const
 crHand = 22;
 ProgramName = 'Little Grid Builder';

var
  fmMain: TfmMain;
  {$ifdef NO_BUFFER}
  bufMain: TPaintBox;
  {$else}
  bufMain: TBitmap;
  {$endif}
  bufThumb: TBitmap;

  Panning: Boolean = False;
  StartPoint: TPoint;
  GStartPoint: TPoint; //start point for the whole moving (reset on the mouse down)
  GCursor: TBox = (x1: -1; y1: -1; z1: -1; x2: -1; y2: -1; z2: -1);
  GLastCursor: TBox = (x1: -1; y1: -1; z1: -1; x2: -1; y2: -1; z2: -1);
  GSelect: TBox = (x1: -1; y1: -1; z1: -1; x2: -1; y2: -1; z2: -1);
  GHasSelection: Boolean = False; //If anything is selected
  GLastSelect: TBox = (x1: -1; y1: -1; z1: -1; x2: -1; y2: -1; z2: -1);
  GSelStart: TBox = (x1: -1; y1: -1; z1: -1; x2: -1; y2: -1; z2: -1);
  GLastPlacePos: TPoint3d = (x: -1000; y: -1000; z: -1000);
  SLastAimPos: TPoint = (x: -1000; y: -1000);
  SAimPos: TPoint3d = (x: -1000; y: -1000; z: -1000);

  GPlacing: Boolean = False;
  StartVert: Integer;
  GVMoving: Boolean = False; //Moving the Layout being placed vertically
  GSelecting: Boolean = False;
  GMoveAllowed: Boolean = False;
  GFHMoving: Boolean = False; //Moving the selected fragment horizontally
  GFVMoving: Boolean = False; //Moving the selected fragment vertically
  GMvOrigin: TPoint;
  GInvPlacing: Boolean = False;
  GObjCopied: Boolean = False;
  SZoneResizing: Boolean = False;
  SZoneResizingId: Integer = -1;
  SZoneResOrigin: TPoint3d;

  SMvType: TObjType = otNone;
  SVertMoving: Boolean;
  SMvId: Byte;
  SPrevBtn: TSpeedButton;

  KeyHandled: Boolean = False;
  SZoneSelecting: Boolean = False;

implementation

uses ProgBar, Open, Settings, Hints, OpenSim, About, ScenarioProp, SceneProp,
     ActorTpl, Globals, CurrentFiles, ScriptEd, BatchAnalyse, SceneVis, Select;

var MouseMoved: Boolean; //For checking if the mouse has been moved between pressing and releasing the button
    ActorTemplate: TSceneActor;
    UseActorTpl: Boolean; //If user selected a template, or chose to create an empty Actor

{$R *.dfm}

procedure TfmMain.pbGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var rX, rY, rZ: Integer;
begin
 if ProgMode = pmScene then begin
  Panning:= (SceneTool = stHand) or (Button = mbMiddle);
  if Panning then Exit;
  if SceneTool = stSelect then begin
    if PositionInside(X - GOffX + GScrX, Y - GOffY + GScrY, SelType, SelId)
    then begin
      DownInSel:= True; //Will trigger object moving when mouse moves
    end else begin
      ShowSceneSelList(X, Y); //Select one obj or display menu if more
      DblClicked:= False;
      OutputDebugString('DblClicked = False');
    end;
  end
  else if (SceneTool = stAim) and (Button = mbLeft) then begin
    Clipboard.AsText:= Format('X%dY%dZ%d', [SAimPos.x, SAimPos.y, SAimPos.z]);
  end
  else if (SceneTool = stAddActor) and (Button = mbLeft) then begin
    GCursor:= GetPCursor(X, Y, True);
    If (GCursor.x1 > -1) and BoxIsPoint(GCursor)
    and MouseToScene(X-GOffX+HScr.Position-24, Y-GOffY+VScr.Position, rX, rY, rZ,
                     Sett.Scene.SnapToBricks)
    then begin
      if UseActorTpl then
        CreateActor(rX, rY, rZ, ActorTemplate)
      else
        CreateActor(rX, rY, rZ);
    end;
  end
  else if (SceneTool = stAddTrack) and (Button = mbLeft) then begin
    if Length(VScene.Points) < 256 then begin
      GCursor:= GetPCursor(X, Y, True);
      if (GCursor.x1 > -1) and BoxIsPoint(GCursor)
      and MouseToScene(X-GOffX+HScr.Position-24, Y-GOffY+VScr.Position, rX, rY, rZ,
                       Sett.Scene.SnapToBricks)
      then begin
        SceneUndoSetPoint(VScene);
        SetLength(VScene.Points, Length(VScene.Points) + 1);
        SetTrack(High(VScene.Points), rX, rY, rZ);
        SelectObject(otPoint, High(VScene.Points));
      end;
    end
    else Application.MessageBox('No more Points can be created','Little Big Architect',MB_ICONWARNING+MB_OK);
  end
  else if (SceneTool = stAddZone) and (Button = mbLeft) then begin
    If Length(VScene.Zones) < 256 then begin
      GCursor:= GetPCursor(X, Y, True);
      If (GCursor.x1 > -1) and BoxIsPoint(GCursor)
      and MouseToScene(X-GOffX+HScr.Position-24, Y-GOffY+VScr.Position, rX, rY, rZ,
                       Sett.Scene.SnapToBricks)
      then begin
        SceneUndoSetPoint(VScene);
        SetLength(VScene.Zones, Length(VScene.Zones) + 1);
        SZoneResizingId:= High(VScene.Zones);
        SetZone(SZoneResizingId, rX, rY, rZ, rX, rY, rZ, ztCube);
        SelectObject(otZone, SZoneResizingId);
        SZoneResizing:= True;
        SZoneResOrigin:= Point3d(rX, rY, rZ);
        //LastPCursor:= PCursor;
      end;
    end
    else Application.MessageBox('No more Zones can be created','Little Big Architect',MB_ICONWARNING+MB_OK);
  end;
 end
 else begin //Grid Mode
   Panning:= (GridTool = gtHand) or (Button = mbMiddle);
   GPlacing:= ((GridTool = gtPlace) or GInvPlacing) and (Button = mbLeft);
   GVMoving:= ((GridTool = gtPlace) or GInvPlacing) and (Button = mbRight);
   GSelecting:= (GridTool in [gtSelect, gtInvisi]) and not GMoveAllowed and (Button <> mbMiddle);
   if GSelecting then begin
     GObjCopied:= False;
     GSelect:= GCursor; GSelStart:= GSelect;
     if GHasSelection then
       DrawPieceBrk(GLastSelect.x1,GLastSelect.y1,GLastSelect.z1,GLastSelect.x2-GLastSelect.x1+1,
         GLastSelect.y2-GLastSelect.y1+1,GLastSelect.z2-GLastSelect.z1+1,dmRemember);
     DrawPieceBrk(GSelect.x1,GSelect.y1,GSelect.z1,GSelect.x2-GSelect.x1+1,
       GSelect.y2-GSelect.y1+1,GSelect.z2-GSelect.z1+1,dmMerge);
     GHasSelection:= GCursor.x1 > -1;
     GLastSelect:= GSelect;
   end;
   GFHMoving:= (GridTool in [gtSelect, gtInvisi]) and GMoveAllowed and (Button = mbLeft);
   GFVMoving:= (GridTool in [gtSelect, gtInvisi]) and GMoveAllowed and (Button = mbRight);
   if GFHMoving or GFVMoving then begin
     GMvOrigin:= GridToPos(GSelect.x1, GSelect.y1, GSelect.z1, -X, -Y);
     MapCreateUndo(CMap^);
     if not (ssCtrl in Shift) then
       PutPiece(CMap^, GPlacePos.x, GPlacePos.y, GPlacePos.z, BufObj, False);
     DrawPieceBrk(GSelect.x1, GSelect.y1, GSelect.z1, GSelect.x2-GSelect.x1+1,
       GSelect.y2-GSelect.y1+1, GSelect.z2-GSelect.z1+1, dmNormal,True);
   end;
   StartVert:= Sett.Controls.GPlaceLayer;
 end;
 StartPoint:= Point(X, Y);
 DownPt:= StartPoint;
 MouseMoved:= False;
 LastSnapDelta:= Point3d(128, 128, 128);
 UpdateCoords(X - GOffX + GScrX - 24, Y - GOffY + GScrY);
end;

procedure TfmMain.pbGridMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var gX, gZ, PlaceLayer, a, rX, rY, rZ, dX: Integer;
    ZZ: TSceneZone;
    Pt: TPoint;
begin
 MouseMoved:= True;
 If not ((ssMiddle in Shift) or (ssLeft in Shift)) then Panning:= False;
 If not ((ssLeft in Shift) or (ssRight in Shift)) then begin
   SMvType:= otNone;
   SZoneResizing:= False;
 end;
 if (ProgMode = pmScene) and (SceneTool = stHand) then
   PutHint('Left hold and move to pan image'#13'<Shift> - switch to Point adding tool'#13'<Shift> + <Ctrl> - switch to Actor adding tool') //55
 else if (ProgMode <> pmScene) and (GridTool = gtHand) then
   PutHint('Left hold and move to pan image'); //5
 if Panning then begin
   ScrollMap(-(X-StartPoint.X), -(Y-StartPoint.Y));
   StartPoint:= Point(X, Y);
 end;
 if ProgMode = pmScene then begin
   if SZoneResizing then
     PutHint('<Ctrl> - change Zone height (Y)'#13'<Shift> - move Zone (instead of changing its size)'#13'<Ctrl> + <Shift> - both of above') //81
   else begin
     case SceneTool of
       stSelect: PutHint('LEFT hold and move to move an element in X and Z axes, RIGHT hold and move to move element in Y axis'#13'<Shift> - switch to Point adding tool. <Shift>+<Ctrl> - switch to Actor adding tool.'#13'<Ctrl> and LEFT click an Actor to duplicate it'); //75
       //stAim: PutHint('LEFT click to copy Scene position to clipboard.'#13'Ctrl to disable snapping');
       stAddTrack: PutHint('LEFT click to add a new Point at cursor position'); //76
       stAddZone: PutHint('LEFT hold and move to begin adding a new Zone at cursor position'); //82
       stAddActor: PutHint('LEFT click to add a new Actor at cursor position'); //83
     end;
   end;
   if DownInSel and ((ssLeft in Shift) or (ssRight in Shift))
   and ((Abs(X-DownPt.X) > 2) or (Abs(Y-DownPt.Y) > 2))
   then begin
     SceneUndoSetPoint(VScene);
     if (SelType = otZone)
     and ZonePosInHandle(SelId, DownPt.X - GOffX + GScrX, DownPt.Y - GOffY + GScrY)
     then begin
       SZoneResizing:= True;
       SZoneResizingId:= SelId;
       SZoneResOrigin:= Point3d(VScene.Zones[SelId].X1, VScene.Zones[SelId].Y1,
                                VScene.Zones[SelId].Z1);
     end
     else begin
       SMvType:= SelType;
       SMvId:= SelId;
       SVertMoving:= ssRight in Shift;
       if (SelType = otActor) and (ssLeft in Shift) and (ssCtrl in Shift) then begin
         if Length(VScene.Actors) < 256 then begin
           SetLength(VScene.Actors, Length(VScene.Actors) + 1);
           VScene.Actors[High(VScene.Actors)]:= VScene.Actors[SelId];
           VScene.Actors[High(VScene.Actors)].DispInfo.Sprite:= nil; //to create a new instance
           SetActor(High(VScene.Actors), VScene.Actors[SelId].X, VScene.Actors[SelId].Y,
             VScene.Actors[SelId].Z);
           SelectObject(otActor, High(VScene.Actors));
           SelId:= High(VScene.Actors);
           SMvId:= SelId;
         end
         else Application.MessageBox('No more Actors can be created','Little Big Architect',MB_ICONWARNING+MB_OK);
       end;
     end;
     StartPoint:= DownPt;
     DownInSel:= False;
   end;
   if (X <> StartPoint.X) or (Y <> StartPoint.Y) then begin
     if SZoneResizing then begin
       ZZ:= VScene.Zones[SZoneResizingId];
       if (ssCtrl in Shift) or (ssRight in Shift) then begin // Y
         rY:= MouseToSceneY(X-GOffX + HScr.Position-24, Y-GOffY + VScr.Position,
                            IfThen(SZoneResOrigin.x = ZZ.X1, ZZ.X2, ZZ.X1), //take the other coord
                            Sett.Scene.SnapToBricks);
         if ssShift in Shift then //Edit position instead of size
           SZoneResOrigin.y:= SZoneResOrigin.y + rY
                            - IfThen(SZoneResOrigin.y = ZZ.Y1, ZZ.Y2, ZZ.Y1);
         //If ZoneResOrigin.y < -256 then ZoneResOrigin.y:= -256;
         if rY < -256 then rY:= -256 else if rY > 6400 then rY:= 6400;
         SetZone(SZoneResizingId, ZZ.X1, SZoneResOrigin.y, ZZ.Z1,
                                  ZZ.X2, rY,               ZZ.Z2,
                 VScene.Zones[SZoneResizingId].RealType);
       end
       else begin // X + Z
         MouseToSceneXZ(X-GOffX+HScr.Position-24, Y-GOffY+VScr.Position,
                        IfThen(SZoneResOrigin.y = ZZ.Y1, ZZ.Y2, ZZ.Y1),
                        rX, rZ, Sett.Scene.SnapToBricks);
         If ssShift in Shift then begin //Edit position instead of size
           SZoneResOrigin.x:= SZoneResOrigin.x + rX
                            - IfThen(SZoneResOrigin.x = ZZ.X1, ZZ.X2, ZZ.X1);
           SZoneResOrigin.z:= SZoneResOrigin.z + rZ
                            - IfThen(SZoneResOrigin.z = ZZ.Z1, ZZ.Z2, ZZ.Z1);
         end;
         //If ZoneResOrigin.x < -256 then ZoneResOrigin.x:= -256;
         //If ZoneResOrigin.z < -256 then ZoneResOrigin.z:= -256;
         If rX < -256 then rX:= -256 else if rX > 32767 then rX:= 32767;
         If rZ < -256 then rZ:= -256 else if rZ > 32767 then rZ:= 32767;
         SetZone(SZoneResizingId, SZoneResOrigin.x, ZZ.Y1, SZoneResOrigin.z,
                                  rX,               ZZ.Y2, rZ,
                 VScene.Zones[SZoneResizingId].RealType);
       end;
       //DrawZone(High(VScene.Zones),);
       //SelectObject(otZone,High(VScene.Zones));
       //DrawSelection();
       GCursor:= GetPCursor(X, Y, True);
       UpdateCoords(X-GOffX+GScrX-24, Y-GOffY+GScrY);
       frSceneObj.ChangeSceneObj();
     end
     else begin
       MoveObject(SMvType, SMvId, X - StartPoint.X, Y - StartPoint.Y, SVertMoving);
       StartPoint:= Point(X, Y);
       If SceneTool <> stHand then begin
         GCursor:= GetPCursor(X, Y, True);
         UpdateCoords(X-GOffX+GScrX-24, Y-GOffY+GScrY);
         if SceneTool = stAim then begin
           DrawPositionHighlight(SLastAimPos, False);
           //GCursor:= GetPCursor(X, Y, True);
           if MouseToScene(X-GOffX+GScrX-24, Y-GOffY+GScrY, rX, rY, rZ,
                not (ssCtrl in KeyboardStateToShiftState()), True)
           then begin
             Pt:= SceneToMouse(rX, rY, rZ);
             SLastAimPos:= Pt;
             SAimPos:= Point3d(rX, rY, rZ);
             DrawPositionHighlight(Pt, True);
             PutHint('LEFT click to copy Scene position ' + Format('[%d, %d, %d]', [rX, rY, rZ])
                   + ' to clipboard.'#13'Ctrl to disable snapping');
           end else
             PutHint('Invalid position. Cursor must point a flat ground piece.');
         end;
       end;
     end;
   end;
 end
 else begin //Grid mode
  If (GridTool = gtPlace) or GInvPlacing then begin
    PutHint('LEFT click to place layout on the grid at current layer'#13'LEFT HOLD and MOVE up/down to place at another layer'#13'RIGHT HOLD and MOVE up/down to change layer (without placing)'); //4
    If GPlacing or GVMoving then begin
      sePlaceLayer.Value:= StartVert + ((StartPoint.Y-Y) div 15);
      btSelBrkClick(sePlaceLayer);
      PlaceLayer:= Sett.Controls.GPlaceLayer;
      gX:= GPlacePos.x;
      gZ:= GPlacePos.z;
    end
    else begin
      PlaceLayer:= Sett.Controls.GPlaceLayer;
      GetBrick(X-GOffX+HScr.Position-24, Y-GOffY+VScr.Position, PlaceLayer, gX, gZ);
    end;
    if ((GPlacePos.x <> gX) or (GPlacePos.y <> PlaceLayer) or (GPlacePos.z <> gZ))
    and (gX >= -PlaceObj.X + 1) and (gX <= GHiX)
    and (gZ >= -PlaceObj.Z + 1) and (gZ <= GHiZ) then begin
      DrawPieceBrk(GPlacePos.x,GPlacePos.y,GPlacePos.z,PlaceObj.X,PlaceObj.Y,PlaceObj.Z,dmRemember,True);
      GPlacePos:= Point3d(gX,PlaceLayer,gZ);
      DrawPieceBrk(gX,0,gZ,PlaceObj.X,PlaceObj.Y+PlaceLayer,PlaceObj.Z,dmMerge);
      //DrawMapA;
      UpdateCoords();
    end;
  end
  else if GridTool in [gtSelect, gtInvisi] then begin
    if GFHMoving then begin
      PutHint('RELEASE mouse button to drop the piece'); //20
      GetBrick(X+GMvOrigin.X+12, Y+GMvOrigin.Y+12, GSelect.y1,gX,gZ);
      if (gX >= -GSelect.x2 + GSelect.x1) and (gX <= GHiX)
      and (gZ >= -GSelect.z2 + GSelect.z1) and (gZ <= GHiZ) then
        GPlacePos:= Point3d(gX, GSelect.y1, gZ);
    end
    else if GFVMoving then begin
      GPlacePos:= Point3d(GSelect.x1, GSelect.y1+((StartPoint.Y-Y+7) div 15), GSelect.z1);
      If GPlacePos.y < -GSelect.y2 + GSelect.y1 then
        GPlacePos.y:= -GSelect.y2 + GSelect.y1
      else if GPlacePos.y > GHiY then GPlacePos.y:= GHiY;
    end
    else begin
      PutHint('LEFT click to select'#13'LEFT HOLD and MOVE to select area (doesn''t work for layout selecting)'); //15
      GCursor:= GetPCursor(X, Y, False);
      If BoxEmpty(GSelStart) then GSelStart:= GCursor;
      If GSelecting then begin
        If not BoxEmpty(GCursor) and (Sett.Controls.GSelMode <> smObject) then
          GSelect:= Box(Min(GSelStart.x1,GCursor.x1),Min(GSelStart.y1,GCursor.y1),
                        Min(GSelStart.z1,GCursor.z1),Max(GSelStart.x2,GCursor.x2),
                        Max(GSelStart.y2,GCursor.y2),Max(GSelStart.z2,GCursor.z2));
      end
      else begin
        if GHasSelection and BoxContains(GSelect, FneCoords[0], FneCoords[1], FneCoords[2])
        then begin
          pbGrid.Cursor:= crSizeAll;
          GMoveAllowed:= True;
          PutHint('Drag with LEFT mouse button to move horizonatally (X and Z axes) (CTRL to copy)'#13'Drag with RIGHT mouse button to move vertically (Y axis)'#13'Press DEL to delete selected fragment'); //16
        end
        else begin
          pbGrid.Cursor:= crDefault;
          GMoveAllowed:= False;
        end;
      end;
    end;
    if (GFHMoving or GFVMoving)
    and ((GPlacePos.x <> GLastPlacePos.x) or (GPlacePos.y <> GLastPlacePos.y) or (GPlacePos.z <> GLastPlacePos.z))
    then begin
      UpdateCoords();
      DrawPieceBrk(GLastPlacePos.x, GLastPlacePos.y, GLastPlacePos.z, PlaceObj.X, PlaceObj.Y, PlaceObj.Z, dmRemember, True);
      DrawPieceBrk(GPlacePos.x, GPlacePos.y, GPlacePos.z, PlaceObj.X, PlaceObj.Y, PlaceObj.Z, dmMerge, True, False);
      GLastPlacePos:= GPlacePos;
    end
    else if (GCursor.x1<>GLastCursor.x1) or (GCursor.y1<>GLastCursor.y1) or (GCursor.z1<>GLastCursor.z1)
         or (GCursor.x2<>GLastCursor.x2) or (GCursor.y2<>GLastCursor.y2) or (GCursor.z2<>GLastCursor.z2) then begin
      UpdateCoords();
      If GSelecting then begin
        DrawPieceBrk(GLastSelect.x1,GLastSelect.y1,GLastSelect.z1,GLastSelect.x2-GLastSelect.x1+1,
          GLastSelect.y2-GLastSelect.y1+1,GLastSelect.z2-GLastSelect.z1+1,dmRemember);
        DrawPieceBrk(GSelect.x1,GSelect.y1,GSelect.z1,GSelect.x2-GSelect.x1+1,
          GSelect.y2-GSelect.y1+1,GSelect.z2-GSelect.z1+1,dmMerge,False,False);
        GLastSelect:= GSelect;
      end else begin
        DrawPieceBrk(GLastCursor.x1,GLastCursor.y1,GLastCursor.z1,GLastCursor.x2-GLastCursor.x1+1,
          GLastCursor.y2-GLastCursor.y1+1,GLastCursor.z2-GLastCursor.z1+1,dmRemember);
        DrawPieceBrk(GCursor.x1,GCursor.y1,GCursor.z1,GCursor.x2-GCursor.x1+1,
          GCursor.y2-GCursor.y1+1,GCursor.z2-GCursor.z1+1,dmMerge,False,False);
      end;
      GLastCursor:= GCursor;
    end;
  end;
 end;
end;

procedure TfmMain.pbGridMouseLeave(Sender: TObject);
begin
 if SceneTool = stAim then
   DrawPositionHighlight(SLastAimPos, False);
 ClearCoords();
end;

procedure TfmMain.pbGridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var a, b, c: Integer;
begin
 Panning:= False;
 if ProgMode = pmScene then begin
   if (Button = mbLeft) and (SMvType <> otNone) and not MouseMoved then
     ShowSceneSelList(X, Y);
   if SceneTool = stAim then begin
     btScEdit.Down:= True;
     btScHandClick(btScEdit);
   end;
 end else begin //Grid Mode
   If GPlacing then begin
     MapCreateUndo(CMap^);
     PutPiece(CMap^, GPlacePos.x, GPlacePos.y, GPlacePos.z, PlaceObj, False);
     If frLtClip.btReset.Down then frLtClip.ChangePlaceObj(True);
     SetMapModified(CMap^);
     If GInvPlacing and Sett.General.SingleInvPlacing then InvPlacingEnd();
   end;

   If GSelecting and GHasSelection then begin
     PlaceObj:= CopyPiece(CMap^, GSelect.x1, GSelect.y1, GSelect.z1, GSelect.x2-GSelect.x1+1,
       GSelect.y2-GSelect.y1+1, GSelect.z2-GSelect.z1+1, GridTool = gtInvisi);
     GPlacePos:= Point3d(GSelect.x1, GSelect.y1, GSelect.z1);
     BufObj.X:= PlaceObj.X;
     BufObj.Y:= PlaceObj.Y;
     BufObj.Z:= PlaceObj.Z;
     SetLength(BufObj.Map, BufObj.X, BufObj.Y, BufObj.Z);
     for c:= 0 to BufObj.Z - 1 do
      for b:= 0 to BufObj.Y - 1 do
       for a:= 0 to BufObj.X - 1 do
        If (GridTool = gtInvisi)
        and (foNormal in CMap^.M^[a+GSelect.x1, b+GSelect.y1, c+GSelect.z1].Frame) then
          BufObj.Map[a,b,c]:= CMap^.M^[a+GSelect.x1, b+GSelect.y1, c+GSelect.z1]
        else
          BufObj.Map[a,b,c]:= EmptyMapItem;
     GObjCopied:= True;
   end;

   If GFHMoving or GFVMoving then begin
     BufObj:= CopyPiece(CMap^, GPlacePos.x, GPlacePos.y, GPlacePos.z,
                               PlaceObj.X, PlaceObj.Y, PlaceObj.Z);
     PutPiece(CMap^, GPlacePos.x, GPlacePos.y, GPlacePos.z, PlaceObj);
     SetMapModified(CMap^);
     GSelect:= Box(GPlacePos.x, GPlacePos.y, GPlacePos.z, GPlacePos.x+PlaceObj.X-1,
                   GPlacePos.y+PlaceObj.Y-1, GPlacePos.z+PlaceObj.Z-1);
     GLastSelect:= GSelect;
     GCursor:= Box(-1, -1, -1, -1, -1, -1);
     GFVMoving:= False;
     GFHMoving:= False;
     DrawPieceBrk(GSelect.x1, GSelect.y1, GSelect.z1, GSelect.x2-GSelect.x1+1,
                  GSelect.y2-GSelect.y1+1,GSelect.z2-GSelect.z1+1,dmNormal,True);
   end;

   if GHasSelection and (Button = mbRight) and not MouseMoved then
     ShowGridSelMenu(X, Y);
 end;

 SMvType:= otNone;
 SZoneResizing:= False;
 GPlacing:= False;
 GVMoving:= False;
 GSelecting:= False;
end;

procedure TfmMain.pbGridDblClick(Sender: TObject);
begin
 DblClicked:= True;
 OutputDebugString('DblClicked = True');
 if (ProgMode = pmScene) and (SelType = otActor) then begin
   fmScriptEd.OpenScripts(SelId);
   fmScriptEd.BringToFront();
 end;
end;

procedure TfmMain.ShowSceneSelList(X, Y: Integer);
const
  Flags: array[Boolean, TPopupAlignment] of Word =
    ((TPM_LEFTALIGN, TPM_RIGHTALIGN, TPM_CENTERALIGN),
     (TPM_RIGHTALIGN, TPM_LEFTALIGN, TPM_CENTERALIGN));
  Buttons: array[TTrackButton] of Word = (TPM_RIGHTBUTTON, TPM_LEFTBUTTON);
var a, b: Integer;
    SelList: TSceneObjects;
    nametemp: String;
    pt: TPoint;
    AFlags: Integer;
    MParams: TPMParams;
begin
 //NewId:= GetObjectAtCursor(X,Y,btScTracks.Down,btScActors.Down,btScZones.Down,NewType);
 //SelectObject(NewType, NewId);
 SelList:= GetObjectsAtCursor(X, Y, ScVisible.Tracks, True, True);
 b:= 0;
 if Length(SelList) < 1 then SelectObject(otNone, 0)
 else if Length(SelList) = 1 then SelectObject(SelList[0].oType, SelList[0].oId)
 else begin
   while mScObjSelect.Items.Count > 4 do mScObjSelect.Items.Delete(1);
   for a:= 0 to High(SelList) do begin
     nametemp:= ' ' + IntToStr(SelList[a].oId);
     case SelList[a].oType of
       otActor: begin
         nametemp:= 'Actor' + nametemp;
         if VScene.Actors[SelList[a].oId].Name <> '' then
           nametemp:= nametemp + ': ' + VScene.Actors[SelList[a].oId].Name;
         b:= 0;
       end;
       otPoint: begin
         nametemp:= 'Point' + nametemp;
         if VScene.Points[SelList[a].oId].Name <> '' then
           nametemp:= nametemp + ': ' + VScene.Points[SelList[a].oId].Name;
         b:= 1;
       end;
       otZone:  begin
         nametemp:= 'Zone' + nametemp;
         if VScene.Zones[SelList[a].oId].RealType = ztSceneric then
           nametemp:= nametemp + ' (' + IntToStr(VScene.Zones[SelList[a].oId].VirtualID) + ')';
         if VScene.Zones[SelList[a].oId].Name <> '' then
           nametemp:= nametemp + ': ' + VScene.Zones[SelList[a].oId].Name;
         b:= Byte(VScene.Zones[SelList[a].oId].RealType) + 2;
       end;
     end;
     //nametemp:= nametemp + ' ' + IntToStr(SelList[a].oId);
     //If (SelList[a].oType = otZone)
     //and (VScene.Zones[SelList[a].oId].ZoneType = 2) then
     //  nametemp:= nametemp + ' (' + IntToStr(VScene.Zones[SelList[a].oId].Info0) + ')';
     mScObjSelect.Items.Insert(a + 1,
       NewItem(nametemp, 0, False, True, mSSelectNothingClick, 0, 'mSSel' + IntToStr(a)));
     mScObjSelect.Items[a+1].ImageIndex:= b;
     mScObjSelect.Items[a+1].Tag:= Byte(SelList[a].oType)*10000 + SelList[a].oId;
     CompMods.UpdateComponent(mScObjSelect.Items[a+1]);
   end;
   mScObjSelect.Tag:= IfThen(DblClicked, 1, 0);
   pt:= pbGrid.ClientToScreen(Point(X, Y));
   AFlags:= Flags[UseRightToLeftAlignment, mScObjSelect.Alignment]
         or Buttons[mScObjSelect.TrackButton]
         or (Byte(mScObjSelect.MenuAnimation) shl 10);
   //This is to make the menu avoid mouse position, so that double click is possible      
   MParams.cbSize:= sizeof(MParams);
   MParams.rcExclude:= Rect(pt.X-2, pt.Y-2, pt.X+3, pt.Y+3);
   TrackPopupMenuEx(mScObjSelect.Handle, AFlags, pt.X, pt.Y,
     PopupList.Window, @MParams);
   //mScObjSelect.Popup(pt.X+1, pt.Y+1);
 end;
end;

procedure TfmMain.ShowGridSelMenu(X, Y: Integer);
var a: Integer;
    pt: TPoint;
begin
 mGCopyTo.Clear();
 mGCopyTo.Enabled:= Length(LdMaps) > 1;
 if mGCopyTo.Enabled then
   for a:= 0 to High(LdMaps) do begin
     if a = cbFragment.ItemIndex then Continue;
     if a = 0 then mGCopyTo.Add(NewItem('Main Grid', 0, False, True, mGSelAllClick,
       0, 'mGCopyTo' + IntToStr(a)))
     else mGCopyTo.Add(NewItem('Fragment ' + IntToStr(a), 0, False, True,
       mGSelAllClick, 0, 'mGCopyTo' + IntToStr(a)));
     mGCopyTo.Items[mGCopyTo.Count-1].Tag:= a;
     CompMods.UpdateComponent(mGCopyTo.Items[mGCopyTo.Count-1]);
   end;
 pt:= pbGrid.ClientToScreen(Point(X, Y));
 mGRight.Popup(pt.X, pt.Y);
end;

procedure TfmMain.VScrScroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
 If ScrollCode = scEndScroll then Exit;
 If Sender = HScr then ScrollMap(ScrollPos - HScr.Position,0)
 else if Sender = VScr then ScrollMap(0,ScrollPos - VScr.Position);
end;

procedure TfmMain.FormResize(Sender: TObject);
//var a, b: Integer;
begin
 {a:=imgBuffer.Width;
 b:=imgBuffer.Height;}
 {$ifndef NO_BUFFER}SetDimensions(bufMain, pbGrid.Width, pbGrid.Height);{$endif}
 SetDimensions(imgLts, pbLts.Width, pbLts.Height);
 If not pbGrid.Visible then Exit;
 ActiveControl:= nil;
 If GImgW > pbGrid.Width then begin
   HScr.Enabled:= True;
   HScr.Max:= GImgW;
   HScr.PageSize:= pbGrid.Width;
 end
 else begin
   HScr.Position:= 0;
   HScr.Enabled:= False;
 end;
 If GImgH > pbGrid.Height then begin
   VScr.Enabled:= True;
   VScr.Max:= GImgH;
   VScr.PageSize:= pbGrid.Height;
 end
 else begin
   VScr.Position:= 0;
   VScr.Enabled:= False;
 end;

 DrawMapA();
 {If a<pbGrid.Width then DrawFragment(a+HScr.Position,VScr.Position,
  pbGrid.Width+HScr.Position,pbGrid.Height+VScr.Position);
 If b<pbGrid.Height then DrawFragment(HScr.Position,b+VScr.Position,
  pbGrid.Width-a+HScr.Position,pbGrid.Height+VScr.Position);}
 if LayoutMap[High(LayoutMap)] > pbLts.Height - 2 then begin
   LScr.Enabled:= True;
   LScr.Max:= LayoutMap[High(LayoutMap)] - 2;
   LScr.PageSize:= pbLts.Height;
 end
 else begin
   LScr.Position:= 0;
   LScr.Enabled:= False;
 end;
 PaintLayouts();
 frLtClip.SetClipWndPos();
 SetCoordsPos();
end;

procedure TfmMain.pbGridPaint(Sender: TObject);
begin
 {$ifdef NO_BUFFER}
 DrawMapA();
 {$else}
 UpdateImage(bufMain,pbGrid);
 {$endif}
end;

{procedure TForm1.CopyData(var Msg: TWMCopyData); //Scene Mode (deprecated, subject to remove)
begin
 If not SceneMode then Msg.Result:= 1 else SceneMessage(Msg);
end;}

procedure TfmMain.FormCreate(Sender: TObject);
begin
 lnkMantis:= TLink.Create(Self);
 lnkMantis.Parent:= paDummy;
 lnkMantis.SetBounds(189, 288, 264, 19);
 lnkMantis.Cursor:= crHandPoint; lnkMantis.Caption:= 'http://sacredcarrot.xesf.net/mantis/';
 lnkMantis.Font.Charset:= DEFAULT_CHARSET; lnkMantis.Font.Color:= clSkyBlue;
 lnkMantis.Font.Height:= -16; lnkMantis.Font.Name:= 'Arial'; lnkMantis.Font.Style:= [fsBold];
 lnkMantis.ParentFont:= False; lnkMantis.Transparent:= True;
 lnkMantis.LinkStyle.Normal.Color:= clSkyBlue; lnkMantis.LinkStyle.Normal.Style:= [fsBold];
 lnkMantis.LinkStyle.Hover.Color:= clWhite; lnkMantis.LinkStyle.Hover.Style:= [fsBold, fsUnderline];
 lnkMantis.LinkStyle.Pressed.Color:= clWhite; lnkMantis.LinkStyle.Pressed.Style:= [fsBold, fsUnderline];
 lnkMantis.Address:= 'http://sacredcarrot.xesf.net/mantis/';
 seScMaxLayer_:= TfrBetterSpin.Create(Self);
 seScMaxLayer_.Name:= 'seScMaxLayer_';  seScMaxLayer_.Parent:= GroupBox1;
 seScMaxLayer_.SetBounds(35, 80, 35, 22);
 seScMaxLayer_.Hint:= 'Draw only to specified layer|Disables drawing of layers above the specified one';
 seScMaxLayer_.Setup(0, 24, 0);  seScMaxLayer_.OnChange:= btMaxLayer_Click;
 seMaxLayer_:= TfrBetterSpin.Create(Self);
 seMaxLayer_.Name:= 'seMaxLayer_';  seMaxLayer_.Parent:= GroupBox4;
 seMaxLayer_.SetBounds(34, 79, 35, 22);
 seMaxLayer_.Hint:= 'Draw only to specified layer|Disables drawing of layers above the specified one';
 seMaxLayer_.Setup(0, 24, 0);  seMaxLayer_.OnChange:= btMaxLayer_Click;
 seAX:= TfrBetterSpin.Create(Self);
 seAX.Name:= 'seAX';  seAX.Parent:= paAdv;
 seAX.SetBounds(19, 22, 35, 22);
 seAX.Color:= $FFBE00;
 seAX.Setup(1, 64, 1);  seAX.OnChange:= seAXChange;
 seAY:= TfrBetterSpin.Create(Self);
 seAY.Name:= 'seAY';  seAY.Parent:= paAdv;
 seAY.SetBounds(19, 46, 35, 22);
 seAY.Color:= clYellow;
 seAY.Setup(1, 25, 1);  seAY.OnChange:= seAXChange;
 seAZ:= TfrBetterSpin.Create(Self);
 seAZ.Name:= 'seAZ';  seAZ.Parent:= paAdv;
 seAZ.SetBounds(19, 70, 35, 22);
 seAZ.Color:= clLime;
 seAZ.Setup(1, 64, 1);  seAZ.OnChange:= seAXChange;
 sePlaceLayer:= TfrBetterSpin.Create(Self);
 sePlaceLayer.Name:= 'sePlaceLayer';  sePlaceLayer.Parent:= gbPlaceOpts;
 sePlaceLayer.SetBounds(101, 83, 41, 22);
 sePlaceLayer.Hint:= 'Adjusts vertical position of layout being placed';
 sePlaceLayer.Setup(0, 24, 0);  sePlaceLayer.OnChange:= btSelBrkClick;
 seX:= TfrBetterSpin.Create(Self);
 seX.Name:= 'seX';  seX.Parent:= gbCreateInvisi;
 seX.SetBounds(24, 32, 41, 22);
 seX.Color:= $FFBE00;
 seX.Setup(1, 64, 1);
 seY:= TfrBetterSpin.Create(Self);
 seY.Name:= 'seY';  seY.Parent:= gbCreateInvisi;
 seY.SetBounds(24, 56, 41, 22);
 seY.Color:= clYellow;
 seY.Setup(1, 25, 1);
 seZ:= TfrBetterSpin.Create(Self);
 seZ.Name:= 'seZ';  seZ.Parent:= gbCreateInvisi;
 seZ.SetBounds(24, 80, 41, 22);
 seZ.Color:= clLime;
 seZ.Setup(1, 64, 1);
 
 {$ifdef NO_BUFFER}bufMain:= Form1.pbGrid;{$endif}
 lbVersion.Caption:= 'Version ' + ReadProgramVersion(ThisIsBeta);
 lbBetaInfo.Visible:= ThisIsBeta;
 lnkMantis.Visible:= False; //ThisIsBeta; --link no longer working
 if Special then begin
   lbVersion.Visible:= False;
   lbDisclaimer.Visible:= False;
   lbSpecial.Caption:= 'Version ' + SpecialVer + #13
                     + 'Special Build - DO NOT DISTRIBUTE, please';
   lbSpecial.Visible:= True;                  
 end;
 paSplash.BringToFront();

 frLtClip:= TfrClipping.Create(Self);
 frLtClip.Parent:= Self;
 frSceneObj:= TfrSceneObj.Create(Self);
 frSceneObj.Parent:= paObjInspector;

 bufMain.Canvas.Brush.Color:= clBlack;
 bufMain.Canvas.Pen.Color:= clWhite;
 bufThumb.Canvas.Brush.Color:= clBlack;
 imgLts.Canvas.Brush.Color:= clBtnFace;
 bufMain.Canvas.Pen.Color:= clRed;
 bufMain.Canvas.Font.Style:= [fsBold];
 bufMain.Canvas.Font.Name:= 'Courier New';
 bufMain.Canvas.Font.Size:= 20;
 paLayout.DoubleBuffered:= True;
 paGrid.DoubleBuffered:= True;
 frLtClip.DoubleBuffered:= True;
 paCoords.DoubleBuffered:= True;
 Screen.Cursors[crHand]:= LoadCursor(hInstance,'Z1_CRHAND');
 btHandClick(Self);
 Application.OnMessage:= AppMessage;
 DragAcceptFiles(Handle, True);
 {$ifndef DEBUG_LOG}
   aDebugLog.Visible:= False;
 {$endif}  

 EnableControls(False); //Disable everything I might have forgot about :)
 DblClicked:= False;
end;

procedure TfmMain.UpdateCoordsPanel();
begin
 if ProgMode = pmScene then
   paCoords.Visible:= Sett.Controls.Coords and (SceneTool <> stHand)
 else
   paCoords.Visible:= Sett.Controls.Coords and (GridTool <> gtHand);
 paCoords.Realign();
 SetCoordsPos();
end;

procedure TfmMain.btFrames_Click(Sender: TObject);
begin
 if UpdatingControls then Exit;
 if (Sender = btFrames_) or (Sender = btScFrames_) then
   Sett.Controls.Frames:= (Sender as TSpeedButton).Down
 else if (Sender = btNet_) or (Sender = btScNet_) then
   Sett.Controls.Net:= (Sender as TSpeedButton).Down
 else if (Sender = btShowInv_) or (Sender = btScShowInv_) then
   Sett.Controls.Invisi:= (Sender as TSpeedButton).Down
 else if (Sender = cbPlacedFr1) or (Sender = cbPlacedFr2) then
   Sett.Controls.GPlacedFr:= (Sender as TCheckBox).Checked
 else if (Sender = cbCursor1) or (Sender = cbCursor2) then
   Sett.Controls.GCursor:= (Sender as TCheckBox).Checked
 else if (Sender = cbHelper1) or (Sender = cbHelper2) or (Sender = cbHelper3) then
   Sett.Controls.GHelper:= (Sender as TCheckBox).Checked
 else if (Sender = cbHelp3D1) or (Sender = cbHelp3D2) or (Sender = cbHelp3D3) then
   Sett.Controls.GHelp3D:= (Sender as TCheckBox).Checked
 else if Sender = mViewShapes then
   Sett.Controls.Physical:= mViewShapes.Checked;

 cbHelp3D1.Enabled:= Sett.Controls.GHelper;
 cbHelp3D2.Enabled:= Sett.Controls.GHelper;
 cbHelp3D3.Enabled:= Sett.Controls.GHelper;
 DrawMapA();
end;

procedure TfmMain.btCoords_Click(Sender: TObject);
begin
 if UpdatingControls then Exit;
 if Assigned(Sender) then  
 //if (Sender = btCoords) or (Sender = btScCoords_) then begin
   Sett.Controls.Coords:= (Sender as TSpeedButton).Down;
 //end

 UpdateCoordsPanel();
end;

procedure TfmMain.btMaxLayer_Click(Sender: TObject);
begin
 if (Sender = seMaxLayer_) and seMaxLayer_.ValueOK then
   mDeleteLayer.Caption:= 'Delete Layer ' + IntToStr(seMaxLayer_.Value);
 if UpdatingControls then Exit;
 if Sender is TSpeedButton then
   Sett.Controls.MaxLayerEna:= (Sender as TSpeedButton).Down
 else if Sender is TfrBetterSpin then
   Sett.Controls.MaxLayer:= (Sender as TfrBetterSpin).ReadValueDef();

 if Sett.Controls.MaxLayerEna then
   HiVisLayer:= Sett.Controls.MaxLayer
 else
   HiVisLayer:= GHiY;

 DrawMapA();
end;

procedure TfmMain.btSelBrkClick(Sender: TObject);
begin
 if (Sender = btSelBrk) or (Sender = btSelCol) or (Sender = btSelObj) then begin
        if btSelBrk.Down then Sett.Controls.GSelMode:= smBrick
   else if btSelCol.Down then Sett.Controls.GSelMode:= smColumn
   else if btSelObj.Down then Sett.Controls.GSelMode:= smObject;
 end
 else if (Sender = btSelFnt) or (Sender = btSelFne) then
   Sett.Controls.GSelNTrans:= btSelFnt.Down
 else if Sender = sePlaceLayer then
   Sett.Controls.GPlaceLayer:= sePlaceLayer.ReadValueDef()
 else if (Sender = btInvBrk) or (Sender = btInvObj) then
   Sett.Controls.GInvModeBrk:= btInvBrk.Down
end;

procedure TfmMain.cbFramesLtClick(Sender: TObject);
begin
 if UpdatingControls then Exit;
 if Assigned(Sender) then
   Sett.Controls.GLayoutFr:= cbFramesLt.Checked;
 PaintLayouts();
 frLtClip.pbImage.Repaint();
end;

procedure TfmMain.aSettingsExecute(Sender: TObject);
begin
 fmSettings.ShowSettings(nil);
end;

procedure TfmMain.pbThumbPaint(Sender: TObject);
begin
 bufThumb.Canvas.BrushCopy(Rect(152-29,0,152,22),imgAxes.Picture.Bitmap,Rect(0,0,28,22),clFuchsia);
 UpdateImage(bufThumb,pbThumb);
 If HScr.Enabled or VScr.Enabled then begin
   pbThumb.Canvas.Brush.Color:=clRed;
   pbThumb.Canvas.FrameRect(Bounds(Trunc((HScr.Position*152)/GImgW),Trunc((VScr.Position*96)/GImgH),
     Trunc((pbGrid.Width*152)/GImgW),Trunc((pbGrid.Height*96)/GImgH)));
 end;
end;

procedure TfmMain.aExportBMPExecute(Sender: TObject);
var drive: String;
begin
 If not MainMapIsGrid then begin
   Application.MessageBox('Fragment exporting feature is not yet implemented. Sorry.','Export',MB_ICONINFORMATION + MB_OK);
   Exit;
 end;  

 DlgSave.Title:= 'Export current image as bitmap';
 DlgSave.FileName:= '';
 DlgSave.Filter:= 'Bitmaps (*.bmp)|*.bmp';
 DlgSave.InitialDir:= Sett.General.LastExpDir;

 If DlgSave.Execute then begin
   drive:= ExtractFileDrive(DlgSave.FileName);
   If (drive[1] in ['A'..'Z']) and (DiskFree(Byte(drive[1]) - 64) < 6046078) then
     Application.MessageBox('Not enough free space in the target drive.'#13'Exported bitmap requires at least 5.8MB (6 046 078 bytes) of free space.','Export',MB_ICONERROR+MB_OK)
   else
     ExportGridToBitmap(DlgSave.FileName);
 end;
end;

procedure TfmMain.aFileListExecute(Sender: TObject);
begin
 TfmCurrentFiles.ShowDialog();
end;

procedure TfmMain.pbThumbMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 pbThumbMouseMove(Self,Shift,X,Y);
end;

procedure TfmMain.pbThumbMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var NewX, NewY: Integer;
begin
 If ssLeft in Shift then begin
   NewX:= Trunc((X+1)*(GImgW/152) - pbGrid.Width/2);
   NewY:= Trunc((Y+1)*(GImgH/96) - pbGrid.Height/2);
   ScrollMap(NewX-HScr.Position, NewY-VScr.Position);
   HScr.Position:= NewX;
   VScr.Position:= NewY;
 end;
end;

procedure TfmMain.aExitExecute(Sender: TObject);
begin
 Close();
end;

procedure TfmMain.pbLtsPaint(Sender: TObject);
begin
 If pbGrid.Visible then UpdateImage(imgLts,pbLts);
end;

procedure TfmMain.LScrChange(Sender: TObject);
begin
 PaintLayouts();
end;

procedure TfmMain.pbLtsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var a: Integer;
begin
 for a:= 0 to High(LayoutMap) do
   If LayoutMap[a] > Y + LScr.Position + 1 then Break;
 LtSel:= a;
 PaintLayouts();
 frLtClip.ChangePlaceObj();
end;

procedure TfmMain.Splitter1CanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
 if ProgMode = pmGrid then begin
   pbLts.Visible:= NewSize > 50;
   pbLts.Width:= paLayout.Width - LScr.Width - 4;
   if GridTool = gtPlace then begin
     Sett.Controls.GLastLtPos:= IfThen(NewSize > 50, NewSize, 1);
   end
   else begin
     Sett.Controls.GLtAlwaysOn:= NewSize > 50;
     Sett.Controls.GLastLtPos:= IfThen(NewSize > 50, NewSize, 100);
   end;
 end
 else if ProgMode = pmScene then begin
   Sett.Controls.SLastOiPos:= IfThen(NewSize > 50, NewSize, 100);
 end;  
end;

procedure TfmMain.btHandClick(Sender: TObject);
begin
 if btHand.Down then GridTool:= gtHand
 else if btSelect.Down then GridTool:= gtSelect
 else if btPlace.Down then GridTool:= gtPlace
 else if btInvisi.Down then GridTool:= gtInvisi;
 ResetControls(False);
 UpdateButtons();     
 pbGrid.Cursor:= crDefault;
 ToolOpts.Visible:= True;
 frLtClip.Visible:= False;
 paAdv.Visible:= False;
 UpdateCoordsPanel();
 if not ((GridTool = gtPlace) or Sett.Controls.GLtAlwaysOn) then begin
   pbLts.Visible:= False;
   paLeftSide.Width:= 1;
 end;
 If (GridTool <> gtInvisi) and GInvPlacing then InvPlacingEnd();
 If not (GridTool in [gtSelect, gtInvisi]) then GObjCopied:= False;
 case GridTool of
   gtHand: begin
     pbGrid.Cursor:= crHand;
     ToolOpts.Visible:= False;
   end;
   gtSelect: ToolOpts.ActivePage:= SelOpts;
   gtPlace: begin
     If (Sett.Controls.GLastLtPos > 1) then begin
       paLeftSide.Width:= Sett.Controls.GLastLtPos;
       pbLts.Width:= paLayout.Width - LScr.Width - 4;
       pbLts.Visible:= True;
     end;
     frLtClip.ChangePlaceObj();
     ToolOpts.ActivePage:= PlaceOpts;
     frLtClip.InitClipping();
   end;
   gtInvisi: ToolOpts.ActivePage:= InvOpts;
 end;
 FormResize(Self);
end;

procedure TfmMain.aHintsExecute(Sender: TObject);
begin
 if Sender = aHints then
   Sett.Controls.Hints:= aHints.Checked;
 paHint.Visible:= Sett.Controls.Hints;
 FormResize(Self);
end;

procedure TfmMain.DeleteSelectedArea();
begin
 if GHasSelection then begin
   DelPiece(CMap^, GSelect);
   PutPiece(CMap^, GPlacePos.x, GPlacePos.y, GPlacePos.z, BufObj, False);
   GObjCopied:= False;
   GHasSelection:= False;
   SetMapModified(CMap^);
   DrawPieceBrk(GSelect.x1, GSelect.y1, GSelect.z1, GSelect.x2-GSelect.x1+1,
     GSelect.y2-GSelect.y1+1, GSelect.z2-GSelect.z1+1);
 end;    
end;

procedure TfmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var tmp: TObjType;
    //tmpGFHMoving, tmpGVHMoving: Boolean;
    NewPt: TPoint3d;
begin
 if SZoneResizing then Exit;
 DrawPieceBrk(GSelect.x1,GSelect.y1,GSelect.z1,
   GSelect.x2-GSelect.x1+1,GSelect.y2-GSelect.y1+1,GSelect.z2-GSelect.z1+1,dmRemember);
 if (ProgMode = pmScene) and not Assigned(SPrevBtn) then begin
   case SceneTool of
     stHand: SPrevBtn:= btScHand;
     stSelect: SPrevBtn:= btScEdit;
     stAddActor: SPrevBtn:= btScAddActor;
     stAddZone: SPrevBtn:= btScAddZone;
     else SPrevBtn:= btScAddTrack;
   end;
 end;
 if ProgMode = pmScene then begin
   KeyHandled:= True;
   case Key of
     46: if not (ActiveControl is TfrBetterSpin)  //Del
         and (SceneTool = stSelect) and (SelType <> otNone) then begin
           tmp:= SelType;
           SelType:= otNone;
           SceneUndoSetPoint(VScene);
           case tmp of
             otPoint: DeleteTrack(SelId);
             otActor: DeleteActor(SelId);
             otZone: DeleteZone(SelId);
           end;
         end;
     16: If ProgMode = pmScene then begin
           If ssCtrl in Shift then btScAddActor.Down:= True
           else btScAddTrack.Down:= True;
           btScHandClick(Sender);
         end;
     17: If (ProgMode = pmScene) and (ssShift in Shift) then begin
           btScAddActor.Down:= True;
           btScHandClick(Sender);
         end;
     else KeyHandled:= False;
   end;
 end
 else begin //Grid Mode
   if GridTool in [gtSelect, gtInvisi] then begin
     KeyHandled:= True;
     //fmMain.Caption:= IntToStr(Key);
     NewPt:= GPlacePos;
     case Key of
        46: DeleteSelectedArea(); //Del
        65: mGSelAllClick(mGSelAll); //Ctrl + A (Ctrl checking inside)
        VK_NUMPAD3: if ssCtrl in Shift then begin //x+ resize selection
                      if GSelect.x2 >= CMap^.X - 1 then Exit;
                      Inc(GSelect.x2);
                    end else begin //move selection
                      if GSelect.x2 >= CMap^.X - 1 then Exit;
                      Inc(GSelect.x1);
                      {if GSelect.x2 < CMap^.X then} Inc(GSelect.x2);
                   { end else begin //move selected block
                      if NewPt.x >= CMap^.X - 1 then Exit;
                      Inc(NewPt.x);}
                    end;
       VK_NUMPAD7: if ssCtrl in Shift then begin //x- resize selection
                      if GSelect.x2 < GSelect.x1 + 1 then Exit;
                      Dec(GSelect.x2);
                    end else begin //move selection
                      if GSelect.x1 < 1 then Exit;
                      Dec(GSelect.x1);
                      Dec(GSelect.x2);
                    end;

       VK_NUMPAD1: if ssCtrl in Shift then begin //z+ resize selection
                      if GSelect.z2 >= CMap^.Z - 1 then Exit;
                      Inc(GSelect.z2);
                    end else begin //move selection
                      if GSelect.z2 >= CMap^.Z - 1 then Exit;
                      Inc(GSelect.z1);
                      Inc(GSelect.z2);
                    end;
       VK_NUMPAD9: if ssCtrl in Shift then begin //z- resize selection
                      if GSelect.z2 < GSelect.z1 + 1 then Exit;
                      Dec(GSelect.z2);
                    end else begin //move selection
                      if GSelect.z1 < 1 then Exit;
                      Dec(GSelect.z1);
                      Dec(GSelect.z2);
                    end;

       VK_NUMPAD8: if ssCtrl in Shift then begin //y+ resize selection
                      if GSelect.y2 >= CMap^.Y - 1 then Exit;
                      Inc(GSelect.y2);
                    end else begin //move selection
                      if GSelect.y2 >= CMap^.Y - 1 then Exit;
                      Inc(GSelect.y1);
                      Inc(GSelect.y2);
                    end;
       VK_NUMPAD2: if ssCtrl in Shift then begin //y- resize selection
                      if GSelect.y2 < GSelect.y1 + 1 then Exit;
                      Dec(GSelect.y2);
                    end else begin //move selection
                      if GSelect.y1 < 1 then Exit;
                      Dec(GSelect.y1);
                      Dec(GSelect.y2);
                    end;
       else KeyHandled:= False;
     end;
     if Key in [VK_NUMPAD3, VK_NUMPAD7, VK_NUMPAD1, VK_NUMPAD9, VK_NUMPAD8, VK_NUMPAD2] then begin
       //if [ssCtrl, ssShift] * Shift <> [] then begin
         GSelecting:= True;
         pbGridMouseUp(pbGrid, mbLeft, [], 0, 0);
         DrawPieceBrk(GSelect.x1,GSelect.y1,GSelect.z1,
           GSelect.x2-GSelect.x1+1,GSelect.y2-GSelect.y1+1,GSelect.z2-GSelect.z1+1, dmMerge);
         UpdateCoords();
       {end else begin
         if (GridTool in [gtSelect, gtInvisi])
         and not GFHMoving and not GFVMoving and not GSelecting and GHasSelection then begin
           MapCreateUndo(CMap^);
           PutPiece(CMap^, GPlacePos.x, GPlacePos.y, GPlacePos.z, BufObj, False);
           DrawPieceBrk(GSelect.x1, GSelect.y1, GSelect.z1, GSelect.x2-GSelect.x1+1,
             GSelect.y2-GSelect.y1+1, GSelect.z2-GSelect.z1+1, dmRemember);
           UpdateCoords();

           Inc(GPlacePos.x);
           GLastPlacePos:= GPlacePos;

           BufObj:= CopyPiece(CMap^, GPlacePos.x, GPlacePos.y, GPlacePos.z,
                                     PlaceObj.X, PlaceObj.Y, PlaceObj.Z);
           PutPiece(CMap^, GPlacePos.x, GPlacePos.y, GPlacePos.z, PlaceObj);
           SetMapModified(CMap^);
           GSelect:= Box(GPlacePos.x, GPlacePos.y, GPlacePos.z, GPlacePos.x+PlaceObj.X-1,
                         GPlacePos.y+PlaceObj.Y-1, GPlacePos.z+PlaceObj.Z-1);
           GLastSelect:= GSelect;
           GCursor:= Box(-1, -1, -1, -1, -1, -1);
           DrawPieceBrk(GSelect.x1, GSelect.y1, GSelect.z1, GSelect.x2-GSelect.x1+1,
                        GSelect.y2-GSelect.y1+1,GSelect.z2-GSelect.z1+1,dmMerge);
         end;
       end; }
     end;  
   end;
 end;

 if KeyHandled then Key:= 0;
end;

procedure TfmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
 If KeyHandled then Key:= #0;
 KeyHandled:= False;
end;

procedure TfmMain.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 If SZoneResizing then Exit;
 If (ProgMode = pmScene) and Assigned(SPrevBtn) then begin
   case Key of
     16: begin
           SPrevBtn.Down:= True;
           btScHandClick(Sender);
           SPrevBtn:= nil;
         end;
     17: If ssShift in Shift then begin
           btScAddTrack.Down:= True;
           btScHandClick(Sender);
         end;
   end;
 end
 else SPrevBtn:= nil;
end;

function TfmMain.SaveMapAs(var Map: TComplexMap): Boolean;
var ext: ShortString;
begin
 ext:= LowerCase(ExtractFileExt(Map.FilePath));
 Result:= False;
 if Map.IsGrid then begin
   DlgSave.InitialDir:= Sett.General.LastSaveDir;
   DlgSave.Title:= 'Save ' + Map.Name + ' as Grid';
   if (ext <> '.hqr') and (Map.FilePath <> '') then DlgSave.FileName:= Map.FilePath
   else
     DlgSave.FileName:= Format('(lib=%d)',
       [ IfThen(LBAMode = 2, CurrentLibIndex+1, GriToBll1[CurrentLibIndex]+1) ]);
   DlgSave.Filter:= 'LBA 1 Grid file (*.gr1)|*.gr1|'+
                    'LBA 2 Grid file (*.gr2)|*.gr2';
   if LBAMode = 2 then DlgSave.FilterIndex:= 2 else DlgSave.FilterIndex:= 1;
   if DlgSave.Execute then
     Result:= SaveGrid(Map, Map.IsMainMap, EnsureFileExt(DlgSave.FileName, IfThen(DlgSave.FilterIndex=1, '.gr1', '.gr2')));
 end
 else begin
   DlgSave.Title:= 'Save ' + Map.Name + ' as LBA 2 Fragment';
   DlgSave.InitialDir:= Sett.General.LastSaveDir;
   if ext <> '.hqr' then DlgSave.FileName:= Map.FilePath
   else DlgSave.FileName:= Format('(lib=%d)', [CurrentLibIndex+1]);
   DlgSave.Filter:= 'LBA 2 Fragment (*.grf)|*.grf';
   if DlgSave.Execute then
     Result:= SaveGrid(Map, Map.IsMainMap, EnsureFileExt(DlgSave.FileName, '.grf'));
 end;
end;

function TfmMain.SaveMapAuto(var Map: TComplexMap): Boolean;
begin
 if Map.FilePath = '' then
   Result:= SaveMapAs(Map)
 else
   Result:= SaveGrid(Map, Map.IsMainMap, Map.FilePath, Map.FileIndex);
end;

procedure TfmMain.aSaveGridExecute(Sender: TObject);
begin
 SaveMapAuto(CMap^);
end;

procedure TfmMain.aSaveGridAsExecute(Sender: TObject);
begin
 SaveMapAs(CMap^);
end;

procedure TfmMain.aSaveScenarioExecute(Sender: TObject);
begin
 If CurrentScenarioFile = '' then
   aSaveScenarioAsExecute(Sender)
 else
   SaveScenario(CurrentScenarioFile);
end;

procedure TfmMain.aSaveScenarioAsExecute(Sender: TObject);
begin
  DlgSave.Title:= 'Save Scenario as';
  DlgSave.FileName:= ChangeFileExt(ExtractFileName(CurrentScenarioFile), '.hqs');
  DlgSave.Filter:= 'High Quality Scenarios (*.hqs)|*.hqs';
  DlgSave.DefaultExt:= '.hqs';
  DlgSave.InitialDir:= Sett.General.LastScenarioDir;
  if DlgSave.Execute then begin
    Sett.General.LastScenarioDir:= ExtractFilePath(DlgSave.FileName);
    SaveScenario(DlgSave.FileName);
  end;
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not CheckModified(True) then Action:= caNone;
end;

procedure TfmMain.aNewExecute(Sender: TObject);
begin
 {If fmOpen.ShowDialog() = mrOK then begin
   CheckModified();
   EnableControls(False);
   btNet.Down:= True;
   Screen.Cursor:= crHourGlass;
   SetLength(VScenario,0);
   OpenFiles();
   If not NoProgress then ProgBarForm.ShowSpecial('Loading files...', Form1, True);
   Grid.Lba2:= fmOpen.rb12.Checked
           or (fmOpen.rb13.Checked and (ExtIs(LibPath,'bl2') or IsBkg(LibPath)));
   Grid.LibIndex:= StrToIntDef(fmOpen.eLibIndex.Text, 0);
   Grid.FragIndex:= StrToIntDef(fmOpen.eFragIndex.Text, 0);
   SetMapsLengths(63, 24, 63);
   ClearMap();
   FindLba2Invisible(VLibrary);
   OpenFinalize(True);
   If fmOpen.rbSceneMode.Checked then GoSceneMode();
 end;}
end;

procedure TfmMain.aOpenSimExecute(Sender: TObject);
var m: Integer;
begin
 if fmOpenSim.ShowDialogMain() then begin
   if CheckModified(False) then begin
     EnableControls(False);
     Screen.Cursor:= crHourGlass;
     SetLength(PkScenario, 0);
     If not NoProgress then ProgBarForm.ShowSpecial('Loading files...', fmMain, True);

     SetLength(LdMaps, 0); //should have been already done, but it won't hurt
     m:= CreateNewMap(True);
     if m >= 0 then begin
       CMap:= @LdMaps[m];
       fmOpenSim.OpenSimpleFiles(CMap^);

       OpenFinalize();
       SetScenarioState(False);
       If fmOpenSim.rbSceneMode.Checked then GoSceneMode();
     end else
       EnableControls(False);
   end;
 end;
end;

procedure TfmMain.aOpenExecute(Sender: TObject);
begin
 If fmOpen.ShowDialog(False) = mrOK then begin
   if CheckModified(False) then begin
     EnableControls(False);
     Screen.Cursor:= crHourGlass;
     SetLength(PkScenario, 0);
     If not NoProgress then ProgBarForm.ShowSpecial('Loading files...', fmMain, True);

     fmOpen.OpenFiles(); //It also initializes the LdMaps

     OpenFinalize();
     SetScenarioState(False);
     If fmOpen.rbSceneMode.Checked then GoSceneMode();
   end;
 end;
end;

function TfmMain.OpenScenarioFile(path: String): Boolean;
var MissingFiles: Boolean;
begin
 Result:= False;
 if CheckModified(False) then begin
   EnableControls(False);
   Sett.General.LastScenarioDir:= ExtractFilePath(path);
   //If not NoProgress then ProgBarForm.ShowSpecial('Loading files...',Form1,True);
   If OpenScenario(path, MissingFiles) then begin
     CMap:= @LdMaps[0];
     OpenFinalize(MissingFiles); //MissingFiles tells if the S is modified
     SetScenarioState(True);
     GoGridMode(); //TODO: correct this after fixing the dialog
     Result:= True;
   end;
   RefreshMapList();
   if Length(LdMaps) > 0 then cbFragment.ItemIndex:= 0
                         else cbFragment.ItemIndex:= -1;
   cbFragmentChange(nil);
   UpdateProgramName();
   AddToRecent(path);
 end;
end;

procedure TfmMain.aOpenScenarioExecute(Sender: TObject);
var ScenDlg: TOpenDialog; //TOpenScenarioDialog;
begin
 //TODO: Fix the dialog
 ScenDlg:= TOpenDialog.Create(fmMain); //TOpenScenarioDialog.Create(Form1);
 ScenDlg.Options:= [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing];
 ScenDlg.Title:= 'Open Scenario';
 ScenDlg.FileName:= '';
 ScenDlg.Filter:= 'High Quality Scenarios (*.hqs)|*.hqs';
 ScenDlg.InitialDir:= Sett.General.LastScenarioDir;
 If ScenDlg.Execute then begin
   OpenScenarioFile(ScenDlg.FileName);
 end;
 ScenDlg.Free();
end;

procedure TfmMain.mOpenRecentScenarioClick(Sender: TObject);
begin
 OpenScenarioFile(Sett.General.RecentScenarios[(Sender as TMenuItem).Tag]);
end;

procedure TfmMain.tmHintMsgTimer(Sender: TObject);
begin
 tmHintMsg.Enabled:= False;
 lbHints.Caption:= '';
end;

procedure TfmMain.AppException(Sender: TObject; E: Exception);
begin
 if ProgBarForm.Visible or not Enabled then ProgBarForm.CloseSpecial;
 if fmSettings.Visible then fmSettings.Close();
 Screen.Cursor:= crDefault;
 Application.MessageBox(PChar(ProgramName+' have risen an exception called: "'+E.Message+'" and may be unstable. Please save your work and restart the program as soon as possible.'),ProgramName,MB_ICONWARNING+MB_OK);
end;

procedure TfmMain.AppShowHint(Sender: TObject);
begin
 PutHint(Application.Hint); //StrToIntDef(Application.Hint, -1));
end;

procedure TfmMain.btInvNewClick(Sender: TObject);
var a, b, c: Integer;
    Invisible: TMapItem;
begin
 If GInvPlacing then InvPlacingEnd()
 else begin
  If LBAMode = 2 then begin
    if Lba2Invisible.Idx.Lt > 0 then Invisible:= Lba2Invisible
    else begin
      Application.MessageBox('It seems that current library doesn''t contain any invisible bricks, sorry.',ProgramName,MB_ICONINFORMATION+MB_OK);
      Exit;
    end;
  end
  else Invisible:= Lba1Invisible;
  fmMain.seX.Enabled:= False;
  fmMain.seY.Enabled:= False;
  fmMain.seZ.Enabled:= False;
  PlaceObj.X:= seX.ReadValueDef();
  PlaceObj.Y:= seY.ReadValueDef();
  PlaceObj.Z:= seZ.ReadValueDef();
  SetLength(PlaceObj.Map,PlaceObj.X,PlaceObj.Y,PlaceObj.Z);
  for c:= 0 to PlaceObj.Z - 1 do
   for b:= 0 to PlaceObj.Y - 1 do
    for a:= 0 to PlaceObj.X - 1 do
     PlaceObj.Map[a,b,c]:= Invisible;
  GInvPlacing:= True;
  btInvNew.Caption:= 'Cancel';
 end;
end;

procedure TfmMain.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var Delta: Integer;
begin
 Delta:= - Sign(WheelDelta) * Sett.Mouse.WheelSpeed;
 MousePos:= fmMain.ScreenToClient(MousePos);
 If (MousePos.X > 0) and (MousePos.Y > 0)
 and (MousePos.X <= paLayout.Width) and (MousePos.Y <= paLayout.Height) then begin
   If Sett.Mouse.InvertY then Delta:= - Delta;
   If Abs(WheelDelta) > Sett.Mouse.WheelAverage then Delta:= Delta * 3;
   LScr.Position:= LScr.Position + Delta;
 end
 else begin
   If Abs(WheelDelta) <= Sett.Mouse.WheelAverage then begin
     If Sett.Mouse.InvertY then Delta:= - Delta;
     ScrollMap(0,Delta);
   end
   else begin
     If Sett.Mouse.InvertX then Delta:= - Delta;
     ScrollMap(Delta,0);
   end;
 end;
 Handled:= True;
end;

procedure TfmMain.GridUndoSetButtons();
begin
 aUndo.Enabled:= Assigned(CMap) and (CMap^.Id > 0);
 aRedo.Enabled:= Assigned(CMap) and (CMap^.Id < CMap^.Max);
end;

procedure TfmMain.aUndoExecute(Sender: TObject);
begin
 if Active then begin
   if ProgMode = pmScene then begin
     SelectObject(otNone, 0);
     if Sender = aUndo then SceneDoUndo(VScene)
                       else SceneDoRedo(VScene);
     ComputeAllDispInfo(VScene);
     MakeObjectsDispList();
     frSceneObj.InitSceneObj();
   end else begin
     GObjCopied:= False;
     if Sender = aUndo then MapDoUndo(CMap^)
                       else MapDoRedo(CMap^);
     GridUndoSetButtons();
     //GSelect:= Box(-1, -1, -1, -1, -1, -1);
     GHasSelection:= False;
     UpdateThumbBack(True);
   end;
   DrawMapA();
 end
 else if fmScriptEd.Active then begin
   if fmScriptEd.ActiveControl = fmScriptEd.seLifeScript then begin
     if Sender = aUndo then fmScriptEd.btUndoRedoClick(fmScriptEd.btLifeUndo)
                       else fmScriptEd.btUndoRedoClick(fmScriptEd.btLifeRedo);
   end
   else if fmScriptEd.ActiveControl = fmScriptEd.seTrackScript then begin
     if Sender = aUndo then fmScriptEd.btUndoRedoClick(fmScriptEd.btTrackUndo)
                       else fmScriptEd.btUndoRedoClick(fmScriptEd.btTrackRedo);
   end;
 end;
end;

procedure TfmMain.lbCoordsClick(Sender: TObject);
begin
 Sett.Controls.Coords:= False;
 UpdateButtons();
end;

procedure TfmMain.btDeleteClick(Sender: TObject);
var layer, a, b: Integer;
begin
 layer:= Sett.Controls.MaxLayer;
 if Sett.General.AskDelLayer
 and not QuestYesNo(Format('Delete all contents of layer %d?',[layer])) then Exit;
 MapCreateUndo(CMap^);
 For b:= 0 to GHiZ do
   for a:= 0 to GHiX do
     CMap^.M^[a, layer, b]:= EmptyMapItem;
 SetMapModified(CMap^);
 DrawMapA();
 UpdateThumbBack(True);
end;

procedure TfmMain.btAlX0Click(Sender: TObject);
var c: Integer;
begin
 If Sender is TSpeedButton then begin
   c:= StrToInt((Sender as TSpeedButton).Name[6]);
   frLtClip.Invert[c]:= not frLtClip.Invert[c];
 end;
 If frLtClip.Invert[0] then btAlX0.Glyph.LoadFromResourceName(0, 'ALTOPLEFT')
 else btAlX0.Glyph.LoadFromResourceName(0, 'ALBTMRIGHT');
 If frLtClip.Invert[1] then btAlY1.Glyph.LoadFromResourceName(0, 'ALBOTTOM')
 else btAlY1.Glyph.LoadFromResourceName(0, 'ALTOP');
 If frLtClip.Invert[2] then btAlZ2.Glyph.LoadFromResourceName(0, 'ALTOPRIGHT')
 else btAlZ2.Glyph.LoadFromResourceName(0, 'ALBTMLEFT');
 frLtClip.SetClipExpand();
end;

procedure TfmMain.seAXChange(Sender: TObject);
begin
 frLtClip.SetClipExpand();
end;

procedure TfmMain.ThumbTimerTimer(Sender: TObject);
begin
 ThumbTimer.Enabled:= False;
 if ThumbCounter < 0 then begin //first do draft updating
   CreateThumbnail(True);
   pbThumbPaint(nil);
   ThumbCounter:= 0;
   ThumbTimer.Enabled:= True;
 end else begin
   CreateThumbnail(False, 0, ThumbCounter, ThumbSizeX - 1, ThumbCounter);
   Inc(ThumbCounter);
   If ThumbCounter >= ThumbSizeY - 1 then begin
     pbThumbPaint(nil);
     ThumbCounter:= 0;
   end
   else ThumbTimer.Enabled:= True;
 end;
end;

//{$o-} //Testing
procedure TfmMain.btTestClick(Sender: TObject);
var Lba, FirstScene: Integer;
    a, b, c, d, e: Integer;
    ScenesPack: TPackEntries;
    Scenes: array of TScene;
    ScnTemp: TScene;
    line: String;
    Err: Boolean;
    temp: Byte;
begin
  Lba:= 2;
  FirstScene:= IfThen(Lba = 1, 0, 1);
  if CheckFile(Lba_SCENE, Lba) then begin
    if OpenPack(GetFilePath(Lba_SCENE, Lba), ScenesPack, FirstScene) then begin
      Application.ProcessMessages();
      line:= IntToStr(Length(ScenesPack));
      OutputDebugString('RESAVE TEST');
      OutputDebugString(PChar(Format('Loading Scenes (LBA%d)...', [Lba])));
      UnpackAll(ScenesPack);
      SetLength(Scenes, Length(ScenesPack));
      for a:= 0 to High(Scenes) do
        Scenes[a]:= LoadSceneFromString(ScenesPack[a].Data, Lba);
    end else begin
      OutputDebugString('Could not open Scene file!');
      Exit;
    end;
  end else begin
    OutputDebugString('Scene check failed!');
    Exit;
  end;
  //Scenes loaded and decompiled
  //Now compile them back
  Err:= False;
  (*for a:= 0 to High(Scenes) do begin
    ScnTemp:= Scenes[a];
    ScnTemp.Actors:= Copy(Scenes[a].Actors); //Otherwise the scripts will be linked only!
    for b:= 0 to High(ScnTemp.Actors) do begin
      ScnTemp.Actors[b].TrackScriptBin:= '';
      ScnTemp.Actors[b].LifeScriptBin:= '';
    end;
    if fmScriptEd.CompileAllScripts(Lba, ScnTemp) then begin
      for b:= 0 to High(ScnTemp.Actors) do begin
        if ScnTemp.Actors[b].TrackScriptBin <> Scenes[a].Actors[b].TrackScriptBin then begin
          for c:= 1 to Length(ScnTemp.Actors[b].TrackScriptBin) do
            if ScnTemp.Actors[b].TrackScriptBin[c] <> Scenes[a].Actors[b].TrackScriptBin[c] then
              OutputDebugString(PChar(Format('Scene %d Actor %d Track Script binary mismatch at offset %d!', [a, b, c-1])));
          Err:= True;
        end;
        if ScnTemp.Actors[b].LifeScriptBin <> Scenes[a].Actors[b].LifeScriptBin then begin
          if Length(ScnTemp.Actors[b].LifeScriptBin) <> Length(Scenes[a].Actors[b].LifeScriptBin) then
            OutputDebugString(PChar(Format('Scene %d Actor %d Life Script binary length mismatch!', [a, b, c-1])));
          d:= Min(Length(ScnTemp.Actors[b].LifeScriptBin), Length(Scenes[a].Actors[b].LifeScriptBin));
          e:= 0;
          for c:= 1 to d do begin
            if ScnTemp.Actors[b].LifeScriptBin[c] <> Scenes[a].Actors[b].LifeScriptBin[c] then begin
              if (c > 1) and (ScnTemp.Actors[b].LifeScriptBin[c-1] = #117) //LBA2 BREAK command
              and (ReadWordFromBinStr(ScnTemp.Actors[b].LifeScriptBin, c) - ReadWordFromBinStr(Scenes[a].Actors[b].LifeScriptBin, c) = 3)
              then begin
                OutputDebugString(PChar(Format('Scene %d Actor %d Life Script allowed difference found at offset %d!', [a, b, c-1])));
                OutputDebugString(PChar(Format('Org = %d, New = %d', [ReadWordFromBinStr(Scenes[a].Actors[b].LifeScriptBin, c), ReadWordFromBinStr(ScnTemp.Actors[b].LifeScriptBin, c)])));
              end
              else begin
                OutputDebugString(PChar(Format('Scene %d Actor %d Life Script binary mismatch at offset %d!', [a, b, c-1])));
                Inc(e);
                Err:= True;
              end;
            end;
            if e >= 15 then Break;
          end;
        end;
        if Err then Break;
      end;
      if Err then
        Break
      else
        OutputDebugString(PChar(Format('Scene %d Scripts are binary identical.', [a, b])));
    end
    else begin
      OutputDebugString(PChar(Format('Scene %d compilation error!', [a])));
      //fmScriptEd.OpenScripts(0);
      //fmScriptEd.lbMessagesDblClick(fmScriptEd.lbMessages);
      Break;
    end;
  end;*)
  for a:= 0 to High(Scenes) do begin
    line:= SceneProjectToString(Scenes[a], Lba);
    if LoadSceneProjectString(line, temp, ScnTemp) then begin
      if fmScriptEd.CompileAllScripts(Lba, ScnTemp) then begin
        line:= SceneToString(ScnTemp, Lba);
        if line <> ScenesPack[a].Data then begin
          if Length(line) <> Length(ScenesPack[a].Data) then
            OutputDebugString(PChar(Format('Scene %d binary length mismatch!', [a])));
          d:= Min(Length(line), Length(ScenesPack[a].Data));
          e:= 0;
          for c:= 1 to d do begin
            if line[c] <> ScenesPack[a].Data[c] then begin
              OutputDebugString(PChar(Format('Scene %d binary mismatch at offset %d!', [a, c-1])));
              Inc(e);
              Err:= True;
            end;
            if e >= 5 then Break;
          end;
          if Err then Break;
        end;
        if Err then
          Break
        else
          OutputDebugString(PChar(Format('Scenes %d are binary identical.', [a])));
      end else
        OutputDebugString(PChar(Format('Scene %d - compilation error!', [a])));
    end else
      OutputDebugString(PChar(Format('Scene %d - error loading from text project!', [a])));
  end;
  OutputDebugString('END OF RESAVE TEST');
  Screen.Cursor:= crDefault;
end;
//{$o+}

procedure TfmMain.aAboutExecute(Sender: TObject);
begin
 fmAbout.ShowModal();
end;

procedure TfmMain.aSceneHelpExecute(Sender: TObject);
begin
 //WinExec(PChar('hh '+ExtractFilePath(Application.ExeName)+'help\Scenes.chm::/html/overview.htm'), SW_SHOW);
 HtmlHelp(Application.Handle, PChar(AppPath + 'help\Scenes.chm'),
   HH_DISPLAY_TOPIC, Cardinal(PChar('/html/overview.htm')));
end;

procedure TfmMain.btScVisibleClick(Sender: TObject);
begin
  if SZoneSelecting then Exit;
  TfmSceneVis.ShowDialog();
end;

procedure TfmMain.btScHandClick(Sender: TObject);
begin
 if btScHand.Down then SceneTool:= stHand
 else if btScEdit.Down then SceneTool:= stSelect
 else if btScAim.Down then SceneTool:= stAim
 else if btScAddActor.Down then SceneTool:= stAddActor
 else if btScAddTrack.Down then SceneTool:= stAddTrack
 else if btScAddZone.Down then SceneTool:= stAddZone;

 pbGrid.Cursor:= crDefault;
 //UpdateButtons();
 frSceneObj.Visible:= False;
 If SceneTool = stHand then pbGrid.Cursor:= crHand;
 If SceneTool in [stHand, stSelect] then frSceneObj.InitSceneObj();
 {else if btScEdit.Down then begin

 end};
 //FormResize(Self);
 UpdateCoordsPanel();
 if Sender = btScAddActor then begin
   if (ssAlt in KeyboardStateToShiftState()) then
     UseActorTpl:= False
   else begin
     UseActorTpl:= fmActorTpl.SelectTemplateDialog();
     while UseActorTpl
     and not LoadActorFromTemplate(fmActorTpl.TplSelName, ActorTemplate) do begin
       ErrorMsg('Error while trying to load the selected template!');
       UseActorTpl:= fmActorTpl.SelectTemplateDialog();
     end;
   end;  
 end;
end;

procedure TfmMain.aScenarioPropExecute(Sender: TObject);
begin
 if fmScenarioProp.ShowDialog(LBAMode = 2, PkScenario, 0, HQSInfo.InfoText, ScenarioDesc, False)
 then SetScenarioModified();
end;

procedure TfmMain.VScrChange(Sender: TObject);
begin
 If HScr.Enabled then GScrX:= HScr.Position else GScrX:= 0;
 If VScr.Enabled then GScrY:= VScr.Position else GScrY:= 0;
end;

procedure TfmMain.aSceneModeExecute(Sender: TObject);
begin
 If GPlacing or GVMoving or GSelecting or GFHMoving or GFVMoving or GInvPlacing
 or (SMvType <> otNone) or SZoneResizing then
   Beep()
 else if ProgMode = pmScene then GoGridMode() else GoSceneMode();
end;

procedure TfmMain.btScVisibleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var tType: TObjType;
    tId: Integer;
begin
  if Button = mbRight then begin
    tType:= SelType;
    tId:= SelId;
    if TfmSelect.ShowSceneSelector(tType, tId) then
      SelectObject(tType, tId);
  end;
end;

procedure TfmMain.mSSelectNothingClick(Sender: TObject);
var tag, sl: Integer;
    ot: TObjType;
begin
  tag:= (Sender as TMenuItem).Tag;
  if tag = -2 then
    SelectObject(otNone, 0)
  else begin
    case tag div 10000 of
      1: ot:= otPoint;
      2: ot:= otZone;
      3: ot:= otActor;
      else Exit;
    end;
    sl:= tag mod 10000;
    SelectObject(ot, sl);
    if ((Sender as TMenuItem).GetParentMenu.Tag <> 0) and (ot = otActor) then begin
      fmScriptEd.OpenScripts(sl);
      fmScriptEd.BringToFront();
    end;
  end;
end;

procedure TfmMain.frSceneObjPropsseZXChange(Sender: TObject);
begin
  frSceneObj.seZXChange(Sender);
end;

procedure TfmMain.tmHighlightTimer(Sender: TObject);
begin                           // dopoprawiaæ pokazywanie, ¿eby by³o ³adniejsze
 tmHighlight.Enabled:= False;
 If SceneHLRec.Stage = hsMoving then begin
   Dec(SceneHLRec.Counter);
   If SceneHLRec.Counter >= 0 then begin
     DrawHighlightMarks(SceneHLRec.MarkingsRect, False);
     InflateRect(SceneHLRec.MarkingsRect, - SceneHLRec.MovingStepX, - SceneHLRec.MovingStepY);
     DrawHighlightMarks(SceneHLRec.MarkingsRect, True);
   end
   else begin
     SceneHLRec.Stage:= hsBlinking;
     SceneHLRec.Counter:= 10;
     tmHighlight.Interval:= 140;
   end;
 end
 else if SceneHLRec.Stage = hsBlinking then begin
   Dec(SceneHLRec.Counter);
   If SceneHLRec.Counter >= 0 then begin
     If SceneHLRec.Counter mod 3 = 0 then
       DrawHighlightMarks(SceneHLRec.MarkingsRect, False)
     else if (SceneHLRec.Counter + 1) mod 3 = 0 then
       DrawHighlightMarks(SceneHLRec.MarkingsRect, True);
   end
   else
     SceneHLRec.Stage:= hsOff;
 end;
 tmHighlight.Enabled:= SceneHLRec.Stage <> hsOff;
end;

procedure TfmMain.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
 If GetKeyState(VK_CONTROL) < 0 then begin //if Ctrl is pressed
   case Msg.CharCode of
     Ord('H'): if ProgMode = pmScene then begin
                 btScHand.Down:= True;
                 btScHandClick(btScHand);
               end else begin
                 btHand.Down:= True;
                 btHandClick(btHand);
               end;
     Ord('P'): if ProgMode = pmGrid then begin
                 btPlace.Down:= True;
                 btHandClick(btPlace);
               end;
     Ord('L'): if ProgMode = pmGrid then begin
                 btSelect.Down:= True;
                 btHandClick(btSelect);
               end;
     Ord('I'): If ProgMode = pmGrid then begin
                 btInvisi.Down:= True;
                 btHandClick(btInvisi);
               end;
     Ord('E'): if ProgMode = pmScene then begin
                 btScEdit.Down:= True;
                 btScHandClick(btScEdit);
               end;

   end;
 end;
end;

procedure TfmMain.aScenePropExecute(Sender: TObject);
begin
 fmSceneProp.EditProperties(VScene);
end;

procedure TfmMain.aSaveSceneExecute(Sender: TObject);
begin
 If CurrentSceneFile = '' then
   aSaveSceneAsExecute(Sender)
 else
   SaveScene(CurrentSceneFile, CurrentSceneIndex);
end;

procedure TfmMain.aSaveSceneAsExecute(Sender: TObject);
var ext: ShortString;
begin
 Assert(Length(LdMaps) > 0, 'fmMain.aSaveSceneAs: LdMaps = empty');
 ext:= LowerCase(ExtractFileExt(CurrentSceneFile));
 DlgSave.Title:= 'Save Scene';
 if (ext <> '.hqr') and (CurrentSceneFile <> '') then
   DlgSave.FileName:= CurrentSceneFile
 else
   DlgSave.FileName:= Format('(gri=%d)', [LdMaps[0].FileIndex + 1]);
 DlgSave.Filter:= 'LBA 1 Binary Scene (*.ls1)|*.ls1'
               //+ '|LBA 2 grid file (*.gr2)|*.gr2'
               + '|Scene Text Project (*.stp)|*.stp';
 //If Grid.Lba2 then DlgSave.FilterIndex:= 2 else DlgSave.FilterIndex:= 1;
 if SceneLoadedFromText then DlgSave.FilterIndex:= 2 else DlgSave.FilterIndex:= 1;
 DlgSave.InitialDir:= Sett.General.LastSaveDir;
 if DlgSave.Execute then
   SaveScene(ChangeFileExt(DlgSave.FileName,IfThen(DlgSave.FilterIndex=1,'.ls1','.stp')));
end;

//Drag & Drop

procedure TfmMain.WMDropFiles(hDrop: THandle; hWindow: HWnd);
var TotalNumberOfFiles, nFileLength: Integer;
    pszFileName: PChar;
    DropPoint: TPoint;
begin
  //number of files
  TotalNumberOfFiles:= DragQueryFile(hDrop, $FFFFFFFF, nil, 0);
  If TotalNumberOfFiles = 1 then begin
    nFileLength:= DragQueryFile(hDrop, 0, Nil, 0) + 1;
    GetMem(pszFileName, nFileLength);
    DragQueryFile(hDrop, 0, pszFileName, nFileLength);
    DragQueryPoint(hDrop, DropPoint);
    //If FindControl(hWindow).Name = 'TForm1' then begin
      If ExtIs(pszFileName, '.hqs') then begin
        OpenScenarioFile(pszFileName)
      end
      else
        Application.MessageBox('Wrong file extension!'#13#13'Only High Quality Scenarios (*.hqs) can be opened by drag & drop.', 'Little Big Architect', MB_ICONERROR or MB_OK);
    //end
    //else
    //  Beep();

    FreeMem(pszFileName, nFileLength);
  end
  else
   Application.MessageBox('Only one file may be dropped at a time!', 'Little Big Architect', MB_ICONERROR or MB_OK);

  DragFinish(hDrop);
end;

procedure TfmMain.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
  case Msg.Message of
    WM_DROPFILES: WMDropFiles(Msg.wParam, Msg.hWnd);
  end;
end;

procedure TfmMain.aManageTplsExecute(Sender: TObject);
begin
 fmActorTpl.ManageTemplatesDialog();
end;

procedure TfmMain.UpdateButtons();
begin
 UpdatingControls:= True;
 btFrames_.Down:= Sett.Controls.Frames;
 btScFrames_.Down:= Sett.Controls.Frames;
 btNet_.Down:= Sett.Controls.Net;
 btScNet_.Down:= Sett.Controls.Net;
 btCoords_.Down:= Sett.Controls.Coords;
 btScCoords_.Down:= Sett.Controls.Coords;
 UpdateCoordsPanel();
 btShowInv_.Down:= Sett.Controls.Invisi;
 btScShowInv_.Down:= Sett.Controls.Invisi;
 btMaxLayer_.Down:= Sett.Controls.MaxLayerEna;
 btScMaxLayer_.Down:= Sett.Controls.MaxLayerEna;
 seMaxLayer_.Value:= Restrict(Sett.Controls.MaxLayer, 0, GHiY);
 seScMaxLayer_.Value:= Restrict(Sett.Controls.MaxLayer, 0, GHiY);

 case Sett.Controls.GSelMode of
   smBrick: btSelBrk.Down:= True;
   smColumn: btSelCol.Down:= True;
   smObject: btSelObj.Down:= True;
 end;
 if Sett.Controls.GSelNTrans then btSelFnt.Down:= True
                             else btSelFne.Down:= True;
 cbPlacedFr1.Checked:= Sett.Controls.GPlacedFr;
 cbPlacedFr2.Checked:= Sett.Controls.GPlacedFr;
 cbCursor1.Checked:= Sett.Controls.GCursor;
 cbCursor2.Checked:= Sett.Controls.GCursor;
 cbHelper1.Checked:= Sett.Controls.GHelper;
 cbHelper2.Checked:= Sett.Controls.GHelper;
 cbHelper3.Checked:= Sett.Controls.GHelper;
 cbHelp3D1.Checked:= Sett.Controls.GHelp3D;
 cbHelp3D2.Checked:= Sett.Controls.GHelp3D;
 cbHelp3D3.Checked:= Sett.Controls.GHelp3D;
 cbFramesLt.Checked:= Sett.Controls.GLayoutFr;
 sePlaceLayer.Value:= Restrict(Sett.Controls.MaxLayer, 0, GHiY);
 if Sett.Controls.GInvModeBrk then btInvBrk.Down:= True
                              else btInvObj.Down:= True;
 mViewShapes.Checked:= Sett.Controls.Physical;
 aHints.Checked:= Sett.Controls.Hints;

 case Sett.Controls.GClippingPos of
   crTopLeft: frLtClip.btPosTL.Down:= True;
   crTopRight: frLtClip.btPosTR.Down:= True;
   crBtmLeft: frLtClip.btPosBL.Down:= True;
   else frLtClip.btPosBR.Down:= True;
 end;
 frLtClip.btReset.Down:= Sett.General.ResetClip;

 frSceneObj.acAutoFind.Checked:= Sett.Controls.SObjAutoFind;

 UpdatingControls:= False;
end;

procedure TfmMain.pcControlsDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
 //if Active then Control.Canvas.Font.Color:= clBlue;
end;

procedure TfmMain.pcControlsChange(Sender: TObject);
begin
 //ActivePage = where we are going
 if not MainMapIsGrid and (pcControls.ActivePage = tsScene) then begin
   pcControls.ActivePageIndex:= pcControls.Tag; //Return to the old tab
   WarningMsg('Scene Mode is not available when editing an LBA 2 Fragment!');
 end
 else begin
   if GPlacing or GVMoving or GSelecting or GFHMoving or GFVMoving or GInvPlacing
   or (SMvType <> otNone) or SZoneResizing then begin
     pcControls.ActivePageIndex:= pcControls.Tag; //Return to the old tab
     Beep();
   end
   else begin
     if pcControls.ActivePage = tsScene then begin
       if not GoSceneMode() then
         pcControls.ActivePageIndex:= pcControls.Tag; //Return to the old tab
     end else if pcControls.ActivePage = tsFragTest then begin
       //GoFragTestMode();
       pcControls.ActivePageIndex:= pcControls.Tag; //Return to the old tab
       WarningMsg('This mode is not yet implemented!');
     end else
       GoGridMode();
   end;
 end;
end;

procedure TfmMain.pcControlsChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
 pcControls.Tag:= pcControls.ActivePageIndex; //Where we were
end;

procedure TfmMain.aCreateFragExecute(Sender: TObject);
var id: Integer;
begin
 id:= CreateNewMap(True);
 if id >= 0 then begin
   InitMap(LdMaps[id], 64, 25, 64); //TODO: make it aware of LBA2 Framgents
   LdMaps[id].IsGrid:= LbaMode = 1;
   LdMaps[id].Compression:= 0;
   cbFragment.ItemIndex:= id;
   cbFragmentChange(nil);
   SetScenarioModified();
 end;
end;

procedure TfmMain.aDebugLogExecute(Sender: TObject);
begin
  DebugLogShowDialog();
end;

Procedure TfmMain.UpdateProgramName();
var a: Integer;
    GMod: Boolean;
    temp, name: String;
begin
 name:= ProgramName;
 if Length(LdMaps) > 0 then begin
   case ProgMode of
     pmScene:    temp:= 'Scene';
     pmGrid:     temp:= 'Grid';
     pmFragTest: temp:= 'Fragment testing';
   end;
   name:= name + ' - Lba ' + IntToStr(LBAMode) + ' - ' + temp + ' Mode ';

   If ScenarioState then begin
     GMod:= False;
     for a:= 0 to High(LdMaps) do
       if LdMaps[a].Modified then begin
         GMod:= True;
         Break;
       end;
     name:= name + '[Scenario';
     if CurrentScenarioFile <> '' then
       name:= name + ' :: ' + ExtractFileName(CurrentScenarioFile);
     name:= name + IfThen(ScenarioModified or GMod or SceneModified, '*') + ']';
   end else begin
     temp:= '';
     for a:= 1 to High(LdMaps) do
       temp:= temp + ', F' + IntToStr(a) + IfThen(LdMaps[a].Modified, '*');
     name:= name + '[Main Grid' + IfThen(LdMaps[0].Modified, '*') + temp
                 + ', Scene' + IfThen(SceneModified, '*') + ']';
   end;
 end;
 fmMain.Caption:= name;
 Application.Title:= name;
end;

procedure TfmMain.SetLBAMode(NewLBA: Byte);
begin
 LBAMode:= NewLBA;
 UpdateProgramName();
end;

procedure TfmMain.RefreshMapList();
var a, b: Integer;
begin
 b:= cbFragment.ItemIndex;
 cbFragment.Clear();
 if Length(LdMaps) > 0 then begin
   if MainMapIsGrid then begin
     for a:= 0 to High(LdMaps) do
       cbFragment.AddItem(IntToStr(a) + ': ' + LdMaps[a].Name, nil);
     if b < 0 then cbFragment.ItemIndex:= 0
     else if b >= cbFragment.Items.Count then
       cbFragment.ItemIndex:= cbFragment.Items.Count - 1
     else cbFragment.ItemIndex:= b;
   end else begin
     cbFragment.AddItem('0: Fragment', nil);
     cbFragment.ItemIndex:= 0;
   end;
 end;
 cbFragment.Enabled:= Length(LdMaps) > 1;
 UpdateComboBox(cbFragment);
 SelectMap(cbFragment.ItemIndex);
end;

procedure TfmMain.cbFragmentChange(Sender: TObject);
begin
 SelectMap(cbFragment.ItemIndex);
end;

procedure TfmMain.cbFragmentDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
 if odDisabled in State then begin
   (Control as TComboBox).Canvas.Brush.Color:= clWindow;
   (Control as TComboBox).Canvas.Font.Color:= clBtnFace;
 end else begin
   if odSelected in State then begin
     (Control as TComboBox).Canvas.Brush.Color:= clHighlight;
     (Control as TComboBox).Canvas.Font.Color:= clHighlightText;
   end else begin
    (Control as TComboBox).Canvas.Brush.Color:= clWindow;
    (Control as TComboBox).Canvas.Font.Color:= clWindowText;
   end;
 end;  

 (Control as TComboBox).Canvas.FillRect(Rect);
 if Index = 0 then
   (Control as TComboBox).Canvas.Font.Style:= [fsBold]
 else
   (Control as TComboBox).Canvas.Font.Style:= [];
 //InflateRect(Rect, -2, -2);
 //(Control as TComboBox).Canvas.Brush.Style:= bsClear;
 (Control as TComboBox).Canvas.TextOut(Rect.Left+1, Rect.Top + 1,
   (Control as TComboBox).Items[Index]);
 //(Control as TComboBox).Canvas.Brush.Style:= bsSolid;
 //(Control as TComboBox).Canvas.Rectangle(0,0,0,0); //Workaround for focus rect problem
end;

procedure TfmMain.mGSelAllClick(Sender: TObject);
var CtrlPressed: Boolean;
begin
 CtrlPressed:= ssCtrl in KeyboardStateToShiftState();
 if Sender = mGSelAll then begin
   GSelect:= Box(0, 0, 0, CMap^.X - 1, CMap^.Y - 1, CMap^.Z - 1);
   GLastSelect:= GSelect;
   GPlacePos:= Point3D(0, 0, 0);
   GHasSelection:= True;
   GSelecting:= True;
   pbGridMouseUp(pbGrid, mbLeft, [], 0, 0);
   DrawMapA();
 end else if Sender = mGSelNone then begin
   GHasSelection:= False;
   GObjCopied:= False;
   DrawPieceBrk(GSelect.x1, GSelect.y1, GSelect.z1, GSelect.x2-GSelect.x1+1,
     GSelect.y2-GSelect.y1+1, GSelect.z2-GSelect.z1+1);
 end else if Sender = mGDelSel then
   DeleteSelectedArea()
 else if Sender = mGNewFrag then
   NewFragmentFromSel(not CtrlPressed)
 else begin //Copy selection to Fragment...
   CopySelToFragment((Sender as TMenuItem).Tag, not CtrlPressed);
   //if not CtrlPressed then DeleteSelectedArea();
 end;
end;

procedure TfmMain.CopySelToFragment(Target: Integer; DelOrg: Boolean);
var temp: TPoint3d;
begin
 if not GHasSelection then Exit;
 if DelOrg then
   PutPiece(CMap^, GPlacePos.x, GPlacePos.y, GPlacePos.z, BufObj, False);
 temp:= GPlacePos; //Will be reset in SelectMap()
 cbFragment.ItemIndex:= Target;
 SelectMap(Target); //Sel coords shouldn't be cleared here
 GPlacePos:= temp; //Restore some variables after reset
 GObjCopied:= True;
 GHasSelection:= True;
 GFHMoving:= True;
 MapCreateUndo(CMap^);
 pbGridMouseUp(pbGrid, mbLeft, [], 0, 0);
end;

procedure TfmMain.NewFragmentFromSel(DelOrg: Boolean);
var temp: TPoint3d;
begin
 if not GHasSelection then Exit;
 if DelOrg then
   PutPiece(CMap^, GPlacePos.x, GPlacePos.y, GPlacePos.z, BufObj, False);
 temp:= GPlacePos; //Will be reset in aCreateFragExecute()
 aCreateFragExecute(nil); //Sel coords shouldn't be cleared here
 GPlacePos:= temp; //Restore some variables after reset
 GObjCopied:= True;
 GHasSelection:= True;
 GFHMoving:= True;
 CopySelToFragment(cbFragment.ItemIndex, False);
 SetScenarioModified();
end;

procedure TfmMain.UpdateFileMenu();
begin
 if Assigned(CMap) then begin
   aSaveGrid.Caption:= 'Save ' + CMap^.Name;
   aSaveGridAs.Caption:= 'Save ' + CMap^.Name + ' as...';
 end;  
end;

procedure TfmMain.mmFileClick(Sender: TObject);
begin
 //Program enters here always when the submenu is going to be displayed,
 //  i.e. when clicking by the mouse, when clicking another menu and
 //  navigating by arrow keys to this one, and finally when using
 //  Alt + M shortcut.
 fmMain.aSelToFrag.Enabled:= GHasSelection;
end;

procedure TfmMain.aSelToFragExecute(Sender: TObject);
begin
 NewFragmentFromSel(False);
end;

procedure TfmMain.aOpenFragExecute(Sender: TObject);
begin
 if fmOpenSim.ShowDialogFrag() and not fmOpenSim.rbLba2.Checked then begin
   aCreateFragExecute(nil);
   if fmOpenSim.rbLba1.Checked then
     OpenGrid(GetFilePath(Lba1_GRI,1), GridList1[Sett.OpenDlg.GrSimFCIndex],
       LdLibrary, CMap^)
   else if fmOpenSim.rbLba2.Checked then begin
     //p:= BkgEntriesCount(GetFilePath(Lba2_BKG,2), itGrids);
     //OpenGrid(GetFilePath(Lba2_BKG, 2), grSimCombo.ItemIndex + p.x - 1, LdLibrary, Map);
   end
   else //rb23 - custom Grid
     OpenGrid(Sett.OpenDlg.GrSimGrPath, Sett.OpenDlg.GrSimGrIndex, LdLibrary, CMap^);

   ResetControls();
   CMap^.Modified:= False; //This should have been already set by InitMap()
   //fmMain.UpdateProgramName();
   SetScenarioModified();
   DrawMapA();
 end;
end;

procedure TfmMain.aCloseFragExecute(Sender: TObject);
begin
 if QuestYesNo('Remove ' + CMap^.Name + ' from the opened maps?'#13'(This will also remove it from the Scenario if a Scenario is opened)') then begin
   if CMap^.Modified then
     case Application.MessageBox(PChar(CMap^.Name + ' has been changed. Save?'), ProgramName, MB_ICONQUESTION+MB_YESNOCANCEL) of
       ID_YES: begin
         fmMain.aSaveGrid.Execute();
         if CMap^.Modified then Exit; //User cancelled saving, so don't close the Frag
       end;
       ID_CANCEL: Exit;
     end;
   //Now we're clear to close the Fragment
   CloseMap(cbFragment.ItemIndex);
 end;  
end;

procedure TfmMain.aBatchAnalyseExecute(Sender: TObject);
begin
  fmBatchAnalyse.ShowDialog();
end;

procedure TfmMain.aCloseAllExecute(Sender: TObject);
begin
 if CheckModified(False) then EnableControls(False);
end;

initialization
 {$ifndef NO_BUFFER}
   bufMain:= TBitmap.Create();
   bufMain.pixelformat:= pf24bit;
   bufMain.Transparent:= False;
 {$endif}
 bufThumb:= TBitmap.Create();
 bufThumb.PixelFormat:= pf24bit;
 bufThumb.Transparent:= False;
 bufThumb.Width:= ThumbSizeX;
 bufThumb.Height:= ThumbSizeY;

finalization
 {$ifndef NO_BUFFER} bufMain.Free(); {$endif}
 bufThumb.Free();

end.
