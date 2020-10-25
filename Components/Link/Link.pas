unit Link;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Graphics, ShellApi, Windows, Messages;

type
  TFontStyle = class(TPersistent)
  private
   FColor: TColor;
   FStyle: TFontStyles;
  public
   procedure Assign(Source: TPersistent); override;
  published
   property Color: TColor read FColor write FColor;
   property Style: TFontStyles read FStyle write FStyle;
  end;

  TLinkStyle = class(TPersistent)
  private
   FNormal: TFontStyle;
   FHover: TFontStyle;
   FPressed: TFontStyle;
   procedure SetNormal(AValue: TFontStyle);
   procedure SetHover(AValue: TFontStyle);
   procedure SetPressed(AValue: TFontStyle);
  public
   constructor Create;
   destructor Destroy; override;
   procedure Assign(Source: TPersistent); override;
  published
   property Normal: TFontStyle read FNormal write SetNormal;
   property Hover: TFontStyle read FHover write SetHover;
   property Pressed: TFontStyle read FPressed write SetPressed;
  end;

type
  TLink = class(TLabel)
  private
   FLinkStyle: TLinkStyle;
   FAddress: TCaption;
   Procedure SetLinkStyle(AValue: TLinkStyle);
   Procedure SetAddress(AValue: TCaption);
  protected
   procedure MouseEnter(var Msg: TMessage); message cm_mouseEnter;
   procedure MouseLeave(var Msg: TMessage); message cm_mouseLeave;
  public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;

   procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
     X, Y: Integer); override;
   procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
     X, Y: Integer); override;
   procedure Click; override;
  published
   property LinkStyle: TLinkStyle read FLinkStyle write SetLinkStyle stored True;
   property Address: TCaption read FAddress write SetAddress;
  end;

procedure Register;

implementation

{$R Link.res}

procedure TFontStyle.Assign(Source : TPersistent);
begin
 if Source is TFontStyle then
  with TFontStyle(Source) do begin
   Self.Color := Color;
   Self.Style := Style;
  end
 else inherited; //raises an exception
end;

procedure TLinkStyle.SetNormal(AValue: TFontStyle);
begin
 FNormal.Assign(AValue);
end;

procedure TLinkStyle.SetHover(AValue: TFontStyle);
begin
 FHover.Assign(AValue);
end;

procedure TLinkStyle.SetPressed(AValue: TFontStyle);
begin
 FPressed.Assign(AValue);
end;

constructor TLinkStyle.Create;
begin
 inherited Create;
 FNormal:=TFontStyle.Create;
 FHover:=TFontStyle.Create;
 FPressed:=TFontStyle.Create;
end;

destructor TLinkStyle.Destroy;
begin
 FNormal.Destroy;
 FHover.Destroy;
 FPressed.Destroy;
 inherited Destroy;
end;

procedure TLinkStyle.Assign(Source: TPersistent);
begin
 if Source is TLinkStyle then
  with TLinkStyle(Source) do begin
   Self.Normal := Normal;
   Self.Hover := Hover;
   Self.Pressed := Pressed;
  end
 else inherited; //raises an exception
end;

Procedure TLink.SetLinkStyle(AValue: TLinkStyle);
begin
 FLinkStyle.Assign(AValue);
 Invalidate;
end;

Procedure TLink.SetAddress(AValue: TCaption);
begin
 FAddress:=AValue;
end;

constructor TLink.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 FLinkStyle:=TLinkStyle.Create;
 FLinkStyle.Normal.Color:=clBlue;
 FLinkStyle.Normal.Style:=[];
 FLinkStyle.Hover.Color:=clYellow;
 FLinkStyle.Hover.Style:=[fsUnderline];
 FLinkStyle.Pressed.Color:=clYellow;
 FLinkStyle.Pressed.Style:=[fsUnderline];
 Font.Color:=FLinkStyle.Normal.Color;
 Font.Style:=FLinkStyle.Normal.Style;
 Cursor:=crHandPoint;
end;

destructor TLink.Destroy;
begin
 FLinkStyle.Destroy;
 inherited Destroy;
end;

procedure TLink.MouseEnter(var Msg: TMessage);
begin
 If not (csDesigning in ComponentState) then begin
  Font.Color:=FLinkStyle.Hover.Color;
  Font.Style:=FLinkStyle.Hover.Style;
  Invalidate;
 end;
end;

procedure TLink.MouseLeave(var Msg: TMessage);
begin
 If not (csDesigning in ComponentState) then begin
  Font.Color:=FLinkStyle.Normal.Color;
  Font.Style:=FLinkStyle.Normal.Style;
  Invalidate;
 end;
end;

procedure TLink.MouseDown(Button: TMouseButton; Shift: TShiftState;
 X, Y: Integer);
begin
 Font.Color:=FLinkStyle.Pressed.Color;
 Font.Style:=FLinkStyle.Pressed.Style;
 Invalidate;
 inherited MouseDown(Button, Shift, X, Y);
end;

procedure TLink.MouseUp(Button: TMouseButton; Shift: TShiftState;
 X, Y: Integer);
begin
 If (X>=0) and (X<=Width) and (Y>=0) and (Y<=Height) then begin
  Font.Color:=FLinkStyle.Hover.Color;
  Font.Style:=FLinkStyle.Hover.Style;
 end
 else begin
  Font.Color:=FLinkStyle.Normal.Color;
  Font.Style:=FLinkStyle.Normal.Style;
 end;
 Invalidate;
 inherited MouseUp(Button, Shift, X, Y);
end;

procedure TLink.Click;
begin
 ShellExecute(Parent.Handle,'open',PChar(FAddress),nil,nil,SW_SHOWNORMAL);
 inherited Click;
end;

procedure Register;
begin
  RegisterComponents('Samples', [TLink]);
end;

end.
