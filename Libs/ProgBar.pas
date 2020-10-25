//******************************************************************************
// Little Big Architect - editing grid, brick and layout files containing
//                        rooms in Little Big Adventure 1 & 2
//
// ProgBar unit.
// Contains progress bar displaying routines.
//
// Copyright (C) Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit ProgBar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Math;

type
  TProgBarForm = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    Bevel2: TBevel;      
    Image1: TImage;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    MasterForm: TForm;
  public
    { Public declarations }
   procedure ShowSpecial(Caption: String; Form: TForm; CursorChange: Boolean;
     ScreenCenter: Boolean = False);
   procedure ShowSpecialBar(Caption: String; Form: TForm; CursorChange: Boolean;
    Min, Max: Integer);
   procedure UpdateBar(Val: Integer);
   procedure CloseSpecial();
  end;

var
  ProgBarForm: TProgBarForm;
  AMin: Integer = 0;
  AMax: Integer = 100;
  Pos: Integer = 0;
  PixPos: Integer = 0;
  Text: PChar;
  TextL: Integer;  // length of the text
  TextPL: Integer; // pixel length
  TextR: TRect;    // text rect


implementation

{$R *.dfm}

procedure TProgBarForm.ShowSpecial(Caption: String; Form: TForm; CursorChange: Boolean;
  ScreenCenter: Boolean = False);
begin
 If CursorChange then Screen.Cursor:= crHourGlass;
 MasterForm:= Form;
 Timer1.Enabled:= True;
 Bevel2.Visible:= False;
 Image1.Visible:= False;
 Pos:= 0;
 Label1.Visible:= True;
 Label1.Caption:= Caption;
 MasterForm.Enabled:= False;
 Show();
 if ScreenCenter then begin
   Left:= (Screen.Width - Width) div 2;
   Top:= (Screen.Height - Height) div 2;
 end
 else begin
   Left:= Form.Left + (Form.Width-Width) div 2;
   Top:= Form.Top + (Form.Height-Height) div 2;
 end;
 Application.ProcessMessages();
end;

procedure TProgBarForm.ShowSpecialBar(Caption: String; Form: TForm; CursorChange: Boolean;
 Min, Max: Integer);
begin
 If CursorChange then Screen.Cursor:= crHourGlass;
 MasterForm:= Form;
 Timer1.Enabled:= True;
 Bevel2.Visible:= True;
 Image1.Visible:= True;
 Image1.Canvas.Brush.Color:= Color;
 Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));
 Image1.Canvas.Brush.Style:= bsClear;
 Label1.Visible:= False;
 AMin:= Min;
 AMax:= Max;
 Pos:= 0;
 PixPos:= 0;
 Text:= PChar(Caption);
 TextPL:= ProgBarForm.Image1.Canvas.TextWidth(Caption);
 TextL:= Length(Caption);
 TextR:= Rect((Image1.Width-TextPL) div 2,1,TextPL,Image1.Canvas.TextHeight(Caption)+1);
 Image1.Canvas.Font.Color:= clBlack;
 Image1.Canvas.TextOut(TextR.Left,1,Caption);
 Image1.Canvas.Font.Color:= clWhite;
 Form.Enabled:= False;
 Left:= Form.Left+(Form.Width-Width) div 2;
 Top:= Form.Top+(Form.Height-Height) div 2;
 Show;
 Application.ProcessMessages;
end;

procedure TProgBarForm.UpdateBar(Val: Integer);
var NewPix, a: Integer;
begin
 If Pos=Val then Exit;
 NewPix:=IfThen(AMax-AMin>0,Round(((Val-AMin)*317)/(AMax-AMin)));
 If NewPix=PixPos then Exit;
 for a:=0 to 17 do begin
  Image1.Canvas.Pen.Color:=$ff9090-a*$070707;
  Image1.Canvas.MoveTo(PixPos,a);
  Image1.Canvas.LineTo(NewPix,a);
 end;
 If NewPix >= TextR.Left then begin
  If TextR.Right-TextR.Left<TextPL then TextR.Right:= NewPix;
  DrawText(Image1.Canvas.Handle,PChar(Text),TextL,TextR,DT_NOPREFIX);
 end;
 Pos:= Val;
 PixPos:= NewPix;
 Application.ProcessMessages;
end;

procedure TProgBarForm.CloseSpecial();
begin
 Screen.Cursor:= crDefault;
 if Assigned(MasterForm) then MasterForm.Enabled:= True;
 Close();
 //Timer1.Enabled:= False;
end;

procedure TProgBarForm.FormCreate(Sender: TObject);
begin
 DoubleBuffered:= True;  
end;

procedure TProgBarForm.Timer1Timer(Sender: TObject);
begin
 If Assigned(MasterForm) and MasterForm.Enabled and Visible then Close();
end;

end.
