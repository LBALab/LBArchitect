# Little Big Architect

This suite is a set of programs, which purpose is to mod(ify) the Little Big Aventure 1 and 2 games.

They allow you to edit isometric sceneries, i.e. grid and scene files containing islands (exteriors) and rooms (interiors) in LBA 1. In LBA 2 only interior sceneries can be edited, because exteriors are in different format (3D).

This program is released under GNU GPL license.

Homepage: http://moonbase.kaziq.net

## General information

There suite consists of three programs:

1. Factory - Editor for Brick and Layout files from LBA 1 and 2. It can read whole hqr files and single brk and bl1/bl2 files. Can export images into bitmaps.
* Brk files are Bricks. You can find them in lba\_brk.hqr form Lba 1 and lba\_bkg.hqr from LBA 2
* Bl1 files are LBA1 Layout Libraries, you can find them in lba\_bll.hqr
* Bl2 files are LBA2 Layout Libraries, you can find them in lba\_bkg.hqr
* Latest version of LBA Package Editor unpacks all these files with appropriate extensions (except for bl1/bl2 - unfortunately version 0.10+ unpacks them all with "bll" extension)
* To display a library file a Brick package must be loaded. If there is a single Brick loaded instead of a Brick package, you will not be able to see the Layouts even if they are opened.
2. Builder - Editor for Grid and Scene files from LBA 1 and 2. Needs Brick, Library and Grid files to be loaded at the same time (lba\_brk + lba\_bll + lba\_gri or lba\_bkg). You can set paths to original Lba files in the View->Settings menu. It can export rooms/islands into bitmaps.
3. Designer - Tool for creating complete HQR packages from separate Grid, Layout, Grick and Scene files. The generated HQR can be used in LBA 1 game directly. The program cannot yet create files for LBA 2, because of the unsupported 3D-Scene format.

## Known issues

#### Builder:

* It sometimes happens that the program will crash without reason when following specific steps:

  1. Single Bricks selection mode has to be enabled.
  2. Go to Hand mode.
  3. Go to Placer mode and change the selection mode to "Select by Layouts"
  4. The program will crash when you try to click anything.

I've got that report from one person only (it happened to him many times), so I suspect it might be a machine-specific issue, because I can't reproduce it.

* 3d helper may be drawn incorrectly near the background net.

## Building from source

The programs have been written using Turbo Delphi 2006 IDE, which is very hard to install and use nowadays, but it's possible. Below is a list of problems and possible workarounds when building the programs.
1. Builder - no known problems.
2. Designer:
* Compilation fails because Components\MPEasyListView\Source\Compilers.inc cannot be found, despite the fact that the file is there. The problem seems to be caused by a bug in Turbo Delphi running in Windows 11, where it blocks the file for exclusive access, never releases it, and then tries to access it again. A workaround is to set the Components directory to Read Only in Windows Explorer.
* Compilation fails because 'tutaj' identifier is undeclared in Main.pas on line 265. This is an artifact of me having started to make changes to Designer and never finishing them. 'Tutaj' means 'here' - it's a marker for me to remember where I should continue to make changes. Unfortunately I did this before I started using version control systems, so after so many years I have no idea what the changes were. The program will build and run fine if you comment out the word 'tutaj', but some functions will probably work incorrectly or not at all, because they are work in progress.
3. Factory - no known problems.

## Thanks to

* AlexFont - for making information about lba\_gri and lba\_bkg files
* OBrasilo - for pointing some issues out
* Peter Below (TeamB) - for explanation about sending Windows messages
* Various people - for reporting bugs

