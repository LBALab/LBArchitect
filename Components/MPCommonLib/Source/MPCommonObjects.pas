unit MPCommonObjects;

// Version 2.1.0
//
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
//
// Alternatively, you may redistribute this library, use and/or modify it under the terms of the
// GNU Lesser General Public License as published by the Free Software Foundation;
// either version 2.1 of the License, or (at your option) any later version.
// You may obtain a copy of the LGPL at http://www.gnu.org/copyleft/.
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
// specific language governing rights and limitations under the License.
//
// The initial developer of this code is Jim Kueneman <jimdk@mindspring.com>
// Special thanks to the following in no particular order for their help/support/code
//    Danijel Malik, Robert Lee, Werner Lehmann, Alexey Torgashin, Milan Vandrovec
//
// Portions provided by Derek Moore of Alastria Software
//
//----------------------------------------------------------------------------

interface

{$I Compilers.inc}
{$I Options.inc}
{$I ..\Include\Addins.inc}

{$ifdef COMPILER_12_UP}
  {$WARN IMPLICIT_STRING_CAST       OFF}
 {$WARN IMPLICIT_STRING_CAST_LOSS  OFF}
{$endif COMPILER_12_UP}

uses
  {$IFDEF COMPILER_10_UP}
  Types,
  {$ENDIF}
  Windows,
  Messages,
  Classes,
  Controls,
  Graphics,
  SysUtils,
  ActiveX,
  CommCtrl,
  Forms,
  ComCtrls,
  ExtCtrls,
  {$IFDEF COMPILER_6_UP}
  RTLConsts,
  {$ELSE}
  Consts,
  {$ENDIF}
  {$IFDEF COMPILER_7_UP}
  Themes,
  UxTheme,
  {$ELSE}
    {$IFDEF USETHEMES}
    TmSchema,
    UxTheme,
    {$ENDIF}
  {$ENDIF}
  {$IFDEF TNTSUPPORT}
    TntClasses,
    {$IFDEF COMPILER_10_UP}
    WideStrings,
    {$ELSE}
    TntWideStrings,
    {$ENDIF}
  {$ENDIF}
  ShlObj,
  ShellAPI,
  ImgList,
  TypInfo,
  MPShellTypes,
  MPResources;

const
  IID_ICommonExtractObj = '{7F667930-E47B-4474-BA62-B100D7DBDA70}';

type
  TILIsParent = function(PIDL1: PItemIDList; PIDL2: PItemIDList;
    ImmediateParent: LongBool): LongBool; stdcall;
  TILIsEqual = function(PIDL1: PItemIDList; PIDL2: PItemIDList): LongBool; stdcall;

  TCommonImageIndexInteger = type Integer;

  TStringListEx = class(TStringList)
  private
    {$IFNDEF COMPILER_7_UP}
    FNameValueSeparator: Char;

    function GetNameValueSeparator: Char;
    function GetValueFromIndex(Index: Integer): string;
    procedure SetNameValueSeparator(const Value: Char);
    procedure SetValueFromIndex(Index: Integer; const Value: string);
    {$ENDIF}
  public
    {$IFNDEF COMPILER_7_UP}
    property ValueFromIndex[Index: Integer]: string read GetValueFromIndex write SetValueFromIndex;
    property NameValueSeparator: Char read GetNameValueSeparator write SetNameValueSeparator;
    {$ENDIF}
  end;

type
  TCommonPIDLManager = class;  // forward
  TCommonPIDLList = class;     // forward

  TPIDLArray = array of PItemIDList;
  TRelativePIDLArray = TPIDLArray;
  TAbsolutePIDLArray = TPIDLArray;

  PPIDLRawArray = ^TPIDLRawArray;
  TPIDLRawArray = array[0..0] of PItemIDList;

  ICommonExtractObj = interface
  [IID_ICommonExtractObj]
    function GetObj: TObject;
    property Obj: TObject read GetObj;
  end;

  // In the ShellContextMenu items may be removed by not supplying the menu with
  // these items.  Note that by including them is DOES not mean that the items will
  // in the menu.  If the items do not support the action the shell with automatically
  // remove the items.
  TCommonShellContextMenuAction = (
    cmaCopy,
    cmaCut,
    cmaPaste,
    cmaDelete,
    cmaRename,
    cmaProperties,
    cmaShortCut
  );
  TCommonShellContextMenuActions = set of TCommonShellContextMenuAction;

  TCommonShellContextMenuExtension = (
    cmeAllFilesystemObjects, // Add the Menu Extensions registered under HKEY_CLASSES_ROOT\AllFilesystemObjects such as Send To item
    cmeDirectory,      // Add the Menu Extensions registered under HKEY_CLASSES_ROOT\Directory
    cmeDirBackground,  // Add the Menu Extensions registered under HKEY_CLASSES_ROOT\Directory\Background
    cmeFolder,         // Add the Menu Extensions registered under HKEY_CLASSES_ROOT\Folder
    cmeAsterik,        // Add the Menu Extensions registered under HKEY_CLASSES_ROOT\*
    cmeShellDefault,   // Adds special actions like, Explore, Open, Search...,  it depends on what other cme_ types are set, such as the Open/Explore Items
    cmePerceivedType   // Checks for a PerceivedType string in the extension key {.ext} that points to a key in the HKEY_CLASSES_ROOT\FileSystemAssociations\SomePerceivedType such as "image".  Will add the "Print" item
  );
  TCommonShellContextMenuExtensions = set of TCommonShellContextMenuExtension;

  //
  // Encapsulates Theme handles for various objects
  //
  {$IFDEF USETHEMES}
  TCommonThemeManager = class
  private
    FButtonTheme: HTHEME;    // Some useful Themes
    FComboBoxTheme: HTHEME;
    FEditTheme: HTHEME;
    FExplorerBarTheme: HTHEME;
    FHeaderTheme: HTHEME;
    FListviewTheme: HTHEME;
    FLoaded: Boolean;
    FOwner: TWinControl;
    FProgressTheme: HTHEME;
    FRebarTheme: HTHEME;
    FScrollbarTheme: HTheme;
    FTaskBandTheme: HTHEME;
    FTaskBarTheme: HTHEME;
    FTreeviewTheme: HTHEME;
    FWindowTheme: HTHEME;
  public
    constructor Create(AnOwner: TWinControl);
    destructor Destroy; override;

    procedure ThemesFree; dynamic;
    procedure ThemesLoad; dynamic;

    property ButtonTheme: HTHEME read FButtonTheme write FButtonTheme;
    property ComboBoxTheme: HTHEME read FComboBoxTheme write FComboBoxTheme;
    property EditThemeTheme: HTHEME read FEditTheme write FEditTheme;
    property ExplorerBarTheme: HTHEME read FExplorerBarTheme write FExplorerBarTheme;
    property HeaderTheme: HTHEME read FHeaderTheme write FHeaderTheme;
    property ListviewTheme: HTHEME read FListviewTheme write FListviewTheme;
    property Loaded: Boolean read FLoaded;
    property Owner: TWinControl read FOwner;
    property ProgressTheme: HTHEME read FProgressTheme write FProgressTheme;
    property RebarTheme: HTHEME read FRebarTheme write FRebarTheme;
    property ScrollbarTheme: HTheme read FScrollbarTheme write FScrollbarTheme;
    property TaskBandTheme: HTHEME read FTaskBandTheme write FTaskBandTheme;
    property TaskBarTheme: HTHEME read FTaskBarTheme write FTaskBarTheme;
    property TreeviewTheme: HTHEME read FTreeviewTheme write FTreeviewTheme;
    property WindowTheme: HTHEME read FWindowTheme write FWindowTheme;
  end;
  {$ENDIF USETHEMES}

  //
  // TWinControl that has a canvas and a few methods/properites for
  // locking the canvas for higher performance drawing.  Also handles
  // XP and above theme support
  //

  TCommonMouseEnterEvent = procedure(Sender: TObject; MousePos: TPoint) of object;

  TCommonCanvasControl = class(TCustomControl)
  private
    FBackBits: TBitmap;
    FBorderStyle: TBorderStyle;
    FCacheDoubleBufferBits: Boolean;
    FCanvas: TControlCanvas;
    FForcePaint: Boolean;
    FImagesExtraLarge: TImageList;
    FImagesLarge: TImageList;
    FImagesSmall: TImageList;
    FMouseEnterExitNotifyEnabled: Boolean;
    FMouseInWindow: Boolean;
    FMouseTimer: TTimer;
    FNCCanvas: TCanvas;
    FOnBeginUpdate: TNotifyEvent;
    FOnEndUpdate: TNotifyEvent;

    FOnMouseEnter: TCommonMouseEnterEvent;
    FOnMouseExit: TNotifyEvent;
    FShowThemedBorder: Boolean;
    {$IFDEF USETHEMES}FThemes: TCommonThemeManager;{$ENDIF USETHEMES}
    function GetCanvas: TControlCanvas;
    function GetThemed: Boolean;
    procedure SetBorderStyle(const Value: TBorderStyle);
    procedure SetCacheDoubleBufferBits(const Value: Boolean);
    procedure SetShowThemedBorder(const Value: Boolean);
    procedure SetThemed(const Value: Boolean);
  protected
    FThemed: Boolean;
    FUpdateCount: Integer;
    procedure AfterPaintRect(ACanvas: TCanvas; ClipRect: TRect); virtual;
    procedure CalcThemedNCSize(var ContextRect: TRect); virtual;
    procedure CMColorChange(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMCtl3DChanged(var Msg: TMessage); message CM_Ctl3DChanged;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMParentFontChanged(var Message: TMessage); message CM_PARENTFONTCHANGED;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DoBeginUpdate; virtual;
    procedure DoEndUpdate;
    procedure DoMouseEnter(MousePos: TPoint); virtual;
    procedure DoMouseExit; virtual;
    procedure DoMouseTrack(MousePos: TPoint); virtual;
    procedure DoPaintRect(ACanvas: TCanvas; ClipRect: TRect; SelectedOnly: Boolean; ClipRectInViewPortCoords: Boolean = False); virtual;
    procedure DoUpdate; virtual;
    procedure KillMouseInWindowTimer;
    procedure MouseTimerProc(Sender: TObject);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure PaintThemedNCBkgnd(ACanvas: TCanvas; ARect: TRect); virtual;
    procedure ResizeBackBits(NewWidth, NewHeight: Integer);
    procedure ValidateBorder;
    procedure WMDestroy(var Msg: TMessage); message WM_DESTROY;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMMouseMove(var Msg: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMNCCalcSize(var Msg: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCPaint(var Msg: TWMNCPaint); message WM_NCPAINT;
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    {$IFDEF USETHEMES}procedure WMThemeChanged(var Message: TMessage); message WM_THEMECHANGED;{$ENDIF USETHEMES}
    property BackBits: TBitmap read FBackBits write FBackBits;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property CacheDoubleBufferBits: Boolean read FCacheDoubleBufferBits write SetCacheDoubleBufferBits default False;
    property MouseInWindow: Boolean read FMouseInWindow write FMouseInWindow;
    property MouseTimer: TTimer read FMouseTimer write FMouseTimer;
    property NCCanvas: TCanvas read FNCCanvas write FNCCanvas;
    property OnBeginUpdate: TNotifyEvent read FOnBeginUpdate write FOnBeginUpdate;
    property OnEndUpdate: TNotifyEvent read FOnEndUpdate write FOnEndUpdate;
    property OnMouseEnter: TCommonMouseEnterEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseExit: TNotifyEvent read FOnMouseExit write FOnMouseExit;
    property ShowThemedBorder: Boolean read FShowThemedBorder write SetShowThemedBorder default True;
    property Themed: Boolean read GetThemed write SetThemed default True;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure BeginUpdate; virtual;
    function DrawWithThemes: Boolean;
    procedure EndUpdate(Invalidate: Boolean = True); virtual;
    procedure Loaded; override;
    procedure PaintToRect(ACanvas: TCanvas; Rect: TRect; ClipRectInViewPortCoords: Boolean = True);
    procedure SafeInvalidateRect(ARect: PRect; ImmediateUpdate: Boolean);

    property Canvas: TControlCanvas read GetCanvas write FCanvas;
    property Color;
    property DragCursor;
    property DragMode;
    property ForcePaint: Boolean read FForcePaint write FForcePaint;
    {$IFDEF USETHEMES}property Themes: TCommonThemeManager read FThemes;{$ENDIF USETHEMES}
    property UpdateCount: Integer read FUpdateCount;
  published
  end;

  //
  //  Stores the state of a TCanvas so it may be restored later
  //
  TCommonDefaultCanvasState = class
  private
    FBkMode: Longword;
    FFont: TFont;
    FBrush: TBrush;
    FPen: TPen;
    FCanvasStored: Boolean;
    FCopyMode: TCopyMode;
    FPenPos: TPoint;
    FTextFlags: Integer;
    function GetBrush: TBrush;
    function GetFont: TFont;
    function GetPen: TPen;
  public
    destructor Destroy; override;

    procedure StoreCanvas(ACanvas: TCanvas);
    procedure RestoreCanvas(ACanvas: TCanvas);

    property BkMode: Longword read FBkMode;
    property CanvasStored: Boolean read FCanvasStored;
    property CopyMode: TCopyMode read FCopyMode;
    property Font: TFont read GetFont;
    property Brush: TBrush read GetBrush;
    property Pen: TPen read GetPen;
    property PenPos: TPoint read FPenPos;
    property TextFlags: Integer read FTextFlags;
  end;

  //
  //  A specialized TList that contains PItemID's
  //
  PCommonPIDLList = ^TCommonPIDLList;
  TCommonPIDLList = class(TList)
  private
    FLocalPIDLMgr: TCommonPIDLManager;  // this can be in an IDataObject that the shell holds on to, causing our global PIDLMgr to be freed on application destroy before the shell releases the IDataObject
    FName: WideString;       // user Data
    FSharePIDLs: Boolean;    // If true the class will not free the PIDL's automaticlly when destroyed
    FDestroying: Boolean;  // Instance of a PIDLManager used to easily deal with the PIDL's
    function GetPIDL(Index: integer): PItemIDList;
  protected
    property Destroying: Boolean read FDestroying;
    property LocalPIDLMgr: TCommonPIDLManager read FLocalPIDLMgr write FLocalPIDLMgr;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear; override;
    procedure CloneList(PIDLList: TCommonPIDLList);
    function CopyAdd(PIDL: PItemIDList): Integer;
    function FindPIDL(TestPIDL: PItemIDList): Integer;
    function LoadFromStream( Stream: TStream): Boolean; virtual;
    function SaveToStream( Stream: TStream): Boolean; virtual;
    procedure StripDesktopPIDLs;
    property Name: WideString read FName write FName;
    property SharePIDLs: Boolean read FSharePIDLs write FSharePIDLs;
  end;

  //
  // TCoolPIDLManager is a class the encapsulates PIDLs and makes them easier to
  // handle.
  //
  TCommonPIDLManager = class
  private
  protected
    FMalloc: IMalloc;  // The global Memory allocator
  public
    constructor Create;
    destructor Destroy; override;

    function AllocGlobalMem(Size: Integer): PByte;
    function AllocStrGlobal(SourceStr: WideString): POleStr;
    function AppendPIDL(DestPIDL, SrcPIDL: PItemIDList): PItemIDList;
    function BindToParent(AbsolutePIDL: PItemIDList; var Folder: IShellFolder): Boolean;
    function CopyPIDL(APIDL: PItemIDList): PItemIDList;
    function EqualPIDL(PIDL1, PIDL2: PItemIDList): Boolean;
    procedure FreeAndNilPIDL(var PIDL: PItemIDList);
    procedure FreeOLEStr(OLEStr: LPWSTR);
    procedure FreePIDL(PIDL: PItemIDList);
    function CopyLastID(IDList: PItemIDList): PItemIDList;
    function GetPointerToLastID(IDList: PItemIDList): PItemIDList;
    function IDCount(APIDL: PItemIDList): integer;
    function IsDesktopFolder(APIDL: PItemIDList): Boolean;
    function IsEmptyPIDL(APIDL: PItemIDList): Boolean;
    function IsSubPIDL(FullPIDL, SubPIDL: PItemIDList): Boolean;
    function NextID(APIDL: PItemIDList): PItemIDList;
    function PIDLSize(APIDL: PItemIDList): integer;
    function LoadFromStream(Stream: TStream): PItemIDList;
    procedure ParsePIDL(AbsolutePIDL: PItemIDList; var PIDLList: TCommonPIDLList; AllAbsolutePIDLs: Boolean);
    procedure ParsePIDLArray(PIDLArray: PPIDLRawArray; var PIDLList: TCommonPIDLList; Count: Integer; Relative, CopyPIDLs: Boolean);
    function StringToPIDL(PIDLStr: AnsiString): PItemIDList;
    function StripLastID(IDList: PItemIDList): PItemIDList; overload;
    function StripLastID(IDList: PItemIDList; var Last_CB: Word; var LastID: PItemIDList): PItemIDList; overload;
    procedure SaveToStream(Stream: TStream; PIDL: PItemIdList);

    property Malloc: IMalloc read FMalloc;
  end;

  //
  // Helper object to write basic property types to a Stream
  //
  TCommonMemoryStreamHelper = class
  public
    function ReadBoolean(S: TStream): Boolean;
    function ReadColor(S: TStream): TColor;
    function ReadInt64(S: TStream): Int64;
    function ReadInteger(S: TStream): Integer;
    function ReadString(S: TStream): AnsiString;
    function ReadWideString(S: TStream): WideString;
    function ReadExtended(S: TStream): Extended;
    procedure ReadStream(SourceStream, TargetStream: TStream);
 //   procedure ReadPublishedProperties(S: TStream; Instance: TObject; RecurseSubClasses: Boolean);
    procedure WriteBoolean(S: TStream; Value: Boolean);
    procedure WriteColor(S: TStream; Value: TColor);
    procedure WriteExtended(S: TStream; Value: Extended);
    procedure WriteInt64(S: TStream; Value: Int64);
    procedure WriteInteger(S: TStream; Value: Integer);
    procedure WriteStream(SourceStream, TargetStream: TStream);
//    procedure WritePublishedProperties(S: TStream; Instance: TObject; RecurseSubClasses: Boolean);
    procedure WriteString(S: TStream; Value: AnsiString);
    procedure WriteWideString(S: TStream; Value: WideString);
  end;

  //
  // MemoryStream that knows how to write/read basic data types
  //
  TCommonStream = class(TMemoryStream)
  public
    function ReadBoolean: Boolean;
    function ReadByte: Byte;
    function ReadInteger: Integer;
    function ReadString: AnsiString;
    function ReadStringList: TStringList;
    function ReadWideString: WideString;

    procedure WriteBoolean(Value: Boolean);
    procedure WriteByte(Value: Byte);
    procedure WriteInteger(Value: Integer);
    procedure WriteString(const Value: AnsiString);
    procedure WriteStringList(Value: TStringList);
    procedure WriteWideString(const Value: WideString);
  end;

  //
  // The dimension of the Marlett Checkbox Font
  //
  TCommonCheckBound = class
  private
    FBounds: TRect;
    FSize: Integer;
  public
    property Size: Integer read FSize write FSize;
    property Bounds: TRect read FBounds write FBounds;
  end;

  //
  // The Stores the dimensions for various sizes of the Marlett Checkbox Font
  //
  TCommonCheckBoundManager = class
  private
    FList: TList;
    function GetBound(Size: Integer): TRect;
    function GetCheckBound(Index: Integer): TCommonCheckBound;
  protected
    procedure Clear;
    function Find(Size: Integer): TCommonCheckBound;

    property List: TList read FList write FList;
    property CheckBound[Index: Integer]: TCommonCheckBound read GetCheckBound;
  public
    constructor Create;
    destructor Destroy; override;

    property Bound[Size: Integer]: TRect read GetBound;
  end;

  //
  // Encapsulates the System image lists
  //
  TSysImageListSize =  (
    sisSmall,    // Large System Images
    sisLarge,    // Small System Images
    sisExtraLarge, // Extra Large Images (48x48)
    sisJumbo       // Jumbo Images (256x256)    Becareful with this.  M$ has layed several traps in using this:
                   // http://blog.alastria.com/2009/07/27/the-windows-api-makers-have-lost-their-minds-part-17/
  );

  TCommonSysImages = class(TImageList)
  private
    FImageSize: TSysImageListSize;
    FJumboImages: IImageList;
    procedure SetImageSize(const Value: TSysImageListSize);
  protected
    procedure RecreateHandle;
    procedure Flush;
    property JumboImages: IImageList read FJumboImages;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property ImageSize: TSysImageListSize read FImageSize write SetImageSize;
  end;

{  TCommonHintWindow = class(THintWindow)
  private
    FAnsiCaption: string;
    FCaption: WideString;
    FNewLastActive: Cardinal;
    FOldWndProc: TWndMethod;
    FOwnerWnd: TWinControl;
    FTipShowing: boolean;
    procedure SetCaption(const Value: WideString);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure HookProc(var Message: TMessage);
    procedure WMDestroy(var Msg: TMessage); message WM_DESTROY;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMNCPaint(var Msg: TWMNCPaint); message WM_NCPAINT;
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMShowWindow(var Msg: TWMShowWindow); message WM_SHOWWINDOW;
    property AnsiCaption: string read FAnsiCaption write FAnsiCaption;
    property NewLastActive: Cardinal read FNewLastActive write FNewLastActive;
    property OldWndProc: TWndMethod read FOldWndProc write FOldWndProc;
    property OwnerWnd: TWinControl read FOwnerWnd write FOwnerWnd;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ActivateHint(Rect: TRect; const AHint: string); override;
    property Caption: WideString read FCaption write SetCaption;
    property TipShowing: boolean read FTipShowing;
  end;     }

  function JumboSysImages : TCommonSysImages;
  function ExtraLargeSysImages: TCommonSysImages;
  function LargeSysImages: TCommonSysImages;
  function SmallSysImages: TCommonSysImages;
  procedure FlushImageLists;
  procedure CreateFullyQualifiedShellDataObject(NamespaceList: TList; DragDropObject: Boolean; var ADataObject: IDataObject);
  procedure StripDuplicatesAndDesktops(NamespaceList: TList);
  function ILIsParent(PIDL1: PItemIDList; PIDL2: PItemIDList; ImmediateParent: LongBool): LongBool;
  function ILIsEqual(PIDL1: PItemIDList; PIDL2: PItemIDList): LongBool;

  {$IFNDEF COMPILER_6_UP}
  function GUIDToString(const GUID: TGUID): string;
  {$ENDIF}
  
var
  StreamHelper: TCommonMemoryStreamHelper;
  Checks: TCommonCheckBoundManager;
  MarlettFont: TFont;
  

implementation

uses
  MPCommonUtilities,
  MPDataObject,
  MPShellUtilities,
  Math;

var
  FreeShellLib: Boolean = False;
  ShellDLL: HMODULE = 0;
  FJumboSysImages : TCommonSysImages = nil;
  FExtraLargeSysImages: TCommonSysImages = nil;
  FLargeSysImages: TCommonSysImages = nil;
  FSmallSysImages: TCommonSysImages = nil;
  PIDLMgr: TCommonPIDLManager = nil;
  ILIsParent_MP: TILIsParent = nil;
  ILIsEqual_MP: TILIsEqual = nil;

{$IFNDEF COMPILER_6_UP}
function GUIDToString(const GUID: TGUID): string;
var
  P: PWideChar;
begin
  Result := '';
  if Succeeded(StringFromCLSID(GUID, P)) then
  begin
    Result := P;
    CoTaskMemFree(P);
  end
end;
{$ENDIF}

function MultiPathNamespaceListSort(Item1, Item2: Pointer): Integer;
// Simply sorts the PIDLs by their length, it has nothing to do with the name 
begin
  Result := PIDLMgr.IDCount(TNamespace(Item2).AbsolutePIDL) - PIDLMgr.IDCount(TNamespace(Item1).AbsolutePIDL)
end;

function ILIsParent(PIDL1: PItemIDList; PIDL2: PItemIDList; ImmediateParent: LongBool): LongBool;
begin
  if Assigned(ILIsParent_MP) and Assigned(PIDL1) and Assigned(PIDL2) then
    Result := ILIsParent_MP(PIDL1, PIDL2, ImmediateParent)
  else
    Result := False
end;

function ILIsEqual(PIDL1: PItemIDList; PIDL2: PItemIDList): LongBool;
begin
  if Assigned(ILIsEqual_MP) and Assigned(PIDL1) and Assigned(PIDL2) then
    Result := ILIsEqual_MP(PIDL1, PIDL2)
  else
    Result := False
end;

procedure FlushImageLists;
begin
  if Assigned(FSmallSysImages) then
    FSmallSysImages.Flush;
  if Assigned(FLargeSysImages) then
    FLargeSysImages.Flush;
  if Assigned(FExtraLargeSysImages) then
    FExtraLargeSysImages.Flush;
  if Assigned(FJumboSysImages) then
    FJumboSysImages.Flush;           
end;
function JumboSysImages : TCommonSysImages;
begin
  if not Assigned(FJumboSysImages) then
  begin
    FJumboSysImages := TCommonSysImages.Create(nil);
    FJumboSysImages.ImageSize := sisJumbo;
  end;
  Result := FJumboSysImages;
end;

function ExtraLargeSysImages: TCommonSysImages;
begin
  if not Assigned(FExtraLargeSysImages) then
  begin
    FExtraLargeSysImages := TCommonSysImages.Create(nil);
    FExtraLargeSysImages.ImageSize := sisExtraLarge;
  end;
  Result := FExtraLargeSysImages
end;

function LargeSysImages: TCommonSysImages;
begin
  if not Assigned(FLargeSysImages) then
  begin
    FLargeSysImages := TCommonSysImages.Create(nil);
    FLargeSysImages.ImageSize := sisLarge;
  end;
  Result := FLargeSysImages
end;

function SmallSysImages: TCommonSysImages;
begin
  if not Assigned(FSmallSysImages) then
  begin
    FSmallSysImages := TCommonSysImages.Create(nil);
    FSmallSysImages.ImageSize := sisSmall;
  end;
  Result := FSmallSysImages
end;

function SHGetImageList(iImageList: Integer; const RefID: TGUID; out ppvOut): HRESULT;
// Retrieves the system ImageList interface
var
  ImageList: TSHGetImageList;
begin
  Result := E_NOTIMPL;
  if (Win32Platform = VER_PLATFORM_WIN32_NT) then
  begin
    ShellDLL := LoadLibrary(Shell32);
    if ShellDLL <> 0 then
    begin
      ImageList := GetProcAddress(ShellDLL, PAnsiChar(727));
      if (Assigned(ImageList)) then
        Result := ImageList(iImageList, RefID, ppvOut);
    end
  end;
end;

procedure StripDuplicatesAndDesktops(NamespaceList: TList);

{$IFDEF COMPILER_6_UP}
  {$MESSAGE 'THIS IS DOG SLOW'}
{$ENDIF}

//
// Sort and modifies the NamespaceList to work with SHFileOperation and other shell
// operations.  The items in the List will be sorted and possibly removed but will NOT
// be freed so this list should not own the items
//
var
  i, j, SourceLen: Integer;
  Dups: TList;
  NS, NSNext: TNamespace;
begin
  // Sort the list from shortest PIDL length to longest
  NamespaceList.Sort(MultiPathNamespaceListSort);
  
  if NamespaceList.Count > 0 then
  begin
    Dups := TList.Create;
    try
      i := 0;
      while i < NamespaceList.Count - 1 do  // Note here we don't run the very last item in the List
      begin
        NS := TNamespace( NamespaceList[i]);
        if not PIDLMgr.IsDesktopFolder(NS.AbsolutePIDL) then
        begin
          SourceLen := PIDLMgr.IDCount(NS.AbsolutePIDL);
          j := i + 1;
          NSNext := TNamespace( NamespaceList[j]);
          // Now run from the next Namespace to the end if the list or until the number of ItemIDs is different (which means they can't be equal)
          while (j < NamespaceList.Count) and (SourceLen = PIDLMgr.IDCount(NSNext.AbsolutePIDL)) do
          begin
            if ILIsEqual(NS.AbsolutePIDL, NSNext.AbsolutePIDL) then
              Dups.Add( Pointer( j));
            Inc(j);
            if j <  NamespaceList.Count then
              NSNext := TNamespace( NamespaceList[j]);
          end;
        end else
          Dups.Add( Pointer( i));  // Remove the Desktop PIDL
        Inc(i);
      end;
      // Test the very list item in the List
      NS := TNamespace( NamespaceList[NamespaceList.Count - 1]);
      if PIDLMgr.IsDesktopFolder(NS.AbsolutePIDL) then
        Dups.Add( Pointer( NamespaceList.Count - 1));  // Remove the Desktop PIDL in the last position
    finally
      for i := 0 to Dups.Count - 1 do
        NamespaceList[ Integer( Dups[i])] := nil;
      NamespaceList.Pack;
      Dups.Free
    end
  end
end;

procedure CreateFullyQualifiedShellDataObject(NamespaceList: TList; DragDropObject: Boolean; var ADataObject: IDataObject);
//
// July 2009 - Functionality changed.  If a valid DataObject is passed in it is used, else
//             a new TCommonDataObject is created.  Make sure you pass in a NIL DataObject if
//             it is expected to create a new object!
//
//             NamespaceList contains TNamespaceObjects, these objects can NOT be owned by the List
//             since this function will remove items from the list if needed and will NOT free the TNamespaces
//             when it does so.  This needs to be a temporary holder for TNamespaces that are owned
//             in other ways
//
var
  ShellIDList: TCommonShellIDList;
  i: Integer;
  HDrop: TCommonHDrop;
  DragLoop: TCommonInShellDragLoop;
  {$IFDEF TNTSUPPORT}
  FileListW: TTntStringList;
  {$ENDIF}
  FileListA: TStringList;
  NS: TNamespace;
  AbsolutePIDLs: TCommonPIDLList;
  CommonDataObj2: ICommonDataObject2;
begin
  if not Assigned(ADataObject) then
    ADataObject := TCommonDataObject.Create(True);
  if Supports(ADataObject, ICommonDataObject2, CommonDataObj2) then
  begin
    CommonDataObj2.SetMultiFolder(True);
    CommonDataObj2.SetMultiFolderVerified(True);
  end;
  if Assigned(NamespaceList) then
  begin
    StripDuplicatesAndDesktops(NamespaceList);
    ShellIDList := TCommonShellIDList.Create;
    if DragDropObject then
      DragLoop := TCommonInShellDragLoop.Create
    else
      DragLoop := nil;
    HDrop := TCommonHDrop.Create;
    AbsolutePIDLs := TCommonPIDLList.Create;
    AbsolutePIDLs.SharePIDLs := True;
    {$IFDEF TNTSUPPORT}
    FileListW := TTntStringList.Create;
    {$ENDIF}
    FileListA := TStringList.Create;
    try
      // First PIDL must be the Desktop (root PIDL)
      AbsolutePIDLs.Add(DesktopFolder.AbsolutePIDL);
      for i := 0 to NamespaceList.Count - 1 do
      begin
        NS := TNamespace( NamespaceList[i]);
        if NS.FileSystem then
        begin
          {$IFDEF TNTSUPPORT}
          if IsUnicode then
            FileListW.Add(NS.NameForParsing)
          else
            FileListA.Add(NS.NameForParsing);
          {$ELSE}
          FileListA.Add(NS.NameForParsing);
          {$ENDIF}
        end;
        AbsolutePIDLs.Add(NS.AbsolutePIDL);
      end;
      ShellIDList.AssignPIDLs(AbsolutePIDLs);
      {$IFDEF TNTSUPPORT}
      if IsUnicode then
        HDrop.AssignFilesW(FileListW)
      else
        HDrop.AssignFilesA(FileListA);
      {$ELSE}
      HDrop.AssignFilesA(FileListA);
      {$ENDIF}
      ShellIDList.SaveToDataObject(ADataObject);
      HDrop.SaveToDataObject(ADataObject);
      if DragDropObject then
        DragLoop.SaveToDataObject(ADataObject)
    finally
      ShellIDList.Free;
      HDrop.Free;
      AbsolutePIDLs.Free;
      {$IFDEF TNTSUPPORT}
      FileListW.Free;
      {$ENDIF}
      FileListA.Free;
      if DragDropObject then
        DragLoop.Free;
    end
  end
end;

{ TCoolDefaultCanvasState }

destructor TCommonDefaultCanvasState.Destroy;
begin
  inherited;
  FreeAndNil(FBrush);
  FreeAndNil(FFont);
  FreeAndNil(FPen);
end;

function TCommonDefaultCanvasState.GetBrush: TBrush;
begin
  if not Assigned(FBrush) then
    FBrush := TBrush.Create;
  Result := FBrush
end;

function TCommonDefaultCanvasState.GetFont: TFont;
begin
  if not Assigned(FFont) then
    FFont := TFont.Create;
  Result := FFont
end;

function TCommonDefaultCanvasState.GetPen: TPen;
begin
  if not Assigned(FPen) then
    FPen := TPen.Create;
  Result := FPen
end;

procedure TCommonDefaultCanvasState.RestoreCanvas(ACanvas: TCanvas);
begin
  Assert(CanvasStored, 'Trying to restore a canvas that has not been saved');
  SetBkMode(ACanvas.Handle, FBkMode);
  ACanvas.CopyMode := FCopyMode;
  ACanvas.Font.Assign(Font);
  ACanvas.Brush.Assign(Brush);
  ACanvas.Pen.Assign(Pen);
  ACanvas.PenPos := FPenPos;
  ACanvas.TextFlags := FTextFlags;
  SelectClipRgn(ACanvas.Handle, 0);
end;

procedure TCommonDefaultCanvasState.StoreCanvas(ACanvas: TCanvas);
begin
  FCanvasStored := True;
  FBkMode := GetBkMode(ACanvas.Handle);
  FCopyMode := ACanvas.CopyMode;
  Font.Assign(ACanvas.Font);
  Brush.Assign(ACanvas.Brush);
  Pen.Assign(ACanvas.Pen);
  FPenPos := ACanvas.PenPos;
  FTextFlags := ACanvas.TextFlags;
end;

{ TCommonCanvasControl }

function TCommonCanvasControl.DrawWithThemes: Boolean;
begin
  {$IFDEF USETHEMES}
  Result := Themed and Themes.Loaded;
  {$ELSE}
  Result := False;
  {$ENDIF USETHEMES}
end;

function TCommonCanvasControl.GetThemed: Boolean;
begin
  Result := False;
  {$IFDEF USETHEMES}
  if not (csLoading in ComponentState) then
    Result := FThemed and UseThemes;
  {$ENDIF USETHEMES}
end;

procedure TCommonCanvasControl.AfterPaintRect(ACanvas: TCanvas; ClipRect: TRect);
begin

end;

procedure TCommonCanvasControl.BeginUpdate;
//
// If ReIndex = False it is up to the user to understand when it is necessary
// to ReIndex different objects.  By doing so performance may be enhanced
// drasticlly on large data sets.
begin
  if FUpdateCount = 0 then
    DoBeginUpdate;
  Inc(FUpdateCount);
end;

constructor TCommonCanvasControl.Create(AOwner: TComponent);
begin
  inherited;
  FCanvas := TControlCanvas.Create;
  FMouseEnterExitNotifyEnabled := True;  /// Warning this can cause problems with WM_MOUSEACTIVE so allow it to be disabled
  Canvas.Control := Self;
  NCCanvas := TCanvas.Create;
  FShowThemedBorder := True;
  // No notifications for font change
//  Font.OnChange := nil;
  FBorderStyle := bsSingle;
  {$IFDEF USETHEMES}
  FThemes := TCommonThemeManager.Create(Self);
  {$ENDIF USETHEMES}
  FThemed := True;
end;

destructor TCommonCanvasControl.Destroy;
begin
  inherited;
  {$IFDEF USETHEMES}FreeAndNil(FThemes);{$ENDIF USETHEMES}
  FreeAndNil(FNCCanvas);
  FreeAndNil(FCanvas);
  FreeAndNil(FBackBits);
end;

procedure TCommonCanvasControl.CalcThemedNCSize(var ContextRect: TRect);
begin

end;

procedure TCommonCanvasControl.CMCtl3DChanged(var Msg: TMessage);
begin
  inherited;
  if FBorderStyle = bsSingle then
    RecreateWnd;
end;

procedure TCommonCanvasControl.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WindowClass.Style := Params.WindowClass.Style or CS_DBLCLKS and not (CS_HREDRAW or CS_VREDRAW);
  Params.Style := Params.Style or WS_CLIPCHILDREN or WS_CLIPSIBLINGS;
  AddBiDiModeExStyle(Params.ExStyle);

  // Themed does not work at design time as Delphi is not themed
  if (BorderStyle = bsSingle) and not Themed then
  begin
    if Ctl3D then
    begin
      Params.ExStyle := Params.ExStyle or WS_EX_CLIENTEDGE;
      Params.Style := Params.Style and not WS_BORDER;
    end
    else
      Params.Style := Params.Style or WS_BORDER;
  end
end;

procedure TCommonCanvasControl.CreateWnd;
begin
  inherited CreateWnd;
  {$IFDEF USETHEMES}Themes.ThemesLoad;{$ENDIF USETHEMES}
  ResizeBackBits(ClientWidth, ClientHeight);
end;

procedure TCommonCanvasControl.DoBeginUpdate;
begin
  if Assigned(OnBeginUpdate) then
    OnBeginUpdate(Self)
end;

procedure TCommonCanvasControl.DoEndUpdate;
begin
  if Assigned(OnEndUpdate) then
    OnEndUpdate(Self)
end;

procedure TCommonCanvasControl.DoMouseEnter(MousePos: TPoint);
begin
  if Assigned(OnMouseEnter) then
    OnMouseEnter(Self, MousePos)
end;

procedure TCommonCanvasControl.DoMouseExit;
begin
  if Assigned(OnMouseExit) then
    OnMouseExit(Self)
end;

procedure TCommonCanvasControl.DoMouseTrack(MousePos: TPoint);
begin
  // Called when the MouseTimer is running and the mouse is in the window
end;

procedure TCommonCanvasControl.DoPaintRect(ACanvas: TCanvas; ClipRect: TRect; SelectedOnly: Boolean; ClipRectInViewPortCoords: Boolean = False);
begin

end;

procedure TCommonCanvasControl.DoUpdate;
begin
end;

procedure TCommonCanvasControl.EndUpdate(Invalidate: Boolean = True);
begin
  Dec(FUpdateCount);
  if (UpdateCount <= 0) then
  begin
    FUpdateCount := 0;
    DoUpdate;
    if Invalidate and HandleAllocated then
      UpdateWindow(Handle);
    DoEndUpdate;
  end
end;

function TCommonCanvasControl.GetCanvas: TControlCanvas;
begin
  FCanvas.Font.Assign(Font);
  FCanvas.Brush.Assign(Brush);
  Result := FCanvas;
end;

procedure TCommonCanvasControl.KillMouseInWindowTimer;
begin
  if MouseInWindow then
  begin
    DoMouseExit;
    if Mouse.Capture <> Handle then
      FreeAndNil(FMouseTimer);
    MouseInWindow := False;
  end;
end;

procedure TCommonCanvasControl.Loaded;
begin
  inherited;
end;

procedure TCommonCanvasControl.MouseTimerProc(Sender: TObject);
var
  Pt: TPoint;
begin
  if HandleAllocated then
  begin
    GetCursorPos(Pt);
    Windows.ScreenToClient(Handle, Pt);
    if not PtInRect(ClientRect, Pt) and (Mouse.Capture <> Handle) then
    begin
      FreeAndNil(FMouseTimer);
      DoMouseExit;
    end else
      DoMouseTrack(Pt)
  end else
  begin
    FreeAndNil(FMouseTimer);
    DoMouseExit;
  end
end;

procedure TCommonCanvasControl.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = FImagesExtraLarge then
      FImagesExtraLarge := nil
    else
    if AComponent = FImagesLarge then
      FImagesLarge := nil
    else
    if AComponent = FImagesSmall then
      FImagesSmall := nil
  end
end;

procedure TCommonCanvasControl.PaintThemedNCBkgnd(ACanvas: TCanvas; ARect: TRect);
begin

end;

procedure TCommonCanvasControl.PaintToRect(ACanvas: TCanvas; Rect: TRect; ClipRectInViewPortCoords: Boolean = True);
begin
  DoPaintRect(ACanvas, Rect, False, ClipRectInViewPortCoords);
end;

procedure TCommonCanvasControl.ResizeBackBits(NewWidth, NewHeight: Integer);
// Resizes the Bitmap for the DoubleBuffering.  Called mainly when the window
// is resized.  Note the bitmap only gets larger to maximize speed during dragging
begin
  if CacheDoubleBufferBits and Assigned(BackBits) then
  begin
    // The Backbits grow to the largest window size
    if (NewWidth > BackBits.Width) then
    begin
      if NewWidth > 0 then
        BackBits.Width := NewWidth
      else
        BackBits.Width := 1
    end;
    if NewHeight > BackBits.Height then
    begin
      if NewHeight > 0 then
        BackBits.Height := NewHeight
      else
        BackBits.Height := 1;
    end
  end
end;

procedure TCommonCanvasControl.SafeInvalidateRect(ARect: PRect; ImmediateUpdate: Boolean);
begin
  if HandleAllocated then
  begin
    InvalidateRect(Handle, ARect, False);
    if ImmediateUpdate then
      UpdateWindow(Handle)
  end
end;

procedure TCommonCanvasControl.SetBorderStyle(const Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TCommonCanvasControl.SetCacheDoubleBufferBits(const Value: Boolean);
begin
  if FCacheDoubleBufferBits <> Value then
  begin
    FCacheDoubleBufferBits := Value;
    if Value then
    begin
      if not Assigned(FBackBits) then
      begin
        FBackBits := TBitmap.Create;
        FBackBits.PixelFormat := pf32Bit
      end
    end else
      FreeAndNil(FBackBits)
  end
end;

procedure TCommonCanvasControl.SetShowThemedBorder(const Value: Boolean);
begin
  if Value <> FShowThemedBorder then
  begin
    FShowThemedBorder := Value;
    if HandleAllocated then
      RecreateWnd;  // Need to modify the NonClient area
  end
end;

procedure TCommonCanvasControl.SetThemed(const Value: Boolean);
begin
  if Value <> FThemed then
  begin
    FThemed := Value;
    {$IFDEF USETHEMES}
    if Value then    
      Themes.ThemesLoad
    else
      Themes.ThemesFree;
    if HandleAllocated then
    begin
      // This is the only way I could get the window to redraw the NonClient areas
      // RedrawWindow did not work either.
  //    Visible := not Visible;
  //    Visible := not Visible;
      RecreateWnd;
  //    SafeInvalidateRect(nil, True);
    end;
    {$ENDIF USETHEMES}
  end
end;

procedure TCommonCanvasControl.ValidateBorder;
var
  HasClientEdge, HasBorder: Boolean;
begin
  HasClientEdge := (GetWindowLong(Handle, GWL_EXSTYLE) and WS_EX_CLIENTEDGE) <> 0;
  HasBorder := (GetWindowLong(Handle, GWL_STYLE) and WS_BORDER) <> 0;

  if Themed then
  begin
    // Needs neither WS_EX_CLIENTEDGE or WS_BORDER
    if HasClientEdge or HasBorder then
    begin
      SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) and not WS_EX_CLIENTEDGE);
      SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) and not WS_BORDER)
    end
  end else
  begin
    if (BorderStyle = bsSingle) then
    begin
      if Ctl3D then
      begin
        // Needs WS_EX_CLIENTEDGE and not WS_BORDER
        if not HasClientEdge or HasBorder then
        begin
          SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_CLIENTEDGE);
          SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) and not WS_BORDER)
        end
      end else
      begin
        // Does not need WS_EX_CLIENTEDGE and needs WS_BORDER
        if HasClientEdge or not HasBorder then
        begin
          SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) and not WS_EX_CLIENTEDGE);
          SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) or WS_BORDER)
        end
      end
    end else
    begin
      SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) and not WS_EX_CLIENTEDGE);
      SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) and not WS_BORDER)
    end
  end
end;

procedure TCommonCanvasControl.WMDestroy(var Msg: TMessage);
begin
  FreeAndNil(FMouseTimer);
  {$IFDEF USETHEMES}Themes.ThemesFree;{$ENDIF USETHEMES}
  inherited;
end;

procedure TCommonCanvasControl.WMKillFocus(var Msg: TWMKillFocus);
begin
  KillMouseInWindowTimer;
  inherited;
end;

procedure TCommonCanvasControl.WMMouseMove(var Msg: TWMMouseMove);
begin
  if not Assigned(MouseTimer) then
  begin
    MouseTimer := TTimer.Create(nil);
    MouseTimer.Enabled := False;
    MouseTimer.OnTimer := MouseTimerProc;
    MouseTimer.Interval := 50;
    MouseTimer.Enabled := True;
    DoMouseEnter(SmallPointToPoint( Msg.Pos));
  end;
  if not PtInRect(ClientRect, SmallPointToPoint(Msg.Pos)) then
  begin
    KillMouseInWindowTimer;
  end else
  begin
    if not MouseInWindow then
    begin
      if Mouse.Capture = Handle then
        DoMouseEnter(SmallPointToPoint( Msg.Pos));
      MouseInWindow := True;
    end
  end;
  inherited;
end;

procedure TCommonCanvasControl.WMNCCalcSize(var Msg: TWMNCCalcSize);
begin
  {$IFDEF USETHEMES}
  if not Themes.Loaded then
    Themes.ThemesLoad;
  {$ENDIF USETHEMES}
  if DrawWithThemes and ShowThemedBorder then
  begin
    DefaultHandler(Msg);
    CalcThemedNCSize(Msg.CalcSize_Params^.rgrc[0])
  end else
  begin
    inherited;
  end
end;

procedure TCommonCanvasControl.WMNCPaint(var Msg: TWMNCPaint);
// The VCL screws this up and draws over the scrollbars making them flicker and
// be covered up by backgound painting when dragging the the window from off the
// screen
const
  InnerStyles: array[TBevelCut] of Integer = (0, BDR_SUNKENINNER, BDR_RAISEDINNER, 0);
  OuterStyles: array[TBevelCut] of Integer = (0, BDR_SUNKENOUTER, BDR_RAISEDOUTER, 0);
  EdgeStyles: array[TBevelKind] of Integer = (0, 0, BF_SOFT, BF_FLAT);
  Ctl3DStyles: array[Boolean] of Integer = (BF_MONO, 0);
var
  ClientR,            // The client area plus the scrollbars
  Filler,             // The rectangle between the scrollbars
  NonClientR: TRect;  // The full window with a 0,0 origin
  DC: HDC;
  Style, StyleEx: Longword;
  OffsetX, OffsetY: Integer;
begin
  // Let Windows paint the scrollbars first
  DefaultHandler(Msg);
  // Always paint the NC area as refreshing it can be tricky and it sometimes
  // is not redrawn on startup
//  if UpdateCount = 0 then
  begin
    DC := GetWindowDC(Handle);
    try
      NCCanvas.Handle := DC;

      Windows.GetClientRect(Handle, ClientR);
      Windows.GetWindowRect(Handle, NonClientR);

      Windows.ScreenToClient(Handle, NonClientR.TopLeft);
      Windows.ScreenToClient(Handle, NonClientR.BottomRight);
      OffsetX := NonClientR.Left;
      OffsetY := NonClientR.Top;

      // The DC origin is with respect to the Window so offset everything to match
      OffsetRect(NonClientR, -OffsetX, -OffsetY);
      OffsetRect(ClientR, -OffsetX, -OffsetY);

      Style := GetWindowLong(Handle, GWL_STYLE);
      if (Style and WS_VSCROLL) <> 0 then
      begin
        StyleEx := GetWindowLong(Handle, GWL_EXSTYLE);
        if (StyleEx and WS_EX_LEFTSCROLLBAR) <> 0 then          // RTL or LTR Reading
          Dec(ClientR.Left, GetSystemMetrics(SM_CYVSCROLL))
        else
          Inc(ClientR.Right, GetSystemMetrics(SM_CYVSCROLL))
      end;
      if (Style and WS_HSCROLL) <> 0 then
        Inc(ClientR.Bottom, GetSystemMetrics(SM_CYHSCROLL));

      // Paint the little square in the corner made by the scroll bars
      if ((Style and WS_VSCROLL) <> 0) and ((Style and WS_HSCROLL) <> 0) then
      begin
        Filler := ClientR;
        StyleEx := GetWindowLong(Handle, GWL_EXSTYLE);
        if (StyleEx and WS_EX_LEFTSCROLLBAR) <> 0 then
          Filler.Right := Filler.Left + GetSystemMetrics(SM_CYVSCROLL)
        else
          Filler.Left := Filler.Right - GetSystemMetrics(SM_CYVSCROLL);
        Filler.Top := Filler.Bottom - GetSystemMetrics(SM_CYHSCROLL);
        NCCanvas.Brush.Color := clBtnFace;
        NCCanvas.FillRect(Filler);
      end;

      // Punch out the client area and the scroll bar area
      ExcludeClipRect(DC, ClientR.Left, ClientR.Top, ClientR.Right, ClientR.Bottom);
      // Fill the entire
      Windows.FillRect(DC, NonClientR, Brush.Handle);

      // Will return false if USETHEMES not defined
      if DrawWithThemes then
        PaintThemedNCBkgnd(NCCanvas, NonClientR)
      else begin
        Windows.FillRect(DC, NonClientR, Brush.Handle);
        if BevelKind <> bkNone then
        begin
          if BevelInner <> bvNone then
            InflateRect(ClientR, 1, 1);
          if BevelOuter <> bvNone then
            InflateRect(ClientR, 1, 1);
        end;
        DrawEdge(DC, NonClientR, InnerStyles[BevelInner] or OuterStyles[BevelOuter],
            Byte(BevelEdges) or EdgeStyles[BevelKind] or Ctl3DStyles[Ctl3D]);
      end;
    finally
      NCCanvas.Handle := 0;
      ReleaseDC(Handle, DC);
    end
  end
end;

procedure TCommonCanvasControl.WMPaint(var Msg: TWMPaint);
// The VCL does a poor job at optimizing the paint messages.  It does not look
// to see what rectangle the system actually needs painted.  Sometimes it only
// needs a small slice of the window painted, why paint it all?  This implementation
// also handles DoubleBuffering better
var
  PaintInfo: TPaintStruct;
  ClientR: TRect;
begin
  BeginPaint(Handle, PaintInfo);
  try
    if (UpdateCount = 0) or ForcePaint then
    begin
      try
       if not CacheDoubleBufferBits then
        begin
          BackBits := TBitmap.Create;
          BackBits.PixelFormat := pf32Bit;
          Windows.GetClientRect(Handle, ClientR);
          if ClientWidth > 0 then
            BackBits.Width := ClientWidth
          else
            BackBits.Width := 1;
          if ClientHeight > 0 then
            BackBits.Height := ClientHeight
          else
            BackBits.Height := 1;
        end;
        BackBits.Canvas.Lock;
        try
          if not IsRectEmpty(PaintInfo.rcPaint) and (ClientWidth > 0) and (ClientHeight > 0) then
          begin
            // Assign attributes to the Canvas used
            BackBits.Canvas.Font.Assign(Font);
            BackBits.Canvas.Brush.Color := Color;
            BackBits.Canvas.Brush.Assign(Brush);

            SetWindowOrgEx(BackBits.Canvas.Handle, 0, 0, nil);
            SetViewportOrgEx(BackBits.Canvas.Handle, 0, 0, nil);
            FillRect(BackBits.Canvas.Handle, PaintInfo.rcPaint, Brush.Handle);
            SelectClipRgn(BackBits.Canvas.Handle, 0);  // Remove the clipping region we created

            // Paint the rectangle that is needed
            DoPaintRect(BackBits.Canvas, PaintInfo.rcPaint, False);

            // Remove any clipping regions applied by the views.
            SelectClipRgn(BackBits.Canvas.Handle, 0);

            AfterPaintRect(BackBits.Canvas, PaintInfo.rcPaint);   

            // Blast the bits to the screen
            BitBlt(PaintInfo.hdc, PaintInfo.rcPaint.Left, PaintInfo.rcPaint.Top,
              PaintInfo.rcPaint.Right - PaintInfo.rcPaint.Left,
              PaintInfo.rcPaint.Bottom - PaintInfo.rcPaint.Top,
              BackBits.Canvas.Handle, PaintInfo.rcPaint.Left, PaintInfo.rcPaint.Top, SRCCOPY);
          end
        finally
          BackBits.Canvas.Unlock;
        end;
      finally
        if not CacheDoubleBufferBits then
          FreeAndNil(FBackBits)
      end;
    end    
  finally
    EndPaint(Handle, PaintInfo);
  end
end;

{$IFDEF USETHEMES}
procedure TCommonCanvasControl.WMThemeChanged(var Message: TMessage);
begin
  inherited;
  Themes.ThemesFree;
  Themes.ThemesLoad;
end;
{$ENDIF USETHEMES}

{ TCoolPIDLList }

constructor TCommonPIDLList.Create;
begin
  inherited Create;
  FLocalPIDLMgr := TCommonPIDLManager.Create;
end;

procedure TCommonPIDLList.Clear;
var
  i: integer;
begin
  if not SharePIDLs then
    for i := 0 to Count - 1 do
      LocalPIDLMgr.FreePIDL( PItemIDList( Items[i]));
  inherited;
end;

procedure TCommonPIDLList.CloneList(PIDLList: TCommonPIDLList);
var
  i: Integer;
begin
  if Assigned(PIDLList) then
  begin
    PIDLList.Clear;
    for i := 0 to Count - 1 do
      PIDLList.CopyAdd(Items[i]);
    PIDLList.Name := Name;
  end
end;

function TCommonPIDLList.CopyAdd(PIDL: PItemIDList): integer;
// Adds a Copy of the passed PIDL to the list
begin
  Result := Add( LocalPIDLMgr.CopyPIDL(PIDL));
end;

destructor TCommonPIDLList.Destroy;
begin
  FDestroying := True;
  inherited;
  FreeAndNil(FLocalPIDLMgr);
end;

function TCommonPIDLList.FindPIDL(TestPIDL: PItemIDList): Integer;
// Finds the index of the PIDL that is equivalent to the passed PIDL.  This is not
// the same as an byte for byte equivalent comparison
var
  i: Integer;
begin
  i := 0;
  Result := -1;
  while (i < Count) and (Result < 0) do
  begin
    if LocalPIDLMgr.EqualPIDL(TestPIDL, GetPIDL(i)) then
      Result := i;
    Inc(i);
  end;
end;

function TCommonPIDLList.GetPIDL(Index: integer): PItemIDList;
begin
  Result := PItemIDList( Items[Index]);
end;

function TCommonPIDLList.LoadFromStream(Stream: TStream): Boolean;
// Loads the PIDL list from a stream
var
  PIDLCount, i: integer;
begin
  Result := True;
  try
    Stream.ReadBuffer(PIDLCount, SizeOf(Integer));
    for i := 0 to PIDLCount - 1 do
      Add( LocalPIDLMgr.LoadFromStream(Stream));
  except
    Result := False;
  end;
end;

function TCommonPIDLList.SaveToStream(Stream: TStream): Boolean;
// Saves the PIDL list to a stream
var
  i: integer;
begin
  Result := True;
  try
    Stream.WriteBuffer(Count, SizeOf(Count));
    for i := 0 to Count - 1 do
      LocalPIDLMgr.SaveToStream(Stream, Items[i]);
  except
    Result := False;
  end;
end;

procedure TCommonPIDLList.StripDesktopPIDLs;
var
  i: Integer;
  PIDL: PItemIDList;
begin
  try
    for i := 0 to Count - 1 do
    begin
      PIDL := PItemIDList( Items[i]);
      if PIDL.mkid.cb = 0 then
      begin
        Items[i] := nil;
        if not SharePIDLs then
          PIDLMgr.FreePIDL(PIDL);
      end
    end
  finally
    Pack
  end
end;

function TCommonPIDLManager.AllocGlobalMem(Size: Integer): PByte;
begin
  Result := Malloc.Alloc(Size);
  if Result <> nil then
    ZeroMemory(Result, Size);
end;

// Routines to do most anything you would want to do with a PIDL

function TCommonPIDLManager.AppendPIDL(DestPIDL, SrcPIDL: PItemIDList): PItemIDList;
// Returns the concatination of the two PIDLs. Neither passed PIDLs are
// freed so it is up to the caller to free them.
var
  DestPIDLSize, SrcPIDLSize: integer;
begin
  DestPIDLSize := 0;
  SrcPIDLSize := 0;
  // Appending a PIDL to the DesktopPIDL is invalid so don't allow it.
  if Assigned(DestPIDL) then
    if not IsDesktopFolder(DestPIDL) then
      DestPIDLSize := PIDLSize(DestPIDL) - SizeOf(DestPIDL^.mkid.cb);

  if Assigned(SrcPIDL) then
    SrcPIDLSize := PIDLSize(SrcPIDL);

  Result := FMalloc.Alloc(DestPIDLSize + SrcPIDLSize);
  if Assigned(Result) then
  begin
    if Assigned(DestPIDL) and (DestPIDLSize > 0) then
      CopyMemory(Result, DestPIDL, DestPIDLSize);
    if Assigned(SrcPIDL) and (SrcPIDLSize > 0) then
      CopyMemory(PAnsiChar(Result) + DestPIDLSize, SrcPIDL, SrcPIDLSize);
  end;
end;

function TCommonPIDLManager.BindToParent(AbsolutePIDL: PItemIDList; var Folder: IShellFolder): Boolean;
var
  Desktop: IShellFolder;
  Last_CB: Word;
  LastID: PItemIDList;
begin
  SHGetDesktopFolder(Desktop);
  if PIDLMgr.IDCount(AbsolutePIDL) = 1 then
  begin
    Folder := Desktop;
    Result := True
  end else
  begin
    StripLastID(AbsolutePIDL, Last_CB, LastID);
    try
      Result := Succeeded(Desktop.BindToObject(AbsolutePIDL, nil, IShellFolder, Pointer(Folder)))
    finally
      LastID.mkid.cb := Last_CB
    end
  end
end;

function TCommonPIDLManager.CopyPIDL(APIDL: PItemIDList): PItemIDList;
// Copies the PIDL and returns a newly allocated PIDL. It is not associated
// with any instance of TCoolPIDLManager so it may be assigned to any instance.
var
  Size: integer;
begin
  if Assigned(APIDL) then
  begin
    Size := PIDLSize(APIDL);
    Result := FMalloc.Alloc(Size);
    if Result <> nil then
      CopyMemory(Result, APIDL, Size);
  end else
    Result := nil
end;

constructor TCommonPIDLManager.Create;
begin
  inherited Create;
  if SHGetMalloc(FMalloc) = E_FAIL then
    raise EOutOfMemory.Create('Can not allocate the IMalloc memory interface')
end;

destructor TCommonPIDLManager.Destroy;
begin
  FMalloc := nil;
  inherited
end;

function TCommonPIDLManager.EqualPIDL(PIDL1, PIDL2: PItemIDList): Boolean;
begin
  if Assigned(PIDL1) and Assigned(PIDL2) then
    Result := Boolean( ILIsEqual(PIDL1, PIDL2))
  else
    Result := False
end;

procedure TCommonPIDLManager.FreeOLEStr(OLEStr: LPWSTR);
// Frees an OLE string created by the Shell; as in StrRet
begin
  FMalloc.Free(OLEStr)
end;

procedure TCommonPIDLManager.FreePIDL(PIDL: PItemIDList);
// Frees the PIDL using the shell memory allocator
begin
  if Assigned(PIDL) then
    FMalloc.Free(PIDL)
end;

function TCommonPIDLManager.CopyLastID(IDList: PItemIDList): PItemIDList;
// Returns a copy of the last PID in the list
var
  Count, i: integer;
  PIDIndex: PItemIDList;
begin
  PIDIndex := IDList;
  Count := IDCount(IDList);
  if Count > 1 then
    for i := 0 to Count - 2 do
     PIDIndex := NextID(PIDIndex);
  Result := CopyPIDL(PIDIndex);
end;

function TCommonPIDLManager.GetPointerToLastID(IDList: PItemIDList): PItemIDList;
// Return a pointer to the last PIDL in the complex PIDL passed to it.
// Useful to overlap an Absolute complex PIDL with the single level
// Relative PIDL.
var
  Count, i: integer;
  PIDIndex: PItemIDList;
begin
  if Assigned(IDList) then
  begin
    PIDIndex := IDList;
    Count := IDCount(IDList);
    if Count > 1 then
      for i := 0 to Count - 2 do
       PIDIndex := NextID(PIDIndex);
    Result := PIDIndex;
  end else
    Result := nil
end;

function TCommonPIDLManager.IDCount(APIDL: PItemIDList): integer;
// Counts the number of Simple PIDLs contained in a Complex PIDL.
var
  Next: PItemIDList;
begin
  Result := 0;
  Next := APIDL;
  if Assigned(Next) then
  begin
    while Next^.mkid.cb <> 0 do
    begin
      Inc(Result);
      Next := NextID(Next);
    end
  end
end;

function TCommonPIDLManager.IsDesktopFolder(APIDL: PItemIDList): Boolean;
// Tests the passed PIDL to see if it is the root Desktop Folder
begin
  if Assigned(APIDL) then
    Result := APIDL.mkid.cb = 0
  else
    Result := False
end;

function TCommonPIDLManager.NextID(APIDL: PItemIDList): PItemIDList;
// Returns a pointer to the next Simple PIDL in a Complex PIDL.
begin
  Result := APIDL;
  Inc(PAnsiChar(Result), APIDL^.mkid.cb);
end;

function TCommonPIDLManager.PIDLSize(APIDL: PItemIDList): integer;
// Returns the total Memory in bytes the PIDL occupies.
begin
  Result := 0;
  if Assigned(APIDL) then
  begin
    Result := SizeOf( Word);  // add the null terminating last ItemID
    while APIDL.mkid.cb <> 0 do
    begin
      Result := Result + APIDL.mkid.cb;
      APIDL := NextID(APIDL);
    end;
  end;
end;

function TCommonPIDLManager.LoadFromStream(Stream: TStream): PItemIDList;
// Loads the PIDL from a Stream
var
  Size: integer;
begin
  Result := nil;
  if Assigned(Stream) then
  begin
    Stream.ReadBuffer(Size, SizeOf(Integer));
    if Size > 0 then
    begin
      Result := FMalloc.Alloc(Size);
      Stream.ReadBuffer(Result^, Size);
    end
  end
end;

function TCommonPIDLManager.StringToPIDL(PIDLStr: AnsiString): PItemIDList;
var
  P: PAnsiChar;
begin
  Result := FMalloc.Alloc(Length(PIDLStr));
  P := @PIDLStr[1];
  Move(P^, Result^, Length(PIDLStr));
end;

function TCommonPIDLManager.StripLastID(IDList: PItemIDList): PItemIDList;
// Removes the last PID from the list. Returns the same, shortened, IDList passed
// to the function
var
  MarkerID: PItemIDList;
begin
  Result := IDList;
  MarkerID := IDList;
  if Assigned(IDList) then
  begin
    while IDList.mkid.cb <> 0 do
    begin
      MarkerID := IDList;
      IDList := NextID(IDList);
    end;
    MarkerID.mkid.cb := 0;
  end;
end;

procedure TCommonPIDLManager.SaveToStream(Stream: TStream; PIDL: PItemIdList);
// Saves the PIDL from a Stream
var
  Size: Integer;
begin
  Size := PIDLSize(PIDL);
  Stream.WriteBuffer(Size, SizeOf(Size));
  Stream.WriteBuffer(PIDL^, Size);
end;


function TCommonPIDLManager.StripLastID(IDList: PItemIDList; var Last_CB: Word;
  var LastID: PItemIDList): PItemIDList;
// Strips the last ID but also returns the pointer to where the last CB was and the
// value that was there before setting it to 0 to shorten the PIDL.  All that is necessary
// is to do a LastID^ := Last_CB.mkid.cb to return the PIDL to its previous state.  Used to
// temporarily strip the last ID of a PIDL
var
  MarkerID: PItemIDList;
begin
  Last_CB := 0;
  LastID := nil;
  Result := IDList;
  MarkerID := IDList;
  if Assigned(IDList) then
  begin
    while IDList.mkid.cb <> 0 do
    begin
      MarkerID := IDList;
      IDList := NextID(IDList);
    end;
    Last_CB := MarkerID.mkid.cb;
    LastID := MarkerID;
    MarkerID.mkid.cb := 0;
  end;
end;

function TCommonPIDLManager.IsEmptyPIDL(APIDL: PItemIDList): Boolean;
begin
  Result := False;
  if Assigned(APIDL) then
    Result := APIDL.mkid.cb <= SizeOf(APIDL.mkid.cb)
end;

function TCommonPIDLManager.IsSubPIDL(FullPIDL, SubPIDL: PItemIDList): Boolean;
// Tests to see if the SubPIDL can be expanded into the passed FullPIDL
var
  i, PIDLLen, SubPIDLLen: integer;
  PIDL: PItemIDList;
  OldCB: Word;
begin
  Result := False;
  if Assigned(FullPIDL) and Assigned(SubPIDL) then
  begin
    SubPIDLLen := IDCount(SubPIDL);
    PIDLLen := IDCount(FullPIDL);
    if SubPIDLLen <= PIDLLen then
    begin
      PIDL := FullPIDL;
      for i := 0 to SubPIDLLen - 1 do
        PIDL := NextID(PIDL);
      OldCB := PIDL.mkid.cb;
      PIDL.mkid.cb := 0;
      try
        Result := ILIsEqual(FullPIDL, SubPIDL);
      finally
        PIDL.mkid.cb := OldCB
      end
    end
  end
end;

procedure TCommonPIDLManager.FreeAndNilPIDL(var PIDL: PItemIDList);
var
  OldPIDL: PItemIDList;
begin
  OldPIDL := PIDL;
  PIDL := nil;
  FreePIDL(OldPIDL)
end;

function TCommonPIDLManager.AllocStrGlobal(SourceStr: WideString): POleStr;
begin
  Result := Malloc.Alloc((Length(SourceStr) + 1) * 2); // Add the null
  if Result <> nil then
    CopyMemory(Result, PWideChar(SourceStr), (Length(SourceStr) + 1) * 2);
end;

procedure TCommonPIDLManager.ParsePIDL(AbsolutePIDL: PItemIDList; var PIDLList: TCommonPIDLList;
  AllAbsolutePIDLs: Boolean);
// Parses the AbsolutePIDL in to its single level PIDLs, if AllAbsolutePIDLs is true
// then each item is not a single level PIDL but an AbsolutePIDL but walking from the
// Desktop up to the passed AbsolutePIDL
var
  OldCB: Word;
  Head, Tail: PItemIDList;
begin
  Head := AbsolutePIDL;
  Tail := Head;
  if Assigned(PIDLList) and Assigned(Head) then
  begin
    while Tail.mkid.cb <> 0 do
    begin
      Tail := NextID(Tail);
      OldCB := Tail.mkid.cb;
      try
        Tail.mkid.cb := 0;
        PIDLList.Add(CopyPIDL(Head));
      finally
        Tail.mkid.cb := OldCB;
      end;
      if not AllAbsolutePIDLs then
        Head := Tail
    end
  end
end;

procedure TCommonPIDLManager.ParsePIDLArray(PIDLArray: PPIDLRawArray;
  var PIDLList: TCommonPIDLList; Count: Integer; Relative,
  CopyPIDLs: Boolean);
// Used to parse the List of PIDLs passed to a few of the IShellFolder interfaces
//
// In the API calls pass the apidl param to the PIDLArray like this:
//    PIDLArray(@apidl, PIDLList, cidl, True, TrueOrFalse)
//  PIDLArray:   A pointer to an array of PItemIDLists
//  PIDLList:    A TList that will be filled with each PIDL
//  Count:       The number of PItemIDLists in the PIDLArray
//  Relative:    If the PItemIDLists are complex fill the PIDLList with the last ItemID of each
//               else use the complex PIDL
//  CopyPIDLs:   Make copies of the PIDLs if true, if false make sure PIDLList is set to share PIDLs!
//
var
  i: Integer;
begin
  if Assigned(PIDLList) and Assigned(PIDLArray) then
  begin
    for i := 0 to Count - 1 do
    begin
      if Relative then
      begin
        if CopyPIDLs then
          PIDLList.Add(CopyPIDL(GetPointerToLastID(PIDLArray^[i])))
        else
          PIDLList.Add(GetPointerToLastID(PIDLArray^[i]))
      end else
      begin
        if CopyPIDLs then
          PIDLList.Add(CopyPIDL(PIDLArray^[i]))
        else
          PIDLList.Add(PIDLArray^[i])
      end
    end
  end
end;

procedure LoadShell32Functions;
begin
  ShellDLL := GetModuleHandleA(PAnsiChar( AnsiString( Shell32)));
  if ShellDLL = 0 then
  begin
    ShellDLL := LoadLibraryA(PAnsiChar( AnsiString( Shell32)));
    FreeShellLib := True;
  end;
  if ShellDll <> 0 then
  begin
    ILIsEqual_MP := GetProcAddress(ShellDLL, PAnsiChar(21));
    ILIsParent_MP := GetProcAddress(ShellDLL, PAnsiChar(23));
  end
end;

{ TCommonMemoryStream}
function TCommonMemoryStreamHelper.ReadBoolean(S: TStream): Boolean;
begin
  S.Read(Result, SizeOf(Result));
end;

function TCommonMemoryStreamHelper.ReadColor(S: TStream): TColor;
begin
  S.Read(Result, SizeOf(Result));
end;

function TCommonMemoryStreamHelper.ReadInt64(S: TStream): Int64;
begin
  S.Read(Result, SizeOf(Result));
end;

function TCommonMemoryStreamHelper.ReadInteger(S: TStream): Integer;
begin
  S.Read(Result, SizeOf(Result))
end;

function TCommonMemoryStreamHelper.ReadString(S: TStream): AnsiString;
var
  i: Integer;
begin
  i := ReadInteger(S);
  SetLength(Result, i);
  S.Read(PAnsiChar(Result)^, i);
end;

function TCommonMemoryStreamHelper.ReadWideString(S: TStream): WideString;
var
  i: Integer;
begin
  i := ReadInteger(S);
  SetLength(Result, i);
  S.Read(PWideChar(Result)^, i * 2);
end;

function TCommonMemoryStreamHelper.ReadExtended(S: TStream): Extended;
begin
  S.Read(Result, SizeOf(Result))
end;

procedure TCommonMemoryStreamHelper.ReadStream(SourceStream, TargetStream: TStream);
var
  Len: Integer;
  X: array of Byte;
begin
  TargetStream.Size := 0;
  SourceStream.Read(Len, SizeOf(Len));
  if Len > 0 then
  begin   
    SetLength(X, Len);
    SourceStream.Read(X[0], Len);
    TargetStream.Write(X[0], Len);
  end
end;

{

Needs to be modified for D5 and D4

procedure TCommonMemoryStreamHelper.ReadPublishedProperties(S: TStream; Instance: TObject; RecurseSubClasses: Boolean);
var
  TypeInfo: PTypeInfo;
  TypeData: PTypeData;
  PropList: PPropList;
  i: Integer;
  Obj: TObject;
begin
  if Assigned(Instance) then
  begin
    TypeInfo := PTypeInfo(Instance.ClassInfo);
    TypeData := GetTypeData(TypeInfo);
    GetMem(PropList, TypeData.PropCount * SizeOf(Pointer));
    try
      GetPropInfos(TypeInfo, PropList);
      for i := 0 to TypeData.PropCount - 1 do
      begin
        case PropList[i].PropType^^.Kind of
          tkClass:
            begin
              if RecurseSubClasses then
              begin
                Obj := GetObjectProp(Instance, PropList[i]);
                ReadPublishedProperties(S, Obj, RecurseSubClasses);
              end
            end;
          tkInteger, tkChar, tkWChar, tkEnumeration, tkSet:
            begin
              SetOrdProp(Instance, PropList[i], ReadInteger(S));
            end;
          tkFloat:
            begin
              SetFloatProp(Instance, PropList[i], ReadExtended(S));
            end;
          tkString:
            begin
              SetStrProp(Instance, PropList[i], ReadString(S));
            end;
          tkWString, tkLString:
            begin
              // It looks like the VCL messes this up completely.
              SetWideStrProp(Instance, PropList[i], ReadWideString(S));
            end;
          tkInt64:
            begin
              SetInt64Prop(Instance, PropList[i], ReadInt64(S));
            end;
        end
      end;
    finally
      FreeMem(PropList);
    end
  end
end;
}
procedure TCommonMemoryStreamHelper.WriteBoolean(S: TStream; Value: Boolean);
begin
  S.Write(Value, SizeOf(Value))
end;

procedure TCommonMemoryStreamHelper.WriteColor(S: TStream; Value: TColor);
begin
  S.Write(Value, SizeOf(Value))
end;

procedure TCommonMemoryStreamHelper.WriteExtended(S: TStream; Value: Extended);
begin
  S.Write(Value, SizeOf(Value))
end;

procedure TCommonMemoryStreamHelper.WriteInt64(S: TStream; Value: Int64);
begin
  S.Write(Value, SizeOf(Value))
end;

procedure TCommonMemoryStreamHelper.WriteInteger(S: TStream; Value: Integer);
begin
  S.Write(Value, SizeOf(Value))
end;

procedure TCommonMemoryStreamHelper.WriteStream(SourceStream,
  TargetStream: TStream);
var
  Len: Integer;
  X: array of Byte;
begin
  Len := SourceStream.Size;
  TargetStream.Write(Len, SizeOf(Len));
  if Len > 0 then
  begin
    SetLength(X, Len);
    SourceStream.Seek(0, 0);
    SourceStream.Read(X[0], Len);
    TargetStream.Write(X[0], Len);
  end
end;

{

Needs to be modified for D5 and D4

procedure TCommonMemoryStreamHelper.WritePublishedProperties(S: TStream; Instance: TObject; RecurseSubClasses: Boolean);
var
  TypeInfo: PTypeInfo;
  TypeData: PTypeData;
  PropList: PPropList;
  i: Integer;
begin
  if Assigned(Instance) then
  begin
    TypeInfo := PTypeInfo(Instance.ClassInfo);
    TypeData := GetTypeData(TypeInfo);
    GetMem(PropList, TypeData.PropCount * SizeOf(Pointer));
    try
      GetPropInfos(TypeInfo, PropList);
      for i := 0 to TypeData.PropCount - 1 do
      begin
        case PropList[i].PropType^^.Kind of
          tkClass:
            begin
              if RecurseSubClasses then
                WritePublishedProperties(S, GetObjectProp(Instance, PropList[i].Name), RecurseSubClasses);
            end;
          tkInteger, tkChar, tkWChar, tkEnumeration, tkSet:
            begin
               WriteInteger(S, GetOrdProp(Instance, PropList[i]))
            end;
          tkFloat:
            begin
              WriteExtended(S, GetFloatProp(Instance, PropList[i]))
            end;
          tkString:
            begin
              WriteString(S, GetStrProp(Instance, PropList[i]))
            end;
          tkWString, tkLString:
            begin
              WriteWideString(S, GetWideStrProp(Instance, PropList[i]));
            end;
          tkInt64:
            begin
              WriteInt64(S, GetInt64Prop(Instance, PropList[i]))
            end;
        end
      end;
    finally
      FreeMem(PropList);
    end
  end
end;
}

procedure TCommonMemoryStreamHelper.WriteString(S: TStream; Value: AnsiString);
begin
  WriteInteger(S, Length(Value));
  S.Write(PAnsiChar(Value)^, Length(Value))
end;

procedure TCommonMemoryStreamHelper.WriteWideString(S: TStream; Value: WideString);
begin
  WriteInteger(S, Length(Value));
  S.Write(PWideChar(Value)^, Length(Value) * 2)
end;

procedure TCommonCanvasControl.CMColorChange(var Message: TMessage);
begin
  inherited;
  if not (csLoading in ComponentState) then
  begin
    SafeInvalidateRect(nil, False);
  end;
end;

procedure TCommonCanvasControl.CMFontChanged(var Message: TMessage);
begin
  inherited;
  if not (csLoading in ComponentState) then
  begin
    SafeInvalidateRect(nil, False);
  end;
end;

procedure TCommonCanvasControl.CMParentFontChanged(var Message: TMessage);
begin
  inherited;
  if not (csLoading in ComponentState) then
  begin
    SafeInvalidateRect(nil, False);
  end
end;

{ TCommonThemeManager }
{$IFDEF USETHEMES}
constructor TCommonThemeManager.Create(AnOwner: TWinControl);
begin
  inherited Create;
  FOwner := AnOwner;
end;

destructor TCommonThemeManager.Destroy;
begin
  ThemesFree;
  inherited;
end;

procedure TCommonThemeManager.ThemesFree;
begin
  FLoaded := False;
  if FButtonTheme <> 0 then
    CloseThemeData(FButtonTheme);
  FButtonTheme := 0;
  if FListviewTheme <> 0 then
    CloseThemeData(FListviewTheme);
  FListviewTheme := 0;
  if FHeaderTheme <> 0 then
    CloseThemeData(FHeaderTheme);
  FHeaderTheme := 0;
  if FTreeviewTheme <> 0 then
    CloseThemeData(FTreeviewTheme);
  FTreeviewTheme := 0;
  if FExplorerBarTheme <> 0 then
    CloseThemeData(FExplorerBarTheme);
  FExplorerBarTheme := 0;
  if FComboBoxTheme <> 0 then
    CloseThemeData(FComboBoxTheme);
  FComboBoxTheme := 0;
  if FEditTheme <> 0 then
    CloseThemeData(FEditTheme);
  FEditTheme := 0;
  if FRebarTheme <> 0 then
    CloseThemeData(FRebarTheme);
  FRebarTheme := 0;
  if FWindowTheme <> 0 then
    CloseThemeData(FWindowTheme);
  FWindowTheme := 0;
  if FTaskBandTheme <> 0 then
    CloseThemeData(FTaskBandTheme);
  FTaskBandTheme := 0;
  if FTaskBarTheme <> 0 then
    CloseThemeData(FTaskBarTheme);
  FTaskBarTheme := 0;
  if FScrollbarTheme <> 0 then
    CloseThemeData(FScrollbarTheme);
  FScrollbarTheme := 0;
  if FProgressTheme <> 0 then
    CloseThemeData(FProgressTheme);
  FProgressTheme := 0;
end;

procedure TCommonThemeManager.ThemesLoad;
begin
  InitThemeLibrary;
  if Owner.HandleAllocated then
  begin
    if UseThemes then
    begin
      ThemesFree;
      FButtonTheme := OpenThemeData(Owner.Handle, 'button');
      FListviewTheme := OpenThemeData(Owner.Handle, 'listview');
      FHeaderTheme := OpenThemeData(Owner.Handle, 'header');
      FTreeviewTheme := OpenThemeData(Owner.Handle, 'treeview');
      FExplorerBarTheme := OpenThemeData(Owner.Handle, 'explorerbar');
      FComboBoxTheme := OpenThemeData(Owner.Handle, 'combobox');
      FEditTheme := OpenThemeData(Owner.Handle, 'edit');
      FRebarTheme := OpenThemeData(Owner.Handle, 'rebar');
      FWindowTheme := OpenThemeData(Owner.Handle, 'window');
      FTaskBandTheme := OpenThemeData(Owner.Handle, 'taskband');
      FTaskBarTheme := OpenThemeData(Owner.Handle, 'taskbar');
      FScrollbarTheme := OpenThemeData(Owner.Handle, 'scrollbar');
      FProgressTheme := OpenThemeData(Owner.Handle, 'progress');
      FLoaded := True
    end;
    RedrawWindow(Owner.Handle, nil, 0, RDW_FRAME or RDW_INVALIDATE or RDW_NOERASE or RDW_NOCHILDREN);
  end
end;
{$ENDIF USETHEMES}



{ TCommonStream}

function TCommonStream.ReadBoolean: Boolean;
begin
  ReadBuffer(Result, SizeOf(Boolean))
end;

function TCommonStream.ReadByte: Byte;
begin
  ReadBuffer(Result, SizeOf(Byte))
end;

function TCommonStream.ReadInteger: Integer;
begin
  ReadBuffer(Result, SizeOf(Integer))
end;

function TCommonStream.ReadString: AnsiString;
var
  Size: LongWord;
begin
  ReadBuffer(Size, SizeOf(LongWord));
  SetLength(Result, Size);
  ReadBuffer(PAnsiChar(Result)^, Size)
end;

function TCommonStream.ReadStringList: TStringList;
var
  i, Count: LongWord;
begin
  Result := TStringList.Create;
  ReadBuffer(Count, SizeOf(LongWord));
  for i := 0 to Count - 1 do
    Result.Add(ReadString)
end;

function TCommonStream.ReadWideString: WideString;
var
  Size: LongWord;
begin
  ReadBuffer(Size, SizeOf(LongWord));
  SetLength(Result, Size);
  ReadBuffer(PWideChar(Result)^, Size * 2)
end;

procedure TCommonStream.WriteBoolean(Value: Boolean);
begin
  WriteBuffer(Value, SizeOf(Boolean))
end;

procedure TCommonStream.WriteByte(Value: Byte);
begin
  WriteBuffer(Value, SizeOf(Byte))
end;

procedure TCommonStream.WriteInteger(Value: Integer);
begin
  WriteBuffer(Value, SizeOf(Integer))
end;

procedure TCommonStream.WriteString(const Value: AnsiString);
var
  Size: LongWord;
begin
  Size := Length(Value);
  WriteBuffer(Size, SizeOf(Size));
  WriteBuffer(PAnsiChar(Value)^, Size);
end;

procedure TCommonStream.WriteStringList(Value: TStringList);
var
  i, Count: LongWord;
begin
  Count := Value.Count;
  WriteBuffer(Count, SizeOf(Count));
  for i := 0 to Count - 1 do
    WriteString(Value[i])
end;

procedure TCommonStream.WriteWideString(const Value: WideString);
var
  Size: LongWord;
begin
  Size := Length(Value);
  WriteBuffer(Size, SizeOf(Size));
  WriteBuffer(PWideChar(Value)^, Size * 2);
end;

{ CheckBoundManager}
constructor TCommonCheckBoundManager.Create;
begin
  List := TList.Create;
end;

destructor TCommonCheckBoundManager.Destroy;
begin
  Clear;
  FreeAndNil(FList);
end;

function TCommonCheckBoundManager.Find(Size: Integer): TCommonCheckBound;
var
  i: Integer;
  Done: Boolean;
begin
  i := 0;
  Done := False;
  Result := nil;
  while (i < List.Count) and not Done do
  begin
    if CheckBound[i].Size = Size then
    begin
      Done := True;
      Result := CheckBound[i]
    end;
    Inc(i)
  end
end;

function TCommonCheckBoundManager.GetBound(Size: Integer): TRect;
var
  Bounds: TCommonCheckBound;
begin
  Bounds := Find(Size);
  if not Assigned(Bounds) then
  begin
    Bounds := TCommonCheckBound.Create;
    List.Add(Bounds);
    Bounds.Size := Size;
    Bounds.Bounds := CheckBounds(Size);
  end;
  Result := Bounds.Bounds;
end;

function TCommonCheckBoundManager.GetCheckBound(Index: Integer): TCommonCheckBound;
begin
  Result := TCommonCheckBound( List[Index])
end;

procedure TCommonCheckBoundManager.Clear;
var
  i: Integer;
begin
  for i := 0 to List.Count - 1 do
    TObject(List[i]).Free;
  List.Clear;
end;

{ TCommonSysImages }
constructor TCommonSysImages.Create(AOwner: TComponent);
begin
  inherited;
  ShareImages := True;
  ImageSize := sisSmall;
  DrawingStyle := dsTransparent
end;

destructor TCommonSysImages.Destroy;
begin
  inherited;
end;

procedure TCommonSysImages.Flush;
begin
  RecreateHandle
end;

procedure TCommonSysImages.RecreateHandle;
var
  PIDL: PItemIDList;
  Malloc: IMalloc;
  FileInfo: TSHFileInfoA;
  Flags: Longword;
begin
  Handle := 0;
  if FImageSize = sisJumbo then 
  begin
    if Succeeded(SHGetImageList(SHIL_JUMBO, IImageList, FJumboImages)) then
      Handle := THandle(FJumboImages)
    else begin
      Flags := SHGFI_PIDL or SHGFI_SYSICONINDEX or SHGFI_LARGEICON;
      SHGetSpecialFolderLocation(0, CSIDL_DESKTOP, PIDL);
      SHGetMalloc(Malloc);
      Handle := SHGetFileInfoA(PAnsiChar(PIDL), 0, FileInfo, SizeOf(FileInfo), Flags);
      Malloc.Free(PIDL);
    end
  end
  else if FImageSize = sisExtraLarge then
  begin
    if Succeeded(SHGetImageList(SHIL_EXTRALARGE, IImageList, FJumboImages)) then
      Handle := THandle(FJumboImages)
    else begin
      Flags := SHGFI_PIDL or SHGFI_SYSICONINDEX or SHGFI_LARGEICON;
      SHGetSpecialFolderLocation(0, CSIDL_DESKTOP, PIDL);
      SHGetMalloc(Malloc);
      Handle := SHGetFileInfoA(PAnsiChar(PIDL), 0, FileInfo, SizeOf(FileInfo), Flags);
      Malloc.Free(PIDL);
    end
  end else
  begin
    SHGetSpecialFolderLocation(0, CSIDL_DESKTOP, PIDL);
    SHGetMalloc(Malloc);
    if FImageSize = sisSmall then
      Flags := SHGFI_PIDL or SHGFI_SYSICONINDEX or SHGFI_SMALLICON
    else
      Flags := SHGFI_PIDL or SHGFI_SYSICONINDEX or SHGFI_LARGEICON;
    Handle := SHGetFileInfoA(PAnsiChar(PIDL), 0, FileInfo, SizeOf(FileInfo), Flags);
    Malloc.Free(PIDL);
  end;
end;

procedure TCommonSysImages.SetImageSize(const Value: TSysImageListSize);
begin
  FImageSize := Value;
  RecreateHandle;
end;


{$IFNDEF COMPILER_7_UP}
{ TStringListEx }

function TStringListEx.GetNameValueSeparator: Char;
begin
  if FNameValueSeparator = '' then
    NameValueSeparator := '=';
  Result := FNameValueSeparator;
end;

function TStringListEx.GetValueFromIndex(Index: Integer): string;
begin
  if Index >= 0 then
    Result := Copy(Get(Index), Length(Names[Index]) + 2, MaxInt)
  else
    Result := '';
end;

procedure TStringListEx.SetNameValueSeparator(const Value: Char);
begin
  if (FNameValueSeparator <> Value) then
    FNameValueSeparator := Value;
end;

procedure TStringListEx.SetValueFromIndex(Index: Integer;
  const Value: string);
begin
  if Value <> '' then
  begin
    if Index < 0 then Index := Add('');
    Put(Index, Names[Index] + NameValueSeparator + Value);
  end
  else
    if Index >= 0 then Delete(Index);
end;
{$ENDIF}


(*
{ TCommonHintWindow }

constructor TCommonHintWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  OwnerWnd := TWinControl.CreateParented(Application.Handle);
  OwnerWnd.Width := 0;
  OwnerWnd.Height := 0;
  OldWndProc := OwnerWnd.WindowProc;
  OwnerWnd.WindowProc := HookProc;
  Width := 0;
  Height := 0;
end;

destructor TCommonHintWindow.Destroy;
begin
  inherited Destroy;
end;

procedure TCommonHintWindow.ActivateHint(Rect: TRect; const AHint: string);
 type
  TAnimationStyle = (atSlideNeg, atSlidePos, atBlend);
const
  AnimationStyle: array[TAnimationStyle] of Integer = (AW_VER_NEGATIVE,
    AW_VER_POSITIVE, AW_BLEND);
var
  TIA: TOOLINFOA;
  TIW: TOOLINFOW;
  Flags: UINT;
begin
  try
    Caption := AHint;
    Parent := OwnerWnd;

    Inc(Rect.Bottom, 4);
    UpdateBoundsRect(Rect);
    if Rect.Top + Height > Screen.DesktopHeight then
      Rect.Top := Screen.DesktopHeight - Height;
    if Rect.Left + Width > Screen.DesktopWidth then
      Rect.Left := Screen.DesktopWidth - Width;
    if Rect.Left < Screen.DesktopLeft then Rect.Left := Screen.DesktopLeft;
    if Rect.Bottom < Screen.DesktopTop then Rect.Bottom := Screen.DesktopTop;

    Flags := TTF_IDISHWND or TTF_SUBCLASS or TTF_TRANSPARENT;

    if IsUnicode then
    begin
      Fillchar(TIW, SizeOf(TIW), #0);
      TIW.cbSize := SizeOf(TIW);
      TIW.hwnd := OwnerWnd.Handle;
      TIW.lpszText := PWideChar( FCaption);
      TIW.uFlags := Flags;
      TIW.hInst := hInstance;
      TIW.Rect := Rect;
      TIW.uID := Handle;
      SendMessage(Handle, TTM_ADDTOOLW, 0, Integer(@TIW));
      SendMessage(Handle, TTM_TRACKACTIVATE, Integer(BOOL(True)), Integer(@TIW));
    end else
    begin
      Fillchar(TIA, SizeOf(TIA), #0);
      TIA.cbSize := SizeOf(TIA);
      TIW.hwnd := OwnerWnd.Handle;
      TIA.lpszText := PAnsiChar( FAnsiCaption);
      TIA.uFlags := Flags;
      TIA.hInst := hInstance;
      TIA.Rect := Rect;
      TIA.uID := Handle;
      SendMessage(Handle, TTM_ADDTOOLA, 0, Integer(@TIA));
      SendMessage(Handle, TTM_TRACKACTIVATE, Integer(BOOL(True)), Integer(@TIA));
    end;
    FTipShowing := True;
  finally
    FNewLastActive := GetTickCount;
  end;
end;

procedure TCommonHintWindow.CreateParams(var Params: TCreateParams);
begin
  InitCommonControl(ICC_BAR_CLASSES);
  inherited CreateParams(Params);
  CreateSubClass(Params, TOOLTIPS_CLASS);
  Params.WndParent := OwnerWnd.Handle;
  Params.Style := WS_POPUP or TTS_NOPREFIX or TTS_ALWAYSTIP;
end;

procedure TCommonHintWindow.CreateWindowHandle(const Params: TCreateParams);
var
  WideClassName: WideString;
begin
  if IsUnicode then
  begin
    WideClassName := Params.WinClassName;
    WindowHandle := CreateWindowExW(Params.ExStyle, PWideChar( WideClassName), PWidechar( Caption),
      Params.Style, Params.X, Params.Y, Params.Width, Params.Height, Params.WndParent, 0, Params.WindowClass.hInstance,
      Params.Param)
  end else
    inherited CreateWindowHandle(Params);
end;

procedure TCommonHintWindow.CreateWnd;
begin
  inherited CreateWnd;
  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE);
end;

procedure TCommonHintWindow.DestroyWnd;
begin
  inherited DestroyWnd;
end;

procedure TCommonHintWindow.HookProc(var Message: TMessage);
var
  NMHDR: PNMHDR;
begin
  if Message.Msg = WM_NOTIFY then
  begin
    if Message.wParam = Integer( Handle) then
    begin
      NMHDR := PNMHDR(Message.LParam);
      case NMHDR.code of
        TTN_POP: begin
    //        beep;
          end;
        TTN_SHOW: begin
    //        beep;
          end;
      end;
    end;
  end;
  OldWndProc(Message);
end;

procedure TCommonHintWindow.SetCaption(const Value: WideString);
begin
  FCaption := Value;
  AnsiCaption := Value;
end;

procedure TCommonHintWindow.WMDestroy(var Msg: TMessage);
begin
  inherited;
end;

procedure TCommonHintWindow.WMEraseBkgnd(var Msg: TWMEraseBkgnd);
begin
  // Don't do VCL default
  CallWindowProc(DefWndProc, Handle, TMessage(Msg).Msg, TMessage(Msg).wParam, TMessage(Msg).lParam);
end;

procedure TCommonHintWindow.WMNCPaint(var Msg: TWMNCPaint);
begin
  // Don't do VCL default
  CallWindowProc(DefWndProc, Handle, TMessage(Msg).Msg, TMessage(Msg).wParam, TMessage(Msg).lParam);
end;

procedure TCommonHintWindow.WMPaint(var Msg: TWMPaint);
begin
  // Don't do VCL default
   CallWindowProc(DefWndProc, Handle, TMessage(Msg).Msg, TMessage(Msg).wParam, TMessage(Msg).lParam);
end;

procedure TCommonHintWindow.WMShowWindow(var Msg: TWMShowWindow);
var
  TIA: TOOLINFOA;
  TIW: TOOLINFOW;
  Flags: UINT;
begin
  if not Msg.Show and TipShowing then
  begin
    Flags := TTF_IDISHWND or TTF_SUBCLASS or TTF_TRANSPARENT;

    if IsUnicode then
    begin
      Fillchar(TIW, SizeOf(TIW), #0);
      TIW.cbSize := SizeOf(TIW);
      TIW.hwnd := OwnerWnd.Handle;
      TIW.lpszText := PWideChar( FCaption);
      TIW.uFlags := Flags;
      TIW.hInst := hInstance;
      TIW.uID := Handle;
      SendMessage(Handle, TTM_TRACKACTIVATE, Integer(BOOL(False)), Integer(@TIW));
      SendMessage(Handle, TTM_DELTOOLW, 0, Integer(@TIW));
    end else
    begin
      Fillchar(TIA, SizeOf(TIA), #0);
      TIA.cbSize := SizeOf(TIA);
      TIW.hwnd := OwnerWnd.Handle;
      TIA.lpszText := PAnsiChar( FAnsiCaption);
      TIA.uFlags := Flags;
      TIA.hInst := hInstance;
      TIA.uID := Handle;
      SendMessage(Handle, TTM_TRACKACTIVATE, Integer(BOOL(False)), Integer(@TIA));
      SendMessage(Handle, TTM_DELTOOLA, 0, Integer(@TIA));
    end;
    FTipShowing := False
  end
end;

*)

initialization
  LoadShell32Functions;
  LoadWideFunctions;
  StreamHelper := TCommonMemoryStreamHelper.Create;
  MarlettFont := TFont.Create;
  MarlettFont.Name := 'marlett';
  Checks := TCommonCheckBoundManager.Create;
  PIDLMgr := TCommonPIDLManager.Create;

finalization
  if FreeShellLib then
    FreeLibrary(ShellDLL);
  StreamHelper.Free;
  FreeAndNil(Checks);
  FreeAndNil(MarlettFont);
  FLargeSysImages.Free;
  FSmallSysImages.Free;
  FExtraLargeSysImages.Free;
  FJumboSysImages.Free;
  FreeAndNil(PIDLMgr);

end.










