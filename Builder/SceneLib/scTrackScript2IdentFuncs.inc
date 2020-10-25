
function TSynTrackScript2HL.Func19: TtkTokenKind;
begin
  if KeyComp('DO') then Result := tkStatement else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func23: TtkTokenKind;
begin
  if KeyComp('END') then Result := tkStatement else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func28: TtkTokenKind;
begin
  if KeyComp('BETA') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func32: TtkTokenKind;
begin
  if KeyComp('LABEL') then begin
    Result:= tkStatement;
    fPrevLabel:= True;
  end
  else Result:= tkIdentifier;
end;

function TSynTrackScript2HL.Func37: TtkTokenKind;
begin
  if KeyComp('ANIM') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func38: TtkTokenKind;
begin
  if KeyComp('DECALAGE') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynTrackScript2HL.Func39: TtkTokenKind;
begin
  if KeyComp('ANGLE') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func46: TtkTokenKind;
begin
  if KeyComp('BODY') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func49: TtkTokenKind;
begin
  if KeyComp('SPEED') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func52: TtkTokenKind;
begin
  if KeyComp('REMP') then Result:= tkKey else Result:= tkIdentifier;
end;

function TSynTrackScript2HL.Func54: TtkTokenKind;
begin
  if KeyComp('CLOSE') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func57: TtkTokenKind;
begin
  if KeyComp('GOTO') then begin
    Result:= tkStatement;
    fPrevLabel:= True;
  end
  else Result:= tkIdentifier;
end;

function TSynTrackScript2HL.Func60: TtkTokenKind;
begin
  if KeyComp('REPLACE') then Result:= tkKey else Result:= tkIdentifier;
end;

function TSynTrackScript2HL.Func66: TtkTokenKind;
begin
  if KeyComp('SAMPLE') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynTrackScript2HL.Func96: TtkTokenKind;
begin
  if KeyComp('BACKGROUND') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func70: TtkTokenKind;
begin
  if KeyComp('STOP') then Result := tkKey else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func87: TtkTokenKind;
begin
  if KeyComp('SPRITE') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func88: TtkTokenKind;
begin
  if KeyComp('VOLUME') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func95: TtkTokenKind;
begin
  if KeyComp('PLAY_ACF') then begin
    Result:= tkCommand;
    fPrevLabel:= True;
  end
  else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func101: TtkTokenKind;
begin
  if KeyComp('INTERVAL') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func106: TtkTokenKind;
begin
  if KeyComp('ANGLE_RND') or KeyComp('NO_BODY') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func109: TtkTokenKind;
begin
  if KeyComp('AFF_TIMER') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func114: TtkTokenKind;
begin
  if KeyComp('FREQUENCY') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func118: TtkTokenKind;
begin
  if KeyComp('OPEN_UP') or KeyComp('SET_FRAME') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynTrackScript2HL.Func121: TtkTokenKind;
begin
  if KeyComp('WAIT_ANIM') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func124: TtkTokenKind;
begin
  if KeyComp('OPEN_LEFT') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func128: TtkTokenKind;
begin
  if KeyComp('PLAY_SMK') then begin
    Result:= tkCommand;
    fPrevLabel:= True;
  end
  else Result:= tkIdentifier;
end;

function TSynTrackScript2HL.Func133: TtkTokenKind;
begin
  if KeyComp('SAMPLE_RND') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func136: TtkTokenKind;
begin
  if KeyComp('WAIT_DOOR') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func137: TtkTokenKind;
begin
  if KeyComp('OPEN_DOWN') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func139: TtkTokenKind;
begin
  if KeyComp('SET_END_3DS') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func143: TtkTokenKind;
begin
  if KeyComp('OPEN_RIGHT') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func150: TtkTokenKind;
begin
  if KeyComp('FACE_TWINSEN') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynTrackScript2HL.Func155: TtkTokenKind;
begin
  if KeyComp('POS_POINT') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func159: TtkTokenKind;
begin
  if KeyComp('SET_FRAME_3DS') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func162: TtkTokenKind;
begin
  if KeyComp('GOTO_POINT') or KeyComp('REPEAT_SAMPLE')
  or KeyComp('WAIT_ANIM_3DS') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func167: TtkTokenKind;
begin
  if KeyComp('SAMPLE_STOP') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func168: TtkTokenKind;
begin
  if KeyComp('WAIT_FRAME_3DS') or KeyComp('WAIT_NB_ANIM') then Result:= tkCommand
  else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func171: TtkTokenKind;
begin
  if KeyComp('SIMPLE_SAMPLE') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func178: TtkTokenKind;
begin
  if KeyComp('SAMPLE_ALWAYS') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func179: TtkTokenKind;
begin
  if KeyComp('STOP_ANIM_3DS') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func187: TtkTokenKind;
begin
  if KeyComp('START_ANIM_3DS') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func191: TtkTokenKind;
begin
  if KeyComp('WAIT_NB_SECOND') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynTrackScript2HL.Func194: TtkTokenKind;
begin
  if KeyComp('WAIT_NUM_DSEC') or KeyComp('SET_START_3DS') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func197: TtkTokenKind;
begin
  if KeyComp('GOTO_POINT_3D') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func202: TtkTokenKind;
begin
  if KeyComp('WAIT_NB_DIZIEME') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynTrackScript2HL.Func200: TtkTokenKind;
begin
  if KeyComp('WAIT_NUM_ANIM') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func223: TtkTokenKind;
begin
  if KeyComp('WAIT_NUM_SECOND') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func250: TtkTokenKind;
begin
  if KeyComp('GOTO_SYM_POINT') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func257: TtkTokenKind;
begin
  if KeyComp('WAIT_NUM_SEC_RND') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func258: TtkTokenKind;
begin
  if KeyComp('WAIT_NB_SECOND_RND') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynTrackScript2HL.Func261: TtkTokenKind;
begin
  if KeyComp('WAIT_NUM_DSEC_RND') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript2HL.Func269: TtkTokenKind;
begin
  if KeyComp('WAIT_NB_DIZIEME_RND') then Result:= tkCommand else Result:= tkIdentifier;
end;