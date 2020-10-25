unit Globals;

//This unit contains all global variables (will contain, actually).
//It should not contain any type definitions, variables only!
//It should not be referenced from interface section (because it may end up
//  in circular reference problem).

interface

uses SysUtils, Forms, DePack, Grids, Scenario, Maps, Libraries, Utils, HQDesc, AddFiles;

const
  Special = False; //Special release
  SpecialVer = '1.0 beta 9 Script Debug';

var
  ThisIsBeta: Boolean = False;
  AppPath: String;

  GridTool: (gtHand, gtSelect, gtPlace, gtInvisi);
  SceneTool: (stHand, stSelect, stAim, stAddActor, stAddTrack, stAddZone);

  HiVisLayer: Integer = 0; //current value, it should be = HighY on Grid load

  UpdatingControls: Boolean = False; //Don't refresh main image when updating control values

  BadBrickMessage: Boolean = False; //Whether the warning about corrupted brick has been shown already
  BadActorMessage: Boolean = False;
  BadLibraryMessage: Boolean = False; //When Brick Id is outside the Library/Layout range

  //Used for giving consecutive automatic names to the newly created Fragments
  MapCounter: Integer = 0;

  LBAMode: Byte = 0; //Current mode: 1 or 2. If 0 then nothing is opened.

  ProgMode: (pmGrid, pmScene, pmFragTest); //Old Scene Mode / Grid Mode

  //Bricks:
  TransparentBrick: Integer = 0;
  PkBricks: TPackEntries;

  //Library:
  LdLibrary: TLibrary;

  //Grids and Fragments:
  GHiX: Integer = 63; //current Grid dimensions
  GHiY: Integer = 24; //Warning: these are used in subrange conditionals, so they
  GHiZ: Integer = 63; //  cannot exceed 255
  GImgW: Integer = 3100; //dimensions of the fully rendered Grid in pixels
  GImgH: Integer = 1950;
  GOffX: Integer = 1530;  //offset of the [0, 0, 0] Brick from the top left
  GOffY: Integer = 380;   //  corner of the Grid image in pixels
  GScrX: Integer = 0; //pixels
  GScrY: Integer = 0;
  MainMapIsGrid: Boolean; //True = Grid is loaded, False = LBA 2 Fragment is loaded
  CMap: PComplexMap = nil; //Points to the current map in LMaps array
  LdMaps: array of TComplexMap; //Currently loaded maps and Fragments (0 is always the main map)
  GLibIndex: Byte; //Lib index for the current Grid (LBA 2 only)
  GFragIndex: Byte; //Fragment index for the current Grid (LBA 2 only)

  //Scene:
  SOrgComp: Word; //original compression of the current Scene file

  SampleNames: TStrArray; //List of Samples.hqr descriptions
  SampleIndexes: TIndexList;
  SpriteNames: TStrArray; //List of Sprites.hqr descriptions
  SpriteIndexes: TIndexList;
  InvObjNames: TStrArray; //List of Invobj.hqr descriptions
  InvObjIndexes: TIndexList;
  MovieNames: TStrArray; //List of movie names from ress.hqr
  DialogTexts: array of array of TDialogText; //All texts by islands

  //Scenarios:
  PkScenario: TPackEntries; //currently opened Scenario (if any)
  HQSInfo: THQSInfo; //info for currently opened Scenario
  ScenarioDesc: String = '';
  CurrentScenarioFile: String = '';
  ScenarioModified: Boolean;
  ScenarioState: Boolean = False;

implementation

initialization
  AppPath:= ExtractFilePath(Application.ExeName); //with the ending "\"

end.
 