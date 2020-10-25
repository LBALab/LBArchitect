unit CompDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfmCompDlg = class(TForm)
    lbInfo: TLabel;
    rbComp0: TRadioButton;
    rbComp1: TRadioButton;
    rbComp2: TRadioButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    class function ShowDialog(Lba2: Boolean; var Comp: Word; GName: String): Boolean;
  end;

implementation

uses Settings, Main;

{$R *.dfm}

class function TfmCompDlg.ShowDialog(Lba2: Boolean; var Comp: Word; GName: String): Boolean;
var NeedShow: Boolean;
    fmCompDlg: TfmCompDlg;
begin
 NeedShow:= False;
 Result:= True;
 If Lba2 then begin
   If Sett.General.UseComp2 then begin
     case Sett.General.CompMode2 of
       cmForce1: Comp:= 1;
       cmForce2: Comp:= 2;
       cmAsk: NeedShow:= True;
     end;
   end
   else Comp:= 0;
 end
 else begin
   If Sett.General.UseComp1 then begin
     case Sett.General.CompMode1 of
       cmForce1: Comp:= 1;
       cmAsk: NeedShow:= True;
     end;
  end
  else Comp:= 0;
 end;

 if NeedShow then begin
   fmCompDlg:= TfmCompDlg.Create(fmMain);
   fmCompDlg.lbInfo.Caption:= 'Please select what compression you want the '
                            + GName + ' to be saved with:';
   try
     fmCompDlg.rbComp2.Visible:= Lba2;
     Case Comp of
       1: fmCompDlg.rbComp1.Checked:= True;
       2: If Lba2 then fmCompDlg.rbComp2.Checked:= True
                  else fmCompDlg.rbComp0.Checked:= True;
       else fmCompDlg.rbComp0.Checked:= True;
     end;
     If fmCompDlg.ShowModal = mrOK then
       comp:= RadioToIndex(fmCompDlg, 'rbComp%d', 0, 2)
     else Result:= False;
   except
     Result:= False;
   end;
   FreeAndNil(fmCompDlg);
 end;
end;

end.
