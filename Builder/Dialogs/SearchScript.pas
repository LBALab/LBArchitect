unit SearchScript;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Utils, ScriptEd, SynEditSearch, SynEditTypes,
  Scene;

type
  TfmSearchScript = class(TForm)
    edText: TEdit;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    cbTrack: TCheckBox;
    cbLife: TCheckBox;
    rbCurrent: TRadioButton;
    rbAll: TRadioButton;
    btFind: TBitBtn;
    btClose: TBitBtn;
    procedure btFindClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure edTextChange(Sender: TObject);
  private
    Found: Boolean;
    Life: Boolean;
    Actor: Integer;
    Options: TSynSearchOptions;
    EdForm: TfmScriptEd;
    Reset: Boolean;
    SynSearch: TSynEditSearch;
    LastActor: Integer;
  public
    procedure OpenSearchDialog(Form: TfmScriptEd);
  end;

var
  fmSearchScript: TfmSearchScript;

implementation

{$R *.dfm}

procedure TfmSearchScript.FormCreate(Sender: TObject);
begin
  SynSearch:= TSynEditSearch.Create(Self);
  SynSearch.Sensitive:= False;
  SynSearch.Whole:= False;
end;

procedure TfmSearchScript.OpenSearchDialog(Form: TfmScriptEd);
begin
  EdForm:= Form;
  Reset:= True;
  EdForm.seLifeScript.SearchEngine:= SynSearch;
  EdForm.seTrackScript.SearchEngine:= SynSearch;
  Show;
end;

procedure TfmSearchScript.btCloseClick(Sender: TObject);
begin
  Close();
end;

procedure TfmSearchScript.btFindClick(Sender: TObject);
var Text: String;
    StepFound: Boolean;
begin
  LastActor:= EdForm.LastActor;
  Text:= Trim(edText.Text);
  if Text <> '' then begin
    if Reset then begin
      Options:= [ssoEntireScope];
      Found:= False;
      Life:= cbLife.Checked; //if not checked then cbTrack must be checked
      if rbCurrent.Checked then
        Actor:= LastActor
      else begin
        Actor:= 0;
        EdForm.OpenScripts(Actor, True);
      end;
      Reset:= False;
    end;

    while Actor <= High(VScene.Actors) do begin
      StepFound:= (    Life and (EdForm.seLifeScript.SearchReplace(Text, '', Options) <> 0))
               or (not Life and (EdForm.seTrackScript.SearchReplace(Text, '', Options) <> 0));
      Options:= []; //next search from cursor
      if StepFound then begin
        Found:= True;
        LastActor:= Actor;
        btFind.Caption:= 'Find next';
        break;
      end
      else begin //Not found, next script
        if Life then EdForm.seLifeScript.SelLength:= 0
                else EdForm.seTrackScript.SelLength:= 0; //otherwise selection persists
        if Life and cbTrack.Checked then
          Life:= False //TrackScript
        else begin
          if cbLife.Checked then
            Life:= True;
          Inc(Actor);
          if rbCurrent.Checked or (Actor > High(VScene.Actors)) then begin //after last actor's script
            EdForm.OpenScripts(LastActor); //return to the last Actor (or last result)
            if Found then
              InfoMsg('No more occurences found.')
            else
              WarningMsg('Search text not found.');
            edTextChange(nil); //Reset
            break;
          end else
            EdForm.OpenScripts(Actor, True);
        end;
        Options:= [ssoEntireScope]; //each new script search from beginning
      end;
    end;
  end else
    InfoMsg('Please enter some text to search for!');
end;

procedure TfmSearchScript.edTextChange(Sender: TObject);
begin
  btFind.Caption:= 'Find';
  Reset:= True;
  btFind.Enabled:= cbTrack.Checked or cbLife.Checked;
end;

end.
