unit AddFiles;

//Loading and managing additional files, like Samples.hqr, Text.hqr, etc.

interface

uses SysUtils, Classes;

type TDialogText = record
       Index: Word;
       TType: Byte; //0x01 = Normal text
                    //0x03 = Big frame
                    //0x05 = No frame, big picture
                    //0x09 = No frame, floating text
                    //0x11 = Holomap location
                    //0x21 = Radio text
                    //0x23 = Radio text - big frame
                    //0x41 = Inventory text
                    //0x81 = Demo teaser text
                    //bit 0 = always 1
                    //bit 1 = full screen?
       Text: String;
     end;

procedure LoadSampleDescriptions(path: String; Lba: Byte);
procedure LoadSpriteDescriptions(path: String; Lba: Byte);
procedure LoadInvObjDescriptions(path: String; Lba: Byte);
procedure LoadMovieNames(data: String; Lba: Byte);
function LoadDialogTexts(path: String; Lba: Byte): Boolean;

implementation

uses Globals, ListForm, DePack, Settings, Utils;

procedure LoadSampleDescriptions(path: String; Lba: Byte);
begin
 SampleNames:= MakeDescriptionList(path, etSamples, Lba = 1,
                 Sett.General.FirstIndex1, False, SampleIndexes);
end;

procedure LoadSpriteDescriptions(path: String; Lba: Byte);
begin
 SpriteNames:= MakeDescriptionList(path, etSprites, Lba = 1,
                 Sett.General.FirstIndex1, False, SpriteIndexes);
end;

procedure LoadInvObjDescriptions(path: String; Lba: Byte);
begin
 InvObjNames:= MakeDescriptionList(path, etModels, Lba = 1,
                 Sett.General.FirstIndex1, False, InvObjIndexes);
end;

procedure LoadMovieNames(data: String; Lba: Byte);
var Str: TStringList;
    a: Integer;
begin
 Str:= TStringList.Create();
 Str.NameValueSeparator:= ' ';
 Str.Text:= Trim(data);
 SetLength(MovieNames, Str.Count);
 if Lba = 1 then
   for a:= 0 to Str.Count - 1 do
     MovieNames[a]:= Str.Names[a] + '.fla'
 else
   for a:= 0 to Str.Count - 1 do
     MovieNames[a]:= Str[a];
 FreeAndNil(Str);
end;

function LoadDialogTexts(path: String; Lba: Byte): Boolean;
var Pack: TPackEntries;
    a, b, NumIndexes, NumTexts: Integer;
    IndexTable: TWordDynAr;
    MaxOff: Word;
    Data, Text: String;
begin
 Result:= False;
 SetLength(DialogTexts, 0, 0);
 if OpenPack(path, Pack) then begin
   SetLength(DialogTexts, Length(Pack) div 2); //ignore lone index entry, if exists (erroneously)
   for a:= 0 to High(DialogTexts) do begin
     if (Pack[a*2].FType <> -2) and (Pack[a*2+1].FType <> -2) then begin //skip blank entries (LBA2)
       NumIndexes:= Pack[a*2].RlSize div 2;
       SetLength(IndexTable, NumIndexes);
       Data:= UnpackToString(Pack[a*2]);
       Move(Data[1], IndexTable[0], NumIndexes * 2);
       Data:= UnpackToString(Pack[a*2+1]);
       Move(Data[1], MaxOff, 2);
       NumTexts:= MaxOff div 2 - 1;
       SetLength(DialogTexts[a], NumTexts);
       if NumIndexes >= NumTexts then begin //check if number of indexes matches number of texts (allow more indexes than texts)
         for b:= 0 to NumTexts - 1 do begin
           Move(Data[b*2+1], MaxOff, 2); //offset
           DialogTexts[a,b].Index:= IndexTable[b];
           if Lba = 2 then begin
             DialogTexts[a,b].TType:= Byte(Data[1+MaxOff]);
             Inc(MaxOff);
           end;
           Text:= ExtractCStrFromStr(Data, 1+MaxOff);
           if Length(Text) <= 100 then
             DialogTexts[a,b].Text:= Text
           else
             DialogTexts[a,b].Text:= Copy(Text, 1, 97) + '...';
         end;
       end else //more texts than indexes -> something's wrong
         SetLength(DialogTexts[a], 0);
     end;
   end;
   Result:= True;
 end;
end;

end.
