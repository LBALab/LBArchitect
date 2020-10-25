//******************************************************************************
// Little Big Architect: Factory - editing brick and layout files from
//                                 Little Big Adventure 1 & 2
//
// Main unit.
// Main program unit. Contains main form's events.
//
// Copyright Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin, IniFiles, StrUtils, Engine, DePack,
  ComCtrls, Buttons, ImgList, Menus, ActnList, Math, filectrl, Libraries,
  Scenario, SpinMod;

type
  TfmMain = class(TForm)
    paMain: TPanel;
    lbInfo: TLabel;
    lbTest: TLabel;
    pcContent: TPageControl;
    BrkTab: TTabSheet;
    lbBrkCount: TLabel;
    Bevel2: TBevel;
    pbBrick: TPaintBox;
    sbBricks: TScrollBar;
    LibTab: TTabSheet;
    lbLtCount: TLabel;
    Bevel1: TBevel;
    pbLayout: TPaintBox;
    btTest: TButton;
    sbLayouts: TScrollBar;
    edGoTo: TEdit;
    DlgOpen: TOpenDialog;
    DlgSave: TSaveDialog;
    pmBricks: TPopupMenu;
    mEditBrk: TMenuItem;
    N1: TMenuItem;
    mExportBrk: TMenuItem;
    mExportBrkBit: TMenuItem;
    N12: TMenuItem;
    mImportBrk: TMenuItem;
    N2: TMenuItem;
    mBrkInsBefore: TMenuItem;
    mBrkInsAfter: TMenuItem;
    N4: TMenuItem;
    mBrkMoveForw: TMenuItem;
    mBrkMoveBack: TMenuItem;
    N3: TMenuItem;
    mBrkDelete: TMenuItem;
    N5: TMenuItem;
    mLockBrick: TMenuItem;
    pmLayouts: TPopupMenu;
    mLtEditStr: TMenuItem;
    mLtEditImg: TMenuItem;
    N6: TMenuItem;
    mExportLay: TMenuItem;
    mExportLayBit: TMenuItem;
    N7: TMenuItem;
    mNewLt: TMenuItem;
    mCopyLt: TMenuItem;
    mDeleteLt: TMenuItem;
    N8: TMenuItem;
    mLockLib: TMenuItem;
    mmMain: TMainMenu;
    mFile: TMenuItem;
    mOpenBrk: TMenuItem;
    mSaveBrk: TMenuItem;
    mSaveBrkAs: TMenuItem;
    N10: TMenuItem;
    mOpenLib: TMenuItem;
    mSaveLib: TMenuItem;
    mSaveLibAs: TMenuItem;
    N11: TMenuItem;
    mSaveBoth: TMenuItem;
    mSaveBothAs: TMenuItem;
    N13: TMenuItem;
    mExit: TMenuItem;
    View1: TMenuItem;
    mFrames: TMenuItem;
    mIndexes: TMenuItem;
    mShapes: TMenuItem;
    Palette1: TMenuItem;
    mLba1: TMenuItem;
    mLba2: TMenuItem;
    N9: TMenuItem;
    mAutoPal: TMenuItem;
    paSplash: TPanel;
    Shape1: TShape;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lbVersion: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    lbAllocCnt: TLabel;
    mRemSharing: TMenuItem;
    btSortSize: TSpeedButton;
    btSortIndex: TSpeedButton;
    N14: TMenuItem;
    NewBrick1: TMenuItem;
    mNewBrk: TMenuItem;
    mNewBrkHqr: TMenuItem;
    mNewLib1: TMenuItem;
    mNewBkg: TMenuItem;
    N15: TMenuItem;
    mNewLt1: TMenuItem;
    mNewLt2: TMenuItem;
    N16: TMenuItem;
    mNewLib2: TMenuItem;
    N18: TMenuItem;
    mOpenScen: TMenuItem;
    mExportScen: TMenuItem;
    mScenProp: TMenuItem;
    N17: TMenuItem;
    mChooseEntry: TMenuItem;
    Options1: TMenuItem;
    mStartWith1: TMenuItem;
    paBadBricks: TPanel;
    Label4: TLabel;
    cbBadBricks: TComboBox;
    N19: TMenuItem;
    mLayImpHqsNew: TMenuItem;
    mLayImpHqsRep: TMenuItem;
    procedure pbLayoutPaint(Sender: TObject);
    procedure mOpenBrkClick(Sender: TObject);
    procedure mFramesClick(Sender: TObject);
    procedure mLba1Click(Sender: TObject);
    procedure mOpenLibClick(Sender: TObject);
    procedure pbBrickPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure sbBricksChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pbBrickMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mEditBrkClick(Sender: TObject);
    procedure mExportBrkBitClick(Sender: TObject);
    procedure mBrkInsBeforeClick(Sender: TObject);
    procedure mBrkMoveForwClick(Sender: TObject);
    procedure mBrkDeleteClick(Sender: TObject);
    procedure mLockBrickClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btTestClick(Sender: TObject);
    procedure sbLayoutsChange(Sender: TObject);
    procedure pbLayoutMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mLtEditImgClick(Sender: TObject);
    procedure edGoToKeyPress(Sender: TObject; var Key: Char);
    procedure mLtEditStrClick(Sender: TObject);
    procedure mSaveBrkClick(Sender: TObject);
    procedure pcContentDrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure mSaveLibClick(Sender: TObject);
    procedure mSaveBothClick(Sender: TObject);
    procedure mSaveBothAsClick(Sender: TObject);
    procedure mImportBrkClick(Sender: TObject);
    procedure mExportLayBitClick(Sender: TObject);
    procedure mExportLayClick(Sender: TObject);
    procedure mExitClick(Sender: TObject);
    procedure mLockLibClick(Sender: TObject);
    procedure mNewLtClick(Sender: TObject);
    procedure mCopyLtClick(Sender: TObject);
    procedure mDeleteLtClick(Sender: TObject);
    procedure pcContentChange(Sender: TObject);
    procedure mRemSharingClick(Sender: TObject);
    procedure btSortSizeClick(Sender: TObject);
    procedure mExportBrkClick(Sender: TObject);
    procedure mNewClick(Sender: TObject);
    procedure pmBricksPopup(Sender: TObject);
    procedure mFileClick(Sender: TObject);
    procedure pmLayoutsPopup(Sender: TObject);
    procedure mOpenScenClick(Sender: TObject);
    procedure mExportScenClick(Sender: TObject);
    procedure mScenPropClick(Sender: TObject);
    procedure mChooseEntryClick(Sender: TObject);
    procedure mStartWith1Click(Sender: TObject);
    procedure cbBadBricksChange(Sender: TObject);
    procedure mLayImpHqsNewClick(Sender: TObject);
    procedure mLayImpHqsRepClick(Sender: TObject);
  private
    
  public
    procedure GetBrkPerRow();
    procedure CloseAll();
  end;

var
  fmMain: TfmMain;

  bufLayout, bufBrick: TBitmap;

  BadBrickMessage: Boolean = False;

procedure EnableSaveMenu();
Procedure CheckSaved(Bricks, Layouts: Boolean);
Procedure OpenParam();
procedure SetTabCaptions();

implementation

uses ProgBar, Bricks, Layouts, Editor, OptPanel, StructEd, DimDialog,
  ScenarioProp, Utils, LayImport;

{$R *.dfm}

procedure EnableSaveMenu();
begin
 fmMain.mSaveBoth.Enabled:= SameText(BrkPath,LibPath) and IsBkg(BrkPath);
 fmMain.mSaveBothAs.Enabled:= fmMain.mSaveBoth.Enabled;
 fmMain.mSaveBrk.Enabled:= not fmMain.mSaveBoth.Enabled and (BrkCount>0);
 fmMain.mSaveBrkAs.Enabled:= fmMain.mSaveBrk.Enabled;
 fmMain.mSaveLib.Enabled:= not fmMain.mSaveBoth.Enabled and (Length(Lib)>0);
 fmMain.mSaveLibAs.Enabled:= fmMain.mSaveLib.Enabled;
 fmMain.mExportScen.Enabled:= BricksOpened and not SingleBrick
                         and (Length(Lib) > 0) and not SingleLayout;
 fmMain.mScenProp.Enabled:= fmMain.mExportScen.Enabled;
end;

function Smaller(v1, v2: Integer): Integer;
begin
 If v1 < v2 then Result:= v1 else Result:= v2;
end;

procedure TfmMain.pbLayoutPaint(Sender: TObject);
begin
 UpdateImage(bufLayout, pbLayout);
end;

procedure TfmMain.mFramesClick(Sender: TObject);
begin
 PaintBricks;
 PaintLayouts;
end;

procedure TfmMain.mLba1Click(Sender: TObject);
begin
 ChangePalette(mLba1.Checked);
end;

procedure TfmMain.mOpenBrkClick(Sender: TObject);
begin
 With DlgOpen do begin
   Title:= 'Open Bricks';
   FileName:= '';
   Filter:= 'Bricks (*.brk, lba_brk.hqr, lba_bkg.hqr)|*.brk;*lba_brk*.hqr;*lba_bkg*.hqr|';
   InitialDir:= LastHqrPath;
   If Execute then begin
     LastHqrPath:= ExtractFilePath(FileName);
     BadBrickMessage:= False;
     cbBadBricks.Clear();
     cbBadBricks.ItemIndex:= -1;
     fmMain.paBadBricks.Visible:= False;
     OpenBricks(FileName);
   end;
 end;
end;

procedure TfmMain.mSaveBrkClick(Sender: TObject);
var ext: String;
begin
 If BrkCount < 1 then Exit;
 If ((Sender as TMenuItem).Name = 'mSaveBrk') and (BrkPath <> '') then
   SaveBricks(BrkPath)
 else with DlgSave do begin
   If SingleBrick then Filter:= 'LBA Brick files (*.brk)|*.brk'
   else Filter:= 'High Quality Resources (*.hqr)|*.hqr';
   FilterIndex:= 1;
   FileName:= ExtractFileName(BrkPath);
   InitialDir:= LastHqrPath;
   If Execute then begin
     FileName:= ChangeFileExt(FileName,IfThen(SingleBrick,'.brk','.hqr'));
     LastHqrPath:= ExtractFilePath(FileName);
     SaveBricks(FileName);
   end;
 end; 
end;

procedure TfmMain.mOpenLibClick(Sender: TObject);
begin
 DlgOpen.Title:= 'Open Layout or Library';
 DlgOpen.FileName:= '';
 DlgOpen.Filter:= 'All supported (lt*, bl*, lba_bll, lba_bkg)|*.lt1;*.lt2;*.bl1;*.bl2;*lba_bll*.hqr;*lba_bkg*.hqr'
               + '|Layouts (*.lt1, *.lt2)|*.lt1;*.lt2'
               + '|Libraries (*.bl1, *.bl2, lba_bll.hqr, lba_bkg.hqr)|*.bl1;*.bl2;*lba_bll*.hqr;*lba_bkg*.hqr';
 DlgOpen.InitialDir:= LastHqrPath;
 If DlgOpen.Execute then begin
  LastHqrPath:= ExtractFilePath(DlgOpen.FileName);
  LoadLibrary(DlgOpen.FileName);
 end;
end;

procedure TfmMain.mSaveLibClick(Sender: TObject);
begin
 If Length(Lib)<1 then Exit;
 If ((Sender as TMenuItem).Name='mSaveLib') and (LibPath<>'') then
  SaveLayouts(LibPath,LibIndex)
 else with DlgSave do begin
  DefaultExt:='';
  FileName:=ExtractFileName(LibPath);
  If SingleLayout then
   Filter:=IfThen(LLba1,'LBA 1 Layouts (*.lt1)|*.lt1','LBA 2 Layouts (*.lt2)|*.lt2')
  else begin
   Filter:=IfThen(LLba1,'LBA 1 Layout Libraries (*.bl1)|*.bl1','LBA 2 Layout Libraries (*.bl2)|*.bl2');
   FileName:=ChangeFileExt(FileName,IfThen(LLBa1,'.bl1','.bl2'));
  end;
  FilterIndex:=1;
  InitialDir:=LibPath;
  If Execute then begin
   LibPath:=ExtractFilePath(FileName);
   FileName:=ChangeFileExt(FileName,IfThen(SingleLayout,IfThen(LLBa1,'.lt1','.lt2'),IfThen(LLBa1,'.bl1','.bl2')));
   SaveLayouts(FileName,-1);
  end;
 end;
end;

procedure TfmMain.mOpenScenClick(Sender: TObject);
begin
 with DlgOpen do begin
   Title:= 'Open Scenario';
   FileName:= '';
   Filter:= 'High Quality Scenarios (*.hqs)|*.hqs';
   InitialDir:= LastScenPath;
   If Execute then begin
     LastScenPath:= ExtractFilePath(FileName);
     BadBrickMessage:= False;
     cbBadBricks.Clear();
     cbBadBricks.ItemIndex:= -1;
     fmMain.paBadBricks.Visible:= False;
     OpenScenario(FileName);
   end;
 end;
end;

procedure TfmMain.mExportScenClick(Sender: TObject);
begin
 If (Length(Lib) < 1) or (BrkCount < 1) then Exit;
 With DlgSave do begin
  Title:= 'Export to a Scenario...';
  Filter:= 'High Quality Scenario (*.hqs)|*.hqs';
  DefaultExt:= 'hqs';
  FilterIndex:= 1;
  FileName:= ExtractFileName(ScenarioPath);
  InitialDir:= LastScenPath;
  If Execute then begin
   LastScenPath:= ExtractFilePath(FileName);
   SaveScenario(FileName);
  end;
 end;
end;

procedure TfmMain.mSaveBothClick(Sender: TObject);
begin
 SaveBoth(BrkPath,LibIndex);
end;

procedure TfmMain.mSaveBothAsClick(Sender: TObject);
begin
 If (Length(Lib)<1) or (BrkCount<1) then Exit;
 With DlgSave do begin
  Filter:= 'LBA 2 Background (lba_bkg.hqr)|*lba_bkg*.hqr';
  DefaultExt:= 'hqr';
  FilterIndex:= 1;
  FileName:= ExtractFileName(BrkPath);
  InitialDir:= LastHqrPath;
  If Execute then begin
   LastHqrPath:= ExtractFilePath(FileName);
   SaveBoth(FileName,LibIndex);
  end;
 end;
end;

procedure TfmMain.pbBrickPaint(Sender: TObject);
begin
 UpdateImage(bufBrick,pbBrick);
end;

procedure OpenParam();
var a: Integer;
    ext, name: String;
begin
 for a:= 1 to Smaller(ParamCount,2) do
   If FileExists(ParamStr(a)) then begin
     name:= LowerCase(ExtractFileName(ParamStr(a)));
     ext:= ExtractFileExt(name);
     If (ext = '.brk') or ((ext = '.hqr') and (IsBkg(name)
     or AnsiContainsText(name, 'lba_brk'))) then
       OpenBricks(ParamStr(a))
     else if (ext = '.bl1') or (ext = '.bl2') or (ext = '.lt1') or (ext = '.lt2')
     or ((ext = '.hqr') and (IsBkg(name) or AnsiContainsText(name, 'lba_bll'))) then
       LoadLibrary(ParamStr(a))
     else if (ext = '.hqs') and (a = 1) then begin
       OpenScenario(ParamStr(1));
       Exit;
     end
     else begin
       MessageBox(fmMain.Handle,'Invalid parameter(s)','Little Big Factory',MB_ICONERROR+MB_OK);
       Exit;
     end;
   end;
end;

procedure TfmMain.FormResize(Sender: TObject);
var temp: Integer;
begin
 SetTabCaptions();
 SetDimensions(bufBrick, pbBrick.Width, pbBrick.Height);
 SetDimensions(bufLayout, pbLayout.Width, pbLayout.Height);
 temp:= sbBricks.Position * BrkPerRow;
 //If {BrkPerRow<>pbBrick.Width div 51 then} PageControl.ActivePageIndex=0 then
  PaintBricks();
 //else
 SetScrollBrk();
 MapLayouts();
 CalcPositions();
 SetScrollLt(True);
 PaintLayouts();
 sbBricks.Position:= temp div BrkPerRow;
end;

procedure TfmMain.sbBricksChange(Sender: TObject);
begin
 PaintBricks();
end;

procedure TfmMain.FormCreate(Sender: TObject);
var Beta: Boolean;
begin
 lbVersion.Caption:= 'Version ' + ReadProgramVersion(Beta);

 CloseAll();
 BrkTab.DoubleBuffered:= True;
 LibTab.DoubleBuffered:= True;
 SetDimensions(bufLayout, pbLayout.Width, pbLayout.Height);
end;

procedure TfmMain.pbBrickMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var NewSel: Integer;
begin
 If X > BrkPerRow*51 - 1 then Exit;
 NewSel:= ((Y div 41) + sbBricks.Position) * BrkPerRow + (X div 51);
 If NewSel > BrkCount - 1 then Exit;
 Bricks.PaintBrick((BrkSelect mod BrkPerRow)*51, ((BrkSelect div BrkPerRow)-sbBricks.Position)*41,
   BrkSelect, bufBrick, False, mIndexes.Checked, mFrames.Checked);
 BrkSelect:= NewSel;
 Bricks.PaintBrick((NewSel mod BrkPerRow)*51, ((NewSel div BrkPerRow)-sbBricks.Position)*41,
   NewSel, bufBrick, True, mIndexes.Checked, mFrames.Checked);
 UpdateInfo();
 UpdateImage(bufBrick, pbBrick);
end;

procedure TfmMain.mEditBrkClick(Sender: TObject);
begin
 If BrkCount >= 1 then
   ShowBrickEditor(BrkSelect);
end;

procedure TfmMain.mExportBrkClick(Sender: TObject);
begin
 If BrkCount >= 1 then
   ExportBrick(bitBuffers[BrkSelect]);
end;

procedure TfmMain.mImportBrkClick(Sender: TObject);
begin
 {With EditForm.dlOpen do begin
  InitialDir:=LastExportPath;
  If Execute then begin
   LastExportPath:=ExtractFilePath(FileName);
   S:=BitBrickToBrick(Brick);
   AssignFile(f,FileName);
   FileMode:=fmOpenWrite;
   Rewrite(f,1);
   BlockWrite(f,S[1],Length(S));
   CloseFile(f);
   Beep;
  end;
 end; }
end;

procedure TfmMain.mExportBrkBitClick(Sender: TObject);
begin
 If BrkCount < 1 then Exit;
 With DlgSave do begin
  DefaultExt:='bmp';
  Filter:='Bitmaps (*.bmp)|*.bmp';
  FilterIndex:=1;
  InitialDir:=LastExportPath;
  If Execute then begin
   LastExportPath:=ExtractFilePath(FileName);
   Buffer.Width:=48;
   Buffer.Height:=38;
   Buffer.Canvas.Brush.Color:=clWhite;
   Buffer.Canvas.FillRect(Rect(0,0,48,38));
   DrawBitBrick(bitBuffers[BrkSelect],0,0,Buffer);
   Buffer.SaveToFile(FileName);
  end;
 end;
end;

procedure TfmMain.mExportLayClick(Sender: TObject);
begin
 If Length(Lib)<1 then Exit;
 ExportLayout(Lib[LtSelect]);
end;

procedure TfmMain.mExportLayBitClick(Sender: TObject);
begin
 If Length(Lib) < 1 then Exit;
 With DlgSave do begin
  DefaultExt:= 'bmp';
  Filter:= 'Bitmaps (*.bmp)|*.bmp';
  FilterIndex:= 1;
  InitialDir:= LastExportPath;
  If Execute then begin
   LastExportPath:= ExtractFilePath(FileName);
   Buffer.Width:= GetLtWidth(Lib[LtSelect]);
   Buffer.Height:= GetLtHeight(Lib[LtSelect]);
   Buffer.Canvas.Brush.Color:= clWhite;
   Buffer.Canvas.FillRect(Rect(0,0,Buffer.Width,Buffer.Height));
   DrawLayout(0,-1,LtSelect,Buffer,mFrames.Checked,false);
   Buffer.SaveToFile(FileName);
  end;
 end;
end;

procedure TfmMain.mLayImpHqsRepClick(Sender: TObject);
var Scen: TPackEntries;
    Info: THQSInfo;
    ExtLib: TCubeLib;
    Checks: TBoolDynAr;
    a: Integer;
    Pal: TPalette;
begin
 DlgOpen.Title:= 'Choose the Scenario to import Layout from';
 DlgOpen.FileName:= '';
 DlgOpen.Filter:= 'High Quality Scenarios (*.hqs)|*.hqs';
 DlgOpen.InitialDir:= LastScenPath;
 if DlgOpen.Execute then begin
   if OpenScenarioPreview(DlgOpen.FileName, Scen, ExtLib, Info) then begin
     if Scen[PaletteEntry].FType = -1 then
       Pal:= LoadPaletteFromString(UnpackToString(Scen[PaletteEntry]))
     else
       Pal:= LoadPaletteFromResource(IfThen(Info.Lba2,2,1));
     if TfmLayImport.ShowDialog(ExtLib, Scen, Info.FirstBrick, -1, Pal, Checks) then begin
       for a:= 0 to High(Checks) do
         if Checks[a] then begin
           if Settings.ImportAutoPal then
             InsertLayout(ExtLib[a], Scen, Info.FirstBrick, Pal, LtSelect)
           else
             InsertLayout(ExtLib[a], Scen, Info.FirstBrick, LtSelect);
           RefreshLayouts(LtSelect);
           EnableSaveMenu();
           Exit;
         end;
     end;
   end;
 end;
end;

procedure TfmMain.mLayImpHqsNewClick(Sender: TObject);
var Scen: TPackEntries;
    Info: THQSInfo;
    ExtLib: TCubeLib;
    Checks: TBoolDynAr;
    a, id: Integer;
    Pal: TPalette;
begin
 if Length(Lib) >= 255 then
   WarningMsg('This Library already has 255 Layouts. It is the maximum number of Layouts that a Library may hold. Delete one of the existing Layouts to be able to import one.')
 else begin
   DlgOpen.Title:= 'Choose the Scenario to import Layouts from';
   DlgOpen.FileName:= '';
   DlgOpen.Filter:= 'High Quality Scenarios (*.hqs)|*.hqs';
   DlgOpen.InitialDir:= LastScenPath;
   if DlgOpen.Execute then begin
     if OpenScenarioPreview(DlgOpen.FileName, Scen, ExtLib, Info) then begin
       if Scen[PaletteEntry].FType = -1 then
         Pal:= LoadPaletteFromString(UnpackToString(Scen[PaletteEntry]))
       else
         Pal:= LoadPaletteFromResource(IfThen(Info.Lba2,2,1));
       if TfmLayImport.ShowDialog(ExtLib, Scen, Info.FirstBrick, 255 - Length(Lib),
            Pal, Checks)
       then begin
         for a:= 0 to High(Checks) do
           if Checks[a] then begin
             if Settings.ImportAutoPal then
               id:= InsertLayout(ExtLib[a], Scen, Info.FirstBrick, Pal, LtSelect)
             else
               id:= InsertLayout(ExtLib[a], Scen, Info.FirstBrick);
             RefreshLayouts(id);
             EnableSaveMenu();
           end;
       end;
     end;
   end;
 end;
end;

procedure TfmMain.mBrkInsBeforeClick(Sender: TObject);
var a: Integer;
begin
 If ((Sender as TMenuItem).Name='mInsAfter') and (Length(VBricks)>0) then Inc(BrkSelect);
 SetLength(VBricks, Length(VBricks)+1);
 Inc(BrkCount);
 Screen.Cursor:= crHourGlass;
 for a:= High(VBricks)-1 downto BrkSelect + BrkOffset do
   VBricks[a+1]:= VBricks[a];
 VBricks[BrkSelect+BrkOffset]:= PackEntry(#01#01#23#18#01#00);
 SetLength(Buffered, BrkCount);
 SetLength(bitBuffers, BrkCount);
 for a:= 0 to High(Buffered) do Buffered[a]:= False;
 Allocated:= 0;
 UpdateInfo();
 SetScrollBrk();
 EnableSaveMenu();
 LibTab.TabVisible:= (Length(Lib)>0) and (BrkCount>0);
 PaintBricks();
 PaintLayouts();
 Screen.Cursor:= crDefault;
end;

procedure TfmMain.mBrkMoveForwClick(Sender: TObject);
var temp: TPackEntry;
    a: Integer;
begin
 If BrkCount < 2 then Exit;
 If (Sender as TMenuItem).Name='mMoveForw' then begin
  If BrkSelect >= BrkCount then Exit;
  a:=1;
 end
 else begin
  If BrkSelect <= 0 then Exit;
  a:=-1;
 end;
 temp:=VBricks[BrkSelect+BrkOffset];
 VBricks[BrkSelect+BrkOffset]:=VBricks[BrkSelect+BrkOffset+a];
 VBricks[BrkSelect+BrkOffset+a]:=temp;
 Buffered[BrkSelect]:=False;
 Buffered[BrkSelect+a]:=False;
 Dec(Allocated,2);
 BrkSelect:=BrkSelect+a;
 UpdateInfo;
 PaintBricks;
 PaintLayouts;
end;

procedure TfmMain.mBrkDeleteClick(Sender: TObject);
var a: Integer;
begin
 If BrkCount < 1 then Exit;
 Screen.Cursor:= crHourGlass;
 for a:= BrkSelect+BrkOffset to High(VBricks)-1 do
   VBricks[a]:= VBricks[a+1];
 SetLength(VBricks,Length(VBricks)-1);
 Dec(BrkCount);
 SetLength(Buffered,BrkCount);
 SetLength(bitBuffers,BrkCount);
 for a:= 0 to High(Buffered) do Buffered[a]:= False;
 Allocated:= 0;
 If BrkSelect > BrkCount-1 then BrkSelect:= BrkCount-1;
 If BrkSelect < 0 then BrkSelect:= 0;
 UpdateInfo();
 If BrkCount = 0 then LibTab.TabVisible:= False;
 SetScrollBrk();
 PaintBricks();
 PaintLayouts();
 Screen.Cursor:= crDefault;
end;

procedure TfmMain.mLockBrickClick(Sender: TObject);
begin
 If Assigned(Sender) and not mLockBrick.Checked
 and (Application.MessageBox('Modifying structure of Bricks can mess all Layouts and Grids up.'#13'Especially when you delete or insert a Brick. All Bricks that are after it move, thus their indexes change. '+
   'Since Layouts refer to Bricks by their indexes, the ones that use Bricks after the deleted/inserted one will be messed up.'#13#13'Are you aware of that?','Little Big Factory',MB_ICONWARNING+MB_YESNO)=ID_NO)
 then
   mLockBrick.Checked:= True
 else begin
  mBrkInsBefore.Enabled:= not mLockBrick.Checked;
  mBrkInsAfter.Enabled:= not mLockBrick.Checked;
  mBrkMoveForw.Enabled:= not mLockBrick.Checked;
  mBrkMoveBack.Enabled:= not mLockBrick.Checked;
  mBrkDelete.Enabled:= not mLockBrick.Checked;
 end;
end;

Procedure CheckSaved(Bricks, Layouts: Boolean);
begin
 If Bricks and Layouts and fmMain.mSaveBoth.Enabled
 and (BricksModified or LayoutsModified) then
  Case MessageBox(fmMain.Handle,'Some Bricks and/or Layouts have been modified. Save the whole BKG file?','Little Big Factory',MB_ICONQUESTION+MB_YESNOCANCEL) of
    ID_YES: fmMain.mSaveBothClick(fmMain);
    ID_CANCEL: Abort;
  end
 else begin
  If Bricks and BricksModified then
   Case MessageBox(fmMain.Handle,'Some Bricks have been modified. Save the whole Hqr file?','Little Big Factory',MB_ICONQUESTION+MB_YESNOCANCEL) of
    ID_YES: If fmMain.mSaveBrk.Enabled then fmMain.mSaveBrkClick(fmMain.mSaveBrk)
            else fmMain.mSaveBothClick(fmMain);
    ID_CANCEL: Abort;
   end;
  If Layouts and LayoutsModified then
   Case MessageBox(fmMain.Handle,'Some Layouts have been modified. Save the Library?','Little Big Factory',MB_ICONQUESTION+MB_YESNOCANCEL) of
    ID_YES: If fmMain.mSaveLib.Enabled then fmMain.mSaveLibClick(fmMain)
            else fmMain.mSaveBothClick(fmMain);
    ID_CANCEL: Abort;
   end;
 end;
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 CheckSaved(True,True);
end;

{$o-}
procedure TfmMain.btTestClick(Sender: TObject);
var a, b, c, d, pX, pY, pZ: integer;
    e: array of Integer;
    jest: boolean;
begin
 lbTest.Caption:='';
 SetLength(e,0);
 //for a:=0 to 255 do
 // c[a]:=0;

 pZ:=0;
 for d:=1 to High(Lib) do
  for c:=0 to Lib[d].Z-1 do
   for b:=0 to Lib[d].Y-1 do
    for a:=0 to Lib[d].X-1 do begin
     jest:=false;
     for pX:=0 to High(e) do
      If Lib[d].Map[a,b,c].Index=e[pX] then begin
       jest:=true;
       break;
      end;
     If not jest and (Lib[d].Map[a,b,c].Index>0) then begin
      Inc(pZ,VBricks[Lib[d].Map[a,b,c].Index+BrkOffset].RlSize);
      SetLength(e,Length(e)+1);
      e[High(e)]:=Lib[d].Map[a,b,c].Index;
     end;
   end;

  lbTest.Caption:=IntToStr(pZ);
 //for a:=1 to High(Lib) do
 // for b:=0 to High(Lib[a].Map) do
 //  Inc(c[Lib[a].Map[b].Sound]);

 //for a:=0 to High(e) do
  //If e[a]>0 then Memo1.Lines.Add(IntToStr(a))
  //else Memo1.Lines.Add('-----------------');

 //for a:=0 to 255 do
 // If c[a]>0 then Label14.Caption:=Label14.Caption+IntToHex(a,2)+': '+IntToStr(c[a])+#13;

 //Label14.Hint:=Label14.Caption;

 {for a:=1 to High(LLibrary) do
  for b:=0 to High(LLibrary[a].Map) do
   If LLibrary[a].Map[b].Sound=$67 then begin
    Label14.Caption:='Jest!';
   end;}
end;
{$o+}

procedure TfmMain.sbLayoutsChange(Sender: TObject);
begin
 PaintLayouts;
end;

procedure TfmMain.pbLayoutMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var a, NewSel: Integer;
begin
 If ssDouble in Shift then Exit; 
 NewSel:=-1;
 for a:=0 to High(LtPos) do
  if PointInRect(Bounds(LtPos[a].X,LtPos[a].Y-sbLayouts.Position,LtDim[a].X,LtDim[a].Y),X,Y) then begin
   NewSel:=a;
   Break;
  end;

 If (NewSel<0) or (NewSel>High(Lib)) then Exit;
 PaintLayout(LtPos[LtSelect].X,LtPos[LtSelect].Y-sbLayouts.Position,
  LtSelect,bufLayout,False,mFrames.Checked);
 LtSelect:=NewSel;
 PaintLayout(LtPos[NewSel].X,LtPos[NewSel].Y-sbLayouts.Position,
  NewSel,bufLayout,True,mFrames.Checked);
 UpdateInfo;
 UpdateImage(bufLayout,pbLayout);
end;

procedure TfmMain.mLtEditImgClick(Sender: TObject);
begin
 If Length(Lib)<1 then Exit;
 ShowLayoutEditor(LtSelect);
end;

procedure TfmMain.edGoToKeyPress(Sender: TObject; var Key: Char);
var a: Integer;
begin
 If (Key = #13) and TryStrToInt(edGoTo.Text,a) then begin
   If (a >= 1) and (a <= Length(Lib)) then begin
     LtSelect:= a - 1;
     sbLayouts.Position:= LtPos[a-1].Y;
     UpdateInfo();
   end;
 end;
end;

procedure TfmMain.mLtEditStrClick(Sender: TObject);
begin
 fmStruct.ShowStructEditor(LtSelect);
end;

procedure SetTabCaptions();
var wb, wbm, wbt, wl, wlt, ww: Integer;
    sIndex, sBrk, sLib, sB, sL: String;
begin
 If SingleBrick then sB:='Brick' else sB:='Bricks';
 If SingleLayout then sL:='Layout' else sL:='Library';
 With fmMain.pcContent do begin
  sIndex:= IfThen(LibIndex>-1,', '+IntToStr(LibIndex+1));
  If BrkPath = '' then sBrk:= 'Unsaved ' + sB else sBrk:= BrkPath;
  If LibPath = '' then sLib:= 'Unsaved ' + sL else sLib:= LibPath + sIndex;
  If fmMain.BrkTab.TabVisible and fmMain.LibTab.TabVisible then begin
   wbt:= Canvas.TextWidth(sB+' - ');
   wlt:= Canvas.TextWidth(sL+' - '+sIndex);
   wb:= Canvas.TextWidth(BrkPath) + wbt;
   wbm:= Canvas.TextWidth(MinimizeName(BrkPath,Canvas,0))+wbt;
   wl:= Canvas.TextWidth(LibPath) + wlt;
   ww:= Width - 28;

   If wb + wl > ww then begin
    if wl > ww - wbm then begin
      sBrk:= MinimizeName(BrkPath, Canvas,0);
      sLib:= MinimizeName(LibPath,Canvas,ww-wbm-wlt) + sIndex;
    end else
      sBrk:= MinimizeName(BrkPath,Canvas,ww-wl-wbt);
   end;
  end;
  fmMain.BrkTab.Caption:= sB + ' - ' + sBrk;
  fmMain.LibTab.Caption:= sL + ' - ' + sLib;
 end;
end;

procedure TfmMain.pcContentDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
var TextW, x: Integer;
begin
 Control.Canvas.Brush.Color:=clBtnFace;
 Control.Canvas.FillRect(Rect);
 TextW:=Control.Canvas.TextWidth(pcContent.Pages[TabIndex].Caption);
 x:=(Rect.Left+Rect.Right-TextW) div 2;
 Control.Canvas.TextOut(x,Rect.Top+4, pcContent.Pages[TabIndex].Caption);
 Control.Canvas.Font.Color:=clPurple;
 If TabIndex=0 then
  Control.Canvas.TextOut(x,Rect.Top+4,IfThen(SingleBrick,'Brick - ','Bricks - '))
 else
  Control.Canvas.TextOut(x,Rect.Top+4,IfThen(SingleLayout,'Layout - ','Library - '));
end;

procedure TfmMain.mExitClick(Sender: TObject);
begin
 Close;
end;

procedure TfmMain.mLockLibClick(Sender: TObject);
var ext: String;
begin
 If Assigned(Sender) and not mLockLib.Checked
 and (MessageBox(Handle, 'You are about to enable deleting Layouts and editing their images. Before you do it, please read what these features do, which might be different from what you think they do.'#13#13
   + ' Edit image - brings Editor window, in which you can edit BRICKS (not the Layout itself) that this Layout is made of. For your convenience this feature puts the Bricks together as one Layout for editing, '
   + 'and splits them back after editing is done. Layout itself will NOT be modified during this operation.'#13#13
   + ' Delete - removes selected Layout from the Library, but DOES NOT REMOVE IT''S BRICKS, because some other Layouts may be using them as well. In addition, deleting a Layout can mess all Grids that use it up. '
   + 'All Layouts that have higher indexes will move, thus their indexes will change. Since Grids refer to Layouts by their indexes, all Layouts after the deleted one will have different indexes, which will cause '
   + 'the Grid to put them in wrong places.'#13#13
   + 'Are you aware of all these issues?',
 'Little Big Factory', MB_ICONWARNING+MB_YESNO) = ID_NO) then
   mLockLib.Checked:= True
 else begin
   ext:= LowerCase(ExtractFileExt(LibPath));
   mDeleteLt.Enabled:= not (mLockLib.Checked or SingleLayout);
   mLtEditImg.Enabled:= not mLockLib.Checked;
 end;
end;

procedure TfmMain.mNewLtClick(Sender: TObject);
var temp: TCubeLt;
    x, y, z: Integer;
begin
 if Length(Lib) >= 255 then
   MessageBox(Handle,'This Library already has 255 Layouts. It is the maximum number of Layouts that a Library may hold. Delete one of the existing Layouts to be able to create a new one.','Little Big Factory',MB_ICONINFORMATION+MB_OK)
 else begin
   x:= 1;
   y:= 1;
   z:= 1;
   if TfmDimensions.ShowDialog(x, y ,z) then
     NewLayoutEditor(x, y, z);
 end;
end;

procedure TfmMain.mCopyLtClick(Sender: TObject);
var id, a, b, c, brk: Integer;
begin
 if Length(Lib) >= 255 then
   MessageBox(Handle,'This Library already has 255 Layouts. It is the maximum number of Layouts that a Library may hold. Delete one of the existing Layouts to be able to copy one.','Little Big Factory',MB_ICONINFORMATION+MB_OK)
 else begin
   Screen.Cursor:= crHourGlass;
   id:= CreateLayout(Lib[LtSelect].x, Lib[LtSelect].y, Lib[LtSelect].z);
   for c:= 0 to Lib[id].z - 1 do
    for b:= 0 to Lib[id].y - 1 do
     for a:= 0 to Lib[id].x - 1 do
      If (a = Lib[id].x-1) or (b = Lib[id].y-1) or (c = Lib[id].z-1) then begin
       If Lib[LtSelect].Map[a,b,c].Index <= 0 then
        VBricks[Lib[id].Map[a,b,c].Index+BrkOffset-1]:= PackEntry(#01#01#23#18#01#00)
       else
        VBricks[Lib[id].Map[a,b,c].Index+BrkOffset-1]:= VBricks[Lib[LtSelect].Map[a,b,c].Index+BrkOffset-1];
      end;
   RefreshLayouts(id);
   Screen.Cursor:= crDefault;
 end;
end;

procedure TfmMain.mRemSharingClick(Sender: TObject);
var a, b, c, brk: Integer;
    temp: TCubeLt;
begin
 Screen.Cursor:=crHourGlass;
 temp:=CopyLayout(Lib[LtSelect]);
 CreateLayout(Lib[LtSelect].x,Lib[LtSelect].y,Lib[LtSelect].z,LtSelect);
 for c:=0 to Lib[LtSelect].z-1 do
  for b:=0 to Lib[LtSelect].y-1 do
   for a:=0 to Lib[LtSelect].x-1 do
    If (a=Lib[LtSelect].x-1) or (b=Lib[LtSelect].y-1) or (c=Lib[LtSelect].z-1) then begin
     If Lib[LtSelect].Map[a,b,c].Index<=0 then
      VBricks[Lib[LtSelect].Map[a,b,c].Index+BrkOffset-1]:=PackEntry(#01#01#23#18#01#00)
     else
      VBricks[Lib[LtSelect].Map[a,b,c].Index+BrkOffset-1]:=VBricks[temp.Map[a,b,c].Index+BrkOffset-1];
    end;
 RefreshLayouts(-1);
 Screen.Cursor:=crDefault;
end;

procedure TfmMain.mDeleteLtClick(Sender: TObject);
var a, b, c: Integer;
    Found: Boolean;
begin
 if Length(Lib) >= 1 then begin
   Found:= False;
   for b:= 0 to High(LtMap) do
     for c:= 0 to High(LtMap[b]) do
       if LtMap[b,c] = LtSelect then begin
         Found:= True;
         Break;
       end;

   if Found then begin
     for a:= LtSelect to High(Lib)-1 do
       Lib[a]:= Lib[a+1];
     SetLength(Lib,Length(Lib)-1);
     AnalyzeLayouts();

     if b <= High(LtMap) then begin
       if c <= High(LtMap[b]) then LtSelect:= LtMap[b,c]
       else if Length(LtMap[b])>0 then LtSelect:= LtMap[b,High(LtMap[b])];
     end
     else LtSelect:= LtMap[High(LtMap), High(LtMap[High(LtMap)])];
     SetScrollLt(True);
     UpdateInfo();
     PaintLayouts();
     LayoutsModified:= True;
   end;  
 end
 else MessageBox(handle,'Library must contain at least one Layout','Little Big Factory',MB_ICONINFORMATION+MB_OK);
end;

procedure TfmMain.pcContentChange(Sender: TObject);
begin
 UpdateInfo();
end;

procedure TfmMain.btSortSizeClick(Sender: TObject);
begin
 If Length(Lib) < 1 then Exit;
 AnalyzeLayouts();
 SetScrollLt(True);
 PaintLayouts();
end;

procedure TfmMain.mNewClick(Sender: TObject);
var name: String;
begin
 name:= (Sender as TMenuItem).Name;
 If name = 'mNewBrk' then NewBrick(True)
 else if name = 'mNewBrkHqr' then NewBrick(False)
 else if name = 'mNewLt1' then NewLayout(True,True)
 else if name = 'mNewLt2' then NewLayout(True,False)
 else if name = 'mNewLib1' then NewLayout(False,True)
 else if name = 'mNewLib2' then NewLayout(False,False)
 //else if name='mNewBkg' then NewBkg;
end;

procedure TfmMain.pmBricksPopup(Sender: TObject);
var ena: Boolean;
begin
 ena:= BrkCount > 0;
 mEditBrk.Enabled:= ena;
 mExportBrk.Enabled:= ena;
 mExportBrkBit.Enabled:= ena;
 mImportBrk.Enabled:= ena;
 mBrkMoveForw.Enabled:= BrkCount > 1;
 mBrkMoveBack.Enabled:= BrkCount > 1;
 mBrkDelete.Enabled:= ena and not SingleBrick;
end;

procedure TfmMain.mFileClick(Sender: TObject);
var ena: Boolean;
begin
 ena:= BricksOpened and not SingleBrick;
 mNewLt1.Enabled:= ena;
 mNewLt2.Enabled:= ena;
 mNewLib1.Enabled:= ena;
 mNewLib2.Enabled:= ena;
end;

procedure TfmMain.pmLayoutsPopup(Sender: TObject);
 var ena: Boolean;
begin
 ena:= Length(Lib) > 0;
 mLtEditStr.Enabled:= ena;
 mLtEditImg.Enabled:= ena and not mLockLib.Checked;
 mExportLay.Enabled:= ena;
 mExportLayBit.Enabled:= ena;
 mCopyLt.Enabled:= ena;
 mRemSharing.Enabled:= ena;
 mDeleteLt.Enabled:= ena and not (mLockLib.Checked or SingleLayout);
end;

procedure TfmMain.mScenPropClick(Sender: TObject);
begin
 if fmScenarioProp.ShowDialog(not LLba1, PkScenario, HQSInfo.FragmentCount,
      HQSInfo.InfoText, ScenarioDesc, True)
 then ScenarioModified:= True;
end;

procedure TfmMain.mChooseEntryClick(Sender: TObject);
begin
 LoadLibrary(LibPath);
end;

procedure TfmMain.mStartWith1Click(Sender: TObject);
begin
 Settings.StartWith1:= mStartWith1.Checked;
end;

procedure TfmMain.cbBadBricksChange(Sender: TObject);
var Id: Integer;
begin
 if (cbBadBricks.ItemIndex >= 0)
 and TryStrToInt(cbBadBricks.Items[cbBadBricks.ItemIndex], Id) then begin
   GetBrkPerRow();
   sbBricks.Position:= EnsureRange(((Id-1) div BrkPerRow) - sbBricks.PageSize div 2,
                                   sbBricks.Min, sbBricks.Max);
   BrkSelect:= Id - 1;
   UpdateInfo();
   PaintBricks();
 end;
end;

procedure TfmMain.GetBrkPerRow();
begin
 BrkPerRow:= pbBrick.Width div 51;
 if BrkPerRow < 1 then BrkPerRow:= 1;
end;

procedure TfmMain.CloseAll();
begin
 paMain.Visible:= False;
 paSplash.Visible:= True;

 mExportScen.Enabled:= False;
 mScenProp.Enabled:= False;
 ScenarioDesc:= '';
 HQSInfo.InfoText:= '';
 SetLength(PkScenario, 0);

 mNewLt.Enabled:= False;
 mCopyLt.Enabled:= False;
 btSortSize.Enabled:= False;
 btSortIndex.Enabled:= False;
 edGoTo.Enabled:= False;
 mChooseEntry.Enabled:= False;
 mSaveBoth.Enabled:= False;
 mSaveBothAs.Enabled:= False;
 mSaveLib.Enabled:= False;
 mSaveLibAs.Enabled:= False;
 SetLength(Lib,0);
 LibIndex:= 0;
 LtSelect:= 1;
 SetLength(LtSort, 0);
 SetLength(LtMap, 0);
 SetLength(LtDim, 0);
 SetLength(LtPos, 0);
 LayoutsModified:= False;

 mSaveBrk.Enabled:= False;
 mSaveBrkAs.Enabled:= False;
 SetLength(VBricks, 0);
 BrkCount:= 0;
 BricksOpened:= False;
 BrkPerRow:= 1;
 BrkSelect:= 0;
 SetLength(Buffered, 0);
 SetLength(bitBuffers, 0);
 Allocated:= 0;
 BricksModified:= False;
end;

initialization
 bufLayout:= TBitmap.Create();
 bufLayout.pixelformat:= pf32bit;
 bufLayout.Transparent:= False;
 bufBrick:= TBitmap.Create();
 bufBrick.pixelformat:= pf32bit;
 bufBrick.Transparent:= False;

finalization
 FreeAndNil(bufLayout);
 FreeAndNil(bufBrick);

end.
