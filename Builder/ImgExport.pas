unit ImgExport;

interface

uses Windows, Graphics, ProgBar, Rendering, Open, SysUtils, Hints, Settings, Engine,
     DePack, Grids;

procedure ExportGridToBitmap(path: String);

implementation

uses Main, Globals, Maps;

type
  TPalBitmap = array of array of Byte; //Coordinates are flipped! (var[y, x]:= xxx) (to spped up saving)

var
  BrkBuff: array of TBrickImage;
  BrkBuffMap: array of SmallInt; {16 bit signed}


Procedure InitBrickBuffer(Brk: TPackEntries);
var a: Integer;
begin
 SetLength(BrkBuff, 0);
 SetLength(BrkBuffMap, Length(Brk) + 1);
 for a:= 1 to High(BrkBuffMap) do BrkBuffMap[a]:= -1;
 BuffMap[0]:= -2;
end;

procedure BufferBrick(BrkNum: Integer);
var {a, b,} c: Integer;
begin
 if BrkBuffMap[BrkNum] = -1 then begin
   c:= Length(BrkBuff);
   SetLength(BrkBuff, c + 1);
   {for a:= 0 to 47 do
     for b:= 0 to 37 do
       BrkBuff[c][a,b]:= 0;}
   if PkBricks[BrkNum-1].Comp > 0 then UnpackSelf(PkBricks[BrkNum-1]);
   PaintBrkStringIndexed(PkBricks[BrkNum-1].Data, BrkBuff[c]);
   BrkBuffMap[BrkNum]:= c;
 end;
end;

procedure BrkDrawIndexed(Brk: TBrickImage; x, y: Integer; var Dest: TPalBitmap);
var a, b: Integer;
begin
 for a:= 0 to 47 do
   for b:= 0 to 37 do
     If (Brk[a,b] <> 0)
     and (x + a >= 0) and (x + a <= 3099) and (y + b >= 0) and (y + b <= 1949) then
       Dest[b+y,a+x]:= Brk[a,b];
end;

//This is modified version of DrawMap, for exporting purpose only.
//The main difference is that it draws the image in the buffer for which each pixel
//  is idex in the palette (not RGB)
//TODO: Check if it would not be faster for normal operation than current method
procedure DrawMapPal(x, y: Integer; var Dest: TPalBitmap);
var a, b, c, pX, pY: Integer;
    mi: TMapItem;
begin
 for a:= 0 to GHiX do begin
   for b:= 0 to GHiY do begin
     for c:= 0 to GHiZ do begin
       pX:= x + (a - c) * 24;
       pY:= y + (a + c) * 12 - b * 15;
       mi:= CMap^.M^[a,b,c];
       if b <= HiVisLayer then begin
         if (foNormal in mi.Frame) then begin
           if mi.BrkNr <> TransparentBrick then begin
             BufferBrick(mi.BrkNr);
             BrkDrawIndexed(BrkBuff[BrkBuffMap[mi.BrkNr]], pX, pY, Dest);
           end;
         end;
       end;
     end;
   end;
 end;
end;

procedure ExportGridToBitmap(path: String);  
var f: File;             //TODO: add fragment exporting (smaller bitmaps)
    Buff: TPalBitmap;
    a: Word;
    b: Dword;
    c: Byte;
    e: Integer;
begin

 InitBrickBuffer(PkBricks);

 If not NoProgress then ProgBarForm.ShowSpecialBar('Exporting to bitmap...', fmMain, True, 0, GImgH - 1);

 AssignFile(f,path);
 Rewrite(f,1);

 //== Bitmap file header ==
 a:= 19778;   BlockWrite(f,a,2); // Bitmap identifier (ASCII "BM")
 b:= 6046078; BlockWrite(f,b,4); // File size
 b:= 0;       BlockWrite(f,b,4); // Reserved
 b:= 1078;    BlockWrite(f,b,4); // Offset to the bitmap data

 //== Bitmap info header ==
 b:= 40;      BlockWrite(f,b,4); // Size of the bitmap info header structure
 b:= 3100;    BlockWrite(f,b,4); // Bitmap width
 b:= 1950;    BlockWrite(f,b,4); // Bitmap height
 a:= 1;       BlockWrite(f,a,2); // Number of planes
 a:= 8;       BlockWrite(f,a,2); // Bits per pixel
 b:= 0;       BlockWrite(f,b,4); // Compression
 b:= 6045000; BlockWrite(f,b,4); // Size of the image
 b:= 0;       BlockWrite(f,b,4); // X - pixels per meter
 b:= 0;       BlockWrite(f,b,4); // Y - pixels per meter
 b:= 0;       BlockWrite(f,b,4); // Number of used colours
 b:= 0;       BlockWrite(f,b,4); // Number of important colours

 //== RGB Quad (palette) ==
 for a:= 0 to 255 do begin
   c:= (Palette[a] shr 16) and $ff; // R
   BlockWrite(f,c,1);
   c:= (Palette[a] shr 8) and $ff;  // G
   BlockWrite(f,c,1);
   c:= Palette[a] and $ff;          // B
   BlockWrite(f,c,1);
   c:= 0;                           // Reserved
   BlockWrite(f,c,1);
 end;

 // Bitmap data
 SetLength(Buff, 1950, 3100);
 DrawMapPal(GOffX, GOffY, Buff);

 for e:= 1949 downto 0 do begin
   BlockWrite(f, Buff[e][0], 3100);
   ProgBarForm.UpdateBar(GImgH - 1 - e);
 end;

 CloseFile(f);
 ProgBarForm.CloseSpecial();
 Beep();
 PutMessage('Image sucessfully exported'); //29
 Sett.General.LastExpDir:= ExtractFilePath(path);
end;

end.
