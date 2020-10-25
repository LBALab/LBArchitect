unit BrkTable;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Engine, Buttons;

type
  TTableForm = class(TForm)
    Panel1: TPanel;
    pbBrick: TPaintBox;
    sbBricks: TScrollBar;
    Bevel1: TBevel;
    btNone: TBitBtn;
    btTemp: TBitBtn;
    Label1: TLabel;
    eIndex: TEdit;
    btClose: TBitBtn;
    procedure pbBrickPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure sbBricksChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pbBrickMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbBrickClick(Sender: TObject);
    procedure btNoneClick(Sender: TObject);
    procedure eIndexKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Popup(x, y: Integer);
  end;

var
  TableForm: TTableForm;
  BrkSel: Integer;
  bufBrick: TBitmap;

implementation

uses Bricks, Main, StructEd, Layouts;

{$R *.dfm}

Procedure SetScrollBrk;
begin
 TableForm.sbBricks.Enabled:=BrkCount>1;
 If TableForm.sbBricks.Enabled then begin
  TableForm.sbBricks.Max:=(BrkCount div 8);
  TableForm.sbBricks.PageSize:=(TableForm.pbBrick.Height div 41);
  TableForm.sbBricks.LargeChange:=TableForm.sbBricks.PageSize
 end;
end;

procedure PaintBricks();
var a, Start: Integer;
    frame: Boolean;
begin
 With TableForm do begin
  frame:= fmMain.mFrames.Checked;
  Start:= sbBricks.Position;
  bufBrick.Canvas.Brush.Color:= clBtnFace;
  bufBrick.Canvas.FillRect(bufBrick.Canvas.ClipRect);
  for a:= 0 to 8*((bufBrick.Height div 41)+1)-1 do
    PaintBrick((a mod 8)*51, (a div 8)*41, a+Start*8,
      bufBrick, BrkSel=a+Start*8, True, frame);
  UpdateImage(bufBrick, pbBrick);
  fmMain.lbAllocCnt.Caption:= 'Allocated: ' + IntToStr(Allocated);
 end;
end;

procedure TTableForm.pbBrickPaint(Sender: TObject);
begin
 PaintBricks();
end;

procedure TTableForm.FormResize(Sender: TObject);
begin
 SetDimensions(bufBrick,pbBrick.Width,pbBrick.Height);
 PaintBricks();
 SetScrollBrk();
end;

procedure TTableForm.FormDeactivate(Sender: TObject);
begin
 Close();
end;

procedure TTableForm.sbBricksChange(Sender: TObject);
begin
 PaintBricks();
end;

procedure TTableForm.FormShow(Sender: TObject);
begin
 SetScrollBrk;
 If (BrkSel>-1) and sbBricks.Enabled then sbBricks.Position:=BrkSel div 8;
 eIndex.SetFocus;
end;

procedure TTableForm.pbBrickMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var NewSel: Integer;
begin
 If X>8*51-1 then Exit;
 NewSel:= ((Y div 41)+sbBricks.Position)*8+(X div 51);
 If NewSel > BrkCount - 1 then Exit;
 Bricks.PaintBrick((BrkSel mod 8)*51, ((BrkSel div 8)-sbBricks.Position)*41,
   NewSel, bufBrick, False, True, fmMain.mFrames.Checked);
 BrkSel:= NewSel;
 Bricks.PaintBrick((NewSel mod 8)*51, ((NewSel div 8)-sbBricks.Position)*41,
   NewSel, bufBrick, True, True, fmMain.mFrames.Checked);
 UpdateImage(bufBrick, pbBrick);
end;

procedure ExitList(Brk: WORD);
var a, b, c: Integer;
begin
 TableForm.Close();
 TableForm.eIndex.Text:= IntToStr(Brk);
 for c:= StrSelect.z1 to StrSelect.z2 do
   for b:= StrSelect.y1 to StrSelect.y2 do
     for a:= StrSelect.x1 to StrSelect.x2 do
       LtImg.Map[a,b,c].Index:= Brk;
 fmStruct.SetBrickImage(Brk);
 If (LtX > 1) or (Lty > 1) or (LtZ > 1) then begin
   fmStruct.CopyToBuf(StrSelect.x1, StrSelect.y1, StrSelect.z1, buff1);
   fmStruct.CopyToBuf(StrSelect.x1, StrSelect.y1, StrSelect.z1, buff2);
 end;
 fmStruct.DrawStruct();
end;

procedure TTableForm.pbBrickClick(Sender: TObject);
begin
 If (BrkSel > -1) and (BrkSel <= BrkCount-1) then ExitList(BrkSel + 1);
end;

procedure TTableForm.btNoneClick(Sender: TObject);
begin
 If (Sender as TBitBtn).Name = 'btNone' then ExitList(0) else ExitList(65535);
end;

procedure TTableForm.eIndexKeyPress(Sender: TObject; var Key: Char);
var a: Integer;
begin
 If Key = #13 then begin
   a:= StrToIntDef(eIndex.Text,65535);
   If a > 65535 then a:= 65535;
   ExitList(a);
 end
 else if ((Key < '0') or (Key > '9')) and (Key <> #8) then Key:= #0;
end;

procedure TTableForm.Popup(x, y: Integer);
begin
 Left:= x - (Width div 2);
 If Left + Width > Screen.Width then Left:= Screen.Width - Width;
 Top:= y;
 If Top + Height > Screen.Height then Top:= Screen.Height - Height;
 Show;
end;

initialization
 bufBrick:= TBitmap.Create;
 bufBrick.pixelformat:= pf32bit;
 bufBrick.Transparent:= False;

finalization
 If Assigned(bufBrick) then bufBrick.Free;

end.
