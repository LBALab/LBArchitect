unit ScenarioProp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, StrUtils, DePack, ExtCtrls;

type
  TfmScenarioProp = class(TForm)
    Label1: TLabel;
    eShortDesc: TEdit;
    Label2: TLabel;
    mLongDesc: TMemo;
    btOK: TBitBtn;
    lbScType: TLabel;
    Label3: TLabel;
    BitBtn1: TBitBtn;
    Label4: TLabel;
    lbScene: TLabel;
    lbSceneCap: TLabel;
    lbHasGrid: TLabel;
    lbHasGridCap: TLabel;
    lbHasFrags: TLabel;
    lbHasFragsCap: TLabel;
    Bevel1: TBevel;
  private
    { Private declarations }
  public
    function ShowDialog(Lba2: Boolean; Scenario: TPackEntries;
      FragCnt: Integer; var ShortDesc, LongDesc: String; FullInfo: Boolean): Boolean;
  end;

var
  fmScenarioProp: TfmScenarioProp;

implementation

uses Scenario;

{$R *.dfm}

//Returns True if user clicked OK, False otherwise
function TfmScenarioProp.ShowDialog(Lba2: Boolean; Scenario: TPackEntries;
  FragCnt: Integer; var ShortDesc, LongDesc: String; FullInfo: Boolean): Boolean;
var GridEx, SceneTxt, SceneBin: Boolean;
begin
 Result:= False;
 GridEx:= (Length(Scenario) > 3) and (Scenario[3].FType = -1);
 SceneTxt:= (Length(Scenario) > 7) and (Scenario[7].FType = -1);
 SceneBin:= (Length(Scenario) > 8) and (Scenario[8].FType = -1);

 lbScType.Caption:= IfThen(Lba2, 'LBA 2', 'LBA 1');
 lbHasGridCap.Visible:= FullInfo;
 lbHasGrid.Visible:= FullInfo;
 lbSceneCap.Visible:= FullInfo;
 lbScene.Visible:= FullInfo;
 lbHasFragsCap.Visible:= FullInfo;
 lbHasFrags.Visible:= FullInfo;
 if FullInfo then begin
   lbHasGrid.Caption:= IfThen(GridEx, 'Yes', 'No');
   lbScene.Caption:= IfThen(SceneTxt, 'Text', '');
   If SceneTxt and SceneBin then lbScene.Caption:= lbScene.Caption + ' + ';
   If SceneBin then lbScene.Caption:= lbScene.Caption + 'Binary';
   if lbScene.Caption = '' then lbScene.Caption:= 'None';
   lbHasFrags.Caption:= IntToStr(FragCnt);
   Height:= 371;
 end else
   Height:= 353;

 eShortDesc.Text:= Trim(ShortDesc);
 mLongDesc.Lines.Text:= LongDesc;

 If ShowModal = mrOK then begin
   ShortDesc:= Copy(eShortDesc.Text, 1, 255);
   LongDesc:= mLongDesc.Lines.Text;
   Result:= True;
 end;
end;

end.
