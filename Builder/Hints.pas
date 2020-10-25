//******************************************************************************
// Little Big Architect: Builder - editing grid files containing rooms in
//                                 Little Big Adventure 1 & 2
//
// Hints unit.
// Contains routines used for displaying hints and coordinates.
//
// Copyright Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit Hints;

interface

uses Windows, ExtCtrls, Graphics, SysUtils, StrUtils, Math, Controls;

//TODO: Make an option in the settings to use short hints instead of hint box
(*const HintArray: array[-1..34] of String =
   ('',
    'To open a grid file click File->Open (simple or advanced)',
 {1}//'Hand tool|Hand - use for panning image',
    //'Placer tool|Placer - use for placing layouts on the grid',
    //'Selector tool|Selector - use for selecting bricks',
    //'LEFT click to place layout on the grid at current layer'#13'LEFT HOLD and MOVE up/down to place at another layer'#13'RIGHT HOLD and MOVE up/down to change layer (without placing)',
 {5}//'Left hold and move to pan image',
    //'Select layout you want to place on the grid',
    //'Select by single bricks',
    //'Select by columns (cells of the grid)',
    //'Select by layouts (bricks belonging to one layout)'#13'WARNING: Doesn''t work well for some layouts! (depends on arrangement)',
{10}//'Shows frame(s) around brick(s) being moved',
    //'Shows frames around layout that is to be placed',
    //'Shows frames around layouts in the palette',
    //'Shows frames below the moved layout/fragment,'#13'that help you to adjust its vertical position',
    //'Adjusts vertical position of layout being placed',
{15}//'LEFT click to select'#13'LEFT HOLD and MOVE to select area (doesn''t work for layout selecting)',
    //'Drag with LEFT mouse button to move horizonatally (X and Z axes) (CTRL to copy)'#13'Drag with RIGHT mouse button to move vertically (Y axis)'#13'Press DEL to delete selected fragment',
    //'Draws edges around bricks on the map',
    //'Draws flat net behind the grid',
    //'Draw only to specified layer'#13'Disables drawing of layers above specified',
{20}//'RELEASE mouse button to drop the fragment',
    //'Creates new empty grid',
    //'Opens an existing grid so that you can edit it',
    //'Saves current grid to a file that can be later used in LBA',
    //'Exports current grid to a bitmap (WARNING: This function doesn''t work under Windows 98 and older)',
{25}//'Exits the program',
    //'Opens settings dialog box',
    //'Shows/hides hint box',
    //'Grid file successfully saved',
    //'Image sucessfully exported',
{30}//'Files successfully loaded',
    //'Select by First Non-Transparent'#13'Selects: a brick that the pixel pointed by the mouse cursor belongs to',
    //'Select by First Non-Empty'#13'Selects: a brick that is geometrically in front of the image and is under the mouse cursor',
    //'Minimize/expand the panel',
    //'Lock at top right corner',
{35}//'Lock at top left corner',
    //'Lock at bottom left corner',
    //'Lock at bottom right corner',
    //'Toggle reset limits after placing',
    //'Click on measure cells to delimit part of the layout that will be placed'#13'Click and move to select range'#13'Click on blue triangles to select full axes',
{40}//'Invisible Bricks Mode - use for editing invisible bricks',
    //'Shows frame(s) around brick pointed by the mouse, indicating which one it will be',
    //'Undo last action',
    //'Redo last undone action',
    //'Coordinates panel - click to hide.',
{45}//'Displays Grid coordinates',
    //'Delete specified layer'#13'Deletes all contents of the layer which number is in the box on the left',
    //'Show/hide Advanced panel.'#13'Advanced panel allows you to expand current layout to specified numbers of bricks in all axes.'#13'Layout will be cloned to fit the desired dimensions.',
    //'Adjust X dimension',
    //'Adjust Y dimension',
{50}//'Adjust Z dimension',
    //'Change alignment in X axis',
    //'Change alignment in Y axis',
    //'Change alignment in Z axis',
    //'Shows frames in 3 dimensions coming from the moved layout/fragment,'#13'that help to adjust its position in all 3 dimensions',
{55}//'Left hold and move to pan image'#13'<Shift> - switch to Point adding mode'#13'<Shift> + <Ctrl> - switch to Actor adding mode',
    //'Thumbnail - shows overview of the grid or fragment'#13'Click to jump to the area pointed by cursor',
    //'Edit mode - allows you to move, delete scene elements, and add new ones',
    //'Add Point mode - allows you to add new Points',
    '*not used*',
{60}//'Displays scene coordinates and information about selected scene elements',
    //'Highlights Invisible Bricks by drawing frames around them',
    //'Show Points (right click to select a Point)',
    //'Show Zones (right click to select a Zone)',
    //'Show Actors (right click to select an Actor)',
{65}//'Show clipping. Draws clipping rectangles around actors that use clipping',
    //'Select all types of Zones to be displayed',
    //'Select all types of Zones NOT to be displayed',
    //'Show/hide Cube Zones (type 0)',
    //'Show/hide Camera Zones (type 1)',
{70}//'Show/hide Sceneric Zones (type 2)',
    //'Show/hide Grid Zones (type 3)',
    //'Show/hide Object Zones (type 4)',
    //'Show/hide Text Zones (type 5)',
    //'Show/hide Ladder Zones (type 6)',
{75}//'LEFT hold and move to move an element in X and Z axes, RIGHT hold and move to move element in Y axis'#13'<Shift> - switch to Point adding mode. <Shift>+<Ctrl> - switch to Actor adding mode.'#13'<Ctrl> and LEFT click an Actor to duplicate it',
    //'LEFT click to add a new Point at cursor position',
    //'Creates a new wall made of invisible bricks',
    //'Add Actor mode - allows you to add new Actors.'#13'If you hold <Alt> while pressing the button, the template dialog will be skipped, and empty Actor will be chosen for creation.',
    //'Scenario successfully saved',
{80}//'Add Zone mode - allows you to create new Zones',
    //'<Ctrl> - change Zone height (Y)'#13'<Shift> - move Zone (instead of changing its size)'#13'<Ctrl> + <Shift> - both of above',
    //'LEFT hold and move to begin adding a new Zone at cursor position',
    //'LEFT click to add a new Actor at cursor position',
    //'Automatically find Actor when selected in the Object Panel',
{85}//'Automatically find Point when selected in the Object Panel',
    //'Automatically find Zone when selected in the Object Panel',
    //'Entity index (starting with 0)|Entity index in the File3D.hqr (starting with 0)'#13
    //+ 'If the number is red, it means that there is no Entity with this index in the File3D.hqr. In such case you should set one of the existing Entities, otherwise the game may crash',
    //'Entity of the Actor|You may select another Entity for the Actor'#13'But be careful, because the new Entity may not have Body and Anim with proper virtual indexes',
    //'Body of the Actor|Virtual Body index in the current Entity'#13'If the number is red, it means that there is no Body with this virtual index in the Entity. In such case you should set one of the existing Bodies, otherwise the game may crash',
{90}//'Virtual Body index of the Actor|You may select another Body for the current Entity'#13'The first number (without parenthesis) is the real index of the Body - entry index in the Body.hqr file.'#13
    //+ 'The second number (in parenthesis) is the virtual index of the Body - it is used to call this Body in Scenes.',
    //'Animation of the Actor|Virtual Animation index in the current Entity'#13'If the number is red, it means that there is no Animation with this virtual index in the Entity. In such case you should set one of the existing Animations, otherwise the game may crash',
    //'Virtual Animation index of the Actor|You may select another Animation for the current Entity'#13'The first number (without parenthesis) is the real index of the Animation - entry index in the Anim.hqr file.'#13
    //+ 'The second number (in parenthesis) is the virtual index of the Animation - it is used to call this Animation in Scenes.'
    //'Scene file successfully saved'
        );  *)

var
 HintsOn: Boolean = False;
 LastHint: Integer = -1;
 CurCoords, SelCoords, BrkInfo: String;

procedure PutHint(Hint: String);
procedure PutMessage(Msg: String);
procedure SetCoordsPos();
Function MouseToScene(X, Y: Integer; out sX, sY, sZ: Integer;
  Snap: Boolean = False; SnapOffset: Boolean = False): Boolean;
procedure SceneToMouse(sX, sY, sZ: Integer; out X, Y: Integer); overload;
function SceneToMouse(sX, sY, sZ: Integer): TPoint; overload;
Procedure MouseToSceneXZ(X, Y, sY: Integer; out sX, sZ: Integer;
  Snap: Boolean = False);
Function MouseToSceneY(X, Y, sX: Integer; Snap: Boolean = False): Integer;
procedure UpdateCoords(X: Integer = 0; Y: Integer = 0);
procedure ClearCoords();

implementation

uses Main, Grids, Rendering, Engine, Settings, Scene, Open, Globals, Maps;

{procedure PutHint(Index: Integer = -1);
begin
 If fmMain.Timer.Enabled then Exit;
 If not HintsOn then Index:= -1;
 If Index <> LastHint then begin
   fmMain.lbHints.Font.Color:= clBlack;
   fmMain.lbHints.Font.Size:= 8;
   fmMain.lbHints.Caption:= GetLongHint(HintArray[Index]);
   fmMain.lbHints.Repaint();
   LastHint:= Index;
   fmMain.lbHints.Update();
 end;
end;}

procedure PutHint(Hint: String);
begin
 If fmMain.tmHintMsg.Enabled then Exit;
 If not HintsOn then begin
   if fmMain.lbHints.Caption <> '' then
     fmMain.lbHints.Caption:= '';
   Exit;
 end;

 fmMain.lbHints.Font.Color:= clWindowText;
 fmMain.lbHints.Font.Size:= 8;
 fmMain.lbHints.Caption:= GetLongHint(Hint);
 fmMain.lbHints.Repaint();
end;

{procedure PutMessage(Index: Integer = -1);
begin
 If fmMain.Timer.Enabled then Exit;
 fmMain.lbHints.Font.Color:= clBlue;
 fmMain.lbHints.Font.Size:= 16;
 fmMain.lbHints.Caption:= HintArray[Index];
 fmMain.lbHints.Repaint;
 LastHint:= Index;
 fmMain.Timer.Enabled:= True;
end;}

procedure PutMessage(Msg: String);
begin
 If fmMain.tmHintMsg.Enabled then Exit;
 fmMain.lbHints.Font.Color:= clBlue;
 fmMain.lbHints.Font.Size:= 16;
 fmMain.lbHints.Caption:= Msg;
 fmMain.lbHints.Repaint();
 fmMain.tmHintMsg.Enabled:= True;
end;

procedure SetCoordsPos();
begin
 With fmMain do begin
  paCoords.Left:= pbGrid.Width - paCoords.Width + 1;
  paCoords.Top:= pbGrid.Height - paCoords.Height + 1;
 end;
end;

Function CoordsString(B: TBox): String;
begin
 If BoxIsPoint(B) then
  Result:= Format(' [%d, %d, %d] ',[B.x1,B.y1,B.z1])
 else if not Sett.Coords.RangeCon then
  Result:= Format(' [%d, %d, %d] ÷ [%d, %d, %d] ',[B.x1,B.y1,B.z1,B.x2,B.y2,B.z2])
 else if Sett.Coords.RangeHide then begin
  Result:= ' [' + IntToStr(B.x1);
  If B.x2 <> B.x1 then Result:= Result + ':' + IntToStr(B.x2);
  Result:= Result + ', ' + IntToStr(B.y1);
  If B.y2 <> B.y1 then Result:= Result + ':' + IntToStr(B.y2);
  Result:= Result + ', ' + IntToStr(B.z1);
  If B.z2 <> B.z1 then Result:= Result + ':' + IntToStr(B.z2);
  Result:= Result + ' ] ';
 end
 else Result:= Format(' [%d:%d, %d:%d, %d:%d] ',[B.x1,B.x2,B.y1,B.y2,B.z1,B.z2]);
end;

//respects snapping, SnapOffset moves snapping point so that it's more 'natural',
//  maybe it should always work like this?
//TODO: make it respect brick shapes. 
Function MouseToScene(X, Y: Integer; out sX, sY, sZ: Integer;
  Snap: Boolean = False; SnapOffset: Boolean = False): Boolean;
var oX, oY: Integer;
    pX, pZ: Real;
begin
 oX:= X - (GCursor.x1-GCursor.z1) * 24;
 oY:= Y - (GCursor.x1+GCursor.z1) * 12 + GCursor.y1*15;
 //oX, oY: distances from the brick (0,0) point to mouse in pixels
 pX:= (oX / 2) + oY + 1;
 pZ:= -(oX / 2) + oY + 0.5;
 //pX, pZ: distances in Scene arrangement (isometric) but still in pixels
 Result:= (pX >= 0) and (pX <= 24) and (pZ >= 0) and (pZ <= 24);
 //fmMain.cbScZone0_.Caption:= Format('%d, %d', [oX, oY]);  for testing

 If Result then begin
   If Snap then begin
     if SnapOffset then begin
       sX:= GCursor.x1 * 512 + SRound((pX * 512 / 24) / 256) * 256;
       sZ:= GCursor.z1 * 512 + SRound((pZ * 512 / 24) / 256) * 256;
     end else begin
       sX:= GCursor.x1 * 512 + Trunc((pX * 512 / 24) / 256) * 256;
       sZ:= GCursor.z1 * 512 + Trunc((pZ * 512 / 24) / 256) * 256;
     end;
   end else begin
     //rX:=(PCursor.x1+1)*512;
     sX:= GCursor.x1 * 512 + Trunc(pX * 512 / 24);
     //rZ:=(FneCoords[2]+1)*512
     sZ:= GCursor.z1 * 512 + Trunc(pZ * 512 / 24);
   end;
   sY:= (GCursor.y1 + IfThen(LBAMode = 2, 0, 1)) * 256;
 end;
end;

procedure SceneToMouse(sX, sY, sZ: Integer; out X, Y: Integer);
var bX, bZ: Real;
begin
 bX:= sX/512;
 bZ:= sZ/512;
 X:= SRound((bX - bZ) * 24);
 Y:= SRound((bX + bZ) * 12 - sY/256 * 15);
end;

function SceneToMouse(sX, sY, sZ: Integer): TPoint;
var bX, bZ: Real;
begin
 bX:= sX/512;
 bZ:= sZ/512;
 Result.X:= SRound((bX - bZ + 1) * 24);
 Result.Y:= SRound((bX + bZ + 1) * 12 - (sY/256) * 15);
end;

//oblicza pozycjê we wspó³rzêdnych sceny tylko w poziomie (XZ) dla danej wysokoœci (Y)
//TODO: Make this function working good with LBA 2 scene Y difference
Procedure MouseToSceneXZ(X, Y, sY: Integer; out sX, sZ: Integer;
  Snap: Boolean = False);
begin
 //If Grid.Lba2 then Dec(pY,15);
 sX:= SRound( (Y*2 + X)*(512/48) + (sY-512)*(60/48) );
 sZ:= SRound( (Y*2 - X)*(512/48) + (sY-512)*(60/48) );
 If Snap then begin
   sX:= ( sX div 256 ) * 256;
   sZ:= ( sZ div 256 ) * 256;
 end
end;

//oblicza pozycjê we wspó³rzêdnych sceny tylko w pionie (Y) dla danych X i Z
//TODO: Make this function working good with LBA 2 regarding the Y difference
// It doesn't require sZ, because we can get sY without knowing it
Function MouseToSceneY(X, Y, sX: Integer; Snap: Boolean = False): Integer;
begin
 Result:= SRound( sX*(48/60) - (Y*2 + X)*(512/60) + 2053/5 );
 If Snap then
   Result:= ( Result div 256 ) * 256;
end;

//{$o-}
procedure UpdateCoords(X: Integer = 0; Y: Integer = 0);
var mi: TMapItem;
    CToDisp, ScenePix, SceneBrk, SceneSel: String;
    rX, rY, rZ: Integer;
begin  
 If ProgMode = pmScene then begin
   If (GCursor.x1 > -1) and BoxIsPoint(GCursor) then begin
     If Sett.Coords.SceneBrk then
      SceneBrk:= Format(' [%d*512, %d*256, %d*512] ',
        [GCursor.x1, GCursor.y1 + 1 - IfThen(LBAMode = 2, 1), GCursor.z1]);
     If Sett.Coords.SceneCrds and MouseToScene(X, Y, rX, rY, rZ) then
       ScenePix:= Format(' [%d, %d, %d] ', [rX, rY, rZ]);

     CToDisp:= ScenePix;
     If SceneBrk <> ''  then CToDisp:= IfThen(CToDisp<>'',CToDisp+#13'          = ') + SceneBrk;
     //If SceneCom<>'' then SceneText:= IfThen(SceneText<>'',SceneText+#13'          = ')+SceneCom;
     If CToDisp <> '' then CToDisp:= ' Scene: ' + CToDisp;
      //Form1.pbGrid.Canvas.Ellipse(pX-5,pZ-5,pX+6,pZ+6);
   end;
   If Sett.Coords.SceneSel and (SelType <> otNone) then begin
     SceneSel:= ' Selected: ';
     case SelType of
       otPoint:
         SceneSel:= SceneSel + 'Point' + Format('%d [%d, %d, %d]',
           [SelId, VScene.Points[SelId].x, VScene.Points[SelId].y, VScene.Points[SelId].z]);
       otZone:
         SceneSel:= SceneSel + 'Zone ' + IntToStr(SelId) + CoordsString(
           Box(VScene.Zones[SelId].X1, VScene.Zones[SelId].Y1, VScene.Zones[SelId].Z1,
               VScene.Zones[SelId].X2, VScene.Zones[SelId].Y2, VScene.Zones[SelId].Z2));
       otActor:
         SceneSel:= SceneSel + 'Actor ' + Format('%d [%d, %d, %d]',
           [SelId,VScene.Actors[SelId].x,
                  VScene.Actors[SelId].y,VScene.Actors[SelId].z]);
     end;

     CToDisp:= IfThen(CToDisp <> '', CToDisp + #13) + SceneSel;
   end;
   If Sett.Coords.SceneClip then
     CToDisp:= IfThen(CToDisp <> '', CToDisp + #13) + Format(' Clip position: [%d, %d] ',[X, Y-24]);
 end
 else begin
   SelCoords:= '';
   BrkInfo:= '';
   CurCoords:= '';
   If GridTool in [gtSelect, gtInvisi] then begin

     If Sett.Coords.Cursor and (GCursor.x1 > -1) then
       CurCoords:= ' Cursor: ' + CoordsString(GCursor)
     else CurCoords:= '';

     If Sett.Coords.Selection and GHasSelection then
       SelCoords:= ' Selection: ' + CoordsString(GSelect)
     else SelCoords:= '';

     BrkInfo:= '';
     If Sett.Coords.BrkInfo then begin
       mi.BrkNr:= -1000;
       If Sett.Coords.BrkInfoSel and (GSelect.x1 > -1) and BoxIsPoint(GSelect) then
         mi:= CMap^.M^[GSelect.x1, GSelect.y1, GSelect.z1]
       else if not Sett.Coords.BrkInfoSel and (GCursor.x1 > -1) and BoxIsPoint(GCursor) then
         mi:= CMap^.M^[GCursor.x1, GCursor.y1, GCursor.z1];
       If mi.BrkNr > -1000 then
         BrkInfo:= Format(' Layout: %d, Piece: %d, Brick: %d ',
                     [IfThen(Sett.General.FirstIndex1, mi.Idx.Lt, mi.Idx.Lt - 1),
                      mi.Idx.Brk, mi.BrkNr]);
     end;
   end
   else if (GridTool = gtPlace) and Sett.Coords.Cursor and (GPlacePos.x > -1) then
     CurCoords:= ' Place: ' + CoordsString(Box(GPlacePos.x,GPlacePos.y,GPlacePos.z,
       GPlacePos.x+PlaceObj.X-1, GPlacePos.y+PlaceObj.Y-1, GPlacePos.z+PlaceObj.Z-1));

   CToDisp:= CurCoords;
   If SelCoords <> '' then CToDisp:= IfThen(CToDisp <> '', CToDisp + #13) + SelCoords;
   If BrkInfo <> ''   then CToDisp:= IfThen(CToDisp <> '', CToDisp + #13) + BrkInfo;
 end;

 fmMain.lbCoords.Caption:= CToDisp;
 //Form1.paCoords.Visible:=Form1.lbCoords.Caption<>'';
 SetCoordsPos();
 fmMain.lbCoords.Update(); //repaint immediately
end;

procedure ClearCoords();
begin
 fmMain.lbCoords.Caption:= '';
 SetCoordsPos();
 fmMain.lbCoords.Update();
end;

end.
