
function TSynLifeScript1HL.Func15: TtkTokenKind;
begin
  if KeyComp('IF') then Result:= tkIf else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func23: TtkTokenKind;
begin
  if KeyComp('END') then Result := tkStatement else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func28: TtkTokenKind;
begin
  if KeyComp('BETA') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func30: TtkTokenKind;
begin
  if KeyComp('COL') then Result := tkCondition else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func32: TtkTokenKind;
begin
  {if KeyComp('LABEL') then begin
   Result:= tkIf;
   fPrevLabel:= True;
  end
  else} Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func37: TtkTokenKind;
begin
  if KeyComp('ANIM') then begin
   if fPrevIdent = tkIf then Result:= tkCondition
   else Result:= tkCommand
  end
  else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func38: TtkTokenKind;
begin
  if KeyComp('ENDIF') then Result:= tkIf else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func41: TtkTokenKind;
begin
  if KeyComp('ELSE') then Result:= tkIf else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func42: TtkTokenKind;
begin
  if KeyComp('SELF') then Result:= tkKeyword else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func43: TtkTokenKind;
begin
  if KeyComp('CHOICE') then Result := tkCondition else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func44: TtkTokenKind;
begin
  if KeyComp('FUEL') then Result := tkCondition else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func45: TtkTokenKind;
begin
  {if KeyComp('NOP') then Result := tkCommand else} Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func46: TtkTokenKind;
begin
  if KeyComp('BODY') then begin
   if fPrevIdent = tkIf then Result:= tkCondition
   else Result:= tkCommand;
  end
  else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func49: TtkTokenKind;
begin
  if KeyComp('ONEIF') then Result:= tkIf else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func51: TtkTokenKind;
begin
  if KeyComp('FALLABLE') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func53: TtkTokenKind;
begin
  if KeyComp('CDROM') then Result := tkCondition
  else if KeyComp('TRACK') then Result:= tkParameter
  else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func57: TtkTokenKind;
begin
  if KeyComp('SWIF') then Result:= tkIf else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func60: TtkTokenKind;
begin
  if KeyComp('ZONE') then Result := tkCondition else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func62: TtkTokenKind;
begin
  if KeyComp('ACTION') then Result := tkCondition
  else if KeyComp('MANUAL') then Result:= tkParameter
  else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func65: TtkTokenKind;
begin
  if KeyComp('RANDOM') then Result:= tkParameter else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func69: TtkTokenKind;
begin
  if KeyComp('MESSAGE') or KeyComp('TEXT') or KeyComp('ZOOM') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func70: TtkTokenKind;
begin
  if KeyComp('SUICIDE') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func71: TtkTokenKind;
begin
  if KeyComp('CHAPTER') then Result:= tkCondition
  {else if KeyComp('OFFSET') then begin
   Result:= tkIf;
   fPrevLabel:= True;
  end}
  else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func73: TtkTokenKind;
begin
  if KeyComp('NORMAL') then Result := tkParameter else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func75: TtkTokenKind;
begin
  if KeyComp('DISTANCE') then Result := tkCondition else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func78: TtkTokenKind;
begin
  if KeyComp('ATHLETIC') then Result := tkParameter else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func79: TtkTokenKind;
begin
  if KeyComp('OR_IF') {or KeyComp('NEVERIF')} then Result:= tkIf else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func80: TtkTokenKind;
begin
  if KeyComp('CAN_FALL') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func83: TtkTokenKind;
begin
  if KeyComp('FLAG_GAME') then Result := tkCondition
  else if KeyComp('ADD_CHOICE') then Result := tkCommand
  else if KeyComp('DISCRETE') or KeyComp('FOLLOW') then Result:= tkParameter
  else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func84: TtkTokenKind;
begin
  if KeyComp('ADD_FUEL') then Result := tkCommand else Result := tkIdentifier;
end;
function TSynLifeScript1HL.Func86: TtkTokenKind;
begin
  if KeyComp('END_LIFE') then Result := tkStatement else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func87: TtkTokenKind;
begin
  if KeyComp('THE_END') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func88: TtkTokenKind;
begin
  if KeyComp('COL_OBJ') or KeyComp('FLAG_CUBE') then Result := tkCondition
  else if KeyComp('OBJ_COL') then Result := tkCommand
  else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func93: TtkTokenKind;
begin
  if KeyComp('MIDI_OFF') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func94: TtkTokenKind;
begin
  if KeyComp('PROJ_3D') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func95: TtkTokenKind;
begin
  if KeyComp('ANIM_OBJ') then begin
   if fPrevIdent = tkIf then Result:= tkCondition
   else Result:= tkCommand;
  end
  else if KeyComp('HIT_BY') then Result := tkCondition
  else if KeyComp('HIT_OBJ') then Result := tkCommand
  else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func96: TtkTokenKind;
begin
  if KeyComp('GRM_OFF') then Result:= tkCommand
  else if KeyComp('RETURN') then Result:= tkStatement
  else if KeyComp('L_TRACK') then begin
    Result:= tkCondition;
    fPrevLabel:= True;
  end else
    Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func98: TtkTokenKind;
begin
  if KeyComp('VAR_GAME') then Result:= tkCondition else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func100: TtkTokenKind;
begin
  if KeyComp('CHANGE_CUBE') then Result := tkCommand
  else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func101: TtkTokenKind;
begin
  if KeyComp('INVISIBLE') then Result := tkCommand
  else if KeyComp('BEHAVIOUR') then Result := tkCondition
  else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func102: TtkTokenKind;
begin
  if KeyComp('KILL_OBJ') then Result := tkCommand
  else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func103: TtkTokenKind;
begin
  if KeyComp('VAR_CUBE') then Result:= tkCondition else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func104: TtkTokenKind;
begin
  if KeyComp('BODY_OBJ') then begin
   if fPrevIdent = tkIf then Result:= tkCondition
   else Result:= tkCommand;
  end
  else if KeyComp('PLAY_FLA') then begin
    Result:= tkCommand;
    fPrevLabel:= True;
  end
  else if KeyComp('BRICK_COL') then Result:= tkCommand
  else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func105: TtkTokenKind;
begin
  if KeyComp('ASK_CHOICE') then Result := tkCommand
  else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func106: TtkTokenKind;
begin
  if KeyComp('SET_DIR') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func107: TtkTokenKind;
begin
  if KeyComp('SET_LIFE') then begin
   Result := tkCommand;
   fPrevLabel:= True;
  end
  else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func110: TtkTokenKind;
begin
  if KeyComp('DISTANCE_3D') then Result := tkCondition
  else if KeyComp('BULLE_OFF') then Result:= tkCommand
  else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func112: TtkTokenKind;
begin
  if KeyComp('ANIM_SET') then Result := tkCommand
  else if KeyComp('AGGRESSIVE') then Result:= tkParameter
  else if KeyComp('BULLE_ON') then Result:= tkCommand
  else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func113: TtkTokenKind;
begin
  if KeyComp('SET_GRM') then begin
    Result := tkCommand;
    fPrevLabel:= True;
  end
  else if KeyComp('SPORTY') then Result:= tkParameter
  else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func114: TtkTokenKind;
begin
  {If KeyComp('FOLLOW_2') then Result:= tkParameter else} Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func115: TtkTokenKind;
begin
  if KeyComp('NO_MOVE') then Result:= tkParameter else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func116: TtkTokenKind;
begin
  if KeyComp('CARRIED_BY') then Result := tkCondition
  else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func117: TtkTokenKind;
begin
  if KeyComp('GAME_OVER') or KeyComp('SUB_FUEL') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func118: TtkTokenKind;
begin
  if KeyComp('ZONE_OBJ') then Result := tkCondition
  else if KeyComp('BIG_MESSAGE') then Result := tkCommand
  else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func119: TtkTokenKind;
begin
  if KeyComp('SAME_XZ') then Result:= tkParameter else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func120: TtkTokenKind;
begin
  if KeyComp('PLAY_MIDI') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func123: TtkTokenKind;
begin
  if KeyComp('CARRY_BY') then Result:= tkCondition else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func127: TtkTokenKind;
begin
  if KeyComp('CONE_VIEW') then Result := tkCondition
  else if KeyComp('MESSAGE_OBJ') then Result := tkCommand
  else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func128: TtkTokenKind;
begin
  if KeyComp('INC_CHAPTER') then Result:= tkCommand
  else if KeyComp('SET_TRACK') then begin
   Result:= tkKeyword;
   fPrevLabel:= True;
  end
  else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func129: TtkTokenKind;
begin
  if KeyComp('BALLOON_OFF') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func131: TtkTokenKind;
begin
  if KeyComp('CAM_FOLLOW') or KeyComp('BALLOON_ON') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func133: TtkTokenKind;
begin
  if KeyComp('PROJ_ISO') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func134: TtkTokenKind;
begin
  if KeyComp('FADE_PAL_RED') or KeyComp('FADE_RED_PAL') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func137: TtkTokenKind;
begin
  if KeyComp('LIFE_POINT') then Result := tkCondition else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func139: TtkTokenKind;
begin
  if KeyComp('CLEAR_TEXT') or KeyComp('EXPLODE_OBJ') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func140: TtkTokenKind;
begin
  {if KeyComp('TRACK_ATTACK') then Result:= tkParameter else} Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func143: TtkTokenKind;
begin
  if KeyComp('SET_DIRMODE') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func145: TtkTokenKind;
begin
  if KeyComp('GIVE_BONUS') or KeyComp('SAY_MESSAGE') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func146: TtkTokenKind;
begin
  if KeyComp('FOUND_OBJECT') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func150: TtkTokenKind;
begin
  if KeyComp('FADE_ALARM_RED') or KeyComp('FADE_RED_ALARM') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func152: TtkTokenKind;
begin
  if KeyComp('FADE_ALARM_PAL') or KeyComp('FADE_PAL_ALARM') then
    Result := tkCommand
  else if KeyComp('COMPORTMENT') then begin
    Result:= tkStatement;
    fPrevLabel:= True;
  end else
    Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func154: TtkTokenKind;
begin
  if KeyComp('L_TRACK_OBJ') then begin
    Result:= tkCondition;
    fPrevLabel:= True;
  end else
    Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func155: TtkTokenKind;
begin
  if KeyComp('POS_POINT') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func156: TtkTokenKind;
begin
  if KeyComp('FULL_POINT') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func157: TtkTokenKind;
begin
  if KeyComp('COMPORTEMENT') then begin
    Result:= tkStatement;
    fPrevLabel:= True;
  end else
    Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func158: TtkTokenKind;
begin
  if KeyComp('SET_FLAG_GAME') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func160: TtkTokenKind;
begin
  if KeyComp('HOLOMAP_TRAJ') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func163: TtkTokenKind;
begin
  if KeyComp('ASK_CHOICE_OBJ') or KeyComp('BRUTAL_EXIT') or KeyComp('SET_FLAG_CUBE') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func164: TtkTokenKind;
begin
  if KeyComp('SET_DIR_OBJ') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func165: TtkTokenKind;
begin
  if KeyComp('SET_LIFE_OBJ') then begin
   Result := tkCommand;
   fPrevLabel:= True;
  end
  else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func169: TtkTokenKind;
begin
  if KeyComp('SET_DARK_PAL') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func171: TtkTokenKind;
begin
  if KeyComp('MESSAGE_SENDELL') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func173: TtkTokenKind;
begin
  if KeyComp('SET_VAR_GAME') then Result:= tkCommand
  else if KeyComp('NB_GOLD_PIECES') then Result:= tkCondition
  else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func176: TtkTokenKind;
begin
  if KeyComp('PLAY_CD_TRACK') or KeyComp('SET_BEHAVIOUR') then Result := tkCommand
  else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func178: TtkTokenKind;
begin
  if KeyComp('SET_VAR_CUBE') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func183: TtkTokenKind;
begin
  if KeyComp('CURRENT_TRACK') then begin
    Result:= tkCondition;
    fPrevLabel:= True;
  end
  else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func186: TtkTokenKind;
begin
  if KeyComp('SET_TRACK_OBJ') then begin
   Result := tkKeyword;
   fPrevLabel:= True;
  end
  else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func188: TtkTokenKind;
begin
  if KeyComp('INIT_PINGOUIN') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func195: TtkTokenKind;
begin
  if KeyComp('LIFE_POINT_OBJ') then Result := tkCondition
  else if KeyComp('CLR_HOLO_POS') or KeyComp('SET_DOOR_UP') or KeyComp('SET_MAGIC_LEVEL') then Result := tkCommand
  else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func197: TtkTokenKind;
begin
  if KeyComp('STOP_L_TRACK') then begin
    Result:= tkKeyword;
    fPrevLabel:= True;
  end
  else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func200: TtkTokenKind;
begin
  if KeyComp('GIVE_GOLD_PIECES') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func201: TtkTokenKind;
begin
  if KeyComp('SET_DOOR_LEFT') or KeyComp('SET_DIRMODE_OBJ') then Result := tkCommand
  else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func203: TtkTokenKind;
begin
  if KeyComp('SAY_MESSAGE_OBJ') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func204: TtkTokenKind;
begin
  if KeyComp('INC_CLOVER_BOX') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func205: TtkTokenKind;
begin
  if KeyComp('NUM_GOLD_PIECES') then Result := tkCondition else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func206: TtkTokenKind;
begin
  if KeyComp('SET_HOLO_POS') then
    Result:= tkCommand
  else if KeyComp('END_COMPORTMENT') then
    Result:= tkStatement
  else
    Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func208: TtkTokenKind;
begin
  if KeyComp('SET_NORMAL_PAL') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func211: TtkTokenKind;
begin
  if KeyComp('END_COMPORTEMENT') then Result := tkStatement
  else if KeyComp('SUB_MAGIC_POINT') then Result := tkCommand
  else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func214: TtkTokenKind;
begin
  if KeyComp('SET_DOOR_DOWN') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func216: TtkTokenKind;
begin
  if KeyComp('NB_LITTLE_KEYS') then Result:= tkCondition else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func218: TtkTokenKind;
begin
  if KeyComp('USE_INVENTORY') then Result := tkCondition else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func220: TtkTokenKind;
begin
  if KeyComp('SET_DOOR_RIGHT') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func227: TtkTokenKind;
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

function TSynLifeScript1HL.Func229: TtkTokenKind;
begin
  if KeyComp('COMPORTEMENT_HERO') then begin
    if fPrevIdent = tkIf then Result:= tkCondition
    else Result:= tkCommand;
    fPrevLabel:= True;
  end else
    Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func232: TtkTokenKind;
begin
  if KeyComp('SET_COMPORTEMENT') then begin
    Result:= tkStatement;
    fPrevLabel:= True;
  end else
    Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func234: TtkTokenKind;
begin
  if KeyComp('COMPORTEMENT_HERO') then begin
    if fPrevIdent = tkIf then Result:= tkCondition
    else Result:= tkCommand;
    fPrevLabel:= True;
  end else
    Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func241: TtkTokenKind;
begin
  if KeyComp('CURRENT_TRACK_OBJ') then begin
    Result:= tkCondition;
    fPrevLabel:= True;
  end
  else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func248: TtkTokenKind;
begin
  if KeyComp('NUM_LITTLE_KEYS') then Result := tkCondition else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func267: TtkTokenKind;
begin
  if KeyComp('RESTORE_LAST_TRACK') then begin
    Result:= tkKeyword;
    fPrevLabel:= True;
  end
  else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func268: TtkTokenKind;
begin
  if KeyComp('SUB_LIFE_POINT_OBJ') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func270: TtkTokenKind;
begin
  if KeyComp('SET_LIFE_POINT_OBJ') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func284: TtkTokenKind;
begin
  if KeyComp('STOP_CURRENT_TRACK') then begin
    Result:= tkKeyword;
    fPrevLabel:= True;
  end
  else Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func285: TtkTokenKind;
begin
  if KeyComp('SET_COMPORTMENT_OBJ') then begin
    Result:= tkStatement;
    fPrevLabel:= True;
  end else
    Result:= tkIdentifier;
end;

function TSynLifeScript1HL.Func290: TtkTokenKind;
begin
  if KeyComp('SET_COMPORTEMENT_OBJ') then begin
   Result := tkStatement;
   fPrevLabel:= True;
  end
  else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func291: TtkTokenKind;
begin
  if KeyComp('USE_ONE_LITTLE_KEY') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynLifeScript1HL.Func297: TtkTokenKind;
begin
  if KeyComp('SET_USED_INVENTORY') then Result := tkCommand else Result := tkIdentifier;
end;