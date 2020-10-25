unit OpenDirectory;

interface

uses
  SysUtils, Classes, Dialogs, ShlObj, ComObj, Forms, Windows;

type
  TDirOption = (odOnlyComputers,   // = BIF_BROWSEFORCOMPUTER,
                odOnlyPrinters,    // = BIF_BROWSEFORPRINTER,
                odIncludeFiles,    // = BIF_BROWSEINCLUDEFILES
                odIncludeUrls,     // = BIF_BROSWEINCLUDEURLS
                odNoBelowDomain,   // = BIF_DONTGOBELOWDOMAIN,
                odEditBox,         // = BIF_EDITBOX
                odOnlyRoots,       // = BIF_RETURNFSANCESTORS,
                odOnlyFileSystem,  // = BIF_RETURNONLYFSDIRS,
                odShareable,       // = BIF_SHAREABLE
                odShowStatusText,  // = BIF_STATUSTEXT,
                odNewStyleDialog,  // = BIF_NEWDIALOGSTYLE
                odUseNewUI,        // = BIF_USENEWUI
                odValidate);       // = BIF_VALIDATE
                
  TDirOptions = set of TDirOption;

  TDirRoot = (rtAltStartup,       // = CSIDL_ALTSTARTUP,
              rtAppData,          // = CSIDL_APPDATA,
              rtRecycleBin,       // = CSIDL_BITBUCKET,
              rtCommonAltStartup, // = CSIDL_COMMON_ALTSTARTUP,
              rtCommonDesktopDir, // = CSIDL_COMMON_DESKTOPDIRECTORY,
              rtCommonFavorites,  // = CSIDL_COMMON_FAVORITES,
              rtCommonPrograms,   // = CSIDL_COMMON_PROGRAMS,
              rtCommonStartMenu,  // = CSIDL_COMMON_STARTMENU,
              rtCommonStartup,    // = CSIDL_COMMON_STARTUP,
              rtControlPanel,     // = CSIDL_CONTROLS,
              rtCookies,          // = CSIDL_COOKIES,
              rtDesktop,          // = CSIDL_DESKTOP,
              rtDesktopDirectory, // = CSIDL_DESKTOPDIRECTORY,
              rtDrives,           // = CSIDL_DRIVES,
              rtFavorites,        // = CSIDL_FAVORITES,
              rtFonts,            // = CSIDL_FONTS,
              rtHistory,          // = CSIDL_HISTORY,
              rtInternet,         // = CSIDL_INTERNET,
              rtInternetCache,    // = CSIDL_INTERNET_CACHE,
              rtNetworkHood,      // = CSIDL_NETHOOD,
              rtNetwork,          // = CSIDL_NETWORK,
              rtPersonal,         // = CSIDL_PERSONAL,
              rtPrinters,         // = CSIDL_PRINTERS,
              rtPrintHood,        // = CSIDL_PRINTHOOD,
              rtPrograms,         // = CSIDL_PROGRAMS,
              rtRecent,           // = CSIDL_RECENT,
              rtSendTo,           // = CSIDL_SENDTO,
              rtStartMenu,        // = CSIDL_STARTMENU,
              rtAStartup,         // = CSIDL_STARTUP,
              rtTemplates);       // = CSIDL_TEMPLATES);

  TDirParam = record
   OwnerHandle: HWND;
   StartDir: PItemIdList;
  end;

type
  TOpenDirectory = class(TCommonDialog)
  private
   FDirName: String;
   FDirOptions: TDirOptions;
   FStatusText: String;
   FDirRoot: TDirRoot;
   function PathToItemIDList(const APath: WideString): PItemIDList;
   function GetDirOptions: Integer;
   function GetDirRoot: Integer;
  public
   constructor Create(AOwner: TComponent); override;
   Function Execute: Boolean; override;
  published
   property DirName: String read FDirName write FDirName;
   property Options: TDirOptions read FDirOptions write FDirOptions
    default [odOnlyFileSystem, odNoBelowDomain, odShowStatusText, odNewStyleDialog];
   property StatusText: String read FStatusText write FStatusText;
   property RootDir: TDirRoot read FDirRoot write FDirRoot default rtDesktop;
  end;

  EInvalidParent = class(Exception);

procedure Register;

implementation

uses Controls;

{$R OpenDirectory.res}

procedure Register;
begin
  RegisterComponents('Samples', [TOpenDirectory]);
end;

function TOpenDirectory.PathToItemIDList(const APath: WideString): PItemIDList;
var
 DesktopFolder: IShellFolder;
 SLen, FAttr: Cardinal;
begin
 Result := nil;
 if APath <> '' then
 begin
  OleCheck(SHGetDesktopFolder(DesktopFolder));
  DesktopFolder.ParseDisplayName(Application.Handle, nil, PWideChar(APath), SLen, Result, FAttr);
 end;
end;

function BrowseCallbackProc(Wnd: HWnd; Msg: UINT; LParam: LPARAM;
 LpData: LPARAM): Integer; stdcall;

 procedure CenterWindow;
 var
  Rect, Rect1: TRect;
 begin
  GetWindowRect(TDirParam(Pointer(LpData)^).OwnerHandle, Rect1);
  GetWindowRect(Wnd, Rect);
  SetWindowPos(Wnd, 0,
   ((Rect1.Right+Rect1.Left)-(Rect.Right-Rect.Left)) div 2,
   ((Rect1.Bottom+Rect1.Top)-(Rect.Bottom-Rect.Top)) div 2,
   0, 0, SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER);
 end;

begin
 Result:=0;
 try
  If Msg = BFFM_INITIALIZED then begin
   SendMessage(Wnd, BFFM_SETSELECTION, 0, Longint(TDirParam(Pointer(LpData)^).StartDir));
   CenterWindow;
  end;
 except
  Application.HandleException(TObject(LParam));
 end;
end;

function TOpenDirectory.GetDirOptions: Integer;
begin
 Result:= 0;
 If (odOnlyComputers in FDirOptions)  then Result:= Result + BIF_BROWSEFORCOMPUTER;
 If (odOnlyPrinters in FDirOptions)   then Result:= Result + BIF_BROWSEFORPRINTER;
 If (odIncludeFiles in FDirOptions)   then Result:= Result + BIF_BROWSEINCLUDEFILES;
 If (odIncludeUrls in FDirOptions)    then Result:= Result + BIF_BROWSEINCLUDEURLS;
 If (odNoBelowDomain in FDirOptions)  then Result:= Result + BIF_DONTGOBELOWDOMAIN;
 If (odEditBox in FDirOptions)        then Result:= Result + BIF_EDITBOX;
 If (odOnlyRoots in FDirOptions)      then Result:= Result + BIF_RETURNFSANCESTORS;
 If (odOnlyFileSystem in FDirOptions) then Result:= Result + BIF_RETURNONLYFSDIRS;
 If (odShareable in FDirOptions)      then Result:= Result + BIF_SHAREABLE;
 If (odShowStatusText in FDirOptions) then Result:= Result + BIF_STATUSTEXT;
 If (odNewStyleDialog in FDirOptions) then Result:= Result + BIF_NEWDIALOGSTYLE;
 If (odUseNewUI in FDirOptions)       then Result:= Result + BIF_USENEWUI;
 If (odValidate in FDirOptions)       then Result:= Result + BIF_VALIDATE;
end;

function TOpenDirectory.GetDirRoot: Integer;
begin
 case FDirRoot of
  rtAltStartup:       Result:= CSIDL_ALTSTARTUP;
  rtAppData:          Result:= CSIDL_APPDATA;
  rtRecycleBin:       Result:= CSIDL_BITBUCKET;
  rtCommonAltStartup: Result:= CSIDL_COMMON_ALTSTARTUP;
  rtCommonDesktopDir: Result:= CSIDL_COMMON_DESKTOPDIRECTORY;
  rtCommonFavorites:  Result:= CSIDL_COMMON_FAVORITES;
  rtCommonPrograms:   Result:= CSIDL_COMMON_PROGRAMS;
  rtCommonStartMenu:  Result:= CSIDL_COMMON_STARTMENU;
  rtCommonStartup:    Result:= CSIDL_COMMON_STARTUP;
  rtControlPanel:     Result:= CSIDL_CONTROLS;
  rtCookies:          Result:= CSIDL_COOKIES;
  rtDesktop:          Result:= CSIDL_DESKTOP;
  rtDesktopDirectory: Result:= CSIDL_DESKTOPDIRECTORY;
  rtDrives:           Result:= CSIDL_DRIVES;
  rtFavorites:        Result:= CSIDL_FAVORITES;
  rtFonts:            Result:= CSIDL_FONTS;
  rtHistory:          Result:= CSIDL_HISTORY;
  rtInternet:         Result:= CSIDL_INTERNET;
  rtInternetCache:    Result:= CSIDL_INTERNET_CACHE;
  rtNetworkHood:      Result:= CSIDL_NETHOOD;
  rtNetwork:          Result:= CSIDL_NETWORK;
  rtPersonal:         Result:= CSIDL_PERSONAL;
  rtPrinters:         Result:= CSIDL_PRINTERS;
  rtPrintHood:        Result:= CSIDL_PRINTHOOD;
  rtPrograms:         Result:= CSIDL_PROGRAMS;
  rtRecent:           Result:= CSIDL_RECENT;
  rtSendTo:           Result:= CSIDL_SENDTO;
  rtStartMenu:        Result:= CSIDL_STARTMENU;
  rtAStartup:         Result:= CSIDL_STARTUP;
  rtTemplates:        Result:= CSIDL_TEMPLATES;
  else Result:= CSIDL_DESKTOP;
 end;
end;

constructor TOpenDirectory.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 Options:=[odOnlyFileSystem, odNoBelowDomain, odShowStatusText, odNewStyleDialog];
 RootDir:=rtDesktop;
end;

Function TOpenDirectory.Execute: Boolean;
var BI: TBrowseInfo;
    Buf: PChar;
    Dir, root: PItemIDList;
    Handle: HWND;
    DirParam: TDirParam;
begin
 Result:= False;

 If Owner is TWinControl then
  Handle:=(Owner as TWinControl).Handle
 else
  raise EInvalidParent.Create('Owner must be of class TWinControl or its ancestor');

 GetMem(Buf,Max_Path);
 SHGetSpecialFolderLocation(Handle,GetDirRoot,root);
 DirParam.OwnerHandle:=Handle;
 DirParam.StartDir:=PathToItemIDList(FDirName);
 with BI do begin
  hwndOwner:= Handle;
  pidlRoot:= root;
  pszDisplayName:= Buf;
  lpszTitle:= PChar(StatusText);
  ulFlags:= GetDirOptions;
  lpfn:= BrowseCallbackProc;
  lParam:= Integer(@DirParam);
 end;
 Dir:=SHBrowseForFolder(BI);
 If Dir<>nil then begin
  SHGetPathFromIDList(Dir,Buf);
  FDirName:=Buf;
  Result:= True;
 end;
 FreeMem(Buf);
end;

end.
