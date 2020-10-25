unit SceneLibConst;

interface

uses Windows, Graphics, Utils, Engine;

const
  //Static flags
  sfColObj   = 1;     //Compute collisions with objects
  sfColBrk   = 2;     //Compute collisions with bricks
  sfZonable  = 4;     //Can detect (test) zones
  sfClipped  = 8;     //Uses clipping
  sfPushable = 16;    //Can be pushed
  sfLowCol   = 32;    //Compute low collisions
  sfFloorTst = 64;    //Can test floor type (not floating over water)
  sfUnused1  = 128;
  sfUnused2  = 256;
  sfHidden   = 512;   //Invisible
  sfSprite   = 1024;  //Is sprite actor
  sfCanFall  = 2048;
  sfNoShadow = 4096;  //i.e. a vampire
  sfBackgrnd = 8192;  //Is backgrounded
  sfCarrier  = 16384; //Can carry something
  sfMiniZV   = 32768; //Uses mini Zone Volumique (whatever that means)

  //Bonus flags
  bfUnknown1  = 1;
  bfUnknown2  = 2;
  bfUnknown3  = 4;
  bfUnknown4  = 8;
  bfMoney     = 16;
  bfLife      = 32;
  bfMagic     = 64;
  bfKey       = 128;
  bfClover    = 256;
  bfUnknown5  = 512;
  bfUnknown6  = 1024;
  bfUnknown7  = 2048;
  bfUnknown8  = 4096;
  bfUnknown9  = 8192;
  bfUnknown10 = 16384;
  bfUnknown11 = 32768;

type
  //Zone types
  TZoneType = (ztCube     = 0,
               ztCamera   = 1,
               ztSceneric = 2,
               ztFragment = 3,
               ztBonus    = 4,
               ztText     = 5,
               ztLadder   = 6,
               //LBA2 only:
               ztConveyor = 7,
               ztHurt     = 8,
               ztRail     = 9
              );
const
  AllZoneTypes = [ztCube..ztRail];


type
  //The following are types used for display the scene objects only
  TPointDispInfo = record
    rX, rY: Integer;       //screen relative position (pixel)
    gX, gY, gZ: Integer;   //grid position
    Caption: String;
    CaptionX, CaptionY: Integer; //caption origin point (relative to rX, rY)
    DrawOriginX, DrawOriginY: Integer; //Origin of the drawing area (NOT of the image)
    DrawWidth, DrawHeight: Integer;
  end;

  TActorDispInfo = record
    rX, rY: Integer;   //screen relative position (pixel)
    gX, gY, gZ: Integer;
    UsesSprite: Boolean;
    Width, Height: Integer; //in pixels
    Sprite: TBitmap;
    Caption: String;
    CaptionX, CaptionY: Integer; //caption origin point (relative to rX, rY)
    DrawOriginX, DrawOriginY: Integer; //(also relative to rX, rY)
    DrawWidth, DrawHeight: Integer;
  end;

  TZoneDispInfo = record
    rX1, rY1, rX2, rY2: Integer; //bottom far and top near corner coords
    gX1, gY1, gZ1, gX2, gY2, gZ2: Integer; //same as above but in Grid coords
    h: Integer; //height in screen pixels
    sX1, sY1, sX2, sY2: Integer; //pixel coordinates of the bottom left and right corners
    Caption: String; //because sceneric zones have their id included in caption
    CaptionX, CaptionY: Integer; //caption origin point (relative to rX1, rY1)
    DrawOriginX, DrawOriginY: Integer; //(also relative from rX1, rY1)
    DrawWidth, DrawHeight: Integer;
  end;

  TScriptFragOffset = record
    Fragment: Cardinal; //Fragment index
    Offset: Cardinal; //0-based offset in the binary Life Script
  end;

  TScriptFragInfo = array of TScriptFragOffset;

  TDecompError = (
    derrNoError = 0,
    derrTrackNoLabel = 1, //Track Script GOTO doesn't point to a LABEL
    derrLifeNoTrack = 2,  //Life Script SET_TRACK doesn't point to a Track LABEL
    derrLifeNoActor = 3,  //Life Script SET_TRACK_OBJ doesn't point to an existing actor
    derrLifeNoComp = 4,   //Life Script SET_COMPORTMENT(_OBJ) doesn't point to a COMPORTMENT
    derrCompNoActor = 5,  //Life Script SET_COMPORTMENT_OBJ doesn't point to an existing actor
    derrNoComAddr = 6,    //Life Script SET_COMPORTMENT(_OBJ) doesn't point to beginning of a command
    derrCodeAfterEnd = 7, //Code bytes after END
    derrBadOpcode = 8,    //Unknown opcode
    derrLifeCaseExp = 9,  //CASE expected
    derrNoEND = 10,       //No END at the end of script
    derrCaseNoSwitch = 11 //CASE without prior SWITCH
  );

  TLbHashTable = array of record
    Offset: Word;
    Used: Boolean;
    Line: Integer;
    //Some info in for index LABEL names in compilation, LWO
    LabelName:String;
  end;

  TCompList = array of record
    Name: String;
    Offset: Word;
    Used: Boolean;
    Line: Integer;
  end;

  TDecTxtFlags = set of (dtCmpBehav, dtCmpActor, dtIfType);

  TCommandFlag = (cfPar1Dummy, cfPar2Dummy, cfP1Actor, //command flags
                  ofForAndif,                          //operator flags
                  vfParActor, vfCmpActor);             //var flags
  TCommandType = (
    ctCommand  = 0,
    ctIf       = 1,
    ctVariable = 2,
    ctOperator = 4,
    ctVirtual  = 5,
    ctSwVar    = 6,
    ctError    = 7 //for error-only commands
  );

  TCommandProp = record
    ParCount: Integer; //number of command parameters (-1 = text param)
    cType: TCommandType;
    Flags: set of TCommandFlag;
    ParSize: array[0..3] of Integer; //number of bytes used by each parameter
    //ParRng: array[0..3] of TRange; //range of accepted values
    ParRng: array[0..3] of PRange;
  end;
  TCommandProps = array of TCommandProp;
  PCommandProps = ^TCommandProps;
  //Special cases for TCommandProp (during compilation):
  //  ctIf:
  //    no params, just the command
  //  ctVariable, ctSwVar:
  //    first param is the varible param, if it requires any
  //  ctOperator:
  //    first param is the variable comparison value,
  //    second param for IF, AND_IF: jump address if comparison is not true (ENDIF, ELSE, next CASE)
  //    second param for OR_IF: jump address if the comparison is true
  //  ELSE:
  //    first param is the address to jump to (the first comand after ENDIF)
  //  CASE:
  //    first param: jump address if comparison is not true (next (OR_)CASE)
  //  OR_CASE:
  //    first param: jump address if comparison is true (first cmd after CASE)
  //  DEFAULT:
  //    no params
  //  BREAK:
  //    first param is the address to jump to (DEFAULT or END_CASE)

  TVariableProp = record
    HasParam: Boolean; //whether condition has a parameter (max one parameter may exist)
                       //  parameter is always 1 byte long with range 0-255
    Flags: set of TCommandFlag;
    RetSize: Integer;  //number of bytes for the returned value
    RetRange: PRange;  //range of the returned value
  end;
  TVariableProps = array of TVariableProp;
  PVariableProps = ^TVariableProps;

  TTransCommand = record
    Code: Byte;
    Offset: Integer; //In binary Script
    Line: Integer; //In text Script
    cType: TCommandType;
    ParCount: Integer;
    ParSize: array [0..3] of Integer;
    Params: array [0..3] of Integer;
    ParamStr: String;
    Flags: set of TCommandFlag;
    Error: TDecompError;
  end;
  TTransTable = array of TTransCommand;
  TTransTables = array of TTransTable;

  // Actor structure
  TSceneActor = record
    StaticFlags: WORD;
    Unknown: WORD; // LBA2 flags ??
    Entity: SmallInt; //WORD;
    Body: Byte;
    BodyAdd: Byte; //a flag for LBA2
    Anim: Byte;
    Sprite: WORD;
    X: SmallInt;
    Y: SmallInt;
    Z: SmallInt;
    HitPower: Byte;
    BonusType: WORD;
    Angle: WORD;
    RotSpeed: WORD;
    CtrlMode: Byte;
    CtrlUnk: Byte;
    Info0: SmallInt; // for various uses
    Info1: SmallInt;
    Info2: SmallInt;
    Info3: SmallInt;
    BonusAmount: Word;
    TalkColor: Byte;
    UData: String; //unknown data, present only if Unknown = 4
    Armour: Byte;
    LifePoints: Byte;
    TrackScriptBin: String;
    LifeScriptBin: String;

    //Various info not present in the scripts:
    Name: string;
    IsSprite: Boolean;
    FollowId: SmallInt; //when CtrlMode = follow, sometimes > 255 for LBA2 (???)
    TrackScriptTxt: string;
    LifeScriptTxt: string;
    TrackScriptCoords: TPoint; //scroll positions of the editor
    //TrackScriptCaret: TPoint; //caret position in the editor
    LifeScriptCoords: TPoint;
    //LifeScriptCaret: TPoint;
    FragmentInfo: TScriptFragInfo;
    UndoRedoIndex: Integer;
    DispInfo: TActorDispInfo;
  end;

  TSceneZone = record
    X1: Integer; //2-byte signed Little Endian for LBA1, 4-byte signed for LBA2
    Y1: Integer;
    Z1: Integer;
    X2: Integer;
    Y2: Integer;
    Z2: Integer;
    ZType: WORD;
    Info: array[0..7] of DWORD;
    Snap: WORD;

    //Various info not present in the scene
    Name: String;
    RealType: TZoneType;
    TargetCube: Byte;
    TargetPoint: TPoint3d;
    VirtualID: Byte;
    BonusType: Word; //sometimes WORD for LBA2
    BonusQuant: Byte;
    BonusEna: Boolean;
    TextID: Word;
    FragmentName: String;
    FragmentOffset: Cardinal;
    DispInfo: TZoneDispInfo;
  end;

  TScenePoint = record //Formerly: Track
    X: Integer; //2-byte signed Little Endian for LBA1, 4-byte signed for LBA2
    Y: Integer;
    Z: Integer;
    //Info not present in the scene:
    Name: String;
    DispInfo: TPointDispInfo;
  end;

  // Main scene structure definitions
  TScene = record
    TextBank: Byte;
    GameOverScene: Byte;
    UnUsed1: WORD;
    UnUsed2: WORD;
    UnUsed3: Byte; //LBA 2 only
    AlphaLight: WORD;
    BetaLight: WORD;
    SampleAmbience: array[0..3] of SmallInt; // AmbX_1
    SampleRepeat: array[0..3] of SmallInt;   // AmbX_2
    SampleRound: array[0..3] of SmallInt;    // AmbX_3
    SampleUnknown1: array[0..3] of SmallInt; // AmbX_4
    SampleUnknown2: array[0..3] of SmallInt; // AmbX_5
    MinDelay: SmallInt;            // Minimun Delay
    MinDelayRnd: SmallInt;         // Minimun Delay Random Range
    MusicIndex: Byte;

    Unknown: DWORD; //LBA2 only - bytes between Actors and Zones

    Actors: array of TSceneActor;
    Zones: array of TSceneZone;
    Points: array of TScenePoint;
    UData: String; //unknown LBA2 data after points

    TrackTrans_: array of TTransTable;
    TrackHashes_: array of TWordDynAr; //Tables of the LABELs addresses/IDs
    TrackHashes2_: array of TLbHashTable;
    LifeTrans_: array of TTransTable; //transitional table
    CompLists_: array of TStrDynAr; //Tables of tables of COMPORTMENTs names
    CompLists2_: array of TCompList;
  end;

  TMessageType = (mtError, mtWarning, mtInfo, mtUnknown);
  TMsgObjType = (moActorLife, moActorTrack, moActorProp, moPoint, moZone);

  TCompMessage = record
    mType: TMessageType;
    oType: TMsgObjType;
    ObjId: Integer; //Actor Id for example
    Line: Integer; //Line or an additional index, e.g. Actor property tab
    PosStart, PosEnd: Integer;
    //Add: ShortString;
    Text: String;
  end;

  TCompMessages = array of TCompMessage;

  TCompCallbackProc = procedure(Msg: TCompMessage);

  TMacroModItem = record
    id: Integer;
    name: String;
  end;
  TMacroModAr = array of TMacroModItem;

  TSwLevelFrame = record
    PseudoLevel: Boolean; //if true, this is a nested CASE level, not starting with a SWITCH
    IFFrame: Integer;
    lh: Integer;
    BREAKs: array of Word;
    LastCASE: Integer;  //index of the last CASE to adjust its target address
    FirstCASE: Integer; //index of the first CASE needed for ambiguous syntax detection
    LastBREAK: Integer; //indicator for nested CASE detection and modified BREAKs
  end;

const

// ######## CONST ########

CR  = #$0D#$0A;
TAB = #$09;

//LIFE OPERATOR CONSTANTS
loEQUAL      = 0;
loGREATER    = 1;
loLESS       = 2;
loGREATER_EQ = 3;
loLESS_EQ    = 4;
loNOT_EQUAL  = 5;
loMAX_OPCODE = 5;

Operator_Set : set of 0..255 = [loEQUAL..loNOT_EQUAL];
// Set_Track_Obj and Current_Track_Obj doesn't count since they aren't for the actual actor


// ######## ARRAYS ########

ReservedWords: array[0..18] of String = //These words cannot be used as label/comportment names
  ('label', 'stop', 'goto', 'end', 'comportment', 'end_comportment',
   'set_comportment', 'set_comportment_obj', 'if', 'oneif', 'swif',
   'or_if', 'else', 'endif', 'neverif', 'snif', 'offset', 'self', 'break');

OperDecompList: array[0..5] of String =
(
  '==',
  '>',
  '<',
  '>=',
  '<=',
  '!='
);

OperCompList: array[0..5] of TMacroModItem =
(
  (id: 0; name: '=='),
  (id: 1; name: '>'),
  (id: 2; name: '<'),
  (id: 3; name: '>='),
  (id: 4; name: '<='),
  (id: 5; name: '!=')
);  

//Error and warning constants
ceNone           = 0;  //No error
ceUnkCom         = 1;  //unknown command
ceExpCom         = 2;  //expected a command
ceExpFirstInt    = 3;  //expected an integer parameter
ceExpSecInt      = 4;  //expected second integer parameter
ceExpFlaName     = 5;  //expected a FLA name parameter
ceOutOfRange     = 6;  //parameter out of range
ceInvalidNum     = 7;  //invalid number
ceUnkText        = 8;  //unknown text string
ceInvalidChar    = 9;  //invalid character
ceTrackNoLabel   = 10; //no LABEL with specified index
ceInt11BadType   = 11; //cType af the command is not one of the allowed
ceUnkVar         = 12; //unknown variable
ceExpVar         = 13; //expected a variable
ceUnkOper        = 14; //unknown operator
ceExpOper        = 15; //expected an operator
ceExpBehav       = 16; //expected a behaviour
ceUnkBehav       = 17; //unknown behaviour
ceExpDirM        = 18; //expected a DirMode
ceUnkDirM        = 19; //unknown DirMode
ceInt20BadDir    = 20; //leDirMode param was called for non-dirmode command
ceDoubleLabel    = 21; //two LABELs have the same IDs in the Track Script
ceLifeNoTsLb     = 22; //no track LABEL with given ID
ceIfNoEndif      = 23; //IF without an ENDIF
ceExpEND         = 24; //END command expected
ceUnExEol        = 25; //unexpected end of line
ceInt26NoEND     = 26; //no END at the end of Script
ceLifeNoComp     = 27; //no COMPORTMENT with given name
ceInvCompName    = 28; //invalid COMPORTMENT name
ceExpEndComp     = 29; //END_COMPORTMENT expected
ceExpEndOrComp   = 30; //END or COMPORTMENT expected
ceExpORIF        = 31; //OR_IF or IF expected
ceElseNoIf       = 32; //ELSE without a corresponding IF
ceEndifNoIf      = 33; //ENDIF without a corresponding IF or ELSE
ceUnIfBlock      = 34; //there are unfinished IF blocks left
ceDoubleComp     = 35; //two COMPs have the same names in the LifeScript
ceDoubleELSE     = 36; //Double ELSE statement
ceExpNewLine     = 37; //new line expected
ceInfComment     = 38; //infinite comment block
ceInt39OpFirst   = 39; //Operator is not preceded by a Condition
ceInt40WrongOff  = 40; //Wrong offset in TransTable command
ceNoSceneZone    = 41;
ceNoActorAnim    = 42;
ceNoActorBody    = 43;
ceNoSceneID      = 44; //TODO: make it working (may be impossible, or very hard)
//ceLifeNoTrack    = 45;
ceLifeNoActor    = 46;
ceNoSceneTrack   = 47;
ceDoubleLabelName= 48; //The same Label Name declared, twice for the same actor
ceLabelNameNotDeclared= 49; //The Label Name reffered in GOTO doesn't exist
ceIllegalLabelName= 50; //The Label Name reffered in GOTO doesn't exist
ceInvalidNumOrNoLABEL=51; //If an unknown LABEL name is referenced in Life Script,
ceUndefinedLabel = 52;
ceReservedWord   = 53; //The word used as Label or Comportment name is reserved
ceSelfNotAllowed = 54; //SELF not allowed here
ceMGNotAllowed   = 55; //Main_Grid is not allowed
ceInvalidFrag    = 56; //Invalid Fragment name
ceBreakNoSwitch  = 57; //BREAK without prior SWITCH
ceCaseNoSwitch   = 58; //CASE without prior SWITCH
ceDefltNoSwitch  = 59; //DEFAULT without prior SWITCH
ceExpBreakMod    = 60;
ceElseNoEndif    = 61;
ceExpESwBrkMod   = 62; //END_SWITCH is required when using mod BREAKs
MaxErrorId       = 62;

CmdTypeString: array[TCommandType] of String =
( 'ctCommand',  //0
  'ctIf',       //1
  'ctVariable', //2
  '',           //3
  'ctOperator', //4
  'ctVirtual',  //5
  'ctSwVar',    //6
  'ctError'     //7
);

DecompErrorString: array[0..11] of String =
(
  'No error',                                //0
  'Target LABEL does not exist',             //1 Track Script GOTO
  'Target LABEL does not exist',             //2 Life Script SET_TRACK
  'Target Actor does not exist',             //3 Life Script SET_TRACK_OBJ
  'Target comportment does not exist',      //4 Life Script SET_COMPORTMENT(_OBJ)
  'Target Actor does not exist',             //5 Life Script SET_COMPORTMENT_OBJ
  'Target address is not command beginning', //6 Life Script SET_COMPORTMENT(_OBJ)
  'Code bytes after END',                    //7
  'Unknown opcode',                          //8
  'CASE or OR_CASE expected',                //9 Life Script SWITCH
  'No END at the end of script',             //10
  'CASE outside of SWICH-END_SWITCH block'   //11
);

CompErrorString: array[0..MaxErrorId] of String =
(
 'No error',                            //0
 'Unknown command',                     //1
 'Command expected',                    //2
 'Integer parameter expected',          //3
 'Second integer parameter expected',   //4
 'Invalid movie name',                  //5
 'Parameter out of range',              //6
 'Invalid number',                      //7
 'Unknown text string',                 //8
 'Invalid character %s',                //9
 'There is no LABEL with given index',  //10
 'Internal error 11, please report it to the author', //11
 'Unknown variable',                    //12
 'Variable expected',                   //13
 'Unknown operator',                    //14
 'Operator expected',                   //15
 'Behaviour expected',                  //16
 'Unknown behaviour',                   //17
 'DirMode expected',                    //18
 'Unknown DirMode',                     //19
 'Internal error 20, please report it to the author', //20
 'This LABEL ID has already been used', //21
 'No LABEL with given index in the Track Script',     //22
 'IF without a corresponding ENDIF or ELSE',          //23
 'END keyword expected',                //24
 'Unexpected end of line',              //25
 'Internal error 26, please report it to the author', //26
 'There is no COMPORTMENT with given name',          //27
 'Invalid COMPORTMENT name',           //28
 'END_COMPORTMENT expected',           //29
 'COMPORTMENT or END expected',        //30
 'IF-type command expected',           //31
 'ELSE without a corresponding IF',     //32
 'ENDIF without a corresponding IF or ELSE',          //33
 'There are open IF blocks left in this Comportment',//34
 'This COMPORTMENT name has already been used',      //35
 'Double ELSE statement',               //36
 'New line expected',                   //37
 'Infinite comment block',              //38
 'Internal error 39, please report it to LBArchitect''s author', //39
 'Internal error 40, please report it to LBArchitect''s author', //40
 'There is no Sceneric Zone with specified virtual ID', //41
 'The Actor''s entity does not contain Animation with specified virtual ID', //42
 'The Actor''s entity does not contain Body with specified virtual ID', //43
 'There is no Scene with specified index', //44
 '', //45
 'There is no Actor with specified index', //46
 'There is no Track with specified index', //47
 'This LABEL name has already been used', //48
 'This LABEL name isn''t defined for the actor', //49
 'Illegal LABEL name (does it begin with a number?)', //50
 'Expected an integer or LABEL name parameter', //51
 'The LABEL name does not exist in the referenced Actor''s Track Script', //52
 'This word is reserved, and cannot be used as a name', //53
 'SELF is not allowed here', //54
 'Main_Grid is not allowed here', //55
 'Fragment with this name does not exist', //56
 'BREAK outside of SWITCH structure', //57
 'CASE outside of SWITCH structure', //58
 'DEFAULT outside of SWITCH structure', //59
 'Expected ''mod'' keyword (optional) or end of line', //60
 'ELSE without a corresponding ENDIF', //61
 'An unmodified BREAK before the end of SWITCH is required for modified BREAKs' //62
);

MinWarningId        = 1000;
MaxWarningId        = 1064;
cwCodeAfterEnd      = 1000;
cwNoLabelStart      = 1001;
cwNoLabelStop       = 1002;
cwLabelUnused       = 1003;
cwCompUnused        = 1004;
cwNoLabRepStart     = 1005;
cwNoLabRepStop      = 1006;
cwNoSceneZone       = 1041;
cwLifeNoTsLb        = 1045;
cwLifeNoActor       = 1046;
cwActorNoEntity     = 1061;
cwActorSprite       = 1062;
cwActorNotSprite    = 1063;
cwActorNotZonable   = 1064;

CompWarningString: array[MinWarningId..MaxWarningId] of String =
(
 'There should not be any code after END. The script may not work properly', //1000
 'Script should start with LABEL command', //1001
 'There should be a LABEL or END after STOP', //1002
 'LABEL''s ID is probably never referenced (however it may be referenced indirectly)', //1003
 'COMPORTMENT''s name is never referenced', //1004
 'Script should start with a LABEL or REPLACE (REMP) command', //1005
 'There should be a LABEL, END or REPLACE (REMP) after STOP', //1006
 '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', //1007 - 1022
 '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', //1023 - 1040
 'There is no Sceneric Zone with specified virtual ID', //1041
 'The Actor''s entity does not contain Animation with specified virtual ID', //1042
 'The Actor''s entity does not contain Body with specified virtual ID', //1043
 'There is no Scene with specified index', //1044
 'No LABEL with given index in the Track Script', //1045
 'There is no Actor with specified index', //1046
 'There is no Track with specified index', //1047
 '', '', '', '', '', '', '', '', '', '', '', '', '', //1048 - 1060

 'Actor''s entity setting is invalid (there is no entity with such index)', //1061
 'This command is specific to 3D Actors while the Actor is Sprite', //1062
 'This command is specific to Sprite Actors while this Actor is 3D', //1063
 'This Actor cannot detect Zones (static flag is not set)' //1064
);

MinInfoId          = 3000;
MaxInfoId          = 3004;
ciTrackCompiled    = 3000;
ciLifeCompiled     = 3001;
ciLifeParsed       = 3002;
ciLifeResolved     = 3003;
ciLifeCompSing     = 3004;

CompInfoString: array[MinInfoId..MaxInfoId] of String =
(
 'Track Scripts compiled successfully',    //3000
 'Life Scripts compiled successfully',     //3001
 'Life Scripts parsed', //3002
 'Life Scripts'' offsets resolved',        //3003
 'Life Script compiled successfully'     //3004
);

implementation

end.
