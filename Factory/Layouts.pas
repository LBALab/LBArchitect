//******************************************************************************
// Little Big Architect: Factory - editing brick and layout files from
//                                 Little Big Adventure 1 & 2
//
// Layouts unit.
// Contains routines that allow loading and converting Layouts.
//
// Copyright Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit Layouts;

interface

uses Windows, Engine, DePack, Graphics, Classes, SysUtils, Bricks, StrUtils, Math,
 Controls, Libraries, Forms, ListForm;

var
 Lib: TCubeLib;
 LibPath: String;
 LibIndex: Integer = 0;
 LLba1: Boolean = True;
 SingleLayout: Boolean; //if it is a single layout or a library

 LtSelect: Integer = 1;

 LtSort: array of array of Integer;
 LtMap: array of array of Integer;
 LtDim: array of TPoint;
 LtPos: array of TPoint;
 LayoutsModified: Boolean = False;

Procedure SetScrollLt(ChangeMax: Boolean);
function LayoutToVarBrick(Lt: TCubeLt): TVarBrick;
procedure LayoutToBricks(Lt: TCubeLt; Brk: TVarBrick);
procedure CalcDimensions();
procedure MapLayouts();
procedure CalcPositions();
procedure AnalyzeLayouts();
Procedure SetMenuLt(ext: String; Preload: Boolean = False);
function OpenLibrary(path: String; Index: Integer = -1; Preload: Boolean = False): Boolean;
procedure NewLayout(Single, Lba1: Boolean);
//procedure NewBkg;
Procedure LoadLibrary(path: String);
procedure ExportLayout(Lt: TCubeLt);

Procedure DrawLayout(x, y, nr: Integer; dest: TBitmap; frames, index: Boolean);

procedure DrawLayoutNoBuf(x, y: Integer; Lay: TCubeLt; Brk: TPackEntries;
  BrkOffset: Integer; dest: TBitmap; frame, shape: Boolean); overload;
//MapPal enables palette mapping of the Bricks. If true, they will be converted
//  from their original palette to the local palette (Palette var in Bricks.pas)
//  before drawing. In this case the pal parameter is not a real palette, but a map:
//  values are not colours, but indexes of the closest matching colours from the
//  Palette.
procedure DrawLayoutNoBuf(x, y: Integer; Lay: TCubeLt; Brk: TPackEntries;
  BrkOffset: Integer; dest: TBitmap; frame, shape: Boolean; pal: TPalette;
  MapPal: Boolean = False); overload;

procedure PaintLayout(x, y, nr: Integer; dest: TBitmap; Sel, frames: Boolean);
procedure SortLts();
procedure PaintLayouts();
procedure SaveLayouts(path: String; Index: Integer);
procedure ShowLayoutEditor(Nr: Byte);
Function CreateBricks(count: Integer): Integer;
function CreateLayout(x, y, z: Integer; eid: Integer = -1): Integer;

function InsertLayout(Lt: TCubeLt; Brk: TPackEntries; BrkOff: Integer;
  Index: Integer = -1): Integer; overload;
function InsertLayout(Lt: TCubeLt; Brk: TPackEntries; BrkOff: Integer;
  MappedPal: TPalette; Index: Integer = -1): Integer; overload;

procedure RefreshLayouts(id: Integer; BricksMod: Boolean = True);
procedure NewLayoutEditor(x, y, z: Integer);

implementation

uses Main, StructEd, OptPanel, Editor, Scenario, Utils;

Procedure SetScrollLt(ChangeMax: Boolean);
var a, MaxH, MaxLt, ThisLt: Integer;
begin
 If (Length(LtMap)<1) or (Length(LtDim)<1) then Exit;
 MaxH:=0;
 for a:=0 to High(LtMap[High(LtMap)]) do begin
  ThisLt:=LtMap[High(LtMap)][a];
  if LtDim[ThisLt].Y>MaxH then begin
   MaxH:=LtDim[ThisLt].Y;
   MaxLt:=ThisLt;
  end;
 end;

 if MaxH+LtPos[MaxLt].Y+3 > fmMain.pbLayout.Height then begin
   if ChangeMax then fmMain.sbLayouts.Max:= MaxH+LtPos[MaxLt].Y+3;
   fmMain.sbLayouts.PageSize:= fmMain.pbLayout.Height;
   fmMain.sbLayouts.LargeChange:= fmMain.sbLayouts.PageSize;
   fmMain.sbLayouts.Enabled:= True;
 end else begin
   fmMain.sbLayouts.Position:= 0;
   fmMain.sbLayouts.Enabled:= False;
 end; 
end;

function LayoutToVarBrick(Lt: TCubeLt): TVarBrick;
var a, b, c, d, e, rX, rY, BrkIndex: Integer;
    Brk: TBitBrick;
begin
 SetVarBrick(Result,GetLtWidth(Lt),GetLtHeight(Lt));
 FillVarBrick(Result,0);
 for c:=0 to Lt.Z-1 do
  for b:=0 to Lt.Y-1 do
   for a:=0 to Lt.X-1 do begin
    BrkIndex:=Lt.Map[a,b,c].Index-1;
    If BrkIndex>-1 then begin
     GridToPosVar(a,b,c,(Lt.Z-1)*24,(Lt.Y-1)*15,rX,rY);
     If not Buffered[BrkIndex] then BufferBrick(BrkIndex);
     Brk:=BitBuffers[BrkIndex];
     for e:=0 to 37 do
      for d:=0 to 47 do
       If Brk[d,e]>0 then Result.Image[d+rX,e+rY]:=Brk[d,e];
    end;
   end;
end;

procedure LayoutToBricks(Lt: TCubeLt; Brk: TVarBrick); //Brk is the Layout image
var a, b, c, d, e, rX, rY, BrkId, offX, offY: Integer;
begin
 offX:=(Lt.Z-1)*24;
 offY:=(Lt.Y-1)*15;
 for c:=0 to Lt.Z-1 do
  for b:=0 to Lt.Y-1 do
   for a:=0 to Lt.X-1 do begin
    If (a=Lt.X-1) or (b=Lt.Y-1) or (c=Lt.Z-1) then begin
     BrkId:=Lt.Map[a,b,c].Index-1;
     If BrkId>=0 then begin
      GridToPosVar(a,b,c,offX,offY,rX,rY);
      for e:=0 to 37 do
       for d:=0 to 47 do
        If InsideBrick(d,e,b=Lt.Y-1,c=Lt.Z-1,a=Lt.X-1) then
         bitBuffers[BrkId][d,e]:=Brk.Image[d+rX,e+rY];
      VBricks[BrkId+BrkOffset]:=PackEntry(BitBrickToBrick(bitBuffers[BrkId]));
     end;
    end;
   end;
end;

procedure CalcDimensions();
var a: Integer;
begin
 SetLength(LtDim, Length(Lib));
 if Length(Lib) < 1 then Exit;
 LtDim[0]:= Point(0,0);
 for a:= 0 to High(Lib) do
   LtDim[a]:= Point(GetLtWidth(Lib[a]), GetLtHeight(lib[a]));
end;

function FindMaxLt(he, Limit: Integer; LtUsed: TBoolDynAr): Integer;
var MaxW, LtW, a: Integer;         //-1: limit too small, -2: no more objects in line
    Obj: Boolean;
begin
 MaxW:= -1;
 Result:= -1;
 Obj:= False;
 for a:= 0 to High(LtSort[he]) do
   if not LtUsed[LtSort[he][a]] then begin
     LtW:= LtDim[LtSort[he][a]].X;
     if (LtW > MaxW) and (LtW <= Limit) then begin
       MaxW:= LtW;
       Result:= LtSort[he][a];
     end;
     Obj:= True;
   end;
 if not Obj then Result:= -2;
end;

procedure MapLayouts();
var a, line, ScrW, ThisW, MaxLt, Limit, lh, libh: Integer;
    LtUsed: TBoolDynAr;
begin
 if Length(Lib) < 1 then Exit;
 ScrW:= fmMain.pbLayout.Width;
 SetLength(LtMap, 0);
 ThisW:= 0;
 line:= 0;
 lh:= -1;
 if fmMain.btSortSize.Down then begin
   SetLength(LtUsed, Length(Lib));
   for a:= 0 to High(LtUsed) do LtUsed[a]:= False;
   Limit:= 999999;
   for a:= 3 to High(LtSort) do begin
     if Length(LtSort[a]) < 1 then Continue;

     MaxLt:= FindMaxLt(a, Limit, LtUsed);
     if MaxLt = -1 then begin
       Inc(line);
       lh:= -1;
       Limit:= 999999;
       ThisW:= 0;
       MaxLt:= FindMaxLt(a, Limit, LtUsed);
     end;
     while MaxLt >= 0 do begin
       if (High(LtMap) < line) then SetLength(LtMap, line + 1);
       Inc(lh);
       SetLength(LtMap[line], lh + 1);
       LtMap[line, lh]:= MaxLt;
       LtUsed[MaxLt]:= True;
       Inc(ThisW, LtDim[MaxLt].X + 3);

       Limit:= ScrW - ThisW - 3;
       MaxLt:= FindMaxLt(a, Limit, LtUsed);
       if MaxLt = -1 then begin
         Inc(line);
         lh:= -1;
         Limit:= 999999;
         ThisW:= 0;
         MaxLt:= FindMaxLt(a, Limit, LtUsed);
       end;
     end;
   end;
 end else begin
   {SetLength(LtMap, Length(Lib), 1);
   for a:= 0 to High(LtMap) do
     LtMap[a,0]:= a;}
   //Antoher approach: use the spare window width
   SetLength(LtMap, 1);
   libh:= High(Lib);
   for a:= 0 to libh do begin
     Inc(lh);
     SetLength(LtMap[line], lh + 1);
     LtMap[line, lh]:= a;
     Inc(ThisW, LtDim[a].X + 3);
     if a < libh then begin
       if ThisW + LtDim[a+1].X + 3 > ScrW then begin
         Inc(line);
         SetLength(LtMap, line + 1);
         lh:= -1;
         ThisW:= 0;
       end;
     end;
   end;
 end;
end;

procedure CalcPositions();
var a, b, line, MaxH, MaxW, LtH: Integer;
begin
 SetLength(LtPos, Length(lib));
 if Length(Lib) < 1 Then Exit;
 line:= 0;
 for a:= 0 to High(LtMap) do begin
   MaxH:= -1;
   MaxW:= 0;
   for b:= 0 to High(LtMap[a]) do begin
     LtPos[LtMap[a][b]]:= Point(MaxW, line);
     Inc(MaxW, LtDim[LtMap[a][b]].X + 3);
     LtH:= LtDim[LtMap[a][b]].Y;
     if LtH > MaxH then MaxH:= LtH;
   end;
   Inc(line, MaxH+3);
 end;
end;

procedure AnalyzeLayouts();
begin
 CalcDimensions();
 SortLts();
 MapLayouts();
 CalcPositions();
end;

Procedure SetMenuLt(ext: String; Preload: Boolean = False);
begin
 SingleLayout:= (ext = '.lt1') or (ext = '.lt2');
 fmMain.mNewLt.Enabled:= not SingleLayout;
 fmMain.mCopyLt.Enabled:= not SingleLayout;
 fmMain.btSortSize.Enabled:= not SingleLayout;
 fmMain.btSortIndex.Enabled:= not SingleLayout;
 fmMain.edGoTo.Enabled:= not SingleLayout;
 fmMain.mChooseEntry.Enabled:= ext = '.hqr';
 If SingleLayout then begin
   fmMain.mSaveLib.Caption:= 'Save Layout';
   fmMain.mSaveLibAs.Caption:= 'Save Layout as...';
 end
 else begin
   fmMain.mSaveLib.Caption:= 'Save Library';
   fmMain.mSaveLibAs.Caption:= 'Save Library as... (single only)';
 end;
 fmMain.lbLtCount.Caption:= Format('Layouts: %d',[Length(Lib)]);
 SetTabCaptions();
 If BricksOpened and not SingleBrick then begin
   fmMain.LibTab.TabVisible:= True;
   fmMain.pcContent.ActivePageIndex:= 1;
 end
 else if not Preload then
   MessageBox(fmMain.Handle,'In order to see and edit Layuts you will have to load or create a Brick HQR (not a single Brick).','Little Big Factory',MB_ICONINFORMATION+MB_OK);
 AnalyzeLayouts();
 SetScrollLt(True);
 If Length(Lib) > 0 then LtSelect:= LtMap[0][0];
 LayoutsModified:= False;
 UpdateInfo();
 EnableSaveMenu();
 PaintLayouts();
end;

function OpenLibrary(path: String; Index: Integer = -1; Preload: Boolean = False): Boolean;
var FStr: TFileStream;
    MStr: TMemoryStream;
    ext: String;
    temp: TPackEntry;
begin
 Result:= False;
 path:= Trim(path);
 If not FileExists(path) then begin
   MessageBox(fmMain.Handle,PChar('File "'+path+'" not found !'),'LBArchitect',MB_ICONERROR+MB_OK);
   Exit;
 end;
 if not CloseScenario() then Exit;
 FStr:= TFileStream.Create(path, fmOpenRead, fmShareDenyWrite);
 try
   ext:= LowerCase(ExtractFileExt(path));
   try
     If (ext = '.bl1') or (ext = '.bl2') then begin
       LLba1:= ext = '.bl1';
       Lib:= LibToCubeLib(LoadLibraryFromStream2(FStr));
       LibIndex:= -1;
       Result:= True;
     end
     else if (ext = '.lt1') or (ext = '.lt2') then begin
       LLba1:= ext = '.lt1';
       SetLength(Lib,1);
       Lib[0]:= ReadLayoutS(FStr);
       LibIndex:= -1;
       Result:= True;
     end
     else if ext = '.hqr' then begin
       LLba1:= not IsBkg(path);
       if OpenSingleEntry(FStr, Index, temp) then begin
         MStr:= UnpackToStream(temp);
         Lib:= LibToCubeLib(LoadLibraryFromStream2(MStr));
         FreeAndNil(MStr);
         LibIndex:= Index;
         Result:= True;
       end else
         ErrorMsg('Library index out of range!');
     end;
     if Result then begin
       LibPath:= path;
       SetMenuLt(ext, Preload);
     end else
       LibPath:= '';
   except
     on Ex: Exception do
       MessageBox(fmMain.Handle,PChar('There was an error during loading the Library!'#13#13+Ex.Message),'LBArchitect',MB_ICONERROR+MB_OK);
   end;
 finally
   FreeAndNil(FStr);
 end;
end;

procedure NewLayout(Single, Lba1: Boolean);
begin
 CheckSaved(False,True);
 LibPath:='';
 If Single then begin
  LLba1:=Lba1;
  SetLength(Lib,0);
  SetVarBrick(bitImage,GetLtWidth(1,1,1),GetLtHeight(1,1,1));
  FillVarBrick(bitImage,0);
  LtX:=1; LtY:=1; LtZ:=1;
  LayoutToBricks(Lib[CreateLayout(1,1,1)],bitImage);
  SetMenuLt('.lt1');
  LayoutsModified:= True;
 end else begin
   SetLength(Lib, 0);
   SetMenuLt('.hqr');
 end;
 fmMain.mLockLib.Checked:= False;
 fmMain.mLockLibClick(nil);
 PaintBricks();
end;

{procedure NewBkg;
begin
 CheckSaved(True,True);
 BrkOffset:=
 LibPath:= '';
 If Single then begin
  LLba1:=Lba1;
  SetLength(Lib,0);
  SetVarBrick(bitImage,GetLtWidth(1,1,1),GetLtHeight(1,1,1));
  FillVarBrick(bitImage,0);
  LtX:=1; LtY:=1; LtZ:=1;
  LayoutToBricks(Lib[CreateLayout(1,1,1)],bitImage);
  SetMenuLt('.lt1');
  LayoutsModified:=True;
 end
 else begin
  SetLength(Lib,0);
  SetMenuLt('.hqr');
 end;
 Form1.mLockLib.Checked:=False;
 Form1.mLockLibClick(nil);
 PaintBricks;
end;}

procedure LoadLibrary(path: String);
var ext: String;
    p: TSmallPoint;
    a: Integer;
begin
 path:= Trim(path);
 ext:= LowerCase(ExtractFileExt(path));
 If ext= '.hqr' then begin
  //p.x:= 1;
  //If IsBkg(path) then p:= BkgEntriesCount(path,weLibs)
  //else p.y:= PackEntriesCount(path);
  //If NumberDialog('Library',p.x,p.y,a) then begin
  If SameText(path,LibPath) then a:= LibIndex
                            else a:= -1;
  a:= HQRListDialog(path, etLibs, not IsBkg(path), Settings.StartWith1, True,
       'Please select a Library from the package:'#13'(only normal entries are shown)', a);
  If a > -1 then begin
    LibIndex:= a;
    OpenLibrary(path,LibIndex);
  end;
 end
 else if (ext = '.bl1') or (ext = '.bl2') or (ext = '.lt1') or (ext = '.lt2') then
   OpenLibrary(path)
 else
   MessageBox(fmMain.Handle,'Unknown extension!','LBArchitect',MB_ICONERROR+MB_OK);
end;

procedure ExportLayout(Lt: TCubeLt);
begin
 with fmStruct.dlSave do begin
  If LLba1 then Filter:= 'LBA 1 Layout file (*.lt1)|*.lt1'
           else Filter:= 'LBA 2 Layout file (*.lt2)|*.lt2';
  If LLba1 then DefaultExt:= 'lt1' else DefaultExt:= 'lt2';
  InitialDir:= LastExportPath;
  If Execute then begin
   LastExportPath:= ExtractFilePath(FileName);
   WriteLayoutF(FileName,Lt);
   SysUtils.Beep();
  end;
 end;
end;

procedure DrawLayout(x, y, nr: Integer; dest: TBitmap; frames, index: Boolean);
var a, b, c, BrkIndex, rX, rY, offX, offY: Integer;
    Lt: TCubeLt;
    snr: String;
    EmptyLayout: Boolean;
begin
 //dest.FillRect(dest.ClipRect);
 if Length(Lib) < 1 then Exit;
 if (BrkCount < 1) or SingleBrick then Exit;
 Lt:= Lib[nr];
 offX:= (Lt.Z - 1) * 24 + x;
 offY:= (Lt.Y - 1) * 15 + 1 + y; //TODO: check if +1 is really necessary, it causes wrong things at some places
 EmptyLayout:= True;
 for c:= 0 to Lt.Z - 1 do
   for b:= 0 to Lt.Y - 1 do
     for a:= 0 to Lt.X - 1 do
       If Lt.Map[a,b,c].Index > 0 then begin EmptyLayout:= False; Break; end;
 for c:= 0 to Lt.Z - 1 do
   for b:= 0 to Lt.Y - 1 do
     for a:= 0 to Lt.X - 1 do begin
       BrkIndex:= Lt.Map[a,b,c].Index - 1;
       if (BrkIndex > -1) or EmptyLayout then begin
         GridToPosVar(a, b, c, offX, offY, rX, rY);
         if fmMain.mShapes.Checked then ShapeBFrame(rX, rY, dest. Canvas, clYellow, Lt.Map[a,b,c].Shape);
         if BrkIndex > -1 then
           DrawBrick(rX, rY, BrkIndex, dest, false, frames)
         else begin
           BackFrame(rX, rY, dest.Canvas);
           FrontFrame(rX, rY, dest.Canvas);
         end;
         If fmMain.mShapes.Checked then ShapeFFrame(rX, rY, dest.Canvas, clYellow, Lt.Map[a,b,c].Shape);
       end;
     end;
 if index then begin
   dest.Canvas.Brush.Style:= bsClear;
   snr:= IntToStr(nr + 1);
   dest.Canvas.TextOut(x + LtDim[nr].X - dest.Canvas.TextWidth(snr),
                       y + LtDim[nr].Y - dest.Canvas.TextHeight(snr) + 2, snr);
 end;
end;

procedure DrawLayoutNoBuf(x, y: Integer; Lay: TCubeLt; Brk: TPackEntries;
  BrkOffset: Integer; dest: TBitmap; frame, shape: Boolean);
begin
 DrawLayoutNoBuf(x, y, Lay, Brk, BrkOffset, dest, frame, shape, InvertPal);
end;

procedure DrawLayoutNoBuf(x, y: Integer; Lay: TCubeLt; Brk: TPackEntries;
  BrkOffset: Integer; dest: TBitmap; frame, shape: Boolean; pal: TPalette;
  MapPal: Boolean = False);
var a, b, c, BrkIndex, rX, rY, offX, offY, d, e: Integer;
    snr: String;
    EmptyLayout: Boolean;
    Buff: TBitBrick;
begin
 if Length(Brk) < 1 then Exit;
 offX:= (Lay.Z - 1) * 24 + x;
 offY:= (Lay.Y - 1) * 15 + 1 + y; //TODO: check if +1 is really necessary, it causes wrong things at some places
 EmptyLayout:= True;
 for c:= 0 to Lay.Z - 1 do
   for b:= 0 to Lay.Y - 1 do
     for a:= 0 to Lay.X - 1 do
       If Lay.Map[a,b,c].Index > 0 then begin EmptyLayout:= False; Break; end;
 for c:= 0 to Lay.Z - 1 do
   for b:= 0 to Lay.Y - 1 do
     for a:= 0 to Lay.X - 1 do begin
       BrkIndex:= Lay.Map[a,b,c].Index - 1;
       if (BrkIndex > -1) or EmptyLayout then begin
         GridToPosVar(a, b, c, offX, offY, rX, rY);
         if shape then ShapeBFrame(rX, rY, dest.Canvas, clYellow, Lay.Map[a,b,c].Shape);
         if BrkIndex > -1 then begin
           if frame then BackFrame(x, y, dest.Canvas);
           if BrickToBitBrick(UnpackToString(Brk[BrkIndex+BrkOffset]), Buff) then begin
             if MapPal then begin
               for d:= 0 to 47 do
                 for e:= 0 to 37 do
                   Buff[d,e]:= pal[Buff[d,e]]; //palette mapping
             end;
             DrawBitBrick(Buff, rX, rY, dest);
           end;
           if frame then FrontFrame(x, y, dest.Canvas);
         end else begin
           BackFrame(rX, rY, dest.Canvas);
           FrontFrame(rX, rY, dest.Canvas);
         end;
         if shape then ShapeFFrame(rX, rY, dest.Canvas, clYellow, Lay.Map[a,b,c].Shape);
       end;
     end;
end;

procedure PaintLayout(x, y, nr: Integer; dest: TBitmap; Sel, frames: Boolean);
begin
 //If (Lib[nr].X<1) or (Lib[nr].Y<1) or (Lib[nr].Z<1) then Exit;
 if Sel then dest.Canvas.Brush.Color:= clSkyBlue
 else dest.Canvas.Brush.Color:= clBtnFace;
 dest.Canvas.Pen.Color:= clGray;
 dest.Canvas.Rectangle(x, y, x + LtDim[nr].X + 4, y + LtDim[nr].Y + 4);
 DrawLayout(x+2, y+2, nr, dest, frames, fmMain.mIndexes.Checked and not SingleLayout);
end;

//LtSort table - contains Layouts (indexes) grouped and sorted by the sum of their Brick dimensions
procedure SortLts();
var a, he: Integer;
begin
 if Length(Lib) < 1 then Exit;
 SetLength(LtSort, 0);
 for a:= 0 to High(Lib) do begin
   he:= Lib[a].Y + Lib[a].X + Lib[a].Z;
   if High(LtSort) < he then SetLength(LtSort, he+1);
   SetLength(LtSort[he], Length(LtSort[he])+1);
   LtSort[he][High(LtSort[he])]:= a;
 end;
end;

procedure PaintLayouts();
var a, Start: Integer;
    frames: Boolean;
begin
 with fmMain do begin
   frames:= mFrames.Checked;
   Start:= sbLayouts.Position;
   bufLayout.Canvas.Brush.Color:= clBtnFace;
   bufLayout.Canvas.FillRect(bufLayout.Canvas.ClipRect);
   for a:= 0 to High(Lib) do
     if (LtPos[a].Y - Start + LtDim[a].Y >= -2) and (LtPos[a].Y-Start < bufLayout.Height - 1) then
       PaintLayout(LtPos[a].X, LtPos[a]. Y- Start, a, bufLayout, a = LtSelect, frames);
   UpdateImage(bufLayout, pbLayout);
   lbAllocCnt.Caption:= 'Allocated: ' + IntToStr(Allocated);
 end;
end;

procedure SaveLayouts(path: String; Index: Integer);
var ext, s: String;
    f: File;
    VLibrary: TPackEntries;
begin
 ext:=LowerCase(ExtractFileExt(path));
 If (ext='.lt1') or (ext='.lt2') then begin
  LLba1:=ext='.lt1';
  WriteLayoutF(path,Lib[0]);
 end
 else if ext = '.hqr' then begin
  s:= LibraryToString(Lib);
  LLba1:= not IsBkg(path);
  VLibrary:= OpenPack(path);
  VLibrary[Index]:= PackEntry(s);
  If IsBkg(path) then BkgHeadFix(VLibrary,-1,-1,-1,-1,-1);
  SavePackToFile(VLibrary,path);
 end
 else begin  //bl1, bl2
  s:= LibraryToString(Lib);
  LLba1:= ext = '.bl1';
  AssignFile(f,path);
  Rewrite(f,1);
  BlockWrite(f,s[1],Length(s));
  CloseFile(f);
 end;
 LayoutsModified:= False;
 LibPath:= path;
 LibIndex:= Index;
 SetTabCaptions;
 SysUtils.Beep;
end;

procedure ShowLayoutEditor(Nr: Byte);
var a, b, c: Integer;
begin
 BrickMode:=False;
 bitImage:=LayoutToVarBrick(Lib[Nr]);
 LtX:=Lib[Nr].X;
 LtY:=Lib[Nr].Y;
 LtZ:=Lib[Nr].Z;

 EditForm.Label1.Caption:='';
 for c:=0 to LtZ-1 do
  for b:=0 to LtY-1 do
   for a:=0 to LtX-1 do begin
    If Lib[Nr].Map[a,b,c].Index>0 then begin
     If EditForm.Label1.Caption<>'' then EditForm.Label1.Caption:=EditForm.Label1.Caption+', '
     else EditForm.Label1.Caption:=EditForm.Label1.Caption+'You are editing Bricks: ';
     EditForm.Label1.Caption:=EditForm.Label1.Caption+IntToStr(Lib[Nr].Map[a,b,c].Index);
    end;
   end;
 EditForm.Label1.Hint:=EditForm.Label1.Caption;

 ClearSelection;
 EditForm.FormResize(EditForm);
 SetScrolls(True);
 EditForm.Caption:='Image Editor - Layout #'+IntToStr(Nr+1);
 If EditForm.ShowModal=mrOK then begin
  LayoutToBricks(Lib[Nr],bitImage);
  BricksModified:=True;
  PaintLayouts;
  PaintBricks;
 end;
end;

//Creates a number of Bricks specified by count. Returns index of the first one.
function CreateBricks(count: Integer): Integer;
begin
 Result:= BrkCount;
 SetLength(VBricks, Length(VBricks) + count);
 Inc(BrkCount, count);
 if not LLba1 then VBricks[High(VBricks)]:= VBricks[High(VBricks)-count];
 SetLength(Buffered, BrkCount);
 SetLength(bitBuffers, BrkCount);
end;

//Creates a new Layout and Bricks for it. Returns index of the new Layout in the
//Lib array. If eid > -1 then doesn't create a new Layout, but new Bricks only
//for the Layout of given id. X, y and z must be provided anyway.
function CreateLayout(x, y, z: Integer; eid: Integer = -1): Integer;
var a, b, c, id, cnt: Integer;
begin
 if eid = -1 then begin
   id:= Length(Lib);
   SetLength(Lib, id+1);
   Lib[id].X:= x;
   Lib[id].Y:= y;
   Lib[id].Z:= z;
   SetLength(Lib[id].Map ,Lib[id].X, Lib[id].Y, Lib[id].Z);
 end else
   id:= eid;

 cnt:= CreateBricks(x*y + y*z + z*x - x - y - z + 1) + 1;
 for c:= 0 to z-1 do
   for b:= 0 to y-1 do
     for a:= 0 to x-1 do begin
       if eid = -1 then begin
         Lib[id].Map[a,b,c].Shape:= 1;
         Lib[id].Map[a,b,c].Sound:= IfThen(LLba1, $F0, 0);
       end;
       if (a = x-1) or (b = y-1) or (c = z-1) then begin
         Lib[id].Map[a,b,c].Index:= cnt;
         Inc(cnt);
       end else
         Lib[id].Map[a,b,c].Index:= 0;
     end;
 Result:= id;
end;

//Adds given Layout with its Bricks to the current Library.
//If Index >= 0, replaces existing Layout at specified Index.
//Returns index of the new Layout, or -1 if failed
function InsertLayout(Lt: TCubeLt; Brk: TPackEntries; BrkOff: Integer;
  Index: Integer = -1): Integer;
var a, b, c, obid, nbid: Integer;
begin
 if Index = -1 then begin
   if Length(Lib) >= 255 then begin
     Result:= -1;
     Exit;
   end;
   Result:= Length(Lib);
   SetLength(Lib, Result+1);
 end else
   Result:= Index;

 Lib[Result]:= Lt;

 for c:= 0 to Lib[Result].Z - 1 do
   for b:= 0 to Lib[Result].Y - 1 do
     for a:= 0 to Lib[Result].X - 1 do begin
       obid:= Lib[Result].Map[a,b,c].Index - 1;
       if obid >= 0 then begin
         nbid:= CreateBricks(1);
         VBricks[nbid]:= Brk[BrkOff + obid];
         Lib[Result].Map[a,b,c].Index:= nbid + 1;
       end;
     end;
end;

function InsertLayout(Lt: TCubeLt; Brk: TPackEntries; BrkOff: Integer;
  MappedPal: TPalette; Index: Integer = -1): Integer;
var a, b, c, d, e, obid, nbid: Integer;
    Buf: TBitBrick;
begin
 if Index = -1 then begin
   if Length(Lib) >= 255 then begin
     Result:= -1;
     Exit;
   end;
   Result:= Length(Lib);
   SetLength(Lib, Result+1);
 end else
   Result:= Index;

 Lib[Result]:= Lt;

 for c:= 0 to Lib[Result].Z - 1 do
   for b:= 0 to Lib[Result].Y - 1 do
     for a:= 0 to Lib[Result].X - 1 do begin
       obid:= Lib[Result].Map[a,b,c].Index - 1;
       if obid >= 0 then begin
         Inc(obid, BrkOff);
         nbid:= CreateBricks(1);
         if BrickToBitBrick(UnpackToString(Brk[obid]), Buf) then begin //palette mapping
           for d:= 0 to 47 do
             for e:= 0 to 37 do
               Buf[d,e]:= MappedPal[Buf[d,e]] and $FF; //just in case
           VBricks[nbid]:= PackEntry(BitBrickToBrick(Buf));
         end else
           VBricks[nbid]:= Brk[obid];
         Lib[Result].Map[a,b,c].Index:= nbid + 1;
       end;
     end;
end;

procedure RefreshLayouts(id: Integer; BricksMod: Boolean = True);
begin
 LayoutsModified:= True;
 AnalyzeLayouts();
 SetScrollLt(True);
 if Id > -1 then begin
   LtSelect:= id;
   fmMain.sbLayouts.Position:= LtPos[LtSelect].Y;
 end;
 UpdateInfo();
 PaintLayouts();
 If BricksMod then begin
   BricksModified:= True;
   SetScrollBrk();
   PaintBricks();
 end;
end;

procedure NewLayoutEditor(x, y, z: Integer);
var id: Integer;
begin
 BrickMode:=False;
 SetVarBrick(bitImage,GetLtWidth(x,y,z),GetLtHeight(x,y,z));
 FillVarBrick(bitImage,0);
 LtX:=x;
 LtY:=y;
 LtZ:=z;

 EditForm.Label1.Caption:='You are creating a new Layout';
 EditForm.Label1.Hint:='';

 ClearSelection;
 EditForm.FormResize(EditForm);
 SetScrolls(True);
 EditForm.Caption:='Image Editor - Creating a new Layout';
 If EditForm.ShowModal=mrOK then begin
  id:=CreateLayout(x,y,z);
  LayoutToBricks(Lib[id],bitImage);
  RefreshLayouts(id);
  EnableSaveMenu;
 end;
end;

end.
