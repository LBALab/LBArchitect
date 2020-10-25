{$I DFS.INC}  { Standard defines for all Delphi Free Stuff components }

{------------------------------------------------------------------------------}
{ TdfsColorButton v2.60                                                        }
{------------------------------------------------------------------------------}
{ A Windows 95 and NT 4 style color selection button.  It displays a palette   }
{ of 20 color for fast selction and a button to bring up the color dialog.     }
{                                                                              }
{ Copyright 2000, Brad Stowers.  All Rights Reserved.                          }
{                                                                              }
{ Copyright:                                                                   }
{ All Delphi Free Stuff (hereafter "DFS") source code is copyrighted by        }
{ Bradley D. Stowers (hereafter "author"), and shall remain the exclusive      }
{ property of the author.                                                      }
{                                                                              }
{ Distribution Rights:                                                         }
{ You are granted a non-exlusive, royalty-free right to produce and distribute }
{ compiled binary files (executables, DLLs, etc.) that are built with any of   }
{ the DFS source code unless specifically stated otherwise.                    }
{ You are further granted permission to redistribute any of the DFS source     }
{ code in source code form, provided that the original archive as found on the }
{ DFS web site (http://www.delphifreestuff.com) is distributed unmodified. For }
{ example, if you create a descendant of TdfsColorButton, you must include in  }
{ the distribution package the colorbtn.zip file in the exact form that you    }
{ downloaded it from http://www.delphifreestuff.com/mine/files/colorbtn.zip.   }
{                                                                              }
{ Restrictions:                                                                }
{ Without the express written consent of the author, you may not:              }
{   * Distribute modified versions of any DFS source code by itself. You must  }
{     include the original archive as you found it at the DFS site.            }
{   * Sell or lease any portion of DFS source code. You are, of course, free   }
{     to sell any of your own original code that works with, enhances, etc.    }
{     DFS source code.                                                         }
{   * Distribute DFS source code for profit.                                   }
{                                                                              }
{ Warranty:                                                                    }
{ There is absolutely no warranty of any kind whatsoever with any of the DFS   }
{ source code (hereafter "software"). The software is provided to you "AS-IS", }
{ and all risks and losses associated with it's use are assumed by you. In no  }
{ event shall the author of the softare, Bradley D. Stowers, be held           }
{ accountable for any damages or losses that may occur from use or misuse of   }
{ the software.                                                                }
{                                                                              }
{ Support:                                                                     }
{ Support is provided via the DFS Support Forum, which is a web-based message  }
{ system.  You can find it at http://www.delphifreestuff.com/discus/           }
{ All DFS source code is provided free of charge. As such, I can not guarantee }
{ any support whatsoever. While I do try to answer all questions that I        }
{ receive, and address all problems that are reported to me, you must          }
{ understand that I simply can not guarantee that this will always be so.      }
{                                                                              }
{ Clarifications:                                                              }
{ If you need any further information, please feel free to contact me directly.}
{ This agreement can be found online at my site in the "Miscellaneous" section.}
{------------------------------------------------------------------------------}
{ The lateset version of my components are always available on the web at:     }
{   http://www.delphifreestuff.com/                                            }
{ See DFSClrBn.txt for notes, known issues, and revision history.              }
{------------------------------------------------------------------------------}
{ Date last modified:  June 22, 2000                                           }
{------------------------------------------------------------------------------}


unit DFSClrBn;

interface

uses
  WinTypes, WinProcs, Messages, Classes, Controls, Forms, Graphics, StdCtrls,
  Buttons, ExtCtrls, CBtnForm;


{$IFDEF DFS_WIN32}
  {$R DFSClrBn.res}
{$ELSE}
  {$R DFSClrBn.r16}
{$ENDIF}


{$IFDEF DFS_COMPILER_3_UP}
resourcestring
{$ELSE}
const
{$ENDIF}
  SOtherBtnCaption = '&Other';

const
  { This shuts up C++Builder 3 about the redefiniton being different. There
    seems to be no equivalent in C1.  Sorry. }
  {$IFDEF DFS_CPPB_3_UP}
  {$EXTERNALSYM DFS_COMPONENT_VERSION}
  {$ENDIF}
  DFS_COMPONENT_VERSION = 'TdfsColorButton v2.60';

type
  TdfsColorButton = class(TButton)
  private
    FShowColorHints: boolean;
    FOnGetColorHintText: TdfsColorHintTextEvent;
    FCurrentPaletteIndex: integer;
    FPaletteForm: TdfsColorButtonPalette;
    FSectionName: string;
    FOtherBtnCaption: string;
    FColorsLoaded: boolean;
    FCanvas: TCanvas;
    IsFocused: boolean;
    FStyle: TButtonStyle;
    FColor: TColor;
    FPaletteDisplayed: boolean;
    FCycleColors: boolean;
    FPaletteColors: TPaletteColors;
    FOtherColor: TColor;
    FCustomColors: TCustomColors;
    FIgnoreTopmosts: boolean;
{$IFDEF DFS_WIN32}
    FFlat: boolean;
    FCustomColorsKey: string;
{$ELSE}
    FCustomColorsINI: string;
{$ENDIF}
    FOnColorChange: TNotifyEvent;
    FArrowBmp: TBitmap;
    FDisabledArrowBmp: TBitmap;
    FIsMouseOver: boolean;
    FInhibitClick: boolean;

    procedure CNMeasureItem(var Msg: TWMMeasureItem); message CN_MEASUREITEM;
    procedure CNDrawItem(var Msg: TWMDrawItem); message CN_DRAWITEM;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
{$IFDEF DFS_WIN32}
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
{$ENDIF}

    procedure SetStyle(Value: TButtonStyle);
    procedure SetColor(Value: TColor);
    procedure SetPaletteColorIndex(Value: integer);
    procedure SetPaletteColors(Value: TPaletteColors);
    procedure SetCustomColors(Value: TCustomColors);
    procedure SetArrowBmp(Value: TBitmap);
    procedure SetDisabledArrowBmp(Value: TBitmap);
{$IFDEF DFS_WIN32}
    procedure SetFlat(Value: boolean);
{$ENDIF}

    procedure DrawItem(const DrawItemStruct: TDrawItemStruct);
    procedure PaletteSetColor(Sender: TObject; IsOther: boolean; AColor: TColor);
    procedure PaletteClosed(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure SetButtonStyle(ADefault: Boolean); override;
    procedure SetDefaultColors; virtual;

    function GetSectionName: string; virtual;
    procedure SaveCustomColors; virtual;
    procedure LoadCustomColors; virtual;
    function GetVersion: string;
    procedure SetVersion(const Val: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
		procedure DoColorChange; virtual;

    property PaletteColorIndex: integer
       read FCurrentPaletteIndex
       write SetPaletteColorIndex;
    property ArrowBmp: TBitmap
       read FArrowBmp
       write SetArrowBmp;
    property DisabledArrowBmp: TBitmap
       read FDisabledArrowBmp
       write SetDisabledArrowBmp;
    property IgnoreTopmosts: boolean
       read FIgnoreTopmosts
       write FIgnoreTopmosts;
  published
    property Version: string
       read GetVersion
       write SetVersion
       stored FALSE;
    property ShowColorHints: boolean
       read FShowColorHints
       write FShowColorHints
       default TRUE;
    property Style: TButtonStyle
       read FStyle
       write SetStyle
       default bsAutoDetect;
    property OtherBtnCaption: string
       read FOtherBtnCaption
       write FOtherBtnCaption;
    property OtherColor: TColor
       read FOtherColor
       write FOtherColor;
    property CycleColors: boolean
       read FCycleColors
       write FCycleColors
       default FALSE;
    property PaletteColors: TPaletteColors
       read FPaletteColors
       write SetPaletteColors
       stored TRUE;
    property CustomColors: TCustomColors
       read FCustomColors
       write SetCustomColors
       stored TRUE;
    { This property has to come after PaletteColors because it needs to use it }
    property Color: TColor
       read FColor
       write SetColor
       default clBlack;
{$IFDEF DFS_WIN32}
    property Flat: boolean
       read FFlat
       write SetFlat
       default FALSE;
    property CustomColorsKey: string
       read FCustomColorsKey
       write FCustomColorsKey;
{$ELSE}
    property CustomColorsINI: string
       read FCustomColorsINI
       write FCustomColorsINI;
{$ENDIF}
		property OnColorChange: TNotifyEvent
       read FOnColorChange
       write FOnColorChange;
    property OnGetColorHintText: TdfsColorHintTextEvent
       read FOnGetColorHintText
       write FOnGetColorHintText;
  end;

implementation

uses
  {$IFDEF DFS_WIN32}
  Registry,
  {$ELSE}
  IniFiles,
  {$ENDIF}
  SysUtils;


{$IFDEF DFS_COMPILER_2}
{ Delphi 2 doesn't have this, just fake it }
type
  TCustomForm = TForm;
{$ENDIF}

constructor TdfsColorButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIgnoreTopmosts := FALSE;
  FInhibitClick := FALSE;
  FShowColorHints := TRUE;
  FCurrentPaletteIndex := 0;
  FCycleColors := FALSE;
  FArrowBmp := TBitmap.Create;
  FDisabledArrowBmp := TBitmap.Create;
  { I had a report that the Handle assignment was failing for someone who had
    a large project, but that changing to LoadFromResource fixed it.
    Unfortunately, this isn't available in Delphi 1. }
  {$IFDEF DFS_WIN32}
  FArrowBmp.LoadFromResourceName(HInstance, 'DFS_ARROW_BMP');
  FDisabledArrowBmp.LoadFromResourceName(HInstance, 'DFS_ARROW_DISABLED_BMP');
  {$ELSE}
  FArrowBmp.Handle := LoadBitmap(HInstance, 'DFS_ARROW_BMP');
  FDisabledArrowBmp.Handle := LoadBitmap(HInstance, 'DFS_ARROW_DISABLED_BMP');
  {$ENDIF}
  FPaletteColors := TColorArrayClass.Create(4,5);
  FCustomColors := TColorArrayClass.Create(8,2);
  FPaletteForm := NIL;
  FOtherBtnCaption := SOtherBtnCaption;
  FColorsLoaded := FALSE;
  FCanvas := TCanvas.Create;
  FStyle := bsAutoDetect;
  FColor := clBlack;
  FPaletteDisplayed := FALSE;
  Caption := '';
  FIsMouseOver := FALSE;
  {$IFDEF DFS_DELPHI_3_UP}
  ControlStyle := ControlStyle + [csReflector];
  {$ENDIF}
  {$IFDEF DFS_WIN32}
  FFlat := FALSE;
  FCustomColorsKey := '';
  {$ELSE}
  FCustomColorsINI := '';
  {$ENDIF}
  SetDefaultColors;
  Width := 45;
  Height := 22;
end;

destructor TdfsColorButton.Destroy;
begin
  SaveCustomColors;
  FCanvas.Free;
  FPaletteColors.Free;
  FCustomColors.Free;
  FArrowBmp.Free;
  FDisabledArrowBmp.Free;
  inherited Destroy;
end;

procedure TdfsColorButton.CreateWnd;
begin
  inherited CreateWnd;

  if not FColorsLoaded then
    LoadCustomColors;
end;


procedure TdfsColorButton.Loaded;
begin
  inherited Loaded;

  LoadCustomColors;
end;


procedure TdfsColorButton.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style OR BS_OWNERDRAW;
end;

procedure TdfsColorButton.SetStyle(Value: TButtonStyle);
begin
  if Value <> FStyle then
  begin
    FStyle := Value;
    Invalidate;
  end;
end;

procedure TdfsColorButton.SetColor(Value: TColor);
var
  x: integer;
  Found: boolean;
begin
  if Value <> FColor then
  begin
    FColor := Value;
    Found := FALSE;
    for x := 1 to FPaletteColors.Count do
    begin
      if FColor = FPaletteColors.Colors[x] then
      begin
        FCurrentPaletteIndex := x;
        Found := TRUE;
        break;
      end;
    end;
    if not Found then
      FCurrentPaletteIndex := 0;

    Invalidate;
    DoColorChange;
  end;
end;

procedure TdfsColorButton.SetPaletteColorIndex(Value: integer);
begin
  if (Value <> FCurrentPaletteIndex) and (Value >= 0) and
     (Value <= FPaletteColors.Count) then
  begin
    FCurrentPaletteIndex := Value;
    if Value = 0 then
      FColor := OtherColor
    else
      FColor := FPaletteColors.Colors[Value];
    Invalidate;
    DoColorChange;
  end;
end;

procedure TdfsColorButton.CNMeasureItem(var Msg: TWMMeasureItem);
begin
  with Msg.MeasureItemStruct^ do
  begin
    itemWidth := Width;
    itemHeight := Height;
  end;
  Msg.Result := 1;
end;

procedure TdfsColorButton.CNDrawItem(var Msg: TWMDrawItem);
begin
  DrawItem(Msg.DrawItemStruct^);
  Msg.Result := 1;
end;

{ Borrowed from RxLib }
procedure ShadeRect(DC: HDC; const Rect: TRect);
const
  HatchBits: array[0..7] of Word = ($11, $22, $44, $88, $11, $22, $44, $88);
var
  Bitmap: HBitmap;
  SaveBrush: HBrush;
  SaveTextColor, SaveBkColor: TColorRef;
begin
  Bitmap := CreateBitmap(8, 8, 1, 1, @HatchBits);
  SaveBrush := SelectObject(DC, CreatePatternBrush(Bitmap));
  try
    SaveTextColor := SetTextColor(DC, clWhite);
    SaveBkColor := SetBkColor(DC, clBlack);
    with Rect do PatBlt(DC, Left, Top, Right - Left, Bottom - Top, $00A000C9);
    SetBkColor(DC, SaveBkColor);
    SetTextColor(DC, SaveTextColor);
  finally
    DeleteObject(SelectObject(DC, SaveBrush));
    DeleteObject(Bitmap);
  end;
end;


(* There's a bug in the Delphi 2.0x optimization compiler.  If you don't turn
   off optimization under Delphi 2.0x, you will get an internal error C1217.
   This bug is not present in Delphi 1 or 3.
   There appears to be a similar bug in C++Builder 1.  I get an internal error
   C1310.  Same fix for it as for Delphi.  Doesn't appear in C++Builder 3.    *)

{$IFDEF DFS_COMPILER_2}
  {$IFOPT O+}
    {$DEFINE DFS_OPTIMIZATION_ON}
    {$O-}
  {$ENDIF}
{$ENDIF}
procedure TdfsColorButton.DrawItem(const DrawItemStruct: TDrawItemStruct);
var
  IsDown, IsDefault: Boolean;
  R: TRect;
  Flags: Longint;
  CursorPos: TPoint;
  BtnRect: TRect;
  Bmp: TBitmap;
{$IFNDEF DFS_WIN32}
  NewStyle: boolean;
  Bevel: integer;
  TextBounds: TRect;
{$ENDIF}
begin
  FCanvas.Handle := DrawItemStruct.hDC;
  try
    R := ClientRect;

    with DrawItemStruct do
    begin
      IsDown := (itemState and ODS_SELECTED <> 0) or (FPaletteDisplayed);
      IsDefault := itemState and ODS_FOCUS <> 0;
    end;

    GetCursorPos(CursorPos);
    BtnRect.TopLeft := Parent.ClientToScreen(Point(Left, Top));
    BtnRect.BottomRight := Parent.ClientToScreen(Point(Left + Width,
       Top + Height));
    FIsMouseOver := PtInRect(BtnRect, CursorPos);

{$IFDEF DFS_WIN32}
    Flags := DFCS_BUTTONPUSH or DFCS_ADJUSTRECT;
    if IsDown then Flags := Flags or DFCS_PUSHED;
    if DrawItemStruct.itemState and ODS_DISABLED <> 0 then
      Flags := Flags or DFCS_INACTIVE;
    { Don't draw flat if mouse is over it or has the input focus }
    if FFlat and (not FIsMouseOver) and (not Focused) then
      Flags := Flags or DFCS_FLAT;

    if IsDown then
    begin
      FCanvas.Pen.Color := clWindowFrame;
      FCanvas.Pen.Width := 1;
      FCanvas.Brush.Style := bsClear;
      FCanvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);

      { DrawFrameControl must draw within this border }
      InflateRect(R, -1, -1);
    end;

    { DrawFrameControl does not draw a pressed button correctly }
    if IsDown then
    begin
      FCanvas.Pen.Color := clBtnShadow;
      FCanvas.Pen.Width := 1;
      FCanvas.Brush.Color := clBtnFace;
      FCanvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
      InflateRect(R, -1, -1);
    end else begin
      if (csDesigning in ComponentState) or
         (FFlat and ((Flags and DFCS_FLAT) = 0)) then
      begin
        // Flat, but it has focus or mouse is over.
        FCanvas.Pen.Color := clBtnHighlight;
        FCanvas.MoveTo(R.Left, R.Bottom-1);
        FCanvas.LineTo(R.Left, R.Top);
        FCanvas.LineTo(R.Right-1, R.Top);
        FCanvas.Pen.Color := clBtnShadow;
        FCanvas.LineTo(R.Right-1, R.Bottom-1);
        FCanvas.LineTo(R.Left, R.Bottom-1);
        InflateRect(R, -1, -1);
        FCanvas.Brush.Color := clBtnFace;
        FCanvas.FillRect(R);
      end else begin
        DrawFrameControl(DrawItemStruct.hDC, R, DFC_BUTTON, Flags);
        if (Flags and DFCS_FLAT) <> 0 then
        begin
          { I don't know why, but it insists on drawing this little rectangle }
          InflateRect(R, 2, 2);
          FCanvas.Brush.Color := clBtnFace;
          FCanvas.FrameRect(R);
          InflateRect(R, -2, -2);
        end;
      end;
    end;

    R := ClientRect;
    if IsDown then
      OffsetRect(R, 1, 1);
    InflateRect(R, -3, -3);
    if IsFocused and IsDefault then
    begin
      FCanvas.Pen.Color := clWindowFrame;
      FCanvas.Brush.Color := clBtnFace;
      DrawFocusRect(FCanvas.Handle, R);
    end;
    InflateRect(R, -1, -1);
{$ELSE}

    NewStyle := ((Style = bsAutoDetect) and NewStyleControls) or (Style = bsNew);

    if NewStyle then Bevel := 1
    else Bevel := 2;

    R := DrawButtonFace(FCanvas, ClientRect, Bevel, FStyle, not NewStyle,
      IsDown, IsDefault or IsFocused);

    if IsDefault then
    begin
      FCanvas.Brush.Color := clBtnFace;
      TextBounds := R;
      if NewStyle then
      begin
        InflateRect(TextBounds, -2, -2);
        if IsDown then OffsetRect(TextBounds, -1, -1);
      end
      else InflateRect(TextBounds, -2, -2);
      DrawFocusRect(FCanvas.Handle, TextBounds);
    end;
    InflateRect(R, -3, -3);

{$ENDIF}

    { Draw the color rect }
    InflateRect(R, -2, -1);
    Dec(R.Right, 10);
    if (not Enabled) or ((DrawItemStruct.itemState and ODS_DISABLED) <> 0) then
    begin
      FCanvas.Brush.Color := clWindowFrame;
      FCanvas.FrameRect(R);
      InflateRect(R, -1, -1);
      ShadeRect(FCanvas.Handle, R);
    end else begin
      FCanvas.Pen.Color := clWindowFrame;
      FCanvas.Pen.Width := 1;
      FCanvas.Brush.Style := bsClear;
      FCanvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
      FCanvas.Brush.Color := FColor;
      FCanvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
    end;

    { Draw divider line }
    R.Left := R.Right + 3;
    FCanvas.Pen.Color := clBtnShadow;
    FCanvas.MoveTo(R.Left, R.Top);
    FCanvas.LineTo(R.Left, R.Bottom);
    inc(R.Left);
    FCanvas.Pen.Color := clBtnHighlight;
    FCanvas.MoveTo(R.Left, R.Top);
    FCanvas.LineTo(R.Left, R.Bottom);

    { Draw the arrow }
    if Enabled or ((DrawItemStruct.itemState and ODS_DISABLED) = 0) then
      Bmp := FArrowBmp
    else
      Bmp := FDisabledArrowBmp;
    inc(R.Left, 1);
    inc(R.Top, ((R.Bottom - R.Top) div 2) - (Bmp.Height div 2));
    R.Right := R.Left + Bmp.Width-1;
    R.Bottom := R.Top + Bmp.Height-1;
    FCanvas.Brush.Color := clBtnFace;
    FCanvas.BrushCopy(R, Bmp, Rect(0, 0, Bmp.Width-1, Bmp.Height-1),
       Bmp.Canvas.Pixels[0, Bmp.Height-1]);
  finally
    FCanvas.Handle := 0;
  end;
end;
{$IFDEF DFS_OPTIMIZATION_ON}
  {$O+}
  {$UNDEF DFS_OPTIMIZATION_ON}
{$ENDIF}


procedure TdfsColorButton.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TdfsColorButton.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TdfsColorButton.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  Perform(WM_LBUTTONDOWN, Message.Keys, Longint(Message.Pos));
end;

procedure TdfsColorButton.SetButtonStyle(ADefault: Boolean);
begin
  if ADefault <> IsFocused then
  begin
    IsFocused := ADefault;
    Refresh;
  end;
end;

procedure TdfsColorButton.Click;
var
  PalXY: TPoint;
  ArrowHit: boolean;
  NewIdx: integer;
  CursorPos: TPoint;
  ParentForm: TCustomForm;
{$IFDEF DFS_WIN32}
  ScreenRect: TRect;
{$ENDIF}
begin
  if FInhibitClick then
  begin
    FInhibitClick := FALSE;
    exit;
  end;

  if not FIgnoreTopmosts then
{$IFDEF DFS_DELPHI_3_UP}
    Application.NormalizeAllTopMosts;
{$ELSE}
    Application.NormalizeTopMosts;
{$ENDIF}

  GetCursorPos(CursorPos);
  CursorPos := ScreenToClient(CursorPos);
  ArrowHit := CursorPos.X > (Width - 13);
  if FCycleColors and (not ArrowHit) then
  begin
    NewIdx := FCurrentPaletteIndex + 1;
    if NewIdx > PaletteColors.Count then
      PaletteColorIndex := 0
    else
      PaletteColorIndex := NewIdx;
  end else begin
    FPaletteForm := TdfsColorButtonPalette.Create(Self);
    PalXY := Parent.ClientToScreen(Point(Left, Top + Height));
  {$IFDEF DFS_WIN32}
    { Screen.Width and Height don't account for non-hidden task bar. }
    SystemParametersInfo(SPI_GETWORKAREA, 0, @ScreenRect, 0);
    if PalXY.Y + FPaletteForm.Height > ScreenRect.Bottom then
      { No room to display below the button, show it above instead }
      PalXY := Parent.ClientToScreen(Point(Left, Top - 121));
    if PalXY.X < ScreenRect.Left then
      { No room to display horizontally, shift right }
      PalXY.X := ScreenRect.Left
    else if PalXY.X + FPaletteForm.Width > ScreenRect.Right then
      { No room to display horizontally, shift left }
      PalXY.X := ScreenRect.Right - 78;
    FPaletteForm.SetBounds(PalXY.X, PalXY.Y, FPaletteForm.Width,
      FPaletteForm.Height);
  {$ELSE}
    if PalXY.Y + FPaletteForm.Height > Screen.Height then
      { No room to display below the button, show it above instead }
      PalXY := Parent.ClientToScreen(Point(Left, Top - 121));
    if PalXY.X < 0 then
      { No room to display horizontally, shift right }
      PalXY.X := 0
    else if PalXY.X + FPaletteForm.Width > Screen.Width then
      { No room to display horizontally, shift left }
      PalXY.X := Screen.Width - 78;
    FPaletteForm.SetBounds(PalXY.X, PalXY.Y, FPaletteForm.Width,
      FPaletteForm.Height);
  {$ENDIF}
    FPaletteForm.ShowColorHints := ShowColorHints;
    FPaletteForm.btnOther.Caption := OtherBtnCaption;
    FPaletteForm.OtherColor := OtherColor;
    FPaletteForm.StartColor := Color;
    FPaletteForm.SetParentColor := PaletteSetColor;
    FPaletteForm.PaletteClosed := PaletteClosed;
    FPaletteForm.PaletteColors := PaletteColors;
    FPaletteForm.CustomColors := CustomColors;
    FPaletteForm.OnGetColorHintText := FOnGetColorHintText;
    FPaletteDisplayed := TRUE;
    Refresh;
    FPaletteForm.Show;
    ParentForm := GetParentForm(Self);
    if ParentForm <> NIL then
      FlashWindow(ParentForm.Handle, TRUE);
  end;
end;

procedure TdfsColorButton.PaletteSetColor(Sender: TObject; IsOther: boolean;
   AColor: TColor);
begin
  Color := AColor;
  if IsOther then
    OtherColor := AColor;
end;

procedure TdfsColorButton.PaletteClosed(Sender: TObject);
var
  CP: TPoint;
  ParentForm: TCustomForm;
begin
  ParentForm := GetParentForm(Self);
  if ParentForm <> NIL then
    FlashWindow(ParentForm.Handle, FALSE);
  if FPaletteForm = NIL then exit;
  if not FPaletteForm.KeyboardClose then
  begin
    GetCursorPos(CP);
    CP := ScreenToClient(CP);
    if (CP.X >= 0) and (CP.X < Width) and (CP.Y >= 0) and (CP.Y < Height) then
      FInhibitClick := TRUE;
  end;
  CustomColors := FPaletteForm.CustomColors;
  FPaletteDisplayed := FALSE;
  Invalidate;
  FPaletteForm := NIL;
  if not FIgnoreTopmosts then
    Application.RestoreTopMosts;
end;

procedure TdfsColorButton.SetPaletteColors(Value: TPaletteColors);
begin
  FPaletteColors.Assign(Value);
end;

procedure TdfsColorButton.SetCustomColors(Value: TCustomColors);
begin
  FCustomColors.Assign(Value);
end;


function ColorEnumProc(Pen : PLogPen; Colors : PColorArrayCallback): integer;
   {$IFDEF DFS_WIN32} stdcall; {$ELSE} export; {$ENDIF}
begin
  if Pen^.lopnStyle = PS_SOLID then
  begin
    if Colors^[0] < 20 then
    begin
      inc(Colors^[0]);
      Colors^[Colors^[0]] := Pen^.lopnColor;
      Result := 1;
    end else
      Result := 0;
  end else
    Result := 1;
end;


procedure TdfsColorButton.SetDefaultColors;
var
  X, Y: integer;
  DefColors: TColorArrayCallback;
  DC: HDC;
  {$IFNDEF DFS_WIN32}
  CallbackProc: TFarProc;
  {$ENDIF}
begin
  DC := GetDC(GetDesktopWindow);
  try
    if GetDeviceCaps(DC, NUMCOLORS) = 16 then
    begin
      { 16 color mode, enum colors to fill array }
      FillChar(DefColors, SizeOf(DefColors), #0);
      {$IFDEF DFS_WIN32}
      EnumObjects(DC, OBJ_PEN, @ColorEnumProc, LPARAM(@DefColors));
      {$ELSE}
      CallbackProc := MakeProcInstance(@ColorEnumProc, hInstance);
      try
        EnumObjects(DC, OBJ_PEN, CallbackProc, @DefColors);
      finally
        FreeProcInstance(CallbackProc);
      end;
      {$ENDIF}

      for X := 1 to 4 do
      begin
        for Y := 1 to 5 do
        begin
          PaletteColors[X,Y] := DefColors[(X-1)*5+Y];
        end;
      end;
    end else begin
      { Lots 'o colors, pick the ones we want. }
      PaletteColors[1,1] := RGB(255,255,255);
      PaletteColors[1,2] := RGB(255,0,0);
      PaletteColors[1,3] := RGB(0,255,0);
      PaletteColors[1,4] := RGB(0,0,255);
      PaletteColors[1,5] := RGB(191,215,191);
      PaletteColors[2,1] := RGB(0,0,0);
      PaletteColors[2,2] := RGB(127,0,0);
      PaletteColors[2,3] := RGB(0,127,0);
      PaletteColors[2,4] := RGB(0,0,127);
      PaletteColors[2,5] := RGB(159,191,239);
      PaletteColors[3,1] := RGB(191,191,191);
      PaletteColors[3,2] := RGB(255,255,0);
      PaletteColors[3,3] := RGB(0,255,255);
      PaletteColors[3,4] := RGB(255,0,255);
      PaletteColors[3,5] := RGB(255,247,239);
      PaletteColors[4,1] := RGB(127,127,127);
      PaletteColors[4,2] := RGB(127,127,0);
      PaletteColors[4,3] := RGB(0,127,127);
      PaletteColors[4,4] := RGB(127,0,127);
      PaletteColors[4,5] := RGB(159,159,159);
    end;
  finally
    ReleaseDC(GetDesktopWindow, DC);
  end;

  for x := 1 to 8 do
    for y := 1 to 2 do
      CustomColors[x,y] := clWhite;

  FOtherColor := clBtnFace;
end;


function TdfsColorButton.GetSectionName: string;
begin
  Result := Self.Name;
  if Parent <> NIL then
    Result := Parent.Name + '.' + Result;
end;


procedure TdfsColorButton.SaveCustomColors;
var
  {$IFDEF DFS_WIN32}
  Reg: TRegIniFile;
  {$ELSE}
  Ini: TIniFile;
  {$ENDIF}
  Colors: string;
  x: integer;
  y: integer;
begin
  Colors := '';
  for x := 1 to 8 do
  begin
    for y := 1 to 2 do
    begin
      Colors := Colors + '$' + IntToHex(CustomColors[x,y], 8) + ',';
    end;
  end;
  Delete(Colors, Length(Colors), 1); { strip last comma }

  {$IFDEF DFS_WIN32}
  if FCustomColorsKey <> '' then
  begin
    Reg := TRegIniFile.Create(FCustomColorsKey);
    try
      Reg.WriteString('Colors', FSectionName, Colors);
    finally
      Reg.Free;
    end;
  end;
  {$ELSE}
  if FCustomColorsINI <> '' then
  begin
    Ini := TIniFile.Create(FCustomColorsINI);
    try
      Ini.WriteString('Colors', FSectionName, Colors);
    finally
      Ini.Free;
    end;
  end;
  {$ENDIF}
end;


procedure TdfsColorButton.LoadCustomColors;
var
  {$IFDEF DFS_WIN32}
  Reg: TRegIniFile;
  {$ELSE}
  Ini: TIniFile;
  {$ENDIF}
  Colors: string;
  AColor: string;
  CPos: byte;
  x: integer;
  y: integer;
begin
  Colors := '';
  FSectionName := GetSectionName;
  FColorsLoaded := TRUE;

  {$IFDEF DFS_WIN32}
  if FCustomColorsKey <> '' then
  begin
    Reg := TRegIniFile.Create(FCustomColorsKey);
    try
      Colors := Reg.ReadString('Colors', FSectionName, '');
    finally
      Reg.Free;
    end;
  {$ELSE}
  if FCustomColorsINI <> '' then
  begin
    Ini := TIniFile.Create(FCustomColorsINI);
    try
      Colors := Ini.ReadString('Colors', FSectionName, '');
    finally
      Ini.Free;
    end;
  {$ENDIF}
		if Colors <> '' then
		begin
      x := 1;
      y := 1;
      CPos := Pos(',', Colors);
      while CPos > 0 do
      begin
        AColor := Copy(Colors, 1, CPos-1);
        CustomColors[x,y] := StrToIntDef(AColor, clWhite);
        inc(y);
        if y > 2 then
        begin
          y := 1;
          inc(x);
          if x > 8 then
            break;  { all done }
        end;
        Colors := Copy(Colors, CPos+1, Length(Colors));
      end;    { while }
		end;
  end;
end;


procedure TdfsColorButton.DoColorChange;
begin
  if assigned(FOnColorChange) then
    FOnColorChange(Self);
end;

procedure TdfsColorButton.SetArrowBmp(Value: TBitmap);
begin
  if Value <> NIL then
  begin
    FArrowBmp.Assign(Value);
    Invalidate;
  end;
end;

procedure TdfsColorButton.SetDisabledArrowBmp(Value: TBitmap);
begin
  if Value <> NIL then
  begin
    FDisabledArrowBmp.Assign(Value);
    Invalidate;
  end;
end;

{$IFDEF DFS_WIN32}
procedure TdfsColorButton.SetFlat(Value: boolean);
begin
  if Value <> FFlat then
  begin
    FFlat := Value;
    Invalidate;
  end;
end;

procedure TdfsColorButton.CMMouseEnter(var Message: TMessage);
begin
  if FFlat and (not FIsMouseOver) then
    Invalidate;
end;

procedure TdfsColorButton.CMMouseLeave(var Message: TMessage);
begin
  if FFlat and (FIsMouseOver) then
    Invalidate;
end;
{$ENDIF}

function TdfsColorButton.GetVersion: string;
begin
  Result := DFS_COMPONENT_VERSION;
end;

procedure TdfsColorButton.SetVersion(const Val: string);
begin
  { empty write method, just needed to get it to show up in Object Inspector }
end;

end.


