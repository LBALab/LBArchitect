unit brace;

interface

uses Controls, Graphics, Classes, SysUtils;

type
  TBraceOrientation = (boLeft, boRight, boUp, boDown);

  TBrace = class(TGraphicControl)
  private
    FOrientation: TBraceOrientation;
    FPenWidth: Integer;
    FPenColour: TColor;
    FBackColour: TColor;
    FImgList: TImageList;      
    procedure SetOrientation(AOrientation: TBraceOrientation);
    procedure SetPenWidth(AWidth: Integer);
    procedure SetPenColour(AColour: TColor);
    procedure SetBackColour(AColour: TColor);
  protected
    procedure Paint(); override;
    procedure Resize(); override;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; ALeft, ATop, AWidth, AHeight: Integer;
      AOrient: TBraceOrientation; ATag: Integer = 0); reintroduce; overload; 
    destructor Destroy(); override;
    procedure PaintTo(Canvas: TCanvas; X, Y: Integer);
  published
    property Orientation: TBraceOrientation read FOrientation
                                           write SetOrientation;
    property PenWidth: Integer read FPenWidth write SetPenWidth;
    property PenColour: TColor read FPenColour write SetPenColour;
    property BackColour: TColor read FBackColour write SetBackColour;
  end;

//Rysuje klamerkê bez tworzenia obiektu
procedure PaintBrace(Canvas: TCanvas; X, Y, Width, Height: Integer;
  Orientation: TBraceOrientation);

implementation

const ArcSize = 8;
      ArcBtmToLeft = 0;
      ArcBtmToRight = 1;
      ArcLeftToBtm = 2;
      ArcLeftToTop = 3;
      ArcRightToBtm = 4;
      ArcRightToTop = 5;
      ArcTopToLeft = 6;
      ArcTopToRight = 7;

var ImgList: TImageList;

{$R brace.res}

{ TBrace }

constructor TBrace.Create(AOwner: TComponent);
begin
  Create(AOwner, 10, 10, 100, 12, boDown, 0);
end;

constructor TBrace.Create(AOwner: TComponent; ALeft, ATop, AWidth,
  AHeight: Integer; AOrient: TBraceOrientation; ATag: Integer = 0);
var a: Integer;
    temp: TBitmap;
begin
  inherited Create(AOwner);
  Left:= ALeft;
  Top:= ATop;
  Width:= AWidth;
  Height:= AHeight;
  FOrientation:= AOrient;
  Tag:= ATag;
  //FPenWidth:= 1;
  //FPenColour:= clBlack;
  FBackColour:= clNone;

  FImgList:= TImageList.CreateSize(8, 8);
  temp:= TBitmap.Create();
  temp.PixelFormat:= pf4bit;
  temp.Transparent:= False;
  for a:= 0 to 7 do begin
    temp.LoadFromResourceName(HInstance, 'BRACE_' + IntToStr(a));
    FImgList.AddMasked(temp, clFuchsia); //ResourceLoad konwertuje do 16 kolorów (dlaczego?)
  end;
  temp.Free();

  Resize();
end;

destructor TBrace.Destroy();
begin
  FImgList.Free();
  inherited;
end;

procedure TBrace.Paint();
begin
  inherited;
  PaintTo(Canvas, 0, 0);
end;

procedure TBrace.PaintTo(Canvas: TCanvas; X, Y: Integer);
var Center: Integer;
begin
  //Canvas.Pen.Color:= FPenColour;
  //Canvas.Pen.Width:= FPenWidth;
  If FBackColour <> clNone then begin
    Canvas.Brush.Color:= FBackColour;
    Canvas.Brush.Style:= bsSolid;
    Canvas.FillRect(Canvas.ClipRect);
  end;
  {ArcsW:= Width div 10;
  Center:= Width div 2;
  Canvas.Arc(0, -ArcsW, ArcsW * 2 + 1, ArcsW + 1, 0, 0, ArcsW+1, ArcsW);
  Canvas.MoveTo(ArcsW, ArcsW);
  Canvas.LineTo(Center - ArcsW, ArcsW);
  Canvas.Arc(Center - ArcsW * 2, ArcsW, Center, ArcsW * 3,
             Center, ); }
  Canvas.Pen.Color:= clBlack;
  Canvas.Pen.Width:= 2;
  If (FOrientation = boUp) or (FOrientation = boDown) then Center:= Width div 2
                                                      else Center:= Height div 2;
  case FOrientation of
    boLeft: begin
      FImgList.Draw(Canvas, X, Y, ArcBtmToLeft);
      Canvas.MoveTo(X + ArcSize - 2, Y + ArcSize - 1);
      Canvas.LineTo(X + ArcSize - 2, Y + Center - ArcSize - 1);
      FImgList.Draw(Canvas, X + ArcSize - 4, Y + Center - ArcSize, ArcTopToRight);
      FImgList.Draw(Canvas, X + ArcSize - 4, Y + Center, ArcBtmToRight);
      Canvas.MoveTo(X + ArcSize - 2, Y + Center + ArcSize - 1);
      Canvas.LineTo(X + ArcSize - 2, Y + Height - ArcSize - 1);
      FImgList.Draw(Canvas, X, Y + Height - ArcSize, ArcTopToLeft);
    end;
    boRight: begin
      FImgList.Draw(Canvas, X + ArcSize - 4, Y, ArcBtmToRight);
      Canvas.MoveTo(X + ArcSize - 2, Y + ArcSize - 1);
      Canvas.LineTo(X + ArcSize - 2, Y + Center - ArcSize - 1);
      FImgList.Draw(Canvas, X, Y + Center - ArcSize, ArcTopToLeft);
      FImgList.Draw(Canvas, X, Y + Center, ArcBtmToLeft);
      Canvas.MoveTo(X + ArcSize - 2, Y + Center + ArcSize - 1);
      Canvas.LineTo(X + ArcSize - 2, Y + Height - ArcSize - 1);
      FImgList.Draw(Canvas, X + ArcSize - 4, Y + Height - ArcSize, ArcTopToRight);
    end;
    boUp: begin
      FImgList.Draw(Canvas, X, Y, ArcRightToTop);
      Canvas.MoveTo(X + ArcSize - 1, Y + ArcSize - 2);
      Canvas.LineTo(X + Center - ArcSize - 1, Y + ArcSize - 2);
      FImgList.Draw(Canvas, X + Center - ArcSize, Y + ArcSize - 4, ArcLeftToBtm);
      FImgList.Draw(Canvas, X + Center, Y + ArcSize - 4, ArcRightToBtm);
      Canvas.MoveTo(X + Center + ArcSize - 1, Y + ArcSize - 2);
      Canvas.LineTo(X + Width - ArcSize - 1, Y + ArcSize - 2);
      FImgList.Draw(Canvas, X + Width - ArcSize, Y, ArcLeftToTop);
    end;
    boDown: begin
      FImgList.Draw(Canvas, X, Y + ArcSize - 4, ArcRightToBtm);
      Canvas.MoveTo(X + ArcSize - 1, Y + ArcSize - 2);
      Canvas.LineTo(X + Center - ArcSize - 1, Y + ArcSize - 2);
      FImgList.Draw(Canvas, X + Center - ArcSize, Y, ArcLeftToTop);
      FImgList.Draw(Canvas, X + Center, Y, ArcRightToTop);
      Canvas.MoveTo(X + Center + ArcSize - 1, Y + ArcSize - 2);
      Canvas.LineTo(X + Width - ArcSize - 1, Y + ArcSize - 2);
      FImgList.Draw(Canvas, X + Width - ArcSize, Y + ArcSize - 4, ArcLeftToBtm);
    end;
  end;
end;

procedure TBrace.Resize();
begin
  inherited;
  //If Assigned(Parent) then Paint();
end;

procedure TBrace.SetBackColour(AColour: TColor);
begin
  FBackColour:= AColour;
  Repaint();
end;

procedure TBrace.SetOrientation(AOrientation: TBraceOrientation);
begin
  FOrientation:= AOrientation;
  Repaint();
end;

procedure TBrace.SetPenColour(AColour: TColor);
begin
  FPenColour:= AColour;
  Repaint();
end;

procedure TBrace.SetPenWidth(AWidth: Integer);
begin
  FPenWidth:= AWidth;
  Repaint();
end;

procedure InitImgList();
var a: Integer;
    temp: TBitmap;
begin
  If not Assigned(ImgList) then begin
    ImgList:= TImageList.CreateSize(8, 8);
    temp:= TBitmap.Create();
    temp.PixelFormat:= pf4bit;
    temp.Transparent:= False;
    for a:= 0 to 7 do begin
      temp.LoadFromResourceName(HInstance, 'BRACE_' + IntToStr(a));
      ImgList.AddMasked(temp, clFuchsia); //ResourceLoad konwertuje do 16 kolorów (dlaczego?)
    end;
    temp.Free();
  end;
end;

procedure PaintBrace(Canvas: TCanvas; X, Y, Width, Height: Integer;
  Orientation: TBraceOrientation);
var Center: Integer;
begin
 InitImgList();

  {If FBackColour <> clNone then begin
    Canvas.Brush.Color:= FBackColour;
    Canvas.Brush.Style:= bsSolid;
    Canvas.FillRect(Canvas.ClipRect);
  end;}

  Canvas.Pen.Color:= clBlack;
  Canvas.Pen.Width:= 2;
  If (Orientation = boUp) or (Orientation = boDown) then Center:= Width div 2
                                                    else Center:= Height div 2;
  case Orientation of
    boLeft: begin
      ImgList.Draw(Canvas, X, Y, ArcBtmToLeft);
      Canvas.MoveTo(X + ArcSize - 2, Y + ArcSize - 1);
      Canvas.LineTo(X + ArcSize - 2, Y + Center - ArcSize - 1);
      ImgList.Draw(Canvas, X + ArcSize - 4, Y + Center - ArcSize, ArcTopToRight);
      ImgList.Draw(Canvas, X + ArcSize - 4, Y + Center, ArcBtmToRight);
      Canvas.MoveTo(X + ArcSize - 2, Y + Center + ArcSize - 1);
      Canvas.LineTo(X + ArcSize - 2, Y + Height - ArcSize - 1);
      ImgList.Draw(Canvas, X, Y + Height - ArcSize, ArcTopToLeft);
    end;
    boRight: begin
      ImgList.Draw(Canvas, X + ArcSize - 4, Y, ArcBtmToRight);
      Canvas.MoveTo(X + ArcSize - 2, Y + ArcSize - 1);
      Canvas.LineTo(X + ArcSize - 2, Y + Center - ArcSize - 1);
      ImgList.Draw(Canvas, X, Y + Center - ArcSize, ArcTopToLeft);
      ImgList.Draw(Canvas, X, Y + Center, ArcBtmToLeft);
      Canvas.MoveTo(X + ArcSize - 2, Y + Center + ArcSize - 1);
      Canvas.LineTo(X + ArcSize - 2, Y + Height - ArcSize - 1);
      ImgList.Draw(Canvas, X + ArcSize - 4, Y + Height - ArcSize, ArcTopToRight);
    end;
    boUp: begin
      ImgList.Draw(Canvas, X, Y, ArcRightToTop);
      Canvas.MoveTo(X + ArcSize - 1, Y + ArcSize - 2);
      Canvas.LineTo(X + Center - ArcSize - 1, Y + ArcSize - 2);
      ImgList.Draw(Canvas, X + Center - ArcSize, Y + ArcSize - 4, ArcLeftToBtm);
      ImgList.Draw(Canvas, X + Center, Y + ArcSize - 4, ArcRightToBtm);
      Canvas.MoveTo(X + Center + ArcSize - 1, Y + ArcSize - 2);
      Canvas.LineTo(X + Width - ArcSize - 1, Y + ArcSize - 2);
      ImgList.Draw(Canvas, X + Width - ArcSize, Y, ArcLeftToTop);
    end;
    boDown: begin
      ImgList.Draw(Canvas, X, Y + ArcSize - 4, ArcRightToBtm);
      Canvas.MoveTo(X + ArcSize - 1, Y + ArcSize - 2);
      Canvas.LineTo(X + Center - ArcSize - 1, Y + ArcSize - 2);
      ImgList.Draw(Canvas, X + Center - ArcSize, Y, ArcLeftToTop);
      ImgList.Draw(Canvas, X + Center, Y, ArcRightToTop);
      Canvas.MoveTo(X + Center + ArcSize - 1, Y + ArcSize - 2);
      Canvas.LineTo(X + Width - ArcSize - 1, Y + ArcSize - 2);
      ImgList.Draw(Canvas, X + Width - ArcSize, Y + ArcSize - 4, ArcLeftToBtm);
    end;
  end;
end;

end.
