//******************************************************************************
// Little Big Architect: Builder - editing grid files containing rooms in
//                                 Little Big Adventure 1 & 2
//
// Clipping unit.
// Contains routines used for clipping frame. This is frame that shows when you
//  want to place a new layout in the grid, and allows you to clip the Layout so
//  that only part of it will be placed.
//
// Copyright (C) Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit Clipping;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, ActnList, ImgList, Rendering, Engine, Grids,
  Libraries, Math, StdCtrls;

type
  TfrClipping = class(TFrame)
    Images: TImageList;
    btAdvanced: TSpeedButton;
    pbImage: TPaintBox;
    Image1: TImage;
    btPosBR: TSpeedButton;
    btPosTR: TSpeedButton;
    btPosTL: TSpeedButton;
    btPosBL: TSpeedButton;
    btMin: TSpeedButton;
    btReset: TSpeedButton;
    Bevel1: TBevel;
    procedure pbImagePaint(Sender: TObject);
    procedure pbImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btMinClick(Sender: TObject);
    procedure btResetClick(Sender: TObject);
    procedure btPosTRClick(Sender: TObject);
    procedure btAdvancedClick(Sender: TObject);
  private
    FLt: TLayout;
    x24, x12, y15, z24, z12: Integer;
    FSelStart: Integer;
    FSelecting: Boolean;
    FExpandChanged: Boolean;
    Procedure PaintLtPiece(x, y: Integer; Lt: TLayout; dest: TCanvas);
    procedure PaintClipping(Can: TCanvas);
    procedure SetSize();
    function YArea(x, y: Integer; out nr: Integer): Boolean;
    function XArea(x, y: Integer; out nr: Integer): Boolean;
    function ZArea(x, y: Integer; out nr: Integer): Boolean;
  public
    ClipBox: TBox;
    Invert: array [0..2] of Boolean;
    constructor Create(AOwner: TComponent); override;
    procedure ChangePlaceObj(Init: Boolean = True);
    procedure SetClipWndPos();
    procedure InitClipping();
    procedure InitClipExpand();
    procedure SetClipExpand();
  end;

implementation

{$R *.dfm}

uses Main, Open, Settings, Hints, Globals, Maps;

constructor TfrClipping.Create(AOwner: TComponent);
begin
 inherited;
 FSelecting:= False;
 Invert[0]:= False; Invert[1]:= False; Invert[2]:= False;
 FExpandChanged:= False;
end;

Procedure TfrClipping.ChangePlaceObj(Init: Boolean = True);
begin
 DrawPieceBrk(GPlacePos.x,GPlacePos.y,GPlacePos.z,PlaceObj.X,PlaceObj.Y,PlaceObj.Z,dmRemember,True);
 If Init then begin
   InitClipping();
   FExpandChanged:= False;
 end;
 BufObj:= LayoutToPiece(LdLibrary[LtSel], LtSel);
 If not FExpandChanged then InitClipExpand();
 SetClipExpand();
 DrawPieceBrk(GPlacePos.x,GPlacePos.y,GPlacePos.z,PlaceObj.X,PlaceObj.Y,PlaceObj.Z,dmMerge,True);
end;

Procedure TfrClipping.PaintLtPiece(x, y: Integer; Lt: TLayout; dest: TCanvas);
var a, dX, dY, dZ, pX, pY: Integer;
begin
 for a:= 0 to Lt.X * Lt.Y * Lt.Z - 1 do begin
   If Lt.Map[a].Index > 0 then begin
     dX:= a mod Lt.X;
     dY:= (a div Lt.X) mod Lt.Y;
     dZ:= (a div Lt.X) div Lt.Y;
     If not BoxContains(ClipBox, dX, dY, dZ) then Continue;
     GridToPosVar(dX, dY, dZ, (Lt.Z-1)*24+x, (Lt.Y-1)*15+1+y, pX, pY);
     If Sett.Controls.GLayoutFr then BackFrame(pX, pY, dest, Sett.Frames.PanelCol);
     fmMain.imgBrkBuff.Draw(Dest, pX, pY, BuffMap[Lt.Map[a].Index]);
     If Sett.Controls.GLayoutFr then FrontFrame(pX, pY, dest, Sett.Frames.PanelCol);
   end;
 end;
end;

procedure TfrClipping.PaintClipping(Can: TCanvas);
var a: Integer;
    text: String;
begin
 If Length(LdLibrary) < 1 then Exit;
 Can.Brush.Style:= bsSolid;
 Can.FillRect(Can.ClipRect);
 Can.Brush.Style:= bsClear;
 Can.Pen.Color:= clBlack;

 Can.MoveTo(19, z12);
 Can.LineTo(0, z12);
 Can.LineTo(0, z12+y15+10);
 Images.Draw(Can, 2, z12+y15+1, 3);
 for a:= 1 to FLt.Y do begin
   Can.MoveTo(0, z12+a*15); Can.LineTo(20, z12+a*15);
   text:=IntToStr(FLt.Y-a+1);
   If (FLt.Y-a >= ClipBox.y1) and (FLt.Y-a <= ClipBox.y2) then begin
     Images.Draw(Can, 1, z12+a*15-14, 0);
     Can.Font.Color:= clWhite;
   end
   else Can.Font.Color:= clBlack;
   Can.TextOut(10-(Can.TextWidth(text) div 2), z12+a*15-13, text);
 end;

 Can.MoveTo(0, z12+y15+10);
 Can.LineTo(x24, z12+x12+y15+10);
 Can.LineTo(x24+20, z12+x12+y15);
 Can.LineTo(x24+20, z12+x12+y15+10);
 Can.LineTo(x24, z12+x12+y15+10);
 Images.Draw(Can, x24+12, z12+x12+y15+4, 4);
 for a:= 1 to FLt.X do begin
   Can.MoveTo(a*24-24, z12+a*12+y15-2);
   Can.LineTo(a*24-4, z12+a*12+y15-12);
   text:= IntToStr(a);
   If (a-1 >= ClipBox.x1) and (a-1 <= ClipBox.x2) then begin
     Images.Draw(Can, a*24-22, z12+a*12+y15-11, 1);
     Can.Font.Color:= clWhite;
   end
   else Can.Font.Color:= clBlack;
   Can.TextOut(a*24-(Can.TextWidth(text) div 2)-1, z12+a*12+y15-7, text);
 end;

 Can.MoveTo(x24+20, z12+x12+y15+10);
 Can.LineTo(x24+40, z12+x12+y15+10);
 Can.MoveTo(x24+20, z12+x12+y15);
 Can.LineTo(x24+40, z12+x12+y15+10);
 Can.LineTo(x24+40+z24, x12+y15+10);
 Images.Draw(Can, x24+23, z12+x12+y15+4, 5);
 for a:= 1 to FLt.Z do begin
   Can.MoveTo(x24+a*24+20, z12+x12-a*12+y15);
   Can.LineTo(x24+a*24+40, z12+x12-a*12+y15+10);
   text:= IntToStr(FLt.Z-a+1);
   If (FLt.Z-a >= ClipBox.z1) and (FLt.Z-a <= ClipBox.z2) then begin
     Images.Draw(Can, x24+a*24-2, z12+x12-a*12+y15+1, 2);
     Can.Font.Color:= clWhite;
   end
   else Can.Font.Color:= clBlack;
   Can.TextOut(x24+a*24+18-(Can.TextWidth(text) div 2), z12+x12-a*12+y15+4, text);
 end;

 PaintLtPiece(20, 0, FLt, Can);
end;

procedure TfrClipping.SetClipWndPos();
begin
 case Sett.Controls.GClippingPos of
   crTopLeft: begin
     Left:= fmMain.pbGrid.Left + fmMain.paMain.Left;
     Top:= fmMain.pbGrid.Top + fmMain.paMain.Top;
     fmMain.paAdv.Left:= Left;
     fmMain.paAdv.Top:= Top + Height;
   end;
   crTopRight: begin
     Left:= fmMain.pbGrid.Left + fmMain.pbGrid.Width + fmMain.paMain.Left - Width;
     Top:= fmMain.pbGrid.Top + fmMain.paMain.Top;
     fmMain.paAdv.Left:= fmMain.pbGrid.Left + fmMain.pbGrid.Width
                       + fmMain.paMain.Left - fmMain.paAdv.Width;
     fmMain.paAdv.Top:= Top + Height;
   end;
   crBtmRight: begin
     Left:= fmMain.pbGrid.Left + fmMain.pbGrid.Width + fmMain.paMain.Left - Width;
     Top:= fmMain.pbGrid.Top + fmMain.pbGrid.Height + fmMain.paMain.Top - Height;
     fmMain.paAdv.Left:= Left - fmMain.paAdv.Width;
     fmMain.paAdv.Top:= fmMain.pbGrid.Top + fmMain.pbGrid.Height + fmMain.paMain.Top
                      - fmMain.paAdv.Height;
   end;
   crBtmLeft: begin
     Left:= fmMain.pbGrid.Left + fmMain.paMain.Left;
     Top:= fmMain.pbGrid.Top + fmMain.pbGrid.Height + fmMain.paMain.Top - Height;
     fmMain.paAdv.Left:= Left + Width;
     fmMain.paAdv.Top:= fmMain.pbGrid.Top + fmMain.pbGrid.Height + fmMain.paMain.Top
                      - fmMain.paAdv.Height;
   end;
 end;
end;

procedure TfrClipping.SetSize();
begin
 If Sett.Controls.GClippingMin then begin
   Width:= 22;
   Height:= 22;
   btAdvanced.Visible:= False;
   SetClipWndPos();
 end
 else begin
   if ((FLt.X > 1) or (FLt.Y > 1) or (FLt.Z > 1)) then begin
     Width:= GetLtWidth(FLt) + 43;
     Height:= GetLtHeight(FLt) + 13;
     btMin.Visible:= True;
     //btPos3.Visible:= True;
     //btPos4.Visible:= True;
   end
   else begin
     Width:= 19;
     Height:= 14;
     btMin.Visible:= False;
     //btPos3.Visible:= False;
     //btPos4.Visible:= False;
   end;
   btAdvanced.Visible:= True;
   SetClipWndPos();
   SetDimensions(Image1, pbImage.Width, pbImage.Height);
   pbImage.Repaint();
 end;
 fmMain.paAdv.Visible:= Sett.Controls.GClippingAdv
   and not Sett.Controls.GClippingMin and (GridTool = gtPlace);
end;

procedure TfrClipping.InitClipping();
begin
 If Length(LdLibrary) < 1  then Exit;
 FLt:= LdLibrary[LtSel];
 x12:= FLt.X*12; x24:= x12*2; y15:= FLt.Y*15; z12:= FLt.Z*12; z24:= z12*2;
 ClipBox:= Box(0, 0, 0, FLt.X-1, FLt.Y-1, FLt.Z-1);
 Visible:= GridTool = gtPlace;
 SetSize();
end;

procedure TfrClipping.pbImagePaint(Sender: TObject);
begin
 PaintClipping(pbImage.Canvas);
end;

function TfrClipping.YArea(x, y: Integer; out nr: Integer): Boolean;
begin
 Result:= (x>=0) and (y>=z12) and (x<=19) and (y<=z12+y15+9-(x div 2));
 nr:= FLt.Y - ((y-z12) div 15) -1;
 If nr < 0 then nr:= -1;
end;

function TfrClipping.XArea(x, y: Integer; out nr: Integer): Boolean;
begin
 Result:= (x > (z12+y15+9-y)*2) and (x < (-z12-y15+y)*2+20) and (x >= (-z12-y15+y)*2-20)
     and (x < x24+20) and (y <= z12+x12+y15+10);
 nr:= (x+y*2-z24-y15*2-21) div 48;
 If nr > FLt.X-1 then nr:= -1;
end;

function TfrClipping.ZArea(x, y: Integer; out nr: Integer): Boolean;
begin
 Result:= (x>=(z12+y15+x24+11-y)*2) and (x<=(z12-y15+10+y)*2) and (x<=(z12+y15+x24+30-y)*2)
      and (x>x24+20) and (y<=z12+x12+y15+10);
 nr:= (-x+y*2+z24-y15*2+20) div 48;
 If nr > FLt.Z-1 then nr:= -1;
end;

procedure TfrClipping.pbImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var nr: Integer;
begin
 If ssLeft in Shift then begin
   GSelecting:= True;
   If YArea(X, Y, nr) then begin
     If nr < 0 then begin ClipBox.y1:= 0;  ClipBox.y2:= FLt.Y-1; end
               else begin ClipBox.y1:= nr; ClipBox.y2:= nr; end;
   end
   else If XArea(X, Y, nr) then begin
     If nr < 0 then begin ClipBox.x1:= 0;  ClipBox.x2:= FLt.X-1; end
               else begin ClipBox.x1:= nr; ClipBox.x2:= nr; end;
   end
   else If ZArea(X, Y, nr) then begin
     If nr < 0 then begin ClipBox.z1:= 0;  ClipBox.z2:= FLt.Z-1; end
               else begin ClipBox.z1:= nr; ClipBox.z2:= nr; end;
   end
   else GSelecting:= False;
   FSelStart:= nr;
   pbImage.Repaint();
   ChangePlaceObj(False);
 end;
end;

procedure TfrClipping.pbImageMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var nr: Integer;
begin
 If GSelecting and (ssLeft in Shift) then begin
   If YArea(X, Y, nr) and (nr >= 0) then begin
     ClipBox.y1:= Min(FSelStart, nr);
     ClipBox.y2:= Max(FSelStart, nr);
   end;
   If XArea(X, Y, nr) and (nr >= 0) then begin
     ClipBox.x1:= Min(FSelStart, nr);
     ClipBox.x2:= Max(FSelStart, nr);
   end;
   If ZArea(X, Y, nr) and (nr >= 0) then begin
     ClipBox.z1:= Min(FSelStart, nr);
     ClipBox.z2:= Max(FSelStart, nr);
   end;
   pbImage.Repaint();
   ChangePlaceObj(False);
 end;
end;

procedure TfrClipping.btMinClick(Sender: TObject);
begin
 If Assigned(Sender) then
   Sett.Controls.GClippingMin:= not Sett.Controls.GClippingMin;
 If Sett.Controls.GClippingMin then btMin.Glyph.LoadFromResourceName(0,'EXPAND')
 else btMin.Glyph.LoadFromResourceName(0,'MINIMIZE');
 btAdvancedClick(Self);
end;

procedure TfrClipping.btAdvancedClick(Sender: TObject);
begin
 If Sender is TSpeedButton then
   Sett.Controls.GClippingAdv:= not Sett.Controls.GClippingAdv;
 If Sett.Controls.GClippingAdv then btAdvanced.Glyph.LoadFromResourceName(0,'UPARROW')
 else btAdvanced.Glyph.LoadFromResourceName(0,'DNARROW');
 SetSize();
end;

procedure TfrClipping.btResetClick(Sender: TObject);
begin
 If Assigned(Sender) then
   Sett.General.ResetClip:= btReset.Down;
end;

procedure TfrClipping.btPosTRClick(Sender: TObject);
begin
 if UpdatingControls then Exit;
 if Assigned(Sender) then begin
        if btPosTR.Down then Sett.Controls.GClippingPos:= crTopRight
   else if btPosTL.Down then Sett.Controls.GClippingPos:= crTopLeft
   else if btPosBL.Down then Sett.Controls.GClippingPos:= crBtmLeft
   else Sett.Controls.GClippingPos:= crBtmRight;
 end;

 SetClipWndPos();
end;

procedure TfrClipping.InitClipExpand();
begin
 fmMain.seAX.Value:= BufObj.X;
 fmMain.seAY.Value:= BufObj.Y;
 fmMain.seAZ.Value:= BufObj.Z;
 FExpandChanged:= False;
end;

procedure TfrClipping.SetClipExpand();
var a, b, c, d, e, f: Integer;
begin
 if BufObj.X = 0 then Exit;
 DrawPieceBrk(GPlacePos.x,GPlacePos.y,GPlacePos.z,PlaceObj.X,PlaceObj.Y,PlaceObj.Z,dmRemember,True);
 PlaceObj.X:= fmMain.seAX.ReadValueDef(BufObj.X);
 PlaceObj.Y:= fmMain.seAY.ReadValueDef(BufObj.Y);
 PlaceObj.Z:= fmMain.seAZ.ReadValueDef(BufObj.Z);
 SetLength(PlaceObj.Map,PlaceObj.X,PlaceObj.Y,PlaceObj.Z);
 If Invert[0] then d:= BufObj.X-(PlaceObj.X mod BufObj.X) else d:=0;
 If Invert[1] then e:= BufObj.Y-(PlaceObj.Y mod BufObj.Y) else e:=0;
 If Invert[2] then f:= BufObj.Z-(PlaceObj.Z mod BufObj.Z) else f:=0;
 for a:= 0 to PlaceObj.X - 1 do
   for b:= 0 to PlaceObj.Y - 1 do
     for c:= 0 to PlaceObj.Z - 1 do
       PlaceObj.Map[a,b,c]:= BufObj.Map[(a+d) mod BufObj.X,(b+e) mod BufObj.Y,(c+f) mod BufObj.Z];
 DrawPieceBrk(GPlacePos.x,GPlacePos.y,GPlacePos.z,PlaceObj.X,PlaceObj.Y,PlaceObj.Z,dmMerge,True);
end;

end.
