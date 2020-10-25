------------------------------------------------------------------------
Little Big Architect

     Version: 1.1
Release date: 01.06.2020
      Status: Freeware (GNU GPL license)
      Author: kazink@gmail.com           <- feedback is welcome
    Homepage: http://moonbase.kazekr.net <- latest stable version is always there first
  Bugtracker: Not available any more. Drop me an e-mail

 This program allows you to edit Grid files (*.gr1 and *.gr2) that
contain islands and rooms in Lba 1 and rooms only in Lba 2.

Copyright 2004/2020 Zink

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details (License.txt).

 Thanks to: 
  AlexFont - for making information about lba_gri and lba_bkg files
  OBrasilo - for pointing some issues out
  Peter Below (TeamB) - for explanation about sending Windows messages
  Various people - for reporting bugs
------------------------------------------------------------------------


 General information:
======================

 There are three programs:

 Factory.exe - Editor for Brick files and Layout files from LBA 1 and 2. It can read whole hqr files and single brk and bl1/bl2 files. Can export images into bitmaps. 
  Brk files are Bricks. You can find them in lba_brk.hqr form Lba 1 and lba_bkg.hqr from Lba 2. 
  Bl1 files are LBA1 Layout Libraries, you can find them in lba_bll.hqr. 
  Bl2 files are LBA2 Layout Libraries, you can find them in lba_bkg.hqr. 
  Latest version of LBA Package Editor unpacks all these files with appropriate extensions (except for Bl1/Bl2 - unfortunately version 0.10+ unpacks them all with "bll" extension.
 To display a library file a Brick package must be loaded. If there is a single Brick loaded instead of Brick package, you will not be able to see the Layouts even if they are opened.

 Builder.exe - Editor for grid files from LBA 1 and 2. Needs brick, library and grid files to be loaded at the same time (lba_brk+lba_bll+lba_gri or lba_bkg). You can set paths to original Lba files in the View->Settings menu. It can export rooms/islands into bitmaps. 
 It is able to cooperate with LBA Story Coder (written by Alexfont), so Scenes can be edited visually.
 
 Designer.exe - Tool for creating complete HQR packages, that contain rooms and scenes, and are ready to use in LBA 1. The program cannot yet create files for LBA 2.

 Short manuals for all the program are in the \help directory.

 
 Known bugs and issues:
========================

Builder:

 - It sometimes happens that the program will crash without reason when following specific steps:
    1. Single Bricks selection mode has to be enabled.
    2. Go to Hand mode.
    3. Go to Placer mode and change the selection mode to "Select by Layouts"
    4. The program will crash when you try to click anything.
   I've got that report from one person only (it happened to him many times), so I suspect it might be a machine-specific issue, because I can't reproduce it.

 - 3d helper may be drawn incorrectly near the background net.
