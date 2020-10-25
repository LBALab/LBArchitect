{-------------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

Code template generated with SynGen.
The original code is: scLifeScriptHL.pas, released 2007-11-20.
Description: LifeScript Highlighter
The initial author of this file is Zink.
Copyright (c) 2007, all rights reserved.

Contributors to the SynEdit and mwEdit projects are listed in the
Contributors.txt file.

Alternatively, the contents of this file may be used under the terms of the
GNU General Public License Version 2 or later (the "GPL"), in which case
the provisions of the GPL are applicable instead of those above.
If you wish to allow use of your version of this file only under the terms
of the GPL and not to allow others to use your version of this file
under the MPL, indicate your decision by deleting the provisions above and
replace them with the notice and other provisions required by the GPL.
If you do not delete the provisions above, a recipient may use your version
of this file under either the MPL or the GPL.

-------------------------------------------------------------------------------}

unit scTrackScript2HL;

{$I SynEdit.inc}

interface

uses
{$IFDEF SYN_CLX}
  QGraphics,
  QSynEditTypes,
  QSynEditHighlighter,
{$ELSE}
  Graphics,
  SynEditTypes,
  SynEditHighlighter,
{$ENDIF}
  SysUtils,
  Classes;

type
  TtkTokenKind = (
    tkCommand,
    tkComment,
    tkKey,
    tkLabel,
    tkNull,
    tkNumber,
    tkSpace,
    tkStatement,
    tkIdentifier,
    tkUnknown);

  TRangeState = (rsUnKnown, rsBraceComment, rsCStyleComment, rsDelphiComment,
   rsCStyleSingleLine, rsREMSingleLine, rsCondition);

  TProcTableProc = procedure of object;

  PIdentFuncTableFunc = ^TIdentFuncTableFunc;
  TIdentFuncTableFunc = function: TtkTokenKind of object;

const
  MaxKey = 269;

type
  TSynTrackScript2HL = class(TSynCustomHighlighter)
  private
    fLineRef: string;
    fLine: PChar;
    fLineNumber: Integer;
    fProcTable: array[#0..#255] of TProcTableProc;
    fRange: TRangeState;
    Run: LongInt;
    fStringLen: Integer;
    fToIdent: PChar;
    fTokenPos: Integer;
    fTokenID: TtkTokenKind;
    fPrevIdent: TtkTokenKind;
    fPrevLabel: Boolean; //if the last identifier was a command accepting string parameters
    fIdentFuncTable: array[0 .. MaxKey] of TIdentFuncTableFunc;
    fCommandAttri: TSynHighlighterAttributes;
    fCommentAttri: TSynHighlighterAttributes;
    fKeyAttri: TSynHighlighterAttributes;
    fLabelAttri: TSynHighlighterAttributes;
    fNumberAttri: TSynHighlighterAttributes;
    fSpaceAttri: TSynHighlighterAttributes;
    fStatementAttri: TSynHighlighterAttributes;
    fIdentifierAttri: TSynHighlighterAttributes;
    fUnknownAttri: TSynHighlighterAttributes;
    function KeyHash(ToHash: PChar): Integer;
    function KeyComp(const aKey: string): Boolean;
    {$I scTrackScript2IdentHeads.inc}
    procedure IdentProc;
    procedure UnknownProc;
    function AltFunc: TtkTokenKind;
    procedure InitIdent;
    function IdentKind(MayBe: PChar): TtkTokenKind;
    procedure MakeMethodTables;
    procedure NullProc;
    procedure SpaceProc;
    procedure IntegerProc;
    procedure CRProc;
    procedure LFProc;
    procedure BraceCommentOpenProc;
    procedure BraceCommentProc;
    procedure CStyleCommentOpenProc;
    //procedure CStyleCommentProc;
    //procedure DelphiCommentOpenProc;
    //procedure DelphiCommentProc;
    procedure CStyleSingleLineProc;
    procedure REMCommentOpenProc;
  protected
    function GetIdentChars: TSynIdentChars; override;
    function GetSampleSource: string; override;
    function IsFilterStored: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    {$IFNDEF SYN_CPPB_1} class {$ENDIF}
    function GetLanguageName: string; override;
    function GetRange: Pointer; override;
    procedure ResetRange; override;
    procedure SetRange(Value: Pointer); override;
    function GetDefaultAttribute(Index: integer): TSynHighlighterAttributes; override;
    function GetEol: Boolean; override;
    function GetKeyWords: string;
    function GetTokenID: TtkTokenKind;
    procedure SetLine(NewValue: String; LineNumber: Integer); override;
    function GetToken: String; override;
    function GetTokenAttribute: TSynHighlighterAttributes; override;
    function GetTokenKind: integer; override;
    function GetTokenPos: Integer; override;
    procedure Next; override;
  published
    property CommandAttri: TSynHighlighterAttributes read fCommandAttri write fCommandAttri;
    property CommentAttri: TSynHighlighterAttributes read fCommentAttri write fCommentAttri;
    property KeyAttri: TSynHighlighterAttributes read fKeyAttri write fKeyAttri;
    property LabelAttri: TSynHighlighterAttributes read fLabelAttri write fLabelAttri;
    property NumberAttri: TSynHighlighterAttributes read fNumberAttri write fNumberAttri;
    property SpaceAttri: TSynHighlighterAttributes read fSpaceAttri write fSpaceAttri;
    property StatementAttri: TSynHighlighterAttributes read fStatementAttri write fStatementAttri;
    property IdentifierAttri: TSynHighlighterAttributes read fIdentifierAttri write fIdentifierAttri;
    property UnknownAttri: TSynHighlighterAttributes read fUnknownAttri write fUnknownAttri;
  end;

implementation

uses
{$IFDEF SYN_CLX}
  QSynEditStrConst;
{$ELSE}
  SynEditStrConst;
{$ENDIF}

{$IFDEF SYN_COMPILER_3_UP}
resourcestring
{$ELSE}
const
{$ENDIF}
  SYNS_FilterTrackScript = 'All files (*.*)|*.*';
  SYNS_LangTrackScript = 'Track Script';
  SYNS_AttrCommand = 'Command';
  SYNS_AttrStatement = 'Statement';
  SYNS_AttrUnknown = 'Unknown';
  SYNS_AttrBehaviour = 'Behaviour';

var
  Identifiers: array[#0..#255] of ByteBool;
  mHashTable : array[#0..#255] of Integer;

procedure MakeIdentTable;
var
  I, J: Char;
begin
  for I := #0 to #255 do
  begin
    case I of
      '_', '.', '0'..'9', 'a'..'z', 'A'..'Z': Identifiers[I] := True;
    else
      Identifiers[I] := False;
    end;
    J := UpCase(I);
    case I in ['_', {'0'..'9',} 'A'..'Z', 'a'..'z'] of
      True: mHashTable[I] := Ord(J) - 64
    else
      mHashTable[I] := 0;
    end;
  end;
end;

procedure TSynTrackScript2HL.InitIdent;
var
  I: Integer;
  pF: PIdentFuncTableFunc;
begin
  pF := PIdentFuncTableFunc(@fIdentFuncTable);
  for I := Low(fIdentFuncTable) to High(fIdentFuncTable) do
  begin
    pF^ := AltFunc;
    Inc(pF);
  end;
  {$I scTrackScript2IdentTable.inc}
end;

function TSynTrackScript2HL.KeyHash(ToHash: PChar): Integer;
begin
  Result := 0;
  while ToHash^ in ['_', '0'..'9', 'a'..'z', 'A'..'Z'] do
  begin
    if not (ToHash^ in ['0'..'9']) then
     inc(Result, mHashTable[ToHash^]);
    inc(ToHash);
  end;
  fStringLen := ToHash - fToIdent;
end;

function TSynTrackScript2HL.KeyComp(const aKey: String): Boolean;
var
  I: Integer;
  Temp: PChar;
begin
  Temp := fToIdent;
  if Length(aKey) = fStringLen then
  begin
    Result := True;
    for i := 1 to fStringLen do
    begin
      if mHashTable[Temp^] <> mHashTable[aKey[i]] then
      begin
        Result := False;
        break;
      end;
      inc(Temp);
    end;
  end
  else
    Result := False;
end;

{$I scTrackScript2IdentFuncs.inc}

function TSynTrackScript2HL.AltFunc: TtkTokenKind;
begin
  Result := tkIdentifier;
end;

function TSynTrackScript2HL.IdentKind(MayBe: PChar): TtkTokenKind;
var
  HashKey: Integer;
begin
  fToIdent := MayBe;
  HashKey := KeyHash(MayBe);
  if HashKey <= MaxKey then
    Result := fIdentFuncTable[HashKey]
  else
    Result := tkIdentifier;

  if (Result = tkIdentifier) then begin
    if not fPrevLabel then
      Result:= tkUnknown;
    fPrevLabel:= False;
  end;
end;

procedure TSynTrackScript2HL.MakeMethodTables;
var
  I: Char;
begin
  for I := #0 to #255 do
    case I of
      #0: fProcTable[I] := NullProc;
      #10: fProcTable[I] := LFProc;
      #13: fProcTable[I] := CRProc;
      '{': fProcTable[I] := BraceCommentOpenProc;
      '/': fProcTable[I] := CStyleCommentOpenProc;
      //'(': fProcTable[I] := DelphiCommentOpenProc;
      'R', 'r': fProcTable[I]:= REMCommentOpenProc;
      #1..#9,
      #11,
      #12,
      #14..#32 : fProcTable[I] := SpaceProc;
      '0'..'9', '-': fProcTable[I]:= IntegerProc;
      'A'..'Q', 'S'..'Z', 'a'..'q', 's'..'z', '_': fProcTable[I]:= IdentProc;
    else
      fProcTable[I]:= UnknownProc;
    end;
end;

procedure TSynTrackScript2HL.SpaceProc;
begin
  if not (fTokenID in [tkSpace]) then
    fPrevIdent:= fTokenID;
  fTokenID := tkSpace;
  repeat
    inc(Run);
  until not (fLine[Run] in [#1..#32]);
end;

procedure TSynTrackScript2HL.NullProc;
begin
  fTokenID := tkNull;
end;

procedure TSynTrackScript2HL.IntegerProc;
begin
 Inc(Run);
 fTokenID := tkNumber;
 while FLine[Run] in ['0'..'9'] do
  Inc(Run);

 if not (fPrevIdent in [tkCommand, tkStatement, tkKey]) then
   fTokenID:= tkUnknown;
end;

procedure TSynTrackScript2HL.CRProc;
begin
  fTokenID := tkSpace;
  inc(Run);
  if fLine[Run] = #10 then
    inc(Run);
end;

procedure TSynTrackScript2HL.LFProc;
begin
  fTokenID := tkSpace;
  inc(Run);
end;

procedure TSynTrackScript2HL.BraceCommentOpenProc;
begin
  Inc(Run);
  fRange := rsBraceComment;
  BraceCommentProc;
  fTokenID := tkComment;
end;

procedure TSynTrackScript2HL.BraceCommentProc;
begin
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  else
    begin
      fTokenID := tkComment;
      repeat
        if (fLine[Run] = '}') then
        begin
          Inc(Run, 1);
          fRange := rsUnKnown;
          Break;
        end;
        if not (fLine[Run] in [#0, #10, #13]) then
          Inc(Run);
      until fLine[Run] in [#0, #10, #13];
    end;
  end;
end;

procedure TSynTrackScript2HL.CStyleCommentOpenProc;
begin
  Inc(Run);
  {if (fLine[Run] = '*') then
  begin
    fRange := rsCStyleComment;
    CStyleCommentProc;
    fTokenID := tkComment;
  end
  else} if (fLine[Run] = '/') then begin
   fRange:= rsCStyleSingleLine;
   CStyleSingleLineProc;
   fTokenID:= tkComment;
  end
  else
    fTokenID := tkIdentifier;
end;

{procedure TSynTrackScript1HL.CStyleCommentProc;
begin
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  else
    begin
      fTokenID := tkComment;
      repeat
        if (fLine[Run] = '*') and
           (fLine[Run + 1] = '/') then
        begin
          Inc(Run, 2);
          fRange := rsUnKnown;
          Break;
        end;
        if not (fLine[Run] in [#0, #10, #13]) then
          Inc(Run);
      until fLine[Run] in [#0, #10, #13];
    end;
  end;
end;}

{procedure TSynTrackScript1HL.DelphiCommentOpenProc;
begin
  Inc(Run);
  if (fLine[Run] = '*') then
  begin
    fRange := rsDelphiComment;
    DelphiCommentProc;
    fTokenID := tkComment;
  end
  else
    fTokenID := tkIdentifier;
end;

procedure TSynTrackScript1HL.DelphiCommentProc;
begin
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  else
    begin
      fTokenID := tkComment;
      repeat
        if (fLine[Run] = '*') and
           (fLine[Run + 1] = ')') then
        begin
          Inc(Run, 2);
          fRange := rsUnKnown;
          Break;
        end;
        if not (fLine[Run] in [#0, #10, #13]) then
          Inc(Run);
      until fLine[Run] in [#0, #10, #13];
    end;
  end;
end;}

procedure TSynTrackScript2HL.CStyleSingleLineProc;
begin
  fTokenID := tkComment;
  repeat
    Inc(Run);
  until fLine[Run] in [#0, #10, #13];
  fRange := rsUnKnown;
end;

procedure TSynTrackScript2HL.REMCommentOpenProc;
begin
  If (Length(fLine) - 1 >= Run + 2)
  and (fLine[Run+1] in ['e', 'E']) and (fLine[Run+2] in['m', 'M'])
  and ((Length(fLine) - 1 < Run + 3)
    or (fLine[Run+3] in [' ', '{', '/', #13, #10])) then
  begin
    fRange := rsREMSingleLine;
    CStyleSingleLineProc;
    fTokenID := tkComment;
  end
  else
    IdentProc;
end;

constructor TSynTrackScript2HL.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fCommandAttri := TSynHighLighterAttributes.Create(SYNS_AttrCommand);
  fCommandAttri.Foreground:= clNavy;
  AddAttribute(fCommandAttri);

  fCommentAttri := TSynHighLighterAttributes.Create(SYNS_AttrComment);
  fCommentAttri.Style := [fsItalic];
  fCommentAttri.Foreground := clGray; //clTeal;
  AddAttribute(fCommentAttri);

  fKeyAttri := TSynHighLighterAttributes.Create(SYNS_AttrReservedWord);
  fKeyAttri.Style := [fsBold];
  AddAttribute(fKeyAttri);

  fLabelAttri := TSynHighLighterAttributes.Create(SYNS_AttrLabel);
  fLabelAttri.Foreground := clNavy;
  AddAttribute(fLabelAttri);

  fNumberAttri := TSynHighLighterAttributes.Create(SYNS_AttrNumber);
  fNumberAttri.Foreground := clMaroon;
  AddAttribute(fNumberAttri);

  fSpaceAttri := TSynHighLighterAttributes.Create(SYNS_AttrSpace);
  AddAttribute(fSpaceAttri);

  fStatementAttri := TSynHighLighterAttributes.Create(SYNS_AttrStatement);
  fStatementAttri.Style := [fsBold];
  fStatementAttri.Foreground := clGreen;
  AddAttribute(fStatementAttri);

  fIdentifierAttri := TSynHighLighterAttributes.Create(SYNS_AttrIdentifier);
  fIdentifierAttri.Foreground:= clMaroon;
  AddAttribute(fIdentifierAttri);

  fUnknownAttri := TSynHighLighterAttributes.Create(SYNS_AttrUnknown);
  fUnknownAttri.Foreground:= clRed;
  AddAttribute(fUnknownAttri);

  SetAttributesOnChange(DefHighlightChange);
  InitIdent;
  MakeMethodTables;
  fDefaultFilter := SYNS_FilterTrackScript;
  fRange := rsUnknown;
end;

procedure TSynTrackScript2HL.SetLine(NewValue: String; LineNumber: Integer);
begin
  fLineRef := NewValue;
  fLine := PChar(fLineRef);
  Run := 0;
  fLineNumber := LineNumber;
  fPrevIdent:= tkNull;
  fPrevLabel:= False;
  Next;
end;

procedure TSynTrackScript2HL.IdentProc;
begin
  fTokenID := IdentKind((fLine + Run));
  inc(Run, fStringLen);
  while Identifiers[fLine[Run]] do
    Inc(Run);
end;

procedure TSynTrackScript2HL.UnknownProc;
begin
{$IFDEF SYN_MBCSSUPPORT}
  if FLine[Run] in LeadBytes then
    Inc(Run,2)
  else
{$ENDIF}
  inc(Run);
  fTokenID := tkUnknown;
end;

procedure TSynTrackScript2HL.Next;
begin
  fTokenPos := Run;
  case fRange of
    rsBraceComment: BraceCommentProc;
    //rsCStyleComment: CStyleCommentProc;
    //rsDelphiComment: DelphiCommentProc;
  else
    begin
      fRange := rsUnknown;
      fProcTable[fLine[Run]];
    end;
  end;
end;

function TSynTrackScript2HL.GetDefaultAttribute(Index: integer): TSynHighLighterAttributes;
begin
  case Index of
    SYN_ATTR_COMMENT    : Result := fCommentAttri;
    SYN_ATTR_KEYWORD    : Result := fKeyAttri;
    SYN_ATTR_WHITESPACE : Result := fSpaceAttri;
  else
    Result := nil;
  end;
end;

function TSynTrackScript2HL.GetEol: Boolean;
begin
  Result := fTokenID = tkNull;
end;

function TSynTrackScript2HL.GetKeyWords: string;
begin
  Result := 'LABEL,GOTO,END,STOP';
end;

function TSynTrackScript2HL.GetToken: String;
var
  Len: LongInt;
begin
  Len := Run - fTokenPos;
  SetString(Result, (FLine + fTokenPos), Len);
end;

function TSynTrackScript2HL.GetTokenID: TtkTokenKind;
begin
  Result := fTokenId;
end;

function TSynTrackScript2HL.GetTokenAttribute: TSynHighLighterAttributes;
begin
  case GetTokenID of
    tkCommand: Result := fCommandAttri;
    tkComment: Result := fCommentAttri;
    tkKey: Result := fKeyAttri;
    tkLabel: Result := fLabelAttri;
    tkNumber: Result := fNumberAttri;
    tkSpace: Result := fSpaceAttri;
    tkStatement: Result := fStatementAttri;
    tkIdentifier: Result:= fIdentifierAttri;
    tkUnknown: Result := fUnknownAttri;
  else
    Result := nil;
  end;
end;

function TSynTrackScript2HL.GetTokenKind: integer;
begin
  Result := Ord(fTokenId);
end;

function TSynTrackScript2HL.GetTokenPos: Integer;
begin
  Result := fTokenPos;
end;

function TSynTrackScript2HL.GetIdentChars: TSynIdentChars;
begin
  Result := ['_', 'a'..'z', 'A'..'Z'];
end;

function TSynTrackScript2HL.GetSampleSource: string;
begin
  Result := '';
end;

function TSynTrackScript2HL.IsFilterStored: Boolean;
begin
  Result := fDefaultFilter <> SYNS_FilterTrackScript;
end;

{$IFNDEF SYN_CPPB_1} class {$ENDIF}
function TSynTrackScript2HL.GetLanguageName: string;
begin
  Result := SYNS_LangTrackScript;
end;

procedure TSynTrackScript2HL.ResetRange;
begin
  fRange := rsUnknown;
end;

procedure TSynTrackScript2HL.SetRange(Value: Pointer);
begin
  fRange := TRangeState(Value);
end;

function TSynTrackScript2HL.GetRange: Pointer;
begin
  Result := Pointer(fRange);
end;

initialization
  MakeIdentTable;
{$IFNDEF SYN_CPPB_1}
  RegisterPlaceableHighlighter(TSynTrackScript2HL);
{$ENDIF}
end.
