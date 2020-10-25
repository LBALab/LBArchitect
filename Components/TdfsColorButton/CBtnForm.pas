{$I DFS.INC}  { Standard defines for all Delphi Free Stuff components }

{------------------------------------------------------------------------------}
{ A Windows 95 and NT 4 style color selection button.  It displays a palette   }
{ of 20 color for fast selction and a button to bring up the color dialog.     }
{                                                                              }
{ Copyright 1999, Brad Stowers.  All Rights Reserved.                          }
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
{ example, if you create a descendant of TDFSColorButton, you must include in  }
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
{ All DFS source code is provided free of charge. As such, I can not guarantee }
{ any support whatsoever. While I do try to answer all questions that I        }
{ receive, and address all problems that are reported to me, you must          }
{ understand that I simply can not guarantee that this will always be so.      }
{                                                                              }
{ Clarifications:                                                              }
{ If you need any further information, please feel free to contact me directly.}
{ This agreement can be found online at my site in the "Miscellaneous" section.}
{------------------------------------------------------------------------------}
{ Feel free to contact me if you have any questions, comments or suggestions   }
{ at bstowers@pobox.com.                                                       }
{ The lateset version of my components are always available on the web at:     }
{   http://www.delphifreestuff.com/                                            }
{------------------------------------------------------------------------------}
{ Date last modified:  February 23, 1999                                       }
{------------------------------------------------------------------------------}


{-----------------------------------------------------------------------------}
{ TDFSColorButtonPalette                                                      }
{-----------------------------------------------------------------------------}
{ Description:                                                                }
{   This is a support unit for the TDFSColorButton component (DFSClrBn.pas).  }
{-----------------------------------------------------------------------------}
unit CBtnForm;

interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

const
  MAX_COLORS = (MaxInt div SizeOf(TColor));

type
  PColorArrayCallback = ^TColorArrayCallBack;
  TColorArrayCallback = Array[0..20] of TColorRef;

  TSetParentColorEvent = procedure(Sender: TObject; IsOther: boolean;
     AColor: TColor) of object;

  TDFSColorHintTextEvent = procedure(Sender: TObject; AColor: TColor;
     X, Y: integer; var HintStr: string) of object;

  EColorArrayIndexError = class(Exception);

  PColorArray = ^TColorArray;
  TColorArray = array[1..MAX_COLORS] of TColor;

  TColorArrayClass = class(TPersistent)
  private
    FXSize,
    FYSize: integer;
    FCount: integer;
    FColors: PColorArray;

    function GetColor(X, Y: integer): TColor;
    procedure SetColor(X, Y: integer; Value: TColor);
    procedure SetXSize(Value: integer);
    procedure SetYSize(Value: integer);
    function GetSingleColor(Index: integer): TColor;
    procedure SetSingleColor(Index: integer; Value: TColor);
  protected
    procedure CheckXYVals(X, Y: integer);
    procedure ReadXSize(Reader: TReader);
    procedure WriteXSize(Writer: TWriter);
    procedure ReadYSize(Reader: TReader);
    procedure WriteYSize(Writer: TWriter);
    procedure ReadColors(Reader: TReader);
    procedure WriteColors(Writer: TWriter);
  public
    constructor Create(X, Y: integer); virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure DefineProperties(Filer: TFiler); override;
    function IsEqualTo(OtherColors: TColorArrayClass): boolean; virtual;

    property Color[X: integer; Y: integer]: TColor
       read GetColor
       write SetColor;
       default;
    property Colors[Index: integer]: TColor
      read GetSingleColor
      write SetSingleColor;
{  published}
    property XSize: integer
       read FXSize
       write SetXSize;
    property YSize: integer
       read FYSize
       write SetYSize;
    property Count: integer
       read FCount;
  end;

  TPaletteColors = TColorArrayClass;
  TCustomColors = TColorArrayClass;

  TDFSColorButtonPalette = class(TForm)
    btnOther: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDeactivate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOtherClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FShowColorHints: boolean;
    FKeyboardClose: boolean;
    FPreventClose: boolean;
    FOldAppDeactivate: TNotifyEvent;
    FPaletteColors: TPaletteColors;
    FCustomColors: TCustomColors;
    FStartColor,
    FOtherColor: TColor;
    FLastFrame: TPoint;
    FSetParentColor: TSetParentColorEvent;
    FPaletteClosed: TNotifyEvent;
    FOldAppShowHint: TShowHintEvent;
    FOnGetColorHintText: TDFSColorHintTextEvent;

    function ValidColorIndex(X, Y: integer): boolean;
    procedure AppDeactivate(Sender: TObject);
    function GetSquareCoords(X, Y: integer): TRect;
    procedure DrawSquare(X, Y: integer; AColor: TColor; IsFocused: boolean);
    procedure FrameCurrentSquare(NewFrame: TPoint);
    function GetCurrentSquare: TPoint;
    procedure SetStartColor(Value: TColor);
    procedure SetPaletteColors(Value: TPaletteColors);
    procedure SetCustomColors(Value: TCustomColors);
    procedure PaletteShowHint(var HintStr: string; var CanShow: Boolean;
       var HintInfo: THintInfo);
    procedure SetShowColorHints(Val: boolean);
  protected
    function BuildHintText(AColor: TColor; X, Y: integer): string; virtual;
    procedure GetColorHintText(AColor: TColor; X, Y: integer;
       var HintStr: string); virtual;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property ShowColorHints: boolean
       read FShowColorHints
       write SetShowColorHints;
    property KeyboardClose: boolean
       read FKeyboardClose
       write FKeyboardClose;
    property SetParentColor: TSetParentColorEvent
       read FSetParentColor
       write FSetParentColor;
    property PaletteClosed: TNotifyEvent
       read FPaletteClosed
       write FPaletteClosed;
    property StartColor: TColor
       read FStartColor
       write SetStartColor;
    property OtherColor: TColor
       read FOtherColor
       write FOtherColor;
    property PaletteColors: TPaletteColors
       read FPaletteColors
       write SetPaletteColors;
    property CustomColors: TCustomColors
       read FCustomColors
       write SetCustomColors;
    property OnGetColorHintText: TDFSColorHintTextEvent
       read FOnGetColorHintText
       write FOnGetColorHintText;
  end;


implementation

{$R *.DFM}

uses
  ExtCtrls;


constructor TColorArrayClass.Create(X, Y: integer);
begin
  inherited Create;

  FXSize := X;
  FYSize := Y;
  FCount := X * Y;
  GetMem(FColors, X * Y * SizeOf(TColor));
end;

destructor TColorArrayClass.Destroy;
begin
  FreeMem(FColors, FXSize * FYSize * SizeOf(TColor));
  FCount := 0;

  inherited Destroy;
end;

function TColorArrayClass.GetColor(X, Y: integer): TColor;
begin
  CheckXYVals(X, Y);
  Result := FColors^[(Y-1)*FXSize+X];
end;

procedure TColorArrayClass.SetColor(X, Y: integer; Value: TColor);
begin
  CheckXYVals(X, Y);
  FColors^[(Y-1)*FXSize+X] := Value;
end;

procedure TColorArrayClass.SetXSize(Value: integer);
begin
  if Value <> XSize then
  begin
    FreeMem(FColors, XSize * YSize * SizeOf(TColor));
    FXSize := Value;
    GetMem(FColors, XSize * YSize * SizeOf(TColor));
    FCount := XSize * YSize;
    { really need to recopy colors, but I'm lazy and don't need it right now }
  end;
end;

procedure TColorArrayClass.SetYSize(Value: integer);
begin
  if Value <> YSize then
  begin
    FreeMem(FColors, XSize * YSize * SizeOf(TColor));
    FYSize := Value;
    GetMem(FColors, XSize * YSize * SizeOf(TColor));
    FCount := XSize * YSize;
    { really need to recopy colors, but I'm lazy and don't need it right now }
  end;
end;

function TColorArrayClass.GetSingleColor(Index: integer): TColor;
begin
  if (Index < 1) or (Index > (XSize * YSize)) then
    raise EColorArrayIndexError.Create('Array index out of bounds');
  Result := FColors^[Index];
end;

procedure TColorArrayClass.SetSingleColor(Index: integer; Value: TColor);
begin
  if (Index < 1) or (Index > (XSize * YSize)) then
    raise EColorArrayIndexError.Create('Array index out of bounds');
  if FColors^[Index] <> Value then
    FColors^[Index] := Value;
end;

procedure TColorArrayClass.CheckXYVals(X, Y: integer);
begin
  if (X < 1) or (Y < 1) or (X > XSize) or (Y > YSize) then
    raise EColorArrayIndexError.Create('Array index out of bounds');
end;


procedure TColorArrayClass.ReadXSize(Reader: TReader);
begin
  XSize := Reader.ReadInteger;
end;

procedure TColorArrayClass.WriteXSize(Writer: TWriter);
begin
  Writer.WriteInteger(XSize);
end;

procedure TColorArrayClass.ReadYSize(Reader: TReader);
begin
  YSize := Reader.ReadInteger;
end;

procedure TColorArrayClass.WriteYSize(Writer: TWriter);
begin
  Writer.WriteInteger(YSize);
end;

procedure TColorArrayClass.ReadColors(Reader: TReader);
var
  X, Y: integer;
begin
  X := 1;
  Y := 1;
  Reader.ReadListBegin;
  while not Reader.EndOfList do
  begin
    Color[X, Y] := Reader.ReadInteger;
    if Y < YSize then
      inc(Y)
    else begin
      Y := 1;
      inc(X);
    end;
  end;
  Reader.ReadListEnd;
end;

procedure TColorArrayClass.WriteColors(Writer: TWriter);
var
  X, Y: integer;
begin
  Writer.WriteListBegin;
  for X := 1 to XSize do
    for Y := 1 to YSize do
      Writer.WriteInteger(Color[X, Y]);
  Writer.WriteListEnd;
end;

procedure TColorArrayClass.DefineProperties(Filer: TFiler);
begin
  Filer.DefineProperty('XSize', ReadXSize, WriteXSize, TRUE);
  Filer.DefineProperty('YSize', ReadYSize, WriteYSize, TRUE);
  Filer.DefineProperty('Colors', ReadColors, WriteColors, TRUE);
end;

procedure TColorArrayClass.Assign(Source: TPersistent);
var
  x, y: integer;
begin
  if Source is TColorArrayClass then
  begin
    FreeMem(FColors, XSize * YSize * SizeOf(TColor));
    FXSize := TColorArrayClass(Source).XSize;
    FYSize := TColorArrayClass(Source).YSize;
    FCount := FXSize * FYSize;
    GetMem(FColors, XSize * YSize * SizeOf(TColor));
    for x := 1 to XSize do
    begin
      for y := 1 to YSize do
      begin
        Color[x,y] := TColorArrayClass(Source).Color[x,y];
      end;
    end;
  end else
    inherited Assign(Source);
end;

function TColorArrayClass.IsEqualTo(OtherColors: TColorArrayClass): boolean;
var
  x, y: integer;
begin
  Result := FALSE;
  if OtherColors = Self then
  begin
    Result := TRUE;
    exit;
  end;
  if OtherColors <> NIL then
  begin
    if (XSize = OtherColors.XSize) and (YSize = OtherColors.YSize) then
    begin
      for x := 1 to XSize do
      begin
        for y := 1 to YSize do
        begin
          if Color[x,y] <> OtherColors.Color[x,y] then
            exit;
        end;
      end;
      Result := TRUE;  { all colors matched }
    end;
  end;
end;





constructor TDFSColorButtonPalette.Create(AOwner: TComponent);
begin
  { Inherited is going to fire FormCreate which needs the colors, so create our
    stuff before calling inherited. }
  FPaletteColors := TColorArrayClass.Create(4,5);
  FCustomColors := TColorArrayClass.Create(8,2);
  FKeyboardClose := FALSE;
  FShowColorHints := TRUE;

  inherited Create(AOwner);
end;

destructor TDFSColorButtonPalette.Destroy;
begin
  FPaletteColors.Free;
  FCustomColors.Free;

  inherited Destroy;
end;

procedure TDFSColorButtonPalette.Loaded;
begin
  inherited Loaded;

  ShowHint := FShowColorHints;
end;

procedure TDFSColorButtonPalette.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

{$IFDEF DFS_WIN32}
  Params.Style := Params.Style AND NOT WS_CAPTION;
{$ELSE}
  Params.Style := WS_POPUP or WS_DLGFRAME or DS_MODALFRAME;
{$ENDIF}
end;

procedure TDFSColorButtonPalette.GetColorHintText(AColor: TColor; X, Y: integer;
   var HintStr: string);
begin
  if assigned(FOnGetColorHintText) then
    FOnGetColorHintText(Parent, AColor, X, Y, HintStr);
end;

procedure TDFSColorButtonPalette.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  if assigned(FPaletteClosed) then
    FPaletteClosed(Self);
end;

procedure TDFSColorButtonPalette.FormDeactivate(Sender: TObject);
begin
  Close;
end;

procedure TDFSColorButtonPalette.FormPaint(Sender: TObject);
var
  X, Y: integer;
begin
  for X := 1 to 4 do
  begin
    for Y := 1 to 5 do
    begin
      { Draw color square }
      DrawSquare(X, Y, FPaletteColors[x,y], FALSE);
    end;
  end;

  { Draw seperator line }
  with Canvas do
  begin
    Pen.Color := clBtnShadow;
    MoveTo(2, 93);
    LineTo(ClientWidth - 2, 93);
    Pen.Color := clBtnHighlight;
    MoveTo(2, 94);
    LineTo(ClientWidth - 2, 94);
  end;

  { Draw "other" color }
  DrawSquare(0, 0, FOtherColor, FALSE);

  { Draw the current selection }
  FrameCurrentSquare(GetCurrentSquare)
end;

function TDFSColorButtonPalette.GetSquareCoords(X, Y: integer): TRect;
begin
  Result := Rect(0,0,0,0);

  if (Y = 0) then
  begin
    { other square }
    X := ClientWidth - 18;
    Y := btnOther.Top + ((btnOther.Height - 16) div 2);
  end else if ValidColorIndex(X, Y) then
  begin
    X := (X-1) * 18 + 1;
    Y := (Y-1) * 18 + 1;
  end else
    exit;

  Result := Rect(X-1, Y-1, X+17, Y+17);
end;

procedure TDFSColorButtonPalette.DrawSquare(X, Y: integer; AColor: TColor;
   IsFocused: boolean);
var
  R: TRect;
begin
  R := GetSquareCoords(X, Y);
  if IsRectEmpty(R) then
    exit;

  if (Y = 0) then
    AColor := FOtherColor;

  with Canvas do
  begin
    if IsFocused then
    begin
      Brush.Color := {$IFDEF DFS_WIN32} cl3DDkShadow; {$ELSE} clBlack; {$ENDIF}
      FrameRect(R);
      InflateRect(R, -1, -1);
      Brush.Color := clBtnHighlight;
      FrameRect(R);
      InflateRect(R, -1, -1);
      Brush.Color := {$IFDEF DFS_WIN32} cl3DDkShadow; {$ELSE} clBlack; {$ENDIF}
      FrameRect(R);
      InflateRect(R, -1, -1);
    end else begin
      { Get rid of any focus framing rect left over from previous paint }
      Brush.Color := Self.Color;
      FrameRect(R);
      InflateRect(R, -1, -1);
      { Draw a 3D frame }
      Frame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1);
      { Frame3D reduces the rectangle size by 1 }
      Frame3D(Canvas, R, {$IFDEF DFS_WIN32} cl3DDkShadow {$ELSE} clBlack {$ENDIF},
          {$IFDEF DFS_WIN32} cl3DLight {$ELSE} clSilver {$ENDIF}, 1);
    end;
    { Paint the color }
    Brush.Color := AColor;
    FillRect(R);
  end;
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

procedure TDFSColorButtonPalette.FormCreate(Sender: TObject);
var
  X, Y: integer;
  Colors: TColorArrayCallback;
  DC: HDC;
  {$IFNDEF DFS_WIN32}
  CallbackProc: TFarProc;
  {$ENDIF}
begin
  FPreventClose := FALSE;
  
  FOldAppDeactivate := Application.OnDeactivate;
  Application.OnDeactivate := AppDeactivate;
  FOldAppShowHint := Application.OnShowHint;
  Application.OnShowHint := PaletteShowHint;

  FLastFrame := Point(-1,-1);

  DC := GetDC(GetDesktopWindow);
  try
    if GetDeviceCaps(DC, NUMCOLORS) = 16 then
    begin
      { 16 color mode, enum colors to fill array }
      FillChar(Colors, SizeOf(Colors), #0);
      {$IFDEF DFS_WIN32}
      EnumObjects(DC, OBJ_PEN, @ColorEnumProc, LPARAM(@Colors));
      {$ELSE}
      CallbackProc := MakeProcInstance(@ColorEnumProc, hInstance);
      try
        EnumObjects(DC, OBJ_PEN, CallbackProc, @Colors);
      finally
        FreeProcInstance(CallbackProc);
      end;
      {$ENDIF}

      for X := 1 to 4 do
      begin
        for Y := 1 to 5 do
        begin
          FPaletteColors[X,Y] := Colors[(X-1)*5+Y];
        end;
      end;
    end else begin
      { Lots 'o colors, pick the ones we want. }
      FPaletteColors[1,1] := RGB(255,255,255);
      FPaletteColors[1,2] := RGB(255,0,0);
      FPaletteColors[1,3] := RGB(0,255,0);
      FPaletteColors[1,4] := RGB(0,0,255);
      FPaletteColors[1,5] := RGB(191,215,191);
      FPaletteColors[2,1] := RGB(0,0,0);
      FPaletteColors[2,2] := RGB(127,0,0);
      FPaletteColors[2,3] := RGB(0,127,0);
      FPaletteColors[2,4] := RGB(0,0,127);
      FPaletteColors[2,5] := RGB(159,191,239);
      FPaletteColors[3,1] := RGB(191,191,191);
      FPaletteColors[3,2] := RGB(255,255,0);
      FPaletteColors[3,3] := RGB(0,255,255);
      FPaletteColors[3,4] := RGB(255,0,255);
      FPaletteColors[3,5] := RGB(255,247,239);
      FPaletteColors[4,1] := RGB(127,127,127);
      FPaletteColors[4,2] := RGB(127,127,0);
      FPaletteColors[4,3] := RGB(0,127,127);
      FPaletteColors[4,4] := RGB(127,0,127);
      FPaletteColors[4,5] := RGB(159,159,159);
    end;
  finally
    ReleaseDC(GetDesktopWindow, DC);
  end;

  FOtherColor := clBtnFace;
  FStartColor := clBlack;

  { Oh, how I do hate large fonts. }
  ClientWidth := 72;
  btnOther.Top := 98;
  btnOther.Width := ClientWidth - 22;
  ClientHeight := btnOther.Top + btnOther.Height + 2;
end;

procedure TDFSColorButtonPalette.SetStartColor(Value: TColor);
var
  x, y: integer;
begin
  FStartColor := Value;
  { See if we have that color }
  for x := 1 to 4 do
  begin
    for y := 1 to 5 do
    begin
      if ColorToRGB(FPaletteColors[x,y]) = ColorToRGB(FStartColor) then
      begin
        FLastFrame := Point(x,y);
        DrawSquare(x, y, FStartColor, TRUE);
        exit;
      end;
    end;
  end;
  { didn't find it }
  FOtherColor := FStartColor;
end;

procedure TDFSColorButtonPalette.SetShowColorHints(Val: boolean);
begin
  FShowColorHints := Val;
  ShowHint := Val;
end;

procedure TDFSColorButtonPalette.AppDeactivate(Sender: TObject);
begin
  if FPreventClose then
    exit;

  if assigned(FOldAppDeactivate) then
    FOldAppDeactivate(Sender);

  Close;
end;

function TDFSColorButtonPalette.BuildHintText(AColor: TColor;
   X, Y: integer): string;
type
  {$IFNDEF DFS_WIN32}
  DWORD = longint;
  {$ENDIF}
  TRGBMap = packed record
    case boolean of
      TRUE:  ( RGBVal: DWORD );
      FALSE: ( Red,
               Green,
               Blue,
               Unused: byte );
  end;
var
  RGBColor: TRGBMap;
begin
  RGBColor.RGBVal := ColorToRGB(AColor);
  { for hex, you could use:
  HintStr := Format('RGB = %.2x %.2x %.2x', [AColor.Red, AColor.Green,}
  Result := Format('RGB = %.3d %.3d %.3d', [RGBColor.Red, RGBColor.Green,
     RGBColor.Blue]);

  GetColorHintText(AColor, X, Y, Result);
end;

procedure TDFSColorButtonPalette.PaletteShowHint(var HintStr: string;
   var CanShow: Boolean; var HintInfo: THintInfo);
var
  CS: TPoint;
  AColor: TColor;
begin
  if HintInfo.HintControl = Self then
  begin
    CS := GetCurrentSquare;
    if ValidColorIndex(CS.X, CS.Y) then
    begin
      { Hint is valid as long as cursor stays inside this color square }
      HintInfo.CursorRect := GetSquareCoords(CS.X, CS.Y);
      if CS.Y = 0 then
        AColor := FOtherColor
      else
        AColor := FPaletteColors[CS.X, CS.Y];

      HintStr := BuildHintText(AColor, CS.X, CS.Y);

      CanShow := HintStr <> '';

      {$IFNDEF DFS_DELPHI_3_UP}
      if CanShow then
      begin
        CS.X := HintInfo.CursorRect.Left;
        CS.Y := HintInfo.CursorRect.Bottom + 8;
        HintInfo.HintPos := ClientToScreen(CS);
      end;
      {$ENDIF}
    end else
      CanShow := FALSE;
  end;
  if assigned(FOldAppShowHint) then
    FOldAppShowHint(HintStr, CanShow, HintInfo);
end;

procedure TDFSColorButtonPalette.btnOtherClick(Sender: TObject);
var
  AColor: TColor;
  c: char;
  p: integer;
  y: integer;
  x: integer;
  z: integer;
  Dlg: TColorDialog;
  ColorPicked: boolean;
begin
  Dlg := TColorDialog.Create(Self);
  try
    FPreventClose := TRUE;
    Dlg.Color := FOtherColor;
    Dlg.Options := [cdFullOpen];
    { set custom colors here }
    for x := 1 to 8 do
    begin
      for y := 1 to 2 do
      begin
        c := Chr((y-1)*8+x + 64);
        Dlg.CustomColors.Add('Color' + c + '=' + IntToHex(CustomColors[x,y], 8));
      end;
    end;
    ColorPicked := Dlg.Execute;
    if ColorPicked then
    begin
      FOtherColor := Dlg.Color;
      { get custom colors here }
      for z := 0 to 15 do
      begin
        p := Pos('=', Dlg.CustomColors[z]);
        AColor := StrToIntDef('$'+Copy(Dlg.CustomColors[z], p+1, 9), clWhite);
        p := Ord(Dlg.CustomColors[z][p-1]) - 64;
        x := (p-1) mod 8 + 1;
        y := (p-1) div 8 + 1;
        CustomColors[x,y] := AColor;
      end;
    end;
  finally
    FPreventClose := FALSE;
    Dlg.Free;
  end;

  if ColorPicked then
  begin
    if assigned(FSetParentColor) then
      FSetParentColor(Self, TRUE, FOtherColor);
    Close;
  end;
end;

procedure TDFSColorButtonPalette.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := not FPreventClose;
end;

function TDFSColorButtonPalette.ValidColorIndex(X, Y: integer): boolean;
begin
  Result := ((X > 0) and (X <= 4) and (Y > 0) and (Y <= 5)) or (Y = 0);
end;

procedure TDFSColorButtonPalette.FrameCurrentSquare(NewFrame: TPoint);

  function ComparePoints(const Pt1, Pt2: TPoint): boolean;
  begin
    Result := ((Pt1.X = Pt2.X) and (Pt1.Y =Pt2.Y));
  end;

var
  AColor: TColor;
begin
  if not ComparePoints(NewFrame, FLastFrame) and
     ValidColorIndex(NewFrame.X, NewFrame.Y) then
  begin
    { Unframe the last one }
    if ValidColorIndex(FLastFrame.X, FLastFrame.Y) then
    begin
      if FLastFrame.Y = 0 then
        AColor := FOtherColor
      else
        AColor := FPaletteColors[FLastFrame.X, FLastFrame.Y];
      with FLastFrame do
        DrawSquare(X, Y, AColor, FALSE);
    end;

		if NewFrame.Y = 0 then
      AColor := FOtherColor
    else
      AColor := FPaletteColors[NewFrame.X, NewFrame.Y];
    with NewFrame do
      DrawSquare(X, Y, AColor, TRUE);
    FLastFrame := NewFrame;
  end;
end;


procedure TDFSColorButtonPalette.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  FrameCurrentSquare(GetCurrentSquare);
end;

procedure TDFSColorButtonPalette.FormClick(Sender: TObject);
var
  SelectedColorSquare: TPoint;
  AColor: TColor;
begin
  if assigned(FSetParentColor) then
  begin
    SelectedColorSquare := GetCurrentSquare;
    if ValidColorIndex(SelectedColorSquare.X, SelectedColorSquare.Y) then
    begin
      if (SelectedColorSquare.Y = 0) then
        AColor := FOtherColor
      else
        AColor := FPaletteColors[SelectedColorSquare.x, SelectedColorSquare.Y];
      FSetParentColor(Self, (SelectedColorSquare.Y = 0), AColor);
    end;
  end;
  Close;
end;

function TDFSColorButtonPalette.GetCurrentSquare: TPoint;

  function IsOtherColorSquare(Pt: TPoint): boolean;
  begin
    Result := (Pt.X >= ClientWidth-19) and (Pt.X <= ClientWidth-1) and
       (Pt.Y >= 96) and (Pt.Y <= 113);
  end;

var
  CurPos: TPoint;
begin
  GetCursorPos(CurPos);
  CurPos := ScreenToClient(CurPos);
  Result := Point((CurPos.X div 18) + 1, (CurPos.Y div 18) + 1);
  if IsOtherColorSquare(CurPos) then
    Result := Point(0,0)
  else if not ValidColorIndex(Result.X, Result.Y) then
    Result := Point(-1,-1);
end;

procedure TDFSColorButtonPalette.FormKeyPress(Sender: TObject;
  var Key: Char);
var
  SelectedColorSquare: TPoint;
  AColor: TColor;
begin
  case Key of
    #27:
      begin
        FKeyboardClose := TRUE;
        Close;
      end;
    #13:
      begin
        if assigned(FSetParentColor) then
        begin
          SelectedColorSquare := FLastFrame;
          if ValidColorIndex(SelectedColorSquare.X, SelectedColorSquare.Y) then
          begin
            if (SelectedColorSquare.Y = 0) then
              AColor := FOtherColor
            else
              AColor := FPaletteColors[SelectedColorSquare.x,
                 SelectedColorSquare.Y];
            FSetParentColor(Self, (SelectedColorSquare.Y = 0), AColor);
          end;
        end;
        FKeyboardClose := TRUE;
        Close;
      end;
  end;
end;

procedure TDFSColorButtonPalette.FormDestroy(Sender: TObject);
begin
  Application.OnDeactivate := FOldAppDeactivate;
  Application.OnShowHint := FOldAppShowHint;
end;

procedure TDFSColorButtonPalette.SetPaletteColors(Value: TPaletteColors);
begin
  FPaletteColors.Assign(Value);
end;

procedure TDFSColorButtonPalette.SetCustomColors(Value: TCustomColors);
begin
  FCustomColors.Assign(Value);
end;


procedure TDFSColorButtonPalette.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  FrameIt: boolean;
  NewFrame: TPoint;
begin
  FrameIt := TRUE;
  NewFrame := FLastFrame;
  if ValidColorIndex(NewFrame.X, NewFrame.Y) then
  begin
    case Key of
      VK_LEFT:
        begin
          if NewFrame.Y = 0 then
            exit;
          dec(NewFrame.X);
          if NewFrame.X < 1 then
            NewFrame.X := 4
          else if NewFrame.X > 4 then
            NewFrame.X := 1;
        end;
      VK_UP:
        begin
          dec(NewFrame.Y);
          if NewFrame.Y < 0 then
            NewFrame.Y := 5
          else if NewFrame.Y > 5 then
            NewFrame.Y := 0;
        end;
      VK_RIGHT:
        begin
          if NewFrame.Y = 0 then
            exit;
          inc(NewFrame.X);
          if NewFrame.X < 1 then
            NewFrame.X := 4
          else if NewFrame.X > 4 then
            NewFrame.X := 1;
        end;
      VK_DOWN:
        begin
          inc(NewFrame.Y);
          if NewFrame.Y < 0 then
            NewFrame.Y := 5
          else if NewFrame.Y > 5 then
            NewFrame.Y := 0;
        end;
    else
      FrameIt := FALSE;
    end;
  end else
    NewFrame := Point(1, 1);

  if FrameIt then
    FrameCurrentSquare(NewFrame);
end;

end.
