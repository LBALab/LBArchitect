//******************************************************************************
// Little Big Architect: Builder - editing grid files containing rooms in
//                                 Little Big Adventure 1 & 2
//
// ListDialog unit.
// Contains routines used for displaying entry list when choosing hqr files.
//
// Copyright (C) Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit ListDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfmListForm = class(TForm)
    ListBox: TListBox;
    btOK: TButton;
    Button2: TButton;
    Label1: TLabel;
    procedure ListBoxClick(Sender: TObject);
    procedure ListBoxDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ShowDialog(Mode: String; Count: Integer; out RetVal: Integer): Boolean;
  end;

var
  fmListForm: TfmListForm;

implementation

{$R *.dfm}

function TfmListForm.ShowDialog(Mode: String; Count: Integer; out RetVal: Integer): Boolean;
var t: String;
    RStr: TResourceStream;
    a: Integer;
begin
 If (Mode='LBA_1_BLL') or (Mode='LBA_2_BLL') then t:='Library' else t:='Grid';
 Label1.Caption:= 'The package you selected contains more than one '+t+'.'#13'Which one do you want to use?';
 RStr:= TResourceStream.Create(0,Mode,'TEXT');
 ListBox.Items.LoadFromStream(RStr);
 while ListBox.Items.Count > Count do ListBox.Items.Delete(ListBox.Items.Count-1);
 a:= ListBox.Items.Count - 1;
 while ListBox.Items.Count < Count do ListBox.Items.Add(Format('Unknown item %d',[ListBox.Items.Count-a]));
 btOK.Enabled:= False;
 ShowModal;
 RetVal:= ListBox.ItemIndex;
 Result:= ModalResult = mrOK;
end;

procedure TfmListForm.ListBoxClick(Sender: TObject);
begin
 btOK.Enabled:=ListBox.ItemIndex>-1;
end;

procedure TfmListForm.ListBoxDblClick(Sender: TObject);
begin
 ModalResult:=mrOK;
end;

end.
