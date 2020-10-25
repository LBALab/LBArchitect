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
{ TColorArrayEditor                                                           }
{-----------------------------------------------------------------------------}
{ Description:                                                                }
{   This is a support unit for the TDFSColorButton component (DFSClrBn.PAS).  }
{-----------------------------------------------------------------------------}
unit ColorAEd;

interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, CBtnForm, DesignIntf, StdCtrls, DesignEditors;

type
  TColorArrayEditor = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    ColorDlg: TColorDialog;
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FColors: TColorArrayClass;
    FLastFrame: TPoint;
    procedure SetColors(Val: TColorArrayClass);
    procedure DrawSquare(X, Y: integer; AColor: TColor; IsFocused: boolean);
    procedure FrameCurrentSquare;
    function ValidColorIndex(X, Y: integer): boolean;
    function GetCurrentSquare: TPoint;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Colors: TColorArrayClass
       read FColors
       write SetColors;
  end;

  TColorArrayProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function AllEqual: boolean; override;
  end;

implementation

{$R *.DFM}

uses
  ExtCtrls;
  

constructor TColorArrayEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColors := NIL;
end;

destructor TColorArrayEditor.Destroy;
begin
  FColors.Free;
  inherited Destroy;
end;

procedure TColorArrayEditor.SetColors(Val: TColorArrayClass);
begin
  if FColors = NIL then
    FColors := TColorArrayClass.Create(Val.XSize, Val.YSize);
  FColors.Assign(Val);
end;



procedure TColorArrayProperty.Edit;
var
  Dlg: TColorArrayEditor;
begin
  Application.CreateForm(TColorArrayEditor, Dlg);
  try
    Dlg.Caption := Self.GetName;
    Dlg.Colors := TColorArrayClass(GetOrdValue);
    if Dlg.ShowModal = mrOk then
    begin
      { SetOrdValue will operate on all selected propertiy values }
      SetOrdValue(Longint(Dlg.Colors));
      Modified;
    end;
  finally
    Dlg.Free;
  end;
end;

function TColorArrayProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly, paMultiSelect];
end;

function TColorArrayProperty.AllEqual: boolean;
var
  SourceColors: TColorArrayClass;
  x: integer;
begin
  Result := FALSE;
  if PropCount > 1 then
  begin
    { Get first selected color set }
    SourceColors := TColorArrayClass(GetOrdValue);
    for x := 1 to PropCount-1 do
    begin
      { Compare first selected to all other selected color sets }
      if not SourceColors.IsEqualTo(TColorArrayClass(GetOrdValueAt(x))) then
        exit;
    end;
  end;
  Result := TRUE;
end;


procedure TColorArrayEditor.FormPaint(Sender: TObject);
var
  X, Y: integer;
begin
  for x := 1 to Colors.XSize do
  begin
    for y := 1 to Colors.YSize do
    begin
      { Draw color square }
      DrawSquare(X, Y, FColors[x,y], FALSE);
    end;
  end;

  { Draw the current selection }
  FrameCurrentSquare;

  { Draw seperator line }
  y := Colors.YSize * 18 + 10;
  with Canvas do
  begin
    Pen.Color := clBtnShadow;
    MoveTo(5, y);
    LineTo(ClientWidth - 5, y);
    Pen.Color := clBtnHighlight;
    inc(y);
    MoveTo(5, y);
    LineTo(ClientWidth - 5, y);
  end;

end;

procedure TColorArrayEditor.DrawSquare(X, Y: integer; AColor: TColor; IsFocused: boolean);
var
  R: TRect;
begin
  if ValidColorIndex(X, Y) then
  begin
    X := (X-1) * 18 + ((ClientWidth - (Colors.XSize * 18)) div 2);
    Y := (Y-1) * 18 + 6;
  end else
    exit;

  with Canvas do
  begin
    R := Rect(X-1, Y-1, X+17, Y+17);
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


procedure TColorArrayEditor.FrameCurrentSquare;

  function ComparePoints(const Pt1, Pt2: TPoint): boolean;
  begin
    Result := ((Pt1.X = Pt2.X) and (Pt1.Y =Pt2.Y));
  end;

var
  NewFrame: TPoint;
begin
  NewFrame := GetCurrentSquare;
  if not ComparePoints(NewFrame, FLastFrame) and
     ValidColorIndex(NewFrame.X, NewFrame.Y) then
  begin
    { Unframe the last one }
    if ValidColorIndex(FLastFrame.X, FLastFrame.Y) then
      with FLastFrame do
        DrawSquare(X, Y, FColors[X, Y], FALSE);
    with NewFrame do
      DrawSquare(X, Y, FColors[X, Y], TRUE);
    FLastFrame := NewFrame;
  end;
end;

function TColorArrayEditor.ValidColorIndex(X, Y: integer): boolean;
begin
  Result := ((X > 0) and (X <= Colors.XSize) and
     (Y > 0) and (Y <= Colors.YSize));
end;

function TColorArrayEditor.GetCurrentSquare: TPoint;
var
  CurPos: TPoint;
  CenteringOffset: integer;
  x: integer;
begin
  CenteringOffset := ((ClientWidth - (Colors.XSize * 18)) div 2);
  GetCursorPos(CurPos);
  CurPos := ScreenToClient(CurPos);
  x := CurPos.X - CenteringOffset;
  if x >= 0 then
    x := (x div 18) + 1;
  Result := Point(x, ((CurPos.Y - 5) div 18) + 1);
  if not ValidColorIndex(Result.X, Result.Y) then
    Result := Point(-1,-1);
end;

procedure TColorArrayEditor.FormCreate(Sender: TObject);
begin
  FLastFrame := Point(-1,-1);
end;

procedure TColorArrayEditor.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  FrameCurrentSquare;
end;

procedure TColorArrayEditor.FormClick(Sender: TObject);
var
  SelectedColorSquare: TPoint;
begin
  SelectedColorSquare := GetCurrentSquare;
  if ValidColorIndex(SelectedColorSquare.X, SelectedColorSquare.Y) then
  begin
    ColorDlg.Color := FColors[SelectedColorSquare.X, SelectedColorSquare.Y];
    if ColorDlg.Execute then
    begin
      with SelectedColorSquare do
      begin
        FColors[X, Y] := ColorDlg.Color;
        DrawSquare(X, Y, ColorDlg.Color, FALSE);
      end;
      FrameCurrentSquare;
    end;
  end;
end;

procedure TColorArrayEditor.FormShow(Sender: TObject);
  function MaxInt(I1, I2: integer): integer;
  begin
    if I1 > I2 then
      Result := I1
    else
      Result := I2;
  end;
begin
  { Oh, how I do hate large fonts. }
{  ClientWidth := Colors.XSize * 18 + 18;
  ClientHeight := Colors.YSize * 18 + 42;}
  btnOK.Top := Colors.YSize * 18 + 14;
  btnCancel.Top := btnOK.Top;
  ClientWidth := MaxInt((btnOk.Width + btnCancel.Width + 12),
     (Colors.XSize * 18 + 8));
  ClientHeight := btnOk.Top + btnOk.Height + 2;
  btnOK.Left := (ClientWidth - (btnOK.Width * 2) - 4) div 2; 
  btnCancel.Left := btnOK.Left + btnOK.Width + 4;
end;

end.

