unit StrData;

interface

uses Windows, Classes, SysUtils;

type
 TStrData = Object
  Pos: Int64;
  Data: String;
  Size: Int64;
  Function ReadByte: Byte;
  Function ReadWord: Word;
  Function ReadDword: DWord;
  Function Read(count: Int64): String;
  Procedure Seek(NewPos: Int64);
  Constructor Create(source: String); overload;
  Constructor Create(source: TStream); overload;
  Constructor CreateFromFile(path: String);
  Destructor Destroy;
 end;

implementation



{ TStrData }

constructor TStrData.Create(source: TStream);
begin
 Size:=source.Size;
 SetLength(Data,Size);
 source.Seek(0,soBeginning);
 source.Read(Data[1],Size);
 Pos:=0;
end;

constructor TStrData.Create(source: String);
begin
 Size:=Length(source);
 Data:=source;
 Pos:=0
end;

constructor TStrData.CreateFromFile(path: String);
var f: File;
begin
 AssignFile(f,path);
 FileMode:=fmOpenRead;
 Reset(f,1);
 Size:=FileSize(f);
 SetLength(Data,Size);
 BlockRead(f,Data[1],Size);
 CloseFile(f);
 Pos:=0;
end;

destructor TStrData.Destroy;
begin
 SetLength(Data,0);
 Size:=0;
end;

function TStrData.Read(count: Int64): String;
begin
 Result:=Copy(Data,Pos+1,count);
 Inc(Pos,count);
end;

function TStrData.ReadByte: Byte;
begin
 Result:=Byte(Data[Pos+1]);
 Inc(Pos);
end;

function TStrData.ReadDword: DWord;
begin
 Result:=DWord(Copy(Data,Pos+1,10));
 Inc(Pos,4);
end;

function TStrData.ReadWord: Word;
begin
 Result:=DWord(Copy(Data,Pos+1,2));
 Inc(Pos,2);
end;

procedure TStrData.Seek(NewPos: Int64);
begin
 Pos:=NewPos;
end;

end.
 