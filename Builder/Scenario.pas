unit Scenario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Libraries, StrUtils, ProgBar, Engine, Hints, StdCtrls, DePack, Settings,
  SceneLib, Math, Menus, Utils, CompMods, SceneLibComp;

type
 THQSInfo = record
   Lba2: Boolean;
   InfoText: String;
   Version: Word; //HQS version, not LBA version :)
   FirstFragment, FragmentCount: Word;
   FirstBrick: Word;
   BrickCount: Cardinal;
 end;

 TFragmentInfo = record
   Name: String; //Fragment Name
   Offsets: array of Cardinal; //Offsets in the Bin Script
 end;

Procedure SetScenarioModified();
//MissingFiles - True if Scenario didn't contain some files and they have been specified by user
function OpenScenario(path: String; var MissingFiles: Boolean): Boolean;
procedure CloseScenario();
procedure SaveScenario(path: String);
procedure UpdateShortcuts();
procedure SetScenarioState(Value: Boolean);
procedure RefreshRecentMenu();
procedure AddToRecent(path: String);

implementation

uses Bricks, Open, Grids, OpenSim, Scene, Rendering, SceneLibConst,
     ScriptEd, Globals, Main, Maps;

const BaseScenarioLen = 11;
      InfoEntry = 0;
      DescEntry = 1;
      LibraryEntry = 2;
      GridEntry = 3;
      PaletteEntry = 4;
      MapNamesEntry = 5;
      FragAssocEntry = 6;
      SceneTxtEntry = 7;
      SceneBinEntry = 8;

var TempLib: TCubeLib;

Procedure SetScenarioModified();
begin
 If not ScenarioModified then begin
   ScenarioModified:= True;
   fmMain.UpdateProgramName();
 end;
end;

function LoadHQSInfo(data: String; EntCount: Integer): THQSInfo;
var dl: Integer;
begin
 //FStr.Seek(0,soBeginning);
 Result.Lba2:= data[1] = #2; //FStr.Read(Result.Lba2,1);
 Result.InfoText:= Copy(data, 2, 255); //FStr.Read(Result.InfoText[1],255);
 dl:= Length(data);
 if dl >= 258 then Result.Version:= ReadWordFromBinStr(data, 257)
 else if dl = 257 then Result.Version:= Byte(data[257])
                  else Result.Version:= 0;
 if Result.Version >= 2 then begin
   Result.FirstFragment:= ReadWordFromBinStr(data, $102 + 1);
   Result.FragmentCount:= ReadWordFromBinStr(data, $104 + 1);
   Result.FirstBrick:= ReadWordFromBinStr(data, $106 + 1);
   Result.BrickCount:= ReadUIntFromBinStr(data, $108 + 1);
 end
 else begin
   Result.FirstFragment:= 0;
   Result.FragmentCount:= 0;
   Result.FirstBrick:= 20;
   Result.BrickCount:= EntCount - 20;
 end;
 //FStr.Free;
end;

function ReadFragmentNameList(data: String): TStrDynAr;
var a: Integer;
    temp: TStringList;
begin
 temp:= TStringList.Create();
 temp.Text:= data;
 SetLength(Result, temp.Count);
 for a:= 0 to temp.Count - 1 do
   Result[a]:= temp[a];
 FreeAndNil(temp);  
end;

function OpenScenario(path: String; var MissingFiles: Boolean): Boolean;
var ext: String;
    NoGrid, NoLib, NoScene: Boolean;
    tlba, gl, fl: Byte;
    a, mh: Integer;
    sl: Cardinal;
    MStr: TMemoryStream;
    FragNames: TStrDynAr;

  procedure CancelOpen();
  begin
    EnableControls(False); //CloseScenario();
    Result:= False;
    CurrentScenarioFile:= '';
  end;
  
begin
 Result:= True;
 MissingFiles:= False;
 path:= Trim(path);
 If not FileExists(path) then begin
   Application.MessageBox(PChar('File "'+path+'" not found !'), ProgramName, MB_ICONERROR+MB_OK);
   CancelOpen();
   Exit;
 end;
 ext:= LowerCase(ExtractFileExt(path));
 If (ext = '.hqs') then begin
   CurrentScenarioFile:= path;
   PkScenario:= OpenPack(path);
   sl:= Length(PkScenario);
   HQSInfo:= LoadHQSInfo(UnpackToString(PkScenario[InfoEntry]), sl);
   fmMain.SetLBAMode(IfThen(HQSInfo.Lba2, 2, 1));

   if HQSInfo.Version > 2 then begin
     Application.MessageBox('Unsupported Scenario version! Please download the latest LBArchitect from lba.kazekr.net', ProgramName, MB_ICONERROR+MB_OK);
     CancelOpen();
     Exit;
   end;

   if ((HQSInfo.FirstFragment > 0)
   and ((HQSInfo.FirstFragment <= 10) //10 and below are reserved
     or (HQSInfo.FirstFragment + HQSInfo.FragmentCount > sl)
     or ((HQSInfo.FirstBrick > 0)
         and (HQSInfo.FirstFragment + HQSInfo.FragmentCount > HQSInfo.FirstBrick))))
   or ((HQSInfo.FirstBrick > 0)
   and ((HQSInfo.FirstBrick <= 10)
     or (HQSInfo.FirstBrick + HQSInfo.BrickCount > sl))) then begin
     Application.MessageBox('The Scenario file seems corrupted!', ProgramName, MB_ICONERROR+MB_OK);
     CancelOpen();
     Exit;
   end;

   If PkScenario[DescEntry].FType = -1 then
     ScenarioDesc:= UnpackToString(PkScenario[DescEntry]);

   if PkScenario[MapNamesEntry].FType = -1 then
     FragNames:= ReadFragmentNameList(UnpackToString(PkScenario[MapNamesEntry]));

   PaletteType:= ptScenario;
   If PkScenario[PaletteEntry].FType = -1 then begin
     MStr:= UnpackToStream(PkScenario[PaletteEntry]);
     Palette:= LoadPaletteFromStream(MStr);
     FreeAndNil(Mstr);
   end else begin
     If HQSInfo.Lba2 then Palette:= LoadPaletteFromResource(2)
     else Palette:= LoadPaletteFromResource(1);
     PaletteType:= ptLba;
   end;

   PkBricks:= Copy(PkScenario, HQSInfo.FirstBrick, HQSInfo.BrickCount); //OpenPack(FStr,20);
   TransparentBrick:= 0;
   If HQSInfo.Lba2 then FindTransparentBrick();

   NoLib:= False;
   If PkScenario[LibraryEntry].FType = -1 then begin
     MStr:= UnpackToStream(PkScenario[LibraryEntry]);
     LdLibrary:= LoadLibraryFromStream(MStr);
     FreeAndNil(MStr);
   end else
     NoLib:= True;

   NoGrid:= False;
   if not NoLib then begin //Grid can't be alone without Library
     MainMapIsGrid:= True;
     if CreateNewMap(False) >= 0 then begin
       if PkScenario[GridEntry].FType = -1 then begin
         MStr:= UnpackToStream(PkScenario[GridEntry]);
         LoadGridFromStream(MStr, HQSInfo.Lba2,
                   LdLibrary, GLibIndex, GFragIndex, LdMaps[0]);
         FreeAndNil(MStr);
         if Length(FragNames) > 0 then
           LdMaps[0].Name:= FragNames[0];
       end else
         NoGrid:= True;
     end else begin
       CancelOpen();
       Exit;
     end;     
   end
   else NoGrid:= True;

   NoScene:= False;
   If PkScenario[SceneTxtEntry].FType = -1 then begin
     If HQSInfo.Version > 0 then begin
       MStr:= UnpackToStream(PkScenario[SceneTxtEntry]);
       If not LoadSceneProjectStream(MStr, tlba, VScene) then begin
         Application.MessageBox('Error loading the Text Scene Project!', ProgramName, MB_ICONERROR+MB_OK);
         CancelOpen();
       end;
       FreeAndNil(MStr);
     end
     else begin
       MStr:= UnpackToStream(PkScenario[SceneTxtEntry]);
       if not LoadCoderProjectStream(MStr, IfThen(HQSInfo.Lba2, 2, 1), VScene) then begin
         Application.MessageBox('Error loading the Story Coder Project!', ProgramName, MB_ICONERROR+MB_OK);
         CancelOpen();
       end;
       FreeAndNil(MStr);
     end;
   end
   else if PkScenario[SceneBinEntry].FType = -1 then begin
     MStr:= UnpackToStream(PkScenario[SceneBinEntry]);
     VScene:= LoadSceneFromStream(MStr, IfThen(HQSInfo.Lba2, 2, 1));
     FreeAndNil(MStr);
   end
   else NoScene:= True;

   If NoGrid or NoLib or NoScene then begin
     If Application.MessageBox('The Scenario doesn''t contain some required elements. Please choose them in the dialog that follows.', ProgramName, MB_ICONWARNING+MB_OKCANCEL)
          = IDOK then begin
       If fmOpen.ShowDialog(True, NoLib, NoGrid, NoScene, False) = mrOK then begin
         //EnableControls(False);
         Screen.Cursor:= crHourGlass;
         fmOpen.OpenFiles(NoLib, NoGrid, NoScene, False);
         If not NoProgress then ProgBarForm.ShowSpecial('Loading files...', fmMain, True);
         //DataToMap();
         //BufferBricks(VLibrary, VBricks);
         //CreateThumbnail(False);
         //If fmOpen.rbSceneMode.Checked then GoSceneMode();
         //SetScenarioModified();
         MissingFiles:= True;
       end
       else CancelOpen();
     end
     else CancelOpen();
   end;

   if Result and (HQSInfo.FragmentCount > 0) then //Now load the Fragments if any
     for a:= HQSInfo.FirstFragment to HQSInfo.FirstFragment + HQSInfo.FragmentCount - 1
     do begin
       mh:= CreateNewMap(False);
       if mh >= 0 then begin
         MStr:= UnpackToStream(PkScenario[a]);
         LoadGridFromStream(MStr, HQSInfo.Lba2, LdLibrary, gl, fl, LdMaps[mh]);
         FreeAndNil(MStr);
         if mh <= High(FragNames) then
           LdMaps[mh].Name:= FragNames[mh];
       end else begin
         WarningMsg('The Scenario could not be fully loaded! Better don''t save it on top of the original one!');
         CurrentScenarioFile:= ''; //to prevent auto-overwrite
         break;
       end;
     end;
 end;
end;

procedure CloseScenario();
begin
 HQSInfo.InfoText:= '';
 ScenarioDesc:= '';
 SetLength(PkScenario, 0);
end;

function CreateHQSInfo(Lba2: Boolean; Desc: String;
  FirstFrag, FragCount, FirstBrk: Word; BrkCount: Cardinal): String;
begin
 if Lba2 then Result:= #2 else Result:= #1;
 if Length(Desc) > 255 then Result:= Result + Copy(Desc, 1, 255)
 else Result:= Result + Desc + StringOfChar(' ', 255 - Length(Desc));
 Result:= Result + WordToBinStr(2) //version
                 + WordToBinStr(FirstFrag) + WordToBinStr(FragCount)
                 + WordToBinStr(FirstBrk) + UIntToBinStr(BrkCount);
end;

function CreateFragmentNameList(): String;
var a: Integer;
begin
 Result:= '';
 for a:= 0 to High(LdMaps) do
   Result:= Result + LdMaps[a].Name + #$0A;
 SetLength(Result, Length(Result) - 1);
end;

function CreateFragmentInfo(Scene: TScene): String;
var a, b: Integer;
begin
 Result:= '';
 for a:= 0 to High(Scene.Actors) do
   for b:= 0 to High(Scene.Actors[a].FragmentInfo) do
     Result:= Result + Char(Scene.Actors[a].FragmentInfo[b].Fragment)
                     + UIntToBinStr(Scene.Actors[a].FragmentInfo[b].Offset);
 for a:= 0 to High(Scene.Zones) do
   if Scene.Zones[a].RealType = ztFragment then begin
     b:= FragmentNameIndex(Scene.Zones[a].FragmentName);
     if b >= 1 then
       Result:= Result + Char(b - 1) + UIntToBinStr(Scene.Zones[a].FragmentOffset);
   end;
end;

function MakeScenarioFile(): Boolean;
var a, b, c, d, Index, vsh, BrkCnt, FirstFrag, FragCnt: Integer;
    ptemp: TPackEntry;
    utemp: String;
    FLibUsage: TGridLibUsage;
begin
 Assert(Length(LdMaps) > 0, 'MakeScenarioFile()');
 Result:= True;
 If Length(PkScenario) < 1 then begin
   SetLength(PkScenario, BaseScenarioLen);
   for a:= 0 to BaseScenarioLen - 1 do
     PkScenario[a]:= PackEntry('', -2); //make all entries blank
 end
 else
   SetLength(PkScenario, BaseScenarioLen);

 If Length(ScenarioDesc) > 0 then PkScenario[DescEntry]:= PackEntry(ScenarioDesc, -1, 2)
                             else PkScenario[DescEntry]:= PackEntry('', -2);

 FLibUsage:= GetAllMapsLibUsage();
 PkScenario[GridEntry]:= PackEntry(MapToGridString(LdMaps[0], LBAMode = 2, @FLibUsage, GLibIndex, GFragIndex), -1, 2);
 If PaletteType = ptFile then
   PkScenario[PaletteEntry]:= PackEntry(PaletteToString(Palette), -1, 2);
 PkScenario[MapNamesEntry]:= PackEntry(CreateFragmentNameList(), -1, 2); //Fragment names list
 PkScenario[SceneTxtEntry]:= PackEntry(SceneProjectToString(VScene, LBAMode, True), -1, 2);

 FragCnt:= Length(LdMaps) - 1;
 SetLength(PkScenario, BaseScenarioLen + FragCnt);
 if Length(LdMaps) > 1 then FirstFrag:= 11
                       else FirstFrag:= 0; //There are no Fragments
 if LBAMode = 1 then
   for a:= 1 to FragCnt do //Grids for LBA 1
     PkScenario[FirstFrag + a - 1]:=
       PackEntry(MapToGridString(LdMaps[a], False, nil, 0, 0), -1, 2)
 else
   for a:= 1 to FragCnt do //Fragments for LBA 2
     PkScenario[FirstFrag + a - 1]:=
       PackEntry(MapToFragmentString(LdMaps[a]), -1, 2);

 TempLib:= LibToCubeLib(Copy(LdLibrary, 1, High(LdLibrary)));
 BrkCnt:= 0;
 for a:= 0 to High(TempLib) do
   for d:= 0 to TempLib[a].Z - 1 do
     for c:= 0 to TempLib[a].Y - 1 do
       for b:= 0 to TempLib[a].X - 1 do begin
         Index:= TempLib[a].Map[b,c,d].Index;
         If Index > 0 then begin
           Inc(BrkCnt);
           vsh:= BaseScenarioLen + FragCnt + BrkCnt - 1;
           SetLength(PkScenario, vsh + 1);

           if PkBricks[Index-1].Comp <> 2 then begin
             utemp:= UnpackToString(PkBricks[Index-1]);
             ptemp:= PackEntry(utemp, -1, 2);
             If ptemp.CpSize < ptemp.RlSize then
               PkScenario[vsh]:= ptemp
             else
               PkScenario[vsh]:= PackEntry(utemp, -1, 0);
           end else if (PkBricks[Index-1].CpSize < PkBricks[Index-1].RlSize) then
             PkScenario[vsh]:= PkBricks[Index-1]
           else begin
             utemp:= UnpackToString(PkBricks[Index-1]);
             PkScenario[vsh]:= PackEntry(utemp, -1, 0);
           end;

           TempLib[a].Map[b,c,d].Index:= vsh + 1 - BaseScenarioLen - FragCnt;
         end;
       end;

 PkScenario[LibraryEntry]:= PackEntry(LibraryToString(TempLib), -1, 2);

 PkScenario[InfoEntry]:= PackEntry(CreateHQSInfo(LBAMode = 2, HQSInfo.InfoText,
   FirstFrag, FragCnt, BaseScenarioLen + FragCnt, BrkCnt), -1, 2);

 if fmScriptEd.CompileAllScripts(LbaMode, VScene) then begin
   PkScenario[SceneBinEntry]:= PackEntry(SceneToString(VScene, LBAMode), -1, 2);
   PkScenario[FragAssocEntry]:= PackEntry(CreateFragmentInfo(VScene), -1, 2);
 end else
   Application.MessageBox('Binary form of the Scene could not be included in the Scenario, because there were errors in Actor Scripts.'#13
                        + 'This Scenario cannot be used in Stage Designer program as a Scene File source.'#13#13
                        + 'To solve this problem fix Actor Scripts in the current Scene so they will compile without errors, and save the Scenario again.',
                        ProgramName, MB_ICONWARNING + MB_OK);
end;

procedure SaveScenario(path: String);
var a: Integer;
begin
 If ExtIs(path, '.hqs') then begin
   If not NoProgress then ProgBarForm.ShowSpecial('Saving Scenario...', fmMain, True);
   If MakeScenarioFile() then begin
     SavePackToFile(PkScenario, path);
     SetScenarioState(True);
     ScenarioModified:= False;
     for a:= 0 to High(LdMaps) do
       LdMaps[a].Modified:= False;
     SceneModified:= False;
     CurrentScenarioFile:= path;
     fmMain.UpdateProgramName();
     SysUtils.Beep();
     PutMessage('Scenario successfully saved'); //79
   end;
   ProgBarForm.CloseSpecial();
   AddToRecent(path);
 end;
end;

procedure UpdateShortcuts();
begin
 fmMain.aSaveGrid.ShortCut:= 0;
 fmMain.aSaveScene.ShortCut:= 0;
 fmMain.aSaveScenario.ShortCut:= 0;
 If ScenarioState then
   fmMain.aSaveScenario.ShortCut:= ShortCut(Word('S'), [ssCtrl])
 else begin
   if ProgMode = pmScene then
     fmMain.aSaveScene.ShortCut:= ShortCut(Word('S'), [ssCtrl])
   else
     fmMain.aSaveGrid.ShortCut:= ShortCut(Word('S'), [ssCtrl]);
 end;
end;

procedure SetScenarioState(Value: Boolean);
begin
 ScenarioState:= Value;
 fmMain.UpdateProgramName();
 UpdateShortcuts();
end;

procedure RefreshRecentMenu();
var a: Integer;
    temp: TMenuItem;
begin
 fmMain.mRecentScenario.Clear();
 for a:= 0 to MaxRecentScenarios - 1 do
   if Sett.General.RecentScenarios[a] <> '' then begin
     temp:= NewItem(Sett.General.RecentScenarios[a], 0, False, True,
                    fmMain.mOpenRecentScenarioClick, 0, '');
     temp.Tag:= a;
     fmMain.mRecentScenario.Add(temp);
     CompMods.UpdateComponent(temp);
   end;
 fmMain.mRecentScenario.Enabled:= fmMain.mRecentScenario.Count > 0;
end;


procedure AddToRecent(path: String);
var a, b, c: Integer;
begin
 path:= GetLongFileName(path);
 c:= MaxRecentScenarios - 1; //High(..Sett.General.Recent...)
 for a:= 0 to MaxRecentScenarios - 2 do
   if AnsiSameText(path, Sett.General.RecentScenarios[a]) then begin
     c:= a;
     Break;
   end;
 for b:= c - 1 downto 0 do
   Sett.General.RecentScenarios[b + 1]:= Sett.General.RecentScenarios[b];
 Sett.General.RecentScenarios[0]:= path;
 RefreshRecentMenu();
end;

end.
