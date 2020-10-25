unit Projects;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PathEdit, StdCtrls, Buttons, ComCtrls, ExtCtrls, IniFiles, DePack;

type
  TfmProject = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    rb1CompNone: TRadioButton;
    rb1CompAlways: TRadioButton;
    rb1CompAuto: TRadioButton;
    GroupBox2: TGroupBox;
    rb2CompNone: TRadioButton;
    rb2CompAuto: TRadioButton;
    rb2CompAlways1: TRadioButton;
    rb2CompAlways2: TRadioButton;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    eMinSizeBenefit: TEdit;
    cbMinSizeBenefit: TComboBox;
    eMinTimeBenefit: TEdit;
    eMaxSizeLoss: TEdit;
    cbMaxSizeLoss: TComboBox;
    cbMinTimeBenefit: TComboBox;
    btOK: TBitBtn;
    btCancel: TBitBtn;
    TabSheet2: TTabSheet;
    tsOutFiles: TTabSheet;
    cbOutputSce: TCheckBox;
    Panel1: TPanel;
    rb2AutoBoth: TRadioButton;
    rb2AutoOnly1: TRadioButton;
    rb2AutoOnly2: TRadioButton;
    rbOutputType1: TRadioButton;
    Label8: TLabel;
    rbOutputType2: TRadioButton;
    pcOutFiles: TPageControl;
    tsOutLBA1: TTabSheet;
    tsOutLBA2: TTabSheet;
    gbOutLba1: TGroupBox;
    lbBllCap: TLabel;
    lbBrkCap: TLabel;
    cbOutputGri: TCheckBox;
    //peOutputGri: TPathEdit;
    cbOutputBllBrk: TCheckBox;
    gbOutLba2: TGroupBox;
    cbOutputBkg: TCheckBox;
    //peOutputBkg: TPathEdit;
    TabSheet4: TTabSheet;
    meDescription: TMemo;
    Label9: TLabel;
    tsGeneral: TTabSheet;
    cbAutoFrag: TCheckBox;
    Label10: TLabel;
    edFirstFrag: TEdit;
    Label14: TLabel;
    cbOverrideFrag: TCheckBox;
    Label13: TLabel;
    cbHqdGri: TCheckBox;
    cbHqdBll: TCheckBox;
    cbHqdSce: TCheckBox;
    cbHqdBkg: TCheckBox;
    cbCompOptOff: TCheckBox;
    lbCompOff: TLabel;
    GroupBox4: TGroupBox;
    cbUseRepeated: TCheckBox;
    cbLtsRemUnused: TCheckBox;
    cbBrkRemDoubled: TCheckBox;
    lbOptOff: TLabel;
    GroupBox5: TGroupBox;
    cbBrkForceInv: TCheckBox;
    eBrkForceInv: TEdit;
    btAutoFragHelp: TBitBtn;
    Label6: TLabel;
    Label7: TLabel;
    Label11: TLabel;
    procedure cbOverrideFragClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbCompOptOffClick(Sender: TObject);
    procedure cbOutputGriClick(Sender: TObject);
    procedure btAutoFragHelpClick(Sender: TObject);
  private
    { Private declarations }
  public
    peOutputGri: TPathEdit;
    peOutputBll: TPathEdit;
    peOutputBrk: TPathEdit;
    peOutputBkg: TPathEdit;
    peOutputSce: TPathEdit;
    Procedure ShowOptions();
  end;


var
  fmProject: TfmProject;
  f: TMemIniFile;
  CurrentProject: String = '';
  ProjectModified: Boolean = False;

  ProjectOptions: record
    General: record
      CompOptOff: Boolean;
      AutoFragment: Boolean;
      OverrideFrag: Boolean;
      OvFragValue: Integer;
    end;  
    Compression: record
      Lba1: Integer; // 0 = none, 1 = always type 1, 3 = auto
      Lba2: Integer; // 0 = none, 1 = always 1, 2 = always 2, 3 = auto
      Lba2Auto: Integer; // 0 = both, 1 = type 1 only, 2 = type 2 only
      MinSizeBenVal: Single;
      MinSizeBenUnit: Integer; // 0 = %, 1 = kB
      MinTimeBenVal: Single;
      MinTimeBenUnit: Integer; // 0 = %, 1 = sec.
      MaxSizeLossVal: Single;
      MaxSizeLossUnit: Integer; // 0 = %, 1 = kB
    end;
    Optimizations: record
      UseRepeated: Boolean;
      //BricksRemoveUnused: Boolean;
      BricksRemoveDoubled: Boolean;
      ForceInvisibleBrick: Boolean;
      ForceInvBrickValue: Integer;
      LayoutsRemoveUnused: Boolean;
    end;
    Output: record
      OutputLBA: Integer; // 1 = LBA 1, 2 = LBA 2;
      Lba1OutputGrid: Boolean;
      Lba1GridPath: String;
      Lba1GridHqd: Boolean;
      Lba1OutputLibBrk: Boolean;
      Lba1LibraryPath: String;
      Lba1LibraryHqd: Boolean;
      Lba1BrickPath: String;
      Lba2OutputBkg: Boolean;
      Lba2BkgPath: String;
      Lba2BkgHqd: Boolean;
      OutputScene: Boolean;
      ScenePath: String;
      SceneHqd: Boolean;
    end;
    Description: TStringList;
  end = (General: (AutoFragment: True);
         Compression: (Lba1: 3; Lba2: 3; Lba2Auto: 0; MinSizeBenVal: 1; MinSizeBenUnit: 0;
                       MinTimeBenVal: 1; MinTimeBenUnit: 0; MaxSizeLossVal: 1;
                       MaxSizeLossUnit: 0);
         Optimizations: (UseRepeated: True; BricksRemoveDoubled: True;
                         ForceInvisibleBrick: False; ForceInvBrickValue: 0;
                         LayoutsRemoveUnused: False);
         Output: (OutputLBA: 1; Lba1OutputGrid: True; Lba1GridPath: '';
                  Lba1OutputLibBrk: True; Lba1LibraryPath: ''; Lba1BrickPath: '';
                  Lba2OutputBkg: True; Lba2BkgPath: ''; OutputScene: True; ScenePath: '')
        );

function CheckExistingLine(Grid: Boolean; Line: Integer): Boolean;
Procedure LoadProject(path: String);
Procedure SaveProject(path: String);
procedure UnloadProject();
procedure SetProjectModified(val: Boolean);

implementation

uses Main, Editing, Utils, Settings;

{$R *.dfm}

function CheckExistingLine(Grid: Boolean; Line: Integer): Boolean;
begin
 if Grid then begin
   GridList[Line].MapEx:= (not ProjectOptions.Output.Lba1OutputGrid)
     or (GridList[Line].MapPath = '<B>')
     or (FileExists(GridList[Line].MapPath)
         and (ExtIs(GridList[Line].MapPath,'.gr1') or ExtIs(GridList[Line].MapPath,'.hqs')));
   GridList[Line].LibEx:= (not ProjectOptions.Output.Lba1OutputLibBrk)
     or (GridList[Line].LibPath = '<B>')
     or (FileExists(GridList[Line].LibPath)
         and (ExtIs(GridList[Line].LibPath,'.bl1') or ExtIs(GridList[Line].LibPath,'.hqs')));
   GridList[Line].BrickEx:= (not ProjectOptions.Output.Lba1OutputLibBrk)
     or (GridList[Line].BrickPath = '<B>')
     or (FileExists(GridList[Line].BrickPath)
         and (ExtIs(GridList[Line].BrickPath,'.hqr') or ExtIs(GridList[Line].BrickPath,'.hqs')));
   GridList[Line].SceneEx:= (not ProjectOptions.Output.OutputScene)
     or (GridList[Line].ScenePath = '<B>')
     or (FileExists(GridList[Line].ScenePath)
         and (ExtIs(GridList[Line].ScenePath,'.ls1') or ExtIs(GridList[Line].ScenePath,'.hqs')));

   Result:= GridList[Line].MapEx  and GridList[Line].LibEx
        and GridList[Line].BrickEx and GridList[Line].SceneEx;
 end else begin
   FragList[Line].MapEx:= (not ProjectOptions.Output.Lba1OutputGrid)
     or (FragList[Line].MapPath = '<B>')
     or (FileExists(FragList[Line].MapPath)
         and (ExtIs(FragList[Line].MapPath,'.gr1') or ExtIs(FragList[Line].MapPath,'.hqs')));
   FragList[Line].LibEx:= (not ProjectOptions.Output.Lba1OutputLibBrk)
     or (FragList[Line].LibPath = '<B>')
     or (FileExists(FragList[Line].LibPath)
         and (ExtIs(FragList[Line].LibPath,'.bl1') or ExtIs(FragList[Line].LibPath,'.hqs')));
   FragList[Line].BrickEx:= (not ProjectOptions.Output.Lba1OutputLibBrk)
     or (FragList[Line].BrickPath = '<B>')
     or (FileExists(FragList[Line].BrickPath)
         and (ExtIs(FragList[Line].BrickPath,'.hqr') or ExtIs(FragList[Line].BrickPath,'.hqs')));

   Result:= FragList[Line].MapEx  and FragList[Line].LibEx
        and FragList[Line].BrickEx;
 end;
end;

procedure CheckExistingFiles();
var a: Integer;
    GF: Boolean;
begin
 GF:= True;
 for a:= 0 to High(GridList) do
   if not CheckExistingLine(True, a) then GF:= False;
   //Don't exit when found to mark all cells
 for a:= 0 to High(FragList) do
   if not CheckExistingLine(False, a) then GF:= False;
 if not GF then
   WarningMsg('Some of the files in the lists don''t exist, the paths are invalid,'
            + ' cells are empty, or extensions are not appropriate. You will have to'
            + ' make sure all cells contain correct files, otherwise you will not be'
            + ' able to build the project.'#13#13'Invalid cells have been marked in red.');
end;

procedure CheckValues(var Subject: Integer; Values: array of Integer;
 DefaultIndex: Integer = 0);
var a: Integer;
begin
 for a:= 0 to High(Values) do
  If Subject = Values[a] then Exit;
 Subject:= Values[DefaultIndex];
end;

Procedure CheckRange(var Subject: Integer; Min, Max, Default: Integer); overload;
begin
 If (Subject < Min) or (Subject > Max) then Subject:= Default;
end;

Procedure CheckRange(var Subject: Single; Min, Max, Default: Single); overload;
begin
 If (Subject < Min) or (Subject > Max) then Subject:= Default;
end;

Procedure TfmProject.ShowOptions();
var sb, tb, sl: Single;
    bi, ov: Integer;
begin
 ov:= 121;
 cbCompOptOff.Checked:= ProjectOptions.General.CompOptOff;
 cbCompOptOffClick(nil);
 cbAutoFrag.Checked:= ProjectOptions.General.AutoFragment;
 cbOverrideFrag.Checked:= ProjectOptions.General.OverrideFrag;
 edFirstFrag.Text:= IntToStr(ProjectOptions.General.OvFragValue);
 Case ProjectOptions.Compression.Lba1 of
   0: rb1CompNone.Checked:= True;
   1: rb1CompAlways.Checked:= True;
   else rb1CompAuto.Checked:= True;
 end;
 Case ProjectOptions.Compression.Lba2 of
   0: rb2CompNone.Checked:= True;
   1: rb2CompAlways1.Checked:= True;
   2: rb2CompAlways2.Checked:= True;
   else rb2CompAuto.Checked:= True;
 end;
 Case ProjectOptions.Compression.Lba2Auto of
   0: rb2AutoBoth.Checked:= True;
   1: rb2AutoOnly1.Checked:= True;
   else rb2AutoOnly2.Checked:= True;
 end;
 eMinSizeBenefit.Text:= Format('%f',[ProjectOptions.Compression.MinSizeBenVal]);
 cbMinSizeBenefit.ItemIndex:= ProjectOptions.Compression.MinSizeBenUnit;
 eMinTimeBenefit.Text:= Format('%f',[ProjectOptions.Compression.MinTimeBenVal]);
 cbMinTimeBenefit.ItemIndex:= ProjectOptions.Compression.MinTimeBenUnit;
 eMaxSizeLoss.Text:= Format('%f',[ProjectOptions.Compression.MaxSizeLossVal]);
 cbMaxSizeLoss.ItemIndex:= ProjectOptions.Compression.MaxSizeLossUnit;
 cbUseRepeated.Checked:= ProjectOptions.Optimizations.UseRepeated;
 //cbBrkRemUnused.Checked:= ProjectOptions.Optimizations.BricksRemoveUnused;
 cbLtsRemUnused.Checked:= ProjectOptions.Optimizations.LayoutsRemoveUnused;
 cbBrkRemDoubled.Checked:= ProjectOptions.Optimizations.BricksRemoveDoubled;
 cbBrkForceInv.Checked:= ProjectOptions.Optimizations.ForceInvisibleBrick;
 eBrkForceInv.Text:= IntToStr(ProjectOptions.Optimizations.ForceInvBrickValue);
 If ProjectOptions.Output.OutputLba = 1 then rbOutputType1.Checked:= True
                                        else rbOutputType2.Checked:= True;
 cbOutputGri.Checked:= ProjectOptions.Output.Lba1OutputGrid;
 peOutputGri.Path:= ProjectOptions.Output.Lba1GridPath;
 cbHqdGri.Checked:= ProjectOptions.Output.Lba1GridHqd;
 cbOutputBllBrk.Checked:= ProjectOptions.Output.Lba1OutputLibBrk;
 peOutputBll.Path:= ProjectOptions.Output.Lba1LibraryPath;
 cbHqdBll.Checked:= ProjectOptions.Output.Lba1LibraryHqd;
 peOutputBrk.Path:= ProjectOptions.Output.Lba1BrickPath;
 cbOutputBkg.Checked:= ProjectOptions.Output.Lba2OutputBkg;
 peOutputBkg.Path:= ProjectOptions.Output.Lba2BkgPath;
 cbHqdBkg.Checked:= ProjectOptions.Output.Lba2BkgHqd;
 cbOutputSce.Checked:= ProjectOptions.Output.OutputScene;
 peOutputSce.Path:= ProjectOptions.Output.ScenePath;
 cbHqdSce.Checked:= ProjectOptions.Output.SceneHqd;
 meDescription.Lines.Assign(ProjectOptions.Description);
 //===========================================================
 While (ShowModal = mrOK)
 and not (TryStrToFloat(eMinSizeBenefit.Text,sb) and (sb >= 0)
      and TryStrToFloat(eMinTimeBenefit.Text,tb) and (tb >= 0)
      and TryStrToFloat(eMaxSizeLoss.Text,sl)    and (sl >= 0)
      and TryStrToInt(eBrkForceInv.Text,bi)      and (bi >= 0)
      and ((TryStrToInt(edFirstFrag.Text,ov) and (ov > 0)) or not cbOverrideFrag.Checked))
 do
   MessageBox(Handle,'At leas one of the number fields contains invalid number!'#13#13
                   + 'Field "Override default first Fragment row" should contain an integer number, greater than zero.'#13
                   + 'Fields "file size benefit is at least", "time benefit is at least" and "size loss is not higher than" should contain real numbers, greater or equal to zero.'#13
                   + 'Field "Force the invisible Brick at specific position" should contain an integer number, greater or equal to zero.','Stage Designer',MB_ICONERROR+MB_OK);
 If ModalResult = mrOK then begin
   ProjectOptions.General.CompOptOff:= cbCompOptOff.Checked;
   ProjectOptions.General.AutoFragment:= cbAutoFrag.Checked;
   ProjectOptions.General.OverrideFrag:= cbOverrideFrag.Checked;
   ProjectOptions.General.OvFragValue:= ov;
   If rb1CompNone.Checked then ProjectOptions.Compression.Lba1:= 0
   else if rb1CompAlways.Checked then ProjectOptions.Compression.Lba1:= 1
   else ProjectOptions.Compression.Lba1:= 3;
   If rb2CompNone.Checked then ProjectOptions.Compression.Lba2:= 0
   else if rb2CompAlways1.Checked then ProjectOptions.Compression.Lba2:= 1
   else if rb2CompAlways2.Checked then ProjectOptions.Compression.Lba2:= 2
   else ProjectOptions.Compression.Lba2:= 3;
   If rb2AutoBoth.Checked then ProjectOptions.Compression.Lba2Auto:= 0
   else if rb2AutoOnly1.Checked then ProjectOptions.Compression.Lba2Auto:= 1
   else ProjectOptions.Compression.Lba2Auto:= 2;
   ProjectOptions.Compression.MinSizeBenVal:= sb;
   ProjectOptions.Compression.MinSizeBenUnit:= cbMinSizeBenefit.ItemIndex;
   ProjectOptions.Compression.MinTimeBenVal:= tb;
   ProjectOptions.Compression.MinTimeBenUnit:= cbMinTimeBenefit.ItemIndex;
   ProjectOptions.Compression.MaxSizeLossVal:= sl;
   ProjectOptions.Compression.MaxSizeLossUnit:= cbMaxSizeLoss.ItemIndex;
   ProjectOptions.Optimizations.UseRepeated:= cbUseRepeated.Checked;
  // ProjectOptions.Optimizations.BricksRemoveUnused:= cbBrkRemUnused.Checked;
   ProjectOptions.Optimizations.LayoutsRemoveUnused:= cbLtsRemUnused.Checked;
   ProjectOptions.Optimizations.BricksRemoveDoubled:= cbBrkRemDoubled.Checked;
   ProjectOptions.Optimizations.ForceInvisibleBrick:= cbBrkForceInv.Checked;
   ProjectOptions.Optimizations.ForceInvBrickValue:= bi;
   If rbOutputType1.Checked then ProjectOptions.Output.OutputLba:= 1
                            else ProjectOptions.Output.OutputLba:= 2;
   ProjectOptions.Output.Lba1OutputGrid:= cbOutputGri.Checked;
   ProjectOptions.Output.Lba1GridPath:= peOutputGri.Path;
   ProjectOptions.Output.Lba1GridHqd:= cbHqdGri.Checked;
   ProjectOptions.Output.Lba1OutputLibBrk:= cbOutputBllBrk.Checked;
   ProjectOptions.Output.Lba1LibraryPath:= peOutputBll.Path;
   ProjectOptions.Output.Lba1LibraryHqd:= cbHqdBll.Checked;
   ProjectOptions.Output.Lba1BrickPath:= peOutputBrk.Path;
   ProjectOptions.Output.Lba2OutputBkg:= cbOutputBkg.Checked;
   ProjectOptions.Output.Lba2BkgPath:= peOutputBkg.Path;
   ProjectOptions.Output.Lba2BkgHqd:= cbHqdBkg.Checked;
   ProjectOptions.Output.OutputScene:= cbOutputSce.Checked;
   ProjectOptions.Output.ScenePath:= peOutputSce.Path;
   ProjectOptions.Output.SceneHqd:= cbHqdSce.Checked;
   ProjectOptions.Description.Assign(meDescription.Lines);
   SetProjectModified(True);
   CheckExistingFiles();
   fmMain.lvGrids.Repaint();
   fmMain.lvFrags.Repaint();
 end;
end;

Procedure LoadProject(path: String);
var a: Integer;
begin
 if FileExists(path) then begin
   f:= TMemIniFile.Create(path);
   try
     UnloadProject();

     //project options:
     ProjectOptions.General.CompOptOff:= f.ReadBool('General', 'CompOptOff', False);
     ProjectOptions.General.AutoFragment:= f.ReadBool('General', 'AutoFragment', False);
     ProjectOptions.General.OverrideFrag:= f.ReadBool('General', 'OverrideFrag', False);
     ProjectOptions.General.OvFragValue:= f.ReadInteger('General', 'OvFragValue', 171);
     CheckRange(ProjectOptions.General.OvFragValue, 1, 256, 171);

     ProjectOptions.Compression.Lba1:= f.ReadInteger('Compression', 'Lba1', 3);
     CheckValues(ProjectOptions.Compression.Lba1, [0,1,3], 2);
     ProjectOptions.Compression.Lba2:= f.ReadInteger('Compression', 'Lba2', 3);
     CheckRange(ProjectOptions.Compression.Lba2, 0, 3, 3);
     ProjectOptions.Compression.Lba2Auto:= f.ReadInteger('Compression', 'Lba2Auto', 0);
     CheckRange(ProjectOptions.Compression.Lba2Auto, 0, 2, 0);
     ProjectOptions.Compression.MinSizeBenVal:= f.ReadFloat('Compression', 'MinSizeBenVal', 1);
     CheckRange(ProjectOptions.Compression.MinSizeBenVal, 0, 1000000, 1);
     ProjectOptions.Compression.MinSizeBenUnit:= f.ReadInteger('Compression', 'MinSizeBenUnit', 0);
     CheckRange(ProjectOptions.Compression.MinSizeBenUnit, 0, 1, 0);
     ProjectOptions.Compression.MinTimeBenVal:= f.ReadFloat('Compression', 'MinTimeBenVal', 0.1);
     CheckRange(ProjectOptions.Compression.MinTimeBenVal, 0, 1000000, 0.1);
     ProjectOptions.Compression.MinTimeBenUnit:= f.ReadInteger('Compression', 'MinTimeBenUnit', 0);
     CheckRange(ProjectOptions.Compression.MinTimeBenUnit, 0, 1, 0);
     ProjectOptions.Compression.MaxSizeLossVal:= f.ReadFloat('Compression', 'MaxSizeLossVal', 1);
     CheckRange(ProjectOptions.Compression.MaxSizeLossVal, 0, 1000000, 1);
     ProjectOptions.Compression.MaxSizeLossUnit:= f.ReadInteger('Compression', 'MaxSizeLossUnit', 0);
     CheckRange(ProjectOptions.Compression.MaxSizeLossUnit, 0, 1, 0);

     ProjectOptions.Optimizations.UseRepeated:= f.ReadBool('Optimizations', 'UseRepeated', True);
     ProjectOptions.Optimizations.BricksRemoveDoubled:= f.ReadBool('Optimizations', 'BricksRemoveDoubled', True);
     ProjectOptions.Optimizations.ForceInvisibleBrick:= f.ReadBool('Optimizations', 'ForceInvisibleBrick', False);
     ProjectOptions.Optimizations.ForceInvBrickValue:= f.ReadInteger('Optimizations', 'ForceInvBrickValue', 0);
     CheckRange(ProjectOptions.Optimizations.ForceInvBrickValue, 0, 1000000, 0);
     ProjectOptions.Optimizations.LayoutsRemoveUnused:= f.ReadBool('Optimizations', 'LayoutsRemoveUnused', False);

     ProjectOptions.Output.OutputLba:= f.ReadInteger('Output', 'OutputType', 1);
     CheckRange(ProjectOptions.Output.OutputLba, 1, 2, 1);
     ProjectOptions.Output.Lba1OutputGrid:= f.ReadBool('Output', 'Lba1OutputGrid', True);
     ProjectOptions.Output.Lba1GridPath:= f.ReadString('Output', 'Lba1GridPath', '');
     ProjectOptions.Output.Lba1GridHqd:= f.ReadBool('Output', 'Lba1GridHqd', False);
     ProjectOptions.Output.Lba1OutputLibBrk:= f.ReadBool('Output', 'Lba1OutputLibBrk', True);
     ProjectOptions.Output.Lba1LibraryPath:= f.ReadString('Output', 'Lba1LibraryPath', '');
     ProjectOptions.Output.Lba1LibraryHqd:= f.ReadBool('Output', 'Lba1LibraryHqd', False);
     ProjectOptions.Output.Lba1BrickPath:= f.ReadString('Output', 'Lba1BrickPath', '');
     ProjectOptions.Output.Lba2OutputBkg:= f.ReadBool('Output', 'Lba2OutputBkg', True);
     ProjectOptions.Output.Lba2BkgPath:= f.ReadString('Output', 'Lba2BkgPath', '');
     ProjectOptions.Output.Lba2BkgHqd:= f.ReadBool('Output', 'Lba2BkgHqd', False);
     ProjectOptions.Output.OutputScene:= f.ReadBool('Output', 'OutputScene', True);
     ProjectOptions.Output.ScenePath:= f.ReadString('Output', 'ScenePath', '');
     ProjectOptions.Output.SceneHqd:= f.ReadBool('Output', 'SceneHqd', False);

     If f.SectionExists('Description') then begin
       a:= 0;
       while f.ValueExists('Description', IntToStr(a)) do begin
         ProjectOptions.Description.Add(f.ReadString('Description', IntToStr(a), ''));
         Inc(a);
       end;
     end;

     //project data:
     SetLength(GridList, f.ReadInteger('ProjectData','Count',0));
     for a:= 0 to High(GridList) do begin
       //Form1.lvList.Items.Add();
       GridList[a].MapPath:=     f.ReadString('ProjectData', IntToStr(a+1)+'gri','');
       GridList[a].LibPath:=     f.ReadString('ProjectData', IntToStr(a+1)+'lib','');
       GridList[a].BrickPath:=   f.ReadString('ProjectData', IntToStr(a+1)+'brk','');
       GridList[a].ScenePath:=   f.ReadString('ProjectData', IntToStr(a+1)+'sce','');
       GridList[a].Description:= f.ReadString('ProjectData', IntToStr(a+1)+'des','');
       If SameText(GridList[a].LibPath, '<B>')
       and not SameText(GridList[a].BrickPath, '<B>') then
         GridList[a].BrickPath:= '<B>';
       If SameText(GridList[a].BrickPath, '<B>')
       and not SameText(GridList[a].LibPath, '<B>') then
        GridList[a].LibPath:= '<B>';
     end;
     fmMain.lvGrids.Items.Count:= Length(GridList);
     fmMain.lvTest.SetItemCount(Length(GridList));
     SetLength(FragList, f.ReadInteger('ProjectDataF','Count',0));
     for a:= 0 to High(FragList) do begin
       FragList[a].MapPath:=     f.ReadString('ProjectDataF', IntToStr(a+1)+'fra','');
       FragList[a].MapIndex:=    f.ReadInteger('ProjectDataF', IntToStr(a+1)+'fri',0);
       FragList[a].LibPath:=     f.ReadString('ProjectDataF', IntToStr(a+1)+'lib','');
       FragList[a].BrickPath:=   f.ReadString('ProjectDataF', IntToStr(a+1)+'brk','');
       FragList[a].Description:= f.ReadString('ProjectDataF', IntToStr(a+1)+'des','');
       if SameText(FragList[a].LibPath, '<B>')
       and not SameText(FragList[a].BrickPath, '<B>') then
         FragList[a].BrickPath:= '<B>';
       if SameText(FragList[a].BrickPath, '<B>')
       and not SameText(FragList[a].LibPath, '<B>') then
         FragList[a].LibPath:= '<B>';
     end;
     fmMain.lvFrags.Items.Count:= Length(FragList);

     CurrentProject:= path;
     MainSettings.LastProject:= path;
     fmMain.AddToRecent(path);
     fmMain.dlSave.FileName:= ExtractFileName(path);
     fmMain.Caption:= 'Little Stage Designer [' + ExtractFileName(path) + ']';

     CheckExistingFiles();

   finally
     FreeAndNil(f);
   end;
 end else begin
   CurrentProject:= '';
   MainSettings.LastProject:= '';
   fmMain.dlSave.FileName:= '';
   fmMain.Caption:= 'Little Stage Designer';
   ErrorMsg('Project file does not exist!');
 end;
 MainSettings.LastProjectDir:= ExtractFilePath(MainSettings.LastProject);
 SetProjectModified(False);
 Application.Title:= fmMain.Caption;
 fmMain.lvGrids.Repaint();
 fmMain.lvFrags.Repaint();
end;

Procedure SaveProject(path: String);
var a: Integer;
    row: String;
begin
 f:= TMemIniFile.Create(path);
 try
   //project options:
   f.WriteBool('General', 'CompOptOff', ProjectOptions.General.CompOptOff);
   f.WriteBool('General', 'AutoFragment', ProjectOptions.General.AutoFragment);
   f.WriteBool('General', 'OverrideFrag', ProjectOptions.General.OverrideFrag);
   f.WriteInteger('General', 'OvFragValue', ProjectOptions.General.OvFragValue);

   f.WriteInteger('Compression','Lba1',ProjectOptions.Compression.Lba1);
   f.WriteInteger('Compression','Lba2',ProjectOptions.Compression.Lba2);
   f.WriteInteger('Compression','Lba2Auto',ProjectOptions.Compression.Lba2Auto);
   f.WriteFloat('Compression','MinSizeBenVal',ProjectOptions.Compression.MinSizeBenVal);
   f.WriteInteger('Compression','MinSizeBenUnit',ProjectOptions.Compression.MinSizeBenUnit);
   f.WriteFloat('Compression','MinTimeBenVal',ProjectOptions.Compression.MinTimeBenVal);
   f.WriteInteger('Compression','MinTimeBenUnit',ProjectOptions.Compression.MinTimeBenUnit);
   f.WriteFloat('Compression','MaxSizeLossVal',ProjectOptions.Compression.MaxSizeLossVal);
   f.WriteInteger('Compression','MaxSizeLossUnit',ProjectOptions.Compression.MaxSizeLossUnit);

   f.WriteBool('Optimizations','UseRepeated',ProjectOptions.Optimizations.UseRepeated);
   f.WriteBool('Optimizations','BricksRemoveDoubled',ProjectOptions.Optimizations.BricksRemoveDoubled);
   f.WriteBool('Optimizations','ForceInvisibleBrick',ProjectOptions.Optimizations.ForceInvisibleBrick);
   f.WriteInteger('Optimizations','ForceInvBrickValue',ProjectOptions.Optimizations.ForceInvBrickValue);
   f.WriteBool('Optimizations','LayoutsRemoveUnused',ProjectOptions.Optimizations.LayoutsRemoveUnused);

   f.WriteInteger('Output','OutputType',ProjectOptions.Output.OutputLba);
   f.WriteBool('Output','Lba1OutputGrid',ProjectOptions.Output.Lba1OutputGrid);
   f.WriteString('Output','Lba1GridPath',ProjectOptions.Output.Lba1GridPath);
   f.WriteBool('Output','Lba1GridHqd',ProjectOptions.Output.Lba1GridHqd);
   f.WriteBool('Output','Lba1OutputLibBrk',ProjectOptions.Output.Lba1OutputLibBrk);
   f.WriteString('Output','Lba1LibraryPath',ProjectOptions.Output.Lba1LibraryPath);
   f.WriteBool('Output','Lba1LibraryHqd',ProjectOptions.Output.Lba1LibraryHqd);
   f.WriteString('Output','Lba1BrickPath',ProjectOptions.Output.Lba1BrickPath);
   f.WriteBool('Output','Lba2OutputBkg',ProjectOptions.Output.Lba2OutputBkg);
   f.WriteString('Output','Lba2BkgPath',ProjectOptions.Output.Lba2BkgPath);
   f.WriteBool('Output','Lba2BkgHqd',ProjectOptions.Output.Lba2BkgHqd);
   f.WriteBool('Output','OutputScene',ProjectOptions.Output.OutputScene);
   f.WriteString('Output','ScenePath',ProjectOptions.Output.ScenePath);
   f.WriteBool('Output','SceneHqd',ProjectOptions.Output.SceneHqd);

   f.EraseSection('Description');
   for a:= 0 to ProjectOptions.Description.Count - 1 do
     f.WriteString('Description', IntToStr(a), ProjectOptions.Description.Strings[a]);

   //project data:
   f.EraseSection('ProjectData');
   f.WriteInteger('ProjectData', 'Count', Length(GridList));
   for a:= 0 to High(GridList) do begin
     row:= IntToStr(a+1);
     if GridList[a].MapPath <> '' then
       f.WriteString('ProjectData', row+'gri', GridList[a].MapPath);
     if GridList[a].LibPath <> '' then
       f.WriteString('ProjectData', row+'lib', GridList[a].LibPath);
     if GridList[a].BrickPath <> '' then
       f.WriteString('ProjectData', row+'brk', GridList[a].BrickPath);
     if GridList[a].ScenePath <> '' then
       f.WriteString('ProjectData', row+'sce', GridList[a].ScenePath);
     if GridList[a].Description <> '' then
       f.WriteString('ProjectData', row+'des', GridList[a].Description);
   end;
   f.EraseSection('ProjectDataF');
   f.WriteInteger('ProjectDataF', 'Count', Length(FragList));
   for a:= 0 to High(FragList) do begin
     row:= IntToStr(a+1);
     if FragList[a].MapPath <> '' then begin
       f.WriteString('ProjectDataF', row+'fra', FragList[a].MapPath);
       f.WriteInteger('ProjectDataF', row+'fri', FragList[a].MapIndex);
     end;
     if FragList[a].LibPath <> '' then
       f.WriteString('ProjectDataF', row+'lib', FragList[a].LibPath);
     if FragList[a].BrickPath <> '' then
       f.WriteString('ProjectDataF', row+'brk', FragList[a].BrickPath);
     if FragList[a].Description <> '' then
       f.WriteString('ProjectDataF', row+'des', FragList[a].Description);
   end;

   f.UpdateFile();

   CurrentProject:= path;
   MainSettings.LastProject:= path;
   MainSettings.LastProjectDir:= ExtractFilePath(MainSettings.LastProject);
   fmMain.AddToRecent(path);
   SetProjectModified(False);
   fmMain.Caption:= 'Little Stage Designer [' + ExtractFileName(path) + ']';
   Application.Title:= fmMain.Caption;

 finally
   FreeAndNil(f);
 end;
end;

procedure UnloadProject();
begin
 fmMain.lvGrids.Items.Count:= 0;
 fmMain.lvTest.Items.Clear();
 fmMain.lvFrags.Items.Count:= 0;
 fmMain.lvGrids.Repaint();
 fmMain.lvFrags.Repaint();
 SetLength(GridList, 0);
 SetLength(FragList, 0);
 CurrentProject:= '';
 SetProjectModified(False);
 fmMain.Caption:= 'Little Stage Designer';
 Application.Title:= fmMain.Caption;
 GUndoState:= 0;
 GUndoHigh:= 0;
 FUndoState:= 0;
 FUndoHigh:= 0;
 fmMain.aUndo.Enabled:= False;
 fmMain.aRedo.Enabled:= False;
end;

procedure SetProjectModified(val: Boolean);
begin
 ProjectModified:= val;
 fmMain.aSaveProject.Enabled:= val;
 if val then fmMain.sbMain.Panels[0].Text:= 'Modified'
        else fmMain.sbMain.Panels[0].Text:= '';
end;

procedure TfmProject.btAutoFragHelpClick(Sender: TObject);
begin
 InfoMsg('This option uses information stored in Scenario (HQS) files to automatically'
       + ' create all necessary Fragment entries (also called ''disappearing ceiling'
       + ' Grids'').'#13
       + 'The new Scenarios can hold Fragments inside them together with the main Grids.'
       + ' This enables the Grid creator to use Fragment names in addition to dummy'
       + ' indexes for SET_GRM commands and Zones of type 3, since the indexes are'
       + ' usually not known yet. During Script compilation Builder will include in the'
       + ' Scenario additional information associating the Fragments with places in the'
       + ' Scripts. Then if such a Scenario is used in the Designer Project the program'
       + ' will add the used Fragments from it to the end of the Grid HQR package and'
       + ' replace marked places in the appropriate Scripts with correct Fragment'
       + ' indexes.'#13#13
       + 'Alternatively, if this option is disabled, users will be able to add Fragments'
       + ' from Scenarios manually to the project (they can do that at any time,'
       + ' actually). This however requires the Fragment indexes in the Scripts to be'
       + ' set up to correct values manually.'#13#13
       + 'This feature will not work with regular Grids or Scenes (*.gr1, *.ls1), only'
       + ' with Scenarios. And to make it work for a row, the row has to have the same'
       + ' Scenario file path in both Grid and Scene column.');
end;

procedure TfmProject.cbCompOptOffClick(Sender: TObject);
begin
 lbCompOff.Visible:= cbCompOptOff.Checked;
 lbOptOff.Visible:= cbCompOptOff.Checked;
end;

procedure TfmProject.cbOutputGriClick(Sender: TObject);
begin
 peOutputGri.Enabled:= cbOutputGri.Checked;
 cbHqdGri.Enabled:= cbOutputGri.Checked;
 peOutputBll.Enabled:= cbOutputBllBrk.Checked;
 peOutputBrk.Enabled:= cbOutputBllBrk.Checked;
 lbBllCap.Enabled:= cbOutputBllBrk.Checked;
 lbBrkCap.Enabled:= cbOutputBllBrk.Checked;
 cbHqdBll.Enabled:= cbOutputBllBrk.Checked;
 peOutputSce.Enabled:= cbOutputSce.Checked;
 cbHqdSce.Enabled:= cbOutputSce.Checked;
 peOutputBkg.Enabled:= cbOutputBkg.Checked;
 cbHqdBkg.Enabled:= cbOutputBkg.Checked;
end;

procedure TfmProject.cbOverrideFragClick(Sender: TObject);
begin
 edFirstFrag.Enabled:= cbOverrideFrag.Checked;
end;

procedure TfmProject.FormCreate(Sender: TObject);
begin
 peOutputGri:= TPathEdit.Create(Self);
 peOutputGri.Parent:= gbOutLba1;
 peOutputGri.SetBounds(cbOutputGri.Left, 48, 433, 24);
 peOutputGri.PathKind:= pkFile;
 peOutputGri.IncPathDelimiter:= False;
 peOutputGri.FileFilter:= 'LBA Grids package (lba_gri.hqr)|*.hqr';
 peOutputGri.FileFilterIndex:= 1;

 peOutputBll:= TPathEdit.Create(Self);
 peOutputBll.Parent:= gbOutLba1;
 peOutputBll.SetBounds(lbBllCap.Left, 120, 433, 24);
 peOutputBll.PathKind:= pkFile;
 peOutputBll.IncPathDelimiter:= False;
 peOutputBll.FileFilter:= 'LBA Libraries package (lba_bll.hqr)|*.hqr';
 peOutputBll.FileFilterIndex:= 1;

 peOutputBrk:= TPathEdit.Create(Self);
 peOutputBrk.Parent:= gbOutLba1;
 peOutputBrk.SetBounds(lbBrkCap.Left, 160, 433, 24);
 peOutputBrk.PathKind:= pkFile;
 peOutputBrk.IncPathDelimiter:= False;
 peOutputBrk.FileFilter:= 'LBA Bricks package (lba_brk.hqr)|*.hqr';
 peOutputBrk.FileFilterIndex:= 1;

 peOutputBkg:= TPathEdit.Create(Self);
 peOutputBkg.Parent:= gbOutLba2;
 peOutputBkg.SetBounds(cbOutputBkg.Left, 48, 433, 24);
 peOutputBkg.PathKind:= pkFile;
 peOutputBkg.IncPathDelimiter:= False;
 peOutputBkg.FileFilter:= 'LBA Backgrounds package (lba_bkg.hqr)|*.hqr';
 peOutputBkg.FileFilterIndex:= 1;

 peOutputSce:= TPathEdit.Create(Self);
 peOutputSce.Parent:= tsOutFiles;
 peOutputSce.SetBounds(cbOutputSce.Left, 312, 433, 24);
 peOutputSce.PathKind:= pkFile;
 peOutputSce.IncPathDelimiter:= False;
 peOutputSce.FileFilter:= 'LBA Scenes package (scene.hqr)|*.hqr';
 peOutputSce.FileFilterIndex:= 1;
end;

initialization
 ProjectOptions.Description:= TStringList.Create();

finalization
 FreeAndNil(ProjectOptions.Description);

end.
 