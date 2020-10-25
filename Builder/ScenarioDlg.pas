unit ScenarioDlg;

interface

uses Classes, Dialogs, Controls, ExtCtrls;

type
  {TPreviewFileControl = class(TWinControl)
  private
    //FPreviewFileDialog: TPreviewFileDialog;
  protected
    //procedure SetPreviewFileDialog(const AValue: TPreviewFileDialog);
    procedure CreateParams(var Params: TCreateParams); override;
    class function GetControlClassDefaultSize: TPoint; override;
  public
    constructor Create(TheOwner: TComponent); override;
    //property PreviewFileDialog: TPreviewFileDialog read FPreviewFileDialog
    //                                               write SetPreviewFileDialog;
  end;}


  TOpenScenarioDialog = class(TOpenDialog)
  private
    FRadioGroup: TRadioGroup;
  protected
    function GetSceneMode(): Boolean;
    procedure SetSceneMode(ASceneMode: Boolean);
  public
    constructor Create(TheOwner: TComponent); override;
    property SceneMode: Boolean read GetSceneMode write SetSceneMode;
  end;

implementation

function TOpenScenarioDialog.GetSceneMode(): Boolean;
begin
 Result:= FRadioGroup.ItemIndex = 1;
end;

procedure TOpenScenarioDialog.SetSceneMode(ASceneMode: Boolean);
begin
 If ASceneMode then FRadioGroup.ItemIndex:= 1
               else FRadioGroup.ItemIndex:= 0;
end;

constructor TOpenScenarioDialog.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);

  FRadioGroup:= TRadioGroup.Create(Self);
  with FRadioGroup do begin
    Name:= 'FRadioGroup';
    //Parent:= Self as TWinControl;
    Align:= alClient;
    Items.Add('Open in Grid Mode (for Grid editing)');
    Items.Add('Open in Scene Mode (for Scene editing)');
    ItemIndex:= 0;
  end;
end;

end.
 