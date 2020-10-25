unit Bricks;

interface

//uses Graphics, Windows, Classes;

uses DePack, Engine, Grids, Libraries, Classes, ProgBar, SysUtils, Windows,
     ExtCtrls, Graphics, Controls, Math, Forms;

var
 BrkTemp: TBitmap;

procedure BufferBrick(BrkNum: Integer);
Function PixelOfBrick(x, y: Integer; Brk: Integer): Byte;
Function BrickIsEmpty(Brk: Integer): Boolean;

implementation

uses Rendering, Open, Main, Globals;

{Function BrickToBitBrick(Brick: String): TBitBrick;
var a, b, c, PixCount, cX, cY, dPos: Integer;
    Height, OffsetX, OffsetY, SubLines, Flags: Byte;
begin
 for b:=0 to 37 do
  for a:=0 to 47 do
   Result[a,b]:= -1;
 Height:=Byte(Brick[2]);
 OffsetX:=Byte(Brick[3]); OffsetY:=Byte(Brick[4]);
 cY:=OffsetY;
 dPos:=5;
 for a:=0 to Height-1 do begin
  cX:=OffsetX;
  SubLines:=Byte(Brick[dPos]);
  Inc(dPos);
  for b:=0 to SubLines-1 do begin
   Flags:=Byte(Brick[dPos]);
   Inc(dPos);
   PixCount:=(Flags and $3F)+1;
   If (Flags and $40)<>0 then
    for c:=0 to PixCount-1 do begin
     Result[cX,cY]:= InvertPal[Byte(Brick[dPos])];
     Inc(dPos);
     Inc(cX);
    end
   else if (Flags and $80)<>0 then begin
    for c:=0 to PixCount-1 do begin
     Result[cX,cY]:= InvertPal[Byte(Brick[dPos])];
     Inc(cX);
    end;
    Inc(dPos);
   end
   else
    Inc(cX,PixCount);
  end;
  Inc(cY);
 end;
end;}

{Procedure BufferBrick(BrkNum: DWord);
begin
 If BuffMap[BrkNum] < 0 then begin
  SetLength(bitBuffers,Length(bitBuffers)+1);
  bitBuffers[High(bitBuffers)]:= BrickToBitBrick(UnpackToString(Bricks[BrkNum-1]));
  BuffMap[BrkNum]:= High(bitBuffers);
 end;
end;

procedure DrawBitBrick(Brk: TBitBrick; x, y: Integer; bit: TBitmap);
var a, b, c, d, e, f, bitW: Integer;
    r: TRect;
begin
 bitW:= bit.Width;
 r:= bit.Canvas.ClipRect;
 e:= Max(0,r.Left-x);
 f:= Min(47,r.Right-x-1);
 for b:=Max(0,r.Top-y) to Min(37,r.Bottom-y-1) do
  for a:=e to f do begin
   c:= a + x;
   d:= b + y;
   If Brk[a,b] <> -1 then
    DWord(Pointer(Integer(bit.ScanLine[d])+c*4)^):= Brk[a,b];
  end;
end;}

procedure BufferBrick(BrkNum: Integer);
begin
 If BuffMap[BrkNum] = -1 then begin
   BrkTemp.Canvas.Brush.Color:= clFuchsia;
   BrkTemp.Canvas.FillRect(Rect(0, 0, 48, 38));
   If PkBricks[BrkNum-1].Comp > 0 then UnpackSelf(PkBricks[BrkNum-1]);
   if not PaintBrickFromString(PkBricks[BrkNum-1].Data, Point(0,0), Palette, BrkTemp.Canvas, False, True)
   and not BadBrickMessage then begin
     Application.MessageBox('The data of at least one Brick is corrupted!'#13'The unreadable part has been replaced with red colour. Use Factory to find out which bricks are corrupted (as the red filling may not always be visible) and fix this problem.',
       ProgramName, MB_ICONERROR + MB_OK);
     BadBrickMessage:= True;
   end;    
   BuffMap[BrkNum]:= fmMain.imgBrkBuff.AddMasked(BrkTemp, clFuchsia);
 end;
end;

Function PixelOfBrick(x, y: Integer; Brk: Integer): Byte;
var a, b, c, dPos: Integer;
    d, Height, SubLines, Flags: Byte;
begin
 Result:= 0;
 If PkBricks[Brk].Comp > 0 then UnpackSelf(PkBricks[Brk]);
 Height:= Byte(PkBricks[Brk].Data[2]);
 x:= x - Byte(PkBricks[Brk].Data[3]); //Offset
 y:= y - Byte(PkBricks[Brk].Data[4]);
 If (x > Byte(PkBricks[Brk].Data[1])-1) or (x < 0) or (y > Height-1) or (y < 0) then Exit;
 dPos:=5 ;
 for a:= 0 to Height - 1 do begin
   SubLines:= Byte(PkBricks[Brk].Data[dPos]);
   Inc(dPos);
   If a < y then
     for b:= 0 to SubLines - 1 do begin
       Flags:= Byte(PkBricks[Brk].Data[dPos]);
       Inc(dPos);
       If (Flags and $40) > 0 then Inc(dPos, (Flags and $3F) + 1)
       else if (Flags and $80) > 0 then Inc(dPos);
     end
   else begin
     c:= -1;
     for b:= 0 to SubLines - 1 do begin
       Flags:= Byte(PkBricks[Brk].Data[dPos]);
       Inc(dPos);
       d:= (Flags and $3F) + 1;
       If c + d >= x then begin
         If (Flags and $40) > 0 then Result:= Byte(PkBricks[Brk].Data[dPos+x-c-1])
         else if (Flags and $80) > 0 then Result:= Byte(PkBricks[Brk].Data[dPos]);
         Exit;
       end
       else begin
         If (Flags and $40) > 0 then Inc(dPos,d)
         else if (Flags and $80) > 0 then Inc(dPos);
       end;
       Inc(c,d);
     end;
   end;
 end;
end;

// Checks if the Brick is all transparent
Function BrickIsEmpty(Brk: Integer): Boolean;
var a, b, dPos: Integer;
    Height, SubLines, Flags: Byte;
begin
 If PkBricks[Brk].Comp > 0 then UnpackSelf(PkBricks[Brk]);
 Height:= Byte(PkBricks[Brk].Data[2]);
 dPos:= 5;
 for a:= 0 to Height - 1 do begin
   SubLines:= Byte(PkBricks[Brk].Data[dPos]);
   Inc(dPos);
   for b:= 0 to SubLines - 1 do begin
     Flags:= Byte(PkBricks[Brk].Data[dPos]);
     If (Flags and $C0) <> 0 then begin //$40 or $80
       Result:= False;
       Exit;
     end;
     Inc(dPos);
   end;
 end;
 Result:= True;
end;

initialization
 BrkTemp:= TBitmap.Create;
 BrkTemp.Width:= 48;
 BrkTemp.Height:= 38;
 BrkTemp.Canvas.Brush.Color:= clFuchsia;

finalization
 FreeAndNil(BrkTemp);

end.
 