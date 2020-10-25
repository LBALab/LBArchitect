//******************************************************************************
// Little Big Architect: Factory - editing brick and layout files from
//                                 Little Big Adventure 1 & 2
//
// OptPanel unit.
// Contains the small panel that slides out from left border of the editor
//  window.
//
// Copyright Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit OptPanel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, IniFiles, DFSClrBn, Math;

type
  TOptForm = class(TForm)
    paOpt: TPanel;
    pcOpts: TPageControl;
    optZoom: TTabSheet;
    optDisplay: TTabSheet;
    cbFrontF: TCheckBox;
    cbGrid: TCheckBox;
    cbBackF: TCheckBox;
    cbCoverBack: TCheckBox;
    lbZoom: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    cbAddF: TCheckBox;
    optOptions: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    optStructOpts: TTabSheet;
    cbShowImg: TCheckBox;
    cbIndexes: TCheckBox;
    cbShape: TCheckBox;
    Label7: TLabel;
    cbFrames: TCheckBox;
    procedure lbZoomClick(Sender: TObject);
    procedure cbGridClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbFrontCColorChange(Sender: TObject);
    procedure cbFramesClick(Sender: TObject);
  private
    { Private declarations }
  public
    cbFrontC: TdfsColorButton;
    cbBackC: TdfsColorButton;
    cbSelect: TdfsColorButton;
    procedure ShowPanel(x, y, Index: Integer);
    procedure HidePanel;
  end;

var
  OptForm: TOptForm;

  AppPath: String;
  LastBrkPath: String;
  LastLtPath: String;
  LastExportPath: String;
  LastHqrPath: String;
  LastScenPath: String;

  Settings: record
    StartWith1: Boolean;
    ImportAutoPal: Boolean;
  end;  

procedure ChangePalette(PLba1: Boolean; Repaint: Boolean = True);
procedure SaveSettings;
procedure LoadSettings;

implementation

uses Editor, Engine, Main, Bricks, Layouts, StructEd, Scenario;

{$R *.dfm}

procedure TOptForm.FormCreate(Sender: TObject);
const PaletteColours: array[0..4*5-1] of TColor =
  (16777215, 255, 65280, 16711680, 12572607, 0, 127, 32512, 8323072,
   15712159, 12566463, 65535, 16776960, 16711935, 7715583, 8355711,
   33023, 8355584, 8323199, 22446);
var a: Integer;
begin
 cbFrontC:= TdfsColorButton.Create(Self);
 cbFrontC.Parent:= optOptions;
 cbFrontC.SetBounds(26, 40, 45, 22);
 cbFrontC.ShowColorHints:= False;
 cbFrontC.OtherBtnCaption:= '&Other';
 cbFrontC.OtherColor:= clBtnFace;
 cbFrontC.CycleColors:= True;
 cbFrontC.PaletteColors.XSize:= 4;
 cbFrontC.PaletteColors.YSize:= 5;
 for a:= 1 to 4 * 5 do
   cbFrontC.PaletteColors.Colors[a]:= PaletteColours[a - 1];
 cbFrontC.CustomColors.XSize:= 8;
 cbFrontC.CustomColors.YSize:= 2;
 for a:= 1 to 8 * 2 do
   cbFrontC.CustomColors.Colors[a]:= clWhite;
 cbFrontC.OnColorChange:= cbFrontCColorChange;

 cbBackC:= TdfsColorButton.Create(Self);
 cbBackC.Parent:= optOptions;
 cbBackC.SetBounds(26, 80, 45, 22);
 cbBackC.ShowColorHints:= False;
 cbBackC.OtherBtnCaption:= '&Other';
 cbBackC.OtherColor:= clBtnFace;
 cbBackC.CycleColors:= True;
 cbBackC.PaletteColors.Assign(cbFrontC.PaletteColors);
 cbBackC.CustomColors.Assign(cbFrontC.CustomColors);
 cbBackC.OnColorChange:= cbFrontCColorChange;

 cbSelect:= TdfsColorButton.Create(Self);
 cbSelect.Parent:= optStructOpts;
 cbSelect.SetBounds(27, 88, 45, 22);
 cbSelect.ShowColorHints:= False;
 cbSelect.OtherBtnCaption:= '&Other';
 cbSelect.OtherColor:= clBtnFace;
 cbSelect.CycleColors:= True;
 cbSelect.PaletteColors.Assign(cbFrontC.PaletteColors);
 cbSelect.CustomColors.Assign(cbFrontC.CustomColors);
 cbSelect.OnColorChange:= cbFramesClick;

 lbZoom.ItemIndex:= 0;
end;

procedure TOptForm.ShowPanel(x, y, Index: Integer);
begin
 OptForm.Left:=x;
 OptForm.Top:=y;
 OptForm.pcOpts.ActivePageIndex:=Index;
 AnimateWindow(OptForm.Handle,50,aw_hor_positive+aw_slide);
 OptForm.Visible:=True;
end;

procedure TOptForm.HidePanel;
begin
 AnimateWindow(OptForm.Handle,50,aw_hor_negative+aw_hide+aw_slide);
 OptForm.Visible:=False;
end;

procedure TOptForm.lbZoomClick(Sender: TObject);
begin
 Zoom:=OptForm.lbZoom.ItemIndex+1;
 SetScrolls(True);
 RepaintImage;
end;

procedure TOptForm.cbGridClick(Sender: TObject);
begin
 RepaintImage;
end;

procedure ChangePalette(PLba1: Boolean; Repaint: Boolean = True);
begin
 Palette:= LoadPaletteFromResource(IfThen(PLba1,1,2));
 InvertPal:= InvertPalette(Palette);
 If PLba1 then fmMain.mLba1.Checked:= True else fmMain.mLba2.Checked:= True;
 If Repaint then begin
  PaintBricks();
  PaintLayouts();
 end;
end;

procedure SaveSettings();
var f: TIniFile;
begin
 f:=TIniFIle.Create(AppPath+'Factory.ini');
 f.WriteInteger('General', 'Palette',        IfThen(fmMain.mLba1.Checked,1,2));
 f.WriteString( 'General', 'lba_brk',        BrkPath);
 f.WriteString( 'General', 'bll_path',       LibPath);
 f.WriteInteger('General', 'bll_index',      LibIndex);
 f.WriteString( 'General', 'scen_path',      ScenarioPath);
 f.WriteInteger('General', 'Zoom',           OptForm.lbZoom.ItemIndex);
 f.WriteString( 'General', 'LastBrkPath',    LastBrkPath);
 f.WriteString( 'General', 'LastExportPath', LastExportPath);
 f.WriteString( 'General', 'LastHqrPath',    LastHqrPath);
 f.WriteString( 'General', 'LastScenPath',   LastScenPath);
 f.WriteBool(   'General', 'ViewFrames',     fmMain.mFrames.Checked);
 f.WriteBool(   'General', 'ViewIndexes',    fmMain.mIndexes.Checked);
 f.WriteBool(   'General', 'ViewShapes',     fmMain.mShapes.Checked);
 f.WriteBool(   'General', 'SortBySizes',    fmMain.btSortSize.Down);
 f.WriteBool(   'Editor',  'Grid',           OptForm.cbGrid.Checked);
 f.WriteBool(   'Editor',  'FrontFrame',     OptForm.cbFrontF.Checked);
 f.WriteBool(   'Editor',  'BackFrame',      OptForm.cbBackF.Checked);
 f.WriteBool(   'Editor',  'AddFrame',       OptForm.cbAddF.Checked);
 f.WriteBool(   'Editor',  'BrickCoversBF',  OptForm.cbCoverBack.Checked);
 f.WriteInteger('Editor',  'FrontColour',    OptForm.cbFrontC.Color);
 f.WriteInteger('Editor',  'BackColour',     OptForm.cbBackC.Color);
 f.WriteBool(   'StructEditor', 'ShowFrames',  OptForm.cbFrames.Checked);
 f.WriteBool(   'StructEditor', 'ShowImage',   OptForm.cbShowImg.Checked);
 f.WriteBool(   'StructEditor', 'ShowIndexes', OptForm.cbIndexes.Checked);
 f.WriteBool(   'StructEditor', 'ShowShape',   OptForm.cbShape.Checked);
 f.WriteInteger('StructEditor', 'SelColour',   OptForm.cbSelect.Color);

 f.WriteBool('General', 'HQRStartWith1', Settings.StartWith1);
 f.WriteBool('General', 'ImportAutoPal', Settings.ImportAutoPal);
 f.Free;
end;

procedure LoadSettings();
var f: TIniFile;
begin
 AppPath:= ExtractFilePath(Application.ExeName);
 f:= TIniFIle.Create(AppPath+'Factory.ini');
 ChangePalette(f.ReadInteger('General','Palette',1)=1);
 BrkPath:=                     f.ReadString('General','lba_brk','');
 LibPath:=                     f.ReadString('General','bll_path','');
 LibIndex:=                    f.ReadInteger('General','bll_index',1);
 ScenarioPath:=                f.ReadString('General','scen_path','');
 OptForm.lbZoom.ItemIndex:=    f.ReadInteger('General','Zoom',0);
 OptForm.lbZoomClick(EditForm);
 LastBrkPath:=                 f.ReadString('General','LastBrkPath',AppPath);
 LastExportPath:=              f.ReadString('General','LastExportPath',AppPath);
 LastHqrPath:=                 f.ReadString('General','LastHqrPath',AppPath);
 LastScenPath:=                f.ReadString('General','LastScenPath',AppPath);
 fmMain.mFrames.Checked:=      f.ReadBool('General', 'ViewFrames', False);
 fmMain.mIndexes.Checked:=     f.ReadBool('General', 'ViewIndexes', True);
 fmMain.mShapes.Checked:=      f.ReadBool('General', 'ViewShapes', False);
 If f.ReadBool('General','SortBySizes',True) then fmMain.btSortSize.Down:= True
 else fmMain.btSortIndex.Down:= True;
 OptForm.cbGrid.Checked:=      f.ReadBool('Editor','Grid',False);
 OptForm.cbFrontF.Checked:=    f.ReadBool('Editor','FrontFrame',True);
 OptForm.cbBackF.Checked:=     f.ReadBool('Editor','BackFrame',True);
 OptForm.cbAddF.Checked:=      f.ReadBool('Editor','AddFrame',True);
 OptForm.cbCoverBack.Checked:= f.ReadBool('Editor','BrickCoversBF',True);
 OptForm.cbFrontC.Color:=      f.ReadInteger('Editor','FrontColour',clRed);
 OptForm.cbBackC.Color:=       f.ReadInteger('Editor','BackColour',clBlue);
 OptForm.cbFrames.Checked:=    f.ReadBool('StructEditor','ShowFrames',True);
 OptForm.cbShowImg.Checked:=   f.ReadBool('StructEditor','ShowImage',True);
 OptForm.cbIndexes.Checked:=   f.ReadBool('StructEditor','ShowIndexes',True);
 OptForm.cbShape.Checked:=     f.ReadBool('StructEditor','ShowShape',False);
 OptForm.cbSelect.Color:=      f.ReadInteger('StructEditor','SelColour',$000080FF);

 Settings.StartWith1:= f.ReadBool('General', 'HQRStartWith1', True);
 fmMain.mStartWith1.Checked:= Settings.StartWith1;
 Settings.ImportAutoPal:= f.ReadBool('General', 'ImportAutoPal', True);
 f.Free;
end;

procedure TOptForm.cbFrontCColorChange(Sender: TObject);
begin
 RepaintImage();
end;

procedure TOptForm.cbFramesClick(Sender: TObject);
begin
 fmStruct.DrawStruct();
end;

end.
