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

unit scLifeScript1HL;

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
    tkCondition,
    tkIf,
    tkLabel,
    tkNull,
    tkNumber,
    tkSpace,
    tkStatement,
    tkIdentifier,
    tkOperator,
    tkParameter,
    tkKeyword,
    tkUnknown);

  TRangeState = (rsUnKnown, rsBraceComment, rsCStyleComment, rsDelphiComment,
   rsCStyleSingleLine, rsREMSingleLine, rsCondition);

  TProcTableProc = procedure of object;

  PIdentFuncTableFunc = ^TIdentFuncTableFunc;
  TIdentFuncTableFunc = function: TtkTokenKind of object;

const
  MaxKey = 297;

type
  TSynLifeScript1HL = class(TSynCustomHighlighter)
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
    fConditionAttri: TSynHighlighterAttributes;
    fIfAttri: TSynHighlighterAttributes;
    fLabelAttri: TSynHighlighterAttributes;
    fNumberAttri: TSynHighlighterAttributes;
    fSpaceAttri: TSynHighlighterAttributes;
    fStatementAttri: TSynHighlighterAttributes;
    fIdentifierAttri: TSynHighlighterAttributes;
    fOperatorAttri: TSynHighlighterAttributes;
    fParameterAttri: TSynHighlighterAttributes;
    fKeywordAttri: TSynHighlighterAttributes;
    fUnknownAttri: TSynHighlighterAttributes;
    function KeyHash(ToHash: PChar): Integer;
    function KeyComp(const aKey: string): Boolean;
    {$I scLifeScript1IdentHeads.inc}
    procedure IdentProc;
    procedure UnknownProc;
    function AltFunc: TtkTokenKind;
    procedure InitIdent;
    function IdentKind(MayBe: PChar): TtkTokenKind;
    procedure MakeMethodTables;
    procedure NullProc;
    procedure SpaceProc;
    procedure OperatorProc;
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
    property ConditionAttri: TSynHighlighterAttributes read fConditionAttri write fConditionAttri;
    property IfAttri: TSynHighlighterAttributes read fIfAttri write fIfAttri;
    property LabelAttri: TSynHighlighterAttributes read fLabelAttri write fLabelAttri;
    property NumberAttri: TSynHighlighterAttributes read fNumberAttri write fNumberAttri;
    property SpaceAttri: TSynHighlighterAttributes read fSpaceAttri write fSpaceAttri;
    property StatementAttri: TSynHighlighterAttributes read fStatementAttri write fStatementAttri;
    property IdentifierAttri: TSynHighlighterAttributes read fIdentifierAttri write fIdentifierAttri;
    property OperatorAttri: TSynHighlighterAttributes read fOperatorAttri write fOperatorAttri;
    property ParameterAttri: TSynHighlighterAttributes read fParameterAttri write fParameterAttri;
    property KeywordAttri: TSynHighlighterAttributes read fKeywordAttri write fKeywordAttri;
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
  SYNS_FilterLifeScript = 'All files (*.*)|*.*';
  SYNS_LangLifeScript = 'Life Script';
  SYNS_AttrCommand = 'Command';
  SYNS_AttrIf = 'If';
  SYNS_AttrStatement = 'Statement';
  SYNS_AttrUnknown = 'Unknown';
  SYNS_AttrParameter = 'Parameter';

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

procedure TSynLifeScript1HL.InitIdent;
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
  {$I scLifeScript1IdentTable.inc}
end;

function TSynLifeScript1HL.KeyHash(ToHash: PChar): Integer;
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

function TSynLifeScript1HL.KeyComp(const aKey: String): Boolean;
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

{$I scLifeScript1IdentFuncs.inc}

function TSynLifeScript1HL.AltFunc: TtkTokenKind;
begin
  Result := tkIdentifier;
end;

function TSynLifeScript1HL.IdentKind(MayBe: PChar): TtkTokenKind;
var
  HashKey: Integer;
begin
  fToIdent := MayBe;
  HashKey := KeyHash(MayBe);
  if HashKey <= MaxKey then
    Result := fIdentFuncTable[HashKey]
  else
    Result := tkIdentifier;

  case Result of
   tkIdentifier: begin
     if not fPrevLabel then Result:= tkUnknown;
     fPrevLabel:= False;
   end;
   tkCondition:
     if fPrevIdent <> tkIf then Result:= tkUnknown;
   tkCommand:
     if fPrevIdent = tkIf then Result:= tkUnknown;
  end;
end;

procedure TSynLifeScript1HL.MakeMethodTables;
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
      '=', '>', '<', '!': fProcTable[I]:= OperatorProc;
      '0'..'9', '-': fProcTable[I]:= IntegerProc;
      'A'..'Q', 'S'..'Z', 'a'..'q', 's'..'z', '_': fProcTable[I] := IdentProc;
    else
      fProcTable[I] := UnknownProc;
    end;
end;

procedure TSynLifeScript1HL.SpaceProc;
begin
  if not (fTokenID in [tkSpace]) then
    fPrevIdent:= fTokenID;
  fTokenID := tkSpace;
  repeat
    inc(Run);
  until not (fLine[Run] in [#1..#32]);
end;

procedure TSynLifeScript1HL.NullProc;
begin
  fTokenID := tkNull;
end;

procedure TSynLifeScript1HL.OperatorProc;
begin
 fTokenID:= tkOperator;
 case fLine[Run] of
  '=', '!': if (fLine[Run + 1] = '=') then Inc(Run) else fTokenID:= tkUnknown;
  '<', '>': if (fLine[Run + 1] = '=') then Inc(Run);
 else fTokenID:= tkUnknown;
 end;
 Inc(Run);
end;

procedure TSynLifeScript1HL.IntegerProc;
begin
 Inc(Run);
 fTokenID := tkNumber;
 while FLine[Run] in ['0'..'9'] do
  Inc(Run);

 if not (fPrevIdent in [tkOperator, tkCommand, tkCondition,
                        tkStatement, tkNumber, tkKeyword, tkParameter]) then
   fTokenID:= tkUnknown;
end;

procedure TSynLifeScript1HL.CRProc;
begin
  fTokenID := tkSpace;
  inc(Run);
  if fLine[Run] = #10 then
    inc(Run);
end;

procedure TSynLifeScript1HL.LFProc;
begin
  fTokenID := tkSpace;
  inc(Run);
end;

procedure TSynLifeScript1HL.BraceCommentOpenProc;
begin
  Inc(Run);
  fRange := rsBraceComment;
  BraceCommentProc;
  fTokenID := tkComment;
end;

procedure TSynLifeScript1HL.BraceCommentProc;
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

procedure TSynLifeScript1HL.CStyleCommentOpenProc;
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

{procedure TSynLifeScript1HL.CStyleCommentProc;
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

{procedure TSynLifeScript1HL.DelphiCommentOpenProc;
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
end;}

{procedure TSynLifeScript1HL.DelphiCommentProc;
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

procedure TSynLifeScript1HL.CStyleSingleLineProc;
begin
  fTokenID := tkComment;
  repeat
    Inc(Run);
  until fLine[Run] in [#0, #10, #13];
  fRange := rsUnKnown;
end;

procedure TSynLifeScript1HL.REMCommentOpenProc;
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

constructor TSynLifeScript1HL.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fCommandAttri := TSynHighLighterAttributes.Create(SYNS_AttrCommand);
  fCommandAttri.Foreground:= clNavy;
  AddAttribute(fCommandAttri);

  fCommentAttri := TSynHighLighterAttributes.Create(SYNS_AttrComment);
  fCommentAttri.Style := [fsItalic];
  fCommentAttri.Foreground := clGray; //clTeal;
  AddAttribute(fCommentAttri);

  fConditionAttri := TSynHighLighterAttributes.Create(SYNS_AttrCondition);
  fConditionAttri.Foreground := clBlue;
  AddAttribute(fConditionAttri);

  fIfAttri:= TSynHighLighterAttributes.Create(SYNS_AttrIf);
  fIfAttri.Style:= [fsBold];
  AddAttribute(fIfAttri);

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

  fOperatorAttri := TSynHighLighterAttributes.Create(SYNS_AttrOperator);
  fOperatorAttri.Foreground:= clNone;
  AddAttribute(fOperatorAttri);

  fParameterAttri := TSynHighLighterAttributes.Create(SYNS_AttrParameter);
  fParameterAttri.Foreground:= clOlive;
  AddAttribute(fParameterAttri);

  fKeywordAttri:= TSynHighLighterAttributes.Create(SYNS_AttrReservedWord);
  fKeywordAttri.Style:= [fsBold];
  //fKeywordAttri.Foreground:= clMaroon;
  AddAttribute(fKeywordAttri);

  fUnknownAttri := TSynHighLighterAttributes.Create(SYNS_AttrUnknown);
  fUnknownAttri.Foreground:= clRed;
  AddAttribute(fUnknownAttri);

  SetAttributesOnChange(DefHighlightChange);
  InitIdent;
  MakeMethodTables;
  fDefaultFilter := SYNS_FilterLifeScript;
  fRange := rsUnknown;
end;

procedure TSynLifeScript1HL.SetLine(NewValue: String; LineNumber: Integer);
begin
  fLineRef := NewValue;
  fLine := PChar(fLineRef);
  Run := 0;
  fLineNumber := LineNumber;
  fPrevIdent:= tkNull;
  fPrevLabel:= False;
  Next;
end;

procedure TSynLifeScript1HL.IdentProc;
begin
  fTokenID := IdentKind((fLine + Run));
  inc(Run, fStringLen);
  while Identifiers[fLine[Run]] do
    Inc(Run);
end;

procedure TSynLifeScript1HL.UnknownProc;
begin
{$IFDEF SYN_MBCSSUPPORT}
  if FLine[Run] in LeadBytes then
    Inc(Run,2)
  else
{$ENDIF}
  inc(Run);
  fTokenID := tkUnknown;
end;

procedure TSynLifeScript1HL.Next;
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

function TSynLifeScript1HL.GetDefaultAttribute(Index: integer): TSynHighLighterAttributes;
begin
  case Index of
    SYN_ATTR_COMMENT    : Result := fCommentAttri;
    SYN_ATTR_KEYWORD    : Result := fKeywordAttri;
    SYN_ATTR_WHITESPACE : Result := fSpaceAttri;
  else
    Result := nil;
  end;
end;

function TSynLifeScript1HL.GetEol: Boolean;
begin
  Result := fTokenID = tkNull;
end;

function TSynLifeScript1HL.GetKeyWords: string;
begin
  Result := 
    'COMPORTMENT,ELSE,END,END_COMPORTMENT,ENDIF,IF,ONEIF,OR_IF,SWIF,NEVERIF';
end;

function TSynLifeScript1HL.GetToken: String;
var
  Len: LongInt;
begin
  Len := Run - fTokenPos;
  SetString(Result, (FLine + fTokenPos), Len);
end;

function TSynLifeScript1HL.GetTokenID: TtkTokenKind;
begin
  Result := fTokenId;
end;

function TSynLifeScript1HL.GetTokenAttribute: TSynHighLighterAttributes;
begin
  case GetTokenID of
    tkCommand: Result:= fCommandAttri;
    tkComment: Result:= fCommentAttri;
    tkCondition: Result:= fConditionAttri;
    tkIf: Result:= fIfAttri;
    tkLabel: Result:= fLabelAttri;
    tkNumber: Result:= fNumberAttri;
    tkSpace: Result:= fSpaceAttri;
    tkStatement: Result:= fStatementAttri;
    tkIdentifier: Result:= fIdentifierAttri;
    tkOperator: Result:= fOperatorAttri;
    tkParameter: Result:= fParameterAttri;
    tkKeyword: Result:= fKeywordAttri;
    tkUnknown: Result:= fUnknownAttri;
  else
    Result := nil;
  end;
end;

function TSynLifeScript1HL.GetTokenKind: integer;
begin
  Result := Ord(fTokenId);
end;

function TSynLifeScript1HL.GetTokenPos: Integer;
begin
  Result := fTokenPos;
end;

function TSynLifeScript1HL.GetIdentChars: TSynIdentChars;
begin
  Result := ['_', 'a'..'z', 'A'..'Z'];
end;

function TSynLifeScript1HL.GetSampleSource: string;
begin
  Result := '';
end;

function TSynLifeScript1HL.IsFilterStored: Boolean;
begin
  Result := fDefaultFilter <> SYNS_FilterLifeScript;
end;

{$IFNDEF SYN_CPPB_1} class {$ENDIF}
function TSynLifeScript1HL.GetLanguageName: string;
begin
  Result := SYNS_LangLifeScript;
end;

procedure TSynLifeScript1HL.ResetRange;
begin
  fRange := rsUnknown;
end;

procedure TSynLifeScript1HL.SetRange(Value: Pointer);
begin
  fRange := TRangeState(Value);
end;

function TSynLifeScript1HL.GetRange: Pointer;
begin
  Result := Pointer(fRange);
end;

initialization
  MakeIdentTable;
{$IFNDEF SYN_CPPB_1}
  RegisterPlaceableHighlighter(TSynLifeScript1HL);
{$ENDIF}
end.
