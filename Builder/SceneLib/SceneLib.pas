//***************************************************************************
// Little Big Architect: SceneLib unit - provides scene opening, script
//                                       de/compilation and saving routines

// Copyright (C) 2007 alexfont
// Copyright (C) 2007/2008 Zink

// e-mail: alexandrefontoura@gmail.com
// e-mail: zink@poczta.onet.pl

// This source code is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

// This source code is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License (License.txt) for more details.
//***************************************************************************

unit SceneLib;

interface

uses Windows, Classes, SysUtils, Dialogs, Math, SceneLibConst,
     SceneLibComp, SceneLibDecomp, SceneLib1Tab, SceneLib2Tab,
     DePack, Graphics, Engine,
     ActorInfo, Forms, Controls, CompDialog, Hints, Settings, Utils;

var
  //Debug: Boolean = True;
  //TrackHashes_: array of TWordDynAr; //Tables of the LABELs addresses/IDs
  //TrackHashes2_: array of TLbHashTable;
  //LifeTrans_: array of TTransTable; //transitional table
  //CompLists_: array of TStrDynAr; //Tables of tables of COMPORTMENTs names
  //CompLists2_: array of TCompList;

  //Script compilation/decompilation settings:
  ScrSet: record
    Comp: record
      RequireENDs: Boolean;
      StrictSyntax: Boolean;
      LabelWarnings: Boolean;
      LbUnusedWarns: Boolean;
      CompUnusedWarns: Boolean;
      AutoHLError: Boolean; //Highlight Script error after compilation
      AutoHLAlways: Boolean; //False = only when the error is in the current Script
      CheckTracks: Boolean; //Checks if Point ID references are correct (GOTO_POINT(_3D) commands)
      TrackErrors: Boolean;
      CheckBdAn: Boolean; //Checks if Body and Anim virtual ID references are correct (BODY(_OBJ) commands and conditions)
      BdAnErrors: Boolean;
      CheckActors: Boolean; //Checks if Actor ID references are correct (*_OBJ commands and conditions)
      ActorErrors: Boolean;
      CheckZones: Boolean; //Checks if Zone virtual ID references are correct (ZONE(_OBJ) conditions)
      CheckSuit: Boolean; //Checks if suitable commands/conditions are used (Sprite commands for Sprite Actors only)
    end;
    Decomp: record
      UpperCase: Boolean;
      IndentLife: Boolean;
      IndentTrack: Boolean;
      FirstCompMain: Boolean;
      AddEND_SWITCH: Boolean;
      Lba1MacroOrg: Boolean;
      Lba2MacroOrg: Boolean;
      CompoOrg: Boolean;
    end;
  end =
   (Comp: (RequireENDs: True; StrictSyntax: False; LabelWarnings: True;
           LbUnusedWarns: True; CompUnusedWarns: True;
           AutoHLError: True; AutoHLAlways: False;
           CheckTracks: True; TrackErrors: False; CheckBdAn: True; BdAnErrors: False;
           CheckActors: True; ActorErrors: False; CheckZones: True; CheckSuit: True; );
    Decomp: (UpperCase: True; IndentLife: True; IndentTrack: True; FirstCompMain: True;
             AddEND_SWITCH: False;
             Lba1MacroOrg: False; Lba2MacroOrg: False; CompoOrg: False; )
   );

// Functions declarations ------------------
// -----------------------------------------

// General routines ------------------------

procedure ComputeTrackDispInfo(var st: TScenePoint; id: Integer);
procedure ComputeActorDispInfo(var sa: TSceneActor; id: Integer);
procedure ComputeZoneDispInfo(var sz: TSceneZone; id: Integer);
procedure ComputeTrackDrawInfo(var st: TScenePoint; id: Integer);
procedure ComputeActorDrawInfo(var sa: TSceneActor; id: Integer);
procedure ComputeZoneDrawInfo(var sz: TSceneZone);
procedure ComputeAllDispInfo(var VScene: TScene);

Function LoadSceneFromFile(path: String; Lba: Byte; CleanUp: Boolean = True): TScene;
Function LoadSceneFromStream(data: TStream; Lba: Byte; CleanUp: Boolean = True): TScene;      // LoadBinaryScene
function LoadSceneFromString(data: String; Lba: Byte; CleanUp: Boolean = True): TScene;
Function LoadTextSceneStream(data: TStream; Lba: Byte; out sc: TScene): Boolean;
Function LoadCoderProjectStream(data: TStream; Lba: Byte; out sc: TScene): Boolean;
Function SceneProjectGetStr(Data: TStringList; Section, Name: String;
  out Value: String): Boolean;
Function SceneProjectGetInt(Data: TStringList; Section, Name: String;
  out Value: Integer): Boolean;
Function SceneProjectGetSection(Data: TStringList; Section: String;
  out Content: String): Boolean;
function LoadSceneProjectStream(data: TStream; var Lba: Byte; out sc: TScene): Boolean;
function LoadSceneProjectString(data: String; var Lba: Byte; out sc: TScene): Boolean;
//Procedure SaveSceneFile(path: String; Lba: Byte; Scene: TScene);
function SceneToString(var Scene: TScene; Lba: Byte): String;
//Saves Scene Text Project
//Scenario = True makes additional info to be saved
function SceneProjectToString(sc: TScene; Lba: Byte;
  Scenario: Boolean = False): String;
Function CreateEmptyScene(): TScene;
procedure SaveScene(path: String; Index: Integer = -1);
Function IsSceneLba2(path: String): Boolean;

// Misc ----------------------------------

Function MsgType(id: Integer): TMessageType;
Procedure AddMessage(var Msgs: TCompMessages; TrackScript: Boolean;
  Id, Actor, Line, PStart, Len: Integer; Add: ShortString = ''); overload;
Procedure AddMessage(Proc: TCompCallbackProc; TrackScript: Boolean;
  Id, Actor, Line, PStart, Len: Integer; Add: ShortString = ''); overload;
Procedure AddMessage(Proc: TCompCallbackProc; TrackScript: Boolean;
  mType: TMessageType; Actor, Line, PStart, Len: Integer; Text: String); overload;
function MessageToString(TrackScript: Boolean;
  Id, Actor, Line: Integer; Add: ShortString = ''): String;

//This function checks various parts of the Scene (Actor Body IDs, Animation IDs,
//  Zone Fragment names, etc.) for containing valid values.
//TODO: Add other things to check.
function SceneCheckConsistency(Scene: TScene; Callback: TCompCallbackProc): Boolean;

function FixCase(Text: String): String; //sets the case according to setting
function CheckBadOpcode(cmd: TTransCommand; var Res: String): Boolean;

implementation

uses Scene, Open, Main, StrUtils, ScriptEd, Scenario, Globals;

  // #########################################################
  // ################# General routines ######################
  // #########################################################

procedure ComputeTrackDispInfo(var st: TScenePoint; id: Integer);
begin
 SceneToXY(st.X, st.Y, st.Z, 0, 0, st.DispInfo.rX, st.DispInfo.rY);
 SceneToGrid(st.X, st.Y, st.Z, st.DispInfo.gX, st.DispInfo.gY, st.DispInfo.gZ);
 ComputeTrackDrawInfo(st, id);
end;

//TODO: Check if the Sprite images don't need to be freed at the program end
procedure ComputeActorDispInfo(var sa: TSceneActor; id: Integer);
begin
 SceneToXY(sa.x, sa.y, sa.z, 0, 0, sa.DispInfo.rX, sa.DispInfo.rY);
 SceneToGrid(sa.x, sa.y, sa.z, sa.DispInfo.gX, sa.DispInfo.gY, sa.DispInfo.gZ);
 sa.DispInfo.Width:= 35;
 sa.DispInfo.Height:= 86;
 sa.DispInfo.UsesSprite:= False;
 If {SceneUsesSprites and} ((sa.StaticFlags and sfSprite) <> 0) then begin
  If sa.Sprite < Length(VSprites) then begin
   sa.DispInfo.UsesSprite:= True;
   sa.DispInfo.Width:= Byte(VSprites[sa.Sprite].Data[9]);
   sa.DispInfo.Height:= Byte(VSprites[sa.Sprite].Data[10]);
   Inc(sa.DispInfo.rX, SprActInfo[sa.Sprite].OffsetX - 2);
   Inc(sa.DispInfo.rY, SprActInfo[sa.Sprite].OffsetY);
   If not Assigned(sa.DispInfo.Sprite) then begin
     sa.DispInfo.Sprite:= TBitmap.Create;
     sa.DispInfo.Sprite.PixelFormat:= pf24bit;
     sa.DispInfo.Sprite.Transparent:= True;
     sa.DispInfo.Sprite.TransparentMode:= tmFixed;
     sa.DispInfo.Sprite.TransparentColor:= 0;
   end;
   sa.DispInfo.Sprite.Width:= sa.DispInfo.Width;
   sa.DispInfo.Sprite.Height:= sa.DispInfo.Height;
   sa.DispInfo.Sprite.Canvas.Brush.Color:= 0;
   sa.DispInfo.Sprite.Canvas.FillRect(Rect(0,0,sa.DispInfo.Width,sa.DispInfo.Height));
   if not PaintBrickFromString(VSprites[sa.Sprite].Data, Point(0,0), Palette,
     sa.DispInfo.Sprite.Canvas, False, False, clWhite, True)
   and not BadActorMessage then begin
     Application.MessageBox('The data of at least one Actor is corrupted!'#13'The unreadable part has been replaced with red colour.',
       ProgramName, MB_ICONERROR + MB_OK);
     BadActorMessage:= True;
   end;    

  end
  else
   MessageDlg(Format('Sprite index out of range!'#13#13'Sprite index: %d'#13'Actor ID: ',[sa.Sprite]),Dialogs.mtWarning,[mbOK],0);
 end
 else begin
  Dec(sa.DispInfo.rX,17);
  Dec(sa.DispInfo.rY,86);
 end;
 ComputeActorDrawInfo(sa, id);
end;

procedure ComputeZoneDispInfo(var sz: TSceneZone; id: Integer);
begin
 SceneToXY(sz.x1, sz.y1, sz.z1, 0, 0, sz.DispInfo.rX1, sz.DispInfo.rY1);
 SceneToXY(sz.x2, sz.y2, sz.z2, 0, 0, sz.DispInfo.rX2, sz.DispInfo.rY2);
 sz.DispInfo.h:= ((sz.Y2 - sz.Y1) * 15) div 256;
 SceneToGrid(sz.x1, sz.y1, sz.z1, sz.DispInfo.gX1, sz.DispInfo.gY1, sz.DispInfo.gZ1);
 SceneToGrid(sz.x2, sz.y2, sz.z2, sz.DispInfo.gX2, sz.DispInfo.gY2, sz.DispInfo.gZ2);
 sz.DispInfo.sX1:= sz.DispInfo.rY2 + sz.DispInfo.h - sz.DispInfo.rY1
               + ((sz.DispInfo.rX2 + sz.DispInfo.rX1) div 2);
 sz.DispInfo.sY1:= (sz.DispInfo.rY1 + sz.DispInfo.rY2 + sz.DispInfo.h
                - ((sz.DispInfo.rX1 - sz.DispInfo.rX2) div 2)) div 2;
 sz.DispInfo.sX2:= sz.DispInfo.rY1 - sz.DispInfo.h
               + ((sz.DispInfo.rX2 + sz.DispInfo.rX1) div 2) - sz.DispInfo.rY2;
 sz.DispInfo.sY2:= (sz.DispInfo.rY1 + sz.DispInfo.rY2 + sz.DispInfo.h
                + ((sz.DispInfo.rX1 - sz.DispInfo.rX2) div 2)) div 2;
 if sz.RealType = ztSceneric then
   sz.DispInfo.Caption:= Format('%d(%d)', [id, sz.VirtualID])
 else
   sz.DispInfo.Caption:= IntToStr(id);
 ComputeZoneDrawInfo(sz);
end;

procedure ComputeTrackDrawInfo(var st: TScenePoint; id: Integer);
var tw: Integer;
begin
 tw:= bufMain.Canvas.TextWidth(IntToStr(id));
 st.DispInfo.CaptionX:= - tw div 2;
 st.DispInfo.CaptionY:= - 64;
 st.DispInfo.DrawOriginX:= - Max(24, tw div 2);
 st.DispInfo.DrawOriginY:= - 64;
 st.DispInfo.DrawWidth:= Max(tw, Ceil(tw / 2) + 22);
 st.DispInfo.DrawHeight:= 35 + 37;
end;

procedure ComputeActorDrawInfo(var sa: TSceneActor; id: Integer);
var tw, ar: Integer;
begin
 tw:= bufMain.Canvas.TextWidth(IntToStr(id));
 If ((sa.StaticFlags and sfSprite) = 0) then ar:= 15 else ar:= 0;
 sa.DispInfo.CaptionX:= (sa.DispInfo.Width - tw) div 2;
 sa.DispInfo.CaptionY:= - 30;
 sa.DispInfo.DrawOriginX:= Min((sa.DispInfo.Width - tw) div 2, 0) - ar;
 sa.DispInfo.DrawOriginY:= - 30;
 sa.DispInfo.DrawWidth:= Max(sa.DispInfo.Width, tw) + ar*2;
 sa.DispInfo.DrawHeight:= sa.DispInfo.Height + 30 + ar*2;
 //TODO: take clipping into consideration here
end;

procedure ComputeZoneDrawInfo(var sz: TSceneZone);
begin
 sz.DispInfo.CaptionX:= 0;
 sz.DispInfo.CaptionY:= - sz.DispInfo.h;
 sz.DispInfo.DrawOriginX:= sz.DispInfo.sX2 - sz.DispInfo.rX1;
 sz.DispInfo.DrawOriginY:= - sz.DispInfo.h;
 sz.DispInfo.DrawWidth:=
   Max(bufMain.Canvas.TextWidth(sz.DispInfo.Caption) + sz.DispInfo.rX1 - sz.DispInfo.sX2,
       sz.DispInfo.sX1 - sz.DispInfo.sX2 + 1);
 sz.DispInfo.DrawHeight:=
   Max(bufMain.Canvas.TextHeight(sz.DispInfo.Caption),
       sz.DispInfo.rY2 - Sz.DispInfo.rY1 + sz.DispInfo.h * 2 + 2);
end;

procedure ComputeAllDispInfo(var VScene: TScene);
var a: Integer;
begin
 for a:= 0 to High(VScene.Points) do
   ComputeTrackDispInfo(VScene.Points[a], a);
 for a:= 0 to High(VScene.Actors) do
   ComputeActorDispInfo(VScene.Actors[a], a);
 for a:= 0 to High(VScene.Zones) do
   ComputeZoneDispInfo(VScene.Zones[a], a);
end;

procedure ComputeSpecificValues(var sc: TScene; Lba: Byte);
var a: Integer;
begin
  for a:= 0 to High(sc.Actors) do begin
    sc.Actors[a].IsSprite:= (sc.Actors[a].StaticFlags and sfSprite) <> 0;
    sc.Actors[a].FollowId:=
      IfThen(Lba = 1, sc.Actors[a].Info1, sc.Actors[a].Info3);
  end;

  for a:= 0 to High(sc.Zones) do begin
    if Lba = 1 then begin
      sc.Zones[a].RealType:= TZoneType(sc.Zones[a].ZType);
      sc.Zones[a].TargetCube:= Byte(sc.Zones[a].Info[0]);
      sc.Zones[a].TargetPoint:= Point3d(SmallInt(sc.Zones[a].Info[1]),
                                        SmallInt(sc.Zones[a].Info[2]),
                                        SmallInt(sc.Zones[a].Info[3]));
      sc.Zones[a].VirtualID:= Byte(sc.Zones[a].Info[0]);
      sc.Zones[a].BonusType:= Byte(sc.Zones[a].Info[1]);
      sc.Zones[a].BonusQuant:= Byte(sc.Zones[a].Info[2]);
      sc.Zones[a].BonusEna:= sc.Zones[a].Snap = 0;
      sc.Zones[a].TextID:= Word(sc.Zones[a].Info[0]);
    end else begin
      sc.Zones[a].RealType:= TZoneType(sc.Zones[a].ZType);
      sc.Zones[a].TargetCube:= Byte(sc.Zones[a].Snap);
      sc.Zones[a].TargetPoint:= Point3d(Integer(sc.Zones[a].Info[0]),
                                        Integer(sc.Zones[a].Info[1]),
                                        Integer(sc.Zones[a].Info[2]));
      sc.Zones[a].VirtualID:= Byte(sc.Zones[a].Snap);
      sc.Zones[a].BonusType:= Word(sc.Zones[a].Info[0]);
      sc.Zones[a].BonusQuant:= Byte(sc.Zones[a].Info[1]);
      sc.Zones[a].BonusEna:= sc.Zones[a].Info[7] <> 0;
      sc.Zones[a].TextID:= sc.Zones[a].Snap;
    end;
  end;
end;

procedure StoreSpecificValues(var sc: TScene; Lba: Byte);
var a: Integer;
begin
  for a:= 0 to High(sc.Actors) do begin
    if (Lba = 1) and (sc.Actors[a].CtrlMode in [ld1FOLLOW, ld1FOLLOW2]) then
      sc.Actors[a].Info1:= sc.Actors[a].FollowId
    else if (Lba = 2)
    and (sc.Actors[a].CtrlMode
         in [ld2FOLLOW, ld2FOLLOW2, ld2SAME_XZ, ld2DIRMODE9, ld2DIRMODE10, ld2DIRMODE11])
    then
      sc.Actors[a].Info3:= sc.Actors[a].FollowId;
  end;

  for a:= 0 to High(sc.Zones) do begin
    if Lba = 1 then begin
      sc.Zones[a].ZType:= Word(sc.Zones[a].RealType);
      case sc.Zones[a].RealType of
        ztCube: begin
          sc.Zones[a].Info[0]:= sc.Zones[a].TargetCube;
          sc.Zones[a].Info[1]:= Word(sc.Zones[a].TargetPoint.x);
          sc.Zones[a].Info[2]:= Word(sc.Zones[a].TargetPoint.y);
          sc.Zones[a].Info[3]:= Word(sc.Zones[a].TargetPoint.z);
        end;
        ztCamera: begin
          sc.Zones[a].Info[1]:= Word(sc.Zones[a].TargetPoint.x);
          sc.Zones[a].Info[2]:= Word(sc.Zones[a].TargetPoint.y);
          sc.Zones[a].Info[3]:= Word(sc.Zones[a].TargetPoint.z);
        end;
        ztSceneric: sc.Zones[a].Info[0]:= sc.Zones[a].VirtualID;
        ztBonus: begin
          sc.Zones[a].Info[1]:= sc.Zones[a].BonusType;
          sc.Zones[a].Info[2]:= sc.Zones[a].BonusQuant;
          sc.Zones[a].Snap:= IfThen(sc.Zones[a].BonusEna, 0, 1);
        end;
        ztText: sc.Zones[a].Info[0]:= sc.Zones[a].TextID;
      end;
    end else begin
      sc.Zones[a].ZType:= Word(sc.Zones[a].RealType);
      case sc.Zones[a].RealType of
        ztCube: begin
          sc.Zones[a].Snap:= sc.Zones[a].TargetCube;
          sc.Zones[a].Info[0]:= Word(sc.Zones[a].TargetPoint.x);
          sc.Zones[a].Info[1]:= Word(sc.Zones[a].TargetPoint.y);
          sc.Zones[a].Info[2]:= Word(sc.Zones[a].TargetPoint.z);
        end;
        ztCamera: begin
          sc.Zones[a].Info[0]:= DWord(sc.Zones[a].TargetPoint.x);
          sc.Zones[a].Info[1]:= DWord(sc.Zones[a].TargetPoint.y);
          sc.Zones[a].Info[2]:= DWord(sc.Zones[a].TargetPoint.z);
        end;
        ztSceneric: sc.Zones[a].Snap:= sc.Zones[a].VirtualID;
        ztBonus: begin
          sc.Zones[a].Info[0]:= sc.Zones[a].BonusType;
          sc.Zones[a].Info[1]:= sc.Zones[a].BonusQuant;
          sc.Zones[a].Info[7]:= IfThen(sc.Zones[a].BonusEna, 1, 0);
        end;
        ztText: sc.Zones[a].Snap:= sc.Zones[a].TextID;
      end;
    end;
  end;
end;

//Opens binary Scene
Function LoadSceneFromStream(data: TStream; Lba: Byte; CleanUp: Boolean = True): TScene;
var a: Integer;
    NumBytes, NumObjects, Dummy: Word;
    NumData: DWord;
    dSize: Byte;
begin
  data.Seek(0, soBeginning);

  // Start reading scene file                     //offsets for LBA 2
  data.Read(Result.TextBank, 1);                    //0
  data.Read(Result.GameOverScene, 1);               //1

  data.Read(Result.UnUsed1, 2);                     //2
  data.Read(Result.UnUsed2, 2);                     //4
  if Lba = 2 then data.Read(Result.UnUsed3, 1);     //6

  data.Read(Result.AlphaLight, 2);                  //7
  data.Read(Result.BetaLight, 2);                   //9

  for a:= 0 to 3 do begin
    data.Read(Result.SampleAmbience[a], 2);         //11  21  31  41
    data.Read(Result.SampleRepeat[a], 2);           //13  23  33  43
    data.Read(Result.SampleRound[a], 2);            //15  25  35  45
    if Lba = 2 then begin
      data.Read(Result.SampleUnknown1[a], 2);       //17  27  37  47
      data.Read(Result.SampleUnknown2[a], 2);       //19  29  39  49
    end;
  end;
  data.Read(Result.MinDelay, 2);                    //51
  data.Read(Result.MinDelayRnd, 2);                 //53

  data.Read(Result.MusicIndex, 1);                  //55

  SetLength(Result.Actors, 1);

  Result.Actors[0].Name:= 'The_Hero';
  data.Read(Result.Actors[0].X, 2);                 //56
  data.Read(Result.Actors[0].Y, 2);                 //58
  data.Read(Result.Actors[0].Z, 2);                 //60

  // Get Hero Track Script
  data.Read(NumBytes, 2);                           //62
  SetLength(Result.Actors[0].TrackScriptBin, NumBytes);
  if NumBytes > 0 then
    data.Read(Result.Actors[0].TrackScriptBin[1], NumBytes); //64

  // Get Hero Life Script
  data.Read(NumBytes, 2);
  SetLength(Result.Actors[0].LifeScriptBin, NumBytes);
  if NumBytes > 0 then
    data.Read(Result.Actors[0].LifeScriptBin[1], NumBytes);

  // Read Actors
  data.Read(NumObjects, 2);
  SetLength(Result.Actors, NumObjects);

  for a:= 1 to NumObjects - 1 do begin
    if Lba = 1 then begin
      data.Read(Result.Actors[a].StaticFlags, 2);
      data.Read(Result.Actors[a].Entity, 2);
      data.Read(Result.Actors[a].Body, 1);
      data.Read(Result.Actors[a].Anim, 1);
      data.Read(Result.Actors[a].Sprite, 2);
      data.Read(Result.Actors[a].X, 2);
      data.Read(Result.Actors[a].Y, 2);
      data.Read(Result.Actors[a].Z, 2);
      data.Read(Result.Actors[a].HitPower, 1);
      data.Read(Result.Actors[a].BonusType, 2);
      data.Read(Result.Actors[a].Angle, 2);
      data.Read(Result.Actors[a].RotSpeed, 2);
      data.Read(Result.Actors[a].CtrlMode, 1);
      data.Read(Result.Actors[a].CtrlUnk, 1);
      data.Read(Result.Actors[a].Info0, 2);
      data.Read(Result.Actors[a].Info1, 2);
      data.Read(Result.Actors[a].Info2, 2);
      data.Read(Result.Actors[a].Info3, 2);
      data.Read(Result.Actors[a].BonusAmount, 1);
      data.Read(Result.Actors[a].TalkColor, 1);
      data.Read(Result.Actors[a].Armour, 1);
      data.Read(Result.Actors[a].LifePoints, 1);
    end                                          //LBA1 props len: 35 bytes
    else begin  //LBA 2
      data.Read(Result.Actors[a].StaticFlags, 2);
      data.Read(Result.Actors[a].Unknown, 2); //maybe flags are 4 bytes long for LBA2?
      data.Read(Result.Actors[a].Entity, 2);
      data.Read(Result.Actors[a].Body, 1);
      data.Read(Result.Actors[a].BodyAdd, 1); //flag byte for LBA2
      data.Read(Result.Actors[a].Anim, 1);
      data.Read(Result.Actors[a].Sprite, 2);
      data.Read(Result.Actors[a].X, 2);
      data.Read(Result.Actors[a].Y, 2);
      data.Read(Result.Actors[a].Z, 2);
      data.Read(Result.Actors[a].HitPower, 1);
      data.Read(Result.Actors[a].BonusType, 2);
      data.Read(Result.Actors[a].Angle, 2);
      data.Read(Result.Actors[a].RotSpeed, 2);
      data.Read(Result.Actors[a].CtrlMode, 1);
      data.Read(Result.Actors[a].Info0, 2);
      data.Read(Result.Actors[a].Info1, 2);
      data.Read(Result.Actors[a].Info2, 2);
      data.Read(Result.Actors[a].Info3, 2);
      data.Read(Result.Actors[a].BonusAmount, 2);
      data.Read(Result.Actors[a].TalkColor, 1);
      if (Result.Actors[a].Unknown and $0004) <> 0 then begin //unknown data
        SetLength(Result.Actors[a].UData, 6); //first 2 bytes are NOT the length of the additional segment
        data.Read(Result.Actors[a].UData[1], 6);
        //OutputDebugString(PChar(Format('Unknown = %d!, UData = %.2X %.2X',
        // [Result.Actors[a].Unknown, Byte(Result.Actors[a].UData[1]), Byte(Result.Actors[a].UData[2])])));
      end;
      data.Read(Result.Actors[a].Armour, 1);
      data.Read(Result.Actors[a].LifePoints, 1);
    end;                                         //LBA2 props len: 38 bytes
                                              
    Result.Actors[a].UndoRedoIndex:= 0;

    // Get Actor Track Script
    data.Read(NumBytes, 2);
    SetLength(Result.Actors[a].TrackScriptBin, NumBytes);
    if NumBytes > 0 then
      data.Read(Result.Actors[a].TrackScriptBin[1], NumBytes);

    // Get Actor Life Script
    data.Read(NumBytes, 2);
    SetLength(Result.Actors[a].LifeScriptBin, NumBytes);
    if NumBytes > 0 then
      data.Read(Result.Actors[a].LifeScriptBin[1], NumBytes);
  end;

  if Lba = 2 then data.Read(Result.Unknown, 4);

  // Read Zones
  data.Read(NumObjects, 2);
  SetLength(Result.Zones, NumObjects);

  dSize:= IfThen(Lba = 2, 4, 2);
  for a:= 0 to NumObjects - 1 do begin
    data.Read(Result.Zones[a].X1, dSize);
    data.Read(Result.Zones[a].Y1, dSize);
    data.Read(Result.Zones[a].Z1, dSize);
    data.Read(Result.Zones[a].X2, dSize);
    data.Read(Result.Zones[a].Y2, dSize);
    data.Read(Result.Zones[a].Z2, dSize);
    if Lba = 1 then begin
      data.Read(Result.Zones[a].ZType, 2);
      data.Read(Result.Zones[a].Info[0], 2);
      data.Read(Result.Zones[a].Info[1], 2);
      data.Read(Result.Zones[a].Info[2], 2);
      data.Read(Result.Zones[a].Info[3], 2);
      data.Read(Result.Zones[a].Snap, 2);
    end
    else begin //LBA2
      data.Read(Result.Zones[a].Info[0], 4);
      data.Read(Result.Zones[a].Info[1], 4);
      data.Read(Result.Zones[a].Info[2], 4);
      data.Read(Result.Zones[a].Info[3], 4);
      data.Read(Result.Zones[a].Info[4], 4);
      data.Read(Result.Zones[a].Info[5], 4);
      data.Read(Result.Zones[a].Info[6], 4);
      data.Read(Result.Zones[a].Info[7], 4);
      data.Read(Result.Zones[a].ZType, 2);
      data.Read(Result.Zones[a].Snap, 2);
    end;
  end;

  // Read Points
  data.Read(NumObjects, 2);
  SetLength(Result.Points, NumObjects);

  for a:= 0 to NumObjects - 1 do begin
    data.Read(Result.Points[a].X, dSize);
    data.Read(Result.Points[a].Y, dSize);
    data.Read(Result.Points[a].Z, dSize);
  end;

  if Lba = 2 then begin //additional unknown data
    data.Read(NumData, 4);
    SetLength(Result.UData, NumData * 4);
    if NumData > 0 then
      data.Read(Result.UData[1], NumData * 4);
  end;

  //if data.Position < data.Size then
  //  OutputDebugString(PChar(Format('data size = %d, pos = %d', [data.Size, data.Position])));

  ComputeSpecificValues(Result, Lba);

  SetupDecompiler(Lba);

  SetLength(Result.TrackTrans_, Length(Result.Actors));
  SetLength(Result.TrackHashes_, Length(Result.Actors));
  for a:= 0 to High(Result.Actors) do
    Result.Actors[a].TrackScriptTxt:=
      TrackDecompile(Result.Actors[a].TrackScriptBin, Result.TrackTrans_[a], Result.TrackHashes_[a]);

  SetLength(Result.CompLists_, Length(Result.Actors));
  SetLength(Result.LifeTrans_, Length(Result.Actors));
  for a:= 0 to High(Result.Actors) do
    Result.LifeTrans_[a]:=
      LifeDecompToTransTable(Result.Actors[a].LifeScriptBin, Result.CompLists_[a]);

  LifeDecompResolveOffsets(Result.LifeTrans_, Result.TrackHashes_, Result.CompLists_);

  for a:= 0 to High(Result.Actors) do
    Result.Actors[a].LifeScriptTxt:= LifeDecompTransToString(Result.LifeTrans_[a], a);

  ReleaseDecompiler();

  if CleanUp then begin
    SetLength(Result.TrackTrans_, 0);
    SetLength(Result.TrackHashes_, 0);
    SetLength(Result.TrackHashes2_, 0);
    SetLength(Result.LifeTrans_, 0);
    SetLength(Result.CompLists_, 0);
    SetLength(Result.CompLists2_, 0);
  end;
end;

Function LoadSceneFromFile(path: String; Lba: Byte; CleanUp: Boolean = True): TScene;
var FStr: TFileStream;
begin
  FStr:= TFileStream.Create(path, fmOpenRead);
  Result:= LoadSceneFromStream(FStr, Lba, CleanUp);
  FStr.Free();
end;

function LoadSceneFromString(data: String; Lba: Byte; CleanUp: Boolean = True): TScene;
var MStr: TMemoryStream;
begin
  MStr:= TMemoryStream.Create();
  MStr.Write(data[1], Length(Data));
  Result:= LoadSceneFromStream(MStr, Lba, CleanUp);
  MStr.Free();
end;

{Procedure SaveSceneFile(path: String; Lba: Byte; Scene: TScene);
var FStr: TFileStream;
    temp: String;
begin
  temp:= SceneToString(Scene, Lba);
  FStr:= TFileStream.Create(path, fmCreate or fmShareExclusive);
  FStr.Size:= 0;
  FStr.Seek(0, soBeginning);
  FStr.Write(temp[1], Length(temp));
  FStr.Free();
end;}

//Saves binary Scene, updates Actor Fragment offset info
function SceneToString(var Scene: TScene; Lba: Byte): String;
var a, b, off: Integer;
begin
  StoreSpecificValues(Scene, Lba);

  Result:=                                    //LBA1  LBA2
    Char(Scene.TextBank)                      //0x00  0x00
  + Char(Scene.GameOverScene)                 //0x01  0x01
  + GetStrWord(Scene.UnUsed1)                 //0x02  0x02
  + GetStrWord(Scene.UnUsed2);                //0x04  0x04
  if Lba = 2 then
    Result:= Result + Char(Scene.UnUsed3);    //      0x06
  Result:= Result
  + GetStrWord(Scene.AlphaLight)              //0x06  0x07
  + GetStrWord(Scene.BetaLight)               //0x08  0x09
  + GetStrWord(Word(Scene.SampleAmbience[0])) //0x0A  0x0B
  + GetStrWord(Word(Scene.SampleRepeat[0]))   //0x0C  0x0D
  + GetStrWord(Word(Scene.SampleRound[0]));   //0x0E  0x0F
  if Lba = 2 then begin
    Result:= Result
    + GetStrWord(Word(Scene.SampleUnknown1[0])) //    0x11
    + GetStrWord(Word(Scene.SampleUnknown2[0]));//    0x13
  end;
  Result:= Result
  + GetStrWord(Word(Scene.SampleAmbience[1])) //0x10  0x15
  + GetStrWord(Word(Scene.SampleRepeat[1]))   //0x12  0x17
  + GetStrWord(Word(Scene.SampleRound[1]));   //0x14  0x19
  if Lba = 2 then begin
    Result:= Result
    + GetStrWord(Word(Scene.SampleUnknown1[1])) //    0x1B
    + GetStrWord(Word(Scene.SampleUnknown2[1]));//    0x1D
  end;
  Result:= Result
  + GetStrWord(Word(Scene.SampleAmbience[2])) //0x16  0x1F
  + GetStrWord(Word(Scene.SampleRepeat[2]))   //0x18  0x21
  + GetStrWord(Word(Scene.SampleRound[2]));   //0x1A  0x23
  if Lba = 2 then begin
    Result:= Result
    + GetStrWord(Word(Scene.SampleUnknown1[2])) //    0x25
    + GetStrWord(Word(Scene.SampleUnknown2[2]));//    0x27
  end;
  Result:= Result
  + GetStrWord(Word(Scene.SampleAmbience[3])) //0x1C  0x29
  + GetStrWord(Word(Scene.SampleRepeat[3]))   //0x1E  0x2B
  + GetStrWord(Word(Scene.SampleRound[3]));   //0x20  0x2D
  if Lba = 2 then begin
    Result:= Result
    + GetStrWord(Word(Scene.SampleUnknown1[3])) //    0x2F
    + GetStrWord(Word(Scene.SampleUnknown2[3]));//    0x31
  end;
  Result:= Result
  + GetStrWord(Word(Scene.MinDelay))        //0x22
  + GetStrWord(Word(Scene.MinDelayRnd))     //0x24
  + Char(Scene.MusicIndex)            //0x26

  + GetStrWord(Word(Scene.Actors[0].X))     //0x27
  + GetStrWord(Word(Scene.Actors[0].Y))     //0x29
  + GetStrWord(Word(Scene.Actors[0].Z))     //0x2B
    //TODO: Check during compilation if scripts are not too long
  + GetStrWord(Length(Scene.Actors[0].TrackScriptBin)) //0x2D
  + Scene.Actors[0].TrackScriptBin    //0x2F
  + GetStrWord(Length(Scene.Actors[0].LifeScriptBin));

  off:= Length(Result); //offset of the binary Life Script
  for b:= 0 to High(Scene.Actors[0].FragmentInfo) do  //shift all offsets so they are relative to the
    Inc(Scene.Actors[0].FragmentInfo[b].Offset, off); //Scene beginning instead of Script beginning

  Result:= Result + Scene.Actors[0].LifeScriptBin

  + GetStrWord(Length(Scene.Actors));
  for a:= 1 to High(Scene.Actors) do begin
    if Lba = 1 then begin
      Result:= Result
        + GetStrWord(Scene.Actors[a].StaticFlags)
        + GetStrWord(Word(Scene.Actors[a].Entity))
        + Char(Scene.Actors[a].Body)
        + Char(Scene.Actors[a].Anim)
        + GetStrWord(Scene.Actors[a].Sprite)
        + GetStrWord(Word(Scene.Actors[a].X))
        + GetStrWord(Word(Scene.Actors[a].Y))
        + GetStrWord(Word(Scene.Actors[a].Z))
        + Char(Scene.Actors[a].HitPower)
        + GetStrWord(Scene.Actors[a].BonusType)
        + GetStrWord(Scene.Actors[a].Angle)
        + GetStrWord(Scene.Actors[a].RotSpeed)
        + Char(Scene.Actors[a].CtrlMode)
        + Char(Scene.Actors[a].CtrlUnk)
        + GetStrWord(Word(Scene.Actors[a].Info0))
        + GetStrWord(Word(Scene.Actors[a].Info1))
        + GetStrWord(Word(Scene.Actors[a].Info2))
        + GetStrWord(Word(Scene.Actors[a].Info3))
        + Char(Scene.Actors[a].BonusAmount)
        + Char(Scene.Actors[a].TalkColor)
        + Char(Scene.Actors[a].Armour)
        + Char(Scene.Actors[a].LifePoints)
        + GetStrWord(Length(Scene.Actors[a].TrackScriptBin))
        + Scene.Actors[a].TrackScriptBin
        + GetStrWord(Length(Scene.Actors[a].LifeScriptBin));
    end
    else begin //LBA 2
      Result:= Result
        + GetStrWord(Scene.Actors[a].StaticFlags)
        + GetStrWord(Scene.Actors[a].Unknown) //maybe flags are 4 bytes long for LBA2?
        + GetStrWord(Word(Scene.Actors[a].Entity))
        + Char(Scene.Actors[a].Body)
        + Char(Scene.Actors[a].BodyAdd) //flag byte for LBA2
        + Char(Scene.Actors[a].Anim)
        + GetStrWord(Scene.Actors[a].Sprite)
        + GetStrWord(Word(Scene.Actors[a].X))
        + GetStrWord(Word(Scene.Actors[a].Y))
        + GetStrWord(Word(Scene.Actors[a].Z))
        + Char(Scene.Actors[a].HitPower)
        + GetStrWord(Scene.Actors[a].BonusType)
        + GetStrWord(Scene.Actors[a].Angle)
        + GetStrWord(Scene.Actors[a].RotSpeed)
        + Char(Scene.Actors[a].CtrlMode)
        + GetStrWord(Word(Scene.Actors[a].Info0))
        + GetStrWord(Word(Scene.Actors[a].Info1))
        + GetStrWord(Word(Scene.Actors[a].Info2))
        + GetStrWord(Word(Scene.Actors[a].Info3))
        + GetStrWord(Scene.Actors[a].BonusAmount)
        + Char(Scene.Actors[a].TalkColor);
      if (Scene.Actors[a].Unknown and $0004) <> 0 then //unknown data
        Result:= Result + Scene.Actors[a].UData;
      Result:= Result
        + Char(Scene.Actors[a].Armour)
        + Char(Scene.Actors[a].LifePoints)
        + GetStrWord(Length(Scene.Actors[a].TrackScriptBin))
        + Scene.Actors[a].TrackScriptBin
        + GetStrWord(Length(Scene.Actors[a].LifeScriptBin));
    end;    

    off:= Length(Result); //offset of the binary Life Script
    for b:= 0 to High(Scene.Actors[a].FragmentInfo) do  //shift all offsets so they are relative to the
      Inc(Scene.Actors[a].FragmentInfo[b].Offset, off); //Scene beginning instead of Script beginning

    Result:= Result + Scene.Actors[a].LifeScriptBin;
  end;

  if Lba = 2 then
    Result:= Result + UIntToBinStr(Scene.Unknown);

  Result:= Result + GetStrWord(Length(Scene.Zones));
  for a:= 0 to High(Scene.Zones) do begin
    if Lba = 1 then begin
      Result:= Result
        + GetStrWord(Word(Scene.Zones[a].X1))
        + GetStrWord(Word(Scene.Zones[a].Y1))
        + GetStrWord(Word(Scene.Zones[a].Z1))
        + GetStrWord(Word(Scene.Zones[a].X2))
        + GetStrWord(Word(Scene.Zones[a].Y2))
        + GetStrWord(Word(Scene.Zones[a].Z2))
        + GetStrWord(Scene.Zones[a].ZType);
      if Scene.Zones[a].ZType = 3 then
        Scene.Zones[a].FragmentOffset:= Length(Result); //Points to the first byte of Info0
      Result:= Result
        + GetStrWord(Scene.Zones[a].Info[0])
        + GetStrWord(Scene.Zones[a].Info[1])
        + GetStrWord(Scene.Zones[a].Info[2])
        + GetStrWord(Scene.Zones[a].Info[3])
        + GetStrWord(Scene.Zones[a].Snap);
    end
    else begin //LBA2
      Result:= Result
        + IntToBinStr(Scene.Zones[a].X1)
        + IntToBinStr(Scene.Zones[a].Y1)
        + IntToBinStr(Scene.Zones[a].Z1)
        + IntToBinStr(Scene.Zones[a].X2)
        + IntToBinStr(Scene.Zones[a].Y2)
        + IntToBinStr(Scene.Zones[a].Z2);
      if Scene.Zones[a].ZType = 3 then
        Scene.Zones[a].FragmentOffset:= Length(Result); //Points to the first byte of Info0
      Result:= Result
        + UIntToBinStr(Scene.Zones[a].Info[0])
        + UIntToBinStr(Scene.Zones[a].Info[1])
        + UIntToBinStr(Scene.Zones[a].Info[2])
        + UIntToBinStr(Scene.Zones[a].Info[3])
        + UIntToBinStr(Scene.Zones[a].Info[4])
        + UIntToBinStr(Scene.Zones[a].Info[5])
        + UIntToBinStr(Scene.Zones[a].Info[6])
        + UIntToBinStr(Scene.Zones[a].Info[7])
        + GetStrWord(Scene.Zones[a].ZType)
        + GetStrWord(Scene.Zones[a].Snap);
    end;
  end;

  Result:= Result + GetStrWord(Length(Scene.Points));
  if Lba = 1 then begin
    for a:= 0 to High(Scene.Points) do begin
      Result:= Result
        + GetStrWord(Word(Scene.Points[a].X))
        + GetStrWord(Word(Scene.Points[a].Y))
        + GetStrWord(Word(Scene.Points[a].Z));
    end;
  end else begin
    for a:= 0 to High(Scene.Points) do begin
      Result:= Result
        + IntToBinStr(Scene.Points[a].X)
        + IntToBinStr(Scene.Points[a].Y)
        + IntToBinStr(Scene.Points[a].Z);
    end;
  end;

  if Lba = 2 then begin //additional unknown data
    Result:= Result
      + UIntToBinStr(Length(Scene.UData) div 4)
      + Scene.UData;
  end;
end;

function ReadStreamLine(data: TStream; out str: String): Boolean;
var c: Char;
    NewLinesBlock: Boolean;
begin
 str:= '';
 If data.Position >= data.Size then
   Result:= False
 else begin
   NewLinesBlock:= False;
   repeat
     data.Read(c, 1);
     If c in [#13, #10] then
       NewLinesBlock:= True
     else begin
       If NewLinesBlock then begin
         data.Seek(-1, soCurrent);
         Result:= True;
         Exit;
       end
       else str:= str + c;
     end;
   until data.Position >= data.Size;
   Result:= str <> '';
 end;
end;

Function GetNameValueStr(line: String; Separator: Char;
  out name: String; out value: String): Boolean;
var b: Integer;
begin
 Result:= False;
 b:= Pos(Separator, line);
 If b > 0 then begin
   name:= Copy(line, 1, b - 1);
   Value:= Trim(Copy(line, b + 1, Length(line) - b));
   Result:= True;
 end;
end;

Function GetNameValue(line: String; Separator: Char;
  out name: String; out value: Integer): Boolean;
var temp: String;
begin
 Result:= GetNameValueStr(line, Separator, name, temp)
      and TryStrToInt(temp, value);
end;

//Opens Text Scene
Function LoadTextSceneStream(data: TStream; Lba: Byte; out sc: TScene): Boolean;
var a, x, y, z, value, LastActor: Integer;
    line, ActorName, name: String;
    Section: (seNone, seTEXT, seMAP_FILE, seAMBIANCE, seHERO_START,
              seTRACK_PROG, seLIFE_PROG, seOBJECT, seVAR_CUBE, seZONE, seTRACK);
begin
  Result:= False;
  if Lba = 2 then begin
    WarningMsg('Scenes with .sc2 extension are currently not supported, because there '
     + 'is no known reference or example of such file. If you have one of these '
     + 'files, it would be nice if you could provide it to me, so I could make '
     + 'the support. Contact me at kazink@gmail.com.');
    Exit;
  end;
  SetLength(sc.Actors, 1);
  LastActor:= 0;
  data.Seek(0, soBeginning);
  Section:= seNone;
  x:= 0;
  y:= 0;
  z:= 0;
  while ReadStreamLine(data, line) do begin
    if (LeftStr(line, 4) = '--> ') and (RightStr(line, 4) = ' <--') then begin
      name:= Copy(line, 5, Length(line) - 8);
           If SameText(name, 'TEXT') then Section:= seTEXT
      else if SameText(name, 'MAP_FILE') then Section:= seMAP_FILE
      else if SameText(name, 'AMBIANCE') then Section:= seAMBIANCE
      else if SameText(name, 'HERO_START') then Section:= seHERO_START
      else if SameText(name, 'TRACK_PROG') then Section:= seTRACK_PROG
      else if SameText(name, 'LIFE_PROG') then Section:= seLIFE_PROG
      else if SameText(LeftStr(name, 6), 'OBJECT') then Section:= seOBJECT
      else if SameText(name, 'VAR_CUBE') then Section:= seVAR_CUBE //Unused
      else if SameText(name, 'ZONE') then Section:= seZONE
      else if SameText(name, 'TRACK') then Section:= seTRACK
      else Section:= seNone;
      If Section = seZONE then
        SetLength(sc.Zones, Length(sc.Zones) + 1)
      else if Section = seHERO_START then
        LastActor:= 0;
      //If SameText(LeftStr(Section, 6), 'OBJECT') then
      //  If High(Result.Actors) <
    end
    else begin
      case Section of
        seTEXT: begin
          If not GetNameValue(line, ':', name, value) then Exit;
          If SameText(name, 'textBank') then sc.TextBank:= value
        end;
        seMAP_FILE: begin
          If not GetNameValue(line, ':', name, value) then Exit;
          If SameText(name, 'cube') then sc.GameOverScene:= value
        end;
        seAMBIANCE: begin
          If not GetNameValue(line, ':', name, value) then Exit;
               If SameText(name, 'AlphaLight') then sc.AlphaLight:= Word(value)
          else if SameText(name, 'BetaLight') then sc.BetaLight:= Word(value)
          else if SameText(name, 'amb0_1') then sc.SampleAmbience[0]:= SmallInt(value)
          else if SameText(name, 'amb0_2') then sc.SampleRepeat[0]:= SmallInt(value)
          else if SameText(name, 'amb0_3') then sc.SampleRound[0]:= SmallInt(value)
          else if SameText(name, 'amb0_4') then sc.SampleUnknown1[0]:= SmallInt(value)
          else if SameText(name, 'amb0_5') then sc.SampleUnknown2[0]:= SmallInt(value)
          else if SameText(name, 'amb1_1') then sc.SampleAmbience[1]:= SmallInt(value)
          else if SameText(name, 'amb1_2') then sc.SampleRepeat[1]:= SmallInt(value)
          else if SameText(name, 'amb1_3') then sc.SampleRound[1]:= SmallInt(value)
          else if SameText(name, 'amb1_4') then sc.SampleUnknown1[1]:= SmallInt(value)
          else if SameText(name, 'amb1_5') then sc.SampleUnknown2[1]:= SmallInt(value)
          else if SameText(name, 'amb2_1') then sc.SampleAmbience[2]:= SmallInt(value)
          else if SameText(name, 'amb2_2') then sc.SampleRepeat[2]:= SmallInt(value)
          else if SameText(name, 'amb2_3') then sc.SampleRound[2]:= SmallInt(value)
          else if SameText(name, 'amb2_4') then sc.SampleUnknown1[2]:= SmallInt(value)
          else if SameText(name, 'amb2_5') then sc.SampleUnknown2[2]:= SmallInt(value)
          else if SameText(name, 'amb3_1') then sc.SampleAmbience[3]:= SmallInt(value)
          else if SameText(name, 'amb3_2') then sc.SampleRepeat[3]:= SmallInt(value)
          else if SameText(name, 'amb3_3') then sc.SampleRound[3]:= SmallInt(value)
          else if SameText(name, 'amb3_4') then sc.SampleUnknown1[3]:= SmallInt(value)
          else if SameText(name, 'amb3_5') then sc.SampleUnknown2[3]:= SmallInt(value)
          else if SameText(name, 'Second_Min') then sc.MinDelay:= Word(value)
          else if SameText(name, 'Second_Ecart') then sc.MinDelayRnd:= Word(value)
          else if SameText(name, 'Jingle') then sc.MusicIndex:= Byte(value)
        end;
        seZONE: begin
          If not GetNameValue(line, ':', name, value) then Exit;
               If SameText(name, 'X0') then sc.Zones[High(sc.Zones)].X1:= SmallInt(value)
          else if SameText(name, 'Y0') then sc.Zones[High(sc.Zones)].Y1:= SmallInt(value)
          else if SameText(name, 'Z0') then sc.Zones[High(sc.Zones)].Z1:= SmallInt(value)
          else if SameText(name, 'X1') then sc.Zones[High(sc.Zones)].X2:= SmallInt(value)
          else if SameText(name, 'Y1') then sc.Zones[High(sc.Zones)].Y2:= SmallInt(value)
          else if SameText(name, 'Z1') then sc.Zones[High(sc.Zones)].Z2:= SmallInt(value)
          else if SameText(name, 'Type') then sc.Zones[High(sc.Zones)].ZType:= Word(value)
          else if SameText(name, 'Info0') then sc.Zones[High(sc.Zones)].Info[0]:= Word(value)
          else if SameText(name, 'Info1') then sc.Zones[High(sc.Zones)].Info[1]:= Word(value)
          else if SameText(name, 'Info2') then sc.Zones[High(sc.Zones)].Info[2]:= Word(value)
          else if SameText(name, 'Info3') then sc.Zones[High(sc.Zones)].Info[3]:= Word(value)
          else if SameText(name, 'Info4') then sc.Zones[High(sc.Zones)].Info[4]:= Word(value)
          else if SameText(name, 'Info5') then sc.Zones[High(sc.Zones)].Info[5]:= Word(value)
          else if SameText(name, 'Info6') then sc.Zones[High(sc.Zones)].Info[6]:= Word(value)
          else if SameText(name, 'Snap') then sc.Zones[High(sc.Zones)].Snap:= Word(value)
        end;
        seTRACK: begin
          if not GetNameValue(line, ':', name, value) then Exit;
               If SameText(name, 'X') then x:= value
          else if SameText(name, 'Y') then y:= value
          else if SameText(name, 'Z') then z:= value
          else if SameText(name, 'Num') then begin
            If High(sc.Points) < value then SetLength(sc.Points, value + 1);
            sc.Points[value].X:= SmallInt(x);
            sc.Points[value].Y:= SmallInt(y);
            sc.Points[value].Z:= SmallInt(z);
          end;
        end;
        seHERO_START: begin
          If not GetNameValue(line, ':', name, value) then Exit;
               If SameText(name, 'X') then sc.Actors[0].X:= SmallInt(value)
          else if SameText(name, 'Y') then sc.Actors[0].Y:= SmallInt(value)
          else if SameText(name, 'Z') then sc.Actors[0].Z:= SmallInt(value)
        end;
        seTRACK_PROG: sc.Actors[LastActor].TrackScriptTxt:= sc.Actors[LastActor].TrackScriptTxt + line + CR;
        seLIFE_PROG:  sc.Actors[LastActor].LifeScriptTxt:= sc.Actors[LastActor].LifeScriptTxt + line + CR;
        seOBJECT: begin
          if SameText(Copy(line, 1, 5), 'Name:') then
            ActorName:= Trim(Copy(line, 7, Length(line) - 7))
          else begin
            if not GetNameValue(line, ':', name, value) then Exit;
            if SameText(name, 'Num') then begin
              if High(sc.Actors) < value then SetLength(sc.Actors, value + 1);
              sc.Actors[value].Name:= ActorName;
              LastActor:= value;
            end
            else if SameText(name, 'StaticFlags') then sc.Actors[LastActor].StaticFlags:= Word(value)
            else if SameText(name, 'File3D') then sc.Actors[LastActor].Entity:= SmallInt(value)
            else if SameText(name, 'Body') then sc.Actors[LastActor].Body:= Byte(value)
            else if SameText(name, 'Anim') then sc.Actors[LastActor].Anim:= Byte(value)
            else if SameText(name, 'Sprite') then sc.Actors[LastActor].Sprite:= Word(value)
            else if SameText(name, 'X') then sc.Actors[LastActor].X:= SmallInt(value)
            else if SameText(name, 'Y') then sc.Actors[LastActor].Y:= SmallInt(value)
            else if SameText(name, 'Z') then sc.Actors[LastActor].Z:= SmallInt(value)
            else if SameText(name, 'HitForce') then sc.Actors[LastActor].HitPower:= Byte(value)
            else if SameText(name, 'Bonus') then sc.Actors[LastActor].BonusType:= Word(value)
            else if SameText(name, 'Beta') then sc.Actors[LastActor].Angle:= Word(value)
            else if SameText(name, 'SpeedRot') then sc.Actors[LastActor].RotSpeed:= Word(value)
            else if SameText(name, 'Move') then sc.Actors[LastActor].CtrlMode:= Word(value)
            else if SameText(name, 'CropLeft') then sc.Actors[LastActor].Info0:= SmallInt(value)
            else if SameText(name, 'CropTop') then sc.Actors[LastActor].Info1:= SmallInt(value)
            else if SameText(name, 'CropRight') then sc.Actors[LastActor].Info2:= SmallInt(value)
            else if SameText(name, 'CropBottom') then sc.Actors[LastActor].Info3:= SmallInt(value)
            else if SameText(name, 'ExtraBonus') then sc.Actors[LastActor].BonusAmount:= Byte(value)
            else if SameText(name, 'Color') then sc.Actors[LastActor].TalkColor:= Byte(value)
            else if SameText(name, 'Armure') then sc.Actors[LastActor].Armour:= Byte(value)
            else if SameText(name, 'LifePoint') then sc.Actors[LastActor].LifePoints:= Byte(value)
          end;
        end;
      end;
    end;
  end;

  ComputeSpecificValues(sc, Lba);

  for a:= 0 to High(sc.Actors) do
    sc.Actors[a].UndoRedoIndex:= 0;

  Result:= True;
end;

//Opens Story Coder Project
//There are no LBA2 stp files, as far as I know.
Function LoadCoderProjectStream(data: TStream; Lba: Byte; out sc: TScene): Boolean;
var a, value, oid: Integer;
    line, ActorName, name: String;
    LastObjectSection: (lseNone, lseACTORS, lseZONES, lseTRACKS);
    Section: (seNone, seMAIN_SETTINGS, seACTORS, seOBJECT, seTRACK_SCRIPT,
              seLIFE_SCRIPT, seZONES, sePOINTS);
begin
  Result:= False;
  SetLength(sc.Actors, 1);
  data.Seek(0, soBeginning);
  Section:= seNone;
  LastObjectSection:= lseNone;
  repeat
    if not ReadStreamLine(data, line) then Exit;
  until SameText(Trim(line), '>>>[BEGIN_PROJECT]<<<');

  while ReadStreamLine(data, line) do begin
    If ((LeftStr(line, 1) = '[') and (RightStr(line, 1) = ']'))
    or ((LeftStr(line, 3) = '->[') and (RightStr(line, 3) = ']<-')) then begin
           If SameText(line, '[MAIN_SETTINGS]') then Section:= seMAIN_SETTINGS
      else if SameText(LeftStr(line, 7), '[ACTORS') then Section:= seACTORS
      else if SameText(LeftStr(line, 7), '[OBJECT') then Section:= seOBJECT
      else if SameText(line, '->[TRACK_SCRIPT]<-') then Section:= seTRACK_SCRIPT
      else if SameText(line, '->[LIFE_SCRIPT]<-') then Section:= seLIFE_SCRIPT
      else if SameText(LeftStr(line, 6), '[ZONES') then Section:= seZONES
      else if SameText(LeftStr(line, 7), '[TRACKS') then Section:= sePOINTS
      else Section:= seNone;
      if Section = seOBJECT then begin
        if not TryStrToInt(Copy(line, 9, Length(line) - 9), oid) then Exit;
        case LastObjectSection of
          lseACTORS: if oid > High(sc.Actors) then Exit;
          lseZONES:  if oid > High(sc.Zones)  then Exit;
          lseTRACKS: if oid > High(sc.Points) then Exit;
        end;
      end;
    end
    else begin
      case Section of
        seMAIN_SETTINGS: begin
          If not GetNameValue(line, '=', name, value) then Exit;
               If SameText(name, 'TextBank') then sc.TextBank:= value
          else If SameText(name, 'CubeEntry') then sc.GameOverScene:= value
          else If SameText(name, 'AlphaLight') then sc.AlphaLight:= Word(value)
          else if SameText(name, 'BetaLight') then sc.BetaLight:= Word(value)
          else if SameText(name, 'Amb0_1') then sc.SampleAmbience[0]:= SmallInt(value)
          else if SameText(name, 'Amb0_2') then sc.SampleRepeat[0]:= SmallInt(value)
          else if SameText(name, 'Amb0_3') then sc.SampleRound[0]:= SmallInt(value)
          else if SameText(name, 'Amb0_4') then sc.SampleUnknown1[0]:= SmallInt(value)
          else if SameText(name, 'Amb0_5') then sc.SampleUnknown2[0]:= SmallInt(value)
          else if SameText(name, 'Amb1_1') then sc.SampleAmbience[1]:= SmallInt(value)
          else if SameText(name, 'Amb1_2') then sc.SampleRepeat[1]:= SmallInt(value)
          else if SameText(name, 'Amb1_3') then sc.SampleRound[1]:= SmallInt(value)
          else if SameText(name, 'Amb1_4') then sc.SampleUnknown1[1]:= SmallInt(value)
          else if SameText(name, 'Amb1_5') then sc.SampleUnknown2[1]:= SmallInt(value)
          else if SameText(name, 'Amb2_1') then sc.SampleAmbience[2]:= SmallInt(value)
          else if SameText(name, 'Amb2_2') then sc.SampleRepeat[2]:= SmallInt(value)
          else if SameText(name, 'Amb2_3') then sc.SampleRound[2]:= SmallInt(value)
          else if SameText(name, 'Amb2_4') then sc.SampleUnknown1[2]:= SmallInt(value)
          else if SameText(name, 'Amb2_5') then sc.SampleUnknown2[2]:= SmallInt(value)
          else if SameText(name, 'Amb3_1') then sc.SampleAmbience[3]:= SmallInt(value)
          else if SameText(name, 'Amb3_2') then sc.SampleRepeat[3]:= SmallInt(value)
          else if SameText(name, 'Amb3_3') then sc.SampleRound[3]:= SmallInt(value)
          else if SameText(name, 'Amb3_4') then sc.SampleUnknown1[3]:= SmallInt(value)
          else if SameText(name, 'Amb3_5') then sc.SampleUnknown2[3]:= SmallInt(value)
          else if SameText(name, 'Second_Min') then sc.MinDelay:= Word(value)
          else if SameText(name, 'Second_Ecart') then sc.MinDelayRnd:= Word(value)
          else if SameText(name, 'CubeMusic') then sc.MusicIndex:= Byte(value)
        end;
        seACTORS: begin
          If not GetNameValue(Copy(line, 9, Length(line) - 9), '=', name, value) then Exit;
          SetLength(sc.Actors, Value);
          LastObjectSection:= lseACTORS;
        end;
        seZONES: begin
          If not GetNameValue(Copy(line, 8, Length(line) - 8), '=', name, value) then Exit;
          SetLength(sc.Zones, Value);
          LastObjectSection:= lseZONES;
        end;
        sePOINTS: begin
          If not GetNameValue(Copy(line, 9, Length(line) - 9), '=', name, value) then Exit;
          SetLength(sc.Points, Value);
          LastObjectSection:= lseTRACKS;
        end;
        seOBJECT: begin
          case LastObjectSection of
            lseACTORS: begin
              If SameText(Copy(line, 1, 5), 'Name:') then
                ActorName:= Trim(Copy(line, 7, Length(line) - 7))
              else begin
                If not GetNameValue(line, '=', name, value) then Exit;
                     If SameText(name, 'StaticFlags') then sc.Actors[oid].StaticFlags:= Word(value)
                else if SameText(name, 'Entity')      then sc.Actors[oid].Entity:= SmallInt(value)
                else if SameText(name, 'Body')        then sc.Actors[oid].Body:= Byte(value)
                else if SameText(name, 'Animation')   then sc.Actors[oid].Anim:= Byte(value)
                else if SameText(name, 'SpriteEntry') then sc.Actors[oid].Sprite:= Word(value)
                else if SameText(name, 'X')           then sc.Actors[oid].X:= SmallInt(value)
                else if SameText(name, 'Y')           then sc.Actors[oid].Y:= SmallInt(value)
                else if SameText(name, 'Z')           then sc.Actors[oid].Z:= SmallInt(value)
                else if SameText(name, 'StrengthOfHit') then sc.Actors[oid].HitPower:= Byte(value)
                else if SameText(name, 'BonusParameter') then sc.Actors[oid].BonusType:= Word(value)
                else if SameText(name, 'BetaAngle')   then sc.Actors[oid].Angle:= Word(value)
                else if SameText(name, 'SpeedRotation') then sc.Actors[oid].RotSpeed:= Word(value)
                else if SameText(name, 'Move')        then sc.Actors[oid].CtrlMode:= Word(value)
                else if SameText(name, 'CropLeft')    then sc.Actors[oid].Info0:= SmallInt(value)
                else if SameText(name, 'CropTop')     then sc.Actors[oid].Info1:= SmallInt(value)
                else if SameText(name, 'CropRight')   then sc.Actors[oid].Info2:= SmallInt(value)
                else if SameText(name, 'CropBottom')  then sc.Actors[oid].Info3:= SmallInt(value)
                else if SameText(name, 'BonusAmount') then sc.Actors[oid].BonusAmount:= Byte(value)
                else if SameText(name, 'TalkColor')   then sc.Actors[oid].TalkColor:= Byte(value)
                else if SameText(name, 'Armour')      then sc.Actors[oid].Armour:= Byte(value)
                else if SameText(name, 'LifePoints')  then sc.Actors[oid].LifePoints:= Byte(value)
              end;
            end;
            lseZONES: begin
              If not GetNameValue(line, '=', name, value) then Exit;
                   If SameText(name, 'X0')    then sc.Zones[oid].X1:= SmallInt(value)
              else if SameText(name, 'Y0')    then sc.Zones[oid].Y1:= SmallInt(value)
              else if SameText(name, 'Z0')    then sc.Zones[oid].Z1:= SmallInt(value)
              else if SameText(name, 'X1')    then sc.Zones[oid].X2:= SmallInt(value)
              else if SameText(name, 'Y1')    then sc.Zones[oid].Y2:= SmallInt(value)
              else if SameText(name, 'Z1')    then sc.Zones[oid].Z2:= SmallInt(value)
              else if SameText(name, 'Type')  then sc.Zones[oid].ZType:= Word(value)
              else if SameText(name, 'Info0') then sc.Zones[oid].Info[0]:= Word(value)
              else if SameText(name, 'Info1') then sc.Zones[oid].Info[1]:= Word(value)
              else if SameText(name, 'Info2') then sc.Zones[oid].Info[2]:= Word(value)
              else if SameText(name, 'Info3') then sc.Zones[oid].Info[3]:= Word(value)
              else if SameText(name, 'Info4') then sc.Zones[oid].Info[4]:= Word(value)
              else if SameText(name, 'Info5') then sc.Zones[oid].Info[5]:= Word(value)
              else if SameText(name, 'Info6') then sc.Zones[oid].Info[6]:= Word(value)
              else if SameText(name, 'Snap')  then sc.Zones[oid].Snap:= Word(value)
            end;
            lseTRACKS: begin
              If not GetNameValue(line, '=', name, value) then Exit;
                   If SameText(name, 'X') then sc.Points[oid].X:= SmallInt(value)
              else if SameText(name, 'Y') then sc.Points[oid].Y:= SmallInt(value)
              else if SameText(name, 'Z') then sc.Points[oid].Z:= SmallInt(value)
            end;
          end;
        end;
        seTRACK_SCRIPT: begin
          If LastObjectSection <> lseACTORS then Exit;
          sc.Actors[oid].TrackScriptTxt:= sc.Actors[oid].TrackScriptTxt + line + CR;
        end;
        seLIFE_SCRIPT: begin
          If LastObjectSection <> lseACTORS then Exit;
          sc.Actors[oid].LifeScriptTxt:= sc.Actors[oid].LifeScriptTxt + line + CR;
        end;
      end;
    end;
  end;

  ComputeSpecificValues(sc, Lba);

  for a:= 0 to High(sc.Actors) do
    sc.Actors[a].UndoRedoIndex:= 0;

  Result:= True;
end;

function SceneProjectGetStr(Data: TStringList; Section, Name: String;
  out Value: String): Boolean;
var sid, eid, a: Integer;
    temp: String;
begin
  Result:= True;
  sid:= Data.IndexOf('[' + Section + ' BEGIN]');
  eid:= Data.IndexOf('[' + Section + ' END]');
  if (sid > -1) and (eid > -1) then begin
    for a:= sid + 1 to eid - 1 do begin
      temp:= Data.Names[a];
      if SameText(temp, Name) then begin
        Value:= Data.ValueFromIndex[a];
        Exit;
      end;
    end;
  end;
  Result:= False;
end;

function SceneProjectGetInt(Data: TStringList; Section, Name: String;
  out Value: Integer): Boolean;
var temp: String;
begin
  Result:= SceneProjectGetStr(Data, Section, Name, temp) and TryStrToInt(temp, Value);
end;

function SceneProjectGetDWord(Data: TStringList; Section, Name: String;
  out Value: DWord): Boolean;
var temp: String;
    vtemp: Int64;
begin
  Result:= SceneProjectGetStr(Data, Section, Name, temp)
       and TryStrToInt64(temp, vtemp);
  if Result then
    Value:= DWord(vtemp);
end;

function SceneProjectGetBinData(Data: TStringList; Section, Name: String;
  out Value: String): Boolean;
var temp: String;
    temp2: TStrDynAr;
    a, b: Integer;
begin
  Value:= '';
  Result:= False;
  if SceneProjectGetStr(Data, Section, Name, temp) then begin
    temp2:= ParseCSVLine(temp, ',');
    for a:= 0 to High(temp2) do begin
      if TryStrToInt('$'+temp2[a], b) and (b >= 0) and (b <= 255) then
        Value:= Value + Char(b)
      else
        Exit;
    end;
    Result:= True;
  end;
end;

Function SceneProjectGetSection(Data: TStringList; Section: String;
  out Content: String): Boolean;
var a, sid, eid: Integer;
begin
 Content:= '';
 Result:= True;
 sid:= Data.IndexOf('[' + Section + ' BEGIN]');
 eid:= Data.IndexOf('[' + Section + ' END]');
 If (sid > -1) and (eid > -1) then begin
   for a:= sid + 1 to eid - 1 do
     Content:= Content + Data.Strings[a] + CR;
 end
 else Result:= False;
end;

//Opens Scene Text Project
Function LoadSceneProjectStream(data: TStream; var Lba: Byte; out sc: TScene): Boolean;
var a, b, itemp: Integer;
    stemp: String;
    lines: TStringList;
    dwtemp: DWord;
begin
  Result:= False;
  SetLength(sc.Actors, 1);
  //data.Seek(0, soBeginning);
  lines:= TStringList.Create();
  lines.NameValueSeparator:= '=';
  data.Seek(0, soBeginning);
  lines.LoadFromStream(data);

  if not SceneProjectGetStr(lines, 'INFORMATION', 'File', stemp)
  or not SameText(stemp, 'Scene Text Project') then Exit;
  if SceneProjectGetInt(lines, 'INFORMATION', 'LBA', itemp) then
    Lba:= Byte(itemp) else Exit;

  if SceneProjectGetInt(lines, 'ENVIRONMENT', 'Unused1', itemp) then
    sc.UnUsed1:= Word(itemp); //Optional
  if SceneProjectGetInt(lines, 'ENVIRONMENT', 'Unused2', itemp) then
    sc.UnUsed2:= Word(itemp);
  if Lba = 2 then
    if SceneProjectGetInt(lines, 'ENVIRONMENT', 'Unused3', itemp) then
      sc.UnUsed3:= Byte(itemp) else Exit;

  if SceneProjectGetInt(lines, 'ENVIRONMENT', 'TextBank', itemp) then
    sc.TextBank:= Byte(itemp) else Exit;
  if SceneProjectGetInt(lines, 'ENVIRONMENT', 'GameOverScene', itemp) then
    sc.GameOverScene:= Byte(itemp) else Exit;
  if SceneProjectGetInt(lines, 'ENVIRONMENT', 'AlphaLight', itemp) then
    sc.AlphaLight:= Word(itemp) else Exit;
  if SceneProjectGetInt(lines, 'ENVIRONMENT', 'BetaLight', itemp) then
    sc.BetaLight:= Word(itemp) else Exit;

  for a:= 0 to 3 do begin
    if SceneProjectGetInt(lines, 'ENVIRONMENT', 'SndSample'+IntToStr(a), itemp) then
      sc.SampleAmbience[a]:= SmallInt(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ENVIRONMENT', 'SndRepeat'+IntToStr(a), itemp) then
      sc.SampleRepeat[a]:= SmallInt(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ENVIRONMENT', 'SndRound'+IntToStr(a), itemp) then
      sc.SampleRound[a]:= SmallInt(itemp) else Exit;
    if Lba = 2 then begin
      if SceneProjectGetInt(lines, 'ENVIRONMENT', 'Lba2Amb4'+IntToStr(a), itemp) then
        sc.SampleUnknown1[a]:= SmallInt(itemp) else Exit;
      if SceneProjectGetInt(lines, 'ENVIRONMENT', 'Lba2Amb5'+IntToStr(a), itemp) then
        sc.SampleUnknown2[a]:= SmallInt(itemp) else Exit;
    end;
  end;

  if SceneProjectGetInt(lines, 'ENVIRONMENT', 'MinDelay', itemp) then
    sc.MinDelay:= SmallInt(itemp) else Exit;
  if SceneProjectGetInt(lines, 'ENVIRONMENT', 'MinDelayRnd', itemp) then
    sc.MinDelayRnd:= SmallInt(itemp) else Exit;
  if SceneProjectGetInt(lines, 'ENVIRONMENT', 'Music', itemp) then
    sc.MusicIndex:= Byte(itemp) else Exit;

  if Lba = 2 then begin
    //the unknown value between Actors and Zones:
    if SceneProjectGetDWord(lines, 'ENVIRONMENT', 'Unknown', dwtemp) then
      sc.Unknown:= dwtemp else Exit;
    //the unknown data at the end of binary Scene:
    if not SceneProjectGetBinData(lines, 'ENVIRONMENT', 'FinalData', sc.UData)
    then Exit;
  end;

  if SceneProjectGetInt(lines, 'OBJECTS', 'ActorCount', itemp) and (itemp > 0) then
    SetLength(sc.Actors, itemp) else Exit;
  if SceneProjectGetInt(lines, 'OBJECTS', 'ZoneCount', itemp) and (itemp >= 0) then
    SetLength(sc.Zones, itemp) else Exit;
  if SceneProjectGetInt(lines, 'OBJECTS', 'TrackCount', itemp) and (itemp >= 0) then
    SetLength(sc.Points, itemp) else Exit;

  if not SceneProjectGetStr(lines, 'ACTOR 0', 'Name', sc.Actors[0].Name) then Exit;
  if SceneProjectGetInt(lines, 'ACTOR 0', 'X', itemp) then
    sc.Actors[0].X:= SmallInt(itemp) else Exit;
  if SceneProjectGetInt(lines, 'ACTOR 0', 'Y', itemp) then
    sc.Actors[0].Y:= SmallInt(itemp) else Exit;
  if SceneProjectGetInt(lines, 'ACTOR 0', 'Z', itemp) then
    sc.Actors[0].Z:= SmallInt(itemp) else Exit;
  if not SceneProjectGetSection(lines, 'TRACK SCRIPT 0', sc.Actors[0].TrackScriptTxt)
  then Exit;
  if not SceneProjectGetSection(lines, 'LIFE SCRIPT 0', sc.Actors[0].LifeScriptTxt)
  then Exit;

  for a:= 1 to High(sc.Actors) do begin
    stemp:= IntToStr(a);
    if not SceneProjectGetStr(lines, 'ACTOR ' + stemp, 'Name', sc.Actors[a].Name)
    then sc.Actors[a].Name:= '';
    if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'X', itemp) then
      sc.Actors[a].X:= SmallInt(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'Y', itemp) then
      sc.Actors[a].Y:= SmallInt(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'Z', itemp) then
      sc.Actors[a].Z:= SmallInt(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'StaticFlags', itemp) then
      sc.Actors[a].StaticFlags:= Word(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'Entity', itemp) then
      sc.Actors[a].Entity:= SmallInt(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'Body', itemp) then
      sc.Actors[a].Body:= Byte(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'Animation', itemp) then
      sc.Actors[a].Anim:= Byte(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'Sprite', itemp) then
      sc.Actors[a].Sprite:= Word(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'HitPower', itemp) then
      sc.Actors[a].HitPower:= Byte(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'BonusType', itemp) then
      sc.Actors[a].BonusType:= Word(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'FacingAngle', itemp) then
      sc.Actors[a].Angle:= Word(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'RotationSpd', itemp) then
      sc.Actors[a].RotSpeed:= Word(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'Mode', itemp) then
      sc.Actors[a].CtrlMode:= Byte(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'ModeFlag', itemp) then
      sc.Actors[a].CtrlUnk:= Byte(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'CropLeft', itemp) //backward compat
    or SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'Info0', itemp) then
      sc.Actors[a].Info0:= SmallInt(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'CropTop', itemp)
    or SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'Info1', itemp) then
      sc.Actors[a].Info1:= SmallInt(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'CropRight', itemp)
    or SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'Info2', itemp) then
      sc.Actors[a].Info2:= SmallInt(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'CropBottom', itemp)
    or SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'Info3', itemp) then
      sc.Actors[a].Info3:= SmallInt(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'BonusQuantity', itemp) then
      sc.Actors[a].BonusAmount:= Byte(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'TalkColour', itemp) then
      sc.Actors[a].TalkColor:= Byte(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'Armour', itemp) then
      sc.Actors[a].Armour:= Byte(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'LifePoints', itemp) then
      sc.Actors[a].LifePoints:= Byte(itemp) else Exit;
    if Lba = 2 then begin
      if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'StaticFlags2', itemp) then
        sc.Actors[a].Unknown:= Word(itemp) else Exit;
      if SceneProjectGetInt(lines, 'ACTOR ' + stemp, 'BodyFlag', itemp) then
        sc.Actors[a].BodyAdd:= Byte(itemp) else Exit;
       //unknown data - always present in text scene, not always in binary scene
      if not SceneProjectGetBinData(lines, 'ACTOR ' + stemp, 'Data', sc.Actors[a].UData)
      then Exit;
    end;
    if not SceneProjectGetSection(lines, 'TRACK SCRIPT ' + stemp,
             sc.Actors[a].TrackScriptTxt) then Exit;
    if not SceneProjectGetSection(lines, 'LIFE SCRIPT ' + stemp,
             sc.Actors[a].LifeScriptTxt) then Exit;

    sc.Actors[a].UndoRedoIndex:= 0;
  end;

  for a:= 0 to High(sc.Zones) do begin
    stemp:= IntToStr(a);
    if not SceneProjectGetStr(lines, 'ZONE ' + stemp, 'Name', sc.Zones[a].Name)
    then sc.Zones[a].Name:= '';
    if SceneProjectGetInt(lines, 'ZONE ' + stemp, 'X0', itemp) then
      sc.Zones[a].X1:= Integer(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ZONE ' + stemp, 'Y0', itemp) then
      sc.Zones[a].Y1:= Integer(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ZONE ' + stemp, 'Z0', itemp) then
      sc.Zones[a].Z1:= Integer(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ZONE ' + stemp, 'X1', itemp) then
      sc.Zones[a].X2:= Integer(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ZONE ' + stemp, 'Y1', itemp) then
      sc.Zones[a].Y2:= Integer(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ZONE ' + stemp, 'Z1', itemp) then
      sc.Zones[a].Z2:= Integer(itemp) else Exit;
    if SceneProjectGetInt(lines, 'ZONE ' + stemp, 'Type', itemp) then
      sc.Zones[a].ZType:= Word(itemp) else Exit;
    for b:= 0 to IfThen(Lba = 1, 3, 7) do
      if SceneProjectGetDWord(lines, 'ZONE ' + stemp, 'Info'+IntToStr(b), dwtemp) then
        sc.Zones[a].Info[b]:= dwtemp else Exit;
    if SceneProjectGetInt(lines, 'ZONE ' + stemp, 'Snap', itemp) then
      sc.Zones[a].Snap:= Word(itemp) else Exit;
    if not SceneProjectGetStr(lines, 'ZONE ' + stemp, 'FragName', sc.Zones[a].FragmentName)
    then sc.Zones[a].FragmentName:= ''; //Optional
  end;

  for a:= 0 to High(sc.Points) do begin
    stemp:= IntToStr(a);
    SceneProjectGetStr(lines, 'TRACK ' + stemp, 'Name', sc.Points[a].Name);
    if SceneProjectGetInt(lines, 'TRACK ' + stemp, 'X', itemp) then
      sc.Points[a].X:= Integer(itemp) else Exit;
    if SceneProjectGetInt(lines, 'TRACK ' + stemp, 'Y', itemp) then
      sc.Points[a].Y:= Integer(itemp) else Exit;
    if SceneProjectGetInt(lines, 'TRACK ' + stemp, 'Z', itemp) then
      sc.Points[a].Z:= Integer(itemp) else Exit;
  end;

  ComputeSpecificValues(sc, Lba);

  Result:= True;
end;

function LoadSceneProjectString(data: String; var Lba: Byte; out sc: TScene): Boolean;
var MStr: TMemoryStream;
begin
  MStr:= TMemoryStream.Create();
  MStr.Write(data[1], Length(data));
  Result:= LoadSceneProjectStream(MStr, Lba, sc);
  FreeAndNil(MStr);
end;

function StrToBinData(s: String): String;
var temp: String;
    temp2: TStrDynAr;
    a: Integer;
begin
  Result:= '';
  for a:= 1 to Length(s) do begin
    if a > 1 then Result:= Result + ',';
    Result:= Result + IntToHex(Byte(s[a]), 2);
  end;
end;

//Saves Scene Text Project
//Scenario = True - creates additional info to be saved
function SceneProjectToString(sc: TScene; Lba: Byte;
  Scenario: Boolean = False): String;
var a: Integer;
begin
  StoreSpecificValues(sc, Lba);

  Result:= '[INFORMATION BEGIN]' + CR
         + 'File=Scene Text Project' + CR
         + 'Version=1.0' + CR
         + 'LBA=' + IntToStr(Lba) + CR
         + 'SceneName=' + 'Insert Scene Name Here' + CR
         + 'Grid=' + 'Insert Gird Name And Index Here' + CR
         + 'Library=' + 'Insert Library Name And Index Here' + CR
         + '[INFORMATION END]' + CR
         + CR
         + '[ENVIRONMENT BEGIN]' + CR
         + 'Unused1=' + IntToStr(sc.UnUsed1) + CR
         + 'Unused2=' + IntToStr(sc.UnUsed2) + CR;
  if Lba = 2 then
    Result:= Result + 'Unused3=' + IntToStr(sc.UnUsed3) + CR;
  Result:= Result  
         + 'TextBank=' + IntToStr(sc.TextBank) + CR
         + 'GameOverScene=' + IntToStr(sc.GameOverScene) + CR
         + 'AlphaLight=' + IntToStr(sc.AlphaLight) + CR
         + 'BetaLight=' + IntToStr(sc.BetaLight) + CR
         + 'SndSample0=' + IntToStr(sc.SampleAmbience[0]) + CR
         + 'SndRepeat0=' + IntToStr(sc.SampleRepeat[0]) + CR
         + 'SndRound0=' + IntToStr(sc.SampleRound[0]) + CR
         + 'Lba2Amb40=' + IntToStr(sc.SampleUnknown1[0]) + CR
         + 'Lba2Amb50=' + IntToStr(sc.SampleUnknown2[0]) + CR
         + 'SndSample1=' + IntToStr(sc.SampleAmbience[1]) + CR
         + 'SndRepeat1=' + IntToStr(sc.SampleRepeat[1]) + CR
         + 'SndRound1=' + IntToStr(sc.SampleRound[1]) + CR
         + 'Lba2Amb41=' + IntToStr(sc.SampleUnknown1[1]) + CR
         + 'Lba2Amb51=' + IntToStr(sc.SampleUnknown2[1]) + CR
         + 'SndSample2=' + IntToStr(sc.SampleAmbience[2]) + CR
         + 'SndRepeat2=' + IntToStr(sc.SampleRepeat[2]) + CR
         + 'SndRound2=' + IntToStr(sc.SampleRound[2]) + CR
         + 'Lba2Amb42=' + IntToStr(sc.SampleUnknown1[2]) + CR
         + 'Lba2Amb52=' + IntToStr(sc.SampleUnknown2[2]) + CR
         + 'SndSample3=' + IntToStr(sc.SampleAmbience[3]) + CR
         + 'SndRepeat3=' + IntToStr(sc.SampleRepeat[3]) + CR
         + 'SndRound3=' + IntToStr(sc.SampleRound[3]) + CR
         + 'Lba2Amb43=' + IntToStr(sc.SampleUnknown1[3]) + CR
         + 'Lba2Amb53=' + IntToStr(sc.SampleUnknown2[3]) + CR
         + 'MinDelay=' + IntToStr(sc.MinDelay) + CR
         + 'MinDelayRnd=' + IntToStr(sc.MinDelayRnd) + CR
         + 'Music=' + IntToStr(sc.MusicIndex) + CR;
  if Lba = 2 then begin
    Result:= Result
         //the unknown value between Actors and Zones:
         + 'Unknown=' + IntToStr(Int64(sc.Unknown)) + CR
         //the unknown data at the end of binary Scene:
         + 'FinalData=' + StrToBinData(sc.UData) + CR;
  end;
  Result:= Result
         + '[ENVIRONMENT END]' + CR
         + CR
         + '[OBJECTS BEGIN]' + CR
         + 'ActorCount=' + IntToStr(Length(sc.Actors)) + CR
         + 'ZoneCount=' + IntToStr(Length(sc.Zones)) + CR
         + 'TrackCount=' + IntToStr(Length(sc.Points)) + CR
         + '[OBJECTS END]' + CR
         + CR
         + '[ACTOR 0 BEGIN]' + CR //The Hero
         + 'Name=' + Trim(sc.Actors[0].Name) + CR
         + 'X=' + IntToStr(sc.Actors[0].X) + CR
         + 'Y=' + IntToStr(sc.Actors[0].Y) + CR
         + 'Z=' + IntToStr(sc.Actors[0].Z) + CR
         + '[ACTOR 0 END]' + CR
         + '[TRACK SCRIPT 0 BEGIN]' + CR
         + Trim(sc.Actors[0].TrackScriptTxt) + CR
         + '[TRACK SCRIPT 0 END]' + CR
         + '[LIFE SCRIPT 0 BEGIN]' + CR
         + Trim(sc.Actors[0].LifeScriptTxt) + CR
         + '[LIFE SCRIPT 0 END]' + CR;

  for a:= 1 to High(sc.Actors) do begin
    Result:= Result
           + CR
           + '[ACTOR ' + IntToStr(a) + ' BEGIN]' + CR
           + 'Name=' + Trim(sc.Actors[a].Name) + CR
           + 'StaticFlags=' + IntToStr(sc.Actors[a].StaticFlags) + CR
           + 'Entity=' + IntToStr(sc.Actors[a].Entity) + CR
           + 'Body=' + IntToStr(sc.Actors[a].Body) + CR
           + 'Animation=' + IntToStr(sc.Actors[a].Anim) + CR
           + 'Sprite=' + IntToStr(sc.Actors[a].Sprite) + CR
           + 'X=' + IntToStr(sc.Actors[a].X) + CR
           + 'Y=' + IntToStr(sc.Actors[a].Y) + CR
           + 'Z=' + IntToStr(sc.Actors[a].Z) + CR
           + 'HitPower=' + IntToStr(sc.Actors[a].HitPower) + CR
           + 'BonusType=' + IntToStr(sc.Actors[a].BonusType) + CR
           + 'FacingAngle=' + IntToStr(sc.Actors[a].Angle) + CR
           + 'RotationSpd=' + IntToStr(sc.Actors[a].RotSpeed) + CR
           + 'Mode=' + IntToStr(sc.Actors[a].CtrlMode) + CR
           + 'ModeFlag=' + IntToStr(sc.Actors[a].CtrlUnk) + CR
           + 'CropLeft=' + IntToStr(sc.Actors[a].Info0) + CR
           + 'CropTop=' + IntToStr(sc.Actors[a].Info1) + CR
           + 'CropRight=' + IntToStr(sc.Actors[a].Info2) + CR
           + 'CropBottom=' + IntToStr(sc.Actors[a].Info3) + CR
           + 'BonusQuantity=' + IntToStr(sc.Actors[a].BonusAmount) + CR
           + 'TalkColour=' + IntToStr(sc.Actors[a].TalkColor) + CR
           + 'Armour=' + IntToStr(sc.Actors[a].Armour) + CR
           + 'LifePoints=' + IntToStr(sc.Actors[a].LifePoints) + CR;
    if Lba = 2 then begin
      Result:= Result
           + 'StaticFlags2=' + IntToStr(sc.Actors[a].Unknown) + CR
           + 'BodyFlag=' + IntToStr(sc.Actors[a].BodyAdd) + CR
           + 'Data=' + StrToBinData(sc.Actors[a].UData) + CR
    end;

    Result:= Result
           + '[ACTOR ' + IntToStr(a) + ' END]' + CR
           + '[TRACK SCRIPT ' + IntToStr(a) + ' BEGIN]' + CR
           + Trim(sc.Actors[a].TrackScriptTxt) + CR
           + '[TRACK SCRIPT ' + IntToStr(a) + ' END]' + CR
           + '[LIFE SCRIPT ' + IntToStr(a) + ' BEGIN]' + CR
           + Trim(sc.Actors[a].LifeScriptTxt) + CR
           + '[LIFE SCRIPT ' + IntToStr(a) + ' END]' + CR;
  end;

  Result:= Result + CR;

  for a:= 0 to High(sc.Zones) do begin
    Result:= Result
           + '[ZONE ' + IntToStr(a) + ' BEGIN]' + CR
           + 'Name=' + Trim(sc.Zones[a].Name) + CR
           + 'X0=' + IntToStr(sc.Zones[a].X1) + CR
           + 'Y0=' + IntToStr(sc.Zones[a].Y1) + CR
           + 'Z0=' + IntToStr(sc.Zones[a].Z1) + CR
           + 'X1=' + IntToStr(sc.Zones[a].X2) + CR
           + 'Y1=' + IntToStr(sc.Zones[a].Y2) + CR
           + 'Z1=' + IntToStr(sc.Zones[a].Z2) + CR
           + 'Type=' + IntToStr(sc.Zones[a].ZType) + CR
           + 'Snap=' + IntToStr(sc.Zones[a].Snap) + CR;
    if Lba = 1 then begin
      Result:= Result
           + 'Info0=' + IntToStr(sc.Zones[a].Info[0]) + CR
           + 'Info1=' + IntToStr(sc.Zones[a].Info[1]) + CR
           + 'Info2=' + IntToStr(sc.Zones[a].Info[2]) + CR
           + 'Info3=' + IntToStr(sc.Zones[a].Info[3]) + CR;
    end else begin
      Result:= Result
           + 'Info0=' + IntToStr(Int64(sc.Zones[a].Info[0])) + CR
           + 'Info1=' + IntToStr(Int64(sc.Zones[a].Info[1])) + CR
           + 'Info2=' + IntToStr(Int64(sc.Zones[a].Info[2])) + CR
           + 'Info3=' + IntToStr(Int64(sc.Zones[a].Info[3])) + CR
           + 'Info4=' + IntToStr(Int64(sc.Zones[a].Info[4])) + CR
           + 'Info5=' + IntToStr(Int64(sc.Zones[a].Info[5])) + CR
           + 'Info6=' + IntToStr(Int64(sc.Zones[a].Info[6])) + CR
           + 'Info7=' + IntToStr(Int64(sc.Zones[a].Info[7])) + CR;
    end;
    Result:= Result
           + IfThen(Scenario, 'FragName=' + sc.Zones[a].FragmentName + CR)
           + '[ZONE ' + IntToStr(a) + ' END]' + CR;
  end;

  Result:= Result + CR;

  for a:= 0 to High(sc.Points) do
    Result:= Result
           + '[TRACK ' + IntToStr(a) + ' BEGIN]' + CR
           + 'Name=' + Trim(sc.Points[a].Name) + CR
           + 'X=' + IntToStr(sc.Points[a].X) + CR
           + 'Y=' + IntToStr(sc.Points[a].Y) + CR
           + 'Z=' + IntToStr(sc.Points[a].Z) + CR
           + '[TRACK ' + IntToStr(a) + ' END]' + CR;
end;

Function CreateEmptyScene(): TScene;
var a: Integer;
begin
 Result.TextBank:= 0;
 Result.GameOverScene:= 0;

 Result.UnUsed1:= 0;
 Result.UnUsed2:= 0;

 Result.AlphaLight:= 0;
 Result.BetaLight:= 0;

 for a:= 0 to 3 do begin
   Result.SampleAmbience[a]:= -1;
   Result.SampleRepeat[a]:= -1;
   Result.SampleRound[a]:= -1;
 end;
 Result.MinDelay:= -1;
 Result.MinDelayRnd:= -1;

 Result.MusicIndex:= 0;

 SetLength(Result.Actors, 1);
 Result.Actors[0].X:= 0;
 Result.Actors[0].Y:= 0;
 Result.Actors[0].Z:= 0;

 Result.Actors[0].TrackScriptTxt:= 'END';
 Result.Actors[0].TrackScriptBin:= #0;
 Result.Actors[0].LifeScriptTxt:= 'END';
 Result.Actors[0].LifeScriptBin:= #0;

 Result.Actors[0].UndoRedoIndex:= 0;

 ComputeActorDispInfo(Result.Actors[0], 0);

 SetLength(Result.Zones, 0);
 SetLength(Result.Points, 0);
end;

procedure SaveScene(path: String; Index: Integer = -1);
var ext: String;
    VPack: TPackEntries;
    NewComp: Word;
begin
 ext:= LowerCase(ExtractFileExt(path));
 //Screen.Cursor:= crHourGlass;
 if ext = '.stp' then begin
   SaveStringToFile(SceneProjectToString(VScene, LBAMode), path);
 end
 else if fmScriptEd.CompileAllScripts(LbaMode, VScene) then begin  //binary form - Compile the Scripts first
   //Then we can save
   if (ext = '.ls1') or (ext = '.ls2') then begin
     SaveStringToFile(SceneToString(VScene, IfThen(ext = '.ls1', 1, 2)), path);
   end
   else if ext='.hqr' then begin
     VPack:= OpenPack(path);
     NewComp:= SOrgComp;
     If not TfmCompDlg.ShowDialog(IsBkg(path), NewComp, 'Scene') then begin
       Screen.Cursor:= crDefault;
       Exit;
     end;
     VPack[Index]:=
       PackEntry(SceneToString(VScene, IfThen(IsSceneLba2(path), 2, 1)), -1, NewComp);
     SOrgComp:= NewComp;
     SavePackToFile(VPack, path);
   end
   else Exit;
 end
 else begin
   if Application.MessageBox('There are errors in Actors'' Scripts, so they could not be compiled.'#13
                           + 'Thus the Scene cannot be saved in the binary form until the errors are corrected.'#13#13
                           + 'However, you can save the Scene as a Text Project (*.stp) to fix the errors later,'#13
                           + 'but text Scenes cannot be used in the game.'#13#13
                           + 'Do you want to see the error messages now?',
                           ProgramName, MB_ICONERROR + MB_YESNO)
     = IDYes then
     fmScriptEd.OpenScripts(0);
     fmScriptEd.lbMessagesDblClick(fmScriptEd.lbMessages);
   Exit;
 end;

 SetScenarioState(False);
 SceneModified:= False;
 fmMain.UpdateProgramName();
 //Screen.Cursor:= crDefault;
 SysUtils.Beep();
 PutMessage('Scene file successfully saved'); //93
 CurrentSceneFile:= path;
 Sett.General.LastSaveDir:= ExtractFilePath(path);
end;

function IsSceneLba2(path: String): Boolean;
begin
  If ExtIs(path, '.hqr') then
    Result:= OpenSingleEntry(path,0).RlSize = 4 //first entry size is 4 => LBA 2
  else
    Result:= ExtIs(path, '.ls2') or ExtIs(path, '.sc2');
end;

Function MsgType(id: Integer): TMessageType;
begin
 If (id >= 0) and (id <= MaxErrorId) then
    Result:= mtError
  else if (id >= MinWarningId) and (id <= MaxWarningId) then
    Result:= mtWarning
  else if (id >= MinInfoId) and (id <= MaxInfoId) then
    Result:= mtInfo
  else
    Result:= mtUnknown;
end;

function ErrorString(id: Integer): String;
begin
  case MsgType(id) of
    mtError: Result:= CompErrorString[id];
    mtWarning: Result:= CompWarningString[id];
    mtInfo: Result:= CompInfoString[id];
    else Result:= 'Unknown error';
  end;  
end;

Procedure AddMessage(var Msgs: TCompMessages; TrackScript: Boolean;
  Id, Actor, Line, PStart, Len: Integer; Add: ShortString = ''); overload;
var msh: Integer;
begin
 msh:= Length(Msgs);
 SetLength(Msgs, msh + 1);
 if TrackScript then Msgs[msh].oType:= moActorTrack
                else Msgs[msh].oType:= moActorLife;
 Msgs[msh].mType:= MsgType(Id);
 Msgs[msh].ObjId:= Actor;
 Msgs[msh].Line:= Line;
 Msgs[msh].PosStart:= PStart;
 Msgs[msh].PosEnd:= PStart + Len;
 Msgs[msh].Text:= MessageToString(TrackScript, Id, Actor, Line, Add);
end;

//This proc only calls the callback proc
Procedure AddMessage(Proc: TCompCallbackProc; TrackScript: Boolean;
  Id, Actor, Line, PStart, Len: Integer; Add: ShortString = ''); overload;
var temp: TCompMessage;
begin
 If Assigned(Proc) then begin
   if TrackScript then temp.oType:= moActorTrack
                  else temp.oType:= moActorLife;
   temp.mType:= MsgType(Id);
   temp.ObjId:= Actor;
   temp.Line:= Line;
   temp.PosStart:= PStart;
   temp.PosEnd:= PStart + Len;
   temp.Text:= MessageToString(TrackScript, Id, Actor, Line, Add);
   Proc(temp);
 end;  
end;

//This proc only calls the callback proc
Procedure AddMessage(Proc: TCompCallbackProc; TrackScript: Boolean;
  mType: TMessageType; Actor, Line, PStart, Len: Integer; Text: String); overload;
var temp: TCompMessage;
begin
 If Assigned(Proc) then begin
   if TrackScript then temp.oType:= moActorTrack
                  else temp.oType:= moActorLife;
   temp.mType:= mType;
   temp.ObjId:= Actor;
   temp.Line:= Line;
   temp.PosStart:= PStart;
   temp.PosEnd:= PStart + Len;
   temp.Text:= Text;
   Proc(temp);
 end;  
end;

//This proc only calls the callback proc
Procedure AddMessage(Proc: TCompCallbackProc; oType: TMsgObjType;
  mType: TMessageType; ObjId, AddId: Integer; Text: String); overload;
var temp: TCompMessage;
begin
 If Assigned(Proc) then begin
   temp.oType:= oType;
   temp.mType:= mType;
   temp.ObjId:= ObjId;
   temp.Text:= Text;
   Proc(temp);
 end;  
end;

function MessageToString(TrackScript: Boolean;
  Id, Actor, Line: Integer; Add: ShortString = ''): String;
var mType: TMessageType;
begin
 mType:= MsgType(Id);
 If mType = mtInfo then
   Result:= ErrorString(Id)
 else begin
   If mType = mtError then Result:= '[Error] '
                      else Result:= '[Warning] ';
   Result:= Result + 'Actor ' + IntToStr(Actor);
   If TrackScript then Result:= Result + ' Track Script '
                  else Result:= Result + ' Life Script ';
   Result:= Result + '(' + IntToStr(Line) + '): '
                   + Format(ErrorString(Id), [Add]);
 end;
end;

//This function checks various parts of the Scene (Actor Body IDs, Animation IDs,
//  Zone Fragment names, etc.) for containing valid values.
//TODO: Add other things to check.
function SceneCheckConsistency(Scene: TScene; Callback: TCompCallbackProc): Boolean;
var a, b: Integer;
begin
 Result:= True;
 for a:= 0 to High(Scene.Zones) do
   if (Scene.Zones[a].RealType = ztFragment) and (Scene.Zones[a].FragmentName <> '') then begin
     b:= FragmentNameIndex(Scene.Zones[a].FragmentName);
     if b < 0 then Result:= False;
     if b = -1 then
       AddMessage(Callback, moZone, mtWarning, a, 0,
         '[Warning] Zone ' + IntToStr(a) + ': Invalid Auto-fragment name, Auto-fragment will not be used')
     else if b = -2 then
       AddMessage(Callback, moZone, mtWarning, a, 0,
         '[Warning] Zone ' + IntToStr(a) + ': Main_Grid is not allowed for Auto-fragment, Auto-fragment will not be used');
   end;
end;

function FixCase(Text: String): String; //sets the case according to setting
begin
  if ScrSet.Decomp.UpperCase then
    Result:= Text
  else
    Result:= LowerCase(Text);  
end;

function CheckBadOpcode(cmd: TTransCommand; var Res: String): Boolean;
begin
  Result:= cmd.Error = derrBadOpcode;
  if Result then begin
    Res:= Res + ' //' + DecompErrorString[Ord(cmd.Error)];
    if cmd.Error = derrBadOpcode then
      Res:= Res + Format(' (code: 0x%.2X, expected: %s, offset: 0x%.4X)',
                  [cmd.Code, CmdTypeString[cmd.cType], cmd.Offset]);
    Res:= Res + CR;
  end;
end;

end.

