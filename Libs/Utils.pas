unit Utils;

interface

uses Windows, Forms, SysUtils, Clipbrd, SpinMod, StrUtils, Controls, Math,
     Graphics, FileCtrl, Classes, BetterSpin, ComCtrls;

type
  TRange = record
    Min, Max: Integer;
  end;
  PRange = ^TRange;

  TByteDynAr = array of Byte;
  TWordDynAr = array of Word;
  TIntDynAr = array of Integer;
  TDoubleDynAr = array of Double;
  TStrDynAr = array of String;
  PStrDynAr = ^TStrDynAr;
  TBoolDynAr = array of Boolean;
  TObjArray = array of TObject;
  TObjProc = procedure of object;

const
  RngZero:    TRange = (Min:      0; Max:     0);
  RngBool:    TRange = (Min:      0; Max:     1);
  RngTriple:  TRange = (Min:      0; Max:     2);
  RngDMod7:   TRange = (Min:      0; Max:     7);
  RngDMod13:  TRange = (Min:      0; Max:    13);
  RngBeh4:    TRange = (Min:      0; Max:     4);
  RngMag4:    TRange = (Min:      0; Max:     4);
  RngBeh13:   TRange = (Min:      0; Max:    13);
  RngDist:    TRange = (Min:      0; Max: 32000);
  RngGold:    TRange = (Min:      0; Max:   999);

  RngSByte_1: TRange = (Min:     -1; Max:   254);
  RngUByte:   TRange = (Min:      0; Max:   255);
  RngUWord:   TRange = (Min:      0; Max: 65535);
  RngSWord:   TRange = (Min: -32768; Max: 32767);
  RngHWord_1: TRange = (Min:     -1; Max: 32767);
  RngHWord0:  TRange = (Min:      0; Max: 32767);
  RngHWord1:  TRange = (Min:      1; Max: 32768);
  RngMWord:   TRange = (Min:  65535; Max: 65535);

function ChoiceId(Arg: array of Boolean; Default: Integer): Integer;
function ReadProgramVersion(out Beta: Boolean): String;

procedure ErrorMsg(Text: String);
procedure WarningMsg(Text: String);
procedure InfoMsg(Text: String);
function QuestYesNo(Text: String): Boolean;

function FileNameWithoutExt(name: String): String;
//Coverts short filename (DOS-like with ~s) to the expanded version.
//Works only if the target file exists!
function GetLongFileName(ShortName: String): String;
//Shortens the file name so that it doesn't exceed the given pixel length limit,
//  but doesn't leave full file name in any case, like original MinimizeName.
function MinimizeNameK(FileName: String; Canvas: TCanvas; MaxLen: Integer): String;
procedure DrawMinimizedName(FileName: String; Canvas: TCanvas; R: TRect);

function ParseCSVLine(Data: String; Separator: String): TStrDynAr;
function ParseNameValue(Data, Separator: String; out Name, Value: String): Boolean;

//All following conversion functions are Little Endian!
function ExtractCStrFromStr(d: String; pos: DWord): String;
function ReadIntFromBinStr(d: String; pos: DWord): Integer;
function ReadUIntFromBinStr(d: String; pos: DWord): Cardinal;
procedure WriteIntToBinStr(var d: String; pos, val: Integer);
function IntToBinStr(val: Integer): String;
function UIntToBinStr(val: Cardinal): String;
function ReadWordFromBinStr(d: String; pos: DWord): Word;
procedure WriteWordToBinStr(var d: String; pos, val: Integer);
function WordToBinStr(val: Word): String;
function ReadValFromBinStr(d: String; pos: Cardinal; count: Byte): Cardinal;
procedure WriteValToBinStr(d: String; pos: Cardinal; count: Byte; val: Cardinal);
function ValToBinStr(count: Byte; val: Integer): String;

function SRound(val: Double): Integer;

procedure CopyCoords(seX, seY, seZ: TSpinEdit); overload;
procedure CopyCoords(seX, seY, seZ: TfrBetterSpin); overload;
procedure PasteCoords(seX, seY, seZ: TSpinEdit); overload;
procedure PasteCoords(seX, seY, seZ: TfrBetterSpin); overload;

function ValueInRange(v: Integer; range: TRange): Boolean; overload;
function ValueInRange(v: Integer; Min, Max: Integer): Boolean; overload;
function Restrict(v, VMin, VMax: Integer): Integer;

//The function is case-sensitive
function StrInArray(s: String; a: array of String): Boolean;
//case-insensitive
function TextInArray(t: String; a: array of String): Boolean;

//Enables/disables child controls of the given parent
procedure EnableGroup(Parent: TWinControl; Ena: Boolean); overload;

//If the file has different extension, the right one will be added
function EnsureFileExt(FileName, Ext: String): String;

//Oblicza wysokoœæ linii w TListView (zwraca 1 jeœli lista jest pusta)
function ListViewRowHeight(lv: TListView): Integer;
procedure ListViewLastColAutosize(lv: TListView);

implementation

function ChoiceId(Arg: array of Boolean; Default: Integer): Integer;
var a: Integer;
begin
  Result:= Default;
  for a:= 0 to High(Arg) do
    if Arg[a] then begin
      Result:= a;
      Exit;
    end;
end;

function ReadProgramVersion(out Beta: Boolean): String;
var tab: VS_FIXEDFILEINFO;
    wsk, wsktab: Pointer;
    len: DWORD;
begin
  wsk:= nil;
  try
    len:= GetFileVersionInfoSize(PChar(Application.ExeName), len);
    wsk:= AllocMem(len);
    GetFileVersionInfo(PChar(Application.ExeName), 0, len, wsk);
    VerQueryValue(wsk, '\' ,wsktab, len);
    tab:= VS_FIXEDFILEINFO(wsktab^);
    Result:= IntToStr((tab.dwFileVersionMS shr 16) and $FF) + '.'
           + IntToStr(tab.dwFileVersionMS and $FF);// + '.'
           //+ IntToStr((tab.dwFileVersionMS shr 8) and $FF);
    Beta:= (tab.dwFileFlags and VS_FF_DEBUG) <> 0;
    if Beta then Result:= Result + ' beta ' + IntToStr(tab.dwProductVersionLS);
  finally
    if Assigned(wsk) then FreeMem(wsk);
  end;
end;

procedure ErrorMsg(Text: String);
begin
 Application.MessageBox(PChar(Text), 'Error', MB_ICONERROR or MB_OK);
end;

procedure WarningMsg(Text: String);
begin
 Application.MessageBox(PChar(Text), 'Warning', MB_ICONWARNING or MB_OK);
end;

procedure InfoMsg(Text: String);
begin
 Application.MessageBox(PChar(Text), 'Information', MB_ICONINFORMATION or MB_OK);
end;

function QuestYesNo(Text: String): Boolean;
begin
 Result:= Application.MessageBox(PChar(Text), 'Question',
   MB_ICONQUESTION or MB_YESNO) = ID_YES;
end;

function FileNameWithoutExt(name: String): String;
var a: Integer;
begin
 for a:= Length(name) downto 1 do
   if name[a] = '.' then begin
     Result:= LeftStr(name, a - 1);
     Exit;
   end;
 Result:= name; //if dot not found
end;

function GetLongFileName(ShortName: String): String;
var sr: TSearchRec;
begin
 Result:= '';
 if not FileExists(ShortName) then
   Result:= ShortName
 else begin
   while FindFirst(ShortName, faAnyFile, sr) = 0 do begin
     Result:= '\' + sr.Name + Result;
     SysUtils.FindClose(sr);
     ShortName:= ExtractFileDir(ShortName);
     if Length(ShortName) <= 2 then Break;
   end;
   Result:= ExtractFileDrive(ShortName) + Result;
 end;
end;

function MinimizeNameK(FileName: String; Canvas: TCanvas; MaxLen: Integer): String;
var r: TRect;
    fn: PAnsiChar;
begin
 Result:= MinimizeName(FileName, Canvas, MaxLen);
 if Canvas.TextWidth(Result) > MaxLen then begin
   fn:= PAnsiChar(Result);
   r:= Rect(0, 0, MaxLen, 0);
   DrawText(Canvas.Handle, fn, Length(Result), r,
     DT_END_ELLIPSIS or DT_LEFT or DT_MODIFYSTRING);
   Result:= String(fn);  
 end;
end;

procedure DrawMinimizedName(FileName: String; Canvas: TCanvas; R: TRect);
var temp: String;
begin
 temp:= MinimizeName(FileName, Canvas, R.Right - R.Left);
 DrawText(Canvas.Handle, PChar(temp), Length(temp), R,
   DT_END_ELLIPSIS or DT_LEFT or DT_TOP or DT_SINGLELINE);
end;

function ParseCSVLine(Data: String; Separator: String): TStrDynAr;
var p, k, l, ds: Integer;
begin
 SetLength(Result, 0);
 if Length(Data) = 0 then Exit;
 ds:= Length(Separator);
 if ds = 0 then begin
   SetLength(Result, 1);
   Result[0]:= Data;
 end
 else begin
   l:= 0;
   p:= 0;
   k:= Pos(Separator, data);
   while k > 0 do begin
    Inc(l);
    SetLength(Result, l);
    Result[l-1]:= Copy(data, p + ds, k - p - ds);
    p:= k;
    k:= PosEx(Separator, data, k + 1);
   end;
   Inc(l);
   SetLength(Result, l);
   Result[l-1]:= Copy(data, p + ds, Length(data) - p);
 end;
end;

function ParseNameValue(Data, Separator: String; out Name, Value: String): Boolean;
var a: Integer;
begin
 a:= Pos(Separator, Data);
 Result:= a >= 1;
 if Result then begin
   Name:= LeftStr(Data, a - 1);
   Value:= RightStr(Data, Length(Data) - Length(Separator) - a + 1);
 end;
end;

function ExtractCStrFromStr(d: String; pos: DWord): String;
var a: DWord;
begin
 a:= 0;
 while d[pos + a] <> #0 do Inc(a);
 Result:= Copy(d, pos, a);
end;

function ReadIntFromBinStr(d: String; pos: DWord): Integer;
begin
 Result:= Integer(Byte(d[pos]) + Byte(d[pos+1]) * 256 + Byte(d[pos+2]) * 256 * 256
        + Byte(d[pos+3]) * 256 * 256 * 256);
end;

function ReadUIntFromBinStr(d: String; pos: DWord): Cardinal;
begin
 Result:= Byte(d[pos]) + Byte(d[pos+1]) * 256 + Byte(d[pos+2]) * 256 * 256
        + Byte(d[pos+3]) * 256 * 256 * 256;
end;

procedure WriteIntToBinStr(var d: String; pos, val: Integer);
begin
 d[pos]  := Char(LoByte(LoWord(val)));
 d[pos+1]:= Char(HiByte(LoWord(val)));
 d[pos+2]:= Char(LoByte(HiWord(val)));
 d[pos+3]:= Char(HiByte(HiWord(val)));
end;

function IntToBinStr(val: Integer): String;
begin
  SetLength(Result, 4);
  Move(val, Result[1], 4);
end;

function UIntToBinStr(val: Cardinal): String;
begin
  SetLength(Result, 4);
  Move(val, Result[1], 4);
end;

function ReadWordFromBinStr(d: String; pos: DWord): Word;
begin
  Result:= Byte(d[pos]) + Byte(d[pos+1]) * 256;
end;

procedure WriteWordToBinStr(var d: String; pos, val: Integer);
begin
 d[pos]  := Char(LoByte(val));
 d[pos+1]:= Char(HiByte(val));
end;

function WordToBinStr(val: Word): String;
begin
 Result:= Char(LoByte(val)) + Char(HiByte(val));
end;

//Reads from the string number of bytes specified by count
function ReadValFromBinStr(d: String; pos: Cardinal; count: Byte): Cardinal;
begin
 if Length(d) >= Integer(pos + count - 1) then begin
   Result:= Byte(d[pos]);
   if count >= 2 then Result:= Result or (Byte(d[pos+1]) shl 8);
   if count >= 3 then Result:= Result or (Byte(d[pos+2]) shl 16);
   if count >= 4 then Result:= Result or (Byte(d[pos+3]) shl 24);
 end else
   Result:= 0;  
end;

//Writes to the string number of bytes specified by count
procedure WriteValToBinStr(d: String; pos: Cardinal; count: Byte; val: Cardinal);
begin
 d[pos]:= Char(LoByte(LoWord(val)));
 if count >= 2 then d[pos+1]:= Char(HiByte(LoWord(val)));
 if count >= 3 then d[pos+2]:= Char(LoByte(HiWord(val)));
 if count >= 4 then d[pos+3]:= Char(HiByte(HiWord(val)));
end;

function ValToBinStr(count: Byte; val: Integer): String;
begin
  Result:= Char(LoByte(LoWord(val)));
  if count >= 2 then Result:= Result + Char(HiByte(LoWord(val)));
  if count >= 3 then Result:= Result + Char(LoByte(HiWord(val)));
  if count >= 4 then Result:= Result + Char(HiByte(HiWord(val)));
end;

function SRound(val: Double): Integer;
begin
 Result:= Trunc(SimpleRoundTo(val, 0));
end;

procedure CopyCoords(seX, seY, seZ: TSpinEdit);
begin
 if seX.ValueOK and seY.ValueOK and seZ.ValueOK then
   Clipboard.AsText:= Format('X%dY%dZ%d', [seX.Value, seY.Value, seZ.Value])
 else
   ErrorMsg('One of the fields contains invalid value!');
end;

procedure CopyCoords(seX, seY, seZ: TfrBetterSpin);
begin
 if seX.ValueOK and seY.ValueOK and seZ.ValueOK then
   Clipboard.AsText:= Format('X%dY%dZ%d', [seX.Value, seY.Value, seZ.Value])
 else
   ErrorMsg('One of the fields contains invalid value!');
end;

procedure PasteCoords(seX, seY, seZ: TSpinEdit);
var x, y, z, py, pz: Integer;
    temp: String;
begin
 if Clipboard.HasFormat(CF_TEXT) then begin
   temp:= Copy(Clipboard.AsText, 1, 100); //To avoid hang if clipboard contains lots of data
   py:= Pos('Y', temp);
   pz:= Pos('Z', temp);
   if (temp[1] = 'X') and (py > 0) and (pz > 0)
   and TryStrToInt(Copy(temp, 2, py - 2), x)
   and TryStrToInt(Copy(temp, py + 1, pz - py - 1), y)
   and TryStrToInt(Copy(temp, pz + 1, Length(temp) - pz), z) then begin
     seX.Value:= x;
     seY.Value:= y;
     seZ.Value:= z;
     Exit;
   end;
 end;
 ErrorMsg('Clipboard doesn''t contain valid data!');
end;

procedure PasteCoords(seX, seY, seZ: TfrBetterSpin);
var x, y, z, py, pz: Integer;
    temp: String;
begin
 if Clipboard.HasFormat(CF_TEXT) then begin
   temp:= Copy(Clipboard.AsText, 1, 100); //To avoid hang if clipboard contains lots of data
   py:= Pos('Y', temp);
   pz:= Pos('Z', temp);
   if (temp[1] = 'X') and (py > 0) and (pz > 0)
   and TryStrToInt(Copy(temp, 2, py - 2), x)
   and TryStrToInt(Copy(temp, py + 1, pz - py - 1), y)
   and TryStrToInt(Copy(temp, pz + 1, Length(temp) - pz), z) then begin
     seX.Value:= x;
     seY.Value:= y;
     seZ.Value:= z;
     Exit;
   end;
 end;
 ErrorMsg('Clipboard doesn''t contain valid data!');
end;

function ValueInRange(v: Integer; range: TRange): Boolean; overload;
begin
  Result:= (v >= range.Min) and (v <= range.Max);
end;

function ValueInRange(v: Integer; Min, Max: Integer): Boolean; overload;
begin
  Result:= (v >= Min) and (v <= Max);
end;

function Restrict(v, VMin, VMax: Integer): Integer;
begin
 Result:= Max(Min(v, VMax), VMin);
end;

function StrInArray(s: String; a: array of String): Boolean;
var b: Integer;
begin
 Result:= True;
 for b:= 0 to High(a) do
   if a[b] = s then Exit;
 Result:= False;
end;

function TextInArray(t: String; a: array of String): Boolean;
var b: Integer;
begin
 Result:= True;
 for b:= 0 to High(a) do
   if SameText(a[b], t) then Exit;
 Result:= False;
end;

procedure EnableGroup(Parent: TWinControl; Ena: Boolean);
var a: Integer;
begin
 for a:= 0 to Parent.ControlCount - 1 do
   Parent.Controls[a].Enabled:= Ena;
end;

function EnsureFileExt(FileName, Ext: String): String;
begin
 if not AnsiSameText(ExtractFileExt(FileName), Ext) then
   Result:= FileName + Ext
 else
   Result:= FileName;  
end;

function ListViewRowHeight(lv: TListView): Integer;
begin
 if Assigned(lv.TopItem) then
   Result:= lv.TopItem.DisplayRect(drBounds).Bottom
          - lv.TopItem.DisplayRect(drBounds).Top
 else
   Result:= 1;
end;

procedure ListViewLastColAutosize(lv: TListView);
var lc, a, b: Integer;
begin
 lc:= lv.Columns.Count - 1;
 if (lc >= 0) and (lv.ClientWidth > 0) then begin
   b:= 0;
   for a:= 0 to lc - 1 do
     b:= b + lv.Column[a].Width;
   lv.Column[lc].Width:= lv.ClientWidth - b;
 end;
end;

end.
 