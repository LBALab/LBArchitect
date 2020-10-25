// #########################################################
// ################ Compilation routines ###################
// #########################################################

unit SceneLibComp;

interface

uses Classes, SceneLibConst, SceneLib1Tab, SceneLib2Tab, SysUtils, ActorInfo, Math, Utils;

type
  TIdentType = (itUnknown, itText, itNumber, itOperator);
  TTrackExpected = (teCommand, tePar1Num, tePar2Num, tePar1Text, teNewLine, teLabelNameDeclaration);
  TLifeExpected = (leCommand, lePar1Num, lePar2Num, lePar3Num, lePar4Num, lePar1Text,
                   leVariable, leSwVar, leOperator, leCaseOper, leBehaviour, leDirMode,
                   leNewLine, leFragmentId1, leFragmentId2, leFragSwitch3, leBreakMod);


procedure SetupCompiler(Lba: Byte);
procedure ReleaseCompiler(); //free data arrays
                   
//Returns index of Fragment name. If not found returns -1
//If not legal (i.e. "Main_Grid") returns -2
function FragmentNameIndex(s: String): Integer;

Function TrackCompile(TextScript: String; Actor: Integer;
  var BinaryScript: String; var LabelHashes: TLbHashTable;
  Callback: TCompCallbackProc; AInfo: array of TEntity; Scene: TScene): Boolean;
Function LifeCompToTransTable(TextScript: String; Actor: Integer;
  var LabelHashes: array of TLbHashTable; var CompList: TCompList; var Trans: TTransTable;
  Callback: TCompCallbackProc; AInfo: array of TEntity; Scene: TScene): Boolean;
//In the function below all params are "var", though TrackHashes nad CompLists
//  are not modified in the function. This is because when they were nor "var",
//  the program gave runtime error when the function was being called.
function LifeCompResolveOffsets(var Trans: array of TTransTable; Actor: Integer;
  var LabelHashes: array of TLbHashTable; var CompLists: array of TCompList;
  Callback: TCompCallbackProc): Boolean;
procedure LifeCompCheckUsage(LabelHashes: array of TLbHashTable;
  CompLists: array of TCompList; Callback: TCompCallbackProc);
function LifeCompTransToBin(Trans: TTransTable; var BinaryScript: String;
  var FragInfo: TScriptFragInfo; Actor: Integer; Callback: TCompCallbackProc): Boolean;

implementation

uses SceneLib, Globals;

var
  tmEND, tmBODY, tmANIM, tmLABEL, tmSTOP, tmGOTO, tmFACE_HERO,
    tmWAIT_NUM_AN, tmWAIT_NUM_SEC, tmANGLE_RND, tmREPLACE: Byte;
  lmEND, lmBODY, lmBODY_OBJ, lmANIM, lmANIM_OBJ, lmANIM_SET, lmCOMP, lmEND_COMP,
    lmSET_COMP, lmSET_COMP_OBJ, lmSET_GRM, lmSET_DIRM, lmSET_DIRM_OBJ,
    lmIF, lmOR_IF, lmELSE, lmENDIF, lmAND_IF, lmSET_BEHAV, lmSET_TRACK, lmSET_TRACK_OBJ,
    lmSWITCH, lmCASE, lmOR_CASE, lmBREAK, lmDEFAULT, lmEND_SWITCH,
    lmSUICIDE: Byte;
  lvZONE, lvZONE_OBJ, lvBODY, lvANIM, lvBODY_OBJ, lvANIM_OBJ, lvCUR_TRACK,
    lvCUR_TRACK_OBJ, lvBEHAV: Byte;

  Track3DCmds: set of Byte;       //Track cmds specific to 3D Actors
  TrackSpriteCmds: set of Byte;   //Track cmds specific to Sprite Actors
  TrackPointIDCheck: set of Byte; //Track cmds using Point IDs
  Life3DCmds: set of Byte;        //Life cmds specific to 3D Actors
  LifeSpriteCmds: set of Byte;    //Life cmds specific to Sprite Actors
  Life3DPar1Cmds: set of Byte;    //Life cmds using 3D Actor IDs in first param
  LifeActorRefCmds: set of Byte;  //Life cmds using any Actor IDs in first param
  LifePointRefCmds: set of Byte;  //Life cmds using Point IDs
  Life3DVars: set of Byte;        //Life vars specific to 3D Actors
  LifeActorRefVars: set of Byte;  //Life vars using any Actor IDs in first param
  LifeActorTVars: set of Byte;    //Life vars testing actor IDs
  LifeAfterOrIf: set of Byte;     //Life cmds allowed after OR_IF cmd
  LifeIfWithoutOr: set of Byte;   //Life IF-type cmds without OR_IF
  DirmReqObj: set of Byte;      //dirmodes require an object ID after the mode

  TrackList: TMacroModAr;       //command names with aliases
  TrackProps: TCommandProps;    //command properties
  LifeList: TMacroModAr;        //command names with aliases
  LifeProps: TCommandProps;     //command properties
  VarList: TMacroModAr;         //variable names with aliases
  VarProps: TVariableProps;     //variable properties
  BehavList: TMacroModAr;       //behaviour names
  DirmList: TMacroModAr;        //direction mode list


procedure SetupCompiler(Lba: Byte);
begin
  if Lba = 1 then begin
    tmEND:=            tm1END;
    tmBODY:=           tm1BODY;
    tmANIM:=           tm1ANIM;
    tmLABEL:=          tm1LABEL;
    tmSTOP:=           tm1STOP;
    tmGOTO:=           tm1GOTO;
    tmFACE_HERO:=      tm1FACE_HERO;
    tmWAIT_NUM_AN:=    tm1WAIT_NUM_ANIM;
    tmWAIT_NUM_SEC:=   tm1WAIT_NUM_SECOND;
    tmANGLE_RND:=      tm1ANGLE_RND;
    tmREPLACE:=        255;
    lmEND:=            lm1END;
    lmSUICIDE:=        lm1SUICIDE;
    lmBODY:=           lm1BODY;
    lmBODY_OBJ:=       lm1BODY_OBJ;
    lmANIM:=           lm1ANIM;
    lmANIM_OBJ:=       lm1ANIM_OBJ;
    lmANIM_SET:=       lm1ANIM_SET;
    lmCOMP:=           lm1COMPORTMENT;
    lmEND_COMP:=       lm1END_COMPORTMENT;
    lmSET_COMP:=       lm1SET_COMPORTMENT;
    lmSET_COMP_OBJ:=   lm1SET_COMPORTMENT_OBJ;
    lmIF:=             lm1IF;
    lmOR_IF:=          lm1OR_IF;
    lmELSE:=           lm1ELSE;
    lmENDIF:=          lm1ENDIF;
    lmAND_IF:=         255;
    lmSWITCH:=         255;
    lmCASE:=           255;
    lmOR_CASE:=        255;
    lmBREAK:=          255;
    lmDEFAULT:=        255;
    lmEND_SWITCH:=     255;
    lmSET_BEHAV:=      lm1SET_BEHAVIOUR;
    lmSET_DIRM:=       lm1SET_DIRMODE;
    lmSET_DIRM_OBJ:=   lm1SET_DIRMODE_OBJ;
    lmSET_GRM:=        lm1SET_GRM;
    lmSET_TRACK:=      lm1SET_TRACK;
    lmSET_TRACK_OBJ:=  lm1SET_TRACK_OBJ;
    lvZONE:=           lv1ZONE;
    lvZONE_OBJ:=       lv1ZONE_OBJ;
    lvBODY:=           lv1BODY;
    lvBODY_OBJ:=       lv1BODY_OBJ;
    lvANIM:=           lv1ANIM;
    lvANIM_OBJ:=       lv1ANIM_OBJ;
    lvCUR_TRACK:=      lv1CURRENT_TRACK;
    lvCUR_TRACK_OBJ:=  lv1CURRENT_TRACK_OBJ;
    lvBEHAV:=          lv1BEHAVIOUR;

    Track3DCmds:= [tm1BODY, tm1ANIM, tm1ANGLE, tm1WAIT_NUM_ANIM, tm1NO_BODY,
      tm1FACE_HERO, tm1ANGLE_RND, tm1WAIT_ANIM];
    TrackSpriteCmds:= [tm1OPEN_LEFT, tm1OPEN_RIGHT, tm1OPEN_UP, tm1OPEN_DOWN,
      tm1CLOSE, tm1WAIT_DOOR, tm1GOTO_POINT_3D, tm1SPEED];
    TrackPointIDCheck:= [tm1GOTO_POINT, tm1GOTO_POINT_3D, tm1POS_POINT,
      tm1GOTO_SYM_POINT];
    Life3DCmds:= [lm1BODY, lm1ANIM, lm1ANIM_SET];
    LifeSpriteCmds:= [lm1SET_DOOR_LEFT, lm1SET_DOOR_RIGHT, lm1SET_DOOR_UP,
      lm1SET_DOOR_DOWN];
    Life3DPar1Cmds:= [lm1BODY_OBJ, lm1ANIM_OBJ, lm1SET_LIFE_POINT_OBJ,
      lm1SUB_LIFE_POINT_OBJ];
    LifeActorRefCmds:= [lm1BODY_OBJ, lm1ANIM_OBJ, lm1SET_TRACK_OBJ,
      lm1SET_DIRMODE_OBJ, lm1CAM_FOLLOW, lm1SET_COMPORTMENT_OBJ, lm1KILL_OBJ,
      lm1EXPLODE_OBJ, lm1ASK_CHOICE_OBJ, lm1MESSAGE_OBJ, lm1SAY_MESSAGE_OBJ,
      lm1SET_LIFE_POINT_OBJ, lm1SUB_LIFE_POINT_OBJ, lm1HIT_OBJ, lm1INIT_PINGOUIN];
    LifePointRefCmds:= [lm1POS_POINT];
    Life3DVars:= [lv1BODY, lv1ANIM];
    LifeActorRefVars:= [lv1COL_OBJ, lv1DISTANCE, lv1ZONE_OBJ, lv1BODY_OBJ,
      lv1ANIM_OBJ, lv1LIFE_POINT_OBJ, lv1DISTANCE_3D, lv1CONE_VIEW,
      lv1CURRENT_TRACK_OBJ];
    LifeActorTVars:= [lv1COL, lv1COL_OBJ, lv1HIT_BY, lv1CARRIED_BY];
    LifeAfterOrIf:= [lm1OR_IF, lm1IF, lm1SWIF, lm1ONEIF];
    LifeIfWithoutOr:= [lm1IF, lm1SNIF, lm1NEVERIF, lm1NO_IF, lm1SWIF, lm1ONEIF];
    DirmReqObj:=      [ld1FOLLOW, ld1FOLLOW2];

    SetLength(TrackList, Length(Track1CompList));
    Move(Track1CompList[0], TrackList[0], SizeOf(Track1CompList));
    SetLength(TrackProps, Length(Track1Props));
    Move(Track1Props[0], TrackProps[0], SizeOf(Track1Props));

    SetLength(LifeList, Length(Life1CompList));
    Move(Life1CompList[0], LifeList[0], SizeOf(Life1CompList));
    SetLength(LifeProps, Length(Life1Props));
    Move(Life1Props[0], LifeProps[0], SizeOf(Life1Props));

    SetLength(BehavList, Length(Behav1CompList));
    Move(Behav1CompList[0], BehavList[0], SizeOf(Behav1CompList));
    SetLength(VarList, Length(Var1CompList));
    Move(Var1CompList[0], VarList[0], SizeOf(Var1CompList));
    SetLength(VarProps, Length(Var1Props));
    Move(Var1Props[0], VarProps[0], SizeOf(Var1Props));
    SetLength(DirmList, Length(DirMode1CompList));
    Move(DirMode1CompList[0], DirmList[0], SizeOf(DirMode1CompList));

  end else begin //LBA2

    tmEND:=            tm2END;
    tmBODY:=           tm2BODY;
    tmANIM:=           tm2ANIM;
    tmLABEL:=          tm2LABEL;
    tmSTOP:=           tm2STOP;
    tmGOTO:=           tm2GOTO;
    tmFACE_HERO:=      tm2FACE_TWINSEN;
    tmWAIT_NUM_AN:=    tm2WAIT_NUM_ANIM;
    tmWAIT_NUM_SEC:=   tm2WAIT_NUM_SECOND;
    tmANGLE_RND:=      tm2ANGLE_RND;
    tmREPLACE:=        tm2REPLACE;
    lmEND:=            lm2END;
    lmSUICIDE:=        lm2SUICIDE;
    lmBODY:=           lm2BODY;
    lmBODY_OBJ:=       lm2BODY_OBJ;
    lmANIM:=           lm2ANIM;
    lmANIM_OBJ:=       lm2ANIM_OBJ;
    lmANIM_OBJ:=       lm2ANIM_OBJ;
    lmANIM_SET:=       lm2ANIM_SET;
    lmCOMP:=           lm2COMPORTMENT;
    lmEND_COMP:=       lm2END_COMPORTMENT;
    lmSET_COMP:=       lm2SET_COMPORTMENT;
    lmSET_COMP_OBJ:=   lm2SET_COMPORTMENT_OBJ;
    lmIF:=             lm2IF;
    lmOR_IF:=          lm2OR_IF;
    lmELSE:=           lm2ELSE;
    lmENDIF:=          lm2ENDIF;
    lmAND_IF:=         lm2AND_IF;
    lmSWITCH:=         lm2SWITCH;
    lmCASE:=           lm2CASE;
    lmOR_CASE:=        lm2OR_CASE;
    lmBREAK:=          lm2BREAK;
    lmDEFAULT:=        lm2DEFAULT;
    lmEND_SWITCH:=     lm2END_SWITCH;
    lmSET_BEHAV:=      lm2SET_BEHAVIOUR;
    lmSET_DIRM:=       lm2SET_DIRMODE;
    lmSET_DIRM_OBJ:=   lm2SET_DIRMODE_OBJ;
    lmSET_GRM:=        lm2SET_GRM;
    lmSET_TRACK:=      lm2SET_TRACK;
    lmSET_TRACK_OBJ:=  lm2SET_TRACK_OBJ;
    lvZONE:=           lv2ZONE;
    lvZONE_OBJ:=       lv2ZONE_OBJ;
    lvBODY:=           lv2BODY;
    lvBODY_OBJ:=       lv2BODY_OBJ;
    lvANIM:=           lv2ANIM;
    lvANIM_OBJ:=       lv2ANIM_OBJ;
    lvCUR_TRACK:=      lv2CURRENT_TRACK;
    lvCUR_TRACK_OBJ:=  lv2CURRENT_TRACK_OBJ;
    lvBEHAV:=          lv2BEHAVIOUR;

    Track3DCmds:= [tm2BODY, tm2ANIM, tm2ANGLE, tm2WAIT_NUM_ANIM, tm2NO_BODY,
      tm2FACE_TWINSEN, tm2ANGLE_RND, tm2WAIT_ANIM, tm2BETA, tm2GOTO_POINT, tm2GOTO_SYM_POINT];
    TrackSpriteCmds:= [tm2OPEN_LEFT, tm2OPEN_RIGHT, tm2OPEN_UP, tm2OPEN_DOWN,
      tm2CLOSE, tm2WAIT_DOOR, tm2GOTO_POINT_3D, tm2SPEED, tm2SPRITE,
      tm2SET_FRAME_3DS, tm2SET_START_3DS,	tm2SET_END_3DS, tm2START_ANIM_3DS,
      tm2STOP_ANIM_3DS, tm2WAIT_ANIM_3DS, tm2WAIT_FRAME_3DS];
    TrackPointIDCheck:= [tm2GOTO_POINT, tm2GOTO_POINT_3D, tm2POS_POINT,
      tm2GOTO_SYM_POINT];
    Life3DCmds:= [lm2BODY, lm2ANIM, lm2ANIM_SET, lm2BETA, lm2INVERSE_BETA, lm2NO_BODY];
    LifeSpriteCmds:= [lm2SET_DOOR_LEFT, lm2SET_DOOR_RIGHT, lm2SET_DOOR_UP,
      lm2SET_DOOR_DOWN, lm2SET_SPRITE, lm2SET_FRAME_3DS];
    Life3DPar1Cmds:= [lm2BODY_OBJ, lm2ANIM_OBJ, lm2SET_LIFE_POINT_OBJ,
      lm2SUB_LIFE_POINT_OBJ];
    LifeActorRefCmds:= [lm2BODY_OBJ, lm2ANIM_OBJ, lm2SET_TRACK_OBJ,
      lm2SET_DIRMODE_OBJ, lm2CAM_FOLLOW, lm2SET_COMPORTMENT_OBJ, lm2KILL_OBJ,
      lm2ASK_CHOICE_OBJ, lm2MESSAGE_OBJ, lm2IMPACT_OBJ,
      lm2SET_LIFE_POINT_OBJ, lm2SUB_LIFE_POINT_OBJ, lm2HIT_OBJ, lm2SHADOW_OBJ,
      lm2ADD_MESSAGE_OBJ, lm2SET_ARMOUR_OBJ, lm2ADD_LIFE_POINT_OBJ,
      lm2STOP_TRACK_OBJ, lm2RESTORE_TRACK_OBJ, lm2SAVE_COMPORTMENT_OBJ,
      lm2RESTORE_COMPORTMENT_OBJ, lm2DEBUG_OBJ, lm2FLOW_OBJ, lm2END_MESSAGE_OBJ,
      lm2POS_OBJ_AROUND];
    LifePointRefCmds:= [lm2POS_POINT, lm2IMPACT_POINT, lm2FLOW_POINT];
    Life3DVars:= [lv2BODY, lv2ANIM, lv2ANGLE, lv2REAL_ANGLE];
    LifeActorRefVars:= [lv2COL_OBJ, lv2DISTANCE, lv2ZONE_OBJ, lv2BODY_OBJ,
      lv2ANIM_OBJ, lv2LIFE_POINT_OBJ, lv2DISTANCE_3D, lv2CONE_VIEW,
      lv2CURRENT_TRACK_OBJ, lv2BETA_OBJ, lv2CARRIED_OBJ_BY, lv2HIT_OBJ_BY,
      lv2COL_DECORS_OBJ, lv2ANGLE_OBJ, lv2OBJECT_DISPLAYED];
    LifeActorTVars:= [lv2COL, lv2COL_OBJ, lv2HIT_BY, lv2CARRIED_BY, lv2CARRIED_OBJ_BY,
      lv2HIT_OBJ_BY];
    LifeAfterOrIf:= [lm2OR_IF, lm2IF, lm2SWIF, lm2ONEIF, lm2AND_IF];
    LifeIfWithoutOr:= [lm2IF, lm2SNIF, lm2NEVERIF, lm2SWIF, lm2ONEIF];
    DirmReqObj:= [ld2FOLLOW, ld2FOLLOW2, ld2SAME_XZ, ld2DIRMODE9, ld2DIRMODE10, ld2DIRMODE11];


    SetLength(TrackList, Length(Track2CompList));
    Move(Track2CompList[0], TrackList[0], SizeOf(Track2CompList));
    SetLength(TrackProps, Length(Track2Props));
    Move(Track2Props[0], TrackProps[0], SizeOf(Track2Props));

    SetLength(LifeList, Length(Life2CompList));
    Move(Life2CompList[0], LifeList[0], SizeOf(Life2CompList));
    SetLength(LifeProps, Length(Life2Props));
    Move(Life2Props[0], LifeProps[0], SizeOf(Life2Props));

    SetLength(BehavList, Length(Behav2CompList));
    Move(Behav2CompList[0], BehavList[0], SizeOf(Behav2CompList));
    SetLength(VarList, Length(Var2CompList));
    Move(Var2CompList[0], VarList[0], SizeOf(Var2CompList));
    SetLength(VarProps, Length(Var2Props));
    Move(Var2Props[0], VarProps[0], SizeOf(Var2Props));
    SetLength(DirmList, Length(Dirm2CompList));
    Move(Dirm2CompList[0], DirmList[0], SizeOf(Dirm2CompList));
  end;
end;

procedure ReleaseCompiler();
begin
  SetLength(TrackList, 0);
  SetLength(TrackProps, 0);
  SetLength(LifeList, 0);
  SetLength(LifeProps, 0);
  SetLength(BehavList, 0);
  SetLength(VarList, 0);
  SetLength(VarProps, 0);
  SetLength(DirmList, 0);
end;

//Returns index of LABEL name. If not found return -1
//Normal linear search
function LabelNameIndex(LH: TLbHashTable; s: string): integer;
var i: integer;
begin
 s:= uppercase(s);
 for i:= 0 to length(LH) - 1 do
   if uppercase(LH[i].LabelName) = s then begin
     result:= i;
     exit;
   end;
 result:= -1;
 exit;
end;

//Returns index of Fragment name. If not found returns -1
//If not legal (i.e. "Main_Grid") returns -2
function FragmentNameIndex(s: String): Integer;
var a: Integer;
begin
 Result:= -1;
 if Length(LdMaps) < 1 then Exit;
 if SameText(s, LdMaps[0].Name) then Result:= -2
 else begin
   for a:= 0 to High(LdMaps) do
     if SameText(s, LdMaps[a].Name) then begin
       Result:= a;
       Exit;
     end;
 end;
end;

function IsReservedWord(name: String): Boolean;
var a: Integer;
begin
 Result:= False;
 for a:= 0 to High(ReservedWords) do
   if SameText(name, ReservedWords[a]) then begin
     Result:= True;
     Exit;
   end;
end;

function GetIdentType(name: String): TIdentType;
var a: Integer;
begin
  Result:= itUnknown;
  If Length(name) > 0 then begin
    If name[1] in ['a'..'z', 'A'..'Z'] then begin
      for a:= 2 to Length(name) do
        If not (name[a] in ['a'..'z', 'A'..'Z', '_', '.', '0'..'9']) then Exit;
      Result:= itText;
    end
    else if name[1] in ['0'..'9','-'] then begin
      for a:= 2 to Length(name) do
        If not (name[a] in ['0'..'9']) then Exit;
      Result:= itNumber;
    end
    else if (Length(name) <= 2) and (name[1] in ['=', '<', '>', '!']) then begin
      If (Length(name) = 1) or (name[2] = '=') then Result:= itOperator;
    end;
  end;
end;

//Returns 255 if there is no such identifier
//Lists: TrackList, LifeList, ConditionsList, BehavioursList,
//       OperatorsList, DirModesList
function GetIdentifierId(name: String; list: array of TMacroModItem): Byte;
var a: Integer;
begin
  Result:= 255;
  if Length(name) > 0 then
    for a:= 0 to High(list) do
      if SameText(list[a].name, name) then begin
        Result:= list[a].id;
        Exit;
      end;
end;

function IsProperFlaName(name: String): Boolean;
var a: Integer;
begin
 Result:= False;
 if (Length(name) > 0) and (Length(name) <= 12) then begin
   for a:= 1 to Length(name) do
     if not (name[a] in ['a'..'z', 'A'..'Z', '.', '0'..'9', '_']) then Exit;
   Result:= True; //SameStr(Copy(name,Length(name) - 3, 4),'.fla');
   //Extension checking not necessary - the .fla extension is not required.
 end;
end;

function IsProperCompName(name: String): Boolean;
var a: Integer;
begin
 Result:= False;
 If (Length(name) > 0) and (Length(name) <= 30) then begin
   for a:= 1 to Length(name) do
     If not (name[a] in ['a'..'z','A'..'Z','0'..'9','_','.']) then Exit;
   Result:= True;
 end;
end;

Procedure WarningOrError(Proc: TCompCallbackProc; TrackScript: Boolean;
  Id, Actor, Line, PStart, Len: Integer; Error: Boolean);
begin
 If not Error then Inc(Id, 1000);
 AddMessage(Proc, TrackScript, Id, Actor, Line, PStart, Len);
end;

function CheckActorBodyOrAnim(TrackScript: Boolean; Actor, TargetActor, Value, Line,
  PStart, Len: Integer; AInfo: array of TEntity; Scene: TScene; Body: Boolean;
  Callback: TCompCallbackProc): Boolean;
var a: Integer;
begin
  Result:= True;
  If (TargetActor >= 0) and (TargetActor <= High(Scene.Actors)) then //If Actor is valid
    If ScrSet.Comp.CheckBdAn then begin
      a:= Scene.Actors[TargetActor].Entity;
      If (a >= 0) and (a <= High(AInfo)) then begin //entity is valid
        If Body then begin
          If FindBodyVirtualIndex(AInfo[a].Bodies, Value) < 0 then begin
            WarningOrError(Callback, TrackScript, ceNoActorBody, Actor, Line, PStart, Len,
              ScrSet.Comp.BdAnErrors);
            Result:= not ScrSet.Comp.BdAnErrors;
          end;
        end
        else begin
          If FindAnimVirtualIndex(AInfo[a].Anims, Value) < 0 then begin
            WarningOrError(Callback, TrackScript, ceNoActorAnim, Actor, Line, PStart, Len,
              ScrSet.Comp.BdAnErrors);
            Result:= not ScrSet.Comp.BdAnErrors;
          end;
        end;
      end
      else
        AddMessage(Callback, TrackScript, cwActorNoEntity, Actor, 0, 0, 0);
    end;
end;

Procedure CheckActorSprite(TrackScript: Boolean; Actor, TargetActor, Line, PStart,
 Len: Integer; Scene: TScene; NotSprite: Boolean; Callback: TCompCallbackProc);
begin
 If ScrSet.Comp.CheckSuit then
   If (TargetActor >= 0) and (TargetActor <= High(Scene.Actors)) then //If valid Actor
     If ((Scene.Actors[TargetActor].StaticFlags and sfSprite) = 0) xor NotSprite then
       AddMessage(Callback, TrackScript, IfThen(NotSprite, cwActorSprite, cwActorNotSprite),
         Actor, Line, PStart, Len);
end;

Procedure CheckActorZonable(TrackScript: Boolean; Actor, TargetActor, Line, PStart,
 Len: Integer; Scene: TScene; Callback: TCompCallbackProc);
begin
 If ScrSet.Comp.CheckSuit then
   If (TargetActor > 0) and (TargetActor <= High(Scene.Actors)) then //If valid Actor and not Hero
     If (Scene.Actors[TargetActor].StaticFlags and sfZonable) = 0 then
       AddMessage(Callback, TrackScript, cwActorNotZonable, Actor, Line, PStart, Len);
end;

Function CheckTrackId(TrackScript: Boolean; Actor, Value, Line, PStart,
 Len: Integer; Scene: TScene; Callback: TCompCallbackProc): Boolean;
begin
 Result:= True;
 If ScrSet.Comp.CheckTracks then begin
   If Value > High(Scene.Points) then begin //Track ID out of range
     WarningOrError(Callback, TrackScript, ceNoSceneTrack, Actor, Line, PStart, Len,
       ScrSet.Comp.TrackErrors);
     Result:= not ScrSet.Comp.TrackErrors;
   end;
 end;
end;

Function CheckActorId(Actor, Value, Line, PStart, Len: Integer;
 Scene: TScene; Callback: TCompCallbackProc): Boolean;
begin
 Result:= True;
 If ScrSet.Comp.CheckActors then begin
   If (Value < 0) or (Value > High(Scene.Actors)) then begin
     WarningOrError(Callback, False, ceLifeNoActor, Actor, Line, PStart, Len,
       ScrSet.Comp.ActorErrors);
     Result:= not ScrSet.Comp.ActorErrors;
   end;
 end;
end;

Procedure CheckZoneId(Actor, Value, Line, PStart,
 Len: Integer; Scene: TScene; Callback: TCompCallbackProc);
var a: Integer;
begin
 If ScrSet.Comp.CheckZones then begin
   for a:= 0 to High(Scene.Zones) do
     If (Scene.Zones[a].RealType = ztSceneric)
     and (Scene.Zones[a].VirtualID = Value) then Exit;

   //Zone ID doesn't exist
   AddMessage(Callback, False, cwNoSceneZone, Actor, Line, PStart, Len);
 end;
end;

//==============================================================================
// TRACK SCRIPT
//==============================================================================

function TrackCheckSceneArraysSprite(OpCode: Byte; Actor, Line, PStart,
  Len: Integer; Scene: TScene; Callback: TCompCallbackProc): Boolean;
begin
 Result:= True;
 if OpCode in Track3DCmds then  //checking if the Actor is not a Sprite
   CheckActorSprite(True, Actor, Actor, Line, PStart, Len, Scene, True, Callback)
 else if OpCode in TrackSpriteCmds then //checking if the Actor is a Sprite
   CheckActorSprite(True, Actor, Actor, Line, PStart, Len, Scene, False, Callback);
end;

//Returns True if everything is okay
Function TrackCheckSceneArrays(OpCode: Byte; Value, Actor, Line, PStart,
  Len: Integer; AInfo: array of TEntity; Scene: TScene;
  Callback: TCompCallbackProc): Boolean;
begin
 Result:= True;
 if OpCode in [tmBODY, tmANIM] then //checking Body and Anim virtual indexes
   Result:= CheckActorBodyOrAnim(True, Actor, Actor, Value, Line, PStart, Len,
              AInfo, Scene, OpCode = tmBODY, Callback)
 else if OpCode in TrackPointIDCheck then //checking Track ID
   Result:= CheckTrackId(True, Actor, Value, Line, PStart, Len, Scene, Callback);
end;

//Resturns True if compilation was successful (no errors)
Function TrackCompile(TextScript: String; Actor: Integer;
  var BinaryScript: String; var LabelHashes: TLbHashTable;
  Callback: TCompCallbackProc; AInfo: array of TEntity;
  Scene: TScene): Boolean;
var a, b, Offset, val, param, tth, idst, idl: Integer;
    OpCode: Byte;
    Lines: TStringList;
    CommandProps: TCommandProp;
    Line, Ident,paramstr: String;
    Expected: TTrackExpected;
    EndWarn, CommentBlock, ExpLABEL: Boolean;
    Trans: TTransTable;
begin

  Lines:= TStringList.Create;
  Lines.Text:= TextScript; //It is easier to manage in this form
  tth:= -1;
  SetLength(Trans, 0);
  SetLength(LabelHashes, 0);
  Result:= True;

  BinaryScript:= '';
  Offset:= 0;
  CommentBlock:= False;
  ExpLABEL:= True; //Label expected, otherwise give a warning
  EndWarn:= False; //If code after END warning has been posted already

  //Compiling script into the transitional variable
  Expected:= teCommand;
  for a:= 0 to Lines.Count - 1 do begin

    Line:= Lines.Strings[a]; //LowerCase(Lines.Strings[a]);
    for b:= 1 to Length(Line) do begin

      If CommentBlock then begin
        If Line[b] = '}' then CommentBlock:= False;
        If ((Expected = teNewLine))
        and ((b = Length(Line)) or (Line[b] in [#13, #10])) then
          Expected:= teCommand;
      end
      else begin

        if Line[b] in ['_', '-', '0'..'9', 'a'..'z', 'A'..'Z', ' ', #13, #10, #09, '.',
                       '/', '{']
        then begin

          if Line[b] = '{' then CommentBlock:= True
          else if (Line[b] = '/') and (b > 1) and (Line[b-1] = '/') then begin
            Ident:= '';
            If (Expected = teNewLine) then Expected:= teCommand
            else if Expected <> teCommand then begin
              AddMessage(Callback, True, ceUnExEol, Actor, a + 1, Length(Line), 0);
              Result:= False;
            end;
            Break;
          end;

          if Line[b] in ['_', '-', '0'..'9', 'a'..'z', 'A'..'Z', '.'] then
            Ident:= Ident + Line[b];
            
          if (b = Length(Line)) or (Line[b] in [' ', #13, #10, #09, '{', '/']) then begin
            idl:= Length(Ident);
            idst:= b - idl - 1;
            If idl > 0 then begin
              If SameText(Ident, 'rem') then begin //Start of commented line
                Ident:= '';
                CommentBlock:= False; //useful when comment block starts right after REM
                If Expected = teNewLine then Expected:= teCommand
                else if Expected <> teCommand then begin
                  AddMessage(Callback, True, ceUnExEol, Actor, a + 1, Length(Line), 0);
                  Result:= False;
                end;
                Break;
              end
              else begin
                case Expected of
                  teCommand:
                    if GetIdentType(Ident) = itText then begin
                      OpCode:= GetIdentifierId(Ident, TrackList);
                      if OpCode < 255 then begin
                        CommandProps:= TrackProps[OpCode];

                        if ExpLABEL then begin
                          if not (OpCode in [tmLABEL, tmEND, tmREPLACE]) then begin
                            if LbaMode = 1 then begin
                              if (tth > -1) then
                                AddMessage(Callback, True, cwNoLabelStop, Actor, a + 1, idst, idl)
                              else
                                AddMessage(Callback, True, cwNoLabelStart, Actor, a + 1, idst, idl)
                            end else begin //LBA2
                              if (tth > -1) then
                                AddMessage(Callback, True, cwNoLabRepStop, Actor, a + 1, idst, idl)
                              else
                                AddMessage(Callback, True, cwNoLabRepStart, Actor, a + 1, idst, idl)
                            end;
                          end;  
                        end;
                        ExpLABEL:= OpCode = tmSTOP;

                        Inc(tth);
                        SetLength(Trans, tth + 1);
                        Trans[tth].Code:= OpCode;
                        Trans[tth].ParCount:= CommandProps.ParCount;
                        Move(CommandProps.ParSize[0], Trans[tth].ParSize[0], SizeOf(Trans[tth].ParSize));
                        Trans[tth].Flags:= CommandProps.Flags;
                        Trans[tth].Offset:= Offset;
                        Trans[tth].Line:= a + 1;
                        if not TrackCheckSceneArraysSprite(OpCode, Actor, a + 1,
                          idst, idl, Scene, Callback)
                        then
                          Result:= False;
                        Ident:= '';
                        Inc(Offset);
                        if not EndWarn and (tth > 0) and (Trans[tth-1].Code = tmEND) then begin
                          EndWarn:= True;
                          AddMessage(Callback, True, cwCodeAfterEnd, Actor, a + 1, idst, idl)
                        end;

                        if (CommandProps.ParCount = -1) or (Trans[tth].Code = tmGOTO) then
                          Expected:= tePar1Text
                        else if (CommandProps.ParCount > 0)
                          and not (cfPar1Dummy in CommandProps.Flags) then Expected:= tePar1Num
                        else Expected:= teNewLine;
                        If cfPar1Dummy in CommandProps.Flags then begin
                          Inc(Offset, CommandProps.ParSize[0]);
                          //fill dummy params with default values
                          if Trans[tth].Code = tmFACE_HERO then 
                            Trans[tth].Params[0]:= 65535; //(-1)
                        end;

                      end
                      else begin
                        AddMessage(Callback, True, ceUnkCom, Actor, a + 1, idst, idl);
                        Result:= False;
                      end;
                    end
                    else begin
                      AddMessage(Callback, True, ceExpCom, Actor, a + 1, idst, idl);
                      Result:= False;
                    end;

                  tePar1Num, tePar2Num:
                    if GetIdentType(Ident) = itNumber then begin
                      param:= IfThen(Expected = tePar1Num, 0, 1);
                      if TryStrToInt(Ident, val) then begin
                        if ValueInRange(val, CommandProps.ParRng[param]^) then begin
                          Trans[tth].Params[param]:= val;
                          if not TrackCheckSceneArrays(OpCode, val, Actor, a + 1,
                            idst, idl, AInfo, Scene, Callback)
                          then
                            Result:= False;
                          Ident:= '';
                          //If (Expected = tePar1Num) and (CommandProps.ParamCount > 1)
                          //then Expected:= tePar2Num
                          {else} Expected:= teNewLine; //Par2 is always dummy in Track Scripts
                          //However, we always have to put that param in the binary script
                          //If (CommandProps.ParamCount = 2)
                          //{and (cfPar2Dummy in CommandProps.Flags)} then //Always true
                          Inc(Offset, CommandProps.ParSize[param]);
                          //This section will never be executed for the second param,
                          //  because second param is always dummy (if exists), but
                          //  we still have to respect that param when calculating the offsets
                          if CommandProps.ParCount > 1 then begin
                            Inc(Offset, CommandProps.ParSize[1]);
                            //filling dummy params with default values
                            if Trans[tth].Code = tmWAIT_NUM_AN then
                              Trans[tth].Params[1]:= 0 //(0)
                            else if Trans[tth].Code = tmWAIT_NUM_SEC then
                              Trans[tth].Params[1]:= 0 //(0)
                            else if Trans[tth].Code = tmANGLE_RND then
                              Trans[tth].Params[1]:= 65535; //(-1)
                          end;
                          if Trans[tth].Code = tmLABEL then begin //remember all offsets of the LABELs
                            if High(LabelHashes) < val then SetLength(LabelHashes, val + 1);
                            if LabelHashes[val].Offset = 0 then begin
                              LabelHashes[val].Offset:= Trans[tth].Offset + 1; //all +1 because 0 is reserved for empty cell
                              LabelHashes[val].Line:= a + 1;
                              LabelHashes[val].LabelName:= '';
                              Expected:= teLabelNameDeclaration; //Feature for custom names
                            end
                            else if ScrSet.Comp.StrictSyntax then begin
                              AddMessage(Callback, True, ceDoubleLabel, Actor, a + 1, idst, idl);
                              Result:= False;
                            end;
                          end;
                        end
                        else begin
                          AddMessage(Callback, True, ceOutOfRange, Actor, a + 1, idst, idl);
                          Result:= False;
                        end;
                      end
                      else begin
                        AddMessage(Callback, True, ceInvalidNum, Actor, a + 1, idst, idl);
                        Result:= False;
                      end;
                    end
                    else begin
                      If Expected = tePar1Num then
                        AddMessage(Callback, True, ceExpFirstInt, Actor, a + 1, idst, idl)
                      else
                        AddMessage(Callback, True, ceExpSecInt, Actor, a + 1, idst, idl);
                      Result:= False;
                    end;

                  tePar1Text:
                    If IsProperFlaName(Ident) or (Trans[tth].Code = tmGOTO) then begin
                      Trans[tth].ParamStr:= Ident;
                      Ident:= '';
                      Expected:= teNewLine;
                      if Trans[tth].Code = tmGOTO then
                        Inc(Offset, CommandProps.ParSize[0]) //GOTO param size
                      else
                        Inc(Offset, Length(Ident) + 1); //regular text parameter
                    end
                    else begin
                      AddMessage(Callback, True, ceExpFlaName, Actor, a + 1, idst, idl);
                      Result:= False;
                    end;

                  teLabelNameDeclaration: //since it's not really a first parameter as text
                    begin
                      //notice this relies on that 'val' is a constant kept untouched after LABEL declartion
                      if IsReservedWord(Ident) then begin
                        AddMessage(Callback, True, ceReservedWord, Actor, a + 1, idst, idl);
                        Result:= False;
                      end
                      else if LabelNameIndex(LabelHashes, Ident) >= 0 then begin //If already exist
                        AddMessage(Callback, True, ceDoubleLabelName, Actor, a + 1, idst, idl);
                        Result:= False;
                      end
                      else begin
                        LabelHashes[val].LabelName:= Ident;
                        If Ident[1] in ['-','0'..'9', '.'] then begin
                          AddMessage(Callback, True, ceIllegalLabelName, Actor, a + 1, idst, 1);
                          Result:= False;
                        end;
                      end;
                      Ident:= '';
                      Expected:= teNewLine;
                    end;

                  teNewLine:
                    begin
                      AddMessage(Callback, True, ceExpNewLine, Actor, a + 1, idst, 0);
                      Result:= False;
                    end;

                end; //case
              end; //not commented line

            end; //idl > 0

            If ((Expected = teNewLine) or (Expected = teLabelNameDeclaration))
            and ((Line[b] in [#13, #10]) or (b = Length(Line))) then
              Expected:= teCommand;

          end; //end of line or { /

        end //valid char
        else begin
          AddMessage(Callback, True, ceInvalidChar, Actor, a + 1, b - 1, 1,
                     '0x' + IntToHex(Byte(Line[b]),2));
          Result:= False;
        end;

      end; //not CommentBlock

      If not Result then Break;

      If ((b = Length(Line)) or (Line[b] in [#13, #10]))
      and not (Expected in [teCommand, teNewLine]) then begin
        AddMessage(Callback, True, ceUnExEol, Actor, a + 1, b, 0);
        Result:= False;
        Break;
      end;

    end; //for each char loop

    If not Result then Break;

  end; //for each line loop

  {If Result then  This situation should have been caught earlier
    //We still have to check if all params were supplied
    If not (Expected in [teCommand, teNewLine]) then begin
      If Lines.Count > 0 then a:= Length(Lines.Strings[Lines.Count - 1])
                         else a:= 0;
      AddMessage(Msgs, True, mtError, ceUnExEol, Lines.Count, a, 0);
      Result:= False;
    end;}

  If Result then
    If CommentBlock then begin
      If Lines.Count > 0 then a:= Length(Lines.Strings[Lines.Count - 1])
                         else a:= 0;
      AddMessage(Callback, True, ceInfComment, Actor, Lines.Count, a, 0);
      Result:= False;
    end;

  //Check for END
  If Result then
    If (tth < 0) or (Trans[tth].Code <> tmEND) then
      If ScrSet.Comp.RequireENDs then begin
        If Lines.Count > 0 then a:= Length(Lines.Strings[Lines.Count - 1])
                           else a:= 0;
        AddMessage(Callback, True, ceExpEND, Actor, Lines.Count, a, 0);
        Result:= False;
      end
      else begin
        Inc(tth);
        SetLength(Trans, tth + 1);
        Trans[tth].Code:= tmEND;
        Trans[tth].Offset:= Offset;
      end;

  //Resolving LABEL identifiers (to get offsets for GOTO commands)
  If Result then begin
    for a:= 0 to tth do begin
      If Trans[a].Code = tmGOTO then begin
        If not TryStrToInt(Trans[a].paramstr, param) then begin
          b:= LabelNameIndex(LabelHashes, Trans[a].paramstr);
          If b < 0 then begin //Error for non-existent LABEL Name
            AddMessage(Callback, True, ceLabelNameNotDeclared, Actor, Trans[a].Line, pos('GOTO', UpperCase(Lines.Strings[a]))-1+5,Length(Trans[a].paramstr));
            Result:= False;
            break;
          end;
          param:= b;
        end;
        if param = -1 then //special case (-1)
          Trans[a].Params[0]:= -1
        else begin //regular params
          If (param <= High(LabelHashes)) and (LabelHashes[param].Offset > 0) then begin
            Trans[a].Params[0]:= LabelHashes[param].Offset - 1;
            LabelHashes[param].Used:= True;
          end
          else begin //there is no LABEL with given ID
            AddMessage(Callback, True, ceTrackNoLabel, Actor, Trans[a].Line, pos('GOTO', UpperCase(Lines.Strings[a]))-1+5,Length(Trans[a].paramstr));
            Result:= False;
            Break;
          end;
        end;
      end;
    end;
  end;

  Lines.Free();

  //Converting TrackScript Transition array into binary string
  if Result then begin

    //BinaryScript:= '';  this is done at the beginning
    for a:= 0 to tth do begin
      BinaryScript:= BinaryScript + Char(Trans[a].Code);
      CommandProps:= TrackProps[Trans[a].Code];
      if CommandProps.ParCount = -1 then //Text param (FLA name)
        BinaryScript:= BinaryScript + Trans[a].ParamStr + #0
      else //Numeric param(s)
        for b:= 0 to CommandProps.ParCount - 1 do
          BinaryScript:= BinaryScript
            + ValToBinStr(CommandProps.ParSize[b], Trans[a].Params[b]);
    end;

    //Add END if not present in the text script
    //If Trans[tth].Code <> 0 then
    //  BinaryScript:= BinaryScript + #0;

  end;
end;

//==============================================================================
// LIFE SCRIPT
//==============================================================================

//Checking if 3D/Sprite specific commans are used for the right Actor type
function LifeCheckSceneComIdent(OpCode: Byte; Actor, Line, PStart,
  Len: Integer; Scene: TScene; Callback: TCompCallbackProc): Boolean;
begin
 Result:= True;
 if OpCode in Life3DCmds then  //checking if the Actor is not a Sprite
   CheckActorSprite(False, Actor, Actor, Line, PStart, Len, Scene, True, Callback)
 else if OpCode in LifeSpriteCmds then //checking if the Actor is a Sprite
   CheckActorSprite(False, Actor, Actor, Line, PStart, Len, Scene, False, Callback);
end;

//Checking first parameters of commands, if they reference valid objects
//Returns True if everything is okay
Function LifeCheckSceneComParam1(OpCode: Byte; Value, Actor, Line, PStart,
  Len: Integer; AInfo: array of TEntity; Scene: TScene;
  Callback: TCompCallbackProc): Boolean;
begin
 Result:= True;
 //Checking if target Actor is not a Sprite
 if OpCode in Life3DPar1Cmds then
   CheckActorSprite(False, Actor, Value, Line, PStart, Len, Scene, True, Callback);

 //Separated because the above commands must be checked twice
 if OpCode in LifeActorRefCmds then //Checking if target Actor exists
   Result:= CheckActorId(Actor, Value, Line, PStart, Len, Scene, Callback)
 else if OpCode in [lmBODY, lmANIM, lmANIM_SET] then  //checking Body and Anim virtual indexes
   Result:= CheckActorBodyOrAnim(False, Actor, Actor, Value, Line, PStart, Len,
              AInfo, Scene, OpCode = lmBODY, Callback)
 else if OPCode in LifePointRefCmds then //checking Track IDs
   Result:= CheckTrackId(False, Actor, Value, Line, PStart, Len, Scene, Callback);

   //TODO:
   //lsSET_HOLO_POS, lsCLR_HOLO_POS, lsPLAY_FLA, lsPLAY_MIDI
   //lsSET_GRM, lsGRM_OFF, lsHOLOMAP_TRAJ, lsCHANGE_CUBE
   //texts:
   //lsMESSAGE, lsMESSAGE_OBJ, lsADD_CHOICE, lsASK_CHOICE, lsASK_CHOICE_OBJ,
   //lsBIG_MESSAGE, lsSAY_MESSAGE, lsSAY_MESSAGE_OBJ, lsTEXT
end;

//Checking commands by their second parameter (first param must be supplied also)
Function LifeCheckSceneComParam2(OpCode: Byte; Value1, Value2, Actor, Line, PStart,
  Len: Integer; AInfo: array of TEntity; Scene: TScene;
  Callback: TCompCallbackProc): Boolean;
begin
 Result:= True;
 if OpCode in [lmBODY_OBJ, lmANIM_OBJ] then //Checking Bodies and Anims
   Result:= CheckActorBodyOrAnim(False, Actor, Value1, Value2, Line, PStart, Len,
              AInfo, Scene, OpCode = lmBODY_OBJ, Callback);
end;

//Checking if 3D specific vars are used for a 3D Actor, and other
function LifeCheckSceneVarIdent(OpCode: Byte; Actor, Line, PStart,
  Len: Integer; Scene: TScene; Callback: TCompCallbackProc): Boolean;
begin
 Result:= True;
 if OpCode in Life3DVars then //checking if the Actor is not a Sprite
   CheckActorSprite(False, Actor, Actor, Line, PStart, Len, Scene, True, Callback)
 else if OpCode = lvZONE then //checking if the Actor can detect Zones
   CheckActorZonable(False, Actor, Actor, Line, PStart, Len, Scene, Callback);
end;

//Checking variables by their first parameter
Function LifeCheckSceneVarParam(OpCode: Byte; Value, Actor, Line, PStart,
  Len: Integer; AInfo: array of TEntity; Scene: TScene;
  Callback: TCompCallbackProc): Boolean;
begin
 Result:= True;
 //Checking if target Actor is not a Sprite
 if OpCode in [lvBODY_OBJ, lvANIM_OBJ] then
   CheckActorSprite(False, Actor, Value, Line, PStart, Len, Scene, True, Callback);

 //Checking if target Actor can detect Zones
 if OpCode = lvZONE_OBJ then
   CheckActorZonable(False, Actor, Value, Line, PStart, Len, Scene, Callback);

 //Separated because the above commands must be checked twice
 if OpCode in LifeActorRefVars then //Checking if target Actor exists
   Result:= CheckActorId(Actor, Value, Line, PStart, Len, Scene, Callback);
end;

//Checking variables by their results (param must be supplied also if present)
Function LifeCheckSceneVarResult(OpCode: Byte; Param, Res, Actor, Line, PStart,
  Len: Integer; AInfo: array of TEntity; Scene: TScene;
  Callback: TCompCallbackProc): Boolean;
begin
 Result:= True;
 if OpCode in [lvBODY, lvANIM] then //Checking Body and Anim virtual indexes
   Result:= CheckActorBodyOrAnim(False, Actor, Actor, Res, Line, PStart, Len,
              AInfo, Scene, OpCode = lvBODY, Callback)
 else if OpCode in [lvBODY_OBJ, lvANIM_OBJ] then
   Result:= CheckActorBodyOrAnim(False, Actor, Param, Res, Line, PStart, Len,
              AInfo, Scene, OpCode = lvBODY_OBJ, Callback)
 else if OpCode in LifeActorTVars then //Checking Actor ID
   Result:= CheckActorId(Actor, Res, Line, PStart, Len, Scene, Callback)
 else if OpCode in [lvZONE, lvZONE_OBJ] then //Checking Zone virtual index
   CheckZoneId(Actor, Res, Line, PStart, Len, Scene, Callback);

   //TODO:
   //lscCHOICE
end;




//This function also does basic offsets resolving (offsets of IF/ELSE/ENDIF commands)
//More advanced offsets resolving (that requires info about Track Scripts and other
//  Actors' Scripts) goes to the next function.
Function LifeCompToTransTable(TextScript: String; Actor: Integer;
  var LabelHashes: array of TLbHashTable; var CompList: TCompList; var Trans: TTransTable;
  Callback: TCompCallbackProc; AInfo: array of TEntity; Scene: TScene): Boolean;
var a, b, c, d, Offset, val, param, lth, clh: Integer;
    ish, osh, idst, idl, slh, och: Integer;
    OpCode, LastCommand: Byte;
    Lines: TStringList;
    CommandProps: TCommandProp;
    CmdParRng0: TRange;
    Line, Ident: String;
    Expected: TLifeExpected;
    EndWarn, CommentBlock: Boolean;
    SwitchVar: TVariableProp; //only one, even for nested SWITCH
    IFStack: array of Word; //For IF-ELSE-ENDIF offset resolving
    ORIFStack: array of Word; //For OR_IF offset resolving
    SwLevel: array of TSwLevelFrame; //For BREAK offset resolving (SWITCH may be multilevel!)
    ORCASEList: array of Word; //For OR_CASE offset resolving
begin
  Lines:= TStringList.Create;
  Lines.Text:= TextScript; //It is easier to manage in this form
  lth:= -1;
  SetLength(Trans, 0);
  clh:= -1;
  SetLength(CompList, 0);
  ish:= -1;
  SetLength(IFStack, 0);
  osh:= -1;
  SetLength(ORIFStack, 0);
  slh:= -1; //Switch levels (high)
  SetLength(SwLevel, 0);
  och:= -1;
  SetLength(ORCASEList, 0);

  Result:= True;

  Offset:= 0;
  EndWarn:= False; //If code after END warning has been posted already
  LastCommand:= 254; //-2 (255 is reserved for unused commands (like AND_IF in LBA1)
  CommentBlock:= False;

  //Compiling script into the transitional variable
  Expected:= leCommand;
  for a:= 0 to Lines.Count - 1 do begin

    Line:= Lines.Strings[a]; //LowerCase(Lines.Strings[a]);

    for b:= 1 to Length(Line) do begin

      if CommentBlock then begin
        If Line[b] = '}' then CommentBlock:= False;
        If (Expected = leNewLine)
        and ((b = Length(Line)) or (Line[b] in [#13, #10])) then
          Expected:= leCommand;
      end
      else begin

        if Line[b] in ['_', '-', '0'..'9', 'a'..'z', 'A'..'Z', ' ', #13, #10, #09, '.',
                       '=', '!', '<', '>', '/', '{'] then begin

          if Line[b] = '{' then CommentBlock:= True
          else if (Line[b] = '/') and (b > 1) and (Line[b-1] = '/') then begin
            Ident:= '';
            If Expected = leNewLine then Expected:= leCommand
            else if Expected <> leCommand then begin
              AddMessage(Callback, True, ceUnExEol, Actor, a + 1, Length(Line), 0);
              Result:= False;
            end;
            Break;
          end;

          if Line[b] in ['_', '-', '0'..'9', 'a'..'z', 'A'..'Z', '.',
                         '=', '!', '<', '>']
          then
            Ident:= Ident + Line[b];

          if (b = Length(Line)) or (Line[b] in [' ', #13, #10, #09, '{', '/']) then begin
            idl:= Length(Ident);
            idst:= b - idl - 1;
            if idl > 0 then begin
              if SameText(Ident, 'rem') then begin //Start of commented line
                Ident:= '';
                CommentBlock:= False; //useful when comment block starts right after REM
                if Expected = leNewLine then Expected:= leCommand
                else if Expected <> leCommand then begin
                  AddMessage(Callback, True, ceUnExEol, Actor, a + 1, Length(Line), 0);
                  Result:= False;
                end;
                Break;
              end
              else begin

                case Expected of
                  leCommand: //============ COMMAND =============
                    if GetIdentType(Ident) = itText then begin
                      OpCode:= GetIdentifierId(Ident, LifeList);
                      if OpCode < 255 then begin
                        CommandProps:= LifeProps[OpCode];

                        //Perform some advanced syntax checking:
                        if lth < 0 then begin //if first command
                          if not (OpCode in [lmCOMP, lmEND])
                          and ScrSet.Comp.StrictSyntax
                          then begin
                            AddMessage(Callback, False, ceExpEndOrComp, Actor, a + 1, idst, idl);
                            Result:= False;
                          end;
                        end
                        else begin //if not the first command
                          if OpCode in [lmCOMP, lmEND] then begin
                            if ScrSet.Comp.StrictSyntax {or (OpCode = lmEND)} then begin
                              if Trans[lth].Code <> lmEND_COMP then begin //previous wasn't END_COMPORTMENT
                                AddMessage(Callback, False, ceExpEndComp, Actor, a + 1, idst, idl);
                                Result:= False;
                              end;
                            end;
                          end
                          else if OpCode = lmEND_COMP then begin
                            if ScrSet.Comp.StrictSyntax then begin
                              if ish >= 0 then begin //there are some unclosed IF blocks
                                AddMessage(Callback, False, ceUnIfBlock, Actor, a + 1, idst, idl);
                                Result:= False;
                              end;
                            end;
                          end
                          else begin
                            if ScrSet.Comp.StrictSyntax then begin
                              if (LastCommand = lmOR_IF) //not all cmds allowed after OR_IF
                              and not (OpCode in LifeAfterOrIf) then begin
                                AddMessage(Callback, False, ceExpORIF, Actor, a + 1, idst, idl);
                                Result:= False;
                              end
                              else if (Trans[lth].Code = lmEND_COMP) //last was END_COMPORTMENT
                              and not (OpCode in [lmCOMP, lmEND]) then begin //and next is other than COMP or END
                                AddMessage(Callback, False, ceExpEndOrComp, Actor, a + 1, idst, idl);
                                Result:= False;
                              end;
                            end;  
                          end;
                        end;
                        if not Result then Break;

                        //Syntax OK, so let's go on
                        Inc(lth);
                        SetLength(Trans, lth + 1);
                        Trans[lth].Code:= OpCode;
                        Trans[lth].ParCount:= CommandProps.ParCount;
                        Move(CommandProps.ParSize[0], Trans[lth].ParSize[0], SizeOf(Trans[lth].ParSize));
                        Trans[lth].Flags:= CommandProps.Flags;
                        Trans[lth].cType:= CommandProps.cType;
                        Trans[lth].Offset:= Offset;
                        Trans[lth].Line:= a + 1;
                        if not LifeCheckSceneComIdent(OpCode, Actor, a + 1,
                          idst, idl, Scene, Callback)
                        then
                          Result:= False;
                        Ident:= '';
                        if CommandProps.cType <> ctVirtual then Inc(Offset);
                        LastCommand:= OpCode;
                        if not EndWarn and (lth > 0) and (Trans[lth-1].cType = ctCommand)
                        and (Trans[lth-1].Code = lmEND) then begin
                          EndWarn:= True;
                          AddMessage(Callback, False, cwCodeAfterEnd, Actor, a + 1, idst, idl)
                        end;

                        //IF-ELSE-ENDIF address resolving
                        //first catch a BREAK that is for IF-ELSE-ENDIF, not for SWITCH-CASE
                        if (OpCode in [lmELSE, lmENDIF])
                        and not ScrSet.Comp.StrictSyntax
                        and (slh >= 0) and (SwLevel[slh].lh >= 0)
                        and (ish >= 0) then begin
                          c:= SwLevel[slh].BREAKs[SwLevel[slh].lh];
                          if (c > IFStack[ish]) //last BREAK is inside IF-ELSE-ENDIF
                          and (SwLevel[slh].LastCASE < IFStack[ish]) //and last CASE is outside
                          then begin //=> that BREAK must point to (current) ELSE or ENDIF
                            Trans[c].Params[0]:= Offset;
                            Dec(SwLevel[slh].lh); //and remove it from the list
                            SwLevel[slh].LastBREAK:= -1; //avoid wrong grouped CASE detection
                          end;
                        end;
                        if OpCode = lmELSE then begin
                          if ish >= 0 then begin
                            Inc(Offset, 2); //The hidden address
                            d:= IFStack[ish];
                            if Trans[d].cType = ctOperator then //IF-type
                              Trans[d].Params[1]:= Offset //update the corresponding IF line address
                            else begin //ELSE
                              if not ScrSet.Comp.StrictSyntax then
                                Trans[d].Params[0]:= Offset //double ELSE
                              else begin
                                AddMessage(Callback, False, ceDoubleELSE, Actor, a + 1, idst, idl);
                                Result:= False;
                              end;
                            end;
                            IFStack[ish]:= lth; //store this ELSE position instead
                            //check for orphaned OR_IFs
                            if not ScrSet.Comp.StrictSyntax then begin
                              while (osh >= 0) and (ORIFStack[osh] > d) do begin
                                Trans[ORIFStack[osh]].Params[1]:= Offset; //Orphaned OR_IFs point to the nearest ELSE
                                Dec(osh);
                              end;
                            end;
                            //update and remove AND_IF references for this block
                            c:= ish;
                            while (c > 0) 
                            and (ofForAndif in Trans[IFStack[c-1]].Flags) do
                              Dec(c);
                            if c < ish then begin //found AND_IF frame(s)
                              for d:= c to ish - 1 do //update
                                Trans[IFStack[d]].Params[1]:= Offset;
                              IFStack[c]:= IFStack[ish]; //move ELSE from the end
                              ish:= c; //forget the rest
                            end;
                          end
                          else begin
                            AddMessage(Callback, False, ceElseNoIf, Actor, a + 1, idst, idl);
                            Result:= False;
                          end;
                        end
                        else if OpCode = lmENDIF then begin
                          if ish >= 0 then begin
                            //check for orphaned OR_IFs
                            if not ScrSet.Comp.StrictSyntax then begin
                              d:= IFStack[ish];
                              while (osh >= 0) and (ORIFStack[osh] > d) do begin
                                Trans[ORIFStack[osh]].Params[1]:= Offset; //Orphaned OR_IFs point to the nearest ENDIF
                                Dec(osh);
                              end;
                            end;
                            if Trans[IFStack[ish]].cType = ctOperator then begin //IF frame
                              Trans[IFStack[ish]].Params[1]:= Offset; //update the corresponding IF line address
                              //also update AND_IF references for this block
                              c:= ish;
                              while (c > 0) 
                              and (ofForAndif in Trans[IFStack[c-1]].Flags) do
                                Dec(c);
                              if c < ish then//found AND_IF frame(s)
                                for d:= c to ish - 1 do //update
                                  Trans[IFStack[d]].Params[1]:= Offset;
                              ish:= c - 1; //forget the rest (along with the current IF frame)
                            end else begin //ELSE frame
                              Trans[IFStack[ish]].Params[0]:= Offset; //update the corresponding ELSE address
                              Dec(ish); //pop the info from the stack
                            end;
                          end
                          else begin
                            AddMessage(Callback, False, ceEndifNoIf, Actor, a + 1, idst, idl);
                            Result:= False;
                          end;
                        end;

                        //SWITCH-CASE resolving
                        if (slh >= 0)
                        and ((SwLevel[slh].LastBREAK >= 0) or (OpCode = lmEND_SWITCH))
                        then begin
                          if OpCode in [lmCASE, lmOR_CASE, lmDEFAULT] then
                            SwLevel[slh].LastBREAK:= -1
                          else begin
                            //other command after BREAK means there is no END_SWITCH,
                            //so we must treat this cmd like END_SWITCH
                            //This will also work if the command IS END_SWITCH
                            //Will also work for CASE grouping
                            d:= SwLevel[slh].LastBREAK;
                            for c:= 0 to SwLevel[slh].lh do begin
                              if SameText(Trans[SwLevel[slh].BREAKs[c]].ParamStr, 'mod') then begin
                                if d >= 0 then
                                  Trans[SwLevel[slh].BREAKs[c]].Params[0]:= Trans[d].Offset //set modified BREAK's address to the last BREAK
                                else begin
                                  AddMessage(Callback, False, ceExpESwBrkMod, Actor, a + 1, idst, idl);
                                  Result:= False;
                                end;
                              end else
                                Trans[SwLevel[slh].BREAKs[c]].Params[0]:= //update the BREAK's target address
                                  Offset - IfThen(CommandProps.cType <> ctVirtual, 1);
                            end;
                            SwLevel[slh].lh:= -1;
                            //This applies for the last CASE too
                            if SwLevel[slh].LastCASE >= 0 then
                              Trans[SwLevel[slh].LastCASE].Params[0]:=
                                Offset - IfThen(CommandProps.cType <> ctVirtual, 1);
                            SwLevel[slh].LastCASE:= -1;

                            if (OpCode = lmEND_SWITCH)
                            and SwLevel[slh].Pseudolevel then begin
                              //pseudo-level cannot end with END_SWITCH
                              //The BREAK distribution is ambiguous (by an accident perhaps)
                              c:= SwLevel[slh].FirstCASE; //get the level's first CASE
                              Dec(slh); //destroy the level
                              if (SwLevel[slh].LastCASE >= 0) and (c >= 0) then
                                Trans[SwLevel[slh].LastCASE].Params[0]:= Trans[c].Offset; //absorb the sub-level as part of the current level
                              //Unfortunately, we have to end the higher level here too
                              for c:= 0 to SwLevel[slh].lh do begin
                                if SameText(Trans[SwLevel[slh].BREAKs[c]].ParamStr, 'mod') then begin
                                  if d >= 0 then
                                    Trans[SwLevel[slh].BREAKs[c]].Params[0]:= Trans[d].Offset //set modified BREAK's address to the last BREAK
                                  else begin
                                    AddMessage(Callback, False, ceExpESwBrkMod, Actor, a + 1, idst, idl);
                                    Result:= False;
                                  end;
                                end else
                                  Trans[SwLevel[slh].BREAKs[c]].Params[0]:= Offset - 1;
                              end;
                              //We don't have to update the last CASE, because it has been treated as the pseudo-level member, and already updated
                            end;
                            
                            //take one level off
                            Dec(slh);
                          end;
                        end;
                        if OpCode = lmSWITCH then begin
                          Inc(slh);
                          SetLength(SwLevel, slh + 1);
                          SwLevel[slh].PseudoLevel:= False;
                          SwLevel[slh].IFFrame:= -1; //-1 indicates that the target address must be DEFAULT or ENDIF
                          SwLevel[slh].lh:= -1; //high of the BREAK list
                          SwLevel[slh].LastCASE:= -1;
                          SwLevel[slh].FirstCASE:= -1;
                          SwLevel[slh].LastBREAK:= -1;
                        end
                        else if OpCode in [lmCASE, lmOR_CASE] then begin
                          //First check for sub-CASE
                          if (lth > 1)
                          and (Trans[lth-1].cType <> ctVariable) //CASE after SWITCH
                          and ((Trans[lth-1].cType <> ctOperator) //CASE ofter OR_CASE
                            or (Trans[lth-2].Code <> lmOR_CASE))
                          and ((Trans[lth-1].cType <> ctCommand) //CASE after BREAK
                            or (Trans[lth-1].Code <> lmBREAK))
                          then begin
                            Inc(slh); //treat it like a nested SWITCH with the same Var; it will end at the double BREAK
                            SetLength(SwLevel, slh + 1); //This section should also handle grouped CASEs
                            SwLevel[slh].PseudoLevel:= True;
                            SwLevel[slh].IFFrame:= -1;
                            SwLevel[slh].lh:= -1;
                            SwLevel[slh].LastCASE:= -1;
                            SwLevel[slh].FirstCASE:= -1;
                            SwLevel[slh].LastBREAK:= -1;
                          end;
                          //Normal CASE processing:
                          Inc(Offset, 2); //for the hidden address field
                          if slh < 0 then begin
                            AddMessage(Callback, False, ceCaseNoSwitch, Actor, a + 1, idst, idl);
                            Result:= False;
                          end else begin
                            if SwLevel[slh].LastCASE >= 0 then //each CASE must point to the next (OR_)CASE (first of group)
                              Trans[SwLevel[slh].LastCASE].Params[0]:= Offset - 3;
                            SwLevel[slh].LastCASE:= -1;
                            if SwLevel[slh].FirstCASE < 0 then
                              SwLevel[slh].FirstCASE:= lth; //CASE or OR_CASE
                          end;
                          if OpCode = lmOR_CASE then begin
                            Inc(och);
                            if High(ORCASEList) < och then SetLength(ORCASEList, och + 1);
                            ORCASEList[och]:= lth;
                          end else begin //CASE
                            if Result then //SwLevel validity has been already checked
                              SwLevel[slh].LastCASE:= lth;
                          end;
                        end
                        else if OpCode = lmBREAK then begin
                          Inc(Offset, 2); //for the hidden address field
                          if slh < 0 then begin
                            AddMessage(Callback, False, ceBreakNoSwitch, Actor, a + 1, idst, idl);
                            Result:= False;
                          end else begin
                            Inc(SwLevel[slh].lh);
                            SetLength(SwLevel[slh].BREAKs, SwLevel[slh].lh + 1);
                            SwLevel[slh].BREAKs[SwLevel[slh].lh]:= lth; //record the position to update the address later
                            SwLevel[slh].LastBREAK:= lth;
                          end;
                        end
                        else if OpCode = lmDEFAULT then begin
                          if slh < 0 then begin
                            AddMessage(Callback, False, ceDefltNoSwitch, Actor, a + 1, idst, idl);
                            Result:= False;
                          end else begin
                            if SwLevel[slh].LastCASE >= 0 then //last CASE must point to DEFAULT (if present)
                              Trans[SwLevel[slh].LastCASE].Params[0]:= Offset - 1;
                            SwLevel[slh].LastCASE:= -1;
                          end;
                        end;

                        case CommandProps.cType of
                          ctCommand: if CommandProps.ParCount = -1 then Expected:= lePar1Text
                                     else if CommandProps.ParCount > 0 then begin
                                            if OpCode = lmSET_BEHAV then Expected:= leBehaviour
                                       else if OpCode = lmSET_DIRM  then Expected:= leDirMode
                                       else if OpCode = lmELSE then Expected:= leNewLine
                                       else if OpCode = lmBREAK then begin
                                         if ScrSet.Comp.StrictSyntax then Expected:= leNewLine
                                         else Expected:= leBreakMod;
                                       end
                                       else if OpCode = lmSET_COMP  then Expected:= lePar1Text
                                       else if OpCode = lmSET_GRM   then Expected:= leFragmentId1
                                       else if OpCode in [lmCASE, lmOR_CASE] then Expected:= leCaseOper
                                       else Expected:= lePar1Num;
                                     end else
                                       Expected:= leNewLine;
                          ctIf:      if OpCode = lmSWITCH then Expected:= leSwVar
                                     else Expected:= leVariable;
                          ctVirtual: if OpCode = lmCOMP then Expected:= lePar1Text
                                     else if CommandProps.ParCount > 0 then Expected:= lePar1Num
                                     else Expected:= leNewLine;
                          else begin
                            AddMessage(Callback, False, ceInt11BadType, Actor, a + 1, idst, idl);
                            Result:= False;
                          end;
                        end;
                      end
                      else begin
                        AddMessage(Callback, False, ceUnkCom, Actor, a + 1, idst, idl);
                        Result:= False;
                      end;
                    end
                    else begin
                      AddMessage(Callback, False, ceExpCom, Actor, a + 1, idst, idl);
                      Result:= False;
                    end;

                  //============ INTEGER PARAM =============
                  lePar1Num, lePar2Num, lePar3Num, lePar4Num: 
                  begin
                    //Convert known constants or LABEL Names
                    if (GetIdentType(Ident) = itText)
                    and ((Trans[lth].Code = lmSET_TRACK) or (Trans[lth-1].Code = lvCUR_TRACK))
                    and (LabelNameIndex(LabelHashes[Actor], Ident) >= 0) then
                      Ident:= inttostr(LabelNameIndex(LabelHashes[Actor], Ident));

                    if ((Trans[lth-1].code = lvCUR_TRACK_OBJ) and (Trans[lth-1].Params[0] < length(LabelHashes)))
                    or ((Trans[lth].code = lmSET_TRACK_OBJ) and (Trans[lth].Params[0] < length(LabelHashes))) then begin
                      if (GetIdentType(Ident) = itText) and (Trans[lth-1].Code = lvCUR_TRACK_OBJ)
                      and (LabelNameIndex(LabelHashes[Trans[lth-1].Params[0]], Ident) >= 0) then
                         Ident:= inttostr(LabelNameIndex(LabelHashes[Trans[lth-1].Params[0]], Ident))
                      else if (Expected = lePar2Num)
                      and (GetIdentType(Ident) = itText) and (Trans[lth].Code = lmSET_TRACK_OBJ)
                      and (LabelNameIndex(LabelHashes[Trans[lth].Params[0]], Ident) >= 0) then
                        Ident:= inttostr(LabelNameIndex(LabelHashes[Trans[lth].Params[0]], Ident))
                    end
                    else begin
                      if (Trans[lth-1].Code = lvCUR_TRACK_OBJ) then begin
                        AddMessage(Callback, False, ceLifeNoActor, Actor, a + 1, 0, 0);
                        Result:= False; //should only happen if referenc to a nonexistent actor
                      end; //invalid SET_TRACK_OBJ get taken care of later
                    end;

                    if SameText(Ident, 'SELF') then begin
                      if (Expected = lePar1Num) and
                         ((Trans[lth].cType = ctCommand) and (Trans[lth].Code in LifeActorRefCmds))
                      or ((Trans[lth].cType = ctVariable) and (Trans[lth].Code in LifeActorRefVars))
                      or ((Trans[lth].cType = ctOperator) and (Trans[lth-1].Code in LifeActorTVars))
                      then
                        Ident:= IntToStr(Actor)
                      else begin
                        AddMessage(Callback, False, ceSelfNotAllowed, Actor, a + 1, idst, 0);
                        Result:= False;
                      end;
                    end;

                    //By now any Constant in Ident have been converted to its number

                    if GetIdentType(Ident) = itNumber then begin
                      param:= Byte(Expected) - Byte(lePar1Num);
                      if TryStrToInt(Ident, val) then begin
                        if (Trans[lth].Code in [lmSET_DIRM, lmSET_DIRM_OBJ])
                        and (Expected = lePar2Num) then begin //optional param after the mode (Actor to follow)
                          if (val >= 0) and (val <= 255) then begin
                            if Trans[lth].Code = lmSET_DIRM then
                              Trans[lth].Params[1]:= val
                            else
                              Trans[lth].Params[2]:= val; //SET_DIRMODE_OBJ
                            Ident:= '';
                            Expected:= leNewLine;
                            Inc(Offset); //always 1 byte
                          end
                          else begin
                            AddMessage(Callback, False, ceOutOfRange, Actor, a + 1, idst, idl);
                            Result:= False;
                          end;
                        end
                        else if ValueInRange(val, CommandProps.ParRng[param]^) then begin
                          Trans[lth].Params[param]:= val;
                          if Trans[lth].cType = ctCommand then begin
                            if Expected = lePar1Num then begin
                              if not LifeCheckSceneComParam1(OpCode, val, Actor,
                                a + 1, idst, idl, AInfo, Scene, Callback)
                              then
                                Result:= False;
                            end
                            else if Expected = lePar2Num then begin
                              if not LifeCheckSceneComParam2(OpCode,
                                Trans[lth].Params[0], val, Actor, a + 1, idst, idl,
                                AInfo, Scene, Callback)
                              then
                                Result:= False;
                            end;
                          end
                          else if Expected = lePar1Num then begin
                            if Trans[lth].cType in [ctVariable, ctSwVar] then begin
                              if not LifeCheckSceneVarParam(OpCode, val, Actor,
                                a + 1, idst, idl, AInfo, Scene, Callback)
                              then
                                Result:= False;
                            end
                            else if (Trans[lth].cType = ctOperator)
                            and (OpCode = loEQUAL) then begin //test only equal values
                              if not LifeCheckSceneVarResult(Trans[lth-1].Code,
                                Trans[lth-1].Params[0], val, Actor, a + 1, idst, idl,
                                AInfo, Scene, Callback)
                              then
                                Result:= False;
                            end;
                          end;
                          Ident:= '';

                          if Expected = lePar1Num then begin
                            if CommandProps.cType = ctVariable then Expected:= leOperator
                            else if CommandProps.cType in [ctSwVar, ctOperator] then Expected:= leNewLine
                            else if CommandProps.ParCount > 1 then begin
                              if Trans[lth].Code = lmSET_DIRM_OBJ then Expected:= leDirMode
                              else if Trans[lth].Code = lmSET_COMP_OBJ then Expected:= lePar1Text
                              else Expected:= lePar2Num;
                            end else
                              Expected:= leNewLine;
                          end
                          else if Expected = lePar2Num then begin
                            if CommandProps.ParCount > 2 then
                              Expected:= lePar3Num
                            else
                              Expected:= leNewLine;
                          end
                          else if Expected = lePar3Num then begin
                            if CommandProps.ParCount > 3 then
                              Expected:= lePar4Num
                            else
                              Expected:= leNewLine;
                          end else
                            Expected:= leNewLine;

                          Inc(Offset, CommandProps.ParSize[param]);
                        end
                        else begin
                          AddMessage(Callback, False, ceOutOfRange, Actor, a + 1, idst, idl);
                          Result:= False;
                        end;
                      end
                      else begin
                      AddMessage(Callback, False, ceInvalidNum, Actor, a + 1, idst, idl);
                      Result:= False;
                      end;
                    end
                    else begin //If Ident is not a number (it means that an error occured)
                      if ((Trans[lth].Code = lmSET_TRACK) or (Trans[lth-1].Code = lvCUR_TRACK)) then
                        AddMessage(Callback, False, ceInvalidNumOrNoLABEL, Actor, a + 1, idst, idl)
                      else if (Trans[lth].Code = lmSET_TRACK_OBJ) and (Expected = lePar1Num) then
                        AddMessage(Callback, False, ceExpFirstInt, Actor, a + 1, idst, idl)
                      else If ((Trans[lth].Code = lmSET_TRACK_OBJ) or (Trans[lth-1].Code = lvCUR_TRACK_OBJ)) then
                        AddMessage(Callback, False, ceUndefinedLabel, Actor, a + 1, idst, idl)
                      else If Expected = lePar1Num then
                        AddMessage(Callback, False, ceExpFirstInt, Actor, a + 1, idst, idl)
                      else
                        AddMessage(Callback, False, ceExpSecInt, Actor, a + 1, idst, idl);
                      Result:= False;
                    end;
                  end;

                  lePar1Text: //============ TEXT PARAM =============
                    if Trans[lth].Code = lmCOMP then begin
                      if IsProperCompName(Ident) then begin
                        if IsReservedWord(Ident) then begin //this name is reserved
                          AddMessage(Callback, False, ceReservedWord, Actor, a + 1, idst, idl);
                          Result:= False;
                        end;
                        for c:= 0 to clh do
                          if SameText(CompList[c].Name, Ident) then begin
                            AddMessage(Callback, False, ceDoubleComp, Actor, a + 1, idst, idl);
                            Result:= False;
                            Break;
                          end;
                        if Result then begin
                          Trans[lth].ParamStr:= Ident;
                          //Won't increment Offset because it's a virtual command
                          Inc(clh);
                          //If clh < Offset then begin
                          //  clh:= Offset;
                          //  SetLength(CompList, clh + 1);
                          //end;
                          SetLength(CompList, clh + 1);
                          CompList[clh].Name:= LowerCase(Ident);
                          CompList[clh].Offset:= Offset;
                          CompList[clh].Line:= a + 1;
                          Ident:= '';
                          Expected:= leNewLine;
                        end;
                      end
                      else begin
                        AddMessage(Callback, False, ceInvCompName, Actor, a + 1, idst, idl);
                        Result:= False;
                      end;
                    end
                    else if Trans[lth].Code in [lmSET_COMP, lmSET_COMP_OBJ] then begin
                      if IsProperCompName(Ident) then begin
                        Trans[lth].ParamStr:= Ident;
                        Ident:= '';
                        Expected:= leNewLine;
                        Inc(Offset, 2);
                      end
                      else begin
                        AddMessage(Callback, False, ceInvCompName, Actor, a + 1, idst, idl);
                        Result:= False;
                      end;
                    end
                    else begin //PLAY_FLA
                      If IsProperFlaName(Ident) then begin
                        Trans[lth].ParamStr:= Ident;
                        Expected:= leNewLine;
                        Inc(Offset, Length(Ident) + 1);
                        Ident:= '';
                      end
                      else begin
                        AddMessage(Callback, False, ceExpFlaName, Actor, a + 1, idst, idl);
                        Result:= False;
                      end;
                    end;

                  leVariable, leSwVar: //============ CONDITION =============
                    if GetIdentType(Ident) = itText then begin
                      OpCode:= GetIdentifierId(Ident, VarList);
                      if OpCode < 255 then begin
                        //Not very clean here, but I had to do it this way to work
                        //  properly with conditions.
                        //TODO: rewrite this part so that no such workarounds are necessary
                        CommandProps.ParCount:= IfThen(VarProps[OpCode].HasParam, 1, 0);
                        CommandProps.ParSize[0]:= 1; //won't matter if no param
                        CommandProps.ParSize[1]:= VarProps[OpCode].RetSize;
                        if Expected = leVariable then
                          CommandProps.cType:= ctVariable
                        else
                          CommandProps.cType:= ctSwVar;  
                        CommandProps.Flags:= [];
                        CommandProps.ParRng[0]:= @CmdParRng0;
                        CommandProps.ParRng[0]^.Min:= 0;
                        CommandProps.ParRng[0]^.Max:= 255;
                        CommandProps.ParRng[1]:= VarProps[OpCode].RetRange;
                        if Expected = leSwVar then      //for each lower level SWITCH decalaration
                          SwitchVar:= VarProps[OpCode]; //further higher levels inherit the last value
                        Inc(lth);
                        SetLength(Trans, lth + 1);
                        Trans[lth].Code:= OpCode;
                        Trans[lth].ParCount:= CommandProps.ParCount;
                        Move(CommandProps.ParSize[0], Trans[lth].ParSize[0], SizeOf(Trans[lth].ParSize));
                        Trans[lth].Flags:= [];
                        Trans[lth].cType:= CommandProps.cType;
                        Trans[lth].Offset:= Offset;
                        Trans[lth].Line:= a + 1;
                        if not LifeCheckSceneVarIdent(OpCode, Actor, a + 1,
                          idst, idl, Scene, Callback)
                        then
                          Result:= False;  
                        Ident:= '';
                        Inc(Offset);
                        if CommandProps.ParCount > 0 then Expected:= lePar1Num
                        else begin
                          if Expected = leVariable then
                            Expected:= leOperator
                          else //SwVar
                            Expected:= leNewLine;
                        end;
                      end
                      else begin
                        AddMessage(Callback, False, ceUnkVar, Actor, a + 1, idst, idl);
                        Result:= False;
                      end;
                    end
                    else begin
                      AddMessage(Callback, False, ceExpVar, Actor, a + 1, idst, idl);
                      Result:= False;
                    end;

                  leOperator, leCaseOper: //============ OPERATOR =============
                    if GetIdentType(Ident) = itOperator then begin
                      OpCode:= GetIdentifierId(Ident, OperCompList);
                      if OpCode < 255 then begin
                        Inc(lth);
                        SetLength(Trans, lth + 1);
                        Trans[lth].Code:= OpCode;
                        Trans[lth].ParCount:= 1;
                        Trans[lth].Flags:= [];
                        Trans[lth].cType:= ctOperator;
                        Trans[lth].Offset:= Offset;
                        Trans[lth].Line:= a + 1;
                        //We also have to update the Command Props variable to make the
                        //  params reading working well
                        CommandProps.cType:= ctOperator;
                        //Here ParSize[1] is the Return size of the adjacent Variable
                        if Expected = leOperator then begin
                          CommandProps.ParSize[0]:= CommandProps.ParSize[1];
                          CommandProps.ParRng[0]:= CommandProps.ParRng[1];
                          Inc(Offset, 3); // 1 for OpCode + 2 for the hidden address
                        end else begin //leCaseOper
                          CommandProps.ParSize[0]:= SwitchVar.RetSize;
                          CommandProps.ParRng[0]:= SwitchVar.RetRange;
                          Inc(Offset); //the address is in the CASE cmd in this case
                        end;
                        Trans[lth].ParSize[0]:= CommandProps.ParSize[0];
                        //TODO: Check if CommandProps is still necessary after moving ParSize to Trans[]
                        Ident:= '';
                        if Trans[lth-1].Code = lvBEHAV then
                          Expected:= leBehaviour
                        else
                          Expected:= lePar1Num;
                        if LastCommand = lmOR_IF then begin //the IF-type base command is OR_IF
                          Inc(osh);
                          if High(ORIFStack) < osh then SetLength(ORIFStack, osh + 1);
                          ORIFStack[osh]:= lth; //record the position to update the address later
                        end
                        else if LastCommand in LifeIfWithoutOr then begin
                          for c:= osh downto 0 do //Update addresses for all OR_IFs
                            Trans[ORIFStack[c]].Params[1]:= Offset + CommandProps.ParSize[0]; //(+ 1 or 2 for the comparison param)
                          osh:= -1;
                        end;
                        if LastCommand in (LifeIfWithoutOr + [lmAND_IF]) then begin
                          Inc(ish);
                          if High(IFStack) < ish then SetLength(IFStack, ish + 1); //in case there was no OR_IF before
                          IFStack[ish]:= lth; //record the position to update the address later
                        end;
                        if LastCommand = lmAND_IF then
                          Trans[lth].Flags:= Trans[lth].Flags + [ofForAndif];
                        //unlike OR_IF, OR_CASE keeps the goto address, not the operator,
                        //so we have to record OR_CASE on the list (earlier)
                        //But CASE can be processed here
                        if LastCommand = lmCASE then begin
                          for c:= och downto 0 do //Update addresses for all OR_CASEs
                            Trans[ORCASEList[c]].Params[0]:= Offset + CommandProps.ParSize[0]; //(+ 1 or 2 for the comparison param)
                          och:= -1;
                        end;
                      end
                      else begin
                        AddMessage(Callback, False, ceUnkOper, Actor, a + 1, idst, idl);
                        Result:= False;
                      end;
                    end
                    else begin
                      AddMessage(Callback, False, ceExpOper, Actor, a + 1, idst, idl);
                      Result:= False;
                    end;

                  leBehaviour: //============ BEHAVIOUR =============
                    if GetIdentType(Ident) = itText then begin
                      param:= GetIdentifierId(Ident, BehavList);
                      if param < 255 then begin
                        Trans[lth].Params[0]:= param; //behaviour is always param 0
                        Ident:= '';
                        Inc(Offset);
                        Expected:= leNewLine;
                      end
                      else begin
                        AddMessage(Callback, False, ceUnkBehav, Actor, a + 1, idst, idl);
                        Result:= False;
                      end;
                    end
                    else begin
                      AddMessage(Callback, False, ceExpBehav, Actor, a + 1, idst, idl);
                      Result:= False;
                    end;

                  leDirMode: //============ DIRMODE =============
                    if GetIdentType(Ident) = itText then begin
                      param:= GetIdentifierId(Ident, DirmList);
                      if param < 255 then begin
                        if Trans[lth].Code = lmSET_DIRM then //(first param)
                          Trans[lth].Params[0]:= param
                        else if Trans[lth].Code = lmSET_DIRM_OBJ then //(second param)
                          Trans[lth].Params[1]:= param
                        else begin
                          AddMessage(Callback, False, ceInt20BadDir, Actor, a + 1, idst, idl);
                          Result:= False;
                        end;
                        Ident:= '';
                        Inc(Offset);
                        if param in DirmReqObj then Expected:= lePar2Num
                        else Expected:= leNewLine;
                      end
                      else begin
                        AddMessage(Callback, False, ceUnkDirM, Actor, a + 1, idst, idl);
                        Result:= False;
                      end;
                    end
                    else begin
                      AddMessage(Callback, False, ceExpDirM, Actor, a + 1, idst, idl);
                      Result:= False;
                    end;

                  leFragmentId1,       //integer index or textual name
                  leFragmentId2,       //textual name (optional), or integer switch (LBA2 only)
                  leFragSwitch3: begin //integer switch (LBA2 only)
                    if (Expected = leFragmentId1)
                    and (GetIdentType(Ident) = itNumber) then begin
                      if TryStrToInt(Ident, val) then begin
                        if ValueInRange(val, CommandProps.ParRng[0]^) then begin
                          Trans[lth].Params[0]:= val;
                          Ident:= '';
                          Expected:= leFragmentId2;
                          Inc(Offset, CommandProps.ParSize[0]);
                        end
                        else begin
                          AddMessage(Callback, False, ceOutOfRange, Actor, a + 1, idst, idl);
                          Result:= False;
                        end;
                      end
                      else begin
                        AddMessage(Callback, False, ceInvalidNum, Actor, a + 1, idst, idl);
                        Result:= False;
                      end;
                    end
                    else if (CommandProps.ParCount > 1)
                    and (((Expected = leFragmentId2) and (GetIdentType(Ident) = itNumber))
                      or (Expected = leFragSwitch3))
                    then begin //param2 num => the switch (there is no name)
                      if TryStrToInt(Ident, val) then begin
                        if ValueInRange(val, CommandProps.ParRng[1]^) then begin
                          Trans[lth].Params[1]:= val;
                          Ident:= '';
                          Expected:= leNewLine;
                          Inc(Offset, CommandProps.ParSize[0]);
                        end else begin
                          AddMessage(Callback, False, ceOutOfRange, Actor, a + 1, idst, idl);
                          Result:= False;
                        end;
                      end else begin
                        AddMessage(Callback, False, ceInvalidNum, Actor, a + 1, idst, idl);
                        Result:= False;
                      end;
                    end
                    else begin //If Ident is not a number, or param 2 expected
                      param:= FragmentNameIndex(Ident);
                      if param = -2 then begin
                        AddMessage(Callback, False, ceMGNotAllowed, Actor, a + 1, idst, idl);
                        Result:= False;
                      end else if param < 0 then begin // = -1
                        AddMessage(Callback, False, ceInvalidFrag, Actor, a + 1, idst, idl);
                        Result:= False;
                      end else
                        Trans[lth].Params[3]:= param + 1; //Store Fragment index for this command
                      Ident:= '';
                      //if we have only the name, we must put a dummy value as the first param
                      if Expected = leFragmentId1 then begin
                        Trans[lth].Params[0]:= 0;
                        Inc(Offset, CommandProps.ParSize[0]);
                      end;
                      if CommandProps.ParCount > 1 then //LBA2
                        Expected:= leFragSwitch3
                      else
                        Expected:= leNewLine;
                    end;
                  end;

                  leBreakMod:
                    if SameText(Ident, 'mod') then begin
                      Trans[lth].ParamStr:= 'mod';
                      Ident:= '';
                      Expected:= leNewLine;
                    end else begin
                      AddMessage(Callback, False, ceExpBreakMod, Actor, a + 1, idst, idl);
                      Result:= False;
                    end;

                  leNewLine: begin
                    AddMessage(Callback, False, ceExpNewLine, Actor, a + 1, idst, 0);
                    Result:= False;
                  end;

                end; //case

              end; //if not commented line

            end; //idl > 0

            if ((Expected = leNewLine)
            or  (Expected = leBreakMod)
            or ((Expected = leFragmentId2) and (CommandProps.ParCount <= 1)))
            and ((Line[b] in [#13, #10]) or (b = Length(Line))) then
              Expected:= leCommand;

          end; //end of line or { /

        end //valid char
        else begin
          AddMessage(Callback, False, ceInvalidChar, Actor, a + 1, b - 1, 1,
                     '0x' + IntToHex(Byte(Line[b]),2));
          Result:= False;
        end;

      end; //not CommentBlock

      if not Result then Break;

      if ((b = Length(Line)) or (Line[b] in [#13, #10]))
      and not (Expected in [leCommand, leNewLine, leBreakMod]) then begin
        AddMessage(Callback, False, ceUnExEol, Actor, a + 1, b, 0);
        Result:= False;
        Break;
      end;

    end; //for each char loop

    if not Result then Break;

  end; //for each line loop

  {If Result then  //this situation should have been cought earlier
    //We still have to check if all params were supplied
    If Expected <> leCommand then begin
      If Lines.Count > 0 then a:= Length(Lines.Strings[Lines.Count - 1])
                         else a:= 0;
      AddMessage(Msgs, False, mtError, ceUnExEol, Lines.Count, a, 0);
      Result:= False;
    end;}

  if Result then
    if ish > -1 then begin //IF or ELSE without ENDIF
      if ScrSet.Comp.StrictSyntax then begin
        AddMessage(Callback, False,
          IfThen(Trans[IFStack[ish]-2].Code = lmELSE, ceElseNoEndif, ceIfNoEndif),
          Actor, Trans[IFStack[ish]].Line, 0, 0);
        Result:= False;
      end else begin //LBA2 quirk: IF instead of AND_IF (perhaps a mistake)
        a:= IFStack[ish]; //position of the offending IF's operator
        if (Trans[a-2].Code = lmIF)
        and (lth >= a+3) and (Trans[a+1].Code = lmIF) then begin //next is IF
          Trans[a].Params[1]:= Trans[a+1].Offset; //Point to the next IF's offset
          if (a >= 5) and (lth >= a+4)
          and (Trans[a-5].Code = lmOR_IF) then //prior OR_IF must be corrected too
            Trans[a-3].Params[1]:= Trans[a+4].Offset; //a+4 is the first command after the second IF
        end else begin //next is not an IF, so this is not the quirk we are looking for
          AddMessage(Callback, False, ceIfNoEndif, Actor, Trans[IFStack[ish]].Line, 0, 0);
          Result:= False;
        end;
      end;
    end;

  if Result then
    if CommentBlock then begin
      if Lines.Count > 0 then a:= Length(Lines.Strings[Lines.Count - 1])
                         else a:= 0;
      AddMessage(Callback, False, ceInfComment, Actor, Lines.Count, a, 0);
      Result:= False;
    end;

  if Result then
    if (lth < 0) or (Trans[lth].Code <> 0) then //END
      if ScrSet.Comp.RequireENDs then begin
        if Lines.Count > 0 then a:= Length(Lines.Strings[Lines.Count - 1])
                            else a:= 0;
        AddMessage(Callback, False, ceExpEND, Actor, Lines.Count, a, 0);
        Result:= False;
      end
      else begin
        Inc(lth);
        SetLength(Trans, lth + 1);
        Trans[lth].Code:= 0;
        Trans[lth].Offset:= Offset;
      end;

  Lines.Free();
end;

function LifeCompResolveOffsets(var Trans: array of TTransTable; Actor: Integer;
  var LabelHashes: array of TLbHashTable; var CompLists: array of TCompList;
  Callback: TCompCallbackProc): Boolean;
var b, c, d, e, f, start, dfh, esh: Integer;
    LastCase: Integer; //Offset
    DefaultStack: array of Integer; //list of DEFAULT positions (list needed because SWITCHes may be stacked)
    EndSwitchStack: array of Integer; //list of END_SWITCH positions
    t: String;
    OpCode: Byte;
begin
  Result:= True;

  for b:= 0 to High(Trans[Actor]) do begin //for all commands in the Actor's Script

    if Trans[Actor,b].cType = ctCommand then begin //exclude conditions and operators
      OpCode:= Trans[Actor,b].Code;

      if OpCode = lmSET_TRACK then begin  //replace LABEL indices with their offsets
        c:= Trans[Actor,b].Params[0];
        if c <> -1 then begin //special case (-1) - don't resolve
          if (c <= High(LabelHashes[Actor])) and (LabelHashes[Actor,c].Offset > 0) then begin
            Trans[Actor,b].Params[0]:= LabelHashes[Actor,c].Offset - 1;
            LabelHashes[Actor,c].Used:= True;
          end
          else begin
            AddMessage(Callback, False, ceLifeNoTsLb, Actor, Trans[Actor,b].Line, 0, 0);
            Result:= False;
          end;
        end;
      end
      else if OpCode = lmSET_TRACK_OBJ then begin  //as above, but for all Actors
        c:= Trans[Actor,b].Params[1];
        d:= Trans[Actor,b].Params[0];

        if c <> -1 then begin //special case (-1)
          if d < Length(LabelHashes) then begin
            if (c <= High(LabelHashes[d])) and (LabelHashes[d,c].Offset > 0) then begin
              Trans[Actor,b].Params[1]:= LabelHashes[d,c].Offset - 1;
              LabelHashes[d,c].Used:= True;
            end
            else begin
              AddMessage(Callback, False, ceLifeNoTsLb, Actor, Trans[Actor,b].Line, 0, 0);
              Result:= False;
            end;
          end
          else begin
            AddMessage(Callback, False, ceLifeNoActor, Actor, Trans[Actor,b].Line, 0, 0);
            Result:= False;
          end;
        end;
      end
      else if OpCode = lmSET_COMP then begin  //replace COMPORTMENT names with their offsets
        t:= Trans[Actor,b].ParamStr;
        Trans[Actor,b].ParCount:= 1; //integer param
        {If SameText(t, 'end') then begin //special case: goto end
          If Trans[a,High(Trans[a])].Code = lsEND then
            Trans[a,b].Params[0]:= Trans[a,High(Trans[a])].Offset
          else begin
            AddMessage(Callback, False, mtError, ceInt26NoEND, a, Trans[a,b].Line, 0, 0);
            Result:= False;
          end;
        end
        else} if SameText(t, 'break') then begin //special case: stop execution
          Trans[Actor,b].Params[0]:= 65535;
        end
        else begin
          Result:= False;
          for e:= 0 to High(CompLists[Actor]) do
            If SameText(CompLists[Actor,e].Name, t) then begin
              Trans[Actor,b].Params[0]:= CompLists[Actor,e].Offset;
              Result:= True;
              CompLists[Actor,e].Used:= True;
              Break;
            end;
          if not Result then
            AddMessage(Callback, False, ceLifeNoComp, Actor, Trans[Actor,b].Line, 0, 0);
        end;
      end
      else if OpCode = lmSET_COMP_OBJ then begin //as above, but for all Actors
        t:= Trans[Actor,b].ParamStr;
        d:= Trans[Actor,b].Params[0];
        Trans[Actor,b].ParCount:= 2; //integer param
        if d < Length(CompLists) then begin
          if SameText(t, 'end') then begin //special case: goto end
            if Trans[d,High(Trans[d])].Code = lmEND then
              Trans[Actor,b].Params[1]:= Trans[d,High(Trans[d])].Offset
            else begin
              AddMessage(Callback, False, ceInt26NoEND, Actor, Trans[Actor,b].Line, 0, 0);
              Result:= False;
            end;
          end
          else if SameText(t, 'break') then begin //special case: stop execution
            Trans[Actor,b].Params[1]:= 65535;
          end
          else begin
            Result:= False;
            for e:= 0 to High(CompLists[d]) do
              if SameText(CompLists[d,e].Name, t) then begin
                Trans[Actor,b].Params[1]:= CompLists[d,e].Offset;
                Result:= True;
                CompLists[d,e].Used:= True;
                Break;
              end;
            if not Result then
              AddMessage(Callback, False, ceLifeNoComp, Actor, Trans[Actor,b].Line, 0, 0);

          end;
        end
        else begin
          AddMessage(Callback, False, ceLifeNoActor, Actor, Trans[Actor,b].Line, 0, 0);
          Result:= False;
        end;
      end;

    end
    else if (Trans[Actor,b].cType = ctVariable) then begin //actually, we have to check conditions also

      if Trans[Actor,b].Code in [lvCUR_TRACK, lvCUR_TRACK_OBJ] then begin
        c:= Trans[Actor,b+1].Params[0]; //we actually take param of the next command (operator)
        if Trans[Actor,b].Code = lvCUR_TRACK then d:= Actor else d:= Trans[Actor,b].Params[0];
        if d < Length(LabelHashes) then begin
          if Trans[Actor,b+1].Code in [loGREATER, loGREATER_EQ] then begin
            start:= IfThen(Trans[Actor,b+1].Code = loGREATER, c + 1, c);
            for f:= start to High(LabelHashes[d]) do
              LabelHashes[d,f].Used:= True;
          end
          else if Trans[Actor,b+1].Code in [loLESS, loLESS_EQ] then begin
            start:= IfThen(Trans[Actor,b+1].Code = loLESS, c - 1, c);
            for f:= start downto 0 do
              LabelHashes[d,f].Used:= True;
          end
          else begin
            if (c <= High(LabelHashes[d])) and (LabelHashes[d,c].Offset > 0) then
              LabelHashes[d,c].Used:= True //Nothing to resolve, it's a check only
            else if ScrSet.Comp.LabelWarnings then
              AddMessage(Callback, False, cwLifeNoTsLb, Actor, Trans[Actor,b].Line, 0, 0);
          end;
        end
        else
          AddMessage(Callback, False, cwLifeNoActor, Actor, Trans[Actor,b].Line, 0, 0);
      end
    end;

    if not Result then Break;
  end;

end;

procedure LifeCompCheckUsage(LabelHashes: array of TLbHashTable;
  CompLists: array of TCompList; Callback: TCompCallbackProc);
var a, b: Integer;
begin
  //Checking LABEL usage:
  if ScrSet.Comp.LbUnusedWarns then begin
    for a:= 0 to High(LabelHashes) do //for all Actors
      for b:= 0 to High(LabelHashes[a]) do //for all offsets
        if (LabelHashes[a,b].Offset > 0) //if there is a LABEL here
        and not LabelHashes[a,b].Used then //and not used
          AddMessage(Callback, True, cwLabelUnused, a, LabelHashes[a,b].Line, 0, 0);
  end;

  //Checking COMPORTMENT usage:
  if ScrSet.Comp.CompUnusedWarns then begin
    for a:= 0 to High(CompLists) do //for all Actors
      for b:= 1 to High(CompLists[a]) do //for all comportments (comp 0 is always used)
        if not CompLists[a,b].Used then //if not used
          AddMessage(Callback, False, cwCompUnused, a, CompLists[a,b].Line, 0, 0);
  end;
end;

//Error checking: this function only checks the offsets, that should be ok anyway,
//  so it can return an internal error only.
function LifeCompTransToBin(Trans: TTransTable; var BinaryScript: String;
  var FragInfo: TScriptFragInfo; Actor: Integer; Callback: TCompCallbackProc): Boolean;
var a, b, Offset, param, fih: Integer;
    OpCode: Byte;
begin
 Result:= True;
 BinaryScript:= '';
 Offset:= 0;
 fih:= -1;
 SetLength(FragInfo, 0);

 for a:= 0 to High(Trans) do begin
   OpCode:= Trans[a].Code;

   if Offset = Trans[a].Offset then begin

     case Trans[a].cType of
       ctCommand, ctIf: begin
         BinaryScript:= BinaryScript + Char(OpCode);
         if Trans[a].ParCount = -1 then
           BinaryScript:= BinaryScript + Trans[a].ParamStr + #0
         else begin
           if OpCode in [lmCASE, lmOR_CASE] then begin
             BinaryScript:= BinaryScript + WordToBinStr(Trans[a].Params[0]); //hidden address
           end else begin
             for b:= 0 to Trans[a].ParCount - 1 do
               BinaryScript:= BinaryScript
                 + ValToBinStr(LifeProps[OpCode].ParSize[b], Trans[a].Params[b]);
             if OpCode in [lmSET_DIRM, lmSET_DIRM_OBJ] then begin
               param:= IfThen(OpCode = lmSET_DIRM, 0, 1);
               if Trans[a].Params[param] in DirmReqObj then
                 BinaryScript:= BinaryScript + ValToBinStr(1, Trans[a].Params[param + 1]);
             end;
             if (Trans[a].Code = lmSET_GRM) and (Trans[a].Params[3] >= 2) then begin
               Inc(fih);
               SetLength(FragInfo, fih + 1);
               //-1 for reserved 0, and -1 for Map 0 is the Main Grid
               FragInfo[fih].Fragment:= Trans[a].Params[3] - 2;
               FragInfo[fih].Offset:= Length(BinaryScript) - 1; //Last byte is the param
             end;
           end;
         end;
       end;

       ctVariable, ctSwVar: begin
         BinaryScript:= BinaryScript + Char(OpCode);
         if Trans[a].ParCount > 0 then
           BinaryScript:= BinaryScript + ValToBinStr(1, Trans[a].Params[0]);
       end;

       ctOperator: begin
         if (a < 1)
         or ((Trans[a-1].cType <> ctVariable)
         and not (Trans[a-1].Code in [lmCASE, lmOR_CASE]))
         then begin
           AddMessage(Callback, False, ceInt39OpFirst, Actor, Trans[a].Line, 0, 0);
           Result:= False;
         end;
         BinaryScript:= BinaryScript + Char(OpCode)
           + ValToBinStr(Trans[a].ParSize[0], Trans[a].Params[0]);
         if Trans[a-1].cType = ctVariable then
           BinaryScript:= BinaryScript + ValToBinStr(2, Trans[a].Params[1]); //hidden address
       end;

       //ctVirtual: - nothing
     end;

   end
   else begin
     AddMessage(Callback, False, ceInt40WrongOff, Actor, Trans[a].Line, 0, 0);
     Result:= False;
   end;

   Offset:= Length(BinaryScript);

   If not Result then Break;

 end;
end;

end.
