unit ListForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DePack, HQDesc;

type
  TfmList = class(TForm)
    Label1: TLabel;
    lbList: TListBox;
    btOK: TBitBtn;
    btCancel: TBitBtn;
    procedure lbListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lbListDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    Function ShowList(Caption: String; Items: array of String;
     DefSelect: Integer = -1): Integer;
  end;

var
  fmList: TfmList;

function MakeDescriptionList(Path: String; What: TEntriesType;
  Lba1, StartWith1, InclIndexes: Boolean; out IndexList: TIndexList): TStrArray;
function MakeEntryDescriptionList(Path: String; EntryID: Integer;
  Lba1, StartWith1, InclIndexes: Boolean; out IndexList: TIndexList): TStrArray;
function HQRListDialog(Path: String; What: TEntriesType; Lba1, StartWith1, InclIndexes: Boolean;
  Caption: String; DefSelect: Integer = -1): Integer;

implementation

uses Masks;

{$R *.dfm}

Procedure DescriptionsToStrings(descs: THQRDescs; DescMap: TIntArray; List: TIndexList;
  DescOK, Partial, StartWith1, InclIndexes: Boolean; Prefix: String;
  var Names: TStrArray);
var a, b: Integer;
    st: String;
begin
 if StartWith1 then b:= 1 else b:= 0;
 SetLength(Names,Length(List));
 if DescOK then begin
   for a:= 0 to High(List) do begin
     st:= Prefix;
     if InclIndexes then st:= st + IntToStr(List[a] + b) + ': ';
     if List[a] < Length(DescMap) then
       if DescMap[List[a]] > -1 then begin
         st:= st + descs[DescMap[List[a]]].Desc;
         Names[a]:= st;
       end
       else if not Partial then
         Names[a]:= st + '[no description]'
     else if not Partial then
       Names[a]:= st + '[error in description file]';
   end;
 end
 else if not Partial then begin
   for a:= 0 to High(Names) do
     Names[a]:= IntToStr(List[a] + b) + ': [no description]';
 end;
end;

//Returns array of strings containing descriptions of normal entries of specific type.
//The list is consecutive and does not respect real indexes of the entries.
//Out IndexList returns entry index associated with each description.
Function MakeDescriptionListSingle(Path: String; What: TEntriesType;
  Lba1, StartWith1, InclIndexes: Boolean; out IndexList: TIndexList): TStrArray;
var p: TSmallPoint;
    descs: THQRDescs;
    ext: String;
    DescsOK: Boolean;
    DescMap: TIntArray;
begin
 SetLength(IndexList, 0);
 SetLength(Result, 0);
 if FileExists(Path) then begin
   case What of
     etGrids,
     etGridFrag:  if Lba1 then ext:= 'gr1' else ext:= 'gr2';
     etFrags:     ext:= 'grf';
     etLibs:      if Lba1 then ext:= 'bl1' else ext:= 'bl2';
     etBricks:    ext:= 'brk';
     etScenes:    if Lba1 then ext:= 'ls1' else ext:= 'ls2';
     etFile3d:    ext:= '3de';
     etBodies:    if Lba1 then ext:= 'lm1' else ext:= 'lm2';
     etAnims:     if Lba1 then ext:= 'an1' else ext:= 'an2';
     etSprites:   ext:= 'lsp';
     etSamples:   if Lba1 then ext:= 'voc' else ext:= 'wav';
     etModels:    if Lba1 then ext:= 'lm1' else ext:= 'lm2';
   end;
   DescsOK:= LoadHQRDescriptions(Path, ext, descs, DescMap);

   If DescsOK then
     IndexList:= FilterEntriesList(GetNormalEntriesList(Path), descs)
   else begin
     If Lba1 then
       IndexList:= GetNormalEntriesList(Path)
     else begin
       case What of
         etGrids, etFrags, etLibs, etBricks: begin
           //If IsBkg(Path) then begin //matches mask '*lba_bkg*.hqr'
           p:= BkgEntriesCount0(Path, EntriesToInfoType[What]);
           IndexList:= GetNormalEntriesList(Path, p.x, p.y - 1); //get appropriate range only
         end;
         etScenes:
           //if MatchesMask(ExtractFileName(Path), '*scene*.hqr') then
           IndexList:= GetNormalEntriesList(Path, 1);  //skip first entry
         else
           IndexList:= GetNormalEntriesList(Path); //get all
       end;
     end;
   end;
   DescriptionsToStrings(descs, DescMap, IndexList, DescsOK, False, StartWith1, InclIndexes, '', Result);
 end;
end;

function MakeEntryDescriptionList(Path: String; EntryID: Integer;
  Lba1, StartWith1, InclIndexes: Boolean; out IndexList: TIndexList): TStrArray;
var a: Integer;
    descs: THQRDescs;
    DescsOK: Boolean;
    DescMap: TIntArray;
begin
 SetLength(IndexList, 0);
 SetLength(Result, 0);
 if FileExists(Path) then begin
   DescsOK:= LoadHQREntryDescriptions(Path, EntryID, descs, DescMap);
   if DescsOK then begin
     SetLength(IndexList, Length(descs));
     for a:= 0 to High(IndexList) do
       IndexList[a]:= descs[a].Index;
   end;
   DescriptionsToStrings(descs, DescMap, IndexList, DescsOK, False, StartWith1, InclIndexes, '', Result);
 end;
end;

Function MakeDescriptionList(Path: String; What: TEntriesType;
 Lba1, StartWith1, InclIndexes: Boolean; out IndexList: TIndexList): TStrArray;
var a, b: Integer;
    temp: TIndexList;
    temp2: TStrArray;
begin
 if not Lba1 and (What = etGridFrag) then begin  //TODO: It's horribly slow for LBA 2 Grids
   Result:= MakeDescriptionListSingle(Path, etGrids, False, StartWith1, InclIndexes, IndexList);
   //for a:= 0 to High(Result) do
   //  Result[a]:= '[grid] ' + Result[a];
   temp2:= MakeDescriptionListSingle(Path, etFrags, False, StartWith1, InclIndexes, temp);
   b:= Length(IndexList);
   SetLength(IndexList, b + Length(temp));
   for a:= 0 to High(temp) do
     IndexList[a + b]:= temp[a];
   b:= Length(Result);
   SetLength(Result, b + Length(temp2));
   for a:= 0 to High(temp2) do
     Result[a + b]:= {'[fragment] ' +} temp2[a];
 end
 else if not Lba1 and (What = etFile3D) then begin //LBA2 has file3D as an entry of ress.hqr
   Result:= MakeEntryDescriptionList(Path, 44, Lba1, StartWith1, InclIndexes, IndexList);
 end else
   Result:= MakeDescriptionListSingle(Path, What, Lba1, StartWith1, InclIndexes, IndexList);
end;

{Function MakeDescriptionList(Path: String; What: TEntriesType;
 Lba1, RequireHQD: Boolean; out IndexList: TIndexList): TStrArray;
var p: TSmallPoint;
    descs: THQRDescs;
    ext: String;
    DescsOK: Boolean;
begin
 If FileExists(Path) then begin
  If Lba1 then begin
    IndexList:= GetNormalEntriesList(Path);
  end
  else begin
    If IsBkg(Path) then begin
      p:= BkgEntriesCount0(Path, What);
      IndexList:= GetNormalEntriesList(Path, p.x, p.y - 1); //get appropriate range only
    end
    else if MatchesMask(ExtractFileName(Path), '*scene*.hqr') then //skip first entry
      IndexList:= GetNormalEntriesList(Path, 1)
    else
      IndexList:= GetNormalEntriesList(Path); //get all
  end;

  //TODO: Think more about situation when user opens a file with unknown structure
  //      without description file. Program won't be able to determine which entries
  //      match the given entry type (for example in text.hqr, ress.hqr)

  If (What = etGridFrag) and not Lba1 then begin
    DescsOK:= LoadHQRDescriptions(Path,'gr2',descs);
    DescriptionsToStrings(descs, IndexList, DescsOK, False, '[grid] ', Result);
    DescsOK:= LoadHQRDescriptions(Path,'grf',descs);
    DescriptionsToStrings(descs, IndexList, DescsOK, True, '[fragment] ', Result);
  end
  else begin
   case What of
    etGrids,
    etGridFrag:  If Lba1 then ext:= 'gr1' else ext:= 'gr2';
    etFrags:     ext:= 'grf';
    etLibs:      If Lba1 then ext:= 'bl1' else ext:= 'bl2';
    etBricks:    ext:= 'brk';
    etScenes:    If Lba1 then ext:= 'ls1' else ext:= 'ls2';
    etFile3d:    ext:= '3de';
    etBodies:    If Lba1 then ext:= 'lm1' else ext:= 'lm2';
    etAnims:     If Lba1 then ext:= 'an1' else ext:= 'an2';
   end;
   DescsOK:= LoadHQRDescriptions(Path, ext, descs);
   DescriptionsToStrings(descs, IndexList, DescsOK, False, '', Result);
  end;
 end
 else begin
  SetLength(IndexList,0);
  SetLength(Result,0);
 end;
end;}

Function HQRListDialog(Path: String; What: TEntriesType; Lba1, StartWith1, InclIndexes: Boolean;
 Caption: String; DefSelect: Integer = -1): Integer;
var a: Integer;
    List: TIndexList;
    Names: TStrArray;
begin
 Names:= MakeDescriptionList(Path, What, Lba1, StartWith1, InclIndexes, List);

 If DefSelect > -1 then
  for a:= 0 to High(List) do
   If List[a] = DefSelect then begin
    DefSelect:= a;
    Break;
   end;

 a:= fmList.ShowList(Caption, Names, DefSelect);
 If a > -1 then Result:= List[a] else Result:= -1;
end;

Function TfmList.ShowList(Caption: String; Items: array of String;
 DefSelect: Integer = -1): Integer;
var a: Integer;
begin
 Label1.Caption:= Caption;
 lbList.ClearSelection;
 lbList.Clear;
 If Length(Items) < 1 then
  raise EListError.Create('There must be at least one item in the list');
 for a:= 0 to High(Items) do
  lbList.Items.Add(Items[a]);
 If (DefSelect > -1) and (DefSelect < lbList.Count) then
  lbList.ItemIndex:= DefSelect;
 btOK.Enabled:= lbList.ItemIndex > - 1;

 If ShowModal = mrOK then begin
  Result:= lblist.ItemIndex;
 end
 else
  Result:= -1;
end;

procedure TfmList.lbListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 btOK.Enabled:= lbList.ItemIndex > -1; 
end;

procedure TfmList.lbListDblClick(Sender: TObject);
begin
 If lbList.ItemIndex > -1 then ModalResult:= mrOK;
end;

end.
