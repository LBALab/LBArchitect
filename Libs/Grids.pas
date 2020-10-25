unit Grids;

interface

uses SysUtils, Engine, DePack, Forms, Controls, StdCtrls, Windows, Classes, ProgBar,
     Math, Libraries, Utils, Maps;

type
 TGridObj = record
   Flags: Byte;
   Blocks: array of TBlockIndex;
 end;

 TCell = record
   Offset: WORD;
   Repeated: Boolean;
   ObjCount: Byte;
   Objects: array of TGridObj;
 end;

 TGrid = record
   Lba2: Boolean;
   LibIndex: Byte;
   FragIndex: Byte;
   LibUsage: array[0..31] of Byte;
   Cells: array of TCell;
 end;

 TFragment = record
   X, Y, Z: Byte;
   LibIndex: Byte;
   Blocks: array of array of array of TBlockIndex;
 end;

function SaveGrid(var Map: TComplexMap; CollectLibUsage: Boolean;
  path: String; Index: Integer = -1): Boolean;
//function GridToString(Grid: TGrid): String;
Procedure FindTransparentBrick();
Procedure FindLba2Invisible(Lib: TLibrary);
//procedure SetAllFrameLines();
//Function MapToGrid(): TGrid;
//Function MapToFragment(): TFragment;

//procedure CreateFragment();

implementation

uses Open, Rendering, Main, Hints, Settings, OpenSim, Clipping, Bricks,
     Scenario, Globals, CompDialog;

{Function LoadGridFromStream(data: TStream; Lba2: Boolean): TGrid;
var a, b, c, BlockCount: Integer;
    d: Byte;
begin
 with data do begin
   SetLength(Result.Cells, 64*64);
   If Lba2 then begin
     Result.Lba2:= True;
     Seek(0, soBeginning);
     Read(Result.LibIndex, 1);
     Read(Result.FragIndex, 1);
     d:= 34;
   end
   else d:= 0;
   Seek(d, soBeginning);
   for a:= 0 to 64*64 - 1 do
     Read(Result.Cells[a].Offset, 2);
   for a:= 0 to 64*64 - 1 do begin
     Seek(Result.Cells[a].Offset+d, soBeginning);
     Read(Result.Cells[a].ObjCount, 1);
     SetLength(Result.Cells[a].Objects, Result.Cells[a].ObjCount);
     for b:= 0 to High(Result.Cells[a].Objects) do begin
       Read(Result.Cells[a].Objects[b].Flags, 1);
       BlockCount:= (Result.Cells[a].Objects[b].Flags and $1F) + 1;
       case (Result.Cells[a].Objects[b].Flags and $E0) of
         $00: SetLength(Result.Cells[a].Objects[b].Blocks, 0);
         $40: begin
                SetLength(Result.Cells[a].Objects[b].Blocks, BlockCount);
                for c:= 0 to BlockCount-1 do begin
                  Read(Result.Cells[a].Objects[b].Blocks[c].Lt, 1);
                  Read(Result.Cells[a].Objects[b].Blocks[c].Brk, 1);
                end;
              end;
         $80: begin
                SetLength(Result.Cells[a].Objects[b].Blocks, 1);
                Read(Result.Cells[a].Objects[b].Blocks[0].Lt, 1);
                Read(Result.Cells[a].Objects[b].Blocks[0].Brk, 1);
              end;
       end;
     end;
   end;
 end;
end;  }

function SaveGrid(var Map: TComplexMap; CollectLibUsage: Boolean;
  path: String; Index: Integer = -1): Boolean;
var ext: String;
    VPack: TPackEntries;
    NewComp: Word;
    Lba: Byte;
    FLibUsage: TGridLibUsage;
    FPLU: PGridLibUsage;
begin
 Result:= False;
 Screen.Cursor:= crHourGlass;

 if CollectLibUsage and (Length(LdMaps) > 0) then begin
   FLibUsage:= GetAllMapsLibUsage();
   FPLU:= @FLibUsage;
 end else
   FPLU:= nil;
 
 ext:= LowerCase(ExtractFileExt(path));
 If (ext = '.gr1') or (ext = '.gr2') then begin
   Lba:= IfThen(ext = '.gr2', 2, 1);
   Result:= SaveStringToFile(MapToGridString(Map, Lba = 2, FPLU, GLibIndex, GFragIndex), path);
 end
 else if ext = '.grf' then begin
   Result:= SaveStringToFile(MapToFragmentString(Map), path);
 end
 else if ext = '.hqr' then begin
   If Map.IsGrid then Lba:= IfThen(IsBkg(path), 2, 1)
                 else Lba:= 2;
   VPack:= OpenPack(path);
   NewComp:= Map.Compression;
   If not TfmCompDlg.ShowDialog(Lba = 2, NewComp, Map.Name) then begin
     Screen.Cursor:= crDefault;
     Exit;
   end;
   If Map.IsGrid then
     VPack[Index]:= PackEntry(MapToGridString(Map, Lba = 2, FPLU, GLibIndex, GFragIndex), -1, NewComp)
   else
     VPack[Index]:= PackEntry(MapToFragmentString(Map), -1, NewComp);
   If IsBkg(path) then BkgHeadFix(VPack, -1, -1, -1, -1, -1);
   Map.Compression:= NewComp;
   Result:= SavePackToFile(VPack, path);
 end
 else Exit;
 Map.Modified:= False;
 Map.FilePath:= path;
 Map.FileIndex:= Index;
 SetScenarioState(False);
 fmMain.UpdateProgramName();
 Screen.Cursor:= crDefault;
 SysUtils.Beep();
 PutMessage(Map.Name + ' successfully saved');
 Sett.General.LastSaveDir:= ExtractFilePath(path);
end;

{function GridToString(Grid: TGrid): String;
var a, b, c: Integer;
    s: ShortString;
begin
 Result:='';
 s:='';
 for a:= 0 to 31 do s:= s + Char(Grid.LibUsage[a]);
 for a:= 0 to 64*64-1 do
  Result:= Result + GetStrWord(Grid.Cells[a].Offset);
 for a:= 0 to 64*64-1 do begin
  If Grid.Cells[a].Repeated then Continue;
  Result:= Result + Char(Grid.Cells[a].ObjCount);
  for b:= 0 to High(Grid.Cells[a].Objects) do begin
   Result:= Result + Char(Grid.Cells[a].Objects[b].Flags);
   for c:= 0 to High(Grid.Cells[a].Objects[b].Blocks) do begin
    Result:= Result + Char(Grid.Cells[a].Objects[b].Blocks[c].Lt);
    Result:= Result + Char(Grid.Cells[a].Objects[b].Blocks[c].Brk);
   end;
  end;
 end;
 If Grid.Lba2 then Result:= Char(Grid.LibIndex) + Char(Grid.FragIndex) + s + Result
 else Result:= Result + s;
end;}

{Function FragToString(Frag: TFragment): String;
var a, b, c: Integer;
begin
 Result:= Char(Frag.X) + Char(Frag.Y) + Char(Frag.Z);
 for c:= 0 to Frag.Z - 1 do
  for a:= 0 to Frag.X - 1 do
   for b:= 0 to Frag.Y - 1 do
    Result:= Result + Char(Frag.Blocks[a,b,c].Lt) + Char(Frag.Blocks[a,b,c].Brk);
end;}

Procedure FindTransparentBrick();
var a: Integer;
begin
 TransparentBrick:= 0;
 for a:= 0 to High(PkBricks) do
   If BrickIsEmpty(a) then begin
     TransparentBrick:= a;
     Exit;
   end;
end;

Procedure FindLba2Invisible(Lib: TLibrary);
var a, b, lt, brk: Integer;
begin
 lt:= -1;
 brk:= -1;
 for a:= 0 to High(Lib) do
   If Lib[a].Map[0].Index = TransparentBrick then Break;
 If a <= High(Lib) then begin
   Lba2Invisible.Idx.Lt:= a;
   Lba2Invisible.Idx.Brk:= 0;
   Lba2Invisible.BrkNr:= TransparentBrick;
   Lba2Invisible.Frame:= [foSelect];
   Lba2Invisible.Shape:= 1;
 end
 else begin
   for a:= 0 to High(Lib) do begin
     for b:= 0 to High(Lib[a].Map) do
       if Lib[a].Map[b].Index = TransparentBrick then begin
         lt:= a;
         brk:= b;
         Break;
       end;
     if lt >= 0 then Break;
   end;
   if (lt <= High(Lib)) and (brk <= High(Lib[lt].Map)) then begin
     Lba2Invisible.Idx.Lt:= lt;
     Lba2Invisible.Idx.Brk:= brk;
     Lba2Invisible.BrkNr:= TransparentBrick;
     Lba2Invisible.Frame:= [foSelect];
     Lba2Invisible.Shape:= 1;
   end
   else lba2Invisible.Idx.Lt:= 0;
 end;
end;

{Function GetOType(x, y, z: Integer): Byte;  //full grids only
begin
 If (MMap[x,y,z].BrkNr = -1) then Result:=$00
 else if (y < 24)
  and (MMap[x,y,z].Idx.Lt  = MMap[x,y+1,z].Idx.Lt)
  and (MMap[x,y,z].Idx.Brk = MMap[x,y+1,z].Idx.Brk) then Result:= $80
 else if (y > 0)
  and (MMap[x,y,z].Idx.Lt  = MMap[x,y-1,z].Idx.Lt)
  and (MMap[x,y,z].Idx.Brk = MMap[x,y-1,z].Idx.Brk) then Result:= $80
 else Result:= $40;
end;

Function OTypeUpdate(x, y, z: Integer): Boolean;
begin
 Result:= (y > 0)
      and ((MMap[x,y,z].Idx.Lt  <> MMap[x,y-1,z].Idx.Lt)
        or (MMap[x,y,z].Idx.Brk <> MMap[x,y-1,z].Idx.Brk));
end;

Function FindSameCell(Nr: Integer): Integer;  //full grids only
var a, b: Integer;
begin
 Result:= -1;
 for a:= 0 to Nr-1 do begin
   for b:= 0 to 24 do
     If (MMap[a mod 64,b,a div 64].Idx.Lt <> MMap[Nr mod 64,b,Nr div 64].Idx.Lt)
     or (MMap[a mod 64,b,a div 64].Idx.Brk <> MMap[Nr mod 64,b,Nr div 64].Idx.Brk) then Break;
   If b < 25 then Continue;
   Result:= a;
   Exit;
 end;
end;

Procedure MakeLibUsage(var Target: TGrid);   //full grids only
var a, b, c: Integer;
    Lt: Byte;
begin
 for a:= 0 to 31 do
   Target.LibUsage[a]:= 0;
 if Sett.General.SaveSuperCompat and not Target.Lba2 then
   for a:= 1 to High(VLibrary) do
     Target.LibUsage[a div 8]:= Target.LibUsage[a div 8] or ($80 shr (a mod 8))
 else
   for a:= 0 to 63 do
     for b:= 0 to 24 do
       for c:= 0 to 63 do begin
         Lt:= MMap[a,b,c].Idx.Lt;
         If Lt > 0 then
           Target.LibUsage[Lt div 8]:= Target.LibUsage[Lt div 8] or ($80 shr (Lt mod 8));
       end;
end;}

{Function MapToGrid(): TGrid;      //full grids only
var a, b, c, d, Start, Off: Integer;
    OType, NextOType: Byte; //$00-empty, $40-grouping, $80-repeating
begin
 Result.Lba2:= Grid.Lba2;
 Result.LibIndex:= Grid.LibIndex;
 Result.FragIndex:= Grid.FragIndex;
 MakeLibUsage(Result);
 With Result do begin
  SetLength(Cells,64*64);
  Off:= 8192;
  for c:= 0 to 63 do
   for a:= 0 to 63 do
    With Cells[a+c*64] do begin
     d:= FindSameCell(a+c*64);
     Repeated:= d > -1;
     If Repeated then begin
      Offset:= Cells[d].Offset;
      Continue;
     end;
     Offset:= Off;
     ObjCount:= 0;
     SetLength(Objects,0);
     Start:= 0;
     OType:= GetOType(a,0,c);
     for b:= 1 to 25 do begin
      If b < 25 then NextOType:= GetOType(a,b,c);
      If (NextOType <> OType) or (b = 25) or OTypeUpdate(a,b,c) then begin
       Inc(ObjCount);
       SetLength(Objects,ObjCount);
       case OType of
        $00: begin
              Objects[ObjCount-1].Flags:= b - Start - 1;
              SetLength(Objects[ObjCount-1].Blocks,0);
              Inc(Off,1);
             end;
        $40: begin
              Objects[ObjCount-1].Flags:= $40 or (b - Start - 1);
              SetLength(Objects[ObjCount-1].Blocks,b-Start);
              for d:= Start to b - 1 do
                Objects[ObjCount-1].Blocks[d-Start]:= MMap[a,d,c].Idx;
              Inc(Off, 1 + (b-Start) * 2);
             end;
        $80: begin
              Objects[ObjCount-1].Flags:= $80 or (b - Start - 1);
              SetLength(Objects[ObjCount-1].Blocks,1);
              Objects[ObjCount-1].Blocks[0]:= MMap[a,Start,c].Idx;
              Inc(Off,3);
             end;
       end;
       Start:= b;
       OType:= NextOType;
      end;
     end;
     Inc(Off,1);
    end;
 end;
end;}

{Function MapToFragment: TFragment;
var a, b, c: Integer;
    BlockIdx: TBlockIndex;
begin
 Result.X:= Length(MMap);
 Result.Y:= Length(MMap[0]);
 Result.Z:= Length(MMap[0,0]);
 SetLength(Result.Blocks,Result.X,Result.Y,Result.Z);
 for c:= 0 to Result.Z - 1 do
  for b:= 0 to Result.Y - 1 do
   for a:= 0 to Result.X - 1 do
    Result.Blocks[a,b,c]:= MMap[a,b,c].Idx;
end;}

end.
