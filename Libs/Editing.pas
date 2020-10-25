unit Editing;

interface

uses Windows, SysUtils, Settings, Math;

type
 TListEntry = record
   MapPath: String;
   MapIndex: Integer;
   LibPath: String;
   BrickPath: String;
   ScenePath: String;
   Description: String;
   MapEx, LibEx, BrickEx, SceneEx: Boolean;
 end;

 TMapList = array of TListEntry;

const
 MaxUndo = 30;

var
 GridList: TMapList;
 FragList: TMapList;

 XTemp: Integer;
 PathTemp: String;

 GUndoArray: array[1..MaxUndo] of TMapList;
 GUndoState: Integer = 0; //newest undo image index in the UndoArray
 GUndoHigh: Integer = 0; //highest valid image index in UndoArray
 FUndoArray: array[1..MaxUndo] of TMapList;
 FUndoState: Integer = 0;
 FUndoHigh: Integer = 0;

procedure UpdateUndoButtons();
procedure SetUndo(Grid: Boolean);
procedure DoUndo(Grid: Boolean);
procedure DoRedo(Grid: Boolean);
function GetColumn(Grid: Boolean; x: Integer): Integer;
procedure SetListItem(Grid: Boolean; Index, Column: Integer; Path: String;
  Fragment: Integer; SetUndoItem: Boolean = False);
procedure AddFileAuto(Grid: Boolean; Index, x: Integer; Path: String;
  FIndex: Integer);
procedure DeleteSelectedFiles(Grid: Boolean);
procedure MoveSelectedToTop(Grid: Boolean);
procedure MoveSelectedToBottom(Grid: Boolean);
procedure MoveSelectedUp(Grid: Boolean);
procedure MoveSelectedDown(Grid: Boolean);

implementation

uses Main, ComCtrls, Projects, Utils, DePack, Scenario;

procedure UpdateUndoButtons();
begin
 if fmMain.ActiveControl = fmMain.lvGrids then begin
   fmMain.aUndo.Enabled:= GUndoState > 0;
   fmMain.aUndo.Caption:= 'Undo last Grid list edit';
   fmMain.aRedo.Enabled:= GUndoState < GUndoHigh;
   fmMain.aRedo.Caption:= 'Redo Grid list edit';
 end else if fmMain.ActiveControl = fmMain.lvFrags then begin
   fmMain.aUndo.Enabled:= FUndoState > 0;
   fmMain.aUndo.Caption:= 'Undo last Fragment list edit';
   fmMain.aRedo.Enabled:= FUndoState < FUndoHigh;
   fmMain.aRedo.Caption:= 'Redo Fragment list edit';
 end else begin
   fmMain.aUndo.Enabled:= False;
   fmMain.aUndo.Caption:= 'Can''t undo';
   fmMain.aRedo.Enabled:= False;
   fmMain.aRedo.Caption:= 'Can''t redo';
 end;
 fmMain.aUndo.Hint:= fmMain.aUndo.Caption;
 fmMain.aRedo.Hint:= fmMain.aRedo.Caption;
end;

procedure SetUndo(Grid: Boolean);
var a: Integer;
begin
 if Grid then begin
   if GUndoState < MaxUndo then
     Inc(GUndoState)
   else
     for a:= 1 to MaxUndo - 1 do
       GUndoArray[a]:= GUndoArray[a+1];
   GUndoArray[GUndoState]:= Copy(GridList);
   GUndoHigh:= GUndoState;
 end else begin
   if FUndoState < MaxUndo then
     Inc(FUndoState)
   else
     for a:= 1 to MaxUndo - 1 do
       FUndoArray[a]:= FUndoArray[a+1];
   FUndoArray[FUndoState]:= Copy(FragList);
   FUndoHigh:= FUndoState;
 end;
 UpdateUndoButtons();
end;

procedure DoUndo(Grid: Boolean);
var temp: TMapList;
begin
 if Grid then begin
   if GUndoState > 0 then begin
     temp:= Copy(GridList);
     GridList:= Copy(GUndoArray[GUndoState]);
     GUndoArray[GUndoState]:= temp;
     Dec(GUndoState);
     fmMain.lvGrids.Items.Count:= Length(GridList);
     fmMain.lvTest.SetItemCount(Length(GridList));
     fmMain.lvGrids.Repaint();
   end;
 end else begin
   if FUndoState > 0 then begin
     temp:= Copy(FragList);
     FragList:= Copy(FUndoArray[FUndoState]);
     FUndoArray[FUndoState]:= temp;
     Dec(FUndoState);
     fmMain.lvFrags.Items.Count:= Length(FragList);
     fmMain.lvFrags.Repaint();
   end;
 end;
 UpdateUndoButtons();
end;

procedure DoRedo(Grid: Boolean);
var temp: TMapList;
begin
 if Grid then begin
   if GUndoState < GUndoHigh then begin
     Inc(GUndoState);
     temp:= Copy(GridList);
     GridList:= Copy(GUndoArray[GUndoState]);
     GUndoArray[GUndoState]:= temp;
     fmMain.lvGrids.Items.Count:= Length(GridList);
     fmMain.lvTest.SetItemCount(Length(GridList));
     fmMain.lvGrids.Repaint();
   end;
 end else begin
   if FUndoState < FUndoHigh then begin
     Inc(FUndoState);
     temp:= Copy(FragList);
     FragList:= Copy(FUndoArray[FUndoState]);
     FUndoArray[FUndoState]:= temp;
     fmMain.lvFrags.Items.Count:= Length(FragList);
     fmMain.lvFrags.Repaint();
   end;
 end;
 UpdateUndoButtons();
end;

function GetColumn(Grid: Boolean; x: Integer): Integer;
var a, w: Integer;
    col: TListColumns;
begin
 Result:= -1;
 w:= 0;
 if Grid then col:= fmMain.lvGrids.Columns
         else col:= fmMain.lvFrags.Columns;
 for a:= 0 to col.Count - 1 do begin
   w:= w + col.Items[a].Width;
   if x < w then begin
     Result:= a;
     Break;
   end;
 end;
end;

procedure SetListItem(Grid: Boolean; Index, Column: Integer; Path: String;
  Fragment: Integer; SetUndoItem: Boolean = False);
var Info: TScenarioInfo;
    List: TMapList;
begin
 if SetUndoItem then SetUndo(Grid);
 if Grid then List:= GridList else List:= FragList;
 if (Column = 0)
 or (Grid and (Column = 5)) or (not Grid and (Column = 4)) then begin
   List[Index].MapPath:= Path;
   List[Index].MapIndex:= Fragment;
   List[Index].LibPath:= Path;
   List[Index].BrickPath:= Path;
   List[Index].ScenePath:= Path;
 end else begin
   case Column of
     1: begin
          List[Index].MapPath:= Path;
          List[Index].MapIndex:= Fragment;
        end;
     2: begin
          List[Index].LibPath:= Path;
          if SameText(Path, '<B>') then
            List[Index].BrickPath:= '<B>'
          else if SameText(List[Index].BrickPath, '<B>') then
            List[Index].BrickPath:= '';
        end;
     3: begin
          List[Index].BrickPath:= Path;
          If SameText(Path, '<B>') then
            List[Index].LibPath:= '<B>'
          else if SameText(List[Index].LibPath, '<B>') then
            List[Index].LibPath:= '';
        end;
     4: List[Index].ScenePath:= Path;
   end;
 end;  
 CheckExistingLine(Grid, Index);
 if ExtIs(Path, '.hqs')
 and ((Column = 0) or (Column = 1) or (Column = 4) or (Grid and (Column = 5)))
 and (List[Index].Description = '')
 and ReadScenarioInfo(Path, Info) then
   List[Index].Description:= Info.HQSInfo.InfoText;
 if Grid then fmMain.lvGrids.Repaint()
         else fmMain.lvFrags.Repaint();
 SetProjectModified(True);
end;

procedure DeleteListItem(Grid: Boolean; Index: Integer);
var a: Integer;
begin
 if Grid then begin
   if (Index >= 0) and (Index < Length(GridList)) then begin
     for a:= Index to High(GridList) - 1 do
       GridList[a]:= GridList[a + 1];
     SetLength(GridList, High(GridList));
     SetProjectModified(True);
   end;
 end else begin
   if (Index >= 0) and (Index < Length(FragList)) then begin
     for a:= Index to High(FragList) - 1 do
       FragList[a]:= FragList[a + 1];
     SetLength(FragList, High(FragList));
     SetProjectModified(True);
   end;
 end;
end;

procedure AddFile(Grid: Boolean; Column: Integer; Path: String; FIndex: Integer);
//var Temp: TListItem;
begin
 SetUndo(Grid);
 if Grid then begin
   SetLength(GridList, Length(GridList) + 1);
   //Temp:=
   //Form1.lvList.Items.Add();
   fmMain.lvGrids.Items.Count:= Length(GridList);
   fmMain.lvTest.SetItemCount(Length(GridList));
   //Temp.Caption:= IntToStr(Length(TheList));
   //Temp.SubItems.Add('');
   //Temp.SubItems.Add('');
   //Temp.SubItems.Add('');
   //Temp.SubItems.Add('');
   SetListItem(True, High(GridList), Column, Path, 0);
 end else begin
   SetLength(FragList, Length(FragList) + 1);
   fmMain.lvFrags.Items.Count:= Length(FragList);
   SetListItem(False, High(FragList), Column, Path, FIndex);
 end;
end;

procedure InsertFile(Grid: Boolean; Index, Column: Integer; Path: String;
  FIndex: Integer);
var a: Integer;
    Temp: TListItem;
begin
 SetUndo(Grid);
 if Grid then begin
   SetLength(GridList, Length(GridList) + 1);
   for a:= High(GridList) downto Index + 1 do
     GridList[a]:= GridList[a - 1];
   GridList[Index].MapPath:= '';
   GridList[Index].LibPath:= '';
   GridList[Index].BrickPath:= '';
   GridList[Index].ScenePath:= '';
   GridList[Index].Description:= '';
   fmMain.lvGrids.Items.Count:= Length(GridList);
   fmMain.lvTest.SetItemCount(Length(GridList));
 end else begin
   SetLength(FragList, Length(FragList) + 1);
   for a:= High(FragList) downto Index + 1 do
     FragList[a]:= FragList[a - 1];
   FragList[Index].MapPath:= '';
   FragList[Index].MapIndex:= 0;
   FragList[Index].LibPath:= '';
   FragList[Index].BrickPath:= '';
   FragList[Index].Description:= '';
   fmMain.lvFrags.Items.Count:= Length(FragList);
 end;
 SetListItem(Grid, Index, Column, Path, FIndex);
end;

//index jest liczony od zera!
procedure AddFileAuto(Grid: Boolean; Index, x: Integer; Path: String;
  FIndex: Integer);
var a, maxl: Integer;
    List: TMapList;
begin
 if ProjectOptions.General.OverrideFrag then
   maxl:= 256 + ProjectOptions.General.OvFragValue - 1 //Max number of Grids
 else
   maxl:= 256 + 120; //default value
   
 if Grid and (Length(GridList) >= 256) then
   WarningMsg('Project cannot contain more than 256 Grids!')
 else if not Grid and (Length(FragList) >= 256) then
   WarningMsg('Project cannot contain more than 256 Fragments!')
 else if Length(GridList) + Length(FragList) >= maxl then
   WarningMsg('Project cannot contain more than ' + IntToStr(maxl) + ' lines (Grids + Fragments)!')
 else begin
   a:= GetColumn(Grid, x);
   if a > -1 then begin
     if Grid then List:= GridList else List:= FragList;
     if (Index < 0) or (Index >= Length(List)) then
       AddFile(Grid, a, Path, FIndex)
     else
       InsertFile(Grid, Index, a, Path, FIndex);
   end;
 end;
end;

procedure DeleteSelectedFiles(Grid: Boolean);
var a: Integer;
begin
 if Grid then begin
   if fmMain.lvGrids.SelCount > 0 then begin
     if not MainSettings.AskDeletingRow
     or QuestYesNo('Delete selected rows?') then begin
       SetUndo(True);
       for a:= fmMain.lvGrids.Items.Count - 1 downto 0 do
         if fmMain.lvGrids.Items.Item[a].Selected then
           DeleteListItem(True, a);
       if Assigned(fmMain.lvGrids.TopItem) then
         a:= fmMain.lvGrids.TopItem.Index;
       fmMain.lvGrids.Items.Count:= Length(GridList);
       fmMain.lvTest.SetItemCount(Length(GridList));
       if Assigned(fmMain.lvGrids.TopItem) then
         fmMain.lvGrids.Scroll(0, (a-fmMain.lvGrids.TopItem.Index) * ListViewRowHeight(fmMain.lvGrids));
       fmMain.lvGrids.ClearSelection();
       fmMain.lvGrids.Repaint();
     end;
   end;
 end else begin
   if fmMain.lvFrags.SelCount > 0 then begin
     if not MainSettings.AskDeletingRow
     or QuestYesNo('Delete selected rows?') then begin
       SetUndo(False);
       for a:= fmMain.lvFrags.Items.Count - 1 downto 0 do
         if fmMain.lvFrags.Items.Item[a].Selected then
           DeleteListItem(False, a);
       if Assigned(fmMain.lvFrags.TopItem) then
         a:= fmMain.lvFrags.TopItem.Index;
       fmMain.lvFrags.Items.Count:= Length(FragList);
       if Assigned(fmMain.lvFrags.TopItem) then
         fmMain.lvFrags.Scroll(0, (a-fmMain.lvFrags.TopItem.Index) * ListViewRowHeight(fmMain.lvFrags));
       fmMain.lvFrags.ClearSelection();
       fmMain.lvFrags.Repaint();
     end;
   end;
 end;
end;

procedure MoveSelectedToTop(Grid: Boolean);
var a, b, c: Integer;
    Temp: TListEntry;
begin
 if Grid then begin
   if fmMain.lvGrids.SelCount > 0 then begin
     SetUndo(True);
     c:= 0;
     for a:= 0 to fmMain.lvGrids.Items.Count - 1 do
       If fmMain.lvGrids.Items.Item[a].Selected then begin
         Temp:= GridList[a];
         for b:= a downto c + 1 do
           GridList[b]:= GridList[b - 1];
         GridList[c]:= Temp;
         fmMain.lvGrids.Items.Item[a].Selected:= False;
         fmMain.lvGrids.Items.Item[c].Selected:= True;
         Inc(c);
       end;
   end;
 end else begin
   if fmMain.lvFrags.SelCount > 0 then begin
     SetUndo(False);
     c:= 0;
     for a:= 0 to fmMain.lvFrags.Items.Count - 1 do
       If fmMain.lvFrags.Items.Item[a].Selected then begin
         Temp:= FragList[a];
         for b:= a downto c + 1 do
           FragList[b]:= FragList[b - 1];
         FragList[c]:= Temp;
         fmMain.lvFrags.Items.Item[a].Selected:= False;
         fmMain.lvFrags.Items.Item[c].Selected:= True;
         Inc(c);
       end;
   end;
 end;
 SetProjectModified(True);
end;

procedure MoveSelectedToBottom(Grid: Boolean);
var a, b, c: Integer;
    Temp: TListEntry;
begin
 if Grid then begin
   if fmMain.lvGrids.SelCount > 0 then begin
     SetUndo(True);
     c:= fmMain.lvGrids.Items.Count - 1;
     for a:= c downto 0 do
       if fmMain.lvGrids.Items.Item[a].Selected then begin
         Temp:= GridList[a];
         for b:= a to c - 1 do
           GridList[b]:= GridList[b + 1];
         GridList[c]:= Temp;
         fmMain.lvGrids.Items.Item[a].Selected:= False;
         fmMain.lvGrids.Items.Item[c].Selected:= True;
         Dec(c);
       end;
   end;
 end else begin
   if fmMain.lvFrags.SelCount > 0 then begin
     SetUndo(False);
     c:= fmMain.lvFrags.Items.Count - 1;
     for a:= c downto 0 do
       if fmMain.lvFrags.Items.Item[a].Selected then begin
         Temp:= FragList[a];
         for b:= a to c - 1 do
           FragList[b]:= FragList[b + 1];
         FragList[c]:= Temp;
         fmMain.lvFrags.Items.Item[a].Selected:= False;
         fmMain.lvFrags.Items.Item[c].Selected:= True;
         Dec(c);
       end;
   end;
 end;
 SetProjectModified(True);
end;

procedure MoveSelectedUp(Grid: Boolean);
var a: Integer;
    Temp: TListEntry;
begin
 if Grid then begin
   if fmMain.lvGrids.SelCount > 0 then begin
     SetUndo(True);
     for a:= 0 to fmMain.lvGrids.Items.Count - 1 do
       if fmMain.lvGrids.Items.Item[a].Selected
       and (a > 0) and not fmMain.lvGrids.Items.Item[a - 1].Selected then begin
         Temp:= GridList[a];
         GridList[a]:= GridList[a - 1];
         GridList[a - 1]:= Temp;
         fmMain.lvGrids.Items.Item[a].Selected:= False;
         fmMain.lvGrids.Items.Item[a - 1].Selected:= True;
       end;
   end;
 end else begin
   if fmMain.lvFrags.SelCount > 0 then begin
     SetUndo(False);
     for a:= 0 to fmMain.lvFrags.Items.Count - 1 do
       if fmMain.lvFrags.Items.Item[a].Selected
       and (a > 0) and not fmMain.lvFrags.Items.Item[a - 1].Selected then begin
         Temp:= FragList[a];
         FragList[a]:= FragList[a - 1];
         FragList[a - 1]:= Temp;
         fmMain.lvFrags.Items.Item[a].Selected:= False;
         fmMain.lvFrags.Items.Item[a - 1].Selected:= True;
       end;
   end;
 end;
 SetProjectModified(True);
end;

procedure MoveSelectedDown(Grid: Boolean);
var a, c: Integer;
    Temp: TListEntry;
begin
 if Grid then begin
   if fmMain.lvGrids.SelCount > 0 then begin
     SetUndo(True);
     c:= fmMain.lvGrids.Items.Count - 1;
     for a:= c downto 0 do
       if fmMain.lvGrids.Items.Item[a].Selected
       and (a < c) and not fmMain.lvGrids.Items.Item[a + 1].Selected then begin
         Temp:= GridList[a];
         GridList[a]:= GridList[a + 1];
         GridList[a + 1]:= Temp;
         fmMain.lvGrids.Items.Item[a].Selected:= False;
         fmMain.lvGrids.Items.Item[a + 1].Selected:= True;
       end;
   end;
 end else begin
   if fmMain.lvFrags.SelCount > 0 then begin
     SetUndo(False);
     c:= fmMain.lvFrags.Items.Count - 1;
     for a:= c downto 0 do
       if fmMain.lvFrags.Items.Item[a].Selected
       and (a < c) and not fmMain.lvFrags.Items.Item[a + 1].Selected then begin
         Temp:= FragList[a];
         FragList[a]:= FragList[a + 1];
         FragList[a + 1]:= Temp;
         fmMain.lvFrags.Items.Item[a].Selected:= False;
         fmMain.lvFrags.Items.Item[a + 1].Selected:= True;
       end;
   end;
 end;
 SetProjectModified(True);
end;

end.
