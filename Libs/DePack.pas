//***************************************************************************
// Little Big Architect: DePack unit - provides hqr opening, unpacking
//                                     and saving routines
//
// Copyright Zink
//
// e-mail: zink@poczta.onet.pl
//
// This source code is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This source code is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License (License.txt) for more details.
//***************************************************************************

unit DePack;

interface

uses Windows, Classes, SysUtils, Dialogs, StrUtils, Math, Masks;

type
 TPackEntry = record
  Offset: DWORD;
  CpSize: DWORD;
  RlSize: DWORD;
  Comp: WORD;
  FType: Integer; {-3 = hidden, -2 = blank, -1 = normal, > -1 = repeated}
  Data: string;
 end;

 TPackEntries = array of TPackEntry;
 //Formerly TWhatEntries; for lba_bkg infor only
 TInfoType = (itGrids = 0, itFrags = 1, itLibs = 2, itBricks = 3, itTransparent = 4,
              itGridFrag = 5);
 //For all entry types
 TEntriesType = (etGrids, etFrags, etLibs, etBricks, etGridFrag,
                 etScenes, etFile3d, etBodies, etAnims, etSprites, etSamples,
                 etModels);
 TIndexList = array of Word;
 TIntIndexList = array of Integer;
 TOffsetTable = array of DWord;

 EInvalidIndex = class(Exception);
 EHQRStructError = class(Exception);

const
 EntriesToInfoType: array[etGrids..etSprites] of TInfoType =
   (itGrids, itFrags, itLibs, itBricks, itGridFrag,
    itGrids, itGrids, itGrids, itGrids, itGrids);

var
 f: file;
 OpOffsets: array of record
  D: DWORD;
  T: Integer;
 end;

Function ExtIs(path, ext: String): Boolean;
Function IsBkg(path: String): Boolean;
function ReadStrInt(d: String; pos: DWord): Integer;
procedure WriteStrInt(var d: String; pos, val: Integer);
function GetStrInt(val: Integer): ShortString;
function ReadStrWord(d: String; pos: DWord): Word;
function ReadStrSmallInt(d: String; pos: DWord): SmallInt; //signed word
procedure WriteStrWord(var d: String; pos, val: Integer);
function GetStrWord(val: Word): ShortString;
//Procedure CheckFile(path: String);
Function OpenPack(data: TStream; First: Integer=-1; Last: Integer=-1): TPackEntries; overload;
Function OpenPack(path: String; First: Integer=-1; Last: Integer=-1): TPackEntries; overload;
Function OpenPack(path: String; var data: TPackEntries; First: Integer=-1; Last: Integer=-1): Boolean; overload;
function SavePackToFile(data: TPackEntries; path: String): Boolean;
Function UnpackToStream(src: TPackEntry): TMemoryStream;
Function UnpackToString(src: TPackEntry; MaxBytes: Integer = 0): String;
Procedure UnpackSelf(var src: TPackEntry);
Procedure UnpackAll(var src: TPackEntries);
Function Compress(InData: String; const CType: Word): String;
Function PackEntry(Data: String; FType: Integer = -1; Comp: Word = 0;
 Offset: DWORD = 0): TPackEntry;
Function OpenSingleEntry(data: TStream; Index: Integer; out Entry: TPackEntry): Boolean; overload;
Function OpenSingleEntry(data: TStream; Index: Integer): TPackEntry; overload;
Function OpenSingleEntry(path: String; Index: Integer): TPackEntry; overload;
//procedure ReplaceEntry(path: String; Index: Integer; data: String); //not used
function PackEntriesCount(path: String): Integer;
Function BkgEntriesCount(data: TFileStream; What: TInfoType): TSmallPoint; overload;
Function BkgEntriesCount(path: String; What: TInfoType): TSmallPoint; overload;
Function BkgEntriesCount0(data: TFileStream; What: TInfoType): TSmallPoint; overload;
Function BkgEntriesCount0(path: String; What: TInfoType): TSmallPoint; overload;
procedure BkgHeadFix(var Bkg: TPackEntries; const GrCnt, FrCnt, LbCnt, BkCnt,
 TranspBrk: Integer);
Function NumberDialog(PType: String; First, Last: Integer; var val: Integer): Boolean; overload;
Function NumberDialog(Caption, Text: String; Max: Integer; var val: Integer): Boolean; overload;
Function GetRepeatedRefList(Str: TStream): TIndexList; overload;
Function GetRepeatedRefList(Path: String): TIndexList; overload;
Function GetNormalEntriesList(Str: TStream; First: Integer = 0;
 Last: Integer = -1): TIndexList; overload;
Function GetNormalEntriesList(Path: String; First: Integer = 0;
 Last: Integer = -1): TIndexList; overload;
//Procedure SaveStringToFile(st: String; path: String);
function SaveStringToFile(st: String; path: String): Boolean;

implementation

uses Engine;

Function ExtIs(path, ext: String): Boolean;
begin
 Result:= SameText(ExtractFileExt(path),ext);
end;

Function IsBkg(path: String): Boolean;
begin
 //Result:= ContainsText(path,'lba_bkg') and ExtIs(path,'.hqr');
 Result:= MatchesMask(path, '*lba_bkg*.hqr');
end;

Procedure Error(Code: Integer; path: String = ''; Param: Integer = 0);
var msg, offset: String;
begin
 offset:= IntToStr(Param)+' (Hex: '+IntToHex(Param,0)+').';
 Case Code of
   1: msg:= 'Last offset does not match file size.';
   2: msg:= 'File doesn''t exist.';
   3: msg:= 'Unexpected end of file.';
   4: msg:= 'Erroneous data at offset ' + offset;
   5: msg:= 'Invalid entry size information at offset ' + offset;
   6: msg:= 'Invalid compression information at offset ' + offset;
   7: msg:= 'Erroneous data at line ' + IntToStr(Param) + '.';
   8: msg:= 'Unknown project/script file extension.';
   9: msg:= 'Unknown package file extension.';
  10: msg:= 'No such entry';
  11: msg:= 'File access denied.';
  else msg:= 'Unknown error.';
 end;
 //Application.MessageBox(PChar('During processing the file "'+path+'" the following problem occured:'#13#13+'#'+IntToStr(code)+': '+msg),'LBA Package Engine',MB_ICONERROR+MB_OK);
 try     //¿eby nie by³o b³êdu jeœli plik nie jest otwarty
  CloseFile(f);
 except
 end;
 Abort;
end;

function ReadStrInt(d: String; pos: DWord): Integer;
begin
 Result:= Byte(d[pos])+Byte(d[pos+1])*256+Byte(d[pos+2])*256*256+Byte(d[pos+3])*256*256*256;
end;

procedure WriteStrInt(var d: String; pos, val: Integer);
begin
 d[pos]  := Char(LoByte(LoWord(val)));
 d[pos+1]:= Char(HiByte(LoWord(val)));
 d[pos+2]:= Char(LoByte(HiWord(val)));
 d[pos+3]:= Char(HiByte(HiWord(val)));
end;

function GetStrInt(val: Integer): ShortString;
begin
 Result:= Char(LoByte(LoWord(val)))+Char(HiByte(LoWord(val)))+Char(LoByte(HiWord(val)))+Char(HiByte(HiWord(val)));
end;

function ReadStrWord(d: String; pos: DWord): Word; //unsigned
begin
 Result:= Byte(d[pos]) + Byte(d[pos+1])*256;
end;

function ReadStrSmallInt(d: String; pos: DWord): SmallInt; //signed word
begin
 Result:= SmallInt(Byte(d[pos]) or (Byte(d[pos+1]) shl 8));
end;

procedure WriteStrWord(var d: String; pos, val: Integer);
begin
 d[pos]  := Char(LoByte(val));
 d[pos+1]:= Char(HiByte(val));
end;

function GetStrWord(val: Word): ShortString;
begin
 Result:= Char(LoByte(val)) + Char(HiByte(val));
end;

{Procedure CheckFile(path: String); stdcall;
begin
 If not FileExists(path) then begin
  MessageDlg('File "'+path+'" doesn''t exist!'#13#13'Loading of files aborted.',mtError,[mbOK],0);
  //dlg.Close;
  Abort;
 end;
end; }

Function FindNextOffset(current: Integer): Integer;
var a: Integer;
begin
 for a:= current + 1 to Length(OpOffsets) - 2 do
  If OpOffsets[a].T= -1 then begin
   Result:= a;
   Exit;
  end;
 Result:= Length(OpOffsets) - 1;
end;

Function OpenPack(data: TStream; First: Integer = -1; Last: Integer = -1): TPackEntries; overload;
var a, b, c: Integer;
    Buffer: DWORD;
begin
 SetLength(OpOffsets,1);
 with data do begin
  Seek(0,soBeginning);
  Read(OpOffsets[0].D,4);
  OpOffsets[0].T:= -1;  //first entry is always normal
  SetLength(OpOffsets,(OpOffsets[0].D div 4)-1);
  for a:= 1 to Length(OpOffsets) - 1 do begin
   Read(OpOffsets[a].D,4);
   OpOffsets[a].T:= -1;
   if OpOffsets[a].D = 0 then
    OpOffsets[a].T:= -2
   else
    For b:= 0 to a - 1 do
     If OpOffsets[a].D = OpOffsets[b].D then begin
      OpOffsets[a].T:= b;
      Break;
     end;
  end;

  If First < 0 then First:= 0;
  If Last < 0 then Last:= Length(OpOffsets) - 1
  else if Last >= Length(OpOffsets) then Last:= Length(OpOffsets) - 1;

  SetLength(Result,Last-First+1);
  b:=0;
  For a:=First to Last do begin
   If OpOffsets[a].T=-1 then begin
    Buffer:=OpOffsets[a].D;
    repeat
     If Length(Result)<b+1 then SetLength(Result,b+1);
     If Buffer=OpOffsets[a].D then Result[b].FType:=-1
     else Result[b].FType:=-3;
     Seek(Buffer,soBeginning);
     Result[b].Offset:=Buffer;
     Read(Result[b].RlSize, 4);
     Read(Result[b].CpSize, 4);
     Read(Result[b].Comp, 2);
     If (Result[b].Comp > 2) then Result[b].Comp:= 0;

     SetLength(Result[b].Data, Result[b].CpSize);
     if Result[b].CpSize > 0 then
       Read(Result[b].Data[1], Result[b].CpSize);

     Inc(Buffer,Result[b].CpSize + 10);

     Inc(b);
     c:= FindNextOffset(a);
    until Buffer >= OpOffsets[c].D;
   end
   else begin
    If Length(Result)<b+1 then SetLength(Result,b+1);
    if OpOffsets[a].T>-1 then begin
     Result[b].Offset:=OpOffsets[a].D;
     Result[b].CpSize:=Result[OpOffsets[a].T].CpSize;
     Result[b].RlSize:=Result[OpOffsets[a].T].RlSize;
     Result[b].Comp:=Result[OpOffsets[a].T].Comp;
     Result[b].Data:=Result[OpOffsets[a].T].Data;
    end
    else begin
     Result[b].CpSize:=0;
     Result[b].RlSize:=0;
    end;
    Result[b].FType:=OpOffsets[a].T;
    Inc(b);
   end;
  end;
 end;
 SetLength(Result,b);
 SetLength(OpOffsets,0);
end;

Function OpenPack(path: String; First: Integer=-1; Last: Integer=-1): TPackEntries; overload;
var FStr: TFileStream;
begin
 FStr:= TFileStream.Create(path,fmOpenRead);
 Result:= OpenPack(FStr,First,Last);
 FStr.Free;
end;

Function OpenPack(path: String; var data: TPackEntries; First: Integer = -1;
 Last: Integer = -1): Boolean; overload;
var FStr: TFileStream;
begin
 //Result:= False;
 FStr:= TFileStream.Create(path,fmOpenRead);
 try
   data:= OpenPack(FStr, First, Last);
   Result:= True;
 finally
   FStr.Free;
 end;
end;

//Zwraca PackSize
function CalcOffsets(var data: TPackEntries): Integer;
var a, c: Integer;
    b: DWORD;
begin
 b:= 4;
 for a:= 0 to High(data) do
  If data[a].FType <> -3 then Inc(b,4); //skip hidden

 For a:= 0 to High(data) do begin
  case data[a].FType of
   -1: data[a].Offset:= b;   //normal
   -2: data[a].Offset:= 0;   //blank
   else if data[a].FType >= 0 then  //repeated
    data[a].Offset:= data[data[a].FType].Offset
  end;

  If data[a].FType <> -2 then begin
   c:= 10 + data[a].CpSize;
   If data[a].FType < 0 then Inc(b,c);
  end;
 end;
 Result:= b;
end;

function SavePackToFile(data: TPackEntries; path: String): Boolean;
var a, PackSize: Integer;
    f: File;
begin
 Result:= True;
 PackSize:= CalcOffsets(data);
 AssignFile(f,path);
 try
   try
     Rewrite(f, 1);
     for a:= 0 to High(data) do
       if data[a].FType <> -3 then
         BlockWrite(f, data[a].Offset, 4);
     BlockWrite(f, PackSize, 4);
     for a:= 0 to High(data) do
       if (data[a].FType = -1) or (data[a].FType = -3) then begin
         BlockWrite(f, data[a].RlSize, 4);
         BlockWrite(f, data[a].CpSize, 4);
         BlockWrite(f, data[a].Comp, 2);
         if Length(data[a].Data) > 0 then
           BlockWrite(f, data[a].Data[1], data[a].CpSize);
       end;
   except
     Result:= False;
   end;
 finally
   CloseFile(f);
 end;
end;

Function UnpackToStream(src: TPackEntry): TMemoryStream;
var a: Integer;
    b, d, f, g: Byte;
    e: Word;
    Buffer: String;
begin
 Result:= TMemoryStream.Create();
 Result.Clear();
 If src.FType = -2 then Exit;
 If src.Comp = 0 then begin
   if Length(src.Data) > 0 then
     Result.Write(src.data[1], Length(src.data));
   Exit;
 end;
 Buffer:= '';
 a:= 1;
 repeat
   b:= Byte(src.Data[a]);
   for d:=0 to 7 do begin
     Inc(a);
     if (b and (1 shl d)) <> 0 then
       Buffer:= Buffer + src.Data[a]
     else begin
       e:= Byte(src.Data[a])*256 + Byte(src.Data[a+1]);
       f:= ((e shr 8) and $000f) + src.Comp + 1; //tutaj mamy d³ugoœæ do skopiowania
       e:= ((e shl 4) and $0ff0) + ((e shr 12) and $000f);  //tutaj mamy adres od koñca bufora
       for g:= 1 to f do
         Buffer:= Buffer + Buffer[Length(Buffer)-e];
       Inc(a);
     end;
     If a >= Length(src.Data) then Break;
   end;
   Inc(a);
 until a >= Length(src.Data);
 SetLength(Buffer, src.RlSize);
 Result.Write(Buffer[1], Length(Buffer));
end;

//MaxBytes > 0 makes the function unpack only specified number of bytes
// from the beginning of the file (bytes are counted in unpacked data)
//It is a lot faster to unpack just a few bytes from the beginning than to
// unpack the whole file, if the rest of data is not needed.
Function UnpackToString(src: TPackEntry; MaxBytes: Integer = 0): String;
var a: Integer;
    b, d, f, g: Byte;
    e: Word;
begin
 If src.FType = -2 then Exit;
 If src.Comp = 0 then begin Result:= src.data; Exit; end;
 Result:= '';
 if Length(src.Data) < 1 then Exit;
 If MaxBytes <= 0 then MaxBytes:= src.RlSize;
 a:= 1;
 repeat
  b:= Byte(src.Data[a]);
  for d:= 0 to 7 do begin
   inc(a);
   if (b and (1 shl d)) <> 0 then
    Result:= Result + src.Data[a]
   else begin
    e:= Byte(src.Data[a])*256 + Byte(src.Data[a+1]);
    f:= ((e shr 8) and $000f) + src.Comp + 1; //here we have number of bytes to bopy
    e:= ((e shl 4) and $0ff0) + ((e shr 12) and $000f); //address from the end of the buffer
    for g:= 1 to f do
     Result:= Result + Result[Length(Result)-e];
    Inc(a);
   end;
   If (a >= Length(src.Data)) or (Length(Result) >= MaxBytes) then Break;
  end;
  Inc(a);
 until (a >= Length(src.Data)) or (Length(Result) >= MaxBytes);
 SetLength(Result,MaxBytes);
end;

Procedure UnpackSelf(var src: TPackEntry);
begin
 If src.Comp = 0 then Exit;
 src.Data:= UnpackToString(src);
 src.Comp:= 0;
 src.CpSize:= src.RlSize;
end;

Procedure UnpackAll(var src: TPackEntries);
var a: Integer;
begin
 for a:=0 to High(src) do begin
  src[a].Data:=UnpackToString(src[a]);
  src[a].Comp:=0;
  src[a].CpSize:=src[a].RlSize;
 end;
end;

Function Compress(InData: String; const CType: Word): String;
var a, b, c, d, Pos, MaxSize, MaxPos, InLen: Integer;
    Buff, Needle: String;
    e: Word;
begin
 If (CType <> 1) and (CType <> 2) then begin Result:= InData; Exit; end;
 InLen:= Length(InData);
 Pos:= 1;
 MaxPos:= 0;
 Result:= '';
 if InLen < 1 then Exit;
 repeat
   Buff:= #00;
   for a:= 0 to 7 do begin
     MaxSize:= 0;
     c:= 3;
     d:= 0;
     b:= PosEx(Copy(InData,Pos,c), InData, Max(1,Pos-4096));
     while (b > 0) and (b < Pos) and (Pos < InLen - 1) do begin
       while (Pos+c <= InLen) and (InData[b+c] = InData[Pos+c]) and (c < 16+CType) do
         Inc(c); //find whole string
       if c > MaxSize then begin MaxSize:= c; MaxPos:= b; end;
       if c >= 16 + CType then Break;
       if c <> d then Needle:= Copy(InData, Pos, c);
       b:= PosEx(Needle, InData, b+1);
       d:= c;
     end;

     if MaxSize > 0 then begin
       b:= Pos - MaxPos - 1;
       Inc(Pos,MaxSize);
       c:= MaxSize - CType - 1;
       e:= ((b and $0FFF) shl 4) + (c and $000F);
       Buff:= Buff + Char(e and $00FF) + Char((e and $FF00) shr 8);
       Buff[1]:= Char(Byte(Buff[1]) and ($FF xor (1 shl a)));
     end
     else begin
       Buff:= Buff + InData[Pos];
       Inc(Pos);
       Buff[1]:= Char(Byte(Buff[1]) or (1 shl a));
     end;
     If Pos > InLen then Break;
   end;
   Result:= Result + Buff;
 until Pos > InLen;
end;

Function PackEntry(Data: String; FType: Integer = -1; Comp: Word = 0;
 Offset: DWORD = 0): TPackEntry;
begin
 Result.Comp:= Comp;
 Result.Data:= Compress(Data,Comp);
 Result.RlSize:= Length(Data);
 Result.CpSize:= Length(Result.Data);
 Result.FType:= FType;
 Result.Offset:= Offset;
end;

Function OpenSingleEntry(data: TStream; Index: Integer; out Entry: TPackEntry): Boolean;
var a: Integer;
begin
 Result:= False;
 with data do begin
  Seek(0, soBeginning);
  Read(a, 4);
  If Index * 4 <= a then begin
    Seek(Index*4, soBeginning);
    Read(Entry.Offset, 4);
    Seek(Entry.Offset, soBeginning);
    Read(Entry.RlSize, 4);
    Read(Entry.CpSize, 4);
    Read(Entry.Comp, 2);
    If Entry.Comp > 2 then Entry.Comp:= 0;
    SetLength(Entry.Data, Entry.CpSize);
    Read(Entry.Data[1], Entry.CpSize);
    Result:= True;
  end;
 end;
end;

Function OpenSingleEntry(data: TStream; Index: Integer): TPackEntry;
var a: Integer;
begin
 with data do begin
  Seek(0, soBeginning);
  Read(a, 4);
  if Index * 4 > a then
    raise EInvalidIndex.Create('Index out of range.');
  Seek(Index*4, soBeginning);
  Read(Result.Offset, 4);
  Seek(Result.Offset, soBeginning);
  Read(Result.RlSize, 4);
  Read(Result.CpSize, 4);
  Read(Result.Comp, 2);
  if Result.Comp > 2 then Result.Comp:= 0;
  SetLength(Result.Data, Result.CpSize);
  Read(Result.Data[1], Result.CpSize);
 end;
end;

function OpenSingleEntry(path: String; Index: Integer): TPackEntry;
var FStr: TFileStream;
begin
 FStr:= TFileStream.Create(path, fmOpenRead + fmShareDenyWrite);
 Result:= OpenSingleEntry(FStr, Index);
 FStr.Free;
end;

//Not working good, as far as I remember
{procedure ReplaceEntry(path: String; Index: Integer; data: String);
var s: String;                               //data must not be compressed !!!
    FCount, a, b, FOffset, FSize, FCSize: Integer;
    FComp: Word;
begin
 AssignFile(f,path);
 FileMode:=fmOpenReadWrite;
 Reset(f,1);
 try
  SetLength(s,FileSize(f));
  BlockRead(f,s[1],Length(s));
  FCount:=ReadStrInt(s,1) div 4;
  If FCount<Index-1 then Error(10,path);
  FOffset:=ReadStrInt(s,Index*4+1);
  FSize:=ReadStrInt(s,FOffset+1);
  FCSize:=ReadStrInt(s,FOffset+1+4);
  FComp:=ReadStrWord(s,FOffset+1+8);
  Delete(s,FOffset+1+10,FCSize);
  Insert(data,s,FOffset+1+10);
  WriteStrInt(s,FOffset+1,Length(data));
  WriteStrInt(s,FOffset+1+4,Length(data));
  WriteStrWord(s,FOffset+1+8,0);
  for a:=0 to FCount-1 do begin
   b:=ReadStrInt(s,a*4+1);
   if b>FOffset then Inc(b,Length(data)-FCSize);
   WriteStrInt(s,a*4+1,b);
  end;
  Seek(f,0);
  Truncate(f);
  BlockWrite(f,s[1],Length(s));
  CloseFile(f);
 except
  Error(11,path);
 end;
end;}

Function PackEntriesCount(path: String): Integer;
var f: File;
    a: DWORD;
begin
 //CheckFile(path);
 AssignFile(f, path);
 FileMode:= fmOpenRead;
 Reset(f, 1);
 BlockRead(f, a, 4);
 CloseFile(f);
 Result:= (a div 4) - 1;
end;

//returned indexes are counted from 1
Function BkgEntriesCount(data: TFileStream; What: TInfoType): TSmallPoint; overload;
var Temp: TPackEntry;
    Buff: TMemoryStream;
    a: WORD;
begin
 data.Seek(0,soBeginning);
 data.Read(Temp.Offset,4);
 data.Seek(Temp.Offset,soBeginning);
 data.Read(Temp.RlSize,4);
 data.Read(Temp.CpSize,4);
 data.Read(Temp.Comp,2);
 If (Temp.Comp > 2) then Temp.Comp:= 0;
 SetLength(Temp.Data, Temp.CpSize);
 data.Read(Temp.Data[1], Temp.CpSize);
 Buff:= UnpackToStream(Temp);
 If What = itGridFrag then a:= 0
                      else a:= Ord(What) * 2;
 Buff.Seek(a,soBeginning);
 Buff.Read(Result.X,2);
 Inc(Result.X);
 If What = itGridFrag then Buff.Seek(4,soBeginning);
 Buff.Read(Result.Y,2);
 FreeAndNil(Buff);
end;

Function BkgEntriesCount(path: String; What: TInfoType): TSmallPoint; overload;
var FStr: TFileStream;
begin
 //CheckFile(path);
 FStr:= TFileStream.Create(path,fmOpenRead,fmShareDenyWrite);
 Result:= BkgEntriesCount(FStr, What);
 FStr.Free;
end;

//returned indexes are counted from 0
//BKG info data:
//0x00: 2 bytes, first Grid entry (starting with 0, so always equal to 1)
//0x02: 2 bytes, first Fragment entry
//0x04: 2 bytes, first Library entry
//0x06: 2 bytes, first Brick entry
//0x08: 2 bytes, number of Brick entries
Function BkgEntriesCount0(data: TFileStream; What: TInfoType): TSmallPoint;
var Temp: TPackEntry;
    Buff: TMemoryStream;
    a: WORD;
begin
 data.Seek(0,soBeginning);
 data.Read(Temp.Offset,4);
 data.Seek(Temp.Offset,soBeginning);
 data.Read(Temp.RlSize,4);
 data.Read(Temp.CpSize,4);
 data.Read(Temp.Comp,2);
 if (Temp.Comp > 2) then Temp.Comp:= 0;
 SetLength(Temp.Data, Temp.CpSize);
 data.Read(Temp.Data[1], Temp.CpSize);
 Buff:= UnpackToStream(Temp);
 if What = itGridFrag then a:= 0
                      else a:= Ord(What) * 2;
 Buff.Seek(a,soBeginning);
 Buff.Read(Result.X,2);
 if What = itGridFrag then Buff.Seek(4,soBeginning);
 Buff.Read(Result.Y,2);
 FreeAndNil(Buff);
end;

Function BkgEntriesCount0(path: String; What: TInfoType): TSmallPoint; overload;
var FStr: TFileStream;
begin
 FStr:= TFileStream.Create(path,fmOpenRead,fmShareDenyWrite);
 Result:= BkgEntriesCount0(FStr, What);
 FStr.Free;
end;

procedure BkgHeadFix(var Bkg: TPackEntries; const GrCnt, FrCnt, LbCnt, BkCnt,
 TranspBrk: Integer);
var Dt2, Dt3, Dt4: Word;
    a: Integer;
    max: DWord;
begin
 If Bkg[0].Comp > 0 then UnpackSelf(Bkg[0]);
 If Length(Bkg[0].Data) <> 28 then Exit;
 WriteStrWord(Bkg[0].Data,1,$0001);
 If GrCnt > -1 then Dt2:= GrCnt + 1   else Dt2:= ReadStrWord(Bkg[0].Data,3);
 If FrCnt > -1 then Dt3:= Dt2 + FrCnt else Dt3:= ReadStrWord(Bkg[0].Data,5);
 If LbCnt > -1 then Dt4:= Dt3 + LbCnt else Dt4:= ReadStrWord(Bkg[0].Data,7);
 WriteStrWord(Bkg[0].Data,3,Dt2);
 WriteStrWord(Bkg[0].Data,5,Dt3);
 WriteStrWord(Bkg[0].Data,7,Dt4);
 If BkCnt > -1 then WriteStrWord(Bkg[0].Data,9,BkCnt);
 If TranspBrk > -1 then WriteStrWord(Bkg[0].Data,11,TranspBrk);
 max:= 0;
 for a:= 1 to Dt2 - 1 do
  If Bkg[a].RlSize > max then max:= Bkg[a].RlSize;
 WriteStrInt(Bkg[0].Data,13,max-2);
 max:= 0;
 for a:= Dt3 to Dt4 - 1 do
  If Bkg[a].RlSize > max then max:= Bkg[a].RlSize;
 WriteStrInt(Bkg[0].Data,17,max);
end;

Function NumberDialog(PType: String; First, Last: Integer; var val: Integer): Boolean; overload;
var res: String;
begin
 Result:=False;
 repeat
  res:=InputBox('Specify package entry',
   Format('This package contains more than one %s.'#13'Please enter the index of which one has to be used (from %d to %d):',[PType,First,Last]),'');
  if res='' then Exit;
  val:=StrToIntDef(res,First-1);
 until (val>=First) and (val<=Last);
 Result:=True;
end;

Function NumberDialog(Caption, Text: String; Max: Integer; var val: Integer): Boolean; overload;
var res: String;
begin
 Result:= False;
 If InputQuery(Caption, Text, res) then begin
   Result:= TryStrToInt(res,val) and (val >= 0) and (val <= Max);
   If not Result then begin
     MessageBeep(MB_ICONERROR);
     MessageDlg('Value must be an integer between 0 and ' + IntToStr(Max) + '!',
                mtError,[mbOK],0);
   end;
 end;
end;

//doesn't count hidden entries
Function HQRReadOffsetTable(Str: TStream): TOffsetTable;
var a, Count: Integer;
    b: DWord;
begin
 SetLength(Result, 0);
 Str.Seek(0,soBeginning);
 repeat
  Str.Read(b,4); //search for first non-blank
 until (b <> 0) or (Str.Position = Str.Size);
 If Str.Position < Str.Size then begin
  Count:= (b div 4) - 1; //No file size offset
  SetLength(Result, Count);
  Str.Seek(0,soBeginning);
  for a:= 0 to Count - 1 do
   Str.Read(Result[a],4);
  //Str.Read(b,4);
  //If b <> Str.Size then raise EHQRStructError.Create('Invalid last HQR offset');
 end
 else
  raise EHQRStructError.Create('Invalid HQR file (the file is blank)');
end;

//Returned index list contains:
// - for repeated entries: index of its base entry
// - for other etries (normal, blank): index of the entry
Function GetRepeatedRefList(Str: TStream): TIndexList; overload;
var a, b: Integer;
    Offsets: TOffsetTable;
begin
 Offsets:= HQRReadOffsetTable(Str);
 SetLength(Result, Length(Offsets));
 for a:= 0 to High(Offsets) do begin
  Result[a]:= a;
  if Offsets[a] <> 0 then //if not blank
   for b:= 0 to a - 1 do
    if Offsets[a] = Offsets[b] then begin
     Result[a]:= b;
     Break;
    end;
 end;
end;

Function GetRepeatedRefList(Path: String): TIndexList; overload;
var Str: TFileStream;
begin
 Str:= TFileStream.Create(Path, fmOpenRead);
 Result:= GetRepeatedRefList(Str);
 Str.Free;
end;

//Returns array of the real entries indexes from the specified range (starting with 0)
//The array has the real entries indexes as values (keys are meaningless)
//If Last is = -1, then it takes the highest entry index as Last
Function GetNormalEntriesList(Str: TStream; First: Integer = 0;
 Last: Integer = -1): TIndexList; overload;
var a, b: Integer;
    Offsets: TOffsetTable;
    Repeated: Boolean;
begin
 SetLength(Result, 0);
 Offsets:= HQRReadOffsetTable(Str);
 if Last = -1 then Last:= High(Offsets);
 for a:= First to Last do
   if Offsets[a] <> 0 then begin
     Repeated:= False;
     for b:= 0 to a - 1 do
       if Offsets[a] = Offsets[b] then begin
         Repeated:= True;
         Break;
       end;
     If not Repeated then begin
       SetLength(Result, Length(Result) + 1);
       Result[High(Result)]:= a;
     end;
   end;
end;

Function GetNormalEntriesList(Path: String; First: Integer = 0;
  Last: Integer = -1): TIndexList; overload;
var Str: TFileStream;
begin
  Str:= TFileStream.Create(Path, fmOpenRead);
  Result:= GetNormalEntriesList(Str,First,Last);
  Str.Free();
end;

{Procedure SaveStringToFile(st: String; path: String);
var f: File;
begin
 AssignFile(f, path);
 Rewrite(f, 1);
 BlockWrite(f, st[1], Length(st));
 CloseFile(f);
end;}

function SaveStringToFile(st: String; path: String): Boolean;
var FStr: TFileStream;
    len: Integer;
begin
 FStr:= nil;
 Result:= False;
 try
   try
     FStr:= TFileStream.Create(path, fmCreate or fmShareExclusive);
     FStr.Size:= 0;
     FStr.Seek(0, soBeginning);
     len:= Length(st);
     Result:= FStr.Write(st[1], len) = len;
   finally
     FStr.Free();
   end;
 except
 end;
end;

end.
