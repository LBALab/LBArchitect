TSynLifeSciptHL   {first Identifier is considered to be the Class Name }
tk              {second Identifier is considered to be the Identifier Prefix }
IdentStart '_', 'a'..'z', 'A'..'Z':: '_', '0'..'9', 'a'..'z', 'A'..'Z'::

TOKENTYPES
Comment Style=[fsItalic]|Foreground=clTeal
Space
Label Foreground=clNavy
Key Style=[fsBold]
Command
Statement Foreground=clGreen|Style=[fxBold]
Number Foreground=clMaroon
Condition Foreground=clBlue
|><|

KEYS
IF
ONEIF
ELSE
ENDIF
OR_IF
SWIF
|><|

KEYS Statement
COMPORTEMENT
END_COMPORTEMENT
END
|><|

CHARS

'A'..'Z', 'a'..'z', '_':: Ident
BeginProc
  fTokenID := IdentKind((fLine + Run));
  inc(Run, fStringLen);
  while Identifiers[fLine[Run]] do
    Inc(Run);
EndProc

|><|

ENCLOSEDBY

Comment,BraceComment,{,},MultiLine
Comment,CStyleComment,/*,*/,MultiLine
Comment,DelphiComment,(*,*),MultiLine
Comment,CStyleSingleLine,//

|><|

SAMPLESOURCE

|><|

