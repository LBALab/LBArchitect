//******************************************************************************
// Little Big Architect: Factory - editing brick and layout files from
//                                 Little Big Adventure 1 & 2
//
// This is the main program file.
//
// Copyright Zink
// e-mail: zink@poczta.onet.pl
//
// This source code is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This source code is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License (License.txt) for more details.
//******************************************************************************

program Factory;

uses
  FastMM4 in '..\Libs\FastMM4\FastMM4.pas',
  SysUtils,
  Forms,
  Main in 'Main.pas' {fmMain},
  ProgBar in '..\Libs\ProgBar.pas' {ProgBarForm},
  Engine in '..\Libs\Engine.pas',
  Bricks in 'Bricks.pas',
  DePack in '..\Libs\DePack.pas',
  Editor in 'Editor.pas' {EditForm},
  OptPanel in 'OptPanel.pas' {OptForm},
  Layouts in 'Layouts.pas',
  StructEd in 'StructEd.pas' {fmStruct},
  BrkTable in 'BrkTable.pas' {TableForm},
  DimDialog in 'DimDialog.pas' {fmDimensions},
  Libraries in '..\Libs\Libraries.pas',
  Scenario in 'Scenario.pas',
  ScenarioProp in '..\Libs\ScenarioProp.pas' {fmScenarioProp},
  ListForm in '..\Libs\ListForm.pas' {fmList},
  HQDesc in '..\Libs\HQDesc.pas',
  Utils in '..\Libs\Utils.pas',
  Globals in 'Globals.pas',
  BetterSpin in '..\Components\BetterSpin.pas' {frBetterSpin: TFrame},
  DFSClrBn in '..\Components\TdfsColorButton\DFSClrBn.pas',
  CBtnForm in '..\Components\TdfsColorButton\CBtnForm.pas' {DFSColorButtonPalette},
  LayImport in 'LayImport.pas' {fmLayImport},
  CompMods in '..\Libs\CompMods.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Little Big Factory';
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmScenarioProp, fmScenarioProp);
  Application.CreateForm(TfmList, fmList);
  fmMain.Left:= (Screen.Width-fmMain.Width) div 2;
  fmMain.Top:= (Screen.Height-fmMain.Height) div 2;
  Application.HintHidePause:= 15000;
  Application.CreateForm(TProgBarForm, ProgBarForm);
  Application.CreateForm(TEditForm, EditForm);
  Application.CreateForm(TOptForm, OptForm);
  Application.CreateForm(TfmStruct, fmStruct);
  Application.CreateForm(TTableForm, TableForm);
  Application.OnDeactivate:= TableForm.FormDeactivate;
  LoadSettings();

  If ParamCount > 0 then OpenParam();

  If (Length(VBricks) = 0) and FileExists(BrkPath) then
    OpenBricks(BrkPath);
  If (Length(Lib) = 0) and FileExists(LibPath) then
    OpenLibrary(LibPath, LibIndex, True);

  UpdateComponents();
  Application.Run;

  SaveSettings();
end.

{ TO DO:
 - Replace MessageBox with WarningMsg and Application.MessageBox
 - Refresh Layouts scrollbar after opening a new Library (flashing shade gets bad)
 - Make an option to copy physical blocks in the Layout, not only references
 - Check if Bricks and Layouts were modified at opening new files, not only
     on program exit
 - Disable Layout creation functions when only one Brick is opened
 - Opening buttons on the Bricks and Layouts tabs
 - Editor should display file name instead of index if only one Brick/Layout is
     opened


 Bugs:
 - Layout exporting feature eats one bottom line of the image
    (can't reproduce. Fixed somehow by an accident?)
 - Layout exporting works strangely (why???)
 - When pasting an image that is larger than the Layout dimensions it will be
    cut to the Layout's pixel size. Is that really bad?
 - AV when starting Brick editing under Win98 (already fixed ?)
 - Something's wrong with increasing Layout size (already fixed ?)
 - during fast drawing the line doesn't come up to the image's edge if mouse goes
     off the edge.
     
}
