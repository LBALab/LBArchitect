program LineStippling_Ex;

uses
  Interfaces,
  Forms,
  SysUtils,
  GR32_L,
  MainUnit in 'MainUnit.pas' {FormLineStippling};

begin
  Application.Title:='Line Stippling';
  Application.Initialize;
  Application.CreateForm(TFormLineStippling, FormLineStippling);
  Application.Run;
end.
