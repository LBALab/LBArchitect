unit HQDOut;

interface

uses SysUtils, Classes;

type
  THQDEntry = record
    Index: Integer;
    Extension: String;
    Description: String;
  end;

  TEntryType = (etNormal, etRepeated, etBlank);

  THQDCreator = class(TObject)
  private
    FDescription: String;
    FNormal: Integer;
    FRepeated: Integer;
    FBlank: Integer;
    FMask: String;
    FEntries: array of THQDEntry;
    function GetEntry(Index: Integer): THQDEntry;
    function GetCount(): Integer;
  public
    constructor Create(); overload;
    constructor Create(Desc: String; Mask: String = '*'); overload;
    procedure Clear();
    procedure AddEntry(EType: TEntryType; Index: Integer;
      Extension, Description: String);
    function SaveToFile(path: String): Boolean;

    property Description: String read FDescription write FDescription;
    property Normal: Integer read FNormal;
    property Repeated: Integer read FRepeated;
    property Blank: Integer read FBlank;
    property Count: Integer read GetCount;
    property Mask: String read FMask write FMask;
    property Entry[Index: Integer]: THQDEntry read GetEntry; default;
  end;

implementation

{ THQDCreator }

constructor THQDCreator.Create();
begin
 inherited;
 FMask:= '*';
 Clear();
end;

constructor THQDCreator.Create(Desc: String; Mask: String = '*');
begin
 Create();
 FDescription:= Desc;
 FMask:= Mask;
end;

function THQDCreator.GetEntry(Index: Integer): THQDEntry;
begin
 Result:= FEntries[Index];
end;

function THQDCreator.GetCount(): Integer;
begin
 Result:= Length(FEntries);
end;

procedure THQDCreator.Clear();
begin
 FNormal:= 0;
 FRepeated:= 0;
 FBlank:= 0;
 SetLength(FEntries, 0);
end;

procedure THQDCreator.AddEntry(EType: TEntryType; Index: Integer; Extension,
  Description: String);
var h: Integer;
begin
 if EType = etBlank then
   Inc(FBlank)
 else begin
   h:= Length(FEntries);
   SetLength(FEntries, h + 1);
   FEntries[h].Index:= Index;
   FEntries[h].Extension:= Extension;
   FEntries[h].Description:= Description;
   case EType of
     etNormal: Inc(FNormal);
     etRepeated: Inc(FRepeated);
   end;
 end;
end;

function THQDCreator.SaveToFile(path: String): Boolean;
var st: TStringList;
    a: THQDEntry;
begin
 Result:= False;
 try
   try
     st:= TStringList.Create();
     st.Add(FDescription);
     st.Add(IntToStr(FNormal + FRepeated + FBlank));
     st.Add(IntToStr(FNormal));
     st.Add(IntToStr(FRepeated));
     st.Add(IntToStr(FBlank));
     st.Add(FMask);
     st.Add('Reserved');
     st.Add('Reserved');
     st.Add('Reserved');
     st.Add('Reserved');
     for a in FEntries do
       st.Add(Format('%d:%s|%s', [a.Index, a.Extension, a.Description]));
     st.SaveToFile(path);  
     Result:= True;
   finally
     FreeAndNil(st);
   end;
 except
 end;
end;

end.
