unit CurrentFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfmCurrentFiles = class(TForm)
    btClose: TBitBtn;
    lbEditHead: TLabel;
    lbReadHead: TLabel;
    lbEditCapts: TLabel;
    lbEditPaths: TLabel;
    lbReadCapts: TLabel;
    lbReadPaths: TLabel;
    procedure btCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    class procedure ShowDialog();
  end;


implementation

uses Globals, DePack, Open, Scene;

{$R *.dfm}

{ TfmCurrentFiles }

procedure TfmCurrentFiles.btCloseClick(Sender: TObject);
begin
 Close();
end;

class procedure TfmCurrentFiles.ShowDialog();
var Form: TfmCurrentFiles;
    a, elines, rlines: Integer;
begin
 Application.CreateForm(Self, Form);
 elines:= 0;
 rlines:= 0;
 Form.lbEditCapts.Caption:= '';
 Form.lbEditPaths.Caption:= '';
 Form.lbReadCapts.Caption:= '';
 Form.lbReadPaths.Caption:= '';

 if ScenarioState then begin
     Form.lbEditCapts.Caption:= Form.lbEditCapts.Caption + 'Scenario:';
   if CurrentScenarioFile = '' then
     Form.lbEditPaths.Caption:= Form.lbEditPaths.Caption + '(unsaved)'
   else
     Form.lbEditPaths.Caption:= Form.lbEditPaths.Caption + CurrentScenarioFile;
   Inc(elines);
 end else begin
   if Length(LdMaps) > 0 then begin
     for a:= 0 to High(LdMaps) do begin
       Form.lbEditCapts.Caption:= Form.lbEditCapts.Caption + LdMaps[a].Name + ':'#13;
       if LdMaps[a].FilePath = '' then
         Form.lbEditPaths.Caption:= Form.lbEditPaths.Caption + '(unsaved)'
       else begin
         Form.lbEditPaths.Caption:= Form.lbEditPaths.Caption + LdMaps[a].FilePath;
         if ExtIs(LdMaps[a].FilePath, '.hqr') then
           Form.lbEditPaths.Caption:= Form.lbEditPaths.Caption + ', index: ' + IntToStr(LdMaps[a].FileIndex);
       end;
       Form.lbEditPaths.Caption:= Form.lbEditPaths.Caption + #13;
       Inc(elines);
     end;

     //If there is no Main Map then there is no Scene too :)
     Form.lbEditCapts.Caption:= Form.lbEditCapts.Caption + 'Scene:'#13;
     if CurrentSceneFile = '' then
       Form.lbEditPaths.Caption:= Form.lbEditPaths.Caption + '(unsaved)'
     else begin
       Form.lbEditPaths.Caption:= Form.lbEditPaths.Caption + CurrentSceneFile;
       if ExtIs(CurrentSceneFile, '.hqr') then
         Form.lbEditPaths.Caption:= Form.lbEditPaths.Caption + ', index: ' + IntToStr(CurrentSceneIndex);
       Form.lbEditPaths.Caption:= Form.lbEditPaths.Caption + #13;
     end;
     Inc(elines);
   end;

   if CurrentLibFile <> '' then begin
     Form.lbReadCapts.Caption:= Form.lbReadCapts.Caption + 'Library:'#13;
     Form.lbReadPaths.Caption:= Form.lbReadPaths.Caption + CurrentLibFile;
     if ExtIs(CurrentLibFile, '.hqr') then
       Form.lbReadPaths.Caption:= Form.lbReadPaths.Caption + ', index: ' + IntToStr(CurrentLibIndex);
     Form.lbReadPaths.Caption:= Form.lbReadPaths.Caption + #13;
     Inc(rlines);
   end;
 end;
 if SpritesFile <> '' then begin
   Form.lbReadCapts.Caption:= Form.lbReadCapts.Caption + 'Sprites:'#13;
   Form.lbReadPaths.Caption:= Form.lbReadPaths.Caption + SpritesFile + #13;
   Inc(rlines);
 end;
 if RessFile <> '' then begin
   Form.lbReadCapts.Caption:= Form.lbReadCapts.Caption + 'Resources:'#13;
   Form.lbReadPaths.Caption:= Form.lbReadPaths.Caption + RessFile + #13;
   Inc(rlines);
 end;
 if File3dFile <> '' then begin
   Form.lbReadCapts.Caption:= Form.lbReadCapts.Caption + 'File3D:'#13;
   Form.lbReadPaths.Caption:= Form.lbReadPaths.Caption + File3dFile + #13;
   Inc(rlines);
 end;  
 {if BodyNamesFile <> '' then
   msg:= msg + '  Body names: ' + BodyNamesFile + #13;
 if AnimNamesFile <> '' then
   msg:= msg + '  Anim names: ' + AnimNamesFile + #13;}

 Form.lbEditCapts.Height:= Form.lbEditCapts.Canvas.TextHeight('Wq') * elines;
 Form.lbReadCapts.Height:= Form.lbReadCapts.Canvas.TextHeight('Wq') * rlines;

 if Form.lbEditCapts.Caption = '' then
   Form.lbEditHead.Caption:= 'There are currently no files opened for editing.';
 if Form.lbReadCapts.Caption = '' then
   Form.lbReadHead.Caption:= 'There are currently no files opened for reading.';

 Form.lbReadHead.Top:= Form.lbEditCapts.Top + Form.lbEditCapts.Height + 20;
 Form.lbReadCapts.Top:= Form.lbReadHead.Top + 20;
 Form.lbReadPaths.Top:= Form.lbReadCapts.Top;
 
 Form.ClientHeight:= Form.lbReadCapts.Top + Form.lbReadCapts.Height + 60;

 Form.ShowModal();
end;

end.
