unit Libraries;

interface

uses Windows, Classes, SysUtils, DePack;

{Physical Shapes:
  00: empty (NOT USED)
  01: solid
  02: stairs (top left on the ground)
  03: stairs (top right on the ground)
  04: stairs (bottom left on the ground)
  05: stairs (bottom right on the ground)
  06: stairs-point (top on the ground)
  07: stairs-point (bottom on the ground)
  08: stairs-point (left on the ground)
  09: stairs-point (right on the ground)
  0A: stairs-edge (top on the ground)
  0B: stairs-edge (bottom on the ground)
  0C: stairs-edge (left on the ground)
  0D: stairs-edge (right on the ground)
  0E: ground plane only (NOT USED)}

type
 TElement = record
  Shape, Sound: byte;
  Index: WORD;
 end;

 TLayout = record
  Offset: DWORD;
  X, Y, Z: Byte;
  Map: array of TElement;
 end;

 TCubeLt = record
  Offset: DWORD;
  X, Y, Z: Byte;
  Map: array of array of array of TElement;
 end;

 TLibrary = array of TLayout;
 TCubeLib = array of TCubeLt;

Function LoadLibraryFromStream(data: TStream): TLibrary;
Function LoadLibraryFromStream2(data: TStream): TLibrary;
Function LoadLibraryFromString2(data: String): TLibrary;
Function LibToCubeLib(Lib: TLibrary): TCubeLib;
Function GetLtWidth(Lt: TLayout): Integer; overload;
Function GetLtWidth(Lt: TCubeLt): Integer; overload;
Function GetLtWidth(x, y, z: Byte): Integer; overload;
Function GetLtHeight(Lt: TLayout): Integer; overload;
Function GetLtHeight(Lt: TCubeLt): Integer; overload;
Function GetLtHeight(x, y, z: Byte): Integer; overload;
Function ReadLayoutS(FLt: TStream): TCubeLt;
Function ReadLayoutF(path: String): TCubeLt;
function LibraryToString(ALib: TCubeLib): String; overload;
function LibraryToString(ALib: TLibrary): String; overload;
function LayoutToString(Lt: TCubeLt): String;
Procedure WriteLayoutF(path: String; Lt: TCubeLt);
function CopyLayout(Src: TCubeLt): TCubeLt;
function CopyLibrary(Src: TCubeLib): TCubeLib;

implementation

//loads with empty Layout at the beginning (real Layouts start with index 1)
Function LoadLibraryFromStream(data: TStream): TLibrary;
var a, b: Integer;
begin
 with data do begin
  Seek(0,soBeginning);
  SetLength(Result,2);
  Result[0].X:=1;
  Result[0].Y:=2;
  Result[0].Z:=1;
  SetLength(Result[0].Map,2);
  Read(Result[1].Offset,4);
  SetLength(Result,(Result[1].Offset div 4)+1);
  for a:=2 to High(Result) do
   Read(Result[a].Offset,4);
  for a:=1 to High(Result) do begin
   Read(Result[a].X,1);
   Read(Result[a].Y,1);
   Read(Result[a].Z,1);
   SetLength(Result[a].Map,Result[a].X*Result[a].Y*Result[a].Z);
   for b:=0 to Result[a].X*Result[a].Y*Result[a].Z-1 do begin
    Read(Result[a].Map[b].Shape,1);
    Read(Result[a].Map[b].Sound,1);
    Read(Result[a].Map[b].Index,2);
   end;
  end;
 end;
end;

//Regular (Layouts start with index 0)
Function LoadLibraryFromStream2(data: TStream): TLibrary;
var a, b: Integer;
begin
 with data do begin
  Seek(0,soBeginning);
  SetLength(Result,1);
  Read(Result[0].Offset,4);
  SetLength(Result,(Result[0].Offset div 4));
  for a:=1 to High(Result) do
   Read(Result[a].Offset,4);
  for a:=0 to High(Result) do begin
   Read(Result[a].X,1);
   Read(Result[a].Y,1);
   Read(Result[a].Z,1);
   SetLength(Result[a].Map,Result[a].X*Result[a].Y*Result[a].Z);
   for b:=0 to Result[a].X*Result[a].Y*Result[a].Z-1 do begin
    Read(Result[a].Map[b].Shape,1);
    Read(Result[a].Map[b].Sound,1);
    Read(Result[a].Map[b].Index,2);
   end;
  end;
 end;
end;

Function LoadLibraryFromString2(data: String): TLibrary;
var DStr: TStringStream;
begin
 DStr:= TStringStream.Create(data);
 Result:= LoadLibraryFromStream2(DStr);
 DStr.Free;
end;

Function LtToCubeLt(Lt: TLayout): TCubeLt;
var a, b, c: Integer;
begin
 Result.Offset:= Lt.Offset;
 Result.X:= Lt.X;
 Result.Y:= Lt.Y;
 Result.Z:= Lt.Z;
 SetLength(Result.Map,Lt.X,Lt.Y,Lt.Z);
 for c:= 0 to Lt.Z - 1 do
  for b:= 0 to Lt.Y - 1 do
   for a:= 0 to Lt.X - 1 do
    Result.Map[a,b,c]:= Lt.Map[a + b*Lt.X + c*Lt.Y*Lt.X];
end;

Function LibToCubeLib(Lib: TLibrary): TCubeLib;
var a: Integer;
begin
 SetLength(Result,Length(Lib));
 for a:=0 to High(Result) do
  Result[a]:= LtToCubeLt(Lib[a]);
end;

Function GetLtWidth(Lt: TLayout): Integer; overload;
begin
 Result:=(Lt.X+Lt.Z)*24;
end;

Function GetLtWidth(Lt: TCubeLt): Integer; overload;
begin
 Result:=(Lt.X+Lt.Z)*24;
end;

Function GetLtWidth(x, y, z: Byte): Integer; overload;
begin
 Result:=(x+z)*24;
end;

Function GetLtHeight(Lt: TLayout): Integer; overload;
begin
 Result:=Lt.Y*15+(Lt.X+Lt.Z)*12-1;
end;

Function GetLtHeight(Lt: TCubeLt): Integer; overload;
begin
 Result:=Lt.Y*15+(Lt.X+Lt.Z)*12-1;
end;

Function GetLtHeight(x, y, z: Byte): Integer; overload;
begin
 Result:=y*15+(x+z)*12-1;
end;

Function ReadLayoutS(FLt: TStream): TCubeLt;
var a, b, c: Integer;
begin
 FLt.Seek(0,soBeginning);
 FLt.Read(Result.X,1);
 FLt.Read(Result.Y,1);
 FLt.Read(Result.Z,1);
 SetLength(Result.Map,Result.X,Result.Y,Result.Z);
 for c:=0 to Result.Z-1 do
  for b:=0 to Result.Y-1 do
   for a:=0 to Result.X-1 do begin
    FLt.Read(Result.Map[a,b,c].Shape,1);
    FLt.Read(Result.Map[a,b,c].Sound,1);
    FLt.Read(Result.Map[a,b,c].Index,2);
   end;
 Result.Offset:=0;
end;

Function ReadLayoutF(path: String): TCubeLt;
var fs: TFileStream;
begin
 fs:= TFileStream.Create(path,fmOpenRead);
 Result:= ReadLayoutS(fs);
end;

function LayoutToString(Lt: TCubeLt): String;
var a, b, c: Integer;
begin
 Result:=Char(Lt.X)+Char(Lt.Y)+Char(Lt.Z);
 for c:=0 to Lt.Z-1 do
  for b:=0 to Lt.Y-1 do
   for a:=0 to Lt.X-1 do begin
    Result:=Result+Char(Lt.Map[a,b,c].Shape)+Char(Lt.Map[a,b,c].Sound);
    Result:=Result+Char(Lo(Lt.Map[a,b,c].Index))+Char(Hi(Lt.Map[a,b,c].Index));
   end;
end;

function LayoutLength(Lt: TCubeLt): Cardinal; overload;
begin
 Result:= 3 + Lt.X * Lt.Y * Lt.Z * 4;
end;

function LayoutLength(Lt: TLayout): Cardinal; overload;
begin
 Result:= 3 + Lt.X * Lt.Y * Lt.Z * 4;
end;

function LibraryToString(ALib: TCubeLib): String; overload;
var a, b, c, d: Integer;
begin
 Result:= '';
 If Length(ALib) < 1 then Exit;
 ALib[0].Offset:= Length(ALib) * 4;
 for a:= 1 to High(ALib) do
  ALib[a].Offset:= ALib[a-1].Offset + LayoutLength(ALib[a-1]);

 for a:= 0 to High(ALib) do
  Result:= Result + GetStrInt(ALib[a].Offset);

 for a:= 0 to High(ALib) do begin
  Result:= Result+Char(ALib[a].X) + Char(ALib[a].Y) + Char(ALib[a].Z);
  for d:= 0 to ALib[a].Z - 1 do
   for c:= 0 to ALib[a].Y - 1 do
    for b:= 0 to ALib[a].X - 1 do
     Result:= Result + Char(ALib[a].Map[b,c,d].Shape)
            + Char(ALib[a].Map[b,c,d].Sound) + GetStrWord(ALib[a].Map[b,c,d].Index);
 end;
end;

function LibraryToString(ALib: TLibrary): String; overload;
var a, b: Integer;
begin
 Result:= '';
 If Length(ALib) < 1 then Exit;
 ALib[0].Offset:= Length(ALib) * 4;
 for a:= 1 to High(ALib) do
  ALib[a].Offset:= ALib[a-1].Offset + LayoutLength(ALib[a-1]);

 for a:= 0 to High(ALib) do
  Result:= Result + GetStrInt(ALib[a].Offset);

 for a:= 0 to High(ALib) do begin
  Result:= Result+Char(ALib[a].X) + Char(ALib[a].Y) + Char(ALib[a].Z);
  for b:= 0 to ALib[a].X*ALib[a].Y*ALib[a].Z - 1 do
   Result:= Result + Char(ALib[a].Map[b].Shape)
          + Char(ALib[a].Map[b].Sound) + GetStrWord(ALib[a].Map[b].Index);
 end;
end;

Procedure WriteLayoutF(path: String; Lt: TCubeLt);
var S: String;
    f: File;
begin
 AssignFile(f,path);
 FileMode:= fmOpenWrite;
 Rewrite(f,1);
 s:= LayoutToString(Lt);
 BlockWrite(f,s[1],Length(s));
 CloseFile(f);
end;

function CopyLayout(Src: TCubeLt): TCubeLt; overload;
var a, b, c: Integer;
begin
 Result.Offset:= Src.Offset;
 Result.X:= Src.X;
 Result.Y:= Src.Y;
 Result.Z:= Src.Z;
 SetLength(Result.Map, Result.X, Result.Y, Result.Z);
 for c:= 0 to Result.Z - 1 do
  for b:= 0 to Result.Y - 1 do
   for a:= 0 to Result.X - 1 do
    Result.Map[a,b,c]:= Src.Map[a,b,c];
end;

function CopyLibrary(Src: TCubeLib): TCubeLib;
var a: Integer;
begin
 SetLength(Result,Length(Src));
 for a:= 0 to High(Src) do
  Result[a]:= CopyLayout(Src[a]);
end;

end.
