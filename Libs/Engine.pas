//******************************************************************************
// Little Big Architect - editing grid, brick and layout files containing
//                        rooms in Little Big Adventure 1 & 2
//
// Engine unit (used in both Builder and Factory).
// Contains brick/library/grid loading and displaying routines.
//
// Copyright Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit Engine;

interface

uses Classes, DePack, Windows, Graphics, ExtCtrls, SpinMod, SysUtils, Math;

type
 TPalette = array[0..255] of TColor;

 TPoint3d = record
  x, y, z: Integer;
 end;

 TBox = record
  x1, y1, z1, x2, y2, z2: Integer;
 end;

 TFrameLines = set of (flTopLeftBack, flTopLeftFront, flTopRightBack, flTopRightFront,
                       flBtmLeftBack, flBtmLeftFront, flBtmRightBack, flBtmRightFront,
                       flVertFront, flVertLeft, flVertRight, flVertBack);

 TBrickImage = array[0..47, 0..37] of Byte;

procedure UpdateImage(Src: TImage; Dest: TPaintBox); overload;
procedure UpdateImage(Src: TBitmap; Dest: TPaintBox); overload;
Procedure SetDimensions(Target: TImage; Width, Height: Integer); overload;
Procedure SetDimensions(Target: TBitmap; Width, Height: Integer); overload;
Function SRound(val: Double): Integer;
Function ConvertDef(Spin: TSpinEdit; default: Integer = 0): Integer;
function TryToConvert(Spin: TSpinEdit; out val: Integer): Boolean;

function LoadPaletteFromStream(data: TStream): TPalette;
function LoadPaletteFromString(data: String): TPalette;
function LoadPaletteFromFile(path: String): TPalette;
function LoadPaletteFromResource(version: Byte): TPalette;
function InvertPalette(var pal: TPalette): TPalette;
function PaletteToString(src: TPalette): String;

Procedure BackFrame(X, Y: Integer; C: TCanvas; Col: TColor = clWhite);
Procedure FrontFrame(X, Y: Integer; C: TCanvas; Col: TColor = clWhite);
Procedure FrontFrameC(x, y: Integer; C: TCanvas; Col: TColor; Solid: Boolean = True);
Procedure BackFrameLine(X, Y: Integer; C: TCanvas; Col: TColor; Lines: TFrameLines);
Procedure FrontFrameLine(X, Y: Integer; C: TCanvas; Col: TColor; Lines: TFrameLines; Solid: Boolean = True);
Procedure ShapeBFrame(X, Y: Integer; C: TCanvas; Col: TColor; Shape: Byte);
Procedure ShapeFFrame(X, Y: Integer; C: TCanvas; Col: TColor; Shape: Byte);

//Returns True if the Brick structure is ok. Otherwise returns False and fills the
// Brick with red
function PaintBrickFromString(Brick: String; Pos: TPoint; Palette: TPalette;
  Can: TCanvas; Frame, Offset: Boolean; FrameCol: TColor = clWhite;
  Sprite: Boolean = False): Boolean;

Procedure PaintBrkStringIndexed(Brick: String; var Dest: TBrickImage);
Procedure GridToPosVar(X, Y, Z, pX, pY: Integer; var rX, rY: Integer);
Function GridToPos(X, Y, Z, pX, pY: Integer): TPoint;
Function Point3d(x, y, z: Integer): TPoint3d;
Function Box(x1, y1, z1, x2, y2, z2: Integer): TBox;
Function BoxPoint(x, y, z: Integer): TBox;
Function BoxEmpty(Box: TBox): Boolean;
Function NormalBox(b: TBox): TBox;
Function BoxContains(Box: TBox; x, y, z: Integer): Boolean; overload;
Function BoxContains(Box: TBox; p: TPoint3d): Boolean; overload;
Function BoxIsPoint(B: TBox): Boolean;

implementation

{$R palette.res}

procedure UpdateImage(Src: TImage; Dest: TPaintBox); overload;
begin
 BitBlt(Dest.Canvas.Handle,0,0,Dest.Width,Dest.Height,
        Src.Canvas.Handle,0,0,SRCCOPY);
end;

procedure UpdateImage(Src: TBitmap; Dest: TPaintBox); overload;
begin
 BitBlt(Dest.Canvas.Handle,0,0,Dest.Width,Dest.Height,
        Src.Canvas.Handle,0,0,SRCCOPY);
end;

Procedure SetDimensions(Target: TImage; Width, Height: Integer); overload;
begin
 Target.Width:= Width;
 Target.Picture.Bitmap.Width:= Width;
 Target.Height:= Height;
 Target.Picture.Bitmap.Height:= Height;
end;

Procedure SetDimensions(Target: TBitmap; Width, Height: Integer); overload;
begin
 Target.Width:= Width;
 Target.Height:= Height;
end;

Function SRound(val: Double): Integer;
begin
 Result:= Trunc(SimpleRoundTo(val,0));
end;

Function ConvertDef(Spin: TSpinEdit; default: Integer = 0): Integer;
var Temp: Integer;
begin
 Temp:= StrToIntDef(Spin.Text, default);
 If Temp < Spin.MinValue then Temp:= Spin.MinValue;
 If Temp > Spin.MaxValue then Temp:= Spin.MaxValue;
 Result:= Temp;
end;

function TryToConvert(Spin: TSpinEdit; out val: Integer): Boolean;
begin
 Result:= TryStrToInt(Spin.Text, val)
      and (val >= Spin.MinValue) and (val <= Spin.MaxValue);
end;

function LoadPaletteFromStream(data: TStream): TPalette;
var a: Integer;
    b: Byte;
begin
 data.Seek(0,soBeginning);
 For a:= 0 to 255 do begin
  data.Read(b,1);
  Result[a]:= b;   //R
  data.Read(b,1);
  Result[a]:= Result[a] + b*256;  //G
  data.Read(b,1);
  Result[a]:= Result[a] + b*256*256;  //B
 end;
end;

function LoadPaletteFromString(data: String): TPalette;
var a, b: Integer;
begin
 FillChar(Result, SizeOf(Result), 0);
 for a:= 0 to Min(Length(data) div 3, 256) - 1 do begin
   b:= a * 3;
   Result[a]:= Byte(data[b + 1]) //R
   or (Byte(data[b + 2]) shl 8) //G
   or (Byte(data[b + 3]) shl 16); //B
 end;
end;

function LoadPaletteFromResource(version: Byte): TPalette;
var FRes: TResourceStream;
begin
 FRes:= TResourceStream.Create(0,Format('LBA_%d_MAIN',[version]),'LBA_PALETTE');
 Result:= LoadPaletteFromStream(FRes);
 Fres.Free;
end;

function LoadPaletteFromFile(path: String): TPalette;
var FRes: TFileStream;
begin
 //CheckFile(path);
 FRes:= TFileStream.Create(path,fmOpenRead,fmShareDenyWrite);
 Result:= LoadPaletteFromStream(FRes);
 Fres.Free;
end;

//exchanges R and B colours in the palette
function InvertPalette(var pal: TPalette): TPalette;
var a: Integer;
begin
 for a:=0 to 255 do
  Result[a]:= (pal[a] and $000000ff) shl 16
           or (pal[a] and $00ff0000) shr 16
           or (pal[a] and TColor($ff00ff00));
end;

function PaletteToString(src: TPalette): String;
var a: Integer;
begin
 Result:= '';
 for a:= 0 to 255 do
  Result:= Result + Char( src[a] and $0000ff)
                  + Char((src[a] and $00ff00) shr 8)
                  + Char((src[a] and $ff0000) shr 16);
end;

Procedure BackFrame(X, Y: Integer; C: TCanvas; Col: TColor = clWhite);
begin
 C.Pen.Color:=Col;
 C.Pen.Style:=psDot;
 C.Brush.Style:= bsClear;
 {C.PolyLine([Point(X+24,Y-1),Point(X+24,Y+14),Point(X+48,Y+26)]);
 C.PolyLine([Point(X+24,Y+14),Point(X,Y+26)]); }
 C.PolyLine([Point(x+0,y+26),Point(x+25,y+15),Point(x+48,y+27)]);
 C.PolyLine([Point(x+24,y+0),Point(x+24,y+15)]);
end;

Procedure FrontFrame(X, Y: Integer; C: TCanvas; Col: TColor = clWhite);
begin
 C.Pen.Color:=Col;
 C.Pen.Style:=psSolid;
 C.PolyLine([Point(X,Y+11),Point(X,Y+26),Point(X+24,Y+38),Point(X+24,Y+23),
  Point(X,Y+11),Point(X+24,Y-1),Point(X+48,Y+11),Point(X+24,Y+23)]);
 C.PolyLine([Point(X+24,Y+38),Point(X+48,Y+26),Point(X+48,Y+11)]);
end;

Procedure BackFrameC;
begin
 {C.Pen.Color:= Col;
 C.Pen.Style:= psDot;
 C.MoveTo(0,26);
 C.LineTo(25,15);
 C.LineTo(48,27);
 C.MoveTo(24,0);
 C.LineTo(24,15); }
end;

Procedure FrontFrameC(x, y: Integer; C: TCanvas; Col: TColor; Solid: Boolean = True);
begin
 C.Pen.Color:= Col;
 C.Brush.Style:= bsClear;
 if Solid then C.Pen.Style:= psSolid else C.Pen.Style:= psDot;
 {C.MoveTo(x+1,y+12);
 C.LineTo(x+22,y+22);
 C.LineTo(x+26,y+22);
 C.LineTo(x+47,y+11); //górne V
 C.MoveTo(x+23,y+23);
 C.LineTo(x+23,y+37); //Lewy |
 C.LineTo(x+0,y+26);
 C.LineTo(x+0,y+11);
 C.LineTo(x+23,y+0);
 C.LineTo(x+24,y+0);
 C.LineTo(x+47,y+11);
 C.LineTo(x+47,y+26);
 C.LineTo(x+24,y+37);
 C.LineTo(x+24,y+22); //Prawy | }
 C.PolyLine([Point(x+1,y+12),Point(x+22,y+22),Point(x+26,y+22),Point(x+47,y+11)]);
 C.PolyLine([Point(x+23,y+23),Point(x+23,y+37),Point(x+0,y+26),Point(x+0,y+11),
  Point(x+23,y+0),Point(x+24,y+0),Point(x+47,y+11),Point(x+47,y+26),
  Point(x+24,y+37),Point(x+24,y+22)]);
end;

Procedure BackFrameLine(x, y: Integer; C: TCanvas; Col: TColor; Lines: TFrameLines);
begin
 C.Pen.Color:= Col;
 C.Pen.Style:= psDot;
 C.Brush.Style:= bsClear;
 If flBtmLeftBack  in Lines then C.PolyLine([Point(x+24,y+14),Point(x,y+26)]);
 If flBtmRightBack in Lines then C.PolyLine([Point(x+24,y+14),Point(x+48,y+26)]);
 If flVertBack     in Lines then C.PolyLine([Point(x+24,y+14),Point(x+24,y-1)]);
end;

Procedure FrontFrameLine(X, Y: Integer; C: TCanvas; Col: TColor; Lines: TFrameLines; Solid: Boolean = True);
begin
 C.Pen.Color:= Col;
 if Solid then C.Pen.Style:= psSolid else C.Pen.Style:= psDot;
 C.Brush.Style:= bsClear;
 If flTopLeftBack   in Lines then C.PolyLine([Point(x+24,y-1),Point(x,y+11)]);
 If flTopRightBack  in Lines then C.PolyLine([Point(x+24,y-1),Point(x+48,y+11)]);
 If flTopLeftFront  in Lines then C.PolyLine([Point(x+24,y+23),Point(X,Y+11)]);
 If flTopRightFront in Lines then C.PolyLine([Point(x+24,y+23),Point(x+48,y+11)]);
 If flBtmLeftFront  in Lines then C.PolyLine([Point(x+24,y+38),Point(x,y+26)]);
 If flBtmRightFront in Lines then C.PolyLine([Point(x+24,y+38),Point(x+48,y+26)]);
 If flVertFront     in Lines then C.PolyLine([Point(x+24,y+38),Point(x+24,y+23)]);
 If flVertLeft      in Lines then C.PolyLine([Point(x,y+26),Point(x,y+11)]);
 If flVertRight     in Lines then C.PolyLine([Point(x+48,y+26),Point(x+48,y+11)]);
end;

Procedure ShapeBFrame(X, Y: Integer; C: TCanvas; Col: TColor; Shape: Byte);
begin
 C.Pen.Color:= Col;
 C.Pen.Style:= psDot;
 C.Brush.Style:= bsClear;
 C.PolyLine([Point(X,Y+26),Point(X+24,Y+14),Point(X+48,Y+26)]);
 case Shape of
  01,04,05,07,08,09,11: C.PolyLine([Point(X+24,Y-1),Point(X+24,Y+14)]);
  02,12: C.Polyline([Point(X+24,Y+14),Point(X+48,Y+11)]);
  03,13: C.Polyline([Point(X+24,Y+14),Point(X,Y+11)]);
  06: C.Polyline([Point(X+48,Y+11),Point(X+24,Y+14),Point(X,Y+11)]);
 end;
end;

Procedure ShapeFFrame(X, Y: Integer; C: TCanvas; Col: TColor; Shape: Byte);
begin
 C.Pen.Color:= Col;
 C.Pen.Style:= psDot;
 C.Brush.Style:= bsClear;
 case Shape of
  02,12: C.Polyline([Point(X+24,Y+14),Point(X+48,Y+11)]);
  03,13: C.Polyline([Point(X+24,Y+14),Point(X,Y+11)]);
  06: C.Polyline([Point(X+48,Y+11),Point(X+24,Y+14),Point(X,Y+11)]);
 end;

 C.Pen.Style:= psSolid;
 If (Shape=1) or (Shape=6) or (Shape=8) or (Shape=9) then C.Polyline([Point(X+24,Y+38),Point(X+24,Y+23)]);
 case Shape of
  01: C.Polyline([Point(X,Y+11),Point(X+24,Y+23),Point(X+48,Y+11),Point(X+24,Y-1),Point(X,Y+11),Point(X,Y+26),Point(X+24,Y+38),Point(X+48,Y+26),Point(X+48,Y+11)]);
  02: C.Polyline([Point(X+24,Y+38),Point(X+24,Y+23),Point(X,Y+26),Point(X+24,Y+38),Point(X+48,Y+26),Point(X+48,Y+11),Point(X+24,Y+23)]);
  03: C.Polyline([Point(X+24,Y+38),Point(X+24,Y+23),Point(X+48,Y+26),Point(X+24,Y+38),Point(X,Y+26),Point(X,Y+11),Point(X+24,Y+23)]);
  04: C.Polyline([Point(X+24,Y+38),Point(X,Y+26),Point(X+24,Y-1),Point(X+48,Y+11),Point(X+24,Y+38),Point(X+48,Y+26),Point(X+48,Y+11)]);
  05: C.Polyline([Point(X+24,Y+38),Point(X+48,Y+26),Point(X+24,Y-1),Point(X,Y+11),Point(X+24,Y+38),Point(X,Y+26),Point(X,Y+11)]);
  06: C.Polyline([Point(X,Y+26),Point(X,Y+11),Point(X+24,Y+23),Point(X+48,Y+11),Point(X+48,Y+26),Point(X+24,Y+38),Point(X,Y+26)]);
  07: C.Polyline([Point(X,Y+11),Point(X,Y+26),Point(X+24,Y+38),Point(X,Y+11),Point(X+24,Y-1),Point(X+48,Y+11),Point(X+24,Y+38),Point(X+48,Y+26),Point(X+48,Y+11)]);
  08: C.Polyline([Point(X,Y+26),Point(X+24,Y-1),Point(X+48,Y+11),Point(X+24,Y+23),Point(X,Y+26),Point(X+24,Y+38),Point(X+48,Y+26),Point(X+48,Y+11)]);
  09: C.Polyline([Point(X+48,Y+26),Point(X+24,Y-1),Point(X,Y+11),Point(X+24,Y+23),Point(X+48,Y+26),Point(X+24,Y+38),Point(X,Y+26),Point(X,Y+11)]);
  10: C.Polyline([Point(X+24,Y+38),Point(X+24,Y+23),Point(X,Y+26),Point(X+24,Y+38),Point(X+48,Y+26),Point(X+24,Y+23)]);
  11: C.Polyline([Point(X+24,Y+38),Point(X,Y+26),Point(X+24,Y-1),Point(X+48,Y+26),Point(X+24,Y+38)]);
  12: C.Polyline([Point(X,Y+26),Point(X+24,Y+38),Point(X+48,Y+26),Point(X+48,Y+11),Point(X+24,Y+38)]);
  13: C.Polyline([Point(X+48,Y+26),Point(X+24,Y+38),Point(X,Y+26),Point(X,Y+11),Point(X+24,Y+38)]);
 end;
end;

function PaintBrickFromString(Brick: String; Pos: TPoint; Palette: TPalette;
  Can: TCanvas; Frame, Offset: Boolean; FrameCol: TColor = clWhite;
  Sprite: Boolean = False): Boolean;
var a, b, c, PixCount, cX, cY, dPos, Header, OffsetX, OffsetY, bl: Integer;
    Height, Width, SubLines, Flags: Byte;

  procedure ReturnError();
  begin
    Can.Pen.Color:= clRed;
    Can.MoveTo(cX, cY);
    Can.LineTo(Max(Width, cX), cY);
    Can.Brush.Color:= clRed;
    Can.FillRect(Rect(Pos.X, cY + 1, Pos.X + Width, Pos.Y + Height));
    Abort;
  end;

begin
 Result:= True;
 bl:= Length(Brick);
 Width:= 48;
 Height:= 38;
 cX:= 0;
 cY:= 0;
 If Frame then BackFrame(Pos.X, Pos.Y, Can, FrameCol);
 If Sprite then Header:= 8 else Header:= 0;
 try
   if bl < 2 then ReturnError();
   Width:= Byte(Brick[Header + 1]);
   Height:= Byte(Brick[Header + 2]);

   if bl < 4 then ReturnError();
   If Offset then begin
     OffsetX:= Byte(Brick[Header + 3]);
     OffsetY:= Byte(Brick[Header + 4]);
   end
   else begin
     OffsetX:= 0;
     OffsetY:= 0;
   end;

   cY:= Pos.Y + OffsetY;
   dPos:= Header + 5;
   for a:= 0 to Height - 1 do begin
     cX:= Pos.X + OffsetX;
     if bl < dPos then ReturnError();
     SubLines:= Byte(Brick[dPos]);
     Inc(dPos);
     for b:= 0 to SubLines - 1 do begin
       if bl < dPos then ReturnError();
       Flags:= Byte(Brick[dPos]);
       Inc(dPos);
       PixCount:= (Flags and $3F) + 1;
       If (Flags and $40) <> 0 then begin
         if bl < dPos + PixCount - 1 then ReturnError();
         for c:= 0 to PixCount - 1 do begin
           Can.Pixels[cX, cY]:= Palette[Byte(Brick[dPos])];
           Inc(dPos);
           Inc(cX);
         end;
       end
       else if (Flags and $80) <> 0 then begin
         if bl < dPos then ReturnError();
         Can.Pen.Color:= Palette[Byte(Brick[dPos])];
         Can.MoveTo(cX, cY);
         Can.LineTo(cX + PixCount, cY);
         Inc(dPos);
         Inc(cX, PixCount);
       end
       else
         Inc(cX, PixCount);
     end;
     Inc(cY);
   end;
 except  //After calling ReturnError() aborting will stop here
   Result:= False; 
 end;
 if Frame then FrontFrame(Pos.X, Pos.Y, Can, FrameCol);
end;

//Paints Brick (not Sprite) from string to an indexed image
Procedure PaintBrkStringIndexed(Brick: String; var Dest: TBrickImage);
var a, b, c, PixCount, cX, cY, dPos, OffsetX, OffsetY: Integer;
    Height, SubLines, Flags, Pix: Byte;
begin
 Height:= Byte(Brick[2]);
 OffsetX:= Byte(Brick[3]);
 OffsetY:= Byte(Brick[4]);
 cY:= OffsetY;
 dPos:= 5;
 for a:= 0 to Height - 1 do begin
   cX:= OffsetX;
   SubLines:= Byte(Brick[dPos]);
   Inc(dPos);
   for b:= 0 to SubLines - 1 do begin
     Flags:= Byte(Brick[dPos]);
     Inc(dPos);
     PixCount:= (Flags and $3F) + 1;
     If (Flags and $40) <> 0 then
       for c:= 0 to PixCount - 1 do begin
         Dest[cX,cY]:= Byte(Brick[dPos]);
         Inc(dPos);
         Inc(cX);
       end
     else if (Flags and $80) <> 0 then begin
       Pix:= Byte(Brick[dPos]);
       for c:= 0 to PixCount - 1 do begin
         Dest[cX,cY]:= Pix;
         Inc(cX);
       end;
       Inc(dPos);
     end
     else
       Inc(cX,PixCount);
   end;
   Inc(cY);
 end;
end;

Procedure GridToPosVar(X, Y, Z, pX, pY: Integer; var rX, rY: Integer);
begin
 rX:=(X-Z)*24+pX;
 rY:=(X+Z)*12-Y*15+pY;
end;

Function GridToPos(X, Y, Z, pX, pY: Integer): TPoint;
begin
 Result.X:= (X - Z) * 24 + pX;
 Result.Y:= (X + Z) * 12 - Y * 15 + pY;
end;

Function Point3d(x, y, z: Integer): TPoint3d;
begin
 Result.x:= x; Result.y:= y; Result.z:= z;
end;

Function Box(x1, y1, z1, x2, y2, z2: Integer): TBox;
begin
 Box.x1:= x1; Box.y1:= y1; Box.z1:= z1; Box.x2:= x2; Box.y2:= y2; Box.z2:= z2;
end;

Function BoxPoint(x, y, z: Integer): TBox;
begin
 BoxPoint.x1:=x; BoxPoint.y1:=y; BoxPoint.z1:=z; BoxPoint.x2:=x; BoxPoint.y2:=y; BoxPoint.z2:=z;
end;

Function BoxEmpty(Box: TBox): Boolean;
begin
 Result:=(Box.x1<0) and (Box.y1<0) and (Box.z1<0) and (Box.x2<0) and (Box.y2<0) and (Box.z2<0);
end;

Function NormalBox(b: TBox): TBox;
begin
 Result.x1:=Min(b.x1,b.x2); Result.x2:=Max(b.x1,b.x2);
 Result.y1:=Min(b.y1,b.y2); Result.y2:=Max(b.y1,b.y2);
 Result.z1:=Min(b.z1,b.z2); Result.z2:=Max(b.z1,b.z2);
end;

Function BoxContains(Box: TBox; x, y, z: Integer): Boolean; overload;
begin
 Result:= (x>=Box.x1) and (x<=Box.x2) and (y>=Box.y1) and (y<=Box.y2) and (z>=Box.z1) and (z<=Box.z2);
end;

Function BoxContains(Box: TBox; p: TPoint3d): Boolean; overload;
begin
 Result:= (p.x>=Box.x1) and (p.x<=Box.x2) and (p.y>=Box.y1) and (p.y<=Box.y2) and (p.z>=Box.z1) and (p.z<=Box.z2);
end;

Function BoxIsPoint(B: TBox): Boolean;
begin
 Result:= (B.x1=B.x2) and (B.y1=B.y2) and (B.z1=B.z2);
end;

end.
 