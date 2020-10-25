// #########################################################
// ############### Decompilation routines ##################
// #########################################################

unit Scene1LibDecomp;

//{$define DECOMP_DEBUG}

interface

uses SceneLibConst, SceneLib1Tab, SysUtils, Utils, Dialogs, Math;

function Track1Decompile(BinaryScript: String; var Trans: TTransTable; out HashTable: TWordDynAr): String;
function Track1TransCmdToStrings(Cmd: TTransCommand): TStrDynAr;
function LifeDecompToTransTable1(BinaryScript: String; out CompList: TStrDynAr): TTransTable;
procedure LifeDecompResolveOffsets1(var Trans: array of TTransTable;
  TrackHashes: array of TWordDynAr; CompLists: array of TStrDynAr);
function Life1DecompTransToString(Trans: TTransTable; Actor: Integer): String;
function Life1TransCmdToStrings(Cmd: TTransCommand; Flags: TDecTxtFlags; Actor: Integer = -1): TStrDynAr;

implementation

uses SceneLib;

//Initially we read everything to Integer values, that must be subsequently normalized
//  according to their expected range and size
procedure FixSignedValue(var Val: Integer; Size: Integer; Range: TRange);
begin
 if Range.Min < 0 then begin //fix only params that can be less than zero
        if Size = 1 then Val:= ShortInt(Val) //signed byte
   else if Size = 2 then Val:= SmallInt(Val); //signed word
 end;
end;

function Track1Decompile(BinaryScript: String; var Trans: TTransTable; out HashTable: TWordDynAr): String;
var a, b, Offset, tth, ScriptLen: Integer;
    Param1, Indent: Integer;
    Opcode: Byte;
    Finish: Boolean;
    Line: TStrDynAr;
begin
  Finish:= False;
  ScriptLen:= Length(BinaryScript);
  Offset:= 1; // string starts at position 1
  tth:= -1; //additional variable for TrackTrans high, it should be faster than calling High() each time
  SetLength(Trans, 0);
  SetLength(HashTable, 0);
  Result:= '';

  //Reading script into the transitional variable
  repeat
    Opcode:= Byte(BinaryScript[Offset]);

    Inc(Offset); //Offset:= Offset + 1;

    if OpCode <= 34 then begin

      if (OpCode = ts1END)
      and (not ScrSet.Decomp.AllowMiddleEnd or (Offset > ScriptLen))
      then
        Finish:= True;

      Inc(tth);
      SetLength(Trans, tth + 1);

      Trans[tth].Code:= OpCode;
      Trans[tth].Offset:= Offset - 2;
      Trans[tth].Flags:= Track1Props[OpCode].Flags;
      Trans[tth].ParamCount:= Track1Props[OpCode].ParCount;

      if Trans[tth].ParamCount = -1 then begin //parameter is text
        Trans[tth].ParamStr:= ExtractCStrFromStr(BinaryScript, Offset);
        Inc(Offset, Length(Trans[tth].ParamStr) + 1); //+1 for the #0 at the end
      end
      else begin
        for a:= 0 to Trans[tth].ParamCount - 1 do begin //params are numbers
          Trans[tth].Params[a]:=
            Integer(ReadValFromBinStr(BinaryScript, Offset, Track1Props[OpCode].ParSize[a]));
          FixSignedValue(Trans[tth].Params[a], Track1Props[OpCode].ParSize[a],
                         Track1Props[OpCode].ParRng[a]^);
          Inc(Offset, Track1Props[OpCode].ParSize[a]);
        end;
      end;

      if OpCode = 9 then begin //LABEL - remember all IDs of the LABELs
        If High(HashTable) < Offset - 3 then SetLength(HashTable, Offset - 2);
        HashTable[Offset - 3]:= Trans[tth].Params[0] + 1; //all +1 because 0 is reserved for empty cell
      end;

    end
    else begin
      MessageDlg('Track Script error: Unknown opcode!', Dialogs.mtError, [mbOK], 0);
      Finish:= True; // + return error in future
    end;

  until Finish;

  //Resolving offsets (Track Script internal only)
  for a:= 0 to tth do begin
    if Trans[a].Code = ts1GOTO then begin //GOTO

      Param1:= Trans[a].Params[0];

      if Param1 = -1 then //-1, special case
        Trans[a].Params[0]:= -1 //before it was 65535 -> -1, now something has changed, and it seems not necessary any more
      else begin

        if (Param1 <= High(HashTable)) and (HashTable[Param1] > 0) then
          Trans[a].Params[0]:= HashTable[Param1] - 1
        else
          Trans[a].Error:= derrTrackNoLabel; //there is no LABEL at the given offset

      end;

    end;
  end;

  //Converting to textual form
  for a:= 0 to tth do begin

    Line:= Track1TransCmdToStrings(Trans[a]);

    if ScrSet.Decomp.IndentTrack then begin
      if Trans[a].Code in [ts1LABEL, ts1END{, tsSTOP}] then
        Indent:= 0
      else
        Indent:= 2;
    end;

    {$ifdef DECOMP_DEBUG}
      Result:= Result + Line[0] + StringOfChar(' ', 5 - Length(Line[0]));
      Result:= Result + StringOfChar(' ', Indent);
      for b:= 1 to High(Line) do
        Result:= Result + Line[b] + ' ';
    {$else}
      Result:= Result + StringOfChar(' ', Indent);
      for b:= 0 to High(Line) do
        Result:= Result + Line[b] + ' ';
    {$endif}

    Result:= Result + CR;
        
    (*{$ifdef DECOMP_DEBUG}
      Result:= Result + ' ' + IntToStr(Trans[a].Offset) + ':' + TAB;
    {$endif}

    If ScrSet.Decomp.IndentTrack then
      If not (Trans[a].Code in [ts1LABEL, ts1END{, tsSTOP}]) then
        Result:= Result + '  ';

    If Trans[a].Error <> derrNoError then
      Result:= Result + '[error ' + IntToStr(Ord(Trans[a].Error)) + ']';

    If ScrSet.Decomp.UpperCase then
      Result:= Result + Track1List[Trans[a].Code]
    else
      Result:= Result + LowerCase(Track1List[Trans[a].Code]);

    If Trans[a].ParamCount = -1 then
      Result:= Result + ' ' + Trans[a].ParamStr
    else begin
      If (Trans[a].ParamCount > 0) and not (cfPar1Dummy in Trans[a].Flags) then
        Result:= Result + ' ' + IntToStr(Trans[a].Params[0]);
      //for b:= 0 to TrackTrans[a].ParamCount - 1 do //Par2 is always dummy in Track Scripts
      //  Result:= Result + ' ' + IntToStr(TrackTrans[a].Params[b]);
    end;

    Result:= Result + CR; *)
  end;
end;

function Track1TransCmdToStrings(Cmd: TTransCommand): TStrDynAr;
var rh: Integer;
begin
  SetLength(Result, 0);
  rh:= -1;

  {$ifdef DECOMP_DEBUG}
    Inc(rh);
    SetLength(Result, rh + 1);
    Result[rh]:= IntToStr(Cmd.Offset) + ':';
  {$endif}

  Inc(rh);
  SetLength(Result, rh + 1);
  Result[rh]:= FixCase(Track1List[Cmd.Code]);

  if Cmd.ParamCount = -1 then begin
    Inc(rh);
    SetLength(Result, rh + 1);
    Result[rh]:= Cmd.ParamStr;
  end else begin
    if (Cmd.ParamCount > 0) and not (cfPar1Dummy in Cmd.Flags) then begin
      Inc(rh);
      SetLength(Result, rh + 1);
      Result[rh]:= IntToStr(Cmd.Params[0]);
    //for b:= 0 to TrackTrans[a].ParamCount - 1 do //Par2 is always dummy in Track Scripts
    //  Result:= Result + ' ' + IntToStr(TrackTrans[a].Params[b]);
    end;
  end;

  if Cmd.Error <> derrNoError then begin
    Inc(rh);
    SetLength(Result, rh + 1);
    Result[rh]:= '[error ' + IntToStr(Ord(Cmd.Error)) + ']'
               + ' //' + DecompErrorString[Ord(Cmd.Error)];
  end;
end;

Procedure AddTransCommand(var Trans: TTransTable; var lth: Integer; Code: Byte;
  Offset: Integer; cType: TCommandType; ParamCount, Par1: Integer; ParamStr: String);
begin
  Inc(lth);
  SetLength(Trans, lth + 1);
  Trans[lth].Code:= Code;
  Trans[lth].Offset:= Offset;
  Trans[lth].cType:= cType;
  Trans[lth].ParamCount:= ParamCount;
  Trans[lth].Params[0]:= Par1;
  Trans[lth].ParamStr:= ParamStr;
  Trans[lth].Flags:= [];
end;

Procedure InsertTransCommand(var Trans: TTransTable; id: Integer; Code: Byte;
  Offset: Integer; cType: TCommandType; ParamCount, Par1: Integer; ParamStr: String);
var a: Integer;
begin
  SetLength(Trans, Length(Trans) + 1);
  for a:= High(Trans) downto id + 1 do
    Trans[a]:= Trans[a - 1];
  Trans[id].Code:= Code;
  Trans[id].Offset:= Offset;
  Trans[id].cType:= cType;
  Trans[id].ParamCount:= ParamCount;
  Trans[id].Params[0]:= Par1;
  Trans[id].ParamStr:= ParamStr;
  Trans[id].Flags:= [];
end;

function IdToStrOrSelf(id, Actor: Integer): String;
begin
 if id = Actor then Result:= 'SELF'
 else Result:= IntToStr(id);
end;

Procedure AddCompToList(var CompList: TStrDynAr; Offset: Integer; Name: String);
begin
 If High(CompList) < Offset then SetLength(CompList, Offset + 1);
 CompList[Offset]:= Name;
end;

Function LifeDecompToTransTable1(BinaryScript: String; out CompList: TStrDynAr): TTransTable;  //Modified by Zink
var a, Offset, lth, Comportment, osh, LastCommand, ScriptLen: Integer;
    OpCode, VarCode: Byte;
    FirstComp: String;
    Finish: Boolean;
    Previous: TCommandType;
    OffsetStack: array of Word;
begin
  Finish:= False;
  ScriptLen:= Length(BinaryScript);
  Offset:= 1; // string starts at position 1
  Previous:= ctCommand;
  Comportment:= 0;
  osh:= -1;
  SetLength(OffsetStack, 0);
  SetLength(CompList, 0);
  If ScrSet.Decomp.FirstCompMain then FirstComp:= 'main' else FirstComp:= '0';

  lth:= -1;
  SetLength(Result, 0);
  LastCommand:= -1;

  if ScriptLen > 1 then begin

    AddTransCommand(Result, lth, 32, 0, ctVirtual, -1, 0, FirstComp); //first COMPORTMENT
    AddCompToList(CompList, 0, FirstComp); //save Life Trans Table index of the COMPORTMENT

    //Reading script into the transitional variable
    repeat
      while (osh > -1) and (Offset - 1 >= OffsetStack[osh]) do begin  //add ENDIFs if necessary
        AddTransCommand(Result, lth, 16, Offset - 1, ctVirtual, 0, 0, ''); //ENDIF
        Dec(osh);
      end;

      OpCode:= Byte(BinaryScript[Offset]);

      Inc(Offset);

      if (((Previous = ctCommand) or (Previous = ctOperator))
                                  and (OpCode <= 105)) //Commands
      or ((Previous = ctIf)       and (OpCode <=  29)) //Conditions
      or ((Previous = ctVariable) and (OpCode <=   5)) //Operators
      then begin

        if (Previous in [ctCommand, ctOperator]) and (OpCode = ls1END)
        and (not ScrSet.Decomp.AllowMiddleEnd or (Offset > ScriptLen))
        then
          Finish:= True; 

        Inc(lth);
        SetLength(Result, lth + 1);

        Result[lth].Code:= OpCode;
        Result[lth].Offset:= Offset - 2;

        case Previous of
          ctCommand,
          ctOperator: begin //after an operator there must be a Command or IF
            LastCommand:= OpCode;
            Result[lth].cType:= Life1Props[OpCode].cType;
            Result[lth].Flags:= Life1Props[OpCode].Flags;
            Result[lth].ParamCount:= Life1Props[OpCode].ParCount;
            if Result[lth].ParamCount = -1 then begin
              Result[lth].ParamStr:= ExtractCStrFromStr(BinaryScript, Offset);
              Inc(Offset, Length(Result[lth].ParamStr) + 1); //+1 for the #0 at the end
            end
            else begin
              for a:= 0 to Result[lth].ParamCount - 1 do begin
                Result[lth].Params[a]:=
                  Integer(ReadValFromBinStr(BinaryScript, Offset, Life1Props[OpCode].ParSize[a]));
                FixSignedValue(Result[lth].Params[a], Life1Props[OpCode].ParSize[a],
                               Life1Props[OpCode].ParRng[a]^);
                Inc(Offset, Life1Props[OpCode].ParSize[a]);
              end;
              if (OpCode in [ls1SET_DIRMODE, ls1SET_DIRMODE_OBJ])
              and (Result[lth].Params[Result[lth].ParamCount-1] = 2) then begin //Mode = 2
                Result[lth].Params[2]:= Byte(BinaryScript[Offset]);
                Inc(Offset);
              end
              else if (OpCode = ls1ELSE) and (osh > -1) then //ELSE
                OffsetStack[osh]:= Result[lth].Params[0]; //Correct ENDIF position
            end;
          end;

          ctIf: begin //previous was IF -> current must be a condition
            Result[lth].cType:= ctVariable;
            Result[lth].Flags:= [];
            Result[lth].ParamCount:= IfThen(Var1Props[OpCode].HasParam, 1, 0);
            if Var1Props[OpCode].HasParam then begin //max one param (and single-byte only)
              Result[lth].Params[0]:= Byte(BinaryScript[Offset]);
              Inc(Offset);
            end;
          end;

          //Operators are handled like regular commands. After the operator code there is
          // an operand value, which is handled like a parameter.
          //The address to go to if condition was false is after the operator param
          // and is handled as a second parameter of the operator.
          ctVariable: begin //previus was Variable -> current must be an Operator
            VarCode:= Result[lth-1].Code;
            Result[lth].cType:= ctOperator;
            Result[lth].Flags:= [];
            Result[lth].ParamCount:= 2; //param1: operand, param2: address for false
            Result[lth].Params[0]:=
              Integer(ReadValFromBinStr(BinaryScript, Offset,
                Var1Props[VarCode].RetSize));
            FixSignedValue(Result[lth].Params[0], Var1Props[VarCode].RetSize,
                           Var1Props[VarCode].RetRange^);
            Inc(Offset, Var1Props[VarCode].RetSize);
            Result[lth].Params[1]:= ReadWordFromBinStr(BinaryScript, Offset);
            Inc(Offset, 2);
            If LastCommand <> 55 then begin // <> OR_IF
              Inc(osh);
              If High(OffsetStack) < osh then SetLength(OffsetStack, osh + 1);
              OffsetStack[osh]:= Result[lth].Params[1]; //record the offset to put ENDIF to
            end;
          end;

        end;

        Previous:= Result[lth].cType;

        If (OpCode = ls1END_COMPORTMENT) and (Offset < ScriptLen)
        and (osh < 0) then begin //and we are not inside an IF-ELSE-ENDIF block
          Inc(Comportment); //next COMPORTMENT begins after END_COMPORTMENT
          AddTransCommand(Result, lth, 32, Offset-2, ctVirtual, -1, 0, IntToStr(Comportment));
          AddCompToList(CompList, Offset - 1, IntToStr(Comportment)); //save Life Trans Table index of the COMPORTMENT
        end;

      end
      else begin
        MessageDlg('Life Script error: Unknown opcode!', Dialogs.mtError, [mbOK], 0);
        Finish:= True; // + return error in future
      end;

    until Finish;

  end;

  If (lth < 0) or (Result[lth].Code <> 0) then
    AddTransCommand(Result, lth, 0, 0, ctCommand, 0, 0, '');
end;

Procedure LifeDecompResolveOffsets1(var Trans: array of TTransTable;
  TrackHashes: array of TWordDynAr; CompLists: array of TStrDynAr);
var a, b, c, d, e, AComp: Integer;
    temp: String;
begin
  //First insert additional COMPORTMENTs (one of the original code weirdnesses)
  for a:= 0 to High(Trans) do begin //for all Actors
    AComp:= 1;
    for b:= High(Trans[a]) downto 0 do begin //for all commands in the Actor's Script
      If Trans[a,b].cType = ctCommand then begin //exclude conditions and operators
        case Trans[a,b].Code of
          ls1SET_COMPORTMENT: begin  //replace (virtual) COMPORTMENT offsets with their names
            c:= Trans[a,b].Params[0];
            If (c <> -1) //except special case
            and ((c > High(CompLists[a])) or (CompLists[a,c] = '')) then
              for e:= 0 to High(Trans[a]) do
                If Trans[a,e].Offset = c then begin
                  temp:= 'inserted_' + IntToStr(AComp);
                  InsertTransCommand(Trans[a], e, ls1COMPORTMENT, c, ctVirtual,
                    -1, 0, temp);
                  AddCompToList(CompLists[a], c, temp);
                  Inc(AComp);
                  Break;
                end
                else if Trans[a,e].Offset > c then begin
                  Trans[a,b].Error:= derrNoComAddr;
                  Break;
                end;
          end;

          ls1SET_COMPORTMENT_OBJ: begin //as above, but for all Actors
            c:= Trans[a,b].Params[1];
            d:= Trans[a,b].Params[0];
            If d < Length(CompLists) then begin
              If (c <> -1) //except special case
              and ((c > High(CompLists[d])) or (CompLists[d,c] = '')) then
                for e:= 0 to High(Trans[d]) do
                  If Trans[d,e].Offset = c then begin
                    temp:= 'inserted_' + IntToStr(AComp);
                    InsertTransCommand(Trans[d], e, ls1COMPORTMENT, c, ctVirtual,
                      -1, 0, temp);
                    AddCompToList(CompLists[d], c, temp);
                    Inc(AComp);
                    Break;
                  end
                  else if Trans[d,e].Offset > c then begin
                    Trans[a,b].Error:= derrNoComAddr;
                    Break;
                  end;
            end
            else
              Trans[a,b].Error:= derrCompNoActor;
          end;
        end;
      end;
    end;
  end;

  //Then we can perform the resolving
  for a:= 0 to High(Trans) do begin //for all Actors
    for b:= 0 to High(Trans[a]) do begin //for all commands in the Actor's Script

      If Trans[a,b].cType = ctCommand then begin //exclude conditions and operators

        case Trans[a,b].Code of
          ls1SET_TRACK: begin  //replace LABEL offsets with their indexes
            c:= Trans[a,b].Params[0];
            if c <> -1 then begin //except special case
              If (c <= High(TrackHashes[a])) and (TrackHashes[a,c] > 0) then
                Trans[a,b].Params[0]:= TrackHashes[a,c] - 1
              else
                Trans[a,b].Error:= derrLifeNoTrack;
            end;
          end;

          ls1SET_TRACK_OBJ: begin  //as above, but for all Actors
            c:= Trans[a,b].Params[1];
            d:= Trans[a,b].Params[0];
            if d < Length(TrackHashes) then begin
              if c <> -1 then begin //except special case
                if (c <= High(TrackHashes[d])) and (TrackHashes[d,c] > 0) then
                  Trans[a,b].Params[1]:= TrackHashes[d,c] - 1
                else
                  Trans[a,b].Error:= derrLifeNoTrack;
              end;
            end
            else
              Trans[a,b].Error:= derrLifeNoActor;
          end;

          ls1SET_COMPORTMENT: begin  //replace (virtual) COMPORTMENT offsets with their names
            c:= Trans[a,b].Params[0];
            if c = -1 then begin //special case
              Trans[a,b].ParamStr:= 'break';
              Trans[a,b].ParamCount:= -1; //to display string param instead of int
            end else begin
              If (c <= High(CompLists[a])) and (CompLists[a,c] <> '') then begin
                Trans[a,b].ParamStr:= CompLists[a,c];
                Trans[a,b].ParamCount:= -1; //to display string param instead of int
              end
              else
                Trans[a,b].Error:= derrLifeNoComp;
            end;
          end;

          ls1SET_COMPORTMENT_OBJ: begin //as above, but for all Actors
            c:= Trans[a,b].Params[1];
            d:= Trans[a,b].Params[0];
            if d < Length(CompLists) then begin
              if c = -1 then begin //special case
                Trans[a,b].ParamStr:= 'break';
                Trans[a,b].ParamCount:= -2; //to display 2nd param as string instead of int
              end else begin
                If (c <= High(CompLists[d])) and (CompLists[d,c] <> '') then begin
                  Trans[a,b].ParamStr:= CompLists[d,c];
                  Trans[a,b].ParamCount:= -2; //to display 2nd param as string instead of int
                end
                else
                  Trans[a,b].Error:= derrLifeNoComp;
              end;
            end
            else
              Trans[a,b].Error:= derrCompNoActor;
          end;

        end;

      end;
    end;
  end;
end;

Function Life1DecompTransToString(Trans: TTransTable; Actor: Integer): String;
var a, b, Indent, IndentSingle{, DirMode, LastCond, LastCommand}: Integer;
    Line: TStrDynAr;
    Flags: TDecTxtFlags;
begin
  Result:= '';
  Indent:= 0;

  for a:= 0 to High(Trans) do begin
    Flags:= [];
    if (Trans[a].cType = ctOperator) and (a >= 2) then begin
      if Trans[a-1].Code = lsv1BEHAVIOUR then
        Flags:= [dtCmpBehav];
      if vfCmpActor in Trans[a-1].Flags then
        Flags:= Flags + [dtCmpActor];
      if Trans[a-2].Code in [ls1IF, ls1SNIF, ls1SWIF, ls1ONEIF, ls1NEVERIF, ls1NO_IF]
      then
        Flags:= Flags + [dtIfType];
    end;

    Line:= Life1TransCmdToStrings(Trans[a], Flags, Actor);

    //pre-command indentation set
    if Trans[a].cType in [ctCommand, ctVirtual, ctIf] then begin
      IndentSingle:= 0;
      if ScrSet.Decomp.IndentLife then begin
        case Trans[a].Code of
          ls1ENDIF:            Dec(Indent, 2);
          ls1COMPORTMENT:     Indent:= 0;
          ls1ELSE:             IndentSingle:= -2;
          ls1END_COMPORTMENT: Indent:= 0;
        end;
      end;
    end;

    {$ifdef DECOMP_DEBUG}
      if Trans[a].cType in [ctCommand, ctIf, ctVirtual] then begin
        Result:= Result + Line[0] + StringOfChar(' ', 6 - Length(Line[0]));
        Result:= Result + StringOfChar(' ', Indent + IndentSingle);
        for b:= 1 to High(Line) do
          Result:= Result + Line[b] + ' ';
      end else begin
        for b:= 0 to High(Line) do
          Result:= Result + Line[b] + ' ';
      end;
    {$else}
      if Trans[a].cType in [ctCommand, ctIf, ctVirtual] then
        Result:= Result + StringOfChar(' ', Indent + IndentSingle);
      for b:= 0 to High(Line) do
        Result:= Result + Line[b] + ' ';
    {$endif}

    case Trans[a].cType of //post-command indentation set (and other things)
      ctCommand, ctVirtual, ctIf: begin
        if ScrSet.Decomp.IndentLife then begin
          if Trans[a].Code in [ls1IF, ls1SWIF, ls1ONEIF, ls1NEVERIF, ls1SNIF, ls1NO_IF,
                               ls1COMPORTMENT]
          then
            Inc(Indent, 2);
        end;
        if Trans[a].cType <> ctIf then //ctCommand and ctDummy
          Result:= Result + CR;
      end;
      ctOperator:
        Result:= Result + CR;
    end;
  end;

  (*LastCond:= 0;
  LastCommand:= 0;
  for a:= 0 to High(Trans) do begin

    case Trans[a].cType of
      ctCommand, ctVirtual, ctIf:
      begin //IFs are displayed in the same way as Commmands (only without params)

        LastCommand:= Trans[a].Code;

        {$ifdef DECOMP_DEBUG}
          Result:= Result + IntToStr(Trans[a].Offset) + ':' + TAB;
        {$endif}  

        IndentSingle:= 0;
        If ScrSet.Decomp.IndentLife then begin
          If Trans[a].Code = ls1COMPORTMENT then Indent:= 0
          else if Trans[a].Code = ls1ELSE then IndentSingle:= -2
          else if (Trans[a].Code = ls1ENDIF)
               or ((Trans[a].Code = ls1END_COMPORTMENT)
                 and (Trans[a+1].Code in [ls1COMPORTMENT, ls1END])) then Dec(Indent,2);
        end;

        Result:= Result + StringOfChar(' ', Indent + IndentSingle);

        if Trans[a].Error <> derrNoError then
          Result:= Result + '[error ' + IntToStr(Ord(Trans[a].Error)) + ']';

        if ScrSet.Decomp.UpperCase then
          Result:= Result + Life1DecompList[Trans[a].Code]
        else
          Result:= Result + LowerCase(Life1DecompList[Trans[a].Code]);

        if cfBehav in Trans[a].Flags then begin //BEHAVIOUR (always has a param)
          if ScrSet.Decomp.UpperCase then
            Result:= Result + ' ' + Behaviour1List[Trans[a].Params[0]]
          else
            Result:= Result + ' ' + LowerCase(Behaviour1List[Trans[a].Params[0]]);
        end
        else if Trans[a].Code in [ls1SET_DIRMODE, ls1SET_DIRMODE_OBJ] then begin
          if Trans[a].Code = ls1SET_DIRMODE_OBJ then
            Result:= Result + ' ' + IdToStrOrSelf(Trans[a].Params[0], Actor); //OBJ ID
          DirMode:= Trans[a].Params[Trans[a].ParamCount-1];
          if ScrSet.Decomp.UpperCase then
            Result:= Result + ' ' + DirMode1List[DirMode]
          else
            Result:= Result + ' ' + LowerCase(DirMode1List[DirMode]);
          if DirMode = 2 then //FOLLOW
            Result:= Result + ' ' + IntToStr(Trans[a].Params[2]);
        end
        else begin
          if Trans[a].ParamCount = -1 then
            Result:= Result + ' ' + Trans[a].ParamStr
          else if Trans[a].ParamCount = -2 then //SET_COMP_OBJ only so far
            Result:= Result + ' ' + IdToStrOrSelf(Trans[a].Params[0], Actor) //first number
                            + ' ' + Trans[a].ParamStr            //and second text
          else begin
            if (Trans[a].Code = ls1ELSE) then begin
              {$ifdef DECOMP_DEBUG}
                Result:= Result + ' goto ' + IntToStr(Trans[a].Params[0]);
              {$endif}  
            end else
              for b:= 0 to Trans[a].ParamCount - 1 do begin
                if (b = 0) and (Trans[a].Code in ActorFirstCommands1) then
                  Result:= Result + ' ' + IdToStrOrSelf(Trans[a].Params[b], Actor)
                else
                  Result:= Result + ' ' + IntToStr(Trans[a].Params[b]);
              end;
          end;
        end;

        if ScrSet.Decomp.IndentLife then begin
          if (Trans[a].cType = ctIf)
          and (Trans[a].Code <> ls1OR_IF) then Inc(Indent,2);
          if Trans[a].Code = ls1COMPORTMENT then Inc(Indent, 2);
        end;

        if Trans[a].cType <> ctIf then begin //ctCommand and ctDummy
          if Trans[a].Error <> derrNoError then
            Result:= Result + ' //' + DecompErrorString[Ord(Trans[a].Error)];
          Result:= Result + CR; 
        end;
      end;

      ctVariable: begin
        LastCond:= Trans[a].Code;
        if ScrSet.Decomp.UpperCase then
          Result:= Result + ' ' + Var1List[Trans[a].Code]
        else
          Result:= Result + ' ' + LowerCase(Var1List[Trans[a].Code]);
        if Trans[a].ParamCount > 0 then begin  //max one param
          if Trans[a].Code in ActorParVariables1 then
            Result:= Result + ' ' + IdToStrOrSelf(Trans[a].Params[0], Actor)
          else
            Result:= Result + ' ' + IntToStr(Trans[a].Params[0]);
        end;
      end;

      ctOperator: begin
        Result:= Result + ' ' + OperatorList[Trans[a].Code] + ' ';
        If LastCond = lsv1BEHAVIOUR then begin
          If ScrSet.Decomp.UpperCase then
            Result:= Result + Behaviour1List[Trans[a].Params[0]]
          else
            Result:= Result + LowerCase(Behaviour1List[Trans[a].Params[0]]);
        end
        else begin
          if Trans[a-1].Code in ActorCompVariables1 then
            Result:= Result + IdToStrOrSelf(Trans[a].Params[0], Actor)
          else
            Result:= Result + IntToStr(Trans[a].Params[0]);
        end;
        {$ifdef DECOMP_DEBUG}
          if LastCommand = ls1OR_IF then Result:= Result + ' then'
          else Result:= Result + ' else';
          Result:= Result + ' goto ' + IntToStr(Trans[a].Params[1]);
        {$endif}
        Result:= Result + CR;
      end;
    end;

  end;*)
end;

function Life1TransCmdToStrings(Cmd: TTransCommand; Flags: TDecTxtFlags; Actor: Integer = -1): TStrDynAr;
var rh, b: Integer;
    Param0: Integer;
    DirMode: Byte;
begin
  SetLength(Result, 0);
  rh:= -1;

  case Cmd.cType of
    //ctError: -- error only

    ctCommand, ctVirtual, ctIf:
    begin //IFs are displayed in the same way as Commmands (only without params)
      {$ifdef DECOMP_DEBUG}
        Inc(rh);
        SetLength(Result, rh + 1);
        Result[rh]:= IntToStr(Cmd.Offset) + ':';
      {$endif}

      Inc(rh);
      SetLength(Result, rh + 1);
      if not CheckBadOpcode(Cmd, Result[rh]) then begin
        Result[rh]:= FixCase(Life1DecompList[Cmd.Code]);

        if Cmd.Code = ls1SET_BEHAVIOUR then begin //param from the behav list
          Inc(rh);
          SetLength(Result, rh + 1);
          Param0:= Cmd.Params[0];
          if Param0 <= lbh1MAX_OPCODE then
            Result[rh]:= FixCase(Behaviour1List[Param0])
          else
            Result[rh]:= '(Bad behaviour mode: ' + IntToStr(Param0) + ')';
        end
        else if Cmd.Code in [ls1SET_DIRMODE, ls1SET_DIRMODE_OBJ] then begin
          if Cmd.Code = ls1SET_DIRMODE_OBJ then begin
            Inc(rh);
            SetLength(Result, rh + 1);
            Result[rh]:= IdToStrOrSelf(Cmd.Params[0], Actor); //OBJ ID
          end;
          DirMode:= Byte(Cmd.Params[Cmd.ParamCount-1]);
          Inc(rh);
          SetLength(Result, rh + 1);
          if DirMode <= ldm1MAX_OPCODE then
            Result[rh]:= FixCase(DirMode1List[DirMode])
          else
            Result[rh]:= '(Bad dir mode: ' + IntToStr(DirMode) + ')';
          if DirMode = ldm1FOLLOW then begin //another patram
            Inc(rh);
            SetLength(Result, rh + 1);
            Result[rh]:= IntToStr(Cmd.Params[2]);
          end;
        end
        else begin //regular commands
          if Cmd.ParamCount = -1 then begin //string param
            Inc(rh);
            SetLength(Result, rh + 1);
            Result[rh]:= Cmd.ParamStr;
          end
          else if Cmd.ParamCount = -2 then begin //first number, second text, SET_COMP_OBJ only so far
            Inc(rh, 2);
            SetLength(Result, rh + 1);
            Result[rh-1]:= IdToStrOrSelf(Cmd.Params[0], Actor); //first number
            Result[rh]:=   Cmd.ParamStr;                        //and second text
          end else begin //number params
            if Cmd.Code = ls1ELSE then begin
              {$ifdef DECOMP_DEBUG}
                Inc(rh);
                SetLength(Result, rh + 1);
                Result[rh]:= '(goto ' + IntToStr(Cmd.Params[0]) + ')';
              {$endif}
            end else begin
              for b:= 0 to Cmd.ParamCount - 1 do begin
                Inc(rh);
                SetLength(Result, rh + 1);
                if (b = 0) and (cfP1Actor in Cmd.Flags) then
                  Result[rh]:= IdToStrOrSelf(Cmd.Params[b], Actor)
                else
                  Result[rh]:= IntToStr(Cmd.Params[b]);
              end;
            end;
          end;
        end;
      end;  
    end;

    ctVariable, ctSwVar: begin
      Inc(rh);
      SetLength(Result, rh + 1);
      if not CheckBadOpcode(Cmd, Result[rh]) then begin
        Result[rh]:= FixCase(Var1List[Cmd.Code]);
        if Cmd.ParamCount > 0 then begin  //max one param
          Inc(rh);
          SetLength(Result, rh + 1);
          if vfParActor in Cmd.Flags then
            Result[rh]:= IdToStrOrSelf(Cmd.Params[0], Actor)
          else
            Result[rh]:= IntToStr(Cmd.Params[0]);
        end;
      end;
    end;

    ctOperator: begin
      Inc(rh);
      SetLength(Result, rh + 1);
      if not CheckBadOpcode(Cmd, Result[rh]) then begin
        Result[rh]:= OperatorList[Cmd.Code];
        Inc(rh);  //operator always has at least one param (comparison value)
        SetLength(Result, rh + 1);
        if dtCmpBehav in Flags then begin
          if Cmd.Params[0] <= lbh1MAX_OPCODE then
            Result[rh]:= FixCase(Behaviour1List[Cmd.Params[0]])
          else
            Result[rh]:= '(Bad behaviour mode: ' + IntToStr(Cmd.Params[0]) + ')';
        end
        else begin
          if dtCmpActor in Flags then
            Result[rh]:= IdToStrOrSelf(Cmd.Params[0], Actor)
          else
            Result[rh]:= IntToStr(Cmd.Params[0]);
        end;
        {$ifdef DECOMP_DEBUG}
          Inc(rh);
          SetLength(Result, rh + 1);
          Result[rh]:= '(';
          if dtIfType in Flags then Result[rh]:= Result[rh] + 'else ';
          Result[rh]:= Result[rh] + 'goto ' + IntToStr(Cmd.Params[1]) + ')';
        {$endif}
      end;
    end;
  end;

  if Cmd.Error <> derrNoError then begin
    Inc(rh);
    SetLength(Result, rh + 1);
    Result[rh]:= '[error ' + IntToStr(Ord(Cmd.Error)) + ']'
               + ' //' + DecompErrorString[Ord(Cmd.Error)];
    if Cmd.Error = derrBadOpcode then
      Result[rh]:= Result[rh] + Format(' (code: 0x%.2X, expected: %s, offset: 0x%.4X)',
               [Cmd.Code, CmdTypeString[Cmd.cType], Cmd.Offset])
    else if Cmd.Error = derrCodeAfterEnd then begin
      Result[rh]:= Result[rh] + ' (';
      for b:= 1 to Length(Cmd.ParamStr) do
        Result[rh]:= Result[rh] + Format('%.2X ', [Byte(Cmd.ParamStr[b])]);
      Delete(Result[rh], Length(Result[rh]), 1);
      Result[rh]:= Result[rh] + ')';
    end;
  end;
end;

end.
