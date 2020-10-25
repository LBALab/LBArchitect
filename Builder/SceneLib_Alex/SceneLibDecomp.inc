//***************************************************************************
// Little Big Architect: SceneLib unit - provides scene opening, script
//                                       de/compilation and saving routines
//
// Copyright (C) 2007 alexfont
// Copyright (C) 2007 Zink
//
// e-mail: alexandrefontoura@gmail.com
// e-mail: zink@poczta.onet.pl
//
// This source code is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This source code is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License (License.txt) for more details.
//***************************************************************************

// #########################################################
// ############### Decompilation routines ##################
// #########################################################

// MOVE SCRIPT

Procedure ResolveTrackOffsets(BinaryScript: String; ActorNum: Integer);
var Offset: Integer;
    Opcode: Byte;
    Finish: Boolean;
begin
  Finish:=False;
  Offset:=1; // string starts in position 1

  repeat
    Opcode := ReadStrByte(BinaryScript,Offset);

    Case Opcode of

      // Single Macros
      tsEND,        // 0 END
      tsNOP,        // 1 NOP
      tsWAIT_ANIM,  // 5 WAIT_ANIM
      tsLOOP,       // 6 LOOP
      tsSTOP,       // 11 STOP
      tsNO_BODY,    // 19 NO_BODY
      tsCLOSE,      // 25 CLOSE
      tsWAIT_DOOR:  // 26 WAIT_DOOR
      begin
        if Opcode = tsEND then
          Finish:=True;
        Inc(Offset);          
      end;

      // Macros with byte value
      tsBODY,           // 2 BODY
      tsANIM,           // 3 ANIM
      tsGOTO_POINT,     // 4 GOTO_POINT
      tsPOS_POINT,      // 8 POS_POINT
      tsLABEL,          // 9 LABEL
      tsGOTO_SYM_POINT, // 12 GOTO_SYM_POINT
      tsGOTO_POINT_3D,  // 15 GOTO_POINT_3D
      tsBACKGROUND:     // 17 BACKGROUND
      begin
        if Opcode = tsLABEL then
          TrackOffsets[ActorNum,ReadStrByte(BinaryScript,Offset+1)]:=Offset-1;
        Inc(Offset,2);        
      end;

      // Macros with word value
      tsANGLE,         // 7 ANGLE
      tsGOTO,          // 10 GOTO
      tsSAMPLE,        // 14 SAMPLE
      tsSPEED,         // 16 SPEED
      tsBETA,          // 20 BETA
      tsOPEN_LEFT,     // 21 OPEN_LEFT
      tsOPEN_RIGHT,    // 22 OPEN_RIGHT
      tsOPEN_UP,       // 23 OPEN_UP
      tsOPEN_DOWN,     // 24 OPEN_DOWN
      tsSAMPLE_RND,    // 27 SAMPLE_RND
      tsSAMPLE_ALWAYS, // 28 SAMPLE_ALWAYS
      tsSAMPLE_STOP,   // 29 SAMPLE_STOP
      tsREPEAT_SAMPLE, // 31 REPEAT_SAMPLE
      tsSIMPLE_SAMPLE, // 32 SIMPLE_SAMPLE
      tsFACE_HERO:  // 33 FACE_HERO
      begin
        Inc(Offset,3);
      end;

      // Special macros with different values

      tsWAIT_NUM_ANIM:   // 13 WAIT_NUM_ANIM  1 byte used, 1 byte dummy
      begin
        Inc(Offset,3);
      end;

      tsANGLE_RND:       // 34 ANGLE_RND (4 bytes)
      begin
        Inc(Offset,5); 
      end;

      tsWAIT_NUM_SECOND: // 18 WAIT_NB_SECOND  1 byte used, 4 byte dummy
      begin
        Inc(Offset,6); 
      end;

      tsPLAY_FLA: // 30 PLAY_FLA
      begin
        Inc(Offset,Length(ReadStrStr(BinaryScript,Offset)));
        //Offset:=Offset+2;
      end;

    Else
      Finish:=True; // if no valid command found then exit
    end;

  until Finish;
end;

Function DecompileTrackScript(BinaryScript: String): String;
var Offset: Integer;
    Finish: Boolean;
    Value: SmallInt;
    Opcode: Byte;
    TextScript, TmpString: String;
begin
  Finish:=False;
  Offset:=1; // string starts in position 1
  //Debug:=true;

  repeat
    Opcode := ReadStrByte(BinaryScript,Offset);

    if Debug = true then
      TextScript := TextScript+' '+IntToStr(Offset-1)+':'+TAB;

    Inc(Offset); 

    Case Opcode of

      // Single Macros
      tsEND,        // 0 END
      tsNOP,        // 1 NOP
      tsWAIT_ANIM,  // 5 WAIT_ANIM
      tsLOOP,       // 6 LOOP
      tsSTOP,       // 11 STOP
      tsNO_BODY,    // 19 NO_BODY
      tsCLOSE,      // 25 CLOSE
      tsWAIT_DOOR:  // 26 WAIT_DOOR
      begin
        TextScript:=TextScript+TrackList[Opcode];
        if Opcode = tsEND then
          Finish:=True;
      end;

      // Macros with byte value
      tsBODY,           // 2 BODY
      tsANIM,           // 3 ANIM
      tsGOTO_POINT,     // 4 GOTO_POINT
      tsPOS_POINT,      // 8 POS_POINT
      tsLABEL,          // 9 LABEL
      tsGOTO_SYM_POINT, // 12 GOTO_SYM_POINT
      tsGOTO_POINT_3D,  // 15 GOTO_POINT_3D
      tsBACKGROUND:     // 17 BACKGROUND
      begin
        Value:=ReadStrByte(BinaryScript,Offset);
        Inc(Offset);
        TextScript:=TextScript+TrackList[Opcode]+' '+IntToStr(Value);
      end;

      // Macros with word value
      tsANGLE,         // 7 ANGLE
      tsSAMPLE,        // 14 SAMPLE
      tsSPEED,         // 16 SPEED
      tsBETA,          // 20 BETA
      tsOPEN_LEFT,     // 21 OPEN_LEFT
      tsOPEN_RIGHT,    // 22 OPEN_RIGHT
      tsOPEN_UP,       // 23 OPEN_UP
      tsOPEN_DOWN,     // 24 OPEN_DOWN
      tsSAMPLE_RND,    // 27 SAMPLE_RND
      tsSAMPLE_ALWAYS, // 28 SAMPLE_ALWAYS
      tsSAMPLE_STOP,   // 29 SAMPLE_STOP
      tsREPEAT_SAMPLE, // 31 REPEAT_SAMPLE
      tsSIMPLE_SAMPLE, // 32 SIMPLE_SAMPLE
      tsFACE_HERO:     // 33 FACE_HERO
      begin
        Value:=ReadStrWord(BinaryScript,Offset);
        TextScript:=TextScript+TrackList[Opcode]+' '+IntToStr(Value);
        Inc(Offset,2);
      end;
      // separate to resolve the offsets
      tsGOTO: // 10 GOTO
      begin
        Value:=ReadStrWord(BinaryScript,Offset);
        if Debug = true then
           TextScript := TextScript+TrackList[Opcode]+' offset '+IntToStr(Value)
        else begin
           Value:=ReadStrByte(BinaryScript,Value+2);
           TextScript:=TextScript+TrackList[Opcode]+' '+IntToStr(Value);
        end;
        Inc(Offset,2);
      end;

      // Special macros with different values

      tsWAIT_NUM_ANIM:   // 13 WAIT_NUM_ANIM  1 byte used, 1 byte dummy
      begin
        Value:=ReadStrByte(BinaryScript,Offset);
        Inc(Offset,2);
        TextScript:=TextScript+TrackList[Opcode]+' '+IntToStr(Value);
      end;

      tsANGLE_RND:       // 34 ANGLE_RND (4 bytes)
      begin
        Value:=ReadStrWord(BinaryScript,Offset);
        Inc(Offset,4);
        TextScript:=TextScript+TrackList[Opcode]+' '+IntToStr(Value);
      end;

      tsWAIT_NUM_SECOND: // 18 WAIT_NB_SECOND  1 byte used, 4 byte dummy
      begin
        Value:=ReadStrByte(BinaryScript,Offset);
        Inc(Offset,5);
        TextScript:=TextScript+TrackList[Opcode]+' '+IntToStr(Value);
      end;

      tsPLAY_FLA: // 30 PLAY_FLA
      begin
        TmpString:=ReadStrStr(BinaryScript,Offset);
        Inc(Offset,Length(TmpString));
        TextScript:=TextScript+TrackList[Opcode]+' '+TmpString;
      end;

    Else
      Finish:=True; // if no valid command found then exit
    end;

    TextScript:=TextScript+CR;
    
  until Finish;

  Result:=TextScript;
end;



// LIFE SCRIPT

Procedure ResolveLifeOffsets(BinaryScript: String; ActorNum: Integer);
var Offset, AuxOffset,CurrentComportement, Value: Integer;
    Opcode, ConditionOpcode: Byte;
    Finish: Boolean;
begin
  Finish:=False;
  Offset:=1; // string starts in position 1
  CurrentComportement:=1;

  ComportementOffsets[ActorNum,0]:=0;

  repeat
    Opcode := ReadStrByte(BinaryScript,Offset);

    Case Opcode of

      // Single Macros
      lsEND,                // 0 END
      lsNOP,                // 1 NOP
      lsRETURN,             // 11 RETURN
      lsEND_COMPORTEMENT,   // 35 END_COMPORTAMENT
      lsSUICIDE,            // 38 SUICIDE
      lsUSE_ONE_LITTLE_KEY, // 39 USE_ONE_LITTLE_KEY
      lsEND_LIFE,           // 41 END_LIFE
      lsSTOP_L_TRACK,       // 42 STOP_L_TRACK
      lsRESTORE_L_TRACK,    // 43 RESTORE_L_TRACK
      lsINC_CHAPTER,        // 45 INC_CHAPTER
      lsINC_CLOVER_BOX,     // 66 INC_CLOVER_BOX
      lsFULL_POINT,         // 79 FULL_POINT
      lsGRM_OFF,            // 81 GRM_OFF
      lsFADE_PAL_RED,       // 82 FADE_PAL_RED
      lsFADE_ALARM_RED,     // 83 FADE_ALARM_RED
      lsFADE_ALARM_PAL,     // 84 FADE_ALARM_PAL
      lsFADE_RED_PAL,       // 85 FADE_RED_PAL
      lsFADE_RED_ALARM,     // 86 FADE_RED_ALARM
      lsFADE_PAL_ALARM,     // 87 FADE_PAL_ALARM
      lsBUBBLE_ON,           // 89 BUBBLE_ON
      lsBUBBLE_OFF,          // 90 BUBBLE_OFF
      lsSET_DARK_PAL,       // 92 SET_DARK_PAL
      lsSET_NORMAL_PAL,     // 93 SET_NORMAL_PAL
      lsMESSAGE_SENDELL,    // 94 MESSAGE_SENDELL
      lsGAME_OVER,          // 97 GAME_OVER
      lsTHE_END,            // 98 THE_END
      lsMIDI_OFF,           // 99 MIDI_OFF
      lsPROJ_ISO,       // 101 PROJ_ISO
      lsPROJ_3D,            // 102 PROJ_3D
      lsCLEAR_TEXT,         // 104 CLEAR_TEXT
      lsBRUTAL_EXIT:        // 105 BRUTAL_EXIT
      begin
        if Opcode = lsEND_COMPORTEMENT then begin
          // plus 1 because it will point to the next comportement
          ComportementOffsets[ActorNum,CurrentComportement]:=Offset;
          Inc(CurrentComportement);  
        end;
        if Opcode = lsEND then
          Finish:=True;
        Inc(Offset);          
      end;

      // Macros with byte value
      lsLABEL,              // 10 LABEL
      lsBODY,               // 17 BODY
      lsANIM,               // 19 ANIM
      lsFALLABLE,           // 26 FALLABLE
      lsCAM_FOLLOW,         // 29 CAM_FOLLOW
      lsSET_BEHAVIOR,       // 30 BEHAVIOR
      //lsCOMPORTEMENT,     // 32 COMPORTEMENT
      lsKILL_OBJ,           // 37 KILL_OBJ
      lsFOUND_OBJECT,       // 46 FOUND_OBJECT
      lsGIVE_BONUS,         // 51 GIVE_BONUS
      lsCHANGE_CUBE,        // 52 CHANGE_CUBE
      lsOBJ_COL,            // 53 OBJ_COL
      lsBRICK_COL,          // 54 BRICK_COL
      lsINVISIBLE,          // 56 INVISIBLE
      lsZOOM,               // 57 ZOOM
      lsPOS_POINT,          // 58 POS_POINT
      lsSET_MAGIC_LEVEL,    // 59 SET_MAGIC_LEVEL
      lsSUB_MAGIC_POINT,    // 60 SUB_MAGIC_POINT
      lsPLAY_MIDI,          // 65 PLAY_MIDI
      lsSET_USED_INVENTORY, // 67 SET_USED_INVENTORY
      lsINIT_PINGOUIN,      // 71 INIT_PINGOUIN
      lsSET_HOLO_POS,       // 72 SET_HOLO_POS
      lsCLR_HOLO_POS,       // 73 CLR_HOLO_POS
      lsADD_FUEL,           // 74 ADD_FUEL
      lsSUB_FUEL,           // 75 SUB_FUEL
      lsSET_GRM,            // 76 SET_GRM
      lsEXPLODE_OBJ,        // 88 EXPLODE_OBJ
      lsANIM_SET,           // 95 ANIM_SET
      lsHOLOMAP_TRAJ,       // 96 HOLOMAP_TRAJ
      lsPLAY_CD_TRACK:      // 100 PLAY_CD_TRACK
      begin
        Inc(Offset,2);        
      end;

      // Macros with word value
      lsOFFSET,           // 3 OFFSET
      lsSET_LIFE,         // 21 SET_LIFE
      lsSET_TRACK,        // 22 SET_TRACK
      lsMESSAGE,          // 25 MESSAGE
      lsSET_COMPORTEMENT, // 33 SET_COMPORTEMENT
      lsGIVE_GOLD_PIECES, // 40 GIVE_GOLD_PIECES
      lsSET_DOOR_LEFT,    // 47 SET_DOOR_LEFT
      lsSET_DOOR_RIGHT,   // 48 SET_DOOR_RIGHT
      lsSET_DOOR_UP,      // 49 SET_DOOR_UP
      lsSET_DOOR_DOWN,    // 50 SET_DOOR_DOWN
      lsADD_CHOICE,       // 68 ADD_CHOICE
      lsASK_CHOICE,       // 69 ASK_CHOICE
      lsBIG_MESSAGE,      // 70 BIG_MESSAGE
      lsSAY_MESSAGE,      // 77 SAY_MESSAGE
      lsBETA,             // 80 BETA
      lsTEXT:             // 103 TEXT
      begin
        Inc(Offset,3);
      end;

      // Macros with string value
      lsPLAY_FLA: // 64 PLAY_FLA
      begin
        Inc(Offset,Length(ReadStrStr(BinaryScript,Offset))+1);
      end;

      // Macros with 2 consecutives byte values
      lsBODY_OBJ,            // 18 BODY_OBJ
      lsANIM_OBJ,            // 20 ANIM_OBJ
      lsSET_FLAG_CUBE,       // 31 SET_FLAG_CUBE
      lsSET_FLAG_GAME,       // 36 SET_FLAG_GAME
      lsSET_LIFE_POINT_OBJ,  // 61 SET_LIFE_POINT_OBJ
      lsSUB_LIFE_POINT_OBJ,  // 62 SUB_LIFE_POINT_OBJ
      lsHIT_OBJ:             // 63 HIT_OBJ
      begin
        Inc(Offset,3);
      end;

      // Macros with 1 byte and 1 word
      lsSET_LIFE_OBJ,         // 22 SET_LIFE_OBJ
      lsSET_TRACK_OBJ,        // 24 SET_TRACK_OBJ
      lsSET_COMPORTEMENT_OBJ, // 34 SET_COMPORTEMENT_OBJ
      lsMESSAGE_OBJ,          // 44 MESSAGE_OBJ
      lsSAY_MESSAGE_OBJ,      // 78 SAY_MESSAGE_OBJ
      lsASK_CHOICE_OBJ:       // 91 ASK_CHOICE_OBJ
      begin
        Inc(Offset,4);
      end;

      // Macros with 3 byte values
      lsSET_DIRMODE: // 27 SET_DIRMODE
      begin
        Value:=ReadStrByte(BinaryScript,Offset+1);
        if Value = 2 then
          Inc(Offset,3)
        else
          Inc(Offset,2)
      end;

      lsSET_DIRMODE_OBJ: // 28 SET_DIRMODE_OBJ
      begin
        Value:=ReadStrByte(BinaryScript,Offset+2);
        if Value = 2 then
          Inc(Offset,4)
        else
          Inc(Offset,3)
      end;

      // Now the TRICKY part :)
      // -----------------------------------------------
      // Macros with conditions
      lsSNIF,    // 2 SNIF
      lsNEVERIF, // 4 NEVERIF     <---- RECHECK
      lsNO_IF,   // 6 NO_IF
      lsIF,      // 12 IF
      lsSWIF,    // 13 SWIF
      lsONEIF,   // 14 ONEIF
      lsOR_IF:   // 55 OR_IF
      begin
        AuxOffset:=0;
        ConditionOpcode:=ReadStrByte(BinaryScript,Offset+1);

        Case ConditionOpcode of

          // single macros [OP] 1 byte  + 2 pffset
					csCOL,               // 0 COL
					csZONE,              // 3 ZONE
					csBODY,              // 5 BODY
					csANIM,              // 7 ANIM
					csL_TRACK,           // 9 L_TRACK
					csHIT_BY,            // 13 HIT_BY
					csACTION,            // 14 ACTION
					csLIFE_POINT,        // 16 LIFE_POINT
					csNUM_LITTLE_KEYS,   // 18 NUM_LITTLE_KEYS
					csBEHAVIOR,          // 20 BEHAVIOR
					csCHAPTER,           // 21 CHAPTER
					csFUEL,              // 27 FUEL
          csCARRIED_BY,          // 28 CARRIED_BY
          csCDROM:             // 29 CDROM
          begin
            AuxOffset:=6;
          end;

          // single macros [OP] 2 bytes  + 2 pffset
					csNUM_GOLD_PIECES, // 19 NUM_GOLD_PIECES
					csCHOICE:          // 26 CHOICE
          begin
            AuxOffset:=7;
          end;

          // macros with value [OP] 1 byte  + 2 pffset
					csCOL_OBJ,        // 1 COL_OBJ
					csZONE_OBJ,       // 4 ZONE_OBJ
					csBODY_OBJ,       // 6 BODY_OBJ
					csANIM_OBJ,       // 8 ANIM_OBJ
					csL_TRACK_OBJ,    // 10 L_TRACK_OBJ
					csFLAG_CUBE,      // 11 FLAG_CUBE
					csFLAG_GAME,      // 15 FLAG_GAME
					csLIFE_POINT_OBJ, // 17 LIFE_POINT_OBJ
					csUSE_INVENTORY:  // 25 USE_INVENTORY
					begin
            AuxOffset:=7;
          end;

          // macros with value [OP] 2 bytes + 2 pffset
					csDISTANCE,    // 2 DISTANCE
					csCONE_VIEW,   // 12 CONE_VIEW
					csDISTANCE_3D: // 22 DISTANCE_3D
					begin
            AuxOffset:=8;
          end;

        end;
        Inc(Offset,AuxOffset);

      end;

      lsELSE: // 15 ELSE
      begin
        Inc(Offset,3);
      end;

    Else
      Finish:=True; // if no valid command found then exit
    end;

  until Finish;     
end;

Function IndentScript(Indent:Integer):String;
var a:Integer;
begin
  if Indent >= 1 then begin
    for a:=0 to Indent-1 do
      if a = 0 then
        Result:='  '
      else
        Result:=Result+'  '
    end
  else
    Result:='';
end;

Function GetComportementObjectIndex(Offset,Actor: Integer): Integer;
var a:Integer;
begin
  for a:=0 to COMP_NUM_MAX do begin
    if ComportementOffsets[Actor][a]=Offset then begin
      Result:=a;
      Exit;
    end;
  end;
  Result:=-1;
end;

Function GetTrackObjectIndex(Offset,Actor: Integer): Integer;
var a:Integer;
begin
  for a:=0 to TRACK_NUM_MAX do begin
    if TrackOffsets[Actor][a]=Offset then begin
      Result:=a;
      Exit;
    end;
  end;
  Result:=-1;
end;

Function FindOffset(IndentIndex:Integer; IndentOffsets: array of Integer; CurrentOffset:Integer): Boolean;
var a:Integer;
begin
  for a:=0 to IndentIndex do begin
    if IndentOffsets[a]=CurrentOffset then begin
      Result:=True;
      Exit;
    end;
  end;
  Result:=False;
end;

Function DecompileLifeScript(BinaryScript: String; Actor: Integer): String;
var Offset, CurrentComportement, Value, Value2, Value3, Indent, IndentIndex,IndentIndex2: Integer;
    Opcode, ConditionOpcode, OperatorOpcode: Byte;
    Finish, EndComportement: Boolean;
    TextScript, TmpString, Indentation: String;
    IndentOffsets,IndentOffsets2: array[0..499] of Integer;
begin
  Finish:=False;
  Indent:=0;
  IndentIndex:=0;
  IndentIndex2:=0;  
  Offset:=1; // string starts in position 1
  CurrentComportement:=0;
  //Debug:=true;

  repeat
    EndComportement := False;

    Value:=ReadStrByte(BinaryScript,Offset);
    if Value <> 0 then begin
      if Debug = true then
	      TextScript := TextScript+IntToStr(Offset-1)+':'+TAB;
      TextScript:=TextScript+'COMPORTEMENT '+IntToStr(CurrentComportement)+CR;
      Indent:=1;
    end;

    repeat
      Opcode := ReadStrByte(BinaryScript,Offset);

      if Opcode = lsEND_COMPORTEMENT then
        Indent:=0
      else if Opcode = lsEND then
        Indent:=0
      else if Opcode = lsELSE then
        Dec(Indent);

      Indentation:=IndentScript(Indent);

	    if Debug = True then
	      TextScript := TextScript+IntToStr(Offset-1)+':'+TAB;

      Inc(Offset);
      
	    Case Opcode of

	      // Single Macros
	      lsEND,                // 0 END
	      lsNOP,                // 1 NOP
	      lsRETURN,             // 11 RETURN
	      lsEND_COMPORTEMENT,   // 35 END_COMPORTAMENT
	      lsSUICIDE,            // 38 SUICIDE
	      lsUSE_ONE_LITTLE_KEY, // 39 USE_ONE_LITTLE_KEY
	      lsEND_LIFE,           // 41 END_LIFE
	      lsSTOP_L_TRACK,       // 42 STOP_L_TRACK
	      lsRESTORE_L_TRACK,    // 43 RESTORE_L_TRACK
	      lsINC_CHAPTER,        // 45 INC_CHAPTER
	      lsINC_CLOVER_BOX,     // 66 INC_CLOVER_BOX
	      lsFULL_POINT,         // 79 FULL_POINT
	      lsGRM_OFF,            // 81 GRM_OFF
	      lsFADE_PAL_RED,       // 82 FADE_PAL_RED
	      lsFADE_ALARM_RED,     // 83 FADE_ALARM_RED
	      lsFADE_ALARM_PAL,     // 84 FADE_ALARM_PAL
	      lsFADE_RED_PAL,       // 85 FADE_RED_PAL
	      lsFADE_RED_ALARM,     // 86 FADE_RED_ALARM
	      lsFADE_PAL_ALARM,     // 87 FADE_PAL_ALARM
	      lsBUBBLE_ON,           // 89 BUBBLE_ON
	      lsBUBBLE_OFF,          // 90 BUBBLE_OFF
	      lsSET_DARK_PAL,       // 92 SET_DARK_PAL
	      lsSET_NORMAL_PAL,     // 93 SET_NORMAL_PAL
	      lsMESSAGE_SENDELL,    // 94 MESSAGE_SENDELL
	      lsGAME_OVER,          // 97 GAME_OVER
	      lsTHE_END,            // 98 THE_END
	      lsMIDI_OFF,           // 99 MIDI_OFF
	      lsPROJ_ISO,           // 101 PROJ_ISO
	      lsPROJ_3D,            // 102 PROJ_3D
	      lsCLEAR_TEXT,         // 104 CLEAR_TEXT
	      lsBRUTAL_EXIT:        // 105 BRUTAL_EXIT
	      begin
		      if Opcode = lsEND_COMPORTEMENT then
            EndComportement:=True;
		      if Opcode = lsEND then begin
		        Finish:=True;
            EndComportement:=True;
          end;
          TextScript:=TextScript+Indentation+LifeList[Opcode];
	      end;

	      // Macros with byte value
	      lsLABEL,              // 10 LABEL
	      lsBODY,               // 17 BODY
	      lsANIM,               // 19 ANIM
	      lsFALLABLE,           // 26 FALLABLE
	      lsCAM_FOLLOW,         // 29 CAM_FOLLOW
	      lsSET_BEHAVIOR,       // 30 SET_BEHAVIOR
	      //lsCOMPORTEMENT,     // 32 COMPORTEMENT
	      lsKILL_OBJ,           // 37 KILL_OBJ
	      lsFOUND_OBJECT,       // 46 FOUND_OBJECT
	      lsGIVE_BONUS,         // 51 GIVE_BONUS
	      lsCHANGE_CUBE,        // 52 CHANGE_CUBE
	      lsOBJ_COL,            // 53 OBJ_COL
	      lsBRICK_COL,          // 54 BRICK_COL
	      lsINVISIBLE,          // 56 INVISIBLE
	      lsZOOM,               // 57 ZOOM
	      lsPOS_POINT,          // 58 POS_POINT
	      lsSET_MAGIC_LEVEL,    // 59 SET_MAGIC_LEVEL
	      lsSUB_MAGIC_POINT,    // 60 SUB_MAGIC_POINT
	      lsPLAY_MIDI,          // 65 PLAY_MIDI
	      lsSET_USED_INVENTORY, // 67 SET_USED_INVENTORY
	      lsINIT_PINGOUIN,      // 71 INIT_PINGOUIN
	      lsSET_HOLO_POS,       // 72 SET_HOLO_POS
	      lsCLR_HOLO_POS,       // 73 CLR_HOLO_POS
	      lsADD_FUEL,           // 74 ADD_FUEL
	      lsSUB_FUEL,           // 75 SUB_FUEL
	      lsSET_GRM,            // 76 SET_GRM
	      lsEXPLODE_OBJ,        // 88 EXPLODE_OBJ
	      lsANIM_SET,           // 95 ANIM_SET
	      lsHOLOMAP_TRAJ,       // 96 HOLOMAP_TRAJ
	      lsPLAY_CD_TRACK:      // 100 PLAY_CD_TRACK
	      begin
          Value:=ReadStrByte(BinaryScript,Offset);
          if Opcode = lsSET_BEHAVIOR then
            TextScript:=TextScript+Indentation+LifeList[Opcode]+' '+BehaviorList[Value]
          else
            TextScript:=TextScript+Indentation+LifeList[Opcode]+' '+IntToStr(Value);
		      Inc(Offset);
	      end;

	      // Macros with word value
	      lsOFFSET,           // 3 OFFSET
	      //lsSET_LIFE,         // 21 SET_LIFE
	      lsSET_TRACK,        // 23 SET_TRACK
	      lsMESSAGE,          // 25 MESSAGE
	      lsSET_COMPORTEMENT, // 33 SET_COMPORTEMENT
	      lsGIVE_GOLD_PIECES, // 40 GIVE_GOLD_PIECES
	      lsSET_DOOR_LEFT,    // 47 SET_DOOR_LEFT
	      lsSET_DOOR_RIGHT,   // 48 SET_DOOR_RIGHT
	      lsSET_DOOR_UP,      // 49 SET_DOOR_UP
	      lsSET_DOOR_DOWN,    // 50 SET_DOOR_DOWN
	      lsADD_CHOICE,       // 68 ADD_CHOICE
	      lsASK_CHOICE,       // 69 ASK_CHOICE
	      lsBIG_MESSAGE,      // 70 BIG_MESSAGE
	      lsSAY_MESSAGE,      // 77 SAY_MESSAGE
	      lsBETA,             // 80 BETA
	      lsTEXT:             // 103 TEXT
	      begin
          Value:=ReadStrWord(BinaryScript,Offset);
          if Debug <> True then begin
            if Opcode=lsSET_COMPORTEMENT then
              Value:=GetComportementObjectIndex(Value,Actor);
            if Opcode=lsSET_TRACK then
              Value:=GetTrackObjectIndex(Value,Actor);
          end;
          TextScript:=TextScript+Indentation+LifeList[Opcode]+' '+IntToStr(Value);
		      Inc(Offset,2);
	      end;

	      // Macros with string value
	      lsPLAY_FLA: // 64 PLAY_FLA
	      begin
          TmpString:=ReadStrStr(BinaryScript,Offset);
          TextScript:=TextScript+Indentation+LifeList[Opcode]+' '+TmpString;
		      Inc(Offset,Length(TmpString)+1);
	      end;

	      // Macros with 2 consecutives byte values
	      lsBODY_OBJ,            // 18 BODY_OBJ
	      lsANIM_OBJ:            // 20 ANIM_OBJ
        begin
      		Value:=ReadStrByte(BinaryScript,Offset); // actor
          Value2:=ReadStrByte(BinaryScript,Offset+1);
          TextScript:=TextScript+Indentation+LifeList[Opcode]+' '+IntToStr(Value2)+' '+IntToStr(Value);
		      Inc(Offset,2);
	      end;

        // Macros with 2 consecutives byte values
	      lsSET_FLAG_CUBE,       // 31 SET_FLAG_CUBE
	      lsSET_FLAG_GAME,       // 36 SET_FLAG_GAME
	      lsSET_LIFE_POINT_OBJ,  // 61 SET_LIFE_POINT_OBJ
	      lsSUB_LIFE_POINT_OBJ,  // 62 SUB_LIFE_POINT_OBJ
	      lsHIT_OBJ:             // 63 HIT_OBJ
	      begin
      		Value:=ReadStrByte(BinaryScript,Offset); // actor
          Value2:=ReadStrByte(BinaryScript,Offset+1);
          TextScript:=TextScript+Indentation+LifeList[Opcode]+' '+IntToStr(Value)+' '+IntToStr(Value2);
		      Inc(Offset,2);
	      end;

	      // Macros with 1 byte and 1 word
	      //lsSET_LIFE_OBJ,         // 22 SET_LIFE_OBJ
	      lsSET_TRACK_OBJ,        // 24 SET_TRACK_OBJ
	      lsSET_COMPORTEMENT_OBJ, // 34 SET_COMPORTEMENT_OBJ
	      lsMESSAGE_OBJ,          // 44 MESSAGE_OBJ
	      lsSAY_MESSAGE_OBJ,      // 78 SAY_MESSAGE_OBJ
	      lsASK_CHOICE_OBJ:       // 91 ASK_CHOICE_OBJ
	      begin
		      Value:=ReadStrByte(BinaryScript,Offset); // actor
          Value2:=ReadStrWord(BinaryScript,Offset+1);
          if Opcode=lsSET_COMPORTEMENT_OBJ then
            Value2:=GetComportementObjectIndex(Value2,Value);
          if Opcode=lsSET_TRACK_OBJ then
            Value2:=GetTrackObjectIndex(Value2,Value);
          TextScript:=TextScript+Indentation+LifeList[Opcode]+' '+IntToStr(Value)+' '+IntToStr(Value2);
		      Inc(Offset,3);
	      end;

	      // Macros with 3 byte values
	      lsSET_DIRMODE: // 27 SET_DIRMODE
	      begin
		     Value:=ReadStrByte(BinaryScript,Offset); // mode
         if Value = 2 then begin
           Value2:=ReadStrByte(BinaryScript,Offset+1); // actor to follow
           TextScript:=TextScript+Indentation+LifeList[Opcode]+' '+DirModeList[Value]+' '+IntToStr(Value2);
		       Inc(Offset,2);
         end
         else begin
           TextScript:=TextScript+Indentation+LifeList[Opcode]+' '+DirModeList[Value];
		       Inc(Offset,1);
         end
	      end;

	      lsSET_DIRMODE_OBJ: // 28 SET_DIRMODE_OBJ
	      begin
		      Value:=ReadStrByte(BinaryScript,Offset); // actor
          Value2:=ReadStrByte(BinaryScript,Offset+1); // mode
		      if Value2 = 2 then begin // mode = 2
            Value3:=ReadStrByte(BinaryScript,Offset+2); // actor to follow
            TextScript:=TextScript+Indentation+LifeList[Opcode]+' '+DirModeList[Value]+' '+IntToStr(Value2)+' '+IntToStr(Value3);
		        Inc(Offset,3);
          end
          else begin
            TextScript:=TextScript+Indentation+LifeList[Opcode]+' '+DirModeList[Value]+' '+IntToStr(Value2);
		        Inc(Offset,2);
          end
	      end;

	      // Now the TRICKY part :)
	      // -----------------------------------------------
	      // Macros with conditions
	      lsSNIF,    // 2 SNIF
	      lsNEVERIF, // 4 NEVERIF
	      lsNO_IF,   // 6 NO_IF
	      lsIF,      // 12 IF
	      lsSWIF,    // 13 SWIF
	      lsONEIF,   // 14 ONEIF
	      lsOR_IF:   // 55 OR_IF
	      begin
          // don't indent the code for OR_IF condition
          if Opcode <> lsOR_IF then
            Inc(Indent);

          // Get condition opcode
		      ConditionOpcode:=ReadStrByte(BinaryScript,Offset);
          Inc(Offset);

          TextScript:=TextScript+Indentation+LifeList[Opcode]+' '+ConditionList[ConditionOpcode]+' ';

		      Case ConditionOpcode of

		        // single macros [OP] 1 byte  + 2 offset
						csCOL,               // 0 COL
						csZONE,              // 3 ZONE
						csBODY,              // 5 BODY
						csANIM,              // 7 ANIM
						csL_TRACK,           // 9 L_TRACK
						csHIT_BY,            // 13 HIT_BY
						csACTION,            // 14 ACTION
						csLIFE_POINT,        // 16 LIFE_POINT
						csNUM_LITTLE_KEYS,   // 18 NUM_LITTLE_KEYS
						csBEHAVIOR,          // 20 BEHAVIOR
						csCHAPTER,           // 21 CHAPTER
						csFUEL,              // 27 FUEL
		        csCARRIED_BY,        // 28 CARRIED_BY
		        csCDROM:             // 29 CDROM
		        begin
              OperatorOpcode:=ReadStrByte(BinaryScript,Offset);
              Inc(Offset);
              Value:=ReadStrByte(BinaryScript,Offset);
              Inc(Offset);

              if ConditionOpcode = csBEHAVIOR then
                TextScript:=TextScript+OperatorsList[OperatorOpcode]+' '+BehaviorList[Value]
              else
                TextScript:=TextScript+OperatorsList[OperatorOpcode]+' '+IntToStr(Value);
		        end;

		        // single macros [OP] 2 bytes  + 2 offset
						csNUM_GOLD_PIECES, // 19 NUM_GOLD_PIECES
						csCHOICE:          // 26 CHOICE
            begin
              OperatorOpcode:=ReadStrByte(BinaryScript,Offset);
              Inc(Offset);
              Value:=ReadStrWord(BinaryScript,Offset);
              Inc(Offset,2);

              TextScript:=TextScript+OperatorsList[OperatorOpcode]+' '+IntToStr(Value);
		        end;

		        // macros with value [OP] 1 byte  + 2 offset
						csCOL_OBJ,        // 1 COL_OBJ
						csZONE_OBJ,       // 4 ZONE_OBJ
						csBODY_OBJ,       // 6 BODY_OBJ
						csANIM_OBJ,       // 8 ANIM_OBJ
						csL_TRACK_OBJ,    // 10 L_TRACK_OBJ
						csFLAG_CUBE,      // 11 FLAG_CUBE
						csFLAG_GAME,      // 15 FLAG_GAME
						csLIFE_POINT_OBJ, // 17 LIFE_POINT_OBJ
						csUSE_INVENTORY:  // 25 USE_INVENTORY
						begin
              Value:=ReadStrByte(BinaryScript,Offset);
              Inc(Offset);
              OperatorOpcode:=ReadStrByte(BinaryScript,Offset);
              Inc(Offset);
              Value2:=ReadStrByte(BinaryScript,Offset);
              Inc(Offset);

              TextScript:=TextScript+IntToStr(Value)+' '+OperatorsList[OperatorOpcode]+' '+IntToStr(Value2);
		        end;

		        // macros with value [OP] 2 bytes + 2 offset
						csDISTANCE,    // 2 DISTANCE
						csCONE_VIEW,   // 12 CONE_VIEW
						csDISTANCE_3D: // 22 DISTANCE_3D
						begin
              Value:=ReadStrByte(BinaryScript,Offset);
              Inc(Offset);
              OperatorOpcode:=ReadStrByte(BinaryScript,Offset);
              Inc(Offset);
              Value2:=ReadStrWord(BinaryScript,Offset);
              Inc(Offset,2);

              TextScript:=TextScript+IntToStr(Value)+' '+OperatorsList[OperatorOpcode]+' '+IntToStr(Value2);
		        end;

		      end;

          // Get conditions offsets
          Value:=ReadStrWord(BinaryScript,Offset);
          Inc(Offset,2);

          if Opcode <> lsOR_IF then begin
            Inc(IndentIndex);
            IndentOffsets[IndentIndex]:=Value;
          end;

          if Debug = True then
            TextScript:=TextScript+' else goto '+IntToStr(Value)

	      end;

	      lsELSE: // 15 ELSE
	      begin
          Inc(Indent);
          
          Value:=ReadStrWord(BinaryScript,Offset);
		      Inc(Offset,2);

          Inc(IndentIndex2);
          IndentOffsets2[IndentIndex2]:=Value;

          TextScript:=TextScript+Indentation+LifeList[Opcode];

          if Debug = True then
            TextScript:=TextScript+' goto '+IntToStr(Value)
	      end;

	      Else begin
	        Finish:=True; // if no valid command found then exit
          EndComportement:=True;
        end;
	    end;

      TextScript:=TextScript+CR;

      // WARNING: Very tricky code to solve right indentation
      
      // RESOLVE ENDIF block for IF and other conditions
      while FindOffset(IndentIndex,IndentOffsets,Offset-1)=True do
      begin
        if IndentIndex > 0 then
          Dec(IndentIndex)
        else
          IndentIndex := 0;

        If Opcode <> lsElse then begin
          if Indent > 0 then
            Dec(Indent)
          else
            Indent:=0;

          Indentation:=IndentScript(Indent);

          if Debug = True then
            TextScript:=TextScript+IntToStr(Offset-1)+':'+TAB;
          TextScript:=TextScript+Indentation+LifeList[16]+CR;
        end;
      end;

      // RESOLVE ENDIF block for ELSE
      while FindOffset(IndentIndex2,IndentOffsets2,Offset-1)=True do
      begin
        if IndentIndex2 > 0 then
          Dec(IndentIndex2)
        else
          IndentIndex2 := 0;

        if Indent > 0 then
          Dec(Indent)
        else
          Indent:=0;

        Indentation:=IndentScript(Indent);

        if Debug = True then
          TextScript:=TextScript+IntToStr(Offset-1)+':'+TAB;
        TextScript:=TextScript+Indentation+LifeList[16]+CR;
      end;

    until EndComportement;

    Inc(CurrentComportement);

  until Finish;

  Result:=TextScript;     
end;

