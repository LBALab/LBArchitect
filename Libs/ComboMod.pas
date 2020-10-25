//This unit modifies the ComboBoxes in the program in the way that if the
//  box of items dropped down is too narrow to show the full item captions,
//  it will be enlarged to do so.

// Thanks to Giuliano for the code example

//Usage: Call UpdateComboBoxes() once, for example just before the Application.Run.
//
//  If your program changes content of a ComboBox at run time, the required box width
//  may change. To be always sure its size is correct, call UpdateComboBox() after
//  each change of the ComboBox's content.

unit ComboMod;

interface

uses Windows, Forms, StdCtrls, Messages;

procedure UpdateComboBox(Combo: TComboBox);
procedure UpdateComboBoxes();


implementation

procedure UpdateComboBox(Combo: TComboBox);
var a, {CurrentWidth,} MaxWidth, w, CurrentWidth: Integer;
begin
 //CurrentWidth:= SendMessage(Combo.Handle, CB_GETDROPPEDWIDTH, 0, 0);
 //If CurrentWidth = CB_ERR then CurrentWidth:= Combo.Width;
 //CurrentWidth:= Combo.Width;
 MaxWidth:= 0; //Combo.Width;

 for a:= 0 to Combo.Items.Count - 1 do begin
   w:= Combo.Canvas.TextWidth(Combo.Items.Strings[a]);
   if w > MaxWidth then MaxWidth:= w;
 end;

 if Combo.Items.Count <= Combo.DropDownCount then
   CurrentWidth:= Combo.Width
 else
   CurrentWidth:= Combo.Width - GetSystemMetrics(SM_CXVSCROLL);

 if MaxWidth > CurrentWidth then begin
   MaxWidth:= MaxWidth + 8;
   //if Combo.Items.Count > Combo.DropDownCount then
   //  MaxWidth:= MaxWidth + GetSystemMetrics(SM_CXVSCROLL);
 end else
   MaxWidth:= Combo.Width;

 SendMessage(Combo.Handle, CB_SETDROPPEDWIDTH, MaxWidth, 0);
 //TODO: Since the position of the drop down box can't be changed like its
 //  width, it will be better to replace this modification by adding some
 //  sort of hints to the items, that would show immediately after pointing
 //  the item by mouse cursor (and cover the item exactly), if the item text
 //  is too long.
end;

procedure UpdateComboBoxes();
var a, b: Integer;
begin
 for a:= 0 to Screen.FormCount - 1 do begin  //find all forms
   for b:= 0 to Screen.Forms[a].ComponentCount - 1 do begin
     If Screen.Forms[a].Components[b] is TComboBox then
       UpdateComboBox(Screen.Forms[a].Components[b] as TComboBox);
   end;
 end;
end;

end.
