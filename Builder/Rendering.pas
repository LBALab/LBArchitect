//******************************************************************************
// Little Big Architect: Builder - editing grid files containing rooms in
//                                 Little Big Adventure 1 & 2
//
// BEngine unit.
// Contains routines used for displaying and editing rooms.
//
// Copyright Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit Rendering;

interface

uses DePack, Engine, Grids, Libraries, Classes, ProgBar, SysUtils, Windows,
     ExtCtrls, Graphics, Controls, Math, Bricks, SceneLib, SceneLibConst, Forms,
     Maps;

type
 {TBreakMapItem = record
   Tp, Id: Integer;
 end;}

 //TBitBrick = array[0..47,0..37] of TColor; //0 = transparent

 //TSelArray = array of array of array of Boolean;

 TDrawMode = (dmNormal, dmRemember, dmMerge);

 TSelMode2 = (smNormal, smInvisi, smNormInv);

const
 Lba1Invisible: TMapItem = (Idx: (Lt: 0; Brk: 1); BrkNr: 0; Frame: [foSelect]);
 ThumbSizeX = 152;
 ThumbSizeX2 = 304;
 ThumbSizeY = 96;
 ThumbSizeY2 = 192;

var
 //bitBuffers: array of TBitBrick;
 BuffMap: array of SmallInt; {16 bit signed}
 //BreakMap: array[0..63,0..24,0..63] of array of TBreakMapItem; //used in Scene only - always full size
 FneCoords: array[0..2] of Integer;
 FneDone: Boolean;
 LayoutMap: array of Integer;
 Lba2Invisible: TMapItem;
 LtSel: Integer = 1;
 GPlacePos: TPoint3d = (x: -1000; y: -1000; z: -1000);
 PlaceObj: TMapPiece;
 BufObj: TMapPiece;
 FrDrawRgn: TRect;

 ThumbCounter: Integer = 0;

procedure DrawNet(X, Y: Integer);
procedure UpdateClip(Src: TBitmap; Dest: TPaintBox);
procedure DrawMap(x, y: Integer; Dest: TCanvas; ClearBkg: Boolean = True;
 StartX: Integer = 0; StartY: Integer = 0; StartZ: Integer = 0);
procedure DrawMapA(dx: Integer = 0; dy: Integer = 0);
procedure DrawPiece(x, y, width, height: Integer; DrawMode: TDrawMode = dmNormal;
 ThumbRepnt: Boolean = True; DrawObjs: Boolean = True; DrawSel: Boolean = True;
 UpdClip: Boolean = True; ClearBkg: Boolean = True;
 StartX: Integer = 0; StartY: Integer = 0; StartZ: Integer = 0);
procedure DrawPieceBrk(x, y, z, dx, dy, dz: Integer; Mode: TDrawMode = dmNormal;
 Helper: Boolean = False; ThumbRepaint: Boolean = True);
procedure ScrollMap(dx, dy: Integer);
Procedure BufferBricks(Lib: TLibrary; Brk: TPackEntries);
procedure CreateThumbnail(Draft: Boolean; x1: Integer = 0; y1: Integer = 0;
  x2: Integer = ThumbSizeX - 1; y2: Integer = ThumbSizeY - 1);
procedure UpdateThumbnail(x1, y1, z1, x2, y2, z2: Integer);
procedure UpdateThumbBack(FirstDraft: Boolean);
Function FindLayout(Map: TComplexMap; x, y, z: Integer): TBox;
procedure GetBrick(X, Y, L: Integer; var gX, gZ: Integer);
Function PixelOfScreenVal(X, Y: Integer; Full: Boolean; Mode: TSelMode2): Byte;
Function PixelOfScreen(X, Y: Integer): TColor;
Function GetPCursor(mX, mY: Integer; PointOnly: Boolean): TBox;
Procedure MakeLayoutMap();
Procedure PaintLayout(x, y, Nr: Integer; dest: TCanvas);
procedure PaintLayouts();
Procedure InvPlacingEnd();
//Procedure DrawFlag(x, y, z: Word);

implementation

uses Main, Open, OpenSim, Settings, Clipping, Scene, Globals;

var
 Coords: array[0..2,0..3] of Integer;
 CoIndex, CoLayer: Integer;

procedure UpdateClip(Src: TBitmap; Dest: TPaintBox);
begin
 //Dest.Canvas.CopyRect(Src.Canvas.ClipRect,Src.Canvas,Src.Canvas.ClipRect);
 With Src.Canvas.ClipRect do
  BitBlt(Dest.Canvas.Handle, Left, Top, Right-Left, Bottom-Top,
          Src.Canvas.Handle, Left, Top, SRCCOPY);
end;

procedure DrawNet(X, Y: Integer);
var a: Integer;
begin
 bufMain.Canvas.Pen.Style:= psSolid;
 for a:= 0 to GHiX + 1 do begin
   bufMain.Canvas.MoveTo(a*24+X+24, a*12+Y+14-(GHiY+1)*15);
   bufMain.Canvas.LineTo(a*24+X+24, a*12+Y+14);
   bufMain.Canvas.LineTo(a*24+X+24-(GHiZ+1)*24, a*12+Y+14+(GHiZ+1)*12);
 end;
 for a:= 1 to GHiY + 1 do begin
   bufMain.Canvas.MoveTo((GHiX+1)*24+X+24, (GHiX+1)*12+Y+14-a*15);
   bufMain.Canvas.LineTo(X+24, Y+14-a*15);
   bufMain.Canvas.LineTo(-(GHiZ+1)*24+X+24, (GHiZ+1)*12+Y+14-a*15);
 end;
 for a:= 0 to GHiZ + 1 do begin
   bufMain.Canvas.MoveTo(-a*24+X+24, a*12+Y+14-(GHiY+1)*15);
   bufMain.Canvas.LineTo(-a*24+X+24, a*12+Y+14);
   bufMain.Canvas.LineTo(-a*24+X+24+(GHiX+1)*24, a*12+Y+14+(GHiX+1)*12);
 end;
end;

//this is the main drawing procedure
procedure DrawMap(x, y: Integer; Dest: TCanvas; ClearBkg: Boolean = True;
 StartX: Integer = 0; StartY: Integer = 0; StartZ: Integer = 0);
var a, b, c, pX, pY, bx, by, i: Integer;
    px1, py1, pz1, px2, py2, pz2, cx1, cy1, cx2, cy2: Integer;
    CurFrame, CurFrameA, SelFrame, MinFrames, MoveFrame, MoveCopyFrame, MvObject,
      HelpFrame, Help3D, NormFrame, NormFrameNew, Shapes, PArea, Inv, PlaceDown,
      SelBound: Boolean;
    GridMode: Boolean;
    mi: TMapItem;
    //Id: TBreakMapItem;
begin
 if not Assigned(CMap) then Exit;
 GridMode:= ProgMode = pmGrid;
 Dest.Pen.Width:= 1;
 If ClearBkg {(StartX = 0) and (StartY = 0) and (StartZ = 0)} then begin
   Dest.Brush.Style:= bsSolid;
   Dest.Brush.Color:= clBlack;
   Dest.FillRect(Dest.ClipRect);
 end;
 With fmMain do begin
   If Sett.Controls.Net
   and ClearBkg {(StartX = 0) and (StartY = 0) and (StartZ = 0)} then begin
     Dest.Pen.Color:= Sett.Frames.WinNetCol;
     DrawNet(x,y);
   end;

   cx1:= Dest.ClipRect.Left - 48;// + SceneClipL;
   cy1:= Dest.ClipRect.Top - 37;
   cx2:= Dest.ClipRect.Right - 1;// + SceneClipR;
   cy2:= Dest.ClipRect.Bottom - 1;// + SceneClipR;

   MvObject:= GridMode
              and ((GridTool = gtPlace) or GInvPlacing or GFVMoving or GFHMoving or GObjCopied);
   px1:= GPlacePos.x;
   py1:= GPlacePos.y;
   pz1:= GPlacePos.z;
   px2:= px1 + PlaceObj.x - 1;
   py2:= py1 + PlaceObj.y - 1;
   pz2:= pz1 + PlaceObj.z - 1;

   Inv:= ((ProgMode = pmScene) and Sett.Controls.Invisi)
      or (GridMode and (Sett.Controls.Invisi or (GridTool = gtInvisi)));
   MinFrames:= (GridTool in [gtSelect, gtInvisi]) and not (GFHMoving or GFVMoving);
   MoveFrame:= GridMode and (Sett.Controls.GPlacedFr or (GridTool = gtInvisi) or GInvPlacing)
               and (not GObjCopied or GFHMoving or GFVMoving);
   MoveCopyFrame:= GridMode and GObjCopied and GHasSelection and not (GFHMoving or GFVMoving);
   HelpFrame:= GridMode and Sett.Controls.GHelper and MvObject
               and (not GObjCopied or GFHMoving or GFVMoving);
   Help3D:= GridMode and HelpFrame and Sett.Controls.GHelp3D;
   NormFrame:= Sett.Controls.Frames and not Sett.Frames.NewStyle;
   NormFrameNew:= Sett.Controls.Frames and Sett.Frames.NewStyle;
   Shapes:= mViewShapes.Checked;
   CurFrameA:= GridMode and Sett.Controls.GCursor;
   PlaceDown:= GridMode and (GridTool = gtPlace);

   //pX:= x; pY:= y;
   //Inc(pX, (StartX - StartZ) * 24);
   //Inc(pY, (StartX + StartZ) * 12 - StartY * 15);
   for a:= StartX to GHiX do begin
     for b:= StartY to GHiY do begin
       for c:= StartZ to GHiZ do begin
         pX:= x + (a - c) * 24;
         pY:= y + (a + c) * 12 - b * 15;
         if (pX >= cx1) and (pY >= cy1) and (pX <= cx2) and (pY <= cy2) then begin
           PArea:= (a >= px1) and (a <= px2) and (c >= pz1) and (c <= pz2);
           if MvObject and PArea and (b >= py1) and (b <= py2)
           and (PlaceDown or (foSelect in PlaceObj.Map[a-px1,b-py1,c-pz1].Frame)) then begin
             mi:= PlaceObj.Map[a-px1, b-py1, c-pz1];
             If MoveCopyFrame then BackFrame(pX, pY, Dest, Sett.Frames.SelectCol);
             If MoveFrame then BackFrame(pX, pY, Dest, Sett.Frames.PlacedCol);
             If not GInvPlacing then begin
               {If BuffMap[mi.BrkNr]=-1 then} BufferBrick(mi.BrkNr);
               imgBrkBuff.Draw(Dest, pX, pY, BuffMap[mi.BrkNr]);
               //DrawBitBrick(bitBuffers[BuffMap[mi.BrkNr]],pX,pY,Dest);
             end;
             If MoveCopyFrame then FrontFrameC(pX, pY, Dest, Sett.Frames.SelectCol);
             If MoveFrame then FrontFrameC(pX, pY, Dest, Sett.Frames.PlacedCol);
           end
           else begin
             mi:= CMap^.M^[a, b, c];
             if b <= HiVisLayer then begin
               if (foNormal in mi.Frame) then begin
                 if NormFrame then BackFrame(pX, pY, Dest, Sett.Frames.MainImgCol)
                 else if NormFrameNew then
                   BackFrameLine(pX, pY, Dest, Sett.Frames.MainImgCol, mi.FrLines);
                 if Shapes then ShapeBFrame(pX, pY, Dest, Sett.Frames.ShapesCol, mi.Shape);
               end;
               if GHasSelection and MinFrames then begin //Selection bounds
                 if a = GSelect.x1 then begin
                   if b = GSelect.y1 then begin
                     if c = GSelect.z1 then
                       BackFrameLine(pX, pY, Dest, Sett.Frames.SelectCol, [flVertBack, flBtmLeftBack, flBtmRightBack])
                     else if (c > GSelect.z1) and (c <= GSelect.z2) then
                       BackFrameLine(pX, pY, Dest, Sett.Frames.SelectCol, [flBtmLeftBack]);
                   end else if (b > GSelect.y1) and (b <= GSelect.y2) then begin
                     if c = GSelect.z1 then
                       BackFrameLine(pX, pY, Dest, Sett.Frames.SelectCol, [flVertBack]);
                   end;
                 end else if (a > GSelect.x1) and (a <= GSelect.x2) then begin
                   if b = GSelect.y1 then begin
                     if c = GSelect.z1 then
                       BackFrameLine(pX, pY, Dest, Sett.Frames.SelectCol, [flBtmRightBack]);
                   end;
                 end;
               end;
               if (foSelect in mi.Frame) then begin
                 SelFrame:= GHasSelection and MinFrames
                            and not (GObjCopied or ((GridTool = gtInvisi) and (foNormal in mi.Frame)))
                            and (a >= GSelect.x1) and (b >= GSelect.y1) and (c >= GSelect.z1)
                            and (a <= GSelect.x2) and (b <= GSelect.y2) and (c <= GSelect.z2);
                 CurFrame:= CurFrameA and MinFrames and not SelFrame and not GMoveAllowed
                            and ((GridTool <> gtInvisi) or not (foNormal in mi.Frame))
                            and (a >= GCursor.x1) and (b >= GCursor.y1) and (c >= GCursor.z1)
                            and (a <= GCursor.x2) and (b <= GCursor.y2) and (c <= GCursor.z2);
                 if SelFrame then BackFrame(pX, pY, Canvas, Sett.Frames.SelectCol);
                 if CurFrame then BackFrame(pX, pY, Canvas, Sett.Frames.CursorCol);
               end;
               if (foNormal in mi.Frame) then begin
                 if mi.BrkNr <> TransparentBrick then begin
                  {If BuffMap[mi.BrkNr]=-1 then} BufferBrick(mi.BrkNr);
                  imgBrkBuff.Draw(Dest, pX, pY, BuffMap[mi.BrkNr]);
                  //DrawBitBrick(bitBuffers[BuffMap[mi.BrkNr]],pX,pY,Dest);
                 end;
                 if NormFrame then FrontFrame(pX, pY, Dest, Sett.Frames.MainImgCol)
                 else if NormFrameNew then
                   FrontFrameLine(pX, pY, Dest, Sett.Frames.MainImgCol, mi.FrLines);
                 if Shapes then ShapeFFrame(pX, pY, Dest, Sett.Frames.ShapesCol, mi.Shape);
               end;
               if GHasSelection and MinFrames then begin //Selection bounds
                 if a = GSelect.x1 then begin
                   if b = GSelect.y1 then begin
                     if c = GSelect.z2 then
                       FrontFrameLine(pX, pY, Dest, Sett.Frames.SelectCol, [flVertLeft, flBtmLeftFront], False);
                   end;
                   if b = GSelect.y2 then begin //No 'else', because it may be equal both to y1 and y2
                     if c = GSelect.z1 then
                       FrontFrameLine(pX, pY, Dest, Sett.Frames.SelectCol, [flTopRightBack, flTopLeftBack], False);
                     if c = GSelect.z2 then
                       FrontFrameLine(pX, pY, Dest, Sett.Frames.SelectCol, [flVertLeft, flTopLeftBack, flTopLeftFront], False)
                     else if (c > GSelect.z1) and (c < GSelect.z2) then
                       FrontFrameLine(pX, pY, Dest, Sett.Frames.SelectCol, [flTopLeftBack], False);
                   end else if (b > GSelect.y1) and (b < GSelect.y2) then begin
                     if c = GSelect.z2 then
                       FrontFrameLine(pX, pY, Dest, Sett.Frames.SelectCol, [flVertLeft], False);
                   end;
                 end;
                 if a = GSelect.x2 then begin
                   if b = GSelect.y1 then begin
                     if c = GSelect.z1 then
                       FrontFrameLine(pX, pY, Dest, Sett.Frames.SelectCol, [flVertRight, flBtmRightFront], False);
                     if c = GSelect.z2 then
                       FrontFrameLine(pX, pY, Dest, Sett.Frames.SelectCol, [flVertFront, flBtmRightFront, flBtmLeftFront], False)
                     else if (c > GSelect.z1) and (c < GSelect.z2) then
                       FrontFrameLine(pX, pY, Dest, Sett.Frames.SelectCol, [flBtmRightFront], False);
                   end;
                   if b = GSelect.y2 then begin
                     if c = GSelect.z1 then
                       FrontFrameLine(pX, pY, Dest, Sett.Frames.SelectCol, [flVertRight, flTopRightFront, flTopRightBack], False);
                     if c = GSelect.z2 then
                       FrontFrameLine(pX, pY, Dest, Sett.Frames.SelectCol, [flVertFront, flTopRightFront, flTopLeftFront], False)
                     else if (c > GSelect.z1) and (c < GSelect.z2) then
                       FrontFrameLine(pX, pY, Dest, Sett.Frames.SelectCol, [flTopRightFront], False);
                   end else if (b > GSelect.y1) and (b < GSelect.y2) then begin
                     if c = GSelect.z1 then
                       FrontFrameLine(pX, pY, Dest, Sett.Frames.SelectCol, [flVertRight], False);
                     if c = GSelect.z2 then
                       FrontFrameLine(pX, pY, Dest, Sett.Frames.SelectCol, [flVertFront], False)
                   end;
                 end else if (a > GSelect.x1) and (a < GSelect.x2) then begin
                   if b = GSelect.y1 then begin
                     if c = GSelect.z2 then
                       FrontFrameLine(pX, pY, Dest, Sett.Frames.SelectCol, [flBtmLeftFront], False);
                   end;
                   if b = GSelect.y2 then begin
                     if c = GSelect.z1 then
                       FrontFrameLine(pX, pY, Dest, Sett.Frames.SelectCol, [flTopRightBack], False);
                     if c = GSelect.z2 then
                       FrontFrameLine(pX, pY, Dest, Sett.Frames.SelectCol, [flTopLeftFront], False);
                   end;
                 end;
               end;
               {If SceneMode then begin
                 for i:= 0 to High(BreakMap[a, b, c]) do begin
                   Id:= BreakMap[a,b,c,i];
                   case Id.Typ of
                     1: If ShowTracks then DrawTrack(Id.Id,x,y,Dest.Canvas);
                     //3: If ShowActors then DrawActor(Id.Id,x,y,Dest.Canvas);
                     //If ShowZones and (Id.Zone > -1) then
                     // DrawZone(Id.Zone,x,y,Dest.Canvas,True);
                   end;
                 end;
               end;}
               if Inv and (foSelect in mi.Frame) and not (foNormal in mi.Frame) then
                 FrontFrameC(pX, pY, Dest, Sett.Frames.InvBrkCol);
               if (foSelect in mi.Frame) then begin
                 if SelFrame then FrontFrameC(pX, pY, Dest, Sett.Frames.SelectCol);
                 if CurFrame then FrontFrameC(pX, pY, Dest, Sett.Frames.CursorCol);
               end;
             end;
             if HelpFrame and ((PArea and (b < py1) and ((a = px2) or (c = pz2))) or
               Help3D and (((b >= py1) and (b <= py2)) and
                    (((c < pz1) and (a >= px1) and (a <= px2) and ((a = px2) or (b = py2)))
                 or  ((a < px1) and (c >= pz1) and (c <= pz2) and ((c = pz2) or (b = py2))))))
             then
               FrontFrameC(pX, pY, Dest, Sett.Frames.HelperCol);
           end;
         end;
         //Dec(pX,24); Inc(pY,12);
       end;
       //Inc(pX,(HighZ+1)*24); Dec(pY,(HighZ+1)*12+15);
     end;
     //Inc(pX,24); Inc(pY,(HighY+1)*15+12);
   end;

   {If btScActors.Down then
    for a:=0 to High(Actors) do begin
     //If Actors[a].rX+Actors[a].Width >
     DrawActor(a,x,y,Dest.Canvas);
     for a:=
    end;}

 end;
end;

procedure DrawSceneObjects(DrawSel: Boolean = True);
var a, cx1, cy1, cx2, cy2: Integer;
    DrawTracks: Boolean;
    AA: TActorDispInfo;
    TT: TPointDispInfo;
    ZZ: TZoneDispInfo;
begin
 If ProgMode <> pmScene then Exit;
 DrawTracks:= ScVisible.Tracks;
 cx1:= bufMain.Canvas.ClipRect.Left   - GOffX + GScrX;
 cy1:= bufMain.Canvas.ClipRect.Top    - GOffY + GScrY;
 cx2:= bufMain.Canvas.ClipRect.Right  - GOffX + GScrX;
 cy2:= bufMain.Canvas.ClipRect.Bottom - GOffY + GScrY;
 for a:= 0 to High(ObjectList) do
   if (ObjectList[a].typ = 1) and DrawTracks then begin
     TT:= VScene.Points[ObjectList[a].id].DispInfo;
     If (TT.gY <= HiVisLayer) and (TT.rX+12 >= cx1) and (TT.rY >= cy1)
     and (TT.rX-22 <= cx2) and (TT.rY-64 <= cy2) then
       RedrawTrack(ObjectList[a].id, False, False);
   end
   else if ObjectList[a].typ = 3 then begin
     AA:= VScene.Actors[ObjectList[a].id].DispInfo;
     if (AA.gY <= HiVisLayer) and (AA.rX+AA.Width >= cx1) and (AA.rY+AA.Height >= cy1)
     and (AA.rX <= cx2) and (AA.rY-30 <= cy2) then
       RedrawActor(ObjectList[a].id, False, False);
   end;
 //If DrawSel then DrawSelection; --perhaps not necessary
 for a:= 0 to High(VScene.Zones) do begin
   //if ScVisible.Zones[VScene.Zones[a].RealType] then begin
     ZZ:= VScene.Zones[a].DispInfo;
     if (ZZ.gY1 <= HiVisLayer) and (ZZ.sX1 >= cx1) and (ZZ.rY2 + ZZ.h >= cy1)
     and (ZZ.sX2 <= cx2) and (ZZ.rY1 - ZZ.h <= cy2) then
       RedrawZone(a, False, False);
   //end;
 end;
 if DrawSel then DrawSelection;
end;

procedure DrawMapA(dx: Integer = 0; dy: Integer = 0);
begin
 If not fmMain.pbGrid.Visible then Exit;
 //DrawMap(Off_X-Form1.HScr.Position-dx,Off_Y-Form1.VScr.Position-dy,bufMain); fixed, should not be necessary any more
 DrawMap(GOffX - GScrX - dx, GOffY - GScrY - dy, bufMain.Canvas);
 If ProgMode = pmScene then DrawSceneObjects();
 fmMain.pbThumbPaint(fmMain);
 {$ifndef NO_BUFFER}UpdateImage(bufMain, fmMain.pbGrid);{$endif}
end;

procedure DrawPiece(x, y, width, height: Integer; DrawMode: TDrawMode = dmNormal;
 ThumbRepnt: Boolean = True; DrawObjs: Boolean = True; DrawSel: Boolean = True;
 UpdClip: Boolean = True; ClearBkg: Boolean = True;
 StartX: Integer = 0; StartY: Integer = 0; StartZ: Integer = 0);
var NewClip: HRGN;
begin
 If not fmMain.pbGrid.Visible then Exit;
 If DrawMode = dmMerge then
  NewClip:= CreateRectRgn(Min(x-fmMain.HScr.Position,FrDrawRgn.Left),
                          Min(y-fmMain.VScr.Position,FrDrawRgn.Top),
                          Max(x+width-fmMain.HScr.Position,FrDrawRgn.Right),
                          Max(y+height-fmMain.VScr.Position,FrDrawRgn.Bottom))
 else
  NewClip:= CreateRectRgn(x-fmMain.HScr.Position,y-fmMain.VScr.Position,
                          x+width-fmMain.HScr.Position,y+height-fmMain.VScr.Position);

 SelectClipRgn(bufMain.Canvas.Handle,NewClip);
 If DrawMode = dmRemember then FrDrawRgn:= bufMain.Canvas.ClipRect
 else begin
   DrawMap(GOffX - fmMain.HScr.Position, GOffY - fmMain.VScr.Position, bufMain.Canvas,
           ClearBkg, StartX, StartY, StartZ);
   If ProgMode = pmScene then begin
     If DrawObjs then DrawSceneObjects(DrawSel);
     If DrawSel then DrawSelection;
   end;
   {$ifndef NO_BUFFER}If UpdClip then UpdateClip(bufMain, fmMain.pbGrid);{$endif}
   If ThumbRepnt then fmMain.pbThumbPaint(fmMain);
 end;
 {Form1.pbGrid.Canvas.FrameRect(         //for testing only
  Rect(x-Form1.HScr.Position,y-Form1.VScr.Position,
  x+width-Form1.HScr.Position,y+height-Form1.VScr.Position)); }
 SelectClipRgn(bufMain.Canvas.Handle,0);
 DeleteObject(NewClip);
end;

procedure DrawPieceBrk(x, y, z, dx, dy, dz: Integer; Mode: TDrawMode = dmNormal;
 Helper: Boolean = False; ThumbRepaint: Boolean = True);
begin
 If Helper and Sett.Controls.GHelper then begin
   dy:= dy + y; y:= 0;
   If Sett.Controls.GHelp3D then begin
     dx:= dx + x; x:= 0;
     dz:= dz + z; z:= 0;
   end;
 end;
 DrawPiece((x-z-dz+1)*24+GOffX, (x+z)*12-(y+dy-1)*15+GOffY-1,
           (dx+dz)*24+1, dy*15+(dx+dz)*12+1, Mode, ThumbRepaint);
end;

procedure ScrollMap(dx, dy: Integer); // + left; - right
var NewClip: HRGN;
    h, w, a: Integer;
begin
 with fmMain do begin
  If not pbGrid.Visible then Exit;
  If not HScr.Enabled then dx:= 0;
  If not VScr.Enabled then dy:= 0;
  If (dx > HScr.Max-GScrX-HScr.PageSize+1) then dx:= HScr.Max-GScrX-HScr.PageSize+1;
  If (dx < - GScrX) then dx:= - GScrX;
  If (dy > VScr.Max-GScrY-VScr.PageSize+1) then dy:= VScr.Max-GScrY-VScr.PageSize+1;
  If (dy < - GScrY) then dy:= - GScrY;
  If (dx = 0) and (dy = 0) then Exit;
  If HScr.Enabled then HScr.Position:= GScrX + dx;
  If VScr.Enabled then VScr.Position:= GScrY + dy;
  VScrChange(fmMain.HScr);
  If (Abs(dx) >= bufMain.Width) or (Abs(dy) >= bufMain.Height) then DrawMapA()//dx,dy)
  else begin
    h:= bufMain.Height;
    w:= bufMain.Width;
    BitBlt(bufMain.Canvas.Handle,Max(0,-dx),Max(0,-dy),w-dx,h-dy,
           bufMain.Canvas.Handle,Max(dx,0),Max(dy,0),SRCCOPY);
    for a:= 0 to 1 do begin
      If a = 0 then NewClip:= CreateRectRgn(IfThen(dx>0,w-dx),0,IfThen(dx>0,w,-dx),h)
      else NewClip:= CreateRectRgn(IfThen(dx<0,-dx),IfThen(dy>0,h-dy),IfThen(dx<0,w,w-dx),IfThen(dy>0,h,-dy));
      SelectClipRgn(bufMain.Canvas.Handle,NewClip);
      DrawMap(GOffX-GScrX{-dx}, GOffY-GScrY{-dy}, bufMain.Canvas);
      SelectClipRgn(bufMain.Canvas.Handle,0);
      DeleteObject(NewClip);
    end;
    If ProgMode = pmScene then DrawSceneObjects();
    {$ifndef NO_BUFFER}UpdateImage(bufMain, pbGrid);{$endif}
  end;
  pbThumbPaint(fmMain);
 end;
end;

Procedure BufferBricks(Lib: TLibrary; Brk: TPackEntries);
var a, b, BrkNum: Integer;      //only check if layouts and bricks are consistent
begin
 fmMain.imgBrkBuff.Clear();
 SetLength(BuffMap, Length(Brk) + 1);
 for a:= 1 to High(BuffMap) do BuffMap[a]:= -1;
 BuffMap[0]:= -2;
 for a:= 1 to High(Lib) do begin
  for b:= 0 to High(Lib[a].Map) do begin
   BrkNum:= Lib[a].Map[b].Index - 1;
   If High(Brk) < BrkNum then begin
     Application.MessageBox('One or more Layouts refer to a Brick that doesn''t exist! This usually happens if you select a Library from LBA 2 and Brick package from LBA 1. No files will be opened.',ProgramName,MB_ICONERROR+MB_OK);
     ProgBarForm.CloseSpecial;
     Abort;
   end;
  end;
 end;
end;

//exchanges R with B by the way
Function Average(v: array of TColor): TColor;
var a, c: Integer;
    r, g, b: Integer;
begin
 Result:=0;
 r:=0; g:=0; b:=0;
 c:=0;
 for a:=0 to 3 do
  If v[a]>clBlack then begin
   r:=r+(v[a] and $FF);
   g:=g+((v[a] div 256) and $FF);
   b:=b+((v[a] div (256*256)) and $FF);
   Inc(c);
  end;
 If c>0 then Result:=(b div c)+((g div c)*256)+((r div c)*256*256);
end;

function FlipRGB(v: TColor): TColor;
begin
 Result:= ((v and $0000FF) shl 16) or (v and $00FF00) or ((v and $FF0000) shr 16);
end;

procedure CreateThumbnail(Draft: Boolean; x1: Integer = 0; y1: Integer = 0;
  x2: Integer = ThumbSizeX - 1; y2: Integer = ThumbSizeY - 1);
var a, b: Integer;
    //v: TColor;
begin
 if x1 < 0 then x1:= 0;
 if y1 < 0 then y1:= 0;
 if x2 > ThumbSizeX - 1 then x2:= ThumbSizeX - 1;
 if y2 > ThumbSizeY - 1 then y2:= ThumbSizeY - 1;
 if Draft then begin
   for b:= y1 div 2 to y2 div 2 do
     for a:= x1 div 2 to x2 div 2 do begin
       //v:= FlipRGB(PixelOfScreen(a*GImgW div ThumbSizeX - GOffX-24, b * GImgH div ThumbSizeY - GOffY));
       //CopyMemory(Pointer(Integer(bufThumb.ScanLine[b])+a*3), @v,
       DWord(Pointer(Integer(bufThumb.ScanLine[b])+a*3)^):=
         FlipRGB(PixelOfScreen(a*GImgW div ThumbSizeX - GOffX-24, b * GImgH div ThumbSizeY - GOffY));
     end;
 end else begin
   for b:= y1 to y2 do
     for a:= x1 to x2 do
       DWord(Pointer(Integer(bufThumb.ScanLine[b])+a*3)^):=
         Average([PixelOfScreen((a*2)*GImgW div ThumbSizeX2 - GOffX-24, (b*2) * GImgH div ThumbSizeY2 - GOffY),
         PixelOfScreen((a*2+1) * GImgW div ThumbSizeX2 - GOffX-24, (b*2) * GImgH div ThumbSizeY2 - GOffY),
         PixelOfScreen((a*2) * GImgW div ThumbSizeX2 - GOffX-24, (b*2+1) * GImgH div ThumbSizeY2 - GOffY),
         PixelOfScreen((a*2+1) * GImgW div ThumbSizeX2 - GOffX-24, (b*2+1) * GImgH div ThumbSizeY2 - GOffY)]);
 end;      
end;

procedure UpdateThumbnail(x1, y1, z1, x2, y2, z2: Integer);
var rX1, rY1, rX2, rY2: Integer;
begin
 rX1:= (x1-z2)*24 + GOffX;
 rY1:= (x1+z1)*12 - y2*15 + GOffY - 1;
 rX2:= (x2-z1+2)*24 + GOffX + 1;
 rY2:= (x2+z2+2)*12 - (y1-1)*15 + GOffY - 1;
 CreateThumbnail(False, (rX1*ThumbSizeX) div GImgW, (rY1*ThumbSizeY) div GImgH,
                 (rX2*ThumbSizeX) div GImgW+1, (rY2*ThumbSizeY) div GImgH+1);
end;

procedure UpdateThumbBack(FirstDraft: Boolean);
begin
 if Assigned(CMap) then begin
   ThumbCounter:= IfThen(FirstDraft, -1, 0);
   fmMain.ThumbTimer.Enabled:= True;
 end;  
end;

Function FindLayout(Map: TComplexMap; x, y, z: Integer): TBox;
var lt: Integer;
begin
 Result:= BoxPoint(-1,-1,-1);
 lt:= Map.M^[x,y,z].Idx.Lt;
 If lt > 0 then begin
   Result:= BoxPoint(x,y,z);
   while (Result.x1 > 0)    and (Map.M^[Result.x1-1,y,z].Idx.Lt = lt) do Dec(Result.x1);
   while (Result.x2 < GHiX) and (Map.M^[Result.x2+1,y,z].Idx.Lt = lt) do Inc(Result.x2);
   while (Result.y1 > 0)    and (Map.M^[x,Result.y1-1,z].Idx.Lt = lt) do Dec(Result.y1);
   while (Result.y2 < GHiY) and (Map.M^[x,Result.y2+1,z].Idx.Lt = lt) do Inc(Result.y2);
   while (Result.z1 > 0)    and (Map.M^[x,y,Result.z1-1].Idx.Lt = lt) do Dec(Result.z1);
   while (Result.z2 < GHiZ) and (Map.M^[x,y,Result.z2+1].Idx.Lt = lt) do Inc(Result.z2);
 end
 else if Map.M^[x,y,z].Idx.Brk = 1 then begin
   Result:= BoxPoint(x,y,z);
   while (Result.x1 > 0)    and (Map.M^[Result.x1-1,y,z].Idx.Lt=0) and (Map.M^[Result.x1-1,y,z].Idx.Brk=1) do Dec(Result.x1);
   while (Result.x2 < GHiX) and (Map.M^[Result.x2+1,y,z].Idx.Lt=0) and (Map.M^[Result.x2+1,y,z].Idx.Brk=1) do Inc(Result.x2);
   while (Result.y1 > 0)    and (Map.M^[x,Result.y1-1,z].Idx.Lt=0) and (Map.M^[x,Result.y1-1,z].Idx.Brk=1) do Dec(Result.y1);
   while (Result.y2 < GHiY) and (Map.M^[x,Result.y2+1,z].Idx.Lt=0) and (Map.M^[x,Result.y2+1,z].Idx.Brk=1) do Inc(Result.y2);
   while (Result.z1 > 0)    and (Map.M^[x,y,Result.z1-1].Idx.Lt=0) and (Map.M^[x,y,Result.z1-1].Idx.Brk=1) do Dec(Result.z1);
   while (Result.z2 < GHiZ) and (Map.M^[x,y,Result.z2+1].Idx.Lt=0) and (Map.M^[x,y,Result.z2+1].Idx.Brk=1) do Inc(Result.z2);
 end;
end;

procedure GetBrick(X, Y, L: Integer; var gX, gZ: Integer);
begin
 gX:=((X+2+((Y+L*15)*2)) div 48);
 gZ:=((-X+1+((Y+L*15)*2)) div 48);
end;

Function PixelOfScreenVal(X, Y: Integer; Full: Boolean; Mode: TSelMode2): Byte;
var gX, gZ, oX, oY, oY2, MaxLayer: Integer;
    mi: TMapItem;
begin
 Result:= 0;
 FneDone:= False;
 MaxLayer:= Sett.Controls.MaxLayer;

 If  (X > -GHiZ*24-24-3)  and (X < GHiX*24+24+3) //vertical borders
 and (X > (-Y-GOffY)*2+32) and (X < (Y+GOffY)*2-32)
 and (X > (Y-GOffX)*2-41)  and (X < (-Y-GOffX+GImgW)*2-55) then begin
   Y:= Y * 2 + GHiY * 30 + 30;
   for CoLayer:= GHiY downto 0 do begin
     Dec(Y, 30);
     if not Full and (CoLayer > MaxLayer) then Continue;
     gX:= (X + 2 + Y) div 48;
     gZ:= (-X + 1 + Y) div 48;
     oX:= X - (gX-gZ)*24 + 24;
     oY:= (Y div 2) - (gX+gZ) * 12;
     oY2:= oY * 2;
     if (oY2 < -oX + 22) or (oY2 < oX - 25) then Break;
     Coords[0,0]:= gX;  // grid X
     Coords[0,1]:= gZ;  // grid Y
     Coords[0,2]:= oX;  // offset X
     Coords[0,3]:= oY;  // offset Y
     if ((oX < 24) and (oY2 >= 22-oX) and (oY2 <= 51-oX))
     or ((oX >= 24) and (oY2 >= oX-25) and (oY2 <= oX+4)) then begin
       if oX < 24 then begin
         Coords[1,0]:= gX - 1;
         Coords[1,1]:= gZ;
         Coords[1,2]:= oX + 24;
       end
       else begin
         Coords[1,0]:= gX;
         Coords[1,1]:= gZ - 1;
         Coords[1,2]:= oX - 24;
       end;
       Coords[1,3]:= oY + 12;
       If ((oX < 24) and (oY2 >= -22-oX) and (oY2 <= oX+6))
       or ((oX >= 24) and (oY2 >= oX-25) and (oY2 <= 54-oX)) then begin
         Coords[2,0]:= gX - 1;
         Coords[2,1]:= gZ - 1;
         Coords[2,2]:= oX;
         Coords[2,3]:= oY + 24;
       end
       else Coords[2,0]:= -1;
     end
     else begin
       Coords[1,0]:= -1;
       Coords[2,0]:= -1;
     end;

     for CoIndex:= 0 to 2 do begin
       if (Coords[CoIndex,0] < 0) or (Coords[CoIndex,0] > GHiX)
       or (Coords[CoIndex,1] < 0) or (Coords[CoIndex,1] > GHiZ) then Continue;
       mi:= CMap^.M^[Coords[CoIndex,0], CoLayer, Coords[CoIndex,1]];
       if not FneDone and (foSelect in mi.Frame)
       and not ((Mode = smInvisi) and (foNormal in mi.Frame)) then begin
         FneCoords[0]:= Coords[CoIndex, 0];
         FneCoords[1]:= CoLayer;
         FneCoords[2]:= Coords[CoIndex, 1];
         FneDone:= True;
       end;
       if Mode <> smInvisi then begin
         if mi.BrkNr < 1 then Continue;
         Result:= PixelOfBrick(Coords[CoIndex,2], Coords[CoIndex,3], mi.BrkNr-1);
         if Result > 0 then Exit;
       end
       else if FneDone then Exit;
     end;
   end;
 end;
 if not FneDone then FneCoords[0]:= -1;
end;

Function PixelOfScreen(X, Y: Integer): TColor;
begin
 Result:= Palette[PixelOfScreenVal(X,Y,True,smNormal)];
end;

Function GetPCursor(mX, mY: Integer; PointOnly: Boolean): TBox;
var a: Integer;
    Fnt, FullMap: Boolean;
    Mode: TSelMode2;
begin
 Fnt:= Sett.Controls.GSelNTrans or PointOnly; //PointOnly in SceneMode only :)
 FullMap:= not Sett.Controls.MaxLayerEna;
 if GridTool = gtInvisi then Mode:= smInvisi
 else if Sett.Controls.Invisi then Mode:= smNormInv
 else Mode:= smNormal;
 a:= PixelOfScreenVal(mX - GOffX + GScrX - 24, mY - GOffY + GScrY, FullMap, Mode);
 If (Fnt and (a > 0))
 or ((not Fnt or (Mode = smInvisi)) and (FneCoords[0] > -1)) then begin
   If Fnt then begin
     FneCoords[0]:= Coords[CoIndex,0];
     FneCoords[1]:= CoLayer;
     FneCoords[2]:= Coords[CoIndex,1];
   end;
   If PointOnly or (((GridTool = gtSelect) and (Sett.Controls.GSelMode = smBrick))
   or ((GridTool = gtInvisi) and Sett.Controls.GInvModeBrk)) then
     Result:= BoxPoint(FneCoords[0],FneCoords[1],FneCoords[2])
   else if Sett.Controls.GSelMode = smColumn then
     Result:= Box(FneCoords[0], 0, FneCoords[2], FneCoords[0], GHiY, FneCoords[2])
   else if (((GridTool = gtSelect) and (Sett.Controls.GSelMode = smObject))
   or ((GridTool = gtInvisi) and not Sett.Controls.GInvModeBrk)) and not GSelecting then
     Result:= FindLayout(CMap^, FneCoords[0], FneCoords[1], FneCoords[2])
   else
     Result:= BoxPoint(-1,-1,-1);
 end else
   Result:= BoxPoint(-1,-1,-1);
end;

Procedure MakeLayoutMap();
var a: Integer;
begin
 SetLength(LayoutMap, Length(LdLibrary));
 LayoutMap[0]:= 0;
 for a:= 1 to High(LdLibrary) do
  LayoutMap[a]:= LayoutMap[a-1] + GetLtHeight(LdLibrary[a]) + 3;
end;

Procedure PaintLayout(x, y, Nr: Integer; dest: TCanvas);
var a, dX, dY, dZ, pX, pY: Integer;
    Lt: TLayout;
begin
 If Length(LdLibrary) < 1 then Exit;
 Lt:= LdLibrary[Nr];
 for a:= 0 to Lt.X * Lt.Y * Lt.Z - 1 do begin
  dX:= a mod Lt.X;
  dY:= (a div Lt.X) mod Lt.Y;
  dZ:= (a div Lt.X) div Lt.Y;
  GridToPosVar(dX, dY, dZ, (Lt.Z-1)*24+x, (Lt.Y-1)*15+1+y, pX, pY);
  If Sett.Controls.GLayoutFr then BackFrame(pX, pY, dest, Sett.Frames.PanelCol);
  If Lt.Map[a].Index > 0 then begin
   If Lt.Map[a].Index <> TransparentBrick then begin
    If BuffMap[Lt.Map[a].Index] = -1 then BufferBrick(Lt.Map[a].Index);
    fmMain.imgBrkBuff.Draw(Dest, pX, pY, BuffMap[Lt.Map[a].Index]);
   end;
  end;
  If Sett.Controls.GLayoutFr then FrontFrame(pX, pY, dest, Sett.Frames.PanelCol);
 end;
end;

procedure PaintLayouts();
var a: Integer;
    t: String;
begin
 If Length(LdLibrary) < 1 then Exit;
 With fmMain do begin
   imgLts.Canvas.Brush.Color:= clBtnFace;
   imgLts.Canvas.FillRect(imgLts.Canvas.ClipRect);
   MakeLayoutMap();
   for a:= 1 to High(LdLibrary) do begin
     If LayoutMap[a] - LScr.Position < 0 then Continue;
     If LayoutMap[a-1] - LScr.Position > imgLts.Height then Continue;
     If a = LtSel then begin
       imgLts.Canvas.Brush.Color:= clSkyBlue;
       imgLts.Canvas.FillRect(Rect(0, LayoutMap[a-1]-LScr.Position-1,
         imgLts.Width, LayoutMap[a]-LScr.Position-2));
       imgLts.Canvas.Brush.Style:= bsClear;
     end;
     PaintLayout(0, LayoutMap[a-1]-LScr.Position, a, imgLts.Canvas);
     t:= IntToStr(IfThen(Sett.General.FirstIndex1, a, a - 1));
     imgLts.Canvas.TextOut(imgLts.Width - imgLts.Canvas.TextWidth(t) - 2,
       LayoutMap[a] - LScr.Position - 15, t);
     imgLts.Canvas.Pen.Color:= clBtnShadow;
     imgLts.Canvas.MoveTo(0, LayoutMap[a] - LScr.Position - 2);
     imgLts.Canvas.LineTo(imgLts.Width, LayoutMap[a] - LScr.Position - 2);
   end;
   UpdateImage(imgLts, fmMain.pbLts);
 end;
end;

Procedure InvPlacingEnd();
begin
 GInvPlacing:= False;
 DrawPieceBrk(GPlacePos.x,GPlacePos.y,GPlacePos.z,PlaceObj.X,PlaceObj.Y,PlaceObj.Z,dmNormal,True);
 fmMain.btInvNew.Caption:= 'Create';
 fmMain.seX.Enabled:= True;
 fmMain.seY.Enabled:= True;
 fmMain.seZ.Enabled:= True;
end;

end.
