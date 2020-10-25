unit OpScenGrid;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, PathEdit, StrUtils, ListForm;

type
  TfmOpScenGrid = class(TForm)
    Label1: TLabel;
    lbInfo: TLabel;
    OpenBtn: TButton;
    Button1: TButton;
    cmGrid: TComboBox;
    rb21: TRadioButton;
    rb22: TRadioButton;
    rb23: TRadioButton;
    grText: TStaticText;
    grBtn: TButton;
    DlgOpen: TOpenDialog;
    procedure rb21Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    Function OpenGridForScenario(Lba2: Boolean): Boolean;
  end;

function CheckGridVersion(GridLba2: Boolean; What: String): Boolean;
function CheckGridFragment(Fragment: Boolean): Boolean;

var
  fmOpScenGrid: TfmOpScenGrid;

implementation

uses OpenSim, Settings, Open, Rendering, DePack, ListDialog, Main, Scenario, Globals;

{$R *.dfm}

function CheckGridVersion(GridLba2: Boolean; What: String): Boolean;
begin
 Result:= False;
 If HQSInfo.Lba2 and not GridLba2 then
   Application.MessageBox(PChar('The Scenario is LBA 2 type, you cannot open an LBA 1 '+What+' for it!'),ProgramName,MB_ICONWARNING+MB_OK)
 else if not HQSInfo.Lba2 and GridLba2 then
   Application.MessageBox(PChar('The Scenario is LBA 1 type, you cannot open an LBA 2 '+What+' for it!'),ProgramName,MB_ICONWARNING+MB_OK)
 else
   Result:= True;
end;

function CheckGridFragment(Fragment: Boolean): Boolean;
begin
 Result:= False;
 If Fragment then
   Application.MessageBox('You cannot open a Grid Fragment for a Scenario!',ProgramName,MB_ICONWARNING+MB_OK)
 else
   Result:= True;
end;

Function TfmOpScenGrid.OpenGridForScenario(Lba2: Boolean): Boolean;
var p: TSmallPoint;
begin
 If rb21.Checked then Open.OpenGrid(GetFilePath(Lba1_GRI, 1),cmGrid.ItemIndex)
 else if rb22.Checked then begin
   p:= BkgEntriesCount(GetFilePath(Lba2_BKG, 2),itGrids);
   Open.OpenGrid(GetFilePath(Lba2_BKG, 2), cmGrid.ItemIndex + p.x - 1);
 end
 else Open.OpenGrid(GridPath, GridIndex);
end;

procedure TfmOpScenGrid.rb21Click(Sender: TObject);
begin
 cmGrid.Visible:= rb21.Checked or rb22.Checked;
 grText.Visible:= rb23.Checked;
 grBtn.Visible:= rb23.Checked;
 If rb21.Checked then LoadCombo(cmGrid, 1, etGridFrag)
 else begin
  LoadCombo(cmGrid, 2, etGridFrag);
  while Copy(cmGrid.Items.Strings[cmGrid.Items.Count-1],1,10) = '[fragment]' do
   cmGrid.Items.Delete(cmGrid.Items.Count - 1);
 end;
 OpenBtn.Enabled:= ( cmGrid.Visible and (cmGrid.ItemIndex > -1) )
                or ( grText.Visible and FileExists(GridPath)
                and ( ( HQSInfo.Lba2 and ExtIs(GridPath,'.gr2') )
                   or ( (not HQSInfo.Lba2 and ExtIs(GridPath,'.gr1') ) )
                    )
                   );
end;

procedure TfmOpScenGrid.FormShow(Sender: TObject);
begin
 lbInfo.Caption:= 'Be careful to select appropriate Grid for the Library, '
                + 'that is in the Scenario.'#13'Scenario type is LBA '
                + IfThen(HQSInfo.Lba2,'2','1');
 rb21.Enabled:= BrkEx and BllEx and GriEx and not HQSInfo.Lba2;
 rb22.Enabled:= BkgEx and HQSInfo.Lba2;
 If rb21.Checked and not rb21.Enabled then rb22.Checked:= True;
 If rb22.Checked and not rb22.Enabled then rb21.Checked:= True;
 If not (rb21.Enabled or rb22.Enabled) then rb23.Checked:= True;
 cmGrid.Enabled:= rb21.Enabled or rb22.Enabled;
 If GridPath <> '' then begin
  If not ExtIs(GridPath,'.hqr') then
   grText.Caption:= GridPath
  else if GridIndex >= 0 then
   grText.Caption:= GridPath + ', entry ' + IntToStr(GridIndex + 1);
 end;
 rb21Click(Self);
end;

procedure TfmOpScenGrid.FormCreate(Sender: TObject);
begin
 //rb21Click(Self);
end;

procedure TfmOpScenGrid.grBtnClick(Sender: TObject);
var p: TSmallPoint;
    a, lba: Integer;
    ext: String;
begin
 DlgOpen.Title:= 'Open Grid or package';
 DlgOpen.FileName:= GridPath;
 If HQSInfo.Lba2 then
  DlgOpen.Filter:= 'LBA 2 Grids (*.gr2, lba_bkg.hqr)|*.gr2;*lba_bkg*.hqr|' +
                   'Grid files (*.gr2)|*.gr2|lba_bkg.hqr|*lba_bkg*.hqr'
 else
  DlgOpen.Filter:= 'LBA 1 Grids (*.gr1, lba_gri.hqr)|*.gr1;*lba_gri*.hqr;|' +
                   'Grid files (*.gr1)|*.gr1|lba_gri.hqr|*lba_gri*.hqr';
 DlgOpen.FilterIndex:= 1;
 If DlgOpen.Execute then begin
  ext:= LowerCase(ExtractFileExt(DlgOpen.FileName));
  If ext= '.hqr' then begin
   //p.x:= 1;
   If IsBkg(DlgOpen.FileName) then lba:= 2 else lba:= 1;
   If CheckGridVersion(lba = 2,'Grid') then begin
    //If (lba = 2) then p:= BkgEntriesCount(DlgOpen.FileName,weGrids)
    //else p.y:= PackEntriesCount(DlgOpen.FileName);
    //If fmListForm.ShowDialog(Format('LBA_%d_GRI',[lba]),p.y-p.x+1,a) then begin
    If SameText(DlgOpen.FileName,GridPath) then a:= GridIndex
                                               else a:= -1;
     a:= HQRListDialog(DlgOpen.FileName, etGrids, lba = 1, Sett.General.FirstIndex1,
       'Please select a Grid from the package:'#13'(only normal entries are shown)',a);
    If a > -1 then begin
     GridPath:= DlgOpen.FileName;
     GridIndex:= a; // + p.x;
     grText.Caption:= Format('%s, entry %d',[GridPath,GridIndex]);
     rb23.Checked:= True;
    end;
   end;
  end
  else if (ext = '.gr1') or (ext = '.gr2') then begin
   If CheckGridVersion(ext = '.gr2','Grid') then begin
    GridPath:= DlgOpen.FileName;
    grText.Caption:= GridPath;
    rb23.Checked:= True;
   end;
  end
  else if not CheckGridFragment(ext = '.grf') then
    Application.MessageBox('Unknown extension!',ProgramName,MB_ICONERROR+MB_OK);
  rb21Click(Self);
 end;
end;

end.
