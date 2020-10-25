unit LayImport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Scenario, DePack, Utils, Libraries, ExtCtrls,
  Math, Engine;

type
  TfmLayImport = class(TForm)
    sbContent: TScrollBox;
    btOK: TBitBtn;
    btCancel: TBitBtn;
    Label1: TLabel;
    lbMax: TLabel;
    lbSelCap: TLabel;
    lbSel: TLabel;
    cbAutoPal: TCheckBox;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ItemCheckClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure cbAutoPalClick(Sender: TObject);
  private
    FLib: TCubeLib;
    FBrk: TPackEntries;
    FBrkOff: Integer;
    FOrgPal: TPalette; //palette of imported Scenario
    FMappedPal: TPalette; //index map, not a regular palette
    FPalMapped: Boolean;
    FMax: Integer;
    FLays: array of record
      Panel: TPanel;
      Check: TCheckBox;
      Img: TImage;
    end;
    procedure MapPalette(OrgPal: TPalette);
    procedure ArrangeItems();
  public
    //Max = -1 means: replace (only one Layout can be selected, plus information will be shown)
    class function ShowDialog(Lib: TCubeLib; Brk: TPackEntries;
      BrkOff: Integer; Max: Integer; var Pal: TPalette; var Checks: TBoolDynAr): Boolean;
  end;

implementation

uses Layouts, OptPanel, Editor;

{$R *.dfm}

procedure TfmLayImport.ArrangeItems();
var a, x, y, rowh, flh, maxw, pos: Integer;
begin
 x:= 2;
 y:= 2;
 rowh:= 0;

 flh:= High(FLays);
 sbContent.Hide();
 pos:= sbContent.VertScrollBar.Position;
 sbContent.VertScrollBar.Position:= 0;
 maxw:= sbContent.ClientWidth; // - GetSystemMetrics(SM_CXVSCROLL);

 for a:= 0 to flh do begin
   FLays[a].Panel.Left:= x;
   FLays[a].Panel.Top:= y;
   rowh:= Max(rowh, FLays[a].Panel.Height);
   Inc(x, FLays[a].Panel.Width + 1);
   if a < flh then begin
     if x + FLays[a+1].Panel.Width + 2 > maxw then begin
       x:= 2;
       Inc(y, rowh + 1);
       rowh:= 0;
     end;
   end;
 end;

 sbContent.VertScrollBar.Position:= pos;
 sbContent.Show();
end;

class function TfmLayImport.ShowDialog(Lib: TCubeLib; Brk: TPackEntries;
  BrkOff: Integer; Max: Integer; var Pal: TPalette; var Checks: TBoolDynAr): Boolean;
var Form: TfmLayImport;
    a, top, h: Integer;
begin
 if Max = 0 then begin
   ErrorMsg('No more Layouts can be imported!');
   Exit;
 end;

 Application.CreateForm(Self, Form);

 Form.cbAutoPal.Checked:= Settings.ImportAutoPal;

 Form.FLib:= Lib;
 Form.FBrk:= Brk;
 Form.FBrkOff:= BrkOff;
 Form.FMax:= IfThen(Max = -1, 1, Max);
 Form.FOrgPal:= Pal;
 Form.FPalMapped:= False;

 Form.lbMax.Caption:= IntToStr(Form.FMax);
 //Form.lbReplaceCap.Visible:= Max = -1;

 if Settings.ImportAutoPal then
   Form.MapPalette(Form.FOrgPal);

 SetLength(Form.FLays, Length(Form.FLib));

 top:= 2;

 for a:= 0 to High(Form.FLib) do begin
   Form.FLays[a].Panel:= TPanel.Create(Form);
   Form.FLays[a].Panel.Parent:= Form.sbContent;
   Form.FLays[a].Panel.Caption:= '';
   Form.FLays[a].Panel.BevelOuter:= bvNone;
   //Form.FLays[a].Panel.BevelKind:= bkFlat;
   Form.FLays[a].Panel.BorderStyle:= bsSingle;
   Form.FLays[a].Panel.Ctl3D:= False;
   Form.FLays[a].Panel.DoubleBuffered:= True;

   Form.FLays[a].Check:= TCheckBox.Create(Form);
   Form.FLays[a].Check.Parent:= Form.FLays[a].Panel;
   Form.FLays[a].Check.SetBounds(2, 0, 35, 17);
   Form.FLays[a].Check.Caption:= IntToStr(a);
   Form.FLays[a].Check.Tag:= a;
   Form.FLays[a].Check.DoubleBuffered:= True;
   Form.FLays[a].Check.OnClick:= Form.ItemCheckClick;

   Form.FLays[a].Img:= TImage.Create(Form);
   Form.FLays[a].Img.Parent:= Form.FLays[a].Panel;
   Form.FLays[a].Img.SetBounds(2, 17, GetLtWidth(Form.FLib[a]) + 1, GetLtHeight(Form.FLib[a]) + 1);
   //Form.FLays[a].Img.Transparent:= True;
   Form.FLays[a].Img.Picture.Bitmap.Width:= Form.FLays[a].Img.Width;
   Form.FLays[a].Img.Picture.Bitmap.Height:= Form.FLays[a].Img.Height;
   Form.FLays[a].Img.Picture.Bitmap.PixelFormat:= pf32bit;
   {Form.FLays[a].Img.Picture.Bitmap.Transparent:= True;
   Form.FLays[a].Img.Picture.Bitmap.TransparentMode:= tmFixed;
   Form.FLays[a].Img.Picture.Bitmap.TransparentColor:= clWhite;}
   Form.FLays[a].Img.Canvas.Brush.Color:= clBtnFace;
   Form.FLays[a].Img.Canvas.FillRect(Bounds(0, 0, Form.FLays[a].Img.Width, Form.FLays[a].Img.Height));

   if Settings.ImportAutoPal then
     DrawLayoutNoBuf(0, 0, Form.FLib[a], Form.FBrk, Form.FBrkOff,
       Form.FLays[a].Img.Picture.Bitmap, False, False, Form.FMappedPal, True)
   else
     DrawLayoutNoBuf(0, 0, Form.FLib[a], Form.FBrk, Form.FBrkOff,
       Form.FLays[a].Img.Picture.Bitmap, False, False);

   Form.FLays[a].Panel.SetBounds(2, top, Form.FLays[a].Img.Width + 6,
                                         17 + Form.FLays[a].Img.Height + 4);
   Inc(top, Form.FLays[a].Panel.Height + 1);
 end;

 Form.ArrangeItems();

 Result:= Form.ShowModal = mrOK;

 if Result then begin
   SetLength(Checks, Length(Form.FLays));
   for a:= 0 to High(Form.FLays) do
     Checks[a]:= Form.FLays[a].Check.Checked;
   if Form.FPalMapped then
     Pal:= Form.FMappedPal;
 end;

 FreeAndNil(Form);
end;

procedure TfmLayImport.MapPalette(OrgPal: TPalette);
var a: Integer;
begin
 if FPalMapped then Exit;
 FMappedPal[0]:= 0; //colour 0 is transparent -- always the same
   for a:= 1 to 255 do
     FMappedPal[a]:= FindNearestColour(OrgPal[a]);
 FPalMapped:= True;
end;

procedure TfmLayImport.cbAutoPalClick(Sender: TObject);
var a: Integer;
begin
 Settings.ImportAutoPal:= cbAutoPal.Checked;
 if cbAutoPal.Checked then begin
   MapPalette(FOrgPal);
   for a:= 0 to High(FLib) do begin
     DrawLayoutNoBuf(0, 0, FLib[a], FBrk, FBrkOff,
       FLays[a].Img.Picture.Bitmap, False, False, FMappedPal, True);
     FLays[a].Panel.Repaint();
   end;
 end else begin
   for a:= 0 to High(FLib) do begin
     DrawLayoutNoBuf(0, 0, FLib[a], FBrk, FBrkOff,
       FLays[a].Img.Picture.Bitmap, False, False);
     FLays[a].Panel.Repaint();
   end;
 end;
end;

procedure TfmLayImport.btOKClick(Sender: TObject);
var a, sel: Integer;
begin
 sel:= 0;
 for a:= 0 to High(FLays) do
   if FLays[a].Check.Checked then Inc(sel);

 if sel > FMax then
   ErrorMsg('Number of selected Layouts exceeds maximum number of Layouts that can be imported!')
 else
   ModalResult:= mrOK;
end;

procedure TfmLayImport.FormCreate(Sender: TObject);
begin
 DoubleBuffered:= True;
 sbContent.DoubleBuffered:= True;
 btOK.Enabled:= False;
end;

procedure TfmLayImport.FormResize(Sender: TObject);
begin
 ArrangeItems();
end;

procedure TfmLayImport.ItemCheckClick(Sender: TObject);
var Col: TColor;
    id, a, sel: Integer;
begin
 if (Sender as TCheckBox).Checked then
   Col:= $4fbfFF
 else
   Col:= clBtnFace;

 id:= (Sender as TCheckBox).Tag;

 FLays[id].Panel.Color:= Col;
 (Sender as TCheckBox).Color:= Col;

 FLays[id].Img.Canvas.Brush.Color:= Col;
 FLays[id].Img.Canvas.FillRect(Bounds(0, 0, FLays[id].Img.Width, FLays[id].Img.Height));
 if Settings.ImportAutoPal then
   DrawLayoutNoBuf(0, 0, FLib[id], FBrk, FBrkOff,
     FLays[id].Img.Picture.Bitmap, False, False, FMappedPal, True)
 else
   DrawLayoutNoBuf(0, 0, FLib[id], FBrk, FBrkOff,
     FLays[id].Img.Picture.Bitmap, False, False);

 sel:= 0;
 for a:= 0 to High(FLays) do
   if FLays[a].Check.Checked then Inc(sel);

 lbSel.Caption:= IntToStr(sel);
 if sel > FMax then begin
   lbSelCap.Font.Color:= clRed;
   lbSel.Font.Color:= clRed;
 end else begin
   lbSelCap.Font.Color:= clWindowText;
   lbSel.Font.Color:= clWindowText;
 end;

 btOK.Enabled:= sel > 0;
end;

end.
