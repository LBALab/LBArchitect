unit Manual;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, PathEdit, ExtCtrls, Math;

type
  TfmManual = class(TForm)
    btOK: TBitBtn;
    btCancel: TBitBtn;
    lbPathCap: TLabel;
    lbError: TLabel;
    Label3: TLabel;
    lbRowId: TLabel;
    Label4: TLabel;
    lbColumn: TLabel;
    cbBlank: TCheckBox;
    paFragment: TPanel;
    lbFragmentCap: TLabel;
    cbFragment: TComboBox;
    lbInfo: TLabel;
    procedure cbBlankClick(Sender: TObject);
    procedure btFragHelpClick(Sender: TObject);
    procedure peFilePathChange(Sender: TObject; var Path: TFileName);
    procedure FormCreate(Sender: TObject);
  private
    FGridList: Boolean;
    FColumn: Integer;
    FFragment: Integer;
    FLba: Integer;
    FGridColumn: Boolean;
    procedure ShowInfo(Err: Boolean; text: String);
    function CheckFile(): Boolean;
    function ShowInternal(GridList: Boolean; Row, Column, Lba: Integer;
      ColName: String; var path: String; var Fragment: Integer): Boolean;
  public
    peFile: TPathEdit;
    class function ShowDialog(GridList: Boolean; Row, Column, Lba: Integer;
      ColName: String; var path: String; var Fragment: Integer): Boolean;
  end;

implementation

uses Utils, DePack, Scenario;

{$R *.dfm}

procedure TfmManual.ShowInfo(Err: Boolean; text: String);
begin
 lbError.Caption:= text;
 if Err then lbError.Font.Color:= clRed
        else lbError.Font.Color:= clGreen;
end;

function TfmManual.CheckFile(): Boolean;
var ScInfo: TScenarioInfo;
    a: Integer;

  function LoadAndCheckScenario(): Boolean;
  begin
    Result:= False;
    if not ReadScenarioInfo(peFile.Path, ScInfo) then
      ShowInfo(True, 'Can''t read Scenario info, file may be corrupted!')
    else if ScInfo.HQSInfo.Version < 2 then
      ShowInfo(True, 'Unsupported Scenario version! Required >= 2.')
    else if ScInfo.HQSInfo.Lba2 xor (FLba <> 1) then
      ShowInfo(True, 'Scenario LBA version differs from the project''s version!')
    else
      Result:= True;
  end;

begin
 cbFragment.Enabled:= False;
 ShowInfo(False, 'File OK');
 Result:= False;
 if SameText(peFile.Path, '<B>') then Exit;
 if FileExists(peFile.Path) then begin
   if FGridList then begin
     case FColumn of
       1: if ExtIs(peFile.Path, '.hqs') then begin //if Scenario
            if LoadAndCheckScenario() then begin
              if ScInfo.HasGrid then Result:= True
              else ShowInfo(True, 'Scenario does not contain Grid!')
            end;
          end
          else if ExtIs(peFile.Path, '.gr1') or ExtIs(peFile.Path, '.gr2') then begin
            if ExtIs(peFile.Path, '.gr2') xor (FLba <> 1) then
              ShowInfo(True, 'LBA version of the file differs from the project''s version!')
            else
              Result:= True;
          end else
            ShowInfo(True, 'This column requires HQS, GR1 or GR2 file!');

       2: if ExtIs(peFile.Path, '.hqs') then begin //if Scenario
            if LoadAndCheckScenario() then begin
              if ScInfo.HasLibrary then Result:= True
              else ShowInfo(True, 'Scenario does not contain Library!')
            end;
          end
          else if ExtIs(peFile.Path, '.bl1') or ExtIs(peFile.Path, '.bl2') then begin
            if ExtIs(peFile.Path, '.bl2') xor (FLba <> 1) then
              ShowInfo(True, 'LBA version of the file differs from the project''s version!')
            else
              Result:= True;
          end else
            ShowInfo(True, 'This column requires HQS, BL1 or BL2 file!');

       3: if ExtIs(peFile.Path, '.hqs') then begin //if Scenario
            if LoadAndCheckScenario() then begin
              if ScInfo.HQSInfo.BrickCount > 0 then Result:= True
              else ShowInfo(True, 'Scenario does not contain any Bricks!')
            end;
          end
          else if ExtIs(peFile.Path, '.hqr') then begin //if HQR
            if PackEntriesCount(peFile.Path) > 0 then Result:= True
            else ShowInfo(True, 'HQR does not contain any entries or is corrupted!')
          end else
            ShowInfo(True, 'This column requires HQS or HQR file!');

       4: if ExtIs(peFile.Path, '.hqs') then begin //if Scenario
            if LoadAndCheckScenario() then begin
              if ScInfo.HasBinScene then Result:= True
              else ShowInfo(True, 'Scenario does not contain Binary Scene!')
            end;
          end
          else if ExtIs(peFile.Path, '.ls1') or ExtIs(peFile.Path, '.ls2') then begin
            if ExtIs(peFile.Path, '.ls2') xor (FLba <> 1) then
              ShowInfo(True, 'LBA version of the file differs from the project''s version!')
            else
              Result:= True;
          end else
            ShowInfo(True, 'This column requires HQS, LS1 or LS2 file!');
     end;
   end else begin //Fragment list
     case FColumn of
       1: if ExtIs(peFile.Path, '.hqs') then begin //if Scenario
            if LoadAndCheckScenario() then begin
              if ScInfo.HQSInfo.FragmentCount > 0 then begin
                Result:= True;
                cbFragment.Clear();
                for a:= 0 to ScInfo.HQSInfo.FragmentCount do //not -1, cause it doesn't count main map
                  cbFragment.AddItem(IntToStr(a) + ': ' + ScInfo.MapNames[a], nil);
                cbFragment.ItemIndex:= Min(FFragment, cbFragment.Items.Count - 1);
                cbFragment.Enabled:= True;
              end else
                ShowInfo(True, 'Scenario does not contain any Fragments!')
            end;
          end
          else if ExtIs(peFile.Path, '.gr1') or ExtIs(peFile.Path, '.grf') then begin
            if ExtIs(peFile.Path, '.grf') xor (FLba <> 1) then
              ShowInfo(True, 'LBA version of the file differs from the project''s version!')
            else
              Result:= True;
          end else
            ShowInfo(True, 'This column requires HQS, GR1 or GRF file!');

       2: if ExtIs(peFile.Path, '.hqs') then begin //if Scenario
            if LoadAndCheckScenario() then begin
              if ScInfo.HasLibrary then Result:= True
              else ShowInfo(True, 'Scenario does not contain Library!')
            end;
          end
          else if ExtIs(peFile.Path, '.bl1') then
            Result:= True
          else
            ShowInfo(True, 'This column requires HQS or BL1 file!');

       3: if ExtIs(peFile.Path, '.hqs') then begin //if Scenario
            if LoadAndCheckScenario() then begin
              if ScInfo.HQSInfo.BrickCount > 0 then Result:= True
              else ShowInfo(True, 'Scenario does not contain any Bricks!')
            end;
          end
          else if ExtIs(peFile.Path, '.hqr') then begin //if HQR
            if PackEntriesCount(peFile.Path) > 0 then Result:= True
            else ShowInfo(True, 'HQR does not contain any entries or is corrupted!')
          end else
            ShowInfo(True, 'This column requires HQS or HQR file!');
     end;
   end;
 end else ShowInfo(True, 'Specified file does not exist!');
 //btFragHelp.Visible:= not cbFragment.Enabled;
end;

procedure TfmManual.FormCreate(Sender: TObject);
begin
 peFile:= TPathEdit.Create(Self);
 peFile.Parent:= Self;
 peFile.SetBounds(lbPathCap.Left, 69, 485, 24);
 peFile.PathKind:= pkFile;
 peFile.IncPathDelimiter:= False;
 peFile.OnPathChange:= peFilePathChange;
 peFile.FileFilterIndex:= 1;
end;

class function TfmManual.ShowDialog(GridList: Boolean; Row, Column, Lba: Integer;
  ColName: String; var path: String; var Fragment: Integer): Boolean;
var Form: TfmManual;
begin
 Form:= TfmManual.Create(Application);

 Result:= False;

 if Assigned(Form) then begin
   Result:= Form.ShowInternal(GridList, Row, Column, Lba, ColName, path, Fragment);
 end;

 FreeAndNil(Form);
end;

function TfmManual.ShowInternal(GridList: Boolean; Row, Column, Lba: Integer;
  ColName: String; var path: String; var Fragment: Integer): Boolean;
var dummy: TFileName;  
begin
 FGridList:= GridList;
 FFragment:= Fragment;
 FColumn:= Column;
 FLba:= Lba;
 if GridList then begin
   Caption:= 'Manual Grid list cell edit';
   case FColumn of
     1: lbInfo.Caption:= 'Please specify a Grid or Scenario file';
     2: lbInfo.Caption:= 'Please specify a Library or Scenario file';
     3: lbInfo.Caption:= 'Please specify a Bricks HQR or Scenario file';
     4: lbInfo.Caption:= 'Please specify a Binary Scene or Scenario file';
   end;
 end else begin
   Caption:= 'Manual Fragment list cell edit';
   case FColumn of
     1: lbInfo.Caption:= 'Please specify a Fragment or Scenario file';
     2: lbInfo.Caption:= 'Please specify a Library or Scenario file';
     3: lbInfo.Caption:= 'Please specify a Bricks HQR or Scenario file';
   end;
   if (FColumn = 2) and (Lba = 1) then
     lbInfo.Caption:= lbInfo.Caption
       + #13'Required only for LBA 1. It should be identical as the one used by base Grid.';
 end;
 lbRowId.Caption:= IntToStr(Row);
 lbColumn.Caption:= ColName;
 peFile.Path:= path;
 cbBlank.Checked:= path = '<B>';
 cbBlankClick(nil);
 paFragment.Visible:= not GridList and (Column = 1);
 if paFragment.Visible then ClientHeight:= 196
                       else ClientHeight:= 155;
                       
 peFilePathChange(nil, dummy); //CheckFile();

 Result:= ShowModal = mrOK;

 if Result then begin
   if cbBlank.Checked then path:= '<B>'
                      else path:= peFile.Path;
   Fragment:= Max(cbFragment.ItemIndex, 0);
 end;
end;  

procedure TfmManual.cbBlankClick(Sender: TObject);
begin
 peFile.Enabled:= not cbBlank.Checked;
 lbError.Enabled:= not cbBlank.Checked;
 if not cbBlank.Checked and SameText(peFile.Path, '<B>') then
   peFile.Path:= '';
end;

procedure TfmManual.btFragHelpClick(Sender: TObject);
begin
 {InfoMsg('The Fragment selection will be disabled when one of the following cases occurs:'#13
       + ' 1. Entry is set to blank.'#13
       + ' 2. List being edited is the Grid list not the Fragment list.'#13
       + ' 3. Column being edited is not the Framgnet column.'#13
       + ' 4. The chosen file is not Scenario or seems corrupted.'#13
       + ' 5. The chosen Scenario does not contain any Fragments.'); }
end;

procedure TfmManual.peFilePathChange(Sender: TObject; var Path: TFileName);
begin
 if fsCreating in FormState then Exit; //peFilePath triggers this on creation
 CheckFile();
end;

end.
