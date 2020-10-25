unit SceneLib1Tab;

interface

uses SceneLibConst, Utils;

const

// LBA 1 TRACK MACROS
tm1END = 0;
tm1BODY = 2;
tm1ANIM = 3;
tm1GOTO_POINT = 4;
tm1WAIT_ANIM = 5;
tm1ANGLE = 7;
tm1POS_POINT = 8;
tm1LABEL = 9;
tm1GOTO = 10;
tm1STOP = 11;
tm1GOTO_SYM_POINT = 12;
tm1WAIT_NUM_ANIM = 13;
tm1GOTO_POINT_3D = 15;
tm1SPEED = 16;
tm1WAIT_NUM_SECOND = 18;
tm1NO_BODY = 19;
tm1OPEN_LEFT = 21;
tm1OPEN_RIGHT = 22;
tm1OPEN_UP = 23;
tm1OPEN_DOWN = 24;
tm1CLOSE = 25;
tm1WAIT_DOOR = 26;
tm1FACE_HERO = 33;
tm1ANGLE_RND = 34;
tm1MAX_OPCODE = 34;

//LBA 1 LIFE MACROS
lm1END                  = 0;
lm1SNIF                 = 2;
lm1NEVERIF              = 4;
lm1NO_IF                = 6;
lm1IF                   = 12;
lm1SWIF                 = 13;
lm1ONEIF                = 14;
lm1ELSE                 = 15;
lm1ENDIF                = 16;
lm1BODY                 = 17;
lm1BODY_OBJ             = 18;
lm1ANIM                 = 19;
lm1ANIM_OBJ             = 20;
lm1SET_LIFE_OBJ         = 22;
lm1SET_TRACK            = 23;
lm1SET_TRACK_OBJ        = 24;
lm1SET_DIRMODE          = 27;
lm1SET_DIRMODE_OBJ      = 28;
lm1CAM_FOLLOW           = 29;
lm1SET_BEHAVIOUR        = 30;
lm1COMPORTMENT          = 32;
lm1SET_COMPORTMENT      = 33;
lm1SET_COMPORTMENT_OBJ  = 34;
lm1END_COMPORTMENT      = 35;
lm1KILL_OBJ             = 37;
lm1SUICIDE              = 38;
lm1MESSAGE_OBJ          = 44;
lm1SET_DOOR_LEFT        = 47;
lm1SET_DOOR_RIGHT       = 48;
lm1SET_DOOR_UP          = 49;
lm1SET_DOOR_DOWN        = 50;
lm1OR_IF                = 55;
lm1POS_POINT            = 58;
lm1SET_LIFE_POINT_OBJ   = 61;
lm1SUB_LIFE_POINT_OBJ   = 62;
lm1HIT_OBJ              = 63;
lm1INIT_PINGOUIN        = 71;
lm1SET_GRM              = 76;
lm1SAY_MESSAGE_OBJ      = 78;
lm1EXPLODE_OBJ          = 88;
lm1ASK_CHOICE_OBJ       = 91;
lm1ANIM_SET             = 95;
lm1MAX_OPCODE           = 105;

//LBA 1 LIFE VARIABLE CONSTANTS
lv1COL = 0;
lv1COL_OBJ = 1;
lv1DISTANCE = 2;
lv1ZONE = 3;
lv1ZONE_OBJ = 4;
lv1BODY = 5;
lv1BODY_OBJ = 6;
lv1ANIM = 7;
lv1ANIM_OBJ = 8;
lv1CURRENT_TRACK = 9;
lv1CURRENT_TRACK_OBJ = 10;
lv1CONE_VIEW = 12;
lv1HIT_BY = 13;
lv1LIFE_POINT = 16;
lv1LIFE_POINT_OBJ = 17;
lv1BEHAVIOUR = 20;
lv1DISTANCE_3D = 22;
lv1CARRIED_BY = 28;
lv1MAX_OPCODE = 29;

//LBA 1 Behaviour
lb1MAX_OPCODE = 4;

//Dir Modes
ld1FOLLOW     = 2;
ld1FOLLOW2    = 4;
ld1MAX_OPCODE = 7;

// ######## SETS ########

(*LBA1_LABEL_Relevant_Commands : set of 0..255 = [lm1SET_TRACK,{ lsIf, lsOneIf, lsSwIf,
lsNeverIf, lsSnIf, }lv1CURRENT_TRACK];
// Set_Track_Obj and Current_Track_Obj doesn't count since they aren't for the actual actor

//Commands that take Actor ID as the first parameter
LBA1_ActorFirstCommands = [ls1BODY_OBJ, ls1ANIM_OBJ, ls1SET_LIFE_OBJ, ls1SET_TRACK_OBJ,
  ls1SET_DIRMODE_OBJ, ls1CAM_FOLLOW, ls1SET_COMPORTMENT_OBJ, ls1KILL_OBJ, ls1MESSAGE_OBJ,
  ls1SET_LIFE_POINT_OBJ, ls1SUB_LIFE_POINT_OBJ, ls1HIT_OBJ, ls1INIT_PINGOUIN,
  ls1SAY_MESSAGE_OBJ, ls1EXPLODE_OBJ, ls1ASK_CHOICE_OBJ];

LBA1_ActorParVariables = [lsv1COL_OBJ, lsv1DISTANCE, lsv1ZONE_OBJ, lsv1BODY_OBJ,
  lsv1ANIM_OBJ, lsv1CURRENT_TRACK_OBJ, lsv1CONE_VIEW, lsv1LIFE_POINT_OBJ, lsv1DISTANCE_3D];

//Variables that take Actor ID as the comparison value
LBA1_ActorCompVariables = [lsv1COL, lsv1COL_OBJ, lsv1HIT_BY, lsv1CARRIED_BY]; *)

//LBA 1 Track Macro List - same for comp and decomp
Track1DecompList: array[0..34] of String = //original command names
(
  'END',  //0
  'NOP',
  'BODY',
  'ANIM',
  'GOTO_POINT',
  'WAIT_ANIM', //5
  'LOOP',
  'ANGLE',
  'POS_POINT',
  'LABEL',
  'GOTO', //10
  'STOP',
  'GOTO_SYM_POINT',
  'WAIT_NB_ANIM',
  'SAMPLE',
  'GOTO_POINT_3D', //15
  'SPEED',
  'BACKGROUND',
  'WAIT_NB_SECOND',
  'NO_BODY',
  'BETA',       //20
  'OPEN_LEFT',
  'OPEN_RIGHT',
  'OPEN_UP',
  'OPEN_DOWN',
  'CLOSE',      //25
  'WAIT_DOOR',
  'SAMPLE_RND',
  'SAMPLE_ALWAYS',
  'SAMPLE_STOP',
  'PLAY_FLA',     //30
  'REPEAT_SAMPLE',
  'SIMPLE_SAMPLE',
  'FACE_TWINKEL',
  'ANGLE_RND'     //34
);

Track1ModsEng: array[0..2] of TMacroModItem = //English command names
(
  (id: 13; name: 'WAIT_NUM_ANIM'),
  (id: 18; name: 'WAIT_NUM_SECOND'),
  (id: 33; name: 'FACE_HERO')
);

Track1CompList: array[0..35] of TMacroModItem =
(
  (id:  0; name: 'END'),
  //disabled: NOP, LOOP
  (id:  2; name: 'BODY'),
  (id:  3; name: 'ANIM'),
  (id:  4; name: 'GOTO_POINT'),
  (id:  5; name: 'WAIT_ANIM'),
  (id:  7; name: 'ANGLE'),
  (id:  8; name: 'POS_POINT'),
  (id:  9; name: 'LABEL'),
  (id: 10; name: 'GOTO'),
  (id: 11; name: 'STOP'),
  (id: 12; name: 'GOTO_SYM_POINT'),
  (id: 13; name: 'WAIT_NB_ANIM'),  //org
  (id: 13; name: 'WAIT_NUM_ANIM'), //alias
  (id: 14; name: 'SAMPLE'),
  (id: 15; name: 'GOTO_POINT_3D'),
  (id: 16; name: 'SPEED'),
  (id: 17; name: 'BACKGROUND'),
  (id: 18; name: 'WAIT_NB_SECOND'),  //org
  (id: 18; name: 'WAIT_NUM_SECOND'), //alias
  (id: 19; name: 'NO_BODY'),
  (id: 20; name: 'BETA'),
  (id: 21; name: 'OPEN_LEFT'),
  (id: 22; name: 'OPEN_RIGHT'),
  (id: 23; name: 'OPEN_UP'),
  (id: 24; name: 'OPEN_DOWN'),
  (id: 25; name: 'CLOSE'),
  (id: 26; name: 'WAIT_DOOR'),
  (id: 27; name: 'SAMPLE_RND'),
  (id: 28; name: 'SAMPLE_ALWAYS'),
  (id: 29; name: 'SAMPLE_STOP'),
  (id: 30; name: 'PLAY_FLA'),
  (id: 31; name: 'REPEAT_SAMPLE'),
  (id: 32; name: 'SIMPLE_SAMPLE'),
  (id: 33; name: 'FACE_TWINKEL'),
  (id: 33; name: 'FACE_HERO'),
  (id: 34; name: 'ANGLE_RND')
);

Life1DecompList: array[0..105] of String = //original command names
(
  'END', // 0
  'NOP',
  'SNIF',
  'OFFSET',
  'NEVERIF',
  '', //5
  'NO_IF',
  '', '', '', //7..9
  'LABEL', // 10
  'RETURN',
  'IF',
  'SWIF',
  'ONEIF',
  'ELSE', // 15
  'ENDIF',
  'BODY',
  'BODY_OBJ',
  'ANIM',
  'ANIM_OBJ', // 20
  'SET_LIFE',
  'SET_LIFE_OBJ',
  'SET_TRACK',
  'SET_TRACK_OBJ',
  'MESSAGE', // 25
  'FALLABLE',
  'SET_DIR',
  'SET_DIR_OBJ',
  'CAM_FOLLOW',
  'COMPORTEMENT_HERO', // 30 
  'SET_FLAG_CUBE',
  'COMPORTEMENT',
  'SET_COMPORTEMENT',
  'SET_COMPORTEMENT_OBJ',
  'END_COMPORTEMENT', // 35
  'SET_FLAG_GAME',
  'KILL_OBJ',
  'SUICIDE',
  'USE_ONE_LITTLE_KEY',
  'GIVE_GOLD_PIECES', // 40
  'END_LIFE',
  'STOP_L_TRACK',
  'RESTORE_L_TRACK',
  'MESSAGE_OBJ',
  'INC_CHAPTER', // 45
  'FOUND_OBJECT',
  'SET_DOOR_LEFT',
  'SET_DOOR_RIGHT',
  'SET_DOOR_UP',
  'SET_DOOR_DOWN', // 50
  'GIVE_BONUS',
  'CHANGE_CUBE',
  'OBJ_COL',
  'BRICK_COL',
  'OR_IF', // 55
  'INVISIBLE',
  'ZOOM',
  'POS_POINT',
  'SET_MAGIC_LEVEL',
  'SUB_MAGIC_POINT', // 60
  'SET_LIFE_POINT_OBJ',
  'SUB_LIFE_POINT_OBJ',
  'HIT_OBJ',
  'PLAY_FLA',
  'PLAY_MIDI', // 65
  'INC_CLOVER_BOX',
  'SET_USED_INVENTORY',
  'ADD_CHOICE',
  'ASK_CHOICE',
  'BIG_MESSAGE', // 70
  'INIT_PINGOUIN',
  'SET_HOLO_POS',
  'CLR_HOLO_POS',
  'ADD_FUEL',
  'SUB_FUEL', // 75
  'SET_GRM',
  'SAY_MESSAGE',
  'SAY_MESSAGE_OBJ',
  'FULL_POINT',
  'BETA', // 80
  'GRM_OFF',
  'FADE_PAL_RED',
  'FADE_ALARM_RED',
  'FADE_ALARM_PAL',
  'FADE_RED_PAL', // 85
  'FADE_RED_ALARM',
  'FADE_PAL_ALARM',
  'EXPLODE_OBJ',
  'BULLE_ON',
  'BULLE_OFF', // 90
  'ASK_CHOICE_OBJ',
  'SET_DARK_PAL',
  'SET_NORMAL_PAL',
  'MESSAGE_SENDELL',
  'ANIM_SET', // 95
  'HOLOMAP_TRAJ',
  'GAME_OVER',
  'THE_END',
  'MIDI_OFF',
  'PLAY_CD_TRACK', // 100
  'PROJ_ISO',
  'PROJ_3D',
  'TEXT',
  'CLEAR_TEXT',
  'BRUTAL_EXIT' // 105
);

//If both mod sets are to be applied, ModsComp must be applied first,
//because of the SET_COMPORTMENT_HERO becomes SET_BEHAVIOUR
Life1ModsComp: array[0..4] of TMacroModItem = //Comportment
(
  (id: 30; name: 'COMPORTMENT_HERO'),
  (id: 32; name: 'COMPORTMENT'),
  (id: 33; name: 'SET_COMPORTMENT'),
  (id: 34; name: 'SET_COMPORTMENT_OBJ'),
  (id: 35; name: 'END_COMPORTMENT')
);

Life1ModsEng: array[0..7] of TMacroModItem = //English command names
(
  (id: 26; name: 'CAN_FALL'),
  (id: 27; name: 'SET_DIRMODE'),
  (id: 28; name: 'SET_DIRMODE_OBJ'),
  (id: 30; name: 'SET_BEHAVIOUR'),
  (id: 42; name: 'STOP_CURRENT_TRACK'),
  (id: 43; name: 'RESTORE_LAST_TRACK'),
  (id: 89; name: 'BALLOON_ON'),
  (id: 90; name: 'BALLOON_OFF')
);

//thanks to TMacroModItem, we can define more than one command
//for a single ID (alias)
Life1CompList: array[0..109] of TMacroModItem =
(
  (id:   0; name: 'END'),
  //Disabled: NOP, SNIF, OFFSET, NEVERIF, NO_IF, LABEL, SET_LIFE(_OBJ)
  (id:  11; name: 'RETURN'),
  (id:  12; name: 'IF'),
  (id:  13; name: 'SWIF'),
  (id:  14; name: 'ONEIF'),
  (id:  15; name: 'ELSE'),
  (id:  16; name: 'ENDIF'),
  (id:  17; name: 'BODY'),
  (id:  18; name: 'BODY_OBJ'),
  (id:  19; name: 'ANIM'),
  (id:  20; name: 'ANIM_OBJ'),
  (id:  23; name: 'SET_TRACK'),
  (id:  24; name: 'SET_TRACK_OBJ'),
  (id:  25; name: 'MESSAGE'),
  (id:  26; name: 'FALLABLE'), //org
  (id:  26; name: 'CAN_FALL'), //alias
  (id:  27; name: 'SET_DIR'),     //org
  (id:  27; name: 'SET_DIRMODE'), //alias
  (id:  28; name: 'SET_DIR_OBJ'),     //org
  (id:  28; name: 'SET_DIRMODE_OBJ'), //alias
  (id:  29; name: 'CAM_FOLLOW'),
  (id:  30; name: 'COMPORTEMENT_HERO'), //org
  (id:  30; name: 'COMPORTMENT_HERO'),  //alias
  (id:  30; name: 'SET_BEHAVIOUR'),         //alias
  (id:  31; name: 'SET_FLAG_CUBE'), //org
  (id:  31; name: 'SET_VAR_CUBE'),  //alias
  (id:  32; name: 'COMPORTEMENT'), //org
  (id:  32; name: 'COMPORTMENT'),  //alias
  (id:  33; name: 'SET_COMPORTEMENT'), //org
  (id:  33; name: 'SET_COMPORTMENT'),  //alias
  (id:  34; name: 'SET_COMPORTEMENT_OBJ'), //org
  (id:  34; name: 'SET_COMPORTMENT_OBJ'),  //alias
  (id:  35; name: 'END_COMPORTEMENT'), //org
  (id:  35; name: 'END_COMPORTMENT'),  //alias
  (id:  36; name: 'SET_FLAG_GAME'), //org
  (id:  36; name: 'SET_VAR_GAME'),  //alias
  (id:  37; name: 'KILL_OBJ'),
  (id:  38; name: 'SUICIDE'),
  (id:  39; name: 'USE_ONE_LITTLE_KEY'),
  (id:  40; name: 'GIVE_GOLD_PIECES'),
  (id:  41; name: 'END_LIFE'),
  (id:  42; name: 'STOP_L_TRACK'),       //org
  (id:  42; name: 'STOP_CURRENT_TRACK'), //alias
  (id:  43; name: 'RESTORE_L_TRACK'),    //org
  (id:  43; name: 'RESTORE_LAST_TRACK'), //alias
  (id:  44; name: 'MESSAGE_OBJ'),
  (id:  45; name: 'INC_CHAPTER'),
  (id:  46; name: 'FOUND_OBJECT'),
  (id:  47; name: 'SET_DOOR_LEFT'),
  (id:  48; name: 'SET_DOOR_RIGHT'),
  (id:  49; name: 'SET_DOOR_UP'),
  (id:  50; name: 'SET_DOOR_DOWN'),
  (id:  51; name: 'GIVE_BONUS'),
  (id:  52; name: 'CHANGE_CUBE'),
  (id:  53; name: 'OBJ_COL'),
  (id:  54; name: 'BRICK_COL'),
  (id:  55; name: 'OR_IF'),
  (id:  56; name: 'INVISIBLE'),
  (id:  57; name: 'ZOOM'),
  (id:  58; name: 'POS_POINT'),
  (id:  59; name: 'SET_MAGIC_LEVEL'),
  (id:  60; name: 'SUB_MAGIC_POINT'),
  (id:  61; name: 'SET_LIFE_POINT_OBJ'),
  (id:  62; name: 'SUB_LIFE_POINT_OBJ'),
  (id:  63; name: 'HIT_OBJ'),
  (id:  64; name: 'PLAY_FLA'),
  (id:  65; name: 'PLAY_MIDI'),
  (id:  66; name: 'INC_CLOVER_BOX'),
  (id:  67; name: 'SET_USED_INVENTORY'),
  (id:  68; name: 'ADD_CHOICE'),
  (id:  69; name: 'ASK_CHOICE'),
  (id:  70; name: 'BIG_MESSAGE'),
  (id:  71; name: 'INIT_PINGOUIN'), //org
  (id:  71; name: 'INIT_PENGUIN'),  //alias
  (id:  72; name: 'SET_HOLO_POS'),
  (id:  73; name: 'CLR_HOLO_POS'),
  (id:  74; name: 'ADD_FUEL'),
  (id:  75; name: 'SUB_FUEL'),
  (id:  76; name: 'SET_GRM'),
  (id:  77; name: 'SAY_MESSAGE'),
  (id:  78; name: 'SAY_MESSAGE_OBJ'),
  (id:  79; name: 'FULL_POINT'),
  (id:  80; name: 'BETA'),
  (id:  81; name: 'GRM_OFF'),
  (id:  82; name: 'FADE_PAL_RED'),
  (id:  83; name: 'FADE_ALARM_RED'),
  (id:  84; name: 'FADE_ALARM_PAL'),
  (id:  85; name: 'FADE_RED_PAL'),
  (id:  86; name: 'FADE_RED_ALARM'),
  (id:  87; name: 'FADE_PAL_ALARM'),
  (id:  88; name: 'EXPLODE_OBJ'),
  (id:  89; name: 'BULLE_ON'),   //org
  (id:  89; name: 'BALLOON_ON'), //alias
  (id:  90; name: 'BULLE_OFF'),   //org
  (id:  90; name: 'BALLOON_OFF'), //alias
  (id:  91; name: 'ASK_CHOICE_OBJ'),
  (id:  92; name: 'SET_DARK_PAL'),
  (id:  93; name: 'SET_NORMAL_PAL'),
  (id:  94; name: 'MESSAGE_SENDELL'),
  (id:  95; name: 'ANIM_SET'),
  (id:  96; name: 'HOLOMAP_TRAJ'),
  (id:  97; name: 'GAME_OVER'),
  (id:  98; name: 'THE_END'),
  (id:  99; name: 'MIDI_OFF'),
  (id: 100; name: 'PLAY_CD_TRACK'),
  (id: 101; name: 'PROJ_ISO'),
  (id: 102; name: 'PROJ_3D'),
  (id: 103; name: 'TEXT'),
  (id: 104; name: 'CLEAR_TEXT'),
  (id: 105; name: 'BRUTAL_EXIT')
);

Var1DecompList: array[0..29] of String = //original macro names
(
  'COL',            //0
  'COL_OBJ',
  'DISTANCE',
  'ZONE',
  'ZONE_OBJ',
  'BODY',           //5
  'BODY_OBJ',
  'ANIM',
  'ANIM_OBJ',
  'L_TRACK',
  'L_TRACK_OBJ',    //10
  'FLAG_CUBE',
  'CONE_VIEW',
  'HIT_BY',
  'ACTION',
  'FLAG_GAME',      //15
  'LIFE_POINT',
  'LIFE_POINT_OBJ',
  'NB_LITTLE_KEYS',
  'NB_GOLD_PIECES',
  'COMPORTEMENT_HERO', //20
  'CHAPTER',
  'DISTANCE_3D',
  '',
  '',
  'USE_INVENTORY',  //25
  'CHOICE',
  'FUEL',
  'CARRY_BY',
  'CDROM'           //29
);

Var1ModsComp: array[0..0] of TMacroModItem = //Comportment
(
  (id: 20; name: 'COMPORTMENT_HERO')
);

Var1ModsEng: array[0..5] of TMacroModItem = //English macro names
(
  (id:  9; name: 'CURRENT_TRACK'),
  (id: 10; name: 'CURRENT_TRACK_OBJ'),
  (id: 18; name: 'NUM_LITTLE_KEYS'),
  (id: 19; name: 'NUM_GOLD_PIECES'),
  (id: 20; name: 'BEHAVIOUR'),
  (id: 28; name: 'CARRIED_BY')
);

Var1CompList: array[0..36] of TMacroModItem =
(
  (id:  0; name: 'COL'),
  (id:  1; name: 'COL_OBJ'),
  (id:  2; name: 'DISTANCE'),
  (id:  3; name: 'ZONE'),
  (id:  4; name: 'ZONE_OBJ'),
  (id:  5; name: 'BODY'),
  (id:  6; name: 'BODY_OBJ'),
  (id:  7; name: 'ANIM'),
  (id:  8; name: 'ANIM_OBJ'),
  (id:  9; name: 'L_TRACK'),       //org
  (id:  9; name: 'CURRENT_TRACK'), //alias
  (id: 10; name: 'L_TRACK_OBJ'),       //org
  (id: 10; name: 'CURRENT_TRACK_OBJ'), //alias
  (id: 11; name: 'FLAG_CUBE'), //org
  (id: 11; name: 'VAR_CUBE'),  //alias
  (id: 12; name: 'CONE_VIEW'),
  (id: 13; name: 'HIT_BY'),
  (id: 14; name: 'ACTION'),
  (id: 15; name: 'FLAG_GAME'), //org
  (id: 15; name: 'VAR_GAME'),  //alias
  (id: 16; name: 'LIFE_POINT'),
  (id: 17; name: 'LIFE_POINT_OBJ'),
  (id: 18; name: 'NB_LITTLE_KEYS'),  //org
  (id: 18; name: 'NUM_LITTLE_KEYS'), //alias
  (id: 19; name: 'NB_GOLD_PIECES'),  //org
  (id: 19; name: 'NUM_GOLD_PIECES'), //alias
  (id: 20; name: 'COMPORTEMENT_HERO'), //org
  (id: 20; name: 'COMPORTMENT_HERO'),  //alias
  (id: 20; name: 'BEHAVIOUR'),         //alias
  (id: 21; name: 'CHAPTER'),
  (id: 22; name: 'DISTANCE_3D'),
  (id: 25; name: 'USE_INVENTORY'),
  (id: 26; name: 'CHOICE'),
  (id: 27; name: 'FUEL'),
  (id: 28; name: 'CARRY_BY'),   //org
  (id: 28; name: 'CARRIED_BY'), //alias
  (id: 29; name: 'CDROM')
);

//no aliases here, but
Behav1DecompList: array[0..lb1MAX_OPCODE] of String =
(
  'NORMAL',     // 0
  'ATHLETIC',   // 1
  'AGGRESSIVE', // 2
  'DISCRETE',   // 3
  'PROTO_PACK'
);

//no aliases here, but it's easier to manage this way
Behav1CompList: array[0..4] of TMacroModItem =
(
  (id: 0; name: 'NORMAL'),
  (id: 1; name: 'ATHLETIC'),
  (id: 2; name: 'AGGRESSIVE'),
  (id: 3; name: 'DISCRETE'),
  (id: 4; name: 'PROTO_PACK')
);

// Direction Modes List
DirMode1DecompList: array [0..ld1MAX_OPCODE] of String =
(
  'NO_MOVE',
  'MANUAL',
  'FOLLOW',
  'TRACK',
  '', //'FOLLOW_2', disabled
  '', //'TRACK_ATTACK', disabled
  'SAME_XZ',
  'RANDOM'
);

// Direction Modes List
DirMode1CompList: array [0..5] of TMacroModItem =
(
  (id: 0; name: 'NO_MOVE'),
  (id: 1; name: 'MANUAL'),
  (id: 2; name: 'FOLLOW'),
  (id: 3; name: 'TRACK'),
  //Disabled: FOLLOW_2 and TRACK_ATTACK
  (id: 6; name: 'SAME_XZ'),
  (id: 7; name: 'RANDOM')
);

Track1Props: array[0..34] of TCommandProp =
(
  (ParCount: 0; Flags: []),                                 //END         0
  (ParCount: 0; Flags: []),                                 //NOP         1
  (ParCount: 1; Flags: [];                                  //BODY        2
   ParSize: (1,0,0,0); ParRng: (@RngSByte_1, nil, nil ,nil)),
  (ParCount: 1; Flags: [];                                  //ANIM        3
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                  //GOTO_POINT  4
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 0;                   Flags: []),               //WAIT_ANIM   5
  (ParCount: 0;                   Flags: []),               //LOOP        6
  (ParCount: 1; Flags: [];                                  //ANGLE       7
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                  //POS_POINT   8
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                  //LABEL       9
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                  //GOTO        10
   ParSize: (2,0,0,0); ParRng: (@RngHWord_1, nil, nil, nil)),
  (ParCount: 0; Flags: []),                                 //STOP        11
  (ParCount: 1; Flags: [];                                  //GOTO_SYM_POINT 12
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 2; Flags: [cfPar2Dummy];                       //WAIT_NUM_ANIM  13
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngZero, nil, nil)),
  (ParCount: 1; Flags: [];                                  //SAMPLE      14
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                  //GOTO_POINT_3D  15
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                  //SPEED       16
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                  //BACKGROUND  17
   ParSize: (1,0,0,0); ParRng: (@RngBool, nil, nil, nil)),
  (ParCount: 2; Flags: [cfPar2Dummy];                       //WAIT_NUM_SECOND 18
   ParSize: (1,4,0,0); ParRng: (@RngUByte, @RngZero, nil, nil)),
  (ParCount: 0; Flags: []),                                 //NO_BODY     19
  (ParCount: 1; Flags: [];                                  //BETA        20
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                  //OPEN_LEFT   21
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                  //OPEN_RIGHT  22
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                  //OPEN_UP     23
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                  //OPEN_DOWN   24
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 0; Flags: []),                                 //CLOSE       25
  (ParCount: 0; Flags: []),                                 //WAIT_DOOR   26
  (ParCount: 1; Flags: [];                                  //SAMPLE_RND  27
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                  //SAMPLE_ALWAYS  28
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                  //SAMPLE_STOP 29
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount:-1; Flags: []),                                 //PLAY_FLA    30
  (ParCount: 1; Flags: [];                                  //REPEAT_SAMPLE  31
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                  //SIMPLE_SAMPLE  32
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; Flags: [cfPar1Dummy];                       //FACE_HERO   33
   ParSize: (2,0,0,0); ParRng: (@RngMWord, nil, nil, nil)),
  (ParCount: 2; Flags: [cfPar2Dummy];                       //ANGLE_RND   34
   ParSize: (2,2,0,0); ParRng: (@RngHWord1, @RngMWord, nil, nil))
);

Life1Props: array[0..105] of TCommandProp =
(
  (ParCount: 0; cType: ctCommand; Flags: []),                   //END      0
  (ParCount: 0; cType: ctCommand; Flags: []),                   //NOP      1
  (ParCount: 0; cType: ctIf;      Flags: []),                   //SNIF     2
  (ParCount: 1; cType: ctCommand; Flags: [];                    //OFFSET   3
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 0; cType: ctIf;      Flags: []),                   //NEVERIF  4
  (ParCount: 0; cType: ctCommand; Flags: []),                   //         5
  (ParCount: 0; cType: ctIf;      Flags: []),                   //NO_IF    6
  (ParCount: 0; cType: ctCommand; Flags: []),                   //         7
  (ParCount: 0; cType: ctCommand; Flags: []),                   //         8
  (ParCount: 0; cType: ctCommand; Flags: []),                   //         9
  (ParCount: 1; cType: ctCommand; Flags: [];                    //LABEL    10
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //RETURN   11
  (ParCount: 0; cType: ctIf;      Flags: []),                   //IF       12
  (ParCount: 0; cType: ctIf;      Flags: []),                   //SWIF     13
  (ParCount: 0; cType: ctIf;      Flags: []),                   //ONEIF    14
  (ParCount: 1; cType: ctCommand; Flags: [];                    //ELSE     15
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 0; cType: ctVirtual; Flags: []),                   //ENDIF    16
  (ParCount: 1; cType: ctCommand; Flags: [];                    //BODY     17
   ParSize: (1,0,0,0); ParRng: (@RngSByte_1, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [];                    //BODY_OBJ 18
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngSByte_1, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //ANIM     19
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [];                    //ANIM_OBJ 20
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_LIFE 21
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [];                    //SET_LIFE_OBJ 22
   ParSize: (1,2,0,0); ParRng: (@RngUByte, @RngUWord, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_TRACK    23
   ParSize: (2,0,0,0); ParRng: (@RngHWord_1, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [];                    //SET_TRACK_OBJ 24
   ParSize: (1,2,0,0); ParRng: (@RngUByte, @RngHWord_1, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //MESSAGE  25
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //FALLABLE 26
   ParSize: (1,0,0,0); ParRng: (@RngBool, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_DIRMODE 27
   ParSize: (1,0,0,0); ParRng: (@RngDMod7, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [];                    //SET_DIRMODE_OBJ 28
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngDMod7, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //CAM_FOLLOW 29
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_BEHAVIOUR 30
   ParSize: (1,0,0,0); ParRng: (@RngBeh4, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [];                    //SET_FLAG_CUBE 31
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount: 1; cType: ctVirtual; Flags: [];                    //COMPORTMENT  32
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_COMPORTMENT 33
   ParSize: (2,0,0,0); ParRng: (@RngHWord_1, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [];                    //SET_COMPORTMENT_OBJ 34
   ParSize: (1,2,0,0); ParRng: (@RngUByte, @RngHWord_1, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //END_COMPORTMENT 35
  (ParCount: 2; cType: ctCommand; Flags: [];                    //SET_FLAG_GAME 36
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //KILL_OBJ 37
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //SUICIDE  38
  (ParCount: 0; cType: ctCommand; Flags: []),                   //USE_ONE_LITTLE_KEY 39
  (ParCount: 1; cType: ctCommand; Flags: [];                    //GIVE_GOLD_PIECES 40
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //END_LIFE 41
  (ParCount: 0; cType: ctCommand; Flags: []),                   //STOP_L_TRACK 42
  (ParCount: 0; cType: ctCommand; Flags: []),                   //RESTORE_L_TRACK 43
  (ParCount: 2; cType: ctCommand; Flags: [];                    //MESSAGE_OBJ  44
   ParSize: (1,2,0,0); ParRng: (@RngUByte, @RngHWord0, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //INC_CHAPTER  45
  (ParCount: 1; cType: ctCommand; Flags: [];                    //FOUND_OBJECT 46
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_DOOR_LEFT 47
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_DOOR_RIGHT 48
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_DOOR_UP 49
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_DOOR_DOWN 50
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //GIVE_BONUS  51
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //CHANGE_CUBE 52
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //OBJ_COL     53
   ParSize: (1,0,0,0); ParRng: (@RngBool, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //BRICK_COL   54
   ParSize: (1,0,0,0); ParRng: (@RngTriple, nil, nil, nil)),
  (ParCount: 0; cType: ctIf;      Flags: []),                   //OR_IF       55
  (ParCount: 1; cType: ctCommand; Flags: [];                    //INVISIBLE   56
   ParSize: (1,0,0,0); ParRng: (@RngBool, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //ZOOM        57
   ParSize: (1,0,0,0); ParRng: (@RngBool, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //POS_POINT   58
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_MAGIC_LEVEL 59
   ParSize: (1,0,0,0); ParRng: (@RngMag4, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SUB_MAGIC_POINT 60
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [];                    //SET_LIFE_POINT_OBJ 61
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [];                    //SUB_LIFE_POINT_OBJ 62
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [];                    //HIT_OBJ   63
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount:-1; cType: ctCommand; Flags: []),                   //PLAY_FLA  64
  (ParCount: 1; cType: ctCommand; Flags: [];                    //PLAY_MIDI 65
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //INC_CLOVER_BOX     66
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_USED_INVENTORY 67
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //ADD_CHOICE    68
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //ASK_CHOICE    69
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //BIG_MESSAGE   70
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //INIT_PINGOUIN 71
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_HOLO_POS  72
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //CLR_HOLO_POS  73
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //ADD_FUEL      74
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SUB_FUEL      75
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_GRM       76
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SAY_MESSAGE   77
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [];                    //SAY_MESSAGE_OBJ 78
   ParSize: (1,2,0,0); ParRng: (@RngUByte, @RngHWord0, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //FULL_POINT    79
  (ParCount: 1; cType: ctCommand; Flags: [];                    //BETA          80
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //GRM_OFF       81
  (ParCount: 0; cType: ctCommand; Flags: []),                   //FADE_PAL_RED  82
  (ParCount: 0; cType: ctCommand; Flags: []),                   //FADE_ALARM_RED 83
  (ParCount: 0; cType: ctCommand; Flags: []),                   //FADE_ALARM_PAL 84
  (ParCount: 0; cType: ctCommand; Flags: []),                   //FADE_RED_PAL   85
  (ParCount: 0; cType: ctCommand; Flags: []),                   //FADE_RED_ALARM 86
  (ParCount: 0; cType: ctCommand; Flags: []),                   //FADE_PAL_ALARM 87
  (ParCount: 1; cType: ctCommand; Flags: [];                    //EXPLODE_OBJ    88
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //BALLOON_ON      89
  (ParCount: 0; cType: ctCommand; Flags: []),                   //BALLOON_OFF     90
  (ParCount: 2; cType: ctCommand; Flags: [];                    //ASK_CHOICE_OBJ 91
   ParSize: (1,2,0,0); ParRng: (@RngUByte, @RngHWord0, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //SET_DARK_PAL   92
  (ParCount: 0; cType: ctCommand; Flags: []),                   //SET_NORMAL_PAL 93
  (ParCount: 0; cType: ctCommand; Flags: []),                   //MESSAGE_SENDELL 94
  (ParCount: 1; cType: ctCommand; Flags: [];                    //ANIM_SET       95
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //HOLOMAP_TRAJ   96
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //GAME_OVER      97
  (ParCount: 0; cType: ctCommand; Flags: []),                   //THE_END        98
  (ParCount: 0; cType: ctCommand; Flags: []),                   //MIDI_OFF       99
  (ParCount: 1; cType: ctCommand; Flags: [];                    //PLAY_CD_TRACK  100
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //PROJ_ISO       101
  (ParCount: 0; cType: ctCommand; Flags: []),                   //PROJ_3D        102
  (ParCount: 1; cType: ctCommand; Flags: [];                    //TEXT           103
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //CLEAR_TEXT     104
  (ParCount: 0; cType: ctCommand; Flags: [])                    //BRUTAL_EXIT    105
);

Var1Props: array[0..29] of TVariableProp =
(
  (HasParam: False; RetSize: 1; RetRange: @RngUByte),   //COL              // 0
  (HasParam: True;  RetSize: 1; RetRange: @RngUByte),   //COL_OBJ          // 1
  (HasParam: True;  RetSize: 2; RetRange: @RngDist),    //DISTANCE         // 2
  (HasParam: False; RetSize: 1; RetRange: @RngUByte),   //ZONE             // 3
  (HasParam: True;  RetSize: 1; RetRange: @RngUByte),   //ZONE_OBJ         // 4
  (HasParam: False; RetSize: 1; RetRange: @RngSByte_1), //BODY             // 5
  (HasParam: True;  RetSize: 1; RetRange: @RngSByte_1), //BODY_OBJ         // 6
  (HasParam: False; RetSize: 1; RetRange: @RngUByte),   //ANIM             // 7
  (HasParam: True;  RetSize: 1; RetRange: @RngUByte),   //ANIM_OBJ         // 8
  (HasParam: False; RetSize: 1; RetRange: @RngUByte),   //L_TRACK          // 9
  (HasParam: True;  RetSize: 1; RetRange: @RngUByte),   //L_TRACK_OBJ      // 10
  (HasParam: True;  RetSize: 1; RetRange: @RngUByte),   //FLAG_CUBE        // 11
  (HasParam: True;  RetSize: 2; RetRange: @RngDist),    //CONE_VIEW        // 12
  (HasParam: False; RetSize: 1; RetRange: @RngUByte),   //HIT_BY           // 13
  (HasParam: False; RetSize: 1; RetRange: @RngBool),    //ACTION           // 14
  (HasParam: True;  RetSize: 1; RetRange: @RngUByte),   //FLAG_GAME        // 15
  (HasParam: False; RetSize: 1; RetRange: @RngUByte),   //LIFE_POINT       // 16
  (HasParam: True;  RetSize: 1; RetRange: @RngUByte),   //LIFE_POINT_OBJ   // 17
  (HasParam: False; RetSize: 1; RetRange: @RngUByte),   //NUM_LITTLE_KEYS  // 18
  (HasParam: False; RetSize: 2; RetRange: @RngGold),    //NUM_GOLD_PIECES  // 19
  (HasParam: False; RetSize: 1; RetRange: @RngBeh4),    //BEHAVIOUR        // 20
  (HasParam: False; RetSize: 1; RetRange: @RngUByte),   //CHAPTER          // 21
  (HasParam: True;  RetSize: 2; RetRange: @RngDist),    //DISTANCE_3D      // 22
  (HasParam: False; RetSize: 0),                 // 23
  (HasParam: False; RetSize: 0),                 // 24
  (HasParam: True;  RetSize: 1; RetRange: @RngUByte),   //USE_INVENTORY    // 25
  (HasParam: False; RetSize: 2; RetRange: @RngHWord0),  //CHOICE           // 26
  (HasParam: False; RetSize: 1; RetRange: @RngUByte),   //FUEL             // 27
  (HasParam: False; RetSize: 1; RetRange: @RngUByte),   //CARRIED_BY       // 28
  (HasParam: False; RetSize: 1; RetRange: @RngUByte)    //CDROM            // 29
);

implementation

end.
