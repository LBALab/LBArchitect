//******************************************************************************
// Little Big Architect: Builder - editing grid files containing rooms
//                                 in Little Big Adventure 1 & 2
//*
// This is the main program file.
//*
// Copyright Zink
// e-mail: zink@poczta.onet.pl
//*
// This source code is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//*
// This source code is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License (License.txt) for more details.
//******************************************************************************

//Conditional compilation constants:
// NO_BUFFER - Disables double buffering when drawing Grid (drawing will
//   be performed directly on pbGrid's canvas). For debugging only.

// Note: define the constants in Project -> Options -> Directories/Confitionals
// If defined in the code using the {$define ...} directive, because they
//   are visible in one unit only.
// Don't forget to rebuild all after changing one of the defines.

program Builder;

uses
  FastMM4 in '..\Libs\FastMM4\FastMM4.pas',
  SysUtils,
  StrUtils,
  Windows,
  Forms,
  Main in 'Main.pas' {fmMain},
  ProgBar in '..\Libs\ProgBar.pas' {ProgBarForm},
  Settings in 'Settings.pas' {fmSettings},
  Open in 'Open.pas' {fmOpen},
  Rendering in 'Rendering.pas',
  Engine in '..\Libs\Engine.pas',
  Hints in 'Hints.pas',
  OpenSim in 'OpenSim.pas' {fmOpenSim},
  Clipping in 'Clipping.pas' {frClipping: TFrame},
  ListDialog in 'ListDialog.pas' {fmListForm},
  Scene in 'Scene.pas',
  Grids in '..\Libs\Grids.pas',
  Libraries in '..\Libs\Libraries.pas',
  DePack in '..\Libs\DePack.pas',
  About in 'About.pas' {fmAbout},
  Bricks in 'Bricks.pas',
  ScenarioProp in '..\Libs\ScenarioProp.pas' {fmScenarioProp},
  HQDesc in '..\Libs\HQDesc.pas',
  ListForm in '..\Libs\ListForm.pas' {fmList},
  Select in 'Select.pas' {fmSelect},
  scLifeScript1HL in 'SceneLib\scLifeScript1HL.pas',
  scTrackScript1HL in 'SceneLib\scTrackScript1HL.pas',
  ScriptEd in 'SceneLib\ScriptEd.pas' {fmScriptEd},
  SceneLib in 'SceneLib\SceneLib.pas',
  SceneObj in 'SceneObj.pas' {frSceneObj: TFrame},
  ImgExport in 'ImgExport.pas',
  ActorInfo in 'ActorInfo.pas',
  ComboMod in '..\Libs\ComboMod.pas',
  SceneProp in 'SceneProp.pas' {fmSceneProp},
  ExitSave in 'ExitSave.pas' {fmExitSave},
  ScenarioDlg in 'ScenarioDlg.pas',
  SceneUndo in 'SceneUndo.pas',
  Utils in '..\Libs\Utils.pas',
  Globals in 'Globals.pas',
  ActorTpl in 'ActorTpl.pas' {fmActorTpl},
  TplName in 'Dialogs\TplName.pas' {fmTplName},
  SceneLibComp in 'SceneLib\SceneLibComp.pas',
  SceneLibConst in 'SceneLib\SceneLibConst.pas',
  Scenario in 'Scenario.pas',
  Maps in 'Maps.pas',
  brace in '..\Libs\brace.pas',
  Link in '..\Components\Link\Link.pas',
  OpenDirectory in '..\Components\OpenDirectory\OpenDirectory.pas',
  PathEdit in '..\Components\PathEdit\PathEdit.pas',
  SynEdit in '..\Components\SynEdit\Source\SynEdit.pas',
  DFSClrBn in '..\Components\TdfsColorButton\DFSClrBn.pas',
  CBtnForm in '..\Components\TdfsColorButton\CBtnForm.pas' {DFSColorButtonPalette},
  SynEditTextBuffer in '..\Components\SynEdit\Source\SynEditTextBuffer.pas',
  SynEditHighlighter in '..\Components\SynEdit\Source\SynEditHighlighter.pas',
  SynEditKeyConst in '..\Components\SynEdit\Source\SynEditKeyConst.pas',
  SynHighlighterMulti in '..\Components\SynEdit\Source\SynHighlighterMulti.pas',
  SynEditStrConst in '..\Components\SynEdit\Source\SynEditStrConst.pas',
  SynRegExpr in '..\Components\SynEdit\Source\SynRegExpr.pas',
  SynEditKbdHandler in '..\Components\SynEdit\Source\SynEditKbdHandler.pas',
  SynEditKeyCmds in '..\Components\SynEdit\Source\SynEditKeyCmds.pas',
  SynEditMiscClasses in '..\Components\SynEdit\Source\SynEditMiscClasses.pas',
  SynEditMiscProcs in '..\Components\SynEdit\Source\SynEditMiscProcs.pas',
  SynEditTypes in '..\Components\SynEdit\Source\SynEditTypes.pas',
  SynTextDrawer in '..\Components\SynEdit\Source\SynTextDrawer.pas',
  SynEditWordWrap in '..\Components\SynEdit\Source\SynEditWordWrap.pas',
  CompDialog in 'CompDialog.pas' {fmCompDlg},
  BetterSpin in '..\Components\BetterSpin.pas' {frBetterSpin: TFrame},
  CurrentFiles in 'Dialogs\CurrentFiles.pas' {fmCurrentFiles},
  AddFiles in 'AddFiles.pas',
  CompMods in '..\Libs\CompMods.pas',
  SceneLibDecomp in 'SceneLib\SceneLibDecomp.pas',
  SceneLib2Tab in 'SceneLib\SceneLib2Tab.pas',
  SearchScript in 'Dialogs\SearchScript.pas' {fmSearchScript},
  SynEditSearch in '..\Components\SynEdit\Source\SynEditSearch.pas',
  BatchAnalyse in 'Dialogs\BatchAnalyse.pas' {fmBatchAnalyse},
  SceneLib1Tab in 'SceneLib\SceneLib1Tab.pas',
  scTrackScript2HL in 'SceneLib\scTrackScript2HL.pas',
  scLifeScript2HL in 'SceneLib\scLifeScript2HL.pas',
  SceneVis in 'Dialogs\SceneVis.pas' {fmSceneVis},
  DebugLog in 'Dialogs\DebugLog.pas' {fmDebugLog},
  SmartCombo in 'SmartCombo.pas';

{$R *.res}
//{$R napisy.res}
{$R Images.res}
{$R cursor.res}

var a: Integer;
  
begin
  Application.Initialize;
  Application.OnException:= fmMain.AppException;
  Application.OnHint:= fmMain.AppShowHint;
  Application.Title:= 'Little Grid Builder';
  Application.HintPause:= 0;

  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TProgBarForm, ProgBarForm);
  Application.CreateForm(TfmSettings, fmSettings);
  Application.CreateForm(TfmOpen, fmOpen);
  Application.CreateForm(TfmOpenSim, fmOpenSim);
  Application.CreateForm(TfmListForm, fmListForm);
  Application.CreateForm(TfmAbout, fmAbout);
  Application.CreateForm(TfmScenarioProp, fmScenarioProp);
  Application.CreateForm(TfmList, fmList);
  Application.CreateForm(TfmScriptEd, fmScriptEd);
  Application.CreateForm(TfmSceneProp, fmSceneProp);
  Application.CreateForm(TfmExitSave, fmExitSave);
  Application.CreateForm(TfmActorTpl, fmActorTpl);
  Application.CreateForm(TfmTplName, fmTplName);
  Application.CreateForm(TfmSearchScript, fmSearchScript);
  Application.CreateForm(TfmBatchAnalyse, fmBatchAnalyse);
  {$ifdef DEBUG_LOG}
    Application.CreateForm(TfmDebugLog, fmDebugLog);
  {$endif}
  ///////////////////////////////////////////// empty line
  fmSettings.LoadSettings();  //fmSettings.LoadSettings(); --buggy IDE sometimes eats a few letters from beginning
  fmMain.UpdateButtons();

  LoadGriToBllTables();

  fmOpen.rbGriOriginClick(nil);
  fmOpen.rbLibOriginClick(nil);
  fmOpen.rbBrkOriginClick(nil);
  fmOpen.rbScnOriginClick(nil);
  If fmOpen.rbLibOrigin.Checked then
    fmOpen.cbLibIndex.ItemIndex:= Sett.OpenDlg.BlComboIndex;
  If fmOpen.rbGriOrigin.Checked then
    fmOpen.cbGriIndex.ItemIndex:= Sett.OpenDlg.GrComboIndex;
  If fmOpen.rbScnOrigin.Checked then
    fmOpen.cbScnIndex.ItemIndex:= Sett.OpenDlg.ScComboIndex;
  fmOpenSim.rbLba1Click(fmOpenSim);

  UpdateComponents();

  if not FileExists(ExtractFilePath(Application.ExeName) + 'Builder.ini') and
   (Application.MessageBox('If you want to open standard LBA rooms, you should set up paths to LBA directories in the settings window (View->Settings). Open the settings now?','LBA Builder',MB_ICONQUESTION+MB_YESNO)
    =ID_YES) then begin
     fmSettings.ShowSettings(fmSettings.tsPaths);
    end;

  If (ParamCount > 0) then begin
    for a:= 1 to ParamCount do
      if SameText(ParamStr(1), 'noprog') or SameText(ParamStr(1), '/noprog') then begin
        NoProgress:= True; //disables the progress bar for easier debugging
        Break;
      end;
    for a:= 1 to ParamCount do
      if ExtIs(ParamStr(a), '.hqs') and FileExists(ParamStr(a)) then begin
        fmMain.OpenScenarioFile(ParamStr(a));
        Break;
      end;
  end;

  Application.Run;

  fmSettings.SaveSettings();
end.

{TO DO:
 - range check error when changing LBA 1 <> 2 (advanced open) (fixed?)

 IMPORTANT - LBA2:
 - add script macro name variatios to the completion proposal lists.
 - compilation: add different error string for LBA2 regarding allowed commands
     after OR_IF (error 31), and add similar checking for AND_IF.
 - compilation: better variable compare range check for nested SWITCHes    

 IMPORTANT - current stuff:
 - Scene compilation error -> no binary Scene -> Scenario can't be used in
     Designer - it apparently can be used.
 - Restoring Fragment names from Scenario
 - Change GOTO command so it will accept IDs from -1 to 255 instead of 254. Since the
     binary param is 2-bytes long (address, not LABEL id) it can handle that.
 - Loading LBA 2 Grid lists takes too long (was it faster before?)
 - After copying selection to another fragment and moving the selection, the screen
     doesn't get refreshed properly if a part of the selection was off the screen
     during copying.
     Also after opening a new grid when selecting and moving for the first time.
 - check the LBA 1 disappearing Fragment descriptions in the HQD file.

 IMPORTANT - before 1.0
 - Block all keys when moving/selecting/etc. in fmMain.FormKeyDown()
 - Replace HScr/VScr.Position with ScrollX/Y where possible
 - For Sprite Actors add icons of their real images to the choice menus.
 - Add information texts to the STP file format saver and object names to the program
 - Make selected element being drawn even if the group it belongs to is turned off
  (also if it is above the highest visible layer).
 - Warning if Scene Object properties don't match the HQR entry counts for
    Body, Anim, File3D and Sprite files.
 - Fix Fragment support in connection with Scenes
 - What about file name prefixes (lib=1) when user changes first entry index setting?
 - Can't move Actors below 0 in Y axis (Points too probably)
 - Add Select All in Grid Mode
 - Possibility to change LibIndex and FragIndex for LBA 2
 - Edit map names
 - Hold Ctrl while clicking "delete selection" from the popup menu to delete
     everything except the selection.
 - for Lba 2 - choose type: Grid or Fragment when creating a new map

 Less important:
 - When changing a Sceneric Zone's index (if it sticks out of the box) to a
     shorter value, the external part is not properly cleared.
 - Add a version of DrawPieceBrk() (and maybe others) that takes TBox instead of
     each coord separately.
 - Add Grid/Scene Mode selection in the Scenario opening dialog, and maybe some
     information about Scenario
 - Highlight terrain structure (places where Actors can jump on, jump off without
     dying, gaps that they can jump over, vaults they can pass under, etc. )
 - don't make full redraw during form resizing
 - input selection coords from keyboard in Grid Mode
 - auto height adjustment while placing
 - make exporting to bitmaps for LBA 2 fragments
 - make exporting to compressed formats (preferably jpg, png, tiff)
 - make the user interface elements draggable and dockable (like in modern software)
 - Export to bitmap everything that is visible, not only the Grid
 - palette preview in the Open advanced dialog
 - try to use GetImageBitmap (gets bitmat with all images from TImageList) to speed up
     rendering
 - column selection when Max Visible Layer setting is used works strange
 - save selected area as another Grid or Framgent
 - if the ini file can't be saved allow closing the program without saving the settings
 - fix selection mode (first non-empty, first non-transprent) icons, because
     it's hard to distinguish them
 - (by OBrasilo) "a text interpreter, you write actions to do in standard english
     and teh interpeter converts them to scripts like, i write "Go to Brick no. 250,
     and pick up Inventory Object no. 20"
 - Scalable (at design time) Thumbnail image
 - Undo snapshot should not be created if the selected area has not been moved
     from the original position (Grid Mode), and it seems not to be wroking also
     after switching to Invisible mode.


 Bugs:
 - New style frames by edges don't detect some edges.
 - Switching between new style edges type (by frames/by objects) doesn't refresh the
     edges until the new style is turned off and on again.
 - Program crashes sometimes: "You need to have "Single bricks" selection mode selected
     and go to the Hand mode than change to Placer mode and change the selection mode
     to "Select by Layouts" the program will crash when you try to click in something"
 - When Highlight Invisible button is pressed, it works like the Invisible tool was
     chosen (can't select anything except invisible bricks)
 - 3d helper is drawn incorrectly near back left and right Grid side
 - Automatic library selection doesn't choose between LBA 1 and 2
 - Frames don't work in Scene Mode for LBA 2
 - Program crashes if tries to open a file that is in use (and can be opened in read-only)

}
