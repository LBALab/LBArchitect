unit DebugLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons;

type
  TfmDebugLog = class(TForm)
    reText: TRichEdit;
    btClose: TBitBtn;
    btClear: TBitBtn;
    procedure btCloseClick(Sender: TObject);
    procedure btClearClick(Sender: TObject);
  private
  
  protected  
    procedure CreateParams(var Params: TCreateParams); override;
  public

  end;

var
  fmDebugLog: TfmDebugLog;

procedure DebugLogShowDialog();
procedure DbgLog(msg: String);

implementation

{$R *.dfm}

procedure DebugLogShowDialog();
begin
  {$ifdef DEBUG_LOG}
    Show();
  {$endif}
end;

procedure DbgLog(msg: String);
begin
  {$ifdef DEBUG_LOG}
    reText.Lines.Add(msg);
    reText.SetFocus();
    reText.SelStart:= reText.GetTextLen();
    reText.Perform(EM_SCROLLCARET, 0, 0);
    Application.ProcessMessages();
  {$endif}
end;

procedure TfmDebugLog.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle:= Params.ExStyle or WS_EX_APPWINDOW;
end;

procedure TfmDebugLog.btClearClick(Sender: TObject);
begin
  reText.Lines.Clear();
end;

procedure TfmDebugLog.btCloseClick(Sender: TObject);
begin
  Close();
end;

end.
