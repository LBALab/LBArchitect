//-- Keywords --

function TSynTrackScript1HL.Func57: TtkTokenKind;
begin
  if KeyComp('GOTO') then begin
    Result:= tkStatement;
    fPrevLabel:= True;
  end
  else Result:= tkIdentifier;
end;

function TSynTrackScript1HL.Func32: TtkTokenKind;
begin
  if KeyComp('LABEL') then begin
    Result:= tkStatement;
    fPrevLabel:= True;
  end
  else Result:= tkIdentifier;
end;

function TSynTrackScript1HL.Func70: TtkTokenKind;
begin
  if KeyComp('STOP') then Result := tkKey else Result := tkIdentifier;
end;

//-- Statements --

function TSynTrackScript1HL.Func23: TtkTokenKind;
begin
  if KeyComp('END') then Result := tkStatement else Result := tkIdentifier;
end;

//-- Commands --

function TSynTrackScript1HL.Func39: TtkTokenKind;
begin
  if KeyComp('ANGLE') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func106: TtkTokenKind;
begin
  if KeyComp('ANGLE_RND') or KeyComp('NO_BODY') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func37: TtkTokenKind;
begin
  if KeyComp('ANIM') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func96: TtkTokenKind;
begin
  if KeyComp('BACKGROUND') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func28: TtkTokenKind;
begin
  if KeyComp('BETA') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func46: TtkTokenKind;
begin
  if KeyComp('BODY') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func54: TtkTokenKind;
begin
  if KeyComp('CLOSE') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func92: TtkTokenKind;
begin
  if KeyComp('FACE_HERO') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func162: TtkTokenKind;
begin
  if KeyComp('GOTO_POINT') or KeyComp('REPEAT_SAMPLE') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func197: TtkTokenKind;
begin
  if KeyComp('GOTO_POINT_3D') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func250: TtkTokenKind;
begin
  if KeyComp('GOTO_SYM_POINT') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func137: TtkTokenKind;
begin
  if KeyComp('OPEN_DOWN') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func124: TtkTokenKind;
begin
  if KeyComp('OPEN_LEFT') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func140: TtkTokenKind;
begin
  if KeyComp('FACE_TWINKEL') then Result:= tkCommand else Result:= tkIdentifier;
end;

function TSynTrackScript1HL.Func143: TtkTokenKind;
begin
  if KeyComp('OPEN_RIGHT') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func118: TtkTokenKind;
begin
  if KeyComp('OPEN_UP') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func104: TtkTokenKind;
begin
  if KeyComp('PLAY_FLA') then begin
    Result := tkCommand;
    fPrevLabel:= True;
  end
  else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func155: TtkTokenKind;
begin
  if KeyComp('POS_POINT') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func66: TtkTokenKind;
begin
  if KeyComp('SAMPLE') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func178: TtkTokenKind;
begin
  if KeyComp('SAMPLE_ALWAYS') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func133: TtkTokenKind;
begin
  if KeyComp('SAMPLE_RND') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func167: TtkTokenKind;
begin
  if KeyComp('SAMPLE_STOP') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func168: TtkTokenKind;
begin
  if KeyComp('WAIT_NB_ANIM') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func191: TtkTokenKind;
begin
  if KeyComp('WAIT_NB_SECOND') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func171: TtkTokenKind;
begin
  if KeyComp('SIMPLE_SAMPLE') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func49: TtkTokenKind;
begin
  if KeyComp('SPEED') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func121: TtkTokenKind;
begin
  if KeyComp('WAIT_ANIM') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func136: TtkTokenKind;
begin
  if KeyComp('WAIT_DOOR') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func200: TtkTokenKind;
begin
  if KeyComp('WAIT_NUM_ANIM') then Result := tkCommand else Result := tkIdentifier;
end;

function TSynTrackScript1HL.Func223: TtkTokenKind;
begin
  if KeyComp('WAIT_NUM_SECOND') then Result := tkCommand else Result := tkIdentifier;
end;