unit BetterSpin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, Themes, Math, ExtCtrls;

type
  TOnValueChangeEvent = procedure(Sender: TObject; Value: Integer; ValueOK: Boolean) of object;

  TfrBetterSpin = class(TFrame)
    paFrame: TPanel;
    edValue: TEdit;
    btLUp: TBitBtn;
    btLDown: TBitBtn;
    btSUp: TBitBtn;
    btSDown: TBitBtn;
    tmRepeat: TTimer;
    procedure FrameResize(Sender: TObject);
    procedure edValueChange(Sender: TObject);
    procedure tmRepeatTimer(Sender: TObject);
    procedure btSUpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btSUpMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btSUpMouseLeave(Sender: TObject);
    procedure edValueKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FMinValue: Integer;
    FMaxValue: Integer;
    FLargeChange: Integer;
    FOnValueChange: TOnValueChangeEvent;
    FOnChange: TNotifyEvent;
    FNormalColour, FErrorColour: TColor;
    FColourChng: Boolean;
    procedure SetupButtons();
    procedure UpdateColour();
    procedure SetErrorColour(AValue: TColor);
    procedure SetColourChng(AValue: Boolean);
    procedure ChangeValue(By: Integer);
    procedure DoChange();
  protected
    procedure SetMinValue(AValue: Integer);
    procedure SetMaxValue(AValue: Integer);
    function GetValue(): Integer;
    procedure SetValue(AValue: Integer);
    procedure SetLargeChange(AValue: Integer);
    function GetValueOK(): Boolean;
    function GetColor(): TColor;
    procedure SetColor(AValue: TColor);
    procedure SetEnabled(AValue: Boolean); override;
    procedure SetHint(AValue: TCaption);
  public
    constructor Create(AOwner: TComponent); override;

    function TryReadValue(out Val: Integer): Boolean;
    function ReadValueDef(Default: Integer): Integer; overload;
    function ReadValueDef(): Integer; overload;
    procedure Setup(Min, Max, Val: Integer; Large: Integer = 0;
      ColourChng: Boolean = True);

    property MinValue: Integer read FMinValue write SetMinValue;
    property MaxValue: Integer read FMaxValue write SetMaxValue;
    property Value: Integer read GetValue write SetValue;
    property LargeChange: Integer read FLargeChange write SetLargeChange;
    property ValueOK: Boolean read GetValueOK;
    property Color: TColor read GetColor write SetColor;
    property ColourChng: Boolean read FColourChng write SetColourChng;
    property ErrorColour: TColor read FErrorColour write SetErrorColour;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnValueChange: TOnValueChangeEvent read FOnValueChange write FOnValueChange;
  end;

implementation

{$R *.dfm}

constructor TfrBetterSpin.Create(AOwner: TComponent);
begin
 inherited;
 if ThemeServices.ThemesEnabled then begin
   btLUp.ControlStyle:= ControlStyle - [csFramed];
   btLDown.ControlStyle:= ControlStyle - [csFramed];
   btSUp.ControlStyle:= ControlStyle - [csFramed];
   btSDown.ControlStyle:= ControlStyle - [csFramed];
 end;
 FMinValue:= 0;
 FMaxValue:= 0;
 FLargeChange:= 1; //to force the change
 SetLargeChange(0);
 edValue.Text:= IntToStr(0);
 SetColor(clWindow);
 FColourChng:= True;
 FErrorColour:= $3C3CFF;
 FNormalColour:= edValue.Color;
 SetupButtons();
end;

{procedure TfrBetterSpin.SetEditRect();
//var Loc: TRect;
begin
 SendMessage(edValue.Handle, EM_GETRECT, 0, LongInt(@Loc));
 Loc.Bottom:= edValue.ClientHeight + 1;  //+1 is workaround for windows paint bug
 Loc.Right:= 10;//edValue.ClientWidth - btSUp.Width - 2;
 //if btLUp.Visible then Loc.Right:= Loc.Right - btLUp.Width;
 Loc.Top:= 0;
 Loc.Left:= 0;
 SendMessage(edValue.Handle, EM_SETRECTNP, 0, LongInt(@Loc));
 SendMessage(edValue.Handle, EM_GETRECT, 0, LongInt(@Loc));  //debug
end; }

procedure TfrBetterSpin.Setup(Min, Max, Val: Integer; Large: Integer = 0;
  ColourChng: Boolean = True);
begin
 FMinValue:= Min;
 FMaxValue:= Max;
 SetLargeChange(Large);
 edValue.Text:= IntToStr(Val);
 FColourChng:= ColourChng;
 SetupButtons();
 UpdateColour();
end;

procedure TfrBetterSpin.SetupButtons();
var temp: Integer;
    ok: Boolean;
begin
 ok:= Enabled and TryStrToInt(edValue.Text, temp);
 btSUp.Enabled:= ok and (temp < FMaxValue);
 btLUp.Enabled:= btSUp.Enabled;
 btSDown.Enabled:= ok and (temp > FMinValue);
 btLDown.Enabled:= btSDown.Enabled;
end;

procedure TfrBetterSpin.UpdateColour();
begin
 if ValueOK then
   edValue.Color:= FNormalColour
 else if FColourChng then
   edValue.Color:= FErrorColour;
 paFrame.Color:= edValue.Color;
end;

procedure TfrBetterSpin.FrameResize(Sender: TObject);
begin
 btLUp.Left:= paFrame.Width - btLUp.Width - 4;
 btLDown.Left:= btLUp.Left;
 if btLUp.Visible then
   btSUp.Left:= btLUp.Left - btSUp.Width
 else
   btSUp.Left:= btLUp.Left;
 btSDown.Left:= btSUp.Left;
 edValue.Margins.Right:= paFrame.ClientWidth - btSUp.Left + 1;
end;                     

procedure TfrBetterSpin.SetMinValue(AValue: Integer);
var temp: Integer;
begin
 FMinValue:= AValue;
 if TryStrToInt(edValue.Text, temp) then
   if temp < FMinValue then SetValue(FMinValue);
end;

procedure TfrBetterSpin.SetMaxValue(AValue: Integer);
var temp: Integer;
begin
 FMaxValue:= AValue;
 if TryStrToInt(edValue.Text, temp) then
   if temp > FMaxValue then SetValue(FMaxValue);
end;

function TfrBetterSpin.GetValue(): Integer;
begin
 Result:= StrToIntDef(edValue.Text, FMinValue);
end;

procedure TfrBetterSpin.SetValue(AValue: Integer);
var prev: Integer;
    prevok: Boolean;
begin
 prevok:= TryStrToInt(edValue.Text, prev);
 edValue.Text:= IntToStr(AValue);
 if not prevok or (AValue <> prev) then DoChange();
 SetupButtons();
 UpdateColour();
end;

procedure TfrBetterSpin.tmRepeatTimer(Sender: TObject);
begin
 tmRepeat.Enabled:= False;
 case tmRepeat.Tag of
   1: ChangeValue(1);
   2: ChangeValue(-1);
   3: ChangeValue(FLargeChange);
   4: ChangeValue(-FLargeChange);
   else Exit;
 end;
 tmRepeat.Interval:= 100;
 tmRepeat.Enabled:= True;
end;

procedure TfrBetterSpin.SetLargeChange(AValue: Integer);
begin
 if AValue <> FLargeChange then begin
   btLUp.Visible:= AValue > 0;
   btLDown.Visible:= AValue > 0;
   if btLUp.Visible then begin
     btSUp.Left:= edValue.ClientRect.Right - btSUp.Width - btLUp.Width;
     btSDown.Left:= edValue.ClientRect.Right - btSDown.Width - btLDown.Width;
   end else begin
     btSUp.Left:= edValue.ClientRect.Right - btSUp.Width;
     btSDown.Left:= edValue.ClientRect.Right - btSDown.Width;
   end;  
 end;
 FLargeChange:= AValue;
 btLUp.Hint:= 'Large change (by ' + IntToStr(AValue) + ')';
 btLDown.Hint:= btLUp.Hint;
end;

function TfrBetterSpin.GetValueOK(): Boolean;
var temp: Integer;
begin
 Result:= TryStrToInt(edValue.Text, temp) and (temp >= FMinValue)
            and (temp <= FMaxValue);
end;

function TfrBetterSpin.GetColor(): TColor;
begin
 Result:= edValue.Color;
end;

procedure TfrBetterSpin.SetColor(AValue: TColor);
begin
 edValue.Color:= AValue;
 paFrame.Color:= AValue;
 FNormalColour:= AValue;
end;

procedure TfrBetterSpin.SetErrorColour(AValue: TColor);
begin
 FErrorColour:= AValue;
 SetupButtons();
end;

procedure TfrBetterSpin.SetColourChng(AValue: Boolean);
begin
 FColourChng:= AValue;
 SetupButtons();
end;

procedure TfrBetterSpin.SetEnabled(AValue: Boolean);
begin
 inherited;
 edValue.Enabled:= AValue;
 SetupButtons();
end;

procedure TfrBetterSpin.SetHint(AValue: TCaption);
begin
 inherited;
 edValue.Hint:= AValue;
end;

function TfrBetterSpin.TryReadValue(out Val: Integer): Boolean;
begin
 Result:= TryStrToInt(edValue.Text, Val) and (Val >= FMinValue)
            and (Val <= FMaxValue);
end;

function TfrBetterSpin.ReadValueDef(Default: Integer): Integer;
begin
 Result:= Min(Max(StrToIntDef(edValue.Text, Default), FMinValue), FMaxValue);
end;

function TfrBetterSpin.ReadValueDef(): Integer;
begin
 Result:= Min(Max(StrToIntDef(edValue.Text, FMinValue), FMinValue), FMaxValue);
end;

procedure TfrBetterSpin.btSUpMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if Button = mbLeft then begin
   if Sender = btSUp then begin
     ChangeValue(1);
     tmRepeat.Tag:= 1;
   end else if Sender = btSDown then begin
     ChangeValue(-1);
     tmRepeat.Tag:= 2;
   end else if Sender = btLUp then begin
     ChangeValue(FLargeChange);
     tmRepeat.Tag:= 3;
   end else if Sender = btLDown then begin
     ChangeValue(-FLargeChange);
     tmRepeat.Tag:= 4;
   end else
     Exit;
   tmRepeat.Interval:= 500;
   tmRepeat.Enabled:= True;
 end;    
end;

procedure TfrBetterSpin.btSUpMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 btSUpMouseLeave(Sender);
end;

procedure TfrBetterSpin.btSUpMouseLeave(Sender: TObject);
begin
 if tmRepeat.Enabled then begin
   tmRepeat.Tag:= 0;
   tmRepeat.Enabled:= False;
   GetParentForm(Self).ActiveControl:= edValue;
   edValue.SelLength:= 0;
 end;  
end;

procedure TfrBetterSpin.ChangeValue(By: Integer);
var temp: Integer;
begin
 if TryStrToInt(edValue.Text, temp) then begin
   Inc(temp, By);
   if FMaxValue >= FMinValue then
     temp:= Max(Min(temp, FMaxValue), FMinValue);
   SetValue(temp);
 end;
end;

procedure TfrBetterSpin.DoChange();
var temp: Integer;
    ok: Boolean;
begin
 if Assigned(FOnChange) then
   FOnChange(Self);
 if Assigned(FOnValueChange) then begin
   ok:= TryStrToInt(edValue.Text, temp);
   FOnValueChange(Self, temp, ok);
 end;
end;

procedure TfrBetterSpin.edValueChange(Sender: TObject);
begin
 DoChange();
 SetupButtons();
 UpdateColour();
end;

procedure TfrBetterSpin.edValueKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if ssCtrl in Shift then begin
   if Key = VK_UP then begin
     ChangeValue(FLargeChange);
     tmRepeat.Tag:= 3;
   end else if Key = VK_DOWN then begin
     ChangeValue(-FLargeChange);
     tmRepeat.Tag:= 4;
   end else
     Exit;
 end else begin
   if Key = VK_UP then begin
     ChangeValue(1);
     tmRepeat.Tag:= 1;
   end else if Key = VK_DOWN then begin
     ChangeValue(-1);
     tmRepeat.Tag:= 2;
   end else
     Exit;
 end;
 Key:= 0;
end;

end.
