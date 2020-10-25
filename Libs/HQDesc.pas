unit HQDesc;

interface

uses SysUtils, Forms, DePack, Classes, Math;

type
 TStrArray = array of String;
 TIntArray = array of Integer;

 THQRDesc = record
  Index: Integer;
  Desc: String;
 end;

 THQRDescs = array of THQRDesc;

 THQRInfoItem = record
  Index: Integer;
  Ext: String[3];
  Desc: String;
 end;

 THQRInfo = array of THQRInfoItem;

 THQDHeader = record
  Desc: String;
  Total: Integer;
  Normal: Integer;
  Repeated: Integer;
  Blank: Integer;
  Mask: String;
 end;

const
 InfoDir = 'fileinfo';

function LoadHQRFullInfo(HQRPath: String): THQRInfo;
function LoadHQRDescriptions(HQRPath: String; ext: String; var Descs: THQRDescs;
  var DescMap: TIntArray): Boolean;
function LoadHQREntryDescriptions(HQRPath: String; Entry: Integer; var Descs: THQRDescs;
  var DescMap: TIntArray): Boolean;
function FilterEntriesList(idl: TIndexList; dsc: THQRDescs): TIndexList;

implementation

uses Masks;

function LoadHQD(HQDPath: String; var Header: THQDHeader; var sl: TStringList): Boolean;
begin
 Result:= False;
 try
   sl:= TStringList.Create();
   sl.LoadFromFile(HQDPath);
   if sl.Count >= 6 then begin
     Header.Desc:= sl[0];
     Header.Total:= StrToIntDef(sl[1], -1);
     Header.Normal:= StrToIntDef(sl[2], -1);
     Header.Repeated:= StrToIntDef(sl[3], -1);
     Header.Blank:= StrToIntDef(sl[4], -1);
     Header.Mask:= sl[5];
     try
       MatchesMask(HQDPath, Header.Mask);
     except
       on EMaskException do Header.Mask:= '*';  //make sure the mask is correct
     end;
     Result:= True;
   end;
 except
 end;
end;

function FindMatchingHQDFile(HQRPath: String; Entries: Integer;
  out Header: THQDHeader; var sl: TStringList): Boolean;
var fs: TSearchRec;
    path: String;
begin
 Result:= False;
 if FileExists(ChangeFileExt(HQRPath, '.hqd')) then begin
   LoadHQD(ChangeFileExt(HQRPath, '.hqd'), Header, sl);
   Result:= True;
 end else begin
   path:= ExtractFilePath(Application.ExeName) + InfoDir + '\';
   if FindFirst(path + '*.hqd', faReadOnly + faHidden + faArchive, fs) = 0 then begin
     repeat
       if LoadHQD(path + fs.Name, Header, sl) then begin
         if (Header.Total = Entries) and MatchesMask(HQRPath, Header.Mask) then begin
           Result:= True;
           Break;
         end;
         FreeAndNil(sl);
       end;
     until FindNext(fs) <> 0;
     FindClose(fs);
   end;
 end;
end;

function ReadHQDFile(HQRPath: String; ext: String;
  out Header: THQDHeader; var Str: TStrArray): Boolean; overload;
var a, b: Integer;
    sl: TStringList;
    st: String;
begin
 Result:= False;
 SetLength(Str, 0);
 a:= PackEntriesCount(HQRPath);
 if FindMatchingHQDFile(HQRPath, a, Header, sl) then begin
   SetLength(Str, Max(sl.Count - 10, 0));
   if ext = '*' then begin //all entries
     for a:= 0 to High(Str) do
       Str[a]:= sl[10 + a];
   end else begin
     for a:= 0 to High(Str) do begin
       st:= sl[10 + a];
       b:= Pos(':', st);
       if (b > 0) and SameText(Copy(st, b + 1, Pos('|',st) - b - 1), ext) then
         Str[a]:= st;
     end;
   end;
   FreeAndNil(sl);
   Result:= True;
 end else
   Header.Desc:= '>> Description file not found <<';
end;

function ReadHQDFile(HQRPath: String; Entry: Integer;
  out Header: THQDHeader; var Str: TStrArray): Boolean; overload;
var a, b, sh: Integer;
    sl: TStringList;
    st, num: String;
    dend: Boolean;
begin
 Result:= False;
 sh:= -1;
 SetLength(Str, 50); //alloc by 50
 a:= PackEntriesCount(HQRPath);
 if FindMatchingHQDFile(HQRPath, a, Header, sl) then begin
   //SetLength(Str, Max(sl.Count - 10, 0));
   num:= IntToStr(Entry);
   a:= 10;
   while a < sl.Count do begin
     st:= sl[a];
     b:= Pos(':', st);
     if (b > 0) and SameText(Copy(st, 1, b - 1), num) then begin
       Inc(a);
       dend:= False;
       while not dend do begin
         st:= Trim(sl[a]);
         if st <> '' then begin
           if SameText(st[1], 'E') then begin
             Inc(sh);
             if sh > High(Str) then
               SetLength(Str, sh + 50);
             Str[sh]:= Copy(st, 2, Length(st) - 1); //without the leading E
           end else
             dend:= True;
         end;
         Inc(a);
       end;
       Break;
     end;
     Inc(a);
   end;

   SetLength(Str, sh + 1); //finally remove the overhead
   FreeAndNil(sl);
   Result:= True;
 end else
   Header.Desc:= '>> Description file not found <<';
end;

function LoadHQRFullInfo(HQRPath: String): THQRInfo;
begin
 //TODO: Later (maybe if it's necesary)
end;

function LoadHQRDescriptions(HQRPath: String; ext: String; var Descs: THQRDescs;
  var DescMap: TIntArray): Boolean;
var a, b, id, lr: Integer;
    temp: TStrArray;
    Header: THQDHeader;
begin
 Result:= False;
 lr:= 0;
 SetLength(Descs, 0);

 if ReadHQDFile(HQRPath, ext, Header, temp) then begin

   SetLength(DescMap, Header.Total);
   for a:= 0 to High(DescMap) do
     DescMap[a]:= -1;

   for a:= 0 to High(temp) do begin
     b:= Pos(':', temp[a]);
     if (b > 0) and TryStrToInt(Copy(temp[a],1,b-1), id) then begin
       b:= Pos('|',temp[a]);
       if (b > 0) then begin
         Inc(lr);
         SetLength(Descs, lr);
         Descs[lr-1].Index:= id;
         Descs[lr-1].Desc:= Copy(temp[a], b + 1, Length(temp[a]) - b);
         if id >= Header.Total then begin
           Header.Desc:= '>> Error in description file near entry ' + IntToStr(id) + ' <<';
           Exit;
         end;
         DescMap[id]:= lr-1;
       end;
     end;
   end;
   Result:= True;
 end;
end;

function LoadHQREntryDescriptions(HQRPath: String; Entry: Integer; var Descs: THQRDescs;
  var DescMap: TIntArray): Boolean;
var a, b, id, rh: Integer;
    temp: TStrArray;
    Header: THQDHeader;
begin
 Result:= False;
 rh:= -1;
 SetLength(Descs, 0);

 if ReadHQDFile(HQRPath, Entry, Header, temp) then begin

   SetLength(DescMap, Length(temp));
   for a:= 0 to High(DescMap) do
     DescMap[a]:= -1;

   SetLength(Descs, Length(temp));
   for a:= 0 to High(temp) do begin
     b:= Pos(':', temp[a]);
     if (b > 0) and TryStrToInt(Copy(temp[a],1,b-1), id) then begin
       Inc(rh);
       Descs[rh].Index:= id;
       Descs[rh].Desc:= Copy(temp[a], b + 1, Length(temp[a]) - b);
       DescMap[id]:= rh;
     end;
   end;
   SetLength(Descs, rh + 1);
   Result:= True;
 end;
end;

//Filters given list of entries through the given entry type basing on given
//descriptions (deletes the indexes that are not in the desc list)
function FilterEntriesList(idl: TIndexList; dsc: THQRDescs): TIndexList;
var a, {b,} fmh: Integer;
    FilterMap: array of Boolean; 
begin
 SetLength(Result, 0);
 fmh:= Length(dsc) - 1;
 SetLength(FilterMap, fmh + 1);
 for a:= 0 to High(dsc) do begin
   If fmh < dsc[a].Index then begin
     fmh:= dsc[a].Index;
     SetLength(FilterMap, fmh + 1);
   end;
   FilterMap[dsc[a].Index]:= True;
 end;

 for a:= 0 to High(idl) do
   If (idl[a] <= fmh) and FilterMap[idl[a]] then begin
     SetLength(Result, Length(Result) + 1);
     Result[High(Result)]:= idl[a];
   end;

 //for a:= 0 to High(idl) do
 //  for b:= 0 to High(dsc) do
 //    If idl[a] = dsc[b].Index then begin
 //      SetLength(Result, Length(Result) + 1);
 //      Result[High(Result)]:= idl[a];
 //      Break;
 //    end;
end;

end.
