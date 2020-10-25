unit Settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, IniFiles, Math;

type
  TfmSettings = class(TForm)
    btOK: TBitBtn;
    btCancel: TBitBtn;
    cbAskDelRow: TCheckBox;
    cbBuildSummary: TCheckBox;
    cbAutoSave: TCheckBox;
    cbNoASForce: TCheckBox;
    cbLastProject: TCheckBox;
    cbStartZero: TCheckBox;
    procedure cbAutoSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
   Procedure ShowSettings();
  end;

const
  MaxRecentProjects = 10;

var
  fmSettings: TfmSettings;
  f: TIniFile;

  MainSettings: record
    StartZero: Boolean;
    LastProjectDir: String;
    LastProject: String;
    AskDeletingRow: Boolean;
    BuildSummary: Boolean;
    OpenLastProject: Boolean;
    AutoSave: Boolean;
    NoASForce: Boolean;
    RecentProjects: array[0..MaxRecentProjects-1] of String;
  end;

Procedure LoadSettings();
Procedure SaveSettings();

implementation

uses Main;

{$R *.dfm}

Procedure TfmSettings.ShowSettings();
begin
 cbStartZero.Checked:= MainSettings.StartZero;
 cbAskDelRow.Checked:= MainSettings.AskDeletingRow;
 cbBuildSummary.Checked:= MainSettings.BuildSummary;
 cbLastProject.Checked:= MainSettings.OpenLastProject;
 cbAutoSave.Checked:= MainSettings.AutoSave;
 cbNoASForce.Checked:= MainSettings.NoASForce;
 cbAutoSaveClick(Self);
 //While (ShowModal = mrOK)
 //and not (TryStrToFloat(eMinSizeBen.Text,sb)  and (sb >= 0)
 //     and TryStrToFloat(eMinTimeBen.Text,tb)  and (tb >= 0)
 //     and TryStrToFloat(eMaxSizeLoss.Text,sl) and (sl >= 0)
 //     and TryStrToInt(eBrkForceInv,bi)        and (bi >= 0)) do
 // MessageBox(Handle,'At leas one of the fields contains invalid number!'#13#13
 //                 + 'Fields "file size benefit is at least", "time benefit is at least" and "size loss is not higher than" should contain real numbers, greater or equal to zero.'#13
 //                 + 'Field "Force the invisible Brick at specific position" should contain and integer number, greater or equal to zero.','Stage Designer',MB_ICONERROR+MB_OK);
 if ShowModal() = mrOK then begin
   MainSettings.StartZero:= cbStartZero.Checked;
   MainSettings.AskDeletingRow:= cbAskDelRow.Checked;
   MainSettings.BuildSummary:= cbBuildSummary.Checked;
   MainSettings.OpenLastProject:= cbLastProject.Checked;
   MainSettings.AutoSave:= cbAutoSave.Checked;
   MainSettings.NoASForce:= cbNoASForce.Checked;
   fmMain.lvGrids.Repaint();
   fmMain.lvTest.Repaint();
   fmMain.lvFrags.Repaint();
 end;
end;

Procedure LoadSettings();
var a: Integer;
begin
 f:= TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
 try
   MainSettings.StartZero:= f.ReadBool('General', 'StartZero', False);
   MainSettings.LastProjectDir:= f.ReadString('General', 'LastProjectDir', '');
   MainSettings.LastProject:= f.ReadString('General', 'LastProject', '');
   MainSettings.AskDeletingRow:= f.ReadBool('General', 'AskDeletingRow', True);
   MainSettings.OpenLastProject:= f.ReadBool('General', 'OpenLastProject', False);
   MainSettings.AutoSave:= f.ReadBool('General', 'AutoSave', True);
   MainSettings.NoASForce:= f.ReadBool('General', 'NoASForce', False);
   fmMain.paFragments.Height:=
     Min(f.ReadInteger('General', 'FragListSize', 124),
         fmMain.ClientHeight - fmMain.sbMain.Height - fmMain.tbMain.Height - 40);
   //fmMain.paFragments.Top:= fmMain.spFragments.Top + fmMain.spFragments.Height;
   //fmMain.lvGrids.Realign();
   for a:= 0 to MaxRecentProjects - 1 do
     MainSettings.RecentProjects[a]:= f.ReadString('General', 'RecentProject' + IntToStr(a), '');
   fmMain.RefreshRecentMenu();
   MainSettings.BuildSummary:= f.ReadBool('Building', 'BuildSummary', True);

 finally
   FreeAndNil(f);
 end;
end;

Procedure SaveSettings();
var a: Integer;
begin
 f:= TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
 try
   f.WriteBool('General', 'StartZero', MainSettings.StartZero);
   f.WriteString('General', 'LastProjectDir', MainSettings.LastProjectDir);
   f.WriteString('General', 'LastProject', MainSettings.LastProject);
   f.WriteBool('General', 'AskDeletingRow', MainSettings.AskDeletingRow);
   f.WriteBool('General', 'OpenLastProject', MainSettings.OpenLastProject);
   f.WriteBool('General', 'AutoSave', MainSettings.AutoSave);
   f.WriteBool('General', 'NoASForce', MainSettings.NoASForce);
   f.WriteInteger('General', 'FragListSize', fmMain.paFragments.Height);
   for a:= 0 to MaxRecentProjects - 1 do
     f.WriteString('General', 'RecentProject' + IntToStr(a), MainSettings.RecentProjects[a]);
   f.WriteBool('Building', 'BuildSummary', MainSettings.BuildSummary);

 finally
   FreeAndNil(f);
 end;
end;

procedure TfmSettings.cbAutoSaveClick(Sender: TObject);
begin
 cbNoASForce.Enabled:= cbAutoSave.Checked;
end;

end.
