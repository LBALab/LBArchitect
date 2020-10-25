unit About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Link, Buttons, Utils;

type
  TfmAbout = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lbHome: TLabel;
    lbVersion: TLabel;
    lbEmail: TLabel;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    Link1: TLink;
    Link2: TLink;
  end;

var
  fmAbout: TfmAbout;

implementation

{$R *.dfm}

uses Main;

procedure TfmAbout.BitBtn1Click(Sender: TObject);
begin
 Close();
end;

procedure TfmAbout.FormCreate(Sender: TObject);
var temp: Boolean;
begin
 Link1:= TLink.Create(Self);
 Link1.Parent:= Self;
 Link1.SetBounds(208, lbHome.Top, 102, 13);
 Link1.Cursor:= crHandPoint;
 Link1.Caption:= 'moonbase.kazekr.net';
 Link1.Font.Charset:= DEFAULT_CHARSET;
 Link1.Font.Color:= clBlue;
 Link1.Font.Height:= -11;
 Link1.Font.Name:= 'MS Sans Serif';
 Link1.Font.Style:= [];
 Link1.ParentFont:= False;
 Link1.LinkStyle.Normal.Color:= clBlue;
 Link1.LinkStyle.Normal.Style:= [];
 Link1.LinkStyle.Hover.Color:= clYellow;
 Link1.LinkStyle.Hover.Style:= [fsUnderline];
 Link1.LinkStyle.Pressed.Color:= clYellow;
 Link1.LinkStyle.Pressed.Style:= [fsUnderline];
 Link1.Address:= 'http://moonbase.kazekr.net';

 Link2:= TLink.Create(Self);
 Link2.Parent:= Self;
 Link2.SetBounds(208, lbEmail.Top, 97, 13);
 Link2.Cursor:= crHandPoint;
 Link2.Caption:= 'kazink@gmail.com';
 Link2.Font.Charset:= DEFAULT_CHARSET;
 Link2.Font.Color:= clBlue;
 Link2.Font.Height:= -11;
 Link2.Font.Name:= 'MS Sans Serif';
 Link2.Font.Style:= [];
 Link2.ParentFont:= False;
 Link2.LinkStyle.Normal.Color:= clBlue;
 Link2.LinkStyle.Normal.Style:= [];
 Link2.LinkStyle.Hover.Color:= clYellow;
 Link2.LinkStyle.Hover.Style:= [fsUnderline];
 Link2.LinkStyle.Pressed.Color:= clYellow;
 Link2.LinkStyle.Pressed.Style:= [fsUnderline];
 Link2.Address:= 'mailto:zink@poczta.onet.pl';

 lbVersion.Caption:= 'Version: ' + ReadProgramVersion(temp);
end;

end.
