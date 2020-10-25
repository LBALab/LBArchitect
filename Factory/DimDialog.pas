unit DimDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, BetterSpin, ExtCtrls;

type
  TfmDimensions = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    btOK: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    Image1: TImage;
    lbPixel: TLabel;
    lbBricks: TLabel;
    lbTooManyBrk: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure seXChange(Sender: TObject);
  private
    { Private declarations }
  public
    seX: TfrBetterSpin;
    seY: TfrBetterSpin;
    seZ: TfrBetterSpin;
    class function ShowDialog(var X, Y, Z: Integer): Boolean;
  end;

implementation

uses Libraries;

{$R *.dfm}

class function TfmDimensions.ShowDialog(var X, Y, Z: Integer): Boolean;
var Form: TfmDimensions;
begin
 Application.CreateForm(Self, Form);

 Form.seX.Value:= X;
 Form.seY.Value:= Y;
 Form.seZ.Value:= Z;

 Form.seXChange(nil);

 Result:= Form.ShowModal = mrOK;

 if Result then begin
   X:= Form.seX.Value;
   Y:= Form.seY.Value;
   Z:= Form.seZ.Value;
 end;

 FreeAndNil(Form);
end;

procedure TfmDimensions.FormCreate(Sender: TObject);
begin
 seX:= TfrBetterSpin.Create(Self);
 seX.Name:= 'seX';  seX.Parent:= Self;  seX.TabOrder:= 0;
 seX.SetBounds(64, 56, 49, 22);
 seX.Color:= $FFBE00;
 seX.Setup(1, 64, 1);
 seX.OnChange:= seXChange;

 seY:= TfrBetterSpin.Create(Self);
 seY.Name:= 'seY';  seY.Parent:= Self;  seY.TabOrder:= 1;
 seY.SetBounds(64, 80, 49, 22);
 seY.Color:= clYellow;
 seY.Setup(1, 24, 1);
 seY.OnChange:= seXChange;

 seZ:= TfrBetterSpin.Create(Self);
 seZ.Name:= 'seZ';  seZ.Parent:= Self;  seZ.TabOrder:= 2;
 seZ.SetBounds(64, 104, 49, 22);
 seZ.Color:= clLime;
 seZ.Setup(1, 64, 1);
 seZ.OnChange:= seXChange;
end;

procedure TfmDimensions.seXChange(Sender: TObject);
var Brk: Integer;
begin
 btOK.Enabled:= seX.ValueOK and seY.ValueOK and seZ.ValueOK;
 if btOK.Enabled then begin
   lbPixel.Caption:= Format('Pixel dimensions: %d x %d',
     [GetLtWidth(seX.Value, seY.Value, seZ.Value),
      GetLtHeight(seX.Value, seY.Value, seZ.Value)]);
   Brk:= seX.Value * seY.Value * seZ.Value;
   lbBricks.Caption:= 'Number of Bricks: ' + IntToStr(Brk);
   lbTooManyBrk.Visible:= Brk > 255;
 end else begin
   lbPixel.Caption:= 'Pixel dimensions: -';
   lbBricks.Caption:= 'Number of Bricks: -';
   lbTooManyBrk.Visible:= False;
 end;

end;

end.
