unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Oblicz: TButton;
    Edit1: TEdit;
    ASCII: TLabel;
    lbSuma: TLabel;
    procedure ObliczClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function SimpleSum(data: String): Byte;
var a: Integer;
begin
 Result:= 0;
 for a:= 1 to Length(data) do
  Result:= Result + Byte(data[a]);
end;

function CRC8(data: String): Byte;
var ShiftReg, fb, a, b: Byte;
begin
 ShiftReg:= 0;
 for a:= 1 to Length(data) do
  for b:= 0 to 7 do begin
   fb:= (ShiftReg and $01) xor ((Byte(data[a]) and ($01 shl b)) shr b);
   ShiftReg:= ShiftReg shr 1;
   If (fb = 1) then
    ShiftReg:= ShiftReg xor $8C;
  end;

 Result:= ShiftReg;
end;

function XOR8(data: String): Byte;
var a: Integer;
begin
 Result:= 0;
 for a:= 1 to Length(data) do
  Result:= Result xor Byte(data[a]);
end;

function Hash(data: String): Integer;
var a: Integer;
begin
 Result := 0;
 data:= UpperCase(data);
 for a:= 1 to Length(data) do begin
  If data[a] in ['_', '0'..'9', 'a'..'z', 'A'..'Z'] then
   Inc(Result, Integer(data[a]) - 64)
  //else
  // Break;
 end;
end;

procedure TForm1.ObliczClick(Sender: TObject);
begin
 lbSuma.Caption:= 'Suma: ' + IntToStr(Hash(Edit1.Text)); //IntToHex(XOR8(Edit1.Text),2);
end;

end.
