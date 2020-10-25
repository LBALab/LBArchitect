unit EasyListviewReg;

// Version 1.5.5
//
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
//
// Alternatively, you may redistribute this library, use and/or modify it under the terms of the
// GNU Lesser General Public License as published by the Free Software Foundation;
// either version 2.1 of the License, or (at your option) any later version.
// You may obtain a copy of the LGPL at http://www.gnu.org/copyleft/.
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
// specific language governing rights and limitations under the License.
//
// The initial developer of this code is Jim Kueneman <jimdk@mindspring.com>
// Special thanks to the following in no particular order for their help/support/code
//    Danijel Malik, Robert Lee, Werner Lehmann, Alexey Torgashin, Milan Vandrovec
//
//----------------------------------------------------------------------------

interface

{$I Compilers.inc}

uses
  ToolsApi,
  Classes,
  {$IFDEF COMPILER_6_UP}
  DesignIntf,
  DesignEditors,
  {$ELSE}
  DsgnIntf,
  DsgnWnds,
  {$ENDIF}
  Forms,
  {$IFDEF COMPILER_5_UP}
  ColnEdit,
  {$ENDIF COMPILER_5_UP}
  SysUtils,
  Controls,
  EasyListview,
  EasyScrollFrame,
  MPCommonWizardHelpers,
  MPCommonObjects,
  EasyTaskPanelForm;

const
  NEW_PAGE = 'New';

type
  TEasyListviewEditor = class(TDefaultEditor)
  public
    procedure Edit; override;
  end;

  TEasyDelphiTaskFormWizard = class(TCommonWizardDelphiForm)
  public
    procedure InitializeWizard; override;
  end;

  // Only used in BDS 4.0 and up
  TEasyBuilderTaskFormWizard = class(TCommonWizardBuilderForm)
  public
    procedure InitializeWizard; override;
  end;

  TEasyTaskPanelCreator = class(TCommonWizardEmptyFormCreator)
  public
    procedure InitializeCreator; override;
  end;

procedure Register;

implementation

uses
  {$IFDEF COMPILER_5_UP}
  EasyCollectionEditor;
  {$ELSE}
  EasyCollectionEditorD4;
  {$ENDIF COMPILER_5_UP}

{$IFDEF COMPILER_8_UP}
var
  DelphiCategory, BuilderCategory: IOTAGalleryCategory;
{$ENDIF}

procedure Register;
begin
  RegisterComponents('MustangPeak', [TEasyListview, TEasyTaskBand, TEasyScrollButton, TEasyTaskPanelBand]);
  RegisterPropertyEditor(TypeInfo(TEasyCollection), nil, '', TEasyCollectionEditor);
  RegisterComponentEditor(TEasyListview, TEasyListviewEditor);
  RegisterComponentEditor(TEasyTaskPanelBand, TEasyListviewEditor);
  RegisterComponentEditor(TEasyTaskBand, TEasyListviewEditor);

  RegisterCustomModule(TEasyTaskPanelForm, TCustomModule);
  RegisterPackageWizard(TEasyDelphiTaskFormWizard.Create);
  {$IFDEF COMPILER_10_UP}
  RegisterPackageWizard(TEasyBuilderTaskFormWizard.Create);
  {$ENDIF COMPILER_10_UP}

  {$IFDEF COMPILER_6_UP}
  RegisterPropertyEditor(TypeInfo(TCommonImageIndexInteger), nil, '', TCommonImageIndexProperty);
  {$ENDIF COMPILER_6_UP}
end;

{ TEasyListviewEditor }

procedure TEasyListviewEditor.Edit;
begin
  // Show column collection editor on listview doubleclick.
  if (Component is TEasyTaskPanelBand) or (Component is TEasyTaskBand) then
    ShowEasyCollectionEditor(Designer, TEasyListview(Component).Groups)
  else
    ShowEasyCollectionEditor(Designer, TEasyListview(Component).Header.Columns);
end;

{ TEasyDelphiTaskForm }

procedure TEasyDelphiTaskFormWizard.InitializeWizard;
begin
  inherited;
  Caption := 'EasyListview TaskPanel';
  Author := 'Mustangpeak';
  Comment := 'Creates a task band panel for the EasyTaskPanelBand component';
  GlyphResourceID := '';  // use the default icon
  Page := NEW_PAGE;  // use the New page for Forms
  UniqueID := 'mustangpeak.easy.delphi.task.form';
  State := [];
  CreatorClass := TEasyTaskPanelCreator;
  {$IFDEF COMPILER_8_UP}
  GalleryCategory := DelphiCategory;
  {$ENDIF COMPILER_8_UP}
end;

{ TEasyBuilderTaskForm }

procedure TEasyBuilderTaskFormWizard.InitializeWizard;
begin
  inherited;
  Caption := 'EasyTaskPanel C++Builder Form';
  Author := 'Mustangpeak';
  Comment := 'Creates a task band panel for the EasyTaskPanelBand component';
  GlyphResourceID := '';  // use the default icon
  Page := '';  // use the default page for Forms
  UniqueID := 'mustangpeak.easy.builder.task.form';
  State := [];
  CreatorClass := TEasyTaskPanelCreator;
  {$IFDEF COMPILER_8_UP}
  GalleryCategory := BuilderCategory;
  {$ENDIF COMPILER_8_UP}
end;

{ TEasyTaskPanelCreator }

procedure TEasyTaskPanelCreator.InitializeCreator;
begin
  inherited;
  AncestorName := 'EasyTaskPanelForm';
  if IsDelphi then
    IncludeIdent.Add('EasyTaskPanelForm')
  else
    IncludeIdent.Add('EasyTaskPanelForm.hpp')
end;

initialization
  {$IFDEF COMPILER_8_UP}
  DelphiCategory := AddDelphiCategory('mustangpeak.delphi.easylistview', 'EasyListview for Delphi');
  BuilderCategory := AddBuilderCategory('mustangpeak.builder.easylistview', 'EasyListview for C++ Builder');
  {$ENDIF COMPILER_8_UP}
finalization
  {$IFDEF COMPILER_8_UP}
  RemoveCategory(BuilderCategory);
  RemoveCategory(DelphiCategory);
  {$ENDIF COMPILER_8_UP}

end.

