unit Maps;

interface

uses Controls, Engine, Libraries, Math, Classes, SysUtils;

const
  GUndoLevels = 10; //Observe that large undo limit values can significantly increase
                    //memory usage. One undo level for a full-size Grid (64 x 25 x 64)
                    //takes about 1.2 MBytes of memory!

type
 TFrameOpts = set of (foNormal, foSelect); //foNormal = 0 for invisible bricks

 TBlockIndex = record
   Lt, Brk: Byte;
 end;

 TMapItem = record
   Idx: TBlockIndex;
   BrkNr: Integer; //1+ = normal, 0 = invisible, -1 = empty
   Shape: Byte;
   Frame: TFrameOpts;
   FrLines: TFrameLines;
 end;

 TGridMap = array of array of array of TMapItem;

 TComplexMap = record
   X, Y, Z: Integer; //Dimensions
   Id: Integer; //Index to the current 'state' in the States
   M: ^TGridMap;
   Max: Integer; //Highest index of state used
   States: array[0..GUndoLevels] of TGridMap; //Undo-Redo states plus current
   //Undo/Redo model: the most current Grid is the farthest (highest index);
   //  Un-doing decreases index; Re-doing increases index.
   Modified: Boolean;
   FilePath: String;
   FileIndex: Integer; //when inside a HQR
   IsGrid: Boolean; //if False then the map is LBA 2 Fragment
   Compression: Byte; //original compression (if opened from hqr)
   Name: String; //User-defined map name (not editable yet)
   IsMainMap: Boolean; //if it is the Main Grid (LdMaps[0])
 end;

 PComplexMap = ^TComplexMap;

 TMapPiece = record
   X, Y, Z: Integer; //Dimensions
   Map: TGridMap;
 end;

 TMapType = (mtGrid, mtFragment);

 TGridLibUsage = array[1..255] of Boolean;
 PGridLibUsage = ^TGridLibUsage;

const
  EmptyMapItem: TMapItem = (Idx: (Lt: 0; Brk: 0); BrkNr: -1; Frame: []; FrLines: []);


procedure UpdateCurrentMapEnvironment();
procedure SetCurrentMapSize(X, Y, Z: Integer);
procedure SetMapSize(var Map: TComplexMap; X, Y, Z: Integer);
procedure InitMap(var Map: TComplexMap; X, Y, Z: Integer);
procedure ClearMap(var Map: TComplexMap);
//procedure DataToMap();

procedure SetAllFrameLines(var Map: TComplexMap);

//For full Grids only.
//LibId and FragId are valid for LBA 2 Grids only
//Returns True if succeeds.
Function LoadGridFromStream(data: TStream; Lba2: Boolean;
  Lib: TLibrary; out LibId, FragId: Byte; var Map: TComplexMap): Boolean;
//For LBA 2 Fragments only
Function LoadFragmentFromStream(data: TStream; Lib: TLibrary;
  var Map: TComplexMap): Boolean;

function LibUsageToString(LU: TGridLibUsage): String;
function GetGridLibUsage(Map: TComplexMap): TGridLibUsage;
function MergeGridLibUsage(LU1, LU2: TGridLibUsage): TGridLibUsage;
function GetAllMapsLibUsage(): TGridLibUsage;

//For full Grids only.
//AddLibUsage: additional lib usage table to be merged with the Grid table;
//  it may be nil when not used.
//LibId and FragId are necessary for LBA 2 Grids only.
Function MapToGridString(Map: TComplexMap; Lba2: Boolean;
  AddLibUsage: PGridLibUsage = nil; LibId: Byte = 0;
  FragId: Byte = 0): String;
//For LBA 2 Fragments only
Function MapToFragmentString(Map: TComplexMap): String;

Function LayoutToPiece(Lt: TLayout; Id: Integer): TMapPiece;
function CopyPiece(Map: TComplexMap; x, y, z: Integer; dx, dy, dz: Word;
  InvOnly: Boolean = False): TMapPiece;
procedure PutPiece(var Map: TComplexMap; x, y, z: Integer; Fr: TMapPiece;
  Transparent: Boolean = True);
Procedure DelPiece(var Map: TComplexMap; x, y, z, dx, dy, dz: Integer); overload;
Procedure DelPiece(var Map: TComplexMap; Range: TBox); overload;

//Adds a new map to the global LdMaps array and returns its index
//  (-1 if failed)
function CreateNewMap(UpdateEnv: Boolean): Integer;
//Removes given map from the global LdMaps array and deletes its contents
procedure CloseMap(Index: Integer);

function CopyGridMap(Src: TGridMap): TGridMap;

//Undo/Redo functions:
procedure MapCreateUndo(var Map: TComplexMap);
procedure MapDoUndo(var Map: TComplexMap);
procedure MapDoRedo(var Map: TComplexMap);

procedure SelectMap(Index: Integer);

implementation

uses Main, Globals, Utils, Settings, Rendering, OpenSim, Scenario;

//Updates variables according to map size
procedure UpdateCurrentMapEnvironment();
begin
 GHiX:= CMap^.X - 1;
 GHiY:= CMap^.Y - 1;
 GHiZ:= CMap^.Z - 1;
 GImgW:= (GHiX+GHiZ+2) * 24 + 40;
 GImgH:= (GHiX+GHiZ+2) * 12 + (GHiY+1) * 15 + 40;
 GOffX:= GHiZ * 24 + 20;
 GOffY:= (GHiY+1) * 15 + 5;
 fmMain.seMaxLayer_.MaxValue:= GHiY;
 fmMain.seScMaxLayer_.MaxValue:= GHiY;
 fmMain.sePlaceLayer.MaxValue:= GHiY;
 fmMain.seX.MaxValue:= GHiX + 1;
 fmMain.seY.MaxValue:= GHiY + 1;
 fmMain.seZ.MaxValue:= GHiZ + 1;
 fmMain.seAX.MaxValue:= GHiX + 1;
 fmMain.seAY.MaxValue:= GHiY + 1;
 fmMain.seAZ.MaxValue:= GHiZ + 1;
end;

procedure SetCurrentMapSize(X, Y, Z: Integer);
begin
 SetMapSize(CMap^, X, Y, Z);
 UpdateCurrentMapEnvironment();
end;

procedure SetMapSize(var Map: TComplexMap; X, Y, Z: Integer);
var a: Integer;
begin
 Map.X:= X;
 Map.Y:= Y;
 Map.Z:= Z;
 for a:= 0 to GUndoLevels do
   SetLength(Map.States[a], X, Y, Z);
 Map.M:= @Map.States[Map.Id]; //Might have changed, so update it
end;

procedure InitMap(var Map: TComplexMap; X, Y, Z: Integer);
begin
 SetMapSize(Map, X, Y, Z);
 Map.Id:= 0;
 Map.M:= @Map.States[0];
 Map.Max:= 0;
 ClearMap(Map);
 Map.Modified:= False;
 Map.FilePath:= '';
 Map.FileIndex:= -1;
end;

procedure ClearMap(var Map: TComplexMap);
var a, b, c: Integer;
begin
 for a:= 0 to Map.X - 1 do
   for b:= 0 to Map.Y - 1 do
     for c:= 0 to Map.Z - 1 do
       Map.M^[a,b,c]:= EmptyMapItem;
end;

procedure SetFrameOpts(var Item: TMapItem; Lba2: Boolean);
begin
 Item.Frame:= [];
 If Item.BrkNr >= 1 then Item.Frame:= [foNormal, foSelect];
 If (Lba2 and (Item.BrkNr = TransparentBrick)) or (Item.BrkNr = 0) then
   Item.Frame:= [foSelect];
end;

procedure SetAllFrameOpts(var Map: TComplexMap; Lba2: Boolean);
var a, b, c: Integer;
begin
 for a:= 0 to Map.X - 1 do
   for b:= 0 to Map.Y - 1 do
     for c:= 0 to Map.Z - 1 do
       SetFrameOpts(Map.M^[a, b, c], Lba2);
end;

procedure SetFrameLines(var Map: TComplexMap; x, y, z: Integer);
var a, b, c: Integer;
    temp: TFrameLines;
    surround: array[-1..1, -1..1, -1..1] of Boolean;
begin
 If not (foSelect in Map.M^[x, y, z].Frame) then
   Map.M^[x, y, z].FrLines:= []
 else begin
   temp:= [];
   If Sett.Frames.NewStyleEdges then //by edges
     for a:= -1 to 1 do
       for b:= -1 to 1 do
         for c:= -1 to 1 do
          If (x+a < 0) or (x+a > Map.X - 1) or (y+b < 0) or (y+b > Map.Y - 1)
          or (z+c < 0) or (z+c > Map.Z - 1) then
            surround[a, b, c]:= False
          else
            surround[a, b, c]:= foSelect in Map.M^[x+a, y+b, z+c].Frame
   else     //by objects
     for a:= -1 to 1 do
       for b:= -1 to 1 do
         for c:= -1 to 1 do
           If (x+a < 0) or (x+a > Map.X - 1) or (y+b < 0) or (y+b > Map.Y - 1)
           or (z+c < 0) or (z+c > Map.Z - 1) then
             surround[a, b, c]:= False
           else
             surround[a, b, c]:= Map.M^[x+a, y+b, z+c].Idx.Lt = Map.M^[x, y, z].Idx.Lt;

   If (surround[-1,0,0] and surround[0,1,0] and not surround[-1,1,0])
      or not (surround[-1,0,0] or surround[0,1,0]) then temp:= temp + [flTopLeftBack];
   If (surround[0,0,1] and surround[0,1,0] and not surround[0,1,1])
      or not (surround[0,0,1] or surround[0,1,0]) then temp:= temp + [flTopLeftFront];
   If (surround[0,0,-1] and surround[0,1,0] and not surround[0,1,-1])
      or not (surround[0,0,-1] or surround[0,1,0]) then temp:= temp + [flTopRightBack];
   If (surround[1,0,0] and surround[0,1,0] and not surround[1,1,0])
      or not (surround[1,0,0] or surround[0,1,0]) then temp:= temp + [flTopRightFront];

   If (surround[-1,0,0] and surround[0,-1,0] and not surround[-1,-1,0])
      or not (surround[-1,0,0] or surround[0,-1,0]) then temp:= temp + [flBtmLeftBack];
   If (surround[0,0,1] and surround[0,-1,0] and not surround[0,-1,1])
      or not (surround[0,0,1] or surround[0,-1,0]) then temp:= temp + [flBtmLeftFront];
   If (surround[0,0,-1] and surround[0,-1,0] and not surround[0,-1,-1])
      or not (surround[0,0,-1] or surround[0,-1,0]) then temp:= temp + [flBtmRightBack];
   If (surround[1,0,0] and surround[0,-1,0] and not surround[1,-1,0])
      or not (surround[1,0,0] or surround[0,-1,0]) then temp:= temp + [flBtmRightFront];

   If (surround[1,0,0] and surround[0,0,1] and not surround[1,0,1])
      or not (surround[1,0,0] or surround[0,0,1]) then temp:= temp + [flVertFront];
   If (surround[-1,0,0] and surround[0,0,1] and not surround[-1,0,1])
      or not (surround[-1,0,0] or surround[0,0,1]) then temp:= temp + [flVertLeft];
   If (surround[1,0,0] and surround[0,0,-1] and not surround[1,0,-1])
      or not (surround[1,0,0] or surround[0,0,-1]) then temp:= temp + [flVertRight];
   If (surround[-1,0,0] and surround[0,0,-1] and not surround[-1,0,-1])
      or not (surround[-1,0,0] or surround[0,0,-1]) then temp:= temp + [flVertBack];

   Map.M^[x, y, z].FrLines:= temp;
 end;
end;

procedure SetAllFrameLines(var Map: TComplexMap);
var a, b, c: Integer;
begin
 for c:= 0 to Map.X - 1 do
   for b:= 0 to Map.Y - 1 do
     for a:= 0 to Map.Z - 1 do
       SetFrameLines(Map, a, b, c);
end;

procedure SetBrkNr(Lib: TLibrary; var MapItem: TMapItem; Fragment2: Boolean);
begin
 If MapItem.Idx.Lt > 0 then begin
   If (Length(Lib) < MapItem.Idx.Lt)
   or (High(Lib[MapItem.Idx.Lt].Map) < MapItem.Idx.Brk) then begin
     If not BadLibraryMessage then
       WarningMsg('One or more Grid objects refer to a Layout or Brick that doesn''t exist! You should check if the Library you selected is appropriate to the Grid. Anyway, the Grid will be opened, but invalid references will be removed.');
     BadLibraryMessage:= True;
     MapItem.Idx.Lt:= 0;
     MapItem.Idx.Brk:= 0;
     MapItem.BrkNr:= 0;
     MapItem.Shape:= 0;
   end
   else begin
     MapItem.BrkNr:= Lib[MapItem.Idx.Lt].Map[MapItem.Idx.Brk].Index;
     MapItem.Shape:= Lib[MapItem.Idx.Lt].Map[MapItem.Idx.Brk].Shape;
   end;
 end
 else if Fragment2 and (MapItem.Idx.Brk = 0) then MapItem.BrkNr:= -1
 else MapItem.BrkNr:= 0;
end;

{function GridToMap(Grd: TGrid; Lib: TLibrary; Lba2: Boolean): TComplexMap; //full grids only
var a, b, c, Height, BlockCount: Integer;
    MapItem: TMapItem;
begin
 Result:= InitMap(64, 25, 64);
 BadLibraryMessage:= False;
 for a:= 0 to High(Grd.Cells) do begin
  Height:= 0;
  for b:= 0 to High(Grd.Cells[a].Objects) do begin
   BlockCount:= (Grd.Cells[a].Objects[b].Flags and $1F)+1;
   case (Grd.Cells[a].Objects[b].Flags and $E0) of
    $40: for c:= 0 to BlockCount - 1 do begin
           MapItem.Idx:= Grd.Cells[a].Objects[b].Blocks[c];
           SetBrkNr(Lib, MapItem, False);
           Result.M^[a mod 64, Height, a div 64]:= MapItem;
           Inc(Height);
         end;
    $80: begin
           MapItem.Idx:= Grd.Cells[a].Objects[b].Blocks[0];
           SetBrkNr(Lib, MapItem, False);
           for c:= 0 to BlockCount - 1 do begin
             Result.M^[a mod 64, Height, a div 64]:= MapItem;
             Inc(Height);
           end;
         end;
    $00: for c:= 0 to BlockCount - 1 do begin
           MapItem.Idx.Lt:= 0;
           MapItem.Idx.Brk:= 0;
           MapItem.BrkNr:= -1;
           Result.M^[a mod 64, Height, a div 64]:= MapItem;
           Inc(Height);
         end;
   end;
  end;
 end;

 for c:= 0 to 63 do
   for b:= 0 to 24 do
     for a:= 0 to 63 do
       SetFrameOpts(Result.M^[a,b,c], Lba2);

 SetAllFrameLines(Result);
end;

Procedure DataToMap(MapType: TMapType): TComplexMap;
begin                                 tu
 If GridNow then GridToMap(Grid, VLibrary)
 else FragmentToMap(Frag, VLibrary);
 FindLba2Invisible(VLibrary);
end;}

//For full Grids only
//LibId and FragId are valid for LBA 2 Grids only
//Returns True if succeeds.
Function LoadGridFromStream(data: TStream; Lba2: Boolean;
  Lib: TLibrary; out LibId, FragId: Byte; var Map: TComplexMap): Boolean;
var x, y, z, c, d, off, N: Integer;
    Flags, Groups, Blocks: Byte;
    offset: Word;
    temp: TMapItem;
begin
 Result:= True;
 InitMap(Map, 64, 25, 64);
 Map.IsGrid:= True;
 BadLibraryMessage:= False;

 if data.Size < 64 * 64 * 2 then
   Result:= False
 else
   try
     If Lba2 then begin
       data.Seek(0, soBeginning);
       data.Read(LibId, 1);
       data.Read(FragId, 1);
       off:= 34; //skip the Layout usage data for LBA 2
     end
     else begin
       LibId:= 0;
       FragId:= 0;
       off:= 0;
     end;

     N:= 0;
     for z:= 0 to 63 do
       for x:= 0 to 63 do begin
         data.Seek(N * 2 + off, soBeginning); //Jump to the Nth offset
         data.Read(offset, 2);
         Inc(N);
         y:= 0;
         data.Seek(offset + off, soBeginning); //Jump to the column data
         data.Read(Groups, 1);
         for c:= 0 to Groups - 1 do begin //Y -  block groups
           data.Read(Flags, 1);
           Blocks:= (Flags and $1F) + 1;
           case (Flags and $E0) of
             $00: for d:= 0 to Blocks - 1 do begin //Y - blocks in group
                    Map.M^[x, y, z].Idx.Lt:= 0;
                    Map.M^[x, y, z].Idx.Brk:= 0;
                    Map.M^[x, y, z].BrkNr:= -1;
                    Inc(y);
                  end;
             $40: for d:= 0 to Blocks - 1 do begin
                    data.Read(Map.M^[x, y, z].Idx.Lt, 1);
                    data.Read(Map.M^[x, y, z].Idx.Brk, 1);
                    SetBrkNr(Lib, Map.M^[x, y, z], False);
                    Inc(y);
                  end;
             $80: begin
                    data.Read(temp.Idx.Lt, 1);
                    data.Read(temp.Idx.Brk, 1);
                    SetBrkNr(Lib, temp, False);
                    for d:= 0 to Blocks - 1 do begin
                      Map.M^[x, y, z]:= temp;
                      Inc(y);
                    end;
                  end;
           end;
         end;
       end;

     SetAllFrameOpts(Map, Lba2);
     SetAllFrameLines(Map);  
   except
     Result:= False;
   end;
end;

//For LBA 2 Fragments only
Function LoadFragmentFromStream(data: TStream; Lib: TLibrary;
  var Map: TComplexMap): Boolean;
var a, b, c: Integer;
    x, y, z: Byte;
begin
 Result:= False;
 Map.IsGrid:= False;
 if data.Size >= 3 then begin
   data.Seek(0, soBeginning);
   data.Read(x, 1);
   data.Read(y, 1);
   data.Read(z, 1);
   InitMap(Map, x, y, z);
   BadLibraryMessage:= False;
   if data.Size >= 3 + x * y * z * 2 then begin
     for c:= 0 to z - 1 do
       for a:= 0 to x - 1 do
         for b:= 0 to y - 1 do begin
           data.Read(Map.M^[a,b,c].Idx.Lt, 1);
           data.Read(Map.M^[a,b,c].Idx.Brk, 1);
           SetBrkNr(Lib, Map.M^[a,b,c], True);
           SetFrameOpts(Map.M^[a,b,c], True);
         end;
     Result:= True;    
   end
 end;
end;

function LibUsageToString(LU: TGridLibUsage): String;
var a: Integer;
begin
 Result:= StringOfChar(#0, 32);
 for a:= 1 to 255 do
   if LU[a] then
     Result[a div 8 + 1]:= Char(Byte(Result[a div 8 + 1]) or ($80 shr (a mod 8)));
end;

function GetGridLibUsage(Map: TComplexMap): TGridLibUsage;
var a, b, c: Integer;
    Lt: Byte;
begin
 FillChar(Result[1], 255, False);
 for a:= 0 to Map.X - 1 do
   for b:= 0 to Map.Y - 1 do
     for c:= 0 to Map.Z - 1 do begin
       Lt:= Map.M^[a, b, c].Idx.Lt;
       if Lt > 0 then Result[Lt]:= True;
     end;
end;

function MergeGridLibUsage(LU1, LU2: TGridLibUsage): TGridLibUsage;
var a: Integer;
begin
 for a:= 1 to 255 do
   Result[a]:= LU1[a] or LU2[a];
end;

function GetAllMapsLibUsage(): TGridLibUsage;
var a: Integer;
begin
 Assert(Length(LdMaps) > 0, 'GetAllMapsLibUsage');
 Result:= GetGridLibUsage(LdMaps[0]);
 for a:= 1 to High(LdMaps) do
   Result:= MergeGridLibUsage(Result, GetGridLibUsage(LdMaps[a]));
end;

//full grids only
Function GetMapColObjType(Map: TComplexMap; x, y, z: Integer): Byte;
begin
 if (Map.M^[x, y, z].BrkNr = -1) then Result:= $00
 else if ((y < Map.Y - 1) and (Map.M^[x, y, z].BrkNr = Map.M^[x, y+1, z].BrkNr))
      or ((y > 0) and (Map.M^[x, y, z].BrkNr = Map.M^[x, y-1, z].BrkNr))
 then Result:= $80
 else Result:= $40;
end;

Function MapColObjTypeUpdated(Map: TGridMap; x, y, z: Integer): Boolean;
begin
 Result:= (y > 0) and (Map[x, y, z].BrkNr <> Map[x, y-1, z].BrkNr);
end;

//full grids only
Function FindSamePrevMapColumn(Map: TComplexMap; Nr: Integer): Integer;
var b, mx, mz, cx, cz: Integer;
    Same: Boolean;
begin
 cx:= Nr mod Map.X;
 cz:= Nr div Map.X;
 for Result:= 0 to Nr - 1 do begin
   mx:= Result mod Map.X;
   mz:= Result div Map.X;
   Same:= True;
   for b:= 0 to Map.Y - 1 do
     if Map.M^[mx, b, mz].BrkNr <> Map.M^[cx, b, cz].BrkNr then begin
       Same:= False;
       Break;
     end;
   if Same then Exit;
 end;
 Result:= -1;
end;

//full grids only
Function MapToGridString(Map: TComplexMap; Lba2: Boolean;
  AddLibUsage: PGridLibUsage = nil; LibId: Byte = 0;
  FragId: Byte = 0): String;
var a, b, c, d, Start, Off: Integer;
    OType, NextOType: Byte; //$00 = empty, $40 = different, $80 = same
    LibUsage: TGridLibUsage;
    Data, Column, LUStr: String;
    Offsets: array of Word;
begin
 LibUsage:= GetGridLibUsage(Map);
 if Assigned(AddLibUsage) then
   LibUsage:= MergeGridLibUsage(LibUsage, AddLibUsage^);
 LUStr:= LibUsageToString(LibUsage);

 SetLength(Offsets, Map.X * Map.Z);
 Result:= '';
 Data:= '';
 Off:= 8192;
 for c:= 0 to Map.Z - 1 do
   for a:= 0 to Map.X - 1 do begin
     //Search for identical previous column first:
     d:= FindSamePrevMapColumn(Map, c * 64 + a);
     if d >= 0 then
       Offsets[c * Map.X + a]:= Offsets[d]

     else begin //No identical column found, so make new:
       Column:= #0;
       Start:= 0;
       OType:= GetMapColObjType(Map, a, 0, c);
       NextOType:= 255;
       for b:= 1 to Map.Y do begin
         if b < Map.Y then
           NextOType:= GetMapColObjType(Map, a, b, c);
         if (NextOType <> OType) or (b = Map.Y) or MapColObjTypeUpdated(Map.M^, a, b, c)
         then begin
           Column[1]:= Char(Byte(Column[1]) + 1);
           Column:= Column + Char(OType or (b - Start - 1));
           case OType of
             $40: for d:= Start to b - 1 do
                    Column:= Column + Char(Map.M^[a, d, c].Idx.Lt) + Char(Map.M^[a, d, c].Idx.Brk);
             $80: Column:= Column + Char(Map.M^[a, Start, c].Idx.Lt) + Char(Map.M^[a, Start, c].Idx.Brk);
           end;
           Start:= b;
           OType:= NextOType;
         end;
       end;  

       Offsets[c * Map.X + a]:= Off;
       Data:= Data + Column;
       Inc(Off, Length(Column));
     end;
     Result:= Result + WordToBinStr(Offsets[c * Map.X + a]);
   end;

 //And finally put everything together:
 if Lba2 then
   Result:= Char(LibId) + Char(FragId) + LUStr + Result + Data
 else
   Result:= Result + Data + LUStr;  
end;

//For LBA 2 Fragments only
Function MapToFragmentString(Map: TComplexMap): String;
var a, b, c: Integer;
begin
 Result:= Char(Map.X) + Char(Map.Y) + Char(Map.Z);
 for c:= 0 to Map.Z - 1 do
   for a:= 0 to Map.X - 1 do
     for b:= 0 to Map.Y - 1 do
       Result:= Result + Char(Map.M^[a, b, c].Idx.Lt) + Char(Map.M^[a, b, c].Idx.Brk);
end;

Function LayoutToPiece(Lt: TLayout; Id: Integer): TMapPiece;
var a, b, c, x: Integer;
begin
 if Lt.X * Lt.Y * Lt.Z > 256 then
   WarningMsg('This Layout has more than 256 blocks and thus will most likely mess up if you try '
            + 'to use it in the game.'#13'This is LBA (1 & 2) engine limitation.');
 Result.X:= fmMain.frLtClip.ClipBox.x2 - fmMain.frLtClip.ClipBox.x1 + 1;
 Result.Y:= fmMain.frLtClip.ClipBox.y2 - fmMain.frLtClip.ClipBox.y1 + 1;
 Result.Z:= fmMain.frLtClip.ClipBox.z2 - fmMain.frLtClip.ClipBox.z1 + 1;
 SetLength(Result.Map, Result.X, Result.Y, Result.Z);
 for c:= 0 to Result.Z - 1 do
   for b:= 0 to Result.Y - 1 do
     for a:= 0 to Result.X - 1 do begin
       x:= ((c + fmMain.frLtClip.ClipBox.z1) * Lt.Y
           + b + fmMain.frLtClip.ClipBox.y1) * Lt.X
           + a + fmMain.frLtClip.ClipBox.x1;
       Result.Map[a,b,c].Idx.Lt:= Id;
       Result.Map[a,b,c].Idx.Brk:= Byte(x);
       Result.Map[a,b,c].BrkNr:= Lt.Map[x].Index;
       Result.Map[a,b,c].Shape:= Lt.Map[x].Shape;
       SetFrameOpts(Result.Map[a,b,c], LBAMode = 2);
     end;
end;

function CopyPiece(Map: TComplexMap; x, y, z: Integer; dx, dy, dz: Word;
  InvOnly: Boolean = False): TMapPiece;
var a, b, c: Integer;
begin
 Result.X:= Min(dx, Map.X - x);
 Result.Y:= Min(dy, Map.Y - y);
 Result.Z:= Min(dz, Map.Z - z);
 SetLength(Result.Map, Result.X, Result.Y, Result.Z);
 for a:= Max(0, -x) to Result.X - 1 do
   for b:= Max(0, -y) to Result.Y - 1 do
     for c:= Max(0, -z) to Result.Z - 1 do
       if InvOnly and (foNormal in Map.M^[a+x,b+y,c+z].Frame) then
         Result.Map[a,b,c]:= EmptyMapItem
       else
         Result.Map[a,b,c]:= Map.M^[a+x, b+y, c+z];
end;

procedure PutPiece(var Map: TComplexMap; x, y, z: Integer; Fr: TMapPiece;
  Transparent: Boolean = True);
var a, b, c, ma, mb, mc: Integer;
begin
 ma:= Min(Fr.X, Map.X - x) - 1;
 mb:= Min(Fr.Y, Map.Y - y) - 1;
 mc:= Min(Fr.Z, Map.Z - z) - 1;
 for a:= Max(0, -x) to ma do
   for b:= Max(0, -y) to mb do
     for c:= Max(0, -z) to mc do
       If not Transparent or (foSelect in Fr.Map[a,b,c].Frame) then
         Map.M^[a+x,b+y,c+z]:= Fr.Map[a,b,c];
 for a:= Max(0, -x) to ma do
   for b:= Max(0, -y) to mb do
     for c:= Max(0, -z) to mc do
       SetFrameLines(Map, a+x, b+y, c+z);
 UpdateThumbnail(x, y, z, x+Fr.X, y+Fr.Y, z+Fr.Z);
end;

Procedure DelPiece(var Map: TComplexMap; x, y, z, dx, dy, dz: Integer); overload;
var a, b, c: Integer;
begin
 For a:= Max(x,0) to Min(x+dx, GHiX) do
   for b:= Max(y,0) to Min(y+dy, GHiY) do
     for c:= Max(z,0) to Min(z+dz, GHiZ) do
       If not ((GridTool = gtInvisi) and (foNormal in Map.M^[a,b,c].Frame)) then
         Map.M^[a,b,c]:= EmptyMapItem;
 UpdateThumbnail(x, y, z, x+dx, y+dy, z+dz);
end;

Procedure DelPiece(var Map: TComplexMap; Range: TBox); overload;
var a, b, c: Integer;
begin
 MapCreateUndo(Map);
 for a:= Max(Range.x1, 0) to Min(Range.x2, GHiX) do
   for b:= Max(Range.y1, 0) to Min(Range.y2, GHiY) do
     for c:= Max(Range.z1, 0) to Min(Range.z2, GHiZ) do
       If not ((GridTool = gtInvisi) and (foNormal in Map.M^[a,b,c].Frame)) then
         Map.M^[a,b,c]:= EmptyMapItem;
 UpdateThumbnail(Range.x1, Range.y1, Range.z1, Range.x2, Range.y2, Range.z2);
end;

function CreateNewMap(UpdateEnv: Boolean): Integer;
var a, ml: Integer;
begin
 ml:= Length(LdMaps);
 try
   SetLength(LdMaps, ml + 1);
 except
   on EOutOfMemory do
     ErrorMsg('Failed to create new Map: Out of memory!');
   else
     ErrorMsg('Failed to create new Map!');
   Result:= -1;
   SetLength(LdMaps, ml);
   Exit;
 end;

 LdMaps[ml].IsMainMap:= ml = 0;
 if LdMaps[ml].IsMainMap then LdMaps[ml].Name:= 'Main_Grid'
                         else LdMaps[ml].Name:= 'Fragment_' + IntToStr(MapCounter);
 Inc(MapCounter);

 //After SetLength() the LdMaps array might have been moved to another memory block,
 //  so it is necessary to fix the internal pointers (M):
 for a:= 0 to ml do
   LdMaps[a].M:= @LdMaps[a].States[LdMaps[a].Id];

 if UpdateEnv then begin
   fmMain.RefreshMapList();
   fmMain.UpdateProgramName();
 end;
 Result:= ml;
end;

procedure CloseMap(Index: Integer);
var a: Integer;
begin
 if (Index > 0) and (Index <= High(LdMaps)) then begin
   for a:= Index to High(LdMaps) - 1 do
     LdMaps[a]:= LdMaps[a + 1];
   SetLength(LdMaps, Length(LdMaps) - 1);
   //After SetLength() the LdMaps array might have been moved to another memory block,
   //  so it is necessary to fix the internal pointers (M):
   for a:= 0 to High(LdMaps) do
     LdMaps[a].M:= @LdMaps[a].States[LdMaps[a].Id];
   fmMain.RefreshMapList();
   SetScenarioModified();
   fmMain.UpdateProgramName();
 end;
end;

function CopyGridMap(Src: TGridMap): TGridMap;
var a, b: Integer;
begin
 Result:= Copy(Src);
 for a:= 0 to High(Src) do begin
   Result[a]:= Copy(Src[a]);
   for b:= 0 to High(Src[a]) do
     Result[a,b]:= Copy(Src[a, b]);
 end;
end;

procedure MapCreateUndo(var Map: TComplexMap);
var a: Integer;
begin
 If Map.Id < GUndoLevels then begin
   Inc(Map.Id);
   Map.M:= @Map.States[Map.Id];
 end else begin
   for a:= 0 to GUndoLevels - 1 do
     Map.States[a]:= Map.States[a+1];
   Map.Id:= GUndoLevels; //Just in case
 end;

 Map.Max:= Map.Id;
 Map.States[Map.Id]:= CopyGridMap(Map.States[Map.Id - 1]);
 fmMain.GridUndoSetButtons();
end;

procedure MapDoUndo(var Map: TComplexMap);
begin
 if Map.Id > 0 then Dec(Map.Id);
 Map.M:= @Map.States[Map.Id];
 Map.Modified:= True;
end;

procedure MapDoRedo(var Map: TComplexMap);
begin
 if Map.Id < Map.Max then Inc(Map.Id);
 Map.M:= @Map.States[Map.Id];
 Map.Modified:= True;
end;

procedure SelectMap(Index: Integer);
begin
 ResetControls(False);
 if Index >= 0 then begin
   CMap:= @LdMaps[Index];
   UpdateCurrentMapEnvironment();
 end else
   CMap:= nil;
 fmMain.UpdateFileMenu();  
 fmMain.GridUndoSetButtons();
 DrawMapA();
 UpdateThumbBack(True);
 fmMain.aCloseFrag.Enabled:= Index > 0;
end;

end.
