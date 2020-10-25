unit LtUsage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TfmLtUsage = class(TForm)
    btOK: TBitBtn;
    btCancel: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    SelReplace: TBitBtn;
    Label3: TLabel;
    btSelAdd: TBitBtn;
    Panel2: TPanel;
    btCopy: TBitBtn;
    Label4: TLabel;
    btPaseReplace: TBitBtn;
    btPasteAdd: TBitBtn;
    Label5: TLabel;
    btUnselAll: TBitBtn;
  private
    { Private declarations }
  public
    //function ShowDialog(var LtUsage: 
  end;

var
  fmLtUsage: TfmLtUsage;

implementation

{$R *.dfm}

end.
