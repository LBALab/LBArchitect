
function TSynLifeScript2HL.Func7: TtkTokenKind;
begin
  if KeyComp('BEHAV10') then Result:= tkParameter else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func8: TtkTokenKind;
begin
  if KeyComp('BEHAV11') then Result:= tkParameter else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func9: TtkTokenKind;
begin
  if KeyComp('BEHAV12') then Result:= tkParameter else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func10: TtkTokenKind;
begin
  if KeyComp('BEHAV13') then Result:= tkParameter else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func15: TtkTokenKind;
begin
  if KeyComp('IF') then Result:= tkIf else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func23: TtkTokenKind;
begin
  if KeyComp('END') then Result := tkStatement else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func27: TtkTokenKind;
begin
  if KeyComp('BEHAV5') then Result:= tkParameter else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func28: TtkTokenKind;
begin
  if KeyComp('BETA') then begin
    if fPrevIdent = tkIf then Result:= tkCondition
    else Result:= tkCommand;
  end
  else if KeyComp('CASE') then Result:= tkKeyword
  else if KeyComp('BEHAV6') then Result:= tkParameter
  else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func29: TtkTokenKind;
begin
  if KeyComp('BEHAV7') then Result:= tkParameter else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func30: TtkTokenKind;
begin
  if KeyComp('COL') then Result:= tkCondition
  else if KeyComp('BEHAV8') then Result:= tkParameter
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func31: TtkTokenKind;
begin
  if KeyComp('BEHAV9') then Result:= tkParameter else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func36: TtkTokenKind;
begin
  if KeyComp('RND') then Result:= tkCondition else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func37: TtkTokenKind;
begin
  if KeyComp('ANIM') then begin
   if fPrevIdent = tkIf then Result:= tkCondition
   else Result:= tkCommand
  end
  else if KeyComp('DEMO') then Result:= tkCondition
  else if KeyComp('BREAK') then Result:= tkKeyword
  else if KeyComp('DIRMODE10') then Result:= tkParameter
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func38: TtkTokenKind;
begin
  if KeyComp('ENDIF') then Result:= tkIf
  else if KeyComp('DIRMODE11') then Result:= tkParameter
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func39: TtkTokenKind;
begin
  if KeyComp('DEBUG') then Result:= tkKeyword
  else if KeyComp('ANGLE') then Result:= tkCondition
  else if KeyComp('DIRMODE12') then Result:= tkParameter
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func40: TtkTokenKind;
begin
  if KeyComp('RAIL') then Result:= tkCondition
  else if KeyComp('DIRMODE13') then Result:= tkParameter
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func41: TtkTokenKind;
begin
  if KeyComp('ELSE') then Result:= tkIf else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func42: TtkTokenKind;
begin
  if KeyComp('SELF') then Result:= tkKeyword
  else if KeyComp('RAIN') then Result:= tkCommand
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func43: TtkTokenKind;
begin
  if KeyComp('CHOICE') then Result:= tkCondition
  else if KeyComp('PCX') then Result:= tkCommand
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func44: TtkTokenKind;
begin
  if KeyComp('FUEL') then Result:= tkCondition
  else if KeyComp('LADDER') then begin
    if fPrevIdent = tkIf then Result:= tkCondition
    else Result:= tkCommand;
  end
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func46: TtkTokenKind;
begin
  if KeyComp('BODY') then begin
   if fPrevIdent = tkIf then Result:= tkCondition
   else Result:= tkCommand;
  end
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func48: TtkTokenKind;
begin
  if KeyComp('ECLAIR') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func49: TtkTokenKind;
begin
  if KeyComp('ONEIF') then Result:= tkIf else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func50: TtkTokenKind;
begin
  if KeyComp('ECHELLE') then begin
    if fPrevIdent = tkIf then Result:= tkCondition
    else Result:= tkCommand;
  end
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func51: TtkTokenKind;
begin
  if KeyComp('FALLABLE') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func52: TtkTokenKind;
begin
  if KeyComp('BULLE') then Result:= tkCommand
  else if KeyComp('REMP') then Result:= tkKeyword
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func53: TtkTokenKind;
begin
  if KeyComp('CDROM') then Result:= tkCondition else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func57: TtkTokenKind;
begin
  if KeyComp('SWIF') then Result:= tkIf else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func60: TtkTokenKind;
begin
  if KeyComp('ZONE') then Result:= tkCondition
  else if KeyComp('REPLACE') then Result:= tkKeyword
  else if KeyComp('SPY') then Result:= tkCommand
  else if KeyComp('DIRMODE8') then Result:= tkParameter
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func61: TtkTokenKind;
begin
  if KeyComp('DIRMODE9') then Result:= tkParameter else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func62: TtkTokenKind;
begin
  if KeyComp('ACTION') then begin
    if fPrevIdent = tkIf then Result:= tkCondition
    else Result:= tkCommand
  end
  else if KeyComp('MANUAL') then Result:= tkParameter
  else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func63: TtkTokenKind;
begin
  if KeyComp('PLUIE') then Result:= tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func65: TtkTokenKind;
begin
  if KeyComp('AND_IF') then Result:= tkIf else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func66: TtkTokenKind;
begin
  if KeyComp('SAMPLE') then Result:= tkCommand
  else if KeyComp('JETPACK') then Result:= tkParameter
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func69: TtkTokenKind;
begin
  if KeyComp('MESSAGE') then Result:= tkCommand
  else if KeyComp('DEFAULT') then Result:= tkKeyword
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func70: TtkTokenKind;
begin
  if KeyComp('SUICIDE') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func71: TtkTokenKind;
begin
  if KeyComp('CHAPTER') then Result:= tkCondition
  else if KeyComp('BALLOON') then Result:= tkCommand
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func73: TtkTokenKind;
begin
  if KeyComp('NORMAL') then Result := tkParameter else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func75: TtkTokenKind;
begin
  if KeyComp('DISTANCE') then Result := tkCondition else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func79: TtkTokenKind;
begin
  if KeyComp('OR_IF') then
    Result:= tkIf
  else if KeyComp('PALETTE') then
    Result:= tkCommand
  else
    Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func80: TtkTokenKind;
begin
  if KeyComp('CAN_FALL') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func82: TtkTokenKind;
begin
  if KeyComp('SWITCH') then Result:= tkIf else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func83: TtkTokenKind;
begin
  if KeyComp('ADD_CHOICE') then Result := tkCommand
  else if KeyComp('FOLLOW') or KeyComp('DISCREET') then Result:= tkParameter
  else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func84: TtkTokenKind;
begin
  if KeyComp('ADD_FUEL') then Result := tkCommand else Result := tkIdentifier;
end;
function TSynLifeScript2HL.Func86: TtkTokenKind;
begin
  if KeyComp('END_LIFE') then Result:= tkStatement
  else if KeyComp('BETA_OBJ') then Result:= tkCondition
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func87: TtkTokenKind;
begin
  if KeyComp('THE_END') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func88: TtkTokenKind;
begin
  if KeyComp('COL_OBJ') then Result := tkCondition
  else if KeyComp('OBJ_COL') then Result := tkCommand
  else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func89: TtkTokenKind;
begin
  if KeyComp('NO_CHOC') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func92: TtkTokenKind;
begin
  if KeyComp('OR_CASE') then Result:= tkKeyword else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func94: TtkTokenKind;
begin
  if KeyComp('ESCALATOR') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func95: TtkTokenKind;
begin
  if KeyComp('ANIM_OBJ') then begin
    if fPrevIdent = tkIf then Result:= tkCondition
    else Result:= tkCommand;
  end
  else if KeyComp('PLAY_ACF') then begin
    Result:= tkCommand;
    fPrevLabel:= True;
  end
  else if KeyComp('HIT_BY') then Result := tkCondition
  else if KeyComp('HIT_OBJ') then Result := tkCommand
  else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func96: TtkTokenKind;
begin
  if KeyComp('RETURN') then Result:= tkStatement
  else if KeyComp('BACKGROUND') then Result:= tkCommand
  else if KeyComp('L_TRACK') then begin
    Result:= tkCondition;
    fPrevLabel:= True;
  end
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func97: TtkTokenKind;
begin
  if KeyComp('DEBUG_OBJ') then Result:= tkKeyword
  else if KeyComp('POPCORN') then Result:= tkCommand
  else if KeyComp('ANGLE_OBJ') then Result:= tkCondition
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func98: TtkTokenKind;
begin
  if KeyComp('VAR_GAME') then Result:= tkCondition else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func100: TtkTokenKind;
begin
  if KeyComp('CHANGE_CUBE') then Result:= tkCommand
  else if KeyComp('LIGHTNING') then Result:= tkCommand
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func101: TtkTokenKind;
begin
  if KeyComp('INVISIBLE') then Result := tkCommand
  else if KeyComp('BEHAVIOUR') then Result := tkCondition
  else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func102: TtkTokenKind;
begin
  if KeyComp('KILL_OBJ') then Result := tkCommand
  else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func103: TtkTokenKind;
begin
  if KeyComp('VAR_CUBE') then Result:= tkCondition else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func104: TtkTokenKind;
begin
  if KeyComp('BODY_OBJ') then begin
    if fPrevIdent = tkIf then Result:= tkCondition
    else Result:= tkCommand;
  end
  else if KeyComp('BRICK_COL') then Result:= tkCommand
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func105: TtkTokenKind;
begin
  if KeyComp('ASK_CHOICE') then Result := tkCommand
  else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func106: TtkTokenKind;
begin
  if KeyComp('NO_BODY') or KeyComp('SET_DIR') then Result:= tkCommand
  else if KeyComp('REAL_ANGLE') then Result:= tkCondition
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func109: TtkTokenKind;
begin
  if KeyComp('ADD_MESSAGE') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func110: TtkTokenKind;
begin
  if KeyComp('DISTANCE_3D') then Result := tkCondition
  else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func112: TtkTokenKind;
begin
  if KeyComp('ANIM_SET') then Result:= tkCommand
  else if KeyComp('AGGRESSIVE') then Result:= tkParameter
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func113: TtkTokenKind;
begin
  if KeyComp('SET_GRM') then begin
    Result := tkCommand;
    fPrevLabel:= True;
  end
  else if KeyComp('CINEMA_MODE') then Result:= tkCommand
  else if KeyComp('SPORTY') then Result:= tkParameter
  else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func114: TtkTokenKind;
begin
  If KeyComp('FLOW_OBJ') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func115: TtkTokenKind;
begin
  if KeyComp('NO_MOVE') then Result:= tkParameter
  else if KeyComp('SET_RAIL') then Result:= tkCommand
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func116: TtkTokenKind;
begin
  if KeyComp('CARRIED_BY') then
    Result:= tkCondition
  else if KeyComp('SET_CAMERA') or KeyComp('NO_SHOCK') then
    Result:= tkCommand
  else
    Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func117: TtkTokenKind;
begin
  if KeyComp('GAME_OVER') or KeyComp('SUB_FUEL') or KeyComp('CONVEYOR')
  then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func118: TtkTokenKind;
begin
  if KeyComp('ZONE_OBJ') then Result:= tkCondition
  else if KeyComp('SET_FRAME') then Result:= tkCommand
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func119: TtkTokenKind;
begin
  if KeyComp('SAME_XZ') then Result:= tkParameter else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func120: TtkTokenKind;
begin
  if KeyComp('IMPACT_OBJ') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func123: TtkTokenKind;
begin
  if KeyComp('END_MESSAGE') then Result:= tkCommand
  else if KeyComp('CARRY_BY') then Result:= tkCondition
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func124: TtkTokenKind;
begin
  if KeyComp('SAVE_HERO') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func125: TtkTokenKind;
begin
  if KeyComp('SAVE_COMP') then Result:= tkKeyword
  else if KeyComp('COL_DECORS') then Result:= tkCondition
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func127: TtkTokenKind;
begin
  if KeyComp('CONE_VIEW') then Result := tkCondition
  else if KeyComp('MESSAGE_OBJ') then Result := tkCommand
  else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func128: TtkTokenKind;
begin
  if KeyComp('INC_CHAPTER') or KeyComp('SHADOW_OBJ') then
    Result:= tkCommand
  else if KeyComp('SET_TRACK') then begin
    Result:= tkKeyword;
    fPrevLabel:= True;
  end
  else if KeyComp('PLAY_SMK') then begin
    Result:= tkCommand;
    fPrevLabel:= True;
  end
  else if KeyComp('PROCESSOR') then Result:= tkCondition
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func131: TtkTokenKind;
begin
  if KeyComp('CAM_FOLLOW') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func133: TtkTokenKind;
begin
  if KeyComp('SAMPLE_RND') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func134: TtkTokenKind;
begin
  if KeyComp('MEMO_SLATE') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func136: TtkTokenKind;
begin
  if KeyComp('END_SWITCH') then Result:= tkKeyword else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func137: TtkTokenKind;
begin
  if KeyComp('LIFE_POINT') then
    Result:= tkCondition
  else if KeyComp('CAMERA_CENTER') then
    Result:= tkCommand
  else
    Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func138: TtkTokenKind;
begin
  if KeyComp('ADD_VAR_GAME') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func139: TtkTokenKind;
begin
  if KeyComp('NEW_SAMPLE') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func142: TtkTokenKind;
begin
  if KeyComp('FADE_TO_PAL') then Result:= tkParameter else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func143: TtkTokenKind;
begin
  if KeyComp('SET_DIRMODE') or KeyComp('ADD_VAR_CUBE') then Result:= tkCommand
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func145: TtkTokenKind;
begin
  if KeyComp('GIVE_BONUS') or KeyComp('INIT_BUGGY') or KeyComp('PARM_SAMPLE')
  then Result:= tkCommand
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func146: TtkTokenKind;
begin
  if KeyComp('FOUND_OBJECT') or KeyComp('MESSAGE_ZOE') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func148: TtkTokenKind;
begin
  if KeyComp('MEMO_ARDOISE') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func150: TtkTokenKind;
begin
  if KeyComp('PLAY_MUSIC') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func151: TtkTokenKind;
begin
  if KeyComp('INVERSE_BETA') or KeyComp('SET_ARMURE') then Result:= tkCommand
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func152: TtkTokenKind;
begin
  if KeyComp('COMPORTMENT') then begin
    Result:= tkStatement;
    fPrevLabel:= True;
  end else
    Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func153: TtkTokenKind;
begin
  if KeyComp('HIT_OBJ_BY') then Result:= tkCondition else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func154: TtkTokenKind;
begin
  if KeyComp('STOP_TRACK') then begin
    Result:= tkKeyword;
    fPrevLabel:= True;
  end
  else if KeyComp('L_TRACK_OBJ') then begin
    Result:= tkCondition;
    fPrevLabel:= True;
  end
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func155: TtkTokenKind;
begin
  if KeyComp('POS_POINT') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func156: TtkTokenKind;
begin
  if KeyComp('FULL_POINT') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func157: TtkTokenKind;
begin
  if KeyComp('COMPORTEMENT') then begin
    Result:= tkStatement;
    fPrevLabel:= True;
  end else
    Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func159: TtkTokenKind;
begin
  if KeyComp('SET_FRAME_3DS') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func161: TtkTokenKind;
begin
  if KeyComp('SET_ARMOUR') or KeyComp('FLOW_POINT') then Result:= tkCommand
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func162: TtkTokenKind;
begin
  if KeyComp('SET_SPRITE') or KeyComp('REPEAT_SAMPLE') then Result:= tkCommand
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func163: TtkTokenKind;
begin
  if KeyComp('ASK_CHOICE_OBJ') or KeyComp('BRUTAL_EXIT') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func164: TtkTokenKind;
begin
  if KeyComp('SET_DIR_OBJ') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func167: TtkTokenKind;
begin
  if KeyComp('IMPACT_POINT') or KeyComp('ADD_MESSAGE_OBJ') or KeyComp('SAMPLE_STOP')
  then Result:= tkCommand
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func169: TtkTokenKind;
begin
  if KeyComp('SET_ANIM_DIAL') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func171: TtkTokenKind;
begin
  if KeyComp('SUB_VAR_GAME') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func173: TtkTokenKind;
begin
  if KeyComp('SET_VAR_GAME') then Result:= tkCommand
  else if KeyComp('NB_GOLD_PIECES') then Result := tkCondition
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func174: TtkTokenKind;
begin
  if KeyComp('CARRIED_OBJ_BY') then Result:= tkCondition else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func175: TtkTokenKind;
begin
  if KeyComp('SET_CHANGE_CUBE') then Result:= tkCommand
  else if KeyComp('DISTANCE_MESSAGE') then Result:= tkCondition
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func176: TtkTokenKind;
begin
  if KeyComp('SET_BEHAVIOUR') or KeyComp('SUB_VAR_CUBE') then Result:= tkCommand
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func177: TtkTokenKind;
begin
  if KeyComp('RESTORE_HERO') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func178: TtkTokenKind;
begin
  if KeyComp('SET_VAR_CUBE') or KeyComp('SAMPLE_ALWAYS') then Result:= tkCommand
  else if KeyComp('RESTORE_COMP') then Result:= tkKeyword
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func181: TtkTokenKind;
begin
  if KeyComp('ANIM_TEXTURE') or KeyComp('END_MESSAGE_OBJ') then Result:= tkCommand
  else if KeyComp('OBJECT_DISPLAYED') or KeyComp('CARRY_OBJ_BY') then Result:= tkCondition
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func183: TtkTokenKind;
begin
  if KeyComp('CURRENT_TRACK') then begin
    Result:= tkCondition;
    fPrevLabel:= True;
  end
  else if KeyComp('SAVE_COMP_OBJ') then Result:= tkKeyword
  else if KeyComp('COL_DECORS_OBJ') then Result:= tkCondition
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func184: TtkTokenKind;
begin
  if KeyComp('RESTORE_TRACK') then begin
    Result:= tkKeyword;
    fPrevLabel:= True;
  end else
    Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func186: TtkTokenKind;
begin
  if KeyComp('SET_TRACK_OBJ') then begin
   Result := tkKeyword;
   fPrevLabel:= True;
  end
  else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func188: TtkTokenKind;
begin
  if KeyComp('PCX_MESS_OBJ') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func195: TtkTokenKind;
begin
  if KeyComp('LIFE_POINT_OBJ') then Result := tkCondition
  else if KeyComp('CLR_HOLO_POS') or KeyComp('SET_DOOR_UP') or KeyComp('SET_MAGIC_LEVEL') then Result := tkCommand
  else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func197: TtkTokenKind;
begin
  if KeyComp('STOP_L_TRACK') then begin
    Result:= tkKeyword;
    fPrevLabel:= True;
  end else
    Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func200: TtkTokenKind;
begin
  if KeyComp('GIVE_GOLD_PIECES') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func201: TtkTokenKind;
begin
  if KeyComp('SET_DOOR_LEFT') or KeyComp('SET_DIRMODE_OBJ') then Result := tkCommand
  else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func203: TtkTokenKind;
begin
  if KeyComp('SET_HIT_ZONE') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func204: TtkTokenKind;
begin
  if KeyComp('INC_CLOVER_BOX') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func205: TtkTokenKind;
begin
  if KeyComp('NUM_GOLD_PIECES') then Result := tkCondition else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func206: TtkTokenKind;
begin
  if KeyComp('SET_HOLO_POS') then
    Result:= tkCommand
  else if KeyComp('END_COMPORTMENT') then
    Result:= tkStatement
  else
    Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func209: TtkTokenKind;
begin
  if KeyComp('SET_ARMURE_OBJ') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func211: TtkTokenKind;
begin
  if KeyComp('SUB_MAGIC_POINT') then
    Result:= tkCommand
  else if KeyComp('END_COMPORTEMENT') then
    Result:= tkStatement
  else
    Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func212: TtkTokenKind;
begin
  if KeyComp('STOP_TRACK_OBJ') then Result:= tkKeyword
  else if KeyComp('POS_OBJ_AROUND') then Result:= tkCommand
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func214: TtkTokenKind;
begin
  if KeyComp('SET_DOOR_DOWN') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func216: TtkTokenKind;
begin
  if KeyComp('NB_LITTLE_KEYS') then Result:= tkCondition else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func218: TtkTokenKind;
begin
  if KeyComp('USE_INVENTORY') then Result := tkCondition else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func219: TtkTokenKind;
begin
  if KeyComp('SET_ARMOUR_OBJ') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func220: TtkTokenKind;
begin
  if KeyComp('SET_DOOR_RIGHT') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func227: TtkTokenKind;
begin
  if KeyComp('SET_COMPORTMENT') then begin
    Result:= tkStatement;
    fPrevLabel:= True;
  end
  else if KeyComp('RESTORE_L_TRACK') then begin
    Result:= tkKeyword;
    fPrevLabel:= True;
  end else
    Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func229: TtkTokenKind;
begin
  if KeyComp('COMPORTMENT_HERO') then begin
    if fPrevIdent = tkIf then Result:= tkCondition
    else Result:= tkCommand;
  end
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func230: TtkTokenKind;
begin
  if KeyComp('SAVE_COMPORTMENT') then Result:= tkKeyword else Result:= tkIdentifier;
end;


function TSynLifeScript2HL.Func232: TtkTokenKind;
begin
  if KeyComp('SET_COMPORTEMENT') then begin
    Result:= tkStatement;
    fPrevLabel:= True;
  end else
    Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func234: TtkTokenKind;
begin
  if KeyComp('COMPORTEMENT_HERO') then begin
    if fPrevIdent = tkIf then Result:= tkCondition
    else Result:= tkCommand;
  end
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func235: TtkTokenKind;
begin
  if KeyComp('ADD_LIFE_POINT_OBJ') then Result:= tkCommand
  else if KeyComp('SAVE_COMPORTEMENT') then Result:= tkKeyword
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func236: TtkTokenKind;
begin
  if KeyComp('RESTORE_COMP_OBJ') then Result:= tkKeyword else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func238: TtkTokenKind;
begin
  if KeyComp('STATE_INVENTORY') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func241: TtkTokenKind;
begin
  if KeyComp('CURRENT_TRACK_OBJ') then begin
    Result:= tkCondition;
    fPrevLabel:= True;
  end
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func242: TtkTokenKind;
begin
  if KeyComp('RESTORE_TRACK_OBJ') then Result:= tkKeyword else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func248: TtkTokenKind;
begin
  if KeyComp('NUM_LITTLE_KEYS') then Result:= tkCondition
  else if KeyComp('TRACK_TO_VAR_GAME') or KeyComp('VAR_GAME_TO_TRACK') then Result:= tkKeyword
  else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func255: TtkTokenKind;
begin
  if KeyComp('STOP_L_TRACK_OBJ') then begin
    Result:= tkKeyword;
    fPrevLabel:= True;
  end else
    Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func268: TtkTokenKind;
begin
  if KeyComp('SUB_LIFE_POINT_OBJ') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func270: TtkTokenKind;
begin
  if KeyComp('SET_LIFE_POINT_OBJ') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func283: TtkTokenKind;
begin
  if KeyComp('RESTORE_COMPORTMENT') then Result:= tkKeyword else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func285: TtkTokenKind;
begin
  if KeyComp('SET_COMPORTMENT_OBJ') then begin
    Result:= tkStatement;
    fPrevLabel:= True;
  end
  else if KeyComp('RESTORE_L_TRACK_OBJ') then begin
    Result:= tkKeyword;
    fPrevLabel:= True;
  end else
    Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func288: TtkTokenKind;
begin
  if KeyComp('RESTORE_COMPORTEMENT') or KeyComp('SAVE_COMPORTMENT_OBJ') then
    Result:= tkKeyword
  else
    Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func290: TtkTokenKind;
begin
  if KeyComp('SET_COMPORTEMENT_OBJ') then begin
    Result:= tkStatement;
    fPrevLabel:= True;
  end else
    Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func291: TtkTokenKind;
begin
  if KeyComp('USE_ONE_LITTLE_KEY') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func293: TtkTokenKind;
begin
  if KeyComp('SAVE_COMPORTEMENT_OBJ') then Result:= tkKeyword else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func297: TtkTokenKind;
begin
  if KeyComp('SET_USED_INVENTORY') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript2HL.Func341: TtkTokenKind;
begin
  if KeyComp('RESTORE_COMPORTMENT_OBJ') then Result:= tkKeyword else Result:= tkIdentifier;
end;

function TSynLifeScript2HL.Func346: TtkTokenKind;
begin
  if KeyComp('RESTORE_COMPORTEMENT_OBJ') then Result:= tkKeyword else Result:= tkIdentifier;
end;