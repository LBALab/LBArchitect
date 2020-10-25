//**********************************************************************************
// This is unit that changes some Delphi components' look.
// These components are:
//  MainMenu: better look, similar to Office XP
//  PopupMenu: same as above
//  ScrollBar: no visible change, but some bugs fixed
//
// In order to use this unit you have to add it to your program's "uses" list
// (in the main project file), and call "UpdateComponents" procedure just before
// the "Application.Run" line. This procedure will search for all Menus, ToolBars
// and ScrollBars on all app's forms, and will apply changes to them.
// If you create any menus, menu items, tool bars or scroll bars at run time,
// you will have to update them manually (by calling UpdateComponent procedure).
//
// Disadvantages:
//  Top menu icons are not supported.
//  Right-to-left is not supported (yet).
//  Bitmaps are not supprted - you have to use image lists.
//  ToolBar drop down buttons are not supported.
//  ToolBar button labels are not supported.
//  If you set position of a ScrollBar to some value before Application.Run, it
//   will be set back to zero. I will have work on it one day.
//
// Remarks:
//  ToolBar height should be set to 26 and Flat -> True,
//  ToolBar button widths and heights -> 24.
//
// Copyright (C) Zink
// e-mail: zink@poczta.onet.pl
//
// This unit is based on XPMenu component written by Khaled Shagrouni. I tried to
// write it myself, not copy somebody's work, and I did. Almost none of the code
// were just copied from the component. I would like to thank Khaled and everyone
// who helped him by introducing their corrections. Thank you.
//
// This source code is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This source code is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License (License.txt) for more details.
//**********************************************************************************

unit CompMods;

interface

uses Forms, StdCtrls, Classes, Messages, Windows, Menus, Graphics, ImgList, SysUtils,
 Controls, Math, ComCtrls;

type
  TModScroll = class(TControl)
  private
   Control: TScrollBar;
   orgWindowProc: TWndMethod;
   orgOnScroll: TScrollEvent; //pointer to original OnScroll event
   procedure modWindowProc(var Message: TMessage);
   procedure modOnScroll(Sender: TObject; ScrollCode: TScrollCode;
     var ScrollPos: Integer);   //our modified OnScroll event
  public
   constructor Create(AOwner: TComponent; Target: TScrollBar); reintroduce;
   destructor Destroy; override;
  end;

  {TModForm = class(TObject)
  private
   Form: TForm;
   orgWindowProc: TWndMethod;
   procedure modWindowProc(var Message: TMessage);
  end;}

  TModMenu = class(TObject)
  private
    procedure modOnDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
      Selected: Boolean);
    procedure modOnMeasureItem(Sender: TObject; ACanvas: TCanvas;
      var Width, Height: Integer);
    procedure DrawTopMenuItem(Item: TMenuItem; ACanvas: TCanvas; ARect: TRect;
      Selected: Boolean);
  public
    procedure UpdateMenuItem(MenuItem: TMenuItem; SubMenus: Boolean = False);
  end;

  TmodToolBar = class(TObject)
  private
    procedure modOnCustomDrawButton(Sender: TToolBar; Button: TToolButton;
      State: TCustomDrawState; var DefaultDraw: Boolean);
  public
    procedure UpdateToolBar(Bar: TToolBar);
  end;

  TColourSet = record
    IconBackColour, TextBackColour, SelectFillColour, SelectCheckedColour,
    SelectBorderColour, SelectShadowColour, DisabledFillColour, DisabledBorderColour,
    SeparatorColour, MenuTextColour, DisabledTextColour: TColor;
  end;

const
  // OPTIONS & SWITCHES:
  DisableScrollBarFlashing = False; //If true, scrollbars will not flash when focused
  UpdateMenus = True;      //here you can enable or disable processing of
  UpdateToolBars = True;   //items of particular type
  UpdateScrollBars = True;
  IconSizeWhenNoIcons = 20;
  // END OF OPTIONS

  ShadowPattern: array[0..3,0..4] of Byte = ((11,32,62,83,92),( 7,23,47,62,69),( 4,12,23,32,35),( 2, 4, 8,11,12));
  ColourSetCollection: array[0..5] of TColourSet = (
   (IconBackColour: clBtnFace;//$00C8D0D4; //Blue
    TextBackColour: clWhite;
    SelectFillColour: $FFEAC6;
    SelectCheckedColour: $FFCAA6; //$DFCAA6;
    SelectBorderColour: clBlue;
    SelectShadowColour: $FF9A76;
    DisabledFillColour: clSilver;
    DisabledBorderColour: clGray;
    SeparatorColour: $808080;
    MenuTextColour: clMenuText;
    DisabledTextColour: clInactiveCaption;),
   (IconBackColour: clBtnFace; //Green
    TextBackColour: clWhite;
    SelectFillColour: $EAFFC6;
    SelectCheckedColour: $AAEF86;
    SelectBorderColour: clGreen;
    SelectShadowColour: $6ACF46;
    DisabledFillColour: clSilver;
    DisabledBorderColour: clGray;
    SeparatorColour: $808080;
    MenuTextColour: clMenuText;
    DisabledTextColour: clInactiveCaption;),
   (IconBackColour: clBtnFace; //Red
    TextBackColour: clWhite;
    SelectFillColour: $C0C0FF;
    SelectCheckedColour: $A0A0FF;
    SelectBorderColour: clRed;
    SelectShadowColour: $8080FF;
    DisabledFillColour: clSilver;
    DisabledBorderColour: clGray;
    SeparatorColour: $808080;
    MenuTextColour: clMenuText;
    DisabledTextColour: clInactiveCaption;),
   (IconBackColour: clBtnFace; //Yellow
    TextBackColour: clWhite;
    SelectFillColour: $00FFFF;
    SelectCheckedColour: $00E0FF;
    SelectBorderColour: $0080FF;
    SelectShadowColour: $00B0FF;
    DisabledFillColour: clSilver;
    DisabledBorderColour: clGray;
    SeparatorColour: $808080;
    MenuTextColour: clMenuText;
    DisabledTextColour: clInactiveCaption;),
   (IconBackColour: clBtnFace; //Purple
    TextBackColour: clWhite;
    SelectFillColour: $FFE0FF;
    SelectCheckedColour: $FFC0FF;
    SelectBorderColour: $FF00FF;
    SelectShadowColour: $FF90FF;
    DisabledFillColour: clSilver;
    DisabledBorderColour: clGray;
    SeparatorColour: $808080;
    MenuTextColour: clMenuText;
    DisabledTextColour: clInactiveCaption;),
   (IconBackColour: clBtnFace; //Orange
    TextBackColour: clWhite;
    SelectFillColour: $B0E0FF;
    SelectCheckedColour: $A0D0FF;
    SelectBorderColour: $2090FF;
    SelectShadowColour: $60B0FF;
    DisabledFillColour: clSilver;
    DisabledBorderColour: clGray;
    SeparatorColour: $808080;
    MenuTextColour: clMenuText;
    DisabledTextColour: clInactiveCaption;));

var ModMenu: TModMenu = nil;
    ModToolBar: TModToolBar = nil;
    BitTmp: TBitmap = nil;
    Colours: TColourSet;
    ColourSetIndex: Integer = 0;
    //Test: Boolean = False;
    OlderOS: Boolean = True;


//This is the main procedure that enables all changes this unit does.
//Call it just before the Application.Run in the main app's file.
procedure UpdateComponents;
//You can use the procedure below to update components you created at run time.
//Components allowed are: TMenuItem, TMainMenu, TPopupMenu, TToolBar
// or TScrollBar, other will be ignored. SubMenus is used for TMenuItems only.
procedure UpdateComponent(AComp: TComponent; SubMenus: Boolean = False);
//Use the procedure below to update an entire Form. For now this is the only
//  way to update newly created MainMenus and PopupMenus, because
//  UpdateCmponent() doesn't work for them.
procedure UpdateForm(AForm: TForm);
//Frames are not updated together with Forms
procedure UpdateFrame(AFrame: TFrame);
//Please do not apply colour sets by typing: Colours:= SomeColourSet, because
//some additional adjustments have to be made. Use the procedure below instead.
procedure ApplyColourSet(ColourSet: TColourSet);
procedure SwitchColourSet(Index: Integer);

implementation

function Smaller(v1, v2: Integer): Integer;
begin
 If v1<v2 then Result:=v1 else Result:=v2;
end;

procedure TModScroll.modWindowProc(var Message: TMessage);
begin
  //we change some aspects of scrollbar only, so it must receive all regular messges
  // that are sent to it:
  If Assigned(orgWindowProc) then orgWindowProc(Message);

  //but for some messages we want to put our oar in:
  case Message.Msg of
   SBM_SETSCROLLINFO: begin

    //when changing scrollbar's PageSize value, it's flashing focus indication
    // remains the same size, which generates a bit ugly effect, so we fix it
    If (TScrollInfo(Pointer(Message.LParam)^).fMask and SIF_PAGE)<>0 then
     If Control.Focused and not DisableScrollBarFlashing then
      Control.Perform(WM_SETFOCUS,0,0);

    //scrollbars don't adjust their position when changing PageSize nor wnen
    // ScrollInfo contains SIF_POS and SIF_PAGE together, it may cause
    // positions out of valid range, so we have to set it manually
    If (TScrollInfo(Pointer(Message.LParam)^).fMask and SIF_POS)<>0 then
     If Control.Position>Control.Max-Control.PageSize+1 then
      Control.Position:=Control.Max-Control.PageSize+1;

   end;
  end;
end;

//Block scrolling beyond Max-PageSize+1 by clicking down arrow (bug workaround)
procedure TModScroll.modOnScroll(Sender: TObject; ScrollCode: TScrollCode;
 var ScrollPos: Integer);
begin
 If ScrollCode=scLineDown then
  with (Sender as TScrollBar) do
   If ScrollPos>Max-PageSize+1 then ScrollPos:=Max-PageSize+1;
 If Assigned(orgOnScroll) then orgOnScroll(Sender,ScrollCode,ScrollPos);
end;

constructor TModScroll.Create(AOwner: TComponent; Target: TScrollBar);
begin
 inherited Create(AOwner);
 Control:=Target;
 orgWindowProc:=Control.WindowProc;        //put our oar in the Window Procedure
 Control.WindowProc:=modWindowProc;
 orgOnScroll:=Control.OnScroll;            //and in the OnScroll event
 Control.OnScroll:=modOnScroll;
 If DisableScrollBarFlashing then Control.ControlState:=Control.ControlState+[csFocusing];
end;

destructor TModScroll.Destroy;
begin
 Control.WindowProc:=orgWindowProc;
 inherited;
end;

function IsTopMenuItem(Item: TMenuItem): Boolean;
begin
 Result:=Item.GetParentComponent is TMainMenu; //as simple as that!
end;

{procedure DrawArrow(Item: TMenuItem; ACanvas: hDC; ARect: TRect);
var PenHandle, OldPenHandle: HPEN;
    x, y: Integer;
begin
 //PenHandle:=CreatePen(PS_SOLID, 1, 0);
 //OldPenHandle:=SelectObject(ACanvas, PenHandle);
 x:=ARect.Right;
 y:=(ARect.Top+ARect.Bottom) div 2;
 //MoveToEx(ACanvas,x-7,y,nil);
 //LineTo(ACanvas,x-10,y-3);
 MoveToEx(ACanvas,x-57,y-2,nil);
 LineTo(ACanvas,x,y-2);
 //LineTo(ACanvas,x-10,ARect.Top
 //SelectObject(ACanvas, OldPenHandle);
 //DeleteObject(PenHandle);
end;}

(*procedure TModForm.modWindowProc(var Message: TMessage);
var MData: PMEASUREITEMSTRUCT;
    DData: PDRAWITEMSTRUCT;
    Item: TMenuItem;
begin
 If Assigned(orgWindowProc) then orgWindowProc(Message);
 case Message.Msg of
  WM_MEASUREITEM: begin
   If Message.WParam=0 then begin //i.e. if control is a menu
    MData:=Pointer(Message.LParam);
    if IsTopMenuItem(Form.Menu.FindItem(MData.itemID,fkCommand)) then
     MData.ItemWidth:=MData.ItemWidth+5;
   end;
  end;
  {WM_DRAWITEM: begin
   If Message.WParam=0 then begin
    DData:=Pointer(Message.LParam);
    If (ODS_SELECTED and DData.itemState)<>0 then begin
     Item:=Form.Menu.FindItem(DData.itemID,fkCommand);
     If not IsTopMenuItem(Item) and (Item.Count>0) then
      DrawArrow(Item,DData.hDC,DData.rcItem)
    end;
   end;
  end;}
 end;
end;*)

procedure DrawIconShadow(ACanvas: TCanvas; Images: TCustomImageList;
 x, y, Index: Integer);
begin
 BitTmp.Width:=Images.Width;
 BitTmp.Height:=Images.Height;
 BitTmp.Canvas.Brush.Color:=Colours.SelectShadowColour;
 BitTmp.Canvas.FillRect(Rect(0,0,BitTmp.Width,BitTmp.Height));
 Images.Draw(BitTmp.Canvas,0,0,Index,ImgList.dsNormal,itMask,True);
 BitTmp.Canvas.Rectangle(0,0,BitTmp.Width,BitTmp.Height);
 ACanvas.Draw(x,y,BitTmp);
end;

procedure SetDrawingColours(ACanvas: TCanvas; Enabled, Selected: Boolean);
begin
 If Enabled then begin
  If Selected then ACanvas.Brush.Color:=Colours.SelectCheckedColour
  else ACanvas.Brush.Color:=Colours.SelectFillColour;
  ACanvas.Pen.Color:=Colours.SelectBorderColour;
 end
 else begin
  ACanvas.Brush.Color:=Colours.DisabledFillColour;
  ACanvas.Pen.Color:=Colours.DisabledBorderColour;
 end;
end;

procedure DrawCheckMark(ACanvas: TCanvas; x, y: Integer; Enabled, Selected, Radio: Boolean);
begin
 SetDrawingColours(ACanvas,Enabled,Selected);
 If Radio then begin
  ACanvas.Polygon([Point(x,y),Point(x-4,y-4),Point(x-7,y-4),Point(x-3,y),
   Point(x-7,y+4),Point(x-4,y+4)]);
  ACanvas.Polygon([Point(x+6,y),Point(x+2,y-4),Point(x-1,y-4),Point(x+3,y),
   Point(x-1,y+4),Point(x+2,y+4)]);
 end
 else begin
  ACanvas.Rectangle(Rect(x-5,y-5,x+5,y+5));
  If Enabled then ACanvas.Pen.Color:=clBlack;
  ACanvas.MoveTo(x+1,y+1);
  ACanvas.LineTo(x-1,y+3);
  ACanvas.LineTo(x-4,y);
  ACanvas.LineTo(x-3,y-1);
  ACanvas.LineTo(x,y+2);
  ACanvas.MoveTo(x-3,y);
  ACanvas.LineTo(x-1,y+2);
  ACanvas.LineTo(x+7,y-6);
 end;
end;

procedure DrawIcon(ACanvas: TCanvas; Images: TCustomImageList; ARect: TRect;
 Index: Integer; HasIcon, Enabled, Active, Checked, Radio: Boolean);
begin
 If HasIcon and (Index>-1) then begin
  If Checked then begin
   SetDrawingColours(ACanvas,Enabled,Active);
   If Radio then
    ACanvas.RoundRect(ARect.Left-3,ARect.Top-2,ARect.Right+2,ARect.Bottom+2,10,10)
   else
    ACanvas.RoundRect(ARect.Left-3,ARect.Top-2,ARect.Right+2,ARect.Bottom+2,2,2);
  end
  else if Active and Enabled then begin
   DrawIconShadow(ACanvas, Images, ARect.Left+1, ARect.Top+1, Index);
   Dec(ARect.Left);
   Dec(ARect.Top);
  end;
  Images.Draw(ACanvas,ARect.Left,ARect.Top,Index,Enabled);
 end
 else if Checked then
  DrawCheckMark(ACanvas,(ARect.Left+ARect.Right) div 2,(ARect.Top+ARect.Bottom) div 2,
   Enabled,Active,Radio);
end;

procedure DrawButtonIcon(ACanvas: TCanvas; Images: TCustomImageList; ARect: TRect;
 Index: Integer; HasIcon, Enabled, Active, Checked: Boolean);
begin
 If HasIcon and (Index>-1) then begin
  If Active or Checked then begin
   SetDrawingColours(ACanvas,Enabled,Active and Checked);
   ACanvas.RoundRect(ARect.Left-3,ARect.Top-2,ARect.Right+2,ARect.Bottom+2,2,2);
   If Active and not Checked then begin
    DrawIconShadow(ACanvas, Images, ARect.Left+2, ARect.Top+2, Index);
    Dec(ARect.Left);
    Dec(ARect.Top);
   end;
  end;
  Inc(ARect.Left);
  Inc(ARect.Top);
  If Enabled then Images.Draw(ACanvas,ARect.Left,ARect.Top,Index,True)
  else begin  //bug workaround (why ImageList draws disabled image all white on ToolBar?)
   BitTmp.Width:=Images.Width;
   BitTmp.Height:=Images.Height;
   BitTmp.Canvas.Brush.Color:=clblack;
   BitTmp.Canvas.FillRect(Rect(0,0,BitTmp.Width,BitTmp.Height));
   Images.Draw(BitTmp.Canvas,0,0,Index,False);
   ACanvas.Draw(ARect.Left,ARect.Top,BitTmp);
  end;
 end
 else if Checked then
  DrawCheckMark(ACanvas,(ARect.Left+ARect.Right) div 2,(ARect.Top+ARect.Bottom) div 2,
   Enabled,Active,False);
end;

function GetImageParams(Item: TMenuItem; out ImageW: Integer;
 out Images: TCustomImageList): Boolean;
begin
 Result:=True;
 If Item.HasParent and (Item.Parent is TMenuItem)
 and Assigned((Item.Parent as TMenuItem).SubMenuImages) then
  Images:=(Item.Parent as TMenuItem).SubMenuImages
 else if Assigned(Item.GetParentMenu.Images) then
  Images:=Item.GetParentMenu.Images
 else
  Result:=False;
 If Result then ImageW:=Images.Width else ImageW:=IconSizeWhenNoIcons;
end;

procedure TModMenu.modOnMeasureItem(Sender: TObject; ACanvas: TCanvas;
 var Width, Height: Integer);
var Images: TCustomImageList;
    Item: TMenuItem;
begin
 Item:=Sender as TMenuItem;
 If not IsTopMenuItem(Item) then begin
  If GetImageParams(Item,Width,Images) then Inc(Width,IfThen(Item.Caption='',-4,8));
  If Item.Caption<>'' then begin
   If Item.Default then ACanvas.Font.Style:=[fsBold];
   Inc(Width,ACanvas.TextWidth(Item.Caption)+5);
  end; 
  If Item.ShortCut<>0 then
   Inc(Width,ACanvas.TextWidth(ShortCutToText(Item.ShortCut))+10);
  Inc(Height,3);
 end; 
end;

// icons in top main menu items are NOT supported
// bitmaps are NOT supported, use ImageList icons only
procedure TModMenu.modOnDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
 Selected: Boolean);
var HasIcon, Enabled: Boolean;
    Item: TMenuItem;
    IconW: Integer;
    Images: TCustomImageList;
    IconRect, TextRect: TRect;
begin
 Item:=Sender as TMenuItem;
 Enabled:=Item.Enabled;

 If IsTopMenuItem(Item) then DrawTopMenuItem(Item,ACanvas,ARect,Selected)
 else begin

  HasIcon:=GetImageParams(Item,IconW,Images);
  IconRect:=ARect;
  IconRect.Right:=ARect.Left+IconW+IfThen(HasIcon,8);

  TextRect:=ARect;
  TextRect.Left:=IconRect.Right;

  If Selected and Enabled then begin
   ACanvas.Brush.Color:=Colours.SelectFillColour;
   ACanvas.Pen.Color:=Colours.SelectBorderColour;
   ACanvas.RoundRect(ARect.Left,ARect.Top,ARect.Right-1,ARect.Bottom,2,2);
  end
  else begin
   ACanvas.Brush.Color:=Colours.IconBackColour;
   ACanvas.FillRect(IconRect);
   ACanvas.Brush.Color:=Colours.TextBackColour;
   ACanvas.FillRect(TextRect);
  end;

  InflateRect(IconRect,-4,-3);
  DrawIcon(ACanvas,Images,IconRect,Item.ImageIndex,
   HasIcon,Enabled,Selected,Item.Checked,Item.RadioItem);

  If Item.IsLine then begin
   ACanvas.Pen.Color:=Colours.SeparatorColour;
   ACanvas.MoveTo(TextRect.Left+7,(TextRect.Top+TextRect.Bottom) div 2);
   ACanvas.LineTo(TextRect.Right,(TextRect.Top+TextRect.Bottom) div 2);
  end
  else begin
   Inc(TextRect.Left,5);
   ACanvas.Brush.Style:=bsClear;
   If Enabled then ACanvas.Font.Color:=Colours.MenuTextColour
   else ACanvas.Font.Color:=Colours.DisabledTextColour;
   If Item.Default then ACanvas.Font.Style:=[fsBold];
   DrawText(ACanvas.Handle,PChar(Item.Caption),Length(Item.Caption),TextRect,
    DT_LEFT+DT_VCENTER+DT_SINGLELINE);
   Dec(TextRect.Right,15);
   DrawText(ACanvas.Handle,PChar(ShortcutToText(Item.ShortCut)),
    Length(ShortCutToText(Item.ShortCut)),TextRect,
    DT_RIGHT+DT_VCENTER+DT_SINGLELINE+DT_NOPREFIX);
  end; 

 end;
end;

function MouseAtItem(Win: TScrollingWinControl; R: TRect): Boolean;
var P: TPoint;
begin
 If Assigned(Win) then begin
  GetCursorPos(P);
  //P:= Mouse.CursorPos;
  Dec(P.X,Win.Left);
  Dec(P.Y,Win.Top);
  Result:=(P.X>=R.Left) and (P.X<=R.Right-1) and (P.Y>=R.Top) and (P.Y<=R.Bottom-1);
 end
 else Result:=False; 
end;

function DarkenColour(c: TColor; Value: Byte): TColor;
var r, g, b: Integer;
begin
 r:=(c and $000000FF);
 g:=(c and $0000FF00) shr 8;
 b:=(c and $00FF0000) shr 16;
 Dec(r,Value);
 If r<0 then r:=0;
 Dec(g,Value);
 If g<0 then g:=0;
 Dec(b,Value);
 If b<0 then b:=0;
 Result:=r + g*256 + b*256*256;
end;

procedure PaintShadow(x, y, y2: Integer; C: TCanvas);
var a, b: Integer;
begin
 for b:=y to y2-1 do
  for a:=x to x+3 do
   C.Pixels[a,b]:=DarkenColour(C.Pixels[a,b],ShadowPattern[a-x,Smaller(b-y,4)]);
end;

procedure TModMenu.DrawTopMenuItem(Item: TMenuItem; ACanvas: TCanvas; ARect: TRect;
 Selected: Boolean);
begin
 If Selected and (Item.Count>0) then begin
  ACanvas.Brush.Color:=Colours.SelectFillColour;
  ACanvas.Pen.Color:=Colours.SelectFillColour;
  ACanvas.RoundRect(ARect.Left,ARect.Top,ARect.Right,ARect.Bottom,2,2);
  ACanvas.Pen.Color:=Colours.SelectBorderColour;
  ACanvas.MoveTo(ARect.Left,ARect.Bottom-1);
  ACanvas.LineTo(ARect.Left,ARect.Top);
  ACanvas.MoveTo(ARect.Left+1,ARect.Top);
  ACanvas.LineTo(ARect.Right-1,ARect.Top);
  ACanvas.MoveTo(ARect.Right-1,ARect.Top+1);
  ACanvas.LineTo(ARect.Right-1,ARect.Bottom);
  PaintShadow(ARect.Right,ARect.Top+4,ARect.Bottom,ACanvas);
 end
 else begin
  ACanvas.Brush.Color:=clMenu;
  ACanvas.FillRect(Rect(ARect.Left,ARect.Top,ARect.Right+4,ARect.Bottom));
  if not OlderOS then
   if MouseAtItem(Item.GetParentMenu.Owner as TScrollingWinControl,ARect) then begin
    ACanvas.Brush.Color:=Colours.SelectFillColour;
    ACanvas.Pen.Color:=Colours.SelectBorderColour;
    ACanvas.RoundRect(ARect.Left,ARect.Top,ARect.Right,ARect.Bottom,2,2);
   end;
 end;
 If Item.Enabled then ACanvas.Font.Color:=Colours.MenuTextColour
 else ACanvas.Font.Color:=Colours.DisabledTextColour;
 ACanvas.Brush.Style:=bsClear;
 DrawText(ACanvas.Handle,PChar(Item.Caption),Length(Item.Caption),ARect,
  DT_CENTER+DT_VCENTER+DT_SINGLELINE);
end;

procedure TModMenu.UpdateMenuItem(MenuItem: TMenuItem; SubMenus: Boolean = False);
var a: integer;
begin
 MenuItem.OnDrawItem := modOnDrawItem;
 MenuItem.OnMeasureItem := modOnMeasureItem;

 if SubMenus then
  for a:=0 to MenuItem.Count-1 do
   UpdateMenuItem(MenuItem.Items[a],true);
end;

procedure TModToolBar.modOnCustomDrawButton(Sender: TToolBar; Button: TToolButton;
 State: TCustomDrawState; var DefaultDraw: Boolean);
var HasIcon: Boolean;
    Images: TCustomImageList;
    R: TRect;
begin
 if (Button.Style = tbsButton) or (Button.Style = tbsCheck) then begin
   HasIcon:= Assigned(Sender.Images);
   if HasIcon then Images:= Sender.Images else Images:= nil;
   R:= Button.BoundsRect;
   InflateRect(R, -3, -3);

   DrawButtonIcon(Sender.Canvas, Images, R, Button.ImageIndex, HasIcon,
     not ((cdsDisabled in State) or (cdsGrayed in State)),
     cdsHot in State, (cdsSelected in State) or (cdsChecked in State));
   DefaultDraw:= False;
 end;
end;

procedure TModToolBar.UpdateToolBar(Bar: TToolBar);
begin
 Bar.OnCustomDrawButton:=modOnCustomDrawButton;
end;

procedure UpdateComponent(AComp: TComponent; SubMenus: Boolean = False);
begin
 If AComp is TScrollBar then
   TModScroll.Create(AComp, AComp as TScrollBar)
 else if AComp is TMenuItem then begin
   ModMenu.UpdateMenuItem(AComp as TMenuItem, SubMenus);
   If (AComp as TMenuItem).GetParentMenu <> nil then
     (AComp as TMenuItem).GetParentMenu.OwnerDraw:= True;
 end
 else if AComp is TToolBar then
   ModToolBar.UpdateToolBar(AComp as TToolBar);
end;

procedure UpdateForm(AForm: TForm);
var b: Integer;
    S: String;
begin
  {with TModForm.Create do begin
   Form:=Screen.Forms[a];
   orgWindowProc:=Form.WindowProc;
   Form.WindowProc:=modWindowProc;
  end;}
  for b:= 0 to AForm.ComponentCount - 1 do begin
    if (AForm.Components[b] is TScrollBar) and UpdateScrollBars then
      TModScroll.Create(AForm.Components[b], AForm.Components[b] as TScrollBar)
    else if (AForm.Components[b] is TMenuItem) and UpdateMenus then begin
      ModMenu.UpdateMenuItem(AForm.Components[b] as TMenuItem);
    end
    else if (AForm.Components[b] is TMainMenu) and UpdateMenus then begin
      (AForm.Components[b] as TMainMenu).OwnerDraw:=True;
      //AForm.Perform(WM_MEASUREITEM,0,
      S := (AForm.Components[b] as TMainMenu).Items[0].Caption;
      (AForm.Components[b] as TMainMenu).Items[0].Caption:= '';
      (AForm.Components[b] as TMainMenu).Items[0].Caption:= S;
    end
    else if (AForm.Components[b] is TPopupMenu) and UpdateMenus then
      (AForm.Components[b] as TPopupMenu).OwnerDraw:= True
    else if (AForm.Components[b] is TToolBar) and UpdateToolBars then
      ModToolBar.UpdateToolBar(AForm.Components[b] as TToolBar);
  end;
end;

procedure UpdateFrame(AFrame: TFrame);
var b: Integer;
    S: String;
begin
  for b:= 0 to AFrame.ComponentCount-1 do begin
    if (AFrame.Components[b] is TScrollBar) and UpdateScrollBars then
      TModScroll.Create(AFrame.Components[b], AFrame.Components[b] as TScrollBar)
    else if (AFrame.Components[b] is TMenuItem) and UpdateMenus then begin
      ModMenu.UpdateMenuItem(AFrame.Components[b] as TMenuItem);
    end
    else if (AFrame.Components[b] is TMainMenu) and UpdateMenus then begin
      (AFrame.Components[b] as TMainMenu).OwnerDraw:=True;
      //AFrame.Perform(WM_MEASUREITEM,0,
      S := (AFrame.Components[b] as TMainMenu).Items[0].Caption;
      (AFrame.Components[b] as TMainMenu).Items[0].Caption:= '';
      (AFrame.Components[b] as TMainMenu).Items[0].Caption:= S;
    end
    else if (AFrame.Components[b] is TPopupMenu) and UpdateMenus then
      (AFrame.Components[b] as TPopupMenu).OwnerDraw:= True
    else if (AFrame.Components[b] is TToolBar) and UpdateToolBars then
      ModToolBar.UpdateToolBar(AFrame.Components[b] as TToolBar);
  end;
end;

//Procedure than must be called just before the Application.Run in the main project
//file. It looks for all menus and ScrollBars on all forms and redirects some of their
//events to call modified methods. Note that original methods are also called,
//so if you define your own event handlers they will be processed as well.
procedure UpdateComponents();
var a: Integer;
    OSVerInfo: TOSVersionInfo;
begin
 OSVerInfo.dwOSVersionInfoSize:= sizeof(OSVerInfo);
 GetVersionEx(OSVerInfo);
 if (OSVerInfo.dwPlatformId = VER_PLATFORM_WIN32_NT)
 and (OSVerInfo.dwMajorVersion >= 5) then OlderOS:= False; //i.e. Win 2k or XP

 for a:= 0 to Screen.FormCount - 1 do  //find all forms
   UpdateForm(Screen.Forms[a]);
end;

procedure ApplyColourSet(ColourSet: TColourSet);
var a, b: Integer;
begin
 Colours:= ColourSet;
 BitTmp.Canvas.Brush.Color:= Colours.SelectShadowColour;
 BitTmp.Canvas.Pen.Color:= Colours.SelectShadowColour;
 for a:= 0 to Screen.FormCount - 1 do
   for b:= 0 to Screen.Forms[a].ComponentCount - 1 do
     If Screen.Forms[a].Components[b] is TToolBar then
       (Screen.Forms[a].Components[b] as TToolBar).Repaint;
end;

procedure SwitchColourSet(Index: Integer);
begin
 If (Index<0) or (Index>5) then Index:=0;
 ApplyColourSet(ColourSetCollection[Index]);
 ColourSetIndex:=Index;
end;

initialization
 BitTmp:=TBitmap.Create;
 BitTmp.Transparent:=True;
 BitTmp.TransparentMode:=tmFixed;
 BitTmp.TransparentColor:=clBlack;
 BitTmp.Canvas.Pen.Mode:=pmXor;
 ApplyColourSet(ColourSetCollection[ColourSetIndex]);
 ModMenu := TModMenu.Create;
 ModToolBar := TModToolBar.Create;

finalization
 FreeAndNil(ModToolBar);
 FreeAndNil(ModMenu);
 FreeAndNil(BitTmp);

end.
