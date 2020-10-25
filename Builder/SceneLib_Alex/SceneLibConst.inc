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

type
  // Structures used for both LBA1 and LBA2
  // --------------------------------------
  
  // Actor structure
  TActor = record
    Name: string;
    StaticFlags: WORD;
    Unknown: WORD; // LBA2 flags ??
    Entity: WORD;
    Body: Byte;
    Animation: Byte;
    SpriteEntry: WORD;
    X: SmallInt;
    Y: SmallInt;
    Z: SmallInt;
    StrengthOfHit: Byte;
    BonusParameter: WORD;
    BetaAngle: WORD;
    SpeedRotation: WORD;
    ControlMode: WORD;
    Info0: SmallInt; // for multiple uses
    Info1: SmallInt;
    Info2: SmallInt;
    Info3: SmallInt;
    BonusAmount: WORD;
    TalkColor: Byte;
    Armour: Byte;
    LifePoints: Byte;
    MoveScript: string;
    LifeScript: string;
  end;
  
  TZone = record
    X1: SmallInt;
    Unknown1: WORD; // LBA2 unknown var
    Y1: SmallInt;
    Unknown2: WORD; // LBA2 unknown var
    Z1: SmallInt;
    Unknown3: WORD; // LBA2 unknown var
    X2: SmallInt;
    Unknown4: WORD; // LBA2 unknown var
    Y2: SmallInt;
    Unknown5: WORD; // LBA2 unknown var
    Z2: SmallInt;
    Unknown6: WORD; // LBA2 unknown var
    ZoneType: WORD;
    Unknown7: WORD; // LBA2 unknown var
    Info0: WORD;
    Unknown8: WORD; // LBA2 unknown var
    Info1: WORD;
    Unknown9: WORD; // LBA2 unknown var
    Info2: WORD;
    Unknown10: WORD; // LBA2 unknown var
    Info3: WORD;
    Unknown11: WORD; // LBA2 unknown var
    Info4: WORD;
    Unknown12: WORD; // LBA2 unknown var
    Info5: WORD;
    Unknown13: WORD; // LBA2 unknown var
    Info6: WORD;
    Unknown14: WORD; // LBA2 unknown var
    Snap: WORD;
    Unknown15: WORD; // LBA2 unknown var
  end;
  
  TTrack = record
    X: SmallInt;
    Unknown1: WORD; // LBA2 unknown var
    Y: SmallInt;
    Unknown2: WORD; // LBA2 unknown var
    Z: SmallInt;
    Unknown3: WORD; // LBA2 unknown var
  end;
  
  // Our hero structure
  THero = record
    X: SmallInt;
    Y: SmallInt;
    Z: SmallInt;
    MoveScript: string; // decomp string
    LifeScript: string; // decomp string
  end;
  
  // Main scene structure definitions
  TScene = record
    IsleNumber: Byte;
    GameOverScene: Byte;
    UnUsed1: WORD;
    UnUsed2: WORD;
    AlphaLight: WORD;
    BetaLight: WORD;
    SampleAmbience1: SmallInt; // Amb0_1
    SampleRepeat1: SmallInt;   // Amb0_2
    SampleRound1: SmallInt;    // Amb0_3
    SampleUnknown11: SmallInt; // Amb0_4
    SampleUnknown12: SmallInt; // Amb0_5
    SampleAmbience2: SmallInt; // Amb1_1
    SampleRepeat2: SmallInt;   // Amb1_2
    SampleRound2: SmallInt;    // Amb1_3
    SampleUnknown21: SmallInt; // Amb1_4
    SampleUnknown22: SmallInt; // Amb1_5
    SampleAmbience3: SmallInt; // Amb2_1
    SampleRepeat3: SmallInt;   // Amb2_2
    SampleRound3: SmallInt;    // Amb2_3
    SampleUnknown31: SmallInt; // Amb2_4
    SampleUnknown32: SmallInt; // Amb2_5
    SampleAmbience4: SmallInt; // Amb3_1
    SampleRepeat4: SmallInt;   // Amb3_2
    SampleRound4: SmallInt;    // Amb3_3
    SampleUnknown41: SmallInt; // Amb3_4
    SampleUnknown42: SmallInt; // Amb3_5
    MinDelay: WORD;            // Minimun Delay
    MinDelayRnd: WORD;         // Minimun Delay Random Range
    MusicIndex: Byte;

    Hero: THero;
    Actors: array of TActor;
    Zones: array of TZone;
    Tracks: array of TTrack;
  end;
  
  TScript = record
    NumOffsets: WORD;
    Script: string;
  end;

  Scene = array of TScene;

const

// ######## CONST ########

COMP_NUM_MAX = 49;
TRACK_NUM_MAX = 255;

CR  = #$0D#$0A;
TAB = #$09;

// TRACK CONSTANT
tsEND = 0;
tsNOP = 1;
tsBODY = 2;
tsANIM = 3;
tsGOTO_POINT = 4;
tsWAIT_ANIM = 5;
tsLOOP = 6;
tsANGLE = 7;
tsPOS_POINT = 8;
tsLABEL = 9;
tsGOTO = 10;
tsSTOP = 11;
tsGOTO_SYM_POINT = 12;
tsWAIT_NUM_ANIM = 13;
tsSAMPLE = 14;
tsGOTO_POINT_3D = 15;
tsSPEED = 16;
tsBACKGROUND = 17;
tsWAIT_NUM_SECOND = 18;
tsNO_BODY = 19;
tsBETA = 20;
tsOPEN_LEFT = 21;
tsOPEN_RIGHT = 22;
tsOPEN_UP = 23;
tsOPEN_DOWN = 24;
tsCLOSE = 25;
tsWAIT_DOOR = 26;
tsSAMPLE_RND = 27;
tsSAMPLE_ALWAYS = 28;
tsSAMPLE_STOP = 29;
tsPLAY_FLA = 30;
tsREPEAT_SAMPLE = 31;
tsSIMPLE_SAMPLE = 32;
tsFACE_HERO = 33;
tsANGLE_RND = 34;

// LIFE CONSTANT

lsEND = 0;
lsNOP = 1;
lsSNIF = 2;
lsOFFSET = 3;
lsNEVERIF = 4;
lsNO_IF = 6;
lsLABEL = 10;
lsRETURN = 11;
lsIF = 12;
lsSWIF = 13;
lsONEIF = 14;
lsELSE = 15;
lsENDIF = 16;
lsBODY = 17;
lsBODY_OBJ = 18;
lsANIM = 19;
lsANIM_OBJ = 20;
lsSET_LIFE = 21;
lsSET_LIFE_OBJ = 22;
lsSET_TRACK = 23;
lsSET_TRACK_OBJ = 24;
lsMESSAGE = 25;
lsFALLABLE = 26;
lsSET_DIRMODE = 27;
lsSET_DIRMODE_OBJ = 28;
lsCAM_FOLLOW = 29;
lsSET_BEHAVIOR = 30;
lsSET_FLAG_CUBE = 31;
lsCOMPORTEMENT = 32;
lsSET_COMPORTEMENT = 33;
lsSET_COMPORTEMENT_OBJ = 34;
lsEND_COMPORTEMENT = 35;
lsSET_FLAG_GAME = 36;
lsKILL_OBJ = 37;
lsSUICIDE = 38;
lsUSE_ONE_LITTLE_KEY = 39;
lsGIVE_GOLD_PIECES = 40;
lsEND_LIFE = 41;
lsSTOP_L_TRACK = 42;
lsRESTORE_L_TRACK = 43;
lsMESSAGE_OBJ = 44;
lsINC_CHAPTER = 45;
lsFOUND_OBJECT = 46;
lsSET_DOOR_LEFT = 47;
lsSET_DOOR_RIGHT = 48;
lsSET_DOOR_UP = 49;
lsSET_DOOR_DOWN = 50;
lsGIVE_BONUS = 51;
lsCHANGE_CUBE = 52;
lsOBJ_COL = 53;
lsBRICK_COL = 54;
lsOR_IF = 55;
lsINVISIBLE = 56;
lsZOOM = 57;
lsPOS_POINT = 58;
lsSET_MAGIC_LEVEL = 59;
lsSUB_MAGIC_POINT = 60;
lsSET_LIFE_POINT_OBJ = 61;
lsSUB_LIFE_POINT_OBJ = 62;
lsHIT_OBJ = 63;
lsPLAY_FLA = 64;
lsPLAY_MIDI = 65;
lsINC_CLOVER_BOX = 66;
lsSET_USED_INVENTORY = 67;
lsADD_CHOICE = 68;
lsASK_CHOICE = 69;
lsBIG_MESSAGE = 70;
lsINIT_PINGOUIN = 71;
lsSET_HOLO_POS = 72;
lsCLR_HOLO_POS = 73;
lsADD_FUEL = 74;
lsSUB_FUEL = 75;
lsSET_GRM = 76;
lsSAY_MESSAGE = 77;
lsSAY_MESSAGE_OBJ = 78;
lsFULL_POINT = 79;
lsBETA = 80;
lsGRM_OFF = 81;
lsFADE_PAL_RED = 82;
lsFADE_ALARM_RED = 83;
lsFADE_ALARM_PAL = 84;
lsFADE_RED_PAL = 85;
lsFADE_RED_ALARM = 86;
lsFADE_PAL_ALARM = 87;
lsEXPLODE_OBJ = 88;
lsBUBBLE_ON = 89;
lsBUBBLE_OFF = 90;
lsASK_CHOICE_OBJ = 91;
lsSET_DARK_PAL = 92;
lsSET_NORMAL_PAL = 93;
lsMESSAGE_SENDELL = 94;
lsANIM_SET = 95;
lsHOLOMAP_TRAJ = 96;
lsGAME_OVER = 97;
lsTHE_END = 98;
lsMIDI_OFF = 99;
lsPLAY_CD_TRACK = 100;
lsPROJ_ISO = 101;
lsPROJ_3D = 102;
lsTEXT = 103;
lsCLEAR_TEXT = 104;
lsBRUTAL_EXIT = 105;

// CONDITION CONSTANT

csCOL = 0;
csCOL_OBJ = 1;
csDISTANCE = 2;
csZONE = 3;
csZONE_OBJ = 4;
csBODY = 5;
csBODY_OBJ = 6;
csANIM = 7;
csANIM_OBJ = 8;
csL_TRACK = 9;
csL_TRACK_OBJ = 10;
csFLAG_CUBE = 11;
csCONE_VIEW = 12;
csHIT_BY = 13;
csACTION = 14;
csFLAG_GAME = 15;
csLIFE_POINT = 16;
csLIFE_POINT_OBJ = 17;
csNUM_LITTLE_KEYS = 18;
csNUM_GOLD_PIECES = 19;
csBEHAVIOR = 20;
csCHAPTER = 21;
csDISTANCE_3D = 22;
csUSE_INVENTORY = 25;
csCHOICE = 26;
csFUEL = 27;
csCARRIED_BY = 28;
csCDROM = 29;



// ######## ARRAYS ########

// Track Macro List
TrackList : array [0..34] of String =
(
  'END',
  'NOP',
  'BODY',
  'ANIM',
  'GOTO_POINT',
  'WAIT_ANIM',
  'LOOP',
  'ANGLE',
  'POS_POINT',
  'LABEL',
  'GOTO',
  'STOP',
  'GOTO_SYM_POINT',
  'WAIT_NUM_ANIM',
  'SAMPLE',
  'GOTO_POINT_3D',
  'SPEED',
  'BACKGROUND',
  'WAIT_NUM_SECOND',
  'NO_BODY',
  'BETA',
  'OPEN_LEFT',
  'OPEN_RIGHT',
  'OPEN_UP',
  'OPEN_DOWN',
  'CLOSE',
  'WAIT_DOOR',
  'SAMPLE_RND',
  'SAMPLE_ALWAYS',
  'SAMPLE_STOP',
  'PLAY_FLA',
  'REPEAT_SAMPLE',
  'SIMPLE_SAMPLE',
  'FACE_HERO',
  'ANGLE_RND'
);

// Life Macro List

LifeList : array [0..105] of String =
(
  'END',
  'NOP',
  'SNIF',
  'OFFSET',
  'NEVERIF',
  '',
  'NO_IF',
  '',
  '',
  '',
  'LABEL',
  'RETURN',
  'IF',
  'SWIF',
  'ONEIF',
  'ELSE',
  'ENDIF',
  'BODY',
  'BODY_OBJ',
  'ANIM',
  'ANIM_OBJ',
  'SET_LIFE',
  'SET_LIFE_OBJ',
  'SET_TRACK',
  'SET_TRACK_OBJ',
  'MESSAGE',
  'FALLABLE',
  'SET_DIRMODE',
  'SET_DIRMODE_OBJ',
  'CAM_FOLLOW',
  'SET_BEHAVIOR',
  'SET_FLAG_CUBE',
  'COMPORTEMENT',
  'SET_COMPORTEMENT',
  'SET_COMPORTEMENT_OBJ',
  'END_COMPORTEMENT',
  'SET_FLAG_GAME',
  'KILL_OBJ',
  'SUICIDE',
  'USE_ONE_LITTLE_KEY',
  'GIVE_GOLD_PIECES',
  'END_LIFE',
  'STOP_L_TRACK',
  'RESTORE_L_TRACK',
  'MESSAGE_OBJ',
  'INC_CHAPTER',
  'FOUND_OBJECT',
  'SET_DOOR_LEFT',
  'SET_DOOR_RIGHT',
  'SET_DOOR_UP',
  'SET_DOOR_DOWN',
  'GIVE_BONUS',
  'CHANGE_CUBE',
  'OBJ_COL',
  'BRICK_COL',
  'OR_IF',
  'INVISIBLE',
  'ZOOM',
  'POS_POINT',
  'SET_MAGIC_LEVEL',
  'SUB_MAGIC_POINT',
  'SET_LIFE_POINT_OBJ',
  'SUB_LIFE_POINT_OBJ',
  'HIT_OBJ',
  'PLAY_FLA',
  'PLAY_MIDI',
  'INC_CLOVER_BOX',
  'SET_USED_INVENTORY',
  'ADD_CHOICE',
  'ASK_CHOICE',
  'BIG_MESSAGE',
  'INIT_PINGOUIN',
  'SET_HOLO_POS',
  'CLR_HOLO_POS',
  'ADD_FUEL',
  'SUB_FUEL',
  'SET_GRM',
  'SAY_MESSAGE',
  'SAY_MESSAGE_OBJ',
  'FULL_POINT',
  'BETA',
  'GRM_OFF',
  'FADE_PAL_RED',
  'FADE_ALARM_RED',
  'FADE_ALARM_PAL',
  'FADE_RED_PAL',
  'FADE_RED_ALARM',
  'FADE_PAL_ALARM',
  'EXPLODE_OBJ',
  'BUBBLE_ON',
  'BUBBLE_OFF',
  'ASK_CHOICE_OBJ',
  'SET_DARK_PAL',
  'SET_NORMAL_PAL',
  'MESSAGE_SENDELL',
  'ANIM_SET',
  'HOLOMAP_TRAJ',
  'GAME_OVER',
  'THE_END',
  'MIDI_OFF',
  'PLAY_CD_TRACK',
  'PROJ_ISO',
  'PROJ_3D',
  'TEXT',
  'CLEAR_TEXT',
  'BRUTAL_EXIT'
);

// Conditions Macro List

ConditionList : array [0..29] of String =
(
  'COL',
  'COL_OBJ',
  'DISTANCE',
  'ZONE',
  'ZONE_OBJ',
  'BODY',
  'BODY_OBJ',
  'ANIM',
  'ANIM_OBJ',
  'L_TRACK',
  'L_TRACK_OBJ',
  'FLAG_CUBE',
  'CONE_VIEW',
  'HIT_BY',
  'ACTION',
  'FLAG_GAME',
  'LIFE_POINT',
  'LIFE_POINT_OBJ',
  'NUM_LITTLE_KEYS',
  'NUM_GOLD_PIECES',
  'BEHAVIOR',
  'CHAPTER',
  'DISTANCE_3D',
  '',
  '',
  'USE_INVENTORY',
  'CHOICE',
  'FUEL',
  'CARRIED_BY',
  'CDROM'
);

// Operators List

OperatorsList : array [0..5] of String =
(
  '=',
  '>',
  '<',
  '>=',
  '<=',
  '!='
);

// Behavior List
BehaviorList : array [0..4] of String =
(
  'NORMAL',
  'ATHLETIC',
  'AGRESSIVE',
  'DISCRETE',
  'PROTO-PACK'
);

// Direction Mode List
DirModeList : array [0..7] of String =
(
  'NO_MOVE',
  'MANUAL',
  'FOLLOW',
  'TRACK',
  'FOLLOW_2',
  'TRACK_ATTACK',
  'SAME_XZ',
  'RANDOM'
);

