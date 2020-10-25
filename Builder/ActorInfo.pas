unit ActorInfo;

interface

uses SysUtils, DePack, Classes, HQDesc, ListForm, Settings, Windows;

type
  TSpriteInfo = record
    OffsetX, OffsetY: Integer;
    MinX, MaxX: Integer;
    MinY, MaxY: Integer;
    MinZ, MaxZ: Integer;
  end;

  //###### by Alexfont ######
  TBodyIndex = record
    VirtualIndex: SmallInt; // virtual index used in scripts
    RealIndex: Integer;    // real index in body entity
    // this structure should have collision box variables
  end;

  TAnimIndex = record
    VirtualIndex: Integer; // virtual index used in scripts
    RealIndex: Integer;    // real index in animation entity
  end;

  TEntity = record
    Bodies: array of TBodyIndex;
    Anims: array of TAnimIndex;
  end;
  //#########################

const
  feBODY = 1;
  feANIM = 3;
  feEND = 255;

var
  SprActInfo: array of TSpriteInfo;
  ActorEntities: array of TEntity;

function LoadSpriteActorsInfo(data: String): Boolean;
//###### Alexfont ######
Function LoadFile3D(path: String; Lba: Byte): Boolean;
//######################
Procedure LoadBodyAnimDesc(BodyPath, AnimPath: String; Lba: Byte);
Procedure GetBodiesAndAnims(Entity: Integer; BodyList, AnimList: TStrings);
Function FindBodyVirtualIndex(Bodies: array of TBodyIndex; VID: Integer): Integer;
Function FindAnimVirtualIndex(Anims: array of TAnimIndex; VID: Integer): Integer;
function RemoveRealIndex(Desc: String): String;
procedure ClearActorInfo();
function AnimName(index: Integer): String;
function BodyName(index: Integer): String;

implementation

uses Scene, SceneLib;

var BodyNames, AnimNames: TStrArray;

function LoadSpriteActorsInfo(data: String): Boolean;
var a: Integer;
begin
 Result:= Length(data) = Length(VSprites) * 16;
 if Result then begin
   SetLength(SprActInfo, Length(VSprites));
   for a:= 0 to High(SprActInfo) do begin
     SprActInfo[a].OffsetX:= ReadStrSmallInt(data, a*16 + 1);
     SprActInfo[a].OffsetY:= ReadStrSmallInt(data, a*16 + 3);
     SprActInfo[a].MinX:= ReadStrSmallInt(data, a*16 + 5);
     SprActInfo[a].MaxX:= ReadStrSmallInt(data, a*16 + 7);
     SprActInfo[a].MinY:= ReadStrSmallInt(data, a*16 + 9);
     SprActInfo[a].MaxY:= ReadStrSmallInt(data, a*16 + 11);
     SprActInfo[a].MinZ:= ReadStrSmallInt(data, a*16 + 13);
     SprActInfo[a].MaxZ:= ReadStrSmallInt(data, a*16 + 15);
   end;
 end;
end;

//###### Alexfont ###### (mod by Zink)
Function OpenEntity(BinaryFile: String; Lba: Byte; var ent: TEntity): Boolean;
var Offset, OpCode, {Tmp1, Tmp2,} bh, ah, Section: Integer;
begin
  Result:= True;
  Offset:= 1;
  //Result.NumOfBodies:= 0;
  //Result.NumOfAnimations:= 0;
  bh:= -1;
  ah:= -1;
  SetLength(ent.Bodies, 50);     //alloc by 50, speeds up memory allocation
  SetLength(ent.Anims, 50);
  repeat
    OpCode:= Byte(BinaryFile[Offset]);
    Inc(Offset);
    //Tmp1:= 0;
    //Tmp2:= 0;
    case OpCode of
      feBODY: begin
        Inc(bh);
        if High(ent.Bodies) < bh then
          SetLength(ent.Bodies, bh + 50);
        ent.Bodies[bh].VirtualIndex:= Byte(BinaryFile[Offset]);
        Inc(Offset, 1);
        Section:= Byte(BinaryFile[Offset]); //length of the section from here (including this byte)
        Inc(Offset, 1);
        ent.Bodies[bh].RealIndex:= ReadStrWord(BinaryFile, Offset);

        Inc(Offset, Section - 1);

        //ignore the bounding box parameters
        //Tmp1:= ReadStrByte(BinaryFile, Offset);
        //Tmp2:= ReadStrByte(BinaryFile, Offset + 1);

        // offsets for collision box (not needed for now)
        //if (Tmp1 = 1) and (Tmp2 = 14) then
        //  Inc(Offset, Tmp2);
      end;

      feANIM: begin
        Inc(ah);
        if High(ent.Anims) < ah then
          SetLength(ent.Anims, ah + 50);
        if Lba = 1 then begin
          ent.Anims[ah].VirtualIndex:= Byte(BinaryFile[Offset]);
          Inc(Offset, 1);
        end
        else begin
          ent.Anims[ah].VirtualIndex:= ReadStrWord(BinaryFile, Offset);
          Inc(Offset, 2);
        end;
        Section:= Byte(BinaryFile[Offset]); //length of the section from here (including this byte)
        Inc(Offset, 1);
        ent.Anims[ah].RealIndex:= ReadStrWord(BinaryFile, Offset);

        Inc(Offset, Section - 1);
      end;

      else begin
        Result:= OpCode = feEND;
       // if OpCode <> feEND then
       //   SysUtils.Beep();
        //Exit;
      end;
    end;
  until OpCode = feEND;
  SetLength(ent.Bodies, bh + 1);
  SetLength(ent.Anims, ah + 1);
end;

Function LoadFile3D(path: String; Lba: Byte): Boolean;
var a, c: Integer;
    VFile3d: TPackEntries;
    VRess44: TPackEntry;
    //FStr: TFileStream;
    EntStr, EntData: String;
    off, offn: DWORD;
begin
  Result:= False;
  if FileExists(path) and ExtIs(path,'.hqr') then begin
    if Lba = 1 then begin
      if OpenPack(path, VFile3d) then begin
        UnpackAll(VFile3d);
        SetLength(ActorEntities, 0); //clear previous content
        SetLength(ActorEntities, Length(VFile3d));
        for a:= 0 to High(VFile3d) do
          if not OpenEntity(VFile3d[a].Data, 1, ActorEntities[a]) then
            Exit;
      end
    end
    else if Lba = 2 then begin
      try
        VRess44:= OpenSingleEntry(path, 44);
      except
        Exit;
      end;
      EntStr:= UnpackToString(VRess44);
      if Length(EntStr) > 4 then begin
        Move(EntStr[1], off, 4); //first offset
        c:= off div 4 - 2; //number of entities
        SetLength(ActorEntities, 0); //clear previous content
        SetLength(ActorEntities, c);
        for a:= 0 to c - 1 do begin
          Move(EntStr[1 + a*4], off, 4); //entity offset
          Move(EntStr[1 + (a+1)*4], offn, 4); //next offset (or file size)
          EntData:= Copy(EntStr, 1 + off, offn - off);
          if not OpenEntity(EntData, 2, ActorEntities[a]) then
            Exit;
        end;
      end else
        Exit;
    end else
      Exit;
    Result:= True;
  end;
  //FStr:= TFileStream.Create(path, fmOpenRead);
  //with FStr do begin
  //  Seek(0, soBeginning);
  //  SetLength(BinaryFile, FStr.Size);
  //  Read(BinaryFile[1], FStr.Size);
  //end;
  //FStr.Free();
  //Result:= OpenEntity(BinaryFile);
end;
//######################

Procedure LoadBodyAnimDesc(BodyPath, AnimPath: String; Lba: Byte);
var DummyIndex: TIndexList;
begin
 BodyNames:= MakeDescriptionList(BodyPath, etBodies, Lba = 1,
               Sett.General.FirstIndex1, True, DummyIndex);
 AnimNames:= MakeDescriptionList(AnimPath, etAnims, Lba = 1,
               Sett.General.FirstIndex1, True, DummyIndex);
end;

//This function inserts given virtual index in parentheses into the object
//  description, after its real index.
function InsertVirtualIndex(Desc: String; VIndex: Integer): String;
var a: integer;
begin
 a:= Pos(':', Desc);
 if a > 0 then
   Insert(' ('+IntToStr(VIndex)+')', Desc, a);
 Result:= Desc;
end;

//This function removes real index prefix from the object description.
//It assumes the description is in form "id: desc" with space between : and the desc.
function RemoveRealIndex(Desc: String): String;
var a: integer;
begin
 a:= Pos(':', Desc);
 if a > 0 then
   Result:= Copy(Desc, a + 2, Length(Desc) - a - 1)
 else
   Result:= Desc;
end;

Procedure GetBodiesAndAnims(Entity: Integer; BodyList, AnimList: TStrings);
var a: Integer;
    ai: TAnimIndex;
    bi: TBodyIndex;
begin
 BodyList.Clear();
 BodyList.Add('Custom');
 AnimList.Clear();
 AnimList.Add('Custom');
 if (Entity >= 0) and (entity <= High(ActorEntities)) then begin
   for a:= 0 to High(ActorEntities[Entity].Bodies) do begin
     bi:= ActorEntities[Entity].Bodies[a];
     BodyList.Add(InsertVirtualIndex(BodyName(bi.RealIndex), bi.VirtualIndex));
   end;
   for a:= 0 to High(ActorEntities[Entity].Anims) do begin
     ai:= ActorEntities[Entity].Anims[a];
     AnimList.Add(InsertVirtualIndex(AnimName(ai.RealIndex), ai.VirtualIndex));
   end;
 end;
end;

//Returns index-in-the-array of the Body with given Virtual ID
//  or returns -1 if there is no such Body
Function FindBodyVirtualIndex(Bodies: array of TBodyIndex; VID: Integer): Integer;
var a: Integer;
begin
 Result:= -1;
 for a:= 0 to High(Bodies) do
   If Bodies[a].VirtualIndex = VID then begin
     Result:= a;
     Exit;
   end;
end;

//Returns index-in-the-array of the Animation with given Virtual ID
//  or returns -1 if there is no such Animation
Function FindAnimVirtualIndex(Anims: array of TAnimIndex; VID: Integer): Integer;
var a: Integer;
begin
 Result:= -1;
 for a:= 0 to High(Anims) do
   If Anims[a].VirtualIndex = VID then begin
     Result:= a;
     Exit;
   end;
end;

procedure ClearActorInfo();
begin
  SetLength(SprActInfo, 0);
  SetLength(ActorEntities, 0);
  SetLength(BodyNames, 0);
  SetLength(AnimNames, 0);
end;

function AnimName(index: Integer): String;
begin
  if index <= High(AnimNames) then
    Result:= AnimNames[index]
  else
    Result:= IntToStr(index) + ': (unknown)';
end;

function BodyName(index: Integer): String;
begin
  if index <= High(BodyNames) then
    Result:= BodyNames[index]
  else
    Result:= IntToStr(index) + ': (unknown)'; 
end;

end.
