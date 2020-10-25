unit Scenario;

interface

uses DePack, Classes, SysUtils, Windows, Libraries, StrUtils, ProgBar, Utils,
     Forms;

type
 THQSInfo = record
   Lba2: Boolean;
   InfoText: String;
   Version: Word; //HQS version, not LBA version :)
   FirstFragment, FragmentCount: Word;
   FirstBrick: Word;
   BrickCount: Cardinal;
 end;

const
 MaxScenarioVersion = 2;
 BaseScenarioLen = 11;
 InfoEntry = 0;
 DescEntry = 1;
 LibraryEntry = 2;
 GridEntry = 3;
 PaletteEntry = 4;
 MapNamesEntry = 5;
 FragAssocEntry = 6;
 SceneTxtEntry = 7;
 SceneBinEntry = 8;

var
 HQSInfo: THQSInfo = (Lba2: False; InfoText: '');
 ScenarioDesc: String = '';
 ScenarioPath: String = '';
 ScenarioModified: Boolean;
 PkScenario: TPackEntries;
 TempLib: TCubeLib;

procedure OpenScenario(path: String);
function OpenScenarioPreview(path: String; var AScenario: TPackEntries;
  var ALib: TCubeLib; var Info: THQSInfo): Boolean; //for Layout import
function CloseScenario(): Boolean;
procedure SaveScenario(path: String);

implementation

uses Main, Layouts, Bricks, OptPanel, Globals;

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

procedure OpenScenario(path: String);
var FStr: TFileStream;
    MStr: TMemoryStream;
    ext: String;
    sl: Integer;
begin
 path:= Trim(path);
 If not FileExists(path) then begin
   MessageBox(fmMain.Handle,PChar('File "'+path+'" not found !'),'LBArchitect',MB_ICONERROR+MB_OK);
   Exit;
 end;
 if not CloseScenario() then Exit;
 BrkPath:= '';
 LibPath:= '';
 ext:= LowerCase(ExtractFileExt(path));
 If (ext = '.hqs') then begin
   FStr:= TFileStream.Create(path, fmOpenRead, fmShareDenyWrite);
   PkScenario:= OpenPack(FStr);
   FreeAndNil(FStr);
   sl:= Length(PkScenario);
   HQSInfo:= LoadHQSInfo(UnpackToString(PkScenario[0]), sl);
   LLba1:= not HQSInfo.Lba2;

   if HQSInfo.Version > MaxScenarioVersion then begin
     Application.MessageBox('Unsupported Scenario version! Please download the latest LBArchitect from http://lba.kazekr.net', ProgramName, MB_ICONERROR+MB_OK);
     fmMain.CloseAll();
     Exit;
   end;

   //Basic structure checking:
   if ((HQSInfo.FirstFragment > 0)
   and ((HQSInfo.FirstFragment <= 10) //10 and below are reserved
     or (HQSInfo.FirstFragment + HQSInfo.FragmentCount > sl)
     or ((HQSInfo.FirstBrick > 0)
         and (HQSInfo.FirstFragment + HQSInfo.FragmentCount > HQSInfo.FirstBrick))))
   or ((HQSInfo.FirstBrick > 0)
   and ((HQSInfo.FirstBrick <= 10)
     or (HQSInfo.FirstBrick + HQSInfo.BrickCount > sl))) then begin
     Application.MessageBox('The Scenario file seems corrupted!', ProgramName, MB_ICONERROR+MB_OK);
     fmMain.CloseAll();
     Exit;
   end;

   If PkScenario[1].FType = -1 then
     ScenarioDesc:= UnpackToString(PkScenario[1]);

   {If VBricks[4].FType = -1 then
   else} ChangePalette(LLba1, False);

   //VBricks:= Copy(VScenario, 20, Length(VScenario)-20);
   VBricks:= Copy(PkScenario, HQSInfo.FirstBrick, HQSInfo.BrickCount);
   BrkOffset:= 0;
   BrkCount:= Length(VBricks);
   BricksOpened:= True;
   SetMenuBrk('.hqs');

   if PkScenario[2].FType = -1 then begin
     MStr:= UnpackToStream(PkScenario[2]);
     Lib:= LibToCubeLib(LoadLibraryFromStream2(MStr));
     FreeAndNil(MStr);
     LibIndex:= -1;
     SetMenuLt('.hqs', True);
   end;
 end;
 ScenarioPath:= path;
end;

function OpenScenarioPreview(path: String; var AScenario: TPackEntries;
  var ALib: TCubeLib; var Info: THQSInfo): Boolean;
var FStr: TFileStream;
    MStr: TMemoryStream;
    ext: String;
    sl: Integer;
begin
 Result:= False;
 path:= Trim(path);
 If not FileExists(path) then begin
   MessageBox(fmMain.Handle,PChar('File "'+path+'" not found !'),'LBArchitect',MB_ICONERROR+MB_OK);
   Exit;
 end;
 ext:= LowerCase(ExtractFileExt(path));
 if (ext = '.hqs') then begin
   FStr:= TFileStream.Create(path, fmOpenRead, fmShareDenyWrite);
   AScenario:= OpenPack(FStr);
   FreeAndNil(FStr);
   sl:= Length(AScenario);
   Info:= LoadHQSInfo(UnpackToString(AScenario[0]), sl);

   if Info.Version > MaxScenarioVersion then begin
     Application.MessageBox('Unsupported Scenario version! Please download the latest LBArchitect from http://lba.kazekr.net', ProgramName, MB_ICONERROR+MB_OK);
     Exit;
   end;

   //Basic structure checking:
   if ((Info.FirstFragment > 0)
   and ((Info.FirstFragment <= 10) //10 and below are reserved
     or (Info.FirstFragment + Info.FragmentCount > sl)
     or ((Info.FirstBrick > 0)
         and (Info.FirstFragment + Info.FragmentCount > Info.FirstBrick))))
   or ((Info.FirstBrick > 0)
   and ((Info.FirstBrick <= 10)
     or (Info.FirstBrick + Info.BrickCount > sl))) then begin
     Application.MessageBox('The Scenario file seems corrupted!', ProgramName, MB_ICONERROR+MB_OK);
     Exit;
   end;

   if AScenario[2].FType = -1 then begin
     MStr:= UnpackToStream(AScenario[2]);
     ALib:= LibToCubeLib(LoadLibraryFromStream2(MStr));
     FreeAndNil(MStr);
   end else begin
     Application.MessageBox('The Scenario file does not contain any Layouts!', ProgramName, MB_ICONERROR+MB_OK);
     Exit;
   end;

   Result:= True;
 end;
end;

function CloseScenario(): Boolean;
begin
 Result:= True;
 if Length(PkScenario) > 0 then begin
   if QuestYesNo('This will close current Scenario. Continue?') then
     fmMain.CloseAll()
   else
     Result:= False;
 end;
end;

function CreateHQSInfo(Lba2: Boolean; Desc: ShortString;
  FirstFrag, FragCount, FirstBrk: Word; BrkCount: Cardinal): String;
begin
 If Lba2 then Result:= #2 else Result:= #1;
 If Length(Desc) > 255 then Result:= Result + Copy(Desc, 1, 255)
 else Result:= Result + Desc + StringOfChar(' ', 255 - Length(Desc));
 Result:= Result + WordToBinStr(2) //version
                 + WordToBinStr(FirstFrag) + WordToBinStr(FragCount)
                 + WordToBinStr(FirstBrk) + UIntToBinStr(BrkCount);
end;

function MakeScenarioFile(): Boolean;
var a, b, c, d, Index, vsh, BrkCnt, BrkBase: Integer;
    ptemp: TPackEntry;
    utemp: String;
begin
 Result:= True;
 if Length(PkScenario) < 1 then begin
   HQSInfo.FirstFragment:= 0;
   HQSInfo.FragmentCount:= 0;
   SetLength(PkScenario, BaseScenarioLen);
   for a:= 0 to BaseScenarioLen - 1 do
     PkScenario[a]:= PackEntry('', -2); //make all entries blank
 end else begin
   if HQSInfo.FragmentCount > 0 then b:= HQSInfo.FirstFragment + HQSInfo.FragmentCount
                                else b:= BaseScenarioLen;
   SetLength(PkScenario, b); //Keep Fragments
 end;  

 if Length(ScenarioDesc) > 0 then PkScenario[1]:= PackEntry(ScenarioDesc, -1, 2)
                             else PkScenario[1]:= PackEntry('', -2);

 TempLib:= CopyLibrary(Lib);
 //vsh:= High(PkScenario);
 BrkBase:= BaseScenarioLen + HQSInfo.FragmentCount;
 BrkCnt:= 0;
 for a:= 0 to High(TempLib) do
   for d:= 0 to TempLib[a].Z - 1 do
     for c:= 0 to TempLib[a].Y - 1 do
      for b:= 0 to TempLib[a].X - 1 do begin
        Index:= TempLib[a].Map[b,c,d].Index;
        If Index > 0 then begin
          Inc(BrkCnt);
          vsh:= BrkBase + BrkCnt - 1;
          SetLength(PkScenario, vsh + 1);

          {if VBricks[Index+BrkOffset-1].Comp <> 2 then
            PkScenario[vsh]:= PackEntry(UnpackToString(VBricks[Index+BrkOffset-1]),-1,2)
          else
            PkScenario[vsh]:= VBricks[Index+BrkOffset-1];}

          if VBricks[Index-1].Comp <> 2 then begin
            utemp:= UnpackToString(VBricks[Index+BrkOffset-1]);
            ptemp:= PackEntry(utemp, -1, 2);
            if ptemp.CpSize < ptemp.RlSize then
              PkScenario[vsh]:= ptemp
            else
              PkScenario[vsh]:= PackEntry(utemp, -1, 0);
          end else if (VBricks[Index+BrkOffset-1].CpSize < VBricks[Index+BrkOffset-1].RlSize) then
            PkScenario[vsh]:= VBricks[Index+BrkOffset-1]
          else begin
            utemp:= UnpackToString(VBricks[Index+BrkOffset-1]);
            PkScenario[vsh]:= PackEntry(utemp, -1, 0);
          end;  

          TempLib[a].Map[b,c,d].Index:= vsh - BrkBase + 1;
        end;
      end;

 PkScenario[2]:= PackEntry(LibraryToString(TempLib),-1,2);

 PkScenario[0]:= PackEntry(CreateHQSInfo(not LLba1, HQSInfo.InfoText,
   HQSInfo.FirstFragment, HQSInfo.FragmentCount,
   BaseScenarioLen + HQSInfo.FragmentCount, BrkCnt), -1, 2);
end;

procedure SaveScenario(path: String);
begin
 If ExtIs(path,'.hqs') then begin
  ProgBarForm.ShowSpecial('Saving Scenario...',fmMain,True);
  MakeScenarioFile();
  SavePackToFile(PkScenario, path);
  ProgBarForm.CloseSpecial();
 end;
 SetTabCaptions();
 ScenarioModified:= False;
 ScenarioPath:= path;
 SysUtils.Beep();
end;

end.
