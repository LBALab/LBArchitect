unit Building;

interface

uses Windows, Projects, Editing, DePack, SysUtils, Libraries, ProgBar,
     HQDOut;

Procedure BuildProject();

implementation

uses Main, Settings, Utils, Scenario;

var
  RepCount: Integer;
  BlankCount: Integer;
  Comp1Count: Integer;
  Comp2Count: Integer;

Function CheckFiles(): Boolean;
var a: Integer;
    G, F: Boolean;
begin
 G:= True;
 F:= True;
 //todo: Modify this to work depending on Project type (LBA 1 or 2)
 for a:= 0 to High(GridList) do
   if not CheckExistingLine(True, a) then G:= False;
   //Don't exit when found to mark all cells
 for a:= 0 to High(FragList) do
   if not CheckExistingLine(False, a) then F:= False;

 if not G then
   WarningMsg('Some of the reqiured files in the Grids List don''t exist, have invalid'
            + ' extensions, or invalid paths. Compilation cannot be performed until'
            + ' all files are valid.'#13#13'Invalid cells have been marked in red.')
 else if not F then //show only one message at a time
   WarningMsg('Some of the reqiured files in the Fragments List don''t exist, have invalid'
            + ' extensions, or invalid paths. Compilation cannot be performed until'
            + ' all files are valid.'#13#13'Invalid cells have been marked in red.');
 Result:= G and F;
end;

Function LoadFileToString(path: String; var data: String): Boolean;
var f: file;
begin
 Result:= False;
 AssignFile(f, path);
 FileMode:= fmOpenRead;
 Reset(f, 1);
 try
   SetLength(data, FileSize(f));
   BlockRead(f, data[1], FileSize(f));
   Result:= True;
 finally
   CloseFile(f);
 end;
end;

//Checks if there is already an entry in Pack identical to the data
//All pack entries must be uncompressed!
Function FindMatchingEntry(Pack: TPackEntries; data: String): Integer;
var a: Integer;
begin
 for a:= 0 to High(Pack) do
   if Pack[a].Data = data then begin
     Result:= a;
     Exit;
   end;
 Result:= -1; //not found  
end;

//Adds a TPackEntry trying to add it as a repeated entry (if option checked)
//Returns created entry index
function AddEntry(var Pack: TPackEntries; data: String; SkipRep: Boolean;
  out Repeated: Boolean): Integer;
var a: Integer;
begin
 if ProjectOptions.Optimizations.UseRepeated and not SkipRep
 and not ProjectOptions.General.CompOptOff then
   a:= FindMatchingEntry(Pack, data)
 else
   a:= -1;
 Result:= Length(Pack);
 SetLength(Pack, Result + 1);
 Pack[Result]:= PackEntry(data, a);
 If a > -1 then Inc(RepCount);
end;

Procedure AddBlankEntry(var Pack: TPackEntries);
begin
 SetLength(Pack, Length(Pack) + 1);
 Pack[High(Pack)]:= PackEntry('', -2);
 Inc(BlankCount);
end;

//Compresses the entry according to the options set
//The entry must not have been compressed yet!
procedure CompressEntry(var Entry: TPackEntry);
var TempComp: TPackEntry;
begin
 if not ProjectOptions.General.CompOptOff then begin
   if ProjectOptions.Compression.Lba1 = 1 then begin
     Entry:= PackEntry(Entry.Data, -1, 1);
     Inc(Comp1Count);
   end
   else if ProjectOptions.Compression.Lba1 = 3 then begin
     TempComp:= PackEntry(Entry.Data, -1, 1);
     if TempComp.CpSize > 0 then begin   //just in case
       if ((ProjectOptions.Compression.MinSizeBenUnit = 0) // %
           and ((1 - (TempComp.CpSize / TempComp.RlSize)) * 100 >=
                ProjectOptions.Compression.MinSizeBenVal))
       or ((ProjectOptions.Compression.MinSizeBenUnit = 1) // kB
           and (Integer(TempComp.RlSize - TempComp.CpSize) >=
                ProjectOptions.Compression.MinSizeBenVal * 1024))
       then begin
         Entry:= TempComp;
         Inc(Comp1Count);
       end;
     end;
   end;
 end;
end;

Procedure BuildError(Errno: Integer; Grids: Boolean; Line: Integer = -1; path: String = '');
var b, s: String;
begin
 case Errno of
    1: s:= 'File not found or invalid path!'#13#13'The path is: ' + path;
    2: s:= 'Cannot access file for reading!'#13#13'The file is: ' + path;
    3: s:= 'Output Grid HQR file path is empty!';
    4: s:= 'Output Library HQR file path is empty!';
    5: s:= 'Output Brick HQR file path is empty!';
    6: s:= 'Output Scene HQR file path is empty!';
    7: s:= 'Too many Grids in the list!'#13'The maximum number of Grids is 256.';
    8: s:= 'Too many Fragments in the list!'#13'The maximum number of Fragments is 256.';
    9: s:= 'Too many automatic Fragments!'#13'Fragments for automatic creation from the used Grids exceed the maximum number of Fragments, which is 256.'#13#13
         + 'There are ' + path + ' Auto-Framgent(s) that can''t make it into the compilation';
   10: s:= 'Grid file has invalid extension!'#13#13'Valid Grid extensions are .gr1 and .hqs.';
   11: s:= 'Library file has invalid extension!'#13#13'Valid Library extensions are .bl1 and .hqs.';
   12: s:= 'Brick file has invalid extension!'#13#13'Valid Brick extensions are .hqr and .hqs.';
   13: s:= 'Scene file has invalid extension!'#13#13'Valid Scene extensions are .ls1 and .hqs.';
   20: s:= 'Scenario file does not contain specified map!'#13#13'The Scenario path is: ' + path;
   21: s:= 'Scenario file does not contain any Library!'#13#13'The Scenario path is: ' + path;
   22: s:= 'Scenario file contains no Bricks!'#13#13'The Scenario path is: ' + path;
   23: s:= 'Scenario file does not contain Binary Scene!'#13#13'The Scenario path is: ' + path;
   24: s:= 'An error occured while extracting Map from the Scenario! The Scenario may be corrupted.'#13#13
         + 'The Scenario Path is: ' + path;
   25: s:= 'An error occured while reading data from the Scenario! The Scenario may be corrupted.'#13#13
         + 'The Scenario Path is: ' + path;
   26: s:= 'Too many Bricks!'#13'Used Grids and Fragments contain too many Bricks. The maximum number of Bricks is 65535.'#13'Enabling removing the doubled Bricks feature (Project options -> Optimizations) may solve the problem.';
   30: s:= 'Scenario file is not of LBA 1 type!'#13#13'The Scneario path is: ' + path;
   31: s:= 'Scenario file is not of LBA 2 type!'#13#13'The Scneario path is: ' + path;
   40: s:= 'Library is not consistent with the Bricks!'#13'(Library references non-existing Bricks)';
   50: s:= 'Error during writing the Grid HQR file!'#13#13'File path is: ' + path;
   51: s:= 'Error during writing the Library HQR file!'#13#13'File path is: ' + path;
   52: s:= 'Error during writing the Brick HQR file!'#13#13'File path is: ' + path;
   53: s:= 'Error during writing the Scene HQR file!'#13#13'File path is: ' + path;
   54: s:= 'Error during writing HQD file for: ' + path;
   60: s:= 'There are no Grid rows defined!';
   61: s:= 'Too many rows defined!'#13'Maximum number of rows is determined by first Fragment index (see Project Options).';
   62: s:= 'Too many automatic Fragments!'#13'Fragments for automatic creation from the used Grids exceed the maximum number of all maps (Grids + Fragments), which is determined by first Fragment index (see Project Options).'#13#13
         + 'There are ' + path + ' Auto-Framgent(s) that can''t make it into the compilation';
   else s:= 'Unknown error';
 end;
 if Line > -1 then begin
   if Grids then b:= 'Grid list'
            else b:= 'Fragment list';
   if not MainSettings.StartZero then Inc(Line);
   b:= b + ', line ' + IntToStr(Line) + ': ' + s;
 end else
   b:= s;
 ErrorMsg(b);
 ProgBarForm.CloseSpecial();
 Abort();
end;

//Index = 0 means Main Grid
function AddGriEntry(var Pack: TPackEntries; Grids: Boolean;
  Line: Integer; Path: String; Index: Integer; out EType: TEntryType): Boolean;
var data: String;
    TmScenario: TPackEntries;
    Repeated: Boolean;
begin
 Result:= False;
 EType:= etNormal;
 if SameText(Path, '<B>') then begin
   AddBlankEntry(Pack);
   EType:= etBlank;
   Result:= True;
 end else begin
   if FileExists(Path) then begin
     if ExtIs(Path, '.gr1') then begin
       if LoadFileToString(Path, data) then begin
         AddEntry(Pack, data, False, Repeated);
         if Repeated then EType:= etRepeated;
         Result:= True;
       end else
         BuildError(2, Grids, Line, Path);
     end
     else if ExtIs(Path, '.hqs') then begin
       if OpenPack(Path, TmScenario) then
         if ScenarioIsLba1(TmScenario) then
           if ScenarioHasMap(TmScenario, Index) then
             if GetScenarioMap(TmScenario, Index, data) then begin
               AddEntry(Pack, data, False, Repeated);
               if Repeated then EType:= etRepeated;
               Result:= True;
             end else
               BuildError(24, Grids, Line, Path)
           else
             BuildError(20, Grids, Line, Path)
         else
           BuildError(30, Grids, Line, Path)
       else
         BuildError(2, Grids, Line, Path);
     end else
       BuildError(10, Grids, Line);
   end else
     BuildError(1, Grids, Line, Path);
 end;
end;

function CreateLibEntryAndBricks(var Lib: String; var BrkPack: TPackEntries;
  Grids: Boolean; Line: Integer; LibPath, BrkPath: String): Boolean;
var TmBricks: TPackEntries;   // temporary bricks
    data: String;
    TempLib: TLibrary;       // temporary library
    TmScenario: TPackEntries;
    b, c, bh, pbl, bi, bm: Integer;
    ScInfo: TScenarioInfo;
    Dummy: Boolean;
begin
 Result:= False;
 if SameText(LibPath, '<B>') then begin
   //AddBlankEntry(LibPack);
   Lib:= '';
   Result:= True;
 end else begin
   //Library
   if FileExists(LibPath) then begin
     if ExtIs(LibPath, '.bl1') then begin
       if not LoadFileToString(LibPath, data) then
         BuildError(2, Grids, Line, LibPath);
     end
     else if ExtIs(LibPath, '.hqs') then begin
       if OpenPack(LibPath, TmScenario) then
         if ReadScenarioInfo(TmScenario, ScInfo) then
           if not ScInfo.HQSInfo.Lba2 then
             if TmScenario[ScLibraryEntry].FType = -1 then
               data:= UnpackToString(TmScenario[ScLibraryEntry])
             else
               BuildError(21, Grids, Line, LibPath)
           else
             BuildError(30, Grids, Line, LibPath)
         else
           BuildError(25, Grids, Line, LibPath)
       else
         BuildError(2, Grids, Line, LibPath);
     end else
       BuildError(11, Grids, Line);
   end else
     BuildError(1, Grids, Line, LibPath);

   //Bricks
   if FileExists(BrkPath) then begin
     if ExtIs(BrkPath, '.hqr') then b:= -1
     else if ExtIs(BrkPath, '.hqs') then begin
       if ReadScenarioInfo(BrkPath, ScInfo) then
         if not ScInfo.HQSInfo.Lba2 then
           b:= ScInfo.HQSInfo.FirstBrick
         else
           BuildError(30, Grids, Line, BrkPath)
       else
         BuildError(25, Grids, Line, BrkPath);
     end else
       BuildError(12, Grids, Line);
     if OpenPack(BrkPath, TmBricks, b, -1) then begin
       if Length(TmBricks) < 1 then
         BuildError(22, Grids, Line, BrkPath);
     end else
       BuildError(2, Grids, Line, BrkPath);
   end else
     BuildError(1, Grids, Line, BrkPath);

   //Matching Lib and Brk (copying used Brk from TmBricks to BrkPack)
   TempLib:= LoadLibraryFromString2(data);
   bh:= High(TmBricks);
   pbl:= Length(BrkPack);
   for b:= 0 to High(TempLib) do begin
     for c:= 0 to High(TempLib[b].Map) do begin
       bi:= TempLib[b].Map[c].Index - 1; //Brick indexes in Layouts start with 1 !
       if (bi >= 0) and (bi <= bh) then begin
         bm:= -1;
         UnpackSelf(TmBricks[bi]);
         if not ProjectOptions.General.CompOptOff
         and ProjectOptions.Optimizations.BricksRemoveDoubled then
           bm:= FindMatchingEntry(BrkPack, TmBricks[bi].Data);
         if bm < 0 then begin
          { bm:= Length(BrkPack);
           if ProjectOptions.Optimizations.BricksRemoveDoubled then begin
             SetLength(PkBricks, Length(PkBricks) + 1);
             PkBricks[High(PkBricks)]:= PackEntry(TmBricks[bi].Data);
           end else}
           bm:= AddEntry(BrkPack, TmBricks[bi].Data, True, Dummy); //Skip repeated creation
         end;
         if (bm >= 65535) then BuildError(26, Grids, Line);
         TempLib[b].Map[c].Index:= bm + 1;
       end
       else if (bi > bh) then
         BuildError(40, True, Line);
     end;
   end;
   //AddEntry(LibPack, LibraryToString(TempLib), False);
   Lib:= LibraryToString(TempLib);
   Result:= True;
 end;
end;

function AddLibEntryAndBricks(var LibPack, BrkPack: TPackEntries;
  Grids: Boolean; Line: Integer; LibPath, BrkPath: String;
  out LibType: TEntryType): Boolean;
var temp: String;
    Repeated: Boolean;
begin
 Result:= False;
 LibType:= etNormal;
 if CreateLibEntryAndBricks(temp, BrkPack, Grids, Line, LibPath, BrkPath)
 then begin
   if temp = '' then begin
     AddBlankEntry(LibPack);
     LibType:= etBlank;
   end else begin
     AddEntry(LibPack, temp, False, Repeated);
     if Repeated then LibType:= etRepeated;
   end;
   Result:= True;
 end;
end;  

function AddSceEntry(var Pack: TPackEntries; Line: Integer; Path: String;
  out EType: TEntryType): Boolean;
var data: String;
    TmScenario: TPackEntries;
    Repeated: Boolean;
begin
 Result:= False;
 EType:= etNormal;
 if SameText(Path, '<B>') then begin
   AddBlankEntry(Pack);
   EType:= etBlank;
   Result:= True;
 end else begin
   if FileExists(Path) then begin
     if ExtIs(Path, '.ls1') then begin
       if LoadFileToString(Path, data) then begin
         AddEntry(Pack, data, False, Repeated);
         if Repeated then EType:= etRepeated;
         Result:= True;
       end else
         BuildError(2, True, Line, Path);
     end
     else if ExtIs(Path, '.hqs') then begin
       if OpenPack(Path, TmScenario) then
         if ScenarioIsLba1(TmScenario) then
           if (TmScenario[ScSceneBinEntry].FType = -1) then begin
             AddEntry(Pack, UnpackToString(TmScenario[ScSceneBinEntry]), False,
               Repeated);
             if Repeated then EType:= etRepeated;
             Result:= True;
           end else
             BuildError(23, True, Line, Path)
         else
           BuildError(30, True, Line, Path)
       else
         BuildError(2, True, Line, Path);
     end else
       BuildError(13, True, Line);
   end else
     BuildError(1, True, Line, Path);
 end;
end;

Procedure BuildProject();
var PkGrids, PkBricks, PkLibs, PkScenes: TPackEntries;
    HqGrids, HqLibs, HqScenes: THQDCreator;
    TmScenario: TPackEntries; // temporary scenario
    TmFrags, TmFragLibs, TmFragDescs: array of String;
    a, b, c, d, e, FirstFrag, GLen, FLen, tfh, FirstAutoFrag, rgc, rfc: Integer;
    TmInfo: TScenarioInfo;
    data, sdata: String;
    et: TEntryType;
    Repeated: Boolean;
begin
 SetLength(PkBricks, 0);
 SetLength(PkLibs, 0);
 SetLength(PkGrids, 0);
 SetLength(PkScenes, 0);
 SetLength(TmScenario, 0);

 tfh:= -1;
 SetLength(TmFrags, 0);
 SetLength(TmFragLibs, 0);
 SetLength(TmFragDescs, 0);

 RepCount:= 0;
 BlankCount:= 0;
 Comp1Count:= 0;
 Comp2Count:= 0;

 try
   HqGrids:= THQDCreator.Create('Isometric room construction data');
   HqLibs:= THQDCreator.Create('Isometric room construction objects');
   HqScenes:= THQDCreator.Create('Interactive room elements and scripting');

   if CheckFiles() then begin
     if Length(GridList) <= 0 then BuildError(60, True);
     if (ProjectOptions.Output.Lba1OutputGrid
       and (ProjectOptions.Output.Lba1GridPath = '')) then BuildError(3, True);
     if ProjectOptions.Output.Lba1OutputLibBrk then begin
       if ProjectOptions.Output.Lba1LibraryPath = '' then BuildError(4, True);
       if ProjectOptions.Output.Lba1BrickPath = '' then BuildError(5, True);
     end;
     if (ProjectOptions.Output.OutputScene
       and (ProjectOptions.Output.ScenePath = '')) then BuildError(6, True);

     if ProjectOptions.General.OverrideFrag then
       FirstFrag:= ProjectOptions.General.OvFragValue - 1 //counting from 0
     else
       FirstFrag:= 120;

     GLen:= Length(GridList);
     FLen:= Length(FragList);
     if GLen <= FirstFrag then
       FirstAutoFrag:= FLen
     else
       FirstAutoFrag:= FLen + GLen - FirstFrag;

     if GLen > 256 then BuildError(7, True);
     if FLen > 256 then BuildError(8, True);
     if GLen + FLen > 256 + FirstFrag then BuildError(61, True);

     ProgBarForm.ShowSpecialBar('Building base entries...', fmMain, False, 0, GLen + FLen - 1);

     //Grid list (plus creating Auto-Fragments in the separate list):
     rgc:= 0; //Real Grid Count
     for a:= 0 to GLen - 1 do begin
       //Map
       if ProjectOptions.Output.Lba1OutputGrid then begin
         if not AddGriEntry(PkGrids, True, a, GridList[a].MapPath, 0, et) then
           Break;
         if et = etNormal then Inc(rgc);
         HqGrids.AddEntry(et, a, 'gr1', GridList[a].Description);
       end;

       //Library and Bricks
       if ProjectOptions.Output.Lba1OutputLibBrk then begin
         if not AddLibEntryAndBricks(pkLibs, PkBricks, True, a,
                  GridList[a].LibPath, GridList[a].BrickPath, et)
         then
           Break;
         HqLibs.AddEntry(et, a, 'bl1', GridList[a].Description);
       end;

       //AutoFragments
       if ProjectOptions.General.AutoFragment
       and ExtIs(GridList[a].MapPath, '.hqs')
       and SameText(GridList[a].MapPath, GridList[a].ScenePath)
       and OpenPack(GridList[a].MapPath, TmScenario)
       and ReadScenarioInfo(GridList[a].MapPath, TmInfo) then begin

         if ProjectOptions.Output.OutputScene then begin
           if TmScenario[ScSceneBinEntry].FType = -1 then
             sdata:= UnpackToString(TmScenario[ScSceneBinEntry])
           else
             BuildError(23, True, a, GridList[a].ScenePath);
         end;

         for c:= 0 to TmInfo.HQSInfo.FragmentCount - 1 do
           if Length(TmInfo.FragData[c]) > 0 then begin //Add Fragment only if actually used
             if not GetScenarioMap(TmScenario, c + 1, data) then
               BuildError(24, True, a, GridList[a].MapPath);
             //d:= AddEntry(TmFrags, data, False);
             Inc(tfh);
             SetLength(TmFrags, tfh + 1);
             TmFrags[tfh]:= data;
             SetLength(TmFragLibs, tfh + 1);
             if not CreateLibEntryAndBricks(TmFragLibs[tfh], PkBricks, True, a,
                      GridList[a].LibPath, GridList[a].BrickPath)
             then
               Break;
             SetLength(TmFragDescs, tfh + 1);
             if Trim(GridList[a].Description) <> '' then
               TmFragDescs[tfh]:= 'Fragment of ' + GridList[a].Description
             else
               TmFragDescs[tfh]:= 'Fragment of #' + IntToStr(a);
             //Modify Scene
             if ProjectOptions.Output.OutputScene then begin
               for e:= 0 to High(TmInfo.FragData[c]) do
                 sdata[TmInfo.FragData[c,e]+1]:= Char(FirstAutoFrag + tfh); //replace with real Fragment index
             end;
           end;
         //Create entry with modified Scene:
         if ProjectOptions.Output.OutputScene then
           AddEntry(PkScenes, sdata, False, Repeated);
         if Repeated then et:= etRepeated else et:= etNormal;
         HqScenes.AddEntry(et, a, 'ls1', GridList[a].Description);
       end else begin
         //Regular Scene
         if ProjectOptions.Output.OutputScene then begin
           if not AddSceEntry(PkScenes, a, GridList[a].ScenePath, et) then Break;
           HqScenes.AddEntry(et, a, 'ls1', GridList[a].Description);
         end;
       end;

       ProgBarForm.UpdateBar(a);
     end;

     if (FLen > 0) or (Length(TmFrags) > 0) then
       for a:= GLen to FirstFrag - 1 do begin //Gap between last Grid and first Fragment
         AddBlankEntry(PkGrids);
         HqGrids.AddEntry(etBlank, a, '', '');
         AddBlankEntry(PkLibs);
         HqLibs.AddEntry(etBlank, a, '', '');
       end;

     //Fragment list (manual Fragments):
     rfc:= 0; //Real Fragment Count
     if FLen + tfh + 1 > 256 then
       BuildError(9, True, -1, IntToStr(FLen + tfh + 1 - 256))
     else if GLen + FLen + tfh + 1 > 256 + FirstFrag then
       BuildError(62, True, -1, IntToStr(GLen + FLen + tfh + 1 - 256 - FirstFrag));

     if FLen > 0 then begin
       for a:= 0 to FLen - 1 do begin
         //Map
         if ProjectOptions.Output.Lba1OutputGrid then begin
           if not AddGriEntry(PkGrids, False, a, FragList[a].MapPath,
                    FragList[a].MapIndex, et)
           then
             Break;
           if et = etNormal then Inc(rfc);  
           HqGrids.AddEntry(et, FirstFrag + a, 'gr1', FragList[a].Description);
         end;

         //Library and Bricks
         if ProjectOptions.Output.Lba1OutputLibBrk then begin
           if not AddLibEntryAndBricks(PkLibs, PkBricks, False, a,
                    FragList[a].LibPath, FragList[a].BrickPath, et)
           then
             Break;
           HqLibs.AddEntry(et, FirstFrag + a, 'bl1', FragList[a].Description);
         end;

         ProgBarForm.UpdateBar(GLen + a);
       end;
     end;
     ProgBarForm.CloseSpecial();

     //And in the end - add automatic Fragments:
     ProgBarForm.ShowSpecialBar('Building Auto-Fragments...', fmMain, False, 0, tfh);
     if tfh + 1 > 0 then
       for a:= 0 to High(TmFrags) do begin
         //Map
         if ProjectOptions.Output.Lba1OutputGrid then begin
           AddEntry(PkGrids, TmFrags[a], False, Repeated);
           if Repeated then et:= etRepeated else et:= etNormal;
           HqGrids.AddEntry(et, FirstFrag + FLen + a, 'gr1', TmFragDescs[a]);
         end;
         //Library and Bricks
         if ProjectOptions.Output.Lba1OutputLibBrk then begin
           if TmFragLibs[a] = '' then begin
             AddBlankEntry(PkLibs);
             et:= etBlank;
           end else begin
             AddEntry(PkLibs, TmFragLibs[a], False, Repeated);
             if Repeated then et:= etRepeated else et:= etNormal;
           end;
           HqLibs.AddEntry(et, FirstFrag + FLen+ a, 'bl1', TmFragDescs[a]);
         end;
         ProgBarForm.UpdateBar(a);
       end;
      ProgBarForm.CloseSpecial();

     c:= Length(PkGrids) + Length(PkLibs) + Length(PkBricks) + Length(PkScenes);

     //Compressing
     if not ProjectOptions.General.CompOptOff
     and (ProjectOptions.Compression.Lba1 > 0) then begin
       ProgBarForm.ShowSpecialBar('Compressing entries...', fmMain, False, 0, c - 1);
       for a:= 0 to High(PkGrids) do begin
         if PkGrids[a].FType = -1 then CompressEntry(PkGrids[a]);
         ProgBarForm.UpdateBar(a);
       end;
       b:= Length(PkGrids);
       for a:= 0 to High(PkLibs) do begin
         if PkLibs[a].FType = -1 then CompressEntry(PkLibs[a]);
         ProgBarForm.UpdateBar(b + a);
       end;
       Inc(b, Length(PkLibs));
       for a:= 0 to High(PkBricks) do begin
         if PkBricks[a].FType = -1 then CompressEntry(PkBricks[a]);
         ProgBarForm.UpdateBar(b + a);
       end;
       Inc(b, Length(PkBricks));
       for a:= 0 to High(PkScenes) do begin
         if PkScenes[a].FType = -1 then CompressEntry(PkScenes[a]);
         ProgBarForm.UpdateBar(b + a);
       end;
       ProgBarForm.CloseSpecial();
     end;

     //Saving everything
     ProgBarForm.ShowSpecialBar('Writing output files...', fmMain, False, 0, 7);
     if ProjectOptions.Output.Lba1OutputGrid then begin
       try
         SavePackToFile(PkGrids, ProjectOptions.Output.Lba1GridPath);
       except
         BuildError(50, True, -1, ProjectOptions.Output.Lba1GridPath);
       end;
       ProgBarForm.UpdateBar(1);
       if ProjectOptions.Output.Lba1GridHqd then begin
         //HqGrids.Mask:= ExtractFileName(ProjectOptions.Output.Lba1GridPath);
         if not HqGrids.SaveToFile(ChangeFileExt(ProjectOptions.Output.Lba1GridPath, '.hqd'))
         then
           BuildError(54, True, -1, ProjectOptions.Output.Lba1GridPath);
       end;
     end;
     ProgBarForm.UpdateBar(2);

     if ProjectOptions.Output.Lba1OutputLibBrk then begin
       try
         SavePackToFile(PkLibs, ProjectOptions.Output.Lba1LibraryPath);
       except
         BuildError(51, True, -1, ProjectOptions.Output.Lba1LibraryPath);
       end;
       ProgBarForm.UpdateBar(3);
       if ProjectOptions.Output.Lba1LibraryHqd then begin
         //HqGrids.Mask:= ExtractFileName(ProjectOptions.Output.Lba1GridPath);
         if not HqLibs.SaveToFile(ChangeFileExt(ProjectOptions.Output.Lba1LibraryPath, '.hqd'))
         then
           BuildError(54, True, -1, ProjectOptions.Output.Lba1LibraryPath);
       end;
       ProgBarForm.UpdateBar(4);
       try
         SavePackToFile(PkBricks, ProjectOptions.Output.Lba1BrickPath);
       except
         BuildError(52, True, -1, ProjectOptions.Output.Lba1BrickPath);
       end;
     end;
     ProgBarForm.UpdateBar(5);

     if ProjectOptions.Output.OutputScene then begin
       try
         SavePackToFile(PkScenes,ProjectOptions.Output.ScenePath);
       except
         BuildError(53, True, -1, ProjectOptions.Output.ScenePath);
       end;
       ProgBarForm.UpdateBar(6);
       if ProjectOptions.Output.SceneHqd then begin
         //HqGrids.Mask:= ExtractFileName(ProjectOptions.Output.Lba1GridPath);
         if not HqScenes.SaveToFile(ChangeFileExt(ProjectOptions.Output.ScenePath, '.hqd'))
         then
           BuildError(54, True, -1, ProjectOptions.Output.ScenePath);
       end;
     end;
     ProgBarForm.UpdateBar(7);
     ProgBarForm.CloseSpecial();

     a:= Length(PkBricks);

     //Free the memory
     SetLength(PkBricks, 0);
     SetLength(PkLibs, 0);
     SetLength(PkGrids, 0);
     SetLength(PkScenes, 0);
     SetLength(TmScenario, 0);
     SetLength(TmFrags, 0);
     SetLength(TmFragLibs, 0);
     SetLength(TmFragDescs, 0);

     If MainSettings.BuildSummary then
       InfoMsg(Format('Project built successfully!'#13#13
              + 'Grids/Scenes: %d'#13
              + 'Manual Fragments: %d'#13
              + 'Auto-Fragments: %d'#13#13
              + 'Total Maps: %d'#13
              + 'Total Bricks: %d'#13#13
              + 'Total entries created: %d'#13
              + 'Normal entries: %d'#13
              + 'Blank entries: %d'#13
              + 'Repeated entries: %d'#13#13
              + 'Entries with no compression: %d'#13
              + 'Entries with compression 1: %d'#13
              + 'Entries with compression 2: %d',
          [rgc, rfc, tfh + 1, rgc + rfc + tfh + 1, a, c,
           c - BlankCount - RepCount, BlankCount, RepCount,
           c - Comp1Count - Comp2Count, Comp1Count, Comp2Count]));
   end;
 finally
   FreeAndNil(HqGrids);
   FreeAndNil(HqLibs);
   FreeAndNil(HqScenes);
 end;
end;

end.
