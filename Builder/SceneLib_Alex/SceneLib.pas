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

unit SceneLib;

interface

uses Windows, Classes, SysUtils;

// include type, vars, const, functions definitions for the entire lib
{$I SceneLibConst.inc}

var
  ConditionMode: Integer;
  //Indentation: array[0..255] of Char;
  LaspOpcode: Integer;
  ComportementOffsets: array[0..99,0..49] of SmallInt;
  IfElseOffsets: array[0..99,0..49,0..255] of SmallInt;
  OrIfOffsets: array[0..99,0..49,0..255] of SmallInt;
  TrackOffsets: array[0..99,0..255] of SmallInt;
  Debug: Boolean;

  // Functions declarations ------------------
  // -----------------------------------------

  // General routines ------------------------

  Function OpenSceneFile(path: String): TScene;
  Function OpenScene(data: TFileStream): TScene;      // LoadBinaryScene

  // String routines -------------------------

  Function ReadStrByte(d: String; pos: DWord): Byte;
  Function ReadStrStr(d: String; pos: DWord): String;

  Function ReadStrInt(d: String; pos: DWord): Integer;
  Procedure WriteStrInt(var d: String; pos, val: Integer);
  Function GetStrInt(val: Integer): ShortString;
  Function ReadStrWord(d: String; pos: DWord): Word;
  Procedure WriteStrWord(var d: String; pos, val: Integer);
  Function GetStrWord(val: Word): ShortString;

  // Decompilation routines ------------------

  Procedure ResolveTrackOffsets(BinaryScript: String; ActorNum: Integer);
  Function DecompileTrackScript(BinaryScript: String): String;

  Procedure ResolveLifeOffsets(BinaryScript: String; ActorNum: Integer);
  Function IndentScript(Indent:Integer):String;
  Function DecompileLifeScript(BinaryScript: String; Actor: Integer): String;


  // Compilation routines ------------------

implementation

  // include decompilation routines
  {$I SceneLibDecomp.inc}
  // include compilation routines
  //{$I SceneLibComp.inc}

  // #########################################################
  // ################# General routines ######################
  // #########################################################

  Function OpenSceneFile(path: String): TScene;
  var FStr: TFileStream;
  begin
    FStr:=TFileStream.Create(path,fmOpenRead);
    Result:=OpenScene(FStr);
    FStr.Free;
  end;
  
  Function OpenScene(data: TFileStream): TScene;
  var a,NumBytes,NumObjects: Integer;
      ScriptBuff: String;
  begin

    with data do begin
      NumBytes:=0;
      NumObjects:=0;

      Seek(0,soBeginning);

      // Start reading scene file
      Read(Result.IsleNumber,1);
      Read(Result.GameOverScene,1);

      Read(Result.UnUsed1,2);
      Read(Result.UnUsed2,2);

      Read(Result.AlphaLight,2);
      Read(Result.BetaLight,2);
      
      Read(Result.SampleAmbience1,2);
      Read(Result.SampleRepeat1,2);
      Read(Result.SampleRound1,2);
      Read(Result.SampleAmbience2,2);
      Read(Result.SampleRepeat2,2);
      Read(Result.SampleRound2,2);
      Read(Result.SampleAmbience3,2);
      Read(Result.SampleRepeat3,2);
      Read(Result.SampleRound3,2);
      Read(Result.SampleAmbience4,2);
      Read(Result.SampleRepeat4,2);
      Read(Result.SampleRound4,2);
      Read(Result.MinDelay,2);
      Read(Result.MinDelayRnd,2);
      
      Read(Result.MusicIndex,1);
      
      Read(Result.Hero.X,2);
      Read(Result.Hero.Y,2);
      Read(Result.Hero.Z,2);
      
      // Get Hero Track Script
      Read(NumBytes,2);
      SetLength(ScriptBuff,NumBytes);
      Read(ScriptBuff[1],NumBytes);
      Result.Hero.MoveScript:=ScriptBuff;
      ResolveTrackOffsets(ScriptBuff,0);
      
      // Get Hero Life Script
      Read(NumBytes,2);
      SetLength(ScriptBuff,NumBytes);
      Read(ScriptBuff[1],NumBytes);
      Result.Hero.LifeScript := ScriptBuff;
      ResolveLifeOffsets(ScriptBuff,0);

      // Read Actors
      Read(NumObjects,2);
      SetLength(Result.Actors,NumObjects-1); // -1 because we don't count the Hero
      
      for a:= 0 to NumObjects-2 do begin
        Read(Result.Actors[a].StaticFlags,2);
        Read(Result.Actors[a].Entity,2);
        Read(Result.Actors[a].Body,1);
        Read(Result.Actors[a].Animation,1);
        Read(Result.Actors[a].SpriteEntry,2);
        Read(Result.Actors[a].X,2);
        Read(Result.Actors[a].Y,2);
        Read(Result.Actors[a].Z,2);
        Read(Result.Actors[a].StrengthOfHit,1);
        Read(Result.Actors[a].BonusParameter,2);
        Read(Result.Actors[a].BetaAngle,2);
        Read(Result.Actors[a].SpeedRotation,2);
        Read(Result.Actors[a].ControlMode,2);
        Read(Result.Actors[a].Info0,2);
        Read(Result.Actors[a].Info1,2);
        Read(Result.Actors[a].Info2,2);
        Read(Result.Actors[a].Info3,2);
        Read(Result.Actors[a].BonusAmount,1);
        Read(Result.Actors[a].TalkColor,1);
        Read(Result.Actors[a].Armour,1);
        Read(Result.Actors[a].LifePoints,1);
        
        // Get Actor Track Script
        Read(NumBytes,2);
        SetLength(ScriptBuff,NumBytes);
        Read(ScriptBuff[1],NumBytes);
        Result.Actors[a].MoveScript:=ScriptBuff;
        ResolveTrackOffsets(ScriptBuff,a+1);

        // Get Actor Life Script
        Read(NumBytes,2);
        SetLength(ScriptBuff,NumBytes);
        Read(ScriptBuff[1],NumBytes);
        Result.Actors[a].LifeScript := ScriptBuff;
        ResolveLifeOffsets(ScriptBuff,a+1);
      end;
      
      // Read Zones
      Read(NumObjects,2);
      SetLength(Result.Zones,NumObjects);

      for a:= 0 to NumObjects-1 do begin
        Read(Result.Zones[a].X1,2);
        Read(Result.Zones[a].Y1,2);
        Read(Result.Zones[a].Z1,2);
        Read(Result.Zones[a].X2,2);
        Read(Result.Zones[a].Y2,2);
        Read(Result.Zones[a].Z2,2);
        Read(Result.Zones[a].ZoneType,2);
        Read(Result.Zones[a].Info0,2);
        Read(Result.Zones[a].Info1,2);
        Read(Result.Zones[a].Info2,2);
        Read(Result.Zones[a].Info3,2);
        Read(Result.Zones[a].Snap,2);
      end;

      // Read Tracks
      Read(NumObjects,2);
      SetLength(Result.Tracks,NumObjects);

      for a:= 0 to NumObjects-1 do begin
        Read(Result.Tracks[a].X,2);
        Read(Result.Tracks[a].Y,2);
        Read(Result.Tracks[a].Z,2);
      end;
    end;
    
    // Decomp Hero Track Script
    Result.Hero.MoveScript := DecompileTrackScript(Result.Hero.MoveScript);
    Result.Hero.LifeScript := DecompileLifeScript(Result.Hero.LifeScript,0);

    // Decomp Actors TRack Script
    for a:= 0 to High(Result.Actors) do begin
      Result.Actors[a].MoveScript := DecompileTrackScript(Result.Actors[a].MoveScript);
      Result.Actors[a].LifeScript := DecompileLifeScript(Result.Actors[a].LifeScript,a+1);
    end;

  end;


  Function ReadStrByte(d: String; pos: DWord): Byte;
  begin
    Result:=Byte(d[pos]);
  end;

  Function ReadStrStr(d: String; pos: DWord): String;
  var a: DWord;
  begin
    a:= 0;
    while d[pos+a] <> #0 do Inc(a); //same as a++ in C++
    Inc(a);
    // a less 1 because #0 byte will make a null terminated string
    Result:= Copy(d, pos, a-1);
  end;  

  // ------------------------------------------------------------
  // ######### DePack.pas String Read routines by Zink ##########
  // ------------------------------------------------------------

  Function ReadStrInt(d: String; pos: DWord): Integer;
  begin
    Result:=Byte(d[pos])+Byte(d[pos+1])*256+Byte(d[pos+2])*256*256+Byte(d[pos+3])*256*256*256;
  end;

  Procedure WriteStrInt(var d: String; pos, val: Integer);
  begin
    d[pos]  :=Char(LoByte(LoWord(val)));
    d[pos+1]:=Char(HiByte(LoWord(val)));
    d[pos+2]:=Char(LoByte(HiWord(val)));
    d[pos+3]:=Char(HiByte(HiWord(val)));
  end;

  Function GetStrInt(val: Integer): ShortString;
  begin
    Result:=Char(LoByte(LoWord(val)))+Char(HiByte(LoWord(val)))+Char(LoByte(HiWord(val)))+Char(HiByte(HiWord(val)));
  end;

  Function ReadStrWord(d: String; pos: DWord): Word;
  begin
    Result:=Byte(d[pos])+Byte(d[pos+1])*256;
  end;

  Procedure WriteStrWord(var d: String; pos, val: Integer);
  begin
    d[pos]  :=Char(LoByte(val));
    d[pos+1]:=Char(HiByte(val));
  end;

  Function GetStrWord(val: Word): ShortString;
  begin
    Result:=Char(LoByte(val))+Char(HiByte(val));
  end;

end.

