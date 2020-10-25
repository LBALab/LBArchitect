unit BatchAnalyse;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, Math, Utils, DePack, Settings,
  SceneLib, SceneLibConst, SceneLib1Tab, SceneLib2Tab, SceneLibDecomp,
  HQDesc, ListForm;

type
  TfmBatchAnalyse = class(TForm)
    rgGroups: TRadioGroup;
    cbMacro: TComboBox;
    reText: TRichEdit;
    btClose: TBitBtn;
    btExport: TBitBtn;
    btStart: TBitBtn;
    cbAllErrors: TCheckBox;
    cbOnlyErrors: TCheckBox;
    dlgSaveTxt: TSaveDialog;
    procedure btCloseClick(Sender: TObject);
    procedure rgGroupsClick(Sender: TObject);
    procedure btStartClick(Sender: TObject);
    procedure cbMacroChange(Sender: TObject);
    procedure btExportClick(Sender: TObject);
  private
    AllIndex: Integer;
    function LogField(Text: String; Size: Integer; Left: Boolean): String;
    procedure ScrollLog();
  protected  
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure ShowDialog();
  end;

var
  fmBatchAnalyse: TfmBatchAnalyse;

implementation

{$R *.dfm}

type
  TGroup = (grpLba1Life      = 0,
            grpLba1Track     = 1,
            grpLba1Variable  = 2,
            grpLba1Behaviour = 3,
            grpLba1DirMode   = 4,
            grpLba1Operator  = 5,
            grpLba2Life      = 6,
            grpLba2Track     = 7,
            grpLba2Variable  = 8,
            grpLba2Behaviour = 9,
            grpLba2DirMode   = 10,
            grpLba2Operator  = 11 );

  TSearchPattern = record
    Types: set of TCommandType;
    Code: Byte;
    CheckParam: Integer;
    ParamVal: Integer;
    ParamNext: Boolean;
  end;
            

procedure TfmBatchAnalyse.btCloseClick(Sender: TObject);
begin
  Close();
end;

procedure TfmBatchAnalyse.ShowDialog();
begin
  Show();
end;

procedure TfmBatchAnalyse.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle:= Params.ExStyle or WS_EX_APPWINDOW;
end;

function TfmBatchAnalyse.LogField(Text: String; Size: Integer; Left: Boolean): String;
begin
  if not Left then
    Result:= StringOfChar(' ', Size - Length(Text))
  else
    Result:= '';
  Result:= Result + Text;
  if Left then
    Result:= Result + StringOfChar(' ', Size - Length(Text));
end;

procedure TfmBatchAnalyse.btExportClick(Sender: TObject);
begin
  dlgSaveTxt.InitialDir:= Sett.General.LastExpDir;
  if dlgSaveTxt.Execute then begin
    Sett.General.LastExpDir:= ExtractFilePath(dlgSaveTxt.FileName);
    reText.Lines.SaveToFile(dlgSaveTxt.FileName);
  end;
end;

procedure TfmBatchAnalyse.btStartClick(Sender: TObject);
var SceneHead, ActorHead, FoundHere: Boolean;
    ScenesPack: TPackEntries;
    Scenes: array of TScene;
    a, b, c, d: Integer;
    Lba, FirstScene, FieldSize: Integer;
    line: String;
    SceneNames: TStrArray;
    SceneIndexList: TIndexList;
    Strings: TStrDynAr;
    Macro1: TSearchPattern;
    Macro2: TSearchPattern;
    UseMacro2: Boolean;
    Errors: Integer;
    Group: TGroup;
    Flags: TDecTxtFlags;

    OccurencesTab: array of Integer;
    ErrorsTab: array of Integer;
begin
  if (rgGroups.ItemIndex < 0) or (cbMacro.ItemIndex < 0) then begin
    WarningMsg('Please make a selection first!');
    Exit;
  end;

  Group:= TGroup(rgGroups.ItemIndex);

  reText.Clear();

  Lba:= IfThen(Group <= grpLba1Operator, 1, 2);
  FirstScene:= IfThen(Lba = 1, 0, 1);
  if CheckFile(Lba_SCENE, Lba) then begin
    if OpenPack(GetFilePath(Lba_SCENE, Lba), ScenesPack) then begin
      Screen.Cursor:= crHourglass;
      Application.ProcessMessages();
      line:= IntToStr(Length(ScenesPack) - FirstScene);
      reText.Lines.Text:= 'Loading Scenes... 0 / ' + line;
      UnpackAll(ScenesPack);
      SetLength(Scenes, Length(ScenesPack) - FirstScene);
      for a:= 0 to High(Scenes) do begin
        Scenes[a]:= LoadSceneFromString(ScenesPack[FirstScene+a].Data, Lba, False); //Keep all transitional tables
        reText.Lines.Text:= 'Loading Scenes... ' + IntToStr(a+1) + ' / ' + line;
        Application.ProcessMessages();
      end;
    end else begin
      ErrorMsg('Could not open Scene file!');
      Exit;
    end;
  end else begin
    ErrorMsg('Scene check failed!');
    Exit;
  end;

  SceneNames:= MakeDescriptionList(GetFilePath(Lba_SCENE, Lba), etScenes,
                 Lba = 1, False, False, SceneIndexList);

  reText.Clear();

  reText.Lines.Add('== LBA SCENE ANALYSIS ==');
  reText.Lines.Add('');
  line:= LogField('Group:', 10, True) + LogField(rgGroups.Items[rgGroups.ItemIndex], 40, True);
  reText.Lines.Add(line);
  line:= LogField('Macro:', 10, True) + LogField(cbMacro.Items[cbMacro.ItemIndex], 40, True);
  reText.Lines.Add(line);
  Application.ProcessMessages();

  UseMacro2:= False;
  Flags:= [];
  FieldSize:= 8;
  case Group of
    grpLba1Life, grpLba2Life: begin
      Macro1.Types:= [ctCommand, ctIf];
      Macro1.Code:= cbMacro.ItemIndex;
      Macro1.CheckParam:= -1;
      FieldSize:= 8;
    end;
    grpLba1Track, grpLba2Track: begin
      Macro1.Types:= [ctCommand];
      Macro1.Code:= cbMacro.ItemIndex;
      Macro1.CheckParam:= -1;
      FieldSize:= 6;
    end;
    grpLba1Variable, grpLba2Variable: begin
      Macro1.Types:= [ctVariable, ctSwVar];
      Macro1.Code:= cbMacro.ItemIndex;
      if ((Lba = 1) and (Macro1.Code = lv1BEHAVIOUR)
      or  (Lba = 2) and (Macro1.Code = lv2BEHAVIOUR)) then
        Flags:= [dtCmpBehav];
      Macro1.CheckParam:= -1;
      FieldSize:= 6;
    end;
    grpLba1Behaviour, grpLba2Behaviour: begin
      Macro1.Types:= [ctCommand];
      if Lba = 1 then Macro1.Code:= lm1SET_BEHAVIOUR
                 else Macro1.Code:= lm2SET_BEHAVIOUR;
      Macro1.CheckParam:= 0;
      Macro1.ParamVal:= cbMacro.ItemIndex;
      Macro1.ParamNext:= False;
      Macro2.Types:= [ctVariable, ctSwVar];
      if Lba = 1 then Macro2.Code:= lv1BEHAVIOUR
                 else Macro2.Code:= lv2BEHAVIOUR;
      Macro2.CheckParam:= 0; //param of the operator, not variable, actually
      Macro2.ParamVal:= cbMacro.ItemIndex;
      Macro2.ParamNext:= True; //here we tell to check param of the next cmd
      Flags:= [dtCmpBehav];
      UseMacro2:= True;
      FieldSize:= 11;
    end;
    grpLba1DirMode, grpLba2DirMode: begin
      Macro1.Types:= [ctCommand];
      if Lba = 1 then Macro1.Code:= lm1SET_DIRMODE
                 else Macro1.Code:= lm2SET_DIRMODE;
      Macro1.CheckParam:= 0;
      Macro1.ParamVal:= cbMacro.ItemIndex;
      Macro1.ParamNext:= False;
      Macro2.Types:= [ctCommand];
      if Lba = 1 then Macro2.Code:= lm1SET_DIRMODE_OBJ
                 else Macro2.Code:= lm2SET_DIRMODE_OBJ;
      Macro2.CheckParam:= 1;
      Macro2.ParamVal:= cbMacro.ItemIndex;
      Macro2.ParamNext:= False;
      UseMacro2:= True;
      FieldSize:= 11;
    end;
    grpLba1Operator, grpLba2Operator: begin
      Macro1.Types:= [ctOperator];
      Macro1.Code:= 0;
      Macro2.CheckParam:= -1;
      FieldSize:= 1;
    end;
  end;

  if cbMacro.ItemIndex = AllIndex then begin

    Errors:= 0;
    SetLength(OccurencesTab, cbMacro.Items.Count - 1); //not count ALL
    SetLength(ErrorsTab, cbMacro.Items.Count - 1);
    
    for a:= 0 to High(Scenes) do begin
      for b:= 0 to High(Scenes[a].Actors) do begin

        if Group in [grpLba1Track, grpLba2Track] then begin
          for c:= 0 to High(Scenes[a].TrackTrans_[b]) do begin
            d:= Scenes[a].TrackTrans_[b][c].Code;
            if d <= High(OccurencesTab) then begin
              Inc(OccurencesTab[d]);
              if Scenes[a].TrackTrans_[b][c].Error <> derrNoError then
                Inc(ErrorsTab[d]);
            end else
              Inc(Errors);
          end;
        end
        else if Group in [grpLba1Life, grpLba2Life, grpLba1Variable, grpLba2Variable] then begin
          for c:= 0 to High(Scenes[a].LifeTrans_[b]) do begin
            if Scenes[a].LifeTrans_[b][c].cType in Macro1.Types then begin
              d:= Scenes[a].LifeTrans_[b][c].Code;
              if d <= High(OccurencesTab) then begin
                Inc(OccurencesTab[d]);
                if Scenes[a].LifeTrans_[b][c].Error <> derrNoError then
                  Inc(ErrorsTab[d]);
              end else
                Inc(Errors);
            end;
          end;
        end
        else begin //behaviours and dir modes
          for c:= 0 to High(Scenes[a].LifeTrans_[b]) do begin
            d:= High(Integer);
            if  (Scenes[a].LifeTrans_[b][c].cType in Macro1.Types)
            and (Scenes[a].LifeTrans_[b][c].Code = Macro1.Code)
            then begin
              d:= Scenes[a].LifeTrans_[b][c].Params[Macro1.CheckParam];
            end
            else if UseMacro2
                and (Scenes[a].LifeTrans_[b][c].cType in Macro2.Types)
                and (Scenes[a].LifeTrans_[b][c].Code = Macro2.Code)
            then begin
              if not Macro2.ParamNext then
                d:= Scenes[a].LifeTrans_[b][c].Params[Macro2.CheckParam]
              else if c < High(Scenes[a].LifeTrans_[b]) then
                d:= Scenes[a].LifeTrans_[b][c+1].Params[Macro2.CheckParam]
              else
                continue;
            end;
            if d <= High(OccurencesTab) then begin
              Inc(OccurencesTab[d]);
              if Scenes[a].LifeTrans_[b][c].Error <> derrNoError then
                Inc(ErrorsTab[d]);
            end else
              Inc(Errors);    
          end;
        end;

      end;
    end;

    //Now display the gathered data
    reText.Lines.Add('');
    for a:= 0 to cbMacro.Items.Count - 2 do begin
      line:= LogField(cbMacro.Items[a], 30, True) + ' '
           + LogField(IntToStr(OccurencesTab[a]), 6, False);
      if ErrorsTab[a] > 0 then
        line:= line + ' ' + LogField('(' + IntToStr(ErrorsTab[a]) + ' errors)', 10, True);
      reText.Lines.Add(line);
      ScrollLog();
    end;

    if Errors > 0 then begin
      reText.Lines.Add('');
      reText.Lines.Add(IntToStr(Errors) + ' overrange macro codes detected.');
      ScrollLog();
    end;

  end
  else begin //single macro

    SetupDecompiler(Lba);

    for a:= 0 to High(Scenes) do begin
      SceneHead:= False;
      for b:= 0 to High(Scenes[a].Actors) do begin
        ActorHead:= False;
        FoundHere:= False;
        Errors:= 0;

        if Group in [grpLba1Track, grpLba2Track] then begin
          for c:= 0 to High(Scenes[a].TrackTrans_[b]) do begin
            if Scenes[a].TrackTrans_[b][c].cType = ctError then Inc(Errors);
            if Scenes[a].TrackTrans_[b][c].Code = Macro1.Code then begin
              FoundHere:= True;
              if Scenes[a].TrackTrans_[b][c].Error <> derrNoError then Inc(Errors);
              if not cbOnlyErrors.Checked then begin
                if not SceneHead then begin
                  reText.Lines.Add('');
                  reText.Lines.Add(Format('Scene %d - %s:', [a, SceneNames[a]]));
                  SceneHead:= True;
                end;
                if not ActorHead then begin
                  reText.Lines.Add(Format('Actor %d:', [b]));
                  ActorHead:= True;
                end;
                Strings:= TrackTransCmdToStrings(Scenes[a].TrackTrans_[b][c]);
                line:= '';//cbMacro.Items[cbMacro.ItemIndex] + '  '; //Macro name
                for d:= 0 to High(Strings) do
                  line:= line + LogField(Strings[d], FieldSize, False) + ' ';
                reText.Lines.Add(line);
                ScrollLog();
              end;
            end;
          end;
        end
        else begin //Life Script
          for c:= 0 to High(Scenes[a].LifeTrans_[b]) do begin
            if Scenes[a].LifeTrans_[b][c].cType = ctError then
              Inc(Errors);
            if  ((Scenes[a].LifeTrans_[b][c].cType in Macro1.Types)
             and (Scenes[a].LifeTrans_[b][c].Code = Macro1.Code)
             and ((Macro1.CheckParam < 0)
               or (Scenes[a].LifeTrans_[b][c].Params[Macro1.CheckParam] = Macro1.ParamVal)))
            or  (UseMacro2
             and (Scenes[a].LifeTrans_[b][c].cType in Macro2.Types)
             and (Scenes[a].LifeTrans_[b][c].Code = Macro2.Code)
             and ((Macro2.CheckParam < 0)
               or (not Macro2.ParamNext
                   and (Scenes[a].LifeTrans_[b][c].Params[Macro2.CheckParam] = Macro2.ParamVal))
               or (    Macro2.ParamNext
                   and (c < High(Scenes[a].LifeTrans_[b]))
                   and (Scenes[a].LifeTrans_[b][c+1].Params[Macro2.CheckParam] = Macro2.ParamVal))) )
            then begin
              FoundHere:= True;
              if Scenes[a].LifeTrans_[b][c].Error <> derrNoError then
                Inc(Errors);
              if not cbOnlyErrors.Checked then begin
                if not SceneHead then begin
                  reText.Lines.Add('');
                  reText.Lines.Add(Format('Scene %d - %s:', [a, SceneNames[a]]));
                  SceneHead:= True;
                end;
                if not ActorHead then begin
                  reText.Lines.Add(Format('Actor %d:', [b]));
                  ActorHead:= True;
                end;

                Strings:= LifeTransCmdToStrings(Scenes[a].LifeTrans_[b][c], []);
                line:= '';//cbMacro.Items[cbMacro.ItemIndex] + '  '; //Macro name
                for d:= 0 to High(Strings) do
                  line:= line + LogField(Strings[d], FieldSize, False) + ' ';

                if (Group in [grpLba1Variable, grpLba2Variable]) //also print operator and comp value
                or ((Group in [grpLba1Behaviour, grpLba2Behaviour])
                    and (Scenes[a].LifeTrans_[b][c].cType = ctVariable))
                then begin
                  if c < High(Scenes[a].LifeTrans_[b]) then begin
                    Strings:= LifeTransCmdToStrings(Scenes[a].LifeTrans_[b][c+1], Flags);
                    for d:= 0 to High(Strings) do
                      line:= line + LogField(Strings[d], FieldSize, False) + ' ';
                  end;
                end;

                reText.Lines.Add(line);
                ScrollLog();
              end;
            end;
          end;
        end;

        if (Errors > 0)
        and (cbAllErrors.Checked or FoundHere) then begin
          if not SceneHead then begin
            reText.Lines.Add('');
            reText.Lines.Add(Format('Scene %d - %s:', [a, SceneNames[a]]));
          end;
          if not ActorHead then
            reText.Lines.Add(Format('Actor %d:', [b]));
          reText.Lines.Add('(' + IntToStr(Errors) + ' errors)');
          ScrollLog();
        end;
      end;
    end;
  end;

  reText.Lines.Add('');
  reText.Lines.Add('== END ==');

  ReleaseDecompiler();

  Screen.Cursor:= crDefault;
end;

procedure TfmBatchAnalyse.cbMacroChange(Sender: TObject);
begin
  cbAllErrors.Enabled:= cbMacro.ItemIndex < cbMacro.Items.Count - 1;
  cbOnlyErrors.Enabled:= cbAllErrors.Enabled;
end;

procedure TfmBatchAnalyse.ScrollLog();
begin
  reText.SetFocus();
  reText.SelStart:= reText.GetTextLen();
  reText.Perform(EM_SCROLLCARET, 0, 0);
  Application.ProcessMessages();
end;

procedure TfmBatchAnalyse.rgGroupsClick(Sender: TObject);
begin
  cbMacro.Clear();
  case rgGroups.ItemIndex of
    0: begin //LBA 1 Life Script
      cbMacro.Items.Text:= '0: END'#13 + '1: NOP'#13 + '2: SNIF'#13 + '3: OFFSET'#13 + '4: NEVERIF'#13
      + '5: (unused)'#13 + '6: NO_IF'#13 + '7: (unused)'#13 + '8: (unused)'#13 + '9: (unused)'#13
      + '10: LABEL'#13 + '11: RETURN'#13 + '12: IF'#13 + '13: SWIF'#13 + '14: ONEIF'#13 + '15: ELSE'#13
      + '16: ENDIF (virtual)'#13 + '17: BODY'#13 + '18: BODY_OBJ'#13 + '19: ANIM'#13 + '20: ANIM_OBJ'#13
      + '21: SET_LIFE'#13 + '22: SET_LIFE_OBJ'#13 + '23: SET_TRACK'#13 + '24: SET_TRACK_OBJ'#13
      + '25: MESSAGE'#13 + '26: CAN_FALL'#13 + '27: SET_DIRMODE'#13 + '28: SET_DIRMODE_OBJ'#13
      + '29: CAM_FOLLOW'#13 + '30: SET_BEHAVIOUR'#13 + '31: SET_FLAG_CUBE'#13
      + '32: COMPORTMENT (virtual)'#13 + '33: SET_COMPORTMENT'#13 + '34: SET_COMPORTMENT_OBJ'#13
      + '35: END_COMPORTMENT'#13 + '36: SET_FLAG_GAME'#13 + '37: KILL_OBJ'#13 + '38: SUICIDE'#13
      + '39: USE_ONE_LITTLE_KEY'#13 + '40: GIVE_GOLD_PIECES'#13 + '41: END_LIFE'#13
      + '42: STOP_CURRENT_TRACK'#13 + '43: RESTORE_LAST_TRACK'#13 + '44: MESSAGE_OBJ'#13
      + '45: INC_CHAPTER'#13 + '46: FOUND_OBJECT'#13 + '47: SET_DOOR_LEFT'#13 + '48: SET_DOOR_RIGHT'#13
      + '49: SET_DOOR_UP'#13 + '50: SET_DOOR_DOWN'#13 + '51: GIVE_BONUS'#13 + '52: CHANGE_CUBE'#13
      + '53: OBJ_COL'#13 + '54: BRICK_COL'#13 + '55: OR_IF'#13 + '56: INVISIBLE'#13 + '57: ZOOM'#13
      + '58: POS_POINT'#13 + '59: SET_MAGIC_LEVEL'#13 + '60: SUB_MAGIC_POINT'#13 + '61: SET_LIFE_POINT_OBJ'#13
      + '62: SUB_LIFE_POINT_OBJ'#13 + '63: HIT_OBJ'#13 + '64: PLAY_FLA'#13 + '65: PLAY_MIDI'#13
      + '66: INC_CLOVER_BOX'#13 + '67: SET_USED_INVENTORY'#13 + '68: ADD_CHOICE'#13 + '69: ASK_CHOICE'#13
      + '70: BIG_MESSAGE'#13 + '71: INIT_PINGOUIN'#13 + '72: SET_HOLO_POS'#13 + '73: CLR_HOLO_POS'#13
      + '74: ADD_FUEL'#13 + '75: SUB_FUEL'#13 + '76: SET_GRM'#13 + '77: SAY_MESSAGE'#13
      + '78: SAY_MESSAGE_OBJ'#13 + '79: FULL_POINT'#13 + '80: BETA'#13 + '81: GRM_OFF'#13
      + '82: FADE_PAL_RED'#13 + '83: FADE_ALARM_RED'#13 + '84: FADE_ALARM_PAL'#13 + '85: FADE_RED_PAL'#13
      + '86: FADE_RED_ALARM'#13 + '87: FADE_PAL_ALARM'#13 + '88: EXPLODE_OBJ'#13 + '89: BALLOON_ON'#13
      + '90: BALLOON_OFF'#13 + '91: ASK_CHOICE_OBJ'#13 + '92: SET_DARK_PAL'#13 + '93: SET_NORMAL_PAL'#13
      + '94: MESSAGE_SENDELL'#13 + '95: ANIM_SET'#13 + '96: HOLOMAP_TRAJ'#13 + '97: GAME_OVER'#13
      + '98: THE_END'#13 + '99: MIDI_OFF'#13 + '100: PLAY_CD_TRACK'#13 + '101: PROJ_ISO'#13 + '102: PROJ_3D'#13
      + '103: TEXT'#13 + '104: CLEAR_TEXT'#13 + '105: BRUTAL_EXIT';
      AllIndex:= cbMacro.Items.Add('== All macros ==');
    end;
    1: begin //LBA 1 Track Script
      cbMacro.Items.Text:= '0: END'#13 + '1: NOP'#13 + '2: BODY'#13 + '3: ANIM'#13 + '4: GOTO_POINT'#13
      + '5: WAIT_ANIM'#13 + '6: LOOP'#13 + '7: ANGLE'#13 + '8: POS_POINT'#13 + '9: LABEL'#13 + '10: GOTO'#13
      + '11: STOP'#13 + '12: GOTO_SYM_POINT'#13 + '13: WAIT_NUM_ANIM'#13 + '14: SAMPLE'#13
      + '15: GOTO_POINT_3D'#13 + '16: SPEED'#13 + '17: BACKGROUND'#13 + '18: WAIT_NUM_SECOND'#13
      + '19: NO_BODY'#13 + '20: BETA'#13 + '21: OPEN_LEFT'#13 + '22: OPEN_RIGHT'#13 + '23: OPEN_UP'#13
      + '24: OPEN_DOWN'#13 + '25: CLOSE'#13 + '26: WAIT_DOOR'#13 + '27: SAMPLE_RND'#13
      + '28: SAMPLE_ALWAYS'#13 + '29: SAMPLE_STOP'#13 + '30: PLAY_FLA'#13 + '31: REPEAT_SAMPLE'#13
      + '32: SIMPLE_SAMPLE'#13 + '33: FACE_HERO'#13 + '34: ANGLE_RND';
      AllIndex:= cbMacro.Items.Add('== All macros ==');
    end;
    2: begin //LBA 1 Conditions
      cbMacro.Items.Text:= '0: COL'#13 + '1: COL_OBJ'#13 + '2: DISTANCE'#13 + '3: ZONE'#13 + '4: ZONE_OBJ'#13
      + '5: BODY'#13 + '6: BODY_OBJ'#13 + '7: ANIM'#13 + '8: ANIM_OBJ'#13 + '9: CURRENT_TRACK'#13
      + '10: CURRENT_TRACK_OBJ'#13 + '11: FLAG_CUBE'#13 + '12: CONE_VIEW'#13 + '13: HIT_BY'#13
      + '14: ACTION'#13 + '15: FLAG_GAME'#13 + '16: LIFE_POINT'#13 + '17: LIFE_POINT_OBJ'#13
      + '18: NUM_LITTLE_KEYS'#13 + '19: NUM_GOLD_PIECES'#13 + '20: BEHAVIOUR'#13 + '21: CHAPTER'#13
      + '22: DISTANCE_3D'#13 + '23: (unused)'#13 + '24: (unused)'#13 + '25: USE_INVENTORY'#13
      + '26: CHOICE'#13 + '27: FUEL'#13 + '28: CARRIED_BY'#13 + '29: CDROM';
      AllIndex:= cbMacro.Items.Add('== All conditions ==');
    end;
    3: begin //LBA 1 Behaviours
      cbMacro.Items.Text:= '0: NORMAL'#13 + '1: ATHLETIC'#13 + '2: AGGRESSIVE'#13 + '3: DISCRETE'#13
      + '4: PROTO_PACK';
      AllIndex:= cbMacro.Items.Add('== All behaviours ==');
    end;
    4: begin //LBA 1 Dir Modes
      cbMacro.Items.Text:= '0: NO_MOVE'#13 + '1: MANUAL'#13 + '2: FOLLOW'#13 + '3: TRACK'#13
      + '4: FOLLOW_2'#13 + '5: TRACK_ATTACK'#13 + '6: SAME_XZ'#13 + '7: RANDOM';
      AllIndex:= cbMacro.Items.Add('== All dir modes ==');
    end;
    {5: begin //LBA 1 Operators
      cbMacro.Items.Text:= '0: =='#13 + '1: >'#13 + '2: <'#13 + '3: >='#13 + '4: <='#13 + '5: !=';
      AllIndex:= cbMacro.Items.Add('== All operators ==');
    end;}

    6: begin //LBA 2 Life Script
      cbMacro.Items.Text:= '0: END'#13 + '1: NOP'#13 + '2: SNIF'#13 + '3: OFFSET'#13 + '4: NEVERIF'#13
      + '5: (unused)'#13 + '6: (unused)'#13 + '7: (unused)'#13 + '8: (unused)'#13 + '9: (unused)'#13
      + '10: PALETTE'#13 + '11: RETURN'#13 + '12: IF'#13 + '13: SWIF'#13 + '14: ONEIF'#13 + '15: ELSE'#13
      + '16: ENDIF'#13 + '17: BODY'#13 + '18: BODY_OBJ'#13 + '19: ANIM'#13 + '20: ANIM_OBJ'#13
      + '21: SET_CAMERA'#13 + '22: CAMERA_CENTER'#13 + '23: SET_TRACK'#13 + '24: SET_TRACK_OBJ'#13
      + '25: MESSAGE'#13 + '26: CAN_FALL'#13 + '27: SET_DIRMODE'#13 + '28: SET_DIRMODE_OBJ'#13
      + '29: CAM_FOLLOW'#13 + '30: SET_BEHAVIOUR'#13 + '31: SET_VAR_CUBE'#13 + '32: COMPORTMENT'#13
      + '33: SET_COMPORTMENT'#13 + '34: SET_COMPORTMENT_OBJ'#13 + '35: END_COMPORTMENT'#13
      + '36: SET_VAR_GAME'#13 + '37: KILL_OBJ'#13 + '38: SUICIDE'#13 + '39: USE_ONE_LITTLE_KEY'#13
      + '40: GIVE_GOLD_PIECES'#13 + '41: END_LIFE'#13 + '42: STOP_CURRENT_TRACK'#13
      + '43: RESTORE_LAST_TRACK'#13 + '44: MESSAGE_OBJ'#13 + '45: INC_CHAPTER'#13 + '46: FOUND_OBJECT'#13
      + '47: SET_DOOR_LEFT'#13 + '48: SET_DOOR_RIGHT'#13 + '49: SET_DOOR_UP'#13 + '50: SET_DOOR_DOWN'#13
      + '51: GIVE_BONUS'#13 + '52: CHANGE_CUBE'#13 + '53: OBJ_COL'#13 + '54: BRICK_COL'#13 + '55: OR_IF'#13
      + '56: INVISIBLE'#13 + '57: SHADOW_OBJ'#13 + '58: POS_POINT'#13 + '59: SET_MAGIC_LEVEL'#13
      + '60: SUB_MAGIC_POINT'#13 + '61: SET_LIFE_POINT_OBJ'#13 + '62: SUB_LIFE_POINT_OBJ'#13
      + '63: HIT_OBJ'#13 + '64: PLAY_ACF'#13 + '65: ECLAIR'#13 + '66: INC_CLOVER_BOX'#13
      + '67: SET_USED_INVENTORY'#13 + '68: ADD_CHOICE'#13 + '69: ASK_CHOICE'#13 + '70: INIT_BUGGY'#13
      + '71: MEMO_SLATE'#13 + '72: SET_HOLO_POS'#13 + '73: CLR_HOLO_POS'#13 + '74: ADD_FUEL'#13
      + '75: SUB_FUEL'#13 + '76: SET_GRM'#13 + '77: SET_CHANGE_CUBE'#13 + '78: MESSAGE_ZOE'#13
      + '79: FULL_POINT'#13 + '80: BETA'#13 + '81: FADE_TO_PAL'#13 + '82: ACTION'#13 + '83: SET_FRAME'#13
      + '84: SET_SPRITE'#13 + '85: SET_FRAME_3DS'#13 + '86: IMPACT_OBJ'#13 + '87: IMPACT_POINT'#13
      + '88: ADD_MESSAGE'#13 + '89: BALLOON'#13 + '90: NO_SHOCK'#13 + '91: ASK_CHOICE_OBJ'#13
      + '92: CINEMA_MODE'#13 + '93: SAVE_HERO'#13 + '94: RESTORE_HERO'#13 + '95: ANIM_SET'#13 + '96: RAIN'#13
      + '97: GAME_OVER'#13 + '98: THE_END'#13 + '99: ESCALATOR'#13 + '100: PLAY_MUSIC'#13
      + '101: TRACK_TO_VAR_GAME'#13 + '102: VAR_GAME_TO_TRACK'#13 + '103: ANIM_TEXTURE'#13
      + '104: ADD_MESSAGE_OBJ'#13 + '105: BRUTAL_EXIT'#13 + '106: REPLACE'#13 + '107: SCALE'#13
      + '108: SET_ARMOR'#13 + '109: SET_ARMOR_OBJ'#13 + '110: ADD_LIFE_POINT_OBJ'#13
      + '111: STATE_INVENTORY'#13 + '112: AND_IF'#13 + '113: SWITCH'#13 + '114: OR_CASE'#13 + '115: CASE'#13
      + '116: DEFAULT'#13 + '117: BREAK'#13 + '118: END_SWITCH'#13 + '119: SET_HIT_ZONE'#13
      + '120: SAVE_COMPORTMENT'#13 + '121: RESTORE_COMPORTMENT'#13 + '122: SAMPLE'#13 + '123: SAMPLE_RND'#13
      + '124: SAMPLE_ALWAYS'#13 + '125: SAMPLE_STOP'#13 + '126: REPEAT_SAMPLE'#13 + '127: BACKGROUND'#13
      + '128: ADD_VAR_GAME'#13 + '129: SUB_VAR_GAME'#13 + '130: ADD_VAR_CUBE'#13 + '131: SUB_VAR_CUBE'#13
      + '132: (unused)'#13 + '133: SET_RAIL'#13 + '134: INVERSE_BETA'#13 + '135: NO_BODY'#13
      + '136: ADD_GOLD_PIECES'#13 + '137: STOP_CURRENT_TRACK_OBJ'#13 + '138: RESTORE_LAST_TRACK_OBJ'#13
      + '139: SAVE_COMPORTMENT_OBJ'#13 + '140: RESTORE_COMPORTMENT_OBJ'#13 + '141: SPY'#13 + '142: DEBUG'#13
      + '143: DEBUG_OBJ'#13 + '144: POPCORN'#13 + '145: FLOW_POINT'#13 + '146: FLOW_OBJ'#13
      + '147: SET_ANIM_DIAL'#13 + '148: PCX'#13 + '149: END_MESSAGE'#13 + '150: END_MESSAGE_OBJ'#13
      + '151: PARM_SAMPLE'#13 + '152: NEW_SAMPLE'#13 + '153: POS_OBJ_AROUND'#13 + '154: PCX_MESS_OBJ';
      AllIndex:= cbMacro.Items.Add('== All macros ==');
    end;
    7: begin //LBA 2 Track Script
      cbMacro.Items.Text:= '0: END'#13 + '1: NOP'#13 + '2: BODY'#13 + '3: ANIM'#13 + '4: GOTO_POINT'#13
      + '5: WAIT_ANIM'#13 + '6: LOOP'#13 + '7: ANGLE'#13 + '8: POS_POINT'#13 + '9: LABEL'#13 + '10: GOTO'#13
      + '11: STOP'#13 + '12: GOTO_SYM_POINT'#13 + '13: WAIT_NUM_ANIM'#13 + '14: SAMPLE'#13
      + '15: GOTO_POINT_3D'#13 + '16: SPEED'#13 + '17: BACKGROUND'#13 + '18: WAIT_NUM_SECOND'#13
      + '19: NO_BODY'#13 + '20: BETA'#13 + '21: OPEN_LEFT'#13 + '22: OPEN_RIGHT'#13 + '23: OPEN_UP'#13
      + '24: OPEN_DOWN'#13 + '25: CLOSE'#13 + '26: WAIT_DOOR'#13 + '27: SAMPLE_RND'#13 + '28: SAMPLE_ALWAYS'#13
      + '29: SAMPLE_STOP'#13 + '30: PLAY_ACF'#13 + '31: REPEAT_SAMPLE'#13 + '32: SIMPLE_SAMPLE'#13
      + '33: FACE_HERO'#13 + '34: ANGLE_RND'#13 + '35: REPLACE'#13 + '36: WAIT_NUM_DECIMAL'#13 + '37: DO'#13
      + '38: SPRITE'#13 + '39: WAIT_NUM_SECOND_RND'#13 + '40: AFF_TIMER'#13 + '41: SET_FRAME'#13
      + '42: SET_FRAME_3DS'#13 + '43: SET_START_3DS'#13 + '44: SET_END_3DS'#13 + '45: START_ANIM_3DS'#13
      + '46: STOP_ANIM_3DS'#13 + '47: WAIT_ANIM_3DS'#13 + '48: WAIT_FRAME_3DS'#13 + '49: WAIT_NUM_DECIMAL_RND'#13
      + '50: INTERVAL'#13 + '51: FREQUENCY'#13 + '52: VOLUME';
      AllIndex:= cbMacro.Items.Add('== All macros ==');
    end;
    8: begin //LBA 2 Conditions
      cbMacro.Items.Text:= '0: COL'#13 + '1: COL_OBJ'#13 + '2: DISTANCE'#13 + '3: ZONE'#13 + '4: ZONE_OBJ'#13
      + '5: BODY'#13 + '6: BODY_OBJ'#13 + '7: ANIM'#13 + '8: ANIM_OBJ'#13 + '9: CURRENT_TRACK'#13
      + '10: CURRENT_TRACK_OBJ'#13 + '11: VAR_CUBE'#13 + '12: CONE_VIEW'#13 + '13: HIT_BY'#13
      + '14: ACTION'#13 + '15: VAR_GAME'#13 + '16: LIFE_POINT'#13 + '17: LIFE_POINT_OBJ'#13
      + '18: NUM_LITTLE_KEYS'#13 + '19: NUM_GOLD_PIECES'#13 + '20: BEHAVIOUR'#13 + '21: CHAPTER'#13
      + '22: DISTANCE_3D'#13 + '23: MAGIC_LEVEL'#13 + '24: MAGIC_POINT'#13 + '25: USE_INVENTORY'#13
      + '26: CHOICE'#13 + '27: FUEL'#13 + '28: CARRIED_BY'#13 + '29: CDROM'#13 + '30: LADDER'#13
      + '31: RND'#13 + '32: RAIL'#13 + '33: BETA'#13 + '34: BETA_OBJ'#13 + '35: CARRIED_OBJ_BY'#13
      + '36: ANGLE'#13 + '37: DISTANCE_MESSAGE'#13 + '38: HIT_OBJ_BY'#13 + '39: REAL_ANGLE'#13
      + '40: DEMO'#13 + '41: COL_DECORS'#13 + '42: COL_DECORS_OBJ'#13 + '43: PROCESSOR'#13
      + '44: OBJECT_DISPLAYED'#13 + '45: ANGLE_OBJ';
      AllIndex:= cbMacro.Items.Add('== All conditions ==');
    end;
    9: begin //LBA 2 Behaviours
      cbMacro.Items.Text:= '0: NORMAL'#13 + '1: SPORTY'#13 + '2: AGGRESSIVE'#13 + '3: DISCRETE'#13
      + '4: PROTO_PACK'#13 + '5: ?'#13 + '6: ?'#13 + '7: ?'#13 + '8: ?'#13 + '9: ?'#13 + '10: ?'#13
      + '11: ?'#13 + '12: ?'#13 + '13: ?';
      AllIndex:= cbMacro.Items.Add('== All behaviours ==');
    end;
    10: begin //LBA 2 Dir Modes
      cbMacro.Items.Text:= '0: NO_MOVE'#13 + '1: MANUAL'#13 + '2: FOLLOW'#13 + '3: TRACK'#13
      + '4: FOLLOW_2'#13 + '5: TRACK_ATTACK'#13 + '6: SAME_XZ'#13 + '7: RANDOM'#13 + '8: RAIL'#13
      + '9: ?'#13 + '10: ?'#13 + '11: ?'#13 + '12: ?'#13 + '13: ?';
      AllIndex:= cbMacro.Items.Add('== All dir modes ==');
    end;
    {11: begin //LBA 2 Operators
      cbMacro.Items.Text:= '0: =='#13 + '1: >'#13 + '2: <'#13 + '3: >='#13 + '4: <='#13 + '5: !=';
      AllIndex:= cbMacro.Items.Add('== All operators ==');
    end; }
  end;
end;

end.
