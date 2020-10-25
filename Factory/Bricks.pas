//******************************************************************************
// Little Big Architect: Factory - editing brick and layout files from
//                                 Little Big Adventure 1 & 2
//
// Bricks unit.
// Contains routines that allow loading and converting Bricks.
//
// Copyright Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit Bricks;

interface

uses Engine, DePack, Classes, Windows, SysUtils, StrUtils, Graphics, Forms,
     Controls, Math;

type
 TBitBrick = array[0..47, 0..37] of byte; //0 = transparent

 TVarBrick = record
  Width, Height: Cardinal;
  Image: array of array of byte;
 end;

var
 VBricks: TPackEntries;
 BrkOffset: Integer;
 BrkCount: Integer = 0;
 Palette, InvertPal: TPalette;
 BrkPath: String;
 BricksOpened: Boolean = False;
 SingleBrick: Boolean;  //single brick or hqr

 BrkPerRow: Integer = 1;
 BrkSelect: Integer = 0;

 Buffered: array of Boolean;
 bitBuffers: array of TBitBrick;
 Allocated: Cardinal = 0;
 BricksModified: Boolean = False;

Procedure SetVarBrick(var Brick: TVarBrick; const Width, Height: Integer);
Procedure CopyVarBrick(var Dest: TVarBrick; const Source: TVarBrick);
procedure FillVarBrick(Brick: TVarBrick; Colour: Byte);
function VBCopyFragment(R: TRect; Source: TVarBrick): TVarBrick;
procedure VBPutFragment(var Dest: TVarBrick; const x, y: Integer; Src: TVarBrick;
 Trans: Boolean = False; TransCol: Byte = 0);
Procedure SetScrollBrk();
Function BrickToBitBrick(Brick: String; out BB: TBitBrick): Boolean;
Function BitBrickToBrick(BB: TBitBrick): String;
function InsideBrick(x, y: Integer; sTop, sLeft, sRight: Boolean): Boolean;
procedure DrawBitBrick(Brk: TBitBrick; x, y: Integer; bit: TBitmap); overload;
procedure DrawBitBrick(Brk: TBitBrick; x, y: Integer; bit: TBitmap;
  pal: TPalette); overload;
Procedure BufferBrick(Nr: DWord);
procedure SetMenuBrk(ext: String);
procedure OpenBricks(path: String);
procedure NewBrick(Single: Boolean);
procedure SaveBricks(path: String);
procedure SaveBrick(Brick: TBitBrick; path: String);
procedure ExportBrick(Brick: TBitBrick);
procedure DrawBrick(x, y, nr: Integer; dest: TBitmap; text, frame: Boolean);
procedure PaintBrick(x, y, nr: Integer; dest: TBitmap; Sel, text, frame: Boolean);
procedure PaintBricks();
procedure SaveBoth(path: String; Index: Integer);
procedure ShowBrickEditor(Nr: DWord);
Procedure UpdateInfo();

implementation

uses Main, ProgBar, Layouts, Editor, OptPanel, Libraries, Scenario;

Procedure SetVarBrick(var Brick: TVarBrick; const Width, Height: Integer);
begin
 Brick.Width:=Width;
 Brick.Height:=Height;
 SetLength(Brick.Image,Width,Height);
end;

Procedure CopyVarBrick(var Dest: TVarBrick; const Source: TVarBrick);
var a, b: Integer;
begin
 Dest.Width:=Source.Width;
 Dest.Height:=Source.Height;
 SetLength(Dest.Image,Dest.Width,Dest.Height);
 for b:=0 to Source.Height-1 do
  for a:=0 to Source.Width-1 do
   Dest.Image[a,b]:=Source.Image[a,b];
end;

procedure FillVarBrick(Brick: TVarBrick; Colour: Byte);
var a, b: Integer;
begin
 for b:=0 to Brick.Height-1 do
  for a:=0 to Brick.Width-1 do
   Brick.Image[a,b]:=Colour
end;

function VBCopyFragment(R: TRect; Source: TVarBrick): TVarBrick;
var a, b: Integer;
begin
 SetVarBrick(Result,R.Right-R.Left+1,R.Bottom-R.Top+1);
 for b:=Max(R.Top,0) to Min(R.Bottom,Source.Height-1) do
  for a:=Max(R.Left,0) to Min(R.Right,Source.Width-1) do
   Result.Image[a-R.Left,b-R.Top]:=Source.Image[a,b];
end;

procedure VBPutFragment(var Dest: TVarBrick; const x, y: Integer; Src: TVarBrick;
 Trans: Boolean = False; TransCol: Byte = 0);
var a, b: Integer;
begin
 for b:= Abs(Min(0,y)) to Min(src.Height,Dest.Height-y) - 1 do
   for a:= Abs(Min(0,x)) to Min(src.Width,Dest.Width-x) - 1 do
     If not (Trans and (Src.Image[a,b] = TransCol)) then
       Dest.Image[a+x,b+y]:= Src.Image[a,b];
end;

Procedure SetScrollBrk();
begin
 fmMain.GetBrkPerRow();
 fmMain.sbBricks.Enabled:=
   (BrkCount-1) div BrkPerRow > (fmMain.pbBrick.Height div 41);
 If fmMain.sbBricks.Enabled then begin
   fmMain.sbBricks.Max:= (BrkCount-1) div BrkPerRow;
   fmMain.sbBricks.PageSize:= fmMain.pbBrick.Height div 41;
   fmMain.sbBricks.LargeChange:= fmMain.sbBricks.PageSize;
 end;
end;

Function BrickToBitBrick(Brick: String; out BB: TBitBrick): Boolean;
var a, b, c, PixCount, cX, cY, dPos, bl: Integer;
    Width, Height, OffsetX, OffsetY, SubLines, Flags: Byte;

  procedure ReturnError();
  var a, b: Integer;
  begin
    for a:= OffsetX to OffsetX + Width - 1 do
      for b:= OffsetY to OffsetY + Height - 1 do
        if (b > cY) or ((b = cY) and (a >= cX)) then begin
          if Odd(a + b) then BB[a, b]:= 90 else BB[a, b]:= 240;
        end;
    Abort;
  end;

begin
 Result:= True;
 try
   cX:= 0;
   cY:= 0;
   OffsetX:= 0;
   OffsetY:= 0;
   Width:= 48;
   Height:= 38;
   bl:= Length(Brick);
   FillMemory(@BB[0,0], 38 * 48 * 1, 0);
   if bl < 4 then ReturnError();
   Width:= Byte(Brick[1]);
   Height:= Byte(Brick[2]);
   if (Width > 48) or (Height > 38) then ReturnError();
   OffsetX:= Byte(Brick[3]); OffsetY:= Byte(Brick[4]);
   cY:= OffsetY;
   dPos:= 5;
   for a:= 0 to Height - 1 do begin
     cX:= OffsetX;
     if bl < dPos then ReturnError();
     SubLines:= Byte(Brick[dPos]);
     Inc(dPos);
     for b:= 0 to SubLines - 1 do begin
       if bl < dPos then ReturnError();
       Flags:= Byte(Brick[dPos]);
       Inc(dPos);
       PixCount:= (Flags and $3F) + 1;
       If (Flags and $40) <> 0 then
         for c:= 0 to PixCount - 1 do begin
           if bl < dPos then ReturnError();
           if (cX < 48) and (cY < 38) then
             BB[cX, cY]:= Byte(Brick[dPos]);
           Inc(dPos);
           Inc(cX);
         end
       else if (Flags and $80) <> 0 then begin
         for c:= 0 to PixCount - 1 do begin
           if bl < dPos then ReturnError();
           if (cX < 48) and (cY < 38) then
             BB[cX, cY]:= Byte(Brick[dPos]);
           Inc(cX);
         end;
         Inc(dPos);
       end
       else
         Inc(cX, PixCount);
     end;
     Inc(cY);
   end;
 except
   Result:= False;
 end;
end;

{Function BitBrickToBrick_(BB: TBitBrick): String;
var a, b, OffX, OffY, MaxX, MaxY: Integer;
    SLMode, NewMode: Byte; //0-unknown, 1-transp, 2-single-col, 3-multi-col, 4-end of line
    SingleRestart: Boolean;
    PixCount, SLCount: Byte;
    ColBuf, LineBuf: String;
begin
 OffX:=47; OffY:=37;
 MaxX:=0; MaxY:=0;
 for b:=0 to 37 do
  for a:=0 to 47 do
   If BB[a,b]>0 then begin
    OffX:=Smaller(OffX,a);
    OffY:=Smaller(OffY,b);
    MaxX:=Larger(MaxX,a);
    MaxY:=Larger(MaxY,b);
   end;
 If MaxX-OffX<0 then Result:=#01#01#23#18#01#00
 else begin
  Result:=Char(MaxX-OffX+1)+Char(MaxY-OffY+1)+Char(OffX)+Char(OffY);
  for b:=OffY to MaxY do begin
   PixCount:=0;  //sub-line pixel count
   SLCount:=0;   //sub-line count
   SLMode:=0;    //sub-line mode
   ColBuf:='';   //column (pixel) buffer
   LineBuf:='';  //line buffer
   SingleRestart:=False;
   for a:=OffX to MaxX do begin
    if (a<MaxX) then begin
     If (BB[a,b]=0) then NewMode:=1
     else if (BB[a,b]=BB[a+1,b])
      or ((a>OffX) and (BB[a,b]=BB[a-1,b])) then NewMode:=2 else NewMode:=3;
     SingleRestart:=(SLMode=2) and (BB[a,b]=BB[a+1,b]) and ((a>OffX) and (BB[a,b]<>BB[a-1,b]))
    end
    else NewMode:=4;

    If a=OffX then SLMode:=NewMode;

    If (NewMode=SLMode) or (NewMode=4) then begin
     If not SingleRestart then Inc(PixCount);
     If (SLMode=3) or (NewMode=4) then
      ColBuf:=ColBuf+Char(BB[a,b]);
    end;
    If (NewMode<>SLMode) or (NewMode=4) or SingleRestart then begin
     If PixCount>0 then //just in case
      case SLMode of
       1: LineBuf:=LineBuf+Char((PixCount-1) and $3F);
       2: begin
           LineBuf:=LineBuf+Char(((PixCount-1) and $3F) or $80);
           LineBuf:=LineBuf+Char(BB[a-1,b]);
          end;
       3,4: begin
             LineBuf:=LineBuf+Char(((PixCount-1) and $3F) or $40);
             LineBuf:=LineBuf+ColBuf;
            end;
      end;
     ColBuf:='';
     PixCount:=1;
     SLMode:=NewMode;
     Inc(SLCount);
     If NewMode=3 then ColBuf:=Char(BB[a,b]);
     SingleRestart:=False;
    end;
   end;
   Result:=Result+Char(SLCount)+LineBuf;
  end;
 end;
end;}

Function PixType(var BB: TBitBrick; OffX, MaxX, X, Y: Integer): Byte;
begin  //1-single-col, 2-single-col-change, 3-multi-col, 4-single-transp
 If (X<MaxX) and (BB[X,Y]=BB[X+1,Y]) then begin
  If (X=OffX) or (BB[X,Y]=BB[X-1,Y]) then Result:=1 else Result:=2;
 end
 else if (X>OffX) and (BB[X,Y]=BB[X-1,Y]) then Result:=1
 else if BB[X,Y]=0 then Result:=4
 else Result:=3;
end;

Function BitBrickToBrick(BB: TBitBrick): String;
var a, b, OffX, OffY, MaxX, MaxY: Integer;
    SLMode, NewMode: Byte; //5-end of line
    PixCount, SLCount: Byte;
    PixBuf, LineBuf: String;
begin
 OffX:=47; OffY:=37;
 MaxX:=0; MaxY:=0;
 for b:=0 to 37 do
  for a:=0 to 47 do
   If BB[a,b]>0 then begin
    OffX:=Min(OffX,a);
    OffY:=Min(OffY,b);
    MaxX:=Max(MaxX,a);
    MaxY:=Max(MaxY,b);
   end;
 If MaxX-OffX<0 then Result:=#01#01#23#18#01#00 //empty brick
 else begin
  Result:=Char(MaxX-OffX+1)+Char(MaxY-OffY+1)+Char(OffX)+Char(OffY);
  for b:=OffY to MaxY do begin
   PixCount:=0;  //sub-line pixel count
   SLCount:=0;   //sub-line count
   SLMode:=0;    //sub-line mode
   PixBuf:='';   //column (pixel) buffer
   LineBuf:='';  //line buffer
   SLMode:=PixType(BB,OffX,MaxX,OffX,b);
   for a:=OffX to MaxX do begin
    If a<MaxX then NewMode:=PixType(BB,OffX,MaxX,a+1,b) else NewMode:=5;

    If SLMode=3 then PixBuf:=PixBuf+Char(BB[a,b]);
    Inc(PixCount);

    If (NewMode<>SLMode) then begin
     case SLMode of
      1:If BB[a,b]=0 then LineBuf:=LineBuf+Char((PixCount-1) and $3F)
        else LineBuf:=LineBuf+Char(((PixCount-1) and $3F) or $80)+Char(BB[a,b]);
      3:begin
         LineBuf:=LineBuf+Char(((PixCount-1) and $3F) or $40)+PixBuf;
        end;
      4:LineBuf:=LineBuf+#00;
     end;
     Inc(SLCount);
     PixBuf:='';
     PixCount:=0;
     If NewMode=2 then SLMode:=1 else SLMode:=NewMode;
    end;
   end;
   Result:=Result+Char(SLCount)+LineBuf;
  end;
 end;
end;

function InsideBrick(x, y: Integer; sTop, sLeft, sRight: Boolean): Boolean;
begin
 Result:=(sTop and (x>=y*2-22) and (x<=y*2+25) and (x>=-y*2+22) and (x<=-y*2+69))
      or (sLeft and (x>=y*2-52) and (x<=y*2-23) and (x>=0) and (x<=23))
      or (sRight and (x>=24) and (x<=47) and (x>=-y*2+70) and (x<=-y*2+99));
end;

procedure DrawBitBrick(Brk: TBitBrick; x, y: Integer; bit: TBitmap);
begin
 DrawBitBrick(Brk, x, y, bit, InvertPal);
end;

procedure DrawBitBrick(Brk: TBitBrick; x, y: Integer; bit: TBitmap;
  pal: TPalette);
var a, b, c, d: Integer;
    ab, ae: Integer;
begin
 ab:= Max(0, -x);
 ae:= Min(47, bit.Width - x - 1);
 for b:= Max(0, -y) to Min(37, bit.Height-y-1) do
   for a:= ab to ae do begin
     c:= a + x;
     d:= b + y;
     if Brk[a,b] > 0 then
       DWord(Pointer(Integer(bit.ScanLine[d]) + c*4)^):= pal[Brk[a,b]];
   end;
end;

Procedure BufferBrick(Nr: DWord);
begin
 if not BrickToBitBrick(UnpackToString(VBricks[Nr+BrkOffset]), bitBuffers[Nr])
 and not BadBrickMessage then begin
   fmMain.cbBadBricks.AddItem(IntToStr(Nr + 1), nil);
   fmMain.paBadBricks.Visible:= True;
   Application.MessageBox('Data of one of the Bricks is corrupted!'#13'The unreadable Brick parts have been fileld with a two-colour pattern.',
     'LBArchitect', MB_ICONERROR + MB_OK);
   BadBrickMessage:= True;
 end;
 Buffered[Nr]:= True;
 Inc(Allocated);
end;

procedure SetMenuBrk(ext: String);
var a: Integer;
begin
 SingleBrick:= ext = '.brk';
 fmMain.mLockBrick.Enabled:= not SingleBrick;
 If SingleBrick then begin
   fmMain.mLockBrick.Checked:= True;
   fmMain.mLockBrickClick(fmMain);
   fmMain.LibTab.TabVisible:= False;
   fmMain.mSaveBrk.Caption:= 'Save Brick';
   fmMain.mSaveBrkAs.Caption:= 'Save Brick as...';
 end else begin
   fmMain.LibTab.TabVisible:= (Length(Lib) > 0) and (BrkCount > 0);
   fmMain.mSaveBrkAs.Caption:= 'Save Bricks as...';
   fmMain.mSaveBrk.Caption:= 'Save Bricks';
 end;
 fmMain.pcContent.ActivePageIndex:= 0;
 SetLength(Buffered, BrkCount);
 SetLength(bitBuffers, BrkCount);
 Allocated:= 0;
 for a:= 0 to High(Buffered) do Buffered[a]:= False;
 SetTabCaptions();
 fmMain.paSplash.Visible:= False;
 fmMain.paMain.Visible:= True;
 SetScrollBrk();
 BrkSelect:= 0;
 BricksModified:= False;
 UpdateInfo();
 EnableSaveMenu();
 PaintBricks();
 PaintLayouts();
end;

procedure OpenBricks(path: String);
var FStr: TFileStream;
    p: TSmallPoint;
    ext, s: String;
    a: Integer;
begin
 path:= Trim(path);
 If not FileExists(path) then begin
   MessageBox(fmMain.handle,PChar('File "'+path+'" not found !'),'LBArchitect',MB_ICONERROR+MB_OK);
   Exit;
 end;
 if not CloseScenario() then Exit;
 ext:= LowerCase(ExtractFileExt(path));
 If (ext <> '.brk') and (ext <> '.hqr') then begin
   MessageBox(fmMain.Handle,'Unknown extension!','LBArchitect',MB_ICONERROR+MB_OK);
   Exit;
 end;
 ProgBarForm.ShowSpecial('Loading...',fmMain,True);
 FStr:= TFileStream.Create(path,fmOpenRead,fmShareDenyWrite);
 If ext = '.brk' then begin
  SetLength(VBricks,1);
  SetLength(s,FStr.Size);
  FStr.Read(s[1],FStr.Size);
  VBricks[0]:= PackEntry(s);
  BrkOffset:= 0;
  BrkCount:= 1;
 end
 else {if ext='.hqr' then} begin
  if IsBkg(path) then begin
    p:= BkgEntriesCount(FStr,itBricks);
    BrkOffset:= p.x-1;
    BrkCount:= p.y;
    VBricks:= OpenPack(FStr);
    If fmMain.mAutoPal.Checked then ChangePalette(False,False);
  end
  else begin
    VBricks:= OpenPack(FStr);
    BrkOffset:= 0;
    BrkCount:= Length(VBricks);
    If fmMain.mAutoPal.Checked then ChangePalette(True,False);
  end;
 end;
 FStr.Free();
 BrkPath:= path;
 BricksOpened:= True;
 SetMenuBrk(ext);
 ProgBarForm.CloseSpecial();
end;

procedure NewBrick(Single: Boolean);
begin
 CheckSaved(True,False);
 BrkOffset:= 0;
 BrkPath:= '';
 If Single then begin
   SetLength(VBricks,1);
   VBricks[0]:= PackEntry(#01#01#23#18#01#00); //empty brick
   BrkCount:= 1;
   SetMenuBrk('.brk');
 end
 else begin
   SetLength(VBricks,0);
   BrkCount:= 0;
   SetMenuBrk('.hqr');
   fmMain.mLockBrick.Checked:= False;
   fmMain.mLockBrickClick(nil);
 end;
 BricksOpened:= True;
end;

procedure SaveBricks(path: String);
begin
 If ExtIs(path,'.hqr') then begin
  ProgBarForm.ShowSpecial('Saving Bricks...',fmMain,True);
  Screen.Cursor:= crHourGlass;
  If IsBkg(path) then BkgHeadFix(VBricks,-1,-1,-1,BrkCount,-1);
  SavePackToFile(VBricks,path);
  Screen.Cursor:= crDefault;
  ProgBarForm.CloseSpecial();
 end
 else
  SaveBrick(bitBuffers[0],path);
 SetTabCaptions;
 BricksModified:= False;
 BrkPath:= path;
 Beep;
end;

procedure SaveBrick(Brick: TBitBrick; path: String);
var S: String;
    f: File;
begin
 S:= BitBrickToBrick(Brick);
 AssignFile(f, path);
 FileMode:= fmOpenWrite;
 Rewrite(f, 1);
 BlockWrite(f, S[1], Length(S));
 CloseFile(f);
end;

procedure ExportBrick(Brick: TBitBrick);
begin
 with EditForm.dlSave do begin
  InitialDir:= LastExportPath;
  If Execute then begin
   LastExportPath:= ExtractFilePath(FileName);
   SaveBrick(Brick, FileName);
  end;
 end;
end;

procedure DrawBrick(x, y, nr: Integer; dest: TBitmap; text, frame: Boolean);
var snr: String;
begin
 if BrkCount - 1 < nr then Exit;
 if frame then BackFrame(x, y, dest.Canvas);
 if not Buffered[nr] then BufferBrick(nr);
 DrawBitBrick(bitBuffers[nr], x, y, dest);
 if frame then FrontFrame(x, y, Dest.Canvas);
 if text then begin
   dest.Canvas.Brush.Style:= bsClear;
   snr:= IntToStr(nr + 1);
   dest.Canvas.TextOut(x-dest.Canvas.TextWidth(snr)+48,
     y-dest.Canvas.TextHeight(snr)+40, snr);
 end;
end;

procedure PaintBrick(x, y, nr: Integer; dest: TBitmap; Sel, text, frame: Boolean);
begin
 if BrkCount-1<nr then Exit;
 if Sel then dest.Canvas.Brush.Color:= clSkyBlue
 else dest.Canvas.Brush.Color:= clBtnFace;
 dest.Canvas.Pen.Color:= clGray;
 dest.Canvas.Rectangle(x, y, x+52, y+42);
 DrawBrick(x+2, y+2, nr, dest, text, frame);
end;

procedure PaintBricks();
var a, Start: Integer;
    frame, text: Boolean;
begin
 With fmMain do begin
   text:= mIndexes.Checked;
   frame:= mFrames.Checked;
   Start:= sbBricks.Position;
   //imgBrick.Canvas.Pen.Color:=clGray;
   GetBrkPerRow();
   bufBrick.Canvas.Brush.Color:= clBtnFace;
   bufBrick.Canvas.FillRect(bufBrick.Canvas.ClipRect);
   for a:= 0 to BrkPerRow * ((bufBrick.Height div 41)+1) - 1 do
     PaintBrick((a mod BrkPerRow)*51, (a div BrkPerRow)*41, a+Start*BrkPerRow,
       bufBrick, a+Start*BrkPerRow=BrkSelect, text, frame);
   UpdateImage(bufBrick, pbBrick);
   lbAllocCnt.Caption:= 'Allocated: ' + IntToStr(Allocated);
 end;
end;

procedure SaveBoth(path: String; Index: Integer);
var s: String;
begin
 If not (IsBkg(BrkPath) and IsBkg(LibPath) and SameText(BrkPath,LibPath)) then Exit;
 ProgBarForm.ShowSpecial('Saving...', fmMain, True);
 Screen.Cursor:= crHourGlass;

 s:= LibraryToString(Lib);
 LLba1:= False;
 VBricks[Index]:= PackEntry(s);

 BkgHeadFix(VBricks,-1,-1,-1,BrkCount,-1);
 SavePackToFile(VBricks,path);

 LayoutsModified:= False;
 LibPath:= path;
 LibIndex:= Index;
 BricksModified:= False;
 BrkPath:= path;

 SetTabCaptions;
 Screen.Cursor:= crDefault;
 ProgBarForm.CloseSpecial();
 Beep;
end;

procedure ShowBrickEditor(Nr: DWord);
var a, b: Integer;
begin
 BrickMode:= True;
 If not Buffered[Nr] then BufferBrick(Nr-1);
 LtX:= 1;
 LtY:= 1;
 LtZ:= 1;
 SetVarBrick(bitImage,48,38);
 for b:= 0 to 37 do
  for a:= 0 to 47 do
   bitImage.Image[a,b]:= bitBuffers[Nr][a,b];
 ClearSelection;
 EditForm.FormResize(EditForm);
 SetScrolls(True);
 EditForm.Caption:= 'Image Editor - Brick #' + IntToStr(Nr+1);
 If EditForm.ShowModal = mrOK then begin
  for b:= 0 to 37 do
   for a:= 0 to 47 do
    If PointInBrick(a,b) then bitBuffers[Nr][a,b]:=bitImage.Image[a,b]
    else bitBuffers[Nr][a,b]:=0;
  VBricks[Nr+BrkOffset]:=PackEntry(BitBrickToBrick(bitBuffers[Nr]));
  BricksModified:=True;
  PaintBricks();
  PaintLayouts();
 end;
end;

Procedure UpdateInfo();
var a, b: byte;
    i: array[1..4] of Byte;
begin
 fmMain.lbBrkCount.Caption:= 'Bricks: ' + IntToStr(BrkCount);
 fmMain.lbAllocCnt.Caption:= 'Allocated: ' + IntToStr(Allocated);
 fmMain.lbLtCount.Caption:= 'Layouts: ' + IntToStr(Length(Lib));
 case fmMain.pcContent.ActivePageIndex of
  0: If BrkCount > 0 then begin
      If Byte(VBricks[BrkSelect+BrkOffset].Data[1]) = 255 then b:= 1 else b:= 0;
      for a:= 1 to 4 do i[a]:= Byte(VBricks[BrkSelect+BrkOffset].Data[a+b]);
      fmMain.lbInfo.Caption:= Format('Brick: %d'#13#13'Width (x): %d'#13
        +'Height (y): %d'#13#13'Offset X: %d'#13'Offset Y: %d',
        [BrkSelect+1,i[1],i[2],i[3],i[4]]);
     end;
  1: If Length(Lib) > 0 then
      fmMain.lbInfo.Caption:= Format('Layout: %d'#13#13'Width (x): %d'#13
        +'Height (y): %d'#13'Depth (z): %d'#13#13'Offset: %d',
        [LtSelect+1,Lib[LtSelect].X,Lib[LtSelect].Y,Lib[LtSelect].Z,Lib[LtSelect].Offset]);
      //Form1.Label14.Caption:=IntToHex(Lib[nr].Map[0,0,0].Sound,2)+#13'Uses Bricks:';
      //for a:=0 to High(Lib[nr].Map) do
      // If Lib[nr].Map[a].Index>0 then
      //  Form1.Label14.Caption:=Form1.Label14.Caption+#13+Format('%d',[Lib[nr].Map[a].Index]);
 end;
end;

end.
