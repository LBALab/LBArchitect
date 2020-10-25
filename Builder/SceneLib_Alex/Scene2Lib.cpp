/*
-------------------------[ LBA Story Coder Source ]--------------------------
Copyright (C) 2004-2005
------------------------------[ SceneLib.cpp ]-------------------------------

Author: Alexandre Fontoura [alexfont]
Begin : Sun Nov 19 2005
Email : alexandrefontoura@oninetspeed.pt

-------------------------------[ GNU License ]-------------------------------

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

-----------------------------------------------------------------------------
*/

#include <vcl.h>
#include <assert.h>
#pragma hdrstop

#include "SceneLib.h"
#include "HQRLib.h"
#include "LBAStoryCoder_main.h"
#include "Commands.h"

//---------------------------------------------------------------------------

#pragma package(smart_init)
int conditionMode2;
char indentation2[256];
int lastopcode2;
short int comportementOffsets2[100][50];
short int trackOffsets2[100][256];
bool wrof2=false; // Write Offsets

extern int filesize;

char Track2List[][50] =
{
  "END",
  "NOP",
  "BODY",
  "ANIM",
  "GOTO_POINT",
  "WAIT_ANIM",
  "LOOP",
  "ANGLE",
  "POS_POINT",
  "LABEL",
  "GOTO",
  "STOP",
  "GOTO_SYM_POINT",
  "WAIT_NUM_ANIM",
  "SAMPLE",
  "GOTO_POINT_3D",
  "SPEED",
  "BACKGROUND",
  "WAIT_NUM_SECOND",
  "NO_BODY",
  "BETA",
  "OPEN_LEFT",
  "OPEN_RIGHT",
  "OPEN_UP",
  "OPEN_DOWN",
  "CLOSE",
  "WAIT_DOOR",
  "SAMPLE_RND",
  "SAMPLE_ALWAYS",
  "SAMPLE_STOP",
  "PLAY_ACF",
  "REPEAT_SAMPLE",
  "SIMPLE_SAMPLE",
  "FACE_TWINKEL",
  "ANGLE_RND",
  "REM",
  "WAIT_NUM_DIZIEME",
  "DO",
  "SPRITE",
  "WAIT_NUM_SECOND_RND",
  "AFF_TIMER",
  "SET_FRAME",
  "SET_FRAME_3DS",
  "SET_START_3DS",
  "SET_END_3DS",
  "START_ANIM_3DS",
  "STOP_ANIM_3DS",
  "WAIT_ANIM_3DS",
  "WAIT_FRAME_3DS",
  "WAIT_NB_DIZIEME_RND",
  "DECALAGE",
  "FREQUENCE",
  "VOLUME"
};

char Life2List[][50]=
{
  "END",
  "NOP",
  "SNIF",
  "OFFSET",
  "NEVERIF",
  "",
  "",
  "",
  "",
  "",
  "PALETTE",
  "RETURN",
  "IF",
  "SWIF",
  "ONEIF",
  "ELSE",
  "ENDIF",
  "BODY",
  "BODY_OBJ",
  "ANIM",
  "ANIM_OBJ",
  "SET_CAMERA",
  "CAMERA_CENTER",
  "SET_TRACK",
  "SET_TRACK_OBJ",
  "MESSAGE",
  "FALLABLE",
  "SET_DIR",
  "SET_DIR_OBJ",
  "CAM_FOLLOW",
  "COMPORTEMENT_HERO",
  "SET_VAR_CUBE",
  "COMPORTEMENT",
  "SET_COMPORTEMENT",
  "SET_COMPORTEMENT_OBJ",
  "END_COMPORTEMENT",
  "SET_VAR_GAME",
  "KILL_OBJ",
  "SUICIDE",
  "USE_ONE_LITTLE_KEY",
  "GIVE_GOLD_PIECES",
  "END_LIFE",
  "STOP_L_TRACK",
  "RESTORE_L_TRACK",
  "MESSAGE_OBJ",
  "INC_CHAPTER",
  "FOUND_OBJECT",
  "SET_DOOR_LEFT",
  "SET_DOOR_RIGHT",
  "SET_DOOR_UP",
  "SET_DOOR_DOWN",
  "GIVE_BONUS",
  "CHANGE_CUBE",
  "OBJ_COL",
  "BRICK_COL",
  "OR_IF", 
  "INVISIBLE",
  "SHADOW_OBJ",
  "POS_POINT",
  "SET_MAGIC_LEVEL",
  "SUB_MAGIC_POINT",
  "SET_LIFE_POINT_OBJ",
  "SUB_LIFE_POINT_OBJ",
  "HIT_OBJ",
  "PLAY_ACF",
  "ECLAIR",
  "INC_CLOVER_BOX",
  "SET_USED_INVENTORY",
  "ADD_CHOICE",
  "ASK_CHOICE",
  "INIT_BUGGY",
  "MEMO_ARDOISE",
  "SET_HOLO_POS",
  "CLR_HOLO_POS",
  "ADD_FUEL",
  "SUB_FUEL",
  "SET_GRM",
  "SET_CHANGE_CUBE",
  "MESSAGE_ZOE",
  "FULL_POINT",
  "BETA",
  "FADE_TO_PAL",
  "ACTION",
  "SET_FRAME",
  "SET_SPRITE",
  "SET_FRAME_3DS",
  "IMPACT_OBJ",
  "IMPACT_POINT",
  "ADD_MESSAGE",
  "BULLE",
  "NO_CHOC",
  "ASK_CHOICE_OBJ",
  "CINEMA_MODE",
  "SAVE_HERO",
  "RESTORE_HERO",
  "ANIM_SET",
  "PLUIE",
  "GAME_OVER",
  "THE_END",
  "ESCALATOR",
  "PLAY_MUSIC",
  "TRACK_TO_VAR_GAME",
  "VAR_GAME_TO_TRACK",
  "ANIM_TEXTURE",
  "ADD_MESSAGE_OBJ",
  "BRUTAL_EXIT",
  "REM",
  "ECHELLE",
  "SET_ARMURE",
  "SET_ARMURE_OBJ",
  "ADD_LIFE_POINT_OBJ",
  "STATE_INVENTORY",
  "AND_IF",
  "SWITCH",
  "OR_CASE",
  "CASE",
  "DEFAULT",
  "BREAK",
  "END_SWITCH",
  "SET_HIT_ZONE",
  "SAVE_COMPORTEMENT",
  "RESTORE_COMPORTEMENT",
  "SAMPLE",
  "SAMPLE_RND",
  "SAMPLE_ALWAYS",
  "SAMPLE_STOP",
  "REPEAT_SAMPLE",
  "BACKGROUND",
  "ADD_VAR_GAME",
  "SUB_VAR_GAME",
  "ADD_VAR_CUBE",
  "SUB_VAR_CUBE",
  "",
  "SET_RAIL",
  "INVERSE_BETA",
  "NO_BODY",
  "ADD_GOLD_PIECES",
  "STOP_L_TRACK_OBJ",
  "RESTORE_L_TRACK_OBJ",
  "SAVE_COMPORTEMENT_OBJ",
  "RESTORE_COMPORTEMENT_OBJ",
  "SPY",
  "DEBUG",
  "DEBUG_OBJ",
  "POPCORN",
  "FLOW_POINT",
  "FLOW_OBJ",
  "SET_ANIM_DIAL",
  "PCX",
  "END_MESSAGE",
  "END_MESSAGE_OBJ",
  "PARM_SAMPLE",
  "NEW_SAMPLE",
  "POS_OBJ_AROUND",
  "PCX_MESS_OBJ"
};

char Conditions2List[][50] = {
  "COL",               
  "COL_OBJ",  
  "DISTANCE", 
  "ZONE",     
  "ZONE_OBJ", 
  "BODY",           
  "BODY_OBJ",        
  "ANIM",           
  "ANIM_OBJ",        
  "L_TRACK",         
  "L_TRACK_OBJ",     
  "VAR_CUBE",    
  "CONE_VIEW",        
  "HIT_BY",           
  "ACTION",          
  "VAR_GAME",         
  "LIFE_POINT",       
  "LIFE_POINT_OBJ",    
  "NUM_LITTLE_KEYS",  
  "NUM_GOLD_PIECES",  
  "COMPORTEMENT_HERO",
  "CHAPTER",         
  "DISTANCE_3D",
  "MAGIC_LEVEL",    
  "MAGIC_POINT",      
  "USE_INVENTORY",    
  "CHOICE",         
  "FUEL",           
  "CARRY_BY",      
  "CDROM",
  "ECHELLE",
  "RND",
  "RAIL",
  "BETA",
  "BETA_OBJ",
  "CARRY_OBJ_BY",
  "ANGLE",
  "DISTANCE_MESSAGE",
  "HIT_OBJ_BY",
  "REAL_ANGLE",
  "DEMO",
  "COL_DECORS",
  "COL_DECORS_OBJ",
  "PROCESSOR",
  "OBJECT_DISPLAYED",
  "ANGLE_OBJ"
};

char Operators2List[][5] = {
  "==",
  ">",
  "<",
  ">=",
  "<=",
  "!="
};


// ZONES

/*
- 7 is for things like stairs
- 8 is hit zone (no idea what this is)
- 9 is for wagons
*/

//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
// BINARY SCENES #########
//------------------------

// ----------------
// - LOAD ROUTINES
// -------------------------------------------------------------------------

TScene loadBinaryScene2(char* fileName, int index)
{
   unsigned char* scenePtr;
   TScene Scene;
  // unsigned short int aux = 0;
   //int filesize;

   if(index != -1)
   {
      filesize = loadResource(fileName,index,&scenePtr);
      if(filesize == -1) // didn't find the file
        return Scene;
   }
   else
   {
      filesize = ResourceSize(fileName);
      FILE* sceneHandle = openResource(fileName);

      scenePtr = (unsigned char*)malloc(filesize);
      readResource(sceneHandle,(char*)scenePtr,filesize);
      closeResource(sceneHandle);

      if(filesize == -1) // didn't find the file
        return Scene;
   }

   if(scenePtr)
   {
        // resolveOffsets2(scenePtr);

        Scene.TextBank = *(scenePtr++);
        Scene.CubeEntry = *(scenePtr); scenePtr+=6; // recheck
        Scene.AlphaLight = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.BetaLight = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb0_1 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb0_2 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb0_3 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb0_4 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb0_5 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb1_1 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb1_2 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb1_3 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb1_4 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb1_5 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb2_1 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb2_2 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb2_3 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb2_4 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb2_5 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb3_1 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb3_2 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb3_3 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb3_4 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb3_5 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Second_Min = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Second_Ecart = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.CubeMusic = *(scenePtr++);

        Scene.Hero.X = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Hero.Y = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Hero.Z = *((unsigned short *)scenePtr); scenePtr+=2;

        //-----------------

        int heroTrackBytes = *((unsigned short *)scenePtr); scenePtr+=2;
        unsigned char * heroTrack = scenePtr;
        Scene.Hero.trackScript = decompTrack2Script(scenePtr);
  //      Scene.Hero.trackScript = "END";
        scenePtr += heroTrackBytes;

        //-----------------
        int heroLifeBytes = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Hero.lifeScript = decompLife2Script(scenePtr, heroLifeBytes, heroTrack);
//        Scene.Hero.lifeScript = "END";
        scenePtr += heroLifeBytes;

        Scene.numActors = *((unsigned short *)scenePtr); scenePtr+=2;

        for(int i=1; i < Scene.numActors; i++)
        {
            TActor Actor;
            strcpy(Actor.Name," ");
            Actor.staticFlag = *((unsigned short *)scenePtr); scenePtr+=2;
            Actor.unknown = *((unsigned short *)scenePtr); scenePtr+=2;
            Actor.Entity = *((unsigned short *)scenePtr); scenePtr+=2;
            Actor.Body = *((unsigned short *)scenePtr); scenePtr+=2; // <<--- RECHECK
            Actor.Animation = *(scenePtr++);
            Actor.SpriteEntry = *(scenePtr); scenePtr+=2;
            Actor.X = *((unsigned short *)scenePtr); scenePtr+=2;
            Actor.Y = *((unsigned short *)scenePtr); scenePtr+=2;
            Actor.Z = *((unsigned short *)scenePtr); scenePtr+=2;
            Actor.StrengthOfHit = *(scenePtr++);
            Actor.BonusParameter = *((unsigned short *)scenePtr); scenePtr+=2;
            Actor.Angle = *((unsigned short *)scenePtr); scenePtr+=2;
            Actor.SpeedRotation = *((unsigned short *)scenePtr); scenePtr+=2;
            Actor.Move = *((unsigned short *)scenePtr); scenePtr+=2;
            Actor.cropLeft = *((unsigned short *)scenePtr); scenePtr+=2;
            Actor.cropTop = *((unsigned short *)scenePtr); scenePtr+=2;
            Actor.cropRight = *((unsigned short *)scenePtr); scenePtr+=2;
            Actor.cropBottom = *((unsigned short *)scenePtr); scenePtr+=2;
            Actor.BonusAmount = *(scenePtr++);
            Actor.TalkColor = *(scenePtr++);
            Actor.Armour = *(scenePtr++);
            Actor.LifePoints = *(scenePtr++);

            int trackBytes = *((unsigned short *)scenePtr); scenePtr+=2;
 //           unsigned char * actorTrack = scenePtr;
            Actor.trackScript = decompTrack2Script(scenePtr);
 //           Actor.trackScript = "END";
            scenePtr += trackBytes;

            int lifeBytes = *((unsigned short *)scenePtr); scenePtr+=2;
//            Actor.lifeScript = decompLife2Script(scenePtr, lifeBytes, actorTrack);
            Actor.lifeScript = "END";
            scenePtr += lifeBytes;

            Scene.Actors.push_back(Actor);
        }

        scenePtr+=4;

        Scene.numZones = *((unsigned short *)scenePtr); scenePtr+=2;

        for(int i=0; i < Scene.numZones; i++)
        {
            TZone Zone;
            Zone.X0 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.unknown1 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Y0 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.unknown2 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Z0 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.unknown3 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.X1 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.unknown4 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Y1 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.unknown5 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Z1 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.unknown6 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Type = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.unknown7 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Info0 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.unknown8 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Info1 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.unknown9 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Info2 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.unknown10 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Info3 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.unknown11 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Info4 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.unknown12 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Info5 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.unknown13 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Info6 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.unknown14 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Snap = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.unknown15 = *((unsigned short *)scenePtr); scenePtr+=2;

            // CHECK THIS BETTER <------------------------
            if(Zone.X1==-32768)
            {
               Zone.X1 = 32767;
            }
            if(Zone.X0==-32768)
            {
               Zone.X0 = 32767;
            }

            Scene.Zones.push_back(Zone);
        }

        Scene.numTracks= *((unsigned short *)scenePtr); scenePtr+=2;

        for(int i=0; i < Scene.numTracks; i++)
        {
            TTrack Track;
            Track.Num = i;
            Track.X = *((unsigned short *)scenePtr); scenePtr+=2;
            Track.unknown1 = *((unsigned short *)scenePtr); scenePtr+=2;
            Track.Y = *((unsigned short *)scenePtr); scenePtr+=2;
            Track.unknown2 = *((unsigned short *)scenePtr); scenePtr+=2;
            Track.Z = *((unsigned short *)scenePtr); scenePtr+=2;
            Track.unknown3 = *((unsigned short *)scenePtr); scenePtr+=2;
            Scene.Tracks.push_back(Track);
        }


		// Other unknown data

   }
   return Scene;
}

char * decompTrack2Script(unsigned char *scriptPtr)
{
    int finish = 0;
    int size = 0;
    unsigned char opcode;
    char scriptbuff[256];
    char scriptbuff2[256];
    unsigned char * tempPtr = scriptPtr;
    char * ptr = (char *)malloc(1);
    *ptr = 0;

    do
    {
       opcode = *(scriptPtr++);

       if(wrof2){ // DEBUG
           sprintf(scriptbuff2,"%d: ", scriptPtr - tempPtr-1);
           size += strlen(scriptbuff2)+2;
           ptr = (char *)realloc(ptr,size);
           strcat(ptr,scriptbuff2);
       }

       switch (opcode)
       {
           case 0: // END
           {
               sprintf(scriptbuff,"END");
               finish = 1;
               break;
           }
           case 1: // NOP
           {
               sprintf(scriptbuff,"NOP");
               break;
           }
           case 2: // BODY
           {
               unsigned char body;
               body = *(unsigned char *) (scriptPtr);
               scriptPtr++;
               sprintf(scriptbuff,"BODY %d",body);
               break;
           }
           case 3: // ANIM
           {
               short int anim;
               anim = *(short int *) (scriptPtr);
               scriptPtr += 2;
               sprintf(scriptbuff,"ANIM %d", anim);
               break;
           }
           case 4: // GOTO_POINT
           {
               sprintf(scriptbuff,"GOTO_POINT %d",*(scriptPtr++));
               break;
           }
           case 5: // WAIT_ANIM
           {
               sprintf(scriptbuff,"WAIT_ANIM");
               break;
           }
           case 6: // LOOP
           {
               sprintf(scriptbuff,"LOOP");
               break;
           }
           case 7: // ANGLE
           {
               short int temp;
               temp = *(short int *) (scriptPtr);
               scriptPtr += 2;
               sprintf(scriptbuff,"ANGLE %d", temp);
               break;
           }
           case 8: // POS_POINT
           {
               sprintf(scriptbuff,"POS_POINT %d",*(scriptPtr++));
               break;
           }
           case 9: // LABEL
           {
               sprintf(scriptbuff,"LABEL %d",*(scriptPtr++));
               break;
           }
           case 10: // GOTO
           {
               short int temp;
               temp = *(short int *) (scriptPtr);
               scriptPtr += 2;
               temp = *(tempPtr + temp + 1);
               sprintf(scriptbuff,"GOTO %d",temp);
               break;
           }
           case 11: // STOP
           {
               sprintf(scriptbuff,"STOP");
               break;
           }
           case 12: // GOTO_SYM_POINT
           {
               sprintf(scriptbuff,"GOTO_SYM_POINT %d", *(scriptPtr++));
               break;
           }
           case 13: // WAIT_NUM_ANIM
           {
               sprintf(scriptbuff,"WAIT_NUM_ANIM %d",*(scriptPtr++));
               scriptPtr++; // dummy
               break;
           }
           case 14: // SAMPLE
           {
               short int temp;
               temp = *(short int *) (scriptPtr);
               scriptPtr += 2;
               sprintf(scriptbuff,"SAMPLE %d", temp);
               break;
           }
           case 15: // GOTO_POINT_3D
           {
               sprintf(scriptbuff,"GOTO_POINT_3D %d", *(scriptPtr++));
               break;
           }
           case 16: // SPEED
           {
               short int temp;
               temp = *(short int *) scriptPtr;
               scriptPtr += 2;
               sprintf(scriptbuff,"SPEED %d", temp);
               break;
           }
           case 17: // BACKGROUND
           {
               sprintf(scriptbuff,"BACKGROUND %d", *(scriptPtr++));
               break;
           }
           case 18: // WAIT_NUM_SECOND       < - RECHECK  #####################
           {
               /*short int temp1;
               short int temp2;  */
               unsigned char temp3;

               temp3 = *(unsigned char *) (scriptPtr++);
               /*temp1 = *(int *) (scriptPtr);
               scriptPtr += 2;

               temp2 = *(int *) (scriptPtr);
               scriptPtr += 2; */

               scriptPtr += 4;

               sprintf(scriptbuff,"WAIT_NUM_SECOND %d", temp3);
               break;
           }
           case 19: // NO_BODY
           {
               sprintf(scriptbuff,"NO_BODY");
               break;
           }
           case 20: // BETA
           {
               short int temp;
               temp = *(short int *) scriptPtr;
               scriptPtr += 2;
               sprintf(scriptbuff,"BETA %d", temp);
               break;
           }
           case 21: // OPEN_LEFT
           {
               short int temp;
               temp = *(short int *) (scriptPtr);
               scriptPtr += 2;
               sprintf(scriptbuff,"OPEN_LEFT %d", temp);
               break;
           }
           case 22: // OPEN_RIGHT
           {
               short int temp;
               temp = *(short int *) (scriptPtr);
               scriptPtr += 2;
               sprintf(scriptbuff,"OPEN_RIGHT %d", temp);
               break;
           }
           case 23: // OPEN_UP
           {
               short int temp;
               temp = *(short int *) (scriptPtr);
               scriptPtr += 2;
               sprintf(scriptbuff,"OPEN_UP %d", temp);
               break;
           }
           case 24: // OPEN_DOWN
           {
               short int temp;
               temp = *(short int *) (scriptPtr);
               scriptPtr += 2;
               sprintf(scriptbuff,"OPEN_DOWN %d", temp);
               break;
           }
           case 25: // CLOSE
           {
               sprintf(scriptbuff,"CLOSE");
               break;
           }
           case 26: // WAIT_DOOR
           {
               sprintf(scriptbuff,"WAIT_DOOR");
               break;
           }
           case 27: // SAMPLE_RND
           {
               short int temp;
               temp = *(short int *) scriptPtr;
               scriptPtr += 2;
               sprintf(scriptbuff,"SAMPLE_RND %d", temp);
               break;
           }
           case 28: // SAMPLE_ALWAYS
           {
               short int temp;
               temp = *(short int *) scriptPtr;
               scriptPtr += 2;
               sprintf(scriptbuff,"SAMPLE_ALWAYS %d", temp);
               break;
           }
           case 29: // SAMPLE_STOP
           {
               short int temp;
               temp = *(short int *) scriptPtr;
               scriptPtr += 2;
               sprintf(scriptbuff,"SAMPLE_STOP %d", temp);
               break;
           }
           case 30: // PLAY_ACF
           {
               sprintf(scriptbuff,"PLAY_ACF %s",scriptPtr);
               scriptPtr += strlen((char *) scriptPtr) + 1;
               break;
           }
           case 31: // REPEAT_SAMPLE
           {
               short int temp;
               temp = *(short int *) scriptPtr;
               scriptPtr += 2;
               sprintf(scriptbuff,"REPEAT_SAMPLE %d", temp);
               break;
           }
           case 32: // SIMPLE_SAMPLE
           {
               short int temp;
               temp = *(short int *) scriptPtr;
               scriptPtr += 2;
               sprintf(scriptbuff,"SIMPLE_SAMPLE %d", temp);
               break;
           }
           case 33: //FACE_TWINSEN
           {
    //           short int temp;
    //           temp = *(short int *) scriptPtr;
               scriptPtr += 2;
               sprintf(scriptbuff,"FACE_TWINSEN");
               break;
           }
           case 34: // ANGLE_RND
           {
               short int temp1;
               short int temp2;

               temp1 = *(short int *) scriptPtr;
               scriptPtr += 2;
               temp2 = *(short int *) scriptPtr;
               scriptPtr += 2;
               sprintf(scriptbuff,"ANGLE_RND %d %d", temp1, temp2);
               break;
           }
           case 35: // REM
           {
               sprintf(scriptbuff,"REM");
               break;
           }
           case 36: // WAIT_NUM_DIZIEME
           {
               unsigned char value;
               value = *(unsigned char *) (scriptPtr++);
               scriptPtr+=4;
               sprintf(scriptbuff,"WAIT_NUM_DIZIEME %d",value);
               break;
           }
           case 37: // DO
           {
               sprintf(scriptbuff,"DO");
               break;
           }
           case 38: // SPRITE
           {
               short int temp;
               temp = *(short int *) scriptPtr;
               scriptPtr += 2;
               sprintf(scriptbuff,"SPRITE %d",temp);
               break;
           }
           case 39: // WAIT_NUM_SECOND_RND
           {
               unsigned char value;
               value = *(unsigned char *) (scriptPtr++);
               scriptPtr+=4;
               sprintf(scriptbuff,"WAIT_NUM_SECOND_RND %d",value);
               break;
           }
           case 40: // AFF_TIMER
           {
               //unsigned char value;
               //value = *(unsigned char *) (scriptPtr++);
               //scriptPtr+=4;
               sprintf(scriptbuff,"AFF_TIMER");
               break;
           }
           case 41: // SET_FRAME
           {
               unsigned char frame;
               frame = *(unsigned char *) (scriptPtr++);
               sprintf(scriptbuff,"SET_FRAME %d",frame);
               break;
           }
           case 42: // SET_FRAME_3DS
           {
               unsigned char frame;
               frame = *(unsigned char *) (scriptPtr++);
               sprintf(scriptbuff,"SET_FRAME_3DS %d",frame);
               break;
           }
           case 43: // SET_START_3DS
           {
               unsigned char frame;
               frame = *(unsigned char *) (scriptPtr++);
               sprintf(scriptbuff,"SET_START_3DS %d",frame);
               break;
           }
           case 44: // SET_END_3DS
           {
               unsigned char frame;
               frame = *(unsigned char *) (scriptPtr++);
               sprintf(scriptbuff,"SET_END_3DS %d",frame);
               break;
           }
           case 45: // START_ANIM_3DS
           {
               unsigned char frame;
               frame = *(unsigned char *) (scriptPtr++);
               sprintf(scriptbuff,"START_ANIM_3DS %d",frame);
               break;
           }
           case 46: // STOP_ANIM_3DS
           {
               unsigned char frame;
               frame = *(unsigned char *) (scriptPtr++);
               sprintf(scriptbuff,"STOP_ANIM_3DS %d",frame);
               break;
           }
           case 47: // WAIT_ANIM_3DS
           {
               sprintf(scriptbuff,"WAIT_ANIM_3DS");
               break;
           }
           case 48: // WAIT_FRAME_3DS
           {
               sprintf(scriptbuff,"WAIT_FRAME_3DS");
               break;
           }
           case 49: // WAIT_NUM_DIZIEME_RND
           {
               unsigned char value;
               value = *(unsigned char *) (scriptPtr++);
               scriptPtr+=4;
               sprintf(scriptbuff,"WAIT_NUM_DIZIEME_RND %d",value);
               break;
           }
           case 50: // DECALAGE
           {
               unsigned char value;
               value = *(short int *) scriptPtr;
               scriptPtr+=2;
               sprintf(scriptbuff,"DECALAGE %d",value);
               break;
           }
           case 51: // FREQUENCE
           {
               short int value;
               value = *(short int *) scriptPtr;
               scriptPtr+=2;
               sprintf(scriptbuff,"FREQUENCE %d",value);
               break;
           }
           case 52: // VOLUME
           {
               unsigned char value;
               value = *(unsigned char *) scriptPtr;
               scriptPtr++;
               sprintf(scriptbuff,"VOLUME %d",value);
               break;
           }

           default:
           {
               sprintf(scriptbuff,"UNK_OPCODE_%d", opcode);
               //finish = 1;
               break;
           }
       }
       size += strlen(scriptbuff)+2;
       ptr = (char *)realloc(ptr,size);
       strcat(ptr,scriptbuff);
       strcat(ptr,"\n");
   }
   while (!finish);
   return ptr;
}

void decompConditions2(unsigned char **scriptPtr, char *buffer)
{
    unsigned char opcode;
    char buffer2[256];

    opcode = **(scriptPtr);

    *(scriptPtr) = (*(scriptPtr)) + 1;

    conditionMode2 = 0;

    switch (opcode)
    {
        case 0:
        {
            strcat(buffer, "COL");
            break;
        }
        case 1:
        {
            char temp;

            temp = **scriptPtr;
            *(scriptPtr) = (*(scriptPtr)) + 1;

            sprintf(buffer2, "COL_OBJ %d", temp);
            strcat(buffer, buffer2);
            break;
        }
        case 2:
        {
            char temp;

            temp = **scriptPtr;
            *(scriptPtr) = (*(scriptPtr)) + 1;

            sprintf(buffer2, "DISTANCE %d", temp);
            strcat(buffer, buffer2);
            conditionMode2 = 1;
            break;
        }
        case 3:
        {
            strcat(buffer, "ZONE");
            break;
        }
        case 4:
        {
            char temp;

            temp = **scriptPtr;
            *(scriptPtr) = (*(scriptPtr)) + 1;

            sprintf(buffer2, "ZONE_OBJ %d", temp);
            strcat(buffer, buffer2);
            break;
        }
        case 5:
        {
            strcat(buffer, "BODY");
            break;
        }
        case 6:
        {
            char temp;

            temp = **scriptPtr;
            *(scriptPtr) = (*(scriptPtr)) + 1;

            sprintf(buffer2, "BODY_OBJ %d", temp);
            strcat(buffer, buffer2);
            break;
        }
        case 7:
        {
            strcat(buffer, "ANIM");
            break;
        }
        case 8:
        {
            char temp;

            temp = **scriptPtr;
            *(scriptPtr) = (*(scriptPtr)) + 1;

            sprintf(buffer2, "ANIM_OBJ %d", temp);
            strcat(buffer, buffer2);
            break;
        }
        case 9:
        {
            strcat(buffer, "L_TRACK");
            break;
        }
        case 10:
        {
            char temp;

            temp = **scriptPtr;
            *(scriptPtr) = (*(scriptPtr)) + 1;

            sprintf(buffer2, "L_TRACK %d", temp);
            strcat(buffer, buffer2);
            break;
        }
        case 11:
        {
            char temp;

            temp = **scriptPtr;
            *(scriptPtr) = (*(scriptPtr)) + 1;
            sprintf(buffer2, "FLAG_CUBE %d", temp);
            strcat(buffer, buffer2);
            break;
        }
        case 12:
        {
            char temp;

            temp = **scriptPtr;
            *(scriptPtr) = (*(scriptPtr)) + 1;

            sprintf(buffer2, "CONE_VIEW %d", temp);
            strcat(buffer, buffer2);
            conditionMode2 = 1;
            break;
        }
        case 13:
        {
            strcat(buffer, "HIT_BY");
            break;
        }
        case 14:
        {
            strcat(buffer, "ACTION");
            break;
        }
        case 15:
        {
            sprintf(buffer2, "FLAG_GAME %d", *((short int *) (*scriptPtr)));
            *(scriptPtr) = (*(scriptPtr)) + 2;
            strcat(buffer, buffer2);
            conditionMode2 = 1;
            break;
        }
        case 16:
        {
            strcat(buffer, "LIFE_POINT");
            break;
        }
        case 17:
        {
            char temp;

            temp = **scriptPtr;
            *(scriptPtr) = (*(scriptPtr)) + 1;

            sprintf(buffer2, "LIFE_POINT_OBJ %d", temp);
            strcat(buffer, buffer2);
            break;
        }
        case 18:
        {
            strcat(buffer, "NB_LITTLE_KEYS");
            break;
        }
        case 19:
        {
            strcat(buffer, "NB_GOLD_PIECES");
            conditionMode2 = 1;
            break;
        }
        case 20:
        {
            strcat(buffer, "COMPORTEMENT_HERO");
            break;
        }
        case 21:
        {
            strcat(buffer, "CHAPTER");
            break;
        }
        case 22:
        {
            char temp;

            temp = **(scriptPtr);

            *(scriptPtr) = (*(scriptPtr)) + 1;

            sprintf(buffer2, "DISTANCE_3D %d", temp);
            strcat(buffer, buffer2);
            conditionMode2 = 1;
            break;
        }
        /*
        23 .. 24 unused
        */
        case 25:
        {
            char temp;

            temp = **(scriptPtr);

            *(scriptPtr) = (*(scriptPtr)) + 1;

            sprintf(buffer2, "USE_INVENTORY %d", temp);
            strcat(buffer, buffer2);
            break;
        }
        case 26:
        {
            strcat(buffer, "CHOICE");
            conditionMode2 = 1;
            break;
        }
        case 27:
        {
            strcat(buffer, "FUEL");
            break;
        }
        default:
        {
            printf("Unsupported condition: %d\n", opcode);
            exit(1);
        }
    }
}

void decompOperators2(unsigned char **scriptPtr, char *buffer)
{
    unsigned char opcode;
    int opcode2;
    char buffer2[256];

    opcode = **(scriptPtr);
    *(scriptPtr) = (*(scriptPtr)) + 1;

    switch(conditionMode2)
    {
        case 0:
        {
            opcode2 = **scriptPtr;
            *(scriptPtr) = (*(scriptPtr)) + 1;
            break;
        }
        case 1:
        {
            opcode2 = *((short int *) (*scriptPtr));
            *(scriptPtr) = (*(scriptPtr)) + 2;
            break;
        }
        default:
        {
            printf("Operator Error!\n");
            exit(1);
            break;
        }
    }

    switch (opcode)
    {
        case 0: // Equal to
        {
            sprintf(buffer2, " == %d", opcode2);
            strcat(buffer, buffer2);
            break;
        }
        case 1: // Greater Than
        {
            sprintf(buffer2, " > %d", opcode2);
            strcat(buffer, buffer2);
            break;
        }
        case 2: // Less Than
        {
            sprintf(buffer2, " < %d", opcode2);
            strcat(buffer, buffer2);
            break;
        }
        case 3: // Greater Than Or Equal To
        {
            sprintf(buffer2, " >= %d", opcode2);
            strcat(buffer, buffer2);
            break;
        }
        case 4: // Less Than Or Equal To
        {
            sprintf(buffer2, " <= %d", opcode2);
            strcat(buffer, buffer2);
            break;
        }
        case 5: // Not equal to
        {
            sprintf(buffer2, " != %d", opcode2);
            strcat(buffer, buffer2);
            break;
        }
        default:
        {
            printf("doCalc default: %d\n", opcode);
            exit(1);
            break;
        }
    }
}

void resolveOffsets2(unsigned char * scenePtr)
{
   // short int offset=0;
    unsigned char opcode;
    unsigned short temp;

    scenePtr += 62; // Hero Track Script Offset
    temp = *((unsigned short *)scenePtr);
    scenePtr+=2;
    setTrack2ObjectIndex(0,temp,scenePtr);
    scenePtr += temp;

    temp = *((unsigned short *)scenePtr); // Hero Life Script Offset
    scenePtr+=2;
    setComportement2ObjectIndex(0,temp,scenePtr);
    scenePtr += temp;

    int numActors = *((unsigned short *)scenePtr);
    scenePtr += 2;

    for(int a=1; a<numActors; a++)
    {
        scenePtr += 38;
        temp = *((unsigned short *)scenePtr);
        scenePtr+=2;
        setTrack2ObjectIndex(a,temp,scenePtr);
        scenePtr += temp;

        temp = *((unsigned short *)scenePtr);
        scenePtr+=2;
        setComportement2ObjectIndex(a,temp,scenePtr);
        scenePtr += temp;
    }
}

void setComportement2ObjectIndex(int numActor, unsigned short numBytes, unsigned char * ptr)
{
    short int offset=0;
    unsigned char tempOp;
    int numComp=1;

    comportementOffsets2[numActor][0] = 0;

    for(int a=numBytes; a > 1; a--){
        tempOp = *(ptr+offset);
        if(tempOp == 35)
        {
            comportementOffsets2[numActor][numComp] = offset+1;
            numComp++;
        }
        offset++;
    }
}

void setTrack2ObjectIndex(int numActor, unsigned short numBytes, unsigned char * ptr)
{
    short int offset=0;
    unsigned char tempOp;
    int numTracks=0;
    int temp;

    for(int a=numBytes; a > 1; a--){
        tempOp = *(ptr+offset);

        if(tempOp == 9)
        {
            temp = *(ptr+offset+1);
            trackOffsets2[numActor][temp] = offset;
            numTracks++;
        }
        offset++;
    }
}

int getComportement2Index(short int comportement[50], short int offset)
{
    for(int a=0; a < 50; a++)
    {
        if(comportement[a]==offset)
            return a;
    }
    return -1;
}

int getComportement2ObjectIndex(short int offset, int numActor)
{
    for(int a=0; a < 50; a++)
    {
        if(comportementOffsets2[numActor][a]==offset)
            return a;
    }
    return -1;
}

int getTrack2ObjectIndex(short int offset, int numActor)
{
    for(int a=0; a < 255; a++)
    {
        if(trackOffsets2[numActor][a]==offset)
            return a;
    }
    return -1;
}

void indentScript2(unsigned short indent){
   if(indent >= 1)
       for(int i=0; i < indent; i++){
           if(i==0)
                sprintf(indentation2, "  ");
           else  
                strcat(indentation2, "  ");
       }
   else
        sprintf(indentation2, "");
}

char * decompLife2Script(unsigned char *scriptPtr, int lifeBytes, unsigned char *trackPtr)
{
    unsigned short indent;
    unsigned short indentOffsets[500];
    signed short indentIndex2=0;
    unsigned short indentOffsets2[500];
    signed short indentIndex=0;
    unsigned short currentOffset=0;

    int size = 0;
    unsigned char opcode;
    char scriptbuff[256];
    char scriptbuff2[256];
    bool endComportement = false;
    bool finish = false;
    int currentComportement = 0;
    unsigned char * tempPtr = scriptPtr;
    unsigned char * trackPtr2 = trackPtr;
    char * ptr = (char *)malloc(1);
    *ptr = 0;


    // Reverse comportement offset  ----------------------
    // ------------------------------
    short int offset=1;
    unsigned char tempOp;
    short int comportement[50];
    int numComp=1;
    comportement[0]=0; // first offset its comportement 0
    for(int a=lifeBytes; a > 1; a--){
        tempOp = *(scriptPtr+offset);
        if(tempOp == 35)
        {
            comportement[numComp] = offset+1;
            numComp++;
        }
        offset++;
    }
    // END of Reverse comportement offset
    // ----------------------------------------------------

    do
    {
        endComportement = false;

        if(*scriptPtr != 0)
        {
            if(wrof2){ // DEBUG
                sprintf(scriptbuff2,"%d: ", scriptPtr - tempPtr);
                size += strlen(scriptbuff2)+2;
                ptr = (char *)realloc(ptr,size);
                strcat(ptr,scriptbuff2);
            }
            sprintf(scriptbuff, "COMPORTEMENT %d", currentComportement);
            size += strlen(scriptbuff)+2;
            ptr = (char *)realloc(ptr,size);
            strcat(ptr,scriptbuff);
            strcat(ptr,"\n");
            indent = 1;
        }

        do
        {
            opcode = *(scriptPtr++);

            if(opcode==35)
                indent=0;
            else if(opcode==0)
                indent=0;
            else if(opcode==15)
                indent--;

            indentScript(indent);

            if(wrof2){ // DEBUG
                sprintf(scriptbuff2,"%d: ", scriptPtr - tempPtr-1);
                size += strlen(scriptbuff2)+2;
                ptr = (char *)realloc(ptr,size);
                strcat(ptr,scriptbuff2);
            }

            switch (opcode)
            {
                case 0:
                {
                    sprintf(scriptbuff, "END");
                    //finish = true;
                    endComportement = true;
                    break;
                }
                case 1:
                {
                    sprintf(scriptbuff, "NOP");
                    break;
                }
                case 2:
                {
                    indent++;
                    short int temp;

                    sprintf(scriptbuff, "SNIF ");

                    decompConditions(&scriptPtr, scriptbuff);
                    decompOperators(&scriptPtr, scriptbuff);

                    temp = *(short int *) scriptPtr;
                    scriptPtr += 2;

                    indentIndex++;
                    indentOffsets[indentIndex] = temp;

                    if(wrof2){
                        sprintf(scriptbuff2, " goto %d", temp);
                        strcat(scriptbuff, scriptbuff2);
                    }
                    break;
                }
                case 3:
                {
                    short int temp;

                    temp = *(short int *) scriptPtr;
                    scriptPtr += 2;

                    sprintf(scriptbuff, "OFFSET %d", temp);
                    break;
                }
                case 4:
                {
                    indent++;
                    short int temp;

                    sprintf(scriptbuff, "NEVERIF ");
                    decompConditions(&scriptPtr, scriptbuff);
                    decompOperators(&scriptPtr, scriptbuff);

                    temp = *(short int *) scriptPtr;
                    scriptPtr += 2;

                    indentIndex++;
                    indentOffsets[indentIndex] = temp;

                    if(wrof2){
                        sprintf(scriptbuff2, " goto %d", temp);
                        strcat(scriptbuff, scriptbuff2);
                    }
                    break;
                }
                case 10:
                {
                    sprintf(scriptbuff, "LABEL %d", *(scriptPtr++));
                    break;
                }
                case 11:
                {
                    sprintf(scriptbuff, "RETURN");
                    break;
                }
                case 12:
                {
                    indent++;
                    short int temp;

                    sprintf(scriptbuff, "IF ");
                    decompConditions(&scriptPtr, scriptbuff);
                    decompOperators(&scriptPtr, scriptbuff);

                    temp = *(short int *) scriptPtr;
                    scriptPtr += 2;

                    indentIndex++;
                    indentOffsets[indentIndex] = temp;

                    if(wrof2){
                        sprintf(scriptbuff2, " else goto %d", temp);
                        strcat(scriptbuff, scriptbuff2);
                    }
                    break;
                }
                case 13:
                {
                    indent++;
                    short int temp;

                    sprintf(scriptbuff, "SWIF ");
                    decompConditions(&scriptPtr, scriptbuff);
                    decompOperators(&scriptPtr, scriptbuff);

                    temp = *(short int *) scriptPtr;
                    scriptPtr += 2;

                    indentIndex++;
                    indentOffsets[indentIndex] = temp;

                    if(wrof2){
                        sprintf(scriptbuff2, " else goto %d", temp);
                        strcat(scriptbuff, scriptbuff2);
                    }
                    break;
                }
                case 14:
                {
                    indent++;
                    short int temp;

                    sprintf(scriptbuff, "ONEIF ");
                    decompConditions(&scriptPtr, scriptbuff);
                    decompOperators(&scriptPtr, scriptbuff);
                    temp = *(short int *) scriptPtr;
                    scriptPtr += 2;

                    indentIndex++;
                    indentOffsets[indentIndex] = temp;

                    if(wrof2){
                        sprintf(scriptbuff2, " else goto %d", temp);
                        strcat(scriptbuff, scriptbuff2);
                    }
                    break;
                }
                case 15:
                {
                    indent++;
                    short int temp;

                    temp = *(short int *) scriptPtr;

                    scriptPtr += 2;

                    sprintf(scriptbuff, "ELSE");

                    indentIndex2++;
                    indentOffsets2[indentIndex2] = temp;

                    if(wrof2){
                        sprintf(scriptbuff2, " %d", temp);
                        strcat(scriptbuff, scriptbuff2);
                    }
                    break;
                }
                case 17:
                {
                    sprintf(scriptbuff, "BODY %d", *(scriptPtr++));
                    break;
                }
                case 18:
                {
                    char temp1;
                    char temp2;

                    temp1 = *(scriptPtr++);
                    temp2 = *(scriptPtr++);

                    sprintf(scriptbuff, "BODY_OBJ %d %d", temp2, temp1);
                    break;
                }
                case 19:
                {
                    sprintf(scriptbuff, "ANIM %d", *(scriptPtr++));
                    break;
                }
                case 20:
                {
                    char temp1;
                    char temp2;

                    temp1 = *(scriptPtr++);
                    temp2 = *(scriptPtr++);

                    sprintf(scriptbuff, "ANIM_OBJ %d %d", temp2, temp1);
                    break;
                }
                case 21:
                {
                    /*short int temp;

                    temp = *(short int *) scriptPtr;
                    scriptPtr += 2;

                    sprintf(scriptbuff, "SET_LIFE %d", temp);
                    break;    */
                  //  currentOffset+=2;
                    short int offset;

                    offset = *(short int *) scriptPtr;
                    scriptPtr += 2;

                    sprintf(scriptbuff, "SET_LIFE %d", getComportementIndex(comportement, offset));
                    break;
                }
                case 22:
                {
                    char temp1;
                    short int temp2;

                    temp1 = *(scriptPtr++);

                    temp2 = *(short int *) scriptPtr;
                    scriptPtr += 2;

                    sprintf(scriptbuff, "SET_LIFE_OBJ %d %d", temp1, getComportementObjectIndex(temp2,temp1));// temp2);
                    break;
                }
                case 23:
                {
                    short int temp;

                    temp = *(short int *) scriptPtr;

                    scriptPtr += 2;

                    temp = *(trackPtr2 + temp + 1);

                    sprintf(scriptbuff, "SET_TRACK %d", temp);
                    break;
                }
                case 24:
                {
                    char temp1;
                    short int temp2;

                    temp1 = *(scriptPtr++);

                    temp2 = *(short int *) scriptPtr;
                    scriptPtr += 2;

                //    temp2 = *(trackPtr2 + temp2 + 1);

                    sprintf(scriptbuff, "SET_TRACK_OBJ %d %d", temp1, getTrackObjectIndex(temp2,temp1));
                    break;
                }
                case 25:
                {
                    short int temp;

                    temp = *(short int *) scriptPtr;

                    scriptPtr += 2;

                    sprintf(scriptbuff, "MESSAGE %d", temp);
                    break;
                }
                case 26:
                {
                    sprintf(scriptbuff, "FALLABLE %d", *(scriptPtr++));
                    break;
                }
                case 27:
                {
                    char temp;
                    char temp2;

                    temp = *scriptPtr++;

                    if (temp == 2)
                    {
                        temp2 = *scriptPtr++;
                        sprintf(scriptbuff, "SET_DIR %d follow %d", temp, temp2);
                    }
                    else
                    {
                        sprintf(scriptbuff, "SET_DIR %d", temp);
                    }
                    break;
                }
                case 28:
                {
                    char temp;
                    char temp2;
                    char temp3;

                    temp3 = *scriptPtr++;
                    temp = *scriptPtr++;

                    if (temp == 2)
                    {
                        temp2 = *scriptPtr++;
                        sprintf(scriptbuff, "SET_DIR_OBJ (actor %d) %d follow %d", temp3, temp, temp2);
                    }
                    else
                    {
                        sprintf(scriptbuff, "SET_DIR_OBJ (actor %d) %d", temp3, temp);
                    }
                    break;
                }
                case 29:
                {
                    sprintf(scriptbuff, "CAM_FOLLOW %d", *(scriptPtr++));
                    break;
                }
                case 30:
                {
                    sprintf(scriptbuff, "COMPORTEMENT_HERO %d", *(scriptPtr++));
                    break;
                }
                case 31:
                {
                    unsigned char temp1;
                    unsigned char temp2;

                    temp1 = *(scriptPtr++);
                    temp2 = *(scriptPtr++);

                    sprintf(scriptbuff, "SET_FLAG_CUBE %d %d", temp1, temp2);
                    break;
                }
                case 32:
                {
                    sprintf(scriptbuff, "COMPORTEMENT %d",*(scriptPtr++));
                    break;
                }
                case 33:
                {
                    short int offset;

                    offset = *(short int *) scriptPtr;
                    scriptPtr += 2;

                    sprintf(scriptbuff, "SET_COMPORTEMENT %d", getComportementIndex(comportement, offset));
                    break;
                }
                case 34:
                {
                    char temp1;
                    short int temp2;

                    temp1 = *(scriptPtr++);

                    temp2 = *(short int *) scriptPtr;
                    scriptPtr += 2;

                    sprintf(scriptbuff, "SET_COMPORTEMENT_OBJ %d %d", temp1, getComportementObjectIndex(temp2,temp1));//
                    break;
                }
                case 35:
                {
                    sprintf(scriptbuff, "END_COMPORTEMENT");
                    endComportement = true;
                    break;
                }
                case 36:
                {
                    unsigned char temp1;
                    char temp2;

                    temp1 = *(scriptPtr++);
                    temp2 = *(scriptPtr++);

                    sprintf(scriptbuff, "SET_FLAG_GAME %d %d", temp1, temp2);
                    break;
                }
                case 37:
                {
                    sprintf(scriptbuff, "KILL_OBJ %d", *(scriptPtr++));
                    break;
                }
                case 38:
                {
                    sprintf(scriptbuff, "SUICIDE");
                    break;
                }
                case 39:
                {
                    sprintf(scriptbuff, "USE_ONE_LITTLE_KEY");
                    break;
                }
                case 40:
                {
                    short int temp;

                    temp = *(short int *) scriptPtr;
                    scriptPtr += 2;

                    sprintf(scriptbuff, "GIVE_GOLD_PIECES %d", temp);
                    break;
                }
                case 41:
                {
                    sprintf(scriptbuff, "END_LIFE");
                    break;
                }
                case 42:
                {
                    sprintf(scriptbuff, "STOP_L_TRACK");
                    break;
                }
                case 43:
                {
                    sprintf(scriptbuff, "RESTORE_L_TRACK");
                    break;
                }
                case 44:
                {
                    char temp1;
                    short int temp2;

                    temp1 = *(scriptPtr++);
                    temp2 = *(short int *) (scriptPtr);
                    scriptPtr += 2;

                    sprintf(scriptbuff, "MESSAGE_OBJ %d %d", temp1, temp2);
                    break;
                }
                case 45:
                {
                    sprintf(scriptbuff, "INC_CHAPTER");
                    break;
                }
                case 46:
                {
                    sprintf(scriptbuff, "FOUND_OBJECT %d", *(scriptPtr++));
                    break;
                }
                case 47:
                {
                    short int temp;

                    temp = *(short int *) (scriptPtr);
                    scriptPtr += 2;

                    sprintf(scriptbuff, "SET_DOOR_LEFT %d", temp);
                    break;
                }
                case 48:
                {
                    short int temp;

                    temp = *(short int *) (scriptPtr);
                    scriptPtr += 2;

                    sprintf(scriptbuff, "SET_DOOR_RIGHT %d", temp);
                    break;
                }
                case 49:
                {
                    short int temp;

                    temp = *(short int *) (scriptPtr);
                    scriptPtr += 2;

                    sprintf(scriptbuff, "SET_DOOR_UP %d", temp);
                    break;
                }
                case 50:
                {
                    short int temp;

                    temp = *(short int *) (scriptPtr++);
                    scriptPtr += 2;

                    sprintf(scriptbuff, "SET_DOOR_DOWN %d", temp);
                    break;
                }
                case 51:
                {
                    sprintf(scriptbuff, "GIVE_BONUS %d", *(scriptPtr++));
                    break;
                }
                case 52:
                {
                    sprintf(scriptbuff, "CHANGE_CUBE %d", *(scriptPtr++));
                    break;
                }
                case 53:
                {
                    sprintf(scriptbuff, "OBJ_COL %d", *(scriptPtr++));
                    break;
                }
                case 54:
                {
                    sprintf(scriptbuff, "BRICK_COL %d", *(scriptPtr++));
                    break;
                }
                case 55:
                {
                    short int temp;

                    sprintf(scriptbuff, "OR_IF ");
                    decompConditions(&scriptPtr, scriptbuff);
                    decompOperators(&scriptPtr, scriptbuff);
                    temp = *(short int *) scriptPtr;
                    scriptPtr += 2;

                    if(wrof2){
                        sprintf(scriptbuff2, " goto %d", temp);
                        strcat(scriptbuff, scriptbuff2);
                    }
                    break;
                }
                case 56:
                {
                    sprintf(scriptbuff, "INVISIBLE %d", *(scriptPtr++));
                    break;
                }
                case 57:
                {
                    sprintf(scriptbuff, "ZOOM %d", *(scriptPtr++));
                    break;
                }
                case 58:
                {
                    sprintf(scriptbuff, "POS_POINT %d", *(scriptPtr++));
                    break;
                }
                case 59:
                {
                    sprintf(scriptbuff, "SET_MAGIC_LEVEL %d", *(scriptPtr++));
                    break;
                }
                case 60:
                {
                    sprintf(scriptbuff, "SUB_MAGIC_POINT %d", *(scriptPtr++));
                    break;
                }
                case 61:
                {
                    char temp1;
                    char temp2;

                    temp1 = *(scriptPtr++);
                    temp2 = *(scriptPtr++);

                    sprintf(scriptbuff, "SET_LIFE_POINT_OBJ %d %d", temp1, temp2);
                    break;
                }
                case 62:
                {
                    char temp1;
                    char temp2;

                    temp1 = *(scriptPtr++);
                    temp2 = *(scriptPtr++);

                    sprintf(scriptbuff, "SUB_LIFE_POINT_OBJ %d %d", temp1, temp2);
                    break;
                }
                case 63:
                {
                    char temp1;
                    char temp2;

                    temp1 = *(scriptPtr++);
                    temp2 = *(scriptPtr++);

                    sprintf(scriptbuff, "HIT_OBJ %d %d", temp1, temp2);
                    break;
                }
                case 64:
                {
                    int temp = strlen((char *) scriptPtr);

                    sprintf(scriptbuff, "PLAY_FLA %s", (char *) scriptPtr);

                    scriptPtr += temp + 1;
                    break;
                }
                case 65:
                {
                    sprintf(scriptbuff, "PLAY_MIDI %d", *(scriptPtr++));
                    break;
                }
                case 66:
                {
                    sprintf(scriptbuff, "INC_CLOVER_BOX");
                    break;
                }
                case 67:
                {
                    sprintf(scriptbuff, "SET_USED_INVENTORY %d", *(scriptPtr++));
                    break;
                }
                case 68:
                {
                    short int temp;

                    temp = *(short int *) (scriptPtr);

                    scriptPtr += 2;

                    sprintf(scriptbuff, "ADD_CHOICE %d", temp);
                    break;
                }
                case 69:
                {
                    short int temp;

                    temp = *(short int *) scriptPtr;

                    scriptPtr += 2;

                    sprintf(scriptbuff, "ASK_CHOICE %d", temp);
                    break;
                }
                case 70:
                {
                    short int temp;

                    temp = *(short int *) scriptPtr;

                    scriptPtr += 2;

                    sprintf(scriptbuff, "BIG_MESSAGE %d", temp);
                    break;
                }
                case 71:
                {
                    sprintf(scriptbuff, "INIT_PINGOUIN %d", *(scriptPtr++));
                    break;
                }
                case 72:
                {
                    sprintf(scriptbuff, "SET_HOLO_POS %d", *(scriptPtr++));
                    break;
                }
                case 73:
                {
                    sprintf(scriptbuff, "CLR_HOLO_POS %d", *(scriptPtr++));
                    break;
                }
                case 74:
                {
                    sprintf(scriptbuff, "ADD_FUEL %d", *(scriptPtr++));
                    break;
                }
                case 75:
                {
                    sprintf(scriptbuff, "SUB_FUEL%d", *(scriptPtr++));
                    break;
                }
                case 76:
                {
                    sprintf(scriptbuff, "SET_GRM %d", *(scriptPtr++));
                    break;
                }
                case 77:
                {
                    short int temp;

                    temp = *(short int *) scriptPtr;

                    scriptPtr += 2;

                    sprintf(scriptbuff, "SAY_MESSAGE %d", temp);
                    break;
                }
                case 78:
                {
                    char temp1;
                    short int temp2;

                    temp1 = *(scriptPtr++);
                    temp2 = *(short int *) scriptPtr;

                    scriptPtr += 2;

                    sprintf(scriptbuff, "SAY_MESSAGE_OBJ %d %d", temp1, temp2);
                    break;
                }
                case 79:
                {
                    sprintf(scriptbuff, "FULL_POINT");
                    break;
                }
                case 80:
                {
                     short int angle;

                    angle = *(short int *) scriptPtr;

                    scriptPtr += 2;

                    sprintf(scriptbuff, "BETA %d", angle);
                    break;
                }
                case 81:
                {
                    sprintf(scriptbuff, "GRM_OFF");
                    break;
                }
                case 82:
                {
                    sprintf(scriptbuff, "FADE_PAL_RED");
                    break;
                }
                case 83:
                {
                    sprintf(scriptbuff, "FADE_ALARM_RED");
                    break;
                }
                case 84:
                {
                    sprintf(scriptbuff, "FADE_ALARM_PAL");
                    break;
                }
                case 85:
                {
                    sprintf(scriptbuff, "FADE_RED_PAL");
            
                    break;
                }
                case 86:
                {
                    sprintf(scriptbuff, "FADE_RED_ALARM");
                    break;
                }
                case 87:
                {
                    sprintf(scriptbuff, "FADE_PAL_ALARM");
                    break;
                }
                case 88:
                {
                    char temp;

                    temp = *(scriptPtr++);

                    sprintf(scriptbuff, "EXPLODE_OBJ %d", temp);
                    break;
                }
                case 89:
                {
                    sprintf(scriptbuff, "BULLE_ON");
            
                    break;
                }
                case 90:
                {
                    sprintf(scriptbuff, "BULLE_OFF");
            
                    break;
                }
                case 91:
                {
                    char temp1;
                    short int temp2;

                    temp1 = *(scriptPtr++);
                    temp2 = *(short int *) scriptPtr;

                    scriptPtr += 2;
                    sprintf(scriptbuff, "ASK_CHOICE_OBJ %d %d", temp1, temp2);
                    break;
                }
                case 92:
                {
                    sprintf(scriptbuff, "SET_DARK_PAL");
                    break;
                }
                case 93:
                {
                    sprintf(scriptbuff, "SET_NORMAL_PAL");
                    break;
                }
                case 94:
                {
                    sprintf(scriptbuff, "MESSAGE_SENDELL");
                    break;
                }
                case 95:
                {
                    sprintf(scriptbuff, "ANIM_SET %d", *(scriptPtr++));
                    break;
                }
                case 96:
                {
                    sprintf(scriptbuff, "HOLOMAP_TRAJ %d", *(scriptPtr++));
                    break;
                }
                case 97:
                {
                    sprintf(scriptbuff, "GAME_OVER");
                    break;
                }
                case 98:
                {
                    sprintf(scriptbuff, "THE_END");
                    break;
                }
                case 99:
                {
                    sprintf(scriptbuff, "MIDI_OFF");
                    break;
                }
                case 100:
                {
                    sprintf(scriptbuff, "PLAY_CD_TRACK %d", *(scriptPtr++));
                    break;
                }
                case 101:
                {
                    sprintf(scriptbuff, "PROJ_ISO");
                    break;
                }
                case 102:
                {
                    sprintf(scriptbuff, "PROJ_3D");
                    break;
                }
                case 103:
                {
                    short int temp;

                    temp = *(short int *) scriptPtr;
                    scriptPtr += 2;

                    sprintf(scriptbuff, "TEXT %d", temp);
                    break;
                }
                case 104:
                {
                    sprintf(scriptbuff, "CLEAR_TEXT");
                    break;
                }
                case 105:
                {
                    sprintf(scriptbuff, "BRUTAL_EXIT");
                    break;
                }     
                default:
                {
                    sprintf(scriptbuff2, "Unknown opcode %d", opcode);
                    strcat(scriptbuff, scriptbuff2);
                    finish = true;
                    break;
                }
            }

            // Write script line in the pointer
            size += strlen(scriptbuff)+2+(indent*2);
            ptr = (char *)realloc(ptr,size);
            strcat(ptr,indentation2);
            strcat(ptr,scriptbuff);
            strcat(ptr,"\n");

            // get current script offset
            currentOffset = scriptPtr - tempPtr;

            // ENDIF block for other conditions  ::::: WORKING <----
            while(findOffset(indentIndex, indentOffsets, currentOffset)){

                if(indentIndex>0)
                    indentIndex--;
                else
                    indentIndex = 0;

                if(opcode!=15){
                        if(indent>0)
                            indent--;
                        else
                            indent = 0;

                        if(wrof2){ // DEBUG
                            sprintf(scriptbuff2,"%d: ", scriptPtr - tempPtr);
                            size += strlen(scriptbuff2)+2;
                            ptr = (char *)realloc(ptr,size);
                            strcat(ptr,scriptbuff2);
                        }

                        sprintf(scriptbuff2,"ENDIF\n");
                        size += strlen(scriptbuff2)+2+(indent*2);
                        ptr = (char *)realloc(ptr,size);
                        indentScript(indent);
                        strcat(ptr,indentation2);
                        strcat(ptr,scriptbuff2);
                }
            }

            // ENDIF block for ELSE      ::::: WORKING <----
            while(findOffset(indentIndex2, indentOffsets2, currentOffset)){
                if(indent>0)
                        indent--;
                    else
                        indent = 0;
                    if(indentIndex2>0)
                        indentIndex2--;
                    else
                        indentIndex2 = 0;

                    if(wrof2){ // DEBUG
                        sprintf(scriptbuff2,"%d: ", scriptPtr - tempPtr);
                        size += strlen(scriptbuff2)+2;
                        ptr = (char *)realloc(ptr,size);
                        strcat(ptr,scriptbuff2);
                    }

                    sprintf(scriptbuff2,"ENDIF\n");
                    size += strlen(scriptbuff2)+2+(indent*2);
                    ptr = (char *)realloc(ptr,size);
                    indentScript(indent);
                    strcat(ptr,indentation2);
                    strcat(ptr,scriptbuff2);
            }

        }while (!endComportement);

        currentComportement ++;

    }
    while (!finish);

    return ptr;
}

bool findOffset2(unsigned short indentIndex, unsigned short indentOffsets[500], unsigned short currentOffset)
{
    for(int a=0; a <= indentIndex; a++)
        if(indentOffsets[a] == currentOffset)
            return true;
    return false;
}

// ----------------
// - SAVE ROUTINES
// -------------------------------------------------------------------------

void saveBinaryScene2(TScene Scene, char* fileName)
{
   FILE* sceneHandle;
   unsigned short aux;
   TScript Script;

   sceneHandle = fopen(fileName, "wb+");
   fseek(sceneHandle, SEEK_SET, 0);

   fwrite(&Scene.TextBank,1,1,sceneHandle);
   fwrite(&Scene.CubeEntry,1,1,sceneHandle);
   aux=0;
   fwrite(&aux,1,1,sceneHandle);
   fwrite(&aux,1,1,sceneHandle);
   fwrite(&aux,1,1,sceneHandle);
   fwrite(&aux,1,1,sceneHandle);
   fwrite(&Scene.AlphaLight,2,1,sceneHandle);
   fwrite(&Scene.BetaLight,2,1,sceneHandle);

   fwrite(&Scene.Amb0_1,2,1,sceneHandle);
   fwrite(&Scene.Amb0_2,2,1,sceneHandle);
   fwrite(&Scene.Amb0_3,2,1,sceneHandle);
   fwrite(&Scene.Amb0_4,2,1,sceneHandle);
   fwrite(&Scene.Amb0_5,2,1,sceneHandle);
   fwrite(&Scene.Amb1_1,2,1,sceneHandle);
   fwrite(&Scene.Amb1_2,2,1,sceneHandle);
   fwrite(&Scene.Amb1_3,2,1,sceneHandle);
   fwrite(&Scene.Amb1_4,2,1,sceneHandle);
   fwrite(&Scene.Amb1_5,2,1,sceneHandle);
   fwrite(&Scene.Amb2_1,2,1,sceneHandle);
   fwrite(&Scene.Amb2_2,2,1,sceneHandle);
   fwrite(&Scene.Amb2_3,2,1,sceneHandle);
   fwrite(&Scene.Amb2_4,2,1,sceneHandle);
   fwrite(&Scene.Amb2_5,2,1,sceneHandle);
   fwrite(&Scene.Amb3_1,2,1,sceneHandle);
   fwrite(&Scene.Amb3_2,2,1,sceneHandle);
   fwrite(&Scene.Amb3_3,2,1,sceneHandle);
   fwrite(&Scene.Amb3_4,2,1,sceneHandle);
   fwrite(&Scene.Amb3_5,2,1,sceneHandle);

   fwrite(&Scene.Second_Min,2,1,sceneHandle);
   fwrite(&Scene.Second_Ecart,2,1,sceneHandle);

   fwrite(&Scene.CubeMusic,1,1,sceneHandle);

   fwrite(&Scene.Hero.X,2,1,sceneHandle);
   fwrite(&Scene.Hero.Y,2,1,sceneHandle);
   fwrite(&Scene.Hero.Z,2,1,sceneHandle);

   /*aux=1;
   fwrite(&aux,2,1,sceneHandle); // Track Offset Numbers
   aux=0;
   fwrite(&aux,1,1,sceneHandle); // Put END in the script   */

   compTrack2(Scene.Hero.trackScript, sceneHandle);

   aux=1;
   fwrite(&aux,2,1,sceneHandle); // Life Offset Numbers
   aux=0;
   fwrite(&aux,1,1,sceneHandle); // Put END in the script

   fwrite(&Scene.numActors,2,1,sceneHandle);

   for(int i=1; i < Scene.numActors; i++)
   {
       fwrite(&Scene.Actors[i-1].staticFlag,2,1,sceneHandle);
       fwrite(&Scene.Actors[i-1].Entity,2,1,sceneHandle);

       fwrite(&Scene.Actors[i-1].Body,1,1,sceneHandle);
       fwrite(&Scene.Actors[i-1].Animation,1,1,sceneHandle);

       fwrite(&Scene.Actors[i-1].SpriteEntry,2,1,sceneHandle);
       fwrite(&Scene.Actors[i-1].X,2,1,sceneHandle);
       fwrite(&Scene.Actors[i-1].Y,2,1,sceneHandle);
       fwrite(&Scene.Actors[i-1].Z,2,1,sceneHandle);

       fwrite(&Scene.Actors[i-1].StrengthOfHit,1,1,sceneHandle);

       fwrite(&Scene.Actors[i-1].BonusParameter,2,1,sceneHandle);
       fwrite(&Scene.Actors[i-1].Angle,2,1,sceneHandle);
       fwrite(&Scene.Actors[i-1].SpeedRotation,2,1,sceneHandle);
       fwrite(&Scene.Actors[i-1].Move,2,1,sceneHandle);
       fwrite(&Scene.Actors[i-1].cropLeft,2,1,sceneHandle);
       fwrite(&Scene.Actors[i-1].cropTop,2,1,sceneHandle);
       fwrite(&Scene.Actors[i-1].cropRight,2,1,sceneHandle);
       fwrite(&Scene.Actors[i-1].cropBottom,2,1,sceneHandle);

       fwrite(&Scene.Actors[i-1].BonusAmount,1,1,sceneHandle);
       fwrite(&Scene.Actors[i-1].TalkColor,1,1,sceneHandle);
       fwrite(&Scene.Actors[i-1].Armour,1,1,sceneHandle);
       fwrite(&Scene.Actors[i-1].LifePoints,1,1,sceneHandle);

       aux=1;
       fwrite(&aux,2,1,sceneHandle); // Track Offset Numbers
       aux=0;
       fwrite(&aux,1,1,sceneHandle); // Put END in the script

  //     compTrack2(Scene.Actors[i-1].trackScript, sceneHandle);

       aux=1;
       fwrite(&aux,2,1,sceneHandle); // Life Offset Numbers
       aux=0;
       fwrite(&aux,1,1,sceneHandle); // Put END in the script
   }

   fwrite(&Scene.numZones,2,1,sceneHandle);

   for(int i=0; i < Scene.numZones; i++)
   {
       fwrite(&Scene.Zones[i].X0,2,1,sceneHandle);
       fwrite(&Scene.Zones[i].Y0,2,1,sceneHandle);
       fwrite(&Scene.Zones[i].Z0,2,1,sceneHandle);
       fwrite(&Scene.Zones[i].X1,2,1,sceneHandle);
       fwrite(&Scene.Zones[i].Y1,2,1,sceneHandle);
       fwrite(&Scene.Zones[i].Z1,2,1,sceneHandle);

       fwrite(&Scene.Zones[i].Type,2,1,sceneHandle);
       fwrite(&Scene.Zones[i].Info0,2,1,sceneHandle);
       fwrite(&Scene.Zones[i].Info1,2,1,sceneHandle);
       fwrite(&Scene.Zones[i].Info2,2,1,sceneHandle);
       fwrite(&Scene.Zones[i].Info3,2,1,sceneHandle);
       fwrite(&Scene.Zones[i].Snap,2,1,sceneHandle);
   }

   fwrite(&Scene.numTracks,2,1,sceneHandle);

   for(int i=0; i < Scene.numTracks; i++)
   {
       fwrite(&Scene.Tracks[i].X,2,1,sceneHandle);
       fwrite(&Scene.Tracks[i].Y,2,1,sceneHandle);
       fwrite(&Scene.Tracks[i].Z,2,1,sceneHandle);
   }

   fclose(sceneHandle);
}

void compTrack2(char * script, FILE* sceneHandle)
{
    TScript track;
    int finish=0;
    int line=0;
    unsigned char opcode;
    char scriptbuffer[256];
    track.script = (unsigned char*)malloc(1);
    int currentOffset=0;

    *track.script = 0;
    track.numOffsets=0;

    do
    {
        getScriptLine(script,scriptbuffer,line);
        opcode = getTrackIndex(scriptbuffer);
        switch(opcode)
        {
            // Single Macros
            case 0:  // END
            case 1:  // NOP
            case 5:  // WAIT_ANIM
            case 11: // STOP
            case 19: // NO_BODY
            case 25: // CLOSE
            case 26: // WAIT_DOOR
            case 27: // SAMPLE_RND
                {
                    track.numOffsets++;
                    track.script=(unsigned char*)realloc((unsigned char*)track.script,track.numOffsets);
                    *(track.script+currentOffset) = (unsigned char)opcode;
                    if(opcode==0)
                        finish=1;
                    currentOffset++;
                    break;
                }
            // Macros with byte value
            case 4:  // GOTO_POINT
            case 6:  // LOOP
            case 8:  // POS_POINT
            case 9:  // LABEL
            case 10: // GOTO
            case 12: // GOTO_SYM_POINT
            case 15: // GOTO_POINT_3D
            case 17: // BACKGROUND
                {
                    track.numOffsets+=2;
                    track.script=(unsigned char*)realloc((unsigned char*)track.script,track.numOffsets);

                    Byte value;
                    AnsiString temp = Track2List[opcode];
                    temp+=" %d";
                    sscanf(scriptbuffer,temp.c_str(),&value);

                    /*if(line==0)
                        tmp = ptr+1;
                    else
                        tmp = ptr;

                    *tmp = opcode; *(tmp++) = value;  */

                    *(track.script+currentOffset) = (unsigned char)opcode;
                    *(track.script+currentOffset+1) = (unsigned char)value;
                    currentOffset+=2;
                    break;
                }

            //

        }
        line++;
    }while(!finish);
    
   fwrite(&track.numOffsets,2,1,sceneHandle);
   fwrite(track.script,track.numOffsets,1,sceneHandle);
}

int getTrack2Index(char* lineBuffer)
{
    int i;
    char buffer[256];
    char* ptr;

    strcpy(buffer,lineBuffer);

    ptr = strchr(buffer,' ');

    if(ptr)
    {
        *ptr = 0;
    }

    for(i=0;i<=(sizeof(Track2List)/34);i++)
    {
        if(strlen(Track2List[i]))
        {
            if(!strcmp(Track2List[i],buffer)){
                return i;
            }
        }
    }

    return -1;
}

void getScriptLine2(char* script,char* buffer, int line)
{
    int i;
    char* temp;

    for(i=0;i<line;i++)
    {
        script = strchr(script,0x0A)+1;
    }

    temp = strchr(script,0x0A);
    *temp = 0;

    strcpy(buffer,script);

    *temp = 0xA;
}

//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
// TEXT SCENES #########
//------------------------

// ----------------
// - Load Routines
// -------------------------------------------------------------------------

TScene loadTextScene2(char* fileName)
{
   TScene Scene;
   FILE * sceneHandle;
 //  unsigned short int aux = 0;
   char buffer[256];

   sceneHandle = fopen(fileName,"rt");

   assert(sceneHandle);

   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(!strcmp(buffer,"--> TEXT <--"));

   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(sscanf(buffer,"textBank: %d",&Scene.TextBank) == 1);

   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(!strcmp(buffer,"--> MAP_FILE <--"));

   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(sscanf(buffer,"cube: %d",&Scene.CubeEntry) == 1);

   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(!strcmp(buffer,"--> AMBIANCE <--"));

   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(sscanf(buffer,"AlphaLight: %d",&Scene.AlphaLight) == 1);
   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(sscanf(buffer,"BetaLight: %d",&Scene.BetaLight) == 1);

   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(sscanf(buffer,"amb0_1: %d",&Scene.Amb0_1) == 1);
   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(sscanf(buffer,"amb0_2: %d",&Scene.Amb0_2) == 1);
   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(sscanf(buffer,"amb0_3: %d",&Scene.Amb0_3) == 1);

   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(sscanf(buffer,"amb1_1: %d",&Scene.Amb1_1) == 1);
   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(sscanf(buffer,"amb1_2: %d",&Scene.Amb1_2) == 1);
   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(sscanf(buffer,"amb1_3: %d",&Scene.Amb1_3) == 1);

   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(sscanf(buffer,"amb2_1: %d",&Scene.Amb2_1) == 1);
   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(sscanf(buffer,"amb2_2: %d",&Scene.Amb2_2) == 1);
   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(sscanf(buffer,"amb2_3: %d",&Scene.Amb2_3) == 1);

   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(sscanf(buffer,"amb3_1: %d",&Scene.Amb3_1) == 1);
   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(sscanf(buffer,"amb3_2: %d",&Scene.Amb3_2) == 1);
   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(sscanf(buffer,"amb3_3: %d",&Scene.Amb3_3) == 1);

   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(sscanf(buffer,"Second_Min: %d",&Scene.Second_Min) == 1);
   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(sscanf(buffer,"Second_Ecart: %d",&Scene.Second_Ecart) == 1);

   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(sscanf(buffer,"Jingle: %d",&Scene.CubeMusic) == 1);

   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(!strcmp(buffer,"--> HERO_START <--"));

   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(sscanf(buffer,"X: %d",&Scene.Hero.X) == 1);
   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(sscanf(buffer,"Y: %d",&Scene.Hero.Y) == 1);
   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(sscanf(buffer,"Z: %d",&Scene.Hero.Z) == 1);

   Scene.Hero.trackScript = getTrack2Script(sceneHandle);
   Scene.Hero.lifeScript = getLife2Script(sceneHandle);

   //----------
   // Actors ----------------------------------------------------

   Scene.numActors = 1;

   while(1)
   {
       TActor Actor;
       char buffer2[256];
       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;

       sprintf(buffer2,"--> OBJECT %d <--", Scene.numActors);
       if(strcmp(buffer2,buffer))
           break;

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       sscanf(buffer,"Name: %s",Actor.Name);

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
      
       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"StaticFlags: %d",&Actor.staticFlag)==1);

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"File3D: %d",&Actor.Entity)==1);

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Body: %d",&Actor.Body)==1);

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Anim: %d",&Actor.Animation)==1);

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Sprite: %d",&Actor.SpriteEntry)==1);

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"X: %d",&Actor.X)==1);
       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Y: %d",&Actor.Y)==1);
       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Z: %d",&Actor.Z)==1);

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"HitForce: %d",&Actor.StrengthOfHit)==1);

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Bonus: %d",&Actor.BonusParameter)==1);

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Beta: %d",&Actor.Angle)==1);

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"SpeedRot: %d",&Actor.SpeedRotation)==1);

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Move: %d",&Actor.Move)==1);

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"CropLeft: %d",&Actor.cropLeft)==1);
       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"CropTop: %d",&Actor.cropTop)==1);
       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"CropRight: %d",&Actor.cropRight)==1);
       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"CropBottom: %d",&Actor.cropBottom)==1);

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"ExtraBonus: %d",&Actor.BonusAmount)==1);

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Color: %d",&Actor.TalkColor)==1);

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Armure: %d",&Actor.Armour)==1);

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"LifePoint: %d",&Actor.LifePoints)==1);

       Actor.trackScript = getTrack2Script(sceneHandle);
       Actor.lifeScript = getLife2Script(sceneHandle);

       Scene.Actors.push_back(Actor);
       Scene.numActors++;
   }

   //---------
   // Zones ----------------------------------------------------

   Scene.numZones = 0;

   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;

   while(!strcmp(buffer,"--> ZONE <--"))
   {
       TZone Zone;

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"X0: %d",&Zone.X0)==1);
       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Y0: %d",&Zone.Y0)==1);
       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Z0: %d",&Zone.Z0)==1);

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"X1: %d",&Zone.X1)==1);
       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Y1: %d",&Zone.Y1)==1);
       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Z1: %d",&Zone.Z1)==1);

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Type: %d",&Zone.Type)==1);

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Info0: %d",&Zone.Info0)==1);
       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Info1: %d",&Zone.Info1)==1);
       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Info2: %d",&Zone.Info2)==1);
       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Info3: %d",&Zone.Info3)==1);

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Snap: %d",&Zone.Snap)==1);

       Scene.numZones++;

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;

       Scene.Zones.push_back(Zone);
    }


   Scene.numTracks = 0;

   while(!strcmp(buffer,"--> TRACK <--"))
   {
       TTrack Track;
       int flagNum;

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"X: %d",&Track.X)==1);
       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Y: %d",&Track.Y)==1);
       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Z: %d",&Track.Z)==1);

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;
       assert(sscanf(buffer,"Num: %d",&Track.Num)==1);

       flagNum = Track.Num;

       assert(Scene.numTracks == flagNum);

       Scene.numTracks++;

       fgets(buffer,256,sceneHandle);
       *strchr(buffer,0xA) = 0;

       Scene.Tracks.push_back(Track);
   }
/*   if(IsConnected())
   {
       SetTrackCommand(Track);
       Sleep(300);
   }              */

   return Scene;
}

char* getTrack2Script(FILE* sceneHandle)
{
  /* int position = ftell(sceneHandle);
   int position2;  */
   int size = 0;
   char buffer[256];
   int numLine = 0;

   char* ptr = (char*)malloc(1);

   *ptr = 0;

   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(!strcmp(buffer,"--> TRACK_PROG <--"));

   while(1)
   {
       numLine++;
       fgets(buffer,256,sceneHandle);

       size+= strlen(buffer)+1;

       ptr = (char*)realloc(ptr,size);

       strcat(ptr,buffer);

       *strchr(buffer,0xA) = 0;
       if(!strcmp(buffer,"END"))
           break;
   }
   return ptr;
}

char* getLife2Script(FILE* sceneHandle)
{
  /* int position = ftell(sceneHandle);
   int position2;    */
   int size = 0;
   char buffer[256];
   int numLine = 0;

   char* ptr = (char*)malloc(1);

   *ptr = 0;

   fgets(buffer,256,sceneHandle);
   *strchr(buffer,0xA) = 0;
   assert(!strcmp(buffer,"--> LIFE_PROG <--"));

   while(1)
   {
       numLine++;
       fgets(buffer,256,sceneHandle);

       size+= strlen(buffer)+1;

       ptr = (char*)realloc(ptr,size);

       strcat(ptr,buffer);

       *strchr(buffer,0xA) = 0;
       if(!strcmp(buffer,"END"))
           break;
   }
   return ptr;
}

// ----------------
// - Save Routines
// -------------------------------------------------------------------------

void saveTextScene2(TScene Scene, char * fileName)
{
   char buffer[100000];

   FILE * sceneHandle;
   sceneHandle = fopen(fileName,"wt");

//   fseek(sceneHandle, SEEK_SET, 0);


   fputs("--> TEXT <--",sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"textBank: %d",Scene.TextBank);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   fputs("--> MAP_FILE <--",sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"cube: %d",Scene.CubeEntry);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   fputs("--> AMBIANCE <--",sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"AlphaLight: %d",Scene.AlphaLight);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"BetaLight: %d",Scene.BetaLight);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb0_1: %d",Scene.Amb0_1);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb0_2: %d",Scene.Amb0_2);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb0_3: %d",Scene.Amb0_3);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb0_4: %d",Scene.Amb0_4);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb0_5: %d",Scene.Amb0_5);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb1_1: %d",Scene.Amb1_1);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb1_2: %d",Scene.Amb1_2);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb1_3: %d",Scene.Amb1_3);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb1_4: %d",Scene.Amb1_4);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb1_5: %d",Scene.Amb1_5);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb2_1: %d",Scene.Amb2_1);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb2_2: %d",Scene.Amb2_2);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb2_3: %d",Scene.Amb2_3);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb2_4: %d",Scene.Amb2_4);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb2_5: %d",Scene.Amb2_5);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb3_1: %d",Scene.Amb3_1);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb3_2: %d",Scene.Amb3_2);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb3_3: %d",Scene.Amb3_3);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb3_4: %d",Scene.Amb3_4);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb3_5: %d",Scene.Amb3_5);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"Second_Min: %d",Scene.Second_Min);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"Second_Ecart: %d",Scene.Second_Ecart);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"Jingle: %d",Scene.CubeMusic);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   fputs("--> HERO_START <--",sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"X: %d",Scene.Hero.X);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);
   sprintf(buffer,"Y: %d",Scene.Hero.Y);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);
   sprintf(buffer,"Z: %d",Scene.Hero.Z);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   fputs("--> TRACK_PROG <--",sceneHandle);
   fputs("\n",sceneHandle);
   sprintf(buffer,Scene.Hero.trackScript);
   fputs(buffer,sceneHandle);

   fputs("--> LIFE_PROG <--",sceneHandle);
   fputs("\n",sceneHandle);
   sprintf(buffer,Scene.Hero.lifeScript);
   fputs(buffer,sceneHandle);

   //----------
   // Actors ----------------------------------------------------


   for(int a=0;a<Scene.numActors-1;a++)
   {
       sprintf(buffer,"--> OBJECT %d <--", a+1);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);

       sprintf(buffer,"Name: %s",Scene.Actors[a].Name);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);

       sprintf(buffer,"Num: %d",a+1);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);

       sprintf(buffer,"StaticFlags: %d",Scene.Actors[a].staticFlag);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);

       sprintf(buffer,"File3D: %d",Scene.Actors[a].Entity);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);

       sprintf(buffer,"Body: %d",Scene.Actors[a].Body);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);

       sprintf(buffer,"Anim: %d",Scene.Actors[a].Animation);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);

       sprintf(buffer,"Sprite: %d",Scene.Actors[a].SpriteEntry);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);

       sprintf(buffer,"X: %d",Scene.Actors[a].X);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);
       sprintf(buffer,"Y: %d",Scene.Actors[a].Y);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);
       sprintf(buffer,"Z: %d",Scene.Actors[a].Z);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);

       sprintf(buffer,"HitForce: %d",Scene.Actors[a].StrengthOfHit);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);

       sprintf(buffer,"Bonus: %d",Scene.Actors[a].BonusParameter);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);

       sprintf(buffer,"Beta: %d",Scene.Actors[a].Angle);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);

       sprintf(buffer,"SpeedRot: %d",Scene.Actors[a].SpeedRotation);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);

       sprintf(buffer,"Move: %d",Scene.Actors[a].Move);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);

       sprintf(buffer,"CropLeft: %d",Scene.Actors[a].cropLeft);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);
       sprintf(buffer,"CropTop: %d",Scene.Actors[a].cropTop);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);
       sprintf(buffer,"CropRight: %d",Scene.Actors[a].cropRight);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);
       sprintf(buffer,"CropBottom: %d",Scene.Actors[a].cropBottom);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);

       sprintf(buffer,"ExtraBonus: %d",Scene.Actors[a].BonusAmount);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);

       sprintf(buffer,"Color: %d",Scene.Actors[a].TalkColor);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);

       sprintf(buffer,"Armure: %d",Scene.Actors[a].Armour);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);

       sprintf(buffer,"LifePoint: %d",Scene.Actors[a].LifePoints);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);

       fputs("--> TRACK_PROG <--",sceneHandle);
       fputs("\n",sceneHandle);
       sprintf(buffer,Scene.Actors[a].trackScript);
       fputs(buffer,sceneHandle);
       fputs("--> LIFE_PROG <--",sceneHandle);
       fputs("\n",sceneHandle);
       sprintf(buffer,Scene.Actors[a].lifeScript);
       fputs(buffer,sceneHandle);
   }

   //---------
   // Zones ----------------------------------------------------

   fputs("--> VAR_CUBE <--\n",sceneHandle);

   for(int a=0; a < Scene.numZones; a++)
   {
       fputs("--> ZONE <--",sceneHandle);
       fputs("\n",sceneHandle);

       sprintf(buffer,"X0: %d",Scene.Zones[a].X0);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);
       sprintf(buffer,"Y0: %d",Scene.Zones[a].Y0);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);
       sprintf(buffer,"Z0: %d",Scene.Zones[a].Z0);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);

       sprintf(buffer,"X1: %d",Scene.Zones[a].X1);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);
       sprintf(buffer,"Y1: %d",Scene.Zones[a].Y1);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);
       sprintf(buffer,"Z1: %d",Scene.Zones[a].Z1);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);

       sprintf(buffer,"Type: %d",Scene.Zones[a].Type);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);
       sprintf(buffer,"Info0: %d",Scene.Zones[a].Info0);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);
       sprintf(buffer,"Info1: %d",Scene.Zones[a].Info1);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);
       sprintf(buffer,"Info2: %d",Scene.Zones[a].Info2);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);
       sprintf(buffer,"Info3: %d",Scene.Zones[a].Info3);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);

       sprintf(buffer,"Snap: %d",Scene.Zones[a].Snap);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);
   }
                     
   for(int a=0;a<Scene.numTracks;a++)
   {
       fputs("--> TRACK <--\n",sceneHandle);
       sprintf(buffer,"X: %d",Scene.Tracks[a].X);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);
       sprintf(buffer,"Y: %d",Scene.Tracks[a].Y);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);
       sprintf(buffer,"Z: %d",Scene.Tracks[a].Z);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);
       sprintf(buffer,"Num: %d",a);
       fputs(buffer,sceneHandle);
       fputs("\n",sceneHandle);
   }

   fputs("--> END <--\n",sceneHandle);

   fclose(sceneHandle);
}

