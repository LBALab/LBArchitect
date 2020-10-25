unit Scenario;

interface

uses DePack, Classes, SysUtils;

const BaseScenarioLen = 11;
      ScInfoEntry = 0;
      ScDescEntry = 1;
      ScLibraryEntry = 2;
      ScGridEntry = 3;
      ScPaletteEntry = 4;
      ScMapNamesEntry = 5;
      ScFragAssocEntry = 6;
      ScSceneTxtEntry = 7;
      ScSceneBinEntry = 8;

type
 THQSInfo = record
   Lba2: Boolean;
   InfoText: String;
   Version: Word; //HQS version, not LBA version :)
   FirstFragment, FragmentCount: Word;
   FirstBrick: Word;
   BrickCount: Cardinal;
 end;
 //Highest version for now is 2

 TFragIndexInfo = array of Cardinal; //Array of Binary Scene offsets

 TScenarioInfo = record
   HQSInfo: THQSInfo;
   HasGrid: Boolean;
   HasLibrary: Boolean;
   HasBinScene: Boolean;
   MapNames: array of String;
   FragData: array of TFragIndexInfo;
 end;

Function ScenarioIsLba1(sc: TPackEntries): Boolean;

//Returns True if the Scenario contains specified Map
//  (0 = Main Grid, 1 = first Fragment, and so on)
function ScenarioHasMap(sc: TPackEntries; Id: Integer): Boolean;

//function ScenarioHasLibBrk(sc: TPackEntries): Boolean;
//function ScenarioHasScene(sc: TPackEntries): Boolean;

//May return False if the pack file is not Scenario
function ReadScenarioInfo(sc: TPackEntries; out Info: TScenarioInfo): Boolean; overload;
function ReadScenarioInfo(path: String; out Info: TScenarioInfo): Boolean; overload;

//Index = 0 means the Main Grid, 1 = first Fragment and so on.
function GetScenarioMap(sc: TPackEntries; Index: Integer; out MapData: String): Boolean;

implementation

uses Utils;

Function ScenarioIsLba1(sc: TPackEntries): Boolean;
begin
 UnpackSelf(sc[ScInfoEntry]);
 Result:= Byte(sc[ScInfoEntry].Data[1]) = 1;
end;

function ScenarioHasMap(sc: TPackEntries; Id: Integer): Boolean;
var temp: String;
    dl: Integer;
    v: Word;
begin
 if Id = 0 then
   Result:= (High(sc) >= ScGridEntry) and (sc[ScGridEntry].FType = -1)
 else begin
   Result:= False;
   temp:= UnpackToString(sc[ScInfoEntry]);
   dl:= Length(temp);
   if dl >= 258 then v:= ReadWordFromBinStr(temp, 257)
   else if dl = 257 then v:= Byte(temp[257])
                    else v:= 0;
   if v >= 2 then begin
     //Info.HQSInfo.FirstFragment:= ReadWordFromBinStr(temp, $102 + 1);
     Result:= (Length(temp) >= $104 + 2)
          and (Id < ReadWordFromBinStr(temp, $104 + 1)); //FragmentCount
   end;
   //else Result:= False;
 end;
end;

//May return False if the pack file is not Scenario
function ReadScenarioInfo(sc: TPackEntries; out Info: TScenarioInfo): Boolean;
var temp: String;
    slist: TStringList;
    a, b, dl, sl: Integer;
    binlen: Cardinal;
begin
 Result:= False;
 sl:= Length(sc);
 if sl < BaseScenarioLen then Exit; //Too few entries
 if sc[ScInfoEntry].FType <> -1 then Exit;
 Info.HasGrid:= sc[ScGridEntry].FType = -1;
 Info.HasLibrary:= sc[ScLibraryEntry].FType = -1;
 Info.HasBinScene:= sc[ScSceneBinEntry].FType = -1;
 temp:= UnpackToString(sc[ScInfoEntry]);
 dl:= Length(temp);
 if dl < 256 then Exit; //first entry too short (not even version 1)
 Info.HQSInfo.Lba2:= temp[1] = #2;
 Info.HQSInfo.InfoText:= Trim(Copy(temp, 2, 255));
 if dl >= 258 then Info.HQSInfo.Version:= ReadWordFromBinStr(temp, 257)
 else if dl = 257 then Info.HQSInfo.Version:= Byte(temp[257]);
 if Info.HQSInfo.Version >= 2 then begin
   if dl < $10C then Exit; //Too short for version 2
   Info.HQSInfo.FirstFragment:= ReadWordFromBinStr(temp, $102 + 1);
   Info.HQSInfo.FragmentCount:= ReadWordFromBinStr(temp, $104 + 1);
   Info.HQSInfo.FirstBrick:= ReadWordFromBinStr(temp, $106 + 1);
   Info.HQSInfo.BrickCount:= ReadUIntFromBinStr(temp, $108 + 1);
   //Check integrity:
   if ((Info.HQSInfo.FirstFragment > 0)
     and ((Info.HQSInfo.FirstFragment <= 10) //10 and below are reserved
       or (Info.HQSInfo.FirstFragment + Info.HQSInfo.FragmentCount > sl)
       or ((Info.HQSInfo.FirstBrick > 0)
           and (Info.HQSInfo.FirstFragment + Info.HQSInfo.FragmentCount > Info.HQSInfo.FirstBrick))))
     or ((Info.HQSInfo.FirstBrick > 0)
     and ((Info.HQSInfo.FirstBrick <= 10)
       or (Info.HQSInfo.FirstBrick + Info.HQSInfo.BrickCount > sl))) then Exit; //Scenario corrupted
 end
 else begin
   Info.HQSInfo.FirstFragment:= 0;
   Info.HQSInfo.FragmentCount:= 0;
   Info.HQSInfo.FirstBrick:= 20;
   Info.HQSInfo.BrickCount:= sl - 20;
 end;

 if sc[ScMapNamesEntry].FType <> -1 then Exit;
 temp:= UnpackToString(sc[ScMapNamesEntry]);
 slist:= TStringList.Create();
 slist.Text:= temp;
 SetLength(Info.MapNames, slist.Count);
 for a:= 0 to slist.Count - 1 do
   Info.MapNames[a]:= slist[a];
 FreeAndNil(slist);

 if sc[ScFragAssocEntry].FType <> -1 then Exit;
 SetLength(Info.FragData, Info.HQSInfo.FragmentCount);
 temp:= UnpackToString(sc[ScFragAssocEntry]);
 a:= 1;
 while a <= Length(temp) - 4 do begin
   b:= Byte(temp[a]); //Fragment no.
   if b <= High(Info.FragData) then begin
     SetLength(Info.FragData[b], Length(Info.FragData[b]) + 1);
     Info.FragData[b, High(Info.FragData[b])]:= ReadUIntFromBinStr(temp, a + 1); //Offset
   end;
   Inc(a, 5);
 end;
 //Now check the Offset consistency:
 if Info.HasBinScene then begin //otherwise Scenario is unusable anyway (but not corrupted, return True)
   binlen:= sc[ScSceneBinEntry].RlSize;
   for a:= 0 to High(Info.FragData) do
     for b:= 0 to High(Info.FragData[a]) do
       if Info.FragData[a, b] >= binlen then Exit; //Offset is out of the binary Scene
 end;

 Result:= True;
end;

function ReadScenarioInfo(path: String; out Info: TScenarioInfo): Boolean;
var temp: TPackEntries;
begin
 Result:= OpenPack(path, temp) and ReadScenarioInfo(temp, Info);
end;

function GetScenarioMap(sc: TPackEntries; Index: Integer; out MapData: String): Boolean;
var Info: TScenarioInfo;
begin
 Result:= False;
 if ReadScenarioInfo(sc, Info) then begin
   if Index = 0 then begin
     if (sc[ScGridEntry].FType = -1) then begin
       MapData:= UnpackToString(sc[ScGridEntry]);
       Result:= True;
     end;
   end
   else if Index <= Info.HQSInfo.FragmentCount then begin
     MapData:= UnpackToString(sc[Info.HQSInfo.FirstFragment + Index - 1]);
     Result:= True;
   end;  
 end;
end;

end.
