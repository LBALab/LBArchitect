unit Select;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ExtCtrls, Scene;

type
  TfmSelect = class(TForm)
    pgEditor: TPageControl;
    TabSheet1: TTabSheet;
    tsMultiEdit: TTabSheet;
    eSelection: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    btOK: TBitBtn;
    btCancel: TBitBtn;
    eX1: TEdit;
    eY1: TEdit;
    eZ1: TEdit;
    eX2: TEdit;
    eY2: TEdit;
    eZ2: TEdit;
    X: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    paScene: TPanel;
    rgType: TRadioGroup;
    cbId: TComboBox;
    Label10: TLabel;
    procedure pgEditorChange(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure rgTypeClick(Sender: TObject);
  private
    { Private declarations }
  public
    class function ShowSceneSelector(var SelType: TObjType;
      var SelId: Integer): Boolean;
  end;

var
  fmSelect: TfmSelect;

implementation

uses Globals, SceneLibConst;

{$R *.dfm}

class function TfmSelect.ShowSceneSelector(var SelType: TObjType;
  var SelId: Integer): Boolean;
var Form: TfmSelect;
begin
  Application.CreateForm(Self, Form);

  Form.pgEditor.Visible:= False;
  Form.paScene.Visible:= True;

  case SelType of
    otActor: Form.rgType.ItemIndex:= 0;
    otZone:  Form.rgType.ItemIndex:= 1;
    otPoint: Form.rgType.ItemIndex:= 2;
    otNone:  Form.rgType.ItemIndex:= 3;
  end;
  Form.rgTypeClick(nil);
  if SelId < Form.cbId.Items.Count then
    Form.cbId.ItemIndex:= SelId;

  Result:= Form.ShowModal = mrOK;
  if Result then begin
    case Form.rgType.ItemIndex of
      0: SelType:= otActor;
      1: SelType:= otZone;
      2: SelType:= otPoint;
      3: SelType:= otNone;
    end;
    if SelType <> otNone then
      SelId:= Form.cbId.ItemIndex;
    if SelId < 0 then begin
      SelType:= otNone;
      SelId:= 0;
    end;  
  end;

  FreeAndNil(Form);
end;

procedure TfmSelect.rgTypeClick(Sender: TObject);
var a: Integer;
    str: String;
begin
  cbId.Clear();
  case rgType.ItemIndex of
    0: for a:= 0 to High(VScene.Actors) do begin
         str:= IntToStr(a);
         if Vscene.Actors[a].Name <> '' then
           str:= str + ': ' + Vscene.Actors[a].Name;
         cbId.Items.Add(str);
       end;
    1: for a:= 0 to High(VScene.Zones) do begin
         str:= IntToStr(a);
         if VScene.Zones[a].RealType = ztSceneric then
           str:= str + ' (' + IntToStr(VScene.Zones[a].VirtualID) + ')';
         if Vscene.Zones[a].Name <> '' then
           str:= str + ': ' + Vscene.Zones[a].Name;
         cbId.Items.Add(str);
       end;
    2: for a:= 0 to High(VScene.Points) do begin
         str:= IntToStr(a);
         if Vscene.Points[a].Name <> '' then
           str:= str + ': ' + Vscene.Points[a].Name;
         cbId.Items.Add(str);  
       end;
  end;
  cbId.Enabled:= rgType.ItemIndex < 3;
  cbId.ItemIndex:= -1;
  if Visible and cbId.Enabled then
    cbId.SetFocus();
end;

procedure TfmSelect.pgEditorChange(Sender: TObject);
begin
 if pgEditor.ActivePageIndex = 0 then eSelection.SetFocus()
 else if not (ActiveControl is TEdit) then eX1.SetFocus();
end;

procedure TfmSelect.btOKClick(Sender: TObject);
begin
 if pgEditor.ActivePageIndex = 0 then begin

  ModalResult:= mrOK;
 end
 else begin

  ModalResult:= mrOK;
 end;
end;

end.
