//This unit makes some modifications to the SpinEdit standrd Delphi control.
//To make it working for a specified form, just add this unit to the "uses" list
// of the form *after* the original Spin unit. If it's before the Spin unit, it
// won't work.

//It introduces the following modifications:
// - If Max and Min of a SpinEdit are set to the same value, the SpinEdit will
//     accept only that value (unmodified SpinEdit accepts any value in such case)
// - Setting Min or Max will check if the value is within them, and adjust it if not.
// - Pressing PgUp and PgDown will change the value by 10*Increment
// - New property: ValueOK, which is true if the value is proper integer, and if
//     it is within boundaries.


unit SpinMod;

interface

uses Windows, Spin, SysUtils, Classes, Controls;

type
  TSpinEdit = class(Spin.TSpinEdit)
  private
    FMinValue: LongInt;
    FMaxValue: LongInt;
    FIncrement: LongInt;
    procedure SetMinValue(v: LongInt);
    procedure SetMaxValue(v: LongInt);
    function GetValue(): LongInt;
    procedure SetValue(v: LongInt);
    function GetValueOK(): Boolean;
    procedure CMExit(var Message: TCMExit);   message CM_EXIT;
  protected
    function CheckValue(NewValue: LongInt): LongInt;
    procedure UpClick (Sender: TObject); override;
    procedure DownClick (Sender: TObject); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    constructor Create(AOwner: TComponent); override;
    property ValueOK: Boolean read GetValueOK;
  published
    property MinValue read FMinValue write SetMinValue;
    property MaxValue read FMaxValue write SetMaxValue;
    property Value read GetValue write SetValue;
    property ReadOnly;
    property Increment read FIncrement write FIncrement default 1;
  end;

implementation

constructor TSpinEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIncrement:= 1;
end;

procedure TSpinEdit.SetMinValue(v: LongInt);
begin
  FMinValue:= v;
  SetValue(GetValue());
end;

procedure TSpinEdit.SetMaxValue(v: LongInt);
begin
  FMaxValue:= v;
  SetValue(GetValue());
end;

function TSpinEdit.CheckValue(NewValue: LongInt): LongInt;
begin
  Result:= NewValue;
  if NewValue < FMinValue then Result:= FMinValue
  else if NewValue > FMaxValue then  Result:= FMaxValue;
end;

function TSpinEdit.GetValue(): LongInt;
begin
  If TryStrToInt(Text, Result) then begin
    If Result > MaxValue then Result:= MaxValue
    else if Result < MinValue then Result:= MinValue;
  end
  else Result:= MinValue;
end;

procedure TSpinEdit.SetValue(v: LongInt);
begin
  Text:= IntToStr(CheckValue(v));
end;

function TSpinEdit.GetValueOK(): Boolean;
var temp: LongInt;
begin
  Result:= TryStrToInt(Text, temp) and (temp >= MinValue) and (temp <= MaxValue);
end;

procedure TSpinEdit.CMExit(var Message: TCMExit);
begin
  inherited;
  Value:= GetValue();
end;

procedure TSpinEdit.UpClick(Sender: TObject);
begin
  if ReadOnly then MessageBeep(0)
  else Value:= Value + FIncrement;
end;

procedure TSpinEdit.DownClick(Sender: TObject);
begin
  if ReadOnly then MessageBeep(0)
  else Value:= Value - FIncrement;
end;

procedure TSpinEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if not ReadOnly then begin
    if Key = VK_PRIOR then Value:= Value + FIncrement * 10 //Page Up
    else if Key = VK_NEXT then Value:= Value - FIncrement * 10; //Page Down
  end;
  inherited KeyDown(Key, Shift);
end;

end.
