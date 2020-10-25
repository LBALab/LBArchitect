//******************************************************************************
// Little Big Architect: Factory - editing brick and layout files from
//                                 Little Big Adventure 1 & 2
//
// Editor unit.
// Contains editor window.
//
// Copyright Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit Editor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Bricks, ClipBrd, ComCtrls, Math;

type
  TEditForm = class(TForm)
    pbMain: TPaintBox;
    btAccept: TBitBtn;
    btCancel: TBitBtn;
    Bevel1: TBevel;
    sbHor: TScrollBar;
    sbVer: TScrollBar;
    btPen: TSpeedButton;
    btSelect: TSpeedButton;
    btCopy: TBitBtn;
    btPaste: TBitBtn;
    btZoom: TBitBtn;
    btDisp: TBitBtn;
    Bevel2: TBevel;
    pbPal: TPaintBox;
    btUndo: TSpeedButton;
    btRedo: TSpeedButton;
    btTransN: TSpeedButton;
    btTrans: TSpeedButton;
    StatusBar1: TStatusBar;
    dlSave: TSaveDialog;
    dlOpen: TOpenDialog;
    btFill: TSpeedButton;
    btSave: TBitBtn;
    btLoad: TBitBtn;
    btPick: TSpeedButton;
    btOpts: TBitBtn;
    paWarning: TPanel;
    Label1: TLabel;
    btWarningMore: TButton;
    procedure pbMainPaint(Sender: TObject);
    procedure FormConstrainedResize(Sender: TObject; var MinWidth,
      MinHeight, MaxWidth, MaxHeight: Integer);
    procedure btZoomClick(Sender: TObject);
    procedure btDispClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sbVerChange(Sender: TObject);
    procedure pbPalPaint(Sender: TObject);
    procedure pbPalMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbPalMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbMainMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure btUndoClick(Sender: TObject);
    procedure btRedoClick(Sender: TObject);
    procedure btPenClick(Sender: TObject);
    procedure btTransNClick(Sender: TObject);
    procedure btCopyClick(Sender: TObject);
    procedure btPasteClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure btLoadClick(Sender: TObject);
    procedure pbPalMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btOptsClick(Sender: TObject);
    procedure btWarningMoreClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
 //ZoomFactors: array[0..5] of Byte = (1, 2, 3, 5, 7, 10);

 MaxUndo = 30;

var
  EditForm: TEditForm;
  Buffer: TBitmap;
  bufMain: TBitmap;

  bitImage: TVarBrick;
  LtX, LtY, LtZ: Byte;
  Zoom: Byte;
  OptsId: Integer = -1;
  LeftCol: Byte = 255;
  RightCol: Byte = 0;
  MDrawing: Boolean = False;
  BrickMode: Boolean;

  UndoArray: array[1..30] of TVarBrick;
  RedoImage: TVarBrick;
  LastUndo: Integer = 0;
  FirstRedo: Integer = 0;

  Selection: TRect;
  MMoving: Boolean = False;
  MSelecting: Boolean = False;
  SelMoving: Boolean = False;
  ColSelecting: Boolean = False;
  LastCoords, Start: TPoint;
  BufBrick1, BufBrick2: TVarBrick;
  JustSelected: Boolean = False;
  CopyBuf: TVarBrick;
  CopyTransColour: TColor;
  LastTool: Integer = 0;

procedure SetScrolls(ChangeMax: Boolean);
function PointInBrick(x, y: Integer): Boolean;
procedure PaintBrick(x1: Integer = 0; y1: Integer = 0; x2: Integer = -1; y2: Integer = -1);
procedure RepaintImage();
function PointInRect(R: TRect; x, y: Integer): Boolean;
procedure ClearSelection();
procedure DrawSelection();
function FindNearestColour(c: TColor): Byte;

implementation

{$R *.dfm}
{$R Images.res}

uses Engine, Main, OptPanel, Layouts;

procedure SetScrolls(ChangeMax: Boolean);
begin
 EditForm.sbHor.Position:=0;
 EditForm.sbVer.Position:=0;
 EditForm.sbHor.Enabled:=bitImage.Width*zoom>EditForm.pbMain.Width-1;
 If EditForm.sbHor.Enabled then begin
  If ChangeMax then EditForm.sbHor.Max:=bitImage.Width*zoom;
  EditForm.sbHor.PageSize:=EditForm.pbMain.Width;
 end;
 EditForm.sbVer.Enabled:=bitImage.Height*zoom>EditForm.pbMain.Height-1;
 If EditForm.sbVer.Enabled then begin
  If ChangeMax then EditForm.sbVer.Max:=bitImage.Height*zoom;
  EditForm.sbVer.PageSize:=EditForm.pbMain.Height;
 end;
end;

function PointInBrick(x, y: Integer): Boolean;
begin
 Result:=(x-2>=y*2-LtY*30-LtZ*24) and (x-1<=y*2+LtZ*24) and (x+2>=-y*2+LtZ*24)
  and (x+3<=-y*2+LtX*48+LtZ*24+LtY*30) and (x>=0) and (x<=bitImage.Width-1);
end;       

procedure SetUndo;
var a: Integer;
begin
 If LastUndo<MaxUndo then
  Inc(LastUndo)
 else
  for a:=1 to MaxUndo-1 do
   CopyVarBrick(UndoArray[a],UndoArray[a+1]);
 CopyVarBrick(UndoArray[LastUndo],bitImage);
 EditForm.btRedo.Enabled:=False;
 EditForm.btUndo.Enabled:=True;
end;

procedure RectTransp(x1, y1, x2, y2: Integer; c: TCanvas; Border: Boolean = False;
 sh: Integer=0); overload;
var a, b, d: Integer;
    temp: TColor;
begin
 temp:=c.Pen.Color;
 d:=(((x1-y1-sh) mod 5)+5) mod 5; //for correct operation on values less than zero
 c.Brush.Color:=clWhite;
 If Border then c.Pen.Color:=clBtnShadow else c.Pen.Color:=clWhite;
 c.Rectangle(x1,y1,x2,y2);
 If Border then begin Inc(x1); Inc(y1); end;
 c.Pen.Color:=clBlack;
 for a:=0 to ((y2-y1+x2-x1-d-1) div 5) do begin
  c.MoveTo(x1+Max(x2-x1-a*5-d,0),y1+Max(a*5-x2+x1+d,0));
  c.LineTo(x2-Max(a*5-y2+y1+d,0),y2-Max(y2-y1-a*5-d,0));
 end;
 c.Pen.Color:=temp;
end;

procedure RectTransp(x1, y1, x2, y2: Integer; bit: TBitmap; sh: Integer=0); overload;
var a, b, bitW: Integer;
    temp: TColor;
begin
 bitW:= bit.Width;
 for b:=Max(0,y1) to Min(y2-1,bit.Height-1) do
  for a:=Max(0,x1) to Min(x2-1,bitW-1) do
   If (a - b - sh) mod 5 = 0 then
    DWord(Pointer(Integer(bit.ScanLine[b])+a*4)^):= clBlack
   else DWord(Pointer(Integer(bit.ScanLine[b])+a*4)^):= clWhite;
end;

procedure FrontLines(x, y: Integer);
var a, b: Integer;
begin
 With bufMain.Canvas do begin
  //Pen.Color:=OptForm.cbFrontC.Color;
  for a:=1 to LtX-1 do begin
   MoveTo(a*12*zoom*2-1+x,((a+LtZ)*12+LtY*15-1)*zoom-1+y);
   for b:=1 to LtZ*12 do begin
    LineTo((b+a*12-1)*zoom*2-1+x,((LtZ+a)*12-b)*zoom-1+y);
    LineTo((b+a*12)*zoom*2-1+x,((LtZ+a)*12-b)*zoom-1+y);
   end;
  end;
  for a:=1 to LtZ-1 do begin
   MoveTo((LtX+a)*12*zoom*2-1+x,((LtX+LtZ-a)*12+LtY*15-1)*zoom-1+y);
   for b:=LtX*12-1 downto 0 do begin
    LineTo((b+a*12+1)*zoom*2-1+x,(b+(LtZ-a)*12)*zoom-1+y);
    LineTo((b+a*12)*zoom*2-1+x,(b+(LtZ-a)*12)*zoom-1+y);
   end;
  end;
  for a:=1 to LtY-1 do begin
   MoveTo(-1+x,(LtZ*12+a*15)*zoom-1+y);
   for b:=1 to LtX*12-1 do begin
    LineTo(b*zoom*2-1+x,(b+a*15+LtZ*12-1)*zoom-1+y);
    LineTo(b*zoom*2-1+x,(b+a*15+LtZ*12)*zoom-1+y);
   end;
   for b:=1 to LtZ*12 do begin
    LineTo((b+LtX*12-1)*zoom*2-1+x,((LtZ+LtX)*12+a*15-b)*zoom-1+y);
    LineTo((b+LtX*12)*zoom*2-1+x,((LtZ+LtX)*12+a*15-b)*zoom-1+y);
   end;
  end;
 end;
end;

procedure FrontFrame(x, y: Integer);
var a: Integer;
begin
 With bufMain.Canvas do begin
  Pen.Color:=OptForm.cbFrontC.Color;
  MoveTo(-1+x,LtZ*12*zoom-1+y);  //--- top ---
  for a:= 0 to LtZ*12-1 do begin
   LineTo(a*zoom*2-1+x,(LtZ*12-a)*zoom-1+y); // /`
   LineTo(a*zoom*2-1+x,(LtZ*12-1-a)*zoom-1+y);
  end;
  for a:= 1 to LtX*12 do begin
   LineTo((a+LtZ*12)*zoom*2-1+x,(a-1)*zoom-1+y); // '\
   LineTo((a+LtZ*12)*zoom*2-1+x,a*zoom-1+y);
  end;
  for a:= -2 downto -Integer(LtZ)*12 do begin
   LineTo((a+(LtX+LtZ)*12+1)*zoom*2-1+x,(-2+LtX*12-a)*zoom-1+y); // ./
   LineTo((a+(LtX+LtZ)*12+1)*zoom*2-1+x,(-1+LtX*12-a)*zoom-1+y);
  end;
  for a:= LtX*12-1 downto 1 do begin
   LineTo(a*zoom*2-1+x,(a+LtZ*12)*zoom-1+y); // \,
   LineTo(a*zoom*2-1+x,(a+LtZ*12-1)*zoom-1+y);
  end;
  LineTo(-1+x,LtZ*12*zoom-1+y); //--- end of top ---
  LineTo(-1+x,(LtZ*12+LtY*15)*zoom-1+y); // |
  for a:=1 to LtX*12-1 do begin
   LineTo(a*zoom*2-1+x,(a+LtZ*12+LtY*15-1)*zoom-1+y);
   LineTo(a*zoom*2-1+x,(a+LtZ*12+LtY*15)*zoom-1+y);
  end;
  for a:= -Integer(LtZ)*12+1 to 0 do begin
   LineTo((a+(LtX+LtZ)*12)*zoom*2-1+x,(LtX*12+LtY*15-a)*zoom-1+y);
   LineTo((a+(LtX+LtZ)*12)*zoom*2-1+x,(-1+LtX*12+LtY*15-a)*zoom-1+y);
  end;
  LineTo((LtX+LtZ)*12*zoom*2-1+x,LtX*12*zoom-1+y); // |
  MoveTo(LtX*12*zoom*2-1+x,(-1+(LtX+LtZ)*12+LtY*15)*zoom-1+y);
  LineTo(LtX*12*zoom*2-1+x,(-1+(LtX+LtZ)*12)*zoom-1+y);
 end;
 If OptForm.cbAddF.Checked then FrontLines(x,y);
end;

procedure BackLines(x, y: Integer);
var a, b: Integer;
begin
 With bufMain.Canvas do begin
  //Pen.Color:=OptForm.cbBackC.Color;
  for a:=1 to LtX-1 do begin
   MoveTo((LtZ+a)*12*zoom*2-1+x,a*12*zoom-1+y);
   for b:=1 to LtZ*12 do begin
    LineTo((-b+(LtZ+a)*12+1)*zoom*2-1+x,(a*12+LtY*15+b-1)*zoom-1+y);
    LineTo((-b+(LtZ+a)*12)*zoom*2-1+x,(a*12+LtY*15+b-1)*zoom-1+y);
   end;
  end;
  for a:=1 to LtZ-1 do begin
   MoveTo(a*12*zoom*2-1+x,(LtZ-a)*12*zoom-1+y);
   for b:=0 to LtX*12-1 do begin
    LineTo((b+a*12)*zoom*2-1+x,(b+(LtZ-a)*12+LtY*15)*zoom-1+y);
    LineTo((b+a*12+1)*zoom*2-1+x,(b+(LtZ-a)*12+LtY*15)*zoom-1+y);
   end;
  end;
  for a:=1 to LtY-1 do begin
   MoveTo(-1+x,(LtZ*12+a*15)*zoom-1+y);
   for b:=0 to LtZ*12-1 do begin
    LineTo(b*zoom*2-1+x,(LtZ*12+a*15-b)*zoom-1+y);
    LineTo(b*zoom*2-1+x,(LtZ*12+a*15-1-b)*zoom-1+y);
   end;
   for b:=0 to LtX*12-1 do begin
    LineTo((b+LtZ*12)*zoom*2-1+x,(b+a*15)*zoom-1+y);
    LineTo((b+LtZ*12+1)*zoom*2-1+x,(b+a*15)*zoom-1+y);
   end;
  end;
 end;
end;

procedure BackFrame(x, y: Integer);
var a: Integer;
begin
 With bufMain.Canvas do begin
  Pen.Color:=OptForm.cbBackC.Color;
  MoveTo(0+x,(-1+LtZ*12+LtY*15)*zoom-1+y);
  for a:=1 to LtZ*12-1 do begin
   LineTo(a*zoom*2-1+x,(LtZ*12+LtY*15-a)*zoom-1+y);
   LineTo(a*zoom*2-1+x,(-1+LtZ*12+LtY*15-a)*zoom-1+y);
  end;
  LineTo((LtZ*12+1)*zoom*2-1+x,LtY*15*zoom-1+y);
  for a:=1 to LtX*12-1 do begin
   LineTo((a+LtZ*12)*zoom*2-1+x,(a+LtY*15)*zoom-1+y);
   LineTo((a+LtZ*12+1)*zoom*2-1+x,(a+LtY*15)*zoom-1+y);
  end;
  MoveTo(LtZ*12*zoom*2-1+x,LtY*15*zoom-1+y);
  LineTo(LtZ*12*zoom*2-1+x,-1+y);
 end;
 If OptForm.cbAddF.Checked then BackLines(x,y);
end;

procedure PaintBrick(x1: Integer = 0; y1: Integer = 0; x2: Integer = -1; y2: Integer = -1);
var a, b, x, y: Integer;
    g: Byte;
    Back, Region: Boolean;
    Clip: HRGN;
begin
 If x1<0 then x1:=0;
 If y1<0 then y1:=0;
 If (x2<0) or (x2>bitImage.Width-1) then x2:=bitImage.Width-1;
 If (y2<0) or (y2>bitImage.Height-1) then y2:=bitImage.Height-1;
 x:=-EditForm.sbHor.Position+1;
 y:=-EditForm.sbVer.Position+1;
 Region:=(x1>0) or (y1>0) or (x2<bitImage.Width-1) or (y2<bitImage.Height-1);
 If Region then begin
  Clip:=CreateRectRgn(x1*zoom+x-1,y1*zoom+y-1,(x2+1)*zoom+x,(y2+1)*zoom+y);
  SelectClipRgn(bufMain.Canvas.Handle,Clip);
 end;
 If OptForm.cbGrid.Checked and (zoom>=4) then g:=1 else g:=0;
 Back:=OptForm.cbBackF.Checked and OptForm.cbCoverBack.Checked;

 for b:=y1 to y2 do
  for a:=x1 to x2 do
   If PointInBrick(a,b) and (bitImage.Image[a,b]=0) then
    RectTransp(a*zoom+x,b*zoom+y,(a+1)*zoom+x-g,(b+1)*zoom+y-g,bufMain,x-y);

 If Back then BackFrame(x,y);
 Back:=Back and (g=1);
 bufMain.Canvas.Pen.Color:=clBtnFace;

 for b:=y1 to y2 do
  for a:=x1 to x2 do
   If PointInBrick(a,b) then begin
    If bitImage.Image[a,b]>0 then begin
     bufMain.Canvas.Brush.Color:=Palette[bitImage.Image[a,b]];
     bufMain.Canvas.FillRect(Bounds(a*zoom+x,b*zoom+y,zoom-g,zoom-g));
     If Back then begin
      bufMain.Canvas.MoveTo((a+1)*zoom-1+x,b*zoom-1+y);
      bufMain.Canvas.LineTo((a+1)*zoom-1+x,(b+1)*zoom-1+y);
      bufMain.Canvas.LineTo(a*zoom-1+x,(b+1)*zoom-1+y);
     end;
    end;
   end;
 If OptForm.cbBackF.Checked and not OptForm.cbCoverBack.Checked then BackFrame(x,y);
 If OptForm.cbFrontF.Checked then FrontFrame(x,y);
 If Region then begin
  SelectClipRgn(bufMain.Canvas.Handle,0);
  DeleteObject(Clip);
 end;
end;

procedure RepaintImage;
var x, y: Integer;
begin
 If bitImage.Width=0 then Exit;
 With EditForm do begin
  x:=sbHor.Position-1;
  y:=sbVer.Position-1;
  bufMain.Canvas.Brush.Color:=clBtnFace;
  bufMain.Canvas.FillRect(Rect(0,0,pbMain.Width,pbMain.Height));
  PaintBrick(x div zoom,y div zoom,(x+pbMain.Width-1) div zoom,(y+pbMain.Height-1) div zoom);
  UpdateImage(bufMain,pbMain);
  If btCopy.Enabled then DrawSelection;
 end;
end;

procedure RepaintFragment(x1, y1, x2, y2: Integer);
var x, y: Integer;
begin
 x:=EditForm.sbHor.Position-1;
 y:=EditForm.sbVer.Position-1;
 //EditForm.imgMain.Canvas.Brush.Color:=clBtnFace;
 //EditForm.imgMain.Canvas.FillRect(Bounds(x1*zoom+x,b*zoom+y,(a+1)*zoom+x-g,(b+1)*zoom+y-g));
 PaintBrick(x1,y1,x2,y2);
 EditForm.pbMain.Canvas.CopyRect(Rect(x1*zoom-x,y1*zoom-y,(x2+1)*zoom-x,(y2+1)*zoom-y),
  bufMain.Canvas,Rect(x1*zoom-x,y1*zoom-y,(x2+1)*zoom-x,(y2+1)*zoom-y));
end;

procedure TEditForm.pbMainPaint(Sender: TObject);
begin
 UpdateImage(bufMain,pbMain);
 If EditForm.btCopy.Enabled then DrawSelection;
end;

procedure TEditForm.FormConstrainedResize(Sender: TObject; var MinWidth,
  MinHeight, MaxWidth, MaxHeight: Integer);
begin
 OptForm.Left:=EditForm.Left+EditForm.Width;
 OptForm.Top:=EditForm.Top;
end;

procedure TEditForm.FormResize(Sender: TObject);
begin
 SetDimensions(bufMain,pbMain.Width,pbMain.Height);
 SetScrolls(False);
 RepaintImage;
end;

procedure HideOpts;
begin
 OptForm.HidePanel;
 case OptForm.pcOpts.ActivePageIndex of
  0: EditForm.btZoom.Glyph.LoadFromResourceName(0,'AR_RIGHT');
  1: EditForm.btDisp.Glyph.LoadFromResourceName(0,'AR_RIGHT');
  2: EditForm.btOpts.Glyph.LoadFromResourceName(0,'AR_RIGHT');
 end;
end;

procedure TEditForm.btZoomClick(Sender: TObject);
begin
 If not OptForm.Visible or (OptForm.pcOpts.ActivePageIndex<>0) then begin
  If OptForm.Visible then HideOpts;
  OptForm.ShowPanel(Left+Width,Top,0);
  btZoom.Glyph.LoadFromResourceName(0,'AR_LEFT');
 end else HideOpts;
end;

procedure TEditForm.btDispClick(Sender: TObject);
begin
 If not OptForm.Visible or (OptForm.pcOpts.ActivePageIndex<>1) then begin
  If OptForm.Visible then HideOpts;
  OptForm.ShowPanel(Left+Width,Top,1);
  btDisp.Glyph.LoadFromResourceName(0,'AR_LEFT');
 end else HideOpts;
end;

procedure TEditForm.btOptsClick(Sender: TObject);
begin
 If not OptForm.Visible or (OptForm.pcOpts.ActivePageIndex<>2) then begin
  If OptForm.Visible then HideOpts;
  OptForm.ShowPanel(Left+Width,Top,2);
  btOpts.Glyph.LoadFromResourceName(0,'AR_LEFT');
 end else HideOpts;
end;

procedure TEditForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 If OptForm.Visible then OptsId:=OptForm.pcOpts.ActivePageIndex else OptsId:=-1;
 HideOpts;
end;

procedure TEditForm.sbVerChange(Sender: TObject);
begin
 RepaintImage;
end;

procedure TEditForm.pbPalPaint(Sender: TObject);
var a: Integer;
begin
 RectTransp(0,0,6,6,pbPal.Canvas);
 for a:=1 to 255 do begin
  pbPal.Canvas.Brush.Color:=Palette[a];
  pbPal.Canvas.FillRect(Bounds((a mod 16)*7,(a div 16)*7,6,6));
 end;
 RectTransp(10,120,60,134,pbPal.Canvas);
 pbPal.Canvas.Pen.Color:=clBtnShadow;
 If RightCol>0 then begin
  pbPal.Canvas.Brush.Color:=Palette[RightCol];
  pbPal.Canvas.Rectangle(92,124,107,139);
 end else
  RectTransp(92,124,107,139,pbPal.Canvas,True);
 If LeftCol>0 then begin
  pbPal.Canvas.Brush.Color:=Palette[LeftCol];
  pbPal.Canvas.Rectangle(84,116,99,131);
 end else
  RectTransp(84,116,99,131,pbPal.Canvas,True);
 pbPal.Canvas.Pen.Color:=clBtnHighlight;
 pbPal.Canvas.MoveTo(106,124);
 pbPal.Canvas.LineTo(106,138);
 pbPal.Canvas.LineTo(92,138);
 pbPal.Canvas.MoveTo(98,116);
 pbPal.Canvas.LineTo(98,130);
 pbPal.Canvas.LineTo(84,130);
end;

procedure TEditForm.pbPalMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 ColSelecting:=True;
 If Y<16*7 then begin
  X:=X div 7;
  Y:=Y div 7;
  If Button=mbLeft then LeftCol:=X+Y*16 else if Button=mbRight then RightCol:=X+Y*16;
  pbPalPaint(Self);
 end
 else if (X>=10) and (Y>=120) and (X<60) and (Y<134) then begin
  If Button=mbLeft then LeftCol:=0 else if Button=mbRight then RightCol:=0;
  pbPalPaint(Self);
 end
 else ColSelecting:=False;
 btTransNClick(Sender);
end;

procedure TEditForm.pbPalMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var Button: TMouseButton;
begin
 If ColSelecting then begin
  If ssLeft in Shift then Button:=mbLeft
  else if ssRight in Shift then Button:=mbRight
  else Exit;
  pbPalMouseDown(Sender,Button,Shift,X,Y);
 end; 
end;

procedure TEditForm.pbPalMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 ColSelecting:=False;
end;

Procedure EnableSelect(Enable: Boolean = True);
begin
 EditForm.btCopy.Enabled:=Enable;
end;

procedure ClearSelection;
begin
 PaintBrick(Selection.Left,Selection.Top,Selection.Right,Selection.Bottom);
 UpdateImage(bufMain,EditForm.pbMain);
 EditForm.btCopy.Enabled:=False;
end;

function NormRect(R: TRect): TRect; overload;
begin
 Result.Left:= Min(R.Left,R.Right);
 Result.Right:= Max(R.Left,R.Right);
 Result.Top:= Min(R.Top,R.Bottom);
 Result.Bottom:= Max(R.Top,R.Bottom);
end;

function NormRect(ALeft, ATop, ARight, ABottom: Integer): TRect; overload;
begin
 Result.Left:= Min(ALeft,ARight);
 Result.Right:= Max(ALeft,ARight);
 Result.Top:= Min(ATop,ABottom);
 Result.Bottom:= Max(ATop,ABottom);
end;

procedure DelimitPoint(var P: TPoint; const Region: TRect); overload;
begin
 P.X:= Max(P.X,Region.Left);  P.X:= Min(P.X,Region.Right);
 P.Y:= Max(P.Y,Region.Top);   P.Y:= Min(P.Y,Region.Bottom);
end;

procedure DelimitPoint(var X, Y: Integer; const Region: TRect); overload;
begin
 X:= Max(X,Region.Left);  X:= Min(X,Region.Right);
 Y:= Max(Y,Region.Top);   Y:= Min(Y,Region.Bottom);
end;

function PointInRect(R: TRect; x, y: Integer): Boolean;
begin
 Result:=(x>=R.Left) and (x<=R.Right) and (y>=R.Top) and (y<=R.Bottom);
end;

{procedure AddRect(var Subject: TRect; const R: TRect);
begin
 Subject.Left:=Smaller(Subject.Left,R.Left);
 Subject.Right:=Larger(Subject.Right,R.Right);
 Subject.Top:=Smaller(Subject.Top,R.Top);
 Subject.Bottom:=Larger(Subject.Bottom,R.Bottom);
end;}

Procedure DrawSelection;
var R: TRect;
    x, y: Integer;
begin
 EditForm.pbMain.Canvas.Brush.Color:=$0080FF;
 R:=NormRect(Selection);
 x:=EditForm.sbHor.Position;
 y:=EditForm.sbVer.Position;
 EditForm.pbMain.Canvas.FrameRect(
  Rect(R.Left*zoom-x,R.Top*zoom-y,(R.Right+1)*zoom+1-x,(R.Bottom+1)*zoom+1-y));
end;

{Line drawing procedure by Gr0g (modified)}
procedure DrawLine(x1, y1, x2, y2: Integer; c: Byte; Brk: TVarBrick);
 Function Sgn(x: Integer): Integer;
 begin
  If x<>0 then Sgn:=x div Abs(x) else Sgn:=0;
 end;
var Licznik, xs, ys, KierunekX, KierunekY: integer;
begin
 xs:=x2-x1;
 ys:=y2-y1;
 KierunekX:=Sgn(xs);
 KierunekY:=Sgn(ys);
 xs:=abs(xs);
 ys:=abs(ys);
 Brk.Image[x1,y1]:=c;
 If xs>ys then begin
  Licznik:=-(xs div 2);
  while (x1 <> x2 ) do begin
   Inc(Licznik,ys);
   Inc(x1,KierunekX);
   If Licznik>0 then begin
    Inc(y1,KierunekY);
    Dec(Licznik,xs);
   end;
   Brk.Image[x1,y1]:=c;
  end;
 end
 else begin
  Licznik:=-(ys div 2);
  while (y1 <> y2 ) do begin
   Inc(Licznik,xs);
   Inc(y1,KierunekY);
   If Licznik>0 then begin
    x1:=x1+KierunekX;
    Dec(Licznik,ys);
   end;
   Brk.Image[x1,y1]:=c;
  end;
 end;
end;

procedure FillArea(x, y: Integer; origc, newc: byte);
begin
 If PointInBrick(x,y) and (bitImage.Image[x,y]=origc) then begin
  bitImage.Image[x,y]:=newc;
  FillArea(x-1,y,origc,newc);
  FillArea(x+1,y,origc,newc);
  FillArea(x,y-1,origc,newc);
  FillArea(x,y+1,origc,newc);
 end;
end;

function GetImageCoords(var x, y: Integer; const UpdateLast: Boolean = True): Boolean;
begin
 x:=(x+EditForm.sbHor.Position-1) div zoom;
 y:=(y+EditForm.sbVer.Position-1) div zoom;
 If UpdateLast then begin
  Result:=((x<>LastCoords.x) or (y<>LastCoords.y));
  LastCoords:=Point(x,y);
 end;
 //Result:=(x>=0) and (x<=47) and (y>=0) and (y<=37);
end;

procedure PutPixel(x, y: Integer; Left, Right, Update, First: Boolean);
var temp: Byte;
begin
 If PointInBrick(x,y) then begin
  If Start.X<0 then Start:=point(x,y);
  If Left then Temp:=LeftCol else if Right then Temp:=RightCol else Exit;
  If First then begin
   bitImage.Image[X,Y]:=Temp;
   If Update then RepaintFragment(x,y,x,y);
  end
  else begin
   DrawLine(Start.X,Start.Y,x,y,Temp,bitImage);
   If Update then RepaintFragment(
    Min(Start.X,x),Min(Start.Y,y),Max(Start.X,x),Max(Start.Y,y));
  end;
  Start:=point(x,y);
 end
 else Start.X:=-1;
end;

procedure TEditForm.pbMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var Temp: Byte;
begin
 GetImageCoords(X,Y,False);
 If btPen.Down and (X>=0) and (X<=bitImage.Width-1) and (Y>=0) and (Y<=bitImage.Height-1) then begin
  If Button=mbMiddle then Exit;
  SetUndo;
  PutPixel(X,Y,Button=mbLeft,Button=mbRight,True,True);
  MDrawing:=True;
 end;
 If btSelect.Down then begin
  If btCopy.Enabled and PointInRect(Selection,X,Y) then begin
   SetUndo;
   If ssCtrl in Shift then CopyVarBrick(BufBrick1,BufBrick2)
   else if JustSelected then FillVarBrick(BufBrick1,RightCol);
   JustSelected:=False;
   SelMoving:=True;
   Start:=Point(X,Y);
  end
  else if (X>=0) and (X<=bitImage.Width-1) and (Y>=0) and (Y<=bitImage.Height-1) then begin
   ClearSelection;
   Selection:=Rect(X,Y,X,Y);
   MSelecting:=True;
  end;
 end
 else if btFill.Down then begin
  If Button=mbLeft then Temp:=LeftCol else if Button=mbRight then Temp:=RightCol else Exit;
  If bitImage.Image[X,Y]=Temp then Exit;
  SetUndo;
  FillArea(X,Y,bitImage.Image[X,Y],Temp);
  RepaintImage;
 end
 else if btPick.Down then begin
  If not PointInBrick(X,Y) then Exit;
  If Button=mbLeft then LeftCol:=bitImage.Image[X,Y]
  else if Button=mbRight then RightCol:=bitImage.Image[X,Y]
  else Exit;
  If LastTool=1 then btFill.Down:=True
  else btPen.Down:=True;
  pbPalPaint(Sender);
 end;
end;

procedure TEditForm.pbMainMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 If not GetImageCoords(X,Y) then Exit;
 StatusBar1.Panels.Items[0].Text:=Format('%d, %d',[X,Y]);
 If (X>=0) and (X<bitImage.Width) and (Y>=0) and (Y<bitImage.Height) then
  StatusBar1.Panels.Items[1].Text:=Format('Colour index: %d',[bitImage.Image[X,Y]]);
 If MDrawing then begin
  PutPixel(X,Y,ssLeft in Shift,ssRight in Shift,True,False);
 end
 else if MSelecting then begin
  ClearSelection;
  Selection.BottomRight:=Point(X,Y);
  DelimitPoint(Selection.BottomRight,Rect(0,0,bitImage.Width-1,bitImage.Height-1));
  btCopy.Enabled:=(Selection.Left<>Selection.Right) or (Selection.Top<>Selection.Bottom);
  if (Selection.Bottom<>Selection.Top) or (Selection.Left<>Selection.Right) then
   DrawSelection;
 end
 else if SelMoving then begin
  VBPutFragment(bitImage,Selection.Left,Selection.Top,BufBrick1);
  DelimitPoint(X,Y,Rect(Start.X-Selection.Right-1,Start.Y-Selection.Bottom-1,
   Start.X-Selection.Left+bitImage.Width,Start.Y-Selection.Top+bitImage.Height));
  OffsetRect(Selection,X-Start.X,Y-Start.Y);
  BufBrick1:=VBCopyFragment(Selection,bitImage);
  VBPutFragment(bitImage,Selection.Left,Selection.Top,BufBrick2,btTrans.Down,RightCol);
  RepaintImage;
  Start:=Point(X,Y);
 end;
 If btSelect.Down and btCopy.Enabled and PointInRect(Selection,X,Y) then
  pbMain.Cursor:=crSizeAll
 else
  pbMain.Cursor:=crDefault;
end;

procedure TEditForm.pbMainMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 MDrawing:=False;
 If MSelecting and btCopy.Enabled then begin
  Selection:=NormRect(Selection);
  BufBrick2:=VBCopyFragment(Selection,bitImage);
  SetVarBrick(BufBrick1,Selection.Right-Selection.Left+1,Selection.Bottom-Selection.Top+1);
  JustSelected:=True;
 end;
 MSelecting:=False;
 SelMoving:=False;
end;

procedure TEditForm.FormShow(Sender: TObject);
begin
 btSave.Visible:=BrickMode;
 btLoad.Visible:=BrickMode;
 paWarning.Visible:=not BrickMode;
 LastUndo:=0;
 btUndo.Enabled:=False;
 btRedo.Enabled:=False;
 If OptsId>-1 then
  case OptsId of
   0:btZoomClick(Self);
   1:btDispClick(Self);
   2:btOptsClick(Self);
  end;
end;

procedure TEditForm.btUndoClick(Sender: TObject);
begin
 If not btRedo.Enabled then begin
  CopyVarBrick(RedoImage,bitImage);
  FirstRedo:=LastUndo;
 end;
 CopyVarBrick(bitImage,UndoArray[LastUndo]);
 If LastUndo>0 then
  Dec(LastUndo);
 If LastUndo<1 then btUndo.Enabled:=False;
 btRedo.Enabled:=True;
 EnableSelect(False);
 RepaintImage;
end;

procedure TEditForm.btRedoClick(Sender: TObject);
begin
 Inc(LastUndo);
 If LastUndo<FirstRedo then
  CopyVarBrick(bitImage,UndoArray[LastUndo+1])
 else begin
  CopyVarBrick(bitImage,RedoImage);
  btRedo.Enabled:=False;
 end;
 btUndo.Enabled:=True;
 EnableSelect(False);
 RepaintImage;
end;

procedure TEditForm.btPenClick(Sender: TObject);
begin
 ClearSelection;
 If btPen.Down then LastTool:=0
 else if btFill.Down then LastTool:=1;
end;

procedure TEditForm.btTransNClick(Sender: TObject);
begin
 If not btCopy.Enabled then Exit;
 If not JustSelected then VBPutFragment(bitImage,Selection.Left,Selection.Top,BufBrick1);
 VBPutFragment(bitImage,Selection.Left,Selection.Top,BufBrick2,btTrans.Down,RightCol);
 RepaintImage;
end;

function IsIdenticalClipboard: Boolean;
var a, b: Integer;
begin
 Result:= False;
 If Clipboard.HasFormat(CF_BITMAP) then begin
  Buffer.Assign(Clipboard);
  If (Buffer.Width<>CopyBuf.Width) or (Buffer.Height<>CopyBuf.Height) then Exit;
  for b:= 0 to CopyBuf.Height-1 do
   for a:= 0 to CopyBuf.Width-1 do
    If ((CopyBuf.Image[a,b]>0) and (Buffer.Canvas.Pixels[a,b]<>Palette[CopyBuf.Image[a,b]]))
    or ((CopyBuf.Image[a,b]=0) and (Buffer.Canvas.Pixels[a,b]<>CopyTransColour)) then Exit;
 end;
 Result:=True;
end;

function Difference(c1, c2: TColor): DWord;
begin
 //Result:= Abs((c1 and $FF) - (c2 and $FF))
 //       + Abs(((c1 shr 8) and $FF) - ((c2 shr 8) and $FF))
 //       + Abs(((c1 shr 16) and $FF) - ((c2 shr 16) and $FF));
 //Better method:
 Result:= Sqr((c1 and $FF) - (c2 and $FF))
        + Sqr(((c1 shr 8) and $FF) - ((c2 shr 8) and $FF))
        + Sqr(((c1 shr 16) and $FF) - ((c2 shr 16) and $FF));
end;

function FindNearestColour(c: TColor): Byte;
var a: Integer;
    Diff, MinDiff: DWord; 
begin
 Result:= 0;
 MinDiff:= High(DWord);
 for a:= 1 to 255 do begin
   if Palette[a] = c then begin
     Result:= a;
     Exit;
   end else begin
     Diff:= Difference(c, Palette[a]);
     if Diff < MinDiff then begin
       MinDiff:= Diff;
       Result:= a;
     end;
   end;
 end;
end;

procedure TEditForm.btCopyClick(Sender: TObject);
var a, b: Integer;
begin
 Buffer.Width:=Selection.Right-Selection.Left+1;
 Buffer.Height:=Selection.Bottom-Selection.Top+1;
 CopyVarBrick(CopyBuf,BufBrick2);
 CopyTransColour:=Palette[RightCol];
 For b:=0 to Buffer.Height-1 do
  For a:=0 to Buffer.Width-1 do begin
   If BufBrick2.Image[a,b]=0 then Buffer.Canvas.Pixels[a,b]:=CopyTransColour
   else Buffer.Canvas.Pixels[a,b]:=Palette[BufBrick2.Image[a,b]];
  end;
 ClipBoard.Assign(Buffer);
end;

procedure TEditForm.btPasteClick(Sender: TObject);
var a, b: Integer;
begin
 If Clipboard.HasFormat(CF_BITMAP) then begin
  SetUndo;
  btSelect.Down:=True;
  btPenClick(Self);
  Buffer.Assign(Clipboard);
  Selection:=Rect(0,0,Min(Buffer.Width,bitImage.Width)-1,Min(Buffer.Height,bitImage.Height)-1);
  BufBrick1:=VBCopyFragment(Rect(0,0,Selection.Right,Selection.Bottom),bitImage);
  JustSelected:=False;
  if IsIdenticalClipboard then CopyVarBrick(BufBrick2,CopyBuf)
  else begin
    SetVarBrick(BufBrick2,BufBrick1.Width,BufBrick1.Height);
    for b:=0 to Min(Selection.Bottom,bitImage.Height-1) do
      for a:=0 to Min(Selection.Right,bitImage.Width-1) do
        BufBrick2.Image[a,b]:= FindNearestColour(Buffer.Canvas.Pixels[a,b]);
  end;
  VBPutFragment(bitImage,0,0,BufBrick2,btTrans.Down,RightCol);
  btCopy.Enabled:=True;
  RepaintImage;
 end
 else
  MessageBox(Handle,'Clipboard is empty or contains no bitmap','Error',MB_OK+MB_ICONERROR);
end;

procedure TEditForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var a, b: Integer;
begin
 //btZoom.Caption:=IntToStr(Key);
 case Key of
  71: If ssCtrl in Shift then begin  // Ctrl + G (Grid on/off)
       OptForm.cbGrid.Checked:=not OptForm.cbGrid.Checked;
       OptForm.cbGridClick(Sender);
      end;
  187, 107: If OptForm.lbZoom.ItemIndex<9 then begin // + (Zoom in)
             OptForm.lbZoom.ItemIndex:=OptForm.lbZoom.ItemIndex+1;
             OptForm.lbZoomClick(Sender);
            end;
  189, 109: If OptForm.lbZoom.ItemIndex>0 then begin // - (Zoom out)
             OptForm.lbZoom.ItemIndex:=OptForm.lbZoom.ItemIndex-1;
             OptForm.lbZoomClick(Sender);
            end;
  65: If ssCtrl in Shift then begin //Ctrl + A (Select all)
       btSelect.Down:=True;
       btPenClick(Sender);
       Selection:=Rect(0,0,bitImage.Width-1,bitImage.Height-1);
       btCopy.Enabled:=True;
       MSelecting:=True;
       pbMainMouseUp(Sender,mbLeft,[],0,0);
       RepaintImage;
      end;
  67: If ssCtrl in Shift then btCopyClick(Sender); //Ctrl + C (Copy)
  86: If ssCtrl in Shift then btPasteClick(Sender); //Ctrl + V (Paste)
  46, 88: begin   //Del, Ctrl + X
           If (Key=88) and (ssCtrl in Shift) then btCopyClick(Self);
           SetUndo;
           If btCopy.Enabled then begin
            If JustSelected then
             for b:=Max(Selection.Top,0) to Min(Selection.Bottom,bitImage.Height-1) do
              for a:=Max(Selection.Left,0) to Min(Selection.Right,bitimage.Width-1) do
               bitImage.Image[a,b]:=RightCol
            else
             VBPutFragment(bitImage,Selection.Left,Selection.Top,BufBrick1);
            ClearSelection;
           end;
          end;
  90: If ssCtrl in Shift then btUndoClick(Sender); //Ctrl + Z
 end;
end;

procedure TEditForm.FormCreate(Sender: TObject);
begin
 EditForm.DoubleBuffered:=True;
end;

procedure TEditForm.btSaveClick(Sender: TObject);
var a, b: Integer;
    c: TBitBrick;
begin
 If BrickMode then begin
  for b:=0 to 37 do
   for a:=0 to 47 do
    c[a,b]:=bitImage.Image[a,b];
  ExportBrick(c);
 end;
end;

procedure TEditForm.btLoadClick(Sender: TObject);
var S: String;
    f: File;
    a, b: Integer;
    c: TBitBrick;
begin
 If BrickMode then begin
   dlOpen.InitialDir:= LastBrkPath;
   If dlOpen.Execute then begin
     LastBrkPath:= ExtractFilePath(dlOpen.FileName);
     AssignFile(f, dlOpen.FileName);
     FileMode:= fmOpenRead;
     Reset(f, 1);
     SetLength(S, Min(FileSize(f), 1024*1024));
     BlockRead(f, S[1], Length(S));
     CloseFile(f);
     if not BrickToBitBrick(S, c) then
       Application.MessageBox('The Brick file is corrupted!'#13'The unreadable data has been fileld with a two-colour pattern.',
         'LBArchitect', MB_ICONERROR + MB_OK);
     SetUndo();
     for b:= 0 to 37 do
       for a:= 0 to 47 do
         bitImage.Image[a,b]:= c[a,b];
     RepaintImage();
     Beep();
   end;
 end;
end;

procedure TEditForm.btWarningMoreClick(Sender: TObject);
begin
 If Label1.Caption = 'You are creating a new Layout' then
  MessageBox(handle,'You selected to create a new Layout. In this editor you can draw the image of the new Layout (or paste it from a graphic editor program). You don''t have to be afraid that Bricks used by this Layout may be used by another one, because there will '
                   +'be completely new Bricks created for this Layout''s use (of course you will be able to set them to be used by another one).'#13#13'By creating this Layout you will - in addition - create a number of Bricks (depending on size of the Layout), that '
                   +'will be visible on the "Bricks" tab of the main program.','LBArchitect - creating a new Layout',MB_ICONINFORMATION+MB_OK)
 else
  MessageBox(handle,PChar(Label1.Caption+'.'#13'It means that by modifying image of this Layout, you are actually modifying Bricks listed above.'#13#13
                   +'Layout you are editing is NOT an image. Layouts are made of Bricks arranged in a way, and they don''t copy their images, but only tell the program how they are arranged. That''s why Bricks have to be loaded in order to display any Layout. '
                   +'Thus if you draw something on image of the Layout, it is in fact drawn on images of appropriate Bricks.'#13#13'Now the thing is that the Bricks this Layout is made of may be used by another Layout also (not only in current Library). '
                   +'If you edit this Layout image, it is possible that another Layout will appear changed also. To avoid that, edit Layout structure first, making sure no other Layout uses it''s Bricks (to do that you may create new Bricks).'),'LBArchitect - about Layouts and Bricks',MB_ICONINFORMATION+MB_OK);
end;

initialization
 Buffer:= TBitmap.Create;
 Buffer.pixelformat:= pf32bit;
 Buffer.Transparent:= False;
 bufMain:= TBitmap.Create;
 bufMain.pixelformat:= pf32bit;
 bufMain.Transparent:= False;

finalization
 If Assigned(Buffer) then Buffer.Free;
 If Assigned(bufMain) then bufMain.Free;

end.
