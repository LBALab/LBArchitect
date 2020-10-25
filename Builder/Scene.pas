//******************************************************************************
// Little Big Architect: Builder - editing grid files containing rooms in
//                                 Little Big Adventure 1 & 2
//
// Scene unit.
// Contains routines used in scene mode (displaying scene elements: actors,
//  zones and flags.
//
// Copyright Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit Scene;

interface

uses Windows, SysUtils, Forms, Controls, Graphics, Types, Messages, Math, DePack,
     Engine, Classes, SceneLib, SceneLibConst, ActorInfo, SynEditTextBuffer;

type
  TObjType = (otNone = 0, otPoint = 1, otZone = 2, otActor = 3);

  TSceneObjectId = record
    oType: TObjType;
    oId: Integer;
  end;

  TSceneObjects = array of TSceneObjectId;
  
var
  VScene: TScene;
  ObjectList: array of record
   typ, id: Byte;
   position: Integer;
  end;
  VSprites: TPackEntries;
  //SceneUsesSprites: Boolean = False;
  //SceneModeAvailable: Boolean = True;
  SceneClipL: Integer = 0;
  SceneClipR: Integer = 0;
  SceneInitialized: Boolean = False; //mainly whether all necessary files have been loaded
  SceneLoadedFromText: Boolean; //Used only for single Scene loading/saving (ignored for HQS)

  SelType: TObjType;
  SelId: Byte;
  LastSelTrack: Byte = 0;
  LastSelActor: Byte = 0;
  LastSelZone: Byte = 0;
  LastSnapDelta: TPoint3d;

  SceneHLRec: record
    Left, Right, Top, Bottom: Integer; //coordinates of the rect to highlight
    Stage: (hsOff, hsMoving, hsBlinking);
    Counter: Integer; //blinking and moving counter
    MarkingsRect: TRect; //current coords of the marking points
    MovingStepX, MovingStepY: Integer;
  end;

  SpritesFile, RessFile, File3dFile,
  BodyNamesFile, AnimNamesFile: String; //File paths just for information

function InitSceneMode(): Boolean;
procedure UnloadSceneFiles();
function GoSceneMode(): Boolean;
procedure GoGridMode();
Procedure SetSceneModified();
Procedure DrawHighlightMarks(Markings: TRect; Visible: Boolean);
procedure DrawPositionHighlight(Pos: TPoint; Visible: Boolean);
Function SceneAngleToDegrees(Angle: Word): Word;
Function DegreesToSceneAngle(Degs: Word): Word;
Procedure SceneToXY(x, y, z, pX, pY: Integer; var rX, rY: Integer);
Procedure SceneToGrid(x, y, z: Integer; var gX, gY, gZ: Integer);
Procedure DrawTrack(nr: Byte; x, y: Integer; Dest: TCanvas);
Procedure RedrawTrack(nr: Byte; SelClear: Boolean = False;
  UpdClip: Boolean = True);
Procedure DeleteTrack(nr: Byte);
Procedure SetTrack(nr: Byte; x, y, z: SmallInt);
Procedure HighlightTrack(nr: Byte);
Procedure DrawActor(nr: Byte; x, y: Integer; Dest: TCanvas);
Procedure MakeObjectsDispList();
Procedure RedrawActor(nr: Byte; SelClear: Boolean = False; UpdClip: Boolean = True);
Procedure SetActor(nr: Byte; x, y, z: SmallInt);
Procedure ChangeActorSprite(nr: Byte; SpriteId: Word);
Procedure DeleteActor(nr: Byte);
Procedure HighlightActor(nr: Byte);
procedure CreateActor(x, y, z: SmallInt); overload;
procedure CreateActor(x, y, z: SmallInt; Template: TSceneActor); overload;
Procedure DrawZone(nr: Byte; x, y: Integer; Dest: TCanvas; Front: Boolean;
  Selected: Boolean = False);
Procedure RedrawZone(nr: Byte; Clear: Boolean = False; UpdClip: Boolean = True);
Procedure DeleteZone(nr: Byte);
Procedure SetZone(nr: Byte; x1, y1, z1, x2, y2, z2: SmallInt; ZType: TZoneType);
Procedure HighlightZone(nr: Byte);
Function ZonePosInHandle(id, x, y: Integer): Boolean;
Procedure DrawSelection();
Function PositionInside(X, Y: Integer; ObjType: TObjType; ObjId: Integer): Boolean;
Function GetObjectAtCursor(X, Y: Integer; FindTracks, FindActors, FindZones: Boolean;
  out ObjType: TObjType): Byte;
Function GetObjectsAtCursor(X, Y: Integer; FindTracks, FindActors,
  FindZones: Boolean): TSceneObjects;
Procedure MoveObject(ObjType: TObjType; ObjId: Byte; dx, dy: Integer; Vertical: Boolean);
Procedure SelectObject(ObjType: TObjType; ObjId: Byte);
procedure MakeZoneSelectionIcons();

implementation

uses Main, OpenSim, Settings, ProgBar, Open, Rendering, Grids, Scenario, SceneObj,
     ScriptEd, SceneUndo, Globals, AddFiles;

function LoadSceneFiles(): Boolean;
var FStr: TFileStream;
    RessTemp: TPackEntries;
begin
 Result:= False;

 if not CheckFile(Lba_SPRITES, LBAMode) then begin
   Application.MessageBox('Sprites.hqr file not found in current working directory. Switch to Scene Mode aborted.','Scene Mode',MB_ICONERROR+MB_OK);
   Exit;
 end;
 SpritesFile:= GetFilePath(Lba_SPRITES, LBAMode);
 FStr:= TFileStream.Create(SpritesFile, fmOpenRead, fmShareDenyWrite);
 VSprites:= OpenPack(FStr);
 UnpackAll(VSprites);
 FStr.Free();
 LoadSpriteDescriptions(GetFilePath(Lba_SPRITES, LBAMode), LBAMode);
 LoadComboSimple(fmMain.frSceneObj.cbASprites, LBAMode, etSprites, -1, Length(SpriteNames));

 if not CheckFile(Lba_RESS, LBAMode) then begin
   Application.MessageBox('Ress.hqr file not found in current working directory. Switch to Scene Mode aborted.','Scene Mode',MB_ICONERROR+MB_OK);
   Exit;
 end;
 RessFile:= GetFilePath(Lba_RESS, LBAMode);
 FStr:= TFileStream.Create(RessFile, fmOpenRead, fmShareDenyWrite);
 RessTemp:= OpenPack(FStr);
 FStr.Free();
 if not LoadSpriteActorsInfo(UnpackToString(RessTemp[IfThen(LBAMode = 2, 5, 3)])) then begin
   Application.MessageBox('Could not load Sprite information.'#13'Scene Mode aborted.','Scene Mode',MB_ICONERROR+MB_OK);
   Exit;
 end;
 LoadMovieNames(UnpackToString(RessTemp[IfThen(LBAMode = 2, 48, 23)]), LBAMode);

 if LBAMode = 1 then begin 
   if not CheckFile(Lba_FILE3D, LBAMode) then begin
     Application.MessageBox('File3d.hqr file not found in current working directory.'#13'Scene Mode aborted.','Scene Mode',MB_ICONERROR+MB_OK);
     Exit;
   end;
   File3dFile:= GetFilePath(Lba_FILE3D, LBAMode);
   if not LoadFile3D(File3dFile, 1) then begin
     Application.MessageBox('Coul not load File3d information.'#13'Scene Mode aborted.','Scene Mode',MB_ICONERROR+MB_OK);
     Exit;
   end;
 end else begin //For LBA2 Entities are in a single entry of ress.hqr
   if not LoadFile3D(RessFile, 2) then begin
     Application.MessageBox('Could not load Entities information.'#13'Scene Mode aborted.','Scene Mode',MB_ICONERROR+MB_OK);
     Exit;
   end;
 end;
 LoadComboSimple(fmMain.frSceneObj.cbAEntity, LBAMode, etFile3d, -1, Length(ActorEntities));
 fmMain.frSceneObj.cbAEntity.Items.Insert(0, 'None (-1)');

 if not CheckFile(Lba_BODY, LBAMode) then begin
   Application.MessageBox('Body.hqr file not found in current working directory.'#13'Scene Mode aborted.','Scene Mode',MB_ICONERROR+MB_OK);
   Exit;
 end;
 BodyNamesFile:= GetFilePath(Lba_BODY, LBAMode);

 if not CheckFile(Lba_ANIM, LBAMode) then begin
   Application.MessageBox('Anim.hqr file not found in current working directory.'#13'Scene Mode aborted.','Scene Mode',MB_ICONERROR+MB_OK);
   Exit;
 end;
 AnimNamesFile:= GetFilePath(Lba_ANIM, LBAMode);
 LoadBodyAnimDesc(BodyNamesFile, AnimNamesFile, LBAMode);

 if CheckFile(Lba_SAMPLES, LBAMode) then
   LoadSampleDescriptions(GetFilePath(Lba_SAMPLES, LBAMode), LBAMode)
 else
   Application.MessageBox('Samples.hqr file not found in current working directory.'#13'This is not critical, you may continue your work.', 'Scene Mode', MB_ICONWARNING+MB_OK);
 

 if CheckFile(Lba_TEXT, LBAMode) then
   LoadDialogTexts(GetFilePath(Lba_TEXT, LBAMode), LBAMode)
 else
   Application.MessageBox('Text.hqr file not found in current working directory.'#13'This is not critical, you may continue your work.', 'Scene Mode', MB_ICONWARNING+MB_OK);

 if LBAMode = 1 then begin
   if CheckFile(Lba_INVOBJ, LBAMode) then
     LoadInvObjDescriptions(GetFilePath(Lba_INVOBJ, LBAMode), LBAMode)
   else
     Application.MessageBox('Invobj.hqr file not found in current working directory.'#13'This is not critical, you may continue your work.', 'Scene Mode', MB_ICONWARNING+MB_OK);
 end;

 Result:= True;
end;

procedure UnloadSceneFiles();
begin
 SetLength(VSprites, 0);
 ClearActorInfo();
 SpritesFile:= '';
 RessFile:= '';
 File3dFile:= '';
 BodyNamesFile:= '';
 AnimNamesFile:= '';
 SceneInitialized:= False;
end;

function InitSceneMode(): Boolean;
begin
 Result:= True;
 If not SceneInitialized then begin
   {for c:=0 to 63 do
    for b:=0 to 24 do
     for a:=0 to 63 do
      SetLength(BreakMap[a,b,c], 0); }

   fmMain.frSceneObj.NoSpinChange:= True;
   fmMain.frSceneObj.seObjId.Value:= 0;
   SelType:= otNone;
   LastSelTrack:= 0;
   LastSelActor:= 0;
   LastSelZone:= 0;
   fmScriptEd.ScriptsVisible:= False;
   fmMain.frSceneObj.InitSceneObj();

   SceneResetUndo();
   fmScriptEd.DeleteAllActorUndoRedo();

   If not NoProgress then ProgBarForm.ShowSpecial('Initializing Scene Mode...',fmMain,True);

   If LoadSceneFiles() then begin
     ComputeAllDispInfo(VScene);
     MakeObjectsDispList();
     SceneInitialized:= True;
   end
   else
     Result:= False;

   ProgBarForm.CloseSpecial();
   fmMain.frSceneObj.NoSpinChange:= False;
 end;
end;

function GoSceneMode(): Boolean;
begin
 Result:= InitSceneMode();
 if Result then begin
   if Sett.General.AutoMainGrid then begin
     fmMain.cbFragment.ItemIndex:= 0;
     fmMain.cbFragmentChange(nil);
   end;
   SceneClipL:= -102; //expand grid repaint area to keep elements visible
   SceneClipR:= 151;  // even if they're partially off the screen
   ProgMode:= pmScene;
   fmMain.UpdateButtons();
   fmMain.pcControls.ActivePage:= fmMain.tsScene;
   fmMain.paLayout.Visible:= False;
   fmMain.paObjInspector.Visible:= True;
   fmMain.paLeftSide.Width:= Max(Sett.Controls.SLastOiPos, 1);
   fmMain.mDeleteLayer.Enabled:= False;
   fmMain.frLtClip.Visible:= False;
   fmMain.paAdv.Visible:= False;
   UpdateShortcuts();
   If fmScriptEd.ScriptsVisible then fmScriptEd.OpenScripts(fmScriptEd.LastActor);
   fmMain.UpdateProgramName();
   fmMain.aSceneMode.Caption:= 'Switch to Grid Mode';
   fmMain.btScHandClick(fmMain.btScHand);
   ResetControls(False);
   SceneSetUndoButtons();
   fmMain.frSceneObj.InitSceneObj();
   fmMain.FormResize(fmMain);
 end;
end;

procedure GoGridMode();
begin
 SceneClipL:= 0;
 SceneClipR:= 0;
 ProgMode:= pmGrid;
 fmMain.UpdateButtons();
 fmMain.pcControls.ActivePage:= fmMain.tsGrid;
 fmMain.paLayout.Visible:= True;
 fmMain.paObjInspector.Visible:= False;
 fmMain.paLeftSide.Width:= Max(Sett.Controls.GLastLtPos, 1);
 fmMain.mDeleteLayer.Enabled:= True;
 fmMain.btHandClick(fmMain);
 UpdateShortcuts();
 if Assigned(fmScriptEd) then begin //it is called on start when fmSSEd is not yet created
   fmScriptEd.ScriptsVisible:= fmScriptEd.Visible;
   fmScriptEd.Close();
 end;
 fmMain.UpdateProgramName();
 fmMain.aSceneMode.Caption:= 'Switch to Scene Mode';
 fmMain.btHandClick(fmMain.btHand); // <- ResetControls(False) inside
 fmMain.GridUndoSetButtons();
 fmMain.frSceneObj.InitSceneObj();
 fmMain.FormResize(fmMain);
end;

procedure GoFragTestMode();
begin
 {SceneClipL:= 0;
 SceneClipR:= 0;
 fmMain.cbFragment.ItemIndex:= 0;
 fmMain.cbFragmentChange(nil);
 ProgMode:= pmFragTest;
 fmMain.UpdateButtons();
 fmMain.pcControls.ActivePage:= fmMain.tsFragTest;

   ProgMode:= pmScene;
   fmMain.UpdateButtons();
   fmMain.pcControls.ActivePage:= fmMain.tsScene;
   fmMain.Splitter1.Visible:= False;
   fmMain.paLayout.Visible:= False;
   fmMain.paObjInspector.Visible:= False;
   fmMain.frLtClip.Visible:= False;
   fmMain.paAdv.Visible:= False;
   UpdateShortcuts();
   If fmScScriptEd.ScriptsVisible then fmScScriptEd.OpenScripts(fmScScriptEd.LastActor);
   fmMain.UpdateProgramName();
   fmMain.aSceneMode.Caption:= 'Switch to Grid Mode';
   fmMain.btScHandClick(fmMain.btScHand);
   ResetControls(False);
   SceneSetUndoButtons();
   fmMain.frSceneObj.InitSceneObj();
   fmMain.FormResize(fmMain);
 fmMain.Splitter1.Visible:= True;
 fmMain.paLayout.Visible:= True;
 fmMain.paObjInspector.Visible:= True;
 fmMain.btHandClick(fmMain);
 UpdateShortcuts();
 if Assigned(fmScScriptEd) then begin //it is called on start when fmSSEd is not yet created
   fmScScriptEd.ScriptsVisible:= fmScScriptEd.Visible;
   fmScScriptEd.Close();
 end;
 fmMain.UpdateProgramName();
 fmMain.aSceneMode.Caption:= 'Switch to Scene Mode';
 fmMain.btHandClick(fmMain.btHand); // <- ResetControls(False) inside
 fmMain.GridUndoSetButtons();
 fmMain.frSceneObj.InitSceneObj();
 fmMain.FormResize(fmMain);}
end;

Procedure SetSceneModified();
begin
 If not SceneModified then begin
   SceneModified:= True;
   fmMain.UpdateProgramName();
 end;
end;

Procedure DrawHighlightMarks(Markings: TRect; Visible: Boolean);
const Size = 30;
begin
 OffsetRect(Markings, - GScrX + GOffX, - GScrY + GOffY);
 With fmMain.pbGrid.Canvas do begin
   If Visible then begin
     Pen.Color:= clRed;
     Pen.Style:= psSolid;
     Pen.Width:= 3;
     MoveTo(Markings.Left, Markings.Top + Size); //----------
     LineTo(Markings.Left, Markings.Top);      // top left
     LineTo(Markings.Left + Size, Markings.Top); //----------
     MoveTo(Markings.Right - Size, Markings.Top); //-----------
     LineTo(Markings.Right, Markings.Top);      // top right
     LineTo(Markings.Right, Markings.Top + Size); //-----------
     MoveTo(Markings.Right, Markings.Bottom - Size); //--------------
     LineTo(Markings.Right, Markings.Bottom);      // bottom right
     LineTo(Markings.Right - Size, Markings.Bottom); //--------------
     MoveTo(Markings.Left + Size, Markings.Bottom); //-------------
     LineTo(Markings.Left, Markings.Bottom);      // bottom left
     LineTo(Markings.Left, Markings.Bottom - Size); //-------------
     Pen.Width:= 1;
   end
   else begin
     OffsetRect(Markings, - 1, - 1);
     BitBlt(fmMain.pbGrid.Canvas.Handle, //top left
            Markings.Left, Markings.Top, Size + 3, Size + 3,
            bufMain.Canvas.Handle, Markings.Left, Markings.Top, SRCCOPY);
     BitBlt(fmMain.pbGrid.Canvas.Handle, //top right
            Markings.Right - Size, Markings.Top, Size + 3, Size + 3,
            bufMain.Canvas.Handle, Markings.Right - Size, Markings.Top, SRCCOPY);
     BitBlt(fmMain.pbGrid.Canvas.Handle, //bottom right
            Markings.Right - Size, Markings.Bottom - Size, Size + 3, Size + 3,
            bufMain.Canvas.Handle, Markings.Right - Size, Markings.Bottom - Size, SRCCOPY);
     BitBlt(fmMain.pbGrid.Canvas.Handle, //bottom left
            Markings.Left, Markings.Bottom - Size, Size + 3, Size + 3,
            bufMain.Canvas.Handle, Markings.Left, Markings.Bottom - Size, SRCCOPY);
   end;
 end;
end;

procedure DrawPositionHighlight(Pos: TPoint; Visible: Boolean);
const Size = 10;
      SizeH = Size div 2;
begin
 Pos.X:= Pos.X - GScrX + GOffX;
 Pos.Y:= Pos.Y - GScrY + GOffY + 1;
 With fmMain.pbGrid.Canvas do begin
   If Visible then begin
     Pen.Color:= clAqua;
     Pen.Style:= psSolid;
     Pen.Width:= 2;
     MoveTo(Pos.X - Size, Pos.Y - SizeH);
     LineTo(Pos.X + Size, Pos.Y + SizeH);
     MoveTo(Pos.X - Size, Pos.Y + SizeH);
     LineTo(Pos.X + Size, Pos.Y - SizeH);
     Pen.Width:= 1;
   end
   else begin
     //OffsetRect(Markings, - 1, - 1);
     BitBlt(fmMain.pbGrid.Canvas.Handle, Pos.X - Size, Pos.Y - SizeH,
       Size * 2 + 1, Size + 1, bufMain.Canvas.Handle, Pos.X - Size, Pos.Y - SizeH, SRCCOPY);
   end;
 end;
end;

procedure StartObjectHighlight(ObjX, ObjY, ObjW, ObjH: Integer);
begin
 SceneHLRec.Left:= ObjX - 2;
 SceneHLRec.Top:= ObjY - 2;
 SceneHLRec.Right:= ObjX + ObjW + 2;
 SceneHLRec.Bottom:= ObjY + ObjH + 2;
 SceneHLRec.Stage:= hsMoving;
 SceneHLRec.Counter:= 20;
 SceneHLRec.MovingStepX:= 20;
 SceneHLRec.MovingStepY:= 20;
 SceneHLRec.MarkingsRect:= Rect(
   SceneHLRec.Left - 400, SceneHLRec.Top - 400,
   SceneHLREc.Right + 400, SceneHLRec.Bottom + 400);
 DrawHighlightMarks(SceneHLRec.MarkingsRect, True);
 fmMain.tmHighlight.Interval:= 40;
 fmMain.tmHighlight.Enabled:= True;
end;

Function SceneAngleToDegrees(Angle: Word): Word;
begin
 Result:= SRound( (Angle * 360) / 1024 ) mod 360;
end;

Function DegreesToSceneAngle(Degs: Word): Word;
begin
 Result:= SRound( (Degs * 1024) / 360 ) mod 1024;
end;

//snapping to Bricks is made here
Procedure SceneMoveBy(x, y, z, dx, dy: Integer; Vertical: Boolean; out nX, nY, nZ: Integer);
var tempDelta: TPoint3d;
    Keys: TShiftState;
begin
 Keys:= KeyboardStateToShiftState();
 If Vertical then begin
   nX:= x;
   nY:= SRound(y - dy*(256/15));
   nZ:= z;
   tempDelta.y:= (LastSnapDelta.y + nY) mod 256;
   If Sett.Scene.SnapToBricks and not (ssAlt in Keys) then
     nY:= SRound((nY + LastSnapDelta.y - 128) / 256) * 256;
 end
 else begin
   nX:= SRound(x + dx*(512/48) + dy*(512/24));
   nY:= y;
   nZ:= SRound(z - dx*(512/48) + dy*(512/24));
   tempDelta.x:= (LastSnapDelta.x + nX) mod 256;
   tempDelta.z:= (LastSnapDelta.z + nZ) mod 256;
   If Sett.Scene.SnapToBricks and not (ssAlt in Keys) then begin
     nX:= SRound((nX + LastSnapDelta.x - 128) / 256) * 256;
     nZ:= SRound((nZ + LastSnapDelta.z - 128) / 256) * 256;
   end;
 end;
 LastSnapDelta:= tempDelta;
 If nX < -256 then nX:= -256 else if nX > 32767 then nX:= 32767;
 If nY < 0 then nY:= 0 else if nY > 6400 then nY:= 6400;
 If nZ < -256 then nZ:= -256 else if nZ > 32767 then nZ:= 32767;
end;

{   //Obsolete
Procedure AddBreakMapItem(x, y, z, Typ, Id: Integer);
begin
 SetLength(BreakMap[x, y, z], Length(BreakMap[x, y, z]) + 1);
 BreakMap[x, y, z, High(BreakMap[x, y, z])].Typ:= Typ;
 BreakMap[x, y, z, High(BreakMap[x, y, z])].Id:= Id;
end;

Procedure DelBreakMapItem(x, y, z, Typ, Id: Integer);
var a, b: Integer;      //Id = -1 means: delete all
begin
 for a:= High(BreakMap[x, y, z]) downto 0 do
  If (BreakMap[x, y, z, a].Typ = Typ)
  and ((Id = -1) or (BreakMap[x, y, z, a].Id = Id)) then begin
   for b:= a+1 to High(BreakMap[x, y, z]) do
    BreakMap[x, y, z, b-1]:= BreakMap[x, y, z, b];
   SetLength(BreakMap[x, y, z], High(BreakMap[x, y, z]));
  end;
end;
}

Procedure SetObjectInList(typ, nr: Byte; pos: Integer; Delete: Boolean);
var a, b: Integer;
begin
 If Length(ObjectList) > 0 then
   for a:= 0 to High(ObjectList) do
     If (ObjectList[a].typ = typ) and (ObjectList[a].id = nr) then begin
       for b:= a to High(ObjectList) - 1 do
         ObjectList[b]:= ObjectList[b + 1];
       SetLength(ObjectList,Length(ObjectList) - 1);
       Break;
     end;

 If not Delete then begin
   If Length(ObjectList) > 0 then begin
     b:= -1;
     for a:= 0 to High(ObjectList) do
       //If (AA.x + SprActInfo[AA.SpriteIndex].MaxX + AA.z + SprActInfo[AA.SpriteIndex].MaxZ)
       //<= (Actors[ActorList[a]].x + SprActInfo[Actors[ActorList[a]].SpriteIndex].MaxX
       //  + Actors[ActorList[a]].z + SprActInfo[Actors[ActorList[a]].SpriteIndex].MaxZ)
       If (pos <= ObjectList[a].position) then begin
         b:= a;
         Break;
       end;
     If b = -1 then b:= Length(Objectlist);
   end
   else b:= 0;

   SetLength(ObjectList,Length(ObjectList) + 1);
   for a:= High(ObjectList) downto b + 1 do
     ObjectList[a]:= ObjectList[a - 1];
   ObjectList[b].typ:= typ;
   ObjectList[b].id:= nr;
   ObjectList[b].position:= pos;
 end;
end;

Procedure ChangeObjectInListID(typ, id, NewID: Byte);
var a: Integer;
begin
 for a:= 0 to High(ObjectList) do
   If (ObjectList[a].typ = typ) and (ObjectList[a].id = id) then begin
     ObjectList[a].id:= NewID;
     Exit;
   end;  
end;

Procedure DrawTrack(nr: Byte; x, y: Integer; Dest: TCanvas);
var TT: TPointDispInfo;
begin
 TT:= VScene.Points[nr].DispInfo;
 Dest.Brush.Style:= bsClear;
 Dest.Font.Color:= $B787FF;
 Dest.BrushCopy(Bounds(TT.rX+x-22, TT.rY+y-37, 24, 37),
   fmMain.imgFlag.Picture.Bitmap,Bounds(0,0,24,37),clWhite);
 Dest.TextOut(TT.rX+x+TT.CaptionX, TT.rY+y+TT.CaptionY, IntToStr(nr));
end;

Procedure RedrawTrack(nr: Byte; SelClear: Boolean = False; UpdClip: Boolean = True);
//var Wid: Integer;
begin
 If nr < Length(VScene.Points) then begin
   //Wid:= Max(bufMain.Canvas.TextWidth(IntToStr(nr)) div 2,24) * 2;
   With VScene.Points[nr].DispInfo do begin
     If SelClear then
       DrawPiece(//VScene.Tracks[nr].DispInfo.rX+Off_X-(Wid div 2),
                 //VScene.Tracks[nr].DispInfo.rY+Off_Y-64,Wid,64,
                 rX + GOffX + DrawOriginX, rY + GOffY + DrawOriginY,
                 DrawWidth, DrawHeight,
                 dmNormal, False, True, False)
     else begin
       DrawTrack(nr, GOffX - GScrX, GOffY - GScrY, bufMain.Canvas);
       DrawPiece(//VScene.Tracks[nr].DispInfo.rX+Off_X-(Wid div 2),
                 //VScene.Tracks[nr].DispInfo.rY+Off_Y-64, Wid, 64,
                 rX + GOffX + DrawOriginX, rY + GOffY + DrawOriginY,
                 DrawWidth, DrawHeight,
                 dmNormal, False, False, UpdClip, UpdClip, False,
                 gX, gY, gZ);
     end;
   end;
 end;
end;

Procedure DeleteTrack(nr: Byte);
var a: Integer;
begin
 SetObjectInList(1, nr, 0, True); //Del from disp list
 RedrawTrack(nr, True);         //Redraw the now empty area

 for a:= nr + 1 to High(VScene.Points) do begin
   VScene.Points[a - 1]:= VScene.Points[a];  //Move the furhter points back in array
   ChangeObjectInListID(1, a, a - 1);        //Change the display IDs of the tracks
   ComputeTrackDrawInfo(VScene.Points[a-1], a-1); //update caption position (and other)
 end;
 SetLength(VScene.Points, High(VScene.Points));

 //DelBreakMapItem(Tracks[nr].gX, Tracks[nr].gY, Tracks[nr].gZ, 1, nr); Obsolete
 DrawMapA();
 //for a:= nr to High(VScene.Tracks) do
 //  RedrawTrack(nr);
 SetSceneModified();
end;

Procedure SetTrack(nr: Byte; x, y, z: SmallInt);
begin
 SetObjectInList(1, nr, 0, True); //Del from disp list
 RedrawTrack(nr, True, False);
 VScene.Points[nr].x:= x;
 VScene.Points[nr].y:= y;
 VScene.Points[nr].z:= z;
 ComputeTrackDispInfo(VScene.Points[nr], nr);
 SetObjectInList(1, nr, x+z, False); //Put in another position in the disp list
 RedrawTrack(nr);
 SetSceneModified();
end;

//Centers the Point in window and displays highlighting
procedure HighlightTrack(nr: Byte);
var tt: TPointDispInfo;
begin
 tt:= VScene.Points[nr].DispInfo;
 ScrollMap(tt.rX + tt.DrawOriginX + GOffX - GScrX - ((fmMain.pbGrid.Width - tt.DrawWidth) div 2),
           tt.rY + tt.DrawOriginY + GOffY - GScrY - ((fmMain.pbGrid.Height - tt.DrawHeight) div 2));
 StartObjectHighlight(tt.rX + tt.DrawOriginX, tt.rY + tt.DrawOriginY,
   tt.DrawWidth, tt.DrawHeight);
end;

procedure DrawZone(nr: Byte; x, y: Integer; Dest: TCanvas; Front: Boolean;
  Selected: Boolean = False);
var x1, y1, x2, y2, xp1, yp1, xp2, yp2: Integer;
    zt: TZoneType;
    ZZ: TZoneDispInfo;
begin
 zt:= VScene.Zones[nr].RealType;
 if not (zt in ScVisible.Zones) then Exit;
 ZZ:= VScene.Zones[nr].DispInfo;
 if Selected then
   Dest.Pen.Color:= clWhite
 else
   Dest.Pen.Color:= Sett.Scene.ZoneColours[zt];
 Dest.Font.Color:= Dest.Pen.Color;
 Dest.Brush.Style:= bsClear;
 x1:= ZZ.rX1 + x;
 y1:= ZZ.rY1 + y;
 x2:= ZZ.rX2 + x;
 y2:= ZZ.rY2 + y;
 xp1:= ZZ.sX1 + x;
 yp1:= ZZ.sY1 + y;
 xp2:= ZZ.sX2 + x;
 yp2:= ZZ.sY2 + y;
 //If Front then begin
  Dest.Pen.Style:= psSolid;
  Dest.MoveTo(xp2, yp2 - ZZ.h);
  Dest.LineTo(xp2, yp2);
  Dest.LineTo(x2,  y2  + ZZ.h);
  Dest.LineTo(xp1, yp1);
  Dest.LineTo(xp1, yp1 - ZZ.h);
  Dest.LineTo(x1,  y1  - ZZ.h);
  Dest.LineTo(xp2, yp2 - ZZ.h);
  Dest.LineTo(x2,  y2);
  Dest.LineTo(xp1, yp1 - ZZ.h);
  Dest.MoveTo(x2,  y2);
  Dest.LineTo(x2,  y2  + ZZ.h);
 //end
 //else begin
  Dest.Pen.Style:= psDot;
  Dest.MoveTo(x1,  y1 - ZZ.h);
  Dest.LineTo(x1,  y1);
  Dest.LineTo(xp1, yp1);
  Dest.MoveTo(x1,  y1);
  Dest.LineTo(xp2, yp2);
 //end;
 Dest.Pen.Style:= psSolid;
 If Selected then
   Dest.Ellipse(x2 - 8, y2 - 8, x2 + 9, y2 + 9);
 //Dest.TextOut(x1, y1-ZZ.h, ZZ.Caption);//IntToStr(nr));
 Dest.TextOut(x1 + ZZ.CaptionX, y1 + ZZ.CaptionY, ZZ.Caption);
end;

Procedure RedrawZone(nr: Byte; Clear: Boolean = False; UpdClip: Boolean = True);
var zz: TZoneDispInfo;
    //wid, hei: Integer;
begin
  zz:= VScene.Zones[nr].DispInfo;
  if Clear then begin
    //wid:= Max(bufMain.Canvas.TextWidth(zz.Caption) + zz.rX1 - zz.sX2,
    //          zz.sX1 - zz.sX2 + 1);
    //hei:= Max(bufMain.Canvas.TextHeight(zz.Caption), zz.rY2 - zz.rY1 + zz.h * 2 + 2);
    DrawPiece(//zz.sX2 + Off_X, zz.rY1 - zz.h + Off_Y, wid, hei,
              zz.rX1 + GOffX + zz.DrawOriginX, zz.rY1 + GOffY + zz.DrawOriginY,
              zz.DrawWidth, zz.DrawHeight,
              dmNormal, False, True, False)  //TODO: changed to redraw Scene Elements also
              //check if it won't have a bad influence on displaying
  end
  else begin
    //DrawPiece(zz.rX2 + Off_X - 8, zz.rY2 + Off_Y - 8, 17, 17,
    //       dmNormal, False, False, False, False);
    DrawZone(nr, GOffX-GScrX, GOffY-GScrY, bufMain.Canvas, False,
      (SelType = otZone) and (SelId = nr));
    {$ifndef NO_BUFFER}if UpdClip then UpdateClip(bufMain, fmMain.pbGrid);{$endif}
   {DrawPiece(zz.sX2 + Off_X,        //TODO make Zone drawing that regards Grid elements
             zz.rY1 - zz.h + Off_Y,  // (Zones could be partially covered)
             zz.sX1 - zz.sX2 + 1,
             zz.rY2 - zz.rY1 + zz.h * 2 + 2,
             dmNormal, False, False, UpdClip, UpdClip,
             VScene.Zones[nr].DispInfo.gX1,
             VScene.Zones[nr].DispInfo.gY1,
             VScene.Zones[nr].DispInfo.gZ1);}
  end;
end;

Procedure DeleteZone(nr: Byte);
var a: Integer;
    zz: TZoneDispInfo;
begin
 zz:= VScene.Zones[nr].DispInfo;
 for a:= nr + 1 to High(VScene.Zones) do begin
   VScene.Zones[a - 1]:= VScene.Zones[a];
   ComputeZoneDispInfo(VScene.Zones[a-1], a-1); //to fix zone ID display
 end;
 SetLength(VScene.Zones, High(VScene.Zones));
 //DrawPiece(zz.sX2 + Off_X - 1, zz.rY1 + Off_Y - zz.h - 1, zz.sX1 - zz.sX2 + 2,
 //          zz.rY2 - zz.rY1 + 2*zz.h + 2, dmNormal, False);
 DrawMapA();
 SetSceneModified();
end;

Procedure SetZone(nr: Byte; x1, y1, z1, x2, y2, z2: SmallInt; ZType: TZoneType);
var //wid, hei: Integer;
    zz: TZoneDispInfo;
begin
 zz:= VScene.Zones[nr].DispInfo;
 //Limit minimal Zone size:
 If Abs(x2 - x1) < 512 then begin
   if (x1 + 512 > High(SmallInt)) then x1:= High(SmallInt) - 512; //Avoid range error near screen edges
   x2:= x1 + 512;
 end;
 If Abs(y2 - y1) < 256 then begin
   if (y1 + 512 > High(SmallInt)) then y1:= High(SmallInt) - 256;
   y2:= y1 + 256;
 end;
 If Abs(z2 - z1) < 512 then begin
   if (z1 + 512 > High(SmallInt)) then z1:= High(SmallInt) - 512;
   z2:= z1 + 512;
 end;

 VScene.Zones[nr].x1:= Min(x1,x2); //normalize coords
 VScene.Zones[nr].y1:= Min(y1,y2);
 VScene.Zones[nr].z1:= Min(z1,z2);
 VScene.Zones[nr].x2:= Max(x1,x2);
 VScene.Zones[nr].y2:= Max(y1,y2);
 VScene.Zones[nr].z2:= Max(z1,z2);

 VScene.Zones[nr].RealType:= ZType;
 ComputeZoneDispInfo(VScene.Zones[nr], nr);
 //wid:= Max(bufMain.Canvas.TextWidth(Zones[nr].Caption),24);
 //DrawPiece(Zones[nr].rX1+Off_X-(Wid div 2),Tracks[nr].rY+Off_Y-62,Wid,62,dmNormal,False);
 //DrawMapA;
 //DrawZone(nr,Off_X-ScrollX,Off_Y-ScrollY,bufMain.Canvas,True);
 //{$ifndef NO_BUFFER}UpdateImage(bufMain,Form1.pbGrid);{$endif}
 //wid:= Max(bufMain.Canvas.TextWidth(zz.Caption) + zz.rX1 - zz.sX2,
 //             zz.sX1 - zz.sX2 + 1);
 //hei:= Max(bufMain.Canvas.TextHeight(zz.Caption), zz.rY2 - zz.rY1 + zz.h * 2 + 2);
 //DrawPiece(zz.sX2 + Off_X, zz.rY1 - zz.h + Off_Y, wid{zz.sX1 - zz.sX2 + 1}, hei,
 //          dmNormal, False, True, False);
 DrawPiece(zz.rX1 + GOffX + zz.DrawOriginX, zz.rY1 + GOffY + zz.DrawOriginY,
           zz.DrawWidth, zz.DrawHeight,
           dmNormal, False, True, False);
 RedrawZone(nr);
 SetSceneModified();
end;

//Centers the Zone in window and displays highlighting
Procedure HighlightZone(nr: Byte);
var zz: TZoneDispInfo;
begin
 zz:= VScene.Zones[nr].DispInfo;
 ScrollMap(zz.rX1 + zz.DrawOriginX + GOffX - GScrX - ((fmMain.pbGrid.Width - zz.DrawWidth) div 2),
           zz.rY1 + zz.DrawOriginY + GOffY - GScrY - ((fmMain.pbGrid.Height - zz.DrawHeight) div 2));
 StartObjectHighlight(zz.rX1 + zz.DrawOriginX, zz.rY1 + zz.DrawOriginY,
   zz.DrawWidth, zz.DrawHeight);
end;

//Says if the cursor position is inside the Zone handle (the small circle)
Function ZonePosInHandle(id, x, y: Integer): Boolean;
var ZZ: TZoneDispInfo;
begin
 ZZ:= VScene.Zones[id].DispInfo;
 Result:= sqrt( sqr(ZZ.rX2 - x) + sqr(ZZ.rY2 - y) ) <= 9;
end;

Function SceneCircPt(sx, sy, mult: Integer; Angle: Double): TPoint;
begin
 Result.X:= sx + SRound(mult * cos(Angle));
 Result.Y:= sy + SRound((mult div 2) * -sin(Angle));
end;

//Angle in degrees
Procedure DrawActorArrow(x, y, Angle: Integer; Dest: TCanvas);
var AngleRad: Double;
begin
 AngleRad:= ((Angle - 135) * pi) / 180; //-135 = Difference between regular and Scene angle systems
 Dest.Pen.Color:= clAqua;
 Dest.Pen.Style:= psSolid;
 Dest.Brush.Style:= bsSolid;
 Dest.Brush.Color:= clAqua;
 Dest.Polygon([SceneCircPt(x,y,8,AngleRad+pi/2),  //Left base
               SceneCircPt(x,y,24,AngleRad+pi/9.2), //Left head inner
               SceneCircPt(x,y,26,AngleRad+pi/6), //Left head outer
               SceneCircPt(x,y,30,AngleRad),      //Head top
               SceneCircPt(x,y,26,AngleRad-pi/6), //Right head outer
               SceneCircPt(x,y,24,AngleRad-pi/9.2), //Right head inner
               SceneCircPt(x,y,8,AngleRad-pi/2) ]); //Right base
end;

Procedure DrawActor(nr: Byte; x, y: Integer; Dest: TCanvas);
var AA: TActorDispInfo;
    x1, y1: Integer;
begin
 if (    VScene.Actors[nr].IsSprite and not ScVisible.ActorsSpri)
 or (not Vscene.Actors[nr].IsSprite and not ScVisible.Actors3D) then Exit;
 AA:= VScene.Actors[nr].DispInfo;
 x1:= AA.rX + x;
 y1:= AA.rY + y;
 //Dest.Brush.Style:= bsClear;

 If AA.UsesSprite then begin //sprite actor
   Dest.Draw(x1,y1,AA.Sprite);
   //Dest.Pen.Style:= psSolid;
   //PaintBrickFromString(Sprites[AA.SpriteIndex-1].Data, Point(x1,y1), Palette, Dest,
   // False, True, clWhite, True);
 end
 else begin  //normal actor
   //Dest.Brush.Style:= bsClear;
   //Dest.BrushCopy(Bounds(x1,y1,35,86),Form1.imgActor.Picture.Bitmap,Bounds(0,0,35,86),clWhite);
   DrawActorArrow(x1 + 17, y1 + 86,
     SceneAngleToDegrees(VScene.Actors[nr].Angle), Dest);
   Dest.Draw(x1,y1,fmMain.imgActor.Picture.Bitmap);
 end;
 if ScVisible.Clipping
 and ((VScene.Actors[nr].StaticFlags and sfClipped) <> 0) then begin
   Dest.Brush.Style:= bsClear; //TODO: Make the clipping be added to the actual
   Dest.Pen.Color:= clAqua;    //       Actor redraw size and position
   Dest.Pen.Style:= psDot;
   Dest.Rectangle(VScene.Actors[nr].Info0 + x + 24,
                  VScene.Actors[nr].Info1 + y + 24,
                  VScene.Actors[nr].Info2 + x + 24,
                  VScene.Actors[nr].Info3 + y + 24);
 end;
 Dest.Font.Color:= clAqua;
 Dest.Brush.Style:= bsClear;
 //Dest.TextOut(x1+(AA.Width div 2)-(Dest.TextWidth(temp) div 2),y1-30,temp);
 Dest.TextOut(x1+AA.CaptionX, y1+AA.CaptionY, IntToStr(nr));
end;

Procedure RedrawActor(nr: Byte; SelClear: Boolean = False; UpdClip: Boolean = True);
//var Wid: Integer;
begin
  //Wid:= Max(bufMain.Canvas.TextWidth(IntToStr(nr)),VScene.Actors[nr].DispInfo.Width);
  With VScene.Actors[nr].DispInfo do begin
    if SelClear then
      DrawPiece(//VScene.Actors[nr].DispInfo.rX + Off_X - 15{Arrow},
                //VScene.Actors[nr].DispInfo.rY + Off_Y - 30, Wid + 30{Arrow},
                //VScene.Actors[nr].DispInfo.Height + 30 + 30{Arrow},
                rX + GOffX + DrawOriginX, rY + GOffY + DrawOriginY,
                DrawWidth, DrawHeight,
                dmNormal, False, True, False)
    else begin
      DrawActor(nr, GOffX - GScrX, GOffY - GScrY, bufMain.Canvas);
      DrawPiece(//VScene.Actors[nr].DispInfo.rX + Off_X - 15{Arrow},
                //VScene.Actors[nr].DispInfo.rY + Off_Y - 30, Wid + 30{Arrow},
                //VScene.Actors[nr].DispInfo.Height + 30 + 30{Arrow},
                rX + GOffX + DrawOriginX, rY + GOffY + DrawOriginY,
                DrawWidth, DrawHeight,
                dmNormal, False, False, UpdClip, UpdClip, False,
                gX, gY, gZ);
   end;
 end;
end;

Procedure DeleteActor(nr: Byte);
var a: Integer;
begin
 If nr = 0 then begin
   Application.MessageBox('You cannot delete The Hero!','Little Big Architect',MB_ICONERROR+MB_OK);
   Exit;
 end;

 VScene.Actors[nr].DispInfo.Sprite.Free();

 SetObjectInList(3,nr,0,True); //Del from disp list
 RedrawActor(nr,True);         //Redraw the now empty area

 for a:= nr + 1 to High(VScene.Actors) do begin
   VScene.Actors[a - 1]:= VScene.Actors[a];  //Move the furhter actors back in array
   ChangeObjectInListID(3, a, a - 1);        //Change the display IDs of the actor
   ComputeActorDrawInfo(VScene.Actors[a-1], a-1); //update caption position (and other)
 end;
 SetLength(VScene.Actors, High(VScene.Actors));
 fmScriptEd.DeleteUnusedActorUndoRedo();

 //DelBreakMapItem(Actors[nr].gX, Actors[nr].gY, Actors[nr].gZ, 3, nr); Obsolete
 DrawMapA();
 SetSceneModified();
end;

Procedure SetActor(nr: Byte; x, y, z: SmallInt);
begin
 SetObjectInList(3,nr,0,True); //Del from disp list
 RedrawActor(nr,True, False);
 VScene.Actors[nr].x:= x;
 VScene.Actors[nr].y:= y;
 VScene.Actors[nr].z:= z;
 ComputeActorDispInfo(VScene.Actors[nr], nr);
 SetObjectInList(3,nr,x+z,False);
 RedrawActor(nr);
 SetSceneModified();
end;

Procedure ChangeActorSprite(nr: Byte; SpriteId: Word);
begin
 SetObjectInList(3,nr,0,True); //Del from disp list
 RedrawActor(nr, True);
 VScene.Actors[nr].Sprite:= SpriteId;
 ComputeActorDispInfo(VScene.Actors[nr], nr);
 SetObjectInList(3, nr, VScene.Actors[nr].X + VScene.Actors[nr].Z, False);
 RedrawActor(nr);
 SetSceneModified();
end;

//Centers the Actor in window and displays highlighting
Procedure HighlightActor(nr: Byte);
var aa: TActorDispInfo;
begin
 aa:= VScene.Actors[nr].DispInfo;
 ScrollMap(aa.rX + aa.DrawOriginX + GOffX - GScrX - ((fmMain.pbGrid.Width - aa.DrawWidth) div 2),
           aa.rY + aa.DrawOriginY + GOffY - GScrY - ((fmMain.pbGrid.Height - aa.DrawHeight) div 2));
 StartObjectHighlight(aa.rX + aa.DrawOriginX, aa.rY + aa.DrawOriginY,
   aa.DrawWidth, aa.DrawHeight);
end;

procedure CreateActor(x, y, z: SmallInt);
var ah: Integer;
begin
 ah:= Length(VScene.Actors);
 If ah < 256 then begin
   SceneUndoSetPoint(VScene);
   SetLength(VScene.Actors, ah + 1);
   VScene.Actors[ah].TrackScriptTxt:= 'END';
   VScene.Actors[ah].TrackScriptBin:= #0;
   VScene.Actors[ah].LifeScriptTxt:= 'END';
   VScene.Actors[ah].LifeScriptBin:= #0;
   VScene.Actors[ah].LifePoints:= 1; //If the value is = 0 the Actor won't appear in the Scene
   VScene.Actors[ah].UndoRedoIndex:= 0;
   SetActor(ah, x, y, z);
   SelectObject(otActor, ah);
 end
 else Application.MessageBox('No more Actors can be created','Little Big Architect',MB_ICONWARNING+MB_OK);
end;

procedure CreateActor(x, y, z: SmallInt; Template: TSceneActor);
var ah: Integer;
begin
 ah:= Length(VScene.Actors);
 If ah < 256 then begin
   SceneUndoSetPoint(VScene);
   SetLength(VScene.Actors, ah + 1);
   VScene.Actors[ah]:= Template;
   VScene.Actors[ah].TrackScriptTxt:= Template.TrackScriptTxt;
   VScene.Actors[ah].TrackScriptBin:= #0; //No need to copy that, it's always empty
   VScene.Actors[ah].LifeScriptTxt:= Template.LifeScriptTxt;
   VScene.Actors[ah].LifeScriptBin:= #0;
   VScene.Actors[ah].UndoRedoIndex:= 0;
   SetActor(ah, x, y, z);
   SelectObject(otActor, ah);
 end
 else Application.MessageBox('No more Actors can be created','Little Big Architect',MB_ICONWARNING+MB_OK);
end;

Procedure MakeObjectsDispList();
var a: Integer;
begin
 SetLength(ObjectList, 0);
 for a:= 0 to High(VScene.Points) do
   SetObjectInList(1, a, VScene.Points[a].X+VScene.Points[a].Z, False);
 for a:= 0 to High(VScene.Actors) do
   SetObjectInList(3, a, VScene.Actors[a].X+VScene.Actors[a].Z, False);
end;

Procedure DrawSelection;
var x, y: Integer;
    temp: String;
begin
 x:= GOffX - fmMain.HScr.Position;
 y:= GOffY - fmMain.VScr.Position;
 bufMain.Canvas.Pen.Style:= psDot;
 bufMain.Canvas.Pen.Color:= clWhite;
 bufMain.Canvas.Brush.Style:= bsClear;
 bufMain.Canvas.Font.Color:= clWhite;
 temp:= IntToStr(SelId);
 case SelType of
   otPoint: if SelId < Length(VScene.Points) then begin
              bufMain.Canvas.Rectangle(Bounds(VScene.Points[SelId].DispInfo.rX+x-24,
                VScene.Points[SelId].DispInfo.rY+y-39,26,39));
              bufMain.Canvas.TextOut(VScene.Points[SelId].DispInfo.rX+x
                - (bufMain.Canvas.TextWidth(temp) div 2),
                VScene.Points[SelId].DispInfo.rY+y-64,temp);
            end;
   otActor: if SelId < Length(VScene.Actors) then begin
              bufMain.Canvas.Rectangle(Bounds(VScene.Actors[SelId].DispInfo.rX+x,
                VScene.Actors[SelId].DispInfo.rY + y,
                VScene.Actors[SelId].DispInfo.Width,
                VScene.Actors[SelId].DispInfo.Height));
              bufMain.Canvas.TextOut(x + VScene.Actors[SelId].DispInfo.rX
                + (VScene.Actors[SelId].DispInfo.Width div 2)
                - (bufMain.Canvas.TextWidth(temp) div 2),
                y + VScene.Actors[SelId].DispInfo.rY-30, temp);
            end;
   otZone:  if SelId < Length(VScene.Zones) then
              DrawZone(SelId, x, y, bufMain.Canvas, False, True);
 end;
end;

Procedure SceneToXY(x, y, z, pX, pY: Integer; var rX, rY: Integer);
begin
 if LBAMode = 2 then begin
   Dec(pY, 12);
   Inc(pX, 1);
 end;  
 rX:= Trunc((x-z)*(24/512)) + pX + 24;
 rY:= Trunc((x+z)*(12/512)-(y*(15/256)-15)) + pY + 12;
end;

Procedure SceneToGrid(x, y, z: Integer; var gX, gY, gZ: Integer);
begin
 gX:= SRound(x/512); //asymmetric arithmetic rounding
 If gX > GHiX then gX:= GHiX else if gX < 0 then gX:= 0;
 gY:= SRound(y/256);
 If gY > GHiY then gY:= GHiY else if gY < 0 then gY:= 0;
 gZ:= SRound(z/512);
 If gZ > GHiZ then gZ:= GHiZ else if gZ < 0 then gZ:= 0;
end;

{Procedure DeleteAll(DTracks, DZones, DActors: Boolean; Redraw: Boolean = True);
var a, b, c: Integer;
begin
 If DTracks then
  for a:= 0 to High(VScene.Tracks) do
   SetObjectInList(1, a, 0, True);
 If DActors then
  for a:= 0 to High(VScene.Actors) do
   SetObjectInList(3, a, 0, True);
 If DTracks then SetLength(VScene.Tracks,0);
 If DZones then SetLength(VScene.Zones,0);
 If DActors then SetLength(VScene.Actors,0);
 //SetLength(ObjectList,0);
 If Redraw then DrawMapA;
end;}

Function PositionInside(X, Y: Integer; ObjType: TObjType; ObjId: Integer): Boolean;
begin
 Result:= False;
 case ObjType of
   otPoint: Result:= (X >= VScene.Points[ObjId].DispInfo.rX - 24)
                 and (X <  VScene.Points[ObjId].DispInfo.rX)
                 and (Y >= VScene.Points[ObjId].DispInfo.rY - 37)
                 and (Y <  VScene.Points[ObjId].DispInfo.rY);
   otActor: Result:= (X >= VScene.Actors[ObjId].DispInfo.rX)
                 and (X <= VScene.Actors[ObjId].DispInfo.rX + VScene.Actors[ObjId].DispInfo.Width)
                 and (Y >= VScene.Actors[ObjId].DispInfo.rY)
                 and (Y <= VScene.Actors[ObjId].DispInfo.rY + VScene.Actors[ObjId].DispInfo.Height);
   otZone:  Result:= (X >= VScene.Zones[ObjId].DispInfo.sX2)
                 and (X <  VScene.Zones[ObjId].DispInfo.sX1)
                 and ( (Y - VScene.Zones[ObjId].DispInfo.rY1 + VScene.Zones[ObjId].DispInfo.h) * 2
                    >= (- X + VScene.Zones[ObjId].DispInfo.rX1) ) //top left side
                 and ( (Y - VScene.Zones[ObjId].DispInfo.rY1 + VScene.Zones[ObjId].DispInfo.h) * 2
                    >= (X - VScene.Zones[ObjId].DispInfo.rX1) )   //top right side
                 and ( (Y - VScene.Zones[ObjId].DispInfo.sY2) * 2
                     < (X - VScene.Zones[ObjId].DispInfo.sX2) )   //bottom left side
                 and ( (Y - VScene.Zones[ObjId].DispInfo.sY1) * 2
                     < (- X + VScene.Zones[ObjId].DispInfo.sX1) ) //bottom right side
 end;
end;

Function GetObjectAtCursor(X, Y: Integer; FindTracks, FindActors, FindZones: Boolean;
 out ObjType: TObjType): Byte;
var a, rX, rY: Integer;
begin
 Result:= 0;
 rX:= X - GOffX + GScrX;
 rY:= Y - GOffY + GScrY;
 ObjType:= otNone;
 If FindTracks then
   for a:= 0 to High(VScene.Points) do
     If (VScene.Points[a].DispInfo.gY <= HiVisLayer)
     and PositionInside(rX, rY, otPoint, a) then begin
       ObjType:= otPoint;
       Result:= a;
       Break;
     end;
 If FindActors then
   for a:= 0 to High(VScene.Actors) do
     If (VScene.Actors[a].DispInfo.gY <= HiVisLayer)
     and PositionInside(rX,rY,otActor,a) then begin
       ObjType:= otActor;
       Result:= a;
       Break;
     end;
 If FindZones then
   for a:= 0 to High(VScene.Zones) do
     If (VScene.Zones[a].DispInfo.gY2 <= HiVisLayer)
     and PositionInside(rX,rY,otZone,a) then begin
       ObjType:= otZone;
       Result:= a;
       Break;
     end;
end;

Function GetObjectsAtCursor(X, Y: Integer; FindTracks, FindActors,
  FindZones: Boolean): TSceneObjects;
var a, rX, rY, rh: Integer;
  procedure AddObject(ot: TObjType; id: Integer);
  begin
    Inc(rh);
    SetLength(Result, rh + 1);
    Result[rh].oType:= ot;
    Result[rh].oId:= id;
  end;
begin
 rh:= -1;
 SetLength(Result, 0);
 rX:= X - GOffX + GScrX;
 rY:= Y - GOffY + GScrY;
 if FindActors then
   for a:= 0 to High(VScene.Actors) do
     if (VScene.Actors[a].DispInfo.gY <= HiVisLayer)
     and ((    VScene.Actors[a].IsSprite and ScVisible.ActorsSpri)
       or (not VScene.Actors[a].IsSprite and ScVisible.Actors3D))
     and PositionInside(rX, rY, otActor, a) then
       AddObject(otActor, a);
 if FindTracks then
   for a:= 0 to High(VScene.Points) do
     If (VScene.Points[a].DispInfo.gY <= HiVisLayer)
     and PositionInside(rX, rY, otPoint, a) then
       AddObject(otPoint, a);
 if FindZones then
   for a:= 0 to High(VScene.Zones) do
     if (VScene.Zones[a].DispInfo.gY1 <= HiVisLayer)
     and (VScene.Zones[a].RealType in ScVisible.Zones)
     and PositionInside(rX, rY, otZone,a) then
       AddObject(otZone, a);
end;

Procedure MoveObject(ObjType: TObjType; ObjId: Byte; dx, dy: Integer; Vertical: Boolean);
var NewSX, NewSY, NewSZ: Integer;
begin
 case ObjType of
   otPoint: begin
              SceneMoveBy(VScene.Points[ObjId].x, VScene.Points[ObjId].y,
                VScene.Points[ObjId].z, dx, dy, Vertical, NewSX, NewSY, NewSZ);
              If (NewSX <> VScene.Points[ObjId].x) or (NewSY <> VScene.Points[ObjId].y)
              or (NewSZ <> VScene.Points[ObjId].z) then
                SetTrack(ObjId, NewSX, NewSY, NewSZ);
            end;
   otActor: begin
              SceneMoveBy(VScene.Actors[ObjId].x, VScene.Actors[ObjId].y,
                VScene.Actors[ObjId].z, dx, dy, Vertical, NewSX, NewSY, NewSZ);
              If (NewSX <> VScene.Actors[ObjId].x) or (NewSY <> VScene.Actors[ObjId].y)
              or (NewSZ <> VScene.Actors[ObjId].z) then
                SetActor(ObjId, NewSX, NewSY, NewSZ);
            end;
    otZone: begin
              SceneMoveBy(VScene.Zones[ObjId].X1, VScene.Zones[ObjId].Y1,
                VScene.Zones[ObjId].Z1, dx, dy, Vertical, NewSX, NewSY, NewSZ);
              If (NewSX <> VScene.Zones[ObjId].X1) or (NewSY <> VScene.Zones[ObjId].Z1)
              or (NewSZ <> VScene.Zones[ObjId].Z1) then begin
                //Avoid 32767 range overflow
                NewSX:= Min(NewSX, 32767 - VScene.Zones[ObjId].X2 + VScene.Zones[ObjId].X1);
                NewSY:= Min(NewSY, 32767 - VScene.Zones[ObjId].Y2 + VScene.Zones[ObjId].Y1);
                NewSZ:= Min(NewSZ, 32767 - VScene.Zones[ObjId].Z2 + VScene.Zones[ObjId].Z1);
                SetZone(ObjId, NewSX, NewSY, NewSZ,
                  NewSX + VScene.Zones[ObjId].X2 - VScene.Zones[ObjId].X1,
                  NewSY + VScene.Zones[ObjId].Y2 - VScene.Zones[ObjId].Y1,
                  NewSZ + VScene.Zones[ObjId].Z2 - VScene.Zones[ObjId].Z1,
                  VScene.Zones[ObjId].RealType);
              end;
            end;
 end;
 If (ObjType <> otNone) then
   fmMain.frSceneObj.ChangeSceneObj();
end;

Procedure SelectObject(ObjType: TObjType; ObjId: Byte);
var TempType: TObjType;
begin
 if (ObjType = SelType) and (ObjId = SelId) then Exit;
 if ((SelType = otPoint) and (Length(VScene.Points) <= 0))
 or ((SelType = otZone)  and (Length(VScene.Zones)  <= 0))
 or ((SelType = otActor) and (Length(VScene.Actors) <= 0)) then Exit;
 TempType:= SelType;
 SelType:= otNone;
 case TempType of
   otPoint: RedrawTrack(SelId, True);
   otActor: RedrawActor(SelId, True);
   otZone:  RedrawZone(SelId, True);
 end;
 if ObjType <> otNone then begin
  SelType:= ObjType;
  SelId:= ObjId;
  case SelType of
    otPoint: LastSelTrack:= SelId; //RedrawTrack(SelId);
    otZone:  LastSelZone:=  SelId;
    otActor: LastSelActor:= SelId; //RedrawActor(SelId, True);
  end;
  DrawSelection();
  {$ifndef NO_BUFFER}UpdateImage(bufMain,fmMain.pbGrid);{$endif}
  if (ObjType = otActor) and fmScriptEd.Visible then
    fmScriptEd.OpenScripts(ObjId);
 end;
 fmMain.frSceneObj.InitSceneObj();
end;

procedure DrawZoneSelectionIcon(Target: TCanvas; Col: TColor);
begin
 Target.Pen.Color:= Col;
 Target.MoveTo(6, 13); Target.LineTo(1, 11); Target.LineTo(1, 4);
 Target.LineTo(8, 1);
 Target.MoveTo(7, 1); Target.LineTo(14, 4); Target.LineTo(14, 11);
 Target.LineTo(7, 14); Target.LineTo(7, 7); Target.LineTo(14, 4);
 Target.MoveTo(3, 5); Target.LineTo(7, 7);
end;

//Adds the Zone coloured icons to the ilSceneSelObj Image List
//(each icon is for one Zone type and has different colour)
procedure MakeZoneSelectionIcons();
var a: Integer;
    zt: TZoneType;
    bmp: TBitmap;
    bc: TColor;
begin
 bmp:= TBitmap.Create();
 try
   bmp.PixelFormat:= pf24bit;
   bmp.Transparent:= False;
   bmp.Width:= 16;
   bmp.Height:= 16;
   //bmp.Canvas.Brush.Color:= clFuchsia;
   //bmp.Canvas.FillRect(Rect(0,0,16,16));
   if fmMain.imgSceneSelObj.Count > 2 then
     for a:= HiZoneType downto 0 do
       fmMain.imgSceneSelObj.Delete(a + 2);
   for zt in AllZoneTypes do begin
     if Sett.Scene.ZoneColours[zt] = clFuchsia then bc:= clBlue
                                               else bc:= clFuchsia;
     bmp.Canvas.Brush.Color:= bc;
     bmp.Canvas.FillRect(Rect(0,0,16,16));
     DrawZoneSelectionIcon(bmp.Canvas, Sett.Scene.ZoneColours[zt]);
     fmMain.imgSceneSelObj.AddMasked(bmp, bc);
   end;
 finally
   bmp.Free();
 end;
end;

end.
