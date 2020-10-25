/*
-------------------------[ LBA Story Coder Source ]--------------------------
Copyright (C) 2004-2006
------------------------------[ SceneLib.cpp ]-------------------------------

Author: Alexandre Fontoura [alexfont]
Begin : Sun Aug 22 2004
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
#include <string.h>
#include <stdio.h>
#pragma hdrstop

#include "SceneLib.h"
#include "HQRLib.h"
#include "LBAStoryCoder_main.h"
#include "Commands.h"
#include "LBADePackLib.h"

//---------------------------------------------------------------------------

#pragma package(smart_init)

extern AnsiString bodyDescPath;
extern int filesize;
extern TLBARess Ress;

int conditionMode;
char indentation[256];
int lastopcode;
short int comportementOffsets[100][50];
short int ifelseOffsets[100][25][256];
short int orifOffsets[100][25][256];
short int trackOffsets[100][256];
bool wrof=false; // Write Offsets
//bool wrof=true; // Write Offsets

char TrackList [][50] =
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
  "PLAY_FLA",
  "REPEAT_SAMPLE",
  "SIMPLE_SAMPLE",
  "FACE_TWINKEL",
  "ANGLE_RND"
};

char LifeList[][50]=
{
  "END", // 0
  "NOP",
  "SNIF",
  "OFFSET",
  "NEVERIF",
  "", //5
  "NO_IF",
  "",
  "",
  "",
  "LABEL", // 10
  "RETURN",
  "IF",
  "SWIF",
  "ONEIF",
  "ELSE", // 15
  "ENDIF",
  "BODY",
  "BODY_OBJ",
  "ANIM",
  "ANIM_OBJ", // 20
  "SET_LIFE",
  "SET_LIFE_OBJ",
  "SET_TRACK",
  "SET_TRACK_OBJ",
  "MESSAGE", // 25
  "FALLABLE",
  "SET_DIR",
  "SET_DIR_OBJ",
  "CAM_FOLLOW",
  "COMPORTEMENT_HERO", // 30
  "SET_FLAG_CUBE",
  "COMPORTEMENT",
  "SET_COMPORTEMENT",
  "SET_COMPORTEMENT_OBJ",
  "END_COMPORTEMENT", // 35
  "SET_FLAG_GAME",
  "KILL_OBJ",
  "SUICIDE",
  "USE_ONE_LITTLE_KEY",
  "GIVE_GOLD_PIECES", // 40
  "END_LIFE",
  "STOP_L_TRACK",
  "RESTORE_L_TRACK",
  "MESSAGE_OBJ",
  "INC_CHAPTER", // 45
  "FOUND_OBJECT",
  "SET_DOOR_LEFT",
  "SET_DOOR_RIGHT",
  "SET_DOOR_UP",
  "SET_DOOR_DOWN", // 50
  "GIVE_BONUS",
  "CHANGE_CUBE",
  "OBJ_COL",
  "BRICK_COL",
  "OR_IF", // 55
  "INVISIBLE",
  "ZOOM",
  "POS_POINT",
  "SET_MAGIC_LEVEL",
  "SUB_MAGIC_POINT", // 60
  "SET_LIFE_POINT_OBJ",
  "SUB_LIFE_POINT_OBJ",
  "HIT_OBJ",
  "PLAY_FLA",
  "PLAY_MIDI", // 65
  "INC_CLOVER_BOX",
  "SET_USED_INVENTORY",
  "ADD_CHOICE",
  "ASK_CHOICE",
  "BIG_MESSAGE", // 70
  "INIT_PINGOUIN",
  "SET_HOLO_POS",
  "CLR_HOLO_POS",
  "ADD_FUEL",
  "SUB_FUEL", // 75
  "SET_GRM",
  "SAY_MESSAGE",
  "SAY_MESSAGE_OBJ",
  "FULL_POINT",
  "BETA", // 80
  "GRM_OFF",
  "FADE_PAL_RED",
  "FADE_ALARM_RED",
  "FADE_ALARM_PAL",
  "FADE_RED_PAL", // 85
  "FADE_RED_ALARM",
  "FADE_PAL_ALARM",
  "EXPLODE_OBJ",
  "BULLE_ON",
  "BULLE_OFF", // 90
  "ASK_CHOICE_OBJ",
  "SET_DARK_PAL",
  "SET_NORMAL_PAL",
  "MESSAGE_SENDELL",
  "ANIM_SET", // 95
  "HOLOMAP_TRAJ",
  "GAME_OVER",
  "THE_END",
  "MIDI_OFF",
  "PLAY_CD_TRACK", // 100
  "PROJ_ISO",
  "PROJ_3D",
  "TEXT",
  "CLEAR_TEXT",
  "BRUTAL_EXIT" // 105
};

char ConditionsList[][50] = {
  "COL",               // 0
  "COL_OBJ",           // 1
  "DISTANCE",          // 2
  "ZONE",              // 3
  "ZONE_OBJ",          // 4
  "BODY",              // 5
  "BODY_OBJ",          // 6
  "ANIM",              // 7
  "ANIM_OBJ",          // 8
  "L_TRACK",           // 9
  "L_TRACK_OBJ",       // 10
  "FLAG_CUBE",         // 11
  "CONE_VIEW",         // 12
  "HIT_BY",            // 13
  "ACTION",            // 14
  "FLAG_GAME",         // 15
  "LIFE_POINT",        // 16
  "LIFE_POINT_OBJ",    // 17
  "NUM_LITTLE_KEYS",   // 18
  "NUM_GOLD_PIECES",   // 19
  "COMPORTEMENT_HERO", // 20
  "CHAPTER",           // 21
  "DISTANCE_3D",       // 22
  "",                  // 23
  "",                  // 24
  "USE_INVENTORY",     // 25
  "CHOICE",            // 26
  "FUEL",              // 27
  "CARRY_BY",          // 28
  "CDROM"              // 29
};

char OperatorsList[][5] = {
  "==",
  ">",
  "<",
  ">=",
  "<=",
  "!="
};

char BehaviorList[][10]=
{
  "NORMAL",    // 0
  "ATHLETIC",  // 1
  "AGGRESSIVE", // 2
  "DISCRETE",   // 3
  "PROTO-PACK"
};

//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
// BINARY SCENES #########
//------------------------

// ----------------
// - LOAD ROUTINES
// -------------------------------------------------------------------------

TScene loadBinaryScene(char* fileName, int index)
{
   unsigned char* scenePtr;
   TScene Scene;
   //unsigned short int aux = 0;

   if(index != -1) // HQR
   {
      /*filesize = loadResource(fileName,index,&scenePtr);
      if(filesize == -1) // didn't find the file
        return Scene;*/

      filesize = Ress.Entries[index].RlSize;
      if(filesize == 0) // file doesn't exist
        return Scene;

      scenePtr = LBARessExtractEntryToPtr(Ress,index);
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
        resolveOffsets(scenePtr);

        Scene.TextBank = *(scenePtr++);
        Scene.CubeEntry = *(scenePtr++); //scenePtr+=4;
        Scene.unused1 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.unused2 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.AlphaLight = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.BetaLight = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb0_1 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb0_2 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb0_3 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb1_1 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb1_2 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb1_3 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb2_1 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb2_2 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb2_3 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb3_1 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb3_2 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Amb3_3 = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Second_Min = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Second_Ecart = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.CubeMusic = *(scenePtr++);

        Scene.Hero.X = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Hero.Y = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Hero.Z = *((unsigned short *)scenePtr); scenePtr+=2;

        //-----------------

        int heroTrackBytes = *((unsigned short *)scenePtr); scenePtr+=2;
        unsigned char * heroTrack = scenePtr;
        Scene.Hero.trackScript = decompTrackScript(scenePtr);
        scenePtr += heroTrackBytes;

        //-----------------
        int heroLifeBytes = *((unsigned short *)scenePtr); scenePtr+=2;
        Scene.Hero.lifeScript = decompLifeScript(scenePtr, heroLifeBytes, heroTrack, 0);
        scenePtr += heroLifeBytes;

        Scene.numActors = *((unsigned short *)scenePtr); scenePtr+=2;
   
        for(int i=1; i < Scene.numActors; i++)
        {
           // char buff[256]; // temp buffer
            TActor Actor;
           // getLine(bodyDescPath.c_str(),buff,0);
           // strcpy(Actor.Name,buff);
            Actor.staticFlag = *((unsigned short *)scenePtr); scenePtr+=2;
            Actor.Entity = *((unsigned short *)scenePtr); scenePtr+=2;
            Actor.Body = *(scenePtr++);
            Actor.Animation = *(scenePtr++);
            Actor.SpriteEntry = *((unsigned short *)scenePtr); scenePtr+=2;
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
            unsigned char * actorTrack = scenePtr;
            Actor.trackScript = decompTrackScript(scenePtr);
            scenePtr += trackBytes;

            int lifeBytes = *((unsigned short *)scenePtr); scenePtr+=2;
            Actor.lifeScript = decompLifeScript(scenePtr, lifeBytes, actorTrack, i);
            scenePtr += lifeBytes;

            Scene.Actors.push_back(Actor);
        }

        Scene.numZones = *((unsigned short *)scenePtr); scenePtr+=2;

        for(int i=0; i < Scene.numZones; i++)
        {
            TZone Zone;
            Zone.X0 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Y0 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Z0 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.X1 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Y1 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Z1 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Type = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Info0 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Info1 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Info2 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Info3 = *((unsigned short *)scenePtr); scenePtr+=2;
            Zone.Snap = *((unsigned short *)scenePtr); scenePtr+=2;

            Scene.Zones.push_back(Zone);
        }

        Scene.numTracks= *((unsigned short *)scenePtr); scenePtr+=2;

        for(int i=0; i < Scene.numTracks; i++)
        {
            TTrack Track;
            Track.Num = i;
            Track.X = *((unsigned short *)scenePtr); scenePtr+=2;
            Track.Y = *((unsigned short *)scenePtr); scenePtr+=2;
            Track.Z = *((unsigned short *)scenePtr); scenePtr+=2;
            Scene.Tracks.push_back(Track);
        }
//        free(scenePtr);
   }
   return Scene;
}

char * decompTrackScript(unsigned char *scriptPtr)
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

       if(wrof){ // DEBUG
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
               sprintf(scriptbuff,"BODY %d",*(scriptPtr++));
               break;
           }
           case 3: // ANIM
           {
               sprintf(scriptbuff,"ANIM %d", *(scriptPtr++));
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
           case 6: // LOOP   <-- RECHECK
           {
               sprintf(scriptbuff,"LOOP");
               //sprintf(scriptbuff,"LOOP %d",*(scriptPtr++)); //<<-- RECHECK
               break;
           }
           case 7: // ANGLE
           {
               short int angleTmp;
               //short int angle;
               angleTmp = *(short int *) (scriptPtr);
               scriptPtr += 2;

               // RECHECK!!!  <-----------------
               //angle = (360*angleTmp)/32767;  // angle in graus

               sprintf(scriptbuff,"ANGLE %d", angleTmp);
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
               short int offset;
               offset = *(short int *) (scriptPtr);
               scriptPtr += 2;
               if(wrof)
                    sprintf(scriptbuff,"GOTO %d",offset);
               else
               {
                    offset = *(tempPtr + offset + 1);
                    sprintf(scriptbuff,"GOTO %d",offset);
               }
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
               short int sample;
               sample = *(short int *) (scriptPtr);
               scriptPtr += 2;
               sprintf(scriptbuff,"SAMPLE %d", sample);
               break;
           }
           case 15: // GOTO_POINT_3D
           {
               sprintf(scriptbuff,"GOTO_POINT_3D %d", *(scriptPtr++));
               break;
           }
           case 16: // SPEED
           {
               short int speed;
               speed = *(short int *) scriptPtr;
               scriptPtr += 2;
               sprintf(scriptbuff,"SPEED %d", speed);
               break;
           }
           case 17: // BACKGROUND
           {
               sprintf(scriptbuff,"BACKGROUND %d", *(scriptPtr++));
               break;
           }
           case 18: // WAIT_NUM_SECOND       < - RECHECK  #####################
           {
               int seconds;

               seconds = *(scriptPtr++);

               scriptPtr += 4;

               sprintf(scriptbuff,"WAIT_NUM_SECOND %d", seconds);
               break;
           }
           case 19: // NO_BODY
           {
               sprintf(scriptbuff,"NO_BODY");
               break;
           }
           case 20: // BETA
           {
               short int angle;
               angle = *(short int *) scriptPtr;
               scriptPtr += 2;
               sprintf(scriptbuff,"BETA %d", angle);
               break;
           }
           case 21: // OPEN_LEFT
           {
               short int distance;
               distance = *(short int *) (scriptPtr);
               scriptPtr += 2;
               sprintf(scriptbuff,"OPEN_LEFT %d", distance);
               break;
           }
           case 22: // OPEN_RIGHT
           {
               short int distance;
               distance = *(short int *) (scriptPtr);
               scriptPtr += 2;
               sprintf(scriptbuff,"OPEN_RIGHT %d", distance);
               break;
           }
           case 23: // OPEN_UP
           {
               short int distance;
               distance = *(short int *) (scriptPtr);
               scriptPtr += 2;
               sprintf(scriptbuff,"OPEN_UP %d", distance);
               break;
           }
           case 24: // OPEN_DOWN
           {
               short int distance;
               distance = *(short int *) (scriptPtr);
               scriptPtr += 2;
               sprintf(scriptbuff,"OPEN_DOWN %d", distance);
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
               short int time;
               time = *(short int *) scriptPtr;
               scriptPtr += 2;
               sprintf(scriptbuff,"SAMPLE_RND %d", time);
               break;
           }
           case 28: // SAMPLE_ALWAYS
           {
               short int sample;
               sample = *(short int *) scriptPtr;
               scriptPtr += 2;
               sprintf(scriptbuff,"SAMPLE_ALWAYS %d", sample);
               break;
           }
           case 29: // SAMPLE_STOP
           {
               short int sample;
               sample = *(short int *) scriptPtr;
               scriptPtr += 2;
               sprintf(scriptbuff,"SAMPLE_STOP %d", sample);
               break;
           }
           case 30: // PLAY_FLA
           {
               sprintf(scriptbuff,"PLAY_FLA %s",scriptPtr);
               scriptPtr += strlen((char *) scriptPtr) + 1;
               break;
           }
           case 31: // REPEAT_SAMPLE
           {
               short int sample;
               sample = *(short int *) scriptPtr;
               scriptPtr += 2;
               sprintf(scriptbuff,"REPEAT_SAMPLE %d", sample);
               break;
           }
           case 32: // SIMPLE_SAMPLE
           {
               short int sample;
               sample = *(short int *) scriptPtr;
               scriptPtr += 2;
               sprintf(scriptbuff,"SIMPLE_SAMPLE %d", sample);
               break;
           }
           case 33: //FACE_TWINKEL
           {
               //short int dummy; // no longer needed, should always be -1
               //dummy = *(short int *) scriptPtr;
               scriptPtr += 2;
               //sprintf(scriptbuff,"FACE_TWINKEL %d", dummy);
               sprintf(scriptbuff,"FACE_TWINKEL");
               break;
           }
           case 34: // ANGLE_RND
           {
               int anglernd;
               //int dummy;

               anglernd = *(short int *) scriptPtr;
               scriptPtr += 2;
               //dummy = *(short int *) scriptPtr;
               scriptPtr += 2;
               sprintf(scriptbuff,"ANGLE_RND %d", anglernd);
               break;
           }
           default:
           {
               sprintf(scriptbuff,"UNK_OPCODE %d", opcode);
               finish = 1;
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

void decompConditions(unsigned char **scriptPtr, char *buffer)
{
    unsigned char opcode;
    char buffer2[256];

    opcode = **(scriptPtr);

    *(scriptPtr) = (*(scriptPtr)) + 1;

    conditionMode = 0;

    switch (opcode)
    {
        case 0:
        {
            strcat(buffer, "COL");
            break;
        }
        case 1:
        {
            int actor;

            actor = **scriptPtr;
            *(scriptPtr) = (*(scriptPtr)) + 1;

            sprintf(buffer2, "COL_OBJ %d", actor);
            strcat(buffer, buffer2);
            break;
        }
        case 2:
        {
            int actor;

            actor = **scriptPtr;
            *(scriptPtr) = (*(scriptPtr)) + 1;

            sprintf(buffer2, "DISTANCE %d", actor);
            strcat(buffer, buffer2);
            conditionMode = 1;
            break;
        }
        case 3:
        {
            strcat(buffer, "ZONE");
            break;
        }
        case 4:
        {
            int actor;

            actor = **scriptPtr;
            *(scriptPtr) = (*(scriptPtr)) + 1;

            sprintf(buffer2, "ZONE_OBJ %d", actor);
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
            int actor;

            actor = **scriptPtr;
            *(scriptPtr) = (*(scriptPtr)) + 1;

            sprintf(buffer2, "BODY_OBJ %d", actor);
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
            int actor;

            actor = **scriptPtr;
            *(scriptPtr) = (*(scriptPtr)) + 1;

            sprintf(buffer2, "ANIM_OBJ %d", actor);
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
            int actor;

            actor = **scriptPtr;
            *(scriptPtr) = (*(scriptPtr)) + 1;

            sprintf(buffer2, "L_TRACK_OBJ %d", actor);
            strcat(buffer, buffer2);
            break;
        }
        case 11:
        {
            int flag;

            flag = **scriptPtr;
            *(scriptPtr) = (*(scriptPtr)) + 1;
            sprintf(buffer2, "FLAG_CUBE %d", flag);
            strcat(buffer, buffer2);
            break;
        }
        case 12:
        {
            int actor;

            actor = **scriptPtr;
            *(scriptPtr) = (*(scriptPtr)) + 1;

            sprintf(buffer2, "CONE_VIEW %d", actor);
            strcat(buffer, buffer2);
            conditionMode = 1;
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
            int flag;

            flag = **scriptPtr;
            *(scriptPtr) = (*(scriptPtr)) + 1;

            sprintf(buffer2, "FLAG_GAME %d", flag);
            strcat(buffer, buffer2);
            break;
        }
        case 16:
        {
            strcat(buffer, "LIFE_POINT");
            break;
        }
        case 17:
        {
            int actor;

            actor = **scriptPtr;
            *(scriptPtr) = (*(scriptPtr)) + 1;

            sprintf(buffer2, "LIFE_POINT_OBJ %d", actor);
            strcat(buffer, buffer2);
            break;
        }
        case 18:
        {
            strcat(buffer, "NUM_LITTLE_KEYS");
            break;
        }
        case 19:
        {
            strcat(buffer, "NUM_GOLD_PIECES"); //NB
            conditionMode = 1;
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
            conditionMode = 1;
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
            conditionMode = 1;
            break;
        }
        case 27:
        {
            strcat(buffer, "FUEL");
            break;
        }
        case 28:
        {
            strcat(buffer, "CARRY_BY");
            break;
        }
        case 29:
        {
            strcat(buffer, "CDROM");
            break;
        }
        default:
        {
            printf("UNK_CONDITION %d\n", opcode);
            //exit(1);
        }
    }
}

void decompOperators(unsigned char **scriptPtr, char *buffer)
{
    unsigned char opcode;
    int opcode2;
    char buffer2[256];

    opcode = **(scriptPtr);
    *(scriptPtr) = (*(scriptPtr)) + 1;

    switch(conditionMode)
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
            //exit(1);
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
            //exit(1);
            break;
        }
    }
}

void resolveOffsets(unsigned char * scenePtr)
{
    //short int offset=0;
    unsigned char opcode;
    unsigned short temp;
    unsigned char * scenePtr2 = scenePtr;

    scenePtr += 45; // Hero Track Script Offset
    temp = *((unsigned short *)scenePtr);
    scenePtr+=2;
    //setTrackObjectIndex(0,temp,scenePtr);
    decompTrackOffsets(scenePtr,0);
    scenePtr += temp;

    temp = *((unsigned short *)scenePtr); // Hero Life Script Offset
    scenePtr+=2;
    scenePtr += temp;

    int numActors = *((unsigned short *)scenePtr);
    scenePtr += 2;

    for(int a=1; a<numActors; a++)
    {
        scenePtr += 35;
        temp = *((unsigned short *)scenePtr);
        scenePtr+=2;
        //setTrackObjectIndex(a,temp,scenePtr);
        decompTrackOffsets(scenePtr,a);
        scenePtr += temp;

        temp = *((unsigned short *)scenePtr);
        scenePtr+=2;
        scenePtr += temp;
    }

    scenePtr2 += 45; // Hero Track Script Offset
    temp = *((unsigned short *)scenePtr2);
    scenePtr2+=2;
    scenePtr2 += temp;

    temp = *((unsigned short *)scenePtr2); // Hero Life Script Offset
    scenePtr2+=2;
    //setComportementObjectIndex(0,temp,scenePtr);
    decompLifeOffsets(scenePtr2,0);
    scenePtr2 += temp;

    int numActors2 = *((unsigned short *)scenePtr2);
    scenePtr2 += 2;

    for(int a=1; a<numActors2; a++)
    {
        scenePtr2 += 35;
        temp = *((unsigned short *)scenePtr2);
        scenePtr2+=2;
        scenePtr2 += temp;

        temp = *((unsigned short *)scenePtr2);
        scenePtr2+=2;
        //setComportementObjectIndex(a,temp,scenePtr);
        decompLifeOffsets(scenePtr2,a);
        scenePtr2 += temp;
    }
}

void setComportementObjectIndex(int numActor, unsigned short numBytes, unsigned char * ptr)
{
    short int offset=0;
    unsigned char tempOp;
    int numComp=1;

    comportementOffsets[numActor][0] = 0;

    for(int a=numBytes; a > 1; a--){
        tempOp = *(ptr+offset);
        if(tempOp == 35)
        {
            comportementOffsets[numActor][numComp] = offset+1;
            numComp++;
        }
        offset++;
    }
}

void setTrackObjectIndex(int numActor, unsigned short numBytes, unsigned char * ptr)
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
            trackOffsets[numActor][temp] = offset;
            numTracks++;
        }
        offset++;
    }
}

int getComportementIndex(short int comportement[50], short int offset)
{
    for(int a=0; a < 50; a++)
    {
        if(comportement[a]==offset)
            return a;
    }
    return -1;
}

int getComportementObjectIndex(short int offset, int numActor)
{
    for(int a=0; a < 50; a++)
    {
        if(comportementOffsets[numActor][a]==offset)
            return a;
    }
    return -1;
}

int getTrackObjectIndex(short int offset, int numActor)
{
    for(int a=0; a < 255; a++)
    {
        if(trackOffsets[numActor][a]==offset)
            return a;
    }
    return -1;
}

void indentScript(unsigned short indent){
   if(indent >= 1)
       for(int i=0; i < indent; i++){
           if(i==0)
                sprintf(indentation, "  ");
           else
                strcat(indentation, "  ");
       }
   else
        sprintf(indentation, "");
}

int decompTrackOffsets(unsigned char *scriptPtr, int actor)
{
    int currentOffset=0;
  //  int currentTrack=0;
    int opcode=0;
    int finish=0;

    do
    {
        opcode = *(scriptPtr+currentOffset);
        switch(opcode)
        {
            // Single Macros
            case 0:  // END
            case 1:  // NOP
            case 5:  // WAIT_ANIM
            case 6:  // LOOP
            case 11: // STOP
            case 19: // NO_BODY
            case 25: // CLOSE
            case 26: // WAIT_DOOR
                {
                    if(opcode==0)
                        finish=1;
                    currentOffset=currentOffset+1;
                    break;
                }
            // Macros with byte value
            case 2: // BODY
            case 3: // ANIM
            case 4:  // GOTO_POINT
            case 8:  // POS_POINT
            case 9:  // LABEL
            case 12: // GOTO_SYM_POINT
            case 15: // GOTO_POINT_3D
            case 17: // BACKGROUND
                {
                    if(opcode==9) // LABEL
                    {
                      trackOffsets[actor][*(scriptPtr+currentOffset+1)] = currentOffset;
//                      currentTrack++;
                    }
                    currentOffset=currentOffset+2;
                    break;
                }
            // Macros with word value
            case 7: // ANGLE
            case 10: // GOTO
            case 14: // SAMPLE
            case 16: // SPEED
            case 20: // BETA
            case 21: // OPEN_LEFT
            case 22: // OPEN_RIGHT
            case 23: // OPEN_UP
            case 24: // OPEN_DOWN
            case 27: // SAMPLE_RND
            case 28: // SAMPLE_ALWAYS
            case 29: // SAMPLE_STOP
            case 31: // REPEAT_SAMPLE
            case 32: // SIMPLE_SAMPLE
            case 33: // FACE_TWINKEL
                    {
                        /*if(opcode == 10) // GOTO
                        {
                            gotoOffsets[actor][*((short int *)(scriptPtr+currentOffset+1))] = currentOffset;
                        } */
                        currentOffset=currentOffset+3;
                        break;
                    }
             case 13: // WAIT_NB_ANIM  1 byte used, 1 byte dummy
                    currentOffset=currentOffset+3;
                    break;
             case 34: // ANGLE_RND
                    currentOffset=currentOffset+5;
                    break;
             case 18: // WAIT_NB_SECOND  1 byte used, 4 byte dummy
                    currentOffset=currentOffset+6;
                    break;
             case 30: // PLAY_FLA      <- RECHECK
                {
                    int size = strlen(scriptPtr+currentOffset+1)+1;
                    currentOffset=currentOffset+size;
                    break;
                }
             default:
                finish=1;
                break;
        }
    }while(!finish);
    return currentOffset;
}

int decompLifeOffsets(unsigned char *scriptPtr, int actor)
{
    int currentOffset=0;
    unsigned char tmpPtr;
    int currentComportement=1;
    int opcode=0;
    int finish=0;

    // first comportament is always at offset 0
    comportementOffsets[actor][0] = 0;

    do
    {
        opcode = *(scriptPtr+currentOffset);
        switch(opcode)
        {
            // Single Macros
            case 0: // END
            case 1: // NOP
            case 11: // RETURN
            case 35: // END_COMPORTAMENT
            case 38: // SUICIDE
            case 39: // USE_ONE_LITTLE_KEY
            case 41: // END_LIFE
            case 42: // STOP_L_TRACK
            case 43: // RESTORE_L_TRACK
            case 45: // INC_CHAPTER
            case 66: // INC_CLOVER_BOX
            case 79: // FULL_POINT
            case 81: // GRM_OFF
            case 82: // FADE_PAL_RED
            case 83: // FADE_ALARM_RED
            case 84: // FADE_ALARM_PAL
            case 85: // FADE_RED_PAL
            case 86: // FADE_RED_ALARM
            case 87: // FADE_PAL_ALARM
            case 89: // BULLE_ON
            case 90: // BUBBLE_OFF
            case 92: // SET_DARK_PAL
            case 93: // SET_NORMAL_PAL
            case 94: // MESSAGE_SENDELL
            case 97: // GAME_OVER
            case 98: // THE_END
            case 99: // MIDI_OFF
            case 101: // PROJ_ISO
            case 102: // PROJ_3D
            case 104: // CLEAR_TEXT
            case 105: // BRUTAL_EXIT
                {
                    if(opcode == 35) // END_COMPORTAMENT
                    {
                      // plus 1 because it will point to the next comportament
                      comportementOffsets[actor][currentComportement] = currentOffset+1;
                      currentComportement++;
                    }

                    if(opcode==0)
                        finish=1;

                    currentOffset=currentOffset+1;
                    break;
                }
            // Macros with byte value
            case 10: // LABEL
            case 17: // BODY
            case 19: // ANIM
            case 26: // FALLABLE
            case 29: // CAM_FOLLOW
            case 30: // COMPORTEMENT_HERO
            //case 32: // COMPORTEMENT
            case 37: // KILL_OBJ
            case 46: // FOUND_OBJECT
            case 51: // GIVE_BONUS
            case 52: // CHANGE_CUBE
            case 53: // OBJ_COL
            case 54: // BRICK_COL
            case 56: // INVISIBLE
            case 57: // ZOOM
            case 58: // POS_POINT
            case 59: // SET_MAGIC_LEVEL
            case 60: // SUB_MAGIC_POINT
            case 65: // PLAY_MIDI
            case 67: // SET_USED_INVENTORY
            case 71: // INIT_PINGOUIN
            case 72: // SET_HOLO_POS
            case 73: // CLR_HOLO_POS
            case 74: // ADD_FUEL
            case 75: // SUB_FUEL
            case 76: // SET_GRM
            case 88: // EXPLODE_OBJ
            case 95: // ANIM_SET
            case 96: // HOLOMAP_TRAJ
            case 100: // PLAY_CD_TRACK
                    currentOffset=currentOffset+2;
                    break;
            // Macros with word value
            case 3: // OFFSET
            case 21: // SET_LIFE
            case 23: // SET_TRACK
            case 25: // MESSAGE
            case 33: // SET_COMPORTEMENT
            case 40: // GIVE_GOLD_PIECES
            case 47: // SET_DOOR_LEFT
            case 48: // SET_DOOR_RIGHT
            case 49: // SET_DOOR_UP
            case 50: // SET_DOOR_DOWN
            case 68: // ADD_CHOICE
            case 69: // ASK_CHOICE
            case 70: // BIG_MESSAGE
            case 77: // SAY_MESSAGE
            case 80: // BETA
            case 103: // TEXT
                    currentOffset=currentOffset+3;
                    break;
            // Macros with string value
            case 64: // PLAY_FLA      <- RECHECK
                {
                    int size = strlen(scriptPtr+currentOffset+1)+1;
                    currentOffset=currentOffset+size+1;
                    break;
                }
             // Macros with 2 consecutives byte values
             case 18: // BODY_OBJ
             case 20: // ANIM_OBJ
             case 31: // SET_FLAG_CUBE
             case 36: // SET_FLAG_GAME
             case 61: // SET_LIFE_POINT_OBJ
             case 62: // SUB_LIFE_POINT_OBJ
             case 63: // HIT_OBJ             
                    currentOffset=currentOffset+3;
                    break;
             // Macros with 1 byte and 1 word
             case 22: // SET_LIFE_OBJ
             case 24: // SET_TRACK_OBJ
             case 34: // SET_COMPORTEMENT_OBJ
             case 44: // MESSAGE_OBJ
             case 78: // SAY_MESSAGE_OBJ
             case 91: // ASK_CHOICE_OBJ
                    currentOffset=currentOffset+4;
                    break;
             // Macros with 3 byte values
             case 27: // SET_DIR
                {
                    int value1 = *(scriptPtr+currentOffset+1);

                    if(value1==2)
                    {
                      currentOffset=currentOffset+3;
                    }
                    else
                    {
                      currentOffset=currentOffset+2;
                    }
                    break;
                }
             case 28: // SET_DIR_OBJ
                {
                    int value2 = *(scriptPtr+currentOffset+2);

                    if(value2==2)
                    {
                      currentOffset=currentOffset+4;
                    }
                    else
                    {
                      currentOffset=currentOffset+3;
                    }
                    break;
                }
             // Now the TRICKY part :)
             // -----------------------------------------------
             // Macros with conditions
             case 2: // SNIF
             case 4: // NEVERIF     <---- RECHECK
             case 6: // NO_IF
             case 12: // IF
             case 13: // SWIF
             case 14: // ONEIF
             case 55: // OR_IF
                {
                    int auxOffset=0;
                    int condOpcode = *(scriptPtr+currentOffset+1);

                    // -------------------------------------------------

                    switch(condOpcode){
						// single macros [OP] 1 byte  + 2 pffset
						case 0: // COL
						case 3: // ZONE
						case 5: // BODY
						case 7: // ANIM
						case 9: // L_TRACK
						case 13: // HIT_BY
						case 14: // ACTION
						case 16: // LIFE_POINT
						case 18: // NB_LITTLE_KEYS
						case 20: // COMPORTEMENT_HERO
						case 21: // CHAPTER
						case 27: // FUEL
                        case 28: // CARRY_BY
                        case 29: // CDROM                        
                            auxOffset = 6;
						    break;
						// single macros [OP] 2 bytes  + 2 pffset
						case 19: // NB_GOLD_PIECES
						case 26: // CHOICE
						    auxOffset = 7;
						    break;
						// macros with value [OP] 1 byte  + 2 pffset
						case 1: // COL_OBJ
						case 4: // ZONE_OBJ
						case 6: // BODY_OBJ
						case 8: // ANIM_OBJ
						case 10: // L_TRACK_OBJ
						case 11: // FLAG_CUBE
						case 15: // FLAG_GAME
						case 17: // LIFE_POINT_OBJ
						case 25: // USE_INVENTORY
						    auxOffset = 7;
						    break;
						// macros with value [OP] 2 bytes + 2 pffset
						case 2: // DISTANCE
						case 12: // CONE_VIEW
						case 22: // DISTANCE_3D
						    auxOffset = 8;
						    break;
				    }

                    // --------------------------------------------------

                    currentOffset=currentOffset+auxOffset;
                    break;
                }
             case 15: // ELSE
                    currentOffset=currentOffset+3;
                    break;
             default:
                finish=1;
                break;
        }
    }while(!finish);
    return currentOffset;
}

char * decompLifeScript(unsigned char *scriptPtr, int lifeBytes, unsigned char *trackPtr, int actor)
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
  //  unsigned char * trackPtr2 = trackPtr;
    char * ptr = (char *)malloc(1);
    *ptr = 0;

    memset(indentOffsets,0,sizeof(signed short)*500);
    memset(indentOffsets2,0,sizeof(signed short)*500);


    // Reverse comportement offset  ----------------------
    // ------------------------------
    /*short int offset=1;
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
    } */
    // END of Reverse comportement offset
    // ----------------------------------------------------

    do
    {
        endComportement = false;

        if(*scriptPtr != 0)
        {
            if(wrof){ // DEBUG
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

            if(wrof){ // DEBUG
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
                    finish = true;
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

                    if(wrof){
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

                    if(wrof){
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

                    if(wrof){
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

                    if(wrof){
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

                    if(wrof){
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

                    if(wrof){
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

                    sprintf(scriptbuff, "SET_LIFE %d", getComportementObjectIndex(offset,actor)); //  getComportementIndex(comportement, offset)
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
                    short int offset;

                    offset = *(short int *) scriptPtr;

                    scriptPtr += 2;

                  //  offset = *(trackPtr2 + offset + 1);

                    if(wrof)
                        sprintf(scriptbuff, "SET_TRACK %d", offset);
                    else
                        sprintf(scriptbuff, "SET_TRACK %d", getTrackObjectIndex(offset,actor)); //
                    break;
                }
                case 24:
                {
                    short int actor;
                    short int offset;

                    actor = *(scriptPtr++);

                    offset = *(short int *) scriptPtr;
                    scriptPtr += 2;

                //    offset = *(trackPtr2 + offset + 1);
                    if(wrof)
                        sprintf(scriptbuff, "SET_TRACK_OBJ %d %d", actor, offset);
                    else
                        sprintf(scriptbuff, "SET_TRACK_OBJ %d %d", actor, getTrackObjectIndex(offset,actor));
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
                    int mode;
                    int actor;

                    mode = *(scriptPtr++);

                    if (mode == 2)
                    {
                        actor = *(scriptPtr++);
                        sprintf(scriptbuff, "SET_DIR %d follow %d", mode, actor);
                    }
                    else
                    {
                        sprintf(scriptbuff, "SET_DIR %d", mode);
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
                        sprintf(scriptbuff, "SET_DIR_OBJ %d %d follow %d", temp3, temp, temp2);
                    }
                    else
                    {
                        sprintf(scriptbuff, "SET_DIR_OBJ %d %d", temp3, temp);
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
                    //sprintf(scriptbuff, "COMPORTEMENT_HERO %d", *(scriptPtr++));
                    sprintf(scriptbuff, "COMPORTEMENT_HERO %s", BehaviorList[*(scriptPtr++)]);
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

                    if(wrof)
                        sprintf(scriptbuff, "SET_COMPORTEMENT %d", offset);
                    else
                        sprintf(scriptbuff, "SET_COMPORTEMENT %d", getComportementObjectIndex(offset,actor)); //  getComportementIndex(comportement, offset)
                    break;
                }
                case 34:
                {
                    short int actor;
                    short int offset;

                    actor = *(scriptPtr++);

                    offset = *(short int *) scriptPtr;
                    scriptPtr += 2;

                    if(wrof)
                        sprintf(scriptbuff, "SET_COMPORTEMENT_OBJ %d %d", actor, offset);
                    else
                        sprintf(scriptbuff, "SET_COMPORTEMENT_OBJ %d %d", actor, getComportementObjectIndex(offset,actor));
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

                    temp = *(short int *) (scriptPtr);
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

                    if(wrof){
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
                    sprintf(scriptbuff2, "UNK_OPCODE %d", opcode);
                    strcat(scriptbuff, scriptbuff2);
                    finish = true;
                    break;
                }
            }

            // Write script line in the pointer
            size += strlen(scriptbuff)+2+(indent*2);
            ptr = (char *)realloc(ptr,size);
            strcat(ptr,indentation);
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

                        if(wrof){ // DEBUG
                            sprintf(scriptbuff2,"%d: ", scriptPtr - tempPtr);
                            size += strlen(scriptbuff2)+2;
                            ptr = (char *)realloc(ptr,size);
                            strcat(ptr,scriptbuff2);
                        }

                        sprintf(scriptbuff2,"ENDIF\n");
                        size += strlen(scriptbuff2)+2+(indent*2);
                        ptr = (char *)realloc(ptr,size);
                        indentScript(indent);
                        strcat(ptr,indentation);
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

                    if(wrof){ // DEBUG
                        sprintf(scriptbuff2,"%d: ", scriptPtr - tempPtr);
                        size += strlen(scriptbuff2)+2;
                        ptr = (char *)realloc(ptr,size);
                        strcat(ptr,scriptbuff2);
                    }

                    sprintf(scriptbuff2,"ENDIF\n");
                    size += strlen(scriptbuff2)+2+(indent*2);
                    ptr = (char *)realloc(ptr,size);
                    indentScript(indent);
                    strcat(ptr,indentation);
                    strcat(ptr,scriptbuff2);
            }

        }while (!endComportement);

        currentComportement ++;

    }
    while (!finish);

    return ptr;
}

bool findOffset(unsigned short indentIndex, unsigned short indentOffsets[500], unsigned short currentOffset)
{
    for(int a=0; a <= indentIndex; a++)
        if(indentOffsets[a] == currentOffset)
            return true;
    return false;
}

// ----------------
// - SAVE ROUTINES
// -------------------------------------------------------------------------

void saveBinaryScene(TScene Scene, char* fileName)
{
   FILE* sceneHandle;
 //  unsigned short aux;
   TScript Script;

   resolveCompOffsets(Scene);

   sceneHandle = fopen(fileName, "wb+");
   fseek(sceneHandle, SEEK_SET, 0);

   fwrite(&Scene.TextBank,1,1,sceneHandle);
   fwrite(&Scene.CubeEntry,1,1,sceneHandle);

   /*aux=0;
   fwrite(&aux,1,1,sceneHandle);
   fwrite(&aux,1,1,sceneHandle);
   fwrite(&aux,1,1,sceneHandle);
   fwrite(&aux,1,1,sceneHandle);*/
   fwrite(&Scene.unused1,2,1,sceneHandle);
   fwrite(&Scene.unused2,2,1,sceneHandle);

   fwrite(&Scene.AlphaLight,2,1,sceneHandle);
   fwrite(&Scene.BetaLight,2,1,sceneHandle);

   fwrite(&Scene.Amb0_1,2,1,sceneHandle);
   fwrite(&Scene.Amb0_2,2,1,sceneHandle);
   fwrite(&Scene.Amb0_3,2,1,sceneHandle);
   fwrite(&Scene.Amb1_1,2,1,sceneHandle);
   fwrite(&Scene.Amb1_2,2,1,sceneHandle);
   fwrite(&Scene.Amb1_3,2,1,sceneHandle);
   fwrite(&Scene.Amb2_1,2,1,sceneHandle);
   fwrite(&Scene.Amb2_2,2,1,sceneHandle);
   fwrite(&Scene.Amb2_3,2,1,sceneHandle);
   fwrite(&Scene.Amb3_1,2,1,sceneHandle);
   fwrite(&Scene.Amb3_2,2,1,sceneHandle);
   fwrite(&Scene.Amb3_3,2,1,sceneHandle);

   fwrite(&Scene.Second_Min,2,1,sceneHandle);
   fwrite(&Scene.Second_Ecart,2,1,sceneHandle);

   fwrite(&Scene.CubeMusic,1,1,sceneHandle);

   fwrite(&Scene.Hero.X,2,1,sceneHandle);
   fwrite(&Scene.Hero.Y,2,1,sceneHandle);
   fwrite(&Scene.Hero.Z,2,1,sceneHandle);

   // Hero Track Script Compilation
   compTrack(Scene.Hero.trackScript, sceneHandle, 0);

   // Hero Life Script Compilation
   compLife(Scene.Hero.lifeScript, sceneHandle, 0);

  /* aux=1;
   fwrite(&aux,2,1,sceneHandle); // Life Offset Numbers
   aux=0;
   fwrite(&aux,1,1,sceneHandle); // Put END in the script */

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

       // Actors Track Script Compilation
       compTrack(Scene.Actors[i-1].trackScript, sceneHandle, i);

       // Actors Life Script Compilation
       compLife(Scene.Actors[i-1].lifeScript, sceneHandle, i);


       /*aux=1;
       fwrite(&aux,2,1,sceneHandle); // Life Offset Numbers
       aux=0;
       fwrite(&aux,1,1,sceneHandle); // Put END in the script*/
       
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

void resolveCompOffsets(TScene Scene)
{
  compTrackOffsets(Scene.Hero.trackScript, 0);

  for(int a=1; a < Scene.numActors; a++)
  {
    compTrackOffsets(Scene.Actors[a-1].trackScript, a);
  }

  compLifeOffsets(Scene.Hero.lifeScript, 0);
  
  for(int b=1; b < Scene.numActors; b++)
  {
    compLifeOffsets(Scene.Actors[b-1].lifeScript, b);
  }
}

void compTrack(char * script, FILE* sceneHandle, int actor)
{
    int currentOffset=0;
    int finish=0;
    int line=0;
    unsigned char opcode;
    char scriptbuffer[256];
    AnsiString scriptStr;
    char scriptPtr[2000];

    TScript track;
    track.script = (unsigned char*)malloc(1);
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
            case 6:  // LOOP
            case 11: // STOP
            case 19: // NO_BODY
            case 25: // CLOSE
            case 26: // WAIT_DOOR
                {
                    track.script=(unsigned char*)realloc((unsigned char*)track.script,currentOffset+1);
                    *(track.script+currentOffset) = (unsigned char)opcode;
                    if(opcode==0)
                        finish=1;
                    currentOffset=currentOffset+1;
                    break;
                }
            // Macros with byte value
            case 2: // BODY
            case 3: // ANIM
            case 4:  // GOTO_POINT
            case 8:  // POS_POINT
            case 9:  // LABEL
            case 12: // GOTO_SYM_POINT
            case 15: // GOTO_POINT_3D
            case 17: // BACKGROUND
                {
                    track.script=(unsigned char*)realloc((unsigned char*)track.script,currentOffset+2);

                    int value;
                    AnsiString temp = TrackList[opcode];
                    temp += " %d";
                    sscanf(scriptbuffer,temp.c_str(),&value);

                    *(track.script+currentOffset) = (unsigned char)opcode;
                    *(track.script+currentOffset+1) = (unsigned char)value;

                    currentOffset=currentOffset+2;
                    break;
                }
            // Macros with word value
            case 7: // ANGLE
            case 10: // GOTO
            case 14: // SAMPLE
            case 16: // SPEED
            case 20: // BETA
            case 21: // OPEN_LEFT
            case 22: // OPEN_RIGHT
            case 23: // OPEN_UP
            case 24: // OPEN_DOWN
            case 27: // SAMPLE_RND
            case 28: // SAMPLE_ALWAYS
            case 29: // SAMPLE_STOP
            case 31: // REPEAT_SAMPLE
            case 32: // SIMPLE_SAMPLE
                {
                    track.script=(unsigned char*)realloc((unsigned char*)track.script,currentOffset+3);

                    int value;
                    AnsiString temp = TrackList[opcode];
                    temp += " %d";
                    sscanf(scriptbuffer,temp.c_str(),&value);

                    if(opcode == 10) //GOTO
                    {
                        int offset = trackOffsets[actor][value];
                        value = offset;
                    }
                  /*  else if(opcode == 7)
                    {
                        int angleTmp = value;
                        value = ceil((angleTmp*32767)/360);
                    } */

                    *(track.script+currentOffset) = (unsigned char)opcode;
                    *((short int *)(track.script+currentOffset+1)) = (short int)value;

                    currentOffset=currentOffset+3;
                    break;
                }
             case 33: // FACE_TWINKEL
                {
                    track.script=(unsigned char*)realloc((unsigned char*)track.script,currentOffset+3);
                    int dummy = -1; // no longer needed, always use value -1    
                    *(track.script+currentOffset) = (unsigned char)opcode;
                    *((short int *)(track.script+currentOffset+1)) = (short int)dummy;

                    currentOffset=currentOffset+3;
                    break;
                }
             case 13: // WAIT_NUM_ANIM  1 byte used, 1 byte dummy    <<---RECHECK
                {
                    track.script=(unsigned char*)realloc((unsigned char*)track.script,currentOffset+3);

                    int value1;
                    AnsiString temp = TrackList[opcode];
                    temp += " %d";
                    sscanf(scriptbuffer,temp.c_str(),&value1);

                    *(track.script+currentOffset) = (unsigned char)opcode;
                    *(track.script+currentOffset+1) = (unsigned char)value1;
                    *(track.script+currentOffset+2) = 0;

                    currentOffset=currentOffset+3;
                    break;
                }
             case 34: // ANGLE_RND
                {
                    track.script=(unsigned char*)realloc((unsigned char*)track.script,currentOffset+5);

                    int value1;
                    int value2=-1; // it always need a -1 value to work.
                    AnsiString temp = TrackList[opcode];
                    temp += " %d";
                    sscanf(scriptbuffer,temp.c_str(),&value1);

                    *(track.script+currentOffset) = (unsigned char)opcode;
                    *((short int*)(track.script+currentOffset+1)) = (short int)value1;
                    *((short int*)(track.script+currentOffset+3)) = (short int)value2;

                    currentOffset=currentOffset+5;
                    break;
                }
             case 18: // WAIT_NUM_SECOND  1 byte used, 4 byte dummy
                {
                    track.script=(unsigned char*)realloc((unsigned char*)track.script,currentOffset+6);

                    int value;
                    AnsiString temp = TrackList[opcode];
                    temp += " %d";
                    sscanf(scriptbuffer,temp.c_str(),&value);

                    *(track.script+currentOffset) = (unsigned char)opcode;
                    *(track.script+currentOffset+1) = (unsigned char)value;
                    *(track.script+currentOffset+2) = 0;
                    *(track.script+currentOffset+3) = 0;
                    *(track.script+currentOffset+4) = 0;
                    *(track.script+currentOffset+5) = 0;

                    currentOffset=currentOffset+6;
                    break;
                }
             case 30: // PLAY_FLA      <- RECHECK
                {
                    unsigned char value[255];
                    int size=0;
                    AnsiString temp = TrackList[opcode];
                    temp += " %s";
                    sscanf(scriptbuffer,temp.c_str(),&value);

                    size = strlen(value)+1;
                    track.script=(unsigned char*)realloc((unsigned char*)track.script,currentOffset+1+size);

                    *(track.script+currentOffset) = (unsigned char)opcode;
                    memcpy(track.script+currentOffset+1,&value,size);

                    currentOffset=currentOffset+1+size;
                    break;
                }
             default:
              //  finish = 1;
                break;
        }

        line++;
    }while(!finish);

   track.numOffsets = currentOffset;

   fwrite(&track.numOffsets,2,1,sceneHandle);
   fwrite(track.script,track.numOffsets,1,sceneHandle);
}

int getTrackIndex(char* lineBuffer)
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

    for(i=0;i<=(sizeof(TrackList)/34);i++)
    {
        if(strlen(TrackList[i]))
        {
            if(!strcmp(TrackList[i],buffer)){
                return i;
            }
        }
    }

    return -1;
}

void compTrackOffsets(char * script, int actor)
{
    int currentOffset=0;
    int finish=0;
    int line=0;
  //  int currentTrack=0;
    unsigned char opcode;
    char scriptbuffer[256];
    AnsiString scriptStr;
    char scriptPtr[2000];

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
            case 6:  // LOOP
            case 11: // STOP
            case 19: // NO_BODY
            case 25: // CLOSE
            case 26: // WAIT_DOOR
                {
                    if(opcode==0)
                        finish=1;
                    currentOffset=currentOffset+1;
                    break;
                }
            // Macros with byte value
            case 2: // BODY
            case 3: // ANIM
            case 4:  // GOTO_POINT
            case 8:  // POS_POINT
            case 9:  // LABEL
            case 12: // GOTO_SYM_POINT
            case 15: // GOTO_POINT_3D
            case 17: // BACKGROUND
                {
                    if(opcode==9) // LABEL
                    {
                      int value;
                      AnsiString temp = TrackList[opcode];
                      temp += " %d";
                      sscanf(scriptbuffer,temp.c_str(),&value);
                      trackOffsets[actor][value] = currentOffset;
//                      currentTrack++;
                    }
                    currentOffset=currentOffset+2;
                    break;
                }
            // Macros with word value
            case 7: // ANGLE
            case 10: // GOTO
            case 14: // SAMPLE
            case 16: // SPEED
            case 20: // BETA
            case 21: // OPEN_LEFT
            case 22: // OPEN_RIGHT
            case 23: // OPEN_UP
            case 24: // OPEN_DOWN
            case 27: // SAMPLE_RND
            case 28: // SAMPLE_ALWAYS
            case 29: // SAMPLE_STOP
            case 31: // REPEAT_SAMPLE
            case 32: // SIMPLE_SAMPLE
            case 33: // FACE_TWINKEL            
                {
                    currentOffset=currentOffset+3;
                    break;
                }
             case 13: // WAIT_NUM_ANIM  1 byte used, 1 byte dummy
                {
                    currentOffset=currentOffset+3;
                    break;
                }
             case 34: // ANGLE_RND
                {
                    currentOffset=currentOffset+5;
                    break;
                }
             case 18: // WAIT_NUM_SECOND  1 byte used, 4 byte dummy
                {
                    currentOffset=currentOffset+6;
                    break;
                }
             case 30: // PLAY_FLA      <- RECHECK
                {
                    char value[256];
                    AnsiString temp = TrackList[opcode];
                    temp += " %s";
                    sscanf(scriptbuffer,temp.c_str(),&value);

                    currentOffset=currentOffset+1+strlen(value)+1;
                    break;
                }
             default:
             //   finish = 1;
                break;
        }

        line++;
    }while(!finish);
}

void compLife(char * script, FILE* sceneHandle, int actor)
{
    int currentOffset=0;
    int finish=0;
    int line=0;
    int indentIdx=0;
    int currentIfElse[25];
    int currentOrIf[25];
    unsigned char opcode;
    char scriptbuffer[256];
    AnsiString scriptStr;
    char scriptPtr[2000];

    TScript life;
    life.script = (unsigned char*)malloc(1);
    *life.script = 0;
    life.numOffsets=0;

    memset(currentIfElse,0,sizeof(int)*25);
    memset(currentOrIf,0,sizeof(int)*25);

    do
    {
        getScriptLine(script,scriptbuffer,line);
        indentIdx = getLifeIndentIndex(scriptbuffer);
        opcode = getLifeIndex(scriptbuffer);
        switch(opcode)
        {
            // Single Macros
            case 0: // END
            case 1: // NOP
            case 11: // RETURN
            case 35: // END_COMPORTAMENT
            case 38: // SUICIDE
            case 39: // USE_ONE_LITTLE_KEY
            case 41: // END_LIFE
            case 42: // STOP_L_TRACK
            case 43: // RESTORE_L_TRACK
            case 45: // INC_CHAPTER
            case 66: // INC_CLOVER_BOX
            case 79: // FULL_POINT
            case 81: // GRM_OFF
            case 82: // FADE_PAL_RED
            case 83: // FADE_ALARM_RED
            case 84: // FADE_ALARM_PAL
            case 85: // FADE_RED_PAL
            case 86: // FADE_RED_ALARM
            case 87: // FADE_PAL_ALARM
            case 89: // BULLE_ON
            case 90: // BUBBLE_OFF
            case 92: // SET_DARK_PAL
            case 93: // SET_NORMAL_PAL
            case 94: // MESSAGE_SENDELL
            case 97: // GAME_OVER
            case 98: // THE_END
            case 99: // MIDI_OFF
            case 101: // PROJ_ISO
            case 102: // PROJ_3D
            case 104: // CLEAR_TEXT
            case 105: // BRUTAL_EXIT
                {
                    life.script=(unsigned char*)realloc((unsigned char*)life.script,currentOffset+1);
                    *(life.script+currentOffset) = (unsigned char)opcode;
                    if(opcode==0)
                        finish=1;
                    currentOffset=currentOffset+1;
                    break;
                }
            // Macros with byte value
            case 10: // LABEL
            case 17: // BODY
            case 19: // ANIM
            case 26: // FALLABLE
            case 29: // CAM_FOLLOW
            //case 32: // COMPORTEMENT
            case 37: // KILL_OBJ
            case 46: // FOUND_OBJECT
            case 51: // GIVE_BONUS
            case 52: // CHANGE_CUBE
            case 53: // OBJ_COL
            case 54: // BRICK_COL
            case 56: // INVISIBLE
            case 57: // ZOOM
            case 58: // POS_POINT
            case 59: // SET_MAGIC_LEVEL
            case 60: // SUB_MAGIC_POINT
            case 65: // PLAY_MIDI
            case 67: // SET_USED_INVENTORY
            case 71: // INIT_PINGOUIN
            case 72: // SET_HOLO_POS
            case 73: // CLR_HOLO_POS
            case 74: // ADD_FUEL
            case 75: // SUB_FUEL
            case 76: // SET_GRM
            case 88: // EXPLODE_OBJ
            case 95: // ANIM_SET
            case 96: // HOLOMAP_TRAJ
            case 100: // PLAY_CD_TRACK
                {
                    life.script=(unsigned char*)realloc((unsigned char*)life.script,currentOffset+2);

                    int value;
                    AnsiString temp = LifeList[opcode];
                    temp += " %d";
                    sscanf(scriptbuffer,temp.c_str(),&value);

                    *(life.script+currentOffset) = (unsigned char)opcode;
                    *(life.script+currentOffset+1) = (unsigned char)value;

                    currentOffset=currentOffset+2;
                    break;
                }
            case 30: // COMPORTEMENT_HERO
                {
                    life.script=(unsigned char*)realloc((unsigned char*)life.script,currentOffset+2);

                    unsigned char behavior[10];
                    AnsiString temp = LifeList[opcode];
                    temp += " %s";
                    sscanf(scriptbuffer,temp.c_str(),&behavior);

                    int value = getBehaviorIndex(behavior);

                    *(life.script+currentOffset) = (unsigned char)opcode;
                    *(life.script+currentOffset+1) = (unsigned char)value;

                    currentOffset=currentOffset+2;
                    break;
                }
            // Macros with word value
            case 3: // OFFSET
            case 21: // SET_LIFE
            case 23: // SET_TRACK
            case 25: // MESSAGE
            case 33: // SET_COMPORTEMENT
            case 40: // GIVE_GOLD_PIECES
            case 47: // SET_DOOR_LEFT
            case 48: // SET_DOOR_RIGHT
            case 49: // SET_DOOR_UP
            case 50: // SET_DOOR_DOWN
            case 68: // ADD_CHOICE
            case 69: // ASK_CHOICE
            case 70: // BIG_MESSAGE
            case 77: // SAY_MESSAGE
            case 80: // BETA
            case 103: // TEXT  
                {
                    life.script=(unsigned char*)realloc((unsigned char*)life.script,currentOffset+3);

                    int value=0;
                    AnsiString temp = LifeList[opcode];
                    temp += " %d";
                    sscanf(scriptbuffer,temp.c_str(),&value);

                    //TODO: resolve offsets   <<-- RECHECK
                    if(opcode == 33 || opcode == 21) // SET_COMPORTEMENT
                    {
                       int tmp = value;
                       value = comportementOffsets[actor][tmp];
                    }
                    else if(opcode == 23)
                    {
                       int tmp = value;
                       value = trackOffsets[actor][tmp];
                    }

                    *(life.script+currentOffset) = (unsigned char)opcode;
                    *((short int *)(life.script+currentOffset+1)) = (short int)value;

                    currentOffset=currentOffset+3;
                    break;
                }
            // Macros with string value
            case 64: // PLAY_FLA      <- RECHECK
                {
                    unsigned char value[255];
                    int size=0;
                    memset(value, 0, sizeof(unsigned char)*255);
                    AnsiString temp = LifeList[opcode];
                    temp += " %s";
                    sscanf(scriptbuffer,temp.c_str(),&value);

                    size = strlen(value)+1;
                    life.script=(unsigned char*)realloc((unsigned char*)life.script,currentOffset+1+size);

                    *(life.script+currentOffset) = (unsigned char)opcode;
                    memcpy(life.script+currentOffset+1,&value,size);

                    currentOffset=currentOffset+1+size;
                    break;
                }
             // Macros with 2 consecutives byte values
             case 18: // BODY_OBJ
             case 20: // ANIM_OBJ
             case 31: // SET_FLAG_CUBE
             case 36: // SET_FLAG_GAME
             case 61: // SET_LIFE_POINT_OBJ
             case 62: // SUB_LIFE_POINT_OBJ
             case 63: // HIT_OBJ
                {
                    life.script=(unsigned char*)realloc((unsigned char*)life.script,currentOffset+3);

                    int value1;
                    int value2;
                    AnsiString temp = LifeList[opcode];
                    temp += " %d %d";
                    sscanf(scriptbuffer,temp.c_str(),&value1, &value2);

                    *(life.script+currentOffset) = (unsigned char)opcode;
                    *(life.script+currentOffset+1) = (unsigned char)value1;
                    *(life.script+currentOffset+2) = (unsigned char)value2;

                    currentOffset=currentOffset+3;
                    break;
                }
             // Macros with 1 byte and 1 word
             case 22: // SET_LIFE_OBJ
             case 24: // SET_TRACK_OBJ
             case 34: // SET_COMPORTEMENT_OBJ
             case 44: // MESSAGE_OBJ
             case 78: // SAY_MESSAGE_OBJ
             case 91: // ASK_CHOICE_OBJ
                {
                    life.script=(unsigned char*)realloc((unsigned char*)life.script,currentOffset+4);

                    int value1=0;
                    int value2=0;
                    AnsiString temp = LifeList[opcode];
                    temp += " %d %d";
                    sscanf(scriptbuffer,temp.c_str(),&value1, &value2);

                    // TODO: resolve offsets <<<--- RECHECK
                    if(opcode == 22 || opcode == 34)
                    {
                        int tmp2 = value2;
                        value2 = comportementOffsets[value1][tmp2];
                    }
                    else if(opcode == 24)
                    {
                        int tmp2 = value2;
                        value2 = trackOffsets[value1][tmp2];
                    }

                    *(life.script+currentOffset) = (unsigned char)opcode;
                    *(life.script+currentOffset+1) = (unsigned char)value1;
                    *((short int *)(life.script+currentOffset+2)) = (short int)value2;

                    currentOffset=currentOffset+4;
                    break;
                }
             // Macros with 3 byte values
             case 27: // SET_DIR <<<---- RECHECKKK
                {
                    int value1;
                    int value2;
                    AnsiString temp = LifeList[opcode];
                    temp += " %d";
                    sscanf(scriptbuffer,temp.c_str(),&value1);

                    if(value1==2)
                    {
                      life.script=(unsigned char*)realloc((unsigned char*)life.script,currentOffset+3);
                      temp = LifeList[opcode];
                      temp += " %d follow %d";
                      sscanf(scriptbuffer,temp.c_str(),&value1, &value2);

                      *(life.script+currentOffset) = (unsigned char)opcode;
                      *(life.script+currentOffset+1) = (unsigned char)value1;
                      *(life.script+currentOffset+2) = (unsigned char)value2;
                      currentOffset=currentOffset+3;
                    }
                    else
                    {
                      life.script=(unsigned char*)realloc((unsigned char*)life.script,currentOffset+2);
                      *(life.script+currentOffset) = (unsigned char)opcode;
                      *(life.script+currentOffset+1) = (unsigned char)value1;
                      currentOffset=currentOffset+2;
                    }
                    break;
                }
             case 28: // SET_DIR_OBJ
                {
                    int value1;
                    int value2;
                    int value3;
                    AnsiString temp = LifeList[opcode];
                    temp += " %d %d";
                    sscanf(scriptbuffer,temp.c_str(),&value1, &value2);

                    if(value2==2)
                    {
                      life.script=(unsigned char*)realloc((unsigned char*)life.script,currentOffset+4);
                      temp = LifeList[opcode];
                      temp += " %d %d follow %d";
                      sscanf(scriptbuffer,temp.c_str(),&value1, &value2, &value3);

                      *(life.script+currentOffset) = (unsigned char)opcode;
                      *(life.script+currentOffset+1) = (unsigned char)value1;
                      *(life.script+currentOffset+2) = (unsigned char)value2;
                      *(life.script+currentOffset+3) = (unsigned char)value3;
                      currentOffset=currentOffset+4;
                    }
                    else
                    {
                      life.script=(unsigned char*)realloc((unsigned char*)life.script,currentOffset+3);
                      *(life.script+currentOffset) = (unsigned char)opcode;
                      *(life.script+currentOffset+1) = (unsigned char)value1;
                      *(life.script+currentOffset+2) = (unsigned char)value2;
                      currentOffset=currentOffset+3;
                    }
                    break;
                }
             // Now the TRICKY part :)
             // -----------------------------------------------
             // Macros with conditions
             case 2: // SNIF
             case 4: // NEVERIF     <---- RECHECK
             case 6: // NO_IF
             case 12: // IF
             case 13: // SWIF
             case 14: // ONEIF
             case 55: // OR_IF
                {
                    int offsetValue=0;

                    if(opcode == 55) //OR_IF: always apear another condition after this
                    {
                        offsetValue = orifOffsets[actor][indentIdx][currentOrIf[indentIdx]];

                    }
                    else
                    {
                        offsetValue = ifelseOffsets[actor][indentIdx][currentIfElse[indentIdx]];
                        currentOrIf[indentIdx]++;
                        currentIfElse[indentIdx]++;
                    }

                    char condMacro[255];
                    AnsiString temp = LifeList[opcode];
                    temp += " %s";
                    sscanf(scriptbuffer,temp.c_str(),&condMacro);

                    int condOpcode = getConditionsIndex(condMacro);

                    int auxOffset = compConditionsOffsets(condOpcode);
                    life.script=(unsigned char*)realloc((unsigned char*)life.script,currentOffset+auxOffset);

                    *(life.script+currentOffset) = (unsigned char)opcode;
                    *(life.script+currentOffset+1) = (unsigned char)condOpcode;

                    // -------------------------------------------------

                    switch(condOpcode){
						// single macros [OP] 1 byte  + 2 pffset
						case 0: // COL
						case 3: // ZONE
						case 5: // BODY
						case 7: // ANIM
						case 9: // L_TRACK
						case 13: // HIT_BY
						case 14: // ACTION
						case 16: // LIFE_POINT
						case 18: // NB_LITTLE_KEYS
						case 20: // COMPORTEMENT_HERO
						case 21: // CHAPTER
						case 27: // FUEL
                        case 28: // CARRY_BY
                        case 29: // CDROM  
						{
                            char tmpOp[255];
                            int tmpValue;
                            AnsiString temp2 = LifeList[opcode];
                            temp2 += " ";
                            temp2 += ConditionsList[condOpcode];
                            temp2 += " %s %d"; // operator
                            sscanf(scriptbuffer,temp2.c_str(),&tmpOp, &tmpValue);

                            int operatorOpcode = getOperatorsIndex(tmpOp);

						    *(life.script+currentOffset+2) = (unsigned char)operatorOpcode;
                            *(life.script+currentOffset+3) = (unsigned char)tmpValue;
                            *((short int *)(life.script+currentOffset+4)) = (short int)offsetValue;
						    break;
						}
						// single macros [OP] 2 bytes  + 2 pffset
						case 19: // NB_GOLD_PIECES
						case 26: // CHOICE
						{
						    char tmpOp[5];
                            int tmpValue;
                            AnsiString temp3 = LifeList[opcode];
                            temp3 += " ";
                            temp3 += ConditionsList[condOpcode];
                            temp3 += " %s %d"; // operator
                            sscanf(scriptbuffer,temp3.c_str(),&tmpOp, &tmpValue);

                            int operatorOpcode = getOperatorsIndex(tmpOp);

						    *(life.script+currentOffset+2) = (unsigned char)operatorOpcode;
                            *((short int *)(life.script+currentOffset+3)) = (short int)tmpValue;
                            *((short int *)(life.script+currentOffset+5)) = (short int)offsetValue;
						    break;
						}
						// macros with value [OP] 1 byte  + 2 pffset
						case 1: // COL_OBJ
						case 4: // ZONE_OBJ
						case 6: // BODY_OBJ
						case 8: // ANIM_OBJ
						case 10: // L_TRACK_OBJ
						case 11: // FLAG_CUBE
						case 15: // FLAG_GAME
						case 17: // LIFE_POINT_OBJ
						case 25: // USE_INVENTORY
						{
						    char tmpOp[5];
                            int tmpValue1, tmpValue2;
                            AnsiString temp4 = LifeList[opcode];
                            temp4 += " ";
                            temp4 += ConditionsList[condOpcode];
                            temp4 += " %d %s %d"; // operator
                            sscanf(scriptbuffer,temp4.c_str(), &tmpValue1, &tmpOp, &tmpValue2);

                            int operatorOpcode = getOperatorsIndex(tmpOp);

                            *(life.script+currentOffset+2) = (unsigned char)tmpValue1;
						    *(life.script+currentOffset+3) = (unsigned char)operatorOpcode;
                            *(life.script+currentOffset+4) = (unsigned char)tmpValue2;
                            *((short int *)(life.script+currentOffset+5)) = (short int)offsetValue;
						    break;
						}
						// macros with value [OP] 2 bytes + 2 pffset
						case 2: // DISTANCE
						case 12: // CONE_VIEW
						case 22: // DISTANCE_3D
						{
						    char tmpOp[5];
                            int tmpValue1, tmpValue2;
                            AnsiString temp5 = LifeList[opcode];
                            temp5 += " ";
                            temp5 += ConditionsList[condOpcode];
                            temp5 += " %d %s %d"; // operator
                            sscanf(scriptbuffer,temp5.c_str(),&tmpValue1, &tmpOp, &tmpValue2);

                            int operatorOpcode = getOperatorsIndex(tmpOp);

                            *(life.script+currentOffset+2) = (unsigned char)tmpValue1;
						    *(life.script+currentOffset+3) = (unsigned char)operatorOpcode;
                            *((short int *)(life.script+currentOffset+4)) = (short int)tmpValue2;
                            *((short int *)(life.script+currentOffset+6)) = (short int)offsetValue;
						    break;
						}
				    }

                    // --------------------------------------------------

                    currentOffset=currentOffset+auxOffset;
                    break;
                }
             case 15: // ELSE
                {
                    life.script=(unsigned char*)realloc((unsigned char*)life.script,currentOffset+3);

                    //TODO: get else endif offset  <<---RECHECK
                    int offsetValue = ifelseOffsets[actor][indentIdx][currentIfElse[indentIdx]];
                    currentIfElse[indentIdx]++;
                    
                    *(life.script+currentOffset) = (unsigned char)opcode;
                    *((short int *)(life.script+currentOffset+1)) = (short int)offsetValue;

                    currentOffset=currentOffset+3;
                    break;
                }
             case 16: // ENDIF
                {
                    break;
                }
             default:
                {
                  //  finish = 1;
                    break;
                }
        }
        line++;
    }while(!finish);

   life.numOffsets = currentOffset;

   fwrite(&life.numOffsets,2,1,sceneHandle);
   fwrite(life.script,life.numOffsets,1,sceneHandle);
}

int getLifeIndex(char* lineBuffer)
{
    int i;
    char buffer[256];
    char* ptr;

    strcpy(buffer,lineBuffer);

    ptr = strtok (buffer," ");

    int size = strlen(lineBuffer)+1;

    for(i=0;i<size;i++)
    {
        if(*(lineBuffer)==' ')
        {
            int size = strlen(lineBuffer)+1;
            for(int j=0;j<size;j++)
            {
               *(lineBuffer+j) = *(lineBuffer+j+1);
            }
        }
    }

    for(i=0;i<=(sizeof(LifeList)/50);i++)
    {
        if(strlen(LifeList[i]))
        {
            if(!strcmp(LifeList[i],ptr)){
                return i;
            }
        }
    }

    return -1;
}

int getConditionsIndex(char* lineBuffer)
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

    for(i=0;i<=(sizeof(ConditionsList)/34);i++)
    {
        if(strlen(ConditionsList[i]))
        {
            if(!strcmp(ConditionsList[i],buffer)){
                return i;
            }
        }
    }

    return -1;
}

int getOperatorsIndex(char* lineBuffer)
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

    for(i=0;i<=(sizeof(OperatorsList)/5);i++)
    {
        if(strlen(OperatorsList[i]))
        {
            if(!strcmp(OperatorsList[i],buffer)){
                return i;
            }
        }
    }

    return -1;
}

int getBehaviorIndex(char* lineBuffer)
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

    for(i=0;i<=(sizeof(BehaviorList)/10);i++)
    {
        if(strlen(BehaviorList[i]))
        {
            if(!strcmp(BehaviorList[i],buffer)){
                return i;
            }
        }
    }

    return -1;
}

int getLifeIndentIndex(char* lineBuffer)
{
    int index=0;
    char buffer[256];

    strcpy(buffer,lineBuffer);

    int size = strlen(lineBuffer)+1;

    for(int i=0;i<size;i++)
    {
        if(*(lineBuffer+i)==' ' && *(lineBuffer+i+1)==' ')
            index++;
        else
            break;
    }

    return index;
}

int compConditionsOffsets(int opcode)
{
    int aux=0;
    switch(opcode)
    {
		// single macros [OP] 1 byte  + 2 pffset
		case 0: // COL
		case 3: // ZONE
		case 5: // BODY
		case 7: // ANIM
		case 9: // L_TRACK
		case 13: // HIT_BY
		case 14: // ACTION
		case 16: // LIFE_POINT
		case 18: // NB_LITTLE_KEYS
		case 20: // COMPORTEMENT_HERO
		case 21: // CHAPTER
		case 27: // FUEL
        case 28: // CARRY_BY
        case 29: // CDROM
		{
            aux=6;
		    break;
		}
		// single macros [OP] 2 bytes  + 2 pffset
		case 19: // NB_GOLD_PIECES
		case 26: // CHOICE
		{
            aux=7;
		    break;
		}
		// macros with value [OP] 1 byte  + 2 pffset
		case 1: // COL_OBJ
		case 4: // ZONE_OBJ
		case 6: // BODY_OBJ
		case 8: // ANIM_OBJ
		case 10: // L_TRACK_OBJ
		case 11: // FLAG_CUBE
		case 15: // FLAG_GAME
		case 17: // LIFE_POINT_OBJ
		case 25: // USE_INVENTORY
		{
            aux=7;
		    break;
		}
		// macros with value [OP] 2 bytes + 2 pffset
		case 2: // DISTANCE
		case 12: // CONE_VIEW
		case 22: // DISTANCE_3D
		{
            aux=8;
		    break;
		}
        default:
            break;
    }
    return aux;
}

void compLifeOffsets(char * script, int actor)
{
    int currentOffset=0;
    int finish=0;
    int line=0;
    int currentComportement=1;
    int currentIfElse[25];
    int currentOrIf[25];
    int indentIdx = 0;
    unsigned char opcode;
    char scriptbuffer[256];
    AnsiString scriptStr;
    char scriptPtr[2000];

    // first comportament is always at offset 0
    comportementOffsets[actor][0] = 0;

    memset(currentIfElse,0,sizeof(int)*25);
    memset(currentOrIf,0,sizeof(int)*25);

    do
    {
        getScriptLine(script,scriptbuffer,line);
        indentIdx = getLifeIndentIndex(scriptbuffer);
        opcode = getLifeIndex(scriptbuffer);
        switch(opcode)
        {
            // Single Macros
            case 0: // END
            case 1: // NOP
            case 11: // RETURN
            case 35: // END_COMPORTAMENT
            case 38: // SUICIDE
            case 39: // USE_ONE_LITTLE_KEY
            case 41: // END_LIFE
            case 42: // STOP_L_TRACK
            case 43: // RESTORE_L_TRACK
            case 45: // INC_CHAPTER
            case 66: // INC_CLOVER_BOX
            case 79: // FULL_POINT
            case 81: // GRM_OFF
            case 82: // FADE_PAL_RED
            case 83: // FADE_ALARM_RED
            case 84: // FADE_ALARM_PAL
            case 85: // FADE_RED_PAL
            case 86: // FADE_RED_ALARM
            case 87: // FADE_PAL_ALARM
            case 89: // BULLE_ON
            case 90: // BUBBLE_OFF
            case 92: // SET_DARK_PAL
            case 93: // SET_NORMAL_PAL
            case 94: // MESSAGE_SENDELL
            case 97: // GAME_OVER
            case 98: // THE_END
            case 99: // MIDI_OFF
            case 101: // PROJ_ISO
            case 102: // PROJ_3D
            case 104: // CLEAR_TEXT
            case 105: // BRUTAL_EXIT
                {
                    if(opcode == 35) // END_COMPORTAMENT
                    {
                      // plus 1 because it will point to the next comportament
                      comportementOffsets[actor][currentComportement] = currentOffset+1;
                      currentComportement++;
                    }

                    if(opcode==0)
                        finish=1;

                    currentOffset=currentOffset+1;
                    break;
                }
            // Macros with byte value
            case 10: // LABEL
            case 17: // BODY
            case 19: // ANIM
            case 26: // FALLABLE
            case 29: // CAM_FOLLOW
            case 30: // COMPORTEMENT_HERO
            //case 32: // COMPORTEMENT
            case 37: // KILL_OBJ
            case 46: // FOUND_OBJECT
            case 51: // GIVE_BONUS
            case 52: // CHANGE_CUBE
            case 53: // OBJ_COL
            case 54: // BRICK_COL
            case 56: // INVISIBLE
            case 57: // ZOOM
            case 58: // POS_POINT
            case 59: // SET_MAGIC_LEVEL
            case 60: // SUB_MAGIC_POINT
            case 65: // PLAY_MIDI
            case 67: // SET_USED_INVENTORY
            case 71: // INIT_PINGOUIN
            case 72: // SET_HOLO_POS
            case 73: // CLR_HOLO_POS
            case 74: // ADD_FUEL
            case 75: // SUB_FUEL
            case 76: // SET_GRM
            case 88: // EXPLODE_OBJ
            case 95: // ANIM_SET
            case 96: // HOLOMAP_TRAJ
            case 100: // PLAY_CD_TRACK
                {
                    currentOffset=currentOffset+2;
                    break;
                }
            // Macros with word value
            case 3: // OFFSET
            case 21: // SET_LIFE
            case 23: // SET_TRACK
            case 25: // MESSAGE
            case 33: // SET_COMPORTEMENT
            case 40: // GIVE_GOLD_PIECES
            case 47: // SET_DOOR_LEFT
            case 48: // SET_DOOR_RIGHT
            case 49: // SET_DOOR_UP
            case 50: // SET_DOOR_DOWN
            case 68: // ADD_CHOICE
            case 69: // ASK_CHOICE
            case 70: // BIG_MESSAGE
            case 77: // SAY_MESSAGE
            case 80: // BETA
            case 103: // TEXT  
                {
                    currentOffset=currentOffset+3;
                    break;
                }
            // Macros with string value
            case 64: // PLAY_FLA      <- RECHECK
                {
                    unsigned char value[255];
                    int size=0;
                    AnsiString temp = LifeList[opcode];
                    temp += " %s";
                    sscanf(scriptbuffer,temp.c_str(),&value);
                    size = strlen(value)+1;
                    currentOffset=currentOffset+1+size;
                    break;
                }
             // Macros with 2 consecutives byte values
             case 18: // BODY_OBJ
             case 20: // ANIM_OBJ
             case 31: // SET_FLAG_CUBE
             case 36: // SET_FLAG_GAME
             case 61: // SET_LIFE_POINT_OBJ
             case 62: // SUB_LIFE_POINT_OBJ
             case 63: // HIT_OBJ             
                {
                    currentOffset=currentOffset+3;
                    break;
                }
             // Macros with 1 byte and 1 word
             case 22: // SET_LIFE_OBJ
             case 24: // SET_TRACK_OBJ
             case 34: // SET_COMPORTEMENT_OBJ
             case 44: // MESSAGE_OBJ
             case 78: // SAY_MESSAGE_OBJ
             case 91: // ASK_CHOICE_OBJ
                {
                    currentOffset=currentOffset+4;
                    break;
                }
             // Macros with 3 byte values
             case 27: // SET_DIR
                {
                    unsigned char value1;
                    AnsiString temp = LifeList[opcode];
                    temp += " %d";
                    sscanf(scriptbuffer,temp.c_str(),&value1);

                    if(value1==2)
                    {
                      currentOffset=currentOffset+3;
                    }
                    else
                    {
                      currentOffset=currentOffset+2;
                    }
                    break;
                }
             case 28: // SET_DIR_OBJ
                {
                    unsigned char value1;
                    unsigned char value2;
                    AnsiString temp = LifeList[opcode];
                    temp += " %d %d";
                    sscanf(scriptbuffer,temp.c_str(),&value1, &value2);

                    if(value2==2)
                    {
                      currentOffset=currentOffset+4;
                    }
                    else
                    {
                      currentOffset=currentOffset+3;
                    }
                    break;
                }
             // Now the TRICKY part :)
             // -----------------------------------------------
             // Macros with conditions
             case 2: // SNIF
             case 4: // NEVERIF     <---- RECHECK
             case 6: // NO_IF
             case 12: // IF
             case 13: // SWIF
             case 14: // ONEIF
             case 55: // OR_IF
                {
                    char condMacro[255];
                    AnsiString temp = LifeList[opcode];
                    temp += " %s";
                    sscanf(scriptbuffer,temp.c_str(),&condMacro);

                    int condOpcode = getConditionsIndex(condMacro);

                    currentOffset = currentOffset + compConditionsOffsets(condOpcode);

                    if(opcode != 55) // OR_IF
                    {
                        orifOffsets[actor][indentIdx][currentOrIf[indentIdx]] = currentOffset;
                        currentOrIf[indentIdx]++;
                    }

                    break;
                }
             case 15: // ELSE
                {
                    ifelseOffsets[actor][indentIdx][currentIfElse[indentIdx]] = currentOffset+3; // <<-- RECHECK
                    currentIfElse[indentIdx]++;
                    currentOffset=currentOffset+3;
                    break;
                }
             case 16: // ENDIF
                {
                    ifelseOffsets[actor][indentIdx][currentIfElse[indentIdx]] = currentOffset;
                    currentIfElse[indentIdx]++;
                    break;
                }
             default:
                {
              //      finish=1;
                    break;
                }
        }
        line++;
    }while(!finish);
}

void getScriptLine(char* script,char* buffer, int line)
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

TScene loadTextScene(char* fileName)
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

   Scene.Hero.trackScript = getTrackScript(sceneHandle);
   Scene.Hero.lifeScript = getLifeScript(sceneHandle);

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

       Actor.trackScript = getTrackScript(sceneHandle);
       Actor.lifeScript = getLifeScript(sceneHandle);

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

   fclose(sceneHandle);

   return Scene;
}

char* getTrackScript(FILE* sceneHandle)
{
  /* int position = ftell(sceneHandle);
   int position2;  */
   int size = 0;
   char buffer[256];
   char buffer2[256];
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

char* getLifeScript(FILE* sceneHandle)
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

// TODO:
char* removeComments(char * script)
{
   int size = 0;
   int prtSize = 0;
   char* ptr = (char*)malloc(1);
   char * tmp;
   char tmp2[10000]; // <-- RECHECK 

   *ptr = 0;
   int i=0;
   AnsiString s;
   AnsiString xtmp;
   AnsiString stmp = "  ";

   strcpy(tmp2,script);
//   memcpy(tmp2,script,strlen(script));

   while(1)
   {
       // To get one script line
       char c;
       s = "";
       i=0;
       size=0;

       do
       {
         c = tmp2[i];
         s = s + c;
         i++;
       }while(c!=0xA);

       tmp = strchr(tmp2,0xA);
       size+= strlen(tmp)+1;

       // take \n from the pointer
       for(int i=1; i<size; i++)
       {
          tmp[i-1] = tmp[i];
       }

       strcpy(tmp2,tmp);
       //memcpy(tmp2,tmp,strlen(tmp));
       stmp = s;

       if(stmp[1]==' ')
       {
          do
          {
              xtmp = stmp.SubString(2,stmp.Length());
              stmp = xtmp;
          }while(stmp[1]==' ');
       }

       if(!(stmp[1]=='R' && stmp[2]=='E' && stmp[3]=='M'))
       {
          prtSize += s.Length();
          ptr = (char*)realloc(ptr,prtSize+1);
          strcat(ptr,s.c_str());
          if(s == "END\n")
              break;
       }
   }
   return ptr;
}

void saveTextScene(TScene Scene, char * fileName)
{
   char buffer[100000];

   FILE * sceneHandle;
   sceneHandle = fopen(fileName,"wb");

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

   sprintf(buffer,"amb1_1: %d",Scene.Amb1_1);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb1_2: %d",Scene.Amb1_2);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb1_3: %d",Scene.Amb1_3);
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

   sprintf(buffer,"amb3_1: %d",Scene.Amb3_1);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb3_2: %d",Scene.Amb3_2);
   fputs(buffer,sceneHandle);
   fputs("\n",sceneHandle);

   sprintf(buffer,"amb3_3: %d",Scene.Amb3_3);
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

   // TODO: REMOVE COMMENTS
   fputs("--> TRACK_PROG <--",sceneHandle);
   fputs("\n",sceneHandle);
   sprintf(buffer,removeComments(Scene.Hero.trackScript));
   fputs(buffer,sceneHandle);

   fputs("--> LIFE_PROG <--",sceneHandle);
   fputs("\n",sceneHandle);
   sprintf(buffer,removeComments(Scene.Hero.lifeScript));
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
       sprintf(buffer,removeComments(Scene.Actors[a].trackScript));
       fputs(buffer,sceneHandle);
       fputs("--> LIFE_PROG <--",sceneHandle);
       fputs("\n",sceneHandle);
       sprintf(buffer,removeComments(Scene.Actors[a].lifeScript));
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

