unit SceneUndo;

interface

uses SceneLib, SceneLibConst, Controls, Settings, Scene, ScriptEd;

const //Undo group IDs
  //Be careful when changing these values, the order and continuity are important!
  //See SceneObj.pas -> seTXChange(), seAXChange(), seZXChange(), cbAModeChange()
  //  and seZ0TargetIdChange()
  UNDO_GROUP_NONE       = 0;

  UNDO_GROUP_POINT_X    = 1;
  UNDO_GROUP_POINT_Y    = 2;
  UNDO_GROUP_POINT_Z    = 3;

  UNDO_GROUP_ACTOR_X    = 101;
  UNDO_GROUP_ACTOR_Y    = 102;
  UNDO_GROUP_ACTOR_Z    = 103;
  UNDO_GROUP_ACTOR_CL   = 104; //Clip Left
  UNDO_GROUP_ACTOR_CT   = 105; //Clip Top
  UNDO_GROUP_ACTOR_CR   = 106; //Clip Right
  UNDO_GROUP_ACTOR_CB   = 107; //Clip Bottom
  UNDO_GROUP_ACTOR_HP   = 108; //Hit Power
  UNDO_GROUP_ACTOR_ARM  = 109; //Armour
  UNDO_GROUP_ACTOR_LP   = 110; //Life Points
  UNDO_GROUP_ACTOR_ANG  = 111; //Angle
  UNDO_GROUP_ACTOR_ROT  = 112; //Rotation delay
  UNDO_GROUP_ACTOR_BA   = 113; //Bonus Amount
  UNDO_GROUP_ACTOR_TC   = 114; //Talk Colour
  UNDO_GROUP_ACTOR_ENT  = 115; //Entity
  UNDO_GROUP_ACTOR_BD   = 116; //Body
  UNDO_GROUP_ACTOR_ANM  = 117; //Anim
  UNDO_GROUP_ACTOR_SPR  = 118; //Sprite
  UNDO_GROUP_ACTOR_BF   = 119; //Bonus Flags

  UNDO_GROUP_ZONE_X     = 201;
  UNDO_GROUP_ZONE_Y     = 202;
  UNDO_GROUP_ZONE_Z     = 203;
  UNDO_GROUP_ZONE_SX    = 204;
  UNDO_GROUP_ZONE_SY    = 205;
  UNDO_GROUP_ZONE_SZ    = 206;
  UNDO_GROUP_ZONE_0TID  = 207;
  UNDO_GROUP_ZONE_0X    = 208;
  UNDO_GROUP_ZONE_0Y    = 209;
  UNDO_GROUP_ZONE_0Z    = 210;
  UNDO_GROUP_ZONE_1X    = 211;
  UNDO_GROUP_ZONE_1Y    = 212;
  UNDO_GROUP_ZONE_1Z    = 213;
  UNDO_GROUP_ZONE_2ZID  = 214;
  UNDO_GROUP_ZONE_3GID  = 215;
  UNDO_GROUP_ZONE_4BON  = 216;
  UNDO_GROUP_ZONE_5TID  = 217;

procedure SceneSetUndoButtons();
procedure SceneResetUndo(); //Clears the buffers
procedure SceneUndoSetPoint(var VScene: TScene; Group: Integer = UNDO_GROUP_NONE;
  ObjType: TObjType = otNone; ObjId: Integer = 0);
procedure SceneDoUndo(var VScene: TScene);
procedure SceneDoRedo(var VScene: TScene);

implementation

uses Main;

const
  MaxUndo = 100; //Number of available undo buffers

var
  UndoArray: array[1..MaxUndo+1] of TScene;
  LastUndo: Integer = 0;
  HighUndo: Integer = 0;
  LastGroup: Integer = 0;
  LastObjType: TObjType = otNone;
  LastObjId: Integer = -1;

//Copies the Scene for undo/redo usage
procedure CopyScene(Src: TScene; var Dest: TScene);
begin
  Dest.Actors:= Copy(Src.Actors);
  Dest.Zones:= Copy(Src.Zones);
  Dest.Points:= Copy(Src.Points);
end;

procedure SceneSetUndoButtons();
begin
  fmMain.aUndo.Enabled:= LastUndo > 0;
  fmMain.aRedo.Enabled:= LastUndo < HighUndo;
end;

procedure SceneResetUndo(); //Clears the buffers
begin
  LastUndo:= 0;
  HighUndo:= 0;
  LastGroup:= 0;
  SceneSetUndoButtons();
end;

//Creates undo point for Scene Objects
//If Group is equal to the last group (and <> 0(NONE)) and ObjType = LastObjType
//  and ObjId = LastObjId
//  and ObjGroupUndo setting is True then desn't add a new point at all
procedure SceneUndoSetPoint(var VScene: TScene; Group: Integer = UNDO_GROUP_NONE;
  ObjType: TObjType = otNone; ObjId: Integer = 0);
var a: Integer;
begin
  If not (Sett.Scene.ObjGroupUndo
  and (Group > UNDO_GROUP_NONE) and (Group = LastGroup)
  and (ObjType <> otNone) and (ObjType = LastObjType)
  and (ObjId > -1) and (ObjId = LastObjId)) then begin
    If LastUndo < MaxUndo then
      Inc(LastUndo)
    else begin
      for a:= 1 to MaxUndo - 1 do
        CopyScene(UndoArray[a+1], UndoArray[a]);
    end;
    CopyScene(VScene, UndoArray[LastUndo]); //Store the Scene in buffer
    HighUndo:= LastUndo;
    SceneSetUndoButtons();
  end;
  LastGroup:= Group;
  LastObjType:= ObjType;
  LastObjId:= ObjId;
end;

procedure SceneDoUndo(var VScene: TScene);
begin
  if LastUndo > 0 then begin //If we have something in the buffer
    if LastUndo >= HighUndo then
      CopyScene(VScene, UndoArray[LastUndo+1]); //Store current Scene for redo
    CopyScene(UndoArray[LastUndo], VScene); //Restore the last Scene from buffer
    Dec(LastUndo);
  end;
  SceneSetUndoButtons();
  LastGroup:= UNDO_GROUP_NONE;
  LastObjType:= otNone;
  LastObjId:= -1;

  fmScriptEd.DeleteUnusedActorUndoRedo();

  {If not aRedo.Enabled then begin   tutaj
    RedoMap:= CopyMap(Map);
    FirstRedo:= LastUndo;
  end;
  Map:= CopyMap(UndoArray[LastUndo]);
  If LastUndo > 0 then
    Dec(LastUndo);   }
  //If LastUndo < 1 then aUndo.Enabled:=False;
  //aRedo.Enabled:=True;
end;

procedure SceneDoRedo(var VScene: TScene);
begin
  If LastUndo < HighUndo then begin //If there is anything in redo buffer
    Inc(LastUndo);
    CopyScene(UndoArray[LastUndo + 1], VScene); //Restore the Scene from buffer
  end;
  SceneSetUndoButtons();
  LastGroup:= UNDO_GROUP_NONE;
  LastObjType:= otNone;
  LastObjId:= -1;

  fmScriptEd.DeleteUnusedActorUndoRedo();

  {Inc(LastUndo);
  If LastUndo < FirstRedo then
    CopyScene(UndoArray[LastUndo+1], VScene)
  else begin
    CopyScene(RedoBuff, VScene);
    //aRedo.Enabled:= False;
  end;}
  //aUndo.Enabled:=True;
end;

end.
 