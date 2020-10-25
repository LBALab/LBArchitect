unit StructEd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, ImgList, Menus, Engine,
  DePack, MMSystem, DFSClrBn, BetterSpin, Libraries, Utils;

type
  TfmStruct = class(TForm)
    Bevel1: TBevel;
    btAccept: TBitBtn;
    btCancel: TBitBtn;
    pbMain: TPaintBox;
    sbVer: TScrollBar;
    sbHor: TScrollBar;
    btSave: TBitBtn;
    btLoad: TBitBtn;
    StatusBar1: TStatusBar;
    Shapes: TImageList;
    ShapeMenu: TPopupMenu;
    mSolid: TMenuItem;
    gfhghj1: TMenuItem;
    fgsjgfjf1: TMenuItem;
    hfkfsjjgf1: TMenuItem;
    gdfgs1: TMenuItem;
    hfsdgh1: TMenuItem;
    gfjgf1: TMenuItem;
    mfsdf: TMenuItem;
    msdfgdgr: TMenuItem;
    mdtgdg: TMenuItem;
    mdhgg: TMenuItem;
    mstt: TMenuItem;
    mgytaert: TMenuItem;
    gbSelInfo: TGroupBox;
    Timer1: TTimer;
    gbProps: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    cbFloor: TComboBox;
    cbSound: TComboBox;
    btPlay: TBitBtn;
    btOpts: TBitBtn;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    dlSave: TSaveDialog;
    dlOpen: TOpenDialog;
    Image1: TImage;
    paSelInfo: TPageControl;
    TabSheet1: TTabSheet;
    Label11: TLabel;
    TabButtons: TTabSheet;
    TabSheet3: TTabSheet;
    Label4: TLabel;
    Label3: TLabel;
    btShape: TBitBtn;
    btBrick: TBitBtn;
    Label5: TLabel;
    procedure btShapeClick(Sender: TObject);
    procedure mSolidClick(Sender: TObject);
    procedure pbMainPaint(Sender: TObject);
    procedure pbMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure btPlayMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btPlayMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbSoundChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btBrickClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cbShowImgClick(Sender: TObject);
    procedure btOptsClick(Sender: TObject);
    procedure FormConstrainedResize(Sender: TObject; var MinWidth,
      MinHeight, MaxWidth, MaxHeight: Integer);
    procedure FormShow(Sender: TObject);
    procedure cbFloorChange(Sender: TObject);
    procedure seXChange(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure btLoadClick(Sender: TObject);
    procedure pbMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbMainMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btAcceptClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure SetScrolls(ChangeMax: Boolean);
    procedure LoadComboValues(Lba1: Boolean);
    procedure SetShapeImage(Nr: Byte);
    function BlockAtCursor(X, Y: Integer): TPoint3D;
    procedure SetSound();
    procedure HideOpts();
  public
    seX: TfrBetterSpin;
    seY: TfrBetterSpin;
    seZ: TfrBetterSpin;
    procedure ShowStructEditor(Nr: Integer);
    procedure DrawStruct();
    procedure CopyToBuf(x, y, z: Integer; var buffer: TCubeLt);
    procedure SetBrickImage(Nr: Integer);
  end;

var
  fmStruct: TfmStruct;
  OptsId: Integer = -1;
  bufMain: TBitmap;

  LtX, LtY, LtZ: Byte;
  LtImg: TCubeLt;
  StrSelect: TBox;
  AreaSelecting: Boolean = False;
  AreaMoving: Boolean = False;
  MoveStart: TPoint3d;
  buff1, buff2: TCubeLt;

  Loading: Boolean = False;
  Sound1, Sound2, SoundCnt: Byte;

implementation

uses Main, Layouts, Bricks, BrkTable, OptPanel, Math;

var bmpBrk, bmpShape: TBitmap;

{$R *.dfm}
{$R samples.res}

procedure TfmStruct.FormCreate(Sender: TObject);
begin
 seX:= TfrBetterSpin.Create(Self);
 seX.Name:= 'seX';  seX.Parent:= gbProps;  seX.TabOrder:= 0;
 seX.SetBounds(109, 13, 41, 22);
 seX.Color:= $FFBE00;
 seX.Setup(1, 64, 1);  seX.OnChange:= seXChange;
 seY:= TfrBetterSpin.Create(Self);
 seY.Name:= 'seY';  seY.Parent:= gbProps;  seY.TabOrder:= 1;
 seY.SetBounds(109, 36, 41, 22);
 seY.Color:= clYellow;
 seY.Setup(1, 24, 1);  seY.OnChange:= seXChange;
 seZ:= TfrBetterSpin.Create(Self);
 seZ.Name:= 'seZ';  seZ.Parent:= gbProps;  seZ.TabOrder:= 2;
 seZ.SetBounds(109, 58, 41, 22);
 seZ.Color:= clLime;
 seZ.Setup(1, 64, 1);  seY.OnChange:= seXChange;

 ShapeMenu.Alignment:= paCenter;
 DoubleBuffered:= True;

 bmpBrk:= TBitmap.Create();
 bmpBrk.PixelFormat:= pf32bit;
 bmpBrk.TransparentMode:= tmFixed;
 bmpBrk.TransparentColor:= clFuchsia;
 bmpBrk.Width:= 48;
 bmpBrk.Height:= 38;
 bmpShape:= TBitmap.Create();
 bmpShape.Width:= 51;
 bmpShape.Height:= 42;
end;

procedure TfmStruct.SetScrolls(ChangeMax: Boolean);
begin
 sbHor.Position:= 0;
 sbVer.Position:= 0;
 sbHor.Enabled:= (LtX+LtZ)*48 > pbMain.Width - 1;
 If sbHor.Enabled then begin
   If ChangeMax then sbHor.Max:= (LtX+LtZ)*48;
   sbHor.PageSize:= pbMain.Width;
 end;
 sbVer.Enabled:= LtY*30+(LtX+LtZ)*24 > pbMain.Height - 1;
 If sbVer.Enabled then begin
   If ChangeMax then sbVer.Max:= LtY*30+(LtX+LtZ)*24;
   sbVer.PageSize:= pbMain.Height;
 end;
end;

Procedure FFrameL(x, y: Integer; dest: TCanvas; col: TColor);
begin
 dest.Pen.Color:=Col;
 dest.Pen.Style:=psDot;
 dest.PolyLine([Point(X+48,Y-1),Point(X+48,Y+29),Point(X+96,Y+53)]);
 dest.PolyLine([Point(X+48,Y+29),Point(X,Y+53)]);

 dest.PolyLine([Point(X,Y+23),Point(X,Y+53),Point(X+48,Y+77),Point(X+48,Y+47),
  Point(X,Y+23),Point(X+48,Y-1),Point(X+96,Y+23),Point(X+48,Y+47)]);
 dest.PolyLine([Point(X+48,Y+77),Point(X+96,Y+53),Point(X+96,Y+23)]);
 dest.Pen.Style:=psSolid;
end;

Procedure PFrameL(x, y: Integer; dest: TCanvas; col: TColor; sTop, sLeft, sRight: Boolean);
begin
 dest.Pen.Color:=Col;
 dest.Brush.Style:=bsClear;
 If sTop then dest.Polygon([Point(X,Y+23),Point(X+48,Y-1),Point(X+96,Y+23),Point(X+48,Y+47)]);
 If sLeft then dest.Polygon([Point(X,Y+23),Point(X+48,Y+47),Point(X+48,Y+77),Point(X,Y+53)]);
 If sRight then dest.Polygon([Point(X+48,Y+47),Point(X+96,Y+23),Point(X+96,Y+53),Point(X+48,Y+77)]);
 dest.Brush.Style:=bsSolid;
end;

Procedure BackFrameL(x, y: Integer; dest: TCanvas);
begin
 dest.Pen.Color:=clMedGray;
 dest.Pen.Style:=psDot;
 dest.Polyline([Point(x,LtZ*24+LtY*30+y),Point(LtZ*48+x,LtY*30+y),Point((LtZ+LtX)*48+x,LtX*24+LtY*30+y)]);
 dest.Polyline([Point(LtZ*48+x,LtY*30+y),Point(LtZ*48+x,y)]);
end;

{Procedure FrameL(x, y: Integer; dest: TCanvas; col: TColor);
var a: Integer;
begin
 dest.Pen.Color:=Col;
 dest.Pen.Style:=psSolid;
 for a:=0 to LtX do
  dest.Polyline([Point(a*48+x,(a+LtZ)*24+LtY*30+y),Point(a*48+x,(LtZ+a)*24+y),Point((LtZ+a)*48+x,a*24+y)]);
 for a:=0 to LtZ do
  dest.Polyline([Point((LtX+a)*48+x,(LtX+LtZ-a)*24+LtY*30+y),Point((LtX+a)*48+x,(LtX+LtZ-a)*24+y),Point(a*48+x,(LtZ-a)*24+y)]);
 for a:=1 to LtY do
  dest.Polyline([Point(x,LtZ*24+a*30+y),Point(LtX*48+x,(LtX+LtZ)*24+a*30+y),Point((LtZ+LtX)*48+x,LtX*24+a*30+y)]);
end;}

Procedure BigSBFrame(X, Y: Integer; C: TCanvas; Col: TColor; Shape: Byte);
begin
 C.Pen.Color:=Col;
 C.Pen.Style:=psDot;
 C.PolyLine([Point(X,Y+53),Point(X+48,Y+29),Point(X+96,Y+52)]);
 case Shape of
  01,04,05,07,08,09,11: C.PolyLine([Point(X+48,Y-1),Point(X+48,Y+29)]);
  02,12: C.Polyline([Point(X+48,Y+29),Point(X+96,Y+23)]);
  03,13: C.Polyline([Point(X+48,Y+29),Point(X,Y+23)]);
  06: C.Polyline([Point(X+96,Y+23),Point(X+48,Y+29),Point(X,Y+23)]);
 end;
end;

Procedure BigSFFrame(X, Y: Integer; C: TCanvas; Col: TColor; Shape: Byte);
begin
 C.Pen.Color:=Col;
 C.Pen.Style:=psDot;
 C.Brush.Style:=bsClear;
 case Shape of
  02,12: C.Polyline([Point(X+48,Y+29),Point(X+96,Y+23)]);
  03,13: C.Polyline([Point(X+48,Y+29),Point(X,Y+23)]);
  06: C.Polyline([Point(X+96,Y+23),Point(X+48,Y+29),Point(X,Y+23)]);
 end;

 C.Pen.Style:=psSolid;
 If (Shape=1) or (Shape=6) or (Shape=8) or (Shape=9) then C.Polyline([Point(X+48,Y+77),Point(X+48,Y+47)]);
 case Shape of
  01: C.Polyline([Point(X,Y+23),Point(X+48,Y+47),Point(X+96,Y+23),Point(X+48,Y-1),Point(X,Y+23),Point(X,Y+53),Point(X+48,Y+77),Point(X+96,Y+53),Point(X+96,Y+23)]);
  02: C.Polyline([Point(X+48,Y+77),Point(X+48,Y+47),Point(X,Y+53),Point(X+48,Y+77),Point(X+96,Y+53),Point(X+96,Y+23),Point(X+48,Y+47)]);
  03: C.Polyline([Point(X+48,Y+77),Point(X+48,Y+47),Point(X+96,Y+53),Point(X+48,Y+77),Point(X,Y+53),Point(X,Y+23),Point(X+48,Y+47)]);
  04: C.Polyline([Point(X+48,Y+77),Point(X,Y+53),Point(X+48,Y-1),Point(X+96,Y+23),Point(X+48,Y+77),Point(X+96,Y+53),Point(X+96,Y+23)]);
  05: C.Polyline([Point(X+48,Y+77),Point(X+96,Y+53),Point(X+48,Y-1),Point(X,Y+23),Point(X+48,Y+77),Point(X,Y+53),Point(X,Y+23)]);
  06: C.Polyline([Point(X,Y+53),Point(X,Y+23),Point(X+48,Y+47),Point(X+96,Y+23),Point(X+96,Y+53),Point(X+48,Y+77),Point(X,Y+53)]);
  07: C.Polyline([Point(X,Y+23),Point(X,Y+53),Point(X+48,Y+77),Point(X,Y+23),Point(X+48,Y-1),Point(X+96,Y+23),Point(X+48,Y+77),Point(X+96,Y+53),Point(X+96,Y+23)]);
  08: C.Polyline([Point(X,Y+53),Point(X+48,Y-1),Point(X+96,Y+23),Point(X+48,Y+47),Point(X,Y+53),Point(X+48,Y+77),Point(X+96,Y+53),Point(X+96,Y+23)]);
  09: C.Polyline([Point(X+96,Y+53),Point(X+48,Y-1),Point(X,Y+23),Point(X+48,Y+47),Point(X+96,Y+53),Point(X+48,Y+77),Point(X,Y+53),Point(X,Y+23)]);
  10: C.Polyline([Point(X+48,Y+77),Point(X+48,Y+47),Point(X,Y+53),Point(X+48,Y+77),Point(X+96,Y+53),Point(X+48,Y+47)]);
  11: C.Polyline([Point(X+48,Y+77),Point(X,Y+53),Point(X+48,Y-1),Point(X+96,Y+53),Point(X+48,Y+77)]);
  12: C.Polyline([Point(X,Y+53),Point(X+48,Y+77),Point(X+96,Y+53),Point(X+96,Y+23),Point(X+48,Y+77)]);
  13: C.Polyline([Point(X+96,Y+53),Point(X+48,Y+77),Point(X,Y+53),Point(X,Y+23),Point(X+48,Y+77)]);
 end;
 C.Brush.Style:=bsSolid;
end;

procedure BlockToPosVar(X, Y, Z, pX, pY: Integer; var rX, rY: Integer);
begin
 rX:=(X-Z)*48+pX;
 rY:=(X+Z)*24-Y*30+pY
end;

procedure DrawBigBrick(x, y, Nr: Integer; dest: TCanvas);
var a, b: Byte;
begin
 If Nr>BrkCount-1 then Exit;
 If not Buffered[nr] then BufferBrick(nr);
 for b:=0 to 37 do
  for a:=0 to 47 do
   If bitBuffers[Nr][a,b]>0 then begin
    dest.Brush.Color:=Palette[bitBuffers[Nr][a,b]];
    dest.FrameRect(Bounds(a*2+x,b*2+y,2,2));
   end;
end;

procedure TfmStruct.DrawStruct();
var a, b, c, offX, offY, rX, rY, tW, tH, x, y: Integer;
    BrkIndex: Word;
    snr: String;
    shape, image, frames: Boolean;
    temp: TBox;
begin
 If (LtX=0) or (LtY=0) or (LtZ=0) then Exit;
 x:= sbHor.Position;
 y:= sbVer.Position;
 shape:= OptForm.cbShape.Checked;
 image:= OptForm.cbShowImg.Checked;
 frames:= OptForm.cbFrames.Checked;

 offX:= (LtZ-1)*48-x;
 offY:= (LtY-1)*30+1-y;

 bufMain.Canvas.Brush.Color:= clBtnFace;
 bufMain.Canvas.FillRect(bufMain.Canvas.ClipRect);

 BackFrameL(-x,-y,bufMain.Canvas);

 If OptForm.cbShape.Checked then
  for c:=0 to LtZ-1 do
   for b:=0 to LtY-1 do
    for a:=0 to LtX-1 do begin
     BlockToPosVar(a,b,c,offX,offY,rX,rY);
     BigSBFrame(rX,rY,bufMain.Canvas,clYellow,LtImg.Map[a,b,c].Shape);
    end;

 If StrSelect.x1>-1000 then begin
  temp:=NormalBox(StrSelect);
  for c:=Max(temp.z1,0) to Min(temp.z2,LtZ-1) do
   for b:=Max(temp.y1,0) to Min(temp.y2,LtY-1) do
    for a:=Max(temp.x1,0) to Min(temp.x2,LtX-1) do begin
     BlockToPosVar(a,b,c,offX,offY,rX,rY);
     FFrameL(rX,rY,bufMain.Canvas,OptForm.cbSelect.Color);
    end;
 end;

 bufMain.Canvas.Pen.Style:=psSolid;

 for c:=0 to LtZ-1 do
  for b:=0 to LtY-1 do
   for a:=0 to LtX-1 do begin
    BrkIndex:=LtImg.Map[a,b,c].Index;
    BlockToPosVar(a,b,c,offX,offY,rX,rY);
    If (BrkIndex>0) and image then
     DrawBigBrick(rX,rY,LtImg.Map[a,b,c].Index-1,bufMain.Canvas);
    If (b=LtY-1) or (c=LtZ-1) or (a=LtX-1) then begin
     If frames then PFrameL(rX,rY,bufMain.Canvas,clWhite,b=LtY-1,c=LtZ-1,a=LtX-1);
     If shape then BigSFFrame(rX,rY,bufMain.Canvas,clYellow,LtImg.Map[a,b,c].Shape);
    end;
   end;

 bufMain.Canvas.Brush.Color:=clWhite;

 If StrSelect.x1>-1000 then
  for c:=Max(temp.z1,0) to Min(temp.z2,LtZ-1) do
   for b:=Max(temp.y1,0) to Min(temp.y2,LtY-1) do
    for a:=Max(temp.x1,0) to Min(temp.x2,LtX-1) do begin
     BlockToPosVar(a,b,c,offX,offY,rX,rY);
     PFrameL(rX,rY,bufMain.Canvas,OptForm.cbSelect.Color,b=LtY-1,
      c=LtZ-1,a=LtX-1);
    end;

 If OptForm.cbIndexes.Checked then
  for c:=0 to LtZ-1 do
   for b:=0 to LtY-1 do
    for a:=0 to LtX-1 do begin
     BrkIndex:=LtImg.Map[a,b,c].Index;
     If (a=LtX-1) or (b=LtY-1) or (c=LtZ-1) then begin
      BlockToPosVar(a,b,c,offX,offY,rX,rY);

      snr:=IntToStr(BrkIndex);
      tW:=bufMain.Canvas.TextWidth(snr) div 2;
      tH:=bufMain.Canvas.TextHeight(snr) div 2;

      If a=LtX-1 then begin
       If b=LtY-1 then begin
        If c=LtZ-1 then bufMain.Canvas.TextOut(rX+48-tW,rY+42-tH,snr)
        else bufMain.Canvas.TextOut(rX+72-tW,rY+35-tH,snr);
       end
       else if c=LtZ-1 then bufMain.Canvas.TextOut(rX+48-tW,rY+56-tH,snr)
       else bufMain.Canvas.TextOut(rX+72-tW,rY+49-tH,snr);
      end
      else if b=LtY-1 then begin
       If c=LtZ-1 then bufMain.Canvas.TextOut(rX+24-tW,rY+35-tH,snr)
       else bufMain.Canvas.TextOut(rX+48-tW,rY+22-tH,snr);
      end
      else if c=LtZ-1 then bufMain.Canvas.TextOut(rX+24-tW,rY+49-tH,snr);

     end;
    //If Form1.cbShapes.Checked then ShapeBFrame(rX,rY,dest,clYellow,Layout.Map[a].Shape);
    //BackFrameL(rX,rY,dest);//If Form1.cbShapes.Checked then ShapeFFrame(rX,rY,dest,clYellow,Layout.Map[a].Shape);
   //end;
    end;
 UpdateImage(bufMain, pbMain);
end;

procedure TfmStruct.LoadComboValues(Lba1: Boolean);
begin
 If Lba1 then begin
  Label1.Caption:= 'Sound #2:';
  Label2.Caption:= 'Sound #1:';
  cbFloor.Clear();
  cbFloor.Items.SetText('0: Floor'#13'1: Carpet'#13'2: Metal'#13'3: Wood'#13
    +'4: Snow'#13'5: Stone (N)'#13'6: Sand'#13'7: Wet floor'#13'8: Grass'#13
    +'9: Flower (uhms!)'#13'A: In a cave'#13'B: Rubber/Platform'#13'C: Water (very wet floor)');
  cbSound.Clear();
  cbSound.Items.AddStrings(cbFloor.Items);
  cbSound.Items.Add('F0: No sound');
  cbSound.Items.Add('F1: Water (D)');
 end
 else begin
  Label1.Caption:= 'Floor type:';
  Label2.Caption:= 'Sound:';
  cbFloor.Clear();
  cbFloor.Items.SetText('0: Normal floor'#13'1: Water (D)'#13
    +'2: Shooting floor (D N)'#13'3: Conveyor belt -> top left'#13
    +'4: Conveyor belt -> btm right'#13'5: Conveyor belt -> top right'#13
    +'6: Conveyor belt -> btm left'#13'7: Normal (used for the Dome)'#13'8: Normal (used for spikes)'#13
    +'9: Lava (D)'#13'A: Normal floor (N)'#13'B: Gas (D)');
  cbSound.Clear();
  cbSound.Items.SetText('0: No sound'#13'1: Floor'#13'2: Floor (same as 1)'#13
    +'3: Wood 1'#13'4: Sand'#13'5: In a cave 1'#13'6: Metal'#13'7: In a cave 2'#13
    +'8: Carpet'#13'9: Flower (uhms!)'#13'A: Wood 2'#13'B: Wet floor'#13'C: Metal (same as 6)'#13
    +'D: In a cave 3');
 end;
end;

procedure TfmStruct.ShowStructEditor(Nr: Integer);
var a, b, c, NewBrk: Integer;
begin
 Loading:= True;
 LtImg:= CopyLayout(Lib[Nr]);
 LtX:= LtImg.X;
 LtY:= LtImg.Y;
 LtZ:= LtImg.Z;
 seX.Value:= LtX;
 seY.Value:= LtY;
 seZ.Value:= LtZ;
 StrSelect.x1:= -1000;
 paSelInfo.ActivePageIndex:= 0;
 gbSelInfo.Caption:= 'Selected block:';
 LoadComboValues(LLba1);
 If LtImg.Map[0,0,0].Sound > $EE then begin
   cbSound.ItemIndex:= LtImg.Map[0,0,0].Sound - $F0 + 13;
   cbSoundChange(Self);
 end
 else begin
   cbFloor.ItemIndex:= (LtImg.Map[0,0,0].Sound shr 4) and $0F;
   cbSound.ItemIndex:= LtImg.Map[0,0,0].Sound and $0F;
 end;
 Loading:= False;
 SetScrolls(True);
 sbVer.Position:= 0;
 sbHor.Position:= 0;
 Caption:= 'Structure Editor - Layout #' + IntToStr(Nr+1);
 DrawStruct();
 If ShowModal = mrOK then begin
   Lib[Nr]:= CopyLayout(LtImg);

   NewBrk:= 0;
   for c:= 0 to Lib[Nr].Z - 1 do
     for b:= 0 to Lib[Nr].Y - 1 do
       for a:= 0 to Lib[Nr].X - 1 do
         If Lib[Nr].Map[a,b,c].Index = 65535 then begin
           Inc(NewBrk);
           Lib[Nr].Map[a,b,c].Index:= BrkCount + NewBrk;
         end;
   b:= CreateBricks(NewBrk);
   for a:= b to BrkCount - 1 do
     VBricks[BrkOffset+a]:= PackEntry(#01#01#23#18#01#00);

   RefreshLayouts(Nr, NewBrk>0);
 end;
end;

procedure TfmStruct.btShapeClick(Sender: TObject);
var p: TPoint;
begin
 p:=TabButtons.ClientToScreen(Point(btShape.Left+(btShape.Width div 2),btShape.Top+btShape.Height));
 ShapeMenu.Popup(p.x,p.y);
end;

procedure TfmStruct.SetShapeImage(Nr: Byte);
begin
 btShape.Glyph.Assign(nil); //Delete the glyph
 btShape.Caption:= '';
 if Nr = $FF then
   btShape.Caption:='Multiselect'
 else if (Nr = 0) or (Nr > $0D) then
   btShape.Caption:= 'Unknown'#13'shape value'#13'(' + IntToHex(Nr,2) + 'h)'
 else begin
   bmpShape.Canvas.Brush.Color:= clBtnFace;
   bmpShape.Canvas.FillRect(Rect(0,0,51,42));
   Shapes.Draw(bmpShape.Canvas, 0, 0, Nr-1);
   btShape.Glyph.Assign(bmpShape);
 end;
end;

procedure TfmStruct.SetBrickImage(Nr: Integer);
begin
 btBrick.Glyph.Assign(nil); //Delete the glyph
 btBrick.Caption:= '';
 btBrick.Hint:= '';
 If Nr = 65535 then begin
   Label4.Caption:= 'Brick:';
   btBrick.Caption:= 'Temporary'#13'empty';
   btBrick.Hint:= 'If you don''t set any Brick here,'#13'a new empty Brick will be created for this block.';
 end
 else if Nr = -1 then begin
   Label4.Caption:= 'Brick:';
   btBrick.Caption:= 'Multiselect';
 end
 else begin
   Label4.Caption:= 'Brick: ' + IntToStr(Nr);
   Dec(Nr);
   If Nr = -1 then begin
     btBrick.Caption:= 'None';
     btBrick.Hint:= 'No Brick is assigned to this block,'#13'so it won''t be able to contain an image.';
   end
   else if Nr > BrkCount - 1 then
     btBrick.Caption:= 'Brick index'#13'exceeds'#13'maximum'
   else begin
     //DrawBrick(0, 0, Nr, bmpBrk, False, False);
     bmpBrk.Canvas.Brush.Color:= clBtnFace;
     bmpBrk.Canvas.FillRect(Rect(0,0,48,38));
     DrawBrick(0, 0, Nr, bmpBrk, False, False);
     btBrick.Glyph.Assign(bmpBrk);
   end;
 end;
end;

procedure TfmStruct.mSolidClick(Sender: TObject);
var a, b, c, d: Integer;
begin
 d:=(Sender as TMenuItem).ImageIndex+1;
 for c:=StrSelect.z1 to StrSelect.z2 do
  for b:=StrSelect.y1 to StrSelect.y2 do
   for a:=StrSelect.x1 to StrSelect.x2 do
    LtImg.Map[a,b,c].Shape:=d;
 SetShapeImage(d);
 DrawStruct;
end;

procedure TfmStruct.pbMainPaint(Sender: TObject);
begin
 UpdateImage(bufMain,pbMain);
end;

function TfmStruct.BlockAtCursor(X, Y: Integer): TPoint3D;
var a, b, c, offX, offY, rX, rY: Integer;
begin
 Result.x:= -1000;
 offX:= (LtZ-1)*48 - sbHor.Position;
 offY:= (LtY-1)*30+1 - sbVer.Position;
 for c:= 0 to LtZ - 1 do
  for b:= 0 to LtY - 1 do
   for a:= 0 to LtX - 1 do begin
    If (a = LtX-1) or (b = LtY-1) or (c = LtZ-1) then begin
     BlockToPosVar(a, b, c, offX, offY, rX, rY);
     If InsideBrick((X-rX) div 2,(Y-rY) div 2,b=LtY-1,c=LtZ-1,a=LtX-1) then begin
      Result.x:= a;
      Result.y:= b;
      Result.z:= c;
      Exit;
     end;
    end;
   end;
end;

function InsideLayout(Pos: TPoint3d): Boolean;
begin
 Result := (Pos.x>=0) and (Pos.x<LtX)//High(LtImg.Map))
       and (Pos.y>=0) and (Pos.y<LtY)//High(LtImg.Map[0]))
       and (Pos.z>=0) and (Pos.z<LtZ)//High(LtImg.Map[0,0]));
end;

procedure TfmStruct.CopyToBuf(x, y, z: Integer; var buffer: TCubeLt);
var a, b, c: Integer;
begin
 buffer.X:= StrSelect.x2-StrSelect.x1+1;
 buffer.Y:= StrSelect.y2-StrSelect.y1+1;
 buffer.Z:= StrSelect.z2-StrSelect.z1+1;
 SetLength(buffer.Map,buffer.X,buffer.Y,buffer.Z);
 for c:= Max(0,-z) to Min(buffer.Z-1,LtZ-z-1) do
  for b:= Max(0,-y) to Min(buffer.Y-1,LtY-y-1) do
   for a:= Max(0,-x) to Min(buffer.X-1,LtX-x-1) do
    buffer.Map[a,b,c]:= LtImg.Map[x+a,y+b,z+c];
end;

procedure PasteFromBuf(x, y, z: Integer; buffer: TCubeLt);
var a, b, c: Integer;
begin
 for c:=Max(0,-z) to Min(buffer.Z-1,LtZ-z-1) do
  for b:=Max(0,-y) to Min(buffer.Y-1,LtY-y-1) do
   for a:=Max(0,-x) to Min(buffer.X-1,LtX-x-1) do
    LtImg.Map[x+a,y+b,z+c]:=buffer.Map[a,b,c];
end;
{
procedure ClearBuff(var buffer: TCubeLt);
var a, b, c: Integer;
begin
 buffer.X:=StrSelect.x2-StrSelect.x1;
 buffer.Y:=StrSelect.y2-StrSelect.y1;
 buffer.Z:=StrSelect.z2-StrSelect.z1;
 SetLength(buffer.Map,buffer.X,buffer.Y,buffer.Z);
 for c:=0 to buffer.Z-1 do
  for b:=0 to buffer.Y-1 do
   for a:=0 to buffer.X-1 do begin
    buffer.Map[a,b,c].Index:=0;
    buffer.Map[a,b,c].Shape:=1;
    buffer.Map[a,b,c].Sound:=IfThen(LLba1,$F0,0);
   end;
end;
}
procedure TfmStruct.pbMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var NewSel: TPoint3d;
begin
 NewSel:= BlockAtCursor(X, Y);
 If (StrSelect.x1 > -1000) and InsideLayout(NewSel)
 and BoxContains(NormalBox(StrSelect), NewSel) then begin
   AreaMoving:= true;
   MoveStart:= NewSel;
 end
 else begin
   StrSelect.x2:= StrSelect.x1;
   If (NewSel.x <= -1000) or InsideLayout(NewSel) then begin
     StrSelect:= BoxPoint(NewSel.x, NewSel.y, NewSel.z);
     paSelInfo.ActivePageIndex:= IfThen(StrSelect.x1 > -1, 1, 0);
     If StrSelect.x1 > -1000 then begin
       SetBrickImage(LtImg.Map[StrSelect.x1,StrSelect.y1,StrSelect.z1].Index);
       SetShapeImage(LtImg.Map[StrSelect.x1,StrSelect.y1,StrSelect.z1].Shape);
       gbSelInfo.Caption:= Format('Selected block: %d [%d, %d, %d]',
         [StrSelect.x1+StrSelect.y1*LtX+StrSelect.z1*LtY*LtX,StrSelect.x1,StrSelect.y1,StrSelect.z1]);
      AreaSelecting:= (LtX > 1) or (LtY > 1) or (LtZ > 1);
     end
     else gbSelInfo.Caption:= 'Selected block:';
     DrawStruct();
   end;
 end;
end;

function Identical(Index: Boolean): Boolean;
var a, b, c: Integer;
    temp: TBox;
begin
 temp:=NormalBox(StrSelect);
 Result:=False;
 for c:=temp.z1 to temp.z2 do
  for b:=temp.y1 to temp.y2 do
   for a:=temp.x1 to temp.x2 do
    If (Index and (LtImg.Map[a,b,c].Index<>LtImg.Map[temp.x1,temp.y1,temp.z1].Index))
    or (not Index and (LtImg.Map[a,b,c].Shape<>LtImg.Map[temp.x1,temp.y1,temp.z1].Shape)) then Exit;
 Result:=True;
end;

procedure TfmStruct.pbMainMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var NewBlock: TPoint3d;
begin
 NewBlock:=BlockAtCursor(X,Y);
 If InsideLayout(NewBlock) then begin
  If AreaSelecting then begin
   If ((NewBlock.x<>StrSelect.x2) or (NewBlock.y<>StrSelect.y2) or (NewBlock.z<>StrSelect.z2)) then begin
    StrSelect.x2:=NewBlock.x;
    StrSelect.y2:=NewBlock.y;
    StrSelect.z2:=NewBlock.z;
    If BoxIsPoint(StrSelect) then paSelInfo.ActivePageIndex:=1
    else begin
     If ((StrSelect.x1=StrSelect.x2) and (StrSelect.x1=LtX-1))
     or ((StrSelect.y1=StrSelect.y2) and (StrSelect.y1=LtY-1))
     or ((StrSelect.z1=StrSelect.z2) and (StrSelect.z1=LtZ-1)) then begin
      paSelInfo.ActivePageIndex:=1;
      If Identical(True) then
       SetBrickImage(LtImg.Map[StrSelect.x1,StrSelect.y1,StrSelect.z1].Index)
      else SetBrickImage(-1);
      If Identical(False) then
       SetShapeImage(LtImg.Map[StrSelect.x1,StrSelect.y1,StrSelect.z1].Shape)
      else SetShapeImage($FF);
     end
     else paSelInfo.ActivePageIndex:=2;
     gbSelInfo.Caption:='Selected blocks:';
    end;
    DrawStruct;
   end;
  end
  else begin
   If (StrSelect.x1>-1000) and BoxContains(NormalBox(StrSelect),NewBlock) then
    pbMain.Cursor:=crSizeAll
   else pbMain.Cursor:=crDefault;
   If AreaMoving and ((NewBlock.x<>MoveStart.x) or (NewBlock.y<>MoveStart.y)
   or (NewBlock.z<>MoveStart.z)) then begin
    PasteFromBuf(StrSelect.x1,StrSelect.y1,StrSelect.z1,buff1);
    If (NewBlock.x<>MoveStart.x)
    and (((StrSelect.y1=StrSelect.y2) and (StrSelect.y1=LtY-1))
    or ((StrSelect.z1=StrSelect.z2) and (StrSelect.z1=LtZ-1))) then begin
     Inc(StrSelect.x1,NewBlock.x-MoveStart.x);
     Inc(StrSelect.x2,NewBlock.x-MoveStart.x);
     MoveStart.x:=NewBlock.x;
    end;
    If (NewBlock.y<>MoveStart.y)
    and (((StrSelect.x1=StrSelect.x2) and (StrSelect.x1=LtX-1))
    or ((StrSelect.z1=StrSelect.z2) and (StrSelect.z1=LtZ-1))) then begin
     Inc(StrSelect.y1,NewBlock.y-MoveStart.y);
     Inc(StrSelect.y2,NewBlock.y-MoveStart.y);
     MoveStart.y:=NewBlock.y;
    end;
    If (NewBlock.z<>MoveStart.z)
    and (((StrSelect.x1=StrSelect.x2) and (StrSelect.x1=LtX-1))
    or ((StrSelect.y1=StrSelect.y2) and (StrSelect.y1=LtY-1))) then begin
     Inc(StrSelect.z1,NewBlock.z-MoveStart.z);
     Inc(StrSelect.z2,NewBlock.z-MoveStart.z);
     MoveStart.z:=NewBlock.z;
    end;
    CopyToBuf(StrSelect.x1,StrSelect.y1,StrSelect.z1,buff1);
    PasteFromBuf(StrSelect.x1,StrSelect.y1,StrSelect.z1,buff2);
    DrawStruct;
   end;
  end;
 end
 else pbMain.Cursor:=crDefault;
end;

procedure TfmStruct.pbMainMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 If AreaSelecting then begin
  StrSelect:=NormalBox(StrSelect);
  CopyToBuf(StrSelect.x1,StrSelect.y1,StrSelect.z1,buff1);
  CopyToBuf(StrSelect.x1,StrSelect.y1,StrSelect.z1,buff2);
 end;
 AreaSelecting:=false;
 AreaMoving:=false;
end;

procedure PlaySample;
var snd, cnt, ver: Byte;
begin
 If Odd(SoundCnt) then snd:=Sound1 else snd:=Sound2;
 If LLba1 then ver:=1 else ver:=2;
 If Sound1=Sound2 then cnt:=SoundCnt mod 2 else cnt:=1;
 PlaySound(PChar(Format('SAMPLE_%d_%x_%d',[ver,snd,cnt])), hInstance, SND_RESOURCE + SND_ASYNC + SND_NOWAIT);
 Inc(SoundCnt);
end;

procedure TfmStruct.Timer1Timer(Sender: TObject);
begin
 PlaySample();
end;

procedure TfmStruct.btPlayMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 If Button= mbLeft then begin
  Sound2:= cbSound.ItemIndex;
  If LLba1 then Sound1:= cbFloor.ItemIndex else Sound1:= Sound2;
  PlaySample();
  Timer1.Enabled:= True;
 end;
end;

procedure TfmStruct.btPlayMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 Timer1.Enabled:= False;
end;

procedure TfmStruct.SetSound();
var id1, id2, snd: Byte;
    a, b, c: Integer;
begin
 id2:= cbSound.ItemIndex;
 id1:= Max(cbFloor.ItemIndex, 0);
 If not LLba1 or (id2<=12) then snd:= ((id1 shl 4) and $F0) + (id2 and $0F)
 else snd:= $F0 + ((id2-13) and $0F);
 for c:= 0 to LtImg.Z - 1 do
   for b:= 0 to LtImg.Y - 1 do
     for a:= 0 to LtImg.X - 1 do
      LtImg.Map[a,b,c].Sound:= snd;
end;

procedure TfmStruct.cbSoundChange(Sender: TObject);
begin
 If LLba1 then begin
  cbFloor.Enabled:=cbSound.ItemIndex<=12;
  If cbFloor.Enabled then cbFloor.ItemIndex:=cbSound.ItemIndex
  else cbFloor.ItemIndex:=-1;
  btPlay.Enabled:=cbFloor.Enabled;
 end;
 SetSound;
end;

procedure TfmStruct.FormDestroy(Sender: TObject);
begin
 FreeAndNil(bmpBrk);
 FreeAndNil(bmpShape);
end;

procedure TfmStruct.btBrickClick(Sender: TObject);
var p: TPoint;
begin
 If (StrSelect.x1 <= -1000) or (StrSelect.x1>High(LtImg.Map)) then Exit;
 p:=TabButtons.ClientToScreen(Point(btBrick.Left+(btBrick.Width div 2),btBrick.Top+btBrick.Height));
 BrkSel:=LtImg.Map[StrSelect.x1,StrSelect.y1,StrSelect.z1].Index-1;
 TableForm.Popup(p.x,p.y);
end;

procedure TfmStruct.FormResize(Sender: TObject);
begin
 SetDimensions(bufMain,pbMain.Width,pbMain.Height);
 SetScrolls(False);
 DrawStruct;
end;

procedure TfmStruct.cbShowImgClick(Sender: TObject);
begin
 DrawStruct;
end;

procedure TfmStruct.HideOpts();
begin
 OptForm.HidePanel();
 btOpts.Glyph.LoadFromResourceName(0,'AR_RIGHT');
end;

procedure TfmStruct.btOptsClick(Sender: TObject);
begin
 If not OptForm.Visible or (OptForm.pcOpts.ActivePageIndex <> 3) then begin
  If OptForm.Visible then HideOpts();
  OptForm.ShowPanel(Left+Width, Top, 3);
  btOpts.Glyph.LoadFromResourceName(0, 'AR_LEFT');
 end else HideOpts();
end;

procedure TfmStruct.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Timer1.Enabled:=False;
 If OptForm.Visible then OptsId:=OptForm.pcOpts.ActivePageIndex else OptsId:=-1;
 HideOpts;
end;

procedure TfmStruct.FormConstrainedResize(Sender: TObject; var MinWidth,
  MinHeight, MaxWidth, MaxHeight: Integer);
begin
 OptForm.Left:= Left + Width;
 OptForm.Top:= Top;
end;

procedure TfmStruct.FormShow(Sender: TObject);
begin
 If OptsId > -1 then btOptsClick(Self);
end;

procedure TfmStruct.cbFloorChange(Sender: TObject);
begin
 SetSound();
end;

procedure TfmStruct.seXChange(Sender: TObject);
var a, b, c, dX, dY, dZ: Integer;
    temp: TCubeLt;
begin
 If Loading then Exit;
 LtX:= seX.ReadValueDef(LtImg.X);
 LtY:= seY.ReadValueDef(LtImg.Y);
 LtZ:= seZ.ReadValueDef(LtImg.Z);
 temp.X:= LtX;
 temp.Y:= LtY;
 temp.Z:= LtZ;
 SetLength(temp.Map,LtX,LtY,LtZ);
 for c:= 0 to temp.Z - 1 do
  for b:= 0 to temp.Y - 1 do
   for a:= 0 to temp.X - 1 do begin
    temp.Map[a,b,c].Shape:= 1;
    temp.Map[a,b,c].Sound:= LtImg.Map[0,0,0].Sound;
    If (a = temp.X-1) or (b = temp.Y-1) or (c = temp.Z-1) then
     temp.Map[a,b,c].Index:= 65535;
   end;
 dX:= LtX - LtImg.X;
 dY:= LtY - LtImg.Y;
 dZ:= LtZ - LtImg.Z;
 for c:= Max(0,-dZ) to LtImg.Z - 1 do
  for b:= Max(0,-dY) to LtImg.Y - 1 do
   for a:= Max(0,-dX) to LtImg.X - 1 do
    temp.Map[a+dX, b+dY, c+dZ]:= LtImg.Map[a,b,c];
 If StrSelect.x1 > -1000 then begin
  Inc(StrSelect.x1, dX);
  Inc(StrSelect.x2, dX);
  Inc(StrSelect.y1, dY);
  Inc(StrSelect.y2, dY);
  Inc(StrSelect.z1, dZ);
  Inc(StrSelect.z2, dZ);
 end;
 LtImg:= CopyLayout(temp);
 SetScrolls(True);
 DrawStruct();
end;

procedure TfmStruct.btSaveClick(Sender: TObject);
begin
 ExportLayout(TCubeLt(LtImg));
end;

procedure TfmStruct.btLoadClick(Sender: TObject);
var a, b, c: Integer;
    Lt: TCubeLt;
begin
 With dlOpen do begin
  If LLba1 then Filter:= 'LBA 1 Layout files (*.lt1)|*.lt1'
           else Filter:= 'LBA 2 Layout files (*.lt2)|*.lt2';
  If LLba1 then DefaultExt:= 'lt1' else DefaultExt:= 'lt2';
  InitialDir:= LastBrkPath;
  If Execute then begin
   LastBrkPath:= ExtractFilePath(FileName);
   Lt:= ReadLayoutF(FileName);
   Loading:= True;
   LtImg:= CopyLayout(Lt);
   LtX:= LtImg.X;
   LtY:= LtImg.Y;
   LtZ:= LtImg.Z;
   seX.Value:= LtX;
   seY.Value:= LtY;
   seZ.Value:= LtZ;
   StrSelect.x1:= -1000;
   paSelInfo.Visible:= False;
   If LtImg.Map[0,0,0].Sound > $EE then begin
     cbSound.ItemIndex:= LtImg.Map[0,0,0].Sound-$F0+13;
     cbSoundChange(Self);
   end
   else begin
    cbFloor.ItemIndex:= (LtImg.Map[0,0,0].Sound shr 4) and $0F;
    cbSound.ItemIndex:= LtImg.Map[0,0,0].Sound and $0F;
   end;
   Loading:= False;
   SetScrolls(True);
   sbVer.Position:= 0;
   sbHor.Position:= 0;
   DrawStruct();
   Beep();
  end;
 end;
end;

procedure TfmStruct.btAcceptClick(Sender: TObject);
begin
 if LtImg.X * LtImg.Y * LtImg.Z > 256 then
   WarningMsg('This Layout has more than 256 blocks, and thus cannot be used in a Grid.'#13
            + 'This is LBA (1&2) engine limitation.'#13
            + 'You should split the Layout to two or more smaller Layouts.');
end;

initialization
 bufMain:= TBitmap.Create();
 bufMain.pixelformat:= pf32bit;
 bufMain.Transparent:= False;

finalization
 bufMain.Free();

end.
