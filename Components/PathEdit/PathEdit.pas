unit PathEdit;

{version 1.0a
  - resolved problem with file dialog sometimes not showing up in BDS2006}

interface

uses
  Windows, SysUtils, Classes, Controls, StdCtrls, Buttons, Dialogs, OpenDirectory,
  Forms, Graphics, StrUtils;

type
  TEditStyle = (esEditOnly, esButtonOnly, esBoth);
  TPathKind = (pkFile, pkDirectory);
  TPathChangeEvent = procedure(Sender: TObject; var Path: TFileName) of object;
  TButtonKind = (bkText, bkBitmap, bkCustomBitmap);

type
  TPathEdit = class(TCustomControl)
  private
    FEdit: TEdit;
    FButton: TBitBtn;
    FDialogDir: TOpenDirectory;
    FDialogFile: TOpenDialog;
    FPathKind: TPathKind;
    FEditStyle: TEditStyle;
    FFont: TFont;
    FButtonKind: TButtonKind;
    FButtonText: TCaption;
    FButtonGlyph: TBitmap;
    FColor: TColor;
    FOnButtonClick: TNotifyEvent;
    FOnPathChange: TPathChangeEvent;
    FIncPathDelimiter: Boolean;
    procedure SetEditStyle(AValue: TEditStyle);
    procedure UpdatePathDelimiter;
    procedure ButtonClick(Sender: TObject);
    procedure EditTextChange(Sender: TObject);
    procedure EditExit(Sender: TObject);
    procedure SetPath(AValue: TFileName);
    function GetPath: TFileName;
    procedure SetPathKind(AValue: TPathKind);
    procedure SetFont(AValue: TFont);
    procedure SetButtonKind(AValue: TButtonKind);
    procedure SetButtonText(AValue: TCaption);
    procedure SetButtonGlyph(AValue: TBitmap);
    procedure SetColor(AValue: TColor);
    procedure SetIncPathDelimiter(AValue: Boolean);
    function GetFileFilter: String;
    procedure SetFileFilter(AValue: String);
    function GetFileFilterIndex: Integer;
    procedure SetFileFilterIndex(AValue: Integer);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint(); override;
    procedure Resize(); override;
    procedure Loaded(); override;
    procedure SetEnabled(AValue: Boolean); override;
    //Removes all path delimiters from the string end. Necessary for the file dialog,
    //  otherwise the dialog doesn't show up (in BDS2006).
    function RemovePathDelimiters(src: String): String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Edit: TEdit read FEdit;
    property Button: TBitBtn read FButton;
    property DialogDir: TOpenDirectory read FDialogDir;
    property DialogFile: TOpenDialog read FDialogFile;
  published
    property EditStyle: TEditStyle read FEditStyle write SetEditStyle default esBoth;
    property PathKind: TPathKind read FPathKind write SetPathKind default pkDirectory;
    property Path: TFileName read GetPath write SetPath;
    property Font: TFont read FFont write SetFont stored False;
    property ParentFont;
    property ButtonKind: TButtonKind read FButtonKind write SetButtonKind default bkBitmap;
    property ButtonText: TCaption read FButtonText write SetButtonText;
    property ButtonGlyph: TBitmap read FButtonGlyph write SetButtonGlyph stored False;
    property Color: TColor read FColor write SetColor default clWindow;
    property OnButtonClick: TNotifyEvent read FOnButtonClick write FOnButtonClick;
    property OnPathChange: TPathChangeEvent read FOnPathChange write FOnPathChange;
    property IncPathDelimiter: Boolean read FIncPathDelimiter
     write SetIncPathDelimiter default True;
    property Width default 121;
    property Height default 24;
    property FileFilter: String read GetFileFilter write SetFileFilter;
    property FileFilterIndex: Integer read GetFileFilterIndex write SetFileFilterIndex;
  end;

procedure Register;   

implementation

{$R PathEdit.res}

procedure Register;
begin
  RegisterComponents('Samples', [TPathEdit]);
end;

constructor TPathEdit.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);

 FEdit:= TEdit.Create(Self);
 FEdit.Parent:= Self;
 FEdit.BorderStyle:= bsNone;
 FEdit.AutoSize:= False;
 FEdit.OnChange:= EditTextChange;
 FEdit.OnExit:= EditExit;

 FButton:= TBitBtn.Create(Self);
 FButton.Parent:= Self;
 FButton.Caption:= '...';
 FButton.OnClick:= ButtonClick;

 FDialogDir:= TOpenDirectory.Create(Self);
 FDialogDir.Options:= [odNoBelowDomain, odOnlyFIleSystem, odNewStyleDialog];
 FDialogFile:= TOpenDialog.Create(Self);

 PathKind:= pkDirectory;
 EditStyle:= esBoth;
 ButtonKind:= bkBitmap;
 ButtonText:= '...';
 FButtonGlyph:= FButton.Glyph;
 Color:= clWindow;
 IncPathDelimiter:= True;
 FFont:= FEdit.Font;
 Width:= 121;
 Height:= 24;
end;

destructor TPathEdit.Destroy();
begin
 FEdit.Destroy;
 FButton.Destroy;
 FDialogDir.Destroy;
 FDialogFile.Destroy;

 inherited Destroy;
end;

procedure TPathEdit.SetEditStyle(AValue: TEditStyle);
begin
 FEditStyle:= AValue;
 FEdit.Enabled:= FEditStyle <> esButtonOnly;
 FButton.Enabled:= FEditStyle <> esEditOnly;
end;

procedure TPathEdit.UpdatePathDelimiter();
begin
 If FPathKind = pkDirectory then begin
  If FIncPathDelimiter then
   FEdit.Text:= IncludeTrailingPathDelimiter(FEdit.Text)
  else
   FEdit.Text:= RemovePathDelimiters(FEdit.Text);
 end;
end;

procedure TPathEdit.ButtonClick(Sender: TObject);
begin
 If Assigned(FOnButtonClick) then FOnButtonClick(Self);
 if FEdit.Enabled then FEdit.SetFocus();
 If FPathKind = pkFile then begin
  FDialogFile.FileName:= RemovePathDelimiters(FEdit.Text); //Otherwise the dialog won't show up in BDS2006
  If FDialogFile.Execute() then
   FEdit.Text:= FDialogFile.FileName;
 end
 else begin
  FDialogDir.DirName:= FEdit.Text;
  If FDialogDir.Execute then begin
   FEdit.Text:= FDialogDir.DirName;
   UpdatePathDelimiter;
  end;
 end;
end;

procedure TPathEdit.EditTextChange(Sender: TObject);
var Text: TFileName;
begin
 Text:= FEdit.Text;
 If Assigned(FOnPathChange) then FOnPathChange(Self,Text);
 FEdit.Text:= Text;
end;

procedure TPathEdit.EditExit(Sender: TObject);
begin
 UpdatePathDelimiter;
end;

procedure TPathEdit.SetPath(AValue: TFileName);
begin
 If Assigned(FOnPathChange) then FOnPathChange(Self, AValue);
 FEdit.Text:= AValue;
 UpdatePathDelimiter();
end;

function TPathEdit.GetPath: TFileName;
begin
 UpdatePathDelimiter();
 Result:= FEdit.Text;
end;

procedure TPathEdit.SetPathKind(AValue: TPathKind);
begin
 FPathKind:= AValue;
 UpdatePathDelimiter();
end;

procedure TPathEdit.SetFont(AValue: TFont);
begin
 FFont:= AValue;
 Canvas.Font.Assign(FFont);
 FEdit.Font.Assign(FFont);
end;

procedure TPathEdit.SetButtonKind(AValue: TButtonKind);
begin
 FButtonKind:= AValue;
 case FButtonKind of
  bkText: begin
   FButton.Caption:= FButtonText;
   FButton.Glyph.Assign(nil);
  end;
  bkBitmap: begin
   FButton.Caption:='';
   FButton.Glyph.LoadFromResourceName(hInstance, 'BITMAP1');
  end;
  bkCustomBitmap:
   Fbutton.Caption:='';
 end;
end;


procedure TPathEdit.SetButtonText(AValue: TCaption);
begin
 FButtonText:= AValue;
 If FButtonKind = bkText then
  FButton.Caption:= FButtonText;
end;

procedure TPathEdit.SetButtonGlyph(AValue: TBitmap);
begin
 FButton.Glyph.Assign(AValue);
 If AValue = nil then
  FButton.Caption:= FButtonText
 else
  FButton.Caption:= '';
end;

procedure TPathEdit.SetColor(AValue: TColor);
begin
 FColor:= AValue;
 FEdit.Color:= FColor;
end;

procedure TPathEdit.SetIncPathDelimiter(AValue: Boolean);
begin
 FIncPathDelimiter:= AValue;
 If FPathKind = pkDirectory then begin
  If FIncPathDelimiter then
   Path:= IncludeTrailingPathDelimiter(Path)
  else
   Path:= ExcludeTrailingPathDelimiter(Path);
 end;
end;

procedure TPathEdit.SetEnabled(AValue: Boolean);
begin
 FEdit.Enabled:= AValue and (FEditStyle <> esButtonOnly);
 FButton.Enabled:= AValue and (FEditStyle <> esEditOnly);
 inherited SetEnabled(AValue);
end;

function TPathEdit.GetFileFilter: String;
begin
 Result:= FDialogFile.Filter;
end;

procedure TPathEdit.SetFileFilter(AValue: String);
begin
 FDialogFile.Filter:= AValue;
end;

function TPathEdit.GetFileFilterIndex: Integer;
begin
 Result:= FDialogFile.FilterIndex;
end;

procedure TPathEdit.SetFileFilterIndex(AValue: Integer);
begin
 FDialogFile.FilterIndex:= AValue;
end;

procedure TPathEdit.CreateParams(var Params: TCreateParams);
begin
 inherited CreateParams(Params);
 Params.ExStyle:= Params.ExStyle or WS_EX_CLIENTEDGE;
end;

procedure TPathEdit.Paint;
begin
 inherited Paint;
 Canvas.Brush.Color:= FColor;
 Canvas.FillRect(Rect(0,0,Width - Height, Height - 4));
end;

function TPathEdit.RemovePathDelimiters(src: String): String;
var a: Integer;
begin
 Result:= '';
 for a:= Length(src) downto 1 do
   if src[a] <> PathDelim then begin
     Result:= LeftStr(src, a);
     Exit;
   end;
end;

procedure TPathEdit.Resize;
begin
 If Width>Height then begin
  FEdit.Height:= Canvas.TextHeight('Ag') + 1;
  FEdit.Left:= 1;
  FEdit.Top:= (Height - 4 - FEdit.Height) div 2;
  FEdit.Width:= Width - Height - 2;
  FButton.Left:= Width - Height;
  FButton.Top:= 0;
  FButton.Width:= Height - 4;
  FButton.Height:= Height - 4;
 end;
end;

procedure TPathEdit.Loaded;
begin
 Resize;
end;

end.
