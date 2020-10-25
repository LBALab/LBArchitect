{$I DFS.INC}

unit CBtnReg;

interface

procedure Register;

implementation

uses
  DFSClrBn, ColorAEd, CBtnForm, DFSAbout, DesignIntf, Classes;


procedure Register;
begin
  RegisterComponents('DFS', [TdfsColorButton]);
  RegisterPropertyEditor(TypeInfo(TColorArrayClass), NIL, '',
     TColorArrayProperty);
  RegisterPropertyEditor(TypeInfo(string), TdfsColorButton, 'Version',
     TdfsVersionProperty);
end;


end.
