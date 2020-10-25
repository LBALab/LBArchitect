// #########################################################
// ############### Decompilation routines ##################
// #########################################################

unit SceneLibDecomp;

//{$define DECOMP_DEBUG}

interface

uses SceneLibConst, SceneLib1Tab, SceneLib2Tab, SysUtils, Utils, Dialogs, Math;

procedure SetupDecompiler(Lba: Byte);
procedure ReleaseDecompiler(); //free data arrays

function TrackDecompile(BinaryScript: String; var Trans: TTransTable; out HashTable: TWordDynAr): String;
function TrackTransCmdToStrings(Cmd: TTransCommand): TStrDynAr;
function LifeDecompToTransTable(BinaryScript: String; out CompList: TStrDynAr): TTransTable;
procedure LifeDecompResolveOffsets(var Trans: array of TTransTable;
  TrackHashes: array of TWordDynAr; CompLists: array of TStrDynAr);
function LifeDecompTransToString(Trans: TTransTable; Actor: Integer): String;
function LifeTransCmdToStrings(Cmd: TTransCommand; Flags: TDecTxtFlags; Actor: Integer = -1): TStrDynAr;

implementation

uses SceneLib;

var
  tmEND, tmGOTO: Byte;
  tmMAX_OPCODE: Byte;
  lmEND, lmSET_COMP, lmSET_COMP_OBJ, lmCOMP, lmEND_COMP,
  lmSET_TRACK, lmSET_TRACK_OBJ, lmSET_BEHAV,
  lmOR_IF, lmENDIF, lmELSE, lmSWITCH, lmEND_SWITCH, lmBREAK,
  lmSET_DIRM, lmSET_DIRM_OBJ: Byte;
  lmMAX_OPCODE: Byte;
  lvBEHAV: Byte;
  lvMAX_OPCODE: Byte;
  ldMAX_OPCODE: Byte;
  lbMAX_OPCODE: Byte;

  TrackList: TStrDynAr;         //string names
  TrackProps: TCommandProps;    //command properties
  LifeList: TStrDynAr;          //decomp string names
  LifeProps: TCommandProps;     //command properties
  BehavList: TStrDynAr;         //string names
  VarList: TStrDynAr;           //decomp string names
  VarProps: TVariableProps;     //command properties
  DirModeList: TStrDynAr;
  TrackIndent0: set of Byte;    //Track macros to be not indented
  DirmReqObj: set of Byte;      //dirmodes require an object ID after the mode
  CaseMacros: set of Byte;      //Life CASE and OR_CASE macros
  OrAndIf: set of Byte;         //OR_IF + AND_IF
  IfMacros: set of Byte;        //IFs without OR_IF
  IndentPost: set of Byte;      //Life macros that make the next command indented
  {$ifdef DECOMP_DEBUG}
    lmCASE: Byte;
    DbgIfMacros: set of Byte;   //Macros for additional debug output (goto addresses, etc.)
  {$endif}


procedure SetupDecompiler(Lba: Byte);
var a: Integer;
begin
  if Lba = 1 then begin
    tmEND:=           tm1END;
    tmGOTO:=          tm1GOTO;
    tmMAX_OPCODE:=    tm1MAX_OPCODE;
    lmEND:=           lm1END;
    lmOR_IF:=         lm1OR_IF;
    lmENDIF:=         lm1ENDIF;
    lmSET_COMP:=      lm1SET_COMPORTMENT;
    lmSET_COMP_OBJ:=  lm1SET_COMPORTMENT_OBJ;
    lmCOMP:=          lm1COMPORTMENT;
    lmEND_COMP:=      lm1END_COMPORTMENT;
    lmSET_BEHAV:=     lm1SET_BEHAVIOUR;
    lmSET_TRACK:=     lm1SET_TRACK;
    lmSET_TRACK_OBJ:= lm1SET_TRACK_OBJ;
    lmELSE:=          lm1ELSE;
    lmSWITCH:=        255;
    lmEND_SWITCH:=    255;
    lmBREAK:=         255;
    lmSET_DIRM:=      lm1SET_DIRMODE;
    lmSET_DIRM_OBJ:=  lm1SET_DIRMODE_OBJ;
    lmMAX_OPCODE:=    lm1MAX_OPCODE;
    lvBEHAV:=        lv1BEHAVIOUR;
    lvMAX_OPCODE:=   lv1MAX_OPCODE;
    ldMAX_OPCODE:=   ld1MAX_OPCODE;
    lbMAX_OPCODE:=   lb1MAX_OPCODE;

    TrackIndent0:=    [tm1LABEL, tm1END{, ts1STOP}];
    DirmReqObj:=      [ld1FOLLOW, ld1FOLLOW2];
    CaseMacros:=      [];
    OrAndIf:=         [lm1OR_IF];
    IfMacros:=        [lm1IF, lm1SNIF, lm1SWIF, lm1ONEIF, lm1NEVERIF, lm1NO_IF];
    IndentPost:=      [lm1IF, lm1SWIF, lm1ONEIF, lm1NEVERIF, lm1SNIF, lm1NO_IF, lm1COMPORTMENT];
    {$ifdef DECOMP_DEBUG}
      lmCASE:=        255;
      DbgIfMacros:=   [lm1IF, lm1SNIF, lm1SWIF, lm1ONEIF, lm1NEVERIF, lm1NO_IF];
    {$endif}

    SetLength(TrackList, Length(Track1DecompList));
    Move(Track1DecompList[0], TrackList[0], SizeOf(Track1DecompList));
    SetLength(TrackProps, Length(Track1Props));
    Move(Track1Props[0], TrackProps[0], SizeOf(Track1Props));

    SetLength(LifeList, Length(Life1DecompList));
    Move(Life1DecompList[0], LifeList[0], SizeOf(Life1DecompList));
    SetLength(LifeProps, Length(Life1Props));
    Move(Life1Props[0], LifeProps[0], SizeOf(Life1Props));

    SetLength(BehavList, Length(Behav1DecompList));
    Move(Behav1DecompList[0], BehavList[0], SizeOf(Behav1DecompList));
    SetLength(VarList, Length(Var1DecompList));
    Move(Var1DecompList[0], VarList[0], SizeOf(Var1DecompList));
    SetLength(VarProps, Length(Var1Props));
    Move(Var1Props[0], VarProps[0], SizeOf(Var1Props));
    SetLength(DirModeList, Length(DirMode1DecompList));
    Move(DirMode1DecompList[0], DirModeList[0], SizeOf(DirMode1DecompList));

    if not ScrSet.Decomp.CompoOrg then begin
      for a:= 0 to High(Life1ModsComp) do
        LifeList[Life1ModsComp[a].id]:= Life1ModsComp[a].name;
      for a:= 0 to High(Var1ModsComp) do
        VarList[Var1ModsComp[a].id]:= Var1ModsComp[a].name;
    end;
    if not ScrSet.Decomp.Lba1MacroOrg then begin
      for a:= 0 to High(Track1ModsEng) do
        TrackList[Track1ModsEng[a].id]:= Track1ModsEng[a].name;
      for a:= 0 to High(Life1ModsEng) do
        LifeList[Life1ModsEng[a].id]:= Life1ModsEng[a].name;
      for a:= 0 to High(Var1ModsEng) do
        VarList[Var1ModsEng[a].id]:= Var1ModsEng[a].name;
    end;

  end else begin //LBA2
    tmEND:=           tm2END;
    tmGOTO:=          tm2GOTO;
    tmMAX_OPCODE:=    tm2MAX_OPCODE;
    lmEND:=           lm2END;
    lmOR_IF:=         lm2OR_IF;
    lmENDIF:=         lm2ENDIF;
    lmSET_COMP:=      lm2SET_COMPORTMENT;
    lmSET_COMP_OBJ:=  lm2SET_COMPORTMENT_OBJ;
    lmCOMP:=          lm2COMPORTMENT;
    lmEND_COMP:=      lm2END_COMPORTMENT;
    lmSET_BEHAV:=     lm2SET_BEHAVIOUR;
    lmSET_TRACK:=     lm2SET_TRACK;
    lmSET_TRACK_OBJ:= lm2SET_TRACK_OBJ;
    lmELSE:=          lm2ELSE;
    lmSWITCH:=        lm2SWITCH;
    lmEND_SWITCH:=    lm2END_SWITCH;
    lmBREAK:=         lm2BREAK;
    lmSET_DIRM:=      lm2SET_DIRMODE;
    lmSET_DIRM_OBJ:=  lm2SET_DIRMODE_OBJ;
    lmMAX_OPCODE:=    lm2MAX_OPCODE;
    lvBEHAV:=         lv2BEHAVIOUR;
    lvMAX_OPCODE:=    lv2MAX_OPCODE;
    ldMAX_OPCODE:=    ld2MAX_OPCODE;
    lbMAX_OPCODE:=    lb2MAX_OPCODE;

    TrackIndent0:= [tm2LABEL, tm2END, tm2REPLACE{, ts2STOP}];
    DirmReqObj:= [ld2FOLLOW, ld2FOLLOW2, ld2SAME_XZ, ld2DIRMODE9, ld2DIRMODE10, ld2DIRMODE11];
    CaseMacros:= [lm2CASE, lm2OR_CASE];
    OrAndIf:= [lm2OR_IF, lm2AND_IF];
    IfMacros:= [lm2IF, lm2SWIF, lm2ONEIF, lm2NEVERIF, lm2SNIF];
    IndentPost:= [lm2IF, lm2SWIF, lm2ONEIF, lm2NEVERIF, lm2SNIF,
                  lm2COMPORTMENT, lm2SWITCH, lm2CASE, lm2DEFAULT];
    {$ifdef DECOMP_DEBUG}
      lmCASE:=        lm2CASE;
      DbgIfMacros:= [lm2IF, lm2SNIF, lm2SWIF, lm2ONEIF, lm2NEVERIF, lm2AND_IF];
    {$endif}

    SetLength(TrackList, Length(Track2DecompList));
    Move(Track2DecompList[0], TrackList[0], SizeOf(Track2DecompList));
    SetLength(TrackProps, Length(Track2Props));
    Move(Track2Props[0], TrackProps[0], SizeOf(Track2Props));

    SetLength(LifeList, Length(Life2DecompList));
    Move(Life2DecompList[0], LifeList[0], SizeOf(Life2DecompList));
    SetLength(LifeProps, Length(Life2Props));
    Move(Life2Props[0], LifeProps[0], SizeOf(Life2Props));

    SetLength(BehavList, Length(Behav2DecompList));
    Move(Behav2DecompList[0], BehavList[0], SizeOf(Behav2DecompList));
    SetLength(VarList, Length(Var2DecompList));
    Move(Var2DecompList[0], VarList[0], SizeOf(Var2DecompList));
    SetLength(VarProps, Length(Var2Props));
    Move(Var2Props[0], VarProps[0], SizeOf(Var2Props));
    SetLength(DirModeList, Length(Dirm2DecompList));
    Move(Dirm2DecompList[0], DirModeList[0], SizeOf(Dirm2DecompList));

    if not ScrSet.Decomp.CompoOrg then begin
      for a:= 0 to High(Life2ModsComp) do
        LifeList[Life2ModsComp[a].id]:= Life2ModsComp[a].name;
      for a:= 0 to High(Var2ModsComp) do
        VarList[Var2ModsComp[a].id]:= Var2ModsComp[a].name;
    end;
    if not ScrSet.Decomp.Lba2MacroOrg then begin
      for a:= 0 to High(Track2ModsEng) do
        TrackList[Track2ModsEng[a].id]:= Track2ModsEng[a].name;
      for a:= 0 to High(Life2ModsEng) do
        LifeList[Life2ModsEng[a].id]:= Life2ModsEng[a].name;
      for a:= 0 to High(Var2ModsEng) do
        VarList[Var2ModsEng[a].id]:= Var2ModsEng[a].name;
    end;
  end;
end;

procedure ReleaseDecompiler();
begin
  SetLength(TrackList, 0);
  SetLength(TrackProps, 0);
  SetLength(LifeList, 0);
  SetLength(LifeProps, 0);
  SetLength(BehavList, 0);
  SetLength(VarList, 0);
  SetLength(VarProps, 0);
  SetLength(DirModeList, 0);
end;

//Initially we read everything to Integer values, that must be subsequently normalized
//  according to their expected range and size
procedure FixSignedValue(var Val: Integer; Size: Integer; Range: TRange);
begin
 if Range.Min < 0 then begin //fix only params that can be less than zero
   if (Size = 1) and ValueInRange(ShortInt(Val), Range) then
     Val:= ShortInt(Val) //signed byte
   else if (Size = 2) and ValueInRange(SmallInt(Val), Range) then
     Val:= SmallInt(Val); //signed word
 end;
end;

function TrackDecompile(BinaryScript: String; var Trans: TTransTable; out HashTable: TWordDynAr): String;
var a, b, Offset, tth, ScriptLen: Integer;
    Param1, Indent: Integer;
    Opcode: Byte;
    Finish: Boolean;
    Line: TStrDynAr;
begin
  Finish:= False;
  Offset:= 1; // string starts at position 1
  tth:= -1; //additional variable for TrackTrans high, it should be faster than calling High() each time
  SetLength(Trans, 0);
  SetLength(HashTable, 0);
  ScriptLen:= Length(BinaryScript);
  Result:= '';

  if ScriptLen > 0 then begin

    //Reading script into the transitional variable
    repeat
      Opcode:= Byte(BinaryScript[Offset]);

      Inc(Offset);

      if OpCode <= tmMAX_OPCODE then begin

        if OpCode = tmEND then
          Finish:= True;

        Inc(tth);
        SetLength(Trans, tth + 1);

        Trans[tth].cType:= ctCommand;
        Trans[tth].Code:= OpCode;
        Trans[tth].Offset:= Offset - 2;
        Trans[tth].Flags:= TrackProps[OpCode].Flags;
        Trans[tth].ParCount:= TrackProps[OpCode].ParCount;

        if Trans[tth].ParCount = -1 then begin //parameter is text
          Trans[tth].ParamStr:= ExtractCStrFromStr(BinaryScript, Offset);
          Inc(Offset, Length(Trans[tth].ParamStr) + 1); //+1 for the #0 at the end
        end
        else begin
          for a:= 0 to Trans[tth].ParCount - 1 do begin //params are numbers
            Trans[tth].Params[a]:=
              Integer(ReadValFromBinStr(BinaryScript, Offset, TrackProps[OpCode].ParSize[a]));
            FixSignedValue(Trans[tth].Params[a], TrackProps[OpCode].ParSize[a],
                           TrackProps[OpCode].ParRng[a]^);
            Inc(Offset, TrackProps[OpCode].ParSize[a]);
          end;
        end;

        if OpCode = 9 then begin //LABEL - remember all IDs of the LABELs
          if High(HashTable) < Offset - 3 then SetLength(HashTable, Offset - 2);
          HashTable[Offset - 3]:= Trans[tth].Params[0] + 1; //all +1 because 0 is reserved for empty cell
        end;

      end
      else begin
        //MessageDlg('Track Script error: Unknown opcode!', Dialogs.mtError, [mbOK], 0);
        Inc(tth);
        SetLength(Trans, tth + 1);
        Trans[tth].Code:= OpCode;
        Trans[tth].Offset:= Offset - 2;
        Trans[tth].Error:= derrBadOpcode;
        Finish:= True; // + return error in future
      end;

      if (Offset > ScriptLen) and (not Finish) then begin
        Inc(tth);
        SetLength(Trans, tth + 1);
        Trans[tth].cType:= ctError;
        Trans[tth].Error:= derrNoEND;
        Finish:= True;
      end;

    until Finish;

    if ScriptLen >= Offset then begin
      Inc(tth);
      SetLength(Trans, tth + 1);
      Trans[tth].cType:= ctError;
      Trans[tth].Error:= derrCodeAfterEnd;
      Trans[tth].ParamStr:= Copy(BinaryScript, Offset, 10);
    end;

    //Resolving offsets (Track Script internal only)
    for a:= 0 to tth do begin
      if Trans[a].Code = tmGOTO then begin //GOTO

        Param1:= Trans[a].Params[0];

        if Param1 = -1 then //-1, special case (65535, previously not sign-adjusted)
          Trans[a].Params[0]:= -1
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

      Line:= TrackTransCmdToStrings(Trans[a]);

      if ScrSet.Decomp.IndentTrack then begin
        if Trans[a].Code in TrackIndent0 then
          Indent:= 0
        else
          Indent:= 2;
      end else
        Indent:= 0;

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

      if ScrSet.Decomp.IndentTrack then
        if not (Trans[a].Code in [ts2LABEL, ts2END{, ts2STOP}]) then
          Result:= Result + '  ';

      if Trans[a].Error <> derrNoError then
        Result:= Result + '[error ' + IntToStr(Ord(Trans[a].Error)) + ']';

      if Trans[a].Error in [derrBadOpcode, derrCodeAfterEnd] then begin
        Result:= Result + ' //' + DecompErrorString[Ord(Trans[a].Error)];
        if Trans[a].Error = derrBadOpcode then
          Result:= Result + Format(' (code: 0x%.2X, offset: 0x%.4X)', [Trans[a].Code, Trans[a].Offset]);
      end
      else begin
        if ScrSet.Decomp.UpperCase then
          Result:= Result + Track2List[Trans[a].Code]
        else
          Result:= Result + LowerCase(Track2List[Trans[a].Code]);

        if Trans[a].ParamCount = -1 then
          Result:= Result + ' ' + Trans[a].ParamStr
        else begin
          if (Trans[a].ParamCount > 0) and not (cfPar1Dummy in Trans[a].Flags) then
            Result:= Result + ' ' + IntToStr(Trans[a].Params[0]);
          //for b:= 0 to TrackTrans[a].ParamCount - 1 do //Par2 is always dummy in Track Scripts
          //  Result:= Result + ' ' + IntToStr(TrackTrans[a].Params[b]);
        end;
        if Trans[a].Error <> derrNoError then
          Result:= Result + ' //' + DecompErrorString[Ord(Trans[a].Error)];
      end;

      Result:= Result + CR;*)
    end;
  end;  
end;

function TrackTransCmdToStrings(Cmd: TTransCommand): TStrDynAr;
var rh, b: Integer;
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
  if not CheckBadOpcode(Cmd, Result[rh]) then begin
    Result[rh]:= FixCase(TrackList[Cmd.Code]);

    if Cmd.cType <> ctError then begin
      if Cmd.ParCount = -1 then begin
        Inc(rh);
        SetLength(Result, rh + 1);
        Result[rh]:= Cmd.ParamStr;
      end else begin
        if (Cmd.ParCount > 0) and not (cfPar1Dummy in Cmd.Flags) then begin
          Inc(rh);
          SetLength(Result, rh + 1);
          Result[rh]:= IntToStr(Cmd.Params[0]);
        //for b:= 0 to TrackTrans[a].ParamCount - 1 do //Par2 is always dummy in Track Scripts
        //  Result:= Result + ' ' + IntToStr(TrackTrans[a].Params[b]);
        end;
      end;
    end;
  end;  

  if Cmd.Error <> derrNoError then begin
    Inc(rh);
    SetLength(Result, rh + 1);
    Result[rh]:= '[error ' + IntToStr(Ord(Cmd.Error)) + ']'
               + ' //' + DecompErrorString[Ord(Cmd.Error)];
    if Cmd.Error = derrBadOpcode then
      Result[rh]:= Result[rh] + Format(' (code: 0x%.2X, offset: 0x%.4X)', [Cmd.Code, Cmd.Offset])
    else if Cmd.Error = derrCodeAfterEnd then begin
      Result[rh]:= Result[rh] + ' (';
      for b:= 1 to Length(Cmd.ParamStr) do
        Result[rh]:= Result[rh] + Format('%.2X ', [Byte(Cmd.ParamStr[b])]);
      Delete(Result[rh], Length(Result[rh]), 1);
      Result[rh]:= Result[rh] + ')';
    end;
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
  Trans[lth].ParCount:= ParamCount;
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
  Trans[id].ParCount:= ParamCount;
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

function CheckOpCode(var cmd: TTransCommand; expType: TCommandType): Boolean;
begin
 Result:= ((expType in [ctCommand, ctIf])
                                     and (cmd.Code <= lmMAX_OPCODE)) //Commands
          or ((expType = ctVariable) and (cmd.Code <= lvMAX_OPCODE)) //Variables
          or ((expType = ctOperator) and (cmd.Code <= loMAX_OPCODE)); //Operators
 if not Result then begin
   cmd.Error:= derrBadOpcode;
   cmd.cType:= expType;
 end;
end;

Function LifeDecompToTransTable(BinaryScript: String; out CompList: TStrDynAr): TTransTable;  //Modified by Zink
var a, Offset, lth, Comportment, osh, {ssh, svh, {dsh,} LastCommand: Integer;
    OpCode, VarCode: Byte;
    ScriptLen: Integer;
    FirstComp: String;
    Finish{, firstBreak}: Boolean;
    Previous: TCommandType;
    OffsetStack: array of Word;
    //SwEndStack: array of Word; //separate address stack for SWITCH
    //SwDefStack: array of Word; //separate address stack for switch DEFAULT
    //We need the SWITCH stacks because nested SWITCH blocks may exist
    //SwEndAddr: Word; //, SwDefAddr: Word;
    //SwVarProp: array of TVariableProp; //SWTICHes can be nested!
    SwVarProp: TVariableProp; //SWITCHes can be nested, but always the last variable size is used
      //When a nested SWITCH uses a different variable size, than the main SWITCH, further
      //higher level switch CASEs use the nested one's variable sizes. This is an LBA2 weirdness.
begin
  Finish:= False;
  Offset:= 1; // string starts at position 1
  Previous:= ctCommand;
  Comportment:= 0;
  ScriptLen:= Length(BinaryScript);
  osh:= -1;
  SetLength(OffsetStack, 0);
  //svh:= -1;
  //SetLength(SwVarProp, 0);
  SwVarProp.RetSize:= 0;
  //ssh:= -1;
  //SetLength(SwEndStack, 0);
  {dsh:= -1;
  SetLength(SwDefStack, 0);}
  //SwDefAddr:= $FFFF;
  //SwEndAddr:= $FFFF;
  SetLength(CompList, 0);
  if ScrSet.Decomp.FirstCompMain then FirstComp:= 'main' else FirstComp:= '0';

  lth:= -1;
  SetLength(Result, 0);
  LastCommand:= -1;

  if ScriptLen > 1 then begin

    if (ScriptLen < 2)
    or (Byte(BinaryScript[ScriptLen]) <> lmEND)                  //skip adding main COMPO
    or (Byte(BinaryScript[ScriptLen-1]) = lmEND_COMP) then begin //if there is no END_COMPO before END
      AddTransCommand(Result, lth, 32, 0, ctVirtual, -1, 0, FirstComp); //first COMPORTMENT
      AddCompToList(CompList, 0, FirstComp); //save Life Trans Table index of the COMPORTMENT
    end;

    //Reading script into the transitional variable
    repeat
      Opcode:= Byte(BinaryScript[Offset]);

      while (osh > -1) and (Offset - 1 >= OffsetStack[osh]) do begin  //add ENDIFs if necessary
        AddTransCommand(Result, lth, lmENDIF, Offset-1, ctVirtual, 0, 0, '');
        Dec(osh);
      end;
      //while (dsh > -1) and (Offset - 1 >= SwDefStack[dsh]) do begin //add DEFAULT if necessary
      {if (Offset - 1 >= SwDefAddr) and (SwDefAddr < SwEndAddr) then begin
        AddTransCommand(Result, lth, ls2DEFAULT, Offset-1, ctVirtual, 0, 0, '');
        //Dec(dsh);
        SwDefAddr:= $FFFF;
      end;}
      {if ScrSet.Decomp.AddEND_SWITCH then begin //hard to implement (if there are nested SWITCHes without END_SWITCH)
        while (ssh > -1) and (Offset - 1 >= SwEndStack[ssh]) do begin //add END_SWITCH if necessary
        //if (Offset - 1 >= SwEndAddr) and (Opcode <> ls2END_SWITCH) then begin
          if Opcode <> ls2END_SWITCH then //only if there is no original END_SWITCH
            AddTransCommand(Result, lth, ls2END_SWITCH, Offset-1, ctVirtual, 0, 0, '');
          Dec(ssh);
          //SwEndAddr:= $FFFF;
        end;
      end; }

      Inc(Offset);

      if (Previous in [ctCommand, ctOperator]) and (OpCode = lmEND) then
        Finish:= True;

      Inc(lth);
      SetLength(Result, lth + 1);

      Result[lth].Code:= OpCode;
      Result[lth].Offset:= Offset - 2; //-1 for String index starts with 1
                                       //and -1 for the Offset is increased after reding opcode
      case Previous of
        ctCommand,
        ctOperator,    //after an operator there must be a Command or IF
        ctSwVar: begin
          //if (Previous = ctSwVar)
          //and (OpCode <> ls2CASE) and (OpCode <> ls2OR_CASE) then
          //  Result[lth].Error:= derrLifeCaseExp;
          LastCommand:= OpCode;
          if not CheckOpCode(Result[lth], ctCommand) then begin
            //Finish:= True; //TODO: return False
            Break;
          end;
          Result[lth].cType:= LifeProps[OpCode].cType;
          Result[lth].Flags:= LifeProps[OpCode].Flags;
          Result[lth].ParCount:= LifeProps[OpCode].ParCount;
          if Result[lth].ParCount = -1 then begin
            Result[lth].ParamStr:= ExtractCStrFromStr(BinaryScript, Offset);
            Inc(Offset, Length(Result[lth].ParamStr) + 1); //+1 for the #0 at the cstring end
          end
          else begin
            for a:= 0 to Result[lth].ParCount - 1 do begin
              Result[lth].Params[a]:=
                Integer(ReadValFromBinStr(BinaryScript, Offset, LifeProps[OpCode].ParSize[a]));
              FixSignedValue(Result[lth].Params[a], LifeProps[OpCode].ParSize[a],
                             LifeProps[OpCode].ParRng[a]^);
              Inc(Offset, LifeProps[OpCode].ParSize[a]);
            end;
            if OpCode in [lmSET_DIRM, lmSET_DIRM_OBJ] then begin
              if Result[lth].Params[Result[lth].ParCount-1] in DirmReqObj
              then begin
                Result[lth].Params[2]:= Byte(BinaryScript[Offset]);
                Inc(Offset);
              end;
            end else if OpCode = lmELSE then begin
              if osh > -1 then
                OffsetStack[osh]:= Result[lth].Params[0]; //fix ENDIF position
            end else if OpCode in CaseMacros then begin
              if SwVarProp.RetSize >= 0 then begin
                Result[lth].Params[2]:= //third param size depends on the SWITCH variable
                  Integer(ReadValFromBinStr(BinaryScript, Offset, SwVarProp.RetSize));
                  FixSignedValue(Result[lth].Params[2], SwVarProp.RetSize,
                                 SwVarProp.RetRange^);
                Inc(Offset, SwVarProp.RetSize);
              end else
                Result[lth].Error:= derrCaseNoSwitch;
            end;
          end;
        end;

        ctIf: begin //previous was IF (or SWITCH) -> current must be a variable (condition)
          if not CheckOpCode(Result[lth], ctVariable) then begin
            //Finish:= True; //TODO: return False
            Break;
          end;
          if LastCommand = lmSWITCH then begin
            Result[lth].cType:= ctSwVar;
            //Inc(svh);
            //SetLength(SwVarProp, svh + 1);
            SwVarProp:= VarProps[OpCode];
          end else
            Result[lth].cType:= ctVariable;
          Result[lth].Flags:= VarProps[OpCode].Flags;
          Result[lth].ParCount:= IfThen(VarProps[OpCode].HasParam, 1, 0);
          if VarProps[OpCode].HasParam then begin //max one param (and single-byte only)
            Result[lth].Params[0]:= Byte(BinaryScript[Offset]);
            Inc(Offset);
          end;
        end;

        //Operators are handled like regular commands. After the operator code there is
        // an operand value, which is handled like a parameter.
        //The address to go to if condition was false is after the operator param
        // and is handled as a second parameter of the operator.
        ctVariable: begin //previous was Variable -> current must be an Operator
          if not CheckOpCode(Result[lth], ctOperator) then begin
            //Finish:= True; //TODO: return False
            Break;
          end;
          VarCode:= Result[lth-1].Code;
          Result[lth].cType:= ctOperator;
          Result[lth].Flags:= [];
          Result[lth].ParCount:= 2; //param1: operand, param2: address for false
          Result[lth].Params[0]:=
            Integer(ReadValFromBinStr(BinaryScript, Offset,
              VarProps[VarCode].RetSize));
          FixSignedValue(Result[lth].Params[0], VarProps[VarCode].RetSize,
                         VarProps[VarCode].RetRange^);
          Inc(Offset, VarProps[VarCode].RetSize);
          Result[lth].Params[1]:= ReadWordFromBinStr(BinaryScript, Offset);
          Inc(Offset, 2);
          if not (lastCommand in OrAndIf) //Neither OR_IF, nor AND_IF
          and ((lth <= 4)
            or (Result[lth-5].Code <> lmOR_IF) //previous IF type
            or (Result[lth-3].Params[1] <= Result[lth].Params[1]))
          then begin
            Inc(osh);
            if High(OffsetStack) < osh then SetLength(OffsetStack, osh + 1);
            OffsetStack[osh]:= Result[lth].Params[1]; //record the offset to put ENDIF to
          end;
        end;

      end;

      Previous:= Result[lth].cType;

      if (Previous = ctCommand) and (OpCode = lmEND_COMP)
      and (Offset < Length(BinaryScript))
      and (osh < 0) then begin //and we are not inside an IF-ELSE-ENDIF block
        Inc(Comportment); //next COMPORTMENT begins after END_COMPORTMENT
        AddTransCommand(Result, lth, 32, Offset-2, ctVirtual, -1, 0, IntToStr(Comportment));
        AddCompToList(CompList, Offset - 1, IntToStr(Comportment)); //save Life Trans Table index of the COMPORTMENT
      end;

      if (Offset > ScriptLen) and (not Finish) then begin
        Inc(lth);
        SetLength(Result, lth + 1);
        Result[lth].cType:= ctError;
        Result[lth].Error:= derrNoEND;
        Finish:= True;
      end;

    until Finish;

    if ScriptLen >= Offset then begin
      Inc(lth);
      SetLength(Result, lth + 1);
      Result[lth].cType:= ctError;
      Result[lth].Error:= derrCodeAfterEnd;
      Result[lth].ParamStr:= Copy(BinaryScript, Offset, 10);
    end;

  end;

  if (lth < 0) or (Result[lth].Code <> lmEND) then
    AddTransCommand(Result, lth, lmEND, 0, ctCommand, 0, 0, '');
end;

procedure LifeDecompResolveOffsets(var Trans: array of TTransTable;
  TrackHashes: array of TWordDynAr; CompLists: array of TStrDynAr);
var a, b, c, d, e, AComp, blh: Integer;
    temp: String;
    OpCode: Byte;
    BREAKList: array of Word;
begin
  blh:= -1;
  SetLength(BREAKList, 0);

  //First insert additional COMPORTMENTs (one of the original code weirdnesses)
  for a:= 0 to High(Trans) do begin //for all Actors
    AComp:= 1;
    for b:= High(Trans[a]) downto 0 do begin //for all commands in the Actor's Script
      if Trans[a,b].cType = ctCommand then begin //exclude conditions and operators
        OpCode:= Trans[a,b].Code;
        if OpCode = lmSET_COMP then begin  //replace (virtual) COMPORTMENT offsets with their names
          c:= Trans[a,b].Params[0];
          If (c <> -1) //except special case
          and ((c > High(CompLists[a])) or (CompLists[a,c] = '')) then
            for e:= 0 to High(Trans[a]) do
              If Trans[a,e].Offset = c then begin
                temp:= 'inserted_' + IntToStr(AComp);
                InsertTransCommand(Trans[a], e, lmCOMP, c, ctVirtual,
                  -1, 0, temp);
                AddCompToList(CompLists[a], c, temp);
                Inc(AComp);
                Break;
              end
              else if Trans[a,e].Offset > c then begin
                Trans[a,b].Error:= derrNoComAddr;
                Break;
              end;
        end
        else if OpCode = lmSET_COMP_OBJ then begin //as above, but for all Actors
          c:= Trans[a,b].Params[1];
          d:= Trans[a,b].Params[0];
          If d < Length(CompLists) then begin
            If (c <> -1) //except special case
            and ((c > High(CompLists[d])) or (CompLists[d,c] = '')) then
              for e:= 0 to High(Trans[d]) do
                If Trans[d,e].Offset = c then begin
                  temp:= 'inserted_' + IntToStr(AComp);
                  InsertTransCommand(Trans[d], e, lmCOMP, c, ctVirtual,
                    -1, 0, temp);
                  AddCompToList(CompLists[d], c, temp);
                  Inc(AComp);
                  Break;
                end
                else if Trans[d,e].Offset > c then begin
                  Trans[a,b].Error:= derrNoComAddr;
                  Break;
                end;
          end else
            Trans[a,b].Error:= derrCompNoActor;
        end;
      end;
    end;
  end;

  //Then we can perform the resolving
  for a:= 0 to High(Trans) do begin //for all Actors
    blh:= -1;

    for b:= 0 to High(Trans[a]) do begin //for all commands in the Actor's Script

      if Trans[a,b].cType = ctCommand then begin //exclude conditions and operators

        OpCode:= Trans[a,b].Code;
        if OpCode = lmSET_TRACK then begin  //replace LABEL offsets with their indexes
          c:= Trans[a,b].Params[0];
          if c <> -1 then begin //except special case
            If (c <= High(TrackHashes[a])) and (TrackHashes[a,c] > 0) then
              Trans[a,b].Params[0]:= TrackHashes[a,c] - 1
            else
              Trans[a,b].Error:= derrLifeNoTrack;
          end;
        end
        else if OpCode = lmSET_TRACK_OBJ then begin  //as above, but for all Actors
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
        end
        else if OpCode = lmSET_COMP then begin  //replace (virtual) COMPORTMENT offsets with their names
          c:= Trans[a,b].Params[0];
          if c = -1 then begin //special case
            Trans[a,b].ParamStr:= 'break';
            Trans[a,b].ParCount:= -1; //to display string param instead of int
          end else begin
            If (c <= High(CompLists[a])) and (CompLists[a,c] <> '') then begin
              Trans[a,b].ParamStr:= CompLists[a,c];
              Trans[a,b].ParCount:= -1; //to display string param instead of int
            end
            else
              Trans[a,b].Error:= derrLifeNoComp;
          end;
        end
        else if OpCode = lmSET_COMP_OBJ then begin //as above, but for all Actors
          c:= Trans[a,b].Params[1];
          d:= Trans[a,b].Params[0];
          if d < Length(CompLists) then begin
            if c = -1 then begin //special case
              Trans[a,b].ParamStr:= 'break';
              Trans[a,b].ParCount:= -2; //to display 2nd param as string instead of int
            end else begin
              If (c <= High(CompLists[d])) and (CompLists[d,c] <> '') then begin
                Trans[a,b].ParamStr:= CompLists[d,c];
                Trans[a,b].ParCount:= -2; //to display 2nd param as string instead of int
              end
              else
                Trans[a,b].Error:= derrLifeNoComp;
            end;
          end
          else
            Trans[a,b].Error:= derrCompNoActor;
        end
        else if OpCode = lmBREAK then begin
          //BREAKs poinitng to another BREAK instead of END_SWITCH
          if (b < High(Trans[a])) and (b > 0)
          and (Trans[a,b-1].Code <> lmBREAK) and (Trans[a,b+1].Code = lmEND_SWITCH) then begin
            for c:= 0 to blh do
              if (Trans[a,BREAKList[c]].Params[0] = Trans[a,b].Offset) //a previous BREAK points to this one
              then
                Trans[a,BREAKList[c]].ParamStr:= 'mod'; //modified BREAK (special case)
          end;
          Inc(blh);
          if High(BREAKList) < blh then SetLength(BREAKList, blh + 1);
          BREAKList[blh]:= b;
        end;

      end;
    end;
  end;
end;

function LifeDecompTransToString(Trans: TTransTable; Actor: Integer): String;
var a, b, Indent, IndentSingle{, LastCond, LastCommand}: Integer;
    IndentStack: array of Integer; //for IFs only
    ish: Integer;
    IndentSwitch: array of Integer; //Stack required for nested SWITCH
    //IndentCase: array of Integer;
    iswh: Integer;
    //DirMode: Byte;
    Line: TStrDynAr;
    Flags: TDecTxtFlags;
    OpCode: Byte;
begin
  Result:= '';

  ish:= -1;
  SetLength(IndentStack, 0);

  iswh:= -1;
  SetLength(IndentSwitch, 0);
  //SetLength(IndentCase, 0);

  Indent:= 0;
  //IndentCase:= 0;
  //IndentSwitch:= 0;
  //LastCond:= 0;
  //LastCommand:= 0;
  for a:= 0 to High(Trans) do begin

    OpCode:= Trans[a].Code;

    Flags:= [];
    if (Trans[a].cType = ctOperator) and (a >= 2) then begin
      if Trans[a-1].Code = lvBEHAV then
        Flags:= [dtCmpBehav];
      if vfCmpActor in Trans[a-1].Flags then
        Flags:= Flags + [dtCmpActor];
      {$ifdef DECOMP_DEBUG}
        if Trans[a-2].Code in IfMacros then
          Flags:= Flags + [dtIfType];
      {$endif}
    end;

    Line:= LifeTransCmdToStrings(Trans[a], Flags, Actor);

    //pre-command indentation set
    IndentSingle:= 0;
    if Trans[a].cType in [ctCommand, ctVirtual, ctIf] then begin
      if ScrSet.Decomp.IndentLife then begin
        if OpCode in IfMacros then begin
          Inc(ish);
          if High(IndentStack) < ish then SetLength(IndentStack, ish + 1);
          IndentStack[ish]:= Indent;
        end
        else if OpCode = lmENDIF then begin
          if ish >= 0 then begin
            Indent:= IndentStack[ish];
            Dec(ish);
          end;
        end
        else if OpCode = lmCOMP then
          Indent:= 0
        else if OpCode = lmELSE then begin
          if ish >= 0 then
            IndentSingle:= IndentStack[ish] - Indent //temporarily at the last indent stack pos
          else
            IndentSingle:= -2;
        end
        else if OpCode = lmSWITCH then begin
          Inc(iswh);
          if High(IndentSwitch) < iswh then SetLength(IndentSwitch, iswh + 1);
          IndentSwitch[iswh]:= Indent;
        end
        else if OpCode = lmEND_SWITCH then begin
          if iswh >= 0 then begin
            Indent:= IndentSwitch[iswh];
            Dec(iswh);
          end;
        end
        else if OpCode = lmEND_COMP then
          Indent:= 0;
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
          if Trans[a].Code in IndentPost
          then
            Inc(Indent, 2)
          else if Trans[a].Code = lmBREAK then
            Dec(Indent, 2)
        end;
        if Trans[a].cType <> ctIf then //ctCommand and ctDummy
          Result:= Result + CR;
      end;
      ctVariable, ctSwVar: begin
        if (a >= 1) and (Trans[a-1].Code = lmSWITCH) then
          Result:= Result + CR;
      end;
      ctOperator:
        Result:= Result + CR;
    end;


    (*case Trans[a].cType of
      ctError: begin
        Result:= Result + '[error ' + IntToStr(Ord(Trans[a].Error)) + ']'
               + ' //' + DecompErrorString[Ord(Trans[a].Error)];
        if Trans[a].Error = derrBadOpcode then
          Result:= Result + Format(' (code: 0x%.2X, expected: %s, offset: 0x%.4X)',
                   [Trans[a].Code, CmdTypeString[Trans[a].cType], Trans[a].Offset])
        else if Trans[a].Error = derrCodeAfterEnd then begin
          Result:= Result + ' (';
          for b:= 1 to Length(Trans[a].ParamStr) do
            Result:= Result + Format('%.2X ', [Byte(Trans[a].ParamStr[b])]);
          Delete(Result, Length(Result), 1);
          Result:= Result + ')';
        end;
        Result:= Result + CR;
      end;

      ctCommand, ctVirtual, ctIf:
      begin //IFs are displayed in the same way as Commmands (only without params)

        LastCommand:= Trans[a].Code;

        if Debug then Result:= Result + IntToStr(Trans[a].Offset) + ':' + TAB;

        IndentSingle:= 0;
        if ScrSet.Decomp.IndentLife then begin
          case Trans[a].Code of
            ls2IF, ls2SWIF, ls2ONEIF, ls2NEVERIF, ls2SNIF: begin
              Inc(ish);
              if High(IndentStack) < ish then SetLength(IndentStack, ish + 1);
              IndentStack[ish]:= Indent;
            end;
            ls2ENDIF:
              if ish >= 0 then begin
                Indent:= IndentStack[ish];
                Dec(ish);
              end;
            ls2COMPORTMENT: Indent:= 0;
            ls2ELSE:
              if ish >= 0 then
                IndentSingle:= IndentStack[ish] - Indent //temporarily at the last indent stack pos
              else
                IndentSingle:= -2;
            ls2SWITCH: begin
              Inc(iswh);
              if High(IndentSwitch) < iswh then SetLength(IndentSwitch, iswh + 1);
              IndentSwitch[iswh]:= Indent;
              //SetLength(IndentCase, iswh + 1);
              //IndentCase[iswh]:= 0;
            end;
            ls2END_SWITCH: begin
              if iswh >= 0 then begin
                Indent:= IndentSwitch[iswh];
                Dec(iswh);
              end;
            end;
            ls2END_COMPORTMENT:
              Indent:= 0;
              //if (a < High(Trans)) and (Trans[a+1].Code in [ls2COMPORTMENT, ls2END]) then
              //  Dec(Indent, 2);
            ls2CASE, ls2OR_CASE, ls2DEFAULT:
              {if IndentCase[iswh] = 0 then
                IndentCase[iswh]:= Indent //store indent of the first CASE
              else
                Indent:= IndentCase[iswh];}
              //if (a > 0) and (not (Trans[a-1].cType in [ctSwVar, ctOperator])) then //not right after SWITCH or IF
              //  Dec(Indent, 2);
          end;
        end;

        Result:= Result + StringOfChar(' ', Indent + IndentSingle);

        if Trans[a].Error <> derrNoError then
          Result:= Result + '[error ' + IntToStr(Ord(Trans[a].Error)) + ']';

        if ScrSet.Decomp.UpperCase then
          Result:= Result + Life2List[Trans[a].Code]
        else
          Result:= Result + LowerCase(Life2List[Trans[a].Code]);

        if cfBehav in Trans[a].Flags then begin //BEHAVIOUR (always has a param)
          if Trans[a].Params[0] <= lbh2MAX_OPCODE then begin
            if ScrSet.Decomp.UpperCase then
              Result:= Result + ' ' + Behaviour2List[Trans[a].Params[0]]
            else
              Result:= Result + ' ' + LowerCase(Behaviour2List[Trans[a].Params[0]]);
          end else
            Result:= Result + ' Bad behaviour mode: ' + IntToStr(Trans[a].Params[0]);
        end
        else if Trans[a].Code in [ls2SET_DIRMODE, ls2SET_DIRMODE_OBJ] then begin
          if Trans[a].Code = ls2SET_DIRMODE_OBJ then
            Result:= Result + ' ' + IdToStrOrSelf(Trans[a].Params[0], Actor); //OBJ ID
          DirMode:= Byte(Trans[a].Params[Trans[a].ParamCount-1]);
          if ScrSet.Decomp.UpperCase then
            Result:= Result + ' ' + DirMode2List[DirMode]
          else
            Result:= Result + ' ' + LowerCase(DirMode2List[DirMode]);
          if DirMode in [ldm2FOLLOW, ldm2SAME_XZ, ldm2DIRMODE9] then
            Result:= Result + ' ' + IntToStr(Trans[a].Params[2]);
        end
        else if Trans[a].Code in [ls2CASE, ls2OR_CASE] then begin
          Result:= Result + ' ' + OperatorList[Trans[a].Params[1]] + ' '; //IntToStr(Trans[a].Params[1])
          Result:= Result + IntToStr(Trans[a].Params[2]);
          if Debug then begin
            if Trans[a].Code = ls2CASE then
              Result:= Result + ' _else';
            Result:= Result + ' goto ' + IntToStr(Trans[a].Params[0]);
          end;
        end
        //else if Trans[a].Code = lsv2REAL_ANGLE then begin

        //end
        else begin
          if Trans[a].ParamCount = -1 then
            Result:= Result + ' ' + Trans[a].ParamStr
          else if Trans[a].ParamCount = -2 then //SET_COMP_OBJ only so far
            Result:= Result + ' ' + IdToStrOrSelf(Trans[a].Params[0], Actor) //first number
                            + ' ' + Trans[a].ParamStr            //and second text
          else begin
            if Trans[a].Code in [ls2ELSE, ls2BREAK] then begin
              if Debug then
                Result:= Result + ' goto ' + IntToStr(Trans[a].Params[0]);
            end else
              for b:= 0 to Trans[a].ParamCount - 1 do begin
                if (b = 0) and (cfP1Actor in Trans[a].Flags) then
                  Result:= Result + ' ' + IdToStrOrSelf(Trans[a].Params[b], Actor)
                else
                  Result:= Result + ' ' + IntToStr(Trans[a].Params[b]);
              end;
          end;
        end;

        if ScrSet.Decomp.IndentLife then begin
          if Trans[a].Code in [ls2IF, ls2SWIF, ls2ONEIF, ls2NEVERIF, ls2SNIF,
                               ls2COMPORTMENT,
                               ls2SWITCH, ls2CASE, ls2DEFAULT]
          then
            Inc(Indent, 2)
          else if Trans[a].Code = ls2BREAK then begin
            Dec(Indent, 2)
            //if iswh >= 0 then
            //  Indent:= IndentSwitch[iswh]; //in case of missing END_SWITCH, otherwise it will be corrected by the next command
          end;
          //if Trans[a].Code = ls2SWITCH then
          //  Inc(Indent, 2); //additionally, because SWITCH is ctIf
        end;

        if Trans[a].cType <> ctIf then begin //ctCommand and ctDummy
          if Trans[a].Error <> derrNoError then
            Result:= Result + ' //' + DecompErrorString[Ord(Trans[a].Error)];
          Result:= Result + CR;
        end;
      end;

      ctVariable, ctSwVar: begin
        if not CheckBadOpcode(Trans[a], Result) then begin
          LastCond:= Trans[a].Code;
          if ScrSet.Decomp.UpperCase then
            Result:= Result + ' ' + Var2List[Trans[a].Code]
          else
            Result:= Result + ' ' + LowerCase(Var2List[Trans[a].Code]);
          if Trans[a].ParamCount > 0 then begin  //max one param
            if vfParActor in Trans[a].Flags then
              Result:= Result + ' ' + IdToStrOrSelf(Trans[a].Params[0], Actor)
            else
              Result:= Result + ' ' + IntToStr(Trans[a].Params[0]);
          end;
          if LastCommand = ls2SWITCH then
            Result:= Result + CR;
        end;
      end;

      ctOperator: begin
        if not CheckBadOpcode(Trans[a], Result) then begin
          Result:= Result + ' ' + OperatorList[Trans[a].Code] + ' ';
          if LastCond = lsv2BEHAVIOUR then begin
            if Trans[a].Params[0] <= lbh2MAX_OPCODE then begin
              if ScrSet.Decomp.UpperCase then
                Result:= Result + Behaviour2List[Trans[a].Params[0]]
              else
                Result:= Result + LowerCase(Behaviour2List[Trans[a].Params[0]]);
            end else
              Result:= Result + 'Bad behaviour mode: ' + IntToStr(Trans[a].Params[0]);
          end
          else begin
            if vfCmpActor in Trans[a-1].Flags then
              Result:= Result + IdToStrOrSelf(Trans[a].Params[0], Actor)
            else
              Result:= Result + IntToStr(Trans[a].Params[0]);
          end;
          if Debug then begin
            if LastCommand in [ls2IF, ls2SNIF, ls2SWIF, ls2ONEIF, ls2NEVERIF, ls2AND_IF]
            then
              Result:= Result + ' _else';
            Result:= Result + ' goto ' + IntToStr(Trans[a].Params[1]);
          end;
          Result:= Result + CR;
        end;
      end;
    end;*)

  end;
end;

function LifeTransCmdToStrings(Cmd: TTransCommand; Flags: TDecTxtFlags; Actor: Integer = -1): TStrDynAr;
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
        Result[rh]:= FixCase(LifeList[Cmd.Code]);

        if Cmd.Code = lmSET_BEHAV then begin //param from the behav list
          Inc(rh);
          SetLength(Result, rh + 1);
          Param0:= Cmd.Params[0];
          if Param0 <= lbMAX_OPCODE then
            Result[rh]:= FixCase(BehavList[Param0])
          else
            Result[rh]:= '(Bad behaviour mode: ' + IntToStr(Param0) + ')';
        end
        else if Cmd.Code in [lmSET_DIRM, lmSET_DIRM_OBJ] then begin
          if Cmd.Code = lmSET_DIRM_OBJ then begin
            Inc(rh);
            SetLength(Result, rh + 1);
            Result[rh]:= IdToStrOrSelf(Cmd.Params[0], Actor); //OBJ ID
          end;
          DirMode:= Byte(Cmd.Params[Cmd.ParCount-1]);
          Inc(rh);
          SetLength(Result, rh + 1);
          if DirMode <= ldMAX_OPCODE then
            Result[rh]:= FixCase(DirModeList[DirMode])
          else
            Result[rh]:= '(Bad dir mode: ' + IntToStr(DirMode) + ')';
          if DirMode in DirmReqObj then begin //another patram
            Inc(rh);
            SetLength(Result, rh + 1);
            Result[rh]:= IntToStr(Cmd.Params[2]);
          end;
        end
        else if Cmd.Code in CaseMacros then begin
          Inc(rh, 2);
          SetLength(Result, rh + 1);
          Result[rh-1]:= OperDecompList[Cmd.Params[1]]; //IntToStr(Trans[a].Params[1])
          Result[rh]:=   IntToStr(Cmd.Params[2]);
          {$ifdef DECOMP_DEBUG}
            Inc(rh);
            SetLength(Result, rh + 1);
            Result[rh]:= '(';
            if Cmd.Code = lmCASE then Result[rh]:= Result[rh] + 'else ';
            Result[rh]:= Result[rh] + 'goto ' + IntToStr(Cmd.Params[0]) + ')';
          {$endif}
        end
        else begin //regular commands
          if Cmd.ParCount = -1 then begin //string param
            Inc(rh);
            SetLength(Result, rh + 1);
            Result[rh]:= Cmd.ParamStr;
          end
          else if Cmd.ParCount = -2 then begin //first number, second text, SET_COMP_OBJ only so far
            Inc(rh, 2);
            SetLength(Result, rh + 1);
            Result[rh-1]:= IdToStrOrSelf(Cmd.Params[0], Actor); //first number
            Result[rh]:=   Cmd.ParamStr;                        //and second text
          end else begin //number params
            if (Cmd.Code = lmBREAK) and (Cmd.ParamStr <> '') then begin //special modified BREAKs
              Inc(rh);
              SetLength(Result, rh + 1);
              Result[rh]:= Cmd.ParamStr;
            end;
            if Cmd.Code in [lmELSE, lmBREAK] then begin
              {$ifdef DECOMP_DEBUG}
                Inc(rh);
                SetLength(Result, rh + 1);
                Result[rh]:= '(goto ' + IntToStr(Cmd.Params[0]) + ')';
              {$endif}
            end else begin
              for b:= 0 to Cmd.ParCount - 1 do begin
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
        Result[rh]:= FixCase(VarList[Cmd.Code]);
        if Cmd.ParCount > 0 then begin  //max one param
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
        Result[rh]:= OperDecompList[Cmd.Code];
        Inc(rh);  //operator always has at least one param (comparison value)
        SetLength(Result, rh + 1);
        if dtCmpBehav in Flags then begin
          if Cmd.Params[0] <= lbMAX_OPCODE then
            Result[rh]:= FixCase(BehavList[Cmd.Params[0]])
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
