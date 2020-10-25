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
     Engine, Classes;

type
  {Command codes:
     01 - test
     02 - open another grid
     03 - close program
     04 - enable backward communication
     08 - begin updating
     09 - end updating
     11 - set track   12 - delete track   13 - delete all tracks   14 - select track
     21 - set zone    22 - delete zone    23 - delete all zones    24 - select zone
     31 - set actor   32 - delete actor   33 - delete all actors   34 - select actor
    101 - save scenario to a temp file

   Command results:
    0 - unknown error
    1 - not in Scene Mode
    2 - unknown command
    3 - invalid data format
    4 - invalid parameters
    999 - ok
    1000 - test ok
  }

  TComData = record
   Id: Byte;
   x1, y1, z1, x2, y2, z2: SmallInt; //signed 16-bit integer
   Data: Integer;
   Text: array[0..200] of Char; // null-terminated string  (200 characters + trailing null)
   cx1, cy1, cx2, cy2: SmallInt;
  end;

  {Backward commands:
    01 - Test Connection
    10 - Set Tracks coordinates   11 - Select Track   12 - Delete Track  13 - New Track
    20 - Set Zones coordinates    21 - Select Zone    22 - Delete Zone   23 - New Zone
          24 - Clone Zone (all params)   29 - New zone (all params)
    30 - Set Actors coordinates   31 - Select Actor   32 - Delete Actor
          33 - New Actor    34 - New Sprite Actor   35 - Clone Actor
    101 - Save scenario to the temp file      

   Command results:
    0 - unknown error
    1 - invalid id
    10 - invalid command
    100 - command ok
    1000 - test ok }

  TBackCommand = record     //backward communication command
   Id: Byte;
   x1, y1, z1, x2, y2, z2: SmallInt;
  end;

  TSceneTrack = record
   Enabled: Boolean;
   x, y, z: SmallInt; //scene position
   rX, rY: Integer;   //screen relative position
   gX, gY, gZ: Integer;  //grid position
   Caption: ShortString;
  end;

  TSceneActor = record
   Enabled: Boolean;
   x, y, z: SmallInt; //scene position
   rX, rY: Integer;   //screen relative position
   gX, gY, gZ: Integer;
   Caption: ShortString;
   SpriteIndex: Integer;
   cX1, cY1, cX2, cY2: Integer; //clipping
   Width, Height: Integer; //pixels
   UsesClipping: Boolean;
   Sprite: TBitmap;
  end;

  TSceneZone = record
   Enabled: Boolean;
   x1, y1, z1, x2, y2, z2: SmallInt;
   rX1, rY1, rX2, rY2: Integer;
   gX1, gY1, gZ1, gX2, gY2, gZ2: Integer;
   h: Integer; //height in screen pixels
   sX1, sY1, sX2, sY2: Integer; //pixel coordinates of the bottom left and right corners
   Caption: ShortString;
   ZoneType: Byte;
  end;

  TSpriteInfo = record
   OffsetX, OffsetY: Integer;
   MinX, MaxX: Integer;
   MinY, MaxY: Integer;
   MinZ, MaxZ: Integer;
  end;

var
  Tracks: array of TSceneTrack;
  Actors: array of TSceneActor;
  ObjectList: array of record
   typ, id: Byte;
   position: Integer;
  end;
  Zones: array of TSceneZone;
  Sprites: TPackEntries;
  SprActInfo: array of TSpriteInfo;
  SceneUseSprites: Boolean = False;
  SceneMode: Boolean = False;
  SceneClipL: Integer = 0;
  SceneClipR: Integer = 0;
  SceneUpdateStarted: Boolean = False;
  ZoneEnabledTypes: array[0..6] of Boolean;
  DisplayActorClipping: Boolean;
  BackCommand: TBackCommand;
  BackCommEnabled: Boolean = False;
  BackCommHandle: HWND;

  SelType: Byte = 0; //0 - none, 1 - track, 2 - zone, 3 - actor
  SelId: Byte;
  LastSnapDelta: TPoint3d;

procedure OpenSceneMode(SLba, SGrid: Integer); overload;
Procedure OpenSceneMode(path: String); overload;
Procedure SceneToXY(x, y, z, pX, pY: Integer; var rX, rY: Integer);
Procedure SceneToGrid(x, y, z: Integer; var gX, gY, gZ: Integer);
Procedure DrawTrack(nr: Byte; x, y: Integer; Dest: TCanvas);
Procedure RedrawTrack(nr: Byte; SelClear: Boolean = False;
 UpdClip: Boolean = True);
Procedure SetTrack(nr: Byte; x, y, z: SmallInt; Caption: ShortString);
Procedure DrawActor(nr: Byte; x, y: Integer; Dest: TCanvas);
Procedure RedrawActor(nr: Byte; SelClear: Boolean = False;
 UpdClip: Boolean = True);
Procedure SetActor(nr: Byte; x, y, z: SmallInt; Caption: ShortString;
 SpriteIndex: Integer; cX1, cY1, cX2, cY2: SmallInt);
Procedure DeleteActor(nr: Byte);
Procedure DrawZone(nr: Byte; x, y: Integer; Dest: TCanvas; Front: Boolean);
Procedure DrawSelection;
Function PositionInside(X, Y: Integer; ObjType, ObjId: Integer): Boolean;
Function GetObjectAtCursor(X, Y: Integer; FindTracks, FindActors, FindZones: Boolean;
 out ObjType: Byte): Byte;
Procedure MoveObject(ObjType, ObjId: Byte; dx, dy: Integer; Vertical: Boolean);
Procedure SelectObject(ObjType, ObjId: Byte);
Function SendBackCommand(Command: Integer; Id: Byte; x1, y1, z1, x2, y2, z2: SmallInt): Boolean;
Procedure SceneMessage(var Msg: TWMCopyData);

implementation

uses Main, OpenSim, Sett, ProgBar, Open, BEngine, Grids, Scenario;

function LoadSpriteActorsInfo(data: String): Boolean;
var a: Integer;
begin
 Result:= Length(data) = Length(Sprites) * 16;
 If Result then begin
  SetLength(SprActInfo,Length(Sprites) + 1);
  SprActInfo[0].OffsetX:= 0; SprActInfo[0].OffsetY:= 0;
  SprActInfo[0].MinX:= 0; SprActInfo[0].MaxX:= 0; SprActInfo[0].MinY:= 0;
  SprActInfo[0].MaxY:= 0; SprActInfo[0].MinZ:= 0; SprActInfo[0].MaxZ:= 0;
  for a:= 0 to High(SprActInfo) - 1 do begin
   SprActInfo[a+1].OffsetX:= ReadStrSmallInt(data,a*16 + 1);
   SprActInfo[a+1].OffsetY:= ReadStrSmallInt(data,a*16 + 3);
   SprActInfo[a+1].MinX:= ReadStrSmallInt(data,a*16 + 5);
   SprActInfo[a+1].MaxX:= ReadStrSmallInt(data,a*16 + 7);
   SprActInfo[a+1].MinY:= ReadStrSmallInt(data,a*16 + 9);
   SprActInfo[a+1].MaxY:= ReadStrSmallInt(data,a*16 + 11);
   SprActInfo[a+1].MinZ:= ReadStrSmallInt(data,a*16 + 13);
   SprActInfo[a+1].MaxZ:= ReadStrSmallInt(data,a*16 + 15);
  end;
 end;
end;

procedure OpenSceneInitialize;
var a, b, c: Integer;
begin
 {for c:=0 to 63 do
  for b:=0 to 24 do
   for a:=0 to 63 do
    SetLength(BreakMap[a,b,c], 0); }

 SceneClipL:= -102; //expand grid repaint area to keep elements visible
 SceneClipR:= 151;  // even if they're partially off the screen
 SceneMode:= True;
end;

procedure OpenSceneFinalize(SLba: Integer);
var FStr1, FStr2: TFileStream;
    RessTemp: TPackEntries;
begin
 ProgBarForm.ShowSpecial('Loading files...',Form1,True);

 //Check if sprites are available
 SceneUseSprites:= True;
 If (SLba = 1) and FileExists(SetForm.peSprites1.Path)
               and FileExists(SetForm.peRess1.Path) then begin
  FStr1:= TFileStream.Create(SetForm.peSprites1.Path,fmOpenRead,fmShareDenyWrite);
  FStr2:= TFileStream.Create(SetForm.peRess1.Path,fmOpenRead,fmShareDenyWrite);
 end
 else if (SLba = 2) and FileExists(SetForm.peSprites2.Path)
                    and FileExists(SetForm.peRess2.Path) then begin
  FStr1:= TFileStream.Create(SetForm.peSprites2.Path,fmOpenRead,fmShareDenyWrite);
  FStr2:= TFileStream.Create(SetForm.peRess2.Path,fmOpenRead,fmShareDenyWrite);
 end
 else SceneUseSprites:= False;

 If SceneUseSprites then begin
  Sprites:= OpenPack(FStr1);
  UnpackAll(Sprites);
  FStr1.Free;
  RessTemp:= OpenPack(FStr2);
  SceneUseSprites:= LoadSpriteActorsInfo(UnpackToString(RessTemp[IfThen(SLba=1,3,5)]));
  FStr2.Free;
 end;

 OpenFinalize;

 Form1.pcControls.ActivePage:= Form1.tsScene;
 Form1.Splitter1.Visible:= False;
 Form1.paLayout.Visible:= False;
 Form1.aNew.Enabled:= False;
 Form1.aOpenSim.Enabled:= False;
 Form1.aOpen.Enabled:= False;
 Form1.aSave.Enabled:= False;
 Form1.aSaveAs.Enabled:= False;
 Form1.aOpenScen.Enabled:= False;
 Form1.Caption:= 'Little Grid Builder - Scene Mode';
 Form1.FormResize(Form1);
end;

procedure OpenSceneMode(SLba, SGrid: Integer); overload;
var TempLba1: Boolean;
    TempIndex, a: Integer;
begin
 EnableControls(False);

 SimpleForm.FormShow(Form1);
 While ((SLba = 1) and not SimpleForm.rb21.Enabled) or
       ((SLba = 2) and not SimpleForm.rb22.Enabled) do begin
  If MessageBox(Form1.Handle,PChar(Format('Not all files necessary to open LBA %d Grids have been specified. Displaying the Grid will not be possible until you configure the necessary paths.'#13'Click OK to go to settings.'#13'Click Cancel to run in normal mode.',[SLba])),ProgramName,MB_ICONINFORMATION+MB_OKCANCEL)
   =ID_CANCEL then Exit;
  SetForm.PageControl1.ActivePage:=SetForm.TabSheet2;
  SetForm.ShowModal;
  SimpleForm.FormShow(Form1);
 end;

 OpenSceneInitialize;

 TempLba1:= SimpleForm.rb21.Checked;
 TempIndex:= SimpleForm.grSimCombo.ItemIndex;
 If SLba = 1 then SimpleForm.rb21.Checked:= True else SimpleForm.rb22.Checked:= True;
 SimpleForm.rb21Click(Form1);
 If SLba = 1 then begin
  for a:= 0 to High(GridList1) do
   If GridList1[a] = SGrid - 1 then begin  //TODO: Return error if there is no such index
    SimpleForm.grSimCombo.ItemIndex:= a;
    Break;
   end;
 end
 else
  SimpleForm.grSimCombo.ItemIndex:= SGrid - 1;
 Screen.Cursor:= crHourGlass;

 OpenSimpleFiles;
 DataToMap;

 OpenSceneFinalize(SLba);
end;

Procedure OpenSceneMode(path: String); overload;
begin
 //EnableControls(False);
 OpenSceneInitialize;
 If OpenScenario(path) then OpenSceneFinalize(IfThen(HQSInfo.Lba2,2,1));
end;

//snapping to Bricks is introduced here
Procedure SceneMoveBy(x, y, z, dx, dy: Integer; Vertical: Boolean; out nX, nY, nZ: Integer);
var tempDelta: TPoint3d;
begin
 If Vertical then begin
  nX:= x;
  nY:= SRound(y - dy*(256/15));
  nZ:= z;
  tempDelta.y:= (LastSnapDelta.y + nY) mod 256;
  If SetForm.cbSceneSnap.Checked then
   nY:= SRound((nY + LastSnapDelta.y - 128) / 256) * 256;
 end
 else begin
  nX:= SRound(x + dx*(512/48) + dy*(512/24));
  nY:= y;
  nZ:= SRound(z - dx*(512/48) + dy*(512/24));
  tempDelta.x:= (LastSnapDelta.x + nX) mod 256;
  tempDelta.z:= (LastSnapDelta.z + nZ) mod 256;
  If SetForm.cbSceneSnap.Checked then begin
   nX:= SRound((nX + LastSnapDelta.x - 128) / 256) * 256;
   nZ:= SRound((nZ + LastSnapDelta.z - 128) / 256) * 256;
  end;
 end;
 LastSnapDelta:= tempDelta;
 If nX < -256 then nX:= -256 else if nX > 32767 then nX:= 32767;
 If nY < 0 then nY:= 0 else if nY > 6400 then nY:= 6400;
 If nZ < -256 then nZ:= -256 else if nZ > 32767 then nZ:= 32767;
end;

{
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

Procedure SetObjectOnList(typ, nr: Byte; pos: Integer; Delete: Boolean);
var a, b: Integer;
begin
 If Length(ObjectList) > 0 then
  for a:= 0 to High(ObjectList) do
   If (ObjectList[a].typ = typ) and (ObjectList[a].id = nr) then begin
    for b:= a to High(ObjectList) - 1 do
     ObjectList[b]:= ObjectList[b + 1];
    Break;
   end;

 If Delete then begin
  If Length(ObjectList) > 0 then SetLength(ObjectList,Length(ObjectList) - 1);
 end
 else begin
  If Length(ObjectList) > 0 then begin
   for a:= 0 to High(ObjectList) do
    //If (AA.x + SprActInfo[AA.SpriteIndex].MaxX + AA.z + SprActInfo[AA.SpriteIndex].MaxZ)
    //<= (Actors[ActorList[a]].x + SprActInfo[Actors[ActorList[a]].SpriteIndex].MaxX
    //  + Actors[ActorList[a]].z + SprActInfo[Actors[ActorList[a]].SpriteIndex].MaxZ)
    If (pos <= ObjectList[a].position) then begin
     b:= a;
     Break;
    end;
   If a > High(ObjectList) then b:= Length(Objectlist);
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

Procedure DrawTrack(nr: Byte; x, y: Integer; Dest: TCanvas);
var TT: TSceneTrack;
begin
 TT:= Tracks[nr];
 Dest.Brush.Style:= bsClear;
 Dest.Font.Color:= $B787FF;
 Dest.BrushCopy(Bounds(TT.rX+x-22,TT.rY+y-37,24,37),Form1.imgFlag.Picture.Bitmap,Bounds(0,0,24,37),clWhite);
 Dest.TextOut(TT.rX+x-(Dest.TextWidth(TT.Caption) div 2),TT.rY+y-64,TT.Caption);
end;

Procedure RedrawTrack(nr: Byte; SelClear: Boolean = False;
 UpdClip: Boolean = True);
var Wid: Integer;
begin
 If nr < Length(Tracks) then begin
  Wid:= Max(bufMain.Canvas.TextWidth(Tracks[nr].Caption) div 2,24) * 2;
  If SelClear or not Tracks[nr].Enabled then
   DrawPiece(Tracks[nr].rX+Off_X-(Wid div 2),Tracks[nr].rY+Off_Y-64,Wid,64,
    dmNormal,False,True,False)
  else if Tracks[nr].Enabled then begin
   DrawTrack(nr,Off_X-Form1.HScr.Position,Off_Y-Form1.VScr.Position,bufMain.Canvas);
   DrawPiece(Tracks[nr].rX+Off_X-(Wid div 2),Tracks[nr].rY+Off_Y-64,Wid,64,
    dmNormal,False,False,UpdClip,UpdClip,Tracks[nr].gX,Tracks[nr].gY,Tracks[nr].gZ);
  end;
 end;
end;

Procedure DeleteTrack(nr: Byte);
begin
 If High(Tracks) < nr then Exit;
 Tracks[nr].Enabled:= False;
 SetObjectOnList(1,nr,0,True);
 //DelBreakMapItem(Tracks[nr].gX, Tracks[nr].gY, Tracks[nr].gZ, 1, nr);
 RedrawTrack(nr,True);
end;

Procedure SetTrack(nr: Byte; x, y, z: SmallInt; Caption: ShortString);
begin
 If High(Tracks) < nr then SetLength(Tracks,nr+1);
 If Tracks[nr].Enabled then DeleteTrack(nr);
 Tracks[nr].x:= x;
 Tracks[nr].y:= y;
 Tracks[nr].z:= z;
 SetObjectOnList(1,nr,x+z,False);
 SceneToXY(x,y,z,0,0,Tracks[nr].rX,Tracks[nr].rY);
 SceneToGrid(x,y,z,Tracks[nr].gX,Tracks[nr].gY,Tracks[nr].gZ);
 //AddBreakMapItem(Tracks[nr].gX, Tracks[nr].gY, Tracks[nr].gZ, 1, nr);
 Tracks[nr].Caption:= Caption;
 Tracks[nr].Enabled:= True;
 If not SceneUpdateStarted then RedrawTrack(nr);
end;

Procedure DrawZone(nr: Byte; x, y: Integer; Dest: TCanvas; Front: Boolean);
var x1, y1, x2, y2, xp1, yp1, xp2, yp2: Integer;
    ZZ: TSceneZone;
begin
 ZZ:= Zones[nr];
 If (ZZ.ZoneType > 6) or not (ZoneEnabledTypes[ZZ.ZoneType] and ZZ.Enabled) then Exit;
 Dest.Pen.Color:= clScZone[ZZ.ZoneType];
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
 Dest.Font.Color:= clScZone[ZZ.ZoneType];
 Dest.TextOut(x1,y1-ZZ.h,ZZ.Caption);
end;

Procedure DeleteZone(nr: Byte);
var Wid: Integer;
begin
 If High(Zones)<nr then Exit;
 Zones[nr].Enabled:= False;
 //DelBreakMapItem(Zones[nr].gX1, Zones[nr].gY1, Zones[nr].gZ1, 2, nr);
 Wid:= Max(Zones[nr].sX1 - Zones[nr].rX2 + bufMain.Canvas.TextWidth(Zones[nr].Caption) + 24,
  Zones[nr].sX1 - Zones[nr].sX2);
 DrawPiece(Zones[nr].sX2 + Off_X - 1, Zones[nr].rY1 + Off_Y - Zones[nr].h - 1, Wid + 2,
  Zones[nr].rY2 - Zones[nr].rY1 + 2*Zones[nr].h + 2, dmNormal, False);
end;

Procedure SetZone(nr: Byte; x1, y1, z1, x2, y2, z2: SmallInt; ZType: Byte; Caption: PChar);
var Wid: Integer;
begin
 If High(Zones)<nr then SetLength(Zones,nr+1);
 If Zones[nr].Enabled then DeleteZone(nr);
 Zones[nr].x1:= Min(x1,x2);
 Zones[nr].y1:= Min(y1,y2);
 Zones[nr].z1:= Min(z1,z2);
 Zones[nr].x2:= Max(x1,x2);
 Zones[nr].y2:= Max(y1,y2);
 Zones[nr].z2:= Max(z1,z2);
 SceneToXY(x1,y1,z1,0,0,Zones[nr].rX1,Zones[nr].rY1);
 SceneToXY(x2,y2,z2,0,0,Zones[nr].rX2,Zones[nr].rY2);
 Zones[nr].h:= ((y2-y1) * 15) div 256;
 SceneToGrid(x1,y1,z1,Zones[nr].gX1,Zones[nr].gY1,Zones[nr].gZ1);
 SceneToGrid(x2,y2,z2,Zones[nr].gX2,Zones[nr].gY2,Zones[nr].gZ2);
 Zones[nr].sX1:= Zones[nr].rY2+Zones[nr].h - Zones[nr].rY1 + ((Zones[nr].rX2+Zones[nr].rX1) div 2);
 Zones[nr].sY1:= (Zones[nr].rY1+Zones[nr].rY2+Zones[nr].h - ((Zones[nr].rX1-Zones[nr].rX2) div 2)) div 2;
 Zones[nr].sX2:= Zones[nr].rY1-Zones[nr].h + ((Zones[nr].rX2+Zones[nr].rX1) div 2) - Zones[nr].rY2;
 Zones[nr].sY2:= (Zones[nr].rY1+Zones[nr].rY2+Zones[nr].h + ((Zones[nr].rX1-Zones[nr].rX2) div 2)) div 2;
 //AddBreakMapItem(Zones[nr].gX1, Zones[nr].gY1, Zones[nr].gZ1, 2, nr);
 Zones[nr].ZoneType:= ZType;
 Zones[nr].Caption:= Caption;
 Zones[nr].Enabled:= True;
 //Wid:= Max(bufMain.Canvas.TextWidth(Zones[nr].Caption),24);
 //DrawPiece(Zones[nr].rX1+Off_X-(Wid div 2),Tracks[nr].rY+Off_Y-62,Wid,62,dmNormal,False);
 If not SceneUpdateStarted then begin
  //DrawMapA;
  DrawZone(nr,Off_X-Form1.HScr.Position,Off_Y-Form1.VScr.Position,bufMain.Canvas,True);
  UpdateImage(bufMain,Form1.pbGrid);
 end;
end;

Procedure DrawActor(nr: Byte; x, y: Integer; Dest: TCanvas);
var AA: TSceneActor;
    x1, y1: Integer;
begin
 AA:= Actors[nr];
 If not AA.Enabled then Exit;
 x1:= AA.rX + x;
 y1:= AA.rY + y;
 Dest.Brush.Style:= bsClear;
 If AA.SpriteIndex = 0 then begin  //normal actor
  //Dest.Brush.Style:= bsClear;
  //Dest.BrushCopy(Bounds(x1,y1,35,86),Form1.imgActor.Picture.Bitmap,Bounds(0,0,35,86),clWhite);
  Dest.Draw(x1,y1,Form1.imgActor.Picture.Bitmap);
 end
 else begin  //sprite actor
  Dest.Draw(x1,y1,AA.Sprite);
  //Dest.Pen.Style:= psSolid;
  //PaintBrickFromString(Sprites[AA.SpriteIndex-1].Data, Point(x1,y1), Palette, Dest,
  // False, True, clWhite, True);
 end;
 If DisplayActorClipping and AA.UsesClipping then begin
  Dest.Pen.Color:= clAqua;
  Dest.Pen.Style:= psDot;
  Dest.Rectangle(AA.cX1+x+24, AA.cY1+y+24, AA.cX2+x+24, AA.cY2+y+24);
 end;
 Dest.Font.Color:= clAqua;
 Dest.TextOut(x1+(AA.Width div 2)-(Dest.TextWidth(AA.Caption) div 2),y1-30,AA.Caption);
end;

Procedure RedrawActor(nr: Byte; SelClear: Boolean = False;
 UpdClip: Boolean = True);
var Wid: Integer;
begin
 If nr < Length(Actors) then begin
  Wid:= Max(bufMain.Canvas.TextWidth(Actors[nr].Caption),Actors[nr].Width);
  If SelClear or not Actors[nr].Enabled then
   DrawPiece(Actors[nr].rX+Off_X,Actors[nr].rY+Off_Y-30,Wid,
    Actors[nr].Height+30,dmNormal,False,True,False)
  else if Actors[nr].Enabled then begin
   DrawActor(nr,Off_X-Form1.HScr.Position,Off_Y-Form1.VScr.Position,bufMain.Canvas);
   DrawPiece(Actors[nr].rX+Off_X,Actors[nr].rY+Off_Y-30,Wid,
    Actors[nr].Height+30,dmNormal,False,False,UpdClip,UpdClip,
    Actors[nr].gX,Actors[nr].gY,Actors[nr].gZ);
  end;
 end;
end;

Procedure DeleteActor(nr: Byte);
begin
 If High(Actors) < nr then Exit;
 Actors[nr].Enabled:= False;
 SetObjectOnList(3,nr,0,True);
 If Assigned(Actors[nr].Sprite) then Actors[nr].Sprite.Free;
 //DelBreakMapItem(Actors[nr].gX, Actors[nr].gY, Actors[nr].gZ, 3, nr);
 RedrawActor(nr,True);
end;

Procedure SetActor(nr: Byte; x, y, z: SmallInt; Caption: ShortString;
 SpriteIndex: Integer; cX1, cY1, cX2, cY2: SmallInt);
begin
 If High(Actors) < nr then SetLength(Actors,nr+1);
 If Actors[nr].Enabled then DeleteActor(nr);
 Actors[nr].x:= x;
 Actors[nr].y:= y;
 Actors[nr].z:= z;
 SetObjectOnList(3,nr,x+z,False);
 Actors[nr].cX1:= cX1;
 Actors[nr].cY1:= cY1;
 Actors[nr].cX2:= cX2;
 Actors[nr].cY2:= cY2;
 Actors[nr].UsesClipping:= (cX1<>0) or (cY1<>0) or (cX2<>0) or (cY2<>0);
 SceneToXY(x,y,z,0,0,Actors[nr].rX,Actors[nr].rY);
 SceneToGrid(x,y,z,Actors[nr].gX,Actors[nr].gY,Actors[nr].gZ);
 //AddBreakMapItem(Actors[nr].gX, Actors[nr].gY, Actors[nr].gZ, 3, nr);
 Actors[nr].Caption:= Caption;
 Actors[nr].SpriteIndex:= 0;
 Actors[nr].Width:= 35;
 Actors[nr].Height:= 86;
 If SceneUseSprites and (SpriteIndex > 0) then begin
  If SpriteIndex < Length(Sprites) then begin
   Actors[nr].SpriteIndex:= SpriteIndex;
   Actors[nr].Width:= Byte(Sprites[SpriteIndex-1].Data[9]);
   Actors[nr].Height:= Byte(Sprites[SpriteIndex-1].Data[10]);
   Inc(Actors[nr].rX, SprActInfo[Actors[nr].SpriteIndex].OffsetX - 2);
   Inc(Actors[nr].rY, SprActInfo[Actors[nr].SpriteIndex].OffsetY);
   Actors[nr].Sprite:= TBitmap.Create;
   Actors[nr].Sprite.PixelFormat:= pf24bit;
   Actors[nr].Sprite.Transparent:= True;
   Actors[nr].Sprite.TransparentMode:= tmFixed;
   Actors[nr].Sprite.TransparentColor:= 0;
   Actors[nr].Sprite.Width:= Actors[nr].Width;
   Actors[nr].Sprite.Height:= Actors[nr].Height;
   Actors[nr].Sprite.Canvas.Brush.Color:= 0;
   Actors[nr].Sprite.Canvas.FillRect(Rect(0,0,Actors[nr].Width,Actors[nr].Height));
   PaintBrickFromString(Sprites[SpriteIndex-1].Data, Point(0,0), Palette,
    Actors[nr].Sprite.Canvas, False, False, clWhite, True);
  end
  else
   MessageBox(Form1.Handle,PChar(Format('Sprite index out of range!'#13#13'Sprite index: %d'#13'Actor ID: %d',[SpriteIndex,nr])),'Little Grid Builder',MB_ICONERROR+MB_OK);
 end
 else begin
  Dec(Actors[nr].rX,17);
  Dec(Actors[nr].rY,86);
 end;

 Actors[nr].Enabled:= True;
 If not SceneUpdateStarted then
  RedrawActor(nr);
end;

Procedure DrawSelection;
var x, y: Integer;
begin
 x:= Off_X - Form1.HScr.Position;
 y:= Off_Y - Form1.VScr.Position;
 bufMain.Canvas.Pen.Style:= psDot;
 bufMain.Canvas.Pen.Color:= clWhite;
 bufMain.Canvas.Brush.Style:= bsClear;
 bufMain.Canvas.Font.Color:= clWhite;
 case SelType of
  1: If SelId < Length(Tracks) then begin
      bufMain.Canvas.Rectangle(Bounds(Tracks[SelId].rX+x-24,
       Tracks[SelId].rY+y-39,26,39));
      bufMain.Canvas.TextOut(Tracks[SelId].rX+x
       -(bufMain.Canvas.TextWidth(Tracks[SelId].Caption) div 2),
       Tracks[SelId].rY+y-64,Tracks[SelId].Caption);
     end;
  3: If SelId < Length(Actors) then begin
      bufMain.Canvas.Rectangle(Bounds(Actors[SelId].rX+x,Actors[SelId].rY+y,
       Actors[SelId].Width,Actors[SelId].Height));
      bufMain.Canvas.TextOut(x+Actors[SelId].rX +(Actors[SelId].Width div 2)
       -(bufMain.Canvas.TextWidth(Actors[SelId].Caption) div 2),
       y+Actors[SelId].rY-30,Actors[SelId].Caption);
     end;
 end;
end;

Procedure SceneToXY(x, y, z, pX, pY: Integer; var rX, rY: Integer);
begin
 If Grid.Lba2 then Dec(pY,15);
 rX:= Trunc((x-z)*(24/512)) + pX + 24; //Off_X-Form1.HScr.Position+24;
 rY:= Trunc((x+z)*(12/512)-(y*(15/256)-15))+pY+12;//Off_Y-Form1.VScr.Position;
end;

Procedure SceneToGrid(x, y, z: Integer; var gX, gY, gZ: Integer);
begin
 gX:= SRound(x/512); //asymmetric arithmetic rounding
 If gX > HighX then gX:= HighX else if gX < 0 then gX:= 0;
 gY:= SRound(y/256);
 If gY > HighY then gY:= HighY else if gY < 0 then gY:= 0;
 gZ:= SRound(z/512);
 If gZ > HighZ then gZ:= HighZ else if gZ < 0 then gZ:= 0;
end;

Procedure DeleteAll(DTracks, DZones, DActors: Boolean; Redraw: Boolean = True);
var a, b, c: Integer;
begin
 If DTracks then
  for a:= 0 to High(Tracks) do
   SetObjectOnList(1, a, 0, True);
 If DActors then
  for a:= 0 to High(Actors) do
   SetObjectOnList(3, a, 0, True);
 If DTracks then SetLength(Tracks,0);
 If DZones then SetLength(Zones,0);
 If DActors then SetLength(Actors,0);
 //SetLength(ObjectList,0);
 If Redraw then DrawMapA;
end;

Function PositionInside(X, Y: Integer; ObjType, ObjId: Integer): Boolean;
begin
 Result:= False;
 case ObjType of
  1: Result:= Tracks[ObjId].Enabled
      and (X >= Tracks[ObjId].rX - 24) and (X < Tracks[ObjId].rX)
      and (Y >= Tracks[ObjId].rY - 37) and (Y < Tracks[ObjId].rY);
  3: Result:= Actors[ObjId].Enabled
      and (X >= Actors[ObjId].rX) and (X <= Actors[ObjId].rX + Actors[ObjId].Width)
      and (Y >= Actors[ObjId].rY) and (Y <= Actors[ObjId].rY + Actors[ObjId].Height);
 end;
end;

Function GetObjectAtCursor(X, Y: Integer; FindTracks, FindActors, FindZones: Boolean;
 out ObjType: Byte): Byte;
var a, rX, rY: Integer;
begin
 rX:= X - Off_X + ScrollX;
 rY:= Y - Off_Y + ScrollY;
 ObjType:= 0;
 If FindTracks then
  for a:= 0 to High(Tracks) do
   If (Tracks[a].gY <= MaxLayer) and PositionInside(rX,rY,1,a) then begin
    ObjType:= 1;
    Result:= a;
    Break;
   end;
 If FindActors then
  for a:= 0 to High(Actors) do
   If (Actors[a].gY <= MaxLayer) and PositionInside(rX,rY,3,a) then begin
    ObjType:= 3;
    Result:= a;
    Break;
   end;
end;

Procedure MoveObject(ObjType, ObjId: Byte; dx, dy: Integer; Vertical: Boolean);
var NewSX, NewSY, NewSZ: Integer;
begin
 case ObjType of
  1: begin
      SceneMoveBy(Tracks[ObjId].x,Tracks[ObjId].y,Tracks[ObjId].z,dx,dy,Vertical,NewSX,NewSY,NewSZ);
      If (NewSX <> Tracks[ObjId].x) or (NewSY <> Tracks[ObjId].y)
      or (NewSZ <> Tracks[ObjId].z) then
       If SendBackCommand(10,ObjId,NewSX,NewSY,NewSZ,0,0,0) then
        SetTrack(ObjId,NewSX,NewSY,NewSZ,Tracks[ObjId].Caption);
     end;
  3: begin
      SceneMoveBy(Actors[ObjId].x,Actors[ObjId].y,Actors[ObjId].z,dx,dy,Vertical,NewSX,NewSY,NewSZ);
      If (NewSX <> Actors[ObjId].x) or (NewSY <> Actors[ObjId].y)
      or (NewSZ <> Actors[ObjId].z) then
       If SendBackCommand(30,ObjId,NewSX,NewSY,NewSZ,0,0,0) then
        SetActor(ObjId,NewSX,NewSY,NewSZ,Actors[ObjId].Caption,Actors[ObjId].SpriteIndex,
         Actors[ObjId].cX1,Actors[ObjId].cY1,Actors[ObjId].cX2,Actors[ObjId].cY2);
     end;
 end;
end;

Procedure SelectObject(ObjType, ObjId: Byte);
var TempType: byte;
    x, y: Integer;
begin
 If (ObjType = SelType) and (ObjId = SelId) then Exit;
 x:= - Off_X + ScrollX;
 y:= - Off_Y + ScrollY;
 TempType:= SelType;
 SelType:= 0;
 case TempType of
  1: RedrawTrack(SelId, True);
  3: RedrawActor(SelId, True);
 end;
 If ObjType > 0 then begin
  SelType:= ObjType;
  SelId:= ObjId;
  {case SelType of
   1: RedrawTrack(SelId);
   3: RedrawActor(SelId, True);
  end;}
  DrawSelection;
  UpdateImage(bufMain,Form1.pbGrid);
  SendBackCommand(SelType*10+1,ObjId,0,0,0,0,0,0);
 end; 
end;

Procedure EnableBackwardComm(bch: HWND);
begin
 BackCommHandle:= bch;
 BackCommEnabled:= SendBackCommand(01,0,0,0,0,0,0,0);
 Form1.btScEdit.Enabled:= BackCommEnabled;
 Form1.btScAddTrack.Enabled:= BackCommEnabled;
 Form1.btScAddActor.Enabled:= BackCommEnabled;
 Form1.lbEditingEnabled.Visible:= BackCommEnabled;
end;

Function SendBackCommand(Command: Integer; Id: Byte; x1, y1, z1, x2, y2, z2: SmallInt): Boolean;
var temp: TCopyDataStruct;
    a: Integer;
begin
 BackCommand.Id:= Id;
 BackCommand.x1:= x1;
 BackCommand.y1:= y1;
 BackCommand.z1:= z1;
 BackCommand.x2:= x2;
 BackCommand.y2:= y2;
 BackCommand.z2:= z2;
 temp.dwData:= Command;
 temp.cbData:= SizeOf(TBackCommand);
 temp.lpData:= @BackCommand;
 Result:= False;
 a:= SendMessage(BackCommHandle,WM_COPYDATA,0,Integer(@temp));
 If (a <> 100) and (a <> 1000) then ProgBarForm.CloseSpecial;
 case a of
  0: MessageBox(Form1.Handle,'Backward communication error: unknown error!','Little Grid Builder',MB_ICONERROR+MB_OK);
  1: MessageBox(Form1.Handle,'Backward communication error: invalid object id!','Little Grid Builder',MB_ICONERROR+MB_OK);
  10: MessageBox(Form1.Handle,'Backward communication error: invalid command!','Little Grid Builder',MB_ICONERROR+MB_OK);
  100: Result:= True;
  1000: If Command = 01 then Result:= True;
  else MessageBox(Form1.Handle,'Backward communication error: unknown answer!','Little Grid Builder',MB_ICONERROR+MB_OK);
 end;
end;

Procedure SceneMessage(var Msg: TWMCopyData);
var temp: TCopyDataStruct;
    data: TComData;
    TempPath: String;
begin
 Msg.Result:= 999;
 temp:= TCopyDataStruct(Msg.CopyDataStruct^);
 try
  data:= TComData(temp.lpData^);
  case temp.dwData of
   01: Msg.Result:= 1000;
   02: If ((data.Id<>1) and (data.Id<>2)) or (data.Data<=0) then Msg.Result:=4
       else begin
        DeleteAll(True,True,True,False);
        OpenSceneMode(data.Id,data.Data);
       end;
   03: Form1.Close;
   04: EnableBackwardComm(data.Data);
   08: begin
        SceneUpdateStarted:= True;
        ProgBarForm.ShowSpecial('Receiving scene data...',Form1,True);
       end;
   09: begin
        SceneUpdateStarted:= False;
        ProgBarForm.CloseSpecial;
        DrawMapA;
       end;

   11: SetTrack(data.Id,data.x1,data.y1,data.z1,data.Text);
   12: DeleteTrack(data.Id);
   13: DeleteAll(True,False,False);
   14: SelectObject(1, data.Id);

   21: SetZone(data.Id,data.x1,data.y1,data.z1,data.x2,data.y2,data.z2,data.Data,data.Text);
   22: DeleteZone(data.Id);
   23: DeleteAll(False,True,False);
   24: SelectObject(2, data.Id);

   31: SetActor(data.Id, data.x1, data.y1, data.z1, data.Text, data.Data,
        data.cx1, data.cy1, data.cx2, data.cy2);
   32: DeleteActor(data.Id);
   33: DeleteAll(False, False, True);
   34: SelectObject(3, data.Id);

   101: begin
         SaveScenario(IncludeTrailingPathDelimiter(GetEnvironmentVariable('TEMP'))
          + 'TemporaryScenario7865.hqs');
        end;
   else Msg.Result:= 2;
  end;
 except
  Msg.Result:= 3;
 end;
end;

end.
