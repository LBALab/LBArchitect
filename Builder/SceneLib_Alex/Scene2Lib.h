/*
-------------------------[ LBA Story Coder Source ]--------------------------
Copyright (C) 2004-2005
-------------------------------[ SceneLib.h ]--------------------------------

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

#ifndef Scene2LibH
#define Scene2LibH

#include <stdio.h>
#include <vector>
#include <fstream.h>

//---------------------------------------------------------------------------

struct TActor2{
   char Name[256];
   unsigned short staticFlag;
   unsigned short unknown; // LBA2 flags ???
   unsigned short Entity;
   Byte Body;
   Byte Animation;
   unsigned short SpriteEntry;
   unsigned short X;
   unsigned short Y;
   unsigned short Z;
   Byte StrengthOfHit;
   unsigned short BonusParameter;
   unsigned short Angle;
   unsigned short SpeedRotation;
   unsigned short Behaviour;
   unsigned short cropLeft;
   unsigned short cropTop;
   unsigned short cropRight;
   unsigned short cropBottom;
   Byte BonusAmount;
   Byte TalkColor;
   Byte Armour;
   Byte LifePoints;

   char * track2Script;
   char * life2Script;
};

struct TZone2{
   unsigned short X0;
   unsigned short unknown1;
   unsigned short Y0;
   unsigned short unknown2;
   unsigned short Z0;
   unsigned short unknown3;
   unsigned short X1;
   unsigned short unknown4;
   unsigned short Y1;
   unsigned short unknown5;
   unsigned short Z1;
   unsigned short unknown6;
   unsigned short Type;
   unsigned short unknown7;
   unsigned short Info0;
   unsigned short unknown8;
   unsigned short Info1;
   unsigned short unknown9;
   unsigned short Info2;
   unsigned short unknown10;
   unsigned short Info3;
   unsigned short unknown11;
   unsigned short Info4;
   unsigned short unknown12;
   unsigned short Info5;
   unsigned short unknown13;
   unsigned short Info6;
   unsigned short unknown14;
   unsigned short Snap;
   unsigned short unknown15;
};

struct TTrack2{
   unsigned short X;
   unsigned short unknown1;
   unsigned short Y;
   unsigned short unknown2;
   unsigned short Z;
   unsigned short unknown3;
   int Num;
};

struct THero2{
   unsigned short X;
   unsigned short Y;
   unsigned short Z;
   char * track2Script;
   char * life2Script;
};

struct TScene2{
   Byte TextBank;
   Byte CubeEntry;
   unsigned short AlphaLight;
   unsigned short BetaLight;
   unsigned short Amb0_1;
   unsigned short Amb0_2;
   unsigned short Amb0_3;
   unsigned short Amb1_1;
   unsigned short Amb1_2;
   unsigned short Amb1_3;
   unsigned short Amb2_1;
   unsigned short Amb2_2;
   unsigned short Amb2_3;
   unsigned short Amb3_1;
   unsigned short Amb3_2;
   unsigned short Amb3_3;
   unsigned short Amb4_1;
   unsigned short Amb4_2;
   unsigned short Amb4_3;
   unsigned short Amb5_1;
   unsigned short Amb5_2;
   unsigned short Amb5_3;
   unsigned short Second_Min;
   unsigned short Second_Ecart;
   Byte CubeMusic;

   THero2 Hero;

   unsigned short numActors;
   vector<TActor2> Actors;
   unsigned short numZones;
   vector<TZone2> Zones;
   unsigned short numTracks;
   vector<TTrack2> Tracks;
};

struct TScript2{
   unsigned short numOffsets;
   unsigned char * script;
};

//---------------------------------------------------------------------------

// Binary Scenes
// Decompilation routines
TScene2 loadBinaryScene2(char* fileName);
char * decompTrack2Script(unsigned char *scriptPtr);
void decompConditions2(unsigned char **scriptPtr, char *buffer);
void decompOperators2(unsigned char **scriptPtr, char *buffer);
void resolveOffsets2(unsigned char * scenePtr);
void setComportement2ObjectIndex(int numActor, unsigned short numBytes, unsigned char * ptr);
void setTrack2ObjectIndex(int numActor, unsigned short numBytes, unsigned char * ptr);
int getComportement2Index(short int comportement[50], short int offset);
int getComportement2ObjectIndex(short int offset, int numActor);
int getTrack2ObjectIndex(short int offset, int numActor);
void indentScript2(unsigned short indent);
bool findOffset2(unsigned short indentIndex, unsigned short indentOffsets[500], unsigned short currentOffset);
char * decompLife2Script(unsigned char *scriptPtr, int lifeBytes, unsigned char *trackPtr);
// Compilation routines
void saveBinaryScene2(TScene2 Scene, char* fileName);
int getTrack2Index(char* lineBuffer);
void compTrack2(char * script, FILE* sceneHandle);
void getScriptLine2(char* script,char* buffer, int line);

// Text Scenes - Only This :)
TScene2 loadTextScene2(char* fileName);
char* getTrack2Script(FILE* sceneHandle);
char* getLife2Script(FILE* sceneHandle);
void saveTextScene2(TScene2 Scene, char * fileName);

#endif


