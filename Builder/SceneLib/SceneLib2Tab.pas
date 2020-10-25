unit SceneLib2Tab;

interface

uses SceneLibConst, Utils;

const

tm2END             =  0;
tm2BODY            =  2;
tm2ANIM            =  3;
tm2GOTO_POINT      =  4;
tm2WAIT_ANIM       =  5;
tm2ANGLE           =  7;
tm2POS_POINT       =  8;
tm2LABEL           =  9;
tm2GOTO            = 10;
tm2STOP            = 11;
tm2GOTO_SYM_POINT  = 12;
tm2WAIT_NUM_ANIM   = 13;
tm2GOTO_POINT_3D   = 15;
tm2SPEED           = 16;
tm2WAIT_NUM_SECOND = 18;
tm2NO_BODY         = 19;
tm2BETA            = 20;
tm2OPEN_LEFT       = 21;
tm2OPEN_RIGHT      = 22;
tm2OPEN_UP         = 23;
tm2OPEN_DOWN       = 24;
tm2CLOSE           = 25;
tm2WAIT_DOOR       = 26;
tm2FACE_TWINSEN    = 33;
tm2ANGLE_RND       = 34;
tm2REPLACE         = 35;
tm2SPRITE          = 38;
tm2SET_FRAME_3DS	 = 42;
tm2SET_START_3DS	 = 43;
tm2SET_END_3DS	   = 44;
tm2START_ANIM_3DS  = 45;
tm2STOP_ANIM_3DS   = 46;
tm2WAIT_ANIM_3DS   = 47;
tm2WAIT_FRAME_3DS  = 48;
tm2MAX_OPCODE      = 52;

lm2END                  =   0;
lm2SNIF                 =   2;
lm2NEVERIF              =   4;
lm2IF                   =  12;
lm2SWIF                 =  13;
lm2ONEIF                =  14;
lm2ELSE                 =  15;
lm2ENDIF                =  16;
lm2BODY                 =  17;
lm2BODY_OBJ             =  18;
lm2ANIM                 =  19;
lm2ANIM_OBJ             =  20;
lm2SET_TRACK            =  23;
lm2SET_TRACK_OBJ        =  24;
lm2SET_DIRMODE          =  27;
lm2SET_DIRMODE_OBJ      =  28;
lm2CAM_FOLLOW           =  29;
lm2SET_BEHAVIOUR        =  30;
lm2COMPORTMENT          =  32;
lm2SET_COMPORTMENT      =  33;
lm2SET_COMPORTMENT_OBJ  =  34;
lm2END_COMPORTMENT      =  35;
lm2KILL_OBJ             =  37;
lm2SUICIDE              =  38;
lm2MESSAGE_OBJ          =  44;
lm2SET_DOOR_LEFT        =  47;
lm2SET_DOOR_RIGHT       =  48;
lm2SET_DOOR_UP          =  49;
lm2SET_DOOR_DOWN        =  50;
lm2OR_IF                =  55;
lm2SHADOW_OBJ           =  57;
lm2POS_POINT            =  58;
lm2SET_LIFE_POINT_OBJ   =  61;
lm2SUB_LIFE_POINT_OBJ   =  62;
lm2HIT_OBJ              =  63;
lm2SET_GRM              =  76;
lm2BETA                 =  80;
lm2SET_SPRITE	          =  84;
lm2SET_FRAME_3DS        =  85;
lm2IMPACT_OBJ	          =  86;
lm2IMPACT_POINT         =  87;
lm2ASK_CHOICE_OBJ       =  91;
lm2ANIM_SET             =  95;
lm2ADD_MESSAGE_OBJ      = 104;
lm2SET_ARMOUR_OBJ       = 109;
lm2ADD_LIFE_POINT_OBJ   = 110;
lm2AND_IF               = 112;
lm2SWITCH               = 113;
lm2OR_CASE              = 114;
lm2CASE                 = 115;
lm2DEFAULT              = 116;
lm2BREAK                = 117;
lm2END_SWITCH           = 118;
lm2INVERSE_BETA         = 134;
lm2NO_BODY              = 135;
lm2STOP_TRACK_OBJ       = 137;
lm2RESTORE_TRACK_OBJ    = 138;
lm2SAVE_COMPORTMENT_OBJ = 139;
lm2RESTORE_COMPORTMENT_OBJ = 140;
lm2DEBUG_OBJ		        = 143;
lm2FLOW_POINT		        = 145;
lm2FLOW_OBJ		          = 146;
lm2END_MESSAGE_OBJ      = 150;
lm2POS_OBJ_AROUND	      = 153;
lm2MAX_OPCODE           = 154;

lv2COL                 =  0;
lv2COL_OBJ             =  1;
lv2DISTANCE            =  2;
lv2ZONE                =  3;
lv2ZONE_OBJ            =  4;
lv2BODY                =  5;
lv2BODY_OBJ            =  6;
lv2ANIM                =  7;
lv2ANIM_OBJ            =  8;
lv2CURRENT_TRACK       =  9;
lv2CURRENT_TRACK_OBJ   = 10;
lv2CONE_VIEW           = 12;
lv2HIT_BY              = 13;
lv2LIFE_POINT_OBJ      = 17;
lv2BEHAVIOUR           = 20;
lv2DISTANCE_3D         = 22;
lv2CARRIED_BY          = 28;
lv2BETA_OBJ            = 34;
lv2CARRIED_OBJ_BY      = 35;
lv2ANGLE               = 36;
lv2HIT_OBJ_BY	         = 38;
lv2REAL_ANGLE          = 39;
lv2COL_DECORS_OBJ	     = 42;
lv2OBJECT_DISPLAYED    = 44;
lv2ANGLE_OBJ           = 45;
lv2MAX_OPCODE          = 45;

//DirModes
ld2NO_MOVE      = 0;
ld2MANUAL       = 1;
ld2FOLLOW       = 2;  //requires actor param
ld2TRACK        = 3;
ld2FOLLOW2      = 4;  //perhaps requires actor param
ld2TRACK_ATTACK = 5;
ld2SAME_XZ      = 6;  //requires actor param
ld2RANDOM       = 7;
ld2DIRMODE9     = 9;  //requires actor param
ld2DIRMODE10    = 10; //requires actor param
ld2DIRMODE11    = 11; //requires actor param
ld2DIRMODE12    = 12;
ld2DIRMODE13    = 13;
ld2MAX_OPCODE   = 13;

//Behaviours
lb2MAX_OPCODE   = 13;

Track2DecompList: array[0..tm2MAX_OPCODE] of String = //original command names
( 'END',               //  0
  'NOP',               //  1
  'BODY',              //  2
  'ANIM',              //  3
  'GOTO_POINT',        //  4
  'WAIT_ANIM',         //  5
  'LOOP',              //  6
  'ANGLE',             //  7
  'POS_POINT',         //  8
  'LABEL',             //  9
  'GOTO',              // 10
  'STOP',              // 11
  'GOTO_SYM_POINT',    // 12
  'WAIT_NB_ANIM',      // 13
  'SAMPLE',            // 14
  'GOTO_POINT_3D',     // 15
  'SPEED',             // 16
  'BACKGROUND',        // 17
  'WAIT_NB_SECOND',    // 18
  'NO_BODY',           // 19
  'BETA',              // 20
  'OPEN_LEFT',         // 21
  'OPEN_RIGHT',        // 22
  'OPEN_UP',           // 23
  'OPEN_DOWN',         // 24
  'CLOSE',             // 25
  'WAIT_DOOR',         // 26
  'SAMPLE_RND',        // 27
  'SAMPLE_ALWAYS',     // 28
  'SAMPLE_STOP',       // 29
  'PLAY_ACF',          // 30
  'REPEAT_SAMPLE',     // 31
  'SIMPLE_SAMPLE',     // 32
  'FACE_TWINSEN',      // 33
  'ANGLE_RND',         // 34
  'REMP',              // 35 //REM
  'WAIT_NB_DIZIEME',   // 36
  'DO',                // 37
  'SPRITE',            // 38
  'WAIT_NB_SECOND_RND',// 39
  'AFF_TIMER',         // 40
  'SET_FRAME',	       //	41
  'SET_FRAME_3DS',	   // 42
  'SET_START_3DS',	   // 43
  'SET_END_3DS',	     //	44
  'START_ANIM_3DS',    //	45
  'STOP_ANIM_3DS',     //	46
  'WAIT_ANIM_3DS',     //	47
  'WAIT_FRAME_3DS',    //	48
  'WAIT_NB_DIZIEME_RND',// 49
  'DECALAGE',          //	50
  'FREQUENCY', 	       //	51
  'VOLUME'             // 52
);

Track2ModsEng: array[0..7] of TMacroModItem = //English command names
(
  (id: 13; name: 'WAIT_NUM_ANIM'),
  (id: 18; name: 'WAIT_NUM_SECOND'),
  (id: 30; name: 'PLAY_SMK'),
  (id: 35; name: 'REPLACE'),
  (id: 36; name: 'WAIT_NUM_DSEC'),
  (id: 39; name: 'WAIT_NUM_SEC_RND'),
  (id: 49; name: 'WAIT_NUM_DSEC_RND'),
  (id: 50; name: 'INTERVAL')
);

Track2CompList: array[0..58] of TMacroModItem =
( (id:  0; name: 'END'),
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
  (id: 30; name: 'PLAY_ACF'), //org
  (id: 30; name: 'PLAY_SMK'), //alias
  (id: 31; name: 'REPEAT_SAMPLE'),
  (id: 32; name: 'SIMPLE_SAMPLE'),
  (id: 33; name: 'FACE_TWINSEN'),
  (id: 34; name: 'ANGLE_RND'),
  (id: 35; name: 'REMP'),    //org //REM
  (id: 35; name: 'REPLACE'), //alias
  (id: 36; name: 'WAIT_NB_DIZIEME'), //org
  (id: 36; name: 'WAIT_NUM_DSEC'),   //alias
  (id: 37; name: 'DO'),
  (id: 38; name: 'SPRITE'),
  (id: 39; name: 'WAIT_NB_SECOND_RND'), //org
  (id: 39; name: 'WAIT_NUM_SEC_RND'),   //alias
  (id: 40; name: 'AFF_TIMER'),
  (id: 41; name: 'SET_FRAME'),
  (id: 42; name: 'SET_FRAME_3DS'),
  (id: 43; name: 'SET_START_3DS'),
  (id: 44; name: 'SET_END_3DS'),
  (id: 45; name: 'START_ANIM_3DS'),
  (id: 46; name: 'STOP_ANIM_3DS'),
  (id: 47; name: 'WAIT_ANIM_3DS'),
  (id: 48; name: 'WAIT_FRAME_3DS'),
  (id: 49; name: 'WAIT_NB_DIZIEME_RND'), //org
  (id: 49; name: 'WAIT_NUM_DSEC_RND'),   //alias
  (id: 50; name: 'DECALAGE'), //org
  (id: 50; name: 'INTERVAL'), //alias
  (id: 51; name: 'FREQUENCY'),
  (id: 52; name: 'VOLUME')
);

Life2DecompList: array[0..lm2MAX_OPCODE] of String = //original command names
( 'END',               //  0
  'NOP',               //  1
  'SNIF',              //  2
  'OFFSET',            //  3
  'NEVERIF',           //  4
  '', '', '', '', '',  // 5..9
  'PALETTE',           // 10
  'RETURN',            // 11
  'IF',                // 12
  'SWIF',              // 13
  'ONEIF',             // 14
  'ELSE',              // 15
  'ENDIF',             // 16
  'BODY',              // 17
  'BODY_OBJ',          // 18
  'ANIM',              // 19
  'ANIM_OBJ',          // 20
  'SET_CAMERA',  	     // 21
  'CAMERA_CENTER',     //	22
  'SET_TRACK',         // 23
  'SET_TRACK_OBJ',     // 24
  'MESSAGE',           // 25
  'FALLABLE',          // 26
  'SET_DIR',           // 27
  'SET_DIR_OBJ',       // 28
  'CAM_FOLLOW',        // 29
  'COMPORTEMENT_HERO', // 30
  'SET_VAR_CUBE',      // 31
  'COMPORTEMENT',      // 32
  'SET_COMPORTEMENT',  // 33
  'SET_COMPORTEMENT_OBJ',// 34
  'END_COMPORTEMENT',  // 35
  'SET_VAR_GAME',      // 36
  'KILL_OBJ',          // 37
  'SUICIDE',           // 38
  'USE_ONE_LITTLE_KEY',// 39
  'GIVE_GOLD_PIECES',  // 40
  'END_LIFE',          // 41
  'STOP_L_TRACK',      // 42
  'RESTORE_L_TRACK',   // 43
  'MESSAGE_OBJ',       // 44
  'INC_CHAPTER',       // 45
  'FOUND_OBJECT',      // 46
  'SET_DOOR_LEFT',     // 47
  'SET_DOOR_RIGHT',    // 48
  'SET_DOOR_UP',       // 49
  'SET_DOOR_DOWN',     // 50
  'GIVE_BONUS',        // 51
  'CHANGE_CUBE',       // 52
  'OBJ_COL',           // 53
  'BRICK_COL',         // 54
  'OR_IF',             // 55
  'INVISIBLE',         // 56
  'SHADOW_OBJ',        //	57
  'POS_POINT',         // 58
  'SET_MAGIC_LEVEL',   // 59
  'SUB_MAGIC_POINT',   // 60
  'SET_LIFE_POINT_OBJ',// 61
  'SUB_LIFE_POINT_OBJ',// 62
  'HIT_OBJ',           // 63
  'PLAY_ACF',          // 64
  'ECLAIR',            //	65
  'INC_CLOVER_BOX',    // 66
  'SET_USED_INVENTORY',// 67
  'ADD_CHOICE',        // 68
  'ASK_CHOICE',        // 69
  'INIT_BUGGY',	       //	70
  'MEMO_ARDOISE',      // 71
  'SET_HOLO_POS',      // 72
  'CLR_HOLO_POS',      // 73
  'ADD_FUEL',          // 74
  'SUB_FUEL',          // 75
  'SET_GRM',           // 76
  'SET_CHANGE_CUBE',   // 77
  'MESSAGE_ZOE',       //	78
  'FULL_POINT',        // 79
  'BETA',              // 80
  'FADE_TO_PAL',	     //	81
  'ACTION',            //	82
  'SET_FRAME',	       // 83
  'SET_SPRITE',	       //	84
  'SET_FRAME_3DS',     //	85
  'IMPACT_OBJ',	       //	86
  'IMPACT_POINT',      // 87
  'ADD_MESSAGE',	     //	88
  'BULLE',             // 89 
  'NO_CHOC',     	   	 // 90
  'ASK_CHOICE_OBJ',    // 91
  'CINEMA_MODE', 	     //	92
  'SAVE_HERO',   	     //	93
  'RESTORE_HERO',		   // 94
  'ANIM_SET',          // 95
  'PLUIE',             //	96
  'GAME_OVER',         // 97
  'THE_END',           // 98
  'ESCALATOR',         // 99
  'PLAY_MUSIC',	     	 //100
  'TRACK_TO_VAR_GAME', //101
  'VAR_GAME_TO_TRACK', //102
  'ANIM_TEXTURE',      //103
  'ADD_MESSAGE_OBJ',   //104
  'BRUTAL_EXIT',       //105
  'REMP',              //106
  'ECHELLE',           //107
  'SET_ARMURE',        //108 
  'SET_ARMURE_OBJ',    //109
  'ADD_LIFE_POINT_OBJ',//110
  'STATE_INVENTORY',	 //111
  'AND_IF',            //112
  'SWITCH',            //113
  'OR_CASE',           //114
  'CASE',              //115
  'DEFAULT',           //116
  'BREAK',             //117
  'END_SWITCH',        //118
  'SET_HIT_ZONE',      //119
  'SAVE_COMPORTEMENT', //120
  'RESTORE_COMPORTEMENT',//121
  'SAMPLE',            //122
  'SAMPLE_RND',        //123
  'SAMPLE_ALWAYS',     //124
  'SAMPLE_STOP',       //125
  'REPEAT_SAMPLE',     //126
  'BACKGROUND',        //127
  'ADD_VAR_GAME',      //128
  'SUB_VAR_GAME',      //129
  'ADD_VAR_CUBE',      //130
  'SUB_VAR_CUBE',      //131
  '',                  //#define LM_NOP      			132
  'SET_RAIL',          //133
  'INVERSE_BETA',      //134
  'NO_BODY',           //135
  'ADD_GOLD_PIECES',   //136
  'STOP_L_TRACK_OBJ',  //137
  'RESTORE_L_TRACK_OBJ', //138
  'SAVE_COMPORTEMENT_OBJ',//139
  'RESTORE_COMPORTEMENT_OBJ',//140
  'SPY',		       	   //141
  'DEBUG',	           //142
  'DEBUG_OBJ',		     //143
  'POPCORN',		       //144
  'FLOW_POINT',		     //145
  'FLOW_OBJ',		       //146
  'SET_ANIM_DIAL',     //147
  'PCX', 			         //148
  'END_MESSAGE',		   //149
  'END_MESSAGE_OBJ',   //150
  'PARM_SAMPLE',		   //151
  'NEW_SAMPLE',		     //152
  'POS_OBJ_AROUND',	   //153
  'PCX_MESS_OBJ'       //154
);

//If both mod sets are to be applied, ModsComp must be applied first,
//because of the SET_COMPORTMENT_HERO becomes SET_BEHAVIOUR
Life2ModsComp: array[0..8] of TMacroModItem = //Comportment
(
  (id:  30; name: 'COMPORTMENT_HERO'),
  (id:  32; name: 'COMPORTMENT'),
  (id:  33; name: 'SET_COMPORTMENT'),
  (id:  34; name: 'SET_COMPORTMENT_OBJ'),
  (id:  35; name: 'END_COMPORTMENT'),
  (id: 120; name: 'SAVE_COMPORTMENT'),
  (id: 121; name: 'RESTORE_COMPORTMENT'),
  (id: 139; name: 'SAVE_COMPORTMENT_OBJ'),
  (id: 140; name: 'RESTORE_COMPORTMENT_OBJ')
);

Life2ModsEng: array[0..22] of TMacroModItem = //English command names
(
  (id:  26; name: 'CAN_FALL'),
  (id:  27; name: 'SET_DIRMODE'),
  (id:  28; name: 'SET_DIRMODE_OBJ'),
  (id:  30; name: 'SET_BEHAVIOUR'),
  (id:  42; name: 'STOP_TRACK'),
  (id:  43; name: 'RESTORE_TRACK'),
  (id:  64; name: 'PLAY_SMK'),
  (id:  65; name: 'LIGHTNING'),
  (id:  71; name: 'MEMO_SLATE'),
  (id:  89; name: 'BALLOON'),
  (id:  90; name: 'NO_SHOCK'),
  (id:  96; name: 'RAIN'),
  (id:  99; name: 'CONVEYOR'),
  (id: 106; name: 'REPLACE'),
  (id: 107; name: 'LADDER'),
  (id: 108; name: 'SET_ARMOUR'),
  (id: 109; name: 'SET_ARMOUR_OBJ'),
  (id: 120; name: 'SAVE_COMP'),
  (id: 121; name: 'RESTORE_COMP'),
  (id: 137; name: 'STOP_TRACK_OBJ'),
  (id: 138; name: 'RESTORE_TRACK_OBJ'),
  (id: 139; name: 'SAVE_COMP_OBJ'),
  (id: 140; name: 'RESTORE_COMP_OBJ')
);

//thanks to TMacroModItem, we can define more than one command
//for a single ID (alias)
Life2CompList: array[0..177] of TMacroModItem =
( (id:   0; name: 'END'),
  //disabled: NOP, OFFSET, NEVERIF
  (id:   2; name: 'SNIF'),
  (id:  10; name: 'PALETTE'),
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
  (id:  21; name: 'SET_CAMERA'),
  (id:  22; name: 'CAMERA_CENTER'),
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
  (id:  30; name: 'SET_BEHAVIOUR'),     //alias
  (id:  31; name: 'SET_VAR_CUBE'),
  (id:  32; name: 'COMPORTEMENT'), //org
  (id:  32; name: 'COMPORTMENT'),  //alias
  (id:  33; name: 'SET_COMPORTEMENT'), //org
  (id:  33; name: 'SET_COMPORTMENT'),  //alias
  (id:  34; name: 'SET_COMPORTEMENT_OBJ'), //org
  (id:  34; name: 'SET_COMPORTMENT_OBJ'),  //alias
  (id:  35; name: 'END_COMPORTEMENT'), //org
  (id:  35; name: 'END_COMPORTMENT'),  //alias
  (id:  36; name: 'SET_VAR_GAME'),
  (id:  37; name: 'KILL_OBJ'),
  (id:  38; name: 'SUICIDE'),
  (id:  39; name: 'USE_ONE_LITTLE_KEY'),
  (id:  40; name: 'GIVE_GOLD_PIECES'),
  (id:  41; name: 'END_LIFE'),
  (id:  42; name: 'STOP_L_TRACK'), //org
  (id:  42; name: 'STOP_TRACK'),   //alias
  (id:  43; name: 'RESTORE_L_TRACK'), //org
  (id:  43; name: 'RESTORE_TRACK'),   //alias
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
  (id:  57; name: 'SHADOW_OBJ'),
  (id:  58; name: 'POS_POINT'),
  (id:  59; name: 'SET_MAGIC_LEVEL'),
  (id:  60; name: 'SUB_MAGIC_POINT'),
  (id:  61; name: 'SET_LIFE_POINT_OBJ'),
  (id:  62; name: 'SUB_LIFE_POINT_OBJ'),
  (id:  63; name: 'HIT_OBJ'),
  (id:  64; name: 'PLAY_ACF'), //org
  (id:  64; name: 'PLAY_SMK'), //alias
  (id:  65; name: 'ECLAIR'),    //org
  (id:  65; name: 'LIGHTNING'), //alias
  (id:  66; name: 'INC_CLOVER_BOX'),
  (id:  67; name: 'SET_USED_INVENTORY'),
  (id:  68; name: 'ADD_CHOICE'),
  (id:  69; name: 'ASK_CHOICE'),
  (id:  70; name: 'INIT_BUGGY'),
  (id:  71; name: 'MEMO_ARDOISE'), //org
  (id:  71; name: 'MEMO_SLATE'),   //alias
  (id:  72; name: 'SET_HOLO_POS'),
  (id:  73; name: 'CLR_HOLO_POS'),
  (id:  74; name: 'ADD_FUEL'),
  (id:  75; name: 'SUB_FUEL'),
  (id:  76; name: 'SET_GRM'),
  (id:  77; name: 'SET_CHANGE_CUBE'),
  (id:  78; name: 'MESSAGE_ZOE'),
  (id:  79; name: 'FULL_POINT'),
  (id:  80; name: 'BETA'),
  (id:  81; name: 'FADE_TO_PAL'),
  (id:  82; name: 'ACTION'),
  (id:  83; name: 'SET_FRAME'),
  (id:  84; name: 'SET_SPRITE'),
  (id:  85; name: 'SET_FRAME_3DS'),
  (id:  86; name: 'IMPACT_OBJ'),
  (id:  87; name: 'IMPACT_POINT'),
  (id:  88; name: 'ADD_MESSAGE'),
  (id:  89; name: 'BULLE'),   //org
  (id:  89; name: 'BALLOON'), //alias
  (id:  90; name: 'NO_CHOC'),  //org
  (id:  90; name: 'NO_SHOCK'), //alias
  (id:  91; name: 'ASK_CHOICE_OBJ'),
  (id:  92; name: 'CINEMA_MODE'),
  (id:  93; name: 'SAVE_HERO'),
  (id:  94; name: 'RESTORE_HERO'),
  (id:  95; name: 'ANIM_SET'),
  (id:  96; name: 'PLUIE'), //org
  (id:  96; name: 'RAIN'),  //alias
  (id:  97; name: 'GAME_OVER'),
  (id:  98; name: 'THE_END'),
  (id:  99; name: 'ESCALATOR'), //org
  (id:  99; name: 'CONVEYOR'),  //alias
  (id: 100; name: 'PLAY_MUSIC'),
  (id: 101; name: 'TRACK_TO_VAR_GAME'),
  (id: 102; name: 'VAR_GAME_TO_TRACK'),
  (id: 103; name: 'ANIM_TEXTURE'),
  (id: 104; name: 'ADD_MESSAGE_OBJ'),
  (id: 105; name: 'BRUTAL_EXIT'),
  (id: 106; name: 'REMP'),    //org
  (id: 106; name: 'REPLACE'), //alias
  (id: 107; name: 'ECHELLE'), //org
  (id: 107; name: 'LADDER'),  //alias
  (id: 108; name: 'SET_ARMURE'), //org
  (id: 108; name: 'SET_ARMOUR'), //alias
  (id: 109; name: 'SET_ARMURE_OBJ'), //org
  (id: 109; name: 'SET_ARMOUR_OBJ'), //alias
  (id: 110; name: 'ADD_LIFE_POINT_OBJ'),
  (id: 111; name: 'STATE_INVENTORY'),
  (id: 112; name: 'AND_IF'),
  (id: 113; name: 'SWITCH'),
  (id: 114; name: 'OR_CASE'),
  (id: 115; name: 'CASE'),
  (id: 116; name: 'DEFAULT'),
  (id: 117; name: 'BREAK'),
  (id: 118; name: 'END_SWITCH'),
  (id: 119; name: 'SET_HIT_ZONE'),
  (id: 120; name: 'SAVE_COMPORTEMENT'), //org
  (id: 120; name: 'SAVE_COMPORTMENT'),  //alias
  (id: 120; name: 'SAVE_COMP'),         //alias
  (id: 121; name: 'RESTORE_COMPORTEMENT'), //org
  (id: 121; name: 'RESTORE_COMPORTMENT'),  //alias
  (id: 121; name: 'RESTORE_COMP'),         //alias
  (id: 122; name: 'SAMPLE'),
  (id: 123; name: 'SAMPLE_RND'),
  (id: 124; name: 'SAMPLE_ALWAYS'),
  (id: 125; name: 'SAMPLE_STOP'),
  (id: 126; name: 'REPEAT_SAMPLE'),
  (id: 127; name: 'BACKGROUND'),
  (id: 128; name: 'ADD_VAR_GAME'),
  (id: 129; name: 'SUB_VAR_GAME'),
  (id: 130; name: 'ADD_VAR_CUBE'),
  (id: 131; name: 'SUB_VAR_CUBE'),
  (id: 133; name: 'SET_RAIL'),
  (id: 134; name: 'INVERSE_BETA'),
  (id: 135; name: 'NO_BODY'),
  (id: 136; name: 'ADD_GOLD_PIECES'),
  (id: 137; name: 'STOP_L_TRACK_OBJ'), //org
  (id: 137; name: 'STOP_TRACK_OBJ'),   //alias
  (id: 138; name: 'RESTORE_L_TRACK_OBJ'), //org
  (id: 138; name: 'RESTORE_TRACK_OBJ'),   //alias
  (id: 139; name: 'SAVE_COMPORTEMENT_OBJ'), //org
  (id: 139; name: 'SAVE_COMPORTMENT_OBJ'),  //alias
  (id: 139; name: 'SAVE_COMP_OBJ'),         //alias
  (id: 140; name: 'RESTORE_COMPORTEMENT_OBJ'), //org
  (id: 140; name: 'RESTORE_COMPORTMENT_OBJ'),  //alias
  (id: 140; name: 'RESTORE_COMP_OBJ'),         //alias
  (id: 141; name: 'SPY'),
  (id: 142; name: 'DEBUG'),
  (id: 143; name: 'DEBUG_OBJ'),
  (id: 144; name: 'POPCORN'),
  (id: 145; name: 'FLOW_POINT'),
  (id: 146; name: 'FLOW_OBJ'),
  (id: 147; name: 'SET_ANIM_DIAL'),
  (id: 148; name: 'PCX'),
  (id: 149; name: 'END_MESSAGE'),
  (id: 150; name: 'END_MESSAGE_OBJ'),
  (id: 151; name: 'PARM_SAMPLE'),
  (id: 152; name: 'NEW_SAMPLE'),
  (id: 153; name: 'POS_OBJ_AROUND'),
  (id: 154; name: 'PCX_MESS_OBJ')
);

Var2DecompList: array[0..45] of String = //orgignal macro names
( 'COL',               //  0
  'COL_OBJ',           //  1
  'DISTANCE',          //  2
  'ZONE',              //  3
  'ZONE_OBJ',          //  4
  'BODY',              //  5
  'BODY_OBJ',          //  6
  'ANIM',              //  7
  'ANIM_OBJ',          //  8
  'L_TRACK',           //  9
  'L_TRACK_OBJ',       // 10
  'VAR_CUBE',          // 11
  'CONE_VIEW',         // 12
  'HIT_BY',            // 13
  'ACTION',            // 14
  'VAR_GAME',          // 15
  'LIFE_POINT',        // 16
  'LIFE_POINT_OBJ',    // 17
  'NB_LITTLE_KEYS',    // 18
  'NB_GOLD_PIECES',    // 19
  'COMPORTEMENT_HERO', // 20
  'CHAPTER',           // 21
  'DISTANCE_3D',       // 22
  'MAGIC_LEVEL',       // 23
  'MAGIC_POINT',       // 24
  'USE_INVENTORY',     // 25
  'CHOICE',            // 26
  'FUEL',              // 27
  'CARRY_BY',          // 28
  'CDROM',             // 29
  'ECHELLE',           // 30 
  'RND',               // 31
  'RAIL',              // 32
  'BETA',              // 33
  'BETA_OBJ',          // 34
  'CARRY_OBJ_BY',      // 35
  'ANGLE',             // 36
  'DISTANCE_MESSAGE',  // 37
  'HIT_OBJ_BY',	       //	38
  'REAL_ANGLE',        // 39
  'DEMO',		           //	40
  'COL_DECORS',		     // 41
  'COL_DECORS_OBJ',	   // 42
  'PROCESSOR',	       //	43
  'OBJECT_DISPLAYED',	 // 44
  'ANGLE_OBJ'          // 45
);

Var2ModsComp: array[0..0] of TMacroModItem = //Comportment
(
  (id: 20; name: 'COMPORTMENT_HERO')
);

Var2ModsEng: array[0..7] of TMacroModItem = //English macro names
(
  (id:  9; name: 'CURRENT_TRACK'),
  (id: 10; name: 'CURRENT_TRACK_OBJ'),
  (id: 18; name: 'NUM_LITTLE_KEYS'),
  (id: 19; name: 'NUM_GOLD_PIECES'),
  (id: 20; name: 'BEHAVIOUR'),
  (id: 28; name: 'CARRIED_BY'),
  (id: 30; name: 'LADDER'),
  (id: 35; name: 'CARRIED_OBJ_BY')
);

Var2CompList: array[0..54] of TMacroModItem =
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
  (id: 11; name: 'VAR_CUBE'),
  (id: 12; name: 'CONE_VIEW'),
  (id: 13; name: 'HIT_BY'),
  (id: 14; name: 'ACTION'),
  (id: 15; name: 'VAR_GAME'),
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
  (id: 23; name: 'MAGIC_LEVEL'),
  (id: 24; name: 'MAGIC_POINT'),
  (id: 25; name: 'USE_INVENTORY'),
  (id: 26; name: 'CHOICE'),
  (id: 27; name: 'FUEL'),
  (id: 28; name: 'CARRY_BY'),   //org
  (id: 28; name: 'CARRIED_BY'), //alias
  (id: 29; name: 'CDROM'),
  (id: 30; name: 'ECHELLE'), //org
  (id: 30; name: 'LADDER'),  //alias
  (id: 31; name: 'RND'),
  (id: 32; name: 'RAIL'),
  (id: 33; name: 'BETA'),
  (id: 34; name: 'BETA_OBJ'),
  (id: 35; name: 'CARRY_OBJ_BY'),   //org
  (id: 35; name: 'CARRIED_OBJ_BY'), //alias
  (id: 36; name: 'ANGLE'),
  (id: 37; name: 'DISTANCE_MESSAGE'),
  (id: 38; name: 'HIT_OBJ_BY'),
  (id: 39; name: 'REAL_ANGLE'),
  (id: 40; name: 'DEMO'),
  (id: 41; name: 'COL_DECORS'),
  (id: 42; name: 'COL_DECORS_OBJ'),
  (id: 43; name: 'PROCESSOR'),
  (id: 44; name: 'OBJECT_DISPLAYED'),
  (id: 45; name: 'ANGLE_OBJ')
);

Behav2DecompList: array[0..lb2MAX_OPCODE] of String =
(
  'NORMAL',     // 0
  'SPORTY',     // 1
  'AGGRESSIVE', // 2
  'DISCREET',   // 3
  'JETPACK',
  'BEHAV5',
  'BEHAV6',
  'BEHAV7',
  'BEHAV8',
  'BEHAV9',
  'BEHAV10',
  'BEHAV11',
  'BEHAV12', //may be inside the car
  'BEHAV13'
);

Behav2CompList: array[0..13] of TMacroModItem =
(
  (id:  0; name: 'NORMAL'),
  (id:  1; name: 'SPORTY'),
  (id:  2; name: 'AGGRESSIVE'),
  (id:  3; name: 'DISCREET'),
  (id:  4; name: 'JETPACK'),
  (id:  5; name: 'BEHAV5'),
  (id:  6; name: 'BEHAV6'),
  (id:  7; name: 'BEHAV7'),
  (id:  8; name: 'BEHAV8'),
  (id:  9; name: 'BEHAV9'),
  (id: 10; name: 'BEHAV10'),
  (id: 11; name: 'BEHAV11'),
  (id: 12; name: 'BEHAV12'),
  (id: 13; name: 'BEHAV13')
);

// Direction Modes List
Dirm2DecompList: array [0..ld2MAX_OPCODE] of String =
(
  'NO_MOVE',
  'MANUAL',
  'FOLLOW',
  '', //'TRACK'
  '', //'FOLLOW_2'
  '', //'TRACK_ATTACK'
  'SAME_XZ',
  '', //'RANDOM'
  'RAIL',
  'DIRMODE9',
  'DIRMODE10',
  'DIRMODE11',
  'DIRMODE12',
  'DIRMODE13'   //may be the car drive
);

Dirm2CompList: array [0..9] of TMacroModItem =
(
  (id:  0; name: 'NO_MOVE'),
  (id:  1; name: 'MANUAL'),
  (id:  2; name: 'FOLLOW'),
  //disabled: TRACK, FOLLOW_2, TRACK_ATTACK, RANDOM
  (id:  6; name: 'SAME_XZ'),
  (id:  8; name: 'RAIL'),
  (id:  9; name: 'DIRMODE9'),
  (id: 10; name: 'DIRMODE10'),
  (id: 11; name: 'DIRMODE11'),
  (id: 12; name: 'DIRMODE12'),
  (id: 13; name: 'DIRMODE13') 
);

Track2Props: array[0..tm2MAX_OPCODE] of TCommandProp =
(
  (ParCount: 0; Flags: []),                                  //END               0
  (ParCount: 0; Flags: []),                                  //NOP               1
  (ParCount: 1; Flags: [];                                   //BODY              2
   ParSize: (1,0,0,0); ParRng: (@RngSByte_1, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                   //ANIM              3
   ParSize: (2,0,0,0); ParRng: (@RngUWord, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                   //GOTO_POINT        4
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 0; Flags: []),                                  //WAIT_ANIM         5
  (ParCount: 0; Flags: []),                                  //LOOP              6
  (ParCount: 1; Flags: [];                                   //ANGLE             7
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                   //POS_POINT         8
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                   //LABEL             9
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                   //GOTO             10
   ParSize: (2,0,0,0); ParRng: (@RngHWord_1, nil, nil, nil)),
  (ParCount: 0; Flags: []),                                  //STOP             11
  (ParCount: 1; Flags: [];                                   //GOTO_SYM_POINT   12
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 2; Flags: [cfPar2Dummy];                        //WAIT_NUM_ANIM    13
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount: 1; Flags: [];                                   //SAMPLE           14
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                   //GOTO_POINT_3D    15
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                   //SPEED            16
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                   //BACKGROUND       17
   ParSize: (1,0,0,0); ParRng: (@RngBool, nil, nil, nil)),
  (ParCount: 2; Flags: [cfPar2Dummy];                        //WAIT_NUM_SECOND  18
   ParSize: (1,4,0,0); ParRng: (@RngUByte, @RngZero, nil, nil)),
  (ParCount: 0; Flags: []),                                  //NO_BODY          19
  (ParCount: 1; Flags: [];                                   //BETA             20
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                   //OPEN_LEFT        21
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                   //OPEN_RIGHT       22
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                   //OPEN_UP          23
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                   //OPEN_DOWN        24
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 0; Flags: []),                                  //CLOSE            25
  (ParCount: 0; Flags: []),                                  //WAIT_DOOR        26
  (ParCount: 1; Flags: [];                                   //SAMPLE_RND       27
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                   //SAMPLE_ALWAYS    28
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                   //SAMPLE_STOP      29
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount:-1; Flags: []),                                  //PLAY_ACF         30 //PLAY_SMK?
  (ParCount: 1;Flags: [];                                    //REPEAT_SAMPLE    31
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                   //SIMPLE_SAMPLE    32
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; Flags: [cfPar1Dummy];                        //FACE_HERO        33
   ParSize: (2,0,0,0); ParRng: (@RngMWord, nil, nil, nil)),
  (ParCount: 2; Flags: [cfPar2Dummy];                        //ANGLE_RND        34
   ParSize: (2,2,0,0); ParRng: (@RngHWord_1, @RngMWord, nil, nil)),
  (ParCount: 0; Flags: []),                                  //REPLACE          35
  (ParCount: 2; Flags: [cfPar2Dummy];                        //WAIT_NUM_DECIMAL 36
   ParSize: (1,4,0,0); ParRng: (@RngUByte, @RngZero, nil, nil)),
  (ParCount: 0; Flags: []),                                  //DO               37
  (ParCount: 1; Flags: [];                                   //SPRITE           38
   ParSize: (2,0,0,0); ParRng: (@RngHWord_1, nil, nil, nil)),
  (ParCount: 2; Flags: [cfPar2Dummy];                        //WAIT_NUM_SECOND_RND 39
   ParSize: (1,4,0,0); ParRng: (@RngUByte, @RngZero, nil, nil)),
  (ParCount: 0; Flags: []),                                  //AFF_TIMER        40
  (ParCount: 1; Flags: [];                                   //SET_FRAME	       41
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                   //SET_FRAME_3DS	   42
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                   //SET_START_3DS	   43
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                   //SET_END_3DS	     44
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                   //START_ANIM_3DS   45
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 0; Flags: [];                                   //STOP_ANIM_3DS    46
   ParSize: (1,2,0,0); ParRng: (@RngUByte, @RngZero, nil, nil)),
  (ParCount: 0; Flags: []),                                  //WAIT_ANIM_3DS    47
  (ParCount: 0; Flags: []),                                  //WAIT_FRAME_3DS   48
  (ParCount: 2; Flags: [cfPar2Dummy];                        //WAIT_NUM_DECIMAL_RND 49
   ParSize: (1,4,0,0); ParRng: (@RngUByte, @RngZero, nil, nil)),
  (ParCount: 1; Flags: [];                                   //INTERVAL         50
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                   //FREQUENCY 	     51
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 1; Flags: [];                                   //VOLUME           52
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil))
);

Life2Props: array[0..lm2MAX_OPCODE] of TCommandProp =
(
  (ParCount: 0; cType: ctCommand; Flags: []),                   //END            0
  (ParCount: 0; cType: ctCommand; Flags: []),                   //NOP            1
  (ParCount: 0; cType: ctIf;      Flags: []),                   //SNIF           2
  (ParCount: 1; cType: ctCommand; Flags: [];                    //OFFSET         3
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 0; cType: ctIf;      Flags: []),                   //NEVERIF        4
  (ParCount: 0; cType: ctCommand; Flags: []),                   //               5
  (ParCount: 0; cType: ctCommand; Flags: []),                   //               6
  (ParCount: 0; cType: ctCommand; Flags: []),                   //               7
  (ParCount: 0; cType: ctCommand; Flags: []),                   //               8
  (ParCount: 0; cType: ctCommand; Flags: []),                   //               9
  (ParCount: 1; cType: ctCommand; Flags: [];                    //PALETTE       10
   ParSize: (1,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //RETURN        11
  (ParCount: 0; cType: ctIf;      Flags: []),                   //IF            12
  (ParCount: 0; cType: ctIf;      Flags: []),                   //SWIF          13
  (ParCount: 0; cType: ctIf;      Flags: []),                   //ONEIF         14
  (ParCount: 1; cType: ctCommand; Flags: [];                    //ELSE          15
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 0; cType: ctVirtual; Flags: []),                   //ENDIF         16
  (ParCount: 1; cType: ctCommand; Flags: [];                    //BODY          17
   ParSize: (1,0,0,0); ParRng: (@RngSByte_1, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [cfP1Actor];           //BODY_OBJ      18
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngSByte_1, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //ANIM          19
   ParSize: (2,0,0,0); ParRng: (@RngHWord_1, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [cfP1Actor];           //ANIM_OBJ      20
   ParSize: (1,2,0,0); ParRng: (@RngUByte, @RngHWord_1, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_CAMERA    21
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //CAMERA_CENTER 22
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_TRACK     23
   ParSize: (2,0,0,0); ParRng: (@RngHWord_1, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [cfP1Actor];           //SET_TRACK_OBJ 24
   ParSize: (1,2,0,0); ParRng: (@RngUByte, @RngHWord_1, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //MESSAGE       25
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //CAN_FALL      26
   ParSize: (1,0,0,0); ParRng: (@RngTriple, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_DIRMODE     27
   ParSize: (1,0,0,0); ParRng: (@RngDMod13, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [cfP1Actor];           //SET_DIRMODE_OBJ 28
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngDMod13, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [cfP1Actor];           //CAM_FOLLOW    29
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_BEHAVIOUR   30
   ParSize: (1,0,0,0); ParRng: (@RngBeh13, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [];                    //SET_VAR_CUBE  31
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount: 1; cType: ctVirtual; Flags: [];                    //COMPORTMENT           32
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_COMPORTMENT       33
   ParSize: (2,0,0,0); ParRng: (@RngHWord_1, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [cfP1Actor];           //SET_COMPORTMENT_OBJ   34
   ParSize: (1,2,0,0); ParRng: (@RngUByte, @RngHWord_1, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //END_COMPORTMENT       35
  (ParCount: 2; cType: ctCommand; Flags: [];                    //SET_VAR_GAME  36
   ParSize: (1,2,0,0); ParRng: (@RngUByte, @RngUWord, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [cfP1Actor];           //KILL_OBJ      37
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //SUICIDE       38
  (ParCount: 0; cType: ctCommand; Flags: []),                   //USE_ONE_LITTLE_KEY     39
  (ParCount: 1; cType: ctCommand; Flags: [];                    //GIVE_GOLD_PIECES       40
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //END_LIFE      41
  (ParCount: 0; cType: ctCommand; Flags: []),                   //STOP_L_TRACK           42
  (ParCount: 0; cType: ctCommand; Flags: []),                   //RESTORE_L_TRACK        43
  (ParCount: 2; cType: ctCommand; Flags: [cfP1Actor];           //MESSAGE_OBJ   44
   ParSize: (1,2,0,0); ParRng: (@RngUByte, @RngHWord0, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //INC_CHAPTER   45
  (ParCount: 1; cType: ctCommand; Flags: [];                    //FOUND_OBJECT  46
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_DOOR_LEFT          47
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_DOOR_RIGHT         48
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_DOOR_UP            49
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_DOOR_DOWN          50
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //GIVE_BONUS    51
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //CHANGE_CUBE   52
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //OBJ_COL       53
   ParSize: (1,0,0,0); ParRng: (@RngBool, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //BRICK_COL     54
   ParSize: (1,0,0,0); ParRng: (@RngTriple, nil, nil, nil)),
  (ParCount: 0; cType: ctIf;      Flags: []),                   //OR_IF         55
  (ParCount: 1; cType: ctCommand; Flags: [];                    //INVISIBLE     56
   ParSize: (1,0,0,0); ParRng: (@RngBool, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [];                    //SHADOW_OBJ    57
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //POS_POINT     58
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_MAGIC_LEVEL        59
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SUB_MAGIC_POINT        60
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [cfP1Actor];           //SET_LIFE_POINT_OBJ     61
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [cfP1Actor];           //SUB_LIFE_POINT_OBJ     62
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [cfP1Actor];           //HIT_OBJ       63
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount:-1; cType: ctCommand; Flags: []),                   //PLAY_ACF      64
  (ParCount: 1; cType: ctCommand; Flags: [];                    //ECLAIR        65
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //INC_CLOVER_BOX         66
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_USED_INVENTORY     67
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //ADD_CHOICE    68
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //ASK_CHOICE    69
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //INIT_BUGGY    70
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //MEMO_SLATE    71
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_HOLO_POS  72
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //CLR_HOLO_POS  73
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //ADD_FUEL      74
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SUB_FUEL      75
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [];                    //SET_GRM       76
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngBool, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_CHANGE_CUBE        77
   ParSize: (2,0,0,0); ParRng: (@RngUWord, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //MESSAGE_ZOE   78
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //FULL_POINT    79
  (ParCount: 1; cType: ctCommand; Flags: [];                    //BETA          80
   ParSize: (2,0,0,0); ParRng: (@RngSWord, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //FADE_TO_PAL   81
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //ACTION        82
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_FRAME     83
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_SPRITE    84
   ParSize: (2,0,0,0); ParRng: (@RngHWord_1, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_FRAME_3DS 85
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 3; cType: ctCommand; Flags: [cfP1Actor];           //IMPACT_OBJ    86
   ParSize: (1,2,2,0); ParRng: (@RngUByte, @RngUWord, @RngUWord, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [];                    //IMPACT_POINT  87
   ParSize: (1,2,0,0); ParRng: (@RngUByte, @RngUWord, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //ADD_MESSAGE   88
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //BALLOON       89
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //NO_SHOCK      90
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [cfP1Actor];           //ASK_CHOICE_OBJ 91
   ParSize: (1,2,0,0); ParRng: (@RngUByte, @RngHWord0, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //CINEMA_MODE   92
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //SAVE_HERO     93
  (ParCount: 0; cType: ctCommand; Flags: []),                   //RESTORE_HERO  94
  (ParCount: 1; cType: ctCommand; Flags: [];                    //ANIM_SET      95
   ParSize: (2,0,0,0); ParRng: (@RngHWord_1, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //RAIN          96
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //GAME_OVER     97
  (ParCount: 0; cType: ctCommand; Flags: []),                   //THE_END       98
  (ParCount: 1; cType: ctCommand; Flags: [];                    //ESCALATOR     99
   ParSize: (2,0,0,0); ParRng: (@RngUWord, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //PLAY_MUSIC   100
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //TRACK_TO_VAR_GAME 101
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //VAR_GAME_TO_TRACK 102
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //ANIM_TEXTURE 103
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [cfP1Actor];           //ADD_MESSAGE_OBJ   104
   ParSize: (1,2,0,0); ParRng: (@RngUByte, @RngHWord0, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //BRUTAL_EXIT  105
  (ParCount: 0; cType: ctCommand; Flags: []),                   //REPLACE      106 //REM
  (ParCount: 2; cType: ctCommand; Flags: [];                    //SCALE      107 //ECHELLE
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_ARMOR    108 //SET_ARMURE
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [cfP1Actor];           //SET_ARMOR_OBJ      109
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [cfP1Actor];           //ADD_LIFE_POINT_OBJ 110
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [];                    //STATE_INVENTORY    111
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount: 0; cType: ctIf;      Flags: []),                   //AND_IF       112
  (ParCount: 0; cType: ctIf;      Flags: []),                   //SWITCH       113
  (ParCount: 2; cType: ctCommand; Flags: [];                    //OR_CASE      114
   ParSize: (2,1,0,0); ParRng: (@RngUWord, @RngUByte, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [];                    //CASE         115
   ParSize: (2,1,0,0); ParRng: (@RngUWord, @RngUByte, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: [];                    //DEFAULT      116
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //BREAK        117 --special case!
   ParSize: (2,0,0,0); ParRng: (@RngUWord, nil, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //END_SWITCH   118
  (ParCount: 2; cType: ctCommand; Flags: [];                    //SET_HIT_ZONE       119
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //SAVE_COMPORTMENT        120
  (ParCount: 0; cType: ctCommand; Flags: []),                   //RESTORE_COMPORTMENT     121
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SAMPLE             122
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SAMPLE_RND         123
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SAMPLE_ALWAYS      124
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SAMPLE_STOP        125
   ParSize: (2,0,0,0); ParRng: (@RngHWord0, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [];                    //REPEAT_SAMPLE      126
   ParSize: (2,1,0,0); ParRng: (@RngHWord0, @RngUByte, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //BACKGROUND   127
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [];                    //ADD_VAR_GAME 128
   ParSize: (1,2,0,0); ParRng: (@RngUByte, @RngUWord, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [];                    //SUB_VAR_GAME 129
   ParSize: (1,2,0,0); ParRng: (@RngUByte, @RngUWord, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [];                    //ADD_VAR_CUBE 130
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [];                    //SUB_VAR_CUBE 131
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //#define LM_NOP     132
  (ParCount: 2; cType: ctCommand; Flags: [];                    //SET_RAIL           133
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //INVERSE_BETA       134
  (ParCount: 0; cType: ctCommand; Flags: []),                   //NO_BODY            135
  (ParCount: 1; cType: ctCommand; Flags: [];                    //ADD_GOLD_PIECES    136
   ParSize: (2,0,0,0); ParRng: (@RngUWord, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [cfP1Actor];           //STOP_CURRENT_TRACK_OBJ   137
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [cfP1Actor];           //RESTORE_LAST_TRACK_OBJ   138
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [cfP1Actor];           //SAVE_COMPORTMENT_OBJ    139
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [cfP1Actor];           //RESTORE_COMPORTMENT_OBJ 140
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SPY  		     141
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //DEBUG	       142
  (ParCount: 1; cType: ctCommand; Flags: [cfP1Actor];           //DEBUG_OBJ  	 143
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //POPCORN 		 144
  (ParCount: 2; cType: ctCommand; Flags: [];                    //FLOW_POINT 	 145
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount: 2; cType: ctCommand; Flags: [cfP1Actor];           //FLOW_OBJ		 146
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //SET_ANIM_DIAL      147
   ParSize: (2,0,0,0); ParRng: (@RngHWord_1, nil, nil, nil)),
  (ParCount: 1; cType: ctCommand; Flags: [];                    //PCX 		   	 148
   ParSize: (2,0,0,0); ParRng: (@RngUWord, nil, nil, nil)),
  (ParCount: 0; cType: ctCommand; Flags: []),                   //END_MESSAGE	 149
  (ParCount: 1; cType: ctCommand; Flags: [cfP1Actor];           //END_MESSAGE_OBJ    150
   ParSize: (1,0,0,0); ParRng: (@RngUByte, nil, nil, nil)),
  (ParCount: 3; cType: ctCommand; Flags: [];                    //PARM_SAMPLE		     151
   ParSize: (2,1,2,0); ParRng: (@RngHWord0, @RngUByte, @RngUWord, nil)),
  (ParCount: 4; cType: ctCommand; Flags: [];                    //NEW_SAMPLE		     152
   ParSize: (2,2,1,2); ParRng: (@RngUWord, @RngUWord, @RngUByte, @RngUWord)),
  (ParCount: 2; cType: ctCommand; Flags: [cfP1Actor];           //POS_OBJ_AROUND	   153
   ParSize: (1,1,0,0); ParRng: (@RngUByte, @RngUByte, nil, nil)),
  (ParCount: 3; cType: ctCommand; Flags: [cfP1Actor];           //PCX_MESS_OBJ       154
   ParSize: (1,2,2,0); ParRng: (@RngUByte, @RngUWord, @RngUWord, nil))
);

Var2Props: array[0..lv2MAX_OPCODE] of TVariableProp =
(
  (HasParam: False; Flags: [vfCmpActor];               //COL               0
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: True;  Flags: [vfParActor, vfCmpActor];   //COL_OBJ           1
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: True;  Flags: [vfParActor];               //DISTANCE          2
     RetSize: 2; RetRange: @RngDist),
  (HasParam: False; Flags: [];                         //ZONE              3
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: True;  Flags: [vfParActor];               //ZONE_OBJ          4
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: False; Flags: [];                         //BODY              5
     RetSize: 1; RetRange: @RngSByte_1),
  (HasParam: True;  Flags: [vfParActor];               //BODY_OBJ          6
     RetSize: 1; RetRange: @RngSByte_1),
  (HasParam: False; Flags: [];                         //ANIM              7
     RetSize: 2; RetRange: @RngUWord),
  (HasParam: True;  Flags: [vfParActor];               //ANIM_OBJ          8
     RetSize: 2; RetRange: @RngUWord),
  (HasParam: False; Flags: [];                         //CURRENT_TRACK     9
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: True;  Flags: [vfParActor];               //CURRENT_TRACK_OBJ 10
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: True;  Flags: [];                         //VAR_CUBE         11
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: True;  Flags: [vfParActor];               //CONE_VIEW        12
     RetSize: 2; RetRange: @RngDist),
  (HasParam: False; Flags: [vfParActor, vfCmpActor];   //HIT_BY           13
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: False; Flags: [];                         //ACTION           14
     RetSize: 1; RetRange: @RngTriple),
  (HasParam: True;  Flags: [];                         //VAR_GAME         15
     RetSize: 2; RetRange: @RngUWord),
  (HasParam: False; Flags: [];                         //LIFE_POINT       16
     RetSize: 2; RetRange: @RngUWord),
  (HasParam: True;  Flags: [vfParActor];               //LIFE_POINT_OBJ   17
     RetSize: 2; RetRange: @RngUWord),
  (HasParam: False; Flags: [];                         //NUM_LITTLE_KEYS  18
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: False; Flags: [];                         //NUM_GOLD_PIECES  19
     RetSize: 2; RetRange: @RngGold),
  (HasParam: False; Flags: [];                         //BEHAVIOUR        20
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: False; Flags: [];                         //CHAPTER          21
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: True;  Flags: [vfParActor];               //DISTANCE_3D      22
     RetSize: 2; RetRange: @RngDist),
  (HasParam: False; Flags: [];                         //MAGIC_LEVEL      23
     RetSize: 1; RetRange: @RngMag4),
  (HasParam: False; Flags: [];                         //MAGIC_POINT      24
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: True;  Flags: [];                         //USE_INVENTORY    25
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: False; Flags: [];                         //CHOICE           26
     RetSize: 2; RetRange: @RngHWord0),
  (HasParam: False; Flags: [];                         //FUEL             27
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: False; Flags: [vfCmpActor];               //CARRIED_BY       28
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: False; Flags: [];                         //CDROM            29
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: False; Flags: [];                         //ECHELLE          30
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: True;  Flags: [];                         //RND              31
     RetSize: 1; RetRange: @RngSWord),
  (HasParam: True;  Flags: [];                         //RAIL             32
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: False; Flags: [];                         //BETA             33
     RetSize: 2; RetRange: @RngHWord0),
  (HasParam: True;  Flags: [vfParActor];               //BETA_OBJ         34
     RetSize: 2; RetRange: @RngHWord0),
  (HasParam: True;  Flags: [vfParActor, vfCmpActor];   //CARRIED_OBJ_BY   35
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: True;  Flags: [vfParActor];               //ANGLE            36
     RetSize: 2; RetRange: @RngHWord0),
  (HasParam: True;  Flags: [vfParActor];               //DISTANCE_MESSAGE 37
     RetSize: 2; RetRange: @RngHWord0),
  (HasParam: True;  Flags: [vfParActor, vfCmpActor];   //HIT_OBJ_BY		    38
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: True;  Flags: [vfParActor];               //REAL_ANGLE       39
     RetSize: 2; RetRange: @RngSWord),
  (HasParam: False; Flags: [];                         //DEMO             40
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: False; Flags: [];                         //COL_DECORS       41
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: True;  Flags: [vfParActor];               //COL_DECORS_OBJ	  42
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: False; Flags: [];                         //PROCESSOR        43
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: True;  Flags: [vfParActor];               //OBJECT_DISPLAYED 44
     RetSize: 1; RetRange: @RngUByte),
  (HasParam: True;  Flags: [vfParActor];               //ANGLE_OBJ        45
     RetSize: 2; RetRange: @RngHWord0)  
);


implementation

end.
