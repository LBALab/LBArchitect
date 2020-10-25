unit TplName;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfmTplName = class(TForm)
    btOK: TBitBtn;
    btCancel: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    edTempName: TEdit;
    edTempDesc: TEdit;
    Label3: TLabel;
  private
    { Private declarations }
  public
    function ShowDialog(var Name: String; var Desc: String): Boolean;
  end;

var
  fmTplName: TfmTplName;

implementation

{$R *.dfm}

function TfmTplName.ShowDialog(var Name: String; var Desc: String): Boolean;
begin
 edTempName.Text:= Trim(Name);
 edTempDesc.Text:= Trim(Desc);

 Result:= ShowModal = mrOK;

 if Result then begin
   Name:= Trim(edTempName.Text);
   Desc:= Trim(edTempDesc.Text);
 end;
end;

end.
