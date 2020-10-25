program Designer;

uses
  FastMM4 in '..\Libs\FastMM4\FastMM4.pas',
  Forms,
  Main in 'Main.pas' {fmMain},
  CompMods in '..\..\LIBS\CompMods.pas',
  Settings in 'Settings.pas' {fmSettings},
  DePack in '..\Libs\DePack.pas',
  Editing in '..\Libs\Editing.pas',
  Projects in 'Projects.pas' {fmProject},
  Building in 'Building.pas',
  ProgBar in '..\Libs\ProgBar.pas' {ProgBarForm},
  Libraries in '..\Libs\Libraries.pas',
  Manual in 'Manual.pas' {fmManual},
  Scenario in 'Scenario.pas',
  Utils in '..\Libs\Utils.pas',
  FastMM4Messages in '..\Libs\FastMM4\FastMM4Messages.pas',
  Utils_Graph in '..\Libs\Utils_Graph.pas',
  PathEdit in '..\Components\PathEdit\PathEdit.pas',
  OpenDirectory in '..\Components\OpenDirectory\OpenDirectory.pas',
  BetterSpin in '..\Components\BetterSpin.pas' {frBetterSpin: TFrame},
  HQDOut in 'HQDOut.pas',
  MPCommonObjects in '..\Components\MPCommonLib\Source\MPCommonObjects.pas',
  MPCommonUtilities in '..\Components\MPCommonLib\Source\MPCommonUtilities.pas',
  MPCommonWizardTemplates in '..\Components\MPCommonLib\Source\MPCommonWizardTemplates.pas',
  MPDataObject in '..\Components\MPCommonLib\Source\MPDataObject.pas',
  MPResources in '..\Components\MPCommonLib\Source\MPResources.pas',
  MPShellTypes in '..\Components\MPCommonLib\Source\MPShellTypes.pas',
  MPShellUtilities in '..\Components\MPCommonLib\Source\MPShellUtilities.pas',
  MPThreadManager in '..\Components\MPCommonLib\Source\MPThreadManager.pas',
  EasyListview in '..\Components\MPEasyListView\Source\EasyListview.pas',
  EasyListviewAccessible in '..\Components\MPEasyListView\Source\EasyListviewAccessible.pas',
  EasyLVResources in '..\Components\MPEasyListView\Source\EasyLVResources.pas',
  EasyMSAAIntf in '..\Components\MPEasyListView\Source\EasyMSAAIntf.pas',
  EasyScrollFrame in '..\Components\MPEasyListView\Source\EasyScrollFrame.pas',
  EasyTaskPanelForm in '..\Components\MPEasyListView\Source\EasyTaskPanelForm.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Little Stage Designer';
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmSettings, fmSettings);
  Application.CreateForm(TfmProject, fmProject);
  Application.CreateForm(TProgBarForm, ProgBarForm);
  UpdateComponents();

  LoadSettings();

  If (ParamCount() > 0) and ExtIs(ParamStr(1), '.sdp') then
    LoadProject(ParamStr(1))
  else if MainSettings.OpenLastProject and (MainSettings.LastProject <> '') then
    LoadProject(MainSettings.LastProject);

  Application.Run;

  SaveSettings();
end.

{ TO DO:

 Current stuff:
  - don't scroll to top after deleting items

}
